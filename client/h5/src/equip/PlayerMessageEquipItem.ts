import { BaseItem1 } from "../common/BaseItem1";
import { EquipmentItem } from "../common/EquipmentItem";
import { UIToolTipMgr } from "../common/UIToolTipMgr";
import { EquipModel, EquipEvent } from "../commonModel/EquipModel";
import { FriendModel, FriendEvent } from "../commonModel/FriendModel";
import { GoodsModel } from "../commonModel/GoodsModel";
import { RoleManager } from "../commonModel/RoleManager";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { Status } from "../util/Status";

export class PlayerMessageEquipItem extends BaseItem1 {
	private level: Laya.Label;
	private tips: Laya.Label;
	private grade: Laya.Label;
	private award_con: Laya.Box;
	private select_img: Laya.Image;
	private lock_icon: Laya.Image;
	private red_dot: Laya.Image;
	private group_eff: Laya.Box;
	public icon_bg: Laya.Image;
	scaleGp: Laya.Box
	_img_add: Laya.Image


	private model = EquipModel.GetInstance()

	private data;
	private role_id;
	private ser_id = 0;
	private equip_type;
	private award_item: EquipmentItem;
	private data_callback: Function;
	private refresh_data: boolean;
	private attr_cfg;
	private limit_cfg;
	private god_equip_kv_cfg
	private attr_list;
	private click = false;

	public constructor(parent) {
		super(parent)
		let self = this;
		self.base_file = "equipCom"
		self.layout_file = "PlayerMessageEquipItem"
		self.load_callback = function () {
			self.LoadSuccess()
			self.InitEvent()
		}
	}

	public DeleteMe() {
		let self = this;
		if (self.award_item) {
			self.award_item.DeleteMe()
		}
		super.DeleteMe()
	}

	public InitEvent() {
		let self = this;
		self.BindEvent(self.model, EquipEvent.WEAR_SUCCESS, (info) => {
			if (self.equip_type == info.cell_pos) {
				self.UpdateEffect()
			}
		})

		self.BindEvent(GlobalEventSystem, GoodsModel.CHANGE_GOODS_DYNAMIC, (id) => {
			if (!self.data) return;
			let goods_id = self.data.goods_id;
			if (goods_id == id && self.click) {
				let vo = GoodsModel.GetInstance().GetDynamic(id, null, false, true);
				self.showTips(vo);
				return;
			}
		});
	}

	public LoadSuccess() {
		let self = this;
		if (self.equip_type) {
			self.lock_icon.skin = "resource/game/equipCom/texture/role_default_" + self.equip_type + ".png"
		}
		if (self.refresh_data) {
			self.SetData(self.data, self.role_id, self.ser_id)
		}

		if (self.data_callback) {
			self.data_callback()
		}


	}

	public SetEquipPos(equip_type) {
		this.equip_type = equip_type
	}

	public SetCfgs(...cfgs) {
		[this.limit_cfg, this.attr_cfg,this.god_equip_kv_cfg] = cfgs
	}

	public SetData(data, role_id, ser_id?) {
		let self = this;
		self.data = data
		self.role_id = role_id
		self.ser_id = ser_id
		if (!self.is_loaded) {
			self.refresh_data = true
			return
		}

		if (self.award_item){
			if(data!=null){
				self.award_item.SetVisible(true)
			}else{
				self.award_item.SetVisible(false)
			}
		}
		self.icon_bg.visible = data == null

		if (!self.attr_cfg || !self.limit_cfg || !self.data) return

		self.attr_list = self.attr_cfg
		let grade = self.attr_list ? self.attr_list.stage : 0
		self.UpdateAwardItem(data, grade, role_id)
	}

	public UpdateAwardItem(data, grade, role_id) {
		let self = this;
		if (!self.award_item) {
			self.award_item = new EquipmentItem(self.award_con);
			self.award_item.Load();
			self.award_item.SetItemSize(78,78)
		}
		// self.award_item.ExcuteCallback(() => {
		// 	if (EquipModel.GetInstance().otherFullGodEquip(data))
		// 		self.award_item.SetData(data.type_id, null, null, null, null, null, null, null, null, null, data.god_level);
		// 	else
		// 		self.award_item.SetData(data.type_id);
		// })
		if (EquipModel.GetInstance().otherFullGodEquip(data,this.god_equip_kv_cfg)){
			self.award_item.SetData(data.type_id, null, null, null, null, null, null, null, null, null, data.god_level);
		}
		else{
			self.award_item.SetData(data.type_id);
		}
		self.award_item.SetClickCallBack(() => {
			self.click = true;
			let show = false;
			let vo = GoodsModel.GetInstance().GetDynamic(data.goods_id, null, false, true);
			if (self.role_id == RoleManager.GetInstance().GetMainRoleId()) {
				if (!vo)
					GoodsModel.GetInstance().GetDynamic(data.goods_id, null, true, false);
				else
					show = true;
			} else {
				let time = FriendModel.GetInstance().getEquipRequestTime(data.goods_id, self.role_id);
				if (!vo || !time || Status.NowTime - time >= 3) {
					FriendModel.GetInstance().equipRequestTime(data.goods_id, self.role_id, Status.NowTime);
					let server_id = RoleManager.GetInstance().GetMainRoleVo().server_id;
					if (self.ser_id != 0 && self.ser_id != server_id)
						FriendModel.GetInstance().Fire(FriendEvent.REQUEST_KUAFU_GOODS_MESSAGE, self.ser_id, role_id, data.goods_id)
					else
						GoodsModel.GetInstance().Fire(GoodsModel.REQUEST_GOODS_DYNAMIC, data.goods_id, role_id, true);
				}
				else
					show = true;
			}
			if (show)
				self.showTips(vo);
		})
	}

	private showTips(vo) {
		let self = this;
		// if (EquipModel.GetInstance().otherFullGodEquip(self.data))
		if (this.data && this.data.god_level > 0)
			UIToolTipMgr.GetInstance().AppendEquipTips(vo.type_id, null, null, vo, this.role_id, null, this.data.god_level);
		else
			UIToolTipMgr.GetInstance().AppendEquipTips(vo.type_id, null, null, vo, this.role_id);
		this.click = false;
	}

	public UpdateEffect() {
		// this.AddUIEffect("ui_Strengthen_glow", this.group_eff)
	}


	public GetComponents() {
		[
			this.scaleGp,
			this.icon_bg,
			this.lock_icon,
			this._img_add,
			this.award_con,
			this.level,
			this.grade,
			this.red_dot,
			this.group_eff,
		]
			= this.GetChildrenByNames([

				"scaleGp",
				"icon_bg",
				"lock_icon",
				"_img_add",
				"award_con",
				"level",
				"grade",
				"red_dot",
				"group_eff",
			])
	}
}

window["PlayerMessageEquipItem"] = PlayerMessageEquipItem
import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItem1 } from "../common/BaseItem1"
import { EquipmentItem } from "../common/EquipmentItem"
import { MaterialsTool } from "../common/MaterialsTool"
import { ResManager } from "../common/ResManager"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { EquipModel, EquipEvent, EquipDefine } from "../commonModel/EquipModel"
import { Message } from "../sysInfo/SysInfoController"
import { Util, SetAnchoredPosition } from "../util/Util"

export class EquipmentIcon extends BaseItem1 {
	public scaleGp: Laya.Box;
	public icon_bg: Laya.Image;
	public lock_icon: Laya.Image;
	public _img_add: Laya.Image;
	public award_con: Laya.Box;
	public red_dot: Laya.Image;
	public group_eff: Laya.Box;


	data
	model: EquipModel
	equip_type
	attr_cfg
	refresh_data
	data_callback
	attr_list
	award_item
	limit_cfg: any

	public constructor(parent?) {
		super(parent)


		this.model = EquipModel.GetInstance();
		this.base_file = "bag"
		this.dependent_res = ["equipCom"]
		this.layout_file = "BagEquipmentIcon"
		this.load_callback = () => {
			this.LoadSuccess()
			this.InitEvent()
		}


	}

	public DeleteMe() {

		if (this.award_item) {
			this.award_item.DeleteMe()
			this.award_item = null
		}
		super.DeleteMe()
	}

	public InitEvent() {

		this.BindEvent(this.model, EquipEvent.WEAR_SUCCESS, (info?) => {
			if (this.equip_type == info.cell_pos) {
				this.UpdateEffect()
			}
		}
		)
	}

	public LoadSuccess() {

		if (this.refresh_data) {
			this.SetData(this.data)
		}
		if (this.data_callback) {
			this.data_callback()
		}
		Util.AddClickEvent(this.scaleGp, () => {
			let list = this.model.GetEquipInfosByType(this.equip_type)
			let cur_wear_info = this.model.GetWearEquipInfo(this.equip_type)
			if (list.length < 1 && !cur_wear_info) {
				if (this.equip_type == 7) {
					MaterialsTool.GetInstance().materialsTips(EquipDefine.BANGLE_SHOW_ID)
				} else if (this.equip_type == 9) {
					MaterialsTool.GetInstance().materialsTips(EquipDefine.RING_SHOW_ID)
				} else {
					Message.show("当前没有更多装备！")
				}
				return
			}
			if (cur_wear_info) {
				UIToolTipMgr.GetInstance().AppendEquipTips(cur_wear_info.type_id, null, null, cur_wear_info)
			}
		}
			, this, true)
	}

	//function EquipmentIcon.OpenEquipTreasureView()
	//let icon_cfg = CommonManager.GetInstance().GetFunctionIconCfg(416)
	//if (! icon_cfg ) {
	//return
	//}
	//let lv = RoleManager.GetInstance().GetMainRoleVo().level
	//if (icon_cfg.open_lv > lv ) {
	//Alert.Show(icon_cfg.open_lv + "级开启装备寻宝！\n进行寻宝可以获得珍惜戒指和手镯。", Alert_Type.One)
	//}else{
	////RuneTreasureModel:GetInstance():Fire(RuneTreasureEvent.RUNE_TREASURE_OPEN_VIEW, "RuneTreasureBaseView")
	//}
	//}

	public ExcuteOrSetCallback(func?) {

		this.data_callback = func
		if (this.is_loaded) {
			this.data_callback()
		}
	}

	public SetEquipPos(equip_type?) {

		this.equip_type = equip_type
	}

	public SetCfgs(...new_args) {

		[this.limit_cfg, this.attr_cfg] = new_args
	}

	public SetData(data?) {

		this.data = data
		if (!this.is_loaded) {
			this.refresh_data = true
			return
		}

		if (!this.data) {
			if (this.equip_type) {
				ResManager.GetInstance().SetImageSprite(this, this.lock_icon, "equipCom_asset", "role_default_" + this.equip_type)
				let show_add = this.equip_type == 7 || this.equip_type == 9
				this._img_add.visible = show_add
			}
			return
		}

		if ((!this.attr_cfg || !this.limit_cfg)) {
			return
		}
		let lv = (this.limit_cfg.stren_max <= data.stren && (this.limit_cfg.stren_max) || (data.stren))
		this.attr_list = this.attr_cfg
		let grade = (this.attr_list && (this.attr_list.stage) || (0))
		this.UpdateAwardItem(data, lv, grade)
		this._img_add.visible = false
	}

	public ShowRedDot() {
	}

	public UpdateAwardItem(data?, lv?, grade?) {

		if (!this.award_item) {
			this.award_item = new EquipmentItem(this.award_con, null, null, null, null, true)
			this.award_item.Load()
		}
		this.award_item.SetScale(0.68)
		// SetAnchoredPosition(this.award_item, 0, 0)
		this.award_item.SetData(data.type_id, null, data.bind, null, null, null, null, null, data.goods_id)
		this.award_item.SetShowTips(false)
		// let star_count = (this.attr_list && (this.attr_list.star) || (0))

		this.award_item.SetVisible(data != null)
		this.icon_bg.visible = data == null
	}

	public item_data() {

		return this.data
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
			this.red_dot,
			this.group_eff
		] = this.GetChildrenByNames([
			"scaleGp",
			"icon_bg",
			"lock_icon",
			"_img_add",
			"award_con",
			"red_dot",
			"group_eff"
		])
	}

}
window["EquipmentIcon"] = EquipmentIcon
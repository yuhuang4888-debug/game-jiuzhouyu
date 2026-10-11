import { BaseItem1 } from "../common/BaseItem1"
import { Config } from "../common/Config"
import { Util } from "../util/Util"
import { Status } from "../util/Status"
import { ResManager } from "../common/ResManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GoodsModel } from "../commonModel/GoodsModel"
import { RoleManager } from "../commonModel/RoleManager"
import { FriendModel, FriendEvent } from "../commonModel/FriendModel"
import { EquipModel, EquipEvent } from "../commonModel/EquipModel"
import { EquipmentItem } from "../common/EquipmentItem"
import { UIToolTipMgr } from "../common/UIToolTipMgr"

export class GodEquipBuildItem extends BaseItem1 {
	_canBuild
	_canSelect
	_isNext
	_showRedDot
	_showTips
	attr_cfg
	attr_list

	award_item

	click_fun
	data
	equip_type
	godlevel
	limit_cfg
	model
	refresh_data
	data_callback
	role_id
	select
	ser_id
	click

	public constructor(parent?) {
		super(parent)
		this.base_file = "godequipbuild"
		this.layout_file = "GodEquipBuildItem"

		this.click = null
		this.model = EquipModel.GetInstance()
		this.ser_id = 0
		this._showTips = false
		this._showRedDot = true
		this._isNext = true
		this._canSelect = true
		this._canBuild = true

		this.load_callback = () => {
			this.LoadSuccess()
			this.InitEvent()
		}
	}

	public InitEvent() {
		this.BindEvent(this.model, EquipEvent.WEAR_SUCCESS, (info?) => {
			if (this.equip_type == info.cell_pos) {
				this.UpdateEffect()
			}
		})

		this.BindEvent(GlobalEventSystem, GoodsModel.CHANGE_GOODS_DYNAMIC, (id?) => {
			if (!this.data) {
				return
			}
			let goods_id = this.data.goods_id
			if (goods_id == id && this.click) {
				let vo = GoodsModel.GetInstance().GetDynamic(id, null, false, true)
				this.showTips(vo)
				return
			}
		})

		Util.AddClickEvent(this.gp_click, () => {
			if (this.click_fun) {
				this.click_fun(this.equip_type)
			}
		}, this)
	}

	public LoadSuccess() {
		if (this.equip_type) {
			ResManager.GetInstance().SetImageSprite(this, this.lock_icon, "equipCom", "role_default_" + this.equip_type + "")
		}
		if (this.refresh_data) {
			this.SetData(this.data, this.role_id, this.ser_id, this._showTips, this._showRedDot, this._isNext, this.godlevel)
		}
		if (this.data_callback) {
			this.data_callback()
		}

		if (this.select != null) {
			this.setSelect(this.select)
		}
	}

	public SetEquipPos(equip_type?) {

		this.equip_type = equip_type
	}

	public SetCfgs(limit_cfg?, attr_cfg?) {

		this.limit_cfg = limit_cfg
		this.attr_cfg = attr_cfg
	}

	public SetClickFun(fun?) {

		this.click_fun = fun
	}

	public SetData(data?, role_id?, ser_id?, showTips?, showRedDot?, isNext?, godlevel?) {

		if (showTips == null) {
			showTips = false
		}
		if (showRedDot == null) {
			showRedDot = true
		}
		if (isNext == null) {
			isNext = false
		}

		this.data = data
		this.role_id = role_id
		this.ser_id = ser_id
		this._showTips = showTips
		this._showRedDot = showRedDot
		this._isNext = isNext
		this.godlevel = godlevel
		if (!this.is_loaded) {
			this.refresh_data = true
			return
		}
		if (this.award_item) {
			this.award_item.SetVisible(!(!data))
		}
		//this.icon_bg.visible =  ! data 
		this._canSelect = data != null
		if (!this.attr_cfg || !this.limit_cfg || !this.data) {
			return
		}
		this.attr_list = this.attr_cfg
		let grade = this.attr_list && this.attr_list.stage || 0
		this.UpdateAwardItem(data, grade, role_id, this._showTips)
	}

	public UpdateAwardItem(data?, grade?, role_id?, showTips?) {
		if (showTips == null) {
			showTips = false
		}

		if (!this.award_item) {
			this.award_item = new EquipmentItem(this.award_con)
			this.award_item.Load()
			this.award_item.SetItemSize(88, 88)
		}
		if (!showTips) {
			this.award_item.SetShowTips(false)
		}
		if (this._isNext) {
			let attr_list = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_equip_attr.name, data.type_id, false)
			this._isNext = this.model.checkFullPos(data.cell, data.color, attr_list.stage, attr_list.star) && this.model.checkFullAttr(this.godlevel, data.cell, attr_list.stage)
		}
		if (this._isNext) {
			this.award_item.SetData(data.type_id, null, null, null, null, null, null, null, null, null, this.godlevel)
		} else {
			this.award_item.SetData(data.type_id, null, null, null, null, null, null, null, data.goods_id)
		}
		//let limit = this.cfg_god_equip_kv["strength_limit"]
		//if (limit && limit.value) {
		//let limitList = ErlangParser.GetInstance().Parse(limit.value)
		this._canBuild = this.model.checkFullPos(data.cell, data.color, this.attr_list.stage, this.attr_list.star)
		//}
		this.red_dot.visible = this._showRedDot && this.model.godEquipitemRedDot(this.data) && this._canBuild
		this.award_item.SetClickCallBack(() => {
			this.click = true
			let show = false
			let vo = GoodsModel.GetInstance().GetDynamic(data.goods_id, null, false, true)
			if (this.role_id == RoleManager.GetInstance().GetMainRoleId()) {
				if (!vo) {
					GoodsModel.GetInstance().GetDynamic(data.goods_id, null, true, false)
				} else {
					show = true
				}
			} else {
				let time = FriendModel.GetInstance().getEquipRequestTime(data.goods_id, this.role_id)
				if (!vo || !time || Status.NowTime - time >= 3) {
					FriendModel.GetInstance().equipRequestTime(data.goods_id, this.role_id, Status.NowTime)
					let server_id = RoleManager.GetInstance().GetMainRoleVo().server_id
					if (this.ser_id != 0 && this.ser_id != server_id) {
						FriendModel.GetInstance().Fire(FriendEvent.REQUEST_KUAFU_GOODS_MESSAGE, this.ser_id, role_id, data.goods_id)
					} else {
						GoodsModel.GetInstance().Fire(GoodsModel.REQUEST_GOODS_DYNAMIC, data.goods_id, role_id, true)
					}
				} else {
					show = true
				}
			}
			if (show) {
				this.showTips(vo)
			}
		}
		)
	}

	public showTips(vo?) {
		UIToolTipMgr.GetInstance().AppendEquipTips(vo.type_id, null, null, vo, this.role_id)
		this.click = false
	}

	public UpdateEffect() {
		// this.AddUIEffect("ui_Strengthen_glow", this.group_eff)
	}

	public setSelect(bool?) {
		if (!this.is_loaded) {
			this.select = bool
			return
		}
		this._img_select.visible = bool
	}

	public setScale(value?) {
		// if (this.form) {
		// 	SetLocalScale(this.form, value, value, value)
		// }
	}

	public equip_data() {
		return this.data
	}

	public canSelect() {
		return this._canSelect
	}

	public canBuild() {
		return this._canBuild
	}

	public pos() {
		return this.equip_type
	}

	public DeleteMe() {
		if (this.award_item) {
			this.award_item.DeleteMe()
		}
		super.DeleteMe()
	}

	scaleGp: Laya.Box
	icon_bg: Laya.Image
	lock_icon: Laya.Image
	_img_add: Laya.Image
	award_con: Laya.Box
	group_eff: Laya.Box
	_img_select: Laya.Image
	red_dot: Laya.Image
	gp_click: Laya.Box
	public GetComponents() {
		[
			this.scaleGp,
			this.icon_bg,
			this.lock_icon,
			this._img_add,
			this.award_con,
			this.group_eff,
			this._img_select,
			this.red_dot,
			this.gp_click,
		]
			= this.GetChildrenByNames([
				"scaleGp",
				"icon_bg",
				"lock_icon",
				"_img_add",
				"award_con",
				"group_eff",
				"_img_select",
				"red_dot",
				"gp_click",
			])
	}
}
window["GodEquipBuildItem"] = GodEquipBuildItem
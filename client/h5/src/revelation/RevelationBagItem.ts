import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { Util } from "../util/Util"
import { table } from "../common/table"
import { ResManager } from "../common/ResManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { RoleManager } from "../commonModel/RoleManager"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { RevelationModel } from "../commonModel/RevelationModel"
import { RevelationToolTips } from "../common/RevelationToolTips"

export class RevelationBagItem extends BaseItemRenderer {
	WIDTH = 88.9
	HEIGT = 88.9

	model
	res_mgr
	goods_basic
	showeffect1
	showeffect2
	showing_effect1
	showing_effect2

	public constructor() {
		super()
		this.base_file = "revelation"
		this.layout_file = "RevelationBagItem"

		this.model = RevelationModel.GetInstance()
		this.res_mgr = ResManager.GetInstance()

		this.load_callback = () => {
			this.showing_effect1 = null
			this.display_obj.scaleX = 1.045
			this.display_obj.scaleY = 1.045

			Util.AddClickEvent(this._gp_con, () => {
				this.ClickFunc()
			}, this, true)
		}
		this.Load()
	}

	public dataChanged() {
		if (!super.dataChanged()) {
			return
		}
		if (!this.data) {
			return
		}

		let goods_basic = null
		let type_id = this.data.type_id

		this.showeffect1 = false
		this.showeffect2 = false
		if (type_id == 0) {
			this.res_mgr.SetImageSprite(this, this._img_bg, "common", "com_goods_plate_0")
			this._gp_effect.visible = false
			this._img_icon.visible = false
			this._img_bind.visible = false
			this.star_group.visible = false
			this.ban.visible = false
			this._lb_count.text = ""
			this.showeffect2 = false
		} else {
			goods_basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
			if (goods_basic) {
				this.res_mgr.SetImageSprite(this, this._img_bg, "common", "com_goods_plate_" + goods_basic.color)
				this.res_mgr.SetOutsideImageSprite(this, this._img_icon, "resource/game/goodsIcon/" + goods_basic.goods_icon + ".png")
				this._img_bind.visible = this.data.bind == 1
				if (this.data.type == RevelationModel.GOODS_TYPE) {
					let equip = this.model.GetWearEquipByPos(this.data.subtype)
					let bool = !equip || (this.data.rating > equip.rating)
					this._gp_effect.visible = bool
					if (bool) {
						this.showeffect1 = true
					}
				} else {
					this._gp_effect.visible = false
					this.star_group.visible = false
				}
				this._lb_count.text = this.data.goods_num > 1 ? String(this.data.goods_num) : ""
				this._img_icon.visible = true
				let bool = goods_basic.type == RevelationModel.GOODS_TYPE
				if (bool) {
					let equip_data = this.res_mgr.GetGameConfigFromCache(this.base_item, "config_revelation_equip_attr", false)[type_id]
					if (equip_data) {
						this.star_group.visible = true
						let i = 0
						do {
							this["star_" + i].visible = i < equip_data.star
							i = i + 1
						} while ((i < 4))
					}
				}
				this.ban.visible = RoleManager.GetInstance().GetMainRoleVo().level < goods_basic.level
				this.showeffect2 = true
			}
		}

		if (this.showeffect1) {
			if (!this.showing_effect1) {
				this.base_item.AddUIEffect("UI_1138", this._gp_effect, { x: 0, y: 2 }, 12, true)
				//this.img_up.visible = true
				this.showing_effect1 = true
			}
		} else if (this.showing_effect1) {
			this.base_item.ClearUIEffect(this._gp_effect)
			//this.img_up.visible = false
			this.showing_effect1 = null
		}

		/*
		if (this.showeffect2) {
			if (!this.showing_effect2) {
				this.AddUIEffect("UI_1305_1", "UI", this.effect1, false, false, true, { mask_id = 1 })
				this.showing_effect2 = true
			}
		} else if (this.showing_effect2) {
			this.ClearUIEffect(this.effect1)
			this.showing_effect2 = null
		}
		*/
		this.goods_basic = goods_basic
	}

	public ClickFunc() {
		if (this.goods_basic) {
			if (this.goods_basic.type == RevelationModel.GOODS_TYPE) {
				let show_btn_list = [RevelationToolTips.Btn.replace]
				if (this.data.bind != 1 && this.data.trade == 1) {
					table.unshift(show_btn_list, RevelationToolTips.Btn.upShelf)
				}
				UIToolTipMgr.GetInstance().AppendRevelationTooltips(this.data.type_id, this.data, null, show_btn_list)
			} else {
				UIToolTipMgr.GetInstance().AppendGoodsTips(this.goods_basic.type_id, null, null, this.data, this.data.goods_num)
			}
		}
	}

	public DeleteMe() {
		if (this._gp_effect) {
			this.base_item.ClearUIEffect(this._gp_effect)
		}
		/*
		if (this.effect1) {
			this.ClearUIEffect(this.effect1)
		}
		*/
		super.DeleteMe()
	}

	_gp_con: Laya.Box
	_img_bg: Laya.Image
	_img_icon: Laya.Image
	effect1: Laya.Box
	_gp_effect: Laya.Box
	_img_bind: Laya.Image
	_lb_count: Laya.Label
	star_group: Laya.Box
	star_0: Laya.Image
	star_1: Laya.Image
	star_2: Laya.Image
	star_3: Laya.Image
	ban: Laya.Image
	img_up: Laya.Image
	public GetComponents() {
		[
			this._gp_con,
			this._img_bg,
			this._img_icon,
			this.effect1,
			this._gp_effect,
			this._img_bind,
			this._lb_count,
			this.star_group,
			this.star_0,
			this.star_1,
			this.star_2,
			this.star_3,
			this.ban,
			this.img_up,
		]
			= this.GetChildrenByNames([

				"_gp_con",
				"_img_bg",
				"_img_icon",
				"effect1",
				"_gp_effect",
				"_img_bind",
				"_lb_count",
				"star_group",
				"star_0",
				"star_1",
				"star_2",
				"star_3",
				"ban",
				"img_up",
			])
	}
}
window["RevelationBagItem"] = RevelationBagItem
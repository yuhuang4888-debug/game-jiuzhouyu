import { BaseItem1 } from "../common/BaseItem1"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { HolySealModel } from "../commonModel/HolySealModel"
import { Util } from "../util/Util"
import { HolySealToolTips } from "../common/HolySealToolTips"
import { ResManager } from "../common/ResManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { GameResPath } from "../util/GameResPath"
import { WordManager } from "../common/WordManager"
import { Message } from "../sysInfo/SysInfoController"

export class HolySealEquipItem extends BaseItem1 {

	data
	model:HolySealModel
	ui_tool_mgr:UIToolTipMgr
	res_mgr:ResManager
	need_refresh_data:boolean

	constructor(parent?) {
		super(parent)
		this.base_file = "holySeal"
		this.layout_file = "HolySealEquipItem"
		this.model = HolySealModel.GetInstance()
		this.ui_tool_mgr = UIToolTipMgr.GetInstance()
		this.res_mgr = ResManager.GetInstance()
		this.load_callback = () => {
			this.LoadSuccess()
		}
	}

	LoadSuccess() {
		this.InitEvent()
		if (this.need_refresh_data) {
			this.UpdateView()
			this.need_refresh_data = false
		}
	}

	InitEvent() {
		Util.AddClickEvent(this._gp_con, () => {
			if (this.data && this.data.type_id != 0) {
				this.ui_tool_mgr.AppendHolySealTips(this.data.type_id, this.data, null, [HolySealToolTips.Btn.close])
			} else {
				Message.show("异域玩法可获得大量影装")
			}
		}, this, true)
	}

	SetData(data?) {
		this.data = data
		if (this.is_loaded) {
			this.UpdateView()
		} else {
			this.need_refresh_data = true
		}
	}

	UpdateView() {
		let type_id = this.data.type_id
		if (type_id == 0) {
			this._gp_stage.visible = false
			this.res_mgr.SetImageSprite(this, this._img_bg, "holySeal", `bg_${this.model.GetEquipBgbByType(this.data.equip_type)}_0`)
			// this._img_icon.source = undefined
			this.res_mgr.SetImageSprite(this, this._img_icon, "holySeal", `base_${this.data.equip_type}`)
		} else {
			let goods_basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
			if (goods_basic) {
				this._img_icon.skin = undefined
				this.res_mgr.SetOutsideImageSprite(this, this._img_icon, GameResPath.GetGoodsIconPath(goods_basic.goods_icon))
				this.res_mgr.SetImageSprite(this, this._img_bg, "holySeal", `bg_${this.model.GetEquipBgbByType(this.data.cell)}_${goods_basic.color}`)

				let config_seal_equip = this.res_mgr.GetGameConfigFromCache(this, "config_seal_equip", false)
				let equip_data = this.model.GetHolySealData(type_id, config_seal_equip)
				if (equip_data) {
					if (!this._gp_stage.visible) {
						this._gp_stage.visible = true
					}
					this._lb_stage.text = WordManager.ConvertNum(equip_data.stage) + "阶"
					this._lb_stage.strokeColor = this.model.GetStage2StrokeColor(equip_data.color)
					this.res_mgr.SetImageSprite(this, this._img_stage_bg, "common_asset", this.model.GetStage2BgSource(equip_data.color))
				}
			}
		}
	}
	_gp_con: Laya.Box
	_img_bg: Laya.Image
	_img_icon: Laya.Image
	_gp_stage: Laya.Box
	_img_stage_bg: Laya.Image
	_lb_stage: Laya.Label
	public GetComponents() {
		[
			this._gp_con,
			this._img_bg,
			this._img_icon,
			this._gp_stage,
			this._img_stage_bg,
			this._lb_stage,
		]
			= this.GetChildrenByNames([

				"_gp_con",
				"_img_bg",
				"_img_icon",
				"_gp_stage",
				"_img_stage_bg",
				"_lb_stage",
			])
	}
}
window["HolySealEquipItem"] = HolySealEquipItem
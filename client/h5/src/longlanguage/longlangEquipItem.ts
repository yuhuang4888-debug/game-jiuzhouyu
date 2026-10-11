import { BaseItem1 } from "../common/BaseItem1"
import { SetSizeDelta, Util } from "../util/Util"
import { table } from "../common/table"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { GoodsModel } from "../commonModel/GoodsModel"
import { CompositeModel } from "../commonModel/CompositeModel"
import { WordManager } from "../common/WordManager"
import { longlangModel } from "../commonModel/longlangModel"
import { HolySealModel } from "../commonModel/HolySealModel"
import { LonglangToolTips } from "../common/LonglangToolTips"
import { PlayerMessageLonglanguageTips } from "../playerMessage/PlayerMessageLonglanguageTips"

export class longlangEquipItem extends BaseItem1 {
	InitEvent
	data
	model
	need_refresh_data
	cfg_draconic_equip

	public constructor(parent?) {
		super(parent)
		this.base_file = "longlanguage"
		this.dependent_res = ["holySeal"]
		this.layout_file = "longlangEquipItem"
		let _other_longlangtips
		this.model = longlangModel.GetInstance()

		this.load_callback = () => {
			this.cfg_draconic_equip = ResManager.GetInstance().GetGameConfigFromCache(this, "config_draconic_equip", false)
			this.LoadSuccess()
			this.InitEvent()
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._gp_con, () => {
				if (this.data && this.data.type_id && this.data.type_id != 0) {
					let btnList = []
					if (this.data.goods_id) {
						table.insert(btnList, LonglangToolTips.Btn.upStage)
						if (this.model.UpColorCfg[String(this.data.type_id)]) {
							table.insert(btnList, LonglangToolTips.Btn.upColor)
						}
						table.insert(btnList, LonglangToolTips.Btn.outEquip)
					} else {
						table.insert(btnList, LonglangToolTips.Btn.close)
					}
					if(this.data.other){
						// UIToolTipMgr.GetInstance().AppendLongLangToolTips(this.data.type_id, this.data, null, btnList,this.data.suit)
						if (!_other_longlangtips) {
							_other_longlangtips = new PlayerMessageLonglanguageTips()
						}
						_other_longlangtips.SetData(this.data.type_id, this.data, null, btnList,this.data.suit)
						_other_longlangtips.Open()
					}else{
						UIToolTipMgr.GetInstance().AppendLongLangToolTips(this.data.type_id, this.data, null, btnList)
					}
				}
			}
				, this, true)
			this.BindEvent(GoodsModel.GetInstance(), GoodsModel.UPDATE_GOODS_NUM, () => {
				if (this.use_delete_method) {
					return
				}
				if (this.data) {
					let type_id = this.data.type_id
					this.redImg.visible = (CompositeModel.GetInstance().CanCompose(this.model.UpStageCfg[type_id]) || CompositeModel.GetInstance().CanCompose(this.model.UpColorCfg[type_id])) && (!this.data.suit)
				}
			}
			)
		}
	}

	public DeleteMe() {
		// this.ClearUIEffect(this.effectGp)
		// this.ClearUIEffect(this.effectGp0)
		super.DeleteMe()
	}
	public LoadSuccess() {
		if (this.need_refresh_data) {
			this.UpdateView()
			this.need_refresh_data = false
		}
	}

	public SetData(data?) {
		this.data = data
		if (this.is_loaded) {
			this.UpdateView()
		} else {
			this.need_refresh_data = true
		}
	}

	public UpdateView() {
		let type_id = this.data.type_id
		let type = this.data.subtype || this.data.equip_type
		// let scale = type == 9 && 1.1 || 1
		// SetLocalScale(this.form, scale, scale, 1)
		// let hCenter = 0
		let effectName = null
		// let pos = null
		if (type == 11) {
			ResManager.GetInstance().SetImageSprite(this, this._img_bg, "longlanguage", "ui_seal_colour2_1", true)
			effectName = "UI_1303c"
			// pos = [x = -2, y = 4]
			// let y = type_id == 0 && -8 || 3
			// SetAnchoredPositionY(this._img_icon, y)
		} else if (type < 7) {
			ResManager.GetInstance().SetImageSprite(this, this._img_bg, "longlanguage", "ui_ly_02", true)
			// hCenter = 0.5
			// pos = [x = 2, y = 1]
			effectName = "UI_1303a"
			// SetAnchoredPositionY(this._img_icon, -0.5)
		} else {
			ResManager.GetInstance().SetImageSprite(this, this._img_bg, "longlanguage", "ui_ly_01", true)
			// hCenter = 0
			effectName = "UI_1303b"
		}

		if (type_id == 0) {
			this._gp_stage.visible = false
			ResManager.GetInstance().SetImageSprite(this, this._img_icon, "longlanguage", type, true)
			SetSizeDelta(this._img_icon, 72, 72)
			this.redImg.visible = false
			// SetAnchoredPositionX(this._img_icon, 2)
			// let scale_ = type < 7 && 1 || 1.65
			// SetLocalScale(this._img_icon, scale_, scale_, 1)
			this.ClearUIEffect(this.effectGp)
			// this.ClearUIEffect(this.effectGp0)
		} else {
			this.ClearUIEffect(this.effectGp)
			// SetLocalScale(this._img_icon, 0.92, 0.92, 1)
			// SetAnchoredPositionX(this._img_icon, hCenter)
			let goods_basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
			if (goods_basic) {
				this._img_icon.skin = ""
				ResManager.GetInstance().SetOutsideImageSprite(this, this._img_icon, "resource/game/goodsIcon/" + goods_basic.goods_icon + ".png", true)
				let cfg = this.cfg_draconic_equip
				let equip_data = cfg[Number(type_id)]
				if (equip_data) {
					if (!this._gp_stage.visible) {
						this._gp_stage.visible = true
					}
					this._lb_stage.text = WordManager.ConvertNum(equip_data.stage) + "阶"
					let holyseal = HolySealModel.GetInstance()
					let source = holyseal.GetStage2BgSource(equip_data.color)
					ResManager.GetInstance().SetImageSprite(this, this._img_stage_bg, "common", source, true)
				}
				let active = (CompositeModel.GetInstance().CanCompose(this.model.UpStageCfg[type_id]) || CompositeModel.GetInstance().CanCompose(this.model.UpColorCfg[type_id])) && !this.data.suit
				this.redImg.visible = active
				if (goods_basic.color > 3) {
					this.AddUIEffect(effectName, this.effectGp, null, 10, true)
					// if (type == 11) {
					// 	this:AddUIEffect("ui_draconic_frame3_down", this.effectGp0, null, null, true)
					// }
				}
			}
		}
	}

	_gp_con: Laya.Box
	_img_bg: Laya.Image
	_img_icon: Laya.Image
	effectGp: Laya.Box
	_gp_stage: Laya.Box
	_img_stage_bg: Laya.Image
	_lb_stage: Laya.Label
	redImg: Laya.Image
	public GetComponents() {
		[
			this._gp_con,
			this._img_bg,
			this._img_icon,
			this.effectGp,
			this._gp_stage,
			this._img_stage_bg,
			this._lb_stage,
			this.redImg,
		]
			= this.GetChildrenByNames([

				"_gp_con",
				"_img_bg",
				"_img_icon",
				"effectGp",
				"_gp_stage",
				"_img_stage_bg",
				"_lb_stage",
				"redImg",
			])
	}
}
window["longlangEquipItem"] = longlangEquipItem
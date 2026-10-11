import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { Config } from "../common/Config"
import { EquipmentItem } from "../common/EquipmentItem"
import { ResManager } from "../common/ResManager"
import { EquipModel, EquipDefine } from "../commonModel/EquipModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { ColorUtil } from "../util/ColorUtil"
import { ErlangParser } from "../util/ErlangParser"
import { SetSizeDeltaX, SetAnchoredPositionX, Util } from "../util/Util"

export class EquipSuitAwardItem extends BaseItemRenderer {
	_Image1: Laya.Image
	_Image0: Laya.Image
	item_bg: Laya.Image
	_img_icon: Laya.Image
	Image: Laya.Image
	_img_select: Laya.Image
	_lb_suit: Laya.HTMLDivElement
	_lb_count: Laya.HTMLDivElement
	_reddot: Laya.Image
	_group_item: Laya.Box
	award_item
	is_load
	model

	public static width = 264
	public static height = 105

	public constructor(parent) {
		super()

		this.model = EquipModel.GetInstance()
		this.base_file = "suit"
		this.layout_file = "EquipSuitAwardItem"
		this.WIDTH=264
		this.HEIGT=105
		// this.base_file = "suit"
		// this.layout_file = "EquipSuitAwardItemExml"

		// this.load_callback = () => {

		// 	// if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
		// 	// 	this._lb_suit.size  = 16
		// 	// 	this._lb_count.size  = 16
		// 	// }
		// 	this.InitEvent()
		// 	this.is_load = true
		// }

		// this.skinName = "resource/game/suit/exml/EquipSuitAwardItemExml.exml"
		this.Load()
		// this.InitEvent()
	}

	public DeleteMe() {

		if (this.award_item) {
			super.DeleteMe()
			this.award_item.DeleteMe()
			this.award_item = null
		}
		super.DeleteMe()
	}

	public load_callback() {

		if (!this.award_item) {
			this.award_item = new EquipmentItem(this._group_item)
			this.award_item.SetItemSize(87, 87)
			this.award_item.SetUseMask(true)
			this.award_item.Load()
			// this.award_item.SetShowTips(false)
		}
		this.display_obj.mouseEnabled=false
	}

	public dataChanged() {
		if (super.dataChanged()) {
			if(this.selected){
				this._Image0.visible=false
			}else
				this._Image0.visible=true
			if (!this.data) {
				return
			}
			let data = this.data
			this._img_icon.visible = !data.is_empty
			this.award_item.SetVisible(!data.is_empty)
			// this._img_select.visible = this.selecteds
			if (data.is_empty) {
				//this._lb_lock.visible = true 
				this._lb_suit.visible = false
				this._lb_count.visible = false
				this._reddot.visible = false
				ResManager.GetInstance().SetImageSprite(this, this._img_icon, "equipCom_asset", "role_default_" + data.equip_type)
				this._img_icon.visible = true
				return
			} else {
				this._lb_suit.visible = true
				this._lb_count.visible = true
				this._reddot.visible = true
			}

			let dynamic = data.dynamic
			
			this.award_item.SetData(dynamic.type_id)
			//武防装备显示
			if (this.data.isEquipType) {
				this.Image.visible=true
				let showStr
				let makeCfg = Config.GetConfigVo("config_equip_suit_make", dynamic.equip_type + "@" + this.data.suit_lv + "@" + this.data.stage, false, EquipModel.GetInstance().config_equip_suit_make)
				if (makeCfg) {
					let curLv = this.model.GetCurSuitLv(dynamic.equip_type)
					let conditionList = JSON.parse(makeCfg.condition)
					for (let k in conditionList) {
						var v = conditionList[k]
						if (v[0] == "quality") {
							if (Number(v[1]) > dynamic.color || Number(v[2]) > this.model.GetStarByTypeId(dynamic.type_id)) {
								// if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
								// 	showStr = "<font color=0xff4f50>" + ColorUtil.GetColorNameOne(Number(v[2])) + " G" + v[3] + " ! met\nUnable to craft</font>"
								// }else{
								// 	showStr = "<font color=0xff4f50>不足" + ColorUtil.GetColorNameOne(Number(v[2])) + v[3] + "无法打造</font>"
								// }
								showStr = "<font color=\"#ff4f50\">不足" + ColorUtil.GetColorNameOne(Number(v[1])) + v[2] + "无法打造</font>"
								break
							}
						} else if (v[0] == "activated") {
							if (Number(v[2]) > curLv) {
								showStr = "<font color=\"#ff4f50\">请先打造" + EquipDefine.SUIT_NAME_CFG[Number(v[2])-1] + "共鸣</font>"
								break
							}
						}
					}
					if (!showStr) {
						if (curLv == this.data.suit_lv) {
							let count = 0
							let suitDataList = this.model.suitDataList
							if (suitDataList) {
								for (let i in suitDataList) {
									var v = suitDataList[i]
									if (Config.GetConfigVo("config_equip_pos2suittype", v.equip_type, false, EquipModel.GetInstance().config_equip_pos2suittype).type == 1 && v.lv >= curLv) {
										count = count + 1
									}
								}
							}
							//let list = dynamic.suit_list
							//for (let k in list) {
							// var vo = list[k]
							//if (vo.suit_lv == curLv && count < vo.suit_count ) {
							//count = vo.suit_count
							//}
							//}
							showStr = "已打造共鸣<font color=\"#639C12\">" + count + "</font>/6"
						} else if (curLv > this.data.suit_lv) {
							showStr = "<font color=\"#639C12\">已打造" + EquipDefine.SUIT_NAME_CFG[curLv-1] + "共鸣</font>"
						} else {
							showStr = "可打造" + EquipDefine.SUIT_NAME_CFG[this.data.suit_lv-1] + "共鸣"
						}
					}
				} else {
					showStr = "<font color=\"#ff4f50\">不足" + EquipDefine.EQUIP_SUIT_MIN_STAGE + "阶无法打造</font>"
				}
				SetSizeDeltaX(this._lb_suit, 96)
				// this._lb_suit.text = String.gsub(GoodsModel.GetGoodsNameWithColorDark(dynamic.type_id), "%(残%)", "")
				this._lb_suit.innerHTML = Util.StrToHTML(GoodsModel.GetGoodsNameWithColorDark(dynamic.type_id).replace("%(残%)", ""))
				this._lb_count.innerHTML = Util.StrToHTML(showStr)
				let titleRes = "uizbtz_005"
				if (this.data.suit_lv == 2) {
					titleRes = "uizbtz_006"
				} else if (this.data.suit_lv == 3) {
					titleRes = "uizbtz_007"
				}
				ResManager.GetInstance().SetImageSprite(this, this.Image, "suit_asset", titleRes)
				this._reddot.visible = this.model.GetEquipSuitRed(dynamic.equip_type, this.data.suit_lv)
			} else { // 饰品显示
				this.Image.visible=false
				let curLv = this.model.GetCurSuitsLv(dynamic.equip_type)
				let makeCfg = Config.GetConfigVo("config_equip_suit_make", dynamic.equip_type + "@" + this.data.suit_lv + "@" + ((curLv + 1)), false, EquipModel.GetInstance().config_equip_suit_make)
				if (makeCfg) {
					let showStr
					let conditionList = JSON.parse(makeCfg.condition)
					for (let k in conditionList) {
						var v = conditionList[k]
						if (v[0] == "quality") {
							if (Number(v[1]) > dynamic.color || Number(v[3]) > this.model.GetStarByTypeId(dynamic.type_id)) {
								showStr = "<font color=\"#ff4f50\">不足" + ColorUtil.GetColorNameOne(Number(v[1])) + v[2] + "无法打造</font>"
								break
							}
						} else if (v[0] == "stage") {
							if (Number(v[2]) > this.data.stage) {
								showStr = "<font color=\"#ff4f50\">不足" + v[2] + "阶无法打造</font>"
								break
							}
						}
					}
					if (!showStr) {
						showStr = "可提升共鸣等级"
					}

					this._lb_count.innerHTML = Util.StrToHTML(showStr)
				} else {
					this._lb_count.innerHTML = "已满级"
				}
				SetSizeDeltaX(this._lb_suit, 156)
				if (curLv == 0) {
					this._lb_suit.innerHTML = Util.StrToHTML(GoodsModel.GetGoodsNameWithColorDark(dynamic.type_id))
				} else {
					this._lb_suit.innerHTML = Util.StrToHTML(GoodsModel.GetGoodsNameWithColorDark(dynamic.type_id) + (" + ") + curLv)
				}
				SetAnchoredPositionX(this._lb_suit, 110)
				this._reddot.visible = this.model.GetJewelSuitRed(dynamic.equip_type)
			}

		}
	}



	public GetComponents() {
		[
			this._Image1,
			this._Image0,
			this.item_bg,
			this._img_icon,
			this.Image,
			this._img_select,
			this._lb_suit,
			this._lb_count,
			this._reddot,
			this._group_item,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_Image0",
				"item_bg",
				"_img_icon",
				"Image",
				"_img_select",
				"_lb_suit",
				"_lb_count",
				"_reddot",
				"_group_item",
			])
		this._lb_suit.style.fontSize = 18
		this._lb_suit.style.color = "#593d2f"
		this._lb_suit.style.valign = "middle"
		this._lb_suit.style.stroke = 1
		this._lb_suit.style.strokeColor = "#ffffff"
		this._lb_suit.width=90

		this._lb_count.style.fontSize = 18
		this._lb_count.style.color = "#8e6c5c"
		this._lb_count.style.wordWrap = false
	}
}
window["EquipSuitAwardItem"] = EquipSuitAwardItem
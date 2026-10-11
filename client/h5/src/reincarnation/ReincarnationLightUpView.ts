import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { OpenFun } from "../common/OpenFun"
import { ResManager } from "../common/ResManager"
import { LuaSoundManager } from "../common/SoundManager"
import { WordManager } from "../common/WordManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { ReincarnationModel } from "../commonModel/ReincarnationModel"
import { RoleManager } from "../commonModel/RoleManager"
import { ColorUtil, ColorType } from "../util/ColorUtil"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"

export class ReincarnationLightUpView extends BaseView1 {
	DestoryCallback
	InitEvent
	InitView

	public constructor() {
		super()

		this.base_file = "reincarnation"
		this.layout_file = "ReincarnationLightUpView"
		this.layer_value = Enum_UILayer.Activity
		this.use_background = true
		this.click_bg_toClose = true
		this.is_center = true
		let local_util = Util
		let local_reinmodel = ReincarnationModel.GetInstance()
		let local_mainrole = RoleManager.GetInstance().GetMainRoleVo()
		let local_wordMgr = WordManager
		let local_colorUtil = ColorUtil
		let local_gModel = GoodsModel
		let local_goodsmodelIns = local_gModel.GetInstance()
		let propTextList_ = []
		let vo_ = null
		let goods_item_ = null
		let exp_item_ = null
		let type_id_ = null
		let goods_need_ = null
		this.load_callback = () => {
			// ResManager.GetInstance().SetOutsideImageSprite(this, this._Image2, GameResPath.GetIcon("common2", "uity_016j"), true)
			// ResManager.GetInstance().SetOutsideImageSprite(this, this._Image3, GameResPath.GetIcon("common2", "uity_016j"), true)
			ResManager.GetInstance().SetImageSpriteTrans(this, this._Image4, GameResPath.GetIcon("common2", "uity_016f"))
			this.prop_scroller.vScrollBar.visible = false
			this.InitEvent()
		}

		this.open_callback = () => {
			this.InitView()
		}

		this.destroy_callback = () => {
			this.DestoryCallback()
		}

		this.InitEvent = () => {
			let OnLightUpClick = () => {
				if (vo_) {
					local_reinmodel.Fire(ReincarnationModel.SEND_AWAKEN_CEll, vo_.id)
					this.Close()
				}
			}

			Util.AddClickEvent(this.lightup_btn, OnLightUpClick, this, true)

			let update_fun = (changePos?) => {
				if (this.use_delete_method) {
					return
				}
				if (vo_){
					let state = local_reinmodel.GetPointIdState(vo_.turn, 1, vo_.id)
					vo_.state = state
					this.InitView()
				}
			}
			this.BindEvent(local_reinmodel, ReincarnationModel.UPDATE_AWAKEN_CELL, update_fun)


			let ExpChange = () => {
				if (local_mainrole.exp >= vo_.exp_consume) {
					this.exp_count.color = local_colorUtil.TryParseHtmlString(local_colorUtil.GetColorDark(ColorType.GREEN, false))
				} else {
					this.exp_count.color = local_colorUtil.TryParseHtmlString(local_colorUtil.GetColorDark(ColorType.RED, false))
				}
				this.exp_count.text = local_wordMgr.ConvertNum(local_mainrole.exp, true) + "/" + local_wordMgr.ConvertNum(vo_.exp_consume, true)
			}

			this.BindVar(local_mainrole, "exp", ExpChange)
			let OngoodsChange = (goods_list?) => {
				if (this.use_delete_method) {
					return
				}
				for (let _tmpi in goods_list) {
					var vo = goods_list[_tmpi]
					if (vo.type_id == type_id_) {
						let cur_goods = local_goodsmodelIns.GetTypeGoodsNum(type_id_)
						if (cur_goods >= goods_need_) {
							this.goods_count.color = local_colorUtil.TryParseHtmlString(local_colorUtil.GetColorDark(ColorType.GREEN, false))
						} else {
							this.goods_count.color = local_colorUtil.TryParseHtmlString(local_colorUtil.GetColorDark(ColorType.RED, false))
						}
						this.goods_count.text = cur_goods + "/" + goods_need_
					}
				}
			}

			this.BindEvent(local_goodsmodelIns, local_gModel.UPDATE_GOODS_NUM, OngoodsChange)
			Util.AddClickEvent(this.CloseBtn, () => {
				this.Close()
			}
				, this, true, null, null, null, null, LuaSoundManager.SOUND_UI.CLOSE)
			Util.AddClickEvent(this.shopBtn, () => {
				let goodsBase = local_goodsmodelIns.GetGoodsBasicByTypeId(type_id_)
				if (goodsBase) {
					OpenFun.OpenFunHandler(60, 1, type_id_)
					this.Close()
				}
			}
				, this, true)
		}

		this.Open = (vo?) => {
			vo_ = vo
			super.Open()
		}

		this.InitView = () => {
			if (vo_) {
				this.title_label.text = vo_.name
				let prop_data = JSON.parse(vo_.attr)
				if (prop_data) {
					let str = ""
					let i = 0
					do {
						// let propText: Laya.Label = propTextList_[i]
						// if (!propText) {
						// 	propText = new Laya.Label()
						// 	propText.fontSize = 24
						// 	propText.valign = "top"
						// 	propText.align = "left"
						// 	//this.prop_group.addChild(propText)
						// 	propTextList_[i] = propText
						// }
						// propText.visible = true
						//propText.includeInLayout = true
						// propText.text = Util.StrToHTML("<font color='#4a3a32'>" + local_wordMgr.GetProperties(prop_data[i][0]) + ":</font><font color='#639c12'>" + local_wordMgr.ConvertToPercentValue(prop_data[i][0], prop_data[i][1]) + "</font>")
						str = str + Util.StrToHTML("<font color='#4a3a32'>" + local_wordMgr.GetProperties(prop_data[i][0]) + ":</font><font color='#639c12'>" + local_wordMgr.ConvertToPercentValue(prop_data[i][0], prop_data[i][1]) + "</font><br/>")
						i = i + 1
					} while ((i < prop_data.length))
					this.prop_label.style.fontSize = 20
					this.prop_label.style.width = 330
					this.prop_label.style.leading = 8
					this.prop_label.style.color = "#663915"

					this.prop_label.innerHTML = str

					let j = prop_data.length
					if (j < propTextList_.length) {
						do {
							if (propTextList_[j]) {
								propTextList_[j].visible = false
							}
							j = j + 1
						} while ((j < propTextList_.length))
					}
				}
				let goods_data = JSON.parse(vo_.priority_consume)
				if (goods_data && goods_data[0]) {
					type_id_ = Number(goods_data[0][1])
					goods_need_ = Number(goods_data[0][2])
					let goods_base = local_goodsmodelIns.GetGoodsBasicByTypeId(type_id_)
					if (goods_base) {
						this.goods_title.style.fontSize = 20
						this.goods_title.style.width = 250
						this.goods_title.style.color = "#663915"
						this.goods_title.innerHTML = Util.StrToHTML(local_gModel.GetGoodsNameWithColorDark(type_id_))
						let cur_goods = local_goodsmodelIns.GetTypeGoodsNum(type_id_)
						if (cur_goods >= goods_need_) {
							this.goods_count.color = local_colorUtil.TryParseHtmlString(local_colorUtil.GetColorDark(ColorType.GREEN, false))
						} else {
							this.goods_count.color = local_colorUtil.TryParseHtmlString(local_colorUtil.GetColorDark(ColorType.RED, false))
						}
						this.goods_count.text = cur_goods + "/" + goods_need_
						if (!goods_item_) {
							goods_item_ = new BaseAwardItem(this.goods_group)
							goods_item_.Load()
							goods_item_.SetScale(0.7)
						}
						goods_item_.SetData(type_id_)
					}
				}
				this.exp_count.text = local_wordMgr.ConvertNum(local_mainrole.exp, true) + "/" + local_wordMgr.ConvertNum(vo_.exp_consume, true)
				if (local_mainrole.exp >= vo_.exp_consume) {
					this.exp_count.color = local_colorUtil.TryParseHtmlString(local_colorUtil.GetColorDark(ColorType.GREEN, false))
				} else {
					this.exp_count.color = local_colorUtil.TryParseHtmlString(local_colorUtil.GetColorDark(ColorType.RED, false))
				}
				if (!exp_item_) {
					exp_item_ = new BaseAwardItem(this.exp_group)
					exp_item_.Load()
					exp_item_.SetScale(0.7)
				}
				let goods_base = local_goodsmodelIns.GetGoodsBasicByTypeId(32)
				exp_item_.SetData(goods_base.type_id)
				if (vo_.state == 0) {
					let beforeData = local_reinmodel.GetAwakenData(vo_.pre_id)
					if (beforeData) {
						this.tips_label.text = "请先点亮【" + beforeData.name + "】"
						this.tips_label.color = local_colorUtil.TryParseHtmlString(local_colorUtil.GetColorDark(ColorType.RED, false))
					}
					this.lightup_btn.visible = false
					this.shopBtn.visible = false
				} else if (vo_.state == 1) {
					this.tips_label.text = "优先消耗" + local_gModel.GetGoodsName(type_id_)
					this.tips_label.color = local_colorUtil.TryParseHtmlString(local_colorUtil.GetColorDark(ColorType.GREEN, false))
					this.lightup_btn.visible = true
					this.shopBtn.visible = true  //(type_id_ != 38110002 && type_id_ != 38110005) && type_id_ != 38110009)
				}
			}
			// this._Group1.refresh()
		}

		this.DestoryCallback = () => {
			if (goods_item_) {
				goods_item_.DeleteMe()
				goods_item_ = null
			}
			if (exp_item_) {
				exp_item_.DeleteMe()
				exp_item_ = null
			}
			propTextList_ = []
		}


	}

	bg: Laya.Image
	CloseBtn: Laya.Image
	_Image11: Laya.Image
	title_label: Laya.Label
	_Image2: Laya.Image
	_Image3: Laya.Image
	_Label1: Laya.Label
	_Label2: Laya.Label
	_Label3: Laya.Label
	goods_title: Laya.HTMLDivElement
	exp_title: Laya.Label
	exp_count: Laya.Label
	goods_count: Laya.Label
	_Group1: Laya.VBox
	tips_label: Laya.Label
	lightup_btn: Laya.Box
	_Image1: Laya.Image
	labelDisplay: Laya.Label
	_Label4: Laya.Label
	_Label5: Laya.Label
	_Image4: Laya.Image
	prop_scroller: Laya.Panel
	Content: Laya.VBox
	prop_label: Laya.HTMLDivElement
	goods_group: Laya.Box
	exp_group: Laya.Box
	shopBtn: Laya.Box
	_Image111: Laya.Image
	labelDisplay1: Laya.Label
	public GetComponents() {
		[
			this.bg,
			this.CloseBtn,
			this._Image11,
			this.title_label,
			this._Image2,
			this._Image3,
			this._Label1,
			this._Label2,
			this._Label3,
			this.goods_title,
			this.exp_title,
			this.exp_count,
			this.goods_count,
			this._Group1,
			this.tips_label,
			this.lightup_btn,
			this._Image1,
			this.labelDisplay,
			this._Label4,
			this._Label5,
			this._Image4,
			this.prop_scroller,
			this.Content,
			this.prop_label,
			this.goods_group,
			this.exp_group,
			this.shopBtn,
			this._Image111,
			this.labelDisplay1,
		]
			= this.GetChildrenByNames([

				"bg",
				"CloseBtn",
				"_Image11",
				"title_label",
				"_Image2",
				"_Image3",
				"_Label1",
				"_Label2",
				"_Label3",
				"goods_title",
				"exp_title",
				"exp_count",
				"goods_count",
				"_Group1",
				"tips_label",
				"lightup_btn",
				"_Image1",
				"labelDisplay",
				"_Label4",
				"_Label5",
				"_Image4",
				"prop_scroller",
				"Content",
				"prop_label",
				"goods_group",
				"exp_group",
				"shopBtn",
				"_Image111",
				"labelDisplay1",
			])
	}
}
window["ReincarnationLightUpView"] = ReincarnationLightUpView
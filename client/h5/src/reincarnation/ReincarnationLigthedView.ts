import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { WordManager } from "../common/WordManager"
import { ReincarnationModel } from "../commonModel/ReincarnationModel"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"

export class ReincarnationLigthedView extends BaseView1 {
	InitView

	public constructor() {
		super()

		this.base_file = "reincarnation"
		this.layout_file = "ReincarnationLigthedView"
		this.layer_value = Enum_UILayer.Activity
		this.use_background = true
		this.click_bg_toClose = true
		this.is_center = true
		this.destroy_imm = true
		// let local_eui = eui
		let local_util = Util
		let local_reinModel = ReincarnationModel.GetInstance()
		let local_wordMgr = WordManager
		let curPropList_ = []
		let totalPropList_ = []
		let vo_ = null
		this.open_callback = () => {

			// ResManager.GetInstance().SetOutsideImageSprite(this, this._Image2, GameResPath.GetIcon("common2", "uity_016j"), true)
			// ResManager.GetInstance().SetOutsideImageSprite(this, this._Image3, GameResPath.GetIcon("common2", "uity_016j"), true)
			this._Scroller1.vScrollBar.visible = false
			this._Scroller2.vScrollBar.visible = false

			this.InitView()
		}

		this.destroy_callback = () => {
			curPropList_ = []
			totalPropList_ = []
		}

		this.Open = (vo?) => {
			vo_ = vo
			super.Open()
		}

		this.InitView = () => {
			if (!vo_) {
				return
			}
			this.title_text.text = vo_.name
			let prop_data = JSON.parse(vo_.attr)
			if (prop_data) {
				let str = ""
				let j = 0
				do {
					// let curPropLabel = curPropList_[j]
					// if (!curPropLabel) {
					// 	curPropLabel = UiFactory.CreateChild(this.Content1, UIType.Label).transform //local_eui. new Label()
					// 	curPropLabel.GetComponent("Text").size = 24
					// 	curPropLabel.GetComponent("Text").verticalAlign = "top"
					// 	curPropLabel.GetComponent("Text").textAlign = "left"
					// 	//this.prop_group.addChild(curPropLabel)
					// 	curPropList_[i] = curPropLabel
					// }
					// curPropLabel.visible = true
					// curPropLabel.GetComponent("Text").textFlow = Util.StrToHTML("<font color='#4a3a32'>" + local_wordMgr.GetProperties(prop_data[i][0]) + ":</font><font color='#639c12'>" + local_wordMgr.ConvertToPercentValue(prop_data[i][0], prop_data[i][1]) + "</font>")
					str = str + Util.StrToHTML("<font color='#4a3a32'>" + local_wordMgr.GetProperties(prop_data[j][0]) + ":</font><font color='#639c12'>" + local_wordMgr.ConvertToPercentValue(prop_data[j][0], prop_data[j][1]) + "</font><br/>")
					j = j + 1
				} while ((j < prop_data.length))

				this.prop_label.style.fontSize = 22
				this.prop_label.style.width = 330
				this.prop_label.style.leading = 8
				this.prop_label.style.color = "#663915"
				this.prop_label.innerHTML = str


				
				let i = prop_data.length
				if (i < curPropList_.length) {
					do {
						if (curPropList_[i]) {
							curPropList_[i].visible = false
						}
						i = i + 1
					} while ((i < curPropList_.length))
				}
			}
			let light_count = local_reinModel.GetTurnActiveCount(local_reinModel.GetCurTurn())
			let max_count = local_reinModel.GetMaxCount()
			this.total_title.text = "已点亮属性(" + light_count + "/" + max_count + ")"
			let totalProp = local_reinModel.GetTotalProp()
			if (totalProp) {
				let str =""
				let showPropCount = 0
				for (let index in totalProp) {

					// [ts2lua]totalPropList_下标访问可能不正确
					// let totalPropText = totalPropList_[showPropCount]
					// if (!totalPropText) {
					// 	totalPropText = UiFactory.CreateChild(this.Content, UIType.Label).transform//local_eui. new Label()
					// 	totalPropText.GetComponent("Text").size = 24
					// 	totalPropText.GetComponent("Text").verticalAlign = "top"
					// 	totalPropText.GetComponent("Text").textAlign = "left"
					// 	//this.total_group.addChild(totalPropText)
					// 	// [ts2lua]totalPropList_下标访问可能不正确
					// 	totalPropList_[showPropCount] = totalPropText
					// }
					// totalPropText.visible = true
					// // [ts2lua]totalProp下标访问可能不正确
					// totalPropText.GetComponent("Text").textFlow = Util.StrToHTML("<font color='#4a3a32'>" + local_wordMgr.GetProperties(Number(index)) + ":</font><font color='#639c12'>" + local_wordMgr.ConvertToPercentValue(index, totalProp[index]) + "</font>")
					// showPropCount = showPropCount + 1
					str = str  + Util.StrToHTML("<font color='#4a3a32'>" + local_wordMgr.GetProperties(Number(index)) + ":</font><font color='#639c12'>" + local_wordMgr.ConvertToPercentValue(index, totalProp[index]) + "</font><br/>")
				}
				this.pro_label2.style.fontSize = 22
				this.pro_label2.style.width = 330
				this.pro_label2.style.leading = 8
				this.pro_label2.style.color = "#663915"
				this.pro_label2.innerHTML = str


				let i = showPropCount
				if (i < totalPropList_.length) {
					do {
						if (totalPropList_[i]) {
							totalPropList_[i].visible = false
						}
						i = i + 1
					} while ((i < totalPropList_.length))
				}
			}
		}


	}

	bg: Laya.Image
	_Image1: Laya.Image
	_Scroller1: Laya.Panel
	Content1: Laya.VBox
	prop_label: Laya.HTMLDivElement
	_Scroller2: Laya.Panel
	Content: Laya.VBox
	pro_label2: Laya.HTMLDivElement
	_Image2: Laya.Image
	_Image3: Laya.Image
	title_text: Laya.Label
	prop_title: Laya.Label
	total_title: Laya.Label
	public GetComponents() {
		[
			this.bg,
			this._Image1,
			this._Scroller1,
			this.Content1,
			this.prop_label,
			this._Scroller2,
			this.Content,
			this.pro_label2,
			this._Image2,
			this._Image3,
			this.title_text,
			this.prop_title,
			this.total_title,
		]
			= this.GetChildrenByNames([

				"bg",
				"_Image1",
				"_Scroller1",
				"Content1",
				"prop_label",
				"_Scroller2",
				"Content",
				"pro_label2",
				"_Image2",
				"_Image3",
				"title_text",
				"prop_title",
				"total_title",
			])
	}
}
window["ReincarnationLigthedView"] = ReincarnationLigthedView
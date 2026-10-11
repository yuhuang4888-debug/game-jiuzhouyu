import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { WordManager } from "../common/WordManager"
import { GameResPath } from "../util/GameResPath"
import { AtlasUrl, HtmlColorTxt, Util } from "../util/Util"

export class SmeltPropView extends BaseView1 {
	background_alpha
	is_center
	click_bg_toClose
	SetData
	attr_data
	need_refresh
	Local_Open
	prop_group
	use_background
	show_open_movie

	public constructor() {
		super()
		this.base_file = "bag"
		this.layout_file = "SmeltPropView"
		this.layer_value = Enum_UILayer.Activity
		this.click_bg_toClose = true
		this.use_background = true
		this.background_alpha = 0
		this.show_open_movie = true
		this.is_center = true

		this.need_refresh = false
		let word_mgr = WordManager

		this.load_callback = () => {
			// this.prop_text.width = 208
			// this.prop_text.height = 241
			this.prop_text.style.fontSize = 24
			this.prop_text.style.color = "#663915"

			this.prop_scroller.vScrollBarSkin = ""

			if (this.need_refresh) {
				this.SetData(this.attr_data)
			}
			//this._Image1.skin = AtlasUrl("common2", "uity_016b")
		}

		this.Local_Open = (parms?) => {
			if (parms) {
				this.SetData(parms)
			}
			super.Open()
		}

		this.SetData = (data?) => {
			this.attr_data = data
			if (this.is_loaded && data) {
				this.need_refresh = false
				let str = ""
				for (let i = 0; i < this.attr_data.length; i++) {
					if (Number(this.attr_data[i][0]) > 0) {
						if (i == this.attr_data.length - 1) {
							str = str + word_mgr.GetProperties(this.attr_data[i][0]) + " " + (HtmlColorTxt(" + " + word_mgr.ConvertToPercentValue(this.attr_data[i][0], this.attr_data[i][1]), "'#0a953e'"))
						} else {
							str = str + word_mgr.GetProperties(this.attr_data[i][0]) + " " + (HtmlColorTxt(" + " + word_mgr.ConvertToPercentValue(this.attr_data[i][0], this.attr_data[i][1]), "'#0a953e'")) + "<br/>"
						}
					}
				}
				this.prop_text.innerHTML = Util.StrToHTML(str)
				this.prop_text.width = 208
			} else {
				this.need_refresh = true
			}
		}
	}

	public Open(...new_args) {
		this.Local_Open(...new_args)
	}

	_Group1: Laya.Box
	property_bg: Laya.Image
	_Image1: Laya.Image
	property_title: Laya.Label
	prop_scroller: Laya.Panel
	Content: Laya.VBox
	prop_text: Laya.HTMLDivElement
	public GetComponents() {
		[
			this._Group1,
			this.property_bg,
			this._Image1,
			this.property_title,
			this.prop_scroller,
			this.Content,
			this.prop_text,
		]
			= this.GetChildrenByNames([

				"_Group1",
				"property_bg",
				"_Image1",
				"property_title",
				"prop_scroller",
				"Content",
				"prop_text",
			])
	}
}
window["SmeltPropView"] = SmeltPropView
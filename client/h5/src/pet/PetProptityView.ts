import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { WordManager } from "../common/WordManager"
import { HtmlColorTxt, Util } from "../util/Util"

export class PetProptityView extends BaseView1 {
	_Group1: Laya.Box
	property_bg: Laya.Image
	_Image1: Laya.Image
	property_title: Laya.Label
	prop_scroller: Laya.Panel
	Content: Laya.VBox
	prop_text: Laya.HTMLDivElement
	click :Laya.Image

	SetData

	public constructor() {
		super()

		this.base_file = "pet"
		this.layout_file = "PetProptityView"
		this.layer_value = Enum_UILayer.Activity
		this.click_bg_toClose = true
		this.use_background = true
		this.background_alpha = 0
		this.show_open_movie = true
		this.is_center = true
		let local_wordMgr = WordManager
		let attr_data_
		let need_refresh_ = false
		this.load_callback = () => {
			if (need_refresh_) {
				this.SetData(attr_data_)
			}
			Util.AddClickEvent(this.click,()=>{
				this.Close()
			},this,false)
		}

		this.SetData = (data?) => {
			attr_data_ = data
			if (this.is_loaded && data) {
				this.prop_text.width = 210
				need_refresh_ = false
				let str = ""
				for (let i = 0; i < data.length; i++) {
					let id = data[i].attr_id
					let value = data[i].attr_val
					if (id > 0) {
						if (i == data.length - 1) {
							str = `${str}${local_wordMgr.GetProperties(id)} ${Util.HtmlColorTxt(`+${local_wordMgr.ConvertToPercentValue(id, value)}`, "'#0a953e'")}`
						} else {
							str = `${str}${local_wordMgr.GetProperties(id)} ${Util.HtmlColorTxt(`+${local_wordMgr.ConvertToPercentValue(id, value)}`, "'#0a953e'")}<br/>`
						}
					}
				}
				this.prop_text.innerHTML = Util.StrToHTML(str)
				this.prop_text.x = this.Content.width / 2 - this.prop_text.contextWidth / 2
				// this.prop_text.y = this.prop_scroller.height / 2 - this.prop_text.contextHeight / 2
			} else {
				need_refresh_ = true
			}

		}
	}

	public GetComponents() {
		[
			this._Group1,
			this.property_bg,
			this._Image1,
			this.property_title,
			this.prop_scroller,
			this.Content,
			this.prop_text,
			this.click,
		]
			= this.GetChildrenByNames([

				"_Group1",
				"property_bg",
				"_Image1",
				"property_title",
				"prop_scroller",
				"Content",
				"prop_text",
				"click"
			])
		this.prop_text.style.fontSize = 20
		this.prop_text.style.color = "#663915"
		this.prop_text.style.leading = 15
		this.prop_scroller.vScrollBar.visible = false
	}
}
window["PetProptityView"] = PetProptityView
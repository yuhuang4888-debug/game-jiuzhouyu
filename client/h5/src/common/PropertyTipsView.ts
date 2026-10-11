import { Util } from "../util/Util"
import { BaseView1 } from "./BaseView1"
import { Enum_UILayer } from "./LayerManager"
import { WordManager } from "./WordManager"

export class PropertyTipsView extends BaseView1 {

	LoadSuccess
	InitEvent
	UpdateView
	SetData
	public constructor() {
		super();
		let local_WordManager = WordManager,
			_title_name,
			attr_list
		this.base_file = "common"
		this.layout_file = "PropertyTipsView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.use_background = true
		this.click_bg_toClose = true
		// this.is_center = true
		// this.verticalCenter = -200
		// this.horizontalCenter = 0
		this.load_callback = function () {
			this.LoadSuccess()
			this.InitEvent()
		}
		this.open_callback = function () {
			this.UpdateView()
		}
		this.destroy_callback = function () {

		}
		this.LoadSuccess = () => {
			this._scroll_attr.vScrollBar.visible = false
			this.display_obj.centerX = 0
			this.display_obj.centerY = -200
		}

		this.InitEvent = () => {

		}

		this.UpdateView = () => {
			this._lb_title.text = _title_name
			let list = attr_list
			if (list && list.length > 0) {
				this._gp_none_conta.visible = false
				this._scroll_attr.visible = true
				let str_list = []

				for (let data of list) {
					str_list.push(local_WordManager.GetProperties(data[0]) + "：<font color='#639c12'>" + local_WordManager.ConvertToPercentValue(data[0], data[1]) + "</font>")
				}
				this._lb_attr.style.fontSize = 24
				this._lb_attr.style.leading = 10
				this._lb_attr.style.color = "#4a3a32"
				this._lb_attr.innerHTML = Util.StrToHTML(str_list.join("<br/>"))
				this._Group1.height = this._lb_attr.contextHeight + 10
			}
			else {
				this._scroll_attr.visible = false
				this._gp_none_conta.visible = true
			}
		}

		this.SetData = (list, title_name = "属性列表") => {
			attr_list = list
			_title_name = title_name
		}
	}
	
	_Image1: Laya.Image
	_scroll_attr: Laya.Panel
	_Group1: Laya.Box
	_lb_attr: Laya.HTMLDivElement
	_gp_none_conta: Laya.HBox
	tips_icon: Laya.Image
	tips: Laya.Label
	_Group2: Laya.Box
	_Image2: Laya.Image
	_lb_title: Laya.Label
	public GetComponents() {
		[
			this._Image1,
			this._scroll_attr,
			this._Group1,
			this._lb_attr,
			this._gp_none_conta,
			this.tips_icon,
			this.tips,
			this._Group2,
			this._Image2,
			this._lb_title,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_scroll_attr",
				"_Group1",
				"_lb_attr",
				"_gp_none_conta",
				"tips_icon",
				"tips",
				"_Group2",
				"_Image2",
				"_lb_title",
			])
	}
}

window["PropertyTipsView"] = PropertyTipsView
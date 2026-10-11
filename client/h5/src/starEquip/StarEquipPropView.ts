import { BaseView1 } from "../common/BaseView1"
import { Util, SetSizeDeltaY } from "../util/Util"
import { Enum_UILayer } from "../common/LayerManager"
import { WordManager } from "../common/WordManager"

export class StarEquipPropView extends BaseView1 {
	InitEvent
	InitView
	LoadSuccess
	Open
	Scr_Scroller1
	_Group1
	data

	public constructor() {
		super()
		this.base_file = "starEquip"
		this.layout_file = "StarEquipPropView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.use_background = true
		this.click_bg_toClose = true
		this.is_center = true
		this.show_open_movie = true

		//let local_Erlang = ErlangParser.GetInstance()
		let local_WordManager = WordManager

		this.load_callback = () => {
			this._Scroller1.vScrollBar.visible = false

			this._lb_attr0.width = 180
			this._lb_attr0.style.fontSize = 22
			this._lb_attr0.style.color = "#663915"
			this._lb_attr0.style.leading = 8

			this._lb_attr1.width = 180
			this._lb_attr1.style.fontSize = 22
			this._lb_attr1.style.color = "#663915"
			this._lb_attr1.style.leading = 8

			this.LoadSuccess()
		}

		this.LoadSuccess = () => {
			if (this.data && this.is_loaded) {
				this.InitEvent()
				this.InitView(this.data)
			}
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._btn_close, () => {
				this.Close()
			}, this, true)
		}
		//type 
		this.Open = (...new_args) => {
			let [props, type] = new_args
			if (type == 1) {
				let list = []
				for (let _tmpi in props) {
					var vo = props[_tmpi]
					list[vo[0]] = vo[1]
				}
				this.data = list
			} else {
				let list = []
				for (let _tmpi in props) {
					var vo = props[_tmpi]
					list[Number(_tmpi)] = vo
				}
				this.data = list
			}
			super.Open()
		}

		this.InitView = (attr_dic?) => {
			let index = 0
			let str0 = ""
			let str1 = ""
			for (let key in attr_dic) {
				var value = attr_dic[key]
				let str = ""
				if (key == "325") {
					str = "强化基础"
				} else if (key == "326") {
					str = "进化基础"
				} else {
					str = local_WordManager.GetProperties(Number(key))
				}
				if (index % 2 == 0) {
					str0 = str0 + str + "：<font color='#179846'>+" + local_WordManager.ConvertToPercentValue(key, value) + "</font><br>"
				} else {
					str1 = str1 + str + "：<font color='#179846'>+" + local_WordManager.ConvertToPercentValue(key, value) + "</font><br>"
				}
				index = index + 1
			}
			this._lb_attr0.innerHTML = str0
			this._lb_attr1.innerHTML = str1
			this._lb_attr0.width = 180
			this._lb_attr1.width = 180
			SetSizeDeltaY(this.Content, 49 * (Math.ceil(index / 2) - 1) + 22)
		}
	}

	bg1: Laya.Image
	_Image1: Laya.Image
	_Label1: Laya.Label
	_Scroller1: Laya.Panel
	Content: Laya.Box
	_lb_attr0: Laya.HTMLDivElement
	_lb_attr1: Laya.HTMLDivElement
	_btn_close: Laya.Image
	public GetComponents() {
		[
			this.bg1,
			this._Image1,
			this._Label1,
			this._Scroller1,
			this.Content,
			this._lb_attr0,
			this._lb_attr1,
			this._btn_close,
		]
			= this.GetChildrenByNames([
				"bg1",
				"_Image1",
				"_Label1",
				"_Scroller1",
				"Content",
				"_lb_attr0",
				"_lb_attr1",
				"_btn_close",
			])
	}
}
window["StarEquipPropView"] = StarEquipPropView
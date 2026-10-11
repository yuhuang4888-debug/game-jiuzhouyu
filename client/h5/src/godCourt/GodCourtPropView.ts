import { BaseView1 } from "../common/BaseView1"
import { Util } from "../util/Util"
import { Enum_UILayer } from "../common/LayerManager"
import { WordManager } from "../common/WordManager"
import { ResManager } from "../common/ResManager"

export class GodCourtPropView extends BaseView1 {
	InitEvent
	InitView
	LoadSuccess
	Open

	data
	nothingImg
	nothingLb

	public constructor() {
		super()
		this.base_file = "godCourt"
		this.layout_file = "GodCourtPropView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.use_background = true
		this.click_bg_toClose = true
		this.is_center = true
		this.show_open_movie = true

		this.load_callback = () => {
			this._lb_attr0.style.fontSize = 20
			this._lb_attr0.style.color = "#663915"
			this._lb_attr0.width = 200
			this._lb_attr0.style.leading = 16
			this._lb_attr1.style.fontSize = 20
			this._lb_attr1.style.color = "#663915"
			this._lb_attr1.width = 200
			this._lb_attr1.style.leading = 16

			this.gp_attr.vScrollBarSkin = ""
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg2, "resource/game/godCourt/other/ui_stsxjc_001.png")

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

		this.Open = (...new_args) => {
			let parms = new_args
			let list = []
			for (let _tmpi in parms[0]) {
				let vo = parms[0][_tmpi]
				if (vo[0] != 331) {
					if (list[vo[0]]) {
						list[vo[0]] = list[vo[0]] + vo[1]
					} else {
						list[vo[0]] = vo[1]
					}
				}
			}
			this.data = list
			super.Open()
		}

		this.InitView = (attr_dic?) => {
			let index = 0
			let str0 = ""
			let str1 = ""
			//let attrtable = []
			for (let key in attr_dic) {
				let value = attr_dic[key]
				let str = null
				if (key == "325") {
					str = "强化基础"
				} else if (key == "326") {
					str = "进化基础"
				} else {
					str = WordManager.GetProperties(Number(key))
				}
				if (index % 2 == 0) {
					str0 = str0 + str + " <font color='#d15e00'>+" + WordManager.ConvertToPercentValue(key, value) + "</font><br>"
				} else {
					str1 = str1 + str + " <font color='#d15e00'>+" + WordManager.ConvertToPercentValue(key, value) + "</font><br>"
				}
				index = index + 1
			}
			this._lb_attr0.innerHTML = str0
			this._lb_attr1.innerHTML = str1
			this._lb_attr0.width = 200
			this._lb_attr1.width = 200
		}
	}

	img_bg: Laya.Image
	_img_bg2: Laya.Image
	img_top: Laya.Image
	lb_title: Laya.Label
	gp_attr: Laya.Panel
	gp_content: Laya.Box
	_lb_attr0: Laya.HTMLDivElement
	_lb_attr1: Laya.HTMLDivElement
	lb_nothing: Laya.Label
	_btn_close: Laya.Image
	public GetComponents() {
		[
			this.img_bg,
			this._img_bg2,
			this.img_top,
			this.lb_title,
			this.gp_attr,
			this.gp_content,
			this._lb_attr0,
			this._lb_attr1,
			this.lb_nothing,
			this._btn_close,
		]
			= this.GetChildrenByNames([

				"img_bg",
				"_img_bg2",
				"img_top",
				"lb_title",
				"gp_attr",
				"gp_content",
				"_lb_attr0",
				"_lb_attr1",
				"lb_nothing",
				"_btn_close",
			])
	}
}
window["GodCourtPropView"] = GodCourtPropView
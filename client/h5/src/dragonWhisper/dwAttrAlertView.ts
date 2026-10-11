import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { Config } from "../common/Config"
import { Util } from "../util/Util"
import { OpenFun } from "../common/OpenFun"
import { WordManager } from "../common/WordManager"
import { HtmlColorTxt } from "../util/Util"
import { ResManager } from "../common/ResManager"
import { RoleManager } from "../commonModel/RoleManager"
import { Enum_ColorUtil_Dark } from "../util/ColorUtil"

export class dwAttrAlertView extends BaseView1 {
	InitEvent
	LoadSuccess
	Local_Open

	public constructor() {
		super()
		this.base_file = "dragonWhisper"
		this.layout_file = "dwAttrAlertView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.use_background = true
		this.is_center = true
		this.click_bg_toClose = true

		// let _model = DragonWhisperModel.GetInstance()
		let local_WordManager = WordManager
		let _attr_list_ = null
		let _func_go_ = null

		this.load_callback = () => {
			this._lb_attr_left.style.fontSize = 22
			this._lb_attr_left.style.color = "#663915"
			this._lb_attr_left.style.leading = 8
			this._lb_attr_right.style.fontSize = 22
			this._lb_attr_right.style.color = "#663915"
			this._lb_attr_right.style.leading = 8

			this.LoadSuccess()
			this.InitEvent()
		}

		this.Local_Open = (parms?) => {
			_attr_list_ = parms[0]
			_func_go_ = parms[1]
			super.Open()
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._btn_close, () => {
				this.Close()
			}
				, this, true)
			Util.AddClickEvent(this._btn_up, () => {
				OpenFun.OpenFunHandler(164)
				this.Close()
			}
				, this, true)
			Util.AddClickEvent(this._btn_cancel, () => {
				this.Close()
			}
				, this, true)
			Util.AddClickEvent(this._btn_go, () => {
				_func_go_()
				this.Close()
			}
				, this, true)
		}

		this.LoadSuccess = () => {
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_tips, "resource/game/dragonWhisper/other/ui_notice_03.png")
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_line, "resource/game/dragonWhisper/other/ui_line.png")

			let attr_list = [50, 51, 52]
			let cfg = Config.PRELOAD_CLIENT_CONFIG.ConfigItemAttr
			let rVo = RoleManager.GetInstance().GetMainRoleVo()
			let str = ""
			let name = null
			let num = null
			let color = null
			let attr = null
			for (let _tmpi in attr_list) {
				let id = attr_list[_tmpi]
				name = local_WordManager.GetProperties(id)
				attr = rVo[cfg[id].mainvo_str]
				num = HtmlColorTxt(attr, Enum_ColorUtil_Dark.GREEN)
				str = str + name + "：" + num + '<br>'
				//table.insert(list, name + "：" + num)
			}
			this._lb_attr_left.innerHTML = Util.StrToHTML(str)
			this._lb_attr_left.width = 200
			str = ""
			for (let _tmpi in _attr_list_) {
				let vo = _attr_list_[_tmpi]
				name = local_WordManager.GetProperties(Number(vo[0]))
				attr = rVo[cfg[Number(vo[0])].mainvo_str]
				color = attr >= Number(vo[1]) && Enum_ColorUtil_Dark.GREEN || Enum_ColorUtil_Dark.RED
				num = HtmlColorTxt(vo[1], color)
				str = str + name + "：" + num + '<br>'
				//table.insert(list, name + "：" + num)
			}
			this._lb_attr_right.innerHTML = str
			this._lb_attr_right.width = 200
		}
	}

	public Open(...new_args) {
		let parms = new_args
		this.Local_Open(parms)
	}

	_img_bg: Laya.Image
	_img_bg2: Laya.Image
	_gp_title: Laya.Image
	_lb_title: Laya.Label
	_btn_close: Laya.Image
	_img_line: Laya.Image
	_uilyts_001: Laya.Image
	_uilyts_002: Laya.Image
	_img_tips: Laya.Image
	_lb_tips: Laya.Label
	_lb_attr_left: Laya.HTMLDivElement
	_lb_attr_right: Laya.HTMLDivElement
	_btn_cancel: Laya.Image
	_lb_cancel: Laya.Label
	_btn_go: Laya.Image
	_lb_go: Laya.Label
	_btn_up: Laya.Image
	_lb_tips1: Laya.Label
	_lb_tips2: Laya.Label
	public GetComponents() {
		[
			this._img_bg,
			this._img_bg2,
			this._gp_title,
			this._lb_title,
			this._btn_close,
			this._img_line,
			this._uilyts_001,
			this._uilyts_002,
			this._img_tips,
			this._lb_tips,
			this._lb_attr_left,
			this._lb_attr_right,
			this._btn_cancel,
			this._lb_cancel,
			this._btn_go,
			this._lb_go,
			this._btn_up,
			this._lb_tips1,
			this._lb_tips2,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_img_bg2",
				"_gp_title",
				"_lb_title",
				"_btn_close",
				"_img_line",
				"_uilyts_001",
				"_uilyts_002",
				"_img_tips",
				"_lb_tips",
				"_lb_attr_left",
				"_lb_attr_right",
				"_btn_cancel",
				"_lb_cancel",
				"_btn_go",
				"_lb_go",
				"_btn_up",
				"_lb_tips1",
				"_lb_tips2",
			])
	}
}
window["dwAttrAlertView"] = dwAttrAlertView
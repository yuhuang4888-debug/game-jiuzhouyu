import { BaseView1 } from "../common/BaseView1"
import { table } from "../common/table"
import { Enum_UILayer } from "../common/LayerManager"
import { Config } from "../common/Config"
import { RoleManager } from "../commonModel/RoleManager"
import { WordManager } from "../common/WordManager"
import { Enum_ColorUtil_Dark } from "../util/ColorUtil"
import { HtmlColorTxt } from "../util/Util"

export class dwAttrView extends BaseView1 {
	InitEvent
	LoadSuccess

	public constructor() {
		super()
		this.base_file = "dragonWhisper"
		this.layout_file = "dwAttrView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.use_background = true
		this.is_center = true
		this.click_bg_toClose = true

		// let _model = DragonWhisperModel.GetInstance()
		this.load_callback = () => {
			this.LoadSuccess()
			this.InitEvent()
		}

		this.InitEvent = () => {
			// Util.AddClickEvent(this._btn_close, () => {
			// 	this.Close()
			// }, this, true)
		}

		this.LoadSuccess = () => {
			this._lb_attr.style.fontSize = 22
			this._lb_attr.style.color = "#4a3a32"
			this._lb_attr.style.leading = 35

			let attr_list = [50, 51, 52]
			let cfg = Config.PRELOAD_CLIENT_CONFIG.ConfigItemAttr
			let rVo = RoleManager.GetInstance().GetMainRoleVo()
			let name = null
			let num = null
			let attr = null
			let str = ""
			let list = []
			for (let _tmpi in attr_list) {
				let id = attr_list[_tmpi]
				name = WordManager.GetProperties(id)
				attr = rVo[cfg[id].mainvo_str]
				num = HtmlColorTxt("+" + attr, Enum_ColorUtil_Dark.GREEN)
				str = str + name + "  " + num + '<br>'
				list.push(attr)
			}
			if (list.length > 0) {
				this._lb_attr.innerHTML = str
			} else {
				this._lb_attr.innerHTML = ""
			}
			this._lb_attr.width = this._lb_attr.contextWidth
			this.gp_content.callLater(() => {
				if(this.use_delete_method) return
				this._lb_attr.event(Laya.Event.RESIZE)
			})
		}
	}

	img_bg: Laya.Image
	img_top: Laya.Image
	lb_title: Laya.Label
	gp_content: Laya.VBox
	_lb_attr: Laya.HTMLDivElement
	public GetComponents() {
		[
			this.img_bg,
			this.img_top,
			this.lb_title,
			this.gp_content,
			this._lb_attr,
		]
			= this.GetChildrenByNames([
				"img_bg",
				"img_top",
				"lb_title",
				"gp_content",
				"_lb_attr",
			])
	}
}
window["dwAttrView"] = dwAttrView
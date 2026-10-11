import { BaseView1 } from "../common/BaseView1";
import { Config } from "../common/Config";
import { Enum_UILayer } from "../common/LayerManager";
import { WordManager } from "../common/WordManager";
import { PartnerAwakeModel } from "../commonModel/PartnerAwakeModel";
import { Util, HtmlColorTxt } from "../util/Util";

export class PartnerAwakeProView extends BaseView1 {
	bg: Laya.Image
	title_bg: Laya.Image
	title: Laya.Label
	pro_con1: Laya.Box
	image1: Laya.Image
	text1: Laya.Label
	pro1: Laya.HTMLDivElement
	pro_con2: Laya.Box
	image: Laya.Image
	text2: Laya.Label
	pro2: Laya.HTMLDivElement
	click: Laya.Image

	data
	model

	public constructor() {
		super()

		this.base_file = "partnerAwake"
		this.layout_file = "PartnerAwakeProView"
		this.layer_value = Enum_UILayer.Activity
		this.is_center = true
		this.destroy_imm = true
		this.use_background = true
		this.click_bg_toClose = true
		this.data = null
		this.model = PartnerAwakeModel.GetInstance()

		this.open_callback = () => {
			this.OpenCallback()
		}
		this.load_callback=()=>{
			this.InitEvent()
		}
	}

	public InitEvent(){
		Util.AddClickEvent(this.click,()=>{
			this.Close()
		},this)
	}
	public OpenCallback(...new_args) {
		let partner_property = Config.PRELOAD_CLIENT_CONFIG.ConfigPartnerAwake.TaskView.partner_property
		this.pro1.innerHTML = Util.StrToHTML(this.GetProStr(partner_property))
		let task_property = Config.PRELOAD_CLIENT_CONFIG.ConfigPartnerAwake.TaskView.task_property
		this.pro2.innerHTML = Util.StrToHTML(this.GetProStr(task_property))
		this.pro1.x=290
		this.pro2.x=290
	}

	public GetProStr(data?) {
		let str = ""
		this.pro1.width=200
		this.pro2.width=200
		if (data) {
			for (let i = 0; i < data.length; i++) {
				let id = data[i].attr_id
				let value = data[i].attr_val
				if (id > 0) {
					if (i == data.length - 1) {
						str = str + WordManager.GetProperties(id) + "&nbsp;" + HtmlColorTxt("&nbsp;+&nbsp;" + WordManager.ConvertToPercentValue(id, value), "'#0a953e'")
					} else {
						str = str + WordManager.GetProperties(id) + "&nbsp;" + HtmlColorTxt("&nbsp;+&nbsp;" + WordManager.ConvertToPercentValue(id, value), "'#0a953e'") + "<br/>"
					}
				}

			}
		}
		return str
	}

	public Open(...new_args) {
		let params = new_args
		super.Open()
	}


	public GetComponents() {
		[
			this.bg,
			this.title_bg,
			this.title,
			this.pro_con1,
			this.image1,
			this.text1,
			this.pro1,
			this.pro_con2,
			this.image,
			this.text2,
			this.pro2,
			this.click
		]
			= this.GetChildrenByNames([

				"bg",
				"title_bg",
				"title",
				"pro_con1",
				"image1",
				"text1",
				"pro1",
				"pro_con2",
				"image",
				"text2",
				"pro2",
				"click"
			])
		this.pro1.style.fontSize=24
		this.pro1.style.color="#4a3a32"
		this.pro1.style.leading=3

		this.pro2.style.fontSize=24
		this.pro2.style.color="#4a3a32"
		this.pro2.style.leading=3

	}
}
window["PartnerAwakeProView"]=PartnerAwakeProView
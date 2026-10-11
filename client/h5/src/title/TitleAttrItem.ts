import { BaseItem1 } from "../common/BaseItem1"
import { WordManager } from "../common/WordManager"
import { Util, HtmlColorTxt, SetHtmlStyle } from "../util/Util"

export class TitleAttrItem extends BaseItem1 {
	need_refresh_data
	now_attr
	next_attr
	public constructor(parent?) {
		super(parent)


		this.need_refresh_data = false;
		this.base_file = "title"
		this.layout_file = "TitleAttrItem"
		this.load_callback = () => {

			this.LoadSuccess()
		}
	}

	public LoadSuccess() {

		SetHtmlStyle(this.now_attr_lb,{c:"#663915",f:20,ww:false,w:500})
		SetHtmlStyle(this.next_attr_lb,{c:"#0a953e",f:20,ww:false,w:500})

		if (this.need_refresh_data) {
			this.need_refresh_data = false
			this.UpdataView()
		}
	}

	public Setdata(now_attr?, next_attr?) {

		this.now_attr = now_attr
		this.next_attr = next_attr
		if (this.is_loaded) {
			this.UpdataView()
		} else {
			this.need_refresh_data = true
		}
	}

	public UpdataView() {
		let now_str = this.SetNowAttr(this.now_attr)
		this.now_attr_lb.innerHTML = Util.StrToHTML(now_str)
		if (this.next_attr.attr_val == 0) {
			this.next_gp.visible = false
		} else {
			this.next_gp.visible = true
			let next_str = this.SetNextAttr(this.next_attr)
			this.next_attr_lb.innerHTML = Util.StrToHTML(next_str)
		}
	}

	public DeleteMe() {
		super.DeleteMe()
	}
	public SetNowAttr(now_attr?) {

		let str = null
		let value = null
		value = WordManager.ConvertToPercentValue(Number(now_attr.attr_id), Number(now_attr.attr_val))
		let value_str = String(value)
		let key = WordManager.GetProperties(now_attr.attr_id) +"："
		if (value_str.indexOf("%") != -1) {
			str = key+HtmlColorTxt(value, "'#fe1a1a'")
		} else {
			str = key+HtmlColorTxt(value, "'#c85a37'")
		}
		return str
	}

	public SetNextAttr(next_attr?) {

		let str = null
		let value = null
		value = WordManager.ConvertToPercentValue(Number(next_attr.attr_id), Number(next_attr.attr_val))
		let value_str = String(value)
		if (value_str.indexOf("%") != -1) {
			str = HtmlColorTxt(value, "'#fe1a1a'")
		} else {
			str = HtmlColorTxt(value, "'#0a953e'") + " "
		}
		return str
	}




next_gp:Laya.Box
_Image1:Laya.Image
next_attr_lb:Laya.HTMLDivElement
now_attr_lb:Laya.HTMLDivElement
public GetComponents() {
[
this.next_gp,
this._Image1,
this.next_attr_lb,
this.now_attr_lb,
]
 = this.GetChildrenByNames([

"next_gp",
"_Image1",
"next_attr_lb",
"now_attr_lb",
])
}
}
 window["TitleAttrItem"]= TitleAttrItem
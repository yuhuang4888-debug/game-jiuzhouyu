
import { BaseItem1 } from "../common/BaseItem1";
import { WordManager } from "../common/WordManager";
import { Util, HtmlColorTxt } from "../util/Util";

export class RebirthSuccessAttrItem extends BaseItem1 {
	alpha
	need_refresh_data
	now_attr
	next_attr
	public constructor(parent?) {
		super(parent)
		this.need_refresh_data = false;
		this.base_file = "reincarnation"
		this.layout_file = "RebirthSuccessAttrItem"
		this.load_callback = () => {
			this.LoadSuccess()
		}
	}

	public LoadSuccess() {
		if (this.need_refresh_data) {
			this.need_refresh_data = false
			this.UpdataView()
		}
	}

	public SetData(now_attr?, next_attr?) {

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
		this.now_attr_lb.style.fontSize = 24
		this.now_attr_lb.style.color = "#d15e00"
		this.now_attr_lb.style.wordWrap = false

		this.now_attr_lb.innerHTML = Util.StrToHTML(now_str)

		let next_str = this.SetNextAttr(this.next_attr)
		this.next_attr_lb.style.fontSize = 24
		this.next_attr_lb.style.color = "#0a953e"
		this.next_attr_lb.style.wordWrap = false
		this.next_attr_lb.innerHTML = Util.StrToHTML(next_str)
		//this.alpha = 0
	}

	public DeleteMe() {
		super.DeleteMe()
	}
	public SetNowAttr(now_attr?) {
		let str = null
		let value = null
		let local_wordMgr = WordManager
		if (now_attr.attr_id == 0) {
			value = 0
			str = "<font color='#663915'>" + local_wordMgr.GetProperties(this.next_attr.attr_id) + "：</font>" + value
		} else {
			value = local_wordMgr.ConvertToPercentValue(Number(now_attr.attr_id), Number(now_attr.attr_val))
			str = "<font color='#663915'>" + local_wordMgr.GetProperties(now_attr.attr_id) + "：</font>" + value
		}
		return str
	}

	public SetNextAttr(next_attr?) {

		let str = null
		let value = null
		value = WordManager.ConvertToPercentValue(Number(next_attr.attr_id), Number(next_attr.attr_val))
		str = HtmlColorTxt(value, "'#0a953e'") + " "
		return str
	}

	now_attr_lb: Laya.HTMLDivElement
	_next_gp: Laya.Box
	next_attr_lb: Laya.HTMLDivElement
	next_img: Laya.Image
	_Image1: Laya.Image
	public GetComponents() {
		[
			this.now_attr_lb,
			this._next_gp,
			this.next_attr_lb,
			this.next_img,
			this._Image1,
		]
			= this.GetChildrenByNames([

				"now_attr_lb",
				"_next_gp",
				"next_attr_lb",
				"next_img",
				"_Image1",
			])
	}
}
window["RebirthSuccessAttrItem"] = RebirthSuccessAttrItem
import { BaseItem1 } from "../common/BaseItem1";
import { ResManager } from "../common/ResManager";
import { SpecialCharKey } from "../common/SpecialCharKey";
import { PlatformManager } from "../PlatformManager";
import { GameResPath } from "../util/GameResPath";
import { RefBoxVLayout, SetHtmlCenter, SetHtmlStyle, Util } from "../util/Util";

export class LoginNoticeItem extends BaseItem1 {
	data_
	small_line_
	need_fresh = false
	FormatStr
	title_width = 630
	html_list_ = []
	public constructor(parent) {
		super(parent);
		this.base_file = "login";
		this.layout_file = "LoginNoticeItem";

		this.load_callback = () => {
			SetHtmlStyle(this._lb_title, { c: "#663915", f: 24, w: this.title_width, lh: 36 })
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_lb, GameResPath.GetIconOtherPath("login", "uity_016j"))

			if (this.need_fresh) {
				this.need_fresh = false
				this.SetData(this.data_, this.small_line_)
			}
		}


		this.FormatStr = (content) => {

			if (content && content.length > 0 && content.indexOf("0x") != -1) {
				let strs = content.split('0x')
				let str = ""
				for (let i = 0; i < strs.length; i++) {
					if (i == 0) {
						str += `${strs[i]}'#`
					} else {
						let temp = strs[i].slice(0, 6)
						let re_str = strs[i].replace(temp, temp + SpecialCharKey.LoginNoticeItem1)
						if (i != strs.length - 1) {
							str += `${re_str}'#`
						} else {
							str += `${re_str}`
						}

					}
				}
				return str
			} else {
				return content
			}
		}
	}
	public SetData(data, small_line?) {
		this.data_ = data
		this.small_line_ = small_line

		if (!this.is_loaded) {
			this.need_fresh = true
			return
		}

		this.ClearHtml()
		if (!data)
			return;
		let setWxEwm = () => {
			let group = new Laya.Box();
			group.width = 552;
			this._gp_details.addChild(group);
			let img = new Laya.Image();
			group.addChild(img);
			//PlatformManager.GetInstance().SetWxEwmBySdk(this, img);
			img.centerX = 0;
			img.width = img.height = 215;
		};

		data = data.split("\n@@");
		this._lb_title.innerHTML = ""
		let desc = data[0];
		if (desc.indexOf("show_wx_img") != -1) {
			setWxEwm();
		} else {
			this._lb_title.innerHTML = Util.StrToHTML(this.FormatStr(data[0]));
			this._lb_title.style.width = this.title_width
		}

		this._img_lb.visible = true
		if (data.length == 1) {
			this._lb_title.width = this.title_width;
			this._lb_title.x = -25;
			this._img_lb.visible = false;
			RefBoxVLayout(this._gp_details, 10, true)
			return;
		}


		let line_word = "&nbsp;&nbsp;&nbsp;&nbsp;"
		for (let i = 1; i < data.length; i++) {
			desc = data[i];
			if (desc.indexOf("show_wx_img") != -1) {
				setWxEwm();
			}
			else {
				let label = this.html_list_[i]
				if (!label) {
					label = new Laya.HTMLDivElement()
					this._gp_details.addChild(label);
					this.html_list_[i] = label
				}

				SetHtmlStyle(label, { w: this.title_width, f: 24, c: "#663915", lh: 36 })
				label.innerHTML = line_word + Util.StrToHTML(this.FormatStr(data[i]));
				label.style.width = this.title_width
				label.height = label.contextHeight
				label.visible = true
			}
		}


		RefBoxVLayout(this._gp_details, 10, true)
	}

	private ClearHtml(){
		if(!this.html_list_||this.html_list_.length<=0)return
		for (let i = 1; i < this.html_list_.length; i++) {
			this.html_list_[i].visible = false
			this.html_list_[i].innerHTML = ""
		}
	}
	public DeleteMe(): void {
		for(let i = 0;i<this._gp_details.numChildren;i++){
			let com = this._gp_details.getChildAt(i)
			if(com){
				com.removeSelf()
				com.destroy()
				com = null
			}
		}
		super.DeleteMe()
	}
	_img_lb: Laya.Image
	_Group1: Laya.Box
	_lb_title: Laya.HTMLDivElement
	_gp_details: Laya.Box
	public GetComponents() {
		[
			this._img_lb,
			this._Group1,
			this._lb_title,
			this._gp_details,
		]
			= this.GetChildrenByNames([

				"_img_lb",
				"_Group1",
				"_lb_title",
				"_gp_details",
			])
	}
}
window["LoginNoticeItem"] = LoginNoticeItem
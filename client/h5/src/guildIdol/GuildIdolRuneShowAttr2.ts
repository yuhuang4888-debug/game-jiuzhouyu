import { BaseItem1 } from "../common/BaseItem1"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { WordManager } from "../common/WordManager"
import { GuildModel } from "../commonModel/GuildModel"
import { GameResPath } from "../util/GameResPath"
import { HtmlColorTxt } from "../util/Util"

export class GuildIdolRuneShowAttr2 extends BaseItem1 {
	LoadSuccess
	setData
	attr = null
    next_attr = null
	public constructor(parent?) {
		super(parent)

		this.base_file = "guildidol"
		this.layout_file = "GuildIdolRuneShowAttr2"
		this.layer_value = Enum_UILayer.UI
		let _model = GuildModel.GetInstance()
		// let attr = null
		// let next_attr = null
		let refresh = false
		this.load_callback = () => {
			
			this.LoadSuccess()
		}

		this.LoadSuccess = () => {
			//ResManager.GetInstance().SetOutsideImageSprite(this, this._bg, GameResPath.GetIcon("guildidol", "uigh_091"), true)
			if (refresh) {
				this.setData(this.attr, this.next_attr)
			}
		}

		this.setData = (_attr?, _next_attr?) => {

			
			this.attr = _attr
			this.next_attr = _next_attr
			if (!this.is_loaded) {
				refresh = true
				return
			}
			this.PreHtml()
			this._lb_left.innerHTML = WordManager.GetProperties(this.attr[0]) + ":" + HtmlColorTxt(WordManager.ConvertToPercentValue(this.attr[0], this.attr[1]), "'#d85d03'") + " "
			let have_next = this.next_attr != null
			this._gp_next.visible = have_next
			if (have_next) {
				this._lb_right.innerHTML = WordManager.ConvertToPercentValue(this.next_attr[0], this.next_attr[1])+""
			}
		}




	}


	PreHtml(){
		this._lb_left.style.color="#663915"
		this._lb_left.style.fontSize=22
		this._lb_left.width=170

		this._lb_right.style.color="#0a953e"
		this._lb_right.style.fontSize=22
		this._lb_right.width=170
	}


	public DeleteMe() {
		super.DeleteMe()
	}

	_bg: Laya.Image
	_lb_left: Laya.HTMLDivElement
	_gp_next: Laya.Box
	_lb_right: Laya.HTMLDivElement
	_img_add: Laya.Image
	public GetComponents() {
		[
			this._bg,
			this._lb_left,
			this._gp_next,
			this._lb_right,
			this._img_add,
		]
			= this.GetChildrenByNames([

				"_bg",
				"_lb_left",
				"_gp_next",
				"_lb_right",
				"_img_add",
			])
	}
}
window["GuildIdolRuneShowAttr2"] = GuildIdolRuneShowAttr2
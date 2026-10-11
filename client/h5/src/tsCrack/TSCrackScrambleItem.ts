import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { EventName } from "../common/EventName"
import { OpenFun } from "../common/OpenFun"
import { ResManager } from "../common/ResManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { HtmlColorTxt, Util } from "../util/Util"

export class TSCrackScrambleItem extends BaseItemRenderer {
	_img_bg: Laya.Image
	_lb_desc: Laya.HTMLDivElement
	_lb_tips: Laya.Label
	_lb_value: Laya.HTMLDivElement
	_gp_btn: Laya.Box
	_Image1: Laya.Image
	_Label1: Laya.Label

	public static width = 602
	public static height = 119
	WIDTH = 610
    HEIGT = 119

	public constructor(parent) {
		super()

		this.base_file = "tsCrack"
		this.layout_file = "TSCrackScrambleItem"
		this.load_callback = () => {
			Util.AddClickEvent(this._gp_btn, () => {
				if (this.data) {
					OpenFun.OpenFunHandler(this.data.open_id)
					GlobalEventSystem.Fire(EventName.CLOSE_VIEW, "TSCrackScrambleView")
				}
			}, this, true)

			Util.AddClickEvent(this._lb_tips, () => {
				if (this.data) {
					GlobalEventSystem.Fire(EventName.OPEN_VIEW, "TSCrackDescView", this.data.mod + "@" + this.data.sub_mod)
				}
			}, this, true)

			this._lb_tips.text = "详情 ..."//"[{text:",) style:{size:24, textColor:"#a376ff", underline:true}]}
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("tsCrack", "uisksh_108"))
		}
		this.Load()
	}



	public dataChanged() {
		if (super.dataChanged()) {
			this._lb_desc.style.fontSize = 20
			this._lb_desc.style.color = "#ffffff"
			this._lb_desc.style.wordWrap = false
			this._lb_desc.innerHTML = this.data.doc
			let max_desc = this.data.max_value
			if (max_desc >= 9999999) {
				max_desc = "无限"
			}
			this._lb_value.style.fontSize = 22
			this._lb_value.style.color = "#774239"
			this._lb_value.style.wordWrap = false
			this._lb_value.innerHTML = Util.StrToHTML("获取上限:" + HtmlColorTxt(this.data.count + "/" + max_desc, "'#ff6600'"))
		}

	}


	public GetComponents() {
		[
			this._img_bg,
			this._lb_desc,
			this._lb_tips,
			this._lb_value,
			this._gp_btn,
			this._Image1,
			this._Label1,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_lb_desc",
				"_lb_tips",
				"_lb_value",
				"_gp_btn",
				"_Image1",
				"_Label1",
			])
	}
}
window["TSCrackScrambleItem"] = TSCrackScrambleItem
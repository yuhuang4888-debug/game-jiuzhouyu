import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { GuildModel } from "../commonModel/GuildModel"
import { RuneTreasureMainView } from "../runeTreasure/RuneTreasureMainView"
import { Util } from "../util/Util"

export class GuildIdolRuneActItem extends BaseItemRenderer {

	_model

	public WIDTH = 516
	public HEIGT = 60
	is_set
	public constructor(parent) {
		super()
		this.is_set = false
		this.base_file = "guildidol"
		this.layout_file = "GuildIdolRuneActItem"
		this._model = GuildModel.GetInstance()
		this.load_callback = () => {
			if (!this.is_set) {
				this.SetData()
				this.is_set = true
			}
		}
		this.Load()
	}

	public dataChanged() {
		if (!super.dataChanged()) return
		if (this.is_loaded) {
			this.is_set = true
			this.SetData()
		} else {
			this.is_set = false
		}
	}

	SetData() {
		if (!this.data) return
		let act = false
		let godRuneDta = this._model.getIdolRune(this._model.RunePos.god_id)
		if (!godRuneDta) {
			return
		}
		for (let key in godRuneDta.achievemetn_lvs) {

			let info = godRuneDta.achievemetn_lvs[key]
			if (info.achievemetn_lv >= this.data.need_lv) {
				act = true
				break
			}
		}
		let color = !act && "'#663915'" || "'#0a953e'"

		this.PreHtml()
		this._lb_left.innerHTML = Util.HtmlColorTxt(`全身铭文Lv.${this.data.need_lv}`, color)
		this._lb_right.innerHTML = Util.HtmlColorTxt(`铭文组合属性加成${this.data.attr_skill}%`, color)
	}

	PreHtml() {
		this._lb_left.style.color = "#663915"
		this._lb_left.style.fontSize = 20
		this._lb_left.width = 180

		this._lb_right.style.color = "#663915"
		this._lb_right.style.fontSize = 20
		this._lb_right.width = 230

	}

_bg:Laya.Image
_lb_left:Laya.HTMLDivElement
_lb_right:Laya.HTMLDivElement
_Image1:Laya.Image
public GetComponents() {
[
this._bg,
this._lb_left,
this._lb_right,
this._Image1,
]
 = this.GetChildrenByNames([

"_bg",
"_lb_left",
"_lb_right",
"_Image1",
])
}
}
 window["GuildIdolRuneActItem"]= GuildIdolRuneActItem
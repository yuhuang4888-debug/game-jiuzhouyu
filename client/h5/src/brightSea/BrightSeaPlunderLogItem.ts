import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { BrightSeaModel } from "../commonModel/BrightSeaModel"
import { RoleManager } from "../commonModel/RoleManager"
import { ColorUtil } from "../util/ColorUtil"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"

export class BrightSeaPlunderLogItem extends BaseItemRenderer {

	model
	need_refresh_data
	role_mgr
	vo

	public WIDTH = 586
	public HEIGT = 46

	public constructor(parent?) {
		super()


		this.base_file = "brightSea"
		this.layout_file = "BrightSeaPlunderLogItem"
		this.model = BrightSeaModel.GetInstance()
		this.role_mgr = RoleManager.GetInstance()
		this.vo = null
		this.need_refresh_data = false

		this.load_callback = () => {

			this.LoadSuccess()
		}
		this.Load()
	}

	public LoadSuccess() {

		//ResManager.GetInstance().SetOutsideImageSprite(this, this._img_line, GameResPath.GetIcon("arena","uijj_018"))
		if (this.need_refresh_data) {
			this.UpdateView()
			this.need_refresh_data = false
		}
	}

	public dataChanged() {

		if (!super.dataChanged()) return
		this.UpdateView()
	}

	public UpdateView() {

		this._selected.visible = this.selected == true

		let guild_name = this.model.GetGuildName(this.data.guild_name)
		this._lb_guild.text = guild_name
		this._lb_level.text = (this.data.role_lv > 370) && (this.data.role_lv - 370) || this.data.role_lv
		this._tm_img.visible = this.data.role_lv > 370

		let color = ColorUtil.GetColorLight(this.data.shipping_id + 1,false)
		this._lb_ship.color = color
		this._lb_ship.text = this.model.GetShipName(this.data.shipping_id)
		this._lb_name.text = this.data.role_name

		let fighting = this.role_mgr.GetMainRoleVo().fighting
		let five_rate = fighting * 1.05
		let four_rate = fighting * 1.04
		let eighty_five_rate = fighting * 0.85

		if (this.data.power > five_rate) {
			color = "#ff4f50"
		} else if (this.data.power >= eighty_five_rate && this.data.power <= four_rate) {
			//color = "#ffffff"
		} else if (this.data.power < eighty_five_rate) {
			color = "#639c12"
		}
		if (color) {
			this._lb_fight.color=color
			this._lb_fight.text =this.data.power+""
		} else {
			this._lb_fight.color="#d15e00"
			this._lb_fight.text = this.data.power
		}
	}

	public DeleteMe() {
		super.DeleteMe()
	}


_img_line:Laya.Image
_selected:Laya.Image
_lb_name:Laya.Label
_lb_level:Laya.Label
_tm_img:Laya.Image
_lb_guild:Laya.Label
_lb_ship:Laya.Label
_lb_fight:Laya.Label
public GetComponents() {
[
this._img_line,
this._selected,
this._lb_name,
this._lb_level,
this._tm_img,
this._lb_guild,
this._lb_ship,
this._lb_fight,
]
 = this.GetChildrenByNames([

"_img_line",
"_selected",
"_lb_name",
"_lb_level",
"_tm_img",
"_lb_guild",
"_lb_ship",
"_lb_fight",
])
}
}
 window["BrightSeaPlunderLogItem"]= BrightSeaPlunderLogItem
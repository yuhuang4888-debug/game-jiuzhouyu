import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { GuildModel, GuildEvent } from "../commonModel/GuildModel"
import { Color } from "../util/Util"

export class GuildIdolMainTab extends BaseItemRenderer {

	_model

	public WIDTH = 150
	public HEIGT = 54
	is_set
	public constructor(parent) {
		super()

		this.is_set = false
		this.base_file = "guildidol"
		this.layout_file = "GuildIdolMainTab"
		this.load_callback = () => {

			this.InintEvent()
			if (!this.is_set) {
				this.SetData()
				this.is_set = true
			}
		}
		this.Load()
	}

	public InintEvent() {

		this._model = GuildModel.GetInstance()

		this.BindEvent(this._model, GuildEvent.IDOL_TAB_RED_UPDATE, (god_id?) => {
			if (this._model.select_item == god_id) {
				this.updateRed()
			}
		}
		)

		this.BindEvent(this._model, GuildEvent.IDOL_TAB_ALL_RED_UPDATE, (god_id?) => {
			this.updateRed()
		}
		)
	}

	public DeleteMe() {
		super.DeleteMe()
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
		let text_color = null
		let img_str = null
		if (this.selected) {
			text_color ="#9b572f"
			img_str = "ui_button_orange"
		} else {
			text_color = "#ffffff"
			img_str = "tab1"
		}
		this._lb_name.text = this._model.IdolTabName(this.data)
		this._lb_name.color = text_color
		//this._Image1.height=this.selected?56:52
		this._Image1.y=this.selected?3:0
		ResManager.GetInstance().SetImageSprite(this, this._Image1, "common4", img_str, true)
		this.updateRed()
	}

	public updateRed() {
		if(!this.is_loaded)return
		if(!this.data)return
		let god_id = this._model.select_item
		let red_bool = this._model.IdolTabRed(this.data, god_id)
		this._red.visible = red_bool
	}

	_Image1: Laya.Image
	_lb_name: Laya.Label
	_red: Laya.Image
	public GetComponents() {
		[
			this._Image1,
			this._lb_name,
			this._red,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_lb_name",
				"_red",
			])
	}
}
window["GuildIdolMainTab"] = GuildIdolMainTab
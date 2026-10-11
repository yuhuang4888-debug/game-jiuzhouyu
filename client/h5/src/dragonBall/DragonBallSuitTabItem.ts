import { BaseItem1 } from "../common/BaseItem1"
import { Config } from "../common/Config"
import { Util, SetLocalScale, HtmlColorTxt, SetHtmlCenter } from "../util/Util"
import { ResManager } from "../common/ResManager"
import { DragonBallModel } from "../commonModel/DragonBallModel"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { GameResPath } from "../util/GameResPath"

export class DragonBallSuitTabItem extends BaseItemRenderer {
	WIDTH = 174
	HEIGT = 71

	model: DragonBallModel
	res_mgr: ResManager
	public constructor() {
		super()

		this.base_file = "dragonBall"
		this.layout_file = "DragonBallSuitTabItem"

		this.model = DragonBallModel.GetInstance()
		this.res_mgr = ResManager.GetInstance()

		this.load_callback = () => {

			this._html_name.style.color = "#9b572f"
			this._html_name.style.fontSize = 22
			this._html_name.style.wordWrap = false
			this._html_name.style.align = "center"
			this._html_name.style.bold = true
			this.InitEvent()
		}
		this.Load()
	}

	public UpdateItem() {
		this.UpdateRed()
	}

	public InitEvent() {

		this.BindEvent(this.model, DragonBallModel.REFRESH_SUIT_LEVEL_UP_RED, (type) => {
			if (this.model.GetStatueActiveState() && this.data && type == this.data.type) {
				this.UpdateRed()
			}
		})


		this.BindEvent(this.model, DragonBallModel.RecvFmt14303, (type) => {
			if (this.model.GetStatueActiveState()) {
				this.UpdateLv()
			}
		})

	}

	public dataChanged() {
		if (super.dataChanged()) {
			this._img_bg.skin = GameResPath.GetIcon("dragonBall", this.selected ? "ui_ly_07" : "ui_ly_08")

			this.UpdateLv()
			this.UpdateRed()
		}
	}

	public UpdateLv(){
		let data = this.data
		if(data){
			let config_dragon_ball_figure = Config.PRELOAD_SERVER_CONFIG.config_dragon_ball_figure
			let show_lv = data.lv > 0 ? data.lv : 1
			let cur_cfg = config_dragon_ball_figure[`${data.type}@${show_lv}`]
	
			this._html_name.style.color = this.selected ? "#9b572f" : "#ffffff"
			this._html_name.innerHTML = `${cur_cfg.name}<br>${HtmlColorTxt(`Lv${data.lv}`, this.selected ? "'#f88827'" : "'#ffe55a'")}`
			SetHtmlCenter(this._html_name, {w :174})
		}
	}

	public UpdateRed(){
		if(this.data){
			if (this.model.suit_level_up_red_dic[this.data.type]) {
				this._img_red.visible = true
			}
			else {
				this._img_red.visible = false
			}
		}
	}


	_img_bg: Laya.Image
	_html_name: Laya.HTMLDivElement
	_img_red: Laya.Image
	public GetComponents() {
		[
			this._img_bg,
			this._html_name,
			this._img_red,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_html_name",
				"_img_red",
			])
	}
}
window["DragonBallSuitTabItem"] = DragonBallSuitTabItem
import { BaseItem1 } from "../common/BaseItem1"
import { ResManager } from "../common/ResManager"
import { DailyModel } from "../commonModel/DailyModel"
import { ColorUtil } from "../util/ColorUtil"
import { Util } from "../util/Util"
import { DailyEvent } from "./DailyEvent"

export class DailyStrongerTab extends BaseItem1 {
	_model
	cfg_finish
	data
	index_cache

	public constructor(parent) {
		super(parent)
		this.cfg_finish = false;
		this.base_file = "daily"
		this.layout_file = "DailyStrongerTab"
		this._model = DailyModel.GetInstance()
		this.is_delay_callback = false

		this.load_callback = ()=> {

			this.InitEvents()
		}
	}

	

	public InitEvents() {
		let btn_fun = () => {
			if (this.data) {
				this._model.Fire(DailyEvent.DAILY_STRONG_TAB_CLICK, this.data)
			}
		}
		Util.AddClickEvent(this._Image1, btn_fun, this)

		let select_fun = (index?) => {
			this.SetSelected(index)
		}
		this.BindEvent(this._model, DailyEvent.DAILY_STRONG_TAB_CLICK, select_fun)

		if (this.cfg_finish) {
			this.SetData(this.data)
			this.cfg_finish = false
		}
	}
	public SetData(data?) {
		this.data = data
		if (this.is_loaded) {
			if (this.data) {
				this._lb.text = this._model.strongerTabName[this.data - 1]
			}
			this.SetSelected(this._model.strong_tab)
			
			if (this.index_cache != null) {
				this.SetSelected(this.index_cache)
				this.index_cache = null
			}
			// if (this._model.strong_tab == this.data){
				
			// }
		} else {
			this.cfg_finish = true
		}

	}

	public SetSelected(index?) {
		if (this.is_loaded && this.data) {
			console.log("被选中了////////////-:", index, this.data)
			let img_source = (index == this.data) && "ui_btn_achv_highlight" || "ui_btn_achv"
			ResManager.GetInstance().SetImageSprite(this, this._Image1, "common4_asset", img_source)
			this._lb.color = ColorUtil.TryParseHtmlString(index == this.data && "#9b572f" || "#ffffff")
			// this._lb.stroke = 2
			// this._lb.strokeColor = ColorUtil.TryParseHtmlString(index == this.data && "#D56D28" || "#764736")
		} else {
			this.index_cache = index
		}
	}

	public DeleteMe() {

		super.DeleteMe()
	}

	_Image1: Laya.Image
	_lb: Laya.Label
	public GetComponents() {
		[
			this._Image1,
			this._lb,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_lb",
			])
	}
}
window["DailyStrongerTab"] = DailyStrongerTab
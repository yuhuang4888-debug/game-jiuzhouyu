import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { ColorUtil } from "../util/ColorUtil"
import { chcModel } from "../commonModel/chcModel"

export class chcTypeBtn extends BaseItemRenderer {
	UpdateRed
	_model
	need_refresh = false
	WIDTH = 130
	HEIGT = 45

	public constructor() {
		super()
		this.base_file = "chc"
		this.layout_file = "chcTypeBtn"
		this._model = chcModel.GetInstance()

		this.load_callback = () => {
			this.BindEvent(this._model, chcModel.UPDATE_RED, () => {
				this.UpdateRed()
			})

			this.BindEvent(this._model, chcModel.UPDATE_MASTER, () => {
				this.UpdateRed()
			})
			if(this.need_refresh){
				this.dataChanged()
			}
		}

		this.UpdateRed = () => {
			if(!this.data){
				return
			}
			let data = this.data
			let bool = chcModel.GetInstance().GetReddotByStype(data.type, data.vo.page)
			this._reddot.visible = bool
		}
		this.Load()
	}

	public dataChanged() {
		if(!this.data){
			return
		}
		if(!this.is_loaded){
			this.need_refresh = true
			return
		}
		let data = this.data
		//this._lb_name.text = data.vo.normal_name
		this._lb_name.text = data.name
		if (this.selected) {
			ResManager.GetInstance().SetImageSprite(this, this._Image1, "chc", "ui_role_btn_1", true)
			this._lb_name.color = ColorUtil.TryParseHtmlString("#9b572f")
			//this.Out_lb_name.effectColor = ColorUtil.TryParseHtmlString("#d68447")
		} else {
			ResManager.GetInstance().SetImageSprite(this, this._Image1, "chc", "ui_role_btn_2", true)
			this._lb_name.color = ColorUtil.TryParseHtmlString("#d7d9ed")
			//this.Out_lb_name.effectColor = ColorUtil.TryParseHtmlString("#967d6c")
		}
		this.UpdateRed()
	}

	_Image1: Laya.Image
	_reddot: Laya.Image
	_lb_name: Laya.Label
	public GetComponents() {
		[
			this._Image1,
			this._reddot,
			this._lb_name,
		]
			= this.GetChildrenByNames([
				"_Image1",
				"_reddot",
				"_lb_name",
			])
	}
}
window["chcTypeBtn"] = chcTypeBtn
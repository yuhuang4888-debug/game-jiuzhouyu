import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { ColorUtil } from "../util/ColorUtil"
import { chcModel } from "../commonModel/chcModel"

export class chcFuncBtn extends BaseItemRenderer {
	_model
	need_refresh = false
	WIDTH = 141
	HEIGT = 52

	public constructor() {
		super()
		this.base_file = "chc"
		this.layout_file = "chcFuncBtn"
		this._model = chcModel.GetInstance()

		this.load_callback = () => {
			this.BindEvent(this._model, chcModel.UPDATE_RED, () => {
				this.UpdateRed()
			})

			this.BindEvent(this._model, chcModel.UPDATE_MASTER, () => {
				this.UpdateRed()
			})
			
			if(this.need_refresh){
				this.need_refresh = false
				this.dataChanged()
			}
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
		this._lb_name.text = this._model.GetTypeStr(data.id)
		if (this.selected) {
			ResManager.GetInstance().SetImageSprite(this, this._Image, "common", "uian_001a", true)
			this._lb_name.strokeColor = "#3E9298"
			//this.Out_lb_name.effectColor = ColorUtil.TryParseHtmlString("#f14921")
		} else {
			ResManager.GetInstance().SetImageSprite(this, this._Image, "common", "uian_001b")
			this._lb_name.strokeColor = "#6873A8"
			//this.Out_lb_name.effectColor = ColorUtil.TryParseHtmlString("#905c54")
		}
		this.UpdateRed()
	}

	public UpdateRed() {
		if(!this.data){
			return
		}
		let bool = this._model.GetReddotByType(this.data.id)
		this._reddot.visible = bool
	}

	_Image: Laya.Image
	_reddot: Laya.Image
	_lb_name: Laya.Label
	public GetComponents() {
		[
			this._Image,
			this._reddot,
			this._lb_name,
		]
			= this.GetChildrenByNames([
				"_Image",
				"_reddot",
				"_lb_name",
			])
	}
}
window["chcFuncBtn"] = chcFuncBtn
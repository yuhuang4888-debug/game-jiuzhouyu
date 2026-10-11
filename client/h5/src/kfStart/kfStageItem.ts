import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { Util } from "../util/Util"
import { ResManager } from "../common/ResManager"
import { kfStageModel } from "../commonModel/kfStageModel"

export class kfStageItem extends BaseItemRenderer {
	WIDTH = 615
	HEIGT = 105

	res_mgr
	model
	cfg_icon

	public constructor() {
		super()
		this.base_file = "kfStart"
		this.layout_file = "kfStageItem"

		this.res_mgr = ResManager.GetInstance()
		this.model = kfStageModel.GetInstance()

		this.load_callback = () => {
			this.LoadSuccess()
			this.InitEvent()
		}
		this.Load()
	}

	private LoadSuccess() {
		this.cfg_icon = this.res_mgr.GetGameConfigFromCache(this, "ConfigKFuncIcon", true)
		this.res_mgr.SetOutsideImageSprite(this, this._img_bg, "resource/game/kfStart/other/ui_task_05.png")
	}

	private InitEvent() {
		Util.AddClickEvent(this._btn_kf, () => {
			this.model.Fire(kfStageModel.OPEN_VIEW, "kfStageStartView", this.data)
		}, this, true)
	}

	protected dataChanged() {
		if (!super.dataChanged()) {
			return
		}
		let cur_lb = ""
		let next_lb = ""
		let cur_mod = this.data.mod
		if (cur_mod == 1) {
			cur_lb = "本服模式"
			next_lb = "2服模式"
			if (this.data.module_id == 204){
				next_lb = "8服模式"
			}
		} else if (cur_mod == 2) {
			cur_lb = "2服模式"
			next_lb = "4服模式"
		} else if (cur_mod == 4) {
			cur_lb = "4服模式"
			next_lb = "8服模式"
		} else if (cur_mod == 8) {
			cur_lb = "8服模式"
			next_lb = "敬请期待"
		}
		this._lb_now.text = cur_lb
		this._lb_next.text = next_lb

		if (this.cfg_icon[this.data.module_id] && this.cfg_icon[this.data.module_id].icon_name) {
			let icon = this.cfg_icon[this.data.module_id].icon_name
			this.res_mgr.SetImageSprite(this, this._img_icon, "icon", icon)
		}
	}

	_img_bg: Laya.Image
	_lb_now: Laya.Label
	_lb_next: Laya.Label
	_btn_kf: Laya.Image
	_lb_kf: Laya.Label
	_img_icon: Laya.Image
	public GetComponents() {
		[
			this._img_bg,
			this._lb_now,
			this._lb_next,
			this._btn_kf,
			this._lb_kf,
			this._img_icon,
		]
			= this.GetChildrenByNames([
				"_img_bg",
				"_lb_now",
				"_lb_next",
				"_btn_kf",
				"_lb_kf",
				"_img_icon",
			])
	}
}
window["kfStageItem"] = kfStageItem
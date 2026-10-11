import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { table } from "../common/table"
import { Status } from "../util/Status"
import { SYTweenLite } from "../util/SYTweenLite"
import { SetAnchoredPositionX, SetSizeDeltaX } from "../util/Util"

export class DropProgress extends BaseView1 {

	end_time
	progress_bar_width
	tween_list

	public constructor() {
		super()

		this.base_file = "mainUI"
		this.layout_file = "DropProgress"
		this.layer_value = Enum_UILayer.Main
		this.destroy_imm = true
		this.change_scene_close = true
		this.back_login_toClose = true

		this.load_callback = () => {

			this.display_obj.anchorX = this.display_obj.anchorY = 0.5
			this.display_obj.centerX = 0
			this.display_obj.bottom = 450
			// this.form.pivot = Vector2(0.5, 0)
			// this.form.anchorMax = Vector2(0.5, 0)
			// this.form.anchorMin = Vector2(0.5, 0)
			// this.form.anchoredPosition = Vector2(0, 450)

			this.progress_bar_width = this._gp_progress.width
		}
		this.open_callback = () => {
			this.StartDrop()
		}

		this.close_callback = () => {
			this.ClearTween()
		}
	}

	StartDrop() {
		this.ClearTween()

		if (!this.tween_list) {
			this.tween_list = []
		}

		this._gp_progress.width = 10

		let left_time = this.end_time - Status.NowTime
		if (left_time < 0) {
			this.Close()
			return
		}
		table.insert(this.tween_list, SYTweenLite.to(this, this._img, SYTweenLite.UiAnimationType.ANCHORED_POSX, 320, left_time))
		table.insert(this.tween_list, SYTweenLite.to(this, this._gp_progress, SYTweenLite.UiAnimationType.WIDTH, this.progress_bar_width, left_time, () => {
			this.Close()
		}))
	}

	ClearTween() {

		if (this.tween_list) {
			for (let _ = 0; _ < this.tween_list.length; _++) {
				var id = this.tween_list[_]
				SYTweenLite.Stop(id)
			}
			this.tween_list = false
		}

	}

	public Open(end_time?) {
		this.end_time = end_time
		super.Open()
	}

	_Image1: Laya.Image
	_gp_progress: Laya.Box
	_progress_bar: Laya.Image
	_img: Laya.Image
	_lb_tips: Laya.Label
	public GetComponents() {
		[
			this._Image1,
			this._gp_progress,
			this._progress_bar,
			this._img,
			this._lb_tips,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_gp_progress",
				"_progress_bar",
				"_img",
				"_lb_tips",
			])
	}
}
window["DropProgress"] = DropProgress
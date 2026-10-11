import { BaseView1 } from "../common/BaseView1"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { MarriageModel, MarriageEvent } from "../commonModel/MarriageModel"
import { TaskModel } from "../commonModel/TaskModel"
import { PlatformManager } from "../PlatformManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameMath } from "../util/GameMath"
import { GameResPath } from "../util/GameResPath"
import { SetSizeDeltaX, SetAnchoredPositionX, GlobalTimerQuest, Util } from "../util/Util"

export class MarriageForeShowView extends BaseView1 {
	InitEvent
	InitView
	model
	show_fly_anim
	is_show_figure
	time_id
	use_background
	time_down

	OpenAnim
	CloseAnim
	is_playing
	off_set_y

	public constructor() {
		super()
		this.base_file = "marriage"
		this.layout_file = "MarriageForeShowView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.append_to_ctl_queue = true;
		this.time_down = 15
		this.model = MarriageModel.GetInstance()
		this.is_playing = false
		this.off_set_y = 650

		this.load_callback = () => {

			ResManager.GetInstance().SetOutsideImageSprite(this, this.bg, GameResPath.GetIcon("marriage", "uijh_0811"))
			this.InitEvent()
			this._box.pos(Laya.stage.width / 2, Laya.stage.height - this.off_set_y)
			this.OpenAnim()

			PlatformManager.GetInstance().EyouDataPlacement(`game_time_2`);
		}

		this.OpenAnim = () => {
			this.is_playing = true
			let scale1 = 0
			let scale2 = 1.3
			let scale3 = 1
			this._box.scale(scale1, scale1)
			Laya.Tween.to(this._box, { scaleX: scale2, scaleY: scale2 }, 200, Laya.Ease.sineInOut, Laya.Handler.create(this, () => {
				Laya.Tween.to(this._box, { scaleX: scale3, scaleY: scale3 }, 150, Laya.Ease.sineInOut, Laya.Handler.create(this, () => {
					this.is_playing = false
					this.InitView()
				}))
			}, null, false))
		}

		this.CloseAnim = () => {
			if (this.is_playing) {
				return
			}

			this.is_playing = true
			//先关闭倒计时
			if (this.time_id) {
				GlobalTimerQuest.CancelQuest(this.time_id)
				this.time_id = null
			}


			this._bg.visible = false
			Laya.Tween.clearAll(this._box)
			let stage_w = Laya.stage.width
			let scale1 = 1
			let scale2 = 0
			let scale3 = 0.6
			this._box.scale(scale1, scale1)
			let target_x = stage_w - 89//MainUIMarriageItem.width/2
			let target_y = 300
			let liu_hai_height = Util.GetLiuhaiHeight()
			if (liu_hai_height && liu_hai_height > 0) {
				target_y = 300 + liu_hai_height
			}
			target_y += 35  //MainUIMarriageItem.height/2

			//计算时间
			let speed = 1.6//运动速率
			let distance = GameMath.GetDistance(this._box.x, this._box.y, target_x, target_y, true)
			let time = distance / speed

			let data = {
				scaleX: scale2,
				scaleY: scale2,
				x: target_x,
				y: target_y
			}

			let data1 = {
				scaleX: scale3,
				scaleY: scale3,
			}

			//先缩小再移动
			Laya.Tween.to(this._box, data1, 80, Laya.Ease.sineInOut, Laya.Handler.create(this, () => {
				Laya.Tween.to(this._box, data, time, Laya.Ease.sineInOut, Laya.Handler.create(this, () => {
					this.is_playing = false
					this.Close()
				}))
			}, null, false))



		}

		this.close_callback = () => {
			this.task_model.PauseAutoDoTask(false)
			if (this._btn) {
				GlobalEventSystem.Fire(EventName.HIDE_FINGER, this._btn)
			}
		}
		this.destroy_callback = () => {
			Laya.Tween.clearAll(this._box)
			this.time_down = 15
			if (this.time_id) {
				GlobalTimerQuest.CancelQuest(this.time_id)
				this.time_id = null
			}
			if (this.show_fly_anim) {
				this.model.Fire(MarriageEvent.REF_FORESHOW, this.model.GetForeShowIcon(1), this.show_fly_anim)
			}
		}

		this.InitView = () => {
			let ref_timeDown_text = () => {
				this._time_down.text = `跟着主线走，10分钟就能快速75级(${this.time_down}s后关闭)`
			}
			let func = () => {
				if (this.use_delete_method) { return }
				this.time_down = this.time_down - 1
				if (this.time_down <= 0) {
					this.CloseAnim()
				} else {
					ref_timeDown_text()
				}
			}

			this._time_down.visible = !this.is_show_figure
			if (!this.time_id && !this.is_show_figure) {
				this.time_id = GlobalTimerQuest.AddPeriodQuest(func, 1, -1)
			}


			if (this.is_show_figure) {
				let step_cfg = { direction: 8, text: "点击继续任务", "effect_scaleX": 0.65, "effect_scaleY": 0.9, "off_y": 0 }
				GlobalEventSystem.Fire(EventName.SHOW_FINGER, this, this._btn, this.layer_value, null, null, null, null, step_cfg, true)
			}

		}

		this.InitEvent = () => {
			Util.AddClickEvent(this.close, () => {
				this.CloseAnim()
			}, this, true)

			Util.AddClickEvent(this._bg, () => {
				this.CloseAnim()
			}, this, false)

			Util.AddClickEvent(this._btn, () => {
				TaskModel.GetInstance().DoTask()
				this.CloseAnim()
			}, this, true)

			this.BindEvent(GlobalEventSystem, EventName.STATE_RESET_SIZE, (w, h) => {
				if (!this.is_playing) {
					this._box.pos(w / 2, h - this.off_set_y)
				}
			})
		}

	}

	public Open(...new_args) {

		this.show_fly_anim = new_args[0] || false
		this.is_show_figure = new_args[1] || false
		this.task_model.PauseAutoDoTask(true)
		super.Open()
	}



	_bg: Laya.Image
	_box: Laya.Box
	bg: Laya.Image
	close: Laya.Image
	_btn: Laya.Box
	_img_btn: Laya.Image
	_lb_text: Laya.Label
	_time_down: Laya.Label
	public GetComponents() {
		[
			this._bg,
			this._box,
			this.bg,
			this.close,
			this._btn,
			this._img_btn,
			this._lb_text,
			this._time_down,
		]
			= this.GetChildrenByNames([

				"_bg",
				"_box",
				"bg",
				"close",
				"_btn",
				"_img_btn",
				"_lb_text",
				"_time_down",
			])
	}
}
window["MarriageForeShowView"] = MarriageForeShowView
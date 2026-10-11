import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { Status } from "../util/Status"
import { GlobalTimerQuest, Util } from "../util/Util"
import { BaseItem1 } from "../common/BaseItem1"
import { EventName } from "../common/EventName"
import { PlatformManager } from "../PlatformManager"

export class WaitforOpenViewLoading extends BaseItem1 {


	curr_loading_view_dic = {}
	check_time_out_id
	start_show_time
	circle_time_line: Laya.TimeLine
	_timer_id
	_dot_accout
	th_text = "กำลังแยกไฟล์ทรัพยากรในที่นี้"
	public constructor(parent?) {
		super(parent)
		this.base_file = "login"
		this.layout_file = "WaitforOpenViewLoading"
		this.load_callback = () => {
			this.display_obj.centerX = this.display_obj.centerY = 0
			this.InitEvent()
			this.Hide()
		}
	}

	public InitEvent() {
		let onShowWaitforOpenViewLoading = (hash_code?) => {
			this.curr_loading_view_dic[hash_code] = Status.NowTime
			this.Show()
			if (!this.check_time_out_id) {
				this.check_time_out_id = true
				Laya.timer.loop(200, this, this.OnTimer)
			}
		}
		this.BindEvent(GlobalEventSystem,EventName.SHOW_WAITFOR_OPENVIEW_LOADING, onShowWaitforOpenViewLoading)

		let onHideWaitforOpenViewLoading = (hash_code?) => {
			delete this.curr_loading_view_dic[hash_code]
			if (Util.IsTableEmpty(this.curr_loading_view_dic)) {
				this.Hide()
			}
		}
		this.BindEvent(GlobalEventSystem,EventName.HIDE_WAITFOR_OPENVIEW_LOADING, onHideWaitforOpenViewLoading)
	}


	public OnTimer = () => {
		let now_time = Status.NowTime
		if (this.start_show_time && now_time - this.start_show_time >= 0.15) {
			if (!this.GetVisible()) {
				this.SetVisible(true)
			}
		}
		for (let hash_code in this.curr_loading_view_dic) {
			if (now_time - this.curr_loading_view_dic[hash_code] >= 15) {
				delete this.curr_loading_view_dic[hash_code]
			}
		}
		if (Util.IsTableEmpty(this.curr_loading_view_dic)) {
			this.Hide()
		}
	}

	public Show() {
		if (!this.start_show_time) {
			this.start_show_time = Status.NowTime
		}
		this.ClearTimer()
		if (PlatformManager.GetInstance().is_wx_alpha && PlatformManager.IsEyouThPlatform()) {
			this._img_circle.visible = false
			this._dot_accout = 0
			this._lb_loading.fontSize = 36
			this._timer_id = GlobalTimerQuest.AddPeriodQuest(() => {
				this.UpdateTimer()
			}, 1, -1)
			this.UpdateTimer()
			this._lb_loading.x = (this.display_obj.width - this._lb_loading.width) / 2
			return
		}
		if (this._img_circle.rotation == 0) {
			if(!this.circle_time_line){
				this.circle_time_line = new Laya.TimeLine()
			}
			this.circle_time_line.reset()
			this.circle_time_line.addLabel("WaitforOpenViewLoading", 0).to(this._img_circle, {rotation:-360}, 2000, null, 0)
			this.circle_time_line.play(0 , true)
			// Laya.Tween.to(this._img_circle, {rotation: -360}, 2000, Laya.Ease.linearNone, null, null, true)
		}
	}

	public Hide() {
		this.ClearTimer()
		if (this.GetVisible()) {
			this.SetVisible(false)
		}
		this.start_show_time = null
		if (this.check_time_out_id) {
			Laya.timer.clear(this, this.OnTimer)
			this.check_time_out_id = false
		}
		if (this.circle_time_line) {
			this.circle_time_line.destroy()
			this.circle_time_line = undefined
			this._img_circle.rotation = 0
		}
	}
	private UpdateTimer() {
		if (this.use_delete_method) return
		let str = "......"
		let sub_str = this.th_text + str.substring(str.length - this._dot_accout)
		this._lb_loading.text = sub_str
		this._dot_accout++
		if (this._dot_accout >= 4) {
			this._dot_accout = 0
		}
	}
	private ClearTimer() {
		if (this._timer_id) {
			GlobalTimerQuest.CancelQuest(this._timer_id)
			this._timer_id = null
		}
	}

	_img_circle: Laya.Image
	_lb_loading: Laya.Label
	public GetComponents() {
		[
			this._img_circle,
			this._lb_loading,
		]
			= this.GetChildrenByNames([

				"_img_circle",
				"_lb_loading",
			])
	}
}
window["WaitforOpenViewLoading"] = WaitforOpenViewLoading
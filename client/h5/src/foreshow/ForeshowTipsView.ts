import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { OpenFun } from "../common/OpenFun"
import { ResManager } from "../common/ResManager"
import { DailyModel } from "../commonModel/DailyModel"
import { DailyEvent } from "../daily/DailyEvent"
import { ActivityForeshowManager } from "../commonModel/ActivityForeshowManager"
import { GameResPath } from "../util/GameResPath"
import { Util, Trim, GlobalTimerQuest } from "../util/Util"

export class ForeshowTipsView extends BaseView1 {
	InitEvent
	LoadSuccess
	click_bg_toClose
	close_callback
	destroy_callback
	destroy_imm
	initCloseTimer
	initView
	is_center
	onTimer
	open_callback
	removeTimer
	setData
	use_background

	public constructor() {
		super()


		let activity_foreshow_mgr = ActivityForeshowManager.GetInstance()
		let local_OpenFun = OpenFun
		let _activity = null
		let _closeTimer = null
		let _time = 10
		let _isStar = false

		this.base_file = "foreshow"
		this.layout_file = "ForeshowTipsView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.is_center = true
		this.use_background = true
		this.click_bg_toClose = true

		this.load_callback = () => {

			this.InitEvent()
			this.LoadSuccess()
		}

		this.open_callback = () => {
			activity_foreshow_mgr.tips_view_open = true
			DailyModel.GetInstance().Fire(DailyEvent.DAILY_REQUEST_PROTO, 15718)
		}

		this.destroy_callback = () => {
			this.removeTimer()
		}

		this.close_callback = () => {
			activity_foreshow_mgr.tips_view_open = false
			activity_foreshow_mgr.ShowAllTipsView()
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._btn, () => {
				if (_isStar) {
					if (_activity.request_id != 0) {
						local_OpenFun.RequestOpen(_activity.request_id)
					} else {
						local_OpenFun.OpenFunHandler(_activity.jump_id)
					}
				}
				this.Close()
			}
				, this, true)
		}

		this.setData = (activity?, isStar?) => {
			_activity = activity
			_isStar = isStar
			if (this.is_loaded) {
				this.initView()
			}
		}

		this.LoadSuccess = () => {
			ResManager.GetInstance().SetOutsideImageSprite(this, this._bg1, GameResPath.GetIcon("foreshow", "uikfsy_033"))
			ResManager.GetInstance().SetOutsideImageSprite(this, this._bg2, GameResPath.GetIcon("foreshow", "uikfsy_034"))
			this.initView()
		}

		this.initView = () => {
			if (!_activity) {
				return
			}
			ResManager.GetInstance().SetImageSpriteTrans(this, this._icon, GameResPath.GetDailyIconPath(_activity.ac_icon))
			this._lb_desc.text = Trim(_activity.about)
			if (_isStar) {
				this._lb_btn.text = "立即前往"
				this._lb_title.text = "活动开启"
			} else {
				this._lb_btn.text = "知道了"
				this._lb_title.text = "10分钟后开启"
			}
			this.initCloseTimer()
		}

		this.initCloseTimer = () => {

			if (!_closeTimer) {
				_closeTimer = GlobalTimerQuest.AddPeriodQuest(() => {
					this.onTimer()
				}, 1, -1)

				this.onTimer()
			}
		}

		this.onTimer = () => {
			this._lb_close.text = `${_time}S后关闭界面`
			if (_time <= 0) {
				this.removeTimer()
				this.Close()
			}
			_time = _time - 1
		}

		this.removeTimer = () => {

			if (_closeTimer) {
				GlobalTimerQuest.CancelQuest(_closeTimer)
				_closeTimer = null
				_time = 10
			}
		}


	}



	public DeleteMe() {
		super.DeleteMe()
	}

	_bg1: Laya.Image
	_bg2: Laya.Image
	_btn: Laya.Box
	_Image1: Laya.Image
	_lb_btn: Laya.Label
	_Scroller1: Laya.Panel
	_lb_desc: Laya.Label
	_lb_title: Laya.Label
	_icon: Laya.Image
	_lb_close: Laya.Label
	public GetComponents() {
		[
			this._bg1,
			this._bg2,
			this._btn,
			this._Image1,
			this._lb_btn,
			this._Scroller1,
			this._lb_desc,
			this._lb_title,
			this._icon,
			this._lb_close,
		]
			= this.GetChildrenByNames([

				"_bg1",
				"_bg2",
				"_btn",
				"_Image1",
				"_lb_btn",
				"_Scroller1",
				"_lb_desc",
				"_lb_title",
				"_icon",
				"_lb_close",
			])
	}
}
window["ForeshowTipsView"] = ForeshowTipsView
import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { MainUIController } from "../commonController/MainUIController"
import { MainUIModel } from "../commonModel/MainUIModel"
import { RoleManager } from "../commonModel/RoleManager"
import { FirstRechargeModel } from "../commonModel/FirstRechargeModel"
import { SceneManager } from "../scene/SceneManager"
import { Util, SetAnchoredPosition, SetAnchoredPositionX, SetAnchoredPositionY } from "../util/Util"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { SceneEventType } from "../common/EventName"
import { table } from "../common/table"
import { SYTweenFunc } from "../util/SYTweenFunc"
import { SYTweenLite } from "../util/SYTweenLite"
import { GlobalTimerQuest } from "../util/Util"
import { TimeUtil } from "../util/TimeUtil"
import { MainUIManager } from "../common/MainUIManager"
import { Config } from "../common/Config"
import { ViewPopLevelModel } from "../commonModel/ViewPopLevelModel"
import { FirstRechargeNewTipsView } from "./FirstRechargeNewTipsView"

export class FirstRechargeBubble extends BaseView1 {

	bind_id
	canvas
	destroy_callback
	destroy_imm
	e_time
	form
	in_exp_scene
	is_set_order_sorting
	mainUI_controller
	mainUI_model
	model
	need_loading_view
	open_callback
	role_mgr
	scene_mgr
	timer
	tween_id
	tween_list
	tips_item

	public constructor() {
		super()

		this.base_file = "recharge"
		this.layout_file = "FirstRechargeBubble"
		this.layer_value = Enum_UILayer.Main
		this.destroy_imm = true
		this.need_loading_view = false
		this.is_set_order_sorting = false

		this.mainUI_controller = MainUIController.GetInstance()
		this.mainUI_model = MainUIModel.GetInstance()
		this.role_mgr = RoleManager.GetInstance()
		this.model = FirstRechargeModel.GetInstance()
		this.scene_mgr = SceneManager.GetInstance()

		this.timer = null
		this.tween_list = []
		this.in_exp_scene = false
		FirstRechargeModel.GetInstance().no_show_qipao = true
		this.load_callback = () => {
			this.RefViewPos()
			this.LoadSuccess()
		}

		this.open_callback = () => {
		}

		this.close_callback = () => {
		}

		this.destroy_callback = () => {
			this.Remove()
		}
	}

	public RefViewPos() {
		this.display_obj.scale(0.9, 0.9)
	}

	public InitEvent() {

		let local_Move_Time_Interval = MainUIModel.Move_Time_Interval
		let local_MainModel_Instance = this.mainUI_model
		let local_SceneManager_Instance = this.scene_mgr

		Util.AddClickEvent(this._img_bg, () => {
			this.model.Fire(FirstRechargeModel.CLOSE_NEW_TIPS_VIEW)
			ViewPopLevelModel.GetInstance().SetViewPop('FirstRechargeView');
		}, this, false)

		this.bind_id = GlobalEventSystem.Bind(SceneEventType.SCENE_CHANGED, () => {
			let last_scene_id = local_SceneManager_Instance.GetLastSceneId()
			if (local_SceneManager_Instance.IsExpScene() && !local_SceneManager_Instance.IsExpScene(last_scene_id)) {
				this.in_exp_scene = true
				this.SetViewState(true)
			} else if (local_SceneManager_Instance.IsExpScene(last_scene_id) && !local_SceneManager_Instance.IsExpScene()) {
				this.in_exp_scene = false
				let state = !(!local_MainModel_Instance.activity_icon_in_show)
				this.SetViewState(state)
			}

		}
		)

		this.BindEvent(local_MainModel_Instance, MainUIModel.UPDATE_ACTIVITY_STATE, (bool?) => {
			if (this.use_delete_method) {
				return
			}
			if (this.in_exp_scene) {
				return
			}
			if (!this.tween_list) {
				this.tween_list = []
			}
			if (bool) {
				this.display_obj.visible = true
				table.insert(this.tween_list, SYTweenLite.to(this, this.form, SYTweenLite.UiAnimationType.ANCHORED_POSX, 0, local_Move_Time_Interval))
				table.insert(this.tween_list, SYTweenLite.to(this, this.canvas, SYTweenLite.UiAnimationType.ALPHA, 1, local_Move_Time_Interval))
			} else {
				table.insert(this.tween_list, SYTweenLite.to(this, this.form, SYTweenLite.UiAnimationType.ANCHORED_POSX, -160, local_Move_Time_Interval))
				table.insert(this.tween_list, SYTweenLite.to(this, this.canvas, SYTweenLite.UiAnimationType.ALPHA, 0, local_Move_Time_Interval, () => {
					this.display_obj.visible = false
				}))
			}
		}
		)

		this.BindEvent(FirstRechargeModel.GetInstance(), FirstRechargeModel.ADD_FIRST_RECHARGE_NEW_TIPS_ITEM, (is_bubble) => {
			if (is_bubble == true) {
				if (!this.tips_item) {
					this.tips_item = new FirstRechargeNewTipsView(this.display_obj)
				}
				this.tips_item.Load()
			}
		})

		this.BindEvent(FirstRechargeModel.GetInstance(), FirstRechargeModel.REMOVE_FIRST_RECHARGE_NEW_TIPS_ITEM, () => {
			if (this.tips_item) {
				this.tips_item.display_obj.visible = false
				this.tips_item.DeleteMe()
				this.tips_item = null
			}
		})

		let state = !(!local_MainModel_Instance.activity_icon_in_show)
		this.SetViewState(state)
		MainUIManager.GetInstance().AddMoveComponent(this, this.display_obj, true, MainUIManager.MOVE_TYPE.Left)
	}

	public SetViewState(state?) {

		if (this.use_delete_method) {
			return
		}

		SetAnchoredPositionX(this.display_obj, state ? 0 : -160)
		this.display_obj.alpha = state ? 1 : 0
		this.display_obj.visible = state
	}

	public LoadSuccess() {

		this._lb_time.text = TimeUtil.timeConversionWithMillisecond(0, "mm:ss.ms")
		this._lb_info.style.fontSize = 20
		this._lb_info.style.bold = true
		this._lb_info.style.wordWrap = false

		let a
		[this.e_time, a] = this.model.GetBubbleTime()
		this.e_time = this.e_time * 1000
		this.StartTimer()
		this.display_obj.zOrder = 1;
		this.display_obj.bottom = 694
		this.tween_id = SYTweenLite.to(this, this._box_icon, SYTweenLite.UiAnimationType.POSY, this._box_icon.y - 10, 1.5, null, SYTweenFunc.PINGPONG, true)
		this.InitEvent()
	}

	public StartTimer() {
		this.CancelTimer()
		if (!this.timer) {
			this.timer = GlobalTimerQuest.AddPeriodQuest(() => {
				this.OnTimer()
			}, 0.02, -1)
		}
		this.OnTimer()
	}

	public CancelTimer() {
		if (this.timer) {
			GlobalTimerQuest.CancelQuest(this.timer)
			this.timer = null
		}
	}

	public CancelTween() {
		if (this.tween_id) {
			SYTweenLite.Stop(this.tween_id)
			this.tween_id = null
		}

		SetAnchoredPositionY(this._box_icon, 0)
	}

	public OnTimer() {

		let _time = this.e_time - TimeUtil.getServerTimeMs()
		if (_time >= 0) {
			this._lb_time.changeText(TimeUtil.timeConversionWithMillisecond(_time, "mm:ss.ms"))
		} else {
			this.CancelTimer()
			this.model.is_notify = 1
			this.model.Fire(FirstRechargeModel.SCMD_REQUEST, 15907)

			this.model.Fire(FirstRechargeModel.SCMD_REQUEST, 15905)
			this.model.is_bubble = false
			FirstRechargeModel.GetInstance().Fire(FirstRechargeModel.ADD_BUBBLE, false)
		}
	}

	public Remove() {
		this.CancelTimer()
		this.CancelTween()
		if (this.tips_item) {
			this.tips_item.DeleteMe()
			this.tips_item = null
		}
		if (this.tween_list && this.tween_list.length > 0) {
			for (let key in this.tween_list) {
				var tween_id = this.tween_list[key]
				SYTweenLite.Stop(tween_id)
			}
		}
		if (this.bind_id) {
			GlobalEventSystem.UnBind(this.bind_id)
			this.bind_id = null
		}
	}

	_box_icon: Laya.Box
	_img_bg: Laya.Image
	_lb_time: Laya.Label
	_img_tips: Laya.Image
	_lb_info: Laya.HTMLDivElement
	public GetComponents() {
		[
			this._box_icon,
			this._img_bg,
			this._lb_time,
			this._img_tips,
			this._lb_info,
		]
			= this.GetChildrenByNames([
				"_box_icon",
				"_img_bg",
				"_lb_time",
				"_img_tips",
				"_lb_info",
			])
	}
}
window["FirstRechargeBubble"] = FirstRechargeBubble
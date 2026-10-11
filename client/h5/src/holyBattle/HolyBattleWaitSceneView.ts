import { Alert, Alert_Type } from "../alert/Alert"
import { BaseView1 } from "../common/BaseView1"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { LuaSoundManager } from "../common/SoundManager"
import { table } from "../common/table"
import { HolyBattleModel } from "../commonModel/HolyBattleModel"
import { MainUIModel } from "../commonModel/MainUIModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { SYTweenLite } from "../util/SYTweenLite"
import { TimeUtil } from "../util/TimeUtil"
import { SetSizeDelta, HtmlColorTxt, Util, GetSizeDeltaX, GlobalTimerQuest, SetAnchoredPositionX, SetHtmlStyle } from "../util/Util"

export class HolyBattleWaitSceneView extends BaseView1 {
	CancelCountDown
	InitEvent
	LoadSuccess
	Remove
	StartCountDown
	UpdateExp
	UpdateRewardRed
	UpdateTime
	destroy_callback
	//is_center
	tween_list
	ClearAnim

	public constructor() {
		super()


		this.base_file = "holyBattle"
		this.layout_file = "HolyBattleWaitSceneView"
		this.layer_value = Enum_UILayer.Main
		//this.is_center = true
		this.tween_list = []

		let local_HolyBattleModel_Instance = HolyBattleModel.GetInstance()
		let local_HolyBattleModel = HolyBattleModel
		let local_EventName = EventName
		let local_GlobalEventSystem = GlobalEventSystem
		let local_MainUIModel_Instance = MainUIModel.GetInstance()
		let local_MainUIModel = MainUIModel
		let local_Move_Time_Interval = local_MainUIModel.Move_Time_Interval
		let local_TimeUtil = TimeUtil

		this.load_callback = () => {

			this.LoadSuccess()
		}

		this.destroy_callback = () => {
			this.Remove()
		}

		this.LoadSuccess = () => {
			//ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("holyBattle", "uiswgh_003"))
			SetHtmlStyle(this._lb_desc, { f: 18, c: "#5a1c20", lh: 25, w: 220 })
			this._lb_desc.innerHTML = "在战场中每隔" + HtmlColorTxt(10, "'#009916'") + "秒将自动获得一次" + HtmlColorTxt("经验奖励", "'#009916'") + "。"

			this.UpdateTime()
			this.UpdateRewardRed()
			this.InitEvent()

			local_HolyBattleModel_Instance.Fire(local_HolyBattleModel.REQUEST_PROTO, 21804)
			local_HolyBattleModel_Instance.Fire(local_HolyBattleModel.REQUEST_PROTO, 21811)
		}

		this.InitEvent = () => {
			this.BindEvent(local_HolyBattleModel_Instance, local_HolyBattleModel.UPDATE_EXP_DATA, () => {
				this.UpdateExp()
			}
			)
			this.BindEvent(local_HolyBattleModel_Instance, local_HolyBattleModel.UPDATE_TIME_DATA, () => {
				this.UpdateTime()
			}
			)
			this.BindEvent(local_HolyBattleModel_Instance, local_HolyBattleModel.REFRESH_RED_FLAG, (flag?) => {
				if (flag == local_HolyBattleModel.RedFlag.Open) {

				} else if (flag == local_HolyBattleModel.RedFlag.Reward) {
					this.UpdateRewardRed()
				}
			}
			)
			Util.AddClickEvent(this._img_close, () => {
				Alert.Show("是否确认退出当前玩法场景?", Alert_Type.Two, () => {
					local_HolyBattleModel_Instance.Fire(local_HolyBattleModel.REQUEST_PROTO, 21803)
				}
					, null, "退出", "取消")
			},this, true, null, null, null, null, LuaSoundManager.SOUND_UI.CLOSE)

			Util.AddClickEvent(this._img_play, () => {
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "HolyBattleInstructionView")
			}
				, this, true)
			Util.AddClickEvent(this._img_reward, () => {
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "HolyBattleRewardView")
			}
				, this, true)

			let close_width = GetSizeDeltaX(this._img_close)
			let right_width = GetSizeDeltaX(this._gp_right)
			let left_width = GetSizeDeltaX(this._gp_left)
			this.BindEvent(local_MainUIModel_Instance, local_MainUIModel.UPDATE_ACTIVITY_STATE, (bool?) => {
				this.ClearAnim()
				if (bool) {

					table.insert(this.tween_list, SYTweenLite.to(this, this._img_close, SYTweenLite.UiAnimationType.ANCHORED_POSX, -close_width, local_Move_Time_Interval))
					table.insert(this.tween_list, SYTweenLite.to(this, this._gp_right, SYTweenLite.UiAnimationType.ANCHORED_POSX, right_width, local_Move_Time_Interval))
					table.insert(this.tween_list, SYTweenLite.to(this, this._gp_left, SYTweenLite.UiAnimationType.ANCHORED_POSX, -left_width, local_Move_Time_Interval))
					table.insert(this.tween_list, SYTweenLite.to(this, this._gp_time, SYTweenLite.UiAnimationType.ALPHA, 0, local_Move_Time_Interval))
					this._gp_time.visible = false

				} else {
			
					table.insert(this.tween_list, SYTweenLite.to(this, this._img_close, SYTweenLite.UiAnimationType.ANCHORED_POSX, 10, local_Move_Time_Interval))
					table.insert(this.tween_list, SYTweenLite.to(this, this._gp_right, SYTweenLite.UiAnimationType.ANCHORED_POSX, -10, local_Move_Time_Interval))
					table.insert(this.tween_list, SYTweenLite.to(this, this._gp_left, SYTweenLite.UiAnimationType.ANCHORED_POSX, 5, local_Move_Time_Interval))
					table.insert(this.tween_list, SYTweenLite.to(this, this._gp_time, SYTweenLite.UiAnimationType.ALPHA, 1, local_Move_Time_Interval))
					this._gp_time.visible = true

				}
			}
			)
			let state = local_MainUIModel_Instance.activity_icon_in_show
			SetAnchoredPositionX(this._img_close, state && -close_width || 10)
			SetAnchoredPositionX(this._gp_right, state && right_width || -10)
			SetAnchoredPositionX(this._gp_left, state && -left_width || 5)
			this._gp_time.alpha = state && 0 || 1
			local_MainUIModel_Instance.Fire(local_MainUIModel.CHANGE_ACTIVITY_STATE, false)
		}

		this.UpdateExp = () => {
			this._lb_exp.text = local_HolyBattleModel_Instance.GetExp()
		}

		this.UpdateRewardRed = () => {
			let bool = local_HolyBattleModel_Instance.HasRedFlag(local_HolyBattleModel.RedFlag.Reward)
			this._img_reward_red.visible = bool
		}

		this.UpdateTime = () => {
			let time_data = local_HolyBattleModel_Instance.GetTimeData()

			if (time_data && time_data.status == 1) {
				this.StartCountDown(() => {
					let left_time = time_data.end_time - local_TimeUtil.getServerTime()
					if (left_time < 0) {
						this.CancelCountDown()
						return
					}
					this._lb_last_time.text = `${left_time}s`
					//LayoutRebuilder(this._Group1)
				}
					, 1)
			} else {
				this.CancelCountDown()
			}
		}

		let time_func_ = null
		let time_id_ = null
		this.StartCountDown = (func?, time?) => {
			this.CancelCountDown()
			time_id_ = GlobalTimerQuest.AddPeriodQuest(func, time, -1)
			func()
		}

		this.CancelCountDown = () => {
			if (time_id_) {
				GlobalTimerQuest.CancelQuest(time_id_)
				time_id_ = null
			}
		}

		this.Remove = () => {
			this.CancelCountDown()
			this.ClearAnim()
		}

		this.ClearAnim = () => {
			if (this.tween_list && this.tween_list.length > 0) {
				for (let key in this.tween_list) {
					var tween_id = this.tween_list[key]
					SYTweenLite.Stop(tween_id)
				}
			}
		}

	}

	public DeleteMe() {
		super.DeleteMe()
	}

_box_1:Laya.Box
_gp_left:Laya.Box
_img_bg1:Laya.Image
_lb_desc:Laya.HTMLDivElement
_img_wz_bg:Laya.Image
_txt_wz:Laya.Text
_Image1:Laya.Image
_lb_exp:Laya.Label
_gp_time:Laya.Box
_img_bg:Laya.Image
_Image2:Laya.Image
_lb_last_time:Laya.Label
_box_2:Laya.Box
_img_close:Laya.Image
_box_3:Laya.Box
_gp_right:Laya.Box
_img_reward:Laya.Image
_img_reward_red:Laya.Image
_img_play:Laya.Image
public GetComponents() {
[
this._box_1,
this._gp_left,
this._img_bg1,
this._lb_desc,
this._img_wz_bg,
this._txt_wz,
this._Image1,
this._lb_exp,
this._gp_time,
this._img_bg,
this._Image2,
this._lb_last_time,
this._box_2,
this._img_close,
this._box_3,
this._gp_right,
this._img_reward,
this._img_reward_red,
this._img_play,
]
 = this.GetChildrenByNames([

"_box_1",
"_gp_left",
"_img_bg1",
"_lb_desc",
"_img_wz_bg",
"_txt_wz",
"_Image1",
"_lb_exp",
"_gp_time",
"_img_bg",
"_Image2",
"_lb_last_time",
"_box_2",
"_img_close",
"_box_3",
"_gp_right",
"_img_reward",
"_img_reward_red",
"_img_play",
])
}
}
 window["HolyBattleWaitSceneView"]= HolyBattleWaitSceneView
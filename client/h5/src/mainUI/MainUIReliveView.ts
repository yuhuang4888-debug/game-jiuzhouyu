import { BaseView1 } from "../common/BaseView1"
import { CommonManager } from "../common/CommonManager"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { SoundManager } from "../common/SoundManager"
import { ReliveModel } from "../commonModel/ReliveModel"
import { SceneManager } from "../scene/SceneManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest } from "../util/Util"

export class MainUIReliveView extends BaseView1 {
	CancelCountDown
	GetReliveDuration
	GetReliveType
	InitEvent
	LoadSuccess
	Remove
	SetReliveInfo
	StartCountDown
	background_alpha
	change_scene_close
	destroy_callback
	horizontalCenter
	is_delay_callback
	need_loading_view
	not_close_by_android_back_key
	use_background
	verticalCenter

	public static DEFALUT_RELIVE_TYPE = 22;
	public static REBORN_POINT_TYPE = 1;
	public constructor() {
		super()


		this.base_file = "mainUI"
		this.layout_file = "MainUIReliveView"
		this.layer_value = Enum_UILayer.Activity
		this.use_background = true
		this.background_alpha = 0.5
		this.is_delay_callback = false
		this.change_scene_close = true
		this.horizontalCenter = 0
		this.verticalCenter = 0
		this.need_loading_view = false
		this.not_close_by_android_back_key = true
		let model = ReliveModel.GetInstance()
		let time_id_ = null
		let time_func_ = null
		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName
		let scene_mgr = SceneManager.GetInstance()
		let local_TimeUtil = TimeUtil
		let local_laya = Laya
		let local_MainUIReliveView = MainUIReliveView
		let voice
		this.load_callback = () => {

			this.LoadSuccess()
		}

		this.destroy_callback = () => {
			if (voice) {
				SoundManager.GetInstance().StopSoundEffect(voice)
				voice = null
			}
			
			this.Remove()
		}

		this.LoadSuccess = () => {
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("boss", "com_up_bg2"))
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg2, GameResPath.GetIcon("boss", "up_title_3"))
			this.SetReliveInfo()
			this.InitEvent()

			voice = CommonManager.GetInstance().PlayFightingVoice(1)
		}

		this.InitEvent = () => {
			this.BindEvent(local_GlobalEventSystem, local_EventName.UPDATE_RELIVE_INFO, (next_relive_time?) => {
				this.SetReliveInfo()
			}
			)
		}

		this.SetReliveInfo = () => {
			let is_server_control = model.IsServerControl()
			let relive_type = this.GetReliveType()
			let end_time = null
			if (is_server_control) {
				end_time = scene_mgr.next_relive_time
			} else {
				end_time = this.GetReliveDuration() + local_TimeUtil.getServerTime()
			}
			if (end_time > local_TimeUtil.getServerTime()) {
				this.StartCountDown(() => {
					let left_time = end_time - local_TimeUtil.getServerTime()
					if (left_time < 0) {
						this.CancelCountDown()
						this.Close()
						if (!is_server_control) {
							local_GlobalEventSystem.Fire(local_EventName.RELIVE_BY_TYPE, relive_type)
						}
					} else {
						this._lb_left_count.text = String(left_time)
					}

				}
				)
			}
		}

		this.Remove = () => {
			this.CancelCountDown()
		}

		this.CancelCountDown = () => {
			if (time_id_) {
				GlobalTimerQuest.CancelQuest(time_id_)
			}
		}

		this.StartCountDown = (func?) => {
			this.CancelCountDown()
			time_id_ = GlobalTimerQuest.AddPeriodQuest(func, 1)
			func()
		}

		this.GetReliveType = () => {
			let type = local_MainUIReliveView.DEFALUT_RELIVE_TYPE
			return type
		}

		this.GetReliveDuration = () => {
			return 5
		}


	}


	public DeleteMe() {
		super.DeleteMe()
	}



_img_bg:Laya.Image
_img_bg2:Laya.Image
_lb_left_count:Laya.Label
_lb_des2:Laya.Label
_lb_des:Laya.Label
public GetComponents() {
[
this._img_bg,
this._img_bg2,
this._lb_left_count,
this._lb_des2,
this._lb_des,
]
 = this.GetChildrenByNames([

"_img_bg",
"_img_bg2",
"_lb_left_count",
"_lb_des2",
"_lb_des",
])
}
}
 window["MainUIReliveView"]= MainUIReliveView
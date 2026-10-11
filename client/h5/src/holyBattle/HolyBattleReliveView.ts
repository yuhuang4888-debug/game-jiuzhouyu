import { BaseView1 } from "../common/BaseView1"
import { CommonManager } from "../common/CommonManager"
import { CustomHeadItem } from "../common/CustomHeadItem"
import { EventName } from "../common/EventName"
import { Enum_UILayer, LayerManager } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { SoundManager } from "../common/SoundManager"
import { HolyBattleModel } from "../commonModel/HolyBattleModel"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { Mathf } from "../util/Mathf"
import { TimeUtil } from "../util/TimeUtil"
import { SetSizeDeltaX, Util, GlobalTimerQuest } from "../util/Util"

export class HolyBattleReliveView extends BaseView1 {
	CancelCountDown
	InitEvent
	LoadSuccess
	LocalOpen_
	Remove
	StartCountDown
	UpdateAutoReliveState
	UpdateAutoReliveTime
	UpdateView
	back_login_toClose
	background_alpha
	change_scene_close
	destroy_callback
	destroy_imm
	is_center
	not_close_by_android_back_key
	percentHeight
	percentWidth
	preload_server_config
	use_background

	public constructor() {
		super()


		this.base_file = "holyBattle"
		this.layout_file = "HolyBattleReliveView"
		this.layer_value = Enum_UILayer.Top
		this.destroy_imm = true
		this.is_center = true
		this.use_background = true
		this.background_alpha = 0.8
		this.change_scene_close = true
		this.back_login_toClose = true
		this.not_close_by_android_back_key = true

		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName
		let local_Message = Message
		let local_TimeUtil = TimeUtil
		let local_HolyBattleModel_Instance = HolyBattleModel.GetInstance()
		let local_LayerManager_Instance = LayerManager.GetInstance()
		let _data = null
		let auto_relive_time = null
		let head = null
		let voice
		this.preload_server_config = { "config_holy_spirit_battlefield_kv": false }
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
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("holyBattle", "com_up_bg2"))
			

			this.UpdateView()
			this.InitEvent()

			let effect_width = 262
			let effect_height = 384
			let width = local_LayerManager_Instance.stageWidth
			let height = local_LayerManager_Instance.stageHeight
			let scale_x = width / effect_width
			let scale_y = height / effect_height
			//this.AddUIEffect("ui_frame_white", this.layer_value, this._gp_effect, null, { x=scale_x, y=scale_y }, true)

			voice = CommonManager.GetInstance().PlayFightingVoice(1)
		}

		this.UpdateView = () => {
			let holy_spirit_battlefield_kv_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_holy_spirit_battlefield_kv", false)//Config.Holyspiritbattlefieldkv
			let anger_cfg = holy_spirit_battlefield_kv_cfg && holy_spirit_battlefield_kv_cfg["anger"]
			let max_anger_cfg = holy_spirit_battlefield_kv_cfg && holy_spirit_battlefield_kv_cfg["max_anger"]
			let relive_time = holy_spirit_battlefield_kv_cfg && holy_spirit_battlefield_kv_cfg["relive_time"]
			if (anger_cfg) {
				this._lb_tips3.text = `（死亡+${anger_cfg.values}怒气）`
			}

			SetSizeDeltaX(this._img_progress, _data.anger / Number(max_anger_cfg.values) * 365)
			this._lb_progress.text = _data.anger + "/" + max_anger_cfg.values

			if (head == null) {
				head = new CustomHeadItem(this._img_head)
				head.Load()
			}
			head.SetRoleVoData(_data, _data.turn, _data.server_id, _data.lv)

			this._lb_tips2.text = `很遗憾！您已被${_data.role_name}击杀！`
			this._lb_fighting.text = `战力：${_data.power}`

			let end_time = local_TimeUtil.getServerTime() + Number(relive_time.values)

			this.UpdateAutoReliveTime()

			this.StartCountDown(() => {
				let relive_time = (auto_relive_time && auto_relive_time > 0) && Mathf.Min(end_time, auto_relive_time) || end_time
				let left_time = relive_time - local_TimeUtil.getServerTime()
				if (left_time <= 0) {
					this.CancelCountDown()
					if (local_HolyBattleModel_Instance.auto_relive_state) {
						local_GlobalEventSystem.Fire(local_EventName.RELIVE_BY_TYPE, 1)
					} else {
						local_GlobalEventSystem.Fire(local_EventName.RELIVE_BY_TYPE, 24)
					}
					return
				}
				this._lb_last_time.text = String(left_time)
			}
				, 1)

			this.UpdateAutoReliveState()
		}

		this.Remove = () => {
			this.CancelCountDown()
			if (head) {
				head.DeleteMe()
				head = null
			}
		}

		this.LocalOpen_ = (parms?) => {
			if (parms) {
				_data = parms[0]
			}
			super.Open()
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._gp_back, () => {
				local_GlobalEventSystem.Fire(local_EventName.RELIVE_BY_TYPE, 24)
			}
				, this, true)
			Util.AddClickEvent(this._gp_situ, () => {
				local_GlobalEventSystem.Fire(local_EventName.RELIVE_BY_TYPE, 1)
			}
				, this, true)
			Util.AddClickEvent(this._img_gx, () => {
				local_HolyBattleModel_Instance.auto_relive_state = !local_HolyBattleModel_Instance.auto_relive_state
				this.UpdateAutoReliveState()
				this.UpdateAutoReliveTime()
			}
				, this, true)
			this.BindEvent(local_GlobalEventSystem, local_EventName.SHOWRELIVEWINDOW, (res?) => {
				if (res == 1) {
					this.Close()
				}
			}
			)
		}

		this.UpdateAutoReliveState = () => {
			let img_url = local_HolyBattleModel_Instance.auto_relive_state && "com_ui_gx1" || "com_ui_gx"
			ResManager.GetInstance().SetImageSprite(this, this._img_gx, "common_asset", img_url)
		}

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

		this.UpdateAutoReliveTime = () => {
			if (local_HolyBattleModel_Instance.auto_relive_state) {
				auto_relive_time = local_TimeUtil.getServerTime() + 5
			} else {
				auto_relive_time = 0
			}
		}


	}

	public Open(...new_args) {

		let parms = new_args
		this.LocalOpen_(parms)
	}

	public DeleteMe() {
		super.DeleteMe()
	}


	_gp_effect: Laya.Box
	_Group2: Laya.Box
	_img_bg: Laya.Image
	_img_word: Laya.Image
	_img_head: Laya.Image
	_img_split: Laya.Image
	_img_bar_bg: Laya.Image
	_img_cur: Laya.Image
	_img_arrow: Laya.Image
	_lb_fighting: Laya.Label
	_lb_tips2: Laya.Label
	_lb_last_time: Laya.Label
	_lb_desc: Laya.Label
	_lb_tips3: Laya.Label
	_lb_tips4: Laya.Label
	_img_progress_bg: Laya.Image
	_img_progress: Laya.Image
	_lb_progress: Laya.Label
	_gp_back: Laya.Box
	_Image3: Laya.Image
	_Label2: Laya.Label
	_gp_situ: Laya.Box
	_Image4: Laya.Image
	_Label3: Laya.Label
	_Group1: Laya.Box
	_Image5: Laya.Image
	_Label4: Laya.Label
	_img_gx: Laya.Image
	_Label5: Laya.Label
	public GetComponents() {
		[
			this._gp_effect,
			this._Group2,
			this._img_bg,
			this._img_word,
			this._img_head,
			this._img_split,
			this._img_bar_bg,
			this._img_cur,
			this._img_arrow,
			this._lb_fighting,
			this._lb_tips2,
			this._lb_last_time,
			this._lb_desc,
			this._lb_tips3,
			this._lb_tips4,
			this._img_progress_bg,
			this._img_progress,
			this._lb_progress,
			this._gp_back,
			this._Image3,
			this._Label2,
			this._gp_situ,
			this._Image4,
			this._Label3,
			this._Group1,
			this._Image5,
			this._Label4,
			this._img_gx,
			this._Label5,
		]
			= this.GetChildrenByNames([

				"_gp_effect",
				"_Group2",
				"_img_bg",
				"_img_word",
				"_img_head",
				"_img_split",
				"_img_bar_bg",
				"_img_cur",
				"_img_arrow",
				"_lb_fighting",
				"_lb_tips2",
				"_lb_last_time",
				"_lb_desc",
				"_lb_tips3",
				"_lb_tips4",
				"_img_progress_bg",
				"_img_progress",
				"_lb_progress",
				"_gp_back",
				"_Image3",
				"_Label2",
				"_gp_situ",
				"_Image4",
				"_Label3",
				"_Group1",
				"_Image5",
				"_Label4",
				"_img_gx",
				"_Label5",
			])
			ResManager.GetInstance().LoadFont(this, "holy_battle_fight", this._lb_fighting, null,false)
	}
}
window["HolyBattleReliveView"] = HolyBattleReliveView
import { EventDispatcher } from "../util/EventDispatcher"
import { RedDotManager } from "../common/RedDotManager"
import { ModuleType } from "../common/RedDotManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventName } from "../common/EventName"
import { Scene } from "../scene/Scene"
import { AutoFightManager } from "../autofight/AutoFightManager"
import { BossModel } from "./BossModel"
import { GlobalTimerQuest } from "../util/Util"
import { SceneObj } from "../scene/sceneobj/SceneObj"
import { Vector2 } from "../util/Vector2"
import { RoleManager } from "./RoleManager"
import { ErlangParser } from "../util/ErlangParser"
import { Config } from "../common/Config"

export enum DragonWhisperDefine { 
	OPEN_LV = 660, 
	OPEN_DAY = 60, 
	MODULE_ID = 651, 
	VIP_BUY_TIME = 1, 
	VIP_BUY_COST = 2, 
	FREE_COUNT = 3 
}
window["DragonWhisperDefine"] = DragonWhisperDefine
export enum DrWsEvent {
	PROTO = "DrWsEvent.PROTO",
	UPDATE_VIEW = "DrWsEvent.UPDATE_VIEW",
	UPDATE_RECORD = "DrWsEvent.UPDATE_RECORD",
	BUY_TIME_SUCCESS = "DrWsEvent.BUY_TIME_SUCCESS",
	UPDATE_SCENE = "DrWsEvent.UPDATE_SCENE",
	UPDATE_ENTER = "DrWsEvent.UPDATE_ENTER",
	UPDATE_BOSS_ALIVE = "DrWsEvent.UPDATE_BOSS_ALIVE",
	SELECT_BOSS_ITEM = "DrWsEvent.SELECT_BOSS_ITEM",
	SELECT_FIGHT_ITEM = "SELECT_FIGHT_ITEM"
}
window["DrWsEvent"] = DrWsEvent

export class DragonWhisperModel extends EventDispatcher {
	public static Instance
	public static DrWsTimer = {
		SCENE : {key : "SCENE"},
		TIPS : {key : "TIPS"},
		OUT : {key : "OUT", time : 10}
	}
	CheckAttr
	CheckAttrByMonID
	CheckRedStatus
	ClearTimer
	FindWay
	GetEnterInfo
	GetRedStatus
	GetSceneInfo
	GetSceneMonData
	GetTimerData
	GetViewInfo
	GetViewMapInfo
	Reset
	SetEnterInfo
	SetRedStatus
	SetSceneInfo
	SetViewInfo
	StartTimer

	public constructor() {
		super()
		let res_dot_mgr = RedDotManager.GetInstance()
		let local_ModuleType = ModuleType
		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName
		let auto_fight_mgr = AutoFightManager.GetInstance()
		let scene = Scene.GetInstance()
		let _timer_dic_ = {}
		let _view_info_ = null
		let _scene_info_ = null
		let _enter_info_ = null
		this.Reset = () => {
			_view_info_ = null
			_scene_info_ = null
			_enter_info_ = null
		}

		this.SetViewInfo = (info?) => {
			let dic = []
			for (let _tmpi in info.map_lists) {
				let vo = info.map_lists[_tmpi]
				dic[vo.map_id] = vo
			}
			info["map_dic"] = dic
			_view_info_ = info
			this.CheckRedStatus()
			this.Fire(DrWsEvent.UPDATE_VIEW, info)
		}

		this.GetViewInfo = () => {
			return _view_info_
		}

		this.GetViewMapInfo = (map_id?) => {
			let vinfo = this.GetViewInfo()
			if (!vinfo) {
				return
			}
			return vinfo["map_dic"][map_id]
		}

		this.SetSceneInfo = (info?) => {
			for (let _tmpi in info.mon_list) {
				let vo = info.mon_list[_tmpi]
				this.Fire(DrWsEvent.UPDATE_BOSS_ALIVE, vo)
			}
			_scene_info_ = info
			this.Fire(DrWsEvent.UPDATE_SCENE, info)
		}

		this.GetSceneInfo = () => {
			return _scene_info_
		}

		this.GetSceneMonData = (mon_id?) => {
			let sinfo = this.GetSceneInfo()
			if (!sinfo) {
				return
			}
			for (let _tmpi in sinfo.mon_list) {
				let vo = sinfo.mon_list[_tmpi]
				if (vo.mon_id == mon_id) {
					return vo
				}
			}
		}

		this.SetEnterInfo = (info?) => {
			_enter_info_ = info
			this.Fire(DrWsEvent.UPDATE_ENTER, info)
		}

		this.GetEnterInfo = () => {
			return _enter_info_
		}

		this.SetRedStatus = (active?) => {
			res_dot_mgr.SetRedStatus(local_ModuleType.DRAGON_WHISPER, 1, active)
		}

		this.GetRedStatus = () => {
			return res_dot_mgr.CheckRedStatus(local_ModuleType.DRAGON_WHISPER, 1)
		}

		this.CheckRedStatus = () => {
			let vinfo = this.GetViewInfo()
			if (!vinfo) {
				return
			}
			let last_red = this.GetRedStatus()
			let red = vinfo.left_count > 0
			this.SetRedStatus(red)
			if (last_red != red) {
				local_GlobalEventSystem.Fire(local_EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "BossEnterView", BossModel.Index.Dragon_Boss, red)
				local_GlobalEventSystem.Fire(local_EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 4601)
			}
		}

		this.StartTimer = (key?, delta?, func?) => {
			this.ClearTimer(key)
			let timer = GlobalTimerQuest.AddPeriodQuest(func, delta)
			let data = {func : func, timer : timer}
			_timer_dic_[key] = data
		}

		this.ClearTimer = (key?) => {
			if (_timer_dic_[key]) {
				let data = _timer_dic_[key]
				GlobalTimerQuest.CancelQuest(data.timer)
				_timer_dic_[key] = null
			}
		}

		this.GetTimerData = (key?) => {
			return _timer_dic_[key]
		}

		this.FindWay = (x?, y?) => {
			auto_fight_mgr.SetAutoFight(false)
			let tar_pos = new Vector2(x / SceneObj.GetLogicRealRatio().x, y / SceneObj.GetLogicRealRatio().y)
			scene.MainRoleMove(tar_pos, 2, () => {
				auto_fight_mgr.SetAutoFight(true)
			}
			)
			scene.SetClickTarget(null)
		}

		this.CheckAttr = (attr_list?) => {
			let cfg = Config.PRELOAD_CLIENT_CONFIG.ConfigItemAttr
			let rVo = RoleManager.GetInstance().GetMainRoleVo()
			for (let _tmpi in attr_list) {
				let vo = attr_list[_tmpi]
				if (Number(vo[1]) > rVo[cfg[Number(vo[0])].mainvo_str]) {
					return false
				}
			}
			return true
		}

		this.CheckAttrByMonID = (mon_cfg?, mon_id?) => {
			mon_id = Number(mon_id)
			let md = mon_cfg[mon_id]
			let alist = JSON.parse(md.attr_list)
			return this.CheckAttr(alist)
		}
	}

	public static GetInstance() {
		if (!DragonWhisperModel.Instance) {
			DragonWhisperModel.Instance = new DragonWhisperModel()
		}
		return DragonWhisperModel.Instance
	}
}
window["DragonWhisperModel"] = DragonWhisperModel
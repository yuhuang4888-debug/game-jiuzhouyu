import { AutoFightManager } from "../autofight/AutoFightManager"
import { BaseClass } from "../common/BaseClass"
import { BaseVo } from "../common/BaseVo"
import { EventName } from "../common/EventName"
import { RedDotManager, ModuleType } from "../common/RedDotManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { HolyBattleTowerItem } from "../holyBattle/HolyBattleTowerItem"
import { RoleManager } from "./RoleManager"
import { Scene } from "../scene/Scene"
import { SceneManager } from "../scene/SceneManager"
import { SceneObj } from "../scene/sceneobj/SceneObj"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventDispatcher } from "../util/EventDispatcher"
import { GlobalTimerQuest } from "../util/Util"
import { Vector2 } from "../util/Vector2"


export let kfSingleRankDefine = { OPEN_LV: 460, INSTRUCTION: 507, LAYER_COUNT: 10, COIN_TYPE: 36255094, ACTION_TIME: 3000 }
window["kfSingleRankDefine"] = kfSingleRankDefine
export let kfSREvent = {
	REQUEST_PROTO: "kfSREvent.REQUEST_PROTO",
	UPDATE_TOWER: "kfSREvent.UPDATE_TOWER",
	UPDATE_TOP: "kfSREvent.UPDATE_TOP",
	UPDATE_RW_STATE: "kfSREvent.UPDATE_RW_STATE",
	UPDATE_DUN_DATA: "kfSREvent.UPDATE_DUN_DATA",
	UDPATE_RESULT: "kfSREvent.UDPATE_RESULT",
	START_COUNT_DOWN: "kfSREvent.START_COUNT_DOWN",
	BLACK_CALL_BACK: "kfSREvent.BLACK_CALL_BACK",
}
window["kfSREvent"] = kfSREvent
export let kfSRTimer = { OUT_SCENE: { key: "OUT_SCENE" }, USE_TIME: { key: "USE_TIME" }, KEEP_ON: { key: "KEEP_ON", time: 5 } }
window["kfSRTimer"] = kfSRTimer
export let DUN_NAME =
{
	502001: "恶灵骑士试炼",
	502002: "色虐魔女试炼",
	502003: "森之女王试炼",
	502004: "死灵污王试炼",
	502005: "死亡之翼试炼",
	502006: "毁灭君主试炼"
}
window["DUN_NAME"] = DUN_NAME
export class kfSingleRankModel extends EventDispatcher {
	CheckEnterDun
	CheckRewardRedStatus
	ClearAreaTopData
	ClearAreaTowerData
	ClearDunInfo
	ClearTimer
	GetAreaTopData
	GetAreaTopDataOne
	GetAreaTowerData
	GetAreaTowerDataOne
	GetCurAreaID
	GetCurLevel
	GetCurLevelData
	GetDunData
	GetDunInfo
	GetPlayerInfo
	GetPlayerLevelData
	GetRedStatus
	GetTimerData
	SetAreaTopData
	SetAreaTowerData
	SetDunInfo
	SetPlayerInfo
	SetRedStatus
	StartTimer
	_player_info
	
	public constructor() {
		super()

		let red_dot_mgr = RedDotManager.GetInstance()
		let local_ModuleType = ModuleType
		let _timer_dic_ = []
		let _tween_dic_ = []
		let _dun_info_ = null
		let _area_tower_dic_ = []
		let _area_top_dic_ = []
		this.StartTimer = (key?, delta?, func?) => {
			this.ClearTimer(key)
			// let timer = local_laya. new Timer(delta, 0)
			// timer.addEventListener(local_laya.TimerEvent.TIMER, func, this)
			// timer.start()
			let timer = GlobalTimerQuest.AddPeriodQuest(func, delta / 1000, -1)
			let data = { func: func, timer: timer }
			_timer_dic_[key] = data
		}

		this.ClearTimer = (key?) => {
			if (_timer_dic_[key]) {
				let data = _timer_dic_[key]
				GlobalTimerQuest.CancelQuest(data.timer)
				delete _timer_dic_[key]
			}
		}

		this.GetTimerData = (key?) => {
			// [ts2lua]_timer_dic_下标访问可能不正确
			return _timer_dic_[key]
		}

		this.CheckRewardRedStatus = (scmd?) => {
			red_dot_mgr.ClearRedStatus(local_ModuleType.SINGLE_RANK)
			let red = scmd.rw_state == 0 && scmd.start_level > 1
			this.SetRedStatus(local_ModuleType.SINGLE_RANK, 1, red)
			GlobalEventSystem.Fire(EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 610)
		}

		this.GetRedStatus = (mType?, rType?) => {
			return red_dot_mgr.CheckRedStatus(mType, rType)
		}

		this.SetRedStatus = (mType?, rType?, active?) => {
			red_dot_mgr.SetRedStatus(mType, rType, active)
		}

		this.GetDunData = (cfg?, lv?) => {
			// [ts2lua]cfg下标访问可能不正确
			return cfg && cfg[lv]
		}

		this.SetPlayerInfo = (scmd?) => {
			this.ChangeVar("_player_info", scmd, false, true)
			this.CheckRewardRedStatus(scmd)
		}

		this.GetPlayerInfo = () => {
			return this._player_info
		}

		this.GetPlayerLevelData = (level?) => {
			if (!this._player_info) {
				return
			}
			// [ts2lua]this._player_info下标访问可能不正确
			// [ts2lua]this._player_info["level_dic"]下标访问可能不正确
			return this._player_info["level_dic"][level]
		}

		this.GetCurLevelData = () => {
			if (!this._player_info) {
				return
			}
			return this._player_info.level_list[0]
		}

		this.GetCurLevel = () => {
			if (!this._player_info) {
				return 0
			}
			let ldata = this._player_info.level_list[0]
			// [ts2lua]lua中0和空字符串也是true，此处ldata需要确认
			return (ldata && (ldata.level) || (this._player_info.start_level))
		}

		this.GetCurAreaID = () => {
			let lv = this.GetCurLevel()
			return Math.floor((lv - 1) / kfSingleRankDefine.LAYER_COUNT) + 1
		}

		this.SetAreaTowerData = (scmd?) => {
			// [ts2lua]_area_tower_dic_下标访问可能不正确
			_area_tower_dic_[scmd.area_id] = scmd
			this.Fire(kfSREvent.UPDATE_TOWER, scmd)
		}

		this.GetAreaTowerData = (area_id?) => {
			// [ts2lua]_area_tower_dic_下标访问可能不正确
			return _area_tower_dic_[area_id]
		}

		this.GetAreaTowerDataOne = (area_id?, level?) => {
			let data = this.GetAreaTowerData(area_id)
			if (!data) {
				return
			}
			return data["challenger_dic"][level]
		}

		this.ClearAreaTowerData = () => {
			_area_tower_dic_ = []
		}

		this.SetAreaTopData = (scmd?) => {
			_area_top_dic_[scmd.area_id] = scmd
			this.Fire(kfSREvent.UPDATE_TOP, scmd)
		}

		this.GetAreaTopData = (area_id?) => {
			return _area_top_dic_[area_id]
		}

		this.GetAreaTopDataOne = (area_id?, level?) => {
			let data = this.GetAreaTopData(area_id)
			if (!data) {
				return
			}
			return data["challenger_dic"][level]
		}

		this.ClearAreaTopData = () => {
			_area_top_dic_ = []
		}

		this.SetDunInfo = (scmd?) => {
			_dun_info_ = scmd
			this.Fire(kfSREvent.UPDATE_DUN_DATA, scmd)
		}

		this.GetDunInfo = () => {
			return _dun_info_
		}

		this.ClearDunInfo = () => {
			_dun_info_ = null
		}

		this.CheckEnterDun = (lv?) => {
			if (RoleManager.GetInstance().GetMainRoleVo().team_id != 0) {
				return [false, "组队中不能进入试炼！"]
			}
			if (!SceneManager.GetInstance().IsFieldScene()) {
				return [false, "目前场景不能进入试炼！"]
			}
			let pinfo = this.GetPlayerInfo()
			if (!pinfo) {
				return [false, "没有试炼数据！"]
			}
			let max = pinfo.level_list.length >= kfSingleRankDefine.LAYER_COUNT * 2
			if (max && lv >= this.GetCurLevel() + 1) {
				return [false, "挑战次数不足！"]
			}
			return [true, ""]
		}




	}

	static Instance
	public static GetInstance() {

		if (!kfSingleRankModel.Instance) {
			kfSingleRankModel.Instance = new kfSingleRankModel()
		}
		return kfSingleRankModel.Instance
	}
}

window["kfSingleRankModel"] = kfSingleRankModel
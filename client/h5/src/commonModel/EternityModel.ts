import { EventName } from "../common/EventName"
import { ModuleType, RedDotManager } from "../common/RedDotManager"
import { ResManager } from "../common/ResManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { EventDispatcher } from "../util/EventDispatcher"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest } from "../util/Util"

export const EternityDefine = {
	MON_TYPE_LIST: [1, 2],
	MODULE_ID: 279,
	OPEN_LV: 480,
	BOSS_SCENE: 44001
}
export const EternityEvent = {
	REQUEST_PROTO: "EternityEvent.REQUEST_PROTO",
	UPDATE_PLAYER: "EternityEvent.UPDATE_PLAYER",
	SELECT_MON: "EternityEvent.SELECT_MON",
	UPDATE_GO_STATUS: "EternityEvent.UPDATE_GO_STATUS",
	RELIVE_TIME_UPDATE: "EternityEvent.RELIVE_TIME_UPDATE"
}
export const EternityTimer = {
	PLAYER: "PLAYER",
	SCENE: "SCENE",
	BOSS: "BOSS",
	GOBTN: "GOBTN",
	RELIVE: "RELIVE"
}
export class EternityModel extends EventDispatcher {
	CheckActRedStatus
	ClearTimer
	GetActData
	GetAllRedStatus
	GetDamageData
	GetKVData
	GetMonData
	GetMonDataOne
	GetRankRewardData
	GetReliveData
	GetSceneData
	GetTimerData
	Reset
	SetActData
	SetBuffTimer
	SetDamageData
	SetMonData
	SetReliveData
	StartTimer
	UpdateReliveTimer
	_act_data
	_auto_relive
	_damage_data
	_mon_data
	static Instance
	public constructor() {
		super()


		this._auto_relive = false;
		let local_TimeUtil = TimeUtil
		let local_Number = Number
		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName
		let red_dot_mgr = RedDotManager.GetInstance()
		let local_ModuleType = ModuleType
		let local_EternityTimer = EternityTimer
		let _timer_dic_ = []
		let _relive_data_ = null
		this.Reset = () => {
			this._act_data = null
			this._mon_data = null
			this._damage_data = null
			_relive_data_ = null
			this._auto_relive = false
		}

		this.SetActData = (scmd?) => {
			this.ChangeVar("_act_data", scmd, false, true)
			this.CheckActRedStatus()
		}

		this.GetActData = () => {
			return this._act_data
		}

		this.SetMonData = (scmd?) => {
			scmd.mon_dic = {}
			for (let _tmpi in scmd.mon) {
				var vo = scmd.mon[_tmpi]
				scmd.mon_dic[vo.mon_id] = vo
			}
			this.ChangeVar("_mon_data", scmd, false, true)
		}

		this.GetMonData = () => {
			return this._mon_data
		}

		this.GetMonDataOne = (mon_id?) => {
			if (this._mon_data) {
				return this._mon_data["mon_dic"][mon_id]
			}
		}

		this.SetDamageData = (scmd?) => {
			for (let _tmpi in scmd.hurt_list) {
				var vo = scmd.hurt_list[_tmpi]
				vo.monster_id = scmd.mon_id
			}
			this.ChangeVar("_damage_data", scmd, false, true)
		}

		this.GetDamageData = () => {
			return this._damage_data
		}

		this.SetReliveData = (scmd?) => {
			let cur_time = local_TimeUtil.getServerTime()
			if ((scmd.die_time && scmd.die_time <= cur_time) ||
				(scmd.buffTime && scmd.buffTime <= cur_time)) {
				scmd.die_times = 0
			}
			ResManager.GetInstance().GetGameConfigWithAutoDestory("config_sanctum_kv", (cfg?) => {
				let relivetime = this.GetKVData(cfg, "auto_revive_after_limit")
				scmd.relive_time = scmd.time + local_Number(relivetime)
				let min_times = this.GetKVData(cfg, "die_wait_time")
				let list = JSON.parse(min_times)
				scmd.min_times = local_Number(list[0][1])
				_relive_data_ = scmd
				this.SetBuffTimer()
				this.Fire(EternityEvent.RELIVE_TIME_UPDATE)
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "EternityReliveView", scmd)

			}
			,false)
		}

		this.GetReliveData = () => {
			return _relive_data_
		}

		this.GetKVData = (cfg?, key?) => {
			return cfg[key]["value"]
		}

		this.GetSceneData = (cfg?, scene_id?) => {
			return cfg[scene_id]
		}

		this.GetRankRewardData = (cfg?, mon_id?, rank?) => {
			for (let key in cfg) {

				if (cfg[key].boss_id == mon_id) {
					if (rank <= cfg[key].stage_max && rank >= cfg[key].stage_min) {
						return cfg[key]
					}
				}
			}
		}

		this.StartTimer = (key?, delta?, func?) => {
			this.ClearTimer(key)
			let timer = GlobalTimerQuest.AddPeriodQuest(func, delta, -1)
			let data = { func: func, timer: timer }
			_timer_dic_[key] = data
		}

		this.ClearTimer = (key?) => {
			if (_timer_dic_[key]) {
				let data = _timer_dic_[key]
				if (data && data.timer) {
					GlobalTimerQuest.CancelQuest(data.timer)
				}
				_timer_dic_[key] = null
			}
		}

		this.GetTimerData = (key?) => {
			return _timer_dic_[key]
		}

		this.CheckActRedStatus = () => {
			red_dot_mgr.ClearRedStatus(local_ModuleType.ENTERNITY_RED)
			let adata = this.GetActData()
			if (!adata) {
				return
			}
			let cur_time = local_TimeUtil.getServerTime()
			let red = cur_time >= adata.open_time && cur_time < adata.enter_time
			red_dot_mgr.SetRedStatus(local_ModuleType.ENTERNITY_RED, 1, red)
			local_GlobalEventSystem.Fire(local_EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 6210)
		}

		this.GetAllRedStatus = () => {
			return red_dot_mgr.CheckRedStatus(local_ModuleType.ENTERNITY_RED, 1)
		}

		this.SetBuffTimer = () => {
			let rdata = this.GetReliveData()
			let end_time = rdata && rdata.die_time
			if (end_time && end_time > local_TimeUtil.getServerTime()) {
				let func = () => {
					this.UpdateReliveTimer()
				}
				this.StartTimer(local_EternityTimer.RELIVE, 1, func)
				local_GlobalEventSystem.Fire(local_EventName.UPDATE_MAINUI_BUFF_COUNT)
				this.UpdateReliveTimer()
			}
		}

		this.UpdateReliveTimer = () => {
			let rdata = this.GetReliveData()
			if (!rdata) {
				local_GlobalEventSystem.Fire(local_EventName.UPDATE_MAINUI_BUFF_COUNT)
				this.ClearTimer(local_EternityTimer.RELIVE)
			} else {
				let left_time = rdata.die_time - local_TimeUtil.getServerTime()
				if (left_time < 0) {
					local_GlobalEventSystem.Fire(local_EventName.UPDATE_MAINUI_BUFF_COUNT)
					this.ClearTimer(local_EternityTimer.RELIVE)
				}
			}
		}


	}

	public static GetInstance() {

		if (!EternityModel.Instance) {
			EternityModel.Instance = new EternityModel()
		}
		return EternityModel.Instance
	}

}
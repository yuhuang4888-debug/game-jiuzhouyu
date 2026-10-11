import { CommonManager } from "../common/CommonManager"
import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { CrossServerViewIndex } from "../commonController/BossController"
import { SceneManager } from "../scene/SceneManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { EventDispatcher } from "../util/EventDispatcher"
import { GlobalTimerQuest } from "../util/Util"
import { KfViewIndex } from "./Kf1vnModel"
import { RoleManager } from "./RoleManager"

export class TSCrackModel extends EventDispatcher {
	common_mgr
	last_stronghold_id
	owner_id
	person_rank_data
	red_flag
	role_mgr
	scene_mgr
	scramble_reward_data
	scramble_value_data
	season_reward_data
	server_data
	stronghold_datas
	time_id_list
	value_data
	public select_season_id = 0
	private is_first = true




	public static REQUEST_PROTO = "TSM204.REQUEST_PROTO"
	public static REFRESH_RED_FLAG = "TSM204.REFRESH_RED_FLAG"
	public static UPDATE_STRONGHOLD_DATA = "TSM204.UPDATE_STRONGHOLD_DATA"
	public static UPDATE_VALUE_DATA = "TSM204.UPDATE_VALUE_DATA"
	public static UPDATE_OWNER_ID = "TSM204.UPDATE_OWNER_ID"
	public static UPDATE_SCRAMBLE_VALUE = "TSM204.UPDATE_SCRAMBLE_VALUE"
	public static UPDATE_SCRAMBLE_REWARD = "TSM204.UPDATE_SCRAMBLE_REWARD"
	public static UPDATE_SEASON_REWARD = "TSM204.UPDATE_SEASON_REWARD"
	public static UPDATE_PERSON_RANK = "TSM204.UPDATE_PERSON_RANK"
	public static CLICK_TAB = "TSM204.CLICK_TAB"


	public static InstructionOne = 2041
	public static InstructionTwo = 2042
	// TSCrackModel.RedALLFlag = 0
	public static RefresheDataTime = 30

	public static TimeType = {
		Stronghold: 0
	}

	public static RedFlag = {
		PersonReward: 0x001,
		ServerReward: 0x002,
		Login: 0x004
	}
	static Instance

	public ResetData() {

		this.stronghold_datas = null
		this.value_data = null
		this.red_flag = 0
		this.server_data = null
		this.owner_id = null
		this.scramble_value_data = null
		this.scramble_reward_data = null
		this.season_reward_data = null
		this.person_rank_data = null
		this.last_stronghold_id = null
	}


	public constructor() {
		super()

		if (TSCrackModel.Instance != null) {
			//error("attempt to create singleton(TSCrackModel) twice!")
		}
		TSCrackModel.Instance = this


		this.common_mgr = CommonManager.GetInstance()
		this.scene_mgr = SceneManager.GetInstance()
		this.role_mgr = RoleManager.GetInstance()

		this.ResetData()
	}

	public UpdateAllStrongholdData(scmd20401?) {
		ResManager.GetInstance().GetGameConfigWithAutoDestory("config_chrono_rift_castle", (cfg_) => {
			this.stronghold_datas = []
			let cfg = null
			let index = null
			for (let _tmpi in scmd20401.castle_list) {
				var data = scmd20401.castle_list[_tmpi]

				cfg = cfg_[data.castle_id]

				table.sort(data.server_list, (a?, b?) => {
					return a.value > b.value
				})

				index = 1
				for (let _tmpi in data.server_list) {
					var vo = data.server_list[_tmpi]
					vo.rank = index
					index = index + 1
				}

				table.sort(data.role_list, (a?, b?) => {
					return a.value2 > b.value2
				})

				index = 1
				for (let _tmpi in data.role_list) {
					var vo = data.role_list[_tmpi]
					vo.rank = index
					index = index + 1
				}

				if (cfg) {
					this.stronghold_datas[data.castle_id] = { "stronghold_id": data.castle_id, "need_value": data.need_value, "server_num": data.server_num, "server_name": data.server_name, "server_list": data.server_list, "role_list": data.role_list, "role_num": data.role_num, "provide_num": data.provide_num, "stronghold_name": cfg.name, "lv": cfg.lv, "stronghold_castle": ErlangParser.GetInstance().Parse(cfg.connect_castle), "occupa_add": cfg.occupa_add, "icon": cfg.icon }
				}
			}
			this.Fire(TSCrackModel.UPDATE_STRONGHOLD_DATA)
			this.value_data = {
				"my_value": scmd20401.my_value,
				"my_server_value": scmd20401.my_server_value
			}
			this.Fire(TSCrackModel.UPDATE_VALUE_DATA)
		}, false)

	}

	public UpdateStrongholdData(data?) {

		if (!this.stronghold_datas) {
			this.stronghold_datas = []
		}
		let stronghold_data = this.GetStrongholdDataById(data.castle_id)
		let index = 1

		table.sort(data.server_list, (a?, b?) => {
			return a.value > b.value
		})

		index = 1
		for (let _tmpi in data.server_list) {
			var vo = data.server_list[_tmpi]
			vo.rank = index
			index = index + 1
		}

		table.sort(data.role_list, (a?, b?) => {
			return b.value2 > a.value2
		})

		index = 1
		for (let _tmpi in data.role_list) {
			var vo = data.role_list[_tmpi]
			vo.rank = index
			index = index + 1
		}

		if (stronghold_data) {
			stronghold_data.need_value = data.need_value
			stronghold_data.server_num = data.server_num
			stronghold_data.server_name = data.server_name
			stronghold_data.role_list = data.role_list
			stronghold_data.role_num = data.role_num
			stronghold_data.provide_num = data.provide_num
			this.Fire(TSCrackModel.UPDATE_STRONGHOLD_DATA, data.castle_id)
		}
	}

	public GetStrongholdDataById(stronghold_id?) {

		return this.stronghold_datas && this.stronghold_datas[Number(stronghold_id)]
	}

	public GetStrongholdData() {

		return this.stronghold_datas
	}

	public GetValueData() {

		return this.value_data
	}


	public UpdateServerData(scmd?) {

		this.server_data = scmd
		if (this.server_data) {
			table.sort(this.server_data.server_list, (a?, b?) => {
				return a.server_num < b.server_num
			})
		}
		if (this.is_first) {
			this.is_first = false
			this.SetRedFlag(TSCrackModel.RedFlag.Login, true)
		}
	}

	public GetServerData() {

		return this.server_data
	}

	public GetIndexByServerNum(server_num?) {

		if (this.server_data) {
			let server_data = null
			let index = 1
			for (let key in this.server_data.server_list) {

				server_data = this.server_data.server_list[key]
				if (server_data.server_num == server_num) {
					return index
				}
				index = index + 1
			}
		}
		return 0
	}

	public UpdateOwnerPosId(scmd20410?) {

		this.owner_id = scmd20410.castle_id
		this.Fire(TSCrackModel.UPDATE_OWNER_ID, scmd20410.castle_id)
	}

	public GetOwnerPosId() {

		return this.owner_id
	}

	public UpdateScrambleValue(scmd20404?) {

		this.scramble_value_data = []
		for (let _tmpi in scmd20404.act_list) {
			var vo = scmd20404.act_list[_tmpi]
			this.scramble_value_data[vo.mod + "@" + vo.sub_mod] = vo
		}
		this.Fire(TSCrackModel.UPDATE_SCRAMBLE_VALUE)
	}

	public GetScrambleValue(key?) {

		return (this.scramble_value_data && this.scramble_value_data[key] && this.scramble_value_data[key].value) || 0
	}

	public UpdateScrambleRewardData(scmd20405?) {

		this.scramble_reward_data = scmd20405
		if (this.value_data) {
			this.value_data.my_value = scmd20405.all_value
			this.Fire(TSCrackModel.UPDATE_VALUE_DATA)
		}

		table.sort(this.scramble_reward_data.act_list, (a?, b?) => {
			if (a.status == b.status) {
				return a.stage < b.stage
			} else if (a.status == 1) {
				return true
			} else if (b.status == 1) {
				return false
			} else {
				return a.status < b.status
			}
		})
		this.RefreshPersonRewardRed()
		this.Fire(TSCrackModel.UPDATE_SCRAMBLE_REWARD)
	}

	public GetScrambleRewardData() {

		return this.scramble_reward_data
	}

	public UpdateSeasonRewardData(scmd20407?) {

		this.season_reward_data = scmd20407.act_list
		table.sort(this.season_reward_data, (a?, b?) => {
			if (a.status == b.status) {
				return a.goal_id < b.goal_id
			} else if (a.status == 1) {
				return true
			} else if (b.status == 1) {
				return false
			} else {
				return a.status < b.status
			}
		})

		this.RefreshServerRewardRed()
		this.Fire(TSCrackModel.UPDATE_SEASON_REWARD)
	}

	public GetSeasonRewardData() {

		return this.season_reward_data
	}

	public UpdatePersonRank(scmd20409?) {

		this.person_rank_data = scmd20409.role_list

		table.sort(this.person_rank_data, (a?, b?) => {
			return a.value > b.value
		})

		let index = 1
		for (let _tmpi in this.person_rank_data) {
			var vo = this.person_rank_data[_tmpi]
			vo.rank = index
			index = index + 1
		}
		this.Fire(TSCrackModel.UPDATE_PERSON_RANK)
	}

	public GetPersonRank() {

		return this.person_rank_data
	}

	public GetCountByLv(lv?) {

		let count = 0
		let data = null
		if (this.stronghold_datas) {
			for (let key in this.stronghold_datas) {

				data = this.stronghold_datas[key]
				if ((data && data.lv == lv) && data.server_num == this.role_mgr.GetMainRoleVo().server_id) {
					count = count + 1
				}
			}
		}
		return count
	}

	public CanMove(start_id?, end_id?) {

		let start_data = this.GetStrongholdDataById(start_id)
		let check_dic = []
		let check_func
		check_func = (s_id?, e_id?, is_first_id?) => {
			check_dic[s_id] = true
			let start_data = this.GetStrongholdDataById(s_id)
			if (start_data) {
				for (let _tmpi in start_data.stronghold_castle) {
					var id = start_data.stronghold_castle[_tmpi]
					if (Number(id) == Number(end_id)) {
						let bool = this.HasOwnership(s_id) || this.HasOwnership(e_id)
						return bool
					}
				}
				for (let _tmpi in start_data.stronghold_castle) {
					var id = start_data.stronghold_castle[_tmpi]
					id = Number(id)
					if (!check_dic[id] && ((is_first_id && (this.HasOwnership(id) || this.HasOwnership(e_id)) || (this.HasOwnership(id))))) {
						if (check_func(id, Number(e_id), false)) {
							return true
						}
					}
				}
			}
			return false
		}

		return check_func(start_id, end_id, true)
	}

	public HasOwnership(id?) {

		let data = this.GetStrongholdDataById(id)
		if (data) {
			let server_id = this.role_mgr.GetMainRoleVo().server_id
			return Number(data.server_num) == Number(server_id)
		}
		return false
	}

	public RefreshPersonRewardRed() {

		let bool = false
		let data = this.GetScrambleRewardData()
		for (let _tmpi in data.act_list) {
			var vo = data.act_list[_tmpi]
			if (vo.status == 1) {
				bool = true
				break
			}
		}
		this.SetRedFlag(TSCrackModel.RedFlag.PersonReward, bool)
	}

	public RefreshServerRewardRed() {

		let bool = false
		let data = this.GetSeasonRewardData()
		for (let _tmpi in data) {
			var vo = data[_tmpi]
			if (vo.status == 1) {
				bool = true
				break
			}
		}
		this.SetRedFlag(TSCrackModel.RedFlag.ServerReward, bool)
	}

	public SetRedFlag(flag?, state?) {

		if (!flag) {
			return
		}
		let now_flag = 0
		if (state) {
			now_flag = this.red_flag | flag
		} else {
			now_flag = this.red_flag & ~(flag)
		}
		if (now_flag == this.red_flag) {
			return
		}
		this.red_flag = now_flag
		this.Fire(TSCrackModel.REFRESH_RED_FLAG, flag)
		GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "CrossServerEnterView", CrossServerViewIndex.TSCrack, this.GetRedState())
		//GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "Kf1vnView", CrossServerViewIndex.TSCrack, this.GetRedState())
		GlobalEventSystem.Fire(EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 6210)
	}

	public HasRedFlag(flag?) {

		if (!flag) {
			return false
		}
		return ((this.red_flag & flag) != 0)
	}

	public GetRedState() {

		return this.common_mgr.CheckFuncOpenState("TSCrackMainView", true) && this.red_flag > 0 || false
	}

	public OpenState() {

		return this.server_data && this.server_data.status == 1
	}

	public StartRefreshData() {

		this.StartCountTime(TSCrackModel.TimeType.Stronghold, this.RefreshData, TSCrackModel.RefresheDataTime * 1)
	}

	public CancelRefreshData() {

		this.CancelCountTime(TSCrackModel.TimeType.Stronghold)
	}

	public StartCountTime(type?, func?, time?) {

		if (!this.time_id_list) {
			this.time_id_list = {}
		}
		this.CancelCountTime(type)
		this.time_id_list[type] = GlobalTimerQuest.AddPeriodQuest(func, time, -1)
		func()
	}

	public CancelCountTime(type?) {

		if (!this.time_id_list || !this.time_id_list[type]) {
			return
		}
		GlobalTimerQuest.CancelQuest(this.time_id_list[type])
		delete this.time_id_list[type]
	}

	public CancelAllCountTime() {

		if (!this.time_id_list) {
			return
		}
		for (let _ in this.time_id_list) {
			var id = this.time_id_list[_]
			GlobalTimerQuest.CancelQuest(id)
		}
		this.time_id_list = null
	}

	public RefreshData() {

		TSCrackModel.GetInstance().Fire(TSCrackModel.REQUEST_PROTO, 20401)
	}

	public SetLastStrongholdId(id?) {

		this.last_stronghold_id = id
	}

	public GetlastStrongholdId() {

		return this.last_stronghold_id
	}

	public static GetInstance() {

		if (TSCrackModel.Instance == null) {
			new TSCrackModel()
		}
		return TSCrackModel.Instance
	}


}

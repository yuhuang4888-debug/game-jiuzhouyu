import { AutoFightManager } from "../autofight/AutoFightManager"
import { BaseEnterDefine } from "../baseEnterView/BaseEnterDefine"
import { CommonManager } from "../common/CommonManager"
import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { BossSceneManager } from "../commonController/BossSceneManager"
import { RoleManager } from "./RoleManager"
import { Scene } from "../scene/Scene"
import { SceneManager } from "../scene/SceneManager"
import { SceneObj } from "../scene/sceneobj/SceneObj"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { EventDispatcher } from "../util/EventDispatcher"
import { Mathf } from "../util/Mathf"
import { Vector2 } from "../util/Vector2"
import { Config } from "../common/Config"

export class HolyBattleModel extends EventDispatcher {
	CheakResultData
	ClearMonData
	ClearResultData
	GetActData
	GetAverageWorldLv
	GetExp
	GetFightData
	GetMode
	GetMonData
	GetRecordData
	GetRedState
	GetScore
	GetScoreRewardStateList
	GetServerList
	GetTimeData
	GetTowerList
	HasRedFlag
	OpenState
	RefreshActOpenRed
	RefreshRewardRed
	ResetAutoFight
	SetRedFlag
	SetResultData
	TryRefreshRewardRed
	UpdateActData
	UpdateExpData
	UpdateFightData
	UpdateMonData
	UpdateRecordData
	UpdateScoreData
	UpdateTimeData
	auto_relive_state
	result_data
	result_open
	tower_list
	InitConfig

	public static REQUEST_PROTO = "HBM218.REQUEST_PROTO"
	public static REFRESH_RED_FLAG = "HBM218.REFRESH_RED_FLAG"
	public static UPDATE_ACT_DATA = "HBM218.UPDATE_ACT_DATA"
	public static UPDATE_SCORE_DATA = "HBM218.UPDATE_SCORE_DATA"
	public static UPDATE_EXP_DATA = "HBM218.UPDATE_EXP_DATA"
	public static UPDATE_FIGHT_DATA = "HBM218.UPDATE_FIGHT_DATA"
	public static UPDATE_RECORD_DATA = "HBM218.UPDATE_RECORD_DATA"
	public static UPDATE_TIME_DATA = "HBM218.UPDATE_TIME_DATA"
	public static UPDATE_MON_DATA = "HBM218.UPDATE_MON_DATA"
	public static SWITCH_ITEM = "HBM218.SWITCH_ITEM"
	public static UPDATE_SKILL_DATA = "HBM218.UPDATE_SKILL_DATA"

	public static RedFlag = {
		Open: 0x001, 	//升级
		Reward: 0x002	//升星
	}
	public static RedALLFlag = 0

	public static GroupName = [
		"海尊",
		"天尊",
		"夜尊"
	]

	//神道塔的尾号   服务端神道数据和配置的位置没对上
	public static GroupToMon = [
		2, 	//奥法塔
		4,	//幻异塔
		3	//诡秘塔
	]

	public constructor() {
		super()

		if (HolyBattleModel.Instance) {
			return
		}
		HolyBattleModel.Instance = this
		this.tower_list = null
		this.auto_relive_state = false
		let local_HolyBattleModel = HolyBattleModel
		let local_GlobalEventSystem = GlobalEventSystem
		let local_CommonManager_Instance = CommonManager.GetInstance()
		let local_HolyBattle_RedFlag = HolyBattleModel.RedFlag
		let local_EventName = EventName
		let local_SceneManager_Instance = SceneManager.GetInstance()
		let local_Scene = Scene.GetInstance()
		let boss_scene_mgr = BossSceneManager.GetInstance()
		let auto_fight_mgr = AutoFightManager.GetInstance()
		let act_data = null
		let score_data = null
		let exp_data = null
		let fight_data = null
		let record_data = null
		let time_data = null
		let mon_data = null
		let red_flag = 0
		let holy_spirit_battlefield_kv_cfg

		this.InitConfig = () => {
			holy_spirit_battlefield_kv_cfg = Config.PRELOAD_SERVER_CONFIG.config_holy_spirit_battlefield_kv
		}
		this.InitConfig()

		this.UpdateActData = (scmd21801?) => {
			let wlv = 0
			for (let _tmpi in scmd21801.server_list) {
				var vo = scmd21801.server_list[_tmpi]
				wlv = wlv + vo.lv
			}
			scmd21801.avg_wlv = Mathf.Floor(wlv / scmd21801.server_list.length)
			act_data = scmd21801
			this.Fire(local_HolyBattleModel.UPDATE_ACT_DATA)
		}

		this.GetMode = () => {
			return act_data && act_data.mod
		}

		this.GetServerList = () => {
			return act_data && act_data.server_list
		}

		this.GetAverageWorldLv = () => {
			return act_data && act_data.avg_wlv
		}

		this.GetActData = () => {
			return act_data
		}

		////////////-个人积分奖励//////////////
		this.UpdateScoreData = (scmd21805?) => {
			score_data = scmd21805
			this.RefreshRewardRed()
			this.Fire(local_HolyBattleModel.UPDATE_SCORE_DATA)
		}

		this.GetScore = () => {
			return score_data && score_data.point || 0
		}

		this.GetScoreRewardStateList = () => {
			return score_data && score_data.reward_list || {}
		}
		////////////-个人积分奖励//////////////

		////////////-经验变化//////////////
		this.UpdateExpData = (scmd21804?) => {
			exp_data = scmd21804
			this.Fire(local_HolyBattleModel.UPDATE_EXP_DATA)
		}

		this.GetExp = () => {
			return exp_data && exp_data.all_exp || 0
		}
		////////////-经验变化//////////////

		////////////-战场信息//////////////
		this.UpdateFightData = (scmd21807?) => {
			fight_data = scmd21807
			if (score_data) {
				score_data.point = fight_data.point
				this.TryRefreshRewardRed()
			}
			this.Fire(local_HolyBattleModel.UPDATE_FIGHT_DATA)
		}

		this.GetFightData = (scmd21807?) => {
			return fight_data
		}
		////////////-战场信息//////////////

		////////////-战场统计//////////////
		this.UpdateRecordData = (scmd21808?) => {
			record_data = scmd21808

			let sort_func = (a?, b?) => {
				return a.point > b.point
			}
			for (let _ = 0; _ < record_data.group_list.length; _++) {
				var vo = record_data.group_list[_]
				table.sort(vo.role_list, sort_func)
			}

			this.Fire(local_HolyBattleModel.UPDATE_RECORD_DATA)
		}

		this.GetRecordData = (scmd21807?) => {
			return record_data
		}
		////////////-战场统计//////////////

		////////////-活动阶段//////////////
		this.UpdateTimeData = (scmd21811?) => {
			time_data = scmd21811
			this.Fire(local_HolyBattleModel.UPDATE_TIME_DATA)
			this.RefreshActOpenRed()
		}


		this.GetTimeData = () => {
			return time_data
		}

		this.OpenState = () => {
			return time_data && time_data.status > 0
		}
		////////////-活动阶段//////////////

		////////////-怪物信息//////////////
		let _refresh_mon_data_time_id = null
		this.UpdateMonData = (scmd21813?) => {
			if (!mon_data) {
				mon_data = []
			}
			for (let _tmpi in scmd21813.mon_list) {
				var vo = scmd21813.mon_list[_tmpi]
				if (vo.hp == 0) {
					mon_data[vo.mon_cfg_id] = null
				} else {
					mon_data[vo.mon_cfg_id] = vo
				}
			}
			if (!_refresh_mon_data_time_id) {
				_refresh_mon_data_time_id = setTimeout(() => {
					clearTimeout(_refresh_mon_data_time_id)
					_refresh_mon_data_time_id = null
					this.Fire(local_HolyBattleModel.UPDATE_MON_DATA)
				}, 0.3)
			}
		}

		this.GetMonData = () => {
			return mon_data
		}

		this.ClearMonData = () => {
			mon_data = null
		}
		////////////-怪物信息//////////////

		////////////-红点信息//////////////
		//活动开启状态红点
		this.RefreshActOpenRed = () => {
			let bool = false
			if (this.OpenState()
				&& !local_SceneManager_Instance.IsHolyBattleWaitScene()
				&& !local_SceneManager_Instance.IsHolyBattleFightScene()) {
				bool = true
			}
			this.SetRedFlag(local_HolyBattle_RedFlag.Open, bool)
		}

		//奖励领取状态红点
		this.RefreshRewardRed = () => {
			let bool = false
			if (score_data) {
				for (let _tmpi in score_data.reward_list) {
					var vo = score_data.reward_list[_tmpi]
					if (vo.status == 1) {
						bool = true
						break
					}
				}
			}
			this.SetRedFlag(local_HolyBattle_RedFlag.Reward, bool)
		}

		let try_refresh_reward_time_id = null
		this.TryRefreshRewardRed = () => {
			if (!try_refresh_reward_time_id) {
				try_refresh_reward_time_id = setTimeout(() => {

					ResManager.GetInstance().LoadGameConfig(this,
						"config_holy_spirit_battlefield_role_reward", false, null, (cfg?) => {
							let data = score_data
							let mode = this.GetMode()
							let reward_cfg = null

							if (data && mode) {
								for (let _tmpi in data.reward_list) {
									var vo = data.reward_list[_tmpi]
									if (vo.status == 0) {
										reward_cfg = cfg[mode + "@" + vo.stage]
										if (reward_cfg && data.point >= reward_cfg.point) {
											vo.status = 1
										}
									}
								}
							}

							this.RefreshRewardRed()

							clearTimeout(try_refresh_reward_time_id)
							try_refresh_reward_time_id = null

							ResManager.GetInstance().DestoryGameConfig(this, "config_holy_spirit_battlefield_role_reward", false)
						})
				}, 3)
			}
		}

		this.SetRedFlag = (flag?, state?) => {
			if (!flag) {
				return
			}

			let now_flag = 0
			if (state) {
				now_flag = red_flag | flag//bit.bor(red_flag, flag)
			} else {
				now_flag = red_flag & ~flag//bit.band(red_flag, bit.bnot(flag))
			}
			if (now_flag == red_flag) {
				return
			}

			red_flag = now_flag

			this.Fire(local_HolyBattleModel.REFRESH_RED_FLAG, flag)
			local_GlobalEventSystem.Fire(local_EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "BattleFieldEnterView", BaseEnterDefine.BattleFieldIndex().HolyBattle, this.GetRedState())
			local_GlobalEventSystem.Fire(local_EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 280)
		}

		//是否包含指定flag
		this.HasRedFlag = (flag?) => {

			if (!flag) {
				return false
			}
			return ((red_flag & flag) != 0)
			//return bit.band(red_flag, flag) != 0
		}

		this.GetRedState = () => {
			return (local_CommonManager_Instance.CheckFuncOpenState("HolyBattleEnterView", true) && (red_flag > 0) || (false))
		}

		this.GetTowerList = () => {
			if (!this.tower_list) {
				//let holy_spirit_battlefield_kv_cfg = holy_spirit_battlefield_kv_cfg
				let cfg_tower_list = holy_spirit_battlefield_kv_cfg && holy_spirit_battlefield_kv_cfg["tower_list"]

				this.tower_list = []
				if (cfg_tower_list) {
					cfg_tower_list = JSON.parse(cfg_tower_list.values)
					for (let _tmpi in cfg_tower_list) {
						var vo = cfg_tower_list[_tmpi]
						let id_list = []
						for (let _tmpj = 0; _tmpj < vo[0].length; _tmpj++) {
							var info = vo[0][_tmpj]
							id_list[Number(info[1])] = true
							//table.insert(id_list, Number(info[2]))
						}

						table.insert(this.tower_list,
							{
								mon_list: id_list,
								x: vo[1],
								y: vo[2]
							})
					}
				}
			}

			return this.tower_list
		}

		this.ResetAutoFight = (relive_type?) => {
			if (relive_type == 1) {
				return
			}

			let all_tower_list = this.GetTowerList()
			if (all_tower_list.length < 4) {
				return
			}
			let main_role_group = RoleManager.GetInstance().GetMainRoleVo().warGroup
			if (!main_role_group) {
				return
			}

			let my_monster_id = HolyBattleModel.GroupToMon[main_role_group-1]
			let mon_data_list = this.GetMonData()
			let my_tower_list = all_tower_list[my_monster_id-1]	//自己神道的塔
			let one_tower_list = all_tower_list[0]	//圣灵的塔
			let my_tower = null
			let one_tower = null

			if (!my_tower_list) {
				//未分配神道
				return
			}

			if (mon_data_list) {
				for (let key in mon_data_list) {

					let mon_data = mon_data_list[key]
					if (mon_data) {
						if (my_tower_list.mon_list[mon_data.mon_cfg_id]) {
							my_tower = mon_data
						} else if (one_tower_list.mon_list[mon_data.mon_cfg_id]) {
							one_tower = mon_data
						}
					}

				}
			}

			if (!my_tower || !one_tower) {
				return
			}

			let pos
			pos = {}
			if (my_tower.group_id != main_role_group) {
				pos.x = my_tower_list.x
				pos.y = my_tower_list.y
			} else if (one_tower.group_id != main_role_group) {
				pos.x = one_tower_list.x
				pos.y = one_tower_list.y
			} else {
				let r_list = [2, 3, 4]
				for (let _i = 0; _i < r_list.length; _i++) {
					var _v = r_list[_i]
					if (_v == my_monster_id) {
						r_list.splice(_i, 1)
						//table.remove(r_list, _i)
					}
				}
				let random_id = r_list[Math.round(Math.random())]//r_list[Math.random(1, 2)]
				if (all_tower_list[random_id]) {
					pos.x = all_tower_list[random_id].x
					pos.y = all_tower_list[random_id].y
				}

			}

			if (pos.x && pos.y) {
				let real_x = pos.x / SceneObj.GetLogicRealRatio().x
				let real_y = pos.y / SceneObj.GetLogicRealRatio().y

				//auto_fight_mgr:SetAutoFight(true)
				//boss_scene_mgr:SetAutoState(true)
				local_Scene.SetClickTarget(null)
				GlobalEventSystem.Fire(EventName.STARTAUTOFIGHT)
				local_Scene.MainRoleMove(new Vector2(real_x, real_y))
			}



		}

		this.SetResultData = (result_data?) => {
			this.result_data = result_data
		}

		this.ClearResultData = () => {
			this.result_data = null
			this.result_open = false
		}

		this.CheakResultData = () => {
			if (this.result_data) {
				this.result_open = true
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "HolyBattleResultView", this.result_data)
			}
		}

	}

	static Instance
	public static GetInstance() {

		if (!HolyBattleModel.Instance) {
			HolyBattleModel.Instance = new HolyBattleModel()
		}
		return HolyBattleModel.Instance
	}

}
window["HolyBattleModel"] = HolyBattleModel
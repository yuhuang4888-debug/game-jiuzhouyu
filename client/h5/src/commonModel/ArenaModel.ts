import { BaseEnterDefine } from "../baseEnterView/BaseEnterDefine"
import { Config } from "../common/Config"
import { CommonManager } from "../common/CommonManager"
import { EventName } from "../common/EventName"
import { FigureProtoVo } from "../common/FigureProtoVo"
import { ResManager } from "../common/ResManager"
import { FashionPartPos } from "../scene/SceneConfig"
import { ModelPartPos } from "../sharedata/RoleVo"
import { GlobalEventSystem, ClientConfig } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { EventDispatcher } from "../util/EventDispatcher"
import { Trim } from "../util/Util"

export class ArenaModel extends EventDispatcher {
	GetBreachDot
	GetCanReceiveNum
	GetCfgKeyValue
	GetDressByType
	GetFigureId
	GetMyHistoryHighRank
	GetMyRank
	GetReceivedAfterList
	GetRedState
	GetRoleClotheTextureId
	GetRolesData
	GetWeaponClotheId
	InitConfig
	InitKeyValue
	RefreshRed
	SetCanReceiveNum
	SetMyRank
	SetPageInfo
	SetRedState
	SetRolesData
	arena_red_state
	breach_dot
	can_receive_num
	challenge_player_list
	enemy_fight
	guide_info
	key_dic
	page_info
	record_list
	red_time_id
	result_info
	rolesData
	times_info
	static Instance
	config_jjc_config
	config_temple_awaken_suit
	config_temple_awaken_kv
	public static REQUEST_CCMD_EVENT = "ArenaModel.REQUEST_CCMD_EVENT"
	public static OPEN_VIEW = "ArenaModel.OPEN_VIEW"
	public static CLOSE_VIEW = "ArenaModel.CLOSE_VIEW"
	public static UPDATE_TIMES_INFO = "ArenaModel.UPDATE_TIMES_INFO"
	public static UPDATE_RECORD = "ArenaModel.UPDATE_RECORD"
	public static UPDATE_FIGHT_INFO = "ArenaModel.UPDATE_FIGHT_INFO"
	public static UPDATE_BREACH_REWARD_VIEW = "ArenaModel.UPDATE_BREACH_REWARD_VIEW"

	public static MOUDLE_ID = {
		Arena: 280,
		NineSky: 135,
		DuelArena: 653
	}
	GetRoleHeadId

	public constructor() {
		super()

		if (ArenaModel.Instance) {
			return
		}
		ArenaModel.Instance = this

		this.rolesData = null
		this.times_info = null
		this.page_info = null
		this.challenge_player_list = null
		this.record_list = null
		this.result_info = null
		this.enemy_fight = null
		this.guide_info = null
		this.arena_red_state = null
		this.key_dic = null
		this.breach_dot = null
		this.can_receive_num = null
		this.red_time_id = null

		let local_ModelPartPos = ModelPartPos
		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName

		this.InitConfig = () => {
			this.config_jjc_config = Config.PRELOAD_SERVER_CONFIG.config_jjc_config
			this.InitKeyValue(this.config_jjc_config, [1, 4, 17])
			this.config_temple_awaken_suit = Config.PRELOAD_SERVER_CONFIG.config_temple_awaken_suit
			this.config_temple_awaken_kv = Config.PRELOAD_SERVER_CONFIG.config_temple_awaken_kv
		}

		this.SetPageInfo = (scmd?) => {
			this.ChangeVar("page_info", scmd)
		}

		this.GetMyRank = () => {
			if (this.page_info) {
				return this.page_info.rank
			}
		}

		this.SetMyRank = (value?) => {
			if (this.page_info) {
				this.page_info.rank = Number(value)
			}
		}

		this.GetMyHistoryHighRank = () => {
			if (this.page_info) {
				return this.page_info.history_rank
			}
		}

		this.GetReceivedAfterList = () => {
			if (this.page_info) {
				return this.page_info.break_id_list
			}
		}

		//取时装衣服贴图id
		this.GetRoleClotheTextureId = (obj?) => {
			let model_res_list = obj.fashion_model_list
			// if (obj && CheckIsTempleAwaken(obj.figure_list)) {
			// 	let cfg = this.config_temple_awaken_suit
			// 	return Number(cfg["1001@" + obj.career].figure_id), 0
			// }
			if (model_res_list) {
				for (let _tmpi in model_res_list) {
					var v = model_res_list[_tmpi]
					if (v.part_pos == FashionPartPos.Clothe) {
						return v.fashion_model_id, 0
					}
				}
			}
			model_res_list = obj.level_model_list
			if (model_res_list) {
				for (let _tmpi in model_res_list) {
					var v = model_res_list[_tmpi]
					if (v.part_pos == local_ModelPartPos.Clothe) {
						return v.level_model_id, 0
					}
				}
			}
		}

		//先取时装模型列表的 再取等级模型id列表的武器
		this.GetWeaponClotheId = (obj?) => {
			let model_res_list = obj.fashion_model_list
			if (model_res_list) {
				for (let _tmpi in model_res_list) {
					var v = model_res_list[_tmpi]
					if (v.part_pos == local_ModelPartPos.Weapon) {
						return v.fashion_model_id
					}
				}
			}
			let figure_list = obj.figure_list
			if (figure_list) {
				for (let _tmpi in figure_list) {
					var v = figure_list[_tmpi]
					if (v.figure_type == FigureProtoVo.FigureType.Weapon) {
						return v.figure_id
					}
				}
			}
			model_res_list = obj.level_model_list
			if (model_res_list) {
				for (let _tmpi in model_res_list) {
					var v = model_res_list[_tmpi]
					if (v.part_pos == local_ModelPartPos.Weapon) {
						return v.level_model_id
					}
				}
			}
		}

		//通过figure_type来获取对应的值
		this.GetFigureId = (list?, figure_type?) => {
			if (list) {
				for (let _tmpi in list) {
					var v = list[_tmpi]
					if (v.figure_type == figure_type) {
						return v.figure_id
					}
				}
			}
		}

		//取时装头饰贴图id
		//block是否屏蔽时装头饰
		this.GetRoleHeadId = (obj?) => {
			let model_res_list = obj.fashion_model_list
			// if (obj && CheckIsTempleAwaken(obj.figure_list)) {
			// 	let cfg_kv = this.config_temple_awaken_kv
			// 	let head_model_id = Number(ErlangParser.GetInstance().Parse(cfg_kv[7].value)[obj.career][2])
			// 	return [head_model_id, 0]
			// }
			if (model_res_list) {
				for (let k = 0; k < model_res_list.length; k++) {
					var v = model_res_list[k]
					if (v.part_pos == FashionPartPos.Head) {
						return v.fashion_model_id, v.fashion_chartlet_id
					}
				}
			}

			//审核模式下 取指定非正式资源 没有数据的话 就拿服务器下发的数据
			// if (ClientConfig.alpha_mode && IOSShiledConfig.OpenNotFormalAsset) {
			// 	let res_id = this.GetAlphaModelHeadId()
			// 	if (res_id) {
			// 		return res_id
			// 	}
			// }

			model_res_list = obj.level_model_list
			if (model_res_list) {
				for (let k = 0; k < model_res_list.length; k++) {
					var v = model_res_list[k]
					if (v.part_pos == FashionPartPos.Head) {
						return v.level_model_id
					}
				}
			}
		}

		this.GetDressByType = (list?, dress_type?) => {
			let dress_id = null
			if (list) {
				for (let _tmpi in list) {
					var dress = list[_tmpi]
					if (dress.dress_type == dress_type) {
						dress_id = dress.dress_id
						break
					}
				}
			}
			return dress_id
		}

		this.GetCfgKeyValue = (key?) => {
			return this.key_dic[key]
		}

		this.SetRolesData = (value?) => {
			this.ChangeVar("rolesData", value)
		}

		this.GetRolesData = () => {
			return this.rolesData
		}

		this.RefreshRed = () => {
			let bool = false
			let open = CommonManager.GetInstance().CheckFuncOpenState("BattleFieldEnterView", true)
			if (open) {
				let times_info = this.times_info
				let page_info = this.page_info
				if (this.red_time_id) {
					clearTimeout(this.red_time_id)
					this.red_time_id = null
				}
				if (times_info) {
					let left_num = times_info.left_num
					//let num_refresh = times_info.num_refresh	//上一次计算体力的时间戳
					//let add_count_time = this.GetCfgKeyValue(17)	//挑战次数恢复时间
					//add_count_time = Number(add_count_time)
					//let now_time = 0	//保存 当前刷新周期内 已经过了多久
					//if (num_refresh ) {
					//let time_interval = TimeUtil.getServerTime() - num_refresh
					//left_num = left_num + Mathf.Floor(time_interval / add_count_time)
					//now_time = time_interval % add_count_time
					//}
					//if (left_num == 0 ) {
					//let refresh_time = add_count_time - now_time + 1	//延迟1秒刷新
					//this.red_time_id = setTimeout(() => {
					//this:RefreshRed()
					//}, refresh_time)
					//}
					if (left_num > 0) {
						bool = true
					}
				}
				if (page_info) {
					let num = this.GetCanReceiveNum()
					let after_receive_list = this.GetReceivedAfterList()
					let after_receive_num = after_receive_list.length
					if (after_receive_num < num) {
						bool = true
						this.ChangeVar("breach_dot", true)
					} else {
						this.ChangeVar("breach_dot", false)
					}
				}
			}
			if (this.arena_red_state != bool) {
				this.arena_red_state = bool
				local_GlobalEventSystem.Fire(local_EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 280)
				local_GlobalEventSystem.Fire(local_EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "BattleFieldEnterView", BaseEnterDefine.BattleFieldIndex().Arena, bool)
			}
			return bool
		}

		this.SetRedState = (bool?) => {
			this.arena_red_state = bool
		}

		this.GetRedState = () => {
			return this.arena_red_state
		}

		this.GetBreachDot = () => {
			return this.breach_dot
		}

		this.InitKeyValue = (cfg?, keys?) => {
			this.key_dic = []
			for (let _tmpi in keys) {
				var key = keys[_tmpi]
				if (typeof (cfg[key].value) == "string") {
					this.key_dic[key] = Trim(cfg[key].value)
				} else {
					this.key_dic[key] = cfg[key].value
				}
			}
		}

		this.GetCanReceiveNum = () => {
			return this.can_receive_num
		}

		this.SetCanReceiveNum = (cfg?, scmd?) => {
			this.can_receive_num = 0
			let history_rank = scmd.history_rank
			for (let key in cfg) {

				if (cfg[key].rank >= history_rank && history_rank != 0) {
					this.can_receive_num = this.can_receive_num + 1
				}
			}
		}

	}

	public static GetInstance() {

		if (!ArenaModel.Instance) {
			ArenaModel.Instance = new ArenaModel()
		}
		return ArenaModel.Instance
	}
}

window["ArenaModel"] = ArenaModel
import { RedKey } from "./../common/RedDotDefine"
import { RedDotController } from "./../common/RedDotController"
import { CommonManager } from "../common/CommonManager"
import { Config } from "../common/Config"
import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { RoleManager } from "./RoleManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { EventDispatcher } from "../util/EventDispatcher"
import { Util } from "../util/Util"
import { GoodsModel } from "./GoodsModel"
import { TaskModel, TaskTipType } from "./TaskModel"

export class ReincarnationModel extends EventDispatcher {
	CellCanAwake
	CollectRealFinish
	FindAwakenHaveRed
	GetAwakenData
	GetAwakenState
	GetCurStage
	GetCurTurn
	GetMaxCount
	GetNextAwakenId
	GetNextPointId
	GetPointIdState
	GetReinAwakenPointList
	GetStageAwakenState
	GetTotalProp
	GetTurnActiveCount
	GetTurnTaskDic
	GetTurnTaskList
	InitCurRein
	IsFinishRein
	IsFinishStageTask
	IsMaxStage
	LoadCfg
	SetAwkenActiveList
	SetCurStage
	SetCurTurn
	ShowReinRed
	SubmitRed
	TurnTaskRed
	UpdateRedDot
	GetRedDot
	awaken_cfg
	client_cfg
	dropCfg
	is_show_effect
	last_awaken_id
	needStageList
	rein_cfg
	rein_content_list
	rein_task_cfg
	rein_turn_stage_list
	turn_level_list
	GetDanRedDot: () => boolean

	public static UPDATE_AWAKEN_CELL = "UPDATE_AWAKEN_CELL";
	public static UPDATE_CUR_REIN = "UPDATE_CUR_REIN";
	public static UPDATE_FINISH_REIN = "UPDATE_FINISH_REIN";
	public static OPEN_TIPS_VIEW = "OPEN_TIPS_VIEW";
	public static SEND_AWAKEN_CEll = "SEND_AWAKEN_CEll";
	public static STAR_REIN = "STAR_REIN";
	public static UPDATE_TURN_VIEW = "UPDATE_TURN_VIEW";
	public static UPDATE_RED_DOT = "UPDATE_RED_DOT";
	public static REBIRTH_OPEN_VIEW = "REBIRTH_OPEN_VIEW";
	public static UPDATE_MAINUI_MAX_STAGE = "UPDATE_MAINUI_MAX_STAGE";
	static Instance: any
	static MaxTurn = 7
	public constructor() {
		super()

		if (ReincarnationModel.Instance) {
			return
		}
		this.rein_content_list = ["", "一转", "二转", "三转", "四转", "五转", "六转", "七转"];
		this.rein_turn_stage_list = [0];
		this.turn_level_list = [0, 0, 0, 0, 0, 0, 0, 0];//
		this.needStageList = {
			"0": 0,
			"1": 0,
			"2": 0,
			"3": 0,
			"301400": 370,
			"301500": 520,
			"6": 600,
			"7": 600
		};
		this.CollectRealFinish = false;
		this.is_show_effect = false;
		this.last_awaken_id = 0
		let local_ReincarnationModel = ReincarnationModel
		let common_mgr = CommonManager.GetInstance()
		let task_model = TaskModel.GetInstance()
		let awaken_active_ids_list_ = []
		let cur_turn_ = 0
		let cur_stage_ = 0
		let next_awaken_id_ = null
		let first_task_list_ = []
		let rein_awaken_point_list_ = []
		let rein_red_ = false
		let config_reincarnation_task_cfg
		let config_awakening_cell_cfg

		this.LoadCfg = () => {
			config_reincarnation_task_cfg = Config.PRELOAD_SERVER_CONFIG.config_reincarnation_task_cfg
			config_awakening_cell_cfg = Config.PRELOAD_SERVER_CONFIG.config_awakening_cell_cfg
		}

		this.InitCurRein = () => {
			let mainVo = RoleManager.GetInstance().GetMainRoleVo()
			cur_turn_ = mainVo.turn + 1
			cur_stage_ = mainVo.turn_stage

			this.rein_turn_stage_list = []
			let cfg = config_reincarnation_task_cfg
			for (let index in cfg) {
				var task = cfg[index]
				// let TaskVo = ConfigItemMgr.Instance.GetTaskData(task.task_id) //local_Config:GetConfigVo(local_Config.ConfigHasDefaultValue.task.name, task.task_id, false)
				let TaskVo = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_task.name, task.task_id, false)
				if (TaskVo) {
					if (!first_task_list_[task.turn]) {
						first_task_list_[task.turn] = TaskVo.id
					}
					this.turn_level_list[task.turn] = TaskVo.level
				}
				if (!this.rein_turn_stage_list[task.turn]) {
					this.rein_turn_stage_list[task.turn] = 0
				}
				this.rein_turn_stage_list[task.turn] = this.rein_turn_stage_list[task.turn] + 1
				this.needStageList[task.task_id] = task.finish_lv
			}
		}

		this.SetCurTurn = (num?) => {
			cur_turn_ = num
		}

		this.GetCurTurn = () => {
			return cur_turn_
		}

		this.SetCurStage = (num?) => {
			cur_stage_ = num
		}

		this.GetCurStage = () => {
			return cur_stage_
		}

		this.SetAwkenActiveList = (scmd?) => {
			awaken_active_ids_list_ = scmd.active_ids
			let len = Util.TableSize(awaken_active_ids_list_)
			if (len == 0) {
				this.last_awaken_id = 0
			} else {
				this.last_awaken_id = awaken_active_ids_list_[len - 1].active_id
			}
			next_awaken_id_ = this.GetNextPointId(this.last_awaken_id)
			this.Fire(local_ReincarnationModel.UPDATE_AWAKEN_CELL, true)
			this.UpdateRedDot()
		}

		this.GetAwakenState = () => {
			return this.last_awaken_id
		}

		this.GetNextAwakenId = () => {
			return next_awaken_id_
		}

		this.GetNextPointId = (index?) => {
			if (config_awakening_cell_cfg) {
				if (config_awakening_cell_cfg[index + 1]) {
					return index + 1
				} else {
					return 0
				}
			}
		}

		this.UpdateRedDot = () => {
			if (!common_mgr.CheckFuncOpenState("ReincarnationBaseView", true)) {
				return false
			}
			if (RoleManager.GetInstance().GetMainRoleVo().turn >= 7) {
				return false
			}
			if (cur_turn_ > 7) {
				return false
			}

			//等级达到才可以使用转职丹
			let dan_red_dot = this.GetDanRedDot()
			if (this.turn_level_list[cur_turn_] > RoleManager.GetInstance().GetMainRoleVo().level) {
				rein_red_ = false
				dan_red_dot = false
			} else {
				rein_red_ = this.ShowReinRed();
			}

			let red_state = rein_red_ || dan_red_dot
			this.Fire(local_ReincarnationModel.UPDATE_RED_DOT, red_state)
			GlobalEventSystem.Fire(EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 130, red_state)
			// 新红点管理
			RedDotController.ins.up(RedKey.REINCARNATION, red_state ? 1 : 0)
			return rein_red_;
		}

		this.GetRedDot = () => {
			let dan_red_dot = this.GetDanRedDot()
			if (this.turn_level_list[cur_turn_] > RoleManager.GetInstance().GetMainRoleVo().level) {
				dan_red_dot = false
			}
			return (rein_red_ || dan_red_dot)
		}

		this.FindAwakenHaveRed = () => {
			if (!common_mgr.CheckFuncOpenState("ReincarnationBaseView", true)) {
				return false
			}
			if (cur_turn_ < 3) {
				return false
			}
			if (this.turn_level_list[cur_turn_] > RoleManager.GetInstance().GetMainRoleVo().level) {
				return false
			}
			return this.CellCanAwake(next_awaken_id_)
		}

		this.GetMaxCount = () => {
			let awaken_list = this.GetReinAwakenPointList(cur_turn_, 1)
			return Util.TableSize(awaken_list)
		}

		this.CellCanAwake = (id?) => {
			if (!id) {
				return false
			}
			if (awaken_active_ids_list_ && awaken_active_ids_list_[id]) {
				return false
			}
			let cfg = config_awakening_cell_cfg
			if (!config_awakening_cell_cfg[id]) {
				return false
			}
			let taskList = task_model.GetReincarnationTaskList()
			if (!taskList || taskList[0].task_id != cfg[id].task_id) {
				return false
			}
			let cost_attr = JSON.parse(cfg[id].priority_consume)
			let now_count = GoodsModel.GetInstance().GetTypeGoodsNum(cost_attr[0][1])
			return now_count >= Number(cost_attr[0][2])
		}

		this.GetTurnTaskDic = (turn?, stage?) => {
			let task_dic = []
			let cfg = config_reincarnation_task_cfg
			if (!cfg) {
				return
			}
			for (let index in cfg) {
				if (turn == cfg[index].turn && (!stage || stage == cfg[index].stage)) {
					task_dic[cfg[index].task_id] = cfg[index]
				}
			}
			return task_dic
		}

		this.GetTurnTaskList = (turn?) => {
			let task_list = []
			let cfg = config_reincarnation_task_cfg
			if (!cfg) {
				return
			}
			for (let index in cfg) {
				if (turn == cfg[index].turn) {
					// if (!task_list[cfg[index].stage]) {
					// 	task_list[cfg[index].stage] = []
					// }
					table.insert(task_list, cfg[index])
				}
			}
			// for (let index in task_list) {
			// 	var list = task_list[index]
			// 	table.sort(list, (a?, b?) => {
			// 		return a.task_id < b.tasK_id
			// 	})
			// }


			table.sort(task_list, (a?, b?) => {
				return a.task_id < b.tasK_id
			})


			return task_list
		}

		this.GetReinAwakenPointList = (turn?, stage?) => {
			if (!rein_awaken_point_list_[turn]) {
				let point_list = []
				let task_dic = this.GetTurnTaskDic(turn)
				let cfg = config_awakening_cell_cfg
				let task = null
				if (cfg) {
					for (let index in cfg) {
						task = task_dic[cfg[index].task_id]
						if (task) {
							if (!point_list[task.stage]) {
								point_list[task.stage] = []
							}
							table.insert(point_list[task.stage], cfg[index])
						}
					}
				}
				for (let index in point_list) {
					var list = point_list[index]
					table.sort(list, (a?, b?) => {
						return a.id < b.id
					})
				}
				rein_awaken_point_list_[turn] = point_list
			}
			if (stage) {
				if (rein_awaken_point_list_[turn] && rein_awaken_point_list_[turn][stage]) {
					return rein_awaken_point_list_[turn][stage]
				}
			} else {
				return rein_awaken_point_list_[turn]
			}
		}

		this.GetPointIdState = (turn?, stage?, id?) => {
			if ((!turn || !stage) || !id) {
				return
			}
			let list = this.GetReinAwakenPointList(turn)
			if (list && list[stage]) {
				let light_id = this.GetAwakenState()
				if (id <= light_id) {
					return 2
				} else if (id == light_id + 1) {
					return 1
				} else {
					let cfg = config_awakening_cell_cfg
					if (cfg) {
						if (!cfg[light_id + 1] && !cfg[id - 1]) {
							return 1
						} else {
							return 0
						}
					}
				}
			}
		}

		this.GetStageAwakenState = (turn?, stage?) => {
			if (!turn || !stage) {
				return
			}
			let list = this.GetReinAwakenPointList(turn, stage)
			let task_list = this.GetTurnTaskList(turn)
			let now_task = task_list && task_list[stage]
			let len = Util.TableSize(list)
			let light_id = this.GetAwakenState()
			if (list) {
				return list[len - 1].id <= light_id && now_task
			}
		}

		this.GetTotalProp = () => {
			let list = []
			let prop_list = []
			let awaken_list = this.GetReinAwakenPointList(cur_turn_)
			awaken_list = awaken_list[1]
			let str = null
			for (let index in awaken_list) {
				let AwakenVo = awaken_list[index]
				let state = this.GetPointIdState(cur_turn_, 1, AwakenVo.id)
				if (state == 2) {
					let prop_data = JSON.parse(AwakenVo.attr)
					if (prop_data) {
						let i = 0
						do {
							let prop_value = prop_list[prop_data[i][0]]
							if (!prop_value) {
								prop_list[prop_data[i][0]] = 0
							}
							prop_list[prop_data[i][0]] = prop_list[prop_data[i][0]] + prop_data[i][1]
							i = i + 1
						} while ((i < prop_data.length))
					}
				}
			}
			return prop_list
		}

		this.GetAwakenData = (id?) => {
			return config_awakening_cell_cfg[id]
		}

		this.IsFinishRein = () => {
			let is_finish = false
			if (this.rein_turn_stage_list[cur_turn_] && cur_stage_ >= this.rein_turn_stage_list[cur_turn_]) {
				let task_list = task_model.GetReincarnationTaskList()
				if (task_list) {
					is_finish = true
					for (let _tmpi in task_list) {
						var taskVo = task_list[_tmpi]
						if (taskVo.has_finish == 0 || (this.needStageList[taskVo.task_id] && RoleManager.GetInstance().GetMainRoleVo().level < this.needStageList[taskVo.task_id])) {
							is_finish = false
							break
						}
					}
				}
			} else {
				is_finish = false
			}
			return is_finish
		}

		this.IsFinishStageTask = () => {
			let is_finish = false
			let task_list = task_model.GetReincarnationTaskList()
			if (task_list) {
				is_finish = true
				for (let _tmpi in task_list) {
					var taskVo = task_list[_tmpi]
					if (taskVo.has_finish == 0 || (this.needStageList[taskVo.task_id] && RoleManager.GetInstance().GetMainRoleVo().level < this.needStageList[taskVo.task_id])) {
						is_finish = false
						break
					}
				}
			}
			return is_finish
		}

		this.GetTurnActiveCount = (turn?) => {
			let total_count = awaken_active_ids_list_.length
			let pass_count = 0
			let i = 3
			if (i < turn) {
				do {
					let turn_data_list = this.GetReinAwakenPointList(i, 1)
					if (turn_data_list) {
						pass_count = pass_count + Util.TableSize(turn_data_list)
					}
					i = i + 1
				} while ((i < turn))
			}
			return total_count - pass_count
		}

		this.IsMaxStage = () => {
			let career = RoleManager.GetInstance().GetMainRoleVo().career
			let sex = RoleManager.GetInstance().GetMainRoleVo().sex
			let turn = RoleManager.GetInstance().GetMainRoleVo().turn
			let cur_cfg = Config.PRELOAD_SERVER_CONFIG.config_reincarnation_cfg[career + "@" + sex + "@" + turn]
			if ((cur_cfg && RoleManager.GetInstance().GetMainRoleVo().level >= cur_cfg.full_lv) && turn < 7) {
				return true
			}
			return false
		}

		this.SubmitRed = () => {
			let taskList = task_model.GetReincarnationTaskList()
			if (taskList) {
				for (let _tmpi in taskList) {
					var vo = taskList[_tmpi]
					if (vo.task_tips_type == TaskTipType.CollectMaterial) {
						return true
					} else if (vo.task_tips_type == TaskTipType.FinDungeon) {
						let cfg1 = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_dungeon.name, vo.id, false)
						if (cfg1 && cfg1.recommend_power) {
							return cfg1.recommend_power <= RoleManager.GetInstance().GetMainRoleVo().fighting
						}
					}
				}
			}
			return false
		}

		this.ShowReinRed = () => {
			return (this.FindAwakenHaveRed() || this.IsFinishStageTask()) || this.IsFinishRein() || this.SubmitRed()
		}

		/**
		 * 转职丹红点
		 */
		this.GetDanRedDot = () => {
			let local_roleVo: RoleManager = RoleManager.GetInstance()
			let career: number = local_roleVo.mainRoleInfo.career;
			let sex: number = local_roleVo.mainRoleInfo.sex;
			let turn: number = local_roleVo.mainRoleInfo.turn;
			if (turn > 2) return false; // 转生等级为2的话不能有该红点
			let config_reincarnation_cfg = Config.PRELOAD_SERVER_CONFIG.config_reincarnation_cfg;
			let key = career + "@" + sex + "@" + turn;
			let cfg = config_reincarnation_cfg[key];
			if (!cfg) return false;
			let data: any = JSON.parse(cfg.turn_cost)[0];
			if (!data) return false;

			let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(data[0], data[1]);
			let goods_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id);
			if (goods_vo) {
				let goodsNum: number = GoodsModel.GetInstance().GetTypeGoodsNum(goods_vo.type_id);
				return goodsNum >= data[2];
			} else {
				return false;
			}

		}

	}

	public static GetInstance(): ReincarnationModel {
		if (!ReincarnationModel.Instance) {
			ReincarnationModel.Instance = new ReincarnationModel()
		}
		return ReincarnationModel.Instance
	}

}


window["ReincarnationModel"] = ReincarnationModel
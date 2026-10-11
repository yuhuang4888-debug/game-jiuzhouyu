import { EventDispatcher } from "../util/EventDispatcher"
import { table } from "../common/table"
import { Util } from "../util/Util"
import { Config } from "../common/Config"
import { Message } from "../sysInfo/SysInfoController"
import { Scene } from "../scene/Scene"
import { SceneObj } from "../scene/sceneobj/SceneObj"
import { RoleManager } from "./RoleManager"
import { SkillManager } from "../skill/SkillManager"
import { TimeUtil } from "../util/TimeUtil"
import { Vector2 } from "../util/Vector2"
import { EventName } from "../common/EventName"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameMath } from "../util/GameMath"
import { GameResPath } from "../util/GameResPath"
import { MonsterType } from "../scene/SceneConfig"
import { SceneManager } from "../scene/SceneManager"

export class SeaHegemonyModel extends EventDispatcher {
	AssertFindWay
	AssertRankCfg
	CanAttackRole
	CheckCanCreateDoor
	GetAssertBrickLv
	GetAssertGuildData
	GetAssertRed
	GetAttackId
	GetMonsterData
	GetPositionName
	GetReddot
	GetShipModel
	GetShipSkillList
	IsOpenFight
	OpenTaskView
	SelectPositon
	SetAssertRankCfg
	SetAssertRed
	SetBrickFi
	StartInfo
	StartTime
	actType
	activeStartTime
	applyRed
	applySettingData
	assertAutoFind
	assertSendTask
	assertTaskExp
	assertTaskViewOpen
	assert_brick_alert
	assert_brick_alert1
	assert_in_alert
	assert_login_red
	assert_red
	attackList
	beforeList
	dailyRewardRed
	defList
	disRed
	fightBeforeId
	fightCurId
	fightData
	fightGuildData
	fightType
	getAssertViewData
	getBrickCfg
	getBrickState
	getTaskData
	guildToShip
	hasFight
	isShowPoliticalView
	kingActiveRed
	monsterData
	muteTime
	nameList
	titleList: string[] = [];
	nomalActiveRed
	peopleData
	positionNameList
	seaGuildList
	seaHegemonyData
	seaPreList
	seaSoldierData
	selectInfo
	selectingPosition
	setTaskData
	shipType
	ship_model_map
	showRewardType
	showViewType
	skillList
	hasJoinSea
	assertTaskData
	assertViewData
	assertSceneData
	assertGuildData
	GetItemBg
	assertRankData_all
	assertRankData
	seaKingData


	GetGuildSort
	CanAttackMonster

	target_paths

	public static _instance
	public static REQUEST_PROTO = "SHE1"
	public static CLOSE_VIEW = "SHE2"
	public static OPEN_VIEW = "SHE3"
	public static SELECT_DIS = "SHE4"
	public static START_DATA = "SHE5"
	public static SELECT_VIEW = "SHE6"
	public static SELECT_POSITION = "SHE7"
	public static SELECT_PEOPLE = "SHE8"
	public static GUILD_LIST = "SHE9"
	public static CHANGE_SHIP = "SHE10"
	public static ATTACK_DEF_DATA = "SHE11"
	public static SOLDIER_APPLY = "SHE12"
	public static JOIN_VIEW_DATA = "SHE13"
	public static UPDATE_SEA_INFO = "SHE14"
	public static SOLDIER_INFO = "SHE15"
	public static UPDATE_MONSTER = "SHE16"
	public static TOTAL_INFO = "SHE17"
	public static KING_INFO = "SHE18"
	public static RERORN_SUCCESS = "SHE19"
	public static APPLY_SETTING = "SHE20"
	public static APPOINT = "SHE21"
	public static REMOVE_SOLDIER = "SHE22"
	public static REFRESH_RED = "SHE23"
	public static SELECT_SHIP = "SHE24"
	public static ASSERT_VIEW_DATA = "SHE25"
	public static ASSERT_SCENE_DATA = "SHE26"
	public static ASSERT_RANK_DATA = "SHE27"
	public static ASSERT_RANK_TAB = "ASSERT_RANK_TAB"
	public static ASSERT_BRICK_ID_CHANGE = "SHE28"
	public static ASSERT_TASK_DATA = "SHE29"
	public static ASSERT_BRICK_UP = "SHE30"
	public static ASSERT_BRICK_ING = "SHE31"
	public static ASSERT_BRICK_DOWN = "SHE32"
	public static UPDATE_CAMP_DATA = "SHE33"
	public static UPDATE_MERIT_DATA = "SHE34"
	public static UPDATE_PEOPLE_DATA = "SHE35"
	public static UPDATE_PRIVI_DATA = "SHE36"
	public static ASSERT_BRICK_FINISH = "SHE37"
	public static ASSERT_FIND_WAY = "SHE38"
	public static ASSERT_GUILD_DATA = "SHE39"
	public static CHANGE_BG = "SHE40"
	public static SWITCH_VIEW = "SWITCH_VIEW"
	public static CHOSE_TARGET = "CHOSE_TARGET"
	public static START_FIGHT = "START_FIGHT"
	public static MOVE_TO_NPC = "MOVE_TO_NPC"
	public static MOVE_THOURHGT_DOOR = "MOVE_THOURHGT_DOOR"//穿过传送门进行广播
	public static towerPoslist = [4900101, 4900104, 4900102, 4900105, 4900103, 4900106, 4900107]

	public constructor() {
		super()
		this.seaHegemonyData = null
		this.actType = 1
		this.applySettingData = { role_lv: 0, power: 0, auto: 1 }
		this.activeStartTime = []
		this.seaSoldierData = { limit_num: 0, num: 0, has_asset: false, job_list: [] }
		this.StartInfo = []
		this.StartTime = 0
		this.ship_model_map = [
			15010035,
			15010036,
		]
		this.seaGuildList = { 1: [] }

		this.monsterData = {}
		this.shipType = this.shipType || 1
		this.fightGuildData = []
		this.seaPreList = []
		this.hasFight = true
		this.selectingPosition = 3
		this.selectInfo = {}
		this.muteTime = 300
		this.nameList = ["东海之域", "西海之域", "南海之域", "北海之域"]
		this.titleList = ["东海", "西海", "南海", "北海"]
		this.positionNameList = ["海域之王", "海域统领", "海域元帅", "海域指挥", "海域禁军", "本国势力成员"]
		this.fightType = 1
		this.fightData = { att: [], def: [] }
		this.fightCurId = null
		this.fightBeforeId = null
		this.skillList = [] //[ {4900112], [2] = {4900111}}
		this.beforeList = { [4900103]: true, [4900102]: true, [4900101]: true }
		this.dailyRewardRed = false
		this.applyRed = false
		this.disRed = false
		this.nomalActiveRed = false
		this.kingActiveRed = false
		this.attackList = {}
		this.defList = {}
		//this.guildToShip = []
		this.peopleData = []
		this.showViewType = 0
		this.showRewardType = 6
		this.assertTaskViewOpen = false
		this.assertAutoFind = false
		this.assert_brick_alert = false
		this.assert_brick_alert1 = false
		//this.assert_login_red = true
		this.assert_login_red = false
		this.assert_red = false
		this.assertSendTask = 0
		this.assert_in_alert = false
		this.isShowPoliticalView = true

		this.SelectPositon = (vo?, select?) => {
			let info = this.selectInfo[this.selectingPosition]
			let status = false
			if (select) {
				if (!info) {
					let cfg = Config.PRELOAD_SERVER_CONFIG.config_seacraft_daily_reward
					if (cfg && cfg[this.selectingPosition]) {
						info = { limit: cfg[this.selectingPosition].limit, level: vo.self_level, num: 1, people: [vo.role_id] }
						this.selectInfo[this.selectingPosition] = info
					}
					status = true
				} else {
					if (info.limit > info.num) {
						info.num = info.num + 1
						table.insert(info.people, vo.role_id)
						status = true
					} else {
						let cfg = Config.PRELOAD_SERVER_CONFIG.config_seacraft_daily_reward
						Message.show("最多可设置" + info.limit + "个" + cfg[this.selectingPosition].name)
						return status
					}
				}
			}
			else if (info) {
				let i = 0
				do {
					if (vo.role_id == info.people[i]) {
						//info.people.splice(i, 1)
						table.remove(info.people, i)
						info.num = info.num - 1
						break
					}
					i = i + 1
				} while ((i < info.people.length))
			}
			this.Fire(SeaHegemonyModel.SELECT_PEOPLE, this.selectingPosition)
			return status
		}

		let cfg = Config.PRELOAD_SERVER_CONFIG.config_seacraft_daily_reward

		if (cfg) {
			for (let key in cfg) {
				this.positionNameList[key] = cfg[key].name
			}
		}

		this.GetMonsterData = (id?) => {
			return this.monsterData[id] || { hp: 1, hp_max: 1 }
		}

		/*
			默认忽略普通攻击
		*/
		this.GetShipSkillList = (all_skill?) => {
			let list = []
			let skill_ids = []
			if (!this.skillList[this.shipType]) {
				let ship_cfg = Config.PRELOAD_SERVER_CONFIG.config_seacraft_ship[this.shipType]
				let skill_list = JSON.parse(ship_cfg.skill_list)
				for (let index = 0; index < skill_list.length; index++) {
					let info = skill_list[index]
					table.insert(skill_ids, info[0])
				}

				this.skillList[this.shipType] = skill_ids
			} else {
				skill_ids = this.skillList[this.shipType]
			}

			for (let index = 0; index < skill_ids.length; index++) {
				let skill_id = skill_ids[index]
				let skillVo = SkillManager.GetInstance().getSkill(skill_id)
				if (skillVo) {
					if (index == 0) {
						if (all_skill) {
							table.insert(list, skillVo)
						}
					} else {
						table.insert(list, skillVo)
					}
				}
			}
			return list
		}

		this.GetPositionName = (positon?) => {
			return this.positionNameList[positon]
		}


		//power_id 可能是公会id 也可能是阵营id
		this.GetShipModel = (warGroup?, power_id?, is_only_tex_id?) => {

			let tex_name = null//贴图名称
			let model_id = this.ship_model_map[warGroup - 1]


			if (this.GetGuildSort(power_id) != -1) {
				let guild_sort = this.GetGuildSort(power_id) + 1
				//model_clothe_15010035_1
				if (is_only_tex_id) {
					tex_name = `${guild_sort}`
				} else {
					tex_name = `model_clothe_${model_id}_${guild_sort}`
				}

			}

			return [model_id, tex_name]
		}

		//根据公会id或者阵营id 对进攻方公会id进行个排序  根据排序取贴图id
		this.GetGuildSort = (power_id) => {
			let tempGuildList = []
			for (let key in this.attackList) {
				table.insert(tempGuildList, Number(key))
			}

			table.sort(tempGuildList, (a?, b?) => {
				if (a != b) {
					return b > a
				}
				return false
			})

			return tempGuildList.indexOf(power_id)
		}

		/**
		 * @param vo
		 * @param is_same_warcamp  是否检测船的类型是否相同 
		*/
		this.CanAttackRole = (vo?, is_same_warcamp?) => {

			//vo.camp 海王争霸 该属性只有1和2 1进攻 2防守

			if (this.fightType == 1) {
				//进攻方检测防守方
				if ((this.actType==2&&vo.camp==2) || this.defList[vo.guild_id]) {
					if(is_same_warcamp){
						let _mainrole_vo = RoleManager.GetInstance().GetMainRoleVo()
						let camp1 = _mainrole_vo.warGroup
						let camp2 = vo.warGroup
						if(camp1==camp2){
							return true
						}
					}else{
						return true
					}
					
				}
				
			} else {
				//防守方检测进攻方
				if ((this.actType==2&&vo.camp==1) || this.attackList[vo.guild_id]) {
					if(is_same_warcamp){
						let _mainrole_vo = RoleManager.GetInstance().GetMainRoleVo()
						let camp1 = _mainrole_vo.warGroup
						let camp2 = vo.warGroup
						if(camp1==camp2){
							return true
						}
					}else{
						return true
					}
				}
			}

			return false
		}


		//
		this.CanAttackMonster = (vo?) => {
			if (!vo) return false
			if (this.fightType == 1) {
				if (vo.type != MonsterType.COLLECT) {
					//如果是要塞，需要验证是否把对应的外面的哨塔是否打死了
					let index = SeaHegemonyModel.towerPoslist.indexOf(vo.type_id)
					if (index == -1) return false

					let yao_id=vo.type_id%10
					if (yao_id > 3 && yao_id <= 5) {
						let seaListy = this.monsterData
						let tower_id=SeaHegemonyModel.towerPoslist[index-1]
						if (seaListy[tower_id] && seaListy[tower_id].hp != 0) {
							return false
						}
					}
					return true
				}
			} else {
				if (vo.type == MonsterType.COLLECT) {
					return true
				}
			}

			return false
		}



		this.GetReddot = () => {
			return (((this.dailyRewardRed || this.applyRed) || this.kingActiveRed) || this.nomalActiveRed) || this.GetAssertRed()
		}

		this.assertTaskExp = (exp_cfg?) => {
			let exp = 0
			let lv = RoleManager.GetInstance().GetMainRoleVo().level
			for (let key in exp_cfg) {
				let cfg = exp_cfg[key]
				if (lv >= cfg.lv) {
					exp = cfg.exp
				} else {
					break
				}
			}
			return exp
		}

		this.getAssertViewData = (sea_id?) => {
			for (let key in this.assertViewData.sea_list) {
				let viewData = this.assertViewData.sea_list[key]
				if (viewData.sea_id == sea_id) {
					return viewData
				}
			}
		}

		this.getBrickCfg = (brick_cfg?, brick_num?) => {
			let cfg = null;
			for (const key in brick_cfg) {
				if (Object.prototype.hasOwnProperty.call(brick_cfg, key)) {
					const info = brick_cfg[key];
					if (brick_num <= info.nums) {
						cfg = info;
						break;
					}
				}
			}
			return cfg
		}

		this.getBrickState = (status?) => {
			let state = "破败"
			if (status == 2) {
				state = "残缺"
			}
			else if (status == 3) {
				state = "完好"
			}
			else if (status == 4) {
				state = "华丽"
			}
			else if (status == 5) {
				state = "壮观"
			}
			return state
		}

		this.getTaskData = (task_id?) => {
			for (let key in this.assertTaskData.task_list) {
				let task = this.assertTaskData.task_list[key]
				if (task.task_id == task_id) {
					return task
				}
			}
		}

		this.setTaskData = (data?) => {
			for (let key in this.assertTaskData.task_list) {
				let task = this.assertTaskData.task_list[key]
				if (task.task_id == data.task_id) {
					task.count = task.count + 1
					task.status = 2
					break
				}
			}
			Util.ShowCongratulationView(data.reward)
			this.SetAssertRed()
			this.Fire(SeaHegemonyModel.ASSERT_TASK_DATA)
		}

		this.SetBrickFi = (data?) => {
			for (let key in this.assertViewData.sea_list) {
				let viewData = this.assertViewData.sea_list[key]
				if (viewData.sea_id == this.assertSceneData.sea_id) {
					viewData.brick_color = 1
					break
				}
			}
			let kv_cfg = Config.PRELOAD_SERVER_CONFIG.config_sea_craft_daily_kv
			this.assertSendTask = 0
			this.assertSceneData.carry_count = data.carry_count
			let max = kv_cfg["defend_count"].value
			if (max - this.assertSceneData.carry_count >= 0) {
				this.Fire(SeaHegemonyModel.OPEN_VIEW, "SeaAssertTaskView", data)
			} else {
				Message.show("上交成功")
			}
			this.Fire(SeaHegemonyModel.ASSERT_BRICK_FINISH)
		}

		this.AssertFindWay = (bool?) => {
			let kv_cfg = Config.PRELOAD_SERVER_CONFIG.config_sea_craft_daily_kv
			let scene = Scene.GetInstance()
			if (bool) {
				let LogicRealRatio_X = SceneObj.GetLogicRealRatio().x
				let LogicRealRatio_Y = SceneObj.GetLogicRealRatio().y
				this.assertAutoFind = true
				let pos_cfg = kv_cfg["task_end_pos"].value
				let pos_list = JSON.parse(pos_cfg);
				scene.MainRoleMove(new Vector2(pos_list[0] / LogicRealRatio_X, pos_list[1] / LogicRealRatio_Y))
			} else {
				this.assertAutoFind = false
				scene.main_role.DoStand()
			}
			this.Fire(SeaHegemonyModel.ASSERT_FIND_WAY)
		}

		this.AssertRankCfg = (cfg?, rank?) => {
			for (let key in cfg) {
				let rank_cfg = cfg[key]
				if (rank >= rank_cfg.min_rank && rank <= rank_cfg.max_rank) {
					return rank_cfg
				}
			}
		}

		this.SetAssertRankCfg = (data?, cfg?) => {
			if (!data) {
				return
			}
			let rank = 1
			for (let key in data) {
				let info = data[key]
				let rank_cfg = this.AssertRankCfg(cfg, rank)
				if (rank_cfg) {
					info["reward"] = rank_cfg.reward
				}
				rank = rank + 1
			}
		}

		this.GetAssertGuildData = (sea_id?) => {
			for (let key in this.assertGuildData.sea_list) {
				let data = this.assertGuildData.sea_list[key]
				if (data.sea_id == sea_id) {
					return data
				}
			}
		}

		this.GetAssertBrickLv = (brick_lv_config?, brick_num?) => {
			let _cfg = null
			for (const key in brick_lv_config) {
				if (Object.prototype.hasOwnProperty.call(brick_lv_config, key)) {
					const element = brick_lv_config[key];
					if (brick_num < element.nums) {
						_cfg = element
						break
					}
				}
			}
			return _cfg
		}

		this.SetAssertRed = () => {
			let now_red = this.assert_red
			let flag = false
			for (let key in this.assertTaskData.task_list) {
				let data = this.assertTaskData.task_list[key]
				if (data.status == 1) {
					flag = true
					break
				}
			}
			if (now_red != flag) {
				this.assert_red = flag
				this.Fire(SeaHegemonyModel.REFRESH_RED, 4)
				GlobalEventSystem.Fire(EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 6210)
				GlobalEventSystem.Fire(EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 1861)
			}
		}

		this.GetAssertRed = () => {
			return ((this.assert_red || this.assert_login_red) && this.hasJoinSea) //and this.hasFight
		}

		this.OpenTaskView = () => {
			if ((this.seaHegemonyData && this.assertSceneData) && this.seaHegemonyData.camp == this.assertSceneData.sea_id) {
				Message.show("不能采集本海域的砖块")
				return
			}
			let kv_cfg = Config.PRELOAD_SERVER_CONFIG.config_sea_craft_daily_kv
			let scene = Scene.GetInstance()
			let pos_cfg = kv_cfg["task_start_pos"].value
			let pos_list = JSON.parse(pos_cfg);
			let pos_range = Number(kv_cfg["task_end_range"].value)
			//let [logic_pos_x, logic_pos_y] = scene.main_role.GetLogicPos()
			let rel_pos = scene.main_role.real_pos
			let distance = GameMath.GetDistance(rel_pos.x, rel_pos.y, pos_list[0], pos_list[1])
			//[logic_pos_x, logic_pos_y] = scene.main_role.GetLogicPos()
			if (distance <= pos_range * pos_range) {
				if (this.assertSceneData) {
					this.Fire(SeaHegemonyModel.OPEN_VIEW, "SeaAssertTaskSelView")
				}
			} else {
				Message.show("距离NPC过远")
			}
		}

		/*
			是否开启战斗
		*/
		this.IsOpenFight = () => {
			//console.log("___this.StartInfo.start_time", this.StartInfo.start_time)
			if (this.StartInfo && this.StartInfo.start_time && this.StartInfo.start_time != 0) {
				return TimeUtil.getServerTime() > this.StartInfo.start_time
			}
			return false
		}

		this.CheckCanCreateDoor = () => {
			return this.fightType == 0
		}

		this.GetItemBg = (boo) => {
			let sp_name = boo ? "uitc_036" : "uitc_035"
			return GameResPath.GetIconOtherPath("seaHegemony", sp_name)
		}



		this.GetAttackId = (path_cfg?) => {
			if (!path_cfg || !SceneManager.GetInstance().IsSeaHegemonyScene()) return SeaHegemonyModel.towerPoslist[6]

			//之前反馈的问题，下一个目标是哨塔内，但是哨塔中已经被修复，这时提供的目标应该为哨塔内而不是哨塔中 一直往里面打
			let main_role = Scene.GetInstance().main_role
			if (!main_role) return SeaHegemonyModel.towerPoslist[6]
			let chuizu_y = this.GetPlayerChuizu(path_cfg, [main_role.real_pos.x, main_role.real_pos.y])


			let fight_area_list = this.GetFightArea(path_cfg)//id已经转化

			//优先靠近海神城堡的目标
			for (let i = fight_area_list.length - 1; i >= 0; i--) {
				let target_id = fight_area_list[i]
				let cur_data = this.GetTowerCfg(path_cfg, target_id)
				if (!cur_data) continue

				//目标的垂足  用垂足进行判断 比较准确点
				let t_y = this.GetPlayerChuizu(path_cfg, [cur_data.x, cur_data.y])

				//判断方向看看是否能够到达 
				let type = chuizu_y > t_y ? 1 : 0//1 方向：哨塔外>海神城堡   0方向：海神城堡>哨塔外
				if (this.JuglePos(target_id, type, cur_data.y, path_cfg, chuizu_y)) {
					return target_id
				}
			}
			return SeaHegemonyModel.towerPoslist[6]
		}

		/**判断是否能够走到目标*/
		this.JuglePos = (target_id, type, target_y, path_cfg, player_chuizu_y) => {
			//type 方向
			//target_id 目标真实id
			//target_y 目标原始坐标 y

			let t_id = SeaHegemonyModel.towerPoslist.indexOf(target_id)
			let seaListy = this.monsterData

			//区域数据
			let temo_pos = []
			for (let i = 0; i < SeaHegemonyModel.towerPoslist.length; i++) {
				let real_id = SeaHegemonyModel.towerPoslist[i]
				let data = this.GetTowerCfg(path_cfg, real_id)
				let t_y = this.GetPlayerChuizu(path_cfg, [data.x, data.y])
				if (type == 1) {
					if (i >= t_id) continue
					//1 方向：哨塔外>海神城堡
					if (t_y > target_y && t_y <= player_chuizu_y) {
						table.insert(temo_pos, data)
					}
				} else {
					if (i <= t_id) continue
					// 0方向：海神城堡>哨塔外
					if (t_y < target_y && t_y >= player_chuizu_y) {
						table.insert(temo_pos, data)
					}
				}
			}



			//只需要判断能不能走
			if (type == 1) {
				//1 方向：哨塔外>海神城堡
				for (let i = 0; i < temo_pos.length; i++) {
					let data = temo_pos[i]
					let data_id = data.id
					if (data.type == 2) {
						//有要塞，走不通
						if (seaListy[data_id] && seaListy[data_id].hp != 0) {
							return false
						}
					}
				}
			} else {
				// 0方向：海神城堡>哨塔外
				for (let i = temo_pos.length - 1; i >= 0; i--) {
					let data = temo_pos[i]
					let data_id = data.id
					if (data.type == 2) {
						//有要塞，走不通
						if (seaListy[data_id] && seaListy[data_id].hp != 0) {
							return false
						}
					}
				}
			}

			return true
		}

		//获取战斗范围区间
		this.GetFightArea = (path_cfg) => {

			let path = SeaHegemonyModel.towerPoslist
			let seaListy = this.monsterData
			let section = []   //可进行攻击的区间 [tower_id,...]
			for (let i = 0; i < path.length; i++) {
				let id = path[i]
				let data = this.GetTowerCfg(path_cfg, id)
				//先把可以攻击的目标罗列
				if (seaListy[id] && seaListy[id].hp != 0) {
					if (data.type == 2) {
						//要塞判断下对应的哨塔是否被干掉
						let t_id = path[i - 1]
						if (seaListy[t_id] && seaListy[t_id].hp == 0) {
							table.insert(section, id)
						}
					} else {
						table.insert(section, id)
					}
				}
			}

			return section
		}



		//获取垂足  a、b是直线线上两点，o是玩家坐标
		this.MathGetPoint = (p_a, p_b, p_o,is_need_px?) => {
			var x1 = p_a.x;
			var y1 = p_a.y;
			var x2 = p_b.x;
			var y2 = p_b.y;
			var x0 = p_o.x;
			var y0 = p_o.y;

			var k = x1 == x2 ? 10000 : (y2 - y1) / (x2 - x1);//当x1=x2时，给斜率设一个较大值10000
			var a = k;
			var b = -1;
			var c = y1 - k * x1;

			//点到直线的距离
			// var d = Math.abs(a * x0 + b * y0 + c) / Math.sqrt(a * a + b * b);

			//垂足
			var px = (b * b * x0 - a * b * y0 - a * c) / (a * a + b * b);
			var py = (a * a * y0 - a * b * x0 - b * c) / (a * a + b * b);
			// var p = new Vector2(px, py)

			if(is_need_px){
				return new Vector2(px,py)
			}
			return py
		}

		//获取玩家位置于哨塔外到海神城堡直线上的垂足
		//@param point [x,y]
		//return [x,y]
		this.GetPlayerChuizu = (path_cfg, point) => {
			let main_role = Scene.GetInstance().main_role
			if (!main_role) return

			if (!this.list_init) {
				this.list_init = []
				let data1 = this.GetTowerCfg(path_cfg, SeaHegemonyModel.towerPoslist[0])
				let data2 = this.GetTowerCfg(path_cfg, SeaHegemonyModel.towerPoslist[6])
				table.insert(this.list_init, new Vector2(data1.x, data1.y))
				let offset=0
				table.insert(this.list_init, new Vector2(data2.x-offset, data2.y-offset))
			}

			let p_o = new Vector2(point[0], point[1])
			return this.MathGetPoint(this.list_init[0], this.list_init[1], p_o)
		}

		this.GetTowerCfg = (path_cfg, id) => {
			let sceneId = SceneManager.GetInstance().GetSceneId()
			let key = id + "@" + sceneId
			return path_cfg[key]
		}

	}




	//寻路相关
	MathGetPoint
	GetPlayerChuizu
	GetTowerCfg
	GetFightArea
	JuglePos

	list_init = null

	public static GetInstance() {
		if (!SeaHegemonyModel._instance) {
			SeaHegemonyModel._instance = new SeaHegemonyModel()
		}
		return SeaHegemonyModel._instance
	}
}
window["SeaHegemonyModel"] = SeaHegemonyModel
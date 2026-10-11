import { EventDispatcher } from "../util/EventDispatcher"
import { ErlangParser } from "../util/ErlangParser"
import { GlobalTimerQuest, TransformLevel } from "../util/Util"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { RoleManager } from "./RoleManager"
import { Util, IsInTable } from "../util/Util"
import { KfHolyAreaDefine } from "../kfHolyArea/KfHolyAreaDefine"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventName } from "../common/EventName"
import { ActivityIconManager } from "../commonModel/ActivityIconManager"
import { Message } from "../sysInfo/SysInfoController"
import { Config } from "../common/Config"
import { GoodsModel } from "./GoodsModel"
import { ShopModel, ShopMoneyType, ShopType } from "./ShopModel"
import { servicesVersion } from "../../node_modules/typescript/lib/typescript"

export class KfHolyAreaModel extends EventDispatcher {
	static Instance:KfHolyAreaModel
	InitCfg
	build_data
	enter_info
	erlang_parser
	red_flag
	scene_dic
	time_id_list
	world_lv_list
	map_data
	can_attack_scene_list
	can_move_scene_list
	score_data
	time_data

	Csanctuarycamp
	Csanctuarytype
	ConfigKfHolyArena
	Csanctuaryinfo
	Csanctuarymon
	Csanctuarymontype
	Csanctuaryscore
	Csanctuarykv
	Csanctuaryconstruction
	Csanrewardpreview
	CsanctuaryScene

	shop_red_status

	public static REQUEST_CCMD_EVENT = "KHA.REQUEST_CCMD_EVENT"
	public static OPEN_VIEW = "KHA.OPEN_VIEW"
	public static CLOSE_VIEW = "KHA.CLOSE_VIEW"
	public static UPDATE_SCENE_DATA = "KHA.UPDATE_SCENE_DATA"
	public static SWITCH_TAB_ITEM = "KHA.SWITCH_TAB_ITEM"
	public static KILL_DATA = "KHA.KILL_DATA"
	public static BOSS_RELIVE = "KHA.BOSS_RELIVE"
	public static KILL_BOSS = "KHA.KILL_BOSS"
	public static REFRESH_RED_FLAG = "KHA.REFRESH_RED_FLAG"
	public static EXIT_COUNT_DOWN = "KHA.EXIT_COUNT_DOWN"
	public static UPDATE_REFRESH_BOSS_TIME = "UPDATE_REFRESH_BOSS_TIME"
	public static SELECT_BOSS = "SELECT_BOSS"
	public static UPDATE_REFRESH_INDIVIDUAL_SCORE = "UPDATE_REFRESH_INDIVIDUAL_SCORE"

	public static SCENE_EVENT = {
		CHANGE_BOSS_TARGET: "KHA.CHANGE_BOSS_TARGET"
	}

	public static build_type = {
		fort: 1,
		castle: 2,
		holy: 3
	}

	public static RedFlag = {
		Score: 0x001,
		OwnerReward: 0x002
	}

	public static RedALLFlag = 0

	public constructor() {
		super()

		this.red_flag = 0
		this.erlang_parser = ErlangParser.GetInstance()
		this.shop_red_status = true;  //异域商店红点

		for (let key in KfHolyAreaModel.RedFlag) {

			let value = KfHolyAreaModel.RedFlag[key]
			KfHolyAreaModel.RedALLFlag = KfHolyAreaModel.RedALLFlag + value
		}
		this.InitCfg = async () => {
			this.Csanctuarycamp = Config.PRELOAD_SERVER_CONFIG.config_c_sanctuary_camp
			this.Csanctuarytype = Config.PRELOAD_SERVER_CONFIG.config_c_sanctuary_type
			this.ConfigKfHolyArena = Config.PRELOAD_CLIENT_CONFIG.ConfigKfHolyArena
			this.Csanctuaryinfo = Config.PRELOAD_SERVER_CONFIG.config_c_sanctuary_info
			this.Csanctuarymon = Config.PRELOAD_SERVER_CONFIG.config_c_sanctuary_mon
			this.Csanctuarymontype = Config.PRELOAD_SERVER_CONFIG.config_c_sanctuary_mon_type
			this.Csanctuaryscore = Config.PRELOAD_SERVER_CONFIG.config_c_sanctuary_score
			this.Csanctuarykv = Config.PRELOAD_SERVER_CONFIG.config_c_sanctuary_kv
			this.Csanctuaryconstruction = Config.PRELOAD_SERVER_CONFIG.config_c_sanctuary_construction
			this.Csanrewardpreview = Config.PRELOAD_SERVER_CONFIG.config_c_san_reward_preview
			this.CsanctuaryScene = Config.PRELOAD_SERVER_CONFIG.config_c_sanctuary_scene
		}
	}

	public static GetInstance() {

		if (!KfHolyAreaModel.Instance) {
			KfHolyAreaModel.Instance = new KfHolyAreaModel()
		}
		return KfHolyAreaModel.Instance
	}

	public GetTotalTime() {

		let open_time = JSON.parse(this.GetKeyValue("open_time"))
		if (!open_time) return
		let total_time = 0
		for (let _tmpi in open_time) {
			var value = open_time[_tmpi]
			if (value[1] == "open") {
				let data = value[2]
				total_time = total_time + data[1] * 3600 + data[2] * 60
			} else if (value[1] == "continue") {
				let data = value[2]
				total_time = total_time + data[1] * 3600 + data[2] * 60
			}
		}
		return total_time
	}

	public RefreshSceneList(data?) {

		if (data.san_type > 0) {
			let type_cfg = this.GetTypeCfg(data.san_type)
			if (!type_cfg) return
			let scene_dic = {}
			let san_num = JSON.parse(type_cfg.san_num)
			for (let _tmpi in san_num[0][1]) {
				var scene_id = san_num[0][1][_tmpi]
				scene_dic[scene_id] = KfHolyAreaModel.build_type.fort
			}
			let city_num = JSON.parse(type_cfg.city_num)
			for (let _tmpi in city_num[0][1]) {
				var scene_id = city_num[0][1][_tmpi]
				scene_dic[scene_id] = KfHolyAreaModel.build_type.castle
			}
			let village_num = JSON.parse(type_cfg.village_num)
			for (let _tmpi in village_num[0][1]) {
				var scene_id = village_num[0][1][_tmpi]
				scene_dic[scene_id] = KfHolyAreaModel.build_type.holy
			}
			this.scene_dic = scene_dic
		}
	}


	public static time_type = { refresh_scene_data: 0 }
	public StartCountTime(type?, func?, time?) {

		if (!this.time_id_list) {
			this.time_id_list = {}
		}
		this.CancelCountTime(type)
		this.time_id_list[type] = GlobalTimerQuest.AddPeriodQuest(func, time, -1)
		func()
	}

	//跨服异域红点
	public CheckKfHolyAreaShopRed() {
		let have_money = GoodsModel.GetInstance().GetSpecialScore(ShopMoneyType.KfHolyArea)
		let goods_list = ShopModel.GetInstance().GetShopDataByType(ShopType.MedalShop)
		let price = 0
		let sold_out = 0
		for (let key in goods_list) {
			let goods = goods_list[key]
			price = goods.price
			sold_out = goods.sold_out
			if (sold_out == 0 && price <= have_money) {//商品没卖完 且 钱够
				return true
			}
		}
		return false
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
		for (let key in this.time_id_list) {

			GlobalTimerQuest.CancelQuest(this.time_id_list[key])
		}
		this.time_id_list = null
	}

	public GetCampByServerId(server_id?) {

		if (this.map_data) {
			for (let _tmpi in this.map_data.server_ids) {
				var vo = this.map_data.server_ids[_tmpi]
				if (vo.server_id == server_id) {
					return vo.camp
				}
			}
		}
	}

	public IsCampMode() {

		return this.map_data && this.map_data.san_type >= 4
	}

	public GetCampName(camp_id?, camp_name_cfg?) {

		return this.Csanctuarycamp && this.Csanctuarycamp[camp_id] && this.Csanctuarycamp[camp_id].name
	}

	public GetCampServerList(camp_id?) {

		let list = []
		if (this.map_data) {
			for (let _tmpi in this.map_data.server_ids) {
				var vo = this.map_data.server_ids[_tmpi]
				if (vo.camp == camp_id) {
					table.insert(list, vo)
				}
			}
		}
		return list
	}

	public SetSceneData(scene_id?, scmd?) {

		if (!this.build_data) {
			this.build_data = {}
		}
		table.sort(scmd.server, (a?, b?) => {
			return a.score < b.score
		})

		this.build_data[scene_id] = scmd
		this.Fire(KfHolyAreaModel.UPDATE_SCENE_DATA, scene_id)
		this.RefreshCanAttackServerList()
		this.RefreshOwnerRewardRed()
	}

	public GetSceneData(scene_id?) {

		return this.build_data && this.build_data[scene_id]
	}

	public RefreshSceneData() {

		if (this.scene_dic) {
			for (let scene_id in this.scene_dic) {
				this.Fire(KfHolyAreaModel.REQUEST_CCMD_EVENT, 28401, scene_id)
			}
		}
	}

	public RefreshCanAttackServerList() {

		let map_data = this.map_data
		let server_ids = map_data && map_data.server_ids
		if (!server_ids) {
			return
		}
		let main_role_camp = this.GetCampByServerId(RoleManager.GetInstance().GetMainRoleVo().server_unique_id)
		let born_point_list = []
		for (let key in server_ids) {

			let vo = server_ids[key]
			if (vo.camp == main_role_camp) {
				table.insert(born_point_list, vo.camp)
			}
		}
		let list = []
		let GetCanAttackScene
		GetCanAttackScene = (scene_id?) => {
			scene_id = Number(scene_id)
			let scene_data = this.GetSceneData(scene_id)
			if (scene_data && (scene_data.bl_server == main_role_camp || scene_data.before_blserver == main_role_camp)) {
				let relation_cfg = this.GetSceneRelationCfg(scene_id)
				let scene_list = ErlangParser.GetInstance().Parse(relation_cfg.scene_list)
				for (let key in scene_list) {

					let id = scene_list[key]
					if (!IsInTable(id, list)) {
						table.insert(list, id)
						GetCanAttackScene(id)
					}
				}
			} else {
				return false
			}
		}

		if (born_point_list) {
			for (let _tmpi in born_point_list) {
				var point = born_point_list[_tmpi]
				let relation_cfg = this.GetSceneRelationCfg(point)
				let scene_list = ErlangParser.GetInstance().Parse(relation_cfg.scene_list)
				for (let key in scene_list) {

					let id = Number(scene_list[key])
					if (!IsInTable(id, list)) {
						table.insert(list, id)
						GetCanAttackScene(id)
					}
				}
			}
		}
		table.sort(list, (a?, b?) => {
			let a_lv = this.scene_dic[a]
			let b_lv = this.scene_dic[b]
			if (a_lv == b_lv) {
				return b_lv > a_lv
			} else {
				return Number(b) > Number(a)
			}
		})

		this.ChangeVar("can_attack_scene_list", list)
	}

	public GetCanAttackServerList() {
		return this.can_attack_scene_list
	}

	public RefreshAllCanMoveSceneList(){
		let map_data = this.map_data
		let server_ids = map_data && map_data.server_ids
		if (!server_ids) {
			return
		}
		let main_role_camp = this.GetCampByServerId(RoleManager.GetInstance().GetMainRoleVo().server_unique_id)
		let born_point_list = []
		for (let key in server_ids) {

			let vo = server_ids[key]
			if (vo.camp == main_role_camp) {
				table.insert(born_point_list, vo.camp)
			}
		}
		let list = []
		let GetMoveScene
		GetMoveScene = (scene_id) => {
			let relation_cfg = this.GetSceneRelationCfg(scene_id)
			let scene_list = ErlangParser.GetInstance().Parse(relation_cfg.scene_list)
			for (let key in scene_list) {
				let id = Number(scene_list[key])
				if (!IsInTable(id, list)) {
					table.insert(list, id)
					GetMoveScene(id)
				}
			}
		}

		if (born_point_list) {
			for (let _tmpi in born_point_list) {
				var point = born_point_list[_tmpi]
				let relation_cfg = this.GetSceneRelationCfg(point)
				let scene_list = ErlangParser.GetInstance().Parse(relation_cfg.scene_list)
				for (let key in scene_list) {
					let id = Number(scene_list[key])
					if (!IsInTable(id, list)) {
						table.insert(list, id)
						GetMoveScene(id)
					}
				}
			}
		}
		table.sort(list, (a?, b?) => {
			let a_lv = this.scene_dic[a]
			let b_lv = this.scene_dic[b]
			if (a_lv == b_lv) {
				return b_lv > a_lv
			} else {
				return Number(b) > Number(a)
			}
		})

		this.can_move_scene_list = list
	}

	public GetCanMoveSceneList() {
		return this.can_move_scene_list
	}
	

	public IsCanAttackScene(id?) {

		let bool = false
		if (this.can_attack_scene_list) {
			for (let _tmpi in this.can_attack_scene_list) {
				var scene_id = this.can_attack_scene_list[_tmpi]
				if (Number(scene_id) == id) {
					bool = true
					break
				}
			}
		}
		return bool
	}

	public GetServerName(server_id?) {

		let server_ids = this.map_data && this.map_data.server_ids
		if (server_ids) {
			for (let _tmpi in server_ids) {
				var vo = server_ids[_tmpi]
				if (vo.server_id == server_id) {
					return vo.server_name
				}
			}
		}
		return ""
	}

	public GetServerNum(server_id?) {

		let server_ids = this.map_data && this.map_data.server_ids
		if (server_ids) {
			for (let _tmpi in server_ids) {
				var vo = server_ids[_tmpi]
				if (vo.server_id == server_id) {
					return vo.server_num
				}
			}
		}
		return ""
	}

	public StartRefreshSceneData() {

		let loop_func = () => {
			this.RefreshSceneData()
		}
		this.StartCountTime(KfHolyAreaModel.time_type.refresh_scene_data, loop_func, KfHolyAreaDefine.RefreshSceneDataTime)
	}

	public CancelRefreshSceneData() {

		this.CancelCountTime(KfHolyAreaModel.time_type.refresh_scene_data)
	}

	public SetEnterInfo(info?) {

		this.enter_info = info
	}

	public GetEnterInfo() {

		return this.enter_info
	}

	public GetOpenState(is_need_tip?) {

		let level = RoleManager.GetInstance().GetMainRoleVo().level
		let cond_level = this.GetKeyValue("open_lv")
		if (level < cond_level) {
			if(is_need_tip){
				return [false, `${TransformLevel(cond_level)}级`]
			}else{
				return [false, ""]
			}
		}
		let open_day = ServerTimeModel.GetInstance().GetOpenServerDay()

		// if (open_day == KfHolyAreaDefine.NoticeIconShowDay) {
		// 	return [true, "明天开启"]
		// }
		let min_open_day = 999999
		let max_open_day = 0
		let cfg = this.Csanctuarytype
		if (cfg) {
			for (let key in cfg) {

				let vo = cfg[key]
				if (vo.open_min < min_open_day) {
					min_open_day = vo.open_min
				}
				if (vo.open_max > max_open_day) {
					max_open_day = vo.open_max
				}
			}
		}
		if (open_day < min_open_day) {
			if(is_need_tip){
				return [false, `开服第${min_open_day}天`]
			}else{
				return [false, ""]
			}
		}
		let bool = false
		let difference = max_open_day - open_day
		let data = new Date(TimeUtil.getServerTimeMs())
		data.setHours(0)
		data.setMinutes(0)
		data.setSeconds(0)
		let open_day_zero_time = data.getTime() / 1000
		let max_open_day_time = open_day_zero_time + difference * 24 * 60 * 60
		let total_time = this.GetTotalTime()
		let end_time = Math.floor(total_time + max_open_day_time)
		if (TimeUtil.getServerTime() <= end_time) {
			bool = true
		}
		return [bool, ""]
	}

	public RefreshScoreRed() {

		let score_bool = false
		let score_data = this.score_data
		if (score_data) {
			for (let _tmpi in score_data.score_reward) {
				var value = score_data.score_reward[_tmpi]
				if (value.state == 1) {
					score_bool = true
					break
				}
			}
		}
		this.SetRedFlag(KfHolyAreaModel.RedFlag.Score, score_bool)
	}

	public RefreshOwnerRewardRed() {

		let owner_bool = false
		let build_data = this.build_data
		if (build_data) {
			for (let key in build_data) {

				let value = build_data[key]
				if (value && value.bl_reward_recieve == 1) {
					owner_bool = true
					break
				}
			}
		}
		this.SetRedFlag(KfHolyAreaModel.RedFlag.OwnerReward, owner_bool)
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
		this.Fire(KfHolyAreaModel.REFRESH_RED_FLAG, flag)
		GlobalEventSystem.Fire(EventName.REFRESH_ACTIVITY_ICON_RED_DOT, KfHolyAreaDefine.Module_Id)
	}

	public HasRedFlag(flag?) {

		if (!flag) {
			return false
		}
		return ((this.red_flag & flag) != 0)
	}

	public GetRedState() {

		return this.GetOpenState() && (this.red_flag > 0 && this.GetIsInTime()) || false
	}
	public GetIsInTime() {
		let time_data = this.time_data
		if (!time_data) {

			return false
		}
		let now_time = TimeUtil.getServerTime()
		if (now_time > time_data.act_end || now_time < time_data.act_start) return false
		return true
	}

	public RefreshIcon() {

		let [bool, tips] = this.GetOpenState()
		if (bool) {
			ActivityIconManager.GetInstance().addIcon(KfHolyAreaDefine.Module_Id, null, null, tips)
			//if (tips && tips ~="" ) {
			GlobalEventSystem.Fire(ActivityIconManager.SET_ICON_TEXT, KfHolyAreaDefine.Module_Id, tips)
			//}
		} else {
			ActivityIconManager.GetInstance().deleteIcon(KfHolyAreaDefine.Module_Id)
		}
	}

	public GetTypeCfg(type?) {

		return this.Csanctuarytype && this.Csanctuarytype[type]
	}

	public GetMapCfg() {

		let data = this.map_data
		let san_type = data && data.san_type
		if (san_type) {
			return this.ConfigKfHolyArena && this.ConfigKfHolyArena[san_type - 1]
		}
	}

	public GetSceneRelationCfg(scene_id?) {

		return this.Csanctuaryinfo && this.Csanctuaryinfo[scene_id]
	}

	public GetMonsterCfg(monster_id?) {

		return this.Csanctuarymon && this.Csanctuarymon[monster_id]
	}

	public GetMonsterTypeCfg(type?, con_type?) {

		if (type && con_type) {
			return this.Csanctuarymontype && this.Csanctuarymontype[type + "@" + con_type]
		}
	}

	public GetScoreCfg(score?) {

		for (let key in this.Csanctuaryscore) {

			let value = this.Csanctuaryscore[key]
			if (value && value.score == score) {
				return value
			}
		}
	}

	public GetKeyValue(key?) {

		return this.Csanctuarykv && this.Csanctuarykv[key] && this.Csanctuarykv[key].value
	}

	public GetBuildCfg(type?) {

		let world_lv = RoleManager.GetInstance().GetMainRoleVo().worldLv
		for (let key in this.Csanctuaryconstruction) {

			let vo = this.Csanctuaryconstruction[key]
			if ((vo.type == type && vo.lv_min <= world_lv) && vo.lv_max >= world_lv) {
				return vo
			}
		}
	}

	public GetBossRewardPeview(mode?, build_type?, mon_type?) {

		let world_lv = RoleManager.GetInstance().GetMainRoleVo().worldLv
		let min_lv = null
		let max_lv = null
		if (!this.world_lv_list) {
			this.world_lv_list = JSON.parse(this.GetKeyValue("world_lv_list"))
		}
		for (let _tmpi in this.world_lv_list) {
			var value = this.world_lv_list[_tmpi]
			if (Number(value[0]) <= world_lv && Number(value[1]) >= world_lv) {
				let key = mode + "@" + build_type + "@" + mon_type + "@" + value[0] + "@" + value[1]
				if (this.Csanrewardpreview[key]) {
					return this.Csanrewardpreview[key]
				}
			}
		}
	}

	public JudgeTired(show?) {

		if (show == null) {
			show = false
		}
		let flag = true
		let score_data = this.score_data
		if (score_data) {
			let anger = score_data.anger
			let anger_limit = this.GetKeyValue("anger_limit")
			flag = anger_limit && anger_limit > anger
			if (!flag) {
				if (show) {
					Message.show("今日怒气已满，无法对BOSS造成伤害！")
				}
			}
		}
		return flag
	}

	public IsPeaceBoss(boss_id?) {

		let boss_cfg = this.GetMonsterCfg(boss_id)
		let bool = false
		if (boss_cfg) {
			if (boss_cfg.type > 3) {
				bool = true
			}
		}
		return bool
	}

	feast_boss_timer_id
	FeastIconTimeShow = () => {
		let icon_id = "284";
		if(!ActivityIconManager.GetInstance().getIconInfo(icon_id)){
			this.CancelTimer();
			return
		}
		let map_data = this.map_data;
		if (!map_data || !this.GetOpenState()) return;
		let time_data = this.time_data;
		if (!time_data) return;
		let now_time = TimeUtil.getServerTime();
		let is_in_activity_time = this.GetNextTimeStamp();
		let left_time = is_in_activity_time - TimeUtil.getServerTime();
		if (now_time > time_data.act_end || now_time + 300 < time_data.act_start || is_in_activity_time == 0) {
			GlobalEventSystem.Fire(ActivityIconManager.SET_ICON_TEXT, icon_id, "");
		}else if(is_in_activity_time > 0 && left_time > 0 && left_time <= 300){
			let str = TimeUtil.convertTimeColor(left_time);
			GlobalEventSystem.Fire(ActivityIconManager.SET_ICON_TEXT, icon_id, str, "#fe1a1a");
		}else{
			let build_data = this.build_data;
			let bool = true;
			if (build_data) {
				for (let key in build_data) {
					let value = build_data[key];
					let scenes: number[] = JSON.parse(this.CsanctuaryScene[1012].scenes);
					let isSy = scenes.indexOf(value.scene);
					if (value && isSy > -1 && value.bl_server == 0) {
						bool = false;
						break;
					}
				}
			}
			if(bool){
				GlobalEventSystem.Fire(ActivityIconManager.SET_ICON_TEXT, icon_id, "");
			}else{
				GlobalEventSystem.Fire(ActivityIconManager.SET_ICON_TEXT, icon_id, "抢夺中", "#88ff43");
			}
		}
		this.StartFeastTimer();
	}

	StartFeastTimer = () => {
		if (!this.feast_boss_timer_id) {
			let loop_func = () => {
				this.FeastIconTimeShow()
			}
			this.feast_boss_timer_id = GlobalTimerQuest.AddPeriodQuest(() => {
				loop_func()
			}, 1)
		}
	}

	CancelTimer = () => {
		if (this.feast_boss_timer_id) {
			GlobalTimerQuest.CancelQuest(this.feast_boss_timer_id)
			this.feast_boss_timer_id = null
		}
	}

	public GetNextTimeStamp(): number {
		let _refresh_time = this.getBossRefreshTime()
		if (_refresh_time) {
			let date = new Date();
			date.setHours(_refresh_time[0]);
			date.setMinutes(_refresh_time[1]);
			date.setSeconds(0);
			let teamp = Math.round(date.getTime() / 1000);
			return teamp
		}
		return 0
	}

	public getBossRefreshTime() {
		let date = new Date(TimeUtil.getServerTime() * 1000)
		let now_hour = date.getHours()
		let now_minute = date.getMinutes()
		let refresh_cfg = this.GetKeyValue("reborn_time")
		let time = null
		if (refresh_cfg) {
			refresh_cfg = JSON.parse(refresh_cfg)
			for (let key in refresh_cfg) {
				let vo = refresh_cfg[key]
				vo[0] = Number(vo[0])
				vo[1] = Number(vo[1])
				if (vo[0] == now_hour) {
					if (vo[1] > now_minute) {
						time = vo
						break
					}
				} else if (vo[0] > now_hour) {
					time = vo
					break
				}
			}
		}
		return time
	}

	//=============================================异域建筑占领排行榜===================================
	public updateRankData(scmd) {
		if (scmd) {
			let scene_data = this.GetSceneData(scmd.scene_id)
			if(scene_data){
				scene_data.rank_list = scmd.rank_list
			}
		}
	}

	//=============================================被占领后跳转其他异域场景===================================
	//异域场景及异域建筑类型映射[3异域， 2城堡，1要塞]
	is_jump_tips:boolean = false;
	scene_id_type_map
	public initSceneTypeMap() {
		this.scene_id_type_map = {};
		//异域列表
		let scenes1: number[] = JSON.parse(this.CsanctuaryScene[1012].scenes);
		for (let i = 0; i < scenes1.length; i++) {
			this.scene_id_type_map[scenes1[i]] = 3
		}
		//城堡列表
		let scenes2: number[] = JSON.parse(this.CsanctuaryScene[1011].scenes);
		for (let i = 0; i < scenes2.length; i++) {
			this.scene_id_type_map[scenes2[i]] = 2
		}
		//城堡列表
		let scenes3: number[] = JSON.parse(this.CsanctuaryScene[1010].scenes);
		for (let i = 0; i < scenes3.length; i++) {
			this.scene_id_type_map[scenes3[i]] = 1
		}
	}

	public jumpSceneId(scene_id: number) {
		if (this.scene_id_type_map[scene_id] == null) return;
		let can_attack_scene_list = this.can_attack_scene_list;
		let _can_jump_scenes: number[] = [];
		if (can_attack_scene_list && can_attack_scene_list.length) {
			for (let i = 0, len = can_attack_scene_list.length; i < len; i++) {
				let _sceneId = can_attack_scene_list[i];
				if(scene_id == Number(_sceneId))continue;
				let _build_data = this.GetSceneData(_sceneId)
				if (!_build_data || _build_data.bl_server != 0) continue;
				table.insert(_can_jump_scenes, _sceneId)
			}
		}
		if (_can_jump_scenes.length) {
			if(_can_jump_scenes.length > 1){
				//异域列表
				table.sort(_can_jump_scenes, (a, b) => {
					let atype = this.scene_id_type_map[a];
					let btype = this.scene_id_type_map[b];
					return atype > btype
				})
			}
			setTimeout(() => {
				this.Fire(KfHolyAreaModel.OPEN_VIEW, "KfHolyAreaJumpView", _can_jump_scenes[0])
			}, 1000);
		}
	}
}
window["KfHolyAreaModel"] = KfHolyAreaModel
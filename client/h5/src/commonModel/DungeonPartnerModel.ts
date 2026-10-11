import { CommonManager } from "../common/CommonManager"
import { Config } from "../common/Config"
import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { DungeonEnterView } from "../dungeon/DungeonEnterView"
import { RoleManager } from "./RoleManager"
import { GlobalEventSystem, LOAD_QUEUE } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { EventDispatcher } from "../util/EventDispatcher"
import { Util } from "../util/Util"
import { BaseDungeonModel } from "./BaseDungeonModel"
import { VipModel } from "./VipModel"
import { FirstBloodModel } from "./FirstBloodModel"
import { RedDotController } from "../common/RedDotController"
import { RedKey } from "../common/RedDotDefine"


export class DungeonPartnerModel extends EventDispatcher {

	public static REQUEST_CCMD_EVENT = "REQUEST_CCMD_EVENT"
	public static UPDATE_PARTNER_VIEW = "UPDATE_PARTNER_VIEW"
	public static UPDATE_PARTNER_VIEW_STAGE_REWARD = "UPDATE_PARTNER_VIEW_STAGE_REWARD"
	public static UPDATE_PARTNER_SCENE_BATTLE_INFO = "UPDATE_PARTNER_SCENE_BATTLE_INFO"
	public static UPDATE_PARTNER_RED_POINT = "UPDATE_PARTNER_RED_POINT"


	public static RED_POINT_TYPE = {
		CHALLENGE: 0x01, //可挑战关卡，并且战力达到推荐战力（如一星通关满足二星推荐战力）
		SWEEP: 0x02, //扫荡次数
		STAGE_REWARD: 0x04, //阶段奖励宝箱
		FIRST_KILL_REWARD: 0x08, //首杀奖励
	}

	static Instance: DungeonPartnerModel

	view_info = {}
	sweep_count = 999
	stage_reward_info = {}
	red_flage = 0
	cur_page = null
	sweep_show_alert = null

	public constructor() {
		super()
		if (DungeonPartnerModel.Instance) {
			return
		}
		DungeonPartnerModel.Instance = this
	}

	public Clear() {

	}

	public static GetInstance() {
		if (!DungeonPartnerModel.Instance) {
			new DungeonPartnerModel()
		}
		return DungeonPartnerModel.Instance
	}

	public SetViewInfo(scmd61105?) {

		this.view_info[scmd61105.level] = scmd61105
		this.sweep_count = scmd61105.sweep_count
	}

	public GetViewInfo(level?) {
		return this.view_info[level]
	}

	public SetStageRewardInfo(scmd61106?) {

		this.stage_reward_info[scmd61106.level] = scmd61106
	}

	public GetStageRewardInfo(level?) {

		return this.stage_reward_info[level]
	}

	public SetPage(page?) {

		this.cur_page = page
	}

	public GetPage() {

		//初始化默认值
		if (!this.cur_page) {
			this.SetDefaultPage()
		}
		return this.cur_page
	}

	public GetStageUnlockLv(dun_id) {
		let cfg_dungeon = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_dungeon.name, dun_id, false)
		if (!cfg_dungeon) {
			return 999
		}
		let cond = ErlangParser.GetInstance().Parse(cfg_dungeon.condition)
		let unlock_lv = 0
		for (let i = 0; i < cond.length; i++) {
			let v = cond[i]
			if ("lv" == v[0]) {
				unlock_lv = Number(v[1])
				break
			}
		}
		return unlock_lv
	}

	//获取章节扫荡剩余次数
	public GetLeftSweepTime() {
		let total_time = VipModel.GetInstance().GetVipPrivilegeValue(BaseDungeonModel.MODULE_ID, 2000037, 99, RoleManager.GetInstance().GetMainRoleVo().vip_flag)
		//扫荡次数与章节无关
		if(total_time){
			return total_time - this.sweep_count
		}
		else{
			return 0
		}
	}

	public GetRedState() {
		return this.red_flage > 0 && CommonManager.GetInstance().CheckFuncOpenState("DungeonPartnerView", true)
	}

	public HasRedPointFlag(flag?) {
		return ((this.red_flage & flag) != 0)
	}

	public SetRedPointFlag(flag?, state?) {

		// this.red_point_list[flag] = state
		let now_flag
		if (state) {
			now_flag = this.red_flage | flag
		} else {
			now_flag = this.red_flage & ~flag
		}
		if (now_flag == this.red_flage) {
			return
		}
		this.red_flage = now_flag

		this.Fire(DungeonPartnerModel.UPDATE_PARTNER_RED_POINT)
		let red_state = this.GetRedState()
		GlobalEventSystem.Fire(
			EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE,
			"DungeonEnterView",
			DungeonEnterView.Index.DungeonPartner,
			red_state
		)
		GlobalEventSystem.Fire(EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 610)
	}

	public CheckFirstKillRedPoint(scmd?) {

		for (let i = 0; i < scmd.first_blood_list.length; i++) {
			let v = scmd.first_blood_list[i]
			if (0 == v.reward_state) { // 可领取
				this.SetRedPointFlag(DungeonPartnerModel.RED_POINT_TYPE.FIRST_KILL_REWARD, true)
				return
			}
		}
		this.SetRedPointFlag(DungeonPartnerModel.RED_POINT_TYPE.FIRST_KILL_REWARD, false)
	}
	
	public IsDungeonChallengeRedPoint(dun_id) {
		let dungeon_client_cfg = Config.PRELOAD_CLIENT_CONFIG.ConfigDungeonClient
		let level = RoleManager.GetInstance().GetMainRoleVo().level
		let fighting = RoleManager.GetInstance().GetMainRoleVo().fighting
		let len = Util.TableSize(this.view_info)
		for (let i = 1; i <= len; i++) {
			let level_data = this.view_info[i]
			for (let _ = 0; _ < level_data.dun_list.length; _++) {
				let v = level_data.dun_list[_]
				if (dun_id == v.dun_id) {
					let unlock_lv = this.GetStageUnlockLv(v.dun_id)
					let recommend_power = dungeon_client_cfg.recommend_power[v.dun_id][Math.min(v.score + 1, 3) - 1]
					//等级满足，还没打够三星，并且战力满足下一个星的推荐战力，给红点
					if (level >= unlock_lv && fighting >= recommend_power && v.score < 3) {
						return true
					} else {
						return false
					}
				} else if (0 == v.score) {
					//该副本有未通过的前置任务
					return false
				}
			}
		}
	}

	//是否完成前置副本
	public IsFinishPreDungeon(dun_id?) {
		let len = Util.TableSize(this.view_info)
		for (let i = 1; i <= len; i++) {
			let level_data = this.view_info[i]
			for (let _ = 0; _ < level_data.dun_list.length; _++) {
				let v = level_data.dun_list[_]
				if (dun_id == v.dun_id) {
					return true
				} else if (0 == v.score) {
					//该副本有未通过的前置任务
					return false
				}
			}
		}
	}

	public SetDefaultPage() {
		let len = Util.TableSize(this.view_info)
		for (let i = 1; i <= len; i++) {
			if(this.CheckPageChallengeRedPoint(i) || this.CheckPageFirstBloodRedPoint(i) || this.IsStageRewardRedPoint(i)){
				this.SetPage(i)
				return
			}
			let level_data = this.view_info[i]
			for (let _ = 0; _ < level_data.dun_list.length; _++) {
				let v = level_data.dun_list[_]
				if (v.score < 3) {
					this.SetPage(i)
					return
				}
			}
		}
		this.SetPage(len)
	}

	//是否有未领取的阶段奖励
	public IsStageRewardRedPoint(level?) {

		let info = this.GetStageRewardInfo(level)
		if (info) {
			for (let i = 0; i < info.stage_reward.length; i++) {
				let v = info.stage_reward[i]
				if (1 == v.status) { //可领取
					return true
				}
			}
		}
		return false
	}

	public CheckPageChallengeRedPoint(page?) {
		let dungeon_client_cfg = Config.PRELOAD_CLIENT_CONFIG.ConfigDungeonClient
		let fighting = RoleManager.GetInstance().GetMainRoleVo().fighting
		let level = RoleManager.GetInstance().GetMainRoleVo().level
		let level_data = this.view_info[page]
		for (let _ = 0; _ < level_data.dun_list.length; _++) {
			let v = level_data.dun_list[_]
			if(this.IsFinishPreDungeon(v.dun_id)){
				let unlock_lv = this.GetStageUnlockLv(v.dun_id)
				let power_tbl = dungeon_client_cfg.recommend_power[v.dun_id]
				if (power_tbl) {
					let recommend_power = power_tbl[Math.min(v.score + 1, 3) - 1]
					//等級滿足，還沒打夠三星，並且戰力滿足下一個星的推薦戰力，給紅點
					if (level >= unlock_lv && v.score < 3 && fighting >= recommend_power) {
						return true
					}
				}
			}
		}
		return false
	}

	public CheckChallengeRedPoint() {
		
		let find = false
		if(CommonManager.GetInstance().CheckFuncOpenState("DungeonPartnerView", true)){
			let len = Util.TableSize(this.view_info)
			for (let i = 1; i <= len; i++) {
				if(this.CheckPageChallengeRedPoint(i)){
					find = true
					break
				}
				// let level_data = this.view_info[i]
				// for (let _ = 0; _ < level_data.dun_list.length; _++) {
				// 	let v = level_data.dun_list[_]
				// 	let unlock_lv = this.GetStageUnlockLv(v.dun_id)
				// 	let power_tbl = dungeon_client_cfg.recommend_power[v.dun_id]
				// 	if (power_tbl) {
				// 		let recommend_power = power_tbl[Math.min(v.score + 1, 3)]
				// 		//等級滿足，還沒打夠三星，並且戰力滿足下一個星的推薦戰力，給紅點
				// 		if (level >= unlock_lv && v.score < 3 && fighting >= recommend_power) {
							
				// 			break
				// 		}
				// 	}
				// }
			}
		}
		this.SetRedPointFlag(DungeonPartnerModel.RED_POINT_TYPE.CHALLENGE, find)
		RedDotController.ins.up(RedKey.PARTNER_DUNGEON_CHALLENGE, find ? 1 : 0);
	}

	public TryRefreshChallengeRed() {
		this.CheckChallengeRedPoint()
	}


	public CheckPageFirstBloodRedPoint(page?) {
		let level_data = this.view_info[page]
		for (let _ = 0; _ < level_data.dun_list.length; _++) {
			let v = level_data.dun_list[_]
			if(this.CheckDunFirstBloodRedPoint(v.dun_id)){
				return true
			}
		}
		return false
	}

	public CheckDunFirstBloodRedPoint(dun_id){
		let kill_info = FirstBloodModel.GetInstance().GetKillInfo(97, 1)
		if (kill_info) {
			for (let i = 0; i < kill_info.first_blood_list.length; i++) {
				let v = kill_info.first_blood_list[i]
				if (v.boss_id == dun_id) {
					return 0 == v.reward_state
				}
			}
		}
		return false
	}

	public GetDunFirstBloodData(dun_id){
		let kill_info = FirstBloodModel.GetInstance().GetKillInfo(97, 1)
		if (kill_info) {
			for (let i = 0; i < kill_info.first_blood_list.length; i++) {
				let v = kill_info.first_blood_list[i]
				if (v.boss_id == dun_id) {
					return v
				}
			}
		}
	}
}

window["DungeonPartnerModel"] = DungeonPartnerModel
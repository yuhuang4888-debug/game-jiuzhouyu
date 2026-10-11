import { EventDispatcher } from "../util/EventDispatcher"
import { RoleManager } from "./RoleManager"
import { TimeUtil } from "../util/TimeUtil";
import { BaseDungeonModel } from "./BaseDungeonModel";
import { ServerTimeModel } from "../serverTime/ServerTimeModel";
import { Config } from "../common/Config";

export class FirstRechargeModel extends EventDispatcher {
	bubble_time
	first_recharge_info
	func_state
	iconRed
	is_bubble
	is_notify
	loginfirst
	open_func_lv
	plat_mgr
	role_mgr
	qipao_info
	is_show_qipao = false
	public first_show_tips = true//第一次登陆显示tips

	public static SCMD_REQUEST = "FirstRechargeModel.SCMD_REQUEST"
	public static UPDATE_FIRST_RECHARGE_VIEW = "FirstRechargeModel.UPDATE_FIRST_RECHARGE_VIEW"
	public static OPEN_FIRST_RECHARGE_VIEW = "FirstRechargeModel."
	public static OPEN_FIRST_RECHARGE_TIPS_VIEW = "FirstRechargeModel.OPEN_FIRST_RECHARGE_TIPS_VIEW"
	public static ADD_BUBBLE = "FirstRechargeModel.ADD_BUBBLE"
	public static CLOSE_NEW_TIPS_VIEW = "CLOSE_NEW_TIPS_VIEW"
	public static RECEVIED_SUCCESS = "FR1"
	public static MaxDay = 3
	public static CREAT_FIRST_QIPAO = "CREAT_FIRST_QIPAO"
	public static ADD_FIRST_RECHARGE_NEW_TIPS_ITEM = "ADD_FIRST_RECHARGE_NEW_TIPS_ITEM"
	public static REMOVE_FIRST_RECHARGE_NEW_TIPS_ITEM = "REMOVE_FIRST_RECHARGE_NEW_TIPS_ITEM"
	static Instance: FirstRechargeModel
	public constructor() {
		super()

		if (FirstRechargeModel.Instance) {
			return
		}
		FirstRechargeModel.Instance = this

		this.role_mgr = RoleManager.GetInstance()
		//this.plat_mgr = PlatformMgr.GetInstance()

		this.first_recharge_info = null
		this.iconRed = false
		this.loginfirst = true
		this.is_notify = 0
		this.is_bubble = false
		this.bubble_time = null
		this.func_state = null
		this.qipao_info = { "str": null, "time": null }
		//let cfg = Config.ConfigFirstRecharge
		// if (this.plat_mgr.IsEyouJpPlatform() ) {
		// 	this.open_func_lv = cfg.open_func_lv_jp
		// }else{
		this.open_func_lv = 0
		//}

	}

	// 首充结束
	// 首充了
	public IsDoneFirstRecharge() {

		if (this.first_recharge_info) {
			for (let _tmpi in this.first_recharge_info.reward_list) {
				var vo = this.first_recharge_info.reward_list[_tmpi]
				if (vo.open != 0 && vo.open != 5) {
					return true
				}
			}
		}
	}

	// 首充并且领取了所有奖励
	public IsDoneAllReward() {

		if (this.first_recharge_info) {
			for (let _tmpi in this.first_recharge_info.reward_list) {
				var vo = this.first_recharge_info.reward_list[_tmpi]
				if (vo.open != 4) {
					return false
				}
			}
			return true
		}
	}

	// 是否未首充
	public IsNoFirstRecharge() {

		if (this.first_recharge_info) {
			let over = false
			for (let _tmpi in this.first_recharge_info.reward_list) {
				var vo = this.first_recharge_info.reward_list[_tmpi]
				if (vo.open == 0) {
					return true
				}
			}
		}
	}

	// 领奖时间未到
	public HasNoRecevie() {

		if (this.first_recharge_info) {
			for (let _tmpi in this.first_recharge_info.reward_list) {
				var vo = this.first_recharge_info.reward_list[_tmpi]
				if (vo.open == 2) {
					return true
				}
			}
		}
	}

	public GetBubbleTime() {

		if (!this.bubble_time && this.func_state != 1) {
			let role_vo = this.role_mgr.GetMainRoleVo()
			// if (this.plat_mgr.IsEyouJpPlatform() ) {
			// 	//日服20级之后才开始所有的首充流程
			// 	let reach_time = CookieWrapper.GetInstance().GetCookie(CookieLevelType.Account,CookieKey.FIRST_RECHARGE_OPEN)
			// 	if (reach_time ) {
			// 		this.bubble_time = reach_time + 30*60
			// 		this.func_state = 0
			// 	}else{
			// 		if (role_vo.level >= this.open_func_lv ) {
			// 			//超过指定等级却未记录,直接跳到主图标阶段
			// 			this.func_state = 1
			// 		}else{
			// 			//未达到流程开启的指定等级
			// 			this.func_state = 2
			// 		}
			// 	}
			// }else{
			//正常情况，创角30分钟
			this.bubble_time = role_vo.create_role_time + 30 * 60
			this.func_state = 0
			//}
		}
		return [this.bubble_time, this.func_state]
	}
	//是否是创角第一天第二次经验副本
	public IsCreatRoleFirstDayTwithExp() {
		let role_vo = this.role_mgr.GetMainRoleVo()
		let creat_time = role_vo.create_role_time
		let next_day_time = TimeUtil.GetFutureZeroStamp(1)
		let is_first_day = (((next_day_time - creat_time) / 60 / 60) < 24)
		let dungeon_info = BaseDungeonModel.GetInstance().GetDungeonInfo(20)
		let dungeon_exp_time = 0
		for (let key in dungeon_info) {
			let info = dungeon_info[key]
			dungeon_exp_time += info.daily_count
		}
		return is_first_day && dungeon_exp_time == 1
	}

	public GetFirstRechargeQiPaoInfo() {
		let time = RoleManager.GetInstance().GetMainRoleVo().create_role_time
		let cfg = Config.PRELOAD_CLIENT_CONFIG.ConfigFirstRecharge
		let openDay = ServerTimeModel.GetInstance().GetOpenServerDay()
		let create_time = TimeUtil.getServerTime() - time
		let create_role_day = create_time / (24 * 3600)
		if (cfg.new_tips_show_create_role_day < create_role_day) {
			return this.qipao_info
		}
		openDay = openDay < 1 ? 1 : openDay
		openDay = openDay >= 3 ? 3 : openDay
		if (this.IsNoFirstRecharge()) {
			this.qipao_info.str = cfg.qipao_info[openDay][0].info
			this.qipao_info.time = cfg.qipao_info[openDay][0].time
		} else {
			this.qipao_info.str = cfg.qipao_info[openDay][1].info
			this.qipao_info.time = cfg.qipao_info[openDay][1].time
		}
		return this.qipao_info
	}

	public static GetInstance() {

		if (!FirstRechargeModel.Instance) {
			FirstRechargeModel.Instance = new FirstRechargeModel()
		}
		return FirstRechargeModel.Instance
	}

	public ResetModel() {

		this.first_recharge_info = null
		this.iconRed = false
		this.loginfirst = true
		this.is_notify = 0
		this.is_bubble = false
		this.bubble_time = null
		this.func_state = null
	}
}

window["FirstRechargeModel"] = FirstRechargeModel
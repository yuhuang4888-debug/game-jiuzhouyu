import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { ActivityIconManager } from "../commonModel/ActivityIconManager"
import { RoleManager } from "./RoleManager"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventDispatcher } from "../util/EventDispatcher"
import { Config } from "../common/Config"

export class TopPkModel extends EventDispatcher {
	static Instance: TopPkModel
	static REQUEST_SCMD = "TopPkModel.REQUEST_SCMD"
	static OPEN_VIEW = "TopPkModel.OPEN_VIEW"
	static CLOSE_VIEW = "TopPkModel.CLOSE_VIEW"
	static GET_DAILY_COUNT_REWARD = "TopPkModel.GET_DAILY_COUNT_REWARD"
	static REFRESH_RED_FLAG = "TopPkModel.REFRESH_RED_FLAG"

	static PRELOAD_SERVER_CONFIG = {
		"config_top_pk_rank_reward": null
	}

	static RedFlag = {
		Level_Reward: 0x001, 		//段位奖励
		Daily_Reward: 0x002, 		//每日奖励
		Daily_Count: 0x004, 	//每日挑战次数
		Act_Open: 0x008,	//活动开启(打开界面取消)	
	}

	static RedALLFlag = 0
	// base_data //基本信息

	//赛季信息
	season_data: {
		season_count: number,
		season_num: number,
		season_end_time: number,
		season_win_count: number
	}

	//段位信息	
	level_data: {
		rank_lv: number,
		point: number
	}

	//每日次数信息
	daily_count_data: {
		daily_buy_count: number,
		daily_count: number,
		daily_reward_counts: Array<{ count: number, state: number }>
	}

	//每日奖励信息
	daily_reward_data: {
		honor_is_got: number,
		daily_honor_value: number,
		yesterday_rank_lv: number
	}

	level_reward_data //段位等级奖励列表
	act_state_data //活动状态信息
	rank_data //排行榜数据

	match_data //匹配数据

	fight_start_time
	fight_end_time
	quit_scene_time

	//等待匹配
	public wait_match = false
	//自动匹配状态
	public auto_match_state = false
	//function
	InitCfg
	GetOpenState
	GetLevelCfg
	TurnRankLvByPoint
	ResetData
	ResetFightData
	RefreshLevelRewardState
	RefreshDailyCountRed
	RefreshLevelRewardRed
	RefreshDailyRewardRed
	GetRedState
	SetRedFlag
	HasRedFlag
	GetLevelTotalPoint
	SetLevelIcon
	OpenTopView
	RefreshIcon
	RefreshTab
	change_day = false

	get BattleFieldIndex() {
		let open_day = ServerTimeModel.GetInstance().GetOpenServerDay()

		if (open_day < this.changeViewDay) {
			return {
				Arena: 0,
				NineSky: 1,
				HolyBattle: 2,
				Top_Pk: 3,
				GuildFight: 4,
				DuelArena: 999
			}
		}
		else {
			return {
				Arena: 0,
				NineSky: 1,
				HolyBattle: 2,
				Top_Pk: 999,
				GuildFight: 3,
				DuelArena: 999
			}
		}
	}



	get WorldBattleIndex() {
		let open_day = ServerTimeModel.GetInstance().GetOpenServerDay()
		let showTopView = open_day >= TopPkModel.GetInstance().changeViewDay

		if (showTopView) {
			return {
				TOP: 0,
				Diamond_Fight: 1,
				POLAR: 2,
				KF1VN: 3
			}
		}
		else {
			return {
				TOP: 999,
				Diamond_Fight: 0,
				POLAR: 1,
				KF1VN: 2
			}
		}

	}



	changeViewDay = 5 //改变入口的开服天数判断
	public constructor() {
		super()
		let preload_server_config = Config.PRELOAD_SERVER_CONFIG,
			local_TopPkDefine = TopPkDefine,
			local_Number = Number,
			res_mgr = ResManager.GetInstance(),
			local_TopPkModel = TopPkModel,
			local_GlobalEventSystem = GlobalEventSystem,
			local_EventName = EventName,
			red_flag_ = 0

		for (let key in local_TopPkModel.RedFlag) {
			let value = local_TopPkModel.RedFlag[key]
			local_TopPkModel.RedALLFlag += value
		}
		// this.Init()

		this.InitCfg = () => {
			let cfgs = Config.PRELOAD_SERVER_CONFIG.config_top_pk_key_value
			local_TopPkDefine.OPEN_LV = local_Number(cfgs["default@open_lv"].value)
			local_TopPkDefine.OPEN_DAY_COND = JSON.parse(cfgs["open_day_limit@default"].value)
			local_TopPkDefine.DAILY_MATCH_COUNT = local_Number(cfgs["default@daily_count"].value)
			local_TopPkDefine.DAILT_BUY_COUNT = local_Number(cfgs["default@buy_count"].value)
			local_TopPkDefine.BUY_COST = local_Number(cfgs["default@buy_cost"].value)
			local_TopPkDefine.OPEN_AUTO_MATCH_COND = local_Number(cfgs["default@need_time"].value)
		}

		this.GetOpenState = () => {
			let level = RoleManager.GetInstance().GetMainRoleVo().level
			let open_day = ServerTimeModel.GetInstance().GetOpenServerDay()
			let open_day_cond = local_TopPkDefine.OPEN_DAY_COND
			for (let key in open_day_cond) {
				let value = open_day_cond[key]
				if (level >= local_TopPkDefine.OPEN_LV && value && open_day >= value[0] && open_day <= value[1])
					return true
			}
			return false
		}

		this.GetLevelCfg = (key, top_pk_rank_reward_cfg) => {
			return top_pk_rank_reward_cfg && top_pk_rank_reward_cfg[key]
		}

		this.TurnRankLvByPoint = (rank_lv, point, top_pk_rank_reward_cfg) => {

			let cfg = this.GetLevelCfg(rank_lv, top_pk_rank_reward_cfg)
			if (cfg) {
				while (cfg.point <= point) {
					let last_point = cfg.point
					point -= cfg.point
					rank_lv++
					cfg = this.GetLevelCfg(rank_lv, top_pk_rank_reward_cfg)
					if (!cfg) {
						point += last_point
						rank_lv--
						break
					}
				}
			}

			return [rank_lv, point]
		}

		this.ResetData = () => {

		}

		this.ResetFightData = () => {
			this.match_data = undefined
			this.fight_start_time = undefined
			this.fight_end_time = undefined
			this.quit_scene_time = undefined
		}



		this.RefreshLevelRewardState = () => {
			let level_data = this.level_data
			let level_reward_data = this.level_reward_data
			if (level_data && level_reward_data) {
				for (let value of level_reward_data.got_list) {
					if (value.state == 1 && level_data.rank_lv >= value.rank_lv) {
						value.state = 2
					}
				}
				this.ChangeVar("level_reward_data", level_reward_data, false, true)
			}
		}

		this.RefreshDailyCountRed = () => {
			let daily_count_data = this.daily_count_data
			let daily_count_bool = false
			if (daily_count_data) {
				for (let value of daily_count_data.daily_reward_counts) {
					if (value && value.state == 2) {
						daily_count_bool = true
						break
					}
				}
			}
			this.SetRedFlag(local_TopPkModel.RedFlag.Daily_Count, daily_count_bool)
		}

		this.RefreshLevelRewardRed = () => {
			let level_reward_data = this.level_reward_data
			let level_reward_bool = false
			if (level_reward_data) {
				for (let value of level_reward_data.got_list) {
					if (value && value.state == 2) {
						level_reward_bool = true
						break
					}
				}
			}
			this.SetRedFlag(local_TopPkModel.RedFlag.Level_Reward, level_reward_bool)
		}

		this.RefreshDailyRewardRed = () => {
			let daily_reward_data = this.daily_reward_data
			let daily_reward_bool = false
			if (daily_reward_data) {
				daily_reward_bool = daily_reward_data.honor_is_got == 1
			}
			this.SetRedFlag(local_TopPkModel.RedFlag.Daily_Reward, daily_reward_bool)
		}

		this.GetRedState = (need_open_day?) => {
			let open_day = ServerTimeModel.GetInstance().GetOpenServerDay();
			if (open_day >= this.changeViewDay) {
				if (need_open_day)
					return this.GetOpenState() ? red_flag_ > 0 : false
				else
					return false;
			} else {
				if (need_open_day)
					return false
				else
					return this.GetOpenState() ? red_flag_ > 0 : false;
			}
		}


		this.SetRedFlag = (flag, state) => {
			if (!flag) {
				return
			}

			let now_flag = 0
			if (state) {
				now_flag = red_flag_ | flag
			}
			else {
				now_flag = red_flag_ & ~flag
			}

			if (now_flag == red_flag_ && !this.change_day) {//跨天时刷新2个图标
				return
			}

			red_flag_ = now_flag

			this.change_day = false

			this.Fire(local_TopPkModel.REFRESH_RED_FLAG, flag)
			this.RefreshIcon();
			this.RefreshTab();
		}

		//是否包含指定flag
		this.HasRedFlag = (flag) => {
			if (!flag)
				return false
			return ((red_flag_ & flag) != 0)
		}


		this.GetLevelTotalPoint = (level, top_pk_rank_reward_cfg) => {
			let point = 0
			level--
			while (level > 0) {
				let cfg = this.GetLevelCfg(level, top_pk_rank_reward_cfg)
				if (cfg) {
					point += cfg.point
				}
				level--
			}
			return point
		}

		this.SetLevelIcon = (self, img, big_rank, rank_lv, active) => {
			if (!active && active != false)
				active = true
			let level = rank_lv % 5
			if (level == 0)
				level = 5
			if (big_rank == 6)
				level = 1

			let level_url = `${big_rank}_${level}`
			res_mgr.SetTexture(self, img, local_TopPkModel.GetLevelIconUrl(level_url), undefined, this, active)
		}

		this.OpenTopView = () => {
			let open_day = ServerTimeModel.GetInstance().GetOpenServerDay();
			if (open_day >= this.changeViewDay)
				GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "WorldBattleEnterView", this.WorldBattleIndex.TOP);
			else
				GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "BattleFieldEnterView", this.BattleFieldIndex.Top_Pk);
		}

		this.RefreshIcon = () => {
			let open_day = ServerTimeModel.GetInstance().GetOpenServerDay();
			let fullOpenDay = open_day >= this.changeViewDay;
			let icon_red = fullOpenDay ? ActivityIconManager.GetInstance().GetIconRedDot(280) : ActivityIconManager.GetInstance().GetIconRedDot(2820);
			if (fullOpenDay) {
				local_GlobalEventSystem.Fire(local_EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 2820);
				if (icon_red)
					local_GlobalEventSystem.Fire(local_EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 280);
			} else {
				local_GlobalEventSystem.Fire(local_EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 280);
				if (icon_red)
					local_GlobalEventSystem.Fire(local_EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 2820);
			}
		}

		this.RefreshTab = () => {
			let open_day = ServerTimeModel.GetInstance().GetOpenServerDay();
			if (open_day >= this.changeViewDay)
				local_GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "WorldBattleEnterView", this.WorldBattleIndex.TOP, this.GetRedState(true));
			else
				local_GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "BattleFieldEnterView", this.BattleFieldIndex.Top_Pk, this.GetRedState());
		}
	}

	public static GetInstance() {
		if (!TopPkModel.Instance) {
			TopPkModel.Instance = new TopPkModel()
		}
		return TopPkModel.Instance
	}
	public static GetLevelIconUrl(level) {
		return `${TopPkDefine.LEVEL_ICON_URL}${level}.png`
	}

	public static SetRankIcon(img: Laya.Image, rank: number, active: boolean) {
		let rank_url
		switch (rank) {
			case 1:
				rank_url = "rank_icon_1"
				break
			case 2:
				rank_url = "rank_icon_2"
				break
			case 3:
				rank_url = "rank_icon_3"
				break
		}
		if (rank_url) {
			ResManager.GetInstance().SetImageSprite(this, img, "topPk_asset", rank_url, active)
		}
	}
}

export class TopPkDefine {
	//模块ID
	static MODULE_ID = 281
	//开启等级
	static OPEN_LV = 0
	//开服天数
	static OPEN_DAY_COND
	//每日默认匹配次数
	static DAILY_MATCH_COUNT = 0
	//每日可购买匹配次数的次数
	static DAILT_BUY_COUNT = 0
	//购买匹配次数消耗
	static BUY_COST = 0
	//段位图片url
	static LEVEL_ICON_URL = "resource/game/topPk/texture/"
	//特殊货币类型//荣耀值
	static MONEY_TYPE = 41
	//荣耀值图标id
	static MONEY_ICON_ID = "36255010"
	//参战多少场后可开启自动匹配
	static OPEN_AUTO_MATCH_COND = 0

}

window["TopPkModel"] = TopPkModel
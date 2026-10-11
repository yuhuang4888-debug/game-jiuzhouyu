import { CommonManager } from "../common/CommonManager"
import { Config } from "../common/Config"
import { EventName } from "../common/EventName"
import { RedDotController } from "../common/RedDotController"
import { RedKey } from "../common/RedDotDefine"
import { ResManager } from "../common/ResManager"
import { PlatformManager } from "../PlatformManager"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { SkillManager } from "../skill/SkillManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { EventDispatcher } from "../util/EventDispatcher"
import { Util } from "../util/Util"
import { ActivityIconManager } from "./ActivityIconManager"
import { BagModel } from "./BagModel"
import { FirstRechargeModel } from "./FirstRechargeModel"
import { GoodsModel } from "./GoodsModel"
import { MainFunc } from "./MainUIModel"
import { RoleManager } from "./RoleManager"


export interface IDragonBallInfo {
	dragon_id: number;
	dragon_lv: number;
	power: number;
	next_power: number;
}

export interface IDragonSuitInfo {
	type: number;
	lv: number;
	power: number;
	next_power: number;
}

export class DragonBallModel extends EventDispatcher {
	static REQUEST_SCMD = 'DragonBallModel.REQUEST_SCMD'
	static UPDATE_VIEW = 'DragonBallModel.UPDATE_VIEW'
	static SELECT_ITEM = 'DragonBallModel.SELECT_ITEM'
	static REFRESH_RED_FLAG = 'DragonBallModel.REFRESH_RED_FLAG'
	static REFRESH_BALL_LEVEL_UP_RED = 'DragonBallModel.REFRESH_BALL_LEVEL_UP_RED'
	static REFRESH_SUIT_LEVEL_UP_RED = 'DragonBallModel.REFRESH_SUIT_LEVEL_UP_RED'
	static UPDATE_ICON_RED = 'DragonBallModel.UPDATE_ICON_RED'
	static RecvFmt14300 = 'DragonBallModel.RecvFmt14300'
	static RecvFmt14301 = 'DragonBallModel.RecvFmt14301'
	static RecvFmt14302 = 'DragonBallModel.RecvFmt14302'
	static RecvFmt14303 = 'DragonBallModel.RecvFmt14303'
	static RecvFmt14304 = 'DragonBallModel.RecvFmt14304'
	static RecvFmt14306 = 'DragonBallModel.RecvFmt14306'
	static RecvFmt14310 = 'DragonBallModel.RecvFmt14310'
	static UPDATE_GIFT_VIEW = 'DragonBallModel.UPDATE_GIFT_VIEW'
	static ROTATE_BY_ITEM = 'DragonBallModel.ROTATE_BY_ITEM'
	static ROTATE_BY_ITEM_FINSIH = 'DragonBallModel.ROTATE_BY_ITEM_FINSIH'

	static BallInfoDic = {
		38410001: { index: 1, dragon_id: 38410001, res: 'uilz_004', name: '一星龙玉' },
		38410002: { index: 2, dragon_id: 38410002, res: 'uilz_004a', name: '二星龙玉' },
		38410003: { index: 3, dragon_id: 38410003, res: 'uilz_004b', name: '三星龙玉' },
		38410004: { index: 4, dragon_id: 38410004, res: 'uilz_004c', name: '四星龙玉' },
		38410005: { index: 5, dragon_id: 38410005, res: 'uilz_004d', name: '五星龙玉' },
		38410006: { index: 6, dragon_id: 38410006, res: 'uilz_004e', name: '六星龙玉' },
		38410007: { index: 7, dragon_id: 38410007, res: 'uilz_005', name: '七星龙玉' }
	}

	static GoodType = 38
	static SubGoodType = 41
	static ReturnType = 1
	static ModuleId = 143

	static BaseModuleName = "星核"
	static CurModuleName = "龙玉"

	static RedFlag = {
		BallLevelUp: 0x001,//龙玉可激活或升级
		SuitLevelUp: 0x002,//套装可激活或升级
	}

	static Instance: DragonBallModel
	static DragonGiftIconType = 143

	public static GetInstance() {
		if (!DragonBallModel.Instance) {
			DragonBallModel.Instance = new DragonBallModel()
		}
		return DragonBallModel.Instance
	}

	public static GetBallInfo(dragon_id) {
		return DragonBallModel.BallInfoDic[dragon_id]
	}

	/**
	 * 龙珠数据
	 */
	ball_data_dic: { [dragon_id: number]: IDragonBallInfo } = {}
	/**
	 * 龙珠升级红点
	 */
	ball_level_up_red_dic = {}

	/**
	 * 龙珠总战斗力
	 */
	total_power

	/**
	 * 红点状态
	 */
	red_flag = 0
	/**
	 * 雕像激活状态
	 */
	statue_active_status = 0
	/**
	 * 预览战力
	 */
	pre_power
	/**
	 * 当前穿着的套装类型
	 */
	wear_type
	/**
	 * 套装数据
	 */
	suit_data_dic: { [type: number]: IDragonSuitInfo } = {}

	/**
	 * 套装升级红点
	 */
	suit_level_up_red_dic = {}

	/**
	 * 龙珠活动数据
	 */
	dragon_gift_data
	/**
	 * 
	 */
	first_show_red_dot = true
	/**
	 * 礼包最大开服天数
	 */
	gift_max_open_day
	erlang_parser: ErlangParser
	goods_model: GoodsModel
	skill_mgr: SkillManager

	public constructor() {
		super()

		if (DragonBallModel.Instance) {
			return
		}

		this.erlang_parser = ErlangParser.GetInstance()
		this.goods_model = GoodsModel.GetInstance()
		this.skill_mgr = SkillManager.GetInstance()
	}



	/**
	 * 龙珠系统的开启状态
	 * @returns 
	 */
	public GetOpenState() {
		return CommonManager.GetInstance().CheckFuncOpenState("DragonBallView", true) && !PlatformManager.GetInstance().is_alpha
	}

	/**
	 * 重置模块数据
	 */
	public ResetData() {
		this.red_flag = 0
		this.statue_active_status = 0
		this.total_power = 0
		this.pre_power = 0
		this.first_show_red_dot = true
		for (let i in this.ball_data_dic) {
			var v1 = this.ball_data_dic[i]
			v1.dragon_lv = 0
			v1.power = 0
			v1.next_power = 0
		}


		for (let i in this.suit_data_dic) {
			var v2 = this.suit_data_dic[i]
			v2.lv = 0
			v2.power = 0
			v2.next_power = 0
		}

		if (this.gift_max_open_day == null) {
			let max_open_day = 0
			let config_start_nuclear = Config.PRELOAD_SERVER_CONFIG.config_start_nuclear
			for (let key in config_start_nuclear) {
				var v = config_start_nuclear[key]
				if (!max_open_day || v.open_day > max_open_day) {
					max_open_day = v.open_day
				}
			}
			this.gift_max_open_day = max_open_day
		}

	}

	// 设置龙珠数据
	public SetBallData(scmd: ProtoRecvVObj<14300>) {
		for (let v of scmd.dragon_list) {
			if (this.ball_data_dic[v.dragon_id]) {
				this.ball_data_dic[v.dragon_id].dragon_id = v.dragon_id
				this.ball_data_dic[v.dragon_id].dragon_lv = v.dragon_lv
				this.ball_data_dic[v.dragon_id].power = v.power
				this.ball_data_dic[v.dragon_id].next_power = v.next_power
			} else {
				this.ball_data_dic[v.dragon_id] = v
			}
		}
	}

	public GetDrageonData(dragon_id) {
		return this.ball_data_dic && this.ball_data_dic[dragon_id]
	}

	/**
	 * 
	 * @returns 获取雕像激活状态
	 */
	public GetStatueActiveState() {
		return this.GetOpenState() && this.statue_active_status
		// return true
	}

	/**
	 * 刷新龙珠可激活/可升级红点
	 */
	public RefreshBallLevelUpRed() {
		let level_up_bool = false
		if (this.GetOpenState()) {
			let config_dragon_ball = Config.PRELOAD_SERVER_CONFIG.config_dragon_ball
			if (!config_dragon_ball) return
			for (let k in DragonBallModel.BallInfoDic) {
				var info = DragonBallModel.BallInfoDic[k]
				var data = this.GetDrageonData(info.dragon_id)
				var cfg
				if (!data || data.dragon_lv == 0) {
					cfg = config_dragon_ball[`${info.dragon_id}@1`]
				}
				else {
					cfg = config_dragon_ball[`${info.dragon_id}@${data.dragon_lv + 1}`]
				}

				let local_bool = false
				if (cfg) {
					var cost = ErlangParser.GetInstance().Parse(cfg.cost)[0]
					var my_count = this.goods_model.GetBagGoodsNum(cost[1])
					var need_count = cost[2]
					local_bool = my_count >= need_count
				}

				if (local_bool != this.ball_level_up_red_dic[info.dragon_id]) {
					this.ball_level_up_red_dic[info.dragon_id] = local_bool
					this.Fire(DragonBallModel.REFRESH_BALL_LEVEL_UP_RED, info.dragon_id)
				}
				if (local_bool) {
					level_up_bool = true
				}
			}
		}
		this.SetRedFlag(DragonBallModel.RedFlag.BallLevelUp, level_up_bool)
	}

	/**
	 * 刷新套装可激活/可升级红点
	 */
	public RefreshSuitLevelUpRed() {
		let suit_level_up_bool = false
		if (this.GetOpenState()) {
			let config_dragon_ball_figure = Config.PRELOAD_SERVER_CONFIG.config_dragon_ball_figure
			if (!config_dragon_ball_figure) return
			if (Util.IsTableEmpty(this.suit_data_dic)) return

			for (let k in this.suit_data_dic) {
				var data = this.suit_data_dic[k]
				var cfg
				if (!data || data.lv == 0) {
					cfg = config_dragon_ball_figure[`${data.type}@1`]
				}
				else {
					cfg = config_dragon_ball_figure[`${data.type}@${data.lv + 1}`]
				}

				let local_bool = false
				if (cfg) {
					var conditions = ErlangParser.GetInstance().Parse(cfg.conditions)
					for (let k in conditions) {
						var v = conditions[k]
						if (v[0] == "dragon_ball") {
							var need_count = Number(v[1])
							var my_count = this.GetDragonLvCount(v[2])
							local_bool = my_count >= need_count
							break
						}
					}
				}

				if (local_bool != this.suit_level_up_red_dic[data.type]) {
					this.suit_level_up_red_dic[data.type] = local_bool
					this.Fire(DragonBallModel.REFRESH_SUIT_LEVEL_UP_RED, data.type)
				}
				if (local_bool) {
					suit_level_up_bool = true
				}
			}
		}
		this.SetRedFlag(DragonBallModel.RedFlag.SuitLevelUp, suit_level_up_bool)
	}

	SetRedFlag(flag?, state?) {
		if (!flag) {
			return
		}
		let now_flag = 0
		if (state) {
			now_flag = this.red_flag | flag
		} else {
			now_flag = this.red_flag & ~flag
		}
		if (now_flag == this.red_flag) {
			return
		}
		this.red_flag = now_flag
		this.Fire(DragonBallModel.REFRESH_RED_FLAG, flag)
		RedDotController.ins.up(RedKey.DRAGON_BALL, this.GetRedState());
		// RedDotController.ins.up(RedKey.BRIGHT_SEA, this.red_flag ? 1 : 0)
		// GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE,"BagView", BagModel.Index.HolySeal, this.GetRedState())
		GlobalEventSystem.Fire(EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Bag)
	}

	HasRedFlag(flag?) {

		if (!flag) {
			return false
		}
		return ((this.red_flag & flag) != 0)
	}

	// 红点查询函数
	public GetRedState() {
		return this.red_flag > 0
	}

	GetActiveCount() {
		let count = 0
		for (let key in DragonBallModel.BallInfoDic) {
			var info = DragonBallModel.BallInfoDic[key]
			var data = this.GetDrageonData(info.dragon_id)
			if (data && data.dragon_lv > 0) {
				count++
			}
		}
		return count
	}

	GetTotalCount() {
		return Util.TableSize(DragonBallModel.BallInfoDic)
	}


	GetSuitTotalPower() {
		let total_power = 0
		for (let k in this.suit_data_dic) {
			total_power += this.suit_data_dic[k].power
		}
		return total_power
	}


	// 设置套装数据
	public SetSuitData(scmd: ProtoRecvVObj<14303>) {
		for (let v of scmd.figure_list) {
			if (this.suit_data_dic[v.type]) {
				this.suit_data_dic[v.type].type = v.type
				this.suit_data_dic[v.type].lv = v.lv
				this.suit_data_dic[v.type].power = v.power
				this.suit_data_dic[v.type].next_power = v.next_power
			} else {
				this.suit_data_dic[v.type] = v
			}
		}
	}

	public GetSuitData(dragon_id) {
		return this.suit_data_dic && this.suit_data_dic[dragon_id]
	}

	public GetDragonLvCount(lv) {
		if (lv == null) return 0
		lv = Number(lv)
		let count = 0
		for (let key in DragonBallModel.BallInfoDic) {
			var info = DragonBallModel.BallInfoDic[key]
			var data = this.GetDrageonData(info.dragon_id)
			if (data && data.dragon_lv >= lv) {
				count++
			}
		}
		return count
	}

	public SetDragonBallGiftData(scmd) {
		this.dragon_gift_data = scmd
		this.Fire(DragonBallModel.UPDATE_GIFT_VIEW, scmd)
		GlobalEventSystem.Fire(EventName.REFRESH_ACTIVITY_ICON_RED_DOT, DragonBallModel.DragonGiftIconType, this.first_show_red_dot)
	}

	public RefreshGiftIcon() {
		if(!this.GetOpenState()){
			ActivityIconManager.GetInstance().deleteIcon(DragonBallModel.DragonGiftIconType)
			return 
		}
		let data = this.dragon_gift_data
		if(!data || data.id == 0){
			ActivityIconManager.GetInstance().deleteIcon(DragonBallModel.DragonGiftIconType)
			return 
		}
		let config = Config.PRELOAD_SERVER_CONFIG.config_start_nuclear
		if(!config || !config[data.id]) {
			ActivityIconManager.GetInstance().deleteIcon(DragonBallModel.DragonGiftIconType)
			return
		}
		let max_buy_time = config[data.id].times_limit
		let open_day = config[data.id].open_day
		let lv = config[data.id].open_lv
		let role_lv = RoleManager.GetInstance().GetMainRoleLevel()
		let server_openDay = ServerTimeModel.GetInstance().GetOpenServerDay()
		let is_frist = FirstRechargeModel.GetInstance().IsDoneFirstRecharge()
		if (role_lv >= lv && server_openDay >= open_day && (max_buy_time - data.buy_times > 0) && is_frist? true : false ) {
			ActivityIconManager.GetInstance().addIcon(DragonBallModel.DragonGiftIconType)
		} else {
			ActivityIconManager.GetInstance().deleteIcon(DragonBallModel.DragonGiftIconType)
		}
	}

}
window["DragonBallModel"] = DragonBallModel
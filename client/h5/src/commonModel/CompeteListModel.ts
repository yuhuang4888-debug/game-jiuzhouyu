import { CommonManager } from "../common/CommonManager"
import { CongratulationObtainView } from "../common/CongratulationObtainView"
import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { EventDispatcher } from "../util/EventDispatcher"
import { Mathf } from "../util/Mathf"
import { TimeUtil } from "../util/TimeUtil"
import { Trim, Util } from "../util/Util"
import { ActivityIconManager } from "./ActivityIconManager"
import { RoleManager } from "./RoleManager"
import "../competelist/CompetelistView"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { GoodsModel } from "./GoodsModel"



export let CompeteListEvent = {
	REQUEST_PROTO: "REQUEST_PROTO",
	UPDATE_VIEW_DATA: "UPDATE_VIEW_DATA",
	UPDATE_RANK_DATA: "UPDATE_RANK_DATA",
	UPDATE_LOTTERY_DATA: "UPDATE_LOTTERY_DATA",
	UPDATE_KEY_DATA: "UPDATE_LOTTERY_DATA",
	UPDATE_ACT_INFO: "UPDATE_ACT_INFO",
	OPEN_VIEW: "OPEN_VIEW",
	INTEGRAL_UPDATE: "INTEGRAL_UPDATE",
	UPDATE_ENTER_VIEW_RED: "UPDATE_ENTER_VIEW_RED"
}
window["CompeteListEvent"] = CompeteListEvent

export class CompeteListModel extends EventDispatcher {
	private static _instance: CompeteListModel;

	CompeteKeyData
	CompeteListOpenDic
	CompeteOpenActive
	CompeteRankData
	CompeteViewData
	GetActInfo
	GetActiveState
	GetIntegralStage
	IntegralIndex
	RefreshIconRedDot
	SetActList
	SetOpenActive
	ShowAlertList
	checkIntegralCanget
	competeListOpen
	convertTime
	cost_alert
	getIntegralConf
	getIntegralList
	getRankConfList
	getRankList
	getRewardList
	getStageReward
	initIntegral
	initRank
	initReward
	showRedDot
	timeFormat

	private act_list_ = []			//所有活动信息

	// 配置
	private _confRaceActInfo: any;
	private _confRaceActRankReward: any;
	private _confRaceActStageReward: any;
	private _confRaceActReward: any;

	public get actList() {
		return this.act_list_;
	}

	public set actList(value: any) {
		this.act_list_ = value;
	}

	public constructor() {
		super()

		this.CompeteOpenActive = {}
		this._confRaceActInfo = null
		//以下三个列表用   type@subtype 作为键值
		this.ShowAlertList = []
		this.CompeteViewData = {}	//活动界面信息
		this.CompeteRankData = {}	//排行数据
		this.CompeteKeyData = {}	//键值
		this.cost_alert = false

		let activity_icon_mgr = ActivityIconManager.GetInstance()
		let role_mgr = RoleManager.GetInstance()
		let local_CompeteListEvent = CompeteListEvent
		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName
		let integral_Conf_dic_ = []	//积分阶段奖励
		let rank_Conf_dic_ = []		//排行榜奖励信息
		let reward_Conf_dic_ = []		//活动奖励信息


		this.SetOpenActive = (data?) => {
			for (let _tmpi in data) {
				var vo = data[_tmpi]
				this.CompeteOpenActive[vo.type + "@" + vo.subtype] = vo
			}
		}

		this.GetActiveState = (type?, sub_type?) => {
			if (this.CompeteOpenActive[type + "@" + sub_type] && this.CompeteOpenActive[type + "@" + sub_type].end_time != 0) {
				return true
			}
			return false
		}

		this.CompeteListOpenDic = () => {
			return this.CompeteOpenActive
		}

		this.SetActList = (list?) => {
			if (!this._confRaceActInfo) {
				return
			}
			for (let _tmpi in list) {
				let vo = list[_tmpi]
				//let icon_type = "338@" + vo.type + "@" + vo.subtype + "@" + vo.show_id
				let config = this._confRaceActInfo[vo.type + "@" + vo.subtype]
				if (config) {
					let icon_type = Trim(config.icon);
					this.act_list_[icon_type] = vo;
					if (config && config.act_type != 0) {	//0：无单独图标+周末活动内 1：单独图标 2：单独图标 + 周末活动内
						//显示图标
						let icon_info = activity_icon_mgr.getIconInfo(icon_type);
						if (icon_info) {
							if (icon_info.time != vo.end_time) {
								activity_icon_mgr.addIcon(icon_type, vo.buy_end_time, icon_info.data);
							}
						} else {
							let icon_cfg = CommonManager.GetInstance().GetFunctionIconCfg(icon_type);
							if (icon_cfg) {
								let day: number = ServerTimeModel.GetInstance().GetOpenServerDay();
								if (role_mgr.GetMainRoleVo().level >= icon_cfg.open_lv && day >= icon_cfg.open_day) {
									activity_icon_mgr.addIcon(icon_type, vo.buy_end_time);
									this.Fire(local_CompeteListEvent.UPDATE_ACT_INFO, vo.type_id, vo.subtype);
								}
							}
						}
					}
					this.Fire(local_CompeteListEvent.REQUEST_PROTO, 33801, "hh", vo.type, vo.subtype)
				}
			}


			if (list?.length <= 0) {
				for (let key in this.act_list_) {
					let icon_info = this.act_list_[key];
					let config = this._confRaceActInfo[icon_info.type + "@" + icon_info.subtype];
					let icon_type = Trim(config.icon);
					let icon_cfg = CommonManager.GetInstance().GetFunctionIconCfg(icon_type);
					let day: number = ServerTimeModel.GetInstance().GetOpenServerDay();
					if (role_mgr.GetMainRoleVo().level >= icon_cfg.open_lv && day >= icon_cfg.open_day) {
						if (!icon_info || TimeUtil.getServerTime() > icon_info.end_time) {
							activity_icon_mgr.deleteIcon(key)
						}
					} else {
						activity_icon_mgr.deleteIcon(icon_type);
					}
				}

			}

		}

		this.GetActInfo = (icontype?) => {
			return this.act_list_[icontype]
		}

		this.initIntegral = () => {
			if (!Util.IsTableEmpty(integral_Conf_dic_)) {
				return
			}
			let config = this._confRaceActStageReward;
			for (let key in config) {
				let conf = config[key]
				let list = []
				let act_key = conf.type + "@" + conf.sub_type
				list = integral_Conf_dic_[act_key]
				if (!list) {
					list = [conf]
				} else {
					table.insert(list, conf)
				}
				integral_Conf_dic_[act_key] = list
			}
		}

		this.getIntegralList = (type?, sub_type?) => {
			return integral_Conf_dic_[type + "@" + sub_type];
		}

		this.getIntegralConf = (type?, sub_type?, reward_id?) => {
			let list = this.getIntegralList(type, sub_type);
			for (let key in list) {
				let info = list[key];
				if (info.reward_id == reward_id) {
					return info;
				}
			}
		}

		this.getStageReward = (data?) => {
			let goods_list = []
			let conf = this.getIntegralConf(data.type, data.subtype, data.reward_id)
			if (conf) {
				let list = JSON.parse(conf.reward);
				for (let key in list) {
					let info = list[key];
					table.insert(goods_list, info);
				}
			}
			let view = new CongratulationObtainView(goods_list, 10);
			view.Open();
			//CustomActivityModel:GetInstance():RefreshIconRed(data.type, data.subtype, 338)
			this.Fire(local_CompeteListEvent.REQUEST_PROTO, 33801, "hh", data.type, data.subtype)
			let cfg = this._confRaceActInfo[data.type + "@" + data.subtype]
			this.RefreshIconRedDot(data.type, data.subtype, cfg.show_id)
		}

		this.initRank = () => {
			if (!Util.IsTableEmpty(rank_Conf_dic_)) {
				return
			}
			let config = this._confRaceActRankReward;
			for (let key in config) {

				let conf = config[key]
				let list = []
				let act_key = conf.type + "@" + conf.sub_type
				list = rank_Conf_dic_[act_key]
				if (!list) {
					list = [conf]
				} else {
					table.insert(list, conf)
				}
				rank_Conf_dic_[act_key] = list
			}
		}

		this.getRankConfList = (type?, sub_type?) => {
			return rank_Conf_dic_[type + "@" + sub_type]
		}

		this.getRankList = (type?, sub_type?) => {
			let list = [];
			let rankdata = this.CompeteRankData[type + "@" + sub_type];
			let viewdata = this.CompeteViewData[type + "@" + sub_type];
			if (!rankdata || !viewdata) {
				return;
			}
			let dataList = rankdata && rankdata.rank_list;
			let confList = this.getRankConfList(type, sub_type);
			let rankConfDic = [];
			for (let key in confList) {
				let conf = confList[key];
				for (let i = conf.rank_min; i <= conf.rank_max; i++) {
					let world_lv = viewdata.world_lv;
					let rewardList = JSON.parse(conf.reward);
					if (conf.format == 1) {
						let cfg_list = JSON.parse(conf.reward);
						for (let index in cfg_list) {
							let reward_cfg = cfg_list[index]
							if (world_lv < Number(reward_cfg[0])) {
								break;
							}
							rewardList = reward_cfg[1];
						}
					}
					let obj = {};
					obj["rank"] = i;
					obj["conf"] = conf;
					obj["rewardList"] = rewardList;
					rankConfDic[i] = obj;
				}
			}
			if (!dataList) {
				return list
			}
			for (let _tmpi in dataList) {
				var info = dataList[_tmpi];
				let obj = rankConfDic[info.rank];
				if (obj) {
					obj["data"] = info;
				}
			}

			rankConfDic.shift(); // 因为第一个是空白所以要删除
			return rankConfDic;
		}

		this.initReward = () => {
			if (!Util.IsTableEmpty(reward_Conf_dic_)) {
				return
			}

			let config = this._confRaceActReward;

			for (let key in config) {

				let conf = config[key];
				let list = [];
				let act_key = conf.type + "@" + conf.sub_type;
				list = reward_Conf_dic_[act_key];
				if (!list) {
					list = [conf];
				} else {
					table.insert(list, conf);
				}
				reward_Conf_dic_[act_key] = list;
			}
		}

		this.getRewardList = (type?, sub_type?) => {
			return reward_Conf_dic_[type + "@" + sub_type]
		}

		this.RefreshIconRedDot = (type?, subtype?, show_id?) => {
			if (!this._confRaceActInfo) {
				return
			}
			//let icon_type = "338@" + type + "@" + subtype + "@" + show_id
			let config = this._confRaceActInfo[type + "@" + subtype]
			let icon_type = Trim(config.icon)
			let icon = activity_icon_mgr.getIconInfo(icon_type)
			if (icon) {
				let config = this._confRaceActInfo[type + "@" + subtype]
				if (config.act_type != 0) {
					local_GlobalEventSystem.Fire(local_EventName.REFRESH_ACTIVITY_ICON_RED_DOT, icon_type, this.showRedDot(type, subtype))
				} else {
					//local_GlobalEventSystem:Fire(local_EventName.REFRESH_ACTIVITY_ICON_RED_DOT, "???", this.showRedDot(type, subtype))
				}
			}
		}

		this.showRedDot = (type?, subtype?) => {
			let flag = false
			let viewData = this.CompeteViewData[type + "@" + subtype]
			if (viewData) {
				for (let key in viewData.stage_list) {
					let data = viewData.stage_list[key]
					if (data.got_type == 1) {
						return true
					}

					let cost = viewData.cost[0];
					let num: number = GoodsModel.GetInstance().GetTypeGoodsNum(cost.typeId);
					if (num >= cost.count) {
						return true;
					}

				}
			}
			return flag
		}

		this.checkIntegralCanget = (type?, subtype?, reward_id?, needIntegral?) => {
			let flag = false
			let viewData = this.CompeteViewData[type + "@" + subtype]
			if (viewData) {
				let hasGet = false
				for (let _tmpi in viewData.stage_list) {
					var info = viewData.stage_list[_tmpi]
					if (info.id == reward_id) {
						hasGet = info.got_type == 2
						break
					}
				}
				flag = !hasGet && viewData.today_score >= needIntegral
			}
			return flag
		}

		this.convertTime = (times?) => {
			let D = Mathf.Floor(times / 60 / 60 / 24)
			let h = Mathf.Floor(times / 60 / 60) % 24
			let m = Mathf.Floor(times / 60) % 60
			let s = times % 60
			// if (D > 0 ) {
			// 	return D + "天" + h .. "小时" + m .. "分"
			// }else{
			// 	return h + "小时" + m .. "分" + s .. "秒"
			// }
		}

		this.IntegralIndex = (type?, sub_type?) => {
			let index = 0
			let viewData = this.CompeteViewData[type + "@" + sub_type]
			let count = 0
			let notGetIndex = null
			let lastHasGet = true
			if (viewData) {
				let list = []

				for (let i = Util.TableSize(viewData.stage_list); i >= 1; i -= 1) {
					table.insert(list, viewData.stage_list[i])
				}
				for (let _tmpi in list) {
					var info = list[_tmpi]
					if (info.got_type == 1 && notGetIndex == null) {
						notGetIndex = count
					}
					if (info.got_type == 3) {
						break
					}
					count = count + 1
				}

				if (notGetIndex != null) {
					index = notGetIndex
				} else {
					index = count
				}
				return index
			}
		}

		//获取当前积分到达哪个阶段
		this.GetIntegralStage = (type?, sub_type?) => {
			let viewData = this.CompeteViewData[type + "@" + sub_type]
			let list = []

			for (let i = Util.TableSize(viewData.stage_list); i >= 1; i -= 1) {
				table.insert(list, viewData.stage_list[i])
			}

			let count = 0
			for (let _tmpi in list) {
				var info = list[_tmpi]
				if (info.got_type == 3) {
					break
				}
				count = count + 1
			}

			return count
		}

		this.competeListOpen = (show?) => {
			if (show == null) {
				show = false
			}
			let flag = true
			let needLv = 150
			let level = role_mgr.GetMainRoleVo().level
			flag = level >= needLv
			if (!flag && show) {
				Message.show("需要" + needLv + "级开启")
			}
			return flag
		}

		this.timeFormat = (second?) => {
			let date = new Date(second * 1000)	//时间戳为10位需*1000，时间戳为13位的话不需乘1000
			let h = (date.getHours() < 10 && ('0' + date.getHours()) || (date.getHours())) + ':'
			let m = (date.getMinutes() < 10 && ('0' + date.getMinutes()) || (date.getMinutes()))
			return h + m
		}
	}

	public get confRaceActInfo() {
		return this._confRaceActInfo;
	}


	/**
	 * 初始化配置
	 */
	public async InitConfig() {
		await ResManager.GetInstance().LoadGameConfig(
			this,
			'config_race_act_info',
			false,
			undefined,
			(obj) => {
				this._confRaceActInfo = obj;
				ResManager.GetInstance().DestoryGameConfig(this, 'config_race_act_info', false);
			});
		await ResManager.GetInstance().LoadGameConfig(
			this,
			'config_race_act_rank_reward',
			false,
			undefined,
			(obj) => {
				this._confRaceActRankReward = obj;
				ResManager.GetInstance().DestoryGameConfig(this, 'config_race_act_rank_reward', false);
			});
		await ResManager.GetInstance().LoadGameConfig(
			this,
			'config_race_act_stage_reward',
			false,
			undefined,
			(obj) => {
				this._confRaceActStageReward = obj;
				ResManager.GetInstance().DestoryGameConfig(this, 'config_race_act_stage_reward', false);
			});
		await ResManager.GetInstance().LoadGameConfig(
			this,
			'config_race_act_reward',
			false,
			undefined,
			(obj) => {
				this._confRaceActReward = obj;
				ResManager.GetInstance().DestoryGameConfig(this, 'config_race_act_reward', false);
			});
	}




	public static GetInstance() {

		if (!CompeteListModel._instance) {
			CompeteListModel._instance = new CompeteListModel();
		}
		return CompeteListModel._instance
	}

	public static IsBillboardAct(icontype) {
		let x = null
		if (typeof (icontype) == "string" && icontype.length > 3) {
			x = icontype.substring(1, 3)
		}
		return x == "338"
	}
}
window['CompeteListModel'] = CompeteListModel;

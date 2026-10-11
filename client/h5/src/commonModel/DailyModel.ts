import { CongratulationObtainView } from "../common/CongratulationObtainView"
import { EventName } from "../common/EventName"
import { table } from "../common/table"
import { ActivityIconManager } from "../commonModel/ActivityIconManager"
import { RoleManager } from "./RoleManager"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventDispatcher } from "../util/EventDispatcher"
import { TimeUtil } from "../util/TimeUtil"
import { Util } from "../util/Util"
import { BrightSeaModel } from "./BrightSeaModel"
import { GoodsModel } from "./GoodsModel"
import { VipModel } from "./VipModel"
import { Config } from "../common/Config"
import { ResManager } from "../common/ResManager"
import { DailyEvent } from "../daily/DailyEvent"
import { OnHookModel } from "./OnHookModel"
import { ViewPopLevelModel } from "./ViewPopLevelModel"
import { TaskModel } from "./TaskModel"

export let ActivityState = {
	Opening: 1,
	Today: 2,
	Unopened: 3,
	TimeOver: 4,
	LvLimit: 5,
	Closed: 6
}
window["ActivityState"] = ActivityState
export let ActivityType = {
	UnLimit: 1,
	Limit: 2
}
window["ActivityType"] = ActivityType
export let ServerTimeType = {
	MergeDay: 1,
	OpenDay: 2,
	Normal: 3
}
window["ServerTimeType"] = ServerTimeType
export let ActiveTimeType = {
	StartTime: 0,
	EndTime: 1
}
window["ActiveTimeType"] = ActiveTimeType
export let TodayType = {
	Yes: 1,
	No: 2
}
window["TodayType"] = TodayType
export let TimeType = {
	None: 0,
	Week: 1,
	Month: 2,
	Date: 3
}
window["TimeType"] = TimeType

export class DailyModel extends EventDispatcher {
	AutoUseOutLineTimeCard
	EstimateActivityIsToday
	GetAcCfg
	GetAcCfgByTypeStr
	GetActivityRewardList
	GetActivityStartSecAndStartLv
	GetActivityTimeType
	GetAcyivityRealState
	GetBoxRewardListById
	GetDailyTaskVo
	GetDataFromConfig
	GetLimitActivityMaxTimes
	GetLivenessDataByIndex
	GetLivessnessCfgByFigureId
	GetOffLineRed
	GetOpenOrMergeDayByCfg
	GetPersonalBossTimesAndLiveness
	GetRecommendUseNum
	GetResStatus
	GetResStatusRed
	GetTimeStr
	GetToadyActivityList
	GetUnLimitActOpenState
	GetXianShiActivityCfg
	ResetData
	LimitActivityIsOpen
	LivenessCanFind
	LivenessCanGet
	LivenessCanUpgrade
	LivenessRewardCanGet
	MergeGoods
	ResCanFind
	ResNormalCanFind
	SetAllResFindData
	SetDailyData
	SetHuoYueDuData
	SetLivenessImageData
	SetLivenessReward
	SetResData
	SetResFindData
	ShowAllReward
	ShowRedDot
	ShowReward
	SortLimitActivityList
	SortUnLimitActivity
	UpdateDailyData
	UpdateFindData
	UseNewImage
	_strongerData
	_strongerRedDot
	cost_goods_type
	dailyResRed
	daily_data
	getItemConfig
	getStrongerDataByid
	huoyuedu_data
	liveness_dot_not_show
	liveness_find_not_alert
	liveness_image_data
	liveness_reward
	need_tuo_guan_guide
	outline_red
	res_find_data
	res_find_dot_not_show
	setStrongerData
	strongerStar
	strongerTabName
	xianshiActivityList
	CheckDailyTaskRed

	strongerRedDot
	config_ac
	outline_info

	CheckIsJoin //检查是否加入了活动
	SetReservationState


	//首次登陆有日常任务显示红点
	daily_task_first_red = false
	daily_task_first_check = true

	public static LivenessFindOpenLevel = 50
	public static HuoYueDuTypeId = 1032
	public static TuoGuanGuideLevel = 100		//托管引导的出现等级
	public static DailyIconType = 157			//日常图标类型
	strong_tab = 1
	daily_act_open = true
	private daily_act_data

	//上线检测一次挂机卡  需要验证两个步骤 当前挂机时间&&挂机卡数量
	out_line_card_check_1=false
	out_line_card_check_2=false
	public constructor() {
		super()

		if (DailyModel.Instance) {
			return
		}
		DailyModel.Instance = this
		this.liveness_dot_not_show = false;
		this.res_find_dot_not_show = false;
		this.outline_red = true;
		this.strongerTabName = ["我要经验", "我要绑玉", "我要装备"];
		this.xianshiActivityList = [];
		this._strongerRedDot = true;
		this.daily_data = []
		this.liveness_find_not_alert = false
		this.dailyResRed = 0			//日常活动预约红点
		this.cost_goods_type = 38070001   //离线挂机道具
		this.need_tuo_guan_guide = false  //是否需要显示托管引导
		let local_DailyEvent = DailyEvent
		let local_Config = Config
		let role_mgr = RoleManager.GetInstance()
		let local_ActivityState = ActivityState
		let local_TimeUtil = TimeUtil
		let local_Util = Util
		let local_Date = Date
		let local_ActiveTimeType = ActiveTimeType
		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName
		let local_TodayType = TodayType
		let local_Math = Math
		let outline_model = OnHookModel.GetInstance()
		let goods_model = GoodsModel.GetInstance()
		let brightSea_model = BrightSeaModel.GetInstance()
		// let config_res_act_ = null
		// let config_ac_kv_ = null
		let config_liveness_lv_ = null
		// let config_activity_reward_ = null
		let merge_find_list_ = null
		let ItemConfigDic_ = null
		let local_reservation = null
		let local_join = {}

		let config_activity_liveness
		let config_res_act
		let config_liveness_active
		let res_mgr = ResManager.GetInstance()


		this.ResetData = () => {
			this.out_line_card_check_1 = false
			this.out_line_card_check_2 = false
			this.daily_task_first_red = false
			this.daily_task_first_check = true
			this.config_ac = Config.PRELOAD_SERVER_CONFIG.config_ac
			this.Fire(DailyEvent.CONFIG_IS_LOAD)
			config_liveness_lv_ = Config.PRELOAD_SERVER_CONFIG.config_liveness_lv
			config_activity_liveness = Config.PRELOAD_SERVER_CONFIG.config_activity_liveness
		}
		this.SetDailyData = (data?) => {
			if (data) {
				this.daily_data[data.act_type] = data
				let cfg = null
				let vo = null
				let delete_index = null
				let del_num = null
				let index = null
				let fit_level = null
				let lv = role_mgr.mainRoleInfo.level
				for (let obj in this.daily_data) {

					delete_index = []
					if (this.daily_data[obj]) {
						let i = 0
						do {
							fit_level = true
							vo = this.daily_data[obj].ac_list[i]
							if (vo) {
								vo.liveness_cfg = config_activity_liveness[vo.module + "@" + vo.module_sub]
								vo.ac_cfg = this.GetAcCfg(vo.module, vo.module_sub, vo.ac_sub)
								vo.reward_list = this.GetActivityRewardList(vo.ac_cfg)
								if ((vo.liveness_cfg && lv > vo.liveness_cfg.end_lv) || (vo.ac_cfg && lv > vo.ac_cfg.end_lv)) {
									fit_level = false
								}
								if (!vo.ac_cfg || !fit_level) {
									table.insert(delete_index, i + 1)
								}
							}
							i = i + 1
						} while ((i < this.daily_data[obj].ac_list.length))
						del_num = 0
						index = 1
						for (let _tmpi in delete_index) {
							var value = delete_index[Number(_tmpi) - 1]
							index = value - del_num
							table.remove(this.daily_data[obj].ac_list, index)
							del_num = del_num + 1
						}
					}
				}
				this.Fire(local_DailyEvent.UPDATE_DAILY_DATA)
				TaskModel.GetInstance().Fire(TaskModel.UPDATE_TASK_ALERT_VIEW)
			}
		}

		this.UpdateDailyData = (data?) => {
			if ((this.daily_data && data) && this.daily_data[data.act_type]) {
				for (let _tmpi in this.daily_data[data.act_type].ac_list) {
					var vo = this.daily_data[data.act_type].ac_list[_tmpi]
					if (vo.module == data.module && vo.module_sub == data.module_sub) {
						vo.state = data.status
					}
				}
				this.Fire(local_DailyEvent.UPDATE_DAILY_DATA)
				TaskModel.GetInstance().Fire(TaskModel.UPDATE_TASK_ALERT_VIEW)

			}
			if (data.module == 650 && data.module_sub == 1) {
				//@@@
				//CSPVPModel.GetInstance().Fire(CSPVPEvent.REQUEST_PROTO, 65000)
			}
		}

		this.GetAcCfg = (_module?, module_sub?, ac_sub?) => {
			return this.config_ac && this.config_ac[_module + "@" + module_sub + "@" + ac_sub]
		}

		this.GetAcCfgByTypeStr = (type_str?) => {
			return this.config_ac && this.config_ac[type_str]
		}
		this.SetLivenessReward = (data?) => {
			this.liveness_reward = data
			let sort_fun = (a?, b?) => {
				return a.id < b.id
			}

			if (this.liveness_reward && this.liveness_reward.reward_list) {
				table.sort(this.liveness_reward.reward_list, sort_fun)
			}
			this.Fire(local_DailyEvent.UPDATE_LIVENESS_REWARD)
		}

		this.GetLivenessDataByIndex = (index?) => {
			let vo = null
			let reward = (this.liveness_reward && (this.liveness_reward.reward_list[index - 1]) || (null))
			if (reward) {
				vo = []
				vo[0] = reward.id
				vo[1] = reward.state
			}
			return vo
		}

		this.SetResFindData = (data?) => {
			// if (!config_res_act) {
			// 	return
			// }
			this.res_find_data = data

			let call_fun = () => {
				if (this.res_find_data) {
					for (let _tmpi in this.res_find_data) {
						var obj = this.res_find_data[_tmpi]
						obj.config_res_act = config_res_act[obj.act_id + "@" + obj.act_sub + "@" + obj.reward_lv]
					}
				}
				this.Fire(local_DailyEvent.UPDATE_RES_FIND_DATA)
			}
			if (config_res_act) {
				call_fun()
			} else {
				config_res_act = Config.PRELOAD_SERVER_CONFIG.config_res_act
				call_fun()
			}
		}

		this.SetAllResFindData = (data?) => {
			// if (!config_res_act) {
			// 	return
			// }
			merge_find_list_ = data
			let call_fun = () => {
				if (merge_find_list_) {
					for (let _tmpi in merge_find_list_) {
						var obj = merge_find_list_[_tmpi]
						obj.config_res_act = config_res_act[obj.act_id + "@" + obj.act_sub + "@" + obj.reward_lv]
					}
				}
			}
			if (config_res_act) {
				call_fun()
			} else {
				config_res_act = Config.PRELOAD_SERVER_CONFIG.config_res_act
				call_fun()
			}
		}

		this.UpdateFindData = (data?) => {
			if (this.res_find_data) {
				for (let _tmpi in this.res_find_data) {
					var vo = this.res_find_data[_tmpi]
					if ((vo.act_id == data.act_id && vo.act_sub == data.act_sub) && vo.reward_lv == data.reward_lv) {
						vo.lefttimes = data.lefttimes
						vo.lefttimes_vip = data.lefttimes_vip
						break
					}
				}
				this.Fire(local_DailyEvent.UPDATE_RES_FIND_DATA)
			}
		}

		this.SortUnLimitActivity = (ac_list?, config_num_by_vip?, config_ac_kv?) => {
			ac_list = this.GetDataFromConfig(ac_list, config_num_by_vip, config_ac_kv)
			if (ac_list) {
				let sortFunc = (a?, b?) => {
					// ac_cfg: { module: 610, module_sub: 20, ac_sub: 0, ac_name: '恶灵退治', ac_icon: 61020, … }
					// ac_sub: 0
					// can_get_live: 0
					// leftNum: 0
					// live: 20
					// liveness_cfg: { module: 610, module_sub: 20, act_type: 1, name: '挑战2次恶灵退治', start_lv: 70, … }
					// max_live: 50
					// max_num: 5
					// module: 610
					// module_sub: 20
					// num: 2
					// rank: 4
					// reward_list: (2)[{… }, {… }]
					// start_lv: 70
					// state: 1
					//奖励领取状态
					let a_value = 0
					let b_value = 0
					if (a.can_get_live) a_value += 10000
					if (b.can_get_live) b_value += 10000

					//开启状态
						let a_state = this.GetUnLimitActOpenState(a, config_activity_liveness)
						let b_state = this.GetUnLimitActOpenState(b, config_activity_liveness)
					let func_sub = (state, vo) => {
						let va = 0
						if (state != local_ActivityState.Closed) {
							if (state == local_ActivityState.Opening) {
								//主线挂机和限时活动特殊处理
								let is_special = false
								if ((vo.module == 132 && vo.module_sub == 0)
									|| (vo.module == 157 && vo.module_sub == 0)) {
									is_special = true
								}
								//专属大妖特殊处理
								if (is_special) {
									va += 100 * local_ActivityState.LvLimit - 50
								} else {
									if (vo.num >= vo.max_num) {
										va += 100 * local_ActivityState.Closed
									} else {
										va += 100 * state
									}
								}
							} else {
								va += 100 * state
							}
						} else {
							//已经完成了默认次数的任务，但是vip有增加挑战次数
							if (vo.num >= vo.max_num) {
								va += 100 * local_ActivityState.Closed
							} else {
								va += 100 * local_ActivityState.Unopened - 50
							}
						}
						return va
					}
					a_value += func_sub(a_state, a)
					b_value += func_sub(b_state, b)
					if (b_value == a_value) {
							if (a_state == local_ActivityState.LvLimit) {
								return a.start_lv < b.start_lv
							} else {
								return a.rank < b.rank
							}
						} else {
						return a_value < b_value
						}

				}

				table.sort(ac_list, sortFunc)
			}
			return ac_list
		}

		this.GetUnLimitActOpenState = (vo?, activity_liveness_cfg?) => {
			let state = local_ActivityState.Unopened
			let cfg = activity_liveness_cfg[vo.module + "@" + vo.module_sub]
			let max = (cfg && (Number(cfg.max)) || (0))
			if (vo.state && vo.state == 3) {
				state = local_ActivityState.LvLimit
			} else if (vo.state == 2) {
				state = local_ActivityState.TimeOver
			} else if (cfg && max == 0) {
				state = local_ActivityState.Opening
			} else if (vo.leftNum != null && vo.leftNum > 0) {
				state = local_ActivityState.Opening
			} else if (vo.leftNum != null && vo.leftNum <= 0) {
				state = local_ActivityState.Closed
			}
			return state
		}

		this.GetDataFromConfig = (liveness_list?, config_num_by_vip?, config_ac_kv?) => {
			let cfg_ac = null
			let cfg_liv = null
			if (liveness_list) {
				for (let _tmpi in liveness_list) {
					var obj = liveness_list[_tmpi]
					cfg_ac = this.config_ac[obj.module + "@" + obj.module_sub + "@" + obj.ac_sub]
					obj.rank = 0
					obj.start_lv = 0
					if (cfg_ac) {
						obj.rank = Number(cfg_ac.rank)
						obj.start_lv = Number(cfg_ac.start_lv)
					}
					obj.leftNum = 0
					cfg_liv = config_activity_liveness[obj.module + "@" + obj.module_sub]
					if (cfg_liv) {
						obj.leftNum = Number(cfg_liv.max) - obj.num
						if (obj.module == 610 && obj.module_sub == 10) {
							let [max_time, max_liveness] = this.GetPersonalBossTimesAndLiveness(cfg_liv.live, config_ac_kv, config_num_by_vip)
							obj.leftNum += max_time
						}
					}
				}
			}
			return liveness_list
		}

		this.SortLimitActivityList = (ac_list?, config_num_by_vip?, config_ac_kv?) => {
			ac_list = this.GetDataFromConfig(ac_list, config_num_by_vip, config_ac_kv)
			let time = local_TimeUtil.GetZoneTime()
			let sortFunc = (a, b) => {
				let result = 1
				let [a_statr_time, a_start_lv, a_state, a_e_s, a_n_s, a_today] = this.GetActivityStartSecAndStartLv(a, time)
				let [b_statr_time, b_start_lv, b_state, b_e_s, b_n_s, b_today] = this.GetActivityStartSecAndStartLv(b, time)
				//a_state = this.GetAcyivityRealState(a, a_state)
				//b_state = this.GetAcyivityRealState(b, b_state)
				//let a_today = this.EstimateActivityIsToday(a, time)
				//let b_today = this.EstimateActivityIsToday(b, time)
				let a_time_type = this.GetActivityTimeType(a)
				let b_time_type = this.GetActivityTimeType(b)
				a.a_state = a_state
				b.a_state = b_state

				if (a_state != b_state) {
					return a_state < b_state
				} else {
					if (a_state == local_ActivityState.LvLimit && b_state == local_ActivityState.LvLimit) {
						return a_start_lv < b_start_lv
					} else {
						if (a_today != b_today) {
							return a_today < b_today
						} else {
							if (a_statr_time != b_statr_time) {
								return a_statr_time < b_statr_time
							} else {
								if (a_start_lv != b_start_lv) {
									return a_start_lv < b_start_lv
								} else {
									return a_time_type < b_time_type
								}
							}
						}
					}
				}
			}
			table.sort(ac_list, sortFunc)
			return ac_list
		}

		this.GetAcyivityRealState = (vo?, state?) => {
			let real_state = local_ActivityState.Unopened
			let serverState = vo.state
			if (serverState == 3) {  //等级限制
				real_state = local_ActivityState.LvLimit
			} else if (serverState == 1) {  //开启
				real_state = local_ActivityState.Opening
			} else if (serverState == 2) {  //关闭
				real_state = state
			}
			return real_state
		}

		this.GetActivityTimeType = (vo?) => {
			let ac_cfg = this.config_ac[vo.module + "@" + vo.module_sub + "@" + vo.ac_sub]
			if (ac_cfg) {
				let dateList = JSON.parse(ac_cfg.time)
				let monthList = JSON.parse(ac_cfg.month)
				let weekList = JSON.parse(ac_cfg.week)
				if (Util.TableSize(dateList) != 0) {
					return TimeType.Date
				}
				if (Util.TableSize(monthList) != 0) {
					return TimeType.Month
				}
				if (Util.TableSize(weekList) != 0) {
					return TimeType.Week
				}
			}
			return TimeType.None
		}

		this.GetActivityStartSecAndStartLv = (act_vo?, now_time?) => {
			let time = new Date(now_time * 1000)//os.date("*t", now_time)
			let start_second, end_second, now_second
			[start_second, end_second, now_second] = [0, 0, 0]
			let start_lv = 0
			let state = local_ActivityState.Unopened
			let ac_cfg = this.config_ac[act_vo.module + "@" + act_vo.module_sub + "@" + act_vo.ac_sub]
			if (ac_cfg) {
				let active_time_list = JSON.parse(ac_cfg.time_region)
				let vo = null
				if (active_time_list) {
					let i = 0
					do {
						vo = active_time_list[i]
						if (vo) {
							let start_hour = Number(vo[local_ActiveTimeType.StartTime][0])
							let start_min = Number(vo[local_ActiveTimeType.StartTime][1])
							let end_hour = Number(vo[local_ActiveTimeType.EndTime][0])
							let end_min = Number(vo[local_ActiveTimeType.EndTime][1])
							let activity_start_sec = start_hour * 3600 + start_min * 60
							let activity_end_sec = end_hour * 3600 + end_min * 60
							let now_sec = Number(time.getHours() * 3600 + time.getMinutes() * 60)
							start_second = activity_start_sec
							end_second = activity_end_sec
							now_second = now_sec
							if (now_sec < activity_start_sec) {
								state = local_ActivityState.Unopened
								break
							} else if (now_sec >= activity_end_sec) {
								state = local_ActivityState.Closed
							} else {
								state = local_ActivityState.Opening
								break
							}
						}
						i = i + 1
					} while ((i < active_time_list.length))
				}
				start_lv = ac_cfg.start_lv
			}
			let isToday = this.EstimateActivityIsToday(act_vo, now_time)
			if (isToday == local_TodayType.No) {
				state = local_ActivityState.Unopened
			} else if (isToday && state != local_ActivityState.Closed) {
				state = local_ActivityState.Today
			}

			let serverState = act_vo.state
			if (serverState == 3) {  //等级限制
				state = local_ActivityState.LvLimit
			} else if (serverState == 1) {  //开启
				state = local_ActivityState.Opening
			} else if (serverState == 2) {  //关闭
				let reservation = this.GetResStatus(act_vo.module, act_vo.module_sub, act_vo.ac_sub)
				if(isToday&&state == ActivityState.Closed
					&&this.CheckIsJoin(act_vo.module, act_vo.module_sub, act_vo.ac_sub)
					&&(reservation!=null&&reservation!=2)){
						state = 0 //随便赋值一个最小的值，让其排在前面
				}else{
					state = state
				}
				//state = state
			}

			return [start_second, start_lv, state, end_second, now_second, isToday]
		}

		this.EstimateActivityIsToday = (act_vo?, time?) => {
			let server_time_model = ServerTimeModel.GetInstance()
			let result = local_TodayType.No
			let nowDate = new Date(time * 1000) //os.date("*t", time)
			let weekday = Number(nowDate.getDay())//Number(os.date("%w", time))
			if (weekday == 0) {
				weekday = 7
			}
			let ac_cfg = this.config_ac[act_vo.module + "@" + act_vo.module_sub + "@" + act_vo.ac_sub]
			if (ac_cfg) {
				let dateList = JSON.parse(ac_cfg.time)
				let monthList = JSON.parse(ac_cfg.month)
				let weekList = JSON.parse(ac_cfg.week)
				let openDayList = JSON.parse(ac_cfg.open_day)
				let mergeDayList = JSON.parse(ac_cfg.merge_day)
				let openDay = server_time_model.GetOpenServerDay()
				let mergeDay = server_time_model.GetMergeServerDay()
				let isToday = false
				if (mergeDay > 0 && Util.TableSize(mergeDayList) > 0) {
					let dayData = this.GetOpenOrMergeDayByCfg(mergeDayList, mergeDay)
					if (dayData) {
						let startDay = Number(dayData[0])
						let endDay = Number(dayData[1])
						if (mergeDay >= startDay && mergeDay <= endDay) {
							//if (endDay - startDay <= 7 ) {
							//isToday = true
							//}else{
							if (Util.TableSize(weekList) > 0) {
								for (let _tmpi in weekList) {
									var vo = weekList[_tmpi]
									if (Number(vo) == Number(weekday)) {
										isToday = true
										break
									}
								}
							} else if (Util.TableSize(weekList) == 0) {
								isToday = true
							}
							//}
						}
					}
				} else if (Util.TableSize(openDayList) > 0) {
					let dayData = this.GetOpenOrMergeDayByCfg(openDayList, openDay)
					if (dayData) {
						let startDay = Number(dayData[0])
						let endDay = Number(dayData[1])
						if (openDay >= startDay && openDay <= endDay) {
							//if (endDay - startDay <= 7 ) {
							//isToday = true
							//}else{
							if (Util.TableSize(weekList) > 0) {
								for (let _tmpi in weekList) {
									var tmp = weekList[_tmpi]
									if (Number(tmp) == Number(weekday)) {
										isToday = true
										break
									}
								}
							} else if (Util.TableSize(weekList) == 0) {
								isToday = true
							}
							//}
						}
					}
				} else if (Util.TableSize(weekList) != 0) {
					for (let _tmpi in weekList) {
						var vo = weekList[_tmpi]
						if (Number(vo) == Number(weekday)) {
							isToday = true
							break
						}
					}
				} else if (Util.TableSize(monthList) != 0) {
					for (let _tmpi in monthList) {
						var vo = monthList[_tmpi]
						if (Number(vo) == Number(nowDate.getMonth())) {
							isToday = true
							break
						}
					}
				} else if (Util.TableSize(dateList) != 0) {
					for (let _tmpi in dateList) {
						var vo = dateList[_tmpi]
						if (Number(vo[0]) == nowDate.getFullYear() && Number(vo[1]) == nowDate.getMonth() && Number(vo[2]) == nowDate.getDate()) {
							isToday = true
							break
						}
					}
				} else if ((Util.TableSize(weekList) == 0 && Util.TableSize(monthList) == 0) && Util.TableSize(dateList) == 0) {
					isToday = true
				}
				if (isToday) {
					result = local_TodayType.Yes
				} else {
					result = local_TodayType.No
				}
			}
			return result
		}

		this.GetOpenOrMergeDayByCfg = (dayList?, day?) => {
			let dayData = null
			for (let _tmpi in dayList) {
				var vo = dayList[_tmpi]
				let startDay = Number(vo[0])
				let endDay = Number(vo[1])
				if (day <= startDay || (day > startDay && day <= endDay)) {
					dayData = vo
					break
				}
			}
			return dayData
		}

		this.GetLimitActivityMaxTimes = (module?, module_sub?) => {
			let max = 0
			if (this.config_ac) {
				let cfg = null
				for (let key in this.config_ac) {

					// [ts2lua]this.config_ac下标访问可能不正确
					cfg = this.config_ac[key]
					if (cfg.module == module && cfg.module_sub == module_sub) {
						max = max + 1
					}
				}
			}
			return max
		}

		this.SetLivenessImageData = (data?) => {
			this.liveness_image_data = data
			//for (let _tmpi in this.liveness_image_data) {
			//var obj = this.liveness_image_data[_tmpi]
			//obj.liveness_cfg = activity_liveness_cfg[obj.act_id + "@" + obj.act_sub]
			//}
			this.Fire(local_DailyEvent.UPDATE_LIVENESS_IMAGE_DATA)
		}

		this.UseNewImage = (new_lv?) => {
			let call_fun = () => {
				if (this.liveness_image_data) {
					if (new_lv > this.liveness_image_data.lv) {
						let cfg = null
						let id = null
						let i = 1
						do {
							cfg = config_liveness_active[i]
							if (cfg) {
								if (new_lv >= cfg.lv && this.liveness_image_data.id != cfg.id) {
									id = cfg.id
								}
							}
							i = i + 1
						} while ((i <= Util.TableSize(config_liveness_active)))
						if (id) {
							this.Fire(local_DailyEvent.DAILY_REQUEST_PROTO, 15711, "i", id)
						}
					}
				}
			}
			if (!config_liveness_active) {
				call_fun()
			} else {
				ResManager.GetInstance().LoadGameConfig(this, "config_liveness_active", false, null, (cfg) => {
					config_liveness_active = cfg
					call_fun()
					ResManager.GetInstance().DestoryGameConfig(this, "config_liveness_active")
				})
			}
		}

		this.SetHuoYueDuData = (data?) => {
			this.huoyuedu_data = data
			for (let _tmpi in this.huoyuedu_data) {
				var obj = this.huoyuedu_data[_tmpi]
				obj.liveness_cfg = config_activity_liveness[obj.act_id + "@" + obj.act_sub]
			}
			let sortFunc = (a?, b?) => {
				if (a.lefttimes == b.lefttimes) {
					return a.act_id < b.act_id
				} else {
					return b.lefttimes > a.lefttimes
				}
			}

			table.sort(this.huoyuedu_data, sortFunc)
			this.Fire(local_DailyEvent.UPDATE_HUOYUEDU_DATA)
		}

		// this.GetLivessnessCfgByFigureId = (figure_id?, config_liveness_active?) => {
		// 	let cfg = null
		// 	if (config_liveness_active) {
		// 		let vo = null
		// 		for (let key in config_liveness_active) {

		// 			// [ts2lua]config_liveness_active下标访问可能不正确
		// 			vo = config_liveness_active[key]
		// 			if (vo.figure_id == figure_id) {
		// 				cfg = vo
		// 			}
		// 		}
		// 	}
		// 	return cfg
		// }

		this.ShowRedDot = () => {
			let show = ((((((this.LivenessCanGet() || this.LivenessCanUpgrade()) || this.liveness_dot_not_show == false && this.LivenessCanFind())
				|| this.LivenessRewardCanGet()) || this.res_find_dot_not_show == false && this.ResCanFind()) ||
				 this.strongerRedDot) || this.GetOffLineRed()) || this.dailyResRed > 0 || 
				(brightSea_model.GetRedState()|| this.daily_task_first_red||brightSea_model.GetRobStatus())
				 ||this.GetResStatusRed()
			this.Fire(local_DailyEvent.REFRESH_DILY_DOT, show)
			local_GlobalEventSystem.Fire(local_EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 157, show)
			return show
		}

		this.LivenessCanGet = () => {
			let can_get = false
			if (this.daily_data[1]) {
				let list = this.daily_data[1].ac_list
				if (list) {
					let cfg = null
					for (let _tmpi in list) {
						var obj = list[_tmpi]
						if (obj.can_get_live > 0) {
							can_get = true
							break
						}
					}
				}
			}
			return can_get
		}

		this.LivenessCanUpgrade = () => {
			let can_upgrade = false
			if (this.liveness_image_data && config_liveness_lv_) {
				let cfg = config_liveness_lv_[this.liveness_image_data.lv]
				if (cfg && cfg.liveness != 0) {
					can_upgrade = (this.liveness_image_data.liveness >= cfg.liveness && (true) || (false))
				}
			}
			return can_upgrade
		}

		this.LivenessCanFind = () => {
			let can_find = false
			return can_find
		}

		this.LivenessRewardCanGet = () => {
			let can_get = false
			if (this.liveness_reward) {
				for (let _tmpi in this.liveness_reward.reward_list) {
					var vo = this.liveness_reward.reward_list[_tmpi]
					if (vo.state == 1) {
						can_get = true
						break
					}
				}
			}
			return can_get
		}

		this.ResCanFind = () => {
			let can_find = false
			if (this.res_find_data) {
				for (let _tmpi in this.res_find_data) {
					var vo = this.res_find_data[_tmpi]
					if (vo.lefttimes + vo.lefttimes_vip > 0) {
						can_find = true
						break
					}
				}
			}
			return can_find
		}

		this.ResNormalCanFind = () => {
			let can_find = false
			if (this.res_find_data) {
				for (let _tmpi in this.res_find_data) {
					var vo = this.res_find_data[_tmpi]
					if (vo.lefttimes > 0) {
						can_find = true
						break
					}
				}
			}
			return can_find
		}

		this.GetActivityRewardList = (ac_cfg?) => {
			let list = []
			if (ac_cfg) {
				let playerLv = role_mgr.GetMainRoleVo().level
				let rewardList = JSON.parse(ac_cfg.reward)
				for (let _tmpi in rewardList) {
					var obj = rewardList[_tmpi]
					if (playerLv >= Number(obj[0])) {
						list = obj[1]
					}
				}
				if (list.length == 0 && rewardList.length != 0) {
					list = rewardList[0][1]
				}
			}
			return list
		}

		this.GetBoxRewardListById = (id?, config_activity_reward?) => {
			let list = null
			if (config_activity_reward) {
				let cfg = config_activity_reward[id]
				if (cfg) {
					let reward_list = JSON.parse(cfg.reward)
					if (reward_list) {
						list = reward_list[0][1]
					}
				}
			}
			return list
		}

		this.GetToadyActivityList = (list?) => {
			let result = []
			if (list) {
				let a_today = local_TodayType.No
				let time = local_TimeUtil.GetZoneTime()
				for (let _tmpi in list) {
					var vo = list[_tmpi]
					a_today = this.EstimateActivityIsToday(vo, time)
					if (a_today == local_TodayType.Yes) {
						table.insert(result, vo)
					}
				}
			}
			return result
		}

		this.getItemConfig = (type?, config_to_be_strong?) => {
			if (!ItemConfigDic_) {
				ItemConfigDic_ = []
				let config = config_to_be_strong
				let list = null
				for (let key in config) {

					let info = config[key]
					let _type = info.type
					list = ItemConfigDic_[_type]
					if (!list) {
						list = [info]
					} else {
						table.insert(list, info)
					}
					ItemConfigDic_[_type] = list
				}
			}
			let _list = ItemConfigDic_[type]
			_list = !_list && [] || _list
			table.sort(_list, (a?, b?) => {
				let aIndex = 100
				let bIndex = 100
				aIndex = aIndex + a.star
				bIndex = bIndex + b.star
				let level = role_mgr.GetMainRoleVo().level
				if (level < a.lv) {
					aIndex = aIndex - a.lv
				}
				if (level < b.lv) {
					bIndex = bIndex - b.lv
				}
				let _data = this.getStrongerDataByid(a.id)
				if (_data && _data.state == 1) {
					aIndex = aIndex - 20
				}
				_data = this.getStrongerDataByid(b.id)
				if (_data && _data.state == 1) {
					bIndex = bIndex - 20
				}
				if (aIndex == bIndex) {
					return a.id > b.id
				} else {
					return aIndex > bIndex
				}

			}
			)
			return _list
		}

		this.setStrongerData = (data?) => {
			this._strongerData = data
			this.Fire(local_DailyEvent.STRONGER_DATA_RETURN)
		}

		this.getStrongerDataByid = (id?) => {
			let strongerData = this.GetStrongerData()
			if (strongerData) {
				for (let key in strongerData.state_list) {
					let info = strongerData.state_list[key]
					if (info.id == id) {
						return info
					}
				}
			}
		}

		this.strongerStar = (num?) => {
			let str = "11111"
			let str2 = ""
			let i = 0
			do {
				str2 = str2 + 0
				i = i + 1
			} while ((i < num))
			return str2 + str.substring(num - 1, str.length - 1)
		}

		this.GetTimeStr = (time_region?) => {
			let state = local_ActivityState.Unopened
			let time_arr = []
			if (time_region) {
				let time = local_TimeUtil.GetZoneTime()
				let dateObj = new Date(time * 1000)//os.date("*t", time)
				let active_time_list = JSON.parse(time_region)
				let startStr = ""
				let endStr = ""
				let vo = null
				if (active_time_list) {
					let i = 0
					do {
						vo = active_time_list[i]
						if (vo) {
							let start_hour = vo[local_ActiveTimeType.StartTime][0]
							let start_min = vo[local_ActiveTimeType.StartTime][1]
							let end_hour = vo[local_ActiveTimeType.EndTime][0]
							let end_min = vo[local_ActiveTimeType.EndTime][1]
							let activity_start_sec = Number(start_hour * 3600) + Number(start_min * 60)
							let activity_end_sec = Number(end_hour * 3600) + Number(end_min * 60)
							let now_sec = Number(dateObj.getHours() * 3600 + dateObj.getMinutes() * 60)
							if (Number(start_min) < 10) {
								start_min = "0" + start_min
							}
							if (Number(end_min) < 10) {
								end_min = "0" + end_min
							}
							startStr = start_hour + ":" + start_min
							endStr = end_hour + ":" + end_min
							if (now_sec < activity_start_sec) {
								state = local_ActivityState.Unopened
								break
							} else if (now_sec >= activity_end_sec) {
								state = local_ActivityState.Closed
							} else {
								state = local_ActivityState.Opening
								break
							}
						}
						i = i + 1
					} while ((i < active_time_list.length))
				}
				time_arr[0] = startStr
				time_arr[1] = endStr
			}
			return [time_arr, state]
		}

		this.LimitActivityIsOpen = (_module?, module_sub?) => {
			let is_open = false
			if ((this.daily_data && this.daily_data[2]) && this.daily_data[2].ac_list) {
				let list = this.daily_data[2].ac_list
				for (let _tmpi in list) {
					var vo = list[_tmpi]
					if (vo.module == _module && vo.module_sub == module_sub) {
						if (vo.state == 1) {
							is_open = true
						}
						break
					}
				}
			}
			return is_open
		}

		this.GetDailyTaskVo = (_module?, module_sub?, ac_sub?) => {
			let info = null
			if ((this.daily_data && this.daily_data[1]) && this.daily_data[1].ac_list) {
				let list = this.daily_data[1].ac_list
				for (let _tmpi in list) {
					var vo = list[_tmpi]
					if ((vo.module == _module && vo.module_sub == module_sub) && vo.ac_sub == ac_sub) {
						info = vo
						break
					}
				}
			}
			return info
		}

		this.GetRecommendUseNum = (goods_vo?) => {
			let outline_time = this.outline_info || outline_model.GetOnhookTime()
			let recommend_num = local_Math.floor((outline_model.max_outline_time - outline_time) / outline_model.add_time[goods_vo.type_id])
			if (goods_vo && goods_vo.goods_num) {
				recommend_num = goods_vo.goods_num > recommend_num && recommend_num || goods_vo.goods_num
				return recommend_num
			}
		}

		//上线离线挂机卡的使用和购买
		this.AutoUseOutLineTimeCard = () => {
			let outline_time = this.outline_info || outline_model.GetOnhookTime()
			let hours = Math.floor(outline_time / 3600)
			if (hours >= 15) {
				return
			}

			let goods_id = null
			for (let _tmpi in outline_model.goods_type) {
				let v = outline_model.goods_type[_tmpi]
				goods_id = goods_model.GetOneGoodsByTypeId(v)
				if (goods_id && goods_id != 0) {
					let goods_vo = goods_model.GetGoodsVoByGoodsId(goods_id)
					if (goods_vo) {
						let recommend_num = this.GetRecommendUseNum(goods_vo)
						if (recommend_num > 0) {
							//goods_vo.goods_num = recommend_num
							local_GlobalEventSystem.Fire(local_EventName.OPEN_ITEM_USE_VIEW, goods_vo)
						}
					}
					return
				}
			}
			if (goods_id == 0) {
				if (ActivityIconManager.GetInstance().getIconInfo("157")) {
					let basic = goods_model.GetGoodsBasicByTypeId(outline_model.cost_goods_type)
					if (outline_time < 2 * 3600) {
						local_GlobalEventSystem.Fire(local_EventName.OPEN_ITEM_USE_VIEW, basic)
					}
				}
			}
		}

		this.GetOffLineRed = () => {
			let outline_time = this.outline_info || outline_model.GetOnhookTime()
			let hours = local_Math.floor(outline_time / 3600)
			return this.outline_red && hours <= 0
		}

		this.GetPersonalBossTimesAndLiveness = (liveness?, config_ac_kv?, config_num_by_vip?) => {
			//@@@
			let times = 0
			let max = 0
			if (!config_ac_kv) {
				return
			}
			let key = config_ac_kv[2].value
			if (key != null) {
				let cfg_key = "610@" + key + "@" + VipModel.GetInstance().GetNobleCardState() + "@" + role_mgr.GetMainRoleVo().vip_flag
				//let cfg_key = "610@" + key + "@" + 1 .. "@" + 1
				//let cfg = null
				let cfg = config_num_by_vip[cfg_key]
				if (cfg) {
					times = Number(cfg.num)
					max = (times >= 4 && (liveness * 4) || (liveness * times))
				} else {
					times = 1
					max = liveness
				}
			}
			return [times, max]
		}

		this.ShowAllReward = (type?) => {
			//@@@
			// let bag_list = merge_find_list_
			// let res_list = this.res_find_data
			// let list = []
			// if (bag_list && bag_list.length > 0) {
			// 	let i = 0
			// 	do {
			// 		let j = 0
			// 		do {
			// 			if ((type == 1 && bag_list[i] && res_list[j] && bag_list[i].act_id == res_list[j].act_id) && bag_list[i].act_sub == res_list[j].act_sub
			// 				&& bag_list[i].config_res_act) {
			// 				let reward_list = JSON.parse(bag_list[i].config_res_act.gold_goods)
			// 				let count = res_list[j].lefttimes - bag_list[i].lefttimes
			// 				let i = 0
			// 				do {
			// 					reward_list[i][2] = Number(reward_list[i][2]) * count
			// 					table.insert(list, reward_list[i])
			// 					i = i + 1
			// 				} while ((i < reward_list.length))
			// 			} else if ((type == 2 && bag_list[i] && res_list[j] && bag_list[i].act_id == res_list[j].act_id) && bag_list[i].act_sub == res_list[j].act_sub
			// 				&& bag_list[i].config_res_act) {
			// 				let reward_list = JSON.parse(bag_list[i].config_res_act.coin_goods)
			// 				let count = res_list[j].lefttimes - bag_list[i].lefttimes
			// 				let i = 0
			// 				do {
			// 					reward_list[i][2] = Number(reward_list[i][2]) * count
			// 					table.insert(list, reward_list[i])
			// 					i = i + 1
			// 				} while ((i < reward_list.length))
			// 			}
			// 			j = j + 1
			// 		} while ((j < res_list.length))
			// 		i = i + 1
			// 	} while ((i < bag_list.length))
			// }
			// if (list && list.length > 0) {
			// 	let view = new CongratulationObtainView(list, 10)
			// 	view.Open()
			// }
		}

		this.ShowReward = (scmd?) => {
			//@@@
			// let bag_list = this.res_find_data
			// let list = []
			// if (bag_list && bag_list.length > 0) {
			// 	let i = 0
			// 	do {
			// 		if (bag_list[i] && bag_list[i].config_res_act) {
			// 			let act_id = bag_list[i].config_res_act.act_id
			// 			let act_sub = bag_list[i].config_res_act.act_sub
			// 			if ((scmd.type == 1 && scmd.act_id == act_id) && scmd.act_sub == act_sub) {
			// 				let count = bag_list[i].lefttimes - scmd.lefttimes
			// 				let reward_list = JSON.parse(bag_list[i].config_res_act.gold_goods)
			// 				if (bag_list[i].lefttimes_vip > scmd.lefttimes_vip) {
			// 					count = count + bag_list[i].lefttimes_vip - scmd.lefttimes_vip
			// 				}
			// 				let i = 0
			// 				do {
			// 					reward_list[i][2] = Number(reward_list[i][2]) * count
			// 					if (scmd.act_id == 610 && scmd.act_sub == 20 || scmd.act_id == 610 && scmd.act_sub == 34) {
			// 						if (reward_list[i][0] == Config.ConfigNotNormalGoods[5].type) {
			// 							reward_list[i][2] = reward_list[i][2] * 1 + RoleManager.GetInstance().GetMainRoleVo().worldLvExp / 100
			// 						}
			// 					}
			// 					table.insert(list, reward_list[i])
			// 					i = i + 1
			// 				} while ((i < reward_list.length))
			// 			} else if ((scmd.type == 2 && scmd.act_id == act_id) && scmd.act_sub == act_sub) {
			// 				let reward_list = JSON.parse(bag_list[i].config_res_act.coin_goods)
			// 				let count = bag_list[i].lefttimes - scmd.lefttimes
			// 				if (bag_list[i].lefttimes_vip > scmd.lefttimes_vip) {
			// 					count = count + bag_list[i].lefttimes_vip - scmd.lefttimes_vip
			// 				}
			// 				let i = 0
			// 				do {
			// 					reward_list[i][2] = Number(reward_list[i][2]) * count
			// 					if (scmd.act_id == 610 && scmd.act_sub == 20 || scmd.act_id == 610 && scmd.act_sub == 34) {
			// 						if (reward_list[i][0] == Config.ConfigNotNormalGoods[5].type) {
			// 							reward_list[i][2] = reward_list[i][2] * 1 + RoleManager.GetInstance().GetMainRoleVo().worldLvExp / 100
			// 						}
			// 					}
			// 					table.insert(list, reward_list[i])
			// 					i = i + 1
			// 				} while ((i < reward_list.length))
			// 			}
			// 		}
			// 		i = i + 1
			// 	} while ((i < bag_list.length))
			// }
			// if (list && list.length > 0) {
			// 	let view = new CongratulationObtainView(list, 10)
			// 	view.Open()
			// }
		}

		this.MergeGoods = (goods_list?) => {
			let list = goods_list
			let reward_dir = []
			let reward_list = []
			let i = 0
			do {
				let type_id, lock
				[type_id, lock] = goods_model.GetMappingTypeId(list[i][0], list[i][1])
				// [ts2lua]reward_dir下标访问可能不正确
				if (!reward_dir[type_id]) {
					// [ts2lua]reward_dir下标访问可能不正确
					reward_dir[type_id] = { type: list[i][0], goods_id: list[i][1], num: list[i][2] }
				} else {
					// [ts2lua]reward_dir下标访问可能不正确
					// [ts2lua]reward_dir下标访问可能不正确
					reward_dir[type_id].num = reward_dir[type_id].num + list[i][2]
				}
				i = i + 1
			} while ((i < list.length))
			for (let key in reward_dir) {

				// [ts2lua]reward_dir下标访问可能不正确
				let reward = reward_dir[key]
				table.insert(reward_list, [reward.type, reward.goods_id, reward.num])
			}
			return reward_list
		}

		this.SetResData = (scmd?, is_table?) => {
			if (!local_reservation) {
				local_reservation = {}
			}
			if (is_table && scmd) {
				local_reservation = {}
				local_join={}
				let red = 0
				let canRes = null
				let roleLv = RoleManager.GetInstance().GetMainRoleVo().level
				let newDate = new Date(TimeUtil.GetZoneTime() * 1000)//os.date("*t", TimeUtil.GetZoneTime())
				let hours = newDate.getHours()
				let min = newDate.getMinutes()
				for (let _tmpi in scmd) {
					var vo = scmd[_tmpi]
					if (vo.module != 500) {
						canRes = false
						let cfg = this.GetAcCfg(vo.module, vo.module_sub, vo.ac_sub)
						if (vo.status == 0 && cfg) {
							let cfgDate = JSON.parse(cfg.time_region)
							if (cfgDate.length > 0) {
								let starTime = cfgDate[0][0]
								if (hours < Number(starTime[0]) || (Number(starTime[0]) == hours && min < Number(starTime[1]))) {
									canRes = roleLv >= cfg.start_lv
								}
							}
						}
						// [ts2lua]local_reservation下标访问可能不正确
						local_reservation[vo.module + "@" + vo.module_sub + "@" + vo.ac_sub] = vo.status
						local_join[vo.module + "@" + vo.module_sub + "@" + vo.ac_sub] = vo.join
						if (vo.status && canRes) {
							red = red + 1
						}
					}
				}
				if (this.dailyResRed != red) {
					this.dailyResRed = red
					GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "DailyView", 2, this.dailyResRed > 0)
					this.ShowRedDot()
				}
			} else {
				// [ts2lua]local_reservation下标访问可能不正确
				local_reservation[scmd.module + "@" + scmd.module_sub + "@" + scmd.ac_sub] = scmd.status
				local_join[scmd.module + "@" + scmd.module_sub + "@" + scmd.ac_sub] = scmd.join
				this.dailyResRed = this.dailyResRed - 1
				this.Fire(DailyEvent.RESERVATION, scmd)
				GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "DailyView", 2, this.dailyResRed > 0)
				this.ShowRedDot()
			}
		}


		this.SetReservationState=(module,module_sub,ac_sub,status)=>{
			local_reservation[module + "@" + module_sub + "@" + ac_sub] =status
		}

		this.CheckIsJoin = (act_id?, module_sub?, ac_sub?)=>{
			let status = 0
			if (local_join && local_join[act_id + "@" + module_sub + "@" + ac_sub] != undefined) {
				status = local_join[act_id + "@" + module_sub + "@" + ac_sub]
			}
			return status==1
		}

		/***预约奖励领取状态 */
		this.GetResStatus = (act_id?, module_sub?, ac_sub?) => {
			let status = null
			if (local_reservation && local_reservation[act_id + "@" + module_sub + "@" + ac_sub] != undefined) {
				status = local_reservation[act_id + "@" + module_sub + "@" + ac_sub]
			}
			return status
		}

		this.GetResStatusRed=()=>{
			let list = this.daily_data && this.daily_data[ActivityType.Limit] && this.daily_data[ActivityType.Limit].ac_list
			if(list){
				for(let key in list){
					let data = list[key]
					if(data && data.ac_cfg)
					{
						let [str_arr, state] = this.GetTimeStr(data.ac_cfg.time_region)
						let rec = this.GetResStatus(data.module, data.module_sub, data.ac_sub)
	
						//参与活动才可以领取奖励
						if (this.CheckIsJoin(data.module, data.module_sub, data.ac_sub)&&state == ActivityState.Closed && rec && rec == 1) {
							return true
						}
	
						//是否可预约的红点
						if (this.CheckActIsReachDay(data) && this.CheckActIsReachLevel(data) && state == ActivityState.Unopened) {
							let reservation = this.GetResStatus(data.module, data.module_sub, data.ac_sub)
							if (reservation != null && reservation == 0) {
								return true
							}
						}
					}
				}
			}
			return false
		}

		this.GetXianShiActivityCfg = () => {
			if (this.xianshiActivityList.length <= 0) {
				let cof = this.config_ac
				for (let key in cof) {

					// [ts2lua]cof下标访问可能不正确
					let data = cof[key]
					if (data.ac_type == 2) {
						table.insert(this.xianshiActivityList, data)
					}
				}
			}
			return this.xianshiActivityList
		}

		this.CheckDailyTaskRed = () => {
			// let last_check_time = CookieWrapper.GetInstance().GetCookie(CookieWrapper.CHECK_DAILY_TASK_RED_TIME)
			// let need_check = false
			// if(last_check_time){
			// 	last_check_time = Number(last_check_time)
			// 	let next_day_time = TimeUtil.GetTimeFutureZeroStamp(last_check_time, 1, 4)
			// 	if(TimeUtil.getServerTime() > next_day_time){
			// 		need_check = true
			// 	}
			// }
			// else{
			// 	need_check = true
			// }

			let need_check = this.daily_task_first_check
			if (need_check) {
				this.daily_task_first_check = false
				//写死日常任务
				let vo = this.GetDailyTaskVo(300, 1, 0)
				if (vo && vo.liveness_cfg.max > vo.num) {
					this.daily_task_first_red = true
				}

				// CookieWrapper.GetInstance().SaveCookie(CookieWrapper.CHECK_DAILY_TASK_RED_TIME, TimeUtil.getServerTime())
			}

			//如果当前有登录红点，判断日常任务是否做完
			if (this.daily_task_first_red) {
				let vo = this.GetDailyTaskVo(300, 1, 0)
				if (vo && vo.liveness_cfg.max == vo.num) {
					this.daily_task_first_red = false
				}
			}
		}


		this.CheckActIsReachDay=(data)=>{
			if (!data.ac_cfg) {
				return
			}

			let dateObj = new Date(TimeUtil.GetZoneTime() * 1000);
			let weekday = dateObj.getDay()
	
			let dateList = JSON.parse(data.ac_cfg.time)
			let monthList = JSON.parse(data.ac_cfg.month)
			let weekList = JSON.parse(data.ac_cfg.week)
			//具体年月日
			let is_find = false
			if (dateList && dateList.length > 0) {
				is_find = true
				let obj = null
				let i = 0
				do {
					obj = dateList[i]
					if (obj) {
						if (Number(obj[0]) == dateObj.getFullYear() && Number(obj[1]) == dateObj.getMonth() && Number(obj[2]) == dateObj.getDay()) {
							return true
						}
					}
					i = i + 1
				} while ((i < dateList.length))
			}
			if (monthList && monthList.length != 0) {
				is_find = true
				let vo = null
				let i = 0
				do {
					vo = Number(monthList[i])
					if (dateObj.getDay() == vo) {
						return true
					}
					i = i + 1
				} while ((i < monthList.length))
			}
			if (weekList && weekList.length != 0) {
				is_find = true
				let vo = null
				let i = 0
				do {
					vo = Number(weekList[i])
					if (vo) {
						if ((vo == weekday) || (vo == 7 && weekday == 0)) {
							return true
						}
					}
					i = i + 1
				} while ((i < weekList.length))
			}

			if (!is_find) return true
			return false
		}

		this.CheckActIsReachLevel=(data)=>{
			let lv = 0
			if (data.liveness_cfg) {
				lv = Number(data.liveness_cfg.start_lv)
			} else {
				lv = Number(data.ac_cfg.start_lv)
			}
			let role_level=role_mgr.mainRoleInfo.level
			return role_level>=lv
		}

	}


	CheckActIsReachDay
	CheckActIsReachLevel

	static Instance: DailyModel
	public static GetInstance() {

		if (!DailyModel.Instance) {
			DailyModel.Instance = new DailyModel()
		}
		return DailyModel.Instance
	}

	public GetstrongerRedDot() {

			return false
		// let playerLv = RoleManager.GetInstance().GetMainRoleVo().level
		// if (playerLv < 150) {
		// 	return false
		// }
		// return this._strongerRedDot
	}

	public SetstrongerRedDot(value?) {

		if (this._strongerRedDot != value) {
			this._strongerRedDot = value
			GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "DailyView", 3, value)
			this.ShowRedDot()
		}
	}

	public GetStrongerData() {

		return this._strongerData
	}

	public SetDailyActData(scmd) {
		this.daily_act_open = scmd.is_remind
		this.daily_act_data = scmd.act_list
	}
	public ResetDailyActData(){
		this.daily_act_data = null
	}
	public GetDailyActData() {
		return this.daily_act_data
	}
	public CanOpenDailyAct() {
		return this.daily_act_open
	}
	public HasNewAct(scmd) {
		let data = this.daily_act_data
		let new_list = scmd.act_list
		let new_module = 0
		if ((!data || (data && Util.TableSize(data) <= 0)) || (new_list && (new_list && Util.TableSize(new_list) >= 0) && data && Util.TableSize(data) > 0) && Util.TableSize(new_list) > Util.TableSize(data)) return [true, new_module]
		let have_new = false
		for (let i = 0; i < data.length; i++) {
			let mod = data[i].module
			let have_same = false
			let new_mod
			for (let j = 0; j < new_list.length; j++) {
				new_mod = new_list[j].module
				if (mod == new_list[j].module) {
					have_same = true
					break
				}
			}
			if (have_same) continue
			have_new = true
			new_module = new_mod
			break
		}
		return [have_new, new_module]
	}

}

window["DailyModel"] = DailyModel

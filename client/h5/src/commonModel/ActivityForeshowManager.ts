import { CommonManager } from "../common/CommonManager"
import { EventName } from "../common/EventName"
import { OpenFun } from "../common/OpenFun"
import { table } from "../common/table"
import { CustomActivityDefine } from "./CustomActivityDefine"
import { CustomActivityModel } from "./CustomActivityModel"
import { DailyModel } from "./DailyModel"
import { DiamondFightModel } from "./DiamondFightModel"
import { NineSkyModel } from "./NineSkyModel"
import { DailyEvent } from "../daily/DailyEvent"
import { RoleManager } from "./RoleManager"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventDispatcher } from "../util/EventDispatcher"
import { Mathf } from "../util/Mathf"
import { TimeUtil } from "../util/TimeUtil"
import { Trim, GlobalTimerQuest, Split } from "../util/Util"
import { ActivityIconManager } from "../commonModel/ActivityIconManager"
import { Kf1vnModel } from "./Kf1vnModel"
import { SnatchTreasureModel } from "./SnatchTreasureModel"

export class ActivityForeshowManager extends EventDispatcher {

	static FORE_TYPE = {
		NINE_SKY_ONE: "135@0@1",
		NINE_SKY_TWO: "135@0@2",
		SNATCHTREASURE: "652@31@0"
	}

	static Instance: ActivityForeshowManager
	static GetInstance() {

		if (!ActivityForeshowManager.Instance) {
			ActivityForeshowManager.Instance = new ActivityForeshowManager()
		}
		return ActivityForeshowManager.Instance
	}

	/**
	 * 活动预告阶段 
	 */
	static ForeshowState = {
		/**
		 * 未开启
		 */
		UnOpen: 0,
		/**
		 * 展示图标
		 */
		Show: 1,
		/**
		 * 倒计时
		 */
		CountDown: 1,
		/**
		 * 活动进行中
		 */
		InProgress: 2,
		/**
		 * 活动结束
		 */
		Finish: 3
	}

	/**
	 * 开始倒计时时间
	 */
	foreshow_count_down_time = 20 * 60
	/**
	 * 开始显示图标时间
	 */
	foreshow_show_time = 60 * 60

	limit_activity_open_dic = {}
	request_dic = {}
	limit_act_list = []
	game_start_tips_list = []
	show_start_tips_list = []
	show_ten_tips_view = []
	show_ten_tips_list = []
	show_tips_list = []
	timer
	tips_view_open = false
	is_pop_tip=false //开始上线时不弹出活动预告的小弹窗
	is_need_pop_act =null //是否需要弹出提示

	public constructor() {
		super()
		this.InitEvents()
	}


	InitEvents() {

		GlobalEventSystem.Bind(EventName.OPEN_FORESHOW_ICON_VIEW, (icon_type?) => {
			this.ClickActivityIcon(icon_type)
		}
		)

		let delay_timer_id = null
		RoleManager.GetInstance().GetMainRoleVo().Bind(EventName.CHANGE_LEVEL, () => {
			if (delay_timer_id) {
				clearTimeout(delay_timer_id)
				delay_timer_id = null
			}
			if (!delay_timer_id) {
				delay_timer_id =
					setTimeout(() => {
						this.SetTimer()
					}, 100)
			}
		}
		)

		GlobalEventSystem.Bind(ServerTimeModel.DAY_CHANGE, () => {
			this.game_start_tips_list = []
			this.show_ten_tips_view = []
			this.show_ten_tips_list = []
			this.show_start_tips_list = []
			this.SetTimer()
		}
		)

		GlobalEventSystem.Bind(ServerTimeModel.REFRESH_SERVER_TIME, () => {
			this.SetTimer()
		}
		)

		DailyModel.GetInstance().Bind(DailyEvent.CONFIG_IS_LOAD, () => {
			this.SetTimer()
		}
		)

		GlobalEventSystem.Bind(EventName.CLOSE_FORESHOWICON, (icon_type?) => {
			this.CloseForeshowicon(icon_type)
		}
		)

		GlobalEventSystem.Bind(EventName.REFRESH_FORESHOWICON, () => {
			this.OnTime()
		})

	}

	public GetLimitActivityList() {
		let level = RoleManager.GetInstance().GetMainRoleVo().level
		let openDay = ServerTimeModel.GetInstance().GetOpenServerDay()
		let mydate = new Date(TimeUtil.GetZoneTime() * 1000)
		let myday = mydate.getDay()
		myday = myday == 0 && 7 || myday
		let actConf = DailyModel.GetInstance().GetXianShiActivityCfg()
		let list = []
		let need_open_min = 0
		let need_open_max = 0
		for (let _tmpi in actConf) {
			var activity = actConf[_tmpi]
			let full_open_day = false
			if (Trim(activity.open_day) == "[]") {
				full_open_day = true
			} else {
				let open_day = JSON.parse(activity.open_day)[0]
				need_open_min = Number(open_day[0])
				need_open_max = Number(open_day[1])
				full_open_day = openDay >= need_open_min && openDay <= need_open_max
			}
			if (full_open_day) {
				let serverTime = TimeUtil.timeHMS(TimeUtil.GetZoneTime() * 1000)
				let timeList = JSON.parse(activity.time_region)
				if (timeList) {
					for (let _tmpi in timeList) {
						var timeConf = timeList[_tmpi]
						let starTime = timeConf[0][0] * 60 * 60 + timeConf[0][1] * 60
						let endTime = timeConf[1][0] * 60 * 60 + timeConf[1][1] * 60
						if (level >= activity.start_lv
							&& (JSON.parse(activity.week) == 0 || activity.week.indexOf(myday) != -1)//string.find(activity.week,String(myday)) != null)
							&& full_open_day
							&& serverTime < endTime) { //&& serverTime > starTime - this.foreshow_show_time
							table.insert(list, activity)
							break
						}
					}
				}
			}
		}
		table.sort(list, (a?, b?) => {
			let timeList = JSON.parse(a.time_region)
			let timeConf = null
			if (timeList) {
				timeConf = timeList[0]
			} else {
				return true
			}
			let aStartime = timeConf[0][0] * 60 * 60 + timeConf[0][1] * 60
			timeList = JSON.parse(b.time_region)
			if (timeList) {
				timeConf = timeList[0]
			} else {
				return true
			}
			let bStartime = timeConf[0][0] * 60 * 60 + timeConf[0][1] * 60
			return aStartime < bStartime
		}
		)
		return list
	}

	public SetGameStartTipsView(list?) {

		let count = 0
		for (let key in list) {
			let activity = list[key]
			let fullTime = false
			let serverTime = TimeUtil.timeHMS(TimeUtil.GetZoneTime() * 1000)
			let timeList = JSON.parse(activity.time_region)
			for (let key in timeList) {
				let time = timeList[key]
				let starTime = time[0][0] * 60 * 60 + time[0][1] * 60
				let endTime = time[1][0] * 60 * 60 + time[1][1] * 60
				if (serverTime <= endTime) {
					if (serverTime < starTime) {
						fullTime = true
					}
					let bool = true
					if (bool) {
						break
					}
				}
			}
			if (fullTime) {
				table.insert(this.game_start_tips_list, activity)
				count = count + 1
				if (count >= 2) {
					break
				}
			}

		}
		if (count > 0) {
			CustomActivityModel.GetInstance().Fire(CustomActivityDefine.EVENT.SHOW_FORES_GAME_SATR_TIPS_VIEW, this.game_start_tips_list[0])
			table.splice(this.game_start_tips_list, 0, 1)
		}
	}

	public ShowAllTipsView() {

		let activity = this.game_start_tips_list[0]
		if (activity) {
			CustomActivityModel.GetInstance().Fire(CustomActivityDefine.EVENT.SHOW_FORES_GAME_SATR_TIPS_VIEW, activity)
			table.splice(this.game_start_tips_list, 0, 1)
			return
		}
		for (let key in this.show_tips_list) {
			let obj = this.show_tips_list[key]
			this.ShowTips(obj[0], obj[1], obj[2])
			return
		}
	}

	public SetTimer() {

		this.limit_act_list = this.GetLimitActivityList()
		if (this.limit_act_list && this.limit_act_list.length > 0) {
			if (!this.timer) {
				this.timer = GlobalTimerQuest.AddPeriodQuest(() => {
					this.OnTime()
				}, 15, -1)
			}
			this.OnTime()
		} else {
			this.RemoveTimer()
		}
	}

	public RemoveTimer() {
		if (this.timer) {
			GlobalTimerQuest.CancelQuest(this.timer)
			this.timer = null
		}
	}

	public OnTime() {
		this.CheckLimitActivityState()
	}

	public CheckLimitActivityState(index?) {

		if (index == null) {
			index = 0
		}

		if (this.limit_act_list.length <= 0) {
			this.RemoveTimer()
			return
		}

		let activity_data = this.limit_act_list[index]
		if (!activity_data) {
			return
		}

		let activity_time_data = this.CheckActivityTime(activity_data)

		if (activity_time_data.show_ten_tips) {
			this.ShowTips(activity_data, false)
		}

		if (activity_time_data.state == ActivityForeshowManager.ForeshowState.Finish) {
			let icon_type = activity_data.module + "@" + activity_data.module_sub + "@" + activity_data.ac_sub
			this.CloseForeshowicon(icon_type)
		}


		//如果活动正在进行中,显示当前活动并判断下一个阶段的活动预告
		if(activity_time_data.state == ActivityForeshowManager.ForeshowState.InProgress){
			this.ShowActivityIconForeshow(activity_data, activity_time_data)
			this.CheckLimitActivityState(index + 1)
			return
		}

		//当前活动是否需要显示预告图标
		let unnecessary_show_icon = activity_time_data.state == ActivityForeshowManager.ForeshowState.UnOpen
		|| activity_time_data.state == ActivityForeshowManager.ForeshowState.Finish

		if (unnecessary_show_icon && this.limit_act_list.length >= index + 1) {
			this.CheckLimitActivityState(index + 1)
		}
		else{
			this.ShowActivityIconForeshow(activity_data, activity_time_data)
		}
		
	}

	public ShowTips(activity?, isStar?, time: number = 2500) { // 默认2500做延迟避免后端还没好为了容错

		let icon_type = activity.module + "@" + activity.module_sub + "@" + activity.ac_sub
		if (this.tips_view_open) {
			table.insert(this.show_tips_list, [activity, isStar, time])
			return
		}
		if (isStar) {
			if (table.find(this.show_start_tips_list, icon_type) != -1) {
				return
			}
			table.insert(this.show_start_tips_list, icon_type)
		} else {
			if (table.find(this.show_ten_tips_list, icon_type) != -1 || table.find(this.show_ten_tips_view, icon_type) == -1) {
				return
			}
			table.insert(this.show_ten_tips_list, icon_type)
		}
		let show_tip_time = setTimeout(() => {
			let info = DailyModel.GetInstance().daily_data[activity.ac_type]
			let actList
			if(info)
				actList = info.ac_list;
			else
				return

			let ac = actList?.find((data) => {
				return activity.module == data?.ac_cfg?.module && activity.module_sub == data?.ac_cfg?.module_sub;
			})

			if (ac?.state == 1) { // 校验后端给予的数据是否已经开启
				CustomActivityModel.GetInstance().Fire(CustomActivityDefine.EVENT.SHOW_FORES_TIPS_VIEW, activity, isStar);
			}
			clearTimeout(show_tip_time)
		}, time)
	}

	/**
	 * 检查活动情况
	 * @param activity 活动数据
	 * @returns data 
	 */
	public CheckActivityTime(activity?) {

		let activity_time_data = {
			state: ActivityForeshowManager.ForeshowState.Finish,
			time: 0,
			msg: "",
			show_ten_tips: false //是否显示10分钟前提示界面
		}

		if (!activity) {
			return activity_time_data
		}

		let now_time = TimeUtil.GetZoneTime()
		let date = new Date(now_time * 1000)
		let h = date.getHours()
		let m = date.getMinutes()
		let s = date.getSeconds()
		let serverTime = h * 3600 + m * 60 + s
		date.setHours(0)
		date.setMinutes(0)
		date.setSeconds(0)
		let baseTime = Mathf.Round(date.getTime() / 1000)
		let timeList = JSON.parse(activity.time_region)
		if (timeList) {
			let starTime, endTime
			for (let _tmpi in timeList) {
				var timeConf = timeList[_tmpi]
				starTime = timeConf[0][0] * 60 * 60 + timeConf[0][1] * 60
				endTime = timeConf[1][0] * 60 * 60 + timeConf[1][1] * 60
				if (serverTime < starTime - this.foreshow_show_time) {
					activity_time_data.state = ActivityForeshowManager.ForeshowState.UnOpen
					
				} else if (serverTime >= starTime - this.foreshow_show_time && serverTime < starTime) {
					activity_time_data.state = ActivityForeshowManager.ForeshowState.Show
					activity_time_data.time = baseTime + endTime
					activity_time_data.msg = timeConf[0][0] + ":" + (timeConf[0][1] == "0" && ("00") || (timeConf[0][1])) + "开启"
					break;
				} else if (serverTime >= starTime - this.foreshow_count_down_time && serverTime < starTime) {
					activity_time_data.state = ActivityForeshowManager.ForeshowState.CountDown
					activity_time_data.time = baseTime + starTime
					activity_time_data.show_ten_tips = serverTime >= starTime - 10 * 60 && serverTime <= starTime - 9 * 60
					break;
				} else if (serverTime >= starTime && serverTime < endTime) {
					activity_time_data.state = ActivityForeshowManager.ForeshowState.InProgress
					activity_time_data.time = baseTime + endTime
					break;
				} else if (serverTime >= endTime) {
					activity_time_data.state = ActivityForeshowManager.ForeshowState.Finish
					activity_time_data.time = 0
				}
			}
		}
		return activity_time_data
	}

	/**
	 * 显示活动预告图标
	 * @param activity 
	 * @param time 
	 * @param state 
	 * @param msg 
	 * @returns 
	 */
	public ShowActivityIconForeshow(activity_data, activity_time_data) {

		let icon_type = activity_data.module + "@" + activity_data.module_sub + "@" + activity_data.ac_sub
		let icon = ActivityIconManager.GetInstance().getIconInfo(icon_type)
		this.ActivityRequestData(icon_type)
		let can_open = this.CheckActivityOpenState(icon_type)
		if (icon && !can_open) {
			this.CloseForeshowicon(icon_type)
		} else if (!icon || (icon && activity_time_data.state != ActivityForeshowManager.ForeshowState.InProgress)) {
			let icon_info = CommonManager.GetInstance().GetFunctionIconCfg(icon_type)
			if (icon_info) {
				icon_info["foreshow_icon"] = true
				icon_info["foreshow_show"] = false
				icon_info["foreshow_msg"] = false
				icon_info["foreshow_ing"] = false
				if (activity_time_data.state == ActivityForeshowManager.ForeshowState.Show) {
					icon_info["foreshow_show"] = true
					icon_info["foreshow_msg"] = activity_time_data.msg
				} else if (activity_time_data.state == ActivityForeshowManager.ForeshowState.CountDown) {
					icon_info["foreshow_ing"] = true
				} else if (activity_time_data.state == ActivityForeshowManager.ForeshowState.InProgress) {
					if (!can_open) {
						return
					}
					// icon_info["effect_name"] = "ui_function_glow"
					this.ShowTips(activity_data, true)
				}
				ActivityIconManager.GetInstance().addIcon(icon_type, activity_time_data.time, icon_info)
			} else if (!icon_info) {
				console.log("找不到预告图标，查看图标配置")
			}
		} else if (icon && activity_time_data.state == ActivityForeshowManager.ForeshowState.InProgress && icon.data && (icon.data.foreshow_ing || icon.data.foreshow_show)) {	//解决30分钟预告前断线再重连导致显示错误问题
			let icon_info = CommonManager.GetInstance().GetFunctionIconCfg(icon_type)
			icon_info["foreshow_icon"] = true
			icon_info["foreshow_show"] = false
			icon_info["foreshow_msg"] = false
			icon_info["foreshow_ing"] = false
			if (icon_info) {
				if (!can_open) {
					return
				}
				// icon_info["effect_name"] = "ui_function_glow"
				this.ShowTips(activity_data, true)
				ActivityIconManager.GetInstance().addIcon(icon_type, activity_time_data.time, icon_info)
			}
		}
	}

	public CheckActivityOpenState(icon_type?) {

		let can_open = true
		if (icon_type == ActivityForeshowManager.FORE_TYPE.NINE_SKY_ONE
			|| icon_type == ActivityForeshowManager.FORE_TYPE.NINE_SKY_TWO) {
			can_open = NineSkyModel.GetInstance().GetOpenState()
		} else if (icon_type == ActivityForeshowManager.FORE_TYPE.SNATCHTREASURE) {
			can_open = SnatchTreasureModel.GetInstance().checkOpen()
		}

		return can_open
	}

	public ActivityRequestData(icon_type?) {
		let request = this.request_dic[icon_type]
		if (!request && request != false) {
			switch (icon_type) {
				case ActivityForeshowManager.FORE_TYPE.SNATCHTREASURE:
					SnatchTreasureModel.GetInstance().Fire(SnatchTreasureModel.SCMD_REQUEST, 65208)
					break;
			}

			this.request_dic[icon_type] = true
		}
	}

	public CloseForeshowicon(icon_type?) {
		if (this.request_dic[icon_type]) {
			delete this.request_dic[icon_type]
		}
		ActivityIconManager.GetInstance().deleteIcon(icon_type)
		this.DelLimitActivityOpen(icon_type)
		this.limit_act_list = this.GetLimitActivityList()
	}

	public ActivityEndTime(typeId?) {

		let id = Number(Split(String(typeId), "@")[0])
		let act = DailyModel.GetInstance().GetXianShiActivityCfg()
		let activity = null
		for (let _tmpi in act) {
			var key = act[_tmpi]
			if (key.module == id) {
				activity = key
			}
		}
		if (!activity) {
			return 0
		}
		let serverTime = TimeUtil.timeHMS(TimeUtil.GetZoneTime() * 1000)
		let timeConf = JSON.parse(activity.time_region)
		let time = 0
		let subTime = 0
		for (let key in timeConf) {

			if (timeConf[key]) {
				let timeList = timeConf[key]
				time = timeList[1][0] * 60 * 60 + timeList[1][1] * 60
				if (serverTime < time) {
					subTime = time - serverTime
					break
				}
			}
		}
		return TimeUtil.GetZoneTime() + subTime
	}

	public ClickActivityIcon(icon_type?) {

		let list = Split(String(icon_type), "@")
		let module = list[0]
		let module_sub = list[1]
		let ac_sub = list[2]
		let activity = DailyModel.GetInstance().GetAcCfg(module, module_sub, ac_sub)
		if (activity) {
			let activity_data = this.CheckActivityTime(activity)
			if (activity.request_id != 0 && this.CheckApply(module, activity_data.state)) {
				OpenFun.RequestOpen(activity.request_id)
			} else {
				OpenFun.OpenFunHandler(activity.jump_id)
			}
		}
	}

	public CheckApply(module?, act_type?) {

		module = Number(module)
		let flag = true
		switch (module) {
			case 137://勾玉大战
				flag = DiamondFightModel.GetInstance().HasSignUp()
				break;
			case 621:
				let kf_1vn_model = Kf1vnModel.GetInstance()
				flag = kf_1vn_model.page_info && kf_1vn_model.page_info.is_sign == 1
				break;
			case 218:
				flag = false
				break;
			case 652:
				flag = act_type == 2
				break;
			default:
				break;
		}
		return flag
	}

	public SetLimitActivityOpen(icon_type) {
		this.limit_activity_open_dic[icon_type] = true
	}

	public DelLimitActivityOpen(icon_type) {
		delete this.limit_activity_open_dic[icon_type]
	}

	public CheckLimitActivityOpen(icon_type) {
		let open = false
		let info = this.limit_activity_open_dic[icon_type]
		if (info) {
			open = true
		}
		return open
	}

	public OpenFunctionOpen(icon_type) {

		let list = Split(icon_type, "@")
		let activity = DailyModel.GetInstance().GetAcCfg(list[0], list[1], list[2])
		if (activity) {
			activity["Foreshow"] = true
			CustomActivityModel.GetInstance().Fire(CustomActivityDefine.EVENT.SHOW_FORES_GAME_SATR_TIPS_VIEW, activity)
		}
	}

	public GetActivity(icon) {
		let list = Split(String(icon), "@")
		let activity = DailyModel.GetInstance().GetAcCfg(list[0], list[1], list[2])
		return activity
	}

	public CheckActivityOpenToDay(type?, subType?, ac_sub?, need_time?) {
		if (need_time == null) {
			need_time = true
		}
		let flag = false
		let activity = DailyModel.GetInstance().GetAcCfg(type, subType, ac_sub)
		if (!activity) {
			return false
		}
		let openDay = ServerTimeModel.GetInstance().GetOpenServerDay()
		let mydate = new Date(TimeUtil.GetZoneTime() * 1000)
		let myday = mydate.getDay()
		myday = myday == 0 && 7 || myday
		let need_open_min = 0
		let need_open_max = 0
		let full_open_day = false
		if (Trim(activity.open_day) == "[]") {
			full_open_day = true
		} else {
			let open_day = JSON.parse(activity.open_day)[0]
			need_open_min = Number(open_day[0])
			need_open_max = Number(open_day[1])
			full_open_day = openDay >= need_open_min && openDay <= need_open_max
		}

		let full_day =
			(JSON.parse(activity.week) == 0 || activity.week.indexOf(myday) != -1)//string.find(activity.week, String(myday)) != null)
			&& full_open_day

		if (need_time) {
			let serverTime = TimeUtil.timeHMS(TimeUtil.GetZoneTime() * 1000)
			let timeList = JSON.parse(activity.time_region)
			if (timeList) {
				for (let _tmpi in timeList) {
					var timeConf = timeList[_tmpi]
					let starTime = timeConf[0][0] * 60 * 60 + timeConf[0][1] * 60
					let endTime = timeConf[1][0] * 60 * 60 + timeConf[1][1] * 60
					if ((full_day && serverTime < endTime) && serverTime >= starTime) {
						return true
					}
				}
			}
		} else {
			flag = full_day
		}
		return flag
	}

}
window["ActivityForeshowManager"] = ActivityForeshowManager
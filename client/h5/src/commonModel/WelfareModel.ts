import { Alert, Alert_Type } from "../alert/Alert"
import { CommonManager } from "../common/CommonManager"
import { CookieWrapper } from "../common/CookieWrapper"
import { EventName } from "../common/EventName"
import { RedDotManager, ModuleType } from "../common/RedDotManager"
import { ResManager } from "../common/ResManager"
import { PlatformManager } from "../PlatformManager"
import { RoleManager } from "./RoleManager"
import { GlobalEventSystem, ClientConfig } from "../util/DeclareGlobalVar"
import { EventDispatcher } from "../util/EventDispatcher"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest, Util } from "../util/Util"
import { CustomActivityModel } from "./CustomActivityModel"
import { VipModel } from "./VipModel"
import { Config } from "../common/Config"
import { table } from "../common/table"
import { LoginModel } from "../login/LoginModel"
import { md5 } from "../util/md5"

export let WelfareEvent = {
	WELFARE_REQUEST_PROTO: "WELFARE_REQUEST_PROTO",
	WELFARE_OPEN_VIEW: "WELFARE_OPEN_VIEW",
	UPDATE_DAILY_SIGN_DATA: "UPDATE_DAILY_SIGN_DATA",
	RETROACTIVE: "RETROACTIVE",
	UPDATE_LEVEL_REWARD_VIEW: "WelfareEvent.UPDATE_LEVEL_REWARD_VIEW",
	UPDATE_LEVEL_REWARD_NUM: "WelfareEvent.UPDATE_LEVEL_REWARD_NUM",
	UPDATE_XINYUE_VIEW: "WelfareEvent.UPDATE_XINYUE_VIEW",
	UPDATE_RES_GIFT_STATE: "UPDATE_RES_GIFT_STATE",
	SHOW_DOWN_RES_SPEED: "SHOW_DOWN_RES_SPEED",
	SHOW_SVIP_ICON: "SHOW_SVIP_ICON",
	UPDATE_AD_STATE: "UPDATE_AD_STATE",
	UPDATE_ONLINE_VIEW_RED: "UPDATE_ONLINE_VIEW_RED"
}

export let WefareIndex = {
	DailySign: 1,
	OnLine: 2,
	DailySupply: 3,
	ExchangeGift: 4,
	SuperVip: 5,
	Attention: 6
}

//广告常量
export let AdModuleId = {
	Adventure:1,				//遗迹探宝
	DungeonEquip: 2,			//装备副本
	MondayReward: 3,			//周一大奖
}
window["WelfareEvent"] = WelfareEvent
window["WefareIndex"] = WefareIndex
window["AdModuleId"] = AdModuleId
export class WelfareModel extends EventDispatcher {

	static LEVEL_REWARD_SHOW_PARM = 50
	static WBQQLive = "331_wb_qqlive"
	static Instance: WelfareModel
	public static GetInstance() {
		if (!WelfareModel.Instance) {
			WelfareModel.Instance = new WelfareModel()
		}
		return WelfareModel.Instance
	}


	CheckOnlineReddot
	CheckSuperVipOpenState
	ClearOnlineTimer
	GetDailySupplyRed
	GetKvCfg
	GetLevelRewardInfo
	GetLevelRewardRed
	GetOnlineCfg
	GetOnlineData
	GetSuperVipRed
	GetVerifyState
	GetVerifyStateFormSdk
	InitXinYueGift
	RefreshDailySupplyRed
	RefreshSuperVipRed
	Reset
	SetDailyRed
	SetDailySignData
	SetLevelRewardInfo
	SetLevelRewardRed
	SetOnlineData
	SetOnlineReddot
	ShowIconRed
	StartOnlineTimer
	TodayHadSign
	UpdataLevelRewardNum
	UpdateOnlineTimer
	UpdateWelfareRed


	ad_data
	ad_is_first_alert
	dailysign_red
	dailysigndata
	level_reward_red
	now_click_to_check_day
	online_mark
	online_red
	res_gift_open_state
	res_gift_reward_state
	resource_load_info
	show_jinlock_to_jin
	show_story_arrow_day
	today_had_sign
	xinYue_Data
	config_advertisement
	config_key_value
	online_data
	online_is_first_login
	
	public constructor() {
		super()
		if (WelfareModel.Instance) {
			return
		}
		WelfareModel.Instance = this

		this.dailysigndata = null
		this.show_jinlock_to_jin = true
		this.online_mark = null //用于标记在线奖励倒计时,有且只有一个倒计时
		this.dailysign_red = null
		this.online_red = null
		this.level_reward_red = null
		this.show_story_arrow_day = null
		this.online_data = null
		this.xinYue_Data = null
		this.ad_data = null		//广告状态
		this.today_had_sign = false			//今天是否签到
		this.ad_is_first_alert = true		//广告弹窗是否第一次弹起
		this.now_click_to_check_day = null	//当前点击签到的天数
		let local_WelfareEvent = WelfareEvent
		let local_TimeUtil = TimeUtil
		//let local_laya = Laya
		let local_GlobalEventSystem = GlobalEventSystem
		let update_window_red_event = EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE
		let update_activity_icon_red_event = EventName.REFRESH_ACTIVITY_ICON_RED_DOT
		let red_dot_mgr = RedDotManager.GetInstance()
		let local_ModuleType = ModuleType
		let custom_activity_model = CustomActivityModel.GetInstance()
		let online_timer_ = null
		let online_list_ = null
		let online_cfg_ = Config.PRELOAD_SERVER_CONFIG.config_online_reward
		let kv_cfg_ = Config.PRELOAD_SERVER_CONFIG.config_welfare_cfg
		let level_reward_info_ = null
		let super_vip_red_state_ = false
		let id_verify_state = null
		let phone_verify_state = null
		this.online_is_first_login = true

		this.Reset = () => {
			this.ClearOnlineTimer()
			this.today_had_sign = false
			this.ad_is_first_alert = true


			online_cfg_ = Config.PRELOAD_SERVER_CONFIG.config_online_reward
			kv_cfg_ = Config.PRELOAD_SERVER_CONFIG.config_welfare_cfg
			this.config_advertisement = Config.PRELOAD_SERVER_CONFIG.config_advertisement
			this.config_key_value = Config.PRELOAD_SERVER_CONFIG.config_key_value
		}

		this.SetDailySignData = (scmd?) => {
			this.dailysigndata = scmd
			this.Fire(local_WelfareEvent.UPDATE_DAILY_SIGN_DATA, scmd)
			let red = false
			for (let _tmpi in scmd.acc_state) {
				var vo = scmd.acc_state[_tmpi]
				if (vo.receive == 3 || vo.receive == 4) {
					red = true
					break
				}
			}
			if (!red) {
				for (let _tmpi in scmd.total_state) {
					var vo = scmd.total_state[_tmpi]
					if (vo.receive == 3) {
						red = true
						break
					}
				}
			}
			this.SetDailyRed(red)
		}

		//今天是否已签到
		this.TodayHadSign = () => {
			this.today_had_sign = false
			if (this.dailysigndata && this.dailysigndata.check_day > 0) {
				this.today_had_sign = true
				//for (let _tmpi in this.dailysigndata.acc_state) {
				// var vo = this.dailysigndata.acc_state[_tmpi]
				//if (vo.receive == 5 ) {
				//this.today_had_sign = true
				//break
				//}
				//}
			}
			return this.today_had_sign
		}

		this.SetOnlineData = (scmd?) => {
			this.ChangeVar("online_data", scmd, false, true)
			this.StartOnlineTimer()
			this.SetOnlineReddot(this.CheckOnlineReddot())
		}

		this.GetOnlineData = () => {
			return this.online_data
		}

		this.GetOnlineCfg = (id?) => {
			// [ts2lua]online_cfg_下标访问可能不正确
			return online_cfg_ && online_cfg_[id]
		}

		this.GetKvCfg = (id?) => {
			// [ts2lua]kv_cfg_下标访问可能不正确
			let data = kv_cfg_[id]
			// [ts2lua]lua中0和空字符串也是true，此处data需要确认
			return (data && (data.val) || (null))
		}

		this.CheckOnlineReddot = () => {
			let data = this.GetOnlineData()
			if (!data) {
				return false
			}
			if(this.online_is_first_login &&CustomActivityModel.GetInstance().GetDayFirstLoginStatus()){
				return true
			}
			for (let _tmpi in data.list) {
				var info = data.list[_tmpi]
				// [ts2lua]online_cfg_下标访问可能不正确
				let cfg = online_cfg_ && online_cfg_[info.id]
				if (!cfg) {
					break
				}
				if (info.state == 0 && data.time >= cfg.online_time) {
					return true
				}
			}
			return false
		}

		this.StartOnlineTimer = () => {
			this.ClearOnlineTimer()
			let data = this.GetOnlineData()
			online_list_ = []
			for (let _tmpi in data.list) {
				var info = data.list[_tmpi]
				// [ts2lua]online_cfg_下标访问可能不正确
				let cfg = online_cfg_ && online_cfg_[info.id]
				if (!cfg) {
					break
				}
				if (info.state == 0 && cfg.online_time > data.time) {
					table.insert(online_list_, cfg.online_time - data.time + local_TimeUtil.getServerTime())
				}
			}
			if (online_list_.length > 0) {
				online_timer_ = GlobalTimerQuest.AddPeriodQuest(() => {
					this.UpdateOnlineTimer()
				}, 1, -1)

			}
		}

		this.ClearOnlineTimer = () => {
			if (online_timer_) {
				GlobalTimerQuest.CancelQuest(online_timer_)
				online_timer_ = null
			}
		}

		this.UpdateOnlineTimer = () => {
			let i = 0
			do {
				let rtime = online_list_[i] - local_TimeUtil.getServerTime()
				if (rtime <= 0) {
					online_list_.splice(i, 1)
					this.SetOnlineReddot(true)
					i = i - 1
				}
				i = i + 1
			} while ((i < online_list_.length))
			if (online_list_.length < 1) {
				this.ClearOnlineTimer()
			}
		}

		this.ShowIconRed = () => {
			local_GlobalEventSystem.Fire(update_activity_icon_red_event, 417)
		}

		this.SetOnlineReddot = (red?) => {
			red_dot_mgr.SetRedStatus(local_ModuleType.ONLINE, 1, red)
			this.online_red = red
			this.UpdateWelfareRed(1, red)
		}

		this.SetDailyRed = (red?) => {
			red_dot_mgr.SetRedStatus(local_ModuleType.DAILY, 0, red)
			this.dailysign_red = red
			if (!CommonManager.GetInstance().CheckFuncOpenState("DailySignView", true)) {
				return
			}
			this.UpdateWelfareRed(0, red)
		}

		this.SetLevelRewardRed = (red?) => {
			this.level_reward_red = red
			custom_activity_model.RefreshIconRed(417, 0)
		}

		this.UpdateWelfareRed = (index?, state?) => {
			local_GlobalEventSystem.Fire(update_window_red_event, "WelfareView", index, state)
			let red = this.online_red || this.dailysign_red
			local_GlobalEventSystem.Fire(update_activity_icon_red_event, 417)
			this.Fire(WelfareEvent.UPDATE_ONLINE_VIEW_RED,index,state)
		}

		this.SetLevelRewardInfo = (info?) => {
			level_reward_info_ = info
			let bool = false
			for (let _tmpi in info.giftbag_state) {
				var vo = info.giftbag_state[_tmpi]
				if (vo.received == 1) {
					bool = true
					break
				}
			}
			this.SetLevelRewardRed(bool)
			this.Fire(local_WelfareEvent.UPDATE_LEVEL_REWARD_VIEW)
		}

		this.UpdataLevelRewardNum = (scmd?) => {
			if (!level_reward_info_) {
				return
			}
			for (let i in level_reward_info_.giftbag_state) {

				if (level_reward_info_.giftbag_state[i].lv == scmd.lv) {
					level_reward_info_.giftbag_state[i].draw_num = scmd.remain_num
				}
			}
			this.Fire(local_WelfareEvent.UPDATE_LEVEL_REWARD_NUM, scmd.lv, scmd.remain_num)
		}

		this.GetLevelRewardInfo = () => {
			return level_reward_info_
		}
		this.GetLevelRewardRed = () =>{
			return this.level_reward_red
		}
		this.RefreshSuperVipRed = () => {
			// this.GetGameConfig("ConfigSuperVip",(super_vip_cfg?) => {
			// 	let bool = false
			// 	if (this.CheckSuperVipOpenState(super_vip_cfg) ) {
			// 		let last_time = CookieWrapper.GetInstance().GetCookie(CookieLevelType.Account, CookieKey.SUPER_VIP_RED)
			// 		if (! last_time || local_TimeUtil.getServerTime() > Number(last_time) ) {
			// 			bool = true
			// 		}
			// 	}
			// 	if (super_vip_red_state_ != bool ) {
			// 		super_vip_red_state_ = bool
			// 		//local_GlobalEventSystem:Fire(update_window_red_event, "WelfareView", WefareIndex.SuperVip, bool)
			// 		local_GlobalEventSystem.Fire(update_activity_icon_red_event, 452)
			// 	}
			// }
			// , true)
		}

		this.GetSuperVipRed = () => {
			return super_vip_red_state_
		}

		this.CheckSuperVipOpenState = (super_vip_cfg?) => {
			let bool = false
			if (!super_vip_cfg) {
				return false
			}
			let level = RoleManager.GetInstance().GetMainRoleVo().level
			if (level < super_vip_cfg["open_lv"]) {
				return bool
			}
			let plat_name = ClientConfig.plat_name
			let data = null
			if (plat_name && super_vip_cfg) {
				for (let plat_tips in super_vip_cfg) {

					if (plat_name.find(plat_tips)) {
						data = super_vip_cfg[plat_tips]
						bool = true
						break
					}
				}
			}
			if ((!VipModel.GetInstance().all_recharge_record || !data) || data && VipModel.GetInstance().all_recharge_record < data.recharge) {
				bool = false
			}
			return bool
		}

		this.GetDailySupplyRed = () => {
			let bool = false
			if(CommonManager.GetInstance().CheckFuncOpenState("DailySupplyView", true)){
				bool = custom_activity_model.GetRedDotValue(61, 1) > 0
			}
			return bool
		}

		this.RefreshDailySupplyRed = () => {
			let red = custom_activity_model.GetRedDotValue(61, 1)
			local_GlobalEventSystem.Fire(update_activity_icon_red_event, 417)
			local_GlobalEventSystem.Fire(update_window_red_event, "WelfareView", 2, red > 0)
		}

		this.GetVerifyStateFormSdk = () => {
			//let sdk_name = local_PlatformManager.GetInstance().sdk_name
			//// [ts2lua]window下标访问可能不正确
			//// [ts2lua]window下标访问可能不正确
			//if ((sdk_name && window[sdk_name]) && window[sdk_name].getBindInfo ) {
			//// [ts2lua]window下标访问可能不正确
			//window[sdk_name].saveIdCard("idcard",(data?) => {
			//console:warn("idcard验证状态+++++++：", data)
			//id_verify_state = data.ret && data.ret == "SUCCESS"
			//}
			//)
			//// [ts2lua]window下标访问可能不正确
			//window[sdk_name].saveIdCard("phone",(data?) => {
			//console:warn("phone验证状态+++++++：", data)
			//phone_verify_state = data.ret && data.ret == "SUCCESS"
			//}
			//)
			//}
		}

		this.GetVerifyState = (_type?) => {
			//if (local_Util.IsDebug() || local_PlatformManager.GetPlatformName() == "yy_suyou" ) {
			//return false
			//}
			//if (_type == "phone" ) {
			//return phone_verify_state
			//} else if (_type == "idcard" ) {
			//return id_verify_state
			//}
			//return false
		}

		this.InitXinYueGift = () => {
		}


	}

	//检测资源大礼是否开启
	public UpdateResourceGiftRewardState(scmd?) {

		this.res_gift_reward_state = scmd.code
		this.Fire(WelfareEvent.UPDATE_RES_GIFT_STATE)
	}

	public GetResourceGiftOpenState() {

		// let bool = false
		// if (StepPackModule.GetInstance().IsSupport() &&  this.res_gift_reward_state != 2)
		// {
		//     bool =  true
		// }
		// this.res_gift_open_state = bool
		// return bool
	}

	public GetResourceGiftRewardState() {

		return this.res_gift_reward_state
	}

	//检测资源大礼红点
	public CheckResoureGiftRedDot() {

		// let bool = false
		// let down_state = StepPackModule.GetInstance().CurrentPackState()
		// if (down_state == 3 && this.res_gift_state && this.res_gift_state == 1)
		// {
		//     bool = true
		// }
		// return bool
	}

	//检测资源大礼红点
	public SetResourceDownInfo(now_size?, all_size?, speed?, isdone?) {

		this.resource_load_info = this.resource_load_info || {}
		this.resource_load_info.now_size = now_size
		this.resource_load_info.all_size = all_size
		this.resource_load_info.speed = speed
		this.resource_load_info.isdone = isdone
	}

	public GetResourceDownInfo() {
		return this.resource_load_info
	}
	
	//广告状态
	public SetAdData(data?) {
		this.ad_data = data
		this.Fire(WelfareEvent.UPDATE_AD_STATE)
	}

	//通过广告id获取广告的观看状态
	public GetAdLookState(mod_id?, mod_sub_id?) {
		let had_look = false
		if (this.ad_data) {
			for (let i = 0; i < this.ad_data.length; i++) {
				var v = this.ad_data[i]
				if (mod_id == v.mod_id && mod_sub_id == v.sub_id && v.count > 0) {
					had_look = true
				}
			}
		}
		return had_look
	}

	//获取广告配置
	public GetAdCfg(module_id?) {
		let cfg = null
		let mod_id = null
		let mod_sub_id = null
		if (module_id) {
			if (module_id == AdModuleId.Adventure) {
				mod_id = 427
				mod_sub_id = 1
			} else if (module_id == AdModuleId.DungeonEquip) {
				mod_id = 610
				mod_sub_id = 5
			} else if (module_id == AdModuleId.MondayReward) {
				mod_id = 179
				mod_sub_id = 1
			}
		}
		if (this.config_advertisement && mod_id && mod_sub_id) {
			for (let k in this.config_advertisement) {
				var v = this.config_advertisement[k]
				if (v.mod_id == mod_id && v.mod_sub_id == mod_sub_id) {
					cfg = v
					break
				}
			}
		}
		return cfg
	}

	public GetAdOpenState(){
		if(Util.IsConch() && PlatformManager.IsEyouPlatform() && ClientConfig.ShowEyouAd){
			return true
		}
		return false
		// return true
	}

	//是否显示看广告的按钮
	public GetAdLookStateByMoudleId(module_id?):boolean{
		if(!module_id || !this.GetAdOpenState()) return false
		let cfg = this.GetAdCfg(module_id)
		if (cfg) {
			return this.GetAdLookState(cfg.mod_id, cfg.mod_sub_id)
		}
		return false
	}

	//开始看广告
	/**
	 * 激励广告后端逻辑:
	 * 用户点击广告 -> 客户端发送19303 -> 服务端记录下客户端发送的广告信息 -> 服务端接收php调用 -> 根据刚刚的记录来发奖励
	 * 激励广告前端逻辑:
	 * 用户点击广告 -> 客户端发送19303 同时调用SDK接口传入广告id -> 等到后端收到播放成功的消息后通知前端界面刷新
	 * (这里实际上发过去的广告ID是没用到的，但是这里还是按照配置发一下，方便以后拓展。)
	 * @param ad_cfg 
	 */
	public PlayAd(ad_cfg?) {
		if (ad_cfg) {
			this.Fire(WelfareEvent.WELFARE_REQUEST_PROTO, 19303, "iii", ad_cfg.mod_id, ad_cfg.mod_sub_id, 0)
			PlatformManager.GetInstance().ShowAd(ad_cfg.advertisement_id)
		}
	}

	//开始看广告,活动模块使用
	public PlayActivityAd(grade_id?) {
		let ad_cfg = this.config_advertisement[1]
		if (grade_id && ad_cfg) {
			this.Fire(WelfareEvent.WELFARE_REQUEST_PROTO, 19303, "iii", 331, 1, grade_id)
			PlatformManager.GetInstance().ShowAd(ad_cfg.advertisement_id)
		}
	}

	public PlayAdAlert(ad_cfg?, alert_str?) {
		if (ad_cfg) {
			alert_str = alert_str || "观看完影片可再获得一次免费次数！"
			let okFun = () => {
				WelfareModel.GetInstance().PlayAd(ad_cfg)
			}
			let cancel_func = () => {

			}
			Alert.Show(alert_str, Alert_Type.Two, okFun, cancel_func, "查看广告", "取消")
		}
	}
}
window["WelfareModel"] = WelfareModel
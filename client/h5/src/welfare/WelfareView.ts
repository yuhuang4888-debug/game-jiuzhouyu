import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { EventName } from "../common/EventName"
import { RedDotManager, ModuleType } from "../common/RedDotManager"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { RoleManager } from "../commonModel/RoleManager"
import { WelfareModel, WefareIndex } from "../commonModel/WelfareModel"
import { LoginModel } from "../login/LoginModel"
import { GlobalEventSystem, ClientConfig } from "../util/DeclareGlobalVar"
import "./WelfareWelcomeView"
import "../exChange/ExchangeGiftView"
import "../dailySign/DailySignView"
import "../activity/DailySupplyView"
import "../gameNotice/GameNoticeView"
import "../online/OnlineView"
import { PlatformManager } from "../PlatformManager"
import { Config } from "../common/Config"
import { EyouManager } from "../commonController/EyouManager"


export class WelfareView extends BaseWindowComponent {
	CheckDailyReddot
	CheckDailySupplyRed
	CheckOnlineRedDot
	CheckGameNoticeRed
	SetTab
	bg_list
	destroy_imm
	money_list
	preload_client_config
	tabStrList
	tab_new_cond
	titleList
	titleStr
	viewClassList
	window_open_back

	public constructor() {
		super()
		this.titleStr = "dailySign.uiqd_001"
		this.money_list = [2, 1, 0]
		this.destroy_imm = true

		let custom_activity_model = CustomActivityModel.GetInstance()
		let welfare_model = WelfareModel.GetInstance()
		let red_dot_mgr = RedDotManager.GetInstance()
		let local_ModuleType = ModuleType
		let local_GlobalEventSystem = GlobalEventSystem
		let UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE = EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE
		
		this.preload_server_config = {
			"config_checkin_key_value": false
		}
		this.window_open_back = () => {
			this.CheckOnlineRedDot()
			this.CheckDailyReddot()
			this.CheckDailySupplyRed()
			this.CheckGameNoticeRed()
		}

		this.viewClassList = [
			"DailySignView",
			"OnlineView",
			"DailySupplyView",
			"ExchangeGiftView",
			"GameNoticeView",
			"EyouAttentionView"
		]

		this.bg_list = [
			"dailySign_bg.jpg",
			"uizx_001_720x1222.jpg",
			null,
			"uigzhl_001_720x1222.jpg",
			"yxngg_720x1200.jpg",
			"ui_img_ptgz_001.jpg"
		]

		this.titleList = [
			"exchange.ui_title"
		]

		this.tabStrList = [
			{ label: "签到", icon_up_source: "dailySign_asset.uiqd_018", icon_down_source: "dailySign_asset.uiqd_017" },
			{ label: "在线奖励" },
			{ label: "每日补给" },
			{ label: "兑换礼包", open_lv: "50" },
			{ label: "游戏公告"},
			{ label: "Follow Rewards"}
		]

		this.tab_new_cond = {
			"0": () => {
				let cfg = this.preload_server_config["config_checkin_key_value"]//Config.Checkinkeyvalue
				let role_lv = RoleManager.GetInstance().GetMainRoleLevel()
				return role_lv >= cfg.checkin_open_lv.value
			},
			"1": () => {
				return welfare_model.GetOnlineData()
			},
			"2": () => {
				return custom_activity_model.GetActCondition(61, 1)
			}, 
			"3": () => {
				return !PlatformManager.GetInstance().is_alpha
			}, 
			"4": () => {
				let notice_list = LoginModel.GetInstance().GetInsideNoticeList()
				return notice_list && notice_list.length > 0	 				
			},
			"5": () => {
				return EyouManager.GetInstance().GetAttentionState() && !PlatformManager.GetInstance().is_alpha
			}
		}

		this.CheckOnlineRedDot = () => {
			let red = red_dot_mgr.CheckRedStatus(local_ModuleType.ONLINE, 1)
			local_GlobalEventSystem.Fire(UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "WelfareView", 1, red)
		}

		this.CheckDailyReddot = () => {
			let red = red_dot_mgr.CheckRedStatus(local_ModuleType.DAILY, 0)
			local_GlobalEventSystem.Fire(UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "WelfareView", 0, red)
		}

		this.CheckDailySupplyRed = () => {
			let red = custom_activity_model.GetRedDotValue(61, 1)
			local_GlobalEventSystem.Fire(UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "WelfareView", 2, red > 0)
		}

		this.CheckGameNoticeRed = () => {
			let red = LoginModel.GetInstance().GetNoticeRed()
			local_GlobalEventSystem.Fire(UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "WelfareView", 4, red)
		}

	}
}
window["WelfareView"] = WelfareView
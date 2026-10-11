import { CommonManager } from "../common/CommonManager"
import { Config } from "../common/Config"
import { EventName } from "../common/EventName"
import { ActivityIconManager } from "../commonModel/ActivityIconManager"
import { RoleManager } from "../commonModel/RoleManager"
import { LoginManager } from "../login/LoginManager"
import { PlatformManager } from "../PlatformManager"
import { ClientConfig, GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventDispatcher } from "../util/EventDispatcher"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { IsInTable, Util } from "../util/Util"

import "../eyou/EyouAttentionItem"
import "../eyou/EyouAttentionView"
import "../eyou/JumpToCommentView"
import { LoginModel } from "../login/LoginModel"
import { CookieWrapper } from "../common/CookieWrapper"

export class EyouManager extends EventDispatcher {
	static Instance: EyouManager
	static LvDataPlacementList = [
		258,
		295,
		328,
		367,
	]

	fb_state
	fb_icon_type
	cancel_account_icon_type
	init_fb
	init_fbicon

	platform_mgr: PlatformManager = PlatformManager.GetInstance()
	role_mgr: RoleManager = RoleManager.GetInstance()
	com_mgr: CommonManager = CommonManager.GetInstance()
	login_mgr: LoginManager = LoginManager.GetInstance()
	active_icon: ActivityIconManager = ActivityIconManager.GetInstance()

	public constructor() {
		super()
		if (EyouManager.Instance) {
			return
		}
		EyouManager.Instance = this

		this.init_fb = false
		this.fb_state = 0			// 0.无按钮/1:有特效/2:无特效
		this.init_fbicon = false
		this.fb_icon_type = 666
		this.cancel_account_icon_type = 777
		this.InitEvent()
	}

	public static GetInstance() {

		if (!EyouManager.Instance) {
			new EyouManager()
		}
		return EyouManager.Instance
	}

	public InitEvent() {
		GlobalEventSystem.Bind(EventName.GAME_START, () => {
			this.InitEyouInterface()
			this.InitCancelAccount()
		})

		this.role_mgr.GetMainRoleVo().Bind(EventName.CHANGE_LEVEL, (lv) => {
			this.RefreshFbState()
			this.RefreshGoToApp()
			
			this.UpdateLvDataPost(lv)
		})

		GlobalEventSystem.Bind(EventName.UPDATE_NEWEST_TASK_ID, (task_id) => {
			this.UpdateTaskDataPost(task_id)
		}
		)
	}


	public RefreshGoToApp(){
		let lv = RoleManager.GetInstance().GetMainRoleVo().level
		if (PlatformManager.IsEyouPlatform() && Util.IsConch() && ClientConfig.open_go_appstore == 1 && lv == ClientConfig.open_go_appstore_level && !this.platform_mgr.is_wx_alpha) {
			GlobalEventSystem.Fire(EventName.OPEN_VIEW, "JumpToCommentView")
		}
	}

	public InitEyouInterface() {
		if (this.init_fb) {
			return
		}
		this.init_fb = true
		if (PlatformManager.IsEyouPlatform()) {
			PlatformManager.GetInstance().IsShowFB()
		}
	}

	public RefreshFbState() {
		let icon_cfg = this.com_mgr.GetFunctionIconCfg(this.fb_icon_type)
		let main_role = this.role_mgr.GetMainRoleVo()
		if (!this.init_fbicon && icon_cfg && main_role.level >= icon_cfg.open_lv && this.fb_state != null) {
			this.init_fbicon = true
			if (this.fb_state == 2) {
				let icon = this.active_icon.getIconInfo(this.fb_icon_type)
				if (icon) {
					GlobalEventSystem.Fire(ActivityIconManager.UPDATE_EFFECT, this.fb_icon_type, "", false)
				}else{
					icon_cfg.effect_name = ""
					icon_cfg.effect_scale = 1
					this.active_icon.addIcon(this.fb_icon_type)
				}
			} else if (this.fb_state == 1) {
				let icon = this.active_icon.getIconInfo(this.fb_icon_type)
				if (icon) {
					GlobalEventSystem.Fire(ActivityIconManager.UPDATE_EFFECT, this.fb_icon_type, "ui_zhujiemianzhuanquan", true, true, null, 12.8)
				} else {
					icon_cfg.effect_name = "ui_zhujiemianzhuanquan"
					icon_cfg.effect_scale = 1.2
					this.active_icon.addIcon(this.fb_icon_type)
				}
			} else {
				this.active_icon.deleteIcon(this.fb_icon_type)
			}
		}
	}

	public SetFbState(state?) {
		this.fb_state = Number(state)
		this.init_fbicon = false
		this.RefreshFbState()
	}


	//是否开启英文平台关注页面
	public GetAttentionState = () => {
		let open = false
		let cfg = Config.PRELOAD_CLIENT_CONFIG.ConfigEyouAttention
		if (PlatformManager.IsEyouPlatform() && cfg) {
			if (PlatformManager.GetInstance().is_alpha) {
				open = false
			} else {
				if (cfg) {
					let role_lv = this.role_mgr.GetMainRoleLevel()
					if (cfg.close_lv == -1) {
						open = true
					} else if (cfg.open_lv <= role_lv && role_lv <= cfg.close_lv) {
						open = true
					} else {
						open = false
					}
				}
			}
		}
		// open = true

		return open
	}

	public FreeGift(base_type?, sub_type?){
		let cfg = Config.PRELOAD_SERVER_CONFIG.config_recharge_product
		if(!cfg) return

		let info_cond = CustomActivityModel.GetInstance().GetActCondition(base_type, sub_type, "info")
		if (info_cond && info_cond.recharge) {
			let product_info = cfg[Number(info_cond.recharge)]
			this.platform_mgr.FreePayRequest(product_info.money,
				{
					id: product_info.product_id,
					pay_title: product_info.product_name
				})
		}
	}

	public InitCancelAccount(){
		if(PlatformManager.IsEyouPlatform() && Util.IsIOSConch() && this.platform_mgr.is_wx_alpha){
			let icon = this.active_icon.getIconInfo(this.cancel_account_icon_type)
			if (!icon) {
				this.active_icon.addIcon(this.cancel_account_icon_type)
			}

		}else{
			this.active_icon.deleteIcon(this.cancel_account_icon_type)
		}
	}

	public UpdateLvDataPost(lv){
		if (IsInTable(lv, EyouManager.LvDataPlacementList)) {
			PlatformManager.GetInstance().EyouDataPlacement(`lv${lv}`);
		}
		
		//解锁结社系统
		let cfgs = Config.PRELOAD_CLIENT_CONFIG.ConfigFuncOpenCondition
		if(cfgs && cfgs['GuildJoinBaseView'] && cfgs['GuildJoinBaseView'].open_lv == lv){
			PlatformManager.GetInstance().EyouDataPlacement(`game_time_16`);
		}

		//到达70级打点
		if(lv == 70){
			PlatformManager.GetInstance().EyouDataPlacement("gamer_normal");
		}

		//到达140级打点
		if(lv == 140){
			PlatformManager.GetInstance().EyouDataPlacement("gamer_hard");
		}

		//开启一转任务
		if(lv == 150){
			PlatformManager.GetInstance().EyouDataPlacement("game_time_42");
		}

		
	}

	public UpdateTaskDataPost(task_id){

		//解锁神巫唤醒
		let cfgs = Config.PRELOAD_CLIENT_CONFIG.ConfigFuncOpenCondition
		if(cfgs && cfgs['PartnerAwakeMainView'] && cfgs['PartnerAwakeMainView'].open_task == task_id){
			PlatformManager.GetInstance().EyouDataPlacement(`game_time_19`);
		}

		//新形象解锁
		if(cfgs && cfgs['WingsComponentView'] && cfgs['WingsComponentView'].open_task == task_id){
			PlatformManager.GetInstance().EyouDataPlacement(`game_time_10`);
		}

		//首充活动
		let ConfigFirstRecharge = Config.PRELOAD_CLIENT_CONFIG.ConfigFirstRecharge
		if(ConfigFirstRecharge && ConfigFirstRecharge['new_tips_show_task_id'] && ConfigFirstRecharge['new_tips_show_task_id'][0] == task_id){
			PlatformManager.GetInstance().EyouDataPlacement(`game_time_6`);
		}

		//卡主线任务
		if(task_id == 101710){
			PlatformManager.GetInstance().EyouDataPlacement("game_time_47");
		}
	}

	//第一次聊天打点
	account_id_2_first_chat_flag
	public FirstChatDataPost(){
		let account_id = LoginModel.GetInstance().account_id
		if(!account_id) return
		if(!PlatformManager.IsEyouPlatform()) return

		if(this.account_id_2_first_chat_flag == null){
			let data = CookieWrapper.Instance.GetCookie(CookieWrapper.ACCOUNT_FIRST_CHAT, false)
			if (data) {
				this.account_id_2_first_chat_flag = JSON.parse(data)
			}
			else {
				this.account_id_2_first_chat_flag = {}
			}
		}

		
		if(this.account_id_2_first_chat_flag[account_id]){
			return
		}

		this.account_id_2_first_chat_flag[account_id] = true
		CookieWrapper.Instance.SaveCookie(CookieWrapper.ACCOUNT_FIRST_CHAT, JSON.stringify(this.account_id_2_first_chat_flag), false)
		PlatformManager.GetInstance().EyouDataPlacement("to_chat_with");
	}
}
window["EyouManager"] = EyouManager

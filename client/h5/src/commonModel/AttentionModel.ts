import { CommonManager } from "../common/CommonManager"
import { Config } from "../common/Config"
import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { PlatformManager } from "../PlatformManager"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { ClientConfig, GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventDispatcher } from "../util/EventDispatcher"
import { DEVICE_OS, Util } from "../util/Util"
import { ActivityIconManager } from "./ActivityIconManager"
import { CustomActivityDefine } from "./CustomActivityDefine"
import { CustomActivityModel } from "./CustomActivityModel"
import { RoleManager } from "./RoleManager"

export let AttentionEvent = {
	ATTENTION_OPEN_VIEW: "ATTENTION_OPEN_VIEW",
	ATTENTION_CLOSE_VIEW: "ATTENTION_CLOSE_VIEW",
	ATTENTION_REQUEST_CCMD_EVENT: "ATTENTION_REQUEST_CCMD_EVENT",
	ATTENTION_UPDATE_WXCOLLECTION: "ATTENTION_UPDATE_WXCOLLECTION",
	SDK_ATTENTION_RED_STATE:"SDK_ATTENTION_RED_STATE"
}

export class AttentionModel extends EventDispatcher {

	static Instance: AttentionModel
	static ActivityBaseType = 70
	static ActivitySubType = 1
	static SdkIconType = 113113
	static IconType = 113
	public static GetInstance() {
		if (!AttentionModel.Instance) {
			new AttentionModel()
		}
		return AttentionModel.Instance
	}

	platform_mgr = PlatformManager.GetInstance()
	custom_acitity_model = CustomActivityModel.GetInstance()
	activity_icon_mgr = ActivityIconManager.GetInstance()
	local_ServerTimeModel = ServerTimeModel.GetInstance()
	local_RoleManager = RoleManager.GetInstance()
	local_CommonManager = CommonManager.GetInstance()

	attention_cfg		//配置
	act_data
	info
	has_attention = false				//已关注
	has_show_dot = false

	/**
	 * 奖励状态
	 */
	activity_reward_state

	/**
	 * SDK 关注开启状态
	 */
	sdk_open_state
	/**
	 * SDK 关注状态
	 */
	sdk_attention_state = false
	/**
	 * SDK 关注红点状态
	 */
	sdk_attention_red_state = false


	public constructor() {
		super()

		if (AttentionModel.Instance) {
			return
		}
		AttentionModel.Instance = this
	}

	public CheckIconOpen() {
		let cfg = Config.PRELOAD_CLIENT_CONFIG.ClientAttention
		let plat_name = ClientConfig.plat_name
		let open = ClientConfig.attention_open
		let atten_cfg = cfg[plat_name]
		let sever_time = ServerTimeModel.GetInstance().GetOpenServerDay()
		let main_role = RoleManager.GetInstance().GetMainRoleLevel()
		if (!PlatformManager.GetInstance().is_alpha && (open && atten_cfg && atten_cfg.open_day <= sever_time && atten_cfg.open_lv <= main_role)) {
			ActivityIconManager.GetInstance().addIcon(AttentionModel.IconType)
		}
	}

	public UpdateSdkAttentionState() {
		if(this.activity_reward_state == null || this.sdk_open_state == null){
			return
		}
		if (!this.activity_reward_state && this.sdk_open_state){
			//当前活动奖励没领且sdk关注开启则显示图标
			let icon_info = this.activity_icon_mgr.getIconInfo(AttentionModel.SdkIconType)
			if(!icon_info){
				this.activity_icon_mgr.addIcon(AttentionModel.SdkIconType)
			}
		}
		else{
			let icon_info = this.activity_icon_mgr.getIconInfo(AttentionModel.SdkIconType)
			if(icon_info){
				this.activity_icon_mgr.deleteIcon(AttentionModel.SdkIconType)
			}
		}
	}

	public CheckSdkAttentionOpenState() {
		if(!this.SdkAttentionPlatNameCond()){
			return
		}
		//每个帐号只判断一次即可
		if(this.sdk_open_state == null){
			let sdk_name = PlatformManager.GetInstance().sdk_name
			if (window[sdk_name] && window[sdk_name].subscribe) {
				var params = { apiType: 'enabled' };
				window[sdk_name].subscribe(params, (data) => {
					this.sdk_open_state = data.cpStatus == 1
					if(this.sdk_open_state){
						this.CheckSdkAttentionState()
					}
					this.UpdateSdkAttentionState()
				});
			}
			else{
				this.sdk_open_state = false
			}
		}
	}

	public CheckSdkAttentionState() {
		if(!this.SdkAttentionPlatNameCond()){
			return
		}
		//检查关注状态
		let sdk_name = PlatformManager.GetInstance().sdk_name
		if (window[sdk_name] && window[sdk_name].subscribe) {
			var params = { apiType: 'isSubscribe' };
			window[sdk_name].subscribe(params, (data) => {
				console.log("------------CheckSdkAttentionState@subscribe@isSubscribe", data)
				this.sdk_attention_state = data.cpStatus == 1
				this.UpdateSdkAttentionRedState()
			});
		}
		else{
			this.sdk_attention_state = false
			this.UpdateSdkAttentionRedState()
		}
	}

	public UpdateSdkAttentionRedState(){
		let sdk_attention_red_state = this.sdk_attention_state && !this.activity_reward_state
		if(this.sdk_attention_red_state != sdk_attention_red_state){
			this.sdk_attention_red_state = sdk_attention_red_state
			this.Fire(AttentionEvent.SDK_ATTENTION_RED_STATE)
			GlobalEventSystem.Fire(EventName.REFRESH_ACTIVITY_ICON_RED_DOT, AttentionModel.SdkIconType)
		}
	}

	public GetSdkAttentionRedState(){
		return this.sdk_attention_red_state
	}

	public UpdateSdkAttentionActivityRewardState() {
		if(!this.SdkAttentionPlatNameCond()){
			return
		}
		let act_data = CustomActivityModel.GetInstance().GetActData(AttentionModel.ActivityBaseType, AttentionModel.ActivitySubType)
		if(act_data){
			//只使用第0个奖励
			let reward_data = CustomActivityModel.GetInstance().GetAwardDataById(AttentionModel.ActivityBaseType, AttentionModel.ActivitySubType, 1)
			if(reward_data){
				this.activity_reward_state = reward_data.status == 2
				if(this.activity_reward_state){
					AttentionModel.GetInstance().Fire(AttentionEvent.ATTENTION_CLOSE_VIEW, 'AttentionView');
				}
			}
			else{
				this.activity_reward_state = false
			}
			this.UpdateSdkAttentionState()
			this.UpdateSdkAttentionRedState()
		}
	}

	public SdkAttentionPlatNameCond(){
		return PlatformManager.IsAiFengGamePlatform() || Util.IsDebug()
	}

	public ResetData() {
		this.sdk_open_state = undefined
		this.activity_reward_state = undefined
		this.sdk_attention_state = false
		this.sdk_attention_red_state = false

		// 测试
		// this.sdk_open_state = true
		// this.activity_reward_state = false//
		// this.sdk_attention_state = true
		// this.sdk_attention_red_state = true

		let icon_info = this.activity_icon_mgr.getIconInfo(AttentionModel.SdkIconType)
		if(icon_info){
			this.activity_icon_mgr.deleteIcon(AttentionModel.SdkIconType)
		}
	}
}
import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { EventName } from "../common/EventName"
import { FriendModel } from "../commonModel/FriendModel"
import { MainUIModel } from "../commonModel/MainUIModel"
import { PlatformManager } from "../PlatformManager"
import { ClientConfig, GlobalEventSystem } from "../util/DeclareGlobalVar"
import "./CustomerServiceView"
import "./EmailView"
import "./FriendView"
import "./WXCustomerServiceView"

export class FriendEnterView extends BaseWindowComponent {
	_model
	bg_list
	tabStrList
	titleList
	viewClassList
	window_load_back
	my_default_index
	_Local_Open
	is_force = false //是否无视红点跳转
	public constructor() {
		super()

		this._model = FriendModel.GetInstance()
		this.dependent_res = ["friend"]
		this.destroy_imm = true
		this.my_default_index = 0

		if (PlatformManager.GetInstance().is_alpha 
			|| PlatformManager.IsEyouEnPlatform()
			|| ClientConfig.hide_customer_view
		) {
			this.tabStrList = [
				{ label: "好友", icon_up_source: "friend_asset.uisj_003_r1_c2", icon_down_source: "friend_asset.uisj_003_r1_c1" },
				{ label: "邮件", icon_up_source: "friend_asset.uisj_003_r2_c2", icon_down_source: "friend_asset.uisj_003_r2_c1" }]
			this.viewClassList = ["FriendView", "EmailView"]
			this.titleList = ["friend.uisj_001", "friend.uisj_001"]
			this.bg_list = ["ui_bg_1.jpg", "ui_bg_1.jpg"]
		} else {
			if(ClientConfig.is_open_custom_service == 1){
				this.tabStrList = [
					{ label: "好友", icon_up_source: "friend_asset.uisj_003_r1_c2", icon_down_source: "friend_asset.uisj_003_r1_c1" },
					{ label: "邮件", icon_up_source: "friend_asset.uisj_003_r2_c2", icon_down_source: "friend_asset.uisj_003_r2_c1" },
					{ label: "客服", icon_up_source: "friend_asset.uisj_003_r3_c2", icon_down_source: "friend_asset.uisj_003_r3_c1" }]
				this.titleList = ["friend.uisj_001", "friend.uisj_001", "friend.uisj_001"]
			}else {
				this.tabStrList = [
					{ label: "好友", icon_up_source: "friend_asset.uisj_003_r1_c2", icon_down_source: "friend_asset.uisj_003_r1_c1" },
					{ label: "邮件", icon_up_source: "friend_asset.uisj_003_r2_c2", icon_down_source: "friend_asset.uisj_003_r2_c1" }]
				this.titleList = ["friend.uisj_001", "friend.uisj_001"]
			}

			if (ClientConfig && ClientConfig.OpenSdkCustomer == 1) {
				this.viewClassList = ["FriendView", "EmailView", "WXCustomerServiceView"]
				this.bg_list = ["ui_bg_1.jpg", "ui_bg_1.jpg", "ui_friends_bg.jpg"]
			} else {
				this.viewClassList = ["FriendView", "EmailView", "CustomerServiceView"]
				this.bg_list = ["ui_bg_1.jpg", "ui_bg_1.jpg", "ui_friends_bg.jpg"]
			}
		}

		this.window_load_back = () => {
			this.emailRedDot()
			this.friendRedDot()
		}

		this.window_open_back = () => {
			if(!this.is_force){
				let email_red = FriendModel.GetInstance().GetemailRedDot()
				let friend_red = FriendModel.GetInstance().GetfriendRedDot()
				if (email_red && friend_red) {
					this.LocalSetDefaultIndex(0, true)
				} else if (!email_red && !friend_red) {
					this.LocalSetDefaultIndex(0, true)
				} else {
					let index = email_red ? 1 : 0;
					this.LocalSetDefaultIndex(index)
				}
			}
		}


		this._Local_Open = (parms?) => {
			if (parms && parms.length != 0) {
				let obj = parms[0]
				let index = obj&&obj.index||0
				let force = obj&&obj.force||0
				this.SetDefaultIndex(index,true)
				this.is_force=force==1?true:false
			}

		}

	}

	public emailRedDot() {

		GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "FriendEnterView", 1, FriendModel.GetInstance().GetemailRedDot())
		MainUIModel.GetInstance().Fire(MainUIModel.REFRESH_FRIEND_AND_MAIL_RED, 0, this._model.GetRed())
	}

	public friendRedDot() {

		GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "FriendEnterView", 0, FriendModel.GetInstance().GetfriendRedDot())
		MainUIModel.GetInstance().Fire(MainUIModel.REFRESH_FRIEND_AND_MAIL_RED, 1, this._model.GetRed())
	}
	public Open(...new_args): void {
		let parms = new_args
		this._Local_Open(parms)
		super.Open()
	}


}

window["FriendEnterView"] = FriendEnterView
import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { FriendInviteModel } from "../commonModel/FriendInviteModel"
import { RoleManager } from "../commonModel/RoleManager"
import { PlatformManager } from "../PlatformManager"
import { Message } from "../sysInfo/SysInfoController"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
import { FriendInviteWelfareItem } from "./FriendInviteWelfareItem"

export class FriendInviteWelfareView extends BaseView1 {
	_img_bg: Laya.Image
	_img_role: Laya.Image
	_img_title: Laya.Image
	_gp_get: Laya.Box
	_Image1: Laya.Image
	get_label: Laya.Label
	red_dot: Laya.Image
	_gp_hook: Laya.Box
	_Image2: Laya.Image
	_img_hook: Laya.Image
	_Label1: Laya.Label
	Content: Laya.List
	_img_close: Laya.Image
	_gp_show_effect: Laya.Box
	GetFunc
	Init
	InitEvent
	LoadSuccess
	StartTimeOut
	ClearTimeOut

	Scr_Scroller1
	ShareFun
	_list_reward_con
	loop_mgr

	public constructor() {
		super()


		this.base_file = "friendInvite"
		this.layout_file = "FriendInviteWelfareView"
		this.layer_value = Enum_UILayer.Activity
		this.change_scene_close = true
		this.use_background = true
		this.is_center = true
		this.append_to_ctl_queue = true
		this.destroy_imm = true
		this.show_open_movie = true
		let model = FriendInviteModel.GetInstance()
		let local_FriendInviteWelfareView = FriendInviteWelfareView
		let local_RoleManager = RoleManager.GetInstance()
		let local_PlatformManager = PlatformManager
		let local_FriendInviteModel = FriendInviteModel
		let local_Util = Util
		let local_Message = Message
		let hook_state_ = true,
			timer_out_
		
		this.not_show_main_msg = true
		this.load_callback = () => {
			this.Init()
		}
		this.preload_server_config = {
			"config_invite_reward": false
		}
		this.destroy_callback = () => {
			if (this.loop_mgr) {
				this.loop_mgr.DeleteMe()
				this.loop_mgr = null
			}
			this.ClearTimeOut()
		}
		this.Init = () => {
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("friendInvite", "uiqzyl_001"), true)
			this.InitEvent()
			this.LoadSuccess()
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._img_close, () => {
				this.Close()
			}
				, this, true)
			Util.AddClickEvent(this._gp_hook, () => {
				hook_state_ = !hook_state_
				this._img_hook.visible = hook_state_
			}
				, this, true)
			Util.AddClickEvent(this._gp_get, () => {
				this.GetFunc()
			}
				, this, true)
		}

		this.ShareFun = (not_fire?) => {
			let sdk_name = PlatformManager.GetInstance().sdk_name
			let role_id = local_RoleManager.mainRoleInfo.role_id
			if (window[sdk_name]) {
				if (local_Util.IsWXGame() || local_Util.IsQQGame()) {
					if (local_Util.IsWXGame() || local_Util.IsQQGame()) {
						let param_str = "invite_role_id=" + local_RoleManager.mainRoleInfo.role_id
						window[sdk_name].goShare(param_str)
					} else {
						window[sdk_name].goShare()
					}
				} else {
					if (local_PlatformManager.IsShenhaiPlatform()) {
						let params = { "apiType": "setShare", "shareParam": { "shareParams": { "cp_role_id": role_id } } }
						window[sdk_name].shareSdk(params, (data?) => {
							console.log("设置分享+++shareSdk+++++++++++++++:", data)
							if (data.cpStatus == 1) {
								if (!local_PlatformManager.IsBigMixedServer()) {
									//this:StartTimeOut(3, not_fire)
								}
							}
						}
						)
						window[sdk_name].setShareCallback((data?) => {
							console.log("设置分享+++setShareCallback++++++:", data)
							if (data.msg == "success") {
								local_Message.show("分享成功")
								this.StartTimeOut(0.1, not_fire)
							} else if (data.msg == "cancel") {
								local_Message.show("分享失败")
							}
						}
						)
					}
				}
			}
		}

		this.StartTimeOut = (time?, not_fire?) => {
			this.ClearTimeOut()
			timer_out_ = setTimeout(() => {
				if (!this.use_delete_method) {
					if (!not_fire) {
						model.TryTriggerShare()
					}
				}
			}
				, time)
		}

		this.ClearTimeOut = () => {
			if (timer_out_) {
				clearTimeout(timer_out_)
				timer_out_ = null
			}
		}

		this.GetFunc = () => {
			if (hook_state_) {

			}
			model.Fire(local_FriendInviteModel.SCMD_REQUEST, 34004, local_FriendInviteModel.welfare_type, 1)
			this.ShareFun()
		}

		this.LoadSuccess = () => {
			let key = local_FriendInviteModel.welfare_type + "@1"
			// [ts2lua]local_FriendInviteWelfareView.PRELOAD_SERVER_CONFIG.config_invite_reward下标访问可能不正确
			let cfg_ = ResManager.GetInstance().GetGameConfigFromCache(this, "config_invite_reward", false)
			let cfg = cfg_[key]
			if (cfg) {
				let reward_list = JSON.parse(cfg.reward)
				//reward_arr_:replaceAll(reward_list)
				this.loop_mgr = new LoopScrowViewMgr()
				this.loop_mgr.SetData(this.Content, FriendInviteWelfareItem, reward_list, LoopScrCon.Horizontal)
			}
			this._img_hook.visible = hook_state_
		}
	}



	public GetComponents() {
		[
			this._img_bg,
			this._img_role,
			this._img_title,
			this._gp_get,
			this._Image1,
			this.get_label,
			this.red_dot,
			this._gp_hook,
			this._Image2,
			this._img_hook,
			this._Label1,
			this.Content,
			this._img_close,
			this._gp_show_effect,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_img_role",
				"_img_title",
				"_gp_get",
				"_Image1",
				"get_label",
				"red_dot",
				"_gp_hook",
				"_Image2",
				"_img_hook",
				"_Label1",
				"Content",
				"_img_close",
				"_gp_show_effect",
			])
	}
}
window["FriendInviteWelfareView"] = FriendInviteWelfareView
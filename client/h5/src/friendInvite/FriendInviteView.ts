import { BaseView1 } from "../common/BaseView1"
import { EventName } from "../common/EventName"
import { InstructionType } from "../common/InstructionType"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { RewardPreView } from "../common/RewardPreView"
import { table } from "../common/table"
import { FriendInviteModel } from "../commonModel/FriendInviteModel"
import { RoleManager } from "../commonModel/RoleManager"
import { PlatformManager } from "../PlatformManager"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest, Util } from "../util/Util"
import { FriendInviteBoostView } from "./FriendInviteBoostView"
import { FriendInviteHelpView } from "./FriendInviteHelpView"
import { FriendInviteLevelUpView } from "./FriendInviteLevelUpView"
import { FriendInviteRecourseView } from "./FriendInviteRecourseView"
import { FriendInviteTabItem } from "./FriendInviteTabItem"

export class FriendInviteView extends BaseView1 {
	_img_bg: Laya.Image
	_img_close: Laya.Image
	_img_sub_bg: Laya.Image
	_lb_count: Laya.HTMLDivElement
	_lb_preview: Laya.Image
	_img_title: Laya.Image
	Content: Laya.List
	_gp_view_con: Laya.Box
	_gp_open: Laya.Box
	_Image1: Laya.Image
	_lb_open_desc: Laya.Label
	_img_red: Laya.Image
	_lb_count_down: Laya.HTMLDivElement
	
	ins: Laya.Image
	CancelTime
	ClearTimeOut
	Emp_gp_open
	Init
	InitEvent
	InitTab
	LoadSuccess
	OnTime
	Remove
	Scr_Scroller1
	ShareFun
	StartTime
	StartTimeOut
	SwitchTab
	UpdateBtnState
	UpdateTabRed
	UpdateView
	_list_tab_con
	loop_mgr

	public constructor() {
		super()

		this.base_file = "friendInvite"
		this.layout_file = "FriendInviteView"
		this.layer_value = Enum_UILayer.Activity
		this.change_scene_close = true
		this.use_background = true
		this.is_center = true
		this.append_to_ctl_queue = true
		this.click_bg_toClose = true
		this.destroy_imm = true
		this.show_open_movie = true
		let model = FriendInviteModel.GetInstance()
		let local_Util = Util
		let local_FriendInviteModel = FriendInviteModel
		let local_Message = Message
		let local_PlatformManager = PlatformManager
		let local_RoleManager = RoleManager.GetInstance()
		let tab_arr_ = null
		let default_index_ = 0
		let now_index_ = null
		let item_list_ = null
		let time_event_id_ = null
		let box_tab_list_ = model.IsShowAll() ? ["求助", "帮助", "升级", "助力"] : ["求助"]//(Util.IsWXGame() &&    || ["求助"])
		let tab_list_ = null
		let state_ = null
		let timer_out_ = null
		let _close_time_ = null
		this.not_show_main_msg = true
		this.load_callback = () => {

			this.Init()
			model.first_login = false
			model.SetRedDot(999, false)
		}
		this.preload_server_config = {
			"config_invite_lv_reward": false,
			"config_invite_reward": false,
			"config_invite_key_value": false,
			"config_invite_box_reward": false
		}

		this.destroy_callback = () => {
			this.Remove()
		}

		this.Init = () => {
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("friendInvite", "uiyqkbx_001"), true)
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_sub_bg, GameResPath.GetIcon("friendInvite", "uiyqkbx_007"), true)
			//ResManager.GetInstance().SetOutsideImageSprite(this, this._img_title, GameResPath.GetIcon("friendInvite", "uiyqkbx_010"), true)
			if (this.use_delete_method) {
				return
			}
			this.InitEvent()
			this.LoadSuccess()
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this.ins, () => {
				GlobalEventSystem.Fire(EventName.OPEN_INSTRUCTION_VIEW, InstructionType.FriendInvite)
			}, true)
			Util.AddClickEvent(this._img_close, () => {
				this.Close()
			}
				, this, true)

			this.BindEvent(model, local_FriendInviteModel.REFRESH_TAB_DOT, (type?, state?) => {
				this.UpdateTabRed(type, state)
			}
			)

			let info = null
			this.BindVar(model, "info", (event_type?, value?) => {
				info = value
				if (now_index_ < 3) {
					this.UpdateBtnState(true)
				}
			}
			)

			this.BindVar(model, "boost_info", (event_type?, value?) => {
				if (now_index_ == 3) {
					this.UpdateBtnState(false)
				}
			}
			)

			Util.AddClickEvent(this._lb_preview, () => {
				if (info) {
					let cfg_ = ResManager.GetInstance().GetGameConfigFromCache(this, "config_invite_key_value", false)
					let max_count = cfg_[3].value2
					let reward_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_invite_box_reward", false)
					let index = info.daily_count + 1
					let cfg = reward_cfg[index]
					if (!cfg) {
						cfg = reward_cfg[max_count]
					}
					if (cfg) {
						let view = new RewardPreView()
						view.Open(JSON.parse(cfg.reward))
					}
				}
			}
				, this, true)

			Util.AddClickEvent(this._gp_open, () => {
				if (now_index_ == 3) {
					let boost_info = model.GetBoostInfo()
					if (boost_info && boost_info.reward.length > 0) {
						model.Fire(local_FriendInviteModel.SCMD_REQUEST, 34009, local_FriendInviteModel.boost_lv_key)
					} else {
						this.ShareFun()
					}
				} else {
					if (info) {
						if (info.get_status == 0 || info.get_status == 1) {
							let cfg_ = ResManager.GetInstance().GetGameConfigFromCache(this, "config_invite_key_value", false)
							let max_count = cfg_[2].value
							if (info.daily_count >= max_count) {
								local_Message.show("今日领取次数已满")
								return
							}
							if (state_) {
								if (Util.IsDebug()) {
									model.TryTriggerShare()
								} else {
									this.ShareFun()
								}
							} else {
								local_Message.show("冷却中")
								this.ShareFun(true)
							}
						} else if (info.get_status == 2) {
							model.Fire(local_FriendInviteModel.SCMD_REQUEST, 34003)
						}
					}
				}
			}
				, this, true)
		}

		this.ShareFun = (not_fire?) => {
			let sdk_name = PlatformManager.GetInstance().sdk_name
			let role_id = local_RoleManager.mainRoleInfo.role_id
			if (window[sdk_name]) {
				if (local_Util.IsWXGame() || local_Util.IsQQGame()) {
					if (local_Util.IsWXGame() || local_Util.IsQQGame()) {
						console.log("小程序分享功能   " + " 分享者id" + local_RoleManager.mainRoleInfo.role_id)
						let param_str = "invite_role_id=" + local_RoleManager.mainRoleInfo.role_id
						window[sdk_name].goShare(param_str)
					} else {
						window[sdk_name].goShare()
					}
					this.StartTimeOut(3, not_fire)
				} else if (local_PlatformManager.IsShenhaiPlatform()) {
					 if (local_PlatformManager.IsBigMixedServer() || local_PlatformManager.IsAiFengGamePlatform() ) {
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
					} else {
						if (!not_fire) {
							model.TryTriggerShare()
						}
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

		this.LoadSuccess = () => {
			this.InitTab()
			if (this.loop_mgr) {
				this.loop_mgr.SetSelectIndex(default_index_)
			}
		}

		this.InitTab = () => {
			if (!tab_list_) {
				tab_list_ = []
			}
			for (let key in box_tab_list_) {

				let obj = box_tab_list_[key]
				table.insert(tab_list_, { "name": obj, "red_state": model.GetRedDotByType(key) })
			}
			this.loop_mgr = new LoopScrowViewMgr()
			this.loop_mgr.SetData(this.Content, FriendInviteTabItem, tab_list_, LoopScrCon.Horizontal, 1, (item?) => {
				this.SwitchTab(this.Content.selectedIndex)
			})
		}

		this.UpdateView = () => {
			if (!item_list_) {
				item_list_ = []
			}
			let item = item_list_[now_index_]
			if (!item) {
				if (now_index_ == 0) {
					item = new FriendInviteRecourseView(this._gp_view_con)
				} else if (now_index_ == 1) {
					item = new FriendInviteHelpView(this._gp_view_con)
				} else if (now_index_ == 2) {
					item = new FriendInviteLevelUpView(this._gp_view_con)
				} else if (now_index_ == 3) {
					item = new FriendInviteBoostView(this._gp_view_con)
				}
				item_list_[now_index_] = item
				item.Load()
			}
			this.PopUpChild(item)
		}

		this.SwitchTab = (index?) => {
			if (now_index_ == index) {
				return
			}
			if (index == 3) {
				this.UpdateBtnState(false)
			} else if (now_index_ == 3){
				this.UpdateBtnState(true)
			}
			//this.ins.visible = index != 3 ? true : false
			now_index_ = index
			this.UpdateView()
		}

		this.Remove = () => {
			if (this.loop_mgr) {
				this.loop_mgr.DeleteMe()
				this.loop_mgr = null
			}
			if (item_list_) {
				for (let _tmpi in item_list_) {
					var obj = item_list_[_tmpi]
					if (obj) {
						obj.DeleteMe()
					}
				}
				item_list_ = null
			}
			this.CancelTime()
			now_index_ = null
			tab_list_ = null
			this.ClearTimeOut()
		}

		this.UpdateTabRed = (type?, state?) => {
			if (tab_list_ && tab_list_[type]) {
				tab_list_[type].red_state = state
			}
			this.loop_mgr.replaceAll(tab_list_)
		}

		this.StartTime = (left_time?) => {
			this.CancelTime()
			_close_time_ = left_time
			time_event_id_ = GlobalTimerQuest.AddPeriodQuest(() => {
				this.OnTime()
			}, 1)
			this.OnTime()
		}

		this.OnTime = () => {
			let cfg_ = ResManager.GetInstance().GetGameConfigFromCache(this, "config_invite_key_value", false)
			let _time = cfg_[3].value
			let max_count = cfg_[4].value
			let left_time = _close_time_ - TimeUtil.getServerTime()
			state_ = left_time < (max_count - 1) * _time
			if (left_time < 0) {
				this._lb_count_down.innerHTML = ""
				return
			}
			this._lb_count_down.style.fontSize = 22
			this._lb_count_down.style.color = "#ff4f50"
			this._lb_count_down.style.align = "center"
			this._lb_count_down.style.wordWrap = false
			
			this._lb_count_down.innerHTML = Util.StrToHTML((state_ && "<font color='#81aa33'>" || "<font color='#fe5858'>") + TimeUtil.timeConvert8(left_time) + "后可开启</font>")
			let a:Laya.HBox = <Laya.HBox>this._lb_count_down.parent
			a.refresh()
		}

		this.CancelTime = () => {
			if (time_event_id_) {
				GlobalTimerQuest.CancelQuest(time_event_id_)
			}
		}

		this.UpdateBtnState = (bool?) => {
			this._lb_count.style.fontSize = 20
			this._lb_count.style.color = "#ffffff"
			this._lb_count.style.align = "center"
			this._lb_count.style.wordWrap = false
			if (bool) {
				this._lb_count_down.visible = true
				let info = model.GetInfo() 
				let cfg_ = ResManager.GetInstance().GetGameConfigFromCache(this, "config_invite_key_value", false)
				this._img_red.visible = info.get_status == 2
				let source = (info.get_status == 2 && "uiyqkbx_019a1" || "uiyqkbx_019")
				ResManager.GetInstance().SetImageSprite(this, this._Image1, "friendInvite_asset", source)
				let max_count = cfg_[2].value
				this._lb_count.innerHTML = "每天可开启宝箱<font color='#ffe08b'>（" + info.daily_count + "/" + max_count + "）</font>"
				let a = <Laya.HBox>this._lb_count.parent
				a.refresh()
				this.StartTime(info.recover_time)
			} else {
				this._lb_count_down.visible = false
				let boost_info = model.GetBoostInfo()
				let count = boost_info.reward.length > 0 && boost_info.reward[0].count || 0
				let source = ((count && count > 0) && "uiyqkbx_019a1" || "uiyqkbx_019")
				ResManager.GetInstance().SetImageSprite(this, this._Image1, "friendInvite_asset", source)
				this._img_red.visible = count && count > 0
			}
		}
	}



	public GetComponents() {
		[
			this._img_bg,
			this._img_close,
			this._img_sub_bg,
			this._lb_count,
			this._lb_preview,
			this._img_title,
			this.Content,
			this._gp_view_con,
			this._gp_open,
			this._Image1,
			this._lb_open_desc,
			this._img_red,
			this._lb_count_down,
			this.ins
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_img_close",
				"_img_sub_bg",
				"_lb_count",
				"_lb_preview",
				"_img_title",
				"Content",
				"_gp_view_con",
				"_gp_open",
				"_Image1",
				"_lb_open_desc",
				"_img_red",
				"_lb_count_down",
				"ins"
			])
	}
}
window["FriendInviteView"] = FriendInviteView
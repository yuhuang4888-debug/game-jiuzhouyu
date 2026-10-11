
//require("game.vip.VipModel")
//require("game.vip.RechargeItem")
//require("game.vip.RechargeView")
//require("game.vip.VipCardItem")
//require("game.vip.VipComponentTabButton")
//require("game.vip.VipInstructionItem")
//require("game.vip.VipInvalidView")

//require("game.vip.VipPrivilegeCardView")
//require("game.vip.VipPrivilegeShowView")
//require("game.vip.VipRuleItem")
//require("game.vip.VipRuleView")
//require("game.vip.VipTipsView")
//require("game.vip.VipView")
//require("game.vip.VipWeekGiftView")
//require("game.vipActive.VipActiveTab")
//require("game.vipActive.VipActiveView")
//require("game.vipActive.VipUpLevelItem")
//require("game.vipActive.VipUpLevelView")
//require("game.proto.150.Require150")
//require("game.proto.158.Require158")
//require("game.proto.159.Require159")
//require("game.proto.450.Require450")
import { BaseController } from "../common/BaseController"
import { ResManager } from "../common/ResManager"
import { VipModel } from "../commonModel/VipModel"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { RoleManager } from "../commonModel/RoleManager"
import { SceneManager } from "../scene/SceneManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventName } from "../common/EventName"
import { Message } from "../sysInfo/SysInfoController"
import { CookieWrapper } from "../common/CookieWrapper"
import { ActivityIconManager } from "../commonModel/ActivityIconManager"
import { PlatformManager } from "../PlatformManager"
import { Util } from "../util/Util"
import { TimeUtil } from "../util/TimeUtil"
import { SceneEventType } from "../common/EventName"
import { GlobalTimerQuest } from "../util/Util"
import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { ViewManager } from "../common/ViewManager"
import { table } from "../common/table"
import { Scene } from "../scene/Scene"
import { PartnerModel } from "../commonModel/PartnerModel"
import { ClientConfig } from "../util/DeclareGlobalVar"
import { Alert_Type } from "../alert/Alert"
import { Alert } from "../alert/Alert"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { TaskModel } from "../commonModel/TaskModel"
import "../vip/RechargeView"
import "../vip/VipView"
import "../vip/VipInvalidView"
import "../vip/VipPrivilegeCardView"
import "../vip/VipPrivilegeShowView"
import "../vip/VipRuleView"
import "../vip/VipWeekGiftView"
import "../vipActive/VipActiveView"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { TopVipModel } from "../commonModel/TopVipModel"
import { GameResPath } from "../util/GameResPath"
import { FirstRechargeModel } from "../commonModel/FirstRechargeModel"
export class VipController extends BaseController {
	active_back
	free_recive_timer
	is_first_list
	view_dic
	vip_tip_global_bind_id
	vip_tip_scene_bind_id
	vip_view


	public constructor() {
		super()


		this.active_back = true;
		this.is_first_list = [];
		this.view_dic = [];
		let resMgr = ResManager.GetInstance()
		let vipM = VipModel
		let vipmodel = vipM.GetInstance()
		let user_msger = UserMsgAdapter.GetInstance()
		let mainRoleVo = RoleManager.GetInstance().GetMainRoleVo()
		let sceneMgr = SceneManager.GetInstance()
		let local_glo = GlobalEventSystem
		let e_name = EventName
		let msg = Message
		let cookier = CookieWrapper
		let acIconMgr = ActivityIconManager.GetInstance()
		//	let mainui_controller = MainUIController.GetInstance()
		let platMgr = PlatformManager.GetInstance()
		let local_util = Util
		let local_time = TimeUtil
		let scene_e_type = SceneEventType

		let CancelFreeTimer = () => {

			if (this.free_recive_timer) {
				GlobalTimerQuest.CancelQuest(this.free_recive_timer)
			}
		}

		let CheckVipRed = (scmd?) => {
			let red = false
			// if (vipmodel.vipLevel > scmd.got_reward_list.length || scmd.can_reward_list.length > 0 ) {
			//专享礼包已改成付费，不影响红点显示
			if (scmd.can_reward_list.length > 0) {
				red = true
				vipmodel.Fire(vipM.UPDATE_VIP_TAB_RED, true, 1)
			} else {
				red = false
				vipmodel.Fire(vipM.UPDATE_VIP_TAB_RED, false, 1)
			}
			// [ts2lua]vipmodel.show_red_list下标访问可能不正确
			vipmodel.show_red_list[1] = red
			let card_red = false
			for (let _tmpi in scmd.use_card_list) {
				var vo = scmd.use_card_list[_tmpi]
				if (vo.time == 1) {
					red = true
					card_red = true
					break
				}
			}
			// [ts2lua]vipmodel.show_red_list下标访问可能不正确
			vipmodel.show_red_list[0] = card_red
			vipmodel.Fire(vipM.UPDATE_VIP_TAB_RED, card_red, 0)
			vipmodel.Fire(vipM.UPDATE_VIP_RED, red)
		}

		let StarFreeTimer = (end_time?) => {
			if (end_time - local_time.getServerTime() > 0) {
				CancelFreeTimer()
				this.free_recive_timer = setTimeout(() => {
					this.SendFmtToGame(45000)
				}
					, end_time - local_time.getServerTime())
			}
		}

		let CancelVipTipBind = () => {
			if (this.vip_tip_global_bind_id) {
				local_glo.UnBind(this.vip_tip_global_bind_id)
				this.vip_tip_global_bind_id = null
			}
			if (this.vip_tip_scene_bind_id) {
				local_glo.UnBind(this.vip_tip_scene_bind_id)
				this.vip_tip_scene_bind_id = null
			}
		}

		let CheckVipTipBind = () => {
			if ((!vipmodel.has_show_vip_tips && !platMgr.is_alpha) && !platMgr.need_alpha_open_charge) {
				let CheckCanOpenViewView = () => {
					if (sceneMgr.IsFieldScene() && Util.TableSize(BaseWindowComponent.CURR_OPEN_VIEW) == 0) {
						if (ViewManager.GetInstance().NoBackGroupViewInShow()) {
							vipmodel.Fire(vipM.OPEN_VIEW, "VipTipsView")
							vipmodel.has_show_vip_tips = true
							CancelVipTipBind()
						}
					}
				}

				CheckCanOpenViewView()
				if (!vipmodel.has_show_vip_tips) {
					if (!this.vip_tip_global_bind_id) {
						this.vip_tip_global_bind_id = local_glo.Bind(e_name.CLOSED_ONE_VIEW, CheckCanOpenViewView)
					}
					if (!this.vip_tip_scene_bind_id) {
						this.vip_tip_scene_bind_id = local_glo.Bind(scene_e_type.SCENE_CHANGED, CheckCanOpenViewView)
					}
				}
			}
		}

		let DeleteMe = () => {
			CancelFreeTimer()
			super.DeleteMe()
		}


		let On45000 = () => {
			let scmd = user_msger.GetSCMD(45000)
			let vip_level = mainRoleVo.vip_flag
			vipmodel.vipLevel = scmd.vip_lv
			if (vipmodel.vipLevel) {
				mainRoleVo.ChangeVar("vip_flag", vipmodel.vipLevel)
				mainRoleVo.ChangeVar("is_hide_vip", vipmodel.vip_hide,false,true)
			}
			vipmodel.cur_exp = scmd.vip_exp
			vipmodel.total_exp = scmd.need_exp
			vipmodel.vip_hide = scmd.vip_hide
			vipmodel.has_get_award = []
			for (let _tmpi in scmd.got_reward_list) {
				var vo = scmd.got_reward_list[_tmpi]
				// [ts2lua]vipmodel.has_get_award下标访问可能不正确
				vipmodel.has_get_award[vo.got_reward] = true
			}
			vipmodel.can_get_week_list = []


			if (scmd.can_reward_list.length > 0) {

				for (let i = scmd.can_reward_list.length - 1; i >= 0; i -= 1) {
					let vo = scmd.can_reward_list[i]
					if (vo.can_reward == 0) {
						table.remove(scmd.can_reward_list, i)
					} else {
						// [ts2lua]vipmodel.can_get_week_list下标访问可能不正确
						vipmodel.can_get_week_list[vo.can_reward] = true
					}
				}
			}
			vipmodel.can_receve_card_list = scmd.use_card_list
			if (vipmodel.can_receve_card_list.length > 0) {
				let end_time = null
				let allRecived = true
				vipmodel.free_data = null
				vipmodel.show_namebord = false
				for (let _tmpi in vipmodel.can_receve_card_list) {
					var vo = vipmodel.can_receve_card_list[_tmpi]
					if (vo.time != 2) {
						if (vo.use_card != 3) {
							vipmodel.free_data = vo
						}
						vipmodel.show_namebord = "mainUI_asset.uivip_0" + (vo.use_card + 47) + ""
						if (vo.time == 1) {
							if ((vo.use_card == 1 && !vipmodel.has_show_vip_tips) && vipmodel.vipLevel < 1) {
								// CheckVipTipBind()
							}
						} else {
							if (!end_time || vo.time < end_time) {
								end_time = vo.time
							}
						}
						allRecived = false
					} else {
						vipmodel.hasReceveCard = true
					}
				}
				if (end_time) {
					StarFreeTimer(end_time)
				} else {
					CancelFreeTimer()
				}
				if (allRecived) {
					// 暂时屏蔽，接vip需要放出来
					// local_glo:Fire(e_name.OPEN_MAINUI_VIP_TIP, false)
				} else if (sceneMgr.IsFieldScene()) {
					//暂时屏蔽，接vip需要放出来
					//local_glo:Fire(e_name.OPEN_MAINUI_VIP_TIP, true)
				}
			} else {
				vipmodel.show_namebord = false
				vipmodel.free_data = false
				CancelFreeTimer()
				local_glo.Fire(e_name.OPEN_MAINUI_VIP_TIP, false)
			}
			let role = Scene.GetInstance().GetMainRole()
			if (role && role.name_board) {
				//暂时屏蔽，接vip需要放出来
				//role.name_board.SetVipTipsData(vipmodel.show_namebord)
			}
			CheckVipRed(scmd)
			vipmodel.Fire(vipM.UPDATE_VIP_DATA)
			vipmodel.CheckVipIcon()
		}

		let On45001 = () => {
			let scmd = user_msger.GetSCMD(45001)
			if (scmd.res == 1) {
				msg.show("成功领取")
				this.SendFmtToGame(45000)
				vipmodel.Fire(vipM.SCMD_RECEIVE_EXCLUSIVE_GIFT, scmd)
			} else {
				Util.ErrorCodeShow(scmd.res)
			}
		}

		let On45002 = () => {
			let scmd = user_msger.GetSCMD(45002)
			if (scmd.res == 1) {
				msg.show("成功领取")
				this.SendFmtToGame(45000)
				ResManager.GetInstance().LoadGameConfig(this, "config_vip_config", false, undefined, (obj) => {
					let reward_list = vipmodel.GetRewards(vipmodel.vipLevel, obj)
					if (reward_list) {
						vipmodel.Fire(vipM.GET_WEEK_REWARD, reward_list.week_reward)
					}
				})
			}
		}

		let On45003 = () => {
			let scmd = user_msger.GetSCMD(45003)
			if (scmd.res == 1) {
				msg.show("购买成功")
				// cookier.GetInstance().RemoveCookie(cookier.VIP_INVALID_VIEW_SHOW_TIME, true)
				///cookier.GetInstance().RemoveCookie(CookieLevelType.Common, CookieKey.VIP_INVALID_VIEW_SHOW_TIME)
				local_glo.Fire(e_name.OPEN_VIP_VIEW, 1, mainRoleVo.vip_flag)
				vipmodel.CheckVipIcon()
			} else {
				Util.ErrorCodeShow(scmd.res)
			}
			this.active_back = true
		}

		let On45004 = () => {
			let scmd = user_msger.GetSCMD(45004)
			vipmodel.SaveNobleCardInfo(scmd.info)
			vipmodel.Fire(vipM.UPDATE_NOBLE_STATE)

			// for (let i = 0; i < scmd.info.length; i++) {
			//var v = scmd.info[i]
			// 	if (1 == v.is_temp_card && TimeUtil.getServerTime() < v.time ) {
			// 		CheckVipTipBind()
			// 		break
			// 	}
			// }
		}

		let On45005 = () => {
			let scmd = user_msger.GetSCMD(45005)
			if (1 == scmd.is_temp_card) {
				vipmodel.Fire(vipM.OPEN_VIEW, "VipTipsView")
			}
		}

		let On45006 = () => {
			let scmd = user_msger.GetSCMD(45006)
			// this.Fire(VipModel.OPEN_VIEW, "VipInvalidView")
			this.SendFmtToGame(45004)
		}

		let On45007 = () => {
			let scmd = user_msger.GetSCMD(45007)
			if (scmd.res != 1) {
				Util.ErrorCodeShow(scmd.res)
			} else {
				local_glo.Fire(e_name.OPEN_VIP_VIEW, 1, mainRoleVo.vip_flag)
			}
		}


		let On45008 = () => {
			let scmd = user_msger.GetSCMD(45008)
			mainRoleVo.ChangeVar("is_hide_vip",scmd.hide)
			vipmodel.vip_hide = scmd.hide
			// console.error("receive state : " + scmd.hide)
		}

		let On15800 = () => {
			let scmd = user_msger.GetSCMD(15800)
			vipmodel.SetRechargeProductList(scmd)
			vipM.GetInstance().Fire(vipM.ADD_RECHARGE_ICON)
		}

		let On15801 = () => {
			let scmd = user_msger.GetSCMD(15801)
			vipmodel.SetRechargeOneProduct(scmd)
			vipmodel.Fire(vipM.UPDATE_RECHARGE_VIEW, scmd)
			vipmodel.Fire(vipM.ADD_RECHARGE_ICON)
		}

		let On15802 = () => {
			msg.show("充值成功")
			vipmodel.Fire(vipM.UPDATE_RECHARGE_VIEW, null)
			CustomActivityModel.GetInstance().Fire(CustomActivityDefine.EVENT.RECHARGE_SUCCESS)
			//TopVipModel:GetInstance():Fire(TopVipEvent.TOP_VIP_REQUEST_PROTO, 15008, "i", TopVipMoneyId
		}

		let On15803 = () => {
			let scmd = user_msger.GetSCMD(15803)
			vipmodel.SetRechargeRecord(scmd.gold)
			PartnerModel.GetInstance().RefRed()
			vipmodel.Fire(vipM.UPDATE_ALL_RECHARGE)
		}

		let On15804 = () => {
			let scmd = user_msger.GetSCMD(15804)
			if (scmd.errcode != 1) {
				Util.ErrorCodeShow(scmd.errcode);
			}
			else
				vipmodel.Fire(vipM.USE_TOKEN_SUCCESS)
		}

		let On15901 = () => {
			let scmd = user_msger.GetSCMD(15901)
			vipmodel.Fire(vipM.UPDATE_RECHARGE_TYPETWO, scmd)
			let icon_type = null
			if (acIconMgr.getIconInfo("158@3")) {
				icon_type = "158@3"
			}
			if (acIconMgr.getIconInfo("158@0")) {
				icon_type = "158@0"
			}
			if (!icon_type) {
				return
			}
			for (let _tmpi in scmd.product_list) {
				var product = scmd.product_list[_tmpi]
				if (product.state == 1) {
					vipmodel.SetRechargeIconRed(true)
					local_glo.Fire(e_name.REFRESH_ACTIVITY_ICON_RED_DOT, icon_type, true)
					return
				}
			}
			vipmodel.SetRechargeIconRed(false)
			local_glo.Fire(e_name.REFRESH_ACTIVITY_ICON_RED_DOT, icon_type, false)
		}

		let On15902 = () => {
			let scmd = user_msger.GetSCMD(15902)
			if (scmd.errcode != 1) {
				Util.ErrorCodeShow(scmd.errcode)
				return
			}
			vipmodel.Fire(vipM.UPDATE_RECHARGE_TYPETWO, null)
		}



		this.RegisterProtocal(45000, On45000)
		this.RegisterProtocal(45001, On45001)
		this.RegisterProtocal(45002, On45002)
		this.RegisterProtocal(45003, On45003)
		this.RegisterProtocal(45004, On45004)
		this.RegisterProtocal(45005, On45005)
		this.RegisterProtocal(45006, On45006)
		this.RegisterProtocal(45007, On45007)
		this.RegisterProtocal(45008, On45008)
		this.RegisterProtocal(15800, On15800)
		this.RegisterProtocal(15801, On15801)
		this.RegisterProtocal(15802, On15802)
		this.RegisterProtocal(15803, On15803)
		this.RegisterProtocal(15804, On15804)
		this.RegisterProtocal(15901, On15901)
		this.RegisterProtocal(15902, On15902)
		vipmodel.Bind(vipM.REQUEST_PROTO, (id, fmt, ...new_args) => {
			this.SendFmtToGame(id, fmt, ...new_args)
		}
		)
		let OnOpenVipView = (index?, card_index?) => {
			if (PlatformManager.GetInstance().is_alpha) return
			// [ts2lua]window下标访问可能不正确
			if (!window["VipView"]) {
				// if (! resMgr.IsJsLoad("vip") ) {

				// }
			}
			// [ts2lua]window下标访问可能不正确
			let viewName = window["VipView"]
			if (!this.vip_view) {
				this.vip_view = new viewName()
			}
			if ((this.vip_view && index) && this.vip_view.HasOpen()) {
				this.vip_view.loop_scroll.SetSelectIndex(index)
				this.vip_view.SelectIndex(index, card_index)
			} else {
				if (card_index) {
					this.vip_view.Open(index, card_index)
				} else {
					if (RoleManager.GetInstance().GetMainRoleVo().vip_flag >= 4 && VipModel.GetInstance().GetNobleCardState() != 0) {
						this.vip_view.Open(1)
					} else {
						this.vip_view.Open(0)
					}
				}

			}
		}
		local_glo.Bind(e_name.OPEN_VIP_VIEW, OnOpenVipView)

		vipmodel.Bind(vipM.OPEN_VIEW, (view_name, ...new_args) => {
			if (PlatformManager.GetInstance().is_alpha) return
			if (view_name == "RechargeView") {
				let cant_jump_act = new_args[0]
				let is_first = FirstRechargeModel.GetInstance().IsDoneFirstRecharge()
				if(!is_first && !cant_jump_act){
					//120 超值礼包活动
					let act_info = CustomActivityModel.GetInstance().GetActInfoByType(120)
					if(act_info){
						GlobalEventSystem.Fire(EventName.OPEN_ACT_VIEW, `331@${act_info.base_type}@${act_info.show_id}`);
						return
					}
				}
				if (platMgr.is_alpha && !platMgr.need_alpha_open_charge) {
					return
				} else if (ClientConfig.close_charge) {
					Alert.Show(ClientConfig.close_charge, Alert_Type.One, null, null, "確定")
					return
				}
			}
			let view = this.view_dic[view_name]
			if (!view) {
				this.view_dic[view_name] = true
				if (this.view_dic[view_name] == true) {
					let view_class: any = window[view_name]
					view = new view_class()
					this.view_dic[view_name] = view
				}
			}
			if (view && view != true) {
				if (view.HasOpen()) {
					view.Close()
				} else {
					view.Open(...new_args)
				}
			}
		}
		)
		GlobalEventSystem.Bind(
			EventName.MAINUI_TOP_LOAD_SUCCEED, () => {
				this.SendFmtToGame(15800)
			}
		)
		let ResetData = () => {
			this.SendFmtToGame(45000)
			this.SendFmtToGame(45004)
			this.SendFmtToGame(15800)
			this.SendFmtToGame(15901)
			this.SendFmtToGame(15803)
		}
		local_glo.Bind(e_name.GAME_START, () => {
			ResetData()
			show_iwy_svip()
		}
		)
		GlobalEventSystem.Bind(ServerTimeModel.DAY_CHANGE, () => {
			ResetData()
		})

		let RequestVipReward = (reward_lv?) => {
			this.SendFmtToGame(45001, "h", reward_lv)
		}

		vipmodel.Bind(vipM.RECEIVE_EXCLUSIVE_GIFT, RequestVipReward)
		let RequestWeekReward = (level?) => {
			this.SendFmtToGame(45002, "h", level)
		}

		vipmodel.Bind(vipM.RECEIVE_WEEK_GIFT, RequestWeekReward)
		let RequestBuyVipCard = (type?) => {
			if (this.active_back) {
				this.SendFmtToGame(45003, "c", type)
				this.active_back = false
			}
		}

		vipmodel.Bind(vipM.BUY_VIP_CARD, RequestBuyVipCard)

		let RequestIsHideVipFlag = (state?) => {
			// console.error("send state: " + state)
			this.SendFmtToGame(45008, "c", state)
		}
		vipmodel.Bind(vipM.IS_HIDE_VIP_FLAG, RequestIsHideVipFlag)


		local_glo.Bind(e_name.UPDATE_IWY_SVIP_STATE, () => {
			show_iwy_svip()
		})

		let show_iwy_svip=()=>{
			let icon_type = "160" //爱微游 svip
			let data = platMgr.iwy_svip_data
			if(data&&data.status==1){
				if(!ActivityIconManager.GetInstance().getIconInfo(icon_type)){
					let icon_img = data.svip_icon?data.svip_icon:GameResPath.GetIcon("icon",icon_type)
					console.warn("test@iwy",data)
					ActivityIconManager.GetInstance().addIcon(icon_type, undefined, undefined, undefined,icon_img)
				}
			}else{
			
				if(ActivityIconManager.GetInstance().getIconInfo(icon_type)){
					ActivityIconManager.GetInstance().deleteIcon(icon_type)
				}
				
			}
		}



		let add_recharge_icon = () => {
			let icon_type = null
			let icon_0 = null
			let icon_1 = null
			let icon_3 = null
			let icon_4 = null
			icon_0 = "158@3"
			icon_1 = "158@0"
			if (vipmodel.HaveFirstRecharge()) {
				if (acIconMgr.getIconInfo(icon_1)) {
					acIconMgr.deleteIcon(icon_1)
				}
				if (!acIconMgr.getIconInfo(icon_0)) {
					acIconMgr.addIcon(icon_0)
				}
				icon_type = icon_0
			} else {
				if (acIconMgr.getIconInfo(icon_0)) {
					acIconMgr.deleteIcon(icon_0)
				}
				if (!acIconMgr.getIconInfo(icon_1)) {
					acIconMgr.addIcon(icon_1)
				}
				icon_type = icon_1
			}
			local_glo.Fire(e_name.REFRESH_ACTIVITY_ICON_RED_DOT, icon_type, vipmodel.GetRechargeIconRed())
		}

		vipmodel.Bind(vipM.ADD_RECHARGE_ICON, add_recharge_icon)
		//let SetMainUIVipView = () => {
		//if (sceneMgr.IsFieldScene() ) {
		//if (! mainui_controller.main_ui_vip_view ) {
		//local_glo:Fire(e_name.OPEN_MAINUI_VIP_TIP, true)
		//}
		//mainui_controller:SetMainUIViewVisible(7, true)
		//}else{
		//mainui_controller:SetMainUIViewVisible(7, false)
		//}
		//}

		//local_glo:Bind(scene_e_type.SCENE_CHANGED, SetMainUIVipView)
		let change_fun = () => {
			this.SendFmtToGame(15800)
			this.SendFmtToGame(45000)
		}

		local_glo.Bind(e_name.ALPHA_STATE_CHANGE, change_fun)


		GlobalEventSystem.Bind(EventName.UPDATE_NEWEST_TASK_ID, (task_id?) => {
			if (task_id == vipmodel.showNameBoardTaskId) {
				let role = Scene.GetInstance().GetMainRole()
				if (role) {
					role.UpdateDsgt()
				}
			}
		})


		mainRoleVo.Bind(EventName.CHANGE_LEVEL, (level?) => {
			vipmodel.CheckVipIcon()

			// 110级，主动弹一次
			let main_role = RoleManager.GetInstance().GetMainRoleVo()
			let my_level = main_role.level
			let vip_level = main_role.vip_flag
			if (my_level == 110 && (vip_level && vip_level < 4)) {
				// VipModel.GetInstance().Fire(VipModel.OPEN_VIEW, "VipActiveView", true)
			}
		}
		)
		vipmodel.initConfig()
	}
}

window["VipController"] = VipController
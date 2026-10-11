
//require("game.marriage2.BanBarrageView")
//require("game.marriage2.BanquetApplyView")
//require("game.marriage2.BanquetGoodsView")
//require("game.marriage2.BanquetInviteView")
//require("game.marriage2.BanquetModel")
//require("game.marriage2.BanquetNoticeView")
//require("game.marriage2.BanquetRewardView")
//require("game.marriage2.BanquetSceneView")
//require("game.marriage2.BuyInviteView")
//require("game.marriage2.ChoseBanquetView")
//require("game.marriage2.ApplyDateItem")
//require("game.marriage2.BanquetApplyItem")
//require("game.marriage2.WithBtnBanSlider")
//require("game.marriage2.guestApplyItem")
//require("game.marriage2.InvitedRenderer")
//require("game.marriage2.ApplyTabBtn")
//require("game.marriage2.BanquetAniManager")
//require("game.marriage2.BanquetGoodsItem") 

import { AutoFightManager } from "../autofight/AutoFightManager"
import { BaseController } from "../common/BaseController"
import { EventName, SceneEventType } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { BanqEvent, BanquetModel } from "../commonModel/BanquetModel"
import { MarriageModel } from "../commonModel/MarriageModel"
import { ActivityIconManager } from "../commonModel/ActivityIconManager"
import { BanquetAniManager } from "../marriage2/BanquetAniManager"
import { RoleManager } from "../commonModel/RoleManager"
import { SceneManager } from "../scene/SceneManager"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { TimeUtil } from "../util/TimeUtil"
import { Trim, Util } from "../util/Util"
import { MainUIController } from "./MainUIController"

import "../marriage2/ApplyDateItem"
import "../marriage2/ApplyTabBtn"
import "../marriage2/BanBarrageView"
import "../marriage2/BanquetAniManager"
import "../marriage2/BanquetApplyItem"
import "../marriage2/BanquetApplyView"
import "../marriage2/BanquetGoodsItem"
import "../marriage2/BanquetGoodsView"
import "../marriage2/BanquetInviteView"
import "../marriage2/BanquetNoticeView"
import "../marriage2/BanquetSceneView"
import "../marriage2/BarrageItem"
import "../marriage2/BuyInviteView"
import "../marriage2/ChoseBanquetView"
import "../marriage2/GuestApplyItem"
import "../marriage2/InvitedRenderer"
import "../marriage2/WithBtnBanSlider"
import { ViewPopLevelModel } from "../commonModel/ViewPopLevelModel"
import { Enum_UILayer, LayerManager } from "../common/LayerManager"

export class BanquetController extends BaseController {
	InitInfo
	time_id
	viewDic
	static Instance
	public constructor() {
		super()
		this.viewDic = [];
		this.InitInfo = () => {
			let banquetModel = BanquetModel.GetInstance()
			let local_BanqEvent = BanqEvent
			let user_msg_adapter = UserMsgAdapter.GetInstance()
			let local_GlobalEventSystem = GlobalEventSystem
			let local_EventName = EventName
			let local_TimeUtil = TimeUtil
			let local_Date = Date
			let activity_icon_mgr = ActivityIconManager.GetInstance()
			let mainUI_controller = MainUIController.GetInstance()
			let scene_mgr = SceneManager.GetInstance()
			let auto_fight = AutoFightManager.GetInstance()
			let On17250 = () => {
				let scmd = user_msg_adapter.GetSCMD(17250)
				if (scmd.code == 1) {
					banquetModel.SetApplyViewData(scmd)
					banquetModel.Fire(local_BanqEvent.APPLY_VIEW_DATA, scmd)
				} else if (scmd.code != 1720012) {
					Util.ErrorCodeShow(scmd.code)
				}
			}

			let On17251 = () => {
				let scmd = user_msg_adapter.GetSCMD(17251)
				if (scmd.code == 1 || scmd.code == 1720034) {
					this.SendFmtToGame(17249)
					this.SendFmtToGame(17250)
					GlobalEventSystem.Fire(EventName.OPEN_VIEW, "BanquetNoticeView", 2)
				} else {
					Util.ErrorCodeShow(scmd.code)
				}
			}

			let On17252 = () => {
				let scmd = user_msg_adapter.GetSCMD(17252)
				if (scmd.code != 1) {
					Util.ErrorCodeShow(scmd.code)
				} else {
					banquetModel.InviteViewData = scmd
					banquetModel.guestList = scmd.guest_list
					banquetModel.SetAskData(scmd.ask_invite_list)
					banquetModel.Fire(local_BanqEvent.INVITE_VIEW_DATA, scmd)
				}
			}

			let On17253 = () => {
				let scmd = user_msg_adapter.GetSCMD(17253)
				if (scmd.code == 1 || scmd.code == 1720033) {
					this.SendFmtToGame(17252)
				} else {
					Util.ErrorCodeShow(scmd.code)
				}
			}

			let On17254 = () => {
				let scmd = user_msg_adapter.GetSCMD(17254)
			}

			let On17256 = () => {
				let scmd = user_msg_adapter.GetSCMD(17256)
				banquetModel.SetBanquetCall(scmd)
			}

			let On17257 = () => {
				let scmd = user_msg_adapter.GetSCMD(17257)
				if (scmd.code != 1) {
					Util.ErrorCodeShow(scmd.code)
				} else {
					Message.show("索要成功")
				}
			}

			let On17258 = () => {
				let scmd = user_msg_adapter.GetSCMD(17258)
				if (scmd.code != 1) {
					Util.ErrorCodeShow(scmd.code)
				} else {
					Message.show("购买成功")
				}
			}

			let On17259 = () => {
				let scmd = user_msg_adapter.GetSCMD(17259)
				if (scmd.code == 1) {
					this.SendFmtToGame(17252)
					banquetModel.Fire(local_BanqEvent.BUY_MAX, scmd)
				} else if (scmd.code != 1720036) {
					Util.ErrorCodeShow(scmd.code)
				}
			}

			let On17260 = () => {
				let scmd = user_msg_adapter.GetSCMD(17260)
				if (scmd.code == 1) {
					banquetModel.lessInviteNum = scmd.less_invite_num
					for (let _tmpi in scmd.list) {
						var vo = scmd.list[_tmpi]
						if (vo.type == 1) {
							if (!banquetModel.AskData && vo.info_list.length > 0 || banquetModel.AskData && vo.info_list.length > banquetModel.AskData.length) {
								banquetModel.newApply = true
								banquetModel.ChangeVar("newApply", true, false, true)
								local_GlobalEventSystem.Fire(local_EventName.REFRESH_ACTIVITY_ICON_RED_DOT, "172@2", true)
							} else {
								banquetModel.ChangeVar("newApply", false, false, true)
								local_GlobalEventSystem.Fire(local_EventName.REFRESH_ACTIVITY_ICON_RED_DOT, "172@2", false)
							}
							banquetModel.AskData = vo.info_list
							banquetModel.Fire(local_BanqEvent.ASK_DATA, vo.info_list)
						} else if (vo.type == 2) {
							banquetModel.guestList = vo.info_list
							banquetModel.Fire(local_BanqEvent.INVITE_DATA, vo.info_list)
						}
					}
				} else {
					Util.ErrorCodeShow(scmd.code)
				}
			}

			let On17261 = () => {
				let scmd = user_msg_adapter.GetSCMD(17261)
				if (scmd.code != 1) {
					Util.ErrorCodeShow(scmd.code)
				}
				this.SendFmtToGame(17252)
			}

			let On17262 = () => {
				let scmd = user_msg_adapter.GetSCMD(17262)
				if (scmd.code == 1) {
					banquetModel.weddingRoleList = scmd
					banquetModel.Fire(local_BanqEvent.UPDATE_SCENE_SHOW)
				} else {
					Util.ErrorCodeShow(scmd.code)
				}
			}

			let On17263 = () => {
				let scmd = user_msg_adapter.GetSCMD(17263)
				if (scmd.code != 1) {
					Util.ErrorCodeShow(scmd.code)
				}
			}

			let On17264 = () => {
				let scmd = user_msg_adapter.GetSCMD(17264)
				if (scmd.code != 1) {
					Util.ErrorCodeShow(scmd.code)
				}
			}

			let On17265 = () => {
				let scmd = user_msg_adapter.GetSCMD(17265)
				if (scmd.code == 1) {
					banquetModel.BanquetData = scmd
					banquetModel.Fire(local_BanqEvent.BANQUET_INFO, scmd)
				} else {
					Util.ErrorCodeShow(scmd.code)
				}
			}

			let On17266 = () => {
				let scmd = user_msg_adapter.GetSCMD(17266)
				if (scmd.code != 1) {
					Util.ErrorCodeShow(scmd.code)
				} else {
					this.SendFmtToGame(17272)
				}
			}

			let On17267 = () => {
				let scmd = user_msg_adapter.GetSCMD(17267);
				let wedding_fires_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_wedding_fires", false);
				// banquetModel.GetGameConfig("Weddingfires", (wedding_fires_cfg?) => {
				if (wedding_fires_cfg) {
					let cfg = wedding_fires_cfg
					if (cfg) {
						// [ts2lua]cfg下标访问可能不正确
						let fire = cfg[scmd.fires_type]
						if (fire) {
							MarriageModel.GetInstance().PlayFlowerEffectByName(Trim(fire.charact))
						}
					}
					this.SendFmtToGame(17272)
					if (scmd.role_id == RoleManager.GetInstance().GetMainRoleId()) {
						Util.ErrorCodeShow(scmd.code, scmd.error_code_args)
					}
				}
				// }
				// , false)
			}

			let On17270 = () => {
				let scmd = user_msg_adapter.GetSCMD(17270)
				if (scmd.code == 1) {
					banquetModel.Fire(local_BanqEvent.BARRIAGE_SUCCESS)
				}
			}

			let On17271 = () => {
				let scmd = user_msg_adapter.GetSCMD(17271)
				if (scmd.type == 1) {
					this.SendFmtToGame(17272)
				}
				if (scmd.code != 1) {
					Util.ErrorCodeShow(scmd.code, scmd.error_code_args)
				} else {
					if (scmd.type == 1) {
						Message.show("获得喜宴")
					}
				}
			}

			let On17272 = () => {
				let scmd = user_msg_adapter.GetSCMD(17272)
				if (scmd.code == 1) {
					banquetModel.GoodsInfo = scmd
					banquetModel.Fire(local_BanqEvent.UPDATE_GOODS_INFO, scmd)
					banquetModel.UpdateDesk()
				} else {
					Util.ErrorCodeShow(scmd.code)
				}
			}

			let On17273 = () => {

			}

			let On17275 = () => {
				let scmd = user_msg_adapter.GetSCMD(17275)
				banquetModel.Fire(local_BanqEvent.EXP, scmd)
			}

			let On17276 = () => {
				let scmd = user_msg_adapter.GetSCMD(17276)
				this.SendFmtToGame(17249)
				this.SendFmtToGame(17250)
			}

			let On17277 = () => {
				let scmd = user_msg_adapter.GetSCMD(17277)
				for (let _tmpi in scmd.info_list) {
					var vo = scmd.info_list[_tmpi]
					if (1 == vo.type) {
						banquetModel.Fire(local_BanqEvent.AURA, vo.values)
					}
				}
			}

			let On17278 = () => {
				let scmd = user_msg_adapter.GetSCMD(17278)
				if (scmd) {
					for (let _tmpi in scmd.reward) {
						var vo = scmd.reward[_tmpi]
						vo[0] = vo.style
						vo[1] = vo.typeId
						vo[2] = vo.count
					}
					// [ts2lua]window下标访问可能不正确
					let view = window["BanquetRewardView"]
					if (view) {
						let rewardView = new view(scmd.reward, null, null, null, null, null, null, null, null, null, scmd.aura_num)
						rewardView.Open()
					}
				}
			}

			let On17279 = () => {
				let scmd = user_msg_adapter.GetSCMD(17279)
				Util.ShowCongratulationView(scmd.reward, 10)
			}

			let On17249 = () => {
				let scmd = user_msg_adapter.GetSCMD(17249)
				if (scmd.now_wedding_state == 2) {
					let nowDay = new local_Date(local_TimeUtil.getServerTime() * 1000)
					let startDay = new local_Date(scmd.begin_time * 1000)
					let str = null
					if (nowDay.getDate() != startDay.getDate()) {
						str = startDay.getMonth() + 1 + "月" + startDay.getDate() + "日"
					} else {
						str = local_TimeUtil.timeConversion(scmd.begin_time, "hh:MM") + "开始"
					}
					activity_icon_mgr.addIcon("172@2", null, null, str)
				} else if (banquetModel.banqState == 2 && scmd.now_wedding_state == 0) {
					activity_icon_mgr.deleteIcon("172@2")
				}
				banquetModel.banqState = scmd.now_wedding_state
			}



			let On17298 = () => {
				let scmd = user_msg_adapter.GetSCMD(17298)
				if (scmd.error_code == 1) {
					Message.show("一键邀请成功！")
					banquetModel.Fire(local_BanqEvent.REQUET_PROTO, 17252)
					banquetModel.Fire(local_BanqEvent.REQUET_PROTO, 17260, "hc", 1, 2)
				} else {
					Util.ErrorCodeShow(scmd.error_code)
				}
			}


			this.RegisterProtocal(17250, On17250)
			this.RegisterProtocal(17251, On17251)
			this.RegisterProtocal(17252, On17252)
			this.RegisterProtocal(17253, On17253)
			this.RegisterProtocal(17256, On17256)
			this.RegisterProtocal(17257, On17257)
			this.RegisterProtocal(17258, On17258)
			this.RegisterProtocal(17259, On17259)
			this.RegisterProtocal(17260, On17260)
			this.RegisterProtocal(17261, On17261)
			this.RegisterProtocal(17262, On17262)
			this.RegisterProtocal(17263, On17263)
			this.RegisterProtocal(17264, On17264)
			this.RegisterProtocal(17265, On17265)
			this.RegisterProtocal(17266, On17266)
			this.RegisterProtocal(17267, On17267)
			this.RegisterProtocal(17270, On17270)
			this.RegisterProtocal(17271, On17271)
			this.RegisterProtocal(17272, On17272)
			this.RegisterProtocal(17273, On17273)
			this.RegisterProtocal(17275, On17275)
			this.RegisterProtocal(17276, On17276)
			this.RegisterProtocal(17277, On17277)
			this.RegisterProtocal(17278, On17278)
			this.RegisterProtocal(17279, On17279)
			this.RegisterProtocal(17249, On17249)
			this.RegisterProtocal(17298, On17298)
			banquetModel.Bind(local_BanqEvent.REQUET_PROTO, (id, fmt, ...new_args) => {
				this.SendFmtToGame(id, fmt, ...new_args)
			}
			)
			// banquetModel.Bind(local_BanqEvent.OPEN_VIEW,(view_name, ...new_args) => {
			// 		// [ts2lua]this.viewDic下标访问可能不正确
			// 		let view = this.viewDic[view_name]
			// 		if (! view ) {
			// 			// [ts2lua]this.viewDic下标访问可能不正确
			// 			this.viewDic[view_name] = true
			// 			// [ts2lua]window下标访问可能不正确
			// 			if (! window[view_name] ) {
			// 				if (! ResManager.GetInstance().IsJsLoad("banquet") ) {

			// 				}
			// 			}
			// 			// [ts2lua]this.viewDic下标访问可能不正确
			// 			if (this.viewDic[view_name] == true ) {
			// 				// [ts2lua]window下标访问可能不正确
			// 				let view_class = window[view_name]
			// 				view =  new view_class()
			// 				// [ts2lua]this.viewDic下标访问可能不正确
			// 				this.viewDic[view_name] = view
			// 			}
			// 		}
			// 		if (view && view != true ) {
			// 			view.Open(...new_args)
			// 		}
			// 	}
			// )
			banquetModel.Bind(local_BanqEvent.CLOSE_VIEW, (view_name?) => {
				// [ts2lua]this.viewDic下标访问可能不正确
				let view = this.viewDic[view_name]
				if (view) {
					if (view != true && view.HasOpen()) {
						view.Close()
					}
					// [ts2lua]this.viewDic下标访问可能不正确
					this.viewDic[view_name] = null
				}
			}
			)
			banquetModel.Bind(local_BanqEvent.INVITE_GUEST, (roleId?) => {
				this.WriteBegin(17253)
				this.WriteFMT("h", 1)
				this.WriteFMT("l", roleId)
				this.SendToGame()
			}
			)
			banquetModel.Bind(local_BanqEvent.REQUET_ASK, (roleId?, type?) => {
				this.SendFmtToGame(17261, "hlc", 1, roleId, type)
			}
			)

			local_GlobalEventSystem.Bind(local_EventName.GAME_START, () => {
				banquetModel.InitCfg()
				activity_icon_mgr.deleteIcon("172@2")
				activity_icon_mgr.deleteIcon("172@1")
				this.SendFmtToGame(17249)
				this.SendFmtToGame(17256)
				this.SendFmtToGame(17250)
			}
			)
			let SetMainUIVisible = (bool?) => {
				mainUI_controller.SetMainUIViewVisible(10, bool)
				mainUI_controller.SetMainUIViewVisible(11, bool)
			}

			let scene_changed_func = () => {
				let last_scene_id = scene_mgr.GetLastSceneId()
				if (scene_mgr.IsWeddingScene()) {
					this.SendFmtToGame(17265)
					SetMainUIVisible(false)
					banquetModel.view_is_open = true
					GlobalEventSystem.Fire(EventName.OPEN_VIEW, "BanquetSceneView", true)
				} else if ((scene_mgr.IsWeddingScene(last_scene_id) && !scene_mgr.IsWeddingScene()) || banquetModel.view_is_open) {
					SetMainUIVisible(true)
					banquetModel.view_is_open = false
					GlobalEventSystem.Fire(EventName.CLOSE_VIEW, "BanquetSceneView")
					LayerManager.GetInstance().SetLayerVisible(Enum_UILayer.Main, "BanquetAniManager", null)
					LayerManager.GetInstance().SetLayerVisible(Enum_UILayer.UI, "BanquetAniManager", null)
					LayerManager.GetInstance().SetLayerVisible(Enum_UILayer.Activity, "BanquetAniManager", null)
					LayerManager.GetInstance().SetLayerVisible(Enum_UILayer.NameBoard, "BanquetAniManager", null)

					//将暂存的界面显示出来
					ViewPopLevelModel.GetInstance().NextPop()
				}
			}

			local_GlobalEventSystem.Bind(SceneEventType.SCENE_CHANGED, scene_changed_func)
			let complete_collect = (type_id?, ins_id?) => {
				if (banquetModel.IsTable(type_id)) {
					banquetModel.list_table_num[ins_id] = true
				}
				let info = banquetModel.BanquetData
				if (info) {
					if (type_id == 8002003) {
						info.less_normal_candies = info.less_normal_candies + 1
					} else if (type_id == 8002004) {
						info.less_special_candies = info.less_special_candies + 1
					}
				}
			}

			local_GlobalEventSystem.Bind(local_EventName.COMPLETE_TO_COLLECT, complete_collect)
			let anotherSelect = (flag?, type_id?, ins_id?) => {
				if (type_id == 8002003 || type_id == 8002004) {
					// [ts2lua]banquetModel.anotherPick下标访问可能不正确
					banquetModel.anotherPick[ins_id] = true
				}
			}

			local_GlobalEventSystem.Bind(local_EventName.BROADCAST_COLLECT_RESULT, anotherSelect)
			let collectTimer = () => {
				if (this.time_id) {
					clearTimeout(this.time_id)
					this.time_id = null
				}
				if (scene_mgr.IsWeddingScene()) {
					auto_fight.SetAutoFight(false)
					if (!BanquetAniManager.GetInstance().bool_update) {
						this.time_id = setTimeout(() => {
							auto_fight.SetAutoFight(true)
							if (this.time_id) {
								clearTimeout(this.time_id)
								this.time_id = null
							}
						}
							, 0.5)
					}
				}
			}

			local_GlobalEventSystem.Bind(SceneManager.START, collectTimer)
		}
		this.InitInfo()
	}

	public static GetInstance(): BanquetController {
		if (!BanquetController.Instance) {
			BanquetController.Instance = new BanquetController()
		}
		return BanquetController.Instance
	}
}
window["BanquetController"] = BanquetController
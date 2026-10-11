
//require("game.friendInvite.FriendInviteBoostView")
//require("game.friendInvite.FriendInviteHelpItem")
//require("game.friendInvite.FriendInviteHelpView")
//require("game.friendInvite.FriendInviteLevelUpView")
//require("game.friendInvite.FriendInviteModel")
//require("game.friendInvite.FriendInviteRecourseItem")
//require("game.friendInvite.FriendInviteRecourseView")
//require("game.friendInvite.FriendInviteRedItem")
//require("game.friendInvite.FriendInviteRedView")
//require("game.friendInvite.FriendInviteShareView")
//require("game.friendInvite.FriendInviteShopItem")
//require("game.friendInvite.FriendInviteShopView")
//require("game.friendInvite.FriendInviteTabItem")
//require("game.friendInvite.FriendInviteView")
//require("game.friendInvite.FriendInviteWelfareItem")
//require("game.friendInvite.FriendInviteWelfareView")
//require("game.proto.340.Require340")

import { BaseController } from "../common/BaseController"
import { CommonManager } from "../common/CommonManager"
import { CongratulationObtainView } from "../common/CongratulationObtainView"
import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { ActivityIconManager } from "../commonModel/ActivityIconManager"
import { FriendInviteModel } from "../commonModel/FriendInviteModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { RoleManager } from "../commonModel/RoleManager"
import { FriendInviteShopView } from "../friendInvite/FriendInviteShopView"
import { FriendInviteView } from "../friendInvite/FriendInviteView"
import { FriendInviteWelfareView } from "../friendInvite/FriendInviteWelfareView"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { Util } from "../util/Util"

//require("game.proto.113.Require113")
export class FriendInviteController extends BaseController {
	InitEvents
	static Instance
	public constructor() {
		super()

		let model = FriendInviteModel.GetInstance()
		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName
		let SCMD_REQUEST = FriendInviteModel.SCMD_REQUEST
		let local_FriendInviteModel = FriendInviteModel
		let activity_icon_mgr = ActivityIconManager.GetInstance()
		let common_mgr = CommonManager.GetInstance()
		let role_mgr = RoleManager.GetInstance()
		let server_time_model = ServerTimeModel.GetInstance()
		let user_msg_adapter = UserMsgAdapter.GetInstance()
		let friend_invite_view_ = null
		let friend_invite_shop_view_ = null
		let friend_invite_welfare_view_ = null
		let obtain_view_ = null
		this.InitEvents = () => {
			let init_fun = () => {
				model.Fire(SCMD_REQUEST, 34001)
				model.Fire(SCMD_REQUEST, 34012, local_FriendInviteModel.welfare_type)
				//if (Util.IsWXGame()) {
				model.Fire(SCMD_REQUEST, 34005)
				model.Fire(SCMD_REQUEST, 34006)
				model.Fire(SCMD_REQUEST, 34008, local_FriendInviteModel.boost_lv_key)
				//}
				let icon_info = activity_icon_mgr.getIconInfo(local_FriendInviteModel.ICON_TYPE)
				if (model.CheckIconOpenState()) {
					if (!icon_info) {
						icon_info = common_mgr.GetFunctionIconCfg(local_FriendInviteModel.ICON_TYPE)
						let player_lv = role_mgr.mainRoleInfo.level
						let open_day = server_time_model.GetOpenServerDay()
						if ((icon_info && player_lv >= icon_info.open_lv) && open_day >= icon_info.open_day) {
							activity_icon_mgr.addIcon(local_FriendInviteModel.ICON_TYPE, 0, icon_info)
						}
					}
				} else {
					if (icon_info) {
						activity_icon_mgr.deleteIcon(local_FriendInviteModel.ICON_TYPE)
					}
				}
				model.Fire(SCMD_REQUEST, 11301)
			}

			local_GlobalEventSystem.Bind(local_EventName.GAME_START, () => {
				init_fun()
			}
			)
			let LevelChange = () => {
				let icon_info = activity_icon_mgr.getIconInfo(local_FriendInviteModel.ICON_TYPE)
				if (model.CheckIconOpenState()) {
					if (!icon_info) {
						init_fun()
					}
				}
			}
			role_mgr.GetMainRoleVo().Bind(local_EventName.CHANGE_LEVEL, LevelChange)

			model.Bind(SCMD_REQUEST, (cmd, ...new_args) => {
				let args = new_args
				if (cmd == 34004) {
					this.SendFmtToGame(cmd, "cc", args[0], args[1])
				} else if (cmd == 34007) {
					this.SendFmtToGame(cmd, "hc", args[0], args[1])
				} else if (cmd == 34008 || cmd == 34009) {
					this.SendFmtToGame(cmd, "h", args[0])
				} else if (cmd == 34011) {
					this.SendFmtToGame(cmd, "h", args[0])
				} else if (cmd == 34012) {
					this.SendFmtToGame(cmd, "c", args[0])
				} else {
					this.SendFmtToGame(cmd)
				}
			}
			)

			model.Bind(local_FriendInviteModel.OPEN_FRIEND_INVITE_VIEW, () => {
				let info = model.GetRewardByType(local_FriendInviteModel.welfare_type)
				if (info && info[0]) {
					let vo = info[0]
					if (vo.status == 1 && vo.reward_id == 1) {
						if (!friend_invite_view_) {
							friend_invite_view_ = new FriendInviteView()
						}
						if (!friend_invite_view_.HasOpen()) {
							friend_invite_view_.Open()
						}
					} else {
						if (!friend_invite_welfare_view_) {
							friend_invite_welfare_view_ = new FriendInviteWelfareView()
						}
						if (!friend_invite_welfare_view_.HasOpen()) {
							friend_invite_welfare_view_.Open()
						}
					}
				}
			}
			)

			model.Bind(local_FriendInviteModel.OPEN_FRIEND_INVITE_SHOP_VIEW, (index?) => {
				if (!friend_invite_shop_view_) {
					friend_invite_shop_view_ = new FriendInviteShopView()
				}
				friend_invite_shop_view_.SetDefaultIndex(index)
				if (!friend_invite_shop_view_.HasOpen()) {
					friend_invite_shop_view_.Open()
				}
			}
			)

			let day_change = () => {
				model.Fire(SCMD_REQUEST, 11301)
			}
			local_GlobalEventSystem.Bind(ServerTimeModel.DAY_CHANGE, day_change)



			let On34000 = () => {
				let scmd = user_msg_adapter.GetSCMD(34000)
				Util.ErrorCodeShow(scmd.code, scmd.args)
			}

			let On34001 = () => {
				let scmd = user_msg_adapter.GetSCMD(34001)
				model.SetInfo(scmd)
			}

			let On34002 = () => {
				let scmd = user_msg_adapter.GetSCMD(34002)
				model.Fire(SCMD_REQUEST, 34001)
			}

			let On34005 = () => {
				let scmd = user_msg_adapter.GetSCMD(34005)
				model.SetHelpInfo(scmd)
			}

			let On34006 = () => {
				let scmd = user_msg_adapter.GetSCMD(34006)
				model.SetLevelUpInfo(scmd)
			}

			let On34008 = () => {
				let scmd = user_msg_adapter.GetSCMD(34008)
				model.SetBoostInfo(scmd)
			}

			let On34009 = () => {
				let scmd = user_msg_adapter.GetSCMD(34009)
				let view = new CongratulationObtainView(GoodsModel.RewardKeyToNumber(scmd.reward))
				view.Open()
				model.Fire(SCMD_REQUEST, 34008, local_FriendInviteModel.boost_lv_key)
			}

			let On34010 = () => {
				let scmd = user_msg_adapter.GetSCMD(34010)
				model.SetRedInfo(scmd)
			}

			let On34011 = () => {
				let scmd = user_msg_adapter.GetSCMD(34011)
				model.Fire(SCMD_REQUEST, 34010)
				Util.ShowCongratulationView(scmd.reward)
			}

			let On34012 = () => {
				let scmd = user_msg_adapter.GetSCMD(34012)
				model.SetRewardByType(scmd)
			}

			let On34003 = () => {
				let scmd = user_msg_adapter.GetSCMD(34003)
				ResManager.GetInstance().GetGameConfigWithAutoDestory("config_invite_box_reward", (_cfg) => {
					let cfg = _cfg[scmd.daily_count]
					if (cfg) {
						let view = new CongratulationObtainView(JSON.parse(cfg.reward))
						view.Open()
					}
					model.Fire(SCMD_REQUEST, 34001)
				}, false)

			}

			let On11301 = () => {
				let scmd = user_msg_adapter.GetSCMD(11301)
				model.UpdateShareTimes(scmd.count)
			}

			let On11302 = () => {
				let scmd = user_msg_adapter.GetSCMD(11302)
				console.log("11302 领取奖励////////-：", scmd.error_code)
				if (scmd.error_code == 1) {
					Message.show("分享奖励获取成功")
					model.Fire(local_FriendInviteModel.GET_WX_SHARE_REWARD_SUCCESS)
					if (model.wx_share_cfg && model.wx_share_cfg.share_reward) {
						if (model.wx_share_cfg.share_reward) {
							obtain_view_ = new CongratulationObtainView(model.wx_share_cfg.share_reward, 10)
							obtain_view_.Open()
						}
					}
				} else {
					Util.ErrorCodeShow(scmd.error_code)
				}
			}

			let On34004 = () => {
				let scmd = user_msg_adapter.GetSCMD(34004)
				ResManager.GetInstance().GetGameConfigWithAutoDestory("config_invite_reward", (_cfg) => {
					let cfg = _cfg[scmd.type + "@" + scmd.reward_id]
					if (cfg) {
						let view = new CongratulationObtainView(JSON.parse(cfg.reward))
						view.Open()
					}
					if (scmd.type == 1) {
						model.Fire(SCMD_REQUEST, 34001)
					} else if (scmd.type == 2) {
						model.Fire(SCMD_REQUEST, 34005)
					} else if (scmd.type == 3) {
						if (friend_invite_welfare_view_ && friend_invite_welfare_view_.HasOpen()) {
							friend_invite_welfare_view_.Close()
						}
						model.Fire(SCMD_REQUEST, 34012, local_FriendInviteModel.welfare_type)
					}
				}, false)

			}

			let On34007 = () => {
				let scmd = user_msg_adapter.GetSCMD(34007)
				if (scmd.lv == Number(local_FriendInviteModel.help_lv_key)) {
					model.Fire(SCMD_REQUEST, 34005)
				} else if (scmd.lv == Number(local_FriendInviteModel.level_lv_key)) {
					model.Fire(SCMD_REQUEST, 34006)
				}

				ResManager.GetInstance().GetGameConfigWithAutoDestory("config_invite_lv_reward", (_cfg) => {
					let reward_lv_cfg = _cfg
					for (let main_key in reward_lv_cfg) {
						var cfg = reward_lv_cfg[main_key]
						if (cfg.lv == String(scmd.lv) && cfg.min <= scmd.pos && cfg.max >= scmd.pos) {
							let view = new CongratulationObtainView(JSON.parse(cfg.reward))
							view.Open()
							break
						}
					}
				}, false)

			}

			this.RegisterProtocal(34000, On34000)
			this.RegisterProtocal(34001, On34001)
			this.RegisterProtocal(34002, On34002)
			this.RegisterProtocal(34003, On34003)
			this.RegisterProtocal(34004, On34004)
			this.RegisterProtocal(34005, On34005)
			this.RegisterProtocal(34006, On34006)
			this.RegisterProtocal(34007, On34007)
			this.RegisterProtocal(34008, On34008)
			this.RegisterProtocal(34009, On34009)
			this.RegisterProtocal(34010, On34010)
			this.RegisterProtocal(34011, On34011)
			this.RegisterProtocal(34012, On34012)
			this.RegisterProtocal(11301, On11301)
			this.RegisterProtocal(11302, On11302)
		}

		this.InitEvents()
	}

	public static GetInstance() {

		if (!FriendInviteController.Instance) {
			FriendInviteController.Instance = new FriendInviteController()
		}
		return FriendInviteController.Instance
	}
}

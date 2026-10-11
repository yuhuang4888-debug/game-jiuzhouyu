
//require("game.adventure.AdventureItem")
//require("game.adventure.AdventureMainView")
//require("game.adventure.AdventureShopItem")
//require("game.adventure.AdventureShopView")
//require("game.adventure.AdventureWindowView")
//require("game.adventure.AdventureModel")
//require("game.proto.427.Require427")

import { BaseController } from "../common/BaseController"
import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { AdventureModel } from "../commonModel/AdventureModel"
import { RoleManager } from "../commonModel/RoleManager"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { Util } from "../util/Util"
import "../adventure/AdventureWindowView"
import "../adventure/AdventureShopView"

export class AdventureController extends BaseController {
	InitEvent
	InitInfo
	public static Instance
	public constructor() {
		super()


		let model = AdventureModel.GetInstance()
		let local_AdventureModel = AdventureModel
		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName

		let role_mgr = RoleManager.GetInstance()
		let user_msg_adapter = UserMsgAdapter.GetInstance()
		let view_dic_ = []
		let check = null
		this.InitEvent = () => {
			let ref_func = () => {
				model.Fire(local_AdventureModel.REQUEST_SCMD, 42700)
				if (model.shop_data) {
					let ref_shop = () => {
						model.Fire(local_AdventureModel.REQUEST_SCMD, 42704)
					}

					setTimeout(ref_shop, model.outTime)
				}
			}

			local_GlobalEventSystem.Bind(ServerTimeModel.DAY_CHANGE, ref_func)
			local_GlobalEventSystem.Bind(local_EventName.INIT_CONFIG, () => {

			}
			)
			local_GlobalEventSystem.Bind(local_EventName.GAME_START, () => {
				check = null
				model.LoadCfg()
				model.Fire(local_AdventureModel.REQUEST_SCMD, 42700)
			}
			)
			model.Bind(local_AdventureModel.REQUEST_SCMD, (scmd, ...new_args) => {
				let args = new_args
				if (42702 == scmd) {
					this.SendFmtToGame(scmd, "c", args[0])
				} else if (42705 == scmd) {
					this.SendFmtToGame(scmd, "h", args[0])
				} else if (scmd) {
					this.SendFmtToGame(scmd)
				}
			}
			)
			let open_view = (view_name: string, ...new_args) => {
				let view = view_dic_[view_name]
				if (!view) {
					view_dic_[view_name] = true
					if (!window[view_name]) {
						if (!ResManager.GetInstance().IsJsLoad("treasureHunt")) {

						}
					}
					if (view_dic_[view_name] == true) {
						let view_class = window[view_name]
						view = new view_class()
						view_dic_[view_name] = view
					}
				}
				if (view) {
					view.Open(...new_args)
				}
			}

			model.Bind(local_AdventureModel.OPEN_VIEW, open_view)
			role_mgr.GetMainRoleVo().Bind("vip_flag", () => {
				model.Fire(local_AdventureModel.REQUEST_SCMD, 42701)
			}
			)

			role_mgr.GetMainRoleVo().Bind(local_EventName.CHANGE_LEVEL, () => {
				if ((!check && model.GetViewInfo()) && !model.CheckAdveOpenStatus(true)) {
					check = setTimeout(() => {
						ResManager.GetInstance().LoadGameConfig(this, "config_adventure_kv", false, undefined, (cfg?) => {
							model.SetTimeInfo(cfg)
							check = null
						})
					}
						, 1.5)
				}
			}
			)
		}

		this.InitInfo = () => {
			let On42700 = () => {
				let scmd = user_msg_adapter.GetSCMD(42700)
				ResManager.GetInstance().LoadGameConfig(this, "config_adventure_kv", false, undefined, (cfg?) => {
					model.SetTimeInfo(cfg, scmd)
				})
			}

			let On42701 = () => {
				let scmd = user_msg_adapter.GetSCMD(42701)
				model.SetViewInfo(scmd)
				model.Fire(local_AdventureModel.UPDATA_VIEW)
			}

			let On42702 = () => {
				let scmd = user_msg_adapter.GetSCMD(42702)
				if (scmd.errcode != 1) {
					model.is_request_42702 = false
					Util.ErrorCodeShow(scmd.errcode)
					return
				}
				let info = model.GetViewInfo()
				if (!info) {
					return
				}
				info.circle = scmd.circle
				info.location = scmd.location
				if (info.throw_times != null) {
					info.throw_times = info.throw_times + 1
				}
				model.SetViewInfo(info)
				model.Fire(local_AdventureModel.UPDATA_VIEW, scmd)
			}

			let On42703 = () => {
				let scmd = user_msg_adapter.GetSCMD(42703)
				if (scmd.errcode != 1) {
					Util.ErrorCodeShow(scmd.errcode)
					return
				} else {
					Message.show("重置成功")
				}
				let info = model.GetViewInfo()
				if (!info) {
					return
				}
				info.circle = scmd.circle
				info.location = scmd.location
				if (info.left_times != null) {
					info.left_times = info.left_times + 1
				}
				info.lucky_reward = []
				if(info.free_reset_times && info.free_reset_times > 0)
					--info.free_reset_times
				model.SetViewInfo(info)
				model.Fire(local_AdventureModel.UPDATA_VIEW, scmd)
			}

			let On42704 = () => {
				let scmd = user_msg_adapter.GetSCMD(42704)
				model.SetAdvShopData(scmd)
				model.Fire(local_AdventureModel.UPDATE_SHOPVIEW)
			}

			let On42705 = () => {
				let scmd = user_msg_adapter.GetSCMD(42705)
				if (scmd.errcode != 1) {
					Util.ErrorCodeShow(scmd.errcode)
					return
				}
				model.BuyShopData(scmd.id)
				model.Fire(local_AdventureModel.BUY_SUCCESS, scmd.id)
			}

			let On42706 = () => {
				let scmd = user_msg_adapter.GetSCMD(42706)
				if (scmd.errcode != 1) {
					Util.ErrorCodeShow(scmd.errcode)
					return
				}
				model.SetAdvShopData(scmd)
				model.Fire(local_AdventureModel.UPDATE_SHOPVIEW)
			}

			this.RegisterProtocal(42700, On42700)
			this.RegisterProtocal(42701, On42701)
			this.RegisterProtocal(42702, On42702)
			this.RegisterProtocal(42703, On42703)
			this.RegisterProtocal(42704, On42704)
			this.RegisterProtocal(42705, On42705)
			this.RegisterProtocal(42706, On42706)
		}

		this.InitInfo()
		this.InitEvent()
	}
	public static GetInstance() {
		if (!AdventureController.Instance) {
			AdventureController.Instance = new AdventureController()
		}
		return AdventureController.Instance
	}
}
window["AdventureController"] = AdventureController
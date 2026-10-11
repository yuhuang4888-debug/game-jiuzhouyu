
//require("game.limitLevelShop.LimitLevelShopModel")
//require("game.limitLevelShop.LimitLevelShopTabItem")
//require("game.limitLevelShop.LimitLevelShopReward")
//require("game.limitLevelShop.LimitLevelShopView")
//require("game.proto.612.Require612")

import { BaseController } from "../common/BaseController"
import { EventName } from "../common/EventName"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { LimitLevelShopModel } from "../commonModel/LimitLevelShopModel"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { Util } from "../util/Util"
import "../limitLevelShop/LimitLevelShopView"

//超值推荐（推送礼包）
//require("game.assistanceGift.AssistanceGiftView")

export class LimitLevelShopController extends BaseController {
	Init
	view_dic

	public constructor() {
		super()


		this.view_dic = []
		let _model = LimitLevelShopModel.GetInstance()
		let _global_event_system = GlobalEventSystem
		let local_EventName = EventName
		let local_LimitLevelShopModel = LimitLevelShopModel
		let user_msg_adapter = UserMsgAdapter.GetInstance()

		this.Init = () => {
			let ResetData = () => {
				_model.Fire(local_LimitLevelShopModel.SCMD_REQUEST, 61200)
			}

			_global_event_system.Bind(local_EventName.GAME_START, () => {
				_model.ReSetModel()
				ResetData()
			}
			)
			_global_event_system.Bind(ServerTimeModel.DAY_CHANGE, ResetData)

			_model.Bind(local_LimitLevelShopModel.SCMD_REQUEST, (cmd, ...new_args) => {
				let args = new_args
				if (cmd == 61201
					|| cmd == 61203) {
					this.SendFmtToGame(cmd, "hhh", args[0], args[1], args[2])
				} else {
					this.SendFmtToGame(cmd)
				}

			}
			)

			_model.Bind(local_LimitLevelShopModel.OPEN_VIEW, (...new_args) => {
				let parms = new_args
				if (parms) {
					let icon_type = parms[0]
					let [type, subtype] = _model.IconType2Type(icon_type)
					let data = _model.GetTypeData(type)
					let gift_data = _model.GetGiftData(type, subtype)
					if (!data || !gift_data) {
						Message.show("活动未开启")
						return
					}

					let view_name = type == 66 && "AssistanceGiftView" || "LimitLevelShopView"
					let view = this.view_dic[view_name]
					if (!view) {
						this.view_dic[view_name] = true

						if (this.view_dic[view_name] == true) {
							let view_class = window[view_name]
							view = new view_class()
							this.view_dic[view_name] = view
						}
					}

					if (view && view != true) {
						if (view.SetActInfo) {
							view.SetActInfo(icon_type, type)
						}
						if (!view.HasOpen()) {
							view.Open()
						}
					}
				}
			}
			)

			let On61200 = () => {
				let scmd = user_msg_adapter.GetSCMD(61200)
				_model.RefreshState(scmd)
				_model.SetGiftOpenTimes(scmd)
			}
			this.RegisterProtocal(61200, On61200)

			let On61201 = () => {
				let scmd = user_msg_adapter.GetSCMD(61201)
				if (scmd.code == 1) {
					let data = _model.GetTypeData(scmd.type)
					if (data) {
						for (let _tmpi in data.grade_state) {
							var vo = data.grade_state[_tmpi]
							if (vo.grade == scmd.grade) {
								vo.state = 1
								_model.Fire(local_LimitLevelShopModel.BUY_SUCCESS, scmd.type, scmd.subtype, scmd.grade)
								break
							}
						}
					}
				} else {
					Util.ErrorCodeShow(scmd.code)
				}
			}
			this.RegisterProtocal(61201, On61201)

			let On61203 = () => {
				let scmd = user_msg_adapter.GetSCMD(61203)
				_model.SetGiftData(scmd)
			}
			this.RegisterProtocal(61203, On61203)
		}

		this.Init()
	}
}
window["LimitLevelShopController"]=LimitLevelShopController
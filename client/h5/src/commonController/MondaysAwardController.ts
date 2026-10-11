
//require("game.proto.179.Require179")
//require("game.mondaysaward.MondaysAwardModel")
//require("game.mondaysaward.MondaysAwardChnageItem")
//require("game.mondaysaward.MondaysAwardChnageRewardItem")
//require("game.mondaysaward.MondaysAwardChnageTab")
//require("game.mondaysaward.MondaysAwardChnageView")
//require("game.mondaysaward.MondaysAwardEntView")
//require("game.mondaysaward.MondaysAwardRecordItem")
//require("game.mondaysaward.MondaysAwardTaskItem")
//require("game.mondaysaward.MondaysAwardView")

import { BaseController } from "../common/BaseController"
import { EventName } from "../common/EventName"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { GoodsModel } from "../commonModel/GoodsModel"
import { MondaysAwardEvent, MondaysAwardModel } from "../commonModel/MondaysAwardModel"
import { ActivityIconManager } from "../commonModel/ActivityIconManager"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { Util } from "../util/Util"
import  "../mondaysaward/MondaysAwardEntView"


export class MondaysAwardController extends BaseController {
	InitInfo
	_first
	view_dic

	public constructor() {
		super()


		this.view_dic = []
		this._first = true
		let _model = MondaysAwardModel.GetInstance()
		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName
		let activity_icon_mgr = ActivityIconManager.GetInstance()
		let local_MondaysAwardEvent = MondaysAwardEvent
		let user_msg_adapter = UserMsgAdapter.GetInstance()

		this.InitInfo = () => {

			GlobalEventSystem.Bind(ServerTimeModel.DAY_CHANGE, () => {
				this.SendFmtToGame(17907)
			}
			)
			local_GlobalEventSystem.Bind(local_EventName.GAME_START, () => {
				this._first = true
				this.SendFmtToGame(17904)
			}
			)
			_model.Bind(local_MondaysAwardEvent.UPDATE_RED_DOT, () => {
				if (activity_icon_mgr.getIconInfo(_model.icon_type) || activity_icon_mgr.getBoxIconInfo(_model.icon_type)) {
					local_GlobalEventSystem.Fire(local_EventName.REFRESH_ACTIVITY_ICON_RED_DOT, _model.icon_type, _model.showRedDot())
				}
			}
			)
			let UpdateTicketNum = (goods_list?) => {
				let icon = activity_icon_mgr.getIconInfo(_model.icon_type)
				for (let _tmpi in goods_list) {
					var good = goods_list[_tmpi]
					if (good.type_id == _model.goods_id) {
						_model.Fire(local_MondaysAwardEvent.UPDATE_RED_DOT)
						break
					}
				}
			}
			GoodsModel.GetInstance().Bind(GoodsModel.UPDATE_GOODS_NUM, UpdateTicketNum)

			_model.Bind(local_MondaysAwardEvent.REQUEST_PROTO, (cmd, fmt, ...new_args) => {
				let parms = new_args
				if (cmd == 17901) {
					this.WriteBegin(cmd)
					let showDic = parms[0]
					this.WriteFMT("h", Util.TableSize(showDic))
					for (let key in showDic) {

						let list = showDic[key]
						this.WriteFMT("h", key)
						this.WriteFMT("h", list.length)
						for (let _tmpi in list) {
							var id = list[_tmpi]
							this.WriteFMT("h", id)
						}
					}
					this.SendToGame()
				} else {
					this.SendFmtToGame(cmd, fmt, ...new_args)
				}

			}
			)
			_model.Bind(local_MondaysAwardEvent.OPEN_VIEW, (view_name: string, ...new_args) => {
				let view = this.view_dic[view_name]
				if (!view) {
					this.view_dic[view_name] = true
					if (this.view_dic[view_name] == true) {
						let view_class = window[view_name]
						view = new view_class()
						this.view_dic[view_name] = view
					}
				}
				if (view) {
					let open_day = ServerTimeModel.GetInstance().GetOpenServerDay()
					if(open_day <= 7){
						view.tabStrList = [{ label: "开服大奖" }]
						view.titleStr ="mondaysaward.ui_luck_title_2"
					}else{
						view.tabStrList = [{ label: "周一大奖" }]
						view.titleStr = "mondaysaward.ui_luck_title"
					}
					view.Open(...new_args)
				}
			}
			)
			_model.Bind(local_MondaysAwardEvent.ClOSE_VIEW, (view_name, ...new_args) => {
				let view = this.view_dic[view_name]
				if (view && view.HasOpen()) {
					view.Close()
				}
			}
			)

			let On17900 = () => {
				let scmd = user_msg_adapter.GetSCMD(17900)
				Util.ErrorCodeShow(scmd.code)
			}
			this.RegisterProtocal(17900, On17900)	//错误码

			let On17901 = () => {
				let scmd = user_msg_adapter.GetSCMD(17901)
				_model.setPoolReward(scmd)
			}
			this.RegisterProtocal(17901, On17901)	//更换奖池

			let On17902 = () => {
				let scmd = user_msg_adapter.GetSCMD(17902)
				_model.setRecordData(scmd)
			}
			this.RegisterProtocal(17902, On17902)	//个人抽奖记录

			let On17903 = () => {
				let scmd = user_msg_adapter.GetSCMD(17903)
				_model.setRewardReturn(scmd)
			}
			this.RegisterProtocal(17903, On17903)	//抽奖

			let On17904 = () => {
				let scmd = user_msg_adapter.GetSCMD(17904)
				_model.setTaskData(scmd)
				if (this._first) {
					this._first = false
					this.SendFmtToGame(17907)
				}
			}
			this.RegisterProtocal(17904, On17904)	//任务状态

			let On17905 = () => {
				let scmd = user_msg_adapter.GetSCMD(17905)
				_model.setKfRecordData(scmd)
			}
			this.RegisterProtocal(17905, On17905)	//跨服抽奖记录

			let On17906 = () => {
				let scmd = user_msg_adapter.GetSCMD(17906)
				if (scmd.code == 1) {
					_model.Fire(local_MondaysAwardEvent.GET_TASK_RETUEN)
					_model.Fire(local_MondaysAwardEvent.UPDATE_RED_DOT)
				}
			}
			this.RegisterProtocal(17906, On17906)	//领取任务奖励

			let On17907 = () => {
				let scmd = user_msg_adapter.GetSCMD(17907)
				_model.open = scmd.code == 1
				_model.draw_times = scmd.draw_times
				let icon = _model.icon_type
				// if (activity_icon_mgr.getIconInfo(icon)) {
				// 	local_GlobalEventSystem.Fire(ActivityIconManager.UPDATE_EFFECT, icon, "ui_function_glow", _model.open, true)
				// }
				_model.Fire(local_MondaysAwardEvent.UPDATE_RED_DOT)
				_model.Fire(local_MondaysAwardEvent.ACTIVITY_OPEN)
			}
			this.RegisterProtocal(17907, On17907)	//是否在抽奖期间

			let On17908 = () => {
				let scmd = user_msg_adapter.GetSCMD(17908)
				_model.setShowDic(scmd)
			}
			this.RegisterProtocal(17908, On17908)	//获取玩家奖池数据

		}

		this.InitInfo()
	}

}
window["MondaysAwardController"] = MondaysAwardController
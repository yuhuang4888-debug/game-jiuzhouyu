
//require("game.rank.RequireRank")
//require("game.proto.221.Require221")

import { BaseController } from "../common/BaseController"
import { EventName } from "../common/EventName"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { RankModel, RankModelEvent } from "../commonModel/RankModel"
import { RankEntView } from "../rank/RankEntView"
import { RankMenuView } from "../rank/RankMenuView"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { Util } from "../util/Util"
import "../rank/RankEntView"
import "../rank/RankView"
import "../rank/RankMenuView"

export class RankController extends BaseController {
	InitInfo
	menu_view
	rank_view

	public constructor() {
		super()

		let _model = RankModel.GetInstance()
		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName
		let local_RankModelEvent = RankModelEvent
		let user_msg_adapter = UserMsgAdapter.GetInstance()
		this.InitInfo = () => {
			let open_rank_view_byindex = (...new_args) => {
				let args = new_args
				if (!this.rank_view) {
					this.rank_view = new RankEntView()
				}
				this.rank_view.SetDefaultIndex(args[0])
				this.rank_view.SetIndexParameter(args[0], args[1])
				this.rank_view.SetBackId(args[2])
				this.rank_view.Open()
			}
			local_GlobalEventSystem.Bind(local_EventName.OPEN_RANK_VIEW, open_rank_view_byindex)

			let open_menu_view = (...new_args) => {
				let args = new_args
				if (!this.menu_view) {
					this.menu_view = new RankMenuView()
				}
				let role_Id = args[1]
				let alike = this.menu_view.role_id == role_Id
				if (this.menu_view.HasOpen() && alike) {
					this.menu_view.Close()
				} else {
					this.menu_view.SetData(args[0], args[1], args[2], args[3], args[4])
					this.menu_view.Open()
				}
			}
			_model.Bind(local_RankModelEvent.OPEN_MENU_VIEW, open_menu_view)

			//let game_start = () => {
			//_model:initConfig()
			//}

			//local_GlobalEventSystem:Bind(local_EventName.INIT_CONFIG, game_start)

			local_GlobalEventSystem.Bind(local_EventName.GAME_START, () => {
				_model.requestRankData(0)
			}
			)
			let request_rank_data = (...new_args) => {
				let args = new_args
				this.SendFmtToGame(22101, "iii", args[0], args[1], args[2])
			}
			_model.Bind(local_RankModelEvent.REQUEST_RANK_DATA, request_rank_data)

			let request_guild_rank_data = (...new_args) => {
				let args = new_args
				this.SendFmtToGame(22102, "iii", args[0], args[1], args[2])
			}
			_model.Bind(local_RankModelEvent.REQUEST_GUILD_RANK_DATA, request_guild_rank_data)

			let request_like_time = (...new_args) => {
				let args = new_args
				this.SendFmtToGame(22104, "l", args[0])
			}
			_model.Bind(local_RankModelEvent.LIKE, request_like_time)

			let On22100 = () => {
				let scmd = user_msg_adapter.GetSCMD(22100)
				Util.ErrorCodeShow(scmd.errcode)
			}
			this.RegisterProtocal(22100, On22100)

			let On22101 = () => {
				let scmd = user_msg_adapter.GetSCMD(22101)
				_model.setRankData(scmd)
			}
			this.RegisterProtocal(22101, On22101)

			let On22102 = () => {
				let scmd = user_msg_adapter.GetSCMD(22102)
				_model.setRankData(scmd)
			}
			this.RegisterProtocal(22102, On22102)

			let On22103 = () => {
				let scmd = user_msg_adapter.GetSCMD(22103)
				Util.ErrorCodeShow(scmd.errcode)
				_model.setLike(scmd.praise_num)
			}
			this.RegisterProtocal(22103, On22103)

			let On22104 = () => {
				let scmd = user_msg_adapter.GetSCMD(22104)
				if (scmd.errcode == 1) {
					Message.show("膜拜成功")
					_model.setLike(_model.likeTime() - 1)
					_model.playerLikeTime = scmd.praise_num
					_model.Fire(local_RankModelEvent.LIKE_INFO_UPDATE)
				} else {
					Util.ErrorCodeShow(scmd.errcode)
				}
			}
			this.RegisterProtocal(22104, On22104)
		}
		_model.initConfig()
		this.InitInfo()
	}
}

window["RankController"] = RankController
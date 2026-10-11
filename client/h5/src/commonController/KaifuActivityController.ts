
//require("game.kaifuactivity.KaifuActivityEntView")
//require("game.kaifuactivity.KaifuActivityModel")
//require("game.proto.420.Require420")
//require("game.proto.424.Require424")
//require("game.bookOfContract.RequireBookOfContract")
//require("game.invest.RequireInvest")
import { BaseController } from "../common/BaseController"
import { KaifuActivityModel } from "../commonModel/KaifuActivityModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventName } from "../common/EventName"
import { KaifuActivityModelEvent } from "../commonModel/KaifuActivityModel"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { investType } from "../commonModel/KaifuActivityModel"
import { ActivityIconManager } from "../commonModel/ActivityIconManager"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { KaifuActivityEntView } from "../kaifuactivity/KaifuActivityEntView"
import { Util } from "../util/Util"
import { KAIFUACTIVITY_CONFIG } from "../commonModel/KaifuActivityModel"
import { CongratulationObtainView } from "../common/CongratulationObtainView"
import { ErlangParser } from "../util/ErlangParser"
import { GoodsModel } from "../commonModel/GoodsModel"
import { TopInvestEntView } from "../invest/TopInvestEntView"

export class KaifuActivityController extends BaseController {
	InitInfo

	public constructor() {
		super()


		let _model = KaifuActivityModel.GetInstance()
		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName

		let local_KaifuActivityModelEvent = KaifuActivityModelEvent
		let user_msg_adapter = UserMsgAdapter.GetInstance()
		let local_investType = investType
		let activity_icon_mgr = ActivityIconManager.GetInstance()
		let _kaifuActivityView = null
		let _bookActivateView = null
		let success_view = null
		let lvinvest_menu = null
		let topInvest = null
		let activateList = []
		this.InitInfo = () => {
			local_GlobalEventSystem.Bind(local_EventName.GAME_START, () => {
				_model._InvestData = []
				//_model:initConfig()
				setTimeout(() => {
					this.SendFmtToGame(42004)
				}, 5000)

			}
			)
			local_GlobalEventSystem.Bind(ServerTimeModel.DAY_CHANGE, () => {
				this.SendFmtToGame(42004)
			}
			)

			let open_KaifuActivityview = (...new_args) => {
				let args = new_args
				let [viewClassList, tabStrList, bg_list] = _model.GetviewLabelLists()
				if (viewClassList.length <= 0) {
					return
				}
				if (!_kaifuActivityView) {
					_kaifuActivityView = new KaifuActivityEntView()
				}
				if (_kaifuActivityView.HasOpen()) {
					_kaifuActivityView.Close()
				}
				if (args[0] || args[0] == 0)
					_kaifuActivityView.SetDefaultIndex(args[0])
				_kaifuActivityView.setData(viewClassList, tabStrList, bg_list)
				_kaifuActivityView.Open()
			}
			_model.Bind(local_KaifuActivityModelEvent.OPEN_KAIFUACTIVITYVIEW, open_KaifuActivityview)

			//TaskModel:GetInstance():Bind(TaskModel.UPDATE_NEWEST_TASK_ID,() => {
			//_model:AddBookIcon()
			//})

			//GlobalEventSystem:Bind(ServerTimeModel.DAY_CHANGE,() => {
			//_model:AddBookIcon()
			//})



			let open_top_ivity_view = (...new_args) => {
				let args = new_args
				let [viewClassList, tabStrList, bg_list, index] = _model.InvestViewLists(args[0])
				if (!topInvest) {
					topInvest = new TopInvestEntView()
				}
				if (topInvest.HasOpen()) {
					topInvest.Close()
				}
				topInvest.SetDefaultIndex(index)
				topInvest.setData(viewClassList, tabStrList, bg_list)
				topInvest.Open()
			}
			_model.Bind(local_KaifuActivityModelEvent.OPEN_TOP_IVITY_VIEW, open_top_ivity_view)

			//let open_BookActivateView = (...new_args) => {
			//let args = new_args
			//if (! _bookActivateView ) {
			//_bookActivateView =  new BookOfContractActivateView()
			//}
			//if (args[1] ) {
			//_bookActivateView:setData(args[0], args[1])
			//}else{
			//_bookActivateView:setData(args[0])
			//}
			//_bookActivateView:Open()
			//}

			//_model:Bind(local_KaifuActivityModelEvent.OPEN_BOOKACTIVATEVIEW, open_BookActivateView)
			//let request_book_all_data = () => {
			//this:SendFmtToGame(42401)
			//}

			//_model:Bind(local_KaifuActivityModelEvent.REQUEST_BOOK_ALL_DATA, request_book_all_data)
			//let request_book_data = (...new_args) => {
			//let args = new_args
			//this:SendFmtToGame(42402, "c", args[0])
			//}

			//_model:Bind(local_KaifuActivityModelEvent.REQUEST_BOOK_DATA, request_book_data)
			//let request_book_get = (...new_args) => {
			//let args = new_args
			//this:SendFmtToGame(42404, "cc", args[0], args[1])
			//}

			//_model:Bind(local_KaifuActivityModelEvent.REQUEST_BOOK_GET, request_book_get)
			//let open_view = () => {
			//if (activateList.length > 0 ) {
			//open_BookActivateView(activateList[0])
			//table.remove(activateList,1)
			//}
			//}
			//local_GlobalEventSystem:Bind(local_EventName.CONGRATULATION_VIEW_CLOSE, open_view)

			let request_invest_data = (type?) => {
				this.SendFmtToGame(42001, "c", type)
			}
			_model.Bind(local_KaifuActivityModelEvent.REQUEST_INVEST_DATA, request_invest_data)

			let send_invest_level = (...new_args) => {
				let args = new_args
				this.SendFmtToGame(42002, "ch", args[0], args[1])
			}
			_model.Bind(local_KaifuActivityModelEvent.SEND_INVEST_LEVEL, send_invest_level)

			let get_invest = (...new_args) => {
				let args = new_args
				this.SendFmtToGame(42003, "cc", args[0], args[1])
			}
			_model.Bind(local_KaifuActivityModelEvent.GET_INVEST, get_invest)

			let On42000 = () => {
				let scmd = user_msg_adapter.GetSCMD(42000)
				Util.ErrorCodeShow(scmd.code, scmd.args)
			}
			this.RegisterProtocal(42000, On42000)

			let On42001 = () => {
				let scmd = user_msg_adapter.GetSCMD(42001)
				_model.setInvestData(scmd)
			}
			this.RegisterProtocal(42001, On42001)

			let On42002 = () => {
				let scmd = user_msg_adapter.GetSCMD(42002)
				_model.setInvestLevelData(scmd)
				if (scmd.type == local_investType.month) {
					let key = scmd.type + "@" + scmd.lv
					let cfg = _model.getConfig(KAIFUACTIVITY_CONFIG.INVESTMENT_TYPES)
					if (cfg && cfg[key]) {
						let cond = JSON.parse(cfg[key].condition)
						let reward = cond[0][1]
						success_view = new CongratulationObtainView(reward, 10)
						success_view.Open()
					}
				}
			}
			this.RegisterProtocal(42002, On42002)

			let On42003 = () => {
				let scmd = user_msg_adapter.GetSCMD(42003)
				if (scmd.type == local_investType.month) {
					_model.Fire(local_KaifuActivityModelEvent.REQUEST_INVEST_DATA, local_investType.month)
				} else {
					_model.setInvestRewardData(scmd)
				}
				let rewardsList = GoodsModel.RewardKeyToNumber(scmd.rewards)
				success_view = new CongratulationObtainView(rewardsList, 10)
				success_view.Open()
			}
			this.RegisterProtocal(42003, On42003)

			let On42004 = () => {
				let scmd = user_msg_adapter.GetSCMD(42004)
				_model.InvestOpen(scmd)
			}
			this.RegisterProtocal(42004, On42004)
			//let On42400 = () => {
			//let scmd = user_msg_adapter.GetSCMD(42400)
			//ErrorCodeShow(scmd.error_code)
			//}

			//this:RegisterProtocal(42400, On42400)
			//let On42401 = () => {
			//let scmd = user_msg_adapter.GetSCMD(42401)
			//_model:SetBookInfoData(scmd)
			//CustomActivityModel:GetInstance():CheckSpecialIcon("331@3")
			//}

			//this:RegisterProtocal(42401, On42401)
			//let On42402 = () => {
			//let scmd = user_msg_adapter.GetSCMD(42402)
			//_model:updateBookInfoData(scmd)
			//}

			//this:RegisterProtocal(42402, On42402)
			//let On42403 = () => {
			//let scmd = user_msg_adapter.GetSCMD(42403)
			//_model:setRequestData(scmd.list)
			//}

			//this:RegisterProtocal(42403, On42403)
			//let On42404 = () => {
			//let scmd = user_msg_adapter.GetSCMD(42404)
			//if (scmd.error_code == 1 ) {
			//_model:setBookInfoRewardData(scmd.chapter, scmd.stage)
			//let info = _model.BookOfContractItem(scmd.chapter, scmd.stage)
			//let reward_list = ErlangParser.GetInstance().Parse(info.reward)
			//success_view =  new CongratulationObtainView(reward_list, 10)
			//success_view:Open()
			//if (_model.finishAll() ) {
			//let icon = activity_icon_mgr.getIconInfo("424")
			//if (icon ) {
			//activity_icon_mgr:deleteIcon("424")
			//}
			//let icon2 = activity_icon_mgr.getIconInfo("424@1")
			//if (icon2 ) {
			//activity_icon_mgr:deleteIcon("424@1")
			//}
			//let icon3 = activity_icon_mgr.getIconInfo("424@2")
			//if (icon3 ) {
			//activity_icon_mgr:deleteIcon("424@2")
			//}
			//}
			//CustomActivityModel:GetInstance():CheckSpecialIcon("331@3")
			//CustomActivityModel:GetInstance():CheckSpecialIcon("331@3_1")
			//}else{
			//ErrorCodeShow(scmd.error_code)
			//}
			//}
			//this:RegisterProtocal(42404, On42404)

			//let On42405 = () => {
			//let scmd = user_msg_adapter.GetSCMD(42405)
			//_model:setBookOpen(scmd.chapter)
			//if (success_view && success_view.HasOpen() ) {
			//table.insert(activateList, scmd.chapter)
			//}else{
			//_model:Fire(local_KaifuActivityModelEvent.OPEN_BOOKACTIVATEVIEW, scmd.chapter)
			//}
			//_model:setBookRedDot()
			//_model:Fire(local_KaifuActivityModelEvent.UPDATE_BOOK_DATA)
			//}
			//this:RegisterProtocal(42405, On42405)


			//this:RegisterProtocal(42406,() => {
			//let scmd = user_msg_adapter.GetSCMD(42406)
			//_model:changeBookData(scmd)
			//})

		}
		_model.initConfig()
		this.InitInfo()
	}
}

window["KaifuActivityController"] = KaifuActivityController
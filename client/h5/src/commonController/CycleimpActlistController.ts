import { BaseController } from "../common/BaseController"
import { EventName } from "../common/EventName"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { CompeteListEvent, CompeteListModel } from "../commonModel/CompeteListModel"
import { CycleimpActlistEvent, CycleimpActlistModel } from "../commonModel/CycleimpActlistModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { LungDotSubType } from "../commonModel/LungModel"
import { CompetelistEnterView } from "../competelist/CompetelistEnterView"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import "../cycleimpActlist/CycleimpActlistView"
import "../cycleimpActlist/CycleimpActlistTipsView"
import "../cycleimpActlist/CycleimpActlistYesterday"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { RoleManager } from "../commonModel/RoleManager"

export class CycleimpActlistController extends BaseController {
	InitInfo
	enterviewDic
	view_dic

	public constructor() {
		super()


		this.view_dic = []
		this.enterviewDic = []

		this.InitInfo = () => {
			let model = CycleimpActlistModel.GetInstance()
			let user_msg_adapter = UserMsgAdapter.GetInstance()
			let local_CycleimpActlistEvent = CycleimpActlistEvent
			let local_GlobalEventSystem = GlobalEventSystem
			let local_EventName = EventName

			model.Bind(local_CycleimpActlistEvent.REQUEST_PROTO, (id, fmt, ...new_args) => {
				this.SendFmtToGame(id, fmt, ...new_args);
			});

			model.Bind(local_CycleimpActlistEvent.OPEN_VIEW, (view_name, ...new_args) => {
				let view = this.view_dic[view_name];
				if (!view) {
					this.view_dic[view_name] = true;
					if (this.view_dic[view_name] == true) {
						let view_class: any = window[view_name];
						view = new view_class();
						this.view_dic[view_name] = view;
					}
				}
				if (view) {
					view.Open(...new_args);
				}
			}
			)


			let On22700 = () => {
				let scmd = user_msg_adapter.GetSCMD(22700)
				model.SetActTime(scmd)
				if (scmd.type && scmd.subtype) {
					model.Fire(CycleimpActlistEvent.UPDATE_CYCLEIMPACTLIST_DATA)
					this.SendFmtToGame(22701, "hh", scmd.type, scmd.subtype)
					this.SendFmtToGame(22702, "hh", scmd.type, scmd.subtype)
					this.SendFmtToGame(22703)
					return
				}
				if (scmd.type == 0 || scmd.subtype == 0) {
					model.Fire(CycleimpActlistEvent.CLOSE_CYCLEIMPACTLIST)
					return
				}
				


			}

			let On22701 = () => {
				let scmd = user_msg_adapter.GetSCMD(22701)
				model.SetActData(scmd)
				model.Fire(CycleimpActlistEvent.UPDATE_CYCLEIMPACTLIST_VIEW)
				let red = model.CheckActData()
				CustomActivityModel.GetInstance().Fire(CustomActivityDefine.EVENT.UPDATE_TAB_RED, "331_cycle", red)
			}

			let On22702 = () => {
				let scmd = user_msg_adapter.GetSCMD(22702)
				model.SetRankList(scmd, true)
				model.Fire(CycleimpActlistEvent.UPDATE_CYCLEIMPACTLIST_VIEW)
				model.Fire(CycleimpActlistEvent.UPDATE_CYCLEIMPACTLIST_DATA)
			}

			let On22703 = () => {
				let scmd = user_msg_adapter.GetSCMD(22703)
				model.SetYesterdayInfo(scmd)
				model.Fire(CycleimpActlistEvent.UPDATE_CYCLEIMPACTLIST_VIEW)
				if (scmd.push_type == 1) {
					model.will_show_yesterday_tips = true
					this.SendFmtToGame(22703)
				} else {
					model.will_show_yesterday_tips = false
				}
				if ((model.will_show_yesterday_tips) || (model.is_first_show_yesterday_tips && CustomActivityModel.GetInstance().GetDayFirstLoginStatus())) {
					if (scmd.rank_list.length > 0) {
						model.will_show_yesterday_tips = false
						model.is_first_show_yesterday_tips = false
						if (RoleManager.GetInstance().GetMainRoleLevel() >= 150) {
							model.Fire(CycleimpActlistEvent.OPEN_VIEW, "CycleimpActlistYesterday")
						}
					}
				}
			}

			let On22704 = () => {
				let scmd = user_msg_adapter.GetSCMD(22704)
				if (scmd.error_code == 1) {
					model.Fire(local_CycleimpActlistEvent.GET_REWARD, scmd.reward_id)
					model.Fire(local_CycleimpActlistEvent.REQUEST_PROTO, 22701, "hh", scmd.type, scmd.subtype)
				}
			}

			let On22705 = () => {
				let scmd = user_msg_adapter.GetSCMD(22705)
				model.CheckIsShowTips(scmd)
			}

			let On22706 = () => {
				let scmd = user_msg_adapter.GetSCMD(22706)
				this.SendFmtToGame(22702, "hh", scmd.rank_type, scmd.rank_subtype)
			}

			this.RegisterProtocal(22700, On22700)
			this.RegisterProtocal(22701, On22701)
			this.RegisterProtocal(22702, On22702)
			this.RegisterProtocal(22703, On22703)
			this.RegisterProtocal(22704, On22704)
			this.RegisterProtocal(22705, On22705)
			this.RegisterProtocal(22706, On22706)

			let game_star = async () => {
				await model.InitConfig();
				this.SendFmtToGame(22700)
			}
			let day_change = async () => {
				await model.InitConfig();
			}
			local_GlobalEventSystem.Bind(local_EventName.GAME_START, game_star);
			local_GlobalEventSystem.Bind(ServerTimeModel.DAY_CHANGE, day_change);
			local_GlobalEventSystem.Bind(local_EventName.CHANGE_LEVEL, game_star);

			let change_fun = () => {
				game_star();
			}
			local_GlobalEventSystem.Bind(local_EventName.ALPHA_STATE_CHANGE, change_fun);
		}

		this.InitInfo();
	}
}

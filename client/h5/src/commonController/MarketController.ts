
import { BaseController } from "../common/BaseController"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { Message } from "../sysInfo/SysInfoController";
import { MarketEvent, MarketModel } from "../commonModel/MarketModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventName } from "../common/EventName"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Util } from "../util/Util"
import { table } from "../common/table";
import { GoodsModel } from "../commonModel/GoodsModel";
import { TimeUtil } from "../util/TimeUtil";
// import "../market/MarketAuctionAddView"
// import "../market/MarketAuctionCtrlView"
// import "../market/MarketAuctionItem"
// import "../market/MarketAuctionView"
import "../market/MarketBaseView"
import "../market/MarketBuyCtrlView"
import "../market/MarketBuyListView"
import "../market/MarketBuyView"
import "../market/MarketHSliderItem"
import "../market/MarketPlzCtrlView"
import "../market/MarketPlzGoodsItem"
import "../market/MarketPlzListView"
import "../market/MarketPlzShowItem"
import "../market/MarketPlzView"
// import "../market/MarketRecordAuctionItem"
// import "../market/MarketRecordAuctionView"
import "../market/MarketRecordDealView"
import "../market/MarketRecordItem"
// import "../market/MarketRecordRedItem"
// import "../market/MarketRecordRedView"
// import "../market/MarketRecordView"
import "../market/MarketSellCtrlView"
import "../market/MarketSellGoodsItem"
import "../market/MarketSellItem"
import "../market/MarketSellTipView"
import "../market/MarketSellView"
import "../market/MarketShowItem"
import "../market/MarketTypeBtn"
import "../market/Market1TypeItem"
import "../market/MarketBuyTypeItem"
import "../market/MarketRadioBtn"
import "../market/MarketCircleRadioBtn"
import "../market/MarketPlzTypeItem"
// import "../market/MarketAuctionGuildView"
// import "../market/MarketAuctionWorldView"
// import "../market/MarketAuctionSeaView"
// import "../market/AuctionModel"
export class MarketController extends BaseController {
	static Instance: any
	InitEvent
	InitInfo
	view_dic

	public constructor() {
		super()


		this.view_dic = [];
		let model = MarketModel.GetInstance()
		let local_MarketEvent = MarketEvent

		let user_msg_adapter = UserMsgAdapter.GetInstance()
		let local_Message = Message
		this.InitEvent = () => {
			model.Bind(local_MarketEvent.REQUEST_PROTO, (id, fmt, ...new_args) => {
				this.SendFmtToGame(id, fmt, ...new_args)
			}
			)
			model.Bind(local_MarketEvent.OPEN_VIEW, (view_name: string, ...new_args) => {
				// [ts2lua]this.view_dic下标访问可能不正确
				let view = this.view_dic[view_name]
				if (!view) {
					// [ts2lua]this.view_dic下标访问可能不正确
					this.view_dic[view_name] = true

					// [ts2lua]this.view_dic下标访问可能不正确
					if (this.view_dic[view_name] == true) {
						// [ts2lua]window下标访问可能不正确
						let view_class = window[view_name]
						view = new view_class()
						// [ts2lua]this.view_dic下标访问可能不正确
						this.view_dic[view_name] = view
					}
				}
				if (view && view != true) {
					view.Open(...new_args)
				}
			}
			)
			model.Bind(local_MarketEvent.CLOSE_VIEW, (view_name?) => {
				// [ts2lua]this.view_dic下标访问可能不正确
				let view = this.view_dic[view_name]
				if ((view && view != true) && view.HasOpen()) {
					view.Close()
					// [ts2lua]this.view_dic下标访问可能不正确
					this.view_dic[view_name] = null
				}
			}
			)
			GlobalEventSystem.Bind(EventName.GAME_START, () => {

				model.InitConfig()
				this.SendFmtToGame(15121)
			}
			)
			GlobalEventSystem.Bind(ServerTimeModel.DAY_CHANGE, () => {
				this.SendFmtToGame(15121)
			}
			)
			RoleManager.GetInstance().GetMainRoleVo().Bind(EventName.CHANGE_LEVEL, (level?) => {
				if (level == 150) {
					this.SendFmtToGame(15121)
				}
			}
			)
		}

		this.InitInfo = () => {
			let on15100 = () => {
				let scmd = user_msg_adapter.GetSCMD(15100)
				Util.ErrorCodeShow(scmd.errcode, scmd.args)
			}

			let on15101 = () => {
				let scmd = user_msg_adapter.GetSCMD(15101)
				for (let _tmpi in scmd.sell_list) {
					var info = scmd.sell_list[_tmpi]
					info.type = scmd.type
				}
				model.SetGoodsDic(scmd.type, scmd)
			}

			let on15102 = () => {
				let scmd = user_msg_adapter.GetSCMD(15102)
				for (let _tmpi in scmd.goods_list) {
					var info = scmd.goods_list[_tmpi]
					info.type = scmd.type
					info.subtype = scmd.subtype
				}
				table.sort(scmd.goods_list, (a?, b?) => {
					return b.id > a.id
				}
				)
				model.SetSellGoodsInfo(scmd.type, scmd.subtype, scmd)
			}

			let on15104 = () => {
				let scmd = user_msg_adapter.GetSCMD(15104)
			}

			let on15105 = () => {
				let scmd = user_msg_adapter.GetSCMD(15105)
			}

			let on15106 = () => {
				let scmd = user_msg_adapter.GetSCMD(15106)
				if (scmd.errcode == 1) {
					local_Message.show("上架成功")
					model.Fire(local_MarketEvent.CLOSE_VIEW, "MarketSellCtrlView")
					model.Fire(local_MarketEvent.REQUEST_PROTO, 15109)
					model.Fire(local_MarketEvent.UP_SHELF_SUCCESS)
				} else {
					Util.ErrorCodeShow(scmd.errcode)
					if (scmd.errcode == 1500001) {
						model.Fire(local_MarketEvent.NEED_UPDATE_BAG)
					}
				}
			}

			let on15108 = () => {
				let scmd = user_msg_adapter.GetSCMD(15108)
				if (scmd.errcode == 1) {
					local_Message.show("下架成功")
					model.Fire(local_MarketEvent.REQUEST_PROTO, 15109)
					model.Fire(local_MarketEvent.OUT_SHELF_SUCCESS)
				} else {
					Util.ErrorCodeShow(scmd.errcode)
				}
			}

			let on15109 = () => {
				let scmd = user_msg_adapter.GetSCMD(15109)
				let gmodel = GoodsModel.GetInstance()
				for (let _tmpi in scmd.goods_list) {
					var info = scmd.goods_list[_tmpi]
					gmodel.SetBaseInfo(info)
				}
				model.SetShelfGoodsInfo(scmd)
			}

			let on15111 = () => {
				let scmd = user_msg_adapter.GetSCMD(15111)
				if (scmd.errcode == 1) {
					local_Message.show("购买成功!请前往邮箱查收!")
					model.RemoveSellGoodInfo(scmd)
					model.Fire(local_MarketEvent.REQUEST_PROTO, 15114)
					model.Fire(local_MarketEvent.BUY_SUCCESS)
				} else {
					Util.ErrorCodeShow(scmd.errcode)
					if (scmd.errcode == 1510006) {
						model.RemoveSellGoodInfo(scmd)
					} else if (scmd.errcode == 1510014) {
						model.RemoveShelfGoodInfo(scmd)
					}
				}
			}

			let on15112 = () => {
				let scmd = user_msg_adapter.GetSCMD(15112)
				table.sort(scmd.record_list, (a?, b?) => {
					return b.time > a.time
				}
				)
				model.Fire(local_MarketEvent.UPDATE_RECORD, scmd)
			}

			let on15114 = () => {
				let scmd = user_msg_adapter.GetSCMD(15114)
				model.Fire(local_MarketEvent.UPDATE_BUY_TIMES, scmd)
			}

			let on15115 = () => {
				let scmd = user_msg_adapter.GetSCMD(15115)
				if (scmd.errcode == 1) {
					local_Message.show("发起求购成功")
					model.AddlzGoodInfoAll(scmd)
					model.AddlzGoodInfoMine(scmd)
				} else {
					Util.ErrorCodeShow(scmd.errcode)
				}
			}

			let on15116 = () => {
				let scmd = user_msg_adapter.GetSCMD(15116)
				if (scmd.errcode == 1) {
					local_Message.show("撤销求购成功")
					model.RemovePlzGoodInfoAll(scmd)
					model.RemovePlzGoodInfoMine(scmd)
				} else {
					Util.ErrorCodeShow(scmd.errcode)
					if (scmd.errcode == 1510023) {
						model.RemovePlzGoodInfoAll(scmd)
						model.RemovePlzGoodInfoMine(scmd)
					}
				}
			}

			let on15117 = () => {
				let scmd = user_msg_adapter.GetSCMD(15117)
				if (scmd.errcode == 1) {
					local_Message.show("出售成功")
					model.RemovePlzGoodInfoAll(scmd)
					model.Fire(local_MarketEvent.CLOSE_VIEW, "MarketSellTipView")
				} else {
					Util.ErrorCodeShow(scmd.errcode)
					if (scmd.errcode == 1510023) {
						model.RemovePlzGoodInfoAll(scmd)
						model.RemovePlzGoodInfoMine(scmd)
					}
				}
			}

			let on15118 = () => {
				let scmd = user_msg_adapter.GetSCMD(15118)
				model.Fire(local_MarketEvent.UPDATE_PLZ_ALL, scmd)
				model.SetSeekAllInfo(scmd)
			}

			let on15119 = () => {
				let scmd = user_msg_adapter.GetSCMD(15119)
				model.Fire(local_MarketEvent.UPDATE_PLZ_ONE, scmd)
				model.SetSeekMineInfo(scmd)
			}

			let on15120 = () => {
				let scmd = user_msg_adapter.GetSCMD(15120)
				if (scmd.sell_type == 1) {
					model.RemoveSellGoodInfo(scmd)
					model.RemoveShelfGoodInfo(scmd)
				} else if (scmd.sell_type == 3) {
					model.RemovePlzGoodInfoAll(scmd)
					model.RemovePlzGoodInfoMine(scmd)
				}
			}

			let on15121 = () => {
				let scmd = user_msg_adapter.GetSCMD(15121)
				model.kf_open_time = scmd.open_time
				let severTime = TimeUtil.getServerTime()
				model.kf_open = scmd.open_time > 0 && severTime > scmd.open_time
				model.showIcon(model.kf_open)
				//model.Fire(MarketEvent.UPDATE_ICON)

			}

			let on15122 = () => {
				let scmd = user_msg_adapter.GetSCMD(15122)
				if (scmd.errcode == 1) {

				}
				else
					Util.ErrorCodeShow(scmd.errcode)

			}

			this.RegisterProtocal(15100, on15100)
			this.RegisterProtocal(15101, on15101)
			this.RegisterProtocal(15102, on15102)
			this.RegisterProtocal(15104, on15104)
			this.RegisterProtocal(15105, on15105)
			this.RegisterProtocal(15106, on15106)
			this.RegisterProtocal(15108, on15108)
			this.RegisterProtocal(15109, on15109)
			this.RegisterProtocal(15111, on15111)
			this.RegisterProtocal(15112, on15112)
			this.RegisterProtocal(15114, on15114)
			this.RegisterProtocal(15115, on15115)
			this.RegisterProtocal(15116, on15116)
			this.RegisterProtocal(15117, on15117)
			this.RegisterProtocal(15118, on15118)
			this.RegisterProtocal(15119, on15119)
			this.RegisterProtocal(15120, on15120)
			this.RegisterProtocal(15121, on15121)
			this.RegisterProtocal(15122, on15122)
		}

		this.InitInfo()
		this.InitEvent()
	}

	public static GetInstance() {

		if (!MarketController.Instance) {
			MarketController.Instance = new MarketController()
		}
		return MarketController.Instance
	}
}


window["MarketController"] = MarketController
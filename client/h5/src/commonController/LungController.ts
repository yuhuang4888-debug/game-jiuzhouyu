import { BaseController } from "../common/BaseController"
import { CongratulationObtainView } from "../common/CongratulationObtainView"
import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { GoodsModel } from "../commonModel/GoodsModel"
import { LungEvent, LungModel } from "../commonModel/LungModel"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { PlayBigEffect, Util } from "../util/Util"

import "../lung/LungSelectView";
import "../lung/LungBagView";
import "../lung/LungStoveMainView";
import "../lung/LungResolveView";
import "../lung/LungSkillTipsView";
import "../lung/LungStoveRewardView";
import { MysteryShopType, ShopEvent, ShopModel } from "../commonModel/ShopModel"
import { TimeUtil } from "../util/TimeUtil"
import { RoleManager } from "../commonModel/RoleManager"

export class LungController extends BaseController {
	InitEvent
	RegisterAllProtocals

	public constructor() {
		super()


		let model: LungModel = LungModel.GetInstance()
		let user_msg_adapter = UserMsgAdapter.GetInstance()
		let local_Message = Message
		let goods_model = GoodsModel.GetInstance()
		let local_GoodsModel = GoodsModel
		let local_LungEvent = LungEvent
		let shop_model = ShopModel.GetInstance()
		let local_ShopEvent = ShopEvent
		let local_GlobalEventSystem = GlobalEventSystem
		let res_mgr = ResManager.GetInstance()

		let local_EventName = EventName
		let local_LungModel = LungModel
		let view_dic_ = []
		this.RegisterAllProtocals = () => {
			let Handler18100 = () => {
				let scmd = user_msg_adapter.GetSCMD(18100)
				model.SetLungData(scmd)
			}

			let Handler18101 = () => {
				let scmd = user_msg_adapter.GetSCMD(18101)
				if (scmd.error_code == 1) {
					let is_up_star = model.IsNeedUpStar(scmd.lv - 1, scmd.lv)
					if (is_up_star) {
						local_Message.show("突破成功")
					} else {
						local_Message.show("升级成功")
					}
					model.Fire(local_LungEvent.LUNG_UPGRADE_SUCCESS, is_up_star)
					goods_model.Fire(local_GoodsModel.FIGURE_ASK_LUNGEQUIP)
					model.Fire(local_LungEvent.LUNG_REQUEST_PROTO, 18100)
				} else {
					Util.ErrorCodeShow(scmd.error_code)
				}
			}

			let Handler18102 = () => {
				let scmd = user_msg_adapter.GetSCMD(18102)
				if (scmd.error_code == 1) {
					local_Message.show("穿戴成功")
					goods_model.Fire(local_GoodsModel.FIGURE_ASK_LUNGEQUIP)
					model.Fire(local_LungEvent.LUNG_CLICK_GRID_ITEM, scmd.cell_pos)
					model.Fire(local_LungEvent.LUNG_REQUEST_PROTO, 18100)
				} else {
					Util.ErrorCodeShow(scmd.error_code)
				}
			}

			let Handler18103 = () => {
				let scmd = user_msg_adapter.GetSCMD(18103)
				if (scmd.error_code == 1) {
					local_Message.show("卸下成功")
					model.Fire(local_LungEvent.LUNG_WEAR_OFF_SUCCESS, scmd.cell)
					model.Fire(local_LungEvent.LUNG_REQUEST_PROTO, 18100)
					goods_model.Fire(local_GoodsModel.FIGURE_ASK_LUNGEQUIP)
				} else {
					Util.ErrorCodeShow(scmd.error_code)
				}
			}

			let Handler18104 = () => {
				let scmd = user_msg_adapter.GetSCMD(18104)
				if (scmd.error_code == 1) {

					PlayBigEffect("ui_fenjietexiao")
					local_Message.show("分解成功")
					// model.ResolveSuccess(scmd.decompose_list)
				} else {
					Util.ErrorCodeShow(scmd.error_code)
				}
			}

			let Handler18105 = () => {
				let scmd = user_msg_adapter.GetSCMD(18105)
				// scmd.crucible_id = 1
				// scmd.start_time = TimeUtil.getServerTime() - 1000
				// scmd.end_time = TimeUtil.getServerTime() + 10000
				// scmd.count = 5
				// scmd.status_list = []
				// scmd.free_times = 1
				// scmd.next_free_time = TimeUtil.getServerTime() + 500
				model.SetStoveData(scmd)
			}

			let Handler18106 = () => {
				let scmd = user_msg_adapter.GetSCMD(18106)
				if (scmd.error_code == 1) {
					model.Fire(local_LungEvent.LUNG_STOVE_SUCCESS, scmd.reward_list)
					model.Fire(local_LungEvent.LUNG_REQUEST_PROTO, 18105)
				} else {
					Util.ErrorCodeShow(scmd.error_code)
				}
			}

			let Handler18107 = () => {
				let scmd = user_msg_adapter.GetSCMD(18107)
				if (scmd.error_code == 1) {
					local_Message.show("领取成功")
					let goods_list = []
					for (let _tmpi in scmd.reward_list) {
						var vo = scmd.reward_list[_tmpi]
						let obj = []
						obj[0] = 0
						obj[1] = vo.typeId
						obj[2] = vo.count
						goods_list.push(obj)
					}
					let view = new CongratulationObtainView(goods_list, 10)
					view.Open()
					model.Fire(local_LungEvent.LUNG_REQUEST_PROTO, 18105)
				} else {
					Util.ErrorCodeShow(scmd.error_code)
				}
			}

			let Handler18112 = () => {
				let scmd = user_msg_adapter.GetSCMD(18112)
				model.stove_open_state = scmd
				model.Fire(local_LungEvent.LUNG_REQUEST_PROTO, 18105)
			}

			let Handler18113 = () => {
				let scmd = user_msg_adapter.GetSCMD(18113)
				if (scmd.location == local_GoodsModel.GOODS_POS_TYPE.lung_bag) {
					for (let _tmpi in scmd.goods_list) {
						var vo = scmd.goods_list[_tmpi]
						goods_model.UpdateLungBagGoods(vo)
					}
					goods_model.Fire(local_GoodsModel.CHANGE_LUNG_BAG_LIST)
				} else if (scmd.location == local_GoodsModel.GOODS_POS_TYPE.lung_equip) {
					for (let _tmpi in scmd.goods_list) {
						var vo = scmd.goods_list[_tmpi]
						goods_model.UpdateLungEquipGoods(vo)
					}
					goods_model.Fire(local_GoodsModel.CHANGE_LUNG_LIST)
				}
			}

			let update_fun = () => {
				model.LungRedDot()
			}

			goods_model.Bind(local_GoodsModel.CHANGE_LUNG_LIST, update_fun)
			goods_model.Bind(local_GoodsModel.CHANGE_LUNG_BAG_LIST, update_fun)
			RoleManager.GetInstance().GetMainRoleVo().Bind(EventName.CHANGE_LEVEL, () => {
				model.Fire(local_LungEvent.LUNG_REQUEST_PROTO, 18105)
			});

			goods_model.Bind(local_GoodsModel.UPDATE_GOODS_NUM, (goods_list?) => {
				for (let _tmpi in goods_list) {
					var info = goods_list[_tmpi]
					if (info.type_id == LungModel.Goods || info.type_id == LungModel.Goods1) {
						model.LungRedDot()
						break
					}
				}
			})

			let shop_fun = (_type?, cfg_id?) => {
				if (_type == MysteryShopType.LungShopType) {
					model.ShopDot()
				}
			}
			shop_model.Bind(local_ShopEvent.UPDATE_MYSTERY_SHOP_DATA, shop_fun)
			shop_model.Bind(local_ShopEvent.UPDATE_MYSTERY_SHOP_ONE_DATA, shop_fun)

			let score_fun = (vo?) => {
				if ((vo.currency_id == local_LungModel.LungStone1 || vo.currency_id == local_LungModel.LungStone2) || vo.currency_id == local_LungModel.LungStone3) {
					model.ShopDot()
				}
			}
			goods_model.Bind(local_GoodsModel.UPDATE_SPECIAL_SCORE, score_fun)

			let time_change = () => {
				model.Fire(local_LungEvent.LUNG_REQUEST_PROTO, 18112)
			}
			local_GlobalEventSystem.Bind(ServerTimeModel.REFRESH_SERVER_TIME, time_change)

			this.RegisterProtocal(18100, Handler18100)
			this.RegisterProtocal(18101, Handler18101)
			this.RegisterProtocal(18102, Handler18102)
			this.RegisterProtocal(18103, Handler18103)
			this.RegisterProtocal(18104, Handler18104)
			this.RegisterProtocal(18105, Handler18105)
			this.RegisterProtocal(18106, Handler18106)
			this.RegisterProtocal(18107, Handler18107)
			this.RegisterProtocal(18112, Handler18112)
			this.RegisterProtocal(18113, Handler18113)
		}

		this.InitEvent = () => {
			model.Bind(local_LungEvent.LUNG_REQUEST_PROTO, (id, fmt, ...new_args) => {
				this.SendFmtToGame(id, fmt, ...new_args)
			}
			)
			model.Bind(local_LungEvent.LUNG_REQUEST_OTHER_PROTO, (id?, list?) => {
				if (id == 18104) {
					this.WriteBegin(18104)
					this.WriteFMT("h", list.length)
					for (let _tmpi in list) {
						var vo = list[_tmpi]
						this.WriteFMT("l", vo.goods_id)
					}
					this.SendToGame()
				}
			}
			)
			model.Bind(local_LungEvent.LUNG_OPEN_VIEW, async (view_name: string, ...new_args) => {
				let view = view_dic_[view_name]
				if (!view) {
					view_dic_[view_name] = true
					if (!window[view_name]) {
						if (!res_mgr.IsJsLoad("lung")) {
							await res_mgr.LoadJs("lung")
						}
					}
					if (view_dic_[view_name] == true) {
						let view_class = window[view_name]
						view = new view_class()
						view_dic_[view_name] = view
					}
				}
				if (view && view != true) {
					if (view_name == "LungStoveMainView") {
						if (model.StoveOpenState()) {
							model.is_first_show_stove_dot = false;
						} else {
							return;
						}
					}
					view.Open(...new_args);
				}
			}
			)
			model.Bind(local_LungEvent.LUNG_CLOSE_VIEW, (view_name, ...new_args) => {
				let view = view_dic_[view_name]
				if (view && view != true) {
					view.Close()
				}
				view_dic_[view_name] = null
			}
			)
			local_GlobalEventSystem.Bind(local_EventName.GAME_START, async () => {
				await model.InitConfig()
				let delay_fun = () => {
					model.Fire(local_LungEvent.LUNG_REQUEST_PROTO, 18100)
					model.Fire(local_LungEvent.LUNG_REQUEST_PROTO, 18105)
					model.Fire(local_LungEvent.LUNG_REQUEST_PROTO, 18112)
					goods_model.Fire(local_GoodsModel.REQUEST_EXCHANGE_GOODS, local_LungModel.LungExchangeType)
					shop_model.Fire(local_ShopEvent.SHOP_REQUEST_PROTO, 15305, "h", MysteryShopType.LungShopType)
				}
				setTimeout(delay_fun, 3)
			}
			)
			let exchange_fun = (id?) => {
				model.ExchangeSuccess(id)
			}

			goods_model.Bind(local_GoodsModel.BUY_SUCCESS, exchange_fun)
		}

		this.RegisterAllProtocals()
		this.InitEvent()
	}
}

window["LungController"] = LungController
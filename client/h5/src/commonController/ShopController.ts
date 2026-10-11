import { BaseController } from "../common/BaseController"
import { EventName } from "../common/EventName"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { GoodsModel } from "../commonModel/GoodsModel"
import { MysteryShopType, ShopEvent, ShopModel, ShopMoneyType, ShopType } from "../commonModel/ShopModel"
import { RoleManager } from "../commonModel/RoleManager"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { TimeUtil } from "../util/TimeUtil"
import { NotEnougnDiamond, Split, Util } from "../util/Util"
import "../common/QuickBuyView"
import { TopVipEvent, TopVipModel, TopVipMoneyId } from "../commonModel/TopVipModel"
import { PlatformManager } from "../PlatformManager"
import { ResManager } from "../common/ResManager"
import { Config } from "../common/Config"

import "../shop/ShopCommonView"
import "../shop/ShopBulkPurchaseView"
import "../shop/ShopItem"
import "../shop/ShopLimitItem"
import "../shop/ShopMysteriouItem"
import "../shop/ShopMysteriousView"
import "../shop/ShopSeriesTab"
import "../shop/ShopVieItem"
import "../shop/ShopVieView"
import "../shop/ShopView"
import { GuildEvent, GuildModel } from "../commonModel/GuildModel"
import { MainFunc } from "../commonModel/MainUIModel"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { DiamondFightModel } from "../commonModel/DiamondFightModel"
import { GodBeastModel } from "../commonModel/GodBeastModel"
import { OnHookModel } from "../commonModel/OnHookModel"
import { DailyModel } from "../commonModel/DailyModel"

export class ShopController extends BaseController {
	InitEvent
	InitInfo

	public constructor() {
		super()
		let request_proto_event = ShopEvent.SHOP_REQUEST_PROTO
		let local_ShopEvent = ShopEvent
		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName
		let local_ShopType = ShopType
		let user_msg_adapter = UserMsgAdapter.GetInstance()
		let local_Message = Message
		let model = ShopModel.GetInstance()
		let view_dic_ = []

		let special_price = 0
		let special_id = 2005

		this.InitEvent = () => {
			//绑定事件 监听代币变动 更新钻石商城红点
			RoleManager.GetInstance().GetMainRoleVo().BindOne("jin", () => {
				let value: number = RoleManager.GetInstance().GetMainRoleVo()["jin"]
				if (special_price <= value && !model.diamond_red_status) {
					let bool = !model.have_enter_special_tab
					model.diamond_red_status = bool
					GlobalEventSystem.Fire(EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 153, bool)
					//MainUIModel.GetInstance().Fire(MainUIModel.REFRESH_FRIEND_AND_MAIL_RED, MainUIChatView.red_index.shop, bool)
				} else if (special_price > value) {
					model.diamond_red_status = false
					GlobalEventSystem.Fire(EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 153, false)
					//MainUIModel.GetInstance().Fire(MainUIModel.REFRESH_FRIEND_AND_MAIL_RED, MainUIChatView.red_index.shop, false)
				}
			})

			model.Bind(request_proto_event, (id, fmt, ...new_args) => {
				this.SendFmtToGame(id, fmt, ...new_args)
			}
			)




			model.Bind(local_ShopEvent.SHOP_OPEN_VIEW, (view_name: string, ...new_args) => {
				if (PlatformManager.GetInstance().is_alpha && view_name == "QuickBuyView") return
				let view = view_dic_[view_name]
				if (!view) {
					view_dic_[view_name] = true
					if (view_dic_[view_name] == true) {
						let view_class = window[view_name]
						view = new view_class()
						view_dic_[view_name] = view
					}
				}
				if (view && view != true) {
					if (view.HasOpen()) {
						view.Close()
					} else {
						view.Open(...new_args)
					}
				}
			}
			)

			local_GlobalEventSystem.Bind(local_EventName.OPEN_SHOP_MAIN_VIEW, (index?, type_id?, back_id?) => {
				let view = view_dic_["ShopView"]
				// if (view && view != true) {
				// 	view.DeleteMe()
				// 	view_dic_["ShopView"] = null
				// 	view = null
				// }
				if (!view) {
					view_dic_["ShopView"] = true
					if (view_dic_["ShopView"] == true) {
						let view_class = window["ShopView"]
						view = new view_class()
						view_dic_["ShopView"] = view
					}
				}
				if (view && view != true) {
					view.SetDefaultIndex(index)
					view.SetBackId(back_id)
					if (type_id) {
						model.show_type_id = type_id
						view.not_jump_red = true
					}
					if (!view.HasOpen()) {
						view.Open()
					} else {
						view.SetSelectIndex(index)
					}
				}
			}
			)

			local_GlobalEventSystem.Bind(local_EventName.GAME_START, async () => {
				await model.InitConfig()

				model.Fire(request_proto_event, 15301, "c", local_ShopType.Limit)
				model.Fire(request_proto_event, 15301, "c", local_ShopType.Diamond)
				model.Fire(request_proto_event, 15301, "c", local_ShopType.Bind_Diamond)
				model.Fire(request_proto_event, 15301, "c", local_ShopType.Outward)
				model.Fire(request_proto_event, 15301, "c", local_ShopType.NormalShop)
				model.Fire(request_proto_event, 15301, "c", local_ShopType.EudaemonShop)
				model.Fire(request_proto_event, 15301, "c", local_ShopType.Lucky)
				model.Fire(request_proto_event, 15301, "c", local_ShopType.LonglangEx)
				model.Fire(request_proto_event, 15301, "c", local_ShopType.SoulOfWar)
				model.Fire(request_proto_event, 15301, "c", local_ShopType.GodCourt)
				model.Fire(request_proto_event, 15301, "c", local_ShopType.TopVipShop)
				model.Fire(request_proto_event, 15301, "c", local_ShopType.Guild)
				model.Fire(request_proto_event, 15301, "c", local_ShopType.MedalShop)
				model.Fire(request_proto_event, 64000)
			}
			)

			local_GlobalEventSystem.Bind(ServerTimeModel.HOUR_REFRESH, (hour?) => {
				if (hour == 4) {
					model.SetVieInfo(null)
					model.vie_red_stutus = null
					model.Fire(request_proto_event, 64000)
					model.Fire(request_proto_event, 15301, "c", local_ShopType.EudaemonShop)
					model.Fire(request_proto_event, 15301, "c", local_ShopType.SacredShop)
					model.Fire(request_proto_event, 15301, "c", local_ShopType.SoulOfWar)
				}
			}
			)
			RoleManager.GetInstance().GetMainRoleVo().Bind(local_EventName.CHANGE_LEVEL, () => {
				let level = RoleManager.GetInstance().GetMainRoleVo().level
				if (level == 300) {
					model.Fire(request_proto_event, 15301, "c", local_ShopType.SoulOfWar)
				}
			}
			)

			RoleManager.GetInstance().Bind("vip_flag", (vip_flag?) => {
				model.Fire(request_proto_event, 15301, "c", local_ShopType.Lucky)
			}
			)



			GoodsModel.GetInstance().Bind(GoodsModel.CHANGE_BAG_LIST, (goods_list) => {
				//刷新团结之证  相关红点
				let red_1: boolean = goods_list.some((data) => {
					return data.type_id == ShopMoneyType.Guild2
				});
				if (red_1) {
					ShopModel.GetInstance().SetRedofGuild(2)
				}


				//幸运鉴宝 红点
				let red_2: boolean = goods_list.some((data) => {
					return data.type_id == CustomActivityModel.LUCK_STONE_ID
				});
				if (red_2) {
					CustomActivityModel.GetInstance().SetActRedDot(Config.PRELOAD_CLIENT_CONFIG.ConfigCustomActivity.ACT_ID.LUC_TREA_TWO, CustomActivityModel.GetInstance().lucky_sub_type)
					CustomActivityModel.GetInstance().RefreshIconRed(Config.PRELOAD_CLIENT_CONFIG.ConfigCustomActivity.ACT_ID.LUC_TREA_TWO, CustomActivityModel.GetInstance().lucky_sub_type)
				}

				//勾玉擂台门票
				let red_3: boolean = goods_list.some((data) => {
					return data.type_id == DiamondFightModel.TICKET_ID
				});
				if (red_3) {
					DiamondFightModel.GetInstance().UpdateRedforDiamond()
				}
				//蜃装秘卷
				let red_4: boolean = goods_list.some((data) => {
					return data.type_id ==GodBeastModel.GOODS_SENYAO_MIJUAN
				});
				if (red_4) {
					GodBeastModel.GetInstance().CheckAllRedStatus()
				}
				//挂机卡 购买并使用
				if (OnHookModel.GetInstance().call_back_obj) {
					let red_5: boolean = goods_list.some((data) => {
						return data.type_id == OnHookModel.GetInstance().call_back_obj["type_id"]
					});
					if (red_5) {
						let data1 = GoodsModel.GetInstance().GetBindGoodsVoFirstByTypeId(OnHookModel.GetInstance().cost_goods_type)
						let data1_num = data1.goods_num || 0
						let num = OnHookModel.GetInstance().call_back_obj["cur_num"]
						num = num > data1_num ? data1_num : num
						GoodsModel.GetInstance().Fire(GoodsModel.REQUEST_CCMD_EVENT, 15050, "li", data1.goods_id, num);
						OnHookModel.GetInstance().call_back_obj = null
					}
				}
				//挂机卡
				let red_6: boolean = goods_list.some((data) => {
					return data.type_id == 38070001
				});
				if (red_6) {
					if(!DailyModel.GetInstance().out_line_card_check_2){
						DailyModel.GetInstance().out_line_card_check_2 = true
						DailyModel.GetInstance().AutoUseOutLineTimeCard()
					}
				}
			})


			//更新特殊货币 -善魂
			GoodsModel.GetInstance().Bind(GoodsModel.CREATE_SPECIAL_SCORE_FINISH, () => {
				ShopModel.GetInstance().SetRedofGuild(1)
			})

			//更新特殊货币 -善魂
			GoodsModel.GetInstance().Bind(GoodsModel.UPDATE_SPECIAL_SCORE, (vo, old_num) => {
				if (vo.currency_id == ShopMoneyType.Guild && vo.num != old_num) {
					ShopModel.GetInstance().SetRedofGuild(1)
				}

			})

		}

		this.InitInfo = () => {
			//获得商品列表
			let Handler15301 = () => {
				let scmd = user_msg_adapter.GetSCMD(15301)
				if (scmd.goods_list) {
					for (let _tmpi in scmd.goods_list) {
						let vo: IShopGoodsInfo = scmd.goods_list[_tmpi]
						vo.subtype_list = (vo.subtype_list).replace("%[", "")
						vo.subtype_list = (vo.subtype_list).replace("%]", "")
						vo.series_list = Split(vo.subtype_list, ",")
					}
				}
				if (scmd.type == ShopType.TopVipShop) {
					let model = TopVipModel.GetInstance()
					model.SetSupremeVipShopGoodsList(scmd.goods_list)
					model.Fire(TopVipEvent.UPDATE_TOP_VIP_SHOP_VIEW)
					model.Fire(TopVipEvent.TOP_VIP_REQUEST_PROTO, 15008, "i", TopVipMoneyId)
				} else {
					//钻石商城红点
					model.SetShopData(scmd)
					if (scmd.type == ShopType.Diamond) {
						let role_vo = RoleManager.GetInstance().mainRoleInfo
						let have_money = role_vo.jin
						let goods_list = scmd.goods_list
						let price = 0
						let sold_out = 0
						for (let key in goods_list) {
							let goods = goods_list[key]
							if (goods.key_id == special_id) {
								price = goods.price
								sold_out = goods.sold_out
							}
						}
						special_price = price
						if (sold_out == 0 && price <= have_money) {//商品没卖完 且 钱够
							model.diamond_red_status = !model.have_enter_special_tab;
						}
					}
				}
			}

			//购买商品
			let Handler15302 = () => {
				let scmd = user_msg_adapter.GetSCMD(15302)
				if (scmd.result == 1) {
					local_Message.show("购买成功")
					model.Fire(local_ShopEvent.BUY_GOODS_SUCCESS, scmd.key_id)
					model.UpdateShopData(scmd)
				} else if (scmd.result == 1040) {
					let data = ShopModel.GetInstance().GetShopDataByKeyId(scmd.key_id)
					if (data && data.money_type == ShopMoneyType.TopVip) {
						local_Message.show("至尊币不足，完成至尊币任务可获取至尊币")
					} else {
						Util.ErrorCodeShow(scmd.result)
					}
				} else {
					if (scmd.result == 1001) {
						NotEnougnDiamond()
					}
					model.Fire(local_ShopEvent.BUY_GOODS_FAILURE, scmd.key_id)
					Util.ErrorCodeShow(scmd.result)
				}
			}

			//神秘商店
			let Handler15305 = () => {
				let scmd = user_msg_adapter.GetSCMD(15305)
				let cfg = Config.PRELOAD_SERVER_CONFIG.config_mystery_shop_good
				model.SetMysteryShop(scmd, cfg)
			}

			//手动刷新商店
			let Handler15306 = () => {
				let scmd = user_msg_adapter.GetSCMD(15306)
				if (scmd.errcode == 1) {
					local_Message.show("刷新成功")
				} else {
					Util.ErrorCodeShow(scmd.errcode)
				}
			}

			//购买商品
			let Handler15307 = () => {
				let scmd = user_msg_adapter.GetSCMD(15307)
				if (scmd.errcode == 1) {
					if (scmd.type != MysteryShopType.LungShopType) {
						local_Message.show("购买成功")
					}
					model.Fire(local_ShopEvent.SHOP_MYSTERY_BUY_SUCCESS, scmd.cfg_id)
					model.UpdateMysteryShop(scmd)
				} else {
					Util.ErrorCodeShow(scmd.errcode)
				}
			}

			//快速购买
			let Handler15304 = () => {
				let scmd = user_msg_adapter.GetSCMD(15304)
				if (scmd.res == 1) {
					model.Fire(local_ShopEvent.BUY_GOODS_SUCCESS);
					local_Message.show("购买成功")
				} else {
					Util.ErrorCodeShow(scmd.res)
				}
			}

			//限购商品列表
			let Handler64000 = () => {
				let scmd = user_msg_adapter.GetSCMD(64000)
				scmd["left_time"] = TimeUtil.GetFutureZeroStamp(1)
				scmd.id_list.sort((a?, b?) => {
					return a.id - b.id
				})
				if (model.vie_red_stutus == null) {
					let show_out = true
					for (let key in scmd.id_list) {
						var vo = scmd.id_list[key]
						let over1 = vo.buy_num >= vo.daily_limit_num
						let over2 = vo.left_limit_num <= 0
						let vo_show_out = over1 || over2
						if (!vo_show_out) {
							show_out = false
							break
						}
					}
					model.vie_red_stutus = scmd.id_list.length > 0 && !show_out
					local_GlobalEventSystem.Fire(local_EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 153)
					//MainUIModel.GetInstance().Fire(MainUIModel.REFRESH_FRIEND_AND_MAIL_RED, MainUIChatView.red_index.shop)
				}
				model.SetVieInfo(scmd)
				model.Fire(local_ShopEvent.OUT_VIE_SHOP_DATA, scmd)
			}

			//购买
			let Handler64001 = () => {
				let scmd = user_msg_adapter.GetSCMD(64001)
				if (scmd.errcode == 1) {
					model.Fire(local_ShopEvent.BUY_VIE_GOODS_SUCCESS, scmd)
					let vinfo = model.GetVieInfo()
					if (!vinfo) {
						return
					}
					for (let _tmpi in vinfo.id_list) {
						var info = vinfo.id_list[_tmpi]
						if (info.id == scmd.id) {
							info.left_limit_num = scmd.left_limit_num
							info.buy_num = scmd.buy_num
							break
						}
					}
					model.SetVieInfo(vinfo)
				} else {
					Util.ErrorCodeShow(scmd.errcode)
				}
			}

			//商品数量变化
			let Handler64002 = () => {
				let scmd = user_msg_adapter.GetSCMD(64002)
				let vinfo = model.GetVieInfo()
				if (!vinfo) {
					return
				}
				for (let _tmpi in scmd.change_list) {
					var cinfo = scmd.change_list[_tmpi]
					for (let _tmpj in vinfo.id_list) {
						var info = vinfo.id_list[_tmpj]
						if (info.id == cinfo.id) {
							info.left_limit_num = cinfo.left_limit_num
							break
						}
					}
				}
				model.SetVieInfo(vinfo)
			}

			//下架商品
			let Handler64003 = () => {
				let scmd = user_msg_adapter.GetSCMD(64003)
				let vinfo = model.GetVieInfo()
				if (!vinfo) {
					return
				}
				for (let _tmpi in scmd.del_list) {
					var dinfo = scmd.del_list[_tmpi]
					for (let i = 1; i <= vinfo.id_list.length; i++) {
						if (vinfo.id_list[i].id == dinfo.id) {
							vinfo.id_list.slice(i, 1)
							break
						}
					}
				}
				model.SetVieInfo(vinfo)
			}

			this.RegisterProtocal(15301, Handler15301)		//获得商品列表
			this.RegisterProtocal(15302, Handler15302)		//购买商品
			this.RegisterProtocal(15304, Handler15304)		//快速购买
			this.RegisterProtocal(15305, Handler15305)		//神秘商店
			this.RegisterProtocal(15306, Handler15306)		//手动刷新商店
			this.RegisterProtocal(15307, Handler15307)		//购买商品

			this.RegisterProtocal(64000, Handler64000)		//限购商品列表
			this.RegisterProtocal(64001, Handler64001)		//购买
			this.RegisterProtocal(64002, Handler64002)		//商品数量变化
			this.RegisterProtocal(64003, Handler64003)		//下架商品
		}

		this.InitInfo()
		this.InitEvent()
	}
}

window["ShopController"] = ShopController
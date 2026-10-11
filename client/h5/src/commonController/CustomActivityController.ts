
//require("game.proto.331.Require331")
//require("game.proto.332.Require332")
//require("game.proto.224.Require224")
//require("game.proto.225.Require225")
//require("game.proto.226.Require226")
//require("game.customActivity.CustomActivityDefine")
//require("game.customActivity.CustomActivityModel")
//require("game.customActivity.CommonActivityView")
//require("game.customActivity.PartnerActivity")
//require("game.customActivity.CommonActRewardPreview")
//require("game.customActivity.RequireActivity")
//require("game.feastBoss.WeekendActivityView")
//require("game.feastBoss.FeastBossEnterView")
import { BaseController } from "../common/BaseController"
import { CommonManager } from "../common/CommonManager"
import { Config } from "../common/Config"
import { CongratulationObtainAutoView } from "../common/CongratulationObtainAutoView"
import { CongratulationObtainView } from "../common/CongratulationObtainView"
import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { TaskModel } from "../commonModel/TaskModel"
import { ActivityIconManager } from "../commonModel/ActivityIconManager"
import { RoleManager } from "../commonModel/RoleManager"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { Mathf } from "../util/Mathf"
import { TimeUtil } from "../util/TimeUtil"
import { Split, GlobalTimerQuest, Util } from "../util/Util"
import { CommonActivityView } from "../customActivity/CommonActivityView"
import { WelfareModel } from "../commonModel/WelfareModel"
import { PlatformManager } from "../PlatformManager"
import { BaseDungeonModel } from "../commonModel/BaseDungeonModel"
import { DungeonEnterView } from "../dungeon/DungeonEnterView"
import { TurnTableModel } from "../commonModel/TurnTableModel"
import { SaiboModel } from "../commonModel/SaiboModel"
import { HotPointModel } from "../kfHotPoint/HotPointModel"
import { SpecialPackageModel } from "../commonModel/SpecialPackageModel"
import "../customActivity/RequieCustomActivity"
import "../zeroMoney/ZeroMoneyBaseViewTwo"
import "../zeroMoney/ZeroMoneyBaseViewNew"
import "../vipGift/vipGiftWindowView"
import "../ftvCollectionExchange/FtvBulkPurchaseView"
import "../activity/FtvRechargeMainViewTwo"
import "../LuckyTreasure/LuckyTreasureView"
import "../nameVerify/NameVerifyView"
import "../moneyTree/MoneyTreeView"
import "../moneyTree/MoneyTreeShopView"
import "../moneyTree/MoneyTreeViewTwo"
import "../customActivity/StageShowView"
import "../dungeonShow/DungeonShowView"
import "../luckyTreasureTwo/LuckyTreasureTwoBaseView"
import "../common/CongratulationObtainAutoView"
import "../ftvShop/FtvShopView"
import "../ftvShop/FtvShopViewTwo"
import "../gashapon/GashaponMainView"
import "../customActivity/CommonActRewardPreview"
import "../ftvActivityTwo/TurnTableView"
import "../saiboTreasure/SaiboTreasureView"
import "../specialPackage/SpecialPackageView"
import "../ftvActiveness/FtvActivenessMainView"
import './../saiboTreasure/SaiboBuyPreview';
import "../destinyTurntable/DestinyTurnTableActiveView"
import "../dailylogin/DailyLogInView"
import "../atListPurchase/AtListPurchaseView"
import "../wxOneMoney/WXOneMoneyView"
import "../activity/ConRechargeView"
import "../oneDollarSpike/OneDollarSpikeView"
import "../redEnvelopeRebate/RedEnvelopeRebateView"
import "../carnival/CarnivalMainView"
import "../cycleimpActlist/CycleimpActlistView"
import "../ftvExchange/FtvExchangeTips"
import "../testAct/TestActBaseView"
import "../ftvInvest/FtvInvestBaseView"
import "../ftvInvest/FtvInvestBtnView"
import "../ftvInvest/FtvInvestRewardView"
import "../ftvInvest/FtvInvestView"
import "../superGift/SuperGiftView"
import "../activity/rechargeReturnView"
import "../tiredChargePolite/TiredChargePoliteMain"
import "../onlineDraw/OnlineDrawView"
import "../onlineDraw/OnlineDrawBaseView"
import "../redPacketRain/RPRShowView"
import "../redPacketRain/RedPacketRainView"
import "../rareSurface/RareSurfaceView"
import "../rareSurface/RareSurfaceListItem"
import "../rareSurface/RareSurfaceSkillItem"
import "../questionNaire/QuestionNaireBaseView"
import "../questionNaire/QuestionNaireMainView"
import "../questionNaire/QuestionNaireDescribeItem"
import "../questionNaire/QuestionNaireImageItem"
import "../kfGroupBuy/KfGroupBuyEntView"
import "../kfGroupBuy/KfGroupBuyView"
import "../kfGroupBuy/KfGBRecordView"
import "../advertising/AdvertisingBaseView"
import "../advertising/AdvertisingMainView"
import "../newAccumRecharge/NewAccumRechargeEnterView"

import { RedEnvelopeRebateModel } from "../commonModel/RedEnvelopeRebateModel"
import { RedEnvelopeRebateModelEvent } from './../commonModel/RedEnvelopeRebateModel';
import { Alert, Alert_Type } from "../alert/Alert"
import { CycleimpActlistModel } from "../commonModel/CycleimpActlistModel"
import { ViewPopLevelModel } from "../commonModel/ViewPopLevelModel"
import { ActivityForeshowManager } from "../commonModel/ActivityForeshowManager"
import { CookieWrapper } from "../common/CookieWrapper"
import { TiredChargePoliteModel, TiredChargePoliteModelEvent } from "../commonModel/TiredChargePoliteModel"
import { Enum_ColorUtil_Dark } from "../util/ColorUtil"
import { FunctionOpenEvent, FunctionOpenModel } from "../commonModel/FunctionOpenModel"
import { LayerManager } from "../common/LayerManager"
import { KaifuActivityModel } from "../commonModel/KaifuActivityModel"
import { QuestionNaireModel } from "../commonModel/QuestionNaireModel"
import { FlowerrankModel } from "../commonModel/FlowerRankModel"

export class CustomActivityController extends BaseController {
	InitEvents
	InitInfo
	ShowTopPlayerGoalReward
	ShowTopPlayerRankReward
	model: CustomActivityModel;
	view_dic



	public constructor() {
		super()



		this.view_dic = []

		this.model = CustomActivityModel.GetInstance()
		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName
		let dungeon_model = BaseDungeonModel.GetInstance()
		let custom_event = CustomActivityDefine.EVENT
		let local_CustomActivityDefine = CustomActivityDefine
		let local_ServerTimeModel = ServerTimeModel
		let cfg_custom_activity = Config.PRELOAD_CLIENT_CONFIG.ConfigCustomActivity
		let activity_icon_mgr = ActivityIconManager.GetInstance()

		let local_Message = Message
		let role_mgr = RoleManager.GetInstance()
		let common_mgr = CommonManager.GetInstance()
		let user_msg_adapter = UserMsgAdapter.GetInstance()
		//let cost_rank_model = CostRankModel.GetInstance()
		// let boss_base_model = BossModel.GetInstance()
		// let local_BossBaseModel = BossModel
		// let boss_type = BossModel.BossType
		// let turn_table_model = TurnTableModel.GetInstance()
		let time_out_01 = null
		let lucky_reward_list = []
		let lucky_reward_view = null

		this.InitEvents = () => {

			let activenss_time_limit = () => {
				if (this.model.fvt_activeness_time == 0) {
					let now_time = TimeUtil.getServerTime()
					let data = new Date(now_time * 1000)
					data.setHours(7)
					data.setMinutes(0)
					data.setSeconds(0)
					let target_time = Mathf.Round(data.getTime() / 1000)
					if (now_time < target_time) {
						this.model.fvt_activeness_time = target_time - now_time
					}
				}

				this.model.SetActRechargeDay(0)
				this.model.Fire(custom_event.SCMD_REQUEST, 15959)
			}
			let change_day_func = () => {
				this.model.show_super_gift_view = true
				CookieWrapper.GetInstance().RemoveCookie(CookieWrapper.SUPER_GIFT_CHECK)
				activenss_time_limit()
			}

			local_GlobalEventSystem.Bind(local_EventName.GAME_START, () => {
				this.model.OnClearActTime(0)
				RedEnvelopeRebateModel.GetInstance().clearActData();
				this.model.clearSpecialRedDotMap();
				this.model.ResetData()
				SaiboModel.GetInstance().InitConfig();
				this.model.InitConfig()

				//dungeon_model:removeDungeonActivityTimer()
				this.model.Fire(custom_event.SCMD_REQUEST, 33101)
				activenss_time_limit()
				this.model.ClearActivityTime()
			}
			)


			let fefresh_verify_icon = () => {
				this.model.RefreshVerifyIcon()
			}

			local_GlobalEventSystem.Bind(local_EventName.WINDOW_RESUME, fefresh_verify_icon)

			local_GlobalEventSystem.Bind(local_ServerTimeModel.DAY_CHANGE, change_day_func)

			let HOUR_REFRESH = (hour?) => {
				if (hour == 4) {
					if (!this.model.cache_scmd_33101_list) {
						return
					}
					for (let _tmpi in this.model.cache_scmd_33101_list) {
						var v = this.model.cache_scmd_33101_list[_tmpi]
						if (v.base_type == cfg_custom_activity["ACT_ID"].FTVACTIVENESS && v.show_id != 10) {
							let data = this.model.GetActData(v.base_type, v.sub_type)
							if (data) {
								this.model.Fire(custom_event.SCMD_REQUEST, 33193, v.base_type, v.sub_type)
							}
						}
					}
				}
			}
			local_GlobalEventSystem.Bind(local_ServerTimeModel.HOUR_REFRESH, HOUR_REFRESH)

			this.model.Bind(custom_event.CLEAR_AUTO_VIEW, () => {
				if (lucky_reward_view) {
					lucky_reward_view = null
				}
			}
			)
			this.model.Bind(custom_event.SCMD_REQUEST, (cmd: number, ...new_args) => {
				let args = new_args
				if (cmd == 33104
					|| cmd == 33137
					|| cmd == 33138
					|| cmd == 15958
					|| cmd == 33120
					|| cmd == 33121
					|| cmd == 33190
					|| cmd == 33193
					|| cmd == 33197
					|| cmd == 33198
					|| cmd == 33205
					|| cmd == 33208
					|| cmd == 33165
					|| cmd == 33130
					|| cmd == 33131
					|| cmd == 33132
					|| cmd == 33211
					|| cmd == 33177
					|| cmd == 33128
					|| cmd == 33133
					|| cmd == 33139
					|| cmd == 33141
					|| cmd == 33213
					|| cmd == 33217
					|| cmd == 33218
					|| cmd == 33221
					|| cmd == 33222
					|| cmd == 33223
					|| cmd == 22405
					|| cmd == 33225
					|| cmd == 33226
					|| cmd == 33227
					|| cmd == 33228
					|| cmd == 33231
					|| cmd == 33238
					|| cmd == 33240
					|| cmd == 33241
					|| cmd == 33243
					|| cmd == 33245
					|| cmd == 33247
					|| cmd == 33250
					|| cmd == 33255
					|| cmd == 33258
					|| cmd == 33259
					|| cmd == 33211
					|| cmd == 33260
					|| cmd == 33262
					|| cmd == 33263
					|| cmd == 33264
				) {
					this.SendFmtToGame(cmd, "hh", args[0], args[1])
				} else if (cmd == 33265
					||cmd == 33105
					|| cmd == 33123
					|| cmd == 33192
					|| cmd == 33195
					|| cmd == 33207
					|| cmd == 33215
					|| cmd == 33135
					|| cmd == 33144
					|| cmd == 33219
					|| cmd == 33220
					|| cmd == 33168
					|| cmd == 33142
					|| cmd == 33267
				) {
					this.SendFmtToGame(cmd, "hhh", args[0], args[1], args[2])
				} else if (cmd == 22501
					|| cmd == 22403
				) {
					this.SendFmtToGame(cmd, "ih", args[0], args[1])
				} else if (cmd == 22502
					|| cmd == 33136
					|| cmd == 15955
					|| cmd == 15956
					|| cmd == 33140
					|| cmd == 33204
					|| cmd == 33155
					|| cmd == 33157
					|| cmd == 22601
					|| cmd == 22602
					|| cmd == 33261
				) {
					this.SendFmtToGame(cmd, "h", args[0])
				} else if (cmd == 22503
					|| cmd == 22504
				) {
					this.SendFmtToGame(cmd, "ihc", args[0], args[1], args[2])
				} else if (cmd == 15957
				) {
					this.SendFmtToGame(cmd, "hhi", args[0], args[1], args[2])
				} else if (cmd == 33112
				) {
					this.SendFmtToGame(cmd, "h", args[0])
				} else if (cmd == 33113
					|| cmd == 33194
					|| cmd == 33212
					|| cmd == 33134
					|| cmd == 33224
				) {
					this.SendFmtToGame(cmd, "hhc", args[0], args[1], args[2])

				} else if (cmd == 33114
				) {
					this.SendFmtToGame(cmd, "h", args[0])
				} else if (cmd == 33187
				) {
					this.SendFmtToGame(cmd, "hh", args[0], args[1])
				} else if (cmd == 33189
					|| cmd == 15960
				) {
					this.SendFmtToGame(cmd, "h", args[0])
				} else if (cmd == 33122
					|| cmd == 33191
					|| cmd == 33206
					|| cmd == 33167
				) {
					this.SendFmtToGame(cmd, "hhcc", args[0], args[1], args[2], args[3])
				} else if (cmd == 33179
				) {
					this.SendFmtToGame(cmd, "hhhh", args[0], args[1], args[2], args[3])
				} else if (cmd == 15087
				) {
					this.SendFmtToGame(cmd, "s", args[0])
				} else if (cmd == 33106
				) {
					if (args.length >= 5) {
						this.SendFmtToGame(cmd, "hhhhh", args[0], args[1], args[2], args[3], args[4])
					} else {
						//GameError.GetInstance().SendErrorToPHP(debug.traceback())
					}
				} else if (cmd == 33166
				) {
					this.SendFmtToGame(cmd, "hhccc", args[0], args[1], args[2], args[3], args[4])
				} else if (cmd == 33176
					|| cmd == 33214
					|| cmd == 33229
				) {
					this.SendFmtToGame(cmd, "hhhc", args[0], args[1], args[2], args[3])
				} else if (cmd == 33244) {
					this.SendFmtToGame(cmd, "hhhch", args[0], args[1], args[2], args[3], args[4])
				} else if (cmd == 33246) {
					this.SendFmtToGame(cmd, "hhhcc", args[0], args[1], args[2], args[3], args[4])
				} else if (cmd == 33129) {
					this.WriteBegin(cmd)
					this.WriteFMT("h", args[0])
					this.WriteFMT("h", args[1])
					this.WriteFMT("h", args[2].length)
					if (args[2].length > 0) {
						for (let key in args[2]) {

							// [ts2lua]args[2]下标访问可能不正确
							let v = args[2][key]
							this.WriteFMT("c", v[0])
							this.WriteFMT("h", v[1])
						}
					}
					this.SendToGame()
				} else if (cmd == 33115
					|| cmd == 22603
				) {
					this.SendFmtToGame(cmd, "hc", args[0], args[1])
				} else if (cmd == 33142
				) {
					this.SendFmtToGame(cmd, "hhhhc", args[0], args[1], args[2], args[3], args[4])
				} else if (cmd == 33236
				) {
					this.SendFmtToGame(cmd, "c", args[0])
				} else if (cmd == 22505) {
					this.SendFmtToGame(cmd, "i", args[0])
				} else if (cmd == 33256) {
					this.SendFmtToGame(cmd, "hhcss", args[0], args[1], args[2], args[3], args[4])
				} else if (cmd == 33266){
					this.SendFmtToGame(cmd, "hhl", args[0], args[1], args[2])
				}else {
					this.SendFmtToGame(cmd)
				}
			}
			)

			let open_out_act_view = (icon_type, ...new_args) => {
				if (PlatformManager.GetInstance().is_alpha && icon_type == "331@6@0") return
				let parm = new_args
				icon_type = String(icon_type)
				let list = Split(icon_type, "@")

				//竞榜特殊处理
				let isCompeteList = Number(list[1]) == cfg_custom_activity.SPECIAL_ID.COMPETELIST
				// if (isCompeteList && ! CompeteListModel.GetInstance().competeListOpen(true) ) {
				// 	return
				// }

				//综合图标+单独入口的
				let ShowKeyItemToIcon = local_CustomActivityDefine.ShowKeyItemToIcon
				for (let key in ShowKeyItemToIcon) {

					let value = ShowKeyItemToIcon[key]
					if (value == icon_type) {
						let _list = Split(key, "#")
						if (activity_icon_mgr.getIconInfo(_list[0])) {
							list = _list[1] && Split(_list[1], "@")

							//检查活动数据
							let info1 = this.model.GetActInfoByShowID(list[0], list[1])
							let check_data = this.model.CheckActData(info1.base_type, info1.sub_type)
							if (!check_data) {
								return
							}

							icon_type = _list[0]
							parm = list
							break
						}
					}
				}

				if (list.length == 2 || isCompeteList) {

					////////lua配置读取是乱序，此处为排序////////////-
					let window_list = cfg_custom_activity.windowscomponent[String(icon_type)]
					//转换为数组 数组才能排序
					let new_window_list = []
					let w_index = 0
					for (let key_type in window_list) {
						var win_vo = window_list[key_type]
						new_window_list[w_index] = win_vo
						new_window_list[w_index].key_type = key_type
						w_index = w_index + 1
					}
					//排序
					table.sort(new_window_list, (a?, b?) => {
						return a.pos < b.pos
					})
					////////lua配置读取是乱序，此处为排序////////////-

					//检查活动数据
					let list_has_data = false
					if (parm.length == 2) {
						let info2 = this.model.GetActInfoByShowID(parm[0], parm[1])
						if (info2) {
							list_has_data = this.model.CheckActData(info2.base_type, info2.sub_type)
						}
					} else {
						for (let key = 0; key < new_window_list.length; key++) {
							var vo = new_window_list[key]
							let check_data = -1
							let type_list = Split(vo.key_type, "@")
							let info = this.model.GetActInfoByShowID(type_list[0], type_list[1])
							if (info) {
								if ((type_list[0] + type_list[1] == '1213') || (type_list[0] + type_list[1] == '1212')) { // 累充有礼特俗处理
									check_data = Number(Boolean(TiredChargePoliteModel.GetInstance().GetTiredChargePoliteData()))
								} else {
									check_data = this.model.CheckActData(info.base_type, info.sub_type)
								}
							} else {
								let sp_type_id = Number(type_list[0])
								if (sp_type_id == cfg_custom_activity.SPECIAL_ID.LEVELREWARD) {
									check_data = WelfareModel.GetInstance().GetLevelRewardInfo()
								} else if (sp_type_id == cfg_custom_activity.SPECIAL_ID.HOTPOINT) {
									check_data = HotPointModel.GetInstance().GetActInfo(type_list[0], type_list[1])
								}

							}

							if (icon_type == "331@110" && CycleimpActlistModel.GetInstance().GetActTime()) { //循环冲榜，普通活动特殊处理
								list_has_data = true;
								break
							}

							if (icon_type == TiredChargePoliteModel.ICON_TYPE && TiredChargePoliteModel.GetInstance().GetTiredChargePoliteData()) { // 累充有礼特殊处理
								list_has_data = true;
								break;
							}

							if (check_data != -1) {
								if (check_data) {
									list_has_data = true
									break
								}
							}
						}
					}
					if (!list_has_data) {
						Message.show("活动正在加载，请稍后...")
						return
					}

					let view = this[icon_type]
					if (!view) {
						this[icon_type] = true
						if (this[icon_type] == true) {
							//let view_class = CommonActivityView
							view = new CommonActivityView()
							this[icon_type] = view
						}
					}
					if (view) {
						//	let cfg = Config.ClientCustomActivityIconKey
						view.SetIconType(icon_type, new_window_list, ...new_args)
						if (!view.HasOpen()) {
							view.Open()
						} else {
							let [act_type, show_id] = new_args
							let icon_key_cfg = Config.PRELOAD_CLIENT_CONFIG.ClientCustomActivityIconKey
							let window_list = Config.PRELOAD_CLIENT_CONFIG.ConfigCustomActivity.windowscomponent[icon_type]
							let index = 0
							let select_index
							for (let key in window_list) {
								let list = key.split("@")
								if (this.model.ActivityNeedHideInAlpha(list[0])) {
									continue
								}
								let info = this.model.GetActInfoByShowID(list[0], list[1])
								if(list[0] == "23" && !info ){
									info = HotPointModel.GetInstance().GetActInfoByShowId(list[0], list[1])
								}
								let role_lv = RoleManager.GetInstance().mainRoleInfo.level
								let info2 = window_list[key]
								let bool = true
								//封测时，修改开服活动的title
								if (this.model.isCBPlatform() && (icon_type == "331@3" || icon_type == "331@3_1")) {
									info2.title = "uifc_001_png"
								}
								if (info2.max_day && info2.max_day > 0) {
									//bool = KaifuActivityModel.GetInstance().fullShowIconTime(info.stime, info2.max_day)
								}
								let is_Key2Item = icon_key_cfg[key] ? true : false
								if (info && role_lv >= info2.open_lv && bool && is_Key2Item) {
									if (act_type && list[0] == String(act_type)) {
										if (show_id == undefined || list[1] == String(show_id)) {
											select_index = index
											break
										}
									}
									index++
								}
							}
							if (select_index) {
								view.SetSelectIndex(select_index)
							}
						}
					}

				} else if (list.length == 3) {
					let info = this.model.GetActInfoByShowID(list[1], list[2])
					//检查活动数据
					if (info) {
						if (info.base_type == TiredChargePoliteModel.ACT_TYPE) { // 比较特殊
							let actData = TiredChargePoliteModel.GetInstance().GetTiredChargePoliteData();
							if (!actData) {
								console.error('TiredChargePoliteData数据为空');
								return;
							}
						} else {
							let act_data = this.model.CheckActData(info.base_type, info.sub_type)
							if (!act_data) {
								console.error('活动数据为空!');
								return
							}
						}
					}
					let class_name = local_CustomActivityDefine.IconType2View[icon_type]
					class_name = class_name && window[class_name.module_js_class]
					if (!class_name) {
						local_Message.show("未开发 ～")
						return
					}
					if (info) {
						let view = this[icon_type]
						if (!view) {
							view = new class_name()
							this[icon_type] = view
						}
						//主界面活动 加这个方法
						if (view.SetActInfo) {
							this.model.holiday_info = info
							view.SetActInfo(info, parm)
						}
						if (!view.HasOpen()) {
							view.Open()
							ViewPopLevelModel.GetInstance().isPopIng = false;
						}
					} else {
						local_Message.show(local_CustomActivityDefine.DESC_LABEL[0])
					}
				}
			}
			local_GlobalEventSystem.Bind(local_EventName.OPEN_ACT_VIEW, open_out_act_view)


			let close_act_view = (icon_type, ...new_args) => {
				icon_type = String(icon_type)
				let list = Split(icon_type, "@")
				let view = this[icon_type]
				if (!view) {
					return
				}
				if (view.HasOpen && view.HasOpen()) {
					view.Close()
				}
			}
			local_GlobalEventSystem.Bind(local_EventName.CLOSE_ACT_VIEW, close_act_view)


			this.model.Bind(custom_event.OPEN_CUSTOM_VIEW, (view_name, module_js_name, ...new_args) => {
				let parms = new_args

				view_name = String(view_name)
				let view = this.view_dic[view_name]
				if (!view) {
					this.view_dic[view_name] = true

					//if (! window[view_name] && module_js_name ) {
					//if (! ResManager.GetInstance().IsJsLoad(module_js_name) ) {
					//lua_resM:LoadJs(module_js_name)
					//}
					//}

					if (this.view_dic[view_name] == true) {
						let view_class: any = window[view_name]
						if ("CloudPurchaseGetRewardView" == view_name) {
							view = new view_class(parms[0], parms[1])
						} else if ("default" == view_name) {
							view = new view_class()
						} else {
							view = new view_class()
						}
						this.view_dic[view_name] = view
					}
				}
				if (view) {
					if (view_name == "CloudPurchaseGetRewardView") {
						view.Open()
					} else if (view_name == "CommonActRewardPreview") {
						view.SetData(parms[0], parms[1])
						view.Open()
					} else {
						view.Open(...new_args)
					}

				}
			}
			)


			let delay_timer_id = null
			let LevelChange = () => {
				if (delay_timer_id) {
					GlobalTimerQuest.CancelQuest(delay_timer_id)
					delay_timer_id = null
				}
				if (!delay_timer_id) {
					delay_timer_id = GlobalTimerQuest.AddDelayQuest(() => {
						if (this.model.cache_scmd_33101_list) {
							this.model.UpdateActivityIcons(this.model.cache_scmd_33101_list)
						}
						this.model.RefreshLevelWindowRewardState(cfg_custom_activity.ACT_ID.LEVEL_WINDOW_REWARD)	//弹窗奖励
						GlobalTimerQuest.CancelQuest(delay_timer_id)
						delay_timer_id = null
					}, 0.4)
				}
			}
			role_mgr.GetMainRoleVo().Bind(local_EventName.CHANGE_LEVEL, LevelChange)

			let taskChange = (value?) => {
				let icon_mgr = activity_icon_mgr
				let icon_info = null
				let icon_type = null
				let list = []
				let windows_cfg = cfg_custom_activity["windowscomponent"]
				let open_cfg = Config.PRELOAD_CLIENT_CONFIG.ConfigFuncOpenCondition
				let specialView = local_CustomActivityDefine.SpecialView
				for (let v in specialView) {

					let cfg = open_cfg[specialView[v].module_js_class]
					if ((cfg && cfg.open_task != 0) && value == cfg.open_task) {
						for (let w in windows_cfg) {

							let view = windows_cfg[w][v]
							if (view) {
								icon_type = w
								if (icon_mgr.getIconInfo(icon_type)) {
									break
								}
								let key_list = Split(v, "@")
								icon_info = common_mgr.GetFunctionIconCfg(icon_type)
								list[icon_type] = {
									end_time: 0,
									icon_info_data: icon_info.data
								}
								this.model.RequireSpecialViewInfo(key_list[1])
								// break
							}
						}
					}
				}
				if (!Util.IsTableEmpty(list)) {
					this.model.AddActivityIcons(list)
				}
			}
			GlobalEventSystem.Bind(EventName.UPDATE_NEWEST_TASK_ID_NOT_DELAY, taskChange)

			//***yoyo 废弃的活动
			//let open_yoyo_rewaed_View = () => {
			//let class_name = "YoYoRewaedView"
			//// [ts2lua]this下标访问可能不正确
			//let view = this[class_name]
			//if (! view ) {
			//// [ts2lua]this下标访问可能不正确
			//this[class_name] = true
			//// [ts2lua]window下标访问可能不正确
			//if (! window[class_name] ) {
			//if (! ResManager.GetInstance().IsJsLoad("separateActTwo") ) {

			//}
			//}
			//// [ts2lua]this下标访问可能不正确
			//if (this[class_name] == true ) {
			//// [ts2lua]window下标访问可能不正确
			//let view_class = window[class_name]
			//view =  new view_class()
			//// [ts2lua]this下标访问可能不正确
			//this[class_name] = view
			//}
			//}
			//if (view ) {
			//view:Open()
			//}
			//}
			//yoyo_model:Bind(local_YoYoModelEvent.OPEN_YOYO_REWARD_VIEW, open_yoyo_rewaed_View)

			//let request_start = (type?, subtype?, times?, auto_buy?) => {
			//this:SendFmtToGame(33186, "hhhc", type, subtype, times, auto_buy)
			//}
			//yoyo_model:Bind(local_YoYoModelEvent.REQUEST_START, request_start)
			//***yoyo 废弃的活动

			//定制活动物品刷新监听
			let updata_goods = (list?) => {
				this.model.UpdataACTGoodsNum(list)
			}
			GoodsModel.GetInstance().Bind(GoodsModel.UPDATE_GOODS_NUM, updata_goods)

			this.model.Bind(custom_event.SHOW_FORES_GAME_SATR_TIPS_VIEW, (activity?) => {
				/* let class_name = "ForeshowStarTipsView"
				let view = this[class_name]
				if (!view) {
					this[class_name] = true

					if (this[class_name] == true) {
						let view_class = window[class_name]
						view = new view_class()
						this[class_name] = view
					}
				}
				if (view) {
					view.setData(activity)
					view.Open()
				} */

				ViewPopLevelModel.GetInstance().SetView('ForeshowStarTipsView', activity);
			}
			)

			this.model.Bind(custom_event.SHOW_FORES_TIPS_VIEW, (activity?, isStar?) => {
				/* let class_name = "ForeshowStarTipsView"
				let view = this[class_name]
				if (!view) {
					this[class_name] = true

					if (this[class_name] == true) {
						let view_class = window[class_name]
						view = new view_class()
						this[class_name] = view
					}
				}
				if (view && view != true) {
					view.setData(activity, isStar)
					view.Open()
				} */

				if (isStar) {
					if (ActivityForeshowManager.GetInstance().is_pop_tip) {
						ViewPopLevelModel.GetInstance().SetView('ForeshowStarTipsView', activity, isStar);
					} else {
						ActivityForeshowManager.GetInstance().is_need_pop_act = activity
					}
				} else {
					ViewPopLevelModel.GetInstance().SetView('ForeshowStarTipsView', activity, isStar);
				}

			}
			)

			role_mgr.GetMainRoleVo().Bind("vip_flag", () => {
				if (this.model.cache_scmd_33101_list) {
					for (let _tmpi in this.model.cache_scmd_33101_list) {
						var v = this.model.cache_scmd_33101_list[_tmpi]
						if (v.base_type == cfg_custom_activity.ACT_ID.VIPGIFT) {
							this.model.SetActRedDot(v.base_type, v.sub_type)
							this.model.RefreshIconRed(v.base_type, v.sub_type)
							break
						}
					}
				}
				if (this.model.GetActInfoByType(113)) {
					let info = this.model.GetActInfoByType(113)
					this.model.Fire(CustomActivityDefine.EVENT.SCMD_REQUEST, 33104, info.base_type, info.sub_type)
				}
			}
			)

			// DailyModel.GetInstance().Bind(DailyEvent.UPDATE_LIVENESS_REWARD,() => {
			// 		if (this.model.cache_scmd_33101_list ) {
			// 			for (let _tmpi in this.model.cache_scmd_33101_list) {
			// 				var v = this.model.cache_scmd_33101_list[_tmpi]
			// 				if (v.base_type == cfg_custom_activity.ACT_ID.ONLINE_DRAW ) {
			// 					let info81 = this.model.GetActCondition(v.base_type, v.sub_type, "info")
			// 					if (info81 && info81.draw_con ) {
			// 						if (info81.draw_con[1] == "activity" ) {
			// 							this.model.SetActRedDot(v.base_type, v.sub_type)
			// 							this.model.RefreshIconRed(v.base_type, v.sub_type)
			// 						}
			// 					}
			// 				} else if (v.base_type == cfg_custom_activity.ACT_ID.ACT_TURNTABLE ) {
			// 					this.model.SetActRedDot(v.base_type, v.sub_type)
			// 					this.model.RefreshIconRed(v.base_type, v.sub_type)
			// 				}
			// 			}
			// 		}
			// 	}
			// )

			let change_fun = () => {
				this.model.Fire(custom_event.SCMD_REQUEST, 33101)
			}
			local_GlobalEventSystem.Bind(local_EventName.ALPHA_STATE_CHANGE, change_fun)
			local_GlobalEventSystem.Bind(local_EventName.CHANGE_MAINROLE_CAREER, change_fun)
			CustomActivityModel.GetInstance().Bind(CustomActivityDefine.EVENT.RECHARGE_SUCCESS, change_fun)

			//问卷调查
			local_GlobalEventSystem.Bind(EventName.OPEN_QUESTIONNAIRE_VIEW, (index?) => {
				// [ts2lua]this.view_dic下标访问可能不正确
				let view = this.view_dic["QuestionNaireBaseView"]
				if (view && view != true) {
					view.DeleteMe()
					// [ts2lua]this.view_dic下标访问可能不正确
					this.view_dic["QuestionNaireBaseView"] = null
					view = null
				}
				if (!view) {
					// [ts2lua]this.view_dic下标访问可能不正确
					this.view_dic["QuestionNaireBaseView"] = true
					// [ts2lua]window下标访问可能不正确
					if (!window["QuestionNaireBaseView"]) {
						if (!ResManager.GetInstance().IsJsLoad("questionNaire")) {

						}
					}
					// [ts2lua]this.view_dic下标访问可能不正确
					if (this.view_dic["QuestionNaireBaseView"]) {
						// [ts2lua]window下标访问可能不正确
						let view_class = window["QuestionNaireBaseView"]
						view = new view_class()
						// [ts2lua]this.view_dic下标访问可能不正确
						this.view_dic["QuestionNaireBaseView"] = view
					}
				}
				if (view && view != true) {
					if (index) {
						view.SetDefaultIndex(index)
					}
					view.Open()
				}
			}
			)
			QuestionNaireModel.GetInstance().Bind(QuestionNaireModel.CLOSE_QUESTIONNAIRE_VIEW, (view_name?) => {
				// [ts2lua]this.view_dic下标访问可能不正确
				let view = this.view_dic[view_name]
				if (view && view != true) {
					view.Close()
				} else if (view == true) {
					// [ts2lua]this.view_dic下标访问可能不正确
					this.view_dic[view_name] = null
				}
			}
			)
			//问卷调查
		}

		this.InitInfo = () => {
			let On33100 = () => {
				let scmd = user_msg_adapter.GetSCMD(33100)
				if (scmd.error_code != 1012) {
					Util.ErrorCodeShow(scmd.error_code)
				}
			}

			let On33101 = () => {
				let scmd = user_msg_adapter.GetSCMD(33101);
				for (const iterator of scmd.list) {
					if (iterator.base_type == RedEnvelopeRebateModel.ACT_TYPE) {
						this.model.Fire(custom_event.SCMD_REQUEST, 33255, iterator.base_type, iterator.sub_type);
					}
				}

				if (time_out_01) {
					clearTimeout(time_out_01)
					time_out_01 = null
				}
				time_out_01 = setTimeout(() => {
					this.model.ClearActInfo();
					this.model.SaveActInfo(scmd.list)

					for (const iterator of scmd.list) {
						if (iterator.base_type == TiredChargePoliteModel.ACT_TYPE) {
							this.model.Fire(custom_event.SCMD_REQUEST, 33259, iterator.base_type, iterator.sub_type);
						}
					}

					clearTimeout(time_out_01)
					time_out_01 = null
				}, 0.02)
			}

			let On33102 = () => {
				let scmd = user_msg_adapter.GetSCMD(33102)
				this.model.AddActInfo(scmd.list)
			}

			let On33103 = () => {
				let scmd = user_msg_adapter.GetSCMD(33103)
				this.model.DeleteActInfo(scmd.list)
			}

			let On33104 = () => {
				let scmd = user_msg_adapter.GetSCMD(33104)
				//暂时处理充值超值特惠直购礼包
				if (scmd.base_type == 98 && scmd.sub_type == 8) {
					let reward_list = scmd.reward_list
					let old_list = this.model.GetActData(98, 8)
					if (old_list) {
						old_list = old_list.reward_list
						for (let key in reward_list) {
							let re1 = reward_list[key]
							let re2 = old_list[key]
							if (re2.status == 0 && re1.status == 2) {
								let list = ErlangParser.GetInstance().Parse(re1.reward)
								let view = new CongratulationObtainView(list, 10)
								view.Open()
							}
						}
					}
				}
				// 不在显示主界面图标
				if (scmd.base_type == 115) {
					let falg: boolean = true;
					if (scmd) {
						for (const iterator of scmd.reward_list) {
							if (iterator.status != 2) {
								falg = false;
								break;
							}
						}
					}

					if (falg) {
						this.model.SetActData(scmd)
						ActivityIconManager.GetInstance().deleteIcon('331@115@0');
						this.model.Fire(custom_event.UPDATE_VIEW, scmd.base_type, scmd.sub_type, scmd)
						return;
					}
				}
				let is_have_receive = false

				if (scmd.base_type == 120) {
					let list = scmd.reward_list


					for (let key in list) {
						let v = list[key]
						let condition = ErlangParser.GetInstance().parse(v.condition)
						let is_free = false
						if (v.status == 1) is_have_receive = true
						for (let k in condition) {
							if (condition[k][0] == "is_free" && Number(condition[k][1]) == 1) {
								is_free = true
								break
							}
						}
						if (!is_free) {
							v.status = 2
						}
						
					}
					this.model.state = false
					let bool = false
					for (let key in list) {
						let v = list[key]
						let condition = ErlangParser.GetInstance().parse(v.condition)
						for (let k in condition) {
							let index = Number(k)
							if (condition[index][0] == "product_id" && condition[index][1] != 0) {
								bool = true
								break
							}
						}
						if(bool){
							if(v.receive_times > 0){
								this.model.state = true
								break
							}
						}
					}
				}

				this.model.SetActData(scmd)
				this.model.UpdataRechargeSum(scmd.base_type, scmd.sub_type)
				this.model.RefreshSpecialIcon(scmd.base_type, scmd.sub_type)
				this.model.Fire(custom_event.UPDATE_VIEW, scmd.base_type, scmd.sub_type)
				if (scmd.base_type == 120) {
					//运营需求,超值礼包130级之前不主动弹出
					let level = RoleManager.GetInstance().GetMainRoleLevel()
					if(level < 130) return
					let cookie = CookieWrapper.Instance.GetCookie(CookieWrapper.SUPER_GIFT_CHECK)
					if (this.model.show_super_gift_view && is_have_receive && ((cookie && Number(cookie) == 0) || !cookie)) {
						let info = this.model.GetActInfo(scmd.base_type, scmd.sub_type)
						let condition = ErlangParser.GetInstance().parse(info.condition)
						let show_pop = false
						if(!PlatformManager.GetInstance().is_alpha){
							for (let key in condition) {
								let vo = condition[key]
								if (vo[0] == "is_popup") {
									show_pop = Number(vo[1]) == 1 ? true : false
									break
								}
							}
						}
						if (show_pop){
							ViewPopLevelModel.GetInstance().SetSpacialView('SuperGiftView',true,`331@${scmd.base_type}@${info.show_id}`)
							ViewPopLevelModel.GetInstance().SetSpacialView('SuperGiftView',false)
						}
							
						this.model.show_super_gift_view = false
					}
				}

			}

			let On33105 = () => {
				let scmd = user_msg_adapter.GetSCMD(33105)
				if (scmd.error_code != 1) {
					Util.ErrorCodeShow(scmd.error_code)
					let b = scmd.base_type
					let s = scmd.sub_type
					if (cfg_custom_activity.ACT_ID.VIPGIFT == b) {
						this.model.act_key_dic[b] = this.model.act_key_dic[b] || {}
						this.model.act_key_dic[b][s] = this.model.act_key_dic[b][s] || {}
						this.model.act_key_dic[b][s]["buy_ing"] = false
					}
					return
				}
				this.model.SetActResult(scmd)
				this.model.SetActRedDot(scmd.base_type, scmd.sub_type)
				this.model.RefreshIconRed(scmd.base_type, scmd.sub_type)

				//首日福利删除一个倒计时
				if (scmd.base_type == Config.PRELOAD_CLIENT_CONFIG.ConfigCustomActivity.ACT_ID.CREAT_ROLE_GIFT
					&& !this.model.IsNeedCountTime(scmd.base_type, scmd.sub_type)) {
					this.model.OnClearActTime(scmd.base_type, scmd.sub_type)
				}
			}

			let On33106 = () => {
				let scmd = user_msg_adapter.GetSCMD(33106)
				this.model.SetActDataAllCount(scmd)
				this.model.Fire(custom_event.UPDATE_ALL_COUNT, scmd.base_type, scmd.sub_type, scmd)
			}

			let On33108 = () => {
				let scmd = user_msg_adapter.GetSCMD(33108)
				for (let index in scmd.values) {

					this.model.RequireActInfo(scmd.values[index].base_type, scmd.values[index].sub_type)
				}
			}

			let On22500 = () => {
				let scmd = user_msg_adapter.GetSCMD(22500)
				if (scmd.error_code != 1012) {
					Util.ErrorCodeShow(scmd.error_code)
				}
			}

			let On22501 = () => {
				let scmd = user_msg_adapter.GetSCMD(22501)
				let base_type = cfg_custom_activity.ACT_ID.TOP_PLAYER
				let sub_type = 1
				let data = this.model.GetActData(base_type, sub_type)
				if (data) {
					if (data.rank_info) {
						// [ts2lua]data.rank_info下标访问可能不正确
						data.rank_info[scmd.rank_type] = scmd
					} else {
						data.rank_info = []
						// [ts2lua]data.rank_info下标访问可能不正确
						data.rank_info[scmd.rank_type] = scmd
					}
					this.model.SetActRedDot(data.base_type, data.sub_type)
					this.model.RefreshIconRed(data.base_type, data.sub_type)
				} else {
					let data = { base_type: base_type, sub_type: sub_type, rank_info: {} }
					// [ts2lua]data.rank_info下标访问可能不正确
					data.rank_info[scmd.rank_type] = scmd
					this.model.SetActData(data)
				}
				let data_ = data && data.rank_info && data.rank_info[data.rank_info.length - 1]
				this.model.Fire(custom_event.UPDATE_VIEW, base_type, sub_type, scmd.rank_type)
				if (scmd && scmd.end_time && scmd.end_time > 0) {
					this.model.Fire(custom_event.REFRESHCOUNTDOWN, "331@10@0", scmd.end_time, true)
				}
				ResManager.GetInstance().GetGameConfigWithAutoDestory("config_rush_rank", (cfg) => {
					let open_day = ServerTimeModel.GetInstance().GetOpenServerDay();
					let openTime:number = ServerTimeModel.GetInstance().GetOpenServerTime();
					let k = scmd.rank_type
					let v = cfg[k]
					if (v.start_day <= open_day && openTime >= v.open_start_time && openTime <= v.open_end_time) {
						GlobalEventSystem.Fire(EventName.UPDATE_TOP_PLAYER_MAIN_DATA, scmd, base_type, sub_type)
					}

				}, false)

			}

			let On22502 = () => {
				let scmd = user_msg_adapter.GetSCMD(22502)
				table.sort(scmd.goal_list, (a?, b?) => {
					return a.rank_type < b.rank_type
				}
				)
				let base_type = cfg_custom_activity.ACT_ID.TOP_PLAYER
				let sub_type = 1
				let data = this.model.GetActData(base_type, sub_type)
				if (data) {
					data.reward_info = scmd.goal_list
					this.model.SetActRedDot(data.base_type, data.sub_type)
					this.model.RefreshIconRed(data.base_type, data.sub_type)
				} else {
					let data = { base_type: base_type, sub_type: sub_type, reward_info: null }
					data.reward_info = scmd.goal_list
					this.model.SetActData(data)
				}
				this.model.Fire(custom_event.UPDATE_VIEW, base_type, sub_type)
			}

			let On22503 = () => {
				let scmd = user_msg_adapter.GetSCMD(22503)
				if (scmd.error_code == 1) {
					local_Message.show("领取成功")
					this.ShowTopPlayerGoalReward(scmd.type, scmd.goal)
					this.model.Fire(custom_event.SCMD_REQUEST, 22502, scmd.sub_type)
				}
			}

			let On22504 = () => {
				let scmd = user_msg_adapter.GetSCMD(22504)
				if (scmd.error_code == 1) {
					local_Message.show("领取成功")
					this.ShowTopPlayerRankReward(scmd.type, scmd.reward_id)
				}
				// [ts2lua]scmd下标访问可能不正确
				scmd["base_type"] = cfg_custom_activity.ACT_ID.TOP_PLAYER
				this.model.SetActResult(scmd)
				this.model.Fire(custom_event.SCMD_REQUEST, 22502, scmd.sub_type)
			}
			let On22505 = () => {
				let scmd = user_msg_adapter.GetSCMD(22505)
				this.model.TopPlayerGetWayInfo(scmd)
				this.model.Fire(custom_event.UPDATE_VIEW, 10, 1, scmd.rush_id)
			}

			let On33136 = () => {
				let scmd = user_msg_adapter.GetSCMD(33136)
				if (scmd.errcode != 1) {
					if (scmd.errcode != 1012) {
						Util.ErrorCodeShow(scmd.errcode)
					}
					return
				}

				scmd["base_type"] = cfg_custom_activity["ACT_ID"].ZERO_MALL
				let info = this.model.GetActInfo(scmd["base_type"], scmd.sub_type)
				let delete_func = () => {
					let vo = []
					table.insert(vo, info)
					this.model.DeleteActInfo(vo)
					let index = Util.TableSize(this.model.cache_scmd_33101_list) - 1
					do {
						if (this.model.cache_scmd_33101_list[index].base_type == vo[0].base_type && this.model.cache_scmd_33101_list[index].sub_type == vo[0].sub_type) {
							table.remove(this.model.cache_scmd_33101_list, 1)
						}
						index = index - 1
					} while ((index > 0))

				}
				if (scmd.reward_list.length == 0 && info) {
					delete_func()
					return
				} else if (info && info.show_id == 10) {
					let info_cond = this.model.GetActCondition(scmd["base_type"], scmd.sub_type, "info")
					let in_buy_day = true
					if (info_cond && info_cond.buy_day) {
						in_buy_day = (info.stime + Number(info_cond.buy_day) * 24 * 3600) > TimeUtil.getServerTime() && true || false
					}
					let is_delete = true
					if (!in_buy_day) {
						for (let k in scmd.reward_list) {
							var v = scmd.reward_list[k]
							if (v.status == 1) {
								is_delete = false
							}
						}
					} else {
						is_delete = false
					}
					if (is_delete) {
						delete_func()
						return
					}
				}
				if (info) {
					let icon_type = "331" + "@" + info.base_type + "@" + info.show_id
					let icon_info = activity_icon_mgr.getIconInfo(icon_type)
					let list = []
					if (!icon_info) {
						icon_info = common_mgr.GetFunctionIconCfg(icon_type)
						if (icon_info) {
							let player_lv = role_mgr.mainRoleInfo.level
							let open_day = ServerTimeModel.GetInstance().GetOpenServerDay()
							if (player_lv >= icon_info.open_lv && open_day >= icon_info.open_day) {
								list[icon_type] = { base_type: info.base_type, show_id: info.show_id, end_time: info.etime, icon_info_data: icon_info.data }
							}
						}
						if (!Util.IsTableEmpty(list)) {
							this.model.AddActivityIcons(list)
						}
					}
				}
				this.model.SetActData(scmd)
				this.model.zero_money_info = this.model.GetActData(info.base_type, info.sub_type)
				this.model.Fire(custom_event.UPDATE_VIEW, 36, scmd.sub_type)
			}

			let On33137 = () => {
				let scmd = user_msg_adapter.GetSCMD(33137)
				if (scmd.errcode != 1) {
					Util.ErrorCodeShow(scmd.errcode)
					return
				}
				this.model.Fire(custom_event.BUY_SUCCESS, 36, scmd.sub_type)
			}

			let On33138 = () => {
				let scmd = user_msg_adapter.GetSCMD(33138)
				if (scmd.errcode != 1) {
					Util.ErrorCodeShow(scmd.errcode)
					return
				}
				this.model.Fire(custom_event.RECEIVE_SUCCESS, 36, scmd.sub_type, scmd.grade)
			}

			let On15957 = () => {
				let scmd = user_msg_adapter.GetSCMD(15957)
				this.model.SetActRecharge(scmd.type, scmd.subtype, scmd.total_gold)
			}

			let On15958 = () => {
				let scmd = user_msg_adapter.GetSCMD(15958)
				this.model.SetActRecharge(scmd.type, scmd.subtype, scmd.total_gold)
			}

			let On15959 = () => {
				let scmd = user_msg_adapter.GetSCMD(15959)
				this.model.SetActRechargeDay(scmd.total_gold)
				this.model.RequireActInfo(cfg_custom_activity.ACT_ID.CON_RECHARGE, 1)
			}
			let On15960 = () => {
				let scmd = user_msg_adapter.GetSCMD(15960)
				this.model.SetActRechargeGone(scmd.lists)
				this.model.Fire(custom_event.UPDATE_RECHARGE_ITEM)
			}

			let On33112 = () => {
				let scmd = user_msg_adapter.GetSCMD(33112)
				if (scmd.errcode == 1) {
					// [ts2lua]cfg_custom_activity下标访问可能不正确
					let base_type = cfg_custom_activity["ACT_ID"].CLOUD_PURCHASE
					// [ts2lua]scmd下标访问可能不正确
					scmd["base_type"] = base_type
					this.model.cloud_purchase_real_end_time = scmd.next_reward_time
					this.model.SetActData(scmd)
					this.model.Fire(custom_event.UPDATE_VIEW, base_type, scmd.sub_type)
				} else {
					if (scmd.errcode != 1012) {
						Util.ErrorCodeShow(scmd.errcode)
					}
				}
			}

			let On33113 = () => {
				let scmd = user_msg_adapter.GetSCMD(33113)
				if (scmd.errcode == 1) {
					local_Message.show("购买成功")
					let reward_list = []
					for (let _tmpi in scmd.buy_list) {
						var obj = scmd.buy_list[_tmpi]
						let dic = []
						dic[0] = obj.good_type
						dic[1] = obj.reward_id
						dic[2] = obj.reward_num
						table.insert(reward_list, dic)
					}
					for (let _tmpi in scmd.buy_times_list) {
						var vo = scmd.buy_times_list[_tmpi]
						let stage_reward = this.model.UpdateClouldPurchaseStageState(vo.buy_times)
						if (stage_reward) {
							for (let _tmpi in stage_reward) {
								var vo = stage_reward[_tmpi]
								table.insert(reward_list, vo)
							}
						}
					}
					// [ts2lua]this.view_dic下标访问可能不正确
					let view = this.view_dic["CloudPurchaseGetRewardView"]
					if (view) {
						view.DeleteMe()
						// [ts2lua]this.view_dic下标访问可能不正确
						this.view_dic["CloudPurchaseGetRewardView"] = null
					}
					this.model.Fire(custom_event.OPEN_CUSTOM_VIEW, "CloudPurchaseGetRewardView", "customActivity", reward_list, scmd.sub_type)
				} else {
					if (scmd.errcode != 1012) {
						Util.ErrorCodeShow(scmd.errcode)
					}
				}
				this.model.Fire(custom_event.SCMD_REQUEST, 33112, scmd.sub_type)
			}

			let On33114 = () => {
				let scmd = user_msg_adapter.GetSCMD(33114)
				let sort_fun = (a?, b?) => {
					return b.award_time - a.award_time
				}

				scmd.bingo_player_list.sort(sort_fun)
				this.model.cloud_purchase_history = scmd
				this.model.Fire(custom_event.UPDATE_CLOUD_PURCHASE_HISTORY_VIEW)
			}

			let On33116 = () => {
				let scmd = user_msg_adapter.GetSCMD(33116)
				let data = this.model.GetActData(cfg_custom_activity.ACT_ID.CLOUD_PURCHASE, scmd.sub_type)
				if (data) {
					data.stage = scmd.stage
				}
				this.model.Fire(custom_event.UPDATE_VIEW, cfg_custom_activity.ACT_ID.CLOUD_PURCHASE, scmd.sub_type)
			}

			let On33185 = () => {
				let scmd = user_msg_adapter.GetSCMD(33185)
				let act_info = this.model.GetActInfoByShowID(cfg_custom_activity.ACT_ID.CLOUD_PURCHASE, 0)
				if (act_info) {
					this.model.Fire(custom_event.SCMD_REQUEST, 33112, act_info.sub_type)
				}
			}

			let On15955 = () => {
				let scmd = user_msg_adapter.GetSCMD(15955)
				let sort_fun = (a?, b?) => {
					return a.id < b.id
				}
				table.sort(scmd.reward_infos, sort_fun)
				for (let k in scmd.reward_infos) {
					var v = scmd.reward_infos[k]
					v.grade = v.id
				}
				//scmd.reward_infos = scmd.reward_infos.reverse()
				let base_type = cfg_custom_activity.ACT_ID.DAILY_RECHARGE
				// [ts2lua]scmd下标访问可能不正确
				scmd["base_type"] = base_type
				let data = this.model.GetActData(base_type, scmd.sub_type)
				if (data) {
					// [ts2lua]data下标访问可能不正确
					data["reward_infos"] = scmd.reward_infos
					this.model.SetActRedDot(base_type, scmd.sub_type)
					this.model.RefreshIconRed(base_type, scmd.sub_type)
				} else {
					data = scmd
					this.model.SetActData(data)
				}
				this.model.Fire(custom_event.UPDATE_VIEW, cfg_custom_activity.ACT_ID.DAILY_RECHARGE, scmd.sub_type)
			}

			let On15956 = () => {
				let scmd = user_msg_adapter.GetSCMD(15956)
				let sort_fun = (a?, b?) => {
					return a.id < b.id
				}
				table.sort(scmd.reward_list, sort_fun)
				for (let k in scmd.reward_list) {
					var v = scmd.reward_list[k]
					v.grade = v.id
				}
				let base_type = cfg_custom_activity.ACT_ID.DAILY_RECHARGE
				// [ts2lua]scmd下标访问可能不正确
				scmd["base_type"] = base_type
				let data = this.model.GetActData(base_type, scmd.sub_type)
				if (data) {
					// [ts2lua]data下标访问可能不正确
					data["reward_list"] = scmd.reward_list
					this.model.SetActRedDot(base_type, scmd.sub_type)
					this.model.RefreshIconRed(base_type, scmd.sub_type)
				} else {
					data = scmd
					this.model.SetActData(data)
				}
				this.model.Fire(custom_event.UPDATE_DAYILY_FIRST_VIEW, base_type, scmd.sub_type)
			}

			let On33118 = () => {
				let scmd = user_msg_adapter.GetSCMD(33118)
				this.model.Fire(custom_event.SCMD_REQUEST, 33104, scmd.base_type, scmd.sub_type)
			}

			let On33169 = () => {
				let scmd = user_msg_adapter.GetSCMD(33169)
			}

			let On33186 = () => {
				let scmd = user_msg_adapter.GetSCMD(33186)
				if (scmd.errcode == 1) {
					//yoyo_model.setStartData(scmd)
				} else if (scmd.errcode != 1012) {
					Util.ErrorCodeShow(scmd.errcode)
				}
			}

			let On33187 = () => {
				let scmd = user_msg_adapter.GetSCMD(33187)
				if (scmd.errcode == 1) {
					// yoyo_model.shake_times = scmd.shake_times
					// yoyo_model.Fire(local_YoYoModelEvent.TIME_RETURN)
				} else if (scmd.errcode != 1012) {
					Util.ErrorCodeShow(scmd.errcode)
				}
			}

			let On33188 = () => {
				let scmd = user_msg_adapter.GetSCMD(33188)
				//cost_rank_model.setRankData(scmd)
			}

			let On33189 = () => {
				let scmd = user_msg_adapter.GetSCMD(33189)
				//cost_rank_model.setRewardData(scmd)
			}

			let On33120 = () => {
				let scmd = user_msg_adapter.GetSCMD(33120)
				this.model.SetActData(scmd)
				this.model.Fire(custom_event.UPDATE_VIEW, scmd.base_type, scmd.sub_type)
			}

			let On33121 = () => {
				let scmd = user_msg_adapter.GetSCMD(33121)
				Util.ErrorCodeShow(scmd.errcode)
				let b = scmd.base_type
				let s = scmd.sub_type
				this.model.act_key_dic[b] = this.model.act_key_dic[b] || {}
				this.model.act_key_dic[b][s] = this.model.act_key_dic[b][s] || {}
				// [ts2lua]this.model.act_key_dic[b][s]下标访问可能不正确
				this.model.act_key_dic[b][s]["egg_refresh"] = false
				if (scmd.errcode == 1) {
					this.model.Fire(custom_event.SCMD_REQUEST, 33120, b, s)
				}
			}

			let On33122 = () => {
				let scmd = user_msg_adapter.GetSCMD(33122)
				if (scmd.errcode != 1) {
					Util.ErrorCodeShow(scmd.errcode)
					return
				}
				// [ts2lua]scmd下标访问可能不正确
				scmd["error_code"] = scmd.errcode
				this.model.SetActResult(scmd)
			}

			let On33123 = () => {
				let scmd = user_msg_adapter.GetSCMD(33123)
				if (scmd.errcode != 1) {
					Util.ErrorCodeShow(scmd.errcode)
					return
				}
				// [ts2lua]scmd下标访问可能不正确
				scmd["error_code"] = scmd.errcode
				this.model.SetActResult(scmd)
			}

			let On33190 = () => {
				let scmd = user_msg_adapter.GetSCMD(33190)
				if (scmd.error_code != 1) {
					if (scmd.error_code != 1012 && scmd.error_code != 3310043) {
						Util.ErrorCodeShow(scmd.error_code)
					}
					return
				}
				this.model.SetActData(scmd)
				this.model.Fire(custom_event.UPDATE_VIEW, scmd.base_type, scmd.sub_type)
			}

			let On33191 = () => {
				let scmd = user_msg_adapter.GetSCMD(33191)
				if (scmd.error_code != 1) {
					if (scmd.error_code != 1012) {
						Util.ErrorCodeShow(scmd.error_code)
					}
					return
				}
				this.model.SetActResult(scmd)
			}

			let On33192 = () => {
				let scmd = user_msg_adapter.GetSCMD(33192)
				if (scmd.error_code != 1) {
					if (scmd.error_code != 1012) {
						Util.ErrorCodeShow(scmd.error_code)
					}
					return
				}
				this.model.SetActResult(scmd)
			}

			let On33168 = () => {
				let scmd = user_msg_adapter.GetSCMD(33168)
				if (scmd.error_code != 1) {
					if (scmd.error_code != 1012) {
						Util.ErrorCodeShow(scmd.error_code)
					}
					return
				}
				let data = this.model.GetActData(scmd.base_type, scmd.sub_type)
				if (!data || !data.shop) {
					return
				}
				data.score = scmd.score
				for (let _tmpi in data.shop) {
					var v = data.shop[_tmpi]
					if (v && v.grade_id == scmd.grade_id) {
						v.num = scmd.num
					}
				}
				this.model.Fire(custom_event.RECEIVE_SUCCESS, scmd.base_type, scmd.sub_type, scmd, 33168)
				Util.ShowCongratulationView(scmd.reward)
			}

			let On33193 = () => {
				let scmd = user_msg_adapter.GetSCMD(33193)
				let data = this.model.GetActData(scmd.base_type, scmd.sub_type)
				if (data) {
					data["person_times"] = scmd.person_times
					data["server_times"] = scmd.server_times
					for (let _tmpi in scmd.ser_reward_list) {
						var v = scmd.ser_reward_list[_tmpi]
						for (let _tmpi in data.reward_list) {
							var vo = data.reward_list[_tmpi]
							if (vo.grade == v.grade_id) {
								vo["trigger_type"] = v.trigger_type
								vo["param"] = v.param
								vo["times"] = v.times
								vo["reward"] = v.reward
								vo["status"] = v.status
								break
							}
						}
					}
				}
				this.model.SetActData(data)
				data = this.model.GetActData(scmd.base_type, scmd.sub_type)
				this.model.FTVActivenessAllReward(data)
				let material = this.model.GetActivenessStatus("331@56" + DungeonEnterView.Index.Material)
				let material_115 = this.model.GetActivenessStatus(CustomActivityModel.MATIAL_ICON_115)
				let exp = this.model.GetActivenessStatus("331@56" + DungeonEnterView.Index.Exp)
				// //local_GlobalEventSystem:Fire(ActivityIconManager.UPDATE_EFFECT, 610, "ui_activity", material || exp, false, {x=30, y=30})
				dungeon_model.Fire(BaseDungeonModel.UPDATE_ACTIVITY)
				this.model.Fire(custom_event.UPDATE_VIEW, scmd.base_type, scmd.sub_type, 33193)
			}

			//节日活跃提交
			let On33194 = () => {
				let scmd = user_msg_adapter.GetSCMD(33194)
				if (scmd.error_code != 1) {
					Util.ErrorCodeShow(scmd.error_code)
					return
				}
				if (scmd.cost_type == 1) {
					local_Message.show("提交成功")
				}
				this.model.SetActResult(scmd)
			}

			//节日活跃领取（个人
			let On33195 = () => {
				let scmd = user_msg_adapter.GetSCMD(33195)
				if (scmd.error_code != 1) {
					Util.ErrorCodeShow(scmd.error_code)
					return
				}
				this.model.SetActResult(scmd)
			}

			//节日活跃全服次数广播
			let On33196 = () => {
				let scmd = user_msg_adapter.GetSCMD(33196)
				let data = this.model.GetActData(scmd.base_type, scmd.sub_type)
				if (data) {
					data.server_times = scmd.server_times
					for (let i in scmd.trigger_type_list) {

						if (scmd.trigger_type_list[i].trigger_type == 3) {
							// boss_base_model.Fire(local_BossBaseModel.SCMD_REQUEST, 46000, boss_type.abyss)
							// boss_base_model.Fire(local_BossBaseModel.SCMD_REQUEST, 46000, boss_type.secret)
							// boss_base_model.Fire(local_BossBaseModel.SCMD_REQUEST, 46000, boss_type.field)
							// boss_base_model.Fire(local_BossBaseModel.SCMD_REQUEST, 46000, boss_type.fieldspecial)
						}
					}
					if (scmd.is_ask && scmd.is_ask != 0) {
						this.model.Fire(custom_event.SCMD_REQUEST, 33193, scmd.base_type, scmd.sub_type)
						return
					}
				}
			}

			let On33140 = () => {
				let scmd = user_msg_adapter.GetSCMD(33140)
				this.model.Fire(custom_event.UPDATE_HOTPOINT, scmd)
			}

			let On33197 = () => {
				let scmd = user_msg_adapter.GetSCMD(33197)
				this.model.Fire(custom_event.UP_LOG_LIST, scmd)
			}

			let On33198 = () => {
				let scmd = user_msg_adapter.GetSCMD(33198)
				if (scmd.errcode == 1) {
					//yoyo_model.setRecordData(scmd)
				}
			}

			let On33199 = () => {
				let scmd = user_msg_adapter.GetSCMD(33199)
				//yoyo_model.addRecordData(scmd)
			}

			let On33203 = () => {
				let scmd = user_msg_adapter.GetSCMD(33203)
				//cost_rank_model.setkfRankData(scmd)
			}

			let On33204 = () => {
				let scmd = user_msg_adapter.GetSCMD(33204)
				//cost_rank_model.setkfRewardData(scmd)
			}

			let On33179 = () => {
				let scmd = user_msg_adapter.GetSCMD(33179)
				if (scmd.error_code != 1) {
					Util.ErrorCodeShow(scmd.error_code)
					return
				}
				this.model.SetActResult(scmd)
				this.model.Fire(custom_event.SCMD_REQUEST, 33104, scmd.base_type, scmd.sub_type)
			}

			let On33205 = () => {
				let scmd = user_msg_adapter.GetSCMD(33205)
				this.model.SetActData(scmd)
			}

			let On33206 = () => {
				let scmd = user_msg_adapter.GetSCMD(33206)
				if (scmd.error_code != 1) {
					Util.ErrorCodeShow(scmd.error_code)
					return
				}
				this.model.SetActResult(scmd)
			}

			let On33207 = () => {
				let scmd = user_msg_adapter.GetSCMD(33207)
				if (scmd.error_code != 1) {
					Util.ErrorCodeShow(scmd.error_code)
					return
				}
				this.model.SetActResult(scmd)
			}

			let On33208 = () => {
				let scmd = user_msg_adapter.GetSCMD(33208)
				this.model.Fire(custom_event.UPDATE_VIEW, scmd.base_type, scmd.sub_type, 33208, scmd)
			}

			let On33165 = () => {
				let scmd = user_msg_adapter.GetSCMD(33165)
				this.model.SetActData(scmd)
				this.model.Fire(custom_event.UPDATE_VIEW, scmd.base_type, scmd.sub_type)
			}

			let On33166 = () => {
				let scmd = user_msg_adapter.GetSCMD(33166)
				if (scmd.error_code != 1) {
					Util.ErrorCodeShow(scmd.error_code)
					return
				}
				this.model.SetActResult(scmd)
			}

			let On33167 = () => {
				let scmd = user_msg_adapter.GetSCMD(33167)
				if (scmd.error_code != 1) {
					Util.ErrorCodeShow(scmd.error_code)
					return
				}
				this.model.SetActResult(scmd)
			}

			let On33130 = () => {
				let scmd = user_msg_adapter.GetSCMD(33130)
				TurnTableModel.GetInstance().turnTableViewData(scmd)
				this.model.SetActData(scmd)
			}

			let On33131 = () => {
				let scmd = user_msg_adapter.GetSCMD(33131)
				TurnTableModel.GetInstance().startReturnData(scmd)
			}

			let On33132 = () => {
				let scmd = user_msg_adapter.GetSCMD(33132)
				TurnTableModel.GetInstance().recordData(scmd)
			}

			let On33209 = () => {
				let scmd = user_msg_adapter.GetSCMD(33209)
				this.model.Fire(custom_event.UP_DAILY_SUPPLY, scmd.liveness)
			}

			let On33211 = () => {
				let scmd = user_msg_adapter.GetSCMD(33211)
				let b = scmd.base_type
				let s = scmd.sub_type
				let info = this.model.GetActInfo(b, s)
				if (!info) {
					return
				}
				let cond = this.model.GetActCondition(b, s, "info")
				if (!cond) {
					return
				}
				let buy_day = Number(cond.buy_day)
				let can_buy = KaifuActivityModel.GetInstance().fullShowIconTime(Number(info.stime), buy_day)
				if (!can_buy && scmd.investments.length == 0) {
					let vo = []
					table.insert(vo, info)
					this.model.DeleteActInfo(vo)
					let index = this.model.cache_scmd_33101_list.length - 1
					do {
						// [ts2lua]this.model.cache_scmd_33101_list下标访问可能不正确
						let v = this.model.cache_scmd_33101_list[index]
						if (v.base_type == vo[0].base_type && v.sub_type == vo[0].sub_type) {
							this.model.cache_scmd_33101_list.splice(index, 1)
							return
						}
						index = index - 1
					} while ((index >= 0))
				}
				this.model.act_key_dic[b] = this.model.act_key_dic[b] || {}
				this.model.act_key_dic[b].sub_type = scmd.sub_type
				this.model.act_key_dic[b][s] = this.model.act_key_dic[b][s] || {}
				// [ts2lua]this.model.act_key_dic[b][s]下标访问可能不正确
				this.model.act_key_dic[b][s]["investments"] = scmd.investments
				this.model.act_key_dic[b][s]["buy_time"] = scmd.buy_time
				let bool = scmd.investments && scmd.investments.length > 0
				let etime = info.etime
				if (!bool) {
					etime = scmd.buy_time
				}
				if(etime > TimeUtil.getServerTime()){
					ActivityIconManager.GetInstance().addIcon(
						"331@62@1",etime
					)
				}else{
					ActivityIconManager.GetInstance().deleteIcon("331@62@1")
				}
				
				this.model.Fire(custom_event.SCMD_REQUEST, 33104, b, s)
			}

			let On33212 = () => {
				let scmd = user_msg_adapter.GetSCMD(33212)
				if (scmd.error_code != 1) {
					Util.ErrorCodeShow(scmd.error_code)
					return
				}
				this.model.RequireActInfo(scmd.base_type, scmd.sub_type)
				let rewardsList = GoodsModel.RewardKeyToNumber(scmd.reward_list)
				let view = new CongratulationObtainView(rewardsList, 10)
				view.Open()
			}

			let On33215 = () => {
				let scmd = user_msg_adapter.GetSCMD(33215)
				let b = scmd.base_type
				let s = scmd.sub_type
				if (scmd.error_code != 1) {
					Util.ErrorCodeShow(scmd.error_code)
					this.model.act_key_dic[b] = this.model.act_key_dic[b] || {}
					this.model.act_key_dic[b][s] = this.model.act_key_dic[b][s] || {}
					this.model.act_key_dic[b][s]["require_dis"] = false
					return
				}
				let cond = this.model.GetActCondition(b, s, "data", scmd.grade)
				if (!cond) {
					return
				}
				cond.now_cost[0][0] = scmd.now_cost[0].style
				cond.now_cost[0][1] = scmd.now_cost[0].typeId
				cond.now_cost[0][2] = scmd.now_cost[0].count
				let data = this.model.GetActData(b, s)
				if (data && data.reward_list) {
					for (let _tmpi in data.reward_list) {
						var v = data.reward_list[_tmpi]
						if (v.grade == scmd.grade) {
							v.status = 1
							break
						}
					}
				}
				this.model.Fire(custom_event.RECEIVE_SUCCESS, scmd)
				this.model.SetRedDotValue(-1, b, s)
				this.model.RefreshIconRed(b, s)
			}

			let On33176 = () => {
				let scmd = user_msg_adapter.GetSCMD(33176)
				if (scmd.error_code != 1) {
					Util.ErrorCodeShow(scmd.error_code)
					return
				}
				this.model.SetActResult(scmd)
			}

			let On33177 = () => {
				let scmd = user_msg_adapter.GetSCMD(33177)
				this.model.SetActData(scmd)
				this.model.Fire(custom_event.UPDATE_VIEW, scmd.base_type, scmd.sub_type)
			}

			let On22400 = () => {
				let scmd = user_msg_adapter.GetSCMD(22400)
				if (scmd.code != 1) {
					Util.ErrorCodeShow(scmd.code)
				}
			}

			let On22403 = () => {
				let scmd = user_msg_adapter.GetSCMD(22403)
				this.model.Fire(custom_event.UPDATE_VIEW, scmd.type, scmd.sub_type, scmd)
				FlowerrankModel.GetInstance().SetFlowerRankData(scmd)
			}

			let On33128 = () => {
				let scmd = user_msg_adapter.GetSCMD(33128)
				this.model.SetActData(scmd)
				this.model.Fire(custom_event.UPDATE_VIEW, scmd.base_type, scmd.sub_type)
			}

			let On33129 = () => {
				let scmd = user_msg_adapter.GetSCMD(33129)
				if (scmd.error_code != 1) {
					Util.ErrorCodeShow(scmd.error_code)
					return
				}
				local_Message.show("奖池锁定成功")
				let data = this.model.GetActData(scmd.base_type, scmd.sub_type)
				if (data) {
					data.pool = scmd.pool
				}
				this.model.SetActData(data)
				this.model.Fire(custom_event.UPDATE_VIEW, scmd.base_type, scmd.sub_type, 33129)
			}

			let On33133 = () => {
				let scmd = user_msg_adapter.GetSCMD(33133)
				if (scmd.error_code != 1) {
					Util.ErrorCodeShow(scmd.error_code)
					return
				}
				let data = this.model.GetActData(scmd.base_type, scmd.sub_type)
				if (data) {
					data.draw_times = scmd.draw_times
					data.reset = scmd.reset
					data.pool = scmd.pool
					data.stage = scmd.stage
				}
				this.model.SetActData(data)
				this.model.Fire(custom_event.UPDATE_VIEW, scmd.base_type, scmd.sub_type)
			}

			let On33134 = () => {
				let scmd = user_msg_adapter.GetSCMD(33134)
				if (scmd.error_code != 1) {
					Util.ErrorCodeShow(scmd.error_code)
					this.model.setKeyDicValue(scmd.base_type, scmd.sub_type, "is_draw", false)
					return
				}
				this.model.SetActResult(scmd)
			}

			let On33135 = () => {
				let scmd = user_msg_adapter.GetSCMD(33135)
				if (scmd.error_code != 1) {
					Util.ErrorCodeShow(scmd.error_code)
					return
				}
				this.model.SetActResult(scmd)
			}

			let On33139 = () => {
				let scmd = user_msg_adapter.GetSCMD(33139)
				let data = this.model.GetActData(scmd.base_type, scmd.sub_type)
				if (data) {
					data.random_pool = scmd.pool
				}
				this.model.Fire(custom_event.UPDATE_VIEW, scmd.base_type, scmd.sub_type, 33139)
			}

			let On33115 = () => {
				let scmd = user_msg_adapter.GetSCMD(33115)
				if (scmd.code != 1) {
					Util.ErrorCodeShow(scmd.code)
					return
				}
				let base_type = cfg_custom_activity.ACT_ID.actMarriage
				let sub_type = scmd.sub_type
				// [ts2lua]scmd下标访问可能不正确
				scmd["base_type"] = base_type
				let is_add = this.model.getKeyDicValue(base_type, sub_type, "is_add")
				let data = this.model.GetActData(base_type, scmd.sub_type) || scmd
				if (!is_add) {
					this.model.setKeyDicValue(base_type, scmd.sub_type, "data", data)
				}
				if (scmd.opr == 2) {
					scmd.wedding_type_list = data.wedding_type_list
				}
				this.model.SetActData(scmd)
				this.model.Fire(custom_event.UPDATE_VIEW, base_type, sub_type)
			}

			let On33216 = () => {
				let scmd = user_msg_adapter.GetSCMD(33216)
				let info = this.model.GetActInfoByShowID(77, 0)
				this.model.RefreshIconRed(info.base_type, info.sub_type)
				this.model.Fire(custom_event.UP_BETA_RECHARGE, scmd)
			}

			let On33141 = () => {
				let scmd = user_msg_adapter.GetSCMD(33141)
				let data = this.model.GetActData(scmd.base_type, scmd.sub_type)
				let list = scmd.rare_pool
				table.sort(list, (a?, b?) => {
					return a.grade < b.grade
				})
				if (data) {
					data["rare_pool"] = scmd.rare_pool
				}
				this.model.SetActRedDot(data.base_type, data.sub_type)
				this.model.RefreshIconRed(data.base_type, data.sub_type)
				this.model.Fire(custom_event.UPDATE_VIEW, scmd.base_type, scmd.sub_type)
			}

			let On33142 = () => {
				let scmd = user_msg_adapter.GetSCMD(33142)
				if (scmd.error_code != 1) {
					Util.ErrorCodeShow(scmd.error_code)
					return
				}
				this.model.SetActResult(scmd)
			}

			let On33144 = () => {
				let scmd = user_msg_adapter.GetSCMD(33144)
				if (scmd.code != 1) {
					Util.ErrorCodeShow(scmd.code)
					return
				}
				let data = this.model.GetActData(scmd.base_type, scmd.sub_type)
				if (data) {
					for (let _tmpi in data.rare_pool) {
						var vo = data.rare_pool[_tmpi]
						if (vo.grade == scmd.grade) {
							vo.lucky_value = scmd.lucky_value
							vo.free_times = scmd.free_times
							vo.state = scmd.state
							vo.max_luckey_value = scmd.max_luckey_value
						}
					}
				}
				this.model.Fire(custom_event.WISH_POOL_RESET, scmd.base_type, scmd.sub_type)
			}

			let On33213 = () => {
				let scmd = user_msg_adapter.GetSCMD(33213)
				if (scmd.error_code != 1) {
					Util.ErrorCodeShow(scmd.error_code)
					return
				}
				let data = this.model.GetActData(scmd.base_type, scmd.sub_type)
				if (data) {
					data.pool = scmd.pool
				}
				this.model.Fire(custom_event.UPDATE_VIEW, scmd.base_type, scmd.sub_type, 33213)
			}

			let On33214 = () => {
				let scmd = user_msg_adapter.GetSCMD(33214)
				if (scmd.error_code != 1) {
					Util.ErrorCodeShow(scmd.error_code)
					return
				}
				this.model.Fire(custom_event.ANSWER_TARGET, scmd.base_type, scmd.sub_type, scmd)
			}

			let On33217 = () => {
				let scmd = user_msg_adapter.GetSCMD(33217)
				if (scmd.error_code != 1) {
					Util.ErrorCodeShow(scmd.error_code)
					return
				}
				this.model.SetActData(scmd)
				this.model.Fire(custom_event.UPDATE_VIEW, scmd.base_type, scmd.sub_type)
			}

			let On33218 = () => {
				let scmd = user_msg_adapter.GetSCMD(33218)
				this.model.setKeyDicValue(scmd.base_type, scmd.sub_type, "data", scmd)
				this.model.SetActRedDot(scmd.base_type, scmd.sub_type)
				this.model.RefreshIconRed(scmd.base_type, scmd.sub_type)
				this.model.Fire(custom_event.ACT_TURNTABLE_RECORD_RETURN, scmd.base_type, scmd.sub_type, scmd)
			}

			let On33219 = () => {
				let scmd = user_msg_adapter.GetSCMD(33219)
				if (scmd.error_code == 1) {
					this.model.Fire(custom_event.ACT_TURNTABLE_REWARD, scmd.base_type, scmd.sub_type, scmd)
					this.model.SetActRedDot(scmd.base_type, scmd.sub_type)
					this.model.RefreshIconRed(scmd.base_type, scmd.sub_type)
				} else {
					Util.ErrorCodeShow(scmd.error_code)
				}
			}

			let On33220 = () => {
				let scmd = user_msg_adapter.GetSCMD(33220)
				if (scmd.error_code != 1) {
					if (scmd.error_code != 1012 && scmd.error_code != 3310043) {
						Util.ErrorCodeShow(scmd.error_code)
					}
					return
				}
				this.model.Fire(CustomActivityDefine.EVENT.ACT_TURNTABLE_RETURN, scmd)
				this.model.SetActRedDot(scmd.base_type, scmd.sub_type)
				this.model.RefreshIconRed(scmd.base_type, scmd.sub_type)
			}

			let On33221 = () => {
				let scmd = user_msg_adapter.GetSCMD(33221)
				if (scmd.error_code != 1) {
					if (scmd.error_code != 1012 && scmd.error_code != 3310043) {
						Util.ErrorCodeShow(scmd.error_code)
					}
					return
				}
				this.model.SetActData(scmd)
				this.model.Fire(custom_event.UPDATE_VIEW, scmd.base_type, scmd.sub_type)
			}

			let On33222 = () => {
				let scmd = user_msg_adapter.GetSCMD(33222)
				if (scmd.error_code != 1) {
					if (scmd.error_code != 1012) {
						Util.ErrorCodeShow(scmd.error_code)
					}
					return
				}
				this.model.SetActResult(scmd)
			}

			let On33155 = () => {
				let scmd = user_msg_adapter.GetSCMD(33155)
				scmd.base_type = cfg_custom_activity.ACT_ID.RED_PACKET_RAIN
				this.model.redpacket_rain_subtype = scmd.sub_type
				table.sort(scmd.wave_receive, (a?, b?) => {
					return a.wave2 > b.wave2
				}
				)
				this.model.SetActData(scmd)
				this.model.Fire(custom_event.UPDATE_VIEW, scmd.base_type, scmd.sub_type, scmd)
				let cur_time = TimeUtil.getServerTime()
				if (scmd.wave >= 2) {
					let time_cond = this.model.GetActCondition(scmd.base_type, scmd.sub_type, "info")
					if (time_cond && time_cond["rain_time"]) {
						time_cond = time_cond["rain_time"]
						let gap = time_cond[3]
						let wave_count = time_cond[2]
						let etime = (wave_count - scmd.wave + 1) * gap + scmd.start_time
						this.model.Fire(custom_event.REFRESHCOUNTDOWN, "331@14", etime, true)
						if (this.model.rpr_icon_mark) {
							this.model.rpr_icon_mark = false
							let is_over_time = scmd.start_time <= cur_time
							// [ts2lua]lua中0和空字符串也是true，此处scmd.wave == wave_count && is_over_time需要确认
							let wave = (scmd.wave == wave_count && is_over_time && (scmd.wave) || (scmd.wave - 1))
							let mark = true
							for (let _tmpi in scmd.wave_receive) {
								var vo = scmd.wave_receive[_tmpi]
								if (vo.wave2 == wave) {
									mark = false
									let show = vo.is_receive == 0
									this.model.SetRPRCurData({ wave: wave, sub_type: scmd.sub_type })
									this.model.Fire(custom_event.WAVE_RED_PACKET, show)
									break
								}
							}
							if (mark) {
								this.model.SetRPRCurData({ wave: wave, sub_type: scmd.sub_type })
								this.model.Fire(custom_event.WAVE_RED_PACKET, true)
							}
						}
					}
					// [ts2lua]time_cond下标访问可能不正确

				} else {
					let ainfo = this.model.GetActInfo(scmd.base_type, scmd.sub_type)
					let cdate = new Date(cur_time * 1000)
					let sdate = new Date(scmd.start_time * 1000)
					let adate = new Date(ainfo.stime * 1000)
					let first_day = adate.getDay() == cdate.getDay()
					let today = sdate.getDay() == cdate.getDay()
					// [ts2lua]lua中0和空字符串也是true，此处scmd.clear_type == 2需要确认
					let hour = (scmd.clear_type == 2 && (4) || (0))
					let clear_time = TimeUtil.GetTimeFutureZeroStamp(scmd.start_time, 0, hour)
					let tsvar_end = (scmd.start_time == 0 || !first_day && cur_time < clear_time) || first_day && !today
					if (tsvar_end) {
						let str = "已结束"
						local_GlobalEventSystem.Fire(ActivityIconManager.SET_ICON_TEXT, "331@14", str, "#ff4f50")
					} else {
						let val_cond = this.model.GetActCondition(scmd.base_type, scmd.sub_type, "info")
						// [ts2lua]val_cond下标访问可能不正确
						val_cond = val_cond["rain_value"]
						// [ts2lua]lua中0和空字符串也是true，此处val_cond需要确认
						let val = (val_cond && (val_cond[2]) || (0))
						let can_start = scmd.act_value >= val
						if (can_start) {
							this.model.Fire(custom_event.REFRESHCOUNTDOWN, "331@14", scmd.start_time, true, "#88ff43")
						} else {
							let str = "未激活"
							local_GlobalEventSystem.Fire(ActivityIconManager.SET_ICON_TEXT, "331@14", str, "#ff4f50")
						}
					}
				}
			}

			let On33157 = () => {
				let scmd = user_msg_adapter.GetSCMD(33157)
				this.model.Fire(custom_event.UPDATE_RED_PACKET, scmd)
				if (scmd.errcode == 1) {
					let base_type = cfg_custom_activity.ACT_ID.RED_PACKET_RAIN
					let adata = this.model.GetActData(base_type, scmd.sub_type)
					if (!adata) {
						return
					}
					adata.wave = scmd.wave
					adata.start_time = scmd.start_time
					for (let _tmpi in adata.wave_receive) {
						var vo = adata.wave_receive[_tmpi]
						if (vo.wave2 == scmd.wave) {
							vo.is_receive = 1
							break
						}
					}
					this.model.SetActData(adata)
				} else {
					Util.ErrorCodeShow(scmd.errcode)
				}
			}

			let On33158 = () => {
				let scmd = user_msg_adapter.GetSCMD(33158)
				this.model.SetRPRCurData(scmd)
				this.model.Fire(custom_event.WAVE_RED_PACKET, scmd.wave != 0)
				if (scmd.wave == 1) {
					this.SendFmtToGame(33155, "h", scmd.sub_type)
				}
			}

			let On33223 = () => {
				let scmd = user_msg_adapter.GetSCMD(33223)
				this.model.Fire(custom_event.ACT_TFIRST_BLOOD_RETURN, scmd)
			}

			let On22405 = () => {
				let scmd = user_msg_adapter.GetSCMD(22405)
				this.model.Fire(custom_event.UPDATE_VIEW, scmd.type, scmd.sub_type, scmd)
			}

			let On33224 = () => {
				let scmd = user_msg_adapter.GetSCMD(33224)
				this.model.SetActData(scmd)
				this.model.Fire(custom_event.UPDATE_VIEW, scmd.base_type, scmd.sub_type)
			}

			let On33225 = () => {
				// let scmd = user_msg_adapter.GetSCMD(33225)
				// if (scmd.error_code != 1 ) {
				// 	Util.ErrorCodeShow(scmd.error_code)
				// 	if (scmd.error_code == 3310062 ) {
				// 		FortuneCatModel.GetInstance().act_time = false
				// 	}
				// 	return
				// }
				// this.model.SetActResult(scmd)
			}

			let On33226 = () => {
				// let scmd = user_msg_adapter.GetSCMD(33226)
				// FortuneCatModel.GetInstance().SetRecordData(scmd)
			}

			let On33227 = () => {
				let scmd = user_msg_adapter.GetSCMD(33227)
				let data = this.model.GetActData(scmd.base_type, scmd.sub_type)
				if (data) {
					data.gp_goods = scmd.gp_goods
					data.last_shout_time = scmd.last_shout_time
					this.model.SetActData(data)
					if(!this.model.CheckGroupBuyIsTimeOut(scmd.base_type, scmd.sub_type)){
						ActivityIconManager.GetInstance().deleteIcon("331@88@0")
					}
				}
				this.model.Fire(custom_event.UPDATE_VIEW, scmd)
			}

			let On33228 = () => {
				let scmd = user_msg_adapter.GetSCMD(33228)
				this.model.Fire(custom_event.UP_LOG_LIST, scmd)
			}

			let On33229 = () => {
				let scmd = user_msg_adapter.GetSCMD(33229)
				if (scmd.error_code != 1) {
					Util.ErrorCodeShow(scmd.error_code)
				}
				else {
					this.model.SetActResult(scmd)
					let list = scmd.reward_list
					if (list.length) {
						Util.ShowCongratulationView(list, 10)
					} else {
						Message.show("订购成功")
					}
				}
			}

			let On33230 = () => {
				let scmd = user_msg_adapter.GetSCMD(33230)
				let data = this.model.GetActData(scmd.base_type, scmd.sub_type)
				if (data && data.gp_goods) {
					for (let _tmpi in data.gp_goods) {
						var v = data.gp_goods[_tmpi]
						if (v.grade_id == scmd.grade_id) {
							v.buy_num = scmd.buy_num
							break
						}
					}
				}
				this.model.Fire(custom_event.ANSWER_TARGET, scmd.base_type, scmd.sub_type)
			}

			let On33267 = () => {
				let scmd = user_msg_adapter.GetSCMD(33267)
				if (scmd.code != 1) {
					Util.ErrorCodeShow(scmd.error_code)
				}
				let data = this.model.GetActData(scmd.type, scmd.subtype)
				if (data) {
					data.last_shout_time = scmd.last_shout_time
					this.model.SetActData(data)
				}
				this.model.Fire(custom_event.UPDATE_GROUP_BUY_SPEAK_TIME, scmd)
			}

			let On33231 = () => {
				let scmd = user_msg_adapter.GetSCMD(33231)
				let data = this.model.GetActData(scmd.base_type, scmd.sub_type)
				if (data) {
					data.currency = scmd.currency
				}
				this.model.Fire(custom_event.UPDATE_VIEW, scmd.base_type, scmd.sub_type, 33231)
			}

			let On33236 = () => {
				let scmd = user_msg_adapter.GetSCMD(33236)
				if (scmd.error_code ) {
					this.model.Fire(custom_event.SCMD_REQUEST, 33104, QuestionNaireModel.QUESTIONNAIRE_ACT_BASE_TYPE, scmd.question_type)
				}
			}

			let On33238 = () => {
				let scmd = user_msg_adapter.GetSCMD(33238)
				
				this.model.SetActData(scmd)
				this.model.Fire(custom_event.UPDATE_VIEW, scmd.base_type, scmd.sub_type)
				this.model.CheckOpenDesTinyView()
				GlobalEventSystem.Fire(ActivityIconManager.UPDATE_SINGLE_ICON, '331@99@1')
			}

			let On33239 = () => {
				let scmd = user_msg_adapter.GetSCMD(33239)
				let actData = this.model.GetActData(scmd.base_type, scmd.sub_type)
				if (!actData) { return }
				actData.turn = scmd.turn
				actData.point = scmd.point
				actData.need_point = scmd.need_point
				this.model.SetActRedDot(scmd.base_type, scmd.sub_type)
				this.model.RefreshIconRed(scmd.base_type, scmd.sub_type)
				this.model.Fire(custom_event.DESTINY_TURNTABLE_INTEGRAL)
				this.model.CheckOpenDesTinyView()
			}

			let On33240 = () => {
				let scmd = user_msg_adapter.GetSCMD(33240)
				if (scmd.error_code != 1) {
					Util.ErrorCodeShow(scmd.error_code)
				} else {
					let actData = this.model.GetActData(scmd.base_type, scmd.sub_type)
					actData.turn = scmd.turn
					actData.point = scmd.point
					actData.need_point = scmd.need_point
					let index = 1
					for (let i in actData.reward_list) {
						var reward = actData.reward_list[i]
						if (reward.grade == scmd.grade_id) {
							reward.status = 1;
							index = scmd.grade_id;
							break
						}
						
					}
					this.model.SetActRedDot(scmd.base_type, scmd.sub_type)
					this.model.RefreshIconRed(scmd.base_type, scmd.sub_type)
					this.model.Fire(custom_event.DESTINY_TURNTABLE_RUN, index, scmd.reward)
				}
			}

			let On33241 = () => {
				let scmd = user_msg_adapter.GetSCMD(33241)
				this.model.SetActData(scmd)
				this.model.Fire(custom_event.UPDATE_VIEW, scmd.base_type, scmd.sub_type)
			}

			let On33242 = () => {
				let scmd = user_msg_adapter.GetSCMD(33242)
				let data = this.model.GetActData(scmd.base_type, scmd.sub_type)
				if (data) {
					for (let k in data.reward_list) {
						let v = data.reward_list[k]
						for (let k1 in scmd.reward_list) {
							let v1 = scmd.reward_list[k1]
							if (v.grade == v1.grade) {
								v.process = v1.process
								if (v.status == 0) {
									let cond = this.model.GetActCondition(scmd.base_type, scmd.sub_type, "data", v.grade)
									if (cond && cond.treasure_hunt && cond.treasure_hunt[2]) {
										if (v.process >= Number(cond.treasure_hunt[2])) {
											v.status = 1
										}
									}
								}
							}
						}
					}
				}
				this.model.SetActData(data)
				this.model.Fire(custom_event.UP_GRADE, scmd.base_type, scmd.sub_type, scmd)
			}

			let On22601 = () => {
				// let scmd = user_msg_adapter.GetSCMD(22601)
				// let base_type = cfg_custom_activity.ACT_ID.FIGHT_RANK
				// FightRankModel.GetInstance().SetViewData(scmd)
				// this.model.Fire(custom_event.UPDATE_VIEW, base_type, scmd.sub_type)
			}

			let On22602 = () => {
				// let scmd = user_msg_adapter.GetSCMD(22602)
				// let base_type = cfg_custom_activity.ACT_ID.FIGHT_RANK
				// FightRankModel.GetInstance().SetRewardStateData(scmd)
				// this.model.Fire(custom_event.UPDATE_VIEW, base_type, scmd.sub_type)
				// this.model.SetActRedDot(base_type, scmd.sub_type)
				// this.model.RefreshIconRed(base_type, scmd.sub_type)
			}

			let On22603 = () => {
				// let scmd = user_msg_adapter.GetSCMD(22603)
				// if (scmd.code == 1 ) {
				// 	let base_type = cfg_custom_activity.ACT_ID.FIGHT_RANK
				// 	FightRankModel.GetInstance().RewardReturn(scmd)
				// 	this.model.Fire(custom_event.UPDATE_VIEW, base_type , scmd.sub_type)
				// 	this.model.SetActRedDot(base_type, scmd.sub_type)
				// 	this.model.RefreshIconRed(base_type, scmd.sub_type)
				// }else{
				// 	Util.ErrorCodeShow(scmd.code)
				// }
			}
			// let On33216 = () => {
			// 	let scmd = user_msg_adapter.GetSCMD(33216)
			// 	GlobalEventSystem.Fire(EventName.OPEN_VIEW, "RechargeBackView", scmd)
			// }
			let On33243 = () => {
				let scmd = user_msg_adapter.GetSCMD(33243)
				this.model.SetActData(scmd)
				this.model.Fire(custom_event.UPDATE_VIEW, scmd.base_type, scmd.sub_type)
			}
			let On33244 = () => {
				let scmd = user_msg_adapter.GetSCMD(33244)
				if (scmd.error_code != 1) {
					Util.ErrorCodeShow(scmd.error_code)
					this.model.Fire(custom_event.STOP_AUTO, scmd.base_type, scmd.sub_type)
					return
				}
				if (scmd.reward && scmd.reward.length > 0 && (scmd.auto_buy == 0 || scmd.auto_buy == 2)) {
					let reward = GoodsModel.RewardKeyToNumber(scmd.reward)
					let cov = new CongratulationObtainView(reward)
					cov.Open()
				}

				if (scmd.reward && scmd.reward.length > 0 && scmd.auto_buy == 1) {
					let reward = GoodsModel.RewardKeyToNumber(scmd.reward)

					if (!lucky_reward_view) {
						let cov = new CongratulationObtainAutoView(scmd.base_type, scmd.sub_type)
						lucky_reward_view = cov
						lucky_reward_view.SetBtnData({
							text: "停止鉴宝", call_back_func: () => {
								this.model.Fire(custom_event.STOP_AUTO, scmd.base_type, scmd.sub_type, scmd.reward[0].typeId)
							}
						})
						cov.Open()
					}

					lucky_reward_view.SetGoodsData(reward)

					if (this.model.IsRareReward(reward)) {
						this.model.Fire(custom_event.STOP_AUTO, scmd.base_type, scmd.sub_type, scmd.reward[0].typeId)
						if (lucky_reward_view) {
							lucky_reward_view = null
						}

					}
				}
				this.model.Fire(custom_event.SCMD_REQUEST, 33243, scmd.base_type, scmd.sub_type)
			}

			let On33245 = () => {
				let scmd = user_msg_adapter.GetSCMD(33245)
				if (scmd.error_code && scmd.error_code != 1) {
					Util.ErrorCodeShow(scmd.error_code)
					return
				}
				this.model.SetActData(scmd)
				this.model.Fire(custom_event.UPDATE_VIEW, scmd.base_type, scmd.sub_type)
			}

			let On33246 = () => {
				let scmd = user_msg_adapter.GetSCMD(33246)
				if (scmd.error_code && scmd.error_code != 1) {
					this.model.Fire(custom_event.STOP_AUTO, scmd.base_type, scmd.sub_type)
					Util.ErrorCodeShow(scmd.error_code)
					return
				}

				let real_reward_list = []
				if (scmd.reward_list) {
					for (let _ in scmd.reward_list) {
						var reward_info = scmd.reward_list[_]
						let reward_tb = ErlangParser.GetInstance().Parse(reward_info.reward)
						if (reward_tb) {
							reward_tb = reward_tb[0]
						}
						if (reward_info.is_nice) {
							reward_tb[3] = reward_info.is_nice
							reward_tb.is_nice = reward_info.is_nice
						}
						table.insert(real_reward_list, reward_tb)
					}
				}

				if (real_reward_list && real_reward_list.length > 0 && (scmd.lucency_field != 1)) {
					let cov = new CongratulationObtainView(real_reward_list)
					cov.SetSpecType()
					cov.Open()
				} else if (scmd.lucency_field == 1) {
					this.model.ReceiveGashaponRewardList(real_reward_list, scmd.base_type, scmd.sub_type)
				}
				this.model.Fire(custom_event.SCMD_REQUEST, 33245, scmd.base_type, scmd.sub_type)
			}

			let On33247 = () => {
				let scmd = user_msg_adapter.GetSCMD(33247)
				this.model.SetActData(scmd)
				this.model.Fire(custom_event.UPDATE_VIEW, scmd.base_type, scmd.sub_type)
			}

			let On33248 = () => {
				let scmd = user_msg_adapter.GetSCMD(33248)
				// this.model.CheckLvLimitBreak(scmd)
			}

			let On33250 = () => {
				let scmd = user_msg_adapter.GetSCMD(33250)
				this.model.AdvertisingCdData(scmd.cd_lists)
				this.model.Fire(custom_event.SCMD_REQUEST, 33104, scmd.base_type, scmd.sub_type)
				// this.model.DelayGetAdCd(scmd.base_type, scmd.sub_type)
			}
			let On33251 = () => {
				let scmd = user_msg_adapter.GetSCMD(33251)
				this.model.Fire(CustomActivityDefine.EVENT.ADD_TOPPLAYER_TIP, scmd)
			}

			// 红包返利活动
			let On33255 = () => {
				let scmd = user_msg_adapter.GetSCMD(33255);
				RedEnvelopeRebateModel.GetInstance().actData = scmd;
				let time: number = scmd.end_time - TimeUtil.getServerTime();
				let conf = Config.PRELOAD_CLIENT_CONFIG.ClientRedBagOpen;
				let plat_name: string = PlatformManager.GetPlatformName();
				let channels: string[] = conf?.channels?.name.split(',');
				// let 
				if (scmd.is_quality && time > 0 && channels.indexOf(plat_name) != -1 && !PlatformManager.IsWXGameLink()) {
					ActivityIconManager.GetInstance().addIcon(
						RedEnvelopeRebateModel.ICON_TYPE,
					);
					RedEnvelopeRebateModel.GetInstance().Fire(RedEnvelopeRebateModelEvent.UPDATE_WITHDRAW_STATE);
					CustomActivityModel.GetInstance().SetActRedDot(scmd.type, scmd.subtype);
					CustomActivityModel.GetInstance().RefreshIconRed(scmd.type, scmd.subtype);
				} else {
					ActivityIconManager.GetInstance().deleteIcon(
						RedEnvelopeRebateModel.ICON_TYPE,
					);
				}

			}

			// 红包返现活动体现
			let On33256 = () => {
				let scmd = user_msg_adapter.GetSCMD(33256);
				if (scmd.errcode == 1) {
					Alert.Show("红包将在14个工作日内审核发放至账户<br>", Alert_Type.One, () => {
					}, undefined, "确定");
					RedEnvelopeRebateModel.GetInstance().actData.login_money = scmd.login_money;
					RedEnvelopeRebateModel.GetInstance().actData.recharge_money = scmd.recharge_money;
					RedEnvelopeRebateModel.GetInstance().actData.login_status = scmd.login_status;
					RedEnvelopeRebateModel.GetInstance().actData.recharge_status = scmd.recharge_status;
					RedEnvelopeRebateModel.GetInstance().Fire(RedEnvelopeRebateModelEvent.UPDATE_WITHDRAW_STATE);
					CustomActivityModel.GetInstance().SetActRedDot(scmd.type, scmd.subtype);
					CustomActivityModel.GetInstance().RefreshIconRed(scmd.type, scmd.subtype);
				} else {
					Util.ErrorCodeShow(scmd.errcode)
				}
			}

			let On33257 = () => {
				let scmd = user_msg_adapter.GetSCMD(33257);
				// let reward = CustomActivityModel.GetInstance().GetActReward(scmd.base_type, scmd.sub_type, 1, scmd.reward_list)
				let reward: { 0: number, 1: number, 2: number }[] = [];
				for (const iterator of scmd.reward_list) {
					reward.push({ 0: iterator.style, 1: iterator.goods_id, 2: iterator.num })
				}

				if (reward && reward.length) {
					let view = new CongratulationObtainView(reward, 10);
					view.Open();
				}


				let moneys = [];
				let ids: number[] = [31, 34, 35];

				//累充豪礼特殊处理 恭喜获得界面不需要飘字
				if(scmd.type == Config.PRELOAD_CLIENT_CONFIG.ConfigCustomActivity.ACT_ID.TIRED_CHARGE_POLITE){
					ids = []
				}

				for (const iterator of reward) {
					let [type_id_, lock_] = GoodsModel.GetInstance().GetMappingTypeId(iterator[0], iterator[1])
					if (ids.indexOf(type_id_) != -1) {
						moneys.push(iterator);
					}
				}
				if (moneys && moneys.length > 0) {
					let layer_mgr: LayerManager = LayerManager.GetInstance()
					let point = { x: layer_mgr.stageWidth / 2, y: layer_mgr.stageHeight / 2 };
					GlobalEventSystem.Fire(EventName.REWARD_FLY, moneys, point, undefined, undefined, 0, 0)
					// for (const iterator of moneys) {
					// 	let [type_id_, lock_] = GoodsModel.GetInstance().GetMappingTypeId(iterator[0], iterator[1])
					// 	GoodsModel.GetInstance().Fire(GoodsModel.REQUEST_CCMD_EVENT, 15050, "li", type_id_, iterator[2]);
					// }
				}

			}

			let On33258 = () => {
				let scmd = user_msg_adapter.GetSCMD(33258)
				this.model.SetCarnivalProgress(scmd.task_list)
				this.model.Fire(custom_event.SCMD_REQUEST, 33104, scmd.type, scmd.subtype)
			}

			// 累充有礼
			let On33259 = () => {
				let model: TiredChargePoliteModel = TiredChargePoliteModel.GetInstance();
				let scmd = user_msg_adapter.GetSCMD(33259);
				model.SetTiredChargePoliteData(scmd);
				model.Fire(TiredChargePoliteModelEvent.UP_VIEW);
				this.model.SetActRedDot(scmd.base_type, scmd.sub_type);
				this.model.RefreshIconRed(scmd.base_type, scmd.sub_type);
			}
			/**绑玉祈愿信息返回 */
			let On33260 =()=>{
				let scmd = user_msg_adapter.GetSCMD(33260)
				if(!scmd) return
				let b = scmd.type
				let s = scmd.subtype
				this.model.act_key_dic[b] = this.model.act_key_dic[b] || {}
				this.model.act_key_dic[b][s] = this.model.act_key_dic[b][s] || {}
				this.model.act_key_dic[b][s]["free_times"] = scmd.free_times
				this.model.act_key_dic[b][s]["free_gift_status"] = scmd.free_gift_status
				this.model.SetActRedDot(b, s);
				this.model.RefreshIconRed(b, s);
				this.model.Fire(custom_event.UPDATE_VIEW, scmd)
			}

			/**绑玉祈愿抽奖 */
			let On33262 =()=>{
				let scmd = user_msg_adapter.GetSCMD(33262)
				if (scmd.errcode == 1) {
					let b = scmd.type
					let s = scmd.subtype
					this.model.act_key_dic[b] = this.model.act_key_dic[b] || {}
					this.model.act_key_dic[b][s] = this.model.act_key_dic[b][s] || {}
					if (this.model.act_key_dic[b][s]["free_times"] > 0) {
						this.model.act_key_dic[b][s]["free_times"] -= 1
					}
					this.model.SetActRedDot(b, s);
					this.model.RefreshIconRed(b, s);
					this.model.Fire(custom_event.BIND_JAGE_WISH_REWARD, scmd)
				}
				else{
					Util.ErrorCodeShow(scmd.errcode)
				}
			}

			/**每日奖励获取 */
			let On33263 = () => {
				let scmd = user_msg_adapter.GetSCMD(33263)
				if (scmd.errcode == 1) {
					let b = scmd.type
					let s = scmd.subtype
					this.model.act_key_dic[b] = this.model.act_key_dic[b] || {}
					this.model.act_key_dic[b][s] = this.model.act_key_dic[b][s] || {}
					this.model.act_key_dic[b][s]["free_gift_status"] = 2
					this.model.SetActRedDot(b, s);
					this.model.RefreshIconRed(b, s);
					this.model.Fire(custom_event.BIND_JAGE_WISH_DAILY, scmd)
				}
			}
			/**活动总览奖励请求 */
			let On33264 =()=>{
				let scmd = user_msg_adapter.GetSCMD(33264)
				this.model.SetOverViewData(scmd)
			}
			/**绝版外显 */
			let On33265 =()=>{
				let scmd = user_msg_adapter.GetSCMD(33265)
				this.model.Fire(custom_event.UPDATE_VIEW, scmd.type, scmd.subtype, scmd.grade)
			}

			let On33266 =()=> {
				let scmd = user_msg_adapter.GetSCMD(33266)
				if(scmd.errcode == 1){
					this.model.SetOnlineDrawData(scmd)
				}else{
					Util.ErrorCodeShow(scmd.errcode)
				}
			}

			this.RegisterProtocal(33100, On33100)
			this.RegisterProtocal(33101, On33101)
			this.RegisterProtocal(33102, On33102)
			this.RegisterProtocal(33103, On33103)
			this.RegisterProtocal(33104, On33104)
			this.RegisterProtocal(33105, On33105)
			this.RegisterProtocal(33106, On33106)
			this.RegisterProtocal(33108, On33108)

			//// 开服冲榜
			this.RegisterProtocal(22500, On22500)
			this.RegisterProtocal(22501, On22501)
			this.RegisterProtocal(22502, On22502)
			this.RegisterProtocal(22503, On22503)
			this.RegisterProtocal(22504, On22504)
			this.RegisterProtocal(22505, On22505)

			//0元礼包
			this.RegisterProtocal(33136, On33136)
			this.RegisterProtocal(33137, On33137)
			this.RegisterProtocal(33138, On33138)

			//某个活动类型的充值总额
			this.RegisterProtocal(15957, On15957)

			//节日活动 充值有礼 充值金额
			this.RegisterProtocal(15958, On15958)

			//当天充值金额
			this.RegisterProtocal(15959, On15959)
			//几天前的充值金额
			this.RegisterProtocal(15960, On15960)

			////云购
			//this:RegisterProtocal(33112, On33112)
			//this:RegisterProtocal(33113, On33113)
			//this:RegisterProtocal(33114, On33114)
			//this:RegisterProtocal(33116, On33116)

			//每日累充
			this.RegisterProtocal(15955, On15955)
			this.RegisterProtocal(15956, On15956)

			////结社争霸活动
			//this:RegisterProtocal(33118, On33118)

			//验证活动
			this.RegisterProtocal(33169, On33169)

			////摇摇乐
			//this:RegisterProtocal(33186, On33186)
			//this:RegisterProtocal(33187, On33187)

			////节日排行
			//this:RegisterProtocal(33188, On33188)
			//this:RegisterProtocal(33189, On33189)

			////砸蛋
			//this:RegisterProtocal(33120, On33120)
			//this:RegisterProtocal(33121, On33121)
			//this:RegisterProtocal(33122, On33122)
			//this:RegisterProtocal(33123, On33123)

			////摇钱树
			this.RegisterProtocal(33190, On33190)
			this.RegisterProtocal(33191, On33191)
			this.RegisterProtocal(33192, On33192)
			this.RegisterProtocal(33168, On33168)
			this.RegisterProtocal(33231, On33231)

			////神圣召唤
			this.RegisterProtocal(33221, On33221)
			this.RegisterProtocal(33222, On33222)

			////节日活跃
			this.RegisterProtocal(33193, On33193)
			this.RegisterProtocal(33194, On33194)
			this.RegisterProtocal(33195, On33195)
			this.RegisterProtocal(33196, On33196)

			////嗨点
			this.RegisterProtocal(33140, On33140)

			//活动通用获奖记录
			this.RegisterProtocal(33197, On33197)

			////摇摇乐记录
			//this:RegisterProtocal(33198, On33198)
			//this:RegisterProtocal(33199, On33199)

			////跨服消费排行
			//this:RegisterProtocal(33203, On33203)
			//this:RegisterProtocal(33204, On33204)

			////批量兑换
			this.RegisterProtocal(33179, On33179)

			////惊喜扭蛋
			//this:RegisterProtocal(33205, On33205)
			//this:RegisterProtocal(33206, On33206)
			//this:RegisterProtocal(33207, On33207)
			//this:RegisterProtocal(33208, On33208)

			//赛博夺宝
			this.RegisterProtocal(33165, On33165)
			this.RegisterProtocal(33166, On33166)
			this.RegisterProtocal(33167, On33167)

			//绑钻转盘
			this.RegisterProtocal(33130, On33130)
			this.RegisterProtocal(33131, On33131)
			this.RegisterProtocal(33132, On33132)

			//每日补给
			this.RegisterProtocal(33209, On33209)

			////超级投资
			this.RegisterProtocal(33211, On33211)
			this.RegisterProtocal(33212, On33212)

			////vip特惠礼包
			this.RegisterProtocal(33215, On33215)

			////神佑祈愿
			//this:RegisterProtocal(33176, On33176)
			//this:RegisterProtocal(33177, On33177)

			//鲜花榜
			this.RegisterProtocal(22400, On22400)
			this.RegisterProtocal(22403, On22403)

			////自选奖励抽奖
			this.RegisterProtocal(33128, On33128)
			this.RegisterProtocal(33129, On33129)
			this.RegisterProtocal(33133, On33133)
			this.RegisterProtocal(33134, On33134)
			this.RegisterProtocal(33135, On33135)
			this.RegisterProtocal(33139, On33139)

			//完美情缘
			this.RegisterProtocal(33115, On33115)

			////封测充值
			//this:RegisterProtocal(33216, On33216)

			////幸运占卜（许愿池）
			this.RegisterProtocal(33141, On33141)
			this.RegisterProtocal(33142, On33142)
			this.RegisterProtocal(33144, On33144)

			////幸运寻宝
			this.RegisterProtocal(33213, On33213)
			this.RegisterProtocal(33214, On33214)

			////在线抽奖
			this.RegisterProtocal(33217, On33217)

			////活跃度转盘
			//this:RegisterProtocal(33218, On33218)
			//this:RegisterProtocal(33219, On33219)
			//this:RegisterProtocal(33220, On33220)

			////红包雨
			this.RegisterProtocal(33155, On33155)
			this.RegisterProtocal(33157, On33157)
			this.RegisterProtocal(33158, On33158)

			////首杀
			//this:RegisterProtocal(33223, On33223)

			////首发充值消费排行
			this.RegisterProtocal(22405, On22405)

			//招财猫
			this.RegisterProtocal(33224, On33224)
			this.RegisterProtocal(33225, On33225)
			this.RegisterProtocal(33226, On33226)

			////跨服团购
			this.RegisterProtocal(33227, On33227)
			this.RegisterProtocal(33228, On33228)
			this.RegisterProtocal(33229, On33229)
			this.RegisterProtocal(33230, On33230)
			this.RegisterProtocal(33267, On33267)

			////问卷调查
			this.RegisterProtocal(33236, On33236)

			//天命转盘
			this.RegisterProtocal(33238, On33238)
			this.RegisterProtocal(33239, On33239)
			this.RegisterProtocal(33240, On33240)

			//100-幸运寻宝
			this.RegisterProtocal(33241, On33241)
			this.RegisterProtocal(33242, On33242)

			//升战排行
			this.RegisterProtocal(22601, On22601)
			this.RegisterProtocal(22602, On22602)
			this.RegisterProtocal(22603, On22603)

			// 扭蛋（通用抽奖）
			this.RegisterProtocal(33245, On33245)
			this.RegisterProtocal(33246, On33246)

			//封测充值返还
			this.RegisterProtocal(33216, On33216)

			//幸运鉴宝2
			this.RegisterProtocal(33243, On33243)
			this.RegisterProtocal(33244, On33244)

			//多倍充值
			this.RegisterProtocal(33247, On33247)

			//冲级挑战
			this.RegisterProtocal(33248, On33248)

			//广告定制活动cd
			this.RegisterProtocal(33250, On33250)
			//头号玩家提示
			this.RegisterProtocal(33251, On33251)
			// 红包返利
			this.RegisterProtocal(33255, On33255)
			this.RegisterProtocal(33256, On33256)

			// 奖励获得
			this.RegisterProtocal(33257, On33257)

			//全民狂欢
			this.RegisterProtocal(33258, On33258)

			// 累充有礼
			this.RegisterProtocal(33259, On33259)

			//绑玉祈愿
			this.RegisterProtocal(33260,On33260)
			this.RegisterProtocal(33262,On33262)
			this.RegisterProtocal(33263,On33263)

			//总览奖励
			this.RegisterProtocal(33264,On33264)
			//绝版外显
			this.RegisterProtocal(33265,On33265)
			
			this.RegisterProtocal(33266,On33266)
		}

		//开服冲榜
		this.ShowTopPlayerGoalReward = (rank_type?, goal?) => {
			ResManager.GetInstance().GetGameConfigWithAutoDestory("config_rush_goal_reward", (goal_cfg) => {

				let key = rank_type + "@" + goal
				// [ts2lua]goal_cfg下标访问可能不正确
				let cfg = goal_cfg[key]
				let reward = JSON.parse(cfg.reward)
				if (reward && reward.length > 0) {
					let cov = new CongratulationObtainView(reward)
					cov.Open()
				}
			}, false)

		}

		//开服冲榜
		this.ShowTopPlayerRankReward = (rank_type?, reward_id?) => {
			ResManager.GetInstance().GetGameConfigWithAutoDestory("config_rush_rank_reward", (rank_cfg) => {
				if (rank_cfg) {
					let career = role_mgr.GetMainRoleVo().career
					let key = rank_type + "@" + reward_id
					// [ts2lua]rank_cfg下标访问可能不正确
					let cfg = rank_cfg[key]
					let reward = JSON.parse(cfg.reward)
					let career_reward = null
					for (let _tmpi in reward) {
						var vo = reward[_tmpi]
						if (vo[0] == career) {
							career_reward = vo[1]
							break
						}
					}
					if (career_reward && career_reward.length > 0) {
						let cov = new CongratulationObtainView(career_reward)
						cov.Open()
					}
				}
			}, false)

		}


		this.InitEvents()
		this.InitInfo()
	}
}

window["CustomActivityController"] = CustomActivityController
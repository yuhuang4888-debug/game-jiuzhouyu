import { BaseController } from "../common/BaseController"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { Util } from "../util/Util"
import { ResManager } from "../common/ResManager"
import { Message } from "../sysInfo/SysInfoController"
import { MainFunc } from "../commonModel/MainUIModel"
import { RoleManager } from "../commonModel/RoleManager"
import { EventName } from "../common/EventName"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GoodsModel } from "../commonModel/GoodsModel"
import { TaskModel } from "../commonModel/TaskModel"
import { CompositeModel, CompositeEvent } from "../commonModel/CompositeModel"
import { RedEnterView } from "../redEquip/RedEnterView"
import { SelectCompositeMatView } from "../redEquip/SelectCompositeMatView"
import { Config } from "../common/Config"

import "../composite/CompositeView"

//require("game.composite.ComGoodsResloveBagItem")
//require("game.composite.ComGoodsResloveItem")
//require("game.composite.ComGoodsResloveView")
//require("game.composite.CompositeGodBeastItem")
//require("game.composite.CompositeGodBefallItem")
//require("game.composite.CompositeGoodsMatItem")
//require("game.composite.CompositeGoodsView")
//require("game.composite.CompositeGuardAttItem")
//require("game.composite.CompositeGuardView")
//require("game.composite.CompositeHolySealMatItem")
//require("game.composite.CompositeHolySealView")
//require("game.composite.CompositeLonglangView")
//require("game.composite.CompositeModel")
//require("game.composite.CompositeRevelationView")
//require("game.composite.CompositeRuneView")
////require("game.composite.CompositeSoulView")
//require("game.composite.CompositeUnrealMatItem")
//require("game.composite.CompositeUnrealView")
//require("game.composite.CompositeView")
//require("game.composite.GodBeastCompositeView")
//require("game.composite.GodBefallCompositeView")
//require("game.composite.GodBefallButton")

//require("game.composite.RuneComposeCostItem")
//require("game.composite.RuneSelectMatView")
//require("game.composite.SelectGodBeastView")
//require("game.composite.SelectGodBefallView")
//require("game.composite.SelectUnrealMatView")
////require("game.composite.SoulComposeCostItem")
////require("game.composite.SoulSelectMatView")

//require("game.redEquip.CompositeEquipView")
//require("game.common.CompositeEquipItem")
//require("game.common.CompositeSelectEquipItem")
//require("game.redEquip.CompositeEquipResolveView")

//require("game.redEquip.RedEnterView")
//require("game.redEquip.SelectMatView")
//require("game.common.SelectMatItem")
//require("game.redEquip.CompositeRankView")
//require("game.redEquip.RingCompositeItem")
//require("game.redEquip.CompositeRingItem")
//require("game.redEquip.RingCompositeView")
//require("game.redEquip.CompositeEquipResolveView")
//require("game.redEquip.CompositeEquipResolveBagItem")
//require("game.redEquip.ComposeEquipResolveItem")
//require("game.redEquip.RingUpgradeView")
//require("game.redEquip.RingUpCompositeItem")


export class CompositeController extends BaseController {
	InitInfo

	public static GoodsType = {
		Jewel: 14,
		HolyDevice: 20,
		Fashion: 12,
		Props: 38,
		HolySealOther: 61,
		GodMat: 71,
		Rune: 26
	}

	public constructor() {
		super()
		let user_msg_adapter = UserMsgAdapter.GetInstance()
		let local_CompositeEvent = CompositeEvent
		let local_CompositeModel = CompositeModel

		let role_mgr = RoleManager.GetInstance()
		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName
		let local_GoodsModel = GoodsModel
		let local_laya = Laya
		let task_model = TaskModel.GetInstance()
		let view_dic_ = {}
		let composite_view_ = null
		let equip_select_view_ = null
		let godbeast_select_view_ = null
		let unreal_select_view_ = null
		let god_select_view_ = null
		let baby_select_view_ = null
		let redView_ = null

		let goodsmodel = GoodsModel.GetInstance()
		//let redModel = RedEquipModel.GetInstance()
		this.InitInfo = () => {
			let model = CompositeModel.GetInstance()
			let on15020 = () => {
				let scmd = user_msg_adapter.GetSCMD(15020)
				if (scmd.code == 1 || scmd.code == 1500080) {
					model.Fire(local_CompositeEvent.COMPOSE_SUCCESS, scmd.rule_id, scmd.goods_id)
				} else {
					model.Fire(local_CompositeEvent.COMPOSE_Fail)
					if (scmd.goods_id) {
						let goodsVo = goodsmodel.GetGoodsVoByGoodsId(scmd.goods_id)
						if (goodsVo) {
							Message.showGoods(goodsVo)
						}
					}
					Util.ErrorCodeShow(scmd.code)
				}
			}

			this.RegisterProtocal(15020, on15020)
			let OnCompositeEquipBtn = (rule_id?, regular_glist?, specify_glist?) => {
				this.WriteBegin(15020)
				this.WriteFMT("i", rule_id)
				this.WriteFMT("h", regular_glist.length)
				for (let _tmpi in regular_glist) {
					var goods_id = regular_glist[_tmpi]
					this.WriteFMT("l", goods_id)
				}
				this.WriteFMT("h", specify_glist.length)
				for (let _tmpi in specify_glist) {
					var goods_id = specify_glist[_tmpi]
					this.WriteFMT("l", goods_id)
				}
				this.SendToGame()
			}

			model.Bind(local_CompositeEvent.REQUEST_PROTO, OnCompositeEquipBtn)
			let goodsCom = (rule_id?, composeNum?, regularList?, irregular_glist?) => {
				this.WriteBegin(15028)
				this.WriteFMT("i", rule_id)
				this.WriteFMT("i", composeNum)
				let hole = 1
				this.WriteFMT("h", Util.TableSize(regularList))
				for (let key in regularList) {

					// [ts2lua]regularList下标访问可能不正确
					let vo = regularList[key]
					this.WriteFMT("c", hole)
					this.WriteFMT("i", vo[1])
					this.WriteFMT("i", vo[2] * composeNum)
					hole = hole + 1
				}
				this.WriteFMT("h", irregular_glist.length)
				for (let _tmpi in irregular_glist) {
					var goods_id = irregular_glist[_tmpi]
					this.WriteFMT("l", goods_id)
				}
				this.SendToGame()
			}

			model.Bind(local_CompositeEvent.GOODS_COMPOSE, goodsCom)
			let Handler15028 = () => {
				let scmd = user_msg_adapter.GetSCMD(15028)
				if (scmd.code == 1 || scmd.code == 1500080) {
					model.Fire(local_CompositeEvent.COMPOSE_SUCCESS, scmd.rule_id, () => {
						Util.ShowCongratulationView(scmd.rewards)
					})
				} else {
					model.Fire(local_CompositeEvent.COMPOSE_Fail)
					Util.ErrorCodeShow(scmd.code)
				}
			}

			this.RegisterProtocal(15028, Handler15028)
			model.Bind(local_CompositeModel.OPEN_COMPOSITE_VIEW, (index?, back_id?) => {
				if (!composite_view_) {
					composite_view_ = true
					// [ts2lua]window下标访问可能不正确
					//if (! window["CompositeView"] ) {
					//if (! ResManager.GetInstance().IsJsLoad("composite") ) {

					//}
					//}
					if (composite_view_ == true) {
						// [ts2lua]window下标访问可能不正确
						let viewName = window["CompositeView"]
						composite_view_ = new viewName()
					}
				}
				if (composite_view_ && composite_view_ != true) {
					composite_view_.SetDefaultIndex(index)
					composite_view_.SetBackId(back_id)
					if (!composite_view_.HasOpen()) {
						composite_view_.Open()
					}
				}
			})

			model.Bind(local_CompositeEvent.OPEN_VIEW, (view_name: string, ...new_args) => {
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
					let x = view.HasOpen() && view.Close() || view.Open(...new_args)
				}
			})

			model.Bind(local_CompositeEvent.RED_EQUIP_OPEN_VIEW, (view_name: string, ...new_args) => {
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
					let x = view.HasOpen() && view.Close() || view.Open(...new_args)
				}
			})

			model.Bind(local_CompositeModel.OPEN_CHOSE_EQUIPMENT_VIEW, (index?, parms?, mat_type?, type?) => {
				if (!equip_select_view_) {
					equip_select_view_ = new SelectCompositeMatView()
				}
				if (equip_select_view_) {
					equip_select_view_.Open()
					equip_select_view_.SetData(index, parms, mat_type, type)
				}
			})

			model.Bind(local_CompositeModel.OPEN_CHOSE_UNREAL_VIEW, (index?, parms?) => {
				if (!unreal_select_view_) {
					unreal_select_view_ = true
					if (unreal_select_view_ == true) {
						let className = window["SelectUnrealMatView"]
						unreal_select_view_ = new className()
					}
				}
				if (unreal_select_view_ && unreal_select_view_ != true) {
					unreal_select_view_.SetData(index, parms)
					unreal_select_view_.Open()
				}
			})

			model.Bind(local_CompositeModel.COLSE_CHOSE_EQUIPMENT_VIEW, () => {
				if (equip_select_view_ && equip_select_view_ != true) {
					if (equip_select_view_.HasOpen()) {
						equip_select_view_.Close()
					}
				}
			})

			model.Bind(local_CompositeModel.OPEN_CHOSE_GODBEAST_VIEW, (index?, parms?) => {
				if (!godbeast_select_view_) {
					godbeast_select_view_ = true
					if (godbeast_select_view_ == true) {
						let className = window["SelectGodBeastView"]
						godbeast_select_view_ = new className()
					}
				}
				if (godbeast_select_view_ && godbeast_select_view_ != true) {
					godbeast_select_view_.Open()
					godbeast_select_view_.SetData(index, parms)
				}
			})

			model.Bind(local_CompositeModel.CLOSE_CHOSE_GODBEAST_VIEW, () => {
				if (godbeast_select_view_ && godbeast_select_view_ != true) {
					if (godbeast_select_view_.HasOpen()) {
						godbeast_select_view_.Close()
					}
				}
			})

			model.Bind(local_CompositeModel.OPEN_CHOSE_GOD_VIEW, (index?, parms?) => {
				if (!god_select_view_) {
					god_select_view_ = true
					if (god_select_view_ == true) {
						let className = window["SelectGodBefallView"]
						god_select_view_ = new className()
					}
				}
				if (god_select_view_ && god_select_view_ != true) {
					god_select_view_.Open()
					god_select_view_.SetData(index, parms)
				}
			})

			model.Bind(local_CompositeModel.CLOSE_CHOSE_GOD_VIEW, () => {
				if (god_select_view_ && god_select_view_ != true) {
					if (god_select_view_.HasOpen()) {
						god_select_view_.Close()
					}
				}
			})

			let update_dot = (goods_list?) => {
				if (goods_list) {
					let goodsBasic
					let goodType
					let goodSubType
					let comGoodsType = CompositeController.GoodsType
					let comIndex = CompositeModel.Index
					let checkList = []
					for (let _ in goods_list) {
						var goodsInfo = goods_list[_]
						goodsBasic = goodsmodel.GetGoodsBasicByTypeId(goodsInfo.type_id)
						if (goodsBasic) {
							goodType = goodsBasic.type
							goodSubType = goodsBasic.subtype
							//物品合成 (宝石合成 神兵合成  时装合成 碎片合成)
							if (!checkList[comIndex.Goods] && (goodType == comGoodsType.Jewel
								|| (goodType == comGoodsType.HolyDevice && goodSubType == 3)
								|| (goodType == comGoodsType.Fashion && goodSubType == 0)
								|| (goodType == comGoodsType.Props && (goodSubType == 34 || goodSubType == 40)))) {
								checkList[comIndex.Goods] = true
								//圣印合成
							} else if (!checkList[comIndex.HolySeal] && (goodType == comGoodsType.HolySealOther && goodSubType == 2)) {
								checkList[comIndex.HolySeal] = true
								//蜃妖合成
							} else if ((goodsInfo.type_id == 39510010)) {
								checkList[comIndex.GodBeast] = true
								//灵饰合成
							} else if ((goodsInfo.type_id == 38040096)) {
								checkList[comIndex.Unreal] = true
								//将神
							} else if (!checkList[comIndex.God] && (goodType == comGoodsType.GodMat && goodSubType == 3)) {
								checkList[comIndex.God] = true
								//神庭
							} else if ((goodsInfo.type_id == 801706)) {
								checkList[comIndex.GodCourt] = true
								//龙语
							} else if ((goodsInfo.type_id == 38040064)) {
								checkList[comIndex.Longlang] = true
							} else if (goodType == comGoodsType.Rune || goodsInfo.type_id == 38040012) {
								checkList[comIndex.Rune] = true
								//守护合成 必须放在最后 确保不是其他地方的合成材料
							} else if (goodType == comGoodsType.Props) {
								checkList[comIndex.Guard] = true
							}
						}
					}

					let cfg1 = Config.PRELOAD_SERVER_CONFIG.config_compose_menu
					let cfg2 = Config.PRELOAD_SERVER_CONFIG.config_compose_menu_id
					if (checkList[comIndex.Goods]) {
						model.RefreshGoodsRedDot()
					}
					if (checkList[comIndex.HolySeal]) {
						model.RefreshHolySealRedDot()
					}
					if (checkList[comIndex.GodBeast]) {
						model.GodBeastReddot(cfg1, cfg2)
					}
					if (checkList[comIndex.Unreal]) {
						model.RefreshUnrealRedDot()
					}
					if (checkList[comIndex.God]) {
						model.GodReddot(cfg1, cfg2)
					}
					if (checkList[comIndex.Guard]) {
						model.RefreshGuardRedDot()
					}
					if (checkList[comIndex.GodCourt]) {
						model.GetGodCourtRed()
					}
					if (checkList[comIndex.Longlang]) {
						model.RefreshLonglangRedDot()
					}
					if (checkList[comIndex.Rune]) {
						model.RuneComposeRedDot()
					}
				}

				let cfg1 = Config.PRELOAD_SERVER_CONFIG.config_compose_menu
				let cfg2 = Config.PRELOAD_SERVER_CONFIG.config_compose_menu_id
				model.RingUpgradeReddot(cfg1, cfg2)
				model.RingReddot(cfg1, cfg2)
			}
			goodsmodel.Bind(local_GoodsModel.UPDATE_GOODS_NUM, update_dot)

			let delayCallFunc = () => {
				setTimeout(() => {
					let cfg1 = Config.PRELOAD_SERVER_CONFIG.config_compose_menu
					let cfg2 = Config.PRELOAD_SERVER_CONFIG.config_compose_menu_id
					model.RefreshShowRed(cfg1, cfg2)
				}, 0.1)
				setTimeout(() => {
					let cfg1 = Config.PRELOAD_SERVER_CONFIG.config_compose_menu
					let cfg2 = Config.PRELOAD_SERVER_CONFIG.config_compose_menu_id
					model.RingUpgradeReddot(cfg1, cfg2)
					model.RingReddot(cfg1, cfg2)
				}, 0.2)
			}
			role_mgr.GetMainRoleVo().Bind(local_EventName.CHANGE_LEVEL, delayCallFunc)
			goodsmodel.Bind(local_GoodsModel.CREATE_BAG_LIST_FINISH, delayCallFunc)

			goodsmodel.Bind(local_GoodsModel.CHANGE_UNREAL_BAG_LIST, () => {
				model.RefreshUnrealRedDot()
			})
			goodsmodel.Bind(local_GoodsModel.CHANGE_HOLY_SEAL_BAG_LIST, () => {
				model.RefreshHolySealRedDot()
			})
			goodsmodel.Bind(local_GoodsModel.CHANGE_GOD_BAG_LIST, () => {
				let cfg1 = Config.PRELOAD_SERVER_CONFIG.config_compose_menu
				let cfg2 = Config.PRELOAD_SERVER_CONFIG.config_compose_menu_id
				model.GodReddot(cfg1, cfg2)
			})
			goodsmodel.Bind(local_GoodsModel.CHANGE_REVE_BAG_LIST, () => {
				model.RefreshRevelationRedDot()
			})
			goodsmodel.Bind(local_GoodsModel.CHANGE_REVE_EQUIP_LIST, () => {
				model.RefreshRevelationRedDot()
			})
			goodsmodel.Bind(local_GoodsModel.CHANGE_LONGLANG_BAG, () => {
				model.RefreshLonglangRedDot()
			})
			goodsmodel.Bind(local_GoodsModel.CHANGE_GODCOURT_BAG, () => {
				model.GetGodCourtRed()
			})
			goodsmodel.Bind(local_GoodsModel.CHANGE_BEAST_BAG_LIST, () => {
				let cfg1 = Config.PRELOAD_SERVER_CONFIG.config_compose_menu
				let cfg2 = Config.PRELOAD_SERVER_CONFIG.config_compose_menu_id
				model.GodBeastReddot(cfg1, cfg2)
			})

			local_GlobalEventSystem.Bind(local_EventName.INIT_CONFIG, () => {
				model.ResCfg()
				//let red_equip_attr_cfg = null
				//let equip_attr_cfg = null
				//let call_func = () => {
				//if (red_equip_attr_cfg && equip_attr_cfg ) {
				//redModel.createFullDic(red_equip_attr_cfg, equip_attr_cfg)
				//redModel:DestoryGameConfig("config_red_equip_attr", false)
				//redModel:DestoryGameConfig("Equipattr", false)
				//}
				//}

				//redModel:GetGameConfig("config_red_equip_attr",(cfgs?) => {
				//red_equip_attr_cfg = cfgs
				//call_func()
				//}
				//, false)
				//redModel:GetGameConfig("Equipattr",(cfgs?) => {
				//equip_attr_cfg = cfgs
				//call_func()
				//}
				//, false)
			}
			)

			goodsmodel.Bind(local_GoodsModel.EQUIP_DYNAMIC_FINISH, () => {
				//redModel.createFullDic(Config.Redequipattr, Config.Equipattr)
			})

			local_GlobalEventSystem.Bind(local_EventName.GAME_START, () => {
				let cfg = Config.PRELOAD_SERVER_CONFIG.config_compose_menu
				model.InitGoodsTabIdList(cfg)
				model.InitUnrallTabIdList(cfg)
				model.InitHolySealTabIdList(cfg)
				model.InitLonglangTabIdList(cfg)
				//model:InitSoulTabIdList(cfg)
				//model:InitBabyTabIdList(cfg)
				model.InitRevelationList(cfg)
				model.InitGuardTabIdList(cfg)
			})

			model.Bind(local_CompositeEvent.OPEN_RED_VIEW, (index?, back_id?, subindex?) => {
				if (!redView_) {
					redView_ = true
					if (redView_ == true) {
						redView_ = new RedEnterView()
					}
				}
				if (redView_ && redView_ != true) {
					redView_.SetDefaultIndex(index)
					redView_.SetIndexParameter(index, subindex)
					redView_.SetBackId(back_id)
					if (!redView_.HasOpen()) {
						redView_.Open()
					}
				}
			})

			let updateReddot = (list?) => {
				let cfg = Config.PRELOAD_SERVER_CONFIG.config_compose_menu
				model.UpdateEquipRed(cfg, list)
				local_GlobalEventSystem.Fire(local_EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Red)
			}
			goodsmodel.Bind(local_GoodsModel.CHANGE_BAG_LIST, updateReddot)

			let init_equip_red = () => {
				let cfg = Config.PRELOAD_SERVER_CONFIG.config_compose_menu
				model.InitEquipTab(cfg)
				local_GlobalEventSystem.Fire(local_EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Red)
			}
			goodsmodel.Bind(local_GoodsModel.CREATE_BAG_LIST_FINISH, init_equip_red)
			role_mgr.GetMainRoleVo().Bind(local_EventName.CHANGE_LEVEL, init_equip_red)

			model.Bind(local_CompositeModel.OPEN_BABY_COM_SELECT, (index?, parms?, mat_type?) => {
				if (!baby_select_view_) {
					let className = window["BabyComSelectMatView"]
					baby_select_view_ = new className()
				}
				baby_select_view_.Open()
				baby_select_view_.SetData(index, parms, mat_type)
			})
		}

		this.InitInfo()
	}
}
window["CompositeController"] = CompositeController
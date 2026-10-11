
//require("game.common.GoodsModel")

import { BaseController } from "../common/BaseController"
import { EventName, SceneEventType } from "../common/EventName"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { GoodsModel } from "../commonModel/GoodsModel"
import { GlobalEventSystem, LOAD_QUEUE } from "../util/DeclareGlobalVar"
import { RoleManager } from "../commonModel/RoleManager"
import { PlayBigEffect, Util } from "../util/Util"
import { BagModel } from "../commonModel/BagModel"
import { Message } from "../sysInfo/SysInfoController"
import { GameError } from "../util/GameError"
import { Config } from "../common/Config"
import { table } from "../common/table"
import { ColorUtil } from "../util/ColorUtil"
import { Status } from "../util/Status"
import { Alert, Alert_Type } from "../alert/Alert"
import { ItemUseModel } from "../commonModel/ItemUseModel"
import { ResManager } from "../common/ResManager"
import { LungEvent, LungModel } from "../commonModel/LungModel"
import { longlangModel } from "../commonModel/longlangModel"
import { StarEquipModel } from "../commonModel/StarEquipModel"
import { SoundManager } from "../common/SoundManager"
import { ViewPopLevelModel } from "../commonModel/ViewPopLevelModel"
import { HolySealModel } from "../commonModel/HolySealModel"
import { ShopModel, ShopMoneyType } from "../commonModel/ShopModel"
import { Scene } from "../scene/Scene"
//require("game.preload_proto.Require150")
export class GoodsController extends BaseController {
	On15088
	On15053
	On15027
	On15024
	On15021
	On15084
	On15086
	On15019
	On15002
	On15018
	On15025
	On15026
	On15055
	On15050
	On15001
	On15009
	On15030
	On15003
	On15023
	InitInfo
	On15083
	On15087
	On15090
	On15022
	On15089
	On15008
	On15010
	On15000
	On15017

	public constructor() {
		super()


		this.InitInfo = () => {
			let local_GoodsModel = GoodsModel
			let goodsModel = GoodsModel.GetInstance()
			let local_EventName = EventName
			let local_GlobalEventSystem = GlobalEventSystem
			let user_mgr = UserMsgAdapter.GetInstance()
			//let friend_model = FriendModel.GetInstance()
			let role_mgr = RoleManager.GetInstance()
			let local_Util = Util
			let longlang_model = longlangModel.GetInstance()
			let item_use_model = ItemUseModel.GetInstance()
			let bag_model = BagModel.GetInstance()
			let local_Message = Message
			// let boss_base_model = BossModel.GetInstance()
			let award_view_ = null
			let GOODS_POS_TYPE = GoodsModel.GOODS_POS_TYPE
			this.On15087 = () => {
				let vo = user_mgr.GetSCMD("15087")
				goodsModel.Fire(local_EventName.EXCHANGEGIFT_ERROR, vo)
			}

			this.On15000 = () => {
				let vo = user_mgr.GetSCMD("15000")
				goodsModel.AddDynamic(vo)
			}

			this.On15001 = () => {
				let vo = user_mgr.GetSCMD("15001")
				if (vo.type_id == 0) {
					if (goodsModel._isPlayerMessage) {
						local_Message.show("装备信息已过时")
						// friend_model.requestPlayerMessage(friend_model.playerId, true)
					} else {
						Util.ErrorCodeShow(1500001)
					}
				} else {
					if (vo.player_id != role_mgr.GetMainRoleId()) {
						goodsModel.AddDynamic(vo)
					}
				}
				goodsModel._isPlayerMessage = false
			}

			this.On15003 = () => {
				let scmd = user_mgr.GetSCMD("15003")
				if (scmd.code != 1) {
					Util.ErrorCodeShow(scmd.code)
				}
			}

			this.On15008 = () => {
				let vo = user_mgr.GetSCMD("15008")
				// [ts2lua]goodsModel.GetSpecialScore下标访问可能不正确
				let old_num = goodsModel.GetSpecialScore(vo.currency_id)
				// [ts2lua]lua中0和空字符串也是true，此处old_num需要确认
				old_num = old_num && old_num || 0
				goodsModel.UpdateSpecialScore(vo)
				goodsModel.Fire(local_GoodsModel.UPDATE_SPECIAL_SCORE, vo, old_num)
			}

			this.On15009 = () => {
				let vo = user_mgr.GetSCMD("15009")
				goodsModel.CreateSpecialScoreList(vo.currency_list)
				goodsModel.Fire(local_GoodsModel.CREATE_SPECIAL_SCORE_FINISH)
			}

			this.On15017 = async () => {
				let vo = user_mgr.GetSCMD("15017")
				if (vo.pos == GOODS_POS_TYPE.equip) {
					for (let _tmpi in vo.goods_list) {
						var GoodsVo = vo.goods_list[_tmpi]
						goodsModel.UpdateEquipGoods(GoodsVo)
					}
					goodsModel.Fire(local_GoodsModel.CHANGE_EQUIPLIST)
				} else if (vo.pos == GOODS_POS_TYPE.bag) {
					for (let _tmpi in vo.goods_list) {
						var GoodsVo = vo.goods_list[_tmpi]
						item_use_model.UpdateBagGoodsDic(GoodsVo, true)
						goodsModel.UpdateBagGoods(GoodsVo)
						let basic = goodsModel.GetGoodsBasicByTypeId(GoodsVo.type_id)
						if (!basic) {
							GameError.Instance.SendErrorToPHP("goodsbase can ! find id = " + GoodsVo.type_id)
							break
						}
						goodsModel.RefreshtGoods(basic, GoodsVo)
					}
					goodsModel.hasSort = false
					goodsModel.DelayFire(local_GoodsModel.CHANGE_BAG_LIST, vo.goods_list)
					goodsModel.RefreshIconRedDot(vo.goods_list)
					goodsModel.Fire(local_GoodsModel.TRY_SHOW_ITEM_USE_VIEW, vo.goods_list)
				} else if (vo.pos == GOODS_POS_TYPE.rune_bag) {
					for (let _tmpi in vo.goods_list) {
						var GoodsVo = vo.goods_list[_tmpi]
						goodsModel.UpdateRuneBagGoods(GoodsVo)
					}
					goodsModel.Fire(local_GoodsModel.CHANGE_RUNE_BAG_LIST, true)
				} else if (vo.pos == GOODS_POS_TYPE.rune) {
					for (let _tmpi in vo.goods_list) {
						var GoodsVo = vo.goods_list[_tmpi]
						goodsModel.UpdateRuneEquipGoods(GoodsVo)
					}
					goodsModel.Fire(local_GoodsModel.CHANGE_RUNELIST)
				} else if (vo.pos == GOODS_POS_TYPE.treasurebag) {
					for (let _tmpi in vo.goods_list) {
						var GoodsVo = vo.goods_list[_tmpi]
						goodsModel.UpdateTreasureBagGoods(GoodsVo)
					}
					goodsModel.SortTreasureBagList()
					goodsModel.Fire(local_GoodsModel.CHANGE_TREASURE_BAG_LIST)
				} else if (vo.pos == GOODS_POS_TYPE.soul_bag) {
					for (let _tmpi in vo.goods_list) {
						var GoodsVo = vo.goods_list[_tmpi]
						goodsModel.UpdateSoulBagGoods(GoodsVo)
					}
					goodsModel.Fire(local_GoodsModel.CHANGE_SOUL_BAG_LIST, true)
				} else if (vo.pos == GOODS_POS_TYPE.soul) {
					for (let _tmpi in vo.goods_list) {
						var GoodsVo = vo.goods_list[_tmpi]
						goodsModel.UpdateSoulEquipGoods(GoodsVo)
					}
					goodsModel.Fire(local_GoodsModel.CHANGE_SOUL_LIST)
				} else if (vo.pos == GOODS_POS_TYPE.beast_bag) {
					for (let _tmpi in vo.goods_list) {
						var GoodsVo = vo.goods_list[_tmpi]
						goodsModel.UpdateBeastBagGoods(GoodsVo)
					}
					goodsModel.Fire(local_GoodsModel.CHANGE_BEAST_BAG_LIST)
				} else if (vo.pos == GOODS_POS_TYPE.beast) {
					for (let _tmpi in vo.goods_list) {
						var GoodsVo = vo.goods_list[_tmpi]
						goodsModel.UpdateBeastEquipGoods(GoodsVo)
					}
					goodsModel.Fire(local_GoodsModel.CHANGE_BEAST_LIST)
				} else if (vo.pos == GOODS_POS_TYPE.unreal) {
					for (let _tmpi in vo.goods_list) {
						var GoodsVo = vo.goods_list[_tmpi]
						goodsModel.UpdateUnrealEquipGoods(GoodsVo)
					}
					goodsModel.Fire(local_GoodsModel.CHANGE_UNREAL_LIST)
				} else if (vo.pos == GOODS_POS_TYPE.unreal_bag) {
					for (let _tmpi in vo.goods_list) {
						var GoodsVo = vo.goods_list[_tmpi]
						goodsModel.UpdateUnrealBagGoods(GoodsVo)
					}
					goodsModel.Fire(local_GoodsModel.CHANGE_UNREAL_BAG_LIST)
				} else if (vo.pos == GOODS_POS_TYPE.holy_seal) {
					for (let _tmpi in vo.goods_list) {
						var GoodsVo = vo.goods_list[_tmpi]
						goodsModel.UpdateHolySealEquipGoods(GoodsVo)
					}
					goodsModel.Fire(local_GoodsModel.CHANGE_HOLY_SEAL_LIST)
				} else if (vo.pos == GOODS_POS_TYPE.holy_seal_bag) {
					for (let _tmpi in vo.goods_list) {
						var GoodsVo = vo.goods_list[_tmpi]
						goodsModel.UpdateHolySealBagGoods(GoodsVo)
						item_use_model.UpdateBagGoodsDic(GoodsVo, true)
					}
					goodsModel.SortHolySealBagList()
					goodsModel.Fire(local_GoodsModel.TRY_SHOW_ITEM_USE_VIEW, vo.goods_list)
					// goodsModel.Fire(local_GoodsModel.CHANGE_HOLY_SEAL_BAG_LIST)

				} else if (vo.pos == GOODS_POS_TYPE.horse) {
					for (let _tmpi in vo.goods_list) {
						var GoodsVo = vo.goods_list[_tmpi]
						goodsModel.UpdateHorseEquipGoods(GoodsVo)
					}
					goodsModel.Fire(local_GoodsModel.CHANGE_HORSE_LIST)
				} else if (vo.pos == GOODS_POS_TYPE.horse_bag) {
					for (let _tmpi in vo.goods_list) {
						var GoodsVo = vo.goods_list[_tmpi]
						goodsModel.UpdateHorseBagGoods(GoodsVo)
					}
					goodsModel.SortHorseBagList()
					goodsModel.Fire(local_GoodsModel.CHANGE_HORSE_BAG_LIST)
				} else if (vo.pos == GOODS_POS_TYPE.partner) {
					for (let _tmpi in vo.goods_list) {
						var GoodsVo = vo.goods_list[_tmpi]
						goodsModel.UpdatePartnerEquipGoods(GoodsVo)
					}
					goodsModel.Fire(local_GoodsModel.CHANGE_PARTNER_LIST)
				} else if (vo.pos == GOODS_POS_TYPE.partner_bag) {
					for (let _tmpi in vo.goods_list) {
						var GoodsVo = vo.goods_list[_tmpi]
						goodsModel.UpdatePartnerBagGoods(GoodsVo)
					}
					goodsModel.SortPartnerBagList()
					goodsModel.Fire(local_GoodsModel.CHANGE_PARTNER_BAG_LIST)
				} else if (vo.pos == GOODS_POS_TYPE.warehouse) {
					for (let _tmpi in vo.goods_list) {
						var GoodsVo = vo.goods_list[_tmpi]
						goodsModel.UpdateWarehouseGoods(GoodsVo)
					}
					goodsModel.SortWarehouseList()
				} else if (vo.pos == GOODS_POS_TYPE.lung_bag) {
					for (let _tmpi in vo.goods_list) {
						var GoodsVo = vo.goods_list[_tmpi]
						LungModel.GetInstance().Fire(LungEvent.LUNG_REQUEST_PROTO, 18113, "lh", GoodsVo.goods_id, GOODS_POS_TYPE.lung_bag)
					}

				} else if (vo.pos == GOODS_POS_TYPE.lung_equip) {
					for (let _tmpi in vo.goods_list) {
						var GoodsVo = vo.goods_list[_tmpi]
						LungModel.GetInstance().Fire(LungEvent.LUNG_REQUEST_PROTO, 18113, "lh", GoodsVo.goods_id, GOODS_POS_TYPE.lung_equip)
					}

				} else if (vo.pos == GOODS_POS_TYPE.baby_bag) {
					for (let _tmpi in vo.goods_list) {
						var GoodsVo = vo.goods_list[_tmpi]
						goodsModel.UpdateBabyBagGoods(GoodsVo)
					}
					goodsModel.Fire(local_GoodsModel.CHANGE_BABY_BAG)
				} else if (vo.pos == GOODS_POS_TYPE.god_bag) {
					for (let _tmpi in vo.goods_list) {
						var GoodsVo = vo.goods_list[_tmpi]
						goodsModel.UpdateGodBagGoods(GoodsVo)
					}
					goodsModel.Fire(local_GoodsModel.CHANGE_GOD_BAG_LIST)
				} else if (vo.pos == GOODS_POS_TYPE.god_equip) {
					for (let _tmpi in vo.goods_list) {
						var GoodsVo = vo.goods_list[_tmpi]
						goodsModel.UpdateGodEquipGoods(GoodsVo)
					}
					goodsModel.Fire(local_GoodsModel.CHANGE_GOD_LIST)
				} else if (vo.pos == GOODS_POS_TYPE.baby_equip) {
					for (let _tmpi in vo.goods_list) {
						var GoodsVo = vo.goods_list[_tmpi]
						goodsModel.UpdateBabyEquip(GoodsVo)
					}
					goodsModel.Fire(local_GoodsModel.CHANGE_BABY_EQUIP_LIST)
				} else if (vo.pos == GOODS_POS_TYPE.revelation_equip) {
					let cfgs = Config.PRELOAD_SERVER_CONFIG.config_revelation_equip_attr
					for (let _ in vo.goods_list) {
						let GoodsVo = vo.goods_list[_]
						goodsModel.UpdateRevelationEquip(GoodsVo, cfgs)
					}
					goodsModel.Fire(local_GoodsModel.CHANGE_REVE_EQUIP_LIST, vo.goods_list)
				} else if (vo.pos == GOODS_POS_TYPE.revelation_bag) {
					let cfgs = Config.PRELOAD_SERVER_CONFIG.config_revelation_equip_attr
					for (let _ in vo.goods_list) {
						var GoodsVo = vo.goods_list[_]
						goodsModel.UpdateRevelationBag(GoodsVo, cfgs)
					}
					goodsModel.Fire(local_GoodsModel.CHANGE_REVE_BAG_LIST)
				} else if (vo.pos == GOODS_POS_TYPE.demon_talent_bag) {
					for (let _tmpi in vo.goods_list) {
						var GoodsVo = vo.goods_list[_tmpi]
						goodsModel.UpdateDemonTalentGoods(GoodsVo)
					}
					goodsModel.Fire(local_GoodsModel.CHANGE_DEMON_TALENT_LIST)
				} else if (vo.pos == GOODS_POS_TYPE.longlangbag) {
					await new Promise<void>((resolve, reject) => {
						ResManager.GetInstance().GetGameConfigWithAutoDestory("config_draconic_equip", (cfgs) => {
							for (let _ in vo.goods_list) {
								let GoodsVo = vo.goods_list[_]
								goodsModel.UpdateLonglangGoods(GoodsVo, cfgs)
							}
							goodsModel.SortLonglangBag()
							longlang_model.RefreshDecRed(vo.goods_list)
							longlang_model.BetterEquipRed(vo.goods_list)
							goodsModel.Fire(local_GoodsModel.CHANGE_LONGLANG_BAG, true)
							resolve()
						}, false)
					})
				} else if (vo.pos == GOODS_POS_TYPE.longlangequip) {
					await new Promise<void>((resolve, reject) => {
						ResManager.GetInstance().GetGameConfigWithAutoDestory("config_draconic_equip", (cfgs) => {
							for (let _ in vo.goods_list) {
								let GoodsVo = vo.goods_list[_]
								goodsModel.UpdateLonglangEquip(GoodsVo, cfgs)
							}
							longlang_model.BetterEquipRed()
							goodsModel.Fire(local_GoodsModel.CHANGE_LONGLANG_EQUIP)
							resolve()
						}, false)
					})
				} else if (vo.pos == GOODS_POS_TYPE.starEquipBag) {
					await new Promise<void>((resolve, reject) => {
						ResManager.GetInstance().GetGameConfigWithAutoDestory("config_constellation_equip", (cfgs) => {
							if (!cfgs) {
								return
							}
							for (let GoodsVo of vo.goods_list) {
								goodsModel.UpdateStarEquipBagList(GoodsVo, cfgs)
							}
							StarEquipModel.GetInstance().UpdateEquipRed(vo.goods_list)
							StarEquipModel.GetInstance().CheckDevourRed(cfgs)
							goodsModel.SortStarEquipBagList()
							goodsModel.Fire(local_GoodsModel.CHANGE_STAREQUIP_BAG, vo.goods_list)
							resolve()
						}, false)
					})
				} else if (vo.pos == GOODS_POS_TYPE.starEquip) {
					await new Promise<void>((resolve, reject) => {
						ResManager.GetInstance().GetGameConfigWithAutoDestory("config_constellation_equip", (cfgs) => {
							for (let GoodsVo of vo.goods_list) {
								goodsModel.UpdateStarEquipList(GoodsVo, cfgs)
							}
							StarEquipModel.GetInstance().UpdateEquipRed()
							goodsModel.Fire(local_GoodsModel.CHANGE_STAREQUIP, vo.goods_list, false)
							resolve()
						}, false)
					})
				} else if (vo.pos == GOODS_POS_TYPE.godCourtBag) {
					for (let _tmpi in vo.goods_list) {
						var goodsVo = vo.goods_list[_tmpi]
						goodsModel.UpdateGodCourtBagList(goodsVo)
					}
					goodsModel.SortGodCourtBagList()
					goodsModel.Fire(local_GoodsModel.CHANGE_GODCOURT_BAG)
				} else if (vo.pos == GOODS_POS_TYPE.godCourt) {
					for (let _tmpi in vo.goods_list) {
						var goodsVo = vo.goods_list[_tmpi]
						goodsModel.UpdateGodCourtList(goodsVo)
					}
					goodsModel.Fire(local_GoodsModel.CHANGE_GODCOURT)
				} else if (vo.pos == GOODS_POS_TYPE.guildRune) {
					for (let _tmpi in vo.goods_list) {
						var goodsVo = vo.goods_list[_tmpi]
						goodsModel.UpdateGuildRuneList(goodsVo)
					}
					goodsModel.Fire(local_GoodsModel.CHANGE_GUILD_RUNE_LIST)
				}
				goodsModel.DelayFire(local_GoodsModel.UPDATE_GOODS_NUM, vo.goods_list, true)
			}

			this.On15018 = async () => {
				let vo = user_mgr.GetSCMD("15018")
				if (vo.pos == GOODS_POS_TYPE.bag) {
					for (let _tmpi in vo.goods_list) {
						var GoodsVo = vo.goods_list[_tmpi]
						item_use_model.UpdateBagGoodsAsSell(GoodsVo)
						goodsModel.UpdateBagGoods(GoodsVo)
					}
					goodsModel.DelayFire(local_GoodsModel.CHANGE_BAG_LIST, vo.goods_list)
					goodsModel.hasSort = false
					goodsModel.RefreshIconRedDot(vo.goods_list)
					goodsModel.Fire(local_GoodsModel.TRY_SHOW_ITEM_USE_VIEW, vo.goods_list)
				} else if (vo.pos == GOODS_POS_TYPE.rune_bag) {
					for (let _tmpi in vo.goods_list) {
						var GoodsVo = vo.goods_list[_tmpi]
						goodsModel.UpdateRuneBagGoods(GoodsVo)
					}
					goodsModel.Fire(local_GoodsModel.CHANGE_RUNE_BAG_LIST, false)
				} else if (vo.pos == GOODS_POS_TYPE.rune) {
					for (let _tmpi in vo.goods_list) {
						var GoodsVo = vo.goods_list[_tmpi]
						goodsModel.UpdateRuneEquipGoods(GoodsVo)
					}
					goodsModel.Fire(local_GoodsModel.CHANGE_RUNELIST)
				} else if (vo.pos == GOODS_POS_TYPE.treasurebag) {
					for (let _tmpi in vo.goods_list) {
						var GoodsVo = vo.goods_list[_tmpi]
						goodsModel.UpdateTreasureBagGoods(GoodsVo)
					}
					goodsModel.SortTreasureBagList()
					goodsModel.Fire(local_GoodsModel.CHANGE_TREASURE_BAG_LIST)
				} else if (vo.pos == GOODS_POS_TYPE.soul_bag) {
					for (let _tmpi in vo.goods_list) {
						var GoodsVo = vo.goods_list[_tmpi]
						goodsModel.UpdateSoulBagGoods(GoodsVo)
					}
					goodsModel.Fire(local_GoodsModel.CHANGE_SOUL_BAG_LIST, false)
				} else if (vo.pos == GOODS_POS_TYPE.soul) {
					for (let _tmpi in vo.goods_list) {
						var GoodsVo = vo.goods_list[_tmpi]
						goodsModel.UpdateSoulEquipGoods(GoodsVo)
					}
					goodsModel.Fire(local_GoodsModel.CHANGE_SOUL_LIST)
				} else if (vo.pos == GOODS_POS_TYPE.beast_bag) {
					for (let _tmpi in vo.goods_list) {
						var GoodsVo = vo.goods_list[_tmpi]
						goodsModel.UpdateBeastBagGoods(GoodsVo)
					}
					goodsModel.Fire(local_GoodsModel.CHANGE_BEAST_BAG_LIST)
				} else if (vo.pos == GOODS_POS_TYPE.beast) {
					for (let _tmpi in vo.goods_list) {
						var GoodsVo = vo.goods_list[_tmpi]
						goodsModel.UpdateBeastEquipGoods(GoodsVo)
					}
					goodsModel.Fire(local_GoodsModel.CHANGE_BEAST_LIST)
				} else if (vo.pos == GOODS_POS_TYPE.unreal_bag) {
					for (let _tmpi in vo.goods_list) {
						var GoodsVo = vo.goods_list[_tmpi]
						goodsModel.UpdateUnrealBagGoods(GoodsVo)
					}
					goodsModel.Fire(local_GoodsModel.CHANGE_UNREAL_BAG_LIST)
				} else if (vo.pos == GOODS_POS_TYPE.unreal) {
					for (let _tmpi in vo.goods_list) {
						var GoodsVo = vo.goods_list[_tmpi]
						goodsModel.UpdateUnrealEquipGoods(GoodsVo)
					}
					goodsModel.Fire(local_GoodsModel.CHANGE_UNREAL_LIST)
				} else if (vo.pos == GOODS_POS_TYPE.holy_seal) {
					for (let _tmpi in vo.goods_list) {
						var GoodsVo = vo.goods_list[_tmpi]
						goodsModel.UpdateHolySealEquipGoods(GoodsVo)
					}
					goodsModel.Fire(local_GoodsModel.CHANGE_HOLY_SEAL_LIST)
				} else if (vo.pos == GOODS_POS_TYPE.holy_seal_bag) {
					for (let _tmpi in vo.goods_list) {
						var GoodsVo = vo.goods_list[_tmpi]
						item_use_model.UpdateBagGoodsAsSell(GoodsVo)
						goodsModel.UpdateHolySealBagGoods(GoodsVo)
					}
					goodsModel.SortHolySealBagList()
					goodsModel.Fire(local_GoodsModel.TRY_SHOW_ITEM_USE_VIEW, vo.goods_list)
					// goodsModel.Fire(local_GoodsModel.CHANGE_HOLY_SEAL_BAG_LIST)
				} else if (vo.pos == GOODS_POS_TYPE.horse) {
					for (let _tmpi in vo.goods_list) {
						var GoodsVo = vo.goods_list[_tmpi]
						goodsModel.UpdateHorseEquipGoods(GoodsVo)
					}
					goodsModel.Fire(local_GoodsModel.CHANGE_HORSE_LIST)
				} else if (vo.pos == GOODS_POS_TYPE.horse_bag) {
					for (let _tmpi in vo.goods_list) {
						var GoodsVo = vo.goods_list[_tmpi]
						goodsModel.UpdateHorseBagGoods(GoodsVo)
					}
					goodsModel.SortHorseBagList()
					goodsModel.Fire(local_GoodsModel.CHANGE_HORSE_BAG_LIST)
				} else if (vo.pos == GOODS_POS_TYPE.partner) {
					for (let _tmpi in vo.goods_list) {
						var GoodsVo = vo.goods_list[_tmpi]
						goodsModel.UpdatePartnerEquipGoods(GoodsVo)
					}
					goodsModel.Fire(local_GoodsModel.CHANGE_PARTNER_LIST)
				} else if (vo.pos == GOODS_POS_TYPE.partner_bag) {
					for (let _tmpi in vo.goods_list) {
						var GoodsVo = vo.goods_list[_tmpi]
						goodsModel.UpdatePartnerBagGoods(GoodsVo)
					}
					goodsModel.SortPartnerBagList()
					goodsModel.Fire(local_GoodsModel.CHANGE_PARTNER_BAG_LIST)
				} else if (vo.pos == GOODS_POS_TYPE.warehouse) {
					for (let _tmpi in vo.goods_list) {
						var GoodsVo = vo.goods_list[_tmpi]
						goodsModel.UpdateWarehouseGoods(GoodsVo)
					}
					goodsModel.SortWarehouseList()
				} else if (vo.pos == GOODS_POS_TYPE.lung_bag) {
					for (let _tmpi in vo.goods_list) {
						var GoodsVo = vo.goods_list[_tmpi]
						goodsModel.UpdateLungBagGoods(GoodsVo)
					}
					goodsModel.Fire(local_GoodsModel.CHANGE_LUNG_BAG_LIST)
				} else if (vo.pos == GOODS_POS_TYPE.lung_equip) {
					for (let _tmpi in vo.goods_list) {
						var GoodsVo = vo.goods_list[_tmpi]
						goodsModel.UpdateLungEquipGoods(GoodsVo)
					}
					goodsModel.Fire(local_GoodsModel.CHANGE_LUNG_LIST)
				} else if (vo.pos == GOODS_POS_TYPE.baby_bag) {
					for (let _tmpi in vo.goods_list) {
						var GoodsVo = vo.goods_list[_tmpi]
						goodsModel.UpdateBabyBagGoods(GoodsVo)
					}
					goodsModel.Fire(local_GoodsModel.CHANGE_BABY_BAG)
				} else if (vo.pos == GOODS_POS_TYPE.god_bag) {
					for (let _tmpi in vo.goods_list) {
						var GoodsVo = vo.goods_list[_tmpi]
						goodsModel.UpdateGodBagGoods(GoodsVo)
					}
					goodsModel.Fire(local_GoodsModel.CHANGE_GOD_BAG_LIST)
				} else if (vo.pos == GOODS_POS_TYPE.god_equip) {
					for (let _tmpi in vo.goods_list) {
						var GoodsVo = vo.goods_list[_tmpi]
						goodsModel.UpdateGodEquipGoods(GoodsVo)
					}
					goodsModel.Fire(local_GoodsModel.CHANGE_GOD_LIST)
				} else if (vo.pos == GOODS_POS_TYPE.baby_equip) {
					for (let _tmpi in vo.goods_list) {
						var GoodsVo = vo.goods_list[_tmpi]
						goodsModel.UpdateBabyEquip(GoodsVo)
					}
					goodsModel.Fire(local_GoodsModel.CHANGE_BABY_EQUIP_LIST)
				} else if (vo.pos == GOODS_POS_TYPE.revelation_equip) {
					let cfgs = Config.PRELOAD_SERVER_CONFIG.config_revelation_equip_attr
					for (let _ in vo.goods_list) {
						let GoodsVo = vo.goods_list[_]
						goodsModel.UpdateRevelationEquip(GoodsVo, cfgs)
					}
					goodsModel.Fire(local_GoodsModel.CHANGE_REVE_EQUIP_LIST, vo.goods_list)
				} else if (vo.pos == GOODS_POS_TYPE.revelation_bag) {
					let cfgs = Config.PRELOAD_SERVER_CONFIG.config_revelation_equip_attr
					for (let _ in vo.goods_list) {
						var GoodsVo = vo.goods_list[_]
						goodsModel.UpdateRevelationBag(GoodsVo, cfgs)
					}
					goodsModel.Fire(local_GoodsModel.CHANGE_REVE_BAG_LIST)
				} else if (vo.pos == GOODS_POS_TYPE.demon_talent_bag) {
					for (let _tmpi in vo.goods_list) {
						var GoodsVo = vo.goods_list[_tmpi]
						goodsModel.UpdateDemonTalentGoods(GoodsVo)
					}
					goodsModel.Fire(local_GoodsModel.CHANGE_DEMON_TALENT_LIST)
				} else if (vo.pos == GOODS_POS_TYPE.longlangbag) {
					await new Promise<void>((resolve, reject) => {
						ResManager.GetInstance().GetGameConfigWithAutoDestory("config_draconic_equip", (cfgs) => {
							for (let _ in vo.goods_list) {
								let GoodsVo = vo.goods_list[_]
								goodsModel.UpdateLonglangGoods(GoodsVo, cfgs)
							}

							goodsModel.SortLonglangBag()
							longlang_model.RefreshDecRed()
							longlang_model.BetterEquipRed()
							resolve()
						}, false)
					})
					goodsModel.Fire(local_GoodsModel.CHANGE_LONGLANG_BAG, false)
				} else if (vo.pos == GOODS_POS_TYPE.longlangequip) {
					await new Promise<void>((resolve, reject) => {
						ResManager.GetInstance().GetGameConfigWithAutoDestory("config_draconic_equip", (cfgs) => {
							for (let _ in vo.goods_list) {
								let GoodsVo = vo.goods_list[_]
								goodsModel.UpdateLonglangEquip(GoodsVo, cfgs)
							}
							longlang_model.BetterEquipRed()
							resolve()
						}, false)
					})
					goodsModel.Fire(local_GoodsModel.CHANGE_LONGLANG_EQUIP)
				} else if (vo.pos == GOODS_POS_TYPE.starEquipBag) {
					await new Promise<void>((resolve, reject) => {
						ResManager.GetInstance().GetGameConfigWithAutoDestory("config_constellation_equip", (cfgs) => {
							if (!cfgs) {
								return
							}
							for (let GoodsVo of vo.goods_list) {
								goodsModel.UpdateStarEquipBagList(GoodsVo, cfgs)
							}
							StarEquipModel.GetInstance().UpdateEquipRed(vo.goods_list)
							StarEquipModel.GetInstance().CheckDevourRed(cfgs)
							goodsModel.SortStarEquipBagList()
							goodsModel.Fire(local_GoodsModel.CHANGE_STAREQUIP_BAG, vo.goods_list)
							resolve()
						}, false)
					})
				} else if (vo.pos == GOODS_POS_TYPE.starEquip) {
					await new Promise<void>((resolve, reject) => {
						ResManager.GetInstance().GetGameConfigWithAutoDestory("config_constellation_equip", (cfgs) => {
							for (let GoodsVo of vo.goods_list) {
								goodsModel.UpdateStarEquipList(GoodsVo, cfgs)
							}
							StarEquipModel.GetInstance().UpdateEquipRed()
							goodsModel.Fire(local_GoodsModel.CHANGE_STAREQUIP, vo.goods_list, false)
							resolve()
						}, false)
					})
				} else if (vo.pos == GOODS_POS_TYPE.godCourtBag) {
					for (let _tmpi in vo.goods_list) {
						var goodsVo = vo.goods_list[_tmpi]
						goodsModel.UpdateGodCourtBagList(goodsVo)
					}
					goodsModel.SortGodCourtBagList()
					goodsModel.Fire(local_GoodsModel.CHANGE_GODCOURT_BAG)
				} else if (vo.pos == GOODS_POS_TYPE.godCourt) {
					for (let _tmpi in vo.goods_list) {
						var goodsVo = vo.goods_list[_tmpi]
						goodsModel.UpdateGodCourtList(goodsVo)
					}
					goodsModel.Fire(local_GoodsModel.CHANGE_GODCOURT)
				} else if (vo.pos == GOODS_POS_TYPE.guildRune) {
					for (let _tmpi in vo.goods_list) {
						var goodsVo = vo.goods_list[_tmpi]
						goodsModel.UpdateGuildRuneList(goodsVo)
					}
					goodsModel.Fire(local_GoodsModel.CHANGE_GUILD_RUNE_LIST)
				}
				goodsModel.DelayFire(local_GoodsModel.UPDATE_GOODS_NUM, vo.goods_list, false)
			}

			this.On15019 = () => {
				let vo = user_mgr.GetSCMD("15019")
				if (vo.code == 1) {
					local_Message.show("分解成功")
					goodsModel.Fire(local_GoodsModel.GOODS_DECOMPOSE_SUCCESS, vo)
				} else {
					Util.ErrorCodeShow(vo.code)
				}
			}

			this.On15025 = () => {
				let vo = user_mgr.GetSCMD("15025")
				if (vo.code == 1) {
					bag_model.Fire(BagModel.SMELTING_SUCCESS)
				} else {
					Util.ErrorCodeShow(vo.code)
				}
			}

			this.On15002 = () => {
				let vo = user_mgr.GetSCMD("15002")
				if (vo) {
					if (vo.code == 1) {
						local_Message.show("扩容成功")
						if (vo.pos == GOODS_POS_TYPE.bag) {
							goodsModel.bag_goods_max_cell = vo.cell_num
						} else if (vo.pos == GOODS_POS_TYPE.warehouse) {
							goodsModel.warehouse_max_cell = vo.cell_num
						}
						goodsModel.Fire(local_GoodsModel.CHANGE_BAG_MAX_CELL, vo)
						// local_GlobalEventSystem.Fire(local_EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Bag)
					} else {
						Util.ErrorCodeShow(vo.code)
					}
				}
			}

			this.On15010 = () => {
				let vo = user_mgr.GetSCMD("15010")
				if (vo.pos == GOODS_POS_TYPE.equip) {
					goodsModel.CreateEquipList(vo.goods_list)
				} else if (vo.pos == GOODS_POS_TYPE.bag) {
					goodsModel.bag_goods_max_cell = vo.max_cell
					goodsModel.CreateBagList(vo.goods_list)
					goodsModel.hasSort = false;
					if (!goodsModel.expBookTips) {
						goodsModel.IsExpBoolTips();
					}
				} else if (vo.pos == GOODS_POS_TYPE.rune_bag) {
					goodsModel.runebag_goods_max_cell = vo.max_cell
					goodsModel.CreateRuneBagList(vo.goods_list)
				} else if (vo.pos == GOODS_POS_TYPE.rune) {
					goodsModel.CreateRuneEquipList(vo.goods_list)
				} else if (vo.pos == GOODS_POS_TYPE.spirit) {
					goodsModel.CreateSpiritEquipList(vo.goods_list)
				} else if (vo.pos == GOODS_POS_TYPE.treasurebag) {
					goodsModel.CreateTreasureList(vo.goods_list)
				} else if (vo.pos == GOODS_POS_TYPE.soul_bag) {
					goodsModel.soulbag_goods_max_cell = vo.max_cell
					goodsModel.CreateSoulBagList(vo.goods_list)
				} else if (vo.pos == GOODS_POS_TYPE.soul) {
					goodsModel.CreateSoulEquipList(vo.goods_list)
				} else if (vo.pos == GOODS_POS_TYPE.beast_bag) {
					goodsModel.CreateBeastBagList(vo.goods_list)
				} else if (vo.pos == GOODS_POS_TYPE.beast) {
					goodsModel.CreateBeastEquipList(vo.goods_list)
				} else if (vo.pos == GOODS_POS_TYPE.unreal) {
					goodsModel.CreateUnrealEquipList(vo.goods_list)
				} else if (vo.pos == GOODS_POS_TYPE.unreal_bag) {
					goodsModel.CreateUnrealBagList(vo.goods_list)
				} else if (vo.pos == GOODS_POS_TYPE.holy_seal) {
					goodsModel.CreateHolySealEquipList(vo.goods_list)
				} else if (vo.pos == GOODS_POS_TYPE.holy_seal_bag) {
					goodsModel.CreateHolySealBagList(vo.goods_list)
				} else if (vo.pos == GOODS_POS_TYPE.horse_bag) {
					goodsModel.horse_bag_goods_max_cell = vo.max_cell
					goodsModel.CreateHorseBagList(vo.goods_list)
				} else if (vo.pos == GOODS_POS_TYPE.horse) {
					goodsModel.CreateHorseEquipList(vo.goods_list)
				} else if (vo.pos == GOODS_POS_TYPE.partner_bag) {
					goodsModel.partner_bag_goods_max_cell = vo.max_cell
					goodsModel.CreatePartnerBagList(vo.goods_list)
				} else if (vo.pos == GOODS_POS_TYPE.partner) {
					goodsModel.CreatePartnerEquipList(vo.goods_list)
				} else if (vo.pos == GOODS_POS_TYPE.warehouse) {
					goodsModel.warehouse_max_cell = vo.max_cell
					goodsModel.CreateWarehouseList(vo.goods_list)
				} else if (vo.pos == GOODS_POS_TYPE.lung_bag) {
					goodsModel.CreateLungBagList(vo.goods_list)
				} else if (vo.pos == GOODS_POS_TYPE.lung_equip) {
					goodsModel.CreateLungEquipList(vo.goods_list)
				} else if (vo.pos == GOODS_POS_TYPE.baby_bag) {
					goodsModel.CreateBabyBagList(vo.goods_list)
				} else if (vo.pos == GOODS_POS_TYPE.god_equip) {
					goodsModel.CreateGodEquipList(vo.goods_list)
				} else if (vo.pos == GOODS_POS_TYPE.god_bag) {
					goodsModel.CreateGodBagList(vo.goods_list)
				} else if (vo.pos == GOODS_POS_TYPE.baby_equip) {
					goodsModel.CreateBabyEquipList(vo.goods_list)
				} else if (vo.pos == GOODS_POS_TYPE.revelation_equip) {
					goodsModel.CreateReveEquipList(vo.goods_list)
				} else if (vo.pos == GOODS_POS_TYPE.revelation_bag) {
					goodsModel.CreateReveBagList(vo.goods_list)
				} else if (vo.pos == GOODS_POS_TYPE.demon_talent_bag) {
					goodsModel.CreateDemonTalentBagList(vo.goods_list)
				} else if (vo.pos == GOODS_POS_TYPE.longlangbag) {
					goodsModel.CreateLonglangBagList(vo.goods_list)
				} else if (vo.pos == GOODS_POS_TYPE.longlangequip) {
					goodsModel.CreateLonglangEquipList(vo.goods_list)
				} else if (vo.pos == GOODS_POS_TYPE.starEquipBag) {
					let cfg = Config.PRELOAD_SERVER_CONFIG.config_constellation_equip
					goodsModel.CreateStarEquipBagList(cfg, vo.goods_list)
					goodsModel.starEquipBagMaxCell = vo.max_cell
				} else if (vo.pos == GOODS_POS_TYPE.starEquip) {
					let cfg = Config.PRELOAD_SERVER_CONFIG.config_constellation_equip
					goodsModel.CreateStarEquipList(cfg, vo.goods_list)
				} else if (vo.pos == GOODS_POS_TYPE.godCourtBag) {
					goodsModel.CreateGodCourtBagList(vo.goods_list)
					goodsModel.godCourtBagMaxCell = vo.max_cell
				} else if (vo.pos == GOODS_POS_TYPE.godCourt) {
					goodsModel.CreateGodCourtList(vo.goods_list)
				} else if (vo.pos == GOODS_POS_TYPE.guildRune) {
					goodsModel.CreateGuildRuneList(vo.goods_list)
				}
			}

			this.On15021 = () => {
				let scmd = user_mgr.GetSCMD("15021")
				if (scmd.res == 1) {
					local_Message.show("出售成功")
				} else {
					Util.ErrorCodeShow(scmd.res)
				}
			}

			this.On15024 = () => {
				let vo = user_mgr.GetSCMD("15024")
				bag_model.smelt_level = vo.level
				bag_model.smelt_exp = vo.exp
				goodsModel.Fire(local_GoodsModel.ON_SMELTING_EXP)
			}

			this.On15023 = () => {
				let vo = user_mgr.GetSCMD(15023)
			}

			this.On15050 = () => {
				let vo = user_mgr.GetSCMD(15050)
				if (goodsModel.goods_use_dic[vo.goods_id]) {
					goodsModel.goods_use_dic[vo.goods_id] = null
				}
				if (vo.res == 1) {
					let goods = goodsModel.GetGoodsBasicByTypeId(vo.goods_type_id)
					let type = null
					if (goods) {
						type = goods.type
					}
					let coolingGood = type == 35
					if (!coolingGood) {
						local_Message.show("使用成功")
					}
					// if (goods && (goods.type_id == 35 || goods.type_id == 31 || goods.type_id == 34 || goods.type_id == 36020001)) {
					// 	// let pos = BagModel.GetInstance().show_fly_pos || co.TableXY(ScreenWidth / 2 + 180, -ScreenHeight / 2 - 180)
					// 	// GlobalEventSystem.Fire(local_EventName.REWARD_FLY, { [0, goods.type_id, vo.num]}, pos)
					// }
					local_GlobalEventSystem.Fire(local_GoodsModel.USE_BAG_GOODS_SUCCESS, vo.goods_type_id)
					if ((type == 32 || coolingGood) || type == 33 || type == 84) {
						ResManager.GetInstance().LoadGameConfig(this, "config_gift_box", false, LOAD_QUEUE.HIGHT, (cfg?) => {
							if (!cfg) { return }
							let c = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_gift_box.name, vo.goods_type_id, false, cfg)
							let is_open_view = c.show == 1
							let show_goods = []
							for (let index in vo.show_goods) {

								let data = []
								data.push(vo.show_goods[index].type)
								data.push(vo.show_goods[index].goodid)
								table.insert(data, vo.show_goods[index].gnum)
								table.insert(show_goods, data)
							}
							if (is_open_view) {
								Util.ShowCongratulationView(show_goods)
							} else {
								for (let _tmpi in show_goods) {
									var v = show_goods[_tmpi]
									let [typeId, lock] = goodsModel.GetMappingTypeId(v[0], v[1])
									let basic = goodsModel.GetGoodsBasicByTypeId(typeId)
									if (basic && basic.max_overlap == 0) {
										for (let i = 0; i < v[2]; i++) {
											local_Message.show("获得<font color='" + ColorUtil.GetColorLight(basic.color, false) + "'>" + basic.goods_name + "x1</font>")
										}
									} else {
										let num = 0
										num = v[2] ? v[2] : v[1];
										local_Message.show("获得<font color='" + ColorUtil.GetColorLight(basic.color, false) + "'>" + basic.goods_name + "x" + num + "</font>")
									}
								}
							}
							ResManager.GetInstance().DestoryGameConfig(this, "config_gift_box", false)
						}
						)
						if (coolingGood) {
							let callBack = (vo?) => {
								if (vo && vo.use_count >= vo.total_count) {
									goodsModel.cleanCoolingDataById(vo.goods_id)
								}
								bag_model.has_show_red[vo.goods_id] = false
								let goods_cfg = null
								let equip_attr_cfg = null
								let equip_fusion_cfg = null
								let call_func = () => {
									if ((goods_cfg && equip_attr_cfg) && equip_fusion_cfg) {
										let bool = bag_model.ShowBagRed(goods_cfg, equip_attr_cfg, equip_fusion_cfg)
										local_GlobalEventSystem.Fire(local_EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "BagView", BagModel.Index.Goods, bool)
										// local_GlobalEventSystem.Fire(local_EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Bag)
										//goodsModel:DelayFire(local_GoodsModel.CHANGE_BAG_LIST)
										ResManager.GetInstance().DestoryGameConfig(this, "Goods", false)
										ResManager.GetInstance().DestoryGameConfig(this, "config_equip_attr", false)
										ResManager.GetInstance().DestoryGameConfig(this, "Equipfusion", false)
									}
								}

								ResManager.GetInstance().LoadGameConfig(this, "Goods", false, LOAD_QUEUE.HIGHT, (cfg?) => {
									goods_cfg = cfg
									call_func()
								}
								)
								ResManager.GetInstance().LoadGameConfig(this, "config_equip_attr", false, LOAD_QUEUE.HIGHT, (cfg?) => {
									equip_attr_cfg = cfg
									call_func()
								}
								)
								ResManager.GetInstance().LoadGameConfig(this, "Equipfusion", false, LOAD_QUEUE.HIGHT, (cfg?) => {
									equip_fusion_cfg = cfg
									call_func()
								}
								)
							}

							goodsModel.getGoodCoolingData(vo.goods_id, callBack, true)
						}
					}
				} else {
					if (!goodsModel.IsTreasureBagGoods(vo.goods_id)) {
						Util.ErrorCodeShow(vo.res, vo.args)
						if (vo.res == 4000150) {
							// GuildModel.GetInstance()._prestige_limit_mark = true
							item_use_model.ClearTypeIdData(vo.goods_id)
							item_use_model.Fire(ItemUseModel.DELETE_CUR_ITEM, undefined, true)
						}
					}
				}
			}

			this.On15053 = () => {
				let vo = user_mgr.GetSCMD("15053")
				// console.log("//////DropLog//////@On15053", "time:", Status.NowTime, "drop_id:", vo.drop_id, "status:", vo.status, "res:", vo.res)
				if (vo.res == 1) {
					//let drop = Scene.Instance.GetDropItem(vo.drop_id)
					GlobalEventSystem.Fire(SceneEventType.PICK_SCENE_DROP_SUCCESS, vo)
					SoundManager.GetInstance().PlaySoundEffect("openorclosebutton")
				} else if (vo.status == 1) {
					GlobalEventSystem.Fire(SceneEventType.START_PICK_SCENE_DROP, vo)

				} else if (vo.res == 1500020) {
					////掉落包已消失
					GlobalEventSystem.Fire(SceneEventType.DISMISS_SCENE_DROP, vo.drop_id)
					//ErrorCodeShow(vo.res)
				} else {
					//其他不能拾取的情况, 标记为不能拾取
					GlobalEventSystem.Fire(SceneEventType.CAN_NOT_PICK_SCENE_DROP, vo.drop_id)
					Util.ErrorCodeShow(vo.res, vo.args)
				}

			}

			this.On15055 = () => {
				let scmd = user_mgr.GetSCMD("15055")
				if (scmd.player_id == RoleManager.Instance.mainRoleInfo.role_id) {
					goodsModel.goods_buff_list = scmd.buff_list
				}
				goodsModel.Fire(local_GoodsModel.UPDATE_GOODS_BUFF_DATA)
				local_GlobalEventSystem.Fire(local_EventName.UPDATE_BUFF_VIEW)
			}

			this.On15026 = () => {
				let scmd = user_mgr.GetSCMD("15026")
				table.sort(scmd.exchange_list, (a, b) => {
					return a.id < b.id
				})
				goodsModel.SetGoodsExchangeData(scmd.type, scmd.exchange_list)
				goodsModel.Fire(local_GoodsModel.UPDATE_GOODS_EXCHANGE_DATA, scmd)
			}

			this.On15022 = () => {
				let scmd = user_mgr.GetSCMD("15022")
				if (scmd.errcode == 1) {
					if (scmd.type == 2 || scmd.type == 3 || scmd.type == 4) {
						local_Message.show("购买成功")
						this.SendFmtToGame(15026, "h", scmd.type)
					} else if (scmd.type == 5) {
						local_Message.show("兑换成功")
					} else if (scmd.type == 6) {
						local_Message.show("合成成功")
					} else if (scmd.type == 7) {
						local_Message.show("兑换成功")
					}
					goodsModel.Fire(local_GoodsModel.BUY_SUCCESS, scmd.id)
				} else {
					Util.ErrorCodeShow(scmd.errcode)
				}
			}

			this.On15083 = () => {
				let scmd = user_mgr.GetSCMD("15083")
				goodsModel.Fire(local_GoodsModel.REQUEST_GIFT_BAG_MSG_SUCCESS, scmd)
				if (goodsModel.gift_bag_dynamic_call_back) {
					goodsModel.gift_bag_dynamic_call_back(scmd)
					goodsModel.gift_bag_dynamic_call_back = null
				}
			}

			this.On15084 = () => {
				let scmd = user_mgr.GetSCMD("15084")
				goodsModel.setGoodCoolingData(scmd)
			}

			this.On15027 = () => {
				let scmd = user_mgr.GetSCMD("15027")
				if (scmd.opr == 1) {
					/* bag_model.Fire(BagModel.OPEN_VIEW, "GoodsExpiredView", scmd) */
					ViewPopLevelModel.GetInstance().SetView('GoodsExpiredView', scmd);
				}
			}

			this.On15086 = () => {
				let scmd = user_mgr.GetSCMD("15086")
				if (scmd.code == 1) {
					local_Message.show("兑换成功")
				} else {
					Util.ErrorCodeShow(scmd.code)
				}
			}

			this.On15088 = () => {
				let scmd = user_mgr.GetSCMD("15088")
				Scene.Instance.SetDropIndexList(scmd.drop_id_list)
			}

			let ccmd_request = (id, fmt, ...new_args) => {
				this.SendFmtToGame(id, fmt, ...new_args)
			}

			goodsModel.Bind(local_GoodsModel.REQUEST_CCMD_EVENT, ccmd_request)
			this.On15089 = () => {
				let scmd = user_mgr.GetSCMD("15089")
				goodsModel.Fire(local_GoodsModel.EXPECT_POWER, scmd)
			}

			this.On15030 = () => {
				//OnGameStart()
			}

			this.On15090 = () => {
				let scmd = user_mgr.GetSCMD("15090")
				if (scmd.code == 1) {
					if (scmd.under_color == 2) {
						if (scmd.goods_bag_type == 11) {
							Message.show("御魂背包空间不足，已为你自动分解经验材料和蓝色及以下的御魂")
						} else if (scmd.goods_bag_type == 15) {
							Message.show("源力背包空间不足，已为你自动分解经验材料和蓝色及以下的源力")
						}
					} else if (scmd.under_color == 3) {
						if (scmd.goods_bag_type == 11) {
							Message.show("御魂背包空间不足，已为你自动分解经验材料和紫色及以下的御魂")
						} else if (scmd.goods_bag_type == 15) {
							Message.show("源力背包空间不足，已为你自动分解经验材料和紫色及以下的源力")
						}
					} else if (scmd.under_color == 0) {
						if (scmd.goods_bag_type == 43) {
							Message.show("神祭背包空间不足，已为你自动分解经验材料和所有的神祭装备")
						}
					}
					goodsModel.Fire(local_GoodsModel.GOODS_DECOMPOSE_SUCCESS, scmd)
				} else {
					Util.ErrorCodeShow(scmd.code)
				}
			}

			this.RegisterProtocal(15000, this.On15000)
			this.RegisterProtocal(15001, this.On15001)
			this.RegisterProtocal(15003, this.On15003)
			this.RegisterProtocal(15008, this.On15008)
			this.RegisterProtocal(15009, this.On15009)
			this.RegisterProtocal(15017, this.On15017)
			this.RegisterProtocal(15018, this.On15018)
			this.RegisterProtocal(15002, this.On15002)
			this.RegisterProtocal(15010, this.On15010)
			this.RegisterProtocal(15021, this.On15021)
			this.RegisterProtocal(15024, this.On15024)
			this.RegisterProtocal(15019, this.On15019)
			this.RegisterProtocal(15023, this.On15023)
			this.RegisterProtocal(15025, this.On15025)
			this.RegisterProtocal(15050, this.On15050)
			this.RegisterProtocal(15053, this.On15053)
			this.RegisterProtocal(15055, this.On15055)
			this.RegisterProtocal(15026, this.On15026)
			this.RegisterProtocal(15027, this.On15027)
			this.RegisterProtocal(15022, this.On15022)
			this.RegisterProtocal(15083, this.On15083)
			this.RegisterProtocal(15084, this.On15084)
			this.RegisterProtocal(15086, this.On15086)
			this.RegisterProtocal(15087, this.On15087)
			this.RegisterProtocal(15088, this.On15088)
			this.RegisterProtocal(15089, this.On15089)
			this.RegisterProtocal(15090, this.On15090)
			this.RegisterProtocal(15030, this.On15030)
			//let OnGameStart = () => {

			//}

			//this:Bind(local_EventName.INIT_CONFIG, OnGameStart)
			goodsModel.Bind(local_GoodsModel.CREATE_BAG_LIST_FINISH, () => {
				let list = goodsModel.GetBagGoodsDic()
				for (let key in list) {

					// [ts2lua]list下标访问可能不正确
					let vo = list[key]
					if (vo.type == 35) {
						goodsModel.getGoodCoolingData(vo.goods_id, () => {
							// local_GlobalEventSystem.Fire(local_EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Bag)
						}
							, true)
					}
				}
			}
			)
			local_GlobalEventSystem.Bind(local_EventName.GAME_START, () => {
				GoodsModel.GetInstance().ReSetDynamic()
				GoodsModel.GetInstance().inintOptionalGiftMap()
				GoodsModel.GetInstance().expBookTips = false;
				let delay_fun = () => {
					this.SendFmtToGameImme(15010, "h", GOODS_POS_TYPE.equip)
					this.SendFmtToGameImme(15010, "h", GOODS_POS_TYPE.bag)
					this.SendFmtToGameImme(15010, "h", GOODS_POS_TYPE.warehouse)
					this.SendFmtToGame(15010, "h", GOODS_POS_TYPE.rune)
					this.SendFmtToGame(15010, "h", GOODS_POS_TYPE.rune_bag)
					//this:SendFmtToGame(15010, "h", GOODS_POS_TYPE.spirit)
					this.SendFmtToGame(15010, "h", GOODS_POS_TYPE.treasurebag)
					//this:SendFmtToGame(15010, "h", GOODS_POS_TYPE.soul)
					//this:SendFmtToGame(15010, "h", GOODS_POS_TYPE.soul_bag)
					this.SendFmtToGame(15010, "h", GOODS_POS_TYPE.beast)
					this.SendFmtToGame(15010, "h", GOODS_POS_TYPE.beast_bag)
					this.SendFmtToGame(15010, "h", GOODS_POS_TYPE.unreal)
					this.SendFmtToGame(15010, "h", GOODS_POS_TYPE.unreal_bag)
					this.SendFmtToGame(15010, "h", GOODS_POS_TYPE.holy_seal)
					this.SendFmtToGame(15010, "h", GOODS_POS_TYPE.holy_seal_bag)
					this.SendFmtToGame(15010, "h", GOODS_POS_TYPE.horse)
					this.SendFmtToGame(15010, "h", GOODS_POS_TYPE.horse_bag)
					this.SendFmtToGame(15010, "h", GOODS_POS_TYPE.partner)
					this.SendFmtToGame(15010, "h", GOODS_POS_TYPE.partner_bag)
					this.SendFmtToGame(15010, "h", GOODS_POS_TYPE.lung_equip)
					this.SendFmtToGame(15010, "h", GOODS_POS_TYPE.lung_bag)
					//this:SendFmtToGame(15010, "h", GOODS_POS_TYPE.baby_bag)
					//this:SendFmtToGame(15010, "h", GOODS_POS_TYPE.baby_equip)
					this.SendFmtToGame(15010, "h", GOODS_POS_TYPE.god_bag)
					this.SendFmtToGame(15010, "h", GOODS_POS_TYPE.god_equip)
					this.SendFmtToGame(15010, "h", GOODS_POS_TYPE.revelation_bag)
					this.SendFmtToGame(15010, "h", GOODS_POS_TYPE.revelation_equip)
					this.SendFmtToGame(15010, "h", GOODS_POS_TYPE.demon_talent_bag)
					this.SendFmtToGame(15010, "h", GOODS_POS_TYPE.longlangbag)
					this.SendFmtToGame(15010, "h", GOODS_POS_TYPE.longlangequip)
					this.SendFmtToGame(15010, "h", GOODS_POS_TYPE.starEquipBag)
					this.SendFmtToGame(15010, "h", GOODS_POS_TYPE.starEquip)
					this.SendFmtToGame(15010, "h", GOODS_POS_TYPE.godCourt)
					this.SendFmtToGame(15010, "h", GOODS_POS_TYPE.godCourtBag)
					this.SendFmtToGame(15010, "h", GOODS_POS_TYPE.guildRune)
					this.SendFmtToGame(15009)
					this.SendFmtToGame(15027, "c", 1)
				}
				setTimeout(delay_fun, 2.5)
			})

			role_mgr.GetMainRoleVo().Bind(local_EventName.CHANGE_LEVEL, () => { // 等级提升时检索等级直升卡是否达到最大可升等级
				goodsModel.IsExpBoolTips();
			});

			goodsModel.Bind(local_GoodsModel.UPDATE_GOODS_NUM, (goods_list: any[], isAdd: boolean) => {
				if (!isAdd) return
				let bool: boolean = goods_list.some((data) => {
					return data.type == 37 && data.subtype == 9; // 人物直升卡
				});
				if (bool) {
					goodsModel.IsExpBoolTips();
				}
			});

			let onAskEquipGoodsHandler = () => {
				this.SendFmtToGame(15010, "h", GOODS_POS_TYPE.equip)
			}

			goodsModel.Bind(local_GoodsModel.FIGURE_ASK_EQUIPGOODS, onAskEquipGoodsHandler)
			let OnAskBagGoodsHandler = () => {
				this.SendFmtToGame(15010, "h", GOODS_POS_TYPE.bag)
			}

			goodsModel.Bind(local_GoodsModel.FIGURE_ASK_BAGGOODS, OnAskBagGoodsHandler)
			let OnAskEquipBagHandler = () => {
				this.SendFmtToGame(15010, "h", GOODS_POS_TYPE.equipbag)
			}

			goodsModel.Bind(local_GoodsModel.FIGURE_ASK_EQUIPBAG, OnAskEquipBagHandler)
			let OnAskArtifactBagHandler = () => {
				this.SendFmtToGame(15010, "h", GOODS_POS_TYPE.artifactbag)
			}

			goodsModel.Bind(local_GoodsModel.FIGURE_ASK_ARTIFACTBAG, OnAskArtifactBagHandler)
			let OnAskLungEquipHandler = () => {
				this.SendFmtToGame(15010, "h", GOODS_POS_TYPE.lung_equip)
			}

			goodsModel.Bind(local_GoodsModel.FIGURE_ASK_LUNGEQUIP, OnAskLungEquipHandler)
			let OnRequestDynamic = (goods_id?, role_id?, isPlayerMessage?) => {
				if (isPlayerMessage == null) {
					isPlayerMessage = false
				}
				if (role_id) {
					goodsModel._isPlayerMessage = isPlayerMessage
					this.SendFmtToGame(15001, "ll", role_id, goods_id)
				} else {
					this.SendFmtToGame(15000, "l", goods_id)
				}
			}

			goodsModel.Bind(local_GoodsModel.REQUEST_GOODS_DYNAMIC, OnRequestDynamic)
			let OnExpandBagHandler = (pos?, cell_num?) => {
				this.SendFmtToGame(15002, "hh", pos, cell_num)
			}

			goodsModel.Bind(local_GoodsModel.ASK_EXPAND_BAG, OnExpandBagHandler)
			let ResolveGoods = (goods_list?) => {
				this.WriteBegin(15019)
				this.WriteFMT("h", Util.TableSize(goods_list))
				for (let index in goods_list) {

					// [ts2lua]goods_list下标访问可能不正确
					this.WriteFMT("l", goods_list[index].goods_id)
					// [ts2lua]goods_list下标访问可能不正确
					this.WriteFMT("i", goods_list[index].goods_num)
				}
				this.SendToGame()
			}

			goodsModel.Bind(local_GoodsModel.RESOLVE_GOODS, ResolveGoods)
			let OnSellGoodsHandler = (goods_list?) => {
				let index = goods_list.length
				this.WriteBegin(15021)
				this.WriteFMT("h", index)
				let i = 0
				do {
					this.WriteFMT("l", goods_list[i].goods_id)
					this.WriteFMT("i", goods_list[i].num)
					i = i + 1
				} while ((i < index))
				this.SendToGame()
			}

			goodsModel.Bind(local_GoodsModel.SELL_GOODS, OnSellGoodsHandler)
			let OnChangeArtifactPos = (goods_id?) => {
				this.SendFmtToGame(15023, "l", goods_id)
			}

			goodsModel.Bind(local_GoodsModel.CHANGE_GOODS_SUB_POS, OnChangeArtifactPos)
			let OnDevourEquipment = () => {
				this.WriteBegin(15025)
				this.WriteFMT("h", bag_model.devour_number)
				for (let _tmpi in bag_model.devour_list) {
					var GoodsVo = bag_model.devour_list[_tmpi]
					if (GoodsVo.goods_id) {
						this.WriteFMT("l", GoodsVo.goods_id)
						this.WriteFMT("i", GoodsVo.goods_num)
					}
				}
				this.SendToGame()
			}

			goodsModel.Bind(local_GoodsModel.DEVOUR_EQUIPMENT, OnDevourEquipment)
			let OnSmeltingArtifact = () => {
				this.WriteBegin(15025)
				this.WriteFMT("h", Util.TableSize(bag_model.smeltSelectList))
				for (let key in bag_model.smeltSelectList) {
					this.WriteFMT("l", key)
					this.WriteFMT("i", bag_model.smeltSelectList[key])
				}
				this.SendToGame()
			}

			goodsModel.Bind(local_GoodsModel.SMELTING_ARTIFACT, OnSmeltingArtifact)
			let UseHandler = (goods_id?, number?) => {
				if (!goods_id || !number) {
					return
				}
				let goodvo = goodsModel.GetGoodsVoByGoodsId(goods_id)
				if (goodvo) {
					// if (goodvo.type == 38 && goodvo.subtype == 26) {
					// 	let is_activite = role_mgr.IsActiviteByTypeId(goodvo.type_id)
					// 	if (is_activite) {
					// 		let ok_func = () => {
					// 			let list = [{ goods_id: goods_id, num: number }]
					// 			goodsModel.Fire(local_GoodsModel.SELL_GOODS, list)
					// 		}

					// 		let str = "已激活该头像，是否出售该物品"
					// 		Alert.Show(str, Alert_Type.Two, ok_func, undefined, "出售", "取消")
					// 		return
					// 	}
					// }
				}
				// [ts2lua]goodsModel.goods_use_dic下标访问可能不正确
				goodsModel.goods_use_dic[goods_id] = true
				this.SendFmtToGame(15050, "li", goods_id, number)
			}

			goodsModel.Bind(local_GoodsModel.USE_BAG_GOODS, UseHandler)
			let getBuffList = () => {
				this.SendFmtToGame(15055)
			}

			goodsModel.Bind(local_GoodsModel.GET_GOODS_BUFF_LIST, getBuffList)
			let MoveGoods = (goods_id?, from_pos?, to_pos?) => {
				if (goods_id && from_pos && to_pos) {
					this.SendFmtToGame(15003, "lhh", goods_id, from_pos, to_pos)
				}
			}

			goodsModel.Bind(local_GoodsModel.MOVE_GOODS_POS, MoveGoods)
			let optional_gift = (gift_id?, gift_list?) => {
				this.WriteBegin(15086)
				this.WriteFMT("l", gift_id)
				this.WriteFMT("h", Util.TableSize(gift_list))
				for (let key in gift_list) {

					this.WriteFMT("c", Number(key))
					// [ts2lua]gift_list下标访问可能不正确
					this.WriteFMT("i", gift_list[key])
				}
				this.SendToGame()
			}

			goodsModel.Bind(local_GoodsModel.RECEIVED_OPTIONAL_GIFT, optional_gift)
			let request_exchange_goods = (exchange_type?) => {
				this.SendFmtToGame(15026, "h", exchange_type)
			}

			goodsModel.Bind(local_GoodsModel.REQUEST_EXCHANGE_GOODS, request_exchange_goods)
			let exchange_fun = (id?, num?) => {
				this.SendFmtToGame(15022, "li", id, num)
			}

			goodsModel.Bind(local_GoodsModel.EXCHANGE_GOODS, exchange_fun)
			let request_gift_bag = (goods_id?, typr_id?) => {
				this.SendFmtToGame(15083, "li", goods_id, typr_id)
			}

			goodsModel.Bind(local_GoodsModel.REQUEST_GIFT_BAG_MSG, request_gift_bag)
			let request_goods_cooling = (goods_id?) => {
				this.SendFmtToGame(15084, "l", goods_id)
			}

			goodsModel.Bind(local_GoodsModel.REQUEST_GOODS_COOLING, request_goods_cooling)

			local_GlobalEventSystem.Bind(SceneEventType.REQUEST_PICK_UP_SCENE_DROP, (drop_id?) => {
				this.SendFmtToGame(15053, "l", drop_id)
			})
		}

		this.InitInfo()
	}



}
window["GoodsController"] = GoodsController
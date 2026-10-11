import { BaseController } from "../common/BaseController"
import { CommonManager } from "../common/CommonManager"
import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { EquipEvent, EquipModel, EquipDefine } from "../commonModel/EquipModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { LoadLuaClassAB, PlayBigEffect, Util } from "../util/Util"
import { Config } from "../common/Config"

import "../equip/EquipView"
import "../equip/EquipStrenView"
import "../equip/EquipStrenMasterView"
import "../equip/EquipSmeltView"
import "../jewel/EquipJewelView"
import "../jewel/EquipJewelBagView"
import "../jewel/EquipJewelCraveEnterView"
import "../jewel/EquipJewelCraveView"
import "../jewel/EquipJewelMasterView"
import "../equipWash/EquipWashView"
import "../equipWash/EquipWashGoodsView"
import "../equipRefinement/EquipRefiUpLvView"
import "../equipRefinement/EquipRefinementView"
import { MainFunc } from "../commonModel/MainUIModel"
// import { MaterialsTool } from "../common/MaterialsTool"
import "../suit/EquipSuitBaseView"
import "../suit/EquipSuitReturnView"
import { SuitModel, SuitModelEvent } from "../commonModel/SuitModel"

export class EquipController extends BaseController {
	InitEvent
	InitInfo
	static Instance: any

	public constructor() {
		super()
		let local_EquipEvent = EquipEvent
		let model = EquipModel.GetInstance()
		let goods_model = GoodsModel.GetInstance()
		let local_GoodsModel = GoodsModel
		let local_GlobalEventSystem = GlobalEventSystem
		let REFRESH_FUNCTION_ICON_RED_DOT = EventName.REFRESH_FUNCTION_ICON_RED_DOT
		let local_EventName = EventName
		let role_mgr = RoleManager.GetInstance()
		let local_EquipDefine = EquipDefine
		let common_mgr = CommonManager.GetInstance()
		let user_msg_adapter = UserMsgAdapter.GetInstance()
		// let material_tool = MaterialsTool.GetInstance()
		let local_Message = Message
		SuitModel.GetInstance().InitConf();
		let view_dic_ = {}

		this.InitEvent = () => {
			model.Bind(local_EquipEvent.REQUEST_PROTO, (id, fmt, ...new_args) => {
				if (15213 == id) {
					this.WriteBegin(id)
					this.WriteFMT("c", new_args[0])
					this.WriteFMT("h", new_args[1])
					if (new_args[1] > 0) {
						let lock_dic = model.wash_lock_dic[new_args[0]]
						for (let key in lock_dic) {
							this.WriteFMT("c", (Number(key) + 1))
						}
					}
					this.WriteFMT("c", new_args[2])
					this.SendToGame()
				} else {
					this.SendFmtToGame(id, fmt, ...new_args)
				}
			}
			)
			model.Bind(local_EquipEvent.OPEN_VIEW, (view_name: string, ...new_args) => {
				let callback = () => {
					let view = view_dic_[view_name]
					if (!view) {
						let viewName = window[view_name]
						view = new viewName()
						view_dic_[view_name] = view
					}
					view.Open(...new_args)
				}
				LoadLuaClassAB(view_name, callback)
			}
			)
			model.Bind(local_EquipEvent.CLOSE_VIEW, (view_name?) => {
				let view = view_dic_[view_name]
				if (view && view.HasOpen()) {
					view.Close()
					view_dic_[view_name] = null
				}
			}
			)
			goods_model.Bind(local_GoodsModel.CHANGE_EQUIPLIST, () => {
				model.CheckStrenRedDotAll()
				model.CheckSmeltRedDotAll()
				model.CheckJewelRedAll()
				model.CheckJewelCraveReddot()
				//local_GlobalEventSystem:Fire(REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Bag)
			})

			goods_model.Bind(local_GoodsModel.CHANGE_BAG_LIST, () => {
				//local_GlobalEventSystem:Fire(REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Role)
			}
			)
			role_mgr.GetMainRoleVo().BindOne("vip_flag", () => {
				model.CheckJewelRedAll()
			}
			)
			//VipModel:GetInstance():Bind(VipModel.UPDATE_NOBLE_STATE,() => {
			//model:CheckJewelRedAll()
			//}
			//)
			goods_model.Bind(local_GoodsModel.UPDATE_GOODS_NUM, (goods_list?) => {
				if (role_mgr.GetMainRoleVo().level < local_EquipDefine.JEWEL_OPEN_LV) {
					return
				}
				let goods_basic = null
				for (let _tmpi in goods_list) {
					let info = goods_list[_tmpi]
					goods_basic = goods_model.GetGoodsBasicByTypeId(info.type_id)
					if (goods_basic && local_EquipDefine.JEWEL_TYPE == goods_basic.type) {
						model.CheckJewelRedAll()
						break
					}
				}
			}
			)
			goods_model.Bind(local_GoodsModel.UPDATE_GOODS_NUM, (goods_list?) => {
				if (role_mgr.GetMainRoleVo().level < local_EquipDefine.SUIT_OPEN_LV) {
					return
				}
				let goods_basic = null
				for (let _tmpi in goods_list) {
					let info = goods_list[_tmpi]
					goods_basic = goods_model.GetGoodsBasicByTypeId(info.type_id)
					if (!goods_basic) {
						break
					}
					if (local_EquipDefine.SUIT_GOODS_TYPE != goods_basic.type) {
						break
					}
					if (local_EquipDefine.SUIT_GOODS_SUBTYPE != goods_basic.subtype) {
						break
					}
					model.CheckSuitRedDotAll()
					break
				}
			}
			)
			goods_model.Bind(local_GoodsModel.CHANGE_EQUIPLIST, () => {
				model.CheckWashRed()
				model.CheckSuitRedDotAll()
				model.checkRefinementRed()
				model.checkRefinementRed()
			})

			goods_model.Bind(local_GoodsModel.EQUIP_DYNAMIC_FINISH, () => {
				model.CheckStrenRedDotAll()
				model.CheckSmeltRedDotAll()
				model.CheckWashRed()
				model.CheckSuitRedDotAll()
				model.CheckJewelRedAll()
				model.CheckJewelCraveReddot()
				model.checkRefinementRed()
				// model.CheckSuitRedDotAll()
			}
			)
			role_mgr.GetMainRoleVo().BindOne("tong", (type?, val?, oval?, p?) => {
				let is_add = !oval || val > oval
				model.CheckStrenRedDotAll(is_add)
			}
			)
			goods_model.Bind(local_GoodsModel.UPDATE_GOODS_NUM, (goods_list?, is_add?) => {
				for (let _tmpi in goods_list) {
					let info = goods_list[_tmpi]
					if (local_EquipDefine.SMELT_GOODS_TYPE_ID == info.type_id) {
						model.CheckSmeltRedDotAll(is_add)
					}
				}
			}
			)
			//local_GlobalEventSystem:Bind(ServerTimeModel.HOUR_REFRESH,(hour?) => {
			//let role_lv = role_mgr.GetMainRoleVo().level
			//let pos = 1
			//do {
			//let info = model.GetWashUnlockLvInfo(pos)
			//if (info ) {
			//// [ts2lua]info下标访问可能不正确
			//if (role_lv >= info["unlock_lv"] ) {
			//this:SendFmtToGame(15214)
			//return
			//}
			//}
			//pos=pos+1
			//} while ((pos <= 10))
			//model:checkRefinementRed()
			//}
			//)
			//local_GlobalEventSystem:Bind(local_EventName.INIT_CONFIG,() => {
			//model:InitConfig1()
			//model:InitConfig2()
			//model:InitConfig3()
			//}
			//)
			local_GlobalEventSystem.Bind(local_EventName.GAME_START, () => {
				let suitModel: SuitModel = SuitModel.GetInstance();
				suitModel.ClearSuitPos();
				suitModel.ClearSuitPower();

				this.SendFmtToGame(15214)
				model.Reset()
				model.InitEquipWashLockDic()
				model.InitConfig1()
				this.SendFmtToGame(15217)
				this.SendFmtToGame(15220)
				for (let i = 1; i <= 10; i++) {
					this.SendFmtToGame(15210, "c", i)
				}
				model.Fire(EquipEvent.REQUEST_PROTO, 15261)
			}
			)

			// this.SendFmtToGame(15220)
			role_mgr.GetMainRoleVo().Bind(local_EventName.CHANGE_LEVEL, (lv?) => {
				// for (let i = 0; i < 10; i++) {
				// 	let pos_cfg = model.GetWashUnlockLvInfo(i)
				// 	if (pos_cfg && lv >= pos_cfg["unlock_lv"]) {
				// 		this.SendFmtToGame(15214)
				// 		return
				// 	}
				// }
				// model.checkRefinementRed()
			}
			)
			goods_model.Bind(local_GoodsModel.UPDATE_GOODS_NUM, (goods_list?) => {
				model.CheckJewelCraveReddot()
				for (let _tmpi in goods_list) {
					let info = goods_list[_tmpi]
					if (local_EquipDefine.REFINEMENT_GOODS == info.type_id || local_EquipDefine.REFINEMENT_TWO_GOODS == info.type_id) {
						model.checkRefinementRed()
						break
					}
				}

				// 共鸣红点
				let bool: boolean = SuitModel.GetInstance().GetSuitTotlaRed();
				if (bool) {
					SuitModel.GetInstance().Fire(SuitModelEvent.UP_SUIT_RED);
					local_GlobalEventSystem.Fire(REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Role);
				}

			})

			goods_model.Bind(local_GoodsModel.UPDATE_GOODS_NUM, (goods_list?) => {
				if (!common_mgr.CheckFuncOpenState("EquipWashView", true)) {
					return
				}
				for (let _tmpi in goods_list) {
					let info = goods_list[_tmpi]
					if (local_EquipDefine.WASH_DIVISION_GOODS == info.type_id) {
						model.CheckWashRed()
						break
					}
				}
			})
		}

		this.InitInfo = () => {
			let on15200 = () => {
				let scmd = user_msg_adapter.GetSCMD(15200)
				Util.ErrorCodeShow(scmd.res)
				if (scmd.res == 1520090) {

				} else if (scmd.res == 1520091) {
					// material_tool.materialsTips(local_EquipDefine.SMELT_GOODS_TYPE_ID)
				}
			}

			let on15201 = () => {
				let scmd = user_msg_adapter.GetSCMD(15201)
				if (scmd.res == 1) {
					local_Message.show("穿戴装备成功")
					model.Fire(local_EquipEvent.WEAR_SUCCESS, scmd)
					goods_model.Fire(local_GoodsModel.REQUEST_GOODS_DYNAMIC, scmd.goods_id)
					model.Fire(local_EquipEvent.REQUEST_PROTO, 15204, "c", scmd.cell_pos)
					model.Fire(local_EquipEvent.REQUEST_PROTO, 15250, "c", scmd.cell_pos)
					if (scmd.old_goods_id != 0) {
						goods_model.Fire(local_GoodsModel.REQUEST_GOODS_DYNAMIC, scmd.old_goods_id)
					}
					goods_model.Fire(local_GoodsModel.FIGURE_ASK_EQUIPGOODS)
				} else {
					Util.ErrorCodeShow(scmd.res)
				}
			}

			let on15202 = () => {
				let scmd = user_msg_adapter.GetSCMD(15202)
				if (scmd.res == 1) {
					local_Message.show("卸下装备成功")
					goods_model.Fire(local_GoodsModel.FIGURE_ASK_EQUIPGOODS)
					goods_model.DeleteDynamic(scmd.goods_id)
				} else {
					Util.ErrorCodeShow(scmd.res)
				}
			}

			let on15204 = () => {
				let scmd = user_msg_adapter.GetSCMD(15204)
				model.SetStrengthInfo(scmd)
			}

			let on15205 = () => {
				let scmd = user_msg_adapter.GetSCMD(15205)
				if (scmd.res == 1) {
					let gmodel = goods_model
					for (let _tmpi in scmd.stren_info) {
						let info = scmd.stren_info[_tmpi]
						let wear_info = model.GetWearEquipInfo(info.equip_type)
						let dynamic = gmodel.GetDynamic(wear_info.goods_id)
						wear_info.stren = info.stren
						if (dynamic) {
							dynamic.stren = info.stren
						}
						model.SetStrengthInfo(info, false)
					}
					if (scmd.stren_info.length < 1) {
						local_Message.show("强化失败")
					} else if (scmd.type == 1) {
						model.Fire(local_EquipEvent.UPDATE_ONE_STREN, scmd.stren_info)
					} else if (scmd.type == 2) {
						model.Fire(local_EquipEvent.UPDATE_ALL_STREN, scmd)
					}
					model.CheckStrenRedDotAll()
				} else {
					if (scmd.type == 2 && scmd.res1 != 0) {
						model.Fire(local_EquipEvent.ALL_STREN_FAIL, scmd)
					}
					if (scmd.res == 1520090) {

					} else {
						Util.ErrorCodeShow(scmd.res)
					}
				}
			}

			let on15208 = () => {
				let scmd = user_msg_adapter.GetSCMD(15208)
				if (scmd.res == 1) {
					model.Fire(local_EquipEvent.CLOSE_VIEW, "EquipJewelBagView")
					let wear_info = model.GetWearEquipInfo(scmd.equip_type)
					if (!wear_info) {
						return
					}
					let dynamic = goods_model.GetDynamic(wear_info.goods_id, null, false, true)
					if (!dynamic) {
						return
					}
					let list = dynamic.stone_list
					let inlay = false
					for (let _tmpi in list) {
						let info = list[_tmpi]
						if (scmd.pos == info.pos) {
							info.type_id = scmd.type_id
							inlay = true
							break
						}
					}
					if (!inlay) {
						table.insert(list, scmd)
					}
					model.Fire(local_EquipEvent.SET_JEWEL, scmd)
					let equip_stone_inlay_cfg = Config.PRELOAD_SERVER_CONFIG.config_equip_stone_inlay
					let jewel_lv_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_equip_stone_lv", false)
					let equip_stone_pos_unlock_cfg = Config.PRELOAD_SERVER_CONFIG.config_equip_stone_pos_unlock
					if (equip_stone_inlay_cfg && jewel_lv_cfg && equip_stone_pos_unlock_cfg) {
						if (model.is_setting) {
							let success = model.DoSetAll(equip_stone_inlay_cfg, jewel_lv_cfg, equip_stone_pos_unlock_cfg)
							if (!success) {
								// local_Message.show("镶嵌成功")
								PlayBigEffect("ui_baoshi_02");
							}
						}
					}

					if (!model.is_setting) {
						PlayBigEffect("ui_baoshi_02");
					}

					model.CheckJewelRedAll()
				} else {
					Util.ErrorCodeShow(scmd.res)
					if (model.is_setting) {
						model.is_setting = false
					}
				}
			}

			let on15209 = () => {
				let scmd = user_msg_adapter.GetSCMD(15209)
				if (scmd.res == 1) {
					let wear_info = model.GetWearEquipInfo(scmd.equip_type)
					if (!wear_info) {
						return
					}
					let dynamic = goods_model.GetDynamic(wear_info.goods_id, null, false, true)
					if (!dynamic) {
						return
					}
					let list = dynamic.stone_list
					let pos = 0
					for (let _tmpi in dynamic.stone_list) {
						let info = dynamic.stone_list[_tmpi]
						if (scmd.pos == info.pos) {
							table.remove(list, pos)
							break
						}
						pos = pos + 1
					}
					model.Fire(local_EquipEvent.OFF_JEWEL, scmd)
					model.CheckJewelRedAll()
				} else {
					Util.ErrorCodeShow(scmd.res)
				}
			}

			let on15210 = () => {
				let scmd = user_msg_adapter.GetSCMD(15210)
				if (scmd.res == 1) {
					model.jewel_crave_data_list[scmd.equip_type] = scmd
					model.Fire(local_EquipEvent.JEWEL_SEMLT_INFO, scmd)
					local_GlobalEventSystem.Fire(REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Equip)
				} else {
					Util.ErrorCodeShow(scmd.res)
				}
			}

			let on15211 = () => {
				let scmd = user_msg_adapter.GetSCMD(15211)
				if (scmd.res == 1) {
					model.Fire(local_EquipEvent.JEWEL_SEMLT_SUCCESS, scmd)
					this.SendFmtToGame(15210, "c", scmd.equip_type)
				} else {
					Util.ErrorCodeShow(scmd.res)
				}
			}

			let on15215 = () => {
				let scmd = user_msg_adapter.GetSCMD(15215)
				if (scmd.res == 1) {
					model.Fire(local_EquipEvent.CLOSE_VIEW, "EquipJewelBagView");
					if (!model.isOneKeyUpgrade) {
						local_Message.show("升级宝石成功")
					}
					let wear_info = model.GetWearEquipInfo(scmd.equip_type)
					if (!wear_info) {
						return
					}
					let dynamic = goods_model.GetDynamic(wear_info.goods_id, null, false, true)
					if (!dynamic) {
						return
					}
					let list = dynamic.stone_list
					let inlay = false
					for (let _tmpi in list) {
						let info = list[_tmpi]
						if (scmd.pos == info.pos) {
							info.type_id = scmd.type_id
							inlay = true
							break
						}
					}
					model.CheckJewelRedAll()
					model.Fire(local_EquipEvent.UPGRADE_JEWEL, scmd)
				} else {
					model.isOneKeyUpgrade = false;
					Util.ErrorCodeShow(scmd.res)
				}
			}

			let on15216 = () => {
				let scmd = user_msg_adapter.GetSCMD(15216)
				if (scmd.res == 1) {
					if (scmd.is_one_key == 1) {
						model.one_key_mark = true
						this.SendFmtToGame(15216, "ic", scmd.type_id, 1)
					} else {
						local_Message.show("合成宝石成功")
						model.CheckJewelRedAll()
						model.Fire(local_EquipEvent.COMPOSE_JEWEL, scmd)
					}
				} else {
					if (scmd.is_one_key == 1 && model.one_key_mark) {
						model.one_key_mark = false
						local_Message.show("合成宝石成功")
						model.CheckJewelRedAll()
						model.Fire(local_EquipEvent.COMPOSE_JEWEL, scmd)
					} else {
						Util.ErrorCodeShow(scmd.res)
					}
				}
			}

			let on15217 = () => {
				let scmd = user_msg_adapter.GetSCMD(15217)
				model.setGodEquipInfo(scmd)
			}

			let on15218 = () => {
				let scmd = user_msg_adapter.GetSCMD(15218)
				if (scmd.code == 1) {
					model.Fire(local_EquipEvent.GOD_EQUIP_UP)
					this.SendFmtToGame(15217)
				}
				Util.ErrorCodeShow(scmd.code)
			}

			let on15219 = () => {
				let scmd = user_msg_adapter.GetSCMD(15219)
				model.godEquip_total_power_up = scmd.power
				this.Fire(local_EquipEvent.GOD_EQUIP_POWER_UP_RETURN, scmd.power)
			}

			let on15220 = () => {
				let scmd = user_msg_adapter.GetSCMD(15220);
				let suitModel: SuitModel = SuitModel.GetInstance();
				for (const iterator of scmd.suit_list) {
					suitModel.SetSuitPos(iterator);
				}

				suitModel.Fire(SuitModelEvent.UP_SUIT_POS_INFO);
				model.SetSuitData(scmd.suit_list)
				model.CheckSuitRedDotAll()
			}

			let on15221 = () => {
				let scmd = user_msg_adapter.GetSCMD(15221)
				local_Message.show("打造共鸣成功")
				// let dynamic = model.GetWearEquipDynamic(scmd.equip_type)
				// let sdata = model.GetSuitDataByDynamic(dynamic, scmd.lv)
				// let old_suit_slv = sdata.suit_slv
				// if (sdata.suit_lv == 0 && sdata.suit_slv == 0 ) {
				// table.insert(dynamic.suit_list, sdata)
				// }
				// sdata.suit_lv = scmd.lv
				// sdata.suit_slv = scmd.slv
				// let old_result = model.GetSuitNumAndEquips(scmd.equip_type, scmd.lv, old_suit_slv)
				// for (let _tmpi in old_result.list) {
				// let info = old_result.list[_tmpi]
				// let sdata = model.GetSuitDataByDynamic(info, scmd.lv)
				// sdata.suit_count = old_result.num
				// }
				// let new_result = model.GetSuitNumAndEquips(scmd.equip_type, scmd.lv, scmd.slv)
				// for (let _tmpi in new_result.list) {
				// let info = new_result.list[_tmpi]
				// let sdata = model.GetSuitDataByDynamic(info, scmd.lv)
				// sdata.suit_count = new_result.num
				// }

				SuitModel.GetInstance().SetSuitPos({ equip_type: scmd.equip_type, type: scmd.type, slv: scmd.slv });
				SuitModel.GetInstance().Fire(SuitModelEvent.UP_SUIT_SUCCESS);

				// model.UpdateSuitData(scmd)
				model.CheckSuitRedDotAll()
				model.Fire(local_EquipEvent.BUILD_SUIT_SUCCESS)
			}

			let on15222 = () => {
				let scmd = user_msg_adapter.GetSCMD(15222)
				local_Message.show("还原共鸣成功")
				//let dynamic = model.GetWearEquipDynamic(scmd.equip_type)
				//let sdata = model.GetSuitDataByDynamic(dynamic, scmd.lv)
				//let old_suit_slv = sdata.suit_slv
				//sdata.suit_lv = scmd.lv
				//sdata.suit_slv = scmd.slv
				//if (sdata.suit_lv == 0 && sdata.suit_slv == 0 ) {
				//table.insert(dynamic.suit_list, sdata)
				//}
				//let old_result = model.GetSuitNumAndEquips(scmd.equip_type, scmd.lv, old_suit_slv)
				//for (let _tmpi in old_result.list) {
				// let info = old_result.list[_tmpi]
				//let sdata = model.GetSuitDataByDynamic(info, scmd.lv)
				//sdata.suit_count = old_result.num
				//}
				//let new_result = model.GetSuitNumAndEquips(scmd.equip_type, scmd.lv, scmd.slv)
				//for (let _tmpi in new_result.list) {
				// let info = new_result.list[_tmpi]
				//let sdata = model.GetSuitDataByDynamic(info, scmd.lv)
				//sdata.suit_count = new_result.num
				//}




				// model.UpdateSuitData(scmd)
				model.CheckSuitRedDotAll()
				model.Fire(local_EquipEvent.BACK_SUIT_SUCCESS)
				if (scmd.slv < 1) {
					model.Fire(local_EquipEvent.CLOSE_VIEW, "EquipSuitReturnView")
				}
				let list = []
				for (let _tmpi in scmd.reward_list) {
					let vo = scmd.reward_list[_tmpi]
					let type = 0
					if (vo.type == 101) {
						let attr_list = ErlangParser.GetInstance().Parse(vo.attr_list)
						for (let _tmpi in attr_list) {
							let attr = attr_list[_tmpi]
							if (attr[0] == "bind") {
								type = Number(attr[1]) == 1 && 100 || 0
							}
						}
					}
					table.insert(list, [type, vo.id, vo.num])
				}
				Util.ShowCongratulationView(list)

				SuitModel.GetInstance().SetSuitPos({ equip_type: scmd.equip_type, type: scmd.make_type, slv: scmd.slv });
				SuitModel.GetInstance().Fire(SuitModelEvent.BACK_SUIT_SUCCESS);
			}

			let on15223 = () => {
				let scmd = user_msg_adapter.GetSCMD(15223)
				model.Fire(local_EquipEvent.UPDATE_SUIT_REWARD, scmd)
			}

			let on15250 = () => {
				let scmd = user_msg_adapter.GetSCMD(15250)
				model.SetSmeltInfo(scmd)
			}

			let on15251 = () => {
				let scmd = user_msg_adapter.GetSCMD(15251)
				if (scmd.res == 1) {
					for (let _tmpi in scmd.refine_info) {
						let info = scmd.refine_info[_tmpi]
						let sinfo = model.GetSmeltInfo(info.equip_type)
						if (sinfo) {
							sinfo.refine_high = info.refine_high
							sinfo.refine = info.refine_high
						} else {
							info.refine = info.refine_high
							model.SetSmeltInfo(info, false)
						}
					}
					if (scmd.refine_info.length < 1) {
						local_Message.show("精炼失败")
					} else if (scmd.type == 1) {
						model.Fire(local_EquipEvent.UPDATE_ONE_SMELT, scmd.refine_info)
					} else if (scmd.type == 2) {
						model.Fire(local_EquipEvent.UPDATE_ALL_SMELT, scmd)
					}
					model.CheckSmeltRedDotAll()
				} else {
					if (scmd.type == 2 && scmd.res1 != 0) {
						model.Fire(local_EquipEvent.ALL_SMELT_FAIL, scmd)
					} else {
						Util.ErrorCodeShow(scmd.res)
					}
				}
			}

			let on15212 = () => {
				let scmd = user_msg_adapter.GetSCMD(15212)
				if (scmd.res == 1) {
					goods_model.GetDynamic(scmd.goods_id, (vo?) => {
						model.Fire(local_EquipEvent.OPEN_WASH_PROP, scmd)
						model.CheckWashRed()
					}
						, true)
				} else {
					Util.ErrorCodeShow(scmd.res)
				}
			}

			let on15213 = () => {
				let scmd = user_msg_adapter.GetSCMD(15213)
				model.wash_lock = false
				model.Fire(local_EquipEvent.UPDATE_WASH_EQUIP, scmd)
				if (scmd.res != 1) {
					Util.ErrorCodeShow(scmd.res)
					return
				}
				this.SendFmtToGame(15214)
			}

			let on15214 = () => {
				let scmd = user_msg_adapter.GetSCMD(15214)
				model.wash_free_times = scmd.free_times
				if (!common_mgr.CheckFuncOpenState("EquipWashView", true)) {
					return
				}
				model.CheckWashRed()
				model.Fire(local_EquipEvent.UPDATE_WASH_FREETIEM, scmd)
			}

			let on15252 = () => {
				let scmd = user_msg_adapter.GetSCMD(15252)
				if (scmd.res != 1) {
					Util.ErrorCodeShow(scmd.res)
					return
				}
				goods_model.GetDynamic(scmd.goods_id, (vo?) => {
					model.Fire(local_EquipEvent.UPDATE_WASH_EQUIP, scmd)
					model.CheckWashRed()
				}, true)
			}

			let on15254 = () => {
				let scmd = user_msg_adapter.GetSCMD(15254)
				model.Fire(local_EquipEvent.SUBTYPE_POWER, scmd)
			}

			let on15255 = () => {
				let scmd = user_msg_adapter.GetSCMD(15255)
				if (scmd.code != 1) {
					Util.ErrorCodeShow(scmd.code)
					return
				}
				let equip_infos = model.GetWearEquipDynamics()
				if (!equip_infos || equip_infos.length == 0) {
					return
				}
				let equip = null
				for (let _tmpi in equip_infos) {
					let vo = equip_infos[_tmpi]
					if (vo.goods_id == scmd.goods_id) {
						vo.refinement_lv = scmd.refine_lv
						equip = vo
						break
					}
				}
				model.checkRefinementRed()
				model.Fire(local_EquipEvent.UPDATA_REFI_VIEW, equip)
			}

			// 激活全身奖励
			let on15260 = () => {
				let scmd = user_msg_adapter.GetSCMD(15260)
				if (scmd.errcode != 1) {
					Util.ErrorCodeShow(scmd.errcode)
					return
				}
				model.UpdateMasterData(scmd.type, scmd.whole_lv)
				model.Fire(local_EquipEvent.UPDATE_MASTER_VIEW)
				model.CheckJewelRedAll()
				model.CheckStrenRedDotAll()
				model.Fire(local_EquipEvent.UPDATE_MASTER_RED)
			}

			// 获取全身奖励
			let on15261 = () => {
				let scmd = user_msg_adapter.GetSCMD(15261)
				model.SetMasterData(scmd.list)
				model.Fire(local_EquipEvent.UPDATE_MASTER_VIEW)
			}

			// 共鸣套装战力
			let on15262 = () => {
				let scmd = user_msg_adapter.GetSCMD(15262);
				let suitModel: SuitModel = SuitModel.GetInstance();
				suitModel.SetSuitsPower(scmd.pos, scmd.type, scmd.lv, scmd.list);
				suitModel.Fire(SuitModelEvent.UP_SUIT_POWER);
			}





			this.RegisterProtocal(15200, on15200)
			this.RegisterProtocal(15201, on15201)
			this.RegisterProtocal(15202, on15202)
			this.RegisterProtocal(15204, on15204)
			this.RegisterProtocal(15205, on15205)
			this.RegisterProtocal(15208, on15208)
			this.RegisterProtocal(15209, on15209)
			this.RegisterProtocal(15210, on15210)
			this.RegisterProtocal(15211, on15211)
			this.RegisterProtocal(15212, on15212)
			this.RegisterProtocal(15213, on15213)
			this.RegisterProtocal(15214, on15214)
			this.RegisterProtocal(15215, on15215)
			this.RegisterProtocal(15216, on15216)
			this.RegisterProtocal(15217, on15217)
			this.RegisterProtocal(15218, on15218)
			this.RegisterProtocal(15219, on15219)
			this.RegisterProtocal(15220, on15220)
			this.RegisterProtocal(15221, on15221)
			this.RegisterProtocal(15222, on15222)
			this.RegisterProtocal(15223, on15223)
			this.RegisterProtocal(15250, on15250)
			this.RegisterProtocal(15251, on15251)
			this.RegisterProtocal(15252, on15252)
			this.RegisterProtocal(15254, on15254)
			this.RegisterProtocal(15255, on15255)
			this.RegisterProtocal(15260, on15260)
			this.RegisterProtocal(15261, on15261)
			this.RegisterProtocal(15262, on15262)
		}

		this.InitInfo()
		this.InitEvent()
	}

	public static GetInstance() {
		if (!EquipController.Instance) {
			EquipController.Instance = new EquipController()
		}
		return EquipController.Instance
	}
}

window["EquipController"] = EquipController
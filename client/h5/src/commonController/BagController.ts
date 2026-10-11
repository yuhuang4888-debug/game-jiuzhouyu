
//require("game.bag.BagComponentView")
//require("game.bag.BagEquipItem")
//require("game.bag.BagItemRenderer")
//require("game.common.BagModel")
//require("game.bag.BagSmeltItemRender")
//require("game.bag.BagSmeltView")
//require("game.bag.BagView")
//require("game.common.BatchUseView")
//require("game.bag.ExpandBagView")
//require("game.bag.GoodsBagItemRenderer")
//require("game.common.GoodsExpiredView")
//require("game.bag.OneKeyTabItem")
//require("game.bag.OneKeyUseItem")
//require("game.bag.OneKeyUseView")
//require("game.bag.SelectGiftItem")
//require("game.bag.SelectGiftView")
//require("game.bag.SellView")
//require("game.bag.SmeltPropView")
//require("game.bag.WarehouseBagRenderer")
//require("game.bag.WarehouseRenderer")
//require("game.bag.WarehouseView")
//require("game.diamondGift.DiamondGiftView")
//require("game.bag.EquipmentIcon")
//require("game.bag.EquipToolTipItem")
//require("game.transfer.TransferView")
//require("game.transfer.TransferItem")
//require("game.transfer.TransferActView")

import { Alert, Alert_Type } from "../alert/Alert"
import { BagView } from "../bag/BagView"
import { BaseController } from "../common/BaseController"
import { Config } from "../common/Config"
import { EventName } from "../common/EventName"
import { OpenFun } from "../common/OpenFun"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { BagModel } from "../commonModel/BagModel"
import { EquipDefine, EquipModel } from "../commonModel/EquipModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { RoleManager } from "../commonModel/RoleManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { SettingModel } from "../commonModel/SettingModel"
import "../bag/BagSmeltView"
import "../bag/ExpandBagView"
import "../bag/OneKeyUseView"
import "../bag/SmeltPropView"
import "../bag/SelectGiftView"
import "../common/BatchUseView"
import "../bag/SellView"
import "../diamondGift/DiamondGiftView"
import "../common/GoodsExpiredView"
import { MainFunc } from "../commonModel/MainUIModel"
import { enum_OutWardType } from "../commonModel/OutWardBaseModel"
import { longlangModel } from "../commonModel/longlangModel"
import { StarEquipModel } from "../commonModel/StarEquipModel"
import { LungModel, LungEvent } from "../commonModel/LungModel"
export class BagController extends BaseController {
	view_dic
	one_key_id
	bagView
	InitEvent
	oneKeyDevouring

	public constructor() {
		super()
		this.view_dic = [];
		this.oneKeyDevouring = false;
		this.InitEvent = () => {
			let goodsmodel = GoodsModel.GetInstance()
			let bagmodel = BagModel.GetInstance()
			let local_GlobalEventSystem = GlobalEventSystem
			let local_EventName = EventName
			let local_BagModel = BagModel
			let local_GoodsModel = GoodsModel
			let OnSmeltViewOpen = () => {
				this.SendFmtToGame(15024)
			}

			local_GlobalEventSystem.Bind(local_EventName.OPEN_SMELTING_VIEW, OnSmeltViewOpen)
			bagmodel.Bind(local_BagModel.REQUEST_PROTO, (id, fmt, ...new_args) => {
				this.SendFmtToGame(id, fmt, ...new_args)
			}
			)
			let flag = null
			let OpenBagView = (index?) => {
				//if (window["BagView"] ) {

				// let callback = () => {
				if (!this.bagView) {
					this.bagView = new BagView()
				}
				if (this.bagView.HasOpen() && index == null) {
					this.bagView.Close()
				} else {
					this.bagView.SetDefaultIndex(index)
					this.bagView.Open()
				}
				// }
				// LoadLuaClassAB("BagView", callback)
				//}
			}

			local_GlobalEventSystem.Bind(local_EventName.OPEN_BAG_VIEW, OpenBagView)

			let OnBagChange = () => {
				bagmodel.ShowBagRed()
				EquipModel.GetInstance().CheckStrongestRed()
				local_GlobalEventSystem.Fire(local_EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Bag)
				if (goodsmodel.bag_goods_list.length < goodsmodel.bag_goods_max_cell) {
					bagmodel.ShowFullView[local_GoodsModel.GOODS_POS_TYPE.bag] = true
				}
			}

			goodsmodel.Bind(local_GoodsModel.CHANGE_BAG_LIST, OnBagChange)

			let OpenView = (view_name: string, ...new_args) => {
				let parms = new_args
				var callback = () => {
					let view = this.view_dic[view_name]
					if (!view) {
						// this.view_dic[view_name] = true
						// if (this.view_dic[view_name] == true) {
						let view_class = window[view_name]
						view = new view_class()
						this.view_dic[view_name] = view
						// }
					}
					if (view && view != true) {
						view.Open(...new_args)
					}
				}
				// if (view_name == "BatchUseView") {
				callback()
				// } else {
				// 	LoadLuaClassAB(view_name, callback)
				// }
			}

			bagmodel.Bind(local_BagModel.OPEN_VIEW, OpenView)
			let AutoSmeltSet = (scmd?) => {
				if (scmd.type == 4 && scmd.subtype == 1) {
					bagmodel.autoSmelt = scmd.is_open == 1
				}
			}
			SettingModel.GetInstance().Bind(SettingModel.UPDATE_ONE_SETTING_INFO, AutoSmeltSet)
			
			let On15029 = () => {
				let scmd = UserMsgAdapter.GetInstance().GetSCMD(15029)
				if (scmd) {
					if (bagmodel.ShowFullView[scmd.location] && !bagmodel.bagViewOpen[scmd.location]) {
						bagmodel.ShowFullView[scmd.location] = false
						Alert.Show("背包已满，物品已邮件发送，是否前往整理", Alert_Type.Two, () => {
							if (scmd.location == 4) {
								OpenFun.OpenFunHandler(105)
							} else if (scmd.location == 45) {
								OpenFun.OpenFunHandler(170)
							}
							bagmodel.bagViewOpen[scmd.location] = true
							bagmodel.ShowFullView[scmd.location] = true
						}
							, () => {
								bagmodel.ShowFullView[scmd.location] = false
							}
							, "整理")
					}
				}
			}

			this.RegisterProtocal(15029, On15029)

			let role_vo = RoleManager.GetInstance().GetMainRoleVo()
			if (role_vo && role_vo.level < EquipDefine.NOT_SHOW_OND_KEY_WEAR_DOT_LV) {
				this.one_key_id = role_vo.Bind(local_EventName.CHANGE_LEVEL, (lv?) => {
					if (lv == EquipDefine.NOT_SHOW_OND_KEY_WEAR_DOT_LV) {
						EquipModel.GetInstance().CheckStrongestRed()
						bagmodel.Fire(BagModel.UPDATE_ONE_KEY_RED)
						local_GlobalEventSystem.Fire(local_EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Bag)
						role_vo.UnBind(this.one_key_id)
					}
				}
				)
			}

			let clean_bag_to_openView = (code_id, str) => {
				let ErrorCodeBagTypeMap = {
					"1500031": {jump_id: 106},
					"1500131": {jump_id: 195},
					"1500132": {jump_id: 84},
					"1500133": {jump_id: 2},
					"1500134": {jump_id: 15},
					"1500135": {jump_id: 147},
					"1500137": {jump_id: 170},
					"6220002": {jump_id: 164},
					"1500101": {jump_id: 198},
					"3000010": {jump_id: 105},
					"4010004": {jump_id: 105},
					"4160000": {jump_id: 105},
					"4160001": {jump_id: 105},
					"1500003": {jump_id: 105},
					"1500112": {jump_id: 105},
					"1500113": {jump_id: 105},

					"1810022": {jump_id: 117},
					"2330014": {jump_id: 175},
				}
				let _info = ErrorCodeBagTypeMap[code_id]
				if(_info == null) return;
				let jump_id = _info.jump_id;
                let ok = () => {
					GlobalEventSystem.Fire(EventName.TOOLTIPS_JUMP);
					if(jump_id != 2 && jump_id != 15){
						OpenFun.OpenFunHandler(jump_id);
					}
					switch (jump_id) {
						case 105: //背包 -> 普通背包+吞噬
							bagmodel.Fire(local_BagModel.OPEN_VIEW, "BagSmeltView")
							break 
						case 84: //背包 -> 影装 + 影装分解
							GlobalEventSystem.Fire(EventName.OPEN_VIEW, "HolySealDecomposeView")
							break
						case 195: //通灵  -> 灵饰 + 灵饰背包
							GlobalEventSystem.Fire(EventName.OPEN_VIEW, "UnrealDecomposeView")
							break
						case 2: //式神 -> 坐骑 + 坐骑背包
							GlobalEventSystem.Fire(EventName.OPEN_VIEW, "PetEquipBaseView", enum_OutWardType.Horse)
							break
						case 15://式神 -> 侍魂 + 侍魂背包
							GlobalEventSystem.Fire(EventName.OPEN_VIEW, "PetEquipBaseView", enum_OutWardType.Partner)
							break
						case 170://式神 -> 圣衣 + 圣衣背包吞噬
							StarEquipModel.GetInstance().Fire(StarEquipModel.OPEN_VIEW, "StarEquipBasicView", 1)
							break
						case 164://背包 -> 神祭背包 + 神祭分解
							longlangModel.GetInstance().Fire(longlangModel.OPEN_VIEW, "longlangSBaseView")
							break
						case 198://通灵 -> 蜃妖 + 蜃妖背包
							GlobalEventSystem.Fire(EventName.OPEN_VIEW, "GodBeastBagView")
							break
						case 117://通灵 -> 神纹 + 神纹背包
							LungModel.GetInstance().Fire(LungEvent.LUNG_OPEN_VIEW, "LungBagView")
							break	
					}
                }
                Alert.Show(str, Alert_Type.Two, ok, null, "前往整理", "取消")
			}
			local_GlobalEventSystem.Bind(local_EventName.JUMP_VIEW_TO_CLEAN_BAG, clean_bag_to_openView)

		}

		this.InitEvent()
	}

}
window["BagController"] = BagController
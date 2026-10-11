import { Alert, Alert_Type } from "../alert/Alert"
import { attributePotionModel } from "../commonModel/attributePotionModel"
import { BagModel } from "../commonModel/BagModel"
import { DsgtModel } from "../commonModel/DsgtModel"
import { EquipModel, EquipEvent } from "../commonModel/EquipModel"
import { FashionModel } from "../commonModel/FashionModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { ItemUseModel } from "../commonModel/ItemUseModel"
import { MainFunc } from "../commonModel/MainUIModel"
import { MarriageModel } from "../commonModel/MarriageModel"
import { OutWardBaseModel } from "../commonModel/OutWardBaseModel"
import { ShopEvent, ShopModel, ShopType } from "../commonModel/ShopModel"
import { TaskTipType } from "../commonModel/TaskModel"
import { UnrealModel } from "../commonModel/UnrealModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Point } from "../scene/AstarManager"
import { SceneManager } from "../scene/SceneManager"
import { Message } from "../sysInfo/SysInfoController"
import { ColorUtil } from "../util/ColorUtil"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { Util, GlobalTimerQuest, SetAnchoredPosition } from "../util/Util"
import { BaseView1 } from "./BaseView1"
import { Config } from "./Config"
import { EquipmentItem } from "./EquipmentItem"
import { EventName } from "./EventName"
import { Enum_UILayer } from "./LayerManager"
import { OpenFun } from "./OpenFun"
import { ResManager } from "./ResManager"
import { UIToolTipMgr } from "./UIToolTipMgr"
import { ViewManager } from "./ViewManager"
import { DailyModel } from "../commonModel/DailyModel"
import { OutLineModel } from "../commonModel/OutLineModel"
import { SYTweenLite } from "../util/SYTweenLite"
import { SYTweenFunc } from "../util/SYTweenFunc"
import { TreasureMapModel } from "../commonModel/TreasureMapModel"
import "../transferJob/TransferJobCardView"
import { HolySealModel } from "../commonModel/HolySealModel"
import { OnHookModel } from "../commonModel/OnHookModel"
import { PlatformManager } from "../PlatformManager"
import { ViewPopLevelModel } from "../commonModel/ViewPopLevelModel"

export class ItemUseView extends BaseView1 {
	private unreal_wear_state

	IsCanCompose
	Local_Open
	ItemCallFun
	ShowEquipArrow
	FuncInfo
	InitEvent
	ShowEffect
	GetTypeId
	CheckShowEffectAndAutoUse
	IsAutoUse
	DestoryCallback
	CancelTimer
	GetGoodsId
	EnterFunc
	UseTimer
	DeleteCurrentItem
	InitView

	is_anim = false
	anim_y = 244
	anim_time = 0.3	// 秒
	anim_pos_id = null
	anim_alpha_id = null

	public constructor() {
		super()
		let goods_model = GoodsModel.GetInstance()
		let equip_model = EquipModel.GetInstance()
		let dsgt_model = DsgtModel.GetInstance()
		let out_ward_base_model = OutWardBaseModel.GetInstance()
		let local_GoodsModel = GoodsModel
		let UI_tool_tip_mgr = UIToolTipMgr.GetInstance()
		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName
		let local_ItemUseModel = ItemUseModel
		let local_EquipEvent = EquipEvent
		let local_Config = Config
		let role_mgr = RoleManager.GetInstance()
		let local_OpenFun = OpenFun
		let bag_model = BagModel.GetInstance()
		let local_BagModel = BagModel
		let attribu_potion_model = attributePotionModel.GetInstance()
		let shop_model = ShopModel.GetInstance()
		let daily_model = DailyModel.GetInstance()
		let local_Math = Math
		let out_line_model = OnHookModel.GetInstance()
		let local_Message = Message
		let model: ItemUseModel = ItemUseModel.GetInstance()
		let _goods_vo = null
		let _goods_item = null
		let _use_last_time = 10
		let _timer_id = null
		let _cur_show_type = null
		let _fly_vo_ = null
		let _now_count_down_type_id
		let _enter_label_desc

		this.base_file = "common"
		this.layout_file = "ItemUseView"
		this.destroy_imm = true
		this.layer_value = Enum_UILayer.Activity
		this.preload_server_config = {
			"config_goods": false,
			"config_equip_pos2suittype": false,
		}
		this.load_callback = () => {
            if(PlatformManager.IsEyouEnPlatform()){
                this.bottom_label.centerX = 0
				this.bottom_label.width = 176
				this.bottom_label.height = 42
				this.bottom_label.y= 202
				this.bottom_label.wordWrap =true
				this.bottom_label.leading = 0.1 //默认10行高
            }
			this.display_obj.centerX = 150
			this.display_obj.centerY = 150

			this.InitEvent()

			if (!_goods_item) {
				_goods_item = new EquipmentItem(this.item_group, null, this.layer_value)
				_goods_item.Load()
			}
			_goods_item.ExcuteCallback(() => {
				_goods_item.SetScale(0.7)
			})
			//if (_goods_vo ) {
			//this:InitView()
			//}
			// SetAnchoredPosition(this, 100, 80)
		}

		this.destroy_callback = () => {
			this.DestoryCallback()
		}

		this.open_callback = () => {
			// this.cache_sort_order = this.AddCurrLayerSortingOrder(this.layer_value)
			this._gp_con.alpha = 0
			this._gp_con.y = this.anim_y
			this.InitView()
		}

		this.Local_Open = (vo?) => {
			_goods_vo = vo
			super.Open()
		}

		this.InitView = () => {
			if (!_goods_vo) {
				return
			}

			if(!ItemUseModel.GetInstance().CheckItemUseVoExist(_goods_vo)){
				this.DeleteCurrentItem()
				return
			}
			//awarditem保存了SortOrder，第二个之后的物品不会显示特效
			// _goods_item.SetCacheSortOrder(this.cache_sort_order)
			let goods_basic = goods_model.GetGoodsBasicByTypeId(_goods_vo.type_id)
			if (!goods_basic) {
				return
			}
			let goods_num = model.GetTypeGoodsNum(_goods_vo.goods_id)
			if (goods_basic && goods_basic.type == 10) {
				let wear_equip_info = equip_model.GetWearEquipInfo(goods_basic.equip_type)
				let better = !wear_equip_info || wear_equip_info.rating < _goods_vo.rating
				_cur_show_type = better && 2 || 3
				this.up_arrow.visible = better
				_enter_label_desc = better && "装备" || "确定"
				this.bottom_label.text = better && "" || "合成可获更强装备！"
			} else if ((goods_basic && goods_basic.type == 38) && goods_basic.subtype == 6) {
				_cur_show_type = 4
				this.up_arrow.visible = false
				let order = dsgt_model.GetDsgtOrderByTypeID(_goods_vo.type_id)
				_enter_label_desc = (order && order > 0) && "晋升" || "激活"
				goods_num = 0
			} else if ((goods_basic && goods_basic.type == 38) && goods_basic.subtype == 7) {
				let num = _goods_vo.goods_num
				if (num && num > 0) {
					// let outline_time = DailyModel.GetInstance().outline_info || OutLineModel.GetInstance().GetOnhookTime()
					let outline_time = OnHookModel.GetInstance().GetOnhookTime()
					let hours = Math.floor(outline_time / 3600)
					if (hours > 15) {
						this.Close()
						return
					} else if (hours > 10) {
						num = Math.min(1, num)
					} else if (hours > 5) {
						num = Math.min(2, num)
					} else if (hours > 0) {
						num = Math.min(3, num)
					} else if (hours == 0) {
						num = Math.min(4, num)
					}
					_cur_show_type = 1
					this.bottom_label.text = ""
					_enter_label_desc = "使用"
					goods_num = num
				} else {
					_cur_show_type = 0
					this.bottom_label.text = "剩余不足2小时"
					_enter_label_desc = "购买"
					goods_num = 0
				}
				this.up_arrow.visible = false
			} else if (((goods_basic.type <= 22 && goods_basic.type >= 16) && _goods_vo.subtype == 3) || (_goods_vo.type == 69 && _goods_vo.subtype == 1) || (_goods_vo.type == 25 && _goods_vo.subtype == 3)) {
				let Info = this.FuncInfo()
				this.bottom_label.text = ""
				if (Info && Info[0] == 160) {
					if (out_ward_base_model.HasActiveIllu(Info[1], Info[2])) {
						_enter_label_desc = "使用"
						_cur_show_type = 1
					} else {
						_cur_show_type = 5
						_enter_label_desc = "激活"
					}
				}
			} else if (_goods_vo.type == 12) {
				let Info = this.FuncInfo()
				this.bottom_label.text = ""
				let fashion_model = FashionModel.GetInstance()
				if (fashion_model.IsActive(1, _goods_vo.type_id)) {
					_enter_label_desc = "使用"
					_cur_show_type = 1
				} else {
					_cur_show_type = 5
					_enter_label_desc = "激活"
				}
			} else if (_goods_vo.type == UnrealModel.goods_type) {
				if (ViewManager.GetInstance().GetViewOpenState("SecretTreasureMainView")) {
					_enter_label_desc = "立即穿戴"
					this.unreal_wear_state = true
				} else {
					_enter_label_desc = "前往穿戴"
				}

			} else if (_goods_vo.type == HolySealModel.GOODS_TYPE) { // 影装
				_enter_label_desc = "前往穿戴";
				this.up_arrow.visible = true;
				this.bottom_label.text = "";
			} else {
				_cur_show_type = 1
				this.up_arrow.visible = false
				_enter_label_desc = "使用"
				this.bottom_label.text = ""
			}
			_goods_item.SetData(_goods_vo.type_id, goods_num)
			// _goods_item.SetClickCallBack(this.ItemCallFun)

			let goods = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_goods.name, _goods_vo.type_id, false)
			if (goods) {
				this.name_label.text = goods.goods_name
				let name_color = ColorUtil.GetColorDark(goods.color).replace(/'#(\w+)'/, "#$1")
				this.name_label.color = name_color
			} else {
				this.name_label.text = ""
			}

			this._gp_con.visible = true
			this.is_anim = true
			if(this._gp_con.y == 0){
				this.is_anim = false
				this.CheckShowEffectAndAutoUse()
			}
			else{
				this.anim_pos_id = SYTweenLite.to(this, this._gp_con, SYTweenLite.UiAnimationType.POSY, 0, this.anim_time, () => {
					if (this.anim_pos_id) {
						SYTweenLite.Stop(this.anim_pos_id)
						this.anim_pos_id = null
					}
					this.is_anim = false
					this.CheckShowEffectAndAutoUse()
				}, SYTweenFunc.EASE_OUT)
			}

			this.anim_alpha_id = SYTweenLite.to(this, this._gp_con, SYTweenLite.UiAnimationType.ALPHA, 1, this.anim_time, () => {
				if (this.anim_alpha_id) {
					SYTweenLite.Stop(this.anim_alpha_id)
					this.anim_alpha_id = null
				}
			}, SYTweenFunc.EASE_OUT)
		}

		this.ItemCallFun = () => {
			if (_goods_vo) {
				if (_goods_vo.type == 10) {
					UI_tool_tip_mgr.AppendEquipTips(_goods_vo.type_id, null, null, _goods_vo)
				} else if (_goods_vo.type == UnrealModel.goods_type) {
					UI_tool_tip_mgr.AppendUnrealTips(_goods_vo.type_id, _goods_vo)
				} else {
					UI_tool_tip_mgr.AppendGoodsTips(_goods_vo.type_id, null, null, null, _goods_vo.goods_num, null, this)
				}
			}
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this.close_btn, () => {
				if (this.is_anim) {
					return
				}
				if (_goods_vo) {
					if (!model.ContainEquipRecord(_goods_vo.type_id)) {
						model.SaveEquipRecord(_goods_vo.type_id)
					}
				}
				this.DeleteCurrentItem(null, true)
			}, this, true);

			Util.AddClickEvent(this.enter_btn, () => {
				if (this.is_anim) {
					return
				}
				local_GlobalEventSystem.Fire(local_EventName.HIDE_FINGER, this.enter_btn)
				this.EnterFunc()
			}, this, true);

			this.BindEvent(goods_model, local_GoodsModel.TRY_SHOW_ITEM_USE_VIEW, (list?) => {
				if (this.use_delete_method) {
					return
				}
				if (!_goods_vo) {
					return
				}
				for (let _tmpi in list) {
					let vo = list[_tmpi]
					if (vo.goods_id == _goods_vo.goods_id) {
						let goods_num = vo.goods_num
						if (goods_num <= 0) {
							this.DeleteCurrentItem()
							return
						}
						let basic = goods_model.GetGoodsBasicByTypeId(vo.type_id)
						if (basic.type == 10) {
							_goods_item.ChangeCountVisible(false, 0)
						} else {
							_goods_item.ChangeCountVisible(true, goods_num)
							_goods_vo.goods_num = goods_num
						}
						return
					}
				}
			}
			)
			let onDeleteCurrentItem = (count?, force?) => {
				this.DeleteCurrentItem(count, force)
			}
			this.BindEvent(model, local_ItemUseModel.DELETE_CUR_ITEM, onDeleteCurrentItem)

			let update_equip_data = (vo?, goods_id?) => {
				if (_goods_vo && _goods_vo.goods_id == goods_id) {
					this.Open(vo)
				}
			}
			this.BindEvent(model, local_ItemUseModel.UPDATE_EQUIP_DATA, update_equip_data)

			let onFlyAction = (scmd?) => {
				if (!_fly_vo_) return
				let vo = _fly_vo_
				let list = [{ style: 0, typeId: vo.type_id, count: vo.goods_num }]
				let p = new Laya.Point(this.enter_btn.width / 2, this.enter_btn.height / 2)
				let pos = this.enter_btn.localToGlobal(p)
				// local_GlobalEventSystem.Fire(local_EventName.REWARD_FLY, list, pos, undefined, undefined, 1, 0, 800, MainFunc.Role)
			}
			this.BindEvent(equip_model, local_EquipEvent.WEAR_SUCCESS, onFlyAction)

			let onUpdateTask = () => {
				if (this.use_delete_method) {
					return
				}
				this.ShowEquipArrow()
			}
			this.BindEvent(GlobalEventSystem, EventName.UPDATE_NEWEST_TASK_ID, onUpdateTask)

			this.ShowEquipArrow()
		}

		this.DeleteCurrentItem = (count?, force?) => {
			if (!_goods_vo) {
				this.Close()
				return
			}
			if (((_goods_vo.goods_num && _goods_vo.goods_num <= 1) || _goods_vo.type == 10) || _goods_vo.type == 12 || force) {
				model.ClearTypeIdData(_goods_vo.goods_id)
			}
			let vo = model.GetItemShowVo(false,true)
			if (vo == _goods_vo) {
				return
			}
			if (!model.ContainEquipRecord(_goods_vo.type_id) && this.IsCanCompose()) {
				model.SaveEquipRecord(_goods_vo.type_id)
			}
			if (vo) {
				if ((((!count && _goods_vo.type == vo.type) && _goods_vo.subtype == vo.subtype) && vo.type == 38) && vo.subtype == 6) {
					model.ClearTypeIdData(vo.goods_id)
					this.DeleteCurrentItem()
				} else {
					this.Close()
					ViewPopLevelModel.GetInstance().SetView("ItemUseView",vo)
					// local_GlobalEventSystem.Fire(local_EventName.OPEN_ITEM_USE_VIEW, vo)
				}
			} else {
				model.ClearEquipList()
				this.Close()
			}
		}

		this.UseTimer = () => {
			_use_last_time = _use_last_time - 1
			if (_cur_show_type == 1) {
				this.enter_btn_text.text = "使用(" + _use_last_time + "s)"
			} else if (_cur_show_type == 2) {
				this.enter_btn_text.text = "装备(" + _use_last_time + "s)"
			} else if (_cur_show_type == 3) {
				this.enter_btn_text.text = "确定(" + _use_last_time + "s)"
			} else if (_cur_show_type == 4) {
				this.bottom_label.text = _use_last_time + "s后自动关闭"
			} else if (_cur_show_type == 5) {
				this.enter_btn_text.text = "激活(" + _use_last_time + "s)"
			}
			if (_use_last_time <= 0) {
				// this.CancelTimer()
				this.EnterFunc()
			}
		}

		this.CancelTimer = () => {
			if (_timer_id) {
				GlobalTimerQuest.CancelQuest(_timer_id)
				_timer_id = null
			}
			this.enter_btn_text.text = _enter_label_desc
			_now_count_down_type_id = null
		}

		this.GetTypeId = () => {
			if (_goods_vo) {
				return _goods_vo.type_id
			} else {
				return null
			}
		}

		this.GetGoodsId = () => {
			if (_goods_vo) {
				return _goods_vo.goods_id
			} else {
				return null
			}
		}

		this.EnterFunc = (count?) => {
			this.CancelTimer()
			_fly_vo_ = null
			if (_goods_vo) {
				let Clientcfg = local_Config.GetConfigVo(Config.ConfigHasDefaultValue.ClientItemUse.name, _goods_vo.type_id, true)
				let goods_basic = goods_model.GetGoodsBasicByTypeId(_goods_vo.type_id)
				if (!goods_basic) {
					return
				}
				if (goods_basic.type_id == 31 || goods_basic.type_id == 34 || goods_basic.type_id == 35
					|| goods_basic.type_id == 36020001 || goods_basic.type_id == 36010001) {
					goods_model.Fire(local_GoodsModel.USE_BAG_GOODS, _goods_vo.goods_id, _goods_vo.goods_num)
					let pos = this.enter_btn.localToGlobal(new Laya.Point(75, 26))
					GlobalEventSystem.Fire(EventName.REWARD_FLY, [[0, _goods_vo.type_id, _goods_vo.goods_num]], pos)
					this.DeleteCurrentItem()
					return
				}

				//御魂
				if (goods_basic.type == 26) {
					GlobalEventSystem.Fire(EventName.CLOSE_VIEW,"CompositeRuneView")
					OpenFun.OpenFunHandler(110)
					this.Close()
					return
				}


				if (goods_basic.type == 10) {
					if (_cur_show_type == 3) {
						this.DeleteCurrentItem()
						return
					}
					let cfgs = ResManager.GetInstance().GetGameConfigFromCache(this, "config_goods", false)
					let cfg = local_Config.GetConfigVo("Goods", _goods_vo.type_id, false, cfgs)
					let career = role_mgr.GetMainRoleVo().career
					if (cfg.career_id != 0 && cfg.career_id != career) {
						local_Message.show("装备职业类型不符合")
						this.DeleteCurrentItem()
						return
					}
					let wear_info = equip_model.GetWearEquipInfo(_goods_vo.equip_type)
					if (wear_info && wear_info.goods_id == _goods_vo.goods_id) {
						local_Message.show("无法替换当前已穿戴的装备")
						this.DeleteCurrentItem()
						return
					}

					let showAlert
					if (wear_info) {
						let cfg_suit = ResManager.GetInstance().GetGameConfigFromCache(this, "config_equip_pos2suittype", false)
						let suitCfg = cfg_suit[_goods_vo.equip_type]
						if (suitCfg) {
							if (suitCfg.type == 1) {
								let curLv = equip_model.GetCurSuitLv(_goods_vo.equip_type)
								if (curLv > 0) {
									if (wear_info.stage == _goods_vo.stage) {
										showAlert = !equip_model.EquipSuitCanUp(_goods_vo, false, true)
									} else {
										showAlert = true
									}
								}
							} else {
								let cursLv = equip_model.GetCurSuitsLv(_goods_vo.equip_type)
								if (cursLv > 0) {
									showAlert = !equip_model.JewelSuitCanUp(_goods_vo, false, true)
								}
							}
						}
					}

					let func = () => {
						equip_model.Fire(local_EquipEvent.REQUEST_PROTO, 15201, "l", _goods_vo.goods_id)
						_fly_vo_ = _goods_vo
					}

					if (showAlert) {
						// Alert.Show("当前装备无法继承共鸣，是否拆解共鸣并继续穿戴？", Alert_Type.Two, func)
						func();
					} else {
						func()
					}

					this.DeleteCurrentItem()
				} else {
					if (_goods_vo.type == 38 && _goods_vo.subtype == 6) {
						model.ClearTypeIdData(_goods_vo.goods_id)
						let type_id = _goods_vo.type_id
						let dsgt_cfg = dsgt_model.GetDsgtCfgByActiveGoods(type_id)
						if (!dsgt_cfg) {
							this.DeleteCurrentItem()
							return
						}
						let dsgt_id = dsgt_cfg.id
						let order = dsgt_cfg.order
						if (order) {
							local_OpenFun.OpenFunHandler(35, dsgt_id)
						} else {
							let scmd = (order && order > 0) && 41106 || 41109
							dsgt_model.Fire(DsgtModel.SCMD_REQUEST, scmd, dsgt_id)
						}
						this.DeleteCurrentItem(count)
						return
					}
					if (_goods_vo.type == 34) {
						bag_model.Fire(local_BagModel.OPEN_VIEW, "SelectGiftView", _goods_vo)
						this.DeleteCurrentItem()
						return
					} else if (_goods_vo.type == 33) {
						local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "DiamondGiftView", _goods_vo)
						this.DeleteCurrentItem()
						return
					}
					if (_goods_vo.type == 56) {
						let level = role_mgr.GetMainRoleVo().level
						if (level >= 200) {
							attribu_potion_model.useAttribute(_goods_vo.type_id)
						} else {
							if (_use_last_time > 0) {
								let config = attribu_potion_model.getAttrConfig(_goods_vo.type_id)
								let index = config && config.lv || 1
								local_GlobalEventSystem.Fire(local_EventName.SWITCH_MAIN_FUNC_VIEW, MainFunc.Role)
								local_GlobalEventSystem.Fire(local_EventName.OPEN_ATTRIBUTEPOTION_VIEW, index)
							}
						}
						this.DeleteCurrentItem()
						return
					}
					if (_goods_vo.type == 76) {
						local_GlobalEventSystem.Fire(local_EventName.OPEN_MEDAL_ENTER_VIEW, 1)
						this.DeleteCurrentItem(null, true)
						return
					}
					if (_goods_vo.type == 38 && _goods_vo.subtype == 7) {
						let num = DailyModel.GetInstance().GetRecommendUseNum(_goods_vo)
						//let num = _goods_vo.goods_num
						if (!num || num == 0) {
							if (!count) {
								let shop_data = shop_model.GetShopDataByType(ShopType.Bind_Diamond)
								if (shop_data) {
									for (let _tmpi in shop_data) {
										let v = shop_data[_tmpi]
										if (v.goods_id == _goods_vo.type_id) {
											v.scmd = 15302
											let goods_vo = []
											goods_vo["goods_num"] = 4
											goods_vo["type_id"] = _goods_vo.type_id
											let num = daily_model.GetRecommendUseNum(goods_vo)
											let price = null
											if (v.discount == 0 || v.discount < 100) {
												price = local_Math.floor(v.price * v.discount / 100 + 0.5)
											} else {
												price = v.price
											}
											let role_vo = role_mgr.mainRoleInfo
											let is_can_buy = local_Math.floor(role_vo.jin + role_vo.jinLock / price)
											let buy_num = is_can_buy == 0 && 1 || (is_can_buy >= num && num || is_can_buy)
											v.cur_num = buy_num
											shop_model.Fire(ShopEvent.SHOP_OPEN_VIEW, "ShopBulkPurchaseView", v)
										}
									}
								}
							}
							this.DeleteCurrentItem()
							return
						}
						let ok_callback = () => {
							if (count) {
								goods_model.Fire(local_GoodsModel.USE_BAG_GOODS, _goods_vo.goods_id, count)
							} else if ((!_goods_vo.goods_num || _goods_vo.goods_num <= 1)) {
								goods_model.Fire(local_GoodsModel.USE_BAG_GOODS, _goods_vo.goods_id, 1)
							} else {
								bag_model.Fire(local_BagModel.OPEN_VIEW, "BatchUseView", _goods_vo, 1, num, _goods_vo.goods_num)
							}
						}

						let value = null
						if (count) {
							value = count
						} else if ((!num || num <= 1)) {
							value = 1
						} else {
							value = num
						}
						let time = daily_model.outline_info || out_line_model.GetOnhookTime()
						let add_time = out_line_model.add_time[_goods_vo.type_id]
						if (time + add_time * value > out_line_model.max_outline_time) {
							let time = local_Math.floor(out_line_model.max_outline_time / 3600)
							Alert.Show("使用后离线挂机时间将会溢出(最多" + time + "个小时),是否继续使用", Alert_Type.Two, ok_callback)
						} else {
							ok_callback()
						}
						this.DeleteCurrentItem()
						return
					}
					if (((_goods_vo.type == 40 && _goods_vo.subtype == 6) && MarriageModel.GetInstance().GetRingInfo()) && MarriageModel.GetInstance().GetRingInfo().star == 0) {
						local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "MarriageBaseView", 2)
						return
					}

					if (((_goods_vo.type < 22 && _goods_vo.type >= 16) && _goods_vo.subtype == 3) || (_goods_vo.type == 69 && _goods_vo.subtype == 1) || (_goods_vo.type == 25 && _goods_vo.subtype == 3)) {
						let Info = this.FuncInfo()
						if (Info && Info[0] == 160) {
							if (out_ward_base_model.HasActiveIllu(Info[1], Info[2])) {
								local_GlobalEventSystem.Fire(local_EventName.OPEN_ILLUSION_VIEW, Info[1], Info[2])
							} else {
								out_ward_base_model.Fire(OutWardBaseModel.ACTIVE_OUTWARD_FIGURE, Info[1], Info[2])
							}
						}
						this.DeleteCurrentItem(null, true)
						return
					}
					if (_goods_vo.type == 22 || _goods_vo.type == 25) {
						let Info = this.FuncInfo()
						if (Info && Info[0] == 160) {
							local_OpenFun.OpenFunHandler(121, Info[1], Info[2])
						}
						this.DeleteCurrentItem(null, true)
						return
					}
					if (_goods_vo.type == 68) {
						let Info = this.FuncInfo()
						if (Info && Info[0] == 182) {
							local_OpenFun.OpenFunHandler(122, 2, Info[1])
						}
						this.DeleteCurrentItem(null, true)
						return
					}

					if (_goods_vo.type == 75) {
						if (SceneManager.GetInstance().IsFieldScene()) {
							TreasureMapModel.GetInstance().Fire(TreasureMapModel.TM_USE_GOODS, _goods_vo, false)
						} else {
							local_Message.show("当前场景不能使用")
						}
						this.DeleteCurrentItem(null, true)
						return
					}

					if (_goods_vo.type == UnrealModel.goods_type) {
						if (this.unreal_wear_state) {
							UnrealModel.GetInstance().Fire(UnrealModel.REQUEST_CCMD_EVENT, 14901, _goods_vo.goods_id)
						} else {
							if (!ViewManager.GetInstance().GetViewOpenState("SecretTreasureMainView")) {
								OpenFun.OpenFunHandler(195)
							}
						}
						this.Close()
						return
					}

					if (_goods_vo.type == HolySealModel.GOODS_TYPE) { // 影装
						OpenFun.OpenFunHandler(84);
						this.Close();
						return
					}
					/*
					if (_goods_vo.type_id == 37070001) {
						if (GuildModel.GetInstance()._prestige_limit_mark) {
							this.DeleteCurrentItem(null, true)
							return
						}
					}
					*/
					if (_goods_vo.type_id == 37090001) {
						let ok_callback = () => {
							goods_model.Fire(local_GoodsModel.USE_BAG_GOODS, _goods_vo.goods_id, 1)
						}
						let level = RoleManager.GetInstance().GetMainRoleLevel()
						//let lv = level > 370 && "神创" + (level - 370) || level
						if (level < 219) {
							Alert.Show("是否使用人物直升丹？[推荐使用等级259级]", Alert_Type.Two, ok_callback)
						} else {
							ok_callback()
						}
						return
					}
					if (_goods_vo.type == 12) {
						let Info = this.FuncInfo()
						this.bottom_label.text = ""
						let fashion_model = FashionModel.GetInstance()
						let pos_id = _goods_vo.subtype
						if (fashion_model.IsActive(pos_id, _goods_vo.type_id)) {
							OpenFun.OpenFunHandler(107, FashionModel.GetInstance().type_to_tab_index[pos_id], _goods_vo.type_id)

						} else {
							fashion_model.Fire(FashionModel.SCMD_REQUEST, 41304, pos_id, _goods_vo.type_id)
							if (_goods_vo.goods_num > 1) {
								OpenFun.OpenFunHandler(107, FashionModel.GetInstance().type_to_tab_index[pos_id], _goods_vo.type_id)
							}
						}
						this.DeleteCurrentItem()
						return
					}
					if (count) {
						goods_model.Fire(local_GoodsModel.USE_BAG_GOODS, _goods_vo.goods_id, count)
					} else if ((!_goods_vo.goods_num || _goods_vo.goods_num <= 1)) {
						goods_model.Fire(local_GoodsModel.USE_BAG_GOODS, _goods_vo.goods_id, 1)
					} else {
						bag_model.Fire(local_BagModel.OPEN_VIEW, "BatchUseView", _goods_vo, 1, _goods_vo.goods_num)
					}
					this.DeleteCurrentItem()
				}
			}
		}

		this.CheckShowEffectAndAutoUse = () => {
			if(_now_count_down_type_id != _goods_vo.type_id){
				let time = this.IsAutoUse()
				this.CancelTimer()
				_use_last_time = time
				if (time > 0) {
					_now_count_down_type_id = _goods_vo.type_id
					_timer_id = GlobalTimerQuest.AddPeriodQuest(this.UseTimer, 1)//1000, time
					this.UseTimer()
				
				}
			}
		}

		this.ShowEffect = () => {
			if (_goods_vo) {
				let type_id = _goods_vo.type_id
				let cfg = local_Config.GetConfigVo(Config.ConfigHasDefaultValue.ClientItemUse.name, type_id, true)
				if (cfg) {
					return cfg.show_effect
				}
			}
		}

		this.IsAutoUse = () => {
			if (_goods_vo) {
				let goods_basic = goods_model.GetGoodsBasicByTypeId(_goods_vo.type_id)
				if (!goods_basic) {
					return false
				}
				if ((goods_basic && goods_basic.type == 38) && goods_basic.subtype == 7) {
					let num = _goods_vo.goods_num
					if (num && num > 0) {
						//
					} else {
						return false
					}
				}
				let bool = true

				let type_id = _goods_vo.type_id
				let cfg = local_Config.GetConfigVo(Config.ConfigHasDefaultValue.ClientItemUse.name, type_id, true)

				if (!cfg) {
					bool = false
				}

				if (_goods_vo && _goods_vo.type == UnrealModel.goods_type) {
					bool = false
				}
				if (bool) {
					return cfg.auto_use_sec
				}
			}
			return 0
		}

		this.IsCanCompose = () => {
			if (_goods_vo) {
				let cfg = local_Config.GetConfigVo(Config.ConfigHasDefaultValue.ClientItemUse.name, _goods_vo.type_id, true)
				if (cfg) {
					return cfg.compose
				}
			}
			return false
		}

		this.FuncInfo = () => {
			if (_goods_vo) {
				let cfg = local_Config.GetConfigVo(Config.ConfigHasDefaultValue.ClientItemUse.name, _goods_vo.type_id, true)
				if (cfg) {
					return cfg.FuncId
				}
			}
			return false
		}

		this.ShowEquipArrow = () => {
			if (this.task_model.IsCurrMainLineTaskTipType(TaskTipType.DressEquip)) {
				if (!this.task_model.IsCurrMainTaskHasFinish()) {
					let step_cfg = this.task_model.GetNowGuideCfg(false)
					local_GlobalEventSystem.Fire(local_EventName.SHOW_FINGER, this, this.enter_btn, this.layer_value, null, null, true, null, step_cfg)
				} else {
					local_GlobalEventSystem.Fire(local_EventName.HIDE_FINGER, this.enter_btn)
				}
			}
		}

		this.DestoryCallback = () => {
			if (this.anim_pos_id) {
				SYTweenLite.Stop(this.anim_pos_id)
				this.anim_pos_id = null
			}
			if (this.anim_alpha_id) {
				SYTweenLite.Stop(this.anim_alpha_id)
				this.anim_alpha_id = null
			}
			if (_goods_item) {
				_goods_item.DeleteMe()
				_goods_item = null
			}
			if (_timer_id) {
				this.CancelTimer()
			}
			_fly_vo_ = null
			if (this.enter_btn) {
				local_GlobalEventSystem.Fire(local_EventName.HIDE_FINGER, this.enter_btn)
			}
			_now_count_down_type_id = null
		}
	}

	public Open(vo?) {
		this.Local_Open(vo)
	}

	_gp_con: Laya.Box
	_Image1: Laya.Image
	item_group: Laya.Box
	name_label: Laya.Label
	_Image2: Laya.Image
	enter_btn: Laya.Box
	_Image11: Laya.Image
	enter_btn_text: Laya.Label
	bottom_label: Laya.Label
	close_btn: Laya.Image
	up_arrow: Laya.Image
	public GetComponents() {
		[
			this._gp_con,
			this._Image1,
			this.item_group,
			this.name_label,
			this._Image2,
			this.enter_btn,
			this._Image11,
			this.enter_btn_text,
			this.bottom_label,
			this.close_btn,
			this.up_arrow,
		]
			= this.GetChildrenByNames([
				"_gp_con",
				"_Image1",
				"item_group",
				"name_label",
				"_Image2",
				"enter_btn",
				"_Image11",
				"enter_btn_text",
				"bottom_label",
				"close_btn",
				"up_arrow",
			])
	}
}
window["ItemUseView"] = ItemUseView
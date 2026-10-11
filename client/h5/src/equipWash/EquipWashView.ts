import { BaseItem1 } from "../common/BaseItem1"
import { NotEnougnDiamond, Util } from "../util/Util"
import { table } from "../common/table"
import { EventName } from "../common/EventName"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { Alert, Alert_Type } from "../alert/Alert"
import { RoleManager } from "../commonModel/RoleManager"
import { Message } from "../sysInfo/SysInfoController"
import { TimeUtil } from "../util/TimeUtil"
import { GoodsModel } from "../commonModel/GoodsModel"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { ResManager } from "../common/ResManager"
import { EquipModel, EquipDefine, EquipEvent } from "../commonModel/EquipModel"
import { ShopModel, ShopEvent } from "../commonModel/ShopModel"
import { BaseAwardItem } from "../common/BaseAwardItem"
import { EquipmentItem } from "../common/EquipmentItem"
import { EquipWashItem } from "./EquipWashItem"
import { EquipWashPropItem } from "./EquipWashPropItem"
import { GameResPath } from "../util/GameResPath"
import { GiftPushIcon } from "../mainUI/GiftPushIcon"
import { EnumPushGiftType, PushGiftModel } from "../commonModel/PushGiftModel"
import { PlatformManager } from "../PlatformManager"
import { ColorUtil, Enum_ColorUtil_Light, Enum_ColorUtil_NEW } from "../util/ColorUtil"

export class EquipWashView extends BaseItem1 {
	InitEvent
	InitView
	LoadSuccess
	RefDivisionCost
	RefreshWashBtn
	SetExtraCost
	SetOpenLv
	SetSelectDefault
	ShowFuncOpenGuideArrow
	SortEquipList
	TouchWashGood
	UpdateCurItem
	UpdateDivision
	UpdateExtraStone
	UpdateFraction
	UpdatePropData
	UpdatePurpleLabel
	UpdateView
	UpdateWashStone
	WashBtnCallBack
	WashRequest

	_Group2
	_Image1

	cur_wash_item_
	equip_icon_list_
	getLockNum
	labelDisplay
	lock_prop_list
	prop_item_list_
	show_item_
	timerId
	wash_goods_item_
	wash_stone_item_

	effect_obj: Laya.Sprite3D
	effect_cache = false

	private giftItem: GiftPushIcon;

	public constructor(parent?) {
		super(parent)
		this.lock_prop_list = []
		this.base_file = "equip"
		this.layout_file = "EquipWashView"

		let model = EquipModel.GetInstance()
		let role_mgr = RoleManager.GetInstance()
		let local_Message = Message
		let local_EquipEvent = EquipEvent
		let goods_model = GoodsModel.GetInstance()
		let local_GoodsModel = GoodsModel
		let local_EventName = EventName
		let local_GlobalEventSystem = GlobalEventSystem
		let local_Alert = Alert
		let local_Alert_Type = Alert_Type
		//let funtion_open_model = FunctionOpenModel.GetInstance()
		//let local_FuncOpenId = FuncOpenId
		let cur_equip_info_ = null
		let free_time_ = 0
		let ratio_plus_ = 0
		let wash_jin_ = 0
		let equip_pos_list_ = EquipDefine.EQUIP_POS
		let equip_list_ = []
		this.equip_icon_list_ = []
		this.prop_item_list_ = []
		let select_goods_ = false
		this.wash_goods_item_ = null
		this.cur_wash_item_ = null
		let extra_cost_type_ = 0
		let extra_cost_have_num_ = 0
		let extra_cost_need_num_ = 0
		let wash_stone_have_num_ = 0
		let wash_stone_need_num_ = 0
		let up_info_ = []
		let is_up_ = null
		let is_up_socre_ = null
		let wash_stone_typeID_ = null
		let is_washing_ = 0
		let equip_wash_unlock_cfg_

		this.load_callback = () => {
			model.wash_lock = false
			this.LoadSuccess()
		}

		this.LoadSuccess = () => {
			if (PlatformManager.IsEyouEnPlatform()) {
				this._Image11.x = 224
				this._Image11.width = 270
				this._img_cost0.width = 215
				this._img_cost0.x = 252
				this._img_cost0.align = "center"
				this._img_cost.pos(19, 581)
				this._img_cost.width = 129
				this._img_cost.height = 75
				this._img_cost.wordWrap = true
			}

			ResManager.GetInstance().LoadFont(this, "equip_wash_font", this._bit_figth)


			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_018, GameResPath.GetIcon("equip", "xx_titleBg16"), true)
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_006, GameResPath.GetIconOtherPath("equip", "xl_002"))
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_040, GameResPath.GetIconOtherPath("equip", "xl_003"))
			this._Scroller1.hScrollBar.visible = false

			this.wash_stone_count.width = 100
			this.wash_stone_count.style.fontSize = 20
			this.wash_stone_count.style.color = "#ffffff"
			this.wash_stone_count.style.stroke = 1
			this.wash_stone_count.style.strokeColor = "#000000"

			this._lb_extra_num.width = 100
			this._lb_extra_num.style.fontSize = 20
			this._lb_extra_num.style.color = "#ffffff"
			this._lb_extra_num.style.stroke = 1
			this._lb_extra_num.style.strokeColor = "#000000"

			this.wash_purple_label.width = 400
			this.wash_purple_label.style.fontSize = 20
			this.wash_purple_label.style.color = "#663915"

			equip_wash_unlock_cfg_ = ResManager.GetInstance().GetGameConfigFromCache(this, "config_equip_wash_unlock_lv", false)

			let scale1= 3
			let pos_1= {x:-5.5,y:-7}

			this.AddUIEffect("effect_ui_forge_1", this._gp_effect, pos_1, scale1, null, null, null, (obj) => {
				this.effect_obj = obj
				if (!this.effect_cache) {
					this.effect_obj.active = false
				} else {
					this.effect_cache = false
				}
			}, null, null, null, null, false)



			let scale2= 2.95
			let pos_2= {x:0.45,y:-8.02}
			this.AddUIEffect("effect_ui_forge_2", this._gp_eff_040,pos_2,scale2,true)


			this.InitEvent()
			this.InitView()
			this.ShowGiftIcon();
		}

		this.InitEvent = () => {

			this.BindEvent(PushGiftModel.GetInstance(), PushGiftModel.UPDATE_ICON, (giftId: number) => {
				this.ShowGiftIcon();
			})

			Util.AddClickEvent(this.btn_wash, () => {
				if (is_washing_ > 0 && (is_washing_ > TimeUtil.getServerTimeMs())) {
					local_Message.show("点击过快")
					return
				}
				let role_lv = role_mgr.GetMainRoleVo().level
				if (!cur_equip_info_) {
					local_Message.show("未穿戴装备")
					return
				}
				let pos_info = model.GetWashUnlockLvInfo(cur_equip_info_.equip_type)
				if (!pos_info) {
					return
				}
				if (role_lv >= pos_info["unlock_lv"]) {

					this.WashBtnCallBack()
					return
				}
				local_Message.show("等级不足")
			}, this, true)

			Util.AddClickEvent(this.wash_purple_bg, () => {
				if (ratio_plus_ == 0) {
					ratio_plus_ = 1
					this.wash_purple_img.visible = true
					select_goods_ = true
					if (is_up_) {
						return
					}
					this.UpdateWashStone()
				} else if (ratio_plus_ == 1) {
					ratio_plus_ = 0
					this.wash_purple_img.visible = false
					select_goods_ = false
					if (is_up_) {
						return
					}
					this.UpdateWashStone()
				}
			}, this, true)

			this.BindEvent(model, local_EquipEvent.SELECT_WASH_EQUIP, (info?) => {
				if (info && (!cur_equip_info_ || info.equip_type != cur_equip_info_.equip_type)) {
					cur_equip_info_ = info
					this.UpdatePropData(info)
					this.UpdateCurItem()
					this.UpdatePurpleLabel()
					this.UpdateExtraStone(0)
					this.RefreshWashBtn()
					this.UpdateWashStone()
				}
			})

			this.BindEvent(goods_model, local_GoodsModel.UPDATE_GOODS_NUM, (goods_list?) => {
				if (this.use_delete_method) {
					return
				}
				for (let _tmpi in goods_list) {
					let v = goods_list[_tmpi]
					if (v.type_id == wash_stone_typeID_) {
						this.UpdateWashStone()
					}
					if (v.type_id == extra_cost_type_) {
						extra_cost_have_num_ = goods_model.GetTypeGoodsNum(extra_cost_type_)
						let color = (extra_cost_have_num_ >= extra_cost_need_num_ && ("'#b3ff48'") || ("'#ff4f50'"))
						this._lb_extra_num.innerHTML = Util.StrToHTML("<font color=" + color + " >" + extra_cost_have_num_ + "</font>/" + extra_cost_need_num_)
						this._lb_extra_num.width = 100
					}
					if ((up_info_ && up_info_["type_id"]) && v.type_id == up_info_["type_id"]) {
						this.UpdatePurpleLabel()
						this.UpdateWashStone()
					}
				}
			})

			let UpdateCallBack = (scmd?) => {
				if (scmd.res != 1) {
					is_washing_ = 0
					return
				}
				if (cur_equip_info_ && cur_equip_info_.goods_id == scmd.goods_id) {
					goods_model.GetDynamic(scmd.goods_id, (vo?) => {
						if (!this.is_loaded) {
							return
						}
						cur_equip_info_ = vo
						let item = this.equip_icon_list_[cur_equip_info_.equip_type]
						if (item) {
							item.SetData(cur_equip_info_)
						}
						if (scmd.attr_list) {
							is_washing_ = 0
							//this.ClearUIEffect(this._gp_wash_effect)
							//this.AddUIEffect("UI_1504", this._gp_wash_effect, null, null, false)
							model.Fire(local_EquipEvent.PLAY_PROP_EFFECT, scmd.attr_list)
						
							//洗炼成功特效播放
							if (this.effect_obj) {
								this.effect_obj.active = false
								this.effect_obj.active = true
							} else {
								this.effect_cache = true
							}

						} else {
							//this:ClearUIEffect(this._gp_order_effect)
							//this:AddUIEffect2("ui_shengduanchenggong_glow", this._gp_order_effect, null, null, false)
							model.wash_lock_dic[vo.equip_type] = []
						}
						this.UpdatePropData(vo)
						this.UpdateCurItem()
						this.RefreshWashBtn()
						this.UpdateWashStone()
					}
						, true)
				}
			}

			this.BindEvent(model, local_EquipEvent.UPDATE_WASH_EQUIP, UpdateCallBack)
			this.BindEvent(model, local_EquipEvent.OPEN_WASH_PROP, (scmd?) => {
				if (cur_equip_info_ && cur_equip_info_.goods_id == scmd.goods_id) {
					goods_model.GetDynamic(scmd.goods_id, (vo?) => {
						cur_equip_info_ = vo
						this.UpdatePropData(vo)
						this.UpdateCurItem()
						this.RefreshWashBtn()
						this.UpdateWashStone()
						let item = this.equip_icon_list_[cur_equip_info_.equip_type]
						if (item) {
							item.SetData(cur_equip_info_)
						}
						let attr_list = []
						table.insert(attr_list, vo.wash_attr[scmd.index])
						model.Fire(local_EquipEvent.PLAY_PROP_EFFECT, attr_list)
					}
						, false)
				}
			})

			this.BindEvent(model, local_EquipEvent.UPDATE_WASH_FREETIEM, (scmd?) => {
				model.wash_free_times = scmd.free_times
				this.RefreshWashBtn()
				this.UpdateWashStone()
			})

			this.BindVar(role_mgr.GetMainRoleVo(), "jin", () => {
				this.UpdatePurpleLabel()
			})

			Util.AddClickEvent(this.cur_wash_group, () => {
				if (!cur_equip_info_) {
					return
				}
				let goodsVo = goods_model.GetEquipById(cur_equip_info_.goods_id)
				UIToolTipMgr.GetInstance().AppendEquipTips(cur_equip_info_.type_id, null, null, goodsVo, null, [1])
			}, this, true)

			let lock_wash_prop = () => {
				if (is_up_) {
					return
				}
				this.UpdateWashStone()
				this.UpdatePurpleLabel()
				this.UpdateExtraStone(this.getLockNum())
			}

			this.BindEvent(model, local_EquipEvent.LOCK_WASH_PROP, lock_wash_prop)
			let ref_equip_list = () => {
				this.SortEquipList()
				let i = 0
				if (i < equip_list_.length) {
					do {
						let pos = equip_list_[i]
						let item = this.equip_icon_list_[pos]
						// if (item) {
						// 	item.transform.SetSiblingIndex(i) //this._gp_equip_item.setChildIndex(item, i)
						// }
						if (!equip_wash_unlock_cfg_) {
							return
						}
						if (item) {
							let open_cfg = equip_wash_unlock_cfg_[pos]
							item.SetOpenData(open_cfg)
						}
						i = i + 1
					} while ((i < equip_list_.length))
				}
				this.UpdateView()
				this.UpdateCurItem()
				this.RefreshWashBtn()
			}

			this.BindEvent(role_mgr.mainRoleInfo, local_EventName.CHANGE_LEVEL, ref_equip_list)
			this.BindEvent(goods_model, local_GoodsModel.CHANGE_EQUIPLIST, ref_equip_list)
			let guide_arrow_fun = (id?, step?) => {
				this.ShowFuncOpenGuideArrow(id, step)
			}
			//this:BindEvent(local_GlobalEventSystem, FunctionOpenEvent.FUNCTIONOPEN_START_TEXT_STEP_ARROW, guide_arrow_fun)
		}

		this.InitView = () => {
			this.SortEquipList()
			let i = 0
			if (i < equip_list_.length) {
				do {
					let pos = equip_list_[i]
					let item = new EquipWashItem(this.Content)
					item.Load()
					this.equip_icon_list_[pos] = item
					if (!equip_wash_unlock_cfg_) {
						return
					}
					let open_cfg = equip_wash_unlock_cfg_[pos]
					if (item) {
						item.ExcuteCallback(() => {
							item.SetEquipPos(pos)
							item.SetOpenData(open_cfg)
						}
						)
					}
					i = i + 1
				} while ((i < equip_list_.length))
			}
			if (!this.cur_wash_item_) {
				this.cur_wash_item_ = new EquipmentItem(this.cur_wash_group)
				this.cur_wash_item_.Load()
				this.cur_wash_item_.SetItemSize(123, 123)
				this.cur_wash_item_.SetShowTips(false)
			}
			if (!this.wash_goods_item_) {
				this.wash_goods_item_ = new BaseAwardItem(this.wash_goods_group)
				this.wash_goods_item_.Load()
				this.wash_goods_item_.ExcuteCallback(() => {
					this.wash_goods_item_.SetItemSize(87, 87)
					this.wash_goods_item_.SetShowTips(false)
				})
				let GoodsClickFunc = () => {
					if (!select_goods_) {
						this.TouchWashGood()
					} else {
						local_Alert.Show("当前已选择消耗勾玉必出橙色及以上品质属性,\n是否解除选择并放入其他洗炼道具？", local_Alert_Type.Two, () => {
							this.wash_purple_img.visible = false
							select_goods_ = false
							ratio_plus_ = 0
							this.UpdateWashStone()
							let onDelay = () => {
								this.TouchWashGood()
							}
							clearTimeout(this.timerId)
							this.timerId = setTimeout(onDelay, 0.2)
						}
							, null, null, null, null, true, null, null, true)
					}
				}
				Util.AddClickEvent(this._gp_extra, GoodsClickFunc, this, true)
			}
			if (!this.wash_stone_item_) {
				this.wash_stone_item_ = new BaseAwardItem(this.gp_washStone)
				this.wash_stone_item_.Load()
				this.wash_stone_item_.ExcuteCallback(() => {
					this.wash_stone_item_.SetItemSize(87, 87)
				})
			}

			i = 0
			let pos = [-1,72,146,221]
			do {
				let item: EquipWashPropItem = new EquipWashPropItem(this.wash_prop_group)
				item.Load()
				this.prop_item_list_[i] = item
				item.SetVisible(false)
				item.SetPosition(0, pos[i])
				i = i + 1
			} while ((i < 4))
			//
			//let i = 0
			//do {
			//this.wash_prop_group.swapChildrenAt(i, this.prop_item_list_.length - i - 1)
			//i=i+1
			//} while ((i < this.prop_item_list_.length / 2))

			this.UpdateView()
			this.SetSelectDefault()
		}

		this.RefreshWashBtn = () => {
			if (Util.IsNull(this.btn_wash) || !cur_equip_info_) {
				return
			}
			if (cur_equip_info_.wash_attr.length == 0) {
				this.btn_wash.visible = false
				return
			}
			this.btn_wash.visible = true
			if (is_up_) {
				this.lb_wash.text = "升段"
				//this.labelDisplay.GetComponent("Outline").effectColor = ColorUtil.TryParseHtmlString("#2f999f")
				//ResManager.GetInstance().SetImageSprite(this, this._Image1, "common_asset", "com_rect_btn11")
				return
			}
			free_time_ = model.wash_free_times || 0
			if (free_time_ > 0) {
				this.lb_wash.text = "免费洗炼" //+ free_time_ + "/3"
				this._img_red.visible = !is_up_socre_
			} else if (free_time_ == 0) {
				this.lb_wash.text = "洗炼"
				this._img_red.visible = false
			}
			//ResManager.GetInstance().SetImageSprite(this, this._Image1, "common_asset", "com_rect_btn12")
		}

		this.WashBtnCallBack = () => {
			if (!cur_equip_info_) {
				return
			}
			let recharge = () => {
				NotEnougnDiamond()
			}

			let role_vo = role_mgr.mainRoleInfo
			if (is_up_ && up_info_["type_id"]) {
				let UpRequest = (is_buy?) => {
					model.Fire(local_EquipEvent.REQUEST_PROTO, 15252, "cc", cur_equip_info_.equip_type, is_buy)
				}

				if (select_goods_) {
					let need_money = up_info_["need_money"]
					let have_mon = role_vo.jinLock
					if (have_mon >= need_money) {
						UpRequest(1)
					} else {
						let jin = role_vo.jin
						if (have_mon + jin >= need_money) {
							local_Alert.Show(Util.StrToHTML("绑玉不足，是否消耗<font color='#639c12'>" + (need_money - have_mon) + "勾玉</font>进行升段"), local_Alert_Type.Two, () => {
								UpRequest(1)
							})
							local_Alert.SetIsCharge(true)
						} else {
							recharge()
						}
					}
				} else {
					let have_num = goods_model.GetTypeGoodsNum(up_info_["type_id"])
					let need_num = up_info_["cost_cfg"] && up_info_["cost_cfg"][2]
					if (have_num >= Number(need_num)) {
						UpRequest(0)
					} else {
						local_Message.show("材料不足")
					}
				}
				return
			}
			let wash_attr = cur_equip_info_.wash_attr
			if (wash_attr.length == 0) {
				local_Message.show("洗炼槽未解锁")
				return
			}
			let is_check = false
			let isWashRating = () => {
				let equip_info = cur_equip_info_
				if (!equip_info) {
					return
				}
				let next_pos = equip_info.equip_type + "@" + (equip_info.division + 1)
				let equip_wash_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_equip_wash", false)
				let next_wash = model.GetWashInfo(next_pos, equip_wash_cfg)
				if (!next_wash) {
					return false
				}
				let pos = equip_info.equip_type + "@" + equip_info.division
				let wash_list = model.GetWashInfo(pos, equip_wash_cfg)
				if (!wash_list) {
					return false
				}
				let equip_attr_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_equip_attr", false)
				let stage = model.GetStageByTypeId(equip_info.type_id, equip_attr_cfg)
				if (((wash_list.need_rating || wash_list.need_stage) && equip_info.wash_rating >= wash_list.need_rating) && stage < wash_list.need_stage) {
					return true
				}
				return false
			}


			let wash_ok = () => {
				let ok_callback = () => {
					if (free_time_ && free_time_ > 0) {
						this.WashRequest()
						return
					}
					if (wash_stone_need_num_ > wash_stone_have_num_) {
						ShopModel.GetInstance().Fire(ShopEvent.SHOP_OPEN_VIEW, "QuickBuyView", { type_id: wash_stone_typeID_ })
						return
					}
					if (select_goods_ && role_vo.jin + role_vo.jinLock < wash_jin_) {
						recharge()
						return
					}
					if (extra_cost_type_ != 0) {
						if (extra_cost_have_num_ < extra_cost_need_num_) {
							let goods_name = goods_model.GetGoodsBasicByTypeId(extra_cost_type_).goods_name
							local_Message.show(goods_name + "不足")
							return
						}
					}
					this.WashRequest()
				}

				if (!model.equip_wash_hint) {
					for (let _tmpi in wash_attr) {
						let attr = wash_attr[_tmpi]
						if (attr.color >= 4) {
							let cur_pos = model.wash_lock_dic[cur_equip_info_.equip_type]
							let lock_num = this.getLockNum()
							if ((!lock_num || lock_num == 0) || (cur_pos && !cur_pos[attr.index - 1])) {
								local_Alert.Show("有橙色或橙色以上的属性将被洗炼\n是否继续?", local_Alert_Type.AlertTypeCheckBox, () => {
									model.equip_wash_hint = is_check
									ok_callback()
								}
									, null, "确定", "取消", null, false, () => {
										is_check = !is_check
									}
									, "本次登录不再提示", true)
								return
							}
						}
					}
				}
				ok_callback()
			}

			let washRating = () => {
				if (isWashRating()) {
					local_Alert.Show("当前洗炼评分已达到升段所需，\n但装备阶数尚未达到升段要求。\n是否继续洗炼？", local_Alert_Type.Two, () => {
						wash_ok()
					}
					)
					return
				}
				wash_ok()
			}
			washRating()
		}

		this.WashRequest = () => {
			if (!cur_equip_info_) {
				return
			}
			if (model.wash_lock) {
				return
			}
			is_washing_ = TimeUtil.getServerTimeMs() + 700
			let lock_num = this.getLockNum()
			model.Fire(local_EquipEvent.REQUEST_PROTO, 15213, "", cur_equip_info_.equip_type, lock_num, ratio_plus_)
			model.wash_lock = true
		}

		this.TouchWashGood = () => {
			let select_callBack = (index?, type_id?, need_num?, have_num?) => {
				if (this.use_delete_method) {
					return
				}
				extra_cost_type_ = Number(type_id)
				ratio_plus_ = Number(index) + 2
				if (this.wash_goods_item_) {
					this.wash_goods_item_.SetData(type_id, null, null, null, null)
				}
				if (type_id != 0) {
					extra_cost_have_num_ = have_num
					extra_cost_need_num_ = Number(need_num)
					this.SetExtraCost()
				} else {
					this._img_add.visible = true
					this._lb_extra_num.visible = false
					this.UpdatePurpleLabel()
					extra_cost_have_num_ = 0
					extra_cost_need_num_ = 0
				}
			}

			if (cur_equip_info_) {
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "EquipWashGoodsView", cur_equip_info_, this.getLockNum(), extra_cost_type_, select_callBack)
			}
		}

		this.UpdateWashStone = () => {
			if (!cur_equip_info_) {
				return
			}
			let cfg = null
			let pos = null
			let equip_wash_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_equip_wash", false)
			if (cur_equip_info_) {
				pos = cur_equip_info_.equip_type + "@" + cur_equip_info_.division
				cfg = model.GetWashInfo(pos, equip_wash_cfg)
			}
			if (!cfg) {
				return
			}
			let _cost = null
			if (is_up_) {
				let up_cost = cfg.up_cost
				if (up_cost != "[]") {
					if (typeof (up_cost) == "string") {
						up_cost = JSON.parse(up_cost)[0]
						//model:GetWashInfo(pos, equip_wash_cfg).up_cost = up_cost
					}
					_cost = up_cost
				} else {
					_cost = null
				}
			} else {
				let wash_cost = cfg && cfg["wash_cost"]
				if (!wash_cost) {
					return
				}
				wash_cost = JSON.parse(wash_cost)
				for (let _tmpi in wash_cost) {
					let cost = wash_cost[_tmpi]
					if (Util.TableSize(model.wash_lock_dic[cur_equip_info_.equip_type]) == Number(cost[0])) {
						_cost = cost[1][0]
						break
					}
				}
			}
			if (_cost) {
				wash_stone_typeID_ = Number(_cost[1])
				let need_num = Number(!select_goods_ && cur_equip_info_.wash_attr.length > 0 && _cost[2] || 0)
				let good_num = (select_goods_ && (0) || (goods_model.GetTypeGoodsNum(wash_stone_typeID_)))
				wash_stone_have_num_ = good_num
				wash_stone_need_num_ = need_num
				if (this.wash_stone_item_) {
					this.wash_stone_item_.SetData(wash_stone_typeID_)
				}
				let color = (good_num >= need_num && ("'#b3ff48'") || ("'#ff4f50'"))
				this.wash_stone_count.innerHTML = Util.StrToHTML("<font color=" + color + ">" + good_num + "</font>/" + need_num)
				this.wash_stone_count.width = 100

				//this.wash_stone_group.setChildIndex(this.wash_stone_count, 3)
				//this.wash_stone_count.SetAsLastSibling()
				this.wash_stone_group.visible = true
				if (is_up_ && good_num >= need_num) {
					this._img_red.visible = true
				} else if (is_up_) {
					this._img_red.visible = false
				}
			} else {
				this.wash_stone_group.visible = false
			}
		}

		this.UpdatePurpleLabel = () => {
			let cur_cfg = null
			let pos = null
			let equip_wash_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_equip_wash", false)
			let goods_price_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_goods_price", false)
			if (cur_equip_info_) {
				pos = cur_equip_info_.equip_type + "@" + cur_equip_info_.division
				cur_cfg = model.GetWashInfo(pos, equip_wash_cfg)
			}
			if (!cur_cfg) {
				return
			}
			up_info_ = []
			let need_money = 0
			if (is_up_) {
				this._gp_extra.visible = false
				let up_cost = cur_cfg.up_cost
				if (up_cost != "[]") {
					if (typeof (up_cost) == "string") {
						up_cost = JSON.parse(up_cost)[0]
						//model:GetWashInfo(pos, equip_wash_cfg).up_cost = up_cost
					}
					let type_id = goods_model.GetMappingTypeId(up_cost[0], up_cost[1])[0]
					let basic = goods_model.GetGoodsBasicByTypeId(type_id)
					if (!basic) {
						this.wash_purple_label.visible = false
						return
					}
					type_id = Number(type_id)
					let have_num = goods_model.GetTypeGoodsNum(type_id)

					if (have_num >= Number(up_cost[2])) {
						this._gp_cost_desc.visible = false
						this.gp_purple.visible = false
					} else {
						let goods_info = goods_price_cfg[type_id]
						if (!goods_info) {
							return
						}
						let price = goods_info.price
						need_money = (Number(up_cost[2]) - have_num) * price
						this.wash_purple_label.innerHTML = "自动购买" + GoodsModel.GetGoodsNameWithColorLight(basic.type_id)
						this.wash_purple_label.width = 400
					}

					up_info_["type_id"] = type_id
					up_info_["cost_cfg"] = up_cost
					up_info_["need_money"] = need_money
				} else {
					this._gp_cost_desc.visible = false
					this.gp_purple.visible = false
					return
				}
			} else if (cur_equip_info_ && extra_cost_type_ == 0) {
				this._gp_extra.visible = true
				let extra_cost = JSON.parse(cur_cfg["extra_cost"])
				for (let _tmpi in extra_cost) {
					let cost = extra_cost[_tmpi]
					if (this.getLockNum() == Number(cost[0])) {
						wash_jin_ = Number(cost[1][0][2])
						need_money = wash_jin_
						if (PlatformManager.IsEyouEnPlatform()) {
							this.wash_purple_label.innerHTML = Util.StrToHTML("Guaranteed to get one&nbsp;<font color='#ff9015'>Orange</font>&nbsp;and above stats.")
							this.wash_purple_label.width = 500
						} else {
							this.wash_purple_label.innerHTML = Util.StrToHTML("必出一条<font color='#ff9015'>橙色</font>及以上属性")
							this.wash_purple_label.width = 400
						}
						this._gp_cost_desc.refresh()
						break
					}
				}
			}
			if (need_money > 0) {
				this._gp_cost_desc.visible = true
				this.gp_purple.visible = true
			}
			if (need_money && need_money > 0) {
				let role_vo = role_mgr.GetMainRoleVo()
				let have_mon = (is_up_ && (role_vo.jinLock) || (role_vo.jin))
				this.wash_purple0_la.color = (need_money > have_mon) ? ColorUtil.GetReplaceChar(Enum_ColorUtil_Light.RED) :ColorUtil.GetReplaceChar(Enum_ColorUtil_Light.GREEN)
				this.wash_purple0_la.text = String(need_money)
				this.gp_purple.visible = true
				this.lb_tips.visible = true
				this.img_jin.visible = true
				ResManager.GetInstance().SetImageSprite(this, this.img_jin, "common_asset", is_up_ && "com_bind_diamond" || "com_diamond")
				this.wash_purple0_la.visible = true
				this.wash_purple_label.x = 120
			} else if (!is_up_ && extra_cost_type_ != 0) {
				this.SetExtraCost()
			}
			//LayoutRebuilder(this._Group2)
		}

		this.SetExtraCost = () => {
			if (!extra_cost_type_) {
				return
			}
			let have_num = extra_cost_have_num_
			let need_num = extra_cost_need_num_
			let index = extra_cost_type_ == 38040007 ? 0 : 1
			ratio_plus_ = extra_cost_type_ == 38040007 ? 2 : 3
			let color = have_num >= need_num ? "'#b3ff48'" : "'#ff4f50'"
			this._lb_extra_num.visible = true
			this._lb_extra_num.innerHTML = Util.StrToHTML("<font color=" + color + ">" + have_num + "</font>/" + need_num)
			this._lb_extra_num.width = 100
			this.gp_purple.visible = false
			this.lb_tips.visible = false
			this.wash_purple_label.x = -55
			let extra_type = ["红色", "橙色"]
			color = index == 0 ? "'#ff4f50'" : "'#ff9015'"
			this.wash_purple_label.innerHTML = Util.StrToHTML("必出一条<font color=" + color + ">" + extra_type[index] + "</font>或<font color=" + color + ">" + extra_type[index] + "</font>以上属性")
			this.wash_purple_label.width = 400
			this._gp_cost_desc.refresh()
			this.img_jin.visible = false
			this.wash_purple0_la.visible = false
			this._img_add.visible = false
		}

		this.UpdateView = () => {
			let equipInfos = model.GetWearEquipDynamics()
			for (let key in equipInfos) {
				let info = equipInfos[key]
				if (!info) {
					return
				}
				let item = this.equip_icon_list_[info.equip_type]
				if (item) {
					item.SetData(info)
				}
				if (cur_equip_info_ && info.equip_type == cur_equip_info_.equip_type) {
					cur_equip_info_ = info
				}
			}
		}

		this.UpdateCurItem = () => {
			if (this.cur_wash_item_ && cur_equip_info_) {
				this.cur_wash_item_.SetData(cur_equip_info_.type_id)
				this.UpdateFraction(cur_equip_info_)
			}
			this.UpdateDivision()
		}

		this.SetOpenLv = () => {
			let i = 0
			if (i < equip_pos_list_.length) {
				do {
					let equip_type = equip_pos_list_[i]
					let open_cfg = equip_wash_unlock_cfg_[equip_type]
					let item = this.equip_icon_list_[equip_type]
					if (item) {
						item.SetOpenData(open_cfg)
					}
					i = i + 1
				} while ((i < equip_pos_list_.length))
			}
		}

		this.SortEquipList = () => {
			let list = model.GetWearEquipDynamics()
			let role_lv = role_mgr.GetMainRoleVo().level
			let un_lock_list = []
			let lock_wear_list = []
			let lock_unwear_list = []
			let unlock_lv_list = []
			for (let i in equip_wash_unlock_cfg_) {
				let v = equip_wash_unlock_cfg_[i]
				table.insert(unlock_lv_list, v)
			}
			if (unlock_lv_list.length > 0) {
				table.sort(unlock_lv_list, (a?, b?) => {
					return a.unlock_lv < b.unlock_lv
				})
			}
			let i = 0
			if (i < unlock_lv_list.length) {
				do {
					let open_cfg = unlock_lv_list[i]
					let equip_type = open_cfg.pos
					if (open_cfg && role_lv >= open_cfg.unlock_lv) {
						let bool = true
						for (let j in list) {
							if (list[j].equip_type == equip_type) {
								table.insert(lock_wear_list, equip_type)
								bool = false
								break
							}
						}
						if (bool) {
							table.insert(lock_unwear_list, equip_type)
						}
					} else {
						table.insert(un_lock_list, equip_type)
					}
					i = i + 1
				} while ((i < unlock_lv_list.length))
			}
			for (let k in lock_unwear_list) {
				let v = lock_unwear_list[k]
				table.insert(lock_wear_list, v)
			}
			for (let k in un_lock_list) {
				let v = un_lock_list[k]
				table.insert(lock_wear_list, v)
			}
			equip_list_ = lock_wear_list // table.merge(lock_wear_list, lock_unwear_list, un_lock_list)
		}

		this.SetSelectDefault = () => {
			let role_lv = role_mgr.GetMainRoleVo().level
			let list = model.GetWearEquipDynamics()
			if (list.length < 1) {
				return
			}
			if (model.wash_select_pos != 0 && role_lv >= model.GetWashUnlockLvInfo(model.wash_select_pos)["unlock_lv"]) {
				let info = list[model.wash_select_pos - 1]
				let item = this.equip_icon_list_[info.equip_type]
				if (item) {
					item.ExcuteCallback(() => {
						model.Fire(local_EquipEvent.SELECT_WASH_EQUIP, info)
					}
					)
				}
				return
			} else {
				let info = null
				if (!info) {
					info = list[0]
				}
				let item = this.equip_icon_list_[info.equip_type]
				if (item) {
					item.ExcuteCallback(() => {
						model.Fire(local_EquipEvent.SELECT_WASH_EQUIP, info)
					}
					)
				}
			}
		}

		this.UpdateFraction = (info?) => {
			if (!info) {
				return
			}
			this._bit_figth.text = info.wash_rating + "(" + info.division + "段)"
		}

		this.getLockNum = () => {
			if (!cur_equip_info_) {
				return
			}
			let dic = model.wash_lock_dic && model.wash_lock_dic[cur_equip_info_.equip_type]
			return Util.TableSize(dic)
		}

		this.UpdatePropData = (info?) => {
			if (!info) {
				return
			}
			for (let i = 0; i < this.prop_item_list_.length; i++) {
				if (this.prop_item_list_[i]) {
					this.prop_item_list_[i].SetVisible(true)
					this.prop_item_list_[i].SetData(cur_equip_info_, i)
				}
			}
		}

		this.UpdateExtraStone = (lock_num?) => {
			if (extra_cost_type_ == 0) {
				return
			}
			let wash_list = null
			let equip_wash_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_equip_wash", false)
			if (cur_equip_info_) {
				let pos = cur_equip_info_.equip_type + "@" + cur_equip_info_.division
				wash_list = model.GetWashInfo(pos, equip_wash_cfg)
			}
			if (!wash_list) {
				return
			}
			let goods_info = goods_model.GetGoodsBasicByTypeId(extra_cost_type_)
			if (!goods_info) {
				return
			}
			let cost = null
			if (goods_info.color == 4) {
				cost = JSON.parse(wash_list["extra_orange_cost"])
			} else if (goods_info.color == 5) {
				cost = JSON.parse(wash_list["extra_red_cost"])
			} else {
				return
			}
			if (!cost) {
				return
			}
			extra_cost_need_num_ = Number(cost[lock_num][1][0][2])
			let color = (extra_cost_have_num_ >= extra_cost_need_num_ && ("'#b3ff48'") || ("'#ff4f50'"))
			this._lb_extra_num.innerHTML = Util.StrToHTML("<font color=" + color + ">" + extra_cost_have_num_ + "</font>/" + extra_cost_need_num_)
			this._lb_extra_num.width = 100
		}

		this.UpdateDivision = () => {
			if (cur_equip_info_) {
				let equip_wash_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_equip_wash", false)
				this.RefDivisionCost()
				let next_pos = cur_equip_info_.equip_type + "@" + (cur_equip_info_.division + 1)
				let next_wash_list = model.GetWashInfo(next_pos, equip_wash_cfg)
				is_up_socre_ = false
				if (!next_wash_list) {
					this._lb_oredr_full.visible = true
					this._gp_up_cond.visible = false
					return
				}
				this._lb_oredr_full.visible = false
				this._gp_up_cond.visible = true
				let pos = cur_equip_info_.equip_type + "@" + cur_equip_info_.division
				let wash_list = model.GetWashInfo(pos, equip_wash_cfg)
				if (!wash_list) {
					return
				}
				let color = null
				if (wash_list.need_rating) {
					color = wash_list.need_rating > cur_equip_info_.wash_rating?Enum_ColorUtil_NEW.LIGHT_RED:Enum_ColorUtil_NEW.LIGHT_GREEN
					is_up_socre_ = wash_list.need_rating <= cur_equip_info_.wash_rating
					this._lb_cond_socre.color = color
					this._lb_cond_socre.text = wash_list.need_rating
				}
				if (wash_list.need_stage) {
					let equip_attr_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_equip_attr", false)
					let stage = model.GetStageByTypeId(cur_equip_info_.type_id, equip_attr_cfg)
					color = stage < wash_list.need_stage?Enum_ColorUtil_NEW.LIGHT_RED:Enum_ColorUtil_NEW.LIGHT_GREEN
					/*
					if (PlatformManager.GetInstance().IsEyouEnPlatform()) {
						this._lb_cond_order.textFlow = Util.StrToHTML("Gear <font color=" + color + ">Grade" + wash_list.need_stage + " </font>")
					} else if (PlatformManager.GetInstance().IsEyouThPlatform()) {
						this._lb_cond_order.textFlow = Util.StrToHTML("อุปกรณ์<font color=" + color + ">ขั้น" + wash_list.need_stage + "</font>")
					} else {
						this._lb_cond_order.textFlow = Util.StrToHTML("装备<font color=" + color + ">" + wash_list.need_stage + "阶</font>")
					}*/
					this._lb_cond_order.color = color
					this._lb_cond_order.text = wash_list.need_stage + "阶"
				}
			}
			//LayoutRebuilder(this._gp_up_cond)
		}

		this.RefDivisionCost = () => {
			is_up_ = false
			if (!cur_equip_info_) {
				return
			}
			let equip_attr_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_equip_attr", false)
			let equip_wash_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_equip_wash", false)
			if (model.IsWashDivision(cur_equip_info_, equip_attr_cfg, equip_wash_cfg)) {
				model.CheckWashDivisionRedAll()
				ratio_plus_ = 0
				this.wash_purple_img.visible = false
				select_goods_ = false
				this._gp_extra.visible = false
				is_up_ = true
				this._img_cost.text = "升段消耗："
				this.UpdatePurpleLabel()
			} else if (!this._gp_extra.visible) {
				this._img_cost.text = "洗炼消耗："
				ratio_plus_ = 0
				this.wash_purple_img.visible = false
				select_goods_ = false
				this._gp_extra.visible = true
				this.UpdatePurpleLabel()
			}
		}

		this.ShowFuncOpenGuideArrow = (id?, step?) => {
		}
	}

	private ShowGiftIcon() {
		let bool: boolean = Boolean(PushGiftModel.GetInstance().GetGiftList(EnumPushGiftType.eQiangZhe));
		if (bool) {
			if (!this.giftItem) {
				this.giftItem = new GiftPushIcon(this.giftIcon);
				this.giftItem.Load();
			}
			this.giftItem.ExcuteCallback(() => {
				this.giftItem.SetDate(PushGiftModel.ICON_TYPE, EnumPushGiftType.eQiangZhe, 0);
			});


		}
		this.giftIcon.visible = bool;
	}

	public DeleteMe() {

		if (this.effect_obj) {
			this.effect_obj.destroy()
		}
		this.effect_cache = false

		this.ClearUIEffect(this._gp_effect)
		this.ClearUIEffect(this._gp_eff_040)

		if (this.equip_icon_list_.length > 0) {
			for (let key in this.equip_icon_list_) {
				this.equip_icon_list_[key].DeleteMe()
			}
			this.equip_icon_list_ = []
		}
		if (this.prop_item_list_.length > 0) {
			for (let key in this.prop_item_list_) {
				this.prop_item_list_[key].DeleteMe()
			}
			this.prop_item_list_ = []
		}
		if (this.show_item_) {
			this.show_item_.DeleteMe()
			this.show_item_ = null
		}
		if (this.wash_stone_item_) {
			this.wash_stone_item_.DeleteMe()
			this.wash_stone_item_ = null
		}
		if (this.cur_wash_item_) {
			this.cur_wash_item_.DeleteMe()
			this.cur_wash_item_ = null
		}
		if (this.wash_goods_item_) {
			this.wash_goods_item_.DeleteMe()
			this.wash_goods_item_ = null
		}
		clearTimeout(this.timerId)
		this.timerId = null
		EquipModel.GetInstance().CookieLockList()
		if (this.giftItem) {
			this.giftItem.DeleteMe();
			this.giftItem = null;
		}
		super.DeleteMe()
	}

	public ReOpen_callback() {
		//this.AddUIEffect("ui_1503", "UI", this._gp_effect, null, 1.01, true)
		//let curr_sorting_order = this.AddCurrLayerSortingOrder("UI")
		//this.CoverEffect(this.wash_prop_group, "UI", curr_sorting_order)
	}

_img_006:Laya.Image
_img_018:Laya.Image
_img_040:Laya.Image
_img_030:Laya.Image
_Image3:Laya.Image
_Image11:Laya.Image
_Image2:Laya.Image
_gp_eff_040:Laya.Box
_gp_up_cond:Laya.HBox
lb_washTitle:Laya.Label
_lb_cond_socre:Laya.Label
lb_equip:Laya.Label
_lb_cond_order:Laya.Label
_Label1:Laya.Label
cur_wash_group:Laya.Box
_gp_effect:Laya.Box
wash_prop_group:Laya.Box
_img_cost:Laya.Label
_img_cost0:Laya.Label
wash_stone_group:Laya.Box
gp_washStone:Laya.Box
wash_stone_count:Laya.HTMLDivElement
_gp_extra:Laya.Box
_img_addBG:Laya.Image
wash_goods_group:Laya.Box
_img_add:Laya.Image
_lb_extra_num:Laya.HTMLDivElement
gp_purple:Laya.Box
wash_purple_bg:Laya.Image
wash_purple_img:Laya.Image
_gp_cost_desc:Laya.HBox
lb_tips:Laya.Label
wash_purple0_la:Laya.Label
img_jin:Laya.Image
wash_purple_label:Laya.HTMLDivElement
gp_fight:Laya.Box
_img_bg:Laya.Image
img_tx1:Laya.Image
_bit_figth:Laya.Label
_gp_wash_effect:Laya.Box
_Scroller1:Laya.Panel
Content:Laya.HBox
_gp_order_effect:Laya.Box
_lb_oredr_full:Laya.Label
btn_wash:Laya.Image
lb_wash:Laya.Label
_img_red:Laya.Image
giftIcon:Laya.Box
public GetComponents() {
[
this._img_006,
this._img_018,
this._img_040,
this._img_030,
this._Image3,
this._Image11,
this._Image2,
this._gp_eff_040,
this._gp_up_cond,
this.lb_washTitle,
this._lb_cond_socre,
this.lb_equip,
this._lb_cond_order,
this._Label1,
this.cur_wash_group,
this._gp_effect,
this.wash_prop_group,
this._img_cost,
this._img_cost0,
this.wash_stone_group,
this.gp_washStone,
this.wash_stone_count,
this._gp_extra,
this._img_addBG,
this.wash_goods_group,
this._img_add,
this._lb_extra_num,
this.gp_purple,
this.wash_purple_bg,
this.wash_purple_img,
this._gp_cost_desc,
this.lb_tips,
this.wash_purple0_la,
this.img_jin,
this.wash_purple_label,
this.gp_fight,
this._img_bg,
this.img_tx1,
this._bit_figth,
this._gp_wash_effect,
this._Scroller1,
this.Content,
this._gp_order_effect,
this._lb_oredr_full,
this.btn_wash,
this.lb_wash,
this._img_red,
this.giftIcon,
]
 = this.GetChildrenByNames([

"_img_006",
"_img_018",
"_img_040",
"_img_030",
"_Image3",
"_Image11",
"_Image2",
"_gp_eff_040",
"_gp_up_cond",
"lb_washTitle",
"_lb_cond_socre",
"lb_equip",
"_lb_cond_order",
"_Label1",
"cur_wash_group",
"_gp_effect",
"wash_prop_group",
"_img_cost",
"_img_cost0",
"wash_stone_group",
"gp_washStone",
"wash_stone_count",
"_gp_extra",
"_img_addBG",
"wash_goods_group",
"_img_add",
"_lb_extra_num",
"gp_purple",
"wash_purple_bg",
"wash_purple_img",
"_gp_cost_desc",
"lb_tips",
"wash_purple0_la",
"img_jin",
"wash_purple_label",
"gp_fight",
"_img_bg",
"img_tx1",
"_bit_figth",
"_gp_wash_effect",
"_Scroller1",
"Content",
"_gp_order_effect",
"_lb_oredr_full",
"btn_wash",
"lb_wash",
"_img_red",
"giftIcon",
])
}
}
 window["EquipWashView"]= EquipWashView
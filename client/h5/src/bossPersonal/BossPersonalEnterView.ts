import { BaseItem1 } from "../common/BaseItem1"
import { Config } from "../common/Config"
import { table } from "../common/table"
import { Util, SetAnchoredPositionX, HtmlColorTxt } from "../util/Util"
import { ErlangParser } from "../util/ErlangParser"
import { TimeUtil } from "../util/TimeUtil"
import { ColorUtil } from "../util/ColorUtil"
import { OpenFun } from "../common/OpenFun"
import { EventName } from "../common/EventName"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ResManager } from "../common/ResManager"
import { BossModel } from "../commonModel/BossModel"
import { BaseDungeonModel } from "../commonModel/BaseDungeonModel"
import { RoleManager } from "../commonModel/RoleManager"
import { VipModel } from "../commonModel/VipModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { DUN_TYPE } from "../commonModel/BaseDungeonModel"
import { SYTweenLite } from "../util/SYTweenLite"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { Alert, Alert_Type } from "../alert/Alert"
import { LoopScrowViewMgr, LoopScrCon } from "../common/LoopScrowViewMgr"
import { Message } from "../sysInfo/SysInfoController"
import { UI_MODEL_TYPE } from "../common/UIModelClass3D"
import { EquipmentItem } from "../common/EquipmentItem"
import { BossPersonalItem } from "./BossPersonalItem"
import { TopVipModel } from "../commonModel/TopVipModel"

import "./BossVipAddView"
import { ShopModel } from "../commonModel/ShopModel"
import { SceneManager } from "../scene/SceneManager"
import { PlatformManager } from "../PlatformManager"

export class BossPersonalEnterView extends BaseItem1 {
	ArrowUpdateView
	CustomMehod
	DeleteMe
	Emp_btn_dun
	GetCostNum
	HideArrow
	InitDunRoomList
	InitEvent
	InitView
	LoadSucceed
	ReOpen_callback
	RefreshDunBtn
	SetDefaultSelect
	ShowBossModel
	ShowRewardItem
	ShowSelectDunRoomInfo
	Text
	UpdateScrollerView

	_bossinfo
	_gp_drop

	_list_dg_room
	clickTime
	color_shape
	icon
	loopr_mgr
	mask
	tween_id1
	tween_id2
	first_enter = false

	cfg_dungeon
	cfg_ui_content
	cfg_num_by_vip
	cfg_num_by_vip_info
	cfg_dungeon_client

	public constructor(parent?) {
		super(parent)
		this.base_file = "bossPersonal"
		this.layout_file = "BossPersonalEnterView"

		let dunmodel = BaseDungeonModel.GetInstance()
		let local_BaseDungeonModel = BaseDungeonModel
		let local_DUN_TYPE = DUN_TYPE
		let goods_model = GoodsModel.GetInstance()
		let role_mgr = RoleManager.GetInstance()
		let vip_model = VipModel.GetInstance()
		let local_OpenFun = OpenFun
		let local_Alert = Alert
		let local_Alert_Type = Alert_Type
		let local_GlobalEventSystem = GlobalEventSystem
		let OPEN_VIEW = EventName.OPEN_VIEW

		let reward_item_list_ = null
		let dun_data_ = null
		let select_index_ = 0
		let select_boss_id_ = null
		let cost_ = null
		let ticket_type_ = null
		let clickTime_ = null
		let remain_time_ = 0
		let btnGray = false

		this.load_callback = () => {

			this.cfg_dungeon = ResManager.GetInstance().GetGameConfigFromCache(this, "config_dungeon", false)
			this.cfg_ui_content = ResManager.GetInstance().GetGameConfigFromCache(this, "config_dungeon_ui_content", false)
			this.cfg_num_by_vip = ResManager.GetInstance().GetGameConfigFromCache(this, "config_num_by_vip", false)
			this.cfg_num_by_vip_info = ResManager.GetInstance().GetGameConfigFromCache(this, "config_num_by_vip_info", false)
			this.cfg_dungeon_client = ResManager.GetInstance().GetGameConfigFromCache(this, "ConfigDungeonClient", true)
			this.LoadSucceed()
			// if (PlatformMgr.GetInstance().IsEyouThPlatform()) {
			// 	this.Text.text = "บันทึก\nดรอป"
			// 	this.Text.pivot = Vector2(0.5, 1)
			// 	SetSizeDeltaY(this.Text, 60)
			// }
			this.SetDefaultSelect()
			this.InitView()
			this.InitEvent()
			this.InitDunRoomList()
			// if (PlatformMgr.GetInstance().IsEyouIdnPlatform()) {
			// 	this._lb_tiket_name.size = 16
			// 	this._lb_have.size = 16
			// 	this._lb_cost.size = 16
			// 	LayoutRebuilder(this._gp_ticket)
			// 	SetAnchoredPositionY(this._gp_ticket, -851.8)
			// 	this._Label1.size = 18
			// 	SetAnchoredPosition(this._Label1, 520, -20)
			// }
		}

		this.ReOpen_callback = () => {
			//let icon = this._bossinfo && this._bossinfo.icon
			this.ShowBossModel(this.icon)
		}

		this.LoadSucceed = () => {
			this._reward_con.vScrollBar.visible = false
			this._sl_dg_room.scrollBar.visible = false

			this._lb_remain_time.style.fontSize = 20
			this._lb_remain_time.style.color = "#ffffff"
			this._lb_remain_time.style.wordWrap = false

			this._lb_tiket_name.style.fontSize = 20
			this._lb_tiket_name.style.color = "#ffffff"
			this._lb_tiket_name.style.wordWrap = false
			dun_data_ = dunmodel.GetDungeonInfo(local_DUN_TYPE.Vip_Rerson_Boss)
			dunmodel.vip_person_view_status = true
			dunmodel.RefreshVipPersonRed()
			dunmodel.Fire(local_BaseDungeonModel.SCMD_REQUEST, 61020, local_DUN_TYPE.Vip_Rerson_Boss)


			this.ShowShop()
			this.CheckShopRed()
		}

		this.InitEvent = () => {

			Util.AddClickEvent(this._img_shop, () => {
				GlobalEventSystem.Fire(EventName.OPEN_VIEW, "BossFieldSoulShopView")
			}, this, true)


			Util.AddClickEvent(this._btn_drop, () => {
				BossModel.GetInstance().Fire(BossModel.OPEN_DROP_RECORD_VIEW)
			}, this, true)

			// Util.AddClickEvent(this._img_left, () => {
			// 	this.ArrowUpdateView(-1)
			// }, this, true)

			// Util.AddClickEvent(this._img_right, () => {
			// 	this.ArrowUpdateView(1)
			// }, this, true)

			Util.AddClickEvent(this._gp_ticket, () => {
				UIToolTipMgr.GetInstance().AppendGoodsTips(ticket_type_)
			}, this)

			Util.AddClickEvent(this._btn_add, () => {
				GlobalEventSystem.Fire(EventName.OPEN_VIEW, "BossVipAddView")
			}, this, true)

			let DungeonButtonCallBack = () => {
				if (clickTime_ && TimeUtil.getServerTime() - clickTime_ < 0.5) {
					return
				}
				let dun_infos = dunmodel.GetDungeonInfo(local_DUN_TYPE.Vip_Rerson_Boss)
				let dun_info = dun_infos && dun_infos[select_index_]
				if (!dun_info) {
					return
				}


				if (SceneManager.GetInstance().IsSuitBossScene()) {
					Message.show("当前场景不能进入")
					return
				}

				let dun_id = dun_data_[select_index_] && dun_data_[select_index_].dun_id

				//先退出队伍
				if (!BaseDungeonModel.GetInstance().TryToEnterDungeon(dun_id)) return


				if (this.first_enter) {
					dunmodel.Fire(local_BaseDungeonModel.SCMD_REQUEST, 61001, dun_id)
					return
				}
				let limit_vip_lv = Number(dun_info.vip_lv)
				let limit_vip_type = Number(dun_info.vip_type)
				let vip_lv_auto_buy = Number(dun_info.vip_lv_auto_buy)
				if (!dun_data_) {
					return
				}

				let cost_num = this.GetCostNum()
				let good_type = ticket_type_
				let goods_num = goods_model.GetTypeGoodsNum(good_type)
				let cfg = Config.PRELOAD_SERVER_CONFIG.config_goods_price
				let goods_info = cfg[good_type]
				if (!goods_info) {
					return
				}
				let goods_price = goods_info.price
				let basic = goods_model.GetGoodsBasicByTypeId(good_type)
				if (!basic) {
					return
				}
				let _tiket_name = basic.goods_name
				let vip_lv = role_mgr.GetMainRoleVo().vip_flag
				if (limit_vip_type && !vip_model.GetNobleCardState()) {
					let ok_callback = () => {
						local_OpenFun.OpenFunHandler(23, 0)
					}
					let content = "尚未激活特权卡,是否前往激活？"
					local_Alert.Show(content, local_Alert_Type.Two, ok_callback, null, "前往")
					return
				} else if (limit_vip_lv && limit_vip_lv > vip_lv) {
					let ok_callback = () => {
						local_OpenFun.OpenFunHandler(23, 0)
					}

					let content = "需要VIP" + limit_vip_lv + "才能进入，是否前往提升？"
					local_Alert.Show(content, local_Alert_Type.Two, ok_callback, null, "前往")
					return
				} else if (!remain_time_ || remain_time_ == 0) {
					if (vip_model.IsInvalidCard()) {
						let ok_callback = () => {
							local_OpenFun.OpenFunHandler(23, 0)
						}
						let content = "激活vip特权卡增加次数"
						local_Alert.Show(content, local_Alert_Type.Two, ok_callback, null, "前往")
						return
					}
					let cfg = this.cfg_num_by_vip
					let role_vipLv = vip_lv
					let key = "610@10000" + local_DUN_TYPE.Vip_Rerson_Boss + "@99@" + role_vipLv
					let cur_add_num = cfg[key].num
					let i = role_vipLv + 1
					do {
						key = "610@10000" + local_DUN_TYPE.Vip_Rerson_Boss + "@99@" + i
						if (!cfg[key]) {
							break
						}
						let add_num = cfg[key].num
						if (add_num > cur_add_num) {
							let ok_callback = () => {
								local_OpenFun.OpenFunHandler(23, 0)
							}
							let content = "VIP" + i + "可增加挑战次数,是否前往提升？"
							// if (PlatformMgr.GetInstance().IsEyouJpPlatform()) {
							// 	content = "プレミア" + i.. "挑戦回数を増やせます。増加しに行きますか？"
							// }
							local_Alert.Show(content, local_Alert_Type.Two, ok_callback, null, "前往")
							return
						}
						i = i + 1
					} while (true)
					Message.show("挑战次数不足")
					return
				}
				let ok_back = () => {
					if (goods_num < cost_num) {
						let enter_callback = () => {
							if (vip_lv_auto_buy > vip_lv) {
								local_OpenFun.OpenFunHandler(23, 0)
								return
							}
							let all_cost = (cost_num - goods_num) * goods_price
							if (role_mgr.mainRoleInfo.jin + role_mgr.mainRoleInfo.jinLock < all_cost) {
								local_Alert.Show("勾玉数量不足，是否进行充值", local_Alert_Type.Two, () => {
									local_OpenFun.OpenFunHandler(21)
								})
								return
							}
							dunmodel.Fire(local_BaseDungeonModel.SCMD_REQUEST, 61001, dun_id)
						}
						if (vip_lv_auto_buy && vip_lv && vip_lv_auto_buy > vip_lv) {
							let desc = "<font color='#ff4f50'>VIP" + vip_lv_auto_buy + "可直接消耗绑定勾玉购买门票</font>"
							// if (PlatformMgr.GetInstance().IsEyouJpPlatform()) {
							// 	desc = "<font color=0xff4f50>プレミア" + vip_lv_auto_buy + "入場券は無償ダイヤで購入可能</font>"
							// }
							local_GlobalEventSystem.Fire(OPEN_VIEW, "BossPersonalAlert", good_type, goods_num, cost_num, goods_price, dun_id, _tiket_name, local_DUN_TYPE.Vip_Rerson_Boss, enter_callback, desc, "前往提升")
						} else {
							local_GlobalEventSystem.Fire(OPEN_VIEW, "BossPersonalAlert", good_type, goods_num, cost_num, goods_price, dun_id, _tiket_name, local_DUN_TYPE.Vip_Rerson_Boss, enter_callback)
						}
					} else {
						dunmodel.Fire(local_BaseDungeonModel.SCMD_REQUEST, 61001, dun_id)
					}
					clickTime_ = TimeUtil.getServerTime()
				}
				let CheckEquipNum = () => {
					ok_back()
				}
				CheckEquipNum()
			}
			Util.AddClickEvent(this._btn_dun, DungeonButtonCallBack, this, true)

			this.BindEvent(dunmodel, BaseDungeonModel.QUIT_DUNGEON_RETURN, (dun_id)=>{
				let dun_id_1 = dun_data_[select_index_] && dun_data_[select_index_].dun_id
				if(dun_id_1&&dun_id_1==dun_id){
					DungeonButtonCallBack()
				}
			})

			let change_level = () => {
				if (!this._sl_dg_room || !this.loopr_mgr) {
					return
				}
				this.RefreshDunBtn()
				//let scrollH = this._list_dg_room.anchoredPosition.x
				this.loopr_mgr.SetSelectIndex(select_index_, false)
				//SetAnchoredPositionX(this.Content, scrollH)
			}
			this.BindEvent(role_mgr.GetMainRoleVo(), EventName.CHANGE_LEVEL, change_level)

			let updata_tecketNum = (goods_list?) => {
				if (this.use_delete_method) {
					return
				}
				let cur_data = dun_data_[select_index_]
				if (!cur_data) {
					return
				}
				//let dun_id = cur_data.dun_id
				let cost_num = this.GetCostNum()
				let good_type = ticket_type_
				for (let _tmpi in goods_list) {
					let good = goods_list[_tmpi]
					if (good.type_id == good_type) {
						let goods_num = goods_model.GetTypeGoodsNum(good_type)
						this._lb_have.text = String(goods_num)
						if (goods_num >= cost_num) {
							this._lb_have.color = ColorUtil.TryParseHtmlString("#00fa64")
						} else {
							this._lb_have.color = ColorUtil.TryParseHtmlString("#fe1a1a")
						}
						break
					}
				}
			}
			this.BindEvent(goods_model, GoodsModel.UPDATE_GOODS_NUM, updata_tecketNum)

			let update_view = (dun_type?) => {
				if (dun_type == local_DUN_TYPE.Vip_Rerson_Boss) {
					dun_data_ = dunmodel.GetDungeonInfo(local_DUN_TYPE.Vip_Rerson_Boss)
					this.InitView()
					this.InitDunRoomList()
				}
			}
			this.BindEvent(dunmodel, local_BaseDungeonModel.UPDATE_DUNGEON_TYPE_VIEW, update_view)

			/*
			let show = false
			let show_green_fun = (is_green?) => {
				show = !show
				if (this.color_shape) {
					destroy(this.color_shape)
					this.color_shape = null
				}
				if (show) {
					if (!this.color_shape) {
						this.color_shape = SetGreenOrBlackBg(this.form, is_green)
					}
				}
				this._Group2.visible = !show
				this._gp_drop.visible = !show
			}
			this.BindEvent(GlobalEventSystem, EventName.SHOW_GREEN_OR_BLACK_BG, show_green_fun)
			*/

			Util.AddClickEvent(this.lb_vip, () => {
				OpenFun.OpenFunHandler(23)
			}, this)
		}

		this.InitView = () => {
			if (!dun_data_) {
				return
			}
			let data = dun_data_[select_index_]
			if (!data) {
				return
			}
			this.first_enter = false
			let dun_id = data.dun_id
			let cfgs = this.cfg_dungeon
			let cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_dungeon.name, dun_id, false, cfgs)
			let price_cfg = Config.PRELOAD_SERVER_CONFIG.config_goods_price
			if (!cfg) {
				return
			}
			if (!price_cfg) {
				return
			}
			cost_ = ErlangParser.GetInstance().Parse(cfg.cost)
			let vip_card = vip_model.GetNobleCardState()
			let vip_flag = role_mgr.GetMainRoleVo().vip_flag
			//let role_lv = role_mgr.GetMainRoleVo().level
			let subId = local_BaseDungeonModel.VIP_COUNT_PARAMETER + Number(local_DUN_TYPE.Vip_Rerson_Boss)
			let num_type = vip_model.GetVipCfgNumType(this.cfg_num_by_vip_info, local_BaseDungeonModel.MODULE_ID, subId)
			if (num_type == 2) {
				vip_card = 99
			}
			let vip_default_count = vip_model.GetVipPrivilegeValue(local_BaseDungeonModel.MODULE_ID, subId, vip_card, vip_flag)
			let daily_default_count = Number(dun_data_[0].count_cond) + vip_default_count

			let supreme_vip_count = 0
			let supreme_vip = TopVipModel.GetInstance().GetMyTopVipVo()
			let supreme_vip_type = supreme_vip && supreme_vip.supvip_type
			let add_show = true
			if (role_mgr.GetMainRoleVo().supreme_vip && supreme_vip_type == 2) {
				supreme_vip_count = 1
				add_show = false
			}
			this._btn_add.visible = add_show
			if (add_show) {
				let scale = 18
				let pos = { x: 0, y: 0 }
				this.AddUIEffect("ZengJia", this._box_time_effect, pos, scale, true)
			}
			else
				this.ClearUIEffect(this._box_time_effect)
			let total_count = dun_data_[0].add_count + dun_data_[0].vip_count + daily_default_count + supreme_vip_count
			let remain_time = Math.max(total_count - dun_data_[0].daily_count, 0)
			remain_time_ = remain_time
			let cost_num = this.GetCostNum()
			let good_type = ticket_type_
			let goods_num = goods_model.GetTypeGoodsNum(good_type)
			let basic = goods_model.GetGoodsBasicByTypeId(good_type)
			this.lb_vip.visible = remain_time == 0 && total_count == 0
			this._lb_remain_time.visible = !this.lb_vip.visible
			if (this._lb_remain_time.visible) {
				let color = (remain_time == 0 && ("'#fe1a1a'") || ("'#00fa64'"))
				this._lb_remain_time.innerHTML = "剩余次数：" + HtmlColorTxt(remain_time, color) + "<font color = '#00fa64'>/" + total_count + "</font>"
				this.CallLater(() => {
					this._lb_remain_time.event(Laya.Event.RESIZE)
					this._btn_add.x = this._gp_times.x + this._lb_remain_time.contextWidth +5
					this._box_time_effect.x = this._btn_add.x - 6.5
				})
			}
			this._lb_have.text = String(goods_num)
			// if (PlatformMgr.GetInstance().IsEyouIdnPlatform()) {
			// 	this._lb_cost.text = "/" + cost_num + " " + basic.goods_name + " utk masuk"
			// } else {
			// 	this._lb_cost.text = "/" + cost_num
			// }
			this._lb_cost.text = "/" + cost_num

			let dun_infos = dunmodel.GetDungeonInfo(local_DUN_TYPE.Vip_Rerson_Boss)
			let dun_info = dun_infos && dun_infos[select_index_]
			let vip_lv_auto_buy = Number(dun_info.vip_lv_auto_buy)
			let str = null
			if (vip_flag < vip_lv_auto_buy) {
				str = "非<font color='#00fa64'>V" + vip_lv_auto_buy + "</font>可消耗" + basic.goods_name
			} else {
				let price = price_cfg[good_type].price * cost_num
				// if (PlatformMgr.GetInstance().IsEyouIdnPlatform()) {
				// 	str = "Bisa konsumsi <font color=0xb3ff48>" + price + "</font> Berlian Terikat"
				// } else {
				// 	str = "可消耗<font color=0xb3ff48>" + price + "</font>绑玉或" + basic.goods_name
				// }
				str = "可消耗<font color='#00fa64'>" + price + "</font>绑玉或" + basic.goods_name
			}
			this._lb_tiket_name.innerHTML = Util.StrToHTML(str)
			if (goods_num >= cost_num) {
				this._lb_have.color = ColorUtil.TryParseHtmlString("#00fa64")
			} else {
				this._lb_have.color = ColorUtil.TryParseHtmlString("#fe1a1a")
			}
			if (basic) {
				let good_url = "resource/game/goodsIcon/" + basic.goods_icon + ".png"
				ResManager.GetInstance().SetOutsideImageSprite(this, this._img_goodsicon, good_url)
			}

			this.CallLater(() => {
				this._lb_tiket_name.event("resize")
			})

			// 首次挑战
			if (data.rec_data) {
				for (let i in data.rec_data) {
					let vo = data.rec_data[i]
					if (vo.key == 10 && vo.val == 0) {
						this.first_enter = true
					}
				}
			}
			this._lb_first.visible = this.first_enter
			this._gp_ticket.visible = !this.first_enter
			this._img_red.visible = !btnGray && this.first_enter
			//LayoutRebuilder(this._Group3)
			//LayoutRebuilder(this._gp_ticket)
		}

		this.InitDunRoomList = () => {
			if (!dun_data_) {
				return
			}
			if (!this.loopr_mgr) {
				this.loopr_mgr = new LoopScrowViewMgr()
				//let cnf = { not_first_call: true }
				this.loopr_mgr.SetData(this._sl_dg_room, BossPersonalItem, dun_data_, LoopScrCon.Horizontal, 1, (index) => {
					this.ShowSelectDunRoomInfo(index)
					this.InitView()
				}, select_index_)
			} else {
				this.loopr_mgr.replaceAll(dun_data_)
			}

			// 滑动框定位
			// let num = select_index_ + 1
			// if (num > 4) {
			// 	this.loopr_mgr.LastOnChild(num)
			// }

			// 滑动框定位
			let num = select_index_
			let value = 0
			if (num > 4) {
				value = num * 140 + (num - 1) * this._sl_dg_room.spaceX
				value = Math.min(value, 1293)
			}
			this._sl_dg_room.scrollBar.value = value

			this.loopr_mgr.SetOnValueChanged(() => {
				this.HideArrow()
			})
			//setTimeout(() => {
			//this.loopr_mgr.FirstOnChild(select_index_)
			this.loopr_mgr.SetSelectIndex(select_index_, false)
			this.HideArrow()
			//},0.2)
			//this:UpdateScrollerView(select_index_)
			this.ShowSelectDunRoomInfo(select_index_)
			//this:HideArrow()
		}

		this.ArrowUpdateView = (_dir?) => {
			return
			/*
			if (this.clickTime && TimeUtil.getServerTime() - this.clickTime <= 0.3) {
				return
			}
			for (let _index in dun_data_) {
				let _width = this.Content.sizeDelta.x / dun_data_.length
				let _center_pos = Math.ceil(_width * Number(_index) + _width / 2)
				let _next_center_pos = Math.ceil(_width * (Number(_index) + 1) + _width / 2)
				let _view_center_pos = -this.Content.anchoredPosition.x + this._sl_dg_room.x / 2
				let move_x = null
				if (_dir == 1) {
					if (_center_pos <= _view_center_pos && _next_center_pos > _view_center_pos) {
						this.clickTime = TimeUtil.getServerTime()
						if (Math.abs(_center_pos - _view_center_pos) <= 5) {
							move_x = _next_center_pos - this._sl_dg_room.x / 2~
						} else if (Math.abs(_next_center_pos - _view_center_pos) <= 5) {
							move_x = Math.ceil(_width * Number(_index) + 2 + _width / 2) - this._sl_dg_room.x / 2
						} else {
							move_x = _next_center_pos - this._sl_dg_room.x / 2
						}
						if (move_x + this._sl_dg_room.x > this.Content.sizeDelta.x) {
							move_x = this.Content.sizeDelta.x - this._sl_dg_room.x
						}
						if (this.tween_id1) {
							SYTweenLite.Stop(this.tween_id1)
							this.tween_id1 = null
						}
						this.tween_id1 = SYTweenLite.to(this, this.Content, SYTweenLite.UiAnimationType.POSX, -move_x, 0.3, () => {
							this.HideArrow()
							SYTweenLite.Stop(this.tween_id1)
						})
						return
					}
				} else {
					if (_center_pos < _view_center_pos && _next_center_pos >= _view_center_pos) {
						this.clickTime = TimeUtil.getServerTime();
						if (Math.abs(_center_pos - _view_center_pos) <= 10) {
							move_x = Math.ceil(_width * Number(_index) - 1 + _width / 2) - this._sl_dg_room.x / 2
						} else {
							move_x = _center_pos - this._sl_dg_room.x / 2
						}
						if (move_x < 0) {
							move_x = 0
						}
						if (this.tween_id2) {
							SYTweenLite.Stop(this.tween_id2)
							this.tween_id2 = null
						}
						this.tween_id2 = SYTweenLite.to(this, this.Content, SYTweenLite.UiAnimationType.POSX, -move_x, 0.3, () => {
							this.HideArrow()
							SYTweenLite.Stop(this.tween_id2)
						})
						return
					}
				}
			}
			*/
		}

		this.HideArrow = () => {
			if (!dun_data_) {
				return
			}

			let value = this.loopr_mgr.parent.scrollBar.value
			let min = 0.01
			let max = this.loopr_mgr.parent.scrollBar.max
			this._img_left.visible = value > min
			this._img_right.visible = value < max
			/*
			
			let _width = this.Content.sizeDelta.x / dun_data_.length
			if (Math.abs(this.Content.anchoredPosition.x) >= _width / 3) {
				this._img_left.visible = true
			} else {
				this._img_left.visible = false
			}
			if (Math.abs(this.Content.anchoredPosition.x) + this._sl_dg_room.x <= this.Content.sizeDelta.x - _width / 3) {
				this._img_right.visible = true
			} else {
				this._img_right.visible = false
			}
			*/
		}

		this.UpdateScrollerView = (_select?) => {
			/*
			if (!dun_data_) {
				return
			}
			let _itemnum = dun_data_.length
			let _total_width = this.Content.sizeDelta.x
			let _view_width = this._sl_dg_room.x
			let item_width = _total_width / _itemnum * _select
			if (item_width > _view_width / 2 && item_width < _total_width - _view_width / 2) {
				SetAnchoredPositionX(this.Content, - (item_width - _view_width / 2 + _total_width / _itemnum / 2))
			} else if (item_width <= _view_width / 2) {
				SetAnchoredPositionX(this.Content, 0)
			} else if (item_width > _total_width - _view_width / 2) {
				SetAnchoredPositionX(this.Content, -(_total_width - _view_width))
			}
			this.loopr_mgr.WrapContent()
			this.loopr_mgr.ForceUpdateCurrentItems()
			*/

			//setTimeout(() => {
			//this.loopr_mgr.CenterOnChild(_select)
			//},0.2)
		}

		this.SetDefaultSelect = () => {
			if (!dun_data_) {
				return
			}
			if (select_boss_id_) {
				let index = 0
				for (let key in dun_data_) {
					let c = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_dungeon_ui_content.name, dun_data_[key].dun_id, false, this.cfg_ui_content)
					let boss_id = c["value1"]
					if (boss_id == select_boss_id_) {
						break
					}
					index = index + 1
				}
				select_index_ = index
			} else {
				let role_lv = role_mgr.GetMainRoleVo().level
				for (let _index in dun_data_) {
					if (role_lv < Number(dun_data_[_index].level)) {
						if (Number(_index) == 0) {
							select_index_ = 0
						} else {
							select_index_ = Number(_index) - 1
						}
						return
					}
				}
				if (!select_index_ || select_index_ == 0) {
					select_index_ = dun_data_.length - 1
				}
			}
		}

		this.ShowSelectDunRoomInfo = (select_index?) => {
			select_index_ = select_index
			if (!dun_data_) {
				return
			}
			let dun_data = dun_data_[select_index]
			if (!dun_data || !dun_data.dun_id) {
				return
			}

			if (!this.cfg_ui_content) {
				return
			}
			let _roominfo = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_dungeon_ui_content.name, dun_data.dun_id, false, this.cfg_ui_content)
			if (!_roominfo) {
				return
			}
			let _bossinfo = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_mon.name, _roominfo.value1, false)
			if (!_bossinfo) {
				return
			}
			this._lb_boss_name.text = _bossinfo.name
			let reward_list = JSON.parse(_roominfo.rewards)
			let career = role_mgr.GetMainRoleVo().career
			let reward = []
			for (let key in reward_list) {
				let obj = reward_list[key]
				if (Number(obj[0]) == career) {
					reward = obj[1]
					break
				}
			}
			if (reward.length == 0) {
				reward = reward_list
			}
			this.ShowRewardItem(reward)
			this._bossinfo = _bossinfo
			this.icon = _bossinfo.icon
			this.ShowBossModel(this.icon)
			this.RefreshDunBtn()
		}

		this.RefreshDunBtn = () => {
			let role_lv = role_mgr.GetMainRoleVo().level
			let dun_info = dunmodel.GetDungeonInfo(local_DUN_TYPE.Vip_Rerson_Boss)
			if (!dun_info) {
				return
			}
			let cur_info = dun_info[select_index_]
			if (!cur_info) {
				//GameError.GetInstance().SendErrorToPHP("专属boss：" + select_index_ + " 配置长度" + dun_info.length, true)
				return
			}
			let limit_lv = Number(cur_info.level)
			//let limit_vip_lv = cur_info.vip_lv
			if (!limit_lv || role_lv >= limit_lv) {
				//this.labelDisplay.color = ColorUtil.TryParseHtmlString("#d86137")
				if (PlatformManager.IsEyouEnPlatform()) {
					this.labelDisplay.fontSize = 18
				}else{
				this.labelDisplay.fontSize = 22
				}
				this.labelDisplay.text = "前往挑战"
				if (btnGray) {
					Util.SetImageGray(this._Image11, false)
					btnGray = false
				}
				this._btn_dun.mouseEnabled = true
			} else {
				//this.labelDisplay.color = ColorUtil.TryParseHtmlString("#4c4c4c")
				// if (PlatformMgr.GetInstance().IsEyouIdnPlatform()) {
				// 	let lv = limit_lv > 370 && "Genesis Lv." + (limit_lv - 370) || "Lv." + limit_lv
				// 	this.labelDisplay.text = "<size=26>" + lv + "</size>"
				// } else {
				this.labelDisplay.fontSize = 18
				let lv = (limit_lv > 370 && ("神创" + (limit_lv - 370)) || (limit_lv))
				let _dec = lv + "级开启"
				this.labelDisplay.text = _dec
				//}
				// if (PlatformMgr.GetInstance().IsEyouJpPlatform()) {
				// 	lv = (limit_lv > 370 && ("神話Lv" + (limit_lv - 370)) || ("Lv" + limit_lv))
				// 	_dec = lv + "解放"
				// 	this.labelDisplay.text = "<size=26>" + _dec + "</size>"
				// }
				if (!btnGray) {
					Util.SetImageGray(this._Image11, true)
					btnGray = true
				}
				this._btn_dun.mouseEnabled = false
			}
		}

		this.ShowBossModel = (model_id?) => {
			if (model_id == null) { return }
			let modelCfg = this.cfg_dungeon_client.show_effect
			let _modelCfg = modelCfg[model_id]
			let offset = _modelCfg && _modelCfg.offset || { x: 0, y: 0 }
			let ui_scale = _modelCfg && _modelCfg.scale || 1
			let action_name_list = _modelCfg && _modelCfg.action_name_list || ["attack"]
			table.insert(action_name_list, "idle")

			// let curr_sorting_order = this.AddCurrLayerSortingOrder(this.layer_value)
			// let callBack = () => {
			// 	this.CoverMode(this._gp_drop, this.layer_value, curr_sorting_order)
			// 	this.CoverMode(this._Group2, this.layer_value, curr_sorting_order)
			// }
			let data = {
				clothe_res_id: model_id,
				type: UI_MODEL_TYPE.MONSTER,
				layer_value: this.layer_value,
				scale: 0.7 * ui_scale,
				position: offset,
				action_name_list: action_name_list,
				layout_file: "BossPersonalEnterView"
			}
			ResManager.GetInstance().SetRoleModel(this, this._gp_boss_model, data)
		}

		this.ShowRewardItem = (reward_list?) => {
			let act_goods = BossModel.GetInstance().GetActiveDrop()
			if (act_goods) {
				let [type_id, lock] = goods_model.GetMappingTypeId(0, act_goods)
				let goods_vo = goods_model.GetGoodsBasicByTypeId(type_id)
				if (goods_vo) {
					table.insert(reward_list, { 0: 0, 1: goods_vo.type_id, 2: 0 })
				}
			}
			let len = reward_list.length
			if (!reward_item_list_) {
				reward_item_list_ = []
			}
			let i = len
			if (i < reward_item_list_.length) {
				do {
					if (reward_item_list_[i].display_obj)
						reward_item_list_[i].display_obj.visible = false
					i = i + 1
				} while ((i < reward_item_list_.length))
			}
			for (let key in reward_list) {
				let item = reward_item_list_[key]
				if (!item) {
					item = new EquipmentItem(this._reward_con)
					reward_item_list_[key] = item
					item.SetUseMask(true)
					item.Load()
					item.SetItemSize(80, 80)
					item.SetPosition(Number(key) % 2 == 0 ? 0 : 97, Math.floor(Number(key) / 2) * 89)
				}

				let vo = reward_list[key]
				item.ExcuteCallback(() => {
					let [type_id, lock] = goods_model.GetMappingTypeId(vo[0], vo[1])
					let goods_vo = goods_model.GetGoodsBasicByTypeId(type_id)
					if (goods_vo) {
						item.SetData(goods_vo.type_id, 0, lock)
						if (item.display_obj)
							item.display_obj.visible = true
					}
				})
			}
		}

		this.GetCostNum = () => {
			if (!dun_data_ || !cost_) {
				return
			}
			for (let _tmpi in cost_) {
				let v = cost_[_tmpi]
				if (Number(v[0]) <= dun_data_[0].daily_count + 1 && Number(v[1]) >= dun_data_[0].daily_count + 1) {
					ticket_type_ = Number(v[2][0][1])
					return Number(v[2][0][2])
				}
			}
		}

		this.DeleteMe = () => {
			this.ClearUIEffect(this._box_time_effect)
			if (this.tween_id1) {
				SYTweenLite.Stop(this.tween_id1)
				this.tween_id1 = null
			}

			if (this.tween_id2) {
				SYTweenLite.Stop(this.tween_id2)
				this.tween_id2 = null
			}

			if (reward_item_list_) {
				for (let _tmpi in reward_item_list_) {
					let obj = reward_item_list_[_tmpi]
					obj.DeleteMe()
				}
				reward_item_list_ = null
			}
			dunmodel.vip_person_view_status = false
			clickTime_ = null
			if (this.loopr_mgr) {
				this.loopr_mgr.DeleteMe()
				this.loopr_mgr = null
			}
			// if (this.color_shape) {
			// 	destroy(this.color_shape)
			// 	this.color_shape = null
			// }
			super.DeleteMe()
		}

		this.CustomMehod = (index?, args?) => {
			if ((args && args[0]) && Number(args[0]) > 1) {
				select_boss_id_ = args[0]
			}
		}
	}


	private ShowShop = () => {
		let lv = RoleManager.GetInstance().GetMainRoleLevel()
		this._img_shop.visible = lv >= 300
	}

	private CheckShopRed = () => {
		let red = ShopModel.GetInstance().CheckSoulOfWarRed()
		this._img_shop_red.visible = red
	}


	_Group1: Laya.Box
	_gp_boss_model: Laya.Box
	_btn_drop: Laya.Image
	_Image1: Laya.Image
	_lb_boss_name: Laya.Label
	_img_shop: Laya.Image
	_img_shop_red: Laya.Image
	_Group2: Laya.Box
	_img_drop: Laya.Image
	_Label1: Laya.Label
	_reward_con: Laya.Panel
	_Group3: Laya.Box
	_img_bg: Laya.Image
	_sl_dg_room: Laya.List
	_gp_times: Laya.HBox
	_lb_remain_time: Laya.HTMLDivElement
	_btn_add: Laya.Image
	_box_time_effect: Laya.Box
	_gp_ticket: Laya.HBox
	_lb_tiket_name: Laya.HTMLDivElement
	_img_goodsicon: Laya.Image
	_lb_have: Laya.Label
	_lb_cost: Laya.Label
	_lb_enter: Laya.Label
	_lb_first: Laya.Label
	_btn_dun: Laya.Box
	_Image11: Laya.Image
	labelDisplay: Laya.Label
	_img_red: Laya.Image
	_img_left: Laya.Image
	_img_right: Laya.Image
	_lb_cond: Laya.Label
	lb_vip: Laya.Label
	public GetComponents() {
		[
			this._Group1,
			this._gp_boss_model,
			this._btn_drop,
			this._Image1,
			this._lb_boss_name,
			this._img_shop,
			this._img_shop_red,
			this._Group2,
			this._img_drop,
			this._Label1,
			this._reward_con,
			this._Group3,
			this._img_bg,
			this._sl_dg_room,
			this._gp_times,
			this._lb_remain_time,
			this._btn_add,
			this._box_time_effect,
			this._gp_ticket,
			this._lb_tiket_name,
			this._img_goodsicon,
			this._lb_have,
			this._lb_cost,
			this._lb_enter,
			this._lb_first,
			this._btn_dun,
			this._Image11,
			this.labelDisplay,
			this._img_red,
			this._img_left,
			this._img_right,
			this._lb_cond,
			this.lb_vip,
		]
			= this.GetChildrenByNames([

				"_Group1",
				"_gp_boss_model",
				"_btn_drop",
				"_Image1",
				"_lb_boss_name",
				"_img_shop",
				"_img_shop_red",
				"_Group2",
				"_img_drop",
				"_Label1",
				"_reward_con",
				"_Group3",
				"_img_bg",
				"_sl_dg_room",
				"_gp_times",
				"_lb_remain_time",
				"_btn_add",
				"_box_time_effect",
				"_gp_ticket",
				"_lb_tiket_name",
				"_img_goodsicon",
				"_lb_have",
				"_lb_cost",
				"_lb_enter",
				"_lb_first",
				"_btn_dun",
				"_Image11",
				"labelDisplay",
				"_img_red",
				"_img_left",
				"_img_right",
				"_lb_cond",
				"lb_vip",
			])
	}
}
window["BossPersonalEnterView"] = BossPersonalEnterView
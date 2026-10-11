import { BaseItem1 } from "../common/BaseItem1"
import { table } from "../common/table"
import { Util, SetAnchoredPosition } from "../util/Util"
import { Config } from "../common/Config"
import { TimeUtil } from "../util/TimeUtil"
import { OpenFun } from "../common/OpenFun"
import { EventName, SceneEventType } from "../common/EventName"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GlobalTimerQuest } from "../util/Util"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { GoodsModel } from "../commonModel/GoodsModel"
import { RoleManager } from "../commonModel/RoleManager"
import { SceneManager } from "../scene/SceneManager"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { Alert, Alert_Type } from "../alert/Alert"
import { LoopScrowViewMgr, LoopScrCon } from "../common/LoopScrowViewMgr"
import { Message } from "../sysInfo/SysInfoController"
import { BossModel } from "../commonModel/BossModel"
import { BossSuitItem } from "./BossSuitItem"
import { BossFieldTabItem } from "../bossField/BossFieldTabItem"

import "../bossPersonal/BossPersonalAlert"

export class BossSuitRoomItem extends BaseItem1 {
	ClearTime
	CreateRadionBtn
	InitEvent
	LayerInfo
	LoadSuccess
	RadioBtnCallBack
	RequestPlayerNum
	SetClickCallBack
	SetData
	SetDefultSelect
	SetSelectBoss
	SwitchView
	UpdateLayerMapView
	UpdateTicket
	UpdateView
	SourceVipClick
	UpdateVipShow

	all_layers
	boss_info
	boss_type
	clickTime
	cost
	cur_layer_boss_info_list
	cur_layer_boss_list
	getAttentionNum
	is_enter
	is_load
	layer_info
	model
	radioBtn
	role_lv
	select_boss_id
	select_index
	select_layer
	swicth_view_call_back
	ticket_num
	ticket_typeid
	timer
	cfg_boss
	cfg_boos_type
	cfg_bg
	role_mgr

	public constructor(parent?) {
		super(parent)
		this.base_file = "suitboss"
		this.layout_file = "BossSuitRoomItem"

		this.layer_info = []
		this.boss_type = BossModel.BossType.suit
		this.cur_layer_boss_list = []
		this.cur_layer_boss_info_list = []
		this.is_load = true
		this.is_enter = false
		this.model = BossModel.GetInstance()
		this.role_mgr = RoleManager.GetInstance()

		this.load_callback = () => {
			this._Scroller1.scrollBar.visible = false
			this._lb_enter_num.style.fontSize = 20
			this._lb_enter_num.style.color = "#ffffff"
			this._lb_enter_num.style.wordWrap = false
			this._lb_people_num.style.fontSize = 20
			this._lb_people_num.style.color = "#ffffff"
			this._lb_people_num.style.wordWrap = false
			this._lb_people_num.innerHTML = "当前进入人数：<font color = '#00fa64'>0</font>"
			this._lb_ticket.style.fontSize = 20
			this._lb_ticket.style.color = "#ffffff"
			this._lb_ticket.style.wordWrap = false
			this.source_vip.style.fontSize = 20
			this.source_vip.style.color = "#00fa64"
			this.source_vip.style.wordWrap = false
			this.source_vip.innerHTML = "<a href = '226'>提升疲劳值上限</a>"

			/*
			if (PlatformMgr.GetInstance().IsEyouIdnPlatform()) {
				this._lb_enter_num.size = 20
				this._lb_people_num.size = 20
				this._Label1.size = 20
				this._lb_ticket.size = 20
				let csf = this.labelDisplay.GetComponent("ContentSizeFitter")
				csf.horizontalFit = UnityEngine.UI.ContentSizeFitter.FitMode.Unconstrained
				SetSizeDeltaX(this.labelDisplay, 150)
				this.labelDisplay.lineSpacing = 0.7
				this.labelDisplay.verticalAlign = "middle"
				this.labelDisplay.textAlign = "center"
			}
			*/
			this.LoadSuccess()
			this.InitEvent()
			this.SetDefultSelect()
			this.UpdateVipShow()
		}

		this.LoadSuccess = () => {
			this.cfg_boss = ResManager.GetInstance().GetGameConfigFromCache(this, "config_boss_cfg", false)
			this.cfg_boos_type = ResManager.GetInstance().GetGameConfigFromCache(this, "config_boss_type", false)
			this.cfg_bg = ResManager.GetInstance().GetGameConfigFromCache(this, "ClientBossBg", true)

			this.model.Fire(BossModel.SCMD_REQUEST, 46000, this.boss_type)
			if (!this.timer) {
				this.timer = GlobalTimerQuest.AddPeriodQuest(this.RequestPlayerNum, 5)
			}
			this.cost = this.model.GetSuitBossTypeCost(BossModel.BossType.suit, this.cfg_boos_type)
			this.role_lv = RoleManager.GetInstance().GetMainRoleVo().level
			this.ticket_num = GoodsModel.GetInstance().GetTypeGoodsNum(this.cost[1].type_id)
			this.ticket_typeid = this.cost[1].type_id
			let ticket_basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(this.ticket_typeid)
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_ticket, GameResPath.GetGoodsIconPath(ticket_basic.goods_icon))
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_map, GameResPath.GetIcon("suitboss", "uimh_004"))
		}

		this.CreateRadionBtn = () => {
			let tab_list = []
			let index = 0
			//let tab
			do {
				index = index + 1
				/*
				if (PlatformMgr.GetInstance().IsEyouEnPlatform()) {
					table.insert(tab_list, { label = "Fl." + index, down_source = "uimh_004", down_text_color = "#fbf5d3", down_show_outline=false })
				} else if (PlatformMgr.GetInstance().IsEyouThPlatform()) {
					table.insert(tab_list, { label = "ขั้น" + index, down_source = "uimh_004", down_text_color = "#fbf5d3", down_show_outline=false })
				} else if (PlatformMgr.GetInstance().IsEyouIdnPlatform()) {
					tab = [label = "Lt." + index, down_source = "uimh_004", down_text_color = "#fbf5d3", down_show_outline = false]
					table.insert(tab_list, tab)
				} else {
					table.insert(tab_list, { label = `第${index}层`, down_source = "uimh_004", down_text_color = "#fbf5d3", down_show_outline=false })
				}
				*/
				table.insert(tab_list, { label: `${index}层`, boss_type: BossModel.BossType.suit })
			} while ((index < this.all_layers)
			)
			if (!this.radioBtn) {
				this.radioBtn = new LoopScrowViewMgr()
				this.radioBtn.SetData(this._Scroller1, BossFieldTabItem, tab_list, LoopScrCon.Horizontal, 1, this.RadioBtnCallBack)
			} else {
				this.radioBtn.replaceAll(tab_list)
			}
		}

		this.InitEvent = () => {
			let UpdateTicketNum = (goods_list?) => {
				if (this.use_delete_method) {
					return
				}
				if (!this.cost) {
					return
				}
				for (let _tmpi in goods_list) {
					let good = goods_list[_tmpi]
					if (good.type_id == this.cost[1].type_id) {
						this.ticket_num = GoodsModel.GetInstance().GetTypeGoodsNum(good.type_id)
						if (!this.is_enter) {
							this.UpdateTicket()
						}
						this.is_enter = false
					}
				}
			}
			this.BindEvent(GoodsModel.GetInstance(), GoodsModel.UPDATE_GOODS_NUM, UpdateTicketNum)

			Util.AddClickEvent(this._img_ticket, () => {
				UIToolTipMgr.GetInstance().AppendGoodsTips(this.ticket_typeid)
			}, this, true)

			Util.AddClickEvent(this._btn_go, () => {
				//let server_time = TimeUtil.getServerTime()
				if (this.clickTime && (TimeUtil.getServerTime() - this.clickTime) * 1000 < 500) {
					return
				}
				if (!this.layer_info || !this.layer_info[this.select_layer + 1] || !this.layer_info[this.select_layer + 1][0]) { return }
				let open_lv = this.layer_info[this.select_layer + 1][0].open_lv
				if (this.role_lv < open_lv) {
					let dec = "玩家达到" + open_lv + "级可进入蛮荒" + this.select_layer + "层"
					Message.show(dec)
					return
				}
				if (this.boss_info.count <= 0) {
					Message.show("进入次数已用完")
					return
				}
				let _cost = this.cost[this.boss_info.all_count - this.boss_info.count + 1]
				if (!_cost) {
					return
				}
				let _cfg = Config.PRELOAD_SERVER_CONFIG.config_goods_price[_cost.type_id]
				if (!_cfg) {
					return
				}
				let goods_price = _cfg.price
				let cfgs = ResManager.GetInstance().GetGameConfigFromCache(this, "Goods", false)
				let goods_cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_goods.name, _cost.type_id, false, cfgs)
				if (!goods_cfg) {
					return
				}
				let goods_name = goods_cfg.goods_name
				//let equip_bag_cell = BossModel.GetInstance().GetBossKeyValue(BossModel.BossType.suit, "min_equip_bag_cell")
				//let god_bag_cell = BossModel.GetInstance().GetBossKeyValue(BossModel.BossType.suit, "min_god_bag_cell")
				let request_func = () => {
					let cost_count = Number(goods_price) * (Number(_cost.need_num) - Number(this.ticket_num))
					let jin_lock = this.role_mgr.GetMainRoleVo().jinLock
					let jin = this.role_mgr.GetMainRoleVo().jin
					let scmd_func = () => {
						BossModel.GetInstance().SetEnterBossInfo({ boss_id: this.select_boss_id })
						BossModel.GetInstance().Fire(BossModel.SCMD_REQUEST, 46003, BossModel.BossType.suit, this.select_boss_id)
						this.is_enter = true
					}
					if (jin_lock < cost_count && jin + jin_lock < cost_count) {
						Alert.Show("勾玉数量不足，是否进行充值", Alert_Type.Two, () => {
							OpenFun.OpenFunHandler(21)
						})
					} else if (jin_lock < cost_count && jin + jin_lock >= cost_count) {
						let str = "<font color='#ff4f50'>当前绑定勾玉数量不足，是否消耗勾玉代替？</font>"
						let content = Util.StrToHTML(str)
						Alert.Show(content, Alert_Type.Two, scmd_func, null, "确定", "取消")
						Alert.SetIsCharge(true)
					} else {
						scmd_func()
					}
				}

				let ok_back = () => {
					if (this.ticket_num < _cost.need_num) {
						GlobalEventSystem.Fire(EventName.OPEN_VIEW, "BossPersonalAlert", _cost.type_id, this.ticket_num, _cost.need_num, goods_price, this.select_boss_id, goods_name, BossModel.BossType.suit, () => {
							request_func()
						}
						)
					} else {
						request_func()
					}
					this.clickTime = TimeUtil.getServerTime()
				}

				let CheckEquipNum = () => {
					ok_back()
				}
				if (this.layer_info[this.select_layer + 1][this.select_index].lv - RoleManager.GetInstance().GetMainRoleVo().level >= BossModel.HIGT_LEVEL_TIPS_VALUE) {
					Alert.Show("该大妖等级较高，挑战可能比较困难。<br>是否继续前往?", Alert_Type.Two, CheckEquipNum, null, "前往", "取消")
					return
				}
				let alert1 = () => {
					Alert.Show("是否离开当前场景?", Alert_Type.Two, () => {
						CheckEquipNum()
					}
						, null, "离开", "取消")
				}

				if (SceneManager.GetInstance().IsSuitBossScene()) {
					let curr_scene_id = SceneManager.GetInstance().curr_scene_id
					let layer = curr_scene_id - BossModel.BaseBossSceneId[this.boss_type]
					if (this.select_layer == layer) {
						BossModel.GetInstance().Fire(BossModel.CHANGE_BOSS_TARGET, null, this.select_boss_id)
						GlobalEventSystem.Fire(EventName.OPEN_BOSS_ENTER_VIEW, null, null, false)
					} else {
						alert1()
					}
				} else {

					if(SceneManager.GetInstance().IsNotChangeScene()){
						Message.show("当前场景不能进入")
						return
					}


					if (!SceneManager.GetInstance().IsFieldScene()) {
						alert1()
					} else {
						CheckEquipNum()
					}
				}
			}
				, this, true)
			this.BindEvent(RoleManager.GetInstance().GetMainRoleVo(), EventName.CHANGE_LEVEL, (lv?) => {
				this.role_lv = lv
				this.UpdateView()
			})

			this.BindVar(RoleManager.GetInstance().GetMainRoleVo(), "vip_flag", (vip_flag?) => {
				this.model.Fire(BossModel.SCMD_REQUEST, 46000, this.boss_type)
				this.UpdateVipShow()
			})

			this.BindVar(RoleManager.GetInstance().GetMainRoleVo(), "supreme_vip", () => {
				this.UpdateVipShow()
			})

			this.BindEvent(this.model, BossModel.UPDATE_BOSS_INFO, (boss_type?) => {
				if (boss_type == this.boss_type && this.cur_layer_boss_info_list && this.cur_layer_boss_info_list.length != 0) {
					this.UpdateView()
				}
			}
			)
			this.BindEvent(this.model, BossModel.UPDATE_PLAYER_NUM, (scene_id?, player_num?) => {
				if (this.use_delete_method) { return }
				let boss_cfgs = this.cfg_boss
				if (boss_cfgs) {
					let cur_scene_id = boss_cfgs[this.select_boss_id] && boss_cfgs[this.select_boss_id].scene
					if (cur_scene_id == scene_id) {
						this._lb_people_num.innerHTML = "当前进入人数：<font color = '#00fa64'>" + player_num + "</font>"
					}
				}
			}
			)

			this.source_vip.on(Laya.Event.LINK, this, this.SourceVipClick)
		}

		this.RadioBtnCallBack = (index?) => {
			if (this.select_layer == Number(index)) {
				return
			}
			let layer = index + 1
			let open_lv = this.layer_info[layer][0].open_lv
			if (this.role_lv < open_lv) {
				let lv = (open_lv > 370 && ("神创" + (open_lv - 370)) || (open_lv))
				let dec = "玩家达到" + lv + "级可进入蛮荒" + layer + "层"
				Message.show(dec)
				this.radioBtn.SetSelectIndex(this.select_layer)
				return
			}
			this.select_index = 0
			this.select_layer = index
			this.UpdateLayerMapView()
			this.SwitchView(this.select_index)
		}

		this.SetClickCallBack = (SwitchView?) => {
			this.swicth_view_call_back = SwitchView
		}

		this.SetSelectBoss = (select_boss_id?) => {
			this.select_boss_id = select_boss_id
		}

		this.UpdateTicket = () => {
			if (!this._lb_ticket) {
				return
			}
			let need_num = 1
			if (this.boss_info.count == 0 && this.cost[this.boss_info.all_count + 1]) {
				need_num = this.cost[this.boss_info.all_count + 1].need_num
			} else if (this.boss_info.count == 0 && !this.cost[this.boss_info.all_count + 1]) {
				need_num = 0
			} else if (this.boss_info.count != 0) {
				need_num = this.cost[this.boss_info.all_count - this.boss_info.count + 1].need_num
			}
			let _color = (this.ticket_num >= need_num && ("'#00fa64'") || ("'#fe1a1a'"))
			this._lb_ticket.innerHTML = Util.StrToHTML("<font color=" + _color + ">" + this.ticket_num + "</font>" + "/" + need_num)
			_color = (this.boss_info.count > 0 && ("'#00fa64'") || ("'#fe1a1a'"))
			this._lb_enter_num.innerHTML = Util.StrToHTML("剩余进入次数：<font color=" + _color + ">" + this.boss_info.count + "/" + this.boss_info.all_count + "</font>")
			this.CallLater(() => {
				this._lb_ticket.event("resize")
			})
		}

		this.SwitchView = (index?) => {
			if (this.cur_layer_boss_info_list[index]) {
				this.select_boss_id = this.cur_layer_boss_info_list[index].boss_id
				this.swicth_view_call_back(this.cur_layer_boss_info_list[index])
				this.RequestPlayerNum()
			}
		}

		this.RequestPlayerNum = () => {
			let boss_cfgs = this.cfg_boss
			if (boss_cfgs) {
				let scene_id = boss_cfgs[this.select_boss_id] && boss_cfgs[this.select_boss_id].scene
				if (scene_id) {
					GlobalEventSystem.Fire(SceneEventType.SCENE_PALYER_COUNT, scene_id)
				}
			}
		}

		this.SetData = (boss_info?) => {
			this.boss_info = boss_info
			if (this.boss_info) {
				this.UpdateTicket()
				this.UpdateView()
			}
		}

		this.UpdateView = () => {
			this.boss_info = this.model.GetBossTypeInfo(BossModel.BossType.suit)
			if (this.boss_info) {
				this.UpdateTicket()
				this.SwitchView(this.select_index)
				this.getAttentionNum()
				this.LayerInfo()
				this.UpdateLayerMapView()
			}
		}

		this.UpdateLayerMapView = () => {
			for (let index in this.cur_layer_boss_list) {
				let item = this.cur_layer_boss_list[index]
				if (item) {
					item.visible = false
				}
			}
			this.cur_layer_boss_info_list = this.layer_info[this.select_layer + 1]
			let bg = this.cfg_bg && this.cfg_bg[this.boss_type]
			let pos_list = null
			if ((bg && bg[Number(this.select_layer)]) && bg[Number(this.select_layer)]["pos"]) {
				pos_list = bg[Number(this.select_layer)]["pos"]
			}
			if (!this.cur_layer_boss_info_list) { return }
			for (let index in this.cur_layer_boss_info_list) {
				let info = this.cur_layer_boss_info_list[index]
				let parent = this["_Group" + Number(Number(index) + 1)]
				let boss_item = this.cur_layer_boss_list[index]
				if (!boss_item) {
					boss_item = new BossSuitItem(parent)
					boss_item.Load()
					let func = (e?) => {
						let _index = e.index
						if (_index == this.select_index) {
							return
						}
						e.SetSelect(true)
						this.cur_layer_boss_list[this.select_index].SetSelect(false)
						this.SwitchView(_index)
						this.select_index = _index
						//let group = this.cur_layer_boss_list[_index].trans_gp_boss_icon
						//Laya.Tween.get(group):to({scaleX=0.85, scaleY=0.85}, 50, Laya.Ease.circIn):to({scaleX=1, scaleY=1}, 100, Laya.Ease.circOut).call(() => {
						//Laya.Tween.removeTweens(group)
						//}
						//)
					}
					boss_item.setFun(2, func, index)
					table.insert(this.cur_layer_boss_list, boss_item)
					//AddClickEvent(boss_item.transform.gameObject,(e?) => {
					//let _index = e.cur_index
					//if (_index == this.select_index ) {
					//return
					//}
					//item:SetSelect(true)
					//this.cur_layer_boss_list[this.select_index].SetSelect(false)
					//this:SwitchView(_index)
					//this.select_index = _index
					//let group = this.cur_layer_boss_list[_index].trans_gp_boss_icon
					////Laya.Tween.get(group):to({scaleX=0.85, scaleY=0.85}, 50, Laya.Ease.circIn):to({scaleX=1, scaleY=1}, 100, Laya.Ease.circOut).call(() => {
					////Laya.Tween.removeTweens(group)
					////}
					////)
					//},this,true)
				}
				if (pos_list) {
					let pos = pos_list[index]
					SetAnchoredPosition(parent, pos.x, pos.y)
				}
				boss_item.ExcuteCallback(() => {
					boss_item.SetData(info)
					if (this.select_index == index) {
						this.select_boss_id = info.boss_id
						boss_item.SetSelect(true)
					} else {
						boss_item.SetSelect(false)
					}
					boss_item.visible = true
				}
				)
			}
		}

		this.SetDefultSelect = () => {
			this.boss_info = this.model.GetBossTypeInfo(BossModel.BossType.suit)
			if (this.boss_info) {
				this.LayerInfo()
				this.all_layers = Util.TableSize(this.layer_info)
				this.CreateRadionBtn()
				// if (this.select_boss_id) {
				// 	//let boss_info = this.boss_info.boss_info
				// 	for (let index in this.layer_info) {
				// 		for (let i in this.layer_info[index]) {
				// 			if (this.layer_info[index][i].boss_id == this.select_boss_id) {
				// 				this.select_layer = this.layer_info[index][i].layer - 1
				// 				this.select_index = i
				// 			}
				// 		}
				// 	}
				// } else {
				for (let index in this.layer_info) {
					let info = this.layer_info[index]
					if (this.role_lv >= info[0].open_lv) {
						this.select_layer = info[0].layer - 1
						this.select_index = 0
						this.select_boss_id = info[0].boss_id
					}
				}
				// }
				if (!this.select_layer) {
					this.select_index = 0
					this.select_layer = 0
					this.select_boss_id = 0
				}
				this.radioBtn.SetSelectIndex(this.select_layer)
				this.UpdateLayerMapView()
				this.SwitchView(this.select_index)
				this.UpdateTicket()
			}
		}

		this.LayerInfo = () => {
			this.layer_info = {}
			for (let index in this.boss_info.boss_info) {
				let vo = this.boss_info.boss_info[index]
				if (vo.layer) {
					this.layer_info[vo.layer] = this.layer_info[vo.layer] || []
					table.insert(this.layer_info[vo.layer], vo)
				}
			}
			for (let index in this.layer_info) {
				let sort_func = (a?, b?) => {
					return a.boss_id < b.boss_id
				}
				table.sort(this.layer_info[index], sort_func)
			}
			this.getAttentionNum()
		}

		this.getAttentionNum = () => {
			BossModel.GetInstance().suitboss_attention_num = 0
			for (let index in this.boss_info.boss_info) {
				if (this.boss_info.boss_info[index].is_remind) {
					BossModel.GetInstance().suitboss_attention_num = BossModel.GetInstance().suitboss_attention_num + 1
				}
			}
		}

		this.ClearTime = () => {
			if (this.timer) {
				GlobalTimerQuest.CancelQuest(this.timer)
				this.timer = null
			}
		}

		this.SourceVipClick = (e?) => {
			if (e) {
				OpenFun.OpenFunHandler(Number(e))
			}
		}

		this.UpdateVipShow = () => {
			let show = false
			let main_role = RoleManager.GetInstance().GetMainRoleVo()
			let vip = main_role.vip_flag
			if (vip >= 4) {
				let svip = main_role.supreme_vip
				if (!svip) {
					show = true
				}
			}
			this.source_vip.visible = show
			this._gp_cost.y = show ? 9 : 30
		}
	}

	public DeleteMe() {
		this.ClearTime()
		if (this.cur_layer_boss_list.length > 0) {
			for (let index in this.cur_layer_boss_list) {
				//let group = this.cur_layer_boss_list[index]._gp_boss_icon
				//if (group ) {
				//Laya.Tween.removeTweens(group)
				//}
				this.cur_layer_boss_list[index].DeleteMe()
			}
		}
		if (this.radioBtn) {
			this.radioBtn.DeleteMe()
			this.radioBtn = null
		}
		this.source_vip.off(Laya.Event.LINK, this, this.SourceVipClick)
		this.clickTime = null
		super.DeleteMe()
	}

	_Group12: Laya.Box
	_img_bg: Laya.Image
	_img_map: Laya.Image
	_Scroller1: Laya.List
	_gp_bossitem: Laya.Box
	_Group1: Laya.Box
	_Group2: Laya.Box
	_Group3: Laya.Box
	_Group4: Laya.Box
	_Group5: Laya.Box
	_Group6: Laya.Box
	_Group7: Laya.Box
	_Group8: Laya.Box
	_Group9: Laya.Box
	_Group11: Laya.Box
	_lb_enter_num: Laya.HTMLDivElement
	_lb_people_num: Laya.HTMLDivElement
	_gp_cost: Laya.HBox
	_Group10: Laya.HBox
	_Label1: Laya.Label
	_lb_ticket: Laya.HTMLDivElement
	_img_ticket: Laya.Image
	source_vip: Laya.HTMLDivElement
	_img_left: Laya.Image
	_img_right: Laya.Image
	_btn_go: Laya.Box
	_Image1: Laya.Image
	labelDisplay: Laya.Label
	public GetComponents() {
		[
			this._Group12,
			this._img_bg,
			this._img_map,
			this._Scroller1,
			this._gp_bossitem,
			this._Group1,
			this._Group2,
			this._Group3,
			this._Group4,
			this._Group5,
			this._Group6,
			this._Group7,
			this._Group8,
			this._Group9,
			this._Group11,
			this._lb_enter_num,
			this._lb_people_num,
			this._gp_cost,
			this._Group10,
			this._Label1,
			this._lb_ticket,
			this._img_ticket,
			this.source_vip,
			this._img_left,
			this._img_right,
			this._btn_go,
			this._Image1,
			this.labelDisplay,
		]
			= this.GetChildrenByNames([

				"_Group12",
				"_img_bg",
				"_img_map",
				"_Scroller1",
				"_gp_bossitem",
				"_Group1",
				"_Group2",
				"_Group3",
				"_Group4",
				"_Group5",
				"_Group6",
				"_Group7",
				"_Group8",
				"_Group9",
				"_Group11",
				"_lb_enter_num",
				"_lb_people_num",
				"_gp_cost",
				"_Group10",
				"_Label1",
				"_lb_ticket",
				"_img_ticket",
				"source_vip",
				"_img_left",
				"_img_right",
				"_btn_go",
				"_Image1",
				"labelDisplay",
			])
	}
}
window["BossSuitRoomItem"] = BossSuitRoomItem
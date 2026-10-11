import { BaseItem1 } from "../common/BaseItem1"
import { table } from "../common/table"
import { Util, SetLocalPositionY, GetSizeDeltaY, RefBoxChildsLayout } from "../util/Util"
import { Config } from "../common/Config"
import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { Message } from "../sysInfo/SysInfoController"
import { ErlangParser } from "../util/ErlangParser"
import { EquipModel } from "../commonModel/EquipModel"
import { RoleManager } from "../commonModel/RoleManager"
import { OpenFun } from "../common/OpenFun"
import { TimeUtil } from "../util/TimeUtil"
import { MatViewType } from "../commonModel/CompositeModel"
import { Alert, Alert_Type } from "../alert/Alert"
import { RedEnterView } from "./RedEnterView"
import { SYTweenLite } from "../util/SYTweenLite"
import { CompositeModel, CompositeEvent } from "../commonModel/CompositeModel"
import { CongratulationObtainView } from "../common/CongratulationObtainView"
import { UIVerTabBar } from "../newgameui/UIVerTabBar"
import { EquipmentItem } from "../common/EquipmentItem"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { LoopScrowViewMgr, LoopScrCon } from "../common/LoopScrowViewMgr"
import { UIVerTabBtn } from "../newgameui/UIVerTabBtn"
import { UIVerTabBtn2 } from "../newgameui/UIVerTabBtn2"
import { CommonRuleView } from "../common/CommonRuleView"
import { CompositeRingItem } from "./CompositeRingItem"
import { RingCompositeItem } from "./RingCompositeItem"
import { SoundManager } from "../common/SoundManager"
import { RuneTreasureModel } from "../commonModel/RuneTreasureModel"
import { ActivityIconManager } from "../commonModel/ActivityIconManager"
import { GameResPath } from "../util/GameResPath"
import { PlatformManager } from "../PlatformManager"

export class RingCompositeView extends BaseItem1 {
	AddCompositeEffect
	CheckNeedEnough
	Clear
	ClearCompositeEffect
	CompositeFailAni
	CreateLeftUITab
	CreateMatItems
	InitEvent
	InitmanuConfig
	LoadSuccess
	LocalDeleteMe
	LocalVisibleFunc
	ReOpen_callback
	SetMatData
	SetTabButtom
	SetTargetProperty
	ShowRuleView
	UpdateRedDot
	UpdateSuccessRatio
	UpdateView

	deleteData
	initView
	itemTouchHandler
	loadme
	round_bg
	selectIndex
	setRingItem
	setRingItemRed
	tabBar
	top_bg
	tween_id
	waitid

	res_mgr
	cfg_rule

	public constructor(parent?) {
		super(parent)
		this.base_file = "composite"
		this.layout_file = "RingCompositeView"
		this.preload_server_config = {
			"config_compose_menu": false,
			"config_compose_menu_id": false,
			"config_goods_compose": false
		}
		this.preload_client_config = {
			"ClientRuleViewConfig": false
		}

		this.res_mgr = ResManager.GetInstance()
		let local_comModel = CompositeModel
		let local_comModelIns = local_comModel.GetInstance()
		let local_gModel = GoodsModel
		let local_gModelIns = local_gModel.GetInstance()
		let local_comEvent = CompositeEvent
		let local_msg = Message
		let local_erlang = ErlangParser.GetInstance()
		let local_timeUtil = TimeUtil
		let local_equipModel = EquipModel.GetInstance()
		let local_openFunc = OpenFun
		let _item_arrayCollection_ = null
		let mat_item_list_ = null
		//let index_to_type_list_ = ["1", "2", "3", "4", "5"]
		let goodsid_to_index_ = []
		let compManu_cfg_ = null
		let compManuName_cfg_ = null
		let comp_equip_rule_cfg_ = null
		let loadme_finish_ = null
		let default_index_ = null
		let sub_select_id_ = null
		let sub_id_list_ = null
		let sub_index_default_ = 0
		let regular_mat_cfg_ = null
		let irregular_mat_cfg_ = null
		let rule_id_ = null
		let comp_equip_id_ = null
		//let cur_compEquip_rule_ = null
		let success_probability_list_ = null
		let success_radio_ = null
		let success_type_ = null
		let hole_list_ = null
		let target_item_ = null
		let cur_com_id_ = null
		let cfgList_
		let dataList
		let tabIndexToId_ = []
		let cur_tab_index_ = null
		let type_ = MatViewType.RING
		let clcikTime_ = null

		this.load_callback = () => {
			if (PlatformManager.IsEyouEnPlatform()) {
				this._Label2.pos(1,-9)
				this._Label2.width = 217
				this._Label2.height = 60
				this._Label2.wordWrap = true
			}else if (PlatformManager.IsEyouThPlatform()) {
				this._Label2.pos(-42,0)
			}
			this.LoadSuccess()
		}

		this.InitEvent = () => {
			let OnOneKeyAddClick = () => {
				local_comModelIns.Fire(local_comModel.COLSE_CHOSE_EQUIPMENT_VIEW)
				//let list = local_comModelIns.GetRingCompositeList(irregular_mat_cfg_, local_comModelIns.selected_ring_list, local_comModelIns.ring_mat_list)
				if (!cur_com_id_) {
					local_msg.show("未解锁装备")
					return
				}
				let index = 0
				let not_enough = false
				let i = 0
				do {
					if (Number(hole_list_[i]) == 1) {
						if (!local_comModelIns.ring_mat_list[i]) {
							let regular_data = regular_mat_cfg_[index]
							if (regular_data) {
								let type_id_list = []
								for (let _tmpi in regular_data) {
									let vo = regular_data[_tmpi]
									table.insert(type_id_list, vo[1])
								}
								if (regular_data.length == 1) {
									let type_id = regular_data[0][1]
									let goodsbasic = local_gModelIns.GetGoodsBasicByTypeId(type_id)
									if (goodsbasic && goodsbasic.type != 10) {
										break
									}
								}
								let mat_list = local_comModelIns.GetRingCompositeList(type_id_list, local_comModelIns.selected_ring_list, local_comModelIns.ring_mat_list)
								if (mat_list) {
									let goodsVo = mat_list[0]
									if (goodsVo) {
										local_comModelIns.ring_mat_list[i] = goodsVo.goods_id
										local_comModelIns.Fire(local_comEvent.SELECT_RING_GOODS, i, goodsVo, type_)
									} else {
										not_enough = true
									}
								}
							}
						}
						index = index + 1
					}
					i = i + 1
				} while ((i < hole_list_.length))
				let irregular_index = 0
				i = 0
				do {
					if (Number(hole_list_[i]) == 2) {
						if (!local_comModelIns.selected_ring_list[i]) {
							let regular_data = irregular_mat_cfg_[irregular_index]
							if (regular_data) {
								let type_id_list = []
								for (let _tmpi in regular_data) {
									let vo = regular_data[_tmpi]
									table.insert(type_id_list, vo)
								}
								let mat_list = local_comModelIns.GetRingCompositeList(type_id_list, local_comModelIns.selected_ring_list, local_comModelIns.ring_mat_list)
								let goodsVo = mat_list[0]
								if (goodsVo) {
									local_comModelIns.selected_ring_list[i] = goodsVo.goods_id
									local_comModelIns.Fire(local_comEvent.SELECT_RING_GOODS, i, goodsVo, type_)
								} else {
									not_enough = true
								}
							}
						}
						irregular_index = irregular_index + 1
					}
					i = i + 1
				} while ((i < hole_list_.length))
				if (not_enough) {
					local_msg.show("没有满足要求的装备~")
					return
				}
			}
			Util.AddClickEvent(this.btnOneKeyAdd, OnOneKeyAddClick, this, true)

			Util.AddClickEvent(this.btnComposite, () => {
				local_comModelIns.Fire(local_comModel.COLSE_CHOSE_EQUIPMENT_VIEW)
				if (success_radio_ == 0) {
					local_msg.show("材料不足，无法合成")
					return
				}
				if (clcikTime_ && local_timeUtil.getServerTimeMs() - clcikTime_ < 800) {
					return
				}
				clcikTime_ = local_timeUtil.getServerTimeMs()
				let isBind = false
				let regular_list = []
				for (let index in local_comModelIns.selected_ring_list) {
					let goods_id = local_comModelIns.selected_ring_list[index]
					if (goods_id) {
						table.insert(regular_list, goods_id)
						if (!isBind) {
							let goodVo = local_gModelIns.GetGoodsVoByGoodsId(goods_id)
							if (!goodVo) {
								let equipList = local_equipModel.GetWearEquipInfos()
								for (let key in equipList) {
									let equip = equipList[key]
									if (equip.goods_id == goods_id) {
										goodVo = equip
										break
									}
								}
							}
							if (goodVo && goodVo.bind && goodVo.bind != 0) {
								isBind = true
							}
						}
					}
				}
				let irregular_list = []
				for (let index in local_comModelIns.ring_mat_list) {
					let goods_id = local_comModelIns.ring_mat_list[index]
					if (goods_id) {
						let goodVo = local_gModelIns.GetGoodsVoByGoodsId(goods_id)
						if (!goodVo) {
							let equipList = local_equipModel.GetWearEquipInfos()
							for (let key in equipList) {
								let equip = equipList[key]
								if (equip.goods_id == goods_id) {
									goodVo = equip
									break
								}
							}
						}
						let needCount = 0
						if (goodVo) {
							needCount = Number(local_comModelIns.compEquip_regular_glist[goodVo.type_id])
						}
						if (goodVo && needCount) {
							if (goodVo.goods_num >= needCount) {
								let i = 0
								do {
									table.insert(irregular_list, goods_id)
									i = i + 1
								} while ((i < needCount))
							} else {
								let goodsList = local_gModelIns.GetTypeGoods(goodVo.type_id)
								for (let _tmpi in goodsList) {
									let goodsVo = goodsList[_tmpi]
									let i = 0
									do {
										table.insert(irregular_list, goodsVo.goods_id)
										i = i + 1; needCount = needCount - 1
									} while ((i < goodsVo.goods_num && needCount > 0))
									if (needCount <= 0) {
										break
									}
								}
							}
							local_comModelIns.compEquip_regular_glist[goodVo.type_id] = false
						} else {
							table.insert(irregular_list, goods_id)
							if (!isBind) {
								if (goodVo && goodVo.bind && goodVo.bind != 0) {
									isBind = true
								}
							}
						}
					}
				}
				let okFunc = () => {
					this.AddCompositeEffect(() => {
						local_comModelIns.Fire(local_comEvent.REQUEST_PROTO, rule_id_, irregular_list, regular_list)
					}
					)
				}

				if (isBind) {
					Alert.Show("当前合成材料中存在绑定的材料，合成后的装备也将是绑定的，是否确认进行合成？", Alert_Type.Two, okFunc)
				} else {
					okFunc()
				}
			}
				, this, true)

			Util.AddClickEvent(this._icon, () => {
					local_openFunc.OpenFunHandler(92, 0)
			}, this, true)
			Util.AddClickEvent(this._icon_df, () => {
				local_openFunc.OpenFunHandler(92, 2)
			}, this, true)

			Util.AddClickEvent(this._icon_zz, () => {
				local_openFunc.OpenFunHandler(92, 3)
			}, this, true)

			Util.AddClickEvent(this._state_icon, () => {
				this.ShowRuleView()
			}, this, true)

			//this._item_list.addEventListener(Laya.ItemTapEvent.ITEM_TAP, this.itemTouchHandler, this)
			this.BindEvent(local_comModelIns, local_comEvent.COMPOSE_SUCCESS, (rule_id?, goods_id?) => {
				if ((local_comModelIns.selectViewIndex != RedEnterView.Index.Ring && type_ == MatViewType.RING) || (local_comModelIns.selectViewIndex != RedEnterView.Index.Ring_Upgrade && type_ == MatViewType.RINGUP)) {
					local_comModelIns.ring_mat_list = {}
					local_comModelIns.selected_ring_list = {}
					this.setRingItem()
					this.SetTabButtom()
					return
				}
				let c = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_goods_compose.name, rule_id, false)
				if (c && c.type == 9) {
					local_comModelIns.selected_ring_list = {}
					local_comModelIns.ring_mat_list = {}
					this.setRingItem()
					this.SetTabButtom()
					let com_cfg = c
					if (com_cfg) {
						let com_id = local_erlang.Parse(com_cfg.goods)
						let com = [0, com_id[0][1], 1, goods_id]
						let success_view = new CongratulationObtainView([com], 10)
						success_view.Open()
					}
				}
			})

			this.BindEvent(local_comModelIns, local_comEvent.COMPOSE_Fail, () => {
				if ((local_comModelIns.selectViewIndex != RedEnterView.Index.Ring && type_ == MatViewType.RING) || (local_comModelIns.selectViewIndex != RedEnterView.Index.Ring_Upgrade && type_ == MatViewType.RINGUP)) {
					return
				}
				SoundManager.GetInstance().PlaySoundEffect("guildboss")
				this.AddUIEffect("effect_hechengshibai", this._gp_effect, null, 2, null, 2, null, null, null, null, null, null, false)
				//this.CompositeFailAni()
			})

			let OnSelectMatItem = (index?, parms?, type?) => {
				if (type != type_) {
					return
				}
				let item = mat_item_list_[index]
				if (item) {
					item.SetEquipData(parms)
					goodsid_to_index_[parms.goods_id] = index
				}
				this.UpdateSuccessRatio()
			}
			this.BindEvent(local_comModelIns, local_comEvent.SELECT_RING_GOODS, OnSelectMatItem)

			let OnUninstallEquip = (goods_id?) => {
				let index = goodsid_to_index_[goods_id]
				let item = mat_item_list_[index]
				if (item) {
					item.ReSetItem()
					if (local_comModelIns.selected_ring_list[index]) {
						delete local_comModelIns.selected_ring_list[index]
					} else if (local_comModelIns.ring_mat_list[index]) {
						delete local_comModelIns.ring_mat_list[index]
					}
				}
				goodsid_to_index_[goods_id] = null
				this.UpdateSuccessRatio()
			}
			this.BindEvent(local_comModelIns, local_comModel.UNINSTALL_EQUIP, OnUninstallEquip)

			let OnLevelChange = () => {
				this.CreateLeftUITab()
				this.setRingItem(false)
				this.SetTabButtom()
			}
			this.BindVar(RoleManager.GetInstance().GetMainRoleVo(), EventName.CHANGE_LEVEL, OnLevelChange)

			let OnRatioChange = () => {
				this.UpdateSuccessRatio()
			}
			this.BindEvent(local_comModelIns, local_comModel.UPDATA_SUCCESS_RATIO, OnRatioChange)

			let update_red = () => {
				if (this.use_delete_method) {
					return
				}
				this.setRingItem(false)
				this.UpdateRedDot()
				this.UpdateSuccessRatio()
				local_comModelIns.RingReddot(compManu_cfg_, compManuName_cfg_)
			}
			this.BindEvent(local_gModelIns, local_gModel.CHANGE_BAG_LIST, update_red)
		}

		this.LocalDeleteMe = () => {
			if (mat_item_list_) {
				for (let key in mat_item_list_) {
					mat_item_list_[key].DeleteMe()
					mat_item_list_[key] = null
				}
			}
			mat_item_list_ = null
			if (this.tabBar) {
				this.tabBar.DeleteMe()
				this.tabBar = null
			}
			if (target_item_) {
				target_item_.DeleteMe()
				target_item_ = null
			}
			if (this.com_fail) {
				SYTweenLite.Stop(this.com_fail)
				this.com_fail = null
			}
			this.ClearCompositeEffect()

			if (this.tween_id) {
				SYTweenLite.Stop(this.tween_id)
				this.tween_id = null
			}
			if (this.waitid) {
				clearTimeout(this.waitid)
				this.waitid = null
			}
			//this._item_list.removeEventListener(Laya.ItemTapEvent.ITEM_TAP, this.itemTouchHandler, this)

			this.ClearUIEffect(this._gp_bg_effect1)
			this.ClearUIEffect(this._gp_bg_effect2)
			this.ClearUIEffect(this._gp_bg_effect3)
			if (_item_arrayCollection_) {
				_item_arrayCollection_.DeleteMe()
				_item_arrayCollection_ = null
			}
			this.deleteData()
			local_comModelIns.need_goods_list = []
			local_comModelIns.ring_one_key_red_list = []
			compManu_cfg_ = null
			compManuName_cfg_ = null
			comp_equip_rule_cfg_ = null
		}

		this.LoadSuccess = () => {
			compManu_cfg_ = this.res_mgr.GetGameConfigFromCache(this, "config_compose_menu", false)
			compManuName_cfg_ = this.res_mgr.GetGameConfigFromCache(this, "config_compose_menu_id", false)
			comp_equip_rule_cfg_ = this.res_mgr.GetGameConfigFromCache(this, "config_goods_compose", false)
			this.cfg_rule = this.res_mgr.GetGameConfigFromCache(this, "ClientRuleViewConfig", true)

			this.res_mgr.SetOutsideImageSprite(this, this.mid_bg, "resource/game/composite/other/ui_merge_09.png")

			this._Scroller1.scrollBar.visible = false
			this.initView()
			//夺宝图标
			// if(ActivityIconManager.GetInstance().getIconInfo(416)){
			// 	let treasureModel = RuneTreasureModel.GetInstance()
			// 	let max = 0
			// 	for (let key in treasureModel.luckey) {
			// 		if (treasureModel.luckey[key].luckey_value > max) {
			// 			max = treasureModel.luckey[key].luckey_value
			// 		}
			// 	}
			// 	if (max < 500 && max >= 400) {
			// 		ResManager.GetInstance().SetImageSprite(this,this._icon,"icon","416_1")
			// 	} else if (max >= 500) {
			// 		ResManager.GetInstance().SetImageSprite(this,this._icon,"icon","416_2")
			// 	} else {
			// 		ResManager.GetInstance().SetImageSprite(this,this._icon,"icon","416")
			// 	}
			// }else{
			// 	ResManager.GetInstance().SetImageSprite(this,this._icon,"icon","416")
			// }
			let role_lv =RoleManager.GetInstance().GetMainRoleLevel()
			this._icon_df.visible = false
			this._icon_zz.visible = role_lv>=RuneTreasureModel.EXTREME_TREASURE_OPEN_LV
			RefBoxChildsLayout(this._box_icons,10,70,true,"left")
		}

		this.loadme = () => {
			loadme_finish_ = true
			this.initView()
		}

		this.initView = () => {
			if (loadme_finish_ && this.is_loaded) {
				if (!default_index_) {
					default_index_ = []
				}
				//this:AddUIEffect2("ui_synthesize_striation1", this._gp_bg_effect1, null, null, true)
				//this:AddUIEffect2("ui_synthesize_striation1", this._gp_bg_effect2, null, null, true)
				//this:AddUIEffect2("ui_synthesize_striation1", this._gp_bg_effect3, null, null, true)
				//this:AddUIEffect2("ui_synthesize_striation3", this._gp_reward_effect, null, null, true)
				//this:AddUIEffect("UI_1703","UI" ,this._gp_bg_effect1, null,null,true)
				//let curr_sorting_order = this.AddCurrLayerSortingOrder("UI")
				//this:CoverMode(this._Group5, "UI", curr_sorting_order)
				//this:CoverMode(this._Group6, "UI", curr_sorting_order)
				//this:CoverMode(this.mat_group, "UI", curr_sorting_order)

				this.CreateLeftUITab()
				this.SetTabButtom()
				this.CreateMatItems()
				if (this.tabBar) {
					if (default_index_.length > 0) {
						this.tabBar.SetSelectTab(default_index_[0], default_index_[1])
						sub_select_id_ = Number(sub_id_list_[default_index_[0]][default_index_[1]])
					} else {
						this.tabBar.SetSelectTab(0, sub_index_default_)
						sub_select_id_ = Number(sub_id_list_[0][sub_index_default_])
					}
					//this.tab_group.validateNow()
				}
				this.InitmanuConfig()
				this.setRingItem()
				this.InitEvent()
			}
		}

		this.InitmanuConfig = () => {
			//if (local_comModelIns.composite_manu_cfg ) {
			let manuConfig = compManu_cfg_[local_comModel.RingComposeRuleRule]
			if (manuConfig) {
				tabIndexToId_ = local_erlang.Parse(manuConfig.list)
			}
			//}
		}

		this.ShowRuleView = () => {
			let ruleConfig = this.cfg_rule
			if (ruleConfig) {
				let ShowConfig = ruleConfig["com" + tabIndexToId_[cur_tab_index_]]
				if (ShowConfig) {
					let ruleView = new CommonRuleView()
					ruleView.Open(ShowConfig["content"])
					ruleView.SetTitle(ShowConfig["title"])
				}
			}
		}

		this.CreateMatItems = () => {
			if (!mat_item_list_) {
				mat_item_list_ = []
			}
			let i = 0
			do {
				let mat = this["mat_pos_" + i]
				let item = new CompositeRingItem(mat)
				item.SetType(i, type_)
				item.Load()
				mat_item_list_[i] = item
				i = i + 1
			} while ((i < 3))
		}

		this.SetTabButtom = () => {
			let list = local_comModelIns.GetRingSubRedDot(compManu_cfg_)
			let i = 0
			if (i < list.length) {
				do {
					this.tabBar.setTabRedDot(i, false)
					let j = 0
					if (list[i] && (j < list[i].length)) {
						do {
							let show = list[i][j]
							if (show[0]) {
								default_index_[0] = i
								default_index_[1] = j
								this.tabBar.setTabRedDot(i, true)
								this.tabBar.setSubTabRedDot(i, j, true)
							} else {
								this.tabBar.setSubTabRedDot(i, j, false)
							}
							j = j + 1
						} while ((j < list[i].length))
					}
					i = i + 1
				} while ((i < list.length))
			}
		}

		this.CreateLeftUITab = () => {
			let list = local_comModelIns.GetTabBarData(compManu_cfg_, compManuName_cfg_, local_comModel.RingComposeRuleRule)
			if (!list || list[0].length == 0) {
				return
			}
			if (!this.tabBar) {
				this.tabBar = new UIVerTabBar(this.tab_scroller)
				this.tabBar.Load()
			}
			let call_fun = (tab_index?, sub_index?) => {
				if (sub_id_list_ && sub_id_list_[tab_index]) {
					cur_tab_index_ = tab_index
					sub_select_id_ = Number(sub_id_list_[tab_index][sub_index])
					this.deleteData()
					this.setRingItem()
				}
			}

			sub_id_list_ = list[0]
			let iconList = (list[2] && (list[2]) || (null))
			if (sub_id_list_.length > 0) {
				this.tabBar.SetTabBar(list[1], call_fun, GetSizeDeltaY(this.tab_scroller), null, UIVerTabBtn, iconList, GetSizeDeltaY(this.tab_scroller))
			}
		}

		this.UpdateRedDot = () => {
			this.SetTabButtom()
			this.setRingItemRed()
		}

		this.UpdateView = (cfg?) => {
			if (cfg) {
				rule_id_ = cfg.id
				let goods_cfg = local_erlang.Parse(cfg.goods)
				if (goods_cfg) {
					comp_equip_id_ = goods_cfg[0][1]
					this.SetTargetProperty(comp_equip_id_)
					this.SetMatData(cfg)
					success_type_ = cfg.ratio_type
					if (type_ == MatViewType.RING) {
						success_probability_list_ = local_erlang.Parse(cfg.ratio)[0]
					} else if (type_ == MatViewType.RINGUP) {
						success_probability_list_ = local_erlang.Parse(cfg.ratio)
					}
					this.UpdateSuccessRatio()
					this.one_key_add_red.visible = local_comModelIns.ring_one_key_red_list[_item_arrayCollection_.parent.selectedIndex]
				}
			}
		}

		this.SetMatData = (cfg?) => {
			if (!cfg) {
				return
			}
			hole_list_ = local_erlang.Parse(cfg.hole_list)
			regular_mat_cfg_ = local_erlang.Parse(cfg.regular_mat)
			irregular_mat_cfg_ = local_erlang.Parse(cfg.irregular_mat)
			if (hole_list_) {
				if (!mat_item_list_) {
					mat_item_list_ = []
				}
				let index = 0
				let regular_index = 0
				let irregular_index = 0
				let i = 0
				do {
					let mat_item = mat_item_list_[i]
					if (mat_item) {
						let parms = null
						if ((Number(hole_list_[i]) == 1 && regular_mat_cfg_) && regular_mat_cfg_[regular_index]) {
							parms = regular_mat_cfg_[regular_index]
							regular_index = regular_index + 1
						} else if ((Number(hole_list_[i] == 2) && irregular_mat_cfg_) && irregular_mat_cfg_[irregular_index]) {
							parms = irregular_mat_cfg_[irregular_index]
							irregular_index = irregular_index + 1
						}
						mat_item.InitMatData(Number(hole_list_[i]), parms, type_)
						index = index + 1
					}
					i = i + 1
				} while ((i < 3))
			}
		}

		this.SetTargetProperty = (type_id?) => {
			if (type_id) {
				if (!target_item_) {
					target_item_ = new EquipmentItem(this.award_group)
					target_item_.Load()
					target_item_.SetItemSize(85, 85)
				}
				target_item_.SetClickCallBack(() => {
					UIToolTipMgr.GetInstance().AppendEquipTips(type_id)
				}
				)
				target_item_.SetData(type_id)
			}
		}

		this.CheckNeedEnough = (cost_list?) => {
			if (!cost_list) {
				return false
			}
			for (let _tmpi in cost_list) {
				let info = cost_list[_tmpi]
				let needTypeId = Number(info[0][1])
				let own = local_gModelIns.GetTypeGoodsNum(needTypeId)
				let equipList = local_equipModel.GetWearEquipInfos()
				let count = 0
				for (let key in equipList) {
					let equip = equipList[key]
					if (equip.type_id == needTypeId) {
						count = count + 1
						break
					}
				}
				if ((own + count) < Number(info[0][2])) {
					return false
				}
			}
			return true
		}

		this.UpdateSuccessRatio = () => {
			let goods_count = Util.TableSize(local_comModelIns.selected_ring_list)
			if (success_type_ == 1) {
				success_radio_ = 0
				let cfg = regular_mat_cfg_
				if (cfg) {
					if (Util.TableSize(local_comModelIns.ring_mat_list) < cfg.length || (Util.TableSize(local_comModelIns.ring_mat_list) == cfg.length && !this.CheckNeedEnough(cfg))) {
						this.success_label.text = success_radio_ + "%"
						this.composite_red.visible = false
						this.one_key_add_red.visible = local_comModelIns.ring_one_key_red_list[_item_arrayCollection_.parent.selectedIndex]
						return
					}
				}
				success_radio_ = Number(success_probability_list_)
			} else if (success_type_ == 2) {
				if (success_probability_list_) {
					success_radio_ = 0
					let cfg = regular_mat_cfg_
					if (cfg) {
						if (Util.TableSize(local_comModelIns.ring_mat_list) < cfg.length || (Util.TableSize(local_comModelIns.ring_mat_list) == cfg.length && !this.CheckNeedEnough(cfg))) {
							this.success_label.text = success_radio_ + "%"
							this.composite_red.visible = false
							this.one_key_add_red.visible = local_comModelIns.ring_one_key_red_list[_item_arrayCollection_.parent.selectedIndex]
							return
						}
					}
					for (let _tmpi in success_probability_list_) {
						let vo = success_probability_list_[_tmpi]
						if (Number(vo[0]) == goods_count) {
							success_radio_ = Number(vo[1])
							break
						}
					}
				}
			}
			this.success_label.text = success_radio_ + "%"
			if (success_radio_ == 100) {
				this.composite_red.visible = true
				this.one_key_add_red.visible = false
			} else {
				this.composite_red.visible = false
			}
		}

		this.setRingItemRed = (needrefresh?) => {
			if (needrefresh == null) {
				needrefresh = true
			}
			local_comModelIns.need_goods_list = []
			local_comModelIns.ring_one_key_red_list = []
			let sub_id = sub_select_id_

			let conf = compManu_cfg_[sub_id]
			let confList = local_erlang.Parse(conf.list)
			let i = 0
			for (let key in confList) {
				let id = Number(confList[key])
				let cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_goods_compose.name, id, false, comp_equip_rule_cfg_)
				if (!cfg) {
					//SetImageGray(Image, true)
					local_comModelIns.ring_one_key_red_list[i] = false
				} else {
					//SetImageGray(Image, false)
					let can_com = local_comModelIns.RingCanComposite(cfg.id)
					//let regular_list = local_erlang.Parse(cfg.regular_mat)
					//for (let _tmpi in regular_list) {
					//let Vo = regular_list[_tmpi]
					//// [ts2lua]local_comModelIns.need_goods_list下标访问可能不正确
					//local_comModelIns.need_goods_list[Vo[1*/ = [Vo[1]]
					//}
					//let irregular_list = local_erlang.Parse(cfg.irregular_mat)
					//for (let _tmpi in irregular_list) {
					//Vo = irregular_list[_tmpi]
					//// [ts2lua]local_comModelIns.need_goods_list下标访问可能不正确
					//local_comModelIns.need_goods_list[Vo] = [Vo]
					//}
					if (can_com) {
						local_comModelIns.ring_one_key_red_list[i] = true
					} else {
						local_comModelIns.ring_one_key_red_list[i] = false
					}
				}
				i = i + 1
			}
			this.one_key_add_red.visible = local_comModelIns.ring_one_key_red_list[_item_arrayCollection_.parent.selectedIndexs]
			if (_item_arrayCollection_ && needrefresh) {
				//_item_arrayCollection_:refresh()
				_item_arrayCollection_.SetSelectIndex(this.selectIndex())
			}
		}

		this.setRingItem = (refresh?) => {
			if (refresh == null) {
				refresh = true
			}
			[cfgList_, dataList] = local_comModelIns.GetRingList(compManu_cfg_, sub_select_id_)
			if (dataList) {
				if (!_item_arrayCollection_) {
					_item_arrayCollection_ = new LoopScrowViewMgr()
					_item_arrayCollection_.SetData(this._Scroller1, RingCompositeItem, dataList, LoopScrCon.Horizontal, 1, this.itemTouchHandler)
				} else {
					_item_arrayCollection_.replaceAll(dataList)
				}
				//if (! _item_arrayCollection_ ) {
				//_item_arrayCollection_ = eui. new ArrayCollection(dataList)
				//this._item_list.dataProvider = _item_arrayCollection_
				//this._item_list.itemRenderer = RingCompositeItem
				//}else{
				//_item_arrayCollection_:replaceAll(dataList)
				//}

				this.setRingItemRed()
				let index = this.selectIndex()
				_item_arrayCollection_.SetSelectIndex(index)

				if (cfgList_.length > 0) {
					cur_com_id_ = cfgList_[index]
				}
				if (cur_com_id_) {
					if (refresh) {
						this.UpdateView(cur_com_id_)
					}
				} else {
					this.Clear()
				}
			}
		}

		this.itemTouchHandler = (index?) => {
			let data = dataList[index]
			let goods_cfg = null
			if (cur_com_id_) {
				goods_cfg = local_erlang.Parse(cur_com_id_.goods)
			}
			if (!goods_cfg || goods_cfg[0][1] == data[0][1]) {
				return
			}
			local_comModelIns.selected_ring_list = {}
			local_comModelIns.ring_mat_list = {}
			cur_com_id_ = cfgList_[index]
			if (cur_com_id_) {
				this.UpdateView(cur_com_id_)
			} else {
				this.Clear()
			}
		}

		this.Clear = () => {
			if (mat_item_list_) {
				for (let index in mat_item_list_) {
					let item = mat_item_list_[index]
					if (item) {
						item.InitMatData(3, null, type_)
					}
				}
			}
			if (target_item_) {
				target_item_.SetData(0)
				target_item_.ClearItemEffect()
			}
			this.one_key_add_red.visible = false
			this.composite_red.visible = false
			local_comModelIns.ring_one_key_red_list = []
		}

		this.AddCompositeEffect = (call_back?) => {
			call_back()
			/*
			this.AddUIEffect("UI_1704", "UI", this._gp_bg_effect2, null, null, false, {
				call_back_func = call_back,
				last_time = 1
			})
			*/

			//this:ClearCompositeEffect()
			//this:AddUIEffect2("ui_synthesize_framework", this._gp_framework)
			//this:AddUIEffect2("ui_synthesize_arrary1_1", this._gp_arrary1_1)
			//setTimeout(() => {
			//this:AddUIEffect2("ui_synthesize_arrary1", this._gp_arrary1, null, null, null, null, call_back)
			//}
			//, 0.2)
		}

		this.ClearCompositeEffect = () => {
			/*
			this.ClearUIEffect(this._gp_framework)
			this.ClearUIEffect(this._gp_arrary1_1)
			this.ClearUIEffect(this._gp_arrary1)
			*/
		}

		this.CompositeFailAni = () => {
			SetLocalPositionY(this.com_fail, 556)

			this.com_fail.visible = true
			this.com_fail.alpha = 1

			if (this.tween_id) {
				SYTweenLite.Stop(this.tween_id)
			}
			let delay_func = () => {
				if (this.com_fail) {
					this.com_fail.visible = false
				}
			}

			this.tween_id = SYTweenLite.to(this, this.com_fail, SYTweenLite.UiAnimationType.POSY, 450, 1, () => {
				this.waitid = setTimeout(() => {
					if (!this.use_delete_method) {
						this.tween_id = SYTweenLite.to(this, this.com_fail, SYTweenLite.UiAnimationType.ALPHA, 0, 0.8)
					}
				}, 200)
			})
		}

		this.deleteData = () => {
			local_comModelIns.selected_ring_list = {}
			local_comModelIns.ring_mat_list = {}
			if (type_ == MatViewType.RING) {
				local_comModelIns.selected_ring_list = {}
				local_comModelIns.ring_mat_list = {}
			} else if (type_ == MatViewType.RINGUP) {
				local_comModelIns.selected_ring_up_list = {}
				local_comModelIns.ring_up_mat_list = {}
			}
		}

		this.selectIndex = () => {
			let index = 0
			let find = false
			let count = 0
			for (let key in local_comModelIns.ring_one_key_red_list) {
				let red = local_comModelIns.ring_one_key_red_list[key]
				if (red) {
					find = true
					break
				}
				count = count + 1
			}
			if (find) {
				index = count
			}
			return index
		}

		this.LocalVisibleFunc = (bool?) => {
			local_comModelIns.Fire(local_comModel.COLSE_CHOSE_EQUIPMENT_VIEW)
			super.SetVisible(bool)
		}

		this.ReOpen_callback = () => {
			//this:AddUIEffect("UI_1703","UI" ,this._gp_bg_effect1, null,null,true)
			//let curr_sorting_order = this.AddCurrLayerSortingOrder("UI")

			//this:CoverMode(this._Group5, "UI", curr_sorting_order)
			//this:CoverMode(this._Group6, "UI", curr_sorting_order)
			//this:CoverMode(this.mat_group, "UI", curr_sorting_order)
		}
		this.loadme()
	}

	public SetVisible(bool?) {
		this.LocalVisibleFunc(bool)
	}

	public DeleteMe() {
		this.LocalDeleteMe()
		super.DeleteMe()
	}

	leftImage: Laya.Image
	bottom_image: Laya.Image
	mid_bg: Laya.Image
	_gp_bg_effect1: Laya.Box
	_gp_bg_effect2: Laya.Box
	_gp_bg_effect3: Laya.Box
	_Scroller1: Laya.List
	tab_scroller: Laya.Box
	_Group2: Laya.Box
	_Image2: Laya.Image
	_Group1: Laya.HBox
	_Label1: Laya.Label
	success_label: Laya.Label
	_Group3: Laya.Box
	_Image4: Laya.Image
	_lb_need: Laya.Label
	_state_icon: Laya.Image
	btnOneKeyAdd: Laya.Box
	_Image1: Laya.Image
	labelDisplay: Laya.Label
	one_key_add_red: Laya.Image
	btnComposite: Laya.Box
	_Image111: Laya.Image
	labelDisplay1: Laya.Label
	composite_red: Laya.Image
	_Image5: Laya.Image
	_Group4: Laya.Box
	_Label2: Laya.Label
_box_icons:Laya.Box
	_icon: Laya.Image
_icon_df:Laya.Image
_icon_zz:Laya.Image
	_Group5: Laya.Box
	_Image6: Laya.Image
	_Image7: Laya.Image
	_Image8: Laya.Image
	mat_group: Laya.Box
	mat_pos_0: Laya.Box
	mat_pos_1: Laya.Box
	mat_pos_2: Laya.Box
	_Group6: Laya.Image
	award_group: Laya.Box
	com_fail: Laya.Image
	_gp_effect: Laya.Box
	public GetComponents() {
		[
			this.leftImage,
			this.bottom_image,
			this.mid_bg,
			this._gp_bg_effect1,
			this._gp_bg_effect2,
			this._gp_bg_effect3,
			this._Scroller1,
			this.tab_scroller,
			this._Group2,
			this._Image2,
			this._Group1,
			this._Label1,
			this.success_label,
			this._Group3,
			this._Image4,
			this._lb_need,
			this._state_icon,
			this.btnOneKeyAdd,
			this._Image1,
			this.labelDisplay,
			this.one_key_add_red,
			this.btnComposite,
			this._Image111,
			this.labelDisplay1,
			this.composite_red,
			this._Image5,
			this._Group4,
			this._Label2,
this._box_icons,
			this._icon,
this._icon_df,
this._icon_zz,
			this._Group5,
			this._Image6,
			this._Image7,
			this._Image8,
			this.mat_group,
			this.mat_pos_0,
			this.mat_pos_1,
			this.mat_pos_2,
			this._Group6,
			this.award_group,
			this.com_fail,
			this._gp_effect,
		]
			= this.GetChildrenByNames([

				"leftImage",
				"bottom_image",
				"mid_bg",
				"_gp_bg_effect1",
				"_gp_bg_effect2",
				"_gp_bg_effect3",
				"_Scroller1",
				"tab_scroller",
				"_Group2",
				"_Image2",
				"_Group1",
				"_Label1",
				"success_label",
				"_Group3",
				"_Image4",
				"_lb_need",
				"_state_icon",
				"btnOneKeyAdd",
				"_Image1",
				"labelDisplay",
				"one_key_add_red",
				"btnComposite",
				"_Image111",
				"labelDisplay1",
				"composite_red",
				"_Image5",
				"_Group4",
				"_Label2",
"_box_icons",
				"_icon",
"_icon_df",
"_icon_zz",
				"_Group5",
				"_Image6",
				"_Image7",
				"_Image8",
				"mat_group",
				"mat_pos_0",
				"mat_pos_1",
				"mat_pos_2",
				"_Group6",
				"award_group",
				"com_fail",
				"_gp_effect",
			])
	}
}
window["RingCompositeView"] = RingCompositeView
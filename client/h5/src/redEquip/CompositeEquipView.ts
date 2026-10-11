import { BaseItem1 } from "../common/BaseItem1"
import { table } from "../common/table"
import { Util, SetSizeDeltaX, GetSizeDeltaY, SetLocalPositionY, SetHtmlStyle, SetHtmlCenter, PlayBigEffect } from "../util/Util"
import { Config } from "../common/Config"
import { Mathf } from "../util/Mathf"
import { EventName } from "../common/EventName"
import { RoleManager } from "../commonModel/RoleManager"
import { SYTweenLite } from "../util/SYTweenLite"
import { GoodsModel } from "../commonModel/GoodsModel"
import { EquipModel } from "../commonModel/EquipModel"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { WordManager } from "../common/WordManager"
import { Message } from "../sysInfo/SysInfoController"
import { Alert, Alert_Type } from "../alert/Alert"
import { ErlangParser } from "../util/ErlangParser"
import { ResManager } from "../common/ResManager"
import { UIVerTabBar } from "../newgameui/UIVerTabBar"
import { CongratulationObtainView } from "../common/CongratulationObtainView"
import { CompositeModel, CompositeEvent, MatViewType } from "../commonModel/CompositeModel"
import { EquipmentItem } from "../common/EquipmentItem"
import { CommonRuleView } from "../common/CommonRuleView"
import { CompositeEquipResolveView } from "./CompositeEquipResolveView"
import { CompositeEquipItem } from "./CompositeEquipItem"
import { DownDropBtn } from "../common/DownDropBtn"
import { EquipToolTipItem } from "../bag/EquipToolTipItem"
import { SoundManager } from "../common/SoundManager"

import "../composite/CompositeGetMatView"
import { TaskTipType } from "../commonModel/TaskModel"
import { ColorUtil } from "../util/ColorUtil"
import { PlatformManager } from "../PlatformManager"

export class CompositeEquipView extends BaseItem1 {
	AddCompositeEffect
	ChangeSuccessAudioStage
	Clear
	ClearCompositeEffect
	CompositeFailAni
	CreateLeftUITab
	CreateMatItems
	GetTabIndex
	InitEvent
	InitView
	LoadSuccess
	LocalDeleteMe
	ContrastEquipByGoodVo

	SelectDropBtn
	SelectEquipBtn
	SelectRadioBtn
	UpdateRadioBtn
	SetEquipBtnRed
	SetMatData
	SetOneKeyAddRed
	SetRadioBottom
	SetTabButtom
	SetTargetProperty
	ShowRuleView
	UpdateRedDot
	UpdateSuccessRatio
	UpdateView
	GetDafaultIndex

	btn_list
	btn_red_list
	dropBtn:DownDropBtn
	dropSelectIndex
	equip_select_index
	list
	outlinelist
	preload_client_config
	select_index
	tabBar: UIVerTabBar
	tab_id_to_index
	toggleGroup
	tween_id
	waitid
	res_mgr
	equip_model
	goods_model
	cfg_rule
	equipTool1
	equipTool2
	SortList
	SetTabInit
	public constructor(parent?) {
		super(parent)
		this.base_file = "composite"
		this.layout_file = "CompositeEquipView"
		this.preload_server_config = {
			"config_compose_menu": false,
			"config_compose_menu_id": false,
			"config_goods_compose": false
		}
		this.preload_client_config = {
			"ClientRuleViewConfig": false
		}

		this.res_mgr = ResManager.GetInstance()
		let local_mainRoleVo = RoleManager.GetInstance().GetMainRoleVo()
		let local_comModel = CompositeModel
		let local_comModelIns = local_comModel.GetInstance()
		let local_gModel = GoodsModel
		this.goods_model = GoodsModel.GetInstance()
		let local_gModelIns = local_gModel.GetInstance()
		let local_comEvent = CompositeEvent
		let local_msg = Message
		this.equip_model = EquipModel.GetInstance()

		let local_erlang = ErlangParser.GetInstance()
		let sub_index_default_ = 0
		let tab_index_default_ = 0
		let mat_item_list_ = null
		let compManu_cfg_ = null
		let compManuName_cfg_ = null
		let comp_equip_rule_cfg_ = null
		let regular_mat_cfg_ = null
		let irregular_mat_cfg_ = null
		let cur_tab_index_ = null
		let goodsid_to_index_ = {}
		let comp_equip_id_ = null
		let success_radio_ = null
		let one_key_red_list_ = []
		let target_item_ = null
		let sub_id_list_ = null
		let rule_id_ = null
		let default_index_arr = null
		let sub_select_id_ = null
		let sex_ = null
		let success_probability_list_ = null
		let success_type_ = null
		//let index_to_type_list_ = [1, 4, 7, 5, 2, 6, 8, 3]
		let index_to_type_list_ = [0, 3, 6, 4, 1, 5, 7, 2]
		let hole_list_ = null
		let cur_com_id_ = null
		let equip_resolve_view_ = null
		this.select_index = 0
		let supreme_vip = local_mainRoleVo.supreme_vip
		//装备选择
		this.equip_select_index = 1
		//this.preload_client_config = [ClientRuleViewConfig=false]

		this.load_callback = () => {
			if (PlatformManager.IsEyouEnPlatform()) {
				this.amterial_tip.pos(181,963)
				this.lb_title.width = 370
				this.lb_title.x = -39
				this._Label1.width = 370
				this._Label1.x = -2
				this._Label2.width = 200
				this._Label2.x = 350
				this._Label5.pos(10,26)
			}
			if (PlatformManager.IsEyouThPlatform()) {
				SetHtmlStyle(this.need_label, { w: 500, f: 18, c: "#00fa64", ww: false })
			}else{
			SetHtmlStyle(this.need_label, { w: 500, f: 22, c: "#00fa64", ww: false })
			}
			this.LoadSuccess()
		}

		this.LoadSuccess = () => {
			this.res_mgr.SetOutsideImageSprite(this, this.mid_bg, "resource/game/composite/other/ui_merge_01.png")

			compManu_cfg_ = this.res_mgr.GetGameConfigFromCache(this, "config_compose_menu", false)
			compManuName_cfg_ = this.res_mgr.GetGameConfigFromCache(this, "config_compose_menu_id", false)
			comp_equip_rule_cfg_ = this.res_mgr.GetGameConfigFromCache(this, "config_goods_compose", false)
			this.cfg_rule = this.res_mgr.GetGameConfigFromCache(this, "ClientRuleViewConfig", true)


			//this.btn_list = []
			this.btn_red_list = []
			this.list = []
			this.outlinelist = []
			if (RoleManager.GetInstance().GetMainRoleCareer() > 2) {
				this.equip_select_index = 2
			}


			let click_func = (target?) => {
				for (let i = 0; i < 8; i++) {
					if (this["rBtn_" + i] == target.currentTarget) {
						this.select_index = i
						if (i == 0) {
							this.equipBtnCon.visible = true
							this.SelectEquipBtn(this.equip_select_index)
						} else {
							this.equipBtnCon.visible = false
						}
						this.SelectRadioBtn()
						this.ClearCompositeEffect()
						local_comModelIns.Fire(local_comModel.COLSE_CHOSE_EQUIPMENT_VIEW)
						break
					}
				}
			}
			for (let i = 0; i < 8; i++) {
				let btn = this["rBtn_" + i]
				if (btn) {
					Util.AddClickEvent(btn, click_func, this, true)
				}

				let red = this["rBtn_red" + i]
				if (red) {
					this.btn_red_list[i] = red
				}
			}
			/*
			for (let i = 0; i <= 7; i++) {
				let objtoogle = this.btn_group.GetChild(i)
				if (objtoogle) {
					let temp_i = i
					let toggle = objtoogle.transform.GetComponent("Toggle")
					this.btn_list[i] = toggle
					toggle.onValueChanged.AddListener(() => {
						//SoundManager:GetInstance():PlaySoundEffect("2_dianji")
						if (toggle.isOn) {
							this.select_index = temp_i + 1
							this["textlabelDisplay" + (temp_i + 1)].color = ColorUtil.TryParseHtmlString("#ffffff")
							this["OutlabelDisplay" + (temp_i + 1].effectColor) = ColorUtil.TryParseHtmlString("#e1743a")
					if (this.select_index == 1) {
						this.equipBtnCon.visible = true
						this.SelectEquipBtn(this.equip_select_index)
					} else {
						this.equipBtnCon.visible = false
					}
					this.SelectRadioBtn()
					this.ClearCompositeEffect()
					local_comModelIns.Fire(local_comModel.COLSE_CHOSE_EQUIPMENT_VIEW)
				} else {
					this["textlabelDisplay" + (temp_i + 1].color) = ColorUtil.TryParseHtmlString("#e8d9d3")
					this["OutlabelDisplay" + (temp_i + 1].effectColor) = ColorUtil.TryParseHtmlString("#b38270")
				}
				})
				}
			}
			*/



			this.InitView()
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this.btnComposite, () => {

				if(!GoodsModel.GetInstance().CheckEquipNum(1)){
					return
				}

				local_comModelIns.Fire(local_comModel.COLSE_CHOSE_EQUIPMENT_VIEW)
				if (success_radio_ == 0) {
					//Message.show("材料不足，无法合成")
					local_comModelIns.Fire(local_comEvent.OPEN_VIEW, "CompositeGetMatView", "CompositeEquipView", cur_com_id_)
					return
				}
				let isBind = false
				let regular_list = []
				for (let index in local_comModelIns.selected_equip_list) {
					let goods_id = local_comModelIns.selected_equip_list[index]
					if (goods_id) {
						table.insert(regular_list, goods_id)
						if (!isBind) {
							let goodVo = local_gModelIns.GetGoodsVoByGoodsId(goods_id)
							if (goodVo && goodVo.bind != 0) {
								isBind = true
							}
						}
					}
				}
				let irregular_list = []
				for (let index in local_comModelIns.equipment_mat_list) {
					let goods_id = local_comModelIns.equipment_mat_list[index]
					if (goods_id) {
						let goodVo = local_gModelIns.GetGoodsVoByGoodsId(goods_id)
						let needCount
						if (goodVo) {
							needCount = Number(local_comModelIns.compEquip_regular_glist[goodVo.type_id])
							goodVo = local_gModelIns.GetUnBindGoodsVoFirstByTypeId(goodVo.type_id)
						}
						if (goodVo && needCount) {
							goods_id = goodVo.goods_id
							if (goodVo.goods_num >= needCount) {
								if ((!isBind && goodVo) && goodVo.bind != 0) {
									isBind = true
								}
								let i = 0
								if (i < needCount) {
									do {
										table.insert(irregular_list, goodVo.goods_id)
										i = i + 1
									} while ((i < needCount))
								}
							} else {
								let goodsList = local_gModelIns.GetTypeGoods(goodVo.type_id)
								table.sort(goodsList, (a?, b?) => {
									return b.bind > a.bind
								})
								for (let _tmpi in goodsList) {
									let goodsVo = goodsList[_tmpi]
									let i = 0
									do {
										table.insert(irregular_list, goodsVo.goods_id)
										i = i + 1
										needCount = needCount - 1
									} while ((i < goodsVo.goods_num && needCount > 0))
									if (!isBind && goodsVo.bind != 0) {
										isBind = true
									}
									if (needCount <= 0) {
										break
									}
								}
							}
						} else {
							table.insert(irregular_list, goods_id)
							if (!isBind) {
								if (goodVo && goodVo.bind != 0) {
									isBind = true
								}
							}
						}
					}
				}
				let okFunc = () => {
					this.AddCompositeEffect(() => {
						if (rule_id_) {
							local_comModelIns.Fire(local_comEvent.REQUEST_PROTO, rule_id_, irregular_list, regular_list)
						}
					}
					)
				}

				if (isBind) {
					Alert.Show("当前合成材料中存在绑定的材料，合成后的装备也将是绑定的，是否确认进行合成？", Alert_Type.Two, okFunc)
				} else {
					okFunc()
				}
			}, this, true)

			this.BindEvent(local_comModelIns, local_comEvent.COMPOSE_SUCCESS, (rule_id?, goods_id?) => {
				let comCfg = comp_equip_rule_cfg_
				let c = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_goods_compose.name, rule_id, false)
				if ((comCfg && c) && Number(c.type) == 2) {
					this.SelectRadioBtn()
					this.SetTabButtom()
					let goods_vo = this.goods_model.GetGoodsVoByGoodsId(goods_id)
					if(goods_vo){
						let style 
						if(goods_vo.bind){
							style = 100
						}else{
							style = 0
						}
						let reward_list = []
						reward_list.push([style, goods_vo.type_id, 1, goods_id])
						let success_view = new CongratulationObtainView(reward_list, 10)
						success_view.Open()
					}
				}
			})

			this.BindEvent(local_comModelIns, local_comEvent.COMPOSE_Fail, () => {
				SoundManager.GetInstance().PlaySoundEffect("guildboss")
				// this.AddUIEffect("effect_hechengshibai", this._gp_effect, null, 2, null, 2, null, null, null, null, null, null, false)
				PlayBigEffect("effect_hechengshibai", null, 2)
				this.SelectRadioBtn()
				this.SetTabButtom()
				//this.CompositeFailAni()
			})

			let OnSelectMatItem = (index?, parms?) => {
				if (!parms) {
					return
				}
				let item = mat_item_list_[index]
				if (item) {
					item.SetEquipData(parms)
					goodsid_to_index_[parms.goods_id] = index
				}
				this.UpdateSuccessRatio()
			}
			this.BindEvent(local_comModelIns, local_comEvent.SELECT_EQUIP_GOODS, OnSelectMatItem)

			let OnUninstallEquip = (goods_id?) => {
				let index = goodsid_to_index_[goods_id]
				let item = mat_item_list_[index]
				if (item) {
					item.ReSetItem()
					if (local_comModelIns.selected_equip_list[index] == goods_id) {
						delete local_comModelIns.selected_equip_list[index]
					} else if (local_comModelIns.equipment_mat_list[index] == goods_id) {
						delete local_comModelIns.equipment_mat_list[index]
					}
					delete goodsid_to_index_[goods_id]
					//goodsid_to_index_.splice(goods_id, 1)
				}
				this.UpdateSuccessRatio()
			}
			this.BindEvent(local_comModelIns, local_comModel.UNINSTALL_EQUIP, OnUninstallEquip)

			this.BindEvent(local_gModelIns, local_gModel.CHANGE_BAG_LIST, (list?) => {
				if (!this.use_delete_method && list && Util.TableSize(goodsid_to_index_) > 0) {
					for (let _ in list) {
						let v = list[_]
						if (goodsid_to_index_[v.goods_id]) {
							OnUninstallEquip(v.goods_id)
						}
					}
				}
				this.SetTabButtom()
			})

			this.BindEvent(local_gModelIns, local_gModel.CHANGE_EQUIPLIST, () => {
				if (!this.use_delete_method) {
					this.SetRadioBottom()
				}
			})

			let OnOneKeyAddClick = () => {
				local_comModelIns.Fire(local_comModel.COLSE_CHOSE_EQUIPMENT_VIEW)
				if (!cur_com_id_) {
					local_msg.show("未解锁装备")
					return
				}
				let index = 0
				let not_enough = false
				let i = 0
				do {
					if (Number(hole_list_[i]) == 1) {
						if (!local_comModelIns.equipment_mat_list[i]) {
							let regular_data = regular_mat_cfg_[i]
							if (regular_data) {
								if (regular_data.length == 1) {
									let type_id = regular_data[1][1]
									let goodsbasic = local_gModelIns.GetGoodsBasicByTypeId(type_id)
									if (goodsbasic && goodsbasic.type != 10) {
										break
									}
								}
								let type_id_list = []
								for (let _tmpi in regular_data) {
									let vo = regular_data[_tmpi]
									table.insert(type_id_list, vo[1])
								}
								let mat_list = local_comModelIns.GetEquipCompositeList(type_id_list, 1)
								let goodsVo = mat_list[1]
								if (goodsVo) {
									local_comModelIns.equipment_mat_list[i] = goodsVo.goods_id
									local_comModelIns.Fire(local_comEvent.SELECT_EQUIP_GOODS, i, goodsVo)
								} else {
									not_enough = true
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
						if (!local_comModelIns.selected_equip_list[i]) {
							let regular_data = irregular_mat_cfg_[irregular_index]
							if (regular_data) {
								let type_id_list = []
								for (let _tmpi in regular_data) {
									let vo = regular_data[_tmpi]
									table.insert(type_id_list, vo)
								}
								let mat_list = local_comModelIns.GetEquipCompositeList(type_id_list, 1)
								let goodsVo = mat_list[0]
								if (goodsVo) {
									local_comModelIns.selected_equip_list[i] = goodsVo.goods_id
									local_comModelIns.Fire(local_comEvent.SELECT_EQUIP_GOODS, i, goodsVo)
								} else {
									not_enough = true
								}
							}
						}
						irregular_index = irregular_index + 1
					}
					i = i + 1
				} while ((i < hole_list_.length))
				if (success_radio_ == 0) {
					local_comModelIns.Fire(local_comEvent.OPEN_VIEW, "CompositeGetMatView", "CompositeEquipView", cur_com_id_)
				}
				this.one_key_add_red.visible = false
			}
			Util.AddClickEvent(this.btnOneKeyAdd, OnOneKeyAddClick, this, true)

			let OnLevelChange = () => {
				this.CreateLeftUITab()
				this.SelectRadioBtn()
				this.SetTabButtom()
				this.SetRadioBottom()
			}
			this.BindVar(local_mainRoleVo, EventName.CHANGE_LEVEL, OnLevelChange)

			let OnGoodsChange = () => {
				if (this.use_delete_method) {
					return
				}
				this.SetTabButtom()
				this.SetRadioBottom()
				this.SetEquipBtnRed()
			}
			this.BindEvent(local_comModelIns, local_comModel.UPDATE_EQUIP_RED, OnGoodsChange)

			let OnRatioChange = () => {
				this.UpdateSuccessRatio()
			}
			this.BindEvent(local_comModelIns, local_comModel.UPDATA_SUCCESS_RATIO, OnRatioChange)

			Util.AddClickEvent(this.ruleBtn, () => {
				this.ShowRuleView()
			}, this, true)

			Util.AddClickEvent(this.rankBtn, () => {
				local_comModelIns.Fire(local_comEvent.RED_EQUIP_OPEN_VIEW, "CompositeRankView")
			}, this, true)

			Util.AddClickEvent(this.equipBtn1, () => {
				this.SelectEquipBtn(1)
				this.SelectRadioBtn()
			}, this, true)

			Util.AddClickEvent(this.equipBtn2, () => {
				this.SelectEquipBtn(2)
				this.SelectRadioBtn()
			}, this, true)
		}

		this.InitView = () => {
			if (this.is_loaded) {
				if (!default_index_arr) {
					default_index_arr = []
				}
				this.CreateLeftUITab()
				this.SetTabButtom()
				this.CreateMatItems()
				if (this.tabBar && sub_id_list_) {
					if (default_index_arr.length > 0 && sub_id_list_[default_index_arr[0]] && sub_id_list_[default_index_arr[0]][default_index_arr[1]]) {
						this.tabBar.SetSelectTab(default_index_arr[0], default_index_arr[1])
						sub_select_id_ = sub_id_list_[default_index_arr[0]][default_index_arr[1]]
						/*
						let pos_y = 59 * default_index_[1] + 56 * default_index_[1] - 717
						if (pos_y > 0) {
							this.tabBar.SetContentPos(pos_y)
						}
						*/
					} else {
						this.tabBar.SetSelectTab(tab_index_default_, sub_index_default_)
						sub_select_id_ = sub_id_list_[tab_index_default_][sub_index_default_]
						/*
						let pos_y = 59 * tab_index_default_ + 56 * sub_index_default_ - 717
						if (pos_y > 0) {
							this.tabBar.SetContentPos(pos_y)
						}
						*/
					}

				}
				this.InitEvent()
			}
		}

		this.SelectRadioBtn = () => {
			if (this.is_loaded) {
				let key = null
				let tabCfg = compManu_cfg_[sub_select_id_]
				if (tabCfg) {
					let list = local_erlang.Parse(tabCfg.list)
					if (this.select_index == 0 && this.equip_select_index != 1) {
						key = Number(list[8])
					} else {
						key = Number(list[index_to_type_list_[this.select_index]])
					}
				}
				cur_com_id_ = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_goods_compose.name, key, false, comp_equip_rule_cfg_)
				local_comModelIns.selected_equip_list = {}
				local_comModelIns.equipment_mat_list = {}
				local_comModelIns.compEquip_regular_glist = []
				goodsid_to_index_ = {}
				if (cur_com_id_) {
					this.UpdateView(cur_com_id_)
				} else {
					if (tabCfg) {
						let list = local_erlang.Parse(tabCfg.list)
						key = Number(list[index_to_type_list_[0]])
					}
					cur_com_id_ = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_goods_compose.name, key, false, comp_equip_rule_cfg_)
					if (cur_com_id_) {
						//this.rBtn_weapon.selected = true
						//this.select_index = 1
						//let weapon_toggle = this.CompositeSubButtonSkin.GetComponent("Toggle")
						//this.toggleGroup.NotifyToggleOn(weapon_toggle)
					} else {
						this.Clear()
					}
				}
				this.UpdateRadioBtn()
			}
		}

		this.UpdateRadioBtn = () => {
			for (let i = 0; i < 8; i++) {
				let icon = i == this.select_index ? "ui_button_rect12" : "ui_button_rect13"
				let color = i == this.select_index ? "#663915" : "#ffffff"
				this.res_mgr.SetImageSprite(this, this["rBtn_img" + i], "common", icon)
				this["rBtn_lb" + i].color = color
			}
		}

		this.UpdateRedDot = () => {
			this.SetTabButtom()
			this.SetRadioBottom()
		}

		this.Clear = () => {
			if (mat_item_list_) {
				for (let index in mat_item_list_) {
					let item = mat_item_list_[index]
					if (item) {
						item.InitMatData(3)
					}
				}
			}
			if (target_item_) {
				target_item_.SetData(0)
				target_item_.ClearItemEffect()
			}
			this.one_key_add_red.visible = false
			this.composite_red.visible = false
		}

		//isDropBtn是否由下拉菜单点击
		this.UpdateView = (cfg?, isDropBtn?) => {
			if (cfg) {
				let show_red = one_key_red_list_[this.select_index]
				if (!isDropBtn) {
					if (cfg.extra) {
						let data = [{ id: 1, content: "红3装备", cond: cfg.id }, { id: 2, content: "暗金装备", cond: cfg.extra }]
						let defaultStr = "红3装备"
						if (!this.dropBtn) {
							this.dropBtn = new DownDropBtn(this.dropListCon)
							this.dropBtn.Init(data, this.SelectDropBtn, defaultStr, "content", "UI", null, true)
							this.dropBtn.Load()
						} else {
							this.dropBtn.Init(data, this.SelectDropBtn, defaultStr, "content", "UI", null, true)
							this.dropBtn.UpdateItem()
						}
						//SetSizeDeltaX(this.dropBtn.transform, 180)
						this.dropListCon.visible = true
						if (show_red) {
							let index = show_red == 2 && 2 || 1
							this.dropBtn.SetSelectIndex(index - 1)
							return
						} else {
							if (this.dropSelectIndex && this.dropSelectIndex == 2) {
								this.dropBtn.SetSelectIndex(1)
								return
							}
						}
					} else {
						this.dropSelectIndex = null
						this.dropListCon.visible = false
					}
				}

				rule_id_ = cfg.id
				let goods_cfg = local_erlang.Parse(cfg.goods)
				if (goods_cfg && goods_cfg[0]) {
					comp_equip_id_ = goods_cfg[0][1]
					this.SetTargetProperty(comp_equip_id_)
					this.SetMatData(cfg)
					success_type_ = cfg.ratio_type
					success_probability_list_ = local_erlang.Parse(cfg.ratio)
					this.UpdateSuccessRatio()
					let realRed = show_red && (!this.dropSelectIndex || show_red == this.dropSelectIndex || show_red == 3)
					this.one_key_add_red.visible = realRed
					let goodsbasic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(comp_equip_id_)
					let equip_career = goodsbasic.career_id
					let career = RoleManager.GetInstance().GetMainRoleCareer()
					let sex = RoleManager.GetInstance().GetMainRoleSex()
					let showred1
					let showred2
					if (sex == goodsbasic.sex && this.select_index == 1) {
						if (career == equip_career) {
							showred1 = this.equip_select_index == 1
							showred2 = !showred1
						} else {
							showred1 = this.equip_select_index == 2
							showred2 = !showred1
						}
					}
					this.reuipRed1.visible = realRed && showred1
					this.reuipRed2.visible = realRed && showred2
				}
			}
		}

		this.SetMatData = (cfg?) => {
			hole_list_ = local_erlang.Parse(cfg.hole_list)
			regular_mat_cfg_ = local_erlang.Parse(cfg.regular_mat)
			irregular_mat_cfg_ = local_erlang.Parse(cfg.irregular_mat)
			if (hole_list_) {
				if (!mat_item_list_) {
					mat_item_list_ = []
				}
				//let index = 0
				let regular_index = 0
				let irregular_index = 0
				let i = 0
				let is_set = false
				do {
					let mat_item = mat_item_list_[i]
					if (mat_item) {
						let parms = null
						let hole = Number(hole_list_[i])
						if ((hole == 1 && regular_mat_cfg_) && regular_mat_cfg_[regular_index]) {
							parms = regular_mat_cfg_[regular_index]
							regular_index = regular_index + 1
						} else if ((hole == 2 && irregular_mat_cfg_) && irregular_mat_cfg_[irregular_index]) {
							parms = irregular_mat_cfg_[irregular_index]
							irregular_index = irregular_index + 1
						}
						mat_item.InitMatData(hole, parms)

						if (!is_set) {
							this.SetCompositeTip(parms)
							is_set = true
						}
						//index=index+1
					}
					i = i + 1
				} while ((i < 5))
			}
		}

		this.UpdateSuccessRatio = () => {
			let goods_count = Util.TableSize(local_comModelIns.selected_equip_list)
			if (success_type_ == 1) {
				success_radio_ = 0
				if (regular_mat_cfg_ && Util.TableSize(local_comModelIns.equipment_mat_list) < regular_mat_cfg_.length) {
					this.ChangeSuccessAudioStage()
					this.success_label.text = "成功率:" + success_radio_ + "%"
					this.composite_red.visible = false
					this.SetOneKeyAddRed()
					//this.one_key_add_red.visible = one_key_red_list_[this.select_index] && one_key_red_list_[this.select_index] > 0 
					return
				}
				success_radio_ = success_probability_list_
			} else if (success_type_ == 2) {
				if (success_probability_list_) {
					success_radio_ = 0
					let cfg = regular_mat_cfg_
					if ((cfg && cfg[0]) && cfg[0][0]) {
						let cost = Number(cfg[0][0][2])
						if (Util.TableSize(local_comModelIns.equipment_mat_list) < cfg.length || Util.TableSize(local_comModelIns.equipment_mat_list) == cfg.length && cost > local_gModelIns.GetTypeGoodsNum(cfg[0][0][1])) {
							this.ChangeSuccessAudioStage()
							this.success_label.text = "成功率:" + success_radio_ + "%"
							this.composite_red.visible = false
							this.SetOneKeyAddRed()
							//this.one_key_add_red :SetActive( one_key_red_list_[this.select_index] && one_key_red_list_[this.select_index] > 0)
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
			this.ChangeSuccessAudioStage()
			if (success_radio_ != 0 && supreme_vip && supreme_vip != 0) {
				this.success_label.text = "成功率:" + success_radio_ + "%(已含至尊加成+5%)"
			} else {
				this.success_label.text = "成功率:" + success_radio_ + "%"
			}
			if (success_radio_ == 100) {
				this.composite_red.visible = true
				this.one_key_add_red.visible = false
			} else {
				//let btn = this.btn_group.GetChild(this.select_index)
				//if (btn ) {
				let red = this.btn_red_list[this.select_index]
				if (red && red.visible) {
					this.one_key_add_red.visible = true
				} else {
					this.one_key_add_red.visible = false
				}
				//}
				this.composite_red.visible = false
			}
		}

		this.CreateMatItems = () => {
			if (!mat_item_list_) {
				mat_item_list_ = []
			}
			let i = 0
			do {
				let mat = this["mat_pos_" + i]
				let item = new CompositeEquipItem(mat)
				item.SetPos(i)
				item.Load()
				mat_item_list_[i] = item
				i = i + 1
			} while ((i < 5))
		}

		this.SetTabButtom = () => {
			let list = local_comModelIns.equip_red_list
			let sex_arr_1_ = []
			let sex_arr_2_ = []
			for (let key in list) {
				let num_ = Number(key)
				if (num_ % 100 == 2) {
					sex_arr_2_.push(num_)
				} else {
					sex_arr_1_.push(num_)
				}
			}

			default_index_arr = []
			if (RoleManager.GetInstance().GetMainRoleSex() == 2) {
				this.SetTabInit(sex_arr_2_, list)
				this.SetTabInit(sex_arr_1_, list)
			} else {
				this.SetTabInit(sex_arr_1_, list)
				this.SetTabInit(sex_arr_2_, list)
			}

		}

		this.SetTabInit = (total_arr, list) => {
			for (let index_ = total_arr.length; index_ >= 0; index_--) {
				let key = String(total_arr[index_])
				let sub_tab_list = list[key]
				let ShowRed = false
				let i = this.tab_id_to_index[key]
				if (i || i == 0) {
					if (sub_tab_list) {
						for (let k = sub_tab_list.length - 1; k >= 0; k--) {
							let show = sub_tab_list[k]
							if (show) {
								if (default_index_arr.length == 0) {
									default_index_arr[0] = i
									default_index_arr[1] = k
								}

								ShowRed = true
								this.tabBar.setSubTabRedDot(i, k, true)
							} else {
								this.tabBar.setSubTabRedDot(i, k, false)
							}
						}
					}
					this.tabBar.setTabRedDot(i, ShowRed)
				}
			}
		}

		this.SetRadioBottom = () => {
			local_comModelIns.need_goods_list = []
			one_key_red_list_ = []

			let index_red_list = []
			let has_better = false

			let i = 0
			do {
				let key = null
				let tabCfg = compManu_cfg_[sub_select_id_]
				if (tabCfg) {
					let list = local_erlang.Parse(tabCfg.list)
					key = Number(list[index_to_type_list_[i]])
				}
				let cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_goods_compose.name, key, false, comp_equip_rule_cfg_)
				if (!cfg) {
					let radioBtn = this["rBtn_" + i]
					if (radioBtn) {
						index_red_list[i] = 0
						one_key_red_list_[i] = false
					}
				} else {
					let radioBtn = this["rBtn_" + i]
					if (radioBtn) {
						let can_com, type
						[can_com, type] = local_comModelIns.EquipCanComposite(cfg.id, true, true)
						if (can_com) {
							one_key_red_list_[i] = type || true
							// 可合成时进行更优装备的判断
							let goods = ErlangParser.GetInstance().Parse(cfg.goods)[0]
							let basic = this.goods_model.GetGoodsBasicByTypeId(goods[1])
							let equip = EquipModel.GetInstance().GetWearEquipInfo(basic.equip_type)
							let better = false
							if (basic && equip) {
								let score = basic.rating
								score = Util.CalAttrPower(basic.base_attrlist, false, true)
								let equip_attr = ResManager.GetInstance().GetGameConfigFromCache(this, "config_equip_attr", false)
								let equip_vo = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_equip_attr.name, basic.type_id, false, equip_attr)
								if (equip_vo) {
									score = score + Util.CalAttrPower(equip_vo.other_attr, false, true)
								}

								let score_now = Util.CalAttrPower(equip.base_attrlist, false, true)
								let equip_now = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_equip_attr.name, equip.type_id, false, equip_attr)
								if (equip_now) {
									score_now = score_now + Util.CalAttrPower(equip_now.other_attr, false, true)
								}
								let sex = RoleManager.GetInstance().GetMainRoleSex()
								if ((basic.sex == 0 || basic.sex == sex) && score > score_now) {
									better = true
								}
							}
							if (!equip) {
								better = true
							}
							if (better) {
								has_better = true
								index_red_list[i] = 2
								
							} else {
								index_red_list[i] = 1
								
							}
						} else {
							index_red_list[i] = 0
							one_key_red_list_[i] = false
						}
					}
				}
				i = i + 1
			} while ((i < index_to_type_list_.length))


			for(let i in index_red_list){
				var red_dot:Laya.Image = this.btn_red_list[i]
				if(index_red_list[i]){
					if(has_better){

					}
					else{
						
						ResManager.GetInstance().SetImageSprite(this, red_dot, "common", "com_red_point")
					}
				}
				else{
					red_dot.visible = false
				}
			}


			let show_cond = has_better ? 1 : 0
			for(let i in index_red_list){
				var red_dot:Laya.Image = this.btn_red_list[i]
				if(index_red_list[i] > show_cond){
					red_dot.visible = true
					if(index_red_list[i] == 1){
						red_dot.scale(0.8, 0.8)
						ResManager.GetInstance().SetImageSprite(this, red_dot, "common", "com_red_point")
					} else if(index_red_list[i] == 2){
						red_dot.scale(1, 1)
						ResManager.GetInstance().SetImageSprite(this, red_dot, "composite", "ui_merge_21")
					}
				}
				else{
					red_dot.visible = false
				}
			}
			
			this.SetOneKeyAddRed()
			//this.one_key_add_red.visible = one_key_red_list_[this.select_index] && one_key_red_list_[this.select_index] > 0  
		}

		this.GetDafaultIndex = () => {
			local_comModelIns.need_goods_list = []
			one_key_red_list_ = []

			let y_index
			let r_index

			for (let i = 0; i < index_to_type_list_.length; i++) {
				let key = null
				let tabCfg = compManu_cfg_[sub_select_id_]
				if (tabCfg) {
					let list = local_erlang.Parse(tabCfg.list)
					key = Number(list[index_to_type_list_[i]])
				}
				let cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_goods_compose.name, key, false, comp_equip_rule_cfg_)
				if (cfg) {
					let can_com, type
					[can_com, type] = local_comModelIns.EquipCanComposite(cfg.id, true, true)
					if (can_com) {
						one_key_red_list_[i] = type || true
						// 可合成时进行更优装备的判断
						let goods = ErlangParser.GetInstance().Parse(cfg.goods)[0]
						let basic = this.goods_model.GetGoodsBasicByTypeId(goods[1])
						let equip = EquipModel.GetInstance().GetWearEquipInfo(basic.equip_type)
						let better = false
						if (basic && equip) {
							let score = basic.rating
							score = Util.CalAttrPower(basic.base_attrlist, false, true)
							let equip_attr = ResManager.GetInstance().GetGameConfigFromCache(this, "config_equip_attr", false)
							let equip_vo = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_equip_attr.name, basic.type_id, false, equip_attr)
							if (equip_vo) {
								score = score + Util.CalAttrPower(equip_vo.other_attr, false, true)
							}

							let score_now = Util.CalAttrPower(equip.base_attrlist, false, true)
							let equip_now = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_equip_attr.name, equip.type_id, false, equip_attr)
							if (equip_now) {
								score_now = score_now + Util.CalAttrPower(equip_now.other_attr, false, true)
							}
							let sex = RoleManager.GetInstance().GetMainRoleSex()
							if ((basic.sex == 0 || basic.sex == sex) && score > score_now) {
								better = true
							}
						}
						if (!equip) {
							better = true
						}
						if (better) {
							//优
							y_index = i
							break;

						} else {
							//红点
							if (r_index != null) {
								if (i < r_index) {
									r_index = i
								}
							} else {
								r_index = i
							}
						}
					}
				}
			}


			if (y_index) {
				return y_index
			}
			if (r_index) {
				return r_index
			}

			return 0
		}

		this.SortList = (list) => {

			let tab_list = Util.DeepCopy(list) //毕淼修改数据源

			let new_list = []
			new_list[0] = []
			new_list[1] = []
			//根据玩家自身的性别,会将本职业的合成菜单排在前面,按红2->红3->暗金->粉装->装备拆解->异性红2->异性红3->异性暗金->异性粉装
			if (RoleManager.GetInstance().GetMainRoleSex() == 2) {
				//女角色

				new_list[0] = new_list[0].concat(tab_list[0].slice(4, 8))
				new_list[0] = new_list[0].concat(tab_list[0].slice(8))
				new_list[0] = new_list[0].concat(tab_list[0].slice(0, 4))

				new_list[1] = new_list[1].concat(tab_list[1].slice(4, 8))
				new_list[1] = new_list[1].concat(tab_list[1].slice(8))
				new_list[1] = new_list[1].concat(tab_list[1].slice(0, 4))
			} else {
				//男角色
				new_list[0] = new_list[0].concat(tab_list[0].slice(0, 4))
				new_list[0] = new_list[0].concat(tab_list[0].slice(8))
				new_list[0] = new_list[0].concat(tab_list[0].slice(4, 8))

				new_list[1] = new_list[1].concat(tab_list[1].slice(0, 4))
				new_list[1] = new_list[1].concat(tab_list[1].slice(8))
				new_list[1] = new_list[1].concat(tab_list[1].slice(4, 8))
			}

			return new_list
		}

		this.CreateLeftUITab = () => {
			let list_init = local_comModelIns.GetTabBarData(compManu_cfg_, compManuName_cfg_, local_comModel.EquipmentComposeRule, local_comModel.EquipmentResolveRule)
			if (!list_init || list_init[0].length == 0) {
				return
			}
			let list = this.SortList(list_init)
			this.GetTabIndex(list)

			if (!this.tabBar) {
				this.tabBar = new UIVerTabBar(this.tab_group)
				this.tabBar.Load()
			}
			let call_fun = (tab_index?, sub_index?) => {
				//tabbar 初始化的时候执行一次
				if (sub_id_list_ && sub_id_list_[tab_index] && sub_id_list_[tab_index][sub_index]) {
					//if (sub_id_list_[tab_index][sub_index] == sub_id_list_[tab_index][sub_id_list_[tab_index*/.length ) {
					//return
					//}
					cur_tab_index_ = tab_index

					sub_select_id_ = Number(sub_id_list_[tab_index][sub_index])
					if (sub_select_id_ == local_comModel.EquipmentResolveRuleSubTabId) {
						this.compose_equip_group.visible = false
						this.resolve_equip_group.visible = true
						if (!equip_resolve_view_) {
							equip_resolve_view_ = new CompositeEquipResolveView(this.resolve_equip_group)
							equip_resolve_view_.Load()
						}
						equip_resolve_view_.SetData()
					} else {
						this.compose_equip_group.visible = true
						this.resolve_equip_group.visible = false
						this.SetRadioBottom()

						this.select_index = this.GetDafaultIndex()
						this.equipBtnCon.visible = this.select_index == 0
						if (this.select_index == 0) {
							this.SelectEquipBtn(this.equip_select_index)
						}
						this.SelectRadioBtn()
					}
				}
			}

			sub_id_list_ = list[0]
			if (sub_id_list_.length > 0) {
				this.tabBar.SetTabBar(list[1], call_fun, GetSizeDeltaY(this.tab_group), null, null, null, GetSizeDeltaY(this.tab_group))
				// if (local_mainRoleVo.sex == 2) {
				// 	tab_index_default_ = Mathf.Ceil((list[0].length + 1) / 2) - 1
				// }
				tab_index_default_ = 0
				sub_index_default_ = list[0][0].length - 1
			}
		}

		this.SetTargetProperty = (type_id?) => {
			if (type_id) {
				if (!target_item_) {
					target_item_ = new EquipmentItem(this.award_group)
					target_item_.Load()
					target_item_.SetItemSize(96, 96)
				}
				target_item_.SetClickCallBack(() => {
					let goodsBasic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
					if (((goodsBasic.sex == 0 || goodsBasic.sex == RoleManager.GetInstance().GetMainRoleSex())
						&& (goodsBasic.career_id == 0 || goodsBasic.career_id == RoleManager.GetInstance().GetMainRoleCareer()))
						&& EquipModel.GetInstance().GetWearEquipInfo(goodsBasic.equip_type)) {
						//UIToolTipMgr.GetInstance().ContrastEquipByGoodVo(goodsBasic)
						this.ContrastEquipByGoodVo(goodsBasic)
					} else {
						UIToolTipMgr.GetInstance().AppendEquipTips(type_id)
					}
				}
				)
				target_item_.SetData(type_id)
				if (this.select_index == 0) {
					let goods_basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
					if (goods_basic && goods_basic.sex == 1) {
						this.equipBtnText1.text = WordManager.GetCareerLimit(1)
						this.equipBtnText2.text = WordManager.GetCareerLimit(3)
					} else {
						this.equipBtnText1.text = WordManager.GetCareerLimit(2)
						this.equipBtnText2.text = WordManager.GetCareerLimit(4)
					}
				}
			}
		}

		this.ContrastEquipByGoodVo = (data) => {
			let wear_equip_info = this.equip_model.GetWearEquipInfo(data.equip_type)
			let liuhai = Util.GetLiuhaiHeight() || 0
			if (wear_equip_info) {
				let callback = (dynamic?) => {
					if (!this.equipTool1) {
						this.equipTool1 = new EquipToolTipItem()
						// this.equipTool1.display_obj.y = 0
						// this.equipTool1.display_obj.x = 0
					}
					this.equipTool1.SetData(wear_equip_info.type_id, -125, 80 + liuhai, dynamic, 1, [1])
					this.equipTool1.ExcuteCallback(() => {
						this.equipTool1.display_obj.centerX = -125
						this.equipTool1.display_obj.centerY = -80 + liuhai
					})
					this.equipTool1.Open()
					this.equipTool1.closeflag = false
					if (!this.equipTool2) {
						this.equipTool2 = new EquipToolTipItem()
						this.equipTool2.SetBaseAttBool(true);
						this.equipTool2.use_background = false
					}
					this.equipTool2.SetData(data.type_id, 150, -105 + liuhai, data, 1, [1])
					this.equipTool2.ExcuteCallback(() => {
						this.equipTool2.display_obj.centerX = 150
						this.equipTool2.display_obj.centerY = 105 + liuhai
					})
					this.equipTool2.Open()
					this.equipTool2.closeflag = false
				}
				this.goods_model.GetDynamic(wear_equip_info.goods_id, callback)
			}
		}

		this.ShowRuleView = () => {
			if(!this.tabBar)return
			let ruleConfig = this.cfg_rule
			let ttid = 0
			for(let key in this.tab_id_to_index){
				if(this.tab_id_to_index[key]==cur_tab_index_){
					ttid = Number(key)
				}
			}
			if (ruleConfig) {
				//配置只有11000 - 14000 做个兼容
				let rule_num = Math.floor(ttid/10)*10
				let ShowConfig = ruleConfig["com" + rule_num]
				if (ShowConfig) {
					let ruleView = new CommonRuleView()
					ruleView.Open(ShowConfig["content"])
					ruleView.SetTitle(ShowConfig["title"])
				}
			}
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

		this.AddCompositeEffect = (call_back?) => {
			call_back()
			//this:ClearCompositeEffect()
			//this:AddUIEffect2("ui_compound_path", this.compound_path_group, null, null, null, null,() => {
			//this:AddUIEffect2("ui_compound_frame_big", this.compound_frame_big_group, null, null, null, null, call_back)
			//this:AddUIEffect2("ui_compound_boom", this.compound_boom_group)
			//this:AddUIEffect2("ui_compound_frame", this.compound_frame_group)
			//}
			//)
		}

		this.ChangeSuccessAudioStage = () => {
			let star = EquipModel.GetInstance().GetStarByTypeId(Number(comp_equip_id_))
			if (success_radio_ != 0
				&& success_radio_ < 100
				&& local_comModelIns.lifeSkillAdd
				&& local_comModelIns.lifeSkillAdd > 0
				&& star == 3
			) {
				success_radio_ = Math.min(Number(success_radio_) + Mathf.Round(local_comModelIns.lifeSkillAdd / 100), 100)
			}
			let supreme_vip = local_mainRoleVo.supreme_vip
			if (success_radio_ != 0 && supreme_vip && supreme_vip != 0) {
				//this.add_stage_img.visible = true
				//SetAnchoredPosition(this.success_label, -120, -13)
				if (success_radio_ >= 100) {
					//ResManager.GetInstance().SetImageSprite(this, this.add_stage_img, "composite", "max", true)
				} else {
					success_radio_ = Math.min(Number(success_radio_) + 5, 100)
					//ResManager.GetInstance().SetImageSprite(this, this.add_stage_img, "composite", "add", true)
				}
			} else if (success_radio_ == 0) {
				//this.add_stage_img.visible = false
				//SetAnchoredPosition(this.success_label, -40, -13)
			}
		}

		this.ClearCompositeEffect = () => {
			this.ClearUIEffect(this.compound_frame_group)
			this.ClearUIEffect(this.compound_frame_big_group)
			this.ClearUIEffect(this.compound_path_group)
			this.ClearUIEffect(this.compound_boom_group)
		}

		this.GetTabIndex = (tab_list) => {
			this.tab_id_to_index = {}
			let tab_id_list = tab_list[1]//local_erlang.Parse(compManu_cfg_[local_comModel.EquipmentComposeRule].list)
			if (tab_id_list) {
				let role_lv = RoleManager.GetInstance().GetMainRoleLevel()
				let pas_num = 0
				for (let index in tab_id_list) {
					let data = tab_id_list[index]
					let id = data[2]
					let cfg = compManu_cfg_[id]
					if (cfg && role_lv >= cfg.open_lv) {
						this.tab_id_to_index[id] = Number(index) - pas_num
					} else {
						pas_num = pas_num + 1
					}
				}
			}
		}

		this.LocalDeleteMe = () => {
			if (mat_item_list_) {
				for (let key in mat_item_list_) {
					mat_item_list_[key].DeleteMe()
					mat_item_list_[key] = null
				}
				mat_item_list_ = null
			}
			if (this.tabBar) {
				this.tabBar.DeleteMe()
				this.tabBar = null
			}
			if (target_item_) {
				target_item_.DeleteMe()
				target_item_ = null
			}
			if (this.tween_id) {
				SYTweenLite.Stop(this.tween_id)
				this.tween_id = null
			}
			if (this.waitid) {
				clearTimeout(this.waitid)
				this.waitid = null
			}
			if (equip_resolve_view_) {
				equip_resolve_view_.DeleteMe()
				equip_resolve_view_ = null
			}
			if (this.dropBtn) {
				this.dropBtn.DeleteMe()
				this.dropBtn = null
			}
			this.ClearCompositeEffect()
			this.ClearUIEffect(this.compound_Rune_group)
			compManu_cfg_ = null
			compManuName_cfg_ = null
			comp_equip_rule_cfg_ = null
		}

		this.SelectEquipBtn = (index?) => {
			let color1 = index != 1 ? "#ffffff" : "#663915"
			let color2 = index != 1 ? "#663915" : "#ffffff"
			this.equipBtnText1.color = color1
			this.equipBtnText2.color = color2

			let icon1 = index != 1 ? "ui_button_rect13" : "ui_button_rect12"
			let icon2 = index != 1 ? "ui_button_rect12" : "ui_button_rect13"
			this.res_mgr.SetImageSprite(this, this.equipBtnImage1, "common", icon1)
			this.res_mgr.SetImageSprite(this, this.equipBtnImage2, "common", icon2)

			this.equip_select_index = index
		}

		this.SelectDropBtn = (index?, data?) => {
			local_comModelIns.selected_equip_list = {}
			local_comModelIns.equipment_mat_list = {}
			local_comModelIns.compEquip_regular_glist = []
			goodsid_to_index_ = {}
			let key = Number(data.cond)
			let cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_goods_compose.name, key, false, comp_equip_rule_cfg_)
			if (cfg) {
				this.dropSelectIndex = data.id
				this.UpdateView(cfg, true)
			}
		}

		this.SetOneKeyAddRed = () => {
			let redType = one_key_red_list_[this.select_index]
			this.one_key_add_red.visible = redType && (!this.dropSelectIndex || (redType == this.dropSelectIndex || redType == 3))
		}

		this.SetEquipBtnRed = () => {
			let show_red = one_key_red_list_[this.select_index]
			let realRed = show_red && (!this.dropSelectIndex || show_red == this.dropSelectIndex || show_red == 3)
			this.one_key_add_red.visible = realRed
			let goodsbasic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(comp_equip_id_)
			if (!goodsbasic) {
				return
			}
			let equip_career = goodsbasic.career_id
			let career = RoleManager.GetInstance().GetMainRoleCareer()
			let sex = RoleManager.GetInstance().GetMainRoleSex()
			let showred1
			let showred2
			if (sex == goodsbasic.sex && this.select_index == 1) {
				if (career == equip_career) {
					showred1 = this.equip_select_index == 1
					showred2 = !showred1
				} else {
					showred1 = this.equip_select_index == 2
					showred2 = !showred1
				}
			}
			this.reuipRed1.visible = realRed && showred1
			this.reuipRed2.visible = realRed && showred2
		}
	}

	private SetCompositeTip(parms?) {
		if (!parms) {
			return
		}
		let local_MatViewType = MatViewType
		let type_ = local_MatViewType.EQUIP
		let local_gModel = GoodsModel.GetInstance()
		let local_wordMgr = WordManager
		let local_colorUtil = ColorUtil

		let sex = RoleManager.GetInstance().mainRoleInfo.sex
		let equip_attr_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_equip_attr", false)
		let equipVo = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_equip_attr.name, Number(parms[0]), false, equip_attr_cfg)
		let goodsVo = local_gModel.GetGoodsBasicByTypeId(parms[0])
		let sex_word = null
		let type_word = null
		let badStar = null
		if (type_ == local_MatViewType.EQUIP && goodsVo) {
			sex = goodsVo.sex
		}
		if (sex == 1) {
			sex_word = "男"
		} else if (sex == 2) {
			sex_word = "女"
		}
		if (parms.length == 1) {
			type_word = local_wordMgr.GetEquipPos(goodsVo.equip_type)
			let goodsVo1 = local_gModel.GetGoodsBasicByTypeId(parms[0])
			if (goodsVo1 && (((goodsVo1.equip_type == 3 || goodsVo1.equip_type == 5) || goodsVo1.equip_type == 7) || goodsVo1.equip_type == 9)) {
				sex_word = ""
			}
		} else {
			let cache_type = []
			for (let _tmpi in parms) {
				var vo = parms[_tmpi]
				let goodsVo1 = local_gModel.GetGoodsBasicByTypeId(vo)
				if (cache_type.length == 0) {
					table.insert(cache_type, goodsVo1.equip_type)
					type_word = local_wordMgr.GetEquipPos(goodsVo1.equip_type)
				} else if (cache_type[0] != goodsVo1.equip_type) {
					if (cache_type[0] == 3 || cache_type[0] == 5) {
						type_word = "饰品"
					} else {
						type_word = "武防"
					}
				}
				if (type_ == local_MatViewType.EQUIP && !badStar) {
					let equipVo = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_equip_attr.name, Number(vo), false, equip_attr_cfg)
					if (equipVo && equipVo.class_type == 1) {
						badStar = equipVo.star
					}
				}
			}
			if (((cache_type[0] == 3 || cache_type[0] == 5) || cache_type[0] == 7) || cache_type[0] == 9) {
				sex_word = ""
			}
		}
		let star = (equipVo.star > 0 && (equipVo.star + "星") || (""))
		if (type_ == local_MatViewType.EQUIP) {
			if (badStar) {
				this.need_label.innerHTML = Util.StrToHTML("<font color='#ffffff'>需要</font>" + equipVo.stage + "阶" + star + local_colorUtil.GetColorName(goodsVo.color) + sex_word + type_word + "或红色" + badStar + "星残旧装备")
			} else {
				this.need_label.innerHTML = Util.StrToHTML("<font color='#ffffff'>需要</font>" + equipVo.stage + "阶" + star + local_colorUtil.GetColorName(goodsVo.color) + sex_word + type_word)
			}
		} else {
			this.need_label.innerHTML = Util.StrToHTML("<font color='#ffffff'>需要</font>" + equipVo.stage + "阶" + star + local_colorUtil.GetColorName(goodsVo.color) + sex_word + type_word)
		}
		if(PlatformManager.IsEyouPlatform()){
			this._lb_bg2.y = 591
			this.need_label.y = 598
			this.need_label.style.wordWrap = true
			this.need_label.style.leading = 0.1
			this.need_label.style.width = 500
			SetHtmlCenter(this.need_label, { x: 192, w: 500 })

			this._lb_bg2.height = this.need_label.contextHeight + 10
		}else{
		SetHtmlCenter(this.need_label, { x: 258, w: 372 })
		}

		let text_width = this.need_label.contextWidth + 130
		text_width = Math.min(text_width, 500)
		this._lb_bg2.width = text_width + 50

	}

	public DeleteMe() {
		this.LocalDeleteMe()
		super.DeleteMe()
	}

	public SetVisible(bool?) {
		CompositeModel.GetInstance().Fire(CompositeModel.COLSE_CHOSE_EQUIPMENT_VIEW)
		super.SetVisible(bool)
	}

	public createChildren() {
		if (this["GetComponents"]) {
			this["GetComponents"]()
			this.is_get = true
		}
		this.story_obj_list = this.story_obj_list || {}
		this.story_obj_list[TaskTipType.Red_equip_combine] = [this.btnOneKeyAdd, this.btnComposite]
		super.createChildren()
	}


	compose_equip_group: Laya.Box
	mid_bg: Laya.Image
	_Image1: Laya.Image
	_Group1: Laya.Box
	_Image4: Laya.Image
	_Image5: Laya.Image
	_Label1: Laya.Label
	_Label2: Laya.Label
	lineImage2: Laya.Image
	lineImage1: Laya.Image
	_Image6: Laya.Image
	lb_title: Laya.Label
	btn_group: Laya.Box
	rBtn_0: Laya.Box
	rBtn_img0: Laya.Image
	rBtn_lb0: Laya.Label
	rBtn_red0: Laya.Image
	rBtn_1: Laya.Box
	rBtn_img1: Laya.Image
	rBtn_lb1: Laya.Label
	rBtn_red1: Laya.Image
	rBtn_2: Laya.Box
	rBtn_img2: Laya.Image
	rBtn_lb2: Laya.Label
	rBtn_red2: Laya.Image
	rBtn_3: Laya.Box
	rBtn_img3: Laya.Image
	rBtn_lb3: Laya.Label
	rBtn_red3: Laya.Image
	rBtn_4: Laya.Box
	rBtn_img4: Laya.Image
	rBtn_lb4: Laya.Label
	rBtn_red4: Laya.Image
	rBtn_5: Laya.Box
	rBtn_img5: Laya.Image
	rBtn_lb5: Laya.Label
	rBtn_red5: Laya.Image
	rBtn_6: Laya.Box
	rBtn_img6: Laya.Image
	rBtn_lb6: Laya.Label
	rBtn_red6: Laya.Image
	rBtn_7: Laya.Box
	rBtn_img7: Laya.Image
	rBtn_lb7: Laya.Label
	rBtn_red7: Laya.Image
	_Group3: Laya.Box
	success_label: Laya.Label
	add_stage_img: Laya.Image
	amterial_tip: Laya.Box
	_Label4: Laya.Label
	_Image8: Laya.Image
	compound_Rune_group: Laya.Box
	compound_frame_big_group: Laya.Box
	compound_boom_group: Laya.Box
	award_group: Laya.Box
	compound_path_group: Laya.Box
	compound_frame_group: Laya.Box
	mat_group: Laya.Box
	mat_pos_0: Laya.Box
	mat_pos_1: Laya.Box
	mat_pos_2: Laya.Box
	mat_pos_3: Laya.Box
	mat_pos_4: Laya.Box
	btnOneKeyAdd: Laya.Box
	_Image1add: Laya.Image
	labelDisplay: Laya.Label
	one_key_add_red: Laya.Image
	btnComposite: Laya.Box
	_Image1com: Laya.Image
	labelDisplay11: Laya.Label
	composite_red: Laya.Image
	equipBtnCon: Laya.Box
	equipBtn1: Laya.Box
	equipBtnImage1: Laya.Image
	equipBtnText1: Laya.Label
	reuipRed1: Laya.Image
	equipBtn2: Laya.Box
	equipBtnImage2: Laya.Image
	equipBtnText2: Laya.Label
	reuipRed2: Laya.Image
	com_fail: Laya.Image
	ruleBtn: Laya.Image
	dropListCon: Laya.Box
	_lb_bg2: Laya.Image
	need_label: Laya.HTMLDivElement
	resolve_equip_group: Laya.Box
	line_bg: Laya.Image
	_Image9: Laya.Image
	_Label5: Laya.Label
	bottom_image: Laya.Image
	rankBtn: Laya.Image
	tab_group: Laya.Box
	_gp_effect: Laya.Box
	public GetComponents() {
		[
			this.compose_equip_group,
			this.mid_bg,
			this._Image1,
			this._Group1,
			this._Image4,
			this._Image5,
			this._Label1,
			this._Label2,
			this.lineImage2,
			this.lineImage1,
			this._Image6,
			this.lb_title,
			this.btn_group,
			this.rBtn_0,
			this.rBtn_img0,
			this.rBtn_lb0,
			this.rBtn_red0,
			this.rBtn_1,
			this.rBtn_img1,
			this.rBtn_lb1,
			this.rBtn_red1,
			this.rBtn_2,
			this.rBtn_img2,
			this.rBtn_lb2,
			this.rBtn_red2,
			this.rBtn_3,
			this.rBtn_img3,
			this.rBtn_lb3,
			this.rBtn_red3,
			this.rBtn_4,
			this.rBtn_img4,
			this.rBtn_lb4,
			this.rBtn_red4,
			this.rBtn_5,
			this.rBtn_img5,
			this.rBtn_lb5,
			this.rBtn_red5,
			this.rBtn_6,
			this.rBtn_img6,
			this.rBtn_lb6,
			this.rBtn_red6,
			this.rBtn_7,
			this.rBtn_img7,
			this.rBtn_lb7,
			this.rBtn_red7,
			this._Group3,
			this.success_label,
			this.add_stage_img,
			this.amterial_tip,
			this._Label4,
			this._Image8,
			this.compound_Rune_group,
			this.compound_frame_big_group,
			this.compound_boom_group,
			this.award_group,
			this.compound_path_group,
			this.compound_frame_group,
			this.mat_group,
			this.mat_pos_0,
			this.mat_pos_1,
			this.mat_pos_2,
			this.mat_pos_3,
			this.mat_pos_4,
			this.btnOneKeyAdd,
			this._Image1add,
			this.labelDisplay,
			this.one_key_add_red,
			this.btnComposite,
			this._Image1com,
			this.labelDisplay11,
			this.composite_red,
			this.equipBtnCon,
			this.equipBtn1,
			this.equipBtnImage1,
			this.equipBtnText1,
			this.reuipRed1,
			this.equipBtn2,
			this.equipBtnImage2,
			this.equipBtnText2,
			this.reuipRed2,
			this.com_fail,
			this.ruleBtn,
			this.dropListCon,
			this._lb_bg2,
			this.need_label,
			this.resolve_equip_group,
			this.line_bg,
			this._Image9,
			this._Label5,
			this.bottom_image,
			this.rankBtn,
			this.tab_group,
			this._gp_effect,
		]
			= this.GetChildrenByNames([

				"compose_equip_group",
				"mid_bg",
				"_Image1",
				"_Group1",
				"_Image4",
				"_Image5",
				"_Label1",
				"_Label2",
				"lineImage2",
				"lineImage1",
				"_Image6",
				"lb_title",
				"btn_group",
				"rBtn_0",
				"rBtn_img0",
				"rBtn_lb0",
				"rBtn_red0",
				"rBtn_1",
				"rBtn_img1",
				"rBtn_lb1",
				"rBtn_red1",
				"rBtn_2",
				"rBtn_img2",
				"rBtn_lb2",
				"rBtn_red2",
				"rBtn_3",
				"rBtn_img3",
				"rBtn_lb3",
				"rBtn_red3",
				"rBtn_4",
				"rBtn_img4",
				"rBtn_lb4",
				"rBtn_red4",
				"rBtn_5",
				"rBtn_img5",
				"rBtn_lb5",
				"rBtn_red5",
				"rBtn_6",
				"rBtn_img6",
				"rBtn_lb6",
				"rBtn_red6",
				"rBtn_7",
				"rBtn_img7",
				"rBtn_lb7",
				"rBtn_red7",
				"_Group3",
				"success_label",
				"add_stage_img",
				"amterial_tip",
				"_Label4",
				"_Image8",
				"compound_Rune_group",
				"compound_frame_big_group",
				"compound_boom_group",
				"award_group",
				"compound_path_group",
				"compound_frame_group",
				"mat_group",
				"mat_pos_0",
				"mat_pos_1",
				"mat_pos_2",
				"mat_pos_3",
				"mat_pos_4",
				"btnOneKeyAdd",
				"_Image1add",
				"labelDisplay",
				"one_key_add_red",
				"btnComposite",
				"_Image1com",
				"labelDisplay11",
				"composite_red",
				"equipBtnCon",
				"equipBtn1",
				"equipBtnImage1",
				"equipBtnText1",
				"reuipRed1",
				"equipBtn2",
				"equipBtnImage2",
				"equipBtnText2",
				"reuipRed2",
				"com_fail",
				"ruleBtn",
				"dropListCon",
				"_lb_bg2",
				"need_label",
				"resolve_equip_group",
				"line_bg",
				"_Image9",
				"_Label5",
				"bottom_image",
				"rankBtn",
				"tab_group",
				"_gp_effect",
			])
	}
}
window["CompositeEquipView"] = CompositeEquipView
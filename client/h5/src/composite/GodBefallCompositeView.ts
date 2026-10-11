import { BaseItem1 } from "../common/BaseItem1"
import { EventName } from "../common/EventName"
import { Util, GetSizeDeltaY, SetLocalPositionY, PlayBigEffect } from "../util/Util"
import { table } from "../common/table"
import { Config } from "../common/Config"
import { GoodsModel } from "../commonModel/GoodsModel"
import { RoleManager } from "../commonModel/RoleManager"
import { ErlangParser } from "../util/ErlangParser"
import { GodBefallModel } from "../commonModel/GodBefallModel"
import { CompositeModel, CompositeEvent } from "../commonModel/CompositeModel"
import { UIVerTabBar } from "../newgameui/UIVerTabBar"
import { Message } from "../sysInfo/SysInfoController"
import { CongratulationObtainView } from "../common/CongratulationObtainView"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { SYTweenLite } from "../util/SYTweenLite"
import { Alert, Alert_Type } from "../alert/Alert"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { EquipmentItem } from "../common/EquipmentItem"
import { GodBefallButton } from "./GodBefallButton"
import { CompositeGodBefallItem } from "./CompositeGodBefallItem"

import "./SelectGodBefallView"
import { SoundManager } from "../common/SoundManager"

export class GodBefallCompositeView extends BaseItem1 {
	AddCompositeEffect
	Clear
	ClearCompositeEffect
	CompositeFailAni
	Content
	Content1
	CreateLeftUITab
	CreateMatItems
	EmpbtnComposite
	EmpbtnOneKeyAdd
	EquipID_Group
	InitEvent
	InitView
	LoadSuccess
	Scrbtn_group
	Scrtab_scroller
	SelectRadioBtn
	SetMatData
	SetRadioBottom
	SetTabButtom
	SetTargetProperty
	UpdateRedDot
	UpdateSuccessRatio
	UpdateView

	compManuName_cfg
	compManu_cfg
	comp_equip_id
	comp_equip_rule_cfg

	composite_timeout_id
	cur_com_id
	default_index
	god_group_select_value
	god_radioBtn_group
	goodsid_to_index
	hide_img_y
	hole_list
	index_to_type_list
	irregular_mat_cfg
	irregular_mat_gList
	level_change_bind
	mat_item_list
	mat_pos_type
	model
	one_key_red_list
	radio_btn_list
	regular_mat_cfg
	regular_mat_gList
	rule_id
	select_mat_bind
	sub_id_list
	sub_index_default
	sub_select_id
	success_probability_list
	success_radio
	success_type
	tabBar
	tab_group
	tab_loop_list
	tab_loop_mgr
	target_item
	tween_id
	res_mgr

	public constructor(parent?) {
		super(parent)
		this.base_file = "composite"
		this.layout_file = "GodBefallCompositeView"
		this.preload_server_config = {
			"config_compose_menu": false,
			"config_compose_menu_id": false,
			"config_goods_compose": false
		}

		this.sub_index_default = 0
		this.model = CompositeModel.GetInstance()
		this.one_key_red_list = []
		this.mat_pos_type = []
		this.goodsid_to_index = []
		this.EquipID_Group = []
		this.regular_mat_gList = []
		this.irregular_mat_gList = []
		this.default_index = []
		this.radio_btn_list = []
		this.index_to_type_list = ["01", "02", "03", "04"]
		this.tab_loop_list = null
		this.tab_loop_mgr = null
		this.god_group_select_value = 0

		this.res_mgr = ResManager.GetInstance()
		let local_Config = Config
		let local_CompositeModel = CompositeModel
		let local_Message = Message
		let local_CompositeEvent = CompositeEvent
		let goods_model = GoodsModel.GetInstance()
		let erlang_parser = ErlangParser.GetInstance()
		let role_mgr = RoleManager.GetInstance()
		let local_GoodsModel = GoodsModel

		this.load_callback = () => {
			this.LoadSuccess()
		}

		this.LoadSuccess = () => {
			// this.btn_group.scrollBar.visible = false
			this.res_mgr.SetOutsideImageSprite(this, this._Image3, "resource/game/composite/other/ui_merge_01.png")

			this.compManu_cfg = this.res_mgr.GetGameConfigFromCache(this, "config_compose_menu", false)
			this.compManuName_cfg = this.res_mgr.GetGameConfigFromCache(this, "config_compose_menu_id", false)
			this.comp_equip_rule_cfg = this.res_mgr.GetGameConfigFromCache(this, "config_goods_compose", false)

			this.tab_loop_list = []
			this.tab_loop_mgr = new LoopScrowViewMgr()
			let ShowSelectRadioButton = (index?) => {
				this.god_group_select_value = index
				this.SelectRadioBtn()
				this.model.Fire(local_CompositeModel.CLOSE_CHOSE_GOD_VIEW)
			}
			this.tab_loop_mgr.SetData(this.btn_group, GodBefallButton, this.tab_loop_list, LoopScrCon.Horizontal, 1, ShowSelectRadioButton)
			/*
			ResManager.GetInstance().SetOutsideImageSprite(this, this.com_bg, GameResPath.GetIconJpg("composite", "uihc_002"))
			ResManager.GetInstance().SetOutsideImageSprite(this, this.jpg_bg, GameResPath.GetIconJpg("composite", "uihc_003"), true)
			ResManager.GetInstance().SetOutsideImageSprite(this, this.mid_bg, GameResPath.GetIcon("composite", "uihc_004"), true)
			ResManager.GetInstance().SetOutsideImageSprite(this, this.line_bg, GameResPath.GetIcon("composite", "uifu_020"))
			ResManager.GetInstance().SetOutsideImageSprite(this, this._Image2, GameResPath.GetIcon("composite", "uihc_004a"), true)
			ResManager.GetInstance().SetOutsideImageSprite(this, this._Image3, GameResPath.GetIcon("composite", "uihc_004b"), true)
			ResManager.GetInstance().SetOutsideImageSprite(this, this._Image111, GameResPath.GetIcon("composite", "uihc_005a"), true)
			*/

			//this:AddUIEffect2("ui_compound_Rune", this.compound_Rune_group, null, null, true)
			// TODO dxj
			//this.hide_img_y = this.bottom_line.localToGlobal(0, 20).y
			this.InitView()
		}

		this.InitEvent = () => {
			//this.god_radioBtn_group.addEventListener(Laya.UIEvent.CHANGE, ShowSelectRadioButton, this)
			Util.AddClickEvent(this.btnComposite, () => {
				this.model.Fire(local_CompositeModel.CLOSE_CHOSE_GOD_VIEW)
				if (this.success_radio == 0) {
					local_Message.show("材料不足，无法合成")
					return
				}
				let regular_list = []
				let irregular_list = []
				let okFunc = () => {
					this.AddCompositeEffect(() => {
						this.model.Fire(local_CompositeEvent.REQUEST_PROTO, this.rule_id, regular_list, irregular_list)
					}
					)
				}

				let isBind = false
				for (let index in this.model.selected_god_list) {
					let goods_id = this.model.selected_god_list[index]
					if (goods_id) {
						table.insert(regular_list, goods_id)
						if (!isBind) {
							let goodVo = goods_model.GetGoodsVoByGoodsId(goods_id)
							if (goodVo && goodVo.bind == 1) {
								isBind = true
							}
						}
					}
				}
				let i = 0
				do {
					let list = this.regular_mat_cfg[i]
					if (Number(list[0][2]) <= 1) {
						break
					}
					let goods_id = this.model.selected_god_list[i]
					if (!goods_id) {
						break
					}
					let j = 1
					do {
						table.insert(regular_list, goods_id)
						j = j + 1
					} while ((j < Number(list[0][2])))
					i = i + 1
				} while ((i < this.regular_mat_cfg.length))

				if (isBind) {
					Alert.Show("当前合成材料中存在绑定的材料，合成后的装备也将是绑定的，是否确认进行合成？", Alert_Type.Two, okFunc)
				} else {
					okFunc()
				}
			}, this, true)

			this.BindEvent(this.model, local_CompositeEvent.COMPOSE_SUCCESS, (rule_id?, goods_id?) => {
				let c = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_goods_compose.name, rule_id, false)
				if (c && c.type == 11) {
					this.SelectRadioBtn()
					let com_cfg = c
					if (com_cfg) {
						let com_id = erlang_parser.Parse(com_cfg.goods)
						let com = [0, com_id[0][1], 1, goods_id]
						let success_view = new CongratulationObtainView([com], 10)
						success_view.Open()
					}
				}
			})

			this.BindEvent(this.model, local_CompositeEvent.COMPOSE_Fail, () => {
				SoundManager.GetInstance().PlaySoundEffect("guildboss")
				// this.AddUIEffect("effect_hechengshibai", this._gp_effect, null, 2, null, 2, null, null, null, null, null, null, false)
				PlayBigEffect("effect_hechengshibai", null, 2)
				this.SelectRadioBtn()
				//this.CompositeFailAni()
			})

			let OnSelectMatItem = (index?, parms?) => {
				let item = this.mat_item_list[index]
				if (item) {
					item.SetEquipData(parms)
					this.goodsid_to_index[parms.goods_id] = index
				}
				this.UpdateSuccessRatio()
			}
			this.BindEvent(this.model, local_CompositeEvent.SELECT_GOD_GOODS, OnSelectMatItem)

			let OnUninstallEquip = (goods_id?) => {
				let index = this.goodsid_to_index[goods_id]
				let item = this.mat_item_list[index]
				if (item) {
					item.ReSetItem()
					if (this.model.selected_god_list[index]) {
						this.model.selected_god_list[index] = null
					}
					else if (this.model.god_mat_list[index]) {
						this.model.god_mat_list[index] = null
					}
				}
				this.goodsid_to_index[goods_id] = null
				this.UpdateSuccessRatio()
			}
			this.BindEvent(this.model, local_CompositeModel.UNINSTALL_EQUIP, OnUninstallEquip)

			let OnOneKeyAddClick = () => {
				this.model.Fire(local_CompositeModel.CLOSE_CHOSE_GOD_VIEW)
				//let list = this.model.GetGodCompositeList(this.regular_mat_cfg)
				if (!this.cur_com_id) {
					local_Message.show("未解锁装备")
					return
				}
				let index = 0
				let not_enough = false
				let i = 0
				do {
					if (this.hole_list[i] == 1) {
						if (!this.model.selected_god_list[i]) {
							let regular_data = this.regular_mat_cfg[i]
							if (regular_data) {
								let type_id_list = []
								for (let _tmpi in regular_data) {
									let vo = regular_data[_tmpi]
									table.insert(type_id_list, vo[1])
								}
								let mat_list = this.model.GetGodCompositeList(type_id_list)
								if (mat_list) {
									let goodsVo = mat_list[0]
									if (goodsVo) {
										this.model.selected_god_list[i] = goodsVo.goods_id
										this.model.Fire(local_CompositeEvent.SELECT_GOD_GOODS, i, goodsVo)
									} else {
										not_enough = true
									}
								}
							}
						}
						index = index + 1
					}
					i = i + 1
				} while ((i < this.hole_list.length))
				if (not_enough) {
					local_Message.show("没有满足要求的装备~")
					return
				}
			}
			Util.AddClickEvent(this.btnOneKeyAdd, OnOneKeyAddClick, this, true)

			let OnLevelChange = () => {
				this.CreateLeftUITab()
				this.SelectRadioBtn()
				this.SetTabButtom()
				this.SetRadioBottom()
			}
			this.BindEvent(role_mgr, EventName.CHANGE_LEVEL, OnLevelChange)

			let OnRatioChange = () => {
				this.UpdateSuccessRatio()
			}
			this.BindEvent(this.model, local_CompositeModel.UPDATA_GOD_SUCCESS_RATIO, OnRatioChange)

			let update_red = () => {
				if (this.use_delete_method) {
					return
				}
				this.UpdateRedDot()
				this.UpdateSuccessRatio()
			}
			this.BindEvent(goods_model, local_GoodsModel.CHANGE_GOD_BAG_LIST, update_red)
			this.BindEvent(goods_model, local_GoodsModel.CHANGE_GOD_LIST, update_red)
			this.BindEvent(goods_model, local_GoodsModel.CHANGE_BAG_LIST, update_red)
		}

		this.InitView = () => {
			if (this.is_loaded) {
				//if (this.rBtn_weapon ) {
				//    // TODO dxj
				//    //this.god_radioBtn_group = eui. new RadioButtonGroup()
				//    let i = 0
				//    do {
				//        let btn = this.btn_group.getChildAt(i)
				//        if (btn ) {
				//            btn.group = this.god_radioBtn_group
				//        }
				//        i = i + 1
				//    } while ((i < this.btn_group.numChildren))
				//}
				//this.btn_group.validateNow()
				let god_id = GodBefallModel.GetInstance()._com_god_id
				let gdata = GodBefallModel.GetInstance().GetGodData(god_id)
				if (gdata) {
					this.default_index = [gdata.color - 3, 0]
				}

				let list = []
				for (let i = 0; i < this.index_to_type_list.length; i++) {
					let data = { label: "" }
					let label = GodBefallModel.GetInstance().GetGodEquipPosName(i + 1)
					data.label = label
					table.insert(list, data)
				}
				this.tab_loop_list = list
				this.tab_loop_mgr.replaceAll(this.tab_loop_list)
				this.tab_loop_mgr.SetSelectIndex(0)
				//
				/*let i = 0
				do {
					let rBtn = this.btn_group.getChildAt(i)
					if (rBtn)
					{
						rBtn.label = GodBefallModel.GetInstance().GetGodEquipPosName(i + 1)
					}
					i = i + 1
				} while ((i < this.index_to_type_list.length))
				let i = this.index_to_type_list.length
				do {
					let rBtn = this.btn_group.getChildAt(i)
					if (rBtn)
					{
						rBtn.visible = false
					}
					i = i + 1
				} while ((i < this.btn_group.numChildren))
				*/
				this.CreateLeftUITab()
				this.SetTabButtom()
				this.CreateMatItems()
				if (this.tabBar) {
					if (this.default_index && this.default_index.length > 0) {
						this.tabBar.SetSelectTab(this.default_index[0], this.default_index[1])
						this.sub_select_id = this.sub_id_list[this.default_index[0]][this.default_index[1]]
					} else {
						this.tabBar.SetSelectTab(0, this.sub_index_default)
						this.sub_select_id = this.sub_id_list[0][this.sub_index_default]
					}
					//this.tab_group.validateNow()
				}
				this.SelectRadioBtn()
				this.SetRadioBottom()
				this.InitEvent()
			}
		}

		this.SelectRadioBtn = () => {
			if (this.is_loaded) {
				let key = this.sub_select_id + this.index_to_type_list[this.god_group_select_value]
				if (key) {
					key = Number(key)
				}
				this.cur_com_id = local_Config.GetConfigVo(local_Config.ConfigHasDefaultValue.config_goods_compose.name, key, false, this.comp_equip_rule_cfg)
				this.model.selected_god_list = []
				this.model.god_mat_list = []
				this.model.compGod_regular_glist = []
				this.goodsid_to_index = []
				if (this.cur_com_id) {
					this.UpdateView(this.cur_com_id)
				} else {
					key = this.sub_select_id + this.index_to_type_list[0]
					if (key) {
						key = Number(key)
					}
					//this.rBtn_weapon.selected = true
					this.cur_com_id = local_Config.GetConfigVo(local_Config.ConfigHasDefaultValue.config_goods_compose.name, key, false, this.comp_equip_rule_cfg)
					//this.god_group_select_value = 1
					if (this.cur_com_id) {
						this.UpdateView(this.cur_com_id)
					} else {
						this.Clear()
					}
				}
			}
		}

		this.UpdateRedDot = () => {
			this.SetTabButtom()
			this.SetRadioBottom()
		}

		this.Clear = () => {
			if (this.mat_item_list) {
				for (let index in this.mat_item_list) {
					let item = this.mat_item_list[index]
					if (item) {
						item.InitMatData(3)
					}
				}
			}
			if (this.target_item) {
				this.target_item.SetData(0)
				this.target_item.ClearItemEffect()
			}
			this.one_key_add_red.visible = false
			this.composite_red.visible = false
		}

		this.UpdateView = (cfg?) => {
			if (cfg) {
				this.rule_id = cfg.id
				let goods_cfg = erlang_parser.Parse(cfg.goods)
				if (goods_cfg) {
					this.comp_equip_id = goods_cfg[0][1]
					this.SetTargetProperty(this.comp_equip_id)
					this.SetMatData(cfg)
					this.success_type = cfg.ratio_type
					this.success_probability_list = cfg.ratio //erlang_parser:Parse(cfg.ratio)
					this.UpdateSuccessRatio()
					this.one_key_add_red.visible = this.one_key_red_list[this.god_group_select_value]
				}
			}
		}

		this.SetMatData = (cfg?) => {
			if (!cfg) {
				return
			}
			this.hole_list = erlang_parser.Parse(cfg.hole_list)
			for (let k in this.hole_list) {
				let v = this.hole_list[k]
				this.hole_list[k] = Number(v)
			}
			this.regular_mat_cfg = erlang_parser.Parse(cfg.regular_mat)
			this.irregular_mat_cfg = erlang_parser.Parse(cfg.irregular_mat)
			if (this.hole_list) {
				if (!this.mat_item_list) {
					this.mat_item_list = []
				}
				let regular_index = 0
				let irregular_index = 0
				for (let i = 0; i < 5; i++) {
					let mat_item = this.mat_item_list[i]
					if (mat_item) {
						let parms = null
						if ((this.hole_list[i] == 1 && this.regular_mat_cfg) && this.regular_mat_cfg[regular_index]) {
							parms = this.regular_mat_cfg[regular_index]
							regular_index = regular_index + 1
						}
						else if ((this.hole_list[i] == 2 && this.irregular_mat_cfg) && this.irregular_mat_cfg[irregular_index]) {
							parms = this.irregular_mat_cfg[irregular_index]
							irregular_index = irregular_index + 1
						}
						mat_item.InitMatData(this.hole_list[i], parms)
					}
				}
			}
		}

		/*
			0， "" 不算有效值
		*/
		let GetVailTableSize = (list) => {
			if (!list) {
				return 0
			}

			let len = 0
			for (let _ in list) {
				let v = list[_]
				if (v) {
					if (typeof (v) == "number" && v != 0) {
						len = len + 1
					}
					else if (typeof (v) == "string" && v != "") {
						len = len + 1
					}
					else if (typeof (v) == "object") {
						len = len + 1
					}
				}
			}
			return len
		}
		this.UpdateSuccessRatio = () => {
			let goods_count = GetVailTableSize(this.model.selected_god_list)
			if (this.success_type == 1) {
				this.success_radio = 0
				if (this.regular_mat_cfg && goods_count < this.regular_mat_cfg.length) {
					this.success_label.text = "成功率：" + this.success_radio + "%"
					this.composite_red.visible = false
					this.one_key_add_red.visible = this.one_key_red_list[this.god_group_select_value]
					return
				}
				this.success_radio = this.success_probability_list // Number(this.success_probability_list[1])
			}
			this.success_label.text = "成功率：" + this.success_radio + "%"
			if (this.success_radio == 100) {
				this.composite_red.visible = true
				this.one_key_add_red.visible = false
			} else {
				let btn_red = this.one_key_red_list[this.god_group_select_value]
				if (btn_red) {
					this.one_key_add_red.visible = true
				} else {
					this.one_key_add_red.visible = false
				}
				this.composite_red.visible = false
			}
		}

		this.CreateMatItems = () => {
			if (!this.mat_item_list) {
				this.mat_item_list = []
			}
			for (let i = 0; i < 5; i++) {
				let mat = this["mat_pos_" + (i + 1)]
				let item = new CompositeGodBefallItem(mat)
				item.SetIndex(i)
				item.Load()
				this.mat_item_list[i] = item
			}
		}

		this.CreateLeftUITab = () => {
			let list = this.model.GetTabBarData(this.compManu_cfg, this.compManuName_cfg, local_CompositeModel.GodcomposeRule)
			if (!list || list[0].length == 0) {
				return
			}
			if (!this.tabBar) {
				this.tabBar = new UIVerTabBar(this.tab_scroller)
				this.tabBar.Load()
			}
			let call_fun = (tab_index?, sub_index?) => {
				if (this.sub_id_list && this.sub_id_list[tab_index]) {
					this.sub_select_id = this.sub_id_list[tab_index][sub_index]
					this.SetRadioBottom()
					this.SelectRadioBtn()
				}
			}

			this.sub_id_list = list[0]
			if (this.sub_id_list.length > 0) {
				this.tabBar.SetTabBar(list[1], call_fun, GetSizeDeltaY(this.tab_scroller), null, null, null, GetSizeDeltaY(this.tab_scroller))
			}
		}

		this.SetTabButtom = () => {
			let list = this.model.GetGodSubRedDot(this.compManu_cfg)
			this.default_index = this.default_index || []
			let god_id = GodBefallModel.GetInstance()._com_god_id
			for (let i = 0; i < list.length; i++) {
				this.tabBar.setTabRedDot(i, false)
				for (let j = 0; j < list[i].length; j++) {
					let show = list[i][j]
					if (show[0]) {
						if (!god_id) {
							this.default_index[0] = i
							this.default_index[1] = j
						}
						this.tabBar.setTabRedDot(i, true)
						this.tabBar.setSubTabRedDot(i, j, true)
					} else {
						this.tabBar.setSubTabRedDot(i, j, false)
					}
				}
			}
		}

		this.SetRadioBottom = () => {
			this.model.need_goods_list = []
			this.one_key_red_list = []
			let red_mark = false
			for (let i = 0; i < this.index_to_type_list.length; i++) {
				let tab_data = this.tab_loop_list[i]
				let key = this.sub_select_id + this.index_to_type_list[i]
				if (key) {
					key = Number(key)
				}
				let cfg = local_Config.GetConfigVo(local_Config.ConfigHasDefaultValue.config_goods_compose.name, key, false, this.comp_equip_rule_cfg)
				if (!cfg) {
					//if (radioBtn ) {
					//    let red_dot = radioBtn.getChildAt(1)
					//    let Image = radioBtn.getChildAt(0)
					//    local_Util.SetImageGray(Image, true)
					//    radioBtn.touchEnabled = false
					//    red_dot.visible = false
					//}
					if (tab_data) {
						tab_data.red_state = false
					}
					this.one_key_red_list[i] = false
				} else {
					//}
					//if (radioBtn ) {
					//let Image = radioBtn.getChildAt(0)
					//local_Util:SetImageGray(Image, false)
					//radioBtn.touchEnabled = true
					let can_com = this.model.CanCompose(cfg.id)
					let regular_list = erlang_parser.Parse(cfg.regular_mat)
					for (let _tmpi in regular_list) {
						let Vo = regular_list[_tmpi]
						this.model.need_goods_list[Vo[1]] = [Vo[1]]
					}
					let irregular_list = erlang_parser.Parse(cfg.irregular_mat)
					for (let _tmpi in irregular_list) {
						let Vo = irregular_list[_tmpi]
						this.model.need_goods_list[Vo] = [Vo]
					}
					if (can_com) {
						if (tab_data) {
							tab_data.red_state = true
						}
						this.one_key_red_list[i] = true
						if (!red_mark) {
							red_mark = true
							this.god_group_select_value = i
							this.tab_loop_mgr.SetSelectIndex(i)
						}
					} else {
						if (tab_data) {
							tab_data.red_state = false
						}
						this.one_key_red_list[i] = false
					}
				}
			}
			this.tab_loop_mgr.replaceAll(this.tab_loop_list)
			this.one_key_add_red.visible = this.one_key_red_list[this.god_group_select_value]
		}

		this.SetTargetProperty = (type_id?) => {
			if (type_id) {
				if (!this.target_item) {
					this.target_item = new EquipmentItem(this.award_group)
					this.target_item.Load()
					this.target_item.SetItemSize(96, 96)
				}
				this.target_item.SetClickCallBack(() => {
					UIToolTipMgr.GetInstance().AppendGodEquipTips(type_id)
				}
				)
				this.target_item.SetData(type_id)
			}
		}

		this.CompositeFailAni = () => {
			SetLocalPositionY(this.com_fail, 556)
			//this.com_fail.y = 450
			this.com_fail.visible = true
			//this.com_fail.alpha = 1
			//local_laya.Tween.removeTweens(this.com_fail)
			if (this.composite_timeout_id) {
				clearTimeout(this.composite_timeout_id)
			}
			let delay_func = () => {
				if(this.use_delete_method) return
				if (this.com_fail) {
					this.com_fail.visible = false
				}
			}
			this.composite_timeout_id = setTimeout(delay_func, 2000)
			this.tween_id = SYTweenLite.to(this, this.com_fail, SYTweenLite.UiAnimationType.POSY, 450, 0.8)
			//local_laya.Tween.get(this.com_fail):to({y = 300}, 1000):wait(200):to({alpha = 0}, 800).call(delay_func)
		}

		this.AddCompositeEffect = (call_back?) => {
			this.ClearCompositeEffect()
			//this:AddUIEffect2(
			//    "ui_compound_path",
			//    this.compound_path_group,
			//    null,
			//    null,
			//    null,
			//    null,
			//() => {
			//        this.AddUIEffect2("ui_compound_frame_big", this.compound_frame_big_group, null, null, null, null, call_back)
			//        this.AddUIEffect2("ui_compound_boom", this.compound_boom_group)
			//        this.AddUIEffect2("ui_compound_frame", this.compound_frame_group)
			//    }
			//)
			call_back()
		}

		this.ClearCompositeEffect = () => {
			this.ClearUIEffect(this.compound_frame_group)
			this.ClearUIEffect(this.compound_frame_big_group)
			this.ClearUIEffect(this.compound_path_group)
			this.ClearUIEffect(this.compound_boom_group)
		}
	}

	public DeleteMe() {
		if (this.tab_loop_mgr) {
			this.tab_loop_mgr.DeleteMe()
			this.tab_loop_mgr = null
		}
		if (this.mat_item_list) {
			for (let key in this.mat_item_list) {
				this.mat_item_list[key].DeleteMe()
				this.mat_item_list[key] = null
			}
			this.mat_item_list = null
		}
		if (this.tabBar) {
			this.tabBar.DeleteMe()
			this.tabBar = null
		}
		if (this.target_item) {
			this.target_item.DeleteMe()
			this.target_item = null
		}
		if (this.tween_id) {
			SYTweenLite.Stop(this.tween_id)
			this.tween_id = null
		}
		if (this.composite_timeout_id) {
			clearTimeout(this.composite_timeout_id)
		}
		this.ClearCompositeEffect()
		this.ClearUIEffect(this.compound_Rune_group)
		GodBefallModel.GetInstance()._com_god_id = null
		this.compManu_cfg = null
		this.compManuName_cfg = null
		this.comp_equip_rule_cfg = null

		super.DeleteMe()
	}

	public SetVisible(bool?) {
		this.model.Fire(CompositeModel.CLOSE_CHOSE_GOD_VIEW)
		super.SetVisible(bool)
	}

	com_bg: Laya.Image
	_Image3: Laya.Image
	_Image111: Laya.Image
	line_bg: Laya.Image
	_Image8: Laya.Image
	_Label1: Laya.Label
	_Group1: Laya.Box
	_Image4: Laya.Image
	img_line: Laya.Image
	_Label2: Laya.Label
	_Group2: Laya.Image
	_Label3: Laya.Label
	btn_group: Laya.List
	success_label: Laya.Label
	amterial_tip: Laya.Box
	_Image7: Laya.Image
	_Label4: Laya.Label
	compound_Rune_group: Laya.Box
	compound_frame_big_group: Laya.Box
	compound_boom_group: Laya.Box
	award_group: Laya.Box
	compound_path_group: Laya.Box
	compound_frame_group: Laya.Box
	mat_group: Laya.Box
	mat_pos_1: Laya.Box
	mat_pos_2: Laya.Box
	mat_pos_3: Laya.Box
	mat_pos_4: Laya.Box
	mat_pos_5: Laya.Box
	tab_scroller: Laya.Box
	com_fail: Laya.Image
	btnOneKeyAdd: Laya.Box
	_Image11: Laya.Image
	labelDisplay: Laya.Label
	one_key_add_red: Laya.Image
	btnComposite: Laya.Box
	_Image1: Laya.Image
	labelDisplay1: Laya.Label
	composite_red: Laya.Image
	_gp_effect: Laya.Box
	public GetComponents() {
		[
			this.com_bg,
			this._Image3,
			this._Image111,
			this.line_bg,
			this._Image8,
			this._Label1,
			this._Group1,
			this._Image4,
			this.img_line,
			this._Label2,
			this._Group2,
			this._Label3,
			this.btn_group,
			this.success_label,
			this.amterial_tip,
			this._Image7,
			this._Label4,
			this.compound_Rune_group,
			this.compound_frame_big_group,
			this.compound_boom_group,
			this.award_group,
			this.compound_path_group,
			this.compound_frame_group,
			this.mat_group,
			this.mat_pos_1,
			this.mat_pos_2,
			this.mat_pos_3,
			this.mat_pos_4,
			this.mat_pos_5,
			this.tab_scroller,
			this.com_fail,
			this.btnOneKeyAdd,
			this._Image11,
			this.labelDisplay,
			this.one_key_add_red,
			this.btnComposite,
			this._Image1,
			this.labelDisplay1,
			this.composite_red,
			this._gp_effect,
		]
			= this.GetChildrenByNames([

				"com_bg",
				"_Image3",
				"_Image111",
				"line_bg",
				"_Image8",
				"_Label1",
				"_Group1",
				"_Image4",
				"img_line",
				"_Label2",
				"_Group2",
				"_Label3",
				"btn_group",
				"success_label",
				"amterial_tip",
				"_Image7",
				"_Label4",
				"compound_Rune_group",
				"compound_frame_big_group",
				"compound_boom_group",
				"award_group",
				"compound_path_group",
				"compound_frame_group",
				"mat_group",
				"mat_pos_1",
				"mat_pos_2",
				"mat_pos_3",
				"mat_pos_4",
				"mat_pos_5",
				"tab_scroller",
				"com_fail",
				"btnOneKeyAdd",
				"_Image11",
				"labelDisplay",
				"one_key_add_red",
				"btnComposite",
				"_Image1",
				"labelDisplay1",
				"composite_red",
				"_gp_effect",
			])
	}
}
window["GodBefallCompositeView"] = GodBefallCompositeView
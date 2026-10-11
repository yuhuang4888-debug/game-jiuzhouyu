import { BaseItem1 } from "../common/BaseItem1"
import { table } from "../common/table"
import { Util, GetSizeDeltaY } from "../util/Util"
import { Config } from "../common/Config"
import { ResManager } from "../common/ResManager"
import { TimeUtil } from "../util/TimeUtil"
import { UIVerTabBar } from "../newgameui/UIVerTabBar"
import { CongratulationObtainView } from "../common/CongratulationObtainView"
import { GoodsModel } from "../commonModel/GoodsModel"
import { ErlangParser } from "../util/ErlangParser"
import { CompositeModel, CompositeEvent } from "../commonModel/CompositeModel"
import { GodCourtModel } from "../commonModel/GodCourtModel"
import { Message } from "../sysInfo/SysInfoController"
import { CommonRuleView } from "../common/CommonRuleView"
import { EquipmentItem } from "../common/EquipmentItem"
import { GodCourtComItem } from "./GodCourtComItem"
import { SoundManager } from "../common/SoundManager"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { GodCourtTooltip } from "../common/GodCourtTooltip"

import "./GCComSelectView"

export class GodCourtComView extends BaseItem1 {
	ChangeSuccess
	Clear
	ClearCompositeEffect
	CreateLeftUITab
	CreateMatItems
	DeleteMe1

	GetSubRedDot
	InitEvent
	InitView
	LoadSuccess
	//PostList1
	//PostList2
	SelectComTab
	SetMatData
	SetTabButtom
	SetTargetProperty
	ShowRuleView
	UpdateRedDot
	UpdateView

	tabBar
	waitid
	res_mgr
	cfg_rule

	public constructor(parent?) {
		super(parent)
		this.base_file = "composite"
		this.layout_file = "GodCourtComView"
		this.preload_client_config = {
			"ClientRuleViewConfig": false
		}

		this.res_mgr = ResManager.GetInstance()
		let composite_model = CompositeModel.GetInstance()
		let goods_model = GoodsModel.GetInstance()
		let godCourt_model = GodCourtModel.GetInstance()
		let local_erlang = ErlangParser.GetInstance()

		//this.PostList1 = [0, 883, 886, 870];
		//this.PostList2 = [-77, 932, 935, 900];
		//let local_mainRoleVo = RoleManager.GetInstance().GetMainRoleVo()
		let sub_index_default_ = 0
		let tab_index_default_ = 0
		let mat_item_list_ = null
		let mark_click_matPosType_ = null
		let mark_click_mat_pos_ = null
		let compManu_cfg_ = null
		let compManuName_cfg_ = null
		let comp_equip_rule_cfg_ = null
		let regular_mat_cfg_ = null
		let irregular_mat_cfg_ = null
		let mat_pos_type_ = []
		let cur_tab_index_ = null
		let cur_sub_index_ = null
		let tabIndexToId_ = []
		let goodsid_to_index_ = []
		let EquipID_Group_ = []
		let comp_equip_id_ = null
		let cur_compEquip_rule_ = null
		let regular_mat_gList_ = []
		let irregular_mat_gList_ = []
		let success_radio_ = null
		let one_key_red_list_ = []
		let target_item_ = null
		let first_sub_id_ = null
		let sec_sub_id_ = null
		let sub_id_list_ = null
		let rule_id_ = null
		let default_index_ = null
		let sub_select_id_ = null
		let success_probability_list_ = null
		let success_type_ = null
		let target_type_id_ = null
		let radio_btn_list_ = []
		let index_to_type_list_ = [0, 3, 6, 4, 1, 5, 7, 2]
		let tab_id_and_anme_list_ = null
		let hole_list_ = null
		let select_mat_index_ = null
		let cur_com_id_ = null
		let hide_img_y_ = null
		let regularMatItem = null
		let clickTime = null

		this.load_callback = () => {
			this.LoadSuccess()
		}

		this.LoadSuccess = () => {
			this.cfg_rule = this.res_mgr.GetGameConfigFromCache(this, "ClientRuleViewConfig", true)
			compManu_cfg_ = Config.PRELOAD_SERVER_CONFIG.config_compose_menu
			compManuName_cfg_ = Config.PRELOAD_SERVER_CONFIG.config_compose_menu_id
			comp_equip_rule_cfg_ = Config.PRELOAD_SERVER_CONFIG.config_goods_compose
			this.res_mgr.SetOutsideImageSprite(this, this._img_bg2, "resource/game/composite/other/ui_merge_01.png")

			this.InitView()
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this.btnComposite, () => {
				if (clickTime && clickTime > TimeUtil.getServerTimeMs()) {
					return
				}
				clickTime = TimeUtil.getServerTimeMs() + 1000
				//let enough = true
				let selectedList = []
				let regular_list = []
				let regularCfg = local_erlang.Parse(cur_compEquip_rule_.regular_mat)
				for (let _tmpi in regularCfg) {
					let regularVo = regularCfg[_tmpi]
					let needCount = Number(regularVo[0][2])
					let goodsList = goods_model.GetTypeGoods(Number(regularVo[0][1]))
					let useOver = false
					for (let _tmpi in goodsList) {
						let vo = goodsList[_tmpi]
						let i = 0
						let count = 0
						do {
							if (selectedList[vo.goods_id] && selectedList[vo.goods_id] >= vo.goods_num) {
								useOver = true
								break
							}
							needCount = needCount - 1
							count = count + 1
							table.insert(regular_list, vo.goods_id)
							if (!selectedList[vo.goods_id]) {
								selectedList[vo.goods_id] = 1
							} else {
								selectedList[vo.goods_id] = selectedList[vo.goods_id] + 1
							}
							if (count == vo.goods_num) {
								break
							}
						} while ((i < needCount))
						if (needCount == 0) {
							break
						}
					}
					if (needCount > 0) {
						Message.show("材料不足")
						return
					}
				}
				let irregular_list = []
				let irregularCfg = local_erlang.Parse(cur_compEquip_rule_.irregular_mat)
				let needCount = irregularCfg.length
				for (let index in godCourt_model.comSelect) {
					table.insert(irregular_list, index)
				}
				if (irregular_list.length < needCount) {
					Message.show("材料不足")
					return
				}
				composite_model.Fire(CompositeEvent.REQUEST_PROTO, rule_id_, regular_list, irregular_list)
			}, this, true)

			this.BindEvent(composite_model, CompositeEvent.COMPOSE_SUCCESS, (rule_id?, goods_id?) => {
				if (rule_id == rule_id_) {
					if (cur_compEquip_rule_) {
						let com_id = local_erlang.Parse(cur_compEquip_rule_.goods)
						let com = [0, com_id[0][1], 1, goods_id]
						let success_view = new CongratulationObtainView([com], 10)
						success_view.Open()
					}
					godCourt_model.ClearComSelect()
					this.UpdateRedDot()
					//this.SelectComTab()
				}
			})
			this.BindEvent(composite_model, CompositeEvent.COMPOSE_Fail, () => {
				SoundManager.GetInstance().PlaySoundEffect("guildboss")
				this.AddUIEffect("effect_hechengshibai", this._gp_effect, null, 2, null, 2, null, null, null, null, null, null, false)
				godCourt_model.ClearComSelect()
				this.UpdateRedDot()
				//this.SelectComTab()
			})
			let OnSelectMatItem = (goods_id?, select?, index?) => {
				if (!goods_id) {
					return
				}
				if (select) {
					let item = mat_item_list_[index]
					if (item) {
						let goodsVo = goods_model.GetGoodsVoByGoodsId(goods_id)
						item.SetEquipData(goodsVo)
						goodsid_to_index_[goods_id] = index
					}
				} else {
					let index = goodsid_to_index_[goods_id]
					let item = mat_item_list_[index]
					if (item) {
						item.ReSetItem()
					}
					goodsid_to_index_[goods_id] = null
				}
				this.ChangeSuccess()
			}
			this.BindEvent(godCourt_model, GodCourtModel.SELECT_COM_MAT, OnSelectMatItem)

			let OnOneKeyAddClick = () => {
				//let index = 0
				let not_enough = false
				let irregular_index = 0
				let selectList = []
				for (let key in godCourt_model.comSelect) {
					selectList[godCourt_model.comSelect[key]] = true
				}
				let i = 0
				do {
					if (hole_list_[i] == "2") {
						if (!selectList[i]) {
							let regular_data = irregular_mat_cfg_[irregular_index]
							if (regular_data) {
								let type_id_list = []
								for (let _tmpi in regular_data) {
									let vo = regular_data[_tmpi]
									type_id_list[Number(vo)] = true
								}
								not_enough = true
								let goodsList = goods_model.godCourtBagList
								for (let _tmpi in goodsList) {
									let goodsVo = goodsList[_tmpi]
									if (type_id_list[goodsVo.type_id] && godCourt_model.comSelect[goodsVo.goods_id] == null) {
										godCourt_model.SelectComMat(goodsVo.goods_id, i, true)
										not_enough = false
										break
									}
								}
							}
						}
						irregular_index = irregular_index + 1
					}
					i = i + 1
				} while ((i < hole_list_.length))
				this.ChangeSuccess()
				if (not_enough) {
					Message.show("没有满足要求的装备~")
				}
			}
			Util.AddClickEvent(this.btnOneKeyAdd, OnOneKeyAddClick, this, true)

			let OnGoodsChange = () => {
				if (this.use_delete_method) {
					return
				}
				this.SetTabButtom()
			}
			this.BindEvent(goods_model, GoodsModel.CHANGE_BAG_LIST, OnGoodsChange)
			this.BindEvent(goods_model, GoodsModel.CHANGE_GODCOURT_BAG, OnGoodsChange)

			Util.AddClickEvent(this.ruleBtn, () => {
				this.ShowRuleView()
			}, this, true)
		}

		this.InitView = () => {
			if (this.is_loaded) {
				if (!default_index_) {
					default_index_ = []
				}
				this.CreateLeftUITab()
				this.SetTabButtom()
				this.CreateMatItems()
				if (this.tabBar && sub_id_list_) {
					if (default_index_.length > 0) {
						this.tabBar.SetSelectTab(default_index_[0], default_index_[1])
						sub_select_id_ = Number(sub_id_list_[default_index_[0]][default_index_[1]])
					} else {
						this.tabBar.SetSelectTab(tab_index_default_, sub_index_default_)
						sub_select_id_ = Number(sub_id_list_[tab_index_default_][sub_index_default_])
					}
					//this.tab_group.validateNow()
				}
				if (composite_model.composite_manu_cfg) {
					let manuConfig = composite_model.composite_manu_cfg[CompositeModel.EquipmentComposeRule]
					if (manuConfig) {
						tabIndexToId_ = local_erlang.Parse(manuConfig.list)
					}
				}
				this.SelectComTab()
				this.InitEvent()
			}
		}

		this.UpdateRedDot = () => {
			this.SetTabButtom()
			this.SelectComTab()
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
			if (regularMatItem) {
				regularMatItem.InitmatData(3)
			}
			if (target_item_) {
				target_item_.SetData(0)
				target_item_.ClearItemEffect()
			}
			//this.one_key_add_red.visible = false
			//this.composite_red.visible = false
		}

		this.UpdateView = (cfg?) => {
			if (cfg) {
				cur_compEquip_rule_ = cfg
				rule_id_ = cfg.id
				let goods_cfg = local_erlang.Parse(cfg.goods)
				if (goods_cfg && goods_cfg[0]) {
					comp_equip_id_ = goods_cfg[0][1]
					this.SetTargetProperty(comp_equip_id_)
					this.SetMatData(cfg)
					success_type_ = cfg.ratio_type
					success_probability_list_ = local_erlang.Parse(cfg.ratio)
					this.ChangeSuccess()
				}
			}
		}

		this.SetMatData = (cfg?) => {
			hole_list_ = local_erlang.Parse(cfg.hole_list)
			regular_mat_cfg_ = local_erlang.Parse(cfg.regular_mat)
			if ((hole_list_.length >= 6 && hole_list_[5] == "1") && regular_mat_cfg_.length > 0) {
				this.reMatGp.visible = true
				this.reMatBg.visible = true
				regularMatItem.InitMatData(1, regular_mat_cfg_[regular_mat_cfg_.length - 1][0])
			} else {
				this.reMatGp.visible = false
				this.reMatBg.visible = false
			}
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
						let type = Number(hole_list_[i])
						if ((type == 1 && regular_mat_cfg_) && regular_mat_cfg_[regular_index]) {
							parms = regular_mat_cfg_[regular_index][0]
							regular_index = regular_index + 1
						} else if ((type == 2 && irregular_mat_cfg_) && irregular_mat_cfg_[irregular_index]) {
							parms = irregular_mat_cfg_[irregular_index]
							irregular_index = irregular_index + 1
						}
						mat_item.InitMatData(type, parms)
						index = index + 1
					}
					i = i + 1
				} while ((i < 5))
			}
		}

		this.CreateMatItems = () => {
			if (!mat_item_list_) {
				mat_item_list_ = []
			}
			let i = 0
			do {
				let mat = this["mat_pos_" + i]
				let item = new GodCourtComItem(mat)
				item.SetIndex(i)
				item.Load()
				mat_item_list_[i] = item
				i = i + 1
			} while ((i < 5))
			if (!regularMatItem) {
				regularMatItem = new GodCourtComItem(this.reMatGp)
				regularMatItem.SetIndex(5)
				regularMatItem.Load()
			}
		}

		this.CreateLeftUITab = () => {
			let list = composite_model.GetTabBarData(compManu_cfg_, compManuName_cfg_, GodCourtModel.ComId)
			if (!list || list[0].length == 0) {
				return
			}
			if (!this.tabBar) {
				this.tabBar = new UIVerTabBar(this._scroll_tab)
				this.tabBar.Load()
			}
			let call_fun = (tab_index?, sub_index?) => {
				if (sub_id_list_ && sub_id_list_[tab_index]) {
					cur_tab_index_ = tab_index
					sub_select_id_ = Number(sub_id_list_[tab_index][sub_index])
					this.compose_equip_group.visible = true
					godCourt_model.ClearComSelect()
					this.SelectComTab()
				}
			}

			godCourt_model.godcourt_com_id_list = list[0]
			sub_id_list_ = list[0]
			if (sub_id_list_.length > 0) {
				this.tabBar.SetTabBar(list[1], call_fun, GetSizeDeltaY(this._scroll_tab), null, null, null, GetSizeDeltaY(this._scroll_tab))
				sub_index_default_ = list[0][0].length - 1
			}
		}

		this.SetTabButtom = () => {
			let list = this.GetSubRedDot()
			for (let i in list) {
				let ShowRed = null
				for (let j in list[i]) {
					let show = list[i][j]
					if (show) {
						default_index_[0] = Number(i)
						default_index_[1] = Number(j)
						ShowRed = true
						this.tabBar.setSubTabRedDot(Number(i), Number(j), true)
					} else {
						this.tabBar.setSubTabRedDot(Number(i), Number(j), false)
					}
				}
				this.tabBar.setTabRedDot(Number(i), ShowRed)
			}
		}

		this.SelectComTab = () => {
			let comCfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_goods_compose.name, sub_select_id_, false, comp_equip_rule_cfg_)
			this.UpdateView(comCfg)
		}

		this.SetTargetProperty = (type_id?) => {
			if (type_id) {
				if (!target_item_) {
					target_item_ = new EquipmentItem(this.award_group)
					target_item_.Load()
					target_item_.SetItemSize(80, 80)
				}
				target_item_.SetClickCallBack(() => {
					UIToolTipMgr.GetInstance().AppendGodCourtTips(type_id, null, null, [GodCourtTooltip.Btn.close])
				})
				target_item_.SetData(type_id)
			}
		}

		this.ShowRuleView = () => {
			let ruleConfig = this.cfg_rule
			if (ruleConfig) {
				let ShowConfig = ruleConfig["comGodCourt"]
				if (ShowConfig) {
					let ruleView = new CommonRuleView()
					ruleView.Open(ShowConfig["content"])
					ruleView.SetTitle(ShowConfig["title"])
				}
			}
		}

		this.ChangeSuccess = () => {
			//let success = 0
			if (cur_compEquip_rule_) {
				let ratioType = cur_compEquip_rule_.ratio_type
				if (ratioType == 1) {
					//let success = 0
					let size = Util.TableSize(godCourt_model.regualrMatList)
					let hole_list = ErlangParser.GetInstance().Parse(cur_compEquip_rule_.hole_list)
					for (let _tmpi in hole_list) {
						let vo = hole_list[_tmpi]
						if (vo == '1') {
							size = size - 1
						}
					}
					if (size == 0) {
						this.success_label.text = "成功率：" + cur_compEquip_rule_.ratio + "%"
					} else {
						this.success_label.text = "成功率：0%"
					}
				} else if (ratioType == 2) {
					let size = Util.TableSize(godCourt_model.comSelect)
					let ratioList = local_erlang.Parse(cur_compEquip_rule_.ratio)
					this.success_label.text = "成功率：" + (ratioList[size - 1] && ratioList[size - 1][1] || "0") + "%"
				}
			}
		}

		this.GetSubRedDot = () => {
			let list = godCourt_model.godcourt_com_id_list
			//let comRed = false
			let returnList = []
			for (let _tmpi in list) {
				let tabList = list[_tmpi]
				let subRedList = []
				for (let _tmpi in tabList) {
					let subVo = tabList[_tmpi]
					subRedList.push(CompositeModel.GetInstance().CanCompose(subVo))
				}
				returnList.push(subRedList)
			}
			return returnList
		}

		this.ClearCompositeEffect = () => {
			//this:ClearUIEffect(this.compound_frame_group)
			//this:ClearUIEffect(this.compound_frame_big_group)
			//this:ClearUIEffect(this.compound_path_group)
			//this:ClearUIEffect(this.compound_boom_group)
		}

		this.DeleteMe1 = () => {
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
			if (this.waitid) {
				clearTimeout(this.waitid)
				this.waitid = null
			}
			if (regularMatItem) {
				regularMatItem.DeleteMe()
				regularMatItem = null
			}
			//this:ClearCompositeEffect()
			//this:ClearUIEffect(this.compound_Rune_group)
			compManu_cfg_ = null
			compManuName_cfg_ = null
			comp_equip_rule_cfg_ = null
			//let i = 0
			//do {
			//// [ts2lua]this下标访问可能不正确
			//this:ClearUIEffect(this["lineGp" + i])
			//i=i+1
			//} while ((i < 6))
		}
	}

	public DeleteMe() {
		this.DeleteMe1()
		super.DeleteMe()
	}

	compose_equip_group: Laya.Box
	_img_bg1: Laya.Image
	reMatBg: Laya.Image
	_img_bg2: Laya.Image
	success_label: Laya.Label
	ruleBtn: Laya.Image
	award_group: Laya.Box
	mat_group: Laya.Box
	mat_pos_0: Laya.Box
	mat_pos_1: Laya.Box
	mat_pos_2: Laya.Box
	mat_pos_3: Laya.Box
	mat_pos_4: Laya.Box
	btnOneKeyAdd: Laya.Box
	_Image1: Laya.Image
	labelDisplay1: Laya.Label
	one_key_add_red: Laya.Image
	btnComposite: Laya.Box
	_Image11: Laya.Image
	labelDisplay: Laya.Label
	composite_red: Laya.Image
	reMatGp: Laya.Box
	_img_bg0: Laya.Image
	_Image0: Laya.Image
	title: Laya.Label
	_scroll_tab: Laya.Box
	_gp_effect: Laya.Box
	public GetComponents() {
		[
			this.compose_equip_group,
			this._img_bg1,
			this.reMatBg,
			this._img_bg2,
			this.success_label,
			this.ruleBtn,
			this.award_group,
			this.mat_group,
			this.mat_pos_0,
			this.mat_pos_1,
			this.mat_pos_2,
			this.mat_pos_3,
			this.mat_pos_4,
			this.btnOneKeyAdd,
			this._Image1,
			this.labelDisplay1,
			this.one_key_add_red,
			this.btnComposite,
			this._Image11,
			this.labelDisplay,
			this.composite_red,
			this.reMatGp,
			this._img_bg0,
			this._Image0,
			this.title,
			this._scroll_tab,
			this._gp_effect,
		]
			= this.GetChildrenByNames([

				"compose_equip_group",
				"_img_bg1",
				"reMatBg",
				"_img_bg2",
				"success_label",
				"ruleBtn",
				"award_group",
				"mat_group",
				"mat_pos_0",
				"mat_pos_1",
				"mat_pos_2",
				"mat_pos_3",
				"mat_pos_4",
				"btnOneKeyAdd",
				"_Image1",
				"labelDisplay1",
				"one_key_add_red",
				"btnComposite",
				"_Image11",
				"labelDisplay",
				"composite_red",
				"reMatGp",
				"_img_bg0",
				"_Image0",
				"title",
				"_scroll_tab",
				"_gp_effect",
			])
	}
}
window["GodCourtComView"] = GodCourtComView
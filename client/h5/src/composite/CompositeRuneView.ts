import { BaseItem1 } from "../common/BaseItem1"
import { Util, GetSizeDeltaY, HtmlColorTxt } from "../util/Util"
import { Message } from "../sysInfo/SysInfoController"
import { GoodsModel } from "../commonModel/GoodsModel"
import { RuneModel, RuneEvent } from "../commonModel/RuneModel"
import { CompositeModel, CompositeEvent } from "../commonModel/CompositeModel"
import { ColorUtil, Enum_ColorUtil_Dark } from "../util/ColorUtil"
import { ErlangParser } from "../util/ErlangParser"
import { RoleManager } from "../commonModel/RoleManager"
import { Alert, Alert_Type } from "../alert/Alert"
import { Config } from "../common/Config"
import { CongratulationObtainView } from "../common/CongratulationObtainView"
import { UIVerTabBar } from "../newgameui/UIVerTabBar"
import { EquipmentItem } from "../common/EquipmentItem"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { BaseAwardItem } from "../common/BaseAwardItem"
import { RuneComposeCostItem } from "./RuneComposeCostItem"
import { CookieWrapper } from "../common/CookieWrapper"
import { PlatformManager } from "../PlatformManager"

export class CompositeRuneView extends BaseItem1 {
	Content
	EmpcomposeBtn
	UpdateComposePreView
	HaveEnoughCost
	InitEvents
	LoadSuccess
	LocalDeleteMe
	OutlabelDisplay
	RefreshRedDot
	Scrscroll
	SetComposeMatView
	SetCheckState
	SetData
	SetOtherCost
	ShowTargetProperty
	SwitchView
	cost_item
	cur_sub_tab_index
	cur_tab_index
	item_list
	level_limit
	model
	now_compose_cfg
	now_target_type_id
	other_cost_is_enough
	tab_bar
	tab_id_and_anme_list
	target_item
	use_to_compose
	res_mgr
	cfg_menu
	cfg_menu_id
	select_comId

	public constructor(parent?) {
		super(parent)
		this.cur_tab_index = -1
		this.cur_sub_tab_index = -1
		this.item_list = []
		this.level_limit = 0
		this.other_cost_is_enough = true
		this.base_file = "composite"
		this.layout_file = "CompositeRuneView"
		this.preload_server_config = {
			"config_compose_menu": false,
			"config_compose_menu_id": false,
			"config_rune_attr_coefficient": false,
			"config_rune_wake_up": false
		}

		this.model = CompositeModel.GetInstance()
		let rune_model = RuneModel.GetInstance()
		let goods_model = GoodsModel.GetInstance()
		let local_Message = Message
		let local_CompositeEvent = CompositeEvent
		let local_RuneEvent = RuneEvent
		let erlang_parser = ErlangParser.GetInstance()
		let local_ColorUtil = ColorUtil
		this.res_mgr = ResManager.GetInstance()

		this.load_callback = () => {
			if (PlatformManager.IsEyouEnPlatform()) {
				this._Label21.height = 39
				this._Label21.width = 149
				this._Label21.leading = 0.1
				this._Label21.wordWrap =true
				this._Label21.pos(10,16)
				this._Label21.align="center"
				this._Label21.valign="middle"
				this._Label21.fontSize = 20
			}
			this.LoadSuccess()
			this.InitEvents()
			/*
			if (PlatformMgr.GetInstance().IsEyouIdnPlatform()) {
				this.condition.size = 18
			}
			*/
		}

		this.LocalDeleteMe = () => {
			this.use_to_compose = null
			if (this.target_item) {
				this.target_item.DeleteMe()
				this.target_item = null
			}
			if (this.cost_item) {
				this.cost_item.DeleteMe()
				this.cost_item = null
			}
			for (let _tmpi in this.item_list) {
				let item = this.item_list[_tmpi]
				item.DeleteMe()
			}
			this.item_list = []
			if (this.tab_bar) {
				this.tab_bar.DeleteMe()
				this.tab_bar = null
			}
			this.model.ReSetRuneComposeAwake()
		}

		this.LoadSuccess = () => {
			rune_model.Fire(local_RuneEvent.RUNE_REQUEST_PROTO, 16704)
			this.cfg_menu = this.res_mgr.GetGameConfigFromCache(this, "config_compose_menu", false)
			this.cfg_menu_id = this.res_mgr.GetGameConfigFromCache(this, "config_compose_menu_id", false)
			this.res_mgr.SetOutsideImageSprite(this, this._img_1, "resource/game/composite/other/ui_merge_12.png")

			this.condition.width = 500
			this.condition.style.fontSize = 20
			this.condition.style.color = "#d15e00"
			this.condition.style.wordWrap = false

			this.cost_num.width = 140
			this.cost_num.style.fontSize = 20
			this.cost_num.style.color = "#663519"

			this.target_pro.width = 250
			this.target_pro.style.fontSize = 20
			this.target_pro.style.color = "#663915"
			this.target_pro.style.leading = 20
		}

		this.InitEvents = () => {
			Util.AddClickEvent(this.composeBtn, () => {
				if (RoleManager.GetInstance().mainRoleInfo.level > this.level_limit) {
					this.UpdateComposePreView(true)
					if (this.HaveEnoughCost()) {
						//let isBind = false
						let okFunc = () => {
							RuneModel.GetInstance().RequestComposite(this.use_to_compose)
							//this.model.Fire(local_CompositeEvent.REQUEST_PROTO, this.use_to_compose.rule_id, this.use_to_compose.regular_glist, this.use_to_compose.specify_glist)
						}
						// for (let _tmpi in this.use_to_compose.specify_glist) {
						// 	let vo = this.use_to_compose.specify_glist[_tmpi]
						// 	let goodsVo = goods_model.GetGoodsVoByGoodsId(vo)
						// 	if (goodsVo && goodsVo.bind != 0) {
						// 		isBind = true
						// 		break
						// 	}
						// }
						// if (!isBind) {
						// 	for (let _tmpi in this.use_to_compose.regular_glist) {
						// 		let vo = this.use_to_compose.regular_glist[_tmpi]
						// 		let goodsVo = goods_model.GetGoodsVoByGoodsId(vo)
						// 		if (goodsVo && goodsVo.bind != 0) {
						// 			isBind = true
						// 			break
						// 		}
						// 	}
						// }
						// if (isBind) {
						// 	Alert.Show("当前合成材料中存在绑定的材料，合成后的装备也将是绑定的，是否确认进行合成？", Alert_Type.Two, okFunc)
						// } else {
						okFunc()
						// }
					} else {
						// local_Message.show("材料不足")
						this.model.Fire(local_CompositeEvent.OPEN_VIEW, "CompositeGetMatView", "CompositeRuneView")
					}
				} else {
					local_Message.show("等级需要达到" + this.level_limit + "级才能合成")
				}
			}, this, true)

			Util.AddClickEvent(this._gp_check, () => {
				if (this.select_comId) {
					let ignore = this._img_check.visible
					let key = "rune" + this.select_comId
					let value = ignore ? "1" : "0"
					CookieWrapper.GetInstance().SaveCookie(key, value)
					this._img_check.visible = !ignore
					this.RefreshRedDot()
					this.model.RuneComposeRedDot()
				}
			}, this)

			this.BindEvent(this.model, local_CompositeEvent.REFRESH_MSG_AFTER_SELECT, (vo?) => {
				this.UpdateComposePreView()
				if (this.target_item) {
					let list = this.model.RuneComposeAwakeList()
					this.target_item.SetAwake(list.length > 0)
				}
			})

			this.BindEvent(rune_model, local_RuneEvent.COMPOSE_PREVIEW_RETURN, (vo?) => {
				if (vo) {
					this.ShowTargetProperty(vo.lv)
				}
			})

			this.BindEvent(this.model, local_CompositeEvent.COMPOSE_SUCCESS, (rule_id?, goods_id?) => {
				let com_cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_goods_compose.name, rule_id, false)
				if (com_cfg && com_cfg.type == 3) {
					let com_id = erlang_parser.Parse(com_cfg.goods)
					let com = [0, com_id[0][1], 1, goods_id]
					let success_view = new CongratulationObtainView([com], 10)
					success_view.Open()
					this.model.ReSetRuneComposeAwake()
					let [tmp, tmp2] = this.RefreshRedDot()
					this.model.RuneComposeRedDot()
				}
				this.SetData()
			})

			let update_fun = () => {
				this.SetData()
			}
			this.BindEvent(rune_model, local_RuneEvent.UPDTE_RUNE_CONVERT_VIEW, update_fun)

			this.BindEvent(goods_model, GoodsModel.UPDATE_GOODS_NUM, () => {
				if (this.use_delete_method) {
					return
				}
				this.RefreshRedDot()
				this.SetOtherCost()
				// this.GetComposePreView()
			})

			this.SetData()
		}

		this.SetData = () => {
			if (!this.tab_id_and_anme_list) {
				this.tab_id_and_anme_list = this.model.GetRuneComposeData(this.cfg_menu, this.cfg_menu_id)
			}
			if (!this.tab_bar) {
				this.tab_bar = new UIVerTabBar(this.scroll_group)
				this.tab_bar.Load()
			}
			let call_fun = (tab_index?, sub_index?) => {
				if (!this.display_obj.visible) {
					return
				}
				this.model.ReSetRuneComposeAwake()
				this.SwitchView(tab_index, sub_index)
			}

			this.tab_bar.SetTabBar(this.tab_id_and_anme_list[1], call_fun, GetSizeDeltaY(this.scroll_group), null, null, null, GetSizeDeltaY(this.scroll_group))
			if (this.cur_tab_index == -1 && this.cur_sub_tab_index == -1) {
				let index, sub_index
				[index, sub_index] = this.RefreshRedDot()
				this.tab_bar.SetSelectTab(index, sub_index)
			} else {
				this.tab_bar.SetSelectTab(this.cur_tab_index, this.cur_sub_tab_index)
			}
		}

		this.SwitchView = (tab_index?, sub_index?) => {
			this.cur_tab_index = tab_index
			this.cur_sub_tab_index = sub_index
			let [tmp, tmp2] = this.RefreshRedDot()
			this.SetComposeMatView(tab_index, sub_index)
			this.SetCheckState(tab_index, sub_index)
			this.UpdateComposePreView()
		}

		this.SetComposeMatView = (tab_index?, sub_index?) => {
			if (this.tab_id_and_anme_list[0][tab_index] && this.tab_id_and_anme_list[0][tab_index][1]) {
				this.now_compose_cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_goods_compose.name, this.tab_id_and_anme_list[0][tab_index][1][sub_index], false)
				this.level_limit = (this.now_compose_cfg && (this.now_compose_cfg.role_lv) || (0))
				if (this.now_compose_cfg) {
					if (!this.target_item) {
						this.target_item = new EquipmentItem(this.target_conta)
						this.target_item.Load()
						this.target_item.SetItemSize(80, 80)
					}
					this.rune_name.text = this.now_compose_cfg.name
					//let index = this.now_compose_cfg.id % 100
					//let res = index > 10 && ("rune_" + index) || ("rune_0" + index)
					//ResManager.GetInstance().SetImageSprite(this, this._Image2, "composite_asset", res)
					let goods = erlang_parser.Parse(this.now_compose_cfg.goods)
					if (goods) {
						this.now_target_type_id = goods[0][1]
						this.target_item.SetData(goods[0][1])
						this.target_item.SetClickCallBack(() => {
							let goodsVo = {};
							goodsVo["awake_list"] = this.model.RuneComposeAwakeList();
							goodsVo["comPre"] = true;

							let basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(this.now_target_type_id);
							if (basic.type == 26) { // 御魂
								UIToolTipMgr.GetInstance().AppendIllusionTips(this.now_target_type_id, null, null, basic)
							} else {
								UIToolTipMgr.GetInstance().AppendGoodsTips(this.now_target_type_id, null, null, goodsVo)
							}
						}
						)
					}
					//for (let _tmpi in this.item_list) {
					//let item = this.item_list[_tmpi]
					//item:DeleteMe()
					//}
					//this.item_list = []
					let mat = erlang_parser.Parse(this.now_compose_cfg.regular_mat)
					if (mat) {
						let item: RuneComposeCostItem = null
						let i = 0
						if (i < mat.length) {
							do {
								if (i < 2) {
									item = this.item_list[i]
									if (!item) {
										if (i == 0) {
											item = new RuneComposeCostItem(this.item_conta0)
										} else {
											item = new RuneComposeCostItem(this.item_conta1)
										}
										table.insert(this.item_list, item)
										item.Load()
									}
									item.SetData(mat[i][0])
								}
								i = i + 1
							} while ((i < mat.length))
						}
						this.SetOtherCost()
						let condition = erlang_parser.Parse(this.now_compose_cfg.condition)
						if (condition) {
							let num_condition = Number(condition[0][1])
							if (rune_model.rune_tower_floor >= num_condition) {
								this._Image11.gray = false
								this.labelDisplay.gray = false
								let str = "通关御魂塔第" + num_condition + "层解锁  <font color='#0a953e'>(已解锁)</font>"
								if (condition[0][1] == 0) {
									str = "<font color='#639c12'>(默认解锁)</font>"
								}
								this.condition.innerHTML = Util.StrToHTML(str)
							} else {
								this._Image11.gray = true
								this.labelDisplay.gray = true
								let str = "通关御魂塔第" + num_condition + "层解锁  <font color='#ff4f50'>(未解锁)</font>"
								this.condition.innerHTML = Util.StrToHTML(str)
							}
							this.CallLater(() => {
								this.condition.event("resize")
							})
						}
					}
				}
			}
		}

		this.SetCheckState = (tab_index, sub_index) => {
			if (this.tab_id_and_anme_list[0][tab_index] && this.tab_id_and_anme_list[0][tab_index][1]) {
				let id = this.tab_id_and_anme_list[0][tab_index][1][sub_index]
				this.select_comId = id
				let key = "rune" + id
				let ignore = CookieWrapper.GetInstance().GetCookie(key)
				if (!ignore || Number(ignore) == 0) {
					this._img_check.visible = true
				} else {
					this._img_check.visible = false
				}
			}
		}

		this.SetOtherCost = () => {
			this.other_cost_is_enough = true
			let other = (this.now_compose_cfg && (erlang_parser.Parse(this.now_compose_cfg.cost)) || (null))
			if (other) {
				this.cost_conta.visible = true
				if (!this.cost_item) {
					this.cost_item = new BaseAwardItem(this.cost_icon)
					this.cost_item.Load()
					this.cost_item.SetItemSize(35, 35)
					this.cost_item.SetItembgVisible(false)
				}
				let type_id, lock
				[type_id, lock] = goods_model.GetMappingTypeId(other[0][0], other[0][1])
				if (type_id) {
					this.cost_item.SetData(type_id)
				}
				let my_num = goods_model.GetTypeGoodsNum(type_id)
				let colorstr = Enum_ColorUtil_Dark.GREEN
				if (!my_num || my_num < Number(other[0][2])) {
					this.other_cost_is_enough = false
					colorstr = Enum_ColorUtil_Dark.RED
				}

				let str = `${HtmlColorTxt(my_num, colorstr)}/${other[0][2]}`
				this.cost_num.innerHTML = Util.StrToHTML(str)
				this.cost_num.width = 140
			} else {
				this.cost_conta.visible = false
			}
		}

		//is_not_send 仅仅获取合成数据
		this.UpdateComposePreView = (is_not_send?) => {
			let suit = true
			let goods_id_list = []
			let wear_list = []
			for (let _tmpi in this.item_list) {
				let item = this.item_list[_tmpi]
				if (!item.now_bag_vo) {
					suit = false
				} else {
					if (RuneModel.GetInstance().IsRuneDress(item.now_bag_vo)) {
						table.insert(wear_list, item.now_bag_vo)
						table.insert(goods_id_list, item.now_bag_vo.goods_id)
					} else {
						table.insert(goods_id_list, item.now_bag_vo.goods_id)
					}
				}
			}
			if (suit && this.now_compose_cfg) {
				let list = null
				list = {}
				list.rule_id = this.now_compose_cfg.id
				list.regular_glist = goods_id_list
				list.specify_glist = []
				list.wear_list = wear_list
				this.use_to_compose = list
				if(!is_not_send)rune_model.Fire(local_RuneEvent.GET_COMPOSE_PREVIEW, list)
			} else {
				if(!is_not_send)this.ShowTargetProperty(1)
			}
		}

		this.ShowTargetProperty = (level?) => {
			if ((this.now_target_type_id && level) && this.target_item) {
				this.target_item.SetData(this.now_target_type_id)
				this.target_item.SetStrengthen(level)
				let basic = goods_model.GetGoodsBasicByTypeId(this.now_target_type_id)
				if (basic) {
					//let rune_attr_num_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "Runeattrnum", false)
					let rune_attr_coefficient_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_rune_attr_coefficient", false)
					let config_rune_wake_up = ResManager.GetInstance().GetGameConfigFromCache(this, "config_rune_wake_up", false)
					let str = rune_model.GetProBySubtype(basic.subtype, level, basic.color, rune_attr_coefficient_cfg, config_rune_wake_up)
					this.target_pro.innerHTML = Util.StrToHTML(str)
					this.target_pro.width = 250
				}
			}
		}

		this.RefreshRedDot = () => {
			let red_index = 0
			let red_sub_index = 0
			let btn_need_red = false
			let arr = null
			let id = null
			let i = 0
			do {
				let need_red = false
				arr = this.tab_id_and_anme_list[0][i]
				if (arr && arr[1]) {
					let j = 0
					do {
						id = arr[1][j]
						let key = "rune" + id
						let cookie = CookieWrapper.GetInstance().GetCookie(key)
						let ignore = true
						if (!cookie || Number(cookie) == 0) {
							ignore = false
						}
						let isCanCompose = this.model.IsRuneCanCompose(id) && (!ignore)
						//if (((this.tab_bar && this.tab_bar.tab_item_list) && this.tab_bar.tab_item_list[i]) && this.tab_bar.tab_item_list[i].sub_tab_item_list[j] ) {
						this.tab_bar.setSubTabRedDot(i, j, isCanCompose)
						//}
						if (isCanCompose) {
							if (!red_sub_index) {
								red_sub_index = j
							}
							need_red = true
							if ((this.cur_sub_tab_index == j) && (this.cur_tab_index == i)) {
								btn_need_red = true
							}
						}
						j = j + 1
					} while ((j < arr[1].length))
				}
				if (need_red && !red_index) {
					red_index = i
				}
				//if ((this.tab_bar && this.tab_bar.tab_item_list) && this.tab_bar.tab_item_list[i] ) {
				this.tab_bar.setTabRedDot(i, need_red)
				//}
				i = i + 1
			} while ((i < this.tab_id_and_anme_list[0].length))
			this.red_dot.visible = btn_need_red
			return [red_index, red_sub_index]
		}

		this.HaveEnoughCost = () => {
			let is_enough = true
			if (this.use_to_compose) {
				for (let _tmpi in this.item_list) {
					let item = this.item_list[_tmpi]
					if (!item.click_bg.visible) {
						is_enough = false
						break
					}
				}
				if (is_enough) {
					is_enough = this.other_cost_is_enough
				}
			} else {
				is_enough = false
			}
			return is_enough
		}
	}



	public DeleteMe() {
		this.LocalDeleteMe()
		super.DeleteMe()
	}



	_img_1: Laya.Image
	_img_center: Laya.Image
	_img_center1: Laya.Image
	_img_center2: Laya.Image
	_img_left: Laya.Image
	_Image1: Laya.Image
	_Image3: Laya.Image
	_img_2: Laya.Image
	rune_name: Laya.Label
	_Label1: Laya.Label
	target_pro: Laya.HTMLDivElement
	item_conta0: Laya.Box
	item_conta1: Laya.Box
	target_conta: Laya.Box
	scroll_group: Laya.Box
	composeBtn: Laya.Box
	_Image11: Laya.Image
	labelDisplay: Laya.Label
	tips_icon: Laya.Image
	tip_text: Laya.Label
	_Image4: Laya.Image
	gp_condition: Laya.HBox
	condition: Laya.HTMLDivElement
	cost_conta: Laya.Box
	_Label2: Laya.Label
	cost_num: Laya.HTMLDivElement
	cost_icon: Laya.Box
	red_dot: Laya.Image
	_Image23: Laya.Image
	_Label21: Laya.Label
	img_arrow: Laya.Image
	_gp_effect: Laya.Box
	_gp_check: Laya.Image
	_img_check: Laya.Image
	_lb_check: Laya.Label
	public GetComponents() {
		[
			this._img_1,
			this._img_center,
			this._img_center1,
			this._img_center2,
			this._img_left,
			this._Image1,
			this._Image3,
			this._img_2,
			this.rune_name,
			this._Label1,
			this.target_pro,
			this.item_conta0,
			this.item_conta1,
			this.target_conta,
			this.scroll_group,
			this.composeBtn,
			this._Image11,
			this.labelDisplay,
			this.tips_icon,
			this.tip_text,
			this._Image4,
			this.gp_condition,
			this.condition,
			this.cost_conta,
			this._Label2,
			this.cost_num,
			this.cost_icon,
			this.red_dot,
			this._Image23,
			this._Label21,
			this.img_arrow,
			this._gp_effect,
			this._gp_check,
			this._img_check,
			this._lb_check,
		]
			= this.GetChildrenByNames([

				"_img_1",
				"_img_center",
				"_img_center1",
				"_img_center2",
				"_img_left",
				"_Image1",
				"_Image3",
				"_img_2",
				"rune_name",
				"_Label1",
				"target_pro",
				"item_conta0",
				"item_conta1",
				"target_conta",
				"scroll_group",
				"composeBtn",
				"_Image11",
				"labelDisplay",
				"tips_icon",
				"tip_text",
				"_Image4",
				"gp_condition",
				"condition",
				"cost_conta",
				"_Label2",
				"cost_num",
				"cost_icon",
				"red_dot",
				"_Image23",
				"_Label21",
				"img_arrow",
				"_gp_effect",
				"_gp_check",
				"_img_check",
				"_lb_check",
			])
	}
}
window["CompositeRuneView"] = CompositeRuneView
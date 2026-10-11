import { BaseItem1 } from "../common/BaseItem1"
import { table } from "../common/table"
import { Util, SetAnchoredPosition, GetSizeDeltaY } from "../util/Util"
import { Alert, Alert_Type } from "../alert/Alert"
import { Message } from "../sysInfo/SysInfoController"
import { ErlangParser } from "../util/ErlangParser"
import { GoodsModel } from "../commonModel/GoodsModel"
import { GuardModel } from "../commonModel/GuardModel"
import { CompositeModel, CompositeEvent } from "../commonModel/CompositeModel"
import { CompositeGoodsMatItem } from "./CompositeGoodsMatItem"
import { EquipmentItem } from "../common/EquipmentItem"
import { UIVerTabBar } from "../newgameui/UIVerTabBar"
import { ResManager } from "../common/ResManager"
import { CompositeGuardAttItem } from "./CompositeGuardAttItem"
import { Config } from "../common/Config"
import { UIVerTabSubBtn2 } from "../newgameui/UIVerTabSubBtn2"
import { SoundManager } from "../common/SoundManager"
import { PlatformManager } from "../PlatformManager"

export class CompositeGuardView extends BaseItem1 {
	InitEvent
	InitView
	LoadSuccess
	RefreshRed
	SwitchView
	UpdateSuccessRatio
	UpdateView

	attr_item_list
	comMax
	curNum
	cur_sub_tab_index
	cur_tab_index
	mat_4_pos
	mat_item_list
	model
	now_compose_data
	success_radio
	tab_bar
	tab_name_list
	target_item

	cfg_menu_id
	res_mgr

	public constructor(parent?) {
		super(parent)
		this.base_file = "composite"
		this.layout_file = "CompositeGuardView"
		this.preload_server_config = {
			"config_magic_circle": false,
			"config_compose_menu_id": false
		}

		this.mat_4_pos = [{ x: 280, y: 138 }, { x: 280, y: 387 }, { x: 526, y: 138 }, { x: 526, y: 387 }]
		this.model = CompositeModel.GetInstance()
		this.attr_item_list = []
		this.curNum = 1

		this.res_mgr = ResManager.GetInstance()
		let goods_model = GoodsModel.GetInstance()
		let guard_model = GuardModel.GetInstance()
		let local_CompositeEvent = CompositeEvent
		let erlang_parser = ErlangParser.GetInstance()

		this.load_callback = () => {
			if (PlatformManager.IsEyouEnPlatform()) {
				this.Text.height = 39
				this.Text.width = 149
				this.Text.leading = 0.1
				this.Text.wordWrap =true
				this.Text.pos(10,16)
				this.Text.align="center"
				this.Text.valign="middle"
				this.Text.fontSize = 20
				this._lb_name.x = 259
				this._lb_name.width = 370
				this._lb_name.align="center"
			}
			this.LoadSuccess()
		}

		this.LoadSuccess = () => {
			//lua_resM:SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIconJpg("composite","uihc_002"))
			/*
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg1, GameResPath.GetIconJpg("composite", "uihc_003"), true)
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg2, GameResPath.GetIcon("composite", "uidz_016"))
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg3, GameResPath.GetIcon("composite", "ringcom"), true)
			ResManager.GetInstance().SetOutsideImageSprite(this, this._Image2, GameResPath.GetIcon("composite", "uirw_093a"), true)
			ResManager.GetInstance().SetOutsideImageSprite(this, this._Image10, GameResPath.GetIcon("composite", "uihc_018"))
			ResManager.GetInstance().SetOutsideImageSprite(this, this._Image1, GameResPath.GetIcon("composite", "uishhc_001"), true)
			*/
			//this:AddUIEffect2("ui_synthesize_striation4", this._gp_effect0, null, null, true)
			//this:AddUIEffect2("ui_synthesize_striation4", this._gp_effect1, null, null, true)
			//this:AddUIEffect2("ui_synthesize_striation4", this._gp_effect2, null, null, true)
			//this:AddUIEffect2("ui_synthesize_striation4", this._gp_effect3, null, null, true)
			//this:AddUIEffect2("ui_synthesize_striation3", this._gp_effect, null, null, true)
			this._Scroller1.vScrollBar.visible = false
			this.res_mgr.SetOutsideImageSprite(this, this._img_bg3, "resource/game/composite/other/ui_merge_01.png")

			this.cfg_menu_id = this.res_mgr.GetGameConfigFromCache(this, "config_compose_menu_id", false)
			this.InitView()
			this.InitEvent()
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._gp_composite, () => {
				if (!this._img_composite_red.visible) {
					Message.show("物品不足")
					return
				}
				if (!this.now_compose_data) {
					return
				}
				let rule_id = this.now_compose_data.id
				let regular_list = []
				let regular_mat = Util.DeepCopy(this.now_compose_data.regular_mat)
				let isBind = false
				let selectList = []
				for (let i in regular_mat) {

					let vo = regular_mat[i]
					let count = vo[2]
					let type_id = Number(vo[1])
					let goods_list = goods_model.GetTypeGoods(type_id)
					if (goods_list.length > 0 && guard_model.GetActiveGuardNum(type_id) == 0) {
						for (let index in goods_list) {

							let goods_vo = goods_list[index]
							if (goods_vo.bind > 0) {
								isBind = true
								break
							}
						}
					} else {
						table.splice(regular_mat, Number(i), 1)
					}
				}
				let irregular_list = []
				let okFunc = () => {
					this.model.Fire(local_CompositeEvent.GOODS_COMPOSE, rule_id, this.curNum, regular_mat, irregular_list)
				}

				if (isBind) {
					Alert.Show("当前合成材料中存在绑定的材料，合成后的道具也将是绑定的，是否确认进行合成？", Alert_Type.Two, okFunc)
				} else {
					okFunc()
				}
			}
				, this, true)
			this.BindEvent(this.model, local_CompositeEvent.COMPOSE_SUCCESS, (rule_id?, call_back?) => {
				if (this.now_compose_data && rule_id == this.now_compose_data.id) {
					if (call_back) {
						call_back()
					}

					this.UpdateSuccessRatio()
					let [index, sub_index, notFind] = this.RefreshRed()
					if (!notFind) {
						this.tab_bar.SetSelectTab(index, sub_index, true)
						this.SwitchView(index, sub_index)
					}
					let guard_type = null
					if (rule_id == 26011) {
						guard_type = 3
					} else {
						guard_type = 4
					}
					let active_type1, active_type2
					[active_type1, active_type2] = guard_model.GetGuardActiveType()
					if (guard_type != active_type1 && guard_type != active_type2) {
						guard_model.Fire(GuardModel.OPEN_VIEW, guard_type)
					}
				}
			}
			)
			this.BindEvent(this.model, local_CompositeEvent.COMPOSE_Fail, () => {
				SoundManager.GetInstance().PlaySoundEffect("guildboss")
				this.AddUIEffect("effect_hechengshibai", this._gp_effect, null, 2, null, 2, null, null, null, null, null, null, false)
				this.UpdateSuccessRatio()
			}
			)
			this.BindEvent(goods_model, GoodsModel.CHANGE_BAG_LIST, () => {
				if (this.use_delete_method) {
					return
				}
				this.UpdateView()
				this.RefreshRed()
			}
			)
		}

		this.InitView = () => {
			if (!this.tab_name_list) {
				this.tab_name_list = this.model.GetGuardComposeNameList(this.cfg_menu_id)
			}
			if (!this.tab_bar) {
				this.tab_bar = new UIVerTabBar(this._scroll_tab)
				this.tab_bar.Load()
			}
			if (!this.mat_item_list) {
				this.mat_item_list = []
			}
			let call_fun = (tab_index?, sub_index?) => {
				if (!this.display_obj.visible) {
					return
				}
				this.SwitchView(tab_index, sub_index)
			}
			this.tab_bar.ExcuteCallback(() => {
				//this.tab_bar.SetTabBar(this.tab_name_list, call_fun, GetSizeDeltaY(this._scroll_tab), null, null, null, null, UIVerTabSubBtn2, [39510014, 39510020])
				this.tab_bar.SetTabBar(this.tab_name_list, call_fun, GetSizeDeltaY(this._scroll_tab), null, null, null, GetSizeDeltaY(this._scroll_tab), UIVerTabSubBtn2, [39510014, 39510020])
				let index, sub_index
				[index, sub_index] = this.RefreshRed()
				this.tab_bar.SetSelectTab(index, sub_index)
				this.SwitchView(index, sub_index)
			})
		}

		this.SwitchView = (tab_index?, sub_index?) => {
			if (this.cur_tab_index == tab_index && this.cur_sub_tab_index == sub_index) {
				return
			}
			this.cur_tab_index = tab_index
			this.cur_sub_tab_index = sub_index
			this.UpdateView()
		}

		this.RefreshRed = () => {
			let tab_index = null
			let tab_sub_index = null
			let tab_id_list = this.model.guard_tab_id_list
			for (let sub_id in tab_id_list) {
				let sub_list = tab_id_list[sub_id]
				let sub_red = false
				for (let sub_sub_id in sub_list) {
					let sub_sub_red = false
					let composite_id_list = sub_list[sub_sub_id]
					for (let _tmpi in composite_id_list) {
						let composite_id = composite_id_list[_tmpi]
						if (this.model.CanCompose(composite_id[0])) {
							sub_sub_red = true
							break
						}
					}
					if (sub_sub_red) {
						if (tab_index == null) {
							tab_index = Number(sub_id)
						}
						if (tab_sub_index == null) {
							tab_sub_index = Number(sub_sub_id)
						}
						sub_red = true
					}
					this.tab_bar.setSubTabRedDot(sub_id, sub_sub_id, sub_sub_red)
				}
				this.tab_bar.setTabRedDot(sub_id, sub_red)
				let tab_item = (this.tab_bar && this.tab_bar.tab_item_list) && this.tab_bar.tab_item_list[sub_id]
				if (tab_item) {
					tab_item.SetRedDot(sub_red)
				}
			}
			return [tab_index || 0, tab_sub_index || 0, tab_sub_index == null]
		}

		this.UpdateView = () => {
			let tab_index = this.cur_tab_index
			let sub_index = this.cur_sub_tab_index
			let tab_id_list = this.model.guard_tab_id_list
			let compose_cfg = (tab_id_list && tab_id_list[tab_index]) && tab_id_list[tab_index][sub_index]
			let compose_id = compose_cfg[0] && compose_cfg[0][0]
			if (compose_id) {
				let now_compose_cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_goods_compose.name, Number(compose_id), false)
				if (!now_compose_cfg) {
					return
				}
				this.now_compose_data = {
					id: now_compose_cfg.id,
					subtype: now_compose_cfg.subtype,
					regular_mat: erlang_parser.Parse(now_compose_cfg.regular_mat),
					irregular_mat: erlang_parser.Parse(now_compose_cfg.irregular_mat),
					goods: erlang_parser.Parse(now_compose_cfg.goods),
					hole_list: erlang_parser.Parse(now_compose_cfg.hole_list),
					ratio: erlang_parser.Parse(now_compose_cfg.ratio)
				}
				this._lb_name.text = now_compose_cfg.name
				if (this.now_compose_data) {
					if (!this.target_item) {
						this.target_item = new EquipmentItem(this._gp_reward)
						this.target_item.Load()
						this.target_item.SetItemSize(80, 80)
					}
					for (let _tmpi in this.attr_item_list) {
						let item = this.attr_item_list[_tmpi]
						item.display_obj.visible = false
					}
					let goods = this.now_compose_data.goods
					if (goods) {
						this.target_item.SetData(goods[0][1])
						let guard_cfg = this.res_mgr.GetGameConfigFromCache(this, "config_magic_circle", false)
						let attr_list = guard_model.GetGuardCfgByTypeId(Number(goods[0][1]), guard_cfg)
						if (attr_list) {
							for (let i in attr_list) {
								let item = this.attr_item_list[i]
								if (!item) {
									item = new CompositeGuardAttItem(this._gp_attrs)
									item.Load()
									table.insert(this.attr_item_list, item)
								}
								item.ExcuteCallback(() => {
									item.SetData(attr_list[i])
									item.display_obj.visible = true
								}
								)
							}
						}
					}
				}

				let hole_list = this.now_compose_data.hole_list
				let holeNum = 0
				for (let _tmpi in hole_list) {
					//let vo = hole_list[_tmpi]
					holeNum = holeNum + 1
				}
				let regular_mat_cfg = this.now_compose_data.regular_mat
				let regular_mat_dic = []
				for (let key in regular_mat_cfg) {
					let value = regular_mat_cfg[key]
					let vo = value[0]
					table.insert(regular_mat_dic, vo)
				}
				this.now_compose_data.regular_mat = regular_mat_dic
				let index = 0
				let pos = this["mat_" + holeNum + "_pos"]
				for (let i in regular_mat_dic) {
					let vo = regular_mat_dic[i]
					//let count = vo
					let item = this.mat_item_list[index]
					if (!item) {
						item = new CompositeGoodsMatItem(this.display_obj)
						item.Load()
						//item.scaleY = 1.1
						//item.scaleX = item.scaleY
						table.insert(this.mat_item_list, item)
					}
					let parm = { hole_id: 1, regular_mat: { type_id: vo[1], count: vo[2] } }
					let _pos = pos[index]
					item.SetPosition(_pos.x, _pos.y)
					item.SetData(parm)
					item.SetVisible(true)
					index = index + 1
				}
				if (this.mat_item_list && holeNum < this.mat_item_list.length) {
					let i = holeNum
					if (i < this.mat_item_list.length) {
						do {
							let item = this.mat_item_list[i]
							if (item) {
								item.display_obj.visible = false
							}
							i = i + 1
						} while ((i < this.mat_item_list.length))
					}
				}
				this.UpdateSuccessRatio()
			}
		}

		this.UpdateSuccessRatio = () => {
			let success_radio = 0
			let max = 0
			let selectList = []
			let regular_bool = true
			this._img_composite_red.visible = false
			if (this.now_compose_data) {
				if (1 == this.now_compose_data.subtype) {
					let regular_mat_dic = this.now_compose_data.regular_mat
					for (let _tmpi in regular_mat_dic) {
						let vo = regular_mat_dic[_tmpi]
						let count = Number(vo[2])
						let type_id = Number(vo[1])
						let my_count = goods_model.GetTypeGoodsNum(type_id)
						//守护激活可用于合成
						if (guard_model.goodsToType[type_id]) {
							my_count = my_count + guard_model.GetActiveGuardNum(type_id)
						}
						if (my_count < count - (selectList[type_id] || 0)) {
							regular_bool = false
							return
						}
						if (selectList[type_id]) {
							selectList[type_id] = selectList[type_id] + Number(count)
						} else {
							selectList[type_id] = Number(count)
						}
					}
					if (regular_bool) {
						success_radio = Number(this.now_compose_data.ratio[0])
					}
				}
			}
			if (regular_bool) {
				for (let index in selectList) {

					let my_count = goods_model.GetTypeGoodsNum(index)
					max = (max > 0 && (Math.min(max, my_count / selectList[index])) || (my_count / selectList[index]))
				}
			}
			this.comMax = Math.floor(max)
			this.success_radio = success_radio
			this._bit_lb_success.text = "b" + success_radio + "a"
			this._img_composite_red.visible = this.comMax > 0
		}
	}

	public DeleteMe() {
		if (this.target_item) {
			this.target_item.DeleteMe()
			this.target_item = null
		}
		if (this.mat_item_list) {
			for (let _tmpi in this.mat_item_list) {
				let obj = this.mat_item_list[_tmpi]
				obj.DeleteMe()
			}
			this.mat_item_list = []
		}
		if (this.tab_bar) {
			this.tab_bar.DeleteMe()
			this.tab_bar = null
		}
		if (this.attr_item_list.length > 0) {
			for (let _tmpi in this.attr_item_list) {
				let item = this.attr_item_list[_tmpi]
				item.DeleteMe()
			}
			this.attr_item_list = []
		}
		super.DeleteMe()
	}

	_img_bg2: Laya.Image
	_img_bg3: Laya.Image
	_Image2: Laya.Image
	img_arrow: Laya.Image
	_scroll_tab: Laya.Box
	_lb_name: Laya.Label
	_gp_effect: Laya.Box
	_gp_effect0: Laya.Box
	_gp_effect1: Laya.Box
	_gp_effect2: Laya.Box
	_gp_effect3: Laya.Box
	_Image4: Laya.Image
	_Image5: Laya.Image
	_Image6: Laya.Image
	_Image7: Laya.Image
	_Image8: Laya.Image
	_gp_reward: Laya.Box
	_gp_composite: Laya.Box
	_Image9: Laya.Image
	_Label1: Laya.Label
	_img_composite_red: Laya.Image
	_Image10: Laya.Image
	_Image11: Laya.Image
	_Scroller1: Laya.Panel
	_gp_attrs: Laya.VBox
	_bit_lb_success: Laya.Label
	Text: Laya.Label
	img_title: Laya.Image
	_Label2: Laya.Label
	public GetComponents() {
		[
			this._img_bg2,
			this._img_bg3,
			this._Image2,
			this.img_arrow,
			this._scroll_tab,
			this._lb_name,
			this._gp_effect,
			this._gp_effect0,
			this._gp_effect1,
			this._gp_effect2,
			this._gp_effect3,
			this._Image4,
			this._Image5,
			this._Image6,
			this._Image7,
			this._Image8,
			this._gp_reward,
			this._gp_composite,
			this._Image9,
			this._Label1,
			this._img_composite_red,
			this._Image10,
			this._Image11,
			this._Scroller1,
			this._gp_attrs,
			this._bit_lb_success,
			this.Text,
			this.img_title,
			this._Label2,
		]
			= this.GetChildrenByNames([

				"_img_bg2",
				"_img_bg3",
				"_Image2",
				"img_arrow",
				"_scroll_tab",
				"_lb_name",
				"_gp_effect",
				"_gp_effect0",
				"_gp_effect1",
				"_gp_effect2",
				"_gp_effect3",
				"_Image4",
				"_Image5",
				"_Image6",
				"_Image7",
				"_Image8",
				"_gp_reward",
				"_gp_composite",
				"_Image9",
				"_Label1",
				"_img_composite_red",
				"_Image10",
				"_Image11",
				"_Scroller1",
				"_gp_attrs",
				"_bit_lb_success",
				"Text",
				"img_title",
				"_Label2",
			])
	}
}
window["CompositeGuardView"] = CompositeGuardView
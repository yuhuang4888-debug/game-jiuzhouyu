import { BaseItem1 } from "../common/BaseItem1"
import { table } from "../common/table"
import { Util, GetSizeDeltaY } from "../util/Util"
import { Config } from "../common/Config"
import { ErlangParser } from "../util/ErlangParser"
import { ResManager } from "../common/ResManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { CompositeEvent } from "../commonModel/CompositeModel"
import { CompositeModel } from "../commonModel/CompositeModel"
import { Message } from "../sysInfo/SysInfoController"
import { Alert, Alert_Type } from "../alert/Alert"
import { UIVerTabBar } from "../newgameui/UIVerTabBar"
import { EquipmentItem } from "../common/EquipmentItem"
import { CongratulationObtainView } from "../common/CongratulationObtainView"
import { CompositeHolySealMatItem } from "./CompositeHolySealMatItem"
import { SoundManager } from "../common/SoundManager"

export class CompositeLonglangView extends BaseItem1 {
	BindBagList
	InitEvent
	InitView
	LoadSuccess
	LocalDeleteMe
	RefreshRed
	SwitchView
	UpdateSuccessRatio
	UpdateView

	cur_sub_tab_index
	cur_tab_index
	mat_item_list
	mat_pos
	model
	now_compose_data
	success_radio
	tabList
	tab_bar
	tab_name_list
	target_item

	public constructor(parent?) {
		super(parent)
		this.base_file = "composite"
		this.layout_file = "CompositeLonglangView"

		this.model = CompositeModel.GetInstance()
		let goods_model = GoodsModel.GetInstance()
		let local_CompositeEvent = CompositeEvent
		let local_GoodsModel = GoodsModel
		let local_Number = Number
		let local_Config = Config
		let erlang_parser = ErlangParser.GetInstance()
		this.mat_pos = [
			{ x: 405, y: 672 },
			{ x: 405, y: 93 }
		]

		this.load_callback = () => {
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg0, "resource/game/composite/other/ui_merge_01.png")
			this.LoadSuccess()
		}

		this.LoadSuccess = () => {
			this.tabList = this.model.longlang_tab_id_list
			this.InitView()
			this.InitEvent()
		}

		this.InitView = () => {
			if (!this.tab_name_list) {
				this.tab_name_list = this.model.GetLonglangComposeNameList(Config.PRELOAD_SERVER_CONFIG.config_compose_menu, Config.PRELOAD_SERVER_CONFIG.config_compose_menu_id)
			}
			if (!this.tab_bar) {
				this.tab_bar = new UIVerTabBar(this._scroll_tab)
				this.tab_bar.Load()
			}
			if (!this.mat_item_list) {
				this.mat_item_list = []
			}
			let i = 0
			do {
				let item = new CompositeHolySealMatItem(this.display_obj)
				item.Load()
				item.SetPosition(this.mat_pos[i].x, this.mat_pos[i].y)
				this.mat_item_list[i] = item
				i = i + 1
			} while ((i < this.mat_pos.length))
			let call_fun = (tab_index?, sub_index?) => {
				if (!this.display_obj.visible) {
					return
				}
				this.SwitchView(tab_index, sub_index)
			}

			this.tab_bar.SetTabBar(this.tab_name_list, call_fun, GetSizeDeltaY(this._scroll_tab), () => {
				this.RefreshRed()
			}, null, null, GetSizeDeltaY(this._scroll_tab))
			let index, sub_index
			[index, sub_index] = this.RefreshRed()
			this.tab_bar.SetSelectTab(index, sub_index)
			this.SwitchView(index, sub_index)
			setTimeout(() => {
				if(this.use_delete_method) return
				this.RefreshRed()
			}, 0.1)

			// this.tab_bar.ExcuteCallback(() => {
			// 	this.tab_bar.SetTabBar(this.tab_name_list, call_fun, GetSizeDeltaY(this._scroll_tab), () => {
			// 		this.RefreshRed()
			// 	})
			// 	let list = this.RefreshRed()
			// 	let index, sub_index = list[1], list[2]
			// 	this.tab_bar.SetSelectTab(index, sub_index)
			// 	this.tab_bar.RefreshSrollerPos()
			// 	this.SwitchView(index, sub_index)
			// 	SetAnchoredPositionY(this.tab_bar.transContent, 0)
			// 	time_id = setTimeout(() => {
			// 		this.RefreshRed()
			// 	}, 0.1)
			// }
			// )
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._gp_composite, () => {
				if (!this.success_radio) {
					Message.show("物品不足")
					return
				}
				if (!this.now_compose_data) {
					return
				}
				let rule_id = this.now_compose_data.id
				let regular_list = []
				let regular_mat = this.now_compose_data.regular_mat
				let isBind = false
				for (let type_id in regular_mat) {
					let count = regular_mat[type_id]
					let goods_list = goods_model.GetTypeGoods(Number(type_id))
					if (goods_list) {
						for (let index in goods_list) {
							let goods_vo = goods_list[index]
							let i = 0
							do {
								table.insert(regular_list, goods_vo.goods_id)
								count = count - 1
								if (count <= 0) {
									break
								}
								i = i + 1
							} while ((i < goods_vo.goods_num))
							if (count <= 0) {
								break
							}
							if (goods_vo.bind) {
								isBind = true
							}
						}
					}
				}
				let irregular_list = []
				let okFunc = () => {
					this.model.Fire(local_CompositeEvent.REQUEST_PROTO, rule_id, regular_list, irregular_list)
				}

				if (isBind) {
					Alert.Show("当前合成材料中存在绑定的材料，合成后的装备也将是绑定的，是否确认进行合成？", Alert_Type.Two, okFunc)
				} else {
					okFunc()
				}
			}, this, true)

			this.BindEvent(this.model, local_CompositeEvent.COMPOSE_SUCCESS, (rule_id?, goods_id?) => {
				if (this.now_compose_data && rule_id == this.now_compose_data.id) {
					let list = this.now_compose_data.goods
					let com = [0, list[0][1], 1, goods_id]
					let success_view = new CongratulationObtainView([com], 10)
					success_view.Open()
				}
			}
			)
			this.BindEvent(this.model, local_CompositeEvent.COMPOSE_Fail, () => {
				SoundManager.GetInstance().PlaySoundEffect("guildboss")
				this.AddUIEffect("effect_hechengshibai", this._gp_effect, null, 2, null, 2, null, null, null, null, null, null, false)
			}
			)
			this.BindBagList()
		}

		this.BindBagList = () => {
			this.BindEvent(goods_model, local_GoodsModel.CHANGE_LONGLANG_BAG, () => {
				this.RefreshRed()
				this.UpdateSuccessRatio()
			})

			this.BindEvent(goods_model, local_GoodsModel.CHANGE_LONGLANG_EQUIP, () => {
				this.RefreshRed()
				this.UpdateSuccessRatio()
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
			let tab_id_list = this.tabList
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
							tab_index = local_Number(sub_id)
						}
						if (tab_sub_index == null) {
							tab_sub_index = local_Number(sub_sub_id)
						}
						sub_red = true
					}
					this.tab_bar.setSubTabRedDot(sub_id, sub_sub_id, sub_sub_red)
					// let tab_item = ((this.tab_bar && this.tab_bar.tab_item_list) && this.tab_bar.tab_item_list[sub_id]) && this.tab_bar.tab_item_list[sub_id].sub_tab_item_list[sub_sub_id]
					// if (tab_item) {
					// 	tab_item.SetRedDot(sub_sub_red)
					// }
				}
				// let tab_item = (this.tab_bar && this.tab_bar.tab_item_list) && this.tab_bar.tab_item_list[sub_id]
				// if (tab_item) {
				// 	tab_item.SetRedDot(sub_red)
				// }
				this.tab_bar.setTabRedDot(sub_id, sub_red)
			}
			tab_sub_index = tab_sub_index || 0
			tab_index = tab_index || 0
			return [tab_index, tab_sub_index]
		}

		this.UpdateView = () => {
			let tab_index = this.cur_tab_index
			let sub_index = this.cur_sub_tab_index
			let tab_id_list = this.tabList
			let compose_cfg = (tab_id_list && tab_id_list[tab_index]) && tab_id_list[tab_index][sub_index]
			let compose_id = compose_cfg[0] && compose_cfg[0][0] && Number(compose_cfg[0][0])
			if (compose_id) {
				let now_compose_cfg = local_Config.GetConfigVo(local_Config.ConfigHasDefaultValue.config_goods_compose.name, compose_id, false)
				this.now_compose_data = {
					id: now_compose_cfg.id,
					subtype: now_compose_cfg.subtype,
					regular_mat: erlang_parser.Parse(now_compose_cfg.regular_mat),
					irregular_mat: erlang_parser.Parse(now_compose_cfg.irregular_mat),
					goods: erlang_parser.Parse(now_compose_cfg.goods),
					hole_list: erlang_parser.Parse(now_compose_cfg.hole_list),
					ratio: erlang_parser.Parse(now_compose_cfg.ratio)
				}
				if (this.now_compose_data) {
					if (!this.target_item) {
						this.target_item = new EquipmentItem(this._gp_reward)
						this.target_item.SetItemSize(80, 80)
						this.target_item.Load()
					}
					let goods = this.now_compose_data.goods
					if (goods) {
						this.target_item.SetData(Number(goods[0][1]))
					}
				}
				// let hole_list = this.now_compose_data.hole_list
				let regular_mat_cfg = this.now_compose_data.regular_mat
				let regular_mat_dic = []
				for (let key in regular_mat_cfg) {
					let value = regular_mat_cfg[key]
					let vo = value[0]
					if (!regular_mat_dic[vo[1]]) {
						regular_mat_dic[vo[1]] = local_Number(vo[2])
					} else {
						regular_mat_dic[vo[1]] = regular_mat_dic[vo[1]] + local_Number(vo[2])
					}
				}
				this.now_compose_data.regular_mat = regular_mat_dic
				let index = 0
				for (let type_id in regular_mat_dic) {
					let count = regular_mat_dic[type_id]
					let item = this.mat_item_list[index]
					this["_img_mat" + index].visible = true
					item.SetVisible(true)
					let parm = { hole_id: 1, regular_mat: { type_id: type_id, count: count } }
					item.SetData(parm)
					index = index + 1
				}
				// this._gp_effect3.visible = index == 3
				let i = index
				if (i < this.mat_item_list.length) {
					do {
						this["_img_mat" + index].visible = false
						this.mat_item_list[i].SetVisible(false)
						i = i + 1
					} while ((i < this.mat_item_list.length))
				}

				this.UpdateSuccessRatio()
			}
		}

		this.UpdateSuccessRatio = () => {
			let success_radio = 0
			if (this.now_compose_data) {
				if (1 == this.now_compose_data.subtype) {
					let regular_mat_dic = this.now_compose_data.regular_mat
					let regular_bool = true
					for (let type_id in regular_mat_dic) {
						let count = regular_mat_dic[type_id]
						let my_count = goods_model.GetTypeGoodsNum(type_id)
						if (my_count < count) {
							regular_bool = false
							break
						}
					}
					if (regular_bool) {
						success_radio = local_Number(this.now_compose_data.ratio[0])
					}
				}
			}
			this.success_radio = success_radio
			this._img_composite_red.visible = success_radio == 100
		}

		this.LocalDeleteMe = () => {
			if (this.target_item) {
				this.target_item.DeleteMe()
				this.target_item = null
			}
			if (this.mat_item_list) {
				for (let _tmpi in this.mat_item_list) {
					let obj = this.mat_item_list[_tmpi]
					obj.DeleteMe()
				}
				this.mat_item_list = null
			}
			if (this.tab_bar) {
				this.tab_bar.DeleteMe()
				this.tab_bar = null
			}
		}
	}

	public DeleteMe() {
		this.LocalDeleteMe()
		super.DeleteMe()
	}

	_img_bg1: Laya.Image
	_Image1: Laya.Image
	title: Laya.Label
	_img_mat0: Laya.Image
	_img_mat1: Laya.Image
	_img_bg0: Laya.Image
	_gp_reward: Laya.Box
	_scroll_tab: Laya.Box
	_gp_composite: Laya.Box
	_Image2: Laya.Image
	_Label1: Laya.Label
	_img_composite_red: Laya.Image
	_gp_effect: Laya.Box
	public GetComponents() {
		[
			this._img_bg1,
			this._Image1,
			this.title,
			this._img_mat0,
			this._img_mat1,
			this._img_bg0,
			this._gp_reward,
			this._scroll_tab,
			this._gp_composite,
			this._Image2,
			this._Label1,
			this._img_composite_red,
			this._gp_effect,
		]
			= this.GetChildrenByNames([
				"_img_bg1",
				"_Image1",
				"title",
				"_img_mat0",
				"_img_mat1",
				"_img_bg0",
				"_gp_reward",
				"_scroll_tab",
				"_gp_composite",
				"_Image2",
				"_Label1",
				"_img_composite_red",
				"_gp_effect",
			])
	}
}
window["CompositeLonglangView"] = CompositeLonglangView
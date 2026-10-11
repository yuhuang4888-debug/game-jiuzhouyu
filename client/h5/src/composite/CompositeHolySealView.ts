import { BaseItem1 } from "../common/BaseItem1"
import { Util, GetSizeDeltaY } from "../util/Util"
import { table } from "../common/table"
import { Config } from "../common/Config"
import { ErlangParser } from "../util/ErlangParser"
import { GoodsModel } from "../commonModel/GoodsModel"
import { CompositeModel, CompositeEvent } from "../commonModel/CompositeModel"
import { UIVerTabBar } from "../newgameui/UIVerTabBar"
import { Message } from "../sysInfo/SysInfoController"
import { Alert, Alert_Type } from "../alert/Alert"
import { EquipmentItem } from "../common/EquipmentItem"
import { ResManager } from "../common/ResManager"
import { CongratulationObtainView } from "../common/CongratulationObtainView"
import { CompositeHolySealMatItem } from "./CompositeHolySealMatItem"
import { SoundManager } from "../common/SoundManager"
import { PlatformManager } from "../PlatformManager"

export class CompositeHolySealView extends BaseItem1 {
	composite_model
	cur_sub_tab_index
	cur_tab_index
	erlang_parser
	goods_model
	mat_item_list
	mat_pos
	now_compose_data
	success_radio
	tabList
	tab_bar
	tab_name_list
	target_item
	cfg_menu
	cfg_menu_id
	res_mgr

	public constructor(parent?) {
		super(parent)
		this.base_file = "composite"
		this.layout_file = "CompositeHolySealView"
		this.preload_server_config = {
			"config_compose_menu": false,
			"config_compose_menu_id": false
		}

		this.composite_model = CompositeModel.GetInstance()
		this.goods_model = GoodsModel.GetInstance()
		this.erlang_parser = ErlangParser.GetInstance()
		this.res_mgr = ResManager.GetInstance()

		this.mat_pos = [
			{ x: 405, y: 672 },
			{ x: 405, y: 93 }
		]

		this.load_callback = () => {
			this.LoadSuccess()
		}
	}

	public LoadSuccess() {
		if (PlatformManager.IsEyouEnPlatform()) {
			this.title.height = 39
			this.title.width = 149
			this.title.leading = 0.1
			this.title.wordWrap =true
			this.title.pos(10,16)
			this.title.align="center"
			this.title.valign="middle"
			this.title.fontSize = 20
		}
		this.cfg_menu_id = this.res_mgr.GetGameConfigFromCache(this, "config_compose_menu_id", false)
		this.cfg_menu = this.res_mgr.GetGameConfigFromCache(this, "config_compose_menu", false)
		this.res_mgr.SetOutsideImageSprite(this, this._img_bg0, "resource/game/composite/other/ui_merge_01.png")

		this.tabList = this.composite_model.holy_seal_tab_id_list
		this.InitView()
		this.InitEvent()
	}

	public InitView() {
		// this.AddUIEffect2("ui_Sealscompound_circle1", this._gp_effect, false, false, true)
		// this.AddUIEffect2("ui_Sealscompound_circle2", this._gp_effect0, false, false, true)
		// this.AddUIEffect2("ui_Sealscompound_line", this._gp_effect1, false, false, true)
		// this.AddUIEffect2("ui_Sealscompound_rune", this._gp_effect2, false, false, true)
		// this.AddUIEffect2("ui_Sealscompound_line", this._gp_effect3, false, false, true)

		if (!this.tab_name_list) {
			this.tab_name_list = this.composite_model.GetHolySealComposeNameList(this.cfg_menu, this.cfg_menu_id)//this.PRELOAD_SERVER_CONFIG.Composemenuid
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
		} while ((i < this.mat_pos.length)
		)

		let call_fun = (tab_index?, sub_index?) => {
			this.SwitchView(tab_index, sub_index)
		}
		this.tab_bar.SetTabBar(this.tab_name_list, call_fun, GetSizeDeltaY(this._scroll_tab), null, null, null, GetSizeDeltaY(this._scroll_tab))
		let index, sub_index
		[index, sub_index] = this.RefreshRed()
		this.tab_bar.SetSelectTab(index, sub_index)
		// this.tab_bar.RefreshSrollerPos()
		this.SwitchView(index, sub_index)
	}

	public InitEvent() {
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
				let goods_list = this.goods_model.GetTypeGoods(Number(type_id))
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
						} while ((i < goods_vo.goods_num)
						)
						if (count <= 0) {
							break
						}
						if (goods_vo.bind != 0) {
							isBind = true
						}
					}
				}
			}
			let irregular_list = []
			let okFunc = () => {
				this.composite_model.Fire(CompositeEvent.REQUEST_PROTO, rule_id, regular_list, irregular_list)
			}

			if (isBind) {
				Alert.Show("当前合成材料中存在绑定的材料，合成后的装备也将是绑定的，是否确认进行合成？", Alert_Type.Two, okFunc)
			} else {
				okFunc()
			}
		}, this, true)

		this.BindEvent(this.composite_model, CompositeEvent.COMPOSE_SUCCESS, (rule_id?, goods_id?) => {
			if (this.now_compose_data && rule_id == this.now_compose_data.id) {
				let list = this.now_compose_data.goods
				let com = [0, list[0][1], 1, goods_id]
				let success_view = new CongratulationObtainView([com], 10)
				success_view.Open()
			}
		})

		this.BindEvent(this.composite_model, CompositeEvent.COMPOSE_Fail, () => {
			SoundManager.GetInstance().PlaySoundEffect("guildboss")
			this.AddUIEffect("effect_hechengshibai", this._gp_effect, null, 2, null, 2, null, null, null, null, null, null, false)
			this.CompositeFailAni()
		})

		this.BindBagList()
	}

	public BindBagList() {
		this.BindEvent(this.goods_model, GoodsModel.CHANGE_HOLY_SEAL_BAG_LIST, () => {
			this.RefreshRed()
			this.UpdateSuccessRatio()
		})

		this.BindEvent(this.goods_model, GoodsModel.CHANGE_HOLY_SEAL_LIST, () => {
			this.RefreshRed()
			this.UpdateSuccessRatio()
		})
	}

	public SwitchView(tab_index?, sub_index?) {
		if (this.cur_tab_index == tab_index && this.cur_sub_tab_index == sub_index) {
			return
		}
		this.cur_tab_index = tab_index
		this.cur_sub_tab_index = sub_index
		this.UpdateView()
	}

	public RefreshRed() {
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
					if (this.composite_model.CanCompose(composite_id[0])) {
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
				//let tab_item = 
				//((this.tab_bar && this.tab_bar.tab_item_list) && this.tab_bar.tab_item_list[sub_id]) &&
				//this.tab_bar.tab_item_list[sub_id].sub_tab_item_list[sub_sub_id]
				//if (tab_item ) {
				//tab_item:SetRedDot(sub_sub_red)
				//}
			}
			//let tab_item = (this.tab_bar && this.tab_bar.tab_item_list) && this.tab_bar.tab_item_list[sub_id]
			//if (tab_item ) {
			//tab_item:SetRedDot(sub_red)
			//}
			this.tab_bar.setTabRedDot(sub_id, sub_red)
		}
		tab_sub_index = tab_sub_index || 0
		tab_index = tab_index || 0
		return [tab_index, tab_sub_index]
	}

	public UpdateView() {
		let tab_index = this.cur_tab_index
		let sub_index = this.cur_sub_tab_index
		let tab_id_list = this.tabList
		let compose_cfg = (tab_id_list && tab_id_list[tab_index]) && tab_id_list[tab_index][sub_index]
		let compose_id = compose_cfg[0] && compose_cfg[0][0]
		if (compose_id) {
			let now_compose_cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_goods_compose.name, Number(compose_id), false)
			if (now_compose_cfg) {
				this.now_compose_data = {
					id: now_compose_cfg.id,
					subtype: now_compose_cfg.subtype,
					regular_mat: this.erlang_parser.Parse(now_compose_cfg.regular_mat),
					irregular_mat: this.erlang_parser.Parse(now_compose_cfg.irregular_mat),
					goods: this.erlang_parser.Parse(now_compose_cfg.goods),
					hole_list: this.erlang_parser.Parse(now_compose_cfg.hole_list),
					ratio: this.erlang_parser.Parse(now_compose_cfg.ratio)
				}
			}

			if (this.now_compose_data) {
				if (!this.target_item) {
					this.target_item = new EquipmentItem(this._gp_reward)
					this.target_item.SetItemSize(80, 80)
					// this.target_item.verticalCenter = 0
					// this.target_item.horizontalCenter = this.target_item.verticalCenter
					this.target_item.Load()
				}
				let goods = this.now_compose_data.goods
				if (goods) {
					this.target_item.SetData(goods[0][1])
				}
			}
			let hole_list = this.now_compose_data.hole_list
			let regular_mat_cfg = this.now_compose_data.regular_mat
			let regular_mat_dic = []
			let regular_type_id_list = []
			for (let key in regular_mat_cfg) {

				let value = regular_mat_cfg[key]
				let vo = value[0]
				if (!regular_mat_dic[vo[1]]) {
					regular_mat_dic[vo[1]] = Number(vo[2])
					table.insert(regular_type_id_list, vo[1])
				} else {
					regular_mat_dic[vo[1]] = regular_mat_dic[vo[1]] + Number(vo[2])
				}
			}

			table.sort(regular_type_id_list, (a?, b?) => {
				return Number(a) < Number(b)
			})
			this.now_compose_data.regular_mat = regular_mat_dic

			for (let index = 0; index < regular_type_id_list.length; index++) {
				let type_id = regular_type_id_list[index]
				let count = regular_mat_dic[type_id]
				let item = this.mat_item_list[index]
				this["_img_mat" + index].visible = true
				item.SetVisible(true)
				let parm = { hole_id: 1, regular_mat: { type_id: type_id, count: count } }
				item.SetData(parm)
			}

			let index = regular_type_id_list.length
			this._gp_effect3.visible = index == 2
			let i = index
			if (i < this.mat_item_list.length) {
				do {
					this["_img_mat" + index].visible = false
					this.mat_item_list[i].SetVisible(false)
					i = i + 1
				} while ((i < this.mat_item_list.length)
				)
			}
			this.UpdateSuccessRatio()
		}
	}

	public UpdateSuccessRatio() {
		let success_radio = 0
		if (this.now_compose_data) {
			let funcs = {
				"1": () => {
					let regular_mat_dic = this.now_compose_data.regular_mat
					let regular_bool = true
					for (let type_id in regular_mat_dic) {
						let count = regular_mat_dic[type_id]
						let my_count = this.goods_model.GetTypeGoodsNum(type_id)
						if (my_count < count) {
							regular_bool = false
							return
						}
					}
					if (regular_bool) {
						success_radio = Number(this.now_compose_data.ratio[0])
					}
				}
			}
			let casef = funcs[this.now_compose_data.subtype]
			if (!casef) {
				casef = funcs["default"]
			}
			if (casef) {
				casef()
			}
		}
		this.success_radio = success_radio
		this._img_composite_red.visible = success_radio == 100
	}

	public CompositeFailAni() {
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
			this.mat_item_list = null
		}
		if (this.tab_bar) {
			this.tab_bar.DeleteMe()
			this.tab_bar = null
		}
		super.DeleteMe()
	}

	_img_bg1: Laya.Image
	_Image1: Laya.Image
	title: Laya.Label
	_img_arrow: Laya.Image
	_gp_effect: Laya.Box
	_img_bg2: Laya.Image
	_img_bg3: Laya.Image
	_img_mat0: Laya.Image
	_img_mat1: Laya.Image
	_img_bg0: Laya.Image
	_gp_effect0: Laya.Box
	_gp_effect1: Laya.Box
	_gp_effect3: Laya.Box
	_gp_effect2: Laya.Box
	_gp_reward: Laya.Box
	_lb_radio: Laya.Label
	_scroll_tab: Laya.Box
	_gp_composite: Laya.Box
	_Image2: Laya.Image
	_Label1: Laya.Label
	_img_composite_red: Laya.Image
	public GetComponents() {
		[
			this._img_bg1,
			this._Image1,
			this.title,
			this._img_arrow,
			this._gp_effect,
			this._img_bg2,
			this._img_bg3,
			this._img_mat0,
			this._img_mat1,
			this._img_bg0,
			this._gp_effect0,
			this._gp_effect1,
			this._gp_effect3,
			this._gp_effect2,
			this._gp_reward,
			this._lb_radio,
			this._scroll_tab,
			this._gp_composite,
			this._Image2,
			this._Label1,
			this._img_composite_red,
		]
			= this.GetChildrenByNames([

				"_img_bg1",
				"_Image1",
				"title",
				"_img_arrow",
				"_gp_effect",
				"_img_bg2",
				"_img_bg3",
				"_img_mat0",
				"_img_mat1",
				"_img_bg0",
				"_gp_effect0",
				"_gp_effect1",
				"_gp_effect3",
				"_gp_effect2",
				"_gp_reward",
				"_lb_radio",
				"_scroll_tab",
				"_gp_composite",
				"_Image2",
				"_Label1",
				"_img_composite_red",
			])
	}
}
window["CompositeHolySealView"] = CompositeHolySealView
import { BaseItem1 } from "../common/BaseItem1"
import { Util, GetSizeDeltaY, PlayBigEffect } from "../util/Util"
import { table } from "../common/table"
import { Config } from "../common/Config"
import { GoodsModel } from "../commonModel/GoodsModel"
import { ErlangParser } from "../util/ErlangParser"
import { UnrealModel } from "../commonModel/UnrealModel"
import { CompositeModel, CompositeEvent } from "../commonModel/CompositeModel"
import { UIVerTabBar } from "../newgameui/UIVerTabBar"
import { Message } from "../sysInfo/SysInfoController"
import { CongratulationObtainView } from "../common/CongratulationObtainView"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { EquipmentItem } from "../common/EquipmentItem"
import { CompositeUnrealMatItem } from "./CompositeUnrealMatItem"
import { SoundManager } from "../common/SoundManager"
import { PlatformManager } from "../PlatformManager"

export class CompositeUnrealView extends BaseItem1 {
	cost_bool
	cur_index
	cur_sub_tab_index
	cur_tab_index
	default_index
	erlang_parser
	goods_model
	goodsid_to_index
	mat_count_bool
	mat_item_list
	mat_pos
	model
	now_compose_data
	now_compose_list

	tab_bar
	tab_name_list
	target_item
	res_mgr
	cfg_menu
	cfg_menu_id
	cfg_goods_sub
	cfg_goods_compose

	public constructor(parent) {
		super(parent)
		this.base_file = "composite"
		this.layout_file = "CompositeUnrealView"
		this.preload_server_config = {
			"config_compose_menu": false,
			"config_compose_menu_id": false,
			"GoodsSubtype": false,
			"config_goods_compose": false
		}

		this.model = CompositeModel.GetInstance()
		this.goods_model = GoodsModel.GetInstance()
		this.erlang_parser = ErlangParser.GetInstance()
		this.res_mgr = ResManager.GetInstance()

		this.mat_pos = [
			{ x: 264, y: 482 },
			{ x: 404, y: 481 },
			{ x: 544, y: 482 },
			{ x: 313, y: 596 },
			{ x: 495, y: 596 }
		]
		this.default_index = 0

		this.load_callback = () => {
			this.LoadSuccess()
		}
	}

	public LoadSuccess() {
		if (PlatformManager.IsEyouEnPlatform()) {
			this._Label1.height = 39
			this._Label1.width = 149
			this._Label1.leading = 0.1
			this._Label1.wordWrap =true
			this._Label1.pos(10,16)
			this._Label1.align="center"
			this._Label1.valign="middle"
			this._Label1.fontSize = 20
			this._Label4.x = 77
			this._Label4.width = 370
			this._Label4.align="center"
			this._Label5.x = -39
			this._Label5.width = 370
			this._Label5.align="center"
		}
		this.res_mgr.SetOutsideImageSprite(this, this._bg4, "resource/game/composite/other/ui_merge_01.png")
		this.cfg_menu_id = this.res_mgr.GetGameConfigFromCache(this, "config_compose_menu_id", false)
		this.cfg_goods_compose = this.res_mgr.GetGameConfigFromCache(this, "config_goods_compose", false)
		this.cfg_goods_sub = this.res_mgr.GetGameConfigFromCache(this, "GoodsSubtype", false)

		this.InitView()
		this.InitEvent()
	}

	public InitView() {
		let i = 1
		do {
			let key = UnrealModel.goods_type + "@" + i
			let cfg = this.cfg_goods_sub[key]
			if (cfg) {
				if (this["_sub_btn_label" + (i - 1)]) {
					this["_sub_btn_label" + (i - 1)].text = cfg.subtype_name
				}
			}
			i = i + 1
		} while ((i <= UnrealModel.equip_count))

		if (!this.mat_item_list) {
			this.mat_item_list = []
		}
		i = 0
		do {
			let item = new CompositeUnrealMatItem(this._gp_mats)
			item.Load()
			item.SetIndex(i)
			item.SetPosition(this.mat_pos[i].x, this.mat_pos[i].y)
			this.mat_item_list[i] = item
			i = i + 1
		} while ((i < this.mat_pos.length))

		if (!this.tab_name_list) {
			this.tab_name_list = this.model.GetUnrealComposeNameList(this.cfg_menu_id)
		}
		if (!this.tab_bar) {
			this.tab_bar = new UIVerTabBar(this._scroll_tab)
			this.tab_bar.Load()
		}
		let call_fun = (tab_index?, sub_index?) => {
			if (!this.display_obj.visible) {
				return
			}
			this.SwitchView(tab_index, sub_index)
		}

		/*
		if (PlatformMgr.GetInstance().IsEyouKrPlatform()) {
			this.tab_bar.SetTabBar(this.tab_name_list, call_fun, -this._scroll_tab.rect.y, null, null, null, null, null, null, null, 22)
		} else {
			this.tab_bar.SetTabBar(this.tab_name_list, call_fun, -this._scroll_tab.rect.y)
		}
		*/
		this.tab_bar.SetTabBar(this.tab_name_list, call_fun, GetSizeDeltaY(this._scroll_tab), null, null, null, GetSizeDeltaY(this._scroll_tab))
		let index, sub_index
		[index, sub_index] = this.RefreshRed()
		this.tab_bar.SetSelectTab(index, sub_index)
		this.SwitchView(index, sub_index)
	}

	public InitEvent() {
		let click_func = (target?) => {
			let i = 0
			do {
				if (this["sub_btn" + i] == target.currentTarget) {
					this.SwitchSubView(i)
					break
				}
				i = i + 1
			} while ((i < UnrealModel.equip_count))
		}

		let i = 0
		do {
			if (this["sub_btn" + i]) {
				Util.AddClickEvent(this["sub_btn" + i], click_func, this, true)
			}
			i = i + 1
		} while ((i < UnrealModel.equip_count))

		this.BindEvent(this.model, CompositeEvent.SELECT_UNREAL_GOODS, (index?, info?) => {
			let item = this.mat_item_list[index]
			if (item) {
				item.SetData(info.goods_id)
				if (!this.goodsid_to_index) {
					this.goodsid_to_index = []
				}
				this.goodsid_to_index[info.goods_id] = index
			}
			this.model.selected_unreal_list[index] = info.goods_id
			this.UpdateSuccessRatio()
			this.RefreshOneKeyAddRed()
		})

		this.BindEvent(this.model, CompositeEvent.UNINSTALL_UNREAL, (goods_id?) => {
			let index = this.goodsid_to_index[goods_id]
			let item = this.mat_item_list[index]
			if (item) {
				item.SetData(false)
				this.model.selected_unreal_list[index] = null
			}
			delete this.goodsid_to_index[goods_id]
			this.UpdateSuccessRatio()
			this.RefreshOneKeyAddRed()
		})

		Util.AddClickEvent(this._gp_composite, () => {
			if (!this.now_compose_data) {
				return
			}
			if (!this.mat_count_bool) {
				Message.show("物品不足,无法合成")
				return
			}
			let rule_id = this.now_compose_data.id

			let regular_list = []

			let regular_mat = this.now_compose_data.regular_mat
			let goods_vo
			let need_count = 0
			let goods_list = 0
			let type_id = 0
			for (let _ in regular_mat) {
				let data = regular_mat[_]
				goods_vo = data[0]
				type_id = Number(goods_vo[1])
				need_count = Number(goods_vo[2])
				goods_list = GoodsModel.GetInstance().GetTypeGoods(type_id)
				let index = 0
				for (let i = index; i < need_count; i++) {
					goods_vo = goods_list[i]
					if (goods_vo) {
						table.insert(regular_list, goods_vo.goods_id)
					}
				}
			}

			let irregular_list = []
			for (let index in this.model.selected_unreal_list) {
				let goods_id = this.model.selected_unreal_list[index]
				if (goods_id) {
					table.insert(irregular_list, goods_id)
				}
			}
			this.model.Fire(CompositeEvent.REQUEST_PROTO, rule_id, regular_list, irregular_list)
		}, this, true)

		Util.AddClickEvent(this._gp_one_key_add, () => {
			let irregular_mat_cfg = this.now_compose_data.irregular_mat
			if (!this.now_compose_data) {
				Message.show("未解锁装备")
				return
			}
			let hole_list = this.now_compose_data.hole_list
			let select_count = 0
			let index = 0
			let i = 0
			do {
				if (Number(hole_list[i]) == 2) {
					if (!this.model.selected_unreal_list[i]) {
						let goods_list = this.model.GetUnrealCompositeList(irregular_mat_cfg, index)
						if (goods_list && goods_list.length > 0) {
							let goodsVo = goods_list[0]
							if (goodsVo) {
								select_count = select_count + 1
								this.model.Fire(CompositeEvent.SELECT_UNREAL_GOODS, i, goodsVo)
							}
						}
						index = index + 1
					}
				}
				i = i + 1
			} while ((i < hole_list.length))
			if (!select_count) {
				Message.show("没有满足要求的装备~")
				return
			}
			this.RefreshOneKeyAddRed()
		}, this, true)

		this.BindEvent(this.model, CompositeEvent.COMPOSE_SUCCESS, (rule_id?, goods_id?) => {
			if (this.now_compose_data && rule_id == this.now_compose_data.id) {
				let list = this.now_compose_data.goods
				let com = [0, list[0][1], 1, goods_id]
				let success_view = new CongratulationObtainView([com], 10)
				success_view.Open()
				this.model.selected_unreal_list = []
				this.UpdateUnrealEquip()
				this.UpdateSuccessRatio()
				this.RefreshOneKeyAddRed()
			}
		})

		this.BindEvent(this.model, CompositeEvent.COMPOSE_Fail, () => {
			SoundManager.GetInstance().PlaySoundEffect("guildboss")
			// this.AddUIEffect("effect_hechengshibai", this._gp_effect, null, 2, null, 2, null, null, null, null, null, null, false)
			PlayBigEffect("effect_hechengshibai", null, 2)
			this.model.selected_unreal_list = []
			this.UpdateUnrealEquip()
			this.UpdateSuccessRatio()
			//this.CompositeFailAni()
			this.RefreshOneKeyAddRed()
		})

		this.BindEvent(this.goods_model, GoodsModel.CHANGE_UNREAL_BAG_LIST, () => {
			this.RefreshRed()
			this.RefreshSubRed()
			this.RefreshOneKeyAddRed()
		})

		this.BindEvent(this.goods_model, GoodsModel.UPDATE_GOODS_NUM, (goods_list?) => {
			if (this.use_delete_method) {
				return
			}
			for (let _tmpi in goods_list) {
				let vo = goods_list[_tmpi]
				if ((this.now_compose_data && this.now_compose_data.cost) && Number(this.now_compose_data.cost[2]) == vo.type_id) {
					//this:UpdateCostMat()
					this.RefreshSubRed()
					this.RefreshRed()
				}
			}
		})

		/*
		Util.AddClickEvent(this._img_cost, () => {
			if (this.now_compose_data && this.now_compose_data.cost) {
				UIToolTipMgr.GetInstance().DefaultAppendTips(this.now_compose_data.cost[1], 0)
			}
		}, this, true)
		*/
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
		let tab_id_list = this.model.unreal_tab_id_list
		for (let sub_id in tab_id_list) {
			let sub_list = tab_id_list[sub_id]
			let sub_red = false
			for (let sub_sub_id in sub_list) {
				let sub_sub_red = false
				let composite_id_list = sub_list[sub_sub_id]
				for (let _tmpi in composite_id_list) {
					let composite_id = composite_id_list[_tmpi]
					if (this.model.UnrealCanCompose(composite_id)) {
						sub_sub_red = true
						break
					}
				}
				if (sub_sub_red) {
					if (!tab_index) {
						tab_index = Number(sub_id)
					}
					if (!tab_sub_index) {
						tab_sub_index = Number(sub_sub_id)
					}
					sub_red = true
				}
				this.tab_bar.setSubTabRedDot(sub_id, sub_sub_id, sub_sub_red)
			}
			this.tab_bar.setTabRedDot(sub_id, sub_red)
		}
		tab_index = tab_index || 0
		tab_sub_index = tab_sub_index || 0
		return [tab_index, tab_sub_index]
	}

	public UpdateView() {
		let tab_index = this.cur_tab_index
		let sub_index = this.cur_sub_tab_index
		let tab_id_list = this.model.unreal_tab_id_list
		let compose_list = (tab_id_list && tab_id_list[tab_index]) && tab_id_list[tab_index][sub_index]
		if (compose_list) {
			this.now_compose_list = compose_list
			if (this.cur_index) {
				if (this["_sub_btn_img" + this.cur_index]) {
					ResManager.GetInstance().SetImageSprite(this, this["_sub_btn_img" + this.cur_index], "common", "ui_button_rect13")
					this["_sub_btn_label" + this.cur_index].color = "#ffffff"
				}
			}
			this.cur_index = null
			this.SwitchSubView(this.default_index)
			this.RefreshSubRed()
		}
	}

	public SwitchSubView(index?) {
		if (this.cur_index == index) {
			return
		}

		if (this.cur_index || this.cur_index == 0) {
			if (this["_sub_btn_img" + this.cur_index]) {
				ResManager.GetInstance().SetImageSprite(this, this["_sub_btn_img" + this.cur_index], "common", "ui_button_rect13")
				this["_sub_btn_label" + this.cur_index].color = "#ffffff"
			}
		}

		if (this["_sub_btn_img" + index]) {
			ResManager.GetInstance().SetImageSprite(this, this["_sub_btn_img" + index], "common", "ui_button_rect12")
			this["_sub_btn_label" + index].color = "#663915"
		}

		this.cur_index = index
		this.UpdateSubView()
	}

	public UpdateSubView() {
		let compose_id = this.now_compose_list[this.cur_index]
		let now_compose_cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_goods_compose.name, Number(compose_id), false, this.cfg_goods_compose)
		if (!now_compose_cfg) {
			return
		}
		this.now_compose_data = {
			id: now_compose_cfg.id,
			subtype: now_compose_cfg.subtype,
			regular_mat: this.erlang_parser.Parse(now_compose_cfg.regular_mat),
			irregular_mat: this.erlang_parser.Parse(now_compose_cfg.irregular_mat),
			goods: this.erlang_parser.Parse(now_compose_cfg.goods),
			hole_list: this.erlang_parser.Parse(now_compose_cfg.hole_list),
			ratio: this.erlang_parser.Parse(now_compose_cfg.ratio),
			cost: this.erlang_parser.Parse(now_compose_cfg.cost)[1]
		}
		let test = this.erlang_parser.Parse(now_compose_cfg.regular_mat)

		this.model.selected_unreal_list = []

		if (this.now_compose_data) {
			if (!this.target_item) {
				this.target_item = new EquipmentItem(this._gp_award)
				this.target_item.Load()
				this.target_item.SetItemSize(96, 96)
			}
			let goods = this.now_compose_data.goods
			if (goods) {
				this.target_item.SetData(goods[0][1])
			}
		}
		let hole_list = this.now_compose_data.hole_list
		let regular_mat_cfg = this.now_compose_data.regular_mat
		let regular_mat_index = 0
		let irregular_mat_cfg = this.now_compose_data.irregular_mat
		for (let index in this.mat_item_list) {
			let item = this.mat_item_list[index]
			let hole_id = Number(hole_list[index])
			let parm = {}
			if (hole_id) {
				parm["hole_id"] = hole_id
				if (1 == hole_id) {
					parm["regular_id"] = regular_mat_cfg[regular_mat_index]
					regular_mat_index = regular_mat_index + 1
				} else if (2 == hole_id) {
					parm["irregular_mat_cfg"] = irregular_mat_cfg
				} else if (3 == hole_id) {
					parm = false
				}
				item.SetParm(parm)
			} else {
				item.SetParm(false)
			}
		}
		this.UpdateSuccessRatio()
		this.UpdateUnrealEquip()
		this.RefreshOneKeyAddRed()
		//this.UpdateCostMat()
	}

	public UpdateCostMat() {
		this.cost_bool = false
		let cost = this.now_compose_data && this.now_compose_data.cost
		if (cost) {
			/*
			let basic = this.goods_model.GetGoodsBasicByTypeId(cost[1])
			if (basic) {
				ResManager.GetInstance().SetOutsideImageSprite(this, this._img_cost, GameResPath.GetGoodsIconPath(basic.goods_icon))
			}
			*/
			let my_count = this.goods_model.GetTypeGoodsNum(cost[1])
			let cost_count = cost[2]
			this.cost_bool = my_count >= Number(cost_count)
			//this._lb_cost.textFlow = Util.StrToHTML(HtmlColorTxt(my_count, this.cost_bool && "#b3ff48" || "#fe140d") + "/" + cost_count)
		}
	}

	public RefreshSubRed() {
		let index = 0
		for (let _tmpi in this.now_compose_list) {
			let sub_id = this.now_compose_list[_tmpi]
			let is_can_compose = this.model.UnrealCanCompose(sub_id)
			let red_obj = this["_sub_btn_red" + index]
			if (red_obj) {
				red_obj.visible = is_can_compose
			}
			index = index + 1
		}
	}

	public UpdateSuccessRatio() {
		let bool = true
		let regular_mat = this.now_compose_data.regular_mat
		if (regular_mat) {
			let goods_vo
			let need_count = 0
			let my_count = 0
			let type_id = 0
			for (let _ in regular_mat) {
				let data = regular_mat[_]
				goods_vo = data[0]
				type_id = Number(goods_vo[1])
				need_count = Number(goods_vo[2])
				my_count = GoodsModel.GetInstance().GetTypeGoodsNum(type_id)
				if (my_count < need_count) {
					bool = false
					break
				}
			}
		}

		if (bool) {
			let need_count = 0
			for (let _tmpi in this.now_compose_data.ratio) {
				let vo = this.now_compose_data.ratio[_tmpi]
				if (vo[1] == "100") {
					need_count = vo[0]
					break
				}
			}
			let my_count = 0
			for(let i = 0;i<this.model.selected_unreal_list.length;i++){
				if(this.model.selected_unreal_list[i]!=null){
					my_count++
				}
			}
			bool = my_count >= Number(need_count)
		}
		this.mat_count_bool = bool
		this._img_composite_red.visible = this.mat_count_bool
	}

	public UpdateUnrealEquip() {
		for (let index in this.mat_item_list) {
			let goods_id = this.model.selected_unreal_list[index]
			this.mat_item_list[index].SetData(goods_id || false)
		}
	}

	public CompositeFailAni() {
		// this._img_fail.y = 450
		// this._img_fail.visible = true
		// this._img_fail.alpha = 1
		// local_laya.Tween.removeTweens(this._img_fail)
		// let delay_func = () => {
		// 	if (this._img_fail ) {
		// 		this._img_fail.visible = false
		// 	}
		// }

		// local_laya.Tween.get(this._img_fail):to({y=300}, 1000):wait(200):to({alpha=0}, 800).call(delay_func)
	}

	public RefreshOneKeyAddRed() {
		let bool = false
		if (this.now_compose_data) {
			let hole_list = this.now_compose_data.hole_list

			let my_count = 0
			for(let i = 0;i<this.model.selected_unreal_list.length;i++){
				if(this.model.selected_unreal_list[i]!=null){
					my_count++
				}
			}
			
			let cost_count = 0
			for (let _tmpi in hole_list) {
				let type = hole_list[_tmpi]
				if (Number(type) == 2) {
					cost_count = cost_count + 1
				}
			}
			if (my_count != cost_count) {
				if (this.model.UnrealCanCompose(this.now_compose_data.id)) {
					bool = true
				}
			}
		}
		this._img_one_key_add_red.visible = bool
	}

	public DeleteMe() {
		if (this.mat_item_list) {
			for (let _ = 0; _ < this.mat_item_list.length; _++) {
				let obj = this.mat_item_list[_]
				obj.DeleteMe()
			}
			this.mat_item_list = false
		}

		if (this.tab_bar) {
			this.tab_bar.DeleteMe()
			this.tab_bar = false
		}

		if (this.target_item) {
			this.target_item.DeleteMe()
			this.target_item = false
		}

		super.DeleteMe()
	}

	_bg2: Laya.Image
	_bg4: Laya.Image
	_Image9: Laya.Image
	_Label1: Laya.Label
	_bg5: Laya.Image
	_bg6: Laya.Image
	_gp_one_key_add: Laya.Box
	_Image2: Laya.Image
	_Label2: Laya.Label
	_img_one_key_add_red: Laya.Image
	_gp_composite: Laya.Box
	_Image3: Laya.Image
	_Label3: Laya.Label
	_img_composite_red: Laya.Image
	_Group1: Laya.Box
	_Image4: Laya.Image
	_Image5: Laya.Image
	_Label4: Laya.Label
	_Image7: Laya.Image
	_Label5: Laya.Label
	_gp_radio_btns: Laya.Box
	radio0: Laya.Box
	sub_btn0: Laya.Box
	_sub_btn_img0: Laya.Image
	_sub_btn_label0: Laya.Label
	_sub_btn_red0: Laya.Image
	radio1: Laya.Box
	sub_btn1: Laya.Box
	_sub_btn_img1: Laya.Image
	_sub_btn_label1: Laya.Label
	_sub_btn_red1: Laya.Image
	radio2: Laya.Box
	sub_btn2: Laya.Box
	_sub_btn_img2: Laya.Image
	_sub_btn_label2: Laya.Label
	_sub_btn_red2: Laya.Image
	radio3: Laya.Box
	sub_btn3: Laya.Box
	_sub_btn_img3: Laya.Image
	_sub_btn_label3: Laya.Label
	_sub_btn_red3: Laya.Image
	radio4: Laya.Box
	sub_btn4: Laya.Box
	_sub_btn_img4: Laya.Image
	_sub_btn_label4: Laya.Label
	_sub_btn_red4: Laya.Image
	radio5: Laya.Box
	sub_btn5: Laya.Box
	_sub_btn_img5: Laya.Image
	_sub_btn_label5: Laya.Label
	_sub_btn_red5: Laya.Image
	_gp_award: Laya.Box
	_bg7: Laya.Image
	_gp_mats: Laya.Box
	_scroll_tab: Laya.Box
	_img_fail: Laya.Image
	_gp_effect: Laya.Box
	public GetComponents() {
		[
			this._bg2,
			this._bg4,
			this._Image9,
			this._Label1,
			this._bg5,
			this._bg6,
			this._gp_one_key_add,
			this._Image2,
			this._Label2,
			this._img_one_key_add_red,
			this._gp_composite,
			this._Image3,
			this._Label3,
			this._img_composite_red,
			this._Group1,
			this._Image4,
			this._Image5,
			this._Label4,
			this._Image7,
			this._Label5,
			this._gp_radio_btns,
			this.radio0,
			this.sub_btn0,
			this._sub_btn_img0,
			this._sub_btn_label0,
			this._sub_btn_red0,
			this.radio1,
			this.sub_btn1,
			this._sub_btn_img1,
			this._sub_btn_label1,
			this._sub_btn_red1,
			this.radio2,
			this.sub_btn2,
			this._sub_btn_img2,
			this._sub_btn_label2,
			this._sub_btn_red2,
			this.radio3,
			this.sub_btn3,
			this._sub_btn_img3,
			this._sub_btn_label3,
			this._sub_btn_red3,
			this.radio4,
			this.sub_btn4,
			this._sub_btn_img4,
			this._sub_btn_label4,
			this._sub_btn_red4,
			this.radio5,
			this.sub_btn5,
			this._sub_btn_img5,
			this._sub_btn_label5,
			this._sub_btn_red5,
			this._gp_award,
			this._bg7,
			this._gp_mats,
			this._scroll_tab,
			this._img_fail,
			this._gp_effect,
		]
			= this.GetChildrenByNames([

				"_bg2",
				"_bg4",
				"_Image9",
				"_Label1",
				"_bg5",
				"_bg6",
				"_gp_one_key_add",
				"_Image2",
				"_Label2",
				"_img_one_key_add_red",
				"_gp_composite",
				"_Image3",
				"_Label3",
				"_img_composite_red",
				"_Group1",
				"_Image4",
				"_Image5",
				"_Label4",
				"_Image7",
				"_Label5",
				"_gp_radio_btns",
				"radio0",
				"sub_btn0",
				"_sub_btn_img0",
				"_sub_btn_label0",
				"_sub_btn_red0",
				"radio1",
				"sub_btn1",
				"_sub_btn_img1",
				"_sub_btn_label1",
				"_sub_btn_red1",
				"radio2",
				"sub_btn2",
				"_sub_btn_img2",
				"_sub_btn_label2",
				"_sub_btn_red2",
				"radio3",
				"sub_btn3",
				"_sub_btn_img3",
				"_sub_btn_label3",
				"_sub_btn_red3",
				"radio4",
				"sub_btn4",
				"_sub_btn_img4",
				"_sub_btn_label4",
				"_sub_btn_red4",
				"radio5",
				"sub_btn5",
				"_sub_btn_img5",
				"_sub_btn_label5",
				"_sub_btn_red5",
				"_gp_award",
				"_bg7",
				"_gp_mats",
				"_scroll_tab",
				"_img_fail",
				"_gp_effect",
			])
	}
}
window["CompositeUnrealView"] = CompositeUnrealView
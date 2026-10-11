import { BaseItem1 } from "../common/BaseItem1"
import { table } from "../common/table"
import { Util } from "../util/Util"
import { Message } from "../sysInfo/SysInfoController"
import { ErlangParser } from "../util/ErlangParser"
import { GoodsModel, GoodsType } from "../commonModel/GoodsModel"
import { CompositeModel, CompositeEvent } from "../commonModel/CompositeModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventName } from "../common/EventName"
import { UIVerTabBar } from "../newgameui/UIVerTabBar"
import { EquipmentItem } from "../common/EquipmentItem"
import { Alert, Alert_Type } from "../alert/Alert"
import { GetSizeDeltaY } from "../util/Util"
import { ResManager } from "../common/ResManager"
import { Config } from "../common/Config"
import { ComGoodsResloveView } from "./ComGoodsResloveView"
import { CompositeGoodsMatItem } from "./CompositeGoodsMatItem"
import { SoundManager } from "../common/SoundManager"
import { PlatformManager } from "../PlatformManager"

export class CompositeGoodsView extends BaseItem1 {
	InitEvent
	InitView
	LoadSuccess
	LocalDeleteMe
	RefreshRed
	SetNum
	SwitchView
	UpdateSuccessRatio
	UpdateView
	calculator_fun

	comMax
	curNum
	cur_sub_tab_index
	cur_tab_index

	mat_1_pos
	mat_2_pos
	mat_3_pos
	mat_item_list

	model
	now_compose_data

	resloveIndex
	resloveView
	success_radio
	tab_bar
	tab_name_list
	target_item

	cfg_menu_id
	res_mgr

	public constructor(parent?) {
		super(parent)
		this.base_file = "composite"
		this.layout_file = "CompositeGoodsView"
		this.dependent_res = ["newgameui"]
		this.preload_server_config = {
			"config_compose_menu_id": false
		}

		this.comMax = 0
		this.mat_1_pos = [{ x: 405, y: 550 }]
		this.mat_2_pos = [{ x: 247, y: 550 }, { x: 520, y: 550 }]
		this.mat_3_pos = [{ x: 265, y: 550 }, { x: 405, y: 550 }, { x: 545, y: 550 }]
		this.curNum = 1

		this.model = CompositeModel.GetInstance()
		this.res_mgr = ResManager.GetInstance()
		let local_Message = Message
		let goods_model = GoodsModel.GetInstance()
		let local_CompositeEvent = CompositeEvent
		let erlang_parser = ErlangParser.GetInstance()

		this.load_callback = () => {
			if (PlatformManager.IsEyouEnPlatform()) {
				this._Label2.height = 39
				this._Label2.width = 149
				this._Label2.leading = 0.1
				this._Label2.wordWrap =true
				this._Label2.pos(10,16)
				this._Label2.align="center"
				this._Label2.valign="middle"
				this._Label2.fontSize = 20
				this.lb_title.pos(303,34)
				this.lb_title.width = 282
				this.lb_title.align="center"
			}
			this.LoadSuccess()
		}

		this.LoadSuccess = () => {
			//this.AddUIEffect2("ui_compound_Rune", this._gp_effect, null, null, true)
			//this._scroll_tab.vScrollBar.visible = false
			this.cfg_menu_id = this.res_mgr.GetGameConfigFromCache(this, "config_compose_menu_id", false)
			this.res_mgr.SetOutsideImageSprite(this, this._img_bg0, "resource/game/composite/other/ui_merge_01.png")

			this.InitView()
			this.InitEvent()
		}

		this.InitView = () => {
			if (!this.tab_name_list) {
				this.tab_name_list = this.model.GetGoodsComposeNameList(this.cfg_menu_id)
				this.resloveIndex = Util.TableSize(this.tab_name_list)
				table.insert(this.tab_name_list, { 0: "宝石拆解", 1: ["宝石拆解"] })
			}
			if (!this.tab_bar) {
				this.tab_bar = new UIVerTabBar(this.gp_tab)
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

			this.tab_bar.SetTabBar(this.tab_name_list, call_fun, GetSizeDeltaY(this.gp_tab), null, null, null, GetSizeDeltaY(this.gp_tab))
			let index, sub_index
			[index, sub_index] = this.RefreshRed()
			this.tab_bar.SetSelectTab(index, sub_index)
			this.SwitchView(index, sub_index)
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._gp_composite, () => {
				if (!this._img_composite_red.visible) {
					local_Message.show("物品不足")
					return
				}
				if (!this.now_compose_data) {
					return
				}
				let rule_id = this.now_compose_data.id
				let regular_list = []
				let regular_mat = this.now_compose_data.regular_mat
				//let isBind = false
				let selectList = []
				// for (let _tmpi in regular_mat) {
				// 	let vo = regular_mat[_tmpi]
				// 	let count = vo[2]
				// 	let goods_list = goods_model.GetTypeGoods(vo[1])
				// 	if (goods_list) {
				// 		for (let index in goods_list) {
				// 			let goods_vo = goods_list[index]
				// 			//攻击宝石 防御宝石的合成不出现绑定提示弹窗
				// 			if(goods_vo.type==GoodsType.Gem)continue
				// 			if (goods_vo.bind != 0) {
				// 				isBind = true
				// 				break
				// 			}
				// 		}
				// 	}
				// }
				let irregular_list = []
				let okFunc = () => {
					this.model.Fire(local_CompositeEvent.GOODS_COMPOSE, rule_id, this.curNum, regular_mat, irregular_list)
				}

				// if (isBind) {
				// 	Alert.Show("当前合成材料中存在绑定的材料，合成后的道具也将是绑定的，是否确认进行合成？", Alert_Type.Two, okFunc)
				// } else {
					okFunc()
				// }
			}
				, this, true)
			this.BindEvent(this.model, local_CompositeEvent.COMPOSE_SUCCESS, (rule_id?, call_back?) => {
				if (this.now_compose_data && rule_id == this.now_compose_data.id) {
					if (call_back) {
						call_back()
					}

					this.UpdateSuccessRatio()
					let index, sub_index, notFind
					[index, sub_index, notFind] = this.RefreshRed()
					if (!notFind) {
						this.tab_bar.SetSelectTab(index, sub_index, true)
						this.SwitchView(index, sub_index)
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
			Util.AddClickEvent(this.reduceBtn, () => {
				this.SetNum(this.curNum - 1)
			}
				, this, true)
			Util.AddClickEvent(this.increaseBtn, () => {
				this.SetNum(this.curNum + 1)
			}
				, this, true)
			Util.AddClickEvent(this.maxBtn, () => {
				this.SetNum(this.comMax || 1)
			}
				, this, true)
			Util.AddClickEvent(this.numBg, () => {
				this.calculator_fun()
			}
				, this, true)
		}

		this.SwitchView = (tab_index?, sub_index?) => {
			if (this.cur_tab_index == tab_index && this.cur_sub_tab_index == sub_index) {
				return
			}
			this.cur_tab_index = tab_index
			this.cur_sub_tab_index = sub_index
			if (this.resloveIndex == tab_index) {
				this.comGp.visible = false
				this.resloveGp.visible = true
				if (!this.resloveView) {
					this.resloveView = new ComGoodsResloveView(this.resloveGp)
					this.resloveView.Load()
				}
			} else {
				this.comGp.visible = true
				this.resloveGp.visible = false
				this.UpdateView()
			}
		}

		this.RefreshRed = () => {
			let tab_index = null
			let tab_sub_index = null
			let tab_id_list = this.model.goods_tab_id_list
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
							tab_index = sub_id
						}
						if (tab_sub_index == null) {
							tab_sub_index = sub_sub_id
						}
						sub_red = true
					}
					//let tab_item = ((this.tab_bar && this.tab_bar.tab_item_list) && this.tab_bar.tab_item_list[sub_id]) && this.tab_bar.tab_item_list[sub_id].sub_tab_item_list[sub_sub_id]
					//if (tab_item ) {
					this.tab_bar.setSubTabRedDot(sub_id, sub_sub_id, sub_sub_red)
					//}
				}
				//let tab_item = (this.tab_bar && this.tab_bar.tab_item_list) && this.tab_bar.tab_item_list[sub_id]
				//if (tab_item ) {
				this.tab_bar.setTabRedDot(sub_id, sub_red)
				//}
			}
			return [tab_index || 0, tab_sub_index || 0, tab_sub_index == null]
		}

		this.UpdateView = () => {
			let tab_index = this.cur_tab_index
			let sub_index = this.cur_sub_tab_index
			let tab_id_list = this.model.goods_tab_id_list
			let compose_cfg = (tab_id_list && tab_id_list[tab_index]) && tab_id_list[tab_index][sub_index]
			let compose_id = (compose_cfg && compose_cfg[0]) && compose_cfg[0][0]
			if (compose_id) {
				let now_compose_cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_goods_compose.name, Number(compose_id), false, Config.PRELOAD_SERVER_CONFIG.config_goods_compose)
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
				if (this.now_compose_data) {
					if (!this.target_item) {
						this.target_item = new EquipmentItem(this._gp_reward)
						this.target_item.SetItemSize(80, 80)
						this.target_item.Load()
					}
					let goods = this.now_compose_data.goods
					if (goods) {
						this.target_item.SetData(goods[0][1])
					}
				}
				let hole_list = this.now_compose_data.hole_list
				let holeNum = 0
				for (let _tmpi in hole_list) {
					let vo = hole_list[_tmpi]
					if (vo == '1') {
						holeNum = holeNum + 1
					}
				}
				this._img_mat0.visible = holeNum == 1 || holeNum == 3
				this._img_mat1.visible = holeNum == 2 || holeNum == 3
				//this._img_mat2.visible = holeNum == 3
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
					let item = this.mat_item_list[index]
					if (!item) {
						item = new CompositeGoodsMatItem(this.comGp)
						item.Load()
						//item.SetScale(1.1)
						table.insert(this.mat_item_list, item)
					}
					let parm = { hole_id: 1, regular_mat: { type_id: Number(vo[1]), count: Number(vo[2]) } }
					let temp_i = index
					item.SetPosition(pos[temp_i].x, pos[temp_i].y)
					//item:ExcuteCallback(() => {
					item.SetData(parm)
					item.SetVisible(true)
					//}
					//)
					index = index + 1
				}
				if (this.mat_item_list && holeNum < this.mat_item_list.length) {
					let i = holeNum
					do {
						let item = this.mat_item_list[i]
						if (item) {
							item.SetVisible(false)
						}
						i = i + 1
					} while ((i < this.mat_item_list.length))
				}
				this.UpdateSuccessRatio()
			}
		}

		this.UpdateSuccessRatio = () => {
			let success_radio = 0
			let max = 0
			let selectList = []
			let regular_bool = true
			if (this.now_compose_data) {
				if (1 == this.now_compose_data.subtype) {
					let regular_mat_dic = this.now_compose_data.regular_mat
					for (let _tmpi in regular_mat_dic) {
						let vo = regular_mat_dic[_tmpi]
						let count = Number(vo[2])
						let my_count = goods_model.GetTypeGoodsNum(vo[1])
						if (my_count < (count - (selectList[vo[1]] || 0))) {
							regular_bool = false
							break
						}
						if (selectList[vo[1]]) {
							selectList[vo[1]] = selectList[vo[1]] + Number(count)
						} else {
							selectList[vo[1]] = Number(count)
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
			//this.success_radio = success_radio
			this._img_composite_red.visible = this.comMax > 0
			if (this.comMax == 0) {
				this.comMax = 1
			}
			this.SetNum(this.comMax || 1)
		}

		this.SetNum = (num?) => {
			if (num <= 0) {
				local_Message.show("已达到最小数量")
				return
			}
			if (num > 1 && num > this.comMax) {
				local_Message.show("已达到最大数量")
				return
			}
			this.curNum = num
			this.numLb.text = num
		}

		this.calculator_fun = () => {
			let max_num = this.comMax
			let num_change_fun = (value?) => {
				this.SetNum(value)
			}
			GlobalEventSystem.Fire(EventName.OPEN_CALCULATOR_VIEW, max_num, num_change_fun, [10, 240], null, 1)
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
			if (this.resloveView) {
				this.resloveView.DeleteMe()
				this.resloveView = null
			}
		}
	}

	public DeleteMe() {
		this.LocalDeleteMe()
		super.DeleteMe()
	}

	comGp: Laya.Box
	_img_mat0: Laya.Image
	_img_mat1: Laya.Image
	_img_mat2: Laya.Image
	_img_bg0: Laya.Image
	titleimg: Laya.Image
	lb_title: Laya.Label
	_img_bg3: Laya.Image
	_gp_effect: Laya.Box
	_gp_reward: Laya.Box
	_lb_radio: Laya.Label
	_gp_composite: Laya.Box
	_Image1: Laya.Image
	_Label1: Laya.Label
	_img_composite_red: Laya.Image
	lb_tips: Laya.Label
	reduceBtn: Laya.Image
	increaseBtn: Laya.Image
	maxBtn: Laya.Image
	numBg: Laya.Image
	numLb: Laya.Label
	resloveGp: Laya.Box
	tabline: Laya.Image
	_Image2: Laya.Image
	_Label2: Laya.Label
	_img_arrow: Laya.Image
	gp_tab: Laya.Box
	attr: Laya.Label
	public GetComponents() {
		[
			this.comGp,
			this._img_mat0,
			this._img_mat1,
			this._img_mat2,
			this._img_bg0,
			this.titleimg,
			this.lb_title,
			this._img_bg3,
			this._gp_effect,
			this._gp_reward,
			this._lb_radio,
			this._gp_composite,
			this._Image1,
			this._Label1,
			this._img_composite_red,
			this.lb_tips,
			this.reduceBtn,
			this.increaseBtn,
			this.maxBtn,
			this.numBg,
			this.numLb,
			this.resloveGp,
			this.tabline,
			this._Image2,
			this._Label2,
			this._img_arrow,
			this.gp_tab,
			this.attr,
		]
			= this.GetChildrenByNames([

				"comGp",
				"_img_mat0",
				"_img_mat1",
				"_img_mat2",
				"_img_bg0",
				"titleimg",
				"lb_title",
				"_img_bg3",
				"_gp_effect",
				"_gp_reward",
				"_lb_radio",
				"_gp_composite",
				"_Image1",
				"_Label1",
				"_img_composite_red",
				"lb_tips",
				"reduceBtn",
				"increaseBtn",
				"maxBtn",
				"numBg",
				"numLb",
				"resloveGp",
				"tabline",
				"_Image2",
				"_Label2",
				"_img_arrow",
				"gp_tab",
				"attr",
			])
	}
}
window["CompositeGoodsView"] = CompositeGoodsView
import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItem1 } from "../common/BaseItem1"
import { Config } from "../common/Config"
import { EventName } from "../common/EventName"
import { FightingShowSmallItem } from "../common/FightingShowSmallItem"
import { LayerManager, Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { SoundManager } from "../common/SoundManager"
import { table } from "../common/table"
import { UI_MODEL_TYPE } from "../common/UIModelClass3D"
import { ItemUseController } from "../commonController/ItemUseController"
import { FashionModel } from "../commonModel/FashionModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { RoleManager } from "../commonModel/RoleManager"
import { FashionPartPos, ModelPartName, SceneBaseType } from "../scene/SceneConfig"
import { Message } from "../sysInfo/SysInfoController"
import { TaskFinishView } from "../task/TaskFinishView"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { LoadLuaConfigAB, Util, GetSizeDeltaY, Trim, PlayBigEffect, RefBoxVLayout } from "../util/Util"
import { Vector3 } from "../util/Vector3"
import { FashionAttrItem } from "./FashionAttrItem"
import { FashionColorItem } from "./FashionColorItem"
import { FashionItem } from "./FashionItem"
import { FashionLevelView } from "./FashionLevelView"



let local_FashionModel = FashionModel
export class FashionMainView extends BaseItem1 {
	_color = 0
	_res = 0
	color_items = []
	fashion_awarditem: BaseAwardItem
	fashion_loop_list: LoopScrowViewMgr
	fighting_font: string = "fighting_font"
	fight_item: FightingShowSmallItem
	fashion_model: FashionModel = FashionModel.GetInstance()
	role_mgr: RoleManager = RoleManager.GetInstance()
	current_index = 0
	cur_vo
	default_id
	select_fashion_id
	attr_item_list = []
	fashion_pos_id = FashionModel.FashionType.Fashion
	cache_fashion_scmd

	public constructor(parent?) {
		super(parent)
		this.base_file = "fashion"
		this.layout_file = "FashionMainView"
		this.layer_value = Enum_UILayer.UI

		this.load_callback = () => {
			this.cur_vo = { pos_id: this.fashion_pos_id, id: 0, order: 0, own_num: 0, need_num: 0, base_order: 0 }
			this.CreateFashionList()
			this.LoadSuccess()
		}
	}

	public LoadSuccess = () => {
		//resource/game/fashion/other/ui_role_65.png
		ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("fashion", "ui_role_65"))

		this.fight_item = new FightingShowSmallItem(this._box_fight)
		this.fight_item.Load()
		this.fight_item.IsCenter(true, false)

		this._list_fashion_item.vScrollBarSkin = ""
		this._panel_attr_item.vScrollBarSkin = ""

		if (this.fashion_pos_id == local_FashionModel.FashionType.Fashion) {
			ResManager.GetInstance().SetImageSprite(this, this._img_grade, "fashion_asset", "ui_role_icon_4", true)
		} else if (this.fashion_pos_id == local_FashionModel.FashionType.Head) {
			ResManager.GetInstance().SetImageSprite(this, this._img_grade, "fashion_asset", "uiszv3_003a", true)
			this._img_grade.visible = false
		}
		let OrderButCallBack = () => {
			let _id = this.cur_vo["id"]
			let _need_num = this.cur_vo["need_num"]
			let _own_num = this.cur_vo["own_num"]
			let _order = this.cur_vo["order"]
			let color = this.cur_vo["color"]

			if(_need_num == 0){
				Message.show("阶数已满级")
				return
			}
			if (_own_num >= Number(_need_num) && _need_num > 0) {
				if (_order == 0) {
					if (color == 0) {
						this.fashion_model.Fire(local_FashionModel.SCMD_REQUEST, 41304, this.fashion_pos_id, _id, color)
					} else {
						this.fashion_model.Fire(local_FashionModel.SCMD_REQUEST, 41301, this.fashion_pos_id, _id, color, 2)
					}
				} else {
					if (color == 0) {
						this.fashion_model.Fire(local_FashionModel.SCMD_REQUEST, 41306, this.fashion_pos_id, _id, color)
					}
					else {
						this.fashion_model.Fire(local_FashionModel.SCMD_REQUEST, 41316, this.fashion_pos_id, _id, color)
					}
				}
			} else {
				Message.show("道具数量不足")
			}
		}
		Util.AddClickEvent(this._box_activate, OrderButCallBack, this, true)

		let WearButCallBack = () => {
			let list = this.fashion_model.fashion_wear_list[this.fashion_pos_id]
			if (!list) {
				return
			}
			if (this.cur_vo && this.cur_vo.order > 0) {
				let pos_info = this.fashion_model.fashion_info_dic[this.fashion_pos_id]
				let active = this.fashion_model.fashion_active_dic[this.fashion_pos_id][this.cur_vo.id]
				if (active && active.now_color_id == this.cur_vo.color && this.cur_vo.id == pos_info.wear_fashion_id) {
					this.fashion_model.Fire(local_FashionModel.SCMD_REQUEST, 41303, this.fashion_pos_id, this.cur_vo.id)
				} else {
					this.fashion_model.Fire(local_FashionModel.SCMD_REQUEST, 41302, this.fashion_pos_id, this.cur_vo.id, this.cur_vo.color)
				}
			} else if (this.cur_vo && this.cur_vo.order == 0) {
				Message.show("激活可穿戴")
			}
		}
		Util.AddClickEvent(this._img_box, WearButCallBack, this, true)

		let OpenFashionLevelView = () => {
			let fashionLevelView = new FashionLevelView()
			fashionLevelView.Open(this.fashion_pos_id)
		}

		Util.AddClickEvent(this._img_grade, OpenFashionLevelView, this, true)


		let UpdateView = (pos_id?, type_id?) => {
			if (pos_id != this.fashion_pos_id || !this.fashion_loop_list) {
				return
			}
			this.UpdateView()
			if (type_id) {
				let source = (type_id == 1 && ("uity_045ca") || ("uity_045da"))
				ResManager.GetInstance().SetImageSprite(this, this._img_box, "common_asset", source)
				let str = (type_id == 1 && ("穿戴成功") || ((type_id == 2 && ("卸下成功") || (""))))
				if (str != "") {
					Message.show(str)
				}
				return
			}
			this.ShowGradeRed()
			this.SetFashionDetails(this._list_fashion_item.selectedIndex, this.cur_vo.color)
			this.InitColorItem()
		}

		this.BindEvent(this.fashion_model, local_FashionModel.UPDATEVIEW, UpdateView)

		this.BindVar(RoleManager.GetInstance().GetMainRoleVo(), "fashion_model_list", () => {
			if(this._list_fashion_item){
				this.SetFashionDetails(this._list_fashion_item.selectedIndex, this.cur_vo.color, true)
			}
		})

		let ShowEffect = (pos_id?, type_id?) => {
			if (pos_id != this.fashion_pos_id) {
				return
			}
			if (1 == type_id) {
				PlayBigEffect("ui_shengjitexiao")
			} else if (2 == type_id) {
				PlayBigEffect("ui_shengjitexiao")
			}

			let wear_list = this.fashion_model.fashion_wear_list
			let list = wear_list && wear_list[this.fashion_pos_id]
			let cur_index = this._list_fashion_item.selectedIndex
			let fashion_id = list[cur_index].fashion_id
			this.fashion_model.Fire(local_FashionModel.SCMD_REQUEST, 41312, this.fashion_pos_id, fashion_id)
		}
		this.BindEvent(this.fashion_model, local_FashionModel.SUCCESSOPERATE, ShowEffect)

		this.BindEvent(this.fashion_model, FashionModel.SELECTCOLOR, (pos?, color_id?) => {
			if (this.fashion_pos_id == pos) {
				this.SetFashionDetails(this._list_fashion_item.selectedIndex, color_id)
			}
		})

		this.BindEvent(FashionModel.GetInstance(), FashionModel.UPDATE_FIGHT, (scmd?) => {
			if (scmd && this.select_fashion_id == scmd.fashion_id) {
				this.cache_fashion_scmd = scmd
				this.UpdatePower()
			}
		})
	}

	public UpdatePower = () =>{
		let scmd = this.cache_fashion_scmd
		if(!scmd) return
		if(scmd.fashion_id != this.select_fashion_id){
			this.cache_fashion_scmd = null
			return
		}	
		if(!this.fight_item) return
		for(let vo of scmd.color_power_list){
			if(vo.color_id == this.cur_vo["color"]){
				this.fight_item.Updatefighting(vo.color_power);
				if (vo.next_color_power == 0) {
					this.fight_item.UpdatefightingUp(0);
					this.fight_item.IsCenter(true, false);
				} else {
					this.fight_item.UpdatefightingUp(vo.next_color_power - vo.color_power);
					this.fight_item.SetPowerOffset(this.fight_item.display_obj.width / 4);
				}
				break
			}
		}
	}

	public CreateFashionList = () => {
		let wear_list = this.fashion_model.fashion_wear_list
		let list = wear_list && wear_list[this.fashion_pos_id]
		if (!list) {
			return
		}
		if (!this.fashion_loop_list) {
			let ListTouchCallBack = (e?) => {
				SoundManager.GetInstance().PlaySoundEffect("2_dianji")
				let color = this.SelectDefultColor(this._list_fashion_item.selectedIndex)
				this.SetFashionDetails(this._list_fashion_item.selectedIndex, color)
				this.InitColorItem()
				// this.fashion_loop_list.replaceAll(list)
				let cur_index = this._list_fashion_item.selectedIndex
				this.select_fashion_id = list[cur_index].fashion_id
				this.fashion_model.Fire(local_FashionModel.SCMD_REQUEST, 41312, this.fashion_pos_id, this.select_fashion_id)

			}
			this.fashion_loop_list = new LoopScrowViewMgr()
			this.fashion_loop_list.SetData(this._list_fashion_item, FashionItem, list, LoopScrCon.Vertical, 1, ListTouchCallBack)
		} else {
			this.fashion_loop_list.replaceAll(list)
		}


		if (!this.default_id) {
			let red_list = this.fashion_model.fashion_base_red_dic
			if (red_list && !Util.IsTableEmpty(red_list[this.fashion_pos_id])) {
				for (let _index in list) {
					let _id = list[_index][0]
					if (red_list[this.fashion_pos_id][_id]) {
						this.current_index = Number(_index)
						break
					}
				}
			} else {
				this.current_index = 0
			}
		} else {
			this._list_fashion_item.selectedIndex = 0
			for (let _index in list) {
				if (list[_index][0] == this.default_id[0]) {
					this.current_index = Number(_index)
					break
				}
			}
		}
		this.InitScroll(this.current_index)
		this.fashion_loop_list.SetSelectIndex(this.current_index)
		this._list_fashion_item.scrollTo(this.current_index - 3)
		let color = this.SelectDefultColor(this.current_index)
		this.SetFashionDetails(this._list_fashion_item.selectedIndex, color)
		this.InitColorItem()
		this.ShowGradeRed()

	}

	public UpdateView = () => {
		let wear_list = this.fashion_model.fashion_wear_list
		let list = wear_list && wear_list[this.fashion_pos_id]
		if (!list) {
			return
		}
		if (this.fashion_loop_list) {
			this.fashion_loop_list.replaceAll(list)
			this.fashion_loop_list.SetSelectIndex(this.current_index)
		}
	}

	public ShowGradeRed = () => {
		this._img_grade_red.visible = this.fashion_model.GetLevelRed(this.fashion_pos_id)
	}

	public ShowModel = (_res?, bool?, color?, force?) => {
		if (this._res == _res && this._color == color && !bool && !force) { return }
		this._res = _res
		this._color = color
		let role_vo = this.role_mgr.GetMainRoleVo()
		let [role_res, texture_id] = [_res, color]
		let [head_model_id, head_clothe_id] = [_res, color]
		//时装界面只显示普通时装和头发
		let getTextureId = (vo?, type?) => {
			let model_res_list = vo.fashion_model_list
			if (model_res_list && !Util.IsTableEmpty(model_res_list)) {
				for (let k = 0; k < model_res_list.length; k++) {
					var v = model_res_list[k]
					if (v.part_pos == type) {
						return [v.fashion_model_id, v.fashion_chartlet_id]
					}
				}
			}
			model_res_list = vo.level_model_list
			if (model_res_list && !Util.IsTableEmpty(model_res_list)) {
				for (let k = 0; k < model_res_list.length; k++) {
					var v = model_res_list[k]
					if (v.part_pos == type) {
						return [v.level_model_id, 0]
					}
				}
			}
		}

		if (this.fashion_pos_id == local_FashionModel.FashionType.Head) {
			[role_res, texture_id] = getTextureId(role_vo, FashionPartPos.Clothe)
		} else {
			[head_model_id, head_clothe_id] = getTextureId(role_vo, FashionPartPos.Head)
		}
		let weapon_res = role_vo.GetWeaponClotheId()
		let data = {
			career: role_vo.career,
			sex: role_vo.sex,
			clothe_res_id: role_res,
			weapon_res_id: weapon_res,
			weapon_clothe_id: 0,
			position: new Vector3(0, -0.5, 0),
			type: UI_MODEL_TYPE.MAINROLE,
			scale: 1.2,
			texture_id: texture_id,
			fashion_model_id: role_res,
			head_wear_id: head_model_id,
			head_clothe_id: head_clothe_id,
			hair_id: 0,//role_vo.GetRoleHairId(),
			// layout_file : this.layout_file,
		}
		ResManager.GetInstance().SetRoleModel(this, this._box_model, data)
	}

	public CreateModel = (model_index?, color?, force?) => {
		let model_dic = this.fashion_model.fashion_current_user_model_dic
		let model_id = model_dic[model_index] && model_dic[model_index].model_id
		if (color != 0) {
			model_id = FashionModel.GetInstance().config_fashion_model[model_index].model_id
		}
		if (model_id) {
			this.ShowModel(model_id, null, color, force)
		}
	}

	public InitScroll = (_index?) => {
		let wear_list = this.fashion_model.fashion_wear_list && this.fashion_model.fashion_wear_list[this.fashion_pos_id]
		if ((!wear_list || !this._list_fashion_item) || !this._list_fashion_item) {
			return
		}
		let item_num = wear_list.length
		this._list_fashion_item.refresh()
		let contentheight = this._list_fashion_item.scrollBar.max
		let height = GetSizeDeltaY(this._list_fashion_item)
		let item_height = contentheight / item_num * _index
		if (item_height > height / 2 && item_height < contentheight - height / 2) {
			this.fashion_loop_list.CenterOnChild(_index)
		} else if (item_height <= height / 2) {
			this.fashion_loop_list.ResetScrowViewPanel()
		} else if (item_height > contentheight - height / 2) {
			this.fashion_loop_list.LastOnChild(_index)
		}
	}

	public SetFashionDetails = (index?, color?, force?) => {
		if (!color) {
			color = 0
		}
		this.current_index = index
		let list = this.fashion_model.fashion_wear_list[this.fashion_pos_id]
		let pos_info = this.fashion_model.fashion_info_dic[this.fashion_pos_id]
		if ((list && list[index]) && pos_info) {
			let id = list[index].fashion_id
			this.cur_vo.id = id
			let pos_id = this.fashion_pos_id
			let career = this.role_mgr.GetMainRoleVo().career
			let sex = this.role_mgr.GetMainRoleVo().sex
			let model_index = pos_id + "@" + id + "@" + career + "@" + sex + "@" + color
			this.CreateModel(model_index, color, force)
			let order, base_order
			let act_list = this.fashion_model.fashion_active_dic
			if ((act_list && act_list[this.fashion_pos_id]) && act_list[this.fashion_pos_id][id]) {
				let color_list = act_list[this.fashion_pos_id][id].color_list
				if (color_list) {
					for (let k in color_list) {
						var v = color_list[k]
						if (v.color_id == color) {
							order = v.fashion_star_lv
						}
						if (v.color_id == 0) {
							base_order = v.fashion_star_lv
						}
						
					}
				}
			}
			if(!base_order){
				base_order = 0
			}
			if (!order) {
				order = 0
			}
			let next_key, now_key 
			this.cur_vo.base_order =  base_order
			this.cur_vo.order = order
			this.cur_vo.color = color
			let is_wear = id == pos_info.wear_fashion_id && act_list[this.fashion_pos_id] && act_list[this.fashion_pos_id][id] && act_list[this.fashion_pos_id][id].now_color_id == color
			this.cur_vo["is_wear"] = is_wear
			
			let goodinfo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(id)
			if (goodinfo && color == 0) {
				this._lb_name.text = goodinfo.goods_name
			} else {
				let cfg = FashionModel.GetInstance().config_fashion_model//Config.Fashionmodel[model_index]
				this._lb_name.text = cfg && Trim(cfg[model_index].name)
			}

			let cfgs
			if (color == 0) {
				next_key = pos_id + "@" + id + "@" + (order + 1)
				now_key = pos_id + "@" + id + "@" + order
				cfgs = FashionModel.GetInstance().config_fashion
			} else {
				next_key = pos_id + "@" + id + "@" + color + "@" + (order + 1)
				now_key = pos_id + "@" + id + "@" + color + "@" + order
				cfgs = FashionModel.GetInstance().config_fashion_color
			}
			let next_cfg = cfgs[next_key]
			let now_cfg = cfgs[now_key]

			if (order != 0) {
				this._img_box.visible = true
				let source = is_wear && "uity_045ca" || "uity_045da"
				this._img_box.skin = GameResPath.GetIcon("common", source)
				this._lb_dress_tips.text = "穿戴"
				this._lb_order.text = "[" + order + "阶]"
				if (next_cfg) {
					this._lb_activate_desc.text = "进阶"
					this.SetButGray(this._box_activate, false)
					let attr_0_list = now_cfg.attr_list
					let attr_1_list = next_cfg.attr_list
					this.FashionAttShow(attr_0_list, attr_1_list)
					this.SetFashionItem(id, order, true)
				} else {
					this._lb_activate_desc.text = "已满阶"
					this.SetButGray(this._box_activate, true)
					if (!now_cfg) {
						return
					}
					let attr_0_list = now_cfg.attr_list
					this.FashionAttShow(attr_0_list, null)
					this.SetFashionItem(id, order, false)
				}
			} else {
				this._img_box.visible = false
				this._lb_order.text = "[未激活]"
				this._lb_activate_desc.text = "激活"
				this.SetButGray(this._box_activate, false)
				if (!next_cfg) {
					return
				}
				let attr_1_list = next_cfg.attr_list
				let attr_0_list = null
				this.FashionAttShow(attr_0_list, attr_1_list)
				this.SetFashionItem(id, order, true)
			}
			this.UpdatePower()
		}
	}

	public SetButGray = (but, bool) => {
		Util.SetImageGray(but, bool)
	}

	public SetFashionItem = (_id?, _order?, is_show?) => {
		this._box_fashion_num.visible = is_show
		if (!this.fashion_awarditem) {
			this.fashion_awarditem = new BaseAwardItem(this._box_award)
			this.fashion_awarditem.SetItemSize(85, 85)
			this.fashion_awarditem.Load()
		}
		let is_gary = false, cfgs, star_cost, key
		let color = this.cur_vo.color

		if (color == 0) {
			key = this.fashion_pos_id + "@" + _id + "@" + (_order + 1)
			cfgs = this.fashion_model.config_fashion
		} else {
			key = this.fashion_pos_id + "@" + _id + "@" + color + "@" + (_order + 1)
			cfgs = FashionModel.GetInstance().config_fashion_color// Config.Fashioncolor
		}

		let cost = null
		let cfg = cfgs[key]
		if (cfg) {
			if (_order == 0) {
				cost = cfg.active_cost
			} else {
				cost = cfg.star_cost
			}
		} else {
			if (color == 0) {
				key = this.fashion_pos_id + "@" + _id + "@" + _order
			} else {
				key = this.fashion_pos_id + "@" + _id + "@" + color + "@" + _order
			}
			cfg = cfgs[key]
			if(cfg){
				cost = cfg.star_cost
			}
		}

		if (cost) {
			star_cost = JSON.parse(cost)
		}
		if (is_show) {
			if (!star_cost) {
				return
			}
			let own_num = GoodsModel.GetInstance().GetTypeGoodsNum(star_cost[0][1])
			let need_num = star_cost[0] && Number(star_cost[0][2])
			let color_path
			if (own_num >= need_num) {
				color_path = "#00fa64"
				this._img_red.visible = true
			} else {
				color_path = "#ff4f50"
				this._img_red.visible = false
			}
			this.cur_vo.own_num = own_num
			this.cur_vo.need_num = need_num
			this._lb_own.text = own_num
			this._lb_own.color = color_path
			this._lb_need.text = "/" + need_num
			this._lb_need.color = color_path
		} else {
			this._img_red.visible = false
			this.cur_vo.need_num = 0 
			is_gary = true
		}
		this.fashion_awarditem.ExcuteCallback(() => {
			if (star_cost) {
				this.fashion_awarditem.SetData(star_cost[0][1], null, 0)
			}
			this.fashion_awarditem.SetGary(is_gary)
		})
	}

	public FashionAttShow = (attr_0_list?, attr_1_list?) => {
		let main_list = null
		if (attr_0_list) {
			attr_0_list = JSON.parse(attr_0_list)
			main_list = attr_0_list
		}
		if (attr_1_list) {
			attr_1_list = JSON.parse(attr_1_list)
			if (!main_list) {
				main_list = attr_1_list
			}
		}
		if (this.attr_item_list.length > 0) {
			for (let _tmpi in this.attr_item_list) {
				var item = this.attr_item_list[_tmpi]
				item.visible = false
			}
		}
		if (main_list) {
			for (let i in main_list) {
				let item = this.attr_item_list[i]
				if (!item) {
					item = new FashionAttrItem(this._panel_attr_item)
					item.Load()
					table.insert(this.attr_item_list, item)
				}
				item.SetPosition(0, Number(i) * 30)
				item.SetVisible(true)
				item.ExcuteCallback(() => {
					item.visible = true
					let attr_0 = (attr_0_list && (attr_0_list[i]) || (attr_0_list))
					let attr_1 = (attr_1_list && (attr_1_list[i]) || (attr_1_list))
					item.SetData(main_list[i], attr_0, attr_1)
				})
			}

			for(let i = main_list.length; i < this.attr_item_list.length; i++){
				this.attr_item_list[i].SetVisible(false)
			}
		}
	}

	public InitColorItem = () => {
		let color_count = this.fashion_model.GetColorCfg(this.fashion_pos_id, this.cur_vo.id)
		if (!color_count) { 
			this._box_color_item.visible = false
			this._img_color_bg.visible = false
			return 
		}

		this._box_color_item.visible = true
		this._img_color_bg.visible = true

		color_count++ //加一个默认颜色

		let fashion_info = this.fashion_model.GetFashionInfo(this.fashion_pos_id, this.cur_vo.id)
		for (let i = 0; i < color_count; i += 1) {
			let item = this.color_items[i]
			if (!item) {
				item = new FashionColorItem(this._box_color_item)
				item.Load()
				this.color_items[i] = item
			}
			item.SetPosition(i * 86, 0)
			item.ExcuteCallback(() => {
				let data = {
					pos: this.fashion_pos_id,
					fashion_id: this.cur_vo.id,
					color_id: i,
					fashion_info: fashion_info,
					is_select: i == this.cur_vo.color,
					index: this.current_index
				}
				item.SetData(data)
				item.SetVisible(true)
			})
		}

		let total_width = color_count * 86 - 2
		this._box_color_item.width = total_width
		this._img_color_bg.width = total_width + 40

		if (color_count < this.color_items.length) {
			for (let i = color_count; i < this.color_items.length; i += 1) {
				this.color_items[i].SetVisible(false)
			}
		}
	}

	public SelectDefultColor = (index?) => {
		let list = this.fashion_model.fashion_wear_list[this.fashion_pos_id]
		if (list && list[index]) {
			let id = list[index].fashion_id
			let fashion_info = this.fashion_model.GetFashionInfo(this.fashion_pos_id, id)
			if (!fashion_info) { // 未激活
				return 0
			} else {
				let color_list = fashion_info.color_list
				let color_num = this.fashion_model.GetColorCfg(this.fashion_pos_id, id)
				if (!color_num) { return 0 }
				//先判断是否有可激活的

				for (let i = 0; i < color_num; i += 1) {
					let is_activa = false
					for (let k in color_list) {
						var v = color_list[k]
						if (v.color_id == i) { //存在即已激活
							is_activa = true
							break
						}
					}
					if (!is_activa && this.fashion_model.GetColorRed(this.fashion_pos_id, id, i)) { //未激活，有红点
						return i
					}
				}
				//再判断是否有可升级的

				for (let i = 0; i <= color_num; i += 1) {
					if (i == 0) {
						if (this.fashion_model.IsRed(this.fashion_pos_id, id, true)) {
							return i
						}
					} else {
						for (let k in color_list) {
							var v = color_list[k]
							if (v.color_id == i && this.fashion_model.GetColorRed(this.fashion_pos_id, id, i)) { //已激活，有红点
								return i
							}
						}
					}

				}
				//选择第一个
				return 0
			}
		}
		return 0
	}

	public CustomMehod = (index, ...new_args) => {
		let parms = new_args
		if (parms) {
			this.default_id = parms[0]
		}
	}

	public DeleteMe() {
		if (this.fight_item) {
			this.fight_item.DeleteMe()
			this.fight_item = null
		}
		if (this.fashion_awarditem) {
			this.fashion_awarditem.DeleteMe()
			this.fashion_awarditem = null
		}
		if (this.attr_item_list.length > 0) {
			for (let _tmpi in this.attr_item_list) {
				var item = this.attr_item_list[_tmpi]
				item.DeleteMe()
			}
			this.attr_item_list.length = 0
		}
		if (this.fashion_loop_list) {
			this.fashion_loop_list.DeleteMe()
			this.fashion_loop_list = null
		}
		if (this.color_items) {
			for (let k in this.color_items) {
				var v = this.color_items[k]
				v.DeleteMe()
			}
			this.color_items.length = 0
		}
		super.DeleteMe()
	}

	_box_fight: Laya.Box
	_box_model: Laya.Box
	_lb_name: Laya.Label
	_lb_order: Laya.Label
	_box_activate: Laya.Box
	_lb_activate_desc: Laya.Label
	_img_red: Laya.Image
	_list_fashion_item: Laya.List
	_img_grade: Laya.Image
	_img_grade_red: Laya.Image
	_box_award: Laya.Box
	_box_fashion_num: Laya.HBox
	_lb_own: Laya.Label
	_lb_need: Laya.Label
	_panel_attr_item: Laya.Panel
	_img_box: Laya.Image
	_lb_dress_tips: Laya.Label
	_img_color_bg: Laya.Image
	_box_color_item: Laya.Box
	_img_bg: Laya.Image
	public GetComponents() {
		[
			this._box_fight,
			this._box_model,
			this._lb_name,
			this._lb_order,
			this._box_activate,
			this._lb_activate_desc,
			this._img_red,
			this._list_fashion_item,
			this._img_grade,
			this._img_grade_red,
			this._box_award,
			this._box_fashion_num,
			this._lb_own,
			this._lb_need,
			this._panel_attr_item,
			this._img_box,
			this._lb_dress_tips,
			this._img_color_bg,
			this._box_color_item,
			this._img_bg
		]
			= this.GetChildrenByNames([

				"_box_fight",
				"_box_model",
				"_lb_name",
				"_lb_order",
				"_box_activate",
				"_lb_activate_desc",
				"_img_red",
				"_list_fashion_item",
				"_img_grade",
				"_img_grade_red",
				"_box_award",
				"_box_fashion_num",
				"_lb_own",
				"_lb_need",
				"_panel_attr_item",
				"_img_box",
				"_lb_dress_tips",
				"_img_color_bg",
				"_box_color_item",
				"_img_bg"
			])
	}
}
window["FashionMainView"] = FashionMainView
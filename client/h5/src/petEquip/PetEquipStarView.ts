import { BaseItem1 } from "../common/BaseItem1";
import { EquipmentItem } from "../common/EquipmentItem";
import { EventName } from "../common/EventName";
import { ResManager } from "../common/ResManager";
import { UIToolTipMgr } from "../common/UIToolTipMgr";
import { GoodsModel } from "../commonModel/GoodsModel";
import { PetEquipEvent, PetEquipDefine, PetEquipType } from "../commonModel/PetEquipDefine";
import { PetEquipModel } from "../commonModel/PetEquipModel";
import { Message } from "../sysInfo/SysInfoController";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { GameResPath } from "../util/GameResPath";
import { Util } from "../util/Util";
import { PetEquipAttrItem } from "./PetEquipAttrItem";
import { PetEquipSelectItem } from "./PetEquipSelectItem";

import "./PEHStarShowItem"
import "./PEPStarShowItem"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr";

export class PetEquipStarView extends BaseItem1 {
	_Image111: Laya.Image
	_Image2: Laya.Image
	_Image3: Laya.Image
	_Image4: Laya.Image
	_Image5: Laya.Image
	_Image6: Laya.Image
	_Image7: Laya.Image
	_Group1: Laya.Box
	_lb_title1: Laya.Label
	_Image8: Laya.Image
	_Image9: Laya.Image
	_Image10: Laya.Image
	_Group2: Laya.Box
	_lb_title2: Laya.Label
	_Image11: Laya.Image
	_Image12: Laya.Image
	_Image13: Laya.Image
	_Group3: Laya.HBox
	_lb_stage_cur: Laya.Label
	_lb_stage_max: Laya.Label
	_group_up_stage: Laya.Box
	_Image14: Laya.Image
	_lb_stage_next: Laya.Label
	_Group5: Laya.HBox
	_Group4: Laya.HBox
	_lb_star_cur: Laya.Label
	_Image15: Laya.Image
	_lb_star_max: Laya.Label
	_group_up_star: Laya.HBox
	_Image16: Laya.Image
	_lb_star_next: Laya.Label
	_Image17: Laya.Image
	_btn_help: Laya.Image
	_lb_attr: Laya.Label
	_dg_attr: Laya.List
	_btn_stren: Laya.Box
	_Image1: Laya.Image
	labelDisplay: Laya.Label
	_reddot: Laya.Image
	_group_item: Laya.Box
	_img_icon: Laya.Image
	_bg_scr1: Laya.Image
	_bg_scr2: Laya.Image
	_list: Laya.List
	_list_equip: Laya.List
	_group_eff: Laya.Box




	LoadSuccess
	InitEvent
	CustomMehod
	UpdateView
	UpdateChooseItems
	UpdateEquipItems
	UpdateAttrList
	SelectEquipItem
	ChooseItem
	UpdateShowData
	UpdateShowDataByChoose
	UpdateShowItem
	ClickShowItem
	GetChooseData
	GetEquips
	UpdateRedDot
	UpdateEffect
	GetEquipFirst
	_list_loop_mgr
	_list_equip_loop_mgr
	attr_loop_mgr
	public constructor(parent?) {
		super(parent)
		this.base_file = "petEquip"
		this.layout_file = "PetEquipStarView"

		let _model = PetEquipModel.GetInstance(),
			local_Util = Util,
			local_Message = Message,
			local_PetEquipEvent = PetEquipEvent,
			goods_model = GoodsModel.GetInstance(),
			local_GoodsModel = GoodsModel,
			res_mgr = ResManager.GetInstance(),
			local_PetEquipDefine = PetEquipDefine,
			local_Math = Math,
			_show_item_: EquipmentItem,
			_type_: PetEquipType,
			_ac_list_,
			_ac_equip_,
			_ac_attr_,
			_goods_list_,
			_cur_show_data_,
			_cur_choose_data_,
			_cur_choose_item_: PetEquipSelectItem,
			_show_attr_list_ = [],
			last_select = 0

		this.load_callback = () => {
			this.LoadSuccess()
		}

		this.LoadSuccess = () => {
			ResManager.GetInstance().SetTexture(this, this._Image111,GameResPath.GetIcon( "petEquip", "uiwg_052a"))
			// ResManager.GetInstance().SetTexture(this, this._Image2, GameResPath.GetIcon("petEquip", "uiwg_052c"))
			// ResManager.GetInstance().SetTexture(this, this._Image3, GameResPath.GetIcon("petEquip", "uiwg_053a"))

			// _ac_list_ = new Array
			// this._list.dataSource = _ac_list_
			// this._list.itemRender = PetEquipSelectItem
			// this._list.selectHandler=this.ChooseItem

			// this._list.on(local_eui.ItemTapEvent.ITEM_TAP,this, this.ChooseItem)

			// _ac_equip_ = new Array
			// this._list_equip.dataSource = _ac_equip_
			// this._list_equip.itemRender = _model.GetShowItemClass(_type_, 3)
			// this._list_equip.selectHandler=this.SelectEquipItem
			// this._list_equip.on(Laya.Event.i.ITEM_TAP,this, this.SelectEquipItem)

			// _ac_attr_ = new Array
			// this._dg_attr.dataSource = _ac_attr_
			// this._dg_attr.itemRender = PetEquipAttrItem

			let equips = this.GetEquips()

			let [index, data] = this.GetEquipFirst(equips)
			this._list_equip.selectedIndex = index
			_cur_show_data_ = data
			this.UpdateEquipItems(equips,index)

			_goods_list_ = _model.GetStarGoods(_type_, _cur_show_data_, true)
			_cur_choose_data_ = _goods_list_[0]
			if (_cur_choose_data_) {
				_cur_choose_data_._is_select = true
			}
			this.UpdateChooseItems(_goods_list_)
			this.UpdateShowData()
			this.UpdateShowDataByChoose()

			this.InitEvent()
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._btn_stren, () => {
				if (!_cur_show_data_) {
					return
				}
				if (!_cur_show_data_.goods_id) {
					local_Message.show("需要穿戴一件装备")
					return
				}
				if (!_cur_choose_data_ || !_cur_choose_data_.goods_id) {
					local_Message.show("无可吞噬物品")
					return
				}
				let goods_id = _cur_show_data_.goods_id
				let goods_id2 = _cur_choose_data_.goods_id
				_model.Fire(local_PetEquipEvent.REQUEST_PROTO, 16017, "cll", _type_, goods_id, goods_id2)
			}, this, true)

			Util.AddClickEvent(this._btn_help, () => {
				GlobalEventSystem.Fire(EventName.OPEN_INSTRUCTION_VIEW, 16012)
			}, this, true)

			this.BindEvent(_model, local_PetEquipEvent.STAR_SUCCESS, () => {
				this.UpdateEffect()
			})

			this.BindEvent(goods_model, local_GoodsModel.CHANGE_HORSE_BAG_LIST, () => {
				if (_type_ != PetEquipType.HORSE) {
					return
				}
				this.UpdateView()
			})

			this.BindEvent(goods_model, local_GoodsModel.CHANGE_PARTNER_BAG_LIST, () => {
				if (_type_ != PetEquipType.PARTNER) {
					return
				}
				this.UpdateView()
			})

			this.BindEvent(_model, local_PetEquipEvent.UPDATE_RED_STATUS, (type?) => {
				if (_type_ != type) {
					return
				}
				this.UpdateRedDot()
			})

			this.BindEvent(_model, local_PetEquipEvent.UPDATE_INFO, (type?) => {
				if (_type_ != type) {
					return
				}
				this.UpdateView()
			})
		}

		this.CustomMehod = (index?, parms?) => {
			_type_ = parms[0]
		}

		this.UpdateView = () => {
			_goods_list_ = _model.GetStarGoods(_type_, _cur_show_data_, true)
			_cur_choose_data_ = _goods_list_[0]
			if (_cur_choose_data_) {
				_cur_choose_data_._is_select = true
			}
			if (_cur_show_data_) {
				let pos = _cur_show_data_.goods_id ? _cur_show_data_.equip_type : _cur_show_data_.pos
				_cur_show_data_ = _model.GetWearEquipInfo(_type_, pos) || { type: _type_, pos: pos }
			}
			this.UpdateChooseItems(_goods_list_)
			this.UpdateEquipItems()
			this.UpdateShowData()
			this.UpdateShowDataByChoose()
		}

		this.UpdateChooseItems = (list?) => {
			// _ac_list_.source = list
			if (!this._list_loop_mgr) {
				this._list_loop_mgr = new LoopScrowViewMgr()
				this._list_loop_mgr.SetData(this._list, PetEquipSelectItem, list, LoopScrCon.Vertical, null, this.ChooseItem)
			} else {
				this._list_loop_mgr.replaceAll(list)
			}
		}

		this.UpdateEquipItems = (list?,index?) => {
			list = list || this.GetEquips()
			// _ac_equip_.source = list
			if (!this._list_equip_loop_mgr) {
				this._list_equip_loop_mgr = new LoopScrowViewMgr()
				this._list_equip_loop_mgr.SetData(this._list_equip, _model.GetShowItemClass(_type_, 3), list, LoopScrCon.Horizontal, null, this.SelectEquipItem,index)
			} else {
				this._list_equip_loop_mgr.replaceAll(list)
			}
		}

		this.UpdateAttrList = (list, IsNull?) => {
			if (!list) {
				return
			}
			if (!this.attr_loop_mgr) {
				this.attr_loop_mgr = new LoopScrowViewMgr()
				this.attr_loop_mgr.SetData(this._dg_attr, PetEquipAttrItem, list, LoopScrCon.Vertical)
			} else {
				this.attr_loop_mgr.replaceAll(list)
			}
		}

		this.SelectEquipItem = (e?) => {
			if (!this._list_equip_loop_mgr.parent._array) {
				return
			}
			if (_cur_show_data_ == this._list_equip_loop_mgr.parent._array[e]) {
				return
			}
			if (!this._list_equip_loop_mgr.parent._array[e].goods_id) {
				local_Message.show("需先穿戴装备")
				this._list_equip.selectedIndex = last_select
				return
			}
			last_select = e
			_cur_show_data_ = this._list_equip_loop_mgr.parent._array[e]

			_goods_list_ = _model.GetStarGoods(_type_, _cur_show_data_, true)
			this.UpdateChooseItems(_goods_list_)
			_cur_choose_data_ = _goods_list_[0]
			if (_cur_choose_data_) {
				_cur_choose_data_._is_select = true
			}
			this.UpdateShowData()
			this.UpdateShowDataByChoose()
		}

		this.ChooseItem = (e?) => {
			if (e==undefined) {
				return
			}
			if (!this._list_loop_mgr.parent._array) {
				return
			}
			if (_cur_choose_data_ == this._list_loop_mgr.parent._array[e]) {
				return
			}
			if (_cur_choose_data_) {
				_cur_choose_data_._is_select = false
			}
			_cur_choose_data_ = this._list_loop_mgr.parent._array[e]
			this._list_loop_mgr.parent._array[e]._is_select=true
			this._list.selectedIndex = e
			this._list_loop_mgr.replaceAll(_goods_list_)
			this.UpdateShowData()
			this.UpdateShowDataByChoose()
		}

		this.UpdateShowData = () => {
			let data = _cur_show_data_
			if (!data) {
				return
			}
			if (data.goods_id) {
				let edata = _model.GetPetEquipData(_type_, data.goods_id)
				if (!edata) {
					return
				}
				let pet_equip_pos_lv_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_pet_equip_pos_lv", false)
				let attr_list = _model.GetAllAttrList(_type_, data.goods_id, pet_equip_pos_lv_cfg)
				// _ac_attr_.source = attr_list
				this.UpdateAttrList(attr_list)
				_show_attr_list_ = attr_list

				let mdata = _model.GetMaxData(_type_, data.equip_type)
				let star_max = mdata.star <= edata.star
				let stage_max = mdata.stage <= edata.stage
				this._lb_star_max.visible = star_max
				this._lb_stage_max.visible = stage_max

				this._lb_stage_cur.text = `${edata.stage}阶`
				this._lb_star_cur.text = edata.star
			} else {
				// _ac_attr_.source = []
				this.UpdateAttrList([])
				this._lb_stage_cur.text = "0阶"
				this._lb_star_cur.text = "0"
				this._lb_star_max.visible = false
				this._lb_stage_max.visible = false
			}
			this._group_up_stage.visible = false
			this._group_up_star.visible = false
			this.UpdateShowItem(data)
			this.UpdateRedDot()
			this._Group3.refresh()
			this._Group5.refresh()
		}

		this.UpdateShowDataByChoose = () => {
			let data = _cur_show_data_
			let cdata = _cur_choose_data_
			if (!data || !data.type_id || !cdata) {
				return
			}
			this.UpdateShowItem(data)
			let [starData, stageData] = this.GetChooseData()
			if (!starData || !stageData) {
				// this._Group5.centerX=50
				// this._Group3.centerX=50
				return
			}
			let edata = _model.GetPetEquipData(_type_, data.goods_id)
			if (!edata) {
				return
			}
			let star_list = JSON.parse(starData.attr_list)
			let stage_list = JSON.parse(stageData.attr_list)
			let pet_equip_pos_lv_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_pet_equip_pos_lv", false)
			let lvData = _model.GetLvData(_type_, edata.pos_id, edata.pos_lv, pet_equip_pos_lv_cfg)
			let lv_list = JSON.parse(lvData.attr_list)
			let attr_list = _model.GetAttrListByMultList(lv_list, star_list, stage_list)

			let add_list = _model.GetAddAttrList(_show_attr_list_, attr_list)
			// _ac_attr_.source = add_list
			this.UpdateAttrList(add_list)

			let up_star = edata.star < starData.star
			let up_stage = edata.stage < stageData.stage
			this._group_up_stage.visible = up_stage
			this._group_up_star.visible = up_star
			if (up_star) {
				this._lb_star_next.text = starData.star
			}else{
				// this._Group5.centerX=55
			}
			if (up_stage) {
				this._lb_stage_next.text = `${stageData.stage}阶`
			}else{
				// this._Group3.centerX=55
			}
		}

		this.UpdateShowItem = (data?) => {
			if (!_show_item_) {
				_show_item_ = new EquipmentItem(this._group_item)
				_show_item_.Load()
				_show_item_.SetClickCallBack(this.ClickShowItem)
				_show_item_.SetItemSize(87,87)
				// _show_item_.ExcuteCallback(()=>{
				// 	this._group_item.scale(0.8,0.8)
				// })
			}
			if (data && data.type_id) {
				_show_item_.SetData(data.type_id, null, null, null, null, null, null, null, data.goods_id)
				this._img_icon.visible = false
				let edata = _model.GetPetEquipData(_type_, data.goods_id)
				_show_item_.SetStrengthen(edata ? edata.pos_lv : 0)
			} else {
				this._img_icon.visible = true
				_show_item_.SetData()
				this._img_icon.skin = GameResPath.GetIcon("petEquip", `petEquip_${data.type}_${data.pos}`) //`petEquip_json.petEquip_${data.type}_${data.pos}_png`
			}
		}

		this.ClickShowItem = () => {
			let data = _cur_show_data_
			if (!data.goods_id) {
				return
			}
			UIToolTipMgr.GetInstance().AppendPetEquipTips(data.type_id, data)
		}

		//获取增加星数/阶数后的配置
		this.GetChooseData = () => {
			let pinfo = _model.GetPetEquipInfo(_type_)
			let cur_sdata = _cur_show_data_
			let cur_cdata = _cur_choose_data_
			if (!pinfo || !cur_sdata || !cur_cdata || !cur_cdata.type_id) {
				return [undefined, undefined]
			}
			let tar_star = cur_sdata.equipStar
			let tar_stage = cur_sdata.equipStage
			if (cur_cdata.subtype > local_PetEquipDefine.EQUIP_POS_COUNT) {
				let mdata = _model.GetMaxData(_type_, cur_sdata.equip_type)
				if (cur_cdata.subtype == 5) {
					let tstage = cur_cdata.goods_num + tar_stage
					tar_stage = mdata ? local_Math.min(mdata.stage, tstage) : tstage
				} else if (cur_cdata.subtype == 6) {
					let tstar = cur_cdata.goods_num + tar_star
					tar_star = mdata ? local_Math.min(mdata.star, tstar) : tstar
				}
			} else {
				tar_star = local_Math.max(cur_cdata.equipStar, cur_sdata.equipStar)
				tar_stage = local_Math.max(cur_cdata.equipStage, cur_sdata.equipStage)
			}
			let starData = _model.GetStarData(_type_, cur_sdata.equip_type, tar_star)
			let stageData = _model.GetStageData(_type_, cur_sdata.equip_type, tar_stage)
			return [starData, stageData]
		}

		this.GetEquips = () => {
			let equips = _model.GetWearEquipInfos(_type_)
			if (Util.TableSize(equips) >= local_PetEquipDefine.EQUIP_POS_COUNT) {
				return equips
			}
			let dic = { }
			for (let info of equips) {
				if (!info) {
					continue
				}
				dic[info.equip_type] = info
			}
			for (let i = 1; i <= local_PetEquipDefine.EQUIP_POS_COUNT; i++) {
				if (dic[i]) continue
				dic[i] = { type: _type_, pos: i }
			}

			return _model.DicToList(dic)
		}

		this.UpdateRedDot = () => {
			let star_red_id = _model.GetRedIDByType(_type_, 3)
			let pos = _cur_show_data_.type_id ? _cur_show_data_.equip_type : _cur_show_data_.pos
			this._reddot.visible = _model.GetRedStatus(star_red_id, pos)
		}

		this.UpdateEffect = () => {
			// this.AddUIEffect("ui_dazaochenggong_glow", this._group_eff)
		}

		this.GetEquipFirst = (list?) => {
			for (let i = 0; i < list.length; i++) {
				let info = list[i]
				if (info && info.goods_id) {
					let id = _model.GetRedIDByType(_type_, 3)
					let red = _model.GetRedStatus(id, info.equip_type)
					if (red) {
						return [i, info]
					}
				}
			}

			for (let i = 0; i < list.length; i++) {
				let info = list[i]
				if (info && info.goods_id) {
					return [i, info]
				}
			}

			return [0, list[0]]
		}

	}

	public DeleteMe() {
		if (this._list) {
			// this._list.removeEventListener(Laya.ItemTapEvent.ITEM_TAP, this.ChooseItem, this)
		}
		if (this._list_equip) {
			// this._list_equip.removeEventListener(Laya.ItemTapEvent.ITEM_TAP, this.SelectEquipItem, this)
		}

		super.DeleteMe()
	}


	public GetComponents() {
		[
			this._Image111,
			this._Image2,
			this._Image3,
			this._Image4,
			this._Image5,
			this._Image6,
			this._Image7,
			this._Group1,
			this._lb_title1,
			this._Image8,
			this._Image9,
			this._Image10,
			this._Group2,
			this._lb_title2,
			this._Image11,
			this._Image12,
			this._Image13,
			this._Group3,
			this._lb_stage_cur,
			this._lb_stage_max,
			this._group_up_stage,
			this._Image14,
			this._lb_stage_next,
			this._Group5,
			this._Group4,
			this._lb_star_cur,
			this._Image15,
			this._lb_star_max,
			this._group_up_star,
			this._Image16,
			this._lb_star_next,
			this._Image17,
			this._btn_help,
			this._lb_attr,
			this._dg_attr,
			this._btn_stren,
			this._Image1,
			this.labelDisplay,
			this._reddot,
			this._group_item,
			this._img_icon,
			this._bg_scr1,
			this._bg_scr2,
			this._list,
			this._list_equip,
			this._group_eff,
		]
			= this.GetChildrenByNames([

				"_Image111",
				"_Image2",
				"_Image3",
				"_Image4",
				"_Image5",
				"_Image6",
				"_Image7",
				"_Group1",
				"_lb_title1",
				"_Image8",
				"_Image9",
				"_Image10",
				"_Group2",
				"_lb_title2",
				"_Image11",
				"_Image12",
				"_Image13",
				"_Group3",
				"_lb_stage_cur",
				"_lb_stage_max",
				"_group_up_stage",
				"_Image14",
				"_lb_stage_next",
				"_Group5",
				"_Group4",
				"_lb_star_cur",
				"_Image15",
				"_lb_star_max",
				"_group_up_star",
				"_Image16",
				"_lb_star_next",
				"_Image17",
				"_btn_help",
				"_lb_attr",
				"_dg_attr",
				"_btn_stren",
				"_Image1",
				"labelDisplay",
				"_reddot",
				"_group_item",
				"_img_icon",
				"_bg_scr1",
				"_bg_scr2",
				"_list",
				"_list_equip",
				"_group_eff",
			])
		this._dg_attr.scrollBar.visible = false
		this._list.scrollBar.visible = false
		this._list_equip.scrollBar.visible = false
	}
}
window["PetEquipStarView"] = PetEquipStarView
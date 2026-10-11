import { BaseItem1 } from "../common/BaseItem1"
import { EquipmentItem } from "../common/EquipmentItem"
import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { GoodsModel } from "../commonModel/GoodsModel"
import { PetEquipEvent, PetEquipType, PetEquipDefine } from "../commonModel/PetEquipDefine"
import { PetEquipModel } from "../commonModel/PetEquipModel"
import { Message } from "../sysInfo/SysInfoController"
import { Enum_ColorUtil_Light } from "../util/ColorUtil"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { RefGridLayout, Util } from "../util/Util"
import { PetEquipAttrItem } from "./PetEquipAttrItem"
import { PetEquipSelectItem } from "./PetEquipSelectItem"

import "./PEHStrenShowItem"
import "./PEPStrenShowItem"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { PetEquipSelectItem_2 } from "./PetEquipSelectItem_2"

export class PetEquipStrenView extends BaseItem1 {
	_Image11: Laya.Image
	_Image2: Laya.Image
	_Image3: Laya.Image
	_Image4: Laya.Image
	_Image5: Laya.Image
	_Group1: Laya.Box
	_lb_title1: Laya.Label
	_Image6: Laya.Image
	_Image7: Laya.Image
	_Image8: Laya.Image
	_Group2: Laya.Box
	_lb_title2: Laya.Label
	_Image9: Laya.Image
	_Image10: Laya.Image
	_Image111: Laya.Image
	_btn_help: Laya.Image
	_lb_attr: Laya.Label

	_dg_attr: Laya.List
	_Group3: Laya.HBox
	_Label1: Laya.Label
	_lb_lv_cur: Laya.Label
	_lb_max: Laya.Label
	_group_up: Laya.HBox
	_Image12: Laya.Image
	_lb_lv_next: Laya.Label
	_btn_stren: Laya.Box
	_Image1: Laya.Image
	labelDisplay: Laya.Label
	_reddot: Laya.Image
	_group_item: Laya.Box
	_img_icon: Laya.Image
	_bg_scr1: Laya.Image
	_bg_scr2: Laya.Image
	item_panel: Laya.Panel
	item_con: Laya.Box
	_list: Laya.List
	_list_equip: Laya.List
	_pb: Laya.Box
	_Image13: Laya.Image
	_img_pb: Laya.Image
	_lb_pb: Laya.HTMLDivElement
	_group_eff: Laya.Box
	_cb_choose: Laya.Box
	_cb_choose_bg: Laya.Image
	_cb_choose_mark: Laya.Image
	_cb_choose_lb: Laya.Label

	attr_loop_mgr
	equip_loop_mgr
	list_loop_mgr
	item_list = []
	LoadSuccess
	InitEvent
	CustomMehod
	UpdateView
	UpdateChooseItems
	CreatGoodsItems
	UpdateEquipItems
	ClickCheckBox
	SelectEquipItem
	ChooseItem
	ClearChoose
	UpdateShowData
	UpdateShowDataByChoose
	UpdateShowItem
	ClickShowItem
	UpdateAttrData
	UpdateProgress
	UpdateAddExp
	GetChooseList
	GetChooseGoodIdList
	GetChooseData
	GetEquips
	UpdateRedDot
	UpdateEffect
	GetEquipFirst
	UpdateAttrList
	RefAttrLoopMgr
	RefEquipLoopMgr
	RefListLoopMgr
	_img_pb_width = 484
	box_data   //网格布局数据
	public constructor(parent?) {
		super(parent)

		this.base_file = "petEquip"
		this.layout_file = "PetEquipStrenView"

		let _model = PetEquipModel.GetInstance(),
			local_laya = Laya,
			local_Util = Util,
			local_Message = Message,
			local_PetEquipEvent = PetEquipEvent,
			goods_model = GoodsModel.GetInstance(),
			local_GoodsModel = GoodsModel,
			local_PetEquipType = PetEquipType,
			res_mgr = ResManager.GetInstance(),
			local_JSON = JSON,
			local_Enum_ColorUtil_Light = Enum_ColorUtil_Light,
			local_PetEquipDefine = PetEquipDefine,
			_show_item_: EquipmentItem,
			_type_: PetEquipType,
			_ac_list_,
			_ac_equip_,
			_ac_attr_,
			_choose_dic_,
			_goods_list_,
			_set_choose_ = false,
			_cur_show_data_,
			_is_max_ = false,
			last_select = 0
		this.box_data = {
			h_gap: 2,
			v_gap: 3,
			column: 7,
			item_w: 87,
			item_h: 87
		}

		this.load_callback = () => {
			this.LoadSuccess()
		}

		this.LoadSuccess = () => {
			ResManager.GetInstance().SetTexture(this, this._Image11,GameResPath.GetIcon( "petEquip", "uiwg_052a"))
			// ResManager.GetInstance().SetTexture(this, this._Image11, GameResPath.GetIcon("petEquip", "uiwg_052a"))
			// ResManager.GetInstance().SetTexture(this, this._Image2, GameResPath.GetIcon("petEquip", "uiwg_052c"))
			// ResManager.GetInstance().SetTexture(this, this._Image3, GameResPath.GetIcon("petEquip", "uiwg_053"))
			// ResManager.GetInstance().SetTexture(this, this._Image13, GameResPath.GetIcon("petEquip", "uiwg_055a"))
			// ResManager.GetInstance().SetTexture(this, this._img_pb, GameResPath.GetIcon("petEquip", "uiwg_055b"))

			// this._img_pb.mask = new Laya.Rectangle(0, 0, this._img_pb.width, this._img_pb.height)
			_choose_dic_ = {}

			// _ac_list_ = new Array
			// this._list.dataSource = _ac_list_
			// this._list.itemRender = PetEquipSelectItem
			// this._list.selectHandler=this.ChooseItem
			// this._list.addEventListener(local_eui.ItemTapEvent.ITEM_TAP, this.ChooseItem, this)

			// _ac_equip_ = new Array
			// this._list_equip.dataSource = _ac_equip_
			// this._list_equip.itemRender = _model.GetShowItemClass(_type_, 2)
			// this._list_equip.selectHandler=this.SelectEquipItem
			// this._list_equip.addEventListener(local_eui.ItemTapEvent.ITEM_TAP, this.SelectEquipItem, this)

			// _ac_attr_ = new Array
			// this._dg_attr.dataSource = _ac_attr_
			// this._dg_attr.itemRender = PetEquipAttrItem


			//let list = ! data && {} || _model.GetAllAttrList(_type_, data.goods_id, Config.config_pet_equip_pos_lv)
			let equips = this.GetEquips()

			let [index, data] = this.GetEquipFirst(equips)
			this.UpdateEquipItems(equips, index)
			// this._list_equip.selectedIndex = index
			_cur_show_data_ = data
			this.UpdateChooseItems()
			this.UpdateShowData()

			this._cb_choose_mark.visible = _set_choose_
			this.InitEvent()
			this.UpdateRedDot()
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
				if (_is_max_) {
					local_Message.show("已达到强化上限")
					return
				}
				let goods_id = _cur_show_data_.goods_id
				let cost_list = this.GetChooseGoodIdList()
				if (cost_list.length < 1) {
					local_Message.show("请选择吞噬装备")
					return
				}
				_model.Fire(local_PetEquipEvent.REQUEST_STREN, _type_, goods_id, cost_list)
			}, this, true)

			Util.AddClickEvent(this._btn_help, () => {
				GlobalEventSystem.Fire(EventName.OPEN_INSTRUCTION_VIEW, 16011)
			}, this, true)

			this.BindEvent(_model, local_PetEquipEvent.UPGRADE_SUCCESS, () => {
				this.UpdateEffect()
			})

			let func = () => {
				this.ClickCheckBox()
			}
			Util.AddClickEvent(this._cb_choose, func, this)

			this.BindEvent(goods_model, local_GoodsModel.CHANGE_HORSE_BAG_LIST, () => {
				if (_type_ != local_PetEquipType.HORSE) {
					return
				}
				this.ClearChoose()
				this.UpdateChooseItems()
				this.UpdateShowDataByChoose()
			})

			this.BindEvent(goods_model, local_GoodsModel.CHANGE_PARTNER_BAG_LIST, () => {
				if (_type_ != local_PetEquipType.PARTNER) {
					return
				}
				this.ClearChoose()
				this.UpdateChooseItems()
				this.UpdateShowDataByChoose()
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

			this.BindEvent(_model, local_PetEquipEvent.UPDATE_ITEM, (data) => {
				if (!data.goods_id) return
				if (_is_max_) {
					local_Message.show("已达到强化上限")
					return
				}
				let cdata = _choose_dic_[data.goods_id]
				let chosen = !!cdata
				if (cdata) {
					data._is_select = false
					delete _choose_dic_[data.goods_id]
				} else {
					data._is_select = true
					if (data.goods_id) {
						_choose_dic_[data.goods_id] = data
					}
				}
				for (let i = 0; i < _goods_list_.length; i++) {
					if (_goods_list_[i].goods_id) {
						if (_goods_list_[i].goods_id == data.goods_id) {
							_goods_list_[i]._is_select = !chosen
						}
					}
				}
				// this.list_loop_mgr.replaceAll(_goods_list_)
				this.CreatGoodsItems(_goods_list_)
				// let item = this.list_loop_mgr.parent._array[e] //as PetEquipSelectItem
				// item.SetSelectStatus(!chosen)
				this.UpdateShowDataByChoose()
			})
		}

		this.CustomMehod = (index?, parms?) => {
			_type_ = parms[0]
		}

		this.UpdateView = () => {
			if (_cur_show_data_) {
				let pos = _cur_show_data_.goods_id ? _cur_show_data_.equip_type : _cur_show_data_.pos
				_cur_show_data_ = _model.GetWearEquipInfo(_type_, pos) || { type: _type_, pos: pos }
			}
			this.ClearChoose()
			this.UpdateChooseItems()
			this.UpdateEquipItems()
			this.UpdateShowDataByChoose()
		}

		this.UpdateChooseItems = () => {
			_goods_list_ = _model.GetStrenGoods(_type_, _cur_show_data_, true)
			// this._list.dataSource = _goods_list_
			// if(!this.list_loop_mgr){
			// 	this.list_loop_mgr=new LoopScrowViewMgr()
			// 	this.list_loop_mgr.SetData(this._list,PetEquipSelectItem,_goods_list_,LoopScrCon.Vertical,null,this.ChooseItem)
			// }else{
			// 	this.list_loop_mgr.replaceAll(_goods_list_)
			// }	
			this.CreatGoodsItems(_goods_list_)
		}

		this.CreatGoodsItems = (_goods_list_) => {
			for (let i = 0; i < _goods_list_.length; i++) {
				if (!this.item_list[i]) {
					let item = new PetEquipSelectItem_2(this.item_con)
					item.SetData(_goods_list_[i])
					item.Load()
					this.item_list.push(item)
					item.ExcuteCallback(() => {
						RefGridLayout(this.item_con, this.box_data, false)
					})
				} else {
					this.item_list[i].SetData(_goods_list_[i])
				}
			}
		}

		this.UpdateEquipItems = (list?, index?) => {
			list = list || this.GetEquips()
			// this._list_equip.dataSource = list
			if (!this.equip_loop_mgr) {
				this.equip_loop_mgr = new LoopScrowViewMgr()
				this.equip_loop_mgr.SetData(this._list_equip, _model.GetShowItemClass(_type_, 2), list, LoopScrCon.Horizontal, null, this.SelectEquipItem, index)
			} else {
				this.equip_loop_mgr.replaceAll(list)
			}
		}

		this.UpdateAttrList = (list) => {
			if (!this.attr_loop_mgr) {
				this.attr_loop_mgr = new LoopScrowViewMgr()
				this.attr_loop_mgr.SetData(this._dg_attr, PetEquipAttrItem, list, LoopScrCon.Vertical)
			} else {
				this.attr_loop_mgr.replaceAll(list)
			}
		}

		this.ClickCheckBox = (evt?) => {
			if (_is_max_) {
				local_Message.show("已达到强化上限")
				this._cb_choose_mark.visible = _set_choose_
				return
			}
			let bool = !this._cb_choose_mark.visible
			this._cb_choose_mark.visible = bool
			_set_choose_ = bool

			if (!_set_choose_) {
				this.ClearChoose()
			} else {
				for (let info of _goods_list_) {
					if (!info) {
						break
					}
					if (info.goods_id) {
						info._is_select = _set_choose_
						_choose_dic_[info.goods_id] = info
					}
				}
			}
			// this.list_loop_mgr.replaceAll(_goods_list_)
			this.CreatGoodsItems(_goods_list_)
			this.UpdateShowDataByChoose()
		}

		this.SelectEquipItem = (e?) => {
			if (!this.equip_loop_mgr.parent._array) {
				return
			}
			if (_cur_show_data_ == this.equip_loop_mgr.parent._array[e]) {
				return
			}
			if (!this.equip_loop_mgr.parent._array[e].goods_id) {
				local_Message.show("需先穿戴装备")
				this._list_equip.selectedIndex = last_select
				return
			}
			_cur_show_data_ = this.equip_loop_mgr.parent._array[e]
			last_select = e

			this.ClearChoose()
			this.UpdateChooseItems()

			// if (this.equip_loop_mgr.parent._array[e].goods_id) {
			this.UpdateShowDataByChoose()
			// } else {
			this.UpdateShowData()
			// }
		}



		this.ClearChoose = () => {
			_choose_dic_ = {}
			this._cb_choose_mark.visible = false
			_set_choose_ = false
			if (Util.TableSize(_goods_list_) > 0) {
				for (let info of _goods_list_) {
					if (!info) {
						break
					}
					info._is_select = false
				}
			}
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
				let stageData = _model.GetStageData(_type_, edata.pos_id, edata.stage)
				let pet_equip_pos_lv_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_pet_equip_pos_lv", false)
				let lvData = _model.GetLvData(_type_, edata.pos_id, edata.pos_lv, pet_equip_pos_lv_cfg)
				let attr_list = _model.GetAllAttrList(_type_, data.goods_id, pet_equip_pos_lv_cfg)
				// this._dg_attr.dataSource = attr_list
				this.UpdateAttrList(attr_list)
				this._lb_lv_cur.text = edata.pos_lv
				_is_max_ = stageData.limit_pos_lv <= edata.pos_lv
				let exp = _is_max_ ? 0 : lvData.exp
				this.UpdateProgress(edata.pos_point, exp)
			} else {
				// this._dg_attr.dataSource.source = []
				this.UpdateAttrList([])
				this._lb_lv_cur.text = "0"
				this.UpdateProgress(0, -1)
				_is_max_ = false
			}
			// if(!this._lb_lv_next.text){
				// this._Group3.x=300
			// }
			this._group_up.visible = false
			this.UpdateAttrData()
			this.UpdateShowItem(data)
			this.UpdateRedDot()
		}

		this.UpdateShowDataByChoose = () => {
			let data = _cur_show_data_
			if (!data || !data.type_id) {
				return
			}
			this.UpdateShowData()
			if (Util.TableSize(_choose_dic_) > 0) {
				let edata = _model.GetPetEquipData(_type_, data.goods_id)
				if (!edata) {
					return
				}
				let pet_equip_pos_lv_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_pet_equip_pos_lv", false)
				let lvData = _model.GetLvData(_type_, edata.pos_id, edata.pos_lv, pet_equip_pos_lv_cfg)
				let [exp, nextLvData] = this.GetChooseData()
				let is_up = !!nextLvData && edata.pos_lv < nextLvData.pos_lv
				if (is_up) {
					let starData = _model.GetStarData(_type_, edata.pos_id, edata.star)
					let stageData = _model.GetStageData(_type_, edata.pos_id, edata.stage)
					let star_list = local_JSON.parse(starData.attr_list)
					let stage_list = local_JSON.parse(stageData.attr_list)
					let attr_list = _model.GetAttrListByMultList(local_JSON.parse(lvData.attr_list), star_list, stage_list)
					let nattr_list = _model.GetAttrListByMultList(local_JSON.parse(nextLvData.attr_list), star_list, stage_list)
					let add_list = _model.GetAddAttrList(attr_list, nattr_list)
					// this._dg_attr.dataSource.source = add_list
					this.UpdateAttrList(add_list)
					this._lb_lv_next.text = nextLvData.pos_lv
					// this._Group3.x=275
				}else{
					// this._Group3.x=300
				}
				this.UpdateAddExp(edata.pos_point, lvData.exp, exp)
				this._group_up.visible = is_up
			}
		}

		this.UpdateShowItem = (data?) => {
			if (!_show_item_) {
				_show_item_ = new EquipmentItem(this._group_item)
				_show_item_.Load()
				_show_item_.SetClickCallBack(this.ClickShowItem)
				_show_item_.SetItemSize(87,87)
				// _show_item_.ExcuteCallback(() => {
				// 	this._group_item.scale(0.8, 0.8)
				// })
			}
			if (data && data.type_id) {
				this._img_icon.visible = false
				_show_item_.SetData(data.type_id, null, null, null, null, null, null, null, data.goods_id)
				let edata = _model.GetPetEquipData(_type_, data.goods_id)
				_show_item_.SetStrengthen(edata ? edata.pos_lv : 0)
			} else {
				this._img_icon.visible = true
				_show_item_.SetData()
				this._img_icon.skin = GameResPath.GetIcon("petEquip", `petEquip_${data.type}_${data.pos}`)// `petEquip_json.petEquip_${data.type}_${data.pos}_png`
			}
		}

		this.ClickShowItem = () => {
			let data = _cur_show_data_
			if (!data.goods_id) {
				return
			}
			UIToolTipMgr.GetInstance().AppendPetEquipTips(data.type_id, data)
		}

		this.UpdateAttrData = () => {
			let data = _cur_show_data_
			if (!data.goods_id) {
				return
			}
			let pet_equip_pos_lv_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_pet_equip_pos_lv", false)
			let attr_list = _model.GetAllAttrList(_type_, data.goods_id, pet_equip_pos_lv_cfg)
			// this._dg_attr.dataSource.source = attr_list
			this.UpdateAttrList(attr_list)
		}

		this.UpdateProgress = (now?, max?) => {
			this._lb_pb.width = 200
			if (max == 0) {
				let add = local_Util.HtmlColorTxt(`(超出${now})`, local_Enum_ColorUtil_Light.GREEN)
				this._lb_pb.innerHTML = local_Util.StrToHTML(`已满级${add}`)
				this._img_pb.width = this._img_pb_width
			} else if (max < 0) {
				this._lb_pb.innerHTML = "0/0"
				this._img_pb.width = 0
			} else {
				this._img_pb.width = now / max * this._img_pb_width
				this._lb_pb.innerHTML = `${now}/${max}`
			}
			this._lb_pb.x = 484 / 2 - this._lb_pb.contextWidth / 2
		}

		this.UpdateAddExp = (now?, max?, add?) => {
			this._lb_pb.width = 200
			let add_str = ""
			if (_is_max_) {
				if (add > 0) {
					add_str = local_Util.HtmlColorTxt(`(超出${add})`, local_Enum_ColorUtil_Light.GREEN)
				}
				let str = `已满级${add_str}`
				this._lb_pb.innerHTML = Util.StrToHTML(str)
			} else {
				// if (add > 0) {
				// 	add_str = local_Util.HtmlColorTxt(`+(${add})`, local_Enum_ColorUtil_Light.GREEN)
				// }
				let str = `${now}<font color="#0a953e"> (+${add})</font>/${max}`
				this._lb_pb.innerHTML = Util.StrToHTML(str)
			}
			this._lb_pb.x = 484 / 2 - this._lb_pb.contextWidth / 2
		}

		this.GetChooseList = () => {
			let list = []
			for (let key in _choose_dic_) {
				list.push(_choose_dic_[key])
			}
			return list
		}

		this.GetChooseGoodIdList = () => {
			let list = []
			for (let key in _choose_dic_) {
				list.push(_choose_dic_[key].goods_id)
			}
			return list
		}

		//获取增加经验后的配置
		this.GetChooseData = () => {
			let pinfo = _model.GetPetEquipInfo(_type_)
			let cur_data = _cur_show_data_
			if (!pinfo || !cur_data) {
				return [0, undefined]
			}
			let list = this.GetChooseList()
			let exp = 0
			for (let info of list) {
				if (!info.type_id) {
					break
				}
				let starData = _model.GetStarData(_type_, info.equip_type, info.equipStar)
				let stageData = _model.GetStageData(_type_, info.equip_type, info.equipStage)
				exp = exp + starData.exp + stageData.exp
			}
			let edata = _model.GetPetEquipData(_type_, cur_data.goods_id)
			let tar_exp = edata ? edata.pos_point + exp : 0
			let pet_equip_pos_lv_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_pet_equip_pos_lv", false)
			let ldata = _model.GetLvDataByExp(_type_, cur_data.equip_type, tar_exp, edata, pet_equip_pos_lv_cfg)
			return [exp, ldata]
		}

		this.GetEquips = () => {
			let equips = _model.GetWearEquipInfos(_type_)
			if (Util.TableSize(equips) >= local_PetEquipDefine.EQUIP_POS_COUNT) {
				return equips
			}
			let dic = {}
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
			let stren_red_id = _model.GetRedIDByType(_type_, 2)
			let pos = _cur_show_data_.type_id ? _cur_show_data_.equip_type : _cur_show_data_.pos
			this._reddot.visible = _model.GetRedStatus(stren_red_id, pos)
		}

		this.UpdateEffect = () => {
			// this.AddUIEffect("ui_qianghuachenggong", this._group_eff)
		}

		this.GetEquipFirst = (list?) => {
			for (let i = 0; i < list.length; i++) {
				let info = list[i]
				if (info.goods_id) {
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
		for (let i = 0; i < this.item_list.length; i++) {
			if (this.item_list[i]) {
				this.item_list[i].DeleteMe()
				this.item_list[i] = null
			}
		}
		super.DeleteMe()
	}


	public GetComponents() {
		[
			this._Image11,
			this._Image2,
			this._Image3,
			this._Image4,
			this._Image5,
			this._Group1,
			this._lb_title1,
			this._Image6,
			this._Image7,
			this._Image8,
			this._Group2,
			this._lb_title2,
			this._Image9,
			this._Image10,
			this._Image111,
			this._btn_help,
			this._lb_attr,
			this._dg_attr,
			this._Group3,
			this._Label1,
			this._lb_lv_cur,
			this._lb_max,
			this._group_up,
			this._Image12,
			this._lb_lv_next,
			this._btn_stren,
			this._Image1,
			this.labelDisplay,
			this._reddot,
			this._group_item,
			this._img_icon,
			this._bg_scr1,
			this._bg_scr2,
			this.item_panel,
			this.item_con,
			this._list,
			this._list_equip,
			this._pb,
			this._Image13,
			this._img_pb,
			this._lb_pb,
			this._group_eff,
			this._cb_choose,
			this._cb_choose_bg,
			this._cb_choose_mark,
			this._cb_choose_lb,
		]
			= this.GetChildrenByNames([

				"_Image11",
				"_Image2",
				"_Image3",
				"_Image4",
				"_Image5",
				"_Group1",
				"_lb_title1",
				"_Image6",
				"_Image7",
				"_Image8",
				"_Group2",
				"_lb_title2",
				"_Image9",
				"_Image10",
				"_Image111",
				"_btn_help",
				"_lb_attr",
				"_dg_attr",
				"_Group3",
				"_Label1",
				"_lb_lv_cur",
				"_lb_max",
				"_group_up",
				"_Image12",
				"_lb_lv_next",
				"_btn_stren",
				"_Image1",
				"labelDisplay",
				"_reddot",
				"_group_item",
				"_img_icon",
				"_bg_scr1",
				"_bg_scr2",
				"item_panel",
				"item_con",
				"_list",
				"_list_equip",
				"_pb",
				"_Image13",
				"_img_pb",
				"_lb_pb",
				"_group_eff",
				"_cb_choose",
				"_cb_choose_bg",
				"_cb_choose_mark",
				"_cb_choose_lb",
			])
		this._lb_pb.style.fontSize = 18
		this._lb_pb.style.color = "#57160c"
		this._dg_attr.scrollBar.visible = false
		this._list.scrollBar.visible = false
		this._list_equip.scrollBar.visible = false
		this.item_panel.vScrollBar.visible = false
	}
}
window["PetEquipStrenView"] = PetEquipStrenView
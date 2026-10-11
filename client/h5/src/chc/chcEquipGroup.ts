import { BaseItem1 } from "../common/BaseItem1"
import { table } from "../common/table"
import { ResManager } from "../common/ResManager"
import { LoopScrowViewMgr, LoopScrCon } from "../common/LoopScrowViewMgr"
import { GoodsModel } from "../commonModel/GoodsModel"
import { chcModel } from "../commonModel/chcModel"
import { Message } from "../sysInfo/SysInfoController"
import { chcTypeBtn } from "./chcTypeBtn"
import { chcEquipItem } from "./chcEquipItem"

export class chcEquipGroup extends BaseItem1 {
	GetEquipList
	InitEvent
	LoadSuccess
	SwitchStypeData
	SwitchView
	TouchBtnHandle
	TouchEquipHandle

	_ac_btn
	_ac_equip
	_cur_idx
	_ecfg
	_equip_vo
	_list_btn
	_list_equip
	_model
	_pos
	_stype
	_type
	btn_data_list
	equip_data_list
	cfg_page
	cfg_pos
	cfg_starequip

	public constructor(parent?) {
		super(parent)
		this._pos = -1
		this._cur_idx = -1
		this.base_file = "chc"
		this.layout_file = "chcEquipGroup"
		this.preload_server_config = {
			"config_constellation_page": false,
			"config_constellation_pos": false
		}
		this.preload_client_config = {
			"ClientStarEquip": false
		}

		//this.layer_value = Enum_UILayer.UI
		this._model = chcModel.GetInstance()
		let resMgr = ResManager.GetInstance()

		this.load_callback = () => {
			//this.RegisterMask(this._list_equip)
			this.cfg_page = resMgr.GetGameConfigFromCache(this, "config_constellation_page", false)
			this.cfg_pos = resMgr.GetGameConfigFromCache(this, "config_constellation_pos", false)
			this.cfg_starequip = ResManager.GetInstance().GetGameConfigFromCache(this, "ClientStarEquip", true)
			this._Scroller1.scrollBar.visible = false
			this._Scroller2.scrollBar.visible = false
			this.InitEvent()
			this.LoadSuccess()
		}


		this.InitEvent = () => {
			this.BindEvent(this._model, chcModel.UPDATE_INFO, (type?, stype?) => {
				if (this._type != type) {
					return
				}
				if (this._stype != stype) {
					return
				}
				let list = this.GetEquipList(this._stype)
				this._ac_equip.replaceAll(list)
			}
			)
			this.BindEvent(GoodsModel.GetInstance(), GoodsModel.CHANGE_STAREQUIP, () => {
				let list = this.GetEquipList(this._stype)
				this._ac_equip.replaceAll(list)
				if (list.length > 0) {
					let index = 0
					if (this._equip_vo) {
						let i = 0
						do {
							if (this._equip_vo.goods_id == list[i].vo.goods_id) {
								index = i
								break
							}
							i = i + 1
						} while ((i < list.length))
					}
					this._equip_vo = list[index].vo
					this._ac_equip.SetSelectIndex(index)
					//this._list_equip.selectedIndex = index
					this._model.Fire(chcModel.SELECT_ITEM, this._equip_vo, this._type)
				} else {
					this._equip_vo = null
					this.SwitchView()
				}
			}
			)
		}

		this.LoadSuccess = () => {
			//this._ac_btn = eui. new ArrayCollection()
			//this._list_btn.dataProvider = this._ac_btn
			//this._list_btn.itemRenderer = chcTypeBtn
			//this._list_btn.addEventListener(Laya.ItemTapEvent.ITEM_TAP, this.TouchBtnHandle, this)
			//let list = this._model.DicToList()

			let plist = []
			let cfg = this.cfg_page
			for (let _tmpi in cfg) {
				let vo = cfg[_tmpi]
				table.insert(plist, { vo: vo, type: this._type })
			}
			table.sort(plist, (a?, b?) => {
				return a.vo.page < b.vo.page
			})
			let list = this.cfg_starequip.tabList || {}
			for(let i in list){
				let vo = list[i]
				plist[i].name = vo.name
			}
			this.btn_data_list = plist
			if (!this._ac_btn) {
				this._ac_btn = new LoopScrowViewMgr()
				this._ac_btn.SetData(this._Scroller1, chcTypeBtn, plist, LoopScrCon.Horizontal, 1, this.TouchBtnHandle)
			}

			//this._ac_equip = eui. new ArrayCollection()
			//this._list_equip.dataProvider = this._ac_equip
			//this._list_equip.itemRenderer = chcEquipItem
			//this._list_equip.addEventListener(Laya.ItemTapEvent.ITEM_TAP, this.TouchEquipHandle, this)

			//this._ecfg = resMgr.GetGameConfigFromCache(this, "config_constellation_pos", false)
			//let pcfg = resMgr.GetGameConfigFromCache(this, "config_constellation_page", false)


			//this._ac_btn.source = plist
			this.SwitchView()
		}

		this.TouchEquipHandle = (index?) => {
			let data = this.equip_data_list[index]
			if (data) {
				this._equip_vo = data.vo
				this._pos = data.vo.pos
				this._model.Fire(chcModel.SELECT_ITEM, data.vo, this._type)
			}
		}

		this.TouchBtnHandle = (index?) => {
			if (this._cur_idx == index) {
				return
			}
			let data = this.btn_data_list[index]
			this.SwitchStypeData(index, data.vo.page)
		}

		this.SwitchStypeData = (index, stype?, list?) => {
			list = list || this.GetEquipList(stype)
			if (list.length <= 0) {
				Message.show("穿戴圣衣后，才能操作")
				this._ac_btn.SetSelectIndex(this._cur_idx)
				//this._list_btn.selectedIndex = this._cur_idx
			} else {
				this._pos = 0
				this.equip_data_list = list
				if (!this._ac_equip) {
					this._ac_equip = new LoopScrowViewMgr()
					this._ac_equip.SetData(this._Scroller2, chcEquipItem, list, LoopScrCon.Horizontal, 1, this.TouchEquipHandle)
				} else {
					this._ac_equip.replaceAll(list)
				}
				this._stype = stype
				this._model.Fire(chcModel.SELECT_TYPE, stype, this._type)
				this._model.Fire(chcModel.SELECT_ITEM, list[0].vo, this._type)
				this._ac_equip.SetSelectIndex(0)
				this._cur_idx = index
			}
		}

		this.SwitchView = () => {
			let stype = this._model.CheckEquipReStype(this.cfg_pos, this._type)
			if (stype) {
				this._ac_btn.SetSelectIndex(stype - 1)
				this.SwitchStypeData(stype - 1, stype)
			}
		}

		this.GetEquipList = (stype?) => {
			return this._model.GetEquipList(this.cfg_pos, this._type, stype)
		}
	}

	public DeleteMe() {
		//if (this._list_equip ) {
		//this._list_equip.removeEventListener(Laya.ItemTapEvent.ITEM_TAP, this.TouchEquipHandle, this)
		//}
		//if (this._list_btn ) {
		//this._list_btn.removeEventListener(Laya.ItemTapEvent.ITEM_TAP, this.TouchBtnHandle, this)
		//}
		if (this._ac_equip) {
			this._ac_equip.DeleteMe()
			this._ac_equip = null
		}
		if (this._ac_btn) {
			this._ac_btn.DeleteMe()
			this._ac_btn = null
		}
		super.DeleteMe()
	}

	public SetType(type?) {
		this._type = type
	}

	_Scroller1: Laya.List
	_Scroller2: Laya.List
	public GetComponents() {
		[
			this._Scroller1,
			this._Scroller2,
		]
			= this.GetChildrenByNames([
				"_Scroller1",
				"_Scroller2",
			])
	}
}
window["chcEquipGroup"] = chcEquipGroup
import { BaseView1 } from "../common/BaseView1"
import { table } from "../common/table"
import { Enum_UILayer } from "../common/LayerManager"
import { EquipEvent } from "../commonModel/EquipModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { LoopScrowViewMgr, LoopScrCon } from "../common/LoopScrowViewMgr"
import { StarEquipModel } from "../commonModel/StarEquipModel"
import { StarChangeEquipItem } from "./StarChangeEquipItem"

export class StarChangeEquipView extends BaseView1 {
	Local_Open
	UpdateItem
	_list
	data

	public constructor() {
		super()
		this.base_file = "starEquip"
		this.layout_file = "StarChangeEquipView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.is_center = true
		this.use_background = true
		this.click_bg_toClose = true

		//let _model = StarEquipModel.GetInstance()
		//let local_EquipEvent = EquipEvent
		let goods_model = GoodsModel.GetInstance()
		let _ac_list_ = null

		this.load_callback = () => {
			//this.RegisterMask(this._list)
			this.UpdateItem()
		}

		this.Local_Open = (...new_args) => {
			this.data = new_args[0]
			super.Open()
		}

		this.close_callback = () => {
			if (_ac_list_) {
				_ac_list_.DeleteMe()
				_ac_list_ = null
			}
		}

		this.UpdateItem = () => {
			let list = []
			let needPage = this.data.page
			let needPos = this.data.subtype
			let bagList = goods_model.starEquipBagList
			for (let _tmpi in bagList) {
				let vo = bagList[_tmpi]
				if (vo.page == needPage && vo.subtype == needPos) {
					table.insert(list, vo)
				}
			}
			if (!_ac_list_) {
				_ac_list_ = new LoopScrowViewMgr()
				_ac_list_.SetData(this._Scroller1, StarChangeEquipItem, list, LoopScrCon.Vertical)
			} else {
				_ac_list_.replaceAll(list)
			}
			this.noLb.visible = list.length == 0
			this.noImg.visible = list.length == 0
		}
	}

	public Open(...new_args) {
		this.Local_Open(...new_args)
	}

	_Image1: Laya.Image
	_Image2: Laya.Image
	_Label1: Laya.Label
	_Image3: Laya.Image
	_Scroller1: Laya.List
	noLb: Laya.Label
	noImg: Laya.Image
	public GetComponents() {
		[
			this._Image1,
			this._Image2,
			this._Label1,
			this._Image3,
			this._Scroller1,
			this.noLb,
			this.noImg,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_Image2",
				"_Label1",
				"_Image3",
				"_Scroller1",
				"noLb",
				"noImg",
			])
	}
}
window["StarChangeEquipView"] = StarChangeEquipView
import { BaseItem1 } from "../common/BaseItem1"
import { Util } from "../util/Util"
import { GoodsModel } from "../commonModel/GoodsModel"
import { ColorUtil } from "../util/ColorUtil"
import { ColorType } from "../util/ColorUtil"
import { EquipmentItem } from "../common/EquipmentItem"
import { MaterialsTool } from "../common/MaterialsTool"

export class GodEquipBMaterialsItem extends BaseItem1 {
	DeleteMe
	InitEvent
	LoadSuccess
	initItem
	setData

	public constructor(parent?) {
		super(parent)
		this.base_file = "godequipbuild"
		this.layout_file = "GodEquipBMaterialsItem"

		let local_gModel = GoodsModel.GetInstance()
		let local_color = ColorUtil
		let goods_item_ = null
		let _data_ = null

		this.load_callback = () => {
			this.InitEvent()
			this.LoadSuccess()
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._mask, () => {
				if (!this._mask.visible) {
					return
				}
				MaterialsTool.GetInstance().materialsTips(_data_[1])
			}, this)
		}

		this.DeleteMe = () => {
			if (goods_item_) {
				goods_item_.DeleteMe()
				goods_item_ = null
			}
			
			super.DeleteMe()
		}

		this.setData = (data?) => {
			_data_ = data
			if (this.is_loaded) {
				this.initItem()
			}
		}

		this.LoadSuccess = () => {
			//SetLocalScale(this.form, 0.75, 0.75, 1)
			this.initItem()
		}

		this.initItem = () => {
			if (!this.is_loaded) {
				return
			}
			if (!goods_item_) {
				goods_item_ = new EquipmentItem(this.item_group)
				goods_item_.Load()
				goods_item_.SetItemSize(85, 85)
			}
			if (goods_item_) {
				goods_item_.SetVisible(!(!_data_))
			}
			this.icon_bg.visible = !_data_
			this.lock_img.visible = !_data_
			this.num_label.text = ''
			this._mask.visible = false
			if (!_data_) {
				return
			}
			let [type_id, lock] = local_gModel.GetMappingTypeId(_data_[0], _data_[1])
			let goods_vo = local_gModel.GetGoodsBasicByTypeId(Number(type_id))
			let num = local_gModel.GetTypeGoodsNum(goods_vo.type_id)
			let needNum = Number(_data_[2])
			this.num_label.text = num + "/" + needNum
			this.num_label.color = local_color.TryParseHtmlString(num >= needNum && local_color.GetColorLight(ColorType.GREEN, false) || local_color.GetColorLight(ColorType.RED, false))
			if (goods_vo) {
				goods_item_.SetData(goods_vo.type_id)
			}
			this._mask.visible = num < needNum
			//goods_item_.touchEnabled = ! this._mask.visible
			//goods_item_.touchChildren = ! this._mask.visible
		}
	}

	icon_bg: Laya.Image
	item_group: Laya.Box
	lock_img: Laya.Image
	add_img: Laya.Image
	num_label: Laya.Label
	_mask: Laya.Box
	public GetComponents() {
		[
			this.icon_bg,
			this.item_group,
			this.lock_img,
			this.add_img,
			this.num_label,
			this._mask,
		]
			= this.GetChildrenByNames([

				"icon_bg",
				"item_group",
				"lock_img",
				"add_img",
				"num_label",
				"_mask",
			])
	}
}
window["GodEquipBMaterialsItem"] = GodEquipBMaterialsItem
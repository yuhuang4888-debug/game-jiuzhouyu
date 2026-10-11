import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { EquipmentItem } from "../common/EquipmentItem"
import { ResManager } from "../common/ResManager"
import { EquipModel } from "../commonModel/EquipModel"

export class MarketPlzGoodsItem extends BaseItemRenderer {
	_Image1: Laya.Image
	_group_item: Laya.Box
	_Image2: Laya.Image
	_lb_name: Laya.Label
	_lb_stage: Laya.Label
	_img_select: Laya.Image

	item
	public static width = 300
	public static height = 100
	WIDTH = 300
    HEIGT = 100
	public constructor(parent) {
		super()

		this.base_file = "market"
		this.layout_file = "MarketPlzGoodsItem"

		
		this.load_callback = () => {
			this.item = new EquipmentItem(this._group_item)
			this.item.ExcuteCallback(() => {
				this.item.SetItemSize(85 ,85)
			})
			//this.item.SetItemSize(85 ,85)
			//this.item.SetMaskId(this.mask_id || 1)
			this.item.Load()
		}
		this.Load()
		// this.load_callback = () => {

		// 	if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
		// 		this._lb_name.size  = 18
		// 	}
		// 	if (PlatformMgr.GetInstance().IsEyouIdnPlatform() ) {
		// 		this._lb_name.size  = 18
		// 	}

		// 	//this.item.addEventListener(eui.ItemTapEvent.ITEM_TAP, this.ClickItem, this)
		// }

	}
	public createChildren() {
		super.createChildren()
		
	}
	//function MarketPlzGoodsItem.ClickItem(e)
	//e:stopImmediatePropagation()
	//}

	public dataChanged() {
		if (super.dataChanged()) {
			if (this.data == null) { return }
			let data = this.data
			this._lb_name.text = data.goods_name
			let equip_attr_cfg = ResManager.GetInstance().GetGameConfigFromCache(this.base_item, "config_equip_attr", false)
			// [ts2lua]lua中0和空字符串也是true，此处data.type == 10需要确认
			// if (PlatformMgr.GetInstance().IsEyouIdnPlatform() ) {
			// 	this._lb_stage.text = data.type == 10 && "Grade " + EquipModel.GetInstance().GetStageByTypeId(data.type_id, equip_attr_cfg) || ""
			// }else{
			this._lb_stage.text = data.type == 10 && EquipModel.GetInstance().GetStageByTypeId(data.type_id, equip_attr_cfg) + "阶" || ""
			//}

			this.item.SetData(data.type_id)
			if (this.selected) {
				this._img_select.visible = true
			} else {
				this._img_select.visible = false
			}
		}
	}

	public DeleteMe() {

		if (this.item) {
			this.item.DeleteMe()
			this.item = null
		}
		super.DeleteMe()
	}



	public GetComponents() {
		[
			this._Image1,
			this._group_item,
			this._Image2,
			this._lb_name,
			this._lb_stage,
			this._img_select,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_group_item",
				"_Image2",
				"_lb_name",
				"_lb_stage",
				"_img_select",
			])
	}
}

window["MarketPlzGoodsItem"] = MarketPlzGoodsItem
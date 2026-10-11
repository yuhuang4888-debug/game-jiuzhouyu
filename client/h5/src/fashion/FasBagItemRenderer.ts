import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { FashionModel } from "../commonModel/FashionModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"

export class FasBagItemRenderer extends BaseItemRenderer {
	_Group2: Laya.Box
	item_image: Laya.Image
	_Group1: Laya.Box
	fashion_image: Laya.Image
	num_label: Laya.Label
	select_image: Laya.Image
	public static width = 127 + 6
	public static height = 127
	public constructor(parent) {
		super()

		
		this.base_file = "fashion"
		this.layout_file = "FasBagItemRenderer"
		// this.load_callback = () => {

		// }
		// this.skinName = "resource/game/fashion/exml/FasBagItemRendererExml.exml"
		this.Load()

	}

	public load_callback() {
		this.display_obj.scale(0.8,0.8)
		Util.AddClickEvent(this._Group2, () => {
			FashionModel.GetInstance().Fire(FashionModel.SELECTADD, this)
		}, this, false)
	}
	public dataChanged() {
		if(super.dataChanged()){
			let goodinfo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(this.data[0])
			if (goodinfo) {
				ResManager.GetInstance().SetImageSprite(this, this.item_image, "common_asset", "com_goods_plate_" + goodinfo.color)
				//let url = "client/assets/goodsicon/" + this.data[0] + ".png"
				ResManager.GetInstance().SetOutsideImageSprite(this, this.fashion_image, GameResPath.GetGoodsIconPath(goodinfo.goods_icon))
				this.fashion_image.visible = true
				this.num_label.text = this.data[1]
				this.num_label.visible = true
				this.RefStatus()
			} else {
				ResManager.GetInstance().SetImageSprite(this, this.item_image, "common_asset", "com_goods_plate_0")
				this.fashion_image.visible = false
				this.num_label.visible = false
				this.select_image.visible = false
			}
		}
	}

	public RefStatus() {

		if (this.data[3] == 1) {
			this.select_image.visible = true
		} else {
			this.select_image.visible = false
		}
	}

	public GetComponents() {
		[
			this._Group2,
			this.item_image,
			this._Group1,
			this.fashion_image,
			this.num_label,
			this.select_image,
		]
			= this.GetChildrenByNames([

				"_Group2",
				"item_image",
				"_Group1",
				"fashion_image",
				"num_label",
				"select_image",
			])
	}
}
window["FasBagItemRenderer"] = FasBagItemRenderer
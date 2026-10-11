import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { FashionModel } from "../commonModel/FashionModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { PlatformManager } from "../PlatformManager"
import { GameResPath } from "../util/GameResPath"
import { SetHtmlCenter, Util } from "../util/Util"

export class FashionItem extends BaseItemRenderer {
	
	cache_bool

	WIDTH = 140
	HEIGT = 148

	public constructor() {
		super()
		this.base_file = "fashion"
		this.layout_file = "FashionItem"
		this.Load()
	}

	public load_callback() {
		this.fashion_name_label.style.fontSize = 22
		this.fashion_name_label.style.wordWrap = false
	}

	public dataChanged() {
		if (super.dataChanged()) {
			this.select.visible = this.selected

			let fashion_id = this.data.fashion_id
			let pos_id = this.data.pos_id
			this.fashion_name_label.width=200
			let goodinfo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(fashion_id)
			if (!goodinfo) { return }
			if (goodinfo) {
				this.fashion_name_label.innerHTML = GoodsModel.GetGoodsNameWithColorDark(fashion_id)
				SetHtmlCenter(this.fashion_name_label,{x:-35,w:200})
	if (PlatformManager.IsEyouPlatform()) {
				this.fashion_name_label.style.align="center"
				this.fashion_name_label.style.wordWrap = true
				this.fashion_name_label.style.leading = 0.1
				this.fashion_name_label.style.width = 136

				this.Image.centerY = NaN
				this.Image.height = this.fashion_name_label.contextHeight + 10
			}
			}

			ResManager.GetInstance().SetImageSprite(this, this.fashion_plate_image, "common_asset", "com_goods_plate_" + goodinfo.color)
			ResManager.GetInstance().SetOutsideImageSprite(this, this.fashion_icon_image, GameResPath.GetGoodsIconPath(goodinfo.goods_icon))
			this.fashion_name_label.style.color = ColorUtil.GetColorLight(goodinfo.color, false)

			let info = FashionModel.GetInstance().fashion_info_dic[pos_id]
			if (!info) { return }
			let id = info.wear_fashion_id
			let id1 = fashion_id
			if (info && id == id1) {
				this.fashion_waer_image.visible = true
			} else {
				this.fashion_waer_image.visible = false
			}
			let bool = FashionModel.GetInstance().IsRed(pos_id, fashion_id)
			this.fashion_red_image.visible = bool

			let active_dic = FashionModel.GetInstance().fashion_active_dic[pos_id]
			if (active_dic && active_dic[fashion_id]) {
				if (this.cache_bool != false) {
					this.cache_bool = false
					Util.SetImageGray(this.fashion_icon_image, false)
					Util.SetImageGray(this.fashion_plate_image, false)
				}
			} else {
				if (this.cache_bool != true) {
					this.cache_bool = true
					Util.SetImageGray(this.fashion_icon_image, true)
					Util.SetImageGray(this.fashion_plate_image, true)
				}
			}
			this.SetHtmlCenterX(this.fashion_name_label, this.name_box.width)
		}
	}

	public SetHtmlCenterX(html_obj?, w?) {
		if (!html_obj) {
			return
		}
		html_obj.x = w / 2 - html_obj.contextWidth / 2
	}


	fashion_group: Laya.Box
	fashion_icon_group: Laya.Box
	fashion_plate_image: Laya.Image
	_Group1: Laya.Box
	fashion_icon_image: Laya.Image
	select: Laya.Image
	fashion_red_image: Laya.Image
	fashion_waer_image: Laya.Image
	Image: Laya.Image
	name_box: Laya.Box
	fashion_name_label: Laya.HTMLDivElement
	public GetComponents() {
		[
			this.fashion_group,
			this.fashion_icon_group,
			this.fashion_plate_image,
			this._Group1,
			this.fashion_icon_image,
			this.select,
			this.fashion_red_image,
			this.fashion_waer_image,
			this.Image,
			this.fashion_name_label,
			this.name_box
		]
			= this.GetChildrenByNames([

				"fashion_group",
				"fashion_icon_group",
				"fashion_plate_image",
				"_Group1",
				"fashion_icon_image",
				"select",
				"fashion_red_image",
				"fashion_waer_image",
				"Image",
				"fashion_name_label",
				"name_box"
			])
	}
}
window["FashionItem"] = FashionItem
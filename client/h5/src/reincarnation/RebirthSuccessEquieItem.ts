
////////////////////////////////////////////////////////////////////-
// u3d (C) CompanyName, All Rights Reserved
// Created by: WangXiang
// Date: 2020-04-24 09.40:18
////////////////////////////////////////////////////////////////////-

import { BaseItem1 } from "../common/BaseItem1"
import { EquipmentItem } from "../common/EquipmentItem"
import { Enum_UILayer } from "../common/LayerManager"
import { SetLocalScale, SetSizeDelta } from "../util/Util"


export class RebirthSuccessEquieItem extends BaseItem1 {
	scale_cache
	goods_id
	item
	need_refresh

	public constructor(parent?) {
		super(parent)
		this.base_file = "reincarnation"
		this.layout_file = "RebirthSuccessEquieItem"
		this.layer_value = Enum_UILayer.Activity
		this.load_callback = () => {
			if (this.need_refresh) {
				this.SetData(this.goods_id)
			}
			if (this.scale_cache) {
				this.SetScale(this.scale_cache)
			}
		}
	}

	public SetData(goods_id?) {
		this.goods_id = Number(goods_id)
		if (this.is_loaded) {
			if (!this.item) {
				this.item = new EquipmentItem(this.item_gp, null, "Activity")
				this.item.SetUseMask(true)
				this.item.Load()
				this.item.SetScale(0.57)
			}
			this.item.SetData(goods_id)
		} else {
			this.need_refresh = true
		}
	}

	public SetScale(scale?) {
		if (this.is_loaded) {
			let scale_width = this.display_obj.width * scale
			let scale_height = this.display_obj.height * scale
			SetLocalScale(this.display_obj, scale)
			SetSizeDelta(this.display_obj, scale_width, scale_height)
			this.scale_cache = null
		} else {
			this.scale_cache = scale
		}
	}


	public DeleteMe() {

		if (this.item) {
			this.item.DeleteMe()
			this.item = null
		}
		super.DeleteMe()
	}

	_Image1: Laya.Image
	item_gp: Laya.Box
	public GetComponents() {
		[
			this._Image1,
			this.item_gp,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"item_gp",
			])
	}
}
window["RebirthSuccessEquieItem"] = RebirthSuccessEquieItem
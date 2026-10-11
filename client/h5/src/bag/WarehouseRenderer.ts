
////////////////////////////////////////////////////////////////////-
// u3d (C) CompanyName, All Rights Reserved
// Created by: WangXiang
// Date: 2020-03-24 15.30:35
////////////////////////////////////////////////////////////////////-

import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { BagModel } from "../commonModel/BagModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { GlobalTimerQuest } from "../util/Util"
import { BagItemRenderer } from "./BagItemRenderer"

// To edit this template in: Data/Config/Template.lua
// To disable this template, check off menuitem: Options-Enable Template File

//-@class WarehouseRenderer
export class WarehouseRenderer extends BagItemRenderer {
	WIDTH = 97
	HEIGT = 97

	ClickCallBack
	clickTimer
	is_batch

	public constructor() {
		super()

		this.is_batch = true
		this.ClickCallBack = () => {
			let bagModel = BagModel.GetInstance()
			if (this.data) {
				if (this.data.color == -1) {
					bagModel.Fire(BagModel.OPEN_VIEW, "ExpandBagView", GoodsModel.GOODS_POS_TYPE.warehouse, this.data.index)
				} else if (this.data.color) {
					if (!this.clickTimer) {
						//this.clickTimer = setTimeout(() => {
						//this:ClickFunc()
						//this.clickTimer = null
						//}
						//, this, 300)
						this.clickTimer = GlobalTimerQuest.AddDelayQuest(() => {
							this.ClickFunc()
							this.clickTimer = null
						}, 0.3)
					} else {
						if (this.clickTimer) {
							GlobalTimerQuest.CancelQuest(this.clickTimer) //Laya:clearTimeout(this.clickTimer)
							this.clickTimer = null
						}
						if (this.data) {
							GoodsModel.GetInstance().Fire(GoodsModel.MOVE_GOODS_POS, this.data.goods_id, GoodsModel.GOODS_POS_TYPE.warehouse, GoodsModel.GOODS_POS_TYPE.bag)
						}
					}
				}
			}
		}
	}

	public ClickFunc() {
		if (this.data && this.data.type_id) {
			let goods_basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(this.data.type_id)
			if (goods_basic) {
				if (goods_basic.type == 10) {
					UIToolTipMgr.GetInstance().AppendEquipTips(goods_basic.type_id, null, null, this.data, null, [12])
				} else {
					this.data.takeout = true
					UIToolTipMgr.GetInstance().AppendGoodsTips(goods_basic.type_id, null, null, this.data)
				}
			}
		}
	}
}
window["WarehouseRenderer"] = WarehouseRenderer

////////////////////////////////////////////////////////////////////-
// u3d (C) CompanyName, All Rights Reserved
// Created by: WangXiang
// Date: 2020-03-24 15.32:15
////////////////////////////////////////////////////////////////////-

import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { BagModel } from "../commonModel/BagModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { GlobalTimerQuest } from "../util/Util"
import { BagItemRenderer } from "./BagItemRenderer"
import { MonsterModel, MonsterModelEvent } from './../commonModel/MonsterModel';

// To edit this template in: Data/Config/Template.lua
// To disable this template, check off menuitem: Options-Enable Template File

//-@class WarehouseBagRenderer
export class WarehouseBagRenderer extends BagItemRenderer {
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
					bagModel.Fire(BagModel.OPEN_VIEW, "ExpandBagView", GoodsModel.GOODS_POS_TYPE.bag, this.data.index)
				} else if (this.data.color) {
					if (!this.clickTimer) {
						this.clickTimer = GlobalTimerQuest.AddDelayQuest(() => {
							this.ClickFunc()
							this.clickTimer = null
						}, 0.3)
						//Laya:setTimeout(
						//, this, 300)
					} else {
						if (this.clickTimer) {
							GlobalTimerQuest.CancelQuest(this.clickTimer) //Laya:clearTimeout(this.clickTimer)
							this.clickTimer = null
						}
						if (this.data) {
							GoodsModel.GetInstance().Fire(GoodsModel.MOVE_GOODS_POS, this.data.goods_id, GoodsModel.GOODS_POS_TYPE.bag, GoodsModel.GOODS_POS_TYPE.warehouse)
							// MonsterModel.GetInstance().Fire(MonsterModelEvent.UPDATE_RED_DOT);
						}
					}
				}
			}
		}
	}

	public async ClickFunc (){
		if (this.data && this.data.type_id) {
			let goods_basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(this.data.type_id)
			if (goods_basic) {
				if (goods_basic.type == 10) {
					UIToolTipMgr.GetInstance().AppendEquipTips(goods_basic.type_id, null, null, this.data, null, [11])
				} else {
					this.data.deposite = true
					UIToolTipMgr.GetInstance().AppendGoodsTips(goods_basic.type_id, null, null, this.data)
				}
			}
		}
	}
}

window["WarehouseBagRenderer"] = WarehouseBagRenderer
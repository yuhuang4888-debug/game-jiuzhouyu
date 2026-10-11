
////////////////////////////////////////////////////////////////////-
// u3d (C) CompanyName, All Rights Reserved
// Created by: WangXiang
// Date: 2020-04-22 16.54:21
////////////////////////////////////////////////////////////////////-

import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { EquipmentItem } from "../common/EquipmentItem"
import { ResManager } from "../common/ResManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { SnatchTreasureModel } from "../commonModel/SnatchTreasureModel"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"

// To edit this template in: Data/Config/Template.lua
// To disable this template, check off menuitem: Options-Enable Template File

//-@class SnatchTreasureRankItem
export class SnatchTreasureRankItem extends BaseItemRenderer {
	_Image1: Laya.Image
	_lb_rank: Laya.Label
	_Scroller1: Laya.Panel
	Content: Laya.HBox
	_Image2: Laya.Image
	_gp_reward
	_model
	cor_cache
	reward_item_list

	public static width = 405
	public static height = 108
	WIDTH = 578
	HEIGT = 120
	public constructor(parent) {
		super()


		this.reward_item_list = [];
		this.base_file = "snatchTreasure"
		this.layout_file = "SnatchTreasureRankItem"
		//this.layer_value = Enum_UILayer.Activity
		this._model = SnatchTreasureModel.GetInstance()
		this.load_callback = () => {
			this._Scroller1.hScrollBar.visible = false
			// this.RegisterMask(this._gp_reward)
			// this.cor_cache = GetWorldCorners(this.parent_wnd.GetComponentInParent(typeof(UnityEngine.UI.ScrollRect)).transform.Find("_rank_list"))
			ResManager.GetInstance().SetOutsideImageSprite(this, this._Image2, GameResPath.GetIcon("snatchTreasure", "ui_activity_02"))
		}
		this.Load()
	}


	public DeleteMe() {

		for (let key in this.reward_item_list) {

			// [ts2lua]this.reward_item_list下标访问可能不正确
			let item = this.reward_item_list[key]
			item.DeleteMe()
		}
		this.reward_item_list = []
		super.DeleteMe()
	}

	public dataChanged() {
		if (super.dataChanged()) {
			if (!this.data) {
				return
			}
			if (this.data.max_rank == this.data.min_rank) {
				this._lb_rank.text = "第" + this.data.max_rank + "名"
			} else {
				this._lb_rank.text = "第" + this.data.max_rank + (" - ") + this.data.min_rank + "名"
			}
			let reward_list = JSON.parse(this.data.reward)
			let index = 0
			let item: EquipmentItem = null
			for (let key in reward_list) {

				// [ts2lua]reward_list下标访问可能不正确
				let vo = reward_list[key]
				// [ts2lua]this.reward_item_list下标访问可能不正确
				item = this.reward_item_list[index]
				if (!item) {
					item = new EquipmentItem(this.Content)
					this.reward_item_list[index] = item
					//table.insert(this.reward_item_list, item)
					//item.SetScale(0.6)
					// item.SetUseMask(true)
					// item.SetMaskRect(this.cor_cache)

					//item.ExcuteCallback(() => {
					item.SetItemSize(85, 85)
					item.Load()
					//})
				}

				item.SetVisible(true)
				let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(vo[0], vo[1])
				let goods_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
				if (goods_vo) {
					// [ts2lua]lua中0和空字符串也是true，此处vo[2] == 1需要确认
					let num = (Number(vo[2]) == 1 && (null) || (vo[2]))
					item.SetData(goods_vo.type_id, num, lock)
					item.SetStrengthen(goods_vo.stren)
				}
				index = index + 1
			}
			if (this.reward_item_list.length > index) {
				let i = index
				do {
					item = this.reward_item_list[i]
					item.SetVisible(false)
					i = i + 1
				} while ((i < this.reward_item_list.length)
				)
			}
		}

	}

	public GetComponents() {
		[
			this._Image1,
			this._lb_rank,
			this._Scroller1,
			this.Content,
			this._Image2,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_lb_rank",
				"_Scroller1",
				"Content",
				"_Image2",
			])
	}
}
window["SnatchTreasureRankItem"] = SnatchTreasureRankItem
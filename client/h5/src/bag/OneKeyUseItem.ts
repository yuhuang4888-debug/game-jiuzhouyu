
////////////////////////////////////////////////////////////////////-
// u3d (C) CompanyName, All Rights Reserved
// Created by: WangXiang
// Date: 2020-03-25 10.53:15
////////////////////////////////////////////////////////////////////-

import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { BagModel } from "../commonModel/BagModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"

// To edit this template in: Data/Config/Template.lua
// To disable this template, check off menuitem: Options-Enable Template File

//-@class OneKeyUseItem
export class OneKeyUseItem extends BaseItemRenderer {
	WIDTH = 96
	HEIGT = 96

	public conta: Laya.Box;
	public defaultImg: Laya.Image;
	public up: Laya.Image;
	public down: Laya.Image;
	public ban: Laya.Image;
	public grade: Laya.Label;
	public star_group: Laya.Box;
	public star_1: Laya.Image;
	public star_2: Laya.Image;
	public star_3: Laya.Image;
	public star_4: Laya.Image;
	public time_limit: Laya.Image;
	public lock: Laya.Image;
	public redMask: Laya.Image;
	public _bad_icon: Laya.Image;
	public group_eff: Laya.Box;

	item
	SetSelect
	model
	ClickFunc
	// public static width = 96
	// public static height = 96

	public constructor() {
		super()

		this.base_file = "bag"
		this.layout_file = "bagItemRenderer"

		this.model = BagModel.GetInstance()


		this.SetSelect = () => {
			if (this.data) {
				if (this.model.use_select_dic[this.data.goods_id]) {
					this.item.SetSelect(true)
				} else {
					this.item.SetSelect(false)
				}
			}
		}

		this.ClickFunc = () => {
			if (this.data) {
				if (!this.model.use_select_dic[this.data.goods_id]) {
					this.model.use_select_dic[this.data.goods_id] = true
					this.item.SetSelect(true)
				} else {
					delete this.model.use_select_dic[this.data.goods_id]
					this.item.SetSelect(false)
				}
			}
		}

		this.Load()

	}

	public load_callback() {
		this.item = new BaseAwardItem(this.conta)
		this.item.Load()
		this.item.SetScale(0.72)
		this.item.SetClickCallBack(this.ClickFunc)


		this.InitEvent()
	}

	public dataChanged() {
		if (super.dataChanged()) {
			if (this.data) {
				let select = this.model.use_select_dic[this.data.goods_id]
				this.item.SetData(this.data.type_id, this.data.goods_num, null, select)
				this.SetSelect()
			}
		}

	}

	public InitEvent() {

		this.item.ExcuteCallback(() => {
			ResManager.GetInstance().SetImageSprite(this, this.item.select_image, "bag_asset", "select")
			//this.item.select_image.source = "bag_json.select_png"
		}
		)
		this.BindEvent(this.model, BagModel.ONE_KEY_TAB, (bool?, type?, sub_type?) => {
			this.SetSelect()
		}
		)

		this.BindEvent(GlobalEventSystem, GoodsModel.USE_BAG_GOODS_SUCCESS, (goods_type_id?) => {
			if(!this.data)return
			if(goods_type_id==35||goods_type_id==34){
				let point = this.conta.localToGlobal(new Laya.Point(0,0),true)
				let list = [{ "0": 0, "1": this.data.type_id, "2": this.data.goods_num }]
				GlobalEventSystem.Fire(EventName.REWARD_FLY, list, point, null, null, 0, 0)
			}
		
		})

		
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
			this.conta,
			this.defaultImg,
			this.up,
			this.down,
			this.ban,
			this.grade,
			this.star_group,
			this.star_1,
			this.star_2,
			this.star_3,
			this.star_4,
			this.time_limit,
			this.lock,
			this.redMask,
			this._bad_icon,
			this.group_eff
		] = this.GetChildrenByNames([
			"conta",
			"defaultImg",
			"up",
			"down",
			"ban",
			"grade",
			"star_group",
			"star_1",
			"star_2",
			"star_3",
			"star_4",
			"time_limit",
			"lock",
			"redMask",
			"_bad_icon",
			"group_eff"
		])
	}
}
window["OneKeyUseItem"] = OneKeyUseItem
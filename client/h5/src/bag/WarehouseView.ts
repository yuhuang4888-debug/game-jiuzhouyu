import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItem1 } from "../common/BaseItem1"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { OpenFun } from "../common/OpenFun"
import { ResManager } from "../common/ResManager"
import { BagModel } from "../commonModel/BagModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { SuitModel, SuitModelEvent } from "../commonModel/SuitModel"
import { PlatformManager } from "../PlatformManager"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
import { WarehouseBagRenderer } from "./WarehouseBagRenderer"
import { WarehouseRenderer } from "./WarehouseRenderer"

export class WarehouseView extends BaseItem1 {
	_Image1: Laya.Image
	_Image2: Laya.Image
	_Scroller1: Laya.List
	_Scroller2: Laya.List
	_Image3: Laya.Image
	_Image4: Laya.Image
	expandBtn1: Laya.Image
	expandBtn2: Laya.Image
	smeltBtn: Laya.Image
	useBtn: Laya.Image
	redequipBtn: Laya.Image
	suitRed: Laya.Image
	_Image5: Laya.Image
	_Label1: Laya.Label

	goods_con
	model
	bag_loop_mgr
	ware_loop_mgr
	ware_con
	InitEvent
	goods_scroll
	InitView
	ware_scroll
	goodsModel
	public constructor(parent?) {
		super(parent)

		this.base_file = "bag"
		this.layout_file = "WarehouseView"
		this.layer_value = "UI"
		let local_BagModel = BagModel
		let local_Util = Util
		let local_GoodsModel = GoodsModel
		this.model = BagModel.GetInstance();
		this.goodsModel = GoodsModel.GetInstance();
		this.load_callback = () => {
			this.goods_scroll = this._Scroller2
			this.ware_scroll = this._Scroller1

			ResManager.GetInstance().SetOutsideImageSprite(this, this._Image5, GameResPath.GetIcon("bag", "xx_titleBg_01"), true)
			this.suitRed.visible = SuitModel.GetInstance().GetSuitTotlaRed();
			this.InitView()
			this.InitEvent()
		}

		this.InitView = () => {
			if(PlatformManager.IsEyouThPlatform()){
				this.smeltBtn.anchorX = 0.5
				this.smeltBtn.x = 662
				this.redequipBtn.anchorX = 0.5
				this.redequipBtn.x = 662
				this.useBtn.anchorX = 0.5
				this.useBtn.x = 662
				this.expandBtn2.anchorX = 0.5
				this.expandBtn2.x = 662
			}
			// BaseAwardItem.StartBatchLoad()
			this.model.CreateBagFullList()
			if (!this.bag_loop_mgr) {
				this.bag_loop_mgr = new LoopScrowViewMgr(this.layer_value)
				this.bag_loop_mgr.SetData(this.goods_scroll, WarehouseBagRenderer, this.model.bag_full_list, LoopScrCon.Vertical, 6)
			} else {
				this.bag_loop_mgr.replaceAll(this.model.bag_full_list)
			}

			// var x = new Laya.ArrayCollection()
			// this.goods_con.itemRenderer = WarehouseBagRenderer


			this.model.CreateWarehouseList()
			if (!this.ware_loop_mgr) {
				this.ware_loop_mgr = new LoopScrowViewMgr(this.layer_value)
				this.ware_loop_mgr.SetData(this.ware_scroll, WarehouseRenderer, this.model.ware_full_list, LoopScrCon.Vertical, 6)
			} else {
				this.ware_loop_mgr.replaceAll(this.model.ware_full_list)
			}

		}

		this.InitEvent = () => {
			Util.AddClickEvent(this.useBtn, () => {
				this.model.Fire(local_BagModel.OPEN_VIEW, "OneKeyUseView")
			}
				, this, true)

			Util.AddClickEvent(this.expandBtn1, () => {
				this.model.Fire(local_BagModel.OPEN_VIEW, "ExpandBagView", local_GoodsModel.GOODS_POS_TYPE.warehouse)
			}
				, this, true)

			Util.AddClickEvent(this.expandBtn2, () => {
				this.model.Fire(local_BagModel.OPEN_VIEW, "ExpandBagView", local_GoodsModel.GOODS_POS_TYPE.bag)
			}
				, this, true)

			Util.AddClickEvent(this.smeltBtn, () => {
				this.model.Fire(local_BagModel.OPEN_VIEW, "BagSmeltView")
			}
				, this, true)

			let OnChangeBagList = () => {
				if (this.use_delete_method || !this.bag_loop_mgr) {
					return
				}
				this.model.CreateBagFullList()
				this.bag_loop_mgr.replaceAll(this.model.bag_full_list)
			}
			this.BindEvent(this.goodsModel, local_GoodsModel.CHANGE_BAG_LIST, OnChangeBagList)

			let OnChangeWarehouseList = () => {
				if (this.use_delete_method || !this.ware_loop_mgr) {
					return
				}
				this.model.CreateWarehouseList()
				this.ware_loop_mgr.replaceAll(this.model.ware_full_list)
			}
			this.BindEvent(this.goodsModel, local_GoodsModel.CHANGE_WAREHOUSE_LIST, OnChangeWarehouseList)

			let expandFunc = (vo?) => {
				if (vo.pos == local_GoodsModel.GOODS_POS_TYPE.bag) {
					this.model.CreateBagFullList()
					this.bag_loop_mgr.replaceAll(this.model.bag_full_list)
				} else if (vo.pos == local_GoodsModel.GOODS_POS_TYPE.warehouse) {
					this.model.CreateWarehouseList()
					this.ware_loop_mgr.replaceAll(this.model.ware_full_list)
				}
			}
			this.BindEvent(this.goodsModel, local_GoodsModel.CHANGE_BAG_MAX_CELL, expandFunc)

			Util.AddClickEvent(this.redequipBtn, () => {
				// CompositeModel.GetInstance().Fire(CompositeEvent.OPEN_RED_VIEW, 1, 105)
				OpenFun.OpenFunHandler(24);
			}
				, this, true)

			// 共鸣icon红点
			this.BindEvent(SuitModel.GetInstance(), SuitModelEvent.UP_SUIT_RED, () => {
				this.suitRed.visible = SuitModel.GetInstance().GetSuitTotlaRed();
			})
		}
	}

	public DeleteMe() {

		// BaseAwardItem.EndBatchLoad()
		if (this.bag_loop_mgr) {
			this.bag_loop_mgr.DeleteMe()
			this.bag_loop_mgr = null
		}
		if (this.ware_loop_mgr) {
			this.ware_loop_mgr.DeleteMe()
			this.ware_loop_mgr = null
		}
		super.DeleteMe()
	}

	public GetComponents() {
		[
			this._Image1,
			this._Image2,
			this._Scroller1,
			this._Scroller2,
			this._Image3,
			this._Image4,
			this.expandBtn1,
			this.expandBtn2,
			this.smeltBtn,
			this.useBtn,
			this.redequipBtn,
			this.suitRed,
			this._Image5,
			this._Label1,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_Image2",
				"_Scroller1",
				"_Scroller2",
				"_Image3",
				"_Image4",
				"expandBtn1",
				"expandBtn2",
				"smeltBtn",
				"useBtn",
				"redequipBtn",
				"suitRed",
				"_Image5",
				"_Label1",
			])
	}
}
window["WarehouseView"] = WarehouseView
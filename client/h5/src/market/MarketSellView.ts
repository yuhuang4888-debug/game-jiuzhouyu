import { BaseItem1 } from "../common/BaseItem1";
import { MarketModel, MarketEvent } from "../commonModel/MarketModel"
import { UIToolTipMgr } from "../common/UIToolTipMgr";
import { Util } from "../util/Util";
import { ResManager } from "../common/ResManager";
import { GameResPath } from "../util/GameResPath";
import { LoopScrowViewMgr, LoopScrCon } from "../common/LoopScrowViewMgr";
import { MarketSellItem } from "../market/MarketSellItem"
import { MarketSellGoodsItem } from "../market/MarketSellGoodsItem"

export class MarketSellView extends BaseItem1 {
	_img_bg: Laya.Image
	_Image111: Laya.Image
	_lb_tips: Laya.Label
	Content1: Laya.List
	_Image2: Laya.Image
	Content: Laya.List
	_btn_god: Laya.Box
	_Image1: Laya.Image
	CheckMask: Laya.Image
	labelDisplay: Laya.Label
	_btn_goods: Laya.Box
	_Image11: Laya.Image
	CheckMask1: Laya.Image
	labelDisplay1: Laya.Label
	_group_item_empty: Laya.Box
	_Image3: Laya.Image
	_Label1: Laya.Label
	_group_bag_empty: Laya.Box
	_Image4: Laya.Image
	_Label2: Laya.Label

	ChangeRadioValue
	ClearMark
	FireEvent
	InitEvent
	InitView
	Scr_Scroller1
	Scr_Scroller2
	SwitchView
	UpdateItems
	UpdateView
	_list_bag
	_list_item
	loop_mgr
	loop_mgr1

	public constructor(parent?) {
		super(parent)


		this.base_file = "market"
		this.layout_file = "MarketSellView"
		let model = MarketModel.GetInstance()
		let local_MarketEvent = MarketEvent
		let ui_tool_tip_mgr = UIToolTipMgr.GetInstance()
		let max_count_ = 0
		let cur_index_ = 1
		this.preload_server_config = {
			"config_goods": false,
			"config_goods_sell": false
		}
		this.load_callback = () => {

			// let mask = this.GetChild("_Scroller1/_list_item").GetComponent("Image")
			// this.RegisterMask(mask)
			// let mask1 = this.GetChild("_Scroller2/_list_bag").GetComponent("Image")
			// this.RegisterMask(mask1, 2)
			// if (PlatformMgr.GetInstance().IsEyouThPlatform()) {
			// 	SetSizeDeltaY(this._Label1, 35)
			// }

			this.InitView()
			this.InitEvent()
			this.FireEvent()
			// if (PlatformMgr.GetInstance().IsEyouIdnPlatform()) {
			// 	this._Label2.size = 20
			// }
		}

		this.FireEvent = () => {
			model.Fire(local_MarketEvent.REQUEST_PROTO, 15109)
		}

		this.InitEvent = () => {
			this.BindVar(model, "shelf_goods_info", () => {
				this.UpdateView()
			}
			)
			this.BindEvent(model, local_MarketEvent.NEED_UPDATE_BAG, () => {
				this.SwitchView(cur_index_)
			}
			)
			Util.AddClickEvent(this._btn_god, () => {
				if (cur_index_ != 1) {
					this.CheckMask.visible = true
					this.CheckMask1.visible = false
					this.ChangeRadioValue(1)
				}
			}
				, this, true)
			Util.AddClickEvent(this._btn_goods, () => {
				if (cur_index_ != 2) {
					this.CheckMask.visible = false
					this.CheckMask1.visible = true
					this.ChangeRadioValue(2)

				}
			}
				, this, true)
		}

		this.UpdateView = () => {
			let sg_info = model.GetShelfGoodsInfo()
			if (!sg_info) {
				return
			}
			this.UpdateItems(sg_info.goods_list)
			this.SwitchView(cur_index_)
			this._lb_tips.text = "已上架物品 " + sg_info.goods_list.length + "/" + max_count_
		}

		this.InitView = () => {

			//ResManager.GetInstance().SetOutsideImageSprite(this, this._Image111, GameResPath.GetIcon("common2", "uity_072"))
			ResManager.GetInstance().SetOutsideImageSprite(this, this._Image111, GameResPath.GetIcon("market", "xx_titleBg_012"))

			let kvcfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_goods_sell", false)
			max_count_ = model.GetKVCfg(kvcfg, 4)
			this.CheckMask.visible = true
			this.CheckMask1.visible = false
			this.SwitchView(1)
		}

		this.ChangeRadioValue = (index?) => {
			this.SwitchView(Number(index))
		}

		this.SwitchView = (index?, list?) => {
			cur_index_ = index
			this.ClearMark()
			list = list || model.GetBagGoods(index)
			this._group_bag_empty.visible = list.length < 1

			if (!this.loop_mgr) {
				this.loop_mgr = new LoopScrowViewMgr()
				this.loop_mgr.SetData(this.Content, MarketSellItem, list, LoopScrCon.Vertical, 5)
			} else {

				this.loop_mgr.replaceAll(list)
				//this.loop_mgr.FirstOnChild(1)
			}
			//SetAnchoredPositionY(this.Content,0)
		}

		this.UpdateItems = (list?) => {
			this._group_item_empty.visible = list.length < 1
			if (!this.loop_mgr1) {
				this.loop_mgr1 = new LoopScrowViewMgr()
				this.loop_mgr1.SetData(this.Content1, MarketSellGoodsItem, list, LoopScrCon.Vertical, 2)
			} else {
				this.loop_mgr1.replaceAll(list)

			}
		}


		this.ClearMark = () => {
			if (!this.loop_mgr || !this.loop_mgr.data_list) {
				return
			}
			for (let _tmpi in this.loop_mgr.data_list) {
				var vo = this.loop_mgr.data_list[_tmpi]
				vo.isMarket = null
			}
		}


	}

	public DeleteMe() {

		if (this.is_loaded) {
			this.ClearMark()
		}
		if (this.loop_mgr) {
			this.loop_mgr.DeleteMe()
			this.loop_mgr = null
		}
		if (this.loop_mgr1) {
			this.loop_mgr1.DeleteMe()
			this.loop_mgr1 = null
		}
		super.DeleteMe()
	}



	public GetComponents() {
		[
			this._img_bg,
			this._Image111,
			this._lb_tips,
			this.Content1,
			this._Image2,
			this.Content,
			this._btn_god,
			this._Image1,
			this.CheckMask,
			this.labelDisplay,
			this._btn_goods,
			this._Image11,
			this.CheckMask1,
			this.labelDisplay1,
			this._group_item_empty,
			this._Image3,
			this._Label1,
			this._group_bag_empty,
			this._Image4,
			this._Label2,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_Image111",
				"_lb_tips",
				"Content1",
				"_Image2",
				"Content",
				"_btn_god",
				"_Image1",
				"CheckMask",
				"labelDisplay",
				"_btn_goods",
				"_Image11",
				"CheckMask1",
				"labelDisplay1",
				"_group_item_empty",
				"_Image3",
				"_Label1",
				"_group_bag_empty",
				"_Image4",
				"_Label2",
			])
	}
}
window["MarketSellView"] = MarketSellView
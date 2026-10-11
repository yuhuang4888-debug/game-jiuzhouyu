import { BaseItem1 } from "../common/BaseItem1"
import { ShopModel, ShopEvent, ShopType } from "../commonModel/ShopModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { table } from "../common/table"
import { SacredShopItem } from "./SacredShopItem"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"

export class SacredShopView extends BaseItem1 {
	_img_bg: Laya.Image
	_Image1: Laya.Image
	_img_icon: Laya.Image
	_Group1: Laya.Box
	_lb_num: Laya.Label
	_Image2: Laya.Image
	_Label1: Laya.Label
	_Scroller1: Laya.Panel
	Content: Laya.List
	InitEvent
	InitItem
	InitView
	LoadSuccess
	LocalDeleteMe
	RefreshMoneyNum
	Scr_Scroller1
	_gp_items
	loop_mgr

	public constructor(parent?) {
		super(parent)


		this.base_file = "sacredShop"
		this.layout_file = "SacredShopView"
		let model = ShopModel.GetInstance()
		let local_ShopEvent = ShopEvent

		let goods_model = GoodsModel.GetInstance()
		let data_ = null
		let money_type_ = []
		let item_list_ = []
		this.load_callback = () => {

			this.LoadSuccess()
		}

		this.LoadSuccess = () => {
			model.Fire(local_ShopEvent.SHOP_REQUEST_PROTO, 15301, "c", ShopType.SacredShop)
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIconJpg("sacredShop", "uisy_049"))
			ResManager.GetInstance().SetImageSpriteTrans(this, this._Image2, GameResPath.GetIcon("sacredShop", "uisy_052"))
			this.InitEvent()
		}

		this.InitEvent = () => {
			this.BindEvent(goods_model, GoodsModel.UPDATE_SPECIAL_SCORE, () => {
				this.RefreshMoneyNum()
			}
			)
			this.BindEvent(model, local_ShopEvent.UPDATE_SHOP_DATA, () => {
				data_ = model.GetShopDataByType(7)
				if (!data_ || data_.length == 0) {
					return
				}
				money_type_[0] = data_[0].money_type
				this.InitView()
			}
			)
		}

		this.InitView = () => {
			let [type_id, lock] = goods_model.GetMappingTypeId(money_type_[0], 0)
			money_type_[1] = type_id
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_icon, GameResPath.GetGoodsIconPath(type_id))
			this.RefreshMoneyNum()
			this.InitItem()
		}

		this.RefreshMoneyNum = () => {
			this._lb_num.text = goods_model.GetSpecialScore(money_type_[0])
		}

		this.InitItem = () => {
			// if (item_list_.length > 0) {
			// 	for (let _tmpi in item_list_) {
			// 		var item = item_list_[_tmpi]
			// 		item.SetVisible(false)
			// 	}
			// }
			// for (let i in data_) {

			// 	let item = item_list_[i]
			// 	if (!item) {
			// 		item = new SacredShopItem(this.Content)
			// 		item.Load()
			// 		table.insert(item_list_, item)
			// 	}
			// 	//item:ExcuteCallback(() => {
			// 	item.SetVisible(true)
			// 	item.SetData(data_[i])
			// 	//}
			// 	//)
			// }
			if (!this.loop_mgr) {
				this.loop_mgr = new LoopScrowViewMgr()
				this.loop_mgr.SetData(this.Content, SacredShopItem, data_, LoopScrCon.Vertical, 2)
			} else {
				this.loop_mgr.replaceAll(data_)
			}
		}

		this.LocalDeleteMe = () => {
			if (item_list_.length > 0) {
				for (let _tmpi in item_list_) {
					var item = item_list_[_tmpi]
					item.DeleteMe()
				}
				item_list_ = []
			}
			if (this.loop_mgr) {
				this.loop_mgr.DeleteMe()
				this.loop_mgr = null
			}
		}


	}

	public DeleteMe() {

		this.LocalDeleteMe()
		super.DeleteMe()
	}


	public GetComponents() {
		[
			this._img_bg,
			this._Image1,
			this._img_icon,
			this._Group1,
			this._lb_num,
			this._Image2,
			this._Label1,
			this._Scroller1,
			this.Content,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_Image1",
				"_img_icon",
				"_Group1",
				"_lb_num",
				"_Image2",
				"_Label1",
				"_Scroller1",
				"Content",
			])
	}
}
window["SacredShopView"] = SacredShopView
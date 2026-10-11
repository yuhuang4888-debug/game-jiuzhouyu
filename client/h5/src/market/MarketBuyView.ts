import { BaseItem1 } from "../common/BaseItem1"
import { MarketEvent, MarketViewType, MarketModel } from "../commonModel/MarketModel"
import { MarketBuyListView } from "../market/MarketBuyListView"
import { MarketBuyCtrlView } from "../market/MarketBuyCtrlView"
import { ResManager } from "../common/ResManager"
import { LoopScrowViewMgr, LoopScrCon } from "../common/LoopScrowViewMgr"
import { MarketTypeBtn } from "../market/MarketTypeBtn"
export class MarketBuyView extends BaseItem1 {
	_img_bg: Laya.Image
	_group_view: Laya.Box
	_Image1: Laya.Image
	_Scroller1: Laya.Panel
	Content: Laya.List

	CustomMehod
	click_fun
	InitEvent
	InitView
	LocalDeleteMe
	Scr_Scroller1
	SwitchView
	UpdateSubView
	_list_btn
	loop_mgr

	public constructor(parent?) {
		super(parent)


		this.base_file = "market"
		this.layout_file = "MarketBuyView"
		let model = MarketModel.GetInstance()
		let local_MarketViewType = MarketViewType
		let _ac_btn_ = null
		let view_list_ = []
		let viewclass_list_ = [MarketBuyListView, MarketBuyCtrlView]
		let cur_index_ = 0
		let cur_view_type_ = -1
		let sell_type = 0
		let sell_sub_type = 0
		this.preload_client_config = {
			"ConfigMarket": false
		}
		this.load_callback = () => {

			this.InitView()

		}

		this.LocalDeleteMe = () => {
			for (let key in view_list_) {

				// [ts2lua]view_list_下标访问可能不正确
				view_list_[key].DeleteMe()
			}
			view_list_ = []
			//this.Content.removeEventListener(eui.ItemTapEvent.ITEM_TAP, this.click_fun, this)
			// if (this.loop_mgr) {
			// 	this.loop_mgr.DeleteMe()
			// 	this.loop_mgr = null
			// }
		}

		this.InitEvent = () => {
			this.BindEvent(model, MarketEvent.SWTICH_BUY_SUBVIEW, (view_type, ...new_args) => {
				this.UpdateSubView(view_type, ...new_args)
			}
			)
		}
		this.click_fun = (e?) => {
			let data = this.Content.array
			if (data && !sell_type && !sell_sub_type) {
				let index = data[this.Content.selectedIndex].id
				this.SwitchView(index)
			}

		}
		this.InitView = () => {
			let market_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "ConfigMarket", true)
			if (this.use_delete_method) {
				ResManager.GetInstance().DestroyAllReferenceRes(this.hashCode)
				return
			}
			// [ts2lua]market_cfg下标访问可能不正确
			let radio_list = market_cfg["type_radio_cfg"]

			if (!this.loop_mgr) {
				this.loop_mgr = new LoopScrowViewMgr()
				this.loop_mgr.SetData(this.Content, MarketTypeBtn, radio_list, LoopScrCon.Horizontal, 1, this.click_fun)
				//this.Content.addEventListener(eui.ItemTapEvent.ITEM_TAP, this.click_fun, this)
			} else {
				this.loop_mgr.replaceAll(radio_list)

			}
			let index = 0
			if (sell_type && sell_sub_type) {
				let id_ = Number(sell_type)

				for (let key in radio_list) {
					let id = radio_list[key] && radio_list[key].id
					if (id == id_)
						index = Number(key)
				}
				this.UpdateSubView(1, sell_type, sell_sub_type)
				this.loop_mgr.SetSelectIndex(index)
				sell_type = 0
				sell_sub_type = 0
			}
			else {
				
				this.SwitchView(1)
				this.loop_mgr.SetSelectIndex(index)
			}
			

			this.InitEvent()
		}

		this.SwitchView = (index?) => {
			//index = index + 1
			if (cur_view_type_ == local_MarketViewType.LIST && cur_index_ == index) {
				return
			}
			cur_index_ = index
			this.UpdateSubView(local_MarketViewType.LIST, cur_index_)
		}


		this.UpdateSubView = (view_type, ...new_args) => {
			cur_view_type_ = view_type
			// [ts2lua]view_list_下标访问可能不正确
			let view = view_list_[view_type]
			if (!view) {
				// [ts2lua]viewclass_list_下标访问可能不正确
				let viewclass = viewclass_list_[view_type]
				view = new viewclass(this._group_view)
				view.Load()
				// [ts2lua]view_list_下标访问可能不正确
				view_list_[view_type] = view
			}
			view.SetData(...new_args)
			this.PopUpChild(view)
		}

		this.CustomMehod = (index?, ...arg) => {
			// if (!this.is_loaded) {
			// 	return
			// }
			if (arg && index == 0 && arg[0]) {
				sell_type = arg[0][0]
				sell_sub_type = arg[0][1]
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
			this._group_view,
			this._Image1,
			this._Scroller1,
			this.Content,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_group_view",
				"_Image1",
				"_Scroller1",
				"Content",
			])
	}
}
window["MarketBuyView"] = MarketBuyView
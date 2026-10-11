import { BaseItem1 } from "../common/BaseItem1"
import { MarketModel, MarketEvent } from "../commonModel/MarketModel"
import { MarketBuyTypeItem } from "../market/MarketBuyTypeItem"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { table } from "../common/table"
import { LoopScrowViewMgr,LoopScrCon } from "../common/LoopScrowViewMgr"

export class MarketBuyListView extends BaseItem1 {
	_img_bg: Laya.Image
	_Image1: Laya.Image
	_lb_tips: Laya.Label
	_lb_tips2: Laya.Label
	Content: Laya.List

	FireEvent
	InitEvent
	InitView
	LocalDeleteMe
	Scr_Scroller1
	SetData
	UpdateView
	_list_item
	loop_mgr

	public constructor(parent?) {
		super(parent)


		this.base_file = "market"
		this.layout_file = "MarketBuyListView"
		let model = MarketModel.GetInstance()
		let local_MarketEvent = MarketEvent
		let click_list_ = []
		let type_ = 0
		this.preload_server_config = {
			"config_goods_sell": false
		}
		this.load_callback = () => {

			this.InitView()
			this.InitEvent()
			this.FireEvent()
			// if (PlatformMgr.GetInstance().IsEyouIdnPlatform() ) {
			// 	this._lb_tips.size  = 20
			// }
		}

		this.LocalDeleteMe = () => {
			click_list_ = []
			if (this.loop_mgr) {
				this.loop_mgr.DeleteMe()
				this.loop_mgr = null
			}
			super.DeleteMe()
		}

		this.InitView = () => {
			ResManager.GetInstance().SetImageSprite(this, this._Image1,"common2", "uity_072")
			// if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
			// 	this._lb_tips.size  = 18
			// }
		}

		this.FireEvent = () => {
			model.Fire(local_MarketEvent.REQUEST_PROTO, 15101, "i", type_)
		}

		this.InitEvent = () => {
			this.BindEvent(model, local_MarketEvent.SET_TYPE_DIC, (type?) => {
				if (type_ != type) {
					return
				}
				// [ts2lua]click_list_下标访问可能不正确
				click_list_[type_] = true
				this.UpdateView()
			}
			)
		}

		this.UpdateView = () => {
			if (!this.is_loaded) {
				return
			}
			let type_goods_info = model.GetGoodsDic(type_)
			if (!type_goods_info) {
				return
			}
			let list = []
			let kvcfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_goods_sell", false)
			let cfg_list = model.GetTypeCfgAll(kvcfg, type_)

			for (let _tmpi in type_goods_info.sell_list) {
				var info = type_goods_info.sell_list[_tmpi]
				// [ts2lua]cfg_list下标访问可能不正确
				cfg_list[info.subtype] = info
			}
			for (let k in cfg_list) {
				var v = cfg_list[k]
				table.insert(list, v)
			}

			if (!this.loop_mgr) {
				this.loop_mgr = new LoopScrowViewMgr()
				this.loop_mgr.SetData(this.Content, MarketBuyTypeItem, list, LoopScrCon.Vertical)
			} else {
				this.loop_mgr.replaceAll(list)

			}
			let dayCount = 0
			if (!model.kf_open) {
				dayCount = model.checkKfOpen(kvcfg)
				this._lb_tips2.text = dayCount + "天后市场开启跨服交易"
			}
			this._lb_tips2.visible = !model.kf_open && dayCount > 0
		}

		this.SetData = (...new_args) => {
			let parms = new_args
			type_ = parms[0]
			this.FireEvent()
			this.UpdateView()
		}



	}
	public DeleteMe() {

		this.LocalDeleteMe()
	}


	public GetComponents() {
		[
			this._img_bg,
			this._Image1,
			this._lb_tips,
			this._lb_tips2,
			this.Content,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_Image1",
				"_lb_tips",
				"_lb_tips2",
				"Content",
			])
	}
}

window["MarketBuyListView"] = MarketBuyListView
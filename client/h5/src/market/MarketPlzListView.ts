import { BaseItem1 } from "../common/BaseItem1"
import { MarketEvent, MarketModel } from "../commonModel/MarketModel"
import { Util } from "../util/Util"
import { LoopScrowViewMgr,LoopScrCon } from "../common/LoopScrowViewMgr"
import { MarketPlzShowItem } from "../market/MarketPlzShowItem"
import { table } from "../common/table"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"

export class MarketPlzListView extends BaseItem1 {
	_group_title: Laya.Box
	_Image1: Laya.Image
	_Label1: Laya.Label
	_Label2: Laya.Label
	_group_price: Laya.Box
	_Label3: Laya.Label
	_img_price: Laya.Image
	Content: Laya.List
	_group_empty: Laya.HBox
	_Image2: Laya.Image
	_Label4: Laya.Label
	FireEvent
	InitEvent
	InitView
	Scr_Scroller1
	SetData
	SortList
	UpdateView
	_list_item
	loop_mgr

	public constructor(parent?) {
		super(parent)


		this.base_file = "market"
		this.layout_file = "MarketPlzListView"
		let model = MarketModel.GetInstance()
		let local_MarketEvent = MarketEvent
		let select_index_ = 0
		let seek_list_ = []
		let up_order_ = false
		this.preload_server_config = {
			"config_equip_attr": false
		}
		this.load_callback = () => {

			// let mask = this.GetChild("_Scroller1/_list_item").GetComponent("Image")
			// this.RegisterMask(mask)
			// if (PlatformMgr.GetInstance().IsEyouThPlatform() ) {
			// 	SetSizeDeltaY(this._Label4,35)
			// }
			ResManager.GetInstance().SetOutsideImageSprite(this,this._Image1,GameResPath.GetIcon("market", "uishi_014"))
			this.InitView()
			this.InitEvent()
			this.FireEvent()
			// if (PlatformMgr.GetInstance().IsEyouIdnPlatform() ) {
			// 	SetAnchoredPositionX(this._Label3,-73.78)
			// }
		}

		this.InitView = () => {
			if (select_index_ == 0) {
				model.Fire(local_MarketEvent.REQUEST_PROTO, 15118, "hh", 1, 999)
			} else if (select_index_ == 1) {
				model.Fire(local_MarketEvent.REQUEST_PROTO, 15119)
			}

		}

		this.FireEvent = () => {

		}

		this.InitEvent = () => {
			this.BindVar(model, "seek_info_mine", () => {
				if (select_index_ != 1) {
					return
				}
				let mine_info = model.GetSeekMineInfo()
				seek_list_ = mine_info.seek_list
				this.UpdateView()
			}
			)
			this.BindVar(model, "seek_info_all", () => {
				if (select_index_ != 0) {
					return
				}
				let all_info = model.GetSeekAllInfo()
				seek_list_ = all_info.seek_list
				this.UpdateView()
			}
			)
			Util.AddClickEvent(this._group_price, () => {
				up_order_ = !up_order_
				let rotation = up_order_ ? 0 : 180
				this._img_price.rotation = rotation
				seek_list_ = this.SortList(seek_list_, up_order_)
				this.UpdateView()
			}
				, this)
			this.BindEvent(model, local_MarketEvent.SWTICH_PLZ_SELECT, (index?) => {
				select_index_ = index
				// [ts2lua]lua中0和空字符串也是true，此处index == 0需要确认
				let info = (index) == 0 && model.GetSeekAllInfo() || model.GetSeekMineInfo()
				if (!info) {
					this.SetData(index)
				} else {
					seek_list_ = info.seek_list
					this.UpdateView()
				}
			}
			)
		}

		this.UpdateView = () => {
			if (!this.loop_mgr) {
				this.loop_mgr = new LoopScrowViewMgr()
				this.loop_mgr.SetData(this.Content, MarketPlzShowItem, seek_list_, LoopScrCon.Vertical, 1)
			} else {
				this.loop_mgr.replaceAll(seek_list_)

			}
			//this.Content.refresh()
			this._group_empty.visible = seek_list_.length < 1
			this._group_title.visible = seek_list_.length > 0
		}

		this.SetData = (...new_args) => {
			let parms = new_args
			select_index_ = parms[0]
			if (this.is_loaded) {
				if (select_index_ == 0) {
					model.Fire(local_MarketEvent.REQUEST_PROTO, 15118, "hh", 1, 999)
				} else if (select_index_ == 1) {
					model.Fire(local_MarketEvent.REQUEST_PROTO, 15119)
				}
			}
		}

		this.SortList = (list?, up?) => {
			if (up == null) {
				up = true
			}
			if (up) {
				table.sort(list, (a?, b?) => {
					return a.unit_price > b.unit_price
				}
				)
			} else {
				table.sort(list, (a?, b?) => {
					return b.unit_price > a.unit_price
				}
				)
			}
			return list
		}


	}



	public GetComponents() {
		[
			this._group_title,
			this._Image1,
			this._Label1,
			this._Label2,
			this._group_price,
			this._Label3,
			this._img_price,
			this.Content,
			this._group_empty,
			this._Image2,
			this._Label4,
		]
			= this.GetChildrenByNames([

				"_group_title",
				"_Image1",
				"_Label1",
				"_Label2",
				"_group_price",
				"_Label3",
				"_img_price",
				"Content",
				"_group_empty",
				"_Image2",
				"_Label4",
			])
	}
}
window["MarketPlzListView"] = MarketPlzListView
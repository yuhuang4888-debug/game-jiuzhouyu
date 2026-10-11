import { BaseItem1 } from "../common/BaseItem1"
import { MarketModel, MarketEvent } from "../commonModel/MarketModel"
import { MarketRecordItem } from "../market/MarketRecordItem"
import { LoopScrowViewMgr, LoopScrCon } from "../common/LoopScrowViewMgr"

export class MarketRecordDealView extends BaseItem1 {
	_Group1: Laya.Box
	_Image1: Laya.Image
	_Image2: Laya.Image
	_Image3: Laya.Image
	_Image4: Laya.Image
	_Label1: Laya.Label
	_Label2: Laya.Label
	_Label3: Laya.Label
	_Label4: Laya.Label
	Content: Laya.List
	_group_empty: Laya.Box
	_Image5: Laya.Image
	_Label5: Laya.Label

	FireEvent
	InitEvent
	Scr_Scroller1
	UpdateView

	_list_item
	loop_mgr

	public constructor(parent?) {
		super(parent)


		this.base_file = "market"
		this.layout_file = "MarketRecordDealViewExml"
		let model = MarketModel.GetInstance()
		let local_MarketEvent = MarketEvent
		this.load_callback = () => {

			this.InitEvent()
			this.FireEvent()
		}


		this.InitEvent = () => {
			this.BindEvent(model, local_MarketEvent.UPDATE_RECORD, (info?) => {
				this.UpdateView(info)
			}
			)
			this.BindEvent(model, local_MarketEvent.BUY_SUCCESS, (info?) => {
				model.Fire(local_MarketEvent.REQUEST_PROTO, 15112)
			}
			)
		}

		this.FireEvent = () => {
			model.Fire(local_MarketEvent.REQUEST_PROTO, 15112)
		}

		this.UpdateView = (info?) => {

			let list = info.record_list
			this._group_empty.visible = list.length < 1
			if (!this.loop_mgr) {
				this.loop_mgr = new LoopScrowViewMgr()
				this.loop_mgr.SetData(this.Content, MarketRecordItem, list,LoopScrCon.Vertical, 1)
			} else {
				this.loop_mgr.replaceAll(list)

			}
		}



	}

	public DeleteMe() {

		if (this.loop_mgr) {
			this.loop_mgr.DeleteMe()
			this.loop_mgr = null
		}
		super.DeleteMe()
	}


	public GetComponents() {
		[
			this._Group1,
			this._Image1,
			this._Image2,
			this._Image3,
			this._Image4,
			this._Label1,
			this._Label2,
			this._Label3,
			this._Label4,
			this.Content,
			this._group_empty,
			this._Image5,
			this._Label5,
		]
			= this.GetChildrenByNames([

				"_Group1",
				"_Image1",
				"_Image2",
				"_Image3",
				"_Image4",
				"_Label1",
				"_Label2",
				"_Label3",
				"_Label4",
				"Content",
				"_group_empty",
				"_Image5",
				"_Label5",
			])
	}
}

window["MarketRecordDealView"] = MarketRecordDealView
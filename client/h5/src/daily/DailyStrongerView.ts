import { BaseItem1 } from "../common/BaseItem1"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { DailyModel } from "../commonModel/DailyModel"
import { DailyEvent } from "./DailyEvent"
import { DailyStrongerItem } from "./DailyStrongerItem"
import { DailyStrongerTab } from "./DailyStrongerTab"

export class DailyStrongerView extends BaseItem1 {
	CustomMehod
	InitEvents
	LoadSuccess
	bag_loop_mgr
	initItem
	initTab
	tabTouchHandler
	tab_item_list

	public constructor(parent) {
		super(parent)
		this.base_file = "daily"
		this.layout_file = "DailyStrongerView"
		let _model = DailyModel.GetInstance()
		let local_DailyEvent = DailyEvent
		let select_tab = 1
		this.tab_item_list = []
		this.preload_server_config = {
			"config_to_be_strong": false
		}
		this.load_callback = () => {
			this.InitEvents()
			this.LoadSuccess()
		}

		this.InitEvents = () => {
			this.BindEvent(_model, local_DailyEvent.STRONGER_DATA_RETURN, () => {
				this.initItem()
			})

			this.BindEvent(_model, local_DailyEvent.DAILY_STRONG_TAB_CLICK, (index?) => {
				this.tabTouchHandler(index)
			})

			_model.Fire(local_DailyEvent.REQUEST_STRONGER_DATA)
		}

		this.LoadSuccess = () => {
			this.Content.scrollBar.visible = false
			this._Scroller1.hScrollBar.visible = false

			_model.SetstrongerRedDot(false)
			this.initTab()
		}

		this.CustomMehod = (index?, args?) => {
			select_tab = !args && 1 || args[0][1]
		}

		this.initItem = () => {
			let config_to_be_strong = ResManager.GetInstance().GetGameConfigFromCache(this, "config_to_be_strong", false);
			let data = _model.getItemConfig(select_tab, config_to_be_strong)
			if (!this.bag_loop_mgr) {
				this.bag_loop_mgr = new LoopScrowViewMgr()
				this.bag_loop_mgr.SetData(this.Content, DailyStrongerItem, data, LoopScrCon.Vertical)
			} else {
				// this.bag_loop_mgr.RestToBeginning()
				this.bag_loop_mgr.replaceAll(data)
			}

		}

		this.initTab = () => {
			let data = [1, 2, 3]
			let item
			for (let i = 0; i < data.length; i++) {
				var v = data[i]
				item = this.tab_item_list[i]
				if (!item) {
					item = new DailyStrongerTab(this.Content1)
					item.Load()
					this.tab_item_list[i] = item
				}
				item.SetData(v)
				//if (i == select_tab ) { 
				//item:SetSelected(i)		
				//}
			}
			_model.Fire(DailyEvent.DAILY_STRONG_TAB_CLICK, select_tab)
			this.tabTouchHandler(select_tab, true)
		}

		this.tabTouchHandler = (index?, force?) => {
			if (select_tab == index && !force) {
				return
			}
			select_tab = index
			_model.strong_tab = index
			this.initItem()
		}
	}

	public DeleteMe() {
		if (this.bag_loop_mgr) {
			this.bag_loop_mgr.DeleteMe()
			this.bag_loop_mgr = null
		}
		if (this.tab_item_list) {
			for (let i = 0; i < this.tab_item_list.length; i++) {
				var item = this.tab_item_list[i]
				item.DeleteMe()
				item = null
			}
			this.tab_item_list = []
		}
		super.DeleteMe()
	}


	image: Laya.Image
	_item_scroller: Laya.Panel
	Content: Laya.List
	_Scroller1: Laya.Panel
	Content1: Laya.HBox
	_Image1: Laya.Image
	_Image2: Laya.Image
	public GetComponents() {
		[
			this.image,
			this._item_scroller,
			this.Content,
			this._Scroller1,
			this.Content1,
			this._Image1,
			this._Image2,
		]
			= this.GetChildrenByNames([

				"image",
				"_item_scroller",
				"Content",
				"_Scroller1",
				"Content1",
				"_Image1",
				"_Image2",
			])
	}
}
window["DailyStrongerView"] = DailyStrongerView
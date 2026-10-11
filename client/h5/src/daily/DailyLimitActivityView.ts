import { BaseItem1 } from "../common/BaseItem1"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { DailyModel, ActivityType } from "../commonModel/DailyModel"
import { SettingModel } from "../commonModel/SettingModel"
import { GameResPath } from "../util/GameResPath"
import { DailyBottomView } from "./DailyBottomView"
import { DailyEvent } from "./DailyEvent"
import { DailyLimitActivityItem } from "./DailyLimitActivityItem"

export class DailyLimitActivityView extends BaseItem1 {
	InitContent
	InitEvents
	LoadSuccess
	SetData
	_daily_bottom_view
	bag_loop_mgr

	public constructor(parent?) {
		super(parent)


		this.base_file = "daily"
		this.layout_file = "DailyLimitActivityView"
		let model = DailyModel.GetInstance()
		let local_DailyEvent = DailyEvent
		let _daily_task = null
		let _arrayCollection = null
		this._daily_bottom_view = null
		this.bag_loop_mgr = null
		this.preload_server_config = {
			"config_num_by_vip": false,
			"config_ac_kv": false
		}
		this.load_callback = () => {
			this.LoadSuccess()
			this.InitEvents()
			this.SetData()
			model.Fire(local_DailyEvent.DAILY_REQUEST_PROTO, 15701, "c", 2)
			
		}

		this.LoadSuccess = () => {
			this._list_item_con.vScrollBarSkin = ""
			// ResManager.GetInstance().SetOutsideImageSprite(this, this.bg, GameResPath.GetIconJpg("daily", "uirw_mrrw_001"))
		}

		this.InitEvents = () => {
			let update_fun = () => {
				this.SetData()
			}
			this.BindEvent(model, local_DailyEvent.UPDATE_DAILY_DATA, update_fun)
		}

		this.SetData = () => {
			let list = model.daily_data[ActivityType.Limit]
			if (list) {
				let config_num_by_vip = ResManager.GetInstance().GetGameConfigFromCache(this, "config_num_by_vip", false);
				let config_ac_kv = ResManager.GetInstance().GetGameConfigFromCache(this, "config_ac_kv", false);
				_daily_task = model.SortLimitActivityList(list.ac_list, config_num_by_vip, config_ac_kv)
				if (!_daily_task) {
					return
				}
				this.InitContent()
				if (!this._daily_bottom_view) {
					this._daily_bottom_view = new DailyBottomView(this._box_bottom)
					this._daily_bottom_view.Load()
				}
			}
		}

		this.InitContent = () => {
			if (!this.bag_loop_mgr) {
				this.bag_loop_mgr = new LoopScrowViewMgr()
				this.bag_loop_mgr.SetData(this._list_item_con, DailyLimitActivityItem, _daily_task, LoopScrCon.Vertical)
			} else {
				this.bag_loop_mgr.replaceAll(_daily_task)
			}
		}
	}

	public DeleteMe() {
		if (this._daily_bottom_view) {
			this._daily_bottom_view.DeleteMe()
			this._daily_bottom_view = null
		}
		if (this.bag_loop_mgr) {
			this.bag_loop_mgr.DeleteMe()
			this.bag_loop_mgr = null
		}
		super.DeleteMe()
	}



	_list_item_con: Laya.List
	_box_bottom: Laya.Box
	public GetComponents() {
		[
			this._list_item_con,
			this._box_bottom,
		]
			= this.GetChildrenByNames([

				"_list_item_con",
				"_box_bottom",
			])
	}
}
window["DailyLimitActivityView"] = DailyLimitActivityView
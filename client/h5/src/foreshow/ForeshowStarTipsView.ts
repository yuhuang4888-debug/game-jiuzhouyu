import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseView1 } from "../common/BaseView1"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { DailyModel } from "../commonModel/DailyModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { ActivityForeshowManager } from "../commonModel/ActivityForeshowManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { Util, Trim, GlobalTimerQuest, RefBoxChildsLayout, SetHtmlCenter } from "../util/Util"

export class ForeshowStarTipsView extends BaseView1 {
	ChangeCheckImg
	InitEvent
	LoadSuccess
	checkHandler
	check_selected
	click_bg_toClose
	close_callback
	destroy_callback
	destroy_imm
	initCloseTimer
	initView
	localOpen
	is_center
	onTimer
	open_callback
	removeTimer
	setData
	use_background

	public constructor() {
		super()


		let activity_foreshow_mgr = ActivityForeshowManager.GetInstance()
		let local_TimeUtil = TimeUtil
		let _activity = null
		let _item_list = []
		let _closeTimer = null
		let _time = 10
		let _isStar = false

		this.base_file = "foreshow"
		this.layout_file = "ForeshowStarTipsView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.is_center = true
		this.use_background = true
		this.click_bg_toClose = true
		this.append_to_ctl_queue = true;
		this.load_callback = () => {
			// this._lb_desc.style.color="#4a3a32"
			// this._lb_desc.style.fontSize=22
			// this._lb_desc.style.wordWrap=true
			this._Scroller2.hScrollBarSkin = ""
			this._Scroller1.vScrollBarSkin = ""
			this.InitEvent()
			this.LoadSuccess()
		}

		this.open_callback = () => {
			activity_foreshow_mgr.tips_view_open = true
		}

		this.destroy_callback = () => {
			for (let _tmpi in _item_list) {
				var obj = _item_list[_tmpi]
				obj.DeleteMe()
			}
			_item_list = []
			this.removeTimer()
		}

		this.close_callback = () => {
			activity_foreshow_mgr.tips_view_open = false
			activity_foreshow_mgr.ShowAllTipsView()
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._btn, () => {
				if (_isStar) {
					let iconType = _activity.module + "@" + _activity.module_sub + "@" + _activity.ac_sub
					GlobalEventSystem.Fire(EventName.OPEN_FORESHOW_ICON_VIEW, iconType)
				}
				this.Close()
			}, this, true)

			Util.AddClickEvent(this._check, () => {

				this.check_selected = !this.check_selected
				this.ChangeCheckImg()

				this.checkHandler()
			}, this, false)
		}

		/* 	this.setData = (activity?, isStar?) => {
			_activity = activity
			_isStar = isStar
			if (this.is_loaded) {
				this.initView()
			}
			} */

		this.LoadSuccess = () => {
			// ResManager.GetInstance().SetOutsideImageSprite(this, this._bg, GameResPath.GetIcon("foreshow", "uijcyg_001"))
			// ResManager.GetInstance().SetOutsideImageSprite(this, this._bg2, GameResPath.GetIcon("foreshow", "uijcyg_002"))

			this.check_selected = false
			this.initView()
		}

		this.initView = () => {
			if (!_activity) {
				return
			}
			ResManager.GetInstance().SetImageSpriteTrans(this, this._icon, GameResPath.GetDailyIconPath(_activity.ac_icon))
			let serverTime = TimeUtil.timeHMS(TimeUtil.getServerTime() * 1000)
			let timeList = JSON.parse(_activity.time_region)
			let timeStr = ""

			let index1 = 0
			let index2 = 1
			for (let time of timeList) {
				let endTime = TimeUtil.HMStimeToS(time[1][0], time[1][1]);
				if (serverTime <= endTime) {
					let starM = time[index1][index2]
					let endM = time[index2][index2]
					timeStr = time[index1][index1] + ":" + (Number(starM) >= 10 && (starM) || ("0" + starM)) + " ~" + time[index2][index1] + ":" + (Number(endM) >= 10 && (endM) || ("0" + endM))
					if (true) {
						break
					}
				}
			}
			this._lb_time.text = timeStr
			let str: string = Trim(_activity.about)
			str = str.replace("<br/>", "\n")
			this._lb_desc.text = str//Trim(_activity.about)

			let id = _activity.module + "@" + _activity.module_sub + "@" + _activity.ac_sub
			let tipslist = activity_foreshow_mgr.show_ten_tips_view
			this.check_selected = tipslist.indexOf(id) != -1    //TableContains(tipslist, id)
			this.ChangeCheckImg()

			if (_isStar) {
				this._Group3.visible = false
				this._lb_open.visible = true
				this.labelDisplay.text = "参与活动"
			}

			let list = DailyModel.GetInstance().GetActivityRewardList(_activity)
			if (list) {
				let item = null

				for (let i = 0; i < list.length; i++) {
					item = _item_list[i]
					if (!item) {
						item = new BaseAwardItem(this.reward_scroll, null, "Activity")
						_item_list[i] = item
						item.SetUseMask(true)
						item.Load()
						item.SetItemSize(92, 92)
					}
					let type_id, lock
					[type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(list[i][0], list[i][1])
					item.SetData(type_id, 0)
				}

				// let len = list.length
				// let scr_width = (len - 1) * 6 + len * 95.25
				// if (scr_width >= 392) {
				// 	scr_width = 392
				// }
				// SetSizeDeltaX(this._Scroller2, scr_width)
			}
			this.initCloseTimer()

			let len = list ? list.length : 0
			if (len > 4) {
				this.reward_scroll.x = 0
			} else {
				this.reward_scroll.x = (this._Scroller2.width - (len * 92 + (len - 1) * this.reward_scroll.space)) / 2
			}

			RefBoxChildsLayout(this._Group1, 2)
		}

		this.initCloseTimer = () => {

			if (!_closeTimer) {
				_closeTimer = GlobalTimerQuest.AddPeriodQuest(() => {
					this.onTimer()
				}, 1, -1)

				this.onTimer()
			}

		}

		this.onTimer = () => {
			// if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
			// 	this._lb_close.text = "Interface closing in" + _time + "S"
			// }else{
			// 	this._lb_close.text = _time + "S后关闭界面"
			// }
			this._lb_close.text = `${_time}s后关闭界面`
			if (_time <= 0) {
				this.removeTimer()
				this.Close()
			}
			_time = _time - 1
		}

		this.removeTimer = () => {
			if (_closeTimer) {
				GlobalTimerQuest.CancelQuest(_closeTimer)
				_closeTimer = null
				_time = 10
			}
		}

		this.ChangeCheckImg = () => {
			let check_url = this.check_selected && "com_ui_gx1" || "com_ui_gx"
			ResManager.GetInstance().SetImageSprite(this, this._check, "common_asset", check_url)
		}

		this.checkHandler = () => {
			let select = this.check_selected
			let list = activity_foreshow_mgr.show_ten_tips_view
			let id = _activity.module + "@" + _activity.module_sub + "@" + _activity.ac_sub
			if (!select) {
				let index = table.find(list, id)
				if (index != -1) {
					table.splice(list, index, 1)
				}
			} else {
				table.insert(list, id)
			}
		}

		this.localOpen = (...param) => {
			if (param.length > 1) {
				[_activity, _isStar] = [...param];
			} else {
				[_activity] = [...param];
			}
		}

	}


	public DeleteMe() {
		super.DeleteMe()
	}
	public Open(...param) {
		this.localOpen(...param);
		super.Open();
	}



	_bg: Laya.Image
	_bg2: Laya.Image
	_img2: Laya.Image
	_img6: Laya.Image
	_icon: Laya.Image
	_Group1: Laya.Box
	_Label1: Laya.Label
	_lb_time: Laya.Label
	_Scroller1: Laya.Panel
	_lb_desc: Laya.Label
	_btn: Laya.Box
	_Image1: Laya.Image
	labelDisplay: Laya.Label
	_Group3: Laya.Box
	_check: Laya.Image
	_Label2: Laya.Label
	_lb_open: Laya.Label
	_Scroller2: Laya.Panel
	reward_scroll: Laya.HBox
	_lb_close: Laya.Label
	public GetComponents() {
		[
			this._bg,
			this._bg2,
			this._img2,
			this._img6,
			this._icon,
			this._Group1,
			this._Label1,
			this._lb_time,
			this._Scroller1,
			this._lb_desc,
			this._btn,
			this._Image1,
			this.labelDisplay,
			this._Group3,
			this._check,
			this._Label2,
			this._lb_open,
			this._Scroller2,
			this.reward_scroll,
			this._lb_close,
		]
			= this.GetChildrenByNames([

				"_bg",
				"_bg2",
				"_img2",
				"_img6",
				"_icon",
				"_Group1",
				"_Label1",
				"_lb_time",
				"_Scroller1",
				"_lb_desc",
				"_btn",
				"_Image1",
				"labelDisplay",
				"_Group3",
				"_check",
				"_Label2",
				"_lb_open",
				"_Scroller2",
				"reward_scroll",
				"_lb_close",
			])
	}
}
window["ForeshowStarTipsView"] = ForeshowStarTipsView
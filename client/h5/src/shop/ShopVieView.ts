import { BaseItem1 } from "../common/BaseItem1"
import { EventName } from "../common/EventName"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { MainUIModel } from "../commonModel/MainUIModel"
import { ShopModel, ShopEvent, ShopIndex } from "../commonModel/ShopModel"
import { MainUIChatView } from "../mainUI/MainUIChatView"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { Mathf } from "../util/Mathf"
import { SYTweenLite } from "../util/SYTweenLite"
import { TimeUtil } from "../util/TimeUtil"
import { GetSizeDeltaY, SetLocalPositionY, GlobalTimerQuest } from "../util/Util"
import { ShopVieItem } from "./ShopVieItem"

export class ShopVieView extends BaseItem1 {
	CancelTimer
	GetGoodList
	InitContent
	InitEvent
	LoadSuccess
	Local_DeleteMe
	OnTimer
	Scr_scroll
	ShowAnim
	StartTimer
	UpdateView
	_Group1
	_dgp_item
	_lb_time
	_scroll
	_viewport
	cansGroup
	is_delay_callback
	tween_id
	_Group2: Laya.Box
	_Image1: Laya.Image
	_Image2: Laya.Image

	public constructor(parent?) {
		super(parent)


		this.base_file = "shop"
		this.layout_file = "ShopVieView"

		let _model = ShopModel.GetInstance()
		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName
		let local_ShopEvent = ShopEvent
		let local_TimeUtil = TimeUtil
		let data_ = null
		let _ac_item_ = null
		let count_time_id_ = null
		this.is_delay_callback = false

		this.load_callback = () => {

			//this.RegisterMask(this._viewport)
			this.LoadSuccess()
			this.ShowAnim()
		}

		this.Local_DeleteMe = () => {
			this.CancelTimer()
			if (_ac_item_) {
				_ac_item_.DeleteMe()
				_ac_item_ = null
			}
			SYTweenLite.Stop(this.tween_id)
			super.DeleteMe()
		}

		this.LoadSuccess = () => {

			let ac_source = this.GetGoodList()
			_ac_item_ = new LoopScrowViewMgr()
			_ac_item_.SetData(this._dgp_item, ShopVieItem, ac_source, LoopScrCon.Vertical, 3)

			this.InitEvent()
			this.UpdateView()
			this.InitContent()

			//LayoutRebuilder(this._Group1)

			_model.vie_red_stutus = false
			local_GlobalEventSystem.Fire(local_EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "ShopView", ShopIndex.Vie, false)
			local_GlobalEventSystem.Fire(local_EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 153)
			//MainUIModel.GetInstance().Fire(MainUIModel.REFRESH_FRIEND_AND_MAIL_RED, MainUIChatView.red_index.shop)

			_model.Fire(local_ShopEvent.SHOP_REQUEST_PROTO, 64000)
		}

		this.InitEvent = () => {
			this.BindEvent(_model, local_ShopEvent.UPDATE_VIE_SHOP_DATA, () => {
				this.UpdateView()
			}
			)
		}

		this.UpdateView = () => {
			data_ = _model.GetVieInfo()
			if (!data_) {
				return
			}
			_ac_item_.replaceAll(data_.id_list)
			this.StartTimer()
		}

		this.GetGoodList = () => {
			return data_ && data_.id_list || {}
		}

		this.InitContent = () => {
			let list = this.GetGoodList()
			if (_model.show_type_id) {
				let count = null
				let vo = null

				for (let i = 1; i <= list.length; i++) {
					vo = list[i]
					if (vo.goods_id == _model.show_type_id) {
						count = i
						break
					}
				}

				if (count) {
					let height = 332
					let line = Mathf.Floor((count - 1) / 3)
					let scroll_to = line * height
					let scroll_sizey = GetSizeDeltaY(this._scroll)
					let content_sizey = GetSizeDeltaY(this._dgp_item)
					if (scroll_to > content_sizey - scroll_sizey) {
						scroll_to = content_sizey - scroll_sizey
					}
					SetLocalPositionY(this._dgp_item, scroll_to)
				}
				_model.show_type_id = null
			}
		}

		this.StartTimer = () => {
			this.CancelTimer()

			count_time_id_ = GlobalTimerQuest.AddPeriodQuest(() => {
				this.OnTimer()
			}, 0.5, -1)

			this.OnTimer()
		}

		this.OnTimer = () => {
			if (!data_) {
				return
			}
			let left_time = data_.left_time - local_TimeUtil.getServerTime()
			if (left_time < 0) {
				this.CancelTimer()
				this._lb_time.text = "00a00a00"
			} else {
				let str = local_TimeUtil.convertTime(left_time)
				// this._lb_time.text = string.gsub(str,":", "a")
				this._lb_time.text = str.replace(":", "a")
			}
		}

		this.CancelTimer = () => {
			if (count_time_id_) {
				GlobalTimerQuest.CancelQuest(count_time_id_)
				count_time_id_ = null
			}
		}

		this.ShowAnim = () => {
			if (_ac_item_) {
				_ac_item_.RestToBeginning()
				this.cansGroup.alpha = 0
				this.tween_id = SYTweenLite.to(this, this.cansGroup, SYTweenLite.UiAnimationType.ALPHA, 1, 0.5, () => {
					SYTweenLite.Stop(this.tween_id)
				})
			}
		}

	}

	public ReOpen_callback() {

		this.ShowAnim()
	}



	public DeleteMe() {

		this.Local_DeleteMe()
	}


	public GetComponents() {
		[
			this._scroll,
			this._dgp_item,
			this._Group2,
			this._Image1,
			this._Group1,
			this._Image2,
			this._lb_time,
		]
			= this.GetChildrenByNames([

				"_scroll",
				"_dgp_item",
				"_Group2",
				"_Image1",
				"_Group1",
				"_Image2",
				"_lb_time",
			])
	}
}

window["ShopVieView"]=ShopVieView
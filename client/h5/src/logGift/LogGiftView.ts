import { BaseItem1 } from "../common/BaseItem1"
import { CongratulationObtainView } from "../common/CongratulationObtainView"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { LogGiftItem } from "./LogGiftItem"

export class LogGiftView extends BaseItem1 {
	_img_001: Laya.Image
	_img_002: Laya.Image
	_img_004: Laya.Image
	_Image1: Laya.Image
	_Scroller1: Laya.Panel
	Content: Laya.VBox
	_gp_time: Laya.Box
	CreateRewardList
	CustomMehod
	InitEvent
	InitView
	LoadSucceed
	Scr_Scroller1
	SortRewardList
	UpdataRewardList
	_gp_item
	curr_sorting_order
	grade_item_list_
	timer_
	world_corners

	public constructor(parent?) {
		super(parent)


		let model = CustomActivityModel.GetInstance()
		let local_CustomActivityDefine = CustomActivityDefine
		let info_ = null
		let data_ = null
		let reward_list_ = []
		this.grade_item_list_ = []
		this.timer_ = null
		this.base_file = "logGift"
		this.layout_file = "LogGiftView"
		this.layer_value = Enum_UILayer.UI
		this.preload_client_config = {
			"ConfigCustomActivityView" : false
		}
		this.load_callback = () => {
			this._Scroller1.vScrollBar.visible = false
			this.LoadSucceed()
			this.InitEvent()
		}

		this.InitEvent = () => {
			let GetReward = (...new_args) => {
				let args = new_args
				if (info_.base_type == args[0] && info_.sub_type == args[1]) {
					let data = []
					let info = args[3]
					let reward = model.GetActReward(info_.base_type, info_.sub_type, info.form_type, info.reward)
					if (reward.length > 0) {
						let view = new CongratulationObtainView(reward, 10)
						view.Open()
					}
					this.UpdataRewardList()
				}
			}

			this.BindEvent(model, local_CustomActivityDefine.EVENT.ANSWER_TARGET, GetReward)
			let updata_view = (...new_args) => {
				let args = new_args
				if (args[0] == info_.base_type) {
					if (!data_) {
						this.InitView()
						return
					}
					data_ = model.GetActData(info_.base_type, info_.sub_type)
					this.UpdataRewardList()
				}
			}

			this.BindEvent(model, local_CustomActivityDefine.EVENT.UPDATE_VIEW, updata_view)
		}

		this.LoadSucceed = () => {
			let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "ConfigCustomActivityView", true)
			if (cfg && info_) {
				model.LoadCompontRes(this, cfg, "LogGiftView", info_.show_id)
			}
			model.CloseACTRed(info_.base_type, info_.sub_type, null, info_.show_id)
			//this.curr_sorting_order = this.AddCurrLayerSortingOrder(this.layer_value)
			//this.RegisterMask(this._gp_item)
			//this.world_corners = GetWorldCorners(this._gp_item)
			this.InitView()
		}

		this.InitView = () => {
			data_ = model.GetActData(info_.base_type, info_.sub_type)
			if (!data_ || !data_.reward_list) {
				return
			}
			this.UpdataRewardList()
			this.timer_ = model.LoadActTimer(this._gp_time, info_.etime,20, "#b3ff48", null, "#ffffff", "活动剩余时间：")
		}

		this.UpdataRewardList = () => {
			this.SortRewardList()
			this.CreateRewardList()
		}

		this.CreateRewardList = () => {

			if (reward_list_.length <= 0) {
				return
			}
			for (let index in reward_list_) {

				let item = this.grade_item_list_[index]
				if (!item) {
					item = new LogGiftItem(this.Content)
					//item.SetMaskRect(this.world_corners)
					item.Load()
					table.insert(this.grade_item_list_, item)
				}
				let callback = () => {
					item.visible = true
					item.setData(reward_list_[index], info_.base_type, info_.sub_type, this.curr_sorting_order)
				}

				item.ExcuteCallback(callback)

			}
			if (this.grade_item_list_.length > reward_list_.length) {
				let i = reward_list_.length
				do {
					let item = this.grade_item_list_[i]
					if (item) {
						item.visible = false
					}
					i = i + 1
				} while ((i < this.grade_item_list_.length))
			}
		}

		this.SortRewardList = () => {
			let sortFunc = (a?, b?) => {
				return a.grade < b.grade
			}

			table.sort(data_.reward_list, sortFunc)
			reward_list_ = []
			for (let index in data_.reward_list) {

				if (data_.reward_list[index].status < 2) {
					table.insert(reward_list_, data_.reward_list[index])
				}
			}
			if (reward_list_.length != data_.reward_list.length) {
				for (let index in data_.reward_list) {

					if (data_.reward_list[index].status >= 2) {
						table.insert(reward_list_, data_.reward_list[index])
					}
				}
			}
		}

		this.CustomMehod = (index?, info?) => {
			info_ = info
		}
	}

	public DeleteMe() {

		if (this.timer_) {
			this.timer_.DeleteMe()
			this.timer_ = null
		}
		if (this.grade_item_list_.length > 0) {
			for (let i in this.grade_item_list_) {

				this.grade_item_list_[i].DeleteMe()
			}
			this.grade_item_list_ = []
		}
		super.DeleteMe()
	}


	public GetComponents() {
		[
			this._img_001,
			this._img_002,
			this._img_004,
			this._Image1,
			this._Scroller1,
			this.Content,
			this._gp_time,
		]
			= this.GetChildrenByNames([

				"_img_001",
				"_img_002",
				"_img_004",
				"_Image1",
				"_Scroller1",
				"Content",
				"_gp_time",
			])
	}
}
window["LogGiftView"] = LogGiftView
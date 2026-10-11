import { BaseItem1 } from "../common/BaseItem1"
import { Config } from "../common/Config"
import { CongratulationObtainView } from "../common/CongratulationObtainView"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { WelfareModel } from "../commonModel/WelfareModel"
import { PlatformManager } from "../PlatformManager"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { AdvertisingItem } from "./AdvertisingItem"

export class AdvertisingMainView extends BaseItem1 {

	base_type
	sub_type
	act_data
	act_info

	loop_mgr:LoopScrowViewMgr
	model:CustomActivityModel
	timer_item


	public constructor(parent) {
		super(parent)
		this.base_file = "advertising"
		this.layout_file = "AdvertisingMainView"
		this.model = CustomActivityModel.GetInstance()
		this.is_delay_callback = false
		this.load_callback = () => {
			this.base_type = Config.PRELOAD_CLIENT_CONFIG.ConfigCustomActivity.ACT_ID.ADVERTISEMENT
			this.sub_type = 1
			this.LoadSuccess()
		}
	}

	public DeleteMe() {

		if (this.timer_item) {
			this.timer_item.DeleteMe()
			this.timer_item = null
		}
		if (this.loop_mgr) {
			this.loop_mgr.DeleteMe()
			this.loop_mgr = null
		}
		super.DeleteMe()
	}

	public LoadSuccess() {
		this._list_item.vScrollBarSkin = ""

		ResManager.GetInstance().SetOutsideImageSprite(this, this._img_title, GameResPath.GetIconJpg("advertising", "ui_fllb_bg"))

		this.InitEvents()
		this.UpdateItem()

		// if (WelfareModel.GetInstance().GetAdOpenState()) {
			// PlatformManager.GetInstance().SubmitStartG1()
		// }
	}

	public InitEvents() {

		let update_fun = (base_type?, sub_type?) => {
			if (this.use_delete_method) { return }
			if (base_type && sub_type && this.base_type == base_type && this.sub_type == sub_type) {
				this.UpdateItem()
			}
		}
		this.BindEvent(this.model, CustomActivityDefine.EVENT.UPDATE_VIEW, update_fun)

		this.BindEvent(this.model, CustomActivityDefine.EVENT.ANSWER_TARGET, (base_type?, sub_type?, result_data?, reward_data?) => {
			if (!this.act_info) {
				return
			}
			if (this.act_info.base_type == base_type && this.act_info.sub_type == sub_type) {
				let rewards = this.model.GetActReward(reward_data.base_type, reward_data.sub_type, reward_data.form_type, reward_data.reward)
				new CongratulationObtainView(rewards, 10).Open()
			}
		}
		)
	}

	public UpdateItem() {
		this.act_info = this.model.GetActInfo(this.base_type, this.sub_type)
		this.act_data = this.model.GetActData(this.base_type, this.sub_type)
		if (!this.act_info || !this.act_data) {
			return
		}

		this.SetTimer()
		this.InitContent()
	}

	public SetTimer() {
		if (!this.timer_item) {
			let count_timestamp = TimeUtil.GetFutureZeroStamp(1)
			let txt = "每日重置："
			let font_size = 22
			this.timer_item = this.model.LoadActTimer(this._box_time, count_timestamp, font_size, "#fe4848", null, "#663915", txt)
		}
	}

	public InitContent() {
		let reward_data = this.SortRewardList()
		if (!this.loop_mgr) {
			this.loop_mgr = new LoopScrowViewMgr()
			this.loop_mgr.SetData(this._list_item, AdvertisingItem, reward_data, LoopScrCon.Vertical, 1)
		} else {
			this.loop_mgr.replaceAll(reward_data)
		}
	}

	public SortRewardList() {
		if (!this.act_data || !this.act_info) {
			return
		}

		let reward_data: any[] = this.act_data.reward_list
		let sortFunc = (a?, b?) => {
			return a.grade - b.grade
		}
		reward_data.sort(sortFunc)

		for (let _tmpi in reward_data) {
			var data = reward_data[_tmpi]
			data.base_type = this.act_info.base_type
			data.sub_type = this.act_info.sub_type
		}
		return reward_data
	}



	_img_title: Laya.Image
	_box_time: Laya.Box
	_list_item: Laya.List
	public GetComponents() {
		[
			this._img_title,
			this._box_time,
			this._list_item,
		]
			= this.GetChildrenByNames([

				"_img_title",
				"_box_time",
				"_list_item",
			])
	}
}
window["AdvertisingMainView"] = AdvertisingMainView
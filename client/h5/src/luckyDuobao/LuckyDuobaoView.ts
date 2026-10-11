import { BaseItem1 } from "../common/BaseItem1"
import { table } from "../common/table"
import { Util } from "../util/Util"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { LuckyDuobaoItem } from "./LuckyDuobaoItem"

export class LuckyDuobaoView extends BaseItem1 {
	data
	info
	item_list
	model
	timer_item

	public constructor(parent?) {
		super(parent)
		this.base_file = "luckyDuobao"
		this.layout_file = "LuckyDuobaoView"
		this.model = CustomActivityModel.GetInstance()
		this.item_list = []

		this.load_callback = () => {
			ResManager.GetInstance().SetOutsideImageSprite(this, this.title_bg, "resource/game/luckyDuobao/other/uithdb_001.jpg")
			this.gradeScroll.vScrollBarSkin = ""

			this.InitEvent()
			this.InitView()
		}
	}

	public InitEvent() {
		this.BindEvent(this.model, CustomActivityDefine.EVENT.UPDATE_VIEW, (base_type?, sub_type?) => {
			if (this.use_delete_method) { return }
			if (this.info && this.info.base_type == base_type && this.info.sub_type == sub_type) {
				this.InitView()
			}
		})
	}

	public InitView() {
		if (!this.info) { return }
		let info = this.info
		let data = this.model.GetActData(info.base_type, info.sub_type)
		if (!data) { return }
		this.data = data
		if(this.timer_item){
			this.timer_item.DeleteMe()
			this.timer_item = null
		}
		this.timer_item = this.model.LoadActTimer(this._gp_time, info.etime, 24, "#ffef69", null, "#ffffff", "活动剩余时间：")
		this.RefGradeItem()
	}

	public RefGradeItem() {
		if (!this.data) { return }
		let list = this.data.reward_list
		if (!list || Util.IsTableEmpty(list)) {
			return
		}
		let sortFunc = (a?, b?) => {
			return a.grade < b.grade
		}
		table.sort(list, sortFunc)
		let _list = []
		let _list1 = []
		for (let k in list) {
			let v = list[k]
			if (v.status == 2) {
				table.insert(_list, v)
			} else {
				table.insert(_list1, v)
			}
		}
		list = _list1.concat(_list)
		for (let k in list) {
			let v = list[k]
			let item = this.item_list[k]
			if (!item) {
				item = new LuckyDuobaoItem(this.Content)
				item.Load()
				table.insert(this.item_list, item)
			}
			item.ExcuteCallback(() => {
				item.SetDate(this.data.base_type, this.data.sub_type, v)
			})
		}
	}

	public CustomMehod(index?, info?) {
		if (info) {
			this.info = info
		}
	}

	public DeleteMe() {
		if (this.item_list && !Util.IsTableEmpty(this.item_list)) {
			for (let k in this.item_list) {
				let v = this.item_list[k]
				v.DeleteMe()
			}
			this.item_list = []
		}
		if (this.timer_item) {
			this.timer_item.DeleteMe()
			this.timer_item = null
		}
		super.DeleteMe()
	}

	title_bg: Laya.Image
	_gp_time: Laya.Box
	rewardBg: Laya.Image
	gradeScroll: Laya.Panel
	Content: Laya.VBox
	public GetComponents() {
		[
			this.title_bg,
			this._gp_time,
			this.rewardBg,
			this.gradeScroll,
			this.Content,
		]
			= this.GetChildrenByNames([
				"title_bg",
				"_gp_time",
				"rewardBg",
				"gradeScroll",
				"Content",
			])
	}
}
window["LuckyDuobaoView"] = LuckyDuobaoView
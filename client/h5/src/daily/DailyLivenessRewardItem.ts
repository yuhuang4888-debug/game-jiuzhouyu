import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItem1 } from "../common/BaseItem1"
import { ResManager } from "../common/ResManager"
import { DailyModel } from "../commonModel/DailyModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { WeekCardModel } from "../commonModel/WeekCardModel"
import { AtlasUrl, Util } from "../util/Util"
import { DailyEvent } from "./DailyEvent"

export class DailyLivenessRewardItem extends BaseItem1 {
	item
	model
	needRefresh
	data
	public constructor(parent?) {
		super(parent)
		this.base_file = "daily"
		this.layout_file = "DailyLivenessRewardItem"
		this.model = DailyModel.GetInstance()

		this.load_callback = () => {
			this.week_img.visible = WeekCardModel.GetInstance().GetWeekCardData().is_activity == 1
			this.LoadSuccess()
			this.InitEvents()
		}

	}

	public DeleteMe() {
		if (this.item) {
			this.item.DeleteMe()
			this.item = null
		}
		super.DeleteMe()
	}

	public LoadSuccess() {


	}
	public InitEvents() {

		Util.AddClickEvent(this.click_bg, () => {
			let reward = this.model.GetLivenessDataByIndex(this.data.id)
			if (reward) {
				if (reward[1] == 1) {
					this.model.Fire(DailyEvent.DAILY_REQUEST_PROTO, 15705, "i", reward[0])
				}
			}
		}
			, this, true)
		if (this.needRefresh) {
			this.SetData(this.data)
		}
	}

	public SetData(data?) {
		this.data = data
		if (this.is_loaded && this.data) {
			this.ClearUIEffect(this.effect_conta)
			let config_activity_reward = ResManager.GetInstance().GetGameConfigFromCache(this, "config_activity_reward", false)
			let goods_list = this.model.GetBoxRewardListById(this.data.id, config_activity_reward)
			if (this.item) {
				this.item.DeleteMe()
				this.item = null
			}
			if (goods_list && goods_list[0]) {
				let [goods_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(goods_list[0][0], goods_list[0][1])
				this.item = new BaseAwardItem(this.conta)
				this.item.Load()
				this.item.SetItemSize(60, 60)
				this.item.SetData(goods_id, goods_list[0][2], null, null, null, true)
				this.click_bg.visible = this.data.state == 1
				this.got_tag.visible = this.data.state == 2
				this.can_got.visible = this.data.state == 1
				// this.item.SetGary(this.data.state == 0)
				// this.bg.skin = AtlasUrl("daily", this.data.state == 0 ? "ui_task_02" : "ui_task_04")
				if (this.data.state == 1) {
					//let basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(goods_id)
					//if (basic ) {
					//this.item.SetBoxEffect(basic.color)
					//}
					let call_fun = () => {
						// SetRotate(this.effect_conta, 0, 0, 45)
					}
					this.AddUIEffect("UI_1303c", this.effect_conta, null, 5, true, undefined, undefined, call_fun)
				}
				else if (this.data.state == 2 || this.data.state == 0) {
					//this.item.ClearBoxEffect()
					this.ClearUIEffect(this.effect_conta)
				}
			}
		} else {
			this.needRefresh = true
		}
	}


	bg: Laya.Image
	conta: Laya.Box
	got_tag: Laya.Image
	can_got: Laya.Image
	effect_conta: Laya.Box
	click_bg: Laya.Box
	week_img: Laya.Image
	public GetComponents() {
		[
			this.bg,
			this.conta,
			this.got_tag,
			this.can_got,
			this.effect_conta,
			this.click_bg,
			this.week_img
		]
			= this.GetChildrenByNames([

				"bg",
				"conta",
				"got_tag",
				"can_got",
				"effect_conta",
				"click_bg",
				"week_img"
			])
	}
}
window["DailyLivenessRewardItem"] = DailyLivenessRewardItem
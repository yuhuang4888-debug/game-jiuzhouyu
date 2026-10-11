import { BaseItem1 } from "../common/BaseItem1"
import { table } from "../common/table"
import { Util } from "../util/Util"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { CookieWrapper } from "../common/CookieWrapper"
import { CongratulationObtainView } from "../common/CongratulationObtainView"
import { LuckyDuoBaoLimitBuyItem } from "./LuckyDuoBaoLimitBuyItem"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"

export class LuckyDuoBaoLimitBuyView extends BaseItem1 {
	_timer
	act_define
	base_type
	data
	info
	item_list
	model
	sub_type

	public constructor(parent) {
		super(parent)
		this.base_file = "luckyDuobao"
		this.layout_file = "LuckyDuoBaoLimitBuyView"

		this.info = null
		this.data = null
		this.item_list = null
		this._timer = null

		this.model = CustomActivityModel.GetInstance()
		this.act_define = CustomActivityDefine

		this.load_callback = () => {
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_title, "resource/game/luckyDuobao/other/uixsqg_001.jpg")
			this.sv.vScrollBarSkin = ""
			this.LoadSuccess()
		}
	}

	public LoadSuccess() {
		if (this.info) {
			this.base_type = this.info.base_type
			this.sub_type = this.info.sub_type
			this.data = this.model.GetActData(this.base_type, this.sub_type)
			this.InitView()
			this.InitEvent()
			// if (! ACT_LUCKY_DUBAO_LIMIT_BUY ) {
			// 	ACT_LUCKY_DUBAO_LIMIT_BUY = true
			let cookie_value = CookieWrapper.Instance.GetCookie(CookieWrapper.ACT_LUCKY_DUBAO_LIMIT_BUY)
			if (!cookie_value) {
				// ACT_LUCKY_DUBAO_LIMIT_BUY = true
				CookieWrapper.Instance.SaveCookie(CookieWrapper.ACT_LUCKY_DUBAO_LIMIT_BUY, 1, true)
				this.model.SetActRedDot(this.base_type, this.sub_type)
				this.model.RefreshIconRed(this.base_type, this.sub_type)
			}
			// let mask = this.GetChild("sv/Viewport").GetComponent("Image")
			// this.RegisterMask(mask)
		}
	}

	public InitView() {
		this.RefreshView()
		//时间倒计时
		if (this._timer) {
			this._timer.DeleteMe()
			this._timer = null
		}
		this._timer = this.model.LoadActTimer(this._gp_time, this.info.etime, 24, "#ffef69", null, "#ffffff", "活动剩余时间：")
		this.model.CloseACTRed(this.base_type, this.sub_type)
	}

	public RefreshView() {
		if (!this.data) {
			return
		}

		//是否有额外奖励
		// let info_cond = this.model.GetActCondition(this.base_type, this.sub_type, "info")
		// let sp_bool = info_cond.recharge != null
		// this._gp_sp.visible = sp_bool 
		// if (sp_bool ) {
		// 	let sp_status = this.data.reward_list[4].status
		// 	this._btn_get.visible = sp_status>0 
		// 	this._lb_btn.text = sp_status == 1 && "领取" || "已领取"
		// }

		//创建礼包内容
		if (!this.item_list) {
			this.item_list = []
		}
		let gift_list = this.data.reward_list
		// table.sort(gift_list, (a?, b?) => {
		// 	return a.grade < b.grade
		// })

		table.sort(gift_list, (a?, b?) => {

			let cond_a = this.model.GetActCondition(this.base_type, this.sub_type, "data", a.grade)
			let cond_b = this.model.GetActCondition(this.base_type, this.sub_type, "data", b.grade)

			let value_a = 0
			let value_b = 0

			//vip>未购买完>档位>售空
			let limit_buy_a = (cond_a["personal_num"] || 0)
			let left_a = limit_buy_a - a.receive_times
			value_a += left_a > 0 ? (cond_a["vip_lv"] || 0) * 1000 : 0
			let a_buy = a.receive_times < limit_buy_a ? 1 : 0
			value_a += a_buy * 100
			value_a += (100 - a.grade)


			let limit_buy_b = (cond_b["personal_num"] || 0)
			let left_b = limit_buy_b - b.receive_times
			value_b += left_b > 0 ? (cond_b["vip_lv"] || 0) * 1000 : 0
			let b_buy = b.receive_times < limit_buy_b ? 1 : 0
			value_b += b_buy * 100
			value_b += (100 - b.grade)

			return value_a > value_b

		})


		for (let i = 0; i < gift_list.length; i++) {
			let gift_data = gift_list[i]
			let item = this.item_list[i]
			if (!item) {
				item = new LuckyDuoBaoLimitBuyItem(this.Content)
				item.Load()
				this.item_list[i] = item
			}
			item.SetData(gift_data, this.base_type, this.sub_type)
		}
	}

	public InitEvent() {
		if (!this.data) {
			return
		}
		let base_type = this.info.base_type
		let sub_type = this.info.sub_type
		let act_define = this.act_define

		Util.AddClickEvent(this._btn_get, () => {
			if (this.data && this.data.reward_list.length >= 4) {
				if (this.data.reward_list[4].status == 1) {
					this.model.Fire(act_define.EVENT.SCMD_REQUEST, 33105, base_type, sub_type, 4)
				}
			}
		}, this, true)

		let update_view = (...new_args) => {
			let arg = new_args
			if (arg[0] == base_type && arg[1] == sub_type) {
				this.data = this.model.GetActData(base_type, sub_type)
				if (!this.data) {
					return
				}
				this.RefreshView()
			}
		}
		this.BindEvent(this.model, act_define.EVENT.UPDATE_VIEW, update_view)

		this.BindEvent(this.model, act_define.EVENT.ANSWER_TARGET, (b_type?, s_type?, result_data?, reward_data?) => {
			if (base_type == b_type && sub_type == s_type) {
				this.data = this.model.GetActData(base_type, sub_type)
				if (!this.data) {
					return
				}
				//好像可以去掉
				//this:RefreshView()

				if (!reward_data) {
					return
				}
				let rewards = this.model.GetRewardsBySex(reward_data.reward)
				new CongratulationObtainView(rewards, 10).Open()
			}
		}
		)
	}

	public CustomMehod(index?, info?) {
		if (!info) {
			return
		}
		this.info = info
	}

	public DeleteMe() {
		if (this._timer) {
			this._timer.DeleteMe()
			this._timer = null
		}
		if (this.item_list && this.item_list.length > 0) {
			for (let i = 0; i < this.item_list.length; i++) {
				let item = this.item_list[i]
				item.DeleteMe()
			}
			this.item_list = []
		}

		super.DeleteMe()
	}

	_img_title: Laya.Image
	_gp_time: Laya.Box
	_gp_sp: Laya.Box
	_img_sp: Laya.Image
	_btn_get: Laya.Box
	_img_btn: Laya.Image
	_lb_btn: Laya.Label
	sv: Laya.Panel
	Content: Laya.VBox
	public GetComponents() {
		[
			this._img_title,
			this._gp_time,
			this._gp_sp,
			this._img_sp,
			this._btn_get,
			this._img_btn,
			this._lb_btn,
			this.sv,
			this.Content,
		]
			= this.GetChildrenByNames([
				"_img_title",
				"_gp_time",
				"_gp_sp",
				"_img_sp",
				"_btn_get",
				"_img_btn",
				"_lb_btn",
				"sv",
				"Content",
			])
	}
}
window["LuckyDuoBaoLimitBuyView"] = LuckyDuoBaoLimitBuyView
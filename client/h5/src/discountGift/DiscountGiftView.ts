import { BaseItem1 } from "../common/BaseItem1"
import { CongratulationObtainView } from "../common/CongratulationObtainView"
import { EventName } from "../common/EventName"
import { table } from "../common/table"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { Util } from "../util/Util"
import { DiscountGiftItem } from "./DiscountGiftItem"

export class DiscountGiftView extends BaseItem1 {
	Out_lb_btn
	_Viewport1
	_btn_get
	_content_item
	_gp_sp
	_gp_time
	_img_btn
	_img_sp
	_lb_btn
	_timer
	act_define
	base_type
	data
	info
	item_list
	mask_item_mat
	model: CustomActivityModel
	parent_mask
	item_conf
	sub_type


	public constructor(parent) {
		super(parent)

		this.base_file = "discountGift"
		this.layout_file = "DiscountGiftView"
		this.load_callback = () => {

			this.LoadSuccess()
		}

		this.info = null
		this.data = null
		this.item_list = null
		this._timer = null
		this.item_conf = null

		this.model = CustomActivityModel.GetInstance()
		this.act_define = CustomActivityDefine
	}

	public LoadSuccess() {

		if (this.info) {
			// this.RegisterMask(this._Viewport1)
			// this.parent_mask = GetWorldCorners(this._Viewport1)
			// this.mask_item_mat =  new Material(ShaderTools.GetShader("UI-Default_mask"))

			this.base_type = this.info.base_type
			this.sub_type = this.info.sub_type
			this.data = this.model.GetActData(this.base_type, this.sub_type)
			this.InitView()
			this.InitEvent()
			GlobalEventSystem.Fire(EventName.EXCHANGE_BASEWINDOW_BG_HEIGHT, 1200)
		}

	}

	public InitView() {


		this.RefreshView()

		//时间倒计时 
		// if (PlatformMgr.GetInstance().IsEyouIdnPlatform() ) {
		// 	this._timer = this.model.LoadActTimer(this._gp_time, this.info.etime, 16, null, null, "#995534"," Sisa waktu event       ")
		// }else{
		// 	this._timer = this.model.LoadActTimer(this._gp_time, this.info.etime, 22, null, "hh-mm-ss2", "#995534")
		// }
		this._timer = this.model.LoadActTimer(this._gp_time, this.info.etime, 22, "#90fa14", "hh-mm-ss2", "#c95b37")
		this.model.CloseACTRed(this.base_type, this.sub_type)
	}

	public RefreshView() {

		if (!this.data) {
			return
		}

		//是否有额外奖励
		let info_cond = this.model.GetActCondition(this.base_type, this.sub_type, "info")
		let sp_bool = info_cond.recharge != null
		this._gp_sp.visible = sp_bool
		if (sp_bool) {
			let sp_status = this.data.reward_list[4].status
			this._btn_get.visible = sp_status > 0
			this._lb_btn.text = sp_status == 1 && "领取" || "已领取"
		}

		//创建礼包内容
		if (!this.item_list) {
			this.item_list = []
		}
		let gift_list = this.data.reward_list
		//4档以上的要调间距
		// if (Util.TableSize(gift_list) >= 4) {
		// 	let layout = this._content_item.GetComponent("UnityEngine.UI.VerticalLayoutGroup")
		// 	layout.spacing = -10
		// }
		//各奖励的条件
		if (!this.item_conf) {
			this.item_conf = {}
			for (let i = 0; i < Util.TableSize(gift_list); i++) {
				let grade = gift_list[i].grade
				let cond = this.model.GetActCondition(this.base_type, this.sub_type, "data", grade)
				this.item_conf[grade] = cond
				// table.insert(this.reward_limit, Number(cond.limit_buy))
			}
		}
		table.sort(gift_list, (a?, b?) => {

			let cond_a = this.item_conf[a.grade]
			let cond_b = this.item_conf[b.grade]

			let value_a = 0
			let value_b = 0

			//vip>未购买完>档位>售空
			let limit_buy_a =(cond_a["limit_buy"] || 0)
			let left_a = limit_buy_a-a.receive_times 
			value_a += left_a>0?(cond_a["vip_lv"] || 0) * 1000:0
			let a_buy = a.receive_times < limit_buy_a ? 1 : 0
			value_a += a_buy * 100
			value_a += (100 - a.grade)


			let limit_buy_b =(cond_b["limit_buy"] || 0)
			let left_b = limit_buy_b-b.receive_times
			value_b += left_b>0?(cond_b["vip_lv"] || 0) * 1000:0
			let b_buy = b.receive_times < limit_buy_b ? 1 : 0
			value_b += b_buy * 100
			value_b += (100 - b.grade)

			return value_a > value_b

			// let b_buy = b.receive_times < (cond_b["limit_buy"] || 0) ? 1 : 0
			// if (a_buy != b_buy) {
			// 	if (a_buy == 1) {
			// 		return true
			// 	} else if (b_buy == 1) {
			// 		return false
			// 	}
			// } else {
			// 	return a.grade < b.grade
			// }
		})
		for (let i = 0; i < gift_list.length; i++) {
			let gift_data = gift_list[i]
			let item = this.item_list[i]
			if (!item) {
				item = new DiscountGiftItem(this._content_item)
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
		}

		if (this.item_list && this.item_list.length > 0) {
			for (let i = 0; i < this.item_list.length; i++) {
				var item = this.item_list[i]
				item.DeleteMe()
			}
			this.item_list = []
		}
		super.DeleteMe()
	}


	_Scroller1: Laya.Panel

	public GetComponents() {
		[
			this._gp_time,
			this._gp_sp,
			this._img_sp,
			this._btn_get,
			this._img_btn,
			this._lb_btn,
			this._Scroller1,
			this._content_item,
		]
			= this.GetChildrenByNames([

				"_gp_time",
				"_gp_sp",
				"_img_sp",
				"_btn_get",
				"_img_btn",
				"_lb_btn",
				"_Scroller1",
				"_content_item",
			])

		this._Scroller1.vScrollBarSkin = ""
	}
}
window["DiscountGiftView"] = DiscountGiftView
import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItem1 } from "../common/BaseItem1"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { Message } from "../sysInfo/SysInfoController"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { Color, Util } from "../util/Util"

export class LogGiftItem extends BaseItem1 {
	_Image1: Laya.Image
	_Image2: Laya.Image
	_lb_desc: Laya.Label
	_Scroller1: Laya.Panel
	Content: Laya.HBox
	_gp_btn: Laya.Box
	_btn_draw: Laya.Box
	_Image: Laya.Image
	labelDisplay: Laya.Label
	_img_red: Laya.Image
	_img_is_draw: Laya.Image
	Scr_Scroller1
	_gp_item
	base_type
	curr_sorting_order
	effect_color
	info
	reward_item_list
	sub_type
	fly_list
	public constructor(parent?) {
		super(parent)


		this.reward_item_list = [];
		this.base_file = "logGift"
		this.layout_file = "LogGiftItem"
		this.layer_value = Enum_UILayer.UI
		this.load_callback = () => {
			this._Scroller1.hScrollBar.visible = false
			this.LoadSuccess()
			this.InitEvent()
			ResManager.GetInstance().SetOutsideImageSprite(this, this._Image1, GameResPath.GetIcon("logGift", "uidlsl_005"))
		}
	}

	public InitEvent() {

		let DrawOnClick = () => {
			if (!this.base_type || !this.sub_type) { return }
			let act_info = CustomActivityModel.GetInstance().GetActInfo(this.base_type, this.sub_type)
			if (act_info && act_info.etime - TimeUtil.getServerTime() <= 0) {
				Message.show("活动已过期")
				return
			}
			if (this.info.status == 1) {
				CustomActivityModel.GetInstance().RequireGetAward(this.base_type, this.sub_type, this.info.grade)
				//飘字特效
				CustomActivityModel.GetInstance().ShowActFlyReward(this.fly_list, this._gp_btn)
			} else {
				let str = this.info.status == 0 ? "登录天数不满足" : (this.info.status == 2 && "已领取" || "奖励超时")
				Message.show(str)
			}
		}

		Util.AddClickEvent(this._gp_btn, DrawOnClick, this, true)
	}

	public LoadSuccess() {

		//this.curr_sorting_order = this.AddCurrLayerSortingOrder(this.layer_value)
		//this.RegisterMask(this._gp_item, 2)
		//this.Scr_Scroller1.parentScroll = this.parent_wnd.GetComponentInParent(typeof (UnityEngine.UI.ScrollRect))
	}

	public setData(info?, base_type?, sub_type?, sort_order?) {

		this.info = info
		if (!info) { return }
		let reward = CustomActivityModel.GetInstance().GetActReward(base_type, sub_type, info.form_type, info.reward)
		this.base_type = base_type
		this.sub_type = sub_type
		this.curr_sorting_order = sort_order
		let info_ = CustomActivityModel.GetInstance().GetActInfo(base_type, sub_type)

		if (info_ && info_.show_id >= 20) {
			ResManager.GetInstance().SetImageSprite(this, this._Image2, "logGift_asset", "uixydb_003", true)
			ResManager.GetInstance().SetImageSprite(this, this._Image, "common_asset", "com_rect_btn5")

			this.effect_color = "#c95b37"
		} else {
			this.effect_color = "#c95b37"
		}
		this.setDescLabel(info.name)
		this.setBtn(info.status)
		this.RefreshReward(reward)
		this.fly_list=CustomActivityModel.GetInstance().GetFlyRewardList(reward)
	}

	public setDescLabel(name?) {

		this._lb_desc.text = name
	}

	public setBtn(status?) {

		this._gp_btn.visible = (status < 2 && (true || (false)))
		this._img_red.visible = (status == 1 && (true || (false)))
		if (status < 2) {
			let img = this._Image
			let label = this.labelDisplay
			Util.SetImageGray(img, (status != 1 && (true) || (false)))
			label.strokeColor = status == 1 && this.effect_color || Color(153 / 255, 153 / 255, 153 / 255, 128 / 255)
		}
		this._img_is_draw.visible = (status >= 2 && (true || (false)))
	}

	public RefreshReward(rewards?) {


		if (!rewards) {
			return
		}
		if (this.reward_item_list.length > 0) {
			for (let index in this.reward_item_list) {
				let item = this.reward_item_list[index]
				if (item) {
					item.display_obj.visible = false
				}
			}
		}
		let count = 0
		for (let index in rewards) {

			let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(rewards[index][0], rewards[index][1])
			let basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
			if (!basic) {
				return
			}
			let goods_num = (basic && basic.max_overlap == 0 && (1) || (rewards[index][2]))
			let create_num = (basic && basic.max_overlap == 0 && (rewards[index][2]) || (1))
			let i = 0
			do {
				let item: BaseAwardItem = this.reward_item_list[count]
				if (!item) {
					item = new BaseAwardItem(this.Content)
					// item.SetCacheSortOrder(this.curr_sorting_order)
					// item.SetMaskId(2)
					// item.SetMaskRect(this.mask_corners)
					item.Load()
					item.SetItemSize(85, 85)
					table.insert(this.reward_item_list, item)
				}
				item.SetData(type_id, goods_num, lock, null, null, false)
				item.ExcuteCallback(() => {
					item.display_obj.visible = true

				}
				)
				count = count + 1
				i = i + 1
			} while ((i < create_num))
		}
		
	}

	public DeleteMe() {

		if (this.reward_item_list.length > 0) {
			for (let index in this.reward_item_list) {
				var item = this.reward_item_list[index]
				item.DeleteMe()
			}
			this.reward_item_list = []
		}
		super.DeleteMe()
	}



	public GetComponents() {
		[
			this._Image1,
			this._Image2,
			this._lb_desc,
			this._Scroller1,
			this.Content,
			this._gp_btn,
			this._btn_draw,
			this._Image,
			this.labelDisplay,
			this._img_red,
			this._img_is_draw,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_Image2",
				"_lb_desc",
				"_Scroller1",
				"Content",
				"_gp_btn",
				"_btn_draw",
				"_Image",
				"labelDisplay",
				"_img_red",
				"_img_is_draw",
			])
	}
}
window["LogGiftItem"] = LogGiftItem
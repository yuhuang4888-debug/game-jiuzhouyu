import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { Config } from "../common/Config"
import { Enum_UILayer } from "../common/LayerManager"
import { DailyModel } from "../commonModel/DailyModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { RoleManager } from "../commonModel/RoleManager"
import { ErlangParser } from "../util/ErlangParser"
import { Util } from "../util/Util"
import { DailyEvent } from "./DailyEvent"

export class DailyResFindItem extends BaseItemRenderer {
	public WIDTH = 693
	public HEIGT = 165

	cfg_finish
	cost_item
	item_list
	model

	public static width = 693
	public static height = 165
	public constructor() {
		super()
		this.cfg_finish = false;
		this.base_file = "daily"
		this.layout_file = "DailyResFindItem"
		this.model = DailyModel.GetInstance()
		this.item_list = []
		this.Load()
	}

	public load_callback() {
		this._Scroller1.hScrollBar.visible = false
		Util.SetImageGray(this._Image1, true)

		// this.RegisterMask(this.reward_scroll, 2)
		// let scroll_rect = this.parent_wnd.GetComponentInParent(typeof (UnityEngine.UI.ScrollRect))
		// if (scroll_rect && scroll_rect.transform) {
		//	 let scroll_group = scroll_rect.transform.Find("scroll_group")
		//	 if (scroll_group) {
		//		 this.parent_mask_corners = GetWorldCorners(scroll_group)
		//	 }
		// }

		this.cost_item = new BaseAwardItem(this.cost_icon)
		this.cost_item.Load()
		this.cost_item.SetItemSize(40, 40)
		this.cost_item.SetItembgVisible(false)

		this.InitEvents()
	}

	public InitEvents() {
		let btn_fun = () => {
			if (this.data) {
				if (this.data.act_sub == 132 && this.data.act_id == -1) {
					//if (this.model.resFindCheck[1] ) {
					//OutLineModel:GetInstance():Fire(OutLineModel.REQUEST_PROTO, 13204, "c", 2)
					//}else{
					//OutLineModel:GetInstance():Fire(OutLineModel.REQUEST_PROTO, 13204, "c", 1)
					//}
				} else {
					this.model.Fire(DailyEvent.OPEN_VIEW, "DailyResFindTipsView", this.data)
				}
			}
		}
		Util.AddClickEvent(this.findBtn, btn_fun, this, true)
	}

	public dataChanged() {
		if (super.dataChanged()){
			if (this.data && this.data.config_res_act) {
				let str = "(<font color='#663915'>可找回</font><font color='#0a853e'>" + this.data.lefttimes + "</font><font color='#663915'>次， 额外次数<font color='#0a853e'>+" + this.data.lefttimes_vip + "</font>)</font>"
				if (this.model.resFindCheck[1]) {
					str = "(<font color='#663915'>可找回</font><font color='#0a853e'>" + this.data.lefttimes + "</font><font color='#663915'>次)</font>"
					this.findBtn.visible = this.data.lefttimes > 0
					this.doneBtn.visible = this.data.lefttimes <= 0
				} else {
					this.findBtn.visible = (this.data.lefttimes + this.data.lefttimes_vip > 0)
					this.doneBtn.visible = (this.data.lefttimes + this.data.lefttimes_vip <= 0)
				}
				this.cost_icon.visible = !this.doneBtn.visible
				this.price.visible = !this.doneBtn.visible
				this.title.style.fontSize = 24
				this.title.width = 685
				this.title.style.color = "#d65e00"
				this.title.innerHTML = this.data.config_res_act.name + str
				this.SetReward()
				this.free_lb.visible = !this.doneBtn.visible && this.model.resFindCheck[1]
			}
		}
	}

	public SetReward() {
		if (this.data && this.data.config_res_act) {
			let reawd = JSON.parse(this.data.config_res_act.gold_goods)
			let money = JSON.parse(this.data.config_res_act.gold_per)
			if (this.model.resFindCheck[1]) {
				reawd = JSON.parse(this.data.config_res_act.coin_goods)
				money = JSON.parse(this.data.config_res_act.coin_per)
			}
			for (let _tmpi in this.item_list) {
				var item = this.item_list[_tmpi]
				item.SetVisible(false)
			}
			if (money) {
				let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(money[0][0], money[0][1])
				let color_str = "'#74665E'"
				if (this.model.resFindCheck[1]) {
					this.price_gp.visible = false
					this.free_lb.visible = true
				} else {
					this.price_gp.visible = true
					this.free_lb.visible = false
					this.cost_item.SetData(type_id)
				}
				this.price.style.fontSize = 22
				this.price.width = 94
				this.price.style.color = "#663915"
				this.price.innerHTML = Util.StrToHTML("<font color=" + color_str + ">" + money[0][2] + "</font>")
			}
			if (reawd) {
				if ((this.data.act_id == 610 && this.data.act_sub == 20) || (this.data.act_id == 610 && this.data.act_sub == 34)) {
					for (let _tmpi in reawd) {
						var vo = reawd[_tmpi]
						if (vo[0] == Config.PRELOAD_CLIENT_CONFIG.ConfigNotNormalGoods[5].type) {
							vo[2] = vo[2] * 1 + RoleManager.GetInstance().GetMainRoleVo().worldLvExp / 100
						}
					}
				}
				let item = null
				let i = 0
				do {
					item = this.item_list[i]
					if (!item) {
						item = new BaseAwardItem(this.Content)
						this.item_list[i] = item
						item.Load()
						item.SetItemSize(90, 90)
					}
					item.SetPosition(i, 0)
					item.SetVisible(true)
					let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(reawd[i][0], reawd[i][1])
					item.SetData(type_id, reawd[i][2])
					i = i + 1
				} while ((i < reawd.length))
				this.Content["onResize"]()
			}
		}
	}

	public DeleteMe() {
		if (this.item_list) {
			for (let _tmpi in this.item_list) {
				var item = this.item_list[_tmpi]
				item.DeleteMe()
				item = null
			}
			this.item_list = null
		}
		if (this.cost_item) {
			this.cost_item.DeleteMe()
			this.cost_item = null
		}
		super.DeleteMe()
	}
	bg: Laya.Image
	title: Laya.HTMLDivElement
	_Scroller1: Laya.Panel
	Content: Laya.HBox
	findBtn: Laya.Box
	_Image11: Laya.Image
	labelDisplay1: Laya.Label
	price_gp: Laya.Box
	icon: Laya.Image
	cost_icon: Laya.Box
	price: Laya.HTMLDivElement
	doneBtn: Laya.Box
	_Image1: Laya.Image
	labelDisplay: Laya.Label
	free_lb: Laya.Label
	public GetComponents() {
		[
			this.bg,
			this.title,
			this._Scroller1,
			this.Content,
			this.findBtn,
			this._Image11,
			this.labelDisplay1,
			this.price_gp,
			this.icon,
			this.cost_icon,
			this.price,
			this.doneBtn,
			this._Image1,
			this.labelDisplay,
			this.free_lb,
		]
			= this.GetChildrenByNames([

				"bg",
				"title",
				"_Scroller1",
				"Content",
				"findBtn",
				"_Image11",
				"labelDisplay1",
				"price_gp",
				"icon",
				"cost_icon",
				"price",
				"doneBtn",
				"_Image1",
				"labelDisplay",
				"free_lb",
			])
	}
}
window["DailyResFindItem"] = DailyResFindItem
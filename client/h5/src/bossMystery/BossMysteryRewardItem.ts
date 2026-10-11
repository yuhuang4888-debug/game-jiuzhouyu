import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { Util } from "../util/Util"
import { BossModel } from "../commonModel/BossModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { EquipmentItem } from "../common/EquipmentItem"

export class BossMysteryRewardItem extends BaseItemRenderer {
	WIDTH = 576
    HEIGT = 106
	
	goods_model
	item_list
	model
	parent_mask_corners
	parent_wnd
	reward_scroll

	public constructor() {
		super()
		this.base_file = "bossMystery"
		this.layout_file = "BossMysteryRewardItem"

		this.model = BossModel.GetInstance()
		this.goods_model = GoodsModel.GetInstance()

		this.load_callback = () => {
			this._Scroller1.hScrollBar.visible = false
			
			this.tips.style.fontSize = 20
			this.tips.style.color = "#663915"
			this.tips.style.wordWrap = false
			
			this.InitEvents()
		}
		this.Load()
	}

	// public load_callback() {
	// 	// this.RegisterMask(this.reward_scroll, 2)
	// 	// let scroll_rect = this.parent_wnd.GetComponentInParent(typeof (UnityEngine.UI.ScrollRect))
	// 	// if (scroll_rect && scroll_rect.transform) {
	// 	// 	let scroll_group = scroll_rect.transform.Find("scroll_group")
	// 	// 	if (scroll_group) {
	// 	// 		this.parent_mask_corners = GetWorldCorners(scroll_group)
	// 	// 	}
	// 	// }
	// 	this.InitEvents()
	// }

	public DeleteMe() {
		if (this.item_list) {
			for (let _tmpi in this.item_list) {
				var vo = this.item_list[_tmpi]
				vo.DeleteMe()
			}
			this.item_list = null
		}
		super.DeleteMe()
	}

	public InitEvents() {
		let success_fun = (reward_id?) => {
			if (this.data && this.data.reward_id == reward_id) {
				let list = this.model.GetMysteryRewardList(reward_id)
				if (list) {
					// let pos = UILocalToCanvasPoint(this.reward_pos_con, co.TableXY(0, 1), co.TableXY(0, 1))
					// GlobalEventSystem.Fire(EventName.REWARD_FLY, list, pos, null, null)
				}
			}
		}
		this.BindEvent(this.model, BossModel.GET_MYSTERY_BOSS_REWARD_SUCCESS, success_fun)

		let click_fun = () => {
			if (this.data) {
				this.model.Fire(BossModel.SCMD_REQUEST, 46038, this.data.reward_id)
			}
		}
		Util.AddClickEvent(this.getBtn, click_fun, this, true)
	}

	public dataChanged() {
		if (!super.dataChanged()) {
			return
		}

		let str = "击杀<font color='#0a953e'>" + this.data.kill_boss_num + "</font>个首领"
		this.tips.innerHTML = Util.StrToHTML(str)
		if (!this.item_list) {
			this.item_list = []
		}
		if (this.data.reward) {
			let item = null
			let len = this.data.reward.length
			let vo = null
			let i = 0
			do {
				vo = this.data.reward[i]
				item = this.item_list[i]
				if (!item) {
					item = new EquipmentItem(this.Content)
					//item.SetMaskId(2)
					//item.SetMaskRect(this.parent_mask_corners)
					item.Load()
					this.item_list[i] = item
					item.SetItemSize(90, 90)
				}
				item.visible = true
				let [type_id, lock] = this.goods_model.GetMappingTypeId(vo[0], vo[1])
				let goods_vo = this.goods_model.GetGoodsBasicByTypeId(type_id)
				if (goods_vo) {
					item.SetData(goods_vo.type_id, vo[2], lock)
				}
				i = i + 1
			} while ((i < len))
			if (len < this.item_list.length) {
				let i = len
				do {
					if (this.item_list[i]) {
						this.item_list[i].visible = false
					}
					i = i + 1
				} while ((i < this.item_list.length))
			}
		}
		if (this.model.mystery_boss_reward) {
			let has_get = false
			for (let _tmpi in this.model.mystery_boss_reward.had_reward_list) {
				var vo = this.model.mystery_boss_reward.had_reward_list[_tmpi]
				if (vo.stage == this.data.stage) {
					has_get = true
					break
				}
			}
			this.get_state.visible = has_get
			this.getBtn.visible = this.data.kill_boss_num <= this.model.mystery_boss_reward.kill_num && !has_get
			this.red_dot.visible = this.data.kill_boss_num <= this.model.mystery_boss_reward.kill_num && !has_get
			this.none.visible = this.data.kill_boss_num > this.model.mystery_boss_reward.kill_num && !has_get
		}
	}

	_img_bg: Laya.Image
	_Scroller1: Laya.Panel
	Content: Laya.HBox
	_Group1: Laya.Box
	_img_box: Laya.Image
	tips: Laya.HTMLDivElement
	_img_now_tips: Laya.Image
	getBtn: Laya.Box
	btn_img: Laya.Image
	get_label: Laya.Label
	red_dot: Laya.Image
	get_state: Laya.Image
	none: Laya.Image
	reward_pos_con: Laya.Box
	public GetComponents() {
		[
			this._img_bg,
			this._Scroller1,
			this.Content,
			this._Group1,
			this._img_box,
			this.tips,
			this._img_now_tips,
			this.getBtn,
			this.btn_img,
			this.get_label,
			this.red_dot,
			this.get_state,
			this.none,
			this.reward_pos_con,
		]
			= this.GetChildrenByNames([
				"_img_bg",
				"_Scroller1",
				"Content",
				"_Group1",
				"_img_box",
				"tips",
				"_img_now_tips",
				"getBtn",
				"btn_img",
				"get_label",
				"red_dot",
				"get_state",
				"none",
				"reward_pos_con",
			])
	}
}
window["BossMysteryRewardItem"] = BossMysteryRewardItem
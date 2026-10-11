import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { MonBookItem } from "./MonBookItem"

export class MonBookSubItem extends BaseItemRenderer {
	public WIDTH = 668
	public HEIGT = 220

	card_list_arr: Laya.List
	time_id
	played_tween = false
	delay_time_id

	// static Height = 231
	loop_mgr: LoopScrowViewMgr
	public constructor() {
		super()
		this.base_file = "monBook"
		this.layout_file = "MonBookSubItem"
		this.Load()
	}

	public createChildren(): void {
		super.createChildren()
	}

	public load_callback() {
		this._list_card_con.scrollBar.visible = false
	}



	protected dataChanged(): void {
		if (super.dataChanged()) {
			let list = []
			for (let vo of this.data.list) {
				list.push(vo)
			}
			if (!this.loop_mgr) {
				this.loop_mgr = new LoopScrowViewMgr()
				this.loop_mgr.SetData(this._list_card_con, MonBookItem, list, LoopScrCon.Horizontal, undefined)
			}else{
				this.loop_mgr.replaceAll(list)
			}
			

			if (!this.played_tween) {
				this.time_id = setTimeout(() => {
					Laya.Tween.to(this._gp_item, { x: 0 }, 250, Laya.Ease.cubicOut, Laya.Handler.create(this, () => {
						if (this._gp_item)
							Laya.Tween.clearAll(this._gp_item)
					}))
				}, (this.index) * 100)
				this.played_tween = true
			}

			if (this.delay_time_id) {
				clearTimeout(this.delay_time_id)
				this.delay_time_id = undefined
			}
			// if (FunctionOpenModel.getInstance().IsInShowingStory(FuncOpenId.MonBook) && this.data.group == 1) {
			// 	this._list_card_con.validateNow()
			// 	this.delay_time_id = setTimeout(() => {
			// 		// let index = 0
			// 		// let item
			// 		// for(let i = 0, length = this._list_card_con.numChildren; i < length ;i++){
			// 		// 	item = this._list_card_con.getChildAt(i) as MonBookItem
			// 		// 	if (item && item.data && item.data.id == 53020001){
			// 		// 		index = i
			// 		// 		break
			// 		// 	}
			// 		// }
			// 		let item = this._list_card_con.getChildAt(0) as MonBookItem
			// 		if (item) {
			// 			this._list_card_con.setChildIndex(item, 999)
			// 		}
			// 	}, this, (this.itemIndex) * 200)
			// }
		}
	}

	public DeleteMe() {
		if (this.time_id) {
			clearTimeout(this.time_id)
			this.time_id = undefined
		}
		if (this.delay_time_id) {
			clearTimeout(this.delay_time_id)
			this.delay_time_id = undefined
		}
		if (this._gp_item)
			Laya.Tween.clearAll(this._gp_item)
		this.card_list_arr = null
		if (this.loop_mgr) {
			this.loop_mgr.DeleteMe()
			this.loop_mgr = null
		}
		super.DeleteMe()
	}
	

	_gp_item: Laya.Box
	group1: Laya.Box
	_list_card_con: Laya.List
	public GetComponents() {
		[
			this._gp_item,
			this.group1,
			this._list_card_con,
		]
			= this.GetChildrenByNames([

				"_gp_item",
				"group1",
				"_list_card_con",
			])
	}
}
window["MonBookSubItem"] = MonBookSubItem
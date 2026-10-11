import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { GameResPath } from "../util/GameResPath"


export class BossFieldSoulShopItem extends BaseItemRenderer {

	public WIDTH = 602 //86 + 13
	public HEIGT = 258


	item_list
	data

	public constructor(parent) {
		super()

		this.base_file = "bossField"
		this.layout_file = "BossFieldSoulShopItem"

		this.load_callback = () => {
			this.LoadSuccess()
		}
		this.Load()
	}

	public LoadSuccess() {

	}
	public dataChanged() {
		if (super.dataChanged()) {

			let view_class = window["BossFieldSoulShopSubItem"]
			if(!view_class) return
			let data = this.data
			let length = data.length

			if (!this.item_list) {
				this.item_list = []
			}
			let i = 0
			do {
				let item = this.item_list[i]
				if (!item) {
					item = new view_class(this._hbox_con)
					item.Load()
					table.insert(this.item_list, item)
				}
				if (i < length) {
					item.SetData(data[i])
					item.SetVisible(true)
				} else {
					item.SetVisible(false)
				}

				i = i + 1
			} while ((i < 3)
			)
		}
	}

	public DeleteMe() {

		if (this.item_list && this.item_list.length > 0) {
			for (let _tmpi in this.item_list) {
				var obj = this.item_list[_tmpi]
				obj.DeleteMe()
			}
			this.item_list = null
		}

		super.DeleteMe()
	}

	_img_line: Laya.Image
	_hbox_con: Laya.HBox
	public GetComponents() {
		[
			this._img_line,
			this._hbox_con,
		]
			= this.GetChildrenByNames([

				"_img_line",
				"_hbox_con",
			])
	}
}
window["BossFieldSoulShopItem"] = BossFieldSoulShopItem
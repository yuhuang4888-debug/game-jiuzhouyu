import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { TopVipModel } from "../commonModel/TopVipModel"
import { GameResPath } from "../util/GameResPath"
import { TopVipShopItem } from "./TopVipShopItem"

export class TopVipRodItem extends BaseItemRenderer {
	rod_img: Laya.Image
	_Scroller1: Laya.Box
	item_gp: Laya.Image
	Content: Laya.HBox

	Scr_Scroller1
	item_list
	model

	public static width = 584
	public static height = 290
	public constructor(parent) {
		super()

		this.WIDTH = 584
		this.HEIGT = 230
		this.model = TopVipModel.GetInstance();
		this.base_file = "topVip"
		this.layout_file = "TopVipRodItem"
		// this.load_callback = () => {

		// 	this.LoadSuccess()
		// }
		this.Load()
	}

	public load_callback() {

		ResManager.GetInstance().SetOutsideImageSprite(this, this.rod_img, GameResPath.GetIconJpg("topVip", "uizzsd_002"))
	}

	public UpdataView() {
	}
	public dataChanged() {
		if(!super.dataChanged()) return
		let data = this.data
		let length = data.length
		if (!this.item_list) {
			this.item_list = []
		}
		let i = 0
		do {
			let item = this.item_list[i]
			if (!item) {
				item = new TopVipShopItem(this.Content)
				item.Load()
				table.insert(this.item_list, item)
			}
			if (i < length+1) {
				item.SetData(data[i])
				item.SetVisible(true)
			} else {
				item.SetVisible(false)
			}
			i = i + 1
		} while ((i < 3))
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



	public GetComponents() {
		[
			this.rod_img,
			this._Scroller1,
			this.item_gp,
			this.Content,
		]
			= this.GetChildrenByNames([

				"rod_img",
				"_Scroller1",
				"item_gp",
				"Content",
			])
	}
}
window["TopVipRodItem"]=TopVipRodItem
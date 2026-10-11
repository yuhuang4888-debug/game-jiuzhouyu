import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { EudaemonShopItem } from "./EudaemonShopItem"

export class EudaemonShopBigItem extends BaseItemRenderer {
	Content
	ScrollView
	itemArr
	item_list

	WIDTH = 580
	HEIGT = 233
	public constructor(parent) {
		super()
		this.base_file = "eudaemon"
		this.layout_file = "EudaemonShopBigItem"
		this.load_callback = () => {
			this.LoadSuccess()
		}
		this.Load()
	}

	public LoadSuccess() {
		// resource/game/eudaemon/texture/ui_kf_dgxs005a.png
		ResManager.GetInstance().SetOutsideImageSprite(this.base_item, this._img_line, GameResPath.GetIcon("eudaemon", "ui_kf_dgxs005a"))
	}

	protected dataChanged() {
		if (super.dataChanged()) {
			if (!this.item_list) {
				this.item_list = []
			}

			let v, item
			for (let i in this.data) {
				v = this.data[i]
				item = this.item_list[i]
				if (!item) {
					item = new EudaemonShopItem(this._box_item)
					item.Load()
					this.item_list[i] = item
					item.SetPosition(Number(i) * 195, 0)
				}
				item.SetData(v)
				item.SetVisible(true)
			}

			for(let i = this.data.length;i < this.item_list.length; i++){
				this.item_list[i].SetVisible(false)
			}
		}
	}

	public DeleteMe() {
		if(this.item_list){
			for(let item of this.item_list){
				item.DeleteMe()
			}
			this.item_list = false
		}

		if (this.itemArr) {
			this.itemArr.DeleteMe()
			this.itemArr = null
		}
		super.DeleteMe()
	}


	_img_line: Laya.Image
	_box_item: Laya.Box
	public GetComponents() {
		[
			this._img_line,
			this._box_item,
		]
			= this.GetChildrenByNames([

				"_img_line",
				"_box_item",
			])
	}
}
window["EudaemonShopBigItem"] = EudaemonShopBigItem
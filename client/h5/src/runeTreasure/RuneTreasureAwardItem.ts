import { BaseAwardItem } from "../common/BaseAwardItem";
import { BaseItemRenderer } from "../common/BaseItemRenderer";

export class  RuneTreasureAwardItem extends BaseItemRenderer {
	public conta
	private item: BaseAwardItem

	public WIDTH=115
	public HEIGT=115

	constructor() {
		super();
		this.base_file = "runeTreasure";
		this.layout_file = "RuneTreasureAwardItem";
		this.Load()
		// this.skinName = "resource/game/runeTreasure/exml/RuneTreasureAwardItemExml.exml"
	}

	public dataChanged(){
		if (super.dataChanged()) {
			if (this.data) {
				if(!this.item){
					this.item = new BaseAwardItem(this.conta)
					this.item.Load()
					this.item.SetItemSize(86, 86)
				}
				this.item.SetVisible(true)
				this.item.SetData(this.data.goods_id, this.data.goods_num)
			}
		}
	}

	public DeleteMe() {
		let self = this
		if (self.item) {
			self.item.DeleteMe()
			self.item = null
		}
		super.DeleteMe()
	}

	public GetComponents() {
		[
			this.conta,
		]
			= this.GetChildrenByNames([

				"conta",
			])
	}
}

window["RuneTreasureAwardItem"] = RuneTreasureAwardItem

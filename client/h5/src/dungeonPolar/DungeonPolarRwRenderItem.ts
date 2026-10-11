import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { GoodsModel } from "../commonModel/GoodsModel"


export class DungeonPolarRwRenderItem extends BaseItemRenderer {

	public WIDTH = 100
	public HEIGT = 100
	reward_item:BaseAwardItem
	public constructor(parent) {
		super()
		this.base_file = "dungeonPolar"
		this.layout_file = "DungeonPolarRwRenderItem"
		this.load_callback = () => {

		}
		this.Load()
	}

	public DeleteMe() {
		if(this.reward_item){
			this.reward_item.DeleteMe()
			this.reward_item=null
		}
		super.DeleteMe()
	}

	public dataChanged() {
		if (!super.dataChanged()) return

		if (! this.reward_item ) {
			this.reward_item =  new BaseAwardItem(this._box_item)
			this.reward_item.Load()
			this.reward_item.SetItemSize(100,100)
		}
		this.reward_item.ExcuteCallback(() => {
			this.reward_item.SetVisible(true)
				let [goods_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(this.data[0], this.data[1])
				let goodsBasic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(goods_id)
				if (goodsBasic ) {
					this.reward_item.SetData(goodsBasic.type_id, this.data[2])
				}
			})
	}


	_box_item: Laya.Box
	public GetComponents() {
		[
			this._box_item,
		]
			= this.GetChildrenByNames([

				"_box_item",
			])
	}
}
window["DungeonPolarRwRenderItem"] = DungeonPolarRwRenderItem
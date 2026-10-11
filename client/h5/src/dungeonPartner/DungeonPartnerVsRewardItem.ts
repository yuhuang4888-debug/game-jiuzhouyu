import { BaseItem1 } from "../common/BaseItem1"
import { EquipmentItem } from "../common/EquipmentItem"
import { DungeonPartnerModel } from "../commonModel/DungeonPartnerModel"
import { GoodsModel } from "../commonModel/GoodsModel"

export class DungeonPartnerVsRewardItem extends BaseItem1 {
	
	data
	item
	model
	need_refresh_data

	public constructor(parent) {
		super(parent)

		this.base_file = "dungeonPartner"
		this.layout_file = "DungeonPartnerVsRewardItem"
		this.model = DungeonPartnerModel.GetInstance()


		this.load_callback = () => {
			this.LoadSuccess()
		}
	}

	public LoadSuccess() {

		this.InitEvent()

		this.item = new EquipmentItem(this._box_item)
		this.item.Load()
		this.item.SetItemSize(84, 84)

		if (this.need_refresh_data) {
			this.UpdateItem()
			this.need_refresh_data = null
		}
	}

	public InitEvent() {


	}

	//{is_finish, goods_vo}
	public SetData(data?) {

		this.data = data
		if (this.is_loaded) {
			this.UpdateItem()
		} else {
			this.need_refresh_data = true
		}
	}

	public UpdateItem() {

		let v = this.data.goods_vo
		this._img_get.visible = this.data.is_finish
		let goods_model = GoodsModel.GetInstance()
		let [type_id, lock] = goods_model.GetMappingTypeId(v[0], v[1])
		let goods_vo = goods_model.GetGoodsBasicByTypeId(type_id)
		if (goods_vo) {
			this.item.SetData(goods_vo.type_id, v[2], lock)
		}
		if (this.data.size) {
			this.display_obj.width = this.display_obj.height = this.data.size
			this.item.SetItemSize(this.data.size, this.data.size)
		}
	}

	public DeleteMe() {
		if(this.item){
			this.item.DeleteMe()
			this.item = null
		}
		super.DeleteMe()
	}

	_box_item: Laya.Box
	_img_get: Laya.Image
	public GetComponents() {
		[
			this._box_item,
			this._img_get,
		]
			= this.GetChildrenByNames([

				"_box_item",
				"_img_get",
			])
	}
}
window["DungeonPartnerVsRewardItem"] = DungeonPartnerVsRewardItem
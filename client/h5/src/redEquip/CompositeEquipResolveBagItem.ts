import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { Util } from "../util/Util"
import { CompositeModel, CompositeEvent } from "../commonModel/CompositeModel"
import { EquipmentItem } from "../common/EquipmentItem"

export class CompositeEquipResolveBagItem extends BaseItemRenderer {
	WIDTH = 85
	HEIGT = 85

	equip_item
	evene_id
	model
	need_refresh = false

	public constructor() {
		super()
		this.base_file = "composite"
		this.layout_file = "CompositeEquipResolveBagItem"

		this.model = CompositeModel.GetInstance()

		this.load_callback = () => {
			this.InitEvent()
			if(this.need_refresh) {
				this.need_refresh = false
				this.dataChanged()
			}
		}
		this.Load()
	}

	public InitEvent() {
		let click_fun = () => {
			if (this.data) {
				this.model.select_resolve_goods_id = this.data.goods_id
				this.model.Fire(CompositeEvent.SELECT_EQUIP_RESOLVE_ITEM, this.data.goods_id, this.data)
			}
		}
		Util.AddClickEvent(this.clickBg, click_fun, this, true)

		this.BindEvent(this.model, CompositeEvent.SELECT_EQUIP_RESOLVE_ITEM, (goods_id?) => {
			if (this.data) {
				this.SetSelectBg(goods_id == this.data.goods_id)
			}
		})
	}

	public dataChanged() {
		if (!this.is_loaded){
			this.need_refresh = true
			return
		}
		if (this.data) {
			if (!this.equip_item) {
				this.equip_item = new EquipmentItem(this.equip_con)
				this.equip_item.SetItemSize(85, 85)
				this.equip_item.SetUseMask(1)
				this.equip_item.Load()
			}
			this.equip_item.SetData(this.data.type_id)
			this.equip_item.SetShowTips(false)
			this.SetSelectBg(this.model.select_resolve_goods_id == this.data.goods_id)
		}
	}

	public SetSelectBg(bool?) {
		this.selectBg.visible = bool
	}

	public DeleteMe() {
		if (this.equip_item) {
			this.equip_item.DeleteMe()
		}
		this.equip_item = null
		if (this.evene_id) {
			this.model.UnBind(this.evene_id)
			this.evene_id = null
		}
		super.DeleteMe()
	}

	equip_con: Laya.Box
	selectBg: Laya.Image
	clickBg: Laya.Box
	public GetComponents() {
		[
			this.equip_con,
			this.selectBg,
			this.clickBg,
		]
			= this.GetChildrenByNames([
				"equip_con",
				"selectBg",
				"clickBg",
			])
	}
}
window["CompositeEquipResolveBagItem"] = CompositeEquipResolveBagItem
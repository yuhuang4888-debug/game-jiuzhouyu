import { BaseItem1 } from "../common/BaseItem1";
import { EquipmentItem } from "../common/EquipmentItem";
import { UIToolTipMgr } from "../common/UIToolTipMgr";
import { GoodsModel } from "../commonModel/GoodsModel";
import { ColorUtil, ColorType } from "../util/ColorUtil";
import { Util } from "../util/Util";
export class DemonMaterialItem extends BaseItem1 {
	_gp_con: Laya.Box
	_gp_equip: Laya.Box
	_lb_count: Laya.Label


	equip_item: EquipmentItem
	need_refresh_need
	type_id

	public constructor(parent?) {
		super(parent)
		this.base_file = "demon"
		this.layout_file = "DemonMaterialItem"
		this.need_refresh_need = false
		this.load_callback = () => {
			this.LoadSuccess()
		}
	}

	public LoadSuccess() {
		this.equip_item = new EquipmentItem(this._gp_equip)
		this.equip_item.Load()
		this.equip_item.SetItemSize(64, 64)


		Util.AddClickEvent(this._gp_con, () => {
			if (this.type_id) {
				UIToolTipMgr.GetInstance().DefaultAppendTips(this.type_id, 1)
			}
		}, this, true)


		this.BindEvent(GoodsModel.GetInstance(), GoodsModel.UPDATE_GOODS_NUM, (goods_list?) => {
			if (this.use_delete_method) {
				return
			}
			for (let _tmpi in goods_list) {
				let vo = goods_list[_tmpi]
				if (vo.type_id == this.type_id) {
					this.UpdateCount()
					break
				}
			}
		})

		if (this.need_refresh_need) {
			this.need_refresh_need = false
			this.equip_item.SetData(this.type_id)
			this.UpdateCount()
		}
	}

	public SetData(type_id?) {
		this.type_id = type_id
		if (this.is_loaded) {
			this.equip_item.SetData(this.type_id)
			this.UpdateCount()
		} else {
			this.need_refresh_need = true
		}
	}

	public UpdateCount() {
		let count = GoodsModel.GetInstance().GetTypeGoodsNum(this.type_id)
		// this._lb_count.width=50
		// this._lb_count.color ="#0a953e" //count == 0 ? "#0a953e" : "#ffffff"
		this._lb_count.text = String(count)


	}
	public DeleteMe() {
		if (this.equip_item) {
			this.equip_item.DeleteMe()
			this.equip_item = null
		}
		super.DeleteMe()
	}

	public GetComponents() {
		[
			this._gp_con,
			this._gp_equip,
			this._lb_count,
		]
			= this.GetChildrenByNames([

				"_gp_con",
				"_gp_equip",
				"_lb_count",
			])
		// this._lb_count.style.fontSize=18
		// this._lb_count.style.color="#ffffff"
	}
}
window["DemonMaterialItem"]=DemonMaterialItem
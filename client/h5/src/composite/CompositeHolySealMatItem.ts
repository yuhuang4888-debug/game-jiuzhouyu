import { BaseItem1 } from "../common/BaseItem1"
import { Util } from "../util/Util"
import { GoodsModel } from "../commonModel/GoodsModel"
import { EquipmentItem } from "../common/EquipmentItem"

export class CompositeHolySealMatItem extends BaseItem1 {
	_equipment_item
	need_count
	need_refresh_data
	parm
	type_id

	public constructor(parent) {
		super(parent)
		this.base_file = "composite"
		this.layout_file = "CompositeHolySealMatItem"

		this.type_id = 0
		this.need_count = 0

		this.load_callback = () => {
			this.LoadSuccess()
		}
	}

	public LoadSuccess() {
		/*
		if (PlatformMgr.GetInstance().IsEyouPlatform()) {
			SetAnchoredPosition(this._lb_count, 0, 60)
		}
		*/
		this._lb_count.width = 77
		this._lb_count.style.fontSize = 20
		this._lb_count.style.color = "#ffffff"
		this._lb_count.style.stroke = 2
		this._lb_count.style.strokeColor = "#000000"

		this.InitEvent()

		if (this.need_refresh_data) {
			this.need_refresh_data = false
			this.UpdataView()
		}
	}

	public InitEvent() {
		this.BindEvent(GoodsModel.GetInstance(), GoodsModel.UPDATE_GOODS_NUM, (list?) => {
			if (this.use_delete_method) {
				return
			}
			for (let _tmpi in list) {
				var vo = list[_tmpi]
				if (this.type_id == vo.type_id) {
					this.UpdateCost()
				}
			}
		}
		)
	}

	public SetData(parm?) {
		this.parm = parm
		if (this.is_loaded) {
			this.UpdataView()
		} else {
			this.need_refresh_data = true
		}
	}

	public UpdataView() {
		if (this.parm) {
			if (this._equipment_item) {
				this._equipment_item.DeleteMe()
				this._equipment_item = null
			}
			this._equipment_item = new EquipmentItem(this.itemGp)
			this._equipment_item.Load()
			this._equipment_item.SetItemSize(80, 80)
			let vo = this.parm.regular_mat
			let type_id, lock
			[type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(0, vo.type_id)
			let goods_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
			this.type_id = type_id
			this.need_count = vo.count
			this.UpdateCost()
			this._equipment_item.SetData(type_id, 0, lock)
		}
	}

	public UpdateCost() {
		let my_count = GoodsModel.GetInstance().GetTypeGoodsNum(this.type_id)
		let color = my_count < this.need_count && "'#ff4f50'" || "'#ffffff'"
		this._lb_count.innerHTML = Util.HtmlColorTxt(my_count, color) + "/" + this.need_count
		this._lb_count.width = 77
		this._lb_count.height = 20
		this.gp_count.width = this._lb_count.contextWidth
		this.gp_count.height = this._lb_count.contextHeight
		this._equipment_item.SetIconGaryCom(my_count < this.need_count)
	}

	public DeleteMe() {
		if (this._equipment_item) {
			this._equipment_item.DeleteMe()
		}
		this._equipment_item = null
		super.DeleteMe()
	}

	itemGp: Laya.Box
	gp_count: Laya.HBox
	_lb_count: Laya.HTMLDivElement
	public GetComponents() {
		[
			this.itemGp,
			this.gp_count,
			this._lb_count,
		]
			= this.GetChildrenByNames([
				"itemGp",
				"gp_count",
				"_lb_count",
			])
	}
}
window["CompositeHolySealMatItem"] = CompositeHolySealMatItem
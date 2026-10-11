import { BaseItem1 } from "../common/BaseItem1"
import { EquipmentItem } from "../common/EquipmentItem"
import { GoodsModel } from "../commonModel/GoodsModel"
import { GuardModel } from "../commonModel/GuardModel"
import { Util } from "../util/Util"

export class CompositeGoodsMatItem extends BaseItem1 {
	InitEvent
	LoadSuccess
	SetData
	UpdataView
	UpdateCost
	_equipment_item
	need_count
	need_refresh_data
	parm
	type_id

	public constructor(parent?) {
		super(parent)
		this.base_file = "composite"
		this.layout_file = "CompositeGoodsMatItem"

		this.type_id = 0
		this.need_count = 0

		this.LoadSuccess = () => {
			this._lb_count.style.width = 80
			this._lb_count.style.fontSize = 18
			this._lb_count.style.color = "#ffffff"
			this._lb_count.style.stroke = 1
			this._lb_count.style.strokeColor = "#000000"

			this._equipment_item = new EquipmentItem(this.itemGp)
			this._equipment_item.Load()
			this._equipment_item.SetItemSize(80, 80)

			if (this.need_refresh_data) {
				this.need_refresh_data = false
				this.UpdataView()
			}
		}

		this.InitEvent = () => {
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

		this.SetData = (parm?) => {
			this.parm = parm
			if (this.is_loaded) {
				this.UpdataView()
			} else {
				this.need_refresh_data = true
			}
		}

		this.UpdataView = () => {
			if (this.parm) {
				if (!this._equipment_item) {
					//this._equipment_item.DeleteMe()
					this._equipment_item = new EquipmentItem(this.itemGp)
					this._equipment_item.Load()
					this._equipment_item.SetItemSize(84, 84)
				}
				let vo = this.parm.regular_mat
				let type_id, lock
				[type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(0, vo.type_id)
				//let goods_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
				this.type_id = type_id
				this.need_count = Number(vo.count)
				this.UpdateCost()
				this._equipment_item.SetData(type_id, 0, lock)
			}
		}

		this.UpdateCost = () => {
			let my_count = GoodsModel.GetInstance().GetTypeGoodsNum(this.type_id)
			if (GuardModel.GetInstance().goodsToType[this.type_id]) {
				my_count = my_count + GuardModel.GetInstance().GetActiveGuardNum(this.type_id)
			}
			let color = (my_count < this.need_count && ("'#ff4f50'") || ("'#ffffff'"))
			this._lb_count.innerHTML = Util.HtmlColorTxt(my_count, color) + "/" + this.need_count
			this._lb_count.width = 70
			this._lb_count.height = 20
			this.gp_count.width = this._lb_count.contextWidth
			this.gp_count.height = this._lb_count.contextHeight
			this._equipment_item.SetIconGaryCom(my_count < this.need_count)
		}

		this.load_callback = () => {
			this.LoadSuccess()
			this.InitEvent()
		}
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
window["CompositeGoodsMatItem"] = CompositeGoodsMatItem
import { BaseItem1 } from "../common/BaseItem1"
import { Util } from "../util/Util"
import { UnrealModel } from "../commonModel/UnrealModel"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { UnrealToolTips } from "../common/UnrealToolTips"
import { EquipmentItem } from "../common/EquipmentItem"
import { GoodsModel } from "../commonModel/GoodsModel"
import { CompositeModel } from "../commonModel/CompositeModel"

export class CompositeUnrealMatItem extends BaseItem1 {
	equip_info
	goods_id
	index
	need_refresh_data
	parm
	regular_data
	item

	public constructor(parent) {
		super(parent)
		this.base_file = "composite"
		this.layout_file = "CompositeUnrealMatItem"

		this.load_callback = () => {
			this._count.width = 80
			this._count.style.fontSize = 18
			this._count.style.color = "#ffffff"
			this._count.style.stroke = 1
			this._count.style.strokeColor = "#000000"

			this.LoadSuccess()
		}
	}

	public LoadSuccess() {
		this.item = new EquipmentItem(this._item)
		this.item.Load()
		this.item.SetItemSize(80, 80)
		this.item.SetClickCallBack(() => {
			if (this.parm.hole_id == 2) {
				if (this.equip_info && this.equip_info.type == UnrealModel.goods_type) {
					UIToolTipMgr.GetInstance().AppendUnrealTips(this.equip_info.type_id, this.equip_info, null, [3])
				}
			} else if (this.parm.hole_id == 1 && this.regular_data) {
				let type_id = Number(this.regular_data[1])
				if (type_id) {
					UIToolTipMgr.GetInstance().DefaultAppendTips(type_id)
				}
			}
		})

		if (this.need_refresh_data) {
			this.need_refresh_data = false
			this.UpdataView()
		}
		this.InitEvent()
	}

	public InitEvent() {
		Util.AddClickEvent(this._gp_con, () => {
			if (this.parm && this.parm["irregular_mat_cfg"]) {
				CompositeModel.GetInstance().Fire(CompositeModel.OPEN_CHOSE_UNREAL_VIEW, this.index, this.parm)
			}
		}, this, true)

		this.BindEvent(GoodsModel.GetInstance(), GoodsModel.UPDATE_GOODS_NUM, (list?) => {
			if (this.use_delete_method) {
				return
			}
			if (this.regular_data) {
				for (let _tmpi in list) {
					var vo = list[_tmpi]
					if (Number(this.regular_data[1]) == vo.type_id) {
						this.UpdateCost()
					}
				}
			}
		})
	}

	public SetData(goods_id?) {
		this.goods_id = goods_id
		if (this.is_loaded) {
			this.UpdataView()
		} else {
			this.need_refresh_data = true
		}
	}

	public SetIndex(index?) {
		this.index = index
	}

	public UpdataView() {
		if (this.parm) {
			this.regular_data = false
			if (this.parm.hole_id == 2) {
				if (this.goods_id && this.goods_id > 0) {
					this._gp_con.visible = false
					this.item.SetVisible(true)
					this.equip_info = GoodsModel.GetInstance().unrealbag_goods_dic[this.goods_id]
					if (this.equip_info) {
						this.item.SetData(this.equip_info.type_id)
					}
				} else {
					this.item.SetVisible(false)
					this._gp_con.visible = true
					this._img_lock.visible = false
					this._img_add.visible = true
				}
			} else if (this.parm.hole_id == 1) {
				this._gp_con.visible = false
				this.item.SetVisible(true)
				let data = this.parm.regular_id && this.parm.regular_id[0]
				if (data) {
					this.regular_data = data
					this.item.SetData(Number(data[1]))
				}
			} else if (this.parm.hole_id == 3) {
				this.item.SetVisible(false)
				this._img_add.visible = false
				this._gp_con.visible = true
				this._img_lock.visible = true
			}
			this.UpdateCost()
		} else {
			this.item.SetVisible(false)
			this._img_add.visible = false
			this._gp_con.visible = true
			this._img_lock.visible = true
			this._count.visible = false
		}
	}

	public SetParm(parm?) {
		this.parm = parm
		if (this.is_loaded) {
			this.UpdataView()
		} else {
			this.need_refresh_data = true
		}
	}

	public UpdateCost() {
		if (!this.regular_data) {
			this._count.visible = false
			return
		}
		this._count.visible = true
		let type_id = Number(this.regular_data[1])
		let need_count = Number(this.regular_data[2])
		let my_count = GoodsModel.GetInstance().GetTypeGoodsNum(type_id)
		let color = my_count < need_count && "'#ff4f50'" || "'#ffffff'"
		this._count.innerHTML = Util.HtmlColorTxt(my_count, color) + "/" + need_count
		this._count.width = 80
		this.gp_count.width = this._count.contextWidth
		this.item.SetIconGaryCom(my_count < need_count)
	}

	public DeleteMe() {
		if (this.item) {
			this.item.DeleteMe()
		}
		this.item = null

		super.DeleteMe()
	}

	_item: Laya.Box
	_gp_con: Laya.Box
	_Image1: Laya.Image
	_img_add: Laya.Image
	_img_lock: Laya.Image
	gp_count: Laya.HBox
	_count: Laya.HTMLDivElement
	public GetComponents() {
		[
			this._item,
			this._gp_con,
			this._Image1,
			this._img_add,
			this._img_lock,
			this.gp_count,
			this._count,
		]
			= this.GetChildrenByNames([

				"_item",
				"_gp_con",
				"_Image1",
				"_img_add",
				"_img_lock",
				"gp_count",
				"_count",
			])
	}
}
window["CompositeUnrealMatItem"] = CompositeUnrealMatItem
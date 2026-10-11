import { CompositeEquipItem } from "../redEquip/CompositeEquipItem"
import { table } from "../common/table"
import { Util } from "../util/Util"
import { GoodsModel } from "../commonModel/GoodsModel"
import { CompositeModel } from "../commonModel/CompositeModel"
import { StarEquipModel } from "../commonModel/StarEquipModel"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { EquipmentItem } from "../common/EquipmentItem"

export class StarEquipComItem extends CompositeEquipItem {
	public constructor(parent?) {
		super(parent)
	}

	public InitEvent() {
		let OnAddMatBtnClick = () => {
			if (this.mat_type == 2) {
				if (!this.goodsVo) {
					StarEquipModel.GetInstance().Fire(StarEquipModel.OPEN_VIEW, "StarEquipComSelectView", this.parms, this.index, null, this.mat_type)
				} else {
					UIToolTipMgr.GetInstance().AppendStarEquipToolTips(this.mat_id, this.goodsVo, null, [4])
				}
			} else if (this.mat_type == 1 && this.is_equip) {
				if (!this.goodsVo) {
					let mat_list = []
					for (let _tmpi in this.parms) {
						let vo = this.parms[_tmpi]
						table.insert(mat_list, vo[2])
					}
				} else {
					UIToolTipMgr.GetInstance().AppendEquipTips(this.mat_id, null, null, this.goodsVo, null, [5])
				}
			}
		}
		Util.AddClickEvent(this.gp_con, OnAddMatBtnClick, this, false)

		let OnGoodsChange = (list?) => {
			if (this.use_delete_method) {
				return
			}
			if (this.mat_type == 1 && !this.is_equip) {
				for (let _tmpi in list) {
					let vo = list[_tmpi]
					if (vo.type_id == this.mat_id) {
						this.SetMaterialData(this.parms)
					}
				}
			}
		}
		this.BindEvent(GoodsModel.GetInstance(), GoodsModel.UPDATE_GOODS_NUM, OnGoodsChange)
	}

	public InitMatData(mat_pos_type?, parms?) {
		this.mat_type = Number(mat_pos_type)
		if (parms) {
			this.mat_id = Number(parms[1])
		}
		this.parms = parms
		this.goodsVo = false
		if (this.is_loaded) {
			if (!this.item) {
				this.item = new EquipmentItem(this.item_group)
				this.item.Load()
			}
			this.item_group.visible = true
			//this.item.ClearItemEffect()
			if (mat_pos_type == 1) {
				this.lock_img.visible = false
				let goods_basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(this.mat_id)
				if (goods_basic && goods_basic.type == 10) {
					this.item.SetData(null)
					this.item.SetShowTips(false)
					this.add_img.visible = true
					this.num_label.visible = false
					this.is_equip = true
				} else {
					if (this.parms) {
						this.SetMaterialData(this.parms)
						this.add_img.visible = false
						this.num_label.visible = true
						this.is_equip = false
					}
				}
				//this.item_group.visible = true 
			} else if (mat_pos_type == 2) {
				this.lock_img.visible = false
				this.add_img.visible = true
				this.num_label.visible = false
				this.item.SetData(null)
				this.item.SetIconGaryCom(false)
				this.item.SetShowTips(false)
				//this.item_group.visible = true 
			} else {
				this.lock_img.visible = true
				this.add_img.visible = false
				this.num_label.visible = false
				this.item.SetData(null)
				this.item.SetIconGaryCom(false)
				this.item.SetShowTips(false)
				//this.item_group.visible = false 
			}
		} else {
			this.need_refresh = true
		}
	}
}

window["StarEquipComItem"] = StarEquipComItem
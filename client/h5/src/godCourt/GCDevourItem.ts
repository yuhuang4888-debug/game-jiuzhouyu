import { GCBagItem } from "./GCBagItem"
import { Alert, Alert_Type } from "../alert/Alert"
import { GodCourtModel } from "../commonModel/GodCourtModel"

export class GCDevourItem extends GCBagItem {
	WIDTH = 90
    HEIGT = 90
	need_refresh
	
	public constructor() {
		super()
		this.load_callback = () => {
			super.load_callback()
			//this.equipItem.SetClickCallBack(this.ClickFunc)
			this.BindEvent(this.model, GodCourtModel.UPDATE_DEVOUR_COLOR, () => {
				this.dataChanged()
			})

			this.BindEvent(this.model, GodCourtModel.DEVOUR_EFFECT, () => {
				if (!this.use_delete_method && this.data) {
					if (this.model.devourSelect[this.data.goods_id]) {
						//this:AddUIEffect("ui_achievementglow1", "Activity", this.effectGp)
					}
				}
			})

			if (this.need_refresh)
			{
				this.dataChanged()
				this.need_refresh = false
			}
		}
		this.Load()
	}


	public ClickFunc() {
		if (this.data && this.data.goods_id) {
			let goods_id = this.data.goods_id
			let newStatus = !this.model.devourSelect[goods_id]
			let SelectFunc = () => {
				this.model.SelectDevourGoods(goods_id, this.data.type_id, newStatus, this.data.goods_num)
				this.equipItem.SetSelect(newStatus)
			}

			if (newStatus && this.model.devourTips) {
				let wearEquip = this.model.GetEquipPosGoodsVo(this.data.godCourtId, this.data.subtype)
				if (!wearEquip || this.data.rating > wearEquip.rating) {
					let CheckFunc = (bool?) => {
						this.model.devourTips = !bool
					}
					Alert.Show("该装备对您目前阶段来说比较珍稀\n 是否确认分解?", Alert_Type.AlertTypeCheckBox, SelectFunc, null, null, null, null, null, CheckFunc)
					return
				}
			}
			SelectFunc()
		}
	}

	public dataChanged() {
		if (!this.is_loaded){
			this.need_refresh = true
			return
		}
		if (this.data) {
			super.dataChanged()
			this.equipItem.SetSelect(!(! this.model.devourSelect[this.data.goods_id]))
		}
	}
}
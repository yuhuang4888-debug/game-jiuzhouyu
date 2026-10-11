import { AStarEquipBagItem } from "./AStarEquipBagItem"
import { Alert, Alert_Type } from "../alert/Alert"
import { StarEquipModel } from "../commonModel/StarEquipModel"
import { ResManager } from "../common/ResManager"

export class StarEquipDevItem extends AStarEquipBagItem {
	WIDTH = 102
	HEIGT = 100
	need_refresh = false
	cfg_equip
	public constructor() {
		super()
		this.base_file = "starEquip"
		this.layout_file = "StarEquipDevItem"

		this.load_callback = () => {
			this.cfg_equip = ResManager.GetInstance().GetGameConfigFromCache(this.base_item, "config_constellation_equip", false)
			
			super.load_callback()
			this.BindEvent(this.model, StarEquipModel.ADD_DEVOUR_EFFECT, () => {
				//if (this.model.devourSelect[this.data.goods_id] ) {
				//this:AddUIEffect("ui_achievementglow1", this.effectGp)
				//}
			})

			this.BindEvent(this.model, StarEquipModel.UPDATE_DEVOUR_DROP, () => {
				this.dataChanged()
			})

			if (this.need_refresh) {
				this.need_refresh = false
				this.dataChanged()
			}
		}
		this.Load()
	}

	public ClickFunc() {
		if (this.data && this.data.goods_id) {
			let goods_id = this.data.goods_id
			let newStatus = !this.model.devourSelect[goods_id]
			let SelectFunc = () => {
				this.model.SelectDevourGoods(this.cfg_equip, goods_id, this.data.type_id, newStatus)
				this.equipItem.SetSelect(newStatus)
			}

			if (newStatus && this.model.devourTips) {
				let wearEquip = this.model.GetWearEquip(this.data.page, this.data.subtype)
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
		if (!this.data) {
			return
		}
		if (!this.is_loaded) {
			this.need_refresh = true
			return
		}
		super.dataChanged()
		this.equipItem.SetSelect(this.model.devourSelect[this.data.goods_id])
	}


	itemGp: Laya.Box
	banImg: Laya.Image
	upImg: Laya.Image
	effectGp: Laya.Box
	public GetComponents() {
		[
			this.itemGp,
			this.banImg,
			this.upImg,
			this.effectGp,
		]
			= this.GetChildrenByNames([
				"itemGp",
				"banImg",
				"upImg",
				"effectGp",
			])
	}
}
window["StarEquipDevItem"] = StarEquipDevItem
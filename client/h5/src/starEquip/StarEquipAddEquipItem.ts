import { AStarEquipBagItem } from "./AStarEquipBagItem"
import { Alert, Alert_Type } from "../alert/Alert"
import { ResManager } from "../common/ResManager"

export class StarEquipAddEquipItem extends AStarEquipBagItem {
	WIDTH = 125
	HEIGT = 125
	cfg_equip
	public constructor() {
		super()
		this.base_file = "starEquip"
		this.layout_file = "StarEquipBagItem"
	}

	public ClickFunc() {
		if (this.data && this.data.goods_id) {
			let goods_id = this.data.goods_id
			let length = this.data.addition_attrlist.length
			let state = !this.model.comExtraList[goods_id]
			let show = false
			let Cfg = this.cfg_equip
			if (state && length > 0) {
				if (Cfg && Cfg[this.data.type_id]) {
					let list = JSON.parse(Cfg[this.data.type_id].extra_attr)
					if (length > list.length) {
						show = true
					}
				}
			}
			let Func = (bool?) => {
				if (!bool) {
					this.model.SelectComGoods(goods_id, this.data.type_id, state, Cfg)
					let newStatus = this.model.comExtraList[goods_id]
					this.equipItem.SetSelect(newStatus)
				}
			}

			if (state && show) {
				Alert.Show("即将消耗的装备已经进化，请谨慎选择,\n是否仍然消耗", Alert_Type.Two, null, Func, "放入其它", "坚持放入")
			} else {
				Func()
			}
		}
	}

	public load_callback() {
		super.load_callback()
		this.cfg_equip = ResManager.GetInstance().GetGameConfigFromCache(this.base_item, "config_constellation_equip", false)
		//SetLocalScale(this.form, 1.2, 1.2)
	}

	public dataChanged() {
		//if (super.dataChanged() ) {
		super.dataChanged()
		this.equipItem.SetSelect(this.model.comExtraList[this.data.goods_id])
	}
}

window["StarEquipAddEquipItem"] = StarEquipAddEquipItem
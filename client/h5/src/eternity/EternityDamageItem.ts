import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { EquipmentItem } from "../common/EquipmentItem"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { EternityModel } from "../commonModel/EternityModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { ErlangParser } from "../util/ErlangParser"

export class EternityDamageItem extends BaseItemRenderer {
	_lb_name: Laya.Label
	_lb_ratio: Laya.Label
	_Image1: Laya.Image
	_Scroller1: Laya.Panel
	Content: Laya.HBox
	_gp_item
	_info
	_item_list
	_model

	public static width = 235
	public static height = 40
	WIDTH = 220
    HEIGT = 40
	
	public constructor(parent) {
		super()


		this.base_file = "eternity"
		this.layout_file = "EternityDamageItem"
		//this.layer_value = Enum_UILayer.Main
		this._model = EternityModel.GetInstance()
		this.load_callback = () => {
			this._Scroller1.hScrollBar.visible = false
			this._item_list = []
			//this.RegisterMask(this._gp_item,2)
		}
		this.Load()
	}

	public DeleteMe() {

		if (this._item_list) {
			for (let _tmpi in this._item_list) {
				var item = this._item_list[_tmpi]
				item.DeleteMe()
			}
			this._item_list = []
		}
		super.DeleteMe()
	}

	public dataChanged() {
		if (super.dataChanged()) {
			let data = this.data
			this._lb_name.text = data.player_name
			this._lb_ratio.text = data.ratio + "%"
			if (!this._info || this._info.rank != data.rank || this._info.monster_type_id != data.monster_type_id) {
				let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_sanctum_hurt_reward", false)
				let rdata = this._model.GetRankRewardData(cfg, data.mon_id, data.rank)
				if (rdata) {
					let rlist = JSON.parse(rdata.reward)
					let i = 0
					do {
						let vo = rlist[i]
						let item = this._item_list[i]
						if (!item) {
							item = new EquipmentItem(this.Content)
							// item.SetMaskId(2)
							// item.SetMaskRect(this.mask_corners)
							item.Load()
							item.SetItemSize(34, 34)
							table.insert(this._item_list, item)
						}
						item.ExcuteCallback(() => {
							let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(vo[0], vo[1])
							item.SetData(type_id, vo[2], lock)
							item.visible = true
						})
						i = i + 1
					} while ((i < rlist.length))
					i = rlist.length
					if (i < this._item_list.length) {
						do {
							this._item_list[i].ExcuteCallback(() => {
								this._item_list[i].visible = false
							})
							i = i + 1
						} while ((i < this._item_list.length))
					}
				}
			}
			this._info = this.data
		}

	}



	public GetComponents() {
		[
			this._lb_name,
			this._lb_ratio,
			this._Image1,
			this._Scroller1,
			this.Content,
		]
			= this.GetChildrenByNames([

				"_lb_name",
				"_lb_ratio",
				"_Image1",
				"_Scroller1",
				"Content",
			])
	}
}
window["EternityDamageItem"] = EternityDamageItem
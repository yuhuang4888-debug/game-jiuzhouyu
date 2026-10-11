import { BaseItem1 } from "../common/BaseItem1"
import { EquipmentItem } from "../common/EquipmentItem"
import { Enum_UILayer } from "../common/LayerManager"

export class LevelReward extends BaseItem1 {
	_gp_reward
	_img_draw
	_img_limit
	_img_mask
	cache_curr_sorting_order
	data
	is_delay_callback
	item
	needRefresh
	next_curr_sorting_order

	public constructor(parent?) {
		super(parent)


		this.base_file = "levelReward"
		this.layout_file = "LevelReward"
		this.layer_value = Enum_UILayer.UI
		//this.is_delay_callback = false
		this.load_callback = () => {


			// this.ReplaceUIShader(this._img_limit)
			// this.ReplaceUIShader(this._img_mask)
			// this.ReplaceUIShader(this._img_draw)

			if (this.needRefresh) {
				this.InitView(this.data[0], this.data[1], this.data[2], this.data[3])
			}
		}
	}

	public InitView(type_id?, num?, lock?, data?) {


		if (!this.item) {
			this.item = new EquipmentItem(this._gp_reward)
			// this.item.SetMaskId(2)
			// this.item.SetMaskRect(data.parent_mask)
			// this.item.SetMaskItemMaterial(data.mask_item_mat)

			// this.cache_curr_sorting_order = this.AddCurrLayerSortingOrder(this.layer_value)
			// this.item.SetCacheSortOrder(this.cache_curr_sorting_order)
			// this.next_curr_sorting_order = this.AddCurrLayerSortingOrder(this.layer_value)
			// this.CoverEffect(this._img_limit, "UI", this.next_curr_sorting_order)
			// this.CoverEffect(this._img_mask, "UI", this.next_curr_sorting_order)
			// this.CoverEffect(this._img_draw, "UI", this.next_curr_sorting_order)

			this.item.Load()
		}

		this.item.SetData(type_id, num, lock)

		this._img_limit.visible = false
		this._img_mask.visible = false
		this._img_draw.visible = false

		let vo = data.vo
		for (let i in data.limit_reward) {

			if (Number(data.limit_reward[i][1]) == type_id) {
				if (vo && vo.remain_num != null) {
					if (vo.remain_num == 0) {
						this._img_limit.visible = false
						this._img_mask.visible = true
						this._img_draw.visible = true
					} else {
						this._img_limit.visible = true
						this._img_mask.visible = false
						this._img_draw.visible = false
					}
				}
			}
		}
	}

	public SetData(type_id?, num?, lock?, data?) {


		if (type_id) {
			if (this.is_loaded) {
				this.InitView(type_id, num, lock, data)
			} else {
				this.needRefresh = true
				this.data = [type_id, num, lock, data]
			}
		}
	}

	public DeleteMe() {
		if (this.item) {
			this.item.DeleteMe()
			this.item = null
		}
		super.DeleteMe()
	}


	public GetComponents() {
		[
			this._gp_reward,
			this._img_mask,
			this._img_draw,
			this._img_limit,
		]
			= this.GetChildrenByNames([

				"_gp_reward",
				"_img_mask",
				"_img_draw",
				"_img_limit",
			])
	}
}
window["LevelReward"] = LevelReward
import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { Enum_UILayer } from "../common/LayerManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { MondaysAwardModel } from "../commonModel/MondaysAwardModel"
import { ErlangParser } from "../util/ErlangParser"
import { Util } from "../util/Util"

export class MondaysAwardChnageItem extends BaseItemRenderer {
	_gp
	_img_select
	_item
	_model
	cache_curr_sorting_order
	mask_id
	next_curr_sorting_order



	public WIDTH = 109

	public HEIGT = 95



	public constructor(parent) {
		super()
		this.base_file = "mondaysaward"
		this.layout_file = "MondaysAwardChnageItem"
		// this.layer_value = Enum_UILayer.Activity
		this.mask_id = 0
		this._model = MondaysAwardModel.GetInstance()
		this.Load()
	}

	public load_callback() {
		this.LoadSuccess()
		// this.ReplaceUIShader(this._img_select)
	}

	public LoadSuccess() {
		Util.AddClickEvent(this._gp, () => {
			this.select()
		}
			, this, true)
	}

	public DeleteMe() {
		if (this._item) {
			this._item.DeleteMe()
		}
		super.DeleteMe()
	}

	public dataChanged() {
		if (super.dataChanged()) {
			let config = this._model.pool_reward(this.data.choose_id)
			if (config) {
				let reward = JSON.parse(config.reward)[0]

				if (!this._item) {

					this._item = new BaseAwardItem(this._gp, null, "Activity")

					this._item.SetScale(0.75)

					this._item.SetShowTips(false)
					// this.cache_curr_sorting_order = this.AddCurrLayerSortingOrder(this.layer_value)
					// this._item.SetCacheSortOrder(this.cache_curr_sorting_order)
					// this.next_curr_sorting_order = this.AddCurrLayerSortingOrder(this.layer_value)
					// this.CoverEffect(this._img_select, "Activity", this.next_curr_sorting_order
					this._item.Load()
				}
				let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(reward[0], reward[1])
				this._item.SetData(type_id, reward[2])
				//this._item.ExcuteCallback(() => {
				//let curr_sorting_order = this.AddCurrLayerSortingOrder("Activity")
				//this:CoverEffect(this._img_select, "Activity", curr_sorting_order)
				//})
				let bool = this._model.rewardSelect(this.data.id, Number(this.data.choose_id))
				this._img_select.visible = bool
			}
		}
	}

	public select() {
		let config = this._model.getRewardIdById(this.data.id)
		let select = this._model.rewardSelect(this.data.id, Number(this.data.choose_id))
		if (config && this._model.selectNum >= config.num && !select) {
			return
		}
		let activeSelf = !this._img_select.visible
		this._img_select.visible = activeSelf
		this._model.changeSelectNum(activeSelf, this.data.id, Number(this.data.choose_id))
	}


	public GetComponents() {
		[
			this._gp,
			this._img_select,
		]
			= this.GetChildrenByNames([

				"_gp",
				"_img_select",
			])
	}
}
window["MondaysAwardChnageItem"] = MondaysAwardChnageItem
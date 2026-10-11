import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { GuildModel, GuildEvent } from "../commonModel/GuildModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"

export class GuildIdolRuneSelItem extends BaseItemRenderer {
	_item: BaseAwardItem
	_model
	curr_sorting_order
	is_set
	public WIDTH = 97
	public HEIGT = 97
	public constructor(parent) {
		super()
		this.is_set = false
		this.base_file = "guildidol"
		this.layout_file = "GuildIdolRuneSelItem"
		this._model = GuildModel.GetInstance()
		this.load_callback = () => {
			if (!this.is_set) {
				this.SetData()
				this.is_set = true
			}
		}
		this.Load()
	}

	public DeleteMe() {

		if (this._item) {
			this._item.DeleteMe()
			this._item = null
		}
		super.DeleteMe()
	}

	public dataChanged() {
		if (!super.dataChanged()) return

		if (this.is_loaded) {
			this.is_set = true
			this.SetData()
		} else {
			this.is_set = false
		}
	}

	SetData() {
		if (!this.data) return
		if (!this._item) {
			//this.curr_sorting_order = this.AddCurrLayerSortingOrder(this.layer_value)
			this._item = new BaseAwardItem(this._gp, null, "Activity")
			//this._item.SetCacheSortOrder(this.curr_sorting_order)
			//this._item.SetMaskId(1)
			this._item.Load()
			let onClick = () => {
				let RunePos = this._model.RunePos
				this._model.Fire(GuildEvent.REQUEST_PROTO, 40505, "hcl", RunePos.god_id, RunePos.pos, this.data.goods_id)
				this._model.RunePos = [] 
				GlobalEventSystem.Fire(EventName.CLOSE_VIEW, "GuildIdolRuneSelView")
			}
			this._item.SetClickCallBack(onClick)
		}
		this._item.SetData(this.data.type_id)
		this._red.visible = this.data.type_id > this._model.RunePos.type_id
	}

	_gp: Laya.Box
	_red: Laya.Image
	public GetComponents() {
		[
			this._gp,
			this._red,
		]
			= this.GetChildrenByNames([

				"_gp",
				"_red",
			])
	}
}
window["GuildIdolRuneSelItem"] = GuildIdolRuneSelItem
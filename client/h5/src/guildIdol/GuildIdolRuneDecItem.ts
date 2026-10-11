import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { Enum_UILayer } from "../common/LayerManager"
import { GuildModel, GuildEvent } from "../commonModel/GuildModel"
import { Util } from "../util/Util"

export class GuildIdolRuneDecItem extends BaseItemRenderer {
	_model
	item:BaseAwardItem
	public WIDTH = 97
	public HEIGT = 97

	layer_value: any
	is_set
	public constructor(parent) {
		super()
		this.is_set = false
		this.base_file = "guildidol"
		this.layout_file = "GuildIdolRuneDecItem"
		this.layer_value = Enum_UILayer.Activity
		this._model = GuildModel.GetInstance()
		//this._select = null

		this.load_callback = () => {
			this.LoadSuccess()

			if (!this.is_set) {
				this.is_set = true
				this.SetData()
			}
		}

		this.Load()
	}



	public LoadSuccess() {


		this.BindEvent(this._model, GuildEvent.IDOL_RUNE_DEC_CHANGE, () => {

			this.changeSelect()

		})



		Util.AddClickEvent(this._box, () => {

			this._model.setRuneDecList(this.data, this.data.color, !this._select.visible)

		}, this)

	}



	public DeleteMe() {


		if (this.item) {

			this.item.DeleteMe()

			this.item = null

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


		if (!this.item) {
			this.item = new BaseAwardItem(this._gp)
			this.item.Load()
			this.item.SetShowTips(false)

		}

		this.item.SetData(this.data.type_id)

		this.changeSelect()

	}

	public changeSelect(bool?) {


		if (!this.data) {

			return

		}
		this._select.visible = this._model.checkRuneDecSelect(this.data.goods_id)

	}



	_gp: Laya.Box
	_select: Laya.Image
	_box: Laya.Box
	public GetComponents() {
		[
			this._gp,
			this._select,
			this._box,
		]
			= this.GetChildrenByNames([

				"_gp",
				"_select",
				"_box",
			])
	}
}
window["GuildIdolRuneDecItem"] = GuildIdolRuneDecItem
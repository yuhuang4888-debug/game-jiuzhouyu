import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { Util } from "../util/Util"
import { chcModel } from "../commonModel/chcModel"
import { EquipmentItem } from "../common/EquipmentItem"

export class chcEvoSelectItem extends BaseItemRenderer {
	_item
	_model
	WIDTH = 128
	HEIGT = 128
	need_refresh = false

	public constructor() {
		super()
		this.base_file = "chc"
		this.layout_file = "chcEvoSelectItem"
		this._model = chcModel.GetInstance()
		this.load_callback = () => {
			this.LoadSuccess()
			if (this.need_refresh) {
				this.need_refresh = false
				this.dataChanged()
			}
		}
		this.Load()
	}

	public LoadSuccess() {
		this._item = new EquipmentItem(this._gp_item)
		this._item.Load()
		this._item.SetUseMask(true)
		this._item.SetItemSize(108, 108)
		this._item.SetShowTips(false)

		Util.AddClickEvent(this.gp_com, () => {
			this._model.Fire(chcModel.SELECT_MTRL, this.data.vo, !this.data._is_select)
		}, this)

		this.BindEvent(this._model, chcModel.SELECT_MTRL_SS, (vo?) => {
			if(!this.data){
				return
			}
			if (this.data.vo != vo) {
				return
			}
			let data = this.data
			data._is_select = !data._is_select
			this._img_select.visible = data._is_select
		})
	}

	public DeleteMe() {
		this.Clear()
		super.DeleteMe()
	}

	public Clear() {
		if (this._item) {
			this._item.DeleteMe()
			this._item = null
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
		let data = this.data
		this._item.SetData(data.vo.type_id)
		this._item.SetStarEquipStar(data.vo.color, data.vo.star)
		this._img_select.visible = data._is_select
	}

	gp_com: Laya.Box
	_gp_item: Laya.Box
	_img_select: Laya.Image
	public GetComponents() {
		[
			this.gp_com,
			this._gp_item,
			this._img_select,
		]
			= this.GetChildrenByNames([
				"gp_com",
				"_gp_item",
				"_img_select",
			])
	}
}
window["chcEvoSelectItem"] = chcEvoSelectItem
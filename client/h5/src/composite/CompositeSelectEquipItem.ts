import { Util } from "../util/Util"
import { CompositeModel } from "../commonModel/CompositeModel"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { EquipmentItem } from "../common/EquipmentItem"
import { RuneModel } from "../commonModel/RuneModel"

export class CompositeSelectEquipItem extends BaseItemRenderer {
	WIDTH = 85
	HEIGT = 85
	_item
	_model
	_status
	click_callback

	public constructor() {
		super()
		this._status = 0
		this.base_file = "composite"
		this.layout_file = "CompositeSelectEquipItem"
		this._model = CompositeModel.GetInstance()

		this.load_callback = () => {
			this.InitEvent()
		}
		this.Load()
	}

	public InitEvent() {
		Util.AddClickEvent(this.item_group, () => {
			//if (this.click_callback ) { 
			// this.click_callback(this)
			//}
			this._model.Fire(CompositeModel.SELECT_GOD_EQUIP, this)
		}, this, true)
	}

	public SetClickCallback(click_callback?) {
		this.click_callback = click_callback
	}

	public DeleteMe() {
		if (this._item) {
			this._item.DeleteMe()
			this._item = null
		}

		super.DeleteMe()
	}

	public dataChanged() {
		if(!super.dataChanged())
			return
		let data = this.data
		if (!data) {
			return
		}

		if (!this._item) {
			this._item = new EquipmentItem(this.item_group)
			/*
			let loadsuccess = this._item.LoadSuccess
			this._item.LoadSuccess = () => {
				loadsuccess(this._item)
				this._item.click_group.GetComponent("Image").raycastTarget = false
				this._item.item_bg.GetComponent("Image").raycastTarget = false
			}
			this._item.SetUseMask(true)
			*/
			this._item.Load()
			this._item.SetItemSize(85, 85)
			this._item.SetShowTips(false)
		}
		this._item.SetData(data.type_id, 1, data.bind)
		this._item.SetStrengthen(data.level)
		this._img_wear.visible = RuneModel.GetInstance().IsRuneDress(data)
	}


item_group:Laya.Box
_img_wear:Laya.Image
public GetComponents() {
[
this.item_group,
this._img_wear,
]
 = this.GetChildrenByNames([

"item_group",
"_img_wear",
])
}
}
 window["CompositeSelectEquipItem"]= CompositeSelectEquipItem
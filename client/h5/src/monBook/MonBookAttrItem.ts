import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { MonBookModel } from "../commonModel/MonBookModel"

export class MonBookAttrItem extends BaseItemRenderer {

	need_refresh_data
	model
	vo

	public WIDTH= 293
	public HEIGT= 37
	public constructor(parent) {
		super()
		this.base_file = "monBook"
		this.layout_file = "MonBookAttrItem"
		this.need_refresh_data = false
		this.model = MonBookModel.GetInstance()
		this.load_callback = ()=>{

		}
		this.Load()
	}


	public dataChanged(){ 
	
		if (super.dataChanged() ) {
			this.UpdateView()
		}
	}



	private UpdateView() {
		if (this.data) {
			this._lb_attr_name.text = this.data.name
			this._lb_attr_value.text = this.data.now_value
			if (this.data.add_value) {
				this._lb_attr_add_value.visible = true
				this._img_next.visible = true
				this._lb_attr_add_value.text = this.data.add_value
			}
			else {
				this._lb_attr_add_value.visible = false
				this._img_next.visible = false
			}

		}
	}

	_Group1: Laya.Box
	_lb_attr_name: Laya.Label
	_lb_attr_value: Laya.Label
	_img_next: Laya.Image
	_lb_attr_add_value: Laya.Label
	public GetComponents() {
		[
			this._Group1,
			this._lb_attr_name,
			this._lb_attr_value,
			this._img_next,
			this._lb_attr_add_value,
		]
			= this.GetChildrenByNames([

				"_Group1",
				"_lb_attr_name",
				"_lb_attr_value",
				"_img_next",
				"_lb_attr_add_value",
			])
	}
}
window["MonBookAttrItem"] = MonBookAttrItem
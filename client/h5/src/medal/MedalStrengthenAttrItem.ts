import { BaseItem1 } from "../common/BaseItem1"
import { WordManager } from "../common/WordManager"
import { MedalModel } from "../commonModel/MedalModel"

export class MedalStrengthenAttrItem extends BaseItem1 {
InitEvent
LoadSuccess
_Group1
_gp_up
_img_up
_lb_name
_lb_next
_lb_now
initView
setData

public constructor(parent?){
super(parent) 
	
	
	this.base_file = "medal"
	this.layout_file = "MedalStrengthenAttrItem"
	let _model = MedalModel.GetInstance()
	let _data = null
	let need_refresh = null
	this.load_callback = () => {
		
		this.InitEvent()
		this.LoadSuccess()
	}
	
	this.InitEvent = () => {
		
	}
	
	this.setData = ( data?) => {
		_data = data
		if (! this.is_loaded ) {
			need_refresh = true
		}else{
			this.initView()
		}
	}
	
	this.LoadSuccess = () => {
		if (need_refresh ) {
			this.initView()
		}
	}
	
	this.initView = () => {
		if (! _data ) {
			return
		}
		let attr_id = _data["attr_id"]
		let now_value = _data["now"]
		let next_value = _data["next"]
		this._lb_name.text = WordManager.GetProperties(attr_id) + ":"
		this._lb_now.text = WordManager.ConvertToPercentValue(attr_id, now_value)
		this._gp_up.visible = next_value !=null  
		if (this._gp_up.visible ) {
			this._lb_next.text = WordManager.ConvertToPercentValue(attr_id, next_value)
		}
		// LayoutRebuilder(this._Group1)
	}
	
	// this.LocalDeleteMe = () => {
	// 	super.DeleteMe( )
	// }
}

	public GetComponents() {
		[
			this._Group1,
			this._lb_name,
			this._lb_now,
			this._gp_up,
			this._img_up,
			this._lb_next,
		]
			= this.GetChildrenByNames([

				"_Group1",
				"_lb_name",
				"_lb_now",
				"_gp_up",
				"_img_up",
				"_lb_next",
			])
	}
}
window["MedalStrengthenAttrItem"] = MedalStrengthenAttrItem
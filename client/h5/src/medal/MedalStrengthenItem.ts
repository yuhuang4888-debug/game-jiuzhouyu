import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItem1 } from "../common/BaseItem1"
import { GoodsModel } from "../commonModel/GoodsModel"
import { MedalModel } from "../commonModel/MedalModel"
import { Util } from "../util/Util"

export class MedalStrengthenItem extends BaseItem1 {
InitEvent
LoadSuccess
_data
_gp_click
_gp_item
_img_select
_lb_count
HashCode
initView
setData
setSelect
setTouch

public constructor(parent?){
super(parent) 
	
	
	this.base_file = "medal"
	this.layout_file = "MedalStrengthenItem"
	this.HashCode = 0
	let _model = MedalModel.GetInstance()
	let need_refresh = false
	let item = null
	let _goods_model = GoodsModel.GetInstance()
	let count = 0
	let c_selet = null
	this.load_callback = () => {
		
		this.InitEvent()
		this.LoadSuccess()
	}
	
	this.InitEvent = () => {
		Util.AddClickEvent(this._gp_click,() => {
				if (count <= 0 ) {
					return
				}
				this.setSelect(true)
			}
			, this)
	}
	
	this.setData = ( data ?, hashCode?) => {
		this._data = data
		this.HashCode = hashCode
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
		if ((c_selet!=null) ) {
			this.setSelect(c_selet)
			c_selet = null
		}
	}
	
	this.initView = () => {
		if (! item ) {
			item =  new BaseAwardItem(this._gp_item)
			item.SetScale(0.75)
			item.Load()
		}
		count = _goods_model.GetTypeGoodsNum(this._data.goods_id)
		item.SetData(this._data.goods_id)
		this._lb_count.text = count + ""
		//this._img_select.touchEnabled = false
		//this._img_select.touchChildren = false
		this.setTouch()
	}
	
	this.setTouch = () => {
		//item.touchEnabled = count <= 0 || this._img_select.visible
		//item.touchChildren = count <= 0 || this._img_select.visible
		//item:SetShowTips(count <= 0 || this._img_select.visible)
		this._gp_click.visible = !(count <= 0 || this._img_select.visible )
	}
	
	this.setSelect = ( bool?) => {
		if ((! this.is_loaded ) ) { 
			c_selet =  bool
			return
		}
		
		if (bool != this._img_select.visible ) {
			this._img_select.visible = bool 
			this.setTouch()
		}
		if (_model.medalStrSelItem && _model.medalStrSelItem.hashCode != this.HashCode ) {
			_model.medalStrSelItem.setSelect(false)
			_model.medalStrSelItem = this
		}
		if (! _model.medalStrSelItem ) {
			_model.medalStrSelItem = this
		}
	}
	
	
}


	public GetComponents() {
		[
			this._gp_item,
			this._lb_count,
			this._img_select,
			this._gp_click,
		]
			= this.GetChildrenByNames([

				"_gp_item",
				"_lb_count",
				"_img_select",
				"_gp_click",
			])
	}
}
window["MedalStrengthenItem"] = MedalStrengthenItem
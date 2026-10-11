import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { CustomHeadItem } from "../common/CustomHeadItem"
import { ResManager } from "../common/ResManager"
import { kfSingleRankModel } from "../commonModel/kfSingleRankModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Enum_ColorUtil_Light, ColorUtil } from "../util/ColorUtil"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { Util } from "../util/Util"

export class kfSRMainItem extends BaseItemRenderer {
_model
head_item
loop_scro_mgr
public WIDTH = 410
public HEIGT = 241

public static width = 410
public static height = 241

public constructor(parent){
super() 
	
	this.base_file = "kfSingleRank"
	this.layout_file = "kfSRMainItem"
	this._model = kfSingleRankModel.GetInstance()
	// this.touchEnabled = false
	this.Load()
}

public load_callback(){ 
	
	
	ResManager.GetInstance().SetImageSpriteTrans(this, this._img_003, GameResPath.GetIcon("kfSingleRank","uikfdr_003"))
	ResManager.GetInstance().SetImageSpriteTrans(this, this._img_select, GameResPath.GetIcon("kfSingleRank","uikfdr_005"))
	this.head_item =  new CustomHeadItem(this._head)
	this.head_item.Load()
	//优化点击
	// Util.AddClickEvent(this._Group3,() => {
	// 	let item_click_func = LuaClickListener.Get(this.gameObject).onClick
	// 	if (item_click_func ) {
	// 		item_click_func()
	// 	}
	// }, null, null, null, null, null, null, this.sound_effect)


	
	Util.AddClickEvent(this._Group3,() => {
		// if (kfSRMainItem.loop_scro_mgr ) {
		// 	kfSRMainItem.loop_scro_mgr.SelectItem(this)
		// }
	},this)
}

public DeleteMe(){ 
	 
//	kfSRMainItem.loop_scro_mgr = null
	super.DeleteMe()
}

public dataChanged(){ 
	if(!super.dataChanged())return
	let data = this.data
	if (data.role_id ) {
		let id = RoleManager.GetInstance().GetMainRoleId()
		let is_this = id == data.role_id
		let color = (is_this && ( "#FFE400" ) || ( "#00fa64" ) )
		this._lb_name.color =color//ColorUtil.TryParseHtmlString(color)
		this._lb_name.text = "s" + data.server_num + "." + data.role_name
		this._lb_time.text = (data.go_time && ( TimeUtil.timeConversionWithMillisecond(data.go_time, "mm:ss.ms") ) || ( "暂无" ) )
		this.head_item.SetRoleVoData(data, null, null, data.lv)
	}
	this._lb_layer.text = `第${data.level}层`
	this._gp_data.visible = data.role_id?true:false
	this._gp_empty.visible = ! data.role_id 
	//LayoutRebuilder(this._Group1)

	if (this.selected ) {
		this._img_select.visible = true 
	}else{
		this._img_select.visible = false 
	}
}


_Group2:Laya.Box
_img_003:Laya.Image
_img_select:Laya.Image
_lb_bc:Laya.Image
_lb_layer:Laya.Label
_gp_empty:Laya.Box
_Image3:Laya.Image
_gp_data:Laya.Box
_head:Laya.Box
_lb_name:Laya.Label
_Label1:Laya.Label
_lb_time:Laya.Label
_Group3:Laya.Box
public GetComponents() {
[
this._Group2,
this._img_003,
this._img_select,
this._lb_bc,
this._lb_layer,
this._gp_empty,
this._Image3,
this._gp_data,
this._head,
this._lb_name,
this._Label1,
this._lb_time,
this._Group3,
]
 = this.GetChildrenByNames([

"_Group2",
"_img_003",
"_img_select",
"_lb_bc",
"_lb_layer",
"_gp_empty",
"_Image3",
"_gp_data",
"_head",
"_lb_name",
"_Label1",
"_lb_time",
"_Group3",
])
}
}
 window["kfSRMainItem"]= kfSRMainItem
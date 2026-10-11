import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { kfSingleRankModel } from "../commonModel/kfSingleRankModel"
import { RoleManager } from "../commonModel/RoleManager"
import { ColorUtil } from "../util/ColorUtil"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"

export class kfSRMainRankItem extends BaseItemRenderer {

_model
public WIDTH = 266
public HEIGT = 45

public constructor(parent){
super() 
	
	this.base_file = "kfSingleRank"
	this.layout_file = "kfSRMainRankItem"
	this._model = kfSingleRankModel.GetInstance()
	this.Load()
}

public load_callback(){ 
	
	
	//ResManager.GetInstance().SetOutsideImageSprite(this, this._Image1, GameResPath.GetIcon("kfSingleRank","uikfdr_020"), true)
}

public DeleteMe(){ 
	
	super.DeleteMe()
}

public dataChanged(){ 
	if(!super.dataChanged())return
	let data = this.data
	let is_this = RoleManager.GetInstance().GetMainRoleId() == data.role_id
	let color
	if (is_this ) {
		color = "#0a953e"
	}else{
		color = "#663915"
	}
	this._lb_layer.color = ColorUtil.TryParseHtmlString(color)
	this._lb_name.color = ColorUtil.TryParseHtmlString(color)
	if (is_this ) {
		this._lb_time.color = ColorUtil.TryParseHtmlString("#0a953e")
	} else if (data.go_time ) {
		this._lb_time.color = ColorUtil.TryParseHtmlString("#0a953e")
	}else{
		this._lb_time.color = ColorUtil.TryParseHtmlString("#663915")
	}
	this._lb_layer.text = data.level
	this._lb_name.text = (data.role_id && ( "s" + data.server_num + "." + data.role_name ) || ( "虚位以待" ) )
	this._lb_time.text = (data.go_time && ( TimeUtil.timeConversionWithMillisecond(data.go_time, "mm:ss.ms") ) || ( "暂无" ) )
}

_Image1:Laya.Image
_lb_layer:Laya.Label
_lb_name:Laya.Label
_lb_time:Laya.Label
public GetComponents() {
[
this._Image1,
this._lb_layer,
this._lb_name,
this._lb_time,
]
 = this.GetChildrenByNames([

"_Image1",
"_lb_layer",
"_lb_name",
"_lb_time",
])
}
}
 window["kfSRMainRankItem"]= kfSRMainRankItem
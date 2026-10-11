import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { kfSingleRankModel } from "../commonModel/kfSingleRankModel"
import { RoleManager } from "../commonModel/RoleManager"
import { ColorUtil } from "../util/ColorUtil"
import { TimeUtil } from "../util/TimeUtil"

export class kfSRRankItem extends BaseItemRenderer {

_model
color
// public static width = 613
// public static height = 71

public WIDTH = 613
public HEIGT = 71

public constructor(parent){
super() 
	
	this.base_file = "kfSingleRank"
	this.layout_file = "kfSRRankItem"
	this._model = kfSingleRankModel.GetInstance()
	this.Load()
}

public load_callback(){ 
	
	
}

public DeleteMe(){ 
	 super.DeleteMe()
}
public dataChanged(){ 
	if(!super.dataChanged())return
	let data = this.data
	let is_this = RoleManager.GetInstance().GetMainRoleId() == data.role_id
	// [ts2lua]lua中0和空字符串也是true，此处is_this需要确认
	let color = (is_this && ( "#0a953e" ) || ( "#5F4A3A" ) )
	this._lb_layer.color = ColorUtil.TryParseHtmlString(color)
	this._lb_name.color = ColorUtil.TryParseHtmlString(color)
	this._lb_time.color = ColorUtil.TryParseHtmlString(color)
	this._lb_time_self.color=ColorUtil.TryParseHtmlString(color)
	this._lb_layer.text = data.level
	this._lb_name.text = (data.role_id && ( "s" + data.server_num + "." + data.role_name ) || ( "虚位以待" ) )
	this._lb_time.text = (data.go_time && ( TimeUtil.timeConversionWithMillisecond(data.go_time, "mm:ss.ms") ) || ( "暂无" ) )

	let ldata = this._model.GetPlayerLevelData(data.level)
	this._lb_time_self.text = ldata ? TimeUtil.timeConvertMS(ldata.go_time, "mm:ss.xx") : "暂无"
}

_Image1:Laya.Image
_lb_layer:Laya.Label
_lb_name:Laya.Label
_lb_time:Laya.Label
_lb_time_self:Laya.Label
public GetComponents() {
[
this._Image1,
this._lb_layer,
this._lb_name,
this._lb_time,
this._lb_time_self,
]
 = this.GetChildrenByNames([

"_Image1",
"_lb_layer",
"_lb_name",
"_lb_time",
"_lb_time_self",
])
}
}
 window["kfSRRankItem"]= kfSRRankItem
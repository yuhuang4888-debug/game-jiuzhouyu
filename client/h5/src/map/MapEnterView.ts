import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { AreaMapView } from "./AreaMapView"
import { WorldMapView } from "./WorldMapView"
import  "./AreaMapView";
import  "./WorldMapView";
import { MapModel } from "../commonModel/MapModel";

export class MapEnterView extends BaseWindowComponent {
bg_list
destroy_imm
money_list
need_close_between_field_scene
tabStrList
titleStr
viewClassList
window_load_back
public constructor(){
super() 
	
	
	this.dependent_res = ["map"]
	this.destroy_imm = true
	this.need_close_between_field_scene = true
	this.tabStrList = [{label:"场景", icon_up_source:"map_json.uicdtb01_02_png", icon_down_source:"map_json.uicdtb01_01_png"}, {label:"世界", icon_up_source:"map_json.uicdtb01_05_png", icon_down_source:"map_json.uicdtb01_04_png"}]
	this.viewClassList = ["AreaMapView", "WorldMapView"]
	this.titleStr = "map.uidu_001"
	this.bg_list = ["uidu_0132.jpg"]
	this.money_list = [2, 1, 0]
	this.window_load_back = () => {
		this.InitMyEvent()
	}
	
	
}

public InitMyEvent(){ 
	this.BindEvent(MapModel.GetInstance(), MapModel.CLOSEMAPENTVIEW,() => {
		this.Close();
	}
)
}
public Open(...new_args){ 
	
	let param = new_args
	let index = param[1]
	if (index ) {
		this.SetDefaultIndex(index)
	}
	super.Open()
}


}

window["MapEnterView"]=MapEnterView
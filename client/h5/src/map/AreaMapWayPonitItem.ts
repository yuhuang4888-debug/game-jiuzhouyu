import { BaseItem1 } from "../common/BaseItem1"
import { MapModel } from "../commonModel/MapModel"

export class AreaMapWayPonitItem extends BaseItem1 {
public end_pos: Laya.Image;
data
dest_point

model
needRefresh
point

localX
localY
localVisible

public constructor(parent?){
super(parent) 
	
	
	this.base_file = "map"
	this.layout_file = "AreaMapWayPonitItem"
	this.model = MapModel.GetInstance()
	this.load_callback = () => {
		
		this.LoadSuccess()
		this.InitEvents()
	}
	
	
}

public LoadSuccess(){ 
	this.SetX(this.localX)
	this.SetY(this.localY)
	this.SetVisible(this.localVisible)
}
public InitEvents(){ 
	
	if (this.needRefresh ) {
		this.SetData(this.data)
	}
}

public SetX(x?){
	this.localX=x
	if(this.is_loaded){
		this.display_obj.x=x;
	}
}

public SetY(y?){
	this.localY=y
	if(this.is_loaded){
		this.display_obj.y=y;
	}
}

public SetVisible(v?){
	this.localVisible=v
	if(this.is_loaded){
		this.display_obj.visible=v;
	}
}


public SetData(data?){ 
	
	this.data = data
	if (this.is_loaded && this.data ) {
		this.end_pos.visible = false 
		this.point.visible = true 
		if (this.dest_point ) {
			this.SetDestPoint()
			this.dest_point = null
		}
	}else{
		this.needRefresh = true
	}
}

public SetDestPoint(){ 
	
	if (this.is_loaded ) {
		this.end_pos.visible = true 
		this.point.visible = false 
	}else{
		this.dest_point = true
	}
}
	public GetComponents() {
		[
			this.end_pos,
			this.point,
		]
			= this.GetChildrenByNames([

				"end_pos",
				"point",
			])
	}

}
// }_pos
// 	= this.GetChildGameObjects({
// 			"point",
// 			"end_pos"
// 		})
// 	this.point,
// 	this.end_pos
// 	= this.GetChildTransforms({
// 			"point",
// 			"end_pos"
// 		})
// 	this.point,
// 	this.end_pos
// 	= this.GetChildImages({
// 			"point",
// 			"end_pos"
// 		})
// end_pos:Laya.Image

window["AreaMapWayPonitItem"] = AreaMapWayPonitItem
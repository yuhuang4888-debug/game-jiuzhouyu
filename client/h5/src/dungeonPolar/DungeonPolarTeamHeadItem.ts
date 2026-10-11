import { BaseItem1 } from "../common/BaseItem1"
import { CustomHeadItem } from "../common/CustomHeadItem"
import { ResManager } from "../common/ResManager"
import { TeamModel } from "../commonModel/TeamModel"

export class DungeonPolarTeamHeadItem extends BaseItem1 {
head:CustomHeadItem
need_refresh_data
vo

public constructor(parent?){
super(parent) 
	
	this.base_file = "dungeonPolar"
	this.layout_file = "DungeonPolarTeamHeadItem"
	this.load_callback = () => {
		
		this.LoadSuccess()
	}
}

public LoadSuccess(){ 
	
	if (this.need_refresh_data ) {
		this.UpdateView()
		this.need_refresh_data = false
	}
}

public SetData(vo?){ 
	
	this.vo = vo
	if (this.is_loaded ) {
		this.UpdateView()
	}else{
		this.need_refresh_data = true
	}
}

public UpdateView(){ 
	
	let bool = this.vo.none ? true : false
	this._gp_head.visible = ! bool 
	this._img_add.visible = bool 
	this._img_join.visible = false 
	if (! bool ) {
		if (! this.head ) {
			this.head =  new CustomHeadItem(this._gp_head)
			this.head.Load()
		}
		this.head.SetRoleVoData(this.vo)
		this._img_join.visible = this.vo.join_value > 0 
		if (this._img_join.visible ) {
			ResManager.GetInstance().SetImageSprite(this, this._img_join,"dungeonPolar_asset", TeamModel.GetInstance().joinImage(TeamModel.POLAR_DUN, this.vo.join_value))
		}
	}
}

public DeleteMe(){ 
	
	if (this.head ) {
		this.head.DeleteMe()
		this.head = null
	}
	super.DeleteMe()
}


_gp_head:Laya.Box
_img_add:Laya.Image
_img_join:Laya.Image
public GetComponents() {
[
this._gp_head,
this._img_add,
this._img_join,
]
 = this.GetChildrenByNames([

"_gp_head",
"_img_add",
"_img_join",
])
}
}
 window["DungeonPolarTeamHeadItem"]= DungeonPolarTeamHeadItem
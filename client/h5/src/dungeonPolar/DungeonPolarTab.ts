import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { BaseDungeonModel } from "../commonModel/BaseDungeonModel"
import { TeamModel } from "../commonModel/TeamModel"

export class DungeonPolarTab extends BaseItemRenderer {
_model

public WIDTH: number = 176
public HEIGT: number = 169
public constructor(parent){
super() 
	
	this.base_file = "dungeonPolar"
	this.layout_file = "DungeonPolarTab"
	this._model = BaseDungeonModel.GetInstance()
	this.load_callback = () => {
		
	}
	this.Load()
}

public dataChanged(){ 
	if(!super.dataChanged())return
	this.select.visible = this.selected
	if (! this.data ) {
		ResManager.GetInstance().SetImageSprite(this, this._img, "dungeonPolar", "uijdfb_005", true)
		//this._lb_title.text = ""
	}else{
		ResManager.GetInstance().SetImageSprite(this, this._img, "dungeonPolar",this.data.single_dun_id+"",true)
		//this._lb_title.text = this.data.dun_name
	}
	let dunInfo = this.data && this._model.getPolarInfo(this.data.dun_id)
	this._img_join.visible =  dunInfo && dunInfo.dun_score > 0 
	if (this._img_join.visible ) {
		ResManager.GetInstance().SetImageSprite(this, this._img_join, "dungeonPolar_asset", TeamModel.GetInstance().joinImage(TeamModel.POLAR_DUN, dunInfo.dun_score))
	}
	this._img_test.visible =  this.data && this.data.single_dun_id == 36002 
}

public DeleteMe(): void {
	super.DeleteMe()
}



_img:Laya.Image
select:Laya.Image
_img_join:Laya.Image
_img_test:Laya.Image
public GetComponents() {
[
this._img,
this.select,
this._img_join,
this._img_test,
]
 = this.GetChildrenByNames([

"_img",
"select",
"_img_join",
"_img_test",
])
}
}
 window["DungeonPolarTab"]= DungeonPolarTab
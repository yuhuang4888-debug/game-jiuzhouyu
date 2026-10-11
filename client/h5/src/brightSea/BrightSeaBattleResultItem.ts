import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { CustomHeadItem } from "../common/CustomHeadItem"
import { ResManager } from "../common/ResManager"
import { BrightSeaModel } from "../commonModel/BrightSeaModel"
import { RoleManager } from "../commonModel/RoleManager"
import { GetSexByCareer } from "../util/Util"

export class BrightSeaBattleResultItem extends BaseItem1 {
data
model
head_box

public static width= 146
public static height = 52

public constructor(parent){
super(parent) 
	this.base_file = "brightSea"
	this.layout_file = "BrightSeaBattleResultItem"
	this.model = BrightSeaModel.GetInstance()
	this.load_callback = () => {
		
		this.UpdateView()
	}
}

public SetData(data?){ 
	
	this.data = data
}

public UpdateView(){ 
	
	if (! this.data ) {
		return
	}

	this._lb_name.text = this.data.name
	this._lb_fight.text = this.data.power
	
	let sp_name = this.data.is_win && "uicczhjs_010" || "uicczhjs_009"
	ResManager.GetInstance().SetImageSprite(this, this._img_result, "brightSea_asset", sp_name, true)

	let frame_data = this.data
	let main_role_vo = RoleManager.GetInstance().GetMainRoleVo()
	if (this.data.role_id == main_role_vo.role_id ) {
		frame_data = main_role_vo
	}
	// //let frame_res = this.model.GetHeadFrame(frame_data)
	// //if (frame_res ) {
	// //	ResManager.GetInstance().SetOutsideImageSprite(this, this._img_frame, GameResPath.GetIcon("head", "2_" + frame_res), true)
	// //}else{
	// 	ResManager.GetInstance().SetImageSprite(this, this._img_frame, "mainUI_asset", "uizjm_005",true)
	// //}


	// let head_res = this.model.GetHeadRes(this.data)
	//ResManager.GetInstance().SetOutsideImageSprite(this, this._img_head, head_res)
	if (!this.head_box) {
		this.head_box = new CustomHeadItem(this._box_head)
		this.head_box.Load()
	}

	let mainVo=RoleManager.GetInstance().mainRoleInfo
	let career=this.data.role_id== mainVo.role_id ?mainVo.career:this.data.career
	let sex=this.data.role_id== mainVo.role_id ?mainVo.sex:this.data.sex
	let ture=this.data.role_id== mainVo.role_id ?mainVo.turn:this.data.turn
	this.head_box.SetData(this.data.role_id, career, sex, this.data.pic, this.data.pic_ver, ture, this.data.ser_id)
	//this.head_box.SetActiveBg(false)
}

public DeleteMe(){
	if(this.head_box){
		this.head_box.DeleteMe()
		this.head_box=null
	}
	super.DeleteMe()
}


_box_head:Laya.Box
_img_result:Laya.Image
_lb_name:Laya.Label
_lb_fight:Laya.Label
label:Laya.Label
public GetComponents() {
[
this._box_head,
this._img_result,
this._lb_name,
this._lb_fight,
this.label,
]
 = this.GetChildrenByNames([

"_box_head",
"_img_result",
"_lb_name",
"_lb_fight",
"label",
])
}
}
 window["BrightSeaBattleResultItem"]= BrightSeaBattleResultItem
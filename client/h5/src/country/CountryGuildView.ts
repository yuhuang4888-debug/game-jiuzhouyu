import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { SeaHegemonyModel } from "../commonModel/SeaHegemonyModel"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
import { CountryGuildItem } from "./CountryGuildItem"

export class CountryGuildView extends BaseView1 {
dataArr
index
InitView
public constructor(){
super() 
	
    this.index = 0
    this.base_file = "country"
    this.layout_file = "CountryGuildView"
    this.layer_value = Enum_UILayer.Activity
    this.use_background = true
    this.click_bg_toClose = true
    this.is_center = true
    let local_model = SeaHegemonyModel
	let lcoal_modelIns = local_model.GetInstance()
	
	this.load_callback = () => {
		
        this.InitView()
        Util.AddClickEvent(
            this.closeBtn,() => {
                this.Close()
            },
            this,
            true
        )
        this.BindEvent(
            lcoal_modelIns,
            local_model.UPDATE_CAMP_DATA,() => {
                this.InitView()
            }
        )
        lcoal_modelIns.Fire(local_model.REQUEST_PROTO, 18655)
    }

    this.InitView = () => {
		let data = lcoal_modelIns.campData || []
		
		this.dataArr =  new LoopScrowViewMgr(this.layer_value)
		this.dataArr.SetData(this.Content, CountryGuildItem, data, LoopScrCon.Vertical)
    }
}

public DeleteMe(){ 
	
	if (this.dataArr ) {
		this.dataArr.DeleteMe()
		this.dataArr = null
	}
    super.DeleteMe()
}

bg:Laya.Image
closeBtn:Laya.Image
_Image2:Laya.Image
_Image4:Laya.Image
Content:Laya.List
timeLb:Laya.Label
_Label1:Laya.Label
_Label2:Laya.Label
_Label3:Laya.Label
_Label4:Laya.Label
_Label5:Laya.Label
_Image2_title:Laya.Image
_lb_win_name:Laya.Label
public GetComponents() {
[
this.bg,
this.closeBtn,
this._Image2,
this._Image4,
this.Content,
this.timeLb,
this._Label1,
this._Label2,
this._Label3,
this._Label4,
this._Label5,
this._Image2_title,
this._lb_win_name,
]
 = this.GetChildrenByNames([

"bg",
"closeBtn",
"_Image2",
"_Image4",
"Content",
"timeLb",
"_Label1",
"_Label2",
"_Label3",
"_Label4",
"_Label5",
"_Image2_title",
"_lb_win_name",
])
}
}
 window["CountryGuildView"]= CountryGuildView
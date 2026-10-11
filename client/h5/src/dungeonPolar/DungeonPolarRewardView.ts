import { BaseView1, OpenMode } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { BaseDungeonModel } from "../commonModel/BaseDungeonModel"
import { Util } from "../util/Util"
import { DungeonPolarRewardItem } from "./DungeonPolarRewardItem"

export class DungeonPolarRewardView extends BaseView1 {
InitEvent
LoadSuccess
background_alpha
click_bg_toClose
destroy_imm
initReward
loop_mgr
mask_corner
open_mode
use_background
_id
public constructor(){
super() 
	
	this.base_file = "dungeonPolar"
	this.layout_file = "DungeonPolarRewardView"
	this.layer_value = Enum_UILayer.Activity
	this.open_mode = OpenMode.OpenToggle
	this.destroy_imm = true
	this.use_background = true
	this.background_alpha = 0
	this.click_bg_toClose = true
	this.preload_server_config={"config_week_dungeon_boss":false}
	this.is_center = true
	let _model = BaseDungeonModel.GetInstance()
	this.load_callback = () => {
		this.InitEvent()
		this.LoadSuccess()
	}

	this.InitEvent = () => {
		Util.AddClickEvent(this._close_btn,() => {
				this.Close()
			}, this, true)
	}

	this.LoadSuccess = () => {
		this.initReward()
	}

	this.initReward = () => {
		let week_dungeon_boss_cfg = ResManager.GetInstance().GetGameConfigFromCache(this,"config_week_dungeon_boss",false)//Config.Weekdungeonboss
		let data = _model.getRewaedCfgList(week_dungeon_boss_cfg, this._id)
		for (let i in data) {
			var info = data[i]
			info["mask_corner"] = this.mask_corner
		}
		if (! this.loop_mgr ) {
			this.loop_mgr =  new LoopScrowViewMgr()
			this.loop_mgr.SetData(this.Content,DungeonPolarRewardItem,data,LoopScrCon.Vertical)
		}else{
			this.loop_mgr.replaceAll(data)
		}
	}

	this.destroy_callback=()=>{
		if (this.loop_mgr ) {
			this.loop_mgr.DeleteMe()
			this.loop_mgr = null
		}
	}
}

public DeleteMe(){ 
	super.DeleteMe()
}

public Open(...new_args){ 
	
	let parms = new_args
	this._id = parms[0]
	super.Open()
}


_Image1:Laya.Image
_Image4:Laya.Image
_Label1:Laya.Label
_close_btn:Laya.Image
Content:Laya.List
img_title:Laya.Image
lb_title:Laya.Label
public GetComponents() {
[
this._Image1,
this._Image4,
this._Label1,
this._close_btn,
this.Content,
this.img_title,
this.lb_title,
]
 = this.GetChildrenByNames([

"_Image1",
"_Image4",
"_Label1",
"_close_btn",
"Content",
"img_title",
"lb_title",
])
}
}
 window["DungeonPolarRewardView"]= DungeonPolarRewardView
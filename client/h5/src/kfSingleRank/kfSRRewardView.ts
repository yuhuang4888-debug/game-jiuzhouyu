import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { kfSingleRankModel, kfSingleRankDefine } from "../commonModel/kfSingleRankModel"
import { Util } from "../util/Util"
import { kfSRRewardItem } from "./kfSRRewardItem"

export class kfSRRewardView extends BaseView1 {
Clear
InitEvent
LoadSuccess
Local_Open
UpdateItems
click_bg_toClose
destroy_callback
destroy_imm
is_center
loop_mgr
preload_server_config
use_background
_area_id_
public constructor(){
super() 
	
	this.base_file = "kfSingleRank"
	this.layout_file = "kfSRRewardView"
	this.layer_value = Enum_UILayer.Activity
	this.destroy_imm = true
	this.use_background = true
	this.is_center = true
	this.click_bg_toClose = true
	let _model = kfSingleRankModel.GetInstance()
	let _ac_list_ = null
	this._area_id_ = null
	this.load_callback = () => {
		
		this.LoadSuccess()
	}

	this.destroy_callback = () => {
		this.Clear()
	}

	this.preload_server_config = {"config_rank_dungeon":false}
	this.Local_Open = () => {
		super.Open()
	}

	this.Clear = () => {
		if (this.loop_mgr ) {
			this.loop_mgr.DeleteMe()
			this.loop_mgr = null
		}
	}

	this.InitEvent = () => {
		Util.AddClickEvent(this._btn_close,() => {
			this.Close()
		}, this, true)
	}

	this.LoadSuccess = () => {
		this.InitEvent()
		let list = []
		let count = kfSingleRankDefine.LAYER_COUNT
		let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_rank_dungeon", false)
		
		for (let i = count; i >=1; i--) {
			let level = (this._area_id_ - 1) * count + i
			table.insert(list, cfg[level])
		}
		this.UpdateItems(list)
	}

	this.UpdateItems = ( list?) => {
		if(!this.loop_mgr ){
			this.loop_mgr =  new LoopScrowViewMgr()
			this.loop_mgr.SetData(this.Content, kfSRRewardItem,list,LoopScrCon.Vertical)
		}else{
			this.loop_mgr.replaceAll(list)
		}
	}
}

public Open(id?){ 
	
	this._area_id_ = id
	this.Local_Open()
}

public DeleteMe(){
	super.DeleteMe()
}


_Image1:Laya.Image
_Image2:Laya.Image
_img_title:Laya.Image
_lb_win_name:Laya.Label
_btn_close:Laya.Image
_Group1:Laya.Box
_Image5:Laya.Image
_Label1:Laya.Label
_Label2:Laya.Label
_Label3:Laya.Label
Content:Laya.List
public GetComponents() {
[
this._Image1,
this._Image2,
this._img_title,
this._lb_win_name,
this._btn_close,
this._Group1,
this._Image5,
this._Label1,
this._Label2,
this._Label3,
this.Content,
]
 = this.GetChildrenByNames([

"_Image1",
"_Image2",
"_img_title",
"_lb_win_name",
"_btn_close",
"_Group1",
"_Image5",
"_Label1",
"_Label2",
"_Label3",
"Content",
])
}
}
 window["kfSRRewardView"]= kfSRRewardView
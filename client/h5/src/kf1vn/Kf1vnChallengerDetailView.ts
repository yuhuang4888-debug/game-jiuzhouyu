import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { Kf1vnModel } from "../commonModel/Kf1vnModel"
import { GameResPath } from "../util/GameResPath"
import { Kf1vnChallengerMsgItem } from "./Kf1vnChallengerMsgItem"

export class Kf1vnChallengerDetailView extends BaseView1 {

InitChallengerContent
InitEvent
InitLeaderContent
LoadSuccess
Local_Open
OpenCallback
click_bg_toClose
destroy_callback
destroy_imm
leader_loop_mgr
leader_scroll_group
loop_loop_mgr
open_callback
use_background
SetLeader

public constructor(){
super() 
	
	this.base_file = "kf1vn"
	this.layout_file = "Kf1vnChallengerDetailView"
	this.layer_value = Enum_UILayer.Top
	this.destroy_imm = true
	this.click_bg_toClose = true
	this.use_background = true
	this.background_alpha = 0
	this.is_center=true
	let data_ = null
	this.load_callback = () => {
		ResManager.GetInstance().SetOutsideImageSprite(this, this._title, GameResPath.GetIcon("kf1vn","ui_kf_ds001"))
		this.LoadSuccess()
		this.InitEvent()
	}

	this.open_callback = () => {
		this.OpenCallback()
	}

	this.destroy_callback = () => {
		if (this.loop_loop_mgr ) {
			this.loop_loop_mgr.DeleteMe()
			this.loop_loop_mgr = null
		}
		if (this.leader_loop_mgr ) {
			this.leader_loop_mgr.DeleteMe()
			this.leader_loop_mgr = null
		}
	}

	this.LoadSuccess = () => {
		
		ResManager.GetInstance().SetOutsideImageSprite(this, this.bg, GameResPath.GetIcon("kf1vn","kf1vn_252"))
	}

	this.InitEvent = () => {

	}

	this.Local_Open = ( parms?) => {
		data_ = parms && parms[0] || null
		super.Open()
	}

	this.OpenCallback = () => {
		if (data_ ) {
			this.InitChallengerContent()
			this.SetLeader()
		}
	}

	this.InitChallengerContent = () => {
		if (! this.loop_loop_mgr ) {
			this.loop_loop_mgr =  new LoopScrowViewMgr()
			this.loop_loop_mgr.SetData(this.Content ,Kf1vnChallengerMsgItem, data_.challenger_list || [],LoopScrCon.Vertical)
		}else{
			this.loop_loop_mgr.replaceAll(data_.challenger_list)
		}
	}

	this.SetLeader = () => {
		if (data_ ) {
			let list = []
			let leader = null
			leader = {}
			leader.player_id = data_.player_id
			leader.platform = data_.platform
			leader.server_num = data_.server_num
			leader.server_name = data_.server_name
			leader.level = data_.level
			leader.name = data_.name
			leader.career = data_.career
			leader.turn = data_.turn
			leader.sex = data_.sex
			leader.picture = data_.picture
			leader.picture_ver = data_.picture_ver
			leader.combat_power = data_.combat_power
			leader.not_show_line = true
			table.insert(list, leader)
			this.InitLeaderContent(list)
		}
	}

	this.InitLeaderContent = ( list?) => {
		if (! this.leader_loop_mgr ) {
			this.leader_loop_mgr =  new LoopScrowViewMgr()
			this.leader_loop_mgr.SetData(this.Content1 ,Kf1vnChallengerMsgItem, list, LoopScrCon.Vertical)
		}else{
			this.leader_loop_mgr.replaceAll(list)
		}
	}
}

public Open(...new_args){ 
	
	let parms = new_args
	this.Local_Open(parms)
}



bg:Laya.Image
_title:Laya.Image
Content:Laya.List
Content1:Laya.List
public GetComponents() {
[
this.bg,
this._title,
this.Content,
this.Content1,
]
 = this.GetChildrenByNames([

"bg",
"_title",
"Content",
"Content1",
])
}
}
 window["Kf1vnChallengerDetailView"]= Kf1vnChallengerDetailView
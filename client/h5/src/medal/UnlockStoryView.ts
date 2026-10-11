import { BaseView1 } from "../common/BaseView1"
import { Config } from "../common/Config"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { MedalModel } from "../commonModel/MedalModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Util, GlobalTimerQuest } from "../util/Util"
import { Vector2 } from "../util/Vector2"

export class UnlockStoryView extends BaseView1 {
_Group1
_Image1
_Image2
_Image3
background_alpha
bg
cfg
click_bg_toClose
close_callback
content
content_group
destroy_callback
destroy_imm
effect_group
effect_group2
hide_main_ui_finger
left_img
left_time
light_effect
model_type
name_img
name_label
not_show_attr_main_msg
not_show_main_msg
open_callback
picture_effect1
picture_effect2
right_img
roleCon
show_open_movie
time_event_id
tips
tips0
unlock_cfg
unlock_type
use_background

public constructor(){
super() 
	
	this.base_file = "unlock"
	this.layout_file = "UnlockStoryView"
	this.layer_value = Enum_UILayer.Activity
	this.destroy_imm = true
	this.use_background = true
	this.click_bg_toClose = true
	this.show_open_movie = false
	this.not_show_main_msg = true
	this.not_show_attr_main_msg = true
	this.background_alpha = 0.8
	this.left_time = 10
	this.hide_main_ui_finger = true
	this.model_type = {
		horse:10, 
		wing:7, 
		partner:1, 
		weapon:3
	}
	this.load_callback = () => {
		MedalModel.GetInstance().Fire(MedalModel.CLOSE_MEDAL_VIEW)
		this.LoadSuccess()
		this.InitEvent()
	}
	
	this.open_callback = () => {
		this.OpenCallBack()
	}
	
	this.close_callback = () => {
		this.task_model.PauseAutoDoTask(false)
	}
	
	this.destroy_callback = () => {
		this.ClearUIEffect(this.effect_group)
		this.ClearUIEffect(this.effect_group2)
		this.ClearUIEffect(this.light_effect)
		this.ClearUIEffect(this.picture_effect1)
		this.ClearUIEffect(this.picture_effect2)
		this.CancelTime()
		//PushGiftModel.GetInstance().CheckDelayTips()
	}
}

public LoadSuccess(){ 
	 
	
}

public InitEvent(){ 
	 
	
}

public Open(...new_args){ 
	
	let parms = new_args
	if (parms && parms[1] ) { 
		this.unlock_type = parms[1]	
	}
	
	super.Open()
}

public OpenCallBack(){ 
	
	if (! this.unlock_type ) {
		return
	}
	this.task_model.PauseAutoDoTask(true)
	//SoundManager:GetInstance():PlaySoundEffect("3_huode")
	this.SetView()
}

public SetView(){ 
	
	if (! this.unlock_cfg ) {
		this.unlock_cfg = Config.PRELOAD_CLIENT_CONFIG.ConfigUnlockTask
	}
	this.cfg = this.unlock_cfg[this.unlock_type]
	if (! this.cfg ) {
		return
	}
	this.name_label.textFlow = Util.StrToHTML(this.cfg.story_name)
	//this:AddUIEffect("ui_Background_glow", this.layer_value, this.light_effect, null, Vector3(1.26, 1.25, 1), true)
	//this:AddUIEffect("ui_arrayglow_behind", this.layer_value, this.picture_effect1, null, 1, true)
	//this:AddUIEffect("ui_arrayglow_front", this.layer_value, this.picture_effect2, null, 1, true)
	//this.AddUIEffect("UI_1115", this.layer_value, this.picture_effect1, null, 1, true)
	//let curr_sorting_order = this.AddCurrLayerSortingOrder(this.layer_value)
	//this.CoverMode(this._Image1, this.layer_value, curr_sorting_order)
	//this.CoverMode(this._Image2, this.layer_value, curr_sorting_order)
	this.PlatAnimation1()
	this.StartTime()
}

public PlatAnimation1(){ 
	
	if (! this.cfg || this.use_delete_method ) {
		return
	}
	let play_tmp = this.cfg.animation_in_unlock_view[1]
	if (this.unlock_type == "weapon" ) {
		play_tmp = this.cfg.animation_in_unlock_view[RoleManager.GetInstance().GetMainRoleVo().career]
	}
	if (! play_tmp ) {
		return
	}
	
	let call_fun = () => {
		
	}
	if (this.unlock_type == "weapon" ) {		
		let data = {
			res_id : Number(play_tmp.source),
			clothe_res_id :  Number(play_tmp.source),
			modelPartPos :  2,
			type :  this.model_type[this.unlock_type], 
			layer_value :  this.layer_value, 
			rotate :  play_tmp.rotate || 0, 
			action_name_list :  play_tmp.action,
			scale :  play_tmp.sacle, 
			position :  new Vector2(play_tmp.story_pos.x, play_tmp.story_pos.y),
			can_rotate :  true,
			callBack :  call_fun
		}
		//ResManager.GetInstance().SetPartModel(this, this.roleCon, data)
	}else{
		let data = {
			res_id : Number(play_tmp.source),
			clothe_res_id : Number(play_tmp.source),
			type : this.model_type[this.unlock_type], 
			layer_value : this.layer_value, 
			rotate : play_tmp.rotate || 0, 
			can_rotate : true,
			action_name_list : play_tmp.action,
			scale : play_tmp.sacle, 
			position : new Vector2(play_tmp.story_pos.x, play_tmp.story_pos.y),
			callBack : call_fun
		}
		ResManager.GetInstance().SetRoleModel(this, this.roleCon, data)
	}
	
	//let curr_sorting_order = this.AddCurrLayerSortingOrder(this.layer_value)
	//this:CoverMode(this._Image2, this.layer_value, curr_sorting_order)
	//this.CoverMode(this._Image3, this.layer_value, curr_sorting_order)
	//this.CoverMode(this.name_label, this.layer_value, curr_sorting_order)
	
	//let ui_effect_str = play_tmp.effect_name
	//this:AddUIEffect(ui_effect_str, this.layer_value, this.effect_group, Vector3(play_tmp.pos[0], play_tmp.pos[1], 0), play_tmp.sacle, null, {call_back_func =() => {
	//this:PlatAnimation2(false)
	//}})
	//this:PlatAnimation2(true)
}

public PlatAnimation2(pre_load?){ 
	
	if (! this.cfg || this.use_delete_method ) {
		return
	}
	let play_tmp = this.cfg.animation[1]
	if (this.unlock_type == "weapon" ) {
		play_tmp = this.cfg.animation[RoleManager.GetInstance().GetMainRoleVo().sex - 1][1]
	}
	if (! play_tmp ) {
		return
	}
	let ui_effect_str = play_tmp.effect_name
	let group = pre_load && this.effect_group2 || this.effect_group
	//this:AddUIEffect(ui_effect_str, group, Vector3(play_tmp.pos[0], play_tmp.pos[1], 0), play_tmp.sacle, true, null, {call_back_func =() => {
	//if (! pre_load ) {
	//let call_fun = () => {
	//this:ClearUIEffect(this.effect_group)
	//this:PlatAnimation1()
	//}
	
	//setTimeout(call_fun, 20)
	//}
	//}})
}

public StartTime(){ 
	
	this.CancelTime()
	this.left_time = 10
	let time_fun = () => {
		this.OnTime()
	}
	this.time_event_id = GlobalTimerQuest.AddPeriodQuest(time_fun,1,-1)
	this.OnTime()
}

public OnTime(){ 
	
	this.left_time = this.left_time - 1
	if (this.left_time <= 0 ) {
		this.Close()
		return
	}
	this.tips0.text = this.left_time + "秒后自动关闭"
}

public CancelTime(){ 
	
	if (this.time_event_id ) {
		GlobalTimerQuest.CancelQuest(this.time_event_id)
		this.time_event_id = null
	}
}


}

window["UnlockStoryView"] = UnlockStoryView
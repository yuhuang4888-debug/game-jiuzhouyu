import { BaseView1 } from "../common/BaseView1"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { LuaSoundManager } from "../common/SoundManager"
import { StoryModel } from "../commonModel/StoryModel"
import { TaskModel } from "../commonModel/TaskModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { SetAnchoredPosition, Util, GlobalTimerQuest } from "../util/Util"

export class UnlockTipsView extends BaseView1 {
EmpcloseBtn
_Image1
_Image11
_Image2
click_bg_toClose
closeBtn
close_callback
count_time_id
destroy_callback
destroy_imm
end_time
labelDisplay
open_callback
show_open_movie
task
task_content
title
use_background

public constructor(){
super() 
	
	this.end_time = 0;
	this.base_file = "unlock"
	this.layout_file = "UnlockTipsView"
	this.layer_value = Enum_UILayer.UI
	this.destroy_imm = true
	this.use_background = false
	this.click_bg_toClose = false
	this.show_open_movie = false
	this.load_callback = () => {
		this.LoadSuccess()
		this.InitEvent()
	}
	
	this.open_callback = () => {
		TaskModel.GetInstance().unlock_tips_is_show = true
		this.OpenCallBack()
	}
	
	this.close_callback = () => {
		TaskModel.GetInstance().unlock_tips_is_show = false
	}
	
	this.destroy_callback = () => {
		this.CancelTimer()
	}
}

public LoadSuccess(){ 
	
	
	let x = 0
	// let y = -(ScreenHeight / 2 - this.form.sizeDelta.y - 135)
	// SetAnchoredPosition(this.form, x, y)
}

public InitEvent(){ 
	
	let go_fun = () => {
		GlobalEventSystem.Fire(EventName.OPEN_UNLOCK_ENTER_VIEW)
		this.Close()
	}
	
	Util.AddClickEvent(this.closeBtn, go_fun, this, true, null, null, null, null, LuaSoundManager.SOUND_UI.CLOSE)
	
	let update_fun = () => {
		if (this.use_delete_method ) {
			return
		}
		if (this.task ) {
			if (! TaskModel.GetInstance().GetHasReceiveTaskList(this.task.task_id) ) {
				this.Close()
			}
		}
	}
	this.BindEvent(TaskModel.GetInstance(), TaskModel.UPDATE_ALL_TASK_FROM_30000, update_fun)
	
	let close_fun = () => {
		this.Close()
	}
	
	this.BindEvent(GlobalEventSystem, EventName.OPEN_UNLOCK_ENTER_VIEW, close_fun)
}

public Open(...new_args){ 
	
	let parms = new_args
	if (parms && parms[1] ) { 
		this.task = parms[1]
	}
	super.Open()
}

public OpenCallBack(){ 
	
	if (! this.task ) {
		return
	}
	StoryModel.GetInstance().DeleteFinger(null, true)
	this.task_content.textFlow = Util.StrToHTML(this.task.task_tips_msg)
	this.StartTimer(5)
}

public StartTimer(end_time?){ 
	
	this.CancelTimer()
	this.end_time = end_time
	let time_fun = () => {
		this.on_time()
	}
	this.count_time_id = GlobalTimerQuest.AddPeriodQuest(time_fun,1,-1)
	
	this.on_time()
}

public on_time(){ 
	
	this.end_time = this.end_time - 1
	if (this.end_time < 0 ) {
		this.CancelTimer()
		this.Close()
		return
	}
}

public CancelTimer(){ 
	
	if (this.count_time_id ) {
		GlobalTimerQuest.CancelQuest(this.count_time_id)
		this.count_time_id = null
	}
	this.end_time = 0
}


}

window["UnlockTipsView"] = UnlockTipsView
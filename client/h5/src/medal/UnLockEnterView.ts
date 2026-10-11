import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { EventName } from "../common/EventName"
import { StoryModel } from "../commonModel/StoryModel"
import { TaskModel } from "../commonModel/TaskModel"
import { UnlockView } from "../unlock/UnlockView"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"

export class UnLockEnterView extends BaseWindowComponent {
bg_list
delay_delete_time
destroy_imm
money_list
tabStrList
titleStr
viewClassList
window_load_back
window_open_back
public constructor(){
super() 
	
	
	this.dependent_res = ["medal"]
	this.tabStrList = [{label:"唤醒", icon_up_source:"medal_asset.hx_2", icon_down_source:"medal_asset.hx_1"}]
	this.viewClassList = [UnlockView]
	this.bg_list = ["unlock_bg.jpg"]
	this.destroy_imm = true
	this.delay_delete_time = 0.01
	this.titleStr = "medal_asset.uihx_000"
	//this.money_list = [2, 1, 0]
	this.window_load_back = () => {
		GlobalEventSystem.Fire(EventName.SELECT_STORY_TARGET, StoryModel.StoryTargetName.RebornBtn, false)
		this.UnLockRedDot()
	}
	
	this.window_open_back = () => { 
		
	}
	
}

public Close(){ 
	
	super.Close( )
}

public SetDefaultIndex(index, ...new_args){ 
	
	super.SetDefaultIndex(this, index)
}

public UnLockRedDot(){ 
	
	let UpdataUnLockRedDot = () => {
		let show = TaskModel.GetInstance().UnLockRedDot(true)
		GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "UnLockEnterView", 0, show)
	}
	
	this.BindEvent(TaskModel.GetInstance(), TaskModel.UPDATE_UNLOCK_RED_DOT, UpdataUnLockRedDot)
	UpdataUnLockRedDot()
}

public DeleteMe(){ 
	
	super.Remove()
	super.DeleteMe()
}

}
window["UnLockEnterView"] = UnLockEnterView
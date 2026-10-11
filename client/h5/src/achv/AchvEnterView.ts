import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { EventName } from "../common/EventName"
import { achvModel } from "../commonModel/achvModel"
import { MainFunc } from "../commonModel/MainUIModel"
import { TaskTipType } from "../commonModel/TaskModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { SetLocalPositionX } from "../util/Util"
import  "./achvView"

export class AchvEnterView extends BaseWindowComponent {
Local_SelectView
_Local_Close
_Local_Open
bg_list
delay_delete_time
destroy_imm
getViewIndex
money_list
tabStrList
titleStr
viewClassList
viewClassModuleDic
window_load_back
window_open_back


public constructor(){
super() 
	
	this.dependent_res = ["achv"]
	this.tabStrList = [{label:"成就", icon_up_source:"achv_json.uibqy_001_r3_c2_png", icon_down_source:"achv_json.uibqy_001_r3_c1_png"}]
	// [ts2lua]window下标访问可能不正确
	this.viewClassList = ["achvView"]
	this.viewClassModuleDic = {"0":{module_name:"achv", class_name:"achvView"}}
	this.destroy_imm = true
	this.delay_delete_time = 0.01
	this.titleStr = "achv.uicj_030"
	this.bg_list = ["uicj_bg1.jpg"]
	this.money_list = [2, 1, 0]
	let GS = GlobalEventSystem
	let local_event = EventName
	let local_task_type = TaskTipType
	let local_achvModel = achvModel.GetInstance()

	this.window_load_back = () => {
		if (local_achvModel.ShowRed ) {
			GS.Fire(local_event.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "AchvEnterView", 0, true)
		}
	}
	
	this.window_open_back = () => {
		if (this.task_model.IsCurrMainLineTaskTipType(local_task_type.AchvAward) ) {
			SetLocalPositionX(this._story_bar2, -156) //第二个选项卡位置
		}
	}
	
	this._Local_Close = () => {
		if (this.task_model.IsCurrMainLineTaskTipType(local_task_type.AchvAward) ) {
			if (this.story_model.curr_view_story_step > 0 ) {
				this.story_model.curr_view_story_step = 0
			}
		}
		// super.Close()
		super.Close()
	}
	
	this.BaseWindowCloseFunc = () => {
		GS.Fire(local_event.SWITCH_MAIN_FUNC_VIEW, MainFunc.Role)
		// super.CloseFunc()
		super.BaseWindowCloseFunc()
	}
	
	this.Local_SelectView = ( index?) => {
		if (this.task_model.IsCurrMainLineTaskTipType(local_task_type.AchvAward) ) {
			this.destroy_imm = true
			if (index != 1 && this.story_model.curr_view_story_step > 0 ) {
				this.story_model.curr_view_story_step = 0
			}
		}
		// super.SelectView(index)
		super.SelectView(index)
	}
	
	this.getViewIndex = ( _class?) => {
		let index = 0
		for (let key in this.viewClassList) {
			
			if (this.viewClassList.hasOwnProperty(key) ) {
				// [ts2lua]this.viewClassList下标访问可能不正确
				let viewClass = this.viewClassList[key]
				if (_class == viewClass ) {
					return index
				}
				index=index+1
			}
		}
	}
	
	this._Local_Open = ( parms?) => {
		if (parms ) {
			this.SetIndexParameter(parms[0], parms[1], parms[2])
		}
		// super.Open()
		super.Open()
	}
	
	
}

public Open(...new_args){ 
	
	let parms = new_args
	this._Local_Open(parms)
}

public Close(){ 
	
	this._Local_Close()
}

public SelectView(index?){ 
	
	this.Local_SelectView(index)
}

}

window["AchvEnterView"]=AchvEnterView
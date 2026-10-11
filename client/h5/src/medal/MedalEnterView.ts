import { OpenMode } from "../common/BaseView1"
import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { CommonManager } from "../common/CommonManager"
import { EventName } from "../common/EventName"
import { ModuleType } from "../common/RedDotManager"
import { MainFunc } from "../commonModel/MainUIModel"
import { MedalModel } from "../commonModel/MedalModel"
import "../title/TitleMainView"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import "./MedalView"

export class MedalEnterView extends BaseWindowComponent {
_model
bg_list
money_list
tabStrList
titleList
viewClassList
window_open_back
CanOpen
public constructor(){
super() 
	
	
	this.dependent_res = ["medal", "title"]
		this.tabStrList = [
			{ label: "地境", icon_up_source: "medal_json.uixunzhang_012b_png", icon_down_source: "medal_json.uixunzhang_012a_png" },
			{ label: "天境", icon_up_source: "title_json.uidttx_015_02_png", icon_down_source: "title_json.uidttx_015_01_png" }
		]

	// this.viewClassList = ["MedalView"]
	this.viewClassList = ["MedalView", "TitleMainView"]
	this.viewClassModuleDic = {
		"0": { module_name: "medal", class_name: "MedalView" },
		"1": { module_name: "title", class_name: "TitleMainView" }
	}
	this.titleList = ["medal.uixz_001", "title.uixz_001"]
	//this.money_list = [2, 1, 0]
	this.bg_list = ["ui_role_bg2.jpg", "ui_role_bg1.jpg"]
	this._model = MedalModel.GetInstance()
	this.window_open_back = () => {
		// this._model.setShowRedDot()
		this.medalRedDot()
		this.CheckTitleRedDot()
	}

	this.CanOpen = () => {
		let func_is_open = CommonManager.GetInstance().CheckFuncOpenState("MedalView");
		if (func_is_open == false) {
			return false;
		}
		if (this.open_mode == OpenMode.OpenToggle && this.isPop) {
			this.Close();
			return false;
		}
		return true;
	};
}

public medalRedDot(){ 
	
	if (this._model.medal_bin_redDot ) {
		return
	}
	let changeMedalRedDot = () => {
		GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "MedalEnterView", 0, this._model.CheckRedStatus(ModuleType.MEDAL, 1) || this._model.CheckRedStatus(ModuleType.MEDAL_STRENGTHEN, 1))
	}
	
	this.BindEvent(GlobalEventSystem, EventName.UPDATE_REDDOT,(mType?, rType?) => {
			if (mType == ModuleType.MEDAL && rType == 1 || mType == ModuleType.MEDAL_STRENGTHEN && rType == 1 ) {
				changeMedalRedDot()
			}
		}
	)
	changeMedalRedDot()
}

public CheckTitleRedDot(){ 
	
	let red = this._model.CheckTitleRedDot()
	GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "MedalEnterView", 1, red)
}

	public BaseWindowCloseFunc() {

		super.BaseWindowCloseFunc()
		GlobalEventSystem.Fire(EventName.SWITCH_MAIN_FUNC_VIEW, MainFunc.Role)
	}

}


window["MedalEnterView"]=MedalEnterView
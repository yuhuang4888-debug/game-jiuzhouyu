import { BaseWindowComponent } from "../../common/BaseWindowComponent"
import { EventName } from "../../common/EventName"
import { UI_MODEL_TYPE } from "../../common/UIModelClass3D"
import { MainFunc } from "../../commonModel/MainUIModel"
import { enum_OutWardType, OutWardBaseModel } from "../../commonModel/OutWardBaseModel"
import { TaskModel, TaskTipType } from "../../commonModel/TaskModel"
import { GlobalEventSystem } from "../../util/DeclareGlobalVar"
import { OutWardBaseView } from "../OutWardBaseView"

export class PartnerComponentView extends OutWardBaseView {

	public constructor(parent?) {
		super(parent)

		this._type = enum_OutWardType.Partner
		this._model_type = UI_MODEL_TYPE.PARTNER
		let local_outwardModel = OutWardBaseModel
		let local_outwardModelIns = local_outwardModel.GetInstance()
		this.load_callback = () => {
			this.LoadSuccess()
		}

		this.InitEvent = () => {
			super.InitEvent()
			let IllusionFunc = () => {
				GlobalEventSystem.Fire(EventName.SWITCH_MAIN_FUNC_VIEW, MainFunc.Pet)
				local_outwardModelIns.Fire(local_outwardModel.OPEN_MOUNTPET_ILLUSION_VIEW, enum_OutWardType.Partner)
			}

			super.OnIllusionBtnClick(IllusionFunc)
			local_outwardModelIns.Fire(local_outwardModel.OPEN_MOUNTPET_VIEW, enum_OutWardType.Partner)
		}

		this.UpdateTask = () => {
			if(!this.task_model.IsCurrMainLineTaskTipType(TaskTipType.TrainPartner))return
			if(this.is_stop_task){
				if (this.story_model.GetFinger(this, this.lv_button)) {
					GlobalEventSystem.Fire(EventName.HIDE_FINGER, this.lv_button)
				}
				if(!this.story_model.GetAllFingerStatus())return
				if (!this.story_model.GetFinger(this, BaseWindowComponent.CURR_BASE_WINDOW_COMPONENT._img_return)) {
					this.story_model.curr_view_story_step = 2
					GlobalEventSystem.Fire(EventName.SHOW_FINGER, this, BaseWindowComponent.CURR_BASE_WINDOW_COMPONENT._img_return)
				}
				return
			}
			if (!this.task_model.IsCurrMainTaskHasFinish()) {
				if (!this.story_model.GetFinger(this, this.lv_button)) {
					this.story_model.curr_view_story_step = 1
					GlobalEventSystem.Fire(EventName.SHOW_FINGER, this, this.lv_button)
				}
			}
		}

	}

	public createChildren() {
		
		if (this["GetComponents"]){
            this["GetComponents"]()
			this.is_get = true
        }
		//精灵改成第一个开放，开放时页签在第一位
		this.story_obj_list = this.story_obj_list || {}
		if(this.task_model.IsCurrMainLineTaskTipType(TaskTipType.MountLevel)
		||this.task_model.IsCurrMainLineTaskTipType(TaskTipType.TrainPartner)){
			this.story_model.curr_view_story_step = 1
			GlobalEventSystem.Fire(EventName.HIDE_FINGER, BaseWindowComponent.CURR_BASE_WINDOW_COMPONENT._story_bar2)
		}
		this.story_obj_list[TaskTipType.TrainPartner] = [null,this.lv_button]
		this.story_obj_list[TaskTipType.MountLevel]=[]
		if(this.task_model.IsCurrMainLineTaskTipType(TaskTipType.MountLevel)){
			let task_vo = TaskModel.GetInstance().GetMainLineTaskVo()
			if(task_vo&&task_vo.task_id==100521&&task_vo.need_num>=3){
				this.story_obj_list[TaskTipType.MountLevel][2] = [null, this.btn_group_2, null]
			}else{
		this.story_obj_list[TaskTipType.MountLevel][2] =  [null, this.btn_group_2,null,BaseWindowComponent.CURR_BASE_WINDOW_COMPONENT._img_return]
			}
		}
		//this.story_obj_list[TaskTipType.MountLevel][2] =  [null, this.btn_group_2,null,BaseWindowComponent.CURR_BASE_WINDOW_COMPONENT._img_return]
		// this.story_obj_list[TaskTipType.MountLevel][2] = [this.btn_group_2, 0, BaseWindowComponent.CURR_BASE_WINDOW_COMPONENT._img_return]
		super.createChildren()
	}
}
window["PartnerComponentView"]=PartnerComponentView
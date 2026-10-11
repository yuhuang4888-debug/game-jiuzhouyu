import { BaseWindowComponent } from "../../common/BaseWindowComponent"
import { EventName } from "../../common/EventName"
import { UI_MODEL_TYPE } from "../../common/UIModelClass3D"
import { MainFunc } from "../../commonModel/MainUIModel"
import { enum_OutWardType, OutWardBaseModel } from "../../commonModel/OutWardBaseModel"
import { TaskModel, TaskTipType } from "../../commonModel/TaskModel"
import { GlobalEventSystem } from "../../util/DeclareGlobalVar"
import { OutWardBaseView } from "../OutWardBaseView"

export class HorseComponentView extends OutWardBaseView {

	public constructor(parent?) {
		super(parent)

		let local_outwardType = enum_OutWardType
		let local_outwardModel = OutWardBaseModel
		let local_outwardModelIns = local_outwardModel.GetInstance()
		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName
		this._type = local_outwardType.Horse
		this._model_type = UI_MODEL_TYPE.HORSE
		this.load_callback = () => {
			this.LoadSuccess()
			//local_GlobalEventSystem:Fire(local_EventName.SELECT_STORY_TARGET, StoryModel.StoryTargetName.PetIcon, false)
		}

		this.InitEvent = () => {
			super.InitEvent()
			let IllusionFunc = () => {
				local_GlobalEventSystem.Fire(local_EventName.SWITCH_MAIN_FUNC_VIEW, MainFunc.Pet)
				local_outwardModelIns.Fire(local_outwardModel.OPEN_MOUNTPET_ILLUSION_VIEW, local_outwardType.Horse)
			}

			super.OnIllusionBtnClick(IllusionFunc)
			local_outwardModelIns.Fire(local_outwardModel.OPEN_MOUNTPET_VIEW, local_outwardType.Horse)
		}

		this.UpdateTask = () => {
			if(!this.task_model.IsCurrMainLineTaskTipType(TaskTipType.TrainMount))return
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
		this.story_obj_list = this.story_obj_list || {}
		let task_vo = TaskModel.GetInstance().GetMainLineTaskVo()
		if (this.task_model.IsCurrMainLineTaskTipType(TaskTipType.TrainMount)
		||this.task_model.IsCurrMainLineTaskTipType(TaskTipType.MountLevel)) {
			this.story_model.curr_view_story_step=1
			GlobalEventSystem.Fire(EventName.HIDE_FINGER, BaseWindowComponent.CURR_BASE_WINDOW_COMPONENT._story_bar2)
		}
		this.story_obj_list[TaskTipType.TrainMount] = [null, this.lv_button]
		this.story_obj_list[TaskTipType.MountLevel]=[]
		if (this.task_model.IsCurrMainLineTaskTipType(TaskTipType.MountLevel)) {
			if (task_vo && task_vo.task_id == 100901&&task_vo.need_num>=3) {
				this.story_obj_list[TaskTipType.MountLevel][1] = [null, this.btn_group_2, null]
			} else {
		this.story_obj_list[TaskTipType.MountLevel][1] = [null, this.btn_group_2,null,BaseWindowComponent.CURR_BASE_WINDOW_COMPONENT._img_return]
			}
		}
		// this.story_obj_list[TaskTipType.MountLevel][1] = [this.btn_group_2, 0, BaseWindowComponent.CURR_BASE_WINDOW_COMPONENT._img_return]
		//this.story_obj_list[TaskTipType.TrainPartner] = [BaseWindowComponent.CURR_BASE_WINDOW_COMPONENT._story_bar2]
		super.createChildren()

	}
}
window["HorseComponentView"]=HorseComponentView

import { BaseWindowComponent } from "../../common/BaseWindowComponent"
import { EventName } from "../../common/EventName"
import { UI_MODEL_TYPE } from "../../common/UIModelClass3D"
import { OutWardBaseModel, enum_OutWardType } from "../../commonModel/OutWardBaseModel"
import { RoleManager } from "../../commonModel/RoleManager"
import { TaskModel, TaskTipType } from "../../commonModel/TaskModel"
import { GlobalEventSystem } from "../../util/DeclareGlobalVar"
import { OutWardBaseView } from "../OutWardBaseView"

export class HolyDeviceComponentView extends OutWardBaseView {

	public constructor(parent?) {
		super(parent)

		let local_outwardModel = OutWardBaseModel
		let local_outwardModelIns = local_outwardModel.GetInstance()
		this._type = enum_OutWardType.HolyDevice
		this._model_type = UI_MODEL_TYPE.WEAPON
		this.is_show_arrow = false

		this.load_callback = () => {
			this.LoadSuccess()
		}

		this.LoadSuccess = () => {
			this.show_type = 1
			super.LoadSuccess()
			this.star_group.visible = false
			this.shadow_group.visible = false
			this.after_btn.visible = false
			this.before_btn.visible = false
			super.SetModel(1)
		}

		this.InitEvent = () => {
			super.InitEvent()
			let IllusionFunc = () => {
				local_outwardModel.GetInstance().Fire(local_outwardModel.OPEN_OUTWARD_ILLUSION_VIEW, enum_OutWardType.HolyDevice)
			}
			super.OnIllusionBtnClick(IllusionFunc)

			local_outwardModelIns.Fire(local_outwardModel.OPEN_MOUNTPET_VIEW, enum_OutWardType.HolyDevice)
		}

		//没有星星
		this.SetStar = (num?) => {

		}

		this.SetStage = (stage?) => {
			let career = RoleManager.GetInstance().mainRoleInfo.career
			let key = `${this.type_id}@${stage}@${career}`
			let cfg = local_outwardModelIns.outward_stage_cfg[key]
			if (cfg) {
				this.res_name.text = cfg.name
			}
			super.SetSelectState(stage)
			this.SetModel(stage)
		}

		//幻化按钮点击事件 特殊处理  神兵可以选择为0级
		this.OnIllusionClick = () => {
			if (this.cur_data.figure_stage == 1) {
				local_outwardModelIns.Fire(local_outwardModel.ILLUSION_OUTWARD, this.type_id, 1, 0, 0)
			} else {
				local_outwardModelIns.Fire(local_outwardModel.ILLUSION_OUTWARD, this.type_id, 1, 1, 0)
			}
		}
	}


	public createChildren() {
		if (this["GetComponents"]) {
			this["GetComponents"]()
			this.is_get = true
		}
		this.story_obj_list = this.story_obj_list || {}

		if (this.task_model.IsCurrMainLineTaskTipType(TaskTipType.TrainArtifact)
		||this.task_model.IsCurrMainLineTaskTipType(TaskTipType.MountLevel)) {
			this.story_model.curr_view_story_step=1
			GlobalEventSystem.Fire(EventName.HIDE_FINGER, BaseWindowComponent.CURR_BASE_WINDOW_COMPONENT._story_bar2)
		}

		this.story_obj_list[TaskTipType.TrainArtifact] = [null, this.lv_button,BaseWindowComponent.CURR_BASE_WINDOW_COMPONENT._img_return]
		this.story_obj_list[TaskTipType.MountLevel]=[]
		//this.story_obj_list[TaskTipType.MountLevel][5] =  [null, this.btn_group_2,null,BaseWindowComponent.CURR_BASE_WINDOW_COMPONENT._img_return]
		if(this.task_model.IsCurrMainLineTaskTipType(TaskTipType.MountLevel)){
			let task_vo = TaskModel.GetInstance().GetMainLineTaskVo()
			if(task_vo&&task_vo.task_id==101406&&task_vo.need_num>=3){
				this.story_obj_list[TaskTipType.MountLevel][5] = [null, this.btn_group_2, null]
			}else{
				this.story_obj_list[TaskTipType.MountLevel][5] = [null, this.btn_group_2, null, BaseWindowComponent.CURR_BASE_WINDOW_COMPONENT._img_return]
			}
		}

		super.createChildren()
	}


}
window["HolyDeviceComponentView"] = HolyDeviceComponentView
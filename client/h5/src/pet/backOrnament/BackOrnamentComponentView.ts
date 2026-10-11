import { UI_MODEL_TYPE } from "../../common/UIModelClass3D"
import { OutWardBaseModel, enum_OutWardType } from "../../commonModel/OutWardBaseModel"
import { RoleManager } from "../../commonModel/RoleManager"
import { OutWardBaseView } from "../OutWardBaseView"

export class BackOrnamentComponentView extends OutWardBaseView {

	public constructor(parent?) {
		super(parent)

		let local_outwardModel = OutWardBaseModel
		let local_outwardModelIns = local_outwardModel.GetInstance()
		this._type = enum_OutWardType.BackOrnament
		this._model_type = UI_MODEL_TYPE.BACKORNAMENT
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
				local_outwardModel.GetInstance().Fire(local_outwardModel.OPEN_OUTWARD_ILLUSION_VIEW, enum_OutWardType.BackOrnament)
			}
			super.OnIllusionBtnClick(IllusionFunc)

			local_outwardModelIns.Fire(local_outwardModel.OPEN_MOUNTPET_VIEW, enum_OutWardType.BackOrnament)
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

		// //幻化按钮点击事件 特殊处理  神兵可以选择为0级
		// this.OnIllusionClick = () => {
		// 	if (this.cur_data.figure_stage == 1) {
		// 		local_outwardModelIns.Fire(local_outwardModel.ILLUSION_OUTWARD, this.type_id, 1, 0, 0)
		// 	} else {
		// 		local_outwardModelIns.Fire(local_outwardModel.ILLUSION_OUTWARD, this.type_id, 1, 1, 0)
		// 	}
		// }
	}
}
window["BackOrnamentComponentView"]=BackOrnamentComponentView
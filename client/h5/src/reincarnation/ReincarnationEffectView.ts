import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { ReincarnationModel } from "../commonModel/ReincarnationModel"
import { TaskModel } from "../commonModel/TaskModel"
import { RoleManager } from "../commonModel/RoleManager"

export class ReincarnationEffectView extends BaseView1 {
	SetData
	model
	not_do_task_id
	public constructor() {
		super()
		this.base_file = "reincarnation"
		this.layout_file = "ReincarnationEffectView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.use_background = false
		this.click_bg_toClose = false
		this.model = ReincarnationModel.GetInstance()
		this.is_center = true

		this.load_callback = () => {

		}

		this.open_callback = () => {
			this.SetData()
		}

		this.close_callback = () => {
			if (this.not_do_task_id) {
				clearTimeout(this.not_do_task_id)
				this.not_do_task_id = null
			}
		}

		this.Open = () => {

			super.Open()
		}

		this.SetData = () => {
			let roleinfo = RoleManager.GetInstance().mainRoleInfo
			if (roleinfo){
				let resouceStr = null
				if (roleinfo.career == 1) {
					resouceStr = "ui_1107_1"
				} else if (roleinfo.career == 2) {
					resouceStr = "ui_1108_1"
				} else if (roleinfo.career == 3) {
					resouceStr = "ui_1107"
				} else if (roleinfo.career == 4) {
					resouceStr = "ui_1108"
				}
				this.model.is_show_effect = true
				TaskModel.GetInstance().not_dotask = true

				let call_fun = () => {
					this.model.Fire(ReincarnationModel.REBIRTH_OPEN_VIEW, "ReincarnationSuccessView")
					this.model.is_show_effect = false
					TaskModel.GetInstance().not_dotask = false
					if (this.not_do_task_id) {
						clearTimeout(this.not_do_task_id)
						this.not_do_task_id = null
					}
					this.Close()
				}
				// this.AddUIEffect(resouceStr, this.group, null, 10, true, undefined, undefined, call_fun)
				//目前还没有特效，所以直接调用回调函数
				call_fun()
				
				this.not_do_task_id = setTimeout(() => {
					TaskModel.GetInstance().not_dotask = false
				}, 10)
			}
		}
	}
	group: Laya.Box
	public GetComponents() {
		[
			this.group,
		]
			= this.GetChildrenByNames([

				"group",
			])
	}
}
window["ReincarnationEffectView"] = ReincarnationEffectView
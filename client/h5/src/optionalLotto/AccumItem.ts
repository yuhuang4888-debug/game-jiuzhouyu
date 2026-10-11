import { BaseItem1 } from "../common/BaseItem1"
import { EquipmentItem } from "../common/EquipmentItem"
import { ResManager } from "../common/ResManager"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { Message } from "../sysInfo/SysInfoController"
import { Color, Util } from "../util/Util"

export class AccumItem extends BaseItem1 {
	_Image1: Laya.Image
	_gp_reward: Laya.Box
	_img_drawed: Laya.Image
	_gp_num: Laya.Box
	_img_num_bg: Laya.Image
	_lb_num: Laya.Label
	_img_red: Laya.Image
	Emp_gp_num
	InitEvent
	InitView
	Local_DeleteMe
	Out_lb_num
	SetData

	public constructor(parent?) {
		super(parent)

		this.base_file = "optionalLotto"
		this.layout_file = "AccumItem"
		let model = CustomActivityModel.GetInstance()
		let reward_item = null
		let base_type = null
		let sub_type = null
		let grade_info = null
		let grade_stage = null
		let count = null

		this.load_callback = () => {

			this.InitEvent()
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._gp_num, () => {
				if (grade_stage) {
					if (grade_stage.status == 2) {
						Message.show("已领取")
					} else if (grade_stage.status == 0) {
						Message.show("累计" + count + "次可领")
					} else {
						model.Fire(CustomActivityDefine.EVENT.SCMD_REQUEST, 33135, base_type, sub_type, grade_stage.grade)
					}
				}
			}
				, this, true)
		}

		this.InitView = () => {
			if (base_type == null || sub_type == null || !grade_info || !grade_stage) {
				return
			}
			let status = grade_stage.status
			this._img_drawed.visible = status == 2
			this._gp_num.visible = status != 2
			this._img_red.visible = status == 1
			if (status != 2) {
				let desc = "可领取"
				let strokeColor = "#fdf7e8"
				let color = "#a51c1c"
				let bg_url = "ui_button_rect8"
				if (status == 0) {
					let cond = model.GetActCondition(base_type, sub_type, "data", grade_stage.grade)
					if (cond) {
						desc = cond.stage + "次"
						count = Number(cond.stage)
						strokeColor = "#d1f6f4"
						bg_url = "ui_button_rect9"
						color = "#186e74"
					}
				}
				this._lb_num.text = desc
				this._lb_num.strokeColor = strokeColor
				this._lb_num.color = color
				ResManager.GetInstance().SetImageSprite(this, this._img_num_bg, "common_asset", bg_url)
			}
			let reward = model.GetActReward(base_type, sub_type, grade_info.form_type, grade_info.reward)
			if (reward && reward[0]) {
				let v = reward[0]
				let [type, lock] = GoodsModel.GetInstance().GetMappingTypeId(v[0], v[1])
				if (!reward_item) {
					reward_item = new EquipmentItem(this._gp_reward)
					reward_item.Load()
					reward_item.SetItemSize(85, 85)
				}
				reward_item.ExcuteCallback(() => {
					reward_item.SetData(type, v[2], lock)
				}
				)
			}
		}

		this.SetData = (...new_args) => {
			let args = new_args
			base_type = args[0]
			sub_type = args[1]
			grade_info = args[2]
			grade_stage = args[3]
			this.InitView()
		}

		this.Local_DeleteMe = () => {
			if (reward_item) {
				reward_item.DeleteMe()
				reward_item = null
			}
		}


	}

	public DeleteMe() {

		this.Local_DeleteMe()
		super.DeleteMe()
	}



	public GetComponents() {
		[
			this._Image1,
			this._gp_reward,
			this._img_drawed,
			this._gp_num,
			this._img_num_bg,
			this._lb_num,
			this._img_red,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_gp_reward",
				"_img_drawed",
				"_gp_num",
				"_img_num_bg",
				"_lb_num",
				"_img_red",
			])
	}
}
window["AccumItem"] = AccumItem
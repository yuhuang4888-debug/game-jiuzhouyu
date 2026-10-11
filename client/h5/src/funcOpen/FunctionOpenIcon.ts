import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer, LayerManager } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { UIModelClass3D, UI_MODEL_TYPE } from "../common/UIModelClass3D"
import { FunctionOpenEvent, FunctionOpenModel } from "../commonModel/FunctionOpenModel"
import { MainUIModel } from "../commonModel/MainUIModel"
import { enum_OutWardType } from "../commonModel/OutWardBaseModel"
import { GameResPath } from "../util/GameResPath"
import { GlobalTimerQuest, SetHtmlCenter, Util } from "../util/Util"
import { Vector3 } from "../util/Vector3"
import { FunctionOpenListView } from "./FunctionOpenListView"
import { Config } from "../common/Config"
import { SYTweenFunc } from "../util/SYTweenFunc"
import { SYTweenLite } from "../util/SYTweenLite"

export class FunctionOpenIcon extends BaseView1 {
	private data
	private model: FunctionOpenModel
	private icon_pos_y

	show_index = 0
	icons = []
	time_id
	tween_
	record_id = 0
	public constructor() {
		super()
		this.base_file = "functionOpen"
		this.layout_file = "FunctionOpenIcon"
		this.layer_value = Enum_UILayer.Main

		this.model = FunctionOpenModel.GetInstance()
		this.load_callback = () => {
			this.LoadSuccess()
			this.InitEvent()
		}
		this.open_callback = () => {

			this.SetFuncIcon()
		}
		this.destroy_callback = () => {
			ResManager.GetInstance().ClearRoleMode(this.hashCode)
			Laya.Tween.clearAll(this.icon_con)
			// this.ClearUIEffect(this.front_effect)
			this.data = null

			if (this.time_id) {
				GlobalTimerQuest.CancelQuest(this.time_id)
				this.time_id = null
			}

			if (this.tween_) {
				for (let key in this.tween_) {
					SYTweenLite.Stop(this.tween_[key])
					delete this.tween_[key]
				}
			}

		}
	}

	LoadSuccess() {

		this.display_obj.right = 0
		let y = 144
		let liu_hai_height = Util.GetLiuhaiHeight()
		if (liu_hai_height && liu_hai_height > 0) {
			y = 144 + liu_hai_height
		}
		this.display_obj.y = y
		this.icon_pos_y = this.icon_con.y


		this.tips.style.fontSize = 36
		this.tips.style.color = "#ffe659"
		this.tips.style.stroke = 4
		this.tips.style.strokeColor = "#3f0808"
		this.tips.style.align = "center"

		this.tips.style.wordWrap = false
		this.tips.style.leading = 4
		this.tips.style.bold = true
		this.tips.scale(0.5, 0.5)
		this.ShowAnimation()
	}

	ShowAnimation() {
		Laya.Tween.to(this.icon_con, { y: this.icon_pos_y - 10 }, 700, undefined, Laya.Handler.create(this, () => {
			this.ShowAnimation2()
		}))
	}

	ShowAnimation2() {
		Laya.Tween.to(this.icon_con, { y: this.icon_pos_y }, 700, undefined, Laya.Handler.create(this, () => {
			this.ShowAnimation()
		}))

	}

	Open(...parms) {
		let [new_data] = parms
		if (!new_data || (this.data && new_data.id == this.data.id)) {
			return
		}
		this.data = new_data
		super.Open()
	}

	InitEvent() {
		Util.AddClickEvent(this.click_box, () => {
			if (this.data) {
				this.model.Fire(FunctionOpenEvent.FUNCTIONOPEN_OPEN_VIEW, "FunctionOpenListView", this.data)
				//this.SetFuncIcon()
			}
		}, this)


		this.BindEvent(MainUIModel.GetInstance(), MainUIModel.UPDATE_ACTIVITY_STATE, (bool) => {
			if (this.use_delete_method) return
			if (bool) {
				Laya.Tween.to(this.display_obj, { right: 0, alpha: 1 }, MainUIModel.Move_Time_Interval)
			} else {
				Laya.Tween.to(this.display_obj, { right: -this.display_obj.width, alpha: 0 }, MainUIModel.Move_Time_Interval)

			}
		})

		let update_fun = (id) => {
			this.ShowRedDot()
		}
		this.BindEvent(this.model, FunctionOpenEvent.FUNCTIONOPEN_GET_REWARD_SUCCESS, update_fun)

		let state = MainUIModel.GetInstance().activity_icon_in_show
		if (state) {
			this.display_obj.right = 0
			this.display_obj.alpha = 1
		} else {
			this.display_obj.right = -this.display_obj.width
			this.display_obj.alpha = 0
		}
	}

	private SetFuncIcon() {
		ResManager.GetInstance().ClearRoleMode(this.hashCode)
		if (!this.data) return


		//做一个轮播
		this.icons = this.model.ShowFuncOpenIcons()
		if (this.icons.length >= 2) {
			if (this.record_id != this.icons[0].id) {
				this.record_id = this.icons[0].id
				this.StartTime()
			}
		} else {
			if (this.time_id) {
				GlobalTimerQuest.CancelQuest(this.time_id)
				this.time_id = null
			}
			this.LoopSHow(this.data)
			this.SetTip(this.data)
		}



		this.ShowRedDot()
	}

	private StartTime() {
		if (this.time_id) {
			GlobalTimerQuest.CancelQuest(this.time_id)
			this.time_id = null
		}
		this.time_id = GlobalTimerQuest.AddPeriodQuest(() => {
			if (!this.tween_) this.tween_ = {}
			for (let key in this.tween_) {
				SYTweenLite.Stop(this.tween_[key])
				delete this.tween_[key]
			}

			this.show_index = this.show_index == 0 ? 1 : 0

			//设置模型和icon
			let SetModel = () => {
				this.LoopSHow(this.icons[this.show_index])
			}

			//设置任务提示
			let SetTip = () => {
				this.SetTip(this.icons[this.show_index])
			}

			this.AnimationShow(this.icon_con, 0.2, SetModel, 1)
			this.AnimationShow(this._img_model_txt, 0.2, null, 3)
			this.AnimationShow(this.tips, 0.4, SetTip, 5)

		}, 10, -1)

		//初始显示
		this.LoopSHow(this.icons[this.show_index])
		this.SetTip(this.icons[this.show_index])
	}


	private AnimationShow(comp?, time?, call_back?, step?) {

		this.tween_[step] = SYTweenLite.to(this, comp, SYTweenLite.UiAnimationType.ALPHA, 0, time, () => {


			//设置数据
			if (call_back) call_back()

			//下一步动画
			this.tween_[step + 1] = SYTweenLite.to(this, comp, SYTweenLite.UiAnimationType.ALPHA, 1, time, () => { }, SYTweenFunc.LINEAR)
		}, SYTweenFunc.LINEAR)
	}

	private LoopSHow(data_vo) {
		if (data_vo.model != "0") {
			let model_type = Number(data_vo.model_type)
			let model_name_ = data_vo.model
			let action_list = null
			let outward_action_cfg_ = Config.PRELOAD_CLIENT_CONFIG.ClientOutWardModel
			let client_pos_cfg_ = Config.PRELOAD_CLIENT_CONFIG.ClientOutWardPos
			if (outward_action_cfg_ && outward_action_cfg_[model_type + "@0"]) {
				action_list = outward_action_cfg_[model_type + "@0"].action_list
			}
			let pre_x = ""
			let default_str = ""
			switch (model_type) {
				case enum_OutWardType.Horse:
					pre_x = "h"
					default_str = "default_horse"
					break;
				case enum_OutWardType.Wings:
					pre_x = "w"
					default_str = "default_wing"
					break;
				case enum_OutWardType.Partner:
					pre_x = "s"
					default_str = "default_sprite"
					break;
				case enum_OutWardType.Artifact:
					pre_x = "d"
					default_str = "default_weapon"
					break;
				case enum_OutWardType.HolyDevice:
					pre_x = "a"
					default_str = "default_artifact"
					break;
				case enum_OutWardType.Pet:
					pre_x = "p"
					default_str = "default_sprite"
					break;
				case 9:
					pre_x = "bb"
					default_str = "default_sprite"
					break;
				case 10:
					pre_x = "js"
					default_str = "default_sprite"
					break;
				case 11:
					pre_x = "yl"
					default_str = "default_sprite"
					break;
				case enum_OutWardType.BackOrnament:
					pre_x = "b"
					default_str = "default_back_ornament"
					break;
			}

			let data = null
			let pos_cfg = client_pos_cfg_[`FunctionOpenIcon_${pre_x}_${model_name_}`]
			if (!pos_cfg) {
				pos_cfg = client_pos_cfg_[default_str]
			}
			data = {
				clothe_res_id: model_name_,
				type: model_type,
				can_rotate: false,
				layer_value: this.layer_value,
				scale: pos_cfg && pos_cfg.scale,
				position: pos_cfg && pos_cfg.position,
				rotate: pos_cfg && pos_cfg.rotate,
				texture_size: { x: 567, y: 415 },
				action_name_list: action_list,
				action_delta: true
			}
			if (data) {
				ResManager.GetInstance().SetRoleModel(this, this._box_model, data)
			}

			//图标
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_model_txt, GameResPath.GetIconOtherPath("functionOpen", `icon_txt_${data_vo.id}`))
			this._img_model_txt.visible = this._box_model.visible = true
			this.icon.visible = false
		} else {
			this._img_model_txt.visible = this._box_model.visible = false
			this.icon.visible = true
			ResManager.GetInstance().SetImageSprite(this, this.icon, "functionOpen", data_vo.icon)
		}


	}


	private SetTip(data_vo) {
		if(data_vo){
			this.tips.innerHTML = Util.StrToHTML(data_vo.icon_text)
			this.tips.x = this.click_box.width / 2 - (this.tips.contextWidth * this.tips.scaleX) / 2
		}
	}


	private ShowRedDot() {
		this.red_dot.visible = this.model.HaveRewardCanGet()
	}


	click_box: Laya.Box
	bg: Laya.Image
	tips: Laya.HTMLDivElement
	icon_con: Laya.Box
	icon: Laya.Image
	_box_model: Laya.Box
	_img_model_txt: Laya.Image
	red_dot: Laya.Image
	public GetComponents() {
		[
			this.click_box,
			this.bg,
			this.tips,
			this.icon_con,
			this.icon,
			this._box_model,
			this._img_model_txt,
			this.red_dot,
		]
			= this.GetChildrenByNames([

				"click_box",
				"bg",
				"tips",
				"icon_con",
				"icon",
				"_box_model",
				"_img_model_txt",
				"red_dot",
			])
	}
}
window["FunctionOpenIcon"] = FunctionOpenIcon
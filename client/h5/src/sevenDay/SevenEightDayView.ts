import { SevenDayView } from "../sevenDay/SevenDayView"
import { Enum_UILayer } from "../common/LayerManager";
import { ResManager } from "../common/ResManager";
import { GameResPath } from "../util/GameResPath";
export class SevenEightDayView extends SevenDayView {
	_img_bg: Laya.Image
	_img_title: Laya.Image
	_img_day: Laya.Image
	img_reward_name: Laya.Image
	_btn_claim: Laya.Box
	_Image11: Laya.Image
	labelDisplay: Laya.Label
	_img_red: Laya.Image
	_gp_effect1: Laya.Box
	_gp_model: Laya.Box
	_gp_model_effect: Laya.Box
	_img_close: Laya.Image
	_Image1: Laya.Image
	_scl_reward: Laya.Panel
	Content: Laya.HBox
	_gp_tab: Laya.HBox
	_Group1: Laya.Box
	_img_model: Laya.Image
	bg1: Laya.Image
	Emp_btn_claim
	Scr_scl_reward
	_gp_reward
	location_y
	public constructor() {
		super()


		this.base_file = "sevenDay"
		this.layout_file = "SevenEightDayView"
		this.use_background = true
		this.is_center = true
		this.layer_value = Enum_UILayer.Activity
		this.not_show_main_msg = true
		this.destroy_imm = true

		this.load_callback = () => {
			this._scl_reward.hScrollBar.visible = false
			//this.RegisterMask(this._gp_reward,1)
			//this.location_y = this._img_model.anchoredPosition.y
		}
	}



	public GetComponents() {
		[
			this._img_bg,
			this._img_title,
			this._img_day,
			this.img_reward_name,
			this._btn_claim,
			this._Image11,
			this.labelDisplay,
			this._img_red,
			this._gp_effect1,
			this._gp_model,
			this._gp_model_effect,
			this._img_close,
			this._Image1,
			this._scl_reward,
			this.Content,
			this._gp_tab,
			this._Group1,
			this._img_model,
			this.bg1
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_img_title",
				"_img_day",
				"img_reward_name",
				"_btn_claim",
				"_Image11",
				"labelDisplay",
				"_img_red",
				"_gp_effect1",
				"_gp_model",
				"_gp_model_effect",
				"_img_close",
				"_Image1",
				"_scl_reward",
				"Content",
				"_gp_tab",
				"_Group1",
				"_img_model",
				"bg1"
			])
	}
}
window["SevenEightDayView"] = SevenEightDayView
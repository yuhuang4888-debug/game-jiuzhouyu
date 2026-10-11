import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { TopVipModel, TopVipEvent } from "../commonModel/TopVipModel"
import { GameResPath } from "../util/GameResPath"
import { GlobalTimerQuest } from "../util/Util"

export class TopVipActivationSkillView extends BaseView1 {
	bottom_label: Laya.Label
	effect_gp: Laya.Box
	_bg_img: Laya.Image
	effect_bg_gp: Laya.Box
	_Group1: Laya.Box
	skill_name_img: Laya.Image
	_Image1: Laya.Image
	skill_img: Laya.Image
	_lb_skill_name:Laya.Label
	_lb_skill_desc: Laya.Label
	CancelTime
	CloseCallBack
	CloseView
	LoadSuccess
	SetData
	StartTimer
	background_alpha
	click_bg_toClose
	close_callback
	destroy_imm
	effect_cache_sort_order
	is_center
	open_callback
	use_background

	public constructor() {
		super()


		let model = TopVipModel.GetInstance()

		let local_laya = Laya
		let need_refresh_ = false
		let skill_id_ = null
		let _stage_ = null
		let timer_ = null
		this.base_file = "topVip"
		this.layout_file = "TopVipActivationSkillView"
		this.layer_value = Enum_UILayer.Activity
		this.background_alpha = 0.7
		this.is_center = true
		this.use_background = true
		this.destroy_imm = true
		this.click_bg_toClose = true
		this.preload_client_config={
			"ClientTopVipActivationConfig":false
		}
		this.load_callback = () => {


		}

		this.open_callback = () => {
			// this.effect_cache_sort_order = this.AddCurrLayerSortingOrder(this.layer_value)
			this.LoadSuccess()
		}
		this.close_callback = () => {
			this.CloseCallBack()
			model.Fire(TopVipEvent.TOP_VIP_REQUEST_PROTO, 45102)
			//GlobalEventSystem:UnBind(EventName.CONGRATULATION_VIEW_CLOSE)
		}

		this.LoadSuccess = () => {
			this._bg_img.visible = true
			this.StartTimer()
			//this:AddUIEffect("UI_1102_jihuochenggong",this.layer_value, this.effect_bg_gp, null, null, false,{custom_sorting_order = this.effect_cache_sort_order,call_back_func =() => {

			//}})
			// this.AddUIEffect("UI_1115", this.effect_gp, null, null, true, {
			// 	custom_sorting_order: this.effect_cache_sort_order + 1, load_call_back: () => {
			// 		// this.CoverEffect(this._Group1)
			// 		// this.CoverEffect(this._bg_img)
			// 	}
			// })
			//this:AddUIEffect2("ui_Pokemon_activation", this.effect_bg_gp, null, null, false, null,() => {

			//}
			//)
			//this:AddUIEffect2("ui_badge_glow", this.effect_gp, null, null, true)
			if (need_refresh_) {
				this.SetData(skill_id_, _stage_)
			}
		}

		this.SetData = (skill_id?, stage?) => {
			skill_id_ = skill_id
			_stage_ = stage
			if (this.is_loaded) {
				ResManager.GetInstance().SetOutsideImageSprite(this, this._bg_img, GameResPath.GetIcon("topVip", "ui_shape_05"), true)
				ResManager.GetInstance().SetOutsideImageSprite(this, this.skill_img, "resource/game/skillIcon/" + skill_id + ".png")
				this._lb_skill_name.text=this.preload_client_config["ClientTopVipActivationConfig"]["stage_"+Number(stage)].name
				this._lb_skill_desc.text=this.preload_client_config["ClientTopVipActivationConfig"]["stage_"+Number(stage)].desc
				// ResManager.GetInstance().SetImageSprite(this, this.skill_name_img, "topvip_asset", "uizz_036_" + stage)
				//this._bg_img.visible = false 
			} else {
				need_refresh_ = true
			}
		}

		this.CloseCallBack = () => {
			//this:ClearUIEffect(this.effect_bg_gp)
			//this:ClearUIEffect(this.effect_gp)
			this.CancelTime()
		}

		this.StartTimer = () => {
			this.CancelTime()
			timer_ = setTimeout(() => {
				this.Close()
			}, 5000)
		}

		this.CancelTime = () => {
			if (timer_) {
				clearTimeout(timer_)
			}
		}

		this.CloseView = () => {
			this.Close()
		}


	}

	public Open(...new_args) {

		let parm = new_args
		if (parm && parm.length > 0) {
			this.SetData(parm[0], parm[1])
		}
		super.Open()
	}


	public GetComponents() {
		[
			this.bottom_label,
			this.effect_gp,
			this._bg_img,
			this.effect_bg_gp,
			this._Group1,
			this.skill_name_img,
			this._Image1,
			this.skill_img,
			this._lb_skill_name,
			this._lb_skill_desc
		]
			= this.GetChildrenByNames([

				"bottom_label",
				"effect_gp",
				"_bg_img",
				"effect_bg_gp",
				"_Group1",
				"skill_name_img",
				"_Image1",
				"skill_img",
				"_lb_skill_name",
				"_lb_skill_desc"
			])
	}
}
window["TopVipActivationSkillView"]=TopVipActivationSkillView
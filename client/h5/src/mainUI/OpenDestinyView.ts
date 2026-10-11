import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { ResVersionManager } from "../ResVersionManager"
import { RoleManager } from "../commonModel/RoleManager"
import { Enum_ColorUtil_Dark } from "../util/ColorUtil"
import { GameResPath } from "../util/GameResPath"
import { SYTweenLite } from "../util/SYTweenLite"
import { Util } from "../util/Util"
import { Vector2 } from "../util/Vector2"


export class OpenDestinyView extends BaseView1 {
	bg_img: Laya.Image
	circule_img: Laya.Image
	icon_img: Laya.Image
	icon_img1: Laya.Image
	effect_gp: Laya.Box
	title_img: Laya.Image
	detail_gp: Laya.Box
	_Label1: Laya.Label
	_Label2: Laya.Label
	_Label3: Laya.Label
	_Label4: Laya.Label
	bottom_label: Laya.Label
	_img_click:Laya.Image
	DeleteTween
	LoadSuccess
	PlayAni
	cantdetail_gp
	cantitle_img
	click_bg_can_close_time
	click_bg_toClose
	close_callback
	destroy_imm
	is_center
	tween_id
	use_background
	InitEvent

	public constructor() {
		super()
		this.base_file = "mainUI"
		this.layout_file = "OpenDestinyView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.use_background = true
		this.click_bg_toClose = true
		this.click_bg_can_close_time = 3
		this.is_center = true
		let local_laya = Laya
		let local_resMgr = ResManager.GetInstance()
		let local_mainRoleVo = RoleManager.GetInstance().GetMainRoleVo()
		this.load_callback = () => {

			// this.cantitle_img = this.title_img.GetComponent("CanvasGroup")
			// this.cantdetail_gp = this.detail_gp.GetComponent("CanvasGroup")
			this.LoadSuccess()
			this.InitEvent()
		}

		this.close_callback = () => {
			this.DeleteTween()
			this.ClearUIEffect(this.effect_gp)
		}
		this.InitEvent=()=>{
			Util.AddClickEvent(this._img_click,()=>{
				this.Close()
			},this,)
		}

		this.LoadSuccess = () => {

			local_resMgr.SetOutsideImageSprite(this, this.bg_img, GameResPath.GetIcon("mainUI", "uisc_002"),true)
			// local_resMgr.SetOutsideImageSprite(this, this.title_img, GameResPath.GetIcon("mainUI", "uisc_005"))
			// local_resMgr.SetOutsideImageSprite(this, this.icon_img, GameResPath.GetIcon("mainUI", "uisc_007"), true)
			//local_resMgr:SetImageSprite(this, this.icon_img1, GameResPath.GetIcon("mainUI","uisc_008"))
			this.PlayAni()
		}

		this.PlayAni = () => {
			this.DeleteTween()

			// this.tween_id = SYTweenLite.to(this, this.circule_img, SYTweenLite.UiAnimationType.ROTATION, -90, 0.3, () => {
			// 	this.bg_img.visible = true
			// 	this.icon_img1.visible = true
			// 	this.icon_img.visible = true
			// 	SYTweenLite.to(this, this.circule_img, SYTweenLite.UiAnimationType.ANCHORED_POSX, 135, 0.3)
			// 	SYTweenLite.to(this, this.bg_img, SYTweenLite.UiAnimationType.ANCHORED_POSX, 121, 0.3)
			// 	SYTweenLite.to(this, this.bg_img, SYTweenLite.UiAnimationType.WIDTH, 598, 0.3)
			// 	SYTweenLite.to(this, this.icon_img1, SYTweenLite.UiAnimationType.ANCHORED_POSX, 541, 0.3)
			// 	this.tween_id = SYTweenLite.to(this, this.icon_img, SYTweenLite.UiAnimationType.ANCHORED_POSX, 522, 0.3, () => {
					// this.AddUIEffect("UI_1130","Activity",this.effect_gp, new Vector2(11,7),1,true)

					// let curr_sorting_order = this.AddCurrLayerSortingOrder(this.layer_value)
					// this.CoverEffect(this.detail_gp, "Activity", curr_sorting_order)
					// this.CoverEffect(this.title_img, "Activity", curr_sorting_order)

					// this.tween_id = SYTweenLite.to(this, this.cantitle_img, SYTweenLite.UiAnimationType.ALPHA, 1, 0.2, () => {
					// 	this.tween_id = SYTweenLite.to(this, this.cantdetail_gp, SYTweenLite.UiAnimationType.ALPHA, 1, 0.3, () => {
					// 		this.bottom_label.visible = true
					// 	})
					// })

				// })
			// })

			//local_laya.Tween.get(this.circule_img):to({rotation=90}, 300).call(() => {

			//local_laya.Tween.get(this.circule_img).to({x=135}, 300)
			//local_laya.Tween.get(this.bg_img).to({x=121, width=598}, 300)
			//local_laya.Tween.get(this.icon_img1).to({x=530}, 300)
			//local_laya.Tween.get(this.icon_img):to({x=509}, 300).call(() => {
			//this:ClearUIEffect(this.effect_gp)
			//this:AddUIEffect2("ui_newlevel_glow", this.effect_gp, null, 1.4, true)
			//local_laya.Tween.get(this.title_img):to({alpha=1}, 200).call(() => {
			//local_laya.Tween.get(this.detail_gp):to({alpha=1}, 300).call(() => {
			//this.bottom_label.visible =  true
			//}
			//)
			//}
			//)
			//}
			//)
			//}
			//)
		}
		this.DeleteTween = () => {
			if (this.tween_id) {
				SYTweenLite.Stop(this.tween_id)
				this.tween_id = null
			}
		}
	}

	public GetComponents() {
		[
			this.bg_img,
			this.circule_img,
			this.icon_img,
			this.icon_img1,
			this.effect_gp,
			this.title_img,
			this.detail_gp,
			this._Label1,
			this._Label2,
			this._Label3,
			this._Label4,
			this.bottom_label,
			this._img_click,
		]
			= this.GetChildrenByNames([

				"bg_img",
				"circule_img",
				"icon_img",
				"icon_img1",
				"effect_gp",
				"title_img",
				"detail_gp",
				"_Label1",
				"_Label2",
				"_Label3",
				"_Label4",
				"bottom_label",
				"_img_click"
			])
	}
}
window["OpenDestinyView"]=OpenDestinyView
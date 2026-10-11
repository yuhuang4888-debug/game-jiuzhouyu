import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer, LayerManager } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { SceneManager } from "../scene/SceneManager"
import { Mathf } from "../util/Mathf"
import { SetAnchoredPosition, SetAnchoredPositionX, SetAnchoredPositionY } from "../util/Util"

export class UIJoyStick extends BaseView1 {
	LoadSuccess
	UpdatePos
	ShowJoyStick
	HideJoyStick

	public constructor() {
		super()

		this.base_file = "mainUI"
		this.layout_file = "UIJoyStick"
		this.layer_value = Enum_UILayer.Main

		let scene_mgr = SceneManager.GetInstance()
		let local_Math = Mathf

		let local_SetAnchoredPositionX = SetAnchoredPositionX
		let local_SetAnchoredPositionY = SetAnchoredPositionY


		this.load_callback = () => {
			this.LoadSuccess()
		}

		this.open_callback = () =>{
			this.Hide()
		}
		this.LoadSuccess = () => {

			this.display_obj.x = this.display_obj.y = 0
			this.display_obj.mouseEnabled = false
			ResManager.GetInstance().SetImageSprite(this, this._img_bg, "mainUI", "mainui_base_bg")
		}

		this.UpdatePos = () => {
			if (this._gp_root) {
				let start_posx = scene_mgr.curr_click_start_pos.x
				let start_posy = scene_mgr.curr_click_start_pos.y //- LayerManager.GetInstance().stageWidth
				local_SetAnchoredPositionX(this._gp_root, start_posx)
				local_SetAnchoredPositionY(this._gp_root, start_posy)
				let dist = local_Math.Min(98 - 44.5, scene_mgr.curr_click_move_dist)
				local_SetAnchoredPositionX(this._img_middle_circle, 100 + scene_mgr.curr_joystick_dir.x * dist)
				local_SetAnchoredPositionY(this._img_middle_circle, 100 + scene_mgr.curr_joystick_dir.y * dist)
				let radian = local_Math.Abs(local_Math.Atan(scene_mgr.curr_joystick_dir.y / scene_mgr.curr_joystick_dir.x))
				radian = radian * 180 / local_Math.PI
				if (scene_mgr.curr_joystick_dir.y <= 0 && scene_mgr.curr_joystick_dir.x > 0) {
					this._img_middle_circle.rotation = -50 - radian  //Quaternion.Euler(0, 0, 50 - radian)
					// this._arrow_img.rotation = 90 - radian //Quaternion.Euler(0, 0, -90 - radian)

				} else if (scene_mgr.curr_joystick_dir.y <= 0 && scene_mgr.curr_joystick_dir.x < 0) {
					this._img_middle_circle.rotation = -50 - 180 + radian //Quaternion.Euler(0, 0, 50 + 180 + radian)
					// this._arrow_img.rotation = 90 - 180 + radian //Quaternion.Euler(0, 0, -90 + 180 + radian)

				} else if (scene_mgr.curr_joystick_dir.y >= 0 && scene_mgr.curr_joystick_dir.x < 0) {
					this._img_middle_circle.rotation = -50 - 180 - radian//Quaternion.Euler(0, 0, 50 + 180 - radian)
					// this._arrow_img.rotation = 90 - 180 - radian//Quaternion.Euler(0, 0, -90 + 180 - radian)

				} else if (scene_mgr.curr_joystick_dir.y >= 0 && scene_mgr.curr_joystick_dir.x > 0) {
					this._img_middle_circle.rotation = -50 + radian//Quaternion.Euler(0, 0, 50 + radian)
					// this._arrow_img.rotation = 90 + radian//Quaternion.Euler(0, 0, -90 + radian)

				}
			} else {
				// LogError("this._gp_root is null")
			}
		}
		this.ShowJoyStick = () => {
			if (this.display_obj && !this.display_obj.visible) {
				this.CancelHide()
				this.UpdatePos()
			}
		}

		this.HideJoyStick = () => {
			if (this.display_obj && this.display_obj.visible) {
				this.Hide()
			}
		}
	}


	_gp_root: Laya.Box
	_img_bg: Laya.Image
	_img_arrow: Laya.Image
	_img_middle_circle: Laya.Image
	public GetComponents() {
		[
			this._gp_root,
			this._img_bg,
			this._img_arrow,
			this._img_middle_circle,
		]
			= this.GetChildrenByNames([

				"_gp_root",
				"_img_bg",
				"_img_arrow",
				"_img_middle_circle",
			])
	}
}
window["UIJoyStick"] = UIJoyStick
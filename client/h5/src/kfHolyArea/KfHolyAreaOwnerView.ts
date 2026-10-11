import { BaseView1 } from "../common/BaseView1"
import { KfHolyAreaModel } from "../commonModel/KfHolyAreaModel"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
import { ErlangParser } from "../util/ErlangParser"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { SceneManager } from "../scene/SceneManager"
import { SYTweenLite } from "../util/SYTweenLite"
import { SYTweenFunc } from "../util/SYTweenFunc"
export class KfHolyAreaOwnerView extends BaseView1 {
	_gp_effect: Laya.Box
	_img_bg: Laya.Image
	_lb_title: Laya.Label
	_lb_tips: Laya.Label
	_Label1: Laya.Label
	_img_box: Laya.Image
	_gp_get: Laya.Box
	_Image1: Laya.Image
	_Label2: Laya.Label
	anim_id
	background_alpha
	change_scene_close
	click_bg_toClose
	data
	destroy_callback
	destroy_imm
	is_center
	model
	preload_server_config
	show_open_movie
	use_background

	public constructor() {
		super()
		this.base_file = "kfHolyArea"
		this.layout_file = "KfHolyAreaOwnerView"
		this.model = KfHolyAreaModel.GetInstance()
		this.layer_value = Enum_UILayer.Activity
		this.show_open_movie = true
		this.is_center = true
		this.destroy_imm = true
		this.change_scene_close = true
		this.use_background = true
		this.background_alpha = 0.7
		this.click_bg_toClose = false
		this.load_callback = () => {
			this.LoadSuccess()
		}

		this.destroy_callback = () => {
			this.Remove()
		}
		this.preload_server_config = { "config_c_sanctuary_construction": false }
	}



	public Open(...new_args) {
		let parm = new_args
		if (parm) {
			this.data = parm[0]
		}
		super.Open()
	}

	public LoadSuccess() {
		//ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("kfHolyArea", "uikfsy_035"))
		ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("common4", "uijs_062"))
		this.InitEvent()
		this.UpdateView()
	}

	public InitEvent() {
		Util.AddClickEvent(this._img_box, () => {
			let data = this.data
			if (data) {
				let scene_data = this.model.GetSceneData(data.scene)
				if (scene_data) {
					let cfg = this.model.GetBuildCfg(scene_data.con_type)
					if (cfg) {
						let preview_list = JSON.parse(cfg.reward)
						let vo = preview_list && preview_list[0]
						if (vo) {
							UIToolTipMgr.GetInstance().DefaultAppendTips(vo[1], Number(vo[2]))
						}
					}
				}
			}
		}, this, false)



		Util.AddClickEvent(this._gp_get, () => {
			let data = this.data
			if (data) {
				this.model.Fire(KfHolyAreaModel.REQUEST_CCMD_EVENT, 28408, data.scene)
			}
			this.Close()
		}, this, true)
	}

	public UpdateView() {
		let data = this.data
		if (data) {
			let scene_info = SceneManager.GetInstance().GetSceneInfo(data.scene)
			this._lb_title.text = "成功占领了" + scene_info.name + "!"
			this._lb_tips.text = "在本服所有成员的努力下成功占领" + scene_info.name + "!\n请领取属于您的归属奖励！"
			ResManager.GetInstance().SetImageSprite(this, this._img_box, "kfHolyArea_asset", "box_" + data.con_type + "_0")
		}
		this.StartAction()
		// this.AddUIEffect("ui_aperture", this._gp_effect, null, null, true)
	}

	public StartAction() {
		this.StopAction()
		this.anim_id = SYTweenLite.to(this, this._img_box, SYTweenLite.UiAnimationType.ROTATION, 20, 1.5, null, SYTweenFunc.PINGPONG, true)
	}

	public StopAction() {
		if (this.anim_id) {
			SYTweenLite.Stop(this.anim_id)
			this._img_box.rotation = 0
			this.anim_id = null
		}
	}

	public Remove() {
		this.StopAction()
		// this.ClearUIEffect(this._gp_effect)
	}

	public GetComponents() {
		[
			this._gp_effect,
			this._img_bg,
			this._lb_title,
			this._lb_tips,
			this._Label1,
			this._img_box,
			this._gp_get,
			this._Image1,
			this._Label2,
		]
			= this.GetChildrenByNames([

				"_gp_effect",
				"_img_bg",
				"_lb_title",
				"_lb_tips",
				"_Label1",
				"_img_box",
				"_gp_get",
				"_Image1",
				"_Label2",
			])
	}
}
window["KfHolyAreaOwnerView"] = KfHolyAreaOwnerView
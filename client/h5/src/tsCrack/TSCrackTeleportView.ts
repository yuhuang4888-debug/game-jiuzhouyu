import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { TSCrackModel } from "../commonModel/TSCrackModel"
import { GameResPath } from "../util/GameResPath"

export class TSCrackTeleportView extends BaseView1 {
	_gp_effect1: Laya.Box
	_img_bg: Laya.Image
	_Image1: Laya.Image
	_Image2: Laya.Image
	_gp_effect: Laya.Box
	id
	ts_crack_model









	public constructor() {
		super()


		this.base_file = "tsCrack"

		this.layout_file = "TSCrackTeleportView"

		this.layer_value = Enum_UILayer.Activity

		this.destroy_imm = true

		this.is_center = true

		this.use_background = true

		this.click_bg_toClose = true

		this.show_open_movie = true

		this.change_scene_close = true



		this.ts_crack_model = TSCrackModel.GetInstance()



		this.load_callback = () => {

			this.LoadSuccess()

		}



		this.open_callback = () => {
			this._gp_effect.width = 720
			this._gp_effect.height = 1280
			this.AddUIEffect("UI_caijiglow", this._gp_effect)

		}



		this.close_callback = () => {

			this.ts_crack_model.Fire(TSCrackModel.REQUEST_PROTO, 20403, this.id)

		}

	}



	public LoadSuccess() {






		this.UpdateView()

		ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("tsCrack", "uiskshcsm_001"))

		//ResManager.GetInstance().SetOutsideImageSprite(this, this._Image1, GameResPath.GetIcon("tsCrack", "uiskshcsm_002"))

		// this.AddUIEffect("ui_portal_2", this._gp_effect1, null, null, true)







	}



	public InitEvent() {




	}



	public UpdateView() {


		setTimeout(() => {

			if (this.use_delete_method) { return }

			this.Close()

		}, 2000)

	}



	public Open(...new_args) {


		let parms = new_args

		this.id = parms[0]

		super.Open()

	}




	public GetComponents() {
		[
			this._gp_effect1,
			this._img_bg,
			this._Image1,
			this._Image2,
			this._gp_effect,
		]
			= this.GetChildrenByNames([

				"_gp_effect1",
				"_img_bg",
				"_Image1",
				"_Image2",
				"_gp_effect",
			])
	}
}
window["TSCrackTeleportView"] = TSCrackTeleportView
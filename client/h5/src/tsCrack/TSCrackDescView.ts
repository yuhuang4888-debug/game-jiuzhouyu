import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { TSCrackModel } from "../commonModel/TSCrackModel"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"

export class TSCrackDescView extends BaseView1 {
	_img_bg: Laya.Image
	_lb_desc: Laya.Label
	InitEvent
	LoadSuccess
	UpdateView
	act_key
	ts_crack_model

	public constructor() {
		super()




		this.base_file = "tsCrack"

		this.layout_file = "TSCrackDescView"

		this.layer_value = Enum_UILayer.Activity

		this.destroy_imm = true

		this.use_background = true

		this.click_bg_toClose = true

		this.show_open_movie = true

		this.change_scene_close = true
		this.is_center = true



		this.ts_crack_model = TSCrackModel.GetInstance()
		this.preload_client_config = {
			"ConfigTSCrack": false
		}


		this.load_callback = () => {

			this.LoadSuccess()

		}



		this.LoadSuccess = () => {



			ResManager.GetInstance().SetImageSpriteTrans(this, this._img_bg, GameResPath.GetIcon("tsCrack", "uisksh_114"))



			this.UpdateView()

			this.InitEvent()

		}



		this.InitEvent = () => {



		}



		this.UpdateView = () => {
			let cfg_ = ResManager.GetInstance().GetGameConfigFromCache(this, "ConfigTSCrack", true)
			let cfg = cfg_ && cfg_["act"] && cfg_["act"][this.act_key]

			if (cfg) {
				
				this._lb_desc.text = Util.StrToHTML(cfg.desc)

			}

		}

	}



	public Open(...new_args) {


		let parms = new_args

		this.act_key = parms[0]

		super.Open()

	}






	public GetComponents() {
		[
			this._img_bg,
			this._lb_desc,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_lb_desc",
			])
	}
}
window["TSCrackDescView"] = TSCrackDescView
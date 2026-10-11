import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { TSCrackModel } from "../commonModel/TSCrackModel"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"

export class TSCrackInstructionView extends BaseView1 {
	_img_bg: Laya.Image
	_img_close: Laya.Image
	desc0: Laya.HTMLDivElement
	desc1: Laya.HTMLDivElement
	desc2: Laya.HTMLDivElement
	desc3: Laya.HTMLDivElement
	_Image2: Laya.Image
	InitEvent
	LoadSuccess
	ts_crack_model









	public constructor() {
		super()


		this.base_file = "tsCrack"

		this.layout_file = "TSCrackInstructionView"

		this.layer_value = Enum_UILayer.Activity

		this.destroy_imm = true

		this.use_background = true

		this.click_bg_toClose = true

		this.show_open_movie = true
		this.is_center = true

		this.change_scene_close = true





		this.ts_crack_model = TSCrackModel.GetInstance()

		this.preload_client_config = {
			"ConfigTSCrack": false
		}

		this.load_callback = () => {

			this.LoadSuccess()

		}



		this.LoadSuccess = () => {



			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("tsCrack", "uisksh_115"))
			let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "ConfigTSCrack", true)
			let ins = cfg.instroduce
			if (ins) {
				for (let key in ins) {
					let des = ins[key]
					this[`desc${key}`].style.fontSize = 18
					this[`desc${key}`].style.color = "#832c1b"
					this[`desc${key}`].style.wordWrap = false
					this[`desc${key}`].innerHTML = des
				}
			}

			this.InitEvent()

		}



		this.InitEvent = () => {

			Util.AddClickEvent(this._img_close, () => {

				this.Close()

			}

				, this, true)

		}

	}







	public GetComponents() {
		[
			this._img_bg,
			this._img_close,
			this.desc0,
			this.desc1,
			this.desc2,
			this.desc3,
			this._Image2,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_img_close",
				"desc0",
				"desc1",
				"desc2",
				"desc3",
				"_Image2",
			])
	}
}
window["TSCrackInstructionView"] = TSCrackInstructionView
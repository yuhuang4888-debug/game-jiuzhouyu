import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { LuaSoundManager } from "../common/SoundManager"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"

export class HolyBattleInstructionView extends BaseView1 {
	LoadSuccess
	change_scene_close
	click_bg_toClose
	destroy_imm
	is_center
	show_open_movie
	use_background

	public constructor() {
		super()


		this.base_file = "holyBattle"
		this.layout_file = "HolyBattleInstructionView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.is_center = true
		this.use_background = true
		this.click_bg_toClose = true
		this.show_open_movie = true
		this.change_scene_close = true

		this.load_callback = () => {

			this.LoadSuccess()
		}

		this.LoadSuccess = () => {
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("holyBattle", "uifh_104"))
			Util.AddClickEvent(this._img_close, () => {
				this.Close()
			}
				, this, true, null, null, null, null, LuaSoundManager.SOUND_UI.CLOSE)
		}


	}

	public DeleteMe(){
		super.DeleteMe()
	}

	_img_bg: Laya.Image
	_img_close: Laya.Image
	public GetComponents() {
		[
			this._img_bg,
			this._img_close,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_img_close",
			])
	}
}
window["HolyBattleInstructionView"] = HolyBattleInstructionView
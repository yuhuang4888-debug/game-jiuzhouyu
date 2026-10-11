import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { BaseDungeonModel } from "../commonModel/BaseDungeonModel"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"

export class DungeonDragonNoneView extends BaseView1 {
	InitEvent
	LoadSuccess
	Remove
	UpdateGxState
	UpdateView
	click_bg_toClose
	destroy_callback
	destroy_imm
	is_center
	show_open_movie
	use_background


	public constructor() {
		super()

		let local_Util = Util
		let _state = false
		this.base_file = "dungeonDragon"
		this.layout_file = "DungeonDragonNoneView"
		this.layer_value = Enum_UILayer.Activity
		this.show_open_movie = true
		this.is_center = true
		this.destroy_imm = true
		this.use_background = true
		this.click_bg_toClose = true
		this.load_callback = () => {

			this.LoadSuccess()
		}

		this.destroy_callback = () => {
			this.Remove()
		}

		this.LoadSuccess = () => {
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("kfHolyArea", "uikfsy_035"), true)
			this.InitEvent()
			this.UpdateView()
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._gp_get, () => {
				this.Close()
			}
				, this, true)
			Util.AddClickEvent(this._img_gx, () => {
				_state = !_state
				this.UpdateGxState()
			}
				, this, true)
		}

		this.UpdateView = () => {
			// this.AddUIEffect("ui_aperture", this._gp_effect, null, null, true)
		}

		this.Remove = () => {
			BaseDungeonModel.GetInstance().none_alert = _state
			// this.ClearUIEffect(this._gp_effect)
			_state = false
		}

		this.UpdateGxState = () => {
			ResManager.GetInstance().SetImageSprite(this, this._img_gx, "common_asset", (_state && ("com_ui_gx1") || ("com_ui_gx")))
		}
	}

	_gp_effect: Laya.Box
	_img_bg: Laya.Image
	_Label1: Laya.Label
	_Label2: Laya.Label
	_gp_get: Laya.Box
	_Image1: Laya.Image
	_Label3: Laya.Label
	_Image2: Laya.Image
	_img_gx: Laya.Image
	_Label4: Laya.Label
	public GetComponents() {
		[
			this._gp_effect,
			this._img_bg,
			this._Label1,
			this._Label2,
			this._gp_get,
			this._Image1,
			this._Label3,
			this._Image2,
			this._img_gx,
			this._Label4,
		]
			= this.GetChildrenByNames([

				"_gp_effect",
				"_img_bg",
				"_Label1",
				"_Label2",
				"_gp_get",
				"_Image1",
				"_Label3",
				"_Image2",
				"_img_gx",
				"_Label4",
			])
	}
}
window["DungeonDragonNoneView"] = DungeonDragonNoneView
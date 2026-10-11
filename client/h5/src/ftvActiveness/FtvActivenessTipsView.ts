import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { Util, SetSizeDeltaY } from "../util/Util"

export class FtvActivenessTipsView extends BaseView1 {
	_Image1: Laya.Image
	_Image2: Laya.Image
	_btn_ok: Laya.Image
	_title_lb: Laya.Label
	_gp_desc: Laya.Box
	_lb_dec: Laya.Label
	InitEvent
	InitView
	SetData
	click_bg_toClose
	destroy_imm
	is_center
	show_open_movie
	use_background

	public constructor() {
		super()


		let data_ = null

		this.base_file = "ftvActiveness"
		this.layout_file = "FtvActivenessTipsView"
		this.is_center = true
		this.use_background = true
		this.click_bg_toClose = true
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.show_open_movie = true
		this.load_callback = () => {

			this.InitEvent()
			this.InitView()
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._btn_ok, () => {
				this.Close()
			}
				, this, true)
		}

		this.InitView = () => {
			if (data_) {
				this._lb_dec.text = data_.desc
			}
		}

		this.SetData = (data?) => {
			data_ = data
		}
	}


	public GetComponents() {
		[
			this._Image1,
			this._Image2,
			this._btn_ok,
			this._title_lb,
			this._gp_desc,
			this._lb_dec,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_Image2",
				"_btn_ok",
				"_title_lb",
				"_gp_desc",
				"_lb_dec",
			])
	}
}
window["FtvActivenessTipsView"]=FtvActivenessTipsView
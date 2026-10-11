import { BaseItem1 } from "../common/BaseItem1"
import { ResManager } from "../common/ResManager"
import { TSCrackModel } from "../commonModel/TSCrackModel"
import { Color, Util } from "../util/Util"

export class TSCrackTabItem extends BaseItem1 {
	_Image1: Laya.Image
	_lb_name: Laya.Label
	_img_red: Laya.Image
	Out_lb_name
	cache_data
	cache_red_state
	cache_select_state
	id
	index



	public constructor(parent) {
		super(parent)


		this.base_file = "tsCrack"

		this.layout_file = "TSCrackTabItem"
		this.load_callback = () => {
			Util.AddClickEvent(this._Image1, () => {

				TSCrackModel.GetInstance().Fire(TSCrackModel.CLICK_TAB, this.id, this.index)

			}, this, true)



			if (this.cache_data != null) {

				this.SetData(this.cache_data)

				this.cache_data = null

			}



			if (this.cache_red_state != null) {

				this.SetRedState(this.cache_red_state)

				this.cache_red_state = null

			}



			if (this.cache_select_state != null) {

				this.SetSelectState(this.cache_select_state)

				this.cache_select_state = null

			}
		}
	}



	// public load_callback() {




	// 	// if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {

	// 	// 	let csf = this._lb_name.GetComponent("ContentSizeFitter")

	// 	// 	csf.horizontalFit = UnityEngine.UI.ContentSizeFitter.FitMode.Unconstrained

	// 	// 	csf.verticalFit = UnityEngine.UI.ContentSizeFitter.FitMode.Unconstrained

	// 	// 	SetSizeDelta(this._lb_name,140,50)

	// 	// 	this._lb_name.size  = 20

	// 	// 	this._lb_name.lineSpacing = 0.7

	// 	// }



	// }



	public SetData(data?) {


		if (this.is_loaded) {

			this._lb_name.text = data.name

			this.id = data.id

			this.index = data.index

		} else {
			this.cache_data = data

		}



	}



	public SetRedState(red_state?) {


		if (this.is_loaded) {

			this._img_red.visible = red_state

		} else {
			this.cache_red_state = red_state

		}

	}



	public SetSelectState(select_state?) {


		if (this.is_loaded) {

			if (select_state) {

				this._lb_name.color = "#ffffff"

				this._lb_name.strokeColor = "#ad455c"

				ResManager.GetInstance().SetImageSprite(this, this._Image1, this.base_file + "_asset", "uilwmb_041", true)

			} else {
				this._lb_name.color = "#4f538f"

				this._lb_name.strokeColor = "#c6c3f4"

				ResManager.GetInstance().SetImageSprite(this, this._Image1, this.base_file + "_asset", "uilwmb_042", true)

			}

		} else {
			this.cache_select_state = select_state

		}



	}




	public GetComponents() {
		[
			this._Image1,
			this._lb_name,
			this._img_red,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_lb_name",
				"_img_red",
			])
	}
}
window["TSCrackTabItem"] = TSCrackTabItem
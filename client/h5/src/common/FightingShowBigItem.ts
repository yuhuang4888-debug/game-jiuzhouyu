import { SetSizeDeltaY, SetSizeDeltaX } from "../util/Util";
import { Vector2 } from "../util/Vector2";
import { BaseItem1 } from "./BaseItem1";
import { ResManager } from "./ResManager";

export class FightingShowBigItem extends BaseItem1 {
	public _gp_fire_effect: Laya.Box;
	public _Group1: Laya.Box;
	public _img: Laya.Image;
	public _lb_fighting: Laya.Label;

	Font_name: string = "font_1"
	bitmapFont: Laya.BitmapFont
	HideEffect
	LoadSuccess
	UpdateView
	Updatefighting
	onLoaded
	public constructor(parent) {
		super(parent)
		let _fire_effect_index_ = null
		let _fighting = null
		let _img_res = null
		let _load_state = false
		let _need_refresh = false
		let _hideEffect = false
		this.base_file = "common"
		this.layout_file = "FightingShowBigItem"
		this.load_callback = () => {
			this.LoadSuccess()
		}

		this.LoadSuccess = () => {
			_load_state = true
			if (_need_refresh) {
				this.UpdateView()
			}
		}

		this.Updatefighting = (fighting?, img_res?) => {
			_fighting = fighting
			_img_res = img_res
			if (_load_state) {
				this.UpdateView()
			} else {
				_need_refresh = true
			}
		}

		this.UpdateView = () => {
			if (!_load_state) {
				return
			}
			if (_img_res) {
				// ResManager.GetInstance().SetImageSprite(this, this._img.GetComponent("Image"), "common_asset", _img_res)
			}
			let fighting = _fighting

			this._lb_fighting.text = fighting
			fighting = String(fighting)
			let len = fighting.length
			let index = 10
			let width = 290
			if (len < 6) {
				index = 6
				width = 230
			} else if (len > 5 && len < 8) {
				index = 8
				width = 260
			} else if (len > 7) {
				index = 10
				width = 290
			}
			//if (index != _fire_effect_index_ ) {
			//let pos = Vector2(-(width - this.width) / 2, 0)
			//if (this._gp_fire_effect ) {
			//lua_resM:ClearUIEffect(this._gp_fire_effect)
			// if (!_hideEffect) {
			let layer = this.layer_value || "UI"
			// 	ResManager.GetInstance().SetUIEffect(this, "UI_1104", layer, this._gp_fire_effect.transform, null, null, true)

			// 	let curr_sorting_order = this.AddCurrLayerSortingOrder(layer)
			// 	this.CoverEffect(this._Group1, layer, curr_sorting_order)
			// }

			//}
			//}
			_fire_effect_index_ = index
			// SetSizeDeltaX(this.form, 90 + this._lb_fighting.preferredWidth)
			// UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(this._Group1)
		}

		this.HideEffect = (bool?) => {
			_hideEffect = bool
		}
	}

	public DeleteMe() {
		//if (this._gp_fire_effect ) {
		//lua_resM:ClearUIEffect(this._gp_fire_effect)
		//}
		super.DeleteMe()
	}

	public GetComponents() {
		[
			this._gp_fire_effect,
			this._Group1,
			this._img,
			this._lb_fighting,
		]
			= this.GetChildrenByNames([

				"_gp_fire_effect",
				"_Group1",
				"_img",
				"_lb_fighting",
			])
		ResManager.GetInstance().LoadFont(this, "fighting_font", this._lb_fighting,60)
	}
}
window["FightingShowBigItem"] = FightingShowBigItem
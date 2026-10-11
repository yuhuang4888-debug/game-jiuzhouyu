import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { Color } from "../util/Util"
import { ResManager } from "../common/ResManager"
import { Util } from "../util/Util"
export class TopPlayerTabItem extends BaseItemRenderer {
	_img_bg: Laya.Image
	_lb_name: Laya.Label
	_img_red: Laya.Image
	public static width = 166
	public static height = 84
	WIDTH = 158
	HEIGT = 68

	public constructor(parent) {
		super()


		this.base_file = "topPlayer"
		this.layout_file = "TopPlayerTabItem"
		this.load_callback = () => {

			this.BindEvent(CustomActivityModel.GetInstance(), CustomActivityDefine.EVENT.CLICK_TOPPLAYER_TAB, (index?) => {
				if (this.index == index) {
					this._lb_name.color = "#9b572f"
					ResManager.GetInstance().SetImageSprite(this, this._img_bg, "topPlayer_asset", "uikf_002", true)
				} else {
					let state = this.data.state
					// [ts2lua]lua中0和空字符串也是true，此处state需要确认
					let color = "#ffffff"
					this._lb_name.color = color
					ResManager.GetInstance().SetImageSprite(this, this._img_bg, "topPlayer_asset", "uikf_003", true)
					// if (state) {


					// }
					// else {

					// }

					// [ts2lua]lua中0和空字符串也是true，此处state需要确认
					//this._lb_name.strokeColor = (state && ( "#A17C68" ) || ( "#cfcfcf" ) )
				}
			})
			// if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
			// 	this._lb_name.size  = 20
			// }
		}
		this.Load()
	}

	public dataChanged() {
		if (super.dataChanged()) {
			let state = this.data.state
			//let states = this.skin.states
			//for (let _tmpi in states) {
			// let vo = states[_tmpi]
			// //if (vo.name == "down" ) {
			// //for (let _tmpi in vo.overrides) {
			// var v = vo.overrides[_tmpi]
			//let sp = v
			//if (sp.target == "_img_bg" && sp.name == "source" ) {
			//// [ts2lua]lua中0和空字符串也是true，此处state需要确认
			//sp.value = (state && ( "kaifuactivity_asset.uikf_002" ) || ( "kaifuactivity_asset.uikf_003" ) )
			//}
			//if (sp.target == "_img_bg" && sp.name == "x" ) {
			//// [ts2lua]lua中0和空字符串也是true，此处state需要确认
			//sp.value = (state && ( 0 ) || ( 3 ) )
			//}
			//if (sp.target == "_lb_name" && sp.name == "color" ) {
			//// [ts2lua]lua中0和空字符串也是true，此处state需要确认
			//sp.value = (state && ( "0xffffff" ) || ( "0x808080" ) )
			//}
			//if (sp.target == "_lb_name" && sp.name == "strokeColor" ) {
			//// [ts2lua]lua中0和空字符串也是true，此处state需要确认
			//sp.value = (state && ( "0xb3663c" ) || ( "0xcfcfcf" ) )
			//}
			//}
			//break
			//}
			//}
			if (this.selected && state) {
				this._lb_name.color = "#9b572f"//Color(255, 255, 255, 1)
				this._lb_name.text = this.data.name
				//Util.SetImageGray(this._img_bg, false)
				this._img_red.visible = this.data.red_state
				ResManager.GetInstance().SetImageSprite(this, this._img_bg, "topPlayer_asset", "uikf_002", true)
			} else {
				//let state = this.data.state
				// [ts2lua]lua中0和空字符串也是true，此处state需要确认
				let color = "#ffffff"//Color(223 / 255, 205 / 255, 195 / 255, 1)
				this._lb_name.color = color
				ResManager.GetInstance().SetImageSprite(this, this._img_bg, "topPlayer_asset", "uikf_003", true)
				if (state) {

					this._lb_name.text = this.data.name
					//Util.SetImageGray(this._img_bg, false)
					this._img_red.visible = this.data.red_state
				} else {
					this._lb_name.text = "敬请期待"
					this._img_red.visible = false
					//Util.SetImageGray(this._img_bg, true)
				}
			}
		}
	}







	public GetComponents() {
		[
			this._img_bg,
			this._lb_name,
			this._img_red,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_lb_name",
				"_img_red",
			])
	}
}
window["TopPlayerTabItem"] = TopPlayerTabItem
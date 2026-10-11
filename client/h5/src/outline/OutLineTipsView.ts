import { BaseAlert } from "../alert/BaseAlert"
import { Enum_UILayer } from "../common/LayerManager"
import { BaseAwardItem } from "../common/BaseAwardItem"

export class OutLineTipsView extends BaseAlert {
	LoadSuccess
	awardItem_

	public constructor(show_content?, type?, ok_callback?, cancel_callback?, ok_text?, cancel_text?, left_time?, is_close_hide?, check_callback?, check_text?, use_background?, good_source?, target_text?, title_text?, goodsType?, show_close_ani?, title_img?, close_back?) {
		super(show_content, ok_callback, cancel_callback, ok_text, cancel_text, left_time, is_close_hide, check_callback, check_text, use_background, good_source, target_text, title_text, null, null, show_close_ani, title_img, close_back)
		this.base_file = "outline"
		this.layout_file = "OutLineTipsView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true

		let alert_type_ = null
		let goodsType_ = null
		let awardItem_ = null
		alert_type_ = type
		goodsType_ = goodsType

		this.destroy_callback = () => {
			if (this.awardItem_) {
				this.awardItem_.DeleteMe()
				this.awardItem_ = null
			}
		}

		this.LoadSuccess = () => {
			if (goodsType_ && !awardItem_) {
				awardItem_ = new BaseAwardItem(this.itemGroup, null, null, false)
				awardItem_.Load()
				awardItem_.ExcuteCallback(() => {
					// if (PlatformMgr.GetInstance().IsEyouIdnPlatform()) {
					// 	this._content.size = 16
					// 	this._content.lineSpacing = 0.7
					// }
				})
				awardItem_.SetData(goodsType_)
				awardItem_.SetItemSize(100, 100)
				this.awardItem_ = awardItem_
			}

			// if (PlatformMgr.GetInstance().IsEyouEnPlatform()) {
			// 	SetSizeDeltaX(this._Image5, 120)
			// 	SetAnchoredPositionX(this._Image5, 183)
			// 	this._content.size = 18
			// }
		}
	}

	public SetBaseInfo() {
		super.SetBaseInfo()
		this._content_html.y = 121
	}

	bg: Laya.Image
	_content: Laya.Box
	_content_html: Laya.HTMLDivElement
	itemGroup: Laya.Box
	_close_btn: Laya.Image
	_cancel_btn: Laya.Image
	cancel_label: Laya.Label
	_ok_btn: Laya.Image
	ok_label: Laya.Label
	public GetComponents() {
		[
			this.bg,
			this._content,
			this._content_html,
			this.itemGroup,
			this._close_btn,
			this._cancel_btn,
			this.cancel_label,
			this._ok_btn,
			this.ok_label,
		]
			= this.GetChildrenByNames([

				"bg",
				"_content",
				"_content_html",
				"itemGroup",
				"_close_btn",
				"_cancel_btn",
				"cancel_label",
				"_ok_btn",
				"ok_label",
			])
	}
}
window["OutLineTipsView"] = OutLineTipsView
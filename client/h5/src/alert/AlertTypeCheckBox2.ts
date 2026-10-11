import { PlatformManager } from "../PlatformManager"
import { BaseAlert } from "./BaseAlert"

export class AlertTypeCheckBox2 extends BaseAlert {
	public constructor(show_content, type, ok_callback, cancel_callback, ok_text, cancel_text, left_time, is_close_hide, check_callback, check_text, use_background, good_source, target_text, title_text, three_top_text, three_down_text, show_close_ani, title_img, close_callback) {
		super(show_content, ok_callback, cancel_callback, ok_text, cancel_text, 
			left_time, is_close_hide, check_callback, check_text, 
			use_background, good_source, target_text, title_text, 
			three_top_text, three_down_text, show_close_ani, title_img, close_callback,type)
		this.base_file = "alert"
		this.layout_file = "AlertTypeCheckBox2"
		this.destroy_imm = true
	}

	public LoadSuccess() {
		super.LoadSuccess()
	}

	public Close() {
		let self = this
		if (self.cancel_callback)
			self.cancel_callback = undefined
		super.Close()
	}
	bg: Laya.Image
	_content: Laya.Box
	_content_html: Laya.HTMLDivElement
	_cancel_btn: Laya.Image
	cancel_label: Laya.Label
	_ok_btn: Laya.Image
	ok_label: Laya.Label
	check: Laya.Box
	_close_btn: Laya.Box
	public GetComponents() {
		[
			this.bg,
			this._content,
			this._content_html,
			this._cancel_btn,
			this.cancel_label,
			this._ok_btn,
			this.ok_label,
			this.check,
			this._close_btn,
		]
			= this.GetChildrenByNames([
				"bg",
				"_content",
				"_content_html",
				"_cancel_btn",
				"cancel_label",
				"_ok_btn",
				"ok_label",
				"check",
				"_close_btn",
			])
	}
}
window["AlertTypeCheckBox2"] = AlertTypeCheckBox2
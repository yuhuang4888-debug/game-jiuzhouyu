import { BaseAlert } from "./BaseAlert"

export class AlertTypeCheckBox extends BaseAlert {
	//public
	public is_hide_check
	public alert_type: number
	public constructor(show_content, type, ok_callback, cancel_callback, ok_text, cancel_text, left_time, is_close_hide, check_callback, check_text, use_background, good_source, target_text, title_text, three_top_text, three_down_text, show_close_ani, title_img, close_callback,is_hide_check) {
		super(show_content, ok_callback, cancel_callback, ok_text, cancel_text, left_time, is_close_hide, check_callback, check_text, use_background, good_source, target_text, title_text, three_top_text, three_down_text, show_close_ani, title_img, close_callback)
		this.base_file = "alert"
		this.layout_file = "AlertTypeCheckBox"
		this.alert_type = type
		this.destroy_imm = true
		this.is_hide_check=is_hide_check
	}

	public LoadSuccess() {
		super.LoadSuccess()
		if(this.is_hide_check){
			this.check.visible=false
			this._content.y=160
		}
	}
	bg: Laya.Image
	_content: Laya.Box
	_content_html: Laya.HTMLDivElement
	_close_btn: Laya.Image
	_cancel_btn: Laya.Image
	cancel_label: Laya.Label
	_ok_btn: Laya.Image
	ok_label: Laya.Label
	check: Laya.Box
	public GetComponents() {
		[
			this.bg,
			this._content,
			this._content_html,
			this._close_btn,
			this._cancel_btn,
			this.cancel_label,
			this._ok_btn,
			this.ok_label,
			this.check,
		]
			= this.GetChildrenByNames([
				"bg",
				"_content",
				"_content_html",
				"_close_btn",
				"_cancel_btn",
				"cancel_label",
				"_ok_btn",
				"ok_label",
				"check",
			])
	}
}
window["AlertTypeCheckBox"] = AlertTypeCheckBox
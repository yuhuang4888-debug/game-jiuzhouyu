import { BaseAlert } from "./BaseAlert"

// TypeScript file
export class AlertTypeThree extends BaseAlert {
	//public
	public alert_type: number
	public constructor(show_content, type, ok_callback, cancel_callback, ok_text, cancel_text, left_time, is_close_hide, check_callback, check_text, use_background, good_source, target_text, title_text, three_top_text, three_down_text, show_close_ani, title_img, close_callback) {
		super(show_content, ok_callback, cancel_callback, ok_text, cancel_text, left_time, is_close_hide, check_callback, check_text, use_background, good_source, target_text, title_text, three_top_text, three_down_text, show_close_ani, title_img, close_callback)
		this.base_file = "alert"
		this.layout_file = "AlertTypeThree"
		this.alert_type = type
		this.destroy_imm = true
	}

	public LoadSuccess() {
		super.LoadSuccess()
	}
	bg: Laya.Image
	_content: Laya.Box
	_content_html: Laya.HTMLDivElement
	_close_btn: Laya.Image
	_cancel_btn: Laya.Image
	cancel_label: Laya.Label
	_ok_btn: Laya.Image
	ok_label: Laya.Label
	_lb_top_html: Laya.HTMLDivElement
	_lb_down_html: Laya.HTMLDivElement
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
			this._lb_top_html,
			this._lb_down_html,
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
				"_lb_top_html",
				"_lb_down_html",
			])
	}
}
window["AlertTypeThree"] = AlertTypeThree
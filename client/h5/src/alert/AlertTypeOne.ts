import { EventName } from "../common/EventName"
import { TaskTipType } from "../commonModel/TaskModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { BaseAlert } from "./BaseAlert"

export class AlertTypeOne extends BaseAlert {
	//public
	public alert_type: number
	public constructor(show_content, type, ok_callback, cancel_callback, ok_text, cancel_text, left_time, is_close_hide, check_callback, check_text, use_background, good_source, target_text, title_text, three_top_text, three_down_text, show_close_ani, title_img, close_callback) {
		super(show_content, ok_callback, cancel_callback, ok_text, cancel_text, left_time, is_close_hide, check_callback, check_text, use_background, good_source, target_text, title_text, three_top_text, three_down_text, show_close_ani, title_img, close_callback)
		this.base_file = "alert"
		this.layout_file = "AlertTypeOne"
		this.alert_type = type
		this.destroy_imm = true
	}

	public LoadSuccess() {
		if(this.story_model.task_supplement_list["AlertTypeOne"]){
			let step1 =
			{
                "direction": 8,
                "text": "没有更好的装备？试试<font color='#0a9f42'>去战胜大妖</font>吧！"
            }
			GlobalEventSystem.Fire(EventName.SHOW_FINGER, this, this._ok_btn, "UI", null, null, null, null, step1, true)
		}
		super.LoadSuccess()
	}
	public Close() {
		if(this.story_model.task_supplement_list["AlertTypeOne"]){
			delete this.story_model.task_supplement_list["AlertTypeOne"]
		}
		super.Close()
	}
	bg: Laya.Image
	_content: Laya.Box
	_content_html: Laya.HTMLDivElement
	_close_btn: Laya.Image
	_ok_btn: Laya.Image
	ok_label: Laya.Label
	public GetComponents() {
		[
			this.bg,
			this._content,
			this._content_html,
			this._close_btn,
			this._ok_btn,
			this.ok_label,
		]
			= this.GetChildrenByNames([
				"bg",
				"_content",
				"_content_html",
				"_close_btn",
				"_ok_btn",
				"ok_label",
			])
	}
}
window["AlertTypeOne"] = AlertTypeOne
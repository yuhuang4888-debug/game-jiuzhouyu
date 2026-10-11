import { AlertTypeTwo } from "../alert/AlertTypeTwo"
import { EventName } from "../common/EventName"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"

export class BossArrowAlert extends AlertTypeTwo {
	public constructor(show_content?, type1?, ok_callback?, cancel_callback?, ok_text?, cancel_text?, left_time?, is_close_hide?, check_callback?, check_text?, use_background?, good_source?, target_text?, title_text?, three_top_text?, three_down_text?, show_close_ani?, title_img?, close_callback?) {
		super(show_content, type1, ok_callback, cancel_callback, ok_text, cancel_text, left_time, is_close_hide, check_callback, check_text, use_background, good_source, target_text, title_text, three_top_text, three_down_text, show_close_ani, title_img, close_callback)


	}

	public LoadSuccess() {

		super.LoadSuccess()
		let setp_cfg = { direction:8, text:"点击退出<br>继续主线任务吧~","effect_scaleX": 0.65,"effect_scaleY": 0.9 }
		GlobalEventSystem.Fire(EventName.SHOW_FINGER, this, this._ok_btn, this.layer_value, null, 20, null, null, setp_cfg, true)
		//MainUIModel:GetInstance():Fire(MainUIModel.CHANGE_ACTIVITY_STATE, false)
	}

}
window["BossArrowAlert"] = BossArrowAlert
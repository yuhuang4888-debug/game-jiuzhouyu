import { BaseItem1 } from "../../common/BaseItem1";
import { Vector2 } from "../../util/Vector2";
import { BaseClass } from "../../common/BaseClass";
import { ResManager } from "../../common/ResManager";
import { GlobalTimerQuest, SetHtmlStyle, Util } from "../../util/Util";
import { GlobalEventSystem } from "../../util/DeclareGlobalVar";
import { ObjectEventType } from "../../common/EventName";
// TypeScript file
export class TalkBoard extends BaseItem1 {
	attach_pos: Vector2 = new Vector2(0, 0);
	attach_res_height = 0;
	off_height = 0;
	off_width = 0;
	_temp_hash_target = new BaseClass();
	needRefresh = false;
	timer_id;
	show_time = 5;
	content_cache;
	res_height_cache;
	time_cache;
	not_change_height;
	id
	count_time_id_
	html_width = 168
	call_back

	public constructor(parent: Laya.Sprite) {
		super(parent);
		this.base_file = "mainUI";
		this.layout_file = "TalkBoard";
		this.is_delay_callback = false;
		this.load_callback = () => {
			this.LoadSuccess();
		};
		//this.Load();
	}

	public CancelTimer() {
		if (this.count_time_id_) {
			GlobalTimerQuest.CancelQuest(this.count_time_id_)
			this.count_time_id_ = null
		}
	}

	public DeleteMe() {
		this.ReleaseData();
		super.DeleteMe();
	}

	public ResetData() {
	}

	protected LoadSuccess() {
		this.display_obj.scaleX = this.display_obj.scaleY = 0.8;
		if (this.needRefresh) {
			this.InitData(this.id, this.content_cache, this.res_height_cache, this.attach_pos, this.time_cache, this.not_change_height);
			this.needRefresh = false;
		}

	}
	public ReleaseData() {
		if (this.call_back) {
			this.call_back()
			this.call_back = null
		}
		this.CancelTimer()
		this.SetAttachResHeight(150);
		this.SetOffHeight(0);
		this.attach_res_height = 0;
		ResManager.GetInstance().DestroyAllReferenceRes(this._temp_hash_target.hashCode);
		this.SetVisible(false);
	}

	public InitData(id, content, res_height, pos, time, not_change_height?) {
		this.id = id;
		this.content_cache = content;
		this.res_height_cache = res_height;
		this.time_cache = time;
		this.not_change_height = not_change_height;
		if (this.is_loaded) {
			if (this.content_cache != null) this.SetContent(this.content_cache);
			if (this.res_height_cache != null) this.SetAttachResHeight(this.res_height_cache);
			if (pos != null) this.UpdatePos(pos.x, pos.y);
			if (this.time_cache != null) this.StartTimer(this.time_cache);
		}
		else {
			this.needRefresh = true;
		}
	}

	public UpdatePos(x?, y?) {
		this.attach_pos.x = x || this.attach_pos.x;
		this.attach_pos.y = y || this.attach_pos.y;
		if (!this.is_loaded) {
			this.needRefresh = true;
			return
		}

		this.display_obj.x = this.attach_pos.x + this.off_width;
		this.display_obj.y = this.attach_pos.y - this.off_height - this.attach_res_height;
	}

	public SetContent(content:string) {
		// console.warn("测试聊天气泡" + content)
		content = content.replace("<br/>", "\n")
		this.content_cache = content;
		if (!this.is_loaded) {
			this.needRefresh = true;
			return
		}

		this.SetVisible(true);
		this.content.text = this.content_cache
		let bg_height = this.content.textField.textHeight + 40
		let width = 20 + this.content.textField.textWidth
		this.content_bg.width = width > 200 ? 200 : width
		this.content_bg.height = bg_height > 60 ? bg_height : 60
		// let y_gap = (bg_height > 60) ? (bg_height - 60) : 0
		// this.content_conta.y = -y_gap
		// this.content_bg.y = -y_gap;
		// this.content.y = -y_gap + 9;
	}

	public SetAttachResHeight(value) {
		if (!this.not_change_height && Math.abs(this.attach_res_height - value) >= 20) {
			this.attach_res_height = value;
			if (!this.is_loaded) {
				this.needRefresh = true;
				return
			}
			this.display_obj.y = this.attach_pos.y - this.off_height - this.attach_res_height;
		}
	}

	public SetOffHeight(y: number) {
		if (this.not_change_height && this.off_height != 0)
			return;
		this.off_height = y;
		if (this.is_loaded) {
			this.off_height = y;
			this.display_obj.y = this.attach_pos.y - this.off_height - this.attach_res_height;
		}
	}

	public SetOffWidth(x: number) {
		this.off_width = x;
		if (this.is_loaded) {
			this.off_width = x;
			this.display_obj.x = this.attach_pos.x + this.off_width;
		}
	}

	public StartTimer(time, call_back?) {
		this.CancelTimer()
		this.show_time = time;
		this.call_back = call_back
		let time_fun = () => {
			this.OnTime()
		}
		this.count_time_id_ = GlobalTimerQuest.AddPeriodQuest(time_fun, 1, -1)
		this.OnTime()
	}

	public CanUpdatePos() {
		return true
	}

	public OnTime() {
		if (this.show_time != undefined) {
			this.show_time = this.show_time - 1;
			if (this.show_time < 0) {
				if (this.call_back) {
					this.call_back()
					this.call_back = null
				}
				this.SetVisible(false);
				this.CancelTimer();
				GlobalEventSystem.Fire(ObjectEventType.TALK_BOARD_TIME_OUT, this.id);
				return;
			}
		}
	}

	content_conta: Laya.Box
	content_bg: Laya.Image
	content: Laya.Label
	public GetComponents() {
		[
			this.content_conta,
			this.content_bg,
			this.content,
		]
			= this.GetChildrenByNames([
				"content_conta",
				"content_bg",
				"content",
			])
	}
}
window["TalkBoard"] = TalkBoard
import { BaseItem1 } from "../common/BaseItem1";
import { SysInfoMiniMgr } from "./SysInfoMiniMgr";
import { StateMachineManager } from "../util/StateMachineManager";
import { PlatformManager } from "../PlatformManager";
import { BaseState } from "../login/loginstate/ConnectGameState";
import { TimeUtil } from "../util/TimeUtil";
import { ResManager } from "../common/ResManager";
import { LayerManager } from "../common/LayerManager";
import { SetHtmlCenter } from "../util/Util";
export enum MessageItemState {
	born,
	alive,
	death
}
window["MessageItemState"] = MessageItemState;
export class BornState implements BaseState {
	state_finish = false;
	message_type;
	self;
	message_setting;
	dic_alpha;
	dic_scale;

	public constructor(self) {
		this.self = self
		this.message_type = self.message_type
		this.message_setting = SysInfoMiniMgr.MessageSetting[self.message_type]
	}

	public OnStateEnter = () => {
		this.self.display_obj.visible = true;
	}

	public OnStateUpdate = (now_time, elapse_time) => {
		let self = this;
		let dic_alpha = elapse_time / self.message_setting.once_move_time;
		let dic_scale = (1 - self.message_setting.default_scale) * elapse_time / self.message_setting.once_move_time;
		let alpha = self.self.display_obj.alpha + dic_alpha;
		if (alpha > 1)
			alpha = 1;
		self.self.display_obj.alpha = alpha;
		let scale = self.self.display_obj.scaleX + dic_scale;
		if (scale > 1)
			scale = 1;
		self.self.display_obj.scaleX = self.self.display_obj.scaleY = scale;
		if (scale == 1 && alpha == 1)
			self.state_finish = true;
		if (self.state_finish) {
			self.state_finish = false;
			self.self.ChangeState(MessageItemState.alive)
		}
	}

	public OnStateQuit = () => {
	}
}

export class AliveState implements BaseState {
	state_finish = false
	message_type
	self
	dic_y
	alive_time
	message_setting

	public constructor(self) {
		this.self = self
		this.message_type = self.message_type
		this.message_setting = SysInfoMiniMgr.MessageSetting[self.message_type]
	}

	public OnStateEnter = () => {
		SysInfoMiniMgr.GetInstance().TryShowMiniMsg(this.message_type)
		this.alive_time = TimeUtil.getClientTime() + this.message_setting.life_cycle
		if (this.message_type >= SysInfoMiniMgr.MessageType.Two) {
			this.self._tagret_x = this.self.display_obj.x + this.message_setting.fly_to_right_dis;
		}
	}

	public OnStateUpdate = (now_time, elapse_time) => {
		let self = this;
		if (self.self.MoveState) {
			let dic_y;
			if (PlatformManager.IsEyouEnPlatform())
				dic_y = self.self.display_obj.height * elapse_time / self.message_setting.once_move_time;
			else
				dic_y = self.message_setting.once_move_dis * elapse_time / self.message_setting.once_move_time;
			self.self.display_obj.y -= dic_y;
			if (self.self.display_obj.y <= self.self._tagret_y) {
				self.self.display_obj.y = self.self._tagret_y;
				self.self.MoveState = false;
			}
		}
		if (self.alive_time && TimeUtil.getClientTime() >= self.alive_time) {
			self.state_finish = true;
		}
		if (self.state_finish) {
			self.state_finish = false
			self.self.ChangeState(MessageItemState.death)
		}
	}
	public OnStateQuit = () => {
		this.alive_time = undefined;
	}
}

export class DeathState implements BaseState {
	state_finish = false;
	message_type;
	self;
	message_setting;
	stay_time;
	not_need_show_x_animation

	public constructor(self) {
		this.self = self;
		this.message_type = self.message_type;
		this.message_setting = SysInfoMiniMgr.MessageSetting[self.message_type];
	}

	public OnStateEnter = () => {
		let self = this
		this.stay_time = TimeUtil.getClientTime() + this.message_setting.stay_time;
		this.not_need_show_x_animation = Math.abs(self.self.display_obj.y) > (this.message_setting.max_show_count - 1) * this.message_setting.once_move_dis;
		if (this.message_type == SysInfoMiniMgr.MessageType.One || this.not_need_show_x_animation) {
			this.self.display_obj.visible = false;
			SysInfoMiniMgr.GetInstance().DeleteMsg(this.self.hashCode, this.message_type);
		}
	}

	public OnStateUpdate = (now_time, elapse_time) => {
		let self = this
		//let move_height = false
		if (!this.not_need_show_x_animation) {
			if (self.stay_time && TimeUtil.getClientTime() < self.stay_time) {
				return;
			}
			let dic_x = self.message_setting.once_move_x_dis * elapse_time / self.message_setting.once_move_x_time;
			self.self.display_obj.x += dic_x;
			let dic_alpha = 0.2 * elapse_time / self.message_setting.once_move_x_time;
			self.self.display_obj.alpha -= dic_alpha
			if (self.self.display_obj.alpha <= 0) {
				self.self.display_obj.alpha = 0
			}
			if (self.self.display_obj.x > self.self._tagret_x) {
				self.self.display_obj.x = self.self._tagret_x
				this.self.display_obj.visible = false
				SysInfoMiniMgr.GetInstance().DeleteMsg(this.self.hashCode, this.message_type)
				this.state_finish = true
			}
		}
		if (this.state_finish) {
			this.state_finish = false
		}
	}
	public OnStateQuit = () => {
	}
}


export class MessageItem extends BaseItem1 {
	//eui
	message_type;
	message_setting;
	state_machine;
	state_list;
	public constructor(parent, message_type) {
		super(parent);
		this.is_delay_callback = false;
		this.message_type = message_type;
		this.message_setting = SysInfoMiniMgr.MessageSetting[message_type];
		this.base_file = "sysInfo";
		this.layout_file = "MessageItem";
		this.state_machine = new StateMachineManager(this, "ChangeStateEnter", "ChangeStateLeave");
		if (!this.state_list)
			this.state_list = {};
		this.state_list[MessageItemState.born] = new BornState(this);
		this.state_machine.RegisterState(MessageItemState.born, "EnterState", "UpdateState", "QuitState", true);
		this.state_list[MessageItemState.alive] = new AliveState(this);
		this.state_machine.RegisterState(MessageItemState.alive, "EnterState", "UpdateState", "QuitState", true);
		this.state_list[MessageItemState.death] = new DeathState(this);
		this.state_machine.RegisterState(MessageItemState.death, "EnterState", "UpdateState", "QuitState", true);
		this.load_callback = function () {
			this.display_obj.anchorX = 0.5;
			this.display_obj.anchorY = 1;
			this.display_obj.alpha = 0;
			this.display_obj.visible = false;
			this.display_obj.scaleX = this.display_obj.scaleY = this.message_setting.default_scale;
			this._lb_content_html.style.color = "#ffffff"//"#88ff43"
			this._lb_content_html.style.fontSize = 32;
			this._lb_content_html.scale(0.5, 0.5, true);
			this._lb_content_html.style.bold = true
			this._lb_content_html.style.wordWrap=false
		};
	}
	public Update(now_time, elapse_time) {
		this.state_machine.Update(now_time, elapse_time);
	}
	private EnterState(state) {
		this.state_list[state].OnStateEnter();
	}
	private UpdateState(now_time, elapse_time) {
		let state = this.state_machine.GetCurrState();
		this.state_list[state].OnStateUpdate(now_time, elapse_time);
	}
	private QuitState(state) {
		this.state_list[state].OnStateQuit();
	}
	private ChangeStateEnter(state: number) { }
	private ChangeStateLeave(state: number) { }

	public ChangeState(state) {
		this.state_machine.ChangeState(state);
	}

	public SetContent(str, message_type) {
		if (!this._lb_content_html) {
			return
		}
		this._lb_content_html.innerHTML = str
		let w=280*2 //MessageItem UI的宽度放大两倍
		this._lb_content_html.width = w;
		//this._lb_content_html.x = 140 - this._lb_content_html.contextWidth * 0.25
		this._lb_content_html.y = 23 - this._lb_content_html.contextHeight * 0.5
        this._lb_content_html.x = (w*this._lb_content_html.scaleX / 2 -  this._lb_content_html.contextWidth* this._lb_content_html.scaleX / 2)
		if (message_type == SysInfoMiniMgr.MessageType.Two) {
			this._img_tips.visible = false;
		} else if (message_type == SysInfoMiniMgr.MessageType.Three) {
			//this.display_obj.x = -250
			//this.display_obj.y = 50 //- LayerManager.GetInstance().stageHeight * 0.5
			this._img_tips.visible = false
			this._lb_content_html.visible = false
			ResManager.GetInstance().LoadFont(this, "scene_exp", this._lb_content, 16)
			this._lb_content.text = str
		}
		else {
			let tips_width = (this._lb_content_html.contextWidth * 0.5) + 60;
			// if (PlatformManager.IsEyouEnPlatform()) {
			// 	let stage_max_width = 720;
			// 	if (this._lb_content_html.contextHeight > 19) {
			// 		this._img_tips.height = this._lb_content_html.contextHeight + 15;
			// 		this.display_obj.anchorY = this._lb_content_html.contextWidth + 15;
			// 		tips_width = this._lb_content_html.contextWidth + 60;
			// 	}
			// 	else {
			// 		this._img_tips.height = 30;
			// 		// this.anchorOffsetY = 30;
			// 		this.display_obj.anchorY = 30
			// 	}
			// 	this.display_obj.height = this._img_tips.height;
			// }
			if (tips_width < 222) {
				tips_width = 222;
			}
			this._img_tips.width = tips_width;
			this._img_tips.visible = true;
		}
	}
	private _move_state = false;
	private _tagret_y;
	private _tagret_x;
	get MoveState() {
		return this._move_state;
	}
	set MoveState(value) {
		let state = this.state_machine.GetCurrState();
		if (state != MessageItemState.alive)
			return;
		if (value) {
			if (PlatformManager.IsEyouEnPlatform()) {
				this._tagret_y = this.display_obj.y - this.display_obj.height;
			}
			else {
				this._tagret_y = this.display_obj.y - this.message_setting.once_move_dis;
			}
			/*
			if (this.message_type >= SysInfoMiniMgr.MessageType.Two) {
				this._tagret_x = this.display_obj.x + this.message_setting.fly_to_right_dis;
			}
			*/
		}
		this._move_state = value;
	}
	public DeleteMe() {
		this.state_machine = undefined;
		super.DeleteMe();
	}
	public ResetObj() {
		this.ChangeState(MessageItemState.death);
	}
	public ReleaseObj() {
		this._move_state = false;
		this.display_obj.y = 0;
		this.display_obj.x = 0;
		this.display_obj.alpha = 0;
		this.display_obj.visible = false;
		this.display_obj.scaleX = this.display_obj.scaleY = this.message_setting.default_scale;
		this._tagret_y = null;
		this._tagret_x = null;
	}
	public GetState() {
		return this.state_machine.GetCurrState();
	}


	_img_tips: Laya.Image
	_lb_content_html: Laya.HTMLDivElement
	_lb_content: Laya.Label
	public GetComponents() {
		[
			this._img_tips,
			this._lb_content_html,
			this._lb_content,
		]
			= this.GetChildrenByNames([

				"_img_tips",
				"_lb_content_html",
				"_lb_content",
			])
	}
}
window["MessageItem"] = MessageItem
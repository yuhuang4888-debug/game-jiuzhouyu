import { LayerManager, Enum_UILayer } from "../common/LayerManager"
import { ObjPool } from "../scene/ObjPool"
import { Runner } from "../util/Runner"
import { HashObject } from "../common/BaseClass"
import { MessageItem, MessageItemState } from "./MessageItem"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventName } from "../common/EventName"

export class SysInfoMiniMgr extends HashObject {
	private message_cache_list	//信息队列 
	private message_wnd_list	//当前显示的item列表
	private message_pool_list
	private message_con_list
	public static Instance
	update_id
	newest_hashCode = 0
	newest_hashCode_list
	has_init_layer = false

	static MessageType = {
		One: 0,
		Two: 1,
		Three: 2
	}

	static MessageSetting = {
		"0": {
			"max_show_count": 3,
			"max_cache_count": 200,
			"default_height": 600,
			"horizontalCenter": 0,
			"default_scale": 0.3,
			"life_cycle": 2,
			"once_move_dis": 30,
			"once_move_time": 0.3,
			"stay_time": 0 //dead阶段开始停留时间
		},
		"1": {
			"max_show_count": 5,
			"max_cache_count": 200,
			"default_height": 550,
			"default_x_to_center": 150,
			"horizontalCenter": 0,
			"default_scale": 0.3,
			"life_cycle": 1,
			"once_move_dis": 30,
			"once_move_time": 0.2,
			"once_move_x_dis": 35,
			"once_move_x_time": 0.1,
			"stay_time": 0.05,
			"fly_to_right_dis": 40,
		},
		"2": {
			"max_show_count": 5,
			"max_cache_count": 200,
			//"default_height": 550,
			"default_x_to_center": 190,
			"default_y_to_bottom": 270,
			"horizontalCenter": 0,
			"default_scale": 0.3,
			"life_cycle": 2,
			"once_move_dis": 30,
			"once_move_time": 0.2,
			"once_move_x_dis": 35,
			"once_move_x_time": 0.1,
			"stay_time": 0.05,
			"fly_to_right_dis": 40,
		}
	}

	public constructor() {
		super()
		this.InitMgr()
	}

	public static GetInstance() {
		if (!SysInfoMiniMgr.Instance) {
			SysInfoMiniMgr.Instance = new SysInfoMiniMgr()
		}
		return SysInfoMiniMgr.Instance
	}

	public AppendMiniMsg = (content, message_type) => {
		if (!this.has_init_layer) {
			this.InitMgr()
		}
		content = String(content)
		if (!this.message_cache_list)
			this.message_cache_list = {}
		if (!this.message_cache_list[message_type])
			this.message_cache_list[message_type] = []
		let list = this.message_cache_list[message_type]
		if (list.length > 0 || !this.GetMsgItemState(message_type)) {
			let message_setting = SysInfoMiniMgr.MessageSetting[message_type];
			if (list.length > message_setting.max_cache_count) {
				list.shift()
			}
			list.push(content)
			this.TryShowMiniMsg(message_type)
		}
		else {
			this.ShowMiniMsg(content, message_type)
		}
	}

	public TryShowMiniMsg = (message_type) => {
		if (this.GetMsgItemState(message_type)) {
			let msg = this.message_cache_list[message_type].shift()
			if (msg)
				this.ShowMiniMsg(msg, message_type)
		}
	}

	private ShowMiniMsg = (content, message_type) => {
		let obj: MessageItem = this.message_pool_list[message_type].GetObjFreeList()
		if (!obj) {
			obj = new MessageItem(this.message_con_list[message_type], message_type)
			obj.Load()
		}
		obj.ExcuteCallback(() => {
			obj.SetContent(content, message_type);
			if (!this.message_wnd_list)
				this.message_wnd_list = {};
			if (!this.message_wnd_list[message_type])
				this.message_wnd_list[message_type] = {};
			for (let key in this.message_wnd_list[message_type]) {
				let obj = this.message_wnd_list[message_type][key];
				if (obj)
					obj.MoveState = true;
			}
			this.message_wnd_list[message_type][obj.hashCode] = obj;
			// this.newest_hashCode = obj.hashCode
			if (!this.newest_hashCode_list) {
				this.newest_hashCode_list = {};
			}
			if (!this.newest_hashCode_list[message_type]) {
				this.newest_hashCode_list[message_type] = 0
			}
			this.newest_hashCode_list[message_type] = obj.hashCode
			obj.ChangeState(MessageItemState.born)
			this.StartUpdate()
		})
	}

	public DeleteMsg = (hashCode, message_type) => {
		let obj = this.message_wnd_list[message_type][hashCode];
		if (obj != null) {
			delete this.message_wnd_list[message_type][hashCode];
			this.message_pool_list[message_type].ReleaseObj(obj);
		}
	}

	private InitMgr = () => {
		GlobalEventSystem.Bind(EventName.STATE_RESET_SIZE, () => {
			this.UpdateMessageConX()
		})
		if (this.has_init_layer)
			return true
		let message_setting = SysInfoMiniMgr.MessageSetting;
		if (!this.message_pool_list)
			this.message_pool_list = {}
		if (!this.message_con_list)
			this.message_con_list = {}
		
		let layer_con = LayerManager.GetInstance().GetUILayer(Enum_UILayer.Message)
		let layer_con_main = LayerManager.GetInstance().GetUILayer(Enum_UILayer.UI)
		if (!layer_con || !layer_con_main)
			return
		
		for (let key in message_setting) {
			let value = message_setting[key]
			let msg_con = new Laya.Box()
			// msg_con.touchChildren = false;
			// msg_con.touchEnabled = false;
			msg_con.height = msg_con.width = 0
			if (value.default_height) {
				msg_con.y = value.default_height
			}
			if (value.default_y_to_bottom) {
				msg_con.y = LayerManager.GetInstance().stageHeight - value.default_y_to_bottom
			}
			msg_con.name = "message_con"
			if (Number(key) == SysInfoMiniMgr.MessageType.Three){
				layer_con_main.addChild(msg_con)
			} else {
				layer_con.addChild(msg_con)
			}
			this.message_pool_list[key] = new ObjPool(value.max_show_count + 2)
			this.message_con_list[key] = msg_con
		}
		this.UpdateMessageConX()
		this.has_init_layer = true
	}

	public UpdateMessageConX() {
		if (this.message_con_list) {
			let msg_con;
			for (let key in this.message_con_list) {
				msg_con = this.message_con_list[key]
				if (msg_con) {
					if (Number(key) >= SysInfoMiniMgr.MessageType.Two) {
						let default_x_to_center = SysInfoMiniMgr.MessageSetting[Number(key)].default_x_to_center
						msg_con.x = LayerManager.GetInstance().stageWidth / 2 - default_x_to_center
					}
					else {
						msg_con.x = LayerManager.GetInstance().stageWidth / 2
					}
				}
			}
		}
	}

	public ClearMsgCache = (message_type = SysInfoMiniMgr.MessageType.One) => {
		if (this.message_cache_list && this.message_cache_list[message_type])
			this.message_cache_list[message_type].length = 0
	}

	public ResetItem = (message_type = SysInfoMiniMgr.MessageType.One) => {
		if (this.message_wnd_list && this.message_wnd_list[message_type]) {
			for (let key in this.message_wnd_list[message_type]) {
				let obj = this.message_wnd_list[message_type][key]
				if (obj) {
					obj.ChangeState(MessageItemState.death)
				}
			}
		}
		this.ClearMsgCache(message_type)
	}

	private StartUpdate = () => {
		if (!this.update_id)
			this.update_id = Runner.GetInstance().AddRunObj(this)
	}

	private RemoveUpdate = () => {
		if (this.update_id) {
			Runner.GetInstance().RemoveRunObj(this.update_id)
			this.update_id = undefined
		}
	}

	public Update = (now_time, elapse_time) => {
		if (this.message_wnd_list) {
			let bool = false
			for (let key in this.message_wnd_list) {
				let list = this.message_wnd_list[key]
				if (list) {
					for (let key in list) {
						let obj = list[key]
						if (obj) {
							bool = true
							obj.Update(now_time, elapse_time)
						}
					}
				}
			}
			if (!bool)
				this.RemoveUpdate();
		}
	}

	//判断是否可以继续添加item
	public GetMsgItemState = (message_type) => {
		if (!this.message_wnd_list
			|| !this.message_wnd_list[message_type]
			|| !this.newest_hashCode_list
			|| !this.newest_hashCode_list[message_type]
			|| !this.message_wnd_list[message_type][this.newest_hashCode_list[message_type]]
			|| this.message_wnd_list[message_type][this.newest_hashCode_list[message_type]].GetState() != MessageItemState.born)
			return true
	}
}
window["SysInfoMiniMgr"] = SysInfoMiniMgr
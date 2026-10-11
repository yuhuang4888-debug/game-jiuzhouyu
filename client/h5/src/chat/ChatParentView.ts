
import { AppConst } from "../common/AppConst"
import { BaseView1 } from "../common/BaseView1"
import { EventName } from "../common/EventName"
import { Enum_UILayer, LayerManager } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { CHAT_TYPE, ChatModel, ChatModelEvent } from "../commonModel/ChatModel"
import { TeamModel } from "../commonModel/TeamModel"
import { LoginModel } from "../login/LoginModel"
import { PlatformManager } from "../PlatformManager"
import { RoleManager } from "../commonModel/RoleManager"
import { Scene } from "../scene/Scene"
import { SceneManager } from "../scene/SceneManager"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem, ClientConfig } from "../util/DeclareGlobalVar"
import { SYTweenFunc } from "../util/SYTweenFunc"
import { SYTweenLite } from "../util/SYTweenLite"
import { Util, GlobalTimerQuest, Split } from "../util/Util"
import { Vector2 } from "../util/Vector2"
import { Vector3 } from "../util/Vector3"
import { ChatItem } from "./ChatItem"
import { ChatParentTab } from "./ChatParentTab"
import { ChatParentTab2 } from "./ChatParentTab2"
import { SystemItem } from "./SystemItem"
import { VoiceChatView } from "./VoiceChatView"
import { SysInfoChuanwenMgr } from "../sysInfo/SysInfoChuanwenMgr"
import { GameResPath } from "../util/GameResPath"
import { Runner } from "../util/Runner"
import { DialogueModel } from "../commonModel/DialogueModel"
import { OpenFun } from "../common/OpenFun"
import { EquipmentViewSecond_Menu_Type } from "../commonModel/EquipModel"
import { DressModel } from "../commonModel/DressModel"
import { EyouManager } from "../commonController/EyouManager"


export class ChatParentView extends BaseView1 {
	CustomMehod
	InitEvent
	UpdateView
	back_login_toClose
	background_alpha
	canvas_group
	chat_item_list
	click_bg_toClose
	close_callback
	create_func_list
	delay_load_finish
	destroy_callback
	destroy_imm
	horizontalCenter
	initContent
	initTab
	initTextField
	is_close
	is_set_zdepth
	loaded_num
	loop_scrol_content
	loop_scrol_tab
	model
	moveTween
	needRefreshData
	open_callback
	preload_server_config
	send
	switchLock
	sys_item_list
	tabTouchHandler
	texttextDisplay__
	timer
	timer_list
	tipsVisible
	use_background
	voice_view


	////
	lastIndex


	///
	SetCanvasVisible
	LoadItems
	Clear
	SendMsg
	LoadItem
	KeepScrollBottom
	KeepTabScrollBottom
	ClearDelayQuest
	GetChatItemByData
	CheckPivot
	mask_corners
	showNoReadNum
	showNoReadIcon

	preTab
	//
	loadtime = 0
	run_id
	Update
	resume_id = null
	player_msg_item
	public constructor() {
		super()

		this.dependent_res = ["mainUI"]
		this.base_file = "chat"
		this.layout_file = "ChatParentView"
		this.layer_value = Enum_UILayer.Activity
		this.horizontalCenter = 0
		this.click_bg_toClose = true
		this.use_background = true
		this.background_alpha = 0
		this.back_login_toClose = true
		this.destroy_imm = true
		// this.destroy_imm = true
		this.preload_client_config = { "ClientTitleNameBordWidth": false }
		this.preload_server_config = { "config_title_cfg": false, "config_medal": false }
		this.model = ChatModel.GetInstance()
		this.is_set_zdepth = false
		this.voice_view = false
		this.delay_load_finish = true
		this.timer_list = []
		// let old_value = 0
		this.player_msg_item = {}
		this.chat_item_list = []
		this.sys_item_list = []

		/////////////////////
		this.preTab = -1
		let MAX_SHOW_NUM = 30
		// let PART_NUM = 10
		let PART_NUM = 5
		let non_breaking_space = "  "

		let local_Util = Util
		let team_model = TeamModel.GetInstance()
		let local_Message = Message
		let login_model = LoginModel.GetInstance()
		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName
		let role_mgr = RoleManager.GetInstance()
		let local_CHAT_TYPE = CHAT_TYPE
		let local_ChatModel = ChatModel
		let local_ChatModelEvent = ChatModelEvent
		let local_laya = Laya
		// let local_eui = eui
		this.loop_scrol_content = null
		this.loop_scrol_tab = null
		let lock = false
		let _model = ChatModel.GetInstance()
		let _channel = 0
		let _selectTab = 0
		let _send = false
		let _touchChat = false
		let timeoutId = null
		let channelList = []
		let scrollerV = 0
		let local_PlatformManager = PlatformManager.GetInstance()
		let platform_mgr = PlatformManager.GetInstance()
		let runner = Runner.GetInstance()
		let noReadNum = 0;
		let isAddItems:boolean  = false;

		/////////////////////

		this.load_callback = () => {
			this.display_obj.centerX = 0
			// if (PlatformManager.IsEyouEnPlatform() ) { 
			// 	this.tips.size  = 20	
			// 	this._Label1.size  = 16
			// 	this._Label2.size  = 16
			// 	this.voice_btn_text.size  = 16
			// }
			//if (PlatformMgr.GetInstance().IsEyouPlatform() ) {
			//this.voice.visible = false 
			//}
			this.InitEvent()
			// this.RegisterMask(this.content_list)
			// this.content_Scroller.onValueChanged.AddListener((value?) => {
			// 	// if (1 == value.y && old_value > 0 && old_value != 1 ) {
			// 	// console.log("============", value.y, this.content_Scroller.content.sizeDelta.y, this.content_Scroller.sizeDelta.y)
			// 	// if (value.y >= 0.999999 && this.Content_chatitem.sizeDelta.y >= this.content_Scroller.sizeDelta.y ) {
			// 	if (this.loaded_num && value.y >= 0.999999 && this.content_Scroller.content && this.content_Scroller.content.sizeDelta.y >= this.content_Scroller.sizeDelta.y ) {
			// 		// let num = Math.min(this.loaded_num, MAX_SHOW_NUM - PART_NUM)
			// 		// this.LoadItems(num)
			// 		this.LoadItems(Math.min(this.loaded_num, MAX_SHOW_NUM))
			// 		this.content_Scroller.StopMovement()
			// 	}
			// 	// old_value = value.y
			// })
			////onValueChanged方法不存在 用以下代码替换
			// this.content_Scroller.addEventListener(Laya.TouchEvent.TOUCH_BEGIN, () => { _touchChat = true }, this);
			// this.content_Scroller.addEventListener(local_eui.UIEvent.CHANGE_END, () => {
			// 	_touchChat = false;
			// 	if (this.content_Scroller && this.content_Scroller.viewport)
			// 		scrollerV = this.content_Scroller.viewport.scrollV;
			// }, this);

			if (this.needRefreshData) {
				this.SetCanvasVisible(false)
				this.UpdateView()
				this.needRefreshData = null
			}

			if (PlatformManager.IsEyouEnPlatform()) {
				this.voice.visible = false
			}

			this.display_obj.y = 100
			ResManager.GetInstance().SetTexture(this, this._Image11, GameResPath.GetIcon("chat", "uilt_001"))
			// if (PlatformMgr.GetInstance().IsEyouPlatform() ) {
			// 	this.voice.visible = false 
			// }
		}

		this.open_callback = () => {
			this.model.is_click_text = false
			this.textDisplay.focus = false
			this.textDisplay.on(Laya.Event.FOCUS, this, this.Update)
			this.textDisplay.on(Laya.Event.BLUR, this, this.Update)
			this.initTextField()
			this.initTab()
			this.switchLock()
			this.moveTween(true)
			// this.display_obj.y = 500;
			if (this.is_close) {
				this.Close()
			}
		}

		this.Update = () => {
			if (DialogueModel.GetInstance().dialog_is_open) {
				this.textDisplay.focus = false
			}
			if (this.textDisplay.focus == true && Laya.Browser.onMobile) {
				this.display_obj.y = 300
			} else {
				this.display_obj.y = LayerManager.GetInstance().stageHeight - this.display_obj.height - 120
			}
		}

		this.close_callback = () => {
			_channel = 0;
			_selectTab = 0;
			timeoutId = null;
			scrollerV = 0;

		}

		this.destroy_callback = () => {
			GlobalEventSystem.UnBind(this.resume_id)
			this.textDisplay.off(Laya.Event.FOCUS, this, this.Update)
			this.textDisplay.off(Laya.Event.BLUR, this, this.Update)
			this.Clear()
		}

		this.preload_server_config = { "config_medal": false }
		this.InitEvent = () => {
			this.resume_id = GlobalEventSystem.Bind(EventName.WINDOW_RESUME, this.Update)
			this.textDisplay.on(Laya.Event.INPUT, this, () => {
				if (this.textDisplay.text.length <= this.textDisplay.maxChars) {
					this.textDisplay.text = this.textDisplay.text
				} else {
					Message.show("单条信息不超过" + String(this.textDisplay.maxChars) + "字")
				}
			})
			Util.AddClickEvent(this.sendBtn, () => {
				this.SendMsg()
			}
				, this, true)
			Util.AddClickEvent(this.faceBtn, (e?) => {
				_model.selectChannel = _channel
				// let worldCamera = GameObject.Find("root/Canvas/UI").GetComponent("Canvas").worldCamera
				// let screen_pos = worldCamera.WorldToScreenPoint(Vector3(this.faceBtn.position.x, this.faceBtn.position.y, 0))

				_model.Fire(local_ChatModelEvent.OPENTOOLPANEL, this.faceBtn.localToGlobal(new Laya.Point(0, 0), true))
			}
				, this, true)
			Util.AddClickEvent(this._bag, (e?) => {
				_model.selectChannel = _channel
				_model.Fire(local_ChatModelEvent.OPENBAGPANEL, this._bag.localToGlobal(new Laya.Point(0, 0), true))
			}
				, this, true)

			let update = (c?, chat?, is_del?) => {
				let channel = _channel
				//锁定的情况下不刷新消息
				if (c == channel) {
					if (_send) {
						this.textDisplay.text = ""
						this.tipsVisible()
						_send = false
					}
					this.LoadItem(chat)
				} else {
					// Message.show("频道已锁定")
					if(chat["is_trumpet"]){
						let idx:number = 0;
						for (let i = 0; i < channelList.length; i++) {
							if(channelList[i].channel == c){
								idx = i
							}
						}
						_channel = c
						_selectTab = _model.chatViewIndex(_channel)
						this.loop_scrol_tab.SetSelectIndex(idx)
						this.Content_tab.selectedIndex = idx
						this.lastIndex = idx
						this.switchLock()
						this.initContent()
					}
				}
			}
			this.BindEvent(_model, local_ChatModelEvent.CHAT_CHANNEL_MSG_UPDATE, update)

			let addFace = (...new_args) => {
				let args = new_args
				if (args[0] && args[1] == _channel) {
					let face_str = "<f_" + args[0] + ">"
					if (this.textDisplay.text.length + face_str.length <= this.textDisplay.maxChars || this.textDisplay.maxChars == 0) {
						this.textDisplay.text = this.textDisplay.text + face_str
					} else {
						Message.show("单条信息不超过" + String(this.textDisplay.maxChars) + "字")
					}
				}
			}

			this.BindEvent(_model, local_ChatModelEvent.ADD_FACE, addFace)
			let addGoods = (...new_args) => {
				let args = new_args
				let data = args[0]
				let goods_name = data.goods_name
				let name = "[" + goods_name + "]"
				if (args[1] == _channel) {
					if ((name.length + this.textDisplay.text.length < this.textDisplay.maxChars || this.textDisplay.maxChars == 0)) {
						// let repetition = string.find(this.textDisplay.text, name)
						let text: string = this.textDisplay.text
						let repetition = text.indexOf(name)
						if (repetition == -1) {
							_model.setSendGoodsData(data, false)
						} else {
							_model.setSendGoodsData(data, true)
						}
						this.textDisplay.text = text + name
					} else {
						Message.show("单条信息不超过" + String(this.textDisplay.maxChars) + "字")
					}
				}
			}

			this.BindEvent(_model, local_ChatModelEvent.ADD_BAG_GOODS, addGoods)
			Util.AddClickEvent(this._gp_lock, () => {
				 // 注释锁功能
				// lock = !lock
				// this.switchLock()
			}
				, this)
			Util.AddClickEvent(this._position, () => {
				//屏蔽圣兽岭无限层
				if (SceneManager.GetInstance().IsCrossWuxianBossScene()) {
					Message.show("该场景不能发送坐标")
					return
				}
				//屏蔽公共频道信息
				if (_model.shield_channel_setting && table.find(ChatModel.SHIELD_CHANNEL, _channel) != -1) {
					Message.show("該聊天已屏蔽，請到設置取消屏蔽")
					return
				}

				if (_channel == local_CHAT_TYPE.TEAM) {
					if (!team_model.team_info) {
						local_Message.show("请加入队伍")
						this.loop_scrol_tab.SetSelectIndex(_selectTab)
						return
					}
				}
				if (_channel == local_CHAT_TYPE.WORLD_KUAFU || _channel == local_CHAT_TYPE.SMALL_KUAFU) {
					local_Message.show("此频道不能发送位置")
					return
				}
				// if (_channel == local_CHAT_TYPE.CAMP && ! SceneManager.GetInstance().IsKfHolyAreaScene() ) {
				//   local_Message.show("只允许分享跨服圣域位置")
				//   return
				// }
				if ((this.textDisplay.text.length < this.textDisplay.maxChars) || this.textDisplay.maxChars == 0) {
					let scene_info = SceneManager.GetInstance().scene_Info
					if (!scene_info) {
						return
					}
					let roleVo = role_mgr.GetMainRoleVo()
					let content = _model.positionChat(scene_info)
					let channel = _channel
					_model.Fire(local_ChatModelEvent.CHAT_SEND_MSG, 11001, channel, roleVo.province, roleVo.city, 0, content, {}, 0, "", true)
				}
			}
				, this, true)
			Util.AddClickEvent(this._close, () => {
				this.Close()
			}
				, this)
			Util.AddClickEvent(this._trumpet, () => {
				_model.Fire(local_ChatModelEvent.OPEN_TRUMPET_VIEW, "ChatTrumpetView")
			}, this, true)

			Util.AddClickEvent(this._dress_up, () => {
				let args = [2, 1, null]
				local_GlobalEventSystem.Fire(local_EventName.SWITCH_ROLE_SECOND_BUTTON, EquipmentViewSecond_Menu_Type.Fashion, args)
				// OpenFun.OpenFunHandler(203)
				this.Close()
			}, this, true)

			this.BindEvent(_model, local_ChatModelEvent.CHAT_BAG_OPEN, (bool?, Channel?) => {
				if (_channel == Channel) {
					this._img_bag_select.visible = bool
				}
			}
			)
			this.BindEvent(_model, local_ChatModelEvent.CLEAR_ROLE_DATA, () => {
				this.UpdateView()
			}
			)


			this.BindEvent(GlobalEventSystem, local_ChatModelEvent.KEEP_CHATVIEW_MSG_NEW, () => {
				if (!lock) {
					this.KeepScrollBottom()
				}
			})

			let click_down_x, click_down_y
			let onSpeakBtnUp = () => {
				this.voice_view.Close()
			}
			// AddUpEvent(this.btn_speak, onSpeakBtnUp)
			let onSpeakBtnDown = (target?, pos_x?, pos_y?) => {
				click_down_x = pos_x
				click_down_y = pos_y
				if (!this.voice_view) {
					this.voice_view = new VoiceChatView()
				}
				this.voice_view.Open({ channel: _channel, pos: new Vector2(56, 480) })
			}
			// AddDownEvent(this.btn_speak, onSpeakBtnDown)

			let onDrag = (target, pos_x, pos_y) => {
				this.voice_view.OnDrage(pos_y - click_down_y)
			}
			// AddDragEvent(this.btn_speak, onDrag)

			Util.AddClickEvent(this.voice, () => {
				console.log("语音")
				// if (AppConst.EnglineVer <= 102 ) {
				// 	Message.show("此功能暂未开放")
				// 	return
				// }
				if (RoleManager.GetInstance().GetMainRoleLevel() < 180) {
					Message.show("等级达到180级即可发送语音进行聊天~")
					return
				}

				// this.textDisplay__.visible = ! this.textDisplay__.visible 
				this.texttextDisplay__.visible = !this.texttextDisplay__.visible
				this.btn_speak.visible = !this.btn_speak.visible
				this.sendBtn.visible = !this.btn_speak.visible
				this.faceBtn.visible = !this.btn_speak.visible

				if (this.btn_speak.visible) {
					// ResManager.GetInstance().SetImageSprite(this, this.voice_icon, "chat_asset", "uilt_032")
					this.voice_btn_text.text = "文字"
				} else {
					// ResManager.GetInstance().SetImageSprite(this, this.voice_icon, "chat_asset", "uilt_031")
					this.voice_btn_text.text = "语音"
				}
			}, this, true)

			Util.AddClickEvent(this._gp_read, () => {
				this.content_Scroller.vScrollBar.stopScroll();
				if(noReadNum > 0){
					let curChatList = [];
					for (let k = 0; k < this.chat_item_list.length; k++) {
						if(this.chat_item_list[k] != undefined){
							table.insert(curChatList, this.chat_item_list[k])
						}
					}
					
					let height = 0;
					for (let i = 0, len = this.Content_chatitem.numChildren; i < len; i++) {
						let item = <Laya.View> this.Content_chatitem.getChildAt(i) as Laya.View
						let chat_item = curChatList[i];
							if(!chat_item) continue;
							let data = chat_item.data;
							height += item.y
							if(!data.read) break;
					}
					this.content_Scroller.vScrollBar.value = height
				}
			}, this, true)

			Util.AddClickEvent(this._to_bottom, () => {
				this.content_Scroller.vScrollBar.stopScroll();
				this.KeepScrollBottom()
			}, this, true)

			this.Content_chatitem.on(Laya.Event.RESIZE, this, () => {
				// console.log(this.Content1.displayHeight)
				this.showNoReadNum()
				this.showNoReadIcon()
				if (!lock) {
					if(isAddItems){
						this.KeepScrollBottom();
					}else{
						let h: number =  this.Content_chatitem.displayHeight;
						// 先用这个方式处理
						let val = this.content_Scroller.vScrollBar.value;
						if(h - val - 180 <= this.content_Scroller.height){
							this.KeepScrollBottom();
						}
					}
					// this.content_Scroller.vScrollBar.stopScroll()
					// this.content_Scroller.vScrollBar.value = this.Content_chatitem.displayHeight
					// this.KeepScrollBottom();
				}
			});

			let scrollerChange = () => {
				let val = this.content_Scroller.vScrollBar.value;
				let showViewPoy = val +  this.content_Scroller.height;
				let isUpdate : boolean = false;
				let curChatList = [];
				for (let k = 0; k < this.chat_item_list.length; k++) {
					if(this.chat_item_list[k] != undefined){
						table.insert(curChatList, this.chat_item_list[k])
					}
					
				}
				for (let i = 0, len = this.Content_chatitem.numChildren; i < len; i++) {
					let item = <Laya.View> this.Content_chatitem.getChildAt(i) as Laya.View
					if(item && item.y >= val - 10 && item.y + item.height <= showViewPoy + 10){
						let chat_item = curChatList[i];
						if(!chat_item) continue;
						let data = chat_item.data;
						if(!data.read){
							data.read = true
							isUpdate = true;
						}
					}
				}
				if(isUpdate){
					this.showNoReadNum()
				}
				this.showNoReadIcon()
			}

			this.content_Scroller.vScrollBar.on(Laya.Event.CHANGE, this, () => {
				scrollerChange()
			});

			this.Content_sysitem.on(Laya.Event.RESIZE, this, () => {
				// console.log(this.Content1.displayHeight)
				if (!lock) {
					// this.content_Scroller.vScrollBar.stopScroll()
					// this.content_Scroller.vScrollBar.value = this.Content_sysitem.displayHeight
					this.KeepScrollBottom();
				}
			});

			this.BindEvent(ChatModel.GetInstance(), ChatModelEvent.CLOSECHATPANEL, () => {
				this.Close()
			})

			this.BindVar(RoleManager.GetInstance().GetMainRoleVo(), "guild_id", ()=>{
				this.initTab()
			})

			this.BindVar(RoleManager.GetInstance().GetMainRoleVo(), "team_id", ()=>{
				this.initTab()
			})
		}

		this.initTextField = () => {
			if (PlatformManager.IsEyouEnPlatform()) {
				// this.textDisplay.characterLimit = 80
			}
			// this.textDisplay.onValueChanged.AddListener((text?) => {
			// 		if (this.textDisplay.characterLimit != 0 && text.length >= this.textDisplay.characterLimit ) {
			// 			Message.show("单条信息不超过"+String(this.textDisplay.characterLimit)+"字")
			// 		}
			// 	})
			// this.textDisplay.addEventListener(Laya.Event.CHANGE, (text?) => {
			// 	if (this.textDisplay.characterLimit != 0 && text.length >= this.textDisplay.characterLimit) {
			// 		Message.show("单条信息不超过" + String(this.textDisplay.characterLimit) + "字")
			// 	}
			// }
			// 	, this)
		}

		this.initTab = () => {
			channelList = _model.chatTabList()
			if (!this.loop_scrol_tab) {
				this.loop_scrol_tab = new LoopScrowViewMgr()
				this.loop_scrol_tab.SetData(this.Content_tab, ChatParentTab2, channelList, LoopScrCon.Vertical, 1, this.tabTouchHandler)
				// this.Content_tab.addEventListener(Laya.ItemTapEvent.ITEM_TAP, this.tabTouchHandler, this)
			} else {
				this.loop_scrol_tab.replaceAll(channelList)
			}
			//有可能打开还没开放的频道,就默认打开世界频道
			if (this.preTab != -1) {
				_selectTab = this.preTab
			}
			if (channelList[_selectTab]) {
				_channel = channelList[_selectTab].channel
			} else {
				_selectTab = 1
			}
			this.loop_scrol_tab.SetSelectIndex(_selectTab)
			// this.loop_scrol_tab.soureArr.refresh()

			if (8 == _selectTab) {
				this.KeepTabScrollBottom()
			}

			this.initContent()
		}

		this.tabTouchHandler = (index?) => {
			let item = channelList[index]
			if(!item) return
			let channe = item.channel
			if (channe == _channel) {
				return
			}
			if (channe == local_CHAT_TYPE.GUILD) {
				let vo = role_mgr.GetMainRoleVo()
				if (vo.guild_id <= 0) {

					local_Message.show("请加入结社!")
					let channe = channelList[this.lastIndex].channel
					_channel = channe
					_selectTab = _model.chatViewIndex(_channel)
					this._lb_tips.text = "请输入聊天内容"
					this.loop_scrol_tab.SetSelectIndex(this.lastIndex)
					// this.loop_scrol_tab.soureArr.refresh()
					this.Content_tab.selectedIndex = this.lastIndex
					// lock = false
					this.switchLock()
					this.initContent()
					return
				}
			}
			_channel = channe
			_selectTab = _model.chatViewIndex(_channel)
			this._lb_tips.text = "请输入聊天内容"
			this.loop_scrol_tab.SetSelectIndex(index)
			// this.loop_scrol_tab.soureArr.refresh()
			this.Content_tab.selectedIndex = index
			this.lastIndex = index
			// lock = false
			this.switchLock()
			this.initContent()
			// this.content_Scroller.vScrollBar.stopScroll()
			// this.content_Scroller.vScrollBar.value = this.Content_chatitem.displayHeight
			// this.content_Scroller.vScrollBar.value = this.Content_sysitem.displayHeight
		}

		this.initContent = () => {
			_model.cleanSendGoodsData()
			this.textDisplay.text = ""
			this.tipsVisible()
			let datalsit = []
			datalsit = datalsit.concat(_model.getChannelChat(_channel))
			this.tips.visible = _channel == local_CHAT_TYPE.SYSTEM
			this.chatGroup.visible = !this.tips.visible

			this.SetCanvasVisible(false)
			this.UpdateView()
		}

		this.UpdateView = () => {
			if (!this.is_loaded) {
				this.needRefreshData = true
				return
			}
			if (_send) {
				this.textDisplay.text = ""
				this.tipsVisible()
				_send = false
			}
			this.ClearDelayQuest()
			let load_num = 0
			if (this.Content_chatitem) {
				this.Content_chatitem.visible = false
			}
			if (this.Content_sysitem) {
				this.Content_sysitem.visible = false
			}
			for (let key in this.chat_item_list) {
				let item = this.chat_item_list[key]
				item.SetVisible(false)
				item.DeleteMe()
			}
			this.chat_item_list = []
			for (let key in this.sys_item_list) {
				let item = this.sys_item_list[key]
				item.SetVisible(false)
				item.DeleteMe()
			}
			this.sys_item_list = []
			if (_channel == CHAT_TYPE.SYSTEM) {
				// this.content_Scroller.content = this.Content_sysitem
				if (this.Content_sysitem) {
					this.Content_sysitem.visible = true
				}
			} else {
				// this.content_Scroller.content = this.Content_chatitem
				if (this.Content_chatitem) {
					this.Content_chatitem.visible = true
				}
			}

			this.LoadItems(0, true)
		}

		this.switchLock = () => {
			if (this) {
				this._lock.visible = lock
				this._unLock.visible = !lock
			}
		}

		this.tipsVisible = () => {
			if (!this.textDisplay) {
				return
			}
			this._lb_tips.visible = this.textDisplay.text == ""
		}

		this.CustomMehod = (index?, args?) => {
			_selectTab = 0
			this.preTab = 0
			if (args == 0) return
			_selectTab = args
			this.preTab = _selectTab
			if (this.is_loaded) {
				// if (this.loop_scrol_tab && _selectTab != this.loop_scrol_tab.select_index) {
				// 	lock = false
				// }
				this.switchLock()
				this.initTextField()
				this.initTab()
			}
		}

		this.moveTween = (isOpen?, callBack?) => {
			if (isOpen) {
				this.display_obj.y = LayerManager.GetInstance().stageHeight
				// this.form.anchoredPosition = new Vector2(0, -250)
				// let start_pos = this.display_obj.localPosition
				// let end_pos = new Vector3(start_pos.x, start_pos.y + 122 + 250, start_pos.z)
				let id = SYTweenLite.to(this, this.display_obj, SYTweenLite.UiAnimationType.POSY, LayerManager.GetInstance().stageHeight - this.display_obj.height - 120, 0.25, () => {
					// this.run_id=runner.AddRunObj(this)
					// LuaViewManager.GetInstance().RefreshBlackGroundPos()
				}, SYTweenFunc.EASE_IN_OUT_BACK, false)
			} else {
			}
		}

		this.SetCanvasVisible = (is_show?) => {

			// console.log("SetCanvasVisible", is_show)
			// this.canvas_group = this.canvas_group || this.content_Scroller.GetComponent("CanvasGroup")
			// if (is_show ) {
			// 	this.canvas_group.alpha = 1
			// // } else if (! lock ) {
			// }else{
			// 	this.canvas_group.alpha = 0
			// }
		}

		this.LoadItems = (loaded_num?, keep_buttom?) => {

			if (!this.is_loaded) {
				return
			}
			isAddItems = true;
			let channel_msg_list = _model.getChannelChat(_channel)
			//test
			// let createMsg = (num?, tag?, channel?) => {
			// 	for (let i = 1; i <= num; i++){
			// 		let newRobot = {name = "test", level = 1, career = 1, channel = channel || CHAT_TYPE.WORLD,
			// 		player_id = 0, time = TimeUtil.getServerTime()}
			// 		newRobot.msg = tag + "！！！<color@4><a6001408>[恶毒魔之靴]</a></font>no." + i
			// 		table.insert(channel_msg_list, newRobot)
			// 	}
			// }
			// channel_msg_list = []
			// if (_channel == CHAT_TYPE.GUILD ) {
			// 	createMsg(30, "结社频道")
			// } else if (_channel == CHAT_TYPE.TEAM ) {
			// 	createMsg(20, "队伍频道")
			// } else if (_channel == CHAT_TYPE.SMALL_KUAFU ) {
			// 	createMsg(13, "跨服频道")
			// } else if (_channel == CHAT_TYPE.WORLD_KUAFU ) {
			// 	createMsg(5, "活动频道")
			// } else if (_channel == CHAT_TYPE.SYSTEM ) {
			// 	createMsg(18, "系统频道", CHAT_TYPE.SYSTEM)
			// }else{
			// 	createMsg(40, "世界频道")
			// }
			if (channel_msg_list.length <= loaded_num) {
				this.SetCanvasVisible(true)
				return
			}
			this.loaded_num = loaded_num
			let local_create_func_list = []
			for (let i = loaded_num; i < channel_msg_list.length; i++) {
				let begin_index = Math.max(channel_msg_list.length - loaded_num - PART_NUM, 0)
				let msg = channel_msg_list[i]
				if (msg) {
					let is_last_msg = keep_buttom && !lock && (i == channel_msg_list.length - 1)
					let item = this.GetChatItemByData(msg)
					if (!this.is_loaded) {
						return
					}


					if (!item) {
						// if((_channel == CHAT_TYPE.WORLD || _channel==CHAT_TYPE.GUILD) && msg.chuanwen){
						// 	item = new SystemItem(this.Content_chatitem)
						// 	item.Load()
						// 	table.insert(this.chat_item_list, item);
						// }
						// else
						if (_channel == CHAT_TYPE.SYSTEM || msg.chuanwen) {
							if (_channel == CHAT_TYPE.SYSTEM) {
								item = new SystemItem(this.Content_sysitem)
								item.Load()
								table.insert(this.sys_item_list, item);
							} else {
								// msg.channel=_channel
								item = new SystemItem(this.Content_chatitem)
								item.Load()
								table.insert(this.chat_item_list, item);
							}
						} else {
							item = new ChatItem(this.Content_chatitem)
							item.Load()
							table.insert(this.chat_item_list, item);
						}
					}
					item.SetData(msg, is_last_msg)
					item.SetVisible(true)
					item.ExcuteCallback(() => {
						this.CheckPivot()
						if (_channel == CHAT_TYPE.SYSTEM) {
							// item.transform.SetParent(this.Content_sysitem)
							// this.content_Scroller.vScrollBar.value=this.Content_sysitem.displayHeight
						} else if (msg.chuanwen) {
						}
					})

				}
				this.loaded_num = this.loaded_num + 1
			}
			this.loadtime++
			let delay_callback
			delay_callback = () => {
				// if (null == next(this.create_func_list) ) {
				// 	this.delay_load_finish = true
				// 	return
				// }
				// let popListAndRun = () => {
				// 	// if (null == next(this.create_func_list) ) {
				// 	// 	this.delay_load_finish = true
				// 	// 	return
				// 	// }
				// 	// let tbl = table.remove(this.create_func_list, 1)
				// 	// tbl.func()
				// }

				// table.insert(this.timer_list, GlobalTimerQuest.AddDelayQuest(() => {
				// 	//系统频道item高度比较少，打开界面可能要加载很多item，所以一帧加载几个避免整个加载过程过长
				// 	if (_channel == CHAT_TYPE.SYSTEM) {
				// 		popListAndRun()
				// 		popListAndRun()
				// 		popListAndRun()
				// 	} else {
				// 		// console.log("Time.frameCount", Time.frameCount)
				// 		popListAndRun()
				// 	}
				// 	delay_callback()
				// 	// }, 0, {count = Time.frameCount}))
				// }, 0))
			}
			//table.merge(this.create_func_list, local_create_func_list)
			// if (this.delay_load_finish) {
			// 	this.delay_load_finish = false
			// 	delay_callback()
			// }

			this.CheckPivot()
		}


		this.GetChatItemByData = (msg?) => {

			for (let i in this.chat_item_list) {
				let item = this.chat_item_list[i]
				if (msg == item.data) {
					return item
				}
			}
			for (let i in this.sys_item_list) {
				let item = this.sys_item_list[i]
				if (msg == item.data) {
					return item
				}
			}
		}

		this.LoadItem = (msg?) => {
			isAddItems = false;
			let item
			let item_list
			let to_bottonm: boolean = true;
			if (_channel == CHAT_TYPE.SYSTEM) {
				item_list = this.sys_item_list
			} else {
				item_list = this.chat_item_list
			}
			// if (item_list.length < MAX_SHOW_NUM) {
			// 	if (_channel == CHAT_TYPE.SYSTEM || msg.chuanwen) {
			// 		item = new SystemItem(this.Content_sysitem)
			// 	} else {
			// 		item = new ChatItem(this.Content_chatitem)
			// 	}
			// 	item.Load()
			// 	item_list[item_list.length + 1] = item
			// } else {
			// 	item = item_list[MAX_SHOW_NUM]

			// 	for (let i = MAX_SHOW_NUM - 1; i >= 1; i -= 1) {
			// 		item_list[i] = item_list[i]
			// 	}
			// 	item_list[1] = item
			// }
			if ((_channel == CHAT_TYPE.WORLD || _channel == CHAT_TYPE.GUILD) && msg.chuanwen) {
				item = new SystemItem(this.Content_chatitem)
				item.Load()
				table.insert(this.chat_item_list, item);
			}
			else if (_channel == CHAT_TYPE.SYSTEM || msg.chuanwen) {
				item = new SystemItem(this.Content_sysitem)
			} else {
				item = new ChatItem(this.Content_chatitem)
				let send_player = (msg.player_list && msg.player_list[1]) || msg
				let main_role_vo = RoleManager.GetInstance().GetMainRoleVo()
				if(send_player && send_player.player_id == main_role_vo.role_id){
					
				}else{
					to_bottonm = false;
				}
			}
			item.Load()
			let listLength = item_list.length + 1
			item_list[item_list.length + 1] = item
			item.SetData(msg, to_bottonm)
			item.SetVisible(true)
			item.ExcuteCallback(() => {
				this.CheckPivot()
				if (_channel == CHAT_TYPE.SYSTEM) {
					// item.transform.SetParent(this.Content_sysitem)
					// this.content_Scroller.vScrollBar.value = this.Content_sysitem.displayHeight
				} else if (msg.chuanwen) {
				}
				// this.content_Scroller.vScrollBar.value=1000

			})

			if(this.content_Scroller.vScrollBar.value >= (listLength - 1) * 150 -20){
				Laya.timer.once(50, this, () => {
					if (this.use_delete_method) return
					if (!lock) {
						let h: number = listLength * 150;
						// let h: number = (this.Content_chatitem.visible && this.Content_chatitem.displayHeight) || this.Content_sysitem.displayHeight;
						// this.content_Scroller.vScrollBar.setScroll(0, h + 10, h + 10);
						this.content_Scroller.vScrollBar.value = h + 10;
					}
				})
			}
			
		}

		this.CheckPivot = () => {

			// //修改item的增长方向
			// UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(this.content_Scroller.content)
			//item数量超过viewport
			// if (this.content_Scroller.content.width> this.content_Scroller.width) {
			// this.Content_chatitem.pivot = Vector2(0, 0)
			// this.content_Scroller.content.pivot = new Vector2(0, 0)
			// //开启保持底部
			// if (! lock ) {
			// 	//自下往上增长
			// 	this.Content_chatitem.pivot = Vector2(0, 0)
			// }else{
			// 	//自上往下增长
			// 	this.Content_chatitem.pivot = Vector2(0, 1)
			// }
			// } else {
			//自上往下增长
			// this.Content_chatitem.pivot = Vector2(0, 1)
			// this.content_Scroller.content.pivot = new Vector2(0, 1)
			// }
		}

		this.Close = () => {
			// runner.RemoveRunObj(this.run_id)
			this.textDisplay.off(Laya.Event.FOCUS, this, this.Update)
			let id = SYTweenLite.to(this, this.display_obj, SYTweenLite.UiAnimationType.POSY, LayerManager.GetInstance().stageHeight, 0.25, () => {
				super.Close()
			}, SYTweenFunc.linear, false)
			// if (this.form ) { 
			// 	this.is_close = false
			// 	let start_pos = this.form.localPosition
			// 	let end_pos = Vector3(start_pos.x, start_pos.y - 122 -250, start_pos.z)
			// 	let id = SYTweenLite.to(this, this.form, SYTweenLite.UiAnimationType.POS, end_pos, 0.1,() => {
			// 			super.Close(this)
			// 		}, SYTweenFunc.linear, false)
			// }else{
			// 	this.is_close = true
			// }
		}

		this.SendMsg = () => {

			if (_channel == local_CHAT_TYPE.TEAM) {
				if (!team_model.team_info) {
					local_Message.show("请加入队伍")
					this.loop_scrol_tab.SetSelectIndex(_selectTab)
					return
				}
			}
			let msg = this.textDisplay.text
			if (msg == "") {
				local_Message.show("请输入聊天内容!")
				return
			} else if (msg == "@test") {
				if ((ClientConfig.TestYouWant && ClientConfig.TestYouWant == 1) || false == ClientConfig.account_server || !login_model.plat_name
				) {
					GlobalEventSystem.Fire(EventName.OPEN_CHEAT_CLIENT_VIEW)
				}
				return
			} else if (msg == "@perform") {
				Laya.Stat.show()
				return
			} else if (msg == "@debug") {
				Laya.enableDebugPanel();
				return
			} else if (msg == "@drop") {
				let obj = undefined//Scene.Instance.now_drop_obj
				if (obj) {
					let str = ""
					str = str + String(obj.state) + " "
					str = str + String(obj.pick_success) + " "
					str = str + String(obj.is_picking) + " "
					str = str + String(obj.can_not_pick) + " "
					str = str + String(obj.start_pick) + " "
					str = str + String(obj.init_state_born) + " "
					str = str + String(obj.init_state_wait_pick) + " "
					str = str + String(obj.init_state_start_pick) + " "
					str = str + String(obj.init_state_end_pick) + " "
					str = str + String(obj.init_state_disappear) + " "
					str = str + String(obj.init_state_stay) + " "
					str = str + String(obj.init_state_move) + " "
					Message.show(str)
				}
				return
			} else if (msg.indexOf("@openlog") != -1) {
				let list = Split(msg, "_")
				let log_type = null
				if (list && list[2]) {
					log_type = list[2]
				}
				// LuaLogManager.GetInstance().SetLogEnable(true, log_type)
				// local_Util.ShowFPS()
				return
			} else if (msg == "@closelog") {
				// LuaLogManager.GetInstance().SetLogEnable(false)
				// local_Util.ShowFPS()
				return
			} else if (msg == "@error") {
				let error_test
				error_test.p = 1
				return
			} else if (msg == "@hideUI") {
				GlobalEventSystem.Fire(EventName.HIDE_OR_SHOW_ALL_UI_CANVAS_LAYER);
				return
			}
			let level = role_mgr.GetMainRoleVo().level
			if (_channel == local_CHAT_TYPE.WORLD && level < 60) {
				local_Message.show("60级开启世界频道")
				return
			} else if (_channel == local_CHAT_TYPE.WORLD_KUAFU) {
				if (!_model.kuafuShow(true)) {
					local_Message.show("当前没有活动开启，可使用喇叭发送信息")
					return
				}
				let [flag, showLv] = _model.checkKuafuActivityOpen()
				if (!flag) {
					// if (PlatformMgr.GetInstance().IsEyouThPlatform() ) {
					// 	local_Message.show("Lv." + showLv + "เปิดช่องอีเวนต์")
					// }else{
					// 	local_Message.show(showLv + "级开启活动频道")
					// }
					local_Message.show(showLv + "级开启活动频道")
					return
				}
			} else if (_channel == local_CHAT_TYPE.SMALL_KUAFU) {
				let config = _model.ViewClassCFG[local_CHAT_TYPE.SMALL_KUAFU]
				let level = role_mgr.GetMainRoleVo().level
				let flag = level >= config.openLevel
				if (!flag) {
					// if (PlatformMgr.GetInstance().IsEyouThPlatform() ) {
					// 	local_Message.show("Lv." + config.openLevel + "เปิดช่องข้ามเซิร์ฟ")
					// }else{
					// 	local_Message.show(config.openLevel + "级开启跨服频道")
					// }
					local_Message.show(config.openLevel + "级开启跨服频道")
					return
				}
			}
			// let temp_msg=ChatModel.GetInstance().disposeChtaFace(msg,20,16,20)
			// if(temp_msg==""){
			// 	Message.show("无效表情")
			// 	return
			// }
			let send_func = () => {
				_send = true
				let roleVo = role_mgr.GetMainRoleVo()
				let channel = _channel
				// msg = DeleteHTMLSign(msg)
				let [sendGoods, goods_id_list, sendGoodsMesg] = _model.sendGoodsMesg(msg)
				//把换行替换成空格
				sendGoodsMesg = sendGoodsMesg.replace("\n", non_breaking_space)
				sendGoodsMesg = sendGoodsMesg.replace(" ", non_breaking_space)
				if (table.find(local_ChatModel.SPECIAL_CHANNEL, _channel) != -1 && goods_id_list.length > 0) {
					_model.Fire(local_ChatModelEvent.SEND_SPECIAL_CHANNEL_GOODS, _channel, goods_id_list)
				}
				_model.Fire(local_ChatModelEvent.CHAT_SEND_MSG, 11001, channel, roleVo.province, roleVo.city, 0, sendGoodsMesg, sendGoods, 0, "")
				EyouManager.GetInstance().FirstChatDataPost()
				// console.log("content", msg)
				// let tmpArgs = this.model.GetAllArgsText(msg)
				// console.log("tmpArgs", tmpArgs)
				// msg = this.model.GetHyperlinkText(msg)
				// console.log("GetHyperlinkText", msg)
				// _model.Fire(local_ChatModelEvent.CHAT_SEND_MSG, 11001, channel, roleVo.province, roleVo.city, 0, msg, tmpArgs, 0, "")
			}

			local_Util.HasFilterWord(msg, null, (is_filter) => {
				if (is_filter) {
					local_Message.show("内容有敏感词")
				} else {
					send_func()
				}
			}, 2)
		}

		this.KeepScrollBottom = () => {
			let h: number = this.Content_chatitem.visible? this.Content_chatitem.displayHeight:this.Content_sysitem.displayHeight;
			// 先用这个方式处理
			Laya.timer.once(50, this, () => {
				if(this.use_delete_method) return
				this.content_Scroller.vScrollBar.value = h + 10;
			})


			//content的高度比scrollview大才会滚动到底部
			// UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(this.content_Scroller.content)
			// if (this.content_Scroller.width > this.content_Scroller.width) {
			// 	this.content_Scroller.content.anchoredPosition = new Vector2(0, this.content_Scroller.content.width)
			// }
		}

		this.KeepTabScrollBottom = () => {

			// UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(this.Content_tab)
			this.Content_tab.x = 0
			this.Content_tab.y = this.Content_tab.height
		}


		this.Clear = () => {

			if (this.loop_scrol_tab) {
				this.loop_scrol_tab.DeleteMe()
				this.loop_scrol_tab = null
			}

			for (let _ in this.chat_item_list) {
				let v = this.chat_item_list[_]
				v.DeleteMe()
			}
			this.chat_item_list = []
			for (let _ in this.sys_item_list) {
				let v = this.sys_item_list[_]
				v.DeleteMe()
			}
			this.sys_item_list = []

			// if (this.timer ) {				
			// 	GlobalTimerQuest.CancelQuest(this.timer)
			// 	this.timer = null
			// }
			this.ClearDelayQuest()

			this.voice_view = null
			this.canvas_group = null
		}

		this.ClearDelayQuest = () => {

			if (this.timer_list) {
				for (let i = 0; i < this.timer_list.length; i++) {
					let v = this.timer_list[i]
					GlobalTimerQuest.CancelQuest(v)
				}
				this.timer_list = []
			}
			this.delay_load_finish = true
			this.create_func_list = []
		}

		this.showNoReadNum = () =>{
			if(!this.Content_chatitem.visible){
				this._gp_read.visible = this._to_bottom.visible = false;
				return;
			}
			noReadNum = 0;
			for (let i = 0, len = this.chat_item_list.length; i < len; i++) {
				let item = this.chat_item_list[i];
				if(!item) continue;
				let data = item.data;
				if(!data.read){
					noReadNum ++
				}
			}
			// this._no_read_cnt.text = noReadNum > 0? `${noReadNum}条未读信息`: "";
		}

		this.showNoReadIcon = () =>{
			if(!this.Content_chatitem.visible){
				this._gp_read.visible = this._to_bottom.visible = false;
				return;
			}

			this._no_read_cnt.text = noReadNum > 0? `${noReadNum}条未读信息`: "";

			let h: number =  this.Content_chatitem.displayHeight;
			// 先用这个方式处理
			let val = this.content_Scroller.vScrollBar.value;
			let isOnBottom: boolean =  h - val > this.content_Scroller.height ;
			let isHaveNoRead: boolean = noReadNum > 0;
			this._gp_read.visible = isOnBottom && isHaveNoRead;
			this._to_bottom.visible = isOnBottom && !isHaveNoRead;
		}
	}


	_Image11: Laya.Image
	bg: Laya.Image
	tab_Scroller: Laya.Panel
	Content_tab: Laya.List
	content_Scroller: Laya.Panel
	Content_chatitem: Laya.VBox
	Content_sysitem: Laya.VBox
	chatGroup: Laya.Box
	_gp_text_input: Laya.Box
	_Image2: Laya.Image
	_lb_tips: Laya.Label
	text_input__: Laya.Box
	_Image1: Laya.Image
	_Rect1: Laya.Box
	textDisplay: Laya.TextInput
	Text: Laya.Label
	PlaceHolder: Laya.Label
	btn_speak: Laya.Box
	image: Laya.Image
	text: Laya.Label
	faceBtn: Laya.Box
	_Image1111: Laya.Image
	labelDisplay1: Laya.Label
	sendBtn: Laya.Box
	_Image111: Laya.Image
	labelDisplay: Laya.Label
	_bag: Laya.Box
	_Image3: Laya.Image
	_Label1: Laya.Label
	_img_bag_select: Laya.Image
	_position: Laya.Box
	_Image4: Laya.Image
	_Label2: Laya.Label
	voice: Laya.Box
	voice_icon: Laya.Image
	voice_btn_text: Laya.Label
	tips: Laya.Label
	_trumpet: Laya.Image
	_gp_lock: Laya.Box
	_Image5: Laya.Image
	_unLock: Laya.Image
	_lock: Laya.Image
	_close: Laya.Image
	_img_down_blcakbg: Laya.Image
	_btn_close: Laya.Box

	_gp_read: Laya.Box
	_img_no_read: Laya.Image
	_no_read_cnt: Laya.Label
	_to_bottom: Laya.Image
	_dress_up: Laya.Image

	public GetComponents() {
		[
			this._Image11,
			this.bg,
			this.tab_Scroller,
			this.Content_tab,
			this.content_Scroller,
			this.Content_chatitem,
			this.Content_sysitem,
			this.chatGroup,
			this._gp_text_input,
			this._Image2,
			this._lb_tips,
			this.text_input__,
			this._Image1,
			this._Rect1,
			this.textDisplay,
			this.Text,
			this.PlaceHolder,
			this.btn_speak,
			this.image,
			this.text,
			this.faceBtn,
			this._Image1111,
			this.labelDisplay1,
			this.sendBtn,
			this._Image111,
			this.labelDisplay,
			this._bag,
			this._Image3,
			this._Label1,
			this._img_bag_select,
			this._position,
			this._Image4,
			this._Label2,
			this.voice,
			this.voice_icon,
			this.voice_btn_text,
			this.tips,
			this._trumpet,
			this._gp_lock,
			this._Image5,
			this._unLock,
			this._lock,
			this._close,
			this._img_down_blcakbg,
			this._btn_close,
			this._gp_read,
			this._img_no_read,
			this._no_read_cnt,
			this._to_bottom,
			this._dress_up,
		]
			= this.GetChildrenByNames([

				"_Image11",
				"bg",
				"tab_Scroller",
				"Content_tab",
				"content_Scroller",
				"Content_chatitem",
				"Content_sysitem",
				"chatGroup",
				"_gp_text_input",
				"_Image2",
				"_lb_tips",
				"text_input__",
				"_Image1",
				"_Rect1",
				"textDisplay",
				"Text",
				"PlaceHolder",
				"btn_speak",
				"image",
				"text",
				"faceBtn",
				"_Image1111",
				"labelDisplay1",
				"sendBtn",
				"_Image111",
				"labelDisplay",
				"_bag",
				"_Image3",
				"_Label1",
				"_img_bag_select",
				"_position",
				"_Image4",
				"_Label2",
				"voice",
				"voice_icon",
				"voice_btn_text",
				"tips",
				"_trumpet",
				"_gp_lock",
				"_Image5",
				"_unLock",
				"_lock",
				"_close",
				"_img_down_blcakbg",
				"_btn_close",
				"_gp_read",
			    "_img_no_read",
			    "_no_read_cnt",
				"_to_bottom",
				"_dress_up",
			])
		this.content_Scroller.vScrollBar.visible = false;
	}
}
window["ChatParentView"] = ChatParentView
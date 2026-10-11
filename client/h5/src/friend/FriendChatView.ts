import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { ChatModel, ChatModelEvent, CHAT_TYPE } from "../commonModel/ChatModel"
import { FriendModel, FriendEvent } from "../commonModel/FriendModel"
import { PlatformManager } from "../PlatformManager"
import { RoleManager } from "../commonModel/RoleManager"
import { SceneManager } from "../scene/SceneManager"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalTimerQuest, Util, SetLocalScale } from "../util/Util"
import { Vector2 } from "../util/Vector2"
import { Vector3 } from "../util/Vector3"
import { FriendChatItem } from "./FriendChatItem"
import { FriendChatTabItem } from "./FriendChatTabItem"
import { FriendMineChatItem } from "./FriendMineChatItem"
import { GameResPath } from "../util/GameResPath"
import { Mathf } from "../util/Mathf"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventName } from "../common/EventName"
import { EyouManager } from "../commonController/EyouManager"

export class FriendChatView extends BaseView1 {
	EmpfaceBtn
	EmpsendBtn
	InitEvent
	ScrcontentScroller
	ScrtabScroller
	_model
	_send
	_vo
	back_login_toClose
	background_alpha
	canvas_group
	change_scene_close
	click_bg_toClose
	close_callback
	content_list
	destroy_imm
	initPlayerInfo
	initTab
	initView
	is_center
	local_ChatModel
	loop_mgr
	open_callback
	send
	show_open_movie
	tabTouchHandler
	time_id
	updateChat
	use_background
	tablist

	public constructor() {
		super()


		this.content_list = []
		this._send = false;
		this.local_ChatModel = ChatModel.GetInstance();
		this.base_file = "chat"
		this.layout_file = "FriendChatView"


		this.layer_value = Enum_UILayer.Activity
		this.use_background = true
		this.click_bg_toClose = true
		this.is_center = true
		this.show_open_movie = true
		this.back_login_toClose = true
		this.background_alpha = 0.5
		this.destroy_imm = true
		this.change_scene_close = true
		this._model = FriendModel.GetInstance()
		let chat_list = []
		let tab_list = []
		let _textLabel = "请输入聊天内容"
		let _touchChat = false
		let local_RoleManager = RoleManager.GetInstance()
		let local_ChatModelEvent = ChatModelEvent
		let local_CHAT_TYPE = CHAT_TYPE
		let local_FriendEvent = FriendEvent
		let local_PlatformManager = PlatformManager.GetInstance()
		let mine_chat_list = []
		this.tablist = []
		this.preload_client_config = {
			"ClientPreventFraud": false
		}
		this.load_callback = () => {

			this.InitEvent()
			let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "ClientPreventFraud", true)
			if (cfg.is_show) {
				this.lb_preventfraud.visible = true
				this.bg.visible = true
				let num = Mathf.Random() * 100
				for (let key in cfg.show_info) {
					if (num >= cfg.show_info[key].min && num <= cfg.show_info[key].max) {
						this.lb_preventfraud.text = cfg.show_info[key].desc
						break
					}
				}
				this.contentScroller.y = 178
				this.contentScroller.height = 494
			} else {
				this.bg.visible = false
				this.lb_preventfraud.visible = true
				this.contentScroller.y = 110
				this.contentScroller.height = 562
			}
			ResManager.GetInstance().SetTexture(this, this._Image11, GameResPath.GetIcon("chat", "uilt_001"))
			ResManager.GetInstance().SetTexture(this, this._Image2, GameResPath.GetIcon("chat", "uilt_020"))
		}

		this.open_callback = () => {
			this._model.private_chat_view_open = true
			this.initView()
			this.initTab()
			this.SetCanvasVisible(0)
		}

		this.close_callback = () => {
			this._model.private_chat_view_open = false
			this._model.openChatId = 0
			_touchChat = false
			this.local_ChatModel.delNoMsgPlayer()
			if (chat_list && chat_list.length > 0) {
				for (let k in chat_list) {
					var v = chat_list[k]
					v.DeleteMe()
				}
				chat_list = []
			}

			if (mine_chat_list && mine_chat_list.length > 0) {
				for (let k in mine_chat_list) {
					var v = mine_chat_list[k]
					v.DeleteMe()
				}
				mine_chat_list = []
			}
			if (this.loop_mgr) {
				this.loop_mgr.DeleteMe()
				this.loop_mgr = null
			}
			if (this.time_id) {
				GlobalTimerQuest.CancelQuest(this.time_id)
				this.time_id = null
			}
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this.sendBtn, () => {
				let level = local_RoleManager.GetMainRoleVo().level
				if (level < 60) {
					Message.show('60级开启私聊好友功能')
					return
				}
				let msg = this._input.text
				if (msg == "") {
					Message.show(_textLabel)
					return
				}
				let send_func = () => {
					this._send = true
					// let tmpArgs = this.local_ChatModel.GetAllArgsText(msg)
					// msg = this.local_ChatModel.GetHyperlinkText(msg)
					let roleVo = local_RoleManager.GetMainRoleVo()
					// this.local_ChatModel.Fire(local_ChatModelEvent.CHAT_SEND_MSG, 11001, local_CHAT_TYPE.PRIVATE_CHAT, roleVo.province, roleVo.city, this._vo.role_id, msg, tmpArgs, 0, "")
					let [sendGoods, goods_id_list, sendGoodsMesg] = this.local_ChatModel.sendGoodsMesg(msg)
					// if (table.find(this.local_ChatModel.SPECIAL_CHANNEL, _channel) != -1 && goods_id_list.length > 0 ) {
					// 	this.local_ChatModel.Fire(local_ChatModelEvent.SEND_SPECIAL_CHANNEL_GOODS, _channel, goods_id_list)
					// }
					this.local_ChatModel.Fire(local_ChatModelEvent.CHAT_SEND_MSG, 11001, local_CHAT_TYPE.PRIVATE_CHAT, roleVo.province, roleVo.city, this._vo.role_id, sendGoodsMesg, sendGoods, 0, "", this._vo.name)
					EyouManager.GetInstance().FirstChatDataPost()
				}
				send_func()
			}
				, this, true)
			Util.AddClickEvent(this.faceBtn, () => {
				this._model.Fire(local_FriendEvent.OPEN_FACE_PANEL, this.faceBtn.localToGlobal(new Laya.Point(0, 0), true))
				this.local_ChatModel.selectChannel = local_CHAT_TYPE.PRIVATE_CHAT
				// _model.Fire(local_ChatModelEvent.OPENTOOLPANEL, this.faceBtn.localToGlobal())

				// let worldCamera = GameObject.Find("root/Canvas/UI").GetComponent("Canvas").worldCamera
				// let screen_pos = worldCamera.WorldToScreenPoint(new Vector3(this.faceBtn.position.x, this.faceBtn.position.y, 0))

				// this.local_ChatModel.Fire(local_ChatModelEvent.OPENTOOLPANEL, new Vector2(25, 339), new Vector2(440, - 482))
			}
				, this, true)

			Util.AddClickEvent(this._send_flower, ()=> {
				GlobalEventSystem.Fire(EventName.OPEN_VIEW, "MarriageFlowerView", this._vo)
			}, this, true)

			let addFace = (...new_args) => {
				let args = new_args
				if (args[0]) {
					let face_str = "<f_" + args[0] + ">"
					if (this._input.text.length + face_str.length <= this._input.maxChars || this._input.maxChars == 0) {
						this._input.text = this._input.text + face_str
					}
				}
			}

			this.BindEvent(this.local_ChatModel, local_ChatModelEvent.ADD_FACE, addFace)
			let update = (id?, data?) => {
				if (this._vo.role_id == id) {
					ChatModel.GetInstance().reSetPrivateNum(this._vo.role_id)
					this.local_ChatModel.Fire(local_ChatModelEvent.REQUEST_PROTO, 11027, "cl", local_CHAT_TYPE.PRIVATE_CHAT, this._vo.role_id)

					//消除当前私聊红点
					this.updateChat(data)
				} else {
					let vo = data.player_list[0]
					if (!vo) {
						return
					}
					let friendVo = {
						role_id: vo.player_id,
						picture: vo.picture,
						dress_list: vo.dress_list,
						lv: vo.level,
						career: vo.career,
						role_name: vo.name
					}
					this.local_ChatModel.addPrivateChatTab(friendVo, true)
					this.initTab()
					if (this._vo.role_id == vo.role_id) { return }
					// this._vo = friendVo
					// this.initView()
				}
			}

			this.BindEvent(this.local_ChatModel, local_ChatModelEvent.CHAT_MSG_UPDATE, update)
			this.BindEvent(this.local_ChatModel, local_ChatModelEvent.CLEAR_ROLE_PRIVATE, (role_id?) => {
				if (role_id != this._vo.role_id) {
					return
				}
				let list = []
				list = list.concat(this.GetdataList())
			}
			)
			Util.AddClickEvent(this._bag, (e?) => {
				this.local_ChatModel.selectChannel = local_CHAT_TYPE.PRIVATE_CHAT
				let arrow_pos_list = {x: 68, y: 476}
				this.local_ChatModel.Fire(local_ChatModelEvent.OPENBAGPANEL, new Vector2(e.stageX, e.stageY), arrow_pos_list)
			}
				, this, true)
			let addGoods = (...new_args) => {
				let args = new_args
				let data = args[0]
				let goods_name = data.goods_name
				let name = "[" + goods_name + "]"
				if ((args[1] == local_CHAT_TYPE.PRIVATE_CHAT && this._input.text.length < this._input.maxChars) || this._input.maxChars == 0) {
					// let goodVo = args[1]
					// let str = this.local_ChatModel.EncryMsgForGoodsItem(goodVo)
					// this.local_ChatModel.ReplaceInputTextMark(this._input, str)
					let repetition = this._input.text.indexOf("[" + goods_name + "]")
					// let repetition = this._input.text.indexOf(`[${goods_name}]`, "[" + goods_name + "]")
					this.local_ChatModel.setSendGoodsData(data, repetition)
					this._input.text = this._input.text + name
				}
			}

			this.BindEvent(this.local_ChatModel, local_ChatModelEvent.ADD_BAG_GOODS, addGoods)
			Util.AddClickEvent(this._position, () => {
				if ((this._input.text.length < this._input.maxChars) || this._input.maxChars == 0) {
					let scene_info = SceneManager.GetInstance().scene_Info
					if (!scene_info) {
						return
					}
					let content = this.local_ChatModel.positionChat(scene_info)
					let channel = local_CHAT_TYPE.PRIVATE_CHAT
					let roleVo = RoleManager.GetInstance().GetMainRoleVo()
					// let str = "<" + scene_info.name + "(" + roleVo.pos_x + "," + roleVo.pos_y + ")>"
					// this.local_ChatModel.AddArgs(str, {"", content})
					// this._input.text = str
					this.local_ChatModel.Fire(local_ChatModelEvent.CHAT_SEND_MSG, 11001, channel, roleVo.province, roleVo.city, this._vo.role_id, content, {}, 0, "", this._vo.name)
					//this:SendMsg()
					//this._input.text = ""
				}
			}
				, this, true)
			this.BindEvent(this._model, local_ChatModelEvent.CHAT_BAG_OPEN, (bool?, Channel?) => {
				if (Channel == local_CHAT_TYPE.PRIVATE_CHAT) {
					this._img_bag_select.visible = bool
				}
			}
			)
			this.BindEvent(this.local_ChatModel, local_ChatModelEvent.PRIVATE_CHAT_PLAYER_INFO, (info?) => {
				this.initPlayerInfo(info)
			}
			)
			this.BindEvent(this._model, local_FriendEvent.INTIMACY_UPDATE, (data?) => {
				if ((!data || !this._vo) || data.role_id != this._vo.role_id) {
					return
				}
				this._lb_intimacy.text = data.intimacy + ''
			}
			)
			this.BindEvent(this._model, local_FriendEvent.FRIEND_OLINE_UPDATE, (data?) => {
				if (data.role_id != this._vo.role_id) {
					return
				}
				// [ts2lua]lua中0和空字符串也是true，此处data.online_flag == 0需要确认
				// let onlineStr = data.online_flag == 0 && "<font color='ff4f50'.length>(离线)</font>" || "<font color='639c12'.length>(在线)</font>"
				let onlineStrColor = data.online_flag == 0 && "#ff4f50" || "#0a953e"
				this._lb_online.text = data.online_flag == 0 && "(离线)" || "(在线)"
				this._lb_online.color = onlineStrColor
			}
			)
			this.BindEvent(this.local_ChatModel, local_ChatModelEvent.REMOVE_PRIVATE_CHAT, (sendId?) => {
				if (sendId == this._vo.role_id) {
					this.initView()
				}
			}
			)

			this.BindEvent(this._model, local_FriendEvent.UPDATE_CHAT_VIEW, (vo?) => {
				if (this._vo.role_id == vo.role_id) {
					ChatModel.GetInstance().reSetPrivateNum(this._vo.role_id)
					this.local_ChatModel.Fire(local_ChatModelEvent.REQUEST_PROTO, 11027, "cl", local_CHAT_TYPE.PRIVATE_CHAT, this._vo.role_id)
					//消除当前私聊红点
					return
				}
				// this._vo = vo
				this.local_ChatModel.addPrivateChatTab(vo, true)
				// this.initView()
				this.initTab()
			}
			)

			this.BindEvent(this._model, local_FriendEvent.UPDATE_MSG_POS, () => {
				this.SetCanvasVisible(1)
				// UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(this.Content)
				if (this.Content.width > this.contentScroller.width) {
					let a = this.Content.width
					this.Content.x = 0
					this.Content.y = a
				}
				//this.ScrcontentScroller.verticalNormalizedPosition = 0


			}
			)

			this.Content1.on(Laya.Event.RESIZE, this, () => {
				// console.log(this.Content1.displayHeight)
				this.contentScroller.vScrollBar.value = this.Content1.displayHeight
			});

			// Util.AddClickEvent(this.Content,this.tabTouchHandler,this);

			// this._input.onValueChanged.AddListener((text?) => {
			// 	if (this._input.maxChars != 0 && text.length >= this._input.maxChars) {
			// 		Message.show("单条信息不超过30字")
			// 	}
			// })

		}


		this.initView = () => {
			for (let key in chat_list) {
				let item = chat_list[key]
				item.SetVisible(false)
				item.DeleteMe()
			}
			chat_list = []
			this.local_ChatModel.Fire(local_ChatModelEvent.REQUEST_PROTO, 11027, "cl", local_CHAT_TYPE.PRIVATE_CHAT, this._vo.role_id)
			this.local_ChatModel.Fire(local_ChatModelEvent.REQUEST_PROTO, 11028, "l", this._vo.role_id)
			this._input.text = ""
			let list = this.GetdataList()
			let parent = this.Content1
			if (list && list.length > 0) {
				let myId = RoleManager.GetInstance().GetMainRoleId()
				let mine_index = 0
				let index = 0
				for (let i = 0; i < list.length; i++) {
					let sendId = list[i].player_list[0].player_id
					let is_mine = sendId == myId
					let item = null
					if (is_mine) {
						item = mine_chat_list[mine_index] && mine_chat_list[mine_index] || new FriendMineChatItem(parent)
						chat_list[index] = item
						index = index + 1
					} else {
						item = chat_list[index] && chat_list[index] || new FriendChatItem(parent)
						chat_list[index] = item
						index = index + 1
					}
					item.Load()
					item.SetData(list[i], i == list.length)
					item.SetVisible(true)
				}
			}
		}

		this.initPlayerInfo = (info?) => {
			// [ts2lua]lua中0和空字符串也是true，此处info.online_flag == 0需要确认
			let onlineStrColor = info.online_flag == 0 && "#ff4f50" || "#0a953e"
			this._lb_online.text = info.online_flag == 0 && "(离线)" || "(在线)"
			this._lb_online.color = onlineStrColor
			this.chatName.text = Util.StrToHTML(info.name)
			this._lb_fighting.text = info.combat_power
			let vip_Lv = info.vip_flag
			this._vip_icon.visible = vip_Lv > 0
			let str
			if (this._vip_icon.visible) {
				if(info.is_hide_vip > 0){
					str = "VIP-x"
					SetLocalScale(this._vip_icon, 1.5, 1.5, 1)
					if (info.supreme_vip == 1) {
						str = "SVIP-x"
						SetLocalScale(this._vip_icon, 1.8, 1.8, 1)
					}
				}
				else{
					str = "uivip_zjm_" + vip_Lv
					SetLocalScale(this._vip_icon, 1.5, 1.5, 1)
					if (info.supreme_vip == 1) {
						str = "VIP_" + vip_Lv
						SetLocalScale(this._vip_icon, 1.8, 1.8, 1)
					}
				}
				ResManager.GetInstance().SetImageSprite(this, this._vip_icon, "mainUI_asset", str)
				this._Group1.x = 192
			} else {
				this._Group1.x = 142
			}
			this._lb_intimacy.text = info.intimacy + ''
			this._lb_fighting.text = info.combat_power
			if (this.time_id) {
				GlobalTimerQuest.CancelQuest(this.time_id)
				this.time_id = null
			}
			this.time_id = GlobalTimerQuest.AddDelayQuest(() => {
				// UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(this._Group1)
			}, 0.1)

			// LayoutRebuilder(this._Group1)
		}

		this.initTab = () => {
			let list = this.local_ChatModel.PrivateChatTabList()
			this.tablist = list
			if (!this.loop_mgr) {
				this.loop_mgr = new LoopScrowViewMgr()
				this.loop_mgr.SetData(this.Content, FriendChatTabItem, list, LoopScrCon.Vertical, 1, this.tabTouchHandler)
			} else {
				this.loop_mgr.replaceAll(list)
			}

		}

		this.tabTouchHandler = (e?) => {
			// console.log(this.tablist[e])
			let vo = this.tablist[e]
			if (!this._vo || !vo || this._vo.role_id == vo.role_id) {
				return
			}
			this._vo = vo
			let item = e
			if (e != 0) {
				let data_list = this.loop_mgr.data_list
				let item = table.remove(data_list, e)
				let item0 = item[0]
				data_list.splice(0, 0, item0)
				this.loop_mgr.replaceAll(data_list)
				this.Content.selectedIndex = 0
			}
			this.local_ChatModel.reSetPrivateNum(this._vo.role_id)
			this._model.openChatId = this._vo.role_id
			this.initView()
		}

		this.updateChat = (data?) => {
			if (this.is_loaded) {
				if (this._send) {
					this._input.text = ""
					this._send = false
				}
				//let list = this.GetdataList()
				//if (list > this.local_ChatModel.privateChat ) {
				//_arrayCollection:removeItemAt(0)
				//}
				let parent = this.Content1
				let myId = RoleManager.GetInstance().GetMainRoleId()
				let sendId = data.player_list[0].player_id
				let is_mine = sendId == myId
				let item = is_mine && new FriendMineChatItem(parent) || new FriendChatItem(parent)
				item.Load()
				item.SetData(data, true, true)
				item.ExcuteCallback(() => {
					// item.transform.SetAsLastSibling()
				})
				table.insert(chat_list, item)
			}

			Laya.timer.once(50, this, () => {
				if (this.use_delete_method) return
				this.contentScroller.vScrollBar.value = chat_list.length * 160
			})
		}


	}

	public setData(data?) {

		this._vo = data
		this._model.openChatId = this._vo.role_id
		//私聊界面打开会从这里进入初始化tab
		this.local_ChatModel.addPrivateChatTab(this._vo)
	}

	public GetdataList() {

		let list = []
		let obj = this.local_ChatModel.getChannelChat(CHAT_TYPE.PRIVATE_CHAT)
		let sendId = this._vo.role_id
		// [ts2lua]obj下标访问可能不正确
		// [ts2lua]obj下标访问可能不正确
		list = obj[sendId] && obj[sendId][0] || []
		// list = list.concat({})
		return list
	}
	public SetCanvasVisible(show?) {

		// this.canvas_group = this.Content.GetComponent("CanvasGroup")
		// if (this.canvas_group == null ) {
		// 	// this.canvas_group = this.Content1.AddComponent(typeof(UnityEngine.CanvasGroup))
		// }
		// this.canvas_group.alpha = show
	}



	_Image11: Laya.Image
	_Image2: Laya.Image
	_Image3: Laya.Image
	_Group1: Laya.HBox
	_vip_icon: Laya.Image
	chatName: Laya.Label
	_lb_online: Laya.Label
	_Image4: Laya.Image
	_lb_intimacy: Laya.Label
	contentScroller: Laya.Panel
	Content1: Laya.VBox
	tabScroller: Laya.Panel
	Content: Laya.List
	_Group2: Laya.Box
	faceBtn: Laya.Box
	_Image1: Laya.Image
	text_input: Laya.Image
	Placeholder: Laya.Label
	Text: Laya.Label
	_Rect1: Laya.Box
	_input: Laya.TextInput
	sendBtn: Laya.Box
	_Image111: Laya.Image
	labelDisplay: Laya.Label
	_bag: Laya.Box
	_Image5: Laya.Image
	_Label1: Laya.Label
	_img_bag_select: Laya.Image
	_position: Laya.Box
	_Image6: Laya.Image
	_Label2: Laya.Label
	_lb_fighting: Laya.Label
	bg: Laya.Image
	lb_preventfraud: Laya.Label
	_send_flower: Laya.Box

	public GetComponents() {
		[
			this._Image11,
			this._Image2,
			this._Image3,
			this._Group1,
			this._vip_icon,
			this.chatName,
			this._lb_online,
			this._Image4,
			this._lb_intimacy,
			this.contentScroller,
			this.Content1,
			this.tabScroller,
			this.Content,
			this._Group2,
			this.faceBtn,
			this._Image1,
			this.text_input,
			this.Placeholder,
			this.Text,
			this._Rect1,
			this._input,
			this.sendBtn,
			this._Image111,
			this.labelDisplay,
			this._bag,
			this._Image5,
			this._Label1,
			this._img_bag_select,
			this._position,
			this._Image6,
			this._Label2,
			this._lb_fighting,
			this.bg,
			this.lb_preventfraud,
			this._send_flower
		]
			= this.GetChildrenByNames([

				"_Image11",
				"_Image2",
				"_Image3",
				"_Group1",
				"_vip_icon",
				"chatName",
				"_lb_online",
				"_Image4",
				"_lb_intimacy",
				"contentScroller",
				"Content1",
				"tabScroller",
				"Content",
				"_Group2",
				"faceBtn",
				"_Image1",
				"text_input",
				"Placeholder",
				"Text",
				"_Rect1",
				"_input",
				"sendBtn",
				"_Image111",
				"labelDisplay",
				"_bag",
				"_Image5",
				"_Label1",
				"_img_bag_select",
				"_position",
				"_Image6",
				"_Label2",
				"_lb_fighting",
				"bg",
				"lb_preventfraud",
				"_send_flower"
			])
		this.contentScroller.vScrollBarSkin = ""
	}
}
window["FriendChatView"] = FriendChatView
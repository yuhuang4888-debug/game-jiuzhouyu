import { BaseView1 } from "../common/BaseView1"
import { CustomRoleHead } from "../common/CustomRoleHead"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { table } from "../common/table"
import { CHAT_TYPE, ChatModel } from "../commonModel/ChatModel"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { FriendEvent, FriendModel } from "../commonModel/FriendModel"
import  "../friend/FriendViewButtonSkin"
import  "../friend/MenuRedButtonSkin"
// import { TeamEvent, TeamModel } from "../commonModel/TeamModel"
import { RoleManager } from "../commonModel/RoleManager"
import { SceneManager } from "../scene/SceneManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { SetSizeDeltaY } from "../util/Util"
import { Vector2 } from "../util/Vector2"

export class ChatMenuView extends BaseView1 {
	Content
	InitEvent
	Local_Open
	_scroller
	back_login_toClose
	background_alpha
	bind_one_id_team
	btnClickHandler
	btnGroup
	btn_label
	clickThis
	click_bg_toClose
	click_target
	close_callback
	destroy_imm
	img_bg
	initView
	open_callback
	removeEvent
	show_open_movie
	updateView
	use_background
	x
	y

	// ChatMenuView.Btn = [PLAYER_MSG=0, ADD_FRIEND=1, ADD_TIME=2, MASK_MSG=3, ADD_BLACK=4, SEND_GIFT=5, CANCEL_MASK_MSG=6, CANCEL_BLACK=7, DEL_FRIEND=8, START_CHAT=9];
	public static Btn = { PLAYER_MSG: 0, ADD_FRIEND: 1, ADD_TIME:2, MASK_MSG:3, ADD_BLACK: 4, SEND_GIFT: 5, CANCEL_MASK_MSG: 6, CANCEL_BLACK: 7, DEL_FRIEND: 8, START_CHAT: 9, COMPLAIN_HEAD: 10 };
	public constructor() {
		super()


		this.btn_label = ["查看信息", "加为好友", "邀请组队", "屏蔽信息", "拉入黑名单", "赠礼给TA", "取消屏蔽", "解除黑名单", "删除好友", "开始聊天", "举报头像"];
		this.base_file = "chat"
		this.layout_file = "ChatMenuView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.show_open_movie = true
		this.back_login_toClose = true
		this.click_bg_toClose = true
		this.use_background = true
		this.background_alpha = 0
		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName
		let local_FriendEvent = FriendEvent
		// let local_eui = eui
		let local_laya = Laya
		let local_CHAT_TYPE = CHAT_TYPE
		let btn_type = ChatMenuView.Btn
		let custom_activity_model = CustomActivityModel.GetInstance()
		let chat_model = ChatModel.GetInstance()
		// let team_model = TeamModel.GetInstance()
		let role_mgr = RoleManager.GetInstance()
		let _localPoint = null
		let id = 0
		let ser_id = 0
		let isPrivateChat = false
		let show_send_gift = null
		let _model = FriendModel.GetInstance()
		let _rela = 0
		let _btnList = []
		let _touchScroller = false
		let max = 4.5
		let role_data = null
		let channel = null
		let source = null
		let isPicture = null
		this.load_callback = () => {

			this.InitEvent()
			this.display_obj.visible = false
		}

		this.close_callback = () => {
			this.removeEvent()
		}

		this.open_callback = () => {
			this.initView()

			// if (this.click_target.click_menu_pos.x + this.form.sizeDelta.x > ScreenWidth ) {
			// 	this.click_target.click_menu_pos.x = ScreenWidth - this.form.sizeDelta.x
			// }
			// LayoutRebuilder(this.Content)
			// if (this.click_target.click_menu_pos.y - this.Content.sizeDelta.y < 0) {
			// 	this.click_target.click_menu_pos.y = this.Content.sizeDelta.y
			// }
			// let world_pos = UIScreenToWorldPoint(this.click_target.click_menu_pos)
			// SetGlobalPositionX(this.form, world_pos.x)
			// SetGlobalPositionY(this.form, world_pos.y)
		}

		// isPicture 是否自定义头像
		this.Local_Open = (...new_args) => {
			[this.click_target, id, ser_id, isPrivateChat, role_data, channel, source, isPicture] = new_args
			if(!this.click_target ) return
			 _localPoint = this.click_target.localToGlobal(new Laya.Point(0,0),true)
			// super.Open()
			// _localPoint = new Vector2(0, 0)
			super.Open()
		}

		this.InitEvent = () => {
			// this.BindEvent(local_GlobalEventSystem, local_EventName.STAGE_CLICK_EVENT,() => {
			// 		this.Close()
			// 	}
			// )
			let update = () => {
				this.updateView()
			}

			this.BindEvent(_model, local_FriendEvent.MENU_DATA_UPDTE, update)
		}

		this.clickThis = (e?) => {

		}

		this.initView = () => {
			this.display_obj.visible = true
			this.display_obj.x = _localPoint.x + 70
			this.display_obj.y = _localPoint.y + 20
			show_send_gift = channel == local_CHAT_TYPE.WORLD || channel == local_CHAT_TYPE.GUILD
			let server_id = role_mgr.GetMainRoleVo().server_unique_id
			let menu_data = FriendModel.GetInstance().getMenuData(id)
			if ((id != 0 && !menu_data) && (ser_id && ser_id == server_id)) {
				FriendModel.GetInstance().Fire(FriendEvent.REQUEST_MENU_DATA, id)
			} else {
				this.updateView()
			}
		}

		this.updateView = () => {
			if (this.is_loaded) {
				this.display_obj.visible = true
				let btnList = [btn_type.PLAYER_MSG, btn_type.ADD_FRIEND, btn_type.ADD_TIME, btn_type.MASK_MSG, btn_type.ADD_BLACK]
				if (show_send_gift && custom_activity_model.GetFlowerRankOpenStatus()) {
					btnList = [btn_type.PLAYER_MSG, btn_type.ADD_FRIEND, btn_type.ADD_TIME, btn_type.SEND_GIFT, btn_type.MASK_MSG, btn_type.ADD_BLACK]
				}
				let info = _model.getMenuData(id)
				if (info) {
					_rela = info.rela
					if (info.rela == 1) {
						if (show_send_gift && custom_activity_model.GetFlowerRankOpenStatus()) {
							btnList = [btn_type.PLAYER_MSG, btn_type.START_CHAT, btn_type.ADD_TIME, btn_type.DEL_FRIEND, btn_type.SEND_GIFT, btn_type.MASK_MSG, btn_type.ADD_BLACK]
						} else {
							btnList = [btn_type.PLAYER_MSG, btn_type.START_CHAT, btn_type.ADD_TIME, btn_type.DEL_FRIEND, btn_type.MASK_MSG, btn_type.ADD_BLACK]
						}
					} else if (info.rela == 3 || info.rela == 4) {
						btnList = [btn_type.PLAYER_MSG, btn_type.MASK_MSG, btn_type.ADD_BLACK]
					}
				}
				let server_id = role_mgr.GetMainRoleVo().server_unique_id
				if ((ser_id && ser_id != 0) && server_id != ser_id) {
					if (channel == local_CHAT_TYPE.SMALL_KUAFU && custom_activity_model.GetFlowerRankOpenStatus()) {
						btnList = [btn_type.PLAYER_MSG, btn_type.SEND_GIFT, btn_type.MASK_MSG]
					} else {
						btnList = [btn_type.PLAYER_MSG, btn_type.MASK_MSG]
					}
				}
				if (chat_model.checkPlayerShield(id)) {
					// let index = btnList.find(btn_type.MASK_MSG)
					let index = table.find(btnList, btn_type.MASK_MSG)
					if (index != -1) {
						// btnList.splice(index, 1, btn_type.CANCEL_MASK_MSG)
						btnList[index] = btn_type.CANCEL_MASK_MSG
					}
				}
				if (isPrivateChat) {
					// let index = btnList.find(btn_type.START_CHAT)
					let index = table.find(btnList, btn_type.START_CHAT)
					if (index != -1) {
						// btnList.splice(index, 1)
						ChatMenuView.remove(btnList, index)
					}
				}
				// if (team_model.team_info ) {
				// 	let index = table.find(btnList, btn_type.ADD_TIME)
				// 	if (index != -1 ) {
				// 		table.remove(btnList, index)
				// 	}
				// }
				if (source && source == "MarketPlzShowItem") {
					let list = [btn_type.MASK_MSG, btn_type.CANCEL_BLACK]
					for (let key in list) {

						let type = list[key]
						let index = table.find(btnList, type)
						if (index != -1) {
							ChatMenuView.remove(btnList, index)
						}
					}
				}

				if (isPicture) {
					table.insert(btnList, btn_type.COMPLAIN_HEAD)
				}

				let btn = null
				let label = ""
				let index = 0
				let i = 1
				for (let i = 0; i < btnList.length; i++) {
					let v = btnList[i]
					btn = _btnList[i]
					let type = btnList[i]
					label = this.btn_label[type]
					let prefab_name = ""
					if (type == btn_type.ADD_BLACK || type == btn_type.CANCEL_BLACK || type == btn_type.MASK_MSG || type == btn_type.CANCEL_MASK_MSG || type == btn_type.COMPLAIN_HEAD) {
						prefab_name = "MenuRedButtonSkin"
					} else {
						prefab_name = "FriendViewButtonSkin"
					}
					if (!btn) {
						let btnclass=window[prefab_name]
						btn =new btnclass(this.Content)
						table.insert(_btnList, btn)
					}
					btn.SetData({ label: label, clickFunc: this.btnClickHandler, name: type })
					btn.Load()
					index = index + 1
				}

				if (index < _btnList.length) {
					let i = _btnList.length - 1
					do {
						btn = _btnList[i]
						btn.SetVisible(false)
						i = i - 1
					} while ((i >= index))
				}
				SetSizeDeltaY(this._scroller, (btnList.length > max && (max * 60) || (btnList.length * 60)))
				SetSizeDeltaY(this.img_bg, (btnList.length > max && (max * 60 + 20) || (btnList.length * 60 + 20)))
				SetSizeDeltaY(this.display_obj,this._scroller.height)
			}
		}

		this.btnClickHandler = (item?) => {
			let btn = item
			// if (id == 0 ) {
			// 	Message.show("玩家已下线")
			// 	return
			// }
			// let type = Number(btn.name)
			let type = Number(btn.data.name)
			let removeMenuData = () => {
				if (id) {
					FriendModel.GetInstance().setMenuData(id, null)
				}
			}
			if (btn_type.PLAYER_MSG == type) {
				if (0 == id) {
					GlobalEventSystem.Fire(local_EventName.OPEN_PLAYER_MESSAGE_VIEW, role_data)
				} else {
					_model.requestPlayerMessage(id, false, ser_id)
				}
			} else if (btn_type.ADD_FRIEND == type) {
				_model.Fire(local_FriendEvent.ADD_FRIEND, id)
				removeMenuData()
			} else if (btn_type.ADD_BLACK == type) {
				_model.Fire(local_FriendEvent.FRIENDS_OPERATIONT, 2, id)
				removeMenuData()
			} else if (btn_type.CANCEL_BLACK == type) {
				_model.Fire(local_FriendEvent.FRIENDS_OPERATIONT, 3, id)
				removeMenuData()
			} else if (btn_type.START_CHAT == type) {
				let vo = _model.getFriendById(id)
				if (vo) {
					_model.Fire(local_FriendEvent.OPEN_CHAT_VIEW, vo)
				}
			} else if (btn_type.DEL_FRIEND == type) {
				_model.Fire(local_FriendEvent.FRIENDS_OPERATIONT, 1, id)
				removeMenuData()
			} else if (btn_type.ADD_TIME == type) {
				// let team_info = team_model.team_info
				// if (! team_info ) {
				// 	if (! this.bind_one_id_team ) {
				// 		this.bind_one_id_team = team_model.Bind(TeamEvent.TEAM_BUILD_SUCCESS,() => {
				// 				let team_info = team_model.team_info
				// 				if (team_info ) {
				// 					team_model.InviteJoinTeam(id)
				// 				}
				// 				if (this.bind_one_id_team ) {
				// 					team_model.UnBind(this.bind_one_id_team)
				// 					this.bind_one_id_team = null
				// 				}
				// 			}
				// 		)
				// 	}
				// 	let scene_id = SceneManager.GetInstance().GetSceneId()
				// 	team_model.Fire(TeamEvent.TEAM_REQUEST_PROTO, 24000, "ccihhi", team_model.activity_id, team_model.activity_sub_id, scene_id
				// 		, team_model.min_level, team_model.max_level, 0)
				// }else{
				// 	team_model.InviteJoinTeam(id)
				// }
				removeMenuData()
			} else if (btn_type.MASK_MSG == type) {
				chat_model.addPlayerShield(id)
			} else if (btn_type.CANCEL_MASK_MSG == type) {
				chat_model.delPlayerShield(id)
			} else if (btn_type.SEND_GIFT == type) {
				if (role_data) {
					local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "MarriageFlowerView", role_data)
				}
			} else if (btn_type.COMPLAIN_HEAD == type) {
				CustomRoleHead.GetInstance().ComplainRoleHead(id)
				removeMenuData()
			}
			this.Close()
		}

		this.removeEvent = () => {
			// _touchScroller = false
			// for (let key in _btnList) {

			// 	let btn = _btnList[key]
			// 	btn.DeleteMe()
			// 	btn=null
			// }
			if(_btnList&&_btnList.length>0){
				for(let i=0;i<_btnList.length;i++){
					_btnList[i].DeleteMe()
					_btnList[i]=null
				}
			}
			_btnList = []
			// this.click_target = null
			// isPrivateChat = null
			// ResManager.GetInstance().DestroyAllReferenceRes(this.hashCode)
		}


	}

	public clickTarget() {

		return this.click_target
	}

	public Open(...new_args) {

		this.Local_Open(...new_args)
	}

	public static remove(list, index?) {
		if (list) {
			if (index != null) {
				return list.splice(index, 1)
			} else {
				return list.pop()
			}
		}
	}
	_Group1: Laya.VBox

	public GetComponents() {
		[
			this.img_bg,
			this._Group1,
			this._scroller,
			this.Content,
		]
			= this.GetChildrenByNames([

				"img_bg",
				"_Group1",
				"_scroller",
				"Content",
			])
			this._scroller.vScrollBarSkin=""
	}
}

window["ChatMenuView"] = ChatMenuView
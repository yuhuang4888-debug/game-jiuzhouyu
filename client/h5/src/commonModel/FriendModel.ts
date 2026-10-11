import { CommonManager } from "../common/CommonManager";
import { Config } from "../common/Config";
import { CongratulationObtainView } from "../common/CongratulationObtainView";
import { EventName } from "../common/EventName";
import { ResManager } from "../common/ResManager";
import { table } from "../common/table";
import { RoleManager } from "./RoleManager";
import { ColorUtil } from "../util/ColorUtil";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { EventDispatcher } from "../util/EventDispatcher";
import { TimeUtil } from "../util/TimeUtil";
import { ChatModel, ChatModelEvent, CHAT_TYPE } from "./ChatModel";
//import { ChatModel, ChatModelEvent, CHAT_TYPE } from "./ChatModel";
import { GoodsModel } from "./GoodsModel";
import { MainUIModel } from "./MainUIModel";
import { Util } from "../util/Util";

//查看信息功能代码和对应模块类似。

export enum FRIEND_CONFIG {
	CONFIGRANDOMNAME = 1,
	CLIENTFIGHTCOM = 2
}
window["FRIEND_CONFIG"] = FRIEND_CONFIG
export enum FRIEND_TYPE {
	FRIEND = 1,
	ENEMY = 2,
	BLACKLIST = 3
}
window["FRIEND_TYPE"] = FRIEND_TYPE
export const FriendEvent = {
	OPEN_BLACK_VIEW: "FriendEvent.OPEN_BLACK_VIEW", UPDATE_MSG_POS: "UPDATE_MSG_POS", UPDATE_CHAT_VIEW: "UPDATE_CHAT_VIEW", UPDATE_MESSAGE_TAB: "UPDATE_MESSAGE_TAB", SELECT_TAB: "SELECT_TAB",
	CLOSE_BUTTON_LIST: "CLOSE_BUTTON_LIST", UPDATE_MENU_VIEW: "UPDATE_MENU_VIEW", OPEN_ADD_VIEW: "FriendEvent.OPEN_ADD_VIEW", OPEN_APPLY_VIEW: "FriendEvent.OPEN_APPLY_VIEW",
	OPEN_CHAT_VIEW: "FriendEvent.OPEN_CHAT_VIEW", OPEN_FACE_PANEL: "FriendEvent.OPEN_FACE_PANEL", OPEN_FRIEND_MENU: "FriendEvent.OPEN_FRIEND_MENU", OPEN_PLAYER_MENU: "FriendEvent.OPEN_PLAYER_MENU",
	OPEN_EMAIL_VIEW: "FriendEvent.OPEN_EMAIL_VIEW", REQUEST_FRIEND_DATA: "FriendEvent.REQUEST_FRIEND_DATA", FRIEND_DATA_UPDATE: "FriendEvent.FRIEND_DATA_UPDATE"
	, REQUEST_RECOMMEND_DATA: "FriendEvent.REQUEST_RECOMMEND_DATA", RECOMMEND_DATA_UPDATE: "FriendEvent.RECOMMEND_DATA_UPDATE", CHECK_PLAYER: "FriendEvent.CHECK_PLAYER",
	ADD_FRIEND: "FriendEvent.ADD_FRIEND", ONECLICK_APPLY: "FriendEvent.ONECLICK_APPLY", ONE_APPLY: "FriendEvent.ONE_APPLY", REQUEST_APPLY_DATA: "FriendEvent.REQUEST_APPLY_DATA",
	FRIENDS_OPERATIONT: "FriendEvent.FRIENDS_OPERATIONT", APPLY_DATA_UPDATE: "FriendEvent.APPLY_DATA_UPDATE", FRIEND_REDDOT_UPDATE: "FriendEvent.FRIEND_REDDOT_UPDATE",
	FRIEND_OLINE_UPDATE: "FriendEvent.FRIEND_OLINE_UPDATE", REQUEST_MENU_DATA: "FriendEvent.REQUEST_MENU_DATA", MENU_DATA_UPDTE: "FriendEvent.MENU_DATA_UPDTE",
	REQUEST_EMAIL_DATA: "FriendEvent.REQUEST_EMAIL_DATA", EMAIL_DATA_UPDATE: "FriendEvent.EMAIL_DATA_UPDATE", REQUEST_EMAIL_INFO: "FriendEvent.REQUEST_EMAIL_INFO",
	REQUEST_DELET_EMAIL: "FriendEvent.REQUEST_DELET_EMAIL", REQUEST_EMAIL_REWARD: "FriendEvent.REQUEST_EMAIL_REWARD", EMAIL_REWARD_UPDATE: "FriendEvent.EMAIL_REWARD_UPDATE",
	EMAIL_ICON_UPDATE: "FriendEvent.EMAIL_ICON_UPDATE", EMAIL_VIEW_OPEN: "FriendEvent.EMAIL_VIEW_OPEN", SEND_GUILD_MAIL: "FriendEvent.SEND_GUILD_MAIL",
	REQUEST_PLAYER_MESSAGE: "FriendEvent.REQUEST_PLAYER_MESSAGE", PLAYER_MESSAGE_UPDATE: "FriendEvent.PLAYER_MESSAGE_UPDATE", REQUEST_KUAFU_PLAYER_MESSAGE: "FriendEvent.REQUEST_KUAFU_PLAYER_MESSAGE",
	REQUEST_KUAFU_GOODS_MESSAGE: "FriendEvent.REQUEST_KUAFU_GOODS_MESSAGE", SUBMIT_SUCCESS: "SUBMIT_SUCCESS", CUSTOMER_SERVICE: "CUSTOMER_SERVICE", NEWAPPLY_CHANGE: "NEWAPPLY_CHANGE", CLOSE_MES_VIEW: "CLOSE_MES_VIEW", UPDATE_FIGHT_DATA: "UPDATE_FIGHT_DATA", REQUEST_PROTO: "REQUEST_PROTO", INTIMACY_UPDATE: "FriendEvent.INTIMACY_UPDATE",
	UPDATE_PLAYERMESSAGE_GUARD : "UPDATE_PLAYERMESSAGE_GUARD",
	UPDATE_PLAYERMESSAGE_DRAGONBALL: "UPDATE_PLAYERMESSAGE_DRAGONBALL",
	UPDATE_PLAYERMESSAGE_HOLYSEAL : "UPDATE_PLAYERMESSAGE_HOLYSEAL",
	UPDATE_PLAYERMESSAGE_LONGLANGUAGE: "UPDATE_PLAYERMESSAGE_LONGLANGUAGE",
	UPDATE_PLAYERMESSAGE_ILLUSION : "UPDATE_PLAYERMESSAGE_ILLUSION",
	UPDATE_PLAYERMESSAGE_REVELATION : "UPDATE_PLAYERMESSAGE_REVELATION",
	UPDATE_PLAYERMESSAGE_PET:"UPDATE_PLAYERMESSAGE_PET",
	UPDATE_PLAYERMESSAGE_GODBEFALL : "UPDATE_PLAYERMESSAGE_GODBEFALL",
	UPDATE_PLAYERMESSAGE_LUNG: "UPDATE_PLAYERMESSAGE_LUNG",
	UPDATE_PLAYERMESSAGE_RUNE : "UPDATE_PLAYERMESSAGE_RUNE",
	UPDATE_PLAYERMESSAGE_UNREAL: "UPDATE_PLAYERMESSAGE_UNREAL",
	UPDATE_PLAYERMESSAGE_GODBEAST: "UPDATE_PLAYERMESSAGE_GODBEAST",
	REQUEST_PLAYERMESSAGE_EVENT: "REQUEST_PLAYERMESSAGE_EVENT",
	UPDATE_FAERIES_EVENT: "UPDATE_FAERIES_EVENT",
}
window["FriendEvent"] = FriendEvent
export class FriendModel extends EventDispatcher {
	GetNoGetRewardEmailList
	ResConfig
	_applyList
	_emailList
	_haveNewApply
	_playerId
	_recommendList
	addEmail
	addFriendToList
	addRecommendId
	allRewardEmailList
	applyType
	binEmailRedDot
	binFriendRedDot
	binRedDot
	changeFriendList
	changeRecommendState
	checkPlayer
	cleanEquipRequestTime
	cleanRecommendList
	config
	delApplyer
	delFriendList
	delIdForRecommendList
	deletEmail
	dummyPlayer
	
	dummyPlayerList
	emailHasNoGetReward
	emailReward
	equipRequestTime
	flushOperationtView
	formatEmailContent
	friendOperationt
	getEmailById
	getEmailInfo
	getEmailReward
	getEquipRequestTime
	getFriendById
	getFriendData
	getFriendDataReturnNew
	getMenuData
	getOnlineDataNum
	initEvent
	is_unread_mail
	now_select_index
	oneApplyId
	openChatId
	playerMessage
	player_dic
	private_chat_view_open
	processEquipListData
	reSetApplyList
	removeMenuData
	requestPlayerMessage
	setApplyList
	setCheckPlayerData
	setEmailData
	setEmailInfo
	setFriendData
	setMenuData
	setPlayerMessage
	setRecommendData
	showGetReward
	sortEmail
	updateFriendOline
	updateIntimacy
	static Instance: FriendModel;
	SetIllusionInfo
	other_player_illusion_info
	other_demon_info
	public constructor() {
		super()


		this.config = [];
		this.is_unread_mail = false;
		this.private_chat_view_open = false;
		this.player_dic = [];
		this.checkPlayer = false;
		this.addRecommendId = 0;
		this.applyType = -1;
		this.oneApplyId = 0;
		this._haveNewApply = false;
		this.friendOperationt = 0;
		this.openChatId = 0;
		this._recommendList = [];
		this._applyList = [];
		this._emailList = []
		this._playerId = 0;
		this.now_select_index = 1
		this.other_demon_info = []
		let local_FRIEND_CONFIG = FRIEND_CONFIG
		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName
		let local_FriendEvent = FriendEvent
		let chat_model = ChatModel.GetInstance()
		let local_ChatModelEvent = ChatModelEvent
		let local_FRIEND_TYPE = FRIEND_TYPE
		let goods_model = GoodsModel.GetInstance()
		let local_TimeUtil = TimeUtil
		let role_mgr = RoleManager.GetInstance()
		let friendDic = []
		let checkVo = {}
		let menuDataDic = []
		let _binFriendRedDot = false
		let emailInfoDic = []
		let _binEmailRedDot = false
		let success_view = null
		let _playerMessage = []
		let _equipRequestTime = []
		let red_index = {
			friend: 1,
			mail: 2
		}
		this.ResConfig = () => {
			this.config[local_FRIEND_CONFIG.CONFIGRANDOMNAME] = Config.PRELOAD_CLIENT_CONFIG.ConfigRandomName
			this.config[local_FRIEND_CONFIG.CLIENTFIGHTCOM] = Config.PRELOAD_CLIENT_CONFIG.ClientFightCom
		}

		this.initEvent = () => {
			let updateFriendRedDot = () => {
				//local_GlobalEventSystem:Fire(local_EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Friend)
				MainUIModel.GetInstance().Fire(MainUIModel.REFRESH_FRIEND_AND_MAIL_RED, red_index.friend, this.GetRed())
				MainUIModel.GetInstance().friend_red=MainUIModel.GetInstance().friend_red || this.GetRed()
			}
			let updatemailRedDot = () => {
				//local_GlobalEventSystem:Fire(local_EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Friend)
				MainUIModel.GetInstance().Fire(MainUIModel.REFRESH_FRIEND_AND_MAIL_RED, red_index.mail, this.GetRed())
				MainUIModel.GetInstance().friend_red=MainUIModel.GetInstance().friend_red || this.GetRed()
			}

			this.Bind(local_FriendEvent.EMAIL_DATA_UPDATE, updatemailRedDot)
			this.Bind(local_FriendEvent.EMAIL_REWARD_UPDATE, updatemailRedDot)
			this.Bind(local_FriendEvent.FRIEND_REDDOT_UPDATE, updateFriendRedDot)
			this.Bind(local_FriendEvent.APPLY_DATA_UPDATE, updateFriendRedDot)
			//未曾引入
			chat_model.Bind(local_ChatModelEvent.CHAT_MSG_UPDATE, updateFriendRedDot)
		}

		this.binRedDot = () => {
			this.binFriendRedDot()
			this.binEmailRedDot()
		}

		this.setFriendData = (data?) => {
			// [ts2lua]friendDic下标访问可能不正确
			friendDic[data.type] = data.rela_list
			this.Fire(local_FriendEvent.FRIEND_DATA_UPDATE, data.type)
		}

		this.getFriendData = (type?, is_sort?) => {
			let list = []
			//未曾引入
			// [ts2lua]friendDic下标访问可能不正确
			if (friendDic[type] ) {
				// [ts2lua]friendDic下标访问可能不正确
				list = friendDic[type]
			}
			if (is_sort ) {
				table.sort(list,(a?, b?) => {
						let aIndex = 0
						let bIndex = 0
						if (a.online_flag == 1 ) {
							aIndex = aIndex + 100
						}
						if (b.online_flag == 1 ) {
							bIndex = bIndex + 100
						}

						let obj = chat_model.getChannelChat(CHAT_TYPE.PRIVATE_CHAT)
						let sendId = a.role_id
						let num = 0
						// [ts2lua]obj下标访问可能不正确
						if (obj[sendId] ) {
							// [ts2lua]obj下标访问可能不正确
							num = obj[sendId][1]
						}
						if (num > 0 ) {
							aIndex = aIndex + 100 + num
						}
						sendId = b.role_id
						// [ts2lua]obj下标访问可能不正确
						num = 0
						if (obj[sendId] ) {
							// [ts2lua]obj下标访问可能不正确
							num = obj[sendId][1]
						}
						if (num > 0 ) {
							bIndex = bIndex + 100 + num
						}
						a.index = aIndex
						b.index = bIndex
						if (a.index > b.index ) {
							return true
						} else if (a.index == b.index ) {
							if (a.intimacy > b.intimacy ) {
								return true
							} else if (a.intimacy == b.intimacy ) {
								if (a.combat_power > b.combat_power ) {
									return true
								}
								return false
							}
							return false
						}
						return false
					}
				)
			}
			return list

		}

		this.getFriendDataReturnNew = (type?) => {
			let list = []
			let flist = this.getFriendData(type)
			return list.concat(flist)
		}

		this.getFriendById = (id?) => {
			if (id == null) {
				return
			}
			let list = []
			if (friendDic[local_FRIEND_TYPE.FRIEND]) {
				// [ts2lua]friendDic下标访问可能不正确
				list = friendDic[local_FRIEND_TYPE.FRIEND]
			}
			let vo = null
			for (let key in list) {

				// [ts2lua]list下标访问可能不正确
				vo = list[key]
				if (vo.role_id == id) {
					return vo
				}
			}
			return null
		}

		this.getOnlineDataNum = (type?) => {
			let list = []
			let num = 0
			// [ts2lua]friendDic下标访问可能不正确
			if (friendDic[type]) {
				// [ts2lua]friendDic下标访问可能不正确
				list = friendDic[type]
			}
			for (let key in list) {

				// [ts2lua]list下标访问可能不正确
				let vo = list[key]
				if (vo.online_flag == 1) {
					num = num + 1
				}
			}
			return num
		}

		this.setRecommendData = (data?) => {
			this._recommendList = data.recommended_list
			this.Fire(local_FriendEvent.RECOMMEND_DATA_UPDATE)
		}

		this.delIdForRecommendList = () => {
			let id = this.addRecommendId
			let flag = false
			if (id == 0) {
				return
			}
			let vo = null
			let i = this._recommendList.length - 1
			do {
				vo = this._recommendList[i]
				if (vo.role_id == id) {
					this._recommendList.splice(i, 1)
					this.addRecommendId = 0
					flag = true
					break
				}
				i = i - 1
			} while ((i >= 0))
			if (flag) {
				this.Fire(local_FriendEvent.RECOMMEND_DATA_UPDATE)
			}
		}

		this.changeRecommendState = () => {
			let id = this.addRecommendId
			let flag = false
			if (id == 0) {
				return
			}
			let vo = null
			let i = this._recommendList.length - 1
			if (i >= 0) {
				do {
					vo = this._recommendList[i]
					if (vo.role_id == id) {
						vo.applyFriend = true
						flag = true
						break
					}
					i = i - 1
				} while ((i >= 0))
			}
			if (flag) {
				this.Fire(local_FriendEvent.RECOMMEND_DATA_UPDATE)
			}
		}

		this.setCheckPlayerData = (data?) => {
			checkVo = {
				role_id: data.role_id,
				role_name: data.role_name,
				career: data.career,
				sex: data.sex,
				turn: data.turn,
				lv: data.lv,
				vip: data.vip,
				picture: data.picture,
				picture_ver: data.picture_ver,
				online_flag: data.online_flag,
				combat_power: data.combat_power
			}
			this._recommendList = []
			table.insert(this._recommendList, checkVo)
			this.Fire(local_FriendEvent.RECOMMEND_DATA_UPDATE)
		}

		this.cleanRecommendList = () => {
			this._recommendList = []
			this.Fire(local_FriendEvent.RECOMMEND_DATA_UPDATE)
		}

		this.setApplyList = (data?) => {
			this._applyList = data.ask_list
			this.SethaveNewApply(this._applyList.length > 0)
			this.Fire(local_FriendEvent.APPLY_DATA_UPDATE)
			this.Fire(local_FriendEvent.FRIEND_REDDOT_UPDATE)
		}

		this.delApplyer = () => {
			this.SethaveNewApply(false)
			let id = this.oneApplyId
			if (id == 0) {
				return
			}
			let vo = null

			for (let i = this._applyList.length-1; i >= 0; i -= 1) {
				vo = this._applyList[i]
				if (vo.role_id == id) {
					table.remove(this._applyList, i)
					this.oneApplyId = 0
					break
				}

			}
			this.Fire(local_FriendEvent.APPLY_DATA_UPDATE)
			this.Fire(local_FriendEvent.FRIEND_REDDOT_UPDATE)
			if (this.applyType == 1) {
				this.Fire(local_FriendEvent.REQUEST_FRIEND_DATA, 1)
			}
		}

		this.reSetApplyList = () => {
			this._applyList = []
			this.SethaveNewApply(false)
			this.Fire(local_FriendEvent.APPLY_DATA_UPDATE)
			this.Fire(local_FriendEvent.FRIEND_REDDOT_UPDATE)
			if (this.applyType == 1) {
				this.Fire(local_FriendEvent.REQUEST_FRIEND_DATA, 1)
			}
		}

		this.addFriendToList = (data?) => {
			let is_have = false
			if (this._applyList && this._applyList.length > 0) {
				for (let k in this._applyList) {
					var v = this._applyList[k]

					if (v.role_id == data.role_id) {
						is_have = true
						break
					}
				}
			}


			if (is_have == false) {
				let vo = {}
				vo = {
					role_id: data.role_id,
					role_name: data.role_name,
					lv: data.lv,
					add_time: data.add_time,
					career: data.career,
					combat_power: data.combat_power
				}
				table.insert(this._applyList, vo)
				this.Fire(local_FriendEvent.APPLY_DATA_UPDATE)
				this.SethaveNewApply(true)
				this.Fire(local_FriendEvent.FRIEND_REDDOT_UPDATE)
			}

		}

		this.changeFriendList = (data?) => {
			let list = []
			let flag = false
			for (let key in data.update_list) {

				// [ts2lua]data.update_list下标访问可能不正确
				let info = data.update_list[key]
				list = this.getFriendData(info.type)
				for (let key in info.role_list) {

					// [ts2lua]info.role_list下标访问可能不正确
					let voInfo = info.role_list[key]
					flag = false
					let i = 0
					if (list && list.length > 0) {
						do {
							let vo = list[i]
							if (vo.role_id == voInfo.role_id) {
								vo = voInfo
								flag = true
								break
							}
							i = i + 1
						} while ((i < list.length))
					}

					if (!flag) {
						table.insert(list, voInfo)
					}
				}
				this.Fire(local_FriendEvent.FRIEND_DATA_UPDATE, info.type)
			}
		}

		this.delFriendList = (data?) => {
			let list = []
			for (let key in data.update_list) {

				let info = data.update_list[key]
				list = this.getFriendData(info.type)
				for (let key in info.role_ids) {

					let id = info.role_ids[key]

					for (let i = list.length-1; i >= 0; i -= 1) {
						let vo = list[i]
						if (vo.role_id == id.role_id) {
							table.remove(list, i)
							break
						}
					}
				}
				this.Fire(local_FriendEvent.FRIEND_DATA_UPDATE, info.type)
			}
		}

		this.setMenuData = (id?, data?, replace?, update?) => {
			if (replace == null) {
				replace = true
			}
			if (update == null) {
				update = false
			}
			if (id == null) {
				return
			}
			let lastData = menuDataDic[id]
			let index = data && data.index
			if (lastData && !replace) {
				data["point"] = lastData.point
				data["requestTime"] = lastData.requestTime
				index = lastData.index
			}
			if (!menuDataDic[id]) {
				menuDataDic[id] = []
			}
			menuDataDic[id] = data
			if (update) {
				this.Fire(local_FriendEvent.MENU_DATA_UPDTE, id, index)
			}
		}

		this.getMenuData = (id?) => {
			return menuDataDic[id]
		}

		this.removeMenuData = () => {
			for (let key in menuDataDic) {

				menuDataDic[key] = null
			}
		}

		this.flushOperationtView = () => {
			let chatType = this.friendOperationt
			if (chatType == 0) {
				return
			}
			// [ts2lua]lua中0和空字符串也是true，此处chatType == 2需要确认
			chatType = chatType == 2 && 1 || chatType
			this.Fire(local_FriendEvent.REQUEST_FRIEND_DATA, chatType)
			this.friendOperationt = 0
		}

		this.binFriendRedDot = () => {
			if (_binFriendRedDot) {
				return
			}
			let changeFriendRedDot = () => {
				let funOpen = CommonManager.GetInstance().CheckFuncOpenState("FriendEnterView", false)
				if (funOpen) {
					local_GlobalEventSystem.Fire(local_EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "FriendEnterView", 0, this.GetfriendRedDot())
					MainUIModel.GetInstance().Fire(MainUIModel.REFRESH_FRIEND_AND_MAIL_RED, red_index.friend, this.GetRed())
					MainUIModel.GetInstance().friend_red=MainUIModel.GetInstance().friend_red || this.GetRed()
					//local_GlobalEventSystem:Fire(local_EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Friend)
				}
			}

			if (FriendModel.GetInstance().GethaveNewApply()) {
				changeFriendRedDot()
			}
			this.Bind(local_FriendEvent.FRIEND_REDDOT_UPDATE, changeFriendRedDot)
			this.Bind(local_FriendEvent.APPLY_DATA_UPDATE, changeFriendRedDot)
			this.Bind(local_FriendEvent.OPEN_CHAT_VIEW, changeFriendRedDot)
			//未曾引入
			chat_model.Bind(local_ChatModelEvent.CHAT_MSG_UPDATE, changeFriendRedDot)
			chat_model.Bind(local_ChatModelEvent.CHAT_MSG_NUM_UPDATE, changeFriendRedDot)
			_binFriendRedDot = true
		}

		this.updateFriendOline = (data?) => {
			let dataList = this.getFriendData(data.rela_type)
			for (let key in dataList) {

				if (dataList[key]) {
					// [ts2lua]dataList下标访问可能不正确
					let vo = dataList[key]
					if (vo.role_id == data.role_id) {
						vo.online_flag = data.online_flag
						if (vo.online_flag == 0) {
							vo.offline_time = TimeUtil.getServerTime() - data.timestamp
						}
						break
					}
				}
			}
			// [ts2lua]friendDic下标访问可能不正确
			friendDic[data.rela_type] = dataList
			this.Fire(local_FriendEvent.FRIEND_OLINE_UPDATE, data)
		}

		this.setEmailData = (data?) => {
			this._emailList = data.mail_list
			this.Fire(local_FriendEvent.EMAIL_DATA_UPDATE)
		}

		this.sortEmail = (a?, b?) => {
			let aIndex = 500
			let bIndex = 500
			if (a.state == 2) {
				aIndex = aIndex + 100
			}
			if (b.state == 2) {
				bIndex = 100 + bIndex
			}
			if (a.time != b.time) {
				if (a.time > b.time) {
					aIndex = 100 + aIndex
				} else {
					bIndex = 100 + bIndex
				}
			}
			if (a.state == 1 && a.time > b.time) {
				aIndex = aIndex - 100
			}
			if (b.state == 1 && b.time > a.time) {
				bIndex = bIndex - 100
			}
			if (a.state == 1 && a.is_attach == 1) {
				aIndex = 50 + aIndex
			}
			if (b.state == 1 && b.is_attach == 1) {
				bIndex = 50 + bIndex
			}
			if (a.state == 3) {
				aIndex = aIndex - 100
			}
			if (b.state == 3) {
				bIndex = bIndex - 100
			}
			return bIndex < aIndex
		}

		this.getEmailById = (id?) => {
			for (let key in this._emailList) {

				if (this._emailList[key]) {
					// [ts2lua]this._emailList下标访问可能不正确
					let vo = this._emailList[key]
					if (vo.mail_id == id) {
						return vo
					}
				}
			}
		}

		this.setEmailInfo = (data?) => {
			// [ts2lua]emailInfoDic下标访问可能不正确
			emailInfoDic[data.mail_id] = data
			let vo = this.getEmailById(data.mail_id)
			if (vo.state != 3) {
				vo.state = 1
			}
			this.Fire(local_FriendEvent.OPEN_EMAIL_VIEW, data.mail_id)
		}

		this.getEmailInfo = (id?) => {
			// [ts2lua]emailInfoDic下标访问可能不正确
			return emailInfoDic[id]
		}

		this.deletEmail = (id?) => {
			let vo = null

			for (let i = this._emailList.length-1; i >= 0; i -= 1) {
				vo = this._emailList[i]
				if (vo.mail_id == id) {
					table.remove(this._emailList, i)
					break
				}
			}
			// [ts2lua]emailInfoDic下标访问可能不正确
			emailInfoDic[id] = null
		}

		this.addEmail = (addlist?) => {
			for (let i = 0; i < addlist.length; i++) {
				table.insert(this._emailList, addlist[i])
			}
			//this._emailList = table.merge(this._emailList, addlist)
			this.Fire(local_FriendEvent.EMAIL_DATA_UPDATE)
			MainUIModel.GetInstance().Fire(MainUIModel.REFRESH_FRIEND_AND_MAIL_RED, red_index.friend, this.GetRed())
			MainUIModel.GetInstance().friend_red=MainUIModel.GetInstance().friend_red || this.GetRed()
			//local_GlobalEventSystem:Fire(local_EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Friend)
		}

		this.getEmailReward = (getList?) => {
			let vo = null
			for (let key in getList) {

				// [ts2lua]getList下标访问可能不正确
				let data = getList[key]
				let i = 0
				do {
					vo = this._emailList[i]
					if (vo.mail_id == data.mail_id) {
						vo.state = 3
						break
					}
					i = i + 1
				} while ((i < this._emailList.length))
				if (emailInfoDic[data.mail_id]) {
					// [ts2lua]emailInfoDic下标访问可能不正确
					let v = emailInfoDic[data.mail_id]
					v.is_receive = 1
				}
			}
			this.Fire(local_FriendEvent.EMAIL_DATA_UPDATE)
			this.Fire(local_FriendEvent.EMAIL_REWARD_UPDATE)
		}

		this.binEmailRedDot = () => {
			if (_binEmailRedDot) {
				return
			}
			let changeEmailRedDot = () => {
				local_GlobalEventSystem.Fire(local_EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "FriendEnterView", 1, FriendModel.GetInstance().GetemailRedDot())

				MainUIModel.GetInstance().Fire(MainUIModel.REFRESH_FRIEND_AND_MAIL_RED, red_index.friend, this.GetRed())
				MainUIModel.GetInstance().friend_red=MainUIModel.GetInstance().friend_red || this.GetRed()
				//local_GlobalEventSystem:Fire(local_EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Friend)
			}

			this.Bind(local_FriendEvent.EMAIL_DATA_UPDATE, changeEmailRedDot)
			this.Bind(local_FriendEvent.EMAIL_REWARD_UPDATE, changeEmailRedDot)
			this.Bind(local_FriendEvent.EMAIL_ICON_UPDATE, changeEmailRedDot)
			if (FriendModel.GetInstance().GetemailRedDot()) {
				changeEmailRedDot()
			}
			_binEmailRedDot = true
		}

		this.formatEmailContent = (content?) => {
			content = content.replace("%[", "【") //强制把英文括号变成中文，避免下面替换时的转义出问题
			content = content.replace("%]", "】")
			content = content.replace("%(", "（") //强制把英文括号变成中文，避免下面替换时的转义出问题
			content = content.replace("%)", "）")
			let colorIndexList = []
			for (let word in content.match("<color@%d+>.-<%/color>")) {
				table.insert(colorIndexList, word)
			}

			for (let key in colorIndexList) {

				let colorStr = colorIndexList[key]
				let colorIndex = colorStr.find("<color@(%d+)>")
				let goodName = colorStr.find("<color@%d+>(.+)<%/color>")
				let color = ColorUtil.GetColorLight(Number(colorIndex))
				content = content.replace(colorStr, "<font color=" + color + ">" + goodName + "</font>")
			}
			return content
		}

		this.emailReward = (data?, is_receive?) => {
			let list = []
			let goods_vo = null
			let num = 0
			let length=0
			for (let key in data) {

				if (data[key]) {
					// [ts2lua]data下标访问可能不正确
					let vo = data[key]
					let [type_id, lock] = goods_model.GetMappingTypeId(vo.object_type, vo.type_id)
					goods_vo = goods_model.GetGoodsBasicByTypeId(type_id)
					// [ts2lua]lua中0和空字符串也是true，此处(goods_vo && goods_vo.max_overlap == 0) && goods_vo.type == 10需要确认
					length = ((goods_vo && goods_vo.max_overlap == 0) && goods_vo.type == 10 && (vo.num) || (1))
					if (goods_vo && goods_vo.type == 10) {
						num = num + length
					}
					let j = 0
					do {
						// [ts2lua]vo下标访问可能不正确
						vo["is_receive"] = is_receive
						table.insert(list, vo)
						j = j + 1
					} while ((j < length))
				}
			}
			return [list, num ]
		}

		this.showGetReward = (reward?) => {
			let reward_list = []
			for (let key in reward) {

				if (reward[key]) {
					// [ts2lua]reward下标访问可能不正确
					let info = reward[key]
					table.insert(reward_list, { "0": info.style, "1": info.typeId, "2": info.count })
				}
			}
			success_view = new CongratulationObtainView(reward_list, 10)
			success_view.Open()
		}

		this.requestPlayerMessage = (roleid?, requestNow?, ser_id?, show_view?) => {
			if (requestNow == null) {
				requestNow = false
			}
			if (show_view == null) {
				show_view = true
			}
			if (roleid == 0 || !roleid) {
				return
			}
			let data = this.playerMessage(roleid)
			let request = true
			this.SetplayerId(roleid)
			if (data && !requestNow) {
				let time = local_TimeUtil.getServerTime()
				if (time - data.time < 5) {
					request = false
				}
			}
			if (request) {
				this.player_dic[roleid] = show_view
				let server_id = role_mgr.GetMainRoleVo().server_unique_id
				if (ser_id && server_id != ser_id) {
					this.Fire(local_FriendEvent.REQUEST_KUAFU_PLAYER_MESSAGE, ser_id, roleid)
					return
				}
				this.Fire(local_FriendEvent.REQUEST_PLAYER_MESSAGE, roleid)
			} else {
				if (show_view) {
					local_GlobalEventSystem.Fire(local_EventName.OPEN_PLAYER_MESSAGE_VIEW, data)
				}
			}
			//setTimeout(() => {

			//}
			//, 400)
		}

		this.setPlayerMessage = (data?) => {
			data["time"] = local_TimeUtil.getServerTime()
			_playerMessage[data.role_id] = data
			if (this.player_dic[data.role_id]) {
				local_GlobalEventSystem.Fire(local_EventName.OPEN_PLAYER_MESSAGE_VIEW, data)
				this.player_dic[data.role_id] = null
			} else {
				//local_GlobalEventSystem:Fire(local_EventName.UPDATE_PALYER_INFO, data)
			}
		}

		this.playerMessage = (role_id?) => {
			// [ts2lua]_playerMessage下标访问可能不正确
			return _playerMessage[role_id]
		}

		this.equipRequestTime = (goods_id?, role_id?, time?) => {
			// [ts2lua]_equipRequestTime下标访问可能不正确
			_equipRequestTime[goods_id + "_" + role_id] = time
		}

		this.getEquipRequestTime = (goods_id?, role_id?) => {
			// [ts2lua]_equipRequestTime下标访问可能不正确
			return _equipRequestTime[goods_id + "_" + role_id]
		}

		this.cleanEquipRequestTime = () => {
			_equipRequestTime = []
		}

		this.processEquipListData = (list?) => {
			let obj = []
			for (let _tmpi in list) {
				var equip = list[_tmpi]
				// [ts2lua]obj下标访问可能不正确
				obj[equip.cell] = equip
			}
			return obj
		}

		this.updateIntimacy = (data?) => {
			if (data && data.role_id) {
				let roleInfo = this.getFriendById(data.role_id)
				if (roleInfo) {
					roleInfo.intimacy = data.intimacy
				}
				this.Fire(local_FriendEvent.INTIMACY_UPDATE, data)
			}
		}

		this.emailHasNoGetReward = () => {
			for (let key in this._emailList) {

				if (this._emailList[key]) {
					// [ts2lua]this._emailList下标访问可能不正确
					let vo = this._emailList[key]
					if (vo.is_attach == 1 && vo.state != 3) {
						return false
					}
				}
			}
			return true
		}
		this.GetNoGetRewardEmailList = () => {
			let list = []
			for (let key in this._emailList) {

				if (this._emailList[key]) {
					// [ts2lua]this._emailList下标访问可能不正确
					let vo = this._emailList[key]
					if (vo.is_attach == 0 || (vo.is_attach == 1 && vo.state == 3)) {
						table.insert(list, vo)
					}
				}
			}
			return list
		}

		this.allRewardEmailList = () => {
			let idlist = []
			for (let key in this._emailList) {

				if (this._emailList[key]) {
					// [ts2lua]this._emailList下标访问可能不正确
					let info = this._emailList[key]
					if (info.is_attach == 1 && info.state != 3) {
						table.insert(idlist, info)
					}
				}
			}
			return idlist
		}

		this.dummyPlayerList = () => {
			let list = []
			let num = 2 + Math.floor(3 * Math.random() + 0.5)
			let i = 0
			do {
				let vo = this.dummyPlayer()
				if (vo ) {
					table.insert(list, vo)
				}
				i = i + 1
			} while ((i < num))
			return list
		}

		this.dummyPlayer = () => {
			let vo
			let roleVo = role_mgr.GetMainRoleVo()
			// [ts2lua]this.config下标访问可能不正确
			// [ts2lua]this.config[local_FRIEND_CONFIG.CONFIGRANDOMNAME]下标访问可能不正确
			let surname = this.config[local_FRIEND_CONFIG.CONFIGRANDOMNAME]["surname"]
			let name = null
			let career = 1 + Math.floor(1 * Math.random() + 0.5)
			if (career == 1) {
				// [ts2lua]this.config下标访问可能不正确
				// [ts2lua]this.config[local_FRIEND_CONFIG.CONFIGRANDOMNAME]下标访问可能不正确
				name = this.config[local_FRIEND_CONFIG.CONFIGRANDOMNAME]["forename_man"]
			} else {	
				// [ts2lua]this.config下标访问可能不正确
				// [ts2lua]this.config[local_FRIEND_CONFIG.CONFIGRANDOMNAME]下标访问可能不正确
				name = this.config[local_FRIEND_CONFIG.CONFIGRANDOMNAME]["forename_woman"]
			}
			let role_id = Math.ceil(Math.random() * 1000000)
			let is_faker = true
			// [ts2lua]surname下标访问可能不正确
			// [ts2lua]name下标访问可能不正确
			//let random = Math.random(surname.length)
			let role_name = surname[Math.ceil(Math.random()*surname.length-1)] + name[Math.ceil(Math.random()*name.length-1)]
			let turn = Math.floor(roleVo.turn * Math.random() + 0.5)
			// [ts2lua]({1, -1})下标访问可能不正确
			let a = [1, -1]
			let lv = roleVo.level + Math.floor(10 * Math.random() + 0.5) * a[Math.floor(Math.random() * 1) + 1]
			let vip = Math.floor(12 * Math.random() + 0.5)
			let online_flag = 1
			// [ts2lua]({1, -1})下标访问可能不正确
			let combat_power = roleVo.fighting + Math.floor(3000 * Math.random() + 0.5) * a[Math.ceil(Math.random() -0.5)]
			vo = { career: career, role_id: role_id, is_faker: is_faker, role_name: role_name, turn: turn, lv: lv, vip: vip, online_flag: online_flag, combat_power: combat_power }
			return vo
		}

		this.SetIllusionInfo = (scmd) => {
			this.other_player_illusion_info = scmd
		}

		this.initEvent()
	}

	public static GetInstance() {

		if (!FriendModel.Instance) {
			FriendModel.Instance = new FriendModel()
		}
		return FriendModel.Instance
	}

	public GetrecommendList() {

		if (this._recommendList.length == 0 && !this.checkPlayer) {
			return this.dummyPlayerList()
		}
		return this._recommendList
	}

	public GetapplyList() {

		return this._applyList
	}

	public SethaveNewApply(value?) {

		if (this._haveNewApply != value) {
			this._haveNewApply = value
			this.Fire(FriendEvent.NEWAPPLY_CHANGE)
		}
	}

	public GethaveNewApply() {

		return this._haveNewApply
	}
	public GetRed() {

		let a = this.GetfriendRedDot()
		let b = this.GetemailRedDot()
		let red = (this.GetfriendRedDot() || this.GetemailRedDot()) && true || false
		return red
	}

	public GetfriendRedDot() {

		if (this.GethaveNewApply()) {
			return true
		}
		//未曾引入
		let list = this.getFriendData(FRIEND_TYPE.FRIEND)
		let num = 0
		for (let key in list) {

			// [ts2lua]list下标访问可能不正确
			let vo = list[key]
			let obj = ChatModel.GetInstance().getChannelChat(CHAT_TYPE.PRIVATE_CHAT)
			let sendId = vo.role_id
			// [ts2lua]obj下标访问可能不正确
			if (obj[sendId] && sendId != this.openChatId ) {
				// [ts2lua]obj下标访问可能不正确
				num = obj[sendId][1]
			}
			if (num > 0 ) {
				return true
			}
		}
		return false
	}

	public GetemailList() {

		table.sort(this._emailList, (a?, b?) => {
				return this.sortEmail(a, b)
			}
		)
		return this._emailList
	}

	public GetemailRedDot() {

		if (this._emailList && this._emailList.length == 0) {
			return false
		}
		for (let key in this._emailList) {

			// [ts2lua]this._emailList下标访问可能不正确
			let email = this._emailList[key]
			if (email.state == 2 || email.is_attach == 1 && email.state != 3) {
				this.is_unread_mail=true
				return true
			}
		}
		this.is_unread_mail=false
		return false
	}

	public nextMailId(){
		let _id: number = -1;
		let _list = this.GetemailList();
		if(_list && _list.length){
			for (let i = 0, len = _list.length; i < len; i++) {
				let _item = _list[i];
				if((_item.is_attach == 1 && _item.state != 3) || (_item.is_attach == 0 && _item.state == 2)){
					_id = _item.mail_id
				}
			}
		}
		return _id
	}

	public GetplayerId() {

		return this._playerId
	}

	public SetplayerId(value?) {

		this._playerId = value
	}

}
window["FriendModel"] = FriendModel
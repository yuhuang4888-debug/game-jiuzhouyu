
//require("game.friend.CustomerServiceView")
//require("game.friend.EmailItem")
//require("game.friend.EmailPopView")
//require("game.friend.EmailView")
//require("game.friend.FightCompareItem")
//require("game.friend.FriendAddPopItem")
//require("game.friend.FriendAddPopView")
//require("game.friend.FriendApllyPopItem")
//require("game.friend.FriendApllyPopView")
//require("game.friend.FriendBlackListItm")
//require("game.friend.FriendBlackListPopView")
//require("game.friend.FriendChatItem")
//require("game.friend.FriendMineChatItem")
//require("game.friend.FriendChatView")
//require("game.friend.FriendEnterView")
//require("game.friend.FriendFacePanel")
//require("game.friend.FriendListItem")
//require("game.common.PlayerMenuView")
//require("game.friend.FriendMenuView")
//require("game.friend.FriendModel")
//require("game.friend.FriendView")
//require("game.friend.PlayerMessageView")
//require("game.friend.PlayerMsgTabBtn")
//require("game.friend.FightComTabItem")
//require("game.friend.FightComSubItem")
//require("game.friend.EmailPopViewItem")
//require("game.friend.MenuRedButtonSkin")
//require("game.friend.FriendViewButtonSkin")
//require("game.equip.PlayerMessageEquipItem")
//require("game.friend.WXCustomerServiceView")
//require("game.friend.FriendChatTabItem")
//require("game.mainUI.PlayerHead")
//require("game.chat.ChatBagPanel")
//require("game.proto.140.Require140")
//require("game.proto.190.Require190")

import { BaseController } from "../common/BaseController"
import { EventName } from "../common/EventName"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { ChatModel } from "../commonModel/ChatModel"
//import { ChatModel } from "../commonModel/ChatModel"
import { FriendEvent, FriendModel, FRIEND_CONFIG, FRIEND_TYPE } from "../commonModel/FriendModel"
import { GuildModel, GuildEvent } from "../commonModel/GuildModel"
import  "../friend/EmailPopView"
import  "../friend/FriendAddPopView"
import "../friend/FriendApllyPopView"
import "../friend/FriendApllyPopView"
import "../friend/FriendBlackListPopView"
import  "../friend/FriendChatView"
import  "../friend/FriendEnterView"
import  "../friend/FriendFacePanel"
import   "../friend/FriendMenuView"
import   "../playerMessage/PlayerMessageView"
import { RoleManager } from "../commonModel/RoleManager"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { TimeUtil } from "../util/TimeUtil"
import { Util } from "../util/Util"
import { SceneModelScale } from "../scene/SceneConfig"
import "../playerMessage/HolySealOtherAttrView"
import "../playerMessage/PlayerMessageDragonBallAttrView"
import "../playerMessage/PlayerMessageRevelationSkillView"
import "../playerMessage/PlayerMessageRevelationAttrView"
import '../playerMessage/PlayerMessageLongLanguageAttrView'
import "../playerMessage/PlayerMessageRunePropertyView"
import "../playerMessage/PlayerMessageGodbeast"
import { table } from "../common/table"


//require("game.proto.150.Require150")
export class FriendController extends BaseController {
InitInfo

public constructor(){
	super() 

	let _model = FriendModel.GetInstance()
	let local_GlobalEventSystem = GlobalEventSystem
	let local_EventName = EventName
	let local_FriendEvent = FriendEvent
	
	let local_TimeUtil = TimeUtil
	let local_Util = Util
	let user_msg_adapter = UserMsgAdapter.GetInstance()
	let local_Message = Message
	let player_message_view = null
	let friend_view = null
	let black_view = null
	let add_view = null
	let apply_view = null
	let chat_view = null
	let face_panel = null
	let email_view = null
	let menu_view = null
	let player_menu_view = null
	let user_mgr=UserMsgAdapter.GetInstance()
	this.InitInfo = () => {
		let game_star = () => {
			_model.ResConfig()
		}
		
		local_GlobalEventSystem.Bind(EventName.INIT_CONFIG, game_star)
		local_GlobalEventSystem.Bind(EventName.GAME_START,() => {
				_model.ResConfig()
				this.SendFmtToGame(19008)
				this.SendFmtToGame(19001)
				this.SendFmtToGame(14006)
				_model.Fire(local_FriendEvent.REQUEST_FRIEND_DATA, FRIEND_TYPE.FRIEND)
				_model.binRedDot()
			}
		)
		let open_player_message_view = (data?) => {
			
			if (! player_message_view ) {
				let player_message_view_class = window["PlayerMessageView"]
				player_message_view=new player_message_view_class()

			}
			player_message_view.setData(data)
			player_message_view.Open()
		}
		local_GlobalEventSystem.Bind(local_EventName.OPEN_PLAYER_MESSAGE_VIEW, open_player_message_view)
		
		let open_friend_view = (e?) => {
			
			if (! friend_view ) {
				let friend_view_class = window["FriendEnterView"]
				friend_view=new friend_view_class()
			}
			// friend_view.SetDefaultIndex(e.index)
			friend_view.Open(e)
		}
		
		local_GlobalEventSystem.Bind(local_EventName.OPEN_FRIEND_VIEW, open_friend_view)
		
		let open_apply_view = () => {
			if (! apply_view ) {
				let apply_view_class = window["FriendApllyPopView"]
				apply_view=new apply_view_class()

			}
			_model.Fire(local_FriendEvent.REQUEST_APPLY_DATA)
			apply_view.Open()
		}
		
		_model.Bind(local_FriendEvent.OPEN_APPLY_VIEW, open_apply_view)
		let open_chat_view = (...new_args) => {
			// [ts2lua]window下标访问可能不正确
			let args = new_args
			if(!args[0]) return
			if (! chat_view ) {
				// [ts2lua]window下标访问可能不正确
				let chat_view_class = window["FriendChatView"]
				chat_view=new chat_view_class()

			}
			ChatModel.GetInstance().reSetPrivateNum(args[0].role_id)//未曾引入模块
			chat_view.setData(args[0])
			chat_view.Open()
		}
		
		_model.Bind(local_FriendEvent.OPEN_CHAT_VIEW, open_chat_view)
		let open_face_panel = (e?) => {
			// [ts2lua]window下标访问可能不正确
			
			if (! face_panel ) {
				// [ts2lua]window下标访问可能不正确
				let face_panel_class = window["FriendFacePanel"]
				face_panel=new face_panel_class()

			}
			face_panel.localPoint = e
			face_panel.Open()
		}
		
		_model.Bind(local_FriendEvent.OPEN_FACE_PANEL, open_face_panel)
		let open_friend_menu = (x?,y?,vo?) => {
			if (! menu_view ) {
				let menu_view_class = window["FriendMenuView"]
				menu_view=new menu_view_class()
			}
			
			if (menu_view ) { 
				if (menu_view.HasOpen()) { 
					menu_view.Close()
				}else{
					menu_view.setData(x,y,vo)
					menu_view.Open()
				}
			}
		}
		_model.Bind(local_FriendEvent.OPEN_FRIEND_MENU, open_friend_menu)

		let open_player_menu = (tab_list?, x?,y?,vo?) => {
			if (! player_menu_view ) {
				let player_menu_view_class = window["PlayerMenuView"]
				player_menu_view=new player_menu_view_class()
			}
			
			if (player_menu_view ) { 
				if (player_menu_view.HasOpen() ) { 
					player_menu_view.Close()
				}else{
					player_menu_view.setData(x,y,vo)
					player_menu_view.Open(tab_list, x,y,vo)
				}
			}
		}
		_model.Bind(local_FriendEvent.OPEN_PLAYER_MENU, open_player_menu)

		let open_email_view = (e?) => {
			if (! email_view ) {
				// [ts2lua]window下标访问可能不正确
				let	email_view_class= window["EmailPopView"]
				email_view=new email_view_class()
			}
			email_view.emailId = e
			email_view.Open()
		}
		
		_model.Bind(local_FriendEvent.OPEN_EMAIL_VIEW, open_email_view)
		let request_friend_data = (...new_args) => {
			let args = new_args
			this.SendFmtToGame(14000, "c", args[0])
		}

		_model.Bind(local_FriendEvent.REQUEST_FRIEND_DATA, request_friend_data)
		let request_recommend_data = (...new_args) => {
			let args = new_args
			_model.checkPlayer = false
			this.SendFmtToGame(14001, "c", args[0])
		}
		
		_model.Bind(local_FriendEvent.REQUEST_RECOMMEND_DATA, request_recommend_data)
		let check_player = (...new_args) => {
			let args = new_args
			this.SendFmtToGame(14002, "s", args[0])
		}
		
		_model.Bind(local_FriendEvent.CHECK_PLAYER, check_player)
		let request_add_friend = (...new_args) => {
			let args = new_args
			_model.addRecommendId = args[0]
			this.SendFmtToGame(14003, "l", args[0])
		}
		
		_model.Bind(local_FriendEvent.ADD_FRIEND, request_add_friend)
		let oneClick_apply = (...new_args) => {
			let args = new_args
			_model.applyType = args[0]
			this.SendFmtToGame(14004, "c", args[0])
		}
		
		_model.Bind(local_FriendEvent.ONECLICK_APPLY, oneClick_apply)
		let one_apply = (...new_args) => {
			let args = new_args
			_model.oneApplyId = args[0]
			_model.applyType = args[1]
			this.SendFmtToGame(14005, "lc", args[0], args[1])
		}
		
		_model.Bind(local_FriendEvent.ONE_APPLY, one_apply)
		let request_apply_list = () => {
			this.SendFmtToGame(14006)
		}
		
		_model.Bind(local_FriendEvent.REQUEST_APPLY_DATA, request_apply_list)
		let friends_operationt = (...new_args) => {
			let args = new_args
			_model.friendOperationt = args[0]
			this.SendFmtToGame(14007, "cl", args[0], args[1])
		}
		
		_model.Bind(local_FriendEvent.FRIENDS_OPERATIONT, friends_operationt)
		let request_menu_data = (...new_args) => {
			let args = new_args
			let role_id = args[0]
			if (role_id == 0 || role_id == RoleManager.GetInstance().GetMainRoleId() ) {
				return
			}
			let x = args[1]
			let y = args[2]
			let index = args[3]
			let data = _model.getMenuData(role_id)
			if (data && data.requestTime && local_TimeUtil.getServerTimeMs() - data.requestTime < 800 ) {
				data.point = {x :x ,y :y}
				data.index = index
				_model.Fire(local_FriendEvent.MENU_DATA_UPDTE, role_id, index)
			}else{
				data = []
				data["point"] = {x :x ,y :y}
				data["requestTime"] = local_TimeUtil.getServerTimeMs()
				data["index"] = index
				_model.setMenuData(role_id, data, true)
				this.SendFmtToGame(14010, "l", args[0])
			}
		}
		
		_model.Bind(local_FriendEvent.REQUEST_MENU_DATA, request_menu_data)
		let request_email_data = () => {
			this.SendFmtToGame(19001)
		}
		
		_model.Bind(local_FriendEvent.REQUEST_EMAIL_DATA, request_email_data)
		let request_email_info = (...new_args) => {
			let args = new_args
			let id = args[0]
			let vo = _model.getEmailInfo(id)
			if (! vo ) {
				this.SendFmtToGame(19002, "l", args[0])
			}else{
				_model.Fire(local_FriendEvent.OPEN_EMAIL_VIEW, id)
			}
		}
		
		_model.Bind(local_FriendEvent.REQUEST_EMAIL_INFO, request_email_info)
		let delet_email = (emailArr?) => {
			this.WriteBegin(19003)
			this.WriteFMT("h", Util.TableSize(emailArr))
			for (let index in emailArr) {
				
				// [ts2lua]emailArr下标访问可能不正确
				this.WriteFMT("l", emailArr[index].mail_id)
			}
			this.SendToGame()
		}
		
		_model.Bind(local_FriendEvent.REQUEST_DELET_EMAIL, delet_email)
		let get_email_reward = (emailArr?) => {
			this.WriteBegin(19005)
			this.WriteFMT("h", Util.TableSize(emailArr))
			for (let index in emailArr) {
				
				// [ts2lua]emailArr下标访问可能不正确
				this.WriteFMT("l", emailArr[index].mail_id)
			}
			this.SendToGame()
		}
		
		_model.Bind(local_FriendEvent.REQUEST_EMAIL_REWARD, get_email_reward)
		let send_guild_email = (...new_args) => {
			let args = new_args
			this.SendFmtToGame(19006, "ss", args[0], args[1])
		}
		
		_model.Bind(local_FriendEvent.SEND_GUILD_MAIL, send_guild_email)
		let customerService = (args?) => {
			this.SendFmtToGame(19010, "s", args)
		}
		
		_model.Bind(local_FriendEvent.CUSTOMER_SERVICE, customerService)
		let request_player_message = (playerId?) => {
			this.SendFmtToGame(15011, "l", playerId)
		}
		
		_model.Bind(local_FriendEvent.REQUEST_PLAYER_MESSAGE, request_player_message)
		_model.Bind(local_FriendEvent.REQUEST_KUAFU_PLAYER_MESSAGE,(server_id?, playerId?) => {
				this.SendFmtToGame(15012, "hl", server_id, playerId)
			}
		)
		_model.Bind(local_FriendEvent.REQUEST_KUAFU_GOODS_MESSAGE,(server_id?, playerId?, goods_id?) => {
				this.SendFmtToGame(15013, "hll", server_id, playerId, goods_id)
			}
		)
		
		let open_black_view = () => {
			if (! black_view ) {
				// [ts2lua]window下标访问可能不正确
				black_view =new window['FriendBlackListPopView']()
			}
			_model.Fire(local_FriendEvent.REQUEST_FRIEND_DATA, FRIEND_TYPE.BLACKLIST)
			black_view.Open()
		}
		
		_model.Bind(local_FriendEvent.OPEN_BLACK_VIEW, open_black_view)
		let open_add_view = () => {
			if (! add_view ) {
				// [ts2lua]window下标访问可能不正确
				add_view =new  window["FriendAddPopView"]()
			}
			_model.Fire(local_FriendEvent.REQUEST_RECOMMEND_DATA, 0)
			add_view.Open()
		}
		_model.Bind(local_FriendEvent.OPEN_ADD_VIEW, open_add_view)
		let On14000 = () => {
			let scmd =  user_mgr.GetSCMD(14000)
			_model.setFriendData(scmd)
		}
		
		this.RegisterProtocal(14000, On14000)
		let On14001 = () => {
			let scmd =  user_mgr.GetSCMD(14001)
			if (scmd.code == 1 ) {
				_model.setRecommendData(scmd)
			}else{
				Util.ErrorCodeShow(scmd.code)
			}
		}
		
		this.RegisterProtocal(14001, On14001)
		let On14002 = () => {
			let scmd =  user_mgr.GetSCMD(14002)
			_model.checkPlayer = true
			if (scmd.code == 1 ) {
				_model.setCheckPlayerData(scmd)
			}else{
				_model.cleanRecommendList()
				Util.ErrorCodeShow(scmd.code)
			}
		}
		
		this.RegisterProtocal(14002, On14002)
		let On14003 = () => {
			let scmd =  user_mgr.GetSCMD(14003)
			if (scmd.code == 1 ) {
				local_Message.show("申请成功")
				_model.changeRecommendState()
			}else{
				Util.ErrorCodeShow(scmd.code)
			}
		}
		
		this.RegisterProtocal(14003, On14003)
		let On14004 = () => {
			let scmd =  user_mgr.GetSCMD(14004)
			_model.reSetApplyList()
			Util.ErrorCodeShow(scmd.code)
		}
		
		this.RegisterProtocal(14004, On14004)
		let On14005 = () => {
			let scmd =  user_mgr.GetSCMD(14005)
			_model.delApplyer()
			Util.ErrorCodeShow(scmd.code)
		}
		
		this.RegisterProtocal(14005, On14005)
		let On14006 = () => {
			let scmd =  user_mgr.GetSCMD(14006)
			_model.setApplyList(scmd)
		}
		
		this.RegisterProtocal(14006, On14006)
		let On14007 = () => {
			let scmd =  user_mgr.GetSCMD(14007)
			_model.flushOperationtView()
			if(scmd.code == 1){
				if(scmd.type == 2){
					Message.show("已拉入黑名单")
				}else if(scmd.type == 3){
					Message.show("已移出黑名单")
				}else if(scmd.type == 1){
					Message.show("已删除好友")
				}else{
					Util.ErrorCodeShow(scmd.code)
				}
			}else{
				Util.ErrorCodeShow(scmd.code)
			}
		}
		
		this.RegisterProtocal(14007, On14007)
		let On14008 = () => {
			let scmd =  user_mgr.GetSCMD(14008)
			_model.addFriendToList(scmd)
		}
		
		this.RegisterProtocal(14008, On14008)
		let On14009 = () => {
			let scmd =  user_mgr.GetSCMD(14009)
			_model.updateFriendOline(scmd)
		}
		
		this.RegisterProtocal(14009, On14009)
		let On14010 = () => {
			let scmd =  user_mgr.GetSCMD(14010)
			if (scmd.code == 1 ) {
				_model.setMenuData(scmd.role_id, scmd, false, true)
				_model.Fire(local_FriendEvent.MENU_DATA_UPDTE)
			}else{
				Util.ErrorCodeShow(scmd.code)
			}
		}
		
		this.RegisterProtocal(14010, On14010)
		let On14013 = () => {
			let scmd =  user_mgr.GetSCMD(14013)
			_model.changeFriendList(scmd)
		}
		
		this.RegisterProtocal(14013, On14013)
		let On14014 = () => {
			let scmd =  user_mgr.GetSCMD(14014)
			_model.delFriendList(scmd)
		}
		
		this.RegisterProtocal(14014, On14014)
		let On14015 = () => {
			let scmd =  user_mgr.GetSCMD(14015)
			_model.updateIntimacy(scmd)
		}
		
		this.RegisterProtocal(14015, On14015)

		let On14099 = () => {
			let scmd =  user_mgr.GetSCMD(14099)
			if (scmd.code ) {
				Util.ErrorCodeShow(scmd.code)
			}
		}
		this.RegisterProtocal(14099, On14099)

		let On19001 = () => {
			let scmd =  user_mgr.GetSCMD(19001)
			_model.setEmailData(scmd)
		}
		
		this.RegisterProtocal(19001, On19001)
		let On19002 = () => {
			let scmd =  user_mgr.GetSCMD(19002)
			_model.setEmailInfo(scmd)
			_model.Fire(local_FriendEvent.EMAIL_DATA_UPDATE)
		}
		
		this.RegisterProtocal(19002, On19002)
		let On19003 = () => {
			let scmd =  user_mgr.GetSCMD(19003)
			if (scmd.error_code == 1 ) {
				for (let key in scmd.mail_ids) {
					
					if (scmd.mail_ids[key] ) {
						// [ts2lua]scmd.mail_ids下标访问可能不正确
						let vo = scmd.mail_ids[key]
						_model.deletEmail(vo.mail_id)
					}
				}
				_model.Fire(local_FriendEvent.EMAIL_DATA_UPDATE)
				local_Message.show("删除成功")
			}else{
				Util.ErrorCodeShow(scmd.error_code)
			}
		}
		
		this.RegisterProtocal(19003, On19003)
		let On19004 = () => {
			let scmd =  user_mgr.GetSCMD(19004)
			_model.addEmail(scmd.mail_list)
		}
		
		this.RegisterProtocal(19004, On19004)
		let On19005 = () => {
			let scmd =  user_mgr.GetSCMD(19005)
			if (scmd.reward && scmd.reward.length > 0 ) {
				_model.getEmailReward(scmd.mail_ids)
				_model.showGetReward(scmd.reward)
			}else{
				Util.ErrorCodeShow(scmd.error_code)
			}
		}
		
		this.RegisterProtocal(19005, On19005)
		let On19006 = () => {
			let scmd =  user_mgr.GetSCMD(19006)
			if (scmd.error_code == 1 ) {
				local_Message.show("发送邮件成功")
				GuildModel.GetInstance().Fire(GuildEvent.CLOSE_VIEW, "GuildMailView")
			}else{
				Util.ErrorCodeShow(scmd.error_code)
			}
		}
		
		this.RegisterProtocal(19006, On19006)
		let On19007 = () => {
			
		}
		
		this.RegisterProtocal(19007, On19007)
		let On19008 = () => {
			let scmd =  user_mgr.GetSCMD(19008)
			_model.is_unread_mail = scmd.is_unread_mail == 1
			if (! friend_view || friend_view && ! friend_view.HasOpen() ) {
				_model.Fire(local_FriendEvent.EMAIL_ICON_UPDATE)
			}
			//local_GlobalEventSystem:Fire(local_EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Friend)
		}
		
		this.RegisterProtocal(19008, On19008)
		let On19009 = () => {
			let scmd =  user_mgr.GetSCMD(19009)
		}
		
		this.RegisterProtocal(19009, On19009)
		let On19010 = () => {
			let scmd =  user_mgr.GetSCMD(19010)
			if (scmd.error_code == 1 ) {
				Util.ErrorCodeShow(scmd.error_code)
				_model.Fire(local_FriendEvent.SUBMIT_SUCCESS)
			}else{
				Util.ErrorCodeShow(scmd.error_code)
			}
		}
		
		this.RegisterProtocal(19010, On19010)
		let On15011 = () => {
			let scmd =  user_mgr.GetSCMD(15011)
			_model.setPlayerMessage(scmd)
		}
		
		this.RegisterProtocal(15011, On15011)

		
		let On15014 = () => {
			let scmd =  user_mgr.GetSCMD(15014)
			// 战力列表内容
			// % EquipPower(装备)、EquipSuitPower(套装)、StonPower(宝石)
			// % RunePower(符文、图鉴、幻灵)、PlayerPower(人物)、FashionPower(时装)
			// % ArbitramentPower(圣裁)、FigurePow(坐骑、精灵、翅膀、圣器、神兵)、CompanionPower(契灵)
			// % SealPower(圣印)、RingPower(戒指)、BabyPower(宝宝)
			// % GodPower(降神)、DemonsPower(使魔)
			let cfg = _model.config[FRIEND_CONFIG.CLIENTFIGHTCOM]
			let num = 0
			let valueStr = ["value2", "value1"]
			let reSetList = []
			let list = scmd.power_list
			let total = 0
			if (cfg ) {
				let i = 0
				do {
					if (i == 1 ) {
						list = scmd.self_power_list
					}
					for (let _tmpi in cfg) {
						var vo = cfg[_tmpi]
						if (vo.tab && vo.tab.length > 0 ) {
							total = 0
							for (let _tmpi in vo.tab) {
								var tabVo = vo.tab[_tmpi]
								if (! vo.hide ) {
									tabVo[valueStr[i]]= list[tabVo.index].power
									total = total + tabVo[valueStr[i]]
								}
							}
							vo[valueStr[i]] = total
						}else{
							vo[valueStr[i]] = list[vo.index].power
						}
					}
					i=i+1
				} while ((i <= 1))
				_model.Fire(local_FriendEvent.UPDATE_FIGHT_DATA, cfg)
			}
		}
		
		this.RegisterProtocal(15014, On15014)

		//查看玩家信息
		let requset = (server_id?, role_id?,type?) =>{
			this.SendFmtToGame(19501, "hlh",server_id, role_id,type)
		}
		_model.Bind(local_FriendEvent.REQUEST_PLAYERMESSAGE_EVENT,requset)

		let On19501 = () =>{
			
		}
		this.RegisterProtocal(19501,On19501)

		let On19502 = () =>{
			let scmd =  user_mgr.GetSCMD(19502)
			if(scmd ){
				_model.Fire(FriendEvent.UPDATE_PLAYERMESSAGE_GUARD,scmd)
				_model.Fire(FriendEvent.UPDATE_FAERIES_EVENT,scmd)
				_model.setPlayerMessage(scmd)
			}
		}
		this.RegisterProtocal(19502,On19502)

		let On19503 = () =>{
			let scmd =  user_mgr.GetSCMD(19503)
			if(scmd ){
				_model.Fire(local_FriendEvent.UPDATE_PLAYERMESSAGE_DRAGONBALL,scmd)
			}
		}
		this.RegisterProtocal(19503,On19503)

		let On19504 = () =>{
			let scmd =  user_mgr.GetSCMD(19504)
			if(scmd && scmd.sys_type == 3 ){ //影装
				_model.Fire(local_FriendEvent.UPDATE_PLAYERMESSAGE_HOLYSEAL,scmd)
			}else{
				_model.Fire(local_FriendEvent.UPDATE_PLAYERMESSAGE_LONGLANGUAGE,scmd)
			}
		}
		this.RegisterProtocal(19504,On19504)

		let On19505 = () =>{
			let scmd =  user_mgr.GetSCMD(19505)
			if(scmd){
				_model.Fire(local_FriendEvent.UPDATE_PLAYERMESSAGE_REVELATION,scmd)
			}
		}
		this.RegisterProtocal(19505,On19505)

		let On19506 = () =>{
			let scmd =  user_mgr.GetSCMD(19506)
			if(scmd) {
				_model.SetIllusionInfo(scmd)
				_model.Fire(local_FriendEvent.UPDATE_PLAYERMESSAGE_ILLUSION,scmd)
			}
		}
		this.RegisterProtocal(19506,On19506)

		let On19507 = () => {
			let scmd = user_mgr.GetSCMD(19507)
			if(scmd){
				_model.Fire(local_FriendEvent.UPDATE_PLAYERMESSAGE_GODBEFALL,scmd)
			}
		}
		this.RegisterProtocal(19507,On19507)

		let On19508 = () => {
			let scmd = user_mgr.GetSCMD(19508)
			if(scmd){
				_model.Fire(local_FriendEvent.UPDATE_PLAYERMESSAGE_UNREAL,scmd)
			}
		}
		this.RegisterProtocal(19508,On19508)

		let On19509 = () => {
			let scmd = user_mgr.GetSCMD(19509)
			if(scmd){
				_model.Fire(local_FriendEvent.UPDATE_PLAYERMESSAGE_LUNG,scmd)
			}
		}
		this.RegisterProtocal(19509,On19509)

		let On19510 = () => {
			let scmd = user_mgr.GetSCMD(19510)
			if(scmd){
				_model.Fire(local_FriendEvent.UPDATE_PLAYERMESSAGE_GODBEAST,scmd)
			}
		}
		this.RegisterProtocal(19510,On19510)

		let On19511 = () => {
			let scmd = user_mgr.GetSCMD(19511)
			if(scmd){
				_model.other_demon_info = scmd.demons_list
				_model.Fire(local_FriendEvent.UPDATE_PLAYERMESSAGE_PET,scmd)
			}
		}
		this.RegisterProtocal(19511,On19511)

		let On19512 = () => {
			let scmd = user_mgr.GetSCMD(19512)
			if(scmd){
				_model.Fire(local_FriendEvent.UPDATE_PLAYERMESSAGE_RUNE,scmd)
			}
		}
		this.RegisterProtocal(19512,On19512)
		_model.Bind(local_FriendEvent.REQUEST_PROTO,(id, fmt, ...new_args) => {
				this.SendFmtToGame(id, fmt, ...new_args)
			}
		)
		let ClosePlayerMsgView = () => {
			if (player_message_view ) {
				player_message_view.Close()
			}
		}
		
		_model.Bind(local_FriendEvent.CLOSE_MES_VIEW, ClosePlayerMsgView)
	}
	
	this.InitInfo()
}

}
window["FriendController"] = FriendController
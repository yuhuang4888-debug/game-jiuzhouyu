
//require("game.proto.110.Require110")
//require("game.chat.ChatBagPanel")
// //require("game.chat.ChatContentItem")
//require("game.chat.ChatItem")
//require("game.chat.SystemItem")
//require("game.chat.ChatEntView")
//require("game.chat.ChatToolPanel")
//require("game.chat.ChatMenuView")
//require("game.chat.ChatModel")
//require("game.chat.ChatParentTab")
//require("game.chat.ChatParentView")
//require("game.chat.ChatSystemItem")
//require("game.chat.ChatToolBagItem")
//require("game.chat.ChatToolBagItem2")
//require("game.chat.ChatToolGridItem")
//require("game.chat.ChatTrumpetMenu")
//require("game.chat.ChatTrumpetMenuItem")
//require("game.chat.ChatTrumpetView")
//require("game.chat.VoiceChatView")
//require("game.chat.VoiceVo")

import "../chat/ChatBagPanel"
import "../chat/ChatMenuView"
import "../chat/ChatParentView"
import "../chat/ChatToolPanel"
import { ChatVoiceManager } from "../chat/ChatVoiceManager"
import { AppConst } from "../common/AppConst"
import { BaseController } from "../common/BaseController"
import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { Config } from "../common/Config"
import { EventName } from "../common/EventName"
import { FigureProtoVo } from "../common/FigureProtoVo"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { ChatModel, ChatModelEvent, CHAT_TYPE } from "../commonModel/ChatModel"
import { FriendModel } from "../commonModel/FriendModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { LungModel } from "../commonModel/LungModel"
import { MainFunc } from "../commonModel/MainUIModel"
import { SettingModel } from "../commonModel/SettingModel"
import { RoleManager } from "../commonModel/RoleManager"
import { SceneManager } from "../scene/SceneManager"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { Message } from "../sysInfo/SysInfoController"
import { ColorUtil } from "../util/ColorUtil"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { Status } from "../util/Status"
import { TimeUtil } from "../util/TimeUtil"
import { DEVICE_OS, Util } from "../util/Util"
import "../chat/VoiceChatView"
import "../chat/ChatTrumpetView"
import "../chat/ChatTrumpetMenu"
import { GuildModel } from "../commonModel/GuildModel"
import { RedPacketModel } from "../commonModel/RedPacketModel"
import { LimitLevelShopModel } from "../commonModel/LimitLevelShopModel"
import { PlatformManager } from "../PlatformManager"
import { MarriageModel } from "../commonModel/MarriageModel"
import { RedDotController } from "../common/RedDotController"
import { RedKey } from "../common/RedDotDefine"

//require("game.chat.ChatVoiceManager")
export class ChatController extends BaseController {
	InitInfo
	RevNewChuanwen
	bag_panel
	chat_view
	face_panel
	menu_view
	model
	trumpet_view
	trumpet_menu


	public constructor() {
		super()


		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName
		let local_CHAT_TYPE = CHAT_TYPE

		let role_mgr = RoleManager.GetInstance()
		let local_ChatModelEvent = ChatModelEvent
		let friend_model = FriendModel.GetInstance()
		let user_msg_adapter = UserMsgAdapter.GetInstance()
		let local_Util = Util
		let local_Message = Message
		let local_Config = Config
		let goods_model = GoodsModel.GetInstance()
		let local_ColorUtil = ColorUtil
		// let local_SysInfoType = SysInfoType
		// let local_SysInfoType = SysInfoCtrl.SysInfoType
		// let custom_activity_model = CustomActivityModel.GetInstance()

		this.model = ChatModel.GetInstance()
		let _model = this.model

		this.InitInfo = () => {
			// let game_star = () => {
			// 	_model.InitConfig()
			// }
			// local_GlobalEventSystem.Bind(local_EventName.INIT_CONFIG, game_star)
			_model.InitConfig()
			local_GlobalEventSystem.Bind(local_EventName.GAME_START, () => {
				_model.ClearChatDic()
				this.SendFmtToGame(11010, "c", local_CHAT_TYPE.GUILD)
				this.SendFmtToGame(11010, "c", local_CHAT_TYPE.PRIVATE_CHAT)
				let openDay = ServerTimeModel.GetInstance().GetOpenServerDay()
				this.SendFmtToGame(11010, "c", local_CHAT_TYPE.WORLD)
				if (openDay != 1) {
					this.SendFmtToGame(11010, "c", local_CHAT_TYPE.SMALL_KUAFU)
					// this.SendFmtToGame(11010, "c", local_CHAT_TYPE.WORLD)
					this.SendFmtToGame(11010, "c", local_CHAT_TYPE.GHOST_WALK)
				}
				this.SendFmtToGame(11050)
				this.SendFmtToGame(11064)
				this.SendFmtToGame(11023)
				_model.WelcomeChat()
				_model.setSmallKuaFuOpen()


				let package_code = PlatformManager.GetInstance().GetWXPackageCode()
				if (package_code) {
					this.SendFmtToGame(11065, "s", package_code)
				}
			}
			)
			let day_change = () => {
				if (!_model.kuaFuOpenData) {
					this.SendFmtToGame(11023)
				}
				if (!_model.SmallKuaFuOpen) {
					_model.setSmallKuaFuOpen()
				}
			}

			local_GlobalEventSystem.Bind(ServerTimeModel.DAY_CHANGE, day_change)
			let open_chat_view = (channel?) => {
				// [ts2lua]window下标访问可能不正确
				if (!window["ChatParentView"]) {
					if (!ResManager.GetInstance().IsJsLoad("chat")) {

					}
				}

				if (!this.chat_view) {
					// [ts2lua]window下标访问可能不正确
					let chat_view_class = window["ChatParentView"]
					this.chat_view = new chat_view_class
				}
				if (channel == local_CHAT_TYPE.GUILD) {
					let vo = role_mgr.GetMainRoleVo()
					if (vo.guild_id <= 0) {
						channel = local_CHAT_TYPE.WORLD
					}
				}
				this.chat_view.CustomMehod(0, _model.chatViewIndex(channel))
				if (!this.chat_view.HasOpen()) {
					this.chat_view.Open()
				}
			}

			local_GlobalEventSystem.Bind(local_EventName.OPEN_CHAT_VIEW, open_chat_view)

			let close_chat_view = () => {
				if (this.chat_view) {
					this.chat_view.Close()
				}
			}

			local_GlobalEventSystem.Bind(local_EventName.CLOSE_CHAT_VIEW, close_chat_view)
			// let open_face_panel = (pos?, is_down?) => {
			let open_face_panel = (...new_args) => {
				// [ts2lua]window下标访问可能不正确
				if (!window["ChatToolPanel"]) {
					if (!ResManager.GetInstance().IsJsLoad("chat")) {

					}
				}
				if (!this.face_panel) {
					// [ts2lua]window下标访问可能不正确
					let face_panel_class = window["ChatToolPanel"]
					this.face_panel = new face_panel_class()
				}
				// this.face_panel.setData(pos, is_down)
				this.face_panel.Open(...new_args)
			}

			_model.Bind(local_ChatModelEvent.OPENTOOLPANEL, open_face_panel)
			let close_face_panel = (e?) => {
				if (this.face_panel && this.face_panel.HasOpen()) {
					this.face_panel.Close()
				}
			}

			_model.Bind(local_ChatModelEvent.CLOSETOOLPANEL, close_face_panel)
			let open_bag_panel = (...new_args) => {
				// [ts2lua]window下标访问可能不正确
				if (!window["ChatBagPanel"]) {
					if (!ResManager.GetInstance().IsJsLoad("chat")) {

					}
				}
				if (!this.bag_panel) {
					// [ts2lua]window下标访问可能不正确
					let bag_panel_class = window["ChatBagPanel"]
					this.bag_panel = new bag_panel_class()
				}
				// this.bag_panel.setData(pos, down)
				this.bag_panel.Open(...new_args)
			}

			_model.Bind(local_ChatModelEvent.OPENBAGPANEL, open_bag_panel)
			let close_bag_panel = (e?) => {
				if (this.bag_panel && this.bag_panel.HasOpen()) {
					this.bag_panel.Close()
				}
			}

			_model.Bind(local_ChatModelEvent.CLOSEBAGPANEL, close_bag_panel)
			let open_chat_menu = (...new_args) => {
				let args = new_args
				let role_id = args[1]
				if (role_id == role_mgr.GetMainRoleId()) {
					return
				}
				if (!this.menu_view) {
					// [ts2lua]window下标访问可能不正确
					let menu_view_class = window["ChatMenuView"]
					this.menu_view = new menu_view_class()
				}
				// let ser_id = args[2]
				// let server_id = role_mgr.GetMainRoleVo().server_unique_id
				// let menu_data = friend_model.getMenuData(role_id)
				// if ((role_id != 0 && (! menu_data || TimeUtil.getServerTimeMs() - menu_data.requestTime >= 800)) && (ser_id && ser_id == server_id) ) {
				// 	friend_model.Fire(FriendEvent.REQUEST_MENU_DATA, role_id)
				// }
				if ((role_id != 0 && this.menu_view.HasOpen()) && this.menu_view.clickTarget() == args[0]) {
					this.menu_view.Close()
				} else {
					this.menu_view.Open(...new_args)
				}
			}

			_model.Bind(local_ChatModelEvent.OPEN_CHAT_MENU, open_chat_menu)
			_model.Bind(local_ChatModelEvent.REQUEST_PROTO, (id, fmt, ...new_args) => {
				this.SendFmtToGame(id, fmt, ...new_args)
			}
			)

			let send_msg = (...new_args) => {
				let args = new_args
				//PrintTable(args)
				if (args[1] == 11004) {
					let voice_id = args[2]
					let player_id = args[3]
					let voice_msg_time = args[4]
					let ticket = "ticket"
					UserMsgAdapter.GetInstance().WriteBegin(11004)
					let vmt1 = Math.floor(voice_msg_time)
					UserMsgAdapter.GetInstance().WriteFMT("llis", { voice_id, player_id, vmt1, ticket })
					UserMsgAdapter.GetInstance().SendToGame()
				} else {
					let goodsStr = ""
					let goosList = args[6]
					if (goosList.length > 0) {
						goodsStr = goodsStr + "["
						let i = 0
						do {
							let info = goosList[i]
							goodsStr = goodsStr + info
							if (i != goosList.length - 1) {
								goodsStr = goodsStr + ","
							}
							i = i + 1
						} while ((i < goosList.length))
						goodsStr = goodsStr + "]"
					}
					if (!args[9]) {
						// [ts2lua]tslua无法自动转换正则表达式，请手动处理。
						// args[5] = args[5].gsub("<", "*")
					}
					console.log("goodsStr:", goodsStr)
					this.SendFmtToGame(args[0], "csslssis", args[1], args[2], args[3], args[4], args[5], goodsStr, args[7], args[8])
					PlatformManager.GetInstance().ChatMonitor(args[1], args[5], args[9])
				}
			}

			_model.Bind(local_ChatModelEvent.CHAT_SEND_MSG, send_msg)
			_model.Bind(local_ChatModelEvent.SEND_SPECIAL_CHANNEL_GOODS, (channel?, goods_id_list?) => {
				this.WriteBegin(11025)
				this.WriteFMT("c", channel)
				this.WriteFMT("h", goods_id_list.length)
				for (let _tmpi in goods_id_list) {
					var id = goods_id_list[_tmpi]
					this.WriteFMT("l", id)
				}
				this.SendToGame()
			}
			)
			_model.Bind(local_ChatModelEvent.CHECK_SPECIAL_CHANNEL_GOODS, (channel?, goods_id?) => {
				this.SendFmtToGame(11026, "cl", channel, goods_id)
			}
			)
			local_GlobalEventSystem.Bind(local_EventName.RECEIVE_NEW_CHUANWEN, (scmd?, type?) => {
				this.RevNewChuanwen(scmd, type)
			}
			)
			local_GlobalEventSystem.Bind(local_EventName.SHOW_CHUANWEN, (content?, cfg?, scmd?) => {
				if (cfg.subtype != 0 && content) {
					scmd.channel = cfg.subtype
					scmd.time = TimeUtil.getServerTime()
					scmd.msg = content
					scmd.tip = cfg.tip
					if (cfg.module_id == 460 && ((cfg.id == 14 || cfg.id == 15) || cfg.id == 16)) {
						scmd.is_boss = true
					}
					 else if (cfg.module_id == 401 && cfg.id == 1) {
						//scmd.is_depot = true
					}
					 else if (cfg.module_id == 151 && cfg.id == 2) {
						scmd.is_market = true
					}
					if (scmd.type == 11015) {
						// [ts2lua]scmd下标访问可能不正确
						scmd["chuanwen"] = true
					}
					_model.setChannelChatData(scmd, cfg)
				}
			}
			)

			_model.Bind(local_ChatModelEvent.OPEN_TRUMPET_VIEW, () => {
				// [ts2lua]window下标访问可能不正确
				if (!this.trumpet_view) {
					let trumpet_view_class = window["ChatTrumpetView"]
					this.trumpet_view = new trumpet_view_class()
				}
				// this.face_panel.setData(pos, is_down)
				if (!this.trumpet_view.HasOpen()) {
					this.trumpet_view.Open()
				} else {
					this.trumpet_view.Close()
				}
			})

			_model.Bind(local_ChatModelEvent.OPEN_TRUMPET_MENU, (...new_args) => {
				// [ts2lua]window下标访问可能不正确
				if (!this.trumpet_menu) {
					let trumpet_menu_class = window["ChatTrumpetMenu"]
					this.trumpet_menu = new trumpet_menu_class()
				}
				// this.face_panel.setData(pos, is_down)
				if (!this.trumpet_menu.HasOpen()) {
					this.trumpet_menu.Open(new_args)
				} else {
					this.trumpet_menu.Close()
				}
			})




			local_GlobalEventSystem.Bind(local_EventName.UNDER_LINE_CLICK_EVENT, (param_list?, x?, y?, text?) => {
				// _model.LinkFun(param_list)
				if (text) {
					_model.LinkEvtInChatItem(text)
				}
			}
			)


			GlobalEventSystem.Bind(ChatModelEvent.ON_RESULT_OF_SPEECH, (reg_txt?) => {
				// reg_txt = LanguageFilter.FilterMsg(reg_txt)
				this.model.reg_txt = reg_txt
				if (!this.model.loading_voice) {
					// if (SettingModel.GetInstance().GetSettingInfo(SettingModel.TYPE.VOICE, SettingModel.SUBTYPE.TEXTONLY) == 1 ) {
					//     this.model.Fire(ChatModelEvent.REQUEST_CCMD_EVENT, 11001, this.model.reg_channel, reg_txt, this.model.chating_key_id || 0, "", null, "")
					// }else{
					if (this.model.sendAlready) {
						// this.model.Fire(ChatModelEvent.REQUEST_CCMD_EVENT, 11005, this.model.reg_channel, this.model.reg_receive_id, this.model.voice_id, reg_txt)
						this.SendFmtToGame(11005, "clls", this.model.reg_channel, this.model.reg_receive_id, this.model.voice_id, reg_txt)
					} else {
						this.SendVoice()
					}
					// }
				}
			})

			GlobalEventSystem.Bind(ChatModelEvent.ON_END_OF_SPEECH, (data?) => {
				if (this.model.end_speech_data) {
					if (data != "") {
						Message.show(data)
					}
					this.model.end_speech_data = null
				} else {
					this.model.end_speech_data = data
				}
				if (!this.model.loading_voice && !this.model.sendAlready) {
					this.SendVoice()
				}
			})

			SettingModel.GetInstance().Bind(SettingModel.BLOCK_SETTING_CHANGE, (subtype?, is_open?) => {
				if (subtype == 22) {
					_model.shield_channel_setting = is_open == 1
				}
			})

			let On11000 = () => {
				let scmd = user_msg_adapter.GetSCMD(11000)
				Util.ErrorCodeShow(scmd.error_code, scmd.args)
			}

			this.RegisterProtocal(11000, On11000)
			let On11001 = () => {
				let scmd = user_msg_adapter.GetSCMD(11001)
				let temp_msg=scmd.msg.toString()	
				let str=""
				let faceList: Array<string>,titlebgList:Array<string>
				[faceList,titlebgList] = ChatModel.GetInstance().getChatFace(scmd.msg);
				if (faceList && faceList.length > 0) {
					for (let i: number = 0; i < faceList.length; i++) {
						let face: string = faceList[i];
						let faceId: string = face.replace(/<f_/gi, "");
						faceId = faceId.replace(/>/gi, "");
						if (Number(faceId) > ChatModel.GetInstance().faceMax() || Number(faceId < ChatModel.GetInstance()._faceMin)) {//不合法表情id
							str=face.replace(/<f_/gi,"/\<f_")
							str=str.replace(/>/gi,"/\>")
							temp_msg=temp_msg.replace(face,str)
						}
						// str+=face

					}
				}
				scmd.msg=temp_msg// str==""? scmd.msg:str
				scmd.iType = ChatModel.MSG_TYPE.TEXT
				_model.setChannelChatData(scmd)
			}

			this.RegisterProtocal(11001, On11001)
			let On11002 = () => {
				let scmd = user_msg_adapter.GetSCMD(11002)
				scmd.iType = ChatModel.MSG_TYPE.TEXT
				_model.setChatData(scmd)
			}

			this.RegisterProtocal(11002, On11002)
			let On11010 = () => {
				let scmd = user_msg_adapter.GetSCMD(11010)
				_model.setChatCache(scmd)
			}

			this.RegisterProtocal(11003, "on11003")
			this.RegisterProtocal(11004, "on11004")
			this.RegisterProtocal(11005, "on11005")

			this.RegisterProtocal(11010, On11010)

			let On11015 = () => {
				let scmd = user_msg_adapter.GetSCMD(11015)
				local_GlobalEventSystem.Fire(local_EventName.RECEIVE_NEW_CHUANWEN, scmd, 11015)
			}
			this.RegisterProtocal(11015, On11015)

			let On11018 = () => {
				let scmd = user_msg_adapter.GetSCMD(11018)
				local_GlobalEventSystem.Fire(local_EventName.RECEIVE_NEW_CHUANWEN, scmd, 11018)
			}
			this.RegisterProtocal(11018, On11018)

			let On11020 = () => {
				let scmd = user_msg_adapter.GetSCMD(11020)
				Message.show(scmd.content)
			}
			this.RegisterProtocal(11020, On11020)
			let On11023 = () => {
				let scmd = user_msg_adapter.GetSCMD(11023)
				_model.setKuafuData(scmd.is_open >= 1)
			}

			this.RegisterProtocal(11023, On11023)
			let On11025 = () => {
				let scmd = user_msg_adapter.GetSCMD(11025)
				if (scmd.error_code != 1) {
					_model.Fire(local_ChatModelEvent.SHOW_SPECIAL_CHANNEL_GOODS)
				}
			}

			this.RegisterProtocal(11025, On11025)
			let On11026 = () => {
				let scmd = user_msg_adapter.GetSCMD(11026)
			}

			this.RegisterProtocal(11026, On11026)
			let On11027 = () => {
				let scmd = user_msg_adapter.GetSCMD(11027)
				Util.ErrorCodeShow(scmd.error_code)
			}

			this.RegisterProtocal(11027, On11027)
			let On11028 = () => {
				let scmd = user_msg_adapter.GetSCMD(11028)
				_model.Fire(local_ChatModelEvent.PRIVATE_CHAT_PLAYER_INFO, scmd)
			}

			this.RegisterProtocal(11028, On11028)
			let On11029 = () => {
				let scmd = user_msg_adapter.GetSCMD(11029)
				scmd.iType = ChatModel.MSG_TYPE.HORN
				_model.setTrumpet(scmd)
			}

			this.RegisterProtocal(11029, On11029)
			let On11046 = () => {
				let scmd = user_msg_adapter.GetSCMD(11046)
				let role_id = role_mgr.GetMainRoleId()
				for (let _tmpi in scmd.list) {
					var data = scmd.list[_tmpi]
					if (role_id == data.role_id) {

					} else {
						_model.ClearRoleChatData(data.role_id)
					}
				}
			}

			this.RegisterProtocal(11046, On11046)
			let On11050 = () => {
				let scmd = user_msg_adapter.GetSCMD(11050)
				_model.StartGongGaoList(scmd)
			}

			this.RegisterProtocal(11050, On11050)
			let On11060 = () => {
				let scmd = user_msg_adapter.GetSCMD(11060)
				if (!(SceneManager.GetInstance().IsKfSingleRankScene() || SceneManager.GetInstance().IsEveningScene() || SceneManager.GetInstance().IsNewMainLineDungeon())) {
					// 屏蔽龙纹精粹&完美神纹碎片
					if(LungModel.lung_msg_hide){
						if (!scmd.goods_list) {
							return
						}
						for(let i in scmd.goods_list) {
							let item = scmd.goods_list[i]
							if (item.goods_type_id == 38040030 || item.goods_type_id == 38040100) {
								return
							}
						}
					}
					
					let show = (str?, gvo?) => {
						switch(scmd.type){
							case 1:
								local_Message.show(str)
								break;
							case 2:
								break;
							case 3:
								local_Message.show(str)
								break;
							case 4:
								if (Util.IsTableEmpty(BaseWindowComponent.CURR_OPEN_VIEW)) {
									local_Message.showGoods(gvo)
								}
								break;
							case 5:
								local_Message.show(`${str}(双倍战魂卡)`)
								break;
						}
					}

					let gvo = null
					if (!scmd.goods_list) {
						return
					}
					for (let _tmpi in scmd.goods_list) {
						var obj = scmd.goods_list[_tmpi]
						if (((obj.goods_type_id == 22 || obj.goods_type_id == 23) || obj.goods_type_id == 41) || obj.goods_type_id == 42) {
							// [ts2lua]local_Config.PRELOAD_CLIENT_CONFIG.ConfigNotNormalGoods下标访问可能不正确 UserMsgAdapter.GetInstance()
							if (local_Config.PRELOAD_CLIENT_CONFIG.ConfigNotNormalGoods[obj.goods_type_id]) {
								// [ts2lua]local_Config.PRELOAD_CLIENT_CONFIG.ConfigNotNormalGoods下标访问可能不正确
								obj.goods_type_id = local_Config.PRELOAD_CLIENT_CONFIG.ConfigNotNormalGoods[obj.goods_type_id].goods_id
							}
						}
						gvo = goods_model.GetGoodsBasicByTypeId(obj.goods_type_id)
						if (gvo && obj.num > 0 && gvo.type != LungModel.LungMaterialGoodsType) {
							let name = gvo.goods_name
							let str = "获得 <font color=" + local_ColorUtil.GetColorLight(gvo.color) + ">" + name + "x" + obj.num + "</font>"
							// [ts2lua]gvo下标访问可能不正确
							gvo['drop_num'] = obj.num
							show(str, gvo)
						}
					}
				}
			}

			this.RegisterProtocal(11060, On11060)
			let On11061 = () => {
				let scmd = user_msg_adapter.GetSCMD(11061)
				//Laya:log("scmd 11061+++++++++++++++++:", scmd)
				let gvo = null
				let str = ""
				for (let _tmpi in scmd.object_list) {
					var v = scmd.object_list[_tmpi]
					let typeId, lock = goods_model.GetMappingTypeId(Number(v.style), Number(v.typeId))
					gvo = goods_model.GetGoodsBasicByTypeId(typeId)
					if (gvo && v.count > 0) {
						let name = gvo.goods_name
						if (v.count > 1) {
							str = "获得 <font color=" + local_ColorUtil.GetColorLight(gvo.color) + ">" + name + "x" + v.count + "</font>"
						} else {
							str = "获得 <font color=" + local_ColorUtil.GetColorLight(gvo.color) + ">" + name + "</font>"
						}
						local_Message.show(str)
					}
				}
			}

			this.RegisterProtocal(11061, On11061)
			let On11063 = () => {
				let scmd = user_msg_adapter.GetSCMD(11063)
				MarriageModel.GetInstance().PlayFlowerEffect(scmd)
			}

			this.RegisterProtocal(11063, On11063)

			//策划要求只有该帐号下的第一个角色才会推
			let On11064 = () => {
				let scmd = user_msg_adapter.GetSCMD(11064)
				ResManager.GetInstance().LoadGameConfig(this,"config_jjc_robot",false,null,(cfg)=>{
					ResManager.GetInstance().LoadGameConfig(this,"ClientRobotLv",true,undefined,(robotlv)=>{
						_model.createRobotChat(scmd.type,cfg,robotlv)
					})
				})
			}

			this.RegisterProtocal(11064, On11064)
			let On11016 = () => {
				let scmd = user_msg_adapter.GetSCMD(11016)
				if (scmd.module_id == 339) {
					let role_vo = role_mgr.GetMainRoleVo()
					if (role_vo.guild_id == 0) {
						return	
					}
					RedPacketModel.GetInstance().SetRedMark(true)
				} else if (scmd.module_id == 400 && scmd.type == 1) {
					RedDotController.ins.up(RedKey.GUILD_APPLY, scmd.num);
					local_GlobalEventSystem.Fire(local_EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Guild)
				}
			}

			this.RegisterProtocal(11016, On11016)
		}

		this.RevNewChuanwen = (scmd?, type?) => {
			let desc, cfg
			[desc, cfg] = _model.GetChuanWen(scmd)
			if (!cfg) {
				return
			}
			if (scmd.module_id == LimitLevelShopModel.ModuleId && ! LimitLevelShopModel.GetInstance().GetTypeData(scmd.id) ) {
				return
			}
			// if (scmd.module_id == KfHolyAreaDefine.Module_Id && ! KfHolyAreaModel.GetInstance().GetOpenState() ) {
			// 	return
			// }
			// if (scmd.module_id == TopVipModuleId && ! TopVipModel.GetInstance().CheckMainRoleCanBuySupremeVipLevel() ) {
			// 	return
			// }
			if (!desc || desc == "") {
				return
			}
			desc = _model.PackageSpecialTab(desc)
			scmd.type = type
			if (cfg.type == 1 || cfg.type == 4 || cfg.type == 5 || cfg.type == 6) {
				// local_GlobalEventSystem.Fire(SysInfoController.APPEND_MSG, local_SysInfoType.CHUANWEN, desc, cfg.type)
				// SysInfoCtrl.Instance.AppendMsg(SysInfoCtrl.SysInfoType.MINI, desc, cfg.type)
				let my_playerId = RoleManager.GetInstance().GetMainRoleId()
				if (scmd.module_id == 416 && scmd.id == 4 && scmd.player_id == my_playerId){
					
				} else {
					this.model.showChuanwen({ txt: desc, type: cfg.type })
				}
				local_GlobalEventSystem.Fire(local_EventName.SHOW_CHUANWEN, desc, cfg, scmd)
			} else if (cfg.type == 2) {
				local_GlobalEventSystem.Fire(local_EventName.SHOW_CHUANWEN, desc, cfg, scmd)
			} else if (cfg.type == 3) {
				let text = _model.DeleteSpecialSign(desc)
				local_Message.show(text)
				if (cfg.subtype != 0) {
					local_GlobalEventSystem.Fire(local_EventName.SHOW_CHUANWEN, desc, cfg, scmd)
				}
			}
			if (scmd) {
				// if (scmd.module_id == 331 && (((scmd.id == 4 || scmd.id == 17) || scmd.id == 18) || scmd.id == 22) ) {
				// 	let act_info = custom_activity_model.GetActInfoByShowID(local_Config.PRELOAD_CLIENT_CONFIG.ConfigCustomActivity.ACT_ID.CLOUD_PURCHASE, 0)
				// 	if (act_info ) {
				// 		custom_activity_model.Fire(CustomActivityDefine.EVENT.SCMD_REQUEST, 33112, act_info.sub_type)
				// 	}
				// }
			}
		}

		this.InitInfo()
	}

	public SendVoice() {

		// if (this.model.voice_id && SettingModel.GetInstance().GetSettingInfo(SettingModel.TYPE.VOICE, SettingModel.SUBTYPE.TEXTONLY) == 0 ) {
		if (this.model.voice_id) {
			console.log("SendVoice")

			if (this.model.reg_channel == CHAT_TYPE.TEAM) {
				// if (! TeamModel.GetInstance().team_info ) {
				// 	Message.show("请加入队伍")
				// 	return
				// }
			} else if (this.model.reg_channel == CHAT_TYPE.WORLD_KUAFU) {
				if (!this.model.kuafuShow(true)) {
					Message.show("当前没有活动开启，可使用喇叭发送信息")
					return
				}
			}

			ChatVoiceManager.GetInstance().AddMainRoleVoicePath(this.model.voice_id, this.model.voice_path)
			let sendId = this.model.voice_id
			var onLoadCallback = (voice_data, time_len) => {
				//test
				// time_len = 7
				if (this.model.voice_id == sendId && this.model.reg_channel) {
					let channel = this.model.reg_channel
					let receive_id = channel != ChatModel.CHANNEL_PRIVATE && (this.model.chating_key_id || 0) || (this.model.private_chat_receive_id || 0)
					let voice_msg_time = Math.max(1, Math.floor(time_len + 0.5))
					let data_send = voice_data
					let voice_text
					let auto_id = this.model.voice_id
					if (this.model.reg_txt) {
						voice_text = this.model.reg_txt
						this.model.reg_txt = null
					} else {
						voice_text = ""
						this.model.reg_receive_id = receive_id
					}
					this.model.reg_txt = null
					// this.model.Fire(ChatModelEvent.REQUEST_CCMD_EVENT, 11003, channel, receive_id, voice_msg_time, data_send, voice_text, auto_id)

					// let channel = args_list[2]
					// let receive_id = args_list[3] || 0
					// let voice_msg_time = args_list[4]
					// let data_send = args_list[5]
					// let voice_text = args_list[6] || ""
					// let auto_id = args_list[7]
					let tk_time = Status.NowTime
					let ticket = "ticket"
					let is_end = 0
					let voiceLength = 0
					for (let i = 0; i < data_send.Length; i++) {
						if (i == data_send.Length - 1) { is_end = 1 }
						UserMsgAdapter.GetInstance().WriteBegin(11003)
						let vmt = Math.floor(voice_msg_time)
						let tktime = Math.floor(tk_time)
						UserMsgAdapter.GetInstance().WriteFMT("cliis", { channel, receive_id, vmt, tktime, ticket })
						UserMsgAdapter.GetInstance().WriteFMT("B", data_send[i])
						UserMsgAdapter.GetInstance().WriteFMT("slc", { voice_text, auto_id, is_end })
						UserMsgAdapter.GetInstance().SendToGame()
						voiceLength = voiceLength + data_send[i].Length
					}
					// Debugger.Log("Voice Data Size is " + voiceLength)
					this.model.sendAlready = true
				}
			}
			this.model.loading_voice = true
			this.model.sendAlready = null
			ChatVoiceManager.GetInstance().LoadMainRoleVoiceData(this.model.voice_id, onLoadCallback)
		}
	}

	//语音
	public on11003() {

		/*
				channel.int8            // 频道
			role_id.int64         // 玩家id
			figure.rec_figure       // 形象数据
			auto_id.int32           // 自增id
			receive_id.int32        // 接受者id
			voice_text.string       // 语音文字内容
			voice_msg_time.int16    // 语音时间(秒)
			*/
		let scmd
		// let scmd = UserMsgAdapter.GetInstance().GetSCMD("11005")
		let channel = this.ReadFmt("c")
		let ser_id = UserMsgAdapter.GetInstance().ReadFmt("h")
		let ser_num = UserMsgAdapter.GetInstance().ReadFmt("h")
		let ser_name = UserMsgAdapter.GetInstance().ReadFmt("s")

		let player_list = []
		let figure = []
		let alength = this.ReadFmt("h")
		for (let i = 1; i <= alength; i++) {
			let data = { player_id: this.ReadFmt("l") }
			let fig = new FigureProtoVo();
			fig.ReadFmt(data)
			table.insert(player_list, data)
		}
		let data_ver, voice_id, receive_id, voice_text, voice_msg_time, send_time = this.ReadFmt("llishi")
		// let mainRoleVo = RoleManager.GetInstance().GetMainRoleVo()
		if (receive_id == 0) {
			// setmetatable(scmd, {__index :scmd.player_list[1]})
			scmd = {
				player_list: player_list, iType: ChatModel.MSG_TYPE.VOICE, voice_id: voice_id, length: voice_msg_time, channel: channel,
				ser_id: ser_id, ser_name: ser_name, player_id: player_list[1].player_id, msg: voice_text || "", args: "", result: 0,
				time: send_time, data_ver: data_ver, ser_num: ser_num, __index: scmd.player_list[1]
			}
		}
		// PrintTable(scmd)
		// let engine_version = Number(AppConst.EnglineVer)
		let engine_version = 0
		// console.log("engine_version", engine_version , scmd.data_ver)
		if (engine_version < scmd.data_ver && scmd.data_ver < 34) {
			return
		} else {
			ChatVoiceManager.GetInstance().SetVoiceVersion(scmd.voice_id, scmd.data_ver)
		}
		this.model.setChannelChatData(scmd)
		// let catch = ! this.model.AddMsg(scmd)
		// this.model.Fire(ChatModel.CHANGE_CHANNEL_SEND_INTERVAL, scmd)
		// this.model.Fire(ChatModel.UPDATE_SEND_TIME)
		// this.model.AddMainRoleChatContent(scmd.msg, scmd.player_id)
		// if (catch ) { return }
		// let subType = SettingModel.C2T[channel]
		// let autoPlay = (subType == null) || (SettingModel.GetInstance().GetSettingInfo(SettingModel.TYPE.VOICE, subType) == 1)
		// let key = GameSettingManager.blockChannel[channel]
		// let has_block = GameSettingManager.GetInstance().GetBlockProperty(key) // 检查语音自动播放屏蔽
		// if (autoPlay && ! has_block ) {
		//     if (SettingModel.GetInstance().GetSettingInfo(SettingModel.TYPE.VOICE, SettingModel.SUBTYPE.AUTOPLAY) == 1 ) {
		//         let wifiState = Application.internetReachability == UnityEngine.NetworkReachability.IntToEnum(2)
		//         if (wifiState ) {
		//             if (! ChatVoiceManager.GetInstance().GetVoice(scmd.voice_id) ) {
		//                 this.model.Fire(ChatModelEvent.REQUEST_CCMD_EVENT, 11004, scmd.voice_id, scmd.player_id,scmd.ser_id, scmd.time, "")
		//             }else{
		//                 ChatVoiceManager.GetInstance().PlayVoice(scmd.voice_id)
		//             }
		//         }
		//     }else{
		//         if (! ChatVoiceManager.GetInstance().GetVoice(scmd.voice_id) ) {
		//             this.model.Fire(ChatModelEvent.REQUEST_CCMD_EVENT, 11004, scmd.voice_id, scmd.player_id,scmd.ser_id, scmd.time, "")
		//         }else{
		//             ChatVoiceManager.GetInstance().PlayVoice(scmd.voice_id)
		//         }
		//     }
		// }
		console.log("on11003", ChatVoiceManager.GetInstance().GetVoice(scmd.voice_id), scmd.voice_id)
		//策划说有人发语音了不用自动播放
		// if (! ChatVoiceManager.GetInstance().GetVoice(scmd.voice_id) ) {
		// 	this.model.Fire(ChatModelEvent.REQUEST_CCMD_EVENT, 11004, scmd.voice_id, scmd.player_id, scmd.time, "")
		//     UserMsgAdapter.WriteBegin(11004)
		//     UserMsgAdapter.WriteFMT("llis", scmd.voice_id, scmd.player_id, Math.floor(scmd.time), "ticket")
		//     UserMsgAdapter.SendToGame()
		// }else{
		//     ChatVoiceManager.GetInstance().PlayVoice(scmd.voice_id)
		// }
	}

	// //请求语音
	// function ChatController.RequestVoiceMsg(voice_id, player_id, player_id)
	// 	UserMsgAdapter.WriteBegin(11004)
	//     UserMsgAdapter.WriteFMT("llis", voice_id, player_id, Math.floor(time), "ticket")
	//     UserMsgAdapter.SendToGame()
	// }

	//语音返回
	public on11004() {

		let erroCode = this.ReadFmt("i")
		let voice_id = this.ReadFmt("l")
		let voice_data = this.ReadFmt("B")
		console.log("on11004", erroCode, voice_id, voice_data)
		if (erroCode != 1) {
			Util.ErrorCodeShow(erroCode)
			return
		}

		ChatVoiceManager.GetInstance().AddVoiceData(voice_id, voice_data)
		ChatVoiceManager.GetInstance().PushPlay(voice_id)
	}

	public on11005() {

		let scmd = UserMsgAdapter.GetInstance().GetSCMD("11005")
		if (scmd.error_code != 1) {
			Util.ErrorCodeShow(scmd.error_code)
		}
	}
}
window["ChatController"] = ChatController
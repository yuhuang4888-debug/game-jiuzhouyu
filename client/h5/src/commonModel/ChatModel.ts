import { Alert, Alert_Type } from "../alert/Alert";
import { AutoFightManager } from "../autofight/AutoFightManager";
import { CommonManager } from "../common/CommonManager";
import { EventName, SceneEventType } from "../common/EventName";
import { HolySealToolTips } from "../common/HolySealToolTips";
import { LayerManager, Enum_UILayer } from "../common/LayerManager";
import { OpenFun } from "../common/OpenFun";
import { ResManager } from "../common/ResManager";
import { table } from "../common/table";
import { UIToolTipMgr } from "../common/UIToolTipMgr";
import { UserMsgAdapter } from "../common/UserMsgAdapter";
import { WordManager } from "../common/WordManager";
import { BossSceneManager } from "../commonController/BossSceneManager";
import { ActivityForeshowManager } from "./ActivityForeshowManager";
import { RoleManager } from "./RoleManager";
import { Scene } from "../scene/Scene";
import { SceneManager } from "../scene/SceneManager";
import { SceneObj } from "../scene/sceneobj/SceneObj";
import { ServerTimeModel } from "../serverTime/ServerTimeModel";
import { ChuanwenItem } from "../sysInfo/ChuanwenItem";
import { Message } from "../sysInfo/SysInfoController";
import { TrumpetItem } from "../sysInfo/TrumpetItem";
import { ColorUtil, ColorType, Enum_ColorUtil_Light, Enum_ColorUtil_Dark } from "../util/ColorUtil";
import { GlobalEventSystem, ClientConfig } from "../util/DeclareGlobalVar";
import { ErlangParser } from "../util/ErlangParser";
import { EventDispatcher } from "../util/EventDispatcher";
import { Status } from "../util/Status";
import { TimeUtil } from "../util/TimeUtil";
import { Util, DEVICE_OS, Split, Trim, HtmlColorTxt, GlobalTimerQuest } from "../util/Util";
import { Vector2 } from "../util/Vector2";
import { BabyEvent } from "./BabyModel";
import { BagModel } from "./BagModel";
import { BanqEvent, BanquetModel } from "./BanquetModel";
import { CustomActivityModel } from "./CustomActivityModel";
import { EquipModel } from "./EquipModel";
import { FriendModel } from "./FriendModel";
import { GodBefallDefine } from "./GodBefallModel";
import { GoodsModel } from "./GoodsModel";
import { GuildEvent, GuildModel } from "./GuildModel";
import { HolySealModel } from "./HolySealModel";
import { longlangModel } from "./longlangModel";
import { LungModel } from "./LungModel";
import { RevelationModel } from "./RevelationModel";
import { TeamModel, TeamEvent } from "./TeamModel";
import { UnrealModel } from "./UnrealModel";
import { StarEquipModel } from "./StarEquipModel";
import { StarEquipToolTip } from "../common/StarEquipToolTip";
import { ChuanwenSpecItem } from "../sysInfo/ChuanwenSpecItem";
import { BossModel } from "./BossModel";
import { HolyTerritoryModel } from "./HolyTerritoryModel";
import { MarketEvent, MarketModel } from "./MarketModel";
import { GuildActivityModel, GuildActEvent } from "./GuildActivityModel";
import { FestivalModel } from './FestivalModel';
import { KfHolyAreaModel } from "./KfHolyAreaModel";
import { DiamondFightModel } from "./DiamondFightModel";
import { Kf1vnModel } from "./Kf1vnModel";
import { SeaHegemonyModel } from "./SeaHegemonyModel";
import { SpecialPackageModel } from "./SpecialPackageModel";
import { DailyModel } from "./DailyModel";
import { Config } from "../common/Config"
import { GhostWalkEvent, GhostWalkModel } from "./GhostWalkModel";
import { GodCourtModel } from "./GodCourtModel";
import { GodCourtTooltip } from "../common/GodCourtTooltip";
import { UnrealToolTips } from "../common/UnrealToolTips";
import { LonglangToolTips } from "../common/LonglangToolTips";
import  "../sysInfo/ChuanwenItem";

export const TRUMPET_TYPE = {
	WORLD: 1,
	SMALL_KUAFU: 2,
	KUAFU: 3
}
export const CHAT_TOOL_TYPE = {
	BAG: 1,
	GOD: 2,
	SEAL: 3, //圣印
	GODBEFALL: 4, //神器
	REVELATION: 5, //天启
	GODCOURT: 6, //神庭
	LONGLANGUAGE:7
}
export enum CHAT_TYPE {
	SYSTEM = 10,
	WORLD = 1,
	TRUMPET = 2,
	GUILD = 4,
	TEAM = 5,
	SMALL_KUAFU = 17,
	PRIVATE_CHAT = 6,
	GUILD_QUIZ = 16,
	WORLD_KUAFU = 13,
	BARRAGE = 12,
	CAMP = 18,
	SEA = 19,
	GHOST_WALK = 20 //百鬼夜行
}
window["CHAT_TYPE"] = CHAT_TYPE
window["CHAT_TOOL_TYPE"] = CHAT_TOOL_TYPE
window["TRUMPET_TYPE"] = TRUMPET_TYPE
export const ChatModelEvent = {
	OPENTOOLPANEL: "CME.OPENTOOLPANEL",
	REQUEST_PROTO: "CME.REQUEST_PROTO",
	CLOSETOOLPANEL: "CME.CLOSETOOLPANEL",
	OPENBAGPANEL: "CME.OPENBAGPANEL",
	CLOSEBAGPANEL: "CME.CLOSEBAGPANEL",
	CHAT_MSG_UPDATE: "CME.CHAT_MSG_UPDATE",
	CHAT_MSG_NUM_UPDATE: "CME.CHAT_MSG_NUM_UPDATE",
	CHAT_CHANNEL_MSG_UPDATE: "CME.CHAT_CHANNEL_MSG_UPDATE",
	REQUEST_CHAT_MSG_CACHE: "CME.REQUEST_CHAT_MSG_CACHE",
	CHAT_CACHE_UPDATE: "CME.CHAT_CACHE_UPDATE",
	CHAT_SEND_MSG: "CME.CHAT_SEND_MSG",
	CHAT_MSG_CHANGE: "CME.CHAT_MSG_CHANGE",
	ADD_FACE: "CME.ADD_FACE",
	ADD_BAG_GOODS: "CME.ADD_BAG_GOODS",
	OPEN_CHAT_MENU: "CME.OPEN_CHAT_MENU",
	REQUEST_KAIFU: "CME.REQUEST_KAIFU",
	SEND_SPECIAL_CHANNEL_GOODS: "CME.SEND_SPECIAL_CHANNEL_GOODS",
	CHECK_SPECIAL_CHANNEL_GOODS: "CME.CHECK_SPECIAL_CHANNEL_GOODS",
	SHOW_SPECIAL_CHANNEL_GOODS: "CME.SHOW_SPECIAL_CHANNEL_GOODS",
	CHAT_BAG_OPEN: "CME.CHAT_BAG_OPEN",
	CLEAR_ROLE_DATA: "CME.CLEAR_ROLE_DATA",
	CLEAR_ROLE_PRIVATE: "CME.CLEAR_ROLE_PRIVATE",
	PRIVATE_CHAT_PLAYER_INFO: "CME.PRIVATE_CHAT_PLAYER_INFO",
	SELECT_TRUMPET_TYPE: "CME.SELECT_TRUMPET_TYPE",
	REMOVE_PRIVATE_CHAT: "CME.REMOVE_PRIVATE_CHAT",
	KEEP_CHATVIEW_MSG_NEW: "CME.KEEP_CHATVIEW_MSG_NEW",
	KEEP_MAINUICHATVIEW_MSG_NEW: "CME.KEEP_MAINUICHATVIEW_MSG_NEW",
	HIDE_MIAN_UI_CHAT_VIEW: "HIDE_MIAN_UI_CHAT_VIEW",
	//语音SDK识别结果返回
	ON_RESULT_OF_SPEECH: "ON_RESULT_OF_SPEECH",
	//语音SDK录制结果返回
	ON_END_OF_SPEECH: "ON_END_OF_SPEECH",
	//语音播放事件
	PLAY_VOICE: "PLAY_VOICE",
	STOP_VOICE_PLAY: "STOP_VOICE_PLAY",
	REQUEST_CCMD_EVENT: "REQUEST_CCMD_EVENT",
	CHANGE_RECORD_STATE: "CHANGE_RECORD_STATE",
	OPEN_TRUMPET_VIEW: "OPEN_TRUMPET_VIEW",
	OPEN_TRUMPET_MENU: "OPEN_TRUMPET_MENU",
	CLOSECHATPANEL: "CLOSECHATPANLE",
	CLICK_MAIN_ITEM: "CLICK_MAIN_ITEM"
}
window["ChatModelEvent"] = ChatModelEvent
export class ChatModel extends EventDispatcher {
	CampOpen
	CheckGongGaoFunc
	CheckPlatName
	ClearGongGaoTimer
	ClearRoleChatData
	DeleteSpecialSign
	FormatAttrTag
	FormatColorTag
	FormatLinkTag
	FormatLinkTag1
	FormatLinkTag2
	GetChuanWen
	GuildChat
	InitConfig
	LevelLimit
	LinkEvtInChatItem
	LinkFun
	PackageSpecialTab
	PrivateChatTabList
	StartGongGaoList
	StartGongGaoTimer
	UpdatetGongGaoTimer
	ViewClassCFG
	WelcomeChat
	_KuafuOpen
	_faceMax
	_faceMin
	_smallKuaFuOpen
	addPlayerShield
	addPrivateChatTab
	camp_open
	changeToDark
	channelChatDic
	channelImage
	chatBagData
	chatGodBefallWearData
	chatGodCourtBagData
	chatLongLanguageBagData
	chatMax
	chatRevelationBagData
	chatSealBagData
	chatToolBagData
	chatViewIndex
	chat_args_dic
	checkChanneOpen
	checkKuafuActivityOpen
	checkPlayerShield
	checkPrivateChatTab
	checkPrivateChatTabIndex
	chuanwen_wait_list
	cleanSendGoodsData
	createRobotChat
	delAllPrivateChatTab
	delFriendChannelChat
	delNoMsgPlayer
	delPlayerShield
	disposeChtaFace
	disposeChtaFace2
	disposeChtaGoods
	dynamicbind
	dynamicbind2
	fer
	getBagGoodsMsg
	getChannelChat
	getChatFace
	getGoodsInfo
	getLength
	getSendGoodsData
	holdFont
	kuafuShow
	matchSendGoods
	positionChat
	privateChat
	reSetPrivateNum
	selectChannel
	sendGoodsMesg
	setChannelChatData
	setChatCache
	setChatData
	setKuafuData
	setSendGoodsData
	setSmallKuaFuOpen
	setTrumpet
	shield_channel_setting
	showChat
	showChuanwen
	showTips
	showTrumpet
	sp_bind
	specManage
	successUp
	timeFormat
	trumpetColor
	trumpetImage
	trumpetName
	trumpetShow
	trumpet_Wait_List
	IsChinese
	replaceChatFace
	delHtmlTag
	matchHtml
	matchHtml2
	setChatInfoFormat //替换富文本中的<>
	hide_vip_dic
	public selectchannel = 0    //保留最新消息的页签
	public is_click_text = false


	public static CHINES_REG = /[\u3002|\uff1f|\uff01|\uff0c|\u3001|\uff1b|\uff1a|\u201c|\u201d|\u2018|\u2019|\uff08|\uff09|\u300a|\u300b|\u3008|\u3009|\u3010|\u3011|\u300e|\u300f|\u300c|\u300d|\ufe43|\ufe44|\u3014|\u3015|\u2026|\u2014|\uff5e|\ufe4f|\uffe5]/gi

	public static CHAT_TYPE = [CHAT_TYPE.SYSTEM, CHAT_TYPE.WORLD, CHAT_TYPE.GUILD, CHAT_TYPE.TEAM, CHAT_TYPE.SMALL_KUAFU, CHAT_TYPE.WORLD_KUAFU];
	public static SPECIAL_CHANNEL = [CHAT_TYPE.SMALL_KUAFU, CHAT_TYPE.WORLD_KUAFU];
	public static DO_NOT_SHOW_VIP_CHANNEL = [CHAT_TYPE.WORLD_KUAFU];
	public static DO_NOT_SHOW_VIP_TRUMPET = [TRUMPET_TYPE.KUAFU];
	public static SHIELD_CHANNEL = [CHAT_TYPE.WORLD, CHAT_TYPE.GUILD, CHAT_TYPE.SMALL_KUAFU, CHAT_TYPE.WORLD_KUAFU, CHAT_TYPE.CAMP, CHAT_TYPE.SEA]

	public static MSG_TYPE = {
		TEXT: 1,
		VOICE: 2,
		HORN: 3,
	}

	// ChuanWenType = []
	// ChuanWenType.ZHENXI = 4 //珍稀传闻
	// ChuanWenType.PAOMADENG = 2 //跑马灯公告

	ChuanWenType = {
		ZHENXI: 4,//珍稀传闻
		PINDAO: 6, //频道-场景
		PAOMADENG: 1 //跑马灯公告	
	}
	static Instance: any;
	static CHANNEL_PRIVATE: any;
	static chineseReg: any;

	public constructor() {
		super()

		if (ChatModel.Instance) {
			return
		}
		ChatModel.Instance = this
		this.successUp = false;
		this.chatMax = 30;
		this.trumpetShow = 10;
		this.trumpet_Wait_List = [];
		this.chuanwen_wait_list = [];
		this.privateChat = 50;
		this.selectChannel = 0;
		this.camp_open = false;
		this.shield_channel_setting = false

		// this.ViewClassCFG = [{channel=CHAT_TYPE.WORLD, index=0, label="世界", openDay=1, openLevel=0], [4]=[channel=CHAT_TYPE.GUILD, index=1, label="结社", openDay=1, openLevel=0], [5]=[channel=CHAT_TYPE.TEAM, index=2, label="队伍", instruction=InstructionType.Chat_guild, openDay=1, openLevel=0], [17]=[channel=CHAT_TYPE.SMALL_KUAFU, index=3, label="跨服", openDay=1, openLevel=200], [13]=[channel=CHAT_TYPE.WORLD_KUAFU, index=4, label="活动", openDay=5, openLevel=100], [15]=[channel=CHAT_TYPE.CAMP, index=5, label="阵营", openDay=1, openLevel=0], [19]=[channel=CHAT_TYPE.SEA, index=6, label="海域", openDay=1, openLevel=0], [10]=[channel=CHAT_TYPE.SYSTEM, index=7, label="系统", openDay=1, openLevel=0]];
		// this.ViewClassCFG = [{channel=CHAT_TYPE.WORLD, index=1, label="世界", openDay=1, openLevel=0],
		// 	[4]=[channel=CHAT_TYPE.GUILD, index=2, label="结社", openDay=1, openLevel=0],
		// 	[5]=[channel=CHAT_TYPE.TEAM, index=3, label="队伍", openDay=1, openLevel=0],
		// 	[17]=[channel=CHAT_TYPE.SMALL_KUAFU, index=4, label="跨服", openDay=1, openLevel=200],
		// 	[13]=[channel=CHAT_TYPE.WORLD_KUAFU, index=5, label="活动", openDay=5, openLevel=100],
		// 	[15]=[channel=CHAT_TYPE.CAMP, index=6, label="阵营", openDay=1, openLevel=0],
		// 	[19]=[channel=CHAT_TYPE.SEA, index=7, label="海域", openDay=1, openLevel=0],
		// 	[10]=[channel=CHAT_TYPE.SYSTEM, index=8, label="系统", openDay=1, openLevel=0]];
		this.ViewClassCFG = {
			"0": { channel: CHAT_TYPE.WORLD, index: 1, label: "世界", openDay: 1, openLevel: 0 },
			"4": { channel: CHAT_TYPE.GUILD, index: 2, label: "结社", openDay: 1, openLevel: 0 },
			"5": { channel: CHAT_TYPE.TEAM, index: 3, label: "队伍", openDay: 1, openLevel: 0 },
			"17": { channel: CHAT_TYPE.SMALL_KUAFU, index: 4, label: "跨服", openDay: 1, openLevel: 200 },
			"13": { channel: CHAT_TYPE.WORLD_KUAFU, index: 5, label: "活动", openDay: 5, openLevel: 100 },
			"15": { channel: CHAT_TYPE.CAMP, index: 6, label: "阵营", openDay: 1, openLevel: 0 },
			"19": { channel: CHAT_TYPE.SEA, index: 7, label: "海域", openDay: 1, openLevel: 0 },
			"10": { channel: CHAT_TYPE.SYSTEM, index: 8, label: "系统", openDay: 1, openLevel: 0 }
		};
		// this.channelChatDic =  new Object();
		this.channelChatDic = []
		this.chat_args_dic = []
		this._faceMax = 48;
		this._faceMin = 1;
		this._KuafuOpen = false;
		let local_Config = Config
		let local_Message = Message
		let local_ChatModelEvent = ChatModelEvent
		let local_CHAT_TYPE = CHAT_TYPE
		let local_TRUMPET_TYPE = TRUMPET_TYPE
		let local_TimeUtil = TimeUtil
		let role_mgr = RoleManager.GetInstance()
		let local_Math = Math
		let goods_model = GoodsModel.GetInstance()
		let local_CHAT_TOOL_TYPE = CHAT_TOOL_TYPE
		let local_Util = Util
		let local_DEVICE_OS = DEVICE_OS
		let equip_model = EquipModel.GetInstance()
		let sever_time_model = ServerTimeModel.GetInstance()
		let local_ColorUtil = ColorUtil
		let local_ColorType = ColorType
		//let local_RES = RES
		//let local_egret = egret
		let scene_mgr = SceneManager.GetInstance()
		let local_GoodsModel = GoodsModel
		let local_GlobalEventSystem = GlobalEventSystem
		let local_RevelationModel = RevelationModel
		let ui_tool_tip_mgr = UIToolTipMgr.GetInstance()
		let local_HolySealModel = HolySealModel
		let local_HolySealToolTips = HolySealToolTips
		let local_LungModel = LungModel
		let local_BagModel = BagModel
		let local_GodBefallDefine = GodBefallDefine
		let local_longlangModel = longlangModel
		let local_LonglangToolTips = LonglangToolTips
		let user_msg_adapter = UserMsgAdapter.GetInstance()
		let local_UnrealModel = UnrealModel
		let local_OpenFun = OpenFun
		let local_EventName = EventName
		let boss_model = BossModel.GetInstance()
		let local_BossBaseModel = BossModel
		let auto_fight_mgr = AutoFightManager.GetInstance()
		let secret_boss_model = BossSceneManager.GetInstance()// 无匹配的类
		let scene = Scene.GetInstance()
		let banquet_model = BanquetModel.GetInstance()// 无匹配的类
		let local_BanqEvent = BanqEvent// 无匹配的类
		let guild_model = GuildModel.GetInstance()// 无匹配的类
		let local_GuildEvent = GuildEvent// 无匹配的类
		let baby_model //= BabyModel.GetInstance() 无匹配的类
		let KfHolyArea_model = KfHolyAreaModel.GetInstance()
		let local_BabyEvent = BabyEvent// 无匹配的类
		// let local_SysInfoController = SysInfoController
		let config_ = []
		let trumpetWait_ = 10
		let gg_timer_ = null
		let gonggao_info_ = null
		let robot_content_config_ = null
		let robot_name_config_ = null
		let _SendGoodsData_ = []
		let faceWidth_ = 70
		let faceHeight_ = 48
		let binEvent_ = false
		let goods_id_ = null
		let role_id_ = null
		let RobotDic_ = []
		let NameDic_ = []
		let shieldList_ = []
		let privateChatTabList_ = []
		let trumpetItem_ = null
		let chuanwenItem_: ChuanwenItem = null
		let chuanwenItem2_
		let gonggao_chuanwenItem_ = null
		let spec_dic_ = { is_boss: { list: null, count: 2 }, is_depot: { list: null, count: 3 }, is_market: { list: null, count: 5 } }
		let worldKufuActivityCFG_ = {
			"137@0@1": { type: 137, subtype: 0, ac_sub: 1, name: "勾玉擂台" },
			"621@0@1": { type: 621, subtype: 0, ac_sub: 1, name: "最强王者" }
		}
		//////////////////////////////////////////////////////////////////////////////
		this.WelcomeChat = () => {
			let newChat = {}
			// [ts2lua]newChat下标访问可能不正确
			newChat["channel"] = local_CHAT_TYPE.SYSTEM
			// [ts2lua]newChat下标访问可能不正确
			newChat["msg"] = "欢迎您进入神奈之里，祝您游戏愉快！"
			// [ts2lua]newChat下标访问可能不正确
			newChat["time"] = local_TimeUtil.getServerTime()
			let chatList = this.getChannelChat(local_CHAT_TYPE.SYSTEM)
			if (!(chatList.length > 0)) {
				table.insert(chatList, newChat)
			}
			// [ts2lua]this.channelChatDic下标访问可能不正确
			this.channelChatDic[local_CHAT_TYPE.SYSTEM] = chatList
			this.Fire(local_ChatModelEvent.CHAT_MSG_CHANGE, local_CHAT_TYPE.SYSTEM, newChat)
		}

		this.showChuanwen = (chuanwen?) => {
			// if (ChuanwenItem.is_playing ) {
			// 	table.insert(this.chuanwen_wait_list, chuanwen)
			// 	return
			// }

			if (chuanwen.type == this.ChuanWenType.ZHENXI) {
				if (!gonggao_chuanwenItem_) {
					let layer = LayerManager.GetInstance().GetUILayer(Enum_UILayer.Top)
					gonggao_chuanwenItem_ = new ChuanwenSpecItem(layer)
					gonggao_chuanwenItem_.Load()
				}
				gonggao_chuanwenItem_.AppendMessage(chuanwen.txt)
			} else if (chuanwen.type == this.ChuanWenType.PINDAO) {
				if (!chuanwenItem2_) {
					let layer = LayerManager.GetInstance().GetUILayer(Enum_UILayer.Top)
					chuanwenItem2_ = new window["ChuanwenItem2"](layer)
					chuanwenItem2_.Load()
				}
				chuanwenItem2_.AppendMessage(chuanwen.txt)
			}
			else {
				if (!chuanwenItem_) {
					let layer = LayerManager.GetInstance().GetUILayer(Enum_UILayer.Top)
					chuanwenItem_ = new ChuanwenItem(layer)
					chuanwenItem_.Load()
				}
				chuanwenItem_.AppendMessage(chuanwen.txt)
			}
		}

		////
		this.GuildChat = (content?) => {
			let newChat = {}
			// [ts2lua]newChat下标访问可能不正确
			newChat["channel"] = local_CHAT_TYPE.GUILD
			// [ts2lua]newChat下标访问可能不正确
			newChat["msg"] = content
			// [ts2lua]newChat下标访问可能不正确
			newChat["chuanwen"] = true
			// [ts2lua]newChat下标访问可能不正确
			newChat["time"] = local_TimeUtil.getServerTime()
			let chatList = this.getChannelChat(local_CHAT_TYPE.GUILD)
			table.insert(chatList, newChat)
			// [ts2lua]this.channelChatDic下标访问可能不正确
			this.channelChatDic[local_CHAT_TYPE.GUILD] = chatList
			this.Fire(local_ChatModelEvent.CHAT_MSG_CHANGE, local_CHAT_TYPE.GUILD, newChat)
		}

		//////////////////////////////////////////////////////////////////////////////////////////////
		this.ClearRoleChatData = (role_id?) => {
			let has_role = false
			for (let key in this.channelChatDic) {

				if (Number(key) == local_CHAT_TYPE.PRIVATE_CHAT) {

				} else {
					// let clist = this.channelChatDic[key]
					// let i = 0
					// do {
					// 	if (role_id == clist[i].player_id ) {
					// 		has_role = true
					// 		clist.splice(i, 1)
					// 		i=i-1
					// 	}
					// 	i=i+1
					// } while ((i < clist.length)
					//)
					let clist = this.channelChatDic[key]

					for (let i = clist.length - 1; i >= 0; i -= 1) {
						if (role_id == clist[i].player_id) {
							has_role = true
							table.remove(clist, i)
						}
					}
				}
			}
			if (has_role) {
				this.Fire(local_ChatModelEvent.CLEAR_ROLE_DATA, role_id)
			}
			let cdic = this.getChannelChat(local_CHAT_TYPE.PRIVATE_CHAT)
			if (cdic[String(role_id)]) {
				cdic[String(role_id)] = null
				this.Fire(local_ChatModelEvent.CLEAR_ROLE_PRIVATE, role_id)
			}
		}

		this.addPlayerShield = (player_id?) => {
			// if (shieldList_.find(player_id) == -1 ) {
			if (table.find(shieldList_, player_id) == -1) {
				table.insert(shieldList_, player_id)
				local_Message.show("屏蔽玩家消息成功，有限期仅在此次登录期间")
			}
		}
		this.delPlayerShield = (player_id?) => {
			// let index = shieldList_.find(player_id)
			let index = table.find(shieldList_, player_id)
			if (index != -1) {
				shieldList_.splice(index, 1)
				// table.remove(shieldList_, 1)
				local_Message.show("取消屏蔽")
			}
		}

		this.checkPlayerShield = (player_id?) => {
			// return shieldList_.find(player_id) != -1
			return table.find(shieldList_, player_id) != -1
		}

		this.addPrivateChatTab = (player_vo?, newChat?) => {
			if (newChat == null) {
				newChat = false
			}
			let a = this.checkPrivateChatTab(player_vo)
			// if (this.checkPrivateChatTab(player_vo)) {//私聊界面
			// 	// if (newChat) {//
			// 	// 	let index = this.checkPrivateChatTabIndex(player_vo)
			// 	// 	if (index != null) {
			// 	// 		table.remove(privateChatTabList_, index)
			// 	// 		// table.insert(privateChatTabList_, 0, player_vo)
			// 	// 		privateChatTabList_.splice(0,0,player_vo)
			// 	// 	}
			// 	// } else {
			// 	// 	let index = this.checkPrivateChatTabIndex(player_vo)
			// 	// 	if (index != null) {
			// 	// 		table.remove(privateChatTabList_, index)
			// 	// 		// table.insert(privateChatTabList_, 0, player_vo)
			// 	// 		privateChatTabList_.splice(0,0,player_vo)
			// 	// 	}
			// 	// }
			// } else {//私聊界面重新打开时
			// 	// if (privateChatTabList_.length >= 1 && newChat) {
			// 	// 	// table.remove(privateChatTabList_, 0)
			// 	// 	// table.insert(privateChatTabList_, 0, player_vo)
			// 	// 	privateChatTabList_.splice(0,0,player_vo)

			// 	// } else {
			// 	// 	// table.insert(privateChatTabList_, player_vo)
			// 	// 	privateChatTabList_.splice(0,0,player_vo)
			// 	// }
			// 	// table.insert(privateChatTabList_, player_vo)
			// 	privateChatTabList_.push(player_vo)
			// }
			if (newChat) {//私聊界面打开状态
				let index = this.checkPrivateChatTabIndex(player_vo)
				if (index != null) {

				} else {
					privateChatTabList_.push(player_vo)
				}
			} else {//私聊界面重新打开时
				let index = this.checkPrivateChatTabIndex(player_vo)
				if (index != null) {
					table.remove(privateChatTabList_, index)
					privateChatTabList_.splice(0, 0, player_vo)
				} else {
					privateChatTabList_.splice(0, 0, player_vo)
				}
			}
		}

		this.checkPrivateChatTab = (player_vo?) => {
			let flag = false
			for (let key in privateChatTabList_) {

				// [ts2lua]privateChatTabList_下标访问可能不正确
				let vo = privateChatTabList_[key]
				if (vo.role_id == player_vo.role_id) {
					return true
				}
			}
			return flag
		}

		this.checkPrivateChatTabIndex = (player_vo?) => {
			let index = 0
			for (let key in privateChatTabList_) {

				// [ts2lua]privateChatTabList_下标访问可能不正确
				let vo = privateChatTabList_[key]
				if (vo.role_id == player_vo.role_id) {
					return index
				}
				index = index + 1
			}
		}

		this.delAllPrivateChatTab = () => {
			privateChatTabList_ = []
		}

		this.delNoMsgPlayer = () => {
			let obj = this.getChannelChat(local_CHAT_TYPE.PRIVATE_CHAT)
			let i = privateChatTabList_.length - 1
			do {
				let player = privateChatTabList_[i]
				let sendId = player.role_id
				// [ts2lua]obj下标访问可能不正确
				// [ts2lua]obj下标访问可能不正确
				if (!(obj[sendId] && obj[sendId][0])) {
					table.remove(privateChatTabList_, i)
				}
				i = i - 1
			} while ((i >= 0)
			)
		}

		this.PrivateChatTabList = () => {
			return privateChatTabList_
		}

		this.timeFormat = (second?) => {
			let date = new Date(second * 1000)
			// [ts2lua]lua中0和空字符串也是true，此处date:getMonth() + 1 < 10需要确认
			let M = (date.getMonth() + 1 < 10 && ('0' + (date.getMonth() + 1)) || (date.getMonth() + 1)) + (' - ')
			// [ts2lua]lua中0和空字符串也是true，此处date:getDate() < 10需要确认
			let D = (date.getDate() < 10 && ('0' + date.getDate()) || (date.getDate())) + ' '
			// [ts2lua]lua中0和空字符串也是true，此处date:getHours() < 10需要确认
			let h = (date.getHours() < 10 && ('0' + date.getHours()) || (date.getHours())) + ':'
			// [ts2lua]lua中0和空字符串也是true，此处date:getMinutes() < 10需要确认
			let m = (date.getMinutes() < 10 && ('0' + date.getMinutes()) || (date.getMinutes())) + ':'
			// [ts2lua]lua中0和空字符串也是true，此处date:getSeconds() < 10需要确认
			let s = (date.getSeconds() < 10 && ('0' + date.getSeconds()) || (date.getSeconds()))
			return M + D + h + m + s
		}

		this.trumpetName = (trumpet_type?) => {
			let str = ""
			if (local_TRUMPET_TYPE.WORLD == trumpet_type) {
				str = "世界频道"
			} else if (local_TRUMPET_TYPE.SMALL_KUAFU == trumpet_type) {
				str = "跨服频道"
			} else if (local_TRUMPET_TYPE.KUAFU == trumpet_type) {
				str = "活动频道"
			}
			return str
		}

		this.trumpetColor = (trumpet_type?) => {
			let color = local_ColorUtil.GetColorLight(local_ColorType.BLUE)
			if (trumpet_type == local_TRUMPET_TYPE.SMALL_KUAFU) {
				color = local_ColorUtil.GetColorLight(local_ColorType.ORANGE)
			} else if (trumpet_type == local_TRUMPET_TYPE.KUAFU) {
				color = local_ColorUtil.GetColorLight(local_ColorType.PINK)
			}
			return color
		}

		this.trumpetImage = (trumpet_type?) => {
			let src = "mainUI_json.mainUI_chat_2_png"
			if (trumpet_type == local_TRUMPET_TYPE.SMALL_KUAFU) {
				src = "mainUI_json.mainUI_chat_4_png"
			} else if (trumpet_type == local_TRUMPET_TYPE.KUAFU) {
				src = "mainUI_json.mainUI_chat_5_png"
			}
			return src
		}

		this.channelImage = (channel?) => {
			let title = ""
			let src = ""
			let color = ""
			if (channel == local_CHAT_TYPE.WORLD) {
				title = "世界"
				src = "mainUI_chat_2"
				// color = ColorUtil.GetColorLight(local_ColorType.BLUE)
				color = "#5E73F3"
			} else if (channel == local_CHAT_TYPE.SMALL_KUAFU) {
				title = "跨服"
				src = "mainUI_chat_4"
				// color = ColorUtil.GetColorLight(local_ColorType.ORANGE)
				color = "#b647e1"
			} else if (channel == local_CHAT_TYPE.WORLD_KUAFU) {
				title = "活动"
				src = "mainUI_chat_5"
				// color = ColorUtil.GetColorLight(local_ColorType.PINK)
				color = "#706ECA"
			} else if (channel == local_CHAT_TYPE.TEAM) {
				title = "队伍"
				src = "mainUI_chat_9"
				// color = ColorUtil.GetColorLight(local_ColorType.GREEN)
				color = "#b3ff48"
			} else if (channel == local_CHAT_TYPE.GUILD) {
				title = "结社"
				src = "mainUI_chat_3"
				// color = ColorUtil.GetColorLight(local_ColorType.PURPLE)
				color = "#D85051"
			} else if (channel == local_CHAT_TYPE.CAMP) {
				title = "阵营"
				src = "mainUI_chat_6"
				color = "#27B24C"
			} else if (channel == local_CHAT_TYPE.SEA) {
				title = "海域"
				src = "mainUI_chat_7"
				color = "#b8741a"
			}
			return [title, src, color]
		}

		this.showTrumpet = (chat?) => {
			if (this.showChat && local_TimeUtil.getServerTime() - this.showChat.time < trumpetWait_) {
				table.insert(this.trumpet_Wait_List, chat)
				return
			}
			this.showChat = chat
			if (!trumpetItem_) {
				let layer = LayerManager.GetInstance().GetUILayer(Enum_UILayer.Top)
				trumpetItem_ = new TrumpetItem(layer)
				trumpetItem_.Load()
			}
			trumpetItem_.setData(chat)
		}


		this.CampOpen = () => {
			//KfHolyArea_model 还没有 目前先返回true
			let data = KfHolyArea_model.map_data
			let san_type = data && data.san_type
			return san_type && san_type >= 4
			return true
		}

		this.checkChanneOpen = (info?) => {
			let swi = {
				[CHAT_TYPE.SMALL_KUAFU]: () => {
					return this.kuaFuOpenData()
				},
				[CHAT_TYPE.CAMP]: () => {
					return this.CampOpen()
				},
				[CHAT_TYPE.SEA]: () => {
					return SeaHegemonyModel.GetInstance().hasJoinSea
				},
				[CHAT_TYPE.WORLD_KUAFU]: () => {
					return (DiamondFightModel.GetInstance().stage_info.war_state == 1 || (Kf1vnModel.GetInstance().stage_info.stage >= 2 && Kf1vnModel.GetInstance().stage_info.stage < 6))
				},
				[CHAT_TYPE.GUILD]: () => {
					return RoleManager.GetInstance().GetMainRoleVo().guild_id > 0
				},
				[CHAT_TYPE.TEAM]: () => {
					return RoleManager.GetInstance().GetMainRoleVo().team_id > 0
				},
				["default"]: () => {
					return true
				}
			}
			let casef = swi[info.channel]
			if (!casef) { casef = swi["default"] }
			if (casef) {
				return casef()
			}
		}


		///////////////////////////////////////////////////////////////////////////////////////////////
		this.InitConfig = () => {
			config_ = []
			robot_content_config_ = Config.PRELOAD_SERVER_CONFIG.config_robot_chat_content
			robot_name_config_ = Config.PRELOAD_SERVER_CONFIG.config_occupy_name
		}

		this.setChannelChatData = (data?, chuanwen_cfg?) => {


			//百鬼发送信息到跨服，特殊处理。发送时使用百鬼夜行频道，但需要展示在跨服频道
			if (data.channel == CHAT_TYPE.GHOST_WALK) {
				data.channel = CHAT_TYPE.SMALL_KUAFU
			}

			//屏蔽公共频道信息
			if (this.shield_channel_setting && table.find(ChatModel.SHIELD_CHANNEL, data.channel) != -1) {
				return
			}

			if (data.result == 2) {
				local_Message.show("无此物品请重新输入")
				return
			}
			if (this.checkPlayerShield(data.player_id)) {
				return
			}
			if (data.result == 1) {
				this.cleanSendGoodsData()
			}
			let channel = data.channel
			// [ts2lua]this.channelChatDic下标访问可能不正确
			let channelArr = this.channelChatDic[channel] || []
			let is_del = false
			let is_spec = false
			for (let key in spec_dic_) {

				[is_spec, is_del] = this.specManage(data, channelArr, key)
				if (is_spec) {
					break
				}
			}
			let chuanwen_sort_func = (a?, b?) => {
				return a.time < b.time
			}
			let PushData = () => {
				if (channelArr.length > this.chatMax) {
					let sdata = table.shift(channelArr)
					for (let key in spec_dic_) {

						if (sdata[key]) {
							let sdata = spec_dic_[key]
							sdata.list = sdata.list || {}
							table.shift(sdata.list)
							break
						}
					}
				}
				table.insert(channelArr, data)
			}

			let main_role_id = RoleManager.GetInstance().GetMainRoleVo().role_id;
			if(data.player_id == main_role_id){
				data["read"] = true
			}

			//更新有数量限制的公告数据
			if (chuanwen_cfg && chuanwen_cfg.limit_line && 0 != chuanwen_cfg.limit_line) {
				let limit_list = []
				for (let i = 0; i < channelArr.length; i++) {
					var v = channelArr[i]
					if (v.module_id == data.module_id && v.id == data.id) {
						table.insert(limit_list, v)
					}
				}
				if (limit_list.length >= chuanwen_cfg.limit_line) {
					// table.sort(limit_list, chuanwen_sort_func)
					let temp = limit_list[0]
					temp["msg"] = data.msg
					temp["time"] = data.time
					temp["tip"] = data.tip
					temp["channel"] = data.channel
					temp["chuanwen"] = data.chuanwen
					table.sort(channelArr, chuanwen_sort_func)
					//使用原数据
					data = temp
				} else {
					PushData()
				}
			} else {
				PushData()
			}
			this.channelChatDic[channel] = channelArr
			this.Fire(local_ChatModelEvent.CHAT_CHANNEL_MSG_UPDATE, data.channel, data, is_del)
			// if (channel != local_CHAT_TYPE.GUILD_QUIZ && channel != local_CHAT_TYPE.BARRAGE ) {
			let level = RoleManager.GetInstance().GetMainRoleVo().level
			if (channel == local_CHAT_TYPE.GUILD_QUIZ || channel == local_CHAT_TYPE.BARRAGE ||
				(channel == local_CHAT_TYPE.SMALL_KUAFU && level < this.ViewClassCFG[CHAT_TYPE.SMALL_KUAFU].openLevel)) {
			} else {
				this.Fire(local_ChatModelEvent.CHAT_MSG_CHANGE, data.channel, data, is_del)
			}
		}

		this.setTrumpet = (data?) => {
			if (data.result == 1) {
				this.cleanSendGoodsData()
			}
			let channel = local_CHAT_TYPE.WORLD
			if (data.horn_type == local_TRUMPET_TYPE.WORLD) {
				channel = local_CHAT_TYPE.WORLD
			} else if (data.horn_type == local_TRUMPET_TYPE.SMALL_KUAFU) {
				channel = local_CHAT_TYPE.SMALL_KUAFU
			} else if (data.horn_type == local_TRUMPET_TYPE.KUAFU) {
				channel = local_CHAT_TYPE.WORLD_KUAFU
			}
			// [ts2lua]this.channelChatDic下标访问可能不正确
			let channelArr = this.channelChatDic[channel] || []
			if (channelArr.length > this.chatMax) {
				let sdata = table.shift(channelArr)
				for (let key in spec_dic_) {

					// [ts2lua]sdata下标访问可能不正确
					if (sdata[key]) {
						// [ts2lua]spec_dic_下标访问可能不正确
						let sdata = spec_dic_[key]
						sdata.list = sdata.list || {}
						table.shift(sdata.list)
						break
					}
				}
			}
			// [ts2lua]data下标访问可能不正确
			data["is_trumpet"] = true
			// [ts2lua]data下标访问可能不正确
			data["time"] = local_TimeUtil.getServerTime()
			table.insert(channelArr, data)
			// [ts2lua]this.channelChatDic下标访问可能不正确
			this.channelChatDic[channel] = channelArr
			this.Fire(local_ChatModelEvent.CHAT_CHANNEL_MSG_UPDATE, channel, data)
			this.Fire(local_ChatModelEvent.CHAT_MSG_CHANGE, data.channel, data)
			this.showTrumpet(data)

		}

		this.specManage = (data?, channelArr?, key?) => {
			let is_del = false
			let is_spec = false
			// [ts2lua]data下标访问可能不正确
			if (data[key]) {
				// [ts2lua]spec_dic_下标访问可能不正确
				let sdata = spec_dic_[key]
				sdata.list = sdata.list || []
				if (sdata.list.length >= sdata.count) {
					let kdata = table.shift(sdata.list)
					let has_data = false
					let i = 0
					do {
						// [ts2lua]channelArr[i]下标访问可能不正确
						if (channelArr[i] && channelArr[i][key]) {
							has_data = true
							table.remove(channelArr, i)
							//channelArr:splice(i, 1)
							is_del = true
							break
						}
						i = i + 1
					} while ((i < channelArr.length))
					if (!has_data) {
						sdata.list = []
					}
				}
				table.insert(sdata.list, data)
				is_spec = true
			}
			return [is_spec, is_del]
		}

		this.getChannelChat = (channel?) => {
			if (channel == local_CHAT_TYPE.PRIVATE_CHAT) {
				// [ts2lua]this.channelChatDic下标访问可能不正确
				return this.channelChatDic[channel] || []
			} else {
				// [ts2lua]this.channelChatDic下标访问可能不正确
				return this.channelChatDic[channel] || []
			}
		}

		this.delFriendChannelChat = (sendId?) => {
			// [ts2lua]this.channelChatDic下标访问可能不正确
			let dic = this.channelChatDic[local_CHAT_TYPE.PRIVATE_CHAT]
			// [ts2lua]dic下标访问可能不正确
			if (dic && dic[sendId]) {
				// [ts2lua]dic下标访问可能不正确
				dic[sendId] = null
				this.Fire(ChatModelEvent.REMOVE_PRIVATE_CHAT, sendId)
			}
		}

		this.setChatData = (data?, showTips?) => {
			if (showTips == null) {
				showTips = true
			}
			let privateChatDic = null
			let myId = role_mgr.GetMainRoleId()
			let channel = data.channel
			let chatNum = 0
			let addChatNum = 1
			let channelArr = []
			// [ts2lua]this.channelChatDic下标访问可能不正确
			privateChatDic = this.channelChatDic[channel]
			let targetId = data.player_list[0].player_id
			// [ts2lua]lua中0和空字符串也是true，此处targetId == myId || ! showTips需要确认
			addChatNum = addChatNum - ((targetId == myId || !showTips) && 1 || 0)//((targetId == myId || ! showTips) and 1 || 0)
			if (targetId == myId) {
				targetId = data.player_list[1].player_id
			}
			if (!privateChatDic) {
				privateChatDic = []
			}
			// [ts2lua]privateChatDic下标访问可能不正确
			if (privateChatDic && privateChatDic[targetId]) {
				// [ts2lua]privateChatDic下标访问可能不正确
				channelArr = privateChatDic[targetId][0]
				// [ts2lua]privateChatDic下标访问可能不正确
				chatNum = privateChatDic[targetId][1]
			}
			if (channelArr.length > this.privateChat) {
				table.remove(channelArr, 1)
			}
			table.insert(channelArr, data)
			chatNum = chatNum + addChatNum
			// [ts2lua]privateChatDic下标访问可能不正确
			privateChatDic[targetId] = [channelArr, chatNum]
			// [ts2lua]this.channelChatDic下标访问可能不正确
			this.channelChatDic[channel] = privateChatDic
			if (showTips) {
				this.Fire(local_ChatModelEvent.CHAT_MSG_UPDATE, targetId, data)
			}
		}

		this.reSetPrivateNum = (targetId?) => {
			let obj = this.getChannelChat(local_CHAT_TYPE.PRIVATE_CHAT)
			let sendId = targetId
			// [ts2lua]obj下标访问可能不正确
			if (obj[sendId]) {
				// [ts2lua]obj下标访问可能不正确
				obj[sendId][1] = 0
				this.Fire(local_ChatModelEvent.CHAT_MSG_NUM_UPDATE, targetId)
			}
		}

		this.chatViewIndex = (channel?) => {
			let channelList = this.chatTabList()
			let index = 0
			let find = false
			for (let key in channelList) {

				// [ts2lua]channelList下标访问可能不正确
				let info = channelList[key]
				if (info.channel == channel) {
					find = true
					break
				}
				index = index + 1
			}
			if (!find) {
				index = 0
			}
			return index
		}

		this.getChatFace = (msg?) => {
			msg = msg.toString()
			let faceList = []
			let titlebgList = []
			let temp = /mainUI_chat_[0-9]/gi
			titlebgList = msg.match(temp)
			// [ts2lua]tslua无法自动转换正则表达式，请手动处理。
			let re = /<f_[0-9]+>/gi
			faceList = msg.match(re)
			return [faceList, titlebgList]
		}

		this.replaceChatFace = (msg1?, imgwidth?, fontsize?, maxwidth?) => {
			//保留原字符串
			msg1 = msg1 && msg1.replace("α", "").replace("β", "")
			let msg = msg1
			let faceList = []
			let faceId = 0
			let htmlList = []
			let htmlId = 0
			let lasthtmlId = 0
			let msglen = 0
			// msg = msg.replace(/&/gi, "*");
			// [ts2lua]tslua无法自动转换正则表达式，请手动处理。
			let re = /<f_[0-9]+>/gi
			//替代表情标识符
			msg = msg.replace(re, "α")
			faceList = msg1.match(re)
			//去掉html标签
			let re2 = /<[^>]+>/g
			htmlList = msg.match(re2)
			msg = msg.replace(re2, "β")
			//处理特殊字符<
			msg = msg.replace("<", "&lt;")
			let newmsg = ""
			for (let i = 0; i < msg.length; i++) {
				if (msg[i] == "α" && faceList && faceList.length > 0) {
					msglen += imgwidth
					if (msglen > maxwidth && newmsg.indexOf("<br/>") == -1) {
						//加入换行符之前 看看之前的html标签是否已经匹配完
						if (lasthtmlId == 0 || lasthtmlId == htmlList.length - 1) {//如果还没有加入html标签或者已经加完了标签 
							newmsg += "<br/>"
							newmsg += faceList[faceId]
						} else {
							newmsg = this.matchHtml(newmsg, faceList[faceId], htmlList, lasthtmlId, true)
						}
					} else {
						newmsg += faceList[faceId]
					}
					faceId++
				} else if (msg[i] == "β" && htmlList && htmlList.length > 0) {
					if (htmlList[htmlId].indexOf("<a") != -1) {
						htmlList[htmlId] = htmlList[htmlId].replace("<a", "<a href='")
						htmlList[htmlId] = htmlList[htmlId].replace(">", "'>")
					}
					if (htmlList[htmlId].indexOf("font") != -1 || htmlList[htmlId].indexOf("<a ") != -1 || htmlList[htmlId].indexOf("</a>") != -1) {
						//处理特殊字符<
					} else {
						htmlList[htmlId] = htmlList[htmlId].replace("<", "&lt;")
					}
					newmsg += htmlList[htmlId]
					if (htmlId < htmlList.length - 1) {
						lasthtmlId = htmlId
						htmlId++
					} else {
						lasthtmlId = htmlId
					}
				} else {
					if (ChatModel.IsChinese(msg[i]) || ChatModel.IsChieseSymbol(msg[i])) {
						msglen += fontsize
					} else {
						msglen += fontsize / 2
					}
					if (msglen > maxwidth && newmsg.indexOf("<br/>") == -1) {
						if (lasthtmlId == 0 || lasthtmlId == htmlList.length - 1) {//如果还没有加入html标签或者已经加完了标签 
							newmsg += "<br/>"
							newmsg += msg[i]
						} else {
							newmsg = this.matchHtml(newmsg, msg[i], htmlList, lasthtmlId, false)
						}
					} else {
						newmsg += msg[i]
					}
				}
			}
			return newmsg
		}

		this.delHtmlTag = (str) => {
			return str.replace(/<[^>]+>/g, "");
		}

		this.matchHtml = (newmsg, char, htmlList, lasthtmlId, isface) => {
			//匹配HTML符号
			let stack = new Array<string>();
			for (let i = 0; i <= lasthtmlId; i++) {
				if (htmlList[i].indexOf("/") == -1) {
					stack.push(htmlList[i])
				} else {
					stack.pop()
				}
			}
			//匹配之前的HTML的标签
			for (let i = stack.length - 1; i >= 0; i--) {
				if (stack[i].indexOf("<a") != -1) {
					newmsg += "</a>"
				}
				if (stack[i].indexOf("<font") != -1) {
					newmsg += "</font>"
				}
			}
			newmsg += "<br/>"
			if (isface) {
				newmsg += char
			}
			//匹配之后的HTML标签
			for (let j = 0; j < stack.length; j++) {
				newmsg += stack[j]
			}
			if (!isface) {
				newmsg += char
			}
			return newmsg
		}



		this.getLength = (str?) => {
			let length = 0
			// [ts2lua]tslua无法自动转换正则表达式，请手动处理。
			// if ((/[a-z0-9~'!@#￥$%^&*()-+_=.:\[\]\<\>]/ig):test(str) ) {
			//   // [ts2lua]tslua无法自动转换正则表达式，请手动处理。
			//   // [ts2lua]修改数组长度需要手动处理。
			//   length = str.match(/[a-z0-9~'!@#￥$%^&*()-+_=.:\[\]\<\>]/ig).length
			// }
			// [ts2lua]tslua无法自动转换正则表达式，请手动处理。
			// if ((/[\s]/ig):test(str) ) {
			//   // [ts2lua]tslua无法自动转换正则表达式，请手动处理。
			//   let blank_length = str.length.match(/[\s]/ig)
			//   if (local_Util.GetDeviceOS() != local_DEVICE_OS.WINDOWS_PC ) {
			//     blank_length = Math.max(blank_length * 2 - 2)
			//   }
			//   length = length + blank_length
			// }
			return length
		}

		this.getBagGoodsMsg = (msg?) => {
			//let BagGoodsList = []
			let str = ""
			// [ts2lua]tslua无法自动转换正则表达式，请手动处理。
			// BagGoodsList = msg.match("/(\[.*?\])/gi")
			// BagGoodsList = msg.match("(%[.-%])")
			let BagGoodsList = []
			let gmatch_func = msg.match(/(\[.*?\])/gi)
			for (let k in gmatch_func) {
				table.insert(BagGoodsList, gmatch_func[k])
			}
			return BagGoodsList
		}

		this.getGoodsInfo = (str?) => {
			let list = []
			// [ts2lua]tslua无法自动转换正则表达式，请手动处理。
			// str = str.gsub("/\{*\[*\]*\}*/gi", "")
			// str = str.gsub("{*%[*%]*}*", "")
			str = str.replace(/\{*\[*\]*\}*/gi, "");
			if (str) {
				list = Split(str, ",")
			}
			return list
		}

		this.matchSendGoods = (goods?, argsList?) => {
			let match = false
			// [ts2lua]tslua无法自动转换正则表达式，请手动处理。
			let _goods_id = goods.replace("[", "")
			_goods_id = _goods_id.replace("]", "")
			// let _goods_id = goods.match("%[(%d*)%]")
			// let index = argsList.find(_goods_id)
			let index = table.find(argsList, _goods_id)
			let type_id = null
			let goods_id = null
			let args = null
			if (index != -1) {
				match = true
				// [ts2lua]argsList下标访问可能不正确
				goods_id = argsList[index]
				// [ts2lua]argsList下标访问可能不正确
				type_id = argsList[index - 1]
				// [ts2lua]argsList下标访问可能不正确
				args = argsList[index + 1]
			}
			return [match, type_id, goods_id, args]
			// return {match, type_id, goods_id, args}
		}

		this.chatToolBagData = (type?) => {
			let list = []
			if (type == local_CHAT_TOOL_TYPE.BAG) {
				for (let key in goods_model.bag_goods_list) {
					// [ts2lua]goods_model.bag_goods_list下标访问可能不正确
					let goods = goods_model.bag_goods_list[key]
					if ((goods.type_id >= 36210001 && goods.type_id <= 36210007) || goods.type_id == 36210008) {

					} else {
						if (goods && goods.type != 10) {
							table.insert(list, goods)
						}
					}
				}
			} else if (type == local_CHAT_TOOL_TYPE.GOD) {
				for (let key in goods_model.bag_goods_list) {
					let goods = goods_model.bag_goods_list[key]
					if (goods && goods.type == 10) {
						table.insert(list, goods)
					}
				}
			} else if (type == local_CHAT_TOOL_TYPE.SEAL) {
				list = list.concat(goods_model.holy_seal_bag_goods_list)
			} else if (type == local_CHAT_TOOL_TYPE.GODBEFALL) {
				list = list.concat(goods_model.god_bag_list)
			} else if (type == local_CHAT_TOOL_TYPE.REVELATION) {
				list = list.concat(goods_model.revelation_bag_list)
			} else if (type == local_CHAT_TOOL_TYPE.GODCOURT) {
				list = list.concat(goods_model.godCourtBagList)
			} else if (type == local_CHAT_TOOL_TYPE.LONGLANGUAGE) {
				list = list.concat(goods_model.longlang_bag_list)
			}
			return list
		}

		this.chatBagData = () => {
			let EquipList = equip_model.GetWearEquipDynamics()
			return EquipList
		}

		this.chatSealBagData = () => {
			let list = []
			let wear_holy_seal_list = goods_model.wear_holy_seal_list
			for (let key in wear_holy_seal_list) {

				// [ts2lua]wear_holy_seal_list下标访问可能不正确
				let equip = wear_holy_seal_list[key]
				table.insert(list, equip)
			}
			return list
		}

		this.chatGodBefallWearData = () => {
			let list = []
			let dic = goods_model.wear_god_dic
			for (let key in dic) {

				// [ts2lua]dic下标访问可能不正确
				let equip = dic[key]
				table.insert(list, equip)
			}
			return list
		}

		this.chatRevelationBagData = () => {
			let list = []
			let revelationList = goods_model.revelation_equip_list
			for (let _tmpi in revelationList) {
				var vo = revelationList[_tmpi]
				if (vo) {
					table.insert(list, vo)
				}
			}
			return list
		}

		this.chatGodCourtBagData = () => {
			let list = []
			let godCourList = goods_model.godCourtList
			if (godCourList) {
				for (let _tmpi in godCourList) {
					var vo = godCourList[_tmpi]
					if (vo) {
						for (let _tmpi in vo) {
							var Vo1 = vo[_tmpi]
							table.insert(list, Vo1)
						}
					}
				}
			}
			return list
		}

		this.chatLongLanguageBagData = () => {
			let list = []
			let longlang_equip_list = goods_model.longlang_equip_list
			if (longlang_equip_list) {
				for (let _tmpi in longlang_equip_list) {
					var vo = longlang_equip_list[_tmpi]
					if (vo) {
						table.insert(list, vo)
					}
				}
			}
			return list
		}

		this.setSendGoodsData = (data?, repetition?) => {
			if (repetition && _SendGoodsData_[data.goods_name]) {
				_SendGoodsData_[data.goods_name] = _SendGoodsData_[data.goods_name] + ",{goods," + data.type_id + "," + data.goods_id + "}"
			} else {
				_SendGoodsData_[data.goods_name] = "{goods," + data.type_id + "," + data.goods_id + "}"
			}
		}

		this.sendGoodsMesg = (msg?) => {
			let list = []
			let goodsId_list = []
			let sendMsg: string = msg
			let goodMsgList = []
			let gmatch_func = msg.match(/\[.*?\]/ig)
			for (let k in gmatch_func) {
				table.insert(goodMsgList, gmatch_func[k])
			}
			for (let key in goodMsgList) {

				let info = goodMsgList[key]
				// let name = info.match("%[(.-)%]")
				let name = info.replace(/\[(.*?)\]/ig, "$1");
				let data = _SendGoodsData_[name]

				//////////////////////////////////////////
				//道具名字带有()会有问题，将()替换成%(%)
				let name2 = name.match(/\[(.*?)\]/ig)
				if (name2) {
					name2 = "%(" + name2 + "%)"
					let index1 = name.find("%(")
					let index2 = name.find("%)")
					// let name_part1 = string.sub(name, 1, index1 - 1)
					// let name_part2 = string.sub(name, index2 + 1, name.len())
					let name_part1 = name.substring(0, index1 - 2)
					let name_part2 = name.substring(index2, name.len() - 1)
					name = name_part1 + name2 + name_part2
				}
				//////////////////////////////////////////-

				if (data) {
					// if (table.find(list, data) != -1) {

					// } else {
					// }
					table.insert(list, data)
					let sp = Split(data, ",")
					let i = 0
					do {
						let index = i * 3 + 2
						let goods_id_str = sp[index]
						// let id = sp[index].gsub("[{}]", "")
						let id = sp[index].replace(/[\{\}]/ig, "")
						let goods_id = (goods_id_str != null && (Number(id)) || (0))
						//小心lua的[]匹配模式
						let info = "[" + name + "]"
						sendMsg = sendMsg.replace(info, "[" + goods_id + "]");
						// sendMsg.gsub(info, "[" + goods_id + "]", 1)
						let goods_vo = goods_model.GetGoodsVoByGoodsId(goods_id)
						if (goods_vo && goods_vo.type == 10) {
							if (table.find(goodsId_list, goods_id) == -1) {
								table.insert(goodsId_list, goods_id)
							}
						}
						i = i + 1
					} while ((i < sp.length / 3))

				}
			}
			return [list, goodsId_list, sendMsg]
		}

		// this.getSendGoodsData = ( goods_id?) => {
		// 	return _SendGoodsData_[goods_id]
		// }

		this.cleanSendGoodsData = () => {
			_SendGoodsData_ = []
		}

		this.setChatCache = (data?) => {
			// PrintTable(data.cache_list)
			if (data.cache_list.length > 0) {
				let list = []
				let conf = this.ViewClassCFG[data.cache_list[0].channel]
				let openDay = sever_time_model.GetOpenServerDay()
				if (conf && openDay < conf.openDay) {
					return
				}
				let i = data.cache_list.length - 1
				do {
					let info = data.cache_list[i]
					let player = info.player_list[0] || {}
					if (info.voice_id > 0) {
						info.iType = ChatModel.MSG_TYPE.VOICE
						player.iType = ChatModel.MSG_TYPE.VOICE
						player.length = info.voice_time
						player.voice_id = info.voice_id
					} else {
						info.iType = ChatModel.MSG_TYPE.TEXT
						player.iType = ChatModel.MSG_TYPE.TEXT
					}
					if (info.channel == local_CHAT_TYPE.PRIVATE_CHAT) {
						this.setChatData(info, info.is_read == 0)
					} else if (info.channel == local_CHAT_TYPE.GHOST_WALK) {
						//百鬼夜行  用百鬼夜行的频道发送的信息，会被展示到跨服频道
						player["channel"] = local_CHAT_TYPE.SMALL_KUAFU
						player["msg"] = info.msg
						player["args"] = info.args
						player["result"] = info.result
						player["time"] = info.time
						table.insert(list, player)
					} else {
						player["channel"] = info.channel
						player["msg"] = info.msg
						player["args"] = info.args
						player["result"] = info.result
						player["time"] = info.time
						table.insert(list, player)
					}
					//缓存聊天，默认已读
					player["read"] = true
					i = i - 1
				} while ((i >= 0))
				if (data.cache_list[0].channel != local_CHAT_TYPE.PRIVATE_CHAT) {
					this.channelChatDic[list[0].channel] = list
					// PrintTable(this.channelChatDic)
					this.Fire(local_ChatModelEvent.CHAT_CACHE_UPDATE)
				}
			}
		}

		this.changeToDark = (msg?) => {
			let re: RegExp = new RegExp(`${local_ColorUtil.GetColorLight(local_ColorType.GREEN)}`, `ig`);
			// let re = ColorUtil.GetColorLight(local_ColorType.GREEN)
			// msg = msg.gsub(re, ColorUtil.GetColorDark(local_ColorType.GREEN))
			msg = msg.replace(re, `${local_ColorUtil.GetColorDark(local_ColorType.GREEN)}`);
			re = new RegExp(`${local_ColorUtil.GetColorLight(local_ColorType.WHITE)}`, `ig`);
			// re = ColorUtil.GetColorLight(local_ColorType.WHITE)
			// msg = msg.gsub(re, ColorUtil.GetColorDark(local_ColorType.WHITE))
			msg = msg = msg.replace(re, `${local_ColorUtil.GetColorDark(local_ColorType.WHITE)}`);
			return msg
		}

		this.setKuafuData = (bool?) => {
			this._KuafuOpen = bool
		}

		this.disposeChtaGoods = (msg?, data?, role_id?, is_light?) => {
			let temp_msg = msg.toString()
			let _str = ""
			let faceList: Array<string>, titlebgList: Array<string>
			[faceList, titlebgList] = this.getChatFace(msg);
			if (faceList && faceList.length > 0) {
				for (let i: number = 0; i < faceList.length; i++) {
					let face: string = faceList[i];
					let faceId: string = face.replace(/<f_/gi, "");
					faceId = faceId.replace(/>/gi, "");
					if (Number(faceId) > ChatModel.GetInstance().faceMax() || Number(faceId < ChatModel.GetInstance()._faceMin)) {//不合法表情id
						_str = face.replace(/<f_/gi, "/\<f_")
						_str = _str.replace(/>/gi, "/\>")
						temp_msg = temp_msg.replace(face, _str)
					}
					// _str+=face

				}
				msg = temp_msg
			}
			let bagList = this.getBagGoodsMsg(msg)
			let contentHtml = msg
			// if (data.args.find("goods") != -1 || data.args.find("revelation_suit") != -1 ) {
			if (data.args.indexOf("goods") != -1 || data.args.indexOf("revelation_suit") != -1) {
				let goodsInfoList = this.getGoodsInfo(data.args)
				let bagGoods = ""
				let linkNum = 0
				let channel = data.channel
				let i = 0
				do {
					bagGoods = bagList[i]
					if (bagGoods) {
						let [match, type_id, goods_id, args] = this.matchSendGoods(bagGoods, goodsInfoList)
						args = args || ""
						let goods_vo = goods_model.GetGoodsBasicByTypeId(type_id)
						if (bagGoods && ((match && bagGoods.indexOf("[") != -1) && bagGoods.indexOf("]") != -1) && goods_vo) {
							let color = is_light && ColorUtil.GetColorLight(goods_vo.color) || ColorUtil.GetColorDark(goods_vo.color)
							// let nameStr = "[" + Trim(goods_vo.goods_name) + "]"
							// let htmlStr = "<a" + type_id + "," + goods_id + "," + role_id + "," + channel + "," + args + ">" + "<font color=" + color + ">" + nameStr + "</font>" + "</a>"
							// //lua中括号要加%
							// // let name = bagGoods.match("%[(.-)%]")
							// let name:string="[name]"
							// name = name.replace("%[", "")			//这里要去掉剩下的[], 否则正则会报错
							// name = name.replace("%]", "")
							// name = "%[" + name + "%]"
							// var replaceFunc =()=> {
							// 	contentHtml = contentHtml.gsub(name, htmlStr)
							// }
							// try {
							// 	replaceFunc;
							// }
							// catch (e) {
							// 	GameError.Instance.SendErrorToPHP(e + "=====" + type_id + (" + ") + goods_id + (" + ") + name);
							// 	return;
							// }
							// let state = xpcall(replaceFunc,(err?) => {
							//    GameError.Instance.SendErrorToPHP(err + "=====" + type_id + (" + ") + goods_id + (" + ") + name)
							// })
							let nameStr = `[${goods_vo.goods_name}]`;
							let htmlStr = `<font color=${local_ColorUtil.GetColorDark(goods_vo.color)}><a${type_id},${goods_id},${role_id},${channel},${args}>${nameStr}</a></font>`;
							contentHtml = contentHtml.replace(bagGoods, htmlStr);
							linkNum = linkNum + 1
						}
						i = i + 1
					}
				} while ((i < bagList.length))
			}
			return contentHtml
		}


		this.disposeChtaFace = (msg: string, img_width?, img_height?, fontsize?, maxwidth?, scale = 1) => {
			scale = scale || 1
			if (!img_width) {
				img_width = 70 * scale
			}
			if (!img_height) {
				img_height = 48 * scale
			}
			let _str = "";
			let faceList: Array<string>, titlebgList: Array<string>
			[faceList, titlebgList] = this.getChatFace(msg);
			let firest_line_face = ""
			let source_text = msg
			if ((faceList && faceList.length > 0) || titlebgList && titlebgList.length > 0) {
				if (titlebgList && titlebgList.length > 0) {
					_str += source_text
					_str = this.replaceChatFace(msg, img_width, fontsize, maxwidth)
					for (let i: number = 0; i < titlebgList.length; i++) {
						// bitmapNum++;
						let face: string = titlebgList[i];
						let replacestr = "<img src='resource/game/mainUI/texture/" + face + ".png' style='width:" + (41 * scale) + "px; height:" + (22 * scale) + "px'/>"
						_str = _str.replace(face, replacestr);
						firest_line_face = _str

					}
					if (firest_line_face == "") {
						firest_line_face += msg
					}
				}
				if (faceList && faceList.length > 0) {
					let is_have_title = (titlebgList && titlebgList.length > 0) ? true : false
					if (_str == "") {
						_str += source_text
						_str = this.replaceChatFace(msg, img_width, fontsize, maxwidth)
					}
					for (let i: number = 0; i < faceList.length; i++) {
						// bitmapNum++;
						let face: string = faceList[i];
						let faceId: string = face.replace(/<f_/gi, "");
						faceId = faceId.replace(/>/gi, "");
						// //获取表情
						// bitmap = bitmapList[i];
						if (Number(faceId) > this.faceMax() || Number(faceId < this._faceMin)) {//不合法表情id
							continue;
						}
						// style='width:130px;height:50px
						let replacestr = "<img src='resource/game/emoji/texture/" + faceId + ".png' style='width:" + img_width + "px; height:" + img_height + "px'/>"
						if (is_have_title) {
							firest_line_face = firest_line_face.replace(face, replacestr);
						} else {
							_str = _str.replace(face, replacestr);
							firest_line_face = _str
						}
					}
					if (firest_line_face == "") {
						firest_line_face += msg
					}
				}
			}
			else {
				msg = this.replaceChatFace(msg, img_width, fontsize, maxwidth)
				firest_line_face = msg;
			}
			return firest_line_face;
		}

		this.setChatInfoFormat = (msg?) => {
			let temp_msg = msg.toString()
			let _str = ""
			let faceList: Array<string>, titlebgList: Array<string>
			[faceList, titlebgList] = this.getChatFace(msg);
			if (faceList && faceList.length > 0) {
				for (let i: number = 0; i < faceList.length; i++) {
					let face: string = faceList[i];
					let faceId: string = face.replace(/<f_/gi, "");
					faceId = faceId.replace(/>/gi, "");
					if (Number(faceId) > ChatModel.GetInstance().faceMax() || Number(faceId < ChatModel.GetInstance()._faceMin)) {//不合法表情id
						_str = face.replace(/<f_/gi, "/\<f_")
						_str = _str.replace(/>/gi, "/\>")
						temp_msg = temp_msg.replace(face, _str)
					}
					// _str+=face

				}
				msg = temp_msg
			}
			return msg
		}

		// this.disposeChtaFace = (htmlMsg, msg, contentLabel: Laya.HTMLDivElement, contentGroup, bitmapList, facePoint = 2.5, fontPoint = 2, offsetY = 7) => {
		// 	let maxWidth=308
		// 	let _str = htmlMsg;
		// 	let faceList: Array<string> = this.getChatFace(msg);
		// 	let bitmapNum: number = 0;//显示表情的个数
		// 	let bitmap: Laya.Image;
		// 	let _offsetX = 0;
		// 	let _offsetY = 0;
		// 	let force_change_line = false
		// 	let firest_line_face = false
		// 	let source_text = msg
		// 	let half_font: number = 0;
		// 	let face_line = []; //多少行有表情
		// 	let notFace = false;
		// 	let maxFontNum = local_Math.floor(maxWidth / contentLabel.style.fontSize) //一行的最大字数
		// 	let offWidth = 0;
		// 	let lastLine = 0;
		// 	if (faceList && faceList.length > 0) {
		// 		_str = "<font size = " + contentLabel.style.fontSize + ">" + source_text + "</font>"
		// 		for (let i: number = 0; i < faceList.length; i++) {
		// 			bitmapNum++;
		// 			let face: string = faceList[i];
		// 			let faceId: string = face.replace(/<f_/gi, "");
		// 			faceId = faceId.replace(/>/gi, "");
		// 			//获取表情
		// 			bitmap = bitmapList[i];
		// 			if (Number(faceId) > this.faceMax()) {//不合法表情id
		// 				if (bitmap)
		// 					contentGroup.removeChild(bitmap);
		// 				continue;
		// 			}
		// 			if (!bitmap) {
		// 				bitmap = new Laya.Image();
		// 				// bitmap.includeInLayout = true;
		// 				bitmapList.push(bitmap);
		// 			}
		// 			bitmap.visible = true;
		// 			bitmap.skin="resource/game/chat/texture/"+faceId+".png"
		// 			// let texture: egret.Texture = local_RES.getRes(`chat_json.${faceId}_png`);
		// 			// bitmap.texture = texture
		// 			bitmap.width = contentLabel.style.fontSize * facePoint;
		// 			bitmap.height = local_Math.floor(contentLabel.style.fontSize * facePoint / faceWidth_ * faceHeight_);

		// 			//记录下当前文本的高度- -
		// 			let h: number = contentLabel.height

		// 			//记录一下关键字的位置
		// 			let idx = local_Math.max(source_text.indexOf(face), 0);
		// 			idx = idx - 0.5 * this.getLength(source_text.substring(0, idx)); //符号。数字。字母。占半个字符
		// 			//关于位置的信息都获取到了  所以去掉关键字  用跟表情大小相同的字号  2个中文空格 代替表情  使后续文字连续 
		// 			let replacestr = this.holdFont(bitmap.width, contentLabel.style.fontSize * fontPoint, " ", true)
		// 			_str = _str.replace(face, replacestr);
		// 			source_text = source_text.replace(face, this.holdFont(bitmap.width, contentLabel.style.fontSize, "<", false));

		// 			//用富文本填充  this.text.textFlow不能是+=
		// 			contentLabel.innerHTML = local_Util.StrToHTML(_str);

		// 			let font_Width = contentLabel.style.fontSize * idx;
		// 			let step = local_Math.floor((font_Width + bitmap.width) / maxWidth);
		// 			if ((step == 0 || step == 1) && font_Width <= maxWidth)
		// 				firest_line_face = true;
		// 			let line = local_Math.max(step, 1);
		// 			if (lastLine != line) {
		// 				lastLine = line;
		// 				force_change_line = false;
		// 				notFace = false;
		// 			}
		// 			let MaxWidth = line * maxWidth;

		// 			// 这里判断如果换行的话就将 X 的位置重置  Y 是总高度
		// 			let curr_width_off = contentLabel.style.fontSize * idx + bitmap.width - MaxWidth;
		// 			if (curr_width_off > 0.5 * contentLabel.style.fontSize) { //大于半个字符换行
		// 				if (curr_width_off <= bitmap.width) {
		// 					bitmap.x = 0;
		// 					let cur = local_Math.floor((bitmap.width - curr_width_off) / (contentLabel.style.fontSize * 0.5));
		// 					let remainder = (bitmap.width - curr_width_off) % (contentLabel.style.fontSize * 0.5);
		// 					if (remainder > 5) cur += 1;
		// 					offWidth = cur * contentLabel.style.fontSize * 0.5;
		// 					force_change_line = true;
		// 				} else {
		// 					bitmap.x = (contentLabel.style.fontSize * idx) % MaxWidth;
		// 					if (force_change_line)
		// 						bitmap.x += offWidth;
		// 				}
		// 				if (step > 0) {
		// 					let lineSpacing = step * contentLabel.style.leading;//行距
		// 					if (!notFace)
		// 						notFace = face_line.length == 0;
		// 					if (face_line.indexOf(step) == -1)
		// 						face_line.push(step);
		// 					let _line = (force_change_line && notFace) || ((step == 0 || step == 1) && firest_line_face && notFace) ? face_line.length : face_line.length - 1;//本行之前有表情的行数
		// 					let _font_size = contentLabel.style.fontSize;
		// 					bitmap.y = _line * (_font_size * fontPoint) + lineSpacing + (step - _line) * _font_size;
		// 				}
		// 			} else {
		// 				if (face_line.indexOf(0) == -1)
		// 					face_line.push(0);
		// 				//根据关键字位置  偏移量 计算 表情的x y
		// 				// first_line_has_face = true
		// 				let x = local_Math.max(contentLabel.style.fontSize * idx, 0);
		// 				let y = 0;
		// 				//添加上表情  结束- -
		// 				bitmap.x = x;
		// 				bitmap.y = y;
		// 			}
		// 			bitmap.y += offsetY;
		// 			contentGroup.addChild(bitmap);
		// 			// contentGroup.validateNow();
		// 		}
		// 	} else {
		// 		contentLabel.innerHTML = local_Util.StrToHTML(htmlMsg);
		// 	}

		// 	if (bitmapList.length > bitmapNum && contentGroup.numChildren > 1) {
		// 		let index;
		// 		for (let i: number = bitmapNum; i < bitmapList.length; i++) {
		// 			bitmap = bitmapList[i];
		// 			index = contentGroup.getChildIndex(bitmap);
		// 			if (index != -1)
		// 				contentGroup.removeChild(bitmap);
		// 		}
		// 	}
		// 	//  firest_line_face;
		// }

		// this.disposeChtaFace2 = (htmlMsg, msg, contentLabel: eui.Label, contentGroup, bitmapList, facePoint = 2.5, fontPoint = 2, offsetY = 7) => {
		// 	let _str = htmlMsg;
		// 	let faceList: Array<string> = this.getChatFace(msg);
		// 	let bitmapNum: number = 0;//显示表情的个数
		// 	let bitmap: eui.Image;
		// 	let firest_line_face = false
		// 	let source_text = msg
		// 	if (faceList && faceList.length > 0) {
		// 		for (let i: number = 0; i < faceList.length; i++) {
		// 			bitmapNum++;
		// 			let face: string = faceList[i];
		// 			let faceId: string = face.replace(/<#/gi, "");
		// 			faceId = faceId.replace(/>/gi, "");
		// 			//获取表情
		// 			bitmap = bitmapList[i];
		// 			if (Number(faceId) > this.faceMax()) {//不合法表情id
		// 				if (bitmap)
		// 					contentGroup.removeChild(bitmap);
		// 				continue;
		// 			}
		// 			if (!bitmap) {
		// 				bitmap = new eui.Image();
		// 				bitmap.includeInLayout = true;
		// 				bitmapList.push(bitmap);
		// 			}
		// 			bitmap.visible = true;
		// 			let texture: egret.Texture = local_RES.getRes(`chat_json.${faceId}_png`);
		// 			bitmap.texture = texture
		// 			bitmap.width = contentLabel.size * facePoint;
		// 			bitmap.height = local_Math.floor(contentLabel.size * facePoint / faceWidth_ * faceHeight_);

		// 			//记录下当前文本的高度- -
		// 			let h: number = contentLabel.height

		// 			//记录一下关键字的位置
		// 			let idx = local_Math.max(source_text.indexOf(face), 0);
		// 			idx = idx - 0.5 * this.getLength(source_text.substring(0, idx)); //符号。数字。字母。占半个字符

		// 			//关于位置的信息都获取到了  所以去掉关键字  用跟表情大小相同的字号  2个中文空格 代替表情  使后续文字连续 
		// 			if (local_Util.GetDeviceOS() != local_DEVICE_OS.WINDOWS_PC)
		// 				_str = _str.replace(face, this.holdFont(bitmap.width, contentLabel.size * fontPoint, "  ", true));
		// 			else
		// 				_str = _str.replace(face, this.holdFont(bitmap.width, contentLabel.size * fontPoint, " ", true));
		// 			source_text = source_text.replace(face, this.holdFont(bitmap.width, contentLabel.size, "<", false));

		// 			//用富文本填充  this.text.textFlow不能是+=
		// 			contentLabel.textFlow = local_Util.StrToHTML(_str);

		// 			//根据关键字位置  偏移量 计算 表情的x y
		// 			let x = local_Math.max(contentLabel.size * idx, 0);
		// 			let y = 0;
		// 			//添加上表情  结束- -
		// 			bitmap.x = x;
		// 			bitmap.y = y;
		// 			bitmap.y += offsetY;
		// 			contentGroup.addChild(bitmap);
		// 			firest_line_face = true;
		// 			contentGroup.validateNow();
		// 		}
		// 	} else {
		// 		contentLabel.textFlow = local_Util.StrToHTML(htmlMsg);
		// 	}

		// 	if (bitmapList.length > bitmapNum && contentGroup.numChildren > 1) {
		// 		let index;
		// 		for (let i: number = bitmapNum; i < bitmapList.length; i++) {
		// 			bitmap = bitmapList[i];
		// 			index = contentGroup.getChildIndex(bitmap);
		// 			if (index != -1)
		// 				contentGroup.removeChild(bitmap);
		// 		}
		// 	}
		// 	return firest_line_face;
		// }


		this.holdFont = (width?, size?, font?, html?) => {
			if (html == null) {
				html = false
			}
			let str = ""
			let num = Math.floor(width / size)
			let remainder = width % size
			let i = 0
			do {
				if (html) {
					str = str + "<font size = " + size + ">" + font + "</font>"
				} else {
					str = str + font
				}
				i = i + 1
			} while ((i < num * 2))
			if (remainder > 0) {
				if (html) {
					if (remainder / size > 1 / 2) {
						str = str + "<font size = " + size + ">" + font + "</font>"
					} else {
						str = str + "<font size = " + size / 2 + ">" + font + "</font>"
					}
				} else {
					if (remainder / size > 1 / 2) {
						str = str + font + font
					} else {
						str = str + font
					}
				}
			}
			return str
		}

		this.GetChuanWen = (scmd?) => {
			let cle_cfg = Config.PRELOAD_SERVER_CONFIG.config_language_extra
			// [ts2lua]cle_cfg下标访问可能不正确
			let cfg = cle_cfg && cle_cfg[scmd.module_id + "@" + scmd.id]
			if (cfg) {
				let array = Split(scmd.content, "#&")
				let str = cfg.content
				let replaceFunc = (match?) => {
					let text1 = match.replace(/[\{\}]/gi, "")
					return array[Number(text1) - 1] || ""
				}
				//let text = str.gsub("{(%d+)}", replaceFunc)
				let text = str.replace(/\{(\d+)\}/gi, replaceFunc)
				text = this.FormatColorTag(text)
				return [text, cfg]
			} else {
				// Message.show("没有找到传闻配置==：", scmd.module_id, scmd.id)
				console.log("没有找到传闻配置==：", scmd.module_id, scmd.id)
			}
			return ["", null]
		}


		this.FormatColorTag = (text?, light?) => {
			if (light == null) {
				light = true
			}
			if (!text || text == "") {
				return ""
			}
			let replaceFunc = (match?) => {
				let str = match.substring(1, match.length - 1)
				// let array = str.split("@")
				let array = Split(str, "@")
				// [ts2lua]lua中0和空字符串也是true，此处light需要确认
				// let func = (light && ( local_ColorUtil.GetColorLight ) || ( local_ColorUtil.GetColorDark ) )
				let func = light ? local_ColorUtil.GetColorLight : local_ColorUtil.GetColorDark
				//let func =local_ColorUtil.GetColorDark
				// return "<font color=" + func(Number(array[1])) + ">"
				// return "<font color=${func(Number(array[1]))}>"
				return `<font color=${func(Number(array[1]))}>`
			}

			// [ts2lua]tslua无法自动转换正则表达式，请手动处理。
			// let result = text.gsub("/<color@.+?>/gi", replaceFunc)
			// let result = text.gsub("<color@.->", replaceFunc)
			// [ts2lua]tslua无法自动转换正则表达式，请手动处理。
			// result = result.replace(/<\/color>/gi, "</font>")
			// result = result.gsub("</font>", "</font>")
			let result = text.replace(/<color@.+?>/gi, replaceFunc)
			result = result.replace(/<\/color>/gi, "</font>")
			result = this.FormatAttrTag(result)
			return result
		}

		this.FormatAttrTag = (text?) => {
			if (!text || text == "") {
				return ""
			}
			let replaceFunc = (match?) => {
				let str = match.substring(1, match.length - 1)
				// let array = str.split("@")
				let array = Split(str, "@")
				return WordManager.GetProperties(Number(array[1]))
			}

			// [ts2lua]tslua无法自动转换正则表达式，请手动处理。
			// let result = text.gsub("/<attr@.+?>/gi", replaceFunc)
			// let result = text.gsub("<attr@.->", replaceFunc)
			// // [ts2lua]tslua无法自动转换正则表达式，请手动处理。
			// // result = result.gsub("/<\/attr>/gi", "")
			// result = result.gsub("</attr>", "")
			let result = text.replace(/<attr@.+?>/gi, replaceFunc)
			result = result.replace(/<\/attr>/gi, "")
			return result
		}

		this.DeleteSpecialSign = (text?) => {
			if (!text || text == "") {
				return ""
			}
			// [ts2lua]tslua无法自动转换正则表达式，请手动处理。
			// let result = text.gsub("/<a.+?>/gi", "")
			// let result = text.gsub("<a.->", "")
			// // [ts2lua]tslua无法自动转换正则表达式，请手动处理。
			// // result = result.gsub("/<\/a>/gi", "")
			// result = result.gsub("</a>", "")
			let result = text.replace(/<a.+?>/gi, "")
			result = result.replace(/<\/a>/gi, "")
			return result
		}

		this.PackageSpecialTab = (text?) => {
			if (!text) {
				return ""
			}
			// if (Trim(text) == "" || text.search("</a>") < 0 ) {
			if (Trim(text) == "" || text.search("</a>") < 0) {
				return text
			}
			let replaceFunc = (match?) => {
				let str = match.substring(1, match.length - 1)
				//let str = string.sub(match, 1, string.len(match) - 1)
				// let array = str.split("@")
				let array = Split(str, "@")
				let name = ""
				if (((array[1] == "goods" || array[1] == "goods2") || array[1] == "goods5") || array[1] == "goods7") {
					let basic = goods_model.GetGoodsBasicByTypeId(Number(array[2]))
					if (basic) {
						name = HtmlColorTxt(Trim(basic.goods_name), ColorUtil.GetColorLight(basic.color))
					}
				} else if ((array[1] == "goods3" || array[1] == "goods4") || array[1] == "goods6") {
					let basic = goods_model.GetGoodsBasicByTypeId(Number(array[2]))
					if (basic) {
						name = HtmlColorTxt("[" + Trim(basic.goods_name) + "]", ColorUtil.GetColorLight(basic.color))
					}
				} else if (array[1] == "scene") {
					let scene_info = scene_mgr.GetSceneInfo(Number(array[2]))
					if (scene_info) {
						name = HtmlColorTxt("<" + scene_info.name + "(" + array[3] + "," + array[3] + ")>", Enum_ColorUtil_Light.GREEN)
					}
				} else if (array[1] == "player" || array[1] == "player2") {
					name = array[2]
				} else if (array[1] == "title") {
					name = array[2]
				}
				return match + name
			}

			// [ts2lua]tslua无法自动转换正则表达式，请手动处理。
			// text = text.gsub("<a.->", replaceFunc)
			text = text.replace(/<a.+?>/gi, replaceFunc)
			return text
		}

		this.FormatLinkTag = (text: string) => {
			if (!text || text == "") {
				return ""
			}
			if (text.indexOf("<a2@") != -1) {
				return this.FormatLinkTag1(text)
			} else {
				return this.FormatLinkTag2(text)
			}
		}

		this.FormatLinkTag1 = (text?) => {
			if (!text || text == "") {
				return ""
			}
			let replaceFunc = (match?) => {
				let str = match.substring(1, match.length - 1)
				return `<font href = 'event:${str}'>`
			}

			// [ts2lua]tslua无法自动转换正则表达式，请手动处理。
			// let result = text.gsub("/<a2@.+?>/gi", replaceFunc)
			// let result = text.gsub("<a2@.->", replaceFunc)
			// // [ts2lua]tslua无法自动转换正则表达式，请手动处理。
			// // result = result.gsub("/<\/a>/gi", "</font>")
			// result = result.gsub("</a>", "</font>")
			let result = text.replace(/<a2@.+?>/gi, replaceFunc)
			result = result.replace(/<\/a>/gi, "</font>")
			return result
		}

		this.FormatLinkTag2 = (text?) => {
			if (!text || text == "") {
				return ""
			}
			let replaceFunc = (match?) => {
				let str = match.substring(1, match.length - 1)
				// return "<u><font href = 'event:" + str + "'>"
				return `<u><font href = 'event:${str}'>`
			}

			// [ts2lua]tslua无法自动转换正则表达式，请手动处理。
			// let result = text.gsub("/<a@.+?>/gi", replaceFunc)
			// let result = text.gsub("<a@.->", replaceFunc)
			// // [ts2lua]tslua无法自动转换正则表达式，请手动处理。
			// // result = result.gsub("/<\/a>/gi", "</font></u>")
			// result = result.gsub("</a>", "</font></u>")
			let result = text.replace(/<a@.+?>/gi, replaceFunc)
			result = result.replace(/<\/a>/gi, "</font></u>")
			return result
		}

		this.LinkEvtInChatItem = (text?) => {
			if (text) {
				let friend_model = FriendModel.GetInstance()
				// [ts2lua]tslua无法自动转换正则表达式，请手动处理。
				// if (evt.text.search("/^a/gi") >= 0 ) {
				//   let param_list = evt.text.split("@")
				// if (text.find("^a") ) {
				if (text.indexOf("@") != -1) {
					let param_list = Split(text, "@")
					// table.remove(param_list, 1)
					this.LinkFun(param_list)
				} else {
					let list = Split(text, ",")
					let type_id = Number(list[0])
					goods_id_ = Number(list[1])
					role_id_ = Number(list[2])
					let channel = Number(list[3])
					let args = Number(list[4])
					let goods_vo = goods_model.GetGoodsBasicByTypeId(type_id)
					let MainRoleId = role_mgr.GetMainRoleId()
					if (goods_id_ && goods_vo.type == 10) {
						let vo = goods_model.GetDynamic(goods_id_, null, false, true)
						let time = friend_model.getEquipRequestTime(goods_id_, role_id_)
						if ((!vo || !time) || Status.NowTime - time >= 3) {
							// UIToolTipMgr.GetInstance().AppendEquipTips(type_id, null, null, vo, role_id_, null, null)
							friend_model.equipRequestTime(goods_id_, role_id_, Status.NowTime)
							if (role_id_ != MainRoleId) {
								// if (ChatModel.SPECIAL_CHANNEL.find(channel) != -1 ) {
								if (table.find(ChatModel.SPECIAL_CHANNEL, channel) != -1) {
									this.Fire(local_ChatModelEvent.CHECK_SPECIAL_CHANNEL_GOODS, channel, goods_id_)
								} else {
									goods_model.Fire(local_GoodsModel.REQUEST_GOODS_DYNAMIC, goods_id_, role_id_)
								}
							} else {
								goods_model.Fire(local_GoodsModel.REQUEST_GOODS_DYNAMIC, goods_id_)
							}
							if (!binEvent_) {
								binEvent_ = true
								let clear_bind = () => {
									if (this.dynamicbind) {
										local_GlobalEventSystem.UnBind(this.dynamicbind)
										this.dynamicbind = null
									}
									if (this.sp_bind) {
										this.UnBind(this.sp_bind)
										this.sp_bind = null
									}
								}
								let change_goods_dynamic = (id?) => {
									if (goods_id_ == id) {
										let vo = goods_model.GetDynamic(id, null, false, true)
										this.showTips(vo, role_id_, true)
										clear_bind()
										binEvent_ = null
									}
								}
								clear_bind()
								this.dynamicbind = local_GlobalEventSystem.Bind(local_GoodsModel.CHANGE_GOODS_DYNAMIC, change_goods_dynamic)
								this.sp_bind = this.Bind(local_ChatModelEvent.SHOW_SPECIAL_CHANNEL_GOODS, () => {
									this.showTips(goods_vo)
								}
								)
							}
						} else {
							this.showTips(vo, role_id_, true)
						}
					} else {
						this.showTips(goods_vo, role_mgr.GetMainRoleId(), goods_vo.type == 10)
					}
				}
			}
		}

		this.showTips = async (vo?, role_id?, isEquip?) => {
			let cfg = await ResManager.GetInstance().LoadGameConfig(this, "config_gift_box", false);
			let gift_cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_gift_box.name, vo.type_id, false, cfg);
			if (isEquip == null) {
				isEquip = false
			}
			let type = vo.type
			let subType = vo.subtype
			if (isEquip) {
				ui_tool_tip_mgr.AppendChatEquipTips(vo.type_id, null, null, vo, role_id)
			} else if (type == local_HolySealModel.GOODS_TYPE) {
				ui_tool_tip_mgr.AppendHolySealTips(vo.type_id, vo, null)
			} else if (type == local_LungModel.LungGoodsType ) {
				ui_tool_tip_mgr.AppendLungTips(vo.type_id, vo.level)
			} else if (type == local_LungModel.LungMaterialGoodsType ) {
				ui_tool_tip_mgr.AppendLungStoneTips(vo.type_id)
			} else if (type == 12 || local_BagModel.IlluType[type] == subType) {//时装或者其他培养的幻化
				ui_tool_tip_mgr.AppendIllusionTips(vo.type_id, null, null, vo)
			} else if (type == local_GodBefallDefine.GOOD_TYPE && subType == local_GodBefallDefine.STAGE_SUBTYPE ) {
				ui_tool_tip_mgr.AppendIllusionTips(vo.type_id, null, null, vo)
			} else if (type == local_GodBefallDefine.EQUIP_TYPE) {
				ui_tool_tip_mgr.AppendGodEquipTips(vo.type_id)
			} else if (type == 76) {//神喻
				ui_tool_tip_mgr.AppendIllusionTips(vo.type_id, null, null, vo)
			} else if (type == RevelationModel.GOODS_TYPE) {
				ui_tool_tip_mgr.AppendRevelationTooltips(vo.type_id)
			} else if (type == local_longlangModel.GOODS_TYPE) {
				ui_tool_tip_mgr.AppendLongLangToolTips(vo.type_id, vo, null, [local_LonglangToolTips.Btn.close ])
			} else if (type == GodCourtModel.GoodsType && subType < 17 ) {
				ui_tool_tip_mgr.AppendGodCourtTips(vo.type_id, null, null, [GodCourtTooltip.Btn.close])
			} else if (type == 75 && subType == 2) { // 藏宝图
				ui_tool_tip_mgr.AppendItemInfoTips(vo.type_id, vo);
			} else if ((type == 32 || type == 34 || type == 33) && gift_cfg?.show_new == 1) { //礼包
				ui_tool_tip_mgr.AppendItemInfoTips(vo.type_id, vo);
			} else {
				ui_tool_tip_mgr.AppendGoodsTips(vo.type_id)
			}
		}

		this.LinkFun = (param_list?) => {
			let friend_model = FriendModel.GetInstance()
			if (!param_list) {
				return
			}
			if (param_list[1] == "player") {
				if (param_list[2] == "蒙面人") {
					Message.show("无法查看蒙面人信息")
				} else {
					friend_model.requestPlayerMessage(Number(param_list[3]))
				}
			} else if (param_list[1] == "player2") {
				if (param_list[2] == "蒙面人") {
					Message.show("无法查看蒙面人信息")
				} else {
					friend_model.requestPlayerMessage(Number(param_list[3]), false, param_list[4])
				}
			} else if (param_list[1] == "guildjoin") {
				guild_model.Fire(local_GuildEvent.REQUEST_PROTO, 40029, "l", Number(param_list[2]))
			} else if (param_list[1] == "goods3") {
				let type_id = Number(param_list[2])
				let basic = goods_model.GetGoodsBasicByTypeId(type_id)
				if (basic) {
					let rating = Number(param_list[3])
					let best_str = param_list[4]
					let vo = user_msg_adapter.GetSCMD(15001, true)
					vo.equip_extra_attr = goods_model.CreateExtraAttr(best_str)
					vo.rating = rating
					vo.type_id = type_id
					vo.color = basic.color
					vo.overall_rating = rating
					let type = basic.type
					let subType = basic.subtype
					goods_model.AddDynamic(vo)
					if (type == 10) {
						ui_tool_tip_mgr.AppendEquipTips(type_id, null, null, vo)
					} else if (type == 39) {
						ui_tool_tip_mgr.AppendGodBeastTips(type_id, null, null, vo)
						// [ts2lua]local_BagModel.IlluType下标访问可能不正确
					} else if (type == 12 || local_BagModel.IlluType[type] == subType) {
						ui_tool_tip_mgr.AppendIllusionTips(basic.type_id, null, null, null, this)
					} else if (type == local_UnrealModel.goods_type) {
						ui_tool_tip_mgr.AppendUnrealTips(vo.type_id, vo, null, [UnrealToolTips.Btn.close])
					} else if (type == local_HolySealModel.GOODS_TYPE) {
						ui_tool_tip_mgr.AppendHolySealTips(basic.type_id, null, null, [HolySealToolTips.Btn.close])
					} else if (type == local_LungModel.LungGoodsType ) {
						ui_tool_tip_mgr.AppendLungTips(basic.type_id, 1)
					} else if (type == local_LungModel.LungMaterialGoodsType ) {
						ui_tool_tip_mgr.AppendLungStoneTips(basic.type_id)
					} else if (type == local_GodBefallDefine.EQUIP_TYPE) {
						ui_tool_tip_mgr.AppendGodEquipTips(basic.type_id)
					} else if (type == local_GodBefallDefine.GOOD_TYPE && subType == local_GodBefallDefine.STAGE_SUBTYPE ) {
						ui_tool_tip_mgr.AppendIllusionTips(basic.type_id)
					} else if (type == local_RevelationModel.GOODS_TYPE) {
						ui_tool_tip_mgr.AppendRevelationTooltips(basic.type_id, null, null, null, 0)
					} else if (type == local_longlangModel.GOODS_TYPE) {
						ui_tool_tip_mgr.AppendLongLangToolTips(basic.type_id, null, null, { "0": local_LonglangToolTips.Btn.close })
					} else if (type == StarEquipModel.GOODS_TYPE && subType < 11) {
						ui_tool_tip_mgr.AppendStarEquipToolTips(type_id, null, null, [StarEquipToolTip.Btn.close])
					} else if (type == GodCourtModel.GoodsType && subType < 17 ) {
						ui_tool_tip_mgr.AppendGodCourtTips(type_id, null, null, [GodCourtTooltip.Btn.close])
					} else {
						ui_tool_tip_mgr.AppendGoodsTips(type_id)
					}
				}
			} else if (param_list[1] == "goods") {
				let type_id = param_list[2]
				let basic = goods_model.GetGoodsBasicByTypeId(type_id)
				let type = basic.type
				let subType = basic.subtype
				if (type == 10) {
					ui_tool_tip_mgr.AppendEquipTips(type_id)
				} else if (type == 39) {
					ui_tool_tip_mgr.AppendGodBeastTips(type_id)
					// [ts2lua]local_BagModel.IlluType下标访问可能不正确
				} else if (type == 12 || local_BagModel.IlluType[type] == subType) {
					ui_tool_tip_mgr.AppendIllusionTips(basic.type_id, null, null, null, this)
					// } else if (type == local_UnrealModel.goods_type ) {
					// 	ui_tool_tip_mgr.AppendUnrealTips(basic.type_id, null, null, {UnrealToolTips.Btn.close})
				} else if (type == local_HolySealModel.GOODS_TYPE) {
					ui_tool_tip_mgr.AppendHolySealTips(basic.type_id, null, null, [HolySealToolTips.Btn.close])
				} else if (type == local_GodBefallDefine.EQUIP_TYPE) {
					ui_tool_tip_mgr.AppendGodEquipTips(basic.type_id)
					// } else if (type == local_GodBefallDefine.GOOD_TYPE && subType == local_GodBefallDefine.STAGE_SUBTYPE ) {
					// 	ui_tool_tip_mgr.AppendIllusionTips(basic.type_id, null, null, null, this)
				} else if (type == local_RevelationModel.GOODS_TYPE) {
					ui_tool_tip_mgr.AppendRevelationTooltips(basic.type_id)
				} else if (type == local_longlangModel.GOODS_TYPE) {
					ui_tool_tip_mgr.AppendLongLangToolTips(basic.type_id, null, null, { "O": local_LonglangToolTips.Btn.close })
				} else if (type == StarEquipModel.GOODS_TYPE && subType < 11) {
					ui_tool_tip_mgr.AppendStarEquipToolTips(type_id, null, null, [StarEquipToolTip.Btn.close])
					// } else if (type == GodCourtModel.GoodsType && subType < 17 ) {
					// 	ui_tool_tip_mgr.AppendGodCourtTips(type_id, null, null, {GodCourtTooltip.Btn.close})
				} else {
					UIToolTipMgr.GetInstance().AppendGoodsTips(type_id)
				}
			} else if (param_list[1] == "open_fun") {
				if (param_list[2] != null) {
					if(param_list[2]==50){
						//打开结社 收起聊天面板
						GlobalEventSystem.Fire(EventName.CLOSE_CHAT_VIEW)
					}
					local_OpenFun.OpenFunHandler(Number(param_list[2]))
				}
			} else if (param_list[1] == "open_fun2") {
				if (Number(param_list[2]) == 451) {
					local_GlobalEventSystem.Fire(local_EventName.OPEN_TOP_VIP_BASE_VIEW)
				} else if (Number(param_list[2]) == FestivalModel.ICON_TYPE) { // 祭典
					local_OpenFun.OpenFunHandler(Number(param_list[2]), Number(param_list[3]));
				} else if (Number(param_list[2]) == SpecialPackageModel.ICON_TYPE) {
					local_OpenFun.OpenFunHandler(Number(param_list[2]));
				} else if (Number(param_list[2]) == Config.PRELOAD_CLIENT_CONFIG.ConfigCustomActivity.ACT_ID.LIST_DUOBAO) { // 冲榜夺宝
					local_OpenFun.OpenFunHandler(Number(param_list[2]));

				}

			} else if (param_list[1] == "open_fun3") {
				if (param_list[2] == "471") {
					if (param_list[3] == "1") {
						let con = "是否开启" + HtmlColorTxt("协助模式", Enum_ColorUtil_Dark.ORANGE) + "前往助他一臂之力，成功协助其获得归属奖励后可获得一份" + HtmlColorTxt("协助奖励", Enum_ColorUtil_Dark.ORANGE)
						Alert.Show(Util.StrToHTML(con), Alert_Type.Two, () => {
							//暂时屏蔽
							//boss_model.doMainSelectBossId = param_list[4]
							boss_model.Fire(local_BossBaseModel.SCMD_REQUEST, 47102, param_list[4], 2)
						}
						)
					} else if (param_list[3] == "2") {
						let jumpId = param_list[4]
						if (jumpId != "") {
							local_OpenFun.OpenFunHandler(157, param_list[4])
						}
					}
				}
			} else if (param_list[1] == "request_id") {
				if (param_list[2] != null) {
					local_OpenFun.RequestOpen(param_list[2])
				}
			} else if (param_list[1] == "moneyTree" || param_list[1] == "custom" || param_list[1] == "zore") {
				let len = param_list.length
				if (len < 4) {
					return
				}
				let [icon_type, act_type, show_id] = CustomActivityModel.GetInstance().GetActIconType(Number(param_list[len - 2]), Number(param_list[len - 1]), true)
				if (icon_type) {
					let id = undefined
					if (icon_type == "331@98@0" || icon_type == "331@98@1") {
						icon_type = "331@100"
						id = 98
					}
					if (act_type) {
						local_GlobalEventSystem.Fire(local_EventName.OPEN_ACT_VIEW, icon_type, act_type, show_id)
					} else {
						local_GlobalEventSystem.Fire(local_EventName.OPEN_ACT_VIEW, icon_type, id)
					}
				}
			} else if (param_list[1] == "goods4") {
				let type_id = Number(param_list[2])
				goods_id_ = Number(param_list[3])
				role_id_ = Number(param_list[4])
				let basic = goods_model.GetGoodsBasicByTypeId(type_id)
				if (basic.type == StarEquipModel.GOODS_TYPE) {
					UIToolTipMgr.GetInstance().AppendStarEquipToolTips(type_id, null, role_id_, [StarEquipToolTip.Btn.close], null, null, goods_id_)
				} else if (role_id_ != role_mgr.GetMainRoleId()) {
					goods_model.Fire(local_GoodsModel.REQUEST_GOODS_DYNAMIC, goods_id_, role_id_)
					if (!binEvent_) {
						binEvent_ = true
						let clear_bind = () => {
							if (this.dynamicbind2) {
								local_GlobalEventSystem.UnBind(this.dynamicbind2)
								this.dynamicbind2 = null
							}
						}

						let change_goods_dynamic = (id?) => {
							if (goods_id_ == id) {
								let vo = goods_model.GetDynamic(id, null, false, true)
								// this.showTips(vo, role_id_, true)
								ui_tool_tip_mgr.AppendEquipTips(vo.type_id, null, null, vo, role_id_)
								clear_bind()
								binEvent_ = null
							}
						}

						this.dynamicbind2 = local_GlobalEventSystem.Bind(local_GoodsModel.CHANGE_GOODS_DYNAMIC, change_goods_dynamic)
					}
				} else {
					let dynamic = equip_model.GetWearEquipDynamic(basic.subtype)
					if (dynamic) {
						ui_tool_tip_mgr.AppendEquipTips(type_id, null, null, dynamic, 1)
					}
				}
				// }
			} else if (param_list[1] == "marriage") {
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "MarriageBaseView")
			} else if (param_list[1] == "sendpersonals") {
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "MarriageBaseView")
			} else if (param_list[1] == "bosshelp") {
				let boss_type = Number(param_list[2])
				let boss_id = Number(param_list[3])
				let scene_id = Number(param_list[4])
				// let x = param_list[5] / LogicRealRatio_X
				// let y = param_list[6] / LogicRealRatio_Y
				let x = param_list[5] / SceneObj.GetLogicRealRatio().x
				let y = param_list[6] / SceneObj.GetLogicRealRatio().y
				let pos = new Vector2(x, y)
				if (scene_id && scene_mgr.GetSceneId() == scene_id) {
					auto_fight_mgr.SetAutoFight(false)
					scene.MainRoleMove(pos, 1, () => {
						let ok = secret_boss_model.JudgeTired(false)
						auto_fight_mgr.SetAutoFight(ok)
					}
					)
				} else {
					if (boss_type == 10) {
						boss_type = 1
					}
					boss_model.CheckEnterCondAndGoCost(boss_type, boss_id, pos)
				}
			} else if (param_list[1] == "weddingask") {
				let w_info
				if (role_mgr.GetMainRoleId() == param_list[2] || role_mgr.GetMainRoleVo().marriage_id == param_list[2]) {
					w_info=BanquetModel.GetInstance().InviteViewData
					if(w_info){
						local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "BanquetNoticeView", 2)
					}else{
						Message.show("婚礼已经结束")
					}
					
				} else {
					w_info=BanquetModel.GetInstance().weddingInfo
					if(w_info){
						local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "BanquetNoticeView", 1)
					}else{
						Message.show("婚礼已经结束")
					}
				}
			} else if (param_list[1] == "scene3") {
				this.fer(param_list[2], Number(param_list[3]), Number(param_list[4]), param_list[5])
			} else if (param_list[1] == "red_envelopes") {
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "RedPacketMainView")
			} else if (param_list[1] == "guildquiz") {
				Alert.Show("是否前往结社晚宴", Alert_Type.Two, () => {
					GlobalEventSystem.Fire(EventName.CLOSE_CHAT_VIEW)
					GuildActivityModel.GetInstance().Fire(GuildActEvent.REQUEST_PROTO, 40212)
				}, null, "前往", "取消")
			} else if (param_list[1] == "team") {
				if (!TeamModel.GetInstance().IsOpenTeam()) return
				TeamModel.GetInstance().Fire(TeamEvent.TEAM_REQUEST_PROTO, 24002, "lcc", param_list[2], param_list[3], param_list[4])
			} else if (param_list[1] == "guilddepot") {
				if (GuildModel.IsHasGuild()) {
					guild_model.Fire(local_GuildEvent.OPEN_VIEW, "GuildDepotBaseView")
				}
			} else if (param_list[1] == "seekgoods") {
				MarketModel.GetInstance().Fire(MarketEvent.OPEN_VIEW, "MarketBaseView", 1)
			} else if (param_list[1] == "sellid") {
				MarketModel.GetInstance().Fire(MarketEvent.OPEN_VIEW, "MarketBaseView", 0, param_list[2], param_list[3])

			} else if (param_list[1] == "guildguard") {
				guild_model.Fire(local_GuildEvent.REQUEST_PROTO, 40230)
			} else if (param_list[1] == "race_act") {
				let type = param_list[2]
				let subtype = param_list[3]
				// [ts2lua]CompeteListModel:GetInstance().config_atList下标访问可能不正确
				// let config = CompeteListModel.GetInstance().config_atList[type + "@" + subtype]
				let config;
				if (config && config.act_type != 1) {
					local_GlobalEventSystem.Fire(local_EventName.OPEN_ACT_VIEW, config.icon, local_Config.PRELOAD_CLIENT_CONFIG.ConfigCustomActivity.SPECIAL_ID.COMPETELIST + "@" + type + "@" + subtype)
				} else {
					local_GlobalEventSystem.Fire(local_EventName.OPEN_COMPETELIST_ENTER_VIEW, type, subtype)
				}
			} else if (param_list[1] == "baby") {
				baby_model.Fire(local_BabyEvent.OPEN_VIEW, "BabyTeaseView", param_list[2])
			} else if (param_list[1] == "praiser") {
				baby_model.Fire(local_BabyEvent.OPEN_VIEW, "BabyBelikeView")
			} else if (param_list[1] == "mystery") {
				boss_model.MysteryBossJumpBySceneId(param_list[2])
			} else if (param_list[1] == "goods5") {
				ui_tool_tip_mgr.AddBabyEquipToolTips(param_list[2], null, null, { type_id: param_list[2], goods_id: 1, rating: param_list[3], skill_id: Number(param_list[4]), skill_lv: 1 })
			} else if (param_list[1] == "3v3team") {
				let team_id = Number(param_list[2])
				// CSPVPModel.GetInstance().Fire(CSPVPEvent.REQUEST_PROTO, 65050, "l", team_id)
			} else if (param_list[1] == "worldauction") {
				local_OpenFun.OpenFunHandler(156)
			} else if (param_list[1] == "kfrealmauction") {
				// MarketModel.GetInstance().Fire(MarketEvent.OPEN_VIEW, "MarketBaseView", 4, 3)
			} else if (param_list[1] == "terri_war") {
				if (!CommonManager.GetInstance().CheckFuncOpenState("BattleFieldEnterView")) {
					return
				}
				local_OpenFun.OpenFunHandler(33)
				// GuildFightModel.GetInstance().Fire(GuildFightEvent.GUILDFIGHT_OPEN_VIEW, "GuildFightMapView")
			} else if (param_list[1] == "title") {
				ResManager.GetInstance().LoadGameConfig(this, "ClientTitleTipsModel", true, null, (cfg?) => {
					let goods_id = null
					for (let key in cfg) {

						// [ts2lua]cfg下标访问可能不正确
						let value = cfg[key]
						if (value.title_id == param_list[3]) {
							goods_id = value.fargment_goods_id
							break
						}
					}
					if (goods_id) {
						ui_tool_tip_mgr.AppendIllusionTips(goods_id, null, null, null, this)
					}
					ResManager.GetInstance().DestoryGameConfig(this, "ClientTitleTipsModel")
				})
			} else if (param_list[1] == "convoy_scene") {
				// ConvoyModel.GetInstance().Fire(ConvoyModel.REQUEST_PROTO, 18502, "i", param_list[2])
			} else if (param_list[1] == "seaAssert") {
				SeaHegemonyModel.GetInstance().Fire(SeaHegemonyModel.REQUEST_PROTO, 18702, "c", param_list[2])
			} else if (param_list[1] == "firstrecharge") {
				OpenFun.OpenFunHandler(21)
			} else if (param_list[1] == "guildapply") {
				GuildModel.GetInstance().Fire(GuildEvent.REQUEST_PROTO, 40002, "l", param_list[2])
			} else if (param_list[1] == "guildassist") {
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "GuildHelpView")
			} else if (param_list[1] == "groupbuy") {
				let icon_type = `331@${param_list[2]}@${param_list[3]}`
				let data = CustomActivityModel.GetInstance().GetActDataByShowID(Number(param_list[2]), Number(param_list[3]))
				let role_wlv = RoleManager.GetInstance().GetMainRoleVo().worldLv
				let is_can_jump = false
				let wlv_min = null
				let wlv_max = null
				if(data){
					let bool = CustomActivityModel.GetInstance().CheckGroupBuyIsTimeOut(data.base_type, data.sub_type, true)
					if(!bool){
						Message.show(`订购阶段已结束`)
						return
					}
					let condition = null
					if(data.reward_list){
						let reward_list = data.reward_list
						for (let key in reward_list) {
							let vo = reward_list[key]
							if(vo.grade == param_list[4]){
								condition = vo.condition
								break
							}
						}
						if(!condition){
							Message.show("世界等级不足")
							return 
						}
						let cond_data = ErlangParser.GetInstance().Parse(condition)
						
						for (let key in cond_data) {
							let data = cond_data[key]
							if(data[0] == "wlv"){
								wlv_max = data[1][0][1]
								wlv_min = data[1][0][0]
								break
							}
						}
						if(wlv_max && role_wlv <= wlv_max && role_wlv >= wlv_min){
							is_can_jump = true
						}
					}
				}else{
					Message.show(`活动已结束`)
					return
				}
				
				if(!is_can_jump){
					Message.show(`世界等级${wlv_min}级开启`)
					return
				}
				let reward_grade = Number(param_list[4])
				local_GlobalEventSystem.Fire(local_EventName.OPEN_ACT_VIEW, icon_type, reward_grade)
				this.Fire(ChatModelEvent.CLOSECHATPANEL)
			}
		}

		this.fer = (target_sceneId?, x?, y?, args?) => {
			target_sceneId = Number(target_sceneId)
			if (scene_mgr.IsPrivateScene(target_sceneId)) {
				local_Message.show("个人场景无法前往")
				return
			} else if (scene_mgr.IsNoTransferScene()) {
				local_Message.show("当前场景无法前往")
				return
			}
			// let posX = x / LogicRealRatio_X
			// let posY = y / LogicRealRatio_Y
			let ratio
			// if (SceneManager.GetInstance().Is3DScene(target_sceneId)) {
			// 	//ratio = SceneObj.LogicRealRatio
			// 	ratio = SceneObj.LogicRealRatio2D
			// } else {
			ratio = SceneObj.LogicRealRatio2D
			// }
			if (!Number(x) || !Number(y)) {
				return
			}
			let posX = Number(x) / ratio.x
			let posY = Number(y) / ratio.y
			let pos = new Vector2(posX, posY)
			if (target_sceneId && scene_mgr.GetSceneId() == target_sceneId) {
				if (!scene.main_role || scene.main_role.x == x && scene.main_role.y == y) {
					return
				}
				local_Message.show("当前已在场景")
				if (scene_mgr.IsGhostWalkScene(target_sceneId)) {
					//百鬼夜行
					GhostWalkModel.ins.SkipToMap(target_sceneId, pos)
				} else {
					scene.MainRoleMove(pos)
				}

			} else {
				// let secneInfo = local_Config.PRELOAD_SETVER_CONFIG.config_scene[target_sceneId]
				let secneInfo = SceneManager.GetInstance().GetSceneInfo(target_sceneId)
				if (!secneInfo) {
					local_Message.show("无此场景")
					return
				}

				//let level = role_mgr.GetMainRoleVo().level
				// let list = H5StringMatch(secneInfo.lv, "%d*,%d*")
				// let list
				// if (list.length > 0) {
				// 	let levList = Split(list[1], ",")
				// 	let minLev = Number(levList[2])
				// 	if (level < minLev) {
				// 		local_Message.show("等级不足，无法前往该场景")
				// 		return
				// 	}
				// }

				if (scene_mgr.IsFieldScene() && scene_mgr.IsFieldScene(target_sceneId)) {
					let call = () => {
						scene.MainRoleMove(pos)
					}
					local_GlobalEventSystem.Fire(SceneEventType.REQUEST_CHANGE_SCENE, target_sceneId, null, null, null, null, null, call)
					return
				}
				let tran = () => {
					if (scene_mgr.IsKfHolyAreaScene(target_sceneId)) {
						user_msg_adapter.SendAllFmtToGame(28404, "i", [target_sceneId])
					} else if (scene_mgr.IsFeastBossScene(target_sceneId)) {
						boss_model.BossToFeastScene(pos)
					} else if (scene_mgr.IsBossScene(target_sceneId) && !scene_mgr.IsBossDoMainScene(target_sceneId)) {
						let args_list = Split(args, "_")
						if (args.boss_type == 10) {
							args.boss_type = 1
						}
						boss_model.CheckEnterCondAndGoCost(args_list[0], args_list[1], pos)
					} else if (scene_mgr.IsFieldScene(target_sceneId)) {
						if (scene_mgr.IsBossScene()) {
							//暂时屏蔽
							//boss_model.bossToField(pos)
						} else if (scene_mgr.IsDungeonScene()) {
							// BaseDungeonModel.GetInstance().exit()
						} else if (scene_mgr.IsKfHolyAreaScene(target_sceneId)) {
							// KfHolyArea_model.Fire(KfHolyAreaModel.REQUEST_CCMD_EVENT, 28407)
						}
					} else if (scene_mgr.IsGhostWalkScene(target_sceneId)) {
						//百鬼夜行
						GhostWalkModel.ins.SkipToMap(target_sceneId, pos)
					} else {
						local_Message.show("此类场景不支持跳转")
					}
				}

				Alert.Show("是否前往场景?", Alert_Type.Two, tran, null, "确定", "取消")
			}
		}

		this.positionChat = (scene_info?, cus_pos?) => {
			let roleVo = role_mgr.GetMainRoleVo()
			let args = ""
			let pos = new Vector2(roleVo.pos_x, roleVo.pos_y)
			if (scene_mgr.IsKfHolyAreaScene()) {

			} else if (scene_mgr.IsHolyTerritory()) {
				let boss_type = boss_model.GetBossType()
				//[ts2lua]HolyTerritoryModel:GetInstance().sceneIdtoIndex下标访问可能不正确
				let boss_id = HolyTerritoryModel.GetInstance().sceneIdtoIndex[scene_mgr.curr_scene_id]
				//let boss_id;
				args = boss_type + "_" + boss_id
			} else if (scene_mgr.IsBossScene(scene_info.sceneId) && !scene_mgr.IsFeastBossScene()) {
				let boss_type = boss_model.GetBossType()
				if (boss_type == BossModel.BossType.domain) {
					args = boss_type + "_0"
				} else {
					let boss_info = boss_model.GetEnterBossInfo()
					// let boss_id = boss_info && boss_info.boss_id
					// let boss_id = BossSceneManager.GetInstance().select_boss_id
					let boss_id
					let list = boss_model.GetBossList()
					if ((!boss_id || 0 == boss_id) && list[1]) {
						// let list = boss_model.GetBossTypeInfo(boss_type)
						// boss_id = ((list && list.boss_info) && list.boss_info[0]) && list.boss_info[0].boss_id
						boss_id = list[1].boss_id
					}
					if (boss_type == local_BossBaseModel.BossType.holy) {
						boss_type = 1
					}
					args = boss_type + "_" + boss_id
				}

			}
			// else if(scene_mgr.IsGhostWalkScene()){
			// 	pos = cus_pos
			// }
			let content = ""
			// if (PlatformMgr.GetInstance().IsEyouKrPlatform() ) {
			// 	content = "<color@" + ColorType.BLUE + "><a@scene3@" + scene_info.id + "@" + Math.floor(roleVo.pos_x) + "@" + Math.floor(roleVo.pos_y) + "@" + args + "><" + Trim(scene_info.name) + "[" + Math.floor(roleVo.pos_x) + "," + Math.floor(roleVo.pos_y) + "]></a></font>"
			// }else{
			// 	content = "<color@" + ColorType.BLUE + "><a@scene3@" + scene_info.id + "@" + Math.floor(roleVo.pos_x) + "@" + Math.floor(roleVo.pos_y) + "@" + args + ">" + "<" + Trim(scene_info.name) + "[" + Math.floor(roleVo.pos_x) + "," + Math.floor(roleVo.pos_y) + "]></a></font>"
			// }

			// content = "<a@scene3@" + scene_info.id ..
			// "@" + Math.floor(roleVo.pos_x) + "@" + Math.floor(roleVo.pos_y) ..
			// "@" + args + "></a>"
			content = `<color@${local_ColorType.BLUE}><a@scene3@${scene_info.id}@${local_Math.floor(pos.x)}@${local_Math.floor(pos.y)}@${args}>${scene_info.name}[${local_Math.floor(roleVo.pos_x)},${local_Math.floor(roleVo.pos_y)}]</a></color>`;
			return content
		}

		this.setSmallKuaFuOpen = () => {
			let flag = false
			// [ts2lua]this.ViewClassCFG下标访问可能不正确
			let config = this.ViewClassCFG[local_CHAT_TYPE.SMALL_KUAFU]
			if (config) {
				let openDay = sever_time_model.GetOpenServerDay()
				let level = role_mgr.GetMainRoleVo().level
				if (openDay >= config.openDay && level >= config.openLevel) {
					flag = true
				}
			}
			this._smallKuaFuOpen = flag
		}

		this.LevelLimit = (channel?, showMessage?) => {
			if (showMessage == null) {
				showMessage = false
			}
			let level = role_mgr.GetMainRoleVo().level
			let flag = true
			if (local_CHAT_TYPE.WORLD == channel) {
				flag = level >= 60
			} else if (local_CHAT_TYPE.GUILD == channel) {
				flag = level >= 60
			} else if (local_CHAT_TYPE.SMALL_KUAFU == channel) {
				flag = level >= 200
			}
			if (!flag && showMessage) {
				local_Message.show("未达到开放等级")
			}
			return flag
		}

		this.StartGongGaoList = (scmd?) => {
			gonggao_info_ = null
			if (!scmd || scmd.notice_list.length < 1) {
				this.ClearGongGaoTimer()
				return
			}
			gonggao_info_ = scmd
			let ser_time = local_TimeUtil.getServerTime()
			let i = 0
			do {
				// do {
				let vo = scmd.notice_list[i]
				if ((vo.state == 0 || ser_time > vo.end_time) || !this.CheckPlatName(vo.source)) {
					table.remove(scmd.notice_list, i)
					i = i - 1
				} else {
					vo.content = this.FormatColorTag(vo.content, true)
					if (vo.send_gap <= 3) {
						vo.send_gap = 300
					}
					if (vo.start_time - ser_time > 0) {
						vo.next_time_stamp = vo.start_time
					} else {
						let time = (ser_time - vo.start_time) % vo.send_gap
						// [ts2lua]lua中0和空字符串也是true，此处time > 0需要确认
						vo.next_time_stamp = ser_time + (time > 0 && (vo.send_gap - time) || (0))
					}
				}
				// } while (true)
				i = i + 1
			} while ((i < scmd.notice_list.length))
			this.ClearGongGaoTimer()
			this.StartGongGaoTimer()
			this.UpdatetGongGaoTimer()
		}

		this.CheckPlatName = (name?) => {
			if (name == "") {
				return true
			}
			// let str_list = name.split(",")
			let str_list = Split(name, ",")
			// let plat_name = PlatformManager.GetPlatformName()
			let plat_name = ClientConfig.plat_name
			for (let _tmpi in str_list) {
				var info = str_list[_tmpi]
				if (info == plat_name) {
					return true
				}
			}
			return false
		}

		this.StartGongGaoTimer = () => {
			// gg_timer_ = local_egret. new Timer(1000)
			// gg_timer_.addEventListener(local_egret.TimerEvent.TIMER, this.UpdatetGongGaoTimer, this)
			// gg_timer_.start()
			let func = () => {
				this.UpdatetGongGaoTimer()
			}
			gg_timer_ = GlobalTimerQuest.AddPeriodQuest(func, 1, -1)
			func()
		}

		this.UpdatetGongGaoTimer = () => {
			let info = gonggao_info_
			if (!info || info.notice_list.length < 1) {
				this.ClearGongGaoTimer()
				return
			}
			let ser_time = local_TimeUtil.getServerTime()
			if (info.notice_list.length <= 0) {
				return
			}
			let i = 0
			do {
				let vo = info.notice_list[i]
				if (ser_time > vo.end_time) {
					table.remove(info.notice_list, i)
					i = i - 1
				} else {
					if (ser_time >= vo.next_time_stamp) {
						this.CheckGongGaoFunc(vo)
						vo.next_time_stamp = vo.next_time_stamp + vo.send_gap
					}
				}
				i = i + 1
			} while ((i < info.notice_list.length))
		}

		this.ClearGongGaoTimer = () => {
			// if (! gg_timer_ ) {
			// 	return
			// }
			// gg_timer_.stop()
			// gg_timer_.removeEventListener(local_egret.TimerEvent.TIMER, this.UpdatetGongGaoTimer, this)
			// gg_timer_ = null
			if (gg_timer_) {
				GlobalTimerQuest.CancelQuest(gg_timer_)
				gg_timer_ = null
			}
		}

		this.CheckGongGaoFunc = (vo?) => {
			if (vo.type == 0) {
				// local_GlobalEventSystem.Fire(local_SysInfoController.APPEND_MSG, SysInfoType.CHUANWEN, vo.content, 1)
				// SysInfoCtrl.Instance.AppendMsg(SysInfoCtrl.SysInfoType.MINI, vo.content, 1)
				this.showChuanwen({ txt: vo.content, type: vo.type })
			} else if (vo.type == 1) {
				let cfg = { subtype: local_CHAT_TYPE.SYSTEM, limit_line: 1 }
				local_GlobalEventSystem.Fire(local_EventName.SHOW_CHUANWEN, vo.content, cfg, {})
			} else if (vo.type == 2) {
				let cfg = { subtype: local_CHAT_TYPE.SYSTEM, limit_line: 1 }
				// local_GlobalEventSystem.Fire(local_SysInfoController.APPEND_MSG, SysInfoType.CHUANWEN, vo.content, 1)
				// SysInfoCtrl.Instance.AppendMsg(SysInfoCtrl.SysInfoType.MINI, vo.content, 1)
				this.showChuanwen({ txt: vo.content, type: vo.type })
				local_GlobalEventSystem.Fire(local_EventName.SHOW_CHUANWEN, vo.content, cfg, {})
			}
		}

		this.kuafuShow = (bool?) => {
			if (bool == null) {
				bool = false
			}
			let flag = false
			for (let key in worldKufuActivityCFG_) {
				let conf = worldKufuActivityCFG_[key]
				if (ActivityForeshowManager.GetInstance().CheckActivityOpenToDay(conf.type, conf.subtype, conf.ac_sub, bool)) {
					flag = true
					break
				}
			}
			return flag
		}

		this.checkKuafuActivityOpen = () => {
			let flag = true
			let level = 0
			let open = true
			let roleLv = role_mgr.GetMainRoleVo().level
			for (let key in worldKufuActivityCFG_) {

				// [ts2lua]worldKufuActivityCFG_下标访问可能不正确
				let conf = worldKufuActivityCFG_[key]
				let ac = DailyModel.GetInstance().GetAcCfg(conf.type, conf.subtype, conf.ac_sub)
				// let ac
				if (ac) {
					if (open && roleLv < ac.start_lv) {
						open = false
					}
					if (level == 0 || level > ac.start_lv) {
						level = ac.start_lv
					}
				}
			}
			return [open, level]
		}

		this.createRobotChat = (type?, cfg?, robotlv?) => {
			//robot_content_config_ 等于 Config.Robotchatcontent
			//robot_name_config_ 等于 Config.Occupyname
			let configList = []
			for (let key in robot_content_config_) {

				let info = robot_content_config_[key]
				if (info.type == type) {
					table.insert(configList, info)
				}
			}
			if (configList.length > 0) {
				table.sort(configList, (a?, b?) => {
					return a.no < b.no
				})
				let roleVo = role_mgr.GetMainRoleVo()
				let index = 0
				let sendRobotChat
				sendRobotChat = () => {
					let config = configList[index]
					if (!config) {
						return
					}
					let Robot = RobotDic_[config.type + "_" + config.role_no]
					let newRobot = []
					if (!Robot) {
						newRobot = []
						newRobot["player_id"] = 0
						let name = ""
						let sex = 1
						let nameLen = Util.TableSize(robot_name_config_)
						let findName = false
						let creat = () => {
							// newRobot["name"] = name
							// newRobot["level"] = config.role_lv
							// newRobot["career"] = 1 + RandomRange(0, 1)
							// newRobot["channel"] = local_CHAT_TYPE.WORLD
							// newRobot["picture"] = '1'

							// let robot_random_index = RandomRange(1, Config.Jjcrobot.length)
							// let random_robot = Config.Jjcrobot[robot_random_index]
							let random_robot
							// for (let i = 0; i < cfg.length; i++) {
							// 	var v = cfg[i]
							// 	let lv_range = ErlangParser.GetInstance().Parse(v.lv_range)
							// 	if (config.role_lv >= Number(lv_range[0]) && config.role_lv <= Number(lv_range[1])) {
							// 		random_robot = v
							// 		break
							// 	}
							// }
							for (let key in cfg) {
								var v = cfg[key]
								let lv_range = ErlangParser.GetInstance().Parse(v.lv_range)
								if (config.role_lv >= Number(lv_range[0]) && config.role_lv <= Number(lv_range[1])) {
									random_robot = v
									break
								}
							}
							let power_range = 0
							if (!random_robot) {
								random_robot = cfg[1]
							}
							for (let key in robotlv) {
								let v = robotlv[key]
								if (config.role_lv >= Number(v.lv[0]) && config.role_lv <= Number(v.lv[1])) {
									power_range = v.power_range
								}
							}
							//最好是配表创建，随机又要考虑装备的性别和职业，又要考虑装备等级和总战力，麻烦
							let rholyorgan = JSON.parse(random_robot.rholyorgan)
							let rfly = ErlangParser.GetInstance().Parse(random_robot.rfly)
							let rmount = ErlangParser.GetInstance().Parse(random_robot.rmount)
							let figure_list = [{ figure_type: 5, figure_id: Number(rholyorgan[0][1][0]), figure_chartlet_id: 0 }, //武器
							{ figure_type: 4, figure_id: 1800010, figure_chartlet_id: 0 },
							{ figure_type: 3, figure_id: Number(rfly[0]), figure_chartlet_id: 0 }, //翅膀
							{ figure_type: 2, figure_id: 1200001, figure_chartlet_id: 0 },
							{ figure_type: 1, figure_id: Number(rmount[0]), figure_chartlet_id: 0 }, //坐骑
							{ figure_type: 10, figure_id: 1100001, figure_chartlet_id: 0 }]
							let equip_list = []
							table.insert(equip_list, { color: 4, goods_id: 0, type_id: 102084011, cell: 8 }) //护腕
							table.insert(equip_list, { color: 4, goods_id: 0, type_id: 102044011, cell: 4 }) //衣服
							table.insert(equip_list, { color: 4, goods_id: 0, type_id: 102064011, cell: 6 }) //腿
							table.insert(equip_list, { color: 4, goods_id: 0, type_id: 102014011, cell: 1 }) //武器
							table.insert(equip_list, { color: 4, goods_id: 0, type_id: 102024021, cell: 2 }) //头冠
							table.insert(equip_list, { color: 4, goods_id: 0, type_id: 101054031, cell: 5 }) //护肤
							table.insert(equip_list, { color: 4, goods_id: 0, type_id: 101034021, cell: 3 }) //项链
							table.insert(equip_list, { color: 4, goods_id: 0, type_id: 101104011, cell: 10 }) //鞋子
							let level_model_list = []
							// let career
							let picture = 90
							if (sex == 1 || sex == 0) {
								table.insert(level_model_list, { part_pos: 1, level_model_id: 1111 }) //人物模型
								table.insert(level_model_list, { part_pos: 2, level_model_id: 1100 }) //武器
								table.insert(level_model_list, { part_pos: 3, level_model_id: 1100 }) //头发
								// career = 1
								sex = 1
								// picture = 1
							} else {
								table.insert(level_model_list, { part_pos: 1, level_model_id: 1213 }) //人物模型
								table.insert(level_model_list, { part_pos: 2, level_model_id: 1200 }) //武器
								table.insert(level_model_list, { part_pos: 3, level_model_id: 1213 }) //头发
								// career = 2
								sex = 2
								// picture = 2
							}
							newRobot = [{
								level_model_list: level_model_list, fazhen_id: 0, realm: 0, figure_list: figure_list, equip_list: equip_list,
								name: name, career: config.career, achv_lv: 21, title_id: 0, level: config.role_lv, guild_id: 0,
								guild_name: "", turn: 0, vip_flag: 0, house_lv: 0, sex: sex, touxian: 0, supreme_vip: 0, dsgt_id: 0,
								combat: Util.RandomRange(power_range[0], power_range[1]), channel: local_CHAT_TYPE.WORLD, picture: picture, player_id: 0,
								suit_fashion_id: 0, revelation_suit: 0, iType: 1, msg: "", medal_id: 2
							}]
							RobotDic_[config.type + "_" + config.role_no] = newRobot
						}

						if ((!findName)
						) {
							let random = Util.RandomRange(1, nameLen)
							let GetName = () => {
								do {
									random = Util.RandomRange(1, nameLen)
									if (config.sex == robot_name_config_[random].sex || config.sex == 0 || robot_name_config_[random].sex == 0) {
										if (!NameDic_[random]) {
											sex = config.sex
											name = Trim(robot_name_config_[random].name)
											NameDic_[random] = config.type + "_" + config.role_no
											findName = true
											creat()
											break
										}
									}
								} while (true)
							}

							// if (!NameDic_[random]) {
							// 	GetName()
							// 	sex=config.sex
							// 	name = Trim(robot_name_config_[random].name)
							// 	NameDic_[random] = config.type + "_" + config.role_no
							// 	findName = true
							// 	creat()
							// }else{

							GetName()
							// }
						} else {
							// newRobot["player_id"] = Robot.player_id
							// newRobot["name"] = Trim(Robot.name)
							// newRobot["level"] = Robot.level
							// newRobot["career"] = Robot.career
							// newRobot["channel"] = Robot.channel
							// newRobot["picture"] = '1'
							newRobot = Robot
						}
					}
					if (Robot) {
						newRobot = Robot
					}
					newRobot[0]["msg"] = Trim(config.content)
					let time = config.gap
					index = index + 1
					time = time ? (time) : (0)
					setTimeout(() => {
						let chatList = this.getChannelChat(local_CHAT_TYPE.WORLD)
						let data = Util.DeepCopy(newRobot[0])
						data["time"] = local_TimeUtil.getServerTime()
						// table.insert(chatList, data)
						// this.channelChatDic[local_CHAT_TYPE.WORLD] = chatList
						if (!this.channelChatDic[local_CHAT_TYPE.WORLD]) {
							this.channelChatDic[local_CHAT_TYPE.WORLD] = []
						}
						this.channelChatDic[local_CHAT_TYPE.WORLD].push(data)
						this.Fire(local_ChatModelEvent.CHAT_CHANNEL_MSG_UPDATE, local_CHAT_TYPE.WORLD, data)
						this.Fire(local_ChatModelEvent.CHAT_MSG_CHANGE, local_CHAT_TYPE.WORLD, data)
						sendRobotChat()
					}, time * 1000)

				}
				sendRobotChat()
			}
		}
	}



	public static GetInstance() {
		if (!ChatModel.Instance) {
			ChatModel.Instance = new ChatModel()
		}
		return ChatModel.Instance
	}

	public faceMax() {
		return this._faceMax
	}

	public faceList() {
		let list = []
		let i = 0
		do {
			table.insert(list, i)
			i = i + 1
		} while ((i <= this.faceMax())
		)
		return list
	}

	public allChat() {
		let list = []
		for (let key in this.channelChatDic) {

			if ((Number(key) == CHAT_TYPE.GUILD_QUIZ || Number(key) == CHAT_TYPE.SYSTEM) || Number(key) == CHAT_TYPE.PRIVATE_CHAT) {

			} else {
				let clist = this.channelChatDic[key]
				let level = RoleManager.GetInstance().GetMainRoleVo().level
				if (Number(key) == CHAT_TYPE.SMALL_KUAFU && level < this.ViewClassCFG[CHAT_TYPE.SMALL_KUAFU].openLevel) {

				} else {
					list = list.concat(clist)
				}
			}
		}
		table.sort(list, (a?, b?) => {
			return a.time < b.time
		}
		)
		list = list.slice(Math.max(list.length - this.chatMax, 0), list.length)
		//list = table.slice(list, Math.max(list.length - this.chatMax, 0), list.length)
		return list
	}

	public sysChat() {
		let list = []
		for (let key in this.channelChatDic) {

			if (Number(key) == CHAT_TYPE.SYSTEM) {
				// [ts2lua]this.channelChatDic下标访问可能不正确
				let clist = this.channelChatDic[key]
				list = list = list.concat(clist)
			}
		}
		table.sort(list, (a?, b?) => {
			return a.time < b.time
		}
		)
		list = list.slice(Math.max(list.length - this.chatMax, 0), list.length)
		//list = table.slice(list, Math.max(list.length - this.chatMax, 0), list.length)
		return list
	}

	// function ChatModel.__getters.haveNewPrivateChat()
	//   if (FriendModel.GetInstance().private_chat_view_open ) {
	//     return false
	//   }
	//   let privateChatDic = this.getChannelChat(CHAT_TYPE.PRIVATE_CHAT)
	//   for (let key in privateChatDic) {

	//     // [ts2lua]privateChatDic下标访问可能不正确
	//     let chatObj = privateChatDic[key]
	//     if (chatObj[1] > 0 ) {
	//       return true
	//     }
	//   }
	//   return false
	// }

	public kuaFuOpenData() {
		return this._KuafuOpen
	}

	public chatTabList() {
		let openDay = ServerTimeModel.GetInstance().GetOpenServerDay()
		let level = RoleManager.GetInstance().GetMainRoleVo().level
		let viewList = []
		let labels = []
		let channelList = []
		for (let key in this.ViewClassCFG) {
			let info = this.ViewClassCFG[key]
			if ((openDay >= info.openDay && level >= info.openLevel) && this.checkChanneOpen(info)) {
				table.insert(viewList, info.class)
				table.insert(labels, info.label)
				table.insert(channelList, info)
			}
		}
		table.sort(channelList, (a?, b?) => {
			return a.index < b.index
		})
		return channelList
	}

	public SmallKuaFuOpen() {
		return this._smallKuaFuOpen
	}


	//添加参数
	public AddArgs(key, t) {
		//只能保存一个
		// if (! Util.IsTableEmpty(this.chat_args_dic) ) {
		// 	this.chat_args_dic = []
		// }
		this.chat_args_dic[key] = t
	}

	//是否存在聊天参数
	public IsHasArgs(str) {
		for (let w in str.match(str, "<.->")) {
			if (this.chat_args_dic[w] != null) {
				return w
			}
		}
		return false
	}

	//获取并组装所有聊天参数
	public GetAllArgsText(str) {
		//目前能保存多个key，每次替换Input<>内容，遍历dic与<>内容作比较，有则发送参数，可用于发送多个道具信息
		//只发送一个则可以只保存单个参数，不需要用到dic结构（对比优化）
		let text = ""
		for (let w in str.match(str, "<.->")) {
			if (this.chat_args_dic[w] != null) {
				text = text + this.chat_args_dic[w][1] + ","
			}
		}
		text = text.substring(0, text.length - 3)
		return "[" + text + "]"
	}

	//获取超链接文本
	public GetHyperlinkText(str) {
		let text = ""
		for (let w in str.match(str, "<.->")) {
			if (this.chat_args_dic[w] != null) {
				// text = LanguageFilter.ConvPartten(w)
				str = str.replace(str, text, this.chat_args_dic[w][2])
			}
		}
		return str
	}

	public ReplaceInputTextMark(input_text, str) {
		//替换规则是"(<.->)"
		let text = input_text.text
		let old_args = this.IsHasArgs(text)
		if ((text.indexOf("(<.->)") && old_args)) {
			// old_args = LanguageFilter.ConvPartten(old_args)
			input_text.text = text + text.replace(old_args, str)
		} else {
			input_text.text = text + str
		}
	}

	public EncryMsgForGoodsItem(goodVo) {
		// let content = null
		// if (goodVo.type == 10 ) { //装备
		// 	egret.log("type_id, goods_id, role_id", goodVo.type_id, goodVo.goods_id, RoleManager.Instance.mainRoleInfo.role_id)
		// 	content = string.format("<a@goods6@%s@%s@%s></a>", goodVo.type_id, goodVo.goods_id, RoleManager.Instance.mainRoleInfo.role_id)
		// }else{
		// 	content = string.format("<a@goods4@%s></a>", goodVo.type_id)
		// }
		// content = string.format("<a@goods@%s></a>", goodVo.type_id)
		// let type_id = String(goodVo.type_id)
		// let goods_id = String(goodVo.goodVo.goods_id)
		// content = "<a@goods@" + type_id + "></a>"
		// let args = "{goods," + type_id + "," + goods_id + "}"
		// let str = "<" + Trim(goodVo.goods_name) + ">"
		// if (goodVo.type == 11 && (goodVo.subtype == 10 || goodVo.subtype == 11)) {
		// 	let type_id, _name, icon = EquipModel.GetInstance().GetIdentifyGoodsNameAndIcon(goodVo.type_id, RoleManager.Instance.mainRoleInfo.career, goodVo.color, true)
		// 	str = "<" + _name + ">"
		// }
		// // egret.log("数据:", str, args, content)
		// this.AddArgs(str, { args, content })
		// return str
	}

	public ClearChatDic() {
		this.channelChatDic = []
		this.hide_vip_dic = []
	}

	public static IsChinese(s: string) {
		if (!this.chineseReg)
			this.chineseReg = new RegExp('^[\u4E00-\u9FFF]+$');
		if (!this.chineseReg.test(s)) {
			return false;
		}
		else {
			return true;
		}
	}

	public static IsChieseSymbol(s: string) {
		let reg = ChatModel.CHINES_REG

		if (s.search(reg) != -1) {
			return true;
		}
		else {
			return false;
		}
	}

	public replaceAHtml(s: string) {

	}
}

window["ChatModel"] = ChatModel
import { Config } from "../common/Config";
import { CookieWrapper } from "../common/CookieWrapper";
import { EventName } from "../common/EventName";
import { FigureProtoVo } from "../common/FigureProtoVo";
import { ModuleType, RedDotManager } from "../common/RedDotManager";
import { ResManager } from "../common/ResManager";
import { WordManager } from "../common/WordManager";
import { RoleManager } from "./RoleManager";
import { MainRoleVo } from "../sharedata/MainRoleVo";
import { ModelPartPos } from "../sharedata/RoleVo";
import { Message } from "../sysInfo/SysInfoController";
import { ClientConfig, GlobalEventSystem } from "../util/DeclareGlobalVar";
import { EventDispatcher } from "../util/EventDispatcher";
import { TimeUtil } from "../util/TimeUtil";
import { Util } from "../util/Util";
import { BaseDungeonModel, DUN_TYPE } from "./BaseDungeonModel";
import { ChatModel, ChatModelEvent, CHAT_TYPE } from "./ChatModel";
import { FriendEvent, FriendModel, FRIEND_TYPE } from "./FriendModel";
import { GoodsModel } from "./GoodsModel";
import { MainFunc } from "./MainUIModel";
import { BanquetModel } from "./BanquetModel";
import { PlatformManager } from "../PlatformManager";
import { ViewPopLevelModel } from "./ViewPopLevelModel";



export const MarriageEvent = {
	REQUEST_PROTO: "MarriageEvent.REQUEST_PROTO",
	SEND_ISSUE_INFO: "MarriageEvent.SEND_ISSUE_INFO",
	ADD_TAG: "MarriageEvent.ADD_TAG",
	SUB_TAG: "MarriageEvent.SUB_TAG",
	SAVE_TAG: "MarriageEvent.SAVE_TAG",
	GIVE_GIFT: "MarriageEvent.GIVE_GIFT",
	UPDATE_PLEASE_STATE: "MarriageEvent.UPDATE_PLEASE_STATE",
	UPDATE_FLOWER_RECORD: "MarriageEvent.UPDATE_FLOWER_RECORD",
	UPDATE_FRIEND_INFO: "MarriageEvent.UPDATE_FRIEND_INFO",
	GET_FLOWER: "MarriageEvent.GET_FLOWER",
	GIVE_GIFT_SUCCESS: "MarriageEvent.GIVE_GIFT_SUCCESS",
	CHANGE_KEY_VALUE: "MarriageEvent.CHANGE_KEY_VALUE",
	SHOW_FLOWER_EFFECT: "MarriageEvent.SHOW_FLOWER_EFFECT",
	STOP_FLOWER_EFFECT: "MarriageEvent.STOP_FLOWER_EFFECT",
	THANKS_FLOWER: "MarriageEvent.THANKS_FLOWER",
	GET_GIFT: "MarriageEvent.GET_GIFT",
	UPDATE_ROLE_DATA: "MarriageEvent.UPDATE_ROLE_DATA",
	STOP_RING_UPGRADE: "MarriageEvent.STOP_RING_UPGRADE",
	RING_UPGRADE_SUCCESS: "MarriageEvent.RING_UPGRADE_SUCCESS",
	RING_UPGRADE_STAR: "MarriageEvent.RING_UPGRADE_STAR",
	UPDATE_DSGT: "MarriageEvent.UPDATE_DSGT",
	TAB_BTN_CLICK: "MarriageEvent.TAB_BTN_CLICK",
	DUN_TAB_BTN_CLICK: "MarriageEvent.DUN_TAB_BTN_CLICK",
	REF_FORESHOW: "MarriageEvent.REF_FORESHOW"
}

export const MarriageDefine = {
	TAG_MAX_COUNT: 8,
	TAG_SAVE_SIGN: "#",
	STAR_MAX_COUNT: 10,
	DUN_ID: 13001,
	FLOWER_BATCH_COUNT: 3,
	OPEN_LV: 170,
	ICON_OPEN_LV_1: 10,
	ICON_OPEN_LV_2: 75
}

export enum MarriageFunID {
	Friend = 0,
	Main,
	Ring,
	Gift,
	Dun,
}

export const MarriageAskCfg = {
	"1": { color: "#6478bf", bg: "uijh_047a", ring: "uijh_045a", name: "uijh_048a", zero_reward: [[0, 40010001, 1], [0, 40020003, 1]], reward: [[0, 40020003, 1]] },
	"2": { color: "#8e41b4", bg: "uijh_047b", ring: "uijh_045b", name: "uijh_048b", zero_reward: [[0, 40010001, 1], [0, 40020001, 1], [0, 12010005, 1]], reward: [[0, 40020001, 1], [0, 12010005, 1]] },
	"3": { color: "#db3b4e", bg: "uijh_047c", ring: "uijh_045c", name: "uijh_048c", zero_reward: [[0, 40010001, 1], [0, 40020002, 1], [0, 12010005, 1]], reward: [[0, 40020002, 1], [0, 12010005, 1]] },
}

export const MarriageFlowCfg = [
	{ id: 1, banner: "uijh_059a", title: "uijh_059b", btn: "前往邂逅", tips: "添加<font color='#FFFF99'>1名好友</font>，开启浪漫之旅" },
	{ id: 2, banner: "uijh_060a", title: "uijh_060b", btn: "赠礼给Ta", tips: "与好友<font color='#FFFF99'>互赠礼物</font>，提升双方亲密度" },
	{ id: 3, banner: "uijh_061a", title: "uijh_061b", btn: "我要求婚", tips: "等级到达<font color='#FFFF99'>170级</font>后，即可向对方求婚" },
	{ id: 4, banner: "uijh_062a", title: "uijh_062b", btn: "举行婚礼", tips: "举行<font color='#FFFF99'>浪漫婚宴</font>，与TA相守相伴" },
]

export const MarriageStateCfg = {
	"Single": { pic: "uijh_065" },
	"Self": { pic: "uijh_066" },
	"OutLine": { pic: "uijh_067" },
	"Married": { pic: "uijh_069" },
}

export const MarriageRecordType = {
	Self: 2,
	Other: 3,
}

export const MarriageRedList = [
	ModuleType.MARRIAGE_GIFT,
	ModuleType.MARRIAGE_RING,
	ModuleType.MARRIAGE_ASK,
]
window["MarriageEvent"] = MarriageEvent
window["MarriageDefine"] = MarriageDefine
window["MarriageFunID"] = MarriageFunID
window["MarriageAskCfg"] = MarriageAskCfg
window["MarriageFlowCfg"] = MarriageFlowCfg
window["MarriageStateCfg"] = MarriageStateCfg
window["MarriageRecordType"] = MarriageRecordType
window["MarriageRedList"] = MarriageRedList


export class MarriageModel extends EventDispatcher {
	// Bind(GIVE_GIFT_SUCCESS: any, arg1: (scmd: any) => void): any {
	// 	throw new Error("Method not implemented.");
	// }
	static Instance: MarriageModel;
	private _mate_info;
	private _gift_info;
	private _ring_info;
	private _flower_info;
	public _hide_buy_tips = false; //购买钻石提示
	public _red_gift_mark = false;
	public _ring_cost_data;
	public is_alert_friend = true
	private _ring;
	// private _dsgt_data_list;
	// private _dsgt_max_love_num;

	//function
	Reset
	SetFriendInfo
	GetFriendInfo
	GetFriendData
	SetMateInfo
	GetMateInfo
	SetGiftInfo
	GetGiftInfo
	SetRingInfo
	GetRingInfo
	GetRingStageData
	GetRingStarData
	GetNextRingStarData
	GetConstantData
	SetRingCostData
	GetTagsByList
	GetTagsStr
	SetTagDataList
	GetTagDataList
	GetTagData
	GetAskDataList
	GetCanMarriageFriendList
	GetCanMarriageFriendListOutIntimacy
	GetCanDunFriendList
	GetFriendList
	GetRoleClotheId
	GetWeaponClotheId
	GetWingClotheId
	GetBackOrnamentClotheId
	GetLivenessId
	GetDsgtAttrStr
	GetHonourAttrStr
	GetRingAttrStr
	GetTagListByCookie
	GetGiftDataByType
	SetLoveNum
	SetKeyValue
	GetRoleFame
	AddRoleFame
	GetFlowerList
	GetFlowerData
	GetFameList
	SetRoleFlowerInfo
	GetRoleFlowerInfo
	HiToChat
	ThanksToChat
	ChatToRole
	OpenChatView
	PlayFlowerEffect
	PlayFlowerEffectByName
	ClearFlowerEffect
	GetFlowerEffectList
	UpadteIconRedStatus
	SetRedStatus
	CheckGiftRedStatus
	CheckRingRedStatus
	CheckAskRedStatus
	GetDunInfo
	CheckRedStatus
	InitCfg
	RefForeShowIcon
	ClickForeShowFunc
	cash_icon
	old_lv
	show_icon
	GetForeShowIcon
	BoardMarriager
	IsCanGet
	constructor() {
		super()
		let mainui_foreshow = [[MarriageDefine.ICON_OPEN_LV_1, MarriageDefine.ICON_OPEN_LV_2, "marriage_1"], [MarriageDefine.ICON_OPEN_LV_2, MarriageDefine.OPEN_LV, "marriage_2"]]
		// this.InitCfg()
		let config_preload_server = Config.PRELOAD_SERVER_CONFIG,
			local_MarriageEvent = MarriageEvent,
			local_MarriageDefine = MarriageDefine,
			friend_model = FriendModel.GetInstance(),
			local_FRIEND_TYPE = FRIEND_TYPE,
			role_mgr = RoleManager.GetInstance(),
			local_ModelPartPos = ModelPartPos,
			local_FigureProtoVo = FigureProtoVo,
			local_WordManager = WordManager,
			local_Util = Util,
			local_GlobalEventSystem = GlobalEventSystem,
			local_EventName = EventName,
			red_dot_mgr = RedDotManager.GetInstance(),
			local_ModuleType = ModuleType,
			goods_model = GoodsModel.GetInstance(),
			res_mgr = ResManager.GetInstance(),
			_cfg_dic_ = {},
			_friend_dic_ = {},
			_tag_data_list_,
			_flower_effect_list_ = []
		this.InitCfg = () => {
			_cfg_dic_["config_marriage_constant"] = Config.PRELOAD_SERVER_CONFIG.config_marriage_constant
			_cfg_dic_["config_ring_star"] = Config.PRELOAD_SERVER_CONFIG.config_ring_star
			_cfg_dic_["config_flower_tools"] = Config.PRELOAD_SERVER_CONFIG.config_flower_tools

			this.SetTagDataList()
			// this.SetDsgtDataList()
			this.SetRingCostData()
		}

		this.Reset = () => {
			// this._friend_info = undefined
			this._mate_info = undefined
			this._gift_info = undefined
			this._flower_info = undefined
			this._ring_info = undefined
		}

		//交友大厅数据
		this.SetFriendInfo = (scmd) => {
			// this.ChangeVar("_friend_info", scmd, false, true)
			_friend_dic_[scmd.page] = scmd
			this.Fire(local_MarriageEvent.UPDATE_FRIEND_INFO, scmd)
		}

		this.GetFriendInfo = (page) => {
			return _friend_dic_[page]
		}

		this.GetFriendData = (page, role_id) => {
			let info = this.GetFriendInfo(page)
			if (!info) return
			for (let data of info.player_list) {
				if (role_id == data.role_id) {
					return data
				}
			}
		}

		//我的伴侣数据
		this.SetMateInfo = (scmd) => {
			this.ChangeVar("_mate_info", scmd, false, true)
		}

		this.GetMateInfo = () => {
			return this._mate_info
		}

		//礼包数据
		this.SetGiftInfo = (scmd) => {
			this._gift_info = scmd
			this.CheckGiftRedStatus()
			this.ChangeVar("_gift_info", scmd, false, true)
		}

		this.GetGiftInfo = () => {
			return this._gift_info
		}

		//戒指数据
		this.SetRingInfo = (scmd, show_animation = false) => {
			this._ring_info = scmd
			this.CheckRingRedStatus()
			this.ChangeVar("_ring_info", scmd, false, true, show_animation)
		}

		this.GetRingInfo = () => {
			return this._ring_info
		}

		this.GetRingStageData = (stage, cfg) => {
			return cfg[stage]
		}

		this.GetRingStarData = (stage, star) => {
			return _cfg_dic_["config_ring_star"][`${stage}@${star}`]
		}

		this.GetNextRingStarData = (stage, star) => {
			let over = star + 1 > local_MarriageDefine.STAR_MAX_COUNT
			star = over ? 1 : star + 1
			stage = over ? stage + 1 : stage
			let nsdata = this.GetRingStarData(stage, star)
			return nsdata
		}

		//获取常量配置
		this.GetConstantData = (key) => {
			if (_cfg_dic_["config_marriage_constant"]) {
				let data = _cfg_dic_["config_marriage_constant"][key]
				return data && data.constant
			}
		}

		//设置称号数据列表
		// this.SetDsgtDataList = () => {
		//     this._dsgt_data_list = []
		//     let tag_dic = {}
		//     let dic = _cfg_dic_["config_love_dsgt_cfg"]
		//     this._dsgt_max_love_num = 0
		//     for (let key in dic) {
		//         if (this._dsgt_max_love_num < dic[key].love_num) {
		//             this._dsgt_max_love_num = dic[key].love_num
		//         }
		//         this._dsgt_data_list.push(dic[key])
		//     }
		//     this._dsgt_data_list.sort((a, b) => {
		//         return a.love_num - b.love_num
		//     })
		// }

		//设置升级道具数据
		this.SetRingCostData = () => {
			let data = this.GetConstantData(7)
			let cost = JSON.parse(data)[0]
			this._ring_cost_data = { type_id: cost[0], exp: cost[1] }
		}

		// this.GetDsgtMaxLoveNum = () => {
		//     return this._dsgt_max_love_num
		// }

		// // 获取称号数据列表
		// this.GetDsgtDataList = () => {
		//     return this._dsgt_data_list
		// }

		// //获取称号配置
		// this.GetDsgtData = (id) => {
		//     return _cfg_dic_["config_love_dsgt_cfg"][id]
		// }

		//获取标签数据
		this.GetTagsByList = (tag_list) => {
			let tag_dic = _cfg_dic_["config_personal_tag_info"]
			let list = []
			for (let info of tag_list) {
				list.push(tag_dic[`${info.tag_id}@${info.tag_subid}`])
			}
			return list
		}

		//获取所有标签组成的字符串
		this.GetTagsStr = (tag_list) => {
			let list = this.GetTagsByList(tag_list)
			// let list = tag_list
			let str = ""
			for (let info of list) {
				str += `${info.tag_subid_name}、`
			}
			str = str.substring(0, str.length - 1)
			return str
		}

		//设置标签数据列表
		this.SetTagDataList = () => {
			_tag_data_list_ = []
			let tag_dic = {}
			let dic = _cfg_dic_["config_personal_tag_info"]
			for (let key in dic) {
				let info = dic[key]
				if (!tag_dic[info.tag_id]) {
					tag_dic[info.tag_id] = {
						tag_mark: false,
						tag_id: info.tag_id,
						tag_id_name: info.tag_id_name,
						tag_list: []
					}
					_tag_data_list_.push(tag_dic[info.tag_id])
				}
				tag_dic[info.tag_id].tag_list.push(info)
			}
		}

		this.GetTagDataList = () => {
			return _tag_data_list_
		}

		this.GetTagData = (tag_id, tag_subid) => {
			return _cfg_dic_["config_personal_tag_info"][`${tag_id}@${tag_subid}`]
		}

		this.GetAskDataList = (cfg) => {
			let dic = cfg
			let list = []
			for (let key in dic) {
				list.push(dic[key])
			}
			return list
		}

		this.GetCanMarriageFriendList = (): [any, any] => {
			let list = []
			let fList = friend_model.getFriendDataReturnNew(local_FRIEND_TYPE.FRIEND)
			let need_fire = fList.length < 1
			if (!need_fire) {
				let need_intimacy = this.GetConstantData(9)
				let role_vo = role_mgr.GetMainRoleVo()
				for (let info of fList) {
					if (info.role_id != role_vo.marriage_id && info.marriage_type == 2) continue
					if (info.intimacy < need_intimacy) continue
					if (info.sex == role_vo.sex && info.role_id != role_vo.marriage_id) continue
					if (info.lv < local_MarriageDefine.OPEN_LV) continue
					list.push(info)
				}
				list.sort((a, b) => {
					return b.intimacy - a.intimacy
				})
			}
			return [need_fire, list]
		}

		this.GetCanMarriageFriendListOutIntimacy = (): [any, any] => {
			let list = []
			let fList = friend_model.getFriendDataReturnNew(local_FRIEND_TYPE.FRIEND)
			let need_fire = fList.length < 1
			if (!need_fire) {
				let role_vo = role_mgr.GetMainRoleVo()
				for (let info of fList) {
					if (info.marriage_type == 2) continue
					if (info.sex == role_vo.sex) continue
					if (info.lv < local_MarriageDefine.OPEN_LV) continue
					list.push(info)
				}
				list.sort((a, b) => {
					return b.intimacy - a.intimacy
				})
			}
			return [need_fire, list]
		}

		// this.GetCanDunFriendList = (): Array<FriendVo> => {
		this.GetCanDunFriendList = (): Array<any> => {
			let list = []
			let fList = friend_model.getFriendDataReturnNew(local_FRIEND_TYPE.FRIEND)
			let role_vo = role_mgr.GetMainRoleVo()
			let married_s = role_vo.marriage_id
			//新增同性好友达到亲密度也能邀请
			let need_intimacy = this.GetConstantData(18)
			for (let info of fList) {
				if (married_s != info.role_id && info.online_flag == 0) continue
				if (info.sex == role_vo.sex && info.role_id != married_s && info.intimacy < need_intimacy) continue
				list.push(info)
			}
			list.sort((a, b) => {
				return b.intimacy - a.intimacy
			})
			return list
		}

		this.GetFriendList = (): [any, any] => {
			let fList = friend_model.getFriendDataReturnNew(local_FRIEND_TYPE.FRIEND)
			let need_fire = fList.length < 1
			if (!need_fire) {
				fList.sort((a, b) => {
					return b.intimacy - a.intimacy
				})
			}
			return [need_fire, fList]
		}

		//取时装衣服贴图id
		this.GetRoleClotheId = (obj) => {
			let [role_res,idi] = Util.GetRoleClotheId(obj)
			return role_res

			// //天启套装
			// let revelation_suit = obj.revelation_suit
			// if (revelation_suit) {
			// 	return Util.GetRevelationClothesRes(revelation_suit,obj.sex)
			// }

			// let model_res_list = obj.fashion_model_list
			// if (model_res_list) {
			// 	for (let v of model_res_list) {
			// 		if (v.part_pos == local_ModelPartPos.Clothe)
			// 			return v.fashion_model_id
			// 	}

			// }

			// model_res_list = obj.level_model_list;
			// if (model_res_list){
			// 	for (let v of model_res_list){
			// 		if (v.part_pos == local_ModelPartPos.Clothe)
			// 		return v.level_model_id;
			// 	}
			// }
				
		}

		//先去时装模型列表的 再取等级模型id列表的武器
		this.GetWeaponClotheId = (obj) => {
			let model_res_list = obj.fashion_model_list;
			if (model_res_list)
				for (let v of model_res_list)
					if (v.part_pos == local_ModelPartPos.Weapon)
						return v.fashion_model_id;
			let figure_list = obj.figure_list
			if (figure_list)
				for (let v of figure_list)
					if (v.figure_type == local_FigureProtoVo.FigureType.Weapon)
						return v.figure_id

			model_res_list = obj.level_model_list;
			if (model_res_list)
				for (let v of model_res_list)
					if (v.part_pos == local_ModelPartPos.Weapon)
						return v.level_model_id;
		}

		//先去时装模型列表的 再取等级模型id列表的武器i
		this.GetWingClotheId = (obj) => {
			if (obj.figure_list)
				for (let v of obj.figure_list)
					if (v.figure_type == local_FigureProtoVo.FigureType.Wing)
						return v.figure_id
		}
		this.GetBackOrnamentClotheId = (obj) => {
			if (obj.figure_list)
				for (let v of obj.figure_list)
					if (v.figure_type == local_FigureProtoVo.FigureType.NewBackOrnament)
						return v.figure_id
		}
		this.GetLivenessId = (obj) => {
			if (obj.liveness_id)
				return obj.liveness_id		
		}

		this.GetDsgtAttrStr = (attr_list: Array<any>, color: number): string => {
			let str = ""
			if (!attr_list) return str
			for (let i = 0; i < attr_list.length; i++) {
				let attr = attr_list[i]
				// let line = i + 1 != attr_list.length && i % 2 != 0 ? "\n" : "\t"
				let line = i + 1 != attr_list.length && i % 2 != 0 ? "<br/>" : "&nbsp;"
				let value = local_WordManager.ConvertToPercentValue(attr[0], attr[1])
				str = str + `${local_WordManager.GetProperties(attr[0])}：${local_Util.HtmlColorTxt(value, color)}` + line
			}
			return str
		}

		this.GetHonourAttrStr = (attr_list: Array<any>, color: number): string => {
			let str = ""
			if (!attr_list) return str
			for (let i = 0; i < attr_list.length; i++) {
				let attr = attr_list[i]
				let value = local_WordManager.ConvertToPercentValue(attr[0], attr[1])
				str = str + `${local_WordManager.GetProperties(attr[0])}：${local_Util.HtmlColorTxt(value, color)}` + "&nbsp;&nbsp;&nbsp;"
			}
			return str
		}

		this.GetRingAttrStr = (attr_list: Array<any>, nattr_list: Array<any>, color: number): string => {
			let str = ""
			if (!attr_list) return str
			let dic = {}
			for (let i = 0; i < attr_list.length; i++) {
				let attr = attr_list[i]
				dic[attr[0]] = attr[1]
			}
			let length = Math.max(nattr_list.length, attr_list.length)
			let list = nattr_list.length > attr_list.length ? nattr_list : attr_list
			for (let i = 0; i < length; i++) {
				let line = i + 1 != length ? "<br/>" : ""
				let attr = list[i]
				let value = dic[attr[0]] || 0
				let pname = local_WordManager.GetProperties(attr[0])
				let dvalue = attr[1] - value
				value = local_WordManager.ConvertToPercentValue(attr[0], value)
				if (dvalue > 0) {
					let svalue = `+${local_WordManager.ConvertToPercentValue(attr[0], dvalue)}`
					str = str + `${pname}:&nbsp;${local_Util.HtmlColorTxt(value, "'#d15e00'")} &nbsp;${local_Util.HtmlColorTxt(svalue, color)}` + line
				} else {
					str = str + `${pname}:${value}` + line
				}
			}
			return str
		}

		// this.CheckDsgtUnlock = (love_num) => {
		//     let dic = DsgtModel.GetInstance().GetDsgtInfoVo()
		//     let list = this.GetDsgtDataList()
		//     for (let info of list) {
		//         if (dic[info.id] && dic[info.id].status != 0) continue
		//         if (love_num >= info.love_num) {
		//             this.Fire(MarriageEvent.REQUEST_PROTO, 17236, "c", info.id)
		//         }
		//     }
		// }

		// this.GetDsgtFirstlockData = () => {
		//     let dic = DsgtModel.GetInstance().GetDsgtInfoVo()
		//     let list = this.GetDsgtDataList()
		//     for (let info of list) {
		//         if (dic[info.dsgt] && dic[info.dsgt].status != 0) continue
		//         return info
		//     }
		// }

		this.GetTagListByCookie = () => {
			let list = []
			let str = CookieWrapper.GetInstance().GetCookie(CookieWrapper.MARRIAGE_TAG_LIST_STR)
			if (!str || str == "") return list
			let str_list = str.split(local_MarriageDefine.TAG_SAVE_SIGN)
			for (let key of str_list) {
				let key_num = Number(key)
				let tag_id = key_num / 10000
				let tag_subid = key_num % 10000
				let data = this.GetTagData(tag_id, tag_subid)
				list.push(data)
			}
			return list
		}

		//1.购买奖励 2.登录奖励
		this.GetGiftDataByType = (type: number) => {
			let gift_info = this.GetGiftInfo()
			if (!gift_info) return
			for (let info of gift_info.gift_state) {
				if (info.count_type == type) {
					return info
				}
			}
		}

		this.SetLoveNum = (value: number) => {
			let minfo = this.GetMateInfo()
			if (!minfo) return
			minfo.love_num = value
		}

		this.SetKeyValue = (key, value) => {
			if (key == 1) {
				this.SetLoveNum(value)
			}
			this.Fire(local_MarriageEvent.CHANGE_KEY_VALUE, key, value)
		}


		////////////////////////////////////////鲜花//////////////////////////////////

		//获取玩家名誉值
		this.GetRoleFame = () => {
			if (!this._flower_info) return 0
			return this._flower_info.fame
		}

		this.AddRoleFame = (add_num) => {
			if (!this._flower_info) return
			this._flower_info.fame += add_num || 0
			this.ChangeVar("_flower_info", this._flower_info, false, true)
		}

		this.GetFlowerList = () => {
			let dic = _cfg_dic_["config_flower_tools"]
			let list = []
			for (let key in dic) {
				list.push(dic[key])
			}
			return list
		}

		this.GetFlowerData = (type_id) => {
			return _cfg_dic_["config_flower_tools"][type_id]
		}

		this.GetFameList = (config) => {
			let dic = config
			let list = []
			for (let key in dic) {
				list.push(dic[key])
			}
			return list
		}

		// this.GetFameLData = (id) => {
		//     return _cfg_dic_["config_fame_lv"][id]
		// }

		this.SetRoleFlowerInfo = (scmd) => {
			this.ChangeVar("_flower_info", scmd)
		}

		this.GetRoleFlowerInfo = () => {
			return this._flower_info
		}


		this.HiToChat = (role_id) => {
			this.ChatToRole(role_id, "嗨，我在茫茫人海中，一眼就遇到你了，来聊会可好")
		}

		this.ThanksToChat = (role_id) => {
			this.ChatToRole(role_id, "亲爱哒，谢谢你的礼物，笔芯~")
		}

		this.ChatToRole = (role_id, content) => {
			let roleVo: MainRoleVo = role_mgr.GetMainRoleVo()
			ChatModel.GetInstance().Fire(ChatModelEvent.CHAT_SEND_MSG, 11001, CHAT_TYPE.PRIVATE_CHAT, roleVo.province, roleVo.city, role_id, content, "", 0, "");
		}

		this.OpenChatView = (role_id) => {
			let friend_vo = friend_model.getFriendById(role_id);
			if (friend_vo)
				friend_model.Fire(FriendEvent.OPEN_CHAT_VIEW, friend_vo)
			else
				Message.show("对方不是您的好友!")
		}

		this.PlayFlowerEffect = (vo) => {
			if (_flower_effect_list_.length >= 20) {
				_flower_effect_list_.shift()
			}
			_flower_effect_list_.push(vo)
			this.Fire(local_MarriageEvent.SHOW_FLOWER_EFFECT)
		}

		this.PlayFlowerEffectByName = (name) => {
			let vo = { effect: name }
			this.PlayFlowerEffect(vo)
		}

		this.ClearFlowerEffect = () => {
			_flower_effect_list_.length = 0
		}

		this.GetFlowerEffectList = () => {
			return _flower_effect_list_
		}




		///////////////////////////////////红点/////////////////////////////////
		this.UpadteIconRedStatus = () => {
			let red = RedDotManager.GetInstance().CheckRedStatusMultModule(MarriageRedList)
			GlobalEventSystem.Fire(EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 172, red)
			local_GlobalEventSystem.Fire(local_EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 1721)
			local_GlobalEventSystem.Fire(local_EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Love)
		}

		this.SetRedStatus = (mtype, rtype, active) => {
			red_dot_mgr.SetRedStatus(mtype, rtype, active)
		}

		this.CheckRedStatus = (mtype, rtype?) => {
			return red_dot_mgr.CheckRedStatus(mtype, rtype)
		}

		this.CheckGiftRedStatus = () => {
			red_dot_mgr.ClearRedStatus(local_ModuleType.MARRIAGE_GIFT)
			let gift_info = this.GetGiftInfo()
			if (!gift_info) return
			let red = false

			// if (gift_info.love_gift_time_s >= TimeUtil.getServerTime()) {
			red = this.IsCanGet()
			this.SetRedStatus(local_ModuleType.MARRIAGE_GIFT, 1, red)
			// }



			if (gift_info.love_gift_time_o >= TimeUtil.getServerTime()) {
				let day_data = this.GetGiftDataByType(2)
				red = !day_data || (day_data.time <= TimeUtil.getServerTime())
				this.SetRedStatus(local_ModuleType.MARRIAGE_GIFT, 2, red)
			}
			if (!gift_info.love_gift_time_o && !gift_info.love_gift_time_s) {
				this.SetRedStatus(local_ModuleType.MARRIAGE_GIFT, 3, this._red_gift_mark)
			}
			this.UpadteIconRedStatus()
		}

		/**是否可以领取520绑玉  */
		this.IsCanGet = () => {
			let buy_data = this.GetGiftDataByType(1)
			return buy_data && buy_data.state == 0 && buy_data.time < TimeUtil.getServerTime()
		}

		this.CheckRingRedStatus = () => {
			red_dot_mgr.ClearRedStatus(local_ModuleType.MARRIAGE_RING)
			let rinfo = this.GetRingInfo()
			if (!rinfo) return
			let sdata = this.GetNextRingStarData(rinfo.stage, rinfo.star)
			if (!sdata) return
			if (sdata.upgrade_pray_num) {
				let own = goods_model.GetTypeGoodsNum(this._ring_cost_data.type_id)
				let can_up = own * this._ring_cost_data.exp >= sdata.upgrade_pray_num - rinfo.pray_num
				this.SetRedStatus(local_ModuleType.MARRIAGE_RING, 1, can_up)
			} else {
				if (rinfo.star == 0) {
					let own = goods_model.GetTypeGoodsNum(this.ring)
					let can_up = own >= 1
					this.SetRedStatus(local_ModuleType.MARRIAGE_RING, 1, can_up)
				} else
					this.SetRedStatus(local_ModuleType.MARRIAGE_RING, 1, false)
			}
			this.UpadteIconRedStatus()
		}



		this.CheckAskRedStatus = () => {
			let red = BanquetModel.GetInstance().canApply
			this.SetRedStatus(local_ModuleType.MARRIAGE_ASK, 1, red)
			this.UpadteIconRedStatus()
		}

		this.GetDunInfo = () => {
			let dun_list = BaseDungeonModel.GetInstance().GetDungeonInfo(DUN_TYPE.Marriage)
			if (dun_list) {
				for (let info of dun_list) {
					if (info.dun_id != local_MarriageDefine.DUN_ID) continue
					return info
				}
			}
		}


		this.RefForeShowIcon = () => {
			if (!PlatformManager.GetInstance().is_alpha) {
				let icon = null
				let lv = RoleManager.GetInstance().GetMainRoleVo().level
				let show_fly_anim = false

				for (let k = 0; k < mainui_foreshow.length; k++) {
					let v = mainui_foreshow[k]

					//改成任务开启
					// if (k == 0 && this.old_lv && this.old_lv < v[0] && lv >= v[0]) {
					// 	//show_fly_anim = true////75级打开 false
					// 	// local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "MarriageForeShowView", false, true)//75级打开 true
					// 	ViewPopLevelModel.GetInstance().SetViewPop('MarriageForeShowView', false, true);
					// }
					if (lv >= v[0] && lv < v[1]) {
						icon = v[2]
					}
				}


				if ((!this.cash_icon && icon) || (!icon && this.cash_icon) || icon != this.cash_icon) {
					if (!show_fly_anim) {
						this.Fire(local_MarriageEvent.REF_FORESHOW, icon)
						this.show_icon = icon
					}
					this.cash_icon = icon
				}
				this.old_lv = lv
			}
		}


		this.ClickForeShowFunc = () => {
			for (let k in mainui_foreshow) {
				var v = mainui_foreshow[k]
				let lv = RoleManager.GetInstance().GetMainRoleVo().level
				if (lv >= v[0] && lv < v[1]) {
					if (Number(k) == 0) {
						//包含百度标识不打开'玩家风采'界面
						if (PlatformManager.GetInstance().is_baidu_version || ClientConfig.not_show_marriagefore_view) {
							return
						}
						ViewPopLevelModel.GetInstance().SetView('MarriageForeShowView', false, false);
						// local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "MarriageForeShowView", false, false)
					} else {
						local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "MarriageFlowView")
					}
					return
				}
			}
		}

		this.GetForeShowIcon = (index?) => {
			if (mainui_foreshow && mainui_foreshow[index]) {
				return mainui_foreshow[index][2]
			}
		}


		this.BoardMarriager = () => {
			let roleVo = role_mgr.GetMainRoleVo()
			if (roleVo.level < 60) {
				return
			}
			let msg = "宝贝，我给你买了一个姻缘锦囊，爱你哟！<f_11>"
			let local_ChatModel = ChatModel.GetInstance()
			let [sendGoods, goods_id_list, sendGoodsMesg] = local_ChatModel.sendGoodsMesg(msg)
			local_ChatModel.Fire(ChatModelEvent.CHAT_SEND_MSG, 11001, CHAT_TYPE.PRIVATE_CHAT,
				roleVo.province, roleVo.city, roleVo.marriage_id, sendGoodsMesg, sendGoods, 0, "", roleVo.marriage_name)
		}

	}
	public static GetInstance() {
		if (!MarriageModel.Instance) {
			MarriageModel.Instance = new MarriageModel()
		}
		return MarriageModel.Instance
	}



	public get ring() {
		if (!this._ring)
			this._ring = this.GetConstantData(31);
		return this._ring;
	}
}
window["MarriageModel"] = MarriageModel
import { Alert, Alert_Type } from "../alert/Alert"
import { CommonManager } from "../common/CommonManager"
import { Config } from "../common/Config"
import { CongratulationObtainView } from "../common/CongratulationObtainView"
import { CookieWrapper } from "../common/CookieWrapper"
import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { UI_MODEL_TYPE } from "../common/UIModelClass3D"
import { ComActBtn } from "../customActivity/ComActBtn"
import { ComActTimerView } from "../customActivity/ComActTimerView"
//import { ComActBtn } from "../customActivity/ComActBtn"
//import { ComActRecordView } from "../customActivity/ComActRecordView"
//import { ComActTimerView } from "../customActivity/ComActTimerView"
import { ActivityIconManager } from "../commonModel/ActivityIconManager"
import { PlatformManager } from "../PlatformManager"
import { RoleManager } from "./RoleManager"
import { FashionPartPos, SceneBaseType } from "../scene/SceneConfig"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem, ClientConfig } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { EventDispatcher } from "../util/EventDispatcher"
import { Mathf } from "../util/Mathf"
import { TimeUtil } from "../util/TimeUtil"
import { Util, Split, Trim, SetAnchoredPositionX, SetAnchoredPositionY, SetLocalScale, SetLocalPositionX, SetLocalPositionY, HtmlColorTxt, DEVICE_OS, GlobalTimerQuest } from "../util/Util"
import { CustomActivityDefine, Enum_Btn_Type, Enum_Currency_Type } from "./CustomActivityDefine"
import { FirstBloodModel } from "./FirstBloodModel"
import { GoodsModel } from "./GoodsModel"
import { TaskModel } from "./TaskModel"
import { VipModel } from "./VipModel"
import { WelfareModel } from "./WelfareModel"
import { ComActRecordView } from "../customActivity/ComActRecordView"
import { LoginModel } from "../login/LoginModel"
import { GameResPath } from "../util/GameResPath"
import { DungeonEnterView } from "../dungeon/DungeonEnterView"
import { BaseDungeonModel } from "./BaseDungeonModel"
import { TurnTableModel } from "./TurnTableModel"
import { SaiboModel } from "./SaiboModel"
import { HotPointModel } from "../kfHotPoint/HotPointModel"
import { BossModel } from "./BossModel"
import { OneDollarSpikeModel } from './OneDollarSpikeModel';
import { TMap } from "../util/TMap"
import { ListDuobaoModel } from "./ListDuobaoModel"
import { FirstRechargeModel } from "./FirstRechargeModel"
import { RedEnvelopeRebateModel } from "./RedEnvelopeRebateModel"
import { IS2CTiredChargePoliteParam, TiredChargePoliteModel, TiredChargePoliteTaskState } from "./TiredChargePoliteModel"
import { DailyModel } from "./DailyModel"
import { isThisTypeNode } from "../../node_modules/typescript/lib/typescript"
import { CycleimpActlistModel } from "./CycleimpActlistModel"
import { QuestionNaireModel } from "./QuestionNaireModel"

export class CustomActivityModel extends EventDispatcher {
	static Instance: CustomActivityModel
	static CLOSE_VIPGIFT_VIEW = "CLOSE_VIPGIFT_VIEW"
	static LUCK_STONE_ID = 36255102 //幸运鉴宝 道具id
	static MATIAL_ICON_115 = `331@563`  //资源副本1.15倍
	/**幸运探宝  限时夺宝币 */
	static LUC_TREA_LIMIT = 38220003
	static KFActivityIconOpenTask = 100310

	static RewardType = {
		Default: 1,
		World: 4,
		Sex: 5,
		Level: 6,
		LevelAndSex: 7,
		WorldAddSex: 8,
	}

	static GetInstance() {
		if (!CustomActivityModel.Instance) {
			CustomActivityModel.Instance = new CustomActivityModel()
		}
		return CustomActivityModel.Instance
	}

	//活动格式化时间
	static GetTimeText(time, state?, color = "'#639c12'") {
		let dateStr = Math.floor(time / 60 / 60 / 24)
		let hoursStr = Math.floor(time / 60 / 60) % 24
		let minutesStr = Math.floor(time / 60) % 60
		let secondStr = time % 60
		switch (state) {
			case 1:

				break
			default:
				if (dateStr > 0)
					return `${Util.HtmlColorTxt(dateStr, color)}天${Util.HtmlColorTxt(hoursStr, color)}时${Util.HtmlColorTxt(minutesStr, color)}分`
				else
					return `${Util.HtmlColorTxt(hoursStr, color)}时${Util.HtmlColorTxt(minutesStr, color)}分${Util.HtmlColorTxt(secondStr, color)}秒`
		}
	}

	public cloud_purchase_history
	public cloud_purchase_real_end_time = 0
	public cache_scmd_33101_list
	public eggs_is_openAlert = true
	public moneyTree_is_openAlert = true
	public holyCall_is_openAlertList = {}
	public act_key_dic = {}     //存放活动键值对，如：是否跳过动画，弹窗本次登录不提示，用法 参考saiboMainView 
	public mount_turntable_is_openAlert = true
	public mount_turntable_jump_ani = false
	public zero_touch_grade = []
	public fvt_activeness_time = 0
	public rpr_icon_mark = true
	public luckyDuobao_buy_alert1 = false
	public luckyDuobao_buy_alert2 = false
	public send_proto
	public merge_gashapon_list
	public play_gashapon_auto_anim_end = false
	public need_show_reward
	public act_record_list = {}
	public act_timer_list = {}
	public lucky_sub_type
	public recharge_day_ = 0
	public topplayer_get_way_list = {}
	private destiny_info = { "show_index": 0, "goods_vo": 0, "need_count": 0, "target": 0 }
	private last_destiny_count = 0
	private destiny_turn_num = 0
	private destiny_getway = []
	private destiny_double_list = []
	private destiny_double_time = 0
	public zero_money_info
	public discountGift_is_jump_alert = false

	InitConfig
	SaveActInfo
	AddActInfo
	// DeleteSubType
	DeleteActInfo
	RefreshDeleteIcon
	UpdateActivityIcons
	AddActivityIcons
	DeleteActivityIcons
	GetAddIconList
	CheckSomeSpecialCond
	ClearActInfo
	GetActInfo
	GetActInfoByShowID
	RequireOverViewRew
	RequireActInfo
	RequireSpecialViewInfo
	IsActIcon
	GetOpenState
	CheckMoney
	SetActData
	SetOverViewData
	GetOverViewData
	GetActData
	GetAwardDataById
	SetActResult
	GetRedDotValue
	SetActRedDot
	GetSpecialRedDotValue
	RefreshIconRed
	GetKaiFuActivityRedDot
	SetRedDotValue
	RequireGetAward
	ResetData
	GetUIModelCfg
	ShowTimeDown
	SetActRecharge
	GetActRecharge
	UpdataRechargeSum
	GetRewardsBySex
	FreeCount
	UpdataACTGoodsNum
	CheckFirstRed
	CloseACTRed
	SetGradeRed
	GetGradeRed
	GetActInfoByType
	GetSpecialOpenState
	GetActivenessStatus
	FTVActivenessAllReward
	GetActIconType
	UpdateClouldPurchaseStageState
	SetActInfoCondition
	SetActDataCondition
	GetActCondition
	SetActDataAllCount
	GetFeastBossIconType
	CheckSpecialIcon
	CheckDayFristLogin
	CheckRewardIsAllGain
	GetDayFirstLoginStatus
	GetActReward
	GetActAllGrade
	ShowViewModel
	GetNameVerifyIconOpenState
	AddNameVerifyIcon
	DeleteSpecialIcon
	RefreshSpecialIcon
	GetFlowerRankOpenStatus
	ActivityNeedHideInAlpha
	getKeyDicValue
	setKeyDicValue
	getActInstructionId
	isCBPlatform
	JumpAct
	LoadCompontRes
	GetCompontRES
	LoadActTimer
	LoadActRecord
	LoadActBtn
	SetRPRCurData
	GetPRPCurData
	UpdateQuestionIcon
	ShowAuthorize
	AuthorizeState
	ShowAuthorizeView
	ResetSendAuthorizeTimesFlag
	ShowGashaponRewardList
	ClearGashaponRewardList
	StopGashaponSendOp
	ResetGashaponSendOp
	PlayGashaponAutoAnimEnd
	ReceiveGashaponRewardList
	RefreshLevelWindowRewardState
	CheckActData
	SetActRechargeDay
	GetActRechargeDay
	IsRareReward
	GetActDataByShowID
	DeleteActTimer
	CheckCanAddRedCondition

	RefreshVerifyIcon
	is_open_verify_view
	CheckIsGotNameVerReward
	GetActRechargeOneDay
	SetActRechargeGone
	recharge_gone
	SetCarnivalProgress   //全民狂欢
	GetCarnivalProgerss
	carnival_progress_list

	//首日福利
	IsNeedCountTime
	OnUpdateActTime
	OnClearActTime
	_act_time_list = {}
	CheckPlatSourceList //检查活动配置是否配置了source_list 控制渠道开启

	//充值豪礼
	GetRechargeList
	GetFristRecharge
	TransReward2
	GetFlyRewardList
	ShowActFlyReward
	GetConDays
	TransReward
	TiredChargeData
	GetConRecharge
	GetMaxProductId
	state
	GetSuperGiftBuyState
	SetOnlineDrawData
	holiday_info

	//天命礼包奖励列表数据维护
	updateDTurntableReward

	//跨服团购维护数据（可拓展）
	group_buy_timer

	specialRedDotMap: TMap<string, boolean>; // 用于处理特殊红点,只保存一次红点数据,即value大于0时
	show_super_gift_view = true
	redpacket_rain_subtype = 0
	online_draw_back_id = null
	online_draw_type = null
	advertising_cd_list
	constructor() {
		super()
		this.specialRedDotMap = new TMap<string, boolean>();
		if (CustomActivityModel.Instance) {
			return
		}
		CustomActivityModel.Instance = this

		let preload_client_config = Config.PRELOAD_CLIENT_CONFIG
		let local_Config = Config
		// let compete_list_model = CompeteListModel.GetInstance()
		let role_mgr = RoleManager.GetInstance()
		// let kaifu_activity_model = KaifuActivityModel.GetInstance()
		let activity_icon_mgr = ActivityIconManager.GetInstance()
		let local_CustomActivityDefine = CustomActivityDefine
		let sever_time_model = ServerTimeModel.GetInstance()
		let common_mgr = CommonManager.GetInstance()
		let local_Util = Util
		let local_TimeUtil = TimeUtil
		let custom_even = local_CustomActivityDefine.EVENT
		let local_Message = Message
		let saibo_model = SaiboModel.GetInstance()
		let erlang_parser = ErlangParser.GetInstance()
		let cookie_wrapper = CookieWrapper.GetInstance()
		let goods_model = GoodsModel.GetInstance()
		let local_GlobalEventSystem = GlobalEventSystem
		let local_Number = Number
		let local_EventName = EventName
		let local_DungeonEnterView = DungeonEnterView
		let local_CustomActivityModel = CustomActivityModel
		let platform_mgr = PlatformManager.GetInstance()
		let local_PlatformManager = PlatformManager
		let act_info_list_ = {}
		let icons_state_ = {}
		let act_data_list_ = null
		let over_view_data_ = null
		let act_red_state_ = null
		let recharge_list_ = null
		let config_cloudbuy_stage_award_ = null
		let ClientNameVerifyConfig_ = null
		let is_fresh_verify = false
		let verify_sub_type = 0
		let act_touch_grade_ = {} //活动单独档位页签红点
		let special_open_list_ = {}
		let ftv_activeness_id_ = null
		let condition_dic_ = {} //活动条件
		let is_dayFirstLogin_ = false //是否当前第一次登陆
		let rpr_data_ = null
		let firstRed_dic_ = {}
		let receive_gashapon_num = 0
		let gashapon_max_num = 10
		let gashapon_force_stop = false
		this.is_open_verify_view = false//是否打开过防沉迷
		this.state = false //是否领取过120奖励礼包
		let online_draw_fight_list = {}
		this.holiday_info = null //用于以后实现一个活动多个展示的预备

		//读取用作红点的配置
		this.InitConfig = () => {
			// config_cloudbuy_stage_award_ = local_Config.PRELOAD_SERVER_CONFIG.config_cloudbuy_stage_award
			//ClientNameVerifyConfig_ = local_Config.ClientNameVerifyConfig
			this.act_key_dic = {}
			this.CheckDayFristLogin()

			ClientNameVerifyConfig_ = Config.PRELOAD_CLIENT_CONFIG.ClientNameVerifyConfig
			if (is_fresh_verify) {
				is_fresh_verify = false
				this.RefreshVerifyIcon()
			}
		}

		///**
		//* 通用方法 start
		//*/
		this.SaveActInfo = (vo?) => {
			let _vo = vo
			for (let i in vo) {
				let v = vo[i]
				act_info_list_[v.base_type] = act_info_list_[v.base_type] || {}
				act_info_list_[v.base_type][v.sub_type] = v
				this.SetActInfoCondition(v)
				switch (v.base_type) {
					case preload_client_config.ConfigCustomActivity.ACT_ID.COST_RANK:
					case preload_client_config.ConfigCustomActivity.ACT_ID.FEASTBOSS:
					case preload_client_config.ConfigCustomActivity.ACT_ID.DOUBLE:
					case preload_client_config.ConfigCustomActivity.ACT_ID.MORE:
						let value = this.CheckFirstRed(v.base_type, v.sub_type)
						act_red_state_[v.base_type] = act_red_state_[v.base_type] ? act_red_state_[v.base_type] : {}
						act_red_state_[v.base_type][v.sub_type] = value
						this.RefreshIconRed(v.base_type, v.sub_type)
						break
					case preload_client_config.ConfigCustomActivity.ACT_ID.KF_COST_RANK:
						// let info = this.GetActInfo(v.base_type, v.sub_type)
						// if (info) {
						// 	let cond = this.GetActCondition(v.base_type, v.sub_type, "info")
						// 	if (cond && cond.refresh_limit_time) {
						// 		info.etime = info.etime - local_Number(cond.refresh_limit_time)
						// 	}
						// }
						break
					case preload_client_config.ConfigCustomActivity.ACT_ID.WISH_POOL:
						// this.DeleteSubType(i, v, _vo)
						break
					case preload_client_config.ConfigCustomActivity.ACT_ID.MONEYTREE_SHOP:
					case preload_client_config.ConfigCustomActivity.ACT_ID.FTVINVEST:
					case preload_client_config.ConfigCustomActivity.ACT_ID.LEVEL_WINDOW_REWARD:		//等级弹窗奖励（外文服使用）
					case preload_client_config.ConfigCustomActivity.ACT_ID.DAILY_LOGIN:
					case preload_client_config.ConfigCustomActivity.ACT_ID.ATLISTPURCHASE:
					case preload_client_config.ConfigCustomActivity.ACT_ID.ATTENTION:
						this.RequireActInfo(v.base_type, v.sub_type)
						break
					case preload_client_config.ConfigCustomActivity.ACT_ID.LIST_DUOBAO:
						ListDuobaoModel.GetInstance().SetActSubType(v.sub_type)
						ListDuobaoModel.GetInstance().Fire(ListDuobaoModel.REQUEST_SCMD, 33252, v.base_type, v.sub_type)
						break
					case preload_client_config.ConfigCustomActivity.ACT_ID.QUESTIONNAIRE_ACT_BASE_TYPE:
						QuestionNaireModel.GetInstance().SetLevel(v, true)
						break
				}
			}

			this.cache_scmd_33101_list = _vo
			this.UpdateActivityIcons(_vo)
			this.RequireOverViewRew(_vo)
		}

		this.RequireOverViewRew = (vo?) => {
			if (!vo) return
			for (let item of vo) {
				switch (item.base_type) {
					case Config.PRELOAD_CLIENT_CONFIG.ConfigCustomActivity.ACT_ID.OVER_VIEW:
						let cond = ErlangParser.GetInstance().Parse(item.condition)
						if (cond && cond[1] && cond[1][1]) {
							for (let item of cond[1][1]) {
								let act_ = this.GetActInfoByShowID(item['0'], item['1'])
								this.Fire(custom_even.SCMD_REQUEST, 33264, act_.base_type, act_.sub_type)
							}
						}
						break
				}
			}
		}
		this.AddActInfo = (vo?) => {
			let _vo = vo
			for (let i in vo) {
				let v = vo[i]
				let bool = true
				act_info_list_[v.base_type] = act_info_list_[v.base_type] || {}
				act_info_list_[v.base_type][v.sub_type] = v
				this.SetActInfoCondition(v)
				switch (v.base_type) {
					case preload_client_config.ConfigCustomActivity.ACT_ID.COST_RANK:
					case preload_client_config.ConfigCustomActivity.ACT_ID.FEASTBOSS:
					case preload_client_config.ConfigCustomActivity.ACT_ID.DOUBLE:
					case preload_client_config.ConfigCustomActivity.ACT_ID.MORE:
						let value = 0
						value += this.CheckFirstRed(v.base_type, v.sub_type)
						act_red_state_[v.base_type] = act_red_state_[v.base_type] ? act_red_state_[v.base_type] : {}
						act_red_state_[v.base_type][v.sub_type] = value
						this.RefreshIconRed(v.base_type, v.sub_type)
						break
					case preload_client_config.ConfigCustomActivity.ACT_ID.KF_COST_RANK:
						// let info = this.GetActInfo(v.base_type, v.sub_type)
						// if (info) {
						// 	let cond = this.GetActCondition(v.base_type, v.sub_type, "info")
						// 	if (cond && cond.refresh_limit_time) {
						// 		info.etime = info.etime - local_Number(cond.refresh_limit_time)
						// 	}
						// }
						break
					case preload_client_config.ConfigCustomActivity.ACT_ID.WISH_POOL:
					case preload_client_config.ConfigCustomActivity.ACT_ID.FTVINVEST:

						// bool = this.DeleteSubType(i, v, _vo)
						break
					case preload_client_config.ConfigCustomActivity.ACT_ID.MONEYTREE_SHOP:
					case preload_client_config.ConfigCustomActivity.ACT_ID.DAILY_LOGIN:
					case preload_client_config.ConfigCustomActivity.ACT_ID.ATTENTION:
						this.RequireActInfo(v.base_type, v.sub_type)
						break
					case preload_client_config.ConfigCustomActivity.ACT_ID.LIST_DUOBAO:
						ListDuobaoModel.GetInstance().SetActSubType(v.sub_type)
						ListDuobaoModel.GetInstance().Fire(ListDuobaoModel.REQUEST_SCMD, 33252, v.base_type, v.sub_type)
						break
				}

				if (bool) {
					if (!this.cache_scmd_33101_list) {
						this.cache_scmd_33101_list = []
					}
					this.cache_scmd_33101_list.push(v)
				}
			}
			let list = this.GetAddIconList(_vo)
			this.AddActivityIcons(list)
		}

		/*
		废弃
		this.DeleteSubType = (i?, v?, vo?) => {
			if (v.base_type == preload_client_config.ConfigCustomActivity.ACT_ID.WISH_POOL
				|| v.base_type == preload_client_config.ConfigCustomActivity.ACT_ID.FTVINVEST) {
				let info = this.GetActInfo(v.base_type, v.sub_type)
				if (info) {
					let cond = this.GetActCondition(v.base_type, v.sub_type, "info")
					if (cond && cond.wlv && cond.wlv[1]) {
						let cond_wlv = cond.wlv[1]
						if (info.wlv < cond_wlv[1] || info.wlv > cond_wlv[2]) {
							act_info_list_[v.base_type][v.sub_type] = null
							if (Util.IsTableEmpty(act_info_list_[v.base_type])) {
								act_info_list_[v.base_type] = null
							}
							for (let j in vo) {

								let v0 = vo[j]
								if (v0.base_type == v.base_type && v0.sub_type == v.sub_type) {
									table.remove(vo, j)
									break
								}
							}
							return false
						} else {
							return true
						}
					}
				}
			}

			return true
		}
		*/

		this.DeleteActInfo = (vo?) => {
			let key = local_CustomActivityDefine.ICON_KEY
			let delete_list = {}
			let del_type = {}
			for (let info of vo) {
				let act_info = this.GetActInfo(info.base_type, info.sub_type)
				if (act_info) {
					let icon_type = key + "@" + info.base_type + "@" + act_info.show_id
					delete_list[icon_type] = true
					del_type[info.base_type + "@" + act_info.show_id] = true
				}
			}
			let windowscomponent = preload_client_config.ConfigCustomActivity.windowscomponent
			for (let icon in windowscomponent) {
				let delete_icon = true
				for (let act_type in windowscomponent[icon]) {
					let list = Split(act_type, "@")
					let type = list[0] + "@" + list[1]
					let info_list = act_info_list_[list[0]] || this.GetSpecialOpenState(list[0], type[1])
					let is_delete = del_type[type]
					if (!is_delete && info_list) {
						delete_icon = false
						break
					}
				}
				if (delete_icon && icons_state_[icon]) {
					// let atListOpenDic = compete_list_model.CompeteListOpenDic()
					let del = true
					// let cfg_list = compete_list_model.config_atList
					// if (cfg_list) {
					// 	for (let key in atListOpenDic) {
					// 		let v = atListOpenDic[key]
					// 		let cfg = cfg_list[`${v.type}@${v.subtype}`]
					// 		if (cfg && (cfg.act_type == 0 || cfg.act_type == 2) && Trim(cfg.icon) == icon) {
					// 			del = false
					// 			break
					// 		}
					// 	}
					// }
					if (del) {
						delete_list[icon] = true
					}
				} else if (!delete_icon) {

				}
			}
			for (let info of vo) {
				let act_info = this.GetActInfo(info.base_type, info.sub_type)
				if (act_info) {
					delete act_info_list_[info.base_type][info.sub_type]
					for (let index = this.cache_scmd_33101_list.length - 1; index >= 0; index--) {
						if (this.cache_scmd_33101_list[index].base_type == vo[0].base_type && this.cache_scmd_33101_list[index].sub_type == vo[0].sub_type) {
							this.cache_scmd_33101_list.splice(index, 1)
						}
					}
				}
			}
			this.DeleteActivityIcons(delete_list)
		}

		//删除指定图标，用于特殊活动
		this.RefreshDeleteIcon = (icon?) => {
			let windowscomponent = preload_client_config.ConfigCustomActivity.windowscomponent
			let list = windowscomponent && windowscomponent[icon]
			let player_lv = role_mgr.mainRoleInfo.level
			if (list) {
				let delete_icon = true
				for (let key in list) {
					let icon_info = list[key]
					let type = Split(key, "@")
					let info_list = act_info_list_[type[0]]
					if (info_list) {
						let bool = true
						if (icon_info.open_lv && player_lv < icon_info.open_lv) {
							bool = false
						}
						if (icon_info.max_day && icon_info.max_day > 0) {
							//bool = kaifu_activity_model.fullShowIconTime(info_list.stime, icon_info.max_day)
						}
						if (bool) {
							delete_icon = false
						}
						break
					}
					if (this.GetSpecialOpenState(list[0], type[1])) {
						delete_icon = false
						break
					}
				}
				if (delete_icon && (icon == "331@4" || icon == "331@4_1")) {
					// let atListOpenDic = compete_list_model.CompeteListOpenDic()
					// if (!Util.IsTableEmpty(atListOpenDic)) {
					// 	delete_icon = false
					// }
				}
				if (delete_icon) {
					let icons = []
					icons.push(icon)
					this.DeleteActivityIcons(icons)
				}
			}
		}

		//更新主界面图标
		this.UpdateActivityIcons = (vo?) => {
			let add_list = this.GetAddIconList(vo)
			let delete_list = {}
			for (let icon_type in icons_state_) {
				if (!add_list[icon_type] ||
					(add_list[icon_type].base_type && local_CustomActivityDefine.SpecialIcon[add_list[icon_type].base_type] && !add_list[icon_type].controll_myself)) {
					delete_list[icon_type] = true
				}
			}
			this.DeleteActivityIcons(delete_list)
			this.AddActivityIcons(add_list)
			this.UpdateQuestionIcon()
		}

		this.AddActivityIcons = (list?) => {
			let vo
			for (let icon_type in list) {
				// if (icon_type == "331@77@0" && (!ClientConfig.show_sealing_test || ClientConfig.show_sealing_test == 0)) {
				// 	continue
				// }

				// 每日直购,没有首充不显示图标
				if (icon_type == '331@115@0' && FirstRechargeModel.GetInstance().IsNoFirstRecharge()) {
					continue
				}

				// 红包返利需要特殊处理
				if (icon_type == "331@117@0") {
					continue
				}

				//充值豪礼@开服累充 7
				if (icon_type == "331@7@0" && RoleManager.GetInstance().mainRoleInfo.level < 40) {
					continue
				}

				if (icon_type == "331@62@1") {
					continue
				}
				vo = list[icon_type]
				if (vo && vo.base_type == 120) {
					let act_info = this.GetActInfoByShowID(vo.base_type, vo.show_id)
					if (act_info) {
						let condition = ErlangParser.GetInstance().parse(act_info.condition)
						let is_first_rec = false
						for (let key in condition) {
							let v0 = condition[key]
							if (v0[0] == "is_first_rec") {
								is_first_rec = Number(v0[1]) == 1 ? true : false
								break
							}
						}
						if (is_first_rec && FirstRechargeModel.GetInstance().IsNoFirstRecharge()) continue
					}
				}
				if (vo && vo.base_type == 129) {
					let act_info = this.GetActInfoByShowID(vo.base_type, vo.show_id)
					if (act_info) {
						let condition = ErlangParser.GetInstance().parse(act_info.condition)
						vo.icon_info_data.icon_name = `331129${condition[1][1]}`
						vo.icon_info_data.open_lv = Number(condition[0][1])
						activity_icon_mgr.addIcon(icon_type, vo.end_time, vo.icon_info_data)
					}
					continue
				}
				if (!vo.controll_myself) {
					let data = list[icon_type]
					icons_state_[icon_type] = true
					activity_icon_mgr.addIcon(icon_type, data.end_time, data.icon_info_data)
					if (icon_type == "331@10@0") {
						this.Fire(CustomActivityDefine.EVENT.REFRESHCOUNTDOWN, "331@10@0", data.end_time, true)
					}
				}
			}
		}

		this.DeleteActivityIcons = (delete_list?) => {
			for (let icon_type in icons_state_) {
				if (delete_list[icon_type]) {
					delete icons_state_[icon_type]
					activity_icon_mgr.deleteIcon(icon_type)
				}
			}
		}

		this.GetAddIconList = (act_list?) => {
			let icon_info, icon_type
			let key = local_CustomActivityDefine.ICON_KEY
			let player_lv = role_mgr.mainRoleInfo.level
			let open_day = sever_time_model.GetOpenServerDay()
			let list = {}
			let windows_cfg = preload_client_config.ConfigCustomActivity.windowscomponent

			//额外增加主界面图标，打开331@x界面中某个子标签
			let keyIcons = local_CustomActivityDefine.ShowKeyItemToIcon
			for (let v in keyIcons) {
				let key_list = Split(v, "#")
				let view_key = key_list[0]
				let item_key = key_list[1]
				let view = windows_cfg[view_key][item_key]
				if (!view) continue
				icon_type = keyIcons[v]
				for (let k in act_list) {
					let info = act_list[k]
					let key = `${info.base_type}@${info.show_id}`
					if (key != item_key) continue
					if (view.open_lv || player_lv >= view.open_lv) {
						icon_info = common_mgr.GetFunctionIconCfg(icon_type)
						list[icon_type] = {
							base_type: info.base_type,
							show_id: info.show_id,
							end_time: info.etime,
							icon_info_data: icon_info
						}
						//不需要请求数据,下面循环act_list的时候会请求
						break
					}
				}
			}

			//不是活动的特殊列表
			let SpecialList = local_CustomActivityDefine.SpecialView
			for (let v in local_CustomActivityDefine.SpecialView) {
				for (let w in windows_cfg) {
					let view = windows_cfg[w][v]
					if (view) {
						icon_type = w
						let key_list = Split(v, "@")
						if (this.GetSpecialOpenState(key_list[0], key_list[1])) {
							icon_info = common_mgr.GetFunctionIconCfg(icon_type)
							let sp_bool = true
							if (icon_info) {
								if (player_lv < icon_info.open_lv
									|| open_day < icon_info.open_day
									|| (icon_info.max_open_day != 0 && open_day > icon_info.max_open_day)
									|| (icon_info.open_task_id != 0 && TaskModel.GetInstance().newest_finish_task_id < icon_info.open_task_id)) {
									sp_bool = false
								}
							}
							if (sp_bool) {
								list[icon_type] = {
									end_time: 0,
									icon_info_data: icon_info.data
								}
								this.RequireSpecialViewInfo(key_list[0], null, null, key_list[1])
								break
							}

						}
					}
				}
			}

			//竟榜活动
			/*
			if (compete_list_model.competeListOpen()) {
				let atListOpenDic = compete_list_model.CompeteListOpenDic()
				for (let key in atListOpenDic) {
					let openInfo = atListOpenDic[key]
					let config_atList = compete_list_model.config_atList
					if (openInfo.end_time > local_TimeUtil.getServerTime()) {
						let config = config_atList && config_atList[`${openInfo.type}@${openInfo.subtype}`];
						if (config && config.act_type != 1) {
							icon_type = Trim(config.icon)
							icon_info = common_mgr.GetFunctionIconCfg(icon_type)
							if (!list[icon_type]) {
								list[icon_type] = {
									end_time: 0,
									icon_info_data: icon_info.data
								}
							}
							this.RequireSpecialViewInfo(preload_client_config.ConfigCustomActivity.SPECIAL_ID.COMPETELIST, openInfo.type, openInfo.subtype);
						}
					}
				}
			}
			*/

			icon_type = null
			for (let k in act_list) {
				let info = act_list[k]
				for (let v in windows_cfg) {
					let cfg = common_mgr.GetFunctionIconCfg(v)
					let bool = true
					if (cfg) {
						if (player_lv < cfg.open_lv
							|| open_day < cfg.open_day
							|| (cfg.max_open_day != 0 && open_day > cfg.max_open_day)
							|| (cfg.open_task_id != 0 && TaskModel.GetInstance().newest_finish_task_id < cfg.open_task_id)
						) {
							bool = false
						}
					} else {
						bool = false
					}
					if (bool) {
						let i = info.base_type + "@" + info.show_id
						if (windows_cfg[v][i] && (!windows_cfg[v][i].open_lv || player_lv >= windows_cfg[v][i].open_lv)) {
							if (!windows_cfg[v][i].max_day
								|| windows_cfg[v][i].max_day == 0) {
								//|| kaifu_activity_model.fullShowIconTime(info.stime, windows_cfg[v][i].max_day)) {
								icon_type = v
							}
							break
						}
					}
				}
				if (!icon_type) {
					if (info.base_type == 101) {
						icon_type = key + "@" + 100 + "@" + info.show_id
					} else {
						icon_type = key + "@" + info.base_type + "@" + info.show_id
					}
				}
				if (local_CustomActivityDefine.SpecialIcon[info.base_type]) {
					this.RequireActInfo(info.base_type, info.sub_type)
					list[icon_type] = {
						base_type: info.base_type,
						show_id: info.show_id,
						end_time: info.etime,
						icon_info_data: {},
						controll_myself: true
					}
				} else if (local_CustomActivityDefine.AdvanceIcon[info.base_type]) {
					this.RequireActInfo(info.base_type, info.sub_type)
				} else {
					this.RequireActInfo(info.base_type, info.sub_type)
					icon_info = activity_icon_mgr.getIconInfo(icon_type)
					if (icon_info) {
						if (icon_type) {
							list[icon_type] = {
								base_type: info.base_type,
								show_id: info.show_id,
								end_time: info.etime,
								icon_info_data: icon_info.data
							}
							this.RequireActInfo(info.base_type, info.sub_type)
						}
					} else {
						icon_info = common_mgr.GetFunctionIconCfg(icon_type)
						if (icon_info) {
							if (player_lv >= icon_info.open_lv && open_day >= icon_info.open_day) {
								if (icon_type) {
									let isAdd = this.CheckSomeSpecialCond(info.base_type, info.sub_type)
									if (isAdd) {
										list[icon_type] = {
											base_type: info.base_type,
											show_id: info.show_id,
											end_time: info.etime,
											icon_info_data: icon_info
										}
									}
									this.RequireActInfo(info.base_type, info.sub_type)
								}
							}
						}
					}
				}
				icon_type = null
			}
			return list
		}

		//活动检查渠道屏蔽
		this.CheckSomeSpecialCond = (base_type?, sub_type?) => {
			//需要根据子类型来渠道屏蔽的活动
			let key = base_type
			if (local_CustomActivityDefine.Subtype_By_Platform[`${base_type}@${sub_type}`]) {
				key = `${base_type}@${sub_type}`
			}
			let bool = true

			switch (key) {
				case preload_client_config.ConfigCustomActivity.ACT_ID.WXONEMONEY:
					if (sub_type == 1) {
						bool = ClientConfig && ClientConfig.onemoney_gift_open
					}
					if (sub_type == 2) {
						bool = ClientConfig && ClientConfig.onemoney_gift_open_magatama
					}

					break
				case preload_client_config.ConfigCustomActivity.ACT_ID.ZERO_MALL:
					bool = false
					break
				case preload_client_config.ConfigCustomActivity.ACT_ID.EN_FREEGIFT:
					bool = local_PlatformManager.IsEyouPlatform() && Util.IsConch() && !Util.IsIOSConch()
					break
				case preload_client_config.ConfigCustomActivity.ACT_ID.FIRST_BLOOD:
					// bool = true
					bool = !FirstBloodModel.GetInstance().ReceiveAll(sub_type)
					break
				case preload_client_config.ConfigCustomActivity.ACT_ID.CREAT_ROLE_GIFT:
					bool = this.CheckPlatSourceList(base_type, sub_type)
					break
				case preload_client_config.ConfigCustomActivity.ACT_ID.ADVERTISEMENT:
					bool = WelfareModel.GetInstance().GetAdOpenState()
					break
				default:
					bool = true
			}

			return bool
		}


		this.CheckPlatSourceList = (base_type, sub_type) => {
			//配置了渠道就按照渠道显示
			let bool = true
			let plat_fome = PlatformManager.GetPlatformName();
			let act_info = CustomActivityModel.GetInstance().GetActInfo(base_type, sub_type)
			if (plat_fome && act_info && act_info.condition) {
				let plat_cond = ErlangParser.GetInstance().parse(act_info.condition)
				for (let i = 0; i < plat_cond.length; i++) {
					if ((plat_cond[i][0] && plat_cond[i][0] == "source_list") && (plat_cond[i][1] && plat_cond[i][1].length > 0)) {
						bool = plat_cond[i][1].indexOf(plat_fome) != -1
					}
				}
			}

			return bool
		}

		this.ClearActInfo = () => {
			act_info_list_ = {}
		}

		this.GetActInfo = (base_type?, sub_type?) => {
			let list = act_info_list_[base_type]
			if (list) {
				let info = list[sub_type]
				if (info) {
					return info
				}
			}
			return false
		}

		this.GetActInfoByShowID = (base_type?, show_id?) => {
			base_type = Number(base_type)
			show_id = Number(show_id)
			let list = act_info_list_[base_type]
			if (!list) {
				return false
			}
			for (let sub_type in list) {
				let info = list[sub_type]
				if (info.show_id == show_id) {
					return info
				}
			}
			return false
		}

		this.RequireActInfo = (base_type?, sub_type?) => {
			//let dungeon_model = BaseDungeonModel.GetInstance()
			let act_info = this.GetActInfo(base_type, sub_type)
			if (!act_info) {
				return
			}
			let endTime = act_info.etime - local_TimeUtil.getServerTime()

			if (base_type == preload_client_config.ConfigCustomActivity.ACT_ID.ZERO_MALL) {
				this.Fire(custom_even.SCMD_REQUEST, 33136, sub_type)
			} else if (base_type == preload_client_config.ConfigCustomActivity.ACT_ID.DAILY_RECHARGE) {
				this.Fire(custom_even.SCMD_REQUEST, 15955, sub_type)
				this.Fire(custom_even.SCMD_REQUEST, 15956, sub_type)
			} else if (base_type == preload_client_config.ConfigCustomActivity.ACT_ID.TOP_PLAYER) {
				let open_day = sever_time_model.GetOpenServerDay()
				let openTime: number = ServerTimeModel.GetInstance().GetOpenServerTime();
				this.Fire(custom_even.SCMD_REQUEST, 22502, sub_type)
				ResManager.GetInstance().GetGameConfigWithAutoDestory("config_rush_rank", (cfg) => {
					for (let k in cfg) {
						let v = cfg[k];
						if (v.start_day <= open_day && openTime >= v.open_start_time && openTime <= v.open_end_time)
							this.Fire(custom_even.SCMD_REQUEST, 22501, local_Number(k), sub_type)
					}
				}, false)
			} else if (base_type == preload_client_config.ConfigCustomActivity.ACT_ID.CLOUD_PURCHASE) {
				//this:Fire(custom_even.SCMD_REQUEST, 33112, sub_type)
			} else if (base_type == preload_client_config.ConfigCustomActivity.ACT_ID.WEAPON_RENTAL
				|| base_type == preload_client_config.ConfigCustomActivity.ACT_ID.QUESTIONNAIRE_ACT_BASE_TYPE) {
				//this:Fire(custom_even.SCMD_REQUEST, 33104, base_type, sub_type)
			} else if (base_type == preload_client_config.ConfigCustomActivity.ACT_ID.SEVENDAYCHALLENGE) {

			} else if (base_type == preload_client_config.ConfigCustomActivity.ACT_ID.ACC_RECHARGE) {
				this.Fire(custom_even.SCMD_REQUEST, 33104, base_type, sub_type)
				this.Fire(custom_even.SCMD_REQUEST, 15957, base_type, sub_type, act_info.stime)
			} else if (base_type == preload_client_config.ConfigCustomActivity.ACT_ID.YOYO_ACT) {
				//this:Fire(custom_even.SCMD_REQUEST, 33187, base_type, sub_type)
				//this:Fire(custom_even.SCMD_REQUEST, 33104, base_type, sub_type)
				//this:Fire(custom_even.REFRESHCOUNTDOWN, YoYoModel.YoYoIcon, act_info.etime, endTime > 0)
			} else if (base_type == preload_client_config.ConfigCustomActivity.ACT_ID.MORE) {
				this.Fire(custom_even.SCMD_REQUEST, 33104, base_type, sub_type)
				BaseDungeonModel.GetInstance().dungeonActivity(base_type, sub_type)
			} else if (base_type == preload_client_config.ConfigCustomActivity.ACT_ID.DOUBLE) {
				this.Fire(custom_even.SCMD_REQUEST, 33104, base_type, sub_type)
				BaseDungeonModel.GetInstance().dungeonActivity(base_type, sub_type)
			} else if (base_type == preload_client_config.ConfigCustomActivity.ACT_ID.COST_RANK) {
				//this:Fire(custom_even.SCMD_REQUEST, 33189, sub_type)
			} else if (base_type == preload_client_config.ConfigCustomActivity.ACT_ID.EGGS) {
				//this:Fire(custom_even.SCMD_REQUEST, 33120, base_type, sub_type)
			} else if (base_type == preload_client_config.ConfigCustomActivity.ACT_ID.MONEYTREE
				|| base_type == preload_client_config.ConfigCustomActivity.ACT_ID.MOUNT_TURNTABLE) {
				this.Fire(custom_even.SCMD_REQUEST, 33190, base_type, sub_type)
			} else if (base_type == preload_client_config.ConfigCustomActivity.ACT_ID.HOLYCALL) {
				this.Fire(custom_even.SCMD_REQUEST, 33221, base_type, sub_type)
			} else if (base_type == preload_client_config.ConfigCustomActivity.ACT_ID.MONSTER_INVASION) {
				//MonsterInvasionModel:GetInstance():requestData()
			} else if (base_type == preload_client_config.ConfigCustomActivity.ACT_ID.CONVOY) {
				// BossModel.GetInstance().FeastBossActivity(base_type, sub_type)
			} else if (base_type == preload_client_config.ConfigCustomActivity.ACT_ID.FEASTBOSS) {
				BossModel.GetInstance().FeastBossActivity(base_type, sub_type)
			} else if (base_type == preload_client_config.ConfigCustomActivity.ACT_ID.FTVACTIVENESS) {
				this.Fire(custom_even.SCMD_REQUEST, 33104, base_type, sub_type)
			} else if (base_type == preload_client_config.ConfigCustomActivity.ACT_ID.KF_COST_RANK) {
				//this:Fire(custom_even.SCMD_REQUEST, 33204, sub_type)
			} else if (base_type == preload_client_config.ConfigCustomActivity.ACT_ID.SURPRISE_EGG) {
				//this:Fire(custom_even.SCMD_REQUEST, 33205, base_type, sub_type)
			} else if (base_type == preload_client_config.ConfigCustomActivity.ACT_ID.SAIBOTREASURE) {
				this.Fire(custom_even.SCMD_REQUEST, 33165, base_type, sub_type)
			} else if (base_type == preload_client_config.ConfigCustomActivity.ACT_ID.FTVCOLLECTION) {
				this.Fire(custom_even.SCMD_REQUEST, 33104, base_type, sub_type)
				//this:Fire(custom_even.SCMD_REQUEST, 33106, base_type, sub_type)
			} else if (base_type == preload_client_config.ConfigCustomActivity.ACT_ID.TURNTABLE) {
				this.Fire(custom_even.SCMD_REQUEST, 33130, base_type, sub_type)
				this.Fire(custom_even.SCMD_REQUEST, 33132, base_type, sub_type)
			} else if (base_type == preload_client_config.ConfigCustomActivity.ACT_ID.FTVINVEST) {
				this.Fire(custom_even.SCMD_REQUEST, 33211, base_type, sub_type)
			} else if (base_type == preload_client_config.ConfigCustomActivity.ACT_ID.GODPRAYER) {
				//this:Fire(custom_even.SCMD_REQUEST, 33177, base_type, sub_type)
			} else if (base_type == preload_client_config.ConfigCustomActivity.ACT_ID.RECHARGERETURN
				|| base_type == preload_client_config.ConfigCustomActivity.ACT_ID.RECHARGE_RESET) {
				//if (! act_red_state_[base_type] ) {
				//act_red_state_[base_type] = []
				//}
				//let value = this.CheckFirstRed(base_type, sub_type)
				//// [ts2lua]act_red_state_下标访问可能不正确
				//// [ts2lua]act_red_state_[base_type]下标访问可能不正确
				//act_red_state_[base_type][sub_type] = value
				//VipModel:GetInstance():Fire(VipModel.REQUEST_PROTO, 15800)
				//return
				GlobalEventSystem.Fire(EventName.MAINUI_TOP_LOAD_SUCCEED)
				
			} else if (base_type == preload_client_config.ConfigCustomActivity.ACT_ID.FLOWERRANK
				|| base_type == preload_client_config.ConfigCustomActivity.ACT_ID.RECHARGERANK
				|| base_type == preload_client_config.ConfigCustomActivity.ACT_ID.CONSUMERANK) {
				this.act_key_dic[base_type] = []
				this.act_key_dic[base_type][sub_type] = true
				this.Fire(custom_even.SCMD_REQUEST, 33104, base_type, sub_type)
			} else if (base_type == preload_client_config.ConfigCustomActivity.ACT_ID.OPTIONALLOTTO) {
				this.Fire(custom_even.SCMD_REQUEST, 33128, base_type, sub_type)
			} else if (base_type == preload_client_config.ConfigCustomActivity.ACT_ID.actMarriage) {
				this.Fire(custom_even.SCMD_REQUEST, 33115, sub_type, 1)
			} else if (base_type == preload_client_config.ConfigCustomActivity.ACT_ID.BETA_ACT) {
				// [ts2lua]act_red_state_下标访问可能不正确
				if (!act_red_state_[base_type]) {
					// [ts2lua]act_red_state_下标访问可能不正确
					act_red_state_[base_type] = []
				}
				let betaact_value = 0
				let betaact_key = base_type
				betaact_value = this.CheckFirstRed(base_type, sub_type)
				// [ts2lua]act_red_state_下标访问可能不正确
				// [ts2lua]act_red_state_[base_type]下标访问可能不正确
				act_red_state_[base_type][sub_type] = betaact_value
				this.Fire(custom_even.SCMD_REQUEST, 33216)
			} else if (base_type == preload_client_config.ConfigCustomActivity.ACT_ID.LUC_TREA) {
				this.Fire(custom_even.SCMD_REQUEST, 33104, base_type, sub_type)
				this.Fire(custom_even.SCMD_REQUEST, 33213, base_type, sub_type)
			} else if (base_type == preload_client_config.ConfigCustomActivity.ACT_ID.ACT_TURNTABLE
				|| base_type == preload_client_config.ConfigCustomActivity.ACT_ID.REAL_LOTTERY) {
				//this:Fire(custom_even.SCMD_REQUEST, 33218, base_type, sub_type)
				//this:Fire(custom_even.SCMD_REQUEST, 33104, base_type, sub_type)
			} else if (base_type == preload_client_config.ConfigCustomActivity.ACT_ID.ONLINE_DRAW) {
				this.Fire(custom_even.SCMD_REQUEST, 33217, base_type, sub_type)
			} else if (base_type == preload_client_config.ConfigCustomActivity.ACT_ID.RED_PACKET_RAIN) {
				this.Fire(custom_even.SCMD_REQUEST, 33155, sub_type)
			} else if (base_type == preload_client_config.ConfigCustomActivity.ACT_ID.FORTUNECAT) {
				this.Fire(custom_even.SCMD_REQUEST, 33224, base_type, sub_type, 0)
			} else if (base_type == preload_client_config.ConfigCustomActivity.ACT_ID.ACTCHALLENGE) {
				// ActChallengeModel.GetInstance().RequestData(base_type, sub_type)
				// this.Fire(custom_even.SCMD_REQUEST, 33104, base_type, sub_type)
			} else if (base_type == preload_client_config.ConfigCustomActivity.ACT_ID.DESTINY_TURNTABLE) {
				this.Fire(custom_even.SCMD_REQUEST, 33238, base_type, sub_type)
				this.Fire(custom_even.SCMD_REQUEST, 33104, base_type, sub_type)
			} else if (base_type == preload_client_config.ConfigCustomActivity.ACT_ID.LUC_TREA_TWO) {
				this.Fire(custom_even.SCMD_REQUEST, 33243, base_type, sub_type)
				this.lucky_sub_type = sub_type
			} else if (base_type == preload_client_config.ConfigCustomActivity.ACT_ID.TURNTABLE_100) {
				this.Fire(custom_even.SCMD_REQUEST, 33241, base_type, sub_type)
			} else if (base_type == preload_client_config.ConfigCustomActivity.ACT_ID.FIGHT_RANK) {
				this.Fire(custom_even.SCMD_REQUEST, 33104, base_type, sub_type)
				this.Fire(custom_even.SCMD_REQUEST, 22601, sub_type)
				if (sub_type % 2 == 0) {
					this.Fire(custom_even.SCMD_REQUEST, 22602, sub_type)
				}
			} else if (base_type == preload_client_config.ConfigCustomActivity.ACT_ID.GASHAPON) {
				this.Fire(custom_even.SCMD_REQUEST, 33104, base_type, sub_type)
				this.Fire(custom_even.SCMD_REQUEST, 33245, base_type, sub_type)
			} else if (base_type == preload_client_config.ConfigCustomActivity.ACT_ID.MANY_RECHARGE) {
				this.Fire(custom_even.SCMD_REQUEST, 33247, base_type, sub_type)
			} else if (base_type == preload_client_config.ConfigCustomActivity.ACT_ID.BIND_JAGE_WISH) {
				this.Fire(custom_even.SCMD_REQUEST, 33260, base_type, sub_type)
				this.Fire(custom_even.SCMD_REQUEST, 33104, base_type, sub_type)
			} else if (base_type == preload_client_config.ConfigCustomActivity.ACT_ID.ADVERTISEMENT) {
				this.Fire(custom_even.SCMD_REQUEST, 33104, base_type, sub_type)
				this.Fire(custom_even.SCMD_REQUEST, 33250, base_type, sub_type)
			} else {
				this.Fire(custom_even.SCMD_REQUEST, 33104, base_type, sub_type)
			}
		}

		this.RequireSpecialViewInfo = (base_type?, type?, sub_type?, show_id?) => {
			if (preload_client_config.ConfigCustomActivity.SPECIAL_ID.BOOKOFCONTRACT == Number(base_type)) {
				//kaifu_activity_model:Fire(KaifuActivityModelEvent.REQUEST_BOOK_ALL_DATA)
			} else if (preload_client_config.ConfigCustomActivity.SPECIAL_ID.HOTPOINT == Number(base_type)) {
				let data = HotPointModel.GetInstance().GetActInfoByShowId(base_type, show_id)
				if (data) {
					HotPointModel.GetInstance().Fire(HotPointModel.REQUEST_SCMD, 33302, base_type, data.sub_type)
					HotPointModel.GetInstance().Fire(HotPointModel.REQUEST_SCMD, 33303, base_type, data.sub_type)
				}
			}
		}

		//判断是否是活动
		this.IsActIcon = (iconType?) => {
			let list = Split(String(iconType), "@")
			let key = list[0]
			return key == local_CustomActivityDefine.ICON_KEY
		}

		//获取活动开启状态
		this.GetOpenState = (iconType?, is_alert?) => {
			let bool = icons_state_[iconType]
			if (is_alert && !bool) {
				let cfg = common_mgr.GetFunctionIconCfg(iconType)
				let role_lv = role_mgr.mainRoleInfo.level
				if (cfg.open_lv > 0 && cfg.open_lv > role_lv) {
					local_Message.show(`等级不够,${cfg.open_lv}级开放`)
				}
			}
			return icons_state_[iconType]
		}

		this.CheckMoney = (cost_gold?) => {
			let money = role_mgr.GetMainRoleVo().jin
			if (money < cost_gold) {
				let ok = () => {
					let time_out_cm = setTimeout(() => {
						VipModel.GetInstance().Fire(VipModel.OPEN_VIEW, "RechargeView")
						clearTimeout(time_out_cm)
						time_out_cm = null
					}, 0.28)
				}
				Alert.Show(Util.StrToHTML(`勾玉不足<font color='#82ab20'>${cost_gold}</font>,是否前往充值?`), Alert_Type.Two, ok, null, "充值", "取消")
				return false
			}
			return true
		}

		this.updateDTurntableReward = (data) => {
			let all_rewards = [];
			let _rewards = data.reward_list;
			let old_Data = this.GetActData(data.base_type, data.sub_type);
			if (old_Data && old_Data.reward_list && _rewards) {
				all_rewards = Util.DeepCopy(old_Data.reward_list)
				for (let key in _rewards) {
					let v = _rewards[key];
					let isHav: boolean = false;
					for (let i = 0; i < all_rewards.length; i++) {
						let old_reward = all_rewards[i];
						if (v.grade == old_reward.grade) {
							all_rewards[i] = v
							isHav = true;
							break
						}
					}
					if (!isHav) {
						table.insert(all_rewards, v)
					}
				}
				let sort_fun = (a?, b?) => {
					return a.grade < b.grade
				}
				table.sort(all_rewards, sort_fun)
			} else {
				all_rewards = _rewards
			}
			let showData = old_Data && old_Data.need_point ? old_Data : data;
			showData.reward_list = all_rewards
			let keys: string[] = Object.keys(data);
			for (let i = 0, len = keys.length; i < len; i++) {
				if (keys[i] == "reward_list") continue;
				showData[keys[i]] = data[keys[i]]
			}

			return showData
		}

		//设置活动信息
		this.SetActData = (data?) => {
			if (!data) {
				return
			}
			act_data_list_[data.base_type] = act_data_list_[data.base_type] || {}
			if (data.base_type == preload_client_config.ConfigCustomActivity.ACT_ID.DESTINY_TURNTABLE) {
				act_data_list_[data.base_type][data.sub_type] = this.updateDTurntableReward(data);
			} else {
				act_data_list_[data.base_type][data.sub_type] = data
			}
			this.SetActDataCondition(data)
			this.GetActAllGrade(data)
			this.SetActRedDot(data.base_type, data.sub_type)
			this.RefreshIconRed(data.base_type, data.sub_type)
			this.RefreshLevelWindowRewardState(data.base_type, data.sub_type)

			//首日福利添加倒计时
			if (data.base_type == Config.PRELOAD_CLIENT_CONFIG.ConfigCustomActivity.ACT_ID.CREAT_ROLE_GIFT) {
				if (this.IsNeedCountTime(data.base_type, data.sub_type)) {
					this.OnUpdateActTime(data.base_type, data.sub_type)
				} else {
					this.OnClearActTime(data.base_type, data.sub_type)
				}
			}
		}

		this.SetOverViewData = (data?) => {
			if (!data) {
				return
			}
			over_view_data_[data.base_type] = over_view_data_[data.base_type] || {}
			over_view_data_[data.base_type][data.sub_type] = data
		}

		this.GetOverViewData = (base_type?, sub_type?) => {
			let data = over_view_data_[base_type]
			return data && data[sub_type]
		}
		//获取活动信息
		this.GetActData = (base_type?, sub_type?) => {
			let data = act_data_list_[base_type]
			return data && data[sub_type]
		}

		this.GetActDataByShowID = (base_type?, show_id?) => {
			base_type = Number(base_type)
			show_id = Number(show_id)
			let result = false
			if (act_data_list_ && act_data_list_[base_type]) {
				let data = act_data_list_[base_type]
				let info = this.GetActInfoByShowID(base_type, show_id)
				if (info) {
					result = data[info.sub_type]
				}
			}
			return result
		}

		//检查活动数据是否已加载
		this.CheckActData = (base_type?, sub_type?) => {
			let role_lv = role_mgr.mainRoleInfo.level

			//检查活动数据
			let act_data = null
			if (base_type == preload_client_config.ConfigCustomActivity.ACT_ID.FIRST_BLOOD) {
				act_data = FirstBloodModel.GetInstance().GetKillInfo(96, sub_type)
			} else if (base_type == preload_client_config.ConfigCustomActivity.ACT_ID.RECHARGERETURN
				|| base_type == preload_client_config.ConfigCustomActivity.ACT_ID.RECHARGE_RESET
				|| base_type == preload_client_config.ConfigCustomActivity.ACT_ID.FEASTBOSS
				|| base_type == preload_client_config.ConfigCustomActivity.ACT_ID.NAMEVERIFY) {
				act_data = true
			} else {
				act_data = this.GetActData(base_type, sub_type)
			}
			if (!act_data) {
				return false
			} else {
				return true
			}
		}

		//获取相应活动的对应档次的奖励
		this.GetAwardDataById = (base_type?, sub_type?, grade?) => {
			let data = this.GetActData(base_type, sub_type)
			let list
			if (data && data.reward_list) {
				list = data.reward_list
			}
			if (!list) {
				return
			}
			for (let key in list) {
				let reward_data = list[key]
				if (reward_data.grade == grade) {
					return reward_data
				}
			}
		}

		//设置活动结果
		this.SetActResult = (result_data?) => {
			if (!result_data) return
			if (result_data.error_code == 1) {
				let reward_data
				let data = this.GetActData(result_data.base_type, result_data.sub_type)
				let res_base_type = result_data.base_type
				if (res_base_type == preload_client_config.ConfigCustomActivity.ACT_ID.TOP_PLAYER) {
					if (data && data.rank_info) {
						data.rank_info[result_data.type].status = 2
						this.SetRedDotValue(-1, result_data.base_type, result_data.sub_type)
						this.Fire(custom_even.ANSWER_TARGET, result_data.base_type, result_data.sub_type, result_data.type)
					}
					return

				} else if (res_base_type == preload_client_config.ConfigCustomActivity.ACT_ID.DAILY_RECHARGE
					|| res_base_type == preload_client_config.ConfigCustomActivity.ACT_ID.CREATEGUILD) {
					if ((data && data.reward_infos) && data.reward_list) {
						this.SetRedDotValue(-1, result_data.base_type, result_data.sub_type)
						this.RefreshIconRed(result_data.base_type, result_data.sub_type)
						this.Fire(custom_even.ANSWER_TARGET, result_data.base_type, result_data.sub_type, result_data.grade)
					}

				} else if (res_base_type == preload_client_config.ConfigCustomActivity.ACT_ID.EGGS) {
					//if (result_data.eggs ) {
					//data.free_smashed_times = result_data.free_smashed_times
					//data.smashed_times = result_data.smashed_times
					//for (let i in data.cumulate_reward) {

					//if (data.cumulate_reward[i].status == 0 && data.cumulate_reward[i].times <= result_data.smashed_times ) {
					//data.cumulate_reward[i].status = 1
					//}
					//}
					//this:SetActRedDot(result_data.base_type, result_data.sub_type)
					//this:RefreshIconRed(result_data.base_type, result_data.sub_type)
					//for (let i in data.eggs) {

					//for (let index in result_data.eggs) {

					//// [ts2lua]result_data.eggs下标访问可能不正确
					//if (result_data.eggs[index].id == data.eggs[i].id ) {
					//// [ts2lua]result_data.eggs下标访问可能不正确
					//data.eggs[i].goods_list = result_data.eggs[index].goods_list
					//data.eggs[i].status = 1
					//}
					//}
					//}
					//}
					//if (result_data.cumulate_reward ) {
					//for (let index in result_data.cumulate_reward) {

					//for (let i in data.cumulate_reward) {

					//// [ts2lua]result_data.cumulate_reward下标访问可能不正确
					//// [ts2lua]result_data.cumulate_reward下标访问可能不正确
					//if (result_data.cumulate_reward[index].grade_id == data.cumulate_reward[i].grade_id && result_data.cumulate_reward[index].status == 2 ) {
					//data.cumulate_reward[i].status = 2
					//this:SetRedDotValue(-1, result_data.base_type, result_data.sub_type)
					//}
					//}
					//}
					//this:RefreshIconRed(result_data.base_type, result_data.sub_type)
					//}
					//this:Fire(custom_even.ANSWER_TARGET, result_data.base_type, result_data.sub_type, result_data)
				} else if (res_base_type == preload_client_config.ConfigCustomActivity.ACT_ID.FTVEXCHANGE) {
					let grade_info
					for (let key in data.reward_list) {
						if (data.reward_list[key].grade == result_data.grade) {
							grade_info = data.reward_list[key]
							break
						}
					}
					// let grade_info = data.reward_list[result_data.grade - 1]
					grade_info.receive_times = grade_info.receive_times + 1
					for (let _tmpi in grade_info.condition) {
						var v = grade_info.condition[_tmpi]
						if (v[0] == "exchang_times") {
							if (grade_info.receive_times >= Number(v[1])) {
								grade_info.status = 2
							}
							// grade_info.status = (grade_info.receive_times >= Number(v[1]) && (2) || (1))
							break
						}
					}
					this.SetActRedDot(result_data.base_type, result_data.sub_type)
					this.RefreshIconRed(result_data.base_type, result_data.sub_type)
					this.Fire(custom_even.ANSWER_TARGET, result_data.base_type, result_data.sub_type, result_data)

				} else if (res_base_type == preload_client_config.ConfigCustomActivity.ACT_ID.MONEYTREE
					|| res_base_type == preload_client_config.ConfigCustomActivity.ACT_ID.MOUNT_TURNTABLE
					|| res_base_type == preload_client_config.ConfigCustomActivity.ACT_ID.HOLYCALL) {
					if (result_data.all_times) {
						data.all_times = result_data.all_times
						for (let _tmpi in data.cumulate_reward) {
							var v = data.cumulate_reward[_tmpi]
							if (v.status == 0 && v.times <= result_data.all_times) {
								v.status = 1
							}
						}
						let reward = result_data.reward_list
						let count = 0
						for (let _tmpi in reward) {
							var value = reward[_tmpi]
							let data = []
							let rew = value.reward[0]
							if (rew.style == 0 && rew.typeId == 0) {
								count = count + rew.count
							}
						}
						if (count) {
							data.rare_draw_times = (data.rare_draw_times && (data.rare_draw_times + count) || (count))
						}
					}
					if (result_data.cumulate_reward) {
						for (let _tmpi in data.cumulate_reward) {
							var v = data.cumulate_reward[_tmpi]
							if (result_data.cumulate_reward[0] && v.grade_id == result_data.cumulate_reward[0].grade_id) {
								v.status = 2
							}
						}
					}
					if (result_data.rare_draw_times != null) {
						data.rare_draw_times = result_data.rare_draw_times
					}
					if (result_data.score != null) {
						data.score = result_data.score
					}
					this.SetActRedDot(result_data.base_type, result_data.sub_type)
					this.RefreshIconRed(result_data.base_type, result_data.sub_type)
					this.Fire(custom_even.ANSWER_TARGET, result_data.base_type, result_data.sub_type, result_data)

				} else if (res_base_type == preload_client_config.ConfigCustomActivity.ACT_ID.SAIBOTREASURE) {
					if (!data) {
						return
					}
					if (result_data.all_times != null) {
						data.all_times = result_data.all_times
						data.today_drawtimes = result_data.today_drawtimes
						if (!data.stage_s) {
							return
						}
						for (let i in data.stage_s) {
							let list = data.stage_s[i].grade_state
							let cur_stage = data.stage_s[i].stage
							if (!list) {
								return
							}
							for (let _tmpi in list) {
								var v = list[_tmpi]
								let cfg = null
								cfg = saibo_model.GetStageCfg(result_data.base_type, result_data.sub_type, cur_stage, v.grade_stage)
								if (cfg && cfg.condition) {
									let num = Number(cfg.condition.total)
									if (v.state_stage == 0 && num <= result_data.all_times) {
										v.state_stage = 1
									}
								}
							}
						}
						if (data.pool) {
							let num = 0
							for (let j in result_data.reward_list) {
								let vo = result_data.reward_list[j]
								for (let i in data.pool) {
									let v = data.pool[i]
									if (v.sort == vo.sort) {
										v.state = 0
									}
								}
							}
						}
					}
					if (result_data.grade_stage != undefined) {
						if (data.stage_s && data.stage_s[result_data.stage - 1]) {
							let cur_stages = data.stage_s[result_data.stage - 1]
							if (!cur_stages) {
								return
							}
							let cur_stage = cur_stages.grade_state[result_data.grade_stage - 1]
							if (!cur_stage) {
								return
							}
							cur_stage.state_stage = 2
							cur_stage.discount_state = result_data.buy >= 1 ? 2 : result_data.buy;
						}
					}
					this.SetActRedDot(result_data.base_type, result_data.sub_type)
					this.RefreshIconRed(result_data.base_type, result_data.sub_type)
					this.Fire(custom_even.ANSWER_TARGET, result_data.base_type, result_data.sub_type, result_data)

					return
				} else if (res_base_type == preload_client_config.ConfigCustomActivity.ACT_ID.FTVACTIVENESS) {
					if (result_data.reward_list) {
						//提交
						this.Fire(custom_even.SCMD_REQUEST, 33104, result_data.base_type, result_data.sub_type)
						// this:Fire(custom_even.SCMD_REQUEST, 33193, result_data.base_type, result_data.sub_type)
					} else if (result_data.reward) {
						//领取全服，目前没有全服奖励道具配置
						for (let v of data.reward_list) {
							if (v.grade == result_data.grade_id) {
								v.status = 2
								this.SetRedDotValue(-1, result_data.base_type, result_data.sub_type)
								this.RefreshIconRed(result_data.base_type, result_data.sub_type)
							}
						}
					} else if (result_data.grade) {
						//领取个人
						for (let v of data.reward_list) {
							if (v.grade == result_data.grade) {
								v.status = 2
								this.SetRedDotValue(-1, result_data.base_type, result_data.sub_type)
								this.RefreshIconRed(result_data.base_type, result_data.sub_type)
							}
						}
					}
					this.Fire(custom_even.ANSWER_TARGET, result_data.base_type, result_data.sub_type, result_data)

				} else if (res_base_type == preload_client_config.ConfigCustomActivity.ACT_ID.FTVSHOP
					|| res_base_type == preload_client_config.ConfigCustomActivity.ACT_ID.SNAPUP
					|| res_base_type == preload_client_config.ConfigCustomActivity.ACT_ID.LUCKY_DUOBAO
				) {
					if (!data) return
					reward_data = this.GetAwardDataById(data.base_type, data.sub_type, result_data.grade)
					if (result_data.num) {
						reward_data.receive_times = reward_data.receive_times + result_data.num
					}
					let cond = this.GetActCondition(data.base_type, data.sub_type, "data", reward_data.grade)
					if (cond) {
						if (cond.personal_num) {
							let limit_num = local_Number(cond.personal_num)
							if (limit_num == reward_data.receive_times) {
								reward_data.status = 2
							}
						}
					}
					this.Fire(custom_even.ANSWER_TARGET, result_data.base_type, result_data.sub_type, result_data, reward_data)
					return

				} else if (res_base_type == preload_client_config.ConfigCustomActivity.ACT_ID.FTVCOLLECTION) {
					if (data) {
						reward_data = this.GetAwardDataById(data.base_type, data.sub_type, result_data.grade)
						if (result_data.num) {
							reward_data.receive_times = reward_data.receive_times + result_data.num
						}
					}
					this.SetActRedDot(result_data.base_type, result_data.sub_type)
					this.RefreshIconRed(result_data.base_type, result_data.sub_type)
					this.Fire(custom_even.ANSWER_TARGET, result_data.base_type, result_data.sub_type, result_data, reward_data)
					return

				} else if (res_base_type == preload_client_config.ConfigCustomActivity.ACT_ID.SURPRISE_EGG) {
					//if (result_data.grade_id != null ) {
					//for (let i in data.cumulate_reward) {

					//if (result_data.grade_id == data.cumulate_reward[i].grade_id ) {
					//data.cumulate_reward[i].status = 2
					//this:SetRedDotValue(-1, result_data.base_type, result_data.sub_type)
					//}
					//}
					//}else{
					//data.free_times = result_data.free_times
					//data.total_times_use = result_data.total_times_use
					//for (let i in data.cumulate_reward) {

					//if (data.cumulate_reward[i].status == 0 && data.cumulate_reward[i].times <= result_data.total_times_use ) {
					//data.cumulate_reward[i].status = 1
					//}
					//}
					//this:SetActRedDot(result_data.base_type, result_data.sub_type)
					//}
					//this:RefreshIconRed(result_data.base_type, result_data.sub_type)
					//this:Fire(custom_even.ANSWER_TARGET, result_data.base_type, result_data.sub_type, result_data)
					return

				} else if (res_base_type == preload_client_config.ConfigCustomActivity.ACT_ID.FTVINVEST) {
					reward_data = this.GetAwardDataById(data.base_type, data.sub_type, result_data.grade)
					reward_data.status = 2
					this.SetRedDotValue(-1, result_data.base_type, result_data.sub_type)
					this.RefreshIconRed(result_data.base_type, result_data.sub_type)
					this.Fire(custom_even.UPDATE_VIEW, result_data.base_type, result_data.sub_type, result_data, reward_data)
					let reward = ErlangParser.GetInstance().parse(reward_data.reward)
					let view = new CongratulationObtainView(reward, 10)
					view.Open()
					return

				} else if (res_base_type == preload_client_config.ConfigCustomActivity.ACT_ID.NAMEVERIFY
					|| res_base_type == preload_client_config.ConfigCustomActivity.ACT_ID.ATTENTION) {
					if (!data) return
					reward_data = this.GetAwardDataById(data.base_type, data.sub_type, result_data.grade)
					reward_data.status = 2
					this.Fire(custom_even.ANSWER_TARGET, result_data.base_type, result_data.sub_type, result_data, reward_data)
					return

				} else if (res_base_type == preload_client_config.ConfigCustomActivity.ACT_ID.GODPRAYER) {
					//data.free_times = result_data.free_times
					//this:SetActRedDot(result_data.base_type, result_data.sub_type)
					//this:RefreshIconRed(result_data.base_type, result_data.sub_type)
					//this:Fire(custom_even.ANSWER_TARGET, result_data.base_type, result_data.sub_type, result_data)
					return

				} else if (res_base_type == preload_client_config.ConfigCustomActivity.ACT_ID.VIPGIFT) {
					if (!data) return
					reward_data = this.GetAwardDataById(data.base_type, data.sub_type, result_data.grade)
					reward_data.status = 2
					this.RefreshIconRed(result_data.base_type, result_data.sub_type)
					this.Fire(custom_even.ANSWER_TARGET, result_data.base_type, result_data.sub_type, result_data, reward_data)
					return

				} else if (res_base_type == preload_client_config.ConfigCustomActivity.ACT_ID.OPTIONALLOTTO) {
					if (!data) return
					let b = result_data.base_type
					let s = result_data.sub_type
					let draw_times = result_data.draw_times
					if (draw_times != null) {
						data.draw_times = draw_times
						if (data && data.pool && data.pool.length > 0) {
							for (let v of data.pool) {
								if (v.grade == result_data.grade) {
									v.status = draw_times
								}
							}
						}
						if (data && data.stage && data.stage.length > 0) {
							for (let v of data.stage) {
								let cond = this.GetActCondition(b, s, "data", v.grade)
								if (cond) {
									if (Number(cond.stage) <= draw_times && v.status == 0) {
										v.status = 1
										this.SetRedDotValue(1, b, s)
									}
								}
							}
						}
					} else {
						if (data && data.stage && data.stage.length > 0) {
							for (let v of data.stage) {
								if (v.grade == result_data.grade) {
									v.status = 2
									this.SetRedDotValue(-1, b, s)
								}
							}
						}
					}
					this.RefreshIconRed(b, s)
					this.Fire(custom_even.ANSWER_TARGET, b, s, result_data)
					return

				} else if (res_base_type == preload_client_config.ConfigCustomActivity.ACT_ID.WISH_POOL) {
					for (let _tmpi in data.rare_pool) {
						var vo = data.rare_pool[_tmpi]
						if (vo.grade == result_data.grade) {
							vo.lucky_value = result_data.lucky_value
							vo.free_times = result_data.free_times
							vo.state = result_data.state
						}
					}
					this.SetActRedDot(result_data.base_type, result_data.sub_type)
					this.RefreshIconRed(result_data.base_type, result_data.sub_type)
					this.Fire(custom_even.ANSWER_TARGET, result_data.base_type, result_data.sub_type, result_data)
					return

				} else if (res_base_type == preload_client_config.ConfigCustomActivity.ACT_ID.KFGROUPBUY) {
					for (let _tmpi in data.gp_goods) {
					var v = data.gp_goods[_tmpi]
					if (v.grade_id == result_data.grade_id ) {
						let type = result_data.purchase_type
						if (type == 1 ) {
							v.first_buy_count = result_data.buy_count
						} else if (type == 2 ) {
							v.tail_buy_count = result_data.buy_count
						}
						v.buy_num = result_data.buy_num
						}
					}
					this.SetActRedDot(result_data.base_type, result_data.sub_type)
					this.RefreshIconRed(result_data.base_type, result_data.sub_type)
					this.Fire(custom_even.ANSWER_TARGET, result_data.base_type, result_data.sub_type, result_data)
					return
					
				} else if (res_base_type == preload_client_config.ConfigCustomActivity.ACT_ID.FORTUNECAT) {
					this.SetActRedDot(result_data.base_type, result_data.sub_type)
					this.RefreshIconRed(result_data.base_type, result_data.sub_type)
					this.Fire(custom_even.ANSWER_TARGET, result_data.base_type, result_data.sub_type, result_data)
					return

				} else if (res_base_type == preload_client_config.ConfigCustomActivity.ACT_ID.MONEYTREE_SHOP || res_base_type == preload_client_config.ConfigCustomActivity.ACT_ID.SPECIAL_PACKAGE) {
					if (data) {
						for (let v of data.reward_list) {
							if (v.grade == result_data.grade) {
								v.receive_times = v.receive_times + 1
								reward_data = v
							}
						}
					}
					this.Fire(custom_even.ANSWER_TARGET, result_data.base_type, result_data.sub_type, result_data, reward_data)
					return
				} else if (res_base_type == preload_client_config.ConfigCustomActivity.ACT_ID.FIRST_BLOOD) {
					this.SetActRedDot(result_data.base_type, result_data.sub_type)
				} else if (res_base_type == preload_client_config.ConfigCustomActivity.ACT_ID.LEVEL_WINDOW_REWARD) {		//弹窗奖励
					Message.show("ごほうび受け取りの成功")
					this.Fire(custom_even.SCMD_REQUEST, 33104, result_data.base_type, result_data.sub_type)
					return
				} else if (res_base_type == preload_client_config.ConfigCustomActivity.ACT_ID.ATLISTPURCHASE) {
					if (!data) return
					reward_data = this.GetAwardDataById(data.base_type, data.sub_type, result_data.grade)
					if (result_data.num) {
						reward_data.receive_times = reward_data.receive_times + result_data.num
					}
					let cond = this.GetActCondition(data.base_type, data.sub_type, "data", reward_data.grade)
					if (cond) {
						if (cond.personal_num) {
							let limit_num = local_Number(cond.personal_num)
							if (limit_num == reward_data.receive_times) {
								reward_data.status = 2
							}
						}
					}
					this.Fire(custom_even.ANSWER_TARGET, result_data.base_type, result_data.sub_type, result_data, reward_data)
				} else if (res_base_type == preload_client_config.ConfigCustomActivity.ACT_ID.SUPERGIFT) {
					if (!data) return
					reward_data = this.GetAwardDataById(data.base_type, data.sub_type, result_data.grade)
					let cond = this.GetActCondition(data.base_type, data.sub_type, "data", reward_data.grade)
					if (cond && cond.is_free && Number(cond.is_free) == 1) {
						this.SetRedDotValue(-1, result_data.base_type, result_data.sub_type)
						this.RefreshIconRed(result_data.base_type, result_data.sub_type)
					}
					reward_data.status = 2

					reward_data.receive_times++
					this.Fire(custom_even.ANSWER_TARGET, result_data.base_type, result_data.sub_type, result_data, reward_data)
					return
				} else if (res_base_type == preload_client_config.ConfigCustomActivity.ACT_ID.TIRED_CHARGE_POLITE) { // 累充有礼
					let info = this.GetActInfo(result_data.base_type, result_data.sub_type);
					if (!info) return
					reward_data = TiredChargePoliteModel.GetInstance().GetReasdsByGrade(result_data.grade);
					this.RefreshIconRed(info.base_type, info.sub_type);
					this.Fire(custom_even.ANSWER_TARGET, result_data.base_type, result_data.sub_type, result_data, reward_data)
				} else if (res_base_type == preload_client_config.ConfigCustomActivity.ACT_ID.LIST_DUOBAO) { // 冲榜夺宝
					let info = this.GetActInfo(result_data.base_type, result_data.sub_type);
					if (!info) return
					// reward_data = this.GetAwardDataById(data.base_type, data.sub_type, result_data.grade)
					this.RefreshIconRed(info.base_type, info.sub_type);
					this.Fire(custom_even.ANSWER_TARGET, result_data.base_type, result_data.sub_type, result_data)
					return;
				} else if (res_base_type == preload_client_config.ConfigCustomActivity.ACT_ID.OVER_VIEW) {
					if (!data) return
					reward_data = this.GetAwardDataById(data.base_type, data.sub_type, result_data.grade)
					reward_data.status = 2
					this.RefreshIconRed(result_data.base_type, result_data.sub_type)
					this.Fire(custom_even.ANSWER_TARGET, result_data.base_type, result_data.sub_type, result_data, reward_data)
					let reward = ErlangParser.GetInstance().parse(reward_data.reward)
					let view = new CongratulationObtainView(reward, 10)
					view.Open()
				} else if (res_base_type == preload_client_config.ConfigCustomActivity.ACT_ID.QUESTIONNAIRE_ACT_BASE_TYPE) {
					this.Fire(custom_even.ANSWER_TARGET, result_data.base_type, result_data.sub_type, result_data)
				} else {
					if (!data) return
					reward_data = this.GetAwardDataById(data.base_type, data.sub_type, result_data.grade)
				}

				if (reward_data) {
					reward_data.status = 2
					this.SetRedDotValue(-1, result_data.base_type, result_data.sub_type)
					this.RefreshIconRed(result_data.base_type, result_data.sub_type)
					this.Fire(custom_even.ANSWER_TARGET, result_data.base_type, result_data.sub_type, result_data, reward_data)
				}
			}
		}

		//获取红点的值(值 >0 说明有红点)
		this.GetRedDotValue = (base_type?, sub_type?) => {
			if (this.ActivityNeedHideInAlpha(base_type)) {
				return 0
			}
			let red_list = act_red_state_[base_type]
			if (red_list) {
				return red_list[sub_type] || 0
			}
			return 0
		}

		//设置红点信息
		this.SetActRedDot = (base_type?, sub_type?) => {
			let data = this.GetActData(base_type, sub_type)
			let info = this.GetActInfo(base_type, sub_type)
			let politeData: IS2CTiredChargePoliteParam = TiredChargePoliteModel.GetInstance().GetTiredChargePoliteData();
			if (base_type == TiredChargePoliteModel.ACT_TYPE) { // 累充有礼不走33104所以特殊处理
				if (!(politeData && info)) {
					return;
				}
			} else {
				if (!data || !info) {
					return;
				}
			}

			if (!act_red_state_[base_type]) {
				act_red_state_[base_type] = {}
			}
			act_red_state_[base_type][sub_type] = 0

			let value = 0
			let draw_num = 0
			let is_finish = this.CheckRewardIsAllGain(data)
			value = value + this.CheckFirstRed(base_type, sub_type)
			if (base_type != TiredChargePoliteModel.ACT_TYPE) {
				if (data.reward_list) {
					for (let key in data.reward_list) {
						let reaward = data.reward_list[key]
						if (reaward && reaward.status && reaward.status == 1) {
							value = value + 1
						}
					}
					act_red_state_[base_type][sub_type] = value
				}
			}

			///**
			//* 各自模块特殊的 红点判断 在下面加
			//*/

			switch (base_type) {
				case preload_client_config.ConfigCustomActivity.ACT_ID.TOP_PLAYER:
					let value_TOP_PLAYER = act_red_state_[base_type][sub_type]
					value_TOP_PLAYER += this.CheckFirstRed(base_type, sub_type)
					if (data.rank_info) {
						for (let key in data.rank_info) {
							let vo = data.rank_info[key]
							if (vo.status == 1) {
								value_TOP_PLAYER = value_TOP_PLAYER + 1
							}
						}
					}
					if (data.reward_info) {
						for (let vo of data.reward_info) {
							for (let v of vo.goal) {
								if (v.status == 1) {
									value_TOP_PLAYER = value_TOP_PLAYER + 1
								}
							}
						}
					}
					act_red_state_[base_type][sub_type] = value_TOP_PLAYER

					break;
				case preload_client_config.ConfigCustomActivity.ACT_ID.DAILY_RECHARGE:
					value = act_red_state_[base_type][sub_type]
					if (data.reward_infos) {
						for (let vo of data.reward_infos) {
							if (vo.state == 1) {
								value = value + 1
							}
						}
					}
					if (data.reward_list) {
						for (let vo of data.reward_list) {
							if (vo.state == 1) {
								value = value + 1
							}
						}
					}
					act_red_state_[base_type][sub_type] = value

					break;
				case preload_client_config.ConfigCustomActivity.ACT_ID.ACC_RECHARGE:
					let total = this.GetActRecharge(base_type, sub_type)
					for (let reward of data.reward_list) {
						if (typeof (reward.condition) == "string") {
							reward.condition = erlang_parser.Parse(reward.condition)
						}
						if (reward.status == 0 && reward.condition[0] && reward.condition[0][1]) {
							if (total >= local_Number(reward.condition[0][1])) {
								act_red_state_[base_type][sub_type] = act_red_state_[base_type][sub_type] + 1
							}
						}
					}

					break;
				case preload_client_config.ConfigCustomActivity.ACT_ID.RANK_RECHARGE_LOOP:
				case preload_client_config.ConfigCustomActivity.ACT_ID.FTVRECHARGE:
					let act_total = this.GetActRecharge(base_type, sub_type)
					let day_total = this.GetActRechargeDay()
					value = 0
					for (let reward of data.reward_list) {
						if (reward.status == 2) {
							draw_num = draw_num + 1
						}
						if (reward.status == 1) {
							value = value + 1
							break
						}
						let reward_cond = this.GetActCondition(base_type, sub_type, "data", reward.grade)
						let target_gold = 1
						let _total = 0
						if (reward_cond.type == "1") {
							target_gold = reward_cond.today_gold
							_total = day_total
						} else if (reward_cond.type == "2") {
							target_gold = reward_cond.gold
							_total = act_total
						}
						if (reward.status != 2 && target_gold && _total >= local_Number(target_gold)) {
							value = value + 1
						}
					}
					if (draw_num < Util.TableSize(data.reward_list) && this.CheckFirstRed(base_type, sub_type) > 0) {
						value = value + 1
					}

					act_red_state_[base_type][sub_type] = value

					break;
				case preload_client_config.ConfigCustomActivity.ACT_ID.FASHION:
					//// [ts2lua]act_red_state_下标访问可能不正确
					//// [ts2lua]act_red_state_[base_type]下标访问可能不正确
					//act_red_state_[base_type][sub_type] = 0

					break;
				case preload_client_config.ConfigCustomActivity.ACT_ID.GUILD_FIGHT_ACT:
					//if (! common_mgr.CheckFuncOpenState("GuildFightActView", true) :
					//return
					//}
					//// [ts2lua]act_red_state_下标访问可能不正确
					//// [ts2lua]act_red_state_[base_type]下标访问可能不正确
					//if (act_red_state_[base_type][sub_type] > 0 :
					//return
					//}
					//let cookie_time = cookie_wrapper.GetCookie(CookieWrapper.GUILD_FIGHT_ACT_RED_TIME)
					//let red = ! cookie_time || local_TimeUtil.getServerTime() > local_Number(cookie_time)
					//// [ts2lua]act_red_state_下标访问可能不正确
					//// [ts2lua]act_red_state_[base_type]下标访问可能不正确
					//// [ts2lua]lua中0和空字符串也是true，此处red需要确认
					//act_red_state_[base_type][sub_type] = (red && ( 1 ) || ( 0 ) )

					break;
				case preload_client_config.ConfigCustomActivity.ACT_ID.CREATEGUILD:
					//if (! common_mgr.CheckFuncOpenState("createGuildView", true) :
					//// [ts2lua]act_red_state_下标访问可能不正确
					//// [ts2lua]act_red_state_[base_type]下标访问可能不正确
					//act_red_state_[base_type][sub_type] = 0
					//}

					break;
				case preload_client_config.ConfigCustomActivity.ACT_ID.EGGS:
					//value = 0
					//if (data.cumulate_reward :
					//for (let i in data.cumulate_reward:

					//if (data.cumulate_reward[i].status == 1 :
					//value=value+1
					//}
					//}
					//}
					//value = value + this.FreeCount(base_type, sub_type)
					//value = value + this.CheckFirstRed(base_type, sub_type)
					//// [ts2lua]act_red_state_下标访问可能不正确
					//// [ts2lua]act_red_state_[base_type]下标访问可能不正确
					//act_red_state_[base_type][sub_type] = value

					break;
				case preload_client_config.ConfigCustomActivity.ACT_ID.FTVEXCHANGE:
					value = 0
					value = value + this.CheckFirstRed(base_type, sub_type)
					act_red_state_[base_type][sub_type] = value

					break;
				case preload_client_config.ConfigCustomActivity.ACT_ID.MONEYTREE:
				case preload_client_config.ConfigCustomActivity.ACT_ID.MOUNT_TURNTABLE:
				case preload_client_config.ConfigCustomActivity.ACT_ID.SURPRISE_EGG:
				case preload_client_config.ConfigCustomActivity.ACT_ID.HOLYCALL:
					value = 0
					if (data.cumulate_reward) {
						for (let v of data.cumulate_reward) {
							if (v.status == 1) {
								value = value + 1
							}
						}
					}
					if (data.free_times && data.free_times > 0) {
						value = value + 1
					}
					if (data.rare_draw_times && data.rare_draw_times > 0) {
						value = value + 1
					}
					value = value + this.CheckFirstRed(base_type, sub_type)
					let cond = this.GetActCondition(base_type, sub_type, "info")
					if (cond && local_CustomActivityDefine.Update_Good_Num[base_type]) {
						let goods = cond["goods"] || cond["one_cost"]
						if (goods) {
							for (let vo of goods) {
								let have_num = goods_model.GetTypeGoodsNum(vo[1])
								if (have_num >= local_Number(vo[2])) {
									value = value + 1
								}
							}
						}
						let act = cond["act"]
						if (act) {
							value = value + this.CheckFirstRed(act[1], act[2])
						}
					}
					act_red_state_[base_type][sub_type] = value

					break;
				case preload_client_config.ConfigCustomActivity.ACT_ID.ZERO_MALL:

					value = 0
					data = this.GetActData(base_type, sub_type)
					if (!data) {
						return
					}
					let act_info = this.GetActInfo(base_type, sub_type)
					if (!act_info) {
						return
					}
					let is_grade1 = false
					for (let i in data.reward_list) {
						let info = data.reward_list[i]
						let is_draw = false
						let condition = null
						if (typeof (info.condition) == "string") {
							condition = erlang_parser.Parse(info.condition)
						}
						for (let i in condition) {
							let draw_lv = local_Number(condition[i][1])
							if (condition[i][0] == "lv" && draw_lv > 1) {
								is_grade1 = true
								if (info.status == 0) {
									let desc = null
									if (draw_lv <= role_mgr.mainRoleInfo.level) {
										is_draw = true
										desc = "领取奖励"
									} else {
										desc = `${draw_lv}级可领`
									}
									local_GlobalEventSystem.Fire(ActivityIconManager.SET_ICON_TEXT, `331@${base_type}@${act_info.show_id}`, desc)
								} else {
									this.ShowTimeDown(base_type, sub_type)
								}
								break
							} else if (draw_lv == 1) {
								break
							}
						}
						this.act_key_dic[base_type] = this.act_key_dic[base_type] || {}
						this.act_key_dic[base_type][sub_type] = this.act_key_dic[base_type][sub_type] || {}
						this.act_key_dic[base_type][sub_type][info.grade] = this.act_key_dic[base_type][sub_type][info.grade] || {}
						let first_login = this.act_key_dic[base_type][sub_type][info.grade]["first_login"]
						this.act_key_dic[base_type][sub_type][info.grade]["first_login"] = first_login != undefined ? first_login : this.CheckFirstRed(base_type, sub_type)
						first_login = this.act_key_dic[base_type][sub_type][info.grade]["first_login"]
						let grade_value = 0
						if (info.status == 0) {
							if (is_draw) {
								grade_value = grade_value + 1
							}
						}
						if (info.status && info.status == 1) {
							if (info.receive_time <= local_TimeUtil.getServerTime()) {
								grade_value = grade_value + 1
							}
						}
						if (first_login && this.GetDayFirstLoginStatus()) {
							grade_value = grade_value + 1
						}
						this.SetGradeRed(base_type, sub_type, info.grade, grade_value)
						value = value + grade_value
					}

					if (!is_grade1) {
						this.ShowTimeDown(base_type, sub_type)
					}
					act_red_state_[base_type][sub_type] = value

					break;
				case preload_client_config.ConfigCustomActivity.ACT_ID.LOGGIFT:
					value = 0
					data = this.GetActData(base_type, sub_type)
					for (let key in data.reward_list) {
						if (data.reward_list[key].status == 1) {
							value = value + 1
						} else if (data.reward_list[key].status == 2) {
							draw_num = draw_num + 1
						}
					}
					if (draw_num < Util.TableSize(data.reward_list) && this.CheckFirstRed(base_type, sub_type) > 0) {
						value = value + 1
					}
					act_red_state_[base_type][sub_type] = value

					break;
				case preload_client_config.ConfigCustomActivity.ACT_ID.COST_RANK:
				case preload_client_config.ConfigCustomActivity.ACT_ID.FEASTBOSS:
				case preload_client_config.ConfigCustomActivity.ACT_ID.FTVSHOP:
				case preload_client_config.ConfigCustomActivity.ACT_ID.SNAPUP:
					value = 0
					info = this.GetActInfo(base_type, sub_type)
					value = value + this.CheckFirstRed(base_type, sub_type)
					act_red_state_[base_type][sub_type] = is_finish ? 0 : value
					break;
				case preload_client_config.ConfigCustomActivity.ACT_ID.FTVLIMITGIFT:
					//data = this.GetActData(base_type, sub_type)
					//if (data.reward_list.length == 0 :
					//// [ts2lua]act_red_state_下标访问可能不正确
					//// [ts2lua]act_red_state_[base_type]下标访问可能不正确
					//act_red_state_[base_type][sub_type] = 0
					//let vo = []
					//table.insert(vo, this.GetActInfo(preload_client_config.ConfigCustomActivity.ACT_ID.FTVLIMITGIFT, sub_type))
					//this:DeleteActInfo(vo)
					//let index = this.cache_scmd_33101_list.length - 1
					//do {
					//// [ts2lua]this.cache_scmd_33101_list下标访问可能不正确
					//// [ts2lua]this.cache_scmd_33101_list下标访问可能不正确
					//if (this.cache_scmd_33101_list[index].base_type == vo[0].base_type && this.cache_scmd_33101_list[index].sub_type == vo[0].sub_type :
					//this.cache_scmd_33101_list.splice(index, 1)
					//}
					//index=index-1
					//} while ((index >= 0))
					//return
					//}
					//value = 0
					//for (let key in data.reward_list:

					//// [ts2lua]data.reward_list下标访问可能不正确
					//let grade = data.reward_list[key].grade
					//// [ts2lua]data.reward_list下标访问可能不正确
					//if (this.GetGradeRed(base_type, sub_type, grade) == null && data.reward_list[key].status == 1 :
					//this:SetGradeRed(base_type, sub_type, grade, true)
					//value=value+1
					//}
					//}
					//// [ts2lua]act_red_state_下标访问可能不正确
					//// [ts2lua]act_red_state_[base_type]下标访问可能不正确
					//act_red_state_[base_type][sub_type] = value

					break;
				case preload_client_config.ConfigCustomActivity.ACT_ID.FTVACTIVENESS:
					data = this.GetActData(base_type, sub_type)
					value = 0
					value = value + this.CheckFirstRed(base_type, sub_type)
					for (let i in data.reward_list) {
						if (data.reward_list[i].status == 1) {
							value = value + 1
						}
					}
					if (this.fvt_activeness_time == 0) {
						let cond = this.GetActCondition(base_type, sub_type, "info")
						if (cond) {
							let cost2 = cond.cost2
							let now_time = local_TimeUtil.getServerTime()
							let data = new Date(now_time * 1000)
							data.setHours(7)
							data.setMinutes(0)
							data.setSeconds(0)
							let taget_time = Mathf.Round(data.getTime() / 1000)
							if (now_time < taget_time) {
								act_red_state_[base_type][sub_type] = value
								return
							}
							if (cost2 && cost2.length > 0) {
								let num = goods_model.GetTypeGoodsNum(cost2[0][1])
								if (num >= Number(cost2[0][2])) {
									value = value + 1
								}
							}
						}
					} else {
						if (!ftv_activeness_id_) {
							let outTime = () => {
								this.RequireActInfo(base_type, sub_type)
								this.fvt_activeness_time = 0
								clearTimeout(ftv_activeness_id_)
								ftv_activeness_id_ = null
							}
							ftv_activeness_id_ = setTimeout(outTime, this.fvt_activeness_time)
						}
					}

					act_red_state_[base_type][sub_type] = value

					break;
				case preload_client_config.ConfigCustomActivity.ACT_ID.YOYO_ACT:
					//// [ts2lua]act_red_state_下标访问可能不正确
					//// [ts2lua]act_red_state_[base_type]下标访问可能不正确
					//value = act_red_state_[base_type][sub_type]
					//if (data.reward_infos :
					//for (let _tmpi in data.reward_infos:
					//var vo = data.reward_infos[_tmpi]
					//if (vo.state == 1 :
					//value=value+1
					//}
					//}
					//}
					//if (data.reward_list :
					//for (let _tmpi in data.reward_list:
					//var vo = data.reward_list[_tmpi]
					//if (vo.state == 1 :
					//value=value+1
					//}
					//}
					//}
					//// [ts2lua]act_red_state_下标访问可能不正确
					//// [ts2lua]act_red_state_[base_type]下标访问可能不正确
					//act_red_state_[base_type][sub_type] = value

					break;
				case preload_client_config.ConfigCustomActivity.ACT_ID.FTVCOLLECTION:
					value = 0
					for (let vo of data.reward_list) {
						let cond = this.GetActCondition(base_type, sub_type, "data", vo.grade)
						if (cond) {
							if (cond.goods_exchange) {
								let goods_list = cond.goods_exchange[1]
								let is_exchange = true
								if (goods_list) {
									for (let i in goods_list) {
										let [type_id, lock] = goods_model.GetMappingTypeId(local_Number(goods_list[i][0]), local_Number(goods_list[i][1]))
										let num = goods_model.GetTypeGoodsNum(type_id)
										if (num < local_Number(goods_list[i][2])) {
											is_exchange = false
										}
									}
								}
								if (is_exchange) {
									if (local_Number(cond.personal_num) > 0) {
										if (vo.receive_times && vo.receive_times >= local_Number(cond.personal_num)) {
											is_exchange = false
										}
									}
									if (local_Number(cond.all_num) > 0) {
										if (vo.all_count && vo.all_count >= local_Number(cond.all_num)) {
											is_exchange = false
										}
									}
								}
								if (is_exchange) {
									value = value + 1
								}
							}
						}
						if (value > 0) {
							break
						}
					}
					act_red_state_[base_type][sub_type] = value

					break;
				case preload_client_config.ConfigCustomActivity.ACT_ID.SAIBOTREASURE:
					value = 0
					if (data.stage_s && data.stage_s.length > 0) {
						for (let list of data.stage_s) {
							let grade_value = 0
							for (let vo of list.grade_state) {
								if (vo.state_stage && vo.state_stage == 1) {
									value = value + 1
									grade_value = grade_value + 1
								}
							}
							this.SetGradeRed(base_type, sub_type, list.stage, grade_value)
						}
					}
					value = value + this.CheckFirstRed(base_type, sub_type)
					let cost_cfg = saibo_model.GetCostCfgByTimes(data.today_drawtimes)
					if (cost_cfg && cost_cfg.cost) {
						let goods = JSON.parse(cost_cfg.cost)[0]
						if (goods && Number(goods[2]) == 0) {
							value = value + 1
						}
					}
					act_red_state_[base_type][sub_type] = value

					break;
				case preload_client_config.ConfigCustomActivity.ACT_ID.TURNTABLE:
					value = 0;
					data = TurnTableModel.GetInstance().getTurnTableData(base_type, sub_type);
					if (data) {
						value = data.ticket_num;
					}
					value = value + this.CheckFirstRed(base_type, sub_type);
					act_red_state_[base_type][sub_type] = value;
					break;
				case preload_client_config.ConfigCustomActivity.ACT_ID.SPECIAL_PACKAGE:
					let sp_condition = this.GetActCondition(base_type, sub_type, "info")
					let total_num = 0
					if (sp_condition.vipnumber) {
						total_num = Number(sp_condition.vipnumber[sp_condition.vipnumber.length - 1][1])
					}
					value = 0
					value += this.CheckFirstRed(base_type, sub_type)
					if (total_num != 0 && data.reward_list && data.reward_list[0] && data.reward_list[0].receive_times == total_num) {
						is_finish = true
					}
					act_red_state_[base_type][sub_type] = is_finish ? 0 : value
					break;
				case preload_client_config.ConfigCustomActivity.ACT_ID.RED_ENVELOPE_REBATE: // 红包返利
					value = 0
					value += +RedEnvelopeRebateModel.GetInstance().GetTypesRedDot();
					act_red_state_[base_type][sub_type] = value
					break;
				case preload_client_config.ConfigCustomActivity.ACT_ID.FTVINVEST:
					//let grade_list = []
					//let list = data.reward_list
					//if (! list :
					//return
					//}
					//for (let _tmpi in list:
					//var v = list[_tmpi]
					//let cond = this.GetActCondition(base_type, sub_type, "data", v.grade)
					//if (! cond :
					//break
					//}
					//if (cond.investment_lv :
					//let lv = local_Number(cond.investment_lv)
					//data.grade_list = data.grade_list || {}
					//// [ts2lua]data.grade_list下标访问可能不正确
					//// [ts2lua]data.grade_list下标访问可能不正确
					//data.grade_list[lv] = data.grade_list[lv] || {}
					//// [ts2lua]data.grade_list下标访问可能不正确
					//data.grade_list[lv].level = lv
					//if (cond.login_days :
					//// [ts2lua]data.grade_list下标访问可能不正确
					//// [ts2lua]data.grade_list下标访问可能不正确
					//data.grade_list[lv].return_list = data.grade_list[lv].return_list || {}
					//// [ts2lua]data.grade_list下标访问可能不正确
					//table.insert(data.grade_list[lv].return_list, v)
					//} else if (cond.buy_reward :
					//// [ts2lua]data.grade_list下标访问可能不正确
					//// [ts2lua]data.grade_list下标访问可能不正确
					//data.grade_list[lv].buy_list = data.grade_list[lv].buy_list || {}
					//// [ts2lua]data.grade_list下标访问可能不正确
					//table.insert(data.grade_list[lv].buy_list, v)
					//}
					//}
					//}

					break;
				case preload_client_config.ConfigCustomActivity.ACT_ID.VIPGIFT:
					value = 0
					info = this.GetActInfo(base_type, sub_type)
					// value = value + this.CheckFirstRed(base_type, sub_type)
					data = this.GetActData(base_type, sub_type)
					if (data && data.reward_list) {
						let role_vip = role_mgr.mainRoleInfo.vip_flag
						let limit_vip = role_vip < 4 ? 4 : role_vip + 1
						for (let v of data.reward_list) {
							if (v.status == 0) {
								let cond = this.GetActCondition(base_type, sub_type, "data", v.grade)
								if (cond && cond.vip && limit_vip >= local_Number(cond.vip)) {
									value = value + 1
								}
							}
						}
					}
					act_red_state_[base_type][sub_type] = value

					break;
				case preload_client_config.ConfigCustomActivity.ACT_ID.GODPRAYER:
					//value = 0
					//if (data.free_times :
					//value=value+1
					//}
					//value = value + this.CheckFirstRed(base_type, sub_type)
					//// [ts2lua]act_red_state_下标访问可能不正确
					//// [ts2lua]act_red_state_[base_type]下标访问可能不正确
					//act_red_state_[base_type][sub_type] = value

					break;
				case preload_client_config.ConfigCustomActivity.ACT_ID.OPTIONALLOTTO:
					value = 0
					if (data && data.stage.length > 0) {
						for (let v of data.stage) {
							if (v.status == 1) {
								value = value + 1
							}
						}
					}
					let key = base_type
					value = value + this.CheckFirstRed(base_type, sub_type)
					act_red_state_[base_type][sub_type] = value

					break;
				case preload_client_config.ConfigCustomActivity.ACT_ID.actMarriage:
					value = 0
					let list = data && data.wedding_type_list
					if (list && list.length <= 3) {
						let key = base_type
						value = value + this.CheckFirstRed(base_type, sub_type)
						let is_add = this.getKeyDicValue(base_type, sub_type, "is_add")
						if (is_add) {
							value = value + 1
						} else {
							let old_data = this.getKeyDicValue(base_type, sub_type, "data")
							if (old_data) {
								let old_list = old_data.wedding_type_list
								if (list.length < 3 && list.length > old_list.length) {
									value = value + 1
									this.setKeyDicValue(base_type, sub_type, "is_add", true)
								}
							}
						}
					}
					if (data.if_get_reward == 1) {
						value = value + 1
					}
					act_red_state_[base_type][sub_type] = value

					break;
				case preload_client_config.ConfigCustomActivity.ACT_ID.WISH_POOL:
					value = 0
					if (data.rare_pool) {
						for (let vo of data.rare_pool) {
							if (vo.free_times > 0) {
								value = value + 1
							}
						}
					}
					let info_cond = this.GetActCondition(base_type, sub_type, "info")
					let type_id = info_cond.cost[0][1]
					let goods_num = goods_model.GetTypeGoodsNum(type_id)
					if (goods_num >= 1) {
						value = value + 1
					}
					value = value + this.CheckFirstRed(base_type, sub_type)
					act_red_state_[base_type][sub_type] = value

					break;
				case preload_client_config.ConfigCustomActivity.ACT_ID.ONLINE_DRAW:
					value = 0
					let info81 = this.GetActCondition(base_type, sub_type, "info")
					if (info81 && info81.draw_con) {
						let draw_all = info81.draw_con[2]
						let drawReach = this.getKeyDicValue(base_type, sub_type, "drawReach")
						if (info81.draw_con[1] == "activity") {
							let daily_model = DailyModel.GetInstance()
							// [ts2lua]lua中0和空字符串也是true，此处daily_model.liveness_reward需要确认
							let live = (daily_model.liveness_reward && (daily_model.liveness_reward.live) || (0))
							let fit = true
							if (info81.draw_time) {
								if (info81.draw_time[1] && info81.draw_time[1][0]) {
									fit = false
									let real_time = info81.draw_time[1]
									let curTime = local_TimeUtil.getServerTime()
									let date = new Date(curTime * 1000)
									let year = date.getFullYear()
									let month = date.getMonth() + 1
									let day = date.getDate()
									if ((local_Number(real_time[0]) == year && local_Number(real_time[1]) == month) && local_Number(real_time[2]) == day) {
										fit = true
									}
								} else {
									fit = sever_time_model.GetOpenServerDay() == local_Number(info81.draw_time[1])
								}
							}
							if ((live >= local_Number(draw_all) && !drawReach) && fit) {
								value = value + 1
								this.setKeyDicValue(base_type, sub_type, "drawReach", true)
							}
						} else {
							let lv = role_mgr.mainRoleInfo.level
							if (lv == local_Number(draw_all) && !drawReach) {
								value = value + 1
								this.setKeyDicValue(base_type, sub_type, "drawReach", true)
							}
						}
						value = value + this.CheckFirstRed(base_type, sub_type)
					}
					// [ts2lua]act_red_state_下标访问可能不正确
					// [ts2lua]act_red_state_[base_type]下标访问可能不正确
					act_red_state_[base_type][sub_type] = value

					break;
				case preload_client_config.ConfigCustomActivity.ACT_ID.ACT_TURNTABLE:
				case preload_client_config.ConfigCustomActivity.ACT_ID.REAL_LOTTERY:
					//value = 0
					//let reward_show_dic = []
					//let act = this.GetActInfo(base_type, sub_type)
					//let reward_show_list = erlang_parser.Parse(act.condition)
					//for (let key in reward_show_list:

					//// [ts2lua]reward_show_list下标访问可能不正确
					//let reward_show = reward_show_list[key]
					//// [ts2lua]reward_show_dic下标访问可能不正确
					//reward_show_dic[reward_show[0*/ = reward_show[1]
					//}
					//let _type_id = 38180004
					//let _cost_num = 1
					//// [ts2lua]reward_show_dic下标访问可能不正确
					//if (reward_show_dic["cost"] :
					//// [ts2lua]reward_show_dic下标访问可能不正确
					//_type_id = reward_show_dic["cost"][0][1]
					//// [ts2lua]reward_show_dic下标访问可能不正确
					//_cost_num = reward_show_dic["cost"][0][2]
					//}
					//let now = goods_model.GetTypeGoodsNum(_type_id)
					//if (now >= _cost_num :
					//value=value+1
					//}
					//let max_live = 150
					//// [ts2lua]reward_show_dic下标访问可能不正确
					//if (reward_show_dic["activation"] :
					//// [ts2lua]reward_show_dic下标访问可能不正确
					//max_live = local_Number(reward_show_dic["activation"])
					//}
					//let view_data = this.getKeyDicValue(base_type, sub_type, "data")
					//if (view_data :
					//let get = false
					//let now_live = view_data.activation
					//if (base_type == preload_client_config.ConfigCustomActivity.ACT_ID.ACT_TURNTABLE :
					//if (view_data.activation_state && view_data.activation_state.length > 0 :
					//let state = view_data.activation_state[0]
					//get = state.status == 2
					//}
					//if (now_live >= max_live && ! get :
					//value=value+1
					//}
					//break;case preload_client_config.ConfigCustomActivity.ACT_ID.REAL_LOTTERY :
					//let state = view_data.activation_state
					//if (state :
					//for (let _tmpi in state:
					//var vo = state[_tmpi]
					//if (vo.status == 1 :
					//value=value+1
					//return
					//}
					//}
					//}
					//}
					//}
					//value = value + this.CheckFirstRed(base_type, sub_type)
					//// [ts2lua]act_red_state_下标访问可能不正确
					//// [ts2lua]act_red_state_[base_type]下标访问可能不正确
					//act_red_state_[base_type][sub_type] = value

					break;
				case preload_client_config.ConfigCustomActivity.ACT_ID.KFGROUPBUY:
					value = 0
					let vo_cond = null
					if (!data.gp_goods)
					{
						this.Fire(custom_even.SCMD_REQUEST, 33227, base_type, sub_type)
					} 
					else {
						let info = this.GetActInfo(base_type, sub_type)
						vo_cond = this.GetActCondition(base_type, sub_type, "info")
						if(! vo_cond || ! info )
						{
							return
						}
					}
					let stime = info.stime
					if(vo_cond){
						let buy_time = vo_cond.buy_day * 24 * 3600
						let buy_end_time = stime + buy_time
						let cur_time = TimeUtil.getServerTime()
						if (cur_time > buy_end_time){
							for (let _tmpi in data.gp_goods){
								var vo = data.gp_goods[_tmpi]
								if(vo.first_buy_count > vo.tail_buy_count){
									value = value + 1
								}
							}
						}
						value = value + this.CheckFirstRed(base_type, sub_type)
						act_red_state_[base_type][sub_type] = value
					}
					break;
				case preload_client_config.ConfigCustomActivity.ACT_ID.FORTUNECAT:
					value = 0
					let info_cond87 = this.GetActCondition(base_type, sub_type, "info")
					let type_id87 = info_cond87.cost[0][1]
					let goods_num87 = goods_model.GetTypeGoodsNum(type_id87)
					if (data.turns > 0 && goods_num87 >= data.cgoods_num) {
						value = value + 1
					}
					value = value + this.CheckFirstRed(base_type, sub_type)
					act_red_state_[base_type][sub_type] = value

					break;
				case preload_client_config.ConfigCustomActivity.ACT_ID.LUC_TREA:
					//幸运探宝
					value = 0
					let info_cond80 = this.GetActCondition(base_type, sub_type, "info")
					let type_id80 = info_cond80.one_cost[0][1]
					let limit_cost = CustomActivityModel.LUC_TREA_LIMIT
					let goods_cost_num = info_cond80.one_cost[0][2]
					let goods_num80 = goods_model.GetTypeGoodsNum(type_id80)
					let goods_num_limit= goods_model.GetTypeGoodsNum(limit_cost)
					if ((goods_num80 +goods_num_limit)>= goods_cost_num) {
						value = value + 1
					}
					value = value + this.CheckFirstRed(base_type, sub_type)
					act_red_state_[base_type][sub_type] = value

					break;
				case preload_client_config.ConfigCustomActivity.ACT_ID.MONEYTREE_SHOP:
					this.Fire(custom_even.SCMD_REQUEST, 33231, base_type, sub_type)

					break;
				case preload_client_config.ConfigCustomActivity.ACT_ID.STARTREK:
					value = 0
					for (let v of data.reward_list) {
						if (v.status == 1 && this.GetDayFirstLoginStatus() && this.GetGradeRed(base_type, sub_type, v.grade) != false) {
							value = value + 1
							this.SetGradeRed(base_type, sub_type, v.grade, 1)
						}
					}
					act_red_state_[base_type][sub_type] = value
					break;
				case preload_client_config.ConfigCustomActivity.ACT_ID.FIRST_BLOOD:

					value = 0
					value = FirstBloodModel.GetInstance().GetRed(sub_type)
					act_red_state_[base_type][sub_type] = value
					break;
				case preload_client_config.ConfigCustomActivity.ACT_ID.DESTINY_TURNTABLE:
					value = 0
					if (data.point >= data.need_point && data.turn <= data.max_turn) {
						value = value + 1
					}
					if (value == 0) {
						data = this.GetActData(base_type, sub_type)
						for (let key in data.reward_list) {
							let destiny_vo = data.reward_list[key]
							let condition = ErlangParser.GetInstance().parse(destiny_vo.condition);
							//天命--每日礼包红点判断
							let isGift = false;
							for (let k in condition) {
								if (condition[k][0] == "is_free" && condition[k][1] == "true") {
									isGift = true
									break
								}
							}
							if (isGift && data.reward_list[key].status == "1") {
								value += 1;
								break;
							}
						}
					}
					act_red_state_[base_type][sub_type] = value
					break;
				case preload_client_config.ConfigCustomActivity.ACT_ID.LUCKY_DUOBAO:
					let cookie_value = CookieWrapper.Instance.GetCookie(CookieWrapper.ACT_LUCKY_DUBAO_LIMIT_BUY)
					// if (! ACT_LUCKY_DUBAO_LIMIT_BUY ) {
					if (!cookie_value) {
						act_red_state_[base_type][sub_type] = 1
					} else {
						act_red_state_[base_type][sub_type] = 0
					}
					break;
				case preload_client_config.ConfigCustomActivity.ACT_ID.FIGHT_RANK && sub_type % 2 == 0:
					/*
					value = this.CheckFirstRed(base_type, sub_type)
					if (FightRankModel.GetInstance().GetRed(sub_type):
						value = value + 1
					}
					act_red_state_[base_type][sub_type] = value
					*/
					break;
				case preload_client_config.ConfigCustomActivity.ACT_ID.GASHAPON:
					value = 0
					value += this.CheckFirstRed(base_type, sub_type)
					if (data.one_cost) {
						let cont = ErlangParser.GetInstance().Parse(data.one_cost)
						if (goods_model.GetTypeGoodsNum(cont[0][1]) > 0) {
							act_red_state_[base_type][sub_type] = value + 1
						}
						else {
							act_red_state_[base_type][sub_type] = value
						}
					}
					break;
				case 98:
					value = 0
					value += this.CheckFirstRed(base_type, sub_type)
					act_red_state_[base_type][sub_type] = is_finish ? 0 : value
					break;
				case preload_client_config.ConfigCustomActivity.ACT_ID.DAILY_LOGIN:
					value = 0
					value += this.CheckFirstRed(base_type, sub_type)
					data = this.GetActData(base_type, sub_type)
					for (let key in data.reward_list) {
						if (data.reward_list[key].status == "1") {
							value += 1
						}
					}
					act_red_state_[base_type][sub_type] = value
					break;
				case preload_client_config.ConfigCustomActivity.ACT_ID.ATLISTPURCHASE:
					value = 0
					value += this.CheckFirstRed(base_type, sub_type)
					act_red_state_[base_type][sub_type] = is_finish ? 0 : value
					break;
				case preload_client_config.ConfigCustomActivity.ACT_ID.WXONEMONEY:
					value = 0
					value += this.CheckFirstRed(base_type, sub_type)
					data = this.GetActData(base_type, sub_type)
					for (let key in data.reward_list) {
						if (data.reward_list[key].status == "1") {
							value += 1
						}
					}
					act_red_state_[base_type][sub_type] = value
					break;
				case preload_client_config.ConfigCustomActivity.ACT_ID.DAILY_DIRECT_PURCHASE:
					if (this.specialRedDotMap.get(base_type + '_' + sub_type)) {
						return;
					}
					value = 0;
					//  value += Number(OneDollarSpikeModel.GetInstance().GetDollarSpikeRedDotState(base_type, sub_type));  /* this.CheckFirstRed(,) */
					data = this.GetActData(base_type, sub_type)
					for (let key in data.reward_list) {
						if (data.reward_list[key].status == 0) {
							value += 1
						}
					}
					act_red_state_[base_type][sub_type] = value;
					if (value) {
						this.specialRedDotMap.set(base_type + '_' + sub_type, Boolean(value));
					}
					break;
				case preload_client_config.ConfigCustomActivity.ACT_ID.CON_RECHARGE:
					let cr_today_recharge = CustomActivityModel.GetInstance().GetActRechargeDay() / 10
					let cr_today_num = 0
					let cr_has_gain = false
					if (this.specialRedDotMap.get(base_type + "_" + sub_type)) {
						value = 0
						let data = this.GetActData(base_type, sub_type)
						for (let item of data.reward_list) {
							let cr_cond = this.GetActCondition(base_type, sub_type, "data", item.grade)
							if (cr_cond.tier == 3 && cr_cond.grade == 1) {
								cr_today_num = Number(cr_cond.gold / 10)
							}
							if (item.status == 1) {
								if (!cr_has_gain) cr_has_gain = true
								value += 1
							}
						}
						act_red_state_[base_type][sub_type] = (cr_has_gain || cr_today_recharge < cr_today_num) ? value : false;
						return
					}
					value = 0
					data = this.GetActData(base_type, sub_type)
					for (let item of data.reward_list) {
						let cr_cond = this.GetActCondition(base_type, sub_type, "data", item.grade)
						if (cr_cond.tier == 3 && cr_cond.grade == 1) {
							cr_today_num = Number(cr_cond.gold / 10)
						}
						if (item.status == 1 && !cr_has_gain) {
							cr_has_gain = true
						}
						if (item.status != 2) {
							value += 1
						}
					}
					act_red_state_[base_type][sub_type] = (cr_has_gain || cr_today_recharge < cr_today_num) ? value : false;
					break;
				case preload_client_config.ConfigCustomActivity.ACT_ID.LIST_DUOBAO:
					value = ListDuobaoModel.GetInstance().GetRed()
					act_red_state_[base_type][sub_type] = value;
					break;
				case preload_client_config.ConfigCustomActivity.ACT_ID.CARNIVAL:
					value = 0
					value += this.CheckFirstRed(base_type, sub_type)
					data = this.GetActData(base_type, sub_type)
					for (let key in data.reward_list) {
						if (data.reward_list[key].status == 1) {
							value += 1
						}
					}
					act_red_state_[base_type][sub_type] = value;
					break;
				case preload_client_config.ConfigCustomActivity.ACT_ID.TIRED_CHARGE_POLITE: // 累充有礼
					value = 0
					// value += this.CheckFirstRed(base_type, sub_type)
					data = this.GetActData(base_type, sub_type)
					value = +TiredChargePoliteModel.GetInstance().GetTiredChargePoliteTotalRed();
					act_red_state_[base_type][sub_type] = value;
					break;
				case preload_client_config.ConfigCustomActivity.ACT_ID.CREAT_ROLE_GIFT:
					//创角礼包
					value = 0
					let act_data = data.reward_list[0]
					if (act_data) {
						//可领取时间
						let end_time = Number(ErlangParser.GetInstance().parse(act_data.condition)[0][1])
						value = TimeUtil.getServerTime() >= end_time && act_data.status != 2 ? 1 : 0
					}
					value += this.CheckFirstRed(base_type, sub_type)
					act_red_state_[base_type][sub_type] = value;
					break;
				case preload_client_config.ConfigCustomActivity.ACT_ID.LUC_TREA_TWO:
					//幸运鉴宝
					let my_have = GoodsModel.GetInstance().GetTypeGoodsNum(CustomActivityModel.LUCK_STONE_ID)
					value = my_have > 0 ? 1 : 0
					act_red_state_[base_type][sub_type] = value;
					break;
				case preload_client_config.ConfigCustomActivity.ACT_ID.RANK_RECHARGE_SINGLE:
					//单笔充值
					let value_125 = act_red_state_[base_type][sub_type]
					value_125 += this.CheckFirstRed(base_type, sub_type)
					act_red_state_[base_type][sub_type] = value_125;
					break;
				case preload_client_config.ConfigCustomActivity.ACT_ID.BIND_JAGE_WISH:
					this.act_key_dic[base_type] = this.act_key_dic[base_type] || {}
					this.act_key_dic[base_type][sub_type] = this.act_key_dic[base_type][sub_type] || {}
					let free_times = this.act_key_dic[base_type][sub_type]["free_times"] //免费次数
					let free_gift_status = this.act_key_dic[base_type][sub_type]["free_gift_status"] //免费次数
					value = free_times > 0 || free_gift_status == 1 ? 1 : 0
					act_red_state_[base_type][sub_type] = value
					break
				case preload_client_config.ConfigCustomActivity.ACT_ID.DAILYSUPPLY:
				case preload_client_config.ConfigCustomActivity.ACT_ID.RARE_SURFACE:
					act_red_state_[base_type][sub_type] = is_finish ? 0 : act_red_state_[base_type][sub_type]
					break
				case preload_client_config.ConfigCustomActivity.ACT_ID.ADVERTISEMENT:
					act_red_state_[base_type][sub_type] = this.AdvertisingRed(base_type, sub_type)
					break
			}
		}

		this.CheckRewardIsAllGain = (data) => {
			let is_finish = true
			if (data.reward_list) {
				for (let key in data.reward_list) {
					let reaward = data.reward_list[key]
					if (!reaward || !reaward.status || reaward.status != 2) {
						is_finish = false
					}
				}
			}
			return is_finish
		}
		///**
		//* 特殊界面的红点
		//*/
		//对于特殊界面，type是代表特殊模块需要额外传的东西，例如竞榜需要特殊的类型进行区分
		//sub_type不一定是子类型，代表含义看自身模块设定
		this.GetSpecialRedDotValue = (base_type?, type?, sub_type?) => {
			let value = 0
			let show = null
			base_type = Number(base_type)
			if (preload_client_config.ConfigCustomActivity.SPECIAL_ID.BOOKOFCONTRACT == base_type) {
				//if (! common_mgr.CheckFuncOpenState("BookOfContractView", true) ) {
				//return
				//}
				//show = kaifu_activity_model.GetBookRedDot()
				//// [ts2lua]lua中0和空字符串也是true，此处show需要确认
				//value = (show && ( 1 ) || ( 0 ) )
			} else if (preload_client_config.ConfigCustomActivity.SPECIAL_ID.LEVELREWARD == base_type) {

				if (!common_mgr.CheckFuncOpenState("LevelRewardView", true)) {
					return
				}
				show = WelfareModel.GetInstance().level_reward_red
				value = show ? 1 : 0

			} else if (preload_client_config.ConfigCustomActivity.SPECIAL_ID.COMPETELIST == base_type) {
				/*
				if (!common_mgr.CheckFuncOpenState("CompetelistView", true)) {
					return
				}
				show = compete_list_model.showRedDot(type, sub_type)
				value = show ? 1 : 0
				*/
			} else if (preload_client_config.ConfigCustomActivity.SPECIAL_ID.HOTPOINT == base_type) {

				//sub_type 实际值是show_id
				if (!this.GetSpecialOpenState(base_type, sub_type)) {
					return
				}
				value = HotPointModel.GetInstance().GetRedByShowId(base_type, sub_type)

			}

			return value
		}

		//刷新对应活动红点
		this.RefreshIconRed = (base_type?, sub_type?, _key?) => {
			let info = this.GetActInfo(base_type, sub_type)
			let SpecialList = local_CustomActivityDefine.SpecialView
			let SpecialView = SpecialList[`${base_type}@${sub_type}`]
			let role_lv = role_mgr.mainRoleInfo.level

			//竟榜活动红点特别处理
			/*
			if (_key != undefined) {
				let value = null
				if (_key && _key == preload_client_config.ConfigCustomActivity.SPECIAL_ID.COMPETELIST) {
					value = this.GetSpecialRedDotValue(_key, base_type, sub_type)
				}
				this.Fire(custom_even.UPDATE_TAB_RED, `${_key}@${base_type}@${sub_type}`, value > 0)
				let config = compete_list_model.config_atList[`${base_type}@${sub_type}`];
				if (config) {
					let icon_type = Trim(config.icon)
					local_GlobalEventSystem.Fire(local_EventName.REFRESH_ACTIVITY_ICON_RED_DOT, icon_type, value > 0)
					return
				}
			}
			*/

			//契约挑战红点特别处理
			/*
			if (base_type == preload_client_config.ConfigCustomActivity.ACT_ID.ACTCHALLENGE) {
				ActChallengeModel.GetInstance().SetRedDot(base_type, sub_type)
				this.Fire(custom_even.UPDATE_RED_DOT, base_type, sub_type)
				return
			}
			*/

			if (info || SpecialView) {
				let windows_cfg = preload_client_config.ConfigCustomActivity["windowscomponent"]

				//先判断是不是大图标里的活动
				let icon_type = null
				let k = null
				if (info) {
					k = base_type + "@" + info.show_id
				} else {
					k = base_type + "@" + sub_type
				}
				for (let key in windows_cfg) {
					let icon
					if (key == "331@100" && (base_type == 10 || base_type == 98 || base_type == 100 || base_type == 101)) {  // 头号玩家子页签，有按钮
						icon = activity_icon_mgr.getIconInfo("331@" + k)
						// }else if( key == "331@100" && base_type==113){
						// 	icon=activity_icon_mgr.getIconInfo("331@10@0") //头号玩家子页签，无按钮
					} else {
						icon = activity_icon_mgr.getIconInfo(key)
					}

					if (!icon) {
						icon = activity_icon_mgr.getBoxIconInfo(key)
					}
					if (icon) {
						let view = windows_cfg[key][k]
						if (view && role_lv >= view.open_lv) {
							if (base_type == 98 || base_type == 100) {
								icon_type = "331@" + k
								// }else if (base_type == 113 || base_type == 10){     //共用头号玩家按钮
								// 	icon_type="331@10@0"     
							} else {
								icon_type = key
							}
							let value = null
							if (info && !SpecialView) {
								value = this.GetRedDotValue(base_type, sub_type)
							} else {
								value = this.GetSpecialRedDotValue(base_type, undefined, sub_type)
							}
							this.Fire(custom_even.UPDATE_TAB_RED, k, value > 0)
							let state = this.GetKaiFuActivityRedDot(icon_type, base_type)
							local_GlobalEventSystem.Fire(local_EventName.REFRESH_ACTIVITY_ICON_RED_DOT, icon_type, state)
							break
						}
					} else {
						let value: number = 0;
						// 如果沒有icon可能是只有页签的也需要发送
						if (info && !SpecialView) {
							value = this.GetRedDotValue(base_type, sub_type)
						} else {
							value = this.GetSpecialRedDotValue(base_type, undefined, sub_type)
						}
						this.Fire(custom_even.UPDATE_TAB_RED, k, value > 0)
						local_GlobalEventSystem.Fire(local_EventName.REFRESH_ACTIVITY_ICON_RED_DOT, icon_type, value > 0)
					}
				}

				//先判断子标签及特殊界面
				let itemIcon
				if (icon_type) {
					itemIcon = local_CustomActivityDefine.ShowKeyItemToIcon[`${icon_type}#${k}`]
				}
				if ((itemIcon || !icon_type) && info) { //and info 避免特殊活动的图标没创建导致icon_type =null 导致进方法报错
					//主界面图标单独的活动
					icon_type = local_CustomActivityDefine.ICON_KEY + "@" + base_type + "@" + info.show_id
					let icon_info = activity_icon_mgr.getIconInfo(icon_type)
					if (!icon_info) {
						icon_info = activity_icon_mgr.getBoxIconInfo(icon_type)
					}
					if (!icon_info) { //图标没创建 不处理红点
						return
					}
					let value = this.GetRedDotValue(base_type, sub_type)
					local_GlobalEventSystem.Fire(local_EventName.REFRESH_ACTIVITY_ICON_RED_DOT, icon_type, value > 0)
					this.Fire(custom_even.UPDATE_RED_DOT, base_type, sub_type)
				} else {
					let state = this.GetKaiFuActivityRedDot(icon_type, base_type)
					local_GlobalEventSystem.Fire(local_EventName.REFRESH_ACTIVITY_ICON_RED_DOT, icon_type, state)
				}
			}
		}

		//不要被函数名迷惑。实际是检测大图标icon下所有页签活动的红点情况
		this.GetKaiFuActivityRedDot = (icon_type?, base_type?) => {    //base_type 只有头号玩家页签时使用,特殊处理
			let windows_cfg = preload_client_config.ConfigCustomActivity["windowscomponent"]
			let icon_info = activity_icon_mgr.getIconInfo(icon_type)
			if (!icon_info) {
				icon_info = activity_icon_mgr.getBoxIconInfo(icon_type)
			}
			if (!icon_info && icon_type != "331@110") { //图标没创建 不处理红点
				return
			}
			let state = false
			let value = 0
			let role_lv = role_mgr.mainRoleInfo.level
			let SpecialList = local_CustomActivityDefine.SpecialView
			let id
			if (icon_type == "331@98@0" || icon_type == "331@98@1") { // 超值特惠是子页签，但是单独按钮，特殊处理
				icon_type = "331@100"
				id = 98
			}
			if (icon_type == "331@100@0" || icon_type == "331@100@1") { // 特惠夺宝是子页签，但是单独按钮，特殊处理
				icon_type = "331@100"
				id = 100
			}
			if (icon_type == "331@10@0") {
				icon_type = "331@100"
				// id=base_type
			}
			for (let act_key in windows_cfg[icon_type]) {
				let view = windows_cfg[icon_type][act_key]
				if (role_lv < view.open_lv) continue;
				let data = Split(act_key, "@")
				if (id && id != data[0]) {
					continue
				}

				let info = this.GetActInfoByShowID(data[0], data[1])
				// if (info.base_type == Config.PRELOAD_CLIENT_CONFIG.ConfigCustomActivity.ACT_ID.CREAT_ROLE_GIFT) {
				// 	let gift_data = this.GetActData(info.base_type, info.sub_type);
				// 	let act_data = gift_data && gift_data.reward_list[0] || null;
				// 	if ((!act_data || act_data.status == 2)) {
				// 		continue;
				// 	}
				// }
				let SpecialView = SpecialList[act_key]
				value = 0
				if (info && !SpecialView) {
					value = this.GetRedDotValue(info.base_type, info.sub_type)
					//移植时的处理，未开发功能不计算红点
					let item_class = Config.PRELOAD_CLIENT_CONFIG.ClientCustomActivityIconKey[act_key]
					if (item_class && !window[item_class.module_js_class]) { // 
						value = 0
					}
				} else {
					value = this.GetSpecialRedDotValue(data[0], undefined, data[1])
					//移植时的处理，未开发功能不计算红点
					let special_class = CustomActivityDefine.SpecialView[act_key]
					if (special_class && !window[special_class.module_js_class]) { // 
						value = 0
					}
				}
				if (value > 0) {
					state = true
					break
				}
			}

			if (!state) {
				/*
				let atListOpenDic = compete_list_model.CompeteListOpenDic()
				let _icon_type
				for (let key in atListOpenDic) {
					let openInfo = atListOpenDic[key]
					if (openInfo.end_time > local_TimeUtil.getServerTime()) {
						if (compete_list_model.config_atList) {
							let config = compete_list_model.config_atList[`${openInfo.type}@${openInfo.subtype}`];
							if (config && config.act_type != 1) {
								_icon_type = Trim(config.icon)
								icon_info = common_mgr.GetFunctionIconCfg(_icon_type)
								if (_icon_type == icon_type) {
									value = this.GetSpecialRedDotValue(preload_client_config.ConfigCustomActivity.SPECIAL_ID.COMPETELIST, openInfo.type, openInfo.subtype)
									if (value > 0) {
										state = compete_list_model.showRedDot(openInfo.type, openInfo.subtype)
										break
									}
								}
							}
						}
					}
				}
				*/
			}
			return state
		}

		//设置功能红点值
		this.SetRedDotValue = (value?, base_type?, sub_type?) => {
			let list = act_red_state_[base_type]
			if (list && list[sub_type] != undefined) {
				list[sub_type] = list[sub_type] + value
			}
		}

		//请求获取奖励
		this.RequireGetAward = (base_type?, sub_type?, grade?, count?) => {
			let info = this.GetActInfo(base_type, sub_type)
			if (!info) {
				Message.show("活动已结束")
				return
			}

			//0元礼包返利
			if (base_type == preload_client_config.ConfigCustomActivity["ACT_ID"].ZERO_MALL) {
				this.Fire(custom_even.SCMD_REQUEST, 33138, sub_type, grade)
				return
			}

			//通用的领取协议，特殊的在上面加
			this.Fire(custom_even.SCMD_REQUEST, 33105, base_type, sub_type, grade)
		}

		this.ResetData = () => {
			act_data_list_ = {}
			act_red_state_ = {}
			over_view_data_ = {}
		}

		//获取模型配置
		this.GetUIModelCfg = (type?, sub_type?, grade?) => {
			//// [ts2lua]preload_client_config.ConfigCustomActivity下标访问可能不正确
			//let mCfg = preload_client_config.ConfigCustomActivity["MODEL_CFG"]
			//// [ts2lua]mCfg下标访问可能不正确
			//return mCfg[type + "@" + sub_type + "@" + grade]
		}

		///**
		//* 0元礼包 start
		//* */
		this.ShowTimeDown = (base_type?, sub_type?) => {
			let info = this.GetActInfo(base_type, sub_type)
			let condition = info.condition
			if (typeof (condition) == "string") {
				condition = erlang_parser.Parse(condition)
			}
			let icon_type = local_CustomActivityDefine.ICON_KEY + "@" + base_type + "@" + info.show_id
			if (condition) {
				for (let v of condition) {
					if (v[0] == "buy_day") {
						let all_second = local_Number(v[1]) * 24 * 3600
						let end_time = info.stime + all_second
						this.Fire(custom_even.REFRESHCOUNTDOWN, icon_type, end_time, end_time > local_TimeUtil.getServerTime())
					}
				}
			}
		}
		///**
		//* 0元礼包  }
		//* */

		///**
		//* 活动充值  start
		//* */

		this.SetActRecharge = (type?, sub_type?, number?) => {
			if (!recharge_list_) {
				recharge_list_ = {}
			}
			let act_info = this.GetActInfo(type, sub_type)
			if (!act_info) {
				return
			}
			recharge_list_[type] = recharge_list_[type] ? recharge_list_[type] : {}
			recharge_list_[type][sub_type] = number
			this.SetActRedDot(type, sub_type)
			this.RefreshIconRed(type, sub_type)
			this.Fire(custom_even.UPDATE_ACT_RECHANGE, type, sub_type)
		}

		this.GetActRecharge = (type?, sub_type?) => {
			if (!recharge_list_) {
				recharge_list_ = {}
			}
			let act_info = this.GetActInfo(type, sub_type)
			if (!act_info) {
				return
			}
			return recharge_list_ && recharge_list_[type] && recharge_list_[type][sub_type] || 0
		}

		this.SetActRechargeDay = (number?) => {
			this.recharge_day_ = number
			this.Fire(custom_even.UPDATE_ACT_RECHANGE_DAY)
		}

		this.GetActRechargeDay = () => {
			return this.recharge_day_
		}

		//充值日结
		this.UpdataRechargeSum = (base_type?, sub_type?) => {
			if (base_type == 14 || base_type == 124 || base_type == 131) {
				this.Fire(custom_even.SCMD_REQUEST, 15958, base_type, sub_type)
				this.Fire(custom_even.SCMD_REQUEST, 15959)
			}
		}

		///**
		//* 活动充值  }
		//* */

		this.GetRewardsBySex = (reward_list?) => {
			let rewards = erlang_parser.Parse(reward_list)
			let sex = role_mgr.GetMainRoleVo().sex
			for (let info of rewards) {
				if (local_Number(info[0]) != sex) continue
				return info[1]
			}
			return rewards
		}

		//砸蛋
		this.FreeCount = (base_type?, sub_type?, return_max?) => {
			//let data = this.GetActData(base_type, sub_type)
			//let condition = null
			//if (typeof(this.GetActInfo(base_type, sub_type).condition) == "string" ) {
			//this:GetActInfo(base_type, sub_type).condition = erlang_parser.Parse(this.GetActInfo(base_type, sub_type).condition)
			//}
			//condition = this.GetActInfo(base_type, sub_type).condition
			//let free_times = null
			//let free_time = null
			//let free_max = null
			//for (let i in condition) {

			//if (condition[i][0] == "free_times" ) {
			//free_times = local_Number(condition[i][1])
			//}
			//if (condition[i][0] == "free_time" ) {
			//free_time = local_Number(condition[i][1])
			//}
			//if (condition[i][0] == "free_max" ) {
			//free_max = local_Number(condition[i][1])
			//}
			//}
			//let count = Math.floor(local_TimeUtil.getServerTime() - data.start_time / free_time)
			//let return_count = null
			//if (data.free_smashed_times >= free_max ) {
			//return_count = 0
			//}else{
			//// [ts2lua]lua中0和空字符串也是true，此处count + 1 >= free_max需要确认
			//return_count = (count + 1 >= free_max && ( free_max ) || ( count + free_times ) )
			//return_count = return_count - data.free_smashed_times
			//}
			//if (return_max ) {
			//return {return_count, free_max, free_time, free_times}
			//}else{
			//return return_count
			//}
		}

		///*
		//*监听活动有关道具
		//*/
		this.UpdataACTGoodsNum = (list?) => {
			for (let base_type in local_CustomActivityDefine.Update_Good_Num) {
				if (!local_CustomActivityDefine.Update_Good_Num[base_type]) {
					break
				}
				let key
				switch (local_Number(base_type)) {
					case preload_client_config.ConfigCustomActivity.ACT_ID.FTVEXCHANGE:
						key = `goods_type`
						break
					case preload_client_config.ConfigCustomActivity.ACT_ID.FTVACTIVENESS:
						key = `cost2`
						break
					case preload_client_config.ConfigCustomActivity.ACT_ID.SAIBOTREASURE:
						key = `goods`
						break
					case preload_client_config.ConfigCustomActivity.ACT_ID.MONEYTREE:
					case preload_client_config.ConfigCustomActivity.ACT_ID.MOUNT_TURNTABLE:
					case preload_client_config.ConfigCustomActivity.ACT_ID.SURPRISE_EGG:
					case preload_client_config.ConfigCustomActivity.ACT_ID.HOLYCALL:
					case preload_client_config.ConfigCustomActivity.ACT_ID.GODPRAYER:
					case preload_client_config.ConfigCustomActivity.ACT_ID.LUC_TREA:
						key = `one_cost`
						break
					case preload_client_config.ConfigCustomActivity.ACT_ID.FTVCOLLECTION:
						key = `drops`
						break
					case preload_client_config.ConfigCustomActivity.ACT_ID.WISH_POOL:
					case preload_client_config.ConfigCustomActivity.ACT_ID.REAL_LOTTERY:
					case preload_client_config.ConfigCustomActivity.ACT_ID.FORTUNECAT:
						key = `cost`
						break
				}

				let info = act_info_list_[base_type]

				let obj_ ={}
				for (let good of list) {
					obj_[good.type_id]=1
				}

				if (Number(base_type) == 103) {  //判断扭蛋机是否刷新数据
					for (let key in info) {
						if (obj_[38180013]) {
							this.Fire(custom_even.SCMD_REQUEST, 33245, info[key].base_type, info[key].sub_type)
						}
					}
				}

				//幸运夺宝  限时夺宝币特殊处理
				if (Number(base_type) == preload_client_config.ConfigCustomActivity.ACT_ID.LUC_TREA) {
					if (obj_[CustomActivityModel.LUC_TREA_LIMIT]) {
						for (let i in info) {
							this.SetActRedDot(info[i].base_type, info[i].sub_type)
							this.RefreshIconRed(info[i].base_type, info[i].sub_type)
						}
					}
				}


				if (info && key) {
					for (let i in info) {
						let cond = this.GetActCondition(info[i].base_type, info[i].sub_type, "info")
						if (cond && cond[key]) {
							let v = cond[key]
							let bool = false
							for (let j in v) {
								for (let good of list) {
									if (good.type_id == Number(v[j][1])) {
										this.SetActRedDot(info[i].base_type, info[i].sub_type)
										this.RefreshIconRed(info[i].base_type, info[i].sub_type)
										// bool = true
										break
									}
								}
								if (bool) {

									break
								}
							}
							// break
						}
					}
				}
			}
		}

		//检测登录红点
		this.CheckFirstRed = (base_type?, sub_type?) => {
			let value = 0
			let key = `${base_type}@${sub_type}`
			let first_red = local_CustomActivityDefine.First_Show_Red
			let day_firse_red = local_CustomActivityDefine.Day_First_Show_Red
			if (firstRed_dic_[key] != false) {
				if (first_red[base_type] && this.CheckCanAddRedCondition(base_type, sub_type)) {
					value = value + 1
				} else if (day_firse_red[base_type] && this.GetDayFirstLoginStatus()) {
					value = value + 1
				}
			}
			return value
		}

		this.CheckCanAddRedCondition = (base_type?, sub_type?) => {
			let bool = true
			if (base_type && sub_type) {
				switch (base_type) {
					case preload_client_config.ConfigCustomActivity.ACT_ID.SUPERGIFT:
						let data = this.GetActData(base_type, sub_type)
						let reward_list = data.reward_list
						let have_receive = false
						for (let key in reward_list) {
							let vo = reward_list[key]
							let cond = this.GetActCondition(data.base_type, data.sub_type, "data", vo.grade)
							if (cond && !cond.is_free && (Number(cond.exchange_num) - vo.receive_times) > 0) {
								have_receive = true
								break
							}
						}
						if (!have_receive) bool = false
						break;
					case preload_client_config.ConfigCustomActivity.ACT_ID.CREAT_ROLE_GIFT:
						let gift_data = this.GetActData(base_type, sub_type)
						let act_data = gift_data && gift_data.reward_list[0] || null
						if ((!act_data || act_data.status == 2)) {
							bool = false
						}
						break;
				}
			}

			return bool
		}
		///**
		//* 打开页面后，关闭该类型的红点
		//*/
		this.CloseACTRed = (base_type?, sub_type?, grade?, show_id?) => {
			if (act_red_state_ && act_red_state_[base_type]
				&& act_red_state_[base_type][sub_type]) {
				let key = `${base_type}@${sub_type}`
				if (this.CheckFirstRed(base_type, sub_type) > 0) {
					if (base_type == preload_client_config.ConfigCustomActivity.ACT_ID.ZERO_MALL) {
						if (this.act_key_dic[base_type] && this.act_key_dic[base_type][sub_type]
							&& this.act_key_dic[base_type][sub_type][grade]) {
							let first_login = this.act_key_dic[base_type][sub_type][grade]["first_login"]
							if (first_login) {
								this.act_key_dic[base_type][sub_type][grade]["first_login"] = false
								let value = this.GetGradeRed(base_type, sub_type, grade)
								if (value) {
									this.SetGradeRed(base_type, sub_type, grade, value - 1)
									act_red_state_[base_type][sub_type] -= 1
								}
							}
						}
					} else if (base_type == preload_client_config.ConfigCustomActivity.ACT_ID.MONEYTREE_SHOP) {
						act_red_state_[base_type][sub_type] -= 1
						firstRed_dic_[key] = false
						let _type = preload_client_config.ConfigCustomActivity.ACT_ID.MONEYTREE
						let moneytree = act_red_state_[_type]
						if (moneytree) {
							for (let key in moneytree) {
								moneytree[key] = moneytree[key] - 1
								this.RefreshIconRed(_type, key)
							}
						}
					} else {
						if (base_type == 71) {
							this.RefreshIconRed(base_type, sub_type)
							return
						}
						act_red_state_[base_type][sub_type] -= 1
						firstRed_dic_[key] = false
					}
				}

				// 清理该类型所有红点
				if (this.specialRedDotMap.get(base_type + '_' + sub_type)) {
					act_red_state_[base_type][sub_type] = 0;
				}

				this.RefreshIconRed(base_type, sub_type)
			}



		}

		///**
		//* 设置同一活动不同档位页签红点
		//*/
		this.SetGradeRed = (base_type?, sub_type?, grade?, value?) => {
			act_touch_grade_[base_type] = act_touch_grade_[base_type] || {}
			act_touch_grade_[base_type][sub_type] = act_touch_grade_[base_type][sub_type] || {}
			let grade_info = act_touch_grade_[base_type][sub_type]
			if (grade_info) {
				grade_info[grade] = value
			}
		}

		///**
		//* 获取同一活动不同档位页签红点
		//*/
		this.GetGradeRed = (base_type?, sub_type?, grade?) => {
			let grade_info = act_touch_grade_[base_type] && act_touch_grade_[base_type][sub_type]
			if (grade_info) {
				return grade_info[grade]
			}
			return undefined
		}

		this.GetActInfoByType = (base_type?) => {
			let info = act_info_list_ && act_info_list_[base_type]
			if (info) {
				for (let key in info) {
					let value = info[key]
					if (value) {
						return value
					}
				}
			}
		}

		this.GetSpecialOpenState = (base_type?, sub_type?) => {
			let bool = false
			let special_types = preload_client_config.ConfigCustomActivity.SPECIAL_ID
			let main_role_vo = role_mgr.GetMainRoleVo()
			let open_day = sever_time_model.GetOpenServerDay()
			switch (local_Number(base_type)) {
				case special_types["BOOKOFCONTRACT"]:
					// bool = common_mgr.CheckFuncOpenState("BookOfContractView", true) && !kaifu_activity_model.finishAll();
					bool = false
					break
				case special_types["LEVELREWARD"]:

					bool = common_mgr.CheckFuncOpenState("LevelRewardView", true)
					let draw_over
					let info = WelfareModel.GetInstance().GetLevelRewardInfo()
					if (info) {
						draw_over = true
						let list = info.giftbag_state
						for (let i in list) {
							let v = list[i]
							if (v.received != 2) {
								draw_over = false
								break
							}
						}
					}
					bool = draw_over ? false : bool

					break
				case special_types["HOTPOINT"]:
					bool = HotPointModel.GetInstance().GetOpenSatuts(base_type, sub_type)
					break
			}

			return bool
		}

		this.GetActivenessStatus = (key?) => {
			if (Util.IsTableEmpty(special_open_list_)) {
				return false
			}
			let time = 0
			for (let i in special_open_list_[key]) {
				if (special_open_list_[key][i][0]) {
					time = local_TimeUtil.getServerTime() > special_open_list_[key][i][1] ? 0 : special_open_list_[key][i][1]
				}
			}

			if (time > 0) {
				activity_icon_mgr.addIcon(key, time)
				return true
			}
			activity_icon_mgr.deleteIcon(key)
			return false
		}

		this.FTVActivenessAllReward = (data?) => {
			if (!data) {
				return
			}
			if (!data.reward_list) {
				return
			}
			let value = 0
			for (let v of data.reward_list) {
				if (typeof (v.condition) == "string") {
					v.condition = erlang_parser.Parse(v.condition)
				}
				if (v.hasOwnProperty("param")) {
					for (let vo of v.condition) {
						let sever_time = local_TimeUtil.getServerTime()
						if (vo[0] == "ser_reward_type" && (vo[1][0] == 1 || vo[1][0] == 2)) {
							let num = vo[1][0] == 1 ? local_DungeonEnterView.Index.Exp : local_DungeonEnterView.Index.Material
							special_open_list_[`331@56${num}`] = special_open_list_[`331@56${num}`] || {}
							if (local_Number(v.param) - sever_time > 0) {
								special_open_list_[`331@56${num}`][v.grade] = [true, local_Number(v.param)]
							} else {
								special_open_list_[`331@56${num}`][v.grade] = [false, 0]
							}
						} if (vo[0] == "ser_reward_type" && vo[1][0] == 6) {
							//新增的1.15倍资源副本
							let key163 = CustomActivityModel.MATIAL_ICON_115
							special_open_list_[key163] = special_open_list_[key163] || {}
							if (local_Number(v.param) - sever_time > 0) {
								special_open_list_[key163][v.grade] = [true, local_Number(v.param)]
							} else {
								special_open_list_[key163][v.grade] = [false, 0]
							}
						} else if (vo[0] == "ser_reward_type" && vo[1][0] == 5) {
							let key = `${data.base_type}@${data.sub_type}`
							special_open_list_[key] = special_open_list_[key] || {}
							let left_time = local_Number(v.param)
							if (left_time > sever_time) {
								special_open_list_[key][v.grade] = [true, local_Number(v.param)]
							} else {
								special_open_list_[key][v.grade] = [false, 0]
							}
							let time = 0
							for (let i in special_open_list_[key]) {
								if (special_open_list_[key][i][0]) {
									time = sever_time > special_open_list_[key][i][1] ? 0 : special_open_list_[key][i][1]
								}
							}
							this.Fire(custom_even.REFRESHCOUNTDOWN, 416, time, time > 0)
						}
					}
				}
			}

		}

		this.GetActIconType = (base_type?, sub_type?, is_alert?) => {
			let info = this.GetActInfo(Number(base_type), Number(sub_type))
			if (!info) {
				if (is_alert) {
					Message.show("活动未开启")
				}
				return [null, null, null]
			}
			let iconType = "331@" + base_type + "@" + info.show_id
			let cfg = common_mgr.GetFunctionIconCfg(iconType)
			if (base_type == "67") {
				cfg = null
			}
			let role_lv = role_mgr.mainRoleInfo.level
			if (!cfg) {
				iconType = null
				let windows_cfg = preload_client_config.ConfigCustomActivity["windowscomponent"]
				let k = base_type + "@" + info.show_id
				for (let key in windows_cfg) {
					let vo = windows_cfg[key][k]
					if (vo) {
						if (vo.open_lv > role_lv) {
							if (is_alert) {
								local_Message.show("等级不足," + vo.open_lv + "级开放")
							}
							return [null, null, null]
						} else {
							return [key, base_type, info.show_id]
						}
					}
				}
			} else {
				if (this.GetOpenState(iconType, is_alert)) {
					return [iconType, null, null]
				}
			}
			return [null, null, null]
		}

		//更新云购阶段奖励数据
		this.UpdateClouldPurchaseStageState = (scmd?) => {
			//let reward_list = []
			//let data = this.GetActData(preload_client_config.ConfigCustomActivity.ACT_ID.CLOUD_PURCHASE, scmd.sub_type)
			//if (data ) {
			//let find = false
			//let new_vo = null
			//new_vo = []
			//new_vo.buy_times = scmd.buy_times
			//new_vo.state = 2
			//if (data.stage.length > 0 ) {
			//for (let _tmpi in data.stage) {
			//var vo = data.stage[_tmpi]
			//if (vo.buy_times == scmd.buy_times ) {
			//find = true
			//vo.state = 2
			//}
			//if (! find ) {
			//table.insert(data.stage, new_vo)
			//}
			//}
			//}else{
			//table.insert(data.stage, new_vo)
			//}
			//if (config_cloudbuy_stage_award_ ) {
			//let tmp = null
			//for (let key in config_cloudbuy_stage_award_) {

			//// [ts2lua]config_cloudbuy_stage_award_下标访问可能不正确
			//tmp = config_cloudbuy_stage_award_[key]
			//if (tmp.buy_times == scmd.buy_times ) {
			//let reward = JSON.parse(tmp.reward)
			//if (reward ) {
			//reward_list = reward
			//break
			//}
			//}
			//}
			//}
			//}
			//return reward_list
		}

		//**
		//* start  活动条件
		//*
		this.SetActInfoCondition = (v?) => {
			if (v && v.condition != "[]" && typeof (v.condition) == "string") {
				let cond = erlang_parser.Parse(v.condition)
				condition_dic_[v.base_type] = condition_dic_[v.base_type] || {}
				condition_dic_[v.base_type][v.sub_type] = condition_dic_[v.base_type][v.sub_type] || {}
				condition_dic_[v.base_type][v.sub_type]["info"] = condition_dic_[v.base_type][v.sub_type]["info"] || {}
				for (let i in cond) {
					let c = cond[i]
					condition_dic_[v.base_type][v.sub_type]["info"][c[0]] = local_Util.TableSize(c) == 2 ? c[1] : c
				}
			}
		}

		this.SetActDataCondition = (data?) => {
			///**
			//* 默认模块条件
			//*/
			if (data.reward_list) {
				for (let grade of data.reward_list) {
					if (grade.condition != "[]" && typeof (grade.condition) == "string") {
						let cond = erlang_parser.Parse(grade.condition)
						condition_dic_[data.base_type] = condition_dic_[data.base_type] || {}
						condition_dic_[data.base_type][data.sub_type] = condition_dic_[data.base_type][data.sub_type] || {}
						condition_dic_[data.base_type][data.sub_type]["data"] = condition_dic_[data.base_type][data.sub_type]["data"] || {}
						condition_dic_[data.base_type][data.sub_type]["data"][grade.grade] = condition_dic_[data.base_type][data.sub_type]["data"][grade.grade] || {}
						for (let i in cond) {
							let c = cond[i]
							condition_dic_[data.base_type][data.sub_type]["data"][grade.grade][c[0]] = local_Util.TableSize(c) == 2 ? c[1] : c
						}
					}
				}
			}
		}

		///**
		//* 活动条件
		//* cond_type: info 或者 data 的条件
		//* grade: data中的档位,必须给cond_type传"data"
		//*/
		this.GetActCondition = (base_type?, sub_type?, cond_type?, grade?) => {
			if (condition_dic_[base_type] && condition_dic_[base_type][sub_type]) {
				if (cond_type == "data" && grade && grade > 0 && condition_dic_[base_type][sub_type][cond_type]) {
					return condition_dic_[base_type][sub_type][cond_type][grade]
				} else if (cond_type) {
					return condition_dic_[base_type][sub_type][cond_type]
				} else {
					return condition_dic_[base_type][sub_type]
				}
			}
			return null
		}

		///**
		//* 保存全服计数器数量
		//*/
		this.SetActDataAllCount = (scmd?) => {
			if (scmd) {
				let base_type = scmd.base_type
				let sub_type = scmd.sub_type
				let grade = scmd.grade
				let data = this.GetActData(base_type, sub_type)
				let grade_info = this.GetAwardDataById(base_type, sub_type, grade)
				let grade_cond = this.GetActCondition(base_type, sub_type, "data", grade)
				if (data && grade_info) {
					switch (base_type) {
						case preload_client_config.ConfigCustomActivity.ACT_ID.FTVSHOP:
						case preload_client_config.ConfigCustomActivity.ACT_ID.SNAPUP:
							grade_info.all_count = scmd.count
							if (scmd.count == local_Number(grade_cond.all_num))
								grade_info.status = 2
							break
						case preload_client_config.ConfigCustomActivity.ACT_ID.FTVCOLLECTION:
							grade_info.all_count = scmd.count
							if (this.CheckFirstRed(base_type, sub_type)) {
								this.SetActRedDot(base_type, sub_type)
								this.RefreshIconRed(base_type, sub_type)
							}
							break
					}
				}
			}
		}

		this.GetFeastBossIconType = () => {
			let icon_type = null
			let info = this.GetActInfoByType(51)
			if (info) {
				icon_type = info.show_id == 0 ? `331@4` : `331@4_${info.show_id}`
			}
			return icon_type
		}

		///**
		//* 331@3中页签特殊判断
		//*/
		this.CheckSpecialIcon = (icon_type?) => {
			let window_list = preload_client_config.ConfigCustomActivity.windowscomponent[icon_type]
			let bool = false
			for (let key in window_list) {
				let list = Split(key, "@")
				let info = this.GetActInfoByShowID(list[0], list[1])
				let role_lv = role_mgr.mainRoleInfo.level
				let info2 = window_list[key]
				if (info && role_lv >= info2.open_lv) {
					bool = true
					break
					/*FirstBloodModel
					if (list[0] == "96") {
						bool = !FirstBloodModel.GetInstance().ReceiveAll(info.sub_type)
					} else {
						bool = true
					}
					if (bool) {
						break
					}
					*/
				} else {
					let special_class = local_CustomActivityDefine.SpecialView[key]
					if (special_class && role_lv >= info2.open_lv) {
						let open_state = this.GetSpecialOpenState(list[0], list[1])
						if (open_state) {
							bool = true
							break
						}
					}
				}
			}
			if (!bool) {
				let delete_list = {}
				delete_list[icon_type] = true
				this.DeleteActivityIcons(delete_list)
			}
		}

		//**
		//* 检测玩家是否是当天第一次登陆
		//*
		this.CheckDayFristLogin = () => {
			let last_date = cookie_wrapper.GetCookie(CookieWrapper.LAST_LOGIN_DATE)
			let now_date = new Date()
			let date = `${now_date.getFullYear()}-${now_date.getMonth() + 1}-${now_date.getDate()}`
			if (last_date != date) {
				is_dayFirstLogin_ = true
			}
			cookie_wrapper.SaveCookie(CookieWrapper.LAST_LOGIN_DATE, date)
		}

		this.GetDayFirstLoginStatus = () => {
			return is_dayFirstLogin_
		}

		this.GetActReward = (base_type?, sub_type?, reward_type?, reward?, limit_sex?) => {
			let reward_list = []
			let info = this.GetActInfo(base_type, sub_type)
			let sex = limit_sex != undefined ? limit_sex : role_mgr.GetMainRoleVo().sex
			let lv = RoleManager.GetInstance().mainRoleInfo.level
			let last_info

			switch (reward_type) {
				case local_CustomActivityModel.RewardType.Default:
					reward_list = erlang_parser.Parse(reward)
					break
				case local_CustomActivityModel.RewardType.Sex:
					let sex_rewards = erlang_parser.Parse(reward)
					for (let vo of sex_rewards) {
						if (local_Number(vo[0]) != sex) continue
						reward_list = vo[1]
					}
					break
				case local_CustomActivityModel.RewardType.World:
					if (info) {
						let wlv = info.wlv
						let world_rewards = erlang_parser.Parse(reward)
						for (let vo of world_rewards) {
							if (local_Number(vo[0]) > wlv) {
								break
							}
							last_info = vo[1]
						}
						if (last_info) {
							reward_list = last_info
						}
					}
					break
				case local_CustomActivityModel.RewardType.Level:
					let world_rewards = erlang_parser.Parse(reward)
					for (let vo of world_rewards) {
						if (local_Number(vo[0][1]) >= lv && local_Number(vo[0][0]) <= lv) {
							last_info = vo[1]
							break
						}
					}
					if (last_info) {
						reward_list = last_info
					}
					break
				case local_CustomActivityModel.RewardType.LevelAndSex:
					let LevelAndSex_rewards = erlang_parser.Parse(reward)
					for (let vo of LevelAndSex_rewards) {
						if (local_Number(vo[0][1]) >= lv && local_Number(vo[0][0]) <= lv) {
							last_info = vo[1]
							break
						}
					}
					if (last_info) {
						for (let v of last_info) {
							if (local_Number(v[0]) != sex) continue
							reward_list = v[1]
						}
					}
					break
				case local_CustomActivityModel.RewardType.WorldAddSex:

					let list
					if (info) {
						let wlv = info.wlv
						let world_rewards = erlang_parser.Parse(reward)
						for (let vo of world_rewards) {
							if (local_Number(vo[0][0]) <= wlv && local_Number(vo[0][1]) >= wlv) {
								last_info = vo[1]
								break
							}
						}
						if (last_info) {
							list = last_info
						}
					}
					if (list) {
						for (let v of list) {
							if (local_Number(v[0]) != sex) continue
							reward_list = v[1]
						}
					}
					break
			}

			return reward_list
		}

		//根据奖励类型筛选活动档位
		this.GetActAllGrade = (data?) => {
			if (!data) {
				return
			}
			let base_type = data.base_type
			let sub_type = data.sub_type
			let info = this.GetActInfo(base_type, sub_type)
			if (!info) {
				return
			}
			let key = `${base_type}@${info.show_id}`
			if (preload_client_config.ConfigCustomActivity.Need_Filtrate_Grade[base_type]
				|| preload_client_config.ConfigCustomActivity.Need_Filtrate_Grade[key]) {
				if (data.reward_list) {
					for (let i = data.reward_list.length - 1; i >= 0; i--) {
						let grade_data = data.reward_list[i]
						let rewards = this.GetActReward(base_type, sub_type, grade_data.form_type, grade_data.reward)
						if (!rewards || rewards.length <= 0) {
							data.reward_list.splice(i, 1)
						}
					}
				}
			}
		}

		/**
		 * @param model_id [模型类型，模型id，1] 由于2.5D项目的模型id有可能相同，因此需要类型来进行分辨
		 */
		this.ShowViewModel = (ref_tar, view_name?, model_id?, parent?, call_func?, is_use_model_id?, cur_sorting_order?, action_list?, can_rotate?, enableHDR?) => {
			if (typeof model_id == "number") {
				return
			}

			let cfg = Config.PRELOAD_CLIENT_CONFIG.UIModelParameter
			let mainVo = role_mgr.GetMainRoleVo()

			//创建模型需要的参数
			let _res_id = Number(model_id[1])
			let _role_res = mainVo.GetRoleClotheId()
			let [_fashion_id, _texture_id] = mainVo.GetRoleClotheTextureId()
			let [_head_res, _head_texture_id] = mainVo.GetRoleHeadId()
			let head_clothe_id = undefined
			let _type = model_id[0]
			let _layout_file = view_name
			// let _layer_value = ref_tar.layer_value
			let _sex = mainVo.sex
			let _career = mainVo.career
			let can_rotate_ = true
			let is_hair = false
			let is_god = false
			let is_act = false
			let is_back = false;
			if (can_rotate == false) {
				can_rotate_ = can_rotate
			}

			let set_id: string = String(_res_id)
			//////////不同模型大类的处理//////////////

			//根据性别组装
			let sub_sex = (m_type?) => {
				set_id = set_id.substring(0, 1) + _sex + set_id.substring(2, 4)
				if (is_hair)
					_head_res = Number(set_id)
				else if (is_act) {
					_head_res = Number(set_id)
					_res_id = Number(set_id)
				}
				else
					_res_id = Number(set_id)
			}
			//////////不同模型大类的处理//////////////

			if (model_id[0] == UI_MODEL_TYPE.HAIR) {
				is_hair = true
				_type = UI_MODEL_TYPE.ROLE
				//发饰特殊处理
				_res_id = _role_res
				_head_res = Number(model_id[1])
				head_clothe_id = undefined
			} else if (model_id[0] == UI_MODEL_TYPE.GOD) {
				is_god = true
			}
			else if (model_id[0] == UI_MODEL_TYPE.ACT) {
				is_act = true
				_type = UI_MODEL_TYPE.ROLE
				_res_id = Number(model_id[1])
				_head_res = Number(model_id[1])
				head_clothe_id = undefined
			} else if (model_id[0] == UI_MODEL_TYPE.BACKORNAMENT) {
				is_back = true
			}

			if (!is_hair) {
				_res_id = Number(model_id[1])
			}

			//单独界面参数,如果没有，使用全局默认
			if (!cfg[_layout_file]) {
				_layout_file = null
			}

			//创建模型
			let data = {}
			if (_type == UI_MODEL_TYPE.ROLE) {

				sub_sex()
				//角色
				data = {
					career: _career,
					sex: _sex,
					type: _type,
					clothe_res_id: _res_id,
					head_wear_id: _head_res,
					head_clothe_id: head_clothe_id,
					layout_file: _layout_file,
					load_call_back: call_func,
					can_rotate: can_rotate_,
					custom_sorting_order: cur_sorting_order,
					action_name_list: action_list,
					enableHDR: enableHDR,
				}
				if (is_hair) {
					data["fashion_model_id"] = _fashion_id
					data["texture_id"] = _texture_id
					data["is_hair"] = is_hair
				}
				ResManager.GetInstance().SetRoleModel(ref_tar, parent, data)
			} else {
				//其他
				data = {
					type: _type,
					clothe_res_id: _res_id,
					// layer_value : _layer_value,
					layout_file: _layout_file,
					load_call_back: call_func,
					can_rotate: can_rotate_,
					custom_sorting_order: cur_sorting_order,
					action_name_list: action_list,
					enableHDR: enableHDR,
				}
				if (is_god) {
					data["weapon_res_id"] = _res_id
					data["wing_id"] = _res_id
				}
				if (is_back) {
					data["back_ornament_id"] = _res_id
				}
				ResManager.GetInstance().SetRoleModel(ref_tar, parent, data)
			}



		}



		this.GetNameVerifyIconOpenState = (base_type?, info?) => {
			let finished_func = (ret?) => {
				let is_got_reward = this.CheckIsGotNameVerReward()
				if (!is_got_reward) {
					this.AddNameVerifyIcon(base_type, info)
					if (!this.is_open_verify_view) {
						this.is_open_verify_view = true
						GlobalEventSystem.Fire(EventName.OPEN_ACT_VIEW, "331@69@0")
					}
				} else {
					this.DeleteSpecialIcon(base_type, info)
				}
			}

			let unfinished_fun = (type?) => {
				if (type == 1) {
					this.AddNameVerifyIcon(base_type, info)
					if (!this.is_open_verify_view) {
						this.is_open_verify_view = true
						GlobalEventSystem.Fire(EventName.OPEN_ACT_VIEW, "331@69@0")
					}
				}
			}

			platform_mgr.CheckSHNameVerify(finished_func, unfinished_fun)
		}




		this.AddNameVerifyIcon = (base_type?, info?) => {
			if (ClientNameVerifyConfig_) {
				let plat_name = LoginModel.GetInstance().plat_name//"PlatTest"//
				let plat_cfg = ClientNameVerifyConfig_[plat_name] || ClientNameVerifyConfig_["default"]
				if (plat_cfg) {
					let list = []
					let open_day = sever_time_model.GetOpenServerDay()
					let lv = role_mgr.mainRoleInfo.level
					if ((open_day >= plat_cfg.open_day && (open_day <= plat_cfg.max_open_day || plat_cfg.max_open_day == 0)) && lv >= plat_cfg.lv) {
						let icon_type = local_CustomActivityDefine.ICON_KEY + "@" + info.base_type + "@" + info.show_id
						let icon_info = common_mgr.GetFunctionIconCfg(icon_type)
						if (icon_info) {
							list[icon_type] = { base_type: info.base_type, show_id: info.show_id, end_time: info.etime, icon_info_data: icon_info }
							this.AddActivityIcons(list)
						}
					} else {
						this.DeleteSpecialIcon(base_type, info)
					}
				} else {
					this.DeleteSpecialIcon(base_type, info)
				}
			}
		}


		this.DeleteSpecialIcon = (base_type?, info?) => {
			if (info) {
				let icon_type = local_CustomActivityDefine.ICON_KEY + "@" + info.base_type + "@" + info.show_id
				if (icon_type) {

					if (icon_type == preload_client_config.ConfigCustomActivity.ACT_ID.NAMEVERIFY) {
						if (!this.CheckIsGotNameVerReward()) {
							//实名验证奖励未领取，不删除图标
							return
						}
					}

					let icon_info = common_mgr.GetFunctionIconCfg(icon_type)
					if (icon_info) {
						let icons = {}
						icons[icon_info.icon_type] = true
						this.DeleteActivityIcons(icons)
					}
				}
			}
		}

		this.RefreshVerifyIcon = () => {
			this.RefreshSpecialIcon(preload_client_config.ConfigCustomActivity.ACT_ID.NAMEVERIFY, verify_sub_type)
		}

		//刷新特殊的图标功能
		this.RefreshSpecialIcon = (base_type?, sub_type?) => {
			let act_data = this.GetActData(base_type, sub_type)
			let info = this.GetActInfo(base_type, sub_type)
			if (act_data && info) {
				switch (base_type) {
					case preload_client_config.ConfigCustomActivity.ACT_ID.NAMEVERIFY: //实名验证
						if (!platform_mgr.is_alpha) {
							let is_got_reward = this.CheckIsGotNameVerReward()
							if (!is_got_reward) {
								verify_sub_type = sub_type
								if (!ClientNameVerifyConfig_) {
									//防止配置文件没加载到 图标没刷新
									is_fresh_verify = true
								} else {
									this.GetNameVerifyIconOpenState(base_type, info)
								}
							} else {
								this.DeleteSpecialIcon(base_type, info)
							}
						}
						break
					case preload_client_config.ConfigCustomActivity.ACT_ID.WXONEMONEY: //一元礼包
						if (info && act_data && act_data.reward_list && act_data.reward_list[0] && act_data.reward_list[0].reward) {
							let reward_data = act_data.reward_list[0]
							if (!reward_data || reward_data.status == 2) {
								this.DeleteSpecialIcon(base_type, info)
							}
						}
						break
					case preload_client_config.ConfigCustomActivity.ACT_ID.WISH_POOL: //幸运占卜（许愿池
						// this.Fire(custom_even.SCMD_REQUEST, 33141, base_type, sub_type)
						break
					case preload_client_config.ConfigCustomActivity.ACT_ID.FTVACTIVENESS: //周中捐獻
						this.Fire(custom_even.SCMD_REQUEST, 33193, base_type, sub_type)
						break
					case preload_client_config.ConfigCustomActivity.ACT_ID.QUESTIONNAIRE_ACT_BASE_TYPE:
						QuestionNaireModel.GetInstance().SetIcon(act_data)
						break
				}
			}
		}

		///**
		//* 鲜花榜
		//*/
		this.GetFlowerRankOpenStatus = () => {
			let base_type = preload_client_config.ConfigCustomActivity.ACT_ID.FLOWERRANK
			let sub_type
			let bool
			if (!this.act_key_dic || !this.act_key_dic[base_type]) { return false }
			for (let key in this.act_key_dic[base_type]) {
				sub_type = key
				bool = this.act_key_dic[base_type][key]
			}
			let [icon_type] = this.GetActIconType(base_type, sub_type)
			return bool && icon_type
		}

		//审核服状态需要屏蔽
		this.ActivityNeedHideInAlpha = (base_type?) => {
			let need_hide = false
			if (platform_mgr.is_alpha || platform_mgr.need_alpha_open_charge) {
				if (local_CustomActivityDefine.NeedHideInAlpha[local_Number(base_type)]) {
					need_hide = true
				}
			}
			return need_hide
		}

		///*
		//* 活动键值
		//*/
		this.getKeyDicValue = (base_type?, sub_type?, key?) => {
			let b = base_type
			let s = sub_type
			let dic = this.act_key_dic
			dic[b] = dic[b] || {}
			dic[b][s] = dic[b][s] || {}
			return dic[b][s][key]
		}

		this.setKeyDicValue = (base_type?, sub_type?, key?, value?) => {
			let b = base_type
			let s = sub_type
			let dic = this.act_key_dic
			dic[b] = dic[b] || {}
			dic[b][s] = dic[b][s] || {}
			dic[b][s][key] = value
		}
		///*
		//* 活动键值
		//*/

		///**活动规则说明 */
		this.getActInstructionId = (base_type?, show_id?) => {
			let instruction_dic = preload_client_config.ConfigCustomActivity.Instruction
			let instruction_plat = preload_client_config.ConfigCustomActivity.Instruction_plat
			if (!instruction_dic || !instruction_plat) {
				return 0
			}
			let key = `${base_type}@${show_id}`
			let instruction_id = 0
			let is_plat = 0
			if (instruction_dic[key] != undefined) {
				instruction_id = instruction_dic[key]
			} else if (instruction_plat[key] != undefined) {
				instruction_id = instruction_plat[key]
				is_plat = 1
			} else if (instruction_dic[base_type]) {
				instruction_id = instruction_dic[base_type]
				key = base_type
			} else if (instruction_plat[base_type]) {
				instruction_id = instruction_plat[base_type]
				key = base_type
				is_plat = 1
			}
			if (is_plat && is_plat != 0) {
				let open_state = common_mgr.GetInstructionState(key)
				instruction_id = open_state ? instruction_id : 0
			}
			return instruction_id
		}

		///**平台封测 UI更换*/
		this.isCBPlatform = () => {
			//let plat_name = local_PlatformManager.GetPlatformName()
			//let CB_Platform_name = preload_client_config.ConfigCustomActivity.CB_Platform_name
			let bool = false
			//if (CB_Platform_name && CB_Platform_name[plat_name] ) {
			//bool = true
			//}
			return bool
		}

		///**定制活动通用跳转 */
		this.JumpAct = (base_type?, show_id?) => {
			let sub_type
			let act_info
			if (show_id != null) {
				act_info = this.GetActInfoByShowID(base_type, show_id)
			} else {
				act_info = this.GetActInfoByType(base_type)
			}
			if (!act_info) {
				local_Message.show("活动未开启")
				return
			}
			if (act_info) {
				show_id = act_info.show_id
				sub_type = act_info.sub_type
				let [icon_type] = this.GetActIconType(base_type, sub_type)
				if (icon_type) {
					local_GlobalEventSystem.Fire(local_EventName.OPEN_ACT_VIEW, icon_type, base_type, show_id)
				}
			}
		}

		///**活动界面控件：资源加载/位置调整
		//* component_name为空则加载is_use_loaded不为true的控件资源，不为空，则加载改控件资源
		//*/
		this.LoadCompontRes = (thisObject?, cfg?, view_name?, show_id?, component_name?, base_type?) => {
			if (!thisObject || !cfg || !view_name || show_id == null) return

			//图片
			let setImg = (com_cfg?, com_name?) => {
				if (com_cfg.res == "") {
					return
				}
				let subtype = com_cfg.res_subtype
				if (subtype == "1") {
					ResManager.GetInstance().SetTexture(thisObject, thisObject[com_name], `resource/game/${com_cfg.res}`, null, thisObject, true)
				} else if (subtype == "2") {
					let temp = Split(com_cfg.res, ".")
					temp[0] = temp[0].replace("_json", "")
					temp[1] = temp[1].replace("_png", "")
					thisObject[com_name].skin = GameResPath.GetIcon(temp[0], temp[1]) //com_cfg.res
				}

				if (com_cfg.x != undefined) {
					thisObject[com_name].x = com_cfg.x
				}
				if (com_cfg.y != undefined) {
					thisObject[com_name].y = com_cfg.y
				}
				if (com_cfg.scale != undefined) {
					thisObject[com_name].scaleX = thisObject[com_name].scaleY = com_cfg.scale
				}
			}

			//特效
			let setEffect = (com_cfg?, com_name?) => {
				// if (com_cfg.res == "") return
				// thisObject.AddUIEffect(com_cfg.res, thisObject[com_name], undefined, undefined, true)
			}

			//位置
			let setPos = (com_cfg?, com_name?) => {

				//看上去没有用
				// if (!com_cfg.offset) {
				// 	return
				// }

				if (com_cfg.x != undefined) {
					thisObject[com_name].x = com_cfg.x
				}
				if (com_cfg.y != undefined) {
					thisObject[com_name].y = com_cfg.y
				}
			}

			let view_cfg = cfg[view_name]
			if (!view_cfg) { return }
			let show_cfg = view_cfg[Number(show_id)]
			if (!show_cfg) {
				show_cfg = view_cfg["default"]
			}
			if (!show_cfg) { return }

			if (component_name) {
				let com_cfg = show_cfg[component_name]
				if (com_cfg.res_type == "1") {
					setImg(com_cfg, component_name)
				} else if (com_cfg.res_type == "2") {
					setEffect(com_cfg, component_name)
				}
			} else {
				for (let key in show_cfg) {
					let com_cfg = show_cfg[key]
					if (!com_cfg.is_use_loaded) {
						if (com_cfg.res_type == "1") {
							setImg(com_cfg, key)
						} else if (com_cfg.res_type == "2") {
							setEffect(com_cfg, key)
						} else if (com_cfg.res_type == "3") {
							setPos(com_cfg, key)
						}
					}
				}
			}
		}

		this.GetCompontRES = (cfg?, view_name?, show_id?, component_name?) => {
			if (!cfg || !view_name || show_id == null) {
				return null
			}

			let view_cfg = cfg[view_name]
			if (!view_cfg) {
				return null
			}

			let show_cfg = view_cfg[show_id]
			if (!show_cfg) {
				show_cfg = view_cfg["default"]
			}
			if (!show_cfg) {
				return null
			}
			for (let key in show_cfg) {
				if (key == component_name) {
					return show_cfg[key]
				}
			}
			return null
		}
		/**
		 * @param endTimeCb 倒计时结束回调
		 */
		this.LoadActTimer = (parent?, etime?, size?, color?, style?, title_color?, desc?, center?, needStoke?, need_bk?, endTimeCb?: Function, end_desc?) => {
			let list = parent.$children
			if (list && list.length > 0) {
				for (let v of list) {
					if (v.__proto__ && v.__proto__.__class__ == "ComActTimerView") {
						v.RefData(etime, size, color, style, title_color, desc, center, needStoke, need_bk, endTimeCb, end_desc)
						return
					}
				}
			}
			let item = new ComActTimerView(parent)
			item.RefData(etime, size, color, style, title_color, desc, center, needStoke, need_bk, endTimeCb, end_desc)
			item.Load()
			return item
		}

		this.LoadActRecord = (parent?, base_type?, sub_type?, item_type?, hide_prefix?, mod_id?, color?) => {
			let list = parent.$children
			if (list && list.length > 0) {
				for (let v of list) {
					if (v.__proto__ && v.__proto__.__class__ == "ComActRecordView") {
						return
					}
				}
			}
			let item = new ComActRecordView(parent)
			item.Load()
			item.ExcuteCallback(() => {
				item.SetData(base_type, sub_type, item_type, hide_prefix, mod_id, color)
			})
			return item
		}

		this.LoadActBtn = (parent, btn, data, cost, btn_dic, draw_num, bg_source?, bg_url?, full_mat_red = true, is_auto_buy = true,
			click_func?, btn_type = Enum_Btn_Type.ONE, currency_type = Enum_Currency_Type.Special, loaded_func?, cost2?) => {
			if (!btn) {
				btn = new ComActBtn(parent)
				btn.Load()
			}
			btn.ExcuteCallback(() => {
				btn.SetData(data, cost, btn_dic, draw_num, bg_source, bg_url, full_mat_red, is_auto_buy, click_func, btn_type, currency_type, loaded_func, cost2)
				if (loaded_func) {
					loaded_func(btn)
				}
			}
			)
			return btn
		}

		this.DeleteActTimer = (parent_wnd?) => {
			this.act_timer_list[parent_wnd] = {}
		}

		//新扭蛋
		this.StopGashaponSendOp = () => {
			gashapon_force_stop = true
		}

		this.ResetGashaponSendOp = () => {
			gashapon_force_stop = false
		}

		this.ClearGashaponRewardList = () => {
			this.merge_gashapon_list = []
			receive_gashapon_num = 0
			this.play_gashapon_auto_anim_end = false
			this.need_show_reward = false
		}

		this.ShowGashaponRewardList = (base_type?, sub_type?) => {
			//let rewardsList = GoodsModel.RewardKeyToNumber(this.merge_gashapon_list)
			this.send_proto = false
			let cov = new CongratulationObtainView(this.merge_gashapon_list)
			cov.SetSpecType()
			cov.Open()

			this.ClearGashaponRewardList()
			//this:Fire(custom_even.SCMD_REQUEST, 33245, base_type, sub_type)
		}

		this.PlayGashaponAutoAnimEnd = () => {
			this.play_gashapon_auto_anim_end = true
			// 抽奖完毕，直接播放奖励
			if (this.need_show_reward) {
				this.ShowGashaponRewardList()
			}
		}

		this.ReceiveGashaponRewardList = (list?, base_type?, sub_type?) => {
			receive_gashapon_num = receive_gashapon_num + 1
			this.merge_gashapon_list = this.merge_gashapon_list || []
			if (list) {
				this.merge_gashapon_list = this.merge_gashapon_list.concat(list)
			}
			let is_nice = false
			if (list) {
				for (let _ in list) {
					let reward = list[_]
					if (reward.is_nice == 1) {
						is_nice = true
						reward[3] = 1
						break
					}
				}
			}

			if (receive_gashapon_num >= gashapon_max_num || gashapon_force_stop || is_nice) {
				if (this.getKeyDicValue(base_type, sub_type, "need_pass_anim")) {
					this.ShowGashaponRewardList(base_type, sub_type)
				} else {
					if (this.play_gashapon_auto_anim_end) {
						this.ShowGashaponRewardList(base_type, sub_type)
					} else {
						this.need_show_reward = true
					}
				}
			} else {
				this.Fire(custom_even.SEND_GASHAPON_OP, base_type, sub_type)
			}
		}
		//新扭蛋

		this.SetRPRCurData = (scmd?) => {
			rpr_data_ = scmd
		}

		this.GetPRPCurData = () => {
			return rpr_data_
		}

		this.UpdateQuestionIcon = () => {
			let question_model = QuestionNaireModel.GetInstance()
			let info = this.GetActInfo(QuestionNaireModel.QUESTIONNAIRE_ACT_BASE_TYPE, question_model.questionnaire_type)
			let data = this.GetActData(QuestionNaireModel.QUESTIONNAIRE_ACT_BASE_TYPE, question_model.questionnaire_type)
			question_model.SetLevel(info, false)
			question_model.SetIcon(data)
		}
		this.IsRareReward = (reward_?) => {
			let act_data = this.GetActData(102, this.lucky_sub_type)
			if (!act_data) { return false }
			let reward_list = act_data.reward_list
			for (let _ in reward_list) {
				let v = reward_list[_]
				let reward = ErlangParser.GetInstance().Parse(v.reward)
				let condition = ErlangParser.GetInstance().Parse(v.condition)
				if (condition[1] && condition[1][0] == "rare" && condition[1][1] == "1" && Number(reward[0][1]) == reward_[0].typeId) {
					return true
				}
			}
			return false
		}

		//奖励弹窗活动
		this.RefreshLevelWindowRewardState = (base_type?, sub_type?) => {
			if (base_type && base_type == preload_client_config.ConfigCustomActivity.ACT_ID.LEVEL_WINDOW_REWARD) {	//等级弹窗奖励（外文服使用）
				let act_info = this.GetActInfoByType(base_type)
				let player_lv = role_mgr.mainRoleInfo.level
				if (act_info) {
					let cond = erlang_parser.Parse(act_info.condition)
					if (cond) {
						let sort_fun = (a?, b?) => {
							return Number(a[1]) < Number(b[1])
						}
						table.sort(cond, sort_fun)
						let act_reward_data = this.GetActData(base_type, act_info.sub_type)
						if (act_reward_data && act_reward_data.reward_list) {
							let find = false
							for (let v of cond) {
								for (let vo of act_reward_data.reward_list) {
									if (Number(v[2]) == vo.grade) {
										if (vo.receive_times == 0) {
											if (player_lv >= Number(v[0])) {
												find = true
												GlobalEventSystem.Fire(EventName.OPEN_VIEW, "LevelWindowRewardView", act_info, vo)
												break
											}
										}
									}
								}
								if (find) {
									break
								}
							}
						}
					}
				}
			}
		}

		//是否领取了实名奖励  实名奖励只能领取一次
		this.CheckIsGotNameVerReward = () => {
			let is_got_reward = false
			let base_type = 69
			let sub_type = 1
			let act_info = CustomActivityModel.GetInstance().GetActData(base_type, sub_type)
			if (act_info && act_info.reward_list && act_info.reward_list[0] && act_info.reward_list[0].reward) {
				let reward_data = act_info.reward_list[0]
				if (reward_data && reward_data.status == 2) {
					is_got_reward = true
				}
			}
			return is_got_reward
		}
		this.SetActRechargeGone = (list?) => {
			this.recharge_gone = list
		}
		this.GetActRechargeOneDay = (num?) => {
			return this.recharge_gone
		}

		this.SetCarnivalProgress = (list?) => {
			this.carnival_progress_list = list
		}

		this.GetCarnivalProgerss = () => {
			return this.carnival_progress_list
		}



		//首日福利
		this.OnUpdateActTime = (base_type?, sub_type?) => {
			if (!this._act_time_list) {
				this._act_time_list = {}
			}

			//model定时
			let time_func = () => {
				let view_cfg = Config.PRELOAD_CLIENT_CONFIG.ConfigCustomActivity.windowscomponent["331@3_1"]["122@0"]
				let role_level = RoleManager.GetInstance().mainRoleInfo.level
				if (view_cfg && role_level >= view_cfg["open_lv"]) {
					this.Fire(CustomActivityDefine.EVENT.SCMD_REQUEST, 33104, base_type, sub_type)
				}
			}

			//倒计时
			let key = base_type + "@" + sub_type
			if (!this._act_time_list[key]) {
				this._act_time_list[key] = GlobalTimerQuest.AddPeriodQuest(() => {
					time_func()
				}, 4, -1) //N秒刷新一次
				time_func()
			}
		}


		this.OnClearActTime = (base_type?, sub_type?) => {
			if (!this._act_time_list) {
				this._act_time_list = {}
			}
			if (base_type != 0) {
				let key = base_type + "@" + sub_type
				if (this._act_time_list[key]) {
					GlobalTimerQuest.CancelQuest(this._act_time_list[key])
					delete this._act_time_list[key]
				}
			} else {
				//==0清理全部的计时器
				for (let key in this._act_time_list) {
					GlobalTimerQuest.CancelQuest(this._act_time_list[key])
					delete this._act_time_list[key]
				}
				this._act_time_list = {}
			}

		}


		//是否领取的首日礼包的奖励(判断是否倒计时用)
		this.IsNeedCountTime = (base_type?, sub_type?) => {
			let cur_data = this.GetActData(base_type, sub_type)
			let act_data = cur_data && cur_data.reward_list[0] || null
			if (!act_data) return
			//可领取时间
			let end_time = Number(ErlangParser.GetInstance().parse(act_data.condition)[0][1])
			//是否已经领取
			let is_got = act_data.status == 2 //==2表示已经领取

			//处于奖励可领取倒计时期间  并且 还没有领取经理
			let boo = TimeUtil.getServerTime() < end_time && !is_got
			return boo
		}


		//充值豪礼
		this.GetRechargeList = (product_id) => {
			//定制活动
			let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "ClientRechargeShow", true)
			let list = []
			for (let key in cfg) {
				let main_vo = cfg[key]
				if (main_vo) {
					for (let key_2 in main_vo) {
						let sub_vo = main_vo[key_2]
						let base_type = Number(key)
						let show_id = Number(key_2)

						//提取活动信息
						let show_id_info = this.GetActInfoByShowID(base_type, show_id)
						if (!show_id_info) continue
						let act_data

						//存放奖励
						let reward_list = []
						act_data = this.GetActData(show_id_info.base_type, show_id_info.sub_type)
						if (!act_data) continue

						//判断活动是否开启
						if (base_type == 121) {
							let cfg = common_mgr.GetFunctionIconCfg("331@121")
							if (cfg) {
								let lv_role = role_mgr.mainRoleInfo.level
								if (lv_role < cfg.open_lv) {
									continue
								}
							}
						} else if (base_type == 109) {
							let lv_role = role_mgr.mainRoleInfo.level
							if (lv_role < 120) {
								continue
							}
						} else {
							let [icon_type] = this.GetActIconType(base_type, act_data.sub_type)

							if (icon_type == "331@110") {
								//循环冲榜活动判断是否开启
								if (!CycleimpActlistModel.GetInstance().CheckActOpen()) {
									continue
								}

							} else {
								//一般的活动
								if (!this.GetOpenState(icon_type, false)) {
									continue
								}
							}
						}


						//处理数据
						if (act_data) {
							switch (base_type) {
								case 6:
									//首日累充
									reward_list = act_data.reward_infos
									break;
								case 109:
									reward_list = this.GetConRecharge(act_data)
									break
								case 121:
									reward_list = this.TiredChargeData(act_data)
									break;
								default:
									reward_list = act_data.reward_list
									break;
							}
						}

						let reward_list_copy = Util.DeepCopy(reward_list)
						table.sort(reward_list_copy,(a,b)=>{
							return a.grade<b.grade
						})

						//处理数据
						//活动开启才展示
						for (let _tmpi in reward_list_copy) {
							let data = reward_list_copy[_tmpi]
							let grade = String(data.grade)
							if (sub_vo && sub_vo[grade]) {
								let rewards = []
								let s_vo = sub_vo[grade]


								//限制  在对应的充值档位显示
								let is_show = false
								if (s_vo && s_vo["product_ids"] && s_vo["product_ids"].length > 0) {
									is_show = s_vo["product_ids"].indexOf(product_id) != -1
								}
								if (!is_show) continue

								switch (base_type) {
									case 6:
										//首日累充
										if (data.state != 2) {
											rewards = this.TransReward2(data.reward_list)
										}
										break;
									case 109:
										//领取后会消失
										if (data.status != 2) {
											let form_type = data.form_type ? data.form_type : 1
											let rewards1 = this.GetActReward(act_data.base_type, act_data.sub_type, form_type, data.reward)
											rewards = this.TransReward(rewards1)
										}
										break;
									case 64:
									case 121:
										//充值后会消失
										if (data.status < 1) {
											let form_type = data.form_type ? data.form_type : 1
											let rewards1 = this.GetActReward(act_data.base_type, act_data.sub_type, form_type, data.reward)
											rewards = this.TransReward(rewards1)
										}
										break;
									default:
										if (data.status != 2) {
											let form_type = data.form_type ? data.form_type : 1
											let rewards1 = this.GetActReward(act_data.base_type, act_data.sub_type, form_type, data.reward)
											rewards = this.TransReward(rewards1)
										}
										break;
								}

								if (rewards.length > 0) {
									let item_data = {
										item_name: s_vo.name,
										reward_list: rewards,
										desc: s_vo.desc,
										base_type: base_type,
										show_id: show_id
									}
									table.insert(list, item_data)
								}

							}
						}
					}
				}

			}


			//首充模块  特殊处理
			let f_rewards = this.GetFristRecharge()
			if (f_rewards[0]) {
				table.insert(list, f_rewards[1])
			}


			return list
		}





		/**开服连充活动 */
		this.GetConRecharge = (act_data) => {
			if (!act_data) return []

			//数据
			let list = act_data.reward_list


			//开服连充活动 连充天数
			let new_list = []
			let con_days = this.GetConDays(act_data)
			con_days = con_days == 0 ? 1 : con_days
			for (let _ = 0; _ < list.length; _++) {
				var v = list[_]
				let cond = CustomActivityModel.GetInstance().GetActCondition(act_data.base_type, act_data.sub_type, "data", v.grade)
				if (cond && cond.day == con_days) {
					table.insert(new_list, v)
				}
			}


			//排序
			table.sort(new_list, (a?, b?) => {
				let cond_a = CustomActivityModel.GetInstance().GetActCondition(act_data.base_type, act_data.sub_type, "data", a.grade)
				let cond_b = CustomActivityModel.GetInstance().GetActCondition(act_data.base_type, act_data.sub_type, "data", b.grade)
				let grade1 = cond_a.grade && 1 || 0
				let grade2 = cond_b.grade && 1 || 0

				if (grade1 != grade2) {
					return grade1 > grade2
				} else {
					if (a.status != b.status) {
						if (a.status == 1) {
							return true
						} else if (b.status == 1) {
							return false
						} else {
							return a.status < b.status
						}
					} else {
						return a.grade < b.grade
					}
				}
			})

			return new_list
		}

		/**首充模块*/
		this.GetFristRecharge = () => {
			let cfg_ = Config.PRELOAD_SERVER_CONFIG.config_recharge_first
			let model = FirstRechargeModel.GetInstance()
			let data = model.first_recharge_info
			if (!data) {
				return [false]
			}
			let sex = RoleManager.GetInstance().mainRoleInfo.sex
			let career = RoleManager.GetInstance().mainRoleInfo.career
			let reward_list = []
			for (let _tmpi in data.reward_list) {
				var vo = data.reward_list[_tmpi]
				if (vo && vo.open == 0) {
					if (!cfg_) {
						return [false]
					}
					let str = data.product_id + "@" + sex + "@" + vo.index
					let cfg_data = cfg_[str]
					if (!cfg_data) {
						return [false]
					}
					let career_reward = JSON.parse(cfg_data.reward)
					let reward = []
					for (let _i = 0; _i < career_reward.length; _i++) {
						var _v = career_reward[_i]
						if (career == Number(_v[0])) {
							reward = _v[1]
							for (let i = 0; i < reward.length; i++) {
								table.insert(reward_list, {
									size: 87,
									vo: {
										style: reward[i][0],
										typeId: reward[i][1],
										count: reward[i][2]
									}
								})
							}
						}
					}
				}
			}

			if (reward_list.length > 0) {
				let cfg = Config.PRELOAD_CLIENT_CONFIG.ClientRechargeShow
				let item_data = {
					item_name: cfg["first_recharge"]["name"],
					reward_list: reward_list,
					desc: cfg["first_recharge"]["desc"],
					base_type: 0,
					show_id: cfg["first_recharge"]["open_id"]
				}
				return [true, item_data]
			}

			return [false]

		}


		/**开服连充天数 */
		this.GetConDays = (act_data) => {
			if (!act_data) return 0
			//连充天数
			let list = act_data.reward_list
			let count = 0
			for (let i = 0; i < list.length; i++) {
				let v = list[i]
				let condi = CustomActivityModel.GetInstance().GetActCondition(act_data.base_type, act_data.sub_type, "data", v.grade)
				if (condi.tier == 1 && condi.grade == 1) {
					if (v.status == 1 || v.status == 2) {
						count++
					}
				}
				else if ((condi.tier == 1) || !condi.tier) {
					if (v.status == 1 || v.status == 2) {
						count++
					}
				}
			}
			return count
		}

		/**开服连充活动 */
		this.GetConRecharge = (act_data) => {
			if (!act_data) return []

			//数据
			let list = act_data.reward_list


			//开服连充活动 连充天数
			let new_list = []
			let con_days = this.GetConDays(act_data)
			con_days = con_days == 0 ? 1 : con_days
			for (let _ = 0; _ < list.length; _++) {
				var v = list[_]
				let cond = CustomActivityModel.GetInstance().GetActCondition(act_data.base_type, act_data.sub_type, "data", v.grade)
				if (cond && cond.day == con_days) {
					table.insert(new_list, v)
				}
			}


			//排序
			table.sort(new_list, (a?, b?) => {
				let cond_a = CustomActivityModel.GetInstance().GetActCondition(act_data.base_type, act_data.sub_type, "data", a.grade)
				let cond_b = CustomActivityModel.GetInstance().GetActCondition(act_data.base_type, act_data.sub_type, "data", b.grade)
				let grade1 = cond_a.grade && 1 || 0
				let grade2 = cond_b.grade && 1 || 0

				if (grade1 != grade2) {
					return grade1 > grade2
				} else {
					if (a.status != b.status) {
						if (a.status == 1) {
							return true
						} else if (b.status == 1) {
							return false
						} else {
							return a.status < b.status
						}
					} else {
						return a.grade < b.grade
					}
				}
			})
			return new_list
		}


		/***累充好礼 */
		this.TiredChargeData = (act_data) => {
			if (!act_data) return []
			let new_list = []
			let task_list = act_data.list
			let strs = []
			for (let i = 0; i < task_list.length; i++) {
				let data = task_list[i]
				//判断档位是否满足条件
				if (TiredChargePoliteModel.GetInstance().GetGearStateByGrade(data.grade) != TiredChargePoliteTaskState.eGet) continue

				for (const item_data of data.reward_list) {
					if (item_data.form_type != 2 || item_data.status >= 1) continue  //只展示类型2的珍稀奖励
					if (item_data && item_data.reward) {
						let str1 = item_data.reward.substr(1, item_data.reward.length - 2)
						table.insert(strs, str1)
					}
				}

			}

			if (strs.length > 0) {
				let data = {}
				data["form_type"] = 1
				data["reward"] = "[" + strs.join(",") + "]"
				data["status"] = 0
				data["grade"] = 1
				table.insert(new_list, data)
			}
			return new_list
		}


		//转下数据
		this.TransReward = (list) => {
			let new_list = []
			for (let i = 0; i < list.length; i++) {
				table.insert(new_list, {
					size: 87,
					vo: {
						style: list[i][0],
						typeId: list[i][1],
						count: list[i][2]
					}
				})
			}
			return new_list
		}



		//转下数据2
		this.TransReward2 = (list) => {

			// {
			// 	count: 1
			// 	style: 0
			// 	typeId: 38160001
			// }
			let new_list = []
			for (let i = 0; i < list.length; i++) {
				table.insert(new_list, {
					size: 87,
					vo: {
						style: list[i]["style"],
						typeId: list[i]["typeId"],
						count: list[i]["count"]
					}
				})
			}
			return new_list
		}

		//获得可以飘字的物品id列表
		this.GetFlyRewardList = (list, type = 0) => {
			let new_list = []
			//let show_style_ids = { 31: 1, 34: 1, 35: 1 } //铜币 绑勾 勾玉 测试用
			let show_style_ids = { 1: 1, 2: 1, 3: 1 } // 勾玉 绑勾 铜币

			switch (type) {
				case 0:
					for (let i = 0; i < list.length; i++) {
						if (!show_style_ids[list[i][0]]) continue
						table.insert(new_list, {
							0: list[i][0],
							1: list[i][1],
							2: list[i][2]
						})
					}
					break;
				case 1:
					//*****这个类型style类型为0，所以不展示特效飘字

					// for (let i = 0; i < list.length; i++) {
					// 	let [type_id_, lock_] = GoodsModel.GetInstance().GetMappingTypeId(0, list[i].type_id)
					// 	if (!show_type_ids[type_id_]) continue
					// 	table.insert(new_list, {
					// 		0: 0,
					// 		1: list[i].type_id,
					// 		2: list[i].good_num
					// 	})
					// }
					break;
				case 2:
					for (let i = 0; i < list.length; i++) {
						if (!show_style_ids[list[i].style]) continue
						table.insert(new_list, {
							0: list[i].style,
							1: list[i].typeId,
							2: list[i].count
						})
					}
					break;
				case 3:
					for (let i = 0; i < list.length; i++) {
						if (list[i].status != 1) continue
						let vo_temp = list[i].reward
						if (!show_style_ids[vo_temp[0]]) continue
						table.insert(new_list, {
							0: vo_temp[0],
							1: vo_temp[1],
							2: vo_temp[2]
						})
					}
					break;
			}

			return new_list
		}

		/**活动飘字特效 */
		this.ShowActFlyReward = (fly_list, btn_get: Laya.UIComponent) => {
			Laya.timer.frameOnce(10, this, () => {
				if (fly_list && fly_list.length > 0) {
					let pos = btn_get.localToGlobal(new Laya.Point(btn_get.width / 2, btn_get.height / 2))
					GlobalEventSystem.Fire(EventName.REWARD_FLY, fly_list, pos)
				}
			}, null, true)

		}



		/**获取最大充值档位 */
		this.GetMaxProductId = () => {
			let rscfg = ResManager.GetInstance().GetGameConfigFromCache(this, "ClientRechargeShow", true)
			if (rscfg && rscfg["recharge_icon"] && rscfg["recharge_icon"]["product_ids"]) {
				let recharge_list = rscfg["recharge_icon"]["product_ids"]
				if (recharge_list.length > 0) {
					return recharge_list[recharge_list.length - 1]
				}
			}
			return 0
		}

		this.GetSuperGiftBuyState = ()=>{
			return this.state
		}

		this.SetOnlineDrawData = (scmd)=>{
			online_draw_fight_list[scmd.subtype] = scmd.power
			this.Fire(CustomActivityDefine.EVENT.UPDATE_FIGHTING_VALUE, online_draw_fight_list)
		}

		this.ResetData()
	}



	public clearSpecialRedDotMap() {
		this.specialRedDotMap.clear();
	}


	public TopPlayerGetWayInfo(scmd) {
		this.topplayer_get_way_list[scmd.rush_id] = scmd.res
	}
	public GetTopPlayerGetWay(rush_id) {
		return this.topplayer_get_way_list[rush_id]
	}

	public CheckOpenDesTinyView() {
		let data = this.GetActData(99, 1)
		let a = data.reward_list.filter(item => item.grade != 0);
		let today_index = data.label
		let index = today_index == 0 ? today_index : today_index - 1
		let today_info = a[today_index - 1]

		if (today_info && today_info.condition) {

		}
		else {
			let data = this.destiny_info
			data.show_index = today_index
			this.destiny_info = data
			return
		}
		let c = today_info.condition
		let condition = ErlangParser.GetInstance().parse(c)
		let reward = ErlangParser.GetInstance().parse(today_info.reward)
		let inevitable = undefined

		for (let key in condition) {
			let vo = condition[key]
			if (vo[0] == "inevitable") {
				inevitable = vo[1]
				break
			}
		}
		let target = inevitable[data.turn - 1][1]
		this.destiny_info = { "show_index": today_index, "goods_vo": reward, "need_count": data.need_point - data.point, "target": target }
		let can_show = Number(target) >= (data.need_point - data.point) && this.destiny_turn_num != data.turn
		if (ResManager.GetInstance().true_game_start && this.last_destiny_count != data.point) {
			if (can_show) {
				GlobalEventSystem.Fire(EventName.OPEN_VIEW, "DestinyTurnTableActiveView")
				this.destiny_turn_num = data.turn
			}
			//else
			//GlobalEventSystem.Fire(EventName.CLOSE_VIEW, "DestinyTurnTableActiveView")
		}


		this.last_destiny_count = data.point
		return can_show
	}
	public GetDesTinyInfo() {
		return this.destiny_info
	}
	public SetDesTinyGetWay(list) {
		this.destiny_getway = list
	}
	public GetDesTinyGetWay() {
		return this.destiny_getway
	}
	public SetDesTinyDouble(list) {
		this.destiny_double_list = list
	}
	public SetDesTinyEndTime(time) {
		this.destiny_double_time = time
	}
	public GetDesTinyEndTime() {
		return this.destiny_double_time
	}
	public IsDoubleAct(id) {
		let bool = false
		if (this.destiny_double_list && Util.TableSize(this.destiny_double_list) > 0) {
			for (let key in this.destiny_double_list) {
				let vo = this.destiny_double_list[key]
				if (Number(id) == Number(vo.jump_id)) {
					bool = true
					break
				}
			}
		}

		return bool
	}
	public GetTopPlayerTip(scmd) {
		let des
		let type = scmd.type
		let rank_id = scmd.rush_rank_id
		let rank = scmd.rank
		let des1, des2, value
		des1 = rank_id == 4 ? "充值" : "提升"
		des2 = ""//rank_id == 4 ? "" : ""
		value = this.GetTopPlayerDes(scmd)
		switch (type) {
			case 0:
				des = "排名已被其他玩家超过"
				break;
			case 1:
				des = `再${des1}${value}${des2}可达到<font color='#d15e00'>${rank}</font>名`
				break;
			case 2:
				des = `恭喜您登临${this.GetTopPlayerName(rank_id)}榜首`
				break;
			case 3:
				des = `再${des1}${value}${des2}可领取冲榜奖励`
				break;
			case 4:
				des = `第2名${des1}${value}${des2}才追上`
				break;


		}
		return des
	}

	private GetTopPlayerDes(scmd) {
		let rank_id = scmd.rush_rank_id

		let value = scmd.value
		let sub_value = scmd.sub_value
		let des
		let type = scmd.type
		switch (rank_id) {
			case 1:
				des = `<font color='#d15e00'>${value}级</font>`
				break;
			case 2:
			case 3:
			case 14:
				// if (type == 3)
				// 	des = `<font color='#d15e00'>${value}阶${sub_value}星</font>`
				// else {
				var va = Mathf.Floor(value / 10000)
				if (va <= 0) va = 1
				des = `<font color='#d15e00'>${va}W</font>`
				// }
				break;
			case 4:
				des = `<font color='#d15e00'>${Number(value) / 10}元</font>`
				break;
			case 5:
			case 13:
				des = `<font color='#d15e00'>${value}级</font>`
				break;
			case 6:
				var va = Mathf.Floor(value / 10000)
				if (va <= 0) va = 1
				des = `<font color='#d15e00'>${va}W</font>`
				break;
		}
		return des
	}
	private GetTopPlayerName(rank_id) {
		let des
		switch (rank_id) {
			case 1:
				des = "等级榜"
				break;
			case 2:
				des = "坐骑榜"
				break;
			case 3:
				des = "侍魂榜"
				break;
			case 4:
				des = "充值榜"
				break;
			case 5:
				des = "宝石榜"
				break;
			case 6:
				des = "战力榜"
				break;
			case 13:
				des = "神纹榜"
				break;
		}
		return des
	}

	public GetActDis(dis) {
		let y = String(dis).indexOf(".") + 1
		let num = 0
		let num_point = 0
		dis = Number(dis)
		if (y > 0) {
			num = Math.floor(dis)
			num_point = Math.floor((dis - num) * 10)
		} else {
			num = Math.floor(dis)
		}
		return [num, num_point]
	}

	public GetDailyChargeConfig(view_name) {
		let cfg = Config.PRELOAD_CLIENT_CONFIG.ConfigDailyFirstRecharge
		return cfg[view_name]
	}

	public StartActivityTime(end_time?, is_reserve?){
		let cur_time = TimeUtil.getServerTime()
		let time = end_time - cur_time
		this.ClearActivityTime()
		// if(!this.group_buy_timer){
		let timer_func = ()=> {
			this.UpdateGroupBuyOpenState(end_time, is_reserve)
		}
		this.group_buy_timer = GlobalTimerQuest.AddDelayQuest(timer_func, time)
		timer_func()
		// }
		// this.UpdateGroupBuyOpenState(end_time, is_reserve)
	}

	public UpdateGroupBuyOpenState(end_time?, is_reserve?) {
		let cur_time = TimeUtil.getServerTime()
		//如果有预定商品，不用进到这里
		if(is_reserve){
			return
		}

		if(cur_time > end_time){  //当前时间大于预定结束的时间
			ActivityIconManager.GetInstance().deleteIcon("331@88@0")
			this.ClearActivityTime()
		}
	}

	public ClearActivityTime(){
		if (this.group_buy_timer) {
			GlobalTimerQuest.CancelQuest(this.group_buy_timer)
			this.group_buy_timer = null
		}
	}

	public CheckGroupBuyIsTimeOut(base_type?, sub_type?, only_need_time = false) {
		let data = this.GetActData(base_type, sub_type)
		if(!data){
			return false
		}
		let info = this.GetActInfo(base_type, sub_type)
		let vo_cond = this.GetActCondition(base_type, sub_type, "info")
		let buy_time = vo_cond.buy_day * 24 * 3600
		let stime = info.stime
		let buy_end_time = stime + buy_time //预购结束时间点
		let cur_time = TimeUtil.getServerTime()
		let bool = true
		//only_need_time： 是不是只取时间
		if(only_need_time){
			if(cur_time <= buy_end_time){
				return true		//处于团购预定阶段
			}else{	
				return false	//处于团购支付阶段
			}
		}else{
			let is_order = false
			if (cur_time > buy_end_time){
				for (let _tmpi in data.gp_goods){
					let vo = data.gp_goods[_tmpi]
					if(vo.first_buy_count){
						bool = true
						is_order = true
						break
					}
				}
				if(!is_order){
					bool = false
				}
			}
			this.StartActivityTime(buy_end_time, bool)
			return bool
		}
	}

	

	//广告cd数据
	public AdvertisingCdData(list?){
		this.advertising_cd_list = list
		this.Fire(CustomActivityDefine.EVENT.UPDATE_ADVERTISING_CD)
	}
	
	//获取cd时间
	public GetAdvertisingCdById( grade_id?){
		let cd_time = null
		if (this.advertising_cd_list ) {
			for (let i = 0; i < this.advertising_cd_list.length; i++) {
				var v = this.advertising_cd_list[i]
				if (v.grade_id == grade_id ) {
					cd_time = v.cd_time
					break
				}
			}
		}
		return cd_time
	}
	
	//广告是否处于cd时间
	public AdvertisingIsInCd(grade_id?){
		let is_in_cd = false
		if (this.advertising_cd_list ) { 
			let now_time = TimeUtil.getServerTime()
			for (let i = 0; i < this.advertising_cd_list.length; i++) {
				var v = this.advertising_cd_list[i]
				if (v.grade_id == grade_id ) { 
					if (now_time - v.cd_time < 0 ) { 
						is_in_cd = true
						break
					}
				}
			}	
		}
		return is_in_cd
	}
	
	//广告红点
	public AdvertisingRed( base_type?, sub_type?){
		let data = this.GetActData(base_type, sub_type)
		let info = this.GetActInfo(base_type, sub_type)
		let value = 0
		if (! data || ! info ) {
			return value
		}
		if (data.reward_list ) {
			for (let key in data.reward_list) {
					//是否有可领取的广告奖励
				let reaward = data.reward_list[key]
				if (reaward && reaward.status && reaward.status == 1 ) {
					value = value + 1
				}
			}
		}
		if (data.reward_list ) {
			for (let key in data.reward_list) {
						//是否有可看的广告
				let reaward = data.reward_list[key]
				if (reaward && reaward.status && reaward.status == 0 ) {
					if (! this.AdvertisingIsInCd(reaward.grade) ) { 
						value = value + 1
						break
					}
				}
			}
		}
		return value
	}
	
	//广告的奖励全部领取了
	public AdvertisingRewardGetAll( base_type?, sub_type?){
		let data = this.GetActData(base_type, sub_type)
		let info = this.GetActInfo(base_type, sub_type)
		if (! data || ! info ) {
			return false
		}
		let all_get = true
		if (data.reward_list ) {
			for (let key in data.reward_list) {
					//是否有可领取的广告奖励
				let reaward = data.reward_list[key]
				if (reaward && reaward.status && reaward.status != 2 && reaward.status != 3 ) {
					all_get = false
				}
			}
		}
		return all_get
	}
}
window["CustomActivityModel"] = CustomActivityModel
import { RoleManager } from "./RoleManager"
import { Config } from "../common/Config"
import { Scene } from "../scene/Scene"
import { SceneManager } from "../scene/SceneManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ActivityIconManager } from "../commonModel/ActivityIconManager"
import { TimeUtil } from "../util/TimeUtil"
import { EventName } from "../common/EventName"
import { EventDispatcher } from "../util/EventDispatcher"
import { MarriageModel } from "./MarriageModel"
import { BanquetAniManager } from "../marriage2/BanquetAniManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { Util } from "../util/Util"
import { ActivityIcon } from "../mainUI/ActivityIcon"
import { DialogueTypeConst } from "./DialogueModel"
import { ErlangParser } from "../util/ErlangParser"

export const BanqEvent = {
	APPLY_VIEW_DATA: "BE1",
	REQUET_PROTO: "BE2",
	APPLY_BANQUET: "BE3",
	// OPEN_VIEW: "OPEN_VIEW",
	UPDATE_GOODS_INFO: "BE5",
	REQUET_ASK: "BE6",
	INVITE_GUEST: "BE7",
	INVITE_DATA: "BE8",
	ASK_DATA: "BE9",
	INVITE_VIEW_DATA: "BE10",
	BUY_MAX: "BE11",
	BANQUET_CALL: "BE12",
	BANQUET_INFO: "BE13",
	CLOSE_VIEW: "BE14",
	EXP: "BE15",
	AURA: "BE16",
	NEW_APPLY: "BE17",
	UPDATE_SCENE_SHOW: "BE18",
	BANQ_START: "BE19",
	BARRIAGE_SUCCESS: "BE20",
	BARRIAGE_STATE: "BR21"
}
window["BanqEvent"] = BanqEvent
export class BanquetModel extends EventDispatcher {
	InviteViewData
	AddTableEffect
	ApplyViewData
	AskData
	CanEat
	CanSuger
	CandyInfo
	CheckFree
	CheckIsMarriedCouple
	ClearTime
	ClientCfg
	GetBrideFigure
	GetBrideId
	GetDayList
	GetFreeCount
	GetGroomFigure
	GetGroomId
	GetGuestPosId
	GetTalkCfg
	// GetUnAffectRoleList
	InitCfg
	IsTable
	IsCandy
	ManInfo
	PosCfg
	SetApplyViewData
	SetAskData
	SetBanquetCall
	UpdateDesk
	anotherPick
	askRed
	canApply
	banqState
	effectList
	guestList
	lessInviteNum
	newApply
	sugerId
	timeid
	weddingInfo
	BanMsg
	GetWedidingClothId
	GetRoleHeadIconInfo

	list_table_num        //{"monster_instance_id":collect_num}
	table_collect_count = 2 //餐桌可以采集的次数
	view_is_open //场景面板是否打开

	static Instance: BanquetModel;
	/**婚礼道具使用信息*/
	public GoodsInfo;
	public weddingRoleList;
	/**65婚礼信息*/
	public BanquetData;
	public constructor() {
		super()

		// if (BanquetModel.GetInstance) {
		// 	return
		// }
		this.lessInviteNum = 0;
		this.guestList = [];
		this.sugerId = [8002003, 8002004];
		this.newApply = false;
		this.list_table_num = {}
		this.canApply = false;
		this.effectList = [];
		this.anotherPick = [];
		this.askRed = false;
		let local_Config = Config
		let role_mgr = RoleManager.GetInstance()
		let local_BanqEvent = BanqEvent
		let activity_icon_mgr: ActivityIconManager = ActivityIconManager.GetInstance()
		let local_ActivityIconManager = ActivityIconManager
		let local_GlobalEventSystem = GlobalEventSystem
		let scene_mgr = SceneManager.GetInstance()
		let local_TimeUtil = TimeUtil
		let scene = Scene.GetInstance()
		let local_EventName = EventName
		let res_mgr = ResManager.GetInstance()

		let BanCandyCfg_ = null
		let nomSugerMax_ = 20
		let expSugerMax_ = 5
		this.InitCfg = () => {
			BanCandyCfg_ = Config.PRELOAD_SERVER_CONFIG.config_wedding_candies
			this.PosCfg = Config.PRELOAD_SERVER_CONFIG.config_wedding_guest_position
			this.ClientCfg = Config.PRELOAD_CLIENT_CONFIG.ClientBanquet

			if (BanCandyCfg_) {
				nomSugerMax_ = BanCandyCfg_[this.sugerId[0]].limit_num;
				expSugerMax_ = BanCandyCfg_[this.sugerId[1]].limit_num;
			}
		}

		this.SetApplyViewData = (scmd?) => {
			this.ApplyViewData = scmd
			this.canApply = false
			if (scmd.now_wedding_state == 2) {

			} else {
				for (let _tmpi in scmd.my_wedding_times) {
					var vo = scmd.my_wedding_times[_tmpi]
					if (vo.use_times < vo.max_times && (vo.wedding_type != 3 || vo.wedding_type == 3 && !vo.order_today)) {
						this.canApply = true
					}
				}
			}
			MarriageModel.GetInstance().CheckAskRedStatus()
		}

		this.GetDayList = () => {
			if (this.ApplyViewData) {
				return this.ApplyViewData.day_list
			}
		}

		this.ClearTime = () => {
			if (this.timeid) {
				clearTimeout(this.timeid)
				this.timeid = null
			}
		}

		this.SetBanquetCall = (scmd?) => {
			if (scmd.type == 1 && scmd.wedding_list.length > 0) {
				let roleId = role_mgr.GetMainRoleId()
				let info = scmd.wedding_list[0]

				let str: string = "进行中"
				let color = "#88ff43"

				if (info) {
					let manInfo = info.man_list[0]
					let womanInfo = info.woman_list[0]
					this.weddingInfo = info

					if (manInfo.role_id == roleId || womanInfo.role_id == roleId) {
						this.ClearTime()
						this.timeid = setTimeout(() => {
							this.Fire(local_BanqEvent.BANQ_START)
							if (this.weddingInfo) {
								activity_icon_mgr.addIcon("172@1")
								// let activityIcon = activity_icon_mgr.getIconInfo("172@1");
								// activityIcon.icon_txt = str;

								GlobalEventSystem.Fire(ActivityIconManager.SET_ICON_TEXT, "172@1", str, color)
								//local_GlobalEventSystem.Fire(local_ActivityIconManager.SET_ICON_TEXT, "172@1", str);//这里协议发出去的，有可能activiIcon对象那边还没有初始化完成监听，所以增加了上面2句
								activity_icon_mgr.deleteIcon("172@2")
								if (scene_mgr.IsFieldScene()) {
									GlobalEventSystem.Fire(EventName.OPEN_VIEW, "BanquetNoticeView", 1);
								}
							}
							this.ClearTime()
						}, (this.weddingInfo.start_time - local_TimeUtil.getServerTime() + 2) * 1000)
					} else {
						let time = local_TimeUtil.timeConversion(this.weddingInfo.start_time, "hh:MM")
						activity_icon_mgr.addIcon("172@1", null, null, time + "开始")
						if (this.weddingInfo.start_time >= local_TimeUtil.getServerTime()) {
							this.ClearTime()
							this.timeid = setTimeout(() => {
								local_GlobalEventSystem.Fire(local_ActivityIconManager.SET_ICON_TEXT, "172@1", str, color);
								for (let _tmpi in info.guest_list) {
									var vo = info.guest_list[_tmpi]
									if (vo.role_id == role_mgr.GetMainRoleId() && scene_mgr.IsFieldScene()) {
										GlobalEventSystem.Fire(EventName.OPEN_VIEW, "BanquetNoticeView", 1);
										break
									}
								}
								this.ClearTime()
							}, (this.weddingInfo.start_time - local_TimeUtil.getServerTime() + 2) * 1000)
						} else {
							local_GlobalEventSystem.Fire(local_ActivityIconManager.SET_ICON_TEXT, "172@1", str,color)
						}
						this.Fire(local_BanqEvent.BANQUET_CALL, scmd)
					}
				}
			} else {
				activity_icon_mgr.deleteIcon("172@1")
				this.weddingInfo = null
				this.InviteViewData = null
			}
		}

		this.CheckFree = (gtype?) => {
			if (this.GoodsInfo) {
				if (gtype == 1) {
					return this.GoodsInfo.free_candies > 0
				} else if (gtype == 2) {
					return this.GoodsInfo.free_fires > 0
				}
			}
		}

		this.GetFreeCount = (gtype?) => {
			if (this.GoodsInfo) {
				if (gtype == 1) {
					return this.GoodsInfo.free_candies
				} else if (gtype == 2) {
					return this.GoodsInfo.free_fires
				}
			}
			return 0
		}

		this.CandyInfo = (index?) => {
			let cfg = BanCandyCfg_
			// [ts2lua]this.sugerId下标访问可能不正确
			let type = this.sugerId[index]
			if (cfg) {
				// [ts2lua]cfg下标访问可能不正确
				return cfg[type]
			}
			return null
		}

		this.GetGuestPosId = () => {
			let roleId = role_mgr.GetMainRoleId()
			if (this.weddingRoleList && this.weddingRoleList.guest_position_list) {
				for (let _tmpi in this.weddingRoleList.guest_position_list) {
					var vo = this.weddingRoleList.guest_position_list[_tmpi]
					if (roleId == vo.guest_role_id) {
						return vo.pos_id
					}
				}
			}
			return 1
		}

		this.UpdateDesk = () => {
			if (this.BanquetData && this.BanquetData.stage_id == 3) {
				let list = this.GoodsInfo
				if (list && list.collect_table_list) {
					for (let _tmpi in list.collect_table_list) {
						var vo = list.collect_table_list[_tmpi]
						this.list_table_num[vo.table_mon_only_id] = true
					}
				}
				let target = scene.GetClickTarget()
				if (target && this.list_table_num[target.id]) {
					scene.SetClickTarget(false)
				}
			}
		}

		/** 返回男方玩家id*/
		this.GetGroomId = () => {
			if ((this.weddingRoleList && this.weddingRoleList.man_list) && this.weddingRoleList.man_list[0]) {
				return this.weddingRoleList.man_list[0].role_id_m
			}
		}

		this.GetGroomFigure = () => {
			if ((this.weddingRoleList && this.weddingRoleList.man_list) && this.weddingRoleList.man_list[0]) {
				return this.weddingRoleList.man_list[0]
			}
		}

		/** 返回女方玩家id*/
		this.GetBrideId = () => {
			if ((this.weddingRoleList && this.weddingRoleList.woman_list) && this.weddingRoleList.woman_list[0]) {
				return this.weddingRoleList.woman_list[0].role_id_w
			}
		}

		this.GetBrideFigure = () => {
			if ((this.weddingRoleList && this.weddingRoleList.woman_list) && this.weddingRoleList.woman_list[0]) {
				return this.weddingRoleList.woman_list[0]
			}
		}

		this.ManInfo = (sex?) => {
			if (this.weddingRoleList) {
				if (sex == 1) {
					return this.weddingRoleList.man_list[0]
				} else {
					return this.weddingRoleList.woman_list[0]
				}
			}
		}

		this.AddTableEffect = (id?) => {

		}

		this.SetAskData = (info?) => {
			this.AskData = info
			if (this.AskData.length > 0) {
				local_GlobalEventSystem.Fire(local_EventName.REFRESH_ACTIVITY_ICON_RED_DOT, "172@2", true)
			} else {
				local_GlobalEventSystem.Fire(local_EventName.REFRESH_ACTIVITY_ICON_RED_DOT, "172@2", false)
			}
		}

		/***糖果是否可以被采集*/
		this.CanSuger = (type?, ins_id?) => {
			if (!this.IsCandy(type)) return false
			let info = this.BanquetData

			//糖果被采集后，会销毁掉，重新new出来ins_id可能一样，会出现采集终止的问题
			// if (this.anotherPick[ins_id]) {
			// 	return false
			// }

			if (info) {
				if (type == 8002003) {
					return nomSugerMax_ > info.less_normal_candies
				} else if (type == 8002004) {
					return expSugerMax_ > info.less_special_candies
				}
			}
		}

		/**餐桌是否可以采集  每个餐桌可以采集N次*/
		this.CanEat = (type?, ins_id?) => {
			if (!this.IsTable(type)) return false
			let boo = this.list_table_num[ins_id] ? false : true
			return boo
		}

		/***是否是餐桌 */
		this.IsTable = (type_id?) => {
			if (type_id == 8002001 || type_id == 8002002 || type_id == 8002005) {
				return true
			}
			return false
		}

		/***是否是喜糖 */
		this.IsCandy = (type_id?) => {
			if (type_id == 8002003 || type_id == 8002004) {
				return true
			}
			return false
		}


		this.GetTalkCfg = () => {
			let cfg = [
				{
					trigger_type: "auto", //触发类型  auto表示上一个步骤结束后会自动触发当前步骤， manul:表示需要外在条件成立 才能触发当前步骤
					talker: "sys1", //讲话者   player表示玩家  sys表示系统  boss表示boss
					content: "一路高翔比翼鸟，蓉池怒放并蒂莲，今天又有一对新人正式走入了婚姻的殿堂，让我们热烈恭喜他们",//对话内容
					npc_id: 10030001,
					hide_daoshu: 1
				},
				{
					trigger_type: "auto", //触发类型  auto表示上一个步骤结束后会自动触发当前步骤， manul:表示需要外在条件成立 才能触发当前步骤
					talker: "sys1", //讲话者   player表示玩家  sys表示系统  boss表示boss
					content: "你是否愿意这个@成为你的伴侣?无论疾病还是健康,贫穷还是富有,永远对他忠贞不渝?", //对话内容
					index: 1,
					npc_id: 10030001,
					hide_daoshu: 1
				},
				{
					trigger_type: "auto", //触发类型  auto表示上一个步骤结束后会自动触发当前步骤， manul:表示需要外在条件成立 才能触发当前步骤
					talker: "woman", //讲话者   player表示玩家  sys表示系统  boss表示boss
					content: "我愿意.", //对话内容
					id: this.GetBrideId(),//10030001
					type: DialogueTypeConst.BANQUET,
					hide_daoshu: 1
				},
				{
					trigger_type: "auto", //触发类型  auto表示上一个步骤结束后会自动触发当前步骤， manul:表示需要外在条件成立 才能触发当前步骤
					talker: "sys1", //讲话者   player表示玩家  sys表示系统  boss表示boss
					content: "你是否愿意这个@成为你的伴侣?无论疾病还是健康,贫穷还是富有,永远对他忠贞不渝?", //对话内容
					index: 2,
					npc_id: 10030001,
					hide_daoshu: 1
				},
				{
					trigger_type: "auto", //触发类型  auto表示上一个步骤结束后会自动触发当前步骤， manul:表示需要外在条件成立 才能触发当前步骤
					talker: "man", //讲话者   player表示玩家  sys表示系统  boss表示boss
					content: "我愿意", //对话内容
					id: this.GetGroomId(),
					type: DialogueTypeConst.BANQUET,
					hide_daoshu: 1
				},
				{
					trigger_type: "auto", //触发类型  auto表示上一个步骤结束后会自动触发当前步骤， manul:表示需要外在条件成立 才能触发当前步骤
					talker: "sys1", //讲话者   player表示玩家  sys表示系统  boss表示boss
					content: "既然如此，你们愿意在诸神的见证下起誓，彼此互相守护陪伴一生么？", //对话内容
					npc_id: 10030001,
					hide_daoshu: 1
				},
				{
					trigger_type: "auto", //触发类型  auto表示上一个步骤结束后会自动触发当前步骤， manul:表示需要外在条件成立 才能触发当前步骤
					talker: "man", //讲话者   player表示玩家  sys表示系统  boss表示boss
					content: "我以诸神的名义起誓:从今日起,你将成为我的伴侣,不论祸福,贵贱,疾病还是健康,我都爱你,珍视你。", //对话内容
					id: this.GetGroomId(),
					type: DialogueTypeConst.BANQUET,
					hide_daoshu: 1
				},
				{
					trigger_type: "auto", //触发类型  auto表示上一个步骤结束后会自动触发当前步骤， manul:表示需要外在条件成立 才能触发当前步骤
					talker: "woman", //讲话者   player表示玩家  sys表示系统  boss表示boss
					content: "我以诸神的名义起誓:从今日起,你将成为我的伴侣,不论祸福,贵贱,疾病还是健康,我都爱你,珍视你。",//对话内容
					id: this.GetBrideId(),
					type: DialogueTypeConst.BANQUET,
					hide_daoshu: 1
				},
				{
					trigger_type: "auto", //触发类型  auto表示上一个步骤结束后会自动触发当前步骤， manul:表示需要外在条件成立 才能触发当前步骤
					talker: "sys1", //讲话者   player表示玩家  sys表示系统  boss表示boss
					content: "在诸神的见证下，我宣布你们正式结为伴侣，祝福你们，愿你们从此白首不分离，婚礼仪式正式结束",//对话内容
					npc_id: 10030001,
					hide_daoshu: 1
				},
			]
			return cfg
		}


		this.CheckIsMarriedCouple = (role_id?) => {
			if (this.GetBrideId() == role_id) {
				return true
			}
			if (this.GetGroomId() == role_id) {
				return true
			}
			return false
		}

		// this.GetUnAffectRoleList = () => {
		// 	//仪式中，不屏蔽新人
		// 	let list = []
		// 	let aniM = BanquetAniManager.GetInstance();
		// 	if (aniM.bool_playing) {
		// 		let groom = aniM.getGroomObj()
		// 		if (groom) {
		// 			table.insert(list, groom)
		// 		}
		// 		let bride = aniM.getBrideObj()
		// 		if (bride) {
		// 			table.insert(list, bride)
		// 		}
		// 	}
		// 	return list
		// }

		/**婚礼服饰 婚礼时装*/
		this.GetWedidingClothId = (sex?) => {
			return sex == 1 ? 1105 : 1205
		}

		/**获取头像的信息 */
		this.GetRoleHeadIconInfo=(picture_str)=>{
			let my_arr = ErlangParser.GetInstance().parse(picture_str||"")
			let my_picture = (my_arr && my_arr[0] && my_arr[0][1]) || "107"
			let my_carrer = (my_arr && my_arr[1] && my_arr[1][1]) || 1
			return [my_picture,my_carrer]
		}
	}

	public static GetInstance() {
		if (!BanquetModel.Instance) {
			BanquetModel.Instance = new BanquetModel()
		}
		return BanquetModel.Instance
	}

}
window["BanquetModel"] = BanquetModel
import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { Scene } from "../scene/Scene"
import { SceneManager } from "../scene/SceneManager"
import { SceneObj } from "../scene/sceneobj/SceneObj"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventDispatcher } from "../util/EventDispatcher"
import { GlobalTimerQuest } from "../util/Util"
import { GoodsModel } from "./GoodsModel"
import { RoleManager } from "./RoleManager"
import { Config } from "../common/Config"
import { MainUIController } from "../commonController/MainUIController"
import { MainUIModel } from "./MainUIModel"
import { CustomActivityModel } from "./CustomActivityModel"

export let KfViewIndex = {
	Eudaemon_Ridge_Boss: 1,
	Domain_Boss: 2,
	ENTERNITY: 3,
	TSCrack: 4
	//SeaHegemony = 5
}
window["KfViewIndex"] = KfViewIndex

export let Kf1vnEvent = {
	KF1VN_REQUEST_PROTO: "KF1VN_REQUEST_PROTO",
	KF1VN_CLOSE_PLAYING_VIEW: "KF1VN_CLOSE_PLAYING_VIEW",
	KF1VN_SELECT_QUIZ_ITEM: "KF1VN_SELECT_QUIZ_ITEM",
	KF1VN_SELECT_RADIO_ITEM: "KF1VN_SELECT_RADIO_ITEM",
	KF1VN_REFRESH_DEFENDER_HP: "KF1VN_REFRESH_DEFENDER_HP",
	KF1VN_UPDATE_QUIZ_INFO: "KF1VN_UPDATE_QUIZ_INFO",
	EXCHANGE_ICON_FLY: "EXCHANGE_ICON_FLY",
	OPEN_DIAOND_FIGHT_VIEW: "Kf1vnEvent.OPEN_DIAOND_FIGHT_VIEW",
	KF1VN_GET_QUIZ_REWARD_SUCCESS: "KF1VN_GET_QUIZ_REWARD_SUCCESS",
	QUIZ_REWARD_ICON_FLY: "QUIZ_REWARD_ICON_FLY",
	KF1VN_UPDATE_RED_DOT: "KF1VN_UPDATE_RED_DOT"
}
window["Kf1vnEvent"] = Kf1vnEvent

//最强王者数据model
export class Kf1vnModel extends EventDispatcher {
	CancelTimer
	ClearData
	DeleteNotPlayerRole
	GetBattleDataById
	GetExchangeGoodsData
	GetLeaderRankDara
	GetQuizTitleByTurn
	GetTurnMax
	HaveQuizRewardCanGet
	InitConfig
	IsVistorInFightScene
	MainRoleIsVistorInFightScene
	SendActivityChuanWen
	SetStageInfo
	ShopRedDot
	StartChuanWenTimer
	UpdateQuizInfo
	exchange_data
	had_show_foreshow
	has_show_shop_dot
	is_vistor
	leader_fighting_info
	leader_rank_data
	not_show_diamond_cost_alert
	on_time
	page_info
	quiz_history
	rank_info_in_waiting_scene
	showChatChannel
	show_quiz_alert
	stage_info
	ticket_fighting_info
	ticket_rank_data
	ticket_wait_info
	quiz_info
	CheckSignRed
	RefreshIcon

	data_obj_
	main_ui_visible
	GetMainUIVisible
	SetMainUIVisible

	public static ForeshowType = "621@0@1"
	public static ICON_TYPE = "621"
	public static MODULE_ID = 621
	public static ExchangeShopType = 4
	public static ZhanHunTypeId = 36255003
	public static CoinTypeId = 35

	public constructor() {
		super()

		if (Kf1vnModel.Instance) {
			return
		}
		let scene_mgr = SceneManager.GetInstance()
		let scene = Scene.GetInstance()
		let goods_model = GoodsModel.GetInstance()
		let count_time_id_ = null
		let chuanwen_time_ = null
		let res_mgr = ResManager.GetInstance()

		this.InitConfig = () => {
		}

		this.GetMainUIVisible=()=>{
			return this.main_ui_visible
		}


		this.SetMainUIVisible=(bool?)=>{
			this.main_ui_visible=bool
			let mainUI_controller = MainUIController.GetInstance()
			mainUI_controller.SetMainUIViewVisible(10, bool)
			MainUIModel.GetInstance().Fire(MainUIModel.CHANGE_ACTIVITY_STATE, bool)
			if (scene_mgr.IsKf1vnFightScene()) {
				mainUI_controller.SetMainUIViewVisible(0, false)
				mainUI_controller.SetMainUIViewVisible(1, false)
				mainUI_controller.SetMainUIViewVisible(2, false)
				mainUI_controller.SetMainUIViewVisible(5, false)
				mainUI_controller.SetCareerLevelVisible(false)
				mainUI_controller.SetMapVisible(false)
				mainUI_controller.SetHeadVisible(false)
			} else if (scene_mgr.IsKf1vnWaitingScene()) {
				mainUI_controller.SetMainUIViewVisible(0, true)
				mainUI_controller.SetMainUIViewVisible(1, true)
				mainUI_controller.SetMainUIViewVisible(2, true)
				mainUI_controller.SetMainUIViewVisible(5, true)
				mainUI_controller.SetCareerLevelVisible(true)
				mainUI_controller.SetMapVisible(true)
				mainUI_controller.SetHeadVisible(true)
			}
		}

		this.ClearData = () => {
			this.data_obj_={}
			this.page_info = false
			this.stage_info = false
			this.ticket_wait_info = false
			this.ticket_fighting_info = false
			this.ticket_rank_data = false
			this.leader_fighting_info = false
			this.leader_rank_data = false
			this.rank_info_in_waiting_scene = false
			this.quiz_history = false
			this.is_vistor = false
			this.show_quiz_alert = true
			this.not_show_diamond_cost_alert = false
			this.has_show_shop_dot = false			//是否顯示過商城紅點
			this.had_show_foreshow = false			//是否显示过活动预告
		}
		this.ClearData()

		this.SetStageInfo = (data?) => {
			this.ChangeVar("stage_info", data)
		}


		this.GetBattleDataById = (battle_id?) => {
			let value = null
			if (this.quiz_info) {
				for (let _tmpi in this.quiz_info.bet_list) {
					var vo = this.quiz_info.bet_list[_tmpi]
					if (vo.battle_id == battle_id) {
						value = vo
						break
					}
				}
			}
			return value
		}


		this.UpdateQuizInfo = () => {
			if (this.stage_info && this.stage_info.stage == 5 && this.quiz_info) {
				for (let _tmpi in this.quiz_info.bet_list) {
					var vo = this.quiz_info.bet_list[_tmpi]
					if (this.stage_info.sub_stage <= 2) {
						vo.status = 0
					} else if (this.stage_info.sub_stage == 3) {
						vo.status = 1
					} else {
						vo.status = 2
					}
					this.Fire(Kf1vnEvent.KF1VN_UPDATE_QUIZ_INFO)
				}
			}
		}

		this.GetLeaderRankDara = () => {
			let result = []
			if (this.leader_rank_data && this.leader_rank_data.rank_2_def_rank) {
				for (let _tmpi in this.leader_rank_data.rank_2_def_rank) {
					var vo = this.leader_rank_data.rank_2_def_rank[_tmpi]
					if (vo.turn > 0) {
						table.insert(result, vo)
					}
				}
			}
			return result
		}


		this.SendActivityChuanWen = () => {
			let scmd = null
			scmd = []
			scmd.module_id = 621
			scmd.id = 6
			scmd.content = ""
			GlobalEventSystem.Fire(EventName.RECEIVE_NEW_CHUANWEN, scmd, 11015)
		}

		this.StartChuanWenTimer = () => {
			this.CancelTimer()
			if (this.stage_info && this.stage_info.stage == 1) {
				if (chuanwen_time_ == null) {
					chuanwen_time_ = 0
					this.SendActivityChuanWen()
				}
				let time_fun = () => {
					this.on_time()
				}
				count_time_id_ = GlobalTimerQuest.AddPeriodQuest(time_fun, 1, -1)
				this.on_time()
			}
		}

		this.on_time = () => {
			if (chuanwen_time_ != null) {
				chuanwen_time_ = chuanwen_time_ + 1
				if (chuanwen_time_ >= 60 * 10) {
					chuanwen_time_ = 0
					this.SendActivityChuanWen()
				}
			}
		}

		this.CancelTimer = () => {
			if (count_time_id_) {
				GlobalTimerQuest.CancelQuest(count_time_id_)
				count_time_id_ = null
			}
		}

		this.MainRoleIsVistorInFightScene = () => {
			if (scene_mgr.IsKf1vnFightScene() && this.is_vistor) {
				return true
			}
		}

		//是否是观察者
		this.IsVistorInFightScene = (role_id?) => {
			let is_vistor = false
			if (this.leader_fighting_info) {
				is_vistor = true
				for (let _tmpi in this.leader_fighting_info.challenger_list) {
					var vo = this.leader_fighting_info.challenger_list[_tmpi]
					if (vo.player_id == role_id) {
						is_vistor = false
						break
					}
				}
				if (this.leader_fighting_info.player_id == role_id) {
					is_vistor = false
				}
			}
			return is_vistor
		}

		this.DeleteNotPlayerRole = () => {
			if (this.leader_fighting_info && scene.role_list && scene_mgr.IsKf1vnFightScene()) {
				let role = null
				for (let id in scene.role_list) {

					role = scene.role_list[id]
					if (role) {
						let find = false
						for (let _tmpi in this.leader_fighting_info.challenger_list) {
							var vo = this.leader_fighting_info.challenger_list[_tmpi]
							if (vo.player_id == role.vo.role_id) {
								find = true
								break
							}
						}
						if (this.leader_fighting_info.player_id == role.vo.role_id) {
							find = true
						}
						if (find == false) {
							if (role.vo.role_id == RoleManager.GetInstance().mainRoleInfo.role_id) {
								console.log("这里咋要删掉主角//////////////////////")
								if (scene.main_role) {
									scene.main_role.SetModelHideFlag(SceneObj.ModelHideFlag.ServerHide, true)
								}
								break
							}
							scene.DeleteRole(role.vo.role_id)
						}
					}
				}
			}
		}
		//是否有竞猜奖励未领取
		this.HaveQuizRewardCanGet = () => {
			let can_get = false
			if (this.quiz_history) {
				for (let _tmpi in this.quiz_history.bet_list) {
					var vo = this.quiz_history.bet_list[_tmpi]
					if (vo.bet_result != 0 && vo.status == 2) {
						can_get = true
						break
					}
				}
			}
			return can_get
		}

		//兑换商店数据
		this.GetExchangeGoodsData = () => {
			if (!this.exchange_data) {
				this.exchange_data = goods_model.GetGoodsExchangeData(Kf1vnModel.ExchangeShopType)
				if (this.exchange_data && Config.PRELOAD_SERVER_CONFIG.config_goods_exchange_rule) {
					let goods = null
					let basic = null
					for (let _tmpi in this.exchange_data) {
						var vo = this.exchange_data[_tmpi]
						vo.cfg = Config.PRELOAD_SERVER_CONFIG.config_goods_exchange_rule[vo.id]
						if (vo.cfg) {
							vo.obtain_list = JSON.parse(vo.cfg.obtain_list)
							vo.cost_list = JSON.parse(vo.cfg.cost_list)
							if (vo.obtain_list[1]) {
								vo.type_id = Number(vo.obtain_list[0][1])
								basic = goods_model.GetGoodsBasicByTypeId(vo.type_id)
								if (basic) {
									vo.color = basic.color
								}
							}
							if (vo.cost_list[0]) {
								vo.cost = Number(vo.cost_list[0][2])
							}
						}
					}
					let sort_fun = (a?, b?) => {
						if (a.color != null && b.color != null && a.cost != null && b.cost != null) {
							if (a.cost == b.cost) {
								return a.color > b.color
							} else {
								return a.cost > b.cost
							}
						}
					}
					table.sort(this.exchange_data, sort_fun)
				}
			} else {
				let new_data = goods_model.GetGoodsExchangeData(Kf1vnModel.ExchangeShopType)
				if (new_data) {
					for (let i = 0; i < this.exchange_data.length; i++) {
						var v = this.exchange_data[i]
						for (let j = 0; j < new_data.length; j++) {
							var vo = new_data[j]
							if (v.id == vo.id) {
								v.count = vo.count
								break
							}
						}
					}
				}

				
				let sort_fun = (a?, b?) => {
					if(a.cost&&b.cost){
						return a.cost>b.cost
					}
				}
				table.sort(this.exchange_data, sort_fun)

			}

			return this.exchange_data
		}


		//兑换红点
		this.ShopRedDot = () => {
			let can_exchange = false
			let exchange_data = this.GetExchangeGoodsData()
			if (exchange_data) {
				let role_lv = RoleManager.GetInstance().mainRoleInfo.level
				let myhave = 0
				let cost_list = null
				for (let _tmpi in exchange_data) {
					var vo = exchange_data[_tmpi]
					if (vo.cfg && vo.cfg.role_lv <= role_lv) {
						myhave = goods_model.GetSpecialScore(Kf1vnModel.ZhanHunTypeId)
						if (vo.cost_list && vo.cost_list[0]) {
							cost_list = vo.cost_list[0]
							if (cost_list && myhave >= Number(cost_list[2])) {
								can_exchange = true
								break
							}
						}
					}
				}
			}

			//每天第一次登录显示红点
			if(CustomActivityModel.GetInstance().GetDayFirstLoginStatus()){
				if (this.has_show_shop_dot) {
					return false
				}else{
					return can_exchange
			}
			}else{
				return false
			}
		}


		this.GetQuizTitleByTurn = (turn?) => {
			let str = "战斗结束，哪方获得胜利？"
			if (turn >= 4 && turn <= 5) {
				str = "战斗结束，擂主剩余血量百分比？"
			} else if (turn >= 6 && turn <= 7) {
				str = "战斗结束，剩余多少名挑战者？"
			}
			return str
		}

	

		this.showChatChannel = () => {
			return scene_mgr.IsKf1vnWaitingScene() || scene_mgr.IsKf1vnFightScene()
		}
		/**检查报名红点 */
		this.CheckSignRed=()=>{
			//是否休战
			//是否报名
			if(this.stage_info&&this.page_info){
				if(this.stage_info.stage == 1&&this.page_info.is_sign != 1){
					return true
				}
			}
			return false
		}
		//刷新图标红点
		this.RefreshIcon=()=>{
			GlobalEventSystem.Fire(EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 2820)
			GlobalEventSystem.Fire(EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 621)
			this.Fire(Kf1vnEvent.KF1VN_UPDATE_RED_DOT)
		}
	}


	static Instance
	public static GetInstance() {

		if (!Kf1vnModel.Instance) {
			Kf1vnModel.Instance = new Kf1vnModel()
		}
		return Kf1vnModel.Instance
	}
}
window["Kf1vnModel"] = Kf1vnModel
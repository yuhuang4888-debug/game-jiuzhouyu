import { Alert, Alert_Type } from "../alert/Alert"
import { BaseView1 } from "../common/BaseView1"
import { EventName } from "../common/EventName"
import { Enum_UILayer, LayerManager } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { MainUIManager } from "../common/MainUIManager"
import { ResManager } from "../common/ResManager"
import { ViewManager } from "../common/ViewManager"
import { MainUIController } from "../commonController/MainUIController"
import { Kf1vnModel, Kf1vnEvent } from "../commonModel/Kf1vnModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { Util, GlobalTimerQuest, SetHtmlStyle, SetHtmlCenter } from "../util/Util"
import { Kf1vnPlatformPlayingItem } from "./Kf1vnPlatformPlayingItem"

/**竞猜界面 */
export class Kf1vnPlatformPlayingView extends BaseView1 {
	CancelTimer
	InitEvent
	LoadSuccess
	OnTime
	OpenCallback
	SetProgress
	StartTimer
	UpdateActivityState
	UpdateQuizList
	UpdateTopTitle
	back_login_close
	change_scene_close
	loop_mgr
	GetTurnMax
	GetDefendNumByTurn
	public constructor() {
		super()

		this.base_file = "kf1vn"
		this.layout_file = "Kf1vnPlatformPlayingView"
		this.layer_value = Enum_UILayer.Main
		this.back_login_close = true
		this.use_background = true
		this.click_bg_toClose = false
		this.destroy_imm = true
		this.append_to_ctl_queue = true
		this.change_scene_close = true
		//this.is_lastView_close=true
		let model = Kf1vnModel.GetInstance()
		let left_time_id_ = null
		let show_animation_ = false
		let item_list_ = null
		//this.is_center=true
		this.preload_server_config = { "config_kf_1vn_match": false, "config_kf_1vn_kv": false, "config_kf_1vn_race_2_award": false }
		this.load_callback = () => {

			MainUIManager.GetInstance().AddMoveComponent(this, this._box, false, MainUIManager.MOVE_TYPE.Stay)
			MainUIManager.GetInstance().AddMoveComponent(this, this.btn_group, false, MainUIManager.MOVE_TYPE.Right)
			MainUIManager.GetInstance().AddMoveComponent(this, this.quitBtn, false, MainUIManager.MOVE_TYPE.Left)


			SetHtmlStyle(this.state_title, { c: "#ffffff", f: 22, ww: false, w: 720 })
			ResManager.GetInstance().SetOutsideImageSprite(this, this._Image2, GameResPath.GetIcon("kf1vn", "ui_role_title_bg1"))
			ResManager.GetInstance().SetOutsideImageSprite(this, this._Image1, GameResPath.GetIcon("kf1vn", "uikf1vn_035"))
			ResManager.GetInstance().SetOutsideImageSprite(this, this.progressBg, GameResPath.GetIcon("kf1vn", "ui_leitill_008"))
			this.LoadSuccess()
			this.InitEvent()


			//请求更新 挑战赛 竞猜列表(战斗信息列表)
			if (model.stage_info && model.stage_info.sub_stage <= 2) {
				model.Fire(Kf1vnEvent.KF1VN_REQUEST_PROTO, 62117)
			}

		}

		this.GetTurnMax = () => {
			let count = 0
			let cfg = null
			let config_kf_1vn_race_2_award = ResManager.GetInstance().GetGameConfigFromCache(this, "config_kf_1vn_race_2_award", false)
			for (let key in config_kf_1vn_race_2_award) {

				cfg = config_kf_1vn_race_2_award[key]
				if (cfg.turn > count) {
					count = cfg.turn
				}
			}
			return count
		}

		this.GetDefendNumByTurn = (turn?) => {
			let num = 0
			let config_kf_1vn_match = ResManager.GetInstance().GetGameConfigFromCache(this, "config_kf_1vn_match", false)
			if (config_kf_1vn_match) {
				let cfg = config_kf_1vn_match[turn]
				num = (config_kf_1vn_match[turn] && (config_kf_1vn_match[turn].c_num) || (0))
			}
			return num
		}

		this.open_callback = () => {
			this.OpenCallback()
		}

		this.destroy_callback = () => {
			this.CancelTimer()
			for (let _tmpi in item_list_) {
				var item = item_list_[_tmpi]
				item.DeleteMe()
				item = null
			}
			item_list_ = null
			if (this.loop_mgr) {
				this.loop_mgr.DeleteMe()
				this.loop_mgr = null
			}
		}

		this.LoadSuccess = () => {

			ResManager.GetInstance().SetOutsideImageSprite(this, this.bg, GameResPath.GetIcon("kf1vn", "ui_activity_06"))
			item_list_ = []
			model.Fire(Kf1vnEvent.KF1VN_REQUEST_PROTO, 62117)
			model.Fire(Kf1vnEvent.KF1VN_REQUEST_PROTO, 62133)
		}

		this.InitEvent = () => {


			let exit_fun = () => {
				let str = null
				if (model.stage_info) {
					if (model.stage_info.stage >= 2 && model.stage_info.stage <= 3) {
						str = "当前<font color='#00fa64'>最强王者资格赛</font>正在火热进行中！离开场景将无法正常进行资格赛匹配，是否确定要继续离开场景？"
					} else if (model.stage_info.stage >= 4 && model.stage_info.stage <= 5) {
						str = "当前<font color='#00fa64'>最强王者擂台赛</font>正在火热进行中！离开场景后将无法正常参与活动，是否确定要继续离开场景？"
					}
				}
				if (str) {
					let ok_fun = () => {
						model.Fire(Kf1vnEvent.KF1VN_REQUEST_PROTO, 62107)
					}

					str = Util.StrToHTML(str)
					Alert.Show(str, Alert_Type.Two, ok_fun)
				} else {
					model.Fire(Kf1vnEvent.KF1VN_REQUEST_PROTO, 62107)
				}
			}
			Util.AddClickEvent(this.quitBtn, exit_fun, this, true)


			let look_rank = () => {
				GlobalEventSystem.Fire(EventName.OPEN_VIEW, "Kf1vnRankView")
			}
			Util.AddClickEvent(this.rankBtn, look_rank, this, true)

			let history_btn_fun = () => {
				GlobalEventSystem.Fire(EventName.OPEN_VIEW, "Kf1vnShopView", 1)
			}
			Util.AddClickEvent(this.historyBtn, history_btn_fun, this, true)

			let shop_btn_fun = () => {
				GlobalEventSystem.Fire(EventName.OPEN_VIEW, "Kf1vnShopView", 0)
			}
			Util.AddClickEvent(this.shopBtn, shop_btn_fun, this, true)


			this.BindVar(model, "stage_info", (key?, value?) => {
				this.UpdateActivityState()
				this.UpdateTopTitle()
			}
			)
			this.BindEvent(model, Kf1vnEvent.KF1VN_UPDATE_QUIZ_INFO, () => {
				this.UpdateQuizList()
				this.UpdateTopTitle()
			}
			)
			this.BindEvent(model, Kf1vnEvent.KF1VN_CLOSE_PLAYING_VIEW, () => {
				this.Close()
			}
			)

			this.BindEvent(GlobalEventSystem, EventName.CLOSED_ONE_VIEW, () => {

				let ui_layer = LayerManager.GetInstance().GetUILayer(Enum_UILayer.Main)
				if (!ui_layer) return
				let obj = ui_layer.getChildAt(ui_layer.numChildren - 1)
				if (obj && obj.name == "MainUITopView") {
					MainUIController.GetInstance().SetTopToLayer(Enum_UILayer.Main)
					ui_layer.addChild(this.display_obj);
					ViewManager.GetInstance().ShowBackGroup(this)
				}
			})

		}

		this.OpenCallback = () => {
			this.UpdateTopTitle()
			this.UpdateActivityState()
			this.UpdateQuizList()
		}

		this.UpdateTopTitle = () => {
			if (model.stage_info && model.stage_info.stage == 5) {
				let num_str = ""
				if (model.quiz_info && model.quiz_info.def_num != null) {
					num_str = `剩余擂主：<font color='#fffaae'>${model.quiz_info.def_num}</font>`//
				}
				let no = this.GetDefendNumByTurn(model.stage_info.turn)
				let turn_max = this.GetTurnMax()
				let turn_str = `第${model.stage_info.turn}/${turn_max}轮：<font color='#fffaae'>1v${no}</font>`
				this.state_title.innerHTML = Util.StrToHTML(turn_str + "&nbsp;&nbsp;&nbsp;&nbsp;" + num_str)
				SetHtmlCenter(this.state_title, { x: 0, w: 720 })
			}
		}

		this.UpdateActivityState = () => {
			if (model.stage_info && model.stage_info.stage == 5) {
				let i = 0
				do {
					this["time_bg" + i].visible = false
					this["time" + i].visible = false
					this["kuang" + i + "_sel"].visible = false
					this["_text_" + (i + 1)].color = "#893637"
					this["_text_" + (i + 1)].strokeColor = "#ffdcd7"
					this["_text_" + (i + 1)].stroke = 2
					i = i + 1
				} while ((i < 3))
				this.CancelTimer()
				this.SetProgress(0, 100)
				if (model.stage_info.sub_stage == 1) {
					this.time_bg0.visible = true
					this.time0.visible = true
					this.kuang0_sel.visible = true

					this._text_1.color = "#000000"
					this._text_1.strokeColor = "#ffffff"
					this._text_1.stroke = 2

					this.StartTimer()
					this.SetProgress(0, 100)
				} else if (model.stage_info.sub_stage == 2) {
					this.time_bg1.visible = true
					this.time1.visible = true
					this.kuang1_sel.visible = true

					this._text_2.color = "#000000"
					this._text_2.strokeColor = "#ffffff"
					this._text_2.stroke = 2


					this.StartTimer()
					this.SetProgress(50, 100)
				} else if (model.stage_info.sub_stage == 3) {
					this.time_bg2.visible = true
					this.time2.visible = true
					this.kuang2_sel.visible = true

					this._text_3.color = "#000000"
					this._text_3.strokeColor = "#ffffff"
					this._text_3.stroke = 2


					this.StartTimer()
					this.SetProgress(100, 100)
				}
			}
		}

		this.StartTimer = () => {
			let time_fun = () => {
				this.OnTime()
			}
			left_time_id_ = GlobalTimerQuest.AddPeriodQuest(time_fun, 1, -1)
			time_fun()
		}

		this.OnTime = () => {
			if (model.stage_info && model.stage_info.stage == 5) {
				let left_time = model.stage_info.sub_edtime - TimeUtil.getServerTime()
				let label = null
				if (model.stage_info.sub_stage == 1) {
					label = this.time0
				} else if (model.stage_info.sub_stage == 2) {
					label = this.time1
				} else if (model.stage_info.sub_stage == 3) {
					label = this.time2
				}
				if (left_time <= 0) {
					this.CancelTimer()
					if (label) {
						label.text = "已结束"
					}
				} else {
					if (label) {
						label.text = TimeUtil.timeConvert(left_time, "hh:MM:ss")
					}
				}
			} else {
				this.CancelTimer()
			}
		}

		this.CancelTimer = () => {
			if (left_time_id_) {
				GlobalTimerQuest.CancelQuest(left_time_id_)
				left_time_id_ = null
			}
		}

		this.SetProgress = (now_value?, max?) => {
			let w = 395
			this.progressBar.width = Math.min((Number(now_value) / Number(max)) * w, w)
		}

		this.UpdateQuizList = () => {

			if (model.quiz_info && model.quiz_info.bet_list) {
				if (!this.loop_mgr) {
					this.loop_mgr = new LoopScrowViewMgr()
					this.loop_mgr.SetData(this.Content, Kf1vnPlatformPlayingItem, model.quiz_info.bet_list, LoopScrCon.Vertical)
				} else {
					this.loop_mgr.replaceAll(model.quiz_info.bet_list)
				}
				this.none_conta.visible = model.quiz_info.bet_list.length <= 0
			}
		}
	}


	_box: Laya.Box
	bg: Laya.Image
	_bg2: Laya.Image
	_txt1: Laya.Label
	_Image1: Laya.Image
	_Image2: Laya.Image
	state_title: Laya.HTMLDivElement
	progress_conta: Laya.Box
	progressBg: Laya.Image
	progressBar: Laya.Image
	_Group1: Laya.Box
	kuang0: Laya.Image
	kuang0_sel: Laya.Image
	time_bg0: Laya.Image
	time0: Laya.Label
	_text_1: Laya.Label
	_Group2: Laya.Box
	kuan1: Laya.Image
	kuang1_sel: Laya.Image
	time_bg1: Laya.Image
	time1: Laya.Label
	_text_2: Laya.Label
	_Group3: Laya.Box
	kuan2: Laya.Image
	kuang2_sel: Laya.Image
	time_bg2: Laya.Image
	time2: Laya.Label
	_text_3: Laya.Label
	Content: Laya.List
	none_conta: Laya.Box
	tips1: Laya.Label
	tips_icon1: Laya.Image
	btn_group: Laya.Box
	shopBtn: Laya.Box
	_Image9: Laya.Image
	shop_red_dot: Laya.Image
	rankBtn: Laya.Box
	_Image10: Laya.Image
	historyBtn: Laya.Box
	_Image11: Laya.Image
	history_red_dot: Laya.Image
	quitBtn: Laya.Image
	public GetComponents() {
		[
			this._box,
			this.bg,
			this._bg2,
			this._txt1,
			this._Image1,
			this._Image2,
			this.state_title,
			this.progress_conta,
			this.progressBg,
			this.progressBar,
			this._Group1,
			this.kuang0,
			this.kuang0_sel,
			this.time_bg0,
			this.time0,
			this._text_1,
			this._Group2,
			this.kuan1,
			this.kuang1_sel,
			this.time_bg1,
			this.time1,
			this._text_2,
			this._Group3,
			this.kuan2,
			this.kuang2_sel,
			this.time_bg2,
			this.time2,
			this._text_3,
			this.Content,
			this.none_conta,
			this.tips1,
			this.tips_icon1,
			this.btn_group,
			this.shopBtn,
			this._Image9,
			this.shop_red_dot,
			this.rankBtn,
			this._Image10,
			this.historyBtn,
			this._Image11,
			this.history_red_dot,
			this.quitBtn,
		]
			= this.GetChildrenByNames([

				"_box",
				"bg",
				"_bg2",
				"_txt1",
				"_Image1",
				"_Image2",
				"state_title",
				"progress_conta",
				"progressBg",
				"progressBar",
				"_Group1",
				"kuang0",
				"kuang0_sel",
				"time_bg0",
				"time0",
				"_text_1",
				"_Group2",
				"kuan1",
				"kuang1_sel",
				"time_bg1",
				"time1",
				"_text_2",
				"_Group3",
				"kuan2",
				"kuang2_sel",
				"time_bg2",
				"time2",
				"_text_3",
				"Content",
				"none_conta",
				"tips1",
				"tips_icon1",
				"btn_group",
				"shopBtn",
				"_Image9",
				"shop_red_dot",
				"rankBtn",
				"_Image10",
				"historyBtn",
				"_Image11",
				"history_red_dot",
				"quitBtn",
			])
	}
}
window["Kf1vnPlatformPlayingView"] = Kf1vnPlatformPlayingView
import { Alert, Alert_Type } from "../alert/Alert"
import { BaseView1 } from "../common/BaseView1"
import { EventName } from "../common/EventName"
import { Enum_UILayer, LayerManager } from "../common/LayerManager"
import { MainUIManager } from "../common/MainUIManager"
import { ResManager } from "../common/ResManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { Kf1vnModel, Kf1vnEvent } from "../commonModel/Kf1vnModel"
import { MainUIModel } from "../commonModel/MainUIModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { SYTweenLite } from "../util/SYTweenLite"
import { TimeUtil } from "../util/TimeUtil"
import { SetSizeDeltaX, SetSizeDeltaY, Util, GetSizeDeltaX, SetLocalPositionY, GlobalTimerQuest, SetHtmlStyle } from "../util/Util"
import { Vector2 } from "../util/Vector2"
import { Kf1vnPlatformPlayingView } from "./Kf1vnPlatformPlayingView"


//1vn准备场景
export class Kf1vnWaitSceneView extends BaseView1 {
	CancelEndTimer
	CancelTicketTimer
	CancelTopTimer
	InitEvent
	LoadSuccess
	OnEndTime
	OnTime
	OpenCallback
	SetBtnState
	ShowHistoryBtnDot
	ShowShopBtnDot
	StartEndTimer
	StartTicketTimer
	StartTopTimer
	UpdateActivityState
	UpdateMyRank
	UpdateTime
	UpdateWaitInfo
	back_login_close
	destroy_callback
	destroy_imm
	GetMaxMtachTimes
	SetBoxVis
	public constructor() {
		super()

		this.base_file = "kf1vn"
		this.layout_file = "Kf1vnWaitSceneView"
		this.layer_value = Enum_UILayer.Main
		this.back_login_close = true
		this.destroy_imm = true
		let model = Kf1vnModel.GetInstance()
		let goods_model = GoodsModel.GetInstance()
		let local_GoodsModel = GoodsModel
		let local_MainUIModel = MainUIModel
		let left_time_id_ = null
		let top_count_timer_ = null
		let is_match_ = null
		let end_time_ = null
		let end_time_id_ = null
		let close_time_ = 5
		this.preload_server_config = { "config_kf_1vn_kv": false }
		this.load_callback = () => {

			//MainUIManager.GetInstance().AddMoveComponent(this, this.gray_mask, false, MainUIManager.MOVE_TYPE.Stay)
			MainUIManager.GetInstance().AddMoveComponent(this, this.ticket_top_conta, false, MainUIManager.MOVE_TYPE.Top)
			MainUIManager.GetInstance().AddMoveComponent(this, this.stage_conta, false, MainUIManager.MOVE_TYPE.Top)
			MainUIManager.GetInstance().AddMoveComponent(this, this.end_conta, false, MainUIManager.MOVE_TYPE.Top)
			MainUIManager.GetInstance().AddMoveComponent(this, this.ticket_msg_conta, false, MainUIManager.MOVE_TYPE.Left)
			MainUIManager.GetInstance().AddMoveComponent(this, this._box_exit, false, MainUIManager.MOVE_TYPE.Left)
			MainUIManager.GetInstance().AddMoveComponent(this, this.btn_group, false, MainUIManager.MOVE_TYPE.Right)


			ResManager.GetInstance().SetOutsideImageSprite(this, this.end_bg, GameResPath.GetIcon("kf1vn", "ui_role_title_bg1"))
			// if (!model.GetMainUIVisible()) {
			// 	model.SetMainUIVisible(model.GetMainUIVisible())
			// }
			local_MainUIModel.GetInstance().Fire(MainUIModel.CHANGE_ACTIVITY_STATE, false)

			this.LoadSuccess()
			this.InitEvent()
		}

		this.GetMaxMtachTimes = () => {
			let config_kf_1vn_kv = ResManager.GetInstance().GetGameConfigFromCache(this, "config_kf_1vn_kv", false)
			let value = (config_kf_1vn_kv[12] && (config_kf_1vn_kv[12].value) || (10))
			return value
		}

		this.open_callback = () => {
			this.OpenCallback()
		}

		this.destroy_callback = () => {
			MainUIManager.GetInstance().RemoveMoveComponent(this)
			this.CancelTopTimer()
			this.CancelTicketTimer()
			this.CancelEndTimer()
		}

		this.LoadSuccess = () => {



			ResManager.GetInstance().LoadFont(this, "diamond_fight_3", this._lb_turn, null, false)
			SetHtmlStyle(this.match_times, { c: "#00fa64", f: 20, w: 130, ww: false })
			SetHtmlStyle(this.score, { c: "#00fa64", f: 20, w: 130, ww: false, lh: 25 })
			close_time_ = 5
		}

		this.InitEvent = () => {
			let look_rank = () => {
				GlobalEventSystem.Fire(EventName.OPEN_VIEW, "Kf1vnRankView")
			}
			Util.AddClickEvent(this.rankBtn, look_rank, this, true)
			Util.AddClickEvent(this.lookBtn, look_rank, this, true)

			let history_btn_fun = () => {
				GlobalEventSystem.Fire(EventName.OPEN_VIEW, "Kf1vnShopView", 1)
			}
			Util.AddClickEvent(this.historyBtn, history_btn_fun, this, true)

			let shop_btn_fun = () => {
				GlobalEventSystem.Fire(EventName.OPEN_VIEW, "Kf1vnShopView", 0)
			}
			Util.AddClickEvent(this.shopBtn, shop_btn_fun, this, true)

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
			Util.AddClickEvent(this._box_exit, exit_fun, this, true)

			this.BindVar(model, "ticket_wait_info", (key?, value?) => {
				this.UpdateWaitInfo()
				this.UpdateActivityState()
			}
			)

			this.BindVar(model, "rank_info_in_waiting_scene", (key?, value?) => {
				this.UpdateMyRank()
			}
			)

			this.BindVar(model, "stage_info", (key?, value?) => {
				this.UpdateWaitInfo()
				this.UpdateActivityState()
			}
			)

			this.BindVar(model, "quiz_history", (key?, value?) => {
				this.ShowHistoryBtnDot()
			}
			)

			let update_shop_red_dot = () => {
				this.ShowShopBtnDot()
			}
			this.BindEvent(goods_model, local_GoodsModel.UPDATE_GOODS_EXCHANGE_DATA, update_shop_red_dot)
			this.BindEvent(goods_model, local_GoodsModel.UPDATE_SPECIAL_SCORE, update_shop_red_dot)



			let view_complete = () => {
				MainUIModel.GetInstance().Fire(MainUIModel.CHANGE_ACTIVITY_STATE, false)
			}
			this.BindEvent(GlobalEventSystem, EventName.SCENE_LOAD_VIEW_COMPLETE, view_complete)
		}

		this.OpenCallback = () => {
			model.Fire(Kf1vnEvent.KF1VN_REQUEST_PROTO, 62133)
			this.UpdateActivityState()
			this.UpdateMyRank()
			this.UpdateWaitInfo()
			this.ShowHistoryBtnDot()
			this.ShowShopBtnDot()
		}

		this.UpdateActivityState = () => {
			this.gray_mask.visible = false
			this.CancelTopTimer()
			this.CancelEndTimer()
			if (model.stage_info) {

				if(model.stage_info.stage !=5){
					//关闭竞猜界面
					this.gray_mask.visible = false
					GlobalEventSystem.Fire(EventName.CLOSE_VIEW, "Kf1vnPlatformPlayingView")
				}

				if (model.stage_info.stage == 2) {
					this.SetBoxVis(this._box_exit, true)
					this.SetBoxVis(this.ticket_msg_conta, false)
					this.SetBoxVis(this.stage_conta, true)
					this.SetBoxVis(this.ticket_top_conta, false)
					this.SetBoxVis(this.end_conta, false)
					this.stage_label.text = "【资格赛】开启倒计时"
					this.StartTopTimer(model.stage_info.edtime, false, "0")
					//LayoutRebuilder(this._Group1)
				} else if (model.stage_info.stage == 3) {
					this.SetBoxVis(this._box_exit, true)
					this.SetBoxVis(this.ticket_msg_conta, true)
					this.SetBoxVis(this.stage_conta, false)
					this.SetBoxVis(this.ticket_top_conta, true)
					this.SetBoxVis(this.end_conta, false)
					if (model.stage_info.sub_stage == 4) {
						this.ticket_label.visible = true
						this.left_match_time.text = ""
						this.match_tips.text = "请耐心等候资格赛结算"
						this.match_tips.visible = true

						this._lb_turn.visible = this._Image_txt1.visible = this._Image_txt2.visible = false
					} else {
						this.ticket_label.visible = false
						let max_match_time = this.GetMaxMtachTimes()
						this._lb_turn.text = `${model.stage_info.turn}/${max_match_time}`
						this._lb_turn.visible = this._Image_txt1.visible = this._Image_txt2.visible = true
						this.match_tips.text = ""
						this.match_tips.visible = false
						this._box_turn.refresh()
						this.StartTopTimer(model.stage_info.sub_edtime, true, "")
					}
					//LayoutRebuilder(this.title_conta)
					//LayoutRebuilder(this.ticket_top_conta)
				} else if (model.stage_info.stage == 4) {
					this.SetBoxVis(this._box_exit, true)
					this.SetBoxVis(this.ticket_msg_conta, true)
					this.SetBoxVis(this.stage_conta, true)
					this.SetBoxVis(this.ticket_top_conta, false)
					this.SetBoxVis(this.end_conta, false)
					this.stage_label.text = "【守擂赛】开启倒计时"
					this.StartTopTimer(model.stage_info.edtime, false, "0")
				} else if (model.stage_info.stage == 5) {
					this.SetBoxVis(this.ticket_msg_conta, false)
					this.SetBoxVis(this.stage_conta, false)
					this.SetBoxVis(this.ticket_top_conta, false)
					this.SetBoxVis(this.end_conta, false)
					this.SetBoxVis(this._box_exit, false)

					//竞猜界面
					this.gray_mask.visible = false
					GlobalEventSystem.Fire(EventName.OPEN_VIEW, "Kf1vnPlatformPlayingView")
				} else if (model.stage_info.stage == 6) {
					this.SetBoxVis(this._box_exit, true)
					this.SetBoxVis(this.ticket_msg_conta, false)
					this.SetBoxVis(this.stage_conta, false)
					this.SetBoxVis(this.ticket_top_conta, false)
					this.SetBoxVis(this.end_conta, true)
					this.StartEndTimer()
				}


				//按钮
				this.SetBtnState()
			}

		}

		this.SetBtnState = () => {

			if(model.stage_info.stage ==5){
				this.SetBoxVis(this.btn_group,false)
			}else{
				this.SetBoxVis(this.btn_group,true)

				let show = model.stage_info.stage == 6
				this.rankBtn.visible = show
				this.historyBtn.visible = show
				this.shopBtn.x = show ? 0 : 185
			}
		}

		this.UpdateMyRank = () => {
			if (model.rank_info_in_waiting_scene) {
				if (model.rank_info_in_waiting_scene.rank >= 0) {
					this.my_rank.text = model.rank_info_in_waiting_scene.rank
				}
			} else {
				this.my_rank.text = "未上榜"
			}
		}

		this.UpdateWaitInfo = () => {
			this.CancelTicketTimer()
			if (model.ticket_wait_info && model.stage_info) {
				this.StartTicketTimer()
				let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_kf_1vn_kv", false)//Config.Kf1vnkv
				let max = (cfg && cfg["10"] && (cfg["10"].value) || (6))
				let txt_color = (model.ticket_wait_info.left_times > 0 && ("'#00fa64'") || ("'#ff4f50'"))
				this.match_times.innerHTML = `<font color=${txt_color}>${(max - model.ticket_wait_info.left_times)}/${max}</font>`
				this.score.innerHTML = `${model.ticket_wait_info.score}积分<br>
			<font color='#ffd27a'>[${model.ticket_wait_info.win}胜</font><font color='#ff5959'>${model.ticket_wait_info.lose}负</font><font color='#ffd27a'>]</font>`
				this.tips.text = `前${model.ticket_wait_info.def_num}名玩家成为擂主人选`
			}
		}

		this.StartTicketTimer = () => {
			let time_fun = () => {
				this.OnTime()
			}
			left_time_id_ = GlobalTimerQuest.AddPeriodQuest(time_fun, 1, -1)
			time_fun()
		}

		this.OnTime = () => {
			if (model.stage_info && model.stage_info.stage == 3) {
				let left_time = model.stage_info.edtime - TimeUtil.getServerTime()
				if (left_time <= 0) {
					this.CancelTicketTimer()
					this.ticket_left_time.text = "已结束"
				} else {
					this.ticket_left_time.text = TimeUtil.timeConvert(left_time, "mm:ss")
				}
			} else {
				this.ticket_left_time.text = "已结束"
				this.CancelTicketTimer()
			}
		}

		this.CancelTicketTimer = () => {
			if (left_time_id_) {
				GlobalTimerQuest.CancelQuest(left_time_id_)
				left_time_id_ = null
			}
		}

		this.StartTopTimer = (end_time?, is_match?, show_txt?) => {
			end_time_ = end_time
			is_match_ = is_match
			let time_fun = () => {
				this.UpdateTime()
			}
			top_count_timer_ = GlobalTimerQuest.AddPeriodQuest(time_fun, 1, -1)
			time_fun()
		}

		this.UpdateTime = () => {
			if (end_time_ != null) {
				let left_time = end_time_ - TimeUtil.getServerTime()
				if (left_time <= 0) {
					this.next_time.text = "0"
					this.left_match_time.text = "0"
					this.CancelTopTimer()
				} else {
					if (!is_match_) {
						//let str = string.gsub(show_txt_, "%d", TimeUtil.timeConvert(left_time, "hh:mm:ss"), 1)
						this.next_time.text = `${TimeUtil.timeConvert(left_time, "mm:ss")}`
					} else {
						this.left_match_time.text = String(left_time)
					}
				}
			} else {
				this.CancelTopTimer()
			}
		}

		this.CancelTopTimer = () => {
			if (top_count_timer_) {
				GlobalTimerQuest.CancelQuest(top_count_timer_)
				top_count_timer_ = null
			}
		}

		this.ShowHistoryBtnDot = () => {
			let show = model.HaveQuizRewardCanGet()
			this.history_red_dot.visible = show
		}

		this.ShowShopBtnDot = () => {
			let show = model.ShopRedDot()
			this.shop_red_dot.visible = show
		}

		this.StartEndTimer = () => {
			let time_fun = () => {
				this.OnEndTime()
			}
			end_time_id_ = GlobalTimerQuest.AddPeriodQuest(time_fun, 1, -1)
			time_fun()
		}

		this.OnEndTime = () => {
			if (model.stage_info && model.stage_info.stage == 6) {
				close_time_ = close_time_ - 1
				if (close_time_ <= 0) {
					this.end_label.text = "本届1vN已结束，期待您的下次参与"
					this.CancelEndTimer()
					model.Fire(Kf1vnEvent.KF1VN_REQUEST_PROTO, 62107)
				} else {
					this.end_label.text = "本届1vN已结束，期待您的下次参与，" + close_time_ + "s后自动退出场景"
				}
			}
		}

		this.CancelEndTimer = () => {
			if (end_time_id_) {
				GlobalTimerQuest.CancelQuest(end_time_id_)
				end_time_id_ = null
			}
		}


		this.SetBoxVis = (box: Laya.Box, boo) => {
			let cell
			for (let i = 0; i < box.numChildren; i++) {
				cell = box.getChildAt(i)
				if (cell) {
					cell.visible = boo
				}
			}

		}
	}

	public DeleteMe() {
		super.DeleteMe()
	}


	gray_mask: Laya.Image
	ticket_top_conta: Laya.Box
	_Image1: Laya.Image
	ticket_label: Laya.Label
	match_tips: Laya.Label
	left_match_time: Laya.Label
	_box_turn: Laya.HBox
	_Image_txt1: Laya.Image
	_lb_turn: Laya.Label
	_Image_txt2: Laya.Image
	stage_conta: Laya.Box
	_Image4: Laya.Image
	stage_label: Laya.Label
	next_time: Laya.Label
	end_conta: Laya.Box
	end_bg: Laya.Image
	end_label: Laya.Label
	ticket_msg_conta: Laya.Box
	left_bg: Laya.Image
	_Image2_title2: Laya.Image
	_Image2_title3: Laya.Image
	_Label1: Laya.Label
	match_times: Laya.HTMLDivElement
	my_rank: Laya.Label
	tips: Laya.Label
	score: Laya.HTMLDivElement
	_Label2: Laya.Label
	_Label3: Laya.Label
	lookBtn: Laya.Box
	_Image8: Laya.Image
	_Label4: Laya.Label
	ticket_left_time: Laya.Label
	_box_exit: Laya.Box
	_btn_exit: Laya.Image
	btn_group: Laya.Box
	shopBtn: Laya.Box
	_Image9: Laya.Image
	shop_red_dot: Laya.Image
	rankBtn: Laya.Box
	_Image10: Laya.Image
	historyBtn: Laya.Box
	_Image11: Laya.Image
	history_red_dot: Laya.Image
	public GetComponents() {
		[
			this.gray_mask,
			this.ticket_top_conta,
			this._Image1,
			this.ticket_label,
			this.match_tips,
			this.left_match_time,
			this._box_turn,
			this._Image_txt1,
			this._lb_turn,
			this._Image_txt2,
			this.stage_conta,
			this._Image4,
			this.stage_label,
			this.next_time,
			this.end_conta,
			this.end_bg,
			this.end_label,
			this.ticket_msg_conta,
			this.left_bg,
			this._Image2_title2,
			this._Image2_title3,
			this._Label1,
			this.match_times,
			this.my_rank,
			this.tips,
			this.score,
			this._Label2,
			this._Label3,
			this.lookBtn,
			this._Image8,
			this._Label4,
			this.ticket_left_time,
			this._box_exit,
			this._btn_exit,
			this.btn_group,
			this.shopBtn,
			this._Image9,
			this.shop_red_dot,
			this.rankBtn,
			this._Image10,
			this.historyBtn,
			this._Image11,
			this.history_red_dot,
		]
			= this.GetChildrenByNames([

				"gray_mask",
				"ticket_top_conta",
				"_Image1",
				"ticket_label",
				"match_tips",
				"left_match_time",
				"_box_turn",
				"_Image_txt1",
				"_lb_turn",
				"_Image_txt2",
				"stage_conta",
				"_Image4",
				"stage_label",
				"next_time",
				"end_conta",
				"end_bg",
				"end_label",
				"ticket_msg_conta",
				"left_bg",
				"_Image2_title2",
				"_Image2_title3",
				"_Label1",
				"match_times",
				"my_rank",
				"tips",
				"score",
				"_Label2",
				"_Label3",
				"lookBtn",
				"_Image8",
				"_Label4",
				"ticket_left_time",
				"_box_exit",
				"_btn_exit",
				"btn_group",
				"shopBtn",
				"_Image9",
				"shop_red_dot",
				"rankBtn",
				"_Image10",
				"historyBtn",
				"_Image11",
				"history_red_dot",
			])
	}
}
window["Kf1vnWaitSceneView"] = Kf1vnWaitSceneView
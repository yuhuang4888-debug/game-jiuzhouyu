import { Alert, Alert_Type } from "../alert/Alert"
import { AutoFightManager } from "../autofight/AutoFightManager"
import { BaseView1 } from "../common/BaseView1"
import { EventName } from "../common/EventName"
import { Enum_UILayer, LayerManager } from "../common/LayerManager"
import { MainUIManager } from "../common/MainUIManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { GuildActivityModel, GuildActEvent } from "../commonModel/GuildActivityModel"
import { MainFunc, MainUIModel } from "../commonModel/MainUIModel"
import { MiniGameModel } from "../commonModel/MiniGameModel"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { SYTweenFunc } from "../util/SYTweenFunc"
import { SYTweenLite } from "../util/SYTweenLite"
import { TimeUtil } from "../util/TimeUtil"
import { Util, GlobalTimerQuest } from "../util/Util"
import { EveningAnswerRankView } from "./EveningAnswerRankView"
import { EveningFoodView } from "./EveningFoodView"

export class EveningBaseView extends BaseView1 {
	_etime
	_timer_id
	back_login_toClose
	change_scene_close
	destroy_callback
	destroy_imm
	is_center
	model: GuildActivityModel
	open_callback
	percentHeight
	percentWidth
	preload_client_config
	preload_server_config
	_foodViewItem: EveningFoodView
	_rank_item: EveningAnswerRankView
	view_list
	is_request_game_stage //是否请求过答题或消消乐界面
	is_open_stage_view  //是否已经尝试打开答题或消消乐的界面
	is_game_over = false //小游戏是否已经结束
	public constructor() {
		super()

		this.model = GuildActivityModel.GetInstance();
		this.base_file = "evening"
		this.layout_file = "EveningBaseView"
		this.layer_value = Enum_UILayer.Main
		this.destroy_imm = true
		this.destroy_child_imm = true
		//this.is_center = true
		this.back_login_toClose = true
		this.change_scene_close = true
		this.is_open_stage_view = false
		this.percentWidth = 100
		this.percentHeight = 100
		this.is_request_game_stage = false
		this.view_list = {}
		this.preload_client_config = { "ConfigGuildAct": false }
		this._foodViewItem = null
		this._rank_item = null
		this.load_callback = () => {
			this._btn_switch.visible = false
			// MainUIManager.GetInstance().AddMoveComponent(this, this._btn_exit, false, MainUIManager.MOVE_TYPE.Left)

			let type = GuildActivityModel.GetInstance().EveningGameType()
			let img_url = type == 2 ? "evening_btn_4" : "evening_btn_2"
			ResManager.GetInstance().SetImageSprite(this, this._img_icon_2, "evening", img_url)
			ResManager.GetInstance().SetImageSprite(this, this._btn_switch, "evening", img_url)

			this.LoadSuccess()

		}

		this.open_callback = () => {

		}
		this.destroy_callback = () => {
			for (let key in this.view_list) {
				this.view_list[key].DeleteMe()
				delete this.view_list[key]
			}
			if (this._foodViewItem) {
				this._foodViewItem.DeleteMe()
				this._foodViewItem = null
			}

			if (this._rank_item) {
				this._rank_item.DeleteMe()
				this._rank_item = null
			}
			MainUIManager.GetInstance().RemoveMoveComponent(this)
			this.Clear()
		}



	}

	public DeleteMe() {
		super.DeleteMe()
	}

	public Clear() {

		this.ClearTimer()
	}

	public LoadSuccess() {

		this.InitView()
		this.InitEvent()
		this.FireEvent()
	}

	public InitView() {

		this.SetTimer()
		this.OpenViewItem()
	}

	public FireEvent() {
		this.model.Fire(GuildActEvent.REQUEST_PROTO, 40211)
		this.model.Fire(GuildActEvent.REQUEST_PROTO, 40260)
	}

	public InitEvent() {

		Util.AddClickEvent(this._btn_exit, () => {
			Alert.Show("是否确定退出篝火场景？", Alert_Type.Two, () => {
				this.model.Fire(GuildActEvent.REQUEST_PROTO, 40218)
			}
			)
		}, this, true)

		Util.AddClickEvent(this._btn_switch, () => {
			if (this.is_game_over) {
				Message.show(`今天${this.model.GetEveningGameName()}已经结束了~`)
				return
			}

			if (this.model.EveningGameType() == 2) {
				if (!MiniGameModel.GetInstance().IsPlaying()) {
					Message.show("您来的太晚了，无法进行消消乐挑战~")
					return
				}
			}

			this.model.Fire(GuildActEvent.OPEN_CLOSE_SCORE_RANK_VIEW, false)
		}, this, true)


		Util.AddClickEvent(this._box_icon_1, () => {
			GlobalEventSystem.Fire(EventName.OPEN_VIEW, "EveningIntroView", 0)
		}, this, true)

		Util.AddClickEvent(this._box_icon_2, () => {
			GlobalEventSystem.Fire(EventName.OPEN_VIEW, "EveningIntroView", 1)
		}, this, true)

		Util.AddClickEvent(this._box_icon_3, () => {
			GlobalEventSystem.Fire(EventName.OPEN_VIEW, "EveningIntroView", 2)
		}, this, true)


		this.BindVar(this.model, "act_info", (event_name?, value?, old_value?) => {
			this.SetTimer(value)
			this.OpenViewItem(value)
		}
		)


		this.BindEvent(this.model, GuildActEvent.UPDATE_MINI_GAME_STATUS, (status?) => {
			if (this.is_open_stage_view) return
			if (this.model.EveningGameType() != 2) return
			this.is_game_over = status == 1 ? true : false
			if (status == 1) {
				//已结束
				this.CloseSpecialView()
				this.ShowHideRankView(true)
			} else {
				if (MiniGameModel.GetInstance().is_continue) {
					MiniGameModel.GetInstance().is_continue = false
					MiniGameModel.GetInstance().StartMiniGame()
				} else {
					if (MiniGameModel.GetInstance().IsPlaying()) {
						MiniGameModel.GetInstance().TryStartMiniGame()
					}
					else {
						MiniGameModel.GetInstance().Fire(MiniGameModel.REQUEST_CCMD_EVENT, 39901, "chc", 1, 402, 2)
					}
				}

			}
			this.is_open_stage_view = true
		})


		this.BindVar(this.model, "question_info", (event_name?, value?, old_value?) => {
			if (this.model.EveningGameType() != 1) return
			if (value) {
				if (value.status != 0) {
					if (value.no != 0) {
						let act_info = this.model.GetActInfo()
						this.CreatNewStageView(act_info)
						this.is_game_over = false
					} else {
						this.is_game_over = true
						this.CloseSpecialView()
						this.ShowHideRankView(true)
					}

				}
			} else {
				this.is_game_over = true
				this.CloseSpecialView()
				this.ShowHideRankView(false)
			}
		})


		this.BindEvent(this.model, GuildActEvent.OPEN_CLOSE_SCORE_RANK_VIEW, (bool?) => {
			this.ShowHideRankView(bool)
		})

		this.BindEvent(this.model, GuildActEvent.GAME_OVER_CLOSE, () => {
			if (this.model.EveningGameType() == 2) {
				this.CloseSpecialView()
				this.ShowHideRankView(true)
			}
		})

		this.BindEvent(MiniGameModel.GetInstance(), MiniGameModel.GAME_OVER, () => {
			//消消乐游戏结束
			if (this.model.EveningGameType() == 2) {
				// this.CloseSpecialView()
				// this.ShowHideRankView(true)
				this.is_game_over = true
			}
		})

		//进场景之前需要验证时间是否充足  监听顺序 UPDATE_MINI_GAME_STATUS》》》START_MINI_GAME
		this.BindEvent(MiniGameModel.GetInstance(), MiniGameModel.START_MINI_GAME, (game_type?) => {
			let act_info = this.model.GetActInfo()
			this.CreatNewStageView(act_info)
			this.ShowHideRankView(false)
		})
	}


	/**第4阶段 */
	private CloseSpecialView() {
		//关闭答题/消消乐界面
		if (this.view_list && this.view_list[4]) {
			this.view_list[4].DeleteMe()
			delete this.view_list[4]
		}
	}


	/**第4阶段  展示或隐藏答题排行 */
	private ShowHideRankView(show?) {
		if (!this._rank_item) {
			this._rank_item = new EveningAnswerRankView(this._group_view)
			this._rank_item.Load()
		}
		this._rank_item.SetVisible(show)
		this._btn_switch.visible = show
		let act_info =  this.model.GetActInfo()
		if (act_info && act_info.stage == 4) {
			this._btn_exit.visible = show
		}
	}



	public SetTimer(info?) {

		this.ClearTimer()
		let act_info = info || this.model.GetActInfo()
		if (!act_info || act_info.stage == 0) {
			return
		}

		if(act_info.stage==3||act_info.stage==5){
			this._etime = 0
		}else{
			this._etime = act_info.etime
		}
		
		this.SetTimeText(this._etime - TimeUtil.getServerTime())

		this._timer_id = GlobalTimerQuest.AddPeriodQuest(() => {
			this.UpdateTimer()
		}, 1, -1)
		this.UpdateTimer()
	}

	public UpdateTimer() {

		let rtime = this._etime - TimeUtil.getServerTime()
		if (rtime < 0) {
			this._lb_time_stage.text = "已结束"
			this.ClearTimer()
		} else {
			this.SetTimeText(rtime)
		}
	}

	public SetTimeText(rtime?) {
		this._lb_time_stage.text = (rtime <= 0 && ("已结束") || (TimeUtil.convertTime(rtime)))
	}

	public ClearTimer() {

		if (this._timer_id) {
			GlobalTimerQuest.CancelQuest(this._timer_id)
			this._timer_id = null
		}
	}

	public OpenViewItem(info?) {

		let act_info = info || this.model.GetActInfo()
		if (!act_info || act_info.stage == 0) {
			return
		}

		let dic = ResManager.GetInstance().GetGameConfigFromCache(this, "ConfigGuildAct", true)["evening_stage_cfg"]
		let cfg = dic[act_info.stage]
		if (!cfg) {
			return
		}
		this.model.SetMainUIViewVisible(cfg.show_icon)
		AutoFightManager.GetInstance().SetAutoFight(true)


		//1、2、3阶段要显示菜肴界面
		if (act_info.stage >= 1 && act_info.stage <= 3) {
			if (!this._foodViewItem) {
				this._foodViewItem = new EveningFoodView(this._group_view)
				this._foodViewItem.Load()
			}
		} else {
			if (this._foodViewItem) {
				this._foodViewItem.DeleteMe()
				this._foodViewItem = null
			}
		}


		//将之前的界面删除
		for (let key in this.view_list) {
			if (Number(key) < act_info.stage) {
				this.view_list[key].DeleteMe()
				delete this.view_list[key]
			}
		}

		//删除排行的界面
		if (act_info.stage != 4 && this._rank_item) {
			this._rank_item.DeleteMe()
			this._rank_item = null
		}


		//构造界面
		if (act_info.stage != 4) {
			this._btn_exit.visible = true
			this.CreatNewStageView(act_info)
			this.ShowHideRankView(false)
		} else {
			//答题/消消乐界面需要判断是否开启
			if (!this.is_request_game_stage) {
				this._btn_exit.visible = false
				this.is_request_game_stage = true
				this.is_open_stage_view = false
				if (this.model.EveningGameType() == 2) {
					//消消乐
					this.model.Fire(GuildActEvent.REQUEST_PROTO, 40221)
				} else {
					//答题
					this.model.Fire(GuildActEvent.REQUEST_PROTO, 40217)
				}
			}
		}



		//设置阶段进度
		this.SetStageShow(act_info)

	}


	public CreatNewStageView(act_info) {
		let sub_view = this.view_list[act_info.stage]
		if (!sub_view) {
			let view = this.model.GetViewByActInfo()
			if (view) {
				sub_view = new view(this._group_view)
				sub_view.Load()
				this.view_list[act_info.stage] = sub_view
			}

		}
	}


	public SetStageShow(act_info) {
		console.warn("test@act_info", act_info)
		//设置缩放
		let s_num_1 = 0.75
		let s_num_2 = 1.2
		for (let i = 1; i <= 3; i++) {
			this["_img_icon_" + i].scale(s_num_1, s_num_1)
		}

		let temp_x = 11
		if (act_info.stage <= 3) {
			//晚宴阶段
			this._img_icon_1.scale(s_num_2, s_num_2)
			temp_x = this._box_icon_1.x
		} else if (act_info.stage <= 5 && act_info.stage >= 4) {
			//答题/消消乐
			this._img_icon_2.scale(s_num_2, s_num_2)
			temp_x = this._box_icon_2.x
		} else {
			//大蛇
			this._img_icon_3.scale(s_num_2, s_num_2)
			temp_x = this._box_icon_3.x
		}


		//置灰
		this._img_arrow_1.gray = act_info.stage <= 3
		this._img_arrow_2.gray = act_info.stage <= 5
		this._img_icon_2.gray = act_info.stage <= 3
		this._img_icon_3.gray = act_info.stage <= 5
		this.lock_1.visible = act_info.stage <= 3
		this.lock_2.visible = act_info.stage <= 5

		//时间的位置
		this._lb_time_stage.x = temp_x - 2
		this._img_select.scale(s_num_2, s_num_2)
		this._img_select.x = temp_x + 38
	}


	_img_bg: Laya.Image
	_group_view: Laya.Box
	_btn_exit: Laya.Image
	_btn_switch: Laya.Image
	_box_stage: Laya.Box
	_img_select: Laya.Image
	_img_arrow_1: Laya.Image
	_img_arrow_2: Laya.Image
	_box_icon_1: Laya.Box
	_img_icon_1: Laya.Image
	_box_icon_2: Laya.Box
	_img_icon_2: Laya.Image
	lock_1: Laya.Image
	_box_icon_3: Laya.Box
	_img_icon_3: Laya.Image
	lock_2: Laya.Image
	_lb_time_stage: Laya.Label
	public GetComponents() {
		[
			this._img_bg,
			this._group_view,
			this._btn_exit,
			this._btn_switch,
			this._box_stage,
			this._img_select,
			this._img_arrow_1,
			this._img_arrow_2,
			this._box_icon_1,
			this._img_icon_1,
			this._box_icon_2,
			this._img_icon_2,
			this.lock_1,
			this._box_icon_3,
			this._img_icon_3,
			this.lock_2,
			this._lb_time_stage,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_group_view",
				"_btn_exit",
				"_btn_switch",
				"_box_stage",
				"_img_select",
				"_img_arrow_1",
				"_img_arrow_2",
				"_box_icon_1",
				"_img_icon_1",
				"_box_icon_2",
				"_img_icon_2",
				"lock_1",
				"_box_icon_3",
				"_img_icon_3",
				"lock_2",
				"_lb_time_stage",
			])
	}
}
window["EveningBaseView"] = EveningBaseView
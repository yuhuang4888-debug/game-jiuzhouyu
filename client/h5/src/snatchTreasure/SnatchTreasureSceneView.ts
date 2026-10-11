import { AutoFightManager } from "../autofight/AutoFightManager"
import { BaseView1 } from "../common/BaseView1"
import { EventName, SceneEventType } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { MainUIManager } from "../common/MainUIManager"
import { ResManager } from "../common/ResManager"
import { BossModel } from "../commonModel/BossModel"
import { GuildEvent, GuildModel } from "../commonModel/GuildModel"
import { MainUIModel } from "../commonModel/MainUIModel"
import { SnatchTreasureModel } from "../commonModel/SnatchTreasureModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { SYTweenLite } from "../util/SYTweenLite"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest, SetAnchoredPositionX, Util } from "../util/Util"
import { STreasureSceneRankItem } from "./STreasureSceneRankItem"

export class SnatchTreasureSceneView extends BaseView1 {
	_exit: Laya.Image
	_gp_rank: Laya.Box
	_Image1: Laya.Image
	_Image2: Laya.Image
	_Image3: Laya.Image
	_lb_round: Laya.Label
	_lb_monster_num: Laya.Label
	_Label1: Laya.Label
	Content: Laya.List
	_Group1: Laya.Box
	_Label2: Laya.Label
	_lb_myrank: Laya.Label
	_lb_myhurt: Laya.Label
	_gp_check_rank: Laya.Box
	_Image4: Laya.Image
	_Label3: Laya.Label
	_gp_count_down: Laya.Box
	_Image5: Laya.Image
	_Group2: Laya.HBox
	_Label4: Laya.Label
	_lb_count_down: Laya.Label
	_gp_bm: Laya.HBox
	_bm_time: Laya.Label
	_Image6: Laya.Image
	_bm_round: Laya.Label
	_Image7: Laya.Image
	Canvas
	InitEvent
	LoadSuccess
	_rank_scroller
	back_login_toClose
	changeRound
	close_callback
	delayTimer
	destroy_imm
	form
	initMyHurt
	initRank
	initTimer
	loop_mgr
	onTimer
	percentHeight
	percentWidth
	removeTimer

	public constructor() {
		super()

		this.base_file = "snatchTreasure"
		this.layout_file = "SnatchTreasureSceneView"
		this.layer_value = Enum_UILayer.Main
		//this.percentWidth = 100
		//this.percentHeight = 100
		this.destroy_imm = true
		this.back_login_toClose = true
		let _arraycollection = null
		let timer = null
		let count_down_time = 0
		let round_time = -2
		let _first = true
		let _model = SnatchTreasureModel.GetInstance()
		let local_AutoFightManager = AutoFightManager.GetInstance()
		let local_MainUIModel = MainUIModel.GetInstance()
		let _MainUIModel = MainUIModel
		let local_SceneEventType = SceneEventType
		let local_SnatchTreasureModel = SnatchTreasureModel
		let local_BossBaseModel = BossModel.GetInstance()
		//let local_Tween = Laya.Tween
		let local_Util = Util
		this.load_callback = () => {
			// this.form.anchoredPosition = Vector2(0, 0)
			// this.form.sizeDelta = Vector2(0,0)
			MainUIManager.GetInstance().AddMoveComponent(this, this._gp_count_down, false, MainUIManager.MOVE_TYPE.Stay)
			MainUIManager.GetInstance().AddMoveComponent(this, this._exit, false, MainUIManager.MOVE_TYPE.Left)
			//MainUIManager.GetInstance().AddMoveComponent(this, this._gp_bm, false, MainUIManager.MOVE_TYPE.Stay)
			MainUIManager.GetInstance().AddMoveComponent(this, this._gp_rank, false, MainUIManager.MOVE_TYPE.Left)
			//ResManager.GetInstance().SetOutsideImageSprite(this, this._Image1, GameResPath.GetIcon("snatchTreasure", "uizxgj_001"), true)
			this.InitEvent()
			this.LoadSuccess()
		}

		this.close_callback = () => {
			this.removeTimer()
			_model.clean()
			local_AutoFightManager.SetAutoFight(true)
			_first = true
			_model.canAuto = true
			if (this.loop_mgr) {
				this.loop_mgr.DeleteMe()
				this.loop_mgr = null
			}
			if (this.delayTimer) {
				clearTimeout(this.delayTimer)
				this.delayTimer = null
			}
			local_MainUIModel.Fire(_MainUIModel.CHANGE_ACTIVITY_STATE, true)
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._gp_check_rank, () => {
				GuildModel.GetInstance().Fire(GuildEvent.OPEN_VIEW, "SnatchTreasureRankView")
			}
				, this)
			Util.AddClickEvent(this._exit, () => {
				_model.Fire(local_SnatchTreasureModel.SCMD_REQUEST, 65206)
			}
				, this, true)
			this.BindEvent(_model, local_SnatchTreasureModel.CHANGE_HURT_RANK, () => {
				this.initRank()
			}
			)
			this.BindEvent(_model, local_SnatchTreasureModel.CHANGE_SELF_HURT, () => {
				this.initMyHurt()
			}
			)
			//this:BindEvent(GlobalEventSystem, local_SceneEventType.MAIN_ROLE_MOVE_END,() => {
			//if (! _model.haveMon() && round_time <= 0 ) {
			//_model:checkAutoFight()
			//}else{
			//local_AutoFightManager:SetAutoFight(true)
			//}
			//}
			//)
			//let onObjDeadHandler = (obj?) => {
			//if (obj && obj.obj_type == SceneBaseType.Monster ) {
			//if (! _model.haveMon() ) {
			//local_AutoFightManager:SetAutoFight(false)
			//}
			//}
			//}

			//this:BindEvent(GlobalEventSystem, local_SceneEventType.CHARACTER_DEAD, onObjDeadHandler)
			this.BindEvent(GlobalEventSystem, local_SceneEventType.PICK_UP_END, () => {
				if ((!_model.haveMon() && round_time != null) && round_time <= 0) {
					_model.AutoFight()
				} else {
					local_AutoFightManager.SetAutoFight(true)
				}
			}
			)
			this.BindEvent(local_BossBaseModel, BossModel.GOODS_HAVE_PICKING, () => {
				if ((!_model.haveMon() && round_time != null) && round_time <= 0) {
					_model.AutoFight()
				} else {
					local_AutoFightManager.SetAutoFight(true)
				}
			}
			)
			this.BindEvent(_model, local_SnatchTreasureModel.CHANGE_ROUND, () => {
				this.changeRound()
			}
			)
			this.BindEvent(local_MainUIModel, _MainUIModel.UPDATE_ACTIVITY_STATE, (bool?) => {
				if (bool && this._gp_bm.visible) {
					MainUIManager.GetInstance().RemoveMoveOneComponent(this, this._gp_bm)
					this._gp_bm.visible = false
					
				} else if (!bool && round_time > 0) {
					MainUIManager.GetInstance().AddMoveComponent(this, this._gp_bm, false, MainUIManager.MOVE_TYPE.Stay)
					this._gp_bm.visible = true
					
				}
			}
			)
			this.BindEvent(local_MainUIModel, _MainUIModel.UPDATE_ACTIVITY_STATE, (bool?) => {
				// if (bool) {
				// 	SYTweenLite.to(this, this.Canvas, SYTweenLite.UiAnimationType.ALPHA, 0, _MainUIModel.Move_Time_Interval)
				// 	SYTweenLite.to(this, this._gp_rank, SYTweenLite.UiAnimationType.ANCHORED_POSX, -245, _MainUIModel.Move_Time_Interval)
				// 	SYTweenLite.to(this, this._exit, SYTweenLite.UiAnimationType.ANCHORED_POSX, -67, _MainUIModel.Move_Time_Interval)
				// 	//local_Tween:get(this._gp_rank):to({left=-this._gp_rank.width, alpha=0}, _MainUIModel.Move_Time_Interval)
				// 	//local_Tween:get(this._exit):to({left=-this._exit.width, alpha=0}, _MainUIModel.Move_Time_Interval)
				// 	//local_Tween:get(this._gp_bm):to({alpha=0}, _MainUIModel.Move_Time_Interval)
				// 	//local_Tween:get(this._gp_count_down):to({alpha=0}, _MainUIModel.Move_Time_Interval)
				// } else {
				// 	SYTweenLite.to(this, this.Canvas, SYTweenLite.UiAnimationType.ALPHA, 1, _MainUIModel.Move_Time_Interval)
				// 	SYTweenLite.to(this, this._gp_rank, SYTweenLite.UiAnimationType.ANCHORED_POSX, 0, _MainUIModel.Move_Time_Interval)
				// 	SYTweenLite.to(this, this._exit, SYTweenLite.UiAnimationType.ANCHORED_POSX, 9, _MainUIModel.Move_Time_Interval)
				// 	//local_Tween:get(this._gp_rank):to({left=0, alpha=1}, _MainUIModel.Move_Time_Interval)
				// 	//local_Tween:get(this._exit):to({left=9, alpha=1}, _MainUIModel.Move_Time_Interval)
				// 	//local_Tween:get(this._gp_bm):to({alpha=1}, _MainUIModel.Move_Time_Interval)
				// 	//local_Tween:get(this._gp_count_down):to({alpha=1}, _MainUIModel.Move_Time_Interval)
				// }
			}
			)

			let auto_fight = (bool?) => {
				if (this.delayTimer) {
					clearTimeout(this.delayTimer)
					this.delayTimer = null
				}
				if (local_AutoFightManager.GetAutoFightState()) {
					if (!local_AutoFightManager.GetTempMode()) {
						if (!_model.haveMon() && round_time && round_time <= 0 && round_time != -2) {
							_model.AutoFight()
						}
					}
				} else {
					this.delayTimer = setTimeout(() => {
						local_AutoFightManager.SetAutoFight(true)
					}, 5000)
				}
			}
			this.BindEvent(GlobalEventSystem, EventName.UPDATE_AUTO_FIGHT_STATE, auto_fight)
		}

		this.LoadSuccess = () => {
			local_MainUIModel.Fire(_MainUIModel.CHANGE_ACTIVITY_STATE, false)
			// let state = local_MainUIModel.activity_icon_in_show
			// if (state) {
			// 	//this._gp_count_down.alpha = 0
			// 	//this._gp_bm.alpha = this._gp_count_down.alpha
			// 	//this._exit.alpha = this._gp_bm.alpha
			// 	//this._gp_rank.alpha = this._exit.alpha
			// 	this.Canvas.alpha = 0
			// 	SetAnchoredPositionX(this._exit, -67)
			// 	SetAnchoredPositionX(this._gp_rank, -245)

			// } else {
			// 	//this._gp_count_down.alpha = 1
			// 	//this._gp_bm.alpha = this._gp_count_down.alpha
			// 	//this._exit.alpha = this._gp_bm.alpha
			// 	//this._gp_rank.alpha = this._exit.alpha
			// 	this.Canvas.alpha = 1
			// 	SetAnchoredPositionX(this._gp_rank, 0)
			// 	SetAnchoredPositionX(this._exit, 9)
			// }
			local_AutoFightManager.SetAutoFight(false)
			this.initRank()
			this.initMyHurt()
			this.initTimer()
			this.changeRound()
		}

		this.initRank = () => {
			let data = _model.HurtListData()
			if (!this.loop_mgr) {
				this.loop_mgr = new LoopScrowViewMgr()
				this.loop_mgr.SetData(this.Content, STreasureSceneRankItem, data, LoopScrCon.Vertical)
			} else {
				this.loop_mgr.replaceAll(data)
			}
			let all = _model._allWave
			this._lb_round.text = "当前波数:" + _model._wave + "/" + all
			this._lb_monster_num.text = "剩余怪物:" + _model._mon_num
		}

		this.initMyHurt = () => {
			let data = _model._thisHurtData
			if (data && data.self_rank != 0) {
				this._lb_myrank.text = data.self_rank
				this._lb_myhurt.text = _model.SetValue(data.self_damage)
			} else {
				this._lb_myrank.text = "暂未上榜"
				this._lb_myhurt.text = "0"
			}
		}

		this.initTimer = () => {
			if (!timer) {
				//timer = Laya. new Timer(1000, 0)
				//timer:addEventListener(Laya.TimerEvent.TIMER, this.onTimer, this)
				timer = GlobalTimerQuest.AddPeriodQuest(() => {
					this.onTimer()
				}, 1, -1)
				count_down_time = _model.endtime - TimeUtil.getServerTime()
			}
		}

		this.onTimer = () => {
			this._lb_count_down.text = TimeUtil.timeConvert(count_down_time, "mm:ss")
			if (count_down_time <= 0) {
				this.removeTimer()
				_model.Fire(local_SnatchTreasureModel.SCMD_REQUEST, 65206)
			}
			if (round_time >= 0) {
				this._bm_time.text = String(round_time)
				round_time = round_time - 1
				if (round_time < 0) {
					MainUIManager.GetInstance().RemoveMoveOneComponent(this, this._gp_bm)
					this._gp_bm.visible = false
					
					_model.canAuto = true
					if (_model.haveMon()) {
						local_AutoFightManager.SetAutoFight(true)
					} else if (!local_BossBaseModel.auto_pick_up) {
						_model.AutoFight()
					}
				}
			}
			count_down_time = count_down_time - 1
		}

		this.removeTimer = () => {
			if (timer) {
				GlobalTimerQuest.CancelQuest(timer)
				timer = null
				count_down_time = 0
				round_time = 0
			}
		}

		this.changeRound = () => {
			let time = _model._roundTime - TimeUtil.getServerTime()
			if (time >= 0) {
				local_MainUIModel.Fire(_MainUIModel.CHANGE_ACTIVITY_STATE, false)
				this._bm_round.text = _model._wave
				round_time = time
				this._bm_time.text = String(round_time)
				MainUIManager.GetInstance().AddMoveComponent(this, this._gp_bm, false, MainUIManager.MOVE_TYPE.Stay)
				this._gp_bm.visible = true
				
				//if (! _model.haveMon() ) {
				//local_AutoFightManager:SetAutoFight(false)
				//}
				//_model.canAuto = false
			} else if (_first) {
				_first = false
				_model.checkAutoFight()
			}
		}


	}




	public GetComponents() {
		[
			this._exit,
			this._gp_rank,
			this._Image1,
			this._Image2,
			this._Image3,
			this._lb_round,
			this._lb_monster_num,
			this._Label1,
			this.Content,
			this._Group1,
			this._Label2,
			this._lb_myrank,
			this._lb_myhurt,
			this._gp_check_rank,
			this._Image4,
			this._Label3,
			this._gp_count_down,
			this._Image5,
			this._Group2,
			this._Label4,
			this._lb_count_down,
			this._gp_bm,
			this._bm_time,
			this._Image6,
			this._bm_round,
			this._Image7,
		]
			= this.GetChildrenByNames([

				"_exit",
				"_gp_rank",
				"_Image1",
				"_Image2",
				"_Image3",
				"_lb_round",
				"_lb_monster_num",
				"_Label1",
				"Content",
				"_Group1",
				"_Label2",
				"_lb_myrank",
				"_lb_myhurt",
				"_gp_check_rank",
				"_Image4",
				"_Label3",
				"_gp_count_down",
				"_Image5",
				"_Group2",
				"_Label4",
				"_lb_count_down",
				"_gp_bm",
				"_bm_time",
				"_Image6",
				"_bm_round",
				"_Image7",
			])
	}
}
window["SnatchTreasureSceneView"] = SnatchTreasureSceneView
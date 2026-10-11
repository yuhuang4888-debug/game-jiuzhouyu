import { AutoFightManager } from "../autofight/AutoFightManager"
import { BaseView1 } from "../common/BaseView1"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { MainUIManager } from "../common/MainUIManager"
import { ResManager } from "../common/ResManager"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { GoodsModel } from "../commonModel/GoodsModel"
import { MainUIModel } from "../commonModel/MainUIModel"
import { NoonPartyModel, NoonPEvent } from "../commonModel/NoonPartyModel"
import { SceneManager } from "../scene/SceneManager"
import { ColorUtil } from "../util/ColorUtil"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { SYTweenLite } from "../util/SYTweenLite"
import { TimeUtil } from "../util/TimeUtil"
import { GetSizeDeltaX, GlobalTimerQuest, SetAnchoredPositionX, Util } from "../util/Util"

export class NoonPartySceneView extends BaseView1 {
	leftPanel: Laya.Box
	_Image1: Laya.Image
	_Image2: Laya.Image
	instructionBtn: Laya.Image
	box1: Laya.Image
	box2: Laya.Image
	img1: Laya.Image
	img2: Laya.Image
	timeLb: Laya.Label
	_Label1: Laya.Label
	_Label2: Laya.Label
	expLb: Laya.Label
	nomalBoxLb: Laya.Label
	rareBoxLb: Laya.Label
	nomalName: Laya.HTMLDivElement
	rareName: Laya.HTMLDivElement
	bossGp: Laya.Box
	_Image3: Laya.Image
	_Image4: Laya.Image
	reliveLb: Laya.Label
	exitBtn: Laya.Image
	CancelBossTimer
	CancelEndTimer
	EndFunc
	InitView
	SetBossTimer
	SetBoxInfo
	SetEndTimer
	SetExpInfo
	StartBossTimer
	StartEndTimer
	TimerFunc

	public constructor() {
		super()


		this.base_file = "noonParty"
		this.layout_file = "NoonPartySceneView"
		let model = NoonPartyModel.GetInstance()
		let local_NoonPEvent = NoonPEvent
		let local_Util = Util
		let mainUI_model = MainUIModel.GetInstance()
		let local_MainUIModel = MainUIModel
		let local_laya = Laya
		let scene_mgr = SceneManager.GetInstance()
		let auto_fight_mgr = AutoFightManager.GetInstance()

		let ui_tool_tip_model = UIToolTipMgr.GetInstance()
		let goods_model = GoodsModel.GetInstance()
		let local_TimeUtil = TimeUtil
		let local_GoodsModel = GoodsModel
		let _panelOffset = 1
		let _exitOffset = 10
		let _reliveTime = null
		let _bossTimer = null
		let _endTime = null
		let _endTimer = null
		let _delay_id = null
		let _boxBack = null
		this.layer_value = Enum_UILayer.Main
		this.destroy_imm = true
		this.back_login_toClose = true
		this.preload_server_config = {
			"config_midday_party_key_value": false
		}
		this.load_callback = () => {
			// this.form.anchoredPosition = Vector2(0, 0)
			// this.form.sizeDelta = Vector2(0, 0)

			// if (PlatformMgr.GetInstance().IsEyouIdnPlatform()) {
			// 	SetAnchoredPositionX(this.expLb, 69)
			// 	this.nomalName.size = 18
			// 	this.rareName.size = 18
			// 	this.expLb.size = 18
			// }
			// this.leftPanel = this.leftPanel.GetComponent("CanvasGroup")
			// this.exitBtn = this.exitBtn.GetComponent("CanvasGroup")
			//ResManager.GetInstance().SetOutsideImageSprite(this, this._Image3, GameResPath.GetIcon("noonParty", "uigh_040"), true)
			//MainUIManager.GetInstance().AddMoveComponent(this, this.bossGp, false, MainUIManager.MOVE_TYPE.Stay)
			
			this.InitView()
		}

		this.close_callback = () => {
			this.CancelBossTimer()
			this.CancelEndTimer()
			clearTimeout(_delay_id)
			_delay_id = null
		}

		this.InitView = () => {
			this.BindEvent(model, local_NoonPEvent.UPDATE_BOX, () => {
				this.SetBoxInfo()
			}
			)
			Util.AddClickEvent(this.instructionBtn, () => {
				GlobalEventSystem.Fire(EventName.OPEN_INSTRUCTION_VIEW, 285)
			}
				, this, true)
			this.BindEvent(model, local_NoonPEvent.UPDATE_EXP, () => {
				this.SetExpInfo()
			}
			)
			this.BindEvent(model, local_NoonPEvent.BOSS_RELIVE_TIME, (time?) => {
				this.SetBossTimer(time)
			}
			)
			this.BindEvent(model, local_NoonPEvent.UPDATE_END_TIME, (time?) => {
				this.SetEndTimer(time)
			}
			)
			Util.AddClickEvent(this.exitBtn, () => {
				model.Fire(local_NoonPEvent.REQUEST_PROTO, 28502)
			}
				, this, true)

			model.Fire(local_NoonPEvent.REQUEST_PROTO, 28503)
			model.Fire(local_NoonPEvent.REQUEST_PROTO, 28504)
			model.Fire(local_NoonPEvent.REQUEST_PROTO, 28505)
			model.Fire(local_NoonPEvent.REQUEST_PROTO, 28506)

			let Paneloffset = -_panelOffset - GetSizeDeltaX(this.leftPanel)
			let ExitOffset = -_exitOffset - GetSizeDeltaX(this.exitBtn)
			this.BindEvent(mainUI_model, local_MainUIModel.UPDATE_ACTIVITY_STATE, (bool?) => {
				if (bool) {
					SYTweenLite.to(this, this.leftPanel, SYTweenLite.UiAnimationType.ALPHA, 0, local_MainUIModel.Move_Time_Interval)
					SYTweenLite.to(this, this.leftPanel, SYTweenLite.UiAnimationType.ANCHORED_POSX, Paneloffset, local_MainUIModel.Move_Time_Interval)

					SYTweenLite.to(this, this.exitBtn, SYTweenLite.UiAnimationType.ALPHA, 0, local_MainUIModel.Move_Time_Interval)
					SYTweenLite.to(this, this.exitBtn, SYTweenLite.UiAnimationType.ANCHORED_POSX, ExitOffset, local_MainUIModel.Move_Time_Interval)

				} else {
					//local_laya.Tween.get(this.leftPanel).to({left=_panelOffset, alpha=1}, local_MainUIModel.Move_Time_Interval)
					//local_laya.Tween.get(this.exitBtn).to({left=_exitOffset, alpha=1}, local_MainUIModel.Move_Time_Interval)

					SYTweenLite.to(this, this.leftPanel, SYTweenLite.UiAnimationType.ALPHA, 1, local_MainUIModel.Move_Time_Interval)
					SYTweenLite.to(this, this.leftPanel, SYTweenLite.UiAnimationType.ANCHORED_POSX, _panelOffset, local_MainUIModel.Move_Time_Interval)

					SYTweenLite.to(this, this.exitBtn, SYTweenLite.UiAnimationType.ALPHA, 1, local_MainUIModel.Move_Time_Interval)
					SYTweenLite.to(this, this.exitBtn, SYTweenLite.UiAnimationType.ANCHORED_POSX, _exitOffset, local_MainUIModel.Move_Time_Interval)

				}
			}
			)
			let state = mainUI_model.activity_icon_in_show
			if (state) {
				this.exitBtn.alpha = 0
				this.leftPanel.alpha = 0
				SetAnchoredPositionX(this.leftPanel, Paneloffset)
				SetAnchoredPositionX(this.exitBtn, ExitOffset)
			} else {
				this.exitBtn.alpha = 1
				this.leftPanel.alpha = 1
				SetAnchoredPositionX(this.leftPanel, _panelOffset)
				SetAnchoredPositionX(this.exitBtn, _exitOffset)
			}
			let main_role_move_end = () => {
				if (_delay_id) {
					clearTimeout(_delay_id)
					_delay_id = null
				}
				if (scene_mgr.main_role_last_enter_stand_time) {
					let delay_fun = () => {
						if (scene_mgr.IsNoonPartyScene()) {
							auto_fight_mgr.SetAutoFight(true)
						}
					}

					_delay_id = setTimeout(delay_fun, 5)
				}
			}

			scene_mgr.BindOne("main_role_last_enter_stand_time", main_role_move_end)
			// [ts2lua]lua_resM:GetGameConfigFromCache(this, "config_midday_party_key_value", false)下标访问可能不正确
			let kv = ResManager.GetInstance().GetGameConfigFromCache(this, "config_midday_party_key_value", false)
			let nomGoodsId = Number(JSON.parse(kv[13].value)[0][1])
			// [ts2lua]lua_resM:GetGameConfigFromCache(this, "config_midday_party_key_value", false)下标访问可能不正确
			let rareGoodsId = Number(JSON.parse(kv[14].value)[0][1])
			Util.AddClickEvent(this.img1, () => {
				ui_tool_tip_model.AppendGoodsTips(nomGoodsId)
			}
				, this, true)
			Util.AddClickEvent(this.img2, () => {
				ui_tool_tip_model.AppendGoodsTips(rareGoodsId)
			}
				, this, true)
			this.nomalName.style.fontSize = 20
			this.nomalName.style.valign = "center"
			this.nomalName.style.color = "#f5c8b2"
			this.nomalName.width = 200

			this.rareName.style.fontSize = 20
			this.rareName.style.valign = "center"
			this.rareName.style.color = "#db99f7"
			this.rareName.width = 200

			this.nomalName.innerHTML = Util.StrToHTML(local_GoodsModel.GetGoodsNameWithColorLight(nomGoodsId))
			this.rareName.innerHTML = Util.StrToHTML(local_GoodsModel.GetGoodsNameWithColorLight(rareGoodsId))
			let goods_basic1 = goods_model.GetGoodsBasicByTypeId(nomGoodsId)
			if (goods_basic1) {
				ResManager.GetInstance().SetOutsideImageSprite(this, this.img1, GameResPath.GetGoodsIconPath(goods_basic1.goods_icon))
			}
			let goods_basic2 = goods_model.GetGoodsBasicByTypeId(rareGoodsId)
			if (goods_basic1) {
				ResManager.GetInstance().SetOutsideImageSprite(this, this.img2, GameResPath.GetGoodsIconPath(goods_basic2.goods_icon))
			}
			auto_fight_mgr.SetAutoFight(true)
		}

		this.SetBoxInfo = () => {
			if (model.box_info) {
				let kv = ResManager.GetInstance().GetGameConfigFromCache(this, "config_midday_party_key_value", false)
				let max = kv[5].value
				if (model.box_info.low_box >= max) {
					this.nomalBoxLb.color = ColorUtil.TryParseHtmlString("#ff4f50")
				}
				this.nomalBoxLb.text = model.box_info.low_box + "/" + max

				max = kv[6].value
				if (model.box_info.high_box >= max) {
					this.rareBoxLb.color = ColorUtil.TryParseHtmlString("#ff4f50")
				}
				this.rareBoxLb.text = model.box_info.high_box + "/" + max
			}
		}

		this.SetExpInfo = () => {
			this.expLb.text = model.ExpInfo
		}

		this.SetBossTimer = (time?) => {
			this.CancelBossTimer()
			_reliveTime = time
			this.StartBossTimer()
		}

		this.CancelBossTimer = () => {
			if (_bossTimer) {
				GlobalTimerQuest.CancelQuest(_bossTimer)
				_bossTimer = null
			}
		}

		this.StartBossTimer = () => {
			_bossTimer = GlobalTimerQuest.AddPeriodQuest(() => {
				this.TimerFunc()
			}, 1, -1)
		}

		this.TimerFunc = () => {
			if (_reliveTime > local_TimeUtil.getServerTime()) {
				MainUIManager.GetInstance().AddMoveComponent(this, this.bossGp, false, MainUIManager.MOVE_TYPE.Stay)
				this.bossGp.visible = true
				this.reliveLb.text = String(_reliveTime - local_TimeUtil.getServerTime())
			} else {
				MainUIManager.GetInstance().RemoveMoveOneComponent(this, this.bossGp)
				this.bossGp.visible = false
				this.CancelBossTimer()
			}
		}

		this.SetEndTimer = (time?) => {
			this.CancelEndTimer()
			_endTime = time
			this.StartEndTimer()
		}

		this.CancelEndTimer = () => {
			if (_endTimer) {
				GlobalTimerQuest.CancelQuest(_endTimer)
				_endTimer = null
			}
		}

		this.StartEndTimer = () => {
			_endTimer = GlobalTimerQuest.AddPeriodQuest(() => {
				this.EndFunc()
			}, 1, -1)
		}

		this.EndFunc = () => {
			this.timeLb.text = local_TimeUtil.timeConvert8(_endTime - local_TimeUtil.getServerTime())
		}
	}



	public GetComponents() {
		[
			this.leftPanel,
			this._Image1,
			this._Image2,
			this.instructionBtn,
			this.box1,
			this.box2,
			this.img1,
			this.img2,
			this.timeLb,
			this._Label1,
			this._Label2,
			this.expLb,
			this.nomalBoxLb,
			this.rareBoxLb,
			this.nomalName,
			this.rareName,
			this.bossGp,
			this._Image3,
			this._Image4,
			this.reliveLb,
			this.exitBtn,
		]
			= this.GetChildrenByNames([

				"leftPanel",
				"_Image1",
				"_Image2",
				"instructionBtn",
				"box1",
				"box2",
				"img1",
				"img2",
				"timeLb",
				"_Label1",
				"_Label2",
				"expLb",
				"nomalBoxLb",
				"rareBoxLb",
				"nomalName",
				"rareName",
				"bossGp",
				"_Image3",
				"_Image4",
				"reliveLb",
				"exitBtn",
			])
			ResManager.GetInstance().LoadFont(this, "SjjjFnt", this.reliveLb, null, false)
	}
}
window["NoonPartySceneView"] = NoonPartySceneView
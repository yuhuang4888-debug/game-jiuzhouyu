import { AutoFightManager } from "../autofight/AutoFightManager"
import { BaseItem1 } from "../common/BaseItem1"
import { EventName } from "../common/EventName"
import { MainUIManager } from "../common/MainUIManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { WordManager } from "../common/WordManager"
import { BaseDungeonModel } from "../commonModel/BaseDungeonModel"
import { FirstRechargeModel } from "../commonModel/FirstRechargeModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { GuardModel } from "../commonModel/GuardModel"
import { MainUIModel } from "../commonModel/MainUIModel"
import { StoryModel } from "../commonModel/StoryModel"
import { PlatformManager } from "../PlatformManager"
import { SceneManager } from "../scene/SceneManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { SYTweenFunc } from "../util/SYTweenFunc"
import { SYTweenLite } from "../util/SYTweenLite"
import { GlobalTimerQuest, Util } from "../util/Util"
import { DungeonExpEnterView } from "./DungeonExpEnterView"
import { DungeonExpUseExpView } from "./DungeonExpUseExpView"

import "./DungeonExpInspriteView"
import "./DungeonExpUseExpView"
import { ViewPopLevelModel } from "../commonModel/ViewPopLevelModel"

export class DungeonExpFightSceneItem extends BaseItem1 {

	public static GUIDE_STATE = { INSPRITE: 1, INSPRITE_DONE: 2, USE_EXP: 3, DONE: 4 }


	efficiency_ani = []
	inspire_ani = []
	show_detail = false

	base_model: BaseDungeonModel
	guard_model: GuardModel
	goods_model: GoodsModel
	auto_fight_mgr: AutoFightManager
	mainUI_model: MainUIModel
	story_model: StoryModel
	scene_mgr: SceneManager
	mainui_mgr: MainUIManager
	recharge_model: FirstRechargeModel

	have_exp_buff = false
	finger_finish = false
	check_auto_fight_timer = null
	guide_state = false
	coin_switch = 0
	diamond_switch = 0
	set_time_out_id = null
	time_id_list = []
	now_insprite_num = 0

	period_timer
	period_timer1


	public constructor(parent?) {
		super(parent)

		this.base_file = "dungeonExp"
		this.layout_file = "DungeonExpFightSceneItem"
		this.efficiency_ani = []
		this.inspire_ani = []
		this.show_detail = false


		this.base_model = BaseDungeonModel.GetInstance()
		this.guard_model = GuardModel.GetInstance()
		this.goods_model = GoodsModel.GetInstance()
		this.auto_fight_mgr = AutoFightManager.GetInstance()
		this.mainUI_model = MainUIModel.GetInstance()
		this.story_model = StoryModel.GetInstance()
		this.scene_mgr = SceneManager.GetInstance()
		this.mainui_mgr = MainUIManager.GetInstance()
		this.recharge_model = FirstRechargeModel.GetInstance()

		this.preload_server_config = {
			"config_goods_effect": false
		}

		this.load_callback = () => {
			
			this.LoadSuccess()
		}
	}


	LoadSuccess() {

		this.display_obj.left = this.display_obj.right = this.display_obj.top = this.display_obj.bottom = 0

		this.mainui_mgr.AddMoveComponent(this, this._box_inspire, false, MainUIManager.MOVE_TYPE.Right)
		this.mainui_mgr.AddMoveComponent(this, this._box_efficiency, false, MainUIManager.MOVE_TYPE.Right)
		this.mainui_mgr.AddMoveComponent(this, this._box_guard, false, MainUIManager.MOVE_TYPE.Right)
		this.mainui_mgr.AddMoveComponent(this, this._box_recharge, false, MainUIManager.MOVE_TYPE.Left)


		this._box_exp_msg_con.visible = false

		this.period_timer = GlobalTimerQuest.AddPeriodQuest(() => {
			// if (this.efficiency_ani && this.efficiency_ani.length > 0) {
			// 	for (let i = 0; i < this.efficiency_ani.length; i++) {
			// 		var v = this.efficiency_ani[i]
			// 		SYTweenLite.Stop(v)
			// 	}
			// 	this.efficiency_ani = []
			// }
			// table.insert(this.efficiency_ani, SYTweenLite.to(this, this._img_efficiency, SYTweenLite.UiAnimationType.ROTATION, 30, 0.3, () => {
			// 	table.insert(this.efficiency_ani, SYTweenLite.to(this, this._img_efficiency, SYTweenLite.UiAnimationType.ROTATION, -30, 0.3, () => {

			// 		table.insert(this.efficiency_ani, SYTweenLite.to(this, this._img_efficiency, SYTweenLite.UiAnimationType.ROTATION, 360, 0.3, null, SYTweenFunc.LINEAR, false))

			// 	}, SYTweenFunc.LINEAR, false))
			// }, SYTweenFunc.LINEAR, false))

		}, 2.5, -1)

		this.period_timer1 = GlobalTimerQuest.AddPeriodQuest(() => {
			// if (this.inspire_ani && this.inspire_ani.length > 0) {
			// 	for (let i = 0; i < this.inspire_ani.length; i++) {
			// 		var v = this.inspire_ani[i]
			// 		SYTweenLite.Stop(v)
			// 	}
			// 	this.inspire_ani = []
			// }
			// table.insert(this.inspire_ani, SYTweenLite.to(this, this._img_inspire, SYTweenLite.UiAnimationType.ROTATION, 30, 0.3, () => {
			// 	table.insert(this.inspire_ani, SYTweenLite.to(this, this._img_inspire, SYTweenLite.UiAnimationType.ROTATION, -30, 0.3, () => {

			// 		table.insert(this.inspire_ani, SYTweenLite.to(this, this._img_inspire, SYTweenLite.UiAnimationType.ROTATION, 360, 0.3, null, SYTweenFunc.LINEAR, false))

			// 	}, SYTweenFunc.LINEAR, false))
			// }, SYTweenFunc.LINEAR, false))

		}, 2.5, -1)

		this.base_model.Fire(BaseDungeonModel.SCMD_REQUEST, 61026)
		let dun_id = this.scene_mgr.GetCurrDunId()
		let info = this.base_model.DunSetInfo(dun_id)
		if (info) {
			this.coin_switch = info[4] && info[4].is_open
			this.diamond_switch = info[2] && info[2].is_open
		}
		this.UpdateExpBuff()
		Util.AddClickEvent(this._box_inspire, () => {
			this.ClearFinger()
			GlobalEventSystem.Fire(EventName.OPEN_VIEW, "DungeonExpInspriteView", this.guide_state)
			if (this.period_timer1) {
				GlobalTimerQuest.CancelQuest(this.period_timer1)
				this.period_timer1 = null
			}
			if (this.inspire_ani && this.inspire_ani.length > 0) {
				for (let i = 0; i < this.inspire_ani.length; i++) {
					var v = this.inspire_ani[i]
					SYTweenLite.Stop(v)
				}
				this.inspire_ani = []
			}
			this._img_inspire.rotation = 0

			// if ((((!this.coin_switch || this.coin_switch == 0) && (!this.diamond_switch || this.diamond_switch == 0)) && !this.have_exp_buff) && !this.finger_finish) {
			// 	//this.base_model:Fire(BaseDungeonModel.EXP_GUIDE_STATE_CHANGE, DungeonExpFightSceneItem.GUIDE_STATE.USE_EXP)
			// } else {
			// 	this.base_model.Fire(BaseDungeonModel.EXP_GUIDE_STATE_CHANGE, DungeonExpFightSceneItem.GUIDE_STATE.DONE)
			// }
		}
			, this, true)
		Util.AddClickEvent(this._box_efficiency, () => {
			this.ClearFinger()
			let guide = this.guide_state
			//this.base_model.Fire(BaseDungeonModel.EXP_GUIDE_STATE_CHANGE, DungeonExpFightSceneItem.GUIDE_STATE.USE_EXP)
			GlobalEventSystem.Fire(EventName.OPEN_VIEW, "DungeonExpUseExpView", guide)
			if (this.period_timer) {
				GlobalTimerQuest.CancelQuest(this.period_timer)
				this.period_timer = null
			}
			if (this.efficiency_ani && this.efficiency_ani.length > 0) {
				for (let i = 0; i < this.efficiency_ani.length; i++) {
					var v = this.efficiency_ani[i]
					SYTweenLite.Stop(v)
				}
				this.efficiency_ani = []
			}
			this._img_efficiency.rotation = 0
			//this._img_efficiency.rotation = 0
			
		}, this, true)

		Util.AddClickEvent(this._box_guard, () => {
			let [type1, type2] = this.guard_model.GetGuardActiveType()
			type1 = type1 == null && 1 || type1
			this.guard_model.Fire(GuardModel.OPEN_VIEW, type1)
		}, this, true)

		Util.AddClickEvent(this._img_recharge, () => {
			// this.recharge_model.Fire(FirstRechargeModel.OPEN_FIRST_RECHARGE_VIEW);
			ViewPopLevelModel.GetInstance().SetViewPop('FirstRechargeView');
		}, this, true)

		this.BindVar(this.base_model, "exp_dun_info", (event_name?, value?) => {
			this.UpdateView()
		})

		this.BindEvent(this.base_model, BaseDungeonModel.UPDATE_INSPRITE_INFO, () => {
			this.UpdateInsprite()
		})

		this.BindEvent(this.goods_model, GoodsModel.UPDATE_GOODS_BUFF_DATA, () => {
			this.UpdateExpBuff()
		})

		this.BindVar(this.base_model, "dungeon_scene_msg", (event_name?, vo?) => {
			this.UpdateWaveNum()
		})

		this.BindEvent(this.base_model, BaseDungeonModel.NEXT_WAVE_TIME_INFO, (wave_num?, left_time?) => {
			this.UpdateWaveNum(wave_num)
		})

		this.BindEvent(this.base_model, BaseDungeonModel.EXP_GUIDE_STATE_CHANGE, (state?) => {
			let info = this.base_model.GetInspireInfo()
			if(info){
				let total_count = info.coin_count + info.gold_count
				if (total_count == 0 && state == DungeonExpFightSceneItem.GUIDE_STATE.DONE)
					state = DungeonExpFightSceneItem.GUIDE_STATE.INSPRITE
				if (((this.coin_switch && this.coin_switch != 0) || (this.diamond_switch && this.diamond_switch != 0)) && this.have_exp_buff)
					state = DungeonExpFightSceneItem.GUIDE_STATE.DONE
				if (this.guide_state) {
					this.ShowGuide(state)
				}
			}
		})

		this.BindEvent(this.base_model, BaseDungeonModel.SHOW_MESSAGE_INSPRITE, () => {
			if ((!this.coin_switch || this.coin_switch == 0) && (!this.diamond_switch || this.diamond_switch == 0) && !this.finger_finish) {
				this.base_model.Fire(BaseDungeonModel.EXP_GUIDE_STATE_CHANGE, DungeonExpFightSceneItem.GUIDE_STATE.USE_EXP)
			} else {
				this.base_model.Fire(BaseDungeonModel.EXP_GUIDE_STATE_CHANGE, DungeonExpFightSceneItem.GUIDE_STATE.DONE)
			}
		})

		this.BindEvent(this.recharge_model, FirstRechargeModel.UPDATE_FIRST_RECHARGE_VIEW, () => {
			this.ShowRechargeImage()
		})

		this.BindEvent(this.base_model, BaseDungeonModel.SHOW_EXP_DETAIL, () => {
			if (this.show_detail) { return }
			this._box_exp_msg_con.visible = true
			this.mainui_mgr.AddMoveComponent(this, this._box_exp_msg_con, false, MainUIManager.MOVE_TYPE.Right)
			this.show_detail = true
		})

		this.UpdateWaveNum()
		this.InitMoveState()
		this.ShowGuardImage()
		this.ShowRechargeImage()


		let open_guard_view = !DungeonExpEnterView.From_Enter_View
		let try_func = () => {
			open_guard_view = true
			this.guard_model.Fire(GuardModel.OPEN_VIEW)
		}
		this.BindEvent(this.guard_model, GuardModel.UPDATA_VIEW, () => {
			if (!this.ShowGuardImage() && !open_guard_view) {
				try_func()
			}
		})

		if (DungeonExpEnterView.From_Enter_View) {
			DungeonExpEnterView.From_Enter_View = false
			if (!this.ShowGuardImage() && this.guard_model.info) {
				try_func()
			}

			if (this.set_time_out_id) {
				clearTimeout(this.set_time_out_id)
				this.set_time_out_id = null
			}
			this.set_time_out_id = setTimeout(() => {
				if (this.use_delete_method) { return }
				if (!this.have_exp_buff) { //((this.coin_switch && this.coin_switch != 0) || (this.diamond_switch && this.diamond_switch != 0)) && 
					this.ShowGuide(DungeonExpFightSceneItem.GUIDE_STATE.USE_EXP)
				} else if (((this.coin_switch && this.coin_switch != 0) || (this.diamond_switch && this.diamond_switch != 0)) && this.have_exp_buff) {
					this.ShowGuide(DungeonExpFightSceneItem.GUIDE_STATE.DONE)
				} else {
					this.ShowGuide(DungeonExpFightSceneItem.GUIDE_STATE.INSPRITE)
				}
			}, 500)
		}
		this.StartCheckAutoFightState()
	}

	StartCheckAutoFightState() {
		let OnTime = () => {
			if (!this.auto_fight_mgr.GetAutoFightState()) {
				this.auto_fight_mgr.SetAutoFight(true)
			}
		}
		this.check_auto_fight_timer = GlobalTimerQuest.AddPeriodQuest(OnTime, 5)
	}

	CacelCheckAutoFightState() {
		if (this.check_auto_fight_timer) {
			GlobalTimerQuest.CancelQuest(this.check_auto_fight_timer)
		}
	}


	RemoveMoveState() {
		this.mainui_mgr.RemoveMoveComponent(this)

		if (this.set_time_out_id) {
			clearTimeout(this.set_time_out_id)
			this.set_time_out_id = null
		}
		if (this.time_id_list && this.time_id_list.length > 0) {
			for (let _ in this.time_id_list) {
				var v = this.time_id_list[_]
				if (v) {
					clearTimeout(v)
					v = null
				}

			}
		}
	}

	InitMoveState() {

	}

	ShowGuide(state?) {
		this.guide_state = state
		if (DungeonExpFightSceneItem.GUIDE_STATE.INSPRITE == state) {
			GlobalEventSystem.Fire(EventName.HIDE_FINGER, this._img_efficiency)
			GlobalEventSystem.Fire(EventName.SHOW_FINGER, this, this._img_inspire, this.layer_value, false, false, false, true, { text: "赶紧鼓舞获得攻击加成吧!", direction: 6, "effect_scaleX": 0.4, "effect_scaleY": 1 }, true)
		} else if (DungeonExpFightSceneItem.GUIDE_STATE.INSPRITE_DONE == state) {
			this.ClearFinger()
		} else if (DungeonExpFightSceneItem.GUIDE_STATE.USE_EXP == state) {
			GlobalEventSystem.Fire(EventName.HIDE_FINGER, this._img_inspire)
			GlobalEventSystem.Fire(EventName.SHOW_FINGER, this, this._img_efficiency, this.layer_value, false, false, false, true, { text: "不用经验符的人都亏哭了!", direction: 6, "effect_scaleX": 0.4, "effect_scaleY": 1 }, true)
		} else if (DungeonExpFightSceneItem.GUIDE_STATE.DONE == state) {
			this.finger_finish = true
			this.ClearFinger()
		}
	}

	ClearFinger() {
		GlobalEventSystem.Fire(EventName.HIDE_FINGER, this._img_inspire)
		GlobalEventSystem.Fire(EventName.HIDE_FINGER, this._img_efficiency)
	}

	UpdateView() {
		let info = this.base_model.GetExpDungeonInfo()
		if (info) {
			this._lb_kill_mon_count.text = String(info.kill_num)
			this._lb_get_exp_count.text = this.ConvertNum(info.exp)
		}
	}

	ConvertNum(num?) {
		num = Number(num)
		if (num <= 9999) {
			return num
		} else if (num >= 10000 && num < 100000000) {
			//return (num / 10000):toFixed(2) + "万"
			return WordManager.FormatNumber2(num, true, true)
		} else if (num >= 100000000 && num < 1000000000000) {
			let left = num % 100000000
			if (PlatformManager.IsEyouIdnPlatform()) {
				return Math.floor(num / 100000000) + "00Jt " + Math.floor(left / 10000) + "0K"
			} else {
				return Math.floor(num / 100000000) + "亿" + Math.floor(left / 10000) + "万"
			}

		} else {
			//return (num / 1000000000000):toFixed(2) + "万亿"
			//return (value / 10000):toFixed(1) + "万"
			return WordManager.FormatNumber2(num, true, true)
		}
	}

	UpdateExpBuff() {
		let GetBuffData = (goods_id?) => {
			let cfgs = ResManager.GetInstance().GetGameConfigFromCache(this, "config_goods_effect", false)
			if (cfgs && cfgs[goods_id]) {
				let tbl = JSON.parse(cfgs[goods_id].effect_list)
				if (tbl[0][0] == "exp_mon") {
					return Number(tbl[0][1])
				}
			}
		}

		let num = 0
		for (let _tmpi in this.goods_model.goods_buff_list) {
			var v = this.goods_model.goods_buff_list[_tmpi]
			if (v.time > 0) {
				for (let _tmpi in DungeonExpUseExpView.goods_list) {
					var goods_id = DungeonExpUseExpView.goods_list[_tmpi]
					if (v.goods_id == goods_id) {
						num = GetBuffData(v.goods_id)
					}
				}
			}
		}
		this._lb_efficiency.text = "经验+" + num * 100 + "%"
		this.have_exp_buff = num > 0
	}

	UpdateInsprite() {
		let info = this.base_model.GetInspireInfo()
		let dun_id = this.scene_mgr.GetCurrDunId()
		let total_count = info.coin_count + info.gold_count
		let num = total_count
		if (dun_id == BaseDungeonModel.GUILD_EXP_ID) {
			total_count = total_count * 5
		} else {
			total_count = total_count * 10
		}
		this._lb_inspire.text = "伤害+" + total_count + "%"
		if (this.now_insprite_num < num) {
			for (let i = 1; i <= num - this.now_insprite_num; i++) {
				let id = setTimeout(() => {
					if (this.use_delete_method) { return }
					this.ClearUIEffect(this._effect_inspire)
					// this.AddUIEffect("ui_dungeon_inspire", this._effect_inspire, null, null, false)
				}, 0.2 * (i - 1))
				table.insert(this.time_id_list, id)
			}

		}

		this.now_insprite_num = num
	}


	UpdateWaveNum(wave_num?) {
		if (!wave_num) {
			let info = this.base_model.GetDungeonSceneMsg()
			wave_num = info && info.wave_num
		}
		if (!wave_num) {
			wave_num = 0
		}
		if (wave_num > BaseDungeonModel.EXP_WAVE_COUNT) {
			wave_num = BaseDungeonModel.EXP_WAVE_COUNT
		}
		this._lb_wave_num.text = wave_num + "/" + BaseDungeonModel.EXP_WAVE_COUNT
	}

	ShowGuardImage() {
		let bool = false
		let open = this.guard_model.OpenStatus()
		if (!open) {
			this._box_guard.visible = false
			return
		}
		this._box_guard.visible = true
		let [type1, type2] = this.guard_model.GetGuardActiveType()
		bool = type1 != null
		Util.SetImageGray(this._img_guard, !bool)
		this._lb_guard.visible = bool
		if (bool) {
			this._lb_guard.text = (type1 == 1 && ("经验+50%") || ("经验+50%\n增伤+5%"))
			let res = type1 == 1 && "guard1_1" || "guard3_1"
			if (type1 == 1) {
				this._img_guard.pos(3, 2)
				this._img_guard.width = 75
				this._img_guard.height = 79
			} else {
				this._img_guard.pos(-3, 9)
				this._img_guard.width = 90
				this._img_guard.height = 71
			}
			ResManager.GetInstance().SetImageSprite(this, this._img_guard, "dungeonExp_asset", res)
			//lua_resM:SetOutsideImageSprite(this, this._img_guard, "client/assets/icon/dungeonExp/guard" + type1 + "_1.png")
		} else {
			this._img_guard.pos(3, 2)
			this._img_guard.width = 75
			this._img_guard.height = 79
			ResManager.GetInstance().SetImageSprite(this, this._img_guard, "dungeonExp_asset", "guard1_1")
			this._lb_guard.text = ""
		}
		return bool
	}

	//是否显示首充
	ShowRechargeImage() {
		if (this.recharge_model.is_bubble) {
			return
		}

		let show_bool = false
		let get_bool = false
		let red_bool = false
		let text_bool = false
		if (this.recharge_model.IsDoneAllReward()) {
			//已领取全部奖励
			show_bool = false
		} else {
			if (this.recharge_model.first_recharge_info) {
				show_bool = true

				let reward_list = this.recharge_model.first_recharge_info.reward_list
				if (reward_list) {

					for (let _tmpi in reward_list) {
						var vo = reward_list[_tmpi]
						if (vo.open == 1) {
							get_bool = true
						} else if (vo.open == 2) {
							text_bool = true
						}
					}

					if (get_bool) {
						text_bool = false
					}

					let no_recharge = this.recharge_model.IsNoFirstRecharge() && this.recharge_model.loginfirst
					if (no_recharge == null) {
						no_recharge = false
					}
					red_bool = get_bool || no_recharge
				}
			}
		}

		this._img_recharge.visible = show_bool
		this._img_red_recharge.visible = red_bool
		this._lb_recharge.visible = text_bool

	}


	public DeleteMe() {

		if (this._box_exp_msg_con) {
			//local_laya.Tween.removeTweens(this._box_exp_msg_con)
			//this:StopTween()
			this.ClearFinger()
		}
		this.CacelCheckAutoFightState()
		this.RemoveAni()
		this.RemoveMoveState()
		this.now_insprite_num = 0
		this.ClearUIEffect(this._effect_inspire)
		this.show_detail = false
		super.DeleteMe()
	}

	RemoveAni() {

		if (this.period_timer) {
			GlobalTimerQuest.CancelQuest(this.period_timer)
			this.period_timer = null
		}
		if (this.period_timer1) {
			GlobalTimerQuest.CancelQuest(this.period_timer1)
			this.period_timer1 = null
		}
		if (this.efficiency_ani && this.efficiency_ani.length > 0) {
			for (let i = 0; i < this.efficiency_ani.length; i++) {
				var v = this.efficiency_ani[i]
				SYTweenLite.Stop(v)
			}
			this.efficiency_ani = []
		}
		if (this.inspire_ani && this.inspire_ani.length > 0) {
			for (let i = 0; i < this.inspire_ani.length; i++) {
				var v = this.inspire_ani[i]
				SYTweenLite.Stop(v)
			}
			this.inspire_ani = []
		}


	}


	_box_exp_msg_con: Laya.Box
	_img_exp_msg_bg: Laya.Image
	_img_bg4: Laya.Image
	_lb_title: Laya.Label
	_img_bg: Laya.Image
	_lb_title2: Laya.Label
	_lb_wave_num: Laya.Label
	_img_bg2: Laya.Image
	_lb_title3: Laya.Label
	_lb_kill_mon_count: Laya.Label
	_img_bg3: Laya.Image
	_lb_title4: Laya.Label
	_lb_get_exp_count: Laya.Label
	_box_guard: Laya.Box
	_img_guard: Laya.Image
	_lb_guard: Laya.Label
	_box_inspire: Laya.Box
	_effect_inspire: Laya.Box
	_img_inspire: Laya.Image
	_lb_inspire: Laya.Label
	_box_efficiency: Laya.Box
	_img_efficiency: Laya.Image
	_lb_efficiency: Laya.Label
	_box_recharge: Laya.Box
	_img_recharge: Laya.Image
	_img_red_recharge: Laya.Image
	_lb_recharge: Laya.Label
	public GetComponents() {
		[
			this._box_exp_msg_con,
			this._img_exp_msg_bg,
			this._img_bg4,
			this._lb_title,
			this._img_bg,
			this._lb_title2,
			this._lb_wave_num,
			this._img_bg2,
			this._lb_title3,
			this._lb_kill_mon_count,
			this._img_bg3,
			this._lb_title4,
			this._lb_get_exp_count,
			this._box_guard,
			this._img_guard,
			this._lb_guard,
			this._box_inspire,
			this._effect_inspire,
			this._img_inspire,
			this._lb_inspire,
			this._box_efficiency,
			this._img_efficiency,
			this._lb_efficiency,
			this._box_recharge,
			this._img_recharge,
			this._img_red_recharge,
			this._lb_recharge,
		]
			= this.GetChildrenByNames([

				"_box_exp_msg_con",
				"_img_exp_msg_bg",
				"_img_bg4",
				"_lb_title",
				"_img_bg",
				"_lb_title2",
				"_lb_wave_num",
				"_img_bg2",
				"_lb_title3",
				"_lb_kill_mon_count",
				"_img_bg3",
				"_lb_title4",
				"_lb_get_exp_count",
				"_box_guard",
				"_img_guard",
				"_lb_guard",
				"_box_inspire",
				"_effect_inspire",
				"_img_inspire",
				"_lb_inspire",
				"_box_efficiency",
				"_img_efficiency",
				"_lb_efficiency",
				"_box_recharge",
				"_img_recharge",
				"_img_red_recharge",
				"_lb_recharge",
			])
	}
}

window["DungeonExpFightSceneItem"] = DungeonExpFightSceneItem

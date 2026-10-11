import { Alert, Alert_Type } from "../alert/Alert"
import { BaseItem1 } from "../common/BaseItem1"
import { EventName } from "../common/EventName"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { BossModel } from "../commonModel/BossModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { RoleManager } from "../commonModel/RoleManager"
import { VipModel } from "../commonModel/VipModel"
import { SceneBaseType } from "../scene/SceneConfig"
import { Message } from "../sysInfo/SysInfoController"
import { Enum_ColorUtil_Light, Enum_ColorUtil_Dark, ColorUtil } from "../util/ColorUtil"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { SetSizeDeltaX, SetAnchoredPosition, Util, HtmlColorTxt, GlobalTimerQuest, MakeListCenter } from "../util/Util"
import { BossDomainItem } from "./BossDomainItem"
import { BossDomainRewardItem } from "./BossDomainRewardItem"
import { Config } from "../common/Config"
import { UI_MODEL_TYPE } from "../common/UIModelClass3D"
import { ErlangParser } from "../util/ErlangParser"
import { StageShowView } from "../customActivity/StageShowView"
import "../bossDomain/BossDomainStageShow"
import { BossDomainStageShow } from "../bossDomain/BossDomainStageShow"

export class BossDomainView extends BaseItem1 {
	CustomMehod
	InitEvent
	LoadSuccess
	ReOpen_callback
	SetCheckBox
	ShowModel
	UpdateProgress
	UpdateRemindState
	action_name_list
	boss_type
	icon
	initItem
	initRequestTimer
	itemTouchHandler
	loop_mgr: LoopScrowViewMgr
	mask
	offset
	onTime
	removeTimer
	ui_scale
	updateReward
	updateTimes
	updateView
	cur_model
	item_list
	box_reward
	_stage_show

	public constructor(parent?) {
		super(parent)
		this.base_file = "bossdomain"
		this.layout_file = "BossDomainView"

		let _model = BossModel.GetInstance()
		let _help = false
		let checkSelect = false
		let _canChallenge = true
		let _fullLevel = true
		let _fullEquip = true
		let show_model = null
		let _select_index = 0
		let _select_boss_id = 0
		let special_boss_id = 0
		let requestTimer = null
		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName
		let local_Message = Message
		let local_Math = Math
		let local_BossModel = BossModel
		let local_Config = Config
		let role_mgr = RoleManager.GetInstance()
		let goods_model = GoodsModel.GetInstance()
		let vip_model = VipModel.GetInstance()
		let local_Enum_ColorUtil_Light = Enum_ColorUtil_Light
		this.boss_type = BossModel.BossType.domainserver
		let is_frist = false
		let scale = 25
		let pos = { x: 0, y: 0 }

		this.load_callback = () => {
			this.AddUIEffect("ZengJia", this._box_time_effect, pos, scale, true)
			ResManager.GetInstance().LoadFont(this, "fighting_font", this._bm_fight, undefined, false)
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_g53, GameResPath.GetIcon("bossdomain", "uihyb_027"))
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_g54, GameResPath.GetIcon("bossdomain", "uihyb_027"))
			this.cur_model = ""
			this.InitEvent()
			this.LoadSuccess()

		}

		this.ReOpen_callback = () => {
			if (this.icon) {
				this.ShowModel(this.icon, this.ui_scale, this.offset, this.action_name_list)
				this.AddUIEffect("ZengJia", this._box_time_effect, pos, scale, true)
			}
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._img_add, () => {
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "BossDomainBuyView")
			}
				, this, true)
			Util.AddClickEvent(this._btn, () => {
				if (!_canChallenge) {
					local_Message.show("灵饰评分不足")
					return
				}
				if (!_fullLevel) {
					local_Message.show("等级不足")
					return
				}
				if (!_fullEquip) {
					local_Message.show("当前星座圣衣套装件数不足")
					return
				}
				let cfg = Config.PRELOAD_SERVER_CONFIG.config_decoration_boss
				let bestBossCfg = _model.DomainBossId(cfg, _select_boss_id)
				let cancel = () => {
					_select_index = bestBossCfg.index - 1
					_canChallenge = true
					_fullLevel = true
					_fullEquip = true
					if (this.loop_mgr) {
						this.loop_mgr.FirstOnChild(_select_index)
						this.loop_mgr.SetSelectIndex(_select_index, false)
					}
					this.updateView()
				}

				let go = () => {
					_model.doMainSelectBossId = _select_boss_id
					_model.Fire(local_BossModel.SCMD_REQUEST, 47102, _select_boss_id, _help && 2 || 1)
				}

				if (bestBossCfg && !_model.do_main_sel_alert) {
					let bossVo = local_Config.GetConfigVo(local_Config.ConfigHasDefaultValue.config_mon.name, bestBossCfg.boss_id, false)
					let typeStr = bestBossCfg.boss_type == 1 && "(争夺)" || "(共享)"

					let con2 = HtmlColorTxt(`${bossVo.lv}级${bossVo.name}${typeStr}`, Enum_ColorUtil_Dark.GREEN)
					let con = `当前有更高级BOSS-${con2}可挑战<br>挑战成功可获得更高收益`
					Alert.Show(con, Alert_Type.AlertTypeCheckBox2, go, cancel, "坚持进入", "挑战高阶", null, false, (bool?) => {
						_model.do_main_sel_alert = bool
					}, "本次登录不再提示")
				} else {
					go()
				}
			}
				, this, true)

			Util.AddClickEvent(this._btn_drop, () => {
				_model.Fire(local_BossModel.OPEN_DROP_RECORD_VIEW, local_BossModel.BossType.domain)
			}
				, this, true)
			Util.AddClickEvent(this._gp_check_touch, () => {
				if (!_model.domain_alert && !_help) {
					local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "BossDomainHelpAlert")
					return
				}
				if (_model.domain_alert && !_help) {
					this.SetCheckBox(true)
				} else if (_help) {
					this.SetCheckBox(false)
				}
				_help = checkSelect
			}
				, this)
			this.BindEvent(_model, local_BossModel.DOMAINBOSS_DATA_RETUEN, () => {
				this.initItem()
			}
			)
			this.BindEvent(_model, local_BossModel.DOMAINBOSS_LIKE_RETURN, (boss_id?) => {
				if (boss_id == _select_boss_id || !boss_id) {
					this.UpdateRemindState()
				}
			}
			)
			Util.AddClickEvent(this.attention, () => {
				let select = _model.GetDomainBossRemind(_select_boss_id)
				let state = !select && 1 || 0
				_model.Fire(local_BossModel.SCMD_REQUEST, 47106, _select_boss_id, state)
			}, this)

			Util.AddClickEvent(this._img_btn, () => {
				if (!this.box_reward) return
				if (!this._stage_show) {
					this._stage_show = new BossDomainStageShow()
				}

				if (this.box_reward[0] && this.box_reward[0][1]) {
					this._stage_show.Open(this.box_reward, this._box_btn, BossDomainStageShow.ShowArrow.UP, this.display_obj.x)
				}
			}, this, true)

			this.BindEvent(_model, local_BossModel.DOMAINBOSS_BUY_TIME_RETURN, () => {
				this.updateTimes()
			}
			)
			//AddClickEvent(this._btn_go,() => {
			//_model:Fire(local_BossModel.SCMD_REQUEST, 47110)
			//}
			//, this, true)
			this.BindEvent(_model, local_BossModel.DOMAINBOSS_SELECT_CHECKBOX, () => {
				this.SetCheckBox(true)
				_help = checkSelect
			}
			)
			this.BindEvent(role_mgr.GetMainRoleVo(), local_EventName.CHANGE_LEVEL, (level?) => {
				this.initItem()
			}
			)
		}

		this.CustomMehod = (index?, args?) => {
			if ((args && args[0]) && Number(args[0]) > 1) {
				_select_boss_id = Number(args[0])
			}
		}

		this.LoadSuccess = () => {
			this.initRequestTimer()
			this.onTime()
		}

		this.initRequestTimer = () => {
			if (!requestTimer) {
				requestTimer = GlobalTimerQuest.AddPeriodQuest(this.onTime, 10)
			}
			this.onTime()
		}

		this.onTime = () => {
			_model.Fire(local_BossModel.SCMD_REQUEST, 47101)
		}

		this.removeTimer = () => {
			if (requestTimer) {
				GlobalTimerQuest.CancelQuest(requestTimer)
				requestTimer = null
			}
		}

		this.initItem = () => {
			let cfg = Config.PRELOAD_SERVER_CONFIG.config_decoration_boss
			let [list, index] = _model.DomainBossList(cfg, _select_boss_id)
			let dataList = list
			_select_index = Number(index)

			if (!this.loop_mgr) {
				this.loop_mgr = new LoopScrowViewMgr()
				this.loop_mgr.SetData(this.Content1, BossDomainItem, dataList, LoopScrCon.Vertical, 1, this.itemTouchHandler, _select_index)
				let select_boss_id = dataList[_select_index] && dataList[_select_index].boss_id
				let boss_cfg = cfg[select_boss_id]
				let lv = role_mgr.GetMainRoleVo().level
				let need_sorce = 0
				let need_lv = 0
				let need_eq_type = 0
				let need_eq_num = 0
				if (boss_cfg) {
					let condition = JSON.parse(boss_cfg.condition)
					for (let key in condition) {

						let element = condition[key]
						if (element[0] == "lv") {
							need_lv = Number(element[1])
						} else if (element[0] == "decoration_rating") {
							need_sorce = Number(element[1])
						} else if (element[0] == "constellation_suit") {
							need_eq_type = Number(element[1])
							need_eq_num = Number(element[2])
						}
					}
				}
				let sorce = 0
				let list = goods_model.wear_unreal_dic
				for (let key in list) {

					let vo = list[key]
					if (vo) {
						sorce = sorce + vo.overall_rating
					}
				}
				if (need_eq_type > 0 && need_eq_num > 0) {
					let num = GoodsModel.GetInstance().GetStarEquipPageNum(need_eq_type, true)
					_fullEquip = num >= need_eq_num
				}
				_canChallenge = sorce >= need_sorce
				_fullLevel = lv >= need_lv
			} else {
				this.loop_mgr.replaceAll(dataList)
				this.loop_mgr.SetSelectIndex(_select_index, false)
			}

			if (!is_frist) {
				this.Content1.scrollTo(_select_index)
				is_frist = true
			}
			this.updateView()
			this.updateTimes()
			//this:UpdateProgress()
		}

		this.itemTouchHandler = (index?) => {
			if (index == _select_index) {
				this.loop_mgr.SetSelectIndex(_select_index, false)
				return
			}
			_select_index = index
			let item: BossDomainItem = this.Content1.getCell(index) as BossDomainItem
			_canChallenge = item.canChallenge()
			_fullLevel = item.fullLevel()
			_fullEquip = item.fullEquip()
			this.updateView()
		}

		this.updateView = () => {

			let data = _model.do_main_data && _model.do_main_data.boss_list[_select_index] || null
			if (data) {
				_select_boss_id = data.boss_id
				let bossVo = local_Config.GetConfigVo(local_Config.ConfigHasDefaultValue.config_mon.name, _select_boss_id, false)
				if (bossVo) {
					this._lb_boss_name.text = `LV.${bossVo.lv}  ${bossVo.name}`
					this.icon = bossVo.icon
					let modelCfg = Config.PRELOAD_CLIENT_CONFIG.ClientDomainBoss
					let _modelCfg = modelCfg[bossVo.id]
					this.offset = _modelCfg && _modelCfg.offset || { x: 0, y: 0 }
					this.ui_scale = _modelCfg && _modelCfg.scale || 1
					let action_name_list = ["attack", "idle"]
					this.action_name_list = action_name_list
					this.ShowModel(this.icon, this.ui_scale, this.offset, this.action_name_list)
					//LayoutRebuilder(this._Group2)
				}
				this.updateReward()
				this.UpdateRemindState()
			}
			this._gp_attention.visible = _fullLevel && _canChallenge && _fullEquip
			let sorce = 0
			let list = goods_model.wear_unreal_dic
			for (let key in list) {

				let vo = list[key]
				if (vo) {
					sorce = sorce + vo.overall_rating
				}
			}
			this._bm_fight.text = String(sorce)
		}

		this.ShowModel = (mon_res?, ui_scale?, offset?, action_name_list?) => {

			if (mon_res == this.cur_model) return
			this.cur_model = mon_res

			let data = {
				clothe_res_id: mon_res,
				type: UI_MODEL_TYPE.MONSTER,
				layer_value: this.layer_value,
				scale: 0.6 * ui_scale,
				position: offset,
				action_name_list: action_name_list,
			}
			ResManager.GetInstance().SetRoleModel(this, this._gp_model_con, data)
		}

		this.updateReward = () => {
			let config = Config.PRELOAD_CLIENT_CONFIG.ClientDomainBoss
			let bestBossCfg = Config.PRELOAD_SERVER_CONFIG.config_decoration_boss
			let reward = config[_select_boss_id]
			let boss_cfg = bestBossCfg[_select_boss_id]
			if (reward && boss_cfg) {

				let is_show_box = boss_cfg.boss_type == 1 //是否展示争夺宝箱


				let list = ErlangParser.GetInstance().parse(reward.reward)
				this.box_reward = null
				if (is_show_box) {
					this.box_reward = list.shift()
				}
				if (!this.item_list) {
					this.item_list = new LoopScrowViewMgr()
					this.item_list.SetData(this.Content, BossDomainRewardItem, list, LoopScrCon.Horizontal)
				} else {
					this.item_list.replaceAll(list)
				}


				//布局
				this._box_btn.visible = is_show_box
				if (is_show_box) {
					this.Content.x = 162
					this._bg_2.x = 148
					MakeListCenter(this.Content, 5, 162, 98)
				} else {
					this.Content.x = 104
					this._bg_2.x = 90
					MakeListCenter(this.Content, 5, 104, 98)
				}

				this.Content.scrollTo(0)
			}
		}

		this.updateTimes = () => {
			let vip_card = vip_model.GetNobleCardState()
			let vip_flag = role_mgr.GetMainRoleVo().vip_flag
			let go_times = vip_model.GetVipPrivilegeValue(local_BossModel.DOMAIN_MODULE_ID, 1, vip_card, vip_flag) + _model.do_main_data.buy_count + _model.do_main_data.add_count
			let count = go_times - _model.do_main_data.count
			this._lb_time.text = count + "/" + go_times
			//this._lb_time.color = ColorUtil.TryParseHtmlString(count > 0 && local_Enum_ColorUtil_Light.GREEN || local_Enum_ColorUtil_Light.RED)
			let help_times = vip_model.GetVipPrivilegeValue(local_BossModel.DOMAIN_MODULE_ID, 2, vip_card, vip_flag)
			let help = help_times - _model.do_main_data.assist_count
			this._lb_help.text = help + "/" + help_times
			this._lb_help.color = ColorUtil.TryParseHtmlString(help > 0 && local_Enum_ColorUtil_Light.GREEN || local_Enum_ColorUtil_Light.RED)
			let value = vip_model.GetVipPrivilegeValue(local_BossModel.DOMAIN_MODULE_ID, 3, vip_card, vip_flag)
			let buy_count = _model.do_main_data.buy_count
			let left_num = "0"
			let cost = 0
			let kv_cfg = Config.PRELOAD_SERVER_CONFIG.config_decoration_boss_kv
			if (kv_cfg[10] && kv_cfg[10].value != "[]") {
				cost = JSON.parse(kv_cfg[10].value)[0][2]
			}
			left_num = String(local_Math.max(0, value - buy_count))
			if (Number(left_num) > 0) {
				//this.AddUIEffect("UI_2102", this.addEffectGp, null, null, true)
			} else {
				//this.ClearUIEffect(this.addEffectGp)
			}
		}

		this.UpdateRemindState = () => {
			let select = _model.GetDomainBossRemind(_select_boss_id)
			let res = select && "ui_26_2" || "ui_26"
			ResManager.GetInstance().SetImageSprite(this, this.attention, "common4", res)
		}

		this.SetCheckBox = (bool?) => {
			let res = bool && "com_ui_gx" || "com_ui_gx1"
			ResManager.GetInstance().SetImageSprite(this, this._gp_check_touch, "common_asset", res)
			checkSelect = bool
		}

	}


	public DeleteMe() {
		this.ClearUIEffect(this._box_time_effect)

		if (this._stage_show) {
			this._stage_show.DeleteMe()
			this._stage_show = null
		}

		this.removeTimer()
		if (this.loop_mgr) {
			this.loop_mgr.DeleteMe()
			this.loop_mgr = null
		}

		if (this.item_list) {
			this.item_list.DeleteMe()
			this.item_list = null
		}
		ResManager.GetInstance().ClearRoleMode(this.hashCode)
		super.DeleteMe()
	}



	_bg_1: Laya.Image
	_bg_2: Laya.Image
	_box_btn: Laya.Box
	_img_btn: Laya.Image
	_Group_title: Laya.Box
	_img_jiejie_b: Laya.Image
	_txt_title1: Laya.Text
	_gp_model_con: Laya.Box
	_gp_attention: Laya.Box
	_img_a: Laya.Image
	attention: Laya.Image
	_lb_attention: Laya.Label
	_Group2: Laya.Box
	_img_b: Laya.Image
	_lb_boss_name: Laya.Label
	_Group5: Laya.Box
	_img_g53: Laya.Image
	_img_g54: Laya.Image
	_img_g51: Laya.Image
	_img_g52: Laya.Image
	_Image5: Laya.Image
	_bm_fight: Laya.Label
	Content1: Laya.List
	Content: Laya.List
	_Label1: Laya.Label
	_lb_time: Laya.Label
	_Label2: Laya.Label
	_lb_help: Laya.Label
	_Group4: Laya.Box
	_Label3: Laya.Label
	_gp_check_touch: Laya.Image
_img_add:Laya.Image
_box_time_effect:Laya.Box
	_btn: Laya.Box
	_Image1: Laya.Image
	labelDisplay: Laya.Label
	_btn_drop: Laya.Image
	public GetComponents() {
		[
			this._bg_1,
			this._bg_2,
			this._box_btn,
			this._img_btn,
			this._Group_title,
			this._img_jiejie_b,
			this._txt_title1,
			this._gp_model_con,
			this._gp_attention,
			this._img_a,
			this.attention,
			this._lb_attention,
			this._Group2,
			this._img_b,
			this._lb_boss_name,
			this._Group5,
			this._img_g53,
			this._img_g54,
			this._img_g51,
			this._img_g52,
			this._Image5,
			this._bm_fight,
			this.Content1,
			this.Content,
			this._Label1,
			this._lb_time,
			this._Label2,
			this._lb_help,
			this._Group4,
			this._Label3,
			this._gp_check_touch,
this._img_add,
this._box_time_effect,
			this._btn,
			this._Image1,
			this.labelDisplay,
			this._btn_drop,
		]
			= this.GetChildrenByNames([

				"_bg_1",
				"_bg_2",
				"_box_btn",
				"_img_btn",
				"_Group_title",
				"_img_jiejie_b",
				"_txt_title1",
				"_gp_model_con",
				"_gp_attention",
				"_img_a",
				"attention",
				"_lb_attention",
				"_Group2",
				"_img_b",
				"_lb_boss_name",
				"_Group5",
				"_img_g53",
				"_img_g54",
				"_img_g51",
				"_img_g52",
				"_Image5",
				"_bm_fight",
				"Content1",
				"Content",
				"_Label1",
				"_lb_time",
				"_Label2",
				"_lb_help",
				"_Group4",
				"_Label3",
				"_gp_check_touch",
"_img_add",
"_box_time_effect",
				"_btn",
				"_Image1",
				"labelDisplay",
				"_btn_drop",
			])
	}
}
window["BossDomainView"] = BossDomainView
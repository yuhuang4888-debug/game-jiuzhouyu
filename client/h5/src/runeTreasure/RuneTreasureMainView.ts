import { Alert, Alert_Type } from "../alert/Alert"
import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItem1 } from "../common/BaseItem1"
import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { OpenFun } from "../common/OpenFun"
import { ResManager } from "../common/ResManager"
//import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { GoodsModel } from "../commonModel/GoodsModel"
import { RuneModel, RuneEvent } from "../commonModel/RuneModel"
import { TaskTipType } from "../commonModel/TaskModel"
//import { PlatformManager } from "../PlatformManager"
import { RoleManager } from "../commonModel/RoleManager"
import { Enum_ColorUtil_Light } from "../util/ColorUtil"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest, Util } from "../util/Util"
import { RuneTreasureStageRewardItem } from "./RuneTreasureStageRewardItem"
import { Config } from "../common/Config"
import { RuneTreasureModel, RuneTreasureEvent } from "../commonModel/RuneTreasureModel"
import { RuneTreasureAwardItem } from "./RuneTreasureAwardItem"
import { RuneConvertView } from "../rune/RuneConvertView"
import { GameResPath } from "../util/GameResPath"
import { RuneShowItem } from "./RuneShowItem"
import { FuncFirstOpenKey, FuncFirstOpenManager } from "../commonModel/FuncFirstOpenManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventName } from "../common/EventName"
import { RuneResultItem } from "./RuneResultItem"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"

export class RuneTreasureMainView extends BaseItem1 {
	SetData
	InitEvents
	LoadSuccess
	InitRareRune
	BtnClickFun
	SetBtnState
	SetProgress
	GetSatgeCfgById
	SetStage
	//SetResetText
	SetMyTreasure
	SetReward
	SetLuck
	ResetReward
	PlayRewardAnim
	InitLuckEffect
	UpdateLuckEffect
	SetSpeciallyRune
	PlayLeftRuneOne
	PlayRightRuneOne
	PlayLeftRuneTwo
	PlayRightRuneTwo
	treasure_type
	luck_max = 135
	luck_value = 0
	luck_percent = 0
	img_luck_effect
	mask_luck: Laya.Sprite
	luck_effect_offset = 15
	offset_value = 0
	mask_pos_y = 150

	all_value = 0
	reward_data
	anim_timeId
	anim_time = 0.01
	anim_step = 2
	child_width = 170
	judge_count = 3

	public constructor(parent) {
		super(parent)
		this.base_file = "runeTreasure"
		this.layout_file = "RuneTreasureMainView"

		let model: RuneTreasureModel = RuneTreasureModel.GetInstance()
		let local_roleMgr = RoleManager.GetInstance()
		let res_mgr = ResManager.GetInstance()
		let local_runeModel: RuneModel = RuneModel.GetInstance()
		let local_goodsModel: GoodsModel = GoodsModel.GetInstance()
		// let local_egret = egret
		let config_treasure_hunt_reward_,
			config_treasure_hunt_,
			config_rune_hunt_stage_,
			config_rune_hunt_turn_flush_,
			array_collection_: LoopScrowViewMgr,
			my_treasure_data_,
			count_free_time_id_,
			item_list_,
			stone_item_: BaseAwardItem,
			money_item_: BaseAwardItem,
			money_item2_: BaseAwardItem,
			is_free_ = false,
			jin_event_id_,
			discount = 0
		this.treasure_type = RuneTreasureModel.RUNE_TREASURE_TYPE

		this.load_callback = function () {
			this.LoadSuccess()
			this.InitEvents()
		}

		this.DeleteMe = () => {
			Laya.timer.clear(this, this.UpdateLuckEffect)
			Laya.Tween.clearAll(this._gp_left)
			Laya.Tween.clearAll(this._gp_right)
			this.CancelFreeTimer()
			this.luck_value = 0
			this.luck_percent = 0
			this.mask_luck = null
			this.ClearUIEffect(this._gp_effect)
			this.ClearUIEffect(this._luck_effect)
			if (item_list_) {
				for (let item of item_list_) {
					item.DeleteMe()
				}
			}
			item_list_ = null
			if (stone_item_) {
				stone_item_.DeleteMe()
				stone_item_ = null
			}
			if (money_item_) {
				money_item_.DeleteMe()
				money_item_ = null
			}
			if (money_item2_) {
				money_item2_.DeleteMe()
				money_item2_ = null
			}
			if (jin_event_id_) {
				local_roleMgr.mainRoleInfo.UnBind(jin_event_id_)
				jin_event_id_ = null
			}
			if (this.anim_timeId) {
				GlobalTimerQuest.CancelQuest(this.anim_timeId)
				this.anim_timeId = null
			}
			this.ClearFuncFirst()
			super.DeleteMe()
		}

		this.LoadSuccess = () => {
			config_treasure_hunt_reward_ = Config.PRELOAD_SERVER_CONFIG.config_treasure_hunt_reward
			config_treasure_hunt_ = Config.PRELOAD_SERVER_CONFIG.config_treasure_hunt
			config_rune_hunt_stage_ = Config.PRELOAD_SERVER_CONFIG.config_rune_hunt_stage
			config_rune_hunt_turn_flush_ = Config.PRELOAD_SERVER_CONFIG.config_rune_hunt_turn_flush
			ResManager.GetInstance().LoadFont(this, "rune_treasure", this.tiemsLab, 32);
			res_mgr.SetOutsideImageSprite(this, this._img_title, GameResPath.GetIcon("runeTreasure", "uizbxb_013b"))
			res_mgr.SetOutsideImageSprite(this, this._img_title1, GameResPath.GetIcon("runeTreasure", "uizbxb_013a"))
			res_mgr.SetOutsideImageSprite(this, this._img_title2, GameResPath.GetIcon("runeTreasure", "uizbxb_013"))
			res_mgr.SetOutsideImageSprite(this, this._img_kuang, GameResPath.GetIcon("runeTreasure", "uizbxb_016"))
			res_mgr.SetOutsideImageSprite(this, this._img_progress, GameResPath.GetIcon("runeTreasure", "uizbxb_017"))
			res_mgr.LoadFont(this, "rune_per", this._lb_percent, 22)
			this.AddUIEffect("ui_duobao_05", this._gp_effect, { x: 0, y: -1.3 }, null, true)
			this.img_luck_effect = this.AddUIEffect(`ui_duobao_04`, this._luck_effect, null, 4, true, null, null, () => {
				if (model.need_init_effect) {
					this.InitLuckEffect()
					model.need_init_effect = false
				}
			}, null, null, null, null, false)
			if (!model.need_init_effect) {
				this.InitLuckEffect()
			}

			this._lb_alltimes.style.color = "#ffffff"
			this._lb_alltimes.style.fontSize = 18
			this._lb_alltimes.style.wordWrap = false

			this._lb_ten.style.color = "#ffffff"
			this._lb_ten.style.fontSize = 18
			this._lb_ten.style.wordWrap = false
			this._lb_ten.style.stroke = 2
			this._lb_ten.style.strokeColor = "#000000"

			this._lb_one.style.color = "#ffffff"
			this._lb_one.style.fontSize = 18
			this._lb_one.style.wordWrap = false
			this._lb_one.style.stroke = 2
			this._lb_one.style.strokeColor = "#000000"

			this.luck_max = Number(config_treasure_hunt_[49].value)
			let discount_list = JSON.parse(config_treasure_hunt_[47].value)
			discount = discount_list[1][1]
			local_runeModel.Fire(RuneEvent.RUNE_REQUEST_PROTO, 16704)
			model.Fire(RuneTreasureEvent.RUNE_TREASURE_REQUEST_PROTO, 41610, "c", this.treasure_type)

			// this.AddUIEffect("ui_activity_Rune2", this._group_eff_1, null, null, true)
			// this.AddUIEffect("ui_activity_Rune1", this._group_eff_2, null, null, true)
			// this._img_circle.mask = this._mask_circle
			// this._group_eff_1.mask = this._mask_eff_1

			array_collection_ = new LoopScrowViewMgr()
			item_list_ = []
			//this.InitRareRune()
			model.Fire(RuneTreasureEvent.RUNE_TREASURE_REQUEST_PROTO, 41601, "c", RuneTreasureModel.RUNE_TREASURE_TYPE)
			// if (PlatformManager.IsEyouEnPlatform()) {
			// 	this.reset_txt.size = 16
			// 	this.reset_txt.y = -2
			// 	this.reset_txt.wordWrap = true
			// }
			this.UpdateFuncFirstState()
			this.SetSpeciallyRune()
		}

		this.SetSpeciallyRune = () => {
			let left = new RuneResultItem(this._gp_left)
			let right = new RuneResultItem(this._gp_right)
			Laya.Tween.clearAll(this._gp_left)
			Laya.Tween.clearAll(this._gp_right)
			left.Load()
			right.Load()
			left.SetData([99, 26260005, 1])
			right.SetData([99, 26270005, 2])
			this.PlayLeftRuneOne()
			this.PlayRightRuneOne()
		}

		this.PlayLeftRuneOne = () => {
			Laya.Tween.to(this._gp_left, { y: this._gp_left.y + 10 }, 2500, undefined, Laya.Handler.create(this, () => {
				this.PlayLeftRuneTwo()
			}))
		}

		this.PlayLeftRuneTwo = () => {
			Laya.Tween.to(this._gp_left, { y: this._gp_left.y - 10 }, 2500, undefined, Laya.Handler.create(this, () => {
				this.PlayLeftRuneOne()
			}))
		}

		this.PlayRightRuneOne = () => {
			Laya.Tween.to(this._gp_right, { y: this._gp_right.y - 10 }, 2500, undefined, Laya.Handler.create(this, () => {
				this.PlayRightRuneTwo()
			}))
		}

		this.PlayRightRuneTwo = () => {
			Laya.Tween.to(this._gp_right, { y: this._gp_right.y + 10 }, 2500, undefined, Laya.Handler.create(this, () => {
				this.PlayRightRuneOne()
			}))
		}

		this.InitEvents = () => {
			Util.AddClickEvent(this._btn_one, () => {
				this.BtnClickFun(1)
				this.FuncFirstOpenClick()
			}, this, true)

			Util.AddClickEvent(this._gp_left, () => {
				let basic = local_goodsModel.GetGoodsBasicByTypeId(26260005)
				if (basic) {
					UIToolTipMgr.GetInstance().AppendIllusionTips(basic.type_id)
				}
			}, this, false)

			Util.AddClickEvent(this._gp_right, () => {
				let basic = local_goodsModel.GetGoodsBasicByTypeId(26270005)
				if (basic) {
					UIToolTipMgr.GetInstance().AppendIllusionTips(basic.type_id)
				}
			}, this, false)

			Util.AddClickEvent(this._btn_ten, () => {
				if (discount == 0 || discount == 10) discount = 10
				this.BtnClickFun(discount)
			}, this, true)

			let UpdateFun = () => {
				this.SetReward()
			}
			this.BindEvent(local_runeModel, RuneEvent.UPDTE_RUNE_CONVERT_VIEW, UpdateFun)

			let UpdateData = () => {
				this.SetMyTreasure()
			}
			this.BindEvent(RuneTreasureModel.GetInstance(), RuneTreasureEvent.UPDATE_RUNE_TREASURE_DATA, UpdateData)

			let change_fun = () => {
				if (this.use_delete_method) return
				if (my_treasure_data_) {
					this.SetBtnState(my_treasure_data_)
				}
			}
			jin_event_id_ = local_roleMgr.mainRoleInfo.BindOne("jin", change_fun)
			this.BindEvent(local_goodsModel, GoodsModel.CHANGE_BAG_LIST, change_fun)

			this.BindEvent(model, RuneTreasureEvent.UPDATE_LUCKEY, (scmd) => {
				if (scmd.htype == this.treasure_type) {
					this.luck_value = scmd.luckey_value
					this.luck_percent = scmd.percent
					this.SetLuck()
				}
			})

			this.SetData()

			Util.AddClickEvent(this._btn_exchange, () => {
				local_runeModel.Fire(RuneEvent.OPEN_VIEW, "RuneConvertView")
			}, this, true)

			Util.AddClickEvent(this._btn_show, () => {
				model.Fire(RuneTreasureEvent.RUNE_TREASURE_OPEN_VIEW, "EquipTreaseRewardView", this.treasure_type)
			}, this, true)

			// this.BindEvent(model, RuneTreasureEvent.ONE_TIME, (scmd) => {
			// 	if (scmd.type == 4 && scmd.reward_list.length > 0) {
			// 		let start_pos = this.scroll.localToGlobal()
			// 		start_pos.x = start_pos.x + this.scroll.width / 2
			// 		start_pos.y = start_pos.y + this.scroll.width / 2
			// 		GlobalEventSystem.Fire(EventName.REWARD_FLY, [[0, scmd.reward_list[0].gtyp_id], 1], start_pos, undefined, undefined, 0, 0, undefined, MainFunc.Mall)
			// 	}
			// })

			// let rare_func = (value) => {
			// 	if (typeof model.GetTreasureHuneKeyCfg(31).value == "string")
			// 		model.GetTreasureHuneKeyCfg(31).value = JSON.parse(model.GetTreasureHuneKeyCfg(31).value)
			// 	let list = model.GetTreasureHuneKeyCfg(31).value
			// 	UIToolTipMgr.GetInstance().AppendGoodsTips(list[value][1])
			// }
			// Util.AddClickEvent(this._gp_rare0, () => {
			// 	rare_func(0)
			// }, this, true)
			// Util.AddClickEvent(this._gp_rare1, () => {
			// 	rare_func(1)
			// }, this, true)

			this._gp_rune.scrollBar.on(Laya.Event.CHANGE, this, () => {
				let value = this._gp_rune.scrollBar.value
				let left = this.judge_count * this.child_width
				let right = this.all_value - left
				if (value <= left) {
					this.ResetReward(true, value)
				} else if (value >= right) {
					this.ResetReward(false, value)
				}
			})
		}

		this.SetData = () => {
			this.SetReward()
			this.SetMyTreasure()
			// this.SetStone()
		}

		// this.SetStone() {
		// if (!stone_item_) {
		// 	stone_item_ = new AwardItem(this.reward_icon)
		// 	stone_item_.Load()
		// 	stone_item_.SetItemSize(40, 40)
		// 	stone_item_.Load()
		// 	stone_item_.SetItembgVisible(false)
		// }
		// let cfg = model.GetTreasureHuneKeyCfg(15)
		// if (cfg) {
		// 	let goods_list = JSON.parse(cfg.value)
		// 	let [type_id, lock] = local_goodsModel.GetMappingTypeId(goods_list[0][0], goods_list[0][1])
		// 	let goods_vo = local_goodsModel.GetGoodsBasicByTypeId(type_id)
		// 	if (goods_vo) {
		// 		stone_item_.SetData(type_id, 1)
		// 		this.get_num.text = `${goods_list[0][2][0]} ~ ${goods_list[0][2][1]}`
		// 	}
		// }
		// }

		// 幸运值
		this.SetLuck = () => {
			this._lb_rate.text = this.luck_value + "/" + this.luck_max
			let value = this.luck_percent || 0
			this._lb_percent.text = "+" + value + "%"

			if (this.img_luck_effect && this.mask_luck) {
				let luck = (this.luck_value + this.offset_value) / (this.luck_max + this.offset_value)
				this.img_luck_effect.centerY = 160 * (1 - luck) - this.luck_effect_offset
				this.img_luck_effect.mask.y = this.mask_pos_y - 160 * (1 - luck) + this.luck_effect_offset
			}
		}

		// 幸运值特效
		this.InitLuckEffect = () => {
			if (this.img_luck_effect && !this.mask_luck) {
				let pos_x = this.img_luck_effect.width / 2
				let pos_y = this.img_luck_effect.height / 2
				this.mask_pos_y = pos_y
				this.mask_luck = new Laya.Sprite()
				this.mask_luck.pos(pos_x, pos_y)
				this.img_luck_effect.mask = this.mask_luck
				this.img_luck_effect.mask.centerX = 0

				let now_value = this.luck_value > 0 ? this.luck_value : 0
				let luck = (now_value + this.offset_value) / (this.luck_max + this.offset_value)
				this.img_luck_effect.centerY = 160 * (1 - luck) - this.luck_effect_offset
				this.img_luck_effect.mask.y = this.mask_pos_y - 160 * (1 - luck) + this.luck_effect_offset

				Laya.timer.frameLoop(3, this, this.UpdateLuckEffect)
			}
		}

		this.UpdateLuckEffect = () => {
			this.mask_luck.graphics.clear()
			this.mask_luck.graphics.drawCircle(0, 0, 73, "#ff0000")
		}

		// 奖励池
		this.SetReward = () => {
			let list = model.GetTreasureRewardByColor(config_treasure_hunt_reward_, 5)
			this.reward_data = list
			this.all_value = list.length * this.child_width - this._gp_rune.width + 50
			array_collection_.SetData(this._gp_rune, RuneShowItem, list, LoopScrCon.Horizontal)
			let default_value = Math.ceil(list.length / 2) * this.child_width - this._gp_rune.width / 2
			this._gp_rune.scrollBar.value = default_value
			this.PlayRewardAnim()
		}

		// 重置奖励池数据 
		this.ResetReward = (is_front, value) => {
			let list = []
			let now_value = 0
			let now_index = 0
			let length = this.reward_data.length
			let move_count = Math.ceil(length / 3)
			if (is_front) {
				for (let i = 0; i < move_count; i++) {
					list[i] = this.reward_data[length - move_count + i]
				}
				for (let i = move_count; i < length; i++) {
					list[i] = this.reward_data[i - move_count]
				}
				now_value = value + move_count * this.child_width
				// now_index = move_count + this.judge_count
			} else {
				for (let i = 0; i < (length - move_count); i++) {
					list[i] = this.reward_data[i + move_count]
				}
				for (let i = (length - move_count); i < length; i++) {
					list[i] = this.reward_data[i - length + move_count]
				}
				now_value = value - move_count * this.child_width
				// now_index = length - (this.judge_count + 4) - move_count
			}
			this.reward_data = list	
			this._gp_rune.updateArray(list)
			//this._gp_rune.startIndex = now_index
			this._gp_rune.scrollBar.value = now_value
		}

		// 播放奖励池动画
		this.PlayRewardAnim = () => {
			if (this.anim_timeId) {
				GlobalTimerQuest.CancelQuest(this.anim_timeId)
				this.anim_timeId = null
			}
			this.anim_timeId = GlobalTimerQuest.AddPeriodQuest(() => {
				let value = this._gp_rune.scrollBar.value + this.anim_step
				this._gp_rune.scrollBar.value = value
			}, this.anim_time)
		}

		// 我的抽奖数据
		this.SetMyTreasure = () => {
			my_treasure_data_ = model.rune_treasure_data
			if (my_treasure_data_ == undefined) {
				return
			}
			// this.SetResetTime(my_treasure_data_.stage_reflush_time)
			this.SetNextFreeTime()
			this.SetStage(my_treasure_data_)
			this.SetBtnState(my_treasure_data_)
			this.SetTimes(my_treasure_data_.draw_tiems)
			//this.SetResetText(my_treasure_data_.turn)
		}


		// this.SetResetText = (turn_times) => {
		// 	let cfg = config_rune_hunt_turn_flush_ && config_rune_hunt_turn_flush_[turn_times]
		// 	if (cfg) {
		// 		let str = "每天0点重置"
		// 		if (cfg.type == 2) {	//每周一0点重置
		// 			str = "周一0点重置"
		// 		} else if (cfg.type == 0) {	//不重置
		// 			str = "奖励不重置"
		// 		}
		// 		this._lb_reset.text = str
		// 	}
		// }

		//设置重置倒计时
		// this.SetResetTime(time) {
		// this.CancelTimer()
		// let on_time = () => {
		// 	let left_time = time - TimeUtil.getServerTime()
		// 	if (left_time < 0) {
		// 		this.CancelTimer()
		// 		this.reset_txt.text = "即将重置阶段奖励"
		// 		model.Fire(RuneTreasureEvent.RUNE_TREASURE_REQUEST_PROTO, 41601, "h", RuneTreasureModel.RUNE_TREASURE_TYPE)
		// 		return
		// 	}
		// 	let time_str = TimeUtil.convertTime(left_time) || 0
		// 	this.reset_txt.text = String(time_str) + "后重置奖励"
		// }
		// this.count_time_id = new local_egret.Timer(1000, 0)
		// this.count_time_id.addEventListener(local_egret.TimerEvent.TIMER, on_time, this)
		// this.count_time_id.start()
		// on_time()
		// }

		// this.CancelTimer() {
		// 	// if (this.count_time_id) {
		// 	// 	this.count_time_id.stop()
		// 	// 	this.count_time_id = undefined
		// 	// }
		// }

		// 设置阶段奖励
		this.SetStage = (data) => {
			if (data) {
				let times_str = Util.HtmlColorTxt(data.draw_tiems, Enum_ColorUtil_Light.GREEN)
				this._lb_alltimes.innerHTML = Util.StrToHTML(`本周累计次数：${times_str}`)
				let cfg
				let first = 0
				let sort_func = (a, b) => {
					return a.stage - b.stage
				}
				data.stage_reward_list.sort(sort_func)

				let max = 0
				for (let i = 0; i < data.stage_reward_list.length; i++) {
					let info = data.stage_reward_list[i]
					let item = item_list_[i]
					if (!item) {
						item = new RuneTreasureStageRewardItem(this._gp_stage)
						item.Load()
						item_list_[i] = item
					}
					cfg = this.GetSatgeCfgById(data.turn, info.stage)
					if (info && cfg) {
						if (first == 0) {
							first = cfg.draw_time
						}
						item.SetData(info, cfg, i)
						max = cfg.draw_time
					}
				}
				this.SetProgress(data.draw_tiems, max)
			}
		}

		// 通过轮次和宝箱id获取阶段配置
		this.GetSatgeCfgById = (turn_time, id) => {
			let cfg
			let vo
			for (let key in config_rune_hunt_stage_) {
				vo = config_rune_hunt_stage_[key]
				if (vo.turn_time == turn_time && vo.reward_id == id) {
					cfg = vo
					break
				}
			}
			return cfg
		}

		this.SetProgress = (now_value, max) => {
			let width = 0
			let step = 60
			if (now_value <= 10) {
				width = 0
			} else if (now_value <= 30) {
				width = 45 + (now_value - 10) / 20 * 75
			} else if (now_value <= 60) {
				width = 190 + (now_value - 30) / 30 * 70
			} else if (now_value <= 100) {
				width = 335 + (now_value - 60) / 40 * 65
			} else if (now_value < 150) {
				width = 480 + (now_value - 100) / 50 * 60
			} else {
				width = 576
			}
			this._img_progress.width = width

			// let value = now_value / max
			// if (value > 1) {
			// 	value = 1
			// }
			//this._img_progress.width = value * 576
		}

		// 设置按钮状态
		this.SetBtnState = (data) => {
			if (data) {
				is_free_ = data.rune_free_time - TimeUtil.getServerTime() > 0 ? false : true
				let icon_url = is_free_ ? "uizbxb_019b" : "uizbxb_019"
				res_mgr.SetImageSprite(this, this._img_one, "runeTreasure", icon_url)
				this.one_icon.visible = !is_free_
				this._lb_one.visible = !is_free_
				this.red_dot.visible = is_free_
				let specail_num = local_goodsModel.GetTypeGoodsNum(RuneTreasureModel.TEN_COMPANY_TICKET)
				let my_have = local_goodsModel.GetTypeGoodsNum(RuneTreasureModel.RUNE_TREASURE_TICKET)
				if (!money_item_) {
					money_item_ = new BaseAwardItem(this.one_icon)
					money_item_.Load()
					money_item_.SetItemSize(32, 32)
					money_item_.Load()
					money_item_.SetItembgVisible(false)
					money_item_.SetData(RuneTreasureModel.RUNE_TREASURE_TICKET)
					money_item_.SetShowTips(false)
				}

				// this.one_cost.text = is_free_ ? "免费" : "1"
				// this.one_cost.text = `${my_have}/1`
				// if (my_have < 1) {
				// 	this.one_cost.textFlow = Util.StrToHTML(`<font color=0xff4f50>${my_have}</font>/1`)
				// 	// this.one_cost.textFlow = Util.StrToHTML(`${my_have}/1`)
				// }
				let color = my_have < 1 ? Enum_ColorUtil_Light.RED : Enum_ColorUtil_Light.GREEN
				let str = Util.HtmlColorTxt(my_have, color)
				this._lb_one.innerHTML = Util.StrToHTML(`${str}/1`)
				this.CallLater(() => {
					this._lb_one.event("resize")
				})

				if (!money_item2_) {
					money_item2_ = new BaseAwardItem(this.ten_icon)
					money_item2_.Load()
					money_item2_.SetItemSize(32, 32)
					money_item2_.Load()
					money_item2_.SetItembgVisible(false)
					money_item2_.SetShowTips(false)
				}
				money_item2_.SetData(specail_num > 0 ? RuneTreasureModel.TEN_COMPANY_TICKET : RuneTreasureModel.RUNE_TREASURE_TICKET)
				// this.ten_cost.text = `${my_have}/10`
				// if (my_have < 10) {
				// 	// this.ten_cost.textFlow = Util.StrToHTML(`<font color=0xff4f50>${my_have}</font>/10`)
				// 	this.ten_cost.textFlow = Util.StrToHTML(`${my_have}/10`)
				// }

				if (specail_num > 0) {
					color = Enum_ColorUtil_Light.GREEN
					str = Util.HtmlColorTxt(specail_num, color)
					this._lb_ten.innerHTML = Util.StrToHTML(`${str}/1`)
				} else {
					let need_num = discount == 0 || discount == 10 ? 10 : discount
					color = my_have < need_num ? Enum_ColorUtil_Light.RED : Enum_ColorUtil_Light.GREEN
					str = Util.HtmlColorTxt(my_have, color)
					this._lb_ten.innerHTML = Util.StrToHTML(`${str}/${need_num}`)
				}
				this._ten_red.visible = specail_num > 0
				this.CallLater(() => {
					this._lb_ten.event("resize")
				})
			}
		}

		// 按钮点击操作
		this.BtnClickFun = (num) => {
			if (model.treasure_rune_lock) {
				return
			}
			let specail_num = local_goodsModel.GetTypeGoodsNum(RuneTreasureModel.TEN_COMPANY_TICKET)
			let specail_basic = local_goodsModel.GetGoodsBasicByTypeId(RuneTreasureModel.TEN_COMPANY_TICKET)
			let my_have = local_goodsModel.GetTypeGoodsNum(RuneTreasureModel.RUNE_TREASURE_TICKET)
			let basic = local_goodsModel.GetGoodsBasicByTypeId(RuneTreasureModel.RUNE_TREASURE_TICKET)
			if (!basic) {
				return
			}
			let request_fun = (buy_type) => {
				let count = num > 1 ? 10 : num
				model.treasure_rune_lock = true
				model.Fire(RuneTreasureEvent.RUNE_TREASURE_REQUEST_PROTO, 41604, "ccc", RuneTreasureModel.RUNE_TREASURE_TYPE, count, buy_type)
			}
			let check_func = (bool: boolean) => {
				model.show_daimond_cost_alert = bool
			}
			let ok_func = () => {
				request_fun(1)
			}
			if (is_free_ && num == 1) {
				request_fun(0)
			} else if (num > 1 && specail_num > 0) {
				if (!specail_basic) return
				request_fun(0)
				// if (model.show_rune_alert == false) {
				// 	let str = `是否消耗<font color='#639c12'>1个${specail_basic.goods_name}</font>进行召唤？`
				// 	let content = Util.StrToHTML(str)
				// 	Alert.Show(content, Alert_Type.AlertTypeCheckBox, () => {
				// 		request_fun(0)
				// 	}, undefined, "确定", "取消", undefined, false, (bool: boolean) => {
				// 		model.show_rune_alert = bool
				// 	}, "本次登录不再提示")
				// } else {
				// 	request_fun(0)
				// }
			} else {
				let need = num - my_have
				let goods_info = Config.PRELOAD_SERVER_CONFIG.config_goods_price[RuneTreasureModel.RUNE_TREASURE_TICKET]
				let goods_price = goods_info ? goods_info.price : 1
				goods_price = goods_price * need
				if (need > 0) {		//不够券
					let money_enough = local_roleMgr.mainRoleInfo.jin >= goods_price
					let gap = need - local_roleMgr.mainRoleInfo.jin
					if (money_enough) {
						if (model.show_daimond_cost_alert == false) {
							let str = `是否消耗<font color='#639c12'>${goods_price}勾玉</font>购买<font color='#639c12'>${need}</font>个<font color='#639c12'>${basic.goods_name}</font>？`
							let content = Util.StrToHTML(str)
							Alert.Show(content, Alert_Type.AlertTypeCheckBox, ok_func, undefined, "确定", "取消", undefined, false, check_func, "本次登录不再提示")
						} else {
							ok_func()
						}
					} else {
						let charge_fun = () => {
							let state = CustomActivityModel.GetInstance().GetSuperGiftBuyState()
							if(state){
								OpenFun.OpenFunHandler(21);
							}else{
								OpenFun.OpenFunHandler(249);
							}
							// OpenFun.OpenFunHandler(21)
						}
						let str = `您的勾玉不足${goods_price}，是否前往充值`
						Alert.Show(str, Alert_Type.One, charge_fun, undefined, "确定")
					}
				} else {
					request_fun(0)
					// if (model.show_rune_alert == false) {
					// 	let str = `是否消耗<font color='#639c12'>${num}个${basic.goods_name}</font>进行召唤？`
					// 	let content = Util.StrToHTML(str)
					// 	Alert.Show(content, Alert_Type.AlertTypeCheckBox, () => {
					// 		request_fun(0)
					// 	}, undefined, "确定", "取消", undefined, false, (bool: boolean) => {
					// 		model.show_rune_alert = bool
					// 	}, "本次登录不再提示")
					// } else {
					// 	request_fun(0)
					// }
				}
			}
		}

		this.InitRareRune = () => {
			// this.AddUIEffect("ui_Rune_icon1_1", this._gp_rare0_eff, null, { x: 0.8, y: 0.8 }, true)
			// this.AddUIEffect("ui_Rune_icon2_1", this._gp_rare1_eff, null, { x: 0.8, y: 0.8 }, true)
			if (typeof model.GetTreasureHuneKeyCfg(31).value == "string")
				model.GetTreasureHuneKeyCfg(31).value = JSON.parse(model.GetTreasureHuneKeyCfg(31).value)
			let list = model.GetTreasureHuneKeyCfg(31).value
			for (let index in list) {
				let basic = local_goodsModel.GetGoodsBasicByTypeId(list[index][1])
				res_mgr.SetTexture(this, this[`_img_rare${index}`], `resource/game/goodsicon/${basic.goods_icon}.png`)
			}
		}
	}

	private SetTimes(times: number) {
		// let wheel: number = 10; // 要求写死
		// let yu: number = times % wheel;
		// let num: number = wheel - yu;
		// this._img_title1.visible = num == 1;
		// this._img_title2.visible = this.tiemsLab.visible = num != 1;

		// this.tiemsLab.text = num.toString();

		// this.tiemsLab.x = num >= 10 ? 172 : 204;


	}

	// 第一次添加到舞台的时候调用
	public createChildren() {
		this.story_obj_list = this.story_obj_list || {
		}
		this.story_obj_list[TaskTipType.Rune_treasure] = ["", this._btn_one, BaseWindowComponent.CURR_BASE_WINDOW_COMPONENT._img_return]
		super.createChildren()
	}


	// 设置重置倒计时
	private SetNextFreeTime() {
		this.CancelFreeTimer()
		let data = RuneTreasureModel.GetInstance().rune_treasure_data;
		let left_time: number = data.rune_free_time - TimeUtil.getServerTime()
		if (left_time > 0) {
			Laya.timer.loop(1000, this, this.on_time)
		} else {
			this._lb_freetime.text = "当前免费";
		}
	}

	private on_time() {
		let data = RuneTreasureModel.GetInstance().rune_treasure_data;
		if (data?.rune_free_time != undefined) {
			let left_time = data.rune_free_time - TimeUtil.getServerTime()
			if (left_time < 0) {
				this.CancelFreeTimer()
				this._lb_freetime.text = "当前免费"
				//放在model里面发协议了
				RuneTreasureModel.GetInstance().Fire(RuneTreasureEvent.RUNE_TREASURE_REQUEST_PROTO, 41601, "c", RuneTreasureModel.RUNE_TREASURE_TYPE)
				return
			}
			let time_str = TimeUtil.timeConvert(left_time, "hh:MM:ss")
			this._lb_freetime.text = String(time_str)
		}
	}

	private CancelFreeTimer() {
		Laya.timer.clear(this, this.on_time)
	}

	public FuncFirstOpenClick() {
		if (this.has_set_func_first_state) {
			let func_first_mgr = FuncFirstOpenManager.GetInstance()
			func_first_mgr.AddStep(FuncFirstOpenKey.RuneTreasure)
			this.ClearFuncFirst()
		}
	}


	has_set_func_first_state
	public UpdateFuncFirstState() {
		let func_first_mgr = FuncFirstOpenManager.GetInstance()
		if (this.CheckFuncFirstValue() && !func_first_mgr.CheckFuncFirstOpenState(FuncFirstOpenKey.RuneTreasure)) {
			func_first_mgr.AddStepSprite(FuncFirstOpenKey.RuneTreasure, 1, this._btn_one)
			func_first_mgr.UpdateStepState(FuncFirstOpenKey.RuneTreasure)
			this.has_set_func_first_state = true
		}
		else {
			this.ClearFuncFirst()
		}
	}

	//当前数据源是否是需要引导的那条数据
	public CheckFuncFirstValue() {
		return true
	}

	public ClearFuncFirst() {
		if (this.has_set_func_first_state) {
			this.has_set_func_first_state = false
			let func_first_mgr = FuncFirstOpenManager.GetInstance()
			func_first_mgr.ClearStepSprite(FuncFirstOpenKey.RuneTreasure, 1)
			GlobalEventSystem.Fire(EventName.HIDE_FINGER, this._btn_one)
		}
	}

	_img_title: Laya.Image
	_img_title1: Laya.Image
	_img_title2: Laya.Image
	tiemsLab: Laya.Label
	_gp_left: Laya.Box
	_gp_right: Laya.Box
	_gp_effect: Laya.Box
	_gp_luck: Laya.Box
	_luck_effect: Laya.Box
	_img_ring: Laya.Image
	_img_tips2: Laya.Image
	_img_tips3: Laya.Image
	_lb_rate: Laya.Label
	_lb_percent: Laya.Label
	_gp_rune: Laya.List
	_gp_progress: Laya.Box
	_img_kuang: Laya.Image
	_img_progress: Laya.Image
	_gp_stage: Laya.Box
	_gp_msg: Laya.Box
	_img_leftbg: Laya.Image
	_img_rightbg: Laya.Image
	_lb_tips1: Laya.Label
	_lb_freetime: Laya.Label
	_lb_alltimes: Laya.HTMLDivElement
	_btn_one: Laya.Box
	_img_one: Laya.Image
	red_dot: Laya.Image
	_gp_one: Laya.HBox
	one_icon: Laya.Box
	_lb_one: Laya.HTMLDivElement
	_btn_ten: Laya.Box
	_img_ten: Laya.Image
	_gp_ten: Laya.HBox
	ten_icon: Laya.Box
	_lb_ten: Laya.HTMLDivElement
	_ten_red: Laya.Image
	_btn_exchange: Laya.Image
	_btn_show: Laya.Image

	public GetComponents() {
		[
			this._img_title,
			this._img_title1,
			this._img_title2,
			this.tiemsLab,
			this._gp_left,
			this._gp_right,
			this._gp_effect,
			this._gp_luck,
			this._luck_effect,
			this._img_ring,
			this._img_tips2,
			this._img_tips3,
			this._lb_rate,
			this._lb_percent,
			this._gp_rune,
			this._gp_progress,
			this._img_kuang,
			this._img_progress,
			this._gp_stage,
			this._gp_msg,
			this._img_leftbg,
			this._img_rightbg,
			this._lb_tips1,
			this._lb_freetime,
			this._lb_alltimes,
			this._btn_one,
			this._img_one,
			this.red_dot,
			this._gp_one,
			this.one_icon,
			this._lb_one,
			this._btn_ten,
			this._img_ten,
			this._gp_ten,
			this.ten_icon,
			this._lb_ten,
			this._ten_red,
			this._btn_exchange,
			this._btn_show,
		]
			= this.GetChildrenByNames([

				"_img_title",
				"_img_title1",
				"_img_title2",
				"tiemsLab",
				"_gp_left",
				"_gp_right",
				"_gp_effect",
				"_gp_luck",
				"_luck_effect",
				"_img_ring",
				"_img_tips2",
				"_img_tips3",
				"_lb_rate",
				"_lb_percent",
				"_gp_rune",
				"_gp_progress",
				"_img_kuang",
				"_img_progress",
				"_gp_stage",
				"_gp_msg",
				"_img_leftbg",
				"_img_rightbg",
				"_lb_tips1",
				"_lb_freetime",
				"_lb_alltimes",
				"_btn_one",
				"_img_one",
				"red_dot",
				"_gp_one",
				"one_icon",
				"_lb_one",
				"_btn_ten",
				"_img_ten",
				"_gp_ten",
				"ten_icon",
				"_lb_ten",
				"_ten_red",
				"_btn_exchange",
				"_btn_show",
			])
	}
}
window["RuneTreasureMainView"] = RuneTreasureMainView
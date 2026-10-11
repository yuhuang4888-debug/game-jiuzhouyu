import { BaseItem1 } from "../common/BaseItem1"
import { table } from "../common/table"
import { Util } from "../util/Util"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest } from "../util/Util"
import { HtmlColorTxt } from "../util/Util"
import { ResManager } from "../common/ResManager"
import { RoleManager } from "../commonModel/RoleManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { BossModel } from "../commonModel/BossModel"
import { Message } from "../sysInfo/SysInfoController"
import { EquipmentItem } from "../common/EquipmentItem"
import { BossMysteryRoomView } from "./BossMysteryRoomView"
import { UI_MODEL_TYPE } from "../common/UIModelClass3D"
import { ErlangParser } from "../util/ErlangParser"

export class BossMysteryEnterView extends BaseItem1 {
	ClearModel
	ClearTimer
	CustomMehod
	InitEvent
	InitView
	LoadSuccess
	ReOpen_callback
	SetBoxMsg
	SetRewardDot
	SetRewardState
	SetRoom
	SetRoomType
	SetSpecialBoss
	ShowModel
	ShowRewardItem
	ShowStateMsg
	StartBoxTimer
	SwitchBoxShow
	SwitchView
	Text
	UpdateCbImage
	UpdateRemindState
	UpdateTime
	UpdateView

	//_cb_attention
	_cb_attention_state

	boss_id
	boss_info
	boss_model
	boss_type
	boss_type_info
	initRequestTimer
	mask
	mon_res
	onTime
	reborn_timer
	removeTimer
	requestTimer
	reward_item_list
	room_item
	select_boss_id
	cfg_boss_type
	cfg_kill

	public constructor(parent?) {
		super(parent)
		this.base_file = "bossMystery"
		this.layout_file = "BossMysteryEnterView"

		this.boss_type = BossModel.BossType.mystery
		this.boss_model = BossModel.GetInstance()
		let role_mgr = RoleManager.GetInstance()
		let goods_model = GoodsModel.GetInstance()

		this._cb_attention_state = false
		this.mon_res = null

		this.load_callback = () => {
			this.LoadSuccess()
			this.InitEvent()
			this.InitView()
		}

		this.ReOpen_callback = () => {
			if (this.mon_res) {
				this.ShowModel(this.mon_res)
			}
		}

		this.CustomMehod = (index?, args?) => {
			if (args && args[0]) {
				this.select_boss_id = Number(args[0])
			}
		}

		this.LoadSuccess = () => {
			this.cfg_boss_type = ResManager.GetInstance().GetGameConfigFromCache(this, "config_boss_type", false)
			this.cfg_kill = ResManager.GetInstance().GetGameConfigFromCache(this, "config_domain_kill_reward", false)
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_reward_bg, "resource/game/bossMystery/other/ui_chief_qz5.png")

			this._reward_con.vScrollBar.visible = false

			this.mon_num.style.fontSize = 20
			this.mon_num.style.color = "#ffffff"
			this.mon_num.style.wordWrap = false
			this.mon_num.style.align = "center"

			this.special_num.style.fontSize = 20
			this.special_num.style.color = "#ffffff"
			this.special_num.style.wordWrap = false
			this.special_num.style.align = "center"

			this.special_add_tired.style.fontSize = 20
			this.special_add_tired.style.color = "#ffffff"
			this.special_add_tired.style.wordWrap = false
			this.special_add_tired.style.align = "center"

			this.left_box_num.style.fontSize = 20
			this.left_box_num.style.color = "#ffffff"
			this.left_box_num.style.wordWrap = false
			this.left_box_num.style.align = "center"

			this.refresh_time.style.fontSize = 20
			this.refresh_time.style.color = "#ffffff"
			this.refresh_time.style.wordWrap = false
			this.refresh_time.style.align = "center"

			this.add_tired.style.fontSize = 20
			this.add_tired.style.color = "#ffffff"
			this.add_tired.style.wordWrap = false
			this.add_tired.style.align = "center"

			let show = this.boss_model.MysteryTicketEnoughDot(this.cfg_boss_type)
			if (show) {
				this.boss_model.has_show_challenge_dot = true
				this.boss_model.RefreshMysteryBossRedDot(this.cfg_kill)
			}

			// if (PlatformMgr.GetInstance().IsEyouEnPlatform()) {
			// 	this.Text.size = 20
			// 	this.Text.lineSpacing = 0.5
			// 	this.Text.verticalAlign = "middle"
			// 	this.Text.textAlign = "center"
			// 	SetSizeDelta(this.Text, 100, 50)
			// 	SetAnchoredPosition(this.Text, 0, -18)
			// }
		}

		this.InitEvent = () => {
			this.BindEvent(this.boss_model, BossModel.UPDATE_BOSS_INFO, (boss_type?) => {
				if (boss_type == this.boss_type) {
					this.UpdateView()
				}
			})

			Util.AddClickEvent(this._gp_attention, () => {
				if (this.boss_info) {
					let is_special = (this.boss_info.mon_type == BossModel.MYSTERY_BOX_TYPE || this.boss_info.mon_type == BossModel.MYSTERY_SUPER_BOX_TYPE || this.boss_info.mon_type == BossModel.MYSTERY_SPECIAL_BOSS_TYPE)
					if (is_special) {
						Message.show("不支持关注哦~")
						return
					}

					let state = !this._cb_attention_state ? 1 : 0
					this.boss_model.Fire(BossModel.SCMD_REQUEST, 46007, this.boss_info.boss_type, this.boss_info.boss_id, state,0)
				}
			}, this, true)


			this.BindEvent(this.boss_model, BossModel.UPDATE_REMIND_STATE, (boss_type?, boss_id?) => {
				if (boss_type == this.boss_type && boss_id == this.boss_id) {
					this.UpdateRemindState()
				}
			})

			Util.AddClickEvent(this._btn_drop, () => {
				this.boss_model.Fire(BossModel.OPEN_DROP_RECORD_VIEW,BossModel.BossType.mystery)
			}, this, true)

			Util.AddClickEvent(this._btn_reward, () => {
				this.boss_model.Fire(BossModel.OPEN_MYSTERY_BOSS_REWARD_VIEW)
			}, this, true)

			Util.AddClickEvent(this.switchBtn, () => {
				this.SwitchBoxShow()
			}, this, true)

			this.BindEvent(this.boss_model, BossModel.UPDATE_MYSTERY_BOSS_REWARD, () => {
				this.SetRewardState()
			})

			this.BindEvent(this.boss_model, BossModel.UPDATE_MON_POS, () => {
				if (this.boss_type == BossModel.BossType.mystery) {
					if (this.boss_info) {
						if (this.boss_info.mon_type == BossModel.MYSTERY_BOX_TYPE || this.boss_info.mon_type == BossModel.MYSTERY_SUPER_BOX_TYPE) {
							this.SetBoxMsg(this.boss_info)
						} else if (this.boss_info.mon_type == BossModel.MYSTERY_SPECIAL_BOSS_TYPE) {
							this.SetSpecialBoss(this.boss_info)
						}
					}
				}
			})
		}

		this.InitView = () => {
			this.SetRoomType()
			this.boss_model.Fire(BossModel.SCMD_REQUEST, 46000, this.boss_type)
			this.boss_model.Fire(BossModel.SCMD_REQUEST, 46037)
			this.boss_model.Fire(BossModel.SCMD_REQUEST, 46039)
			this.initRequestTimer()
			this.SetRewardState()
			this.UpdateView()
		}

		this.UpdateView = () => {
			this.boss_type_info = this.boss_model.GetBossTypeInfo(this.boss_type)
			if (this.room_item) {
				this.room_item.SetData(this.boss_type_info)
			}
		}

		this.SetRoomType = () => {
			this.SetRoom(BossMysteryRoomView)
		}

		this.SetRoom = (room_class?) => {
			if (!this.room_item) {
				this.room_item = new room_class(this._gp_room_con)
				this.room_item.Load()
			}
			let call_fun = (info?) => {
				this.SwitchView(info)
			}
			this.room_item.SetClickCallBack(call_fun)
			if (this.select_boss_id) {
				this.room_item.SetSelectBoss(this.select_boss_id)
			}
		}

		this.SwitchView = (info?) => {
			this.boss_info = info
			if (this.boss_info) {
				this.boss_id = info.boss_id
				if (info.mon_type == BossModel.MYSTERY_BOX_TYPE || info.mon_type == BossModel.MYSTERY_SUPER_BOX_TYPE) {
					this._lb_boss_name.text = info.boss_name
				} else {
					this._lb_boss_name.text = "Lv" + info.lv + " " + info.boss_name
				}

				let rewards = ErlangParser.GetInstance().parse(info.ratio_goods)
				let career = role_mgr.GetMainRoleVo().career
				let reward_list = []
				for (let _tmpi in rewards) {
					let vo = rewards[_tmpi]
					if (Number(vo[0]) == career) {
						reward_list = vo[1]
						break
					}
				}
				this.ShowRewardItem(reward_list)
				this.ShowModel(info.icon, info.ui_scale)
				this.ShowStateMsg(info)
				this.UpdateRemindState()
				this.boss_model.Fire(BossModel.UPDATE_SELECT_BOSS_INFO, info)
			}
		}

		this.ShowRewardItem = (reward_list?) => {
			if (!this.reward_item_list) {
				this.reward_item_list = []
			}
			let len = reward_list.length
			let i = len
			do {
				if (this.reward_item_list[i]) {
					this.reward_item_list[i].SetVisible(false)
				}
				i = i + 1
			} while ((i < this.reward_item_list.length))

			let index = 0
			for (let key in reward_list) {
				let vo = reward_list[key]
				let [type_id, lock] = goods_model.GetMappingTypeId(vo[0], vo[1])
				let goods_vo = goods_model.GetGoodsBasicByTypeId(type_id)
				if (goods_vo) {
					let item = this.reward_item_list[index]
					if (!item) {
						item = new EquipmentItem(this._reward_con)
						this.reward_item_list[index] = item
						item.SetItemSize(80, 80)
						item.SetUseMask(true)
						item.Load()
						item.SetPosition(Number(index) % 2 == 0 ? 0 : 97, Math.floor(Number(index) / 2) * 89)
					}
					item.SetVisible(true)
					item.SetData(goods_vo.type_id, vo[2], lock)
					index = index + 1
				}
			}
		}

		this.ShowModel = (mon_res?, ui_scale?) => {
			this.mon_res = mon_res
			let action_name_list = ["attack"]
			table.insert(action_name_list, "idle")
			// 宝箱怪
			if (mon_res == 15010025||mon_res == 15010066){
				action_name_list = ["idle"]
			}

			let data = {
				clothe_res_id: mon_res,
				type: UI_MODEL_TYPE.MONSTER,
				action_name_list: action_name_list,
				layout_file: "BossMysteryEnterView"
			}
			ResManager.GetInstance().SetRoleModel(this, this._gp_model_con, data)
		}

		this.UpdateRemindState = () => {
			let info = this.boss_model.GetBossInfo(this.boss_type, this.boss_id)
			if (!info) {
				return
			}
			let is_special = (info.mon_type == BossModel.MYSTERY_BOX_TYPE || info.mon_type == BossModel.MYSTERY_SUPER_BOX_TYPE || info.mon_type == BossModel.MYSTERY_SPECIAL_BOSS_TYPE)
			this._cb_attention_state = !is_special ? info.is_remind : false
			this.UpdateCbImage()
		}

		this.UpdateCbImage = () => {
			this.attention.visible = this._cb_attention_state
		}

		this.ShowStateMsg = (info?) => {
			if (info) {
				this.box_con.visible = info.mon_type == 2 || info.mon_type == 3
				this.special_con.visible = info.mon_type == 1
				this.mon_con.visible = info.mon_type == 0
				if (info.mon_type == BossModel.MYSTERY_BOX_TYPE || info.mon_type == BossModel.MYSTERY_SUPER_BOX_TYPE) {
					this.SetBoxMsg(info)
				} else if (info.mon_type == BossModel.MYSTERY_SPECIAL_BOSS_TYPE) {
					this.SetSpecialBoss(info)
				} else {
					this.mon_num.innerHTML = Util.StrToHTML("击杀增加疲劳值：<font color='#00fa64'>" + info.anger + "</font>")
				}
			}
		}

		this.SetSpecialBoss = (info?) => {
			let now_num = this.boss_model.GetNowSpecialBossNum(info.layer)
			this.special_add_tired.innerHTML = Util.StrToHTML("击杀增加疲劳值：<font color='#00fa64'>" + info.anger + "</font>")
			this.special_num.innerHTML = Util.StrToHTML("当前场景内剩余：<font color='#00fa64'>" + now_num + "</font>")
		}

		this.SetBoxMsg = (info?) => {
			let num = this.boss_model.GetMaxBoxNumByType(info.mon_type, info.layer)
			let now_num = this.boss_model.GetNowBoxNum(info.mon_type, info.layer)
			this.add_tired.innerHTML = Util.StrToHTML("采集增加疲劳值：<font color='#00fa64'>" + info.anger + "</font>")
			this.left_box_num.innerHTML = Util.StrToHTML("当前场景内剩余：<font color='#00fa64'>" + now_num + "/" + num + "</font>")
			this.ClearTimer()
			let max = this.boss_model.GetMaxBoxNumByType(info.mon_type, info.layer)
			let now = this.boss_model.GetNowBoxNum(info.mon_type, info.layer)
			let is_max_num = max == now
			if (is_max_num) {
				this.refresh_time.innerHTML = Util.StrToHTML("刷新倒计时：<font color='#00fa64'>已刷新</font>")
			} else {
				this.StartBoxTimer()
			}
		}

		this.SwitchBoxShow = () => {
			if (this.boss_info) {
				if (this.boss_type_info && this.boss_type_info.boss_info) {
					let list = this.boss_type_info.boss_info
					let vo = null
					let i = list.length - 1
					do {
						vo = list[i]
						if (vo && vo.layer == this.boss_info.layer) {
							if ((vo.mon_type == BossModel.MYSTERY_SUPER_BOX_TYPE||vo.mon_type == BossModel.MYSTERY_BOX_TYPE)&& vo.boss_id != this.boss_info.boss_id) {
								this.SwitchView(vo)
								break
							}
						}
						i = i - 1
					} while ((i >= 0))
				}
			}
		}

		this.StartBoxTimer = () => {
			if (!this.reborn_timer) {
				let time_fun = () => {
					this.UpdateTime()
				}
				this.reborn_timer = GlobalTimerQuest.AddDelayQuest(time_fun, 1)
			}
			this.UpdateTime()
		}

		this.UpdateTime = () => {
			if (this.boss_info) {
				let left_time = this.boss_info.reborn_time - TimeUtil.getServerTime()
				if (left_time < 0) {
					this.boss_info.reborn_time = 0
					this.ClearTimer()
					this.refresh_time.innerHTML = Util.StrToHTML("刷新倒计时：<font color='#00fa64'>已刷新</font>")
					return
				}
				let time = TimeUtil.convertTime(left_time)
				this.refresh_time.innerHTML = Util.StrToHTML("刷新倒计时：<font color='#00fa64'>" + time + "</font>")
			}
		}

		this.ClearTimer = () => {
			if (this.reborn_timer) {
				GlobalTimerQuest.CancelQuest(this.reborn_timer)
				this.reborn_timer = null
			}
		}

		this.initRequestTimer = () => {
			if (!this.requestTimer) {
				let time_fun = () => {
					this.onTime()
				}
				this.requestTimer = GlobalTimerQuest.AddDelayQuest(time_fun, 10)
			}
			this.onTime()
		}

		this.onTime = () => {
			this.boss_model.Fire(BossModel.SCMD_REQUEST, 46000, this.boss_type)
			this.boss_model.Fire(BossModel.SCMD_REQUEST, 46039)
		}

		this.removeTimer = () => {
			if (this.requestTimer) {
				GlobalTimerQuest.CancelQuest(this.requestTimer)
				this.requestTimer = null
			}
		}

		this.SetRewardState = () => {
			if (this.boss_model.mystery_boss_reward) {
				let [stage_list, reach, all_len] = this.boss_model.GetMysteryBossRewardCfg(this.boss_model.mystery_boss_reward.kill_num, this.cfg_kill)
				let all_num = this.boss_model.GetMysteryBossNowStageNum(stage_list, this.boss_model.mystery_boss_reward.kill_num)
				this.progress_num.text = this.boss_model.mystery_boss_reward.kill_num + "/" + all_num
				this.SetRewardDot()
			}
		}

		this.SetRewardDot = () => {
			let show = this.boss_model.RefreshMBRewardDot(this.cfg_kill)
			this.red_dot.visible = show
		}
	}

	public DeleteMe() {
		if (this.room_item) {
			this.room_item.DeleteMe()
		}
		this.room_item = null

		if (this.reward_item_list) {
			for (let _tmpi in this.reward_item_list) {
				let vo = this.reward_item_list[_tmpi]
				vo.DeleteMe()
			}
			this.reward_item_list = null
		}

		this.ClearTimer()
		this.removeTimer()
		this.boss_id = null
		super.DeleteMe()
	}

	_Group1: Laya.Box
	_img_reward_bg: Laya.Image
	_Label1: Laya.Label
	_reward_con: Laya.Panel
	_Group2: Laya.Box
	_gp_model_con: Laya.Box
	_Image2: Laya.Image
	_lb_boss_name: Laya.Label
	_gp_attention: Laya.Box
	_Image1: Laya.Image
	attention: Laya.Image
	lb_atten: Laya.Label
	_gp_room_con: Laya.Box
	box_con: Laya.Box
	_Image3: Laya.Image
	left_box_num: Laya.HTMLDivElement
	refresh_time: Laya.HTMLDivElement
	add_tired: Laya.HTMLDivElement
	switchBtn: Laya.Image
	mon_con: Laya.Box
	_Image4: Laya.Image
	mon_num: Laya.HTMLDivElement
	special_con: Laya.Box
	_Image5: Laya.Image
	special_num: Laya.HTMLDivElement
	special_add_tired: Laya.HTMLDivElement
	_btn_drop: Laya.Image
	_btn_reward: Laya.Image
	red_dot: Laya.Image
	progress_num: Laya.Label
	public GetComponents() {
		[
			this._Group1,
			this._img_reward_bg,
			this._Label1,
			this._reward_con,
			this._Group2,
			this._gp_model_con,
			this._Image2,
			this._lb_boss_name,
			this._gp_attention,
			this._Image1,
			this.attention,
			this.lb_atten,
			this._gp_room_con,
			this.box_con,
			this._Image3,
			this.left_box_num,
			this.refresh_time,
			this.add_tired,
			this.switchBtn,
			this.mon_con,
			this._Image4,
			this.mon_num,
			this.special_con,
			this._Image5,
			this.special_num,
			this.special_add_tired,
			this._btn_drop,
			this._btn_reward,
			this.red_dot,
			this.progress_num,
		]
			= this.GetChildrenByNames([
				"_Group1",
				"_img_reward_bg",
				"_Label1",
				"_reward_con",
				"_Group2",
				"_gp_model_con",
				"_Image2",
				"_lb_boss_name",
				"_gp_attention",
				"_Image1",
				"attention",
				"lb_atten",
				"_gp_room_con",
				"box_con",
				"_Image3",
				"left_box_num",
				"refresh_time",
				"add_tired",
				"switchBtn",
				"mon_con",
				"_Image4",
				"mon_num",
				"special_con",
				"_Image5",
				"special_num",
				"special_add_tired",
				"_btn_drop",
				"_btn_reward",
				"red_dot",
				"progress_num",
			])
	}
}
window["BossMysteryEnterView"] = BossMysteryEnterView
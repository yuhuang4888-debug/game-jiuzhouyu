import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItem1 } from "../common/BaseItem1"
import { EventName } from "../common/EventName"
import { OpenFun } from "../common/OpenFun"
import { ResManager } from "../common/ResManager"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { DailyModel } from "../commonModel/DailyModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { RoleManager } from "../commonModel/RoleManager"
import { DailyEvent } from "../daily/DailyEvent"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest, Util } from "../util/Util"
import { Vector2 } from "../util/Vector2"
import { OnlineDrawHeadItem } from "./OnlineDrawHeadItem"

export class OnlineDrawView extends BaseItem1 {
	_img_timebg: Laya.Image
	_lb_time: Laya.Label
	_Group1: Laya.Box
	_headItem0: Laya.Box
	_headItem1: Laya.Box
	_headItem2: Laya.Box
	_img_show: Laya.Image
	_blb_date: Laya.Label
	_blb_cond: Laya.Label
	_Group2: Laya.Box
	_Image1: Laya.Image
	_gp_effect0: Laya.Box
	_gp_reward: Laya.Box
	_Image2: Laya.Image
	_Group3: Laya.HBox
	_fight_num: Laya.Label
	_img_bg0: Laya.Image
	_gp_effect: Laya.Box
	_mask: Laya.Box
	_img_descbg: Laya.Image
	_Image4: Laya.Image
	_gp_desc: Laya.VBox
	_Image5: Laya.Image
	_lb_day: Laya.Label
	_gp_tips: Laya.HBox
	_Image6: Laya.Image
	_Label1: Laya.Label
	_Group4: Laya.HBox
	_img_current: Laya.Image
	_lb_current: Laya.Label
	_btn_go: Laya.Box
	_Image7: Laya.Image
	_Label2: Laya.Label
	_img_red: Laya.Image
	_lb_end: Laya.Label
	left_time: Laya.Label

	private info
	private data
	private reward
	private draw_type
	private draw_all
	private timer
	private current = 0
	private win_item
	private desc_item = []

	//func
	InitView
	InitEvent
	CustomMehod
	RefOpenDay
	RefWinner
	RefCurrent
	RefDrawState
	OnTimer
	StopTimer
	GetProgress
	RequestData

	public constructor(parent) {
		super(parent)
		this.base_file = "onlineDraw"
		this.layout_file = "OnlineDrawView"
		let model = CustomActivityModel.GetInstance()
		let local_Util = Util
		let res_mgr = ResManager.GetInstance()
		let daily_model = DailyModel.GetInstance()
		let server_time_model = ServerTimeModel.GetInstance()
		let local_TimeUtil = TimeUtil
		let ActivityType = 1
		let LevelType = 2
		let local_Number = Number
		this.load_callback = () => {
			this.InitView()
			this.InitEvent()
		}
		this.preload_client_config = {
			"ConfigIllusionModel": false,
			"ConfigOnlineDraw": false
		}

		this.InitView = () => {
			if (!this.info) return
			let Mask_: Laya.Image;
			Mask_ = new Laya.Image();
			Mask_.graphics.drawRect(0, 0, this._img_bg0.width, this._img_bg0.height, "#ffffff");
			Mask_.pos(0, 0);
			//Mask_.pivot(0.5, 1)
			this._img_bg0.mask = Mask_
			let base_type = this.info.base_type
			let sub_type = this.info.sub_type

			let drawReach = model.getKeyDicValue(base_type, sub_type, "drawReach")
			if (drawReach) {
				model.SetRedDotValue(-1, base_type, sub_type)
				model.RefreshIconRed(base_type, sub_type)
			}

			let info_cond = model.GetActCondition(base_type, sub_type, "info")
			if (!info_cond) return
			this.data = model.GetActData(base_type, sub_type)
			if (!this.data) return

			let ltime = this.data.draw_time - TimeUtil.getServerTime()
			if (this.data.winner_list.length < 1 && ltime < 0) {
				this.RequestData()
			}

			this.draw_type = info_cond.draw_con[1] == "activity" ? ActivityType : LevelType
			this.draw_all = info_cond.draw_con[2]
			ResManager.GetInstance().SetImageSprite(this, this._img_timebg, "onlineDraw", `uizxhy_016_1`)
			ResManager.GetInstance().SetImageSprite(this, this._img_current, "onlineDraw", `uizxhy_015_${this.draw_type}`)
			ResManager.GetInstance().SetImageSprite(this, this._img_bg0, "onlineDraw", `uizxhy_002_${this.draw_type}`)
			let source = `uizxhy_004_${this.draw_type}`
			res_mgr.SetOutsideImageSprite(this, this._img_descbg, GameResPath.GetIconOtherPath("onlineDraw", source))

			//开奖信息图片
			let source1 = `uizxhy_012_${this.draw_type}`
			res_mgr.SetOutsideImageSprite(this, this._img_show, GameResPath.GetIconOtherPath("onlineDraw", source1))
			if(info_cond.type == 1){
				let draw_time = info_cond.draw_time[1]
				this._blb_date.text = `${draw_time[1]}M${draw_time[2]}D}`
			}else{
				let second = TimeUtil.getServerTimeMs()
				let date = new Date(second); //时间戳为10位需*1000，时间戳为13位的话不需乘1000
				let M = (date.getMonth() + 1 < 10 ? '0' + (date.getMonth() + 1) : date.getMonth() + 1);
				let D = (date.getDate() < 10 ? '0' + date.getDate() : date.getDate());
				this._blb_date.text = `${M}M${D}D`;
			}
			
			this._blb_cond.text = `${this.draw_all}`
			if (this.draw_type == ActivityType) {
				this._blb_cond.x = 300
			}

			// this.AddUIEffect("ui_huouye_frame", this._gp_effect0, undefined, undefined, true)
			// this.AddUIEffect(`ui_huouye_water${this.draw_type}`, this._gp_effect, undefined, undefined, true)
			this._gp_effect.mask = this._mask

			let ConfigOnlineDraw = ResManager.GetInstance().GetGameConfigFromCache(this, "ConfigOnlineDraw", true)
			if (ConfigOnlineDraw) {
				let desc_list = ConfigOnlineDraw[this.draw_type]
				if (desc_list) {
					let item: Laya.HTMLDivElement
					let content
					for (let i = 0; i < desc_list.describe.length; i++) {
						item = this.desc_item[i]
						content = desc_list.describe[i]
						if (i == 1) {
							if (this.draw_type == ActivityType) {
								content = `2.玩家当天4:00后到抽奖前活跃度达到${this.draw_all}<br><font color='#00fa64'>（活跃度每日4:00刷新）</font>`
							} else if (this.draw_type == LevelType) {
								content = `2.玩家在当天抽奖前，等级到达${this.draw_all}级。`
							}
						}
						if (!item) {
							item = new Laya.HTMLDivElement
							//item.fontSize = 20
							//item.lineSpacing = 14
							item.style.valign = "center"
							item.style.color = "#ffffff"
							item.style.wordWrap = false
							item.style.fontSize = 20
							item.style.leading = 5
							this._gp_desc.addChild(item)
							this.desc_item.push(item)
						}
						item.innerHTML = local_Util.StrToHTML(content)
					}
					GlobalTimerQuest.AddDelayQuest(() => {
						if (this.use_delete_method) return
						this._gp_desc.refresh()
					}, 0.1)
				}
			}
			if (this.draw_type == ActivityType)
				this._gp_tips.visible = true

			// 初始化大奖数据
			let reward_id = info_cond.reward && info_cond.reward[0] ? info_cond.reward[0][1] : undefined
			if (reward_id) {
				model.Fire(CustomActivityDefine.EVENT.SCMD_REQUEST, 33266, base_type, sub_type, Number(reward_id))
				if (!this.reward) {
					this.reward = new BaseAwardItem(this._gp_reward)
					this.reward.SetItemSize(85, 85)
					this.reward.Load()
				}
				let basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(reward_id)
				if (basic) {
					this.reward.SetData(reward_id, info_cond.reward[0][2])
				}
				let ConfigIllusionModel = ResManager.GetInstance().GetGameConfigFromCache(this, "ConfigIllusionModel", true)
				if (ConfigIllusionModel) {
					let model_cfg = ConfigIllusionModel[reward_id]
					// if (model_cfg) {
					// 	this._fight_num.text = `z${model_cfg.fight}`
					// }
					GlobalTimerQuest.AddDelayQuest(() => {
						if (this.use_delete_method) return
						this._Group3.refresh()
					}, 0.1)

				}
			}

			//倒计时
			if (!this.timer) {
				this.timer = GlobalTimerQuest.AddPeriodQuest(() => {
					this.OnTimer()
				}, 1, -1)
			}
			this.OnTimer()

			// 大奖获得者
			this.RefWinner()
			// 开服天数
			this.RefOpenDay()
			// 当前等级or活跃度
			this.RefCurrent()
			// 抽奖状态文本
			this.RefDrawState()

		}

		this.InitEvent = () => {
			// 开服天数跨天时刷新 this.BindEvent(GlobalEventSystem, ServerTimeModel.DAY_CHANGE, dayChange, true)
			let base_type = this.info.base_type
			let sub_type = this.info.sub_type

			local_Util.AddClickEvent(this._btn_go, () => {
				model.CloseACTRed(base_type, sub_type, null, this.info.show_id)
				model.setKeyDicValue(base_type, sub_type, "first_red", true)
				this._img_red.visible = false
				OpenFun.OpenFunHandler(82)
				model.online_draw_type = `${this.info.base_type}@${this.info.show_id}`
			}, this, true)

			this.BindEvent(model, CustomActivityDefine.EVENT.UPDATE_VIEW, (...args) => {
				if (args[0] == base_type && args[1] == sub_type) {
					this.data = model.GetActData(base_type, sub_type)
					this.RefWinner()
					this.RefDrawState()
				}
			})

			this.BindEvent(RoleManager.GetInstance().GetMainRoleVo(), EventName.CHANGE_LEVEL, (level) => {
				if (this.draw_type && this.draw_type == LevelType) {
					this.RefCurrent()
					this.RefDrawState()
				}
			})

			this.BindEvent(GlobalEventSystem, ServerTimeModel.DAY_CHANGE, () => {
				this.RefOpenDay()
			}, true)

			this.BindEvent(daily_model, DailyEvent.UPDATE_LIVENESS_REWARD, () => {
				if (this.draw_type && this.draw_type == ActivityType) {
					this.RefCurrent()
					this.RefDrawState()
				}
			})

			this.BindEvent(model, CustomActivityDefine.EVENT.UPDATE_FIGHTING_VALUE, (fight_value_list?) => {
				if(fight_value_list && Util.TableSize(fight_value_list) > 0){
					let fight_value = fight_value_list[this.info.sub_type]
					if(Number(fight_value) > 0){
						this._fight_num.text = `z${fight_value}`
					}else{
						this._fight_num.visible = false
					}
				}
			})
		}

		this.RequestData = () => {
			model.Fire(CustomActivityDefine.EVENT.SCMD_REQUEST, 33217, this.info.base_type, this.info.sub_type)
		}

		this.RefWinner = () => {
			if (!this.data) return
			if (!this.win_item) {
				this.win_item = []
			}
			let list = this.data.winner_list
			for (let i = 0; i < 3; i++) {
				let vo = list[i]
				let item: OnlineDrawHeadItem = this.win_item[i]
				if (!item) {
					item = new OnlineDrawHeadItem(this[`_headItem${i}`])
					item.Load()
					this.win_item[i] = item
				}
				item.ExcuteCallback(() => {
					item.SetData(i, vo)
					this[`_headItem${i}`].scaleY = 0.99
				})
			}
		}

		this.RefDrawState = () => {
			if (!this.data || !this.info) return
			let base_type = this.info.base_type
			let sub_type = this.info.sub_type

			let ltime = this.data.draw_time - TimeUtil.getServerTime()
			if (ltime >= 0 && this.data.winner_list.length < 1) {
				let progress = this.GetProgress()
				if (progress < 1) {
					//未开奖且未满足抽奖要求
					this._btn_go.visible = true
					this._lb_end.visible = false
					let dayfirst = model.GetDayFirstLoginStatus()
					if (dayfirst) {
						let first_red = model.getKeyDicValue(base_type, sub_type, "first_red")
						if (!first_red) {
							this._img_red.visible = true
						}
					} else {
						this._img_red.visible = false
					}

				} else {
					//未开奖且满足抽奖要求
					this._btn_go.visible = false
					this._lb_end.visible = true
					this._lb_end.text = `已满足抽奖条件\n不要错过时间哦`

					model.CloseACTRed(base_type, sub_type, null, this.info.show_id)
				}

			} else {
				//已开奖
				this._btn_go.visible = false
				this._lb_end.visible = true

				let str = ``
				let is_winner = this.data.is_winner
				switch (is_winner) {
					case 0:
						str = `很遗憾\n但有其他大奖等着你~`
						break
					case 1:
						str = `恭喜玩家\n抽中幸运大奖~`
						break
					case 2:
						str = `未满足抽奖条件\n没参与抽奖`
						break
				}
				this._lb_end.text = str

				model.CloseACTRed(base_type, sub_type, null, this.info.show_id)
			}
		}

		this.RefOpenDay = () => {
			this._lb_day.text = String(ServerTimeModel.GetInstance().GetOpenServerDay())
		}

		this.RefCurrent = () => {
			if (!this.draw_type) return
			let progress = this.GetProgress()
			this._lb_current.text = String(this.current)
			let height = this._img_bg0.height - progress * this._img_bg0.height
			let width = this._img_bg0.width
			let y = height
			this._img_bg0.mask.y = y
			// this._img_bg0.mask.graphics.clear()
			// this._img_bg0.mask.graphics.drawRect(0, 0, width, height, "#ffffff");
		}

		this.GetProgress = () => {
			if (!this.draw_type || !this.draw_all) return
			if (this.draw_type == ActivityType) {
				//活跃度
				this.current = 0
				let info81 = model.GetActCondition(this.info.base_type, this.info.sub_type, "info")
				if(!info81) return
				let curTime = local_TimeUtil.getServerTime()
				let date = new Date(curTime * 1000)
				let fit = false
				let hour = date.getHours()
				let type = info81.type ? Number(info81.type) : 1
				if (type == 1 && info81.draw_time) {//活跃度
					let year = date.getFullYear()
					let month = date.getMonth() + 1
					let day = date.getDate()
					if (info81.draw_time[1] && info81.draw_time[1][0]) {
						let real_time = info81.draw_time[1]
						if (local_Number(real_time[0]) == year && local_Number(real_time[1]) == month && local_Number(real_time[2]) == day) {
							fit = true
						}
					} else {
						let open_day = server_time_model.GetOpenServerDay()
						if (open_day == local_Number(info81.draw_time[1])) {
							fit = true
						}
					}
				}
				if (type == 2 || fit) {
					let ConfigOnlineDraw = ResManager.GetInstance().GetGameConfigFromCache(this, "ConfigOnlineDraw", true)
					if (ConfigOnlineDraw) {
						let cfg = ConfigOnlineDraw[this.draw_type]
						if (cfg && cfg.open_hour) {
							if (hour >= Number(cfg.open_hour)) {
								this.current = daily_model.liveness_reward ? daily_model.liveness_reward.live : 0
							}
						}
					}
				}
			} else if (this.draw_type == LevelType) {
				//等级
				this.current = RoleManager.GetInstance().mainRoleInfo.level
			}
			let progress = local_Util.Clamp(0, 1, this.current / this.draw_all)
			return progress
		}

		this.OnTimer = () => {
			if (this.data && this.data.draw_time) {
				let ltime = this.data.draw_time - TimeUtil.getServerTime()
				if (ltime >= 0) {
					this._lb_time.text = `${TimeUtil.timeConvert(ltime, "hh-mm-ss")}`
					this.left_time.width = 130
					if (ltime == 0) {
						this.RequestData()
					}
				} else {
					this._lb_time.text = "抽奖已结束"
					this.left_time.width = 0
					this.StopTimer()
					if (this.data.winner_list.length < 1) {
						this.RequestData()
					}
				}
				let parent = <Laya.HBox>this._lb_time.parent
				if(parent) parent.refresh()
			}
		}

		this.StopTimer = () => {
			if (this.timer) {
				GlobalTimerQuest.CancelQuest(this.timer)
				this.timer = null
			}
		}

		this.CustomMehod = (index, info) => {
			if (!info) return
			if(Array.isArray(info)){
				this.info = info[0]
			}else{
				this.info = info
			}
			
		}

		this.DeleteMe = () => {
			CustomActivityModel.GetInstance().online_draw_type = null
			this.StopTimer()

			if (this.reward) {
				this.reward.DeleteMe()
			}

			if (this.win_item && this.win_item.length > 0) {
				for (let item of this.win_item) {
					if (!item) continue
					item.DeleteMe()
				}
				this.win_item.length = 0
			}

			this.ClearUIEffect(this._gp_effect)
			this.ClearUIEffect(this._gp_effect0)
			super.DeleteMe()
		}
	}

	public GetComponents() {
		[
			this._img_timebg,
			this._lb_time,
			this._Group1,
			this._headItem0,
			this._headItem1,
			this._headItem2,
			this._img_show,
			this._blb_date,
			this._blb_cond,
			this._Group2,
			this._Image1,
			this._gp_effect0,
			this._gp_reward,
			this._Image2,
			this._Group3,
			this._fight_num,
			this._img_bg0,
			this._gp_effect,
			this._mask,
			this._img_descbg,
			this._Image4,
			this._gp_desc,
			this._Image5,
			this._lb_day,
			this._gp_tips,
			this._Image6,
			this._Label1,
			this._Group4,
			this._img_current,
			this._lb_current,
			this._btn_go,
			this._Image7,
			this._Label2,
			this._img_red,
			this._lb_end,
			this.left_time
		]
			= this.GetChildrenByNames([

				"_img_timebg",
				"_lb_time",
				"_Group1",
				"_headItem0",
				"_headItem1",
				"_headItem2",
				"_img_show",
				"_blb_date",
				"_blb_cond",
				"_Group2",
				"_Image1",
				"_gp_effect0",
				"_gp_reward",
				"_Image2",
				"_Group3",
				"_fight_num",
				"_img_bg0",
				"_gp_effect",
				"_mask",
				"_img_descbg",
				"_Image4",
				"_gp_desc",
				"_Image5",
				"_lb_day",
				"_gp_tips",
				"_Image6",
				"_Label1",
				"_Group4",
				"_img_current",
				"_lb_current",
				"_btn_go",
				"_Image7",
				"_Label2",
				"_img_red",
				"_lb_end",
				"left_time"
			])
		ResManager.GetInstance().LoadFont(this, "online_draw_fnt1", this._blb_date, 12);
		ResManager.GetInstance().LoadFont(this, "online_draw_fnt1", this._blb_cond, 12);
		ResManager.GetInstance().LoadFont(this, "online_draw_fnt", this._fight_num, 15);
	}
}
window["OnlineDrawView"] = OnlineDrawView
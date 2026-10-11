import { BaseItem1 } from "../common/BaseItem1"
import { Config } from "../common/Config"
import { EventName } from "../common/EventName"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { DiamondFightModel } from "../commonModel/DiamondFightModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest, Util } from "../util/Util"

export class DiamondFightEnterView extends BaseItem1 {

	diamond_fight_model: DiamondFightModel
	goods_model: GoodsModel
	server_time_model: ServerTimeModel
	res_mgr: ResManager
	stage_reward_list
	stage_reward_loop_mgr
	ticket_con
	time_func
	time_id


	public constructor(parent) {
		super(parent)

		this.base_file = "diamondFight"
		this.layout_file = "DiamondFightEnterView"

		this.diamond_fight_model = DiamondFightModel.GetInstance()
		this.goods_model = GoodsModel.GetInstance()
		this.server_time_model = ServerTimeModel.GetInstance()
		this.res_mgr = ResManager.GetInstance()

		this.time_id = null
		this.time_func = null

		this.load_callback = () => {
			this.LoadSuccess()
		}
	}

	public LoadSuccess() {
		//登录红点
		this.diamond_fight_model.login_red =false
		this.diamond_fight_model.UpdateRedforDiamond()

		this.res_mgr.SetOutsideImageSprite(this, this._img_title, GameResPath.GetIcon("diamondFight", "uizsdz_004"))

		this.res_mgr.SetOutsideImageSprite(this, this._img_bg2, GameResPath.GetIcon("diamondFight", "uizsdz_005"))

		this.res_mgr.SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("diamondFight", "uizsdz_006"))

		this.res_mgr.SetImageSpriteTrans(this, this._img_bg3, GameResPath.GetIcon("diamondFight", "uizsdz_002a"))

		this.res_mgr.SetOutsideImageSprite(this, this._img_enter_icon, GameResPath.GetGoodsIconPath(DiamondFightModel.TICKET_ID))
		this.res_mgr.SetOutsideImageSprite(this, this._img_ticket, GameResPath.GetGoodsIconPath(DiamondFightModel.TICKET_ID))


		this._html_desc.style.fontSize = 22
		// this._html_desc.style.wordWrap = false
		this._html_desc.style.color = "#ffffff"
		this._html_desc.style.leading = 16

		this._panel_desc.vScrollBarSkin = ""
		this.InitEvent()
		this.InitView()
	}

	public InitEvent() {

		this.BindVar(this.diamond_fight_model, "stage_info", () => {
			this.UpdateInfo()
			this.UpdateEffect()
		})

		this.BindVar(this.diamond_fight_model, "wait_tip_info", () => {
			this.UpdateEffect()
		})

		this.BindVar(this.diamond_fight_model, "user_info", () => {
			this.UpdateInfo()
		})

		this.BindEvent(this.goods_model, GoodsModel.UPDATE_GOODS_NUM, (goods_list?) => {
			if (this.use_delete_method) {
				return
			}
			for (let _tmpi in goods_list) {
				var v = goods_list[_tmpi]
				if (v.type_id == DiamondFightModel.TICKET_ID) {
					this.UpdateTicketNum()
					break
				}
			}
		})

		this.BindEvent(this.diamond_fight_model, DiamondFightModel.UPDATE_RECORD_RED_STATE, () => {
			this.UpdateRecordRed()
		})
		this.BindEvent(this.diamond_fight_model, DiamondFightModel.UPDATE_RED_STATE, () => {
			this.UpdateTicketNum()
		})

		Util.AddClickEvent(this._lb_recharge, () => {
			GlobalEventSystem.Fire(EventName.OPEN_ACT_VIEW, "331@6@0")
		}, this, true)

		Util.AddClickEvent(this._img_ticket, () => {
			UIToolTipMgr.GetInstance().AppendGoodsTips(DiamondFightModel.TICKET_ID)
		}, this, true)

		Util.AddClickEvent(this._box_enter, () => {
			let data = this.diamond_fight_model.stage_info
			let info = this.diamond_fight_model.user_info
			if (!data || !info) {
				if (this.server_time_model.GetOpenServerDay() <= DiamondFightModel.OPEN_DAY) {
					Message.show("开服" + DiamondFightModel.OPEN_DAY + "天后开启勾玉擂台")
				}
				return
			}

			switch (data.war_state) {
				case 0:
					Message.show("当前处于休战阶段，请耐心等待~")
					break
				case 1:
					if (info.is_sign == 1) {
						Message.show("您已报名，请等待进入下一阶段~")
					} else {
						let num = this.goods_model.GetTypeGoodsNum(DiamondFightModel.TICKET_ID)
						if (num >= 1) {
							this.diamond_fight_model.Fire(DiamondFightModel.REQUEST_SCMD, 13702)
						} else {
							Message.show("赛事报名需要一张勾玉擂台门票哦~")
						}
					}
					break
				case 2:
				case 3:
				case 4:
					this.diamond_fight_model.Fire(DiamondFightModel.REQUEST_SCMD, 13704)
					break
				case 5:
					Message.show("赛事已结束，请等待下一场比赛吧~")
					break
			}
		}, this, true)

		Util.AddClickEvent(this._img_check_battle, () => {
			let stage_info = this.diamond_fight_model.stage_info
			if (stage_info) {
				if (stage_info.war_state != 2 && stage_info.war_state != 3) {
					this.diamond_fight_model.Fire(DiamondFightModel.OPEN_VIEW, "DiamondFightBattleView")
					//this:Close()
				} else {
					Message.show("16强争霸战暂未开启")
				}
			} else {
				Message.show("暂无赛事")
			}
			// this.diamond_fight_model.Fire(DiamondFightModel.OPEN_VIEW, "DiamondFightBattleView")
		}, this, true)

	}

	public InitView() {

		this.InitRules()
		this.InitStageReward()
		this.UpdateInfo()
		this.UpdateTicketNum()
		this.UpdateEffect()
		this.UpdateRecordRed()
	}

	public UpdateInfo() {

		let stage_info = this.diamond_fight_model.stage_info
		let user_info = this.diamond_fight_model.user_info
		if (!stage_info || !user_info) {
			if (this.server_time_model.GetOpenServerDay() <= DiamondFightModel.OPEN_DAY) {
				this._box_enter.gray = true
			}
			return
		}

		let end_time
		switch (stage_info.war_state) {
			case 0:
				let bool = false
				this._lb_stage_info.visible = false
				this._lb_enter_state1.visible = false
				this._box_enter_state0.visible = true
				this._box_enter.gray = true
				break
			case 1:
				this._lb_stage_info.visible = true
				end_time = stage_info.end_time
				this.StartCountDown(() => {
					let left_time = end_time - TimeUtil.getServerTime()
					if (left_time < 0) {
						this._lb_stage_info.text = ""
						this.CancelCountDown()
						return
					}
					this._lb_stage_info.text = "报名：" + TimeUtil.timeConvert(left_time, "hh:MM:ss")
				}
				)
				if (user_info.is_sign == 1) {
					this._box_enter.gray = true
					this._lb_enter_state1.text = "已报名"
					this._box_enter_state0.visible = false
					this._lb_enter_state1.visible = true
				} else {
					this._box_enter.gray = false
					this._box_enter_state0.visible = true
					this._lb_enter_state1.visible = false
				}
				break
			case 2:
				this._lb_stage_info.visible = true
				this._box_enter_state0.visible = false
				this._lb_enter_state1.visible = true
				this._box_enter.gray = false
				this._lb_enter_state1.text = "进入战场"
				end_time = stage_info.end_time
				this.StartCountDown(() => {
					let left_time = end_time - TimeUtil.getServerTime()
					if (left_time < 0) {
						this._lb_stage_info.text = ""
						this.CancelCountDown()
						return
					}
					this._lb_stage_info.text = "进场：" + TimeUtil.timeConvert(left_time, "hh:MM:ss")
				}
				)
				break
			case 3:
			case 4:
				this._box_enter_state0.visible = false
				this._lb_enter_state1.visible = true
				this._lb_enter_state1.text = "进入战场"
				this._lb_stage_info.visible = true
				this._lb_stage_info.text = "活动进行中...."
				break
		}

	}

	public InitStageReward() {
		let config_drumwar_lv_to_zone = Config.PRELOAD_SERVER_CONFIG.config_drumwar_lv_to_zone
		let zone = DiamondFightModel.GetZoneByLv(null, config_drumwar_lv_to_zone)
		let list = []
		let config_drumwar_zone_reward = Config.PRELOAD_SERVER_CONFIG.config_drumwar_zone_reward
		let i = DiamondFightModel.MAX_ROUNDS

		if (i > 0) {
			do {
				let count = this.diamond_fight_model.GetTotalDiamond(zone, i, true, config_drumwar_zone_reward, config_drumwar_lv_to_zone)
				table.insert(list, { index: i, count: count })
				i = i - 1
			} while ((i > 0)
			)
		}

		this.stage_reward_list = list

		let item_class = window["DiamondFightEnterItem"]

		if (item_class) {
			if (this.stage_reward_loop_mgr) {
				this.stage_reward_loop_mgr.replaceAll(this.stage_reward_list)
			} else {
				this.stage_reward_loop_mgr = new LoopScrowViewMgr()
				this.stage_reward_loop_mgr.SetData(this._list_item, item_class, this.stage_reward_list, LoopScrCon.Vertical)
			}
		}
	}

	public InitRules() {

		let config_drumwar_lv_to_zone = Config.PRELOAD_SERVER_CONFIG.config_drumwar_lv_to_zone

		let str = "1、活动开启:"
		let drumwar_cfg = Config.PRELOAD_SERVER_CONFIG.config_drumwar_cfg
		let open_week = null
		let now_open_day = this.server_time_model.GetOpenServerDay()
		let open_day = null
		drumwar_cfg = drumwar_cfg && drumwar_cfg[0]
		if (drumwar_cfg) {
			drumwar_cfg = ErlangParser.GetInstance().Parse(drumwar_cfg.open_day)
			open_week = drumwar_cfg && Number(drumwar_cfg[0][0])
			open_week = open_week == 7 && 0 || open_week
		}
		if (open_week && drumwar_cfg) {
			let time = TimeUtil.getServerTime()
			let bool = true
			let time_date = null
			let now_day = null
			open_day = now_open_day

			while ((bool)) {
				time_date = new Date(time * 1000)
				now_day = time_date.getDay()
				if (now_day != open_week) {
					let n = open_week - now_day
					if (n > 0) {
						open_day = now_open_day + n
						time = time + n * 24 * 60 * 60
					} else {
						open_day = 7 + n + now_open_day
						time = time + (7 + n) * 24 * 60 * 60
					}
				}
				if (open_day >= DiamondFightModel.OPEN_DAY) {
					bool = false
				} else {
					open_day = open_day + 7
					time = time + 7 * 24 * 60 * 60
				}
			}
			time_date.setTime(time * 1000)
			let month = time_date.getMonth()
			let data = time_date.getDate()
			str = str + "<font color='#b3ff48'>" + ((month + 1)) + "月" + data + "日</font>"
		} else {
			str = str + "每周一"
		}
		str = str + " 报名时间:<font color='#b3ff48'>00:00-20:59</font> 活动时间:<font color='#b3ff48'>21:00-21:20</font><br>"
		str = str + "2、所属赛区:<font color='#b3ff48'>" + this.diamond_fight_model.GetDistrictDesc(null, config_drumwar_lv_to_zone) + "</font><br>"
		str = str + "3、开服天数≥5开放勾玉擂台活动<br>4、报名勾玉擂台需要消耗勾玉擂台门票，每日首充可获得门票。<br>5、勾玉擂台为跨服玩法，即多个服务器的玩家将根据等级划分赛区一起进行活动，不同赛区之间互不影响。<br>6、勾玉擂台分为海选赛和争霸赛两个环节；海选赛分为8轮随机匹配，两两玩家进行对战，胜利则晋级下一轮，失败则淘汰，直到8轮匹配结束剩余16强玩家；争霸赛即是16强玩家两两进行对战淘汰赛，一共进行4轮最终决出活动冠军。<br>7、参与勾玉擂台无论胜利或失败均可获得绑玉奖励，所以胜利的场次越多就可以获得更多的绑玉哦！<br>8、勾玉擂台争霸赛开始后可进行竞猜，竞猜正确可获得绑玉奖励，切勿错过哦！"
		this._html_desc.innerHTML = str
		this._html_desc.style.width = 660
		this._panel_desc.callLater(()=>{
			if(this.use_delete_method) return
			this._panel_desc.refresh()
		})
	}

	public CancelCountDown() {
		if (this.time_id) {
			GlobalTimerQuest.CancelQuest(this.time_id)
			this.time_id = null
		}
	}

	public StartCountDown(func?) {

		this.CancelCountDown()
		this.time_id = GlobalTimerQuest.AddPeriodQuest(func, 1, -1)
		func()
	}

	public UpdateTicketNum() {
		let item_num = this.goods_model.GetTypeGoodsNum(DiamondFightModel.TICKET_ID)
		this._lb_count.text = "x" + item_num
		this._img_btn_red.visible = item_num>0&&!this.diamond_fight_model.HasSignUp()&&this.diamond_fight_model.IsSignUpBefore()
	}

	public UpdateEffect() {
		let wait_tip_info = this.diamond_fight_model.wait_tip_info
		let stage_info = this.diamond_fight_model.stage_info
		if (wait_tip_info && stage_info && stage_info.war_state == 4 && wait_tip_info.type == 2) {
			this._lb_tips.visible = this._img_tips.visible = true
		} else {
			this._lb_tips.visible = this._img_tips.visible = false
			// this.ClearUIEffect(this._gp_check_effect)
		}
	}

	public UpdateRecordRed() {

		let bool = this.diamond_fight_model.GetRecordRedState()
		this._img_check_battle_red.visible = bool
	}

	public DeleteMe() {

		this.CancelCountDown()
		if (this.stage_reward_loop_mgr) {
			this.stage_reward_loop_mgr.DeleteMe()
			this.stage_reward_loop_mgr = null
		}
		// this.ClearUIEffect(this._gp_check_effect)
		// this.ClearUIEffect(this._gp_enter_effect)

		super.DeleteMe()
	}



	_img_title: Laya.Image
	_img_check_battle: Laya.Image
	_img_bg2: Laya.Image
	_img_tips: Laya.Image
	_img_bg: Laya.Image
	_img_bg1: Laya.Image
	_img_bg3: Laya.Image
	_img_bg4: Laya.Image
	_img_bg5: Laya.Image
	_lb_title: Laya.Label
	_lb_title2: Laya.Label
	_lb_tip2: Laya.Label
	_lb_title3: Laya.Label
	_lb_stage_info: Laya.Label
	_lb_tips: Laya.Label
	_lb_tips2: Laya.Label
	_lb_recharge: Laya.Label
	_lb_tips3: Laya.Label
	_lb_count: Laya.Label
	_img_check_battle_red: Laya.Image
	_box_enter: Laya.Box
	_img_enter: Laya.Image
	_box_enter_state0: Laya.HBox
	_lb_enter_state00: Laya.Label
	_img_enter_icon: Laya.Image
	_lb_enter_state01: Laya.Label
	_lb_enter_state1: Laya.Label
	_box_enter_effect: Laya.Box
_img_btn_red:Laya.Image
	_box_check_effect: Laya.Box
	_list_item: Laya.List
	_panel_desc: Laya.Panel
	_html_desc: Laya.HTMLDivElement
	_img_ticket: Laya.Image
	public GetComponents() {
		[
			this._img_title,
			this._img_check_battle,
			this._img_bg2,
			this._img_tips,
			this._img_bg,
			this._img_bg1,
			this._img_bg3,
			this._img_bg4,
			this._img_bg5,
			this._lb_title,
			this._lb_title2,
			this._lb_tip2,
			this._lb_title3,
			this._lb_stage_info,
			this._lb_tips,
			this._lb_tips2,
			this._lb_recharge,
			this._lb_tips3,
			this._lb_count,
			this._img_check_battle_red,
			this._box_enter,
			this._img_enter,
			this._box_enter_state0,
			this._lb_enter_state00,
			this._img_enter_icon,
			this._lb_enter_state01,
			this._lb_enter_state1,
			this._box_enter_effect,
this._img_btn_red,
			this._box_check_effect,
			this._list_item,
			this._panel_desc,
			this._html_desc,
			this._img_ticket,
		]
			= this.GetChildrenByNames([

				"_img_title",
				"_img_check_battle",
				"_img_bg2",
				"_img_tips",
				"_img_bg",
				"_img_bg1",
				"_img_bg3",
				"_img_bg4",
				"_img_bg5",
				"_lb_title",
				"_lb_title2",
				"_lb_tip2",
				"_lb_title3",
				"_lb_stage_info",
				"_lb_tips",
				"_lb_tips2",
				"_lb_recharge",
				"_lb_tips3",
				"_lb_count",
				"_img_check_battle_red",
				"_box_enter",
				"_img_enter",
				"_box_enter_state0",
				"_lb_enter_state00",
				"_img_enter_icon",
				"_lb_enter_state01",
				"_lb_enter_state1",
				"_box_enter_effect",
"_img_btn_red",
				"_box_check_effect",
				"_list_item",
				"_panel_desc",
				"_html_desc",
				"_img_ticket",
			])
	}
}
window["DiamondFightEnterView"] = DiamondFightEnterView
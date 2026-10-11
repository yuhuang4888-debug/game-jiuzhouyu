import { BaseItem1 } from "../common/BaseItem1"
import { ResManager } from "../common/ResManager"
import { ListDuobaoModel } from "../commonModel/ListDuobaoModel"
import { NotEnougnDiamond, Util } from "../util/Util"
import { Config } from "../common/Config"
import { BaseAwardItem } from "../common/BaseAwardItem"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventName } from "../common/EventName"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { GameResPath } from "../util/GameResPath"
import { Enum_Btn_Type } from "../commonModel/CustomActivityDefine"
import { Enum_Currency_Type } from "../commonModel/CustomActivityDefine"
import { LoopScrowViewMgr, LoopScrCon } from "../common/LoopScrowViewMgr"
import { ListRankItemBig } from "./ListRankItemBig"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"

import "./ListRankView"
import "./ListRewardView"
import "./ListDuobaoRecordView"
import { RoleManager } from "../commonModel/RoleManager"
import { Message } from "../sysInfo/SysInfoController"
import { Mathf } from "../util/Mathf"
import { Alert, Alert_Type } from "../alert/Alert"
import { CongratulationObtainView } from "../common/CongratulationObtainView"
import { CycleimpActlistEvent, CycleimpActlistModel } from "../commonModel/CycleimpActlistModel"

export class ListDuobaoView extends BaseItem1 {
	model
	custom_model
	res_mgr

	info
	score
	need_score
	stage_id
	stage_type
	one_cost
	ten_cost
	item_list
	time_item
	one_btn
	ten_btn
	player_loop_mgr

	public constructor(parent) {
		super(parent)
		this.base_file = "listDuobao"
		this.layout_file = "ListDuobaoView"

		this.model = ListDuobaoModel.GetInstance()
		this.res_mgr = ResManager.GetInstance()
		this.custom_model = CustomActivityModel.GetInstance()

		this.score = 0
		this.item_list = []

		this.load_callback = () => {
			this.LoadSuccess()
			this.InitEvent()
		}
	}

	public CustomMehod(index?, _info?) {
		this.info = _info
	}

	public DeleteMe() {
		if (this.player_loop_mgr) {
			this.player_loop_mgr.DeleteMe()
			this.player_loop_mgr = null
		}
		if (this.ten_btn) {
			this.ten_btn.DeleteMe()
			this.ten_btn = null
		}
		if (this.one_btn) {
			this.one_btn.DeleteMe()
			this.one_btn = null
		}
		if (this.time_item) {
			this.time_item.DeleteMe()
			this.time_item = null
		}
		for (let i in this.item_list) {
			let item = this.item_list[i]
			if (item) {
				item.DeleteMe()
			}
		}
		this.item_list = []
		super.DeleteMe()
	}

	private LoadSuccess() {
		this.model.Fire(ListDuobaoModel.REQUEST_SCMD, 33252, this.model.base_type, this.model.sub_type)
		this.model.Fire(ListDuobaoModel.REQUEST_SCMD, 33253, this.model.base_type, this.model.sub_type)
		this.res_mgr.SetOutsideImageSprite(this, this._img_bg, "resource/game/listDuobao/other/ui_cbdb_bg_01.png")
		this.res_mgr.SetOutsideImageSprite(this, this._img_bg4, "resource/game/listDuobao/other/ui_cbdb_bg_12.png")
		this.res_mgr.SetOutsideImageSprite(this, this._gp_title, "resource/game/listDuobao/other/ui_cbdb_01.png")

		this._lb_tips.style.fontSize = 18
		this._lb_tips.style.color = "#663915"
		this._lb_tips.style.wordWrap = false

		this.AddUIEffect("UI_1003", this._gp_effect, null, 5, true)

		this.model.first_in = false
		this.model.UpdateRed()
	}

	private InitEvent() {
		Util.AddClickEvent(this._img_bg2, () => {
			this.model.Fire(ListDuobaoModel.OPEN_VIEW, "ListRankView")
		}, this)

		Util.AddClickEvent(this._img_arr, () => {
			this.model.Fire(ListDuobaoModel.OPEN_VIEW, "ListRankView")
		}, this, true)

		Util.AddClickEvent(this._gp_rank, () => {
			this.model.Fire(ListDuobaoModel.OPEN_VIEW, "ListRankView")
		}, this)

		Util.AddClickEvent(this._btn1, () => {
			GlobalEventSystem.Fire(EventName.OPEN_INSTRUCTION_VIEW, 332116)
		}, this, true)

		Util.AddClickEvent(this._btn2, () => {
			this.model.Fire(ListDuobaoModel.OPEN_VIEW, "ListDuobaoRecordView")
		}, this, true)

		Util.AddClickEvent(this._btn3, () => {
			if (this.stage_type == 1) {
				this.model.Fire(ListDuobaoModel.REQUEST_SCMD, 33254, this.model.base_type, this.model.sub_type, this.stage_id)
			} else {
				this.model.Fire(ListDuobaoModel.OPEN_VIEW, "ListRewardView")
			}
		}, this, true)

		Util.AddClickEvent(this._btn_one, () => {
			if (this.one_cost) {
				this.BtnHandle(1)
			}
		}, this, true)

		Util.AddClickEvent(this._btn_ten, () => {
			if (this.ten_cost) {
				this.BtnHandle(10)
			}
		}, this, true)

		this.BindEvent(this.model, ListDuobaoModel.UPDATE_MAIN_VIEW, () => {
			this.UpdateView()
		})

		this.BindEvent(this.model, ListDuobaoModel.UPDATE_RANK, () => {
			this.UpdateRank()
		})

		this.BindVar(RoleManager.GetInstance().GetMainRoleVo(), "jinLock", () => {
			this.UpdateBtn()
		})

		// 领取奖励回调
		this.BindEvent(CustomActivityModel.GetInstance(), CustomActivityDefine.EVENT.ANSWER_TARGET, (...new_args) => {
			let args = new_args;
			if (this.model.base_type == args[0] && this.model.sub_type == args[1]) {
				CustomActivityModel.GetInstance().Fire(CustomActivityDefine.EVENT.UPDATE_TAB_RED, "331_cycle", CycleimpActlistModel.GetInstance().CheckActData())
				CycleimpActlistModel.GetInstance().Fire(CycleimpActlistEvent.UPDATE_CYCLEIMPACTLIT_RED);
			}
		});
	}

	private BtnHandle(count) {
		let cost = count == 1 ? this.one_cost : this.ten_cost
		let need = Number(cost[2])
		let have = 0
		if (Number(this.one_cost[0]) == 2) {
			have = RoleManager.GetInstance().GetMainRoleVo().jinLock
		}

		if (have >= need) {
			this.custom_model.Fire(CustomActivityDefine.EVENT.SCMD_REQUEST, 33191, this.model.base_type, this.model.sub_type, count, false)
		} else {
			let all = RoleManager.GetInstance().GetMainRoleVo().jin + have
			if (all >= need) {
				let ok_func = () => {
					this.custom_model.Fire(CustomActivityDefine.EVENT.SCMD_REQUEST, 33191, this.model.base_type, this.model.sub_type, count, true)
				}
				if (this.model.is_openAlert) {
					let check_func = () => {
						this.model.is_openAlert = false
					}
					let num = need - have
					Alert.Show("绑玉不足，是否消耗" + num + "勾玉进行抽奖？", Alert_Type.AlertTypeCheckBox, ok_func, null, null, null, null, null, check_func)
					Alert.SetIsCharge(true)
				} else {
					ok_func()
				}
			} else {
				NotEnougnDiamond("勾玉不足，是否前往充值？")
			}
		}
	}

	private UpdateView() {
		this.UpdateReward()
		this.UpdateStage()
		this.UpdateBtn()

		if (!this.time_item) {
			this.time_item = this.custom_model.LoadActTimer(this._gp_time, this.info.etime, 18, "#0a953e", null, "#663915", "活动倒计时：")
		}
	}

	private UpdateReward() {
		let data = this.model.reward_list
		if (!data) {
			return
		}
		for (let i in data) {
			let vo = data[i]
			let item = this.item_list[i]
			if (!item) {
				let parent = this["_gp" + i]
				item = new BaseAwardItem(parent)
				item.Load()
				item.SetItemSize(85, 85)
				this.item_list[i] = item
			}
			item.ExcuteCallback(() => {
				let type_id = vo.reward[0].typeId
				let num = vo.reward[0].count
				item.SetData(type_id, num)
			})
		}
	}

	private UpdateStage() {
		this._lb_tips.innerHTML = "每次抽奖可获得" + "<font color='#0a953e'>10</font>" + "积分"
		this.score = this.model.score
		let stage_list = this.model.stage_list
		if (!stage_list) {
			return
		}
		for (let i in stage_list) {
			let vo = stage_list[i]
			if (vo.got_type != 2 || Number(i) == stage_list.length - 1) {
				this.stage_id = vo.id
				this.stage_type = vo.got_type
				break
			}
		}
		let icon = this.stage_type == 1 ? "icon_cbdb_04" : "icon_cbdb_03"
		this._gp_effect.visible = this.stage_type == 1
		this.res_mgr.SetImageSprite(this, this._btn3, "listDuobao", icon)
		let cfg = Config.PRELOAD_SERVER_CONFIG.config_rush_treasure_stage_reward
		let key = this.model.base_type + "@" + this.model.sub_type + "@" + this.stage_id
		if (!cfg || !cfg[key]) {
			return
		}
		this.need_score = cfg[key].need_val
		this._lb_pro.text = this.score + "/" + this.need_score
		let val = Mathf.Min(1, this.score / this.need_score)
		this._img_fill.width = 422 * val
		this._red.visible = this.model.stage_red
	}

	private UpdateBtn() {
		let cond = this.custom_model.GetActCondition(this.info.base_type, this.info.sub_type, "info")
		if (!cond) {
			return
		}
		if (cond.one_cost) {
			this.one_cost = cond.one_cost[0]
			if (Number(this.one_cost[0]) == 2) {
				this.res_mgr.SetImageSprite(this, this._img_cost1, "common", "com_bind_diamond")
				let have = RoleManager.GetInstance().GetMainRoleVo().jinLock
				let need = Number(this.one_cost[2])
				this._lb_have1.color = have >= need ? "#0a953e" : "#ff4f50"
				this._lb_have1.text = " " + have
				this._lb_cost1.text = "/" + need
			}
		}

		if (cond.ten_cost) {
			this.ten_cost = cond.ten_cost[0]
			if (Number(this.ten_cost[0]) == 2) {
				this.res_mgr.SetImageSprite(this, this._img_cost10, "common", "com_bind_diamond")
				let have = RoleManager.GetInstance().GetMainRoleVo().jinLock
				let need = Number(this.ten_cost[2])
				this._lb_have10.color = have >= need ? "#0a953e" : "#ff4f50"
				this._lb_have10.text = " " + have
				this._lb_cost10.text = "/" + need
			}
		}
	}

	private UpdateRank() {
		/* 	let list = [
				this.model.player_rank_list[0],
				this.model.player_rank_list[1]
			] */
		let list: any[] = this.model.player_rank_list;
		if (!this.player_loop_mgr) {
			this.player_loop_mgr = new LoopScrowViewMgr()
			this.player_loop_mgr.SetData(this._gp_rank, ListRankItemBig, list, LoopScrCon.Vertical)
		} else {
			this.player_loop_mgr.replaceAll(list)
		}


		let index: number = list.findIndex((rank: any) => {
			return rank.role_id == RoleManager.GetInstance().GetMainRoleId();
		});

		this._gp_rank.tweenTo(Math.max(0, index - 1));


	}

	_img_bg: Laya.Image
	_img_bg2: Laya.Image
	_img_bg3: Laya.Image
	_img_bg4: Laya.Image
	_gp_title: Laya.Image
	_lb_title: Laya.Label
	_img_arr: Laya.Image
	_img1: Laya.Image
	_lb1: Laya.Label
	_gp_item: Laya.Box
	_gp0: Laya.Box
	_gp1: Laya.Box
	_gp2: Laya.Box
	_gp3: Laya.Box
	_gp4: Laya.Box
	_gp5: Laya.Box
	_gp6: Laya.Box
	_gp7: Laya.Box
	_gp8: Laya.Box
	_gp9: Laya.Box
	_gp10: Laya.Box
	effect1: Laya.Image
	_gp11: Laya.Box
	effect2: Laya.Image
	_gp_rank: Laya.List
	_btn1: Laya.Image
	_btn2: Laya.Image
	_btn3: Laya.Image
	_red: Laya.Image
	_btn4: Laya.Box
	_lb_tips: Laya.HTMLDivElement
	_lb_time: Laya.Label
	_gp_time: Laya.Box
	_gp_pro: Laya.Image
	_img_fill: Laya.Image
	_lb_pro: Laya.Label
	_gp_one: Laya.Box
	_btn_one: Laya.Image
	_lb_one: Laya.Label
	_gp_cost1: Laya.HBox
	_img_cost1: Laya.Image
	_lb_have1: Laya.Label
	_lb_cost1: Laya.Label
	_gp_ten: Laya.Box
	_btn_ten: Laya.Image
	_lb_ten: Laya.Label
	_gp_cost10: Laya.HBox
	_img_cost10: Laya.Image
	_lb_have10: Laya.Label
	_lb_cost10: Laya.Label
	_gp_effect: Laya.Box
	public GetComponents() {
		[
			this._img_bg,
			this._img_bg2,
			this._img_bg3,
			this._img_bg4,
			this._gp_title,
			this._lb_title,
			this._img_arr,
			this._img1,
			this._lb1,
			this._gp_item,
			this._gp0,
			this._gp1,
			this._gp2,
			this._gp3,
			this._gp4,
			this._gp5,
			this._gp6,
			this._gp7,
			this._gp8,
			this._gp9,
			this._gp10,
			this.effect1,
			this._gp11,
			this.effect2,
			this._gp_rank,
			this._btn1,
			this._btn2,
			this._btn3,
			this._red,
			this._btn4,
			this._lb_tips,
			this._lb_time,
			this._gp_time,
			this._gp_pro,
			this._img_fill,
			this._lb_pro,
			this._gp_one,
			this._btn_one,
			this._lb_one,
			this._gp_cost1,
			this._img_cost1,
			this._lb_have1,
			this._lb_cost1,
			this._gp_ten,
			this._btn_ten,
			this._lb_ten,
			this._gp_cost10,
			this._img_cost10,
			this._lb_have10,
			this._lb_cost10,
			this._gp_effect,
		]
			= this.GetChildrenByNames([
				"_img_bg",
				"_img_bg2",
				"_img_bg3",
				"_img_bg4",
				"_gp_title",
				"_lb_title",
				"_img_arr",
				"_img1",
				"_lb1",
				"_gp_item",
				"_gp0",
				"_gp1",
				"_gp2",
				"_gp3",
				"_gp4",
				"_gp5",
				"_gp6",
				"_gp7",
				"_gp8",
				"_gp9",
				"_gp10",
				"effect1",
				"_gp11",
				"effect2",
				"_gp_rank",
				"_btn1",
				"_btn2",
				"_btn3",
				"_red",
				"_btn4",
				"_lb_tips",
				"_lb_time",
				"_gp_time",
				"_gp_pro",
				"_img_fill",
				"_lb_pro",
				"_gp_one",
				"_btn_one",
				"_lb_one",
				"_gp_cost1",
				"_img_cost1",
				"_lb_have1",
				"_lb_cost1",
				"_gp_ten",
				"_btn_ten",
				"_lb_ten",
				"_gp_cost10",
				"_img_cost10",
				"_lb_have10",
				"_lb_cost10",
				"_gp_effect",
			])
	}
}
window["ListDuobaoView"] = ListDuobaoView
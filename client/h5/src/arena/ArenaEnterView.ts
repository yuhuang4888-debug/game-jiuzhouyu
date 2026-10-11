import { BaseItem1 } from "../common/BaseItem1"
import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { CommonManager } from "../common/CommonManager"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { ArenaModel } from "../commonModel/ArenaModel"
import { TaskTipType } from "../commonModel/TaskModel"
import { RoleManager } from "../commonModel/RoleManager"
import { ClientConfig, GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { Mathf } from "../util/Mathf"
import { Runner } from "../util/Runner"
import { SYTweenFunc } from "../util/SYTweenFunc"
import { SYTweenLite } from "../util/SYTweenLite"
import { TimeUtil } from "../util/TimeUtil"
import { SetAnchoredPositionX, Util, HtmlColorTxt, GlobalTimerQuest, SetSizeDeltaY, GetSizeDeltaY, SetAnchoredPositionY } from "../util/Util"
import { ArenaEnterRoleItem } from "./ArenaEnterRoleItem"
import { PlatformManager } from "../PlatformManager"
import { HaloModel, HaloPrivilegeType } from "../commonModel/HaloModel"
import { Alert, Alert_Type } from "../alert/Alert"

export class ArenaEnterView extends BaseItem1 {

	InitEvent
	LoadSuccess
	Local_DeleteMe
	OnTime
	Scr_scroll_con
	SetRedDot
	StartTimer
	StopTimer
	Update
	UpdateChallenger
	UpdateInfo
	UpdateTimesInfo
	UpdateHalo
	InitHalo
	UpdateMergeCheckBox


	_end_time
	_need_update_challenger
	_time
	_update_challenger_vo
	_view_con
	createChildren
	item_list
	story_obj_list
	timer
	times_info
	tween_id
	run_id

	public constructor(parent?) {
		super(parent)

		this._time = 0
		this._end_time = null
		this._need_update_challenger = false
		this._update_challenger_vo = null
		this.item_list = null
		this.timer = null
		this.times_info = null
		this.tween_id = null

		this.base_file = "arena"
		this.layout_file = "ArenaEnterView"
		this.layer_value = Enum_UILayer.UI
		let model = ArenaModel.GetInstance()
		let local_ArenaModel = ArenaModel
		let local_TimeUtil = TimeUtil
		let runner = Runner.GetInstance()
		let cloud_width = 752

		this.load_callback = () => {
			this._scroll_con.vScrollBarSkin = ""
			this.AddUIEffect("ZengJia", this._box_time_effect, { x: 0, y: 0 }, 25, true)
			this.LoadSuccess()
			this.InitEvent()
		}

		//第一次添加到舞台的时候调用
		this.createChildren = () => {
			this.story_obj_list = this.story_obj_list || {}
			this.story_obj_list[TaskTipType.Fin_glad] = []
			this.story_obj_list[TaskTipType.Fin_glad][1] = [BaseWindowComponent.CURR_BASE_WINDOW_COMPONENT._story_bar2]
			super.createChildren()
		}

		this.LoadSuccess = () => {
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_left, GameResPath.GetIcon("arena", "uijj_002a"))

			model.Fire(local_ArenaModel.REQUEST_CCMD_EVENT, 28001)
			model.Fire(local_ArenaModel.REQUEST_CCMD_EVENT, 28002)
			model.Fire(local_ArenaModel.REQUEST_CCMD_EVENT, 28004)

			this.SetRedDot()

			// ResManager.GetInstance().SetOutsideImageSprite(this, this._view_con, GameResPath.GetModelMask("rect_mask"), false)

			this.run_id = runner.AddRunObj(this)
			this.InitHalo()
		}

		this.InitEvent = () => {
			this.BindVar(model, "page_info", (event_name?, value?, old_value?) => {
				this.UpdateInfo(value)
				if (this._need_update_challenger) {
					this._need_update_challenger = false
					this.UpdateChallenger(this._update_challenger_vo)
				}
			}
			)

			this.BindVar(model, "challenge_player_list", (event_name?, value?, old_value?) => {
				this.UpdateChallenger(value)
			}
			)

			this.BindVar(model, "times_info", (event_name?, value?, old_value?) => {
				this.times_info = value
				this.UpdateTimesInfo()
			}
			)

			this.BindVar(model, "breach_dot", (event_name?, value?, old_value?) => {
				this.SetRedDot()
			}
			)

			Util.AddClickEvent(this._gp_rank, () => {
				let jump_bool = CommonManager.GetInstance().CheckFuncOpenState("RankEntView")
				if (jump_bool) {
					GlobalEventSystem.Fire(EventName.OPEN_RANK_VIEW, 0, 7, 48)
				}
			}, this, true)

			Util.AddClickEvent(this._gp_rank_reward, () => {
				model.Fire(local_ArenaModel.OPEN_VIEW, "ArenaRankRewardMainView")
			}, this, true)

			Util.AddClickEvent(this._gp_battle_record, () => {
				model.Fire(local_ArenaModel.OPEN_VIEW, "ArenaBattleRecordView")
			}, this, true)

			Util.AddClickEvent(this._img_refresh, () => {
				this._scroll_con.vScrollBar.stopScroll()
				model.Fire(local_ArenaModel.REQUEST_CCMD_EVENT, 28002)
			}, this, true)

			Util.AddClickEvent(this._img_add, () => {
				if (this.times_info) {
					if (PlatformManager.GetInstance().is_alpha) return
					model.Fire(local_ArenaModel.OPEN_VIEW, "ArenaBuyTimesView", this.times_info.can_buy_num, 280)
				}
			}
				, this, true)

			let update_func = () => {
				if (!this.use_delete_method) {
					if (this._gp_item_con.anchorY < 200) {
						this._img_tips_arrow.visible = false
					} else {
						this._img_tips_arrow.visible = true
					}
				}
			}
			// this.Scr_scroll_con.onValueChanged.AddListener(() => {
			// 	update_func()
			// })

			// this.tween_id = SYTweenLite.to(this, this._img_tips_arrow, SYTweenLite.UiAnimationType.POSY, -60, 1.6, null, SYTweenFunc.PINGPONG, true)

		}

		this.InitHalo = () => {
			//光环
			this.UpdateHalo()
			Util.AddClickEvent(this._lb_halo_tips, () => {
				GlobalEventSystem.Fire(EventName.OPEN_VIEW, "HaloMainView")
			}, this, false)

			Util.AddClickEvent(this._img_merge_count, () => {
				if(!HaloModel.GetInstance().CheckPrivilegeOpenState(HaloPrivilegeType.ArenaSweep)){
                    return
                }
				let state = HaloModel.GetInstance().GetSettingData(HaloPrivilegeType.ArenaSweep, 0)
				if (!state) {
					let str = "勾选后,本次竞技场将合并所有次数进入.<br>是否确认勾选?"
					let content = Util.StrToHTML(str)
					Alert.Show(
						content,
						Alert_Type.Two, () => {
							HaloModel.GetInstance().Fire(HaloModel.REQUEST_SCMD, 51402, "hhc", HaloPrivilegeType.ArenaSweep, 0, 1)
						}
					)
				} else {
					HaloModel.GetInstance().Fire(HaloModel.REQUEST_SCMD, 51402, "hhc", HaloPrivilegeType.ArenaSweep, 0, 0)
				}
			}, this, true)

			this.BindEvent(HaloModel.GetInstance(), HaloModel.RecvFmt51302, (id, type) => {
				if (id == HaloPrivilegeType.ArenaSweep) {
					this.UpdateMergeCheckBox()
				}
			}
			)
			this.UpdateMergeCheckBox()
		}

		this.UpdateHalo = () => {
			if (HaloModel.GetInstance().GetOpenState()) {
				this._box_halo.visible = true
				if (HaloModel.GetInstance().GetHaloOpenState()) {
					this._img_merge_count.visible = true
					this._lb_halo_tips.visible = false
				}
				else {
					this._img_merge_count.visible = false
					this._lb_halo_tips.visible = true
				}
			}
			else {
				this._box_halo.visible = false
			}
		}

		this.UpdateMergeCheckBox = () => {
			let state = HaloModel.GetInstance().GetSettingData(HaloPrivilegeType.ArenaSweep, 0)
			this._img_merge_count.skin = GameResPath.GetIcon("common", state && "com_ui_gx1" || "com_ui_gx")
		}

		this.UpdateInfo = (vo?) => {
			this._lb_my_rank.text = vo.rank > 0 && vo.rank || "未上榜"
			this._lb_my_fighting.text = String(RoleManager.GetInstance().GetMainRoleVo().fighting)
		}

		this.UpdateTimesInfo = () => {
			let vo = this.times_info
			let max_count = model.GetCfgKeyValue(1)
			let add_count_time = model.GetCfgKeyValue(17)

			if (vo.num_refresh == 0) {
				if (vo.left_num == 0) {
					this._lb_left_count.color = "#ff4f50"
					this._lb_left_count.text = vo.left_num + "/" + max_count// HtmlColorTxt(vo.left_num, "'#ff4f50'") + "/" + max_count
				} else {
					this._lb_left_count.color = "#00fa64"
					this._lb_left_count.text = vo.left_num + "/" + max_count
				}
				//this._lb_count_time.visible = false 
			} else {
				let time_interval = local_TimeUtil.getServerTime() - vo.num_refresh
				let now_count = vo.left_num + Mathf.Floor(time_interval / add_count_time)
				time_interval = time_interval % add_count_time
				if (now_count < max_count) {
					//this._lb_count_time.visible = true 
					this._lb_left_count.text = now_count + "/" + max_count
					//this:StartTimer((add_count_time - time_interval) % add_count_time)
				} else {
					//this._lb_count_time.visible = false 
					this._lb_left_count.text = now_count + "/" + max_count
				}
			}

			if (!this._Group3.visible) {
				this._Group3.visible = true
			}
			// LayoutRebuilder(this._Group3)
		}

		this.StartTimer = (refresh_time?) => {
			this.StopTimer()
			this._end_time = refresh_time + local_TimeUtil.getServerTime()

			this.timer = GlobalTimerQuest.AddPeriodQuest(() => {
				this.OnTime()
			}, 1, -1)
			this.OnTime()
		}

		this.OnTime = () => {
			let left_time = this._end_time - local_TimeUtil.getServerTime()
			if (left_time < 0) {
				this.StopTimer()
				this.UpdateTimesInfo()
				return
			}
			let time = local_TimeUtil.convertTime(left_time)
			//this._lb_count_time.text = time + "后恢复一次"
		}

		this.StopTimer = () => {
			if (this.timer) {
				GlobalTimerQuest.CancelQuest(this.timer)
				this.timer = null
			}
		}

		this.UpdateChallenger = (vo?) => {
			let my_rank = model.GetMyRank()
			if (my_rank == null) {
				this._need_update_challenger = true
				this._update_challenger_vo = vo
				return
			}
			if (vo) {
				let list = vo
				let len = list.length
				if (!this.item_list) {
					this.item_list = []
				}
				for (let i = 0; i < this.item_list.length; i++) {
					this.item_list[i].SetVisible(false)
				}
				if (len > 0) {
					model.guide_info = null
					let item = null

					this._gp_item_con.visible = false
					for (let key = len - 1; key >= 0; key -= 1) {
						let vo = list[key]
						if (!model.guide_info && (my_rank == 0 || vo.rank < my_rank)) {
							model.guide_info = vo
						}
						item = this.item_list[key]
						if (!item) {
							item = new ArenaEnterRoleItem(this._gp_item_con)
							this.item_list[key] = item
							item.SetData(vo, key, len)
							item.SetMask(this._view_con)
							item.Load()
						} else {
							item.SetData(vo, key, len)
						}
						let i = Number(key)
						item.SetLocalPos((i % 2 != 0 && (50) || (390)), (260 * (i) + 130))
						item.SetVisible(true)
					}

					let content_height = 260 * (len - 1) + 130 + 500
					SetSizeDeltaY(this._gp_item_con, content_height)
					Laya.timer.frameOnce(1, this, () => {
						if (this.use_delete_method) return
						this._scroll_con.vScrollBar.value = content_height
						this._gp_item_con.visible = true
					})
					let scroll_height = GetSizeDeltaY(this._scroll_con)
					// SetAnchoredPositionY(this._gp_item_con, 260 * (len - 1) + 130 + 500 - scroll_height)
				}
			}
		}

		this.SetRedDot = () => {
			let red_state = model.GetBreachDot()
			this._reward_dot_img.visible = red_state
		}

		this.Update = () => {
			// 	SetRotate(this._round_top, 0, 0, 0.2)
			// 	SetRotate(this._round_down, 0, 0, 0.2)

			for (let i = 1; i <= 4; i++) {
				let item_x = this["_clouds" + i].x
				item_x = item_x + 0.5
				if (item_x >= 720) {
					let item_width = cloud_width
					item_x = - item_width
				}
				SetAnchoredPositionX(this["_clouds" + i], item_x)
			}
		}

		this.Local_DeleteMe = () => {
			if (this.item_list) {
				for (let _tmpi in this.item_list) {
					var vo = this.item_list[_tmpi]
					vo.DeleteMe()
				}
				this.item_list = null
			}
			this.StopTimer()
			if (this.tween_id) {
				SYTweenLite.Stop(this.tween_id)
			}
			runner.RemoveRunObj(this.run_id)
		}


	}

	public ReOpen_callback() {

		if (this.item_list && this.item_list.length > 0) {
			for (let k in this.item_list) {
				var role_item = this.item_list[k]
				role_item.ReOpen_callback()
			}
		}
	}

	public DeleteMe() {
		this.ClearUIEffect(this._box_time_effect)
		this.Local_DeleteMe()
		super.DeleteMe()
	}




	_mask: Laya.Image
	_round_top: Laya.Image
	_round_down: Laya.Image
	_clouds1: Laya.Image
	_clouds2: Laya.Image
	_clouds3: Laya.Image
	_clouds4: Laya.Image
	_scroll_con: Laya.Panel
	_gp_item_con: Laya.Box
	_img_left: Laya.Image
	_img_right: Laya.Image
	_img_refresh: Laya.Image
	_lb_refresh: Laya.Label
	_gp_rank: Laya.Box
	_Image1: Laya.Image
	_gp_rank_reward: Laya.Box
	_Image2: Laya.Image
	_reward_dot_img: Laya.Image
	_gp_battle_record: Laya.Box
	_Image3: Laya.Image
	_Group1: Laya.Box
	_Label1: Laya.Label
	_lb_my_rank: Laya.Label
	_Group2: Laya.Box
	_Label2: Laya.Label
	_lb_my_fighting: Laya.Label
	_Group3: Laya.Box
	_Label3: Laya.Label
	_lb_left_count: Laya.Label
	_img_add: Laya.Image
	_box_time_effect: Laya.Box
	_lb_count_time: Laya.Label
	_img_tips_arrow: Laya.Image
	_box_halo: Laya.Box
	_img_merge_count: Laya.Image
	_lb_halo_tips: Laya.Label
	public GetComponents() {
		[
			this._mask,
			this._round_top,
			this._round_down,
			this._clouds1,
			this._clouds2,
			this._clouds3,
			this._clouds4,
			this._scroll_con,
			this._gp_item_con,
			this._img_left,
			this._img_right,
			this._img_refresh,
			this._lb_refresh,
			this._gp_rank,
			this._Image1,
			this._gp_rank_reward,
			this._Image2,
			this._reward_dot_img,
			this._gp_battle_record,
			this._Image3,
			this._Group1,
			this._Label1,
			this._lb_my_rank,
			this._Group2,
			this._Label2,
			this._lb_my_fighting,
			this._Group3,
			this._Label3,
			this._lb_left_count,
			this._img_add,
			this._box_time_effect,
			this._lb_count_time,
			this._img_tips_arrow,
			this._box_halo,
			this._img_merge_count,
			this._lb_halo_tips,

		]
			= this.GetChildrenByNames([

				"_mask",
				"_round_top",
				"_round_down",
				"_clouds1",
				"_clouds2",
				"_clouds3",
				"_clouds4",
				"_scroll_con",
				"_gp_item_con",
				"_img_left",
				"_img_right",
				"_img_refresh",
				"_lb_refresh",
				"_gp_rank",
				"_Image1",
				"_gp_rank_reward",
				"_Image2",
				"_reward_dot_img",
				"_gp_battle_record",
				"_Image3",
				"_Group1",
				"_Label1",
				"_lb_my_rank",
				"_Group2",
				"_Label2",
				"_lb_my_fighting",
				"_Group3",
				"_Label3",
				"_lb_left_count",
				"_img_add",
				"_box_time_effect",
				"_lb_count_time",
				"_img_tips_arrow",
				"_box_halo",
				"_img_merge_count",
				"_lb_halo_tips",
			])
	}
}
window["ArenaEnterView"] = ArenaEnterView
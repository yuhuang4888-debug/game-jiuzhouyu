import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseView1 } from "../common/BaseView1"
import { CommonManager } from "../common/CommonManager"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { SoundManager } from "../common/SoundManager"
import { table } from "../common/table"
import { ArenaModel } from "../commonModel/ArenaModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { GameResPath } from "../util/GameResPath"
import { SYTweenFunc } from "../util/SYTweenFunc"
import { SYTweenLite } from "../util/SYTweenLite"
import { TimeUtil } from "../util/TimeUtil"
import { Color, SetAnchoredPositionY, Util, GlobalTimerQuest } from "../util/Util"

export class ArenaResultView extends BaseView1 {
	_img_fly: Laya.Image
	_gp_base: Laya.Box
	_gp_victroy: Laya.Box
	_gp_success: Laya.Box
	_Group2: Laya.Box
	img_rank_bg: Laya.Image
	_lb_tips_1: Laya.Label
	_lb_level: Laya.Label
	_Group1: Laya.Box
	_lb_tips_2_1: Laya.Label
	_gp_level_up: Laya.HBox
	_img_arrow: Laya.Image
	_lb_tips_2: Laya.Label
	_Group4: Laya.HBox
	_img_1: Laya.Image
	_Group3: Laya.Box
	_img_2: Laya.Image
	_lb_1: Laya.Label
	_img_3: Laya.Image
	_Scroller1: Laya.Panel
	_gp_reward_con: Laya.HBox
	_lb_count_time: Laya.Label
	wx_share_con: Laya.Box
	_img_result: Laya.Image
	_img_bg: Laya.Image
	_img_close: Laya.Image
	CancelTime
	InitEvent
	LoadSuccess
	OnTime
	Remove
	Scr_Scroller1
	SetWXShare
	StartMaxAction
	StartTime
	StopMaxAction
	UpdateView
	_Viewport
	_end_time
	award_item_list
	can_gp_level_up
	can_lb_tips_2_1
	click_bg_toClose
	destroy_callback
	destroy_imm
	is_center
	left_time
	line_lb_1
	line_lb_level
	line_lb_tips_1
	not_show_main_msg
	open_callback
	rank_change
	time_event_id
	time_list
	tween_lv_id
	tween_tip_id
	use_background
	wx_share_tips

	public constructor() {
		super()


		this.base_file = "arena"
		this.layout_file = "ArenaResultView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.is_center = true
		this.use_background = true
		this.click_bg_toClose = true
		let voice
		this.left_time = 10
		this.not_show_main_msg = true
		this.award_item_list = null
		this.time_event_id = null
		this.rank_change = null
		this.wx_share_tips = null
		this._end_time = null
		this.time_list = []

		let model = ArenaModel.GetInstance()
		//let friend_invite_model = FriendInviteModel.GetInstance()
		let goods_model = GoodsModel.GetInstance()
		let local_TimeUtil = TimeUtil

		this.load_callback = () => {

			this.LoadSuccess()
			this.InitEvent()
		}

		this.open_callback = () => {
			this.UpdateView()
		}

		this.destroy_callback = () => {
			this.Remove()
		}

		this.LoadSuccess = () => {
			// ResManager.GetInstance().SetOutsideImageSprite(this, this._img_1, GameResPath.GetIcon("arena", "jjc_001"))
			// ResManager.GetInstance().SetOutsideImageSprite(this, this._img_3, GameResPath.GetIcon("arena", "jjc_001"))
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._img_close,()=>{
				this.Close()
			},this)
			//let close_fun = () => {
			//this:Close()
			//}
			//this:BindEvent(friend_invite_model, FriendInviteModel.GET_WX_SHARE_REWARD_SUCCESS, close_fun)
		}

		this.UpdateView = () => {
			let data = model.result_info
			if (data) {

				let state=data.result == 1?2:1
				voice=CommonManager.GetInstance().PlayFightingVoice(state)

				let result = data.result == 1
				let role_vo = data.role_list[0]

				this._lb_level.text = role_vo.rank > 0 && role_vo.rank || "未上榜"
				this._lb_level.fontSize=role_vo.Rank > 0 && 44 || 30
				// if (!role_vo.rank || role_vo.rank == 0) {
				// 	this._lb_level.fontSize = 45
				// }

				let before_rank = role_vo.before_rank > 0 && role_vo.before_rank || (Number(model.GetCfgKeyValue(4)) + 1)
				let rank = role_vo.rank > 0 && role_vo.rank || (Number(model.GetCfgKeyValue(4)) + 1)
				let model_history = model.GetMyHistoryHighRank()
				let history_high_rank = (model_history && model_history > 0) && model_history || (Number(model.GetCfgKeyValue(4)) + 1)
				if (result) {
					//SoundManager:GetInstance():PlaySoundEffect("1_jiesuan")
					//this:AddUIEffect("ui_victory_glow1", this.layer_value,this._gp_victroy, null, {x=1.5, y=1.5}, false)
					// this.AddUIEffect("UI_2104", this.layer_value, this._gp_success, null, 1, false)
					// this._lb_tips_1.color ="#fff7cc"// Color(255 / 255, 247 / 255, 204 / 255, 1)
					// this.line_lb_tips_1.effectColor = "#bf7a1d"// Color(191 / 255, 122 / 255, 29 / 255, 1)

					// this._lb_level.color ="#fff7cc"// Color(255 / 255, 247 / 255, 204 / 255, 1)
					// this.line_lb_level.effectColor = "#bf7a1d"//Color(191 / 255, 122 / 255, 29 / 255, 1)

					this._lb_1.color ="#fff7cc"// Color(255 / 255, 247 / 255, 204 / 255, 1)
					// this.line_lb_1.effectColor ="#bf7a1d"// Color(191 / 255, 122 / 255, 29 / 255, 1)

					this.rank_change = before_rank- rank
					this._gp_level_up.visible = true
					if (this.rank_change > 0) {
						// if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
						// 	this._lb_tips_2.text = this.rank_change 
						// } else if (PlatformMgr.GetInstance().IsEyouIdnPlatform() ) {
						// 	this._lb_tips_2.text = this.rank_change + " Rank"
						// }else{
						this._lb_tips_2.text = this.rank_change + "名"
						// }
						if (history_high_rank > this.rank_change) {
							this._lb_tips_2_1.visible = true
							this.StartMaxAction()
						} else {
							this._lb_tips_2_1.visible = false
						}
					} else {
						this._img_arrow.visible = false
						this._lb_tips_2_1.text = "未变化"
						this._lb_tips_2.visible = false
					}
					// LayoutRebuilder(this._gp_level_up)

					//this:SetWXShare()
					ResManager.GetInstance().SetImageSprite(this,this._img_result,"arena","ui_copy_64")
					this._img_1.skin=GameResPath.GetIcon("arena","ui_copy_66")
					ResManager.GetInstance().SetOutsideImageSprite(this,this._img_bg,GameResPath.GetIcon("arena","com_up_bg1"))
					this._img_3.skin=GameResPath.GetIcon("arena","ui_copy_65")
				} else {
					// this.AddUIEffect("UI_2105",this.layer_value, this._gp_success, null, 1, false)
					SetAnchoredPositionY(this._gp_success, -150)
					// this._lb_tips_1.color ="#e5e5e5"// Color(229 / 255, 229 / 255, 229 / 255, 1)
					// this.line_lb_tips_1.effectColor ="#444444" // Color(68 / 255, 68 / 255, 68 / 255, 1)

					// this._lb_level.color = "#e5e5e5"// Color(229 / 255, 229 / 255, 229 / 255, 1)
					// this.line_lb_level.effectColor ="#444444"// Color(68 / 255, 68 / 255, 68 / 255, 1)

					this._lb_1.color = "#e5e5e5"// Color(229 / 255, 229 / 255, 229 / 255, 1)
					// this.line_lb_1.effectColor = "#444444"// Color(68 / 255, 68 / 255, 68 / 255, 1)

					this._gp_level_up.visible = false
					this._lb_tips_2_1.visible = false
					// Util.SetImageGray(this._img_1, !result)
					// Util.SetImageGray(this._img_2, !result)
					// Util.SetImageGray(this._img_3, !result)
					ResManager.GetInstance().SetImageSprite(this,this._img_result,"arena","fail")
					this._img_1.skin=GameResPath.GetIcon("arena","ui_copy_69")
					ResManager.GetInstance().SetOutsideImageSprite(this,this._img_bg,GameResPath.GetIcon("arena","com_up_bg2"))
					this._img_3.skin=GameResPath.GetIcon("arena","ui_arena_14")
					this._lb_level.color="#dbdfe3"
					this._lb_tips_1.color="#dbdfe3"
				}

				let result_list = data.reward_list
				for (let key in result_list) {

					let vo = result_list[key]
					let [type_id, lock] = goods_model.GetMappingTypeId(vo.type, vo.type_id)
					let goods_vo = goods_model.GetGoodsBasicByTypeId(type_id)
					if (goods_vo) {
						if (!this.award_item_list) {
							this.award_item_list = []
						}
						let item = this.award_item_list[key]
						if (!item) {
							item = new BaseAwardItem(this._gp_reward_con)
							this.award_item_list[key] = item
							item.Load()
							item.ExcuteCallback(()=>{
								item.SetItemSize(87,87)
							})
						}
						item.SetData(goods_vo.type_id, vo.num, lock)
					}
				}
				this.StartTime()
			}
		}

		this.StartTime = () => {
			this.CancelTime()
			this._end_time = this.left_time + local_TimeUtil.getServerTime()
			this.time_event_id = GlobalTimerQuest.AddPeriodQuest(() => {
				this.OnTime()
			}, 1, -1)
			this.OnTime()
		}

		this.OnTime = () => {
			let left_time = this._end_time - local_TimeUtil.getServerTime()
			if (left_time < 0) {
				this.Close()
				return
			}
			this._lb_count_time.text = "点击任意位置关闭(" + left_time + "s)"
		}

		this.CancelTime = () => {
			if (this.time_event_id) {
				GlobalTimerQuest.CancelQuest(this.time_event_id)
				this.time_event_id = null
			}
		}

		this.Remove = () => {

			if (voice) {
				SoundManager.GetInstance().StopSoundEffect(voice)
				voice = null
			}

			
			this.CancelTime()
			if (this.award_item_list) {
				for (let _tmpi in this.award_item_list) {
					var obj = this.award_item_list[_tmpi]
					obj.DeleteMe()
				}
				this.award_item_list = []
			}
			if (this.wx_share_tips) {
				this.wx_share_tips.DeleteMe()
				this.wx_share_tips = null
			}
		}

		this.StartMaxAction = () => {
			this.StopMaxAction()
			this._gp_level_up.alpha = 1
			this._lb_tips_2_1.alpha = 0


			let fun1
			fun1 = () => {
				SYTweenLite.Stop(this.tween_lv_id)
				this.tween_lv_id = null
				this.tween_lv_id = SYTweenLite.to(this, this._gp_level_up, SYTweenLite.UiAnimationType.ALPHA, 0, 1.5, () => {
					let time_lv_id = setTimeout(() => {
						if (this.use_delete_method) {
							return
						}
						SYTweenLite.Stop(this.tween_lv_id)
						this.tween_lv_id = null
						this.tween_lv_id = SYTweenLite.to(this, this._gp_level_up, SYTweenLite.UiAnimationType.ALPHA, 1, 1.5, () => {
							fun1()
						})
					}, 3)
					table.insert(this.time_list, time_lv_id)
				}, SYTweenFunc.LINEAR, false)
			}

			let fun2
			fun2 = () => {
				if (this.use_delete_method) {
					return
				}
				SYTweenLite.Stop(this.tween_tip_id)
				this.tween_tip_id = null
				this.tween_tip_id = SYTweenLite.to(this, this._lb_tips_2_1, SYTweenLite.UiAnimationType.ALPHA, 1, 1.5, () => {
					SYTweenLite.Stop(this.tween_tip_id)
					this.tween_tip_id = null
					this.tween_tip_id = SYTweenLite.to(this, this._lb_tips_2_1, SYTweenLite.UiAnimationType.ALPHA, 0, 1.5, () => {
						let time_tip_id = setTimeout(() => {
							fun2()
						}, 3)
						table.insert(this.time_list, time_tip_id)
					})
				})
			}

			fun1()
			let anim_time_id = setTimeout(fun2, 1.5)
			table.insert(this.time_list, anim_time_id)
		}

		this.StopMaxAction = () => {
			if (this.use_delete_method) {
				return
			}

			if (this._gp_level_up) {
				this._gp_level_up.alpha = 1
			}
			if (this._lb_tips_2_1) {
				this._lb_tips_2_1.alpha = 1
			}
			if (this.time_list.length > 0) {
				for (let i = 0; i < this.time_list.length; i++) {
					var v = this.time_list[i]
					clearTimeout(v)
				}
			}
			if (this.tween_tip_id) {
				SYTweenLite.Stop(this.tween_tip_id)
				this.tween_tip_id = null
			}
			if (this.tween_lv_id) {
				SYTweenLite.Stop(this.tween_lv_id)
				this.tween_lv_id = null
			}
		}

		this.SetWXShare = () => {
			//let call_back = (show?) => {
			//this.wx_share_con.visible = show
			//if (this.wx_share_con.visible ) {
			//if (! this.wx_share_tips ) {
			//this.wx_share_tips =  new WXShareTips(this.wx_share_con)
			//this.wx_share_tips.Load()
			//}
			//}
			//}

			//friend_invite_model:ShowWXShare(call_back)
		}


	}

	public Close() {
		this.StopMaxAction()
		super.Close()
	}

	public GetComponents() {
		[
			this._img_fly,
			this._gp_base,
			this._gp_victroy,
			this._gp_success,
			this._Group2,
			this.img_rank_bg,
			this._lb_tips_1,
			this._lb_level,
			this._Group1,
			this._lb_tips_2_1,
			this._gp_level_up,
			this._img_arrow,
			this._lb_tips_2,
			this._Group4,
			this._img_1,
			this._Group3,
			this._img_2,
			this._lb_1,
			this._img_3,
			this._Scroller1,
			this._gp_reward_con,
			this._lb_count_time,
			this.wx_share_con,
			this._img_bg,
			this._img_result,
			this._img_close
		]
			= this.GetChildrenByNames([

				"_img_fly",
				"_gp_base",
				"_gp_victroy",
				"_gp_success",
				"_Group2",
				"img_rank_bg",
				"_lb_tips_1",
				"_lb_level",
				"_Group1",
				"_lb_tips_2_1",
				"_gp_level_up",
				"_img_arrow",
				"_lb_tips_2",
				"_Group4",
				"_img_1",
				"_Group3",
				"_img_2",
				"_lb_1",
				"_img_3",
				"_Scroller1",
				"_gp_reward_con",
				"_lb_count_time",
				"wx_share_con",
				"_img_bg",
				"_img_result",
				"_img_close"
			])
		this._Scroller1.hScrollBar.visible=false
	}
}
window["ArenaResultView"]=ArenaResultView
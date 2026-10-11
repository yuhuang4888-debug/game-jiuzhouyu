import { BaseItem1 } from "../common/BaseItem1"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { Config } from "../common/Config"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { GameResPath } from "../util/GameResPath"
import { ResManager } from "../common/ResManager"
import { Util, SetAnchoredPosition } from "../util/Util"
import { OpenFun } from "../common/OpenFun"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { table } from "../common/table"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { TopPlayerTabItem } from "../topPlayer/TopPlayerTabItem"
import { Message } from "../sysInfo/SysInfoController"
import { Color } from "../util/Util"
import { RoleManager } from "../commonModel/RoleManager"
import { ErlangParser } from "../util/ErlangParser"
import { TopPlayerItem } from "./TopPlayerItem"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest } from "../util/Util"
import { TopPlayerGetWayView } from "./TopPlayerGetWayView"
import { TopPlayerRankView } from "./TopPlayerRankView"

export class TopPlayerView extends BaseItem1 {
	_img_bg: Laya.Image
	_img_title: Laya.Image
	_img_title0: Laya.Image
	_img_title1: Laya.Image
	Content1: Laya.List
	Content: Laya.List
	_Group1: Laya.HBox
	_Label1: Laya.Label
	_lb_rank: Laya.HTMLDivElement
	_Group2: Laya.HBox
	_lb_lv_desc: Laya.Label
	_lb_lv: Laya.HTMLDivElement
	_Group3: Laya.HBox
	_Label2: Laya.Label
	_lb_count_down: Laya.HTMLDivElement
	_gp_rank: Laya.Image
	_Image1: Laya.Image
	_Label3: Laya.Label
	_gp_need: Laya.Image
	_Image2: Laya.Image
	_lb_need: Laya.Label
	_img_line: Laya.Image
	rank_bg: Laya.Image
	CancelTime

	Init
	InitEvent
	InitTab
	LoadSuccess
	Local_DeleteMe
	StartTime
	UpdateDefaultIndex
	UpdateTab
	UpdateTabRed
	UpdateView
	GetRedIndex


	close_callback
	getDataByType
	listGp
	loop_mgr
	open_callback
	request_25001_dic
	request_25002_state
	tab_loop_mgr

	public static Type = { Level: 1, Mount: 2, Parter: 3, Pay: 4, Store: 5, Pet: 7, Suit: 8, Soul: 9, Lung: 13, Rune: 14, Fight: 6 }
	public constructor(parent?) {
		super(parent)


		this.base_file = "topPlayer"
		this.layout_file = "TopPlayerView"
		//this.dependent_res = ["kaifuactivity"]
		this.is_load_res = false
		let model = CustomActivityModel.GetInstance()

		let local_CustomActivityDefine = CustomActivityDefine
		let cfg_ = null
		let base_type_ = Config.PRELOAD_CLIENT_CONFIG.ConfigCustomActivity.ACT_ID.TOP_PLAYER
		let show_id_ = 0
		let sub_type_ = 1
		let tab_arr_ = null
		let item_arr_ = null
		let default_index_ = 1
		let now_index_ = null
		let show_rank_type_ = null
		let count_down_id_ = null
		let tab_list_ = null
		let rank_view_ = null
		let get_way_view_ = null
		let open_dic_ = null
		let need_dic = []
		let index_dic_ = null
		let _close_time_ = 0
		this.preload_server_config = {
			"config_rush_rank": false,
			"config_rush_rank_reward": false,
			"config_rush_goal_reward": false
		}
		this.load_callback = () => {

			// if (PlatformMgr.GetInstance().IsEyouIdnPlatform() ) {
			// 	this._lb_need.lineSpacing = 0.7
			// 	//this._lb_rank.size  = 16
			// 	//SetAnchoredPosition(this._lb_rank,135,3)
			// }
			// let mask = this.GetChild("_Scroller2/listGp").GetComponent("Image")
			// this.RegisterMask(mask)
			this.Init()
		}
		this.open_callback = () => {

		}
		this.close_callback = () => {
			if (this.tab_loop_mgr) {
				this.tab_loop_mgr.DeleteMe()
				this.tab_loop_mgr = null
			}
			if (this.loop_mgr) {
				this.loop_mgr.DeleteMe()
				this.loop_mgr = null
			}
		}

		this.Init = () => {

			let url1 = GameResPath.GetIcon("common2", "uity_060")
			let url2 = GameResPath.GetIconJpg("topPlayer", "uikf_006b")
			let url3 = GameResPath.GetIcon("topPlayer", "uikf_006")
			let url4 = GameResPath.GetIcon("topPlayer", "uikf_021")
			let url5 = GameResPath.GetIcon("common2", "com_line_5")
			if (model.isCBPlatform()) {
				url4 = GameResPath.GetIcon("topPlayer", "uikf_021_fc")
			}
			ResManager.GetInstance().SetImageSpriteTrans(this, this._img_bg, url1)
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_title, url2)
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_title0, url3)
			ResManager.GetInstance().SetImageSpriteTrans(this, this._img_title1, url4)
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_line, url5)
			ResManager.GetInstance().SetOutsideImageSprite(this, this.rank_bg, GameResPath.GetIcon("topPlayer", "ui_role_11"))
			this.InitEvent()
			this.LoadSuccess()
			model.Fire(local_CustomActivityDefine.EVENT.SCMD_REQUEST, 22502, sub_type_)
		}

		this.InitEvent = () => {
			this.BindEvent(model, local_CustomActivityDefine.EVENT.UPDATE_VIEW, (base_type?, sub_type?, rank_type?) => {
				if (sub_type_ == sub_type && base_type == base_type_) {
					this.UpdateView()
					if (rank_type == null) {
						this.request_25002_state = true
						for (let key in open_dic_) {

							// [ts2lua]open_dic_下标访问可能不正确
							let rank_type = Number(open_dic_[key])
							this.UpdateTabRed(rank_type)
						}
					} else {
						if (!this.request_25001_dic) {
							this.request_25001_dic = []
						}
						// [ts2lua]this.request_25001_dic下标访问可能不正确
						this.request_25001_dic[rank_type - 1] = true
						this.UpdateTabRed(rank_type)
					}
				}
			}
			)
			Util.AddClickEvent(this._gp_rank, () => {
				let act_data = model.GetActData(base_type_, sub_type_)
				if(!act_data) return
				// [ts2lua]act_data.rank_info下标访问可能不正确
				let data = (show_rank_type_ && act_data.rank_info) && act_data.rank_info[show_rank_type_]
				if (data) {
					if (!rank_view_) {
						rank_view_ = new TopPlayerRankView()
					}
					rank_view_.SetRankData(data)
					if (!rank_view_.HasOpen()) {
						rank_view_.Open()
					}
				}
			}
				, this, true)
			Util.AddClickEvent(this._gp_need, () => {
				if (!show_rank_type_) {
					return
				}
				if (show_rank_type_ == TopPlayerView.Type.Pay) {
					OpenFun.OpenFunHandler(21)
					return
				}
				if (!get_way_view_) {
					get_way_view_ = new TopPlayerGetWayView
				}
				get_way_view_.SetRankType(show_rank_type_)
				if (!get_way_view_.HasOpen()) {
					get_way_view_.Open()
				}
			}
				, this, true)
			let change_day = () => {
				this.UpdateTab()
			}

			this.BindEvent(GlobalEventSystem, ServerTimeModel.DAY_CHANGE, change_day)
			let answer_target = (base_type?, sub_type?, rank_type?) => {
				if (sub_type_ == sub_type && base_type == base_type_) {
					this.UpdateTabRed(rank_type)
					this.UpdateView()
				}
			}

			this.BindEvent(model, local_CustomActivityDefine.EVENT.ANSWER_TARGET, answer_target)
			this.BindEvent(model, local_CustomActivityDefine.EVENT.CLICK_TOPPLAYER_TAB, () => {

			})
		}

		//this.UpdateDefaultIndex = () => {
		//if ((((now_index_ == null && this.request_25002_state) && open_dic_) && this.request_25001_dic) && Util.TableSize(open_dic_) == Util.TableSize(this.request_25001_dic) ) {
		//let default_index = default_index_
		//for (let key in tab_list_) {

		//// [ts2lua]tab_list_下标访问可能不正确
		//let tab = tab_list_[key]
		//if (tab && tab.red_state ) {
		//default_index = local_Number(key)
		//break
		//}
		//}
		//this.tab_loop_mgr.SetSelectIndex(default_index)
		//this:SwitchTab(default_index)
		//}
		//}

		this.LoadSuccess = () => {
			CustomActivityModel.GetInstance().CloseACTRed(base_type_, sub_type_)
			this.InitTab()
			this.UpdateTab()
			//this.tab_loop_mgr.SetSelectIndex(default_index_)
			//this:SwitchTab(default_index_)
		}

		this.InitTab = () => {
			let list = []
			let rush_rank = ResManager.GetInstance().GetGameConfigFromCache(this, "config_rush_rank", false);
			let openTime:number = ServerTimeModel.GetInstance().GetOpenServerTime();
			for (let k in rush_rank) {
				let v = rush_rank[k]
				if(openTime >= v.open_start_time && openTime <= v.open_end_time){
					table.insert(list, { name: v.name, start_day: v.start_day, type: v.id })
				}
				
			}
			tab_list_ = list
		}

		this.UpdateTab = () => {
			let index = 1
			open_dic_ = []
			index_dic_ = []
			let open_day = ServerTimeModel.GetInstance().GetOpenServerDay()
			table.sort(tab_list_, (a?, b?) => {
				return a.start_day < b.start_day
			})
			let now_index = 0
			for (let i = tab_list_.length - 1; i >= 0; i--) {

				let v = tab_list_[i]
				let state = v.start_day <= open_day
				need_dic[i] = v.start_day
				if (state) {
					index = Number(i)
					let type = v.type
					open_dic_[i] = type
					// [ts2lua]index_dic_下标访问可能不正确
					index_dic_[type] = i
					model.Fire(local_CustomActivityDefine.EVENT.SCMD_REQUEST, 22501, type, sub_type_)
				}
				// else
				// 	table.remove(tab_list_, i)
				v.state = state
				if (state == true) {
					now_index = now_index + 1
				}
			}
			if (!now_index || now_index == 0) {
				now_index = 1
			}

			if (!this.tab_loop_mgr) {
				this.tab_loop_mgr = new LoopScrowViewMgr()

				this.tab_loop_mgr.SetData(this.Content1, TopPlayerTabItem, tab_list_, LoopScrCon.Vertical, 1, (item?) => {
					let index = this.Content1.selectedIndex
					// [ts2lua]open_dic_下标访问可能不正确
					if (!open_dic_[index]) {
						this.tab_loop_mgr.SetSelectIndex(now_index_)
						let need_day = need_dic[index]
						Message.show(`开服第${need_day}天开启`)
						return
					}
					if (now_index_ == index) {
						return
					}
					now_index_ = index

					//model:Fire(local_CustomActivityDefine.EVENT.CLICK_TOPPLAYER_TAB, index)
					this.UpdateView(true)
				}, now_index - 1)
				//this.tab_loop_mgr.SetSelectIndex(now_index)
				//model:Fire(local_CustomActivityDefine.EVENT.CLICK_TOPPLAYER_TAB, 1)
			} else {
				this.tab_loop_mgr.replaceAll(tab_list_)
			}
			default_index_ = index
		}

		this.UpdateTabRed = (rank_type?) => {
			let act_data = model.GetActData(base_type_, sub_type_)
			let can_get_stage_reward = () => {
				let data = this.getDataByType(rank_type)
				let bool = false
				if (data) {
					for (let _tmpi in data.goal) {
						var vo = data.goal[_tmpi]
						if (vo.status == 1) {
							bool = true
							break
						}
					}
				}
				return bool
			}

			let can_get_rank_reward = () => {
				// [ts2lua]act_data.rank_info下标访问可能不正确
				let data = act_data.rank_info && act_data.rank_info[rank_type]
				return data && data.status == 1
			}

			let bool = can_get_stage_reward() || can_get_rank_reward()
			// [ts2lua]index_dic_下标访问可能不正确
			let index = index_dic_[rank_type]
			// [ts2lua]tab_list_下标访问可能不正确
			if (tab_list_ && tab_list_[index]) {
				// [ts2lua]tab_list_下标访问可能不正确
				tab_list_[index].red_state = bool
				this.tab_loop_mgr.replaceAll(tab_list_)
			}
			return bool
		}


		this.UpdateView = (need_refresh?) => {
			if (need_refresh == null) {
				need_refresh = false
			}
			//this.Scr_Scroller1.verticalNormalizedPosition = 0
			//SetAnchoredPosition(this.Content, this.Content1.x, 0)
			let act_data = model.GetActData(base_type_, sub_type_)
			// [ts2lua]tab_list_下标访问可能不正确
			let v = tab_list_[now_index_]
			let rank_type = v && v.type
			show_rank_type_ = rank_type
			this.CancelTime()
			if (act_data && rank_type) {
				// [ts2lua]act_data.rank_info下标访问可能不正确
				let data = act_data.rank_info && act_data.rank_info[rank_type]
				let targer_data = act_data.reward_info
				let list = []
				if (data) {
					this._lb_rank.style.fontSize = 22
					this._lb_rank.style.valign = "center"
					this._lb_rank.style.color = "#663915"
					this._lb_rank.width = 150
					if (data.sel_rank && data.sel_rank != 0) {
						// if (PlatformMgr.GetInstance().IsEyouIdnPlatform() ) {
						// 	this._lb_rank.textFlow = Util.StrToHTML("Rank <font color=0x639c12>" + data.sel_rank + "</font>")
						// }else{

						this._lb_rank.innerHTML = Util.StrToHTML("第<font color='#639c12'>" + data.sel_rank + "</font>名")
						//	}
					} else {
						this._lb_rank.innerHTML = "未上榜"
					}
					let desc_tab = TopPlayerView.GetRankType2Desc(rank_type, true)
					let desc1 = desc_tab.desc1
					let desc2 = desc_tab.desc2
					this._lb_lv_desc.text = desc1 + ":"
					this._lb_need.text = desc2
					this._lb_lv.width = 150
					this._lb_lv.style.fontSize = 22
					//this._lb_lv.style.align = "left"
					this._lb_lv.style.color = "#663915"

					this._lb_lv.innerHTML = Util.StrToHTML(TopPlayerView.GetValue2Desc(rank_type, data.sel_val, "#639c12", true))
					this._lb_count_down.style.fontSize = 22
					this._lb_count_down.style.valign = "center"
					this._lb_count_down.style.color = "#663915"
					this._lb_count_down.width = 200
					if (data.end_time && data.end_time != 0) {
						this._lb_count_down.style.color = "#0a953e"
						this.StartTime(data.end_time)
					} else {
						this._lb_count_down.style.color = Color(211 / 255, 0, 0, 1)
						this._lb_count_down.innerHTML = "已结束"
					}
					let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_rush_rank_reward", false)
					let status = data.status
					let career = RoleManager.GetInstance().GetMainRoleVo().career
					let bool = status > 0
					if (cfg) {
						for (let key in cfg) {

							// [ts2lua]cfg下标访问可能不正确
							let vo = cfg[key]
							if (vo.id == rank_type) {
								let state = 0
								if (bool) {
									if (data.sel_rank >= vo.rank_min && data.sel_rank <= vo.rank_max) {
										state = status
									}
								}
								let reward = JSON.parse(vo.reward)
								let sex_reward = null
								for (let _tmpi in reward) {
									var v0 = reward[_tmpi]
									if (Number(v0[0]) == career) {
										sex_reward = v0[1]
										break
									}
								}
								table.insert(list, { rank_type: show_rank_type_, id: vo.reward_id, reward: sex_reward, state: state, desc: vo.about, type: 1 })
							}
						}
					}
				}
				if (targer_data && targer_data.length > 0) {
					let data = this.getDataByType(rank_type)
					if (data) {
						let goal_reward_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_rush_goal_reward", false)
						if(goal_reward_cfg)
						{
							for (let _tmpi in data.goal) {
								let vo = data.goal[_tmpi]
								// [ts2lua]goal_reward_cfg下标访问可能不正确
								let cfg = goal_reward_cfg[rank_type + "@" + vo.goalId]
								let reward = JSON.parse(cfg.reward)
								table.insert(list, { rank_type: show_rank_type_, id: cfg.reward_id, reward: reward, state: vo.status, desc: cfg.about, type: 0, sort_id: cfg.sort_id })
							}
						}
					}
				}
				table.sort(list, (a?, b?) => {
					if (a.type != b.type) {
						return a.type > b.type
					} else if (a.sort_id && b.sort_id && a.sort_id != b.sort_id) {
						return a.sort_id < b.sort_id
					}
					else {
						return a.id < b.id
					}
				})
				//if (need_refresh ) {
				//if (this.loop_mgr ) {
				//this.loop_mgr.DeleteMe()
				//this.loop_mgr = null
				//}
				//}

				if (!this.loop_mgr) {
					this.loop_mgr = new LoopScrowViewMgr()
					this.loop_mgr.SetData(this.Content, TopPlayerItem, list, LoopScrCon.Vertical)
				} else {
					this.loop_mgr.replaceAll(list)
				}
				let index = this.GetRedIndex(list)
				if(this.loop_mgr)
					this.loop_mgr.FirstOnChild(index)
				// LayoutRebuilder(this._Group1)
				// LayoutRebuilder(this._Group2)
				// LayoutRebuilder(this._Group3)
			}
		}

		this.GetRedIndex = (list) => {
			let index = 0
			for (let i = 0; i < list.length; i++) {
				let v = list[i]
				if(v.state == 1){
					index = i
					break
				}
			}
			return index
		}

		this.getDataByType = (rank_type?) => {
			let act_data = model.GetActData(base_type_, sub_type_)
			let data = null
			if (act_data && rank_type) {
				let targer_data = act_data.reward_info
				if (targer_data && targer_data.length > 0) {
					for (let _tmpi in targer_data) {
						var v = targer_data[_tmpi]
						if (v.rank_type == rank_type) {
							data = v
						}
					}
				}
			}
			return data
		}

		this.StartTime = (end_time?) => {
			this.CancelTime()
			_close_time_ = end_time
			let OnTime = () => {
				let left_time = _close_time_ - TimeUtil.getServerTime()
				this._lb_count_down.style.fontSize = 22
				this._lb_count_down.style.valign = "center"
				this._lb_count_down.style.color = "#663915"
				this._lb_count_down.width = 200
				if (left_time < 0) {
					this._lb_count_down.innerHTML = "已结束"
					this._lb_count_down.style.color = Color(211 / 255, 0, 0, 1)
					this.CancelTime()
					return
				}

				let str = CustomActivityModel.GetTimeText(left_time)
				this._lb_count_down.innerHTML = str
			}
			count_down_id_ = GlobalTimerQuest.AddPeriodQuest(OnTime, 1)



			OnTime()
		}



		this.CancelTime = () => {
			if (count_down_id_) {
				GlobalTimerQuest.CancelQuest(count_down_id_)
			}
		}

		this.Local_DeleteMe = () => {
			if (rank_view_) {
				rank_view_.DeleteMe()
				rank_view_ = null
			}
			if (get_way_view_) {
				get_way_view_.DeleteMe()
				get_way_view_ = null
			}
			this.CancelTime()
			default_index_ = 1
			now_index_ = null
			open_dic_ = null
			need_dic = []
			index_dic_ = null
			this.request_25002_state = null
			this.request_25001_dic = this.request_25002_state
			if (this.tab_loop_mgr) {
				this.tab_loop_mgr.DeleteMe()
				this.tab_loop_mgr = null
			}
			if (this.loop_mgr) {
				this.loop_mgr.DeleteMe()
				this.loop_mgr = null
			}
		}


	}
	public DeleteMe() {

		this.Local_DeleteMe()
		super.DeleteMe()
	}

	public static GetValue2Desc(rank_type, value, color, is_combat?) {
		let desc = null
		if (TopPlayerView.Type.Level == rank_type) {
			desc = "<font color='" + color + "'>" + value + "</font>"
		} else if (TopPlayerView.Type.Fight == rank_type) {
			desc = "<font color='" + color + "'>" + value + "</font>"
		} else if (TopPlayerView.Type.Pet == rank_type) {
			desc = "<font color='" + color + "'>" + value + "</font>"
		} else if (TopPlayerView.Type.Suit == rank_type) {
			desc = "<font color='" + color + "'>" + value + "</font>"
		} else if (TopPlayerView.Type.Pay == rank_type) {
			desc = "<font color='" + color + "'>" + Number(value) / 10 + "</font>"
		} else if (TopPlayerView.Type.Store == rank_type) {
			desc = "<font color='" + color + "'>" + value + "</font>"
		} else if (TopPlayerView.Type.Mount == rank_type) {
			// if (PlatformMgr.GetInstance().IsEyouIdnPlatform() ) {
			// 	desc = "<font color=" + color + ">Grade " + Math.floor(value / 1000) + "</font> <font color=" + color + ">S" + value % 1000 + "</font>"
			// }else{
			if (is_combat) {
				desc = "<font color='" + color + "'>" + value + "</font>"
			}
			else {
				desc = "<font color='" + color + "'>" + Math.floor(value / 1000) + "</font>阶<font color='" + color + "'>" + value % 1000 + "</font>星"
			}
			//}
		} else if (TopPlayerView.Type.Parter == rank_type) {
			// if (PlatformMgr.GetInstance().IsEyouIdnPlatform() ) {
			// 	desc = "<font color=" + color + ">Grade " + Math.floor(value / 1000) + "</font> <font color=" + color + ">S" + value % 1000 + "</font>"
			// }else{
			if (is_combat) {
				desc = "<font color='" + color + "'>" + value + "</font>"
			}
			else {
				desc = "<font color='" + color + "'>" + Math.floor(value / 1000) + "</font>阶<font color='" + color + "'>" + value % 1000 + "</font>星"
			}
			//}
		} else if (TopPlayerView.Type.Lung == rank_type) {
			desc = "<font color='" + color + "'>" + value + "</font>"
		} else if (TopPlayerView.Type.Rune == rank_type) {
			desc = "<font color='" + color + "'>" + value + "</font>"
		}
		return desc
	}

	public static GetRankType2Desc(rank_type, is_combat?) {
		let desc1 = null
		let desc2 = null
		if (TopPlayerView.Type.Level == rank_type) {
			desc1 = "当前等级"
			desc2 = "我要升级"
		} else if (TopPlayerView.Type.Mount == rank_type) {
			if (is_combat) {
				desc1 = "坐骑战力"
				desc2 = "提升战力"
			}
			else {
				desc1 = "坐骑阶数"
				desc2 = "我要升阶"
			}
		} else if (TopPlayerView.Type.Parter == rank_type) {
			if (is_combat) {
				desc1 = "侍魂战力"
				desc2 = "提升战力"
			}
			else {
				desc1 = "侍魂阶数"
				desc2 = "我要升阶"
			}
		} else if (TopPlayerView.Type.Store == rank_type) {
			desc1 = "宝石总等级"
			desc2 = "我要宝石"
		} else if (TopPlayerView.Type.Pay == rank_type) {
			desc1 = "充值总额"
			desc2 = "我要充值"
		} else if (TopPlayerView.Type.Suit == rank_type) {
			desc1 = "套装总等级"
			desc2 = "提升等级"
		} else if (TopPlayerView.Type.Pet == rank_type) {
			desc1 = "飞骑总阶数"
			desc2 = "我要升阶"
		} else if (TopPlayerView.Type.Fight == rank_type) {
			desc1 = "我的战力"
			desc2 = "提升战力"
		} else if (TopPlayerView.Type.Lung == rank_type) {
			desc1 = "神纹等级"
			desc2 = "提升等级"
		} else if(TopPlayerView.Type.Rune == rank_type){
			desc1 = "御魂战力"
			desc2 = "提升御魂"
		}
		return { desc1, desc2 }
	}






	public GetComponents() {
		[
			this._img_bg,
			this._img_title,
			this._img_title0,
			this._img_title1,
			this.Content1,
			this.Content,
			this._Group1,
			this._Label1,
			this._lb_rank,
			this._Group2,
			this._lb_lv_desc,
			this._lb_lv,
			this._Group3,
			this._Label2,
			this._lb_count_down,
			this._gp_rank,
			this._Image1,
			this._Label3,
			this._gp_need,
			this._Image2,
			this._lb_need,
			this._img_line,
			this.rank_bg
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_img_title",
				"_img_title0",
				"_img_title1",
				"Content1",
				"Content",
				"_Group1",
				"_Label1",
				"_lb_rank",
				"_Group2",
				"_lb_lv_desc",
				"_lb_lv",
				"_Group3",
				"_Label2",
				"_lb_count_down",
				"_gp_rank",
				"_Image1",
				"_Label3",
				"_gp_need",
				"_Image2",
				"_lb_need",
				"_img_line",
				"rank_bg"
			])
	}
}
window["TopPlayerView"] = TopPlayerView
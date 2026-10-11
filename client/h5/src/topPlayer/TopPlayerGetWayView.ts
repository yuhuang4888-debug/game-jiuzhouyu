import { BaseView1 } from "../common/BaseView1"
import { TopPlayerView } from "./TopPlayerView"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { Util, GetSizeDeltaY, SetSizeDeltaY } from "../util/Util"
import { LuaSoundManager } from "../common/SoundManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { TopPlayerGetWayItem } from "./TopPlayerGetWayItem"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { table } from "../common/table"
import { Config } from "../common/Config"

export class TopPlayerGetWayView extends BaseView1 {
	_bg1: Laya.Image
	_bg2: Laya.Image
	_bg3: Laya.Image
	goodDesc: Laya.Label
	content: Laya.List
	btnClose: Laya.Box
	_Image1: Laya.Image
	labelDisplay: Laya.Label
	_Group1: Laya.Box
	_Image11: Laya.Image
	_lb_title: Laya.Label
	_Image2: Laya.Image
	GetTips
	LoadSuccess
	SetRankType
	click_bg_toClose
	close_callback
	destroy_callback
	destroy_imm
	is_center
	//itemScroller
	item_list
	loop_mgr
	preload_client_config
	show_open_movie
	use_background

	public constructor() {
		super()


		this.item_list = []
		let local_TopPlayerView = TopPlayerView
		let _bg1_height_ = null
		let _bg2_height_ = null
		let _bg3_height_ = null
		let content_height = null
		let cfg_ = null
		let rank_type_ = null
		let Init_ = null
		this.base_file = "topPlayer"
		this.layout_file = "TopPlayerGetWayView"
		this.layer_value = Enum_UILayer.Activity
		this.use_background = true
		this.click_bg_toClose = true
		this.is_load_res = false
		this.destroy_imm = true
		this.is_center = true
		this.show_open_movie = true
		this.preload_server_config = {
			"config_rush_rank_jump": false
		}
		this.load_callback = () => {

			Init_()
		}
		this.close_callback = () => {
			if (this.loop_mgr) {
				this.loop_mgr.DeleteMe()
				this.loop_mgr = null
			}
		}

		this.destroy_callback = () => { }
		this.preload_client_config = {
			"ConfigTopPlayer": false
		}
		Init_ = () => {
			cfg_ = ResManager.GetInstance().GetGameConfigFromCache(this, "ConfigTopPlayer", true)
			_bg1_height_ = GetSizeDeltaY(this._bg1)
			_bg2_height_ = GetSizeDeltaY(this._bg2)
			_bg3_height_ = GetSizeDeltaY(this._bg3)
			content_height = GetSizeDeltaY(this.content)

			Util.AddClickEvent(this.btnClose, () => {
				this.Close()
			}
				, this, true, null, null, null, null, LuaSoundManager.SOUND_UI.CLOSE)
			this.BindEvent(CustomActivityModel.GetInstance(), CustomActivityDefine.EVENT.UPDATE_VIEW, (base_type?, sub_type?, rank_type?) => {
				if (1 == sub_type && base_type == Config.PRELOAD_CLIENT_CONFIG.ConfigCustomActivity.ACT_ID.TOP_PLAYER && rank_type_ == rank_type) {
					this.LoadSuccess()
				}

			})
			CustomActivityModel.GetInstance().Fire(CustomActivityDefine.EVENT.SCMD_REQUEST, 22505, rank_type_)
		}

		this.LoadSuccess = () => {
			if (!rank_type_) {
				return
			}
			let config = ResManager.GetInstance().GetGameConfigFromCache(this, "config_rush_rank_jump", false)
			// [ts2lua]cfg_下标访问可能不正确
			let data = cfg_ && cfg_[rank_type_]
			let act_way_data = CustomActivityModel.GetInstance().GetTopPlayerGetWay(rank_type_)
			this.goodDesc.text = this.GetTips(rank_type_)
			let str = null
			this._lb_title.text = local_TopPlayerView.GetRankType2Desc(rank_type_, true).desc2
			if (data) {
				let list = []
				let zero_is_buy = false
				if (act_way_data && Util.TableSize(act_way_data) > 0) {
					table.sort(act_way_data, (a, b) => {
						return a.label > b.label
					})

					for (let key in act_way_data) {
						let vo = act_way_data[key]
						if (vo && vo.jump_id == 228) {
							let data = CustomActivityModel.GetInstance().zero_money_info
							if (data && data.reward_list) {
								for (let k in data.reward_list) {
									var v = data.reward_list[k]
									if (v && v.grade == 3 && v.status != 0) {
										vo.label = 0
										vo.end_time = 0
										zero_is_buy = true
										break
									}
								}
							}
						}
						if(vo)
						{
							table.insert(list, {
								"desc": config[vo.jump_id].desc,
								"open_id": vo.jump_id,
								"label": vo.label,
								"end_time": vo.end_time
							})
						}
					}

				}
				list = list.concat(data)
				if (zero_is_buy) {
					let data
					for (let i = 0; i < list.length; i++) {
						let value = list[i]
						if (value && value.open_id == 228) {

							data = value
							list.splice(i, 1)
							break
						}
					}
					list.push(data)
				}
				if (!this.loop_mgr) {
					this.loop_mgr = new LoopScrowViewMgr()
					this.loop_mgr.SetData(this.content, TopPlayerGetWayItem, list, LoopScrCon.Vertical)
				} else {
					this.loop_mgr.replaceAll(list)
				}

			}
		}

		this.SetRankType = (rank_type?) => {
			rank_type_ = rank_type

		}

		this.GetTips = (rank_type?) => {
			let tips = ""
			if (local_TopPlayerView.Type.Level == rank_type) {
				tips = "以下途径可获得经验"
			} else if (local_TopPlayerView.Type.Mount == rank_type) {
				tips = "以下途径可获得坐骑进阶材料"
			} else if (local_TopPlayerView.Type.Parter == rank_type) {
				tips = "以下途径可获得精灵进阶材料"
			} else if (local_TopPlayerView.Type.Pet == rank_type) {
				tips = "以下途径可获得飞骑进阶材料"
			} else if (local_TopPlayerView.Type.Suit == rank_type) {
				tips = "以下途径可获得套装升级材料"
			} else if (local_TopPlayerView.Type.Store == rank_type) {
				tips = "以下途径可获得宝石"
			} else if (local_TopPlayerView.Type.Soul == rank_type) {
				tips = "以下途径可提升战斗力"
			}
			return tips
		}


	}


	public GetComponents() {
		[
			this._bg1,
			this._bg2,
			this._bg3,
			this.goodDesc,
			this.content,
			this.btnClose,
			this._Image1,
			this.labelDisplay,
			this._Group1,
			this._Image11,
			this._lb_title,
			this._Image2,
		]
			= this.GetChildrenByNames([

				"_bg1",
				"_bg2",
				"_bg3",
				"goodDesc",
				"content",
				"btnClose",
				"_Image1",
				"labelDisplay",
				"_Group1",
				"_Image11",
				"_lb_title",
				"_Image2",
			])
	}
}
window["TopPlayerGetWayView"] = TopPlayerGetWayView
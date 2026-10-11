import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { LuaSoundManager } from "../common/SoundManager"
import { table } from "../common/table"
import { HolyBattleModel } from "../commonModel/HolyBattleModel"
import { GameResPath } from "../util/GameResPath"
import { Util, HtmlColorTxt } from "../util/Util"
import { HolyBattleRewardItem } from "./HolyBattleRewardItem"
import { HolyBattleRewardTabItem } from "./HolyBattleRewardTabItem"

//奖励展示界面
export class HolyBattleRewardView extends BaseView1 {
	InitEvent
	InitTab
	LoadSuccess
	Scr_scr_item
	Scr_scr_tab
	SwitchTab
	UpdateRewardTabRed
	UpdateView
	change_scene_close
	click_bg_toClose
	destroy_callback
	destroy_imm
	is_center
	open_callback
	parent_mask_corner
	preload_server_config
	show_open_movie
	use_background

	public static Score = 0
	public static Camp = 1

	public constructor() {
		super()


		this.base_file = "holyBattle"
		this.layout_file = "HolyBattleRewardView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.is_center = true
		this.use_background = true
		this.click_bg_toClose = true
		this.show_open_movie = true
		this.change_scene_close = true

		let local_HolyBattleModel_Instance = HolyBattleModel.GetInstance()
		let local_HolyBattleModel = HolyBattleModel
		let _tab_name_list = ["积分奖励", "神道奖励"]
		let _tab_data_list = null
		let _tab_arr = null
		let _default_index = HolyBattleRewardView.Score
		let _now_index_ = null
		let _item_arr:LoopScrowViewMgr = null
		this.preload_server_config = { "config_holy_spirit_battlefield_role_reward": false, "config_holy_spirit_battlefield_battle_reward": false }

		this.load_callback = () => {
			ResManager.GetInstance().SetOutsideImageSprite(this, this._Image1, GameResPath.GetIcon("team","ui_content_bg2"))
			this.LoadSuccess()
			// if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
			// 	this._lb_tips.size  = 18
			// }
		}

		this.open_callback = () => {
			//this.RegisterMask(this._view_item)
		}

		this.destroy_callback = () => {
			if (_tab_arr) {
				_tab_arr.DeleteMe()
				_tab_arr = null
			}

			if (_item_arr) {
				_item_arr.DeleteMe()
				_item_arr = null
			}
			_tab_data_list = null
		}

		this.LoadSuccess = () => {
			this.InitTab()
			this.UpdateRewardTabRed()
			this.InitEvent()
			HolyBattleModel.GetInstance().Fire(HolyBattleModel.REQUEST_PROTO, 21805)
		}

		this.InitTab = () => {
			if (!_tab_data_list) {
				_tab_data_list = []
			}
			for (let key in _tab_name_list) {

				let obj = _tab_name_list[key]
				table.insert(_tab_data_list, {
					name: obj,
					red_state: false
				})
			}
			if(!_tab_arr){
				_tab_arr = new LoopScrowViewMgr()
				_tab_arr.SetData(this._list_tab_con, HolyBattleRewardTabItem, _tab_data_list, LoopScrCon.Horizontal, 1, (item?) => {
					this.SwitchTab(item)
				})
			}else{
				_tab_arr.replaceAll(_tab_data_list)
			}
			
			_tab_arr.SetSelectIndex(_default_index)
		
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._img_close, () => {
				this.Close()
			}
				, this, true, null, null, null, null, LuaSoundManager.SOUND_UI.CLOSE)
			this.BindEvent(local_HolyBattleModel_Instance, local_HolyBattleModel.UPDATE_SCORE_DATA, () => {
				if (_now_index_ == HolyBattleRewardView.Score) {
					this.UpdateView()
				}
			}
			)
			this.BindEvent(local_HolyBattleModel_Instance, local_HolyBattleModel.REFRESH_RED_FLAG, (flag?) => {
				if (flag == local_HolyBattleModel.RedFlag.Open) {

				} else if (flag == local_HolyBattleModel.RedFlag.Reward) {
					this.UpdateRewardTabRed()
				}

			}
			)
		}

		this.SwitchTab = (index?) => {
			if (_now_index_ == index) {
				return
			}
			//_item_arr.SetSelectIndex(index)
			_now_index_ = index
			this.UpdateView()
		}

		this.UpdateRewardTabRed = () => {
			if (_tab_data_list && _tab_data_list[HolyBattleRewardView.Score]) {
				_tab_data_list[HolyBattleRewardView.Score].red_state = local_HolyBattleModel_Instance.HasRedFlag(local_HolyBattleModel.RedFlag.Reward)
				_tab_arr.replaceAll(_tab_data_list)
			}
		}

		this.UpdateView = () => {
			let list = []
			let mode = local_HolyBattleModel_Instance.GetMode()
			if (mode) {
				if (_now_index_ == HolyBattleRewardView.Score) {
					ResManager.GetInstance().SetImageSprite(this, this._img_title, "holyBattle_asset", "ui_slzc_jfjl_001", true)
					this._lb_tips.text = "积分奖励每次开活动会自动重置，请及时领取哦！"

					let holy_spirit_battlefield_role_reward_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_holy_spirit_battlefield_role_reward", false)//Config.Holyspiritbattlefieldrolereward
					let reward_list = local_HolyBattleModel_Instance.GetScoreRewardStateList()
					let score = local_HolyBattleModel_Instance.GetScore()
					let score_cfg = null
					if (reward_list) {
						for (let _tmpi in reward_list) {
							var vo = reward_list[_tmpi]
							score_cfg = holy_spirit_battlefield_role_reward_cfg[mode + "@" + vo.stage]

							table.insert(list,
								{
									type: _now_index_,
									point: score,
									stage: vo.stage, //阶段
									status: vo.status, //0 不能领取 1 可以领取， 2已经领取,
									need_point: score_cfg && score_cfg.point || 0,
									reward: score_cfg &&JSON.parse(score_cfg.reward) || [],
									parent_mask: this.parent_mask_corner
								})
						}
						table.sort(list, (a?, b?) => {
							if (a.status == b.status) {
								return a.stage < b.stage
							} else if (a.status == 1) {
								return true
							} else if (b.status == 1) {
								return false
							} else {
								return a.status < b.status
							}
						})
					}

				} else if (_now_index_ == HolyBattleRewardView.Camp) {
					ResManager.GetInstance().SetImageSprite(this, this._img_title, "holyBattle_asset", "uismfb_020c", true)
					this._lb_tips.text = "神道奖励将在比赛结束时自动发放"

					let holy_spirit_battlefield_battle_reward_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_holy_spirit_battlefield_battle_reward", false)//Config.Holyspiritbattlefieldbattlereward
					holy_spirit_battlefield_battle_reward_cfg = holy_spirit_battlefield_battle_reward_cfg && holy_spirit_battlefield_battle_reward_cfg[mode]
					if (holy_spirit_battlefield_battle_reward_cfg) {
						table.insert(list,
							{
								type: _now_index_,
								reward: JSON.parse(holy_spirit_battlefield_battle_reward_cfg.win_reward),
								desc: "当前所在神道" + HtmlColorTxt("战斗胜利", "'#d15e00'") + "可获以下奖励内容",
								parent_mask: this.parent_mask_corner
							}
						)

						table.insert(list,
							{
								type: _now_index_,
								reward: JSON.parse(holy_spirit_battlefield_battle_reward_cfg.fail_reward),
								desc: "当前所在神道" + HtmlColorTxt("战斗失败", "'#d15e00'") + "可获以下奖励内容",
								parent_mask: this.parent_mask_corner
							})
					}
				}

				if(!_item_arr){
					_item_arr = new LoopScrowViewMgr()
					_item_arr.SetData(this._list_item_con, HolyBattleRewardItem,list, LoopScrCon.Vertical)
				}else{
					_item_arr.replaceAll(list)
				}
				

			}
		}
	}


	public DeleteMe(){
		super.DeleteMe()
	}


_Image1:Laya.Image
_Image2:Laya.Image
_img_title:Laya.Image
_img_close:Laya.Image
_Image3:Laya.Image
_lb_tips:Laya.Label
_list_item_con:Laya.List
_list_tab_con:Laya.List
public GetComponents() {
[
this._Image1,
this._Image2,
this._img_title,
this._img_close,
this._Image3,
this._lb_tips,
this._list_item_con,
this._list_tab_con,
]
 = this.GetChildrenByNames([

"_Image1",
"_Image2",
"_img_title",
"_img_close",
"_Image3",
"_lb_tips",
"_list_item_con",
"_list_tab_con",
])
}
}
 window["HolyBattleRewardView"]= HolyBattleRewardView
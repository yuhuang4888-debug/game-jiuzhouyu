import { BaseView1 } from "../common/BaseView1"
import { CommonManager } from "../common/CommonManager"
import { CommonRewardItem } from "../common/CommonRewardItem"
import { EventName } from "../common/EventName"
import { Enum_UILayer, LayerManager } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { SoundManager } from "../common/SoundManager"
import { table } from "../common/table"
import { HolyBattleModel } from "../commonModel/HolyBattleModel"
import { SceneManager } from "../scene/SceneManager"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { SetSizeDeltaX, HtmlColorTxt, Color, GlobalTimerQuest, SetHtmlStyle, MakeListCenter } from "../util/Util"

export class HolyBattleResultView extends BaseView1 {
	CancelCountDown
	LoadSuccess
	LocalOpen_
	Remove
	Scr_Scroller1
	StartCountDown
	UpdateView
	back_login_toClose
	background_alpha
	click_bg_toClose
	destroy_callback
	destroy_imm
	is_center
	preload_server_config
	show_open_movie
	use_background

	public constructor() {
		super()


		this.base_file = "holyBattle"
		this.layout_file = "HolyBattleResultView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.is_center = true
		this.use_background = true
		this.background_alpha = 0.8
		this.show_open_movie = true
		this.click_bg_toClose = true
		this.back_login_toClose = true

		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName
		let local_Message = Message
		let local_TimeUtil = TimeUtil
		let local_HolyBattleModel_Instance = HolyBattleModel.GetInstance()
		let local_HolyBattleModel = HolyBattleModel
		let local_SceneManager_Instance = SceneManager.GetInstance()
		let local_LayerManager_Instance = LayerManager.GetInstance()
		let _data = null
		let _array_reward = null
		let voice
		this.preload_server_config = { "config_role_holy_spirit_battlefield_group": false, "config_holy_spirit_battlefield_battle_reward": false }
		this.load_callback = () => {
			SetHtmlStyle(this._lb_score1, { f: 22, c: "#5a1c20", ww: false, w: 167 })
			SetHtmlStyle(this._lb_score2, { f: 22, c: "#5a1c20", ww: false, w: 167 })
			SetHtmlStyle(this._lb_score3, { f: 22, c: "#5a1c20", ww: false, w: 167 })
			SetHtmlStyle(this._lb_my_camp, { f: 20, c: "#663915", ww: false, w: 210 })
			SetHtmlStyle(this._lb_rank, { f: 20, c: "#663915", ww: false, w: 210 })
			this.LoadSuccess()
		}

		this.destroy_callback = () => {
			this.Remove()
		}

		this.LoadSuccess = () => {

			this.UpdateView()
		}

		this.UpdateView = () => {
			let mode = local_HolyBattleModel_Instance.GetMode()

			if (mode) {
				let holy_spirit_battlefield_battle_reward = ResManager.GetInstance().GetGameConfigFromCache(this, "config_holy_spirit_battlefield_battle_reward", false)//Config.Holyspiritbattlefieldbattlereward
				holy_spirit_battlefield_battle_reward = holy_spirit_battlefield_battle_reward && holy_spirit_battlefield_battle_reward[mode]
				if (holy_spirit_battlefield_battle_reward) {
					let battle_reward = null
					let list = []
					if (_data.res == 1) {
						battle_reward = JSON.parse(holy_spirit_battlefield_battle_reward.win_reward)
					} else {
						battle_reward = JSON.parse(holy_spirit_battlefield_battle_reward.fail_reward)
					}
					for (let _tmpi in battle_reward) {
						var vo = battle_reward[_tmpi]
						table.insert(list,
							{
								size: 79,
								vo: {
									style: vo[0],
									typeId: vo[1],
									count: vo[2]
								},
								layer_value: this.layer_value
							})
					}
					if (!_array_reward) {
						_array_reward = new LoopScrowViewMgr()
						_array_reward.SetData(this._list_reward_con, CommonRewardItem, list, LoopScrCon.Horizontal)
					} else {
						_array_reward.replaceAll(list)
					}

					//list居中
					MakeListCenter(this._list_reward_con, 5, 126, 79)
				}
			}


			if (_data.group_list) {
				table.sort(_data.group_list, (a?, b?) => {
					if (a.tower_num == b.tower_num) {
						return b.point < a.point
					} else {
						return b.tower_num < a.tower_num
					}
				})

				let role_holy_spirit_battlefield_group = ResManager.GetInstance().GetGameConfigFromCache(this, "config_role_holy_spirit_battlefield_group", false)//Config.Roleholyspiritbattlefieldgroup
				let group_cfg = null
				let index = 1
				let my_group_rank = null
				for (let _tmpi in _data.group_list) {
					var vo = _data.group_list[_tmpi]
					group_cfg = role_holy_spirit_battlefield_group[vo.group_id]
					if (group_cfg) {
						this["_lb_name" + index].text = `${ group_cfg.name}`//index + "." + group_cfg.name
						this["_lb_count" + index].text = "x" + vo.tower_num
						this["_lb_score" + index].innerHTML = `总积分：${HtmlColorTxt(vo.point, "'#c85a37'")}`

						let textcolor = vo.group_id == _data.my_group_id && "#c85a37" || "#5a1c20"
						this["_lb_name" + index].color = textcolor
						if (vo.group_id == _data.my_group_id) {
							my_group_rank = index
						}
						index = index + 1
					}
				}

				group_cfg = role_holy_spirit_battlefield_group[_data.my_group_id]
				if (group_cfg) {
					this._lb_my_camp.innerHTML = "所在神道:" + HtmlColorTxt(group_cfg.name, "'#c85a37'")
				}

				this._lb_rank.innerHTML = "神道排名:" + HtmlColorTxt(my_group_rank, "'#c85a37'")
			}

			let state=_data.res == 1?2:1
		    voice=CommonManager.GetInstance().PlayFightingVoice(state)
			if (_data.res == 1) {
				ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg1, GameResPath.GetIcon("holyBattle", "com_up_bg1"))
				ResManager.GetInstance().SetImageSprite(this, this._img_tips1, "holyBattle_asset", "uijs_026", true)
			} else {
				ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg1, GameResPath.GetIcon("holyBattle", "com_up_bg2"))
				ResManager.GetInstance().SetImageSprite(this, this._img_tips1, "holyBattle_asset", "uijs_034", true)
			}
		}

		this.Remove = () => {

			if (voice) {
				SoundManager.GetInstance().StopSoundEffect(voice)
				voice = null
			}
			
			this.CancelCountDown()
			local_HolyBattleModel_Instance.ClearMonData()
			if (_array_reward) {
				_array_reward.DeleteMe()
				_array_reward = null
			}
			if (local_SceneManager_Instance.IsHolyBattleFightScene()) {
				local_HolyBattleModel_Instance.Fire(local_HolyBattleModel.REQUEST_PROTO, 21803)
			}
		}

		this.LocalOpen_ = (parms?) => {
			if (parms) {
				_data = parms[0]
			}
			super.Open()
		}

		let time_id_ = null
		this.StartCountDown = (func?, time?) => {
			this.CancelCountDown()
			time_id_ = GlobalTimerQuest.AddPeriodQuest(func, time, -1)
			func()
		}

		this.CancelCountDown = () => {
			if (time_id_) {
				GlobalTimerQuest.CancelQuest(time_id_)
				time_id_ = null
			}
		}


	}

	public Open(...new_args) {

		let parms = new_args
		this.LocalOpen_(parms)
	}

	public DeleteMe() {
		super.DeleteMe()
	}


_Group1:Laya.Box
_img_bg1:Laya.Image
_img_10:Laya.Image
_img_11:Laya.Image
_box_bg2:Laya.Box
_img_rank_bg1:Laya.Image
_img_rank_bg2:Laya.Image
_img_rank_bg3:Laya.Image
_img_rank_bg4:Laya.Image
_img_rank_f1:Laya.Image
_img_rank_f2:Laya.Image
_lb_my_camp:Laya.HTMLDivElement
_lb_rank:Laya.HTMLDivElement
_Label1:Laya.Label
_img_tips1:Laya.Image
_img_rank1:Laya.Image
_img_rank2:Laya.Image
_img_rank3:Laya.Image
_lb_name1:Laya.Label
_lb_name2:Laya.Label
_lb_name3:Laya.Label
_Image1:Laya.Image
_Image2:Laya.Image
_Image3:Laya.Image
_lb_count1:Laya.Label
_lb_count2:Laya.Label
_lb_count3:Laya.Label
_lb_score1:Laya.HTMLDivElement
_lb_score2:Laya.HTMLDivElement
_lb_score3:Laya.HTMLDivElement
_list_reward_con:Laya.List
public GetComponents() {
[
this._Group1,
this._img_bg1,
this._img_10,
this._img_11,
this._box_bg2,
this._img_rank_bg1,
this._img_rank_bg2,
this._img_rank_bg3,
this._img_rank_bg4,
this._img_rank_f1,
this._img_rank_f2,
this._lb_my_camp,
this._lb_rank,
this._Label1,
this._img_tips1,
this._img_rank1,
this._img_rank2,
this._img_rank3,
this._lb_name1,
this._lb_name2,
this._lb_name3,
this._Image1,
this._Image2,
this._Image3,
this._lb_count1,
this._lb_count2,
this._lb_count3,
this._lb_score1,
this._lb_score2,
this._lb_score3,
this._list_reward_con,
]
 = this.GetChildrenByNames([

"_Group1",
"_img_bg1",
"_img_10",
"_img_11",
"_box_bg2",
"_img_rank_bg1",
"_img_rank_bg2",
"_img_rank_bg3",
"_img_rank_bg4",
"_img_rank_f1",
"_img_rank_f2",
"_lb_my_camp",
"_lb_rank",
"_Label1",
"_img_tips1",
"_img_rank1",
"_img_rank2",
"_img_rank3",
"_lb_name1",
"_lb_name2",
"_lb_name3",
"_Image1",
"_Image2",
"_Image3",
"_lb_count1",
"_lb_count2",
"_lb_count3",
"_lb_score1",
"_lb_score2",
"_lb_score3",
"_list_reward_con",
])
}
}
 window["HolyBattleResultView"]= HolyBattleResultView
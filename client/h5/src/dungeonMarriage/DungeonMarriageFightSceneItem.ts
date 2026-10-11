import { BaseItem1 } from "../common/BaseItem1"
import { Config } from "../common/Config"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { MainUIManager } from "../common/MainUIManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { BaseDungeonModel } from "../commonModel/BaseDungeonModel"
import { SceneManager } from "../scene/SceneManager"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest, HtmlColorTxt, SetAnchoredPosition, SetHtmlCenter, SetSizeDelta, Util } from "../util/Util"
import { DungeonMarriageFightSceneRewardItem } from "./DungeonMarriageFightSceneRewardItem"

export class DungeonMarriageFightSceneItem extends BaseItem1 {
	CancelUnrealTime
	GetRefreshTime
	LoadSuccess
	OnTime
	Scr_Scroller1
	SetStar
	StartUnrealTime
	UpdateView
	loop_mgr
	unreal_time_id_

	public constructor(parent?) {
		super(parent)


		this.base_file = "dungeonMarriage"
		this.layout_file = "DungeonMarriageFightSceneItem"
		this.is_load_res = false
		let base_model = BaseDungeonModel.GetInstance()

		let scene_mgr = SceneManager.GetInstance()
		let local_laya = Laya
		let local_TimeUtil = TimeUtil
		let unreal_time_id_ = null
		let reward_attr_ = null
		let _start_time_ = null
		let _dungeon_grade_list_ = null
		let _cfg_ = null
		let _grade_ = null
		let _reward_list_ = null
		let _refresh_time_ = null

		this.preload_server_config = {
            "config_dungeon_score": false
        }
		this.load_callback = () => {
			this.LoadSuccess()
		}

		this.LoadSuccess = () => {
			this.Content.scrollBar.visible = false
			//this.form.SetInsetAndSizeFromParentEdge(luaRectTransform.Edge.Left,0,0)
			//this.form.SetInsetAndSizeFromParentEdge(RectTransform.Edge.Top, 0, 0)
			MainUIManager.GetInstance().AddMoveComponent(this, this.display_obj, false, MainUIManager.MOVE_TYPE.Left)
			SetAnchoredPosition(this, 0, 0)
			// ResManager.GetInstance().SetImageSprite(this, this._img_title, "marriage_asset", "uijh_001f", true)
			// ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("marriage", "uikf1vn_027"))
			// SetSizeDelta(this._img_bg, 249, 400)
			//reward_attr_ = eui. new ArrayCollection()
			//this._list_reward_con.dataProvider = reward_attr_
			//this._list_reward_con.itemRenderer = DungeonUnrealFightSceneRewardItem
			//this._list_reward_con.itemRendererSkinName = DungeonUnrealFightSceneRewardItemSin
			let cur_dun_id = scene_mgr.GetCurrDunId()
			// let level = cur_dun_id - DungeonUnrealEnterView.base_unreal_index
			this._lb_desc.text = "与伴侣一起组队通关完成副本，即可获得丰厚奖励"
			this.UpdateView()
			this.BindVar(base_model, "dungeon_scene_msg", (event_name?, vo?) => {
				if (!this.use_delete_method){
					this.UpdateView()
				}
			}
			)
			this.BindEvent(base_model, BaseDungeonModel.OPEN_DENGEON_RESULT_VIEW, () => {
				if (!this.use_delete_method){
					this.CancelUnrealTime()
				}
			}
			)
		}

		this.UpdateView = () => {
			let vo = base_model.GetDungeonSceneMsg()
			if (vo) {
				_start_time_ = vo.start_time
				this.StartUnrealTime()
			}
		}

		this.StartUnrealTime = () => {
			this.CancelUnrealTime()
			let cur_dun_id = scene_mgr.GetCurrDunId()
			let dungeon_score = ResManager.GetInstance().GetGameConfigFromCache(this, "config_dungeon_score", false)
			// [ts2lua]dungeon_score下标访问可能不正确
			let score_cfg = dungeon_score[cur_dun_id]
			let dungeon_grade_cfg = Config.PRELOAD_SERVER_CONFIG.config_dungeon_grade
			_cfg_ = score_cfg && JSON.parse(score_cfg.time_score_list)
			let dungeon_grade_list = []
			for (let key in dungeon_grade_cfg) {
				let vo = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_dungeon_grade.name, key, false, dungeon_grade_cfg)
				if (vo.dun_id == cur_dun_id) {
					table.insert(dungeon_grade_list, vo)
				}
			}
			_dungeon_grade_list_ = dungeon_grade_list
			_refresh_time_ = this.GetRefreshTime() + _start_time_
			if (!this.unreal_time_id_) {
				this.unreal_time_id_ = GlobalTimerQuest.AddPeriodQuest(this.OnTime, 1, -1)
			}
			//unreal_time_id_ = local_laya. new Timer(1000, 0)
			//unreal_time_id_:addEventListener(local_laya.TimerEvent.TIMER, this.OnTime, this)
			//unreal_time_id_:start()
			this.OnTime()
		}

		this.CancelUnrealTime = () => {
			if (this.unreal_time_id_) {
				GlobalTimerQuest.CancelQuest(this.unreal_time_id_)
				this.unreal_time_id_ = null
			}
		}

		this.OnTime = () => {
			if (this.use_delete_method){
				this.CancelUnrealTime()
				return
			}
			let left_time = _refresh_time_ - local_TimeUtil.getServerTime()
			if (left_time < 0) {
				_refresh_time_ = this.GetRefreshTime() + _start_time_
				if (_refresh_time_ > local_TimeUtil.getServerTime()) {
					this.OnTime()
				}
				return
			}
			let content = null
			if (_grade_ > 1) {
				content = HtmlColorTxt(local_TimeUtil.convertTime(left_time), "'#0a953e'") + "后降为" + (_grade_ - 1) + "星评价"
			} else {
				content = HtmlColorTxt(local_TimeUtil.convertTime(left_time), "'#0a953e'") + "后失败"
			}
			if (this._lb_level_tips){
				this._lb_level_tips.style.fontSize = 20
				this._lb_level_tips.style.color = "#663915"
				this._lb_level_tips.width = 245
				this._lb_level_tips.height = 22
				this._lb_level_tips.innerHTML = Util.StrToHTML(content)
				SetHtmlCenter(this._lb_level_tips, {"x":0, "w":249})
			}
		}

		this.GetRefreshTime = () => {
			let grade = 0
			let level = ""
			let start_time = _start_time_
			let score = 0
			let end_time = 0
			let time = local_TimeUtil.getServerTime() - start_time
			if (_cfg_) {
				for (let _tmpi in _cfg_) {
					var vo = _cfg_[_tmpi]
					if (Number(vo[0]) <= time && Number(vo[1]) >= time) {
						score = Number(vo[2])
						end_time = Number(vo[1])
						break
					}
				}
			}
			if (!end_time) {
				this.CancelUnrealTime()
				return
			}
			for (let _tmpi in _dungeon_grade_list_) {
				var v = _dungeon_grade_list_[_tmpi]
				if (v.min_score <= score && v.max_score >= score) {
					grade = v.grade
					_reward_list_ = ErlangParser.GetInstance().Parse(v.reward) || []
					if (!this.loop_mgr) {
						if (_reward_list_) {
							this.loop_mgr = new LoopScrowViewMgr()
							this.loop_mgr.SetData(this.Content, DungeonMarriageFightSceneRewardItem, _reward_list_, LoopScrCon.Horizontal)
						}
					} else {
						this.loop_mgr.replaceAll(_reward_list_)
					}
					//reward_attr_.source = _reward_list_
					//reward_attr_:refresh()
					break
				}
			}
			base_model.unreal_level = grade
			_grade_ = grade
			this.SetStar(grade)
			return end_time
		}

		this.SetStar = (index?) => {
			for (let i = 0; i < 3; i++) {
				if (index > i) {
					// [ts2lua]this下标访问可能不正确
					ResManager.GetInstance().SetImageSprite(this, this["_img_star" + i], "common_asset", "uifb_hsfb_008a")
				} else {
					// [ts2lua]this下标访问可能不正确
					ResManager.GetInstance().SetImageSprite(this, this["_img_star" + i], "common_asset", "uifb_hsfb_008b")
					//this["_img_star" + i].source = "common_asset.uifb_hsfb_008b"
				}
				
			}
		}
	}

	public DeleteMe() {
		this.CancelUnrealTime()
		if (this.loop_mgr) {
			this.loop_mgr.DeleteMe()
			this.loop_mgr = null
		}
		MainUIManager.GetInstance().RemoveMoveComponent(this)
		super.DeleteMe()
	}

	_gp_con: Laya.Box
	_img_bg: Laya.Image
_img_bg311:Laya.Image
_lb_title11:Laya.Label
	_lb_level_tips: Laya.HTMLDivElement
	_img_star0: Laya.Image
	_img_star1: Laya.Image
	_img_star2: Laya.Image
	Content: Laya.List
	_lb_desc: Laya.Label
	public GetComponents() {
		[
			this._gp_con,
			this._img_bg,
this._img_bg311,
this._lb_title11,
			this._lb_level_tips,
			this._img_star0,
			this._img_star1,
			this._img_star2,
			this.Content,
			this._lb_desc,
		]
			= this.GetChildrenByNames([

				"_gp_con",
				"_img_bg",
"_img_bg311",
"_lb_title11",
				"_lb_level_tips",
				"_img_star0",
				"_img_star1",
				"_img_star2",
				"Content",
				"_lb_desc",
			])
	}
}
window["DungeonMarriageFightSceneItem"] = DungeonMarriageFightSceneItem
import { BaseItem1 } from "../common/BaseItem1"
import { Enum_UILayer } from "../common/LayerManager"
import { MainUIManager } from "../common/MainUIManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { BaseDungeonModel } from "../commonModel/BaseDungeonModel"
import { DungeonPartnerModel } from "../commonModel/DungeonPartnerModel"
import { MainUIModel } from "../commonModel/MainUIModel"
import { SceneManager } from "../scene/SceneManager"
import { GameResPath } from "../util/GameResPath"
import { SYTweenFunc } from "../util/SYTweenFunc"
import { SYTweenLite } from "../util/SYTweenLite"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest } from "../util/Util"
import { DungeonPartnerFightKillInfoItem } from "./DungeonPartnerFightKillInfoItem"
import { DungeonPartnerFightStageInfoItem } from "./DungeonPartnerFightStageInfoItem"

export class DungeonPartnerFightSceneItem extends BaseItem1 {


	timer_id
	kill_info_item_list = []
	stage_info_item_list = []
	tween_ids = []

	model: DungeonPartnerModel
	base_model: BaseDungeonModel
	res_mgr: ResManager
	need_refresh_data
	data

	public constructor(parent) {
		super(parent)

		this.base_file = "dungeonPartner"
		this.layout_file = "DungeonPartnerFightSceneItem"
		this.base_model = BaseDungeonModel.GetInstance()
		this.model = DungeonPartnerModel.GetInstance()
		this.res_mgr = ResManager.GetInstance()
		this.layer_value = Enum_UILayer.Main

		this.preload_server_config = {
			"config_dungeon_score": false
		}


		this.load_callback = () => {
			this.LoadSuccess()
		}
	}

	public LoadSuccess() {

		this._html_grade_info.style.color = "#ffffff"
		this._html_grade_info.style.fontSize = 18
		this._html_grade_info.style.wordWrap = false

		if (!this.timer_id) {
			this.timer_id = GlobalTimerQuest.AddPeriodQuest(() => {
				this.UpdateScore()
			}, 1)
			this.UpdateScore()
		}

		if (this.need_refresh_data) {
			this.UpdateItem()
			this.need_refresh_data = null
		}

		this.InitEvent()
		this.model.Fire(DungeonPartnerModel.REQUEST_CCMD_EVENT, 61110)

		MainUIManager.GetInstance().AddMoveComponent(this, this._box_con, false, MainUIManager.MOVE_TYPE.Left)

		this._panel_content.vScrollBarSkin = ""
	}

	public InitEvent() {

		this.BindEvent(this.model, DungeonPartnerModel.UPDATE_PARTNER_SCENE_BATTLE_INFO, (scmd61110?) => {
			this.UpdateMonsterInfo(scmd61110)
		})

		// this.BindVar(BaseDungeonModel.GetInstance(), "dungeon_scene_msg",(event_name?, vo?) => {
		// 		this.UpdateView()
		// 	}
		// )
	}

	public StopAnimate() {
		if (this.tween_ids) {
			for (let _ in this.tween_ids) {
				let key = this.tween_ids[_]
				SYTweenLite.Stop(key)
			}
			this.tween_ids = []
		}
	}

	public SetData(data?) {
		this.data = data
		if (this.is_loaded) {
			this.UpdateItem()
		} else {
			this.need_refresh_data = true
		}
	}

	public UpdateItem() {

	}

	public UpdateScore() {
		let vo = this.base_model.GetDungeonSceneMsg()
		if (vo) {
			let start_time = vo.start_time
			let cost_time = TimeUtil.getServerTime() - start_time
			let dun_id = SceneManager.GetInstance().GetCurrDunId()
			console.log("============dun_id", dun_id)
			let cfgs = this.res_mgr.GetGameConfigFromCache(this, "config_dungeon_score", false)
			let score_cfg = cfgs[dun_id]
			if (score_cfg) {
				let time_score_list = JSON.parse(score_cfg.time_score_list)
				let cur_score
				let cur_stage_start_time
				let cur_stage_end_time
				if (time_score_list) {
					for (let _ in time_score_list) {
						let vo = time_score_list[_]
						if (Number(vo[0]) <= cost_time && Number(vo[1]) >= cost_time) {
							cur_stage_start_time = Number(vo[0])
							cur_stage_end_time = Number(vo[1])
							cur_score = Number(vo[2])
							break
						}
					}
				}
				if (cur_stage_end_time) {
					let left_second = cur_stage_end_time - cost_time
					this._html_grade_info.innerHTML = `${TimeUtil.timeConvert8(left_second)}后降为${cur_score - 1}星评价`


					//进度条
					this._img_progress.width = left_second / (cur_stage_end_time - cur_stage_start_time) * 154

					for (let i = 1; i <= 3; i++) {
						// this[`_img_star${i}`].visible = i <=cur_score
						ResManager.GetInstance().SetImageSprite(this, this[`_img_star${i}`], "dungeonPartner", i <= cur_score ? "star2" : "star_empty")
					}

				}
			}
		}
	}

	public UpdateMonsterInfo(scmd61110?) {

		let mon_lists = scmd61110.mon_lists
		let item,v
		
		for (let i = 0; i < mon_lists.length; i++) {
			v = mon_lists[i]
			item = this.kill_info_item_list[i]
			if(!item){
				item = new DungeonPartnerFightKillInfoItem(this._panel_content)
				item.Load()
				this.kill_info_item_list[i] = item
			}
			item.SetData(v)
			item.SetPosition(0, i * 43)
		}
		let total_height = mon_lists.length * 43

		let dun_id = SceneManager.GetInstance().GetCurrDunId()
		for (let i = 2; i >= 0; i -= 1) {
			item = this.stage_info_item_list[i]
			if(!item){
				item = new DungeonPartnerFightStageInfoItem(this._panel_content)
				item.Load()
				this.stage_info_item_list[i] = item
			}
			item.SetData({ dun_id: dun_id, star: i + 1, is_finish: false })
			item.SetPosition(0, total_height + (i - 2) * -103)
		}
	}

	public DeleteMe() {
		for (let i = 0; i < this.kill_info_item_list.length; i++) {
			let v = this.kill_info_item_list[i]
			v.DeleteMe()
		}
		this.kill_info_item_list.length = 0

		for (let i = 0; i < this.stage_info_item_list.length; i++) {
			let v = this.stage_info_item_list[i]
			v.DeleteMe()
		}
		this.stage_info_item_list.length = 0
		MainUIManager.GetInstance().RemoveMoveComponent(this)
		if (this.timer_id) {
			GlobalTimerQuest.CancelQuest(this.timer_id)
			this.timer_id = null
		}
		super.DeleteMe()
	}


	_box_con: Laya.Box
	_img_bg: Laya.Image
	_html_grade_info: Laya.HTMLDivElement
	_img_progress_bg: Laya.Image
	_img_progress: Laya.Image
	_img_star1: Laya.Image
	_img_star2: Laya.Image
	_img_star3: Laya.Image
	_img_star: Laya.Image
	_img_bg2: Laya.Image
	_img_bg3: Laya.Image
	_lb_title: Laya.Label
	_panel_content: Laya.Panel
	public GetComponents() {
		[
			this._box_con,
			this._img_bg,
			this._html_grade_info,
			this._img_progress_bg,
			this._img_progress,
			this._img_star1,
			this._img_star2,
			this._img_star3,
			this._img_star,
			this._img_bg2,
			this._img_bg3,
			this._lb_title,
			this._panel_content,
		]
			= this.GetChildrenByNames([

				"_box_con",
				"_img_bg",
				"_html_grade_info",
				"_img_progress_bg",
				"_img_progress",
				"_img_star1",
				"_img_star2",
				"_img_star3",
				"_img_star",
				"_img_bg2",
				"_img_bg3",
				"_lb_title",
				"_panel_content",
			])
	}
}
window["DungeonPartnerFightSceneItem"] = DungeonPartnerFightSceneItem
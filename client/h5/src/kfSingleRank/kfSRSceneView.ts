import { AutoFightManager } from "../autofight/AutoFightManager"
import { BaseItem1 } from "../common/BaseItem1"
import { EventName } from "../common/EventName"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { BaseDungeonModel } from "../commonModel/BaseDungeonModel"
import { kfSingleRankModel, kfSRTimer, kfSREvent, kfSingleRankDefine, DUN_NAME } from "../commonModel/kfSingleRankModel"
import { MainUIModel } from "../commonModel/MainUIModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { TimeUtil } from "../util/TimeUtil"
import { MakeListCenter, SetAnchoredPositionX, Util } from "../util/Util"
import { kfSRAwardItemC } from "./kfSRAwardItemC"
import { table } from "../common/table"
import { SYTweenLite } from "../util/SYTweenLite"
import { SceneManager } from "../scene/SceneManager"
import { Config } from "../common/Config"
import { ErlangParser } from "../util/ErlangParser"

export class kfSRSceneView extends BaseItem1 {
	CheckCountDown
	Clear
	ClearCountDown
	InitEvent
	LoadSuccess
	Scr_Scroller1
	StartTimer
	UpdateDunData
	UpdateTopData
	UpdateUseTimer
	loop_mgr
	_ms_time_
	tween_list

	public constructor(parent?) {
		super(parent)

		this.base_file = "kfSingleRank"
		this.layout_file = "kfSRSceneView"
		let _model = kfSingleRankModel.GetInstance()
		let local_kfSRTimer = kfSRTimer
		let local_kfSREvent = kfSREvent
		let local_MainUIModel = MainUIModel
		let local_laya = Laya
		let local_TimeUtil = TimeUtil
		let base_dungeon_model = BaseDungeonModel.GetInstance()
		let auto_fight_mgr = AutoFightManager.GetInstance()
		let _ac_list_ = null
		let _area_id_ = 0
		let _update_ms_ = 21
		let _count_id_ = null
		this._ms_time_ = 0
		this.tween_list = []
		this.preload_server_config = { "config_rank_dungeon": false }
		let scene_mgr = SceneManager.GetInstance()

		this.load_callback = () => {

			// if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
			// 	SetAnchoredPositionX(this._Label3,-30)
			// }
			this.LoadSuccess()
			_model.Fire(local_kfSREvent.REQUEST_PROTO, 50701)
		}

		this.Clear = () => {
			_model.ClearTimer(local_kfSRTimer.USE_TIME.key)
			this.ClearCountDown()
			_model.ClearAreaTopData()
			if (this.loop_mgr) {
				this.loop_mgr.DeleteMe()
				this.loop_mgr = null
			}
		}

		this.InitEvent = () => {
			this.BindEvent(_model, local_kfSREvent.UPDATE_TOP, (scmd?) => {
				if (_area_id_ == scmd.area_id) {
					this.UpdateTopData(scmd)
				}
			}
			)
			this.BindEvent(MainUIModel.GetInstance(), local_MainUIModel.UPDATE_ACTIVITY_STATE, (bool?) => {
				this.ClearTime()
				if (bool) {
					let tween_id = SYTweenLite.to(this, this._gp_data, SYTweenLite.UiAnimationType.POSX, - this._gp_data.width, local_MainUIModel.Move_Time_Interval)
					table.insert(this.tween_list, tween_id)

					tween_id = SYTweenLite.to(this, this._gp_tips_attack, SYTweenLite.UiAnimationType.ALPHA, 0, local_MainUIModel.Move_Time_Interval)
					table.insert(this.tween_list, tween_id)
				} else {
					let tween_id = SYTweenLite.to(this, this._gp_data, SYTweenLite.UiAnimationType.POSX, 0, local_MainUIModel.Move_Time_Interval)
					table.insert(this.tween_list, tween_id)

					tween_id = SYTweenLite.to(this, this._gp_tips_attack, SYTweenLite.UiAnimationType.ALPHA, 1, local_MainUIModel.Move_Time_Interval)
					table.insert(this.tween_list, tween_id)
				}
			}
			)
			this.BindEvent(_model, local_kfSREvent.UPDATE_DUN_DATA, (scmd?) => {
				this.UpdateDunData()
			}
			)
			this.BindEvent(_model, local_kfSREvent.UDPATE_RESULT, (scmd?) => {
				_model.ClearTimer(local_kfSRTimer.USE_TIME.key)
				this._lb_time_use.text = local_TimeUtil.timeConversionWithMillisecond(scmd.go_time, "mm:ss.ms")
			}
			)
			this.BindEvent(base_dungeon_model, BaseDungeonModel.UPDATE_DUNGEON_INFO, (vo?) => {
				this.CheckCountDown()
				// auto_fight_mgr.SetAutoFight(false)
				GlobalEventSystem.Fire(EventName.STARTAUTOFIGHT)
				this._lb_time_use.text = local_TimeUtil.timeConversionWithMillisecond(0, "mm:ss.ms")
			}
			)

			// this.BindEvent(GlobalEventSystem, EventName.STORY_FINISH, (sceneId?, play_index?) => {
			// 	this.StartTimer()
			// })

			// this.BindEvent(base_dungeon_model, BaseDungeonModel.CLEAR_DUNGEON_INFO, (sceneId?, play_index?) => {
			// 	this.data_vo = null
			// })


			// //如果不跳过剧情，动画会比较提前发协议给后端，为了同步时间，客户端也需要提前启动计时
			// this.BindEvent(StoryModel.Instance, StoryModel.EventName.ANIM_CLIP_FINISH,(type?) => {
			// 	if (type == Config.StoryConst.ImmStopServerStory ) {
			// 		this.StartTimer()
			// 	}
			// })
		}

		this.LoadSuccess = () => {
			this.InitEvent()
			this.UpdateDunData()
			this.CheckCountDown()
		}

		this.UpdateTopData = (scmd?) => {

			//let dinfo = _model.GetDunInfo()
			//let lv = (dinfo && ( dinfo.dun_id % 35000 ) || ( 0 ) )
			let cur_dun_id = scene_mgr.GetCurrDunId()
			let lv = (cur_dun_id && (cur_dun_id % 35000) || (0))

			let tdata = _model.GetAreaTopDataOne(scmd.area_id, lv)
			// let has_top = ! (not tdata)
			let has_top = tdata != null ? true : false
			this._gp_top.visible = has_top
			this._lb_empty.visible = !has_top
			if (has_top) {
				this._lb_name_top.text = `S${tdata.server_num}.${tdata.role_name}`
				this._lb_time_top.text = local_TimeUtil.timeConversionWithMillisecond(tdata.go_time, "mm:ss.ms")
			}
		}

		this.UpdateDunData = () => {
			if (!this.is_loaded) return
			let cur_dun_id = scene_mgr.GetCurrDunId()
			//let dinfo = _model.GetDunInfo()
			if (!cur_dun_id) {
				return
			}
			this._ms_time_ = 0
			let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_rank_dungeon", false)
			let lv = cur_dun_id % 35000//dinfo.dun_id % 35000
			let cur_lv = _model.GetCurLevel()
			let ldata = _model.GetPlayerLevelData(cur_lv)

			let _max_layer_ = Util.TableSize(cfg)
			let not_max = lv < _max_layer_
			_area_id_ = Math.floor(lv / kfSingleRankDefine.LAYER_COUNT)
			_area_id_ = not_max ? _area_id_ + 1 : _area_id_
			_model.Fire(local_kfSREvent.REQUEST_PROTO, 50703, "c", _area_id_)


			let ddata = _model.GetDunData(cfg, lv)

			//let pic = ddata.resource
			// this._lb_layer.text = lv+""
			// ResManager.GetInstance().SetImageSprite(this, this._img_name, "kfsinglerank_asset", "title_" + pic + ".png", true)
			//this._lb_title2.text=`${DUN_NAME[pic]} 第${lv}层`

			let scene_id = scene_mgr.GetSceneId()
			let config_dungeon_wave = ResManager.GetInstance().GetGameConfigFromCache(this, 'config_dungeon_wave', false)
			let cfg_vo = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_dungeon_wave.name, `${cur_dun_id}@${scene_id}@1@1`, false, config_dungeon_wave)
			if (cfg_vo && cfg_vo.mon_list) {
				let mon_list = ErlangParser.GetInstance().Parse(cfg_vo.mon_list)
				let mon_id = mon_list[0][0]
				let mon_cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_mon.name, mon_id, false)
				if (mon_cfg) {
					this._lb_title2.text = `${mon_cfg.name} 第${lv}层`
				} else {
					this._lb_title2.text = ` 第${lv}层`//兼容空配置
				}

			} else {
				this._lb_title2.text = ` 第${lv}层`//兼容空配置
			}


			let list = JSON.parse(ddata.reward)
			for (let _tmpi in list) {
				var vo = list[_tmpi]
				// [ts2lua]lua中0和空字符串也是true，此处cur_lv >= lv && ldata需要确认
				vo.rw_state = (cur_lv >= lv && ldata && (1) || (0))
			}
			// _ac_list_.source = list

			if (!this.loop_mgr) {
				this.loop_mgr = new LoopScrowViewMgr()
				this.loop_mgr.SetData(this.Content, kfSRAwardItemC, list, LoopScrCon.Horizontal)
			} else {
				this.loop_mgr.replaceAll(list)
			}
			this.Content.x = 21
			MakeListCenter(this.Content, 3, 21, 69)
		}

		this.StartTimer = () => {
			if (this._ms_time_ != 0) {
				return
			}
			let dun_msg = base_dungeon_model.GetDungeonSceneMsg()
			this._ms_time_ = dun_msg.start_time_ms  //local_TimeUtil.getServerTimeMs()
			_model.ClearTimer(local_kfSRTimer.USE_TIME.key)
			_model.StartTimer(local_kfSRTimer.USE_TIME.key, _update_ms_, () => {
				this.UpdateUseTimer()
			})
			_model.Fire(local_kfSREvent.START_COUNT_DOWN)
			GlobalEventSystem.Fire(EventName.STARTAUTOFIGHT)
		}

		this.UpdateUseTimer = () => {
			let time = local_TimeUtil.getServerTimeMs() - this._ms_time_
			this._lb_time_use.text = local_TimeUtil.timeConversionWithMillisecond(time, "mm:ss.ms")
		}

		this.CheckCountDown = () => {
			this.ClearCountDown()
			let dun_msg = base_dungeon_model.GetDungeonSceneMsg()
			if (!dun_msg) {
				return
			}
			this.StartTimer()
			// let time = dun_msg.start_time_ms - local_TimeUtil.getServerTimeMs() //+ kfSingleRankDefine.ACTION_TIME
			// if (time <= 0) {
			// 	return
			// }
			// _count_id_ = setTimeout(() => {
			// 	this.StartTimer()
			// }, time / 1000)
		}

		this.ClearCountDown = () => {
			if (_count_id_) {
				clearTimeout(_count_id_)
				_count_id_ = null
			}
		}
	}

	// public RunTime(vo?) {
	// 	this.data_vo = vo
	// 	this.CheckCountDown()
	// }

	ClearTime() {
		if (this.tween_list) {
			for (let _ in this.tween_list) {
				var tween_id = this.tween_list[_]
				SYTweenLite.Stop(tween_id)
			}
			this.tween_list = []
		}
	}


	public DeleteMe() {

		this.Clear()
		super.DeleteMe()
	}



	_gp_tips_attack: Laya.Box
	_Image1: Laya.Image
	_Image2: Laya.Image
	_box_1: Laya.Box
	_gp_data: Laya.Box
	_Image3: Laya.Image
	_Image2_title2: Laya.Image
	_lb_title2: Laya.Label
	_Image4: Laya.Image
	_Image5: Laya.Image
	_Label1: Laya.Label
	_Label2: Laya.Label
	Content: Laya.List
	_Group3: Laya.Box
	_Label3: Laya.Label
	_lb_time_use: Laya.Label
	_gp_top: Laya.Box
	_Group4: Laya.Box
	_Label4: Laya.Label
	_lb_time_top: Laya.Label
	_lb_name_top: Laya.Label
	_lb_empty: Laya.Label
	public GetComponents() {
		[
			this._gp_tips_attack,
			this._Image1,
			this._Image2,
			this._box_1,
			this._gp_data,
			this._Image3,
			this._Image2_title2,
			this._lb_title2,
			this._Image4,
			this._Image5,
			this._Label1,
			this._Label2,
			this.Content,
			this._Group3,
			this._Label3,
			this._lb_time_use,
			this._gp_top,
			this._Group4,
			this._Label4,
			this._lb_time_top,
			this._lb_name_top,
			this._lb_empty,
		]
			= this.GetChildrenByNames([

				"_gp_tips_attack",
				"_Image1",
				"_Image2",
				"_box_1",
				"_gp_data",
				"_Image3",
				"_Image2_title2",
				"_lb_title2",
				"_Image4",
				"_Image5",
				"_Label1",
				"_Label2",
				"Content",
				"_Group3",
				"_Label3",
				"_lb_time_use",
				"_gp_top",
				"_Group4",
				"_Label4",
				"_lb_time_top",
				"_lb_name_top",
				"_lb_empty",
			])
	}
}
window["kfSRSceneView"] = kfSRSceneView
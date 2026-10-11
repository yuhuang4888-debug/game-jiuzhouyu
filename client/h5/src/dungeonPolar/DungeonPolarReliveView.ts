import { BaseView1, OpenMode } from "../common/BaseView1"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { BaseDungeonModel } from "../commonModel/BaseDungeonModel"
import { SceneBaseType } from "../scene/SceneConfig"
import { SceneManager } from "../scene/SceneManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest } from "../util/Util"
import { Config } from "../common/Config"
export class DungeonPolarReliveView extends BaseView1 {
	CancelTime
	Delete
	InitEvent
	StartTime
	close_callback
	destroy_imm
	not_close_by_android_back_key
	onTimer
	open_callback
	open_mode
	updateRelive
	updateView
	use_background



	public constructor() {
		super()


		this.base_file = "dungeonPolar"
		this.layout_file = "DungeonPolarReliveView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.use_background = true
		this.background_alpha = 0.5
		this.is_center = true
		this.change_scene_close = true
		this.need_loading_view = false
		this.not_close_by_android_back_key = true
		let _model :BaseDungeonModel= BaseDungeonModel.GetInstance()
		let timer = null
		let close_time = 0
		let dead_time_wait = 0
		let local_SceneManager = SceneManager.GetInstance()
		let local_ResManager = ResManager.GetInstance()
		this.load_callback = () => {
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("boss", "com_up_bg2"))
			this.InitEvent()
			this.updateView()
		}

		this.open_callback = () => {
			if (local_SceneManager.IsKFPolarDungeon() && Number(_model.relive_time) <= 0) {
				this.Close()
				return
			}
		}



		this.close_callback = () => {
			this.CancelTime()
		}



		this.InitEvent = () => {
			this.BindEvent(_model, BaseDungeonModel.POLAR_DEAD_TIME, (time?) => {
				this.StartTime()
			}
			)

			this.BindEvent(_model, BaseDungeonModel.POLAR_RELIVE_TIME, () => {
				this.updateRelive()
			}
			)
		}



		this.updateView = () => {
			let kv_cfg = Config.PRELOAD_SERVER_CONFIG.config_week_dungeon_kv
			dead_time_wait = local_SceneManager.IsKFPolarDungeon() && Number(kv_cfg[0].value) || Number(kv_cfg[1].value)
			this._gp_title.visible = !local_SceneManager.IsPolarDungeon()
			let scene_mgr = local_SceneManager
			if (scene_mgr.killerType == SceneBaseType.Monster) {
				let mon_vo = scene_mgr.GetMonsterVo(scene_mgr.killerId)
				if (mon_vo) {
					let lv = mon_vo.level > 370 && "神创" + (mon_vo.level - 370) + "级" || "LV." + mon_vo.level
					let skill_str = scene_mgr.killerName + " " + lv

					local_ResManager.SetOutsideImageSprite(this, this._img_mon_head, GameResPath.GetMonsterHeadPath(mon_vo.cfg_data.icon))
					this._lb_des2.text = `很遗憾！您已被${skill_str}击杀!`
				}

			}
			this.StartTime()
			this.updateRelive()
		}



		this.StartTime = () => {
			this.CancelTime()
			if (!Number(_model.dead_time)) {
				close_time = dead_time_wait + TimeUtil.getServerTime()
			} else {
				close_time = dead_time_wait + _model.dead_time
			}

			if (!timer) {
				timer = GlobalTimerQuest.AddPeriodQuest(() => {
					this.onTimer()
				}, 1)
			this.onTimer()
			}
		}



		this.onTimer = () => {
			let left_time = close_time - TimeUtil.getServerTime()
			if (this._lb_left_count.visible) {
				this._lb_left_count.text = left_time + ""
			}
			if (left_time <= 0) {
				this.CancelTime()
				GlobalEventSystem.Fire(EventName.RELIVE_BY_TYPE, 9)
				this.Close()
				return
			}

		}



		this.CancelTime = () => {
			if (timer) {
				GlobalTimerQuest.CancelQuest(timer)
				timer = null
			}
		}



		this.updateRelive = () => {
			if (_model.relive_time != null && this._bm_relive_time ) {
				this._bm_relive_time.text = _model.relive_time + ""
			}
		}

	}



	public DeleteMe() {

		super.DeleteMe()
	}



_Group2:Laya.Box
_img_bg:Laya.Image
_img_bg2:Laya.Image
_gp_title:Laya.Box
_Image4:Laya.Image
_bm_relive_time:Laya.Label
_lb_left_count:Laya.Label
_lb_des2:Laya.Label
_lb_des:Laya.Label
_img_mon_head:Laya.Image
public GetComponents() {
[
this._Group2,
this._img_bg,
this._img_bg2,
this._gp_title,
this._Image4,
this._bm_relive_time,
this._lb_left_count,
this._lb_des2,
this._lb_des,
this._img_mon_head,
]
 = this.GetChildrenByNames([

"_Group2",
"_img_bg",
"_img_bg2",
"_gp_title",
"_Image4",
"_bm_relive_time",
"_lb_left_count",
"_lb_des2",
"_lb_des",
"_img_mon_head",
])
}
}
 window["DungeonPolarReliveView"]= DungeonPolarReliveView
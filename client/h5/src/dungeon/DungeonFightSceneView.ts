import { AutoFightManager } from "../autofight/AutoFightManager"
import { BaseView1 } from "../common/BaseView1"
import { Config } from "../common/Config"
import { EventName, ObjectEventType, SceneEventType } from "../common/EventName"
import { Enum_UILayer, LayerManager } from "../common/LayerManager"
import { MainUIManager } from "../common/MainUIManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { BaseDungeonModel, DUN_TYPE } from "../commonModel/BaseDungeonModel"
import { GuardModel } from "../commonModel/GuardModel"
import { MainUIModel } from "../commonModel/MainUIModel"
// import { TeamModel } from "../commonModel/TeamModel"
import { PlatformManager } from "../PlatformManager"
import { RoleManager } from "../commonModel/RoleManager"
import { Scene } from "../scene/Scene"
import { MonsterType } from "../scene/SceneConfig"
import { SceneManager } from "../scene/SceneManager"
import { SceneObj } from "../scene/sceneobj/SceneObj"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameMath } from "../util/GameMath"
import { GameResPath } from "../util/GameResPath"
import { Runner } from "../util/Runner"
import { SYTweenFunc } from "../util/SYTweenFunc"
import { SYTweenLite } from "../util/SYTweenLite"
import { TimeUtil } from "../util/TimeUtil"
import { DungeonCopperFightSceneItem } from "../dungeonMaterial/DungeonCopperFightSceneItem"
import { GlobalTimerQuest, SetHtmlStyle, Util } from "../util/Util"
import { DungeonMarriageFightSceneItem } from "../dungeonMarriage/DungeonMarriageFightSceneItem"

import "../dungeonExp/DungeonExpFightSceneItem"
import { DungeonEquipFightSceneItem } from "../dungeonEquip/DungeonEquipFightSceneItem"
import { TeamModel } from "../commonModel/TeamModel"
import { DungeonMainLineFightSceneItem } from "../dungeonMainLine/DungeonMainLineFightSceneItem"
import { DungeonPartnerFightSceneItem } from "../dungeonPartner/DungeonPartnerFightSceneItem"
import { DungeonDragonFightSceneItem } from "../dungeonDragon/DungeonDragonFightSceneItem"
import { DungeonReinItem } from "../dungeonRein/DungeonReinItem"
import { kfSingleRankModel, kfSREvent } from "../commonModel/kfSingleRankModel"
import { DungeonHeartFightSceneItem } from "../dungeonHeart/DungeonHeartFightSceneItem"
import { SoundManager } from "../common/SoundManager"
import { BossModel } from "../commonModel/BossModel"
import { DungeonGuildHelpItem } from "./DungeonGuildHelpItem"
import { HaloModel, HaloPrivilegeType } from "../commonModel/HaloModel"
export class DungeonFightSceneView extends BaseView1 {


	AddRunner
	CancelCountTime
	InitEvent
	LoadCustomLogic
	LoadSuccess
	Remove
	RemoveRunner
	ResetView
	ShowBeginEffect
	// ShowBossBornEffect
	ShowCountDown
	ShowFightCountDown
	ShowGuardImage
	ShowQuitTime
	ShowStartCountDown
	ShowTipsEffect
	StartCountTime
	Update
	UpdateDunType

	//副本评分相关
	SetScoreDisplay
	UpdateScore
	timer_score_id
	InitCountTime

	anim_list
	back_login_toClose
	base_model
	close_callback
	destroy_imm
	effect_anim
	horizontalCenter
	item_list
	open_callback
	percentWidth
	voice_vip_person_boss
	local_BossBaseModel_Instance
	guild_help_item: DungeonGuildHelpItem

	private flag: boolean = false;
	// 是否结束
	private end: boolean = false;
	public constructor() {
		super()

		this.base_file = "dungeonCommon"
		this.layout_file = "DungeonFightSceneView"
		this.layer_value = Enum_UILayer.Main
		this.destroy_imm = true
		this.back_login_toClose = true
		this.local_BossBaseModel_Instance = BossModel.GetInstance()
		this.base_model = BaseDungeonModel.GetInstance()
		let layer_mgr = LayerManager.GetInstance()
		let local_BaseDungeonModel = BaseDungeonModel
		let local_DUN_TYPE = DUN_TYPE
		let local_TimeUtil = TimeUtil
		let local_GlobalEventSystem = GlobalEventSystem
		let local_ObjectEventType = ObjectEventType
		let scene = Scene.GetInstance()
		let local_Config = Config
		let local_SceneEventType = SceneEventType
		let scene_mgr = SceneManager.GetInstance()
		let guard_model = GuardModel.GetInstance()
		let local_GuardModel = GuardModel
		let auto_fight_mgr = AutoFightManager.GetInstance()
		let runner = Runner.GetInstance()

		let dun_type_ = 0
		let is_show_tween_ = false
		let time_id_ = null
		let update_times_index_ = 0
		let update_id_ = null
		let mainui_mgr = MainUIManager.GetInstance()


		this.anim_list = []
		this.effect_anim = []

		this.preload_server_config = {
			"config_dungeon": false,
			"config_dungeon_score": false
		}


		this.load_callback = () => {
			// this.percentWidth = 100
			this.display_obj.left = this.display_obj.right = this.display_obj.bottom = 0
			this.display_obj.top = Util.GetLiuhaiHeight()
			this.SetScoreDisplay(false)
			this.LoadSuccess()

		}

		this.open_callback = () => {

			this.LoadCustomLogic()
		}

		this.close_callback = () => {
			this.Remove()
		}

		this.destroy_callback = () => {

		}

		this.LoadSuccess = () => {
			mainui_mgr.AddMoveComponent(this, this._box_top, false, MainUIManager.MOVE_TYPE.Top)
			mainui_mgr.AddMoveComponent(this, this._btn_leave, false, MainUIManager.MOVE_TYPE.Left)
			ResManager.GetInstance().LoadFont(this, "scene_damage_mainrole", this._lb_start_count_down, 18)
			ResManager.GetInstance().LoadFont(this, "scene_damage_mainrole", this._lb_fight_count_down, 16)

			//resource/game/dungeonRune/other/ui_copy_cj_bg.png
			ResManager.GetInstance().SetOutsideImageSprite(this, this.Image4, GameResPath.GetIconOtherPath("dungeonRune", "ui_copy_cj_bg"))
			//resource/game/dungeonRune/other/ui_copy_cj.png
			ResManager.GetInstance().SetOutsideImageSprite(this, this.Image5, GameResPath.GetIconOtherPath("dungeonRune", "ui_copy_cj"))

			ResManager.GetInstance().LoadFont(this, "dungeon_rune_floor", this._lb_floor, 110)

			this.display_obj.left = this.display_obj.right = this.display_obj.bottom = 0
			this.display_obj.top = Util.GetLiuhaiHeight()

			Util.AddClickEvent(this._btn_leave, () => {
				this.base_model.exit()
			}, this, true)

			this.guild_help_item = new DungeonGuildHelpItem(this._box_guild_help)
			this.guild_help_item.Load()
			// this.guild_help_item.SetVisible(false)

			//this._gp_count_down.visible = false 
			let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_dungeon", false)
			this.base_model.InitTurnRelation(cfg)
			this.UpdateDunType()
			if (!dun_type_) {
				return
			}
			// [ts2lua]DungeonFightSceneView.DungeonFightSceneConfig下标访问可能不正确
			let func = DungeonFightSceneView.DungeonFightSceneConfig[dun_type_]
			if (func) {
				func(this)
			} else {
				this.InitCountTime()
			}


			if (scene_mgr.IsReincarnationDungeon()) {
				this.ShowGuardImage()
				this.BindEvent(
					guard_model,
					local_GuardModel.UPDATA_VIEW, () => {
						this.ShowGuardImage()
					}
				)
				Util.AddClickEvent(
					this._gp_guard, () => {
						guard_model.Fire(local_GuardModel.OPEN_VIEW, 2)
					},
					this,
					true
				)
			}

			this.AddRunner()
			this.InitEvent()
		}

		this.InitCountTime = () => {
			this.BindEvent(
				this.base_model,
				local_BaseDungeonModel.UPDATE_DUNGEON_INFO, (vo?) => {
					this.ShowCountDown(true)
					let end_time = vo.end_time
					// console.warn("@@@@@@@@@@@@@@@@@@",vo)
					this.StartCountTime(
						2, () => {
							let left_time = end_time - local_TimeUtil.getServerTime()
							if (left_time < 0) {
								this.CancelCountTime(2)
								this.ShowCountDown(false)
								return
							}
							this._lb_count_down.text = local_TimeUtil.timeConvert8(left_time)
						}
					)
				}
			)
		}

		this.InitEvent = () => {

			//专属大妖击杀
			this.BindEvent(this.local_BossBaseModel_Instance, BossModel.VIP_PERSON_BOSS_kill, () => {
				//this.voice_vip_person_boss = CommonManager.GetInstance().PlayFightingVoice(2)
			}
			)


			let index = 0
			let wave_count = 3
			this.BindEvent(
				local_GlobalEventSystem,
				local_ObjectEventType.OBJ_DEAD, (id?, compress_id?) => {
					let monster = scene.GetMonsterDeadBody(id)
					if (monster) {
						let config =
							local_Config.GetConfigVo(local_Config.ConfigHasDefaultValue.config_mon.name, monster.GetVo().type_id, false)
						if (config && config.boss == local_BaseDungeonModel.Show_Drop_Mon_Type) {
							if (this.base_model.IsShowDropDungeonType(dun_type_)) {
								this.base_model.SetDungeonMonsterDeadPos({ x: monster.real_pos.x, y: monster.real_pos.y })
							}
						}
					}
				}
			)
			this.BindEvent(
				local_GlobalEventSystem,
				local_SceneEventType.MONSTER_VO_ADD, (ins_id?, monster_vo?) => {

				}
			)
			this.BindEvent(
				BaseDungeonModel.GetInstance(),
				BaseDungeonModel.TIMING_UPDATE_EXP, (time: number) => {
					Laya.timer.clearAll(this);
					if (!this.flag && !this.end) {
						this.TimingRequestExp(time);
					}
				}
			)
			this.BindEvent(
				local_GlobalEventSystem,
				local_SceneEventType.SCENE_CHANGED, () => {
					this.ResetView()
					this.UpdateDunType()
					this.LoadCustomLogic()
				}
			)

			this.BindEvent(
				local_GlobalEventSystem,
				local_SceneEventType.SCENE_REENTER, () => {
					this.base_model.EnterSceneStart()
					if (dun_type_ == local_DUN_TYPE.Rune) {
						this.LoadCustomLogic()
					}
				}
			)

			var onMainRoleMoveHandler = (mx?, my?) => {
				//检测坐标触发事件
				mx = mx || RoleManager.Instance.mainRoleInfo.pos_x
				my = my || RoleManager.Instance.mainRoleInfo.pos_y
				//this:UpdateArrowPos(mx, my)
				for (let i = 0; i < this.base_model.role_pos_event_list.length; i++) {
					var vo = this.base_model.role_pos_event_list[i]
					if (SceneManager.Instance.GetSceneId() == vo.scene_id && vo.trigger_state == 1) {
						let tx = vo.pos_x, ty = vo.pos_y
						let x_range = vo.x_range, y_range = vo.y_range
						// console.log("tx, ty,mx, my, x_range, y_range = ", tx, ty, mx, my, x_range, y_range)
						if (Math.abs(tx - mx) <= x_range && Math.abs(ty - my) <= y_range) {
							vo.trigger_state = 2
							this.base_model.TriggerFlushMonster(tx, ty)
						}
					}
				}
			}
			onMainRoleMoveHandler()
			this.BindEvent(GlobalEventSystem, ObjectEventType.MAINROLE_MOVE_EVENT, onMainRoleMoveHandler)



		}

		this.UpdateDunType = () => {
			let cur_dun_id = scene_mgr.GetCurrDunId()
			dun_type_ = this.base_model.GetDunType(cur_dun_id)
			//20//
		}

		this.LoadCustomLogic = () => {
			if (!dun_type_) {
				return
			}

			if (scene_mgr.IsReincarnationDungeon()) {
				this.ShowBeginEffect()
			}


			this.base_model.Fire(local_BaseDungeonModel.SCMD_REQUEST, 61004)
			this.base_model.Fire(local_BaseDungeonModel.SCMD_REQUEST, 61018)
			this.base_model.Fire(local_BaseDungeonModel.SCMD_REQUEST, 61030)

			if (dun_type_ == local_DUN_TYPE.Tower || dun_type_ == local_DUN_TYPE.Rune || dun_type_ == local_DUN_TYPE.Pet) {
				let cur_floor = 0
				let cur_dun_id = scene_mgr.GetCurrDunId()
				if (dun_type_ == local_DUN_TYPE.Rune) {
					cur_floor = cur_dun_id - local_BaseDungeonModel.Rune_Floor_Modulus
				} else if (dun_type_ == local_DUN_TYPE.Pet) {
					cur_floor = cur_dun_id - this.base_model.pet_dun_id
				}
				this._lb_floor.text = String(cur_floor)
				this.ShowCountDown(true)
				is_show_tween_ = true
				this.ShowTipsEffect()
			}
		}

		this.ResetView = () => {
			this._gp_quit_time.visible = false
		}

		this.ShowCountDown = (bool?) => {
			if (!is_show_tween_) {
				this._gp_count_down.visible = bool
			}
		}

		this.ShowFightCountDown = (bool?) => {
			if (bool) {
				// ResManager.GetInstance().SetOutsideImageSprite(
				// 	this,
				// 	this._img_fight_count_down,
				// 	GameResPath.GetIcon("dungeonCommon", "common_18"),
				// 	true
				// )
				//mainui_mgr.AddMoveComponent(this, this._gp_fight_count_down, false, MainUIManager.MOVE_TYPE.Right)
			}
			else {
				//mainui_mgr.RemoveMoveOneComponent(this, this._gp_fight_count_down)
				//移除管理要重置位置
				this._gp_fight_count_down.centerX = 0
			}
			this._gp_fight_count_down.visible = bool
		}

		this.ShowStartCountDown = (bool?) => {
			if (bool) {
				// ResManager.GetInstance().SetOutsideImageSprite(
				// 	this,
				// 	this._img_start_count_down,
				// 	GameResPath.GetIcon("dungeonCommon", "common_15"),
				// 	true
				// )
			}
			this.ShowFightCountDown(!bool)
			this._gp_start_count_down.visible = bool
		}

		this.ShowQuitTime = (end_time?, end_func?) => {
			if (!this._gp_quit_time.visible) {
				ResManager.GetInstance().SetImageSpriteTrans(this, this._img_quit_bg, GameResPath.GetIcon("dungeonCommon", "uigh_040"), true)
				this._gp_quit_time.visible = true
			}
			this.ShowCountDown(false)
			this.StartCountTime(
				4, () => {
					let left_time = end_time - local_TimeUtil.getServerTime()
					if (left_time < 0) {
						this.CancelCountTime(4)
						if (end_func) {
							end_func()
						}
						return
					}
					if (this._lb_quit_time) {
						this._lb_quit_time.changeText(`${left_time}`)
					}
				}
			)
		}

		/**副本评分展示 */
		this.SetScoreDisplay = (bool) => {
			this._box_con.visible = bool
			if (bool) {
				SetHtmlStyle(this._html_grade_info, { c: "#ffffff", f: 18, ww: false })
				if (!this.timer_score_id) {
					this.timer_score_id = GlobalTimerQuest.AddPeriodQuest(() => {
						this.UpdateScore()
					}, 1)
					this.UpdateScore()
				}
			} else {
				if (this.timer_score_id) {
					GlobalTimerQuest.CancelQuest(this.timer_score_id)
					this.timer_score_id = null
				}
			}
		}

		this.UpdateScore = () => {
			let vo = this.base_model.GetDungeonSceneMsg()
			if (vo) {
				let start_time = vo.start_time
				let cost_time = TimeUtil.getServerTime() - start_time
				let dun_id = SceneManager.GetInstance().GetCurrDunId()
				console.log("============dun_id", dun_id)
				let cfgs = ResManager.GetInstance().GetGameConfigFromCache(this, "config_dungeon_score", false)
				if (cfgs && cfgs[dun_id]) {
					let time_score_list = JSON.parse(cfgs[dun_id].time_score_list)
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
					if (cur_stage_end_time /**&& (cur_score - 1) >= 0*/) {
						let left_second = cur_stage_end_time - cost_time

						if ((cur_score - 1) >= 0) {
							this._html_grade_info.innerHTML = `${TimeUtil.timeConvert8(left_second)}后降为${cur_score - 1}星评价`
						} else {
							this._html_grade_info.innerHTML = `${TimeUtil.timeConvert8(left_second)}后副本结束`
						}



						//进度条
						this._img_progress.width = left_second / (cur_stage_end_time - cur_stage_start_time) * 154

						for (let i = 1; i <= 3; i++) {
							ResManager.GetInstance().SetImageSprite(this, this[`_img_star${i}`], "dungeonCommon", i <= cur_score ? "star2" : "star_empty")
						}

					}
				}
			}
		}

		this.StartCountTime = (index?, func?) => {
			if (!time_id_) {
				time_id_ = {}
			}
			this.CancelCountTime(index)
			time_id_[index] = GlobalTimerQuest.AddPeriodQuest(func, 1)
			func()
		}

		this.CancelCountTime = (index?) => {
			if (index == null) {
				if (!time_id_) {
					return
				}
				if (time_id_) {
					for (let key in time_id_) {
						GlobalTimerQuest.CancelQuest(time_id_[key])
						delete time_id_[key]
					}
					time_id_ = null
				}

			} else {
				if (time_id_ && time_id_[index]) {
					GlobalTimerQuest.CancelQuest(time_id_[index])
					delete time_id_[index]
				}

			}
		}

		// this.ShowBossBornEffect = () => {
		// GlobalEventSystem.Fire(EventName.STOPAUTOFIGHT)

		// let call_back_func = () => {
		// 	GlobalEventSystem.Fire(EventName.STARTAUTOFIGHT)
		// }

		// this.AddUIEffect("effect_ui_dayaolaixi", this._gp_born_effect, null, null, null, call_back_func)
		// }

		this.ShowTipsEffect = () => {
			if (!this._gp_tips.visible) {
				this._gp_tips.visible = true
			}
			auto_fight_mgr.SetAutoFight(false)
			let stage_width = layer_mgr.stageWidth
			let value = stage_width / 2 + this._gp_tips.width / 2
			this._gp_tips.centerX = - value


			this.effect_anim.push(SYTweenLite.to(this, this._gp_tips, SYTweenLite.UiAnimationType.CENTER_POSX, 0, 0.3, () => {
					setTimeout(() => {
						if (this.use_delete_method) {
							return
						}
						this.effect_anim.push(SYTweenLite.to(
							this,
							this._gp_tips,
							SYTweenLite.UiAnimationType.CENTER_POSX,
							value,
							0.3, () => {
								auto_fight_mgr.SetAutoFight(true)
								if (this.effect_anim && this.effect_anim.length > 0) {
									for (let i = 0; i < this.effect_anim.length; i++) {
										var v = this.effect_anim[i]
										SYTweenLite.Stop(v)
									}
									this.effect_anim = []
								}
								is_show_tween_ = false
								this._gp_tips.visible = false
							},
							SYTweenFunc.EASE_IN_OUT,
							false
						))

					},500)
				}, SYTweenFunc.EASE_IN_OUT, false))

		}

		this.Update = (now_time?, elapse_time?) => {
			update_times_index_ = update_times_index_ + 1
			if (update_times_index_ % 5 == 0) {
				let pick_list = []
				let monster_list = scene.GetMonsterList()
				let main_role_vo = RoleManager.GetInstance().GetMainRoleVo()
				for (let ins_id in monster_list) {

					// [ts2lua]monster_list下标访问可能不正确
					let monster = monster_list[ins_id]
					if (monster.GetVo().type == MonsterType.PICK && !monster.IsModelHiden()) {
						let mx = main_role_vo.pos_x
						let my = main_role_vo.pos_y
						let x, y = monster.GetRealPos()
						let range = 90
						if (GameMath.GetDistance(mx, my, x, y, false) <= range * range) {
							// table.insert(pick_list, ins_id)
							pick_list.push(ins_id)
							monster.SetModelHideFlag(SceneObj.ModelHideFlag.ServerHide, true)
						}
					}
				}
				if (pick_list.length > 0) {
					local_GlobalEventSystem.Fire(local_ObjectEventType.MAIN_ROLE_COLLIDE_MONSTER, pick_list)
				}
			}
		}

		this.AddRunner = () => {
			if (!update_id_) {
				update_id_ = runner.AddRunObj(this)
			}
		}

		this.RemoveRunner = () => {
			if (update_id_) {
				runner.RemoveRunObj(update_id_)
				update_id_ = null
			}
		}

		this.Remove = () => {

			if (this.voice_vip_person_boss) {
				SoundManager.GetInstance().StopSoundEffect(this.voice_vip_person_boss)
				this.voice_vip_person_boss = null
			}

			//this:ClearUIEffect(this._gp_tips_effect)
			//this:ClearUIEffect(this.custom_effect)
			//if (this.anim_list && this.anim_list.length > 0 ) {
			//for (let i = 0; i < this.anim_list.length; i++) {
			// var v = this.anim_list[i]
			//SYTweenLite.Stop(v)
			//}
			//this.anim_list = []
			//}


			if (this.guild_help_item) {
				this.guild_help_item.DeleteMe()
			}
			this.guild_help_item = undefined

			mainui_mgr.RemoveMoveComponent(this)

			this.CancelCountTime()
			if (this.item_list) {
				for (let _tmpi in this.item_list) {
					var obj = this.item_list[_tmpi]
					obj.DeleteMe()
				}
				this.item_list = null
			}

			this.RemoveRunner()

			Laya.timer.clearAll(this);
			this.flag = false;
			this.end = false;


			if (this.timer_score_id) {
				GlobalTimerQuest.CancelQuest(this.timer_score_id)
				this.timer_score_id = null
			}
		}

		this.ShowGuardImage = () => {
			let bool = false
			let magic_circle_lv = 2
			let open = guard_model.OpenStatus(magic_circle_lv)
			if (!open) {
				return
			}
			let [type1, type2] = guard_model.GetGuardActiveType()
			bool = type2 != null
			Util.SetImageGray(this._img_guard, !bool)
			this._gp_guard.visible = !bool
			if (!bool) {
				type2 = 2
				ResManager.GetInstance().SetImageSprite(this, this._img_guard, "dungeonCommon", "guard" + type2 + "_1", true)
				MainUIManager.GetInstance().AddMoveComponent(this, this._gp_guard, false, MainUIManager.MOVE_TYPE.Right)
			} else {
				MainUIManager.GetInstance().RemoveMoveOneComponent(this, this._gp_guard)
			}
			return bool
		}

		this.ShowBeginEffect = () => {
			let end_fun = () => {
				auto_fight_mgr.SetAutoFight(true)
				this.ShowCountDown(true)
			}
			end_fun()
			//还没有特效，所以目前先直接开启副本

			// auto_fight_mgr.SetAutoFight(false)
			// this.ShowCountDown(false)
			// this.AddUIEffect(
			// 	"UI_1120",
			// 	this.custom_effect,
			// 	false,
			// 	false,
			// 	false,
			// 	{ call_back_func: end_fun }
			// )
		}
	}

	public static DungeonFightSceneConfig = {
		[DUN_TYPE.Exp]: (self) => {
			self.ShowFightCountDown(true)
			self.BindEvent(
				BaseDungeonModel.GetInstance(),
				BaseDungeonModel.UPDATE_DUNGEON_INFO, (vo?) => {
					let end_time = vo.end_time
					self.StartCountTime(
						1, () => {
							let left_time = end_time - TimeUtil.getServerTime()
							if (left_time < 0) {
								self.ShowFightCountDown(false)
								self.CancelCountTime(1)
								self.end = true;
								Laya.timer.clearAll(self);
								return
							}
							self._lb_fight_count_down.text = String(left_time)
						}
					)
				}
			)
			self.BindEvent(
				self.base_model,
				BaseDungeonModel.NEXT_WAVE_TIME_INFO, (wave_num?, left_time?) => {
					self.ShowStartCountDown(true)

					let end_time = left_time
					let call_func = () => {
						self.CancelCountTime(3)
						self.ShowStartCountDown(false)
						BaseDungeonModel.GetInstance().Fire(BaseDungeonModel.SHOW_EXP_DETAIL)

					}

					if (wave_num > 1) {
						call_func()
					}
					else {
						self.StartCountTime(
							3, () => {
								let left_time = end_time - TimeUtil.getServerTime()
								if (left_time < 0) {
									call_func();
									BaseDungeonModel.GetInstance().Fire(BaseDungeonModel.SCMD_REQUEST, 61119);
									return
								}
								self._lb_start_count_down.text = `${left_time}`//String(left_time)
							}
						)
					}
				}
			)
			if (!self.item_list) {
				self.item_list = []
			}
			let view_class = window["DungeonExpFightSceneItem"]

			if (!view_class) return
			let item = new view_class(self._gp_item_con)
			// table.insert(self.item_list, item)
			self.item_list.push(item)
			item.Load()
		},

		[DUN_TYPE.Soul]: (self) => {
			// if (! this.item_list ) {
			// 	this.item_list = []
			// }
			// let item =  new DungeonSoulSceneView(this._gp_item_con)
			// table.insert(this.item_list, item)
			// this._btn_leave.visible = false 
			// this.ShowCountDown(false)
			// //item.percentHeight = 100
			// //item.percentWidth = item.percentHeight
			// item.Load()
		},
		[DUN_TYPE.Unreal]: (self) => {
			// this.BindEvent(BaseDungeonModel.GetInstance(), BaseDungeonModel.UPDATE_DUNGEON_INFO,(vo?) => {
			// 		this.ShowCountDown(true)
			// 		let end_time = vo.end_time
			// 		this.StartCountTime(2,() => {
			// 				let left_time = end_time - TimeUtil.getServerTime()
			// 				if (left_time < 0 ) {
			// 					this.CancelCountTime(2)
			// 					this.ShowCountDown(false)
			// 					return
			// 				}
			// 				this._lb_count_down.text = TimeUtil.timeConvert8(left_time)
			// 			}
			// 		)
			// 	}
			// )
			// if (! this.item_list ) {
			// 	this.item_list = []
			// }
			// let item =  new DungeonUnrealFightSceneItem(this._gp_item_con)
			// table.insert(this.item_list, item)
			// //item.percentHeight = 100
			// //item.percentWidth = item.percentHeight
			// item.Load()
		},
		[DUN_TYPE.MonsterInvasion]: (self) => {
			self.BindEvent(
				BaseDungeonModel.GetInstance(),
				BaseDungeonModel.UPDATE_DUNGEON_INFO, (vo?) => {
					self.ShowCountDown(true)
					let end_time = vo.end_time
					self.StartCountTime(
						2, () => {
							let left_time = end_time - TimeUtil.getServerTime()
							if (left_time < 0) {
								self.CancelCountTime(2)
								self.ShowCountDown(false)
								return
							}
							self._lb_count_down.text = TimeUtil.timeConvert8(left_time)
						}
					)
				}
			)
			if (!self.item_list) {
				self.item_list = []
			}
		},
		[DUN_TYPE.New_Main_Line]: (self) => {
			self.BindEvent(
				BaseDungeonModel.GetInstance(),
				BaseDungeonModel.UPDATE_DUNGEON_INFO, (vo?) => {
					let end_time = vo.end_time
					console.log("//////UPDATE_DUNGEON_INFO//////", vo.end_time, TimeUtil.getServerTime())
					self.StartCountTime(
						2, () => {
							let left_time = end_time - TimeUtil.getServerTime()
							if (left_time < 0) {
								self.ShowCountDown(false)
								self.CancelCountTime(2)
								return
							}

							self.ShowCountDown(true)
							self._lb_count_down.text = TimeUtil.timeConvert8(left_time)
						}
					)
				}
			)
			if (!self.item_list) {
				self.item_list = []
			}
			let item = new DungeonMainLineFightSceneItem(self._gp_item_con)
			// table.insert(self.item_list, item)
			self.item_list.push(item)
			item.Load()
		},
		[DUN_TYPE.Marriage]: (self) => {
			self.BindEvent(BaseDungeonModel.GetInstance(), BaseDungeonModel.UPDATE_DUNGEON_INFO, (vo?) => {
				self.ShowCountDown(true)
				let end_time = vo.end_time
				self.StartCountTime(2, () => {
					let left_time = end_time - TimeUtil.getServerTime()
					if (left_time < 0) {
						self.CancelCountTime(2)
						self.ShowCountDown(false)
						return
					}
					self._lb_count_down.text = TimeUtil.timeConvert8(left_time)
				}
				)
			}
			)
			if (!self.item_list) {
				self.item_list = []
			}
			let item = new DungeonMarriageFightSceneItem(self._gp_item_con)
			self.item_list.push(item)
			item.Load()
		},
		[DUN_TYPE.Equip]: (self) => {
			// [ts2lua]window下标访问可能不正确
			//if (! window["BossHelpRolePanel"] ) {
			//if (! ResManager.GetInstance().IsJsLoad("boss") ) {

			//}
			//}
			self.BindEvent(
				self.base_model,
				BaseDungeonModel.UPDATE_DUNGEON_END_TIME, (end_time?) => {
					if (SceneManager.GetInstance().IsEquipDungeon()) {

						//装备副本结束后,如果是协助，4秒后直接退出

						let team_model = TeamModel.GetInstance()
						let cur_dun_id = SceneManager.GetInstance().GetCurrDunId()
						let state = team_model.help_data && team_model.help_data[cur_dun_id]
						if (state == 1) {
							self.ShowQuitTime(
								TimeUtil.getServerTime() + 4, () => {
									BaseDungeonModel.GetInstance().Fire(BaseDungeonModel.SCMD_REQUEST, 61002)
								})
							return
						}

					}
					self.ShowQuitTime(end_time)
				}
			)
			self.BindEvent(
				BaseDungeonModel.GetInstance(),
				BaseDungeonModel.UPDATE_DUNGEON_INFO, (vo?) => {
					self.ShowCountDown(true)
					let end_time = vo.end_time
					self.StartCountTime(
						2, () => {
							let left_time = end_time - TimeUtil.getServerTime()
							if (left_time < 0) {
								self.CancelCountTime(2)
								self.ShowCountDown(false)
								return
							}
							self._lb_count_down.text = TimeUtil.timeConvert8(left_time)
						}
					)
				}
			)

			self.BindEvent(
				GlobalEventSystem,
				SceneEventType.PICK_UP_END, () => {
					if (!SceneManager.GetInstance().IsEquipDungeon()) {
						return
					}
					self.ShowQuitTime(
						TimeUtil.getServerTime() + 4, () => {
							BaseDungeonModel.GetInstance().Fire(BaseDungeonModel.SCMD_REQUEST, 61002)
						}
					)
				}
			)

			if (!self.item_list) {
				self.item_list = []
			}
			let item = new DungeonEquipFightSceneItem(self._gp_item_con)
			// table.insert(self.item_list, item)
			self.item_list.push(item)
			//item.percentHeight = 100
			//item.percentWidth = item.percentHeight
			item.Load()
		},
		[DUN_TYPE.Heart]: (self) => {
			// self.ShowBossBornEffect()
			self.BindEvent(
				self.base_model,
				BaseDungeonModel.UPDATE_DUNGEON_END_TIME, (end_time?) => {
					self.ShowQuitTime(end_time)
				}
			)
			self.BindEvent(
				BaseDungeonModel.GetInstance(),
				BaseDungeonModel.UPDATE_DUNGEON_INFO, (vo?) => {
					self.ShowCountDown(true)
					let end_time = vo.end_time
					self.StartCountTime(
						2, () => {
							let left_time = end_time - TimeUtil.getServerTime()
							if (left_time < 0) {
								self.CancelCountTime(2)
								self.ShowCountDown(false)
								return
							}
							self._lb_count_down.text = TimeUtil.timeConvert8(left_time)
						}
					)
				}
			)
			if (!self.item_list) {
				self.item_list = []
			}
			let item = new DungeonHeartFightSceneItem(self._gp_item_con)
			self.item_list.push(item)
			item.Load()
		},
		[DUN_TYPE.ReincarnationDun]: (self) => {
			// self.ShowBossBornEffect()
			self.BindEvent(
				self.base_model,
				BaseDungeonModel.UPDATE_DUNGEON_END_TIME, (end_time?) => {
					self.ShowQuitTime(end_time)
				}
			)
			self.BindEvent(
				BaseDungeonModel.GetInstance(),
				BaseDungeonModel.UPDATE_DUNGEON_INFO, (vo?) => {
					self.ShowCountDown(true)
					let end_time = vo.end_time
					self.StartCountTime(
						2, () => {
							let left_time = end_time - TimeUtil.getServerTime()
							if (left_time < 0) {
								self.CancelCountTime(2)
								self.ShowCountDown(false)
								return
							}
							self._lb_count_down.text = TimeUtil.timeConvert8(left_time)
						}
					)
				}
			)
			if (!self.item_list) {
				self.item_list = []
			}
			let item = new DungeonReinItem(self._gp_item_con)
			self.item_list.push(item)
			item.Load()
		},
		[DUN_TYPE.Dragon]: (self) => {
			// if (! window["BossHelpRolePanel"] ) {
			// 	if (! ResManager.GetInstance().IsJsLoad("boss") ) {

			// 	}
			// }
			self.BindEvent(
				self.base_model,
				BaseDungeonModel.UPDATE_DUNGEON_END_TIME, (end_time?) => {
					self.ShowQuitTime(end_time)
				}
			)
			if (!self.item_list) {
				self.item_list = []
			}
			let item = new DungeonDragonFightSceneItem(self._gp_item_con)
			self.item_list.push(item)
			item.Load()
		},
		[DUN_TYPE.Vip_Rerson_Boss]: (self) => {
			self.BindEvent(
				BaseDungeonModel.GetInstance(),
				BaseDungeonModel.UPDATE_DUNGEON_INFO, (vo?) => {
					self.ShowCountDown(true)
					let end_time = vo.end_time
					self.StartCountTime(
						2, () => {
							let left_time = end_time - TimeUtil.getServerTime()
							if (left_time < 0) {
								self.CancelCountTime(2)
								self.ShowCountDown(false)
								return
							}
							self._lb_count_down.text = TimeUtil.timeConvert8(left_time)
						}
					)
				}
			)
			self.BindEvent(
				GlobalEventSystem,
				SceneEventType.PICK_UP_END, () => {
					if (!SceneManager.GetInstance().IsVipPersonalBossDungeon()) {
						return
					}
					//VIP boss结束后,拾取结束，4秒后退出
					self.ShowQuitTime(
						TimeUtil.getServerTime() + 4, () => {
							BaseDungeonModel.GetInstance().Fire(BaseDungeonModel.SCMD_REQUEST, 61002)
						}
					)
				}
			)

			self.BindEvent(
				self.base_model,
				BaseDungeonModel.UPDATE_DUNGEON_END_TIME, (end_time?) => {
					if (!SceneManager.GetInstance().IsVipPersonalBossDungeon()) {
						return
					}
					//VIP boss结束后,如果是开启光环自动拾取，直接4秒后退出
					if(HaloModel.GetInstance().GetHaloOpenState() && HaloModel.GetInstance().CheckPrivilegeOpenState(HaloPrivilegeType.DropPickUpSpeed, true)){
						self.ShowQuitTime(
							TimeUtil.getServerTime() + 4, () => {
								BaseDungeonModel.GetInstance().Fire(BaseDungeonModel.SCMD_REQUEST, 61002)
							})
						return
					}
					
				}
			)

			
		},
		[DUN_TYPE.Pet]: (self) => {
			self.BindEvent(
				BaseDungeonModel.GetInstance(),
				BaseDungeonModel.UPDATE_DUNGEON_INFO, (vo?) => {
					let end_time = vo.end_time
					self.StartCountTime(
						2, () => {
							let left_time = end_time - TimeUtil.getServerTime()
							if (left_time < 0) {
								self.CancelCountTime(2)
								self.ShowCountDown(false)
								return
							}
							self._lb_count_down.text = TimeUtil.timeConvert8(left_time)
						}
					)
				}
			)
		},
		[DUN_TYPE.SingleRank]: (self) => {
			if (!self.item_list) {
				self.item_list = []
			}
			let item = new window["kfSRSceneView"](self._gp_item_con)
			// table.insert(self.item_list, item)
			self.item_list.push(item)
			//item.percentHeight = 100
			//item.percentWidth = item.percentHeight
			item.Load()
			let end_time = null
			self.BindEvent(BaseDungeonModel.GetInstance(), BaseDungeonModel.UPDATE_DUNGEON_INFO, (vo?) => {
				end_time = vo.end_time
				// item.ExcuteCallback(() => {
				// 	item.RunTime(vo)
				// })
			}
			)
			self.BindEvent(kfSingleRankModel.GetInstance(), kfSREvent.START_COUNT_DOWN, () => {
				if (!end_time) {
					return
				}
				self.ShowCountDown(true)
				self.StartCountTime(2, () => {
					let left_time = end_time - TimeUtil.getServerTime()
					if (left_time < 0) {
						self.CancelCountTime(2)
						self.ShowCountDown(false)
						return
					}
					self._lb_count_down.text = TimeUtil.timeConvert8(left_time)
				}
				)
			}
			)
		},
		[DUN_TYPE.Partner]: (self) => {
			self.BindEvent(
				BaseDungeonModel.GetInstance(),
				BaseDungeonModel.UPDATE_DUNGEON_INFO, (vo?) => {
					self.ShowCountDown(true)
					let end_time = vo.end_time
					self.StartCountTime(
						2, () => {
							let left_time = end_time - TimeUtil.getServerTime()
							if (left_time < 0) {
								self.CancelCountTime(2)
								self.ShowCountDown(false)
								return
							}
							self._lb_count_down.text = TimeUtil.timeConvert8(left_time)
						}
					)
				}
			)
			if (!self.item_list) {
				self.item_list = []
			}
			let item = new DungeonPartnerFightSceneItem(self._gp_item_con)
			// table.insert(self.item_list, item)
			self.item_list.push(item)
			item.Load()
		},
		[DUN_TYPE.NEW_WING]: (self) => {
			//倒计时
			self.InitCountTime()
			//评分
			self.SetScoreDisplay(true)
		},
		[DUN_TYPE.NEW_AMULET]: (self) => {
			//倒计时
			self.InitCountTime()
			//评分
			self.SetScoreDisplay(true)
		},
		[DUN_TYPE.NEW_MOUNT]: (self) => {
			//倒计时
			self.InitCountTime()
			//评分
			self.SetScoreDisplay(true)
		},
		[DUN_TYPE.NEW_WEAPON]: (self) => {
			//倒计时
			self.InitCountTime()
			//评分
			self.SetScoreDisplay(true)
		},
		[DUN_TYPE.NEW_BACK_ORNAMENT]: (self) => {
			//倒计时
			self.InitCountTime()
			//评分
			self.SetScoreDisplay(true)
		},
		[DUN_TYPE.Material_Mount]: (self) => {
			//倒计时
			self.InitCountTime()
			//评分
			self.SetScoreDisplay(true)
		},
		[DUN_TYPE.Material_Copper]: (self) => {
			// if (!self.item_list) {
			// 	self.item_list = []
			// }
			// let item = new DungeonCopperFightSceneItem(self._gp_item_con)
			// self.item_list.push(item)
			// item.Load()
			//倒计时
			self.InitCountTime()
			//评分
			self.SetScoreDisplay(true)
		}

	}



	/**
	 * 定时请求用于更新经验
	 */
	private TimingRequestExp(nextTime: number) {
		let time: number = (TimeUtil.getServerTime() * 1000) - nextTime;
		Laya.timer.once(Math.max(1000, time), this, () => {
			this.flag = false;
			if (!this.end) {
				BaseDungeonModel.GetInstance().Fire(BaseDungeonModel.SCMD_REQUEST, 61119);
			}
		});
	}

	_btn_leave: Laya.Image
	_gp_item_con: Laya.Box
	custom_effect: Laya.Box
	_gp_born_effect: Laya.Box
	_box_top: Laya.Box
	_gp_count_down: Laya.Box
	_Image1: Laya.Image
	_Group1: Laya.HBox
	_Label1: Laya.Label
	_lb_count_down: Laya.Label
	_gp_fight_count_down: Laya.Box
	_img_fight_count_down: Laya.Image
	_img_bg: Laya.Image
	_img_bg2: Laya.Image
	_img_bg3: Laya.Image
	_lb_fight_count_down: Laya.Label
	_gp_start_count_down: Laya.Box
	_img_start_count_down: Laya.Image
	_Image2: Laya.Image
	_lb_start_count_down: Laya.Label
	_gp_tips: Laya.Box
	Image4: Laya.Image
	Image5: Laya.Image
	_lb_floor: Laya.Label
	_gp_quit_time: Laya.Box
	_img_quit_bg: Laya.Image
	_Image6: Laya.Image
	_lb_quit_time: Laya.Label
	_gp_guard: Laya.Box
	_img_guard: Laya.Image
	_box_guild_help: Laya.Box
	_box_con: Laya.Box
	_img_bg_score: Laya.Image
	_html_grade_info: Laya.HTMLDivElement
	_img_progress_bg: Laya.Image
	_img_progress: Laya.Image
	_img_star: Laya.Image
	_img_star1: Laya.Image
	_img_star2: Laya.Image
	_img_star3: Laya.Image
	public GetComponents() {
		[
			this._btn_leave,
			this._gp_item_con,
			this.custom_effect,
			this._gp_born_effect,
			this._box_top,
			this._gp_count_down,
			this._Image1,
			this._Group1,
			this._Label1,
			this._lb_count_down,
			this._gp_fight_count_down,
			this._img_fight_count_down,
			this._img_bg,
			this._img_bg2,
			this._img_bg3,
			this._lb_fight_count_down,
			this._gp_start_count_down,
			this._img_start_count_down,
			this._Image2,
			this._lb_start_count_down,
			this._gp_tips,
			this.Image4,
			this.Image5,
			this._lb_floor,
			this._gp_quit_time,
			this._img_quit_bg,
			this._Image6,
			this._lb_quit_time,
			this._gp_guard,
			this._img_guard,
			this._box_guild_help,
			this._box_con,
			this._img_bg_score,
			this._html_grade_info,
			this._img_progress_bg,
			this._img_progress,
			this._img_star,
			this._img_star1,
			this._img_star2,
			this._img_star3,
		]
			= this.GetChildrenByNames([

				"_btn_leave",
				"_gp_item_con",
				"custom_effect",
				"_gp_born_effect",
				"_box_top",
				"_gp_count_down",
				"_Image1",
				"_Group1",
				"_Label1",
				"_lb_count_down",
				"_gp_fight_count_down",
				"_img_fight_count_down",
				"_img_bg",
				"_img_bg2",
				"_img_bg3",
				"_lb_fight_count_down",
				"_gp_start_count_down",
				"_img_start_count_down",
				"_Image2",
				"_lb_start_count_down",
				"_gp_tips",
				"Image4",
				"Image5",
				"_lb_floor",
				"_gp_quit_time",
				"_img_quit_bg",
				"_Image6",
				"_lb_quit_time",
				"_gp_guard",
				"_img_guard",
				"_box_guild_help",
				"_box_con",
				"_img_bg_score",
				"_html_grade_info",
				"_img_progress_bg",
				"_img_progress",
				"_img_star",
				"_img_star1",
				"_img_star2",
				"_img_star3",
			])
	}
}
window["DungeonFightSceneView"] = DungeonFightSceneView
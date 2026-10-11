import { BossTargetPanel } from "../boss/BossTargetPanel"
import { BaseView1, OpenMode } from "../common/BaseView1"
import { EventName, SceneEventType } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { MainUIManager } from "../common/MainUIManager"
import { ResManager } from "../common/ResManager"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { BossSceneManager } from "../commonController/BossSceneManager"
import { BaseDungeonModel } from "../commonModel/BaseDungeonModel"
import { BossModel } from "../commonModel/BossModel"
import { MainUIModel } from "../commonModel/MainUIModel"
import { Scene } from "../scene/Scene"
import { SceneBaseType } from "../scene/SceneConfig"
import { SceneManager } from "../scene/SceneManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameMath } from "../util/GameMath"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { Util, GlobalTimerQuest, RefBoxChildsLayout } from "../util/Util"
import { DungeonPolarScenePanel } from "./DungeonPolarScenePanel"
import { DungeonPolarView } from "./DungeonPolarView"
import { Config } from "../common/Config"
import { RoleManager } from "../commonModel/RoleManager"

export class DungeonPolarSceneView extends BaseView1 {
	CancelCountTime
	InitEvent
	LoadSuccess
	ShowCountDown
	ShowStar
	StartCountTime
	blood_boss_id
	destroy_imm
	end_time
	open_mode
	save_boss_damage_dic
	setTagetPanelHid
	setTargetList
	starCfg
	tagetPanelTimer
	_taget_panel
	_model
	_panel
	_tagetPanelTimer
	star
	starTime
	_list_obj
	public constructor() {
		super()

		this.base_file = "dungeonPolar"
		this.layout_file = "DungeonPolarSceneView"
		this.dependent_res = ["dungeonCommon"]
		this.preload_server_config =
		{
			"config_week_dungeon_boss": false
		}
		this.layer_value = Enum_UILayer.Main
		//this.open_mode = OpenMode.OpenToggle
		this.destroy_imm = true
		this._model = BaseDungeonModel.GetInstance()
		let _scene_mgr = SceneManager.GetInstance()
		let scene = Scene.GetInstance()
		this._panel = null
		let bossModel = BossModel.GetInstance()
		let exit_time = 0
		let dead_time_wait = 0
		let time_speed = 100
		this._tagetPanelTimer = null
		let _count_time = 0
		let blood_boss_id = null
		let hid_activityState = false
		let is_show_tween = false
		let time_id = null
		let time_func = null
		let bossList = []
		let local_EventName = EventName
		let local_GlobalEventSystem = GlobalEventSystem
		let local_MainUIModel = MainUIModel
		let local_BaseDungeonModel = BaseDungeonModel
		let local_ResManager = ResManager.GetInstance()
		let local_TimeUtil = TimeUtil
		this.save_boss_damage_dic = []
		let select_boss_id = 0
		let local_GameMath = GameMath
		let local_SceneBaseType = SceneBaseType
		let boss_scene_mgr = BossSceneManager.GetInstance()
		this.star = 3
		let exp_change_bind_
		let local_rolemainVo = RoleManager.GetInstance().GetMainRoleVo()
		this.load_callback = () => {
			ResManager.GetInstance().SetOutsideImageSprite(this,this._Image2,GameResPath.GetIconOtherPath("dungeonPolar","ui_copy_20"))
			ResManager.GetInstance().SetOutsideImageSprite(this,this._exit_time,GameResPath.GetIconOtherPath("dungeonPolar","ui_copy_20"))
			local_GlobalEventSystem.Fire(local_EventName.HIDE_MAINUI_FIGHT_NUM, false)
			ResManager.GetInstance().LoadFont(this, "rune_per", this._lb_exit_time, null, false)
			this.display_obj.left = this.display_obj.right = this.display_obj.bottom = 0
			this.display_obj.top = Util.GetLiuhaiHeight()

			this.InitEvent()
			this.LoadSuccess()

			MainUIModel.GetInstance().Fire(MainUIModel.CHANGE_ACTIVITY_STATE, false)
		}

		this.InitEvent = () => {

			Util.AddClickEvent(this._gp_exit, () => {
				this._model.exit()
			}
				, this, true)
			this.BindEvent(local_BaseDungeonModel.GetInstance(), local_BaseDungeonModel.UPDATE_DUNGEON_INFO, (vo?) => {
				this.starTime = vo.start_time
				this.end_time = vo.end_time
				this.StartCountTime(() => {
					let left_time = this.end_time && this.end_time - local_TimeUtil.getServerTime() || 0
					if (left_time < 0) {
						this.CancelCountTime()
						this.ShowCountDown(false)
						return
					}
					this._lb_count_down.text = local_TimeUtil.timeConvert8(left_time)
				}
				)
			}
			)
			this.BindEvent(local_GlobalEventSystem, SceneEventType.SCENE_CHANGED, () => {
				this._model.Fire(local_BaseDungeonModel.SCMD_REQUEST, 61004)
			}
			)
			Util.AddClickEvent(this._btn_chat, () => {
				let local_pos = this._btn_chat.localToGlobal(new Laya.Point(0, 0))
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "DungeonPolarChatView", local_pos)
			}, this, true)

			Util.AddClickEvent(this._img_instruction, () => {
				let dun_id = _scene_mgr.GetCurrDunId()
				// let type = String(dun_id).slice(-1)
				// //Number(string.sub(dun_id,string.len(dun_id)-1,string.len(dun_id)))
				// let in_type = InstructionType.dungeonPolar
				// if (type == 2 ) {
				// 	in_type = InstructionType.dungeonPolar2
				// }
				local_GlobalEventSystem.Fire(local_EventName.OPEN_INSTRUCTION_VIEW, dun_id)
			}
				, this, true)
			this.BindEvent(this._model, local_BaseDungeonModel.UPDATE_DUNGEON_END_TIME, (end_time?) => {
				this._gp_exit_time.visible = true
				exit_time = end_time
			}
			)
			this.BindEvent(this._model, local_BaseDungeonModel.CHANGE_POLAR_BOSS, (boss_id?) => {
				if (select_boss_id != boss_id) {
					select_boss_id = boss_id
				}
			}
			)
			this.BindEvent(local_GlobalEventSystem, local_EventName.MAIN_ROLE_CHANGE_ATTACK_TARGRT, (target?) => {
				if (target && target.vo) {
					if (select_boss_id == target.vo.type_id) {
						return
					}
					let obj_type = target.obj_type
					if (obj_type && obj_type == local_SceneBaseType.Monster) {
						for (let _tmpi in bossList) {
							var info = bossList[_tmpi]
							if (info.boss_id == target.vo.type_id) {
								select_boss_id = target.vo.type_id
								break
							}
						}
					}
				}
			}
			)


			//复活异常 特殊处理
			let ExpChange = () => {
				//console.warn("主角死了:"+local_rolemainVo.hp)
				if(local_rolemainVo.hp==0){
					this._model.Fire(local_BaseDungeonModel.SCMD_REQUEST, 61088)
				}
			}

			exp_change_bind_ = local_rolemainVo.BindOne("hp", ExpChange)

		}

		this.setTargetList = () => {
			if (!this._tagetPanelTimer) {
				this._tagetPanelTimer = GlobalTimerQuest.AddPeriodQuest(() => {
					this.tagetPanelTimer()
				}, time_speed / 1000)
			}
		}

		this.LoadSuccess = () => {
			this._model.Fire(local_BaseDungeonModel.SCMD_REQUEST, 61088)
			MainUIManager.GetInstance().AddMoveComponent(this, this._gp_count_down, false, MainUIManager.MOVE_TYPE.Stay)
			MainUIManager.GetInstance().AddMoveComponent(this, this._gp_exit, false, MainUIManager.MOVE_TYPE.Left)
			MainUIManager.GetInstance().AddMoveComponent(this, this._img_instruction, false, MainUIManager.MOVE_TYPE.Left)
			MainUIManager.GetInstance().AddMoveComponent(this, this._target_gp, false, MainUIManager.MOVE_TYPE.Stay)
			MainUIManager.GetInstance().AddMoveComponent(this, this._gp, false, MainUIManager.MOVE_TYPE.Left)
			MainUIManager.GetInstance().AddMoveComponent(this, this._gp_tips, false, MainUIManager.MOVE_TYPE.Stay)
			MainUIManager.GetInstance().AddMoveComponent(this, this.gp_star, false, MainUIManager.MOVE_TYPE.Left)
			this._btn_chat.visible = !_scene_mgr.IsPolarDungeon()
			RefBoxChildsLayout(this._gp_tips, 2)

			let kv_cfg = Config.PRELOAD_SERVER_CONFIG.config_week_dungeon_kv
			dead_time_wait = _scene_mgr.IsKFPolarDungeon() && Number(kv_cfg[0].value) || Number(kv_cfg[1].value)
			let dun_id = _scene_mgr.GetCurrDunId()
			let week_dungeon_boss_cfg = local_ResManager.GetGameConfigFromCache(this, "config_week_dungeon_boss", false)//Config.Weekdungeonboss
			bossList = this._model.polarbossList(week_dungeon_boss_cfg, dun_id)
			if (!this._taget_panel) {
				this._taget_panel = new BossTargetPanel(this._target_gp)
				this._taget_panel.Load()
			}
			this._taget_panel.ExcuteCallback(() => {
				this.setTargetList()
			}
			)
			let vo = this._model.GetDungeonSceneMsg()
			if (vo) {
				this.starTime = vo.start_time
				this.end_time = vo.end_time
				this.StartCountTime(() => {
					let left_time = this.end_time && this.end_time - local_TimeUtil.getServerTime() || 0
					if (left_time < 0) {
						this.CancelCountTime()
						this.ShowCountDown(false)
						return
					} else {
						this.ShowCountDown(true)
					}
					this._lb_count_down.text = local_TimeUtil.timeConvert8(left_time)
				}
				)
			} else {
				this._model.Fire(local_BaseDungeonModel.SCMD_REQUEST, 61004)
			}
			if (!this._panel) {
				this._panel = new DungeonPolarScenePanel(this._gp)
				this._panel.Load()
			}



		}

		this.tagetPanelTimer = () => {
			if (_count_time >= 1000 / time_speed) {
				if (exit_time >= local_TimeUtil.getServerTime()) {
					this._lb_exit_time.text = (exit_time - local_TimeUtil.getServerTime()) + ""
				}
				this.ShowStar()
				_count_time = 0
			}
			_count_time = _count_time + 1



			let list = null

			let monster_list = scene.FindTargets(Scene.FIND_TARGET_TYPE.monster, 10, null, 1000, null, null, null)[0]
			//let monster_list = scene.FindTargets(Scene.FIND_TARGET_TYPE.monster, 10, null, 800, null, null, null)

			if (monster_list.length > 0) {
				list = monster_list

			}
			let boss = scene.FindNearestMonsters(select_boss_id)

			let bossPos = null
			let vo = boss && boss.GetVo()
			if (boss) {
				for (let key in bossList) {

					let bossInfo = bossList[key]
					if (bossInfo.boss_id == vo.type_id) {
						let flag = this._model.PolarBossInfo(vo.type_id)
						if (flag != null && flag != 1) {
							let pos_List = JSON.parse(bossInfo.boss_born)[0]
							bossPos = { x: Number(pos_List[0]), y: Number(pos_List[1]) }
							break
						}
					}
				}
			}
			let distance = (bossPos && scene.main_role) && local_GameMath.GetDistance(scene.main_role.real_pos.x, scene.main_role.real_pos.y, bossPos.x, bossPos.y) || null
			if (boss && distance != null && distance <= 600 * 600) {
				if (this.save_boss_damage_dic[vo.type_id] == null && vo && vo.type_id == select_boss_id) {
					this.save_boss_damage_dic[vo.type_id] = true
					bossModel.show_damage_boss_ins_id = vo.instance_id
					UserMsgAdapter.GetInstance().SendAllFmtToGame(12025, "i", vo.instance_id)
				}
			} else {
				if (this.save_boss_damage_dic[select_boss_id]) {
					delete this.save_boss_damage_dic[select_boss_id]
					//bossModel.show_damage_boss_ins_id = null
				}
			}

			let target = boss_scene_mgr.GetAttackTarget()



			if (list && list.length > 0) {
				if (!hid_activityState && local_MainUIModel.GetInstance().activity_icon_in_show) {
					local_MainUIModel.GetInstance().Fire(local_MainUIModel.CHANGE_ACTIVITY_STATE, false)
				}
				if (boss && !local_MainUIModel.GetInstance().big_blood_in_show) {
					this.blood_boss_id = boss.vo.type_id
					let config = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_mon.name, this.blood_boss_id, false)
					if (config) {
						local_GlobalEventSystem.Fire(local_EventName.SHOW_HITER_BIG_BLOOD_VIEW, true, boss.GetVo(), config.hp_num, false)
					}
				} else if ((!boss || (boss && boss.vo.type_id != this.blood_boss_id)) && local_MainUIModel.GetInstance().big_blood_in_show && target && target.obj_type && target.obj_type == local_SceneBaseType.Monster) {
					local_GlobalEventSystem.Fire(local_EventName.SHOW_HITER_BIG_BLOOD_VIEW, false)
				}

				if (this._taget_panel) {
					this._taget_panel.SetData(list)
				}
				hid_activityState = true
				this.setTagetPanelHid(true)
			} else {
				hid_activityState = false
				this.setTagetPanelHid(false)
				if (this._taget_panel) {
					this._taget_panel.SetData([])
				}

				if (local_MainUIModel.GetInstance().big_blood_in_show && (!target || (target.obj_type && target.obj_type == local_SceneBaseType.Monster))) {
					local_GlobalEventSystem.Fire(local_EventName.SHOW_HITER_BIG_BLOOD_VIEW, false)
				}
			}
			BossModel.GetInstance().CheckIsPickupMon()
		}


		this.ShowStar = () => {
			if (!this.starCfg) {
				let cfg = Config.PRELOAD_SERVER_CONFIG.config_week_dungeon
				let dun_id = _scene_mgr.GetCurrDunId()
				for (let i in cfg) {
					var v = cfg[i]
					if (v.single_dun_id == dun_id || v.team_dun_id == dun_id) {
						this.starCfg = v
						break
					}
				}
			}

			if (this.starCfg) {
				let starList = JSON.parse(this.starCfg.time_score)
				if (this.starTime) {
					let pass_time = local_TimeUtil.getServerTime() - this.starTime
					let min = 0
					let max = 0
					let star = 0
					for (let i in starList) {
						var info = starList[i]
						if (pass_time >= Number(info[1]) && pass_time <= Number(info[2])) {
							min = Number(info[1])
							max = Number(info[2])
							star = Number(info[0])
							break
						}
					}

					let left_time = max - pass_time
					let starCon
					if (star > 1) {
						starCon = DungeonPolarView.menu_dic[star - 2]
					}

					this.star_time.text = TimeUtil.timeConvert8(left_time) + (star > 1 && "后降为" + starCon.content || "后副本失败")
					this.star_bar.width =left_time / (max - min) * 156
					if (this.star != star) {
						ResManager.GetInstance().SetImageSprite(this, this.star_icon, "dungeonPolar", `ui_copy_jd${star}`)
						// starCon = DungeonPolarView.menu_dic[star]
						// if (starCon) {
						// 	this.star_name.text = starCon.content
						// }
					}
					this.star = star
				}
			}
		}

		this.setTagetPanelHid = (bool?) => {
			if (this._taget_panel && this._taget_panel.visible != bool) {
				this._taget_panel.visible = bool
			}
		}

		this.ShowCountDown = (bool?) => {
			if (!is_show_tween) {
				this._gp_count_down.visible = bool
			}
		}

		this.StartCountTime = (func?) => {
			this.CancelCountTime()
			time_func = func
			time_id = GlobalTimerQuest.AddPeriodQuest(() => {
				func()
			}, 1)
			func()
		}

		this.CancelCountTime = () => {
			if (!time_id) {
				return
			}
			GlobalTimerQuest.CancelQuest(time_id)
			time_id = null
			time_func = null
		}


		this.close_callback = () => {
			local_GlobalEventSystem.Fire(local_EventName.HIDE_MAINUI_FIGHT_NUM, true)
			if (this._tagetPanelTimer) {
				GlobalTimerQuest.CancelQuest(this._tagetPanelTimer)
				this._tagetPanelTimer = null
			}
			if (this._taget_panel && !this._taget_panel.use_delete_method) {
				this._taget_panel.DeleteMe()
				this._taget_panel = null
			}

			if (this._panel) {
				this._panel.DeleteMe()
				this._panel = null
			}
			this.CancelCountTime()
			this._model.dead_time = null
			this._model.boss_info = []
			this.save_boss_damage_dic = []


			if (exp_change_bind_) {
				local_rolemainVo.UnBind(exp_change_bind_)
				exp_change_bind_ = null
			}
		}
	}

	public DeleteMe() {


		super.DeleteMe()
	}


	_target_gp: Laya.Box
	_gp_exit: Laya.Box
	_exit1: Laya.Image
	_gp: Laya.Box
	_gp_exit_time: Laya.Box
	_exit_time: Laya.Image
	_Group1: Laya.HBox
	_lb_exit_time: Laya.Label
	_Image1: Laya.Image
	_gp_count_down: Laya.Box
	_Image2: Laya.Image
	_Label1: Laya.Label
	_lb_count_down: Laya.Label
	_gp_tips: Laya.Box
	_btn_chat: Laya.Image
	_btn_relive: Laya.Image
	_img_instruction: Laya.Image
	gp_star: Laya.Box
	Image2: Laya.Image
	Image1: Laya.Image
	star_time: Laya.Label
	Image3: Laya.Image
	star_bar: Laya.Image
	star_icon: Laya.Image
	public GetComponents() {
		[
			this._target_gp,
			this._gp_exit,
			this._exit1,
			this._gp,
			this._gp_exit_time,
			this._exit_time,
			this._Group1,
			this._lb_exit_time,
			this._Image1,
			this._gp_count_down,
			this._Image2,
			this._Label1,
			this._lb_count_down,
			this._gp_tips,
			this._btn_chat,
			this._btn_relive,
			this._img_instruction,
			this.gp_star,
			this.Image2,
			this.Image1,
			this.star_time,
			this.Image3,
			this.star_bar,
			this.star_icon,
		]
			= this.GetChildrenByNames([

				"_target_gp",
				"_gp_exit",
				"_exit1",
				"_gp",
				"_gp_exit_time",
				"_exit_time",
				"_Group1",
				"_lb_exit_time",
				"_Image1",
				"_gp_count_down",
				"_Image2",
				"_Label1",
				"_lb_count_down",
				"_gp_tips",
				"_btn_chat",
				"_btn_relive",
				"_img_instruction",
				"gp_star",
				"Image2",
				"Image1",
				"star_time",
				"Image3",
				"star_bar",
				"star_icon",
			])
	}
}
window["DungeonPolarSceneView"] = DungeonPolarSceneView
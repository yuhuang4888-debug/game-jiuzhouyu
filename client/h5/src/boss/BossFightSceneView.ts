import { Alert, Alert_Type } from "../alert/Alert"
import { AutoFightManager } from "../autofight/AutoFightManager"
import { BaseView1 } from "../common/BaseView1"
import { Config } from "../common/Config"
import { EventName, ObjectEventType, SceneEventType } from "../common/EventName"
import { Enum_UILayer, LayerManager } from "../common/LayerManager"
import { MainUIManager } from "../common/MainUIManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { BossSceneEvent, BossSceneManager } from "../commonController/BossSceneManager"
import { BossModel } from "../commonModel/BossModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { GuardModel } from "../commonModel/GuardModel"
import { GuildEvent, GuildModel } from "../commonModel/GuildModel"
import { MainUIModel } from "../commonModel/MainUIModel"
import { TaskTipType } from "../commonModel/TaskModel"
import { MainUITaskTeamView } from "../mainUI/MainUITaskTeamView"
import { RoleManager } from "../commonModel/RoleManager"
import { Scene } from "../scene/Scene"
import { SceneBaseType } from "../scene/SceneConfig"
import { SceneManager } from "../scene/SceneManager"
import { SceneObj } from "../scene/sceneobj/SceneObj"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { Message } from "../sysInfo/SysInfoController"
import { ColorType, ColorUtil, Enum_ColorUtil_Light, Enum_ColorUtil_NEW } from "../util/ColorUtil"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameMath } from "../util/GameMath"
import { GameResPath } from "../util/GameResPath"
import { Runner } from "../util/Runner"
import { SYTweenFunc } from "../util/SYTweenFunc"
import { SYTweenLite } from "../util/SYTweenLite"
import { TimeUtil } from "../util/TimeUtil"
import { GetSizeDeltaX, GlobalTimerQuest, HtmlColorTxt, IsInTable, RefBoxChildsLayout, RefBoxVLayout, SetAnchoredPositionX, SetAnchoredPositionY, Util } from "../util/Util"
import { Vector2 } from "../util/Vector2"
import { BossDamageItem } from "./BossDamageItem"
import { BossTargetItem } from "./BossTargetItem"
import { BossWayFindingItem } from "./BossWayFindingItem"
import { HolyTerritoryModel, HTEvent } from "../commonModel/HolyTerritoryModel"
import { BossHelpPanel } from "./BossHelpPanel"
import { BossHelpRolePanel } from "./BossHelpRolePanel"
import "./BossRebornView"
import "../task/TaskView"
import { BossArrowAlert } from "./BossArrowAlert"
import { SeaHegemonyModel } from "../commonModel/SeaHegemonyModel"
import { ActivityIconManager } from "../commonModel/ActivityIconManager"
import { SuitActivityModel } from '../commonModel/SuitActivityModel';
import { OpenFun } from "../common/OpenFun"
export class BossFightSceneView extends BaseView1 {

	hide_activity_state
	boss_pos_list
	select_boss_id
	save_boss_damage_dic
	help_panel
	help_role_panel
	help_mark
	show_help
	tweenHelp
	timeHelp
	show_reborn
	boss_type
	boss_info
	holy_boxs_data
	htDataId
	time_surplus
	reborn_cost
	mystery_boxs_data
	tween_id
	tween_id2
	tween_id3
	owner_id
	proview
	now_attack
	mystery_special_boss_data
	last_time


	wayfinding_item: BossWayFindingItem
	damage_item: BossDamageItem
	target_item: BossTargetItem
	blood_boss_id
	time_id_list
	timer

	guard_model: GuardModel
	holy_territory_model
	scene_mgr: SceneManager
	boss_model: BossModel
	auto_fight_mgr: AutoFightManager
	boss_scene_mgr: BossSceneManager
	mainUI_model: MainUIModel
	local_scene: Scene
	goods_model: GoodsModel
	role_mgr: RoleManager
	res_mgr: ResManager
	word_boss_
	box_right_gap = 10

	public static WayFind_Left_Offest = 1
	public constructor() {
		super()

		this.base_file = "boss"
		this.layout_file = "BossFightSceneView"
		this.layer_value = Enum_UILayer.Main
		this.destroy_imm = true
		this.back_login_toClose = true

		this.hide_activity_state = false
		this.boss_pos_list = []
		this.select_boss_id = 0
		this.save_boss_damage_dic = {}

		this.help_panel = null
		this.help_role_panel = null
		this.help_mark = false
		this.show_help = false
		this.tweenHelp = false
		this.timeHelp = false
		this.show_reborn = false

		this.scene_mgr = SceneManager.GetInstance()
		this.boss_model = BossModel.GetInstance()
		this.auto_fight_mgr = AutoFightManager.GetInstance()
		this.boss_scene_mgr = BossSceneManager.GetInstance()
		this.mainUI_model = MainUIModel.GetInstance()
		this.local_scene = Scene.GetInstance()
		this.goods_model = GoodsModel.GetInstance()
		this.role_mgr = RoleManager.GetInstance()
		this.res_mgr = ResManager.GetInstance()

		this.guard_model = GuardModel.GetInstance()
		this.holy_territory_model = HolyTerritoryModel.GetInstance()

		this.preload_server_config = {
			"config_eudemons_boss_cfg": false,
			"config_boss_cfg": false,
			"config_boss_type": false
		}
		this.load_callback = () => {
			this.LoadSuccsss()
		}

		this.open_callback = () => {
		}

		this.close_callback = () => {
			this.Remove()
		}
	}


	public LoadSuccsss() {
		this.res_mgr.SetImageSpriteTrans(this, this._img_help_tips, GameResPath.GetIcon("boss", "ui_help_tips"), true)
		this.special_boss_str.style.fontSize = 18
		this.special_boss_str.style.color = "#ffffff"
		this.special_boss_str.style.wordWrap = false

		this.auto_fight_mgr.SetAutoFight(false)


		this.boss_type = this.boss_model.GetBossType()

		//this:IsCreateWarFreeBySceneType(scene_type)
		this.wayfinding_item = new BossWayFindingItem(this._box_wayfinding)
		this.wayfinding_item.Load()
		this.wayfinding_item.ExcuteCallback(() => {
			this.InitEvent()
			this.ShowGuard()
			this.RequestBossInfo()
			this.UpdateView()
			this.AddKaiIcon()
			this.AddCrossIcon()
		})
		if (!this.scene_mgr.IsCrossWuxianBossScene()) {
			this.damage_item = new BossDamageItem(this._box_damage)
			this.damage_item.Load()
		}


		this.help_panel = new BossHelpPanel(this._box_help)
		this.help_panel.Load()
		this.help_panel.SetVisible(false)
		this.help_role_panel = new BossHelpRolePanel(this._box_help_role)
		this.help_role_panel.Load()
		this.help_role_panel.SetVisible(false)

		MainUIManager.GetInstance().AddMoveComponent(this, this._box_wayfinding, false, MainUIManager.MOVE_TYPE.Stay)
		// MainUIManager.GetInstance().AddMoveComponent(this, this._box_exit, false, MainUIManager.MOVE_TYPE.Left)
		MainUIManager.GetInstance().AddMoveComponent(this, this._img_rank, false, MainUIManager.MOVE_TYPE.Left)
		MainUIManager.GetInstance().AddMoveComponent(this, this._box_damage, false, MainUIManager.MOVE_TYPE.Left)
		MainUIManager.GetInstance().AddMoveComponent(this, this._box_target, false, MainUIManager.MOVE_TYPE.Stay)
		MainUIManager.GetInstance().AddMoveComponent(this, this._box_help, false, MainUIManager.MOVE_TYPE.Right)
		MainUIManager.GetInstance().AddMoveComponent(this, this._box_help_role, false, MainUIManager.MOVE_TYPE.Right)
		MainUIManager.GetInstance().AddMoveComponent(this, this._box_right, false, MainUIManager.MOVE_TYPE.Right)

		// if (this.scene_mgr.IsFieldBossScene()) {
		// 	MainUIManager.GetInstance().AddMoveComponent(this, this._img_vit, false, MainUIManager.MOVE_TYPE.Stay)
		// }

		if (this.scene_mgr.IsMysteryBossScene()) {
			MainUIManager.GetInstance().AddMoveComponent(this, this._box_special_boss, false, MainUIManager.MOVE_TYPE.Left)
			MainUIManager.GetInstance().AddMoveComponent(this, this._box_mystery, false, MainUIManager.MOVE_TYPE.Left)
		}

		if (this._box_war_free.visible) {
			MainUIManager.GetInstance().AddMoveComponent(this, this._box_war_free, false, MainUIManager.MOVE_TYPE.Left)
		}
		Runner.GetInstance().AddRunObj(this)
		//if (this._box_wayfinding.GetComponent("CanvasGroup") ) {
		//let alpha = MainUIModel.GetInstance().mainui_task_swich_type == 2 && 0 || 1
		//this._box_wayfinding.GetComponent("CanvasGroup").alpha = alpha
		//}
		if (this.scene_mgr.IsFieldBossScene() || this.scene_mgr.IsFieldInfiniteBossScene()) {
			// this.res_mgr.SetOutsideImageSprite(this, this._img_vit, GameResPath.GetGoodsIconPath(String(BossModel.tired_goods_id)))
			//this._img_vit.visible = true
			this.UpdateIconBox()
			this.UpdateVitStage()
		}
	}

	public InitEvent() {
		this.BindEvent(GlobalEventSystem, EventName.MAIN_ROLE_CHANGE_ATTACK_TARGRT, (target?) => {
			//攻击目标
			if (target && target.vo) {
				if (this.boss_scene_mgr.GetAttackTarget() == target) {
					return
				}
				let obj_type = target.obj_type
				if (//(obj_type && obj_type == SceneBaseType.Monster) &&
					this.boss_scene_mgr.JudgeTired(false, null, target.vo.type_id) ||
					obj_type && obj_type == SceneBaseType.Role
				) {
					this.boss_scene_mgr.SetAttackTarget(target)
				}
			} else {
				this.boss_scene_mgr.SetAttackTarget(null)
				return
			}
		}
		)






		// this.BindEvent(GlobalEventSystem, NineSkyModel.NINE_SKY_FIGHTING_MSG, (attack_role_id?) => {
		// 	this.boss_scene_mgr.SetSufferedList(attack_role_id)
		// }
		// )

		//主角死亡清理目标
		this.BindEvent(GlobalEventSystem, EventName.SHOWRELIVEWINDOW, () => {
			this.boss_scene_mgr.SetAttackTarget(null)
		}
		)

		//场景有对象死亡
		this.BindEvent(GlobalEventSystem, SceneEventType.CHARACTER_DEAD, (obj?) => {
			if ((((this.scene_mgr.IsPickUpDropScene() && obj) && obj._type == SceneBaseType.Monster) &&
				this.boss_scene_mgr.GetAttackTarget()) &&
				obj == this.boss_scene_mgr.GetAttackTarget()
			) {
				//this.auto_fight_mgr.SetAutoFight(false)
				this.boss_scene_mgr.SetAttackTarget(null)
			}
			if ((((this.scene_mgr.IsPickUpDropScene() && obj) && obj._type == SceneBaseType.Role) &&
				this.boss_scene_mgr.GetAttackTarget()) &&
				obj == this.boss_scene_mgr.GetAttackTarget()
			) {
				this.boss_scene_mgr.SetAttackTarget(null)
				//this.auto_fight_mgr.SetAutoFight(false)
				this.boss_scene_mgr.SetAutoState(true)
			}
		}
		)

		this.BindEvent(GlobalEventSystem, SceneEventType.CANCEL_CLICK_TARGET, () => {
			if (this.boss_scene_mgr.GetAttackTarget()) {
				this.boss_scene_mgr.SetAttackTarget(null)
			}
			this.boss_scene_mgr.SetAutoState(false)
			//this.auto_fight_mgr.SetAutoFight(false)
		}
		)

		this.BindEvent(GlobalEventSystem, SceneEventType.MONSTER_VO_ADD, (instance_id?, monster_vo?) => {
			if (this.boss_scene_mgr.GetAutoState() && monster_vo && monster_vo.type_id == this.select_boss_id && this.boss_scene_mgr.JudgeTired(false)) {
				this.auto_fight_mgr.SetAutoFight(true)
			}
			this.boss_model.ShowBossDieEffect(monster_vo.type_id, false)
		}
		)

		this.BindEvent(GlobalEventSystem, ObjectEventType.OBJ_DEAD, (id?, compress_id?) => {
			let monster = this.local_scene.GetMonsterDeadBody(id)
			if (monster) {
				let config = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_mon.name, monster.GetVo().type_id, false)
				if (config && config.boss >= 3) {
					this.boss_model.SetBossDeadPos({ x: monster.real_pos.x, y: monster.real_pos.y })
				}
			}
		}
		)

		//this:BindEvent(GlobalEventSystem,EventName.COLLECT_MONSTER_X_Y,(type_id?, x?, y?) => {
		//}
		//)



		this.BindEvent(GlobalEventSystem, ServerTimeModel.DAY_CHANGE, () => {
			this.RequestBossInfo()
		}
		)
		this.BindEvent(GlobalEventSystem, SceneEventType.PICK_UP_END, () => {
			let main_line_vo = this.task_model.GetMainLineTaskVo()
			if (this.task_model.IsCurrMainLineTaskTipType(TaskTipType.Kill_boss_id)
				&& this.task_model.IsCurrMainTaskHasFinish()
				&& main_line_vo
				&& (main_line_vo.task_id == BossModel.FIELD_BOSS_GUIDE_TASK_ID
					|| main_line_vo.task_id == 101481
					|| main_line_vo.task_id == 101701
					|| main_line_vo.task_id == 101485
					|| main_line_vo.task_id == 101705)) {
				//if (this.task_model.IsCurrMainLineTaskTipType(TaskTipType.EndTalk) && main_line_vo && main_line_vo.task_id == BossModel.FIELD_BOSS_GUIDE_TASK_ID && this.task_model.IsCurrMainTaskHasFinish() ) {
				let setp_cfg = { direction: 4, text: "退出大妖场景，<br>继续主线任务吧~", "effect_scaleX": 0.4, "effect_scaleY": 1 }
				GlobalEventSystem.Fire(EventName.SHOW_FINGER, this, this._box_exit, this.layer_value, null, null, null, null, setp_cfg, true)
				this.mainUI_model.Fire(MainUIModel.CHANGE_ACTIVITY_STATE, false)
			}
		}
		)

		//this:BindEvent(this.boss_model,BossModel.PICK_UP_END,() => {
		//if (this.scene_mgr.IsPickUpDropScene() ) {
		//if (this.boss_scene_mgr.GetAutoState() ) {
		//this.boss_model.Fire(BossModel.CHANGE_BOSS_TARGET, null, this.select_boss_id, false)
		//}else{
		//this.auto_fight_mgr.SetAutoFight(false)
		//}
		//}
		//}
		//)

		this.BindEvent(this.boss_model, BossModel.UPDATE_BOSS_INFO, (boss_type?) => {
			if (boss_type == this.boss_type) {
				this.UpdateView()
			}
		}
		)

		this.BindEvent(this.boss_model, BossModel.KILL_BOSS, (scmd?) => {

			if (this.boss_info) {
				for (let _tmpi in this.boss_info) {
					var data = this.boss_info[_tmpi]
					if (data.boss_id == scmd.boss_id) {
						data.reborn_time = scmd.reborn_time
						data.num = scmd.num
						break
					}
				}
			}

			switch (this.boss_type) {
				case BossModel.BossType.suit:
					break
				case BossModel.BossType.field:
				case BossModel.BossType.field_infinite:
					break
				case BossModel.BossType.abyss:
					break
				case BossModel.BossType.holyterritory:
					break
				case BossModel.BossType.mystery:
					this.boss_model.Fire(BossModel.SCMD_REQUEST, 46037)
					break
				case BossModel.BossType.holy:
					if (this.holy_boxs_data) {
						let is_box
						for (let _ in this.holy_boxs_data) {
							var vo = this.holy_boxs_data[_]
							if (vo.boss_id == scmd.boss_id) {
								is_box = true
								this.holy_boxs_data[_] = scmd
								break
							}
						}
						if (is_box) {
							this.UpdateBosxData()
						}
					}
					break
			}
		})

		//改变选中BOSS
		this.BindEvent(this.boss_model, BossModel.FINDWAY_INDEX, (index) => {
			if (this.boss_info && this.boss_info[index]) {
				this.select_boss_id = this.boss_info[index].boss_id
			}
		})

		//更新疲劳
		this.BindEvent(this.boss_scene_mgr, BossSceneEvent.TIRED_DATA_UPDATE, (boss_tired, boss_type) => {


			let bool = true
			if (!boss_type) {
				bool = false
			}

			if (boss_type && bool && boss_type != this.boss_type) {
				bool = false
			}

			if (boss_type && !bool && this.boss_type == BossModel.BossType.fieldspecial && boss_type == BossModel.BossType.field) {
				bool = true
			}

			if (!bool)
				return


			let dataList = this.boss_model.GetBossTypeInfo(this.boss_type)
			if (dataList)
				dataList.tired = boss_tired

			let info = this.boss_model.GetBossTypeInfo(this.boss_type)
			if (info) {
				if (this.scene_mgr.IsFieldBossScene() || this.scene_mgr.IsFieldSpecialBossScene() || this.scene_mgr.IsFieldInfiniteBossScene()) {
					this.wayfinding_item.SetProgress(info.tired, info.all_tired)
					this.boss_model.RefreshFieldBossRed()
				}
				else {
					this.wayfinding_item.SetProgress(info.tired, info.all_tired)
				}

			}
		})

		this.BindEvent(this.holy_territory_model, HTEvent.UPDATE_MONSTER_DATA, (scmd) => {
			if (this.boss_type == BossModel.BossType.holyterritory && this.scene_mgr.curr_scene_id - BossModel.BaseBossSceneId[this.boss_type] == scmd.sanctuary_id) {
				//if (!this.htDataId || this.htDataId != scmd.sanctuary_id) {
					this.UpdateView()
				//}
				// else {
				// 	this.UpdateView()
				// }
				this.htDataId = scmd.sanctuary_id
			}
		})

		this.BindEvent(this.holy_territory_model, HTEvent.GO_HT, () => {
			this.htDataId = null
		})

		this.BindEvent(this.boss_model, BossModel.UPDATE_MON_POS, () => {
			if (this.boss_type == BossModel.BossType.holy) {
				this.UpdateBosxData()
			}
			else if (this.boss_type == BossModel.BossType.mystery) {
				this.UpdateMysteryBoxData()
				this.ShowSpecialBoss()
			}
		})

		this.BindEvent(this.boss_model, BossModel.PUSH_MSG, (key, val) => {
			if (this.boss_type == BossModel.BossType.holy) {
				let boss_info = this.holy_boxs_data && this.holy_boxs_data[key]
				if (boss_info) {
					let info = this.boss_model.GetBossTypeInfo(BossModel.BossType.holy)
					let vo
					for (let _tmpi in info.collect_list) {
						vo = info.collect_list[_tmpi]
						if (vo.type == key) {
							vo.collect_times = val
							let left_time = vo.total_collect_times - vo.collect_times
							// let color = left_time == 0 && ColorUtil.GetColorLight(ColorType.RED) || ColorUtil.GetColorLight(ColorType.GREEN)
							let word = null
							switch (key) {
								case 1:
									word = "蜃气宝箱"
									break
								case 2:
									word = "蜃气秘宝"
									break
								case 3:
									word = "蜃气水晶"
									break
							}
							let tips = `采集成功,${word}剩余${HtmlColorTxt(left_time, "'#00fa64'")}次`
							Message.show(tips)
						}
					}
					this.UpdateBosxData()
				}
			}
		})

		let sail_func = (boss_id?, x?, y?) => {
			let real_x = x / SceneObj.GetLogicRealRatio().x
			let real_y = y / SceneObj.GetLogicRealRatio().y
			let move_completed_callback = () => {
				if (boss_id) {
					let boss = this.local_scene.FindNearestMonsters(boss_id)
					if (boss) {
						this.local_scene.MainRoleAttackMonster(boss)
						this.local_scene.SetClickTarget(boss)
					}
				}
			}
			this.boss_scene_mgr.SetAttackTarget(null)
			this.auto_fight_mgr.SetAutoFight(false)
			this.boss_scene_mgr.SetAutoState(false)
			this.local_scene.MainRoleMove(new Vector2(real_x, real_y), 0, move_completed_callback)
			Message.show("正在前往采集")
		}

		let CollectBox = (type?) => {
			let boss_info = this.holy_boxs_data && this.holy_boxs_data[type]
			if (boss_info) {
				let pos_list = this.boss_model.GetBoxsPos(boss_info.boss_id, BossModel.BossType.holy)
				if (pos_list) {
					let recent_pos = this.GetRecentPos(pos_list)
					if (recent_pos) {
						sail_func(boss_info.boss_id, recent_pos.x, recent_pos.y)
					} else {
						let cfgs = this.res_mgr.GetGameConfigFromCache(this, "config_eudemons_boss_cfg", false)
						let cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_eudemons_boss_cfg.name, boss_info.boss_id, false, cfgs)
						if (cfg) {
							let posList = JSON.parse(cfg.rand_xy)
							if (posList && posList[0]) {
								sail_func(boss_info.boss_id, posList[0][0], posList[0][1])
							}
						}
					}
				}
			}
		}

		this.BindEvent(this.boss_model, BossModel.COLLECT_BOX, CollectBox)

		Util.AddClickEvent(this._gp_rare, () => {
			CollectBox(BossModel.S_BOX_TYPE)
		}
			, this, true)
		Util.AddClickEvent(this._gp_ordinary, () => {
			CollectBox(BossModel.C_BOX_TYPE)
		}
			, this, true)
		Util.AddClickEvent(this._gp_crystal, () => {
			CollectBox(BossModel.CRYSTAL_TYPE)
		}
			, this, true)

		//this.BindEvent(this.local_scene,SceneEventType.SCENE_MOVE_END,() => {
		//if (this.scene_mgr.IsPickUpDropScene() ) {
		//this.boss_model.FindDrop()
		//}
		//}
		//)

		Util.AddClickEvent(this._box_exit, () => {
			let bosstype = this.boss_type
			let ok_func = (boss_type?) => {
				if (boss_type == null) {
					boss_type = bosstype
				}
				if (boss_type) {
					//圣域
					if (boss_type == BossModel.BossType.holyterritory) {
						this.holy_territory_model.Fire(HTEvent.REQUEST_PROTO, 28304)
					} else if (this.boss_model.IsCrossServerBoss(boss_type)) {
						this.boss_model.Fire(BossModel.SCMD_REQUEST, 47004, boss_type - BossModel.cross_boss_base_index)
					} else {
						this.boss_model.Fire(BossModel.SCMD_REQUEST, 46004, boss_type)
					}
					this.boss_scene_mgr.relive_success = false
					this.boss_scene_mgr.return_safe_success = false
				}
			}

			let content = "是否确认离开当前场景？"
			if (this.boss_type == BossModel.BossType.abyss) {
				if (this.time_surplus && this.time_surplus > 0) {
					content = "是否确认离开当前场景？<br><font color=" + ColorUtil.GetColorDark(ColorType.GREEN) + ">不会返还进入消耗<br>剩余免战时间将会清零</font>"
				} else {
					content = "是否确认离开当前场景？<br><font color=" + ColorUtil.GetColorDark(ColorType.GREEN) + ">不会返还进入消耗</font>"
				}
			}
			let main_line_vo = this.task_model.GetMainLineTaskVo()
			if (this.task_model.IsCurrMainLineTaskTipType(TaskTipType.Kill_boss_id)
				&& this.task_model.IsCurrMainTaskHasFinish()
				&& main_line_vo
				&& (main_line_vo.task_id == BossModel.FIELD_BOSS_GUIDE_TASK_ID
					|| main_line_vo.task_id == 101481
					|| main_line_vo.task_id == 101701
					|| main_line_vo.task_id == 101485
					|| main_line_vo.task_id == 101705)) {
				GlobalEventSystem.Fire(EventName.HIDE_FINGER, this._box_exit)
				// let view = new BossArrowAlert(content, Alert_Type.Two, ok_func, () => {
				// 	GlobalEventSystem.Fire(SceneEventType.PICK_UP_END)
				// }, "退出", "取消")
				// view.Open()
				// Alert.Show(content, Alert_Type.Two, ok_func, () => {
				// 	GlobalEventSystem.Fire(SceneEventType.PICK_UP_END)
				// }, "退出", "取消")
				// // view.Open()
				// let view = new BossArrowAlert(content, Alert_Type.Two, ok_func, () => {
				// 	GlobalEventSystem.Fire(SceneEventType.PICK_UP_END)
				// }

				// 	, "退出", "取消")
				// view.Open()
				ok_func()
			} else {
				Alert.Show(content, Alert_Type.Two, ok_func, null, "退出", "取消")
			}
		}, this, true)

		Util.AddClickEvent(this._box_war_free, () => {
			GlobalEventSystem.Fire(EventName.OPEN_WEEKEND_ACTIVITY_VIEW, "BossWarFreeView")
		}, this, true)

		this.BindEvent(this.boss_model, BossModel.UPDATE_WAR_FREE_TIME, (end_time?) => {
			if (end_time <= 0) {
				this.war_free_time_lb.visible = false
				this.CancelTime()
				this.time_surplus = 0
			} else {
				this.time_surplus = end_time
				this.UpdateTimer()
				this.StarTimer(1)
				this.war_free_time_lb.visible = true
			}
		})

		this.BindEvent(this.goods_model, GoodsModel.UPDATE_GOODS_NUM, () => {
			if (this.use_delete_method) {
				return
			}
			if (this.scene_mgr.IsHolyBossScene() || this.scene_mgr.IsFieldBossScene() || this.scene_mgr.IsFieldInfiniteBossScene() || this.scene_mgr.IsSuitBossScene()) {
				let show = false
				if (!this.reborn_cost) {
					let cfgs = this.res_mgr.GetGameConfigFromCache(this, "config_boss_type", false)
					this.reborn_cost = this.boss_model.GetBossRebornCost(this.boss_type, cfgs)
				}
				if (this.reborn_cost) {
					let num = this.goods_model.GetTypeGoodsNum(this.reborn_cost[1])
					show = num > 0
				}
				if (show && !this.show_reborn) {
					MainUIManager.GetInstance().AddMoveComponent(this, this._img_reborn, false, MainUIManager.MOVE_TYPE.Stay)
					this.show_reborn = true
				}
				this._img_reborn.visible = show
				this.UpdateIconBox()
			}
			if (this.scene_mgr.IsFieldBossScene() || this.scene_mgr.IsFieldInfiniteBossScene()) {
				this.UpdateVitStage()
			}
		}, true)

		this.BindEvent(GlobalEventSystem, GoodsModel.USE_BAG_GOODS_SUCCESS, (type_id?) => {
			if (type_id != BossModel.tired_goods_id) {
				return
			}
			if ((!this.scene_mgr.IsFieldBossScene() && !this.scene_mgr.IsFieldSpecialBossScene()) && !this.scene_mgr.IsFieldInfiniteBossScene() &&
				!this.scene_mgr.IsAbyssBossScene()
			) {
				return
			}
			let info = this.boss_model.GetBossTypeInfo(this.boss_type)
			info.all_tired = info.all_tired + 1
			this.wayfinding_item.SetProgress(info.tired, info.all_tired)
		})


		let get_recent_pos = (pos_list?) => {
			return this.GetRecentPos(pos_list)
		}

		Util.AddClickEvent(this.box2, () => {
			let boss_info = this.mystery_boxs_data && this.mystery_boxs_data[BossModel.MYSTERY_BOX_TYPE]
			if (boss_info) {
				let mon_type = this.boss_model.GetNowCollectBoxMonType()
				if (mon_type == BossModel.MYSTERY_BOX_TYPE) {
					Message.show("正在采集中")
				} else {
					let pos_list = this.boss_model.GetBoxsPos(boss_info.boss_id, BossModel.BossType.mystery)
					if (pos_list) {
						let recent_pos = get_recent_pos(pos_list)
						if (recent_pos) {
							sail_func(boss_info.boss_id, recent_pos.x, recent_pos.y)
						}
					} else {
						Message.show("暂无可采集宝箱")
					}
				}
			}
		}, this, true)

		Util.AddClickEvent(this.box3, () => {
			let boss_info = this.mystery_boxs_data && this.mystery_boxs_data[BossModel.MYSTERY_SUPER_BOX_TYPE]
			if (boss_info) {
				let mon_type = this.boss_model.GetNowCollectBoxMonType()
				if (mon_type == BossModel.MYSTERY_SUPER_BOX_TYPE) {
					Message.show("正在采集中")
				} else {
					let pos_list = this.boss_model.GetBoxsPos(boss_info.boss_id, BossModel.BossType.mystery)
					if (pos_list) {
						let recent_pos = get_recent_pos(pos_list)
						if (recent_pos) {
							sail_func(boss_info.boss_id, recent_pos.x, recent_pos.y)
						}
					} else {
						Message.show("暂无可采集秘宝")
					}
				}
			}
		}, this, true)

		Util.AddClickEvent(this._box_special_boss, () => {
			this.SpecialBossClickFun()
		}, this, true)

		Util.AddClickEvent(this._img_rank, () => {
			BossModel.GetInstance().Fire(BossModel.SHOW_DAMAGE, true)
		}, this, true)

		Util.AddClickEvent(this._img_reborn, () => {
			if (this.scene_mgr.IsHolyBossScene() || this.scene_mgr.IsFieldBossScene() || this.scene_mgr.IsFieldInfiniteBossScene() || this.scene_mgr.IsSuitBossScene()) {
				let mainRoleVo = RoleManager.GetInstance().GetMainRoleVo()
				let posVo = null
				for (let i = 0; i < this.boss_pos_list.length; i++) {
					posVo = this.boss_pos_list[i]
					if (GameMath.IsPointNear(posVo.x, posVo.y, mainRoleVo.pos_x, mainRoleVo.pos_y, 500)) {
						if (!this.reborn_cost) {
							let cfgs = this.res_mgr.GetGameConfigFromCache(this, "config_boss_type", false)
							this.reborn_cost = this.boss_model.GetBossRebornCost(this.boss_type, cfgs)
						}
						let bossInfo = this.boss_info[i]
						if (bossInfo && this.reborn_cost) {
							GlobalEventSystem.Fire(EventName.OPEN_WEEKEND_ACTIVITY_VIEW, "BossRebornView", bossInfo)
							return
						}
					}
				}
				Message.show("附近没有可复活的大妖")
			}
		}, this, true)

		// Util.AddClickEvent(this._img_vit, () => {
		// 	this.boss_model.Fire(BossModel.OPEN_BOSS_TIRED_ALERT)
		// }, this, true)



		let show_fun = (bool?) => {
			if (bool) {
				SYTweenLite.to(this, this._box_special_boss, SYTweenLite.UiAnimationType.ANCHORED_POSX, 0, MainUIModel.Move_Time_Interval, null, SYTweenFunc.EASE_IN)
			} else {
				SYTweenLite.to(this, this._box_special_boss, SYTweenLite.UiAnimationType.ANCHORED_POSX, -250, MainUIModel.Move_Time_Interval, null, SYTweenFunc.EASE_IN)
			}
		}

		this.BindEvent(this.boss_model, BossModel.SHOW_WAY_FINDING_PANEL, show_fun)
		this.BindEvent(GlobalEventSystem, EventName.SHOW_MAIN_UI_TASK, (show?) => {
			if (this.tween_id) {
				SYTweenLite.Stop(this.tween_id)
			}
			let endValue = show && 6 || -GetSizeDeltaX(this._box_wayfinding)

			let tween_type = show && SYTweenFunc.EASE_IN_BACK || SYTweenFunc.EASE_OUT_BACK

			let interval = MainUITaskTeamView.MoveInterval * 0.6
			this.tween_id = SYTweenLite.to(this, this._box_wayfinding, SYTweenLite.UiAnimationType.ANCHORED_POSX, endValue, interval, () => {
				SYTweenLite.Stop(this.tween_id)
				this.tween_id = null
			}, tween_type)
		})

		this.BindEvent(this.boss_model, BossModel.FORCE_SHOW_TASK, () => {
			if (this._box_wayfinding) {
				this._box_wayfinding.alpha = 1
			}
		})

		this.BindEvent(GlobalEventSystem, EventName.SHOW_BOSS_WAY_PANEL, (show?) => {
			if (this.scene_mgr.IsHolyBossScene() || this.scene_mgr.IsCrossWuxianBossScene()) {
				this._box_wayfinding.visible = true
				this.wayfinding_item.SetTask(!show)
			} else {
				this._box_wayfinding.visible = show
			}
			if (show) {
				MainUIManager.GetInstance().RemoveMoveOneComponent(this, this._box_wayfinding)
				MainUIManager.GetInstance().AddMoveComponent(this, this._box_wayfinding, false, MainUIManager.MOVE_TYPE.Stay)
			} else {
				MainUIManager.GetInstance().RemoveMoveOneComponent(this, this._box_wayfinding, false)
			}
		})

		this.BindEvent(this.boss_model, BossModel.SHOW_DAMAGE, (show?) => {
			if (this.tween_id2) {
				SYTweenLite.Stop(this.tween_id2)
				this.tween_id2 = null
			}

			let endValue = show ? 4 : -GetSizeDeltaX(this._box_damage)

			let tween_type = show && SYTweenFunc.EASE_IN_BACK || SYTweenFunc.EASE_OUT_BACK
			let interval = MainUITaskTeamView.MoveInterval * 0.6

			this.tween_id2 = SYTweenLite.to(this, this._box_damage, SYTweenLite.UiAnimationType.ANCHORED_POSX, endValue, interval, () => {
				this.tween_id2 = false
			}, tween_type)

			if (this.tween_id3) {
				SYTweenLite.Stop(this.tween_id3)
				this.tween_id3 = null
			}
			endValue = show && -GetSizeDeltaX(this._img_rank) || 0

			tween_type = show && SYTweenFunc.EASE_OUT_BACK || SYTweenFunc.EASE_IN_BACK

			interval = MainUITaskTeamView.MoveInterval * 0.6
			this.tween_id3 = SYTweenLite.to(this, this._img_rank, SYTweenLite.UiAnimationType.ANCHORED_POSX, endValue, interval, () => {
				this.tween_id3 = false
			}, tween_type)
		})

		this.boss_model.Fire(BossModel.SCMD_REQUEST, 20203)

		this.BindEvent(GuildModel.GetInstance(), GuildEvent.ASSIST_SUCCESS, () => {
			this.HelpSuccess()
		}
		)
		this.BindEvent(
			GlobalEventSystem,
			EventName.REFRESH_ACTIVITY_ICON_RED_DOT,
			(icon_type?) => {
				if (1525 == Number(icon_type)) {
					let bool = SuitActivityModel.GetInstance().showRed;
					this.kai_red.visible = bool
				} else if (6210 == Number(icon_type)) {
					this.cross_red.visible = this.boss_model.GetEudaemonRed()
				}
			}
		);
	}

	public Remove() {
		this.CancelAllCountTime()
		Runner.GetInstance().RemoveRunObj(this.hashCode)
		this.CancelTime()
		SYTweenLite.Stop(this.tween_id)
		SYTweenLite.Stop(this.tween_id2)
		SYTweenLite.Stop(this.tweenHelp)
		clearTimeout(this.timeHelp)

		if (this.wayfinding_item) {
			this.wayfinding_item.DeleteMe()
		}
		this.wayfinding_item = undefined
		if (this.damage_item) {
			this.damage_item.DeleteMe()
		}
		this.damage_item = undefined

		if (this.target_item) {
			this.target_item.DeleteMe()
			//GlobalEventSystem:Fire(EventName.UPDATE_TEAM_INVITE_FLAG_POS, false)
		}
		this.target_item = undefined

		if (this.help_panel) {
			this.help_panel.DeleteMe()
		}
		this.help_panel = false
		if (this.help_role_panel) {
			this.help_role_panel.DeleteMe()
		}
		this.help_role_panel = false



		this.boss_pos_list = []
		this.boss_model.CleanBossDieEffect()
		this.owner_id = null
		this.boss_type = this.owner_id
		this.proview = this.boss_type
		this.reborn_cost = this.proview
		this.boss_scene_mgr.ResetData()
		this.save_boss_damage_dic = {}
		this.now_attack = false
		this.help_mark = false
		this.show_reborn = false



		MainUIManager.GetInstance().RemoveMoveComponent(this)

		//BossModel.GetInstance().Fire(BossModel.SELECT_TASK_TEAM_VIEW, 1)


	}

	public InitView() {

		this.wayfinding_item.SetData(this.boss_type, this.boss_info, this.boss_pos_list)
		if (this.damage_item) {
			this.damage_item.SetBossType(this.boss_type)
		}
		if (this.boss_type == BossModel.BossType.suit) {
			this.wayfinding_item.SetProgress(0, 100)
		} else if (this.boss_type == BossModel.BossType.field) {
			// SetAnchoredPositionY(this._box_icon, 460)
			//this._img_reborn.bottom = 453
			let info = this.boss_model.GetBossTypeInfo(BossModel.BossType.field)
			this.wayfinding_item.SetProgress(info.tired, info.all_tired)
			this.show_help = true
		} else if (this.boss_type == BossModel.BossType.field_infinite) {
			// SetAnchoredPositionY(this._box_icon, 460)
			//this._img_reborn.bottom = 453
			let info = this.boss_model.GetBossTypeInfo(BossModel.BossType.field_infinite)
			this.wayfinding_item.SetProgress(info.tired, info.all_tired)
			this.show_help = true
		} else if (this.boss_type == BossModel.BossType.fieldspecial) {
			// SetAnchoredPositionY(this._box_icon, 460)
			//this._img_reborn.bottom = 453
			let info = this.boss_model.GetBossTypeInfo(BossModel.BossType.fieldspecial)
			this.wayfinding_item.SetProgress(info.tired, info.all_tired)
			this.show_help = true
		} else if (this.boss_type == BossModel.BossType.abyss) {
		} else if (this.boss_type == BossModel.BossType.holyterritory) {
			let info = this.boss_model.GetBossTypeInfo(BossModel.BossType.holyterritory)
			this.wayfinding_item.SetProgress(info.tired, info.all_tired)
		} else if (this.boss_type == BossModel.BossType.holy) {
			this._box_holy.visible = true
			// SetAnchoredPositionY(this._box_icon, 530)
			this.show_help = true
		} else if (this.boss_type == BossModel.BossType.mystery) {
			this._box_mystery.visible = true
			this._box_special_boss.visible = true
			this.ShowSpecialBoss()
		}
		if (this.boss_type == BossModel.BossType.holy || this.boss_type == BossModel.BossType.holy_wuxian) {
			this._box_holy.bottom = 400 - 10
			this._box_icon.bottom = 490 - 10
		} else {
			this._box_holy.bottom = 470
			this._box_icon.bottom = 410
		}
	}

	//初始化Boss位置
	public InitBossPos() {

		if (!this.boss_info) {
			return
		}
		let curr_time = TimeUtil.getServerTime()
		let eudemons_boss_cfg = this.res_mgr.GetGameConfigFromCache(this, "config_eudemons_boss_cfg", false)
		let boss_cfg = this.res_mgr.GetGameConfigFromCache(this, "config_boss_cfg", false)
		let info, pos
		for (let _ in this.boss_info) {
			info = this.boss_info[_]
			pos = this.boss_model.GetBossPos(info.boss_id, this.boss_type, eudemons_boss_cfg, boss_cfg)
			if (pos) {
				table.insert(this.boss_pos_list, pos)
			}
			//if (info.reborn_time > curr_time ) {
			//let pos = this.boss_model.GetBossPos(info.boss_id, this.boss_type)
			//this.boss_model.ShowBossDieEffect(info.boss_id, true, pos)
			//}
		}
	}

	public UpdateView() {

		this.GetBossInfo()
		if (this.boss_info) {
			this.InitBossPos()
			this.InitView()
			this.GoToMemberDeadPos()
		}
	}

	public RequestBossInfo() {

		switch (this.boss_type) {
			case BossModel.BossType.field:
			case BossModel.BossType.field_infinite:
			case BossModel.BossType.abyss:
				if (this.boss_type == BossModel.BossType.field) {
					this.boss_model.Fire(BossModel.SCMD_REQUEST, 46043, BossModel.BossType.field)
				} else if (this.boss_type == BossModel.BossType.field_infinite) {
					this.boss_model.Fire(BossModel.SCMD_REQUEST, 46043, BossModel.BossType.field_infinite)
				}
				this.boss_model.Fire(BossModel.SCMD_REQUEST, 46000, this.boss_type)
				break
			case BossModel.BossType.holyterritory:
				let i = 1
				do {
					this.holy_territory_model.Fire(HTEvent.REQUEST_PROTO, 28301, "c", i)
					i = i + 1
				} while ((i <= 3))
				break
			case BossModel.BossType.mystery:
				this.boss_model.Fire(BossModel.SCMD_REQUEST, 46000, this.boss_type)
				this.boss_model.Fire(BossModel.SCMD_REQUEST, 46005, this.boss_type)
				this.boss_model.Fire(BossModel.SCMD_REQUEST, 46039)
				break
			case BossModel.BossType.suit:
				this.boss_model.Fire(BossModel.SCMD_REQUEST, 46000, this.boss_type)
				this.boss_model.Fire(BossModel.SCMD_REQUEST, 46005, this.boss_type)
				break
			case BossModel.BossType.holy:
				this.boss_model.Fire(BossModel.SCMD_REQUEST, 47000, this.boss_type - BossModel.cross_boss_base_index)
				break
			case BossModel.BossType.holy_wuxian:
				this.boss_model.Fire(BossModel.SCMD_REQUEST, 46000, this.boss_type)
				break

		}

	}

	public GetBossInfo() {

		let curr_scene_id = this.scene_mgr.curr_scene_id
		let boss_info
		let info = this.boss_model.GetBossTypeInfo(this.boss_type)
		let layer
		switch (this.boss_type) {
			case BossModel.BossType.suit:
			case BossModel.BossType.abyss:
			case BossModel.BossType.field:
			case BossModel.BossType.field_infinite:
				layer = curr_scene_id != BossModel.BOSS_FIELD_INFINITE ? curr_scene_id - BossModel.BaseBossSceneId[this.boss_type] : 0
				//layer = curr_scene_id != 34090 ? curr_scene_id - BossModel.BaseBossSceneId[this.boss_type] : 0// + dis // 世界boss场景id统一加了100 boss之家减了100//无限层场景34090特殊处理
				info = this.boss_model.GetBossTypeInfo(this.boss_type)
				if (info) {
					boss_info = []
					for (let _tmpi in info.boss_info) {
						var vo = info.boss_info[_tmpi]
						if (vo.layer == layer && vo.boss_type == this.boss_type) {
							table.insert(boss_info, vo)
						}
					}
				}
				break
			case BossModel.BossType.holyterritory:
				let sanctuary_id = curr_scene_id - BossModel.BaseBossSceneId[this.boss_type]
				let info1 = this.holy_territory_model.GetTerData(sanctuary_id)
				if (info1) {
					let _cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_boss_cfg", false)
					this.holy_territory_model.SetBossInfo(info1, _cfg)
					boss_info = info1.boss_info
				}
				break
			case BossModel.BossType.holy:
				let holy_layer = curr_scene_id - BossModel.BaseBossSceneId[this.boss_type]
				let holy_info = this.boss_model.GetBossTypeInfo(this.boss_type)
				if (holy_info) {
					boss_info = []
					for (let _tmpi in holy_info.boss_info) {
						var vo = holy_info.boss_info[_tmpi]
						if (vo.layer == holy_layer) {
							let mon_cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_mon.name, vo.boss_id, false)
							if (mon_cfg && mon_cfg.kind == 0) {
								table.insert(boss_info, vo)
							} else {
								let cfgs = this.res_mgr.GetGameConfigFromCache(this, "config_eudemons_boss_cfg", false)
								let boss_cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_eudemons_boss_cfg.name, vo.boss_id, false, cfgs)
								if (boss_cfg) {
									if (!this.holy_boxs_data) {
										this.holy_boxs_data = []
									}
									this.holy_boxs_data[boss_cfg.is_rare] = vo
								}
							}
						}
					}
					this.UpdateBosxData()
				}
				break
			case BossModel.BossType.mystery:
				let layer_num = curr_scene_id - BossModel.BaseBossSceneId[this.boss_type]
				let info_list = this.boss_model.GetBossTypeInfo(this.boss_type)
				if (info_list) {
					boss_info = []
					this.mystery_special_boss_data = []
					this.mystery_boxs_data = []
					for (let _tmpi in info_list.boss_info) {
						var vo = info_list.boss_info[_tmpi]
						if (vo.layer == layer_num && vo.boss_type == this.boss_type) {
							if (vo.mon_type == BossModel.MYSTERY_NORMAL_BOSS_TYPE) {
								table.insert(boss_info, vo)
							} else if (vo.mon_type == BossModel.MYSTERY_SPECIAL_BOSS_TYPE) {
								table.insert(this.mystery_special_boss_data, vo)
							} else if (vo.mon_type == BossModel.MYSTERY_BOX_TYPE || vo.mon_type == BossModel.MYSTERY_SUPER_BOX_TYPE) {
								this.mystery_boxs_data[vo.mon_type] = vo
							}
						}
					}
					this.UpdateMysteryBoxData()
					this.ShowSpecialBoss()
				}
				break
			case BossModel.BossType.fieldspecial:
				let boss_layer = curr_scene_id - BossModel.BaseBossSceneId[this.boss_type]
				let info2 = this.boss_model.GetBossTypeInfo(this.boss_type)
				if (info2) {
					boss_info = []
					for (let _tmpi in info2.boss_info) {
						var vo = info2.boss_info[_tmpi]
						table.insert(boss_info, vo)
					}
				}
				break
			case BossModel.BossType.holy_wuxian:
				let info3 = this.boss_model.GetBossTypeInfo(this.boss_type)
				if (info3) {
					boss_info = []
					for (let _tmpi in info3.boss_info) {
						var vo = info3.boss_info[_tmpi]
						table.insert(boss_info, vo)
					}
				}
				break
		}


		if (this.boss_type == BossModel.BossType.holyterritory) {
			table.sort(boss_info, (a, b) => {
				return a.boss_id > b.boss_id
			})
		} else {
			table.sort(boss_info, (a, b) => {
				return a.boss_id < b.boss_id
			})
		}

		this.boss_info = boss_info
	}

	public GoToMemberDeadPos() {

		let dead_pos = this.boss_model.GetMemberDeadPos()
		if (dead_pos) {
			this.auto_fight_mgr.SetAutoFight(false)
			this.local_scene.MainRoleMove(
				dead_pos,
				0, () => {
					let ok = this.boss_scene_mgr.JudgeTired(false)
					this.auto_fight_mgr.SetAutoFight(ok)
				}
			)
			this.boss_model.SetMemberDeadPos(null)
		}
	}


	public Update(now_time?, elapse_time?) {

		if (!this.last_time || now_time - this.last_time > 1) {
			//console.log(now_time)
			this.last_time = now_time
			this.TagetPanelTimer()
		}
	}

	public TagetPanelTimer() {

		if (!this.boss_info) { return }

		let bossVo = null
		let x = null
		let y = null
		let bossPos = null

		let vo = this.boss_scene_mgr.FindBossInfo(this.boss_info, this.select_boss_id)
		if (vo) {
			if (this.scene_mgr.IsHolyBossScene()) {
				let cfgs = this.res_mgr.GetGameConfigFromCache(this, "config_eudemons_boss_cfg", false)
				bossVo = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_eudemons_boss_cfg.name, vo.boss_id, false, cfgs)
				if (bossVo) {
					let pos = JSON.parse(bossVo.fixed_xy)
					x = pos[0][0]
					y = pos[0][1]
					bossPos = { x: x, y: y }
				}
			} else {
				let cfgs = this.res_mgr.GetGameConfigFromCache(this, "config_boss_cfg", false)
				bossVo = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_boss_cfg.name, vo.boss_id, false, cfgs)
				if (bossVo) {
					x = bossVo.x
					y = bossVo.y
					bossPos = { x: x, y: y }
				}
			}
		}

		this.boss_scene_mgr.select_boss_id = this.select_boss_id

		let monster_list = this.local_scene.FindTargets(Scene.FIND_TARGET_TYPE.monster, 1, null, 1000, null, null, null)[0]
		let role_list = this.boss_scene_mgr.GetSortSecneRoleList()

		if (this.scene_mgr.IsHolyBossScene()) {
			let i = monster_list.length
			if (i > 0) {
				do {
					if (monster_list[i - 1].vo.boss_type == 0 || monster_list[i - 1].vo.boss_type == 1) {
						table.remove(monster_list, i - 1)
					}
					i = i - 1
				} while ((i > 0))
			}
		}

		let boss = monster_list[0]
		if (boss && this.damage_item) {
			//if (this.select_boss_id == 0 ) {
			this.select_boss_id = boss.vo.type_id
			//}
			//显示求助按钮
			if (this.show_help && !this.help_mark && this.damage_item) {
				this.help_mark = true
				this.damage_item.SetHelpStatus(true)
			}
			this.damage_item.SetBossData(boss.vo)
		} else {
			if (this.show_help && this.help_mark && this.damage_item) {
				this.help_mark = false
				this.damage_item.SetHelpStatus(false)
			}
		}

		let main_role_vo = this.role_mgr.GetMainRoleVo()

		let distance = (bossPos && this.local_scene.main_role) && GameMath.GetDistance(main_role_vo.pos_x, main_role_vo.pos_y, bossPos.x, bossPos.y) || null

		if (boss && distance && distance <= 450 * 450) {
			if (!this.save_boss_damage_dic[boss.vo.type_id]) {
				this.save_boss_damage_dic[boss.vo.type_id] = true
				this.now_attack = boss
				this.boss_scene_mgr.SetDamageBossInstanceId(boss.vo.instance_id)
				UserMsgAdapter.Instance.SendAllFmtToGame(12043, "i", [boss.vo.instance_id])
				UserMsgAdapter.Instance.SendAllFmtToGame(12025, "i", [boss.vo.instance_id])
			}
		} else {
			if (this.select_boss_id && this.save_boss_damage_dic[this.select_boss_id]) {
				this.save_boss_damage_dic[this.select_boss_id] = false
				this.boss_scene_mgr.SetDamageBossInstanceId(null)
			}
		}
		this.boss_scene_mgr.JudgeTarget(role_list)


		let list
		if (monster_list.length > 0) {
			list = []
			list = list.concat(monster_list)
			list = list.concat(role_list)
			// table.merge(list, monster_list)
			// table.merge(list, role_list)
		} else if (this.select_boss_id > 0) {
			if ((vo && vo.reborn_time > TimeUtil.getServerTime()) && this.local_scene.main_role && x && y) {
				bossPos = { x: x, y: y }
				let distance =
					GameMath.GetDistance(
						main_role_vo.pos_x,
						main_role_vo.pos_y,
						bossPos.x,
						bossPos.y
					)
				let monVo = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_mon.name, vo.boss_id, false)
				let bossDistance = monVo.tracing_distance + 150
				if (distance <= bossDistance * bossDistance) {
					list = []
					table.insert(list, vo)
					for (let _ = 0; _ < role_list.length; _++) {
						let vo = role_list[_]
						table.insert(list, vo)
					}
				}
			} else {
				list = role_list
			}
		} else {
			list = role_list
		}

		let target = this.boss_scene_mgr.GetAttackTarget()

		if (list && list.length > 0) {
			if (!this.hide_activity_state && this.mainUI_model.activity_icon_in_show) {
				this.mainUI_model.Fire(MainUIModel.CHANGE_ACTIVITY_STATE, false)
			}
			if (boss && !this.mainUI_model.big_blood_in_show) {
				this.blood_boss_id = boss.vo.type_id
				let config = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_mon.name, this.blood_boss_id, false)
				if (config) {
					GlobalEventSystem.Fire(EventName.SHOW_HITER_BIG_BLOOD_VIEW, true, boss.GetVo(), config.hp_num, false)
				}
			} else if (((((!boss || boss && boss.vo.type_id != this.blood_boss_id) && this.mainUI_model.big_blood_in_show) &&
				target) &&
				target._type) &&
				target._type == SceneBaseType.Monster
			) {
				GlobalEventSystem.Fire(EventName.SHOW_HITER_BIG_BLOOD_VIEW, false)
			}

			if (!this.target_item) {
				this.target_item = new BossTargetItem(this._box_target)
				this.target_item.Load()
				this.target_item.SetVisible(false)
			}
			if (list && list.length > 0) {
				let role_id = RoleManager.GetInstance().GetMainRoleId()
				for (let j = 0; j < list.length; j++) {
					let vv = list[j]
					if (role_id == vv.role_id) {
						table.splice(list, j, 1)
						break
					}
				}
			}

			this.target_item.SetData(list)
			this.hide_activity_state = true
			if (this.wayfinding_item) {
				let id = null
				if (boss && boss.vo) {
					id = boss.vo.type_id
				}
				if (!id && list && list[1]) {
					id = list[1].boss_id
				}
				this.wayfinding_item.SetTiredStatus(id)
			}
			this.SetTagetPanelHid(true)
		} else {
			this.hide_activity_state = false
			this.SetTagetPanelHid(false)
			if (this.wayfinding_item) {
				this.wayfinding_item.SetTiredStatus(null)
			}

			if (this.mainUI_model.big_blood_in_show && (!target || (target._type && target._type == SceneBaseType.Monster))) {
				GlobalEventSystem.Fire(EventName.SHOW_HITER_BIG_BLOOD_VIEW, false)
			}
		}
		//this:AttackTarget()
	}

	public AttackTarget() {

		if (this.boss_model.auto_pick_up && this.auto_fight_mgr.GetAutoFightState()) {
			this.auto_fight_mgr.SetAutoFight(false)
		}

		if (this.auto_fight_mgr.GetAutoFindWayState() || !this.boss_scene_mgr.GetAutoState() || this.boss_model.auto_pick_up) {
			return
		}

		let vo = this.boss_scene_mgr.FindBossInfo(this.boss_info, this.select_boss_id)
		if (!vo) {
			return
		}
		let x = null
		let y = null

		let cfgs = ResManager.GetInstance().GetGameConfigFromCache(this, "config_boss_cfg", false)
		let bossVo = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_boss_cfg.name, vo.boss_id, false, cfgs)
		if (bossVo) {
			x = bossVo.x
			y = bossVo.y
		}
		let bossPos = { x: x, y: y }
		let target = this.boss_scene_mgr.GetAttackTarget()
		let boss = this.local_scene.GetMonsterByTypeId(this.select_boss_id)
		if (!target) {
			let role = this.boss_scene_mgr.NearSufferedRole()
			if (((role && !role.IsDead()) && this.local_scene.main_role) && !this.local_scene.main_role.is_dead) {
				this.boss_scene_mgr.SetAttackTarget(role)
				this.local_scene.SetClickTarget(role)
				this.auto_fight_mgr.SetAutoFight(true)
				return
			}
			let NearBossRole = this.boss_scene_mgr.NearBossRole(bossPos)
			if (NearBossRole) {
				this.boss_scene_mgr.SetAttackTarget(NearBossRole)
				this.local_scene.SetClickTarget(NearBossRole)
				this.auto_fight_mgr.SetAutoFight(true)
			}
		}
		if ((target && target._type) && target._type == SceneBaseType.Role) {
			let over = this.boss_scene_mgr.CheckRole(bossPos)
			if (over) {
				this.auto_fight_mgr.SetAutoFight(false)
				this.boss_model.Fire(BossModel.CHANGE_BOSS_TARGET, null, this.select_boss_id)
			}
		}
	}

	public SetTagetPanelHid(bool?) {

		if (this.target_item) {
			this.target_item.SetVisible(bool)
			//GlobalEventSystem:Fire(EventName.UPDATE_TEAM_INVITE_FLAG_POS, bool)
		}
	}

	public StartCountTime(type?, func?) {

		if (!this.time_id_list) {
			this.time_id_list = {}
		}
		this.CancelCountTime(type)
		this.time_id_list[type] = GlobalTimerQuest.AddPeriodQuest(func, 1, -1)
		func()
	}

	public CancelCountTime(type?) {

		if (!this.time_id_list || !this.time_id_list[type]) {
			return
		}
		GlobalTimerQuest.CancelQuest(this.time_id_list[type])
		delete this.time_id_list[type]
	}

	public CancelAllCountTime() {

		if (!this.time_id_list) {
			return
		}
		for (let _ in this.time_id_list) {
			var id = this.time_id_list[_]
			GlobalTimerQuest.CancelQuest(id)
		}
		this.time_id_list = null
	}

	public IsCreateWarFreeBySceneType(scene_type?) {

		let config_protect = this.res_mgr.GetGameConfigFromCache(this, "Protect", false)
		//-let scene_type_str = String(scene_type)
		for (let key in config_protect) {

			// [ts2lua]config_protect下标访问可能不正确
			let cfg = config_protect[key]
			if (key == scene_type) {
				this._box_war_free.visible = true
			} else {
				this._box_war_free.visible = false
			}
		}
	}
	public UpdateTimer() {

		if (this.time_surplus <= 0) {
			this.CancelTime()
			this.war_free_time_lb.visible = false
			return
		}
		this.time_surplus = this.time_surplus - 1
		let D = Math.floor(this.time_surplus / 60 / 60 / 24)
		let h = Math.floor(this.time_surplus / 60 / 60) % 24
		let m = Math.floor(this.time_surplus / 60) % 60
		let s = this.time_surplus % 60
		if (D >= 1) {
			this.war_free_time_lb.text = `${D}天${h}时`
		} else if (h >= 1) {
			this.war_free_time_lb.text = `${h}小时${m}分`
		} else if (m >= 1) {
			if (s >= 10) {
				this.war_free_time_lb.text = `${m}分${s}秒`
			} else {
				this.war_free_time_lb.text = `${m}分0${s}秒`
			}
		} else {
			if (s >= 10) {
				this.war_free_time_lb.text = `${s}秒`
			} else {
				this.war_free_time_lb.text = `0${s}秒`
			}
		}
	}

	public StarTimer(countdoentime?) {

		this.CancelTime()
		this.timer = GlobalTimerQuest.AddPeriodQuest(() => {
			this.UpdateTimer()
		}, countdoentime)
	}

	public CancelTime() {

		if (this.timer) {
			GlobalTimerQuest.CancelQuest(this.timer)
		}
	}

	public ShowGuard() {

		if (this.scene_mgr.IsFieldBossScene()
			|| this.scene_mgr.IsFieldSpecialBossScene()
			|| this.scene_mgr.IsFieldInfiniteBossScene()
			|| this.scene_mgr.IsAbyssBossScene()
			|| this.scene_mgr.IsHolyTerritory()
			|| this.scene_mgr.IsHolyBossScene()
			||this.scene_mgr.IsCrossWuxianBossScene()) {
			this.ShowGuardImage()
			this.BindEvent(this.guard_model, GuardModel.UPDATA_VIEW, () => {
				this.ShowGuardImage()
			}
			)

			Util.AddClickEvent(this._box_guard, () => {
				this.guard_model.Fire(GuardModel.OPEN_VIEW, 2)
			}, this, true)
			Util.AddClickEvent(this._box_kai, () => {
				OpenFun.OpenFunHandler(196);
			}, this, true)
			Util.AddClickEvent(this._box_cross, () => {
				OpenFun.OpenFunHandler(86);
			}, this, true)
		}
	}

	public ShowGuardImage() {

		let bool = false
		if (this.scene_mgr.IsFieldBossScene()
			|| this.scene_mgr.IsFieldSpecialBossScene()
			|| this.scene_mgr.IsFieldInfiniteBossScene()
			|| this.scene_mgr.IsAbyssBossScene()
			|| this.scene_mgr.IsHolyTerritory()
			|| this.scene_mgr.IsHolyBossScene()) {
			let open = this.guard_model.OpenStatus()
			if (!open) {
				return
			}
			let [type1, type2] = this.guard_model.GetGuardActiveType()
			bool = type2 == null
			Util.SetImageGray(this._img_guard, bool)
			this._box_guard.visible = bool
			RefBoxVLayout(this._box_right, this.box_right_gap, true, true)
			let y = bool ? 620 : 709
			this._box_kai.y = y
			if (bool) {
				type2 = 2
				this.res_mgr.SetImageSprite(this, this._img_guard, "boss_asset", "guard" + type2 + "_1", true)
				// MainUIManager.GetInstance().AddMoveComponent(this, this._box_guard, false, MainUIManager.MOVE_TYPE.Right)
			} else {
				// MainUIManager.GetInstance().RemoveMoveOneComponent(this, this._box_guard)
			}
		}
		return bool
	}


	private AddCrossIcon() {
		this._box_cross.visible = false
		if (this.scene_mgr.IsHolyBossScene() || this.scene_mgr.IsCrossWuxianBossScene()) {
			this._box_cross.visible = true
			this.res_mgr.SetImageSprite(this, this._img_cross, "icon", "24", true)
			this.cross_red.visible = this.boss_model.GetEudaemonRed()
		}
		RefBoxVLayout(this._box_right, this.box_right_gap, true, true)
	}
	public AddKaiIcon() {
		this._box_kai.visible = false
		if (this.scene_mgr.IsFieldBossScene() || this.scene_mgr.IsFieldInfiniteBossScene()) {
			this.res_mgr.SetImageSprite(this, this._img_kai, "icon_asset", "1525", true)
			// MainUIManager.GetInstance().AddMoveComponent(this, this._box_kai, false, MainUIManager.MOVE_TYPE.Right)
			let bool = SuitActivityModel.GetInstance().showRed;
			this.kai_red.visible = bool
			this._box_kai.visible = true
		}
		RefBoxVLayout(this._box_right, this.box_right_gap, true, true)
	}

	public UpdateBosxData() {

		let info = this.boss_model.GetBossTypeInfo(BossModel.BossType.holy)
		let collect_list = info && info.collect_list
		let type2Com = {
			"1": "_ordinary",
			"2": "_rare",
			"3": "_crystal"
		}

		if (collect_list) {
			for (let _tmpi in collect_list) {
				var vo = collect_list[_tmpi]
				let com = type2Com[vo.type]
				let bool = vo.total_collect_times > vo.collect_times
				this["_gp" + com].visible = bool
				RefBoxChildsLayout(this._box_holy, 10, 80, true, "center")
				if (bool) {
					let boss_info = this.holy_boxs_data && this.holy_boxs_data[vo.type]
					if (boss_info) {
						let pos_list = this.boss_model.GetBoxsPos(boss_info.boss_id, BossModel.BossType.holy)
						if (pos_list) {
							let len = pos_list.length
							if (len > 0) {
								this.CancelCountTime(vo.type)
								this["_lb" + com].color = "#00fa64"
								this["_lb" + com].text = "剩余:" + len
							} else {
								this["_lb" + com].color = "#00fa64"
								let end_time = boss_info.reborn_time
								this.StartCountTime(BossModel.C_BOX_TYPE, () => {
									let left_time = end_time - TimeUtil.getServerTime()
									if (left_time < 0) {
										this["_lb" + com].text = ""
										this.CancelCountTime(vo.type)
										return
									}
									this["_lb" + com].text = TimeUtil.timeConvert(left_time, "hh:mm:ss")
								}
								)
							}
						}
					}
				} else {
					this.CancelCountTime(vo.type)
				}
			}
		}
	}


	public GetRecentPos(pos_list?) {

		let role_vo = RoleManager.GetInstance().GetMainRoleVo()
		let recent_pos = null
		let recent_distance = null
		for (let _tmpi in pos_list) {
			var pos = pos_list[_tmpi]
			let distance = GameMath.GetDistance(role_vo.pos_x, role_vo.pos_y, pos.x, pos.y)
			if (recent_distance == null || recent_distance > distance) {
				recent_distance = distance
				recent_pos = pos
			}
		}
		return recent_pos
	}

	public UpdateMysteryBoxData() {
		let info = this.boss_model.GetBossTypeInfo(BossModel.BossType.mystery)
		if (info) {
			let collect_list = info.boss_info
			if (collect_list) {
				for (let _tmpi in collect_list) {
					var vo = collect_list[_tmpi]
					let mon_type = vo.mon_type
					if (mon_type == BossModel.MYSTERY_BOX_TYPE || mon_type == BossModel.MYSTERY_SUPER_BOX_TYPE) {
						let boss_info = this.mystery_boxs_data && this.mystery_boxs_data[mon_type]
						if (boss_info) {
							let pos_list = this.boss_model.GetBoxsPos(boss_info.boss_id, BossModel.BossType.mystery)
							if (pos_list) {
								let len = pos_list.length
								if (len > 0) {
									this["box_label" + mon_type].color = Enum_ColorUtil_NEW.LIGHT_GREEN
									this["box_label" + mon_type].text = "剩余:" + len
									this["tired_label" + mon_type].text = "疲劳值:" + vo.anger
								} else {
									this["box_label" + mon_type].color = Enum_ColorUtil_NEW.LIGHT_RED
									this["tired_label" + mon_type].text = "疲劳值:" + vo.anger
									let end_time = boss_info.reborn_time
									this.StartCountTime(mon_type, () => {
										let left_time = end_time - TimeUtil.getServerTime()
										if (left_time < 0) {
											this["box_label" + mon_type].text = ""
											this.CancelCountTime(mon_type)
											return
										}
										this["box_label" + mon_type].text = TimeUtil.timeConvert(left_time, "hh:MM:ss")
									}
									)
								}
							}
						}
					} else {
						this.CancelCountTime(mon_type)
					}
				}
			}
		}
	}

	public ShowSpecialBoss() {
		let boss_name = null
		if (this.mystery_special_boss_data) {
			for (let _tmpi in this.mystery_special_boss_data) {
				var data = this.mystery_special_boss_data[_tmpi]
				boss_name = data.boss_name
				break
			}
			//let vo = null
			let layer_num = SceneManager.GetInstance().curr_scene_id - BossModel.BaseBossSceneId[this.boss_type]
			let num = this.boss_model.GetNowSpecialBossNum(layer_num)
			//let color_str = (num > 0 && ("#b3ff48") || ("#ffffff"))
			if (boss_name) {
				this.special_boss_str.innerHTML = "<a href='1@1'>" + Util.StrToHTML("当前场景存活<font color='#00fa64'>" + boss_name + "</font>：" + num) + "</a>"
			}
			// AddUnderlineText(this.special_boss_str, this.special_boss_str, "#ffffff", 15, 7)
		}
		//this.special_boss_str.text = [{text:"当前场景存活", style:{underline:true}], {text=boss_name, style=[textColor="#b3ff48", underline=true]], [text=":", style=[underline=true]], [text=num, style=[textColor=color_str, underline=true]]]
	}

	public SpecialBossClickFun() {

		let pos = null
		let special_boss_list = []
		let index = -1
		let vo = null
		let list = null
		let layer_num = SceneManager.GetInstance().curr_scene_id - BossModel.BaseBossSceneId[this.boss_type]
		if (this.boss_model.boxs_pos) {
			for (let boss_type in this.boss_model.boxs_pos) {

				if (Number(boss_type) == BossModel.BossType.mystery) {
					list = this.boss_model.boxs_pos[boss_type]
					if (list) {
						for (let boss_id in list) {

							vo = list[boss_id]
							if (this.boss_model.IsSpecialBoss(boss_id) && this.boss_model.GetLayerByBossId(boss_id) == layer_num) {
								if (vo) {
									for (let _tmpi in vo) {
										var sub = vo[_tmpi]
										let obj = null
										obj = []
										obj.boss_id = boss_id
										obj.x = sub.x
										obj.y = sub.y
										table.insert(special_boss_list, obj)
									}
								}
							}
						}
					}
				}
			}
			let recent_boss = this.GetRecentPos(special_boss_list)
			if (recent_boss) {
				this.StartFindWay(recent_boss, recent_boss.boss_id)
			} else {
				Message.show("当前场景存活数量0")
			}
		}
	}

	public StartFindWay(pos?, boss_id?) {

		if (pos) {
			let move_completed_callback = () => {
				let boss = this.local_scene.FindNearestMonsters(boss_id)
				// this.boss_model.auto = true
				let mainRole = this.local_scene.main_role
				if (boss && GameMath.GetDistance(mainRole.real_pos.x, mainRole.real_pos.y, boss.real_pos.x, boss.real_pos.y) <= 300 * 300) {
					if (!this.boss_model.JudgeTired(false, null, boss.vo.type_id)) {
						return
					}
					this.local_scene.clearGoToData()
					this.local_scene.SetClickTarget(boss)
					this.auto_fight_mgr.SetAutoFight(true)
				}
			}
			this.local_scene.MainRoleMove(new Vector2(pos.x / SceneObj.GetLogicRealRatio().x, pos.y / SceneObj.GetLogicRealRatio().y), 3, move_completed_callback)
		}
	}

	public UpdateVitStage() {

		// let num = GoodsModel.GetInstance().GetTypeGoodsNum(BossModel.tired_goods_id)
		// let bool = (num <= 0)
		// this._img_vit.gray = bool
	}

	public HelpSuccess() {
		let view_width = LayerManager.GetInstance().stageWidth
		SetAnchoredPositionX(this._img_help_tips, view_width)
		this._img_help_tips.visible = true
		let tar_x = view_width * 0.5 - 274 * 0.5
		this.tweenHelp = SYTweenLite.to(this, this._img_help_tips, SYTweenLite.UiAnimationType.ANCHORED_POSX, tar_x, 0.3, () => {
			this.timeHelp = setTimeout(() => {
				clearTimeout(this.timeHelp)
				this.tweenHelp = SYTweenLite.to(this, this._img_help_tips, SYTweenLite.UiAnimationType.ANCHORED_POSX, view_width, 0.3, () => {
					this._img_help_tips.visible = false
				}, SYTweenFunc.EASE_IN)
			}, 1)
		}, SYTweenFunc.EASE_IN)
	}

	public UpdateIconBox() {
		this._img_reborn.width = this._img_reborn.visible ? 63 : 0.1
		//this._img_vit.width = this._img_vit.visible ? 63 : 0.1
		// let space = (this._img_reborn.visible && this._img_vit.visible) ? 22 : 0
		// this._box_icon.space = space
	}

	_box_damage: Laya.Box
	_img_rank: Laya.Image
	_box_wayfinding: Laya.Box
	_box_secret: Laya.Box
	_Image1: Laya.Image
	_pilao_lb: Laya.Label
	_collect_lb: Laya.Label
	_Image2: Laya.Image
	_box_target: Laya.Box
	_box_state: Laya.HBox
	_state_img: Laya.Image
	_Image3: Laya.Image
	_box_holy: Laya.Box
	_gp_ordinary: Laya.Box
	_Image4: Laya.Image
	_lb_ordinary: Laya.Label
	_gp_rare: Laya.Box
	_Image5: Laya.Image
	_lb_rare: Laya.Label
	_gp_crystal: Laya.Box
	_Image6: Laya.Image
	_lb_crystal: Laya.Label
	_box_mystery: Laya.Box
	box2: Laya.Box
_img_desc_bg_1:Laya.Image
	_Image7: Laya.Image
	box_label2: Laya.Label
	tired_label2: Laya.Label
	box3: Laya.Box
_img_desc_bg_2:Laya.Image
	_Image8: Laya.Image
	box_label3: Laya.Label
	tired_label3: Laya.Label
	_box_right: Laya.Box
	_box_cross: Laya.Box
	_img_cross: Laya.Image
	cross_red: Laya.Image
	_box_kai: Laya.Box
	_img_kai: Laya.Image
	kai_red: Laya.Image
	_box_guard: Laya.Box
	_img_guard: Laya.Image
	_lb_guard: Laya.Label
	_box_exit: Laya.Box
	_img_exit: Laya.Image
	_box_special_boss: Laya.Box
	_Image9: Laya.Image
	special_boss_str: Laya.HTMLDivElement
	_box_war_free: Laya.Box
	_Image11: Laya.Image
	war_free_time_lb: Laya.Label
	_box_icon: Laya.Box
	_img_vit: Laya.Image
	_img_reborn: Laya.Image
	_box_help: Laya.Box
	_box_help_role: Laya.Box
	_img_help_tips: Laya.Image
	_img_title: Laya.Image
	public GetComponents() {
		[
			this._box_damage,
			this._img_rank,
			this._box_wayfinding,
			this._box_secret,
			this._Image1,
			this._pilao_lb,
			this._collect_lb,
			this._Image2,
			this._box_target,
			this._box_state,
			this._state_img,
			this._Image3,
			this._box_holy,
			this._gp_ordinary,
			this._Image4,
			this._lb_ordinary,
			this._gp_rare,
			this._Image5,
			this._lb_rare,
			this._gp_crystal,
			this._Image6,
			this._lb_crystal,
			this._box_mystery,
			this.box2,
this._img_desc_bg_1,
			this._Image7,
			this.box_label2,
			this.tired_label2,
			this.box3,
this._img_desc_bg_2,
			this._Image8,
			this.box_label3,
			this.tired_label3,
			this._box_right,
			this._box_cross,
			this._img_cross,
			this.cross_red,
			this._box_kai,
			this._img_kai,
			this.kai_red,
			this._box_guard,
			this._img_guard,
			this._lb_guard,
			this._box_exit,
			this._img_exit,
			this._box_special_boss,
			this._Image9,
			this.special_boss_str,
			this._box_war_free,
			this._Image11,
			this.war_free_time_lb,
			this._box_icon,
			this._img_vit,
			this._img_reborn,
			this._box_help,
			this._box_help_role,
			this._img_help_tips,
			this._img_title,
		]
			= this.GetChildrenByNames([

				"_box_damage",
				"_img_rank",
				"_box_wayfinding",
				"_box_secret",
				"_Image1",
				"_pilao_lb",
				"_collect_lb",
				"_Image2",
				"_box_target",
				"_box_state",
				"_state_img",
				"_Image3",
				"_box_holy",
				"_gp_ordinary",
				"_Image4",
				"_lb_ordinary",
				"_gp_rare",
				"_Image5",
				"_lb_rare",
				"_gp_crystal",
				"_Image6",
				"_lb_crystal",
				"_box_mystery",
				"box2",
"_img_desc_bg_1",
				"_Image7",
				"box_label2",
				"tired_label2",
				"box3",
"_img_desc_bg_2",
				"_Image8",
				"box_label3",
				"tired_label3",
				"_box_right",
				"_box_cross",
				"_img_cross",
				"cross_red",
				"_box_kai",
				"_img_kai",
				"kai_red",
				"_box_guard",
				"_img_guard",
				"_lb_guard",
				"_box_exit",
				"_img_exit",
				"_box_special_boss",
				"_Image9",
				"special_boss_str",
				"_box_war_free",
				"_Image11",
				"war_free_time_lb",
				"_box_icon",
				"_img_vit",
				"_img_reborn",
				"_box_help",
				"_box_help_role",
				"_img_help_tips",
				"_img_title",
			])
	}
}
window["BossFightSceneView"] = BossFightSceneView
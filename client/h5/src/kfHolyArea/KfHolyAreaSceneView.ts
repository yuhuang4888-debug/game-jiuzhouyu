
import { KfHolyAreaModel } from "../commonModel/KfHolyAreaModel"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { Util, SetSizeDeltaX, SetAnchoredPosition, SetLocalScaleX } from "../util/Util"
import { Alert, Alert_Type } from "../alert/Alert"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventName, SceneEventType } from "../common/EventName"
import { table } from "../common/table"
import { ColorUtil, ColorType } from "../util/ColorUtil"
import { TimeUtil } from "../util/TimeUtil"
import { RoleManager } from "../commonModel/RoleManager"
import { GlobalTimerQuest } from "../util/Util"
import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { SceneManager } from "../scene/SceneManager"
import { BossModel } from "../commonModel/BossModel"
import { AutoFightManager } from "../autofight/AutoFightManager"
import { BossSceneManager } from "../commonController/BossSceneManager"
import { MainUIModel } from "../commonModel/MainUIModel"
import { Scene } from "../scene/Scene"
import { GoodsModel } from "../commonModel/GoodsModel"
import { Config } from "../common/Config"
import { MainUIManager } from "../common/MainUIManager"
import { GameMath } from "../util/GameMath"
import { SceneBaseType } from "../scene/SceneConfig"
import { Runner } from "../util/Runner"
import { SYTweenLite } from "../util/SYTweenLite"
import { SceneObj } from "../scene/sceneobj/SceneObj"
import { Vector2 } from "../util/Vector2"
import { KfHolyAreaSceneBossItem } from "./KfHolyAreaSceneBossItem"
import { Mathf } from "../util/Mathf"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { KfHolyAreaSceneDamageItem } from "./KfHolyAreaSceneDamageItem"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { BossTargetItem } from "../boss/BossTargetItem"
import { KfHolyAreaDefine } from "./KfHolyAreaDefine"
import { TaskModel, TaskType } from "../commonModel/TaskModel"
import { ActivityIconManager } from "../commonModel/ActivityIconManager"
export class KfHolyAreaSceneView extends BaseView1 {
	labelD
	Emp_gp_exit
	Emp_rbtn_boss
	Emp_rbtn_damage
	Scr_Scroller1
	Scr_Scroller2
	_Scroller1
	_Scroller2
	_list_boss_con
	_list_damage_con
	auto_fight_mgr
	back_login_toClose
	boss_damage_dic
	boss_list
	boss_loop_mgr
	boss_model
	boss_pos_dic
	boss_scene_mgr
	boss_target_panel
	damage_list
	damage_loop_mgr
	destroy_callback
	destroy_imm
	goods_model
	hide_activity_state
	kf_holy_area_model
	mainUI_model
	progress_width
	role_mgr
	save_boss_damage_dic
	scene
	scene_id
	scene_mgr
	select_boss_id
	show_damage_boss_ins_id
	target_auto_fight_cfg
	time_func
	time_id
	time_out
	timer
	turn_state
	tween_list
	update_id
	update_times_index

	public constructor() {
		super()

		this.base_file = "kfHolyArea"
		this.layout_file = "KfHolyAreaSceneView"

		this.layer_value = Enum_UILayer.Main

		this.destroy_imm = true
		this.back_login_toClose = true

		this.progress_width = 224
		this.turn_state = true

		this.save_boss_damage_dic = []
		this.update_times_index = 0

		this.kf_holy_area_model = KfHolyAreaModel.GetInstance()
		this.scene_mgr = SceneManager.GetInstance()
		this.boss_model = BossModel.GetInstance()
		this.auto_fight_mgr = AutoFightManager.GetInstance()
		this.boss_scene_mgr = BossSceneManager.GetInstance()
		this.mainUI_model = MainUIModel.GetInstance()
		this.scene = Scene.GetInstance()
		this.goods_model = GoodsModel.GetInstance()
		this.role_mgr = RoleManager.GetInstance()

		this.hide_activity_state = false

		this.load_callback = () => {
			this.LoadSuccess()
		}

		this.destroy_callback = () => {
			this.Remove()
		}
	}

	public LoadSuccess() {



		// this.form.pivot = Vector2(0.5, 0.5)
		// this.form.anchorMin = Vector2(0, 0)
		// this.form.anchorMax = Vector2(1, 1)
		// this.form.anchoredPosition = Vector2(0, 0)
		// this.form.sizeDelta = Vector2(0,0)


		// if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
		// 	this._lb_boss_tips.size  = 14
		// 	this._lb_boss_tips.lineSpacing = 0.7
		// 	let csf = this._lb_boss_tips.GetComponent("ContentSizeFitter")
		// 	csf.horizontalFit = UnityEngine.UI.ContentSizeFitter.FitMode.Unconstrained
		// 	SetSizeDeltaX(this._lb_boss_tips,240)	
		// }
		ResManager.GetInstance().LoadFont(this, "rune_per", this._lb_left_time, null, false)
		GlobalEventSystem.Fire(EventName.STOPAUTOFIGHT)

		//ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("kfHolyArea", "uizxgj_001"))
		ResManager.GetInstance().SetImageSpriteTrans(this, this._img_bg0, GameResPath.GetIcon("kfHolyArea", "uikfsy_046"))
		ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg1, GameResPath.GetIcon("kfHolyArea", "uikfsy_045"))

		this.Content1.mouseHandler = new Laya.Handler(this, (e: Laya.Event, index) => {
			if (e.type == Laya.Event.CLICK)
				this.SwitchBoss(index)
		})

		this.turn_state = true

		this.InitEvent()

		this.ChangeScene()
		this.AddRunner()
		this.UpdateAnger()
		this.updateIconRed()


		this.SwitchBtn(true)
		this.updateTaskInfo()

		this.target_auto_fight_cfg = Config.PRELOAD_CLIENT_CONFIG.ConfigTargetAutoFight.Flag["kfHolyAreaScene"]

		MainUIManager.GetInstance().AddMoveComponent(this, this._gp_con, false, MainUIManager.MOVE_TYPE.Left)
		MainUIManager.GetInstance().AddMoveComponent(this, this._gp_exit, false, MainUIManager.MOVE_TYPE.Left)
	}

	public Remove() {

		if (this.boss_target_panel) {
			this.boss_target_panel.DeleteMe()
			this.boss_target_panel = null
		}
		this.CancelAllCountTime()
		this.RemoveRunner()
		this.CancelTime()
		this.ClearTween()

		if (this.damage_loop_mgr) {
			this.damage_loop_mgr.DeleteMe()
			this.damage_loop_mgr = null
		}

		if (this.boss_loop_mgr) {
			this.boss_loop_mgr.DeleteMe()
			this.boss_loop_mgr = null
		}
		// this.ClearUIEffect(this.effect_gp)

		MainUIManager.GetInstance().RemoveMoveComponent(this)
	}

	public UpdateAnger() {

		let info = this.kf_holy_area_model.score_data
		let max_anger = this.kf_holy_area_model.GetKeyValue("anger_limit")
		if (max_anger) {
			max_anger = Number(max_anger)
		} else {
			max_anger = 0
		}
		if (info && info.anger > 0) {
			SetSizeDeltaX(this._img_progress, info.anger / max_anger * this.progress_width)
			this._lb_anger.text = info.anger + "/" + max_anger
			this._lb_anger.color = "#00fa64"
			if (Number(info.anger) >= Number(max_anger))
				this._lb_anger.color = "#fe1a1a"
		} else {
			SetSizeDeltaX(this._img_progress, 0)
			this._lb_anger.text = 0 + "/" + max_anger
			this._lb_anger.color = "#00fa64"
		}
	}

	public FindBoss() {

		let list = Scene.GetInstance().GetMonsterList()
		let boss = null
		let x = null
		let y = null
		let distance = null
		let attacker = Scene.GetInstance().main_role
		for (let boss_id in list) {

			let mon = list[boss_id]
			x = mon.x
			y = mon.y
			let newdistance = GameMath.GetDistance(attacker.x, attacker.y, x, y)
			if (!distance || newdistance < distance) {
				distance = newdistance
				boss = mon
			}
		}
		return boss
	}

	public OwnerRole() {

		let main_vo = RoleManager.GetInstance().GetMainRoleVo()
		let role = null
		let role_vo_list = this.GetRoleVoList()
		for (let key in role_vo_list) {

			let role_vo = role_vo_list[key]
			if (role_vo.vo_type == SceneBaseType.MainRole) {
				break
			}
			if (!SceneManager.GetInstance().IsCanAttackByMainRole(role_vo)) {
				break
			}
			role = Scene.GetInstance().GetRole(role_vo.role_id)
			if (role) {
				break
			}
		}
		return role
	}

	public JudgeTarget(list?) {

		// if (this.secret_model.attack_target && this.secret_model.attack_target.obj_type == SceneBaseType.Role ) {
		// 	if (list.find(this.secret_model.attack_target) == -1 ) {
		// 		this.secret_model.attack_target = null
		// 	}
		// }
	}

	public AddRunner() {

		if (!this.update_id) {
			Runner.GetInstance().AddRunObj(this)
			this.update_id = true
		}
	}

	public RemoveRunner() {

		if (this.update_id) {
			Runner.GetInstance().RemoveRunObj(this.hashCode)
			this.update_id = null
		}
	}

	public ChangeScene() {

		this.select_boss_id = null
		this.scene_id = SceneManager.GetInstance().GetSceneId()
		this.kf_holy_area_model.Fire(KfHolyAreaModel.REQUEST_CCMD_EVENT, 28401, this.scene_id)
	}

	public InitEvent() {


		this.BindEvent(GlobalEventSystem, ActivityIconManager.SET_ICON_TEXT, (icon_type?, text?, color?) =>{
			if(icon_type == 284){
				if (text && text != '' && this._lb_icon_desc) {
					if (color) {
						this._lb_icon_desc.color = color
					}
					this._lb_icon_desc.text = text
					this._lb_icon_desc.visible = this._img_icon_desc_bg.visible = true
				}
				else {
					this._lb_icon_desc.visible = this._img_icon_desc_bg.visible = false
				}
			}
		});



		this.BindEvent(GlobalEventSystem, SceneEventType.MONSTER_VO_ADD, (instance_id?, monster_vo?) => {
			if (this.save_boss_damage_dic && this.save_boss_damage_dic[monster_vo.type_id]) {
				this.save_boss_damage_dic[monster_vo.type_id] = null
			}
			if (this.boss_damage_dic && this.boss_damage_dic[monster_vo.type_id]) {
				this.boss_damage_dic[monster_vo.type_id] = false
			}

			if (this.boss_scene_mgr.GetAutoState() && monster_vo && monster_vo.type_id == this.select_boss_id && this.kf_holy_area_model.JudgeTired(false)) {
				this.auto_fight_mgr.SetAutoFight(true)
			}

			// this.boss_model.showBossDieEffect(monster_vo.type_id, false)
		}
		)

		this.BindEvent(GlobalEventSystem, SceneEventType.MONSTER_VO_REMOVE, (instance_id?, monster_vo?) => {
			this.kf_holy_area_model.Fire(KfHolyAreaModel.REQUEST_CCMD_EVENT, 28401, this.scene_id)
		})


		this.BindEvent(GlobalEventSystem, SceneManager.START, (scene_id?) => {
			this.ChangeScene()
		})

		this.BindEvent(GlobalEventSystem, EventName.UPDATE_BOSS_DAMAGE_DATA, (monster_id?, list?) => {
			this.UpdateBossDamage(monster_id, list)
		})

		this.BindEvent(GlobalEventSystem, EventName.ADD_BOSS_DAMAGE_DATA, (vo?) => {
			this.AddBossDamage(vo)
		})

		this.BindEvent(GlobalEventSystem, EventName.REMOVE_BOSS_DAMAGE_DATA, (monster_id?, list?) => {
			this.RemoveDamage(monster_id, list)
		})


		this.BindEvent(this.kf_holy_area_model, KfHolyAreaModel.UPDATE_SCENE_DATA, (scene_id?) => {
			if (this.scene_id == scene_id) {
				this.UpdateBossInfo()
			}
		})

		this.BindEvent(this.kf_holy_area_model, KfHolyAreaModel.KILL_BOSS, (scmd?) => {
			let scene_info = this.kf_holy_area_model.GetSceneData(this.scene_id)
			if (scene_info) {
				let bool = false
				for (let _tmpi in scene_info.boss_info) {
					var vo = scene_info.boss_info[_tmpi]
					if (vo.bossid == scmd.boss_id) {
						vo.reborn_time = scmd.reborn_time
						bool = true
						break
					}
				}
				if (bool) {
					this.kf_holy_area_model.SetSceneData(scene_info.scene, scene_info)
				}
			}
		})


		this.BindEvent(this.kf_holy_area_model, KfHolyAreaModel.EXIT_COUNT_DOWN, (scmd?) => {
			let end_time = scmd.out_time
			let call_back = () => {
				if (!this._gp_con1.visible) {
					this._gp_con1.visible = true
				}
				let left_time = end_time - TimeUtil.getServerTime()
				if (left_time < 0) {
					this._gp_con1.visible = false
					this.CancelCountTime(0)
				}
				this._lb_left_time.text = String(left_time)
			}

			this.StartCountTime(0, call_back, 1)
		})

		this.BindEvent(this.kf_holy_area_model, KfHolyAreaModel.SCENE_EVENT.CHANGE_BOSS_TARGET, (boss_id?) => {
			this.select_boss_id = boss_id
			this.TryFindBoss()
		})

		this.BindVar(this.kf_holy_area_model, "score_data", () => {
			this.UpdateAnger()
		})

		this.BindVar(this.kf_holy_area_model, "damage_data", () => {
			let scmd = this.kf_holy_area_model.damage_data
			if (scmd) {
				let list = []
				for (let _tmpi in scmd.rank_list) {
					var obj = scmd.rank_list[_tmpi]
					let camp = this.kf_holy_area_model.GetCampByServerId(obj.server_id)
					if (!camp) {
						return
					}
					table.insert(
						list,
						{
							modulus: obj.hurt / 100,
							server_id: obj.server_id,
							server_num: obj.server_num,
							player_id: obj.role_id,
							player_name: obj.name,
							server_name: obj.server_name,
							camp: camp,
						}
					)
				}
				table.sort(list, (a?, b?) => {
					return b.modulus > a.modulus
				})

				let dic = []
				for (let _tmpi in list) {
					var vo = list[_tmpi]
					if (!dic[vo.camp]) {
						dic[vo.camp] = {
							server_name: vo.server_name,
							server_num: vo.server_num,
							camp: vo.camp,
							damage: 0
						}
					}
					dic[vo.camp].damage = dic[vo.camp].damage + vo.modulus
				}

				let max_server_id = null
				let max_damage = null
				let max_camp = null
				for (let camp in dic) {

					let obj = dic[camp]
					if (obj) {
						if (!max_damage || obj.damage > max_damage) {
							max_damage = obj.damage
							max_server_id = obj.server_id
							max_camp = camp
						}
					}
				}

				let max_data = max_camp && dic[max_camp]
				if (max_data) {
					if (this.kf_holy_area_model.IsCampMode()) {
						let c_sanctuary_camp_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_c_sanctuary_camp", false)
						this._lb_boss_owner.text = "当前归属:" + this.kf_holy_area_model.GetCampName(max_camp, c_sanctuary_camp_cfg)
					} else {
						this._lb_boss_owner.text = "当前归属:S" + max_data.server_num + "." + max_data.server_name
					}
				} else {
					this._lb_boss_owner.text = ""
				}
				this.damage_list = list
				this.ReplaceDamageList()
			}
		})

		this.BindEvent(MainUIModel.GetInstance(), MainUIModel.UPDATE_ACTIVITY_STATE, (bool?) => {
			this.updateIconShow(bool)
		})

		this.BindEvent(this.kf_holy_area_model, KfHolyAreaModel.REFRESH_RED_FLAG, (scmd?) => {
			this.updateIconRed()
		})

		// this._rbtn_boss.group.addEventListener(Laya.UIEvent.CHANGE, this.SwitchBtn, this)
		// this._list_boss_con.addEventListener(Laya.ItemTapEvent.ITEM_TAP, this.touch_boss_list, this)

		Util.AddClickEvent(this._gp_exit, () => {
			Alert.Show("确定要从场景中退出吗?", Alert_Type.Two, () => {
				this.kf_holy_area_model.Fire(KfHolyAreaModel.REQUEST_CCMD_EVENT, 28407)
			}, null, "退出", "取消")
		}, this, true)


		Util.AddClickEvent(this._img_turn, () => {
			this.turn_state = this.TurnSubView(!this.turn_state)
		}, this, true)


		Util.AddClickEvent(this._rbtn_boss, () => {
			this.SwitchBtn(true)
		}, this)


		Util.AddClickEvent(this._rbtn_damage, () => {
			this.SwitchBtn(false)
		}, this)

		Util.AddClickEvent(this.img_icon, () => {
			this.kf_holy_area_model.Fire(KfHolyAreaModel.OPEN_VIEW, 'KfHolyAreaEnterView');
		}, this, true)


		// Util.AddClickEvent(this.auction_gp,() => {
		// 		this.ClearUIEffect(this.effect_gp)
		// 		this.kf_holy_area_model.Fire(KfHolyAreaModel.OPEN_VIEW, "KfHolyAreaAuctionIntroduceView")
		// 	},this,true)

		// this.BindEvent(this.kf_holy_area_model, KfHolyAreaModel.UPDATE_REFRESH_BOSS_TIME,(end_time?) => {
		// 	this.UpdateAuctionTime(end_time)
		// }
		// )

		// this.kf_holy_area_model.Fire(KfHolyAreaModel.REQUEST_CCMD_EVENT, 28420)
		Util.AddClickEvent(this.gp_task, () => {
			let _task_data = TaskModel.GetInstance().GetReceiveTaskVoByTaskType(TaskType.KFHOLYAREA_TASK);
			if (_task_data && _task_data.now_num >= _task_data.need_num && _task_data.has_finish == 1) {
				TaskModel.GetInstance().Fire(TaskModel.REQUEST_CCMD_EVENT, 30004, _task_data.task_id)
			}
		}, this, false)
		this.InitFightEvent()
	}

	public TurnSubView(state?) {

		if (this.turn_state == state) {
			return this.turn_state
		}
		this.ClearTween()
		if (!this.tween_list) {
			this.tween_list = []
		}
		SetLocalScaleX(this._img_turn, state ? 1 : -1)

		if (state) {
			table.insert(this.tween_list, SYTweenLite.to(this, this._gp_con0, SYTweenLite.UiAnimationType.ANCHORED_POSX, 0, MainUIModel.Move_Time_Interval))
			//table.insert(this.tween_list, SYTweenLite.to(this, this._img_turn, SYTweenLite.UiAnimationType.POSX, 207, MainUIModel.Move_Time_Interval))
		} else {
			table.insert(this.tween_list, SYTweenLite.to(this, this._gp_con0, SYTweenLite.UiAnimationType.ANCHORED_POSX, -280, MainUIModel.Move_Time_Interval))
			//table.insert(this.tween_list, SYTweenLite.to(this, this._img_turn, SYTweenLite.UiAnimationType.POSX, 20, MainUIModel.Move_Time_Interval))
		}
		return state
	}

	public ClearTween() {

		if (this.tween_list) {
			for (let _ in this.tween_list) {
				var id = this.tween_list[_]
				SYTweenLite.Stop(id)
			}
			this.tween_list = false
		}
		// Laya.Tween.removeTweens(this._gp_con0)
		// Laya.Tween.removeTweens(this._img_turn)
		// Laya.Tween.removeTweens(this.auction_gp)
	}

	private updateIconShow(bool) {
		this.img_icon.visible = !bool
	}

	private updateIconRed() {
		this._icon_red.visible = KfHolyAreaModel.GetInstance().GetRedState()
	}

	public SwitchBtn(bool?) {

		if (bool) {

			this.labelDisplay.color = ColorUtil.TryParseHtmlString("#98521a")
			this.labelDisplay1.color = ColorUtil.TryParseHtmlString("#50557d")

			ResManager.GetInstance().SetImageSprite(this, this._Image111, "mainUI_asset", "mainui_taskbtn_light")
			ResManager.GetInstance().SetImageSprite(this, this._Image1, "mainUI_asset", "mainui_taskbtn_normal")

			this._gp_boss.visible = true
			this._gp_damage.visible = false
			this._lb_anger.visible = true
			this.nuqi.visible = true
		} else {
			this.labelDisplay.color = ColorUtil.TryParseHtmlString("#50557d")
			this.labelDisplay1.color = ColorUtil.TryParseHtmlString("#98521a")

			ResManager.GetInstance().SetImageSprite(this, this._Image111, "mainUI_asset", "mainui_taskbtn_normal")
			ResManager.GetInstance().SetImageSprite(this, this._Image1, "mainUI_asset", "mainui_taskbtn_light")

			this._gp_boss.visible = false
			this._gp_damage.visible = true
			this._lb_anger.visible = false
			this.nuqi.visible = false
		}

	}

	public SwitchBoss(index?) {

		let boss_info = this.boss_list[index]
		this.select_boss_id = boss_info && boss_info.bossid
		this.TryFindBoss()
	}

	public TryFindBoss() {

		let end_pos = this.GetBossPos()
		if (end_pos) {
			GlobalEventSystem.Fire(EventName.STOPAUTOFIGHT)
			Scene.GetInstance().SetClickTarget(null)
			let real_x = end_pos.x / SceneObj.GetLogicRealRatio().x
			let real_y = end_pos.y / SceneObj.GetLogicRealRatio().y
			let move_completed_callback = () => {
				Scene.GetInstance().clearGoToData()
				this.kf_holy_area_model.JudgeTired(true)
				GlobalEventSystem.Fire(EventName.STARTAUTOFIGHT)
			}

			Scene.GetInstance().MainRoleMove(new Vector2(real_x, real_y), 3, move_completed_callback)
		}
	}

	public UpdateSelect() {

		let target = Scene.GetInstance().GetClickTarget()
		if (target && target.obj_type == SceneBaseType.Monster) {
			let list = this.boss_list
			let index = null
			for (let key in list) {

				let vo = list[key]
				if (vo && vo.bossid == target.vo.type_id) {
					index = key
					break
				}
			}
			if (index != null && this.boss_loop_mgr.select_index != index) {
				this.select_boss_id = target.vo.type_id
				this.boss_loop_mgr.SetSelectIndex(index)
				this.UpdateScrollV()
			}
		}
	}

	public UpdateScrollV() {

		// let index = this.boss_loop_mgr.select_index
		// if (index > 0) {
		// 	let height = KfHolyAreaSceneBossItem.height * (index - 1)
		// 	let y_offset = Mathf.Clamp(height, 0, this.Content1.sizeDelta.y + 1 - this._Scroller1.sizeDelta.y)
		// 	SetAnchoredPosition(this.Content1, 0, y_offset)
		// }
	}

	public GetBossPos() {

		return this.boss_pos_dic && this.boss_pos_dic[this.select_boss_id]
	}

	public GetBossInfo() {

		let list = this.boss_list
		if (list) {
			for (let _tmpi in list) {
				var vo = list[_tmpi]
				if (vo.bossid == this.select_boss_id) {
					return vo
				}
			}
		}
	}

	public UpdateBossDamage(monster_id?, list?) {

		if (!this.boss_damage_dic) {
			this.boss_damage_dic = []
		}
		let dic = []
		for (let _tmpi in list) {
			var vo = list[_tmpi]
			dic[vo.player_id] = vo
		}
		this.boss_damage_dic[monster_id] = dic
		this.UpdateDamageList()
	}

	public AddBossDamage(vo?) {

		let dic = this.boss_damage_dic && this.boss_damage_dic[vo.monster_id]
		if (dic) {
			let data = dic[vo.player_id]
			if (data) {
				data.damage = data.damage + vo.damage
			} else {
				dic[vo.player_id] = vo
			}
			this.UpdateDamageList()
		}
	}

	public RemoveDamage(monster_id?, list?) {

		let dic = this.boss_damage_dic && this.boss_damage_dic[monster_id]
		if (dic) {
			for (let _tmpi in list) {
				var data = list[_tmpi]
				if (dic[data.player_id]) {
					dic[data.player_id] = null
				}
			}
			this.UpdateDamageList()
		}
	}

	public GetDamageList() {

		let list = []
		if (this.boss_damage_dic && this.boss_damage_dic[this.show_damage_boss_ins_id]) {
			let dic = this.boss_damage_dic[this.show_damage_boss_ins_id]
			let total_damage = 0
			for (let key in dic) {

				let vo = dic[key]
				if (vo && vo.damage) {
					total_damage = total_damage + vo.damage
					table.insert(list, vo)
				}
			}
			table.sort(list, (a?, b?) => {
				return a.damage > b.damage
			})

			for (let _tmpi in list) {
				var vo = list[_tmpi]
				if (!vo.damage) {
					vo.modulus = 0
				} else {
					let value = vo.damage * 100 / total_damage

					vo.modulus = Number(value.toFixed(2))
				}
			}
		}
		return list
	}

	public UpdateDamageList() {

		let list = this.GetDamageList()
		let dic = []
		let camp = null
		for (let _tmpi in list) {
			var vo = list[_tmpi]
			camp = this.kf_holy_area_model.GetCampByServerId(vo.server_id)
			if (camp) {
				if (!dic[camp]) {
					dic[camp] = { camp: camp, server_name: vo.server_name, server_num: vo.server_num, damage: 0 }
				}
				dic[camp].damage = dic[camp].damage + vo.damage
			}
		}
		let max_server_id = null
		let max_damage = null
		let max_camp = null
		for (let camp in dic) {

			let obj = dic[camp]
			if (obj) {
				if (!max_damage || obj.damage > max_damage) {
					max_damage = obj.damage
					max_server_id = obj.server_id
					max_camp = camp
				}
			}
		}
		let max_data = max_camp && dic[max_camp]
		if (max_data) {
			if (this.kf_holy_area_model.IsCampMode()) {
				this._lb_boss_owner.text = "当前归属:" + this.kf_holy_area_model.GetCampName(max_camp)
			} else {
				this._lb_boss_owner.text = "当前归属:S" + max_data.server_num + "." + max_data.server_name
			}
		} else {
			this._lb_boss_owner.text = ""
		}
		this.damage_list = list
		this.ReplaceDamageList()
	}

	public ReplaceDamageList() {

		if (this.damage_loop_mgr) {
			this.damage_loop_mgr.replaceAll(this.damage_list)
		} else {
			this.damage_loop_mgr = new LoopScrowViewMgr()
			this.damage_loop_mgr.SetData(this.Content, KfHolyAreaSceneDamageItem, this.damage_list, LoopScrCon.Vertical)
		}
	}

	public UpdateBossInfo() {

		let scene_info = this.kf_holy_area_model.GetSceneData(this.scene_id)
		let list
		if (scene_info) {
			list = scene_info.boss_info
		} else {
			list = []
		}

		this.boss_list = list
		if (this.boss_loop_mgr) {
			this.boss_loop_mgr.replaceAll(this.boss_list)
		} else {
			this.boss_loop_mgr = new LoopScrowViewMgr()
			this.boss_loop_mgr.SetData(
				this.Content1,
				KfHolyAreaSceneBossItem,
				this.boss_list,
				LoopScrCon.Vertical,
				1, () => {

				}
			)
		}

		this.UpdateBossPos()
		if (!this.select_boss_id) {
			let enter_info = this.kf_holy_area_model.GetEnterInfo()
			if (enter_info) {
				this.select_boss_id = enter_info.boss_id
				this.TryFindBoss()
				let index = null
				for (let key in scene_info.boss_info) {

					let vo = scene_info.boss_info[key]
					if (vo && vo.bossid == enter_info.boss_id) {
						index = key
						break
					}
				}
				if (index != null && this.boss_loop_mgr.select_index != index) {
					this.select_boss_id = enter_info.boss_id
					this.boss_loop_mgr.SetSelectIndex(index)
					this.UpdateScrollV()
				}
			}
		}
	}

	public UpdateBossPos() {

		let list = this.boss_list
		this.boss_pos_dic = []
		for (let _tmpi in list) {
			var vo = list[_tmpi]
			let cfg = this.kf_holy_area_model.GetMonsterCfg(vo.bossid)
			if (cfg) {
				this.boss_pos_dic[vo.bossid] = {
					x: cfg.x,
					y: cfg.y
				}
			}
		}
	}

	public GetBossInfoByBossId(boss_id?) {

		let list = this.boss_list
		if (list) {
			for (let _tmpi in list) {
				var vo = list[_tmpi]
				if (vo.bossid == boss_id) {
					return vo
				}
			}
		}
	}

	public Update(now_time?, elapse_time?) {

		this.update_times_index = this.update_times_index + 1

		if (this.update_times_index % 20 == 0) {
			this.UpdateBossAutoFight()
		}

		if (this.update_times_index % 20 == 0) {
			this.UpdateDamage()
		}
	}

	public UpdateDamage() {

		if (this.boss_pos_dic) {
			for (let boss_id in this.boss_pos_dic) {

				//let pos = this.boss_pos_dic[boss_id]
				let mon_cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_mon.name, boss_id, false)
				//tracing_distance
				let monster_list = Scene.GetInstance().FindTargets(Scene.FIND_TARGET_TYPE.monster, 1, null, 2000, null, null, null)[0]
				if (monster_list && Util.TableSize(monster_list) > 0) {
					let monster1 = null
					for (let _ in monster_list) {
						var v = monster_list[_]
						if (v.vo && v.vo.type_id && v.vo.type_id == boss_id) {
							monster1 = v.vo
							break
						}
					}
					if (monster1) {
						let main_role_vo = this.role_mgr.GetMainRoleVo()
						if (main_role_vo) {
							let distance = GameMath.GetDistance(main_role_vo.pos_x, main_role_vo.pos_y, monster1.pos_x, monster1.pos_y)
							if (monster1.cfg_data && monster1.cfg_data.tracing_distance && distance <= monster1.cfg_data.tracing_distance * monster1.cfg_data.tracing_distance) {//KfHolyAreaDefine.Examination_Range * KfHolyAreaDefine.Examination_Range ) {
								if (!this.save_boss_damage_dic[boss_id]) {
									let boss_cfg = this.kf_holy_area_model.GetMonsterCfg(boss_id)
									let scene_info = this.kf_holy_area_model.GetSceneData(this.scene_id)
									let type_cfg = boss_cfg && this.kf_holy_area_model.GetMonsterTypeCfg(boss_cfg.type, scene_info && scene_info.con_type)
									if (type_cfg) {
										this._lb_boss_tips.text = "按照伤害比例分配" + type_cfg.score + "积分"
									}
									let info = this.GetBossInfoByBossId(boss_id)
									if (info && (info.reborn_time == 0 || info.reborn_time < TimeUtil.getServerTime())) {
										let mon_list = this.scene.FindTargets(Scene.FIND_TARGET_TYPE.monster, 1, null, this.target_auto_fight_cfg.distance, null, null, null)[0]
										let monster = mon_list[0]
										let monster_vo = null
										if (monster) {
											monster_vo = monster.GetVo()
										}
										if (monster_vo && monster_vo.type_id == boss_id) {
											this.save_boss_damage_dic[boss_id] = true
											this.show_damage_boss_ins_id = monster_vo.instance_id
											UserMsgAdapter.GetInstance().SendAllFmtToGame(12025, "i", [monster_vo.instance_id])
										}
									} else {
										this.save_boss_damage_dic[boss_id] = true
										this.kf_holy_area_model.Fire(KfHolyAreaModel.REQUEST_CCMD_EVENT, 28403, this.scene_id, boss_id)
									}
									if (this.save_boss_damage_dic[boss_id]) {
										let mon_cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_mon.name, boss_id, false)
										this._lb_boss_name.text = mon_cfg && mon_cfg.name || ""
									}
								}
							}
							else {
								if (this.save_boss_damage_dic[boss_id]) {
									this.save_boss_damage_dic[boss_id] = false
									this.show_damage_boss_ins_id = null
									this._lb_boss_tips.text = ""
									this._lb_boss_name.text = ""
									this.UpdateDamageList()
								}
							}
						}

					}
				}

			}
		}
	}

	public StartCountTime(type?, func?, time?) {

		if (!this.time_id) {
			this.time_id = {}
		}
		this.CancelCountTime(type)
		this.time_id[type] = GlobalTimerQuest.AddPeriodQuest(func, time, -1)
		func()
	}

	public CancelCountTime(type?) {

		if (!this.time_id || !this.time_id[type]) {
			return
		}
		GlobalTimerQuest.CancelQuest(this.time_id[type])
		delete this.time_id[type]
	}

	public CancelAllCountTime() {

		if (!this.time_id) {
			return
		}
		for (let key in this.time_id) {

			GlobalTimerQuest.CancelQuest(this.time_id[key])
			// this.time_id[key].stop()
			// this.time_id[key].removeEventListener(Laya.TimerEvent.TIMER, this.time_func[key], this)
		}
		this.time_id = null
		this.time_func = null
	}

	public UpdateAuctionTime(end_time?) {

		let auction_produce_limit_time = this.kf_holy_area_model.GetKeyValue("auction_produce_limit_time")
		let time = TimeUtil.getServerTime()
		let start_time = end_time - auction_produce_limit_time
		if (time > start_time && time < end_time) {
			this.auction_gp.visible = true
			// this.ClearUIEffect(this.effect_gp)
			// this.AddUIEffect("ui_function_glow", this.effect_gp, null, null, true)
			this.time_out = end_time - time
			this.UpdateTimer()
			this.StarTimer(1)
		} else {
			this.CancelTime()
			this.auction_gp.visible = false
		}
	}

	public UpdateTimer() {

		if (this.time_out <= 0) {
			this.CancelTime()
			this.auction_gp.visible = false
			return
		}
		this.time_out = this.time_out - 1
		let D = Math.floor(this.time_out / 60 / 60 / 24)
		let h = Math.floor(this.time_out / 60 / 60) % 24
		let m = Math.floor(this.time_out / 60) % 60
		let s = this.time_out % 60
		if (D >= 1) {
			this.auction_lb.text = D + "天" + h + "时"
		} else if (h >= 1) {
			this.auction_lb.text = h + "小时" + m + "分"
		} else if (m >= 1) {
			if (s >= 10) {
				this.auction_lb.text = m + "分" + s + "秒"
			} else {
				this.auction_lb.text = m + "分0" + s + "秒"
			}
		} else {
			if (s >= 10) {
				this.auction_lb.text = s + "秒"
			} else {
				this.auction_lb.text = "0" + s + "秒"
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

	public InitFightEvent() {


		// AutoFightManager.GetInstance().SetAutoFight(true)

		if (!this.boss_target_panel) {
			this.boss_target_panel = new BossTargetItem(this._target_gp)
			this.boss_target_panel.SetStartPos(29, -23)
			this.boss_target_panel.Load()
		}

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

		//this:BindEvent(GlobalEventSystem,NineSkyModel.NINE_SKY_FIGHTING_MSG,(attack_role_id?) => {
		//this.boss_scene_mgr.SetSufferedList(attack_role_id)
		//})

		this.BindEvent(GlobalEventSystem, EventName.SHOWRELIVEWINDOW, () => {
			this.boss_scene_mgr.SetAttackTarget(null)
		})

		this.BindEvent(GlobalEventSystem, SceneEventType.CHARACTER_DEAD, (obj?) => {


			//let curr_attack_target = SceneManager.GetInstance().curr_attack_target
			//if (curr_attack_target && obj == curr_attack_target ) {
			//curr_attack_target = null
			//}
		})

		this.BindEvent(GlobalEventSystem, SceneEventType.CANCEL_CLICK_TARGET, () => {
			if (this.boss_scene_mgr.GetAttackTarget()) {
				this.boss_scene_mgr.SetAttackTarget(null)
			}
			this.boss_scene_mgr.SetAutoState(false)
		})


		//this:BindEvent(this.scene,SceneEventType.SCENE_MOVE_END,() => {
		// if (SceneManager.GetInstance().IsPickUpDropScene() ) {
		// 	this.boss_model.FindDrop()
		// }
		//})

		//SceneManager:GetInstance():BindOne("curr_joystick_dir",() => {
		//if (! SceneManager.GetInstance().curr_joystick_dir ) {
		//if (SceneManager.GetInstance().IsPickUpDropScene() ) {
		//this.boss_model.FindDrop()
		//}
		//}
		//})

		// this.BindEvent(this.boss_model,BossBaseModel.PICK_UP_END,() => {
		// 		if (SceneManager.GetInstance().IsPickUpDropScene() ) {
		// 			this.TryFindBoss()
		// 			AutoFightManager.GetInstance().SetAutoFight(true)
		// 		}
		// 	})
		this.BindEvent(this.task_model, TaskModel.UPDATE_ONE_TASK, () => {
			this.updateTaskInfo()
		})

		this.BindEvent(this.task_model, TaskModel.UPDATE_ALL_TASK_FROM_30000, () => {
			this.updateTaskInfo()
		})
	}

	public UpdateBossAutoFight() {

		let obj_list = []


		let mon_list = this.scene.FindTargets(Scene.FIND_TARGET_TYPE.monster, 1, null, this.target_auto_fight_cfg.distance, null, null, null)[0]


		if (mon_list.length > 0) {
			for (let _ = 0; _ < mon_list.length; _++) {
				var mon = mon_list[_]
				table.insert(obj_list, mon)
			}
		} else if (this.select_boss_id && this.select_boss_id > 0) {
			let vo = this.GetBossInfo()

			if (vo && vo.reborn_time > TimeUtil.getServerTime()) {
				let bossPos = this.GetBossPos()
				if (bossPos) {
					let main_role_vo = this.role_mgr.GetMainRoleVo()
					let distance = GameMath.GetDistance(main_role_vo.pos_x, main_role_vo.pos_y, bossPos.x, bossPos.y)
					let monVo = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_mon.name, vo.bossid, false)
					let bossDistance = monVo.tracing_distance + 150
					if (distance <= bossDistance * bossDistance) {

						table.insert(obj_list, {
							boss_id: vo.bossid,
							reborn_time: vo.reborn_time,
							boss_name: monVo.name
						})
					}
				}
			}
		}


		let role_list = this.scene.FindTargets(Scene.FIND_TARGET_TYPE.role, 10, null, this.target_auto_fight_cfg.distance, null, null, null)[0]
		if (role_list) {
			let no_owner_list = []
			for (let role_id in role_list) {
				var obj = role_list[role_id]
				if (obj && !obj.IsDead()) {
					if (obj.vo.boss_flag == 1) {
						table.insert(obj_list, obj)
					} else {
						table.insert(no_owner_list, obj)
					}
				}
			}

			for (let _ = 0; _ < no_owner_list.length; _++) {
				var obj = no_owner_list[_]
				table.insert(obj_list, obj)
			}
		}

		if (obj_list.length > 0) {
			if (!this.hide_activity_state && MainUIModel.GetInstance().activity_icon_in_show) {
				MainUIModel.GetInstance().Fire(MainUIModel.CHANGE_ACTIVITY_STATE, false)
			}
			let boss = mon_list[0]
			if (boss && !MainUIModel.GetInstance().big_blood_in_show) {
				let config = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_mon.name, boss.GetVo().type_id, false)
				GlobalEventSystem.Fire(EventName.SHOW_HITER_BIG_BLOOD_VIEW, true, boss.GetVo(), config.hp_num)
			}
			if (this.boss_target_panel) {
				this.boss_target_panel.SetData(obj_list)
			}
			this.hide_activity_state = true
			if (this._target_gp) {
				this._target_gp.visible = true
			}
			if (this._target_gp && !MainUIManager.GetInstance().HasMoveComponent(this, this._target_gp)) {
				// this._target_gp.x = 210
				// this._target_gp.y = 255
				MainUIManager.GetInstance().AddMoveComponent(this, this._target_gp, false, MainUIManager.MOVE_TYPE.Right)
			}
		} else {
			this.hide_activity_state = false
			if (this._target_gp) {
				this._target_gp.visible = false
				if (this._target_gp && MainUIManager.GetInstance().HasMoveComponent(this, this._target_gp)) {
					MainUIManager.GetInstance().RemoveMoveOneComponent(this, this._target_gp)
				}
			}
		}
		// this.attackTarget()
	}

	public attackTarget() {

		// let target = this.secret_model.attack_target
		// let auto_state = AutoFightManager.GetInstance().GetAutoFightState()
		// if (this.boss_model.autopickup && auto_state ) {
		// 	GlobalEventSystem.Fire(EventName.STOPAUTOFIGHT)
		// }
		// if (this.boss_model.autopickup || ! auto_state ) {
		// 	if (target ) {
		// 		this.secret_model.attack_target = null
		// 	}
		// 	return
		// }
		// if (target ) {
		// 	let vo = target.GetVo()
		// 	if (vo ) {
		// 		if (target.obj_type == SceneBaseType.Role ) {
		// 			if (! this.scene.GetRole(vo.role_id) || ! SceneManager.GetInstance().IsCanAttackByMainRole(vo) ) {
		// 				this.secret_model.attack_target = null
		// 				target = this.secret_model.attack_target
		// 				this.scene.SetClickTarget(null)
		// 			}
		// 		} else if (target.obj_type == SceneBaseType.Monster ) {
		// 			if (! this.scene.GetMonster(vo.instance_id) ) {
		// 				this.secret_model.attack_target = null
		// 				target = this.secret_model.attack_target
		// 				this.scene.SetClickTarget(null)
		// 			}
		// 		}
		// 	}else{
		// 		this.secret_model.attack_target = null
		// 		target = this.secret_model.attack_target
		// 		this.scene.SetClickTarget(null)
		// 	}
		// }
		// let scene_mgr = SceneManager.GetInstance()
		// let bossPos = null
		// let distance = null
		// let c_sanctuary_mon_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_c_sanctuary_mon", false)
		// let vo = this.GetBossInfo()
		// let bossVo = vo && this.kf_holy_area_model.GetMonsterCfg(vo.bossid, c_sanctuary_mon_cfg)
		// if (bossVo ) {
		// 	bossPos = [x = bossVo.x, y = bossVo.y]
		// }
		// let main_role = this.scene.main_role
		// if (bossPos && main_role ) {
		// 	distance = GameMath.GetDistance(main_role.x, main_role.y, bossPos.x, bossPos.y)
		// }
		// if (distance ) {
		// 	if (distance < KfHolyAreaDefine.Examination_Range * KfHolyAreaDefine.Examination_Range ) {
		// 		if (! target ) {
		// 			let obj = null
		// 			let boss = this.scene.GetMonsterByTypeId(this.select_boss_id)
		// 			if (boss ) {
		// 				let role = this.OwnerRole()
		// 				if (role ) {
		// 					if (role && ! role.IsDead() ) {
		// 						obj = role
		// 					}
		// 				} else if (this.kf_holy_area_model.JudgeTired(false) ) {
		// 					obj = boss
		// 				}
		// 			}else{
		// 				let role = this.secret_model.nearSufferedRole()
		// 				if (scene_mgr.IsCanAttackByMainRole(role, false) ) {
		// 					obj = role
		// 				}
		// 				if (! obj ) {
		// 					let nearBossRole = bossPos && this.secret_model.nearBossRole(bossPos)
		// 					if (nearBossRole && scene_mgr.IsCanAttackByMainRole(nearBossRole.GetVo(), false) ) {
		// 						obj = nearBossRole
		// 					}
		// 				}
		// 			}
		// 			if (obj ) {
		// 				target = obj
		// 				this.secret_model.attack_target = target
		// 			}
		// 		}
		// 		if (target ) {
		// 			this.scene.clearGoToData()
		// 			this.scene.SetClickTarget(target)
		// 		}
		// 	}
		// }
	}

	public CheckRole(bossPos?) {

		let main_role = Scene.GetInstance().main_role
		let distance = GameMath.GetDistance(main_role.x, main_role.y, bossPos.x, bossPos.y)
		if (distance > KfHolyAreaDefine.Examination_Range * KfHolyAreaDefine.Examination_Range) {
			return true
		}
		return false
	}

	public GetRoleVoList() {

		let main_role_vo = RoleManager.GetInstance().GetMainRoleVo()
		let main_role_id = RoleManager.GetInstance().GetMainRoleId()
		let list = []
		let role_vo_list = SceneManager.GetInstance().GetAllRoleVos()

		for (let role_id in role_vo_list) {

			let role_vo = role_vo_list[role_id]
			if (role_vo.hp == 0 || role_vo.boss_flag == 1) {

			} else {
				if (Number(role_id) != main_role_id) {
					table.insert(list, role_vo)
				}
			}
		}
		return list
	}


	// 服
	public GetRoleList() {

		let main_role_vo = RoleManager.GetInstance().GetMainRoleVo()
		let main_role_id = RoleManager.GetInstance().GetMainRoleId()
		let list = []
		let owner_list = []
		let role_vo_list = SceneManager.GetInstance().GetAllRoleVos()

		for (let role_id in role_vo_list) {

			let role_vo = role_vo_list[role_id]
			if (role_vo.hp == 0 || Number(role_id) == main_role_id) {

			} else {
				let role = Scene.GetInstance().GetRole(role_id)
				if (role) {

					if (role_vo.boss_flag == 1) {
						table.insert(owner_list, role)
					} else {
						table.insert(list, role)
					}

				}
			}
		}
		for (let key in list) {
			let obj = list[key]
			table.insert(owner_list, obj)
		}
		return list
	}

	private updateTaskInfo() {
		let _task_data = TaskModel.GetInstance().GetReceiveTaskVoByTaskType(TaskType.KFHOLYAREA_TASK);
		if (_task_data) {
			this.gp_task.visible = true;
			this.lblTaskTitle.text = _task_data.task_name;
			this.task_desc.style.fontSize = 18;
			this.task_desc.style.color = "#663915";
			this.task_desc.style.leading = -1;
			// this.task_desc.style.padding =  [(180 - this.task_desc.contextHeight) * 0.25, 0, 0, 0];;
			this.task_desc.style.wordWrap = true;
			this.task_desc.style.width = 180;
			if (_task_data.has_finish > 0) {
				this.task_desc.innerHTML = _task_data.tips + "<font color='#639c12'>(完成)</font>"
			} else {
				this.task_desc.innerHTML = _task_data.tips + "(<font color='#D15E00'>" + _task_data.now_num + "/" + _task_data.need_num + ")" + "</font>"
			}
		} else {
			this.gp_task.visible = false
		}
	}

	_gp_con: Laya.Box
	bg1: Laya.Image
	_gp_con0: Laya.Box
	nuqi: Laya.Label
	_Image11: Laya.Image
	_lb_anger: Laya.Label
	_Image2: Laya.Image
	_img_progress: Laya.Image
	_Group1: Laya.Box
	_rbtn_boss: Laya.Box
	_Image111: Laya.Image
	labelDisplay: Laya.Label
	_rbtn_damage: Laya.Box
	_Image1: Laya.Image
	labelDisplay1: Laya.Label
	_gp_boss: Laya.Box
	Content1: Laya.List
	_gp_damage: Laya.Box
	_lb_boss_name: Laya.Label
	_lb_boss_owner: Laya.Label
	_lb_boss_tips: Laya.Label
	Content: Laya.List
	gp_task: Laya.Box
	_img_task_bg: Laya.Image
	lblTaskTitle: Laya.Text
	task_desc: Laya.HTMLDivElement
	allFinish: Laya.Label
	_Group2: Laya.Box
	_img_pk_record: Laya.Image
	_pkrecord_red: Laya.Image
	_img_turn: Laya.Image
	_target_gp: Laya.Box
	_gp_exit: Laya.Box
	_Image3: Laya.Image
	_gp_con1: Laya.Box
	_img_bg0: Laya.Image
	_img_bg1: Laya.Image
	_lb_left_time: Laya.Label
	auction_gp: Laya.Box
	_Image4: Laya.Image
	effect_gp: Laya.Box
	_Image5: Laya.Image
	auction_lb: Laya.Label
	img_icon: Laya.Image
	_icon_red: Laya.Image
	_img_icon_desc_bg: Laya.Image
	_lb_icon_desc: Laya.Text
	public GetComponents() {
		[
			this._gp_con,
			this.bg1,
			this._gp_con0,
			this.nuqi,
			this._Image11,
			this._lb_anger,
			this._Image2,
			this._img_progress,
			this._Group1,
			this._rbtn_boss,
			this._Image111,
			this.labelDisplay,
			this._rbtn_damage,
			this._Image1,
			this.labelDisplay1,
			this._gp_boss,
			this.Content1,
			this._gp_damage,
			this._lb_boss_name,
			this._lb_boss_owner,
			this._lb_boss_tips,
			this.Content,
			this.gp_task,
			this._img_task_bg,
			this.lblTaskTitle,
			this.task_desc,
			this.allFinish,
			this._Group2,
			this._img_pk_record,
			this._pkrecord_red,
			this._img_turn,
			this._target_gp,
			this._gp_exit,
			this._Image3,
			this._gp_con1,
			this._img_bg0,
			this._img_bg1,
			this._lb_left_time,
			this.auction_gp,
			this._Image4,
			this.effect_gp,
			this._Image5,
			this.auction_lb,
			this.img_icon,
			this._icon_red,
			this._img_icon_desc_bg,
			this._lb_icon_desc,
		]
			= this.GetChildrenByNames([

				"_gp_con",
				"bg1",
				"_gp_con0",
				"nuqi",
				"_Image11",
				"_lb_anger",
				"_Image2",
				"_img_progress",
				"_Group1",
				"_rbtn_boss",
				"_Image111",
				"labelDisplay",
				"_rbtn_damage",
				"_Image1",
				"labelDisplay1",
				"_gp_boss",
				"Content1",
				"_gp_damage",
				"_lb_boss_name",
				"_lb_boss_owner",
				"_lb_boss_tips",
				"Content",
				"gp_task",
				"_img_task_bg",
				"lblTaskTitle",
				"task_desc",
				"allFinish",
				"_Group2",
				"_img_pk_record",
				"_pkrecord_red",
				"_img_turn",
				"_target_gp",
				"_gp_exit",
				"_Image3",
				"_gp_con1",
				"_img_bg0",
				"_img_bg1",
				"_lb_left_time",
				"auction_gp",
				"_Image4",
				"effect_gp",
				"_Image5",
				"auction_lb",
				"img_icon",
				"_icon_red",
				"_img_icon_desc_bg",
				"_lb_icon_desc",
			])
	}
}
window["KfHolyAreaSceneView"] = KfHolyAreaSceneView
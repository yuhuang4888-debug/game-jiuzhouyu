import { Alert, Alert_Type } from "../alert/Alert"
import { AutoFightManager } from "../autofight/AutoFightManager"
import { BossHelpRolePanel } from "../boss/BossHelpRolePanel"
import { BossTargetPanel } from "../boss/BossTargetPanel"
import { BossSuitExit } from "../bossSuit/BossSuitExit"
import { BaseView1, OpenMode } from "../common/BaseView1"
import { EventName, ObjectEventType, SceneEventType } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { MainUIManager } from "../common/MainUIManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { BossSceneManager } from "../commonController/BossSceneManager"
import { BossModel } from "../commonModel/BossModel"
import { GuildModel, GuildEvent } from "../commonModel/GuildModel"
import { MainUIModel } from "../commonModel/MainUIModel"
import { NineSkyModel } from "../commonModel/NineSkyModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Scene } from "../scene/Scene"
import { SceneBaseType } from "../scene/SceneConfig"
import { SceneManager } from "../scene/SceneManager"
import { FindVo } from "../scene/sceneobj/FindVo"
import { SceneObj } from "../scene/sceneobj/SceneObj"
import { Message } from "../sysInfo/SysInfoController"
import { ColorUtil, Enum_ColorUtil_Dark, Enum_ColorUtil_Light } from "../util/ColorUtil"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameMath } from "../util/GameMath"
import { TimeUtil } from "../util/TimeUtil"
import { Util, HtmlColorTxt, GlobalTimerQuest } from "../util/Util"
import { Vector2 } from "../util/Vector2"
import { BossDomainScenePanel } from "./BossDomainScenePanel"
import { Config } from "../common/Config"

export class BossDomainSceneView extends BaseView1 {
	InitEvent
	LoadSuccess
	Remove
	SetTagetPanelHid
	UpdateDouble
	UpdateShare
	auto_fight_mgr
	back_login_toClose
	belongVo
	blood_boss_id
	boss_scene_mgr
	close_callback
	destroy_imm
	isShare
	no_belong
	open_mode
	roleMove
	role_mgr
	save_boss_damage_dic
	setTargetList
	tagetPanelTimer
	_scene_mgr
	_taget_panel
	_help_role_panel
	scene


	public constructor() {
		super()

		this.base_file = "bossdomain"
		this.layout_file = "BossDomainSceneView"
		this.preload_server_config = {
			"config_decoration_boss": false,
			"config_boss_cfg": false
		}
		this.scene = Scene.GetInstance()
		this.layer_value = Enum_UILayer.Main
		this.open_mode = OpenMode.OpenToggle
		this.destroy_imm = true
		this.back_login_toClose = true
		let scene = Scene.GetInstance()
		let _show_panel = null
		let select_boss_id = 0
		let _help_click_time = null
		let time_speed = 250
		let _tagetPanelTimer = null
		let _model = BossModel.GetInstance()

		let local_BossModel = BossModel
		let local_Enum_ColorUtil_Dark = Enum_ColorUtil_Dark
		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName

		let local_SceneEventType = SceneEventType
		let local_TimeUtil = TimeUtil
		let mainUI_model = MainUIModel.GetInstance()
		let local_MainUIModel = MainUIModel.GetInstance()

		let help_mark = false
		let _adata = null
		let _show_help = null
		let isDouble = null
		let wait_time = 0
		this.auto_fight_mgr = AutoFightManager.GetInstance()
		this._scene_mgr = SceneManager.GetInstance()
		this.boss_scene_mgr = BossSceneManager.GetInstance()
		this.role_mgr = RoleManager.GetInstance()
		this.save_boss_damage_dic = []
		let main_role_vo = this.role_mgr.GetMainRoleVo()
		this.isShare = false
		this.load_callback = () => {
			this.display_obj.top = Util.GetLiuhaiHeight()
			this.display_obj.bottom = this.display_obj.left = this.display_obj.right = 0
			this.InitEvent()
			this.LoadSuccess()
			local_MainUIModel.Fire(MainUIModel.CHANGE_ACTIVITY_STATE, false)
			BossModel.GetInstance().SetMainUITeamVisible(false)
		}

		this.close_callback = () => {
			this.Remove()
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._gp_exit, () => {
				let fun = () => {
					_model.Fire(local_BossModel.SCMD_REQUEST, 47103)
				}


				let con
				if (_model.domain_boss_enter_type == 2) {
					let s1 = `是否确认退出当前场景，在当前场景${HtmlColorTxt("boss被击杀之前再次进入", local_Enum_ColorUtil_Dark.ORANGE)}`
					let s2 = `将不消耗${HtmlColorTxt("协助次数", local_Enum_ColorUtil_Dark.ORANGE)}`
					let s3 = `，协助${HtmlColorTxt("本服", local_Enum_ColorUtil_Dark.ORANGE)}玩家${HtmlColorTxt("获得归属奖励", local_Enum_ColorUtil_Dark.ORANGE)}`
					let s4 = `时可额外获得一份${HtmlColorTxt("协助奖励", local_Enum_ColorUtil_Dark.ORANGE)}`
					con = Util.StrToHTML(s1 + s2 + s3 + s4)
				} else {
					con = "退出当前场景时将可能不会获得任何奖励，是否继续退出?"
				}
				Alert.Show(con, Alert_Type.Two, fun, null, "确定", "取消")

			}
				, this, true)

			this.BindEvent(local_GlobalEventSystem, local_EventName.MAIN_ROLE_CHANGE_ATTACK_TARGRT, (target?) => {
				// if (!target) {
				// 	this.boss_scene_mgr.SetAttackTarget(null)
				// 	return
				// }
				// if (this.boss_scene_mgr.GetAttackTarget() == target) {
				// 	return
				// }
				// this.boss_scene_mgr.SetAttackTarget(target)
			}
			)

			//主角死亡清理目标
			this.BindEvent(GlobalEventSystem, EventName.SHOWRELIVEWINDOW, () => {
				this.boss_scene_mgr.SetAttackTarget(null)
			}
			)


			this.BindEvent(local_GlobalEventSystem, local_SceneEventType.CHARACTER_DEAD, (obj?) => {
				if (((this._scene_mgr.IsPickUpDropScene() && obj && obj.obj_type == SceneBaseType.Monster) &&
					this.boss_scene_mgr.GetAttackTarget()) &&
					obj == this.boss_scene_mgr.GetAttackTarget()) {
					this.boss_scene_mgr.SetAttackTarget(null)
				}
			}
			)

			this.BindEvent(local_GlobalEventSystem, local_SceneEventType.CANCEL_CLICK_TARGET, () => {
				if (this.boss_scene_mgr.GetAttackTarget()) {
					this.boss_scene_mgr.SetAttackTarget(null)
				}
				this.boss_scene_mgr.SetAutoState(false)
			}
			)


			
			//重登之后，等模型加载出来再寻路
			this.BindEvent(GlobalEventSystem, ObjectEventType.MAINROLE_MOVE_RES_LOAD_COMPLETE, () => {
				if(SceneManager.GetInstance().IsBossDoMainScene()){
					this.roleMove()
				}
			})

			this.BindEvent(GlobalEventSystem, EventName.LOADMAP_COMPLETE, () => {
				if(SceneManager.GetInstance().IsBossDoMainScene()){
					this.roleMove()
				}
			})


			Util.AddClickEvent(this._btn_help, () => {
				if (_help_click_time && local_TimeUtil.getClientTimeMs() - _help_click_time < 5000) {
					Message.show("冷却中...")
					return
				}
				_help_click_time = local_TimeUtil.getClientTimeMs()
				_model.Fire(local_BossModel.SCMD_REQUEST, 47111)
			}
				, this, true)

			this.BindEvent(_model, local_BossModel.DOMAINBOSS_EXIT_TIME, (time?) => {
				let left_time = time - local_TimeUtil.getServerTime()
				let bossSuitExitView = new BossSuitExit(left_time, "", "", null, true)
				bossSuitExitView.Open()
			}
			)

			this.BindEvent(local_GlobalEventSystem, NineSkyModel.NINE_SKY_FIGHTING_MSG, (attack_role_id?) => {
				this.boss_scene_mgr.SetSufferedList(attack_role_id)
			}
			)

			this.BindEvent(GuildModel.GetInstance(), GuildEvent.CANCEL_HELP_SUCCESS, (attack_role_id?) => {
				_adata = GuildModel.GetInstance().GetAssistData()
				this.tagetPanelTimer()
			}
			)
			this.BindEvent(GuildModel.GetInstance(), GuildEvent.HELP_SUCCESS, (attack_role_id?) => {
				_adata = GuildModel.GetInstance().GetAssistData()
				this.tagetPanelTimer()
			}
			)



			Util.AddClickEvent(this.gp_double, () => {
				if (isDouble) {
					Message.show("当前已使用双倍掉落卡")
				} else {
					local_GlobalEventSystem.Fire(EventName.OPEN_VIEW, "BossDomainDoubleView")
				}
			}, this, true)

			this.BindEvent(_model, BossModel.DOMAINBOSS_DATA_RETUEN, () => {
				this.UpdateDouble()
			}
			)

			Util.AddClickEvent(this.fightBtn, () => {
				if (!this.belongVo) {
					this.roleMove()
				} else {
					if (this.belongVo.role_id == this.role_mgr.GetMainRoleId()) {
						Message.show("无法攻击自己!")
					} else {
						let role = scene.GetRole(this.belongVo.role_id)
						if (role) {
							this.boss_scene_mgr.SetAttackTarget(role)
							scene.SetClickTarget(role)
							this.auto_fight_mgr.SetAutoFight(true)
						}
					}
				}
			}, this, true)


			// this.BindEvent(local_GlobalEventSystem, EventName.BOSS_OWNER_SHIP_CHANGE, (role_id?, boss_owner?) => {
			// 	this.UpdateShare()
			// })

		}

		this.Remove = () => {
			MainUIManager.GetInstance().RemoveMoveComponent(this)
			this.save_boss_damage_dic = []
			select_boss_id = 0
			_model.doMainSelectBossId = 0
			if (_tagetPanelTimer) {
				GlobalTimerQuest.CancelQuest(_tagetPanelTimer)
				_tagetPanelTimer = null
			}

			if (this._help_role_panel && !this._help_role_panel.use_delete_method) {
				this._help_role_panel.DeleteMe()
				this._help_role_panel = null
			}

			if (this._taget_panel && !this._taget_panel.use_delete_method) {
				this._taget_panel.DeleteMe()
				this._taget_panel = null
				//local_GlobalEventSystem:Fire(local_EventName.UPDATE_TEAM_INVITE_FLAG_POS, false)
			}

			if (_show_panel) {
				_show_panel.DeleteMe()
				_show_panel = null
			}

			_show_help = null
			this.no_belong = false
			this.belongVo = null
		}

		this.LoadSuccess = () => {
			select_boss_id = _model.doMainSelectBossId
			if (!_show_panel) {
				_show_panel = new BossDomainScenePanel(this._gp)
				_show_panel.Load()
			}
			if (!this._btn_help.visible) {
				_model.Fire(local_BossModel.SCMD_REQUEST, 47109)
			}
			this.roleMove()

			if (!this._taget_panel) {
				this._taget_panel = new BossTargetPanel(this._target_gp)
				this._taget_panel.Load()
			}
			this._taget_panel.ExcuteCallback(() => {
				this.setTargetList()
			}
			)

			_model.Fire(local_BossModel.SCMD_REQUEST, 47114)

			let bossCfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_decoration_boss", false)[select_boss_id]//Config.Decorationboss[select_boss_id]
			if (bossCfg) {
				this.isShare = bossCfg.boss_type != 1
			}

			this._help_role_panel = new BossHelpRolePanel(this._gp_help_role)
			this._help_role_panel.Load()
			this._help_role_panel.SetVisible(false)
			_adata = GuildModel.GetInstance().GetAssistData()
			_show_help = !this.isShare

			MainUIManager.GetInstance().AddMoveComponent(this, this._gp, false, MainUIManager.MOVE_TYPE.Left)
			MainUIManager.GetInstance().AddMoveComponent(this, this._gp_exit, false, MainUIManager.MOVE_TYPE.Left)
			MainUIManager.GetInstance().AddMoveComponent(this, this._target_gp, false, MainUIManager.MOVE_TYPE.Stay)
			MainUIManager.GetInstance().AddMoveComponent(this, this.gp_double, false, MainUIManager.MOVE_TYPE.Right)
			MainUIManager.GetInstance().AddMoveComponent(this, this.gp_gs, false, MainUIManager.MOVE_TYPE.Left)
			MainUIManager.GetInstance().AddMoveComponent(this, this._gp_help_role, false, MainUIManager.MOVE_TYPE.Right)
			this.UpdateDouble()
			this.UpdateShare()
		}

		this.UpdateDouble = () => {
			let data = _model.do_main_data
			let in_buff = data && data.in_buff > 0
			if (data && isDouble != in_buff) {
				isDouble = in_buff
				this.doubletext.color = isDouble && ColorUtil.GetReplaceChar(Enum_ColorUtil_Light.GREEN) || ColorUtil.GetReplaceChar(Enum_ColorUtil_Light.RED)
				this.doubletext.text = isDouble ? "[已使用]" : "[未使用]"
				//SetImageGray(this.Image1 , isDouble)
			}
		}

		this.UpdateShare = () => {

			//800秒的刷新限制
			// let curTimeMs=TimeUtil.getServerTimeMs()//new Date().getTime();
			// if((curTimeMs-wait_time)<600){
			// 	return;
			// }
			// wait_time=curTimeMs

			this.belongVo = null
			let main_role = this.scene.main_role
			if (main_role && main_role.GetVo().boss_flag == 1) {
				this.belongVo = main_role.GetVo()
			} else {
				let role_list = this.scene.role_list
				for (let _ in role_list) {
					var role = role_list[_]

					if (role && role.role_id != null && role.boss_flag == 1) {
						this.belongVo = role
						break
					} else {
						let v1 = role.GetVo()
						if (v1 && v1.boss_flag == 1) {
							this.belongVo = v1
							break
						}
					}

				}
			}





			this.gp_fight.visible = !this.isShare
			this.share_tips.visible = this.isShare
			if (this.gp_fight.visible) {
				this.Text.text = !this.belongVo && "攻击首领" || "当前归属者"
				let desc = ""
				if (!this.belongVo) {
					desc = "暂无"
				} else {
					let is_mask = this.belongVo.mask_id > 0
					if (is_mask) {
						if (this.belongVo.role_id == RoleManager.GetInstance().GetMainRoleId()) {
							desc = "蒙面人(自己)"
						} else {
							desc = "蒙面人"
						}

					} else {
						desc = `S${this.belongVo.server_id}.${this.belongVo.name}`
					}
				}
				this.name.text = desc
			}
		}



		this.roleMove = () => {

			//重连后寻找boss
			if(_model.doMainSelectBossId==0){
				let monster_list = scene.FindTargets(Scene.FIND_TARGET_TYPE.monster, 1, null, 800, null, null, null)[0]
				let monster = monster_list[0]
				let boss = null
				if (monster) {
					boss = monster.GetVo()
				}

				if(boss&&boss.type_id){
					_model.doMainSelectBossId=boss.type_id
				}
			}
			
			let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_decoration_boss", false)//Config.Decorationboss
			let boss_cfg = cfg[_model.doMainSelectBossId]
			if (boss_cfg) {

				this.auto_fight_mgr.SetAutoFight(false)
				this.boss_scene_mgr.SetAutoState(false)


				let real_x = boss_cfg.x / SceneObj.GetLogicRealRatio().x
				let real_y = boss_cfg.y / SceneObj.GetLogicRealRatio().y
				let findVo = new FindVo()
				findVo.type = FindVo.MONSTER
				findVo.sceneId = this._scene_mgr.GetSceneId()
				findVo.id = _model.doMainSelectBossId
				findVo.x = real_x
				findVo.y = real_y
				findVo.range = 5
				// findVo.call_back=()=>{
				// 	let monster = Scene.GetInstance().GetMonsterByTypeId(findVo.id)
				// 	this.boss_scene_mgr.SetAttackTarget(monster)
				// 	this.auto_fight_mgr.SetAutoFight(true)
				// 	this.boss_scene_mgr.SetAutoState(true)
				// }
				// scene.FindElement(findVo)


				let call_fun = () => {
					let monster = Scene.GetInstance().GetMonsterByTypeId(findVo.id)
					this.boss_scene_mgr.SetAttackTarget(monster)
					this.auto_fight_mgr.SetAutoFight(true)
					this.boss_scene_mgr.SetAutoState(true)
				}

				Scene.GetInstance().MainRoleMove(findVo, 0, call_fun)
			}

		}

		this.setTargetList = () => {
			if (!_tagetPanelTimer) {
				_tagetPanelTimer = GlobalTimerQuest.AddPeriodQuest(() => {
					this.tagetPanelTimer()
				}, time_speed / 1000)
			}

		}

		this.tagetPanelTimer = () => {

			let monster_list = []
			this.boss_scene_mgr.select_boss_id = select_boss_id
			monster_list = scene.FindTargets(Scene.FIND_TARGET_TYPE.monster, 1, null, 800, null, null, null)[0]
			let role_list = this.boss_scene_mgr.GetSortSecneRoleList()
			let monster = monster_list[0]
			let boss = null
			if (monster) {
				boss = monster.GetVo()
			}
			if (boss && select_boss_id == 0) {

				select_boss_id = boss.type_id
				let bossCfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_decoration_boss", false)[select_boss_id]//Config.Decorationboss[select_boss_id]
				if (bossCfg) {
					this.isShare = bossCfg.boss_type != 1
				}
				this.UpdateDouble()

			}
			this.UpdateShare()

			if (_show_help && !_adata) {
				if (boss && !help_mark) {
					help_mark = true
					_show_panel.SetBossData(boss)
					_show_panel.SetHelpStatus(true)
				} else if (!boss && help_mark) {
					help_mark = false
					_show_panel.SetBossData(null)
					_show_panel.SetHelpStatus(false)
				}
			}

			let cur_boss = null
			let vo = null
			let list = []
			if (select_boss_id > 0) {
				cur_boss = Scene.GetInstance().GetMonsterByTypeId(select_boss_id)
				vo = _model.DoMainBossInfo(select_boss_id)
			}

			this.boss_scene_mgr.JudgeTarget(role_list)
			list = monster_list.concat(role_list)
			let main_role_vo = this.role_mgr.GetMainRoleVo()
			let distance = (cur_boss && scene.main_role) && GameMath.GetDistance(main_role_vo.pos_x, main_role_vo.pos_y, cur_boss.x, cur_boss.y) || null
			let range = 400
			if (boss && distance && distance <= range * range) {
				if (!this.save_boss_damage_dic[boss.type_id]) {
					this.save_boss_damage_dic[boss.type_id] = true
					this.boss_scene_mgr.SetDamageBossInstanceId(boss.instance_id)
					UserMsgAdapter.GetInstance().SendAllFmtToGame(12043, "i", boss.instance_id)
					UserMsgAdapter.GetInstance().SendAllFmtToGame(12025, "i", boss.instance_id)
				}

				this.blood_boss_id = boss.type_id
				let config = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_mon.name, this.blood_boss_id, false)
				if (!mainUI_model.big_blood_in_show) {
					GlobalEventSystem.Fire(EventName.SHOW_HITER_BIG_BLOOD_VIEW, true, boss, config.hp_num, false)
				}

			} else {
				if (vo && this.save_boss_damage_dic[vo.boss_id]) {
					this.save_boss_damage_dic[vo.boss_id] = false
					this.boss_scene_mgr.SetDamageBossInstanceId(null)
				}
				if (mainUI_model.big_blood_in_show) {
					GlobalEventSystem.Fire(EventName.SHOW_HITER_BIG_BLOOD_VIEW, false)
				}

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
				this._taget_panel.SetData(list)
				this.SetTagetPanelHid(true)

			} else {
				this._taget_panel.SetData([])
				this.SetTagetPanelHid(false)
			}


		}

		this.SetTagetPanelHid = (bool?) => {
			if (this._target_gp) {
				this._target_gp.visible = bool
			}
		}

	}



	_target_gp: Laya.Box
	_gp_exit: Laya.Box
	_exit: Laya.Image
	_gp: Laya.Box
	_btn_help: Laya.Image
	_gp_help_role: Laya.Box
	gp_double: Laya.Box
	Image1: Laya.Image
	doubletext: Laya.Label
	gp_gs: Laya.Box
	Image: Laya.Image
	Text: Laya.Label
	gp_fight: Laya.Box
	name: Laya.Label
	fightBtn: Laya.Box
	_Image11: Laya.Image
	labelDisplay1: Laya.Label
	share_tips: Laya.Label
	public GetComponents() {
		[
			this._target_gp,
			this._gp_exit,
			this._exit,
			this._gp,
			this._btn_help,
			this._gp_help_role,
			this.gp_double,
			this.Image1,
			this.doubletext,
			this.gp_gs,
			this.Image,
			this.Text,
			this.gp_fight,
			this.name,
			this.fightBtn,
			this._Image11,
			this.labelDisplay1,
			this.share_tips,
		]
			= this.GetChildrenByNames([

				"_target_gp",
				"_gp_exit",
				"_exit",
				"_gp",
				"_btn_help",
				"_gp_help_role",
				"gp_double",
				"Image1",
				"doubletext",
				"gp_gs",
				"Image",
				"Text",
				"gp_fight",
				"name",
				"fightBtn",
				"_Image11",
				"labelDisplay1",
				"share_tips",
			])
	}
}
window["BossDomainSceneView"] = BossDomainSceneView
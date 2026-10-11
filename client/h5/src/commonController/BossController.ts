import { Alert, Alert_Type } from "../alert/Alert"
import { AutoFightManager } from "../autofight/AutoFightManager"
import { BaseController } from "../common/BaseController"
import { CommonManager } from "../common/CommonManager"
import { Config } from "../common/Config"
import { EventName, SceneEventType } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { BaseDungeonModel, DUN_TYPE } from "../commonModel/BaseDungeonModel"
import { BossModel } from "../commonModel/BossModel"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { MainUIModel } from "../commonModel/MainUIModel"
import { ShopEvent, ShopModel, ShopType } from "../commonModel/ShopModel"
import { TaskModel, TaskTipType, TaskType } from "../commonModel/TaskModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Scene } from "../scene/Scene"
import { SceneManager } from "../scene/SceneManager"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { Message } from "../sysInfo/SysInfoController"
import { ColorType, ColorUtil } from "../util/ColorUtil"
import { GlobalEventSystem, LOAD_QUEUE } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest, Util } from "../util/Util"
import { BossSceneEvent, BossSceneManager } from "./BossSceneManager"
import { MainUIController } from "./MainUIController"

import "../boss/ImportBoss"
import "../bossField/ImportBossField"

import "../boss/BossHelpPanel"
import "../boss/BossHelpRolePanel"
import "../boss/BossHelpItem"
import "../baseEnterView/CrossServerEnterView"
import "../bossMystery/BossMysteryRewardView"
import "../bossDomain/BossDomainBuyView"
import "../bossDomain/BossDomainDoubleView"
import "../bossDomain/BossDomainHelpAlert"
import "../bossDomain/BossDomainItem"
import "../bossDomain/BossDomainResultView"
import "../bossDomain/BossDomainRewardItem"
import "../bossDomain/BossDomainScenePanel"
import "../bossDomain/BossDomainSceneView"
import "../bossDomain/BossDomainView"
import "../bossField/BossFieldTiredNewView"
import "../bossField/BossFieldVitBuyView"
import "../boss/BossRebornTipsView"
import { ReliveModel } from "../commonModel/ReliveModel"
import { VipModel } from "../commonModel/VipModel"
import { FightManager } from "../scene/fight/FightManager"

export let CrossServerViewIndex = {
	Eudaemon_Ridge_Boss: 0,
	Domain_Boss: 1,
	Mystery_Boss: 2,
	ENTERNITY: 3,
	TSCrack: 4,
	SentientAct: 5,
	GhostWalk: 6,
}

export class BossController extends BaseController {
	boss_abyss_failure_view
	boss_domain_result_view
	boss_drop_record_view
	boss_enter_view
	boss_field_result_view
	boss_fight_scene_view
	boss_relive_tried_view
	boss_tips_view
	boss_tired_alert
	kill_record_view
	mystert_boss_reward_view
	boss_rebron_tips_view
	vit_view
	reborn_tips_view

	view_dic = {}

	boss_scene_mgr: BossSceneManager
	role_mgr: RoleManager
	boss_model: BossModel
	goods_model: GoodsModel
	scene_mgr: SceneManager
	task_model: TaskModel
	scene: Scene
	fight_mgr:FightManager
	auto_fight_mgr: AutoFightManager
	user_msg_adapter: UserMsgAdapter
	mainui_model: MainUIModel
	res_mgr: ResManager

	delay_timer
	reborn_tip_boss_id

	public constructor() {
		super()
		this.boss_scene_mgr = BossSceneManager.GetInstance()
		this.role_mgr = RoleManager.GetInstance()
		this.boss_model = BossModel.GetInstance()
		this.goods_model = GoodsModel.GetInstance()
		this.scene_mgr = SceneManager.GetInstance()
		this.task_model = TaskModel.GetInstance()
		this.scene = Scene.GetInstance()
		this.auto_fight_mgr = AutoFightManager.GetInstance()
		this.user_msg_adapter = UserMsgAdapter.GetInstance()
		this.mainui_model = MainUIModel.GetInstance()
		this.res_mgr = ResManager.GetInstance()
		this.fight_mgr = FightManager.GetInstance()


		this.InitEvent()
		this.RegisterAllProtocals()
	}


	public InitEvent() {
		GlobalEventSystem.Bind(
			EventName.GAME_START, () => {
				this.boss_model.init_field_infinite_proto_state = undefined
				this.boss_model.edu_login_red = true
				this.boss_model.boss_abyss_red_state_ = false
				this.boss_model.is_receview_base = false
				this.boss_model.domain_unfollow_dic = {}
				this.boss_model.eudaemon_has_click = false
				this.boss_model.feast_boss_scene_can_not_collect_mon_id = null

				let cfg = Config.PRELOAD_SERVER_CONFIG.config_boss_type
				let level = this.role_mgr.mainRoleInfo.level
				for (let key in BossModel.BossType) {
					let type = BossModel.BossType[key]
					if (this.boss_model.IsCrossServerBoss(type)) {
					} else {
						let [need_lv, _] = this.boss_model.GetBossTypeCondition(type, cfg)
						if (need_lv && level >= need_lv) {
							this.boss_model.Fire(BossModel.SCMD_REQUEST, 46000, type)
							//秘境boss 阶段奖励
							if (type == BossModel.BossType.mystery) {
								this.boss_model.Fire(BossModel.SCMD_REQUEST, 46037)
							}
						}
					}
				}


				this.boss_model.Fire(BossModel.SCMD_REQUEST, 46034)
				this.boss_model.Fire(BossModel.SCMD_REQUEST, 47101)
				this.boss_model.Fire(BossModel.SCMD_REQUEST, 47105)
				this.boss_model.Fire(BossModel.SCMD_REQUEST, 47000, BossModel.BossType.holy- BossModel.cross_boss_base_index)
			}
		)
		GlobalEventSystem.Bind(
			GoodsModel.USE_BAG_GOODS_SUCCESS, (type_id?) => {
				if (type_id != BossModel.tired_goods_id) {
					return
				}
				this.boss_model.Fire(BossModel.SCMD_REQUEST, 46000, BossModel.BossType.field)
				this.boss_model.Fire(BossModel.SCMD_REQUEST, 46000, BossModel.BossType.field_infinite)
			}
		)
		GlobalEventSystem.Bind(
			SceneManager.START, () => {
				this.ChangeScene()
			}
		)
		GlobalEventSystem.Bind(
			ServerTimeModel.HOUR_REFRESH, (hour?) => {
				if (hour == 4) {
					this.boss_model.Fire(BossModel.SCMD_REQUEST, 46000, BossModel.BossType.suit)
					this.boss_model.Fire(BossModel.SCMD_REQUEST, 46000, BossModel.BossType.abyss)
					this.boss_model.Fire(BossModel.SCMD_REQUEST, 46000, BossModel.BossType.field)
					this.boss_model.Fire(BossModel.SCMD_REQUEST, 46000, BossModel.BossType.field_infinite)
					this.boss_model.Fire(BossModel.SCMD_REQUEST, 46000, BossModel.BossType.fieldspecial)
					this.boss_model.Fire(BossModel.SCMD_REQUEST, 47000, BossModel.BossType.holy - BossModel.cross_boss_base_index)
					this.boss_model.Fire(BaseDungeonModel.SCMD_REQUEST, 61020, DUN_TYPE.Vip_Rerson_Boss)
				}
			}
		)

		GlobalEventSystem.Bind(
			EventName.OPEN_WEEKEND_ACTIVITY_VIEW, (view_name, ...new_args) => {
				let view = this.view_dic[view_name]
				if (!view) {
					let view_class: any = window[view_name]
					if (!view_class) return
					view = new view_class()
					this.view_dic[view_name] = view
				}
				if (view.HasOpen()) {
					view.Close()
				} else {
					view.Open(...new_args)
				}
			}
		)
		
		GlobalEventSystem.Bind(EventName.SERVER_CANCEL_TO_COLLECT, (flag, type_id, ins_id) => {
				if (this.scene_mgr.IsFeastBossScene() && (flag == 13 || flag == 7)) {
					this.boss_model.AddCanNotCollectMon(ins_id)
				}
			}
		)

		let complete_fun = (ins_id?) => {
			if (this.scene_mgr.IsFeastBossScene()) {
				this.boss_model.DeleteNotCollectMon(ins_id)
			}
		}

		let add_complete_fun = (ins_id?) => {
			complete_fun(ins_id)

			if (this.scene_mgr.IsFeastBossScene()) {
				if (this.boss_model.NeedHideBoxList(ins_id)) {
					// 延迟删除(下一帧即可)
					GlobalTimerQuest.AddDelayQuest(() => {
						this.scene_mgr.DeleteMonsterVo(ins_id)
					}, 0.05)
				}
			}
		}

		GlobalEventSystem.Bind(SceneEventType.MONSTER_VO_REMOVE, complete_fun)
		GlobalEventSystem.Bind(SceneEventType.MONSTER_VO_ADD, add_complete_fun)

		GlobalEventSystem.Bind(EventName.CHANGE_ACCOUNT, () => {
			this.boss_model.is_receview_base = false
		});

		GlobalEventSystem.Bind(EventName.CHANGE_ROLE, () => {
			this.boss_model.is_receview_base = false
		});



		GlobalEventSystem.Bind(
			EventName.UPDATE_NEWEST_TASK_ID, () => {
				let newest_finish_task_id = this.task_model.newest_finish_task_id
				let cfg = Config.PRELOAD_CLIENT_CONFIG.ConfigFuncOpenCondition
				let friend_cfg = cfg["BossFieldEnterView"]
				if (friend_cfg && friend_cfg.open_task == newest_finish_task_id) {
					this.boss_model.RefreshFieldBossRed()
				}
				let cfg2 = Config.PRELOAD_SERVER_CONFIG.config_boss_type
				this.boss_model.RefreshSuitRed(cfg2)

				if (this.boss_model.GuideTaskDone() && !this.boss_model.init_field_infinite_proto_state) {
					this.boss_model.init_field_infinite_proto_state = true
					this.boss_model.Fire(BossModel.SCMD_REQUEST, 46000, BossModel.BossType.field)
					this.boss_model.Fire(BossModel.SCMD_REQUEST, 46000, BossModel.BossType.field_infinite)

				}
			}
		)

		this.role_mgr.GetMainRoleVo().Bind(
			EventName.CHANGE_LEVEL, (level?) => {
				if (BossModel.Field_Refresh_Red_Level == level) {
					this.boss_model.RefreshFieldBossRed()
				}
				let cfg1 = Config.PRELOAD_SERVER_CONFIG.config_boss_type
				this.boss_model.RefreshSuitRed(cfg1)

				let cfg = Config.PRELOAD_SERVER_CONFIG.config_domain_kill_reward
				this.boss_model.RefreshMysteryBossRedDot(cfg)

				BossModel.GetInstance().AutoRemainBossAbyss()

				GlobalEventSystem.Fire(EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 6210)
			}
		)
		this.goods_model.Bind(
			GoodsModel.CHANGE_BAG_LIST, () => {
				let cfg = Config.PRELOAD_SERVER_CONFIG.config_domain_kill_reward
				this.boss_model.RefreshMysteryBossRedDot(cfg)
			}
		)
		this.boss_model.Bind(
			BossModel.SCMD_REQUEST, (cmd, ...new_args) => {
				let args = new_args

				if(cmd==47000&&!CommonManager.GetInstance().CheckFuncOpenState("EudaemonEnterView",true))return
				switch (cmd) {
					case 47000:
					case 46000:
					case 47004:
					case 46043:
					case 46044:
						this.SendFmtToGame(cmd, "c", args[0])
						break
					case 46045:
						this.SendFmtToGame(cmd, "ch", args[0], args[1], args[2])
						break;
					case 46046:
						this.SendFmtToGame(cmd, "h", args[0])
						break;
					case 46004:
						this.boss_model.exit_call_back = args[1]
						this.SendFmtToGame(cmd, "c", args[0])
						break
					case 46001:
					case 46003:
					case 47001:
					case 47003:
					case 46041:
					case 47035:
						this.SendFmtToGame(cmd, "ci", args[0], args[1])
						break
					case 46007:
						let auto_state = args[3] ? args[3] : 0
						this.SendFmtToGame(cmd, "cicc", args[0], args[1], args[2], auto_state)
						break
					case 47005:
						this.SendFmtToGame(cmd, "cic", args[0], args[1], args[2])
						break
					case 46032:
					case 47102:
					case 47106:
						this.SendFmtToGame(cmd, "ic", args[0], args[1])
						break
					case 46038:
					case 20202:
					case 20205:
						this.SendFmtToGame(cmd, "i", args[0])
						break
					default:
						this.SendFmtToGame(cmd)
				}
			}
		)

		this.boss_model.Bind(
			EventName.OPEN_BOSS_SCENE_VIEW, (show?, boss_type?) => {
				let close_func = () => {
					if (this.boss_fight_scene_view) {
						this.boss_fight_scene_view.Close()
						this.boss_fight_scene_view = null
					}
				}

				if (show) {
					let class_name = null
					switch (boss_type) {
						case BossModel.BossType.suit:
						case BossModel.BossType.eudaemon:
						case BossModel.BossType.holy:
						case BossModel.BossType.field:
						case BossModel.BossType.fieldspecial:
						case BossModel.BossType.field_infinite:
						case BossModel.BossType.abyss:
						case BossModel.BossType.holyterritory:
						case BossModel.BossType.mystery:
						case BossModel.BossType.holy_wuxian:
							class_name = "BossFightSceneView"
							break
						case BossModel.BossType.feast:
							this.boss_model.feast_boss_scene_can_not_collect_mon_id = null
							class_name = "FeastBossSceneView"
							break
						case BossModel.BossType.domain:
							class_name = "BossDomainSceneView"
							break
					}

					if (class_name && this.boss_fight_scene_view) {
						close_func()
					}
					if (!this.boss_fight_scene_view) {
						let view_class: any = window[class_name]
						this.boss_fight_scene_view = new view_class()
					}
					this.boss_fight_scene_view.Open()
				} else {
					close_func()
				}
			}
		)



		this.boss_model.Bind(
			BossModel.OPEN_BOSS_RESULT_VIEW, (result_data?) => {
				// if (!window["BossFieldResultView"]) {
				// 	if (!ResManager.GetInstance().IsJsLoad("boss")) {
				// 	}
				// }
				// if (!this.boss_field_result_view) {
				// 	this.boss_field_result_view = window["BossFieldResultView"].New()
				// }
				// if (!this.boss_field_result_view.HasOpen()) {
				// 	this.boss_field_result_view.SetResultData(result_data)
				// 	this.boss_field_result_view.Open()
				// }
			}
		)
		this.boss_model.Bind(
			BossModel.OPEN_TIPS_VIEW, (boss_id?) => {
				return
				if (!this.boss_tips_view) {
					this.boss_tips_view = window["BossTipsView"].New()
				}
				this.boss_tips_view.SetData(boss_id)
				this.boss_tips_view.Open()
			}
		)
		this.boss_model.Bind(
			BossModel.OPEN_ABYSS_FAILURE_VIEW, (data?) => {
				if (!this.boss_abyss_failure_view) {
					this.boss_abyss_failure_view = window["BossAbyssFailureView"].New()
				}
				this.boss_abyss_failure_view.SetData(data)
				if (!this.boss_abyss_failure_view.HasOpen()) {
					this.boss_abyss_failure_view.Open()
				}
			}
		)
		this.boss_model.Bind(
			BossModel.OPEN_DROP_RECORD_VIEW, (parms?) => {
				let view_class = window["BossDropRecordView"]
				if (!view_class) return
				if (!this.boss_drop_record_view) {
					this.boss_drop_record_view = new view_class()
				}
				this.boss_drop_record_view.Open(parms)
			}
		)
		this.boss_model.Bind(
			BossModel.OPEN_MYSTERY_BOSS_REWARD_VIEW, () => {
				let view_class = window["BossMysteryRewardView"]
				if (!view_class) return
				if (!this.mystert_boss_reward_view) {
					this.mystert_boss_reward_view = new view_class()
				}
				this.mystert_boss_reward_view.Open()
			}
		)
		this.boss_model.Bind(
			BossModel.OPEN_RELIVE_TRIED_VIEW, () => {
				if (!window["BossReliveTriedView"]) {
					if (!ResManager.GetInstance().IsJsLoad("boss")) {
					}
				}
				if (!this.boss_relive_tried_view) {
					this.boss_relive_tried_view = window["BossReliveTriedView"].New()
				}
				this.boss_relive_tried_view.Open()
			}
		)
		this.boss_model.Bind(
			BossModel.OPEN_KILL_RECORD_VIEW, () => {
				let view_class = window["KillRecordView"]
				if (!view_class) return
				if (!this.kill_record_view) {
					this.kill_record_view = new view_class()
				}
				this.kill_record_view.Open()
			}
		)
		this.boss_model.Bind(
			BossModel.OPEN_BOSS_TIRED_ALERT, (tired?) => {
				let view_class = window["BossFieldTiredNewView"]
				if (!view_class) return
				if (!this.boss_tired_alert) {
					this.boss_tired_alert = new view_class()
				}
				if (!this.boss_tired_alert.HasOpen()) {
					this.boss_tired_alert.Open(tired)
				}
			}
		)
		this.task_model.Bind(
			TaskModel.UPDATE_CIRCLE_TASK_PROGRESS, () => {
				let euda_task = this.task_model.circle_task_progress_data[TaskType.EUDAEMON_TASK]
				this.boss_model.red_list[0] = euda_task && euda_task.finish_num < euda_task.all_num
				this.boss_model.Fire(BossModel.UPDATE_EUDAEMON_RED)
				GlobalEventSystem.Fire(EventName.REFRESH_ACTIVITY_ICON_RED_DOT, "6210")
			}
		)
		this.task_model.Bind(
			TaskModel.UPDATE_ONE_TASK, (task_id?, taskList?) => {
				if (this.scene_mgr.IsHolyBossScene()) {
					for (let _tmpi in taskList) {
						let vo = taskList[_tmpi]
						if (vo.task_tips_type == TaskTipType.Collect || vo.task_tips_type == TaskTipType.Item) {
							if (task_id == CommonManager.GetInstance().GetValue(4700006)) {
								this.boss_model.Fire(BossModel.COLLECT_BOX, BossModel.CRYSTAL_TYPE)
							} else {
								this.task_model.DoTask(vo)
							}
							if (vo.task_tips_type == TaskTipType.Item) {
								let goods_vo = this.goods_model.GetGoodsBasicByTypeId(vo.id)
								if (goods_vo) {
									goods_vo["drop_num"] = 1
									Message.showGoods(goods_vo)
								}
							} else {
								this.res_mgr.GetGameConfigWithAutoDestory("config_eudemons_boss_cfg", (cfgs) => {
									let monsterCfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_eudemons_boss_cfg.name, vo.id, false, cfgs)
									if (monsterCfg) {
										let goodsList = JSON.parse(monsterCfg.goods)
										if (goodsList && goodsList[0]) {
											let goods_vo = this.goods_model.GetGoodsBasicByTypeId(goodsList[0][1])
											if (goods_vo) {
												goods_vo["drop_num"] = goodsList[0][2]
												Message.showGoods(goods_vo)
											}
										}
									}
								}, false)
							}
							break
						}
					}
				}
			}
		)

		GlobalEventSystem.Bind(EventName.BROADCAST_COLLECT_RESULT, (flag?, monster_type_id?, monster_ins_id?) => {
				if (flag == 13 && this.scene_mgr.IsHolyBossScene()) {
					this.SendFmtToGame(20025, "ii", monster_ins_id, monster_type_id)
					for (let key in this.scene_mgr.monster_vo_list) {
						let v = this.scene_mgr.monster_vo_list[key]
						if (v.type_id == monster_type_id && v.instance_id != monster_ins_id) {
							this.scene.SetClickTarget(this.scene.GetMonster(v.instance_id))
							this.auto_fight_mgr.SetAutoFight(true)
							break
						}
					}
				}
			}
		)


		let main_role_move_end = () => {
			clearTimeout(this.delay_timer)
			this.delay_timer = null


			if (this.scene_mgr.main_role_last_enter_stand_time) {
				let delay_time = null
				if (this.scene_mgr.IsHolyBossScene()) {
					delay_time = 15
				}
				if (delay_time) {
					this.delay_timer = setTimeout(() => {
						this.auto_fight_mgr.SetAutoFight(true)
					},
						delay_time
					)
				}
			}
		}
		this.scene_mgr.BindOne("main_role_last_enter_stand_time", main_role_move_end)


		// let open_vit_view = (x?, y?) => {
		// 	let view_class = window["BossFieldVitView"]
		// 	if (!view_class) return
		// 	if (!this.vit_view) {
		// 		this.vit_view = new view_class()
		// 	}

		// 	if (this.vit_view) {
		// 		if (this.vit_view.HasOpen()) {
		// 			this.vit_view.Close()
		// 		} else {
		// 			this.vit_view.SetData(x, y)
		// 			this.vit_view.Open()
		// 		}
		// 	}
		// }
		// this.boss_model.Bind(BossModel.OPEN_VIT_VIEW, open_vit_view)

		ShopModel.GetInstance().Bind(ShopEvent.UPDATE_SHOP_DATA, (type?) => {
			if (type && type == ShopType.SoulOfWar) {
				this.boss_model.RefreshFieldBossRed()
			}

		}
		)
		this.boss_model.Bind(BossModel.OPEN_REBORN_TIPS_VIEW, (reborn_info?, icon?) => {

			//幻饰boss
			if (reborn_info.boss_type == BossModel.BossType.domain
				&& !this.boss_model.IsDomainBossHasTimesCanBuy()
				&& !this.boss_model.IsDomainBossHasTimesCanChallenge()) {
				return
			}

			let view_class = window["BossRebornTipsView"]
			if (!view_class) return
			if (!this.reborn_tips_view) {
				this.reborn_tips_view = new view_class()
				this.reborn_tips_view.SetRebornInfo(reborn_info)
				this.boss_model.reborn_tip_dir[reborn_info.boss_id] = true
				this.reborn_tip_boss_id = reborn_info.boss_id
				this.reborn_tips_view.Open()
			}
			else
				if (!this.boss_model.reborn_tip_dir[reborn_info.boss_id]) {
					this.boss_model.reborn_tip_info.push(reborn_info)
					this.boss_model.reborn_tip_dir[reborn_info.boss_id] = true
				}

		})
		this.boss_model.Bind(BossModel.CLOSE_REBORN_TIPS_VIEW, () => {
			if (this.reborn_tips_view) {
				if (this.reborn_tips_view.HasOpen()) {
					this.reborn_tips_view.Close()
					this.reborn_tips_view = null
					this.boss_model.reborn_tip_dir[this.reborn_tip_boss_id] = false
					this.reborn_tip_boss_id = null
				}
				if (this.boss_model.reborn_tip_info && Util.TableSize(this.boss_model.reborn_tip_info) > 0) {
					let info = this.boss_model.reborn_tip_info[this.boss_model.reborn_tip_info.length - 1]
					this.boss_model.Fire(BossModel.OPEN_REBORN_TIPS_VIEW, info)
					this.boss_model.reborn_tip_info.pop()
				}
			}

		})


		let local_RoleManager_Instance = RoleManager.GetInstance()
		local_RoleManager_Instance.GetMainRoleVo().BindOne(
			"vip_flag", (event_name?, value?, old_value?) => {
				//触发自动关注
				BossModel.GetInstance().AutoRemainBossAbyss()
			}
		)

		let stop_auto_fun = (auto_fight_state) =>{
			if(this.scene_mgr.IsFeastBossScene() && !auto_fight_state){
				//每次取消自动挂机,清理不可采集目标列表
				this.boss_model.ClearNotCollectMon()
			}	
		}
		GlobalEventSystem.Bind(EventName.UPDATE_AUTO_FIGHT_STATE, stop_auto_fun)
	}

	public RegisterAllProtocals() {
		/*
		采集信息
		*/
		//查询采集怪当前的采集对象
		let On20025 = () => {
			let roleList = []
			let len = this.ReadFmt("h")
			let i = 0
			do {
				table.insert(roleList, this.ReadFmt("l"))
				i = i + 1
			} while ((i < len)
			)
			if (roleList[0] && this.scene_mgr.IsHolyBossScene()) {
				let roleVo = this.scene_mgr.GetRoleVo(roleList[0])
				if (this.scene_mgr.IsCanAttackByMainRole(roleVo)) {
					this.boss_model.AttckRole(roleList[0])
				}
			}
		}
		this.RegisterProtocal(20025, On20025)

		//玩家采集被打断,通知玩家打断者的id
		let On20026 = () => {
			let role = this.ReadFmt("l")
			if (role && this.scene_mgr.IsHolyBossScene()) {
				let roleVo = this.scene_mgr.GetRoleVo(role)
				if (roleVo && this.scene_mgr.IsCanAttackByMainRole(roleVo)) {
					this.boss_model.AttckRole(role)
				}
			}
			Message.show("采集中断")
		}
		this.RegisterProtocal(20026, On20026)

		/*
		本服Boss
		*/
		//BOSS列表信息
		let On46000 = () => {
			let vo = this.user_msg_adapter.GetSCMD(46000)
			// console.warn("------On46000------", vo.boss_type, vo.boss_info.length)
			let boss_cfg, boss_type_cfgs, kill_cfg
			boss_type_cfgs = Config.PRELOAD_SERVER_CONFIG.config_boss_type
			kill_cfg = Config.PRELOAD_SERVER_CONFIG.config_domain_kill_reward
			let call_back = () => {
				if (boss_cfg && boss_type_cfgs && kill_cfg) {
					this.boss_model.SetBossInfo(vo, null, boss_cfg, boss_type_cfgs)
					this.boss_model.Fire(BossModel.UPDATE_BOSS_INFO, vo.boss_type)

					switch (vo.boss_type) {
						case BossModel.BossType.field:
							this.boss_model.RefreshFieldBossRed()
							break
						case BossModel.BossType.field_infinite:
							this.boss_model.RefreshFieldBossRed()
							break
						case BossModel.BossType.suit:
							this.boss_model.Fire(BossModel.SCMD_REQUEST, 46005, vo.boss_type)
							this.boss_model.RefreshSuitRed(boss_type_cfgs)
							break
						case BossModel.BossType.mystery:
							this.boss_model.RefreshMysteryBossRedDot(kill_cfg)
							break
						case BossModel.BossType.abyss:
							this.boss_model.is_receview_base = true
							this.boss_model.UpdateBossAbyssRed()
							this.boss_model.AutoRemainBossAbyss()
							break;
					}

					this.res_mgr.DestoryGameConfig(this.boss_model, "config_boss_cfg", false)
				}
			}

			this.res_mgr.LoadGameConfig(this.boss_model, "config_boss_cfg", false, LOAD_QUEUE.MIDDLE, (cfg) => {
				boss_cfg = cfg
				call_back()
			})
		}
		this.RegisterProtocal(46000, On46000)

		//BOSS掉落记录
		let On46002 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(46002)
			this.boss_model.SetDropRecordData(scmd)
			this.boss_model.Fire(BossModel.UPDATE_MON_POS)
		}
		this.RegisterProtocal(46002, On46002)

		//进入本服BOSS
		let On46003 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(46003)
			if (scmd.code != 1) {
				Util.ErrorCodeShow(scmd.code)
			}
		}
		this.RegisterProtocal(46003, On46003)

		//退出本服BOSS
		let On46004 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(46004)
			if (this.boss_model.exit_call_back) {
				this.boss_model.exit_call_back()
				this.boss_model.exit_call_back = null
			}
			if (scmd.code != 1) {
				Util.ErrorCodeShow(scmd.code)
			}
		}
		this.RegisterProtocal(46004, On46004)

		//蛮荒禁地BOSS怒气
		let On46005 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(46005)
			let anger = scmd.anger
			let max_anger = scmd.max_anger
			this.boss_scene_mgr.Fire(BossSceneEvent.UPDATE_SUIT_ANGER, anger, max_anger)
		}
		this.RegisterProtocal(46005, On46005)

		//本服BOSS关注|取消关注操作
		let On46007 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(46007)
			if (scmd.code == 1) {
				let info = this.boss_model.GetBossInfo(scmd.boss_type, scmd.boss_id)
				if (info) {
					info.is_remind = (scmd.remind > 0 && (true) || (false))
					info.auto_remind = scmd.is_auto
					this.boss_model.Fire(BossModel.UPDATE_REMIND_STATE, scmd.boss_type, scmd.boss_id)
					this.boss_model.Fire(BossModel.UPDATE_BOSS_INFO, scmd.boss_type)
				}

				//自动关注状态下不弹出飘字
				if (scmd.is_auto == 0) {
					if (scmd.remind == 0) {
						Message.show("成功取消关注~")
					} else {
						Message.show("关注成功~")
					}
				}



				//更新红点
				switch (scmd.boss_type) {
					case BossModel.BossType.abyss:
						this.boss_model.UpdateBossAbyssRed()
						break
					case BossModel.BossType.holy_wuxian:
						this.boss_model.UpdateEduRed()
						break
				}

				this.boss_model.Fire(BossModel.BOSS_EUDA_REMIAN_UPDATE, scmd)
			} else {
				Util.ErrorCodeShow(scmd.code)
			}
		}
		this.RegisterProtocal(46007, On46007)

		//BOSS被击杀信息
		let On46009 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(46009)
			if (scmd.boss_type == BossModel.BossType.suit ||
				BossModel.BossType.secret ||
				BossModel.BossType.eudaemon ||
				BossModel.BossType.field ||
				BossModel.BossType.field_infinite ||
				BossModel.BossType.fieldspecial ||
				BossModel.BossType.abyss ||
				BossModel.BossType.mystery
			) {
				this.boss_model.Fire(BossModel.KILL_BOSS, scmd)
			}
			this.boss_model.SetBossRebornTime(scmd.boss_type, scmd.boss_id, scmd.reborn_time)

			//添加一个墓碑怪
			this.boss_model.TryToCreatGrave()
		}
		this.RegisterProtocal(46009, On46009)

		//世界BOSS的疲劳值更新
		let On46011 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(46011)
			this.boss_scene_mgr.SetBossTiredData(scmd, BossModel.BossType.field)
			this.boss_model.Fire(BossModel.SCMD_REQUEST, 46044, BossModel.BossType.field)
		}
		this.RegisterProtocal(46011, On46011)

		//结算奖励
		let On46015 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(46015)
			this.boss_model.SetBossResultInfo(scmd)
		}
		this.RegisterProtocal(46015, On46015)

		//本服BOSS复活提醒
		let On46016 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(46016)

			this.boss_model.SetBossRebornTime(scmd.boss_type, scmd.boss_id,0)
			this.boss_model.Fire(BossModel.UPDATE_BOSS_INFO, scmd.boss_type)
			//删除一个墓碑怪
			this.boss_model.SceneDeleteGrave(scmd.boss_type, scmd.boss_id)


			if (!this.boss_model.GuideTaskDone()) return
			if (scmd.boss_type != BossModel.BossType.fieldspecial && scmd.boss_type != BossModel.BossType.field_infinite) {
				//boss之家 180级开启
				if(scmd.boss_type == BossModel.BossType.abyss&&RoleManager.GetInstance().GetMainRoleLevel()<180){
					return
				}
				//世界大妖体力值为0的时候不展示boss复活
				if (scmd.boss_type == BossModel.BossType.field) {
					let boss_info = this.boss_model.GetBossTypeInfo(BossModel.BossType.field)
					if(!boss_info||boss_info.tired<=0)return
				}
				this.boss_model.Fire(BossModel.OPEN_REBORN_TIPS_VIEW, scmd)

			}
		}
		this.RegisterProtocal(46016, On46016)
		let On46008 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(46016)
			if (!this.boss_model.GuideTaskDone()) return
			if (scmd.boss_type != BossModel.BossType.fieldspecial && scmd.boss_type != BossModel.BossType.field_infinite) {//this.scene_mgr.IsFieldScene() &&
				this.boss_model.Fire(BossModel.OPEN_REBORN_TIPS_VIEW, scmd)

			}
		}
		this.RegisterProtocal(46008, On46008)

		//连杀
		let On46024 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(46024)
			if (this.boss_fight_scene_view && this.boss_fight_scene_view.HasOpen()) {
				let main_role_id = this.role_mgr.GetMainRoleId()
				let index = null
				if (main_role_id == scmd["role_id"]) {
					index = scmd.dkill > 2 && scmd.dkill
				} else {
					if (scmd.dkill % 5 == 0) {
						index = scmd.dkill / 5 + 2
					}
				}
				if (index) {
					scmd["index"] = index
					let a = this.boss_fight_scene_view.SetDKillState && this.boss_fight_scene_view.SetDKillState(scmd)
				}
			}
		}
		this.RegisterProtocal(46024, On46024)

		//个人 信息推送
		let On46025 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(46025)
			for (let _tmpi in scmd.info_list) {
				let vo = scmd.info_list[_tmpi]
				switch (vo.key) {
				}
				this.boss_model.Fire(BossModel.PUSH_MSG, vo.key, vo.val)
			}
		}
		this.RegisterProtocal(46025, On46025)

		//节日boss隐藏宝箱推送
		let On46026 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(46026)
			this.boss_model.need_hide_box_list = scmd.box_list
			for (let _tmpi in scmd.box_list) {
				let vo = scmd.box_list[_tmpi]
				this.scene_mgr.DeleteMonsterVo(vo.box_id)
			}
		}
		this.RegisterProtocal(46026, On46026)

		//节日boss宝箱生成广播
		let On46027 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(46027)
			this.boss_model.ShowBoxMonster(scmd)
		}
		this.RegisterProtocal(46027, On46027)

		//节日boss结算推送
		let On46028 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(46028)
			GlobalEventSystem.Fire(EventName.OPEN_WEEKEND_ACTIVITY_VIEW, "FeastBossResultView", scmd)
			this.boss_model.Fire(BossModel.FEAST_BOSS_END)
		}
		this.RegisterProtocal(46028, On46028)

		//节日boss全部击杀
		let On46029 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(46029)
			this.boss_model.Fire(BossModel.SHOW_FEASE_BOSS_END_TIME)
		}
		this.RegisterProtocal(46029, On46029)

		//广播归属
		let On46030 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(46030)
			let main_role_id = this.role_mgr.GetMainRoleId()
			if (this.scene_mgr.IsAbyssBossScene()) {
				if (main_role_id != scmd.role_id) {
					GlobalEventSystem.Fire(EventName.SHOWRELIVEWINDOW, 1)
					this.boss_model.Fire(BossModel.OPEN_ABYSS_FAILURE_VIEW, scmd)
				}
			}
		}
		this.RegisterProtocal(46030, On46030)

		//节日boss波数信息
		let On46033 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(46033)
			this.boss_model.feast_boss_nect_wave_time = scmd.time
			this.boss_model.Fire(BossModel.SHOW_FEASE_BOSS_NEXT_WAVE_TIME, scmd.time)
		}
		this.RegisterProtocal(46033, On46033)

		//新野外boss玩家死亡次数
		let On46034 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(46034)
			ReliveModel.GetInstance().SetReliveTimeData(scmd, ReliveModel.BossSpecialReliveType.WorldBoss)
		}
		this.RegisterProtocal(46034, On46034)

		//重连
		let On46035 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(46035)
			this.boss_model.reconnect = true
		}
		this.RegisterProtocal(46035, On46035)

		//宝箱信息更新
		let On46036 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(46036)
			this.boss_model.AddBoxsPos(scmd, BossModel.BossType.mystery)
			this.boss_model.Fire(BossModel.UPDATE_MON_POS)
		}
		this.RegisterProtocal(46036, On46036)

		//获取秘境领域阶段奖励状态
		let On46037 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(46037)
			let cfg = Config.PRELOAD_SERVER_CONFIG.config_domain_kill_reward
			this.boss_model.SetMysteryBossReward(scmd)
			this.boss_model.RefreshMysteryBossRedDot(cfg)
		}
		this.RegisterProtocal(46037, On46037)

		//秘境领域阶段 领取奖励
		let On46038 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(46038)
			if (scmd.code == 1) {
				Message.show("领取奖励成功")
				this.boss_model.Fire(BossModel.GET_MYSTERY_BOSS_REWARD_SUCCESS, scmd.reward_id)
				this.boss_model.Fire(BossModel.SCMD_REQUEST, 46037)
			} else {
				Util.ErrorCodeShow(scmd.code)
			}
		}
		this.RegisterProtocal(46038, On46038)

		//进场景宝箱信息
		let On46039 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(46039)
			this.boss_model.SetBoxsPos(scmd, BossModel.BossType.mystery)
			this.boss_model.Fire(BossModel.UPDATE_MON_POS)
		}
		this.RegisterProtocal(46039, On46039)

		let On46040 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(46040)
			this.boss_model.UpdateBossHpData(scmd)
		}
		this.RegisterProtocal(46040, On46040)

		//复活boss
		let On46041 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(46041)
			if (scmd.errcode == 1) {
				Message.show("大妖已成功复活")
				this.SendFmtToGame(46000, "c", scmd.boss_type)

				//删除一个墓碑怪
				this.boss_model.SceneDeleteGrave(scmd.boss_type,scmd.boss_id)
			} else {
				Util.ErrorCodeShow(scmd.errcode)
			}
		}
		this.RegisterProtocal(46041, On46041)

		//主动复活boss通知
		let On46042 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(46042)
			if (scmd.boss_type == 10) {
				this.SendFmtToGame(47000, "c", 1)
			} else {
				this.SendFmtToGame(46000, "c", scmd.boss_type)
			}
			//删除一个墓碑怪
			this.boss_model.SceneDeleteGrave(scmd.boss_type, scmd.boss_id)
		}
		this.RegisterProtocal(46042, On46042)


		//boss体力值变化
		let On46043 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(46043)
			
		}
		this.RegisterProtocal(46043, On46043)


		//boss体力值
		let On46044 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(46044)
			this.boss_model.SetVitData(scmd)
			let data = {
				boss_tired: scmd.vit
			}
			this.boss_model.Fire(BossModel.SCMD_REQUEST, 46000, BossModel.BossType.field)//刷新体力值
			this.boss_scene_mgr.SetBossTiredData(data, BossModel.BossType.field)
			this.boss_model.Fire(BossModel.UPDATE_VIT_TIME, scmd)// scmd.vit, scmd.max_vit, scmd.last_vit_time
			this.boss_model.BossFieldRefreshVit(scmd)
		}
		this.RegisterProtocal(46044, On46044)

		/*
		跨服Boss（目前只有圣兽领）
		*/

		//怪物(采集,Boss)列表信息
		let On47000 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(47000)
			scmd.boss_type = scmd.boss_type + BossModel.cross_boss_base_index

			let eudemons_boss_cfg = Config.PRELOAD_SERVER_CONFIG.config_eudemons_boss_cfg
			let boss_type_cfgs = Config.PRELOAD_SERVER_CONFIG.config_boss_type

			if (eudemons_boss_cfg && boss_type_cfgs) {
				this.boss_model.SetBossInfo(scmd, eudemons_boss_cfg, null, boss_type_cfgs)
				this.boss_model.red_list[1] = scmd.tired < scmd.max_tired
				for (let _tmpi in scmd.collect_list) {
					let vo = scmd.collect_list[_tmpi]
					if (vo.type == 3) {
						this.boss_model.red_list[1] = vo.collect_times < vo.total_collect_times
					}
				}
				this.boss_model.UpdateEduRed()
				this.boss_model.Fire(BossModel.UPDATE_EUDAEMON_RED)
				this.boss_model.Fire(BossModel.UPDATE_BOSS_INFO, scmd.boss_type)
				GlobalEventSystem.Fire(EventName.REFRESH_ACTIVITY_ICON_RED_DOT, "6210")
				this.boss_model.TryToCreatGrave()
				
			}

		}
		this.RegisterProtocal(47000, On47000)

		//幻兽BOSS掉落记录
		let On47002 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(47002)
			this.boss_model.SetDropRecordData(scmd)
			this.boss_model.Fire(BossModel.UPDATE_MON_POS)
		}
		this.RegisterProtocal(47002, On47002)

		//进入幻兽之域
		let On47003 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(47003)
			if (scmd.code != 1) {
				Util.ErrorCodeShow(scmd.code)
			}
		}
		this.RegisterProtocal(47003, On47003)

		//退出幻兽之域
		let On47004 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(47004)
			Util.ErrorCodeShow(scmd.code)
		}
		this.RegisterProtocal(47004, On47004)

		//幻兽之域BOSS关注|取消关注操作
		let On47005 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(47005)
			scmd.boss_type = scmd.boss_type + BossModel.cross_boss_base_index
			if (scmd.code == 1) {
				let info = this.boss_model.GetBossInfo(scmd.boss_type, scmd.boss_id)
				if (info) {
					info.is_remind = scmd.remind == 1
					// this.boss_model.Fire(BossModel.UPDATE_BOSS_INFO, scmd.boss_type)
				}
				if (scmd.remind == 0) {
					Message.show("成功取消关注~")
				} else {
					Message.show("关注成功~")
				}


				switch (scmd.boss_type) {
					case BossModel.BossType.holy_wuxian:
					case BossModel.BossType.holy:
						this.boss_model.UpdateEduRed()
						break
				}

				//因为在界面会使用一些数组的浅复制方式，界面的数据可能没更新
				this.boss_model.Fire(BossModel.BOSS_EUDA_REMIAN_UPDATE, scmd)

			} else {
				Util.ErrorCodeShow(scmd.code)
			}
		}
		this.RegisterProtocal(47005, On47005)

		//幻兽之域BOSS重生提醒
		let On47006 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(47006)
			scmd.boss_type = scmd.boss_type + BossModel.cross_boss_base_index
			//if (this.scene_mgr.IsFieldScene()) {
			this.boss_model.Fire(BossModel.OPEN_REBORN_TIPS_VIEW, scmd)
			//}
		}
		this.RegisterProtocal(47006, On47006)

		//幻兽之域BOSS被击杀信息
		let On47007 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(47007)
			scmd.boss_type = scmd.boss_type + BossModel.cross_boss_base_index
			if (scmd.boss_type == BossModel.BossType.holy) {
				this.boss_model.Fire(BossModel.KILL_BOSS, scmd)
			}
			this.boss_model.SetBossRebornTime(scmd.boss_type, scmd.boss_id, scmd.reborn_time)
			this.boss_model.TryToCreatGrave()
		}
		this.RegisterProtocal(47007, On47007)

		//幻兽之域BOSS怪物重生刷新信息
		let On47008 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(47008)
		}
		this.RegisterProtocal(47008, On47008)

		//疲劳值更新
		let On47009 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(47009)
			this.boss_scene_mgr.SetBossTiredData(scmd, BossModel.BossType.eudaemon)
			this.boss_model.UpdateEduRed()
		}
		this.RegisterProtocal(47009, On47009)

		//幻兽之域的错误提示码
		let On47010 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(47010)
			if (scmd.code == 1031) {
				Message.show("正在获取蜃气楼信息 请稍候再试")
			} else {
				Util.ErrorCodeShow(scmd.code)
			}
		}
		this.RegisterProtocal(47010, On47010)

		//同区域服务器列表
		let On47011 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(47011)
			this.boss_model.cross_server_data = scmd
			this.boss_model.Fire(BossModel.REFRESH_CROSS_SERVER_LIST)
		}
		this.RegisterProtocal(47011, On47011)

		//结算奖励
		let On47015 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(47015)
			if (scmd.reward_type == 3) {
				let list = []
				for (let _tmpi in scmd.reward_list) {
					let obj = scmd.reward_list[_tmpi]
					table.insert(list, [obj.type, obj.goods_type_id, obj.num, obj.id])
				}
				Util.ShowCongratulationView(list)
			} else {
				this.boss_model.SetBossResultInfo(scmd)
			}
		}
		this.RegisterProtocal(47015, On47015)

		//个人 信息推送
		let On47016 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(47016)
			for (let _tmpi in scmd.info_list) {
				let vo = scmd.info_list[_tmpi]
				switch (vo.key) {

				}
				this.boss_model.Fire(BossModel.PUSH_MSG, vo.key, vo.val)
			}
		}
		this.RegisterProtocal(47016, On47016)

		//进场景宝箱信息
		let On47017 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(47017)
			this.boss_model.SetBoxsPos(scmd, BossModel.BossType.holy)
		}
		this.RegisterProtocal(47017, On47017)

		//宝箱信息更新
		let On47018 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(47018)
			this.boss_model.AddBoxsPos(scmd, BossModel.BossType.holy)
			this.boss_model.Fire(BossModel.UPDATE_MON_POS)
		}
		this.RegisterProtocal(47018, On47018)

		//狩猎等级信息
		let On47019 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(47019)
			this.boss_model.SetHuntingLevelData(scmd)
			if (scmd.add_exp > 0) {
				Message.show(
					`获得 ${Util.HtmlColorTxt("狩猎经验x" + scmd.add_exp, ColorUtil.GetColorLight(ColorType.GREEN))}`
				)
			}
		}
		this.RegisterProtocal(47019, On47019)

		//圣兽领榜单
		let On47021 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(47021)
			this.boss_model.Fire(BossModel.UPDATE_EUDAEMON_RANK, scmd)
		}
		this.RegisterProtocal(47021, On47021)

		//玩家获得积分推送
		let On47022 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(47022)
		}
		this.RegisterProtocal(47022, On47022)

		//最大疲劳值变化刷新
		let On47023 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(47023)
			if (scmd) {
				let info = this.boss_model.GetBossTypeInfo(BossModel.BossType.holy)
				if (info) {
					info.max_tired = scmd.max_tired
					this.boss_model.red_list[1] = info.tired < scmd.max_tired
					this.boss_model.Fire(BossModel.UPDATE_EUDAEMON_RED)
					this.boss_model.Fire(BossModel.UPDATE_BOSS_INFO, BossModel.BossType.holy)
					this.boss_model.Fire(BossModel.UPDATE_ER_TIRED_VALUE, info.tired)
					GlobalEventSystem.Fire(EventName.REFRESH_ACTIVITY_ICON_RED_DOT, "6210")
				}
			}
		}
		this.RegisterProtocal(47023, On47023)

		//玩家死亡次数
		let On47034 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(47034)
			ReliveModel.GetInstance().SetReliveTimeData(scmd, ReliveModel.BossSpecialReliveType.HolyBoss)
		}
		this.RegisterProtocal(47034, On47034)

		//复活boss
		let On47035 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(47035)
			if (scmd.errcode == 1) {
				Message.show("复活成功")
				this.SendFmtToGame(47000, "c", 1)
			} else {
				Util.ErrorCodeShow(scmd.errcode)
			}
		}
		this.RegisterProtocal(47035, On47035)

		/*
		Pk 记录
		*/

		//界面协议
		let On61900 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(61900)
			this.boss_model.SetkillRecord(scmd)
		}
		this.RegisterProtocal(61900, On61900)

		//新记录
		let On61901 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(61901)
			this.boss_model.SetNewkillRecord(scmd)
		}
		this.RegisterProtocal(61901, On61901)

		//击杀记录
		let On61902 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(61902)
			this.boss_model.SetKfkillRecord(scmd)
		}
		this.RegisterProtocal(61902, On61902)

		/*
		免战
		*/

		//免战保护信息
		let On20201 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(20201)
			this.boss_model.Fire(BossModel.UPDATE_WAR_FREE_VIEW, scmd)
		}
		this.RegisterProtocal(20201, On20201)

		//使用保护
		let On20202 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(20202)
			if (scmd.error_code == 1) {
				this.boss_model.Fire(BossModel.UPDATE_WAR_FREE_VIEW, scmd)
				this.boss_model.Fire(BossModel.SCMD_REQUEST, 20203)
			} else {
				Util.ErrorCodeShow(scmd.error_code)
			}
		}
		this.RegisterProtocal(20202, On20202)

		//保护结束时间(进入场景请求)
		let On20203 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(20203)
			let time = scmd.end_time - TimeUtil.getServerTime()
			if (scmd.end_time == 0) {
				time = 0
			}
			this.boss_model.SetWarFreeTime(time)
			this.boss_model.Fire(BossModel.UPDATE_WAR_FREE_TIME, time)
		}
		this.RegisterProtocal(20203, On20203)

		//保护时间更新
		let On20204 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(20204)
			this.boss_model.Fire(BossModel.UPDATE_WAR_FREE_VIEW, scmd)
		}
		this.RegisterProtocal(20204, On20204)

		//结束保护
		let On20205 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(20205)
			if (scmd.error_code == 1) {
				this.boss_model.Fire(BossModel.SCMD_REQUEST, 20201)
				this.boss_model.Fire(BossModel.SCMD_REQUEST, 20203)
				this.boss_model.Fire(BossModel.UPDATE_WAR_FREE_TIME, 0)
			} else {
				Util.ErrorCodeShow(scmd.error_code)
			}
		}
		this.RegisterProtocal(20205, On20205)

		/*
		怨灵封印信息
		*/

		//怨灵封印信息
		let On47101 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(47101)
			this.boss_model.do_main_data = scmd
			table.sort(scmd.boss_list, (a?, b?) => {
				return a.boss_id < b.boss_id
			})
			this.boss_model.Fire(BossModel.DOMAINBOSS_DATA_RETUEN)
			this.boss_model.SetDomainBossRed()
		}
		this.RegisterProtocal(47101, On47101)

		//进入boss
		let On47102 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(47102)
			if (scmd.error_code == 1) {
				this.boss_model.domain_boss_enter_type = scmd.type
				this.boss_model.Fire(BossModel.ENTER_DOMAINBOSS, scmd)
			} else {
				Util.ErrorCodeShow(scmd.error_code)
			}
		}
		this.RegisterProtocal(47102, On47102)

		//退出
		let On47103 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(47103)
			if (scmd.error_code != 1) {
				Util.ErrorCodeShow(scmd.error_code)
			}
		}
		this.RegisterProtocal(47103, On47103)

		//购买次数
		let On47104 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(47104)
			if (scmd.error_code != 1) {
				Util.ErrorCodeShow(scmd.error_code)
			} else {
				this.boss_model.do_main_data.buy_count = this.boss_model.do_main_data.buy_count + 1
				this.boss_model.Fire(BossModel.DOMAINBOSS_BUY_TIME_RETURN)
			}
		}
		this.RegisterProtocal(47104, On47104)

		//取消关注列表
		let On47105 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(47105)
			for(let vo of scmd.unfollow_list){
				this.boss_model.domain_unfollow_dic[vo.boss_id] = true
			}
			this.boss_model.Fire(BossModel.DOMAINBOSS_LIKE_RETURN)
		}
		this.RegisterProtocal(47105, On47105)


		//关注
		let On47106 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(47106)
			if (scmd.error_code == 1) {
				if (scmd.is_follow == 1) {
					delete this.boss_model.domain_unfollow_dic[scmd.boss_id]
					Message.show("关注成功")
				} else {
					this.boss_model.domain_unfollow_dic[scmd.boss_id] = true
					Message.show("取消关注")
				}
				this.boss_model.Fire(BossModel.DOMAINBOSS_LIKE_RETURN, scmd.boss_id)
			} else {
				Util.ErrorCodeShow(scmd.error_code)
			}
		}
		this.RegisterProtocal(47106, On47106)

		//boss/特殊boss复活通知
		let On47107 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(47107)
			this.res_mgr.GetGameConfigWithAutoDestory("config_decoration_boss", (cfg) => {
				this.boss_model.ReliveTips(scmd, cfg)
			}, false)

		}
		this.RegisterProtocal(47107, On47107)

		//BOSS掉落记录
		let On47108 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(47108)
			for (let key in scmd.drop_log) {

				let info = scmd.drop_log[key]
				info["boss_type"] = BossModel.BossType.domain
			}
			this.boss_model.SetDropRecordData(scmd)
		}
		this.RegisterProtocal(47108, On47108)

		//秘境大妖掉落记录
		let On46046 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(46046)
			let drop_log = scmd.drop_log
			for(let i=0;i<drop_log.length;i++){
				drop_log[i]["boss_type"] = scmd.boss_type
			}
			this.boss_model.SetDropRecordData(scmd)
			this.boss_model.Fire(BossModel.UPDATE_MON_POS)
		}
		this.RegisterProtocal(46046, On46046)
		//特殊boss个人排名
		let On47109 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(47109)
			this.boss_model.role_rank_list = scmd.rank_list
			this.boss_model.Fire(BossModel.DOMAINBOSS_ROLE_RANK_RETURN)
		}
		this.RegisterProtocal(47109, On47109)

		//进入特殊boss
		let On47110 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(47110)
			if (scmd.error_code != 1) {
				Util.ErrorCodeShow(scmd.error_code)
			}
		}
		this.RegisterProtocal(47110, On47110)

		//结社求助
		let On47111 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(47111)
			if (scmd.error_code != 1) {
				Util.ErrorCodeShow(scmd.error_code)
			}
		}
		this.RegisterProtocal(47111, On47111)

		//特殊boss个人伤害
		let On47112 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(47112)
			this.boss_model.ChangeRoleRank(scmd)
		}
		this.RegisterProtocal(47112, On47112)

		//boss结算
		let On47113 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(47113)
			if (!this.boss_domain_result_view) {
				let view_class: any = window["BossDomainResultView"]
				this.boss_domain_result_view = new view_class()
			}
			this.boss_domain_result_view.SetResultData(scmd)
			this.boss_domain_result_view.Open()
		}
		this.RegisterProtocal(47113, On47113)

		//战斗场景信息
		let On47114 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(47114)
			this.boss_model.DoMainBossExitTime(scmd.quit_time)
			this.boss_model.DoMianBossReliveTime(scmd.revive_time)
			this.boss_model.domain_boss_enter_type = scmd.enter_type
		}
		this.RegisterProtocal(47114, On47114)

		//退出时间
		let On47115 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(47115)
			this.boss_model.DoMainBossExitTime(scmd.quit_time)
		}
		this.RegisterProtocal(47115, On47115)

		//复活时间
		let On47116 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(47116)
			this.boss_model.DoMianBossReliveTime(scmd.revive_time)
		}
		this.RegisterProtocal(47116, On47116)

		//boss/特殊boss死亡
		let On47117 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(47117)
		}
		this.RegisterProtocal(47117, On47117)




		//世界boss找回体力
		let On46045 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(46045)
			if (scmd.code == 1) {
				this.boss_model.Fire(BossModel.BOSS_FIELD_BACK_VIT_UPDATE)
			} else {
				Util.ErrorCodeShow(scmd.errcode)
			}
		}
		this.RegisterProtocal(46045, On46045)
	}

	ChangeScene() {

		if (this.boss_rebron_tips_view && this.boss_rebron_tips_view.HasOpen()) {
			this.boss_rebron_tips_view.Close()
		}

		let last_scene_id = this.scene_mgr.GetLastSceneId()
		let last_dun_id = this.scene_mgr.last_dun_id


		if (this.scene_mgr.IsBossScene() && !this.scene_mgr.IsKfHolyAreaScene()) { //and ! this.scene_mgr.IsBossScene(last_scene_id)
			this.EnterSceneHandle()
		}
		if (this.scene_mgr.IsGuildFightScene() || this.scene_mgr.IsSeaHegemonyScene() || this.scene_mgr.IsSeaAsserScene()) {
			this.EnterSceneHandle()
		}
		if (this.scene_mgr.IsBossScene(last_scene_id) && !this.scene_mgr.IsBossScene()) {
			this.ExitSceneHandle()
		}

		if (this.scene_mgr.IsGuildFightScene(last_scene_id) && !this.scene_mgr.IsGuildFightScene()) {
			this.ExitSceneHandle()
		}

		if (this.scene_mgr.IsSeaHegemonyScene(last_scene_id) && !this.scene_mgr.IsSeaHegemonyScene()) {
			this.ExitSceneHandle()
		}

		if (this.scene_mgr.IsSeaAsserScene(last_scene_id) && !this.scene_mgr.IsSeaAsserScene()) {
			this.ExitSceneHandle()
		}

		if (this.scene_mgr.IsKfHolyAreaScene() && !this.scene_mgr.IsKfHolyAreaScene(last_scene_id) && this.scene_mgr.IsBossScene(last_scene_id)) {
			this.ExitSceneHandle()
		}

		//在boss之家被击杀出去外面后 ，恰逢晚宴开始，直接被拉进到晚宴场景  两个场景的ui会重叠在一起
		//做个兼容处理
		if(this.scene_mgr.IsEveningScene()){
			this.ExitSceneHandle()
		}
		clearTimeout(this.delay_timer)


		//this.boss_model:fieldBossTipsTimer()
		if (!this.scene_mgr.IsDWScene()) {
			this.boss_model.drop_dic = []
		}

		if ((this.scene_mgr.IsFieldScene() && this.boss_fight_scene_view) && this.boss_fight_scene_view.HasOpen()) {
			this.boss_fight_scene_view.Close()
		}
		this.BossHpUpdate()


		this.boss_model.TryToCreatGrave()
	}

	EnterSceneHandle() {

		GlobalEventSystem.Fire(EventName.CLOSE_VIEW, "BossEnterView")
		this.SetMainUIVisible(false)

		// if (this.delay_timer) {
		this.mainui_model.Fire(MainUIModel.CHANGE_ACTIVITY_STATE, false)
		this.boss_model.main_ui_setting_flag = true
		if (this.scene_mgr.IsFieldBossScene()) {
			this.boss_model.Fire(EventName.OPEN_BOSS_SCENE_VIEW, true, BossModel.BossType.field)
			this.boss_model.Fire(BossModel.SCMD_REQUEST, 46044, BossModel.BossType.field)
		} else if (this.scene_mgr.IsFieldSpecialBossScene()) {
			this.boss_model.Fire(EventName.OPEN_BOSS_SCENE_VIEW, true, BossModel.BossType.fieldspecial)
		} else if (this.scene_mgr.IsFieldInfiniteBossScene()) {
			this.boss_model.Fire(EventName.OPEN_BOSS_SCENE_VIEW, true, BossModel.BossType.field_infinite)
		} else if (this.scene_mgr.IsAbyssBossScene()) {
			this.boss_model.Fire(EventName.OPEN_BOSS_SCENE_VIEW, true, BossModel.BossType.abyss)
		} else if (this.scene_mgr.IsSuitBossScene()) {
			this.boss_model.Fire(EventName.OPEN_BOSS_SCENE_VIEW, true, BossModel.BossType.suit)
		} else if (this.scene_mgr.IsHolyBossScene()) {
			this.boss_model.Fire(EventName.OPEN_BOSS_SCENE_VIEW, true, BossModel.BossType.holy)
		} else if (this.scene_mgr.IsHolyTerritory()) {
			this.boss_model.Fire(EventName.OPEN_BOSS_SCENE_VIEW, true, BossModel.BossType.holyterritory)
		} else if (this.scene_mgr.IsMysteryBossScene()) {
			this.boss_model.Fire(EventName.OPEN_BOSS_SCENE_VIEW, true, BossModel.BossType.mystery)
		} else if (this.scene_mgr.IsFeastBossScene()) {
			this.boss_model.Fire(EventName.OPEN_BOSS_SCENE_VIEW, true, BossModel.BossType.feast)
			let icon_type = CustomActivityModel.GetInstance().GetFeastBossIconType()
			if (icon_type) {
				GlobalEventSystem.Fire(EventName.CLOSE_ACT_VIEW, icon_type)
			}
		} else if (this.scene_mgr.IsBossDoMainScene()) {
			this.boss_model.Fire(EventName.OPEN_BOSS_SCENE_VIEW, true, BossModel.BossType.domain)
			MainUIController.GetInstance().SetMainUIViewVisible(11, false)
		} else if (this.scene_mgr.IsCrossWuxianBossScene()) {
			this.boss_model.Fire(EventName.OPEN_BOSS_SCENE_VIEW, true, BossModel.BossType.holy_wuxian)
		}
		// }


	}

	ExitSceneHandle() {
		let last_scene_id = this.scene_mgr.GetLastSceneId()
		if ((this.scene_mgr.IsExpDungeon() || !this.scene_mgr.IsDungeonScene()) && !this.scene_mgr.IsKfHolyAreaScene()) {
			this.SetMainUIVisible(true)
			this.mainui_model.Fire(MainUIModel.CHANGE_ACTIVITY_STATE, true)
		}
		if (this.scene_mgr.IsBossDoMainScene(last_scene_id) && this.scene_mgr.IsFieldScene()) {
			GlobalEventSystem.Fire(EventName.OPEN_VIEW, "CrossServerEnterView", CrossServerViewIndex.Domain_Boss)
			MainUIController.GetInstance().SetMainUIViewVisible(11, true)
		}
		this.boss_model.Fire(EventName.OPEN_BOSS_SCENE_VIEW, false)
		// this.auto_fight_mgr.SetAutoFight(true)
		this.boss_model.SetEnterBossInfo(null)
		this.boss_model.last_scene_id = null
	}

	SetMainUIVisible(bool?) {
		MainUIController.GetInstance().SetMainUIViewVisible(10, bool)
		MainUIController.GetInstance().SetMainUIViewVisible(13, bool)
	}

	BossHpUpdate = (config_boss_show_hp?) => {
		this.boss_model.SetBossHpCfg(null)
		let cfg = Config.PRELOAD_SERVER_CONFIG.config_boss_show_hp
		if (cfg && cfg[this.scene_mgr.curr_scene_id]) {
			this.boss_model.SetBossHpCfg(cfg[this.scene_mgr.curr_scene_id])
			this.boss_model.StartUpdateBossHp()
		} else {
			this.boss_model.StopUpdateBossHp()
		}
	}
}

window["BossController"] = BossController
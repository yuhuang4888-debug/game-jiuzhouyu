
import { BaseController } from "../common/BaseController"
import { BaseViewInterface } from "../common/BaseView1"
import { CommonGoodsListVo } from "../common/CommonGoodsListVo"
import { Config } from "../common/Config"
import { CongratulationObtainView } from "../common/CongratulationObtainView"
import { EventName, SceneEventType } from "../common/EventName"
import { OpenFun } from "../common/OpenFun"
import { StoryModel } from "../commonModel/StoryModel"
import { TaskModel, TaskTipType, TaskType } from "../commonModel/TaskModel"
import { LoginManager } from "../login/LoginManager"
import { ParticleManager } from "../particalEffect/ParticleManager"
import { RoleManager } from "../commonModel/RoleManager"
import { FightEvent } from "../scene/fight/FightEvent"
import { Scene } from "../scene/Scene"
import { SceneManager } from "../scene/SceneManager"
import { Message } from "../sysInfo/SysInfoController"
import { TaskUpAlertView } from "../task/TaskUpAlertView"
import { TaskVo } from "../sharedata/TaskVo"
import { ClientConfig, GlobalEventSystem } from "../util/DeclareGlobalVar"
import { Status } from "../util/Status"
import { Util } from "../util/Util"
import { Enum_UILayer } from "../common/LayerManager"
import { AutoBrushModel } from "../commonModel/AutoBrushModel"
import { AutoFightManager } from "../autofight/AutoFightManager"

import "../task/TaskFinishView"
import "../task/TaskCircleFinishView"
import "../task/TaskAutoSettingView"
import { ReincarnationModel } from "../commonModel/ReincarnationModel"
import { SettingModel } from "../commonModel/SettingModel"
import { LoginModel } from "../login/LoginModel"
import { HashObject } from "../common/BaseClass"

export class TaskController extends BaseController {

	InitInfo
	ReadTaskVo
	InitEvents

	ShowSuccessEffect
	success_effect_id
	public constructor() {
		super()

		let model = TaskModel.GetInstance()
		let view_dic_: { [name: string]: BaseViewInterface } = {}
		let welcome_view_ = null
		let up_alert_view_ = null
		let task_finish_ = null
		let local_TaskType = TaskType
		let local_TaskModel = TaskModel
		let local_TaskTipType = TaskTipType

		this.InitEvents = () => {

			model.Bind(TaskModel.TASK_OPEN_VIEW, (view_class_name, ...parms) => {
				let view_class: any = window[view_class_name]
				if (view_class) {
					let view_obj = view_dic_[view_class_name]
					if (!view_obj) {
						view_obj = new view_class()
						view_dic_[view_class_name] = view_obj
					}
					if (!view_obj.HasOpen()) {
						view_obj.Open(...parms)
					}
				}
			})

			model.Bind(TaskModel.TASK_CLOSE_VIEW, (view_class_name) => {
				let view_obj = view_dic_[view_class_name]
				if (view_obj) {
					view_obj.Close()
				}
			})

			GlobalEventSystem.Bind(EventName.GAME_START, () => {
				model.InitConfig()
				model.ClearData()
				model.Fire(TaskModel.REQUEST_CCMD_EVENT, 30010, TaskType.GUILD)
				model.Fire(TaskModel.REQUEST_CCMD_EVENT, 30010, TaskType.DAILY)
				model.Fire(TaskModel.REQUEST_CCMD_EVENT, 30010, TaskType.EUDAEMON_TASK)
				this.SendFmtToGame(30000)
				GlobalEventSystem.Fire(SceneEventType.CLOSE_DIALOGUE_VIEW)
				model.Fire(TaskModel.REQUEST_CCMD_EVENT, 30005)
			}
			)

			let onRequestHandler = (...new_args) => {
				let args = new_args
				if (((args[0] == 30003 || args[0] == 30004) || args[0] == 30012) || args[0] == 30007) {
					this.SendFmtToGame(args[0], "i", args[1])
				} else if ((args[0] == 30010 || args[0] == 30011) || args[0] == 30013) {
					this.SendFmtToGame(args[0], "c", args[1])
				} else if (args[0] == 30006) {
					this.SendFmtToGame(args[0], "iii", args[1], args[2], args[3])
				} else {
					this.SendFmtToGame(args[0])
				}
			}
			model.Bind(TaskModel.REQUEST_CCMD_EVENT, onRequestHandler)

			let scene_changed_func = () => {
				model.monster_center_pos = null
			}
			GlobalEventSystem.Bind(SceneEventType.SCENE_CHANGED, scene_changed_func)

			let scene_start_func = () => {
				let scene_mgr = SceneManager.GetInstance()
				if (scene_mgr.IsFieldScene()) {
					if (model.finish_task_vo) {
						if(model.IsCircleTask(model.finish_task_vo.task_type)){
							model.Fire(TaskModel.TASK_OPEN_VIEW, 'TaskCircleFinishView', model.finish_task_vo);
						}
						else{
							model.Fire(TaskModel.TASK_OPEN_VIEW, 'TaskFinishView', model.finish_task_vo);
						}
						model.finish_task_vo = null
					}

					if (!scene_mgr.IsFieldScene(scene_mgr.GetLastSceneId())) {
						let cache_task = model.ShouldRestoreTask()
						if (cache_task && scene_mgr.IsMainLineDungeonScene(scene_mgr.GetLastSceneId())) {
							AutoBrushModel.GetInstance().StopAutoBrushState()
						}

						let failue_state = false
						if (scene_mgr.IsMainLineDungeonScene(scene_mgr.GetLastSceneId())) {
							failue_state = AutoBrushModel.GetInstance().GetFailueState()
						}

						if (!cache_task && scene_mgr.IsMainLineDungeonScene(scene_mgr.GetLastSceneId())) {
							//说明没有在主线副本内缓存任务，就走下面的逻辑
							let main_task_vo = model.GetMainLineTaskVo()
							if (!main_task_vo || main_task_vo.id > TaskModel.AutoBrushTaskId) {
								return
							}
							let auto_brush_state = AutoBrushModel.GetInstance().GetAutoBrushStrangeState()
							//如果是失败退出的场景
							if (failue_state) {
								if (main_task_vo.has_finish == 1) {
									console.warn("------fail has_finish task", main_task_vo.task_id)
									if (StoryModel.GetInstance().HasFingerIsShowing()) {
										//主线完成有引导不做处理
										console.warn("------fail has_finish has_finger")
									}
									else {
										if(!model.GetAutoTaskSetting()) return
										if (main_task_vo.task_tips_type == local_TaskTipType.Talk
											|| main_task_vo.task_tips_type == local_TaskTipType.StartTalk
											|| main_task_vo.task_tips_type == local_TaskTipType.EndTalk) {
											console.warn("------fail has_finish do talk")
											model.DoTask(main_task_vo)
										}
										else {
											console.warn("------fail has_finish 30004", main_task_vo.task_id)
											//帮他提交
											model.Fire(local_TaskModel.REQUEST_CCMD_EVENT, 30004, main_task_vo.task_id)
										}
									}
								}
								else {
									console.warn("------fail unfinish task , type is PassMainDungeon", main_task_vo.task_id)
									//如果当前的任务是推关
									if (main_task_vo.task_tips_type == local_TaskTipType.PassMainDungeon) {
										let level = AutoBrushModel.GetInstance().GetLevel()
										let next_level = level + 1
										let cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_enchantment_guard_boss.name, next_level, false)
										if (cfg) {
											let main_role_power = RoleManager.GetInstance().GetMainRoleVo().fighting
											if (main_role_power >= cfg.power) {
												//失败后，人物战斗力大于推荐战斗力，重置引导
												// StoryModel.GetInstance().curr_view_story_step = 0 
												AutoBrushModel.GetInstance().Fire(AutoBrushModel.SHOW_MAIN_TASK_ARROW2)
												console.warn("------fail 人物战斗力大于推荐战斗力，重置引导", main_role_power, cfg.power)
											}
											else {
												//原地不动
												console.warn("------fail 人物战斗力小于于推荐战斗力，原地不动", main_role_power, cfg.power)
											}
										}
									}
									else {
										console.warn("------fail unfinish task , type is PassMainDungeon", main_task_vo.task_id)
										if (StoryModel.GetInstance().HasFingerIsShowing()) {
											//主线完成有引导不做处理
										}
										else {
											if(!model.GetAutoTaskSetting()) return
											if (
												main_task_vo.task_tips_type == local_TaskTipType.Talk
												|| main_task_vo.task_tips_type == local_TaskTipType.StartTalk
												|| main_task_vo.task_tips_type == local_TaskTipType.EndTalk
												|| main_task_vo.task_tips_type == local_TaskTipType.Collect
												|| main_task_vo.task_tips_type == local_TaskTipType.Kill) {
												model.DoTask(main_task_vo)
											}
											else {
												//呆着
											}
										}

									}
								}
							}
							else {
								//如果当前任务已结束
								if (main_task_vo.has_finish == 1) {
									console.warn("------win finish task")
									if (auto_brush_state) {
										console.warn("------win stop auto brush")
										AutoBrushModel.GetInstance().Fire(AutoBrushModel.REQUEST_PROTO_EVENT, 13307, "c", 1)
									}
									if (StoryModel.GetInstance().HasFingerIsShowing()) {
										//主线完成有引导不做处理
										console.warn("------win has finger")
									}
									else {
										if(!model.GetAutoTaskSetting()) return
										if (main_task_vo.task_tips_type == local_TaskTipType.Talk
											|| main_task_vo.task_tips_type == local_TaskTipType.StartTalk
											|| main_task_vo.task_tips_type == local_TaskTipType.EndTalk) {
											console.warn("------win do talk")
											model.DoTask(main_task_vo)
										}
										else {
											console.warn("------win 30004", main_task_vo.task_id)
											//帮他提交
											model.Fire(local_TaskModel.REQUEST_CCMD_EVENT, 30004, main_task_vo.task_id)
										}
									}
								}
								else {
									console.warn("------win unfinish task")
									if (auto_brush_state) {
										//自动找怪点自动闯关
										console.warn("------win auto fight")
										AutoFightManager.GetInstance().StartFieldSceneAutoFight()
									}
								}
							}

						}
					} else {
						model.need_go_to_task_cache = null
					}
				} else if (scene_mgr.IsBossScene()) {
					GlobalEventSystem.Fire(EventName.SELECT_STORY_TARGET, StoryModel.StoryTargetName.BossDungeon, false)
				}
			}
			GlobalEventSystem.Bind(SceneManager.START, scene_start_func)

			model.Bind(TaskModel.OPEN_UPALERT_VIEW, () => {
				if (!up_alert_view_) {
					up_alert_view_ = new TaskUpAlertView()
				}
				up_alert_view_.Open()
			})

			model.Bind(TaskModel.CLICK_DO_TASK, (task_id?, task_type?) => {
				model.now_select_task_id = task_id
				model.now_do_task_type = task_type
			})

			let cancelSppedBuff = () => {
				model.CancelSpeedEffect()
			}
			GlobalEventSystem.Bind(EventName.FINDWAY_ENDED, cancelSppedBuff)
			GlobalEventSystem.Bind(EventName.CANCEL_SPEED_BUFF, cancelSppedBuff)
			GlobalEventSystem.Bind(SceneEventType.DIALOGUE_VIEW_IS_OPEN, cancelSppedBuff)
			SceneManager.GetInstance().BindOne("curr_joystick_dir", cancelSppedBuff)
			GlobalEventSystem.Bind(EventName.OPEN_COLLECT_VIEW, cancelSppedBuff)
			GlobalEventSystem.Bind(FightEvent.RELEASE_MAIN_SKILL, cancelSppedBuff)

			let collect_succeed_fun = (mon_type_id?, mon_ins_id?) => {
				if (mon_type_id && model.HaveCollectTask(mon_type_id)) {
					Scene.GetInstance().user_manul_time = Status.NowTime
					console.log("采集成功,暂停0.5秒")
				}
			}
			GlobalEventSystem.Bind(EventName.COMPLETE_TO_COLLECT, collect_succeed_fun)

			//是否自动任务
			let setting_change = (scmd?) => {		
				// let cfg = Config.PRELOAD_CLIENT_CONFIG.ClientBlockConfig
				// if (scmd && scmd.subtype && cfg && cfg.BlockSubType && cfg.BlockSubType.auto_task == scmd.subtype
				// 	&& model.auto_task_alert_view_had_show) {
				// 	model.auto_task_alert_view_had_show = null
				// 	if (model.GetAutoTaskSetting()) {
				// 		model.FindNextAutoFightTask()
				// 	}
				// }
			}
			SettingModel.GetInstance().Bind(SettingModel.UPDATE_ONE_SETTING_INFO, setting_change)

			//最新完成的任务id
			let new_finish_task_id = (task_id?) => {
				let is_first = model.ShowTaskAutoAlert(task_id)
				if (is_first) {
					task_finish_ = false
				}
			}
			GlobalEventSystem.Bind(EventName.UPDATE_NEWEST_TASK_ID_NOT_DELAY, new_finish_task_id)

			//剧情结束后，要继续做任务
			let loading_view_close = (scene_id?, index?) => {
				if(!ClientConfig.auto_task_view) return

				let is_new_career = LoginModel.GetInstance().is_new_career
				if(!is_new_career) return
				
				let story_model = StoryModel.GetInstance()
				if (story_model.main_ui_finger) {
					let obj = story_model.main_ui_finger && story_model.main_ui_finger.target_obj
					GlobalEventSystem.Fire(EventName.HIDE_FINGER, obj, true)
				}
				
				if(!model.auto_setting_view_lock_obj){
					model.auto_setting_view_lock_obj = new HashObject()
				}
				StoryModel.RestoreFingerLock[model.auto_setting_view_lock_obj.hashCode] = true
				model.Fire(TaskModel.TASK_OPEN_VIEW, "TaskAutoSettingView")
			}
			GlobalEventSystem.Bind(EventName.LOGIN_LOADING_VIEW_CLOSE, loading_view_close)

			let story_start = (scene_id?, index?) => {
				GlobalEventSystem.Fire(SceneEventType.CLOSE_DIALOGUE_VIEW)
			}
			GlobalEventSystem.Bind(EventName.STORY_START, story_start)
			GlobalEventSystem.Bind(EventName.CHANGE_ACCOUNT, story_start)
			GlobalEventSystem.Bind(EventName.CHANGE_ROLE, story_start)
		}

		this.InitInfo = () => {
			let need_clear_timer_id = null
			let On30000 = () => {
				let all_task_list = {}
				let can_task_list = {}
				let len0 = this.ReadFmt("h")
				let task_id = null
				let task_tips_list = null
				if (len0 > 0) {
					for (let i = 0; i < len0; i++) {
						[task_id, task_tips_list] = this.ReadTaskVo()
						can_task_list[task_id] = task_tips_list
						all_task_list[task_id] = task_tips_list
					}
				}
				let len = this.ReadFmt("h")
				let has_receive_task_list = null
				let task_id_list = []
				let last_main_line_vo = model.GetMainLineTaskVo()
				let last_reincarnationTaskList = model.GetReincarnationTaskList()
				if (len > 0) {
					has_receive_task_list = {}
					let vo = null
					let i = 0
					do {
						[task_id, task_tips_list] = this.ReadTaskVo()
						task_id_list.push(task_id)
						has_receive_task_list[task_id] = task_tips_list
						//model:ShouldShowFinishView(task_tips_list, false)				//一些特定类型的任务会自动完成，这里也处理下，容错用
						all_task_list[task_id] = task_tips_list
						if (task_tips_list && task_tips_list[0]) {
							vo = task_tips_list[0]
							if ((vo.task_type == local_TaskType.GUILD || vo.task_type == local_TaskType.DAILY) || vo.task_type == local_TaskType.EUDAEMON_TASK) {
								model.Fire(local_TaskModel.REQUEST_CCMD_EVENT, 30012, task_id)
							}
						}
						model.FinishPartnerAwake(task_id)	//伙伴唤醒任务，判断是否有没触发完成的阶段主任务（子任务都已完成）
						i = i + 1
					} while ((i < len))

					if (model.GetHasReceiveTaskList() == null) {
						let task_list = null
						for (let key in has_receive_task_list) {
							task_list = has_receive_task_list[key]
							model.FinishPartnerAwake(key)	//伙伴唤醒任务，每次登录后，判断是否有没触发完成的阶段主任务（子任务都已完成）
						}
					}
				}

				let done_fun = () => {
					let main_line_vo = model.GetMainLineTaskVo()
					if (last_main_line_vo == main_line_vo && model.now_do_task_type == local_TaskType.MAIN_LINE || len == 0) {
						model.SetMainLineTaskVo(null)
					}
					if (last_reincarnationTaskList == model.GetReincarnationTaskList() || len == 0) {
						model.SetReincarnationTaskList(null)
					}
					model.SetClientDailyAndGuildTask(false, TaskType.DAILY)
					model.SetClientDailyAndGuildTask(false, TaskType.GUILD)
					model.DelayFire(local_TaskModel.UPDATE_ALL_TASK_FROM_30000)

					if (task_finish_ && model.GetAutoTaskSetting()) {
						task_finish_ = false
						model.FindNextAutoFightTask()
					}
				}
				console.log("30000-------has_receive_task_list-----:", has_receive_task_list)
				console.log("30000-------all_task_list-----:", all_task_list)
				model.ShowTaskAcceptTaskSound(has_receive_task_list)
				model.SetHasReceiveTaskList(has_receive_task_list)
				model.SetCanTaskList(can_task_list)
				model.SetAllTaskList(all_task_list)
				if (need_clear_timer_id) {
					clearTimeout(need_clear_timer_id)
					need_clear_timer_id = null
				}
				if (!need_clear_timer_id) {
					need_clear_timer_id = setTimeout(() => {
						done_fun()
					}, 100)
				}
			}

			let On30001 = () => {
				let [task_id, task_tips_list] = this.ReadTaskVo(true)
				if (task_tips_list) {
					if (model.GetHasReceiveTaskList()) {
						model.ShowRecinationAlert(task_tips_list)
						model.UpdateHasReceiveTaskListByTaskId(task_id, task_tips_list)
					} else {
						let tem_list = []
						tem_list[task_id] = task_tips_list
						model.SetHasReceiveTaskList(tem_list)
					}

					if (model.GetAllTaskList()) {
						model.UpdateAllTaskList(task_id, task_tips_list)
					} else {
						let tem_list = []
						tem_list[task_id] = task_tips_list
						model.SetAllTaskList(tem_list)
					}
					let is_finish_lv_task = model.ShouldShowFinishView(task_tips_list)
					if (!is_finish_lv_task) {
						model.DailyAndGuildTaskFun(task_tips_list)
					}
					model.DelayFire(local_TaskModel.UPDATE_ONE_TASK, task_id, task_tips_list)
				}
			}

			let On30003 = () => {
				let [task_id, error_code] = this.ReadFmt("ih")
				if (error_code == 0) {
					Util.ErrorCodeShow(error_code)
				} else {
					model.now_select_task_id = task_id
					Message.show("<font color='#93e725'>成功接受任务</font>")
					// model.GetTask(task_id)
					// TaskSoundManager.GetInstance().PlayTaskSound(flag)
				}
			}

			let On30004 = () => {
				let [task_id, error_code] = this.ReadFmt("ii")
				if (error_code != 1) {
					if (error_code != 3000015) {
						Util.ErrorCodeShow(error_code)
					}
				} else {
					//Message.show("完成任务")
					// TaskSoundManager.GetInstance().PlayTaskSound(task_id)
					// TaskSoundManager.GetInstance().PlayTaskCompleteSound(task_id)
					this.ShowSuccessEffect()
				}
				let goods_list = new CommonGoodsListVo().ReadFmt()
				if (task_id) {
					model.Fire(local_TaskModel.FINISH_TASK, task_id)
				}
				let task_cfg = model.GetTaskCfg(task_id)
				if (!task_cfg || (task_cfg.type != TaskType.AWAKE_LINE && task_cfg.type != TaskType.NORMAL_DAILY)) { //唤醒/圣兽领采集水晶任务不自动任务
					task_finish_ = true
				}
				if (task_id > 0 && model.IsShowExpTask(task_id)) {
					if (model.IsMainTask(task_id)) {
						if (!model.newest_finish_task_id || task_id > model.newest_finish_task_id) {
							model.newest_finish_task_id = task_id
						}
						GlobalEventSystem.DelayFire(EventName.UPDATE_NEWEST_TASK_ID, task_id)
						GlobalEventSystem.Fire(EventName.UPDATE_NEWEST_TASK_ID_NOT_DELAY, task_id)
					}
				}
				model.TaskFinish(task_id)
			}

			//最新完成主线任务id
			let On30005 = () => {
				let task_id = this.ReadFmt("i")
				model.newest_finish_task_id = task_id
				GlobalEventSystem.DelayFire(EventName.UPDATE_NEWEST_TASK_ID, task_id)
				GlobalEventSystem.Fire(EventName.UPDATE_NEWEST_TASK_ID_NOT_DELAY, task_id)
				LoginManager.GetInstance().SetGameStartReceiveFlag("30005", true)
			}

			let On30006 = () => {
				let error_code = this.ReadFmt("i")
				let task_id = this.ReadFmt("i")
				if (error_code != 1) {
					Util.ErrorCodeShow(error_code)
				}
			}

			let On30008 = () => {

			}

			let On30009 = () => {
				model.Fire(TaskModel.REQUEST_CCMD_EVENT, 30010, TaskType.GUILD)
				model.Fire(TaskModel.REQUEST_CCMD_EVENT, 30010, TaskType.DAILY)
				model.Fire(TaskModel.REQUEST_CCMD_EVENT, 30010, TaskType.EUDAEMON_TASK)
				this.SendFmtToGame(30000)
			}

			let On30010 = () => {
				let task_type = this.ReadFmt("c")
				let finish_num = this.ReadFmt("c")
				let all_num = this.ReadFmt("c")
				model.SetCircleTaskProgressData(
					{
						task_type: task_type, 
						finish_num: finish_num,
						all_num: all_num
					})
			}

			let On30011 = () => {
				let code = this.ReadFmt("i")
				let task_type = this.ReadFmt("c")
				if (code != 1) {
					Util.ErrorCodeShow(code)
				} else {
					if (!model.HaveThisTypeTask(task_type)) {
						model.now_do_task_type = task_type
						task_finish_ = true
						model.Fire(local_TaskModel.REQUEST_CCMD_EVENT, 30000)
					}
				}
			}

			let On30012 = () => {
				let task_id = this.ReadFmt("i")
				let len = this.ReadFmt("h")
				let reward_list = []

				if (len > 0) {
					let i = 0
					do {
						let vo = null
						vo = []
						vo.type = this.ReadFmt("c")
						vo.type_id = this.ReadFmt("i")
						vo.count = this.ReadFmt("l")
						reward_list.push(vo)
						i = i + 1
					} while ((i < len))
				}

				let len2 = this.ReadFmt("h")
				let extra_reward_list = []
				let i = 0
				if (len2 > 0) {
					do {
						let vo = null
						vo = []
						vo.type = this.ReadFmt("c")
						vo.type_id = this.ReadFmt("i")
						vo.count = this.ReadFmt("l")
						extra_reward_list.push(vo)
						i = i + 1
					} while ((i < len2))
				}
				model.SetCircleTaskReward(task_id, reward_list, extra_reward_list)
			}

			let On30013 = () => {
				let code = this.ReadFmt("i")
				let task_type = this.ReadFmt("c")
				let len = this.ReadFmt("h")
				let reward_list = []
				if (len > 0) {
					let i = 0
					do {
						let vo = null
						vo = []
						vo[0] = this.ReadFmt("c")
						vo[1] = this.ReadFmt("i")
						vo[2] = this.ReadFmt("l")
						reward_list.push(vo)
						i = i + 1
					} while ((i < len))
				}

				let len2 = this.ReadFmt("h")
				// let extra_reward_list = []
				if (len2 > 0) {
					let i = 0
					do {
						let vo = null
						vo = []
						vo[0] = this.ReadFmt("c")
						vo[1] = this.ReadFmt("i")
						vo[2] = this.ReadFmt("l")
						reward_list.push(vo)
						i = i + 1
					} while ((i < len2))
				}

				if (code == 1) {
					let view = new CongratulationObtainView(reward_list, 10)
					view.Open()

					Message.show("扫荡成功")
					if (task_type == TaskType.GUILD) {
						model.Fire(TaskModel.REQUEST_CCMD_EVENT, 30010, TaskType.GUILD)
					} else if (task_type == TaskType.DAILY) {
						model.Fire(TaskModel.REQUEST_CCMD_EVENT, 30010, TaskType.DAILY)
					}
					model.Fire(local_TaskModel.REQUEST_CCMD_EVENT, 30000)
				} else {
					Util.ErrorCodeShow(code)
				}
			}

			this.RegisterProtocal(30000, On30000)
			this.RegisterProtocal(30001, On30001)
			this.RegisterProtocal(30003, On30003)
			this.RegisterProtocal(30004, On30004)
			this.RegisterProtocal(30005, On30005)
			this.RegisterProtocal(30006, On30006)
			this.RegisterProtocal(30008, On30008)
			this.RegisterProtocal(30009, On30009)
			this.RegisterProtocal(30010, On30010)
			this.RegisterProtocal(30011, On30011)
			this.RegisterProtocal(30012, On30012)
			this.RegisterProtocal(30013, On30013)
		}

		this.ReadTaskVo = (set_new_finish_flag?) => {
			let task_tips_list = null
			let task_tips_vo = null
			let task_id = this.ReadFmt("i")
			let task_tips_len = this.ReadFmt("h")
			if (task_tips_len > 0) {
				task_tips_list = []
				let j = 0
				do {
					task_tips_vo = new TaskVo(task_id, this.ReadFmt("c"), this.ReadFmt("s"), this.ReadFmt("c"), this.ReadFmt("i"), this.ReadFmt("i"), this.ReadFmt("i"), this.ReadFmt("i"), this.ReadFmt("i"), this.ReadFmt("h"), this.ReadFmt("h"), this.ReadFmt("c"))
					if (task_tips_vo.task_tips_type == local_TaskTipType.CollectMaterial && task_tips_vo.now_num >= task_tips_vo.need_num) {
						if (task_tips_vo.has_finish == 1) {
							ReincarnationModel.GetInstance().CollectRealFinish = true
						} else {
							ReincarnationModel.GetInstance().CollectRealFinish = false
							task_tips_vo.has_finish = 1
						}
					} else if (task_tips_vo.task_tips_type == local_TaskTipType.Talk
						||task_tips_vo.task_tips_type == local_TaskTipType.TrainMount
						||task_tips_vo.task_tips_type == local_TaskTipType.TrainPartner) {
						if (task_tips_vo.has_finish) {
							task_tips_vo.now_num = 1
						} else {
							task_tips_vo.now_num = 0
						}
						task_tips_vo.need_num = 1
					}
					model.FormatCircleTaskReaward(task_tips_vo)
					if ((set_new_finish_flag && task_tips_vo.has_finish == 1) && model.IsNewFinish(task_tips_vo)) {
						task_tips_vo.new_finish_flag = true
					}
					task_tips_list.push(task_tips_vo)
					j = j + 1
				} while ((j < task_tips_len))
				let task_cfg = model.GetTaskCfg(task_id)
				if (task_cfg) {
					if (task_cfg.type == local_TaskType.MAIN_LINE) {
						let not_finish_vo = task_tips_vo
						for (let _tmpi in task_tips_list) {
							var vo = task_tips_list[_tmpi]
							if (vo.has_finish != 1) {
								not_finish_vo = vo
								break
							}
						}
						model.SetMainLineTaskVo(not_finish_vo)
					} else if (task_cfg.type == local_TaskType.REINCARNATION) {
						for (let _tmpi in task_tips_list) {
							var vo = task_tips_list[_tmpi]
							if (vo.new_finish_flag && vo.task_tips_type != TaskTipType.FinDungeon) {
								OpenFun.OpenFunHandler(18)
								break
							}
						}
						model.SetReincarnationTaskList(task_tips_list)
					}
				}
			}
			return [task_id, task_tips_list]
		}

		this.ShowSuccessEffect = () => {
			if (this.success_effect_id) {
				ParticleManager.GetInstance().DelEffect(this.success_effect_id)
				this.success_effect_id = false
			}

			if (!this.success_effect_id) {

				GlobalEventSystem.Fire(EventName.SHOW_EFFECT, Enum_UILayer.ClickEffect, "ui_renwuwancheng", { x: 0, y: 4 }, 1, 1.5)
				// this.success_effect_id = ParticleManager.GetInstance().AddTargetEffect( "ui_renwuwancheng", Scene.GetInstance().main_role.compress_id, false, null, null, 15,() => {

				// 	},null,null,null,() => {
				// 		}, null, null, new Vector3(0, -4.5, 0), EffectResType.UI)
			}

			// if (this.success_effect_id) {
			// 	ParticleManager.GetInstance().DelEffect(this.success_effect_id)
			// 	this.success_effect_id = false
			// }

			// if (!this.success_effect_id && Scene.GetInstance() && Scene.GetInstance().main_role) {
			// 	let pos = Scene.GetInstance().main_role.real_pos
			// 	let main_role = Scene.GetInstance().main_role
			// 	if (main_role) {
			// 		let y = main_role.res_size.y + 200
			// 		this.success_effect_id = ParticleManager.GetInstance().AddPosEffect("ui_shengjitexiao", new Vector2(pos.x, pos.y - y), false, null, null, false, main_role.compress_id, null, null, null, null, () => {
			// 		}, null, null, null, EffectResType.UI)
			// 	}
			// }
		}

		this.InitInfo()
		this.InitEvents()
	}
}



window["TaskController"] = TaskController
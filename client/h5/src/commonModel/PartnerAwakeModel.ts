import { CommonManager } from "../common/CommonManager"
import { Config } from "../common/Config"
import { EventName } from "../common/EventName"
import { MainFunc } from "../commonModel/MainUIModel"
import { TaskModel, TaskTipType } from "../commonModel/TaskModel"

import { RoleManager } from "./RoleManager"
import { SceneManager } from "../scene/SceneManager"
import { TaskVo } from "../sharedata/TaskVo"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventDispatcher } from "../util/EventDispatcher"
import { GoodsModel } from "./GoodsModel"
import { MapModel } from "./MapModel"
import { PartnerAwakeEvent } from "./PartnerAwakeEvent"
import { RedKey } from "../common/RedDotDefine"

export class PartnerAwakeModel extends EventDispatcher {
	public static Instance;

	first_show
	last_click_time
	red_dot_state
	unlock_new_step

	pre_client_cfgs = Config.PRELOAD_CLIENT_CONFIG

	public constructor() {
		super()

		if (PartnerAwakeModel.Instance) {
			return
		}
		PartnerAwakeModel.Instance = this
		this.last_click_time = 0
		this.first_show = null
		this.unlock_new_step = false
		this.red_dot_state = false
	}

	public static GetInstance() {

		if (!PartnerAwakeModel.Instance) {
			PartnerAwakeModel.Instance = new PartnerAwakeModel()
		}
		return PartnerAwakeModel.Instance
	}

	//红点
	public RedDotFun() {
		this.red_dot_state = this.CanOpenPartnerAwakeView() && (this.TaskUnLock() || this.StepRedDot(1) || this.StepRedDot(2))
		GlobalEventSystem.Fire(EventName.REFRESH_ACTIVITY_ICON_RED_DOT, this.pre_client_cfgs.ConfigPartnerAwake.ParnterIconId, this.red_dot_state)
		GlobalEventSystem.Fire(EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Pet)
		this.Fire(PartnerAwakeEvent.PARTNER_AWAKE_UPDATE_RED_DOT)
		let task_model = TaskModel.GetInstance()
		if(task_model.HavePartnerAwakeTask()){
			RedDotController.ins.up(RedKey.PARTNER_AWAKE, this.red_dot_state ? 1 : 0);
		}else{
			RedDotController.ins.up(RedKey.PARTNER_AWAKE, 0);
		}
		return this.red_dot_state
	}

	//解锁任务第二阶段
	public UnlockNewStep(task_id?) {

		if (this.pre_client_cfgs.ConfigPartnerAwake.TaskView && this.pre_client_cfgs.ConfigPartnerAwake.TaskView.task_list.main_task_id == task_id) {
			this.unlock_new_step = true
		}
	}

	//首次登陆或新任务解锁
	public TaskUnLock() {
		let bool = false
		let task_list = TaskModel.GetInstance().GetHasReceiveTaskList(this.pre_client_cfgs.ConfigPartnerAwake.TaskView.root_task_id)
		if (task_list) {
			if (this.first_show) {
				bool = true
			}
			if (bool == false) {
				bool = this.unlock_new_step
			}
		}
		return bool
	}

	//任务阶段红点
	public StepRedDot(step?) {
		let red_dot = false
		if (this.pre_client_cfgs.ConfigPartnerAwake.TaskView) {
			let task_list_cfg = this.pre_client_cfgs.ConfigPartnerAwake.TaskView.task_list.stone_task_list
			if (step == 2) {
				task_list_cfg = this.pre_client_cfgs.ConfigPartnerAwake.TaskView.task_list2.stone_task_list
			}
			if (task_list_cfg) {
				let task_vo_list
				let task_vo
				let task_model = TaskModel.GetInstance()
				for (let i = 0; i < task_list_cfg.length; i++) {
					let v = task_list_cfg[i]
					task_vo_list = task_model.GetHasReceiveTaskList(v.task_id)
					if (task_vo_list && task_vo_list[0]) {
						task_vo = task_vo_list[0]
						red_dot = this.TaskVoRedDot(task_vo)
						if (red_dot) {
							break
						}
					}
				}
			}
		}
		return red_dot
	}

	//任务红点
	public TaskVoRedDot(task_vo?) {
		let red_dot = false
		if (task_vo) {
			if (task_vo.task_tips_type == TaskTipType.Coin) {
				let tong = RoleManager.GetInstance().GetMainRoleVo().tong
				red_dot = tong >= task_vo.need_num
			} else {
				red_dot = task_vo.has_finish == 1
				if(task_vo.task_tips_type == TaskTipType.Cost_goods){
					let num=GoodsModel.GetInstance().GetBagGoodsNum(task_vo.id)
					red_dot =num >= task_vo.need_num
				}
			}
			if (!red_dot) {
				if (task_vo.task_tips_type == TaskTipType.Cost_goods) {	//收集物品
					if (task_vo.scene_id && SceneManager.GetInstance().IsFieldBossScene(task_vo.scene_id)) {	//需要杀世界boss， 获取掉落
						if (!CommonManager.GetInstance().CheckFuncOpenState("BossFieldEnterView", true)
							|| TaskModel.GetInstance().newest_finish_task_id < this.pre_client_cfgs.ConfigPartnerAwake.FirstBossTaskId) {

						} else {
							let boss_id
							if (this.pre_client_cfgs.ConfigPartnerAwake.TaskIdToBossId) {
								boss_id = this.pre_client_cfgs.ConfigPartnerAwake.TaskIdToBossId[task_vo.task_id]
							}
							if (boss_id) {
								/*缺失BossModel
								let boss_type_info = BossModel.GetInstance().GetBossTypeInfo(BossModel.BossType.field)
								let boss_info = BossModel.GetInstance().GetBossInfo(BossModel.BossType.field, boss_id)
								if (boss_type_info && boss_info) {
									red_dot = (boss_type_info.all_tired - boss_info.tired_add) > 0
								}
								*/
							}
						}
					} else {
						red_dot = MapModel.GetInstance().FiledSceneCanEnter(task_vo.scene_id)
					}
				} else {
				}
			}
		}
		return red_dot
	}

	//是否可以打开界面
	public CanOpenPartnerAwakeView() {
		let task_model = TaskModel.GetInstance()
		if (SceneManager.GetInstance().IsExpDungeon()) {
			if (task_model.newest_finish_task_id >= this.pre_client_cfgs.ConfigPartnerAwake.ExpDungeonTaskId) {
				return true
			}
		} else {
			let [has, task_vo] = task_model.HavePartnerAwakeDungeonTask()
			if (task_model.newest_finish_task_id >= this.pre_client_cfgs.ConfigPartnerAwake.ExpDungeonTaskId
				|| (has && task_vo && task_vo.has_finish == 1)) {
				return true
			}
		}
		return false
	}
}
window["PartnerAwakeModel"] = PartnerAwakeModel
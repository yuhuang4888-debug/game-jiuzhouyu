import { BaseView1, CloseMode } from "../common/BaseView1"
import { EventName, ObjectEventType, SceneEventType } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { TaskModel } from "../commonModel/TaskModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Scene } from "../scene/Scene"
import { EffectResType, MonsterType, SceneBaseType } from "../scene/SceneConfig"
import { SceneManager } from "../scene/SceneManager"
import { FindVo } from "../scene/sceneobj/FindVo"
import { SceneObj } from "../scene/sceneobj/SceneObj"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { PoseState } from "../util/StateMachineManager"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest, SetAnchoredPositionY } from "../util/Util"
import { ResManager } from "../common/ResManager"
import { TreasureMapModel } from "../commonModel/TreasureMapModel"
import { ParticleManager } from "../particalEffect/ParticleManager"

export class CollectBarView extends BaseView1 {


	addMonster_timer_id
	blood_time
	call_back
	close_call_back
	cancel_collect_id
	server_cancel_collect_id
	cancel_next_id
	close_callback
	close_mode
	collectText
	collect_time
	collecting_next_timer_id
	collecting_time_id
	complete_collect_id
	curr_progress
	destroy_callback
	game_start_id
	is_collecting
	is_fake
	is_set_order_sorting
	mainrole_move_id
	mon_id
	monset_remove_id
	open_callback
	other_collect_timer_id
	progress_width
	show_tips
	show_img
	start_collect_id
	type_id
	progress_mask: Laya.Sprite
	progress_height

	//海域特殊处理
	is_sea = false

	scene_mgr: SceneManager
	scene: Scene
	effect_id
	public static collect_total_step = 40 //总共分多少步完成采集
	public constructor() {
		super()

		this.base_file = "mainUI"
		this.layout_file = "CollectBarView"
		this.layer_value = Enum_UILayer.Main
		this.close_mode = CloseMode.CloseVisible
		this.is_collecting = false
		this.scene_mgr = SceneManager.GetInstance()
		this.scene = Scene.GetInstance()

		this.load_callback = () => {
			this.LoadSuccess()
		}

		this.open_callback = () => {

			this.is_sea = this.scene_mgr.IsSeaHegemonyScene();
			this._img_num_bg.visible = this._txt_progress.visible = this.is_sea;
			// let isTreasure: boolean = TreasureMapModel.GetInstance().GetTMCollect();
			let path // let path = isTreasure ? 'ui_cj_1003' : (this.is_sea ? "ui_cj_1002" : "ui_cj_1001");
			if(this.show_img){
				path = this.show_img
			}
			else{
				if(this.is_sea){
					path = 'ui_cj_1002'
				}else{
					path = 'ui_cj_1001'
				}
			}
			ResManager.GetInstance().SetImageSprite(this, this._img_state, "mainUI", path);

			this.display_obj.centerX = 0
			this.display_obj.bottom = 700
			this.display_obj.visible = false  //设为隐藏，开始采集之后再显示
			this.InitEvent()
			if (this.is_fake) {
				this.StartCollect()
			} else {
				this.RequestToCollect()
			}
		}

		this.close_callback = () => {
			this.Remove()
			if(this.close_call_back){
				this.close_call_back()
			}
			this.close_call_back = undefined
		}

		this.destroy_callback = () => {
			this.DestroyInfo()
		}
	}

	public DestroyInfo() {

		if (this.addMonster_timer_id != null) {
			GlobalTimerQuest.CancelQuest(this.addMonster_timer_id)
			this.addMonster_timer_id = null
		}
		if (this.other_collect_timer_id != null) {
			GlobalTimerQuest.CancelQuest(this.other_collect_timer_id)
			this.other_collect_timer_id = null
		}

		this.CancelNextOne()
		if (this.cancel_next_id) {
			GlobalEventSystem.UnBind(this.cancel_next_id)
			this.cancel_next_id = null
		}
	}

	public Remove() {

		if (this.monset_remove_id) {
			GlobalEventSystem.UnBind(this.monset_remove_id)
			this.monset_remove_id = null
		}
		if (this.game_start_id) {
			GlobalEventSystem.UnBind(this.game_start_id)
			this.game_start_id = null
		}

		if (this.mainrole_move_id) {
			GlobalEventSystem.UnBind(this.mainrole_move_id)
			this.mainrole_move_id = null
		}

		if (this.other_collect_timer_id != null) {
			GlobalTimerQuest.CancelQuest(this.other_collect_timer_id)
			this.other_collect_timer_id = null
		}

		if (this.collecting_time_id) {
			Laya.timer.clear(this, this.Collecting)
			this.collecting_time_id = false
		}

		if (this.start_collect_id != null) {
			GlobalEventSystem.UnBind(this.start_collect_id)
			this.start_collect_id = null
		}
		if (this.complete_collect_id != null) {
			GlobalEventSystem.UnBind(this.complete_collect_id)
			this.complete_collect_id = null
		}
		if (this.cancel_collect_id != null) {
			GlobalEventSystem.UnBind(this.cancel_collect_id)
			this.cancel_collect_id = null
		}
		if (this.server_cancel_collect_id != null) {
			GlobalEventSystem.UnBind(this.server_cancel_collect_id)
			this.server_cancel_collect_id = null
		}

		this.CancelCollect()
	}

	public LoadSuccess() {
		this.progress_mask = new Laya.Sprite()
		this._img_progress.mask = this.progress_mask
		this.progress_height = this._img_progress.height - 16//图片空白高度
		this.progress_width = this._img_progress.width

		this.SetProgress(0, 100)
	}

	public DrawMask = (angle) => {
		let height = this.progress_height * angle
		this.progress_mask.graphics.clear();
		this.progress_mask.graphics.drawRect(0, this.progress_height - height + 8, this.progress_width, height, 0x000000) //8上半部分空白高度
	}

	public InitEvent() {

		let cancel_collect = () => {
			if (this.is_collecting) {
				let role = this.scene.main_role
				if (role && !role.IsInState(PoseState.COLLECT)) {
					this.CancelCollect()
					if (!this.is_fake) {
						GlobalEventSystem.Fire(EventName.REQUEST_TO_COLLECT, this.mon_id, this.type_id, 3)
					}
					else {
						this.Close()
					}
				}
			}
		}
		this.mainrole_move_id = GlobalEventSystem.Bind(ObjectEventType.MAINROLE_MOVE_EVENT_IMME, cancel_collect)

		let change_scene_cancel = () => {
			if (this.is_collecting) {
				let role = this.scene.main_role
				if (role) {
					this.CancelCollect()
					if (!this.is_fake) {
						GlobalEventSystem.Fire(EventName.REQUEST_TO_COLLECT, this.mon_id, this.type_id, 3)
					}
					if (this.is_fake) {
						this.Close()
					}
				}
			}
		}
		this.game_start_id = GlobalEventSystem.Bind(SceneEventType.SCENE_CHANGED, change_scene_cancel)

		let onStartCollect = () => {
			this.StartCollect()
		}
		this.start_collect_id = GlobalEventSystem.Bind(EventName.START_TO_COLLECT, onStartCollect)

		let onCompleteCollect = () => {
			let monsterVo = SceneManager.Instance.GetMonsterVo(this.mon_id)
			if (monsterVo && monsterVo.type == MonsterType.NOT_DEAD_COLLECT) {
				//不死采集怪，不删除
				//只有任务采集怪走这里，其他的服务端移除
			} else if (monsterVo && monsterVo.type == MonsterType.TASK_COLLECT) {
				SceneManager.Instance.DeleteMonsterVo(this.mon_id)
			}
			if (monsterVo && monsterVo.type == MonsterType.TASK_COLLECT) {
				this.CancelNextOne()
				if (this.addMonster_timer_id == null) {
					let addMonster = (...new_args) => {
						if (this.addMonster_timer_id) {
							GlobalTimerQuest.CancelQuest(this.addMonster_timer_id)
							this.addMonster_timer_id = null
						}
						SceneManager.Instance.AddMonsterVo(monsterVo, true)
					}
					this.addMonster_timer_id = GlobalTimerQuest.AddDelayQuest(addMonster, 0.5)
				}
			}
			this.Close()
		}
		this.complete_collect_id = GlobalEventSystem.Bind(EventName.COMPLETE_TO_COLLECT, onCompleteCollect)

		let onCancelCollect = (code) => {
			if (!this.is_fake) {
				GlobalEventSystem.Fire(EventName.REQUEST_TO_COLLECT, this.mon_id, this.type_id, 3)
			}
			else {
				this.Close()
			}
			this.CancelCollect()
		}
		this.cancel_collect_id = GlobalEventSystem.Bind(EventName.CANCEL_TO_COLLECT, onCancelCollect)


		let sever_cancel_to_collect = (code) => {
			if (code && code == 13) {
				if(SceneManager.Instance.IsNoonPartyScene() || SceneManager.Instance.IsFeastBossScene()){
					//派对场景自己处理
					this.Close()
					return
				}
				if (this.collecting_time_id) {
					Laya.timer.clear(this, this.Collecting)
					this.collecting_time_id = false
				}
				if (this.other_collect_timer_id == null) {
					let onTimer = (...new_args) => {
						this.Close()
						this.FindNextOne()
					}
					this.other_collect_timer_id = GlobalTimerQuest.AddDelayQuest(onTimer, 1)
				}
			}
			else {
				this.Close()
			}

		}
		this.server_cancel_collect_id = GlobalEventSystem.Bind(EventName.SERVER_CANCEL_TO_COLLECT, sever_cancel_to_collect)

		let onCancelNextCollect = () => {
			this.CancelNextOne()
		}
		this.cancel_next_id = GlobalEventSystem.Bind(EventName.CANCEL_NEXT_COLLECT, onCancelNextCollect)

		let onMonsterRemove = (ins_id, type_id) => {
			if (this.mon_id == ins_id) {
				GlobalEventSystem.Fire(EventName.CANCEL_TO_COLLECT)
			}
		}
		this.monset_remove_id = GlobalEventSystem.Bind(SceneEventType.MONSTER_VO_REMOVE, onMonsterRemove)

		this.BindEvent(GlobalEventSystem, EventName.GAME_START, () => {
			this.Close()
		})
	}

	public Open(mon_id?, type_id?, collect_time?, is_fake?, call_back?, show_tips?, close_call_back?, show_img?) {
		this.mon_id = mon_id
		this.type_id = type_id
		this.collect_time = collect_time
		this.call_back = call_back
		this.is_fake = is_fake //假收集， 采集完执行回调函数就行了
		this.show_tips = show_tips || "采集中...    "
		this.close_call_back = close_call_back
		this.show_img = show_img
		super.Open()
	}

	public CancelCollect() {
		this.is_collecting = false
		this.DrawMask(0)
	}

	// 请求服务器开始采集
	public RequestToCollect() {
		this.SetProgress(0, 100)
		if (this.collecting_time_id) {
			Laya.timer.clear(this, this.Collecting)
			this.collecting_time_id = false
		}

		if (this.other_collect_timer_id != null) {
			GlobalTimerQuest.CancelQuest(this.other_collect_timer_id)
			this.other_collect_timer_id = null
		}
		this.is_collecting = true
		GlobalEventSystem.Fire(EventName.REQUEST_TO_COLLECT, this.mon_id, this.type_id, 1)
	}

	//开始显示采集进度
	public StartCollect() {

		this.display_obj.visible = true
		this.curr_progress = 0
		this.is_collecting = true
		this.blood_time = TimeUtil.getServerTime()//开始计算扣血的时间
		if (!this.collecting_time_id) {
			this.collecting_time_id = true
			Laya.timer.loop(this.collect_time / CollectBarView.collect_total_step * 1000, this, this.Collecting)
		}
	}

	// 采集进度
	public Collecting() {

		if (this.is_collecting == false) {
			if (this.collecting_time_id) {
				Laya.timer.clear(this, this.Collecting)
				this.collecting_time_id = false
			}
			// this.Close()
			return
		}

		this.curr_progress = this.curr_progress + 1
		this.SetProgress(this.curr_progress, CollectBarView.collect_total_step)

		if (this.curr_progress >= CollectBarView.collect_total_step) {
			if (this.collecting_time_id) {
				Laya.timer.clear(this, this.Collecting)
				this.collecting_time_id = false
			}
			if (this.other_collect_timer_id != null) {
				GlobalTimerQuest.CancelQuest(this.other_collect_timer_id)
				this.other_collect_timer_id = null
			}

			if (this.is_fake) {
				let monsterVo = SceneManager.Instance.GetMonsterVo(this.mon_id)
				if (monsterVo && monsterVo.type == MonsterType.NOT_DEAD_COLLECT) {
					//不是不死假采集怪杀
				} else {
					//假采集的怪物要删除怪物
					SceneManager.Instance.DeleteMonsterVo(this.mon_id)
				}
				if (this.call_back) {
					this.call_back()
				}
				this.Close()
			} else {
				GlobalEventSystem.Fire(EventName.REQUEST_TO_COLLECT, this.mon_id, this.type_id, 2)
				//GlobalEventSystem.Fire(EventName.SHOW_EFFECT, Enum_UILayer.Main, "other_effect_caiji_02", { x: 0, y: -1.5 }, 1.1, 3, null, EffectResType.Other)
			}
		}
	}

	// 寻找下一个采集物
	public FindNextOne() {
		this.CancelNextOne()
		let monster = this.scene.GetRandomMonsterByTypeId(this.type_id, this.mon_id) //随机取怪物
		if (monster) {
			let findObj = new FindVo()
			findObj.sceneId = SceneManager.Instance.GetSceneId()
			findObj.type = FindVo.POINT //不能用findVo.MONSTER，不然会去找最近的怪物的
			findObj.x = monster.GetVo().pos_x / SceneObj.GetLogicRealRatio().x
			findObj.y = monster.GetVo().pos_y / SceneObj.GetLogicRealRatio().y

			let monsterVo = monster.GetVo()
			// if (monsterVo && monsterVo.type == MonsterType.TASK_COLLECT) {
			// 	let have_task, monster_id = TaskModel.GetInstance().HaveCaiJiTask(monsterVo.type_id)
			// 	if (have_task) {
			// 		findObj.is_task_find_way = true
			// 	}
			// }

			let call_back = () => {
				this.scene.MainRoleAttackMonster(monster)
				if (this.scene_mgr.IsWeddingScene() ||
					this.scene_mgr.IsFeastBossScene()) {
					GlobalEventSystem.Fire(EventName.STARTAUTOFIGHT)
				}
			}
			findObj.call_back = call_back
			GlobalEventSystem.Fire(EventName.FIND, findObj)
		}
	}

	// 寻找附近的采集物
	public FindNearCollectMon(bool_same?) {

		this.CancelNextOne()
		let monster = null
		if (bool_same) {
			monster = this.scene.GetRandomMonsterByTypeId(this.type_id, this.mon_id) //随机取同类型怪物
		} else {
			let mon_list = this.scene.FindNearestTarget(10000, null, null, null, Scene.FIND_TARGET_TYPE.monster) //附近随机取怪物
			monster = mon_list[0]
		}
		if (monster) {
			let findObj = new FindVo()
			findObj.sceneId = SceneManager.Instance.GetSceneId()
			findObj.type = FindVo.POINT //不能用findVo.MONSTER，不然会去找最近的怪物的
			findObj.x = monster.GetVo().pos_x / SceneObj.GetLogicRealRatio().x
			findObj.y = monster.GetVo().pos_y / SceneObj.GetLogicRealRatio().y
			let call_back = () => {
				this.scene.MainRoleAttackMonster(monster)
				GlobalEventSystem.Fire(EventName.STARTAUTOFIGHT)
			}
			findObj.call_back = call_back
			GlobalEventSystem.Fire(EventName.FIND, findObj)
		}
	}

	// 取消自动采集
	public CancelNextOne() {

		if (this.collecting_next_timer_id) {
			GlobalTimerQuest.CancelQuest(this.collecting_next_timer_id)
			this.collecting_next_timer_id = null
		}
	}

	public SetProgress(curr_value?, max_value?) {
		this.DrawMask(curr_value / max_value)

		if (this.is_sea) {
			this._txt_progress.changeText(`修复中...${Math.floor(curr_value / max_value * 100)}%`)
		}

	}


	_img_bg: Laya.Image
	_img_progress: Laya.Image
	_img_num_bg: Laya.Image
	_txt_progress: Laya.Text
	_img_state: Laya.Image
	public GetComponents() {
		[
			this._img_bg,
			this._img_progress,
			this._img_num_bg,
			this._txt_progress,
			this._img_state,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_img_progress",
				"_img_num_bg",
				"_txt_progress",
				"_img_state",
			])
	}
}
window["CollectBarView"] = CollectBarView
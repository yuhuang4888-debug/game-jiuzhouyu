import { Alert, Alert_Type } from "../alert/Alert"
import { BaseItem1 } from "../common/BaseItem1"
import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { BossModel } from "../commonModel/BossModel"
import { TaskModel, TaskType } from "../commonModel/TaskModel"
import { SceneManager } from "../scene/SceneManager"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { Util } from "../util/Util"


export class EudaemonShopTaskItem extends BaseItem1 {

	data
	model
	need_refresh_data
	public constructor(parent) {
		super(parent)


		this.base_file = "eudaemon"
		this.layout_file = "EudaemonShopTaskItem"
		this.model = BossModel.GetInstance()

		this.load_callback = () => {
			this.LoadSuccess()
		}
	}

	public LoadSuccess() {
		this._html_tips.style.color = "#663915"
		this._html_tips.style.fontSize = 18
		this._html_tips.style.wordWrap = false
		this._html_tips.style.align = "centor"

		Util.AddClickEvent(this._box_go, () => {
			if (this.data) {


				if(SceneManager.GetInstance().IsNotChangeScene()){
					Message.show("当前场景不能进入")
					return
				}

				if(this.data.index!=2){
					GlobalEventSystem.Fire(EventName.CLOSE_VIEW, "EudaemonTaskView")
					GlobalEventSystem.Fire(EventName.CLOSE_VIEW, "CrossServerEnterView")
				}
				
			
				if (SceneManager.GetInstance().IsHolyBossScene()) {
					GlobalEventSystem.Fire(EventName.OPEN_BOSS_ENTER_VIEW, null, null, false)
				}
				if (1 == this.data.index) {
					this.model.get_eudamon_task = true
					if (SceneManager.GetInstance().IsHolyBossScene()) {
						let taskInfo1 = TaskModel.GetInstance().HaveThisTypeTask(TaskType.EUDAEMON_TASK)
						if (!taskInfo1) {
							TaskModel.GetInstance().Fire(TaskModel.REQUEST_CCMD_EVENT, 30011, TaskType.EUDAEMON_TASK)
						}
						return
					}

					let enter_func = () => {
						let task = TaskModel.GetInstance().GetTypeTask(TaskType.EUDAEMON_TASK)
						let sceneId = null
						if (task) {
							sceneId = task.scene_id
						}
						this.model.EudaemonEnterScene(null, sceneId)
						TaskModel.GetInstance().now_do_task_type = TaskType.EUDAEMON_TASK
					}

					
					if (!SceneManager.GetInstance().IsFieldScene()) {
						Alert.Show("是否离开当前场景?", Alert_Type.Two, () => {
							enter_func()
						}
							, null, "离开", "取消")
					} else {
						enter_func()
					}
				} else if (3 == this.data.index) {
					if (SceneManager.GetInstance().IsHolyBossScene()) {
						this.model.Fire(BossModel.COLLECT_BOX, BossModel.CRYSTAL_TYPE)
						return
					}

					let collect_func = () => {
						this.model.EudaemonEnterScene(true)
					}

					this.model.find_cry_stal = true
					if (!SceneManager.GetInstance().IsFieldScene()) {
						Alert.Show("是否离开当前场景?", Alert_Type.Two, () => {
							collect_func()
						}, null, "离开", "取消")
					} else {
						collect_func()
					}
				}else if (2 == this.data.index) {
					this.model.Fire(BossModel.BOSS_EUDA_BOSS_UPDATE_VIEW)
					GlobalEventSystem.Fire(EventName.CLOSE_VIEW, "EudaemonTaskView")
				}
			}
		}
			, this, true)

		this.BindEvent(TaskModel.GetInstance(), TaskModel.UPDATE_CIRCLE_TASK_PROGRESS, () => {
			if (this.data && this.data.index == 0) {
				this.UpdateItem()
			}
		}
		)

		if(this.need_refresh_data){
			this.UpdateItem()
			this.need_refresh_data = false
		}
	}

	public SetData(data) {
		this.data = data
		if (this.is_loaded) {
			this.UpdateItem()
		}
		else {
			this.need_refresh_data = true
		}
	}

	public UpdateItem() {

		ResManager.GetInstance().SetImageSprite(this, this._img_icon, this.data.icon1, this.data.icon2)
		this._html_tips.innerHTML = this.data.str
		this._lb_go.text = "前往"
		this._img_go_red.visible = false
		if (1 == this.data.index) {
			let taskInfo1 = TaskModel.GetInstance().circle_task_progress_data[TaskType.EUDAEMON_TASK]
			if (taskInfo1) {
				this._lb_count.text = taskInfo1.finish_num + "/" + taskInfo1.all_num
			} else {
				this._lb_count.text = "未领取"
			}
			this._img_go_red.visible = taskInfo1 && taskInfo1.finish_num < taskInfo1.all_num
		} else if (2 == this.data.index) {
			let info = this.model.GetBossTypeInfo(BossModel.BossType.holy)
			if (info) {
				this._lb_count.text = info.tired + "/" + info.max_tired
			}
			this._img_go_red.visible = info && info.tired < info.max_tired
		} else if (3 == this.data.index) {
			let bossInfo = this.model.GetBossTypeInfo(BossModel.BossType.holy)
			let collect_list = bossInfo && bossInfo.collect_list
			if (collect_list) {
				for (let _tmpi in collect_list) {
					var vo = collect_list[_tmpi]
					if (vo.type == 3) {
						this._lb_count.text = vo.collect_times + "/" + vo.total_collect_times
						this._img_go_red.visible = vo.collect_times < vo.total_collect_times
						return
					}
				}
			}
		}
	}

	_img_bg: Laya.Image
	_img_bg2: Laya.Image
	_img_icon: Laya.Image
	_img_bg3: Laya.Image
	_lb_count: Laya.Label
	_html_tips: Laya.HTMLDivElement
	_box_go: Laya.Box
	_img_go: Laya.Image
	_lb_go: Laya.Label
	_img_go_red: Laya.Image
	public GetComponents() {
		[
			this._img_bg,
			this._img_bg2,
			this._img_icon,
			this._img_bg3,
			this._lb_count,
			this._html_tips,
			this._box_go,
			this._img_go,
			this._lb_go,
			this._img_go_red,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_img_bg2",
				"_img_icon",
				"_img_bg3",
				"_lb_count",
				"_html_tips",
				"_box_go",
				"_img_go",
				"_lb_go",
				"_img_go_red",
			])
	}
}
window["EudaemonShopTaskItem"] = EudaemonShopTaskItem
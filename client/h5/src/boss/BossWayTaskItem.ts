import { BaseItem1 } from "../common/BaseItem1"
import { CommonManager } from "../common/CommonManager"
import { Config } from "../common/Config"
import { WordManager } from "../common/WordManager"
import { BossModel } from "../commonModel/BossModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { TaskModel, TaskType } from "../commonModel/TaskModel"
import { Util } from "../util/Util"

export class BossWayTaskItem extends BaseItem1 {

	data
	select_status
	need_refresh
	index
	public static width = 236
	public static height = 83
	public constructor(parent) {
		super(parent)


		this.base_file = "boss"
		this.layout_file = "BossWayTaskItem"

		this.load_callback = () => {
			if (this.need_refresh) {
				this.dataChanged()
				this.need_refresh = false
			}
			this.getLb.text = "点击接取"
			// AddUnderlineText(this.getLb, this.getLb, ColorUtil.GetColorLight(ColorType.GREEN), 3, 0)
			Util.AddClickEvent(this.clickGp, () => {
				this.ClickFunc()
				this.SetSelect(true)
				BossModel.GetInstance().Fire(BossModel.SELECT_TASK_ITEM, this.index)
			},this)
			//if (this.select_status ) {
			this.SetSelect(this.select_status)
			//}
			this.BindEvent(BossModel.GetInstance(), BossModel.SELECT_TASK_ITEM, (index?) => {
				if (index != this.index) {
					this.SetSelect(false)
				}
			})
		}
	}

	public ClickFunc() {

		if (this.data) {
			if (this.data.finish) {
				this.selectImg.visible = false
				return
			}
			if (this.data.now_num && this.data.now_num == this.data.need_num) {
				if (this.task_model.ThisTaskTypeCanShowView(this.data)) {
					this.task_model.Fire(TaskModel.TASK_OPEN_VIEW, "TaskFinishView", this.data)
				} else {
					this.task_model.Fire(TaskModel.REQUEST_CCMD_EVENT, 30004, this.data.task_id)
				}
			} else if (this.data.task_id) {
				if (this.data.task_id == CommonManager.GetInstance().GetValue(4700006)) {
					BossModel.GetInstance().Fire(BossModel.COLLECT_BOX, BossModel.CRYSTAL_TYPE)
				} else {
					TaskModel.GetInstance().now_do_task_type = TaskType.EUDAEMON_TASK
					TaskModel.GetInstance().DoTask(this.data)
				}
			} else {
				TaskModel.GetInstance().now_do_task_type = TaskType.EUDAEMON_TASK
				TaskModel.GetInstance().Fire(TaskModel.REQUEST_CCMD_EVENT, 30011, TaskType.EUDAEMON_TASK)
			}
		}
	}

	//function BossWayTaskItem.createChildren()
	//super.createChildren()
	//this.getLb.textFlow = Util.StrToHTML("<font u=true>点击接取</font>")
	//}

	public SetData(data?, index?) {

		this.data = data
		this.index = index
		if (this.is_loaded) {
			this.dataChanged()
		} else {
			this.need_refresh = true
		}
	}

	public dataChanged() {

		if (this.data.task_id) {
			let msg = ""
			let taskCfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_task.name, this.data.task_id, false)
			// let taskCfg = ConfigItemMgr.Instance.GetTaskData(this.data.task_id)
			if ((taskCfg && taskCfg.kind != 3) && taskCfg.type == TaskType.EUDAEMON_TASK) {
				let monster = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_mon.name, this.data.id, false)
				if (monster) {
					msg = "击杀" + monster.name
				} else {
					let goodsBasic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(this.data.id)
					if (goodsBasic) {
						msg = "收集" + goodsBasic.goods_name
					}
				}
			} else {
				let goodsBasic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(this.data.id)
				if (goodsBasic && goodsBasic.type_id != 319) {
					msg = "收集" + goodsBasic.goods_name
				} else {
					let monster = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_mon.name, this.data.id, false)
					if (monster) {
						msg = "采集" + monster.name
					}
				}
			}
			let task = this.data
			if (task.has_finish && task.has_finish > 0) {
				msg = msg + "(完成)"
			} else if (task.show_num && task.show_num > 0) {
				let now_str = WordManager.FormatNumber(task.show_num)
				msg = msg + "(0/" + now_str + ")"
			} else {
				let now_str = WordManager.FormatNumber(task.now_num)
				let need_str = WordManager.FormatNumber(task.need_num)
				// [ts2lua]lua中0和空字符串也是true，此处task.need_num == task.now_num需要确认
				let color_str = (task.need_num == task.now_num && ("#b3ff48") || ("#ffef67"))
				msg = msg + "(" + now_str + "/" + need_str + ")"
			}
			let name = TaskModel.GetInstance().GetTaskNameTitle(this.data.task_id)
			if (task.task_type == TaskType.EUDAEMON_TASK) {
				let [finish_num, all_num] = TaskModel.GetInstance().GetCicleTaskProgressByTaskType(TaskType.EUDAEMON_TASK)
				if (finish_num && all_num) {
					// let color_str = (all_num == finish_num && ("#b3ff48") || ("#ffffff"))
					name = name + "(" + finish_num + "/" + all_num + ")"
				}
			}
			this.taskLb.text = Util.StrToHTML(name)
			this.desLb.text = Util.StrToHTML(msg)
			this.getImg.visible = false
			this.getLb.visible = false
		} else {
			if (this.data.finish) {
				this.clickGp.visible = false
				this.selectImg.visible = false
				this.allFinish.visible = true
				this.allBg.visible = true
			} else {
				this.taskLb.text = "[常]蜃妖试炼"
				this.desLb.text = "完成每日任务可获得悬赏积分."
				this.getImg.visible = true
				this.getLb.visible = true
			}
		}
	}

	public SetSelect(bool?) {

		this.select_status = bool
		if (this.is_loaded) {
			this.selectImg.visible = bool
		}
	}

	clickGp: Laya.Box
	_Image1: Laya.Image
	_Image2: Laya.Image
	getImg: Laya.Image
	taskLb: Laya.Label
	desLb: Laya.Label
	getLb: Laya.Label
	selectImg: Laya.Image
	allBg: Laya.Image
	allFinish: Laya.Label
	public GetComponents() {
		[
			this.clickGp,
			this._Image1,
			this._Image2,
			this.getImg,
			this.taskLb,
			this.desLb,
			this.getLb,
			this.selectImg,
			this.allBg,
			this.allFinish,
		]
			= this.GetChildrenByNames([

				"clickGp",
				"_Image1",
				"_Image2",
				"getImg",
				"taskLb",
				"desLb",
				"getLb",
				"selectImg",
				"allBg",
				"allFinish",
			])
	}
}

window["BossWayTaskItem"] = BossWayTaskItem
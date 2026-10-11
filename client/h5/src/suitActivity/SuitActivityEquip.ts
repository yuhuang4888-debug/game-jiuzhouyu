import { BaseItem1 } from "../common/BaseItem1"
import { Util } from "../util/Util"
import { OpenFun } from "../common/OpenFun"
import { Message } from "../sysInfo/SysInfoController"
import { ResManager } from "../common/ResManager"
import { TaskModel, TaskType } from "../commonModel/TaskModel"
import { SuitActivityModel } from "../commonModel/SuitActivityModel"
import { EquipmentItem } from "../common/EquipmentItem"
import { Config } from "../common/Config"

//套装活动装备Item
export class SuitActivityEquip extends BaseItem1 {
	data
	equip_item
	need_refresh
	suit_id
	res_mgr
	cfg_suit_task
	// old_active = true

	public constructor(parent) {
		super(parent)
		this.base_file = "suitActivity"
		this.layout_file = "SuitActivityEquip"

		this.res_mgr = ResManager.GetInstance()

		this.load_callback = () => {
			this._lb_getway.style.fontSize = 18
			this._lb_getway.style.color = "#ffde5c"
			this._lb_getway.style.wordWrap = false
			this._lb_getway.style.stroke = 1
			this._lb_getway.style.strokeColor = "#000000"

			this.cfg_suit_task = Config.PRELOAD_SERVER_CONFIG.config_suit_clt_task
			if (this.equip_item == null) {
				this.equip_item = new EquipmentItem(this.equip_con)
				this.equip_item.Load()
				this.equip_item.SetItemSize(85, 85)
			}
			if (this.need_refresh) {
				this.need_refresh = false
				this.SetData(this.data, this.suit_id)
			}
		}
	}

	//type_id 装备显示的id activity这个位置是否激活了 jump_id 跳转id
	public SetData(data?, suit_id?) {
		this.data = data
		this.suit_id = suit_id
		if (this.is_loaded && data && suit_id) {
			this.equip_item.SetData(data[1])
			let active = SuitActivityModel.GetInstance().GetEquipActiveStatus(suit_id, data[0])
			this.equip_item.SetGary(!active)
			// if (active && !this.old_active) {
			// 	this.AddUIEffect("ui_zhuangbeitunshi_01", this.gp_effect, null, 13, false, null, null, null, null, null, null, null, false)
			// }
			// this.old_active = active
			this.getway.visible = !active
			let getWay
			if (Number(data[2]) == 0) {
				let taskCfg = this.cfg_suit_task[suit_id + "@" + data[0]]
				getWay = taskCfg && taskCfg.desc || ""
			} else {
				getWay = OpenFun.OpenName(data[2])
			}
			this._lb_getway.innerHTML = "<a href='000'>" + getWay + "</a>"
			this.getway.callLater(() => {
				if(this.use_delete_method) return
				this._lb_getway.event(Laya.Event.RESIZE)
			})

			if (!active) {
				let ClickFun = () => {
					if (this.data) {
						if (Number(this.data[2]) == 0) {
							let taskCfg = this.cfg_suit_task[this.suit_id + "@" + this.data[0]]
							let taskId = taskCfg && taskCfg.task_id
							if (taskId) {
								let taskDesCfg = TaskModel.GetInstance().GetTaskCfg(taskId)
								if (taskDesCfg) {
									let taskVo = TaskModel.GetInstance().GetHasReceiveTaskList(taskId)
									if (taskVo && taskVo.length > 0 || taskDesCfg.type == TaskType.MAIN_LINE) {
										SuitActivityModel.GetInstance().Fire(SuitActivityModel.CLOSE_SUIT_VIEW)
										TaskModel.GetInstance().DoTask(taskVo && taskVo[1])
									} else {
										Message.show("未接取任务")
									}
								}
							}
						} else {
							OpenFun.OpenFunHandler(this.data[2])
						}
					}
				}
				Util.AddClickEvent(this.getway, ClickFun, this, false)
			}
		}
		else {
			this.need_refresh = true
		}
	}

	public Refresh() {
		if (!this.is_loaded) {
			return
		}
		this.SetData(this.data, this.suit_id)
	}

	public DeleteMe() {
		if (this.equip_item) {
			this.equip_item.DeleteMe()
			this.equip_item = null
		}
		// this.old_active = true
		super.DeleteMe()
	}

	equip_con: Laya.Box
	getway: Laya.HBox
	_lb_getway: Laya.HTMLDivElement
	gp_effect: Laya.Box
	public GetComponents() {
		[
			this.equip_con,
			this.getway,
			this._lb_getway,
			this.gp_effect,
		]
			= this.GetChildrenByNames([
				"equip_con",
				"getway",
				"_lb_getway",
				"gp_effect",
			])
	}
}
window["SuitActivityEquip"] = SuitActivityEquip
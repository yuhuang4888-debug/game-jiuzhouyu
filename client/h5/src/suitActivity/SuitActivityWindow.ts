import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { Config } from "../common/Config"
import { table } from "../common/table"
import { Mathf } from "../util/Mathf"
import { RoleManager } from "../commonModel/RoleManager"
import { ResManager } from "../common/ResManager"
import { SuitActivityModel } from "../commonModel/SuitActivityModel"

import "./SuitActivityView"
import "./SuitActivityPanel"
import "./SuitActivityActiveView"
import { TaskTipType } from "../commonModel/TaskModel"

export class SuitActivityWindow extends BaseWindowComponent {
	arg_list
	bg_list
	model
	money_list
	suit_cfg_list
	suit_id_to_index
	tabStrList
	titleStr
	viewClassList
	res_mgr

	public constructor() {
		super()
		// this.destroy_child_imm = true
		this.dependent_res = ["suitActivity"]
		// this.titleList = [
		// 	"suitActivity.ui_title_ss1"
		// ]
		this.titleStr = "suitActivity.ui_title_ss1"
		this.money_list = [2, 1, 0]
		this.tabStrList = []
		this.model = SuitActivityModel.GetInstance()
		this.res_mgr = ResManager.GetInstance()
		
		this.window_load_back = () => {
			//this.cfg_suit_clt = this.res_mgr.GetGameConfigFromCache(this, "config_suit_clt", false)
		}

		this.window_open_back = () => {
			this.SetFinish()
			this.SetReddot()
			let index
			for (let i in this.model.red_list) {
				let vo = this.model.red_list[i]
				if (vo) {
					index = Number(i) - 1
					break
				}
			}
			if (!index) {
				index = 0
				for (let _ in this.model.finish_list) {
					let vo = this.model.finish_list[_]
					if (vo) {
						index = Number(_)-1
					} else {
						break
					}
				}
			}
			this.SetDefaultIndex(index)
		}
	}

	//设置完成状态
	public SetFinish() {
		for (let index in this.suit_id_to_index) {
			let vo = this.suit_id_to_index[index]
			this.SetTabFinishState(vo, this.model.finish_list[index])
		}

		this.BindEvent(this.model, SuitActivityModel.UPDATE_ONE_SUIT, (vo?) => {
			if (vo.cur_stage == 8) {
				this.SetTabFinishState(this.suit_id_to_index[vo.suit_id], true)
			}
		})
	}

	//设置红点状态
	public SetReddot() {
		for (let suit_id in this.suit_id_to_index) {
			let index = this.suit_id_to_index[suit_id]
			this.SetTabRedDotState(index, this.model.red_list[suit_id])
		}

		this.BindEvent(this.model, SuitActivityModel.UPDATE_TAB_RED, (suit_id?, bool?) => {
			let index = this.suit_id_to_index[suit_id]
			this.SetTabRedDotState(index, bool)
		})
	}

	public GetWindowSubData() {
		this.suit_cfg_list = []
		let cfg = Config.PRELOAD_SERVER_CONFIG.config_suit_clt
		let sub_table = []
		this.suit_id_to_index = []
		this.viewClassList = []
		this.arg_list = []
		this.bg_list = []
		let career = RoleManager.GetInstance().GetMainRoleCareer()
		let level = RoleManager.GetInstance().GetMainRoleLevel()
		let turn = RoleManager.GetInstance().GetMainRoleTurn()

		for (let _ in cfg) {
			let vo = cfg[_]
			if (career == vo.career && level >= vo.open_lv && turn >= vo.open_turn) {
				let sub_vo = {
					label: vo.name,
					suit_id: vo.suit_id,
					image: {
						show: false
					}
				}
				table.insert(sub_table, sub_vo)
				table.insert(this.viewClassList, "SuitActivityView")
				table.insert(this.bg_list, "ui_sstz_013.jpg")
			}
		}
		table.sort(sub_table, (a?, b?) => {
			return a.suit_id < b.suit_id
		})
		this.tabStrList = sub_table
		let index = 0
		for (let i = 0; i < sub_table.length; i++) {
			this.suit_id_to_index[sub_table[i].suit_id] = index
			this.arg_list[i] = sub_table[i].suit_id
			index = index + 1
		}
	}

	public SetTabFinishState(index?, status?) {
		this.SetTabImage(index, status, "uisstz_023", 4, 20)
	}

	//1 - 0 2 -
	public SetContentPos(index?) {
		if (index == null) {
			return
		}
		/*
		let viewport_width = this.tabWindowComponent.scroll_tab.sizeDelta.x
		let total_width = this.tabWindowComponent.tab_res_list.length * 100
		let need_width = (index - 2) * 100
		let size_x = - Mathf.Clamp(need_width, 0, total_width - viewport_width)
		this.tabWindowComponent.content.anchoredPosition = Vector2(size_x, 0)
		*/
	}

	public SetTabRedDotState(index?, status?) {
		this.SetTabRed(index, status)
	}
	public Close() {
		if (this.task_model.IsCurrMainLineTaskTipType(TaskTipType.Suit_clt)) {
			if (this.story_model.curr_view_story_step > 0) {
				this.story_model.curr_view_story_step = 0
			}
		}
		super.Close()
	}
}

window["SuitActivityWindow"] = SuitActivityWindow
import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventName } from "../common/EventName"
import { EquipModel } from "../commonModel/EquipModel"
import { CompositeModel } from "../commonModel/CompositeModel"

import "./CompositeEquipView"
import "./CompositeRankView"
import "./GodEquipBuildView"
import "./RingCompositeView"
import "./RingUpgradeView"
import { ResManager } from "../common/ResManager"
import { TaskTipType } from "../commonModel/TaskModel"

export class RedEnterView extends BaseWindowComponent {
	SelectView
	local_CloseFunc
	res_mgr
	cfg_menu
	cfg_menu_id

	public static Index = {
		Equip: 0,
		GodEquipBuild : 1,
		Ring: 2,
		Ring_Upgrade: 3
	}

	public constructor() {
		super()
		this.preload_server_config = {
			"config_compose_menu": false,
			"config_compose_menu_id": false
		}

		this.dependent_res = ["composite", "redequip", "godequipbuild", "equipCom"]
		this.tabStrList = [
			{ label: "装备合成" },
			{ label: "神装打造" },
			{ label: "戒镯升星" },
			{ label: "戒镯进阶" }
		]
		this.viewClassList = [
			"CompositeEquipView",
			"GodEquipBuildView",
			"RingCompositeView",
			"RingUpgradeView"
		]//, RedEquipView,
		this.titleStr = "composite.ui_title_merge"
		this.money_list = [2, 1, 0]
		this.bg_list = [
			"ui_role_bg5.jpg",
			"ui_merge_bg.jpg",
			"ui_role_bg5.jpg",
			"ui_role_bg5.jpg"
		]

		this.res_mgr = ResManager.GetInstance()
		let compositemodel = CompositeModel.GetInstance()
		let local_globalE = GlobalEventSystem
		let local_equipModel = EquipModel.GetInstance()
		let update_red_event = EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE
		let Local_Index = RedEnterView.Index

		this.window_load_back = () => {
			this.cfg_menu = this.res_mgr.GetGameConfigFromCache(this, "config_compose_menu", false)
			this.cfg_menu_id = this.res_mgr.GetGameConfigFromCache(this, "config_compose_menu_id", false)
		}

		this.window_open_back = () => {
			let red = compositemodel.equip_red_dot
			local_globalE.Fire(update_red_event, "RedEnterView", Local_Index.Equip, red)
			this.BindVar(compositemodel, "equip_red_dot", (event_name?, now_value?) => {
				local_globalE.Fire(update_red_event, "RedEnterView", Local_Index.Equip, now_value)
			}
			)

			let ring_red = compositemodel.RingReddot(this.cfg_menu, this.cfg_menu_id)
			local_globalE.Fire(update_red_event, "RedEnterView", Local_Index.Ring, ring_red)
			this.BindVar(compositemodel, "ring_red_dot", (event_name?, now_value?) => {
				local_globalE.Fire(update_red_event, "RedEnterView", Local_Index.Ring, now_value)
			}
			)

			let ring_upgrade_red = compositemodel.RingUpgradeReddot(this.cfg_menu, this.cfg_menu_id)
			local_globalE.Fire(update_red_event, "RedEnterView", Local_Index.Ring_Upgrade, ring_upgrade_red)
			this.BindVar(compositemodel, "ring_upgrade_red_dot", (event_name?, now_value?) => {
				local_globalE.Fire(update_red_event, "RedEnterView", Local_Index.Ring_Upgrade, now_value)
			}
			)

			let godEquip_red = local_equipModel.godEquipRedDot()
			local_globalE.Fire(update_red_event, "RedEnterView", Local_Index.GodEquipBuild, godEquip_red)
			this.BindVar(local_equipModel, "godEquip_red_dot", (event_name?, now_value?) => {
				local_globalE.Fire(update_red_event, "RedEnterView", Local_Index.GodEquipBuild, now_value)
			})

			if (this.task_model.IsCurrMainLineTaskTipType(TaskTipType.Red_equip_combine)) {
				this.destroy_imm = true
			}
		}

		this.local_CloseFunc = () => {
			compositemodel.Fire(CompositeModel.COLSE_CHOSE_EQUIPMENT_VIEW)
			if (this.task_model.IsCurrMainLineTaskTipType(TaskTipType.Red_equip_combine)) {
				if (this.story_model.curr_view_story_step > 0) {
					this.story_model.curr_view_story_step = 0
				}
			}
		}

		this.SelectView = (index?, is_real_index?) => {
			if (is_real_index == null) {
				is_real_index = true
			}
			let real_index = index
			compositemodel.selectViewIndex = this.real_index_to_index[real_index]
			super.SelectView(index, is_real_index)
		}
	}

	public Open(...new_args) {
		let index = new_args[0]
		if (index != null) {
			this.SetDefaultIndex(index)
		}
		if (this.task_model.IsCurrMainLineTaskTipType(TaskTipType.Red_equip_combine)) {
			this.SetDefaultIndex(0, true)
		}
		super.Open()
	}

	public Close() {
		this.local_CloseFunc()
		super.Close()
	}
}
window["RedEnterView"] = RedEnterView
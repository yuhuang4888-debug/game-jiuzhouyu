import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { EventName } from "../common/EventName"
import { BagModel } from "../commonModel/BagModel"
// import { DragonBallModel } from "../commonModel/DragonBallModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { GuardModel } from "../commonModel/GuardModel"
// import { HolySealModel } from "../commonModel/HolySealModel"
import { RoleManager } from "../commonModel/RoleManager"
import { RevelationEvent, RevelationModel } from "../commonModel/RevelationModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import "./BagComponentView"
import "./WarehouseView"
import "../holySeal/HolySealView"
import { HolySealModel } from "../commonModel/HolySealModel"
import "../revelation/RevelationEquipView"
import { TaskTipType } from "../commonModel/TaskModel"
import { ModuleType } from "../common/RedDotManager"
import { RedDotManager } from "../common/RedDotManager"
import { longlangModel } from "../commonModel/longlangModel"
import "../longlanguage/longlanguageView"
import { StoryModel } from "../commonModel/StoryModel"
import { CompositeModel } from "../commonModel/CompositeModel"

export class BagView extends BaseWindowComponent {
	tabStrList
	holy_seal_index
	UpdateRed
	bg_list
	Local_SelectView
	CheckHolySealRedDot
	CheckRevelationReddot
	destroy_imm
	model
	tab_new_cond
	is_open
	CheckBagRedDot
	titleList
	CheckLonglangRed
	viewClassList
	window_open_back
	money_list

	public constructor() {
		super()

		this.is_open = false
		this.not_show_item_use = true;
		this.model = BagModel.GetInstance()
		this.holy_seal_index = 3
		let holy_seal_model = HolySealModel.GetInstance()
		let bag_model = BagModel.GetInstance()
		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName
		let goods_model = GoodsModel.GetInstance()
		let local_GoodsModel = GoodsModel

		this.dependent_res = ["bag"]
		this.tabStrList = [
			{ label: "背包" },//, icon_up_source: "bag_json.bag_3_png", icon_down_source: "bag_json.bag_4_png" 
			{ label: "仓库" },//, icon_up_source: "bag_json.bag_1_png", icon_down_source: "bag_json.bag_2_png"
			{ label: "影装" },//, icon_up_source: "bag_json.uisy_001_02_png", icon_down_source: "bag_json.uisy_001_01_png"
			{ label: "天启" },//, icon_up_source: "bag_json.uitq_01_png", icon_down_source: "bag_json.uitq_02_png"
			{ label: "神祭" }//, icon_up_source: "bag_json.uilwmb_012a_png", icon_down_source: "bag_json.uilwmb_012_png" 
		]
		this.titleStr = "bag.title_name"
		this.viewClassList = [
			"BagComponentView",
			"WarehouseView",
			"HolySealView",
			"RevelationEquipView",
			"longlanguageView"
		]
		this.viewClassModuleDic = {
			"0": { module_name: "bag", class_name: "BagComponentView" },
			"1": { module_name: "bag", class_name: "WarehouseView" },
			"2": { module_name: "holySeal", class_name: "HolySealView" },
			"3": { module_name: "revelation", class_name: "RevelationEquipView" },
			"4": { module_name: "longlanguage", class_name: "longlanguageView" }
		}
		//, RevelationEquipView, longlanguageView
		this.money_list = [2, 1, 0]
		this.bg_list = [
			"ui_bg_1.jpg",
			"ui_bg_1.jpg",
			"ui_seal_bg.jpg",
			"ui_Apocalypse_bg.jpg",
			"ui_lybg.jpg"
		]

		this.titleList = [
			"bag.title_name",
			"bag.title_name",
			"bag.uisy_002",
			"bag.ui_Apocalypse_title",
			"bag.ui_ly_title"
		]

		this.tab_new_cond = {
			2: () => {
				let level = RoleManager.GetInstance().GetMainRoleVo().level
				return true
				// return level >= holy_seal_model.open_lv
			}
		}

		this.window_open_back = () => {
			//MapView.Instance.ChangeCollider()
			//this._img_title.source = this.titleStr
			this.CheckBagRedDot()
			this.CheckHolySealRedDot()
			this.CheckRevelationReddot()
			this.CheckLonglangRed()
			// this._img_instruction.visible = false
			bag_model.bagViewOpen[local_GoodsModel.GOODS_POS_TYPE.bag] = true
			if (this.task_model.IsCurrMainLineTaskTipType(TaskTipType.DressOrangeEquip)) {
				this.destroy_imm = true
				this._story_bar2.x = 80//第一个选项卡位置
				this.story_model.story_index = 0 //引导当前指向的tab index
				this.story_model.RegisterFinishTaskFinger(TaskTipType.DressOrangeEquip)
		}



			if (this.task_model.IsCurrMainLineTaskTipType(TaskTipType.FusionEquip)) {
				this.destroy_imm = true
				this._story_bar2.x = 80//第一个选项卡位置
				this.story_model.story_index = 0 //引导当前指向的tab index
				}
			this.story_model.story_obj = this
			}
		this.Local_SelectView = (index?) => {
			super.SelectView(index)
		}

		this.CheckBagRedDot = () => {
			let updateBagRed = () => {
				let red = bag_model.isShowRed()
				local_GlobalEventSystem.Fire(
					local_EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE,
					"BagView",
					BagModel.Index.Goods,
					red
				)
			}

			// this.BindEvent(DragonBallModel.GetInstance(), DragonBallModel.UPDATE_ICON_RED, updateBagRed)
			this.BindEvent(GuardModel.GetInstance(), GuardModel.UPDATE_RED_DOT, updateBagRed)
			this.BindEvent(
				goods_model,
				local_GoodsModel.CHANGE_BAG_LIST,
				updateBagRed
			)
			this.BindEvent(
				goods_model,
				local_GoodsModel.CHANGE_EQUIPLIST,
				updateBagRed
			)

			this.BindEvent(
				BagModel.GetInstance(),
				BagModel.UPDATE_ONE_KEY_RED,
				updateBagRed
			)

			this.BindVar(BagModel.GetInstance(), "onekeyUseRed", updateBagRed)
			this.BindVar(BagModel.GetInstance(), "useRed", updateBagRed)
			this.BindVar(BagModel.GetInstance(), "smeltRed", updateBagRed)

			updateBagRed()
		}

		this.CheckHolySealRedDot = () => {
			let red = holy_seal_model.GetRedState()
			local_GlobalEventSystem.Fire(
				local_EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE,
				"BagView",
				BagModel.Index.HolySeal,
				red
			)
		}

		this.CheckRevelationReddot = () => {
			let relelationModel:RevelationModel = RevelationModel.GetInstance()
			let redFunc = () => {
				let red = relelationModel.GetRedDot()
				local_GlobalEventSystem.Fire(
					local_EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE,
					"BagView",
					BagModel.Index.Revelation,
					red
				)
			}

			this.BindEvent(relelationModel, RevelationEvent.UPDATE_DEVOUR_RED, redFunc)
			this.BindEvent(relelationModel, RevelationEvent.UPDATE_EQUIP_RED, redFunc)
			this.BindVar(CompositeModel.GetInstance(), "revelation_red_dot", redFunc)
			this.BindVar(relelationModel, "skillRed", redFunc)
			redFunc()
		}

		this.CheckLonglangRed = () => {
			let RedFunc = () => {
				let red = (RedDotManager.GetInstance().GetRedStatus(ModuleType.LONGLANG) && RedDotManager.GetInstance().GetRedStatus(ModuleType.LONGLANG) != 0) && true || false
				local_GlobalEventSystem.Fire(local_EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "BagView", BagModel.Index.Longlang, red)
			}
			this.BindEvent(longlangModel.GetInstance(), longlangModel.REFRESH_RED, RedFunc)
			RedFunc()
		}
	}
	public Close(): void {
		if (this.task_model.IsCurrMainLineTaskTipType(TaskTipType.DressOrangeEquip)
			|| this.task_model.IsCurrMainLineTaskTipType(TaskTipType.FusionEquip)) {
			if (this.story_model.curr_view_story_step > 0) {
				this.story_model.curr_view_story_step = 0
			}
		}
		if (this.story_model.task_supplement_list["AlertTypeOne"]) {
			delete this.story_model.task_supplement_list["AlertTypeOne"]
		}
		this.story_model.story_obj = null
		super.Close()
	}
	public createChildren() {
		if (this["GetComponents"]) {
			this["GetComponents"]()
			this.is_get = true
		}
		this.story_obj_list = this.story_obj_list || {}
		this.story_obj_list[TaskTipType.FusionEquip] = [this._story_bar2,null,null,null]
		super.createChildren()
	}
}
window["BagView"] = BagView
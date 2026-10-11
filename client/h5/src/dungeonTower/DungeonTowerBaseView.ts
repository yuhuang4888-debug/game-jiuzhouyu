import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { BaseDungeonModel } from "../commonModel/BaseDungeonModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"

export class DungeonTowerBaseView extends BaseWindowComponent {
	Local_SelectView
	CheckReddot

	InitCusEvent
	_Local_Close
	public constructor() {
		super()
		this.destroy_imm = true
		this.change_scene_close = false
		this.append_to_ctl_queue = false
		let local_GlobalEventSystem = GlobalEventSystem
		let dungeon_model = BaseDungeonModel.GetInstance()
		let UPDATE_WINDOW_RED_EVENT = EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE

		this.dependent_res = ["dungeonTower"]
		this.tabStrList = [
			{ label: dungeon_model.GetLimitTowerName() }
		]
		this.titleStr = "dungeonTower.ui_copy_title1"
		this.viewClassList = [
			"DungeonTowerView"
		]
		this.viewClassModuleDic = {
			"0": { module_name: "dungeonTower", class_name: "DungeonTowerView" }
		}
		this.money_list = [2, 1, 0]
		this.bg_list = [
			dungeon_model.GetLimitTowerSkin(1)
		]

		this.titleList = [
			`dungeonTower.${dungeon_model.GetLimitTowerSkin(3)}`
		]

		this.window_open_back = () => {
			this.InitCusEvent()
			this.CheckReddot()
		}

		this.Local_SelectView = (index?) => {
			super.SelectView(index)
		}


		this.CheckReddot = () => {
			let exp_red = dungeon_model.CheckTowerRed()
			local_GlobalEventSystem.Fire(UPDATE_WINDOW_RED_EVENT, "DungeonTowerBaseView", 0, exp_red)
		}

		this.InitCusEvent = () => {
			this.BindEvent(dungeon_model, BaseDungeonModel.LIMIT_TIME_TOWER_ITEM_ROUND, () => {
				//更换背景
				ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetBigBgPath(dungeon_model.GetLimitTowerSkin(1)))
				//更换title
				ResManager.GetInstance().SetImageSprite(this, this._img_title, "dungeonTower", dungeon_model.GetLimitTowerSkin(3))

				//刷新tab bar
				this.tabStrList = [
					{ label: dungeon_model.GetLimitTowerName() }
				]
				this.InitTabItem()
			})


			this.BindEvent(dungeon_model, BaseDungeonModel.LIMIT_TIME_TOWER_UPDATE, () => {
				this.CheckReddot()
			})

		}


		this._Local_Close = () => {
			super.Close()
		}


	}


	public Close() {

		this._Local_Close()
	}



}
window["DungeonTowerBaseView"] = DungeonTowerBaseView
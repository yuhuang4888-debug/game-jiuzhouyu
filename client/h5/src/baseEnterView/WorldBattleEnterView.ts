import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { EventName } from "../common/EventName"
import { InstructionType } from "../common/InstructionType"
import { BaseDungeonModel } from "../commonModel/BaseDungeonModel"
import { DiamondFightModel } from "../commonModel/DiamondFightModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { TopPkModel } from "../commonModel/TopPkModel"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"


import "../topPk/TopPkEnterView"
import "../diamondFight/DiamondFightEnterView"
import { Kf1vnEvent, Kf1vnModel } from "../commonModel/Kf1vnModel"
import { CommonManager } from "../common/CommonManager"
export class WorldBattleEnterView extends BaseWindowComponent {

	diamond_fight_model: DiamondFightModel
	kf1vn_model: Kf1vnModel
	goods_model: GoodsModel
	topPk_model: TopPkModel
	public constructor() {
		super()

		this.kf1vn_model = Kf1vnModel.GetInstance()
		this.diamond_fight_model = DiamondFightModel.GetInstance()
		this.goods_model = GoodsModel.GetInstance()
		this.topPk_model = TopPkModel.GetInstance()
		this.destroy_imm = true


		this.LoadSuccess(true)

		this.window_load_back = () => {
			this.InitWindowEvent()
		}
	}

	public Open(...new_args) {
		let parms = new_args
		if (DiamondFightModel.MODULE_ID == parms[0]) {
			this.SetDefaultIndex(this.topPk_model.WorldBattleIndex.Diamond_Fight)
		} else if (Kf1vnModel.MODULE_ID == parms[0]) {
			this.SetDefaultIndex(this.topPk_model.WorldBattleIndex.KF1VN)
		} else if (BaseDungeonModel.MODULE_ID == parms[0]) {
			this.SetDefaultIndex(this.topPk_model.WorldBattleIndex.POLAR)
		}
		super.Open()
	}
	public LoadSuccess(not_call_super?) {

		let open_day = ServerTimeModel.GetInstance().GetOpenServerDay()
		let showTopView = open_day >= TopPkModel.GetInstance().changeViewDay
		if (showTopView) {
			// this.topPk_model.WorldBattleIndex.TOP = 0
			// this.topPk_model.WorldBattleIndex.Diamond_Fight = 1
			// this.topPk_model.WorldBattleIndex.POLAR = 2
			// this.topPk_model.WorldBattleIndex.KF1VN = 3
			this.tabStrList = [
				{ label: "巅峰竞技" },
				{ label: "勾玉擂台" },
				{ label: "极限试炼" },
				{ label: "最强王者" }
			]
			this.viewClassList = [
				"TopPkEnterView",
				"DiamondFightEnterView",
				"DungeonPolarView",
				"Kf1vnEnterView"
			]
			//this.titleStr = "arena_asset.uijj_002"
			this.titleList = [
				"arena.ui_title_forge",
				"common.uizsdz_01a",
				"arena.ui_title_forge",
				"arena.ui_title_forge"
			]
			this.money_list = [2, 1, 0]
			this.bg_list = [
				"uidfjj_002.jpg",
				"uizsdz_001.jpg",
				"ui_bg_1.jpg",
				"uikf1vn_001.jpg"
			]
			this.viewClassModuleDic = [
				{ module_name: "topPk", class_name: "TopPkEnterView" },
				{ module_name: "diamondFight", class_name: "DiamondFightEnterView" },
				{ module_name: "dungeonPolar", class_name: "DungeonPolarView" },
				{ module_name: "kf1vn", class_name: "Kf1vnEnterView" }
			]
			this.instruction_list = [InstructionType.TopPk]
		} else {
			// this.topPk_model.WorldBattleIndex.Diamond_Fight = 0
			// this.topPk_model.WorldBattleIndex.POLAR = 1
			// this.topPk_model.WorldBattleIndex.KF1VN = 2
			// this.topPk_model.WorldBattleIndex.TOP = 999

			this.tabStrList = [
				{ label: "勾玉擂台" },
				{ label: "极限试炼" },
				{ label: "最强王者" }
			]

			this.viewClassList = [
				"DiamondFightEnterView",
				"DungeonPolarView",
				"Kf1vnEnterView"
			]

			this.titleStr = "uijj_001"
			this.titleList = [
				"common.uizsdz_01a"
			]
			this.money_list = [2, 1, 0]

			this.bg_list = [
				"uizsdz_001.jpg",
				"uijdfb_034a_720x1222.jpg",
				"uikf1vn_001.jpg"
			]
			this.viewClassModuleDic = [
				{ module_name: "diamondFight", class_name: "DiamondFightEnterView" },
				{ module_name: "dungeonPolar", class_name: "DungeonPolarView" },
				{ module_name: "kf1vn", class_name: "Kf1vnEnterView" }
			]
		}
		if (!not_call_super) {
			super.LoadSuccess()
		}
	}

	public RefreshDiamondFightRed() {
		let bool = this.diamond_fight_model.GetRecordRedState()||this.diamond_fight_model.GetRedforDiamond()
		GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "WorldBattleEnterView", this.topPk_model.WorldBattleIndex.Diamond_Fight, bool)
	}

	//this.Refresh3V3Red = () => {
	//let bool = cs_pvp_model.GetAllRedStatus()
	//GlobalEventSystem:Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "WorldBattleEnterView", this.topPk_model.WorldBattleIndex.CSPVP, bool)
	//}

	public Refresh1vNRed() {
		let bool = this.kf1vn_model.HaveQuizRewardCanGet() || this.kf1vn_model.ShopRedDot()||this.kf1vn_model.CheckSignRed()
		GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "WorldBattleEnterView", this.topPk_model.WorldBattleIndex.KF1VN, bool)
	}

	public RefreshTopRed() {
		let bool = TopPkModel.GetInstance().GetRedState(true)
		GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "WorldBattleEnterView", this.topPk_model.WorldBattleIndex.TOP, bool)
	}

	public InitWindowEvent() {
		this.RefreshDiamondFightRed()
		this.Refresh1vNRed()
		if (this.topPk_model.WorldBattleIndex.TOP == 0) {
			this.RefreshTopRed()
		}
		this.BindEvent(this.diamond_fight_model, DiamondFightModel.UPDATE_RECORD_RED_STATE, () => {
			this.RefreshDiamondFightRed()
		})

		this.BindEvent(this.diamond_fight_model, DiamondFightModel.UPDATE_RED_STATE, () => {
			this.RefreshDiamondFightRed()
		})
		let refresh_1vn_dot_fun = () => {
			this.Refresh1vNRed()
		}
		this.BindVar(this.kf1vn_model, "quiz_history", refresh_1vn_dot_fun)
		this.BindEvent(this.goods_model, GoodsModel.UPDATE_SPECIAL_SCORE, refresh_1vn_dot_fun)
		this.BindEvent(this.kf1vn_model, Kf1vnEvent.KF1VN_UPDATE_RED_DOT, refresh_1vn_dot_fun)

		// this.BindEvent(GlobalEventSystem,EventName.CHANGE_WINDOW_BG,(res?) => {
		// 		this.SetBg(res)
		// 	})
	}

}
window["WorldBattleEnterView"] = WorldBattleEnterView

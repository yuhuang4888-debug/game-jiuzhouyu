import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { EventName } from "../common/EventName"
import { MainFunc } from "../commonModel/MainUIModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import "./EquipSuitView"
import "./EquipSuitMianView"
import "./JewelrySuitView"
import { EnumSuitTabType, SuitModel, SuitModelEvent } from "../commonModel/SuitModel"
import { EquipSuitMianView } from "./EquipSuitMianView"


export class EquipSuitBaseView extends BaseWindowComponent {
	public static readonly _layout_file: string = 'EquipSuitBaseView';


	InitSubEvent
	arg_list

	private get suitModel() {
		return SuitModel.GetInstance();
	}

	public constructor() {
		super()

		let local_GlobalEventSystem = GlobalEventSystem
		this.destroy_imm = true
		this.dependent_res = ["equipCom", "suit"]
		this.viewClassList = [EquipSuitMianView._layout_file, EquipSuitMianView._layout_file, EquipSuitMianView._layout_file, EquipSuitMianView._layout_file]
		this.titleStr = "suit.uitz_001";
		// 页签对应的背景图
		this.bg_list = ['ui_merge_bg.jpg', 'ui_merge_bg.jpg', 'ui_merge_bg.jpg', 'ui_merge_bg.jpg'];
		this.money_list = [2, 1, 0]
		this.is_show_tab = true
		//{装备类型(1武防，2饰品)，共鸣类型}
		// this.arg_list = [[1, 1], [1, 2], [1, 3], [2, 1]]
		this.tabStrList = [{ label: "妖魂共鸣" }, { label: "修罗共鸣" }, { label: "万物共鸣" }, { label: "饰物共鸣" }]
		// this.instruction_list = [InstructionType.EquipSuit, InstructionType.EquipSuit, InstructionType.EquipSuit, InstructionType.EquipSuit]
		this.window_load_back = () => {
			this.InitSubEvent()
			this.UpdateTabRedDot();
		}
		this.window_open_back = () => {
			this.arg_list = [[1, 1], [1, 2], [1, 3], [2, 1]]
		}
		// this.CheckRedDot = () => {
		// 	let red = equip_model.suitEquipRedList && equip_model.suitEquipRedList[1] != null
		// 	local_GlobalEventSystem.Fire(UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "EquipSuitBaseView", 0, red)

		// 	red = equip_model.suitEquipRedList && equip_model.suitEquipRedList[2] != null
		// 	local_GlobalEventSystem.Fire(UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "EquipSuitBaseView", 1, red)

		// 	red = equip_model.suitEquipRedList && equip_model.suitEquipRedList[3] != null
		// 	local_GlobalEventSystem.Fire(UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "EquipSuitBaseView", 2, red)

		// 	red = !Util.IsTableEmpty(equip_model.suitJewelRedList)
		// 	local_GlobalEventSystem.Fire(UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "EquipSuitBaseView", 3, red)

		// }

		this.InitSubEvent = () => {

			this.BindEvent(
				this.suitModel,
				SuitModelEvent.UP_SUIT_POS_INFO, () => {
					this.UpdateTabRedDot();
				}
			)

			this.BindEvent(
				this.suitModel,
				SuitModelEvent.UP_SUIT_SUCCESS, () => {
					this.UpdateTabRedDot();
				}
			)

			this.BindEvent(
				this.suitModel,
				SuitModelEvent.BACK_SUIT_SUCCESS, () => {
					this.UpdateTabRedDot();
				}
			)
		}

	}


	private UpdateTabRedDot() {
		let types: number[][] = this.suitModel.GetSuitTypeAndSubTypeList();
		for (let i = EnumSuitTabType.eDemonSoul; i <= EnumSuitTabType.eDecorations; i++) {
			let [suitType, subType] = [...types[i]];
			let red: boolean = this.suitModel.GetSuitTypeSubTypePosRedAll(suitType, subType);
			GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, EquipSuitBaseView._layout_file, i, red);
		}
	}

	public BaseWindowCloseFunc() {
		super.BaseWindowCloseFunc()
		// FunctionOpenModel.GetInstance().ClearNowStory(FuncOpenId.TaoZhuang)
		GlobalEventSystem.Fire(EventName.SWITCH_MAIN_FUNC_VIEW, MainFunc.Role)
	}


	public Open(...new_args) {
		let parms = new_args;
		this.SetDefaultIndex(this.suitModel.GetDefTabIndexRed());
		super.Open();
		// if (this.HasOpen()) {
		// 	this.LocalSetSelectIndex(parms[0]);
		// } else {
		// }

	}


}
window["EquipSuitBaseView"] = EquipSuitBaseView
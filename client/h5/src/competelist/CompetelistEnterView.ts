import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { CommonManager } from "../common/CommonManager"
import { EventName } from "../common/EventName"
import { table } from "../common/table"
import { CompeteListEvent, CompeteListModel } from "../commonModel/CompeteListModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { Split } from "../util/Util"

export class CompetelistEnterView extends BaseWindowComponent {
	CheckReddot
	GetClassIndex
	_model
	_viewTypeDic
	bg_list
	instruction_list
	money_list
	not_show_item_use
	setData
	tabStrList
	titleStr
	viewClassList
	window_load_back

	public constructor() {
		super()

		this._model = CompeteListModel.GetInstance();
		this._viewTypeDic = [];
		this.not_show_item_use = true;
		this.dependent_res = ["competelist"];
		this.titleStr = "competelist.ui_title_hd1";
		this.viewClassList = ['CompetelistView'];
		this.bg_list = ["ui_sm_009.jpg"];
		this.money_list = [2, 1, 0];


		let local_CompeteListEvent = CompeteListEvent;

		this.window_load_back = () => {

			this.BindEvent(this._model, local_CompeteListEvent.UPDATE_ENTER_VIEW_RED, (type?, subtype?) => {
				let index = this.GetClassIndex(type, subtype)
				let state = this._model.showRedDot(type, subtype)
				if (index != null) {
					GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "CompetelistEnterView", index, state)
				}
			});

			this.CheckReddot();
		}

		this.CheckReddot = () => {
			for (let key in this._viewTypeDic) {
				let element = this._viewTypeDic[key]
				let list = Split(element, "@")
				if (CommonManager.GetInstance().GetInstructionState(338)) {
					let instrList = []
					for (let key in this._viewTypeDic) {
						table.insert(instrList, "338" + list[0]);
					}
					this.instruction_list = instrList
					// this.SetInstruInex()
				}
				this._model.Fire(local_CompeteListEvent.UPDATE_ENTER_VIEW_RED, list[1], list[2])
			}
		}

		this.setData = (tabStrList?, viewTypeDic?) => {
			this.tabStrList = tabStrList
			this._viewTypeDic = viewTypeDic
		}

		this.GetClassIndex = (type?, subtype?) => {
			let _key = type + "@" + subtype
			let index = 0;
			let find = false;
			for (let key in this._viewTypeDic) {
				let element = this._viewTypeDic[key];
				if (element == _key) {
					find = true;
					break;
				}
				index = index + 1;
			}
			if (find) {
				return index;
			}
		}

	}

	public Open(...new_args) {
		let parms = new_args;
		this.SetDefaultIndex(parms[0]);
		if (parms.length > 1) {
			this.SetIndexParameter(parms[0], parms[1]);
		}
		if (this.HasOpen()) {
			this.LocalSetSelectIndex(parms[0]);
		} else {
			super.Open();
		}
	}

}
import { BaseItem1 } from "../common/BaseItem1"
import { Message } from "../sysInfo/SysInfoController"
import { LoopScrowViewMgr, LoopScrCon } from "../common/LoopScrowViewMgr"
import { chcModel } from "../commonModel/chcModel"
import { chcFuncBtn } from "./chcFuncBtn"
import { ResManager } from "../common/ResManager"

import "./chcStrenView"
import "./chcEvoView"
import "./chcMagicView"
import "./chcSoulView"

import "./chcMasterView"
import "./chcMagicAddView"
import "./chcStrenSpecView"
import "./chcStrenSpecView"

import "./chcEvoSelectView"
import "./chcEvoAttrView"
import "./chcEvoTipsView"

export class chcMainView extends BaseItem1 {
	Clear
	InitEvent
	LoadSuccess
	Scr_Scroller1
	SwitchTypeData
	TouchItemHandle
	_ac_tab
	_ecfg
	_list_tab
	_model
	cfg_pos

	public constructor(parent?) {
		super(parent)
		this.base_file = "chc"
		this.layout_file = "chcMainView"
		this.preload_server_config = {
			"config_constellation_pos": false
		}

		let viewList = []
		let default_index = 0
		let cur_index = -1
		let tabDataList = [{ id: 1, title: "强化", class: "chcStrenView" }, { id: 2, title: "进化", class: "chcEvoView" }, { id: 3, title: "觉醒", class: "chcMagicView" }, { id: 4, title: "启灵", class: "chcSoulView" }]
		this._model = chcModel.GetInstance()

		this.load_callback = () => {
			this.cfg_pos = ResManager.GetInstance().GetGameConfigFromCache(this, "config_constellation_pos", false)
			this.InitEvent()
			this.LoadSuccess()
		}

		this.Clear = () => {
			for (let _tmpi in viewList) {
				var subView = viewList[_tmpi]
				if (!subView) {
					break
				}
				subView.DeleteMe()
			}
			viewList = []
			if (this._ac_tab) {
				this._ac_tab.DeleteMe()
				this._ac_tab = null
			}
			//if (this._list_tab ) {
			//this._list_tab.removeEventListener(local_eui.ItemTapEvent.ITEM_TAP, this.TouchItemHandle, this)
			//}
		}

		this.InitEvent = () => {
			//this:BindEvent(GoodsModel.GetInstance(), GoodsModel.CHANGE_STAREQUIP,() => {
			//let stype = this.SwitchTypeData(cur_index)
			//if (! stype ) {
			//let i = 0
			//do {
			//stype = this.SwitchTypeData(i)
			//if (stype ) {
			//break
			//}
			//i=i+1
			//} while ((i < tabDataList.length))
			//}
			//}
			//)
		}

		this.LoadSuccess = () => {
			//this._ecfg = Config.Constellationpos
			this._ac_tab = new LoopScrowViewMgr()
			this._ac_tab.SetData(this._Scroller1, chcFuncBtn, tabDataList, LoopScrCon.Horizontal, 1, this.TouchItemHandle)
			//this._ac_tab = local_eui. new ArrayCollection(tabDataList)
			//this._list_tab.dataProvider = this._ac_tab
			//this._list_tab.itemRenderer = chcFuncBtn
			//this._list_tab.addEventListener(local_eui.ItemTapEvent.ITEM_TAP, this.TouchItemHandle, this)
			//this._list_tab.selectedIndex = default_index

			this._ac_tab.SetSelectIndex(default_index)

			//this.TouchItemHandle({real_index = 1})
			//this:AddUIEffect("ui_constellation_arrary", this._gp_eff, null, null, true)
			//lua_resM:GetGameConfigFromCache(this, "config_constellation_pos", false)
		}

		this.TouchItemHandle = (index?) => {
			let num_index = Number(index)
			if (cur_index == num_index) {
				return
			}
			this.SwitchTypeData(num_index, true)
		}

		this.SwitchTypeData = (index?, show?) => {
			let stype = this._model.CheckEquipReStype(this.cfg_pos, index + 1)
			if (stype != 0) {
				let data = tabDataList[index]
				cur_index = index
				//this._viewStack.selectedIndex = index
				//this._list_tab.selectedIndex = index

				let subView = viewList[index]
				//let parent = this["_Group" + (index - this._viewStack.selectedChild)]
				let parent = this["_Group" + (index + 1)]
				let view_class = window[data.class]
				if (!subView && parent && view_class) {
					subView = new view_class(parent)
					subView.Load()
					viewList[index] = subView
				}
				this.PopUpChild(subView)
				if (index == 1) {
					this._model.Fire(chcModel.SELECT_VIEW)
				}
			} else {
				if (show) {
					Message.show("穿戴圣衣后，才能操作")
				}
				if (cur_index >= 0) {
					this._ac_tab.SetSelectIndex(cur_index)
				}
				//this._viewStack.selectedIndex = cur_index
				//this._list_tab.selectedIndex = cur_index
			}
			return stype
		}
	}

	public DeleteMe() {
		this.Clear()
		super.DeleteMe()
	}

	_gp_eff: Laya.Box
	_viewStack: Laya.Box
	_Group1: Laya.Box
	_Group2: Laya.Box
	_Group3: Laya.Box
	_Group4: Laya.Box
	_Scroller1: Laya.List
	public GetComponents() {
		[
			this._gp_eff,
			this._viewStack,
			this._Group1,
			this._Group2,
			this._Group3,
			this._Group4,
			this._Scroller1,
		]
			= this.GetChildrenByNames([

				"_gp_eff",
				"_viewStack",
				"_Group1",
				"_Group2",
				"_Group3",
				"_Group4",
				"_Scroller1",
			])
	}
}
window["chcMainView"] = chcMainView
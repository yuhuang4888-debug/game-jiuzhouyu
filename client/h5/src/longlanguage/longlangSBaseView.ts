import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { Util } from "../util/Util"
import { longlangModel } from "../commonModel/longlangModel"
import { LoopScrowViewMgr, LoopScrCon } from "../common/LoopScrowViewMgr"
import { RedDotManager } from "../common/RedDotManager"
import { ModuleType } from "../common/RedDotManager"
import { EventName } from "../common/EventName"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { MainFunc } from "../commonModel/MainUIModel"
import { longlangDecTab } from "./longlangDecTab"
import { longlangDisView } from "./longlangDisView"
import { longlangDecView } from "./longlangDecView"

export class longlangSBaseView extends BaseView1 {
	CloseFunc
	InitView
	Open
	SwtichView
	_tab_list
	tabTouchHandler
	tab_loop_mgr

	public constructor() {
		super()
		this.base_file = "longlanguage"
		this.layout_file = "longlangSBaseView"
		this.layer_value = Enum_UILayer.Activity
		this.is_center = true
		this.use_background = true
		this.destroy_imm = true
		this.click_bg_toClose = true

		let model = longlangModel.GetInstance()
		let tabList_ = ["分解", "拆解"]
		let decomposeView_ = null
		let DismantleView_ = null
		let defaultInde_ = 1
		this.show_open_movie = true

		this.load_callback = () => {
			this._scroller.hScrollBarSkin = ""
			defaultInde_ = defaultInde_ || 0
		}
		this.open_callback = () => {
			this.InitView()
		}

		this.close_callback = () => {
			if (this.tab_loop_mgr) {
				this.tab_loop_mgr.DeleteMe()
				this.tab_loop_mgr = null
			}
			this.CloseFunc()
		}

		this.InitView = () => {
			if (!this.tab_loop_mgr) {
				this.tab_loop_mgr = new LoopScrowViewMgr()
				this.tab_loop_mgr.SetData(this._scroller, longlangDecTab, tabList_, LoopScrCon.Horizontal, 1, (index) => {
					this.tabTouchHandler(index)
				})
			} else {
				this.tab_loop_mgr.replaceAll(tabList_)
			}
			this.tab_loop_mgr.SetSelectIndex(defaultInde_)
			this.SwtichView(defaultInde_)
			Util.AddClickEvent(this._btn_close, () => {
				this.Close()
			}
				, this, true)
			//lua_resM:SetOutsideImageSprite(this, this._bg, GameResPath.GetIcon("bag","uisy_023"))
		}

		this.Open = (...new_args) => {
			let parms = new_args
			if (parms) {
				defaultInde_ = parms[0]
				if (this.is_loaded) {
					this.tab_loop_mgr.SetSelectIndex(defaultInde_)
					this.SwtichView(defaultInde_)
				}
			}
			super.Open()
		}

		this.SwtichView = (index?) => {
			let dec = index == model.DecIndex
			this._lb_title.text = dec ? "神祭分解" : "神祭拆解"
			if (dec) {
				if (!decomposeView_) {
					decomposeView_ = new longlangDecView(this.sub_group)
					decomposeView_.Load()
				}
				this.PopUpChild(decomposeView_)
				let redDotMgr = RedDotManager.GetInstance()
				let local_modelType = ModuleType.LONGLANG
				if (redDotMgr.CheckRedStatus(local_modelType, 3) && !model.decMaterial) {
					redDotMgr.SetRedStatus(local_modelType, 3, false)
					GlobalEventSystem.Fire(EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Bag)
					model.Fire(longlangModel.REFRESH_RED, 3)
				}
			} else if (index == model.DisIndex) {
				if (!DismantleView_) {
					DismantleView_ = new longlangDisView(this.sub_group)
					DismantleView_.Load()
				}
				this.PopUpChild(DismantleView_)
			}
		}

		this.tabTouchHandler = (index) => {
			model.DecViewIndex = index
			this.SwtichView(model.DecViewIndex)
		}

		this.CloseFunc = () => {
			if (decomposeView_) {
				decomposeView_.DeleteMe()
				decomposeView_ = null
			}
			if (DismantleView_) {
				DismantleView_.DeleteMe()
				DismantleView_ = null
			}
			defaultInde_ = 0
		}
	}

	_bg: Laya.Image
	_img_title: Laya.Image
	_lb_title: Laya.Label
	_btn_close: Laya.Image
	_scroller: Laya.List
	sub_group: Laya.Box
	public GetComponents() {
		[
			this._bg,
			this._img_title,
			this._lb_title,
			this._btn_close,
			this._scroller,
			this.sub_group,
		]
			= this.GetChildrenByNames([

				"_bg",
				"_img_title",
				"_lb_title",
				"_btn_close",
				"_scroller",
				"sub_group",
			])
	}
}
window["longlangSBaseView"] = longlangSBaseView
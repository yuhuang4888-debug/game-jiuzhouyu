import { BaseView1 } from "../common/BaseView1"
import { Util } from "../util/Util"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { LoopScrowViewMgr, LoopScrCon } from "../common/LoopScrowViewMgr"
import { StarEquipModel } from "../commonModel/StarEquipModel"
import { StarEquipBasicTab } from "./StarEquipBasicTab"
import { StarEquipBagView } from "./StarEquipBagView"
import { StarEquipDevourView } from "./StarEquipDevourView"

export class StarEquipBasicView extends BaseView1 {
	InitEvent
	LoadSuccess
	Scr_scroller
	SwtichView
	Open

	_tab_list
	_tabarr
	initTab
	tabList
	tabTouchHandler

	public constructor() {
		super()
		this.tabList = ["背包", "吞噬"]
		this.base_file = "starEquip"
		this.layout_file = "StarEquipBasicView"
		this.layer_value = Enum_UILayer.Activity
		this.is_center = true
		this.use_background = true
		this.destroy_imm = true
		this.click_bg_toClose = true

		let local_StarEquipModelIns = StarEquipModel.GetInstance()
		let bag_view = null
		let dev_view = null
		let defaultInde_;
		this.load_callback = () => {
		}

		this.open_callback = () => {
			this.InitEvent()
			this.LoadSuccess()
		}

		this.close_callback = () => {
			defaultInde_ = null;
			if (bag_view) {
				bag_view.DeleteMe()
				bag_view = null
			}
			if (dev_view) {
				dev_view.DeleteMe()
				dev_view = null
			}
			if (this._tabarr) {
				this._tabarr.DeleteMe()
				this._tabarr = null
			}
			local_StarEquipModelIns.bagSelectIndex = local_StarEquipModelIns.BagIndex
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._btn_close, () => {
				this.Close()
			}, this, true)
		}

		this.LoadSuccess = () => {
			//ResManager.GetInstance().SetOutsideImageSprite(this, this._bg, GameResPath.GetIcon("common", "uisy_023"))
			this.initTab()
		}

		this.initTab = () => {
			if (!this._tabarr) {
				this._tabarr = new LoopScrowViewMgr()
				this._tabarr.SetData(this._scroller, StarEquipBasicTab, this.tabList, LoopScrCon.Horizontal, 1, this.tabTouchHandler)
			}
			let selectIndex
			if(defaultInde_){
				selectIndex = defaultInde_
			}else{
				selectIndex = local_StarEquipModelIns.devourRed && local_StarEquipModelIns.DevourIndex || local_StarEquipModelIns.bagSelectIndex
			}
			this._tabarr.SetSelectIndex(selectIndex)
			local_StarEquipModelIns.bagSelectIndex = selectIndex
			this.SwtichView(selectIndex)
		}

		this.tabTouchHandler = (index) => {
			/*
			if (local_StarEquipModelIns.bagSelectIndex == this._tabarr.select_index) {
				return
			}
			*/
			local_StarEquipModelIns.bagSelectIndex = index
			this.SwtichView(local_StarEquipModelIns.bagSelectIndex)
		}

		this.SwtichView = (index?) => {
			//ResManager.GetInstance().SetImageSprite(this, this._img_title, "starEquip", index == local_StarEquipModelIns.BagIndex && "uitc_047" || "uitc_048", true)
			this._lb_title.text = index == local_StarEquipModelIns.BagIndex ? "背包" : "吞噬"
			
			if (index == local_StarEquipModelIns.BagIndex) {
				if (!bag_view) {
					bag_view = new StarEquipBagView(this.sub_group)
					bag_view.Load()
				}
				this.PopUpChild(bag_view)
			} else if (index == local_StarEquipModelIns.DevourIndex) {
				if (!dev_view) {
					dev_view = new StarEquipDevourView(this.sub_group)
					dev_view.Load()
				}
				this.PopUpChild(dev_view)
			}
		}

		this.Open = (...new_args) => {
			let parms = new_args
			if (parms) {
				defaultInde_ = parms[0]
				if (this.is_loaded) {
					this._tabarr.SetSelectIndex(defaultInde_)
					this.SwtichView(defaultInde_)
				}
			}
			super.Open()
		}
	}

	_bg: Laya.Image
	_Group1: Laya.Box
	_Image1: Laya.Image
	_lb_title: Laya.Label
	_btn_close: Laya.Image
	_scroller: Laya.List
	sub_group: Laya.Box
	_gp_effect: Laya.Box
	public GetComponents() {
		[
			this._bg,
			this._Group1,
			this._Image1,
			this._lb_title,
			this._btn_close,
			this._scroller,
			this.sub_group,
			this._gp_effect,
		]
			= this.GetChildrenByNames([
				"_bg",
				"_Group1",
				"_Image1",
				"_lb_title",
				"_btn_close",
				"_scroller",
				"sub_group",
				"_gp_effect",
			])
	}
}
window["StarEquipBasicView"] = StarEquipBasicView
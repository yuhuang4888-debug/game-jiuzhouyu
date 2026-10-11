import { BaseItem1 } from "../common/BaseItem1"
import { MarketModel, MarketEvent, MarketViewType } from "../commonModel/MarketModel"
import { MarketPlzListView } from "../market/MarketPlzListView"
import { MarketPlzCtrlView } from "../market/MarketPlzCtrlView"
import { MarketRadioBtn } from "../market/MarketRadioBtn"
import { MarketCircleRadioBtn } from "../market/MarketCircleRadioBtn"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { DownDropBtn } from "../common/DownDropBtn"
import { Util, SetSizeDeltaX } from "../util/Util"
import { LoopScrowViewMgr, LoopScrCon } from "../common/LoopScrowViewMgr"
export class MarketPlzView extends BaseItem1 {
	_img_bg: Laya.Image
	_group_plz: Laya.List
	_group_select: Laya.List
	_group_view: Laya.Box
	_group_drop: Laya.Box
	_dd_color: Laya.Box
	_dd_stage: Laya.Box
	_dd_star: Laya.Box
	ClickColor
	ClickStage
	ClickStar
	InitEvent
	InitView
	LocalDeleteMe
	RefuseDownBtn
	ScrScrollView
	ScrScrollView1
	SetGroupVisible
	SwitchView
	UpdateSubView
	click_fun
	click_fun1
	down_btn:DownDropBtn
	down_btn1
	down_btn2
	tab_loop_mgr
	tab_loop_mgr1
	//动态添加radio 和 单选框
	public constructor(parent?) {
		super(parent)


		this.base_file = "market"
		this.layout_file = "MarketPlzView"
		let model = MarketModel.GetInstance()
		let local_MarketEvent = MarketEvent
		let view_list_ = []
		let viewclass_list_ = [MarketPlzListView, MarketPlzCtrlView]
		let cur_index_ = -1
		let cur_select_ = 0
		let cur_view_type_ = -1
		let _set_color_ = 99
		let _set_stage_ = 99
		let _set_star_ = 99

		let tab_list = [
			"求购列表",
			"我要求购"
		]
		let tab_list1 = [
			"全部",
			"我的"
		]
		this.preload_client_config = {
			"ConfigMarket": false
		}
		this.load_callback = () => {

			this.InitView()
		}

		this.LocalDeleteMe = () => {
			for (let key in view_list_) {

				// [ts2lua]view_list_下标访问可能不正确
				view_list_[key].DeleteMe()
			}
			view_list_ = []
			if (this.tab_loop_mgr) {
				this.tab_loop_mgr.DeleteMe()
				this.tab_loop_mgr = null
			}
			if (this.tab_loop_mgr1) {
				this.tab_loop_mgr1.DeleteMe()
				this.tab_loop_mgr1 = null
			}
			if (this.down_btn) {
				this.down_btn.DeleteMe()
				this.down_btn = null
			}
			if (this.down_btn1) {
				this.down_btn1.DeleteMe()
				this.down_btn1 = null
			}
			if (this.down_btn2) {
				this.down_btn2.DeleteMe()
				this.down_btn2 = null
			}
			// this._group_plz.removeEventListener(eui.ItemTapEvent.ITEM_TAP, this.click_fun, this)
			// this._group_select.removeEventListener(eui.ItemTapEvent.ITEM_TAP, this.click_fun1, this)
		}

		this.InitEvent = () => {
			this.BindEvent(model, local_MarketEvent.PLZ_GROUP_VISIBLE, (view_type?, is_ctrl?) => {
				this.SetGroupVisible(view_type, is_ctrl)
			}
			)
		}

		this.InitView = () => {
			let market_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "ConfigMarket", true)
			if (this.use_delete_method) {
				//lua_resM:DestroyAllReferenceRes(this.hashCode)
				return
			}
			// [ts2lua]market_cfg下标访问可能不正确
			let color_cfg = []
			let j = 1
			for (let _ in market_cfg["drop_color_cfg"]) {
				var v = market_cfg["drop_color_cfg"][_]

				color_cfg[j] = v
				j = j + 1
			}
			table.sort(color_cfg, (a?, b?) => {
				return a.id < b.id
			})
			let stage_cfg = []
			let i = 1
			for (let _ in market_cfg["drop_stage_cfg"]) {
				var v = market_cfg["drop_stage_cfg"][_]

				stage_cfg[i] = v
				i = i + 1
			}
			table.sort(stage_cfg, (a?, b?) => {
				return a.id < b.id
			})
			let star_cfg = []
			let a = 1
			for (let _ in market_cfg["drop_star_cfg"]) {
				var v = market_cfg["drop_star_cfg"][_]

				star_cfg[a] = v
				a = a + 1
			}
			table.sort(star_cfg, (a?, b?) => {
				return a.id < b.id
			})

			this.down_btn = new DownDropBtn(this._dd_color)
			this.down_btn.Init(color_cfg, (index?, data?) => {

				this.ClickColor(index, data)
			}, "品质", "content", this.layer_value)
			this.down_btn.Load()
			//SetSizeDeltaX(this.down_btn.transform, 135)
			this.down_btn1 = new DownDropBtn(this._dd_stage)
			this.down_btn1.Init(stage_cfg, (index?, data?) => {

				this.ClickStage(index, data)
			}, "阶级", "content", this.layer_value, 5)
			this.down_btn1.Load()
			//SetSizeDeltaX(this.down_btn1.transform, 135)
			this.down_btn2 = new DownDropBtn(this._dd_star)
			this.down_btn2.Init(star_cfg, (index?, data?) => {

				this.ClickStar(index, data)
			}, "星级", "content", this.layer_value)
			this.down_btn2.Load()
			//SetSizeDeltaX(this.down_btn2.transform, 135)
			this.down_btn.ExcuteCallback(()=>{
				this.down_btn.SetSize(127,36)
			})
			this.down_btn1.ExcuteCallback(()=>{
				this.down_btn1.SetSize(127,36)
			})
			this.down_btn2.ExcuteCallback(()=>{
				this.down_btn2.SetSize(127,36)
			})
			if (!this.tab_loop_mgr) {
				this.tab_loop_mgr = new LoopScrowViewMgr()

				this.tab_loop_mgr.SetData(this._group_plz, MarketRadioBtn, tab_list, LoopScrCon.Horizontal, 1, (item?) => {
					let index = this._group_plz.selectedIndex

					this.SwitchView(Number(index))
				})
				//this._group_plz.addEventListener(eui.ItemTapEvent.ITEM_TAP, this.click_fun, this)
				this.tab_loop_mgr.SetSelectIndex(0)
			} else {
				this.tab_loop_mgr.replaceAll(tab_list)
			}

			if (!this.tab_loop_mgr1) {
				this.tab_loop_mgr1 = new LoopScrowViewMgr()

				this.tab_loop_mgr1.SetData(this._group_select, MarketCircleRadioBtn, tab_list1, LoopScrCon.Horizontal, 1, (item?) => {
					let index = this._group_select.selectedIndex

					cur_select_ = index
					model.Fire(local_MarketEvent.SWTICH_PLZ_SELECT, index)
				})
				//this._group_select.addEventListener(eui.ItemTapEvent.ITEM_TAP, this.click_fun1, this)
				this.tab_loop_mgr1.SetSelectIndex(0)
			} else {
				this.tab_loop_mgr1.replaceAll(tab_list1)
			}

			cur_select_ = 0
			this.SwitchView(0)
			this.InitEvent()
		}
		this.click_fun = (e?) => {
			let index = this._group_plz.selectedIndex

			this.SwitchView(Number(index))
		}
		this.click_fun1 = (e?) => {
			let index = this._group_select.selectedIndex

			cur_select_ = index
			model.Fire(local_MarketEvent.SWTICH_PLZ_SELECT, index)
		}

		this.SwitchView = (index?) => {
			if (cur_index_ == index) {
				return
			}
			cur_index_ = index
			this.UpdateSubView(cur_index_, cur_select_)
		}
		this.RefuseDownBtn = () => {
			_set_color_ = 99
			_set_stage_ = 99
			_set_star_ = 99
			this.down_btn.Refuse()
			this.down_btn1.Refuse()
			this.down_btn2.Refuse()
			model.Fire(local_MarketEvent.PLZ_SORT_GOODS, _set_color_, _set_stage_, _set_star_)
		}


		this.UpdateSubView = (view_type, ...new_args) => {
			cur_view_type_ = view_type - 1
			this.SetGroupVisible(cur_view_type_)
			// [ts2lua]view_list_下标访问可能不正确
			let view = view_list_[view_type]
			if (!view) {
				// [ts2lua]viewclass_list_下标访问可能不正确
				let viewclass = viewclass_list_[view_type]
				view = new viewclass(this._group_view)
				view.Load()
				// [ts2lua]view_list_下标访问可能不正确
				view_list_[view_type] = view
			}
			view.SetData(...new_args)
			this.PopUpChild(view)
		}

		this.SetGroupVisible = (view_type?, ctrl?) => {
			if (ctrl == null) {
				ctrl = true
			}
			let is_drop = view_type == MarketViewType.CTRL
			this._group_drop.visible = is_drop && !ctrl
			this._group_select.visible = !is_drop
			if (is_drop && (!ctrl)) {
				this.RefuseDownBtn()

			}
		}

		this.ClickColor = (index?, data?) => {
			_set_color_ = data.cond
			model.Fire(local_MarketEvent.PLZ_SORT_GOODS, _set_color_, _set_stage_, _set_star_)
		}

		this.ClickStage = (index?, data?) => {
			_set_stage_ = data.cond
			model.Fire(local_MarketEvent.PLZ_SORT_GOODS, _set_color_, _set_stage_, _set_star_)
		}

		this.ClickStar = (index?, data?) => {
			_set_star_ = data.cond
			model.Fire(local_MarketEvent.PLZ_SORT_GOODS, _set_color_, _set_stage_, _set_star_)
		}


	}

	public DeleteMe() {

		this.LocalDeleteMe()
		super.DeleteMe()
	}




	public GetComponents() {
		[
			this._img_bg,
			this._group_plz,
			this._group_select,
			this._group_view,
			this._group_drop,
			this._dd_color,
			this._dd_stage,
			this._dd_star,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_group_plz",
				"_group_select",
				"_group_view",
				"_group_drop",
				"_dd_color",
				"_dd_stage",
				"_dd_star",
			])
	}
}
window["MarketPlzView"] = MarketPlzView
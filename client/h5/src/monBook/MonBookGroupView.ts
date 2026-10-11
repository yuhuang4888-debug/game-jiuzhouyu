import { BaseView1 } from "../common/BaseView1"
import { EventName } from "../common/EventName";
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr";
import { ResManager } from "../common/ResManager"
import { MainFunc } from "../commonModel/MainUIModel";
import { MonBookModel } from "../commonModel/MonBookModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { GameResPath } from "../util/GameResPath";
import { Util } from "../util/Util";
import { MonBookGroupItem } from "./MonBookGroupItem";
import { MonBookTabItem } from "./MonBookTabItem";

export class MonBookGroupView extends BaseView1 {
	LoadSuccess
	InitEvent
	SwitchFunc
	UpdateView
	Remove
	RefreshTabRed
	SetDefaultIndex
	tab_loop_mgr: LoopScrowViewMgr
	item_loop_mgr: LoopScrowViewMgr
	set_time_out_id
	delay_id
	public constructor() {
		super()
		this.base_file = "monBook"
		this.layout_file = "MonBookGroupView"
		this.layer_value = Enum_UILayer.Activity
		this.change_scene_close = true
		this.destroy_imm = true
		this.is_center = true
		this.use_background = true
		this.click_bg_toClose = true
		this.show_open_movie = true
		let model = MonBookModel.GetInstance(),
			local_MonBookModel = MonBookModel,
			radio_btn_list_,
			now_index_,
			default_index_ = 0,
			config_mon_pic_group
		this.load_callback = function () {
			this.LoadSuccess()
			this.InitEvent()
		}
		this.preload_server_config = {
			"config_mon_pic_group": false,
			"config_mon_pic_type": false
		}
		this.destroy_callback = function () {
			this.Remove()
		}

		this.LoadSuccess = () => {
			config_mon_pic_group = ResManager.GetInstance().GetGameConfigFromCache(this, "config_mon_pic_group", false)
			this._gp_tab_con.scrollBar.visible = false
			let config_mon_pic_type = ResManager.GetInstance().GetGameConfigFromCache(this, "config_mon_pic_type", false)
			let name_list = Util.DeepCopy(model.GetTabNameList(config_mon_pic_type))
			for (let k in name_list) {
				var v = name_list[k]
				v.is_group = true
			}

			let red_index = this.RefreshTabRed()	//打点红点index
			if (red_index != undefined) {
				default_index_ = red_index
			}

			if (!this.tab_loop_mgr) {
				this.tab_loop_mgr = new LoopScrowViewMgr()
				this.tab_loop_mgr.SetData(this._gp_tab_con, MonBookTabItem, name_list, this.ScrollView, 1, (item?) => {
					let index = this._gp_tab_con.selectedIndex
					if (index == now_index_) {
						return
					}
					now_index_ = index
					model.now_select_group_type = now_index_ + 1
					this.UpdateView(true)
				}, default_index_)
			} else {
				this.tab_loop_mgr.replaceAll(name_list)
			}


		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._img_close, () => {
				this.Close()
			}, this, true)

			let RefreshBookInfo = (type) => {
				let current_index = now_index_ + 1
				if (current_index == type)
					this.UpdateView()
			}
			this.BindEvent(model, local_MonBookModel.REFRESH_BOOK_INFO, RefreshBookInfo)

			this.BindEvent(model, local_MonBookModel.REFRESH_TAB_DOT, (index, type) => {
				let is_show = null
				if (index && index != 0) {
					is_show = model.IsShowMonGroupRedDot()
					let red = model.IsShowGroupDot(type, config_mon_pic_group)
					model.Fire(local_MonBookModel.REFUSE_TAB_RED, type, red, true)
				}
			})

			let LevelSuccess = (type) => {
				let current_index = now_index_ + 1
				if (current_index == type)
					this.UpdateView()
			}
			this.BindEvent(model, local_MonBookModel.LEVEL_SUCCESS, LevelSuccess)

			let goods_change_fun = (_type) => {
				if (_type && _type == MainFunc.Treasure) {
					this.RefreshTabRed()
				}
			}
			this.BindEvent(GlobalEventSystem, EventName.REFRESH_FUNCTION_ICON_RED_DOT, goods_change_fun)
		}


		this.UpdateView = (is_switch?) => {
			let book_list = model.GetBookComposeList(now_index_ + 1, false, config_mon_pic_group)
			if (!book_list)
				return

			let default_index = 0
			if (is_switch) {
				for (let i = 0; i < book_list.length; i++) {
					let vo = book_list[i]
					if (!model.IsGroupReachMaxLevel(vo.type, vo.id)
						&& model.IsShowSingleGroupDot(vo.type, vo.id, config_mon_pic_group)) {
						default_index = i
					}
				}
			}

			//	show_red_dot = model.IsShowSingleGroupDot(data.type, data.id, config_mon_pic_group)  红点跳转
			if (!this.item_loop_mgr) {
				this.item_loop_mgr = new LoopScrowViewMgr()
				this.item_loop_mgr.SetData(this._list_gp, MonBookGroupItem, book_list, LoopScrCon.Vertical)
				setTimeout(() => {
					if (this.use_delete_method) {
						return
					}
					if (is_switch) this._list_gp.scrollTo(default_index)
				}, 50);
			} else {
				this.item_loop_mgr.replaceAll(book_list)
				if (is_switch) this._list_gp.scrollTo(default_index)
			}


		}

		this.Remove = () => {
			if (this.item_loop_mgr) {
				this.item_loop_mgr.DeleteMe()
				this.item_loop_mgr = null
			}
			if (this.tab_loop_mgr) {
				this.tab_loop_mgr.DeleteMe()
				this.tab_loop_mgr = null
			}
			if (this.set_time_out_id) {
				clearTimeout(this.set_time_out_id)
				this.set_time_out_id = null
			}
			if (this.delay_id) {
				clearTimeout(this.delay_id)
				this.delay_id = null
			}
		}

		this.RefreshTabRed = () => {
			// let bit = model.monGroupRedDotBit
			let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_mon_pic_type", false)
			let first_dot_index
			for (let key in cfg) {
				let data = cfg[key]
				let type = data.type
				if (type) {
					let red = model.IsShowGroupDot(type, config_mon_pic_group)
					model.Fire(local_MonBookModel.REFUSE_TAB_RED, type, red, true)
					if (red && first_dot_index == undefined) {
						first_dot_index = type - 1
					}
				}
			}
			return first_dot_index
		}



		this.SetDefaultIndex = (index) => {
			default_index_ = index || default_index_
		}
	}

	public Open(...parms) {
		if (parms) {
			this.SetDefaultIndex(parms[0])
		}
		super.Open()
	}



	bg_img: Laya.Image
	_Image1: Laya.Image
	_Group1: Laya.Box
	_Image2: Laya.Image
	_img_title: Laya.Label
	_img_close: Laya.Image
	_list_gp: Laya.List
	_img_arrow: Laya.Image
	_gp_effect: Laya.Box
	ScrollView: Laya.Panel
	_gp_tab_con: Laya.List
	none_gp: Laya.Box
	Image: Laya.Image
	Text: Laya.Label
	public GetComponents() {
		[
			this.bg_img,
			this._Image1,
			this._Group1,
			this._Image2,
			this._img_title,
			this._img_close,
			this._list_gp,
			this._img_arrow,
			this._gp_effect,
			this.ScrollView,
			this._gp_tab_con,
			this.none_gp,
			this.Image,
			this.Text,
		]
			= this.GetChildrenByNames([

				"bg_img",
				"_Image1",
				"_Group1",
				"_Image2",
				"_img_title",
				"_img_close",
				"_list_gp",
				"_img_arrow",
				"_gp_effect",
				"ScrollView",
				"_gp_tab_con",
				"none_gp",
				"Image",
				"Text",
			])
	}
}
window["MonBookGroupView"] = MonBookGroupView
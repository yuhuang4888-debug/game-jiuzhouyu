import { BaseView1, OpenMode } from "./BaseView1"
import { Enum_UILayer } from "./LayerManager"
import { ViewManager } from "./ViewManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventName } from "./EventName"
import { GameError } from "../util/GameError"
import { ResManager } from "./ResManager"
import { CommonManager } from "./CommonManager"
import { Message } from "../sysInfo/SysInfoController"
import { OpenFun } from "./OpenFun"
import { RoleManager } from "../commonModel/RoleManager"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { Util, DEVICE_OS, AtlasUrl, Split, GetQualifiedClassName, SetSizeDelta } from "../util/Util"
import { SoundManager } from "./SoundManager"
import { GameResPath } from "../util/GameResPath"
import { Config } from "./Config"
import { BaseItemRenderer } from "./BaseItemRenderer"
import { UIEffect } from "./UIEffect"
import { StoryModel } from "../commonModel/StoryModel"
import "./BaseAwardItem"
import { MainUIController } from "../commonController/MainUIController"
import { SYTweenLite } from "../util/SYTweenLite"
import { SYTweenFunc } from "../util/SYTweenFunc"
import { RedDotController } from "./RedDotController"
import { PlatformManager } from "../PlatformManager"
export class BaseWindowComponent extends BaseView1 {
	static CURR_BASE_WINDOW_COMPONENT: BaseWindowComponent
	static is_full_screen //是否铺满了屏幕
	static CURR_OPEN_VIEW = {}
	//Laya
	public _story_bar2: Laya.Box
	public _root_gp: Laya.Box
	public _gp_item_con: Laya.Box
	public _img_return: Laya.Box
	private _img_title_bg: Laya.Image
	protected _img_title: Laya.Image
	private _img_instruction: Laya.Image
	protected _img_bg: Laya.Image
	public _img_tab_bg: Laya.Image
	private _img_red: Laya.Image
	protected _gp_down: Laya.Box
	public _list_tab_con: Laya.List

	public real_index_to_index
	//private
	private default_index
	private real_tab_list
	private index_to_real_index
	private bg_rectangle = "10,10,10,10" //默认背景的九宫格
	private default_bg_source = "resource/game/bigBg/ui_bg_1.jpg"
	private back_id
	private back_showid
	private cur_index
	//protected
	protected instruction_id //设置说明弹窗
	public viewList: Array<any>
	protected arg_list //参数列表
	//public
	public nowSelectIndex = null
	public tabStrList
	public tabRedKeyList
	public viewClassList
	public viewClassModuleDic
	public titleStr = "" //标题图片的引用
	public titleList //标题图片的引用
	public money_list //设置需要显示的 货币类型
	public instruction_list //设置说明弹窗
	public is_show_tab = true //是否显示 tab
	public tab_item_renderer //Tab按钮皮肤
	public bg_list //背景图列表
	public window_load_back //加载回调
	public window_open_back //打开回调
	public window_clsoe_back // 关闭回调
	public tab_new_cond //创建标签条件
	public tab_open_cond //打开标签条件
	public is_real_default_index //是否真正的默认index
	tween_list = []
	red_tween_id
	fullScreenId
	LocalSelectView
	ChangeView
	LocalChangeView
	LocalCloseFunc
	LocalSetDefaultIndex
	SetIndexParameter
	SetTabRed
	SetTabEffect
	SetTabImage
	SetComponentValue
	GetWindowDefaultIndex
	GetComponentValue
	SetBackId
	LocalRemove
	LocalLoadSuccess
	UpdateView
	LocalSetSelectIndex
	InitTabList
	protected InitTabItem
	InitEvent
	SetInstruInex
	onItemTouch
	onTouchCallback
	refreshRed
	Local_Open
	Local_Close
	updateItem
	public constructor() {
		super()
		this.base_file = "common"
		this.layout_file = "BaseWindowSkin"
		this.layer_value = Enum_UILayer.UI
		this.open_mode = OpenMode.OpenOnly
		this.change_scene_close = true
		this.is_lastView_close = true
		this.click_bg_toClose = false
		this.background_alpha = 0.5
		this.use_background2 = true
		this.show_custom_background = true
		this.not_show_main_msg = true;
		this.back_login_toClose = true;

		let local_base_window_compont = BaseWindowComponent,
			view_mgr = ViewManager.GetInstance(),
			story_model = StoryModel.GetInstance(),
			local_GlobalEventSystem = GlobalEventSystem,
			event_name = EventName,
			game_error = GameError.GetInstance(),
			res_mgr = ResManager.GetInstance(),
			common_mgr = CommonManager.GetInstance(),
			local_Message = Message,
			local_OpenFun = OpenFun,
			// local_eui = Laya,
			role_mgr = RoleManager.GetInstance(),
			sever_model = ServerTimeModel.GetInstance(),
			local_Util = Util,
			sound_mgr = SoundManager.GetInstance(),
			is_open_call = false
		this.load_callback = function () {
			// this.GetComponents()
			this.display_obj.bottom = 0
			// this.display_obj.percentHeight = 100
			this.display_obj.centerX = 0
			local_base_window_compont.CURR_BASE_WINDOW_COMPONENT = this
			if(PlatformManager.IsEyouPlatform()){
				this._list_tab_con.repeatX = 4
			}
			this.LoadSuccess()
			if (this.use_delete_method) {
				return
			}
			this.InitEvent()
			this.InitTabItem()
			if (this.window_load_back) {
				this.window_load_back()
			}
		}
		this.open_callback = function () {
			if (this.window_open_back) {
				this.window_open_back()
				if(this._story_bar2&&PlatformManager.IsEyouPlatform()){
                    this._story_bar2.x = 75 + 180*this.story_model.story_index
                }
			}
			is_open_call = true
			local_base_window_compont.CURR_OPEN_VIEW[this.hashCode] = this.titleStr || true
			window["MainUIController"].GetInstance().SetTopToLayer(Enum_UILayer.UI)
			window["MainUIController"].GetInstance().SetHeadVisible(false)
			window["MainUIController"].GetInstance().SetMapVisible(false)
			this.UpdateView()
			// if (this.fullScreenId) {
			// 	clearTimeout(this.fullScreenId)
			// 	this.fullScreenId = undefined
			// }
			// let onDelay = () => {
			// if (this.use_delete_method || !this.isPop)
			// 	return
			// if (local_base_window_compont.is_full_screen == null) {
			// 	// this.validateNow()
			// 	local_base_window_compont.is_full_screen = (this.x <= -75 && this._root_gp && this._root_gp.y <= 0)
			// }
			// if (!local_base_window_compont.is_full_screen) {
			// this.use_background2 = true
			view_mgr.ShowBackGroup(this)
			// }
			// else {
			// 	this.use_background = false
			// 	view_mgr.CheckBackGroup()
			// } //第一次为BaseWindowComponent.is_full_screen = false% 第二次打开 BaseWindowComponent.is_full_screen 为true this.use_background = false
			view_mgr.OpenBaseWindow()
			this.refreshRed()
			// }
			// this.fullScreenId = setTimeout(onDelay, 100)

			this._root_gp.alpha = 0.5
			this._root_gp.y = 200
			this.tween_list.push(SYTweenLite.to(this, this._root_gp, SYTweenLite.UiAnimationType.ALPHA, 1, 0.15))
			this.tween_list.push(SYTweenLite.to(this, this._root_gp, SYTweenLite.UiAnimationType.ANCHORED_POSY, 0, 0.15))
		}
		this.close_callback = function () {
			if (this.window_clsoe_back) {
				this.window_clsoe_back()
			}
			// MainUIController.GetInstance().SetCareerLevelVisible(true)
			// if (this.fullScreenId) {
			// 	clearTimeout(this.fullScreenId)
			// 	this.fullScreenId = undefined
			// }
			if (Util.IsTableEmpty(BaseWindowComponent.CURR_OPEN_VIEW)) {
				window["MainUIController"].GetInstance().SetTopToLayer(Enum_UILayer.Main)
				window["MainUIController"].GetInstance().SetHeadVisible(true)
				window["MainUIController"].GetInstance().SetMapVisible(true)
			}
		}
		this.destroy_callback = function () {
			this.Remove()
		}
		this.Local_Open = () => {
			if (this.CanOpen()) {
				// SysInfoMiniMgr.GetInstance().ResetItem()
				if (story_model.main_ui_finger) {
					let obj = story_model.main_ui_finger && story_model.main_ui_finger.target_obj
					local_GlobalEventSystem.Fire(event_name.HIDE_FINGER, obj, true)
				}
				super.Open()
			}
		}
		this.Local_Close = () => {
			local_GlobalEventSystem.Fire(event_name.HIDE_FINGER, this._img_return)
			delete local_base_window_compont.CURR_OPEN_VIEW[this.hashCode]
			view_mgr.CloseBaseWindow()
			super.Close()
		}
		this.LocalSelectView = (index: number, is_real_index = false) => {
			if (!this.index_to_real_index) {
				game_error.SendErrorToPHP("打开了未达到开启条件的界面-------------------------" + GetQualifiedClassName(this), true)
				this.Close()
				return
			}
			let real_index
			if (is_real_index) {
				real_index = index
				index = this.real_index_to_index[real_index]
			}
			else {
				real_index = this.index_to_real_index[index]
			}
			if (!is_open_call && this.nowSelectIndex == real_index)
				return
			this.ChangeView(index, real_index)
		}
		this.ChangeView = (index, real_index) => {
			this.LocalChangeView(index, real_index)
		}
		this.LocalChangeView = (index, real_index) => {
			let sub_view_class_name = this.viewClassList[index]
			if (!window[sub_view_class_name]) {
				let module_info = this.viewClassModuleDic && this.viewClassModuleDic[index]
				if (module_info) {
					// if (!res_mgr.IsJsLoad(module_info.module_name)) {
					//     await res_mgr.LoadJs(module_info.module_name)
					//     console.log("this.viewClassList[index]", module_info.module_name, window[sub_view_class_name], index)
					// }
					// else {
					// }
				}
			}
			if (this.use_delete_method) {
				return
			}
			if (window[sub_view_class_name]) {
				//功能开启流程判断是否可点击
				let is_open = common_mgr.CheckFuncOpenState(sub_view_class_name)
				if (!is_open) {
					this._list_tab_con.selectedIndex = this.nowSelectIndex != null ? this.nowSelectIndex : 0
					return
				}
				//自己界面判断是否可点击
				let cond_func = this.tab_open_cond && this.tab_open_cond[index]
				if (cond_func && !cond_func(this)) {
					this._list_tab_con.selectedIndex = this.nowSelectIndex != null ? this.nowSelectIndex : 0
					return
				}
			}
			else {
				this._list_tab_con.selectedIndex = this.nowSelectIndex != null ? this.nowSelectIndex : 0
				local_Message.show("找不到对应类")
				return
			}
			//设置背景
			let bg_url = this.default_bg_source
			if (this._img_bg) {
				let bg_res = this.bg_list && this.bg_list[index]
				if (bg_res) {
					bg_url = GameResPath.GetBigBgPath(bg_res)
				}
			}
			res_mgr.SetTexture(this, this._img_bg, bg_url, () => {
				SetSizeDelta(this._img_bg, 720, 1222);
			}, this, false);

			if (!this.viewList)
				this.viewList = []
			let sub_view = this.viewList[real_index]
			if (!sub_view) {
				let sub_view_class: any = window[sub_view_class_name]
				sub_view = new sub_view_class(this._gp_item_con)
				this.viewList[real_index] = sub_view
				//设置参数
				if (sub_view && typeof (sub_view.CustomMehod) == "function") {
					let arg = this.arg_list && this.arg_list[index]
					if (arg)
						sub_view.CustomMehod(index, arg)
					else
						sub_view.CustomMehod(index)
				}
				sub_view.Load()
			}

			if(sub_view && sub_view.ChangeCallFunc){
				sub_view.ChangeCallFunc()
			}

			// 子界面立即删除时候清理viewList中的引用
			if (this.destroy_child_imm) {
				if (this.cur_index && this.viewList[this.cur_index]) {
					delete this.viewList[this.cur_index]
				}
			}
			this.cur_index = real_index

			this.PopUpChild(sub_view)
			GlobalEventSystem.Fire(EventName.CHANGE_SUB_VIEW, sub_view_class_name, this.cur_index)

			if (is_open_call) {
				is_open_call = false
				sub_view.ExcuteCallback(() => {
					if (sub_view.open_callback) {
						sub_view.open_callback()
					}
				})
			}


			//设置标题
			let title_source = this.titleList && this.titleList[index] != null ? (this.titleList[index] || this.titleList[real_index]) : this.titleStr
			let icon_str = title_source.split(".")
			let title_skin = AtlasUrl(icon_str[0], icon_str[1])
			if (this._img_title.skin != title_skin) {
				this._img_title.skin = title_skin
			}
			//设置说明按钮
			let bool = this.instruction_list && this.instruction_list[index] != null
			this.instruction_id = bool ? this.instruction_list[index] : undefined
			this._img_instruction.visible = !!this.instruction_id
			this.nowSelectIndex = real_index
		}

		this.LocalCloseFunc = () => {
			this.Close()
			if (this.back_id) {
				if (this.back_showid != undefined && this.back_showid != null) {
					local_OpenFun.OpenFunHandler(this.back_id, this.back_showid)
				}
				else {
					local_OpenFun.OpenFunHandler(this.back_id)
				}
			}
			this.back_id = undefined
		}
		this.LocalSetDefaultIndex = (index, is_real_index = false) => {
			this.is_real_default_index = is_real_index
			this.default_index = index
		}
		//设置传递参数
		this.SetIndexParameter = (index, ...arg) => {
			if (arg && arg.length > 0) {
				if (!this.arg_list)
					this.arg_list = {}
				this.arg_list[index] = arg
			}
		}
		//设置标签红点
		this.SetTabRed = (index, state) => {
			if (!this.index_to_real_index)
				return
			let real_index = this.index_to_real_index && this.index_to_real_index[index]
			let tab: any = this.real_tab_list[real_index]
			if (tab) {
				tab.red_state = state
				this._list_tab_con.array = this.real_tab_list
				this._list_tab_con.refresh()
				this.refreshRed()
			}
		}
		//设置标签特效
		this.SetTabEffect = (index, state) => {
			if (!this.index_to_real_index)
				return
			let real_index = this.index_to_real_index && this.index_to_real_index[index]
			let tab: any = this.real_tab_list[real_index]
			if (tab && tab.effect && (!tab.effect.show || tab.effect.show != state)) {
				tab.effect["show"] = state
				this._list_tab_con.array = this.real_tab_list
				this._list_tab_con.refresh()
			}
		}
		this.SetTabImage = (index, state, res, x?, y?) => {
			if (!this.index_to_real_index)
				return
			let real_index = this.index_to_real_index && this.index_to_real_index[index]
			let tab = this.real_tab_list[real_index]
			if (tab && tab.image && (tab.image.show != state || res != tab.image.source)) {
				tab.image["show"] = state
				tab.image["source"] = res
				if (x) {
					tab.image.x = x
				}
				if (y) {
					tab.image.y = y
				}
				this._list_tab_con.array = this.real_tab_list
				this._list_tab_con.refresh()
			}
		}
		//设置组件参数
		this.SetComponentValue = (component, obj) => {
			if (this.is_loaded) {
				for (let key in obj) {
					let v = obj[key]
					if (this[component])
						this[component][key] = v
				}
			}
		}
		this.GetWindowDefaultIndex = () => {
			return this.default_index
		}
		//获取组件参数
		this.GetComponentValue = (component, attr) => {
			if (this.is_loaded) {
				return this[component][attr]
			}
		}
		//设置手动关闭打开的界面ID
		this.SetBackId = (id, showid?) => {
			this.back_id = id
			if (showid != undefined && showid != null) {
				this.back_showid = showid
			}
		}
		this.LocalRemove = () => {
			if (this.viewList) {
				for (let key in this.viewList) {
					let view = this.viewList[key]
					if (view)
						view.DeleteMe()
				}
			}
			this.viewList = null
			this.default_index = undefined
			this.nowSelectIndex = undefined
			this.arg_list = undefined
			this._list_tab_con = undefined
			this.instruction_id = undefined
			this.real_index_to_index = undefined
			this.index_to_real_index = undefined
			if (this._list_tab_con) {
				this._list_tab_con.scrollBar.off(Laya.Event.CHANGE, this, this.refreshRed)
				if (this._img_red) {
					// Laya.Tween.clearAll(this._img_red)
				}
			}
			if (this.tween_list) {
				for(let id of this.tween_list){
					SYTweenLite.Stop(id)
				}
				this.tween_list.length = 0
			}
			if(this.red_tween_id){
				SYTweenLite.Stop(this.red_tween_id)
				this.red_tween_id = null
			}
		}
		this.LocalLoadSuccess = () => {
			if (!this.viewClassList) {
				game_error.SendErrorToPHP("打开了界面类为空的界面-------------------------" + GetQualifiedClassName(this), true)
				this.Close()
				return
			}
			if(PlatformManager.IsEyouPlatform()){
				this._story_bar2.width = 180
			}
			let view_name = this.viewClassList[this.default_index]
			if (view_name) {
				let func_is_open = common_mgr.CheckFuncOpenState(view_name)
				if (!func_is_open) {
					this.Close()
					return
				}
			}
			if (!this.viewList)
				this.viewList = []
		}
		//不可以外部调用
		this.UpdateView = () => {
			local_base_window_compont.CURR_BASE_WINDOW_COMPONENT = this

			let is_real_index = false
			let local_mainUI_model = window["MainUIModel"]
			if (!local_mainUI_model.NotJumpRedSubView(GetQualifiedClassName(this)) && this.default_index == undefined && local_mainUI_model.DefaultOpenRedViewLv <= role_mgr.GetMainRoleVo().level) {
				let default_index = 0
				if (this._list_tab_con && this._list_tab_con.array && this._list_tab_con.array.length > 0) {
					for (let key in this._list_tab_con.array) {
						let value = this._list_tab_con.array[key]
						if (value && value.red_state) {
							default_index = Number(key)
							is_real_index = true
							break
						}
					}
				}
				this.default_index = default_index
			}

			if (!this.default_index) {
				is_real_index = true
			}
			this.SetSelectIndex(this.default_index || 0, is_real_index)
			//设置选项卡显示位置 未处理
			if (this._list_tab_con && this._list_tab_con.array) {
				let real_index = this.index_to_real_index && this.index_to_real_index[this.default_index || 0] || 0
				// let numElements = this._list_tab_con.array.length
				let gap = this._list_tab_con.spaceX
				let cell = this._list_tab_con.cells[0]
				let itemWidth = cell.width
				this._list_tab_con.scrollBar.value = Math.max((itemWidth + gap) * (Number(real_index) + 1) - this._list_tab_con.width, 0)
			}
		}
		this.LocalSetSelectIndex = (index, is_real_index?) => {
			if(!this.index_to_real_index) return
			let idx = is_real_index ? index : this.index_to_real_index[index]
			//设置默认选中按钮
			this._list_tab_con.selectedIndex = idx
			//刷新对应界面
			this.SelectView(index, is_real_index)
		}
		this.InitTabList = () => {
			let player_lv = role_mgr.GetMainRoleVo().level
			this.real_tab_list = []
			// let openDay = sever_model.GetOpenServerDay()
			let index = 0
			for (let key in this.tabStrList) {
				let value = this.tabStrList[key]
				if (!value.red_state)
					value["red_state"] = false
				if (!value.effect)
					value["effect"] = undefined
				let lv_func = () => {
					return !value.open_lv || player_lv >= value.open_lv
				}
				let ViewName = ""
				if (this.viewClassModuleDic && this.viewClassModuleDic[index]) {
					ViewName = this.viewClassModuleDic[index].class_name
				}
				else if (this.viewClassList && this.viewClassList[index]) {
					ViewName = this.viewClassList[index]
				}
				//let open_cond_cfg = Config.PRELOAD_CLIENT_CONFIG.ConfigFuncOpenCondition[ViewName]
				let default_func = () => {
					/*
					if (!open_cond_cfg) {
						return true
					}
					if (!open_cond_cfg.open_lv || open_cond_cfg.open_lv <= 200) {
						if (!open_cond_cfg.open_day) {
							return true
						}
						else {
							return openDay >= open_cond_cfg.open_day
						}
					}
					else {
						return player_lv >= open_cond_cfg.open_lv && (!open_cond_cfg.open_day || openDay >= open_cond_cfg.open_day)
					}
					*/
					return common_mgr.CheckFuncOpenState(ViewName, true)
				}
				let cond_func = this.tab_new_cond && this.tab_new_cond[key]
				if (lv_func() && (!cond_func || cond_func(this)) && default_func()) {
					let len = this.real_tab_list.length
					if (!this.real_index_to_index)
						this.real_index_to_index = {}
					this.real_index_to_index[len] = Number(key)
					if (!this.index_to_real_index)
						this.index_to_real_index = {}
					this.index_to_real_index[key] = len
					this.real_tab_list.push(value)
				}
				index++
			}
		}
		this.InitTabItem = () => {
			this.InitTabList()
			if (!this.is_show_tab) {
				this._gp_down.visible = false
				return
			}

			this._list_tab_con.hScrollBarSkin = ""
			this._list_tab_con.cacheContent = true
			this._list_tab_con.itemRender = this.tab_item_renderer || WindowComponentTabButtonOne
			this._list_tab_con.renderHandler = Laya.Handler.create(this, this.updateItem, null, false);

			this._list_tab_con.selectEnable = true;
			this._list_tab_con.selectHandler = Laya.Handler.create(this, this.onItemTouch, null, false);
			this._list_tab_con.mouseHandler = Laya.Handler.create(this, this.onTouchCallback, null, false)
			this._list_tab_con.scrollBar.on(Laya.Event.CHANGE, this, this.refreshRed)

			this._list_tab_con.array = this.real_tab_list
			// let idx = this.is_real_default_index ? this.default_index : this.index_to_real_index && this.index_to_real_index[this.default_index]
			// this._list_tab_con.selectedIndex = idx
		}
		this.InitEvent = () => {
			let click_func = () => {
				this.BaseWindowCloseFunc()
			}
			local_Util.AddClickEvent(this._img_return, click_func, this, true, null, null)
			local_Util.AddClickEvent(this._img_instruction, () => {
				if (this.instruction_id)
					local_GlobalEventSystem.Fire(event_name.OPEN_INSTRUCTION_VIEW, this.instruction_id)
			}, this, true)

			this.BindEvent(local_GlobalEventSystem, event_name.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, (class_name, index, state) => {
				if (class_name == GetQualifiedClassName(this)) {
					this.SetTabRed(index, state)
				}
			})
			this.BindEvent(local_GlobalEventSystem, event_name.UPDATE_BASE_WINDOWS_COMPONENT_EFFECT_STATE, (class_name, index, state) => {
				if (class_name == GetQualifiedClassName(this)) {
					this.SetTabEffect(index, state)
				}
			})
			this.BindEvent(local_GlobalEventSystem, event_name.UPDATE_BASE_WINFOWS_COMPONENT_IMAGE_STATE, (class_name, index, state, res) => {
				if (class_name == GetQualifiedClassName(this)) {
					this.SetTabImage(index, state, res)
				}
			})
			this.BindEvent(local_GlobalEventSystem, event_name.EXCHANGE_BASEWINDOW_BG_HEIGHT, (height) => {
				this._img_bg.height = height
			})

			if (this._img_red) {
				this.red_tween_id = SYTweenLite.to(this, this._img_red, SYTweenLite.UiAnimationType.SCALE, { x: 0.8, y: 0.8 }, 1, null, SYTweenFunc.PINGPONG, true)
			}
		}
		/**界面里面的内容可能会挡住规则按钮 特殊处理*/
		this.SetInstruInex = () => {
			if (this._img_instruction) {
				this._root_gp.setChildIndex(this._img_instruction, -1)
			}
		}
		this.onItemTouch = (itemIndex) => {
			this.SelectView(itemIndex, true)
		}
		this.onTouchCallback = (e: Laya.Event) => {
			if (e.type == Laya.Event.CLICK)
				sound_mgr.PlaySoundEffect("2_dianji")
		}
		this.refreshRed = () => {
			if (!this.use_delete_method) {
				let bool = false
				if (this.real_tab_list && this._list_tab_con.scrollBar) {

					let value = this._list_tab_con.scrollBar.value
					let item_width = 150
					if(PlatformManager.IsEyouPlatform()){
						item_width = 180
					}
					let tab
					let length
					for (let index in this.real_tab_list) {
						tab = this.real_tab_list[index]
						if (tab && (tab.red_state || RedDotController.ins.get(tab.red_key))) {
							length = item_width * (Number(index) + 1) - this._list_tab_con.width - 20 // 20 计算向左的偏移量
							if (length > value) {
								bool = true
								break
							}
						}
					}
				}
				if (this._img_red)
					this._img_red.visible = bool
			}
		}

		this.updateItem = (cell, index: number) => {
			// console.log("----------------updateitem-----------", index, cell)
			if(this._list_tab_con)
			{
				cell.selected = index == this._list_tab_con.selectedIndex
				cell.updateItem(cell.dataSource, index);
			}
		}
	}
	public SetSelectIndex(index, is_real_index?) {
		this.LocalSetSelectIndex(index, is_real_index)
	}
	public SelectView(index: number, is_real_index = false) {
		this.LocalSelectView(index, is_real_index)
	}
	public BaseWindowCloseFunc() {
		//关闭动画
		// this._root_gp.alpha = 1
		// this._root_gp.y = 1280
		this.tween_list.push(SYTweenLite.to(this, this._root_gp, SYTweenLite.UiAnimationType.ALPHA, 0.5, 0.15))
		this.tween_list.push(SYTweenLite.to(this, this._root_gp, SYTweenLite.UiAnimationType.ANCHORED_POSY, 200, 0.15, ()=>{
			this.LocalCloseFunc()
		}))
	}
	//设置默认选中
	public SetDefaultIndex(index, is_real_index = false) {
		this.LocalSetDefaultIndex(index, is_real_index)
	}
	protected Remove() {
		this.LocalRemove()
	}
	protected LoadSuccess() {
		this.LocalLoadSuccess()
	}
	public Close() {
		this.Local_Close()
	}
	public Open() {
		this.Local_Open()
	}
	_tab_scroller: Laya.Panel
	_img_return0: Laya.Image

	public GetComponents() {
		[
			this._root_gp,
			this._img_bg,
			this._story_bar2,
			this._gp_item_con,
			this._img_title_bg,
			this._img_title,
			this._gp_down,
			this._img_tab_bg,
			this._tab_scroller,
			this._list_tab_con,
			this._img_return,
			this._img_return0,
			this._img_red,
			this._img_instruction,
		]
			= this.GetChildrenByNames([

				"_root_gp",
				"_img_bg",
				"_story_bar2",
				"_gp_item_con",
				"_img_title_bg",
				"_img_title",
				"_gp_down",
				"_img_tab_bg",
				"_tab_scroller",
				"_list_tab_con",
				"_img_return",
				"_img_return0",
				"_img_red",
				"_img_instruction",
			])
	}


}
export class WindowComponentTabButtonOne extends BaseItemRenderer {
	public WIDTH = 150
	public HEIGT = 90

	//Laya
	private _Image1: Laya.Image
	private labelDisplay: Laya.Label
	private redDisplay: Laya.Image
	private _gp_effect: Laya.Box
	private effect_show = false
	private effect: UIEffect
	private image: Laya.Image
	private imageShow = false
	public constructor() {
		super()
		this.base_file = "common"
		this.layout_file = "TabButtonOneSkin"

		if(PlatformManager.IsEyouPlatform()){
			this.WIDTH = 180
	}

		this.load_callback = ()=>{
			if(PlatformManager.IsEyouPlatform()){
				this.display_obj.width = 180
				this._Image1.width = 176
				this.labelDisplay.fontSize = 20
				this.labelDisplay.width = 180
				this.labelDisplay.height = 63
				this.labelDisplay.wordWrap=true
				this.labelDisplay.align="center"
				this.labelDisplay.leading = 0.1
				this.labelDisplay.valign = "middle"
			}
		}
		this.Load()
	}
	public createChildren(): void {
		super.createChildren()
	}
	protected dataChanged(): void {
		if (super.dataChanged()) {
			//显示数据中的 label 值
			let data = this.data
			this.labelDisplay.text = data.label
			!data.red_key && (this.redDisplay.visible = data.red_state)

			let select_bg = this.selected ? "uian_001a" : "uian_001b"
			this._Image1.skin = AtlasUrl("common", select_bg)

			let stroke_color = this.selected ? "#3E9298" : "#6873A8"
			this.labelDisplay.strokeColor = stroke_color

			this.showEffect(data.effect != undefined && data.effect.show)
			this.showImage(data.image != undefined && data.image.show)
			data.red_key && RedDotController.ins.bind(data.red_key, this.redDisplay);
		}
	}
	private showEffect(value): void {
		let self = this
		if (value == this.effect_show)
			return
		this.effect_show = value
		/*
		if (value) {
			if (!this.effect) {
				this.effect = new UIEffect()
				let data = this.data
				let source = data.effect.source, x = data.effect.x ? data.effect.x : 0, y = data.effect.y ? data.effect.y : 0, scaleX = data.effect.scaleX ? data.effect.scaleX : 1, scaleY = data.effect.scaleY ? data.effect.scaleY : 1
				this.effect.AddUIEffect(source, this._gp_effect, { x: x, y: y }, { x: scaleX, y: scaleY }, true)
			}
			this._gp_effect.visible = true
		}
		else
			this._gp_effect.visible = false
		*/
	}
	private showImage(value) {
		let self = this
		// if(value ==  this.imageShow) return
		this.imageShow = value
		if (value) {
			if (!this.image) {
				this.image = new Laya.Image
				this.image.x = this.data.image.x || 0
				this.image.y = this.data.image.y || 0
				this.base_item.display_obj.addChild(this.image)
			}
			this.image.skin = "resource/game/common/texture/" + this.data.image.source + ".png"
			this.image.visible = true
		}
		else if (this.image) {
			this.image.visible = false
		}
	}
	public GetComponents() {
		[
			this._Image1,
			this.labelDisplay,
			this.redDisplay,
			this._gp_effect
		] = this.GetChildrenByNames([
			"_Image1",
			"labelDisplay",
			"redDisplay",
			"_gp_effect"
		])
	}

	public DeleteMe(): void {
		let self = this
		// if (this.effect) {
		//     this.effect.ClearUIEffect(this._gp_effect)
		//     this.effect.DeleteMe()
		// }
		this.effect_show = false
		super.DeleteMe()
	}
}
export class WindowComponentTabButtonTwo extends BaseItemRenderer {
	WIDTH = 120
	HEIGT = 120

	//Laya
	private _Image1: Laya.Image
	private redDisplay: Laya.Image
	public constructor() {
		super()
		this.base_file = "common"
		this.layout_file = "TabButtonTwoSkin"
		this.Load()
	}
	protected dataChanged(): void {
		if (super.dataChanged()) {
			//显示数据中的 label 值
			!this.data.red_key && (this.redDisplay.visible = this.data.red_state)
			this.redDisplay.top = this.data.top || 0
			this.redDisplay.right = this.data.right || 0

			let icon_source: string = this.selected ? this.data.icon_down_source : this.data.icon_up_source
			let icon_str = icon_source.split(".")
			this._Image1.skin = AtlasUrl(icon_str[0], icon_str[1])
			this.data.red_key && RedDotController.ins.bind(this.data.red_key, this.redDisplay);
		}
	}

	public GetComponents() {
		[
			this._Image1,
			this.redDisplay,
		] = this.GetChildrenByNames([
			"_Image1",
			"redDisplay"
		])
	}
}
window["BaseWindowComponent"] = BaseWindowComponent
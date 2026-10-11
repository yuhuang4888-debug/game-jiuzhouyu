import { Alert, Alert_Type } from "../alert/Alert"
import { BaseView1 } from "../common/BaseView1"
import { EventName, LoginStateEvent } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { LuaSoundManager } from "../common/SoundManager"
import { table } from "../common/table"
import { EyouThAdultItem } from "../mainUI/EyouThAdultItem"
import { PlatformManager } from "../PlatformManager"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
import { LoginManager } from "./LoginManager"
import { LoginModel } from "./LoginModel"
import { Enum_LoginState } from "./LoginStateManager"
import { ServerModel } from "./ServerModel"

export class LoginSelectServerView extends BaseView1 {

	login_mgr: LoginManager
	server_model: ServerModel
	res_mgr: ResManager
	login_model: LoginModel

	tab_loop_mgr: LoopScrowViewMgr
	item_loop_mgr: LoopScrowViewMgr
	location_loop_mgr: LoopScrowViewMgr
	cache_last_server
	tab_list
	location_list
	item_list
	cur_location_index
	cur_tab_index
	init_area_tab = false
	vn_box_:Laya.Box
	public constructor() {
		super()

		this.base_file = "login"
		this.layout_file = "LoginSelectServerView"
		
		this.layer_value = Enum_UILayer.Top
		this.destroy_imm = true
		this.show_open_movie = true
		this.use_background = true
		this.background_alpha = 0
		this.click_bg_toClose = true
		this.is_center = true

		this.login_mgr = LoginManager.GetInstance()
		this.server_model = ServerModel.GetInstance()
		this.res_mgr = ResManager.GetInstance()
		this.login_model = LoginModel.GetInstance()

		this.load_callback = () => {
			this.LoadSuccess()
		}

		this.close_callback = () => {
			if(this.vn_box_){
				this.vn_box_.removeSelf()
				this.vn_box_.destroy()
				this.vn_box_=null
			}
			let cur_server_id_2_location = this.login_mgr.GetCurServer2Location()
			if (cur_server_id_2_location != this.server_model.cur_selected_location) {
				this.server_model.cur_selected_location = cur_server_id_2_location
				this.server_model.FormatAccountUrl(cur_server_id_2_location)
				this.server_model.LocaltionRequestPlayerLoginInfo(cur_server_id_2_location)
			}

			this.cur_tab_index = null
			this.cur_location_index = null

			this.init_area_tab = false
			if (this.tab_loop_mgr) {
				this.tab_loop_mgr.DeleteMe()
				this.tab_loop_mgr = undefined
			}
			if (this.item_loop_mgr) {
				this.item_loop_mgr.DeleteMe()
				this.item_loop_mgr = undefined
			}
			if (this.location_loop_mgr) {
				this.location_loop_mgr.DeleteMe()
				this.location_loop_mgr = undefined
			}
			this.cache_last_server = false
			this.login_mgr.Fire(LoginStateEvent.CLOSE_VIEW, "LoginSelectServerView")
		}
	}

	public InitEvent() {

		this.BindEvent(GlobalEventSystem, LoginStateEvent.SELECT_SERVER_ITEM, (index?) => {
			this.ClickServer(index)
		})

		this.BindEvent(this.login_mgr, LoginStateEvent.UPDATE_SELECT_SERVER_VIEW, (area?) => {
			if (area == this.server_model.cur_selected_area_id) {
				this.UpdateServerItem()
			}
			this.UpdateTab()
		})

		Util.AddClickEvent(this._img_close, () => {
			this.Close()
		}, this, true, null, null, null, null, LuaSoundManager.SOUND_UI.CLOSE)
	}

	public LoadSuccess() {
		if (PlatformManager.IsEyouVnPlatform()) {
            this.vn_box_ = new Laya.Box()
            this.vn_box_.name = "Box_EyouVnAdultItem"
            this.vn_box_.width = 80
            this.vn_box_.height = 70
            this.vn_box_.centerX = 213
            this.vn_box_.y = 23
            this.display_obj.addChild(this.vn_box_)
            let view = new EyouThAdultItem(this.vn_box_)
			view.SetAnimType(2)
            view.Load()
        }
		if(ServerModel.GetInstance().IsLocationMode()){
			this.res_mgr.SetTexture(this, this._img_bg, GameResPath.GetIconJpg("login", "ui_Login_bg11"), null, null, null, null, true, true)
			this._list_tab.y = 238
			this._list_item.y = 249
			this._list_location.visible = true
			this.cur_location_index = ServerModel.GetInstance().cur_selected_location - 1;

			this.InitLocation()
			if(this.location_list){
				this.RefreshLocation()
			}
		}
		else{
			this.res_mgr.SetTexture(this, this._img_bg, GameResPath.GetIconJpg("login", "ui_Login_bg1"), null, null, null, null, true, true)
			this._list_location.visible = false
			this._list_tab.y = 166
			this._list_item.y = 177
		}

		this.InitEvent()

		this.login_mgr.Fire(LoginStateEvent.LOGIN_STATE_CHANGE, Enum_LoginState.SimplifyServer)
	}

	public InitLocation(){
		if(this.location_list) return
		this.location_list = []
		if(ServerModel.GetInstance().location_info_cfg){
			for(let i = 1; ;i++){
				var info = ServerModel.GetInstance().location_info_cfg[i]
				if(info){
					this.location_list.push(info)
				}
				else{
					break
				}
			}
		}
	}

	public RefreshLocation() {
		if (this.location_loop_mgr) {
			this.location_loop_mgr.replaceAll(this.location_list)
		} else {
			let render_class = window["LoginSelectServerLocationItem"]
			if (render_class) {
				this.location_loop_mgr = new LoopScrowViewMgr()
				this.location_loop_mgr.SetData(this._list_location, render_class, this.location_list, LoopScrCon.Horizontal, 1,(index) => {
					this.SwitchLocation(index)
				}, this.cur_location_index)
			}
		}
	}


	public InitTab() {
		if(!this.tab_list){
			this.tab_list = []
		}
		this.tab_list[0] = { name: "最近登录", belong_id: 0, belong: "", id: 0 }
	}

	public UpdateTab() {
		if (this.init_area_tab) {
			return
		}
		let area_data = this.server_model.GetAreaData()
		if (!area_data) {
			return
		}
		this.InitTab()
		this.init_area_tab = true

		let list = this.SortListByType(area_data, "id", 1)
		for (let _ in list) {
			var v = list[_]
			table.insert(this.tab_list, v)
		}

		let index = 1
		if(this.GetLastServerList().length > 0){
			index = 0
		}

		this.RefreshTab(index)

		GlobalEventSystem.Fire(EventName.HIDE_WAITFOR_OPENVIEW_LOADING, ServerModel.RequestLocationLoading.hashCode);
	}

	public CreateLastServer() {
		return this.SortListByType(this.server_model.GetHistoryLoginInfo(), "time", 1)
	}

	public GetLastServerList() {
		if (!this.cache_last_server || this.cache_last_server.length == 0) {
			if(!this.cache_last_server){
				this.cache_last_server = []
			}

			let last_server_list = this.CreateLastServer()
			if (last_server_list) {
				for (let _tmpi in last_server_list) {
					var player_data = last_server_list[_tmpi]
					if (player_data && player_data.role_id != "0") {
						table.insert(this.cache_last_server,
							{
								server_data: player_data,
								player_data: player_data
							}
						)
					}
				}
			}
		}
		return this.cache_last_server
	}


	public RefreshTab(index?) {
		if (this.tab_loop_mgr) {
			this.tab_loop_mgr.replaceAll(this.tab_list)
			if(index){
				this.tab_loop_mgr.SetSelectIndex(index)
			}
		} else {
			let render_class = window["LoginSelectServerTabItem"]
			if (render_class) {
				this.tab_loop_mgr = new LoopScrowViewMgr()
				this.tab_loop_mgr.SetData(this._list_tab, render_class, this.tab_list, LoopScrCon.Vertical, 1, (index) => {
					this.SwitchTab(index)
				}, index)
			}
		}
	}

	public RefreshItem() {
		if (this.item_loop_mgr) {
			this.item_loop_mgr.replaceAll(this.item_list)
		} else {
			let render_class = window["LoginSelectServerItem"]
			if (render_class) {
				this.item_loop_mgr = new LoopScrowViewMgr()
				this.item_loop_mgr.SetData(this._list_item, render_class, this.item_list, LoopScrCon.Vertical, 1)
			}
		}
	}

	public SwitchTab(index?) {
		if (this.cur_tab_index == index) {
			return
		}

		this.cur_tab_index = index

		if (index == 0) {
			this.item_list = this.GetLastServerList()
			this.RefreshItem()
			this.server_model.cur_selected_area_id = 0
		} else {
			let data = this.tab_list[index]
			if (data && data.id) {
				this.server_model.cur_selected_area_id = data.id
				this.login_mgr.Fire(LoginStateEvent.LOGIN_STATE_CHANGE, Enum_LoginState.ServerList)
			}
		}
	}

	public SwitchLocation(index?) {
		if (this.cur_location_index == index) {
			return
		}

		let call_func = () => {
			this.cur_location_index = index
			this.init_area_tab = false
			this.cur_tab_index = null
			if(this.cache_last_server){
				this.cache_last_server.length = 0
			}
			this.server_model.cur_selected_area_id = 0
			this.server_model.ClearData()
			if(this.item_list){
				this.item_list.length = 0
				this.RefreshItem()
			}
			if(this.tab_list){
				this.tab_list.length = 0
				this.RefreshTab()
			}

			let localtion = index + 1
			this.server_model.FormatAccountUrl(localtion)
			this.server_model.cur_selected_location = localtion
			this.server_model.LocaltionRequestPlayerLoginInfo(localtion)
			GlobalEventSystem.Fire(EventName.SHOW_WAITFOR_OPENVIEW_LOADING, ServerModel.RequestLocationLoading.hashCode);
		}
		
		let localtion = index + 1
	
		if (this.server_model.base_location == localtion ) { 
			call_func()
		}else{
			Alert.Show("The select region might have network delay || other network issues.  Are you sure to switch to this region?", Alert_Type.Two,() => {
				call_func()
			},() => {
				if (this.use_delete_method ) {
					return
				}
				this.location_loop_mgr.SetSelectIndex(this.cur_location_index)
			}, "Confirm", "Cancel")
	
		}
	}

	public UpdateServerItem() {
		let server_data = this.server_model.GetServerData(this.server_model.cur_selected_area_id)
		let list = []
		if (server_data) {
			server_data = this.SortListByType(server_data, "num", 1)
			for (let _tmpi in server_data) {
				var data = server_data[_tmpi]
				table.insert(list,
					{
						server_data: data,
						player_data: this.GetServerMaxLevelPlayerData(data.id)
					}
				)
			}
		}

		this.item_list = list
		this.RefreshItem()
	}

	public GetServerMaxLevelPlayerData(server_id?) {
		let player_server_list = this.server_model.GetHistoryLoginInfo()
		let list = []
		if (player_server_list) {
			for (let _tmpi in player_server_list) {
				var player_data = player_server_list[_tmpi]
				if (player_data.server_id == server_id) {
					table.insert(list, player_data)
				}
			}
			list.sort((a, b) => {
				return - Number(a.lv) + Number(b.lv)
			})
		}
		return list[0]
	}

	public SortListByType(list?, type?, order?) {
		let _list = []
		if (_list) {
			for (let i in list) {
				table.insert(_list, list[i])
			}
			_list.sort((a, b) => {
				let aa = Number(a[type])
				let bb = Number(b[type])

				if (aa == bb) {
					return -1
				}

				if (order > 0) {
					return -aa + bb
				} else {
					return aa - bb
				}
			})
		}
		return _list
	}

	public ClickServer(index?) {
		let data = this.item_list[index]
		if (data) {
			let server_data = data.server_data
			let name = server_data.num && server_data.name || server_data.sname
			let server_id = server_data.num && server_data.id || server_data.server_id
			this.login_mgr.Fire(LoginStateEvent.CHANGE_CUR_SERVER_ID, name, server_id)
			Message.show("切换成功")
			this.Close()
		}
	}
	_img_bg: Laya.Image
	_img_bg2: Laya.Image
	_img_bg3: Laya.Image
	_img_close: Laya.Image
	_list_location: Laya.List
	_list_tab: Laya.List
	_list_item: Laya.List
	public GetComponents() {
		[
			this._img_bg,
			this._img_bg2,
			this._img_bg3,
			this._img_close,
			this._list_location,
			this._list_tab,
			this._list_item,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_img_bg2",
				"_img_bg3",
				"_img_close",
				"_list_location",
				"_list_tab",
				"_list_item",
			])
	}
}
window["LoginSelectServerView"] = LoginSelectServerView

import { BaseView1 } from "../common/BaseView1"
import { CommonManager } from "../common/CommonManager"
import { EventName, ObjectEventType, SceneEventType } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { GoodsModel } from "../commonModel/GoodsModel"
import { GuardModel } from "../commonModel/GuardModel"
import { MainUIModel } from "../commonModel/MainUIModel"
import { PlatformManager } from "../PlatformManager"
import { RoleManager } from "../commonModel/RoleManager"
import { SceneManager } from "../scene/SceneManager"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem, ClientConfig } from "../util/DeclareGlobalVar"
import { Mathf } from "../util/Mathf"
import { TimeUtil } from "../util/TimeUtil"
import { Util, GlobalTimerQuest, Trim, SetSizeDeltaX, SetAnchoredPosition, RefGridLayout, RefBoxChildsLayout } from "../util/Util"
import { CustomHeadItem } from "../common/CustomHeadItem"
import { MainUIMoneyItem } from "./MainUIMoneyItem"
import { ActivityIcon } from "./ActivityIcon"
import { Enum_UILayer } from "../common/LayerManager"
import { SettingModel } from "../commonModel/SettingModel"
import { Config } from "../common/Config"
import { GameResPath } from "../util/GameResPath"
import { ActivityIconManager } from "../commonModel/ActivityIconManager"
import { VipModel } from "../commonModel/VipModel"
import { DressModel, DressType } from "../commonModel/DressModel"
import { PkStatusModel } from "../commonModel/PkStatusModel"
import { Point } from "../scene/AstarManager"
import { MaskModel } from "../commonModel/MaskModel"
import { RoleVo } from "../sharedata/RoleVo"
import { MainUITopBuffItem } from "./MainUITopBuffItem"
import { HaloModel } from "../commonModel/HaloModel"
import { CookieWrapper } from "../common/CookieWrapper"
export class MainUITopView extends BaseView1 {

	timer_id
	map_visible
	head_visible
	hp_width = 182
	default_money_list = [0, 1, 2]
	last_recv_time
	check_outtime_state
	money_item_list = []
	money_type
	ping_state
	buff_item_list
	local_cookie_manager
	cache_box_map_visible = true

	mainUI_model: MainUIModel
	role_mgr: RoleManager
	platform_mgr: PlatformManager
	public constructor() {
		super()

		this.base_file = "mainUI"
		this.layout_file = "MainUITopView"
		this.layer_value = Enum_UILayer.Main
		this.is_delay_callback = false
		this.destroy_imm = false

		this.mainUI_model = MainUIModel.GetInstance()
		this.role_mgr = RoleManager.GetInstance()
		this.platform_mgr = PlatformManager.GetInstance()

		this.local_cookie_manager = CookieWrapper.GetInstance()

		this.load_callback = () => {
			if (PlatformManager.IsEyouThPlatform()) {
				this._img_fight.pos(86, 7)
				this._img_fight.width = 74
				this._img_fight.height = 23
				this._lb_fighting.pos(163, 9)
			}

			ResManager.GetInstance().LoadFont(this, "mainui_top_head_fight", this._lb_fighting, 32, false, () => {
				this.RefreshRoleFighting()
			})

			this._lb_scene_name.fontSize = 2 * this._lb_scene_name.fontSize
			this._lb_scene_name.scale(0.5, 0.5)
			this._lb_role_pos.fontSize = 2 * this._lb_role_pos.fontSize
			this._lb_role_pos.scale(0.5, 0.5)
			this._lb_time.fontSize = 2 * this._lb_time.fontSize
			this._lb_time.scale(0.5, 0.5)
			this._lb_buff_other_count.fontSize = 2 * this._lb_buff_other_count.fontSize
			this._lb_buff_other_count.scale(0.5, 0.5)
			this._lb_hp.fontSize = 2 * this._lb_hp.fontSize
			this._lb_hp.scale(0.5, 0.5)
			// this._lb_fighting.fontSize = 2 * this._lb_fighting.fontSize
			// this._lb_fighting.scale(0.5, 0.5)
			this._lb_lv.fontSize = 2 * this._lb_lv.fontSize
			this._lb_lv.scale(0.5, 0.5)

			this.LoadSuccess()
		}

		this.destroy_callback = () => {
			this.CancelTimer()
		}
	}


	LoadSuccess() {
		this.mainUI_model.SetMainuiLoadedFlag(this.layout_file, true)

		this.display_obj.centerX = 0
		this.display_obj.top = 0
		// this.display_obj.cacheAs = "bitmap"
		this.display_obj.drawCallOptimize = true
		let liu_hai_height = Util.GetLiuhaiHeight()
		if (liu_hai_height && liu_hai_height > 0) {
			this.display_obj.top = liu_hai_height
		}

		if (this.map_visible != null) {
			this.SetMapVisible(this.map_visible)
		}

		if (this.head_visible != null) {
			this.SetHeadVisible(this.head_visible)
		}

		this.SetMoneyType(this.money_type)

		this.InitView()
		this.InitEvent()
		this.StartTimer()

		GlobalEventSystem.Fire(EventName.MAINUI_TOP_LOAD_SUCCEED)

		//抖音小程序特殊处理：审核服状态下，右上角地图屏蔽不显示；
		if(PlatformManager.GetInstance().is_wx_alpha && Util.IsTTGame()){
			this.cache_box_map_visible = false
			this._box_map.visible = false
		}
	}

	InitEvent() {
		Util.AddClickEvent(this._box_halo, () => {
			GlobalEventSystem.Fire(EventName.OPEN_VIEW, "HaloMainView")
			let cookie = this.local_cookie_manager.GetCookie(CookieWrapper.HALO_RED_OPEN_STATE)
			if(cookie == "1"){
				this.local_cookie_manager.SaveCookie(CookieWrapper.HALO_RED_OPEN_STATE, "0")
				this.SetHaloIconRedState(false)
			}

		}, this, true)

		Util.AddClickEvent(this._box_cs, () => {
			if (Util.IsWXGame()) {
				let local_wx
				local_wx = window["wx"]
				if (local_wx && local_wx.openCustomerServiceConversation) {
					local_wx.openCustomerServiceConversation()
				}
			} else {
				this.platform_mgr.EyouOpenGM()
			}
		}, this, true)

		Util.AddClickEvent(this._box_fight_mode, () => {
			let scene_info = SceneManager.GetInstance().GetSceneInfo()
			if (scene_info) {
				if (scene_info.subtype == 0 || scene_info.subtype == 1 || scene_info.subtype == 2) {
					Message.show("当前场景不允许切换PK状态")
				} else {
					GlobalEventSystem.Fire(EventName.OPEN_VIEW, "MainUIFightModeView", true)
				}
			}
		}, this, true)

		Util.AddClickEvent(this._box_buff, () => {
			let buff_list = this.mainUI_model.buff_list
			if (buff_list && buff_list.length > 0) {
				GlobalEventSystem.Fire(EventName.OPEN_VIEW, "MainUIBuffView", true)
			} else {
				Message.show("当前没有Buff")
			}
		}, this, false)

		Util.AddClickEvent(this._box_vip, () => {
			GlobalEventSystem.Fire(EventName.OPEN_VIP_VIEW)
		}, this, true)

		Util.AddClickEvent(this._box_recharge, () => {
			VipModel.GetInstance().Fire(VipModel.OPEN_VIEW, 'RechargeView')
		}, this, true)

		Util.AddClickEvent(this._box_map, () => {
			GlobalEventSystem.Fire(EventName.OPEN_MAP_VIEW, "MapEnterView")
		}, this)

		Util.AddClickEvent(this._img_head, () => {
			SettingModel.GetInstance().Fire(SettingModel.SETTING_OPEN_VIEW, "SettingView")
		}, this)

		let delay_timer_id = null
		this.BindEvent(this.role_mgr.GetMainRoleVo(), EventName.CHANGE_LEVEL, () => {
			if (delay_timer_id) {
				clearTimeout(delay_timer_id)
				delay_timer_id = null
			}
			if (!delay_timer_id) {
				delay_timer_id =
					setTimeout(() => {
						delay_timer_id = null
						this.RefreshLevel()
						this.UpdateHaloIcon(true)
					}, 50)
			}
		})

		this.BindEvent(GlobalEventSystem, EventName.GAME_START, () => {
			this.InitView()
		})

		this.BindEvent(GlobalEventSystem, EventName.UPDATE_NEWEST_TASK_ID, () => {
			this.UpdateHaloIcon(true)
		})

		this.BindEvent(GlobalEventSystem, EventName.OPEN_HALO_ICON, (bool?) => {
			this.UpdateHaloIcon(bool)
		})

		this.BindVar(this.role_mgr.GetMainRoleVo(), "fighting", () => {
			this.RefreshRoleFighting()
		})

		this.BindVar(this.role_mgr.GetMainRoleVo(), "vip_flag", () => {
			this.RefreshRoleVip()
		})

		this.BindVar(this.role_mgr.GetMainRoleVo(), "pk_status", () => {
			this.RefreshPkStatus()
		})

		this.BindVar(this.role_mgr.GetMainRoleVo(), "picture_ver", () => {
			this.RefreshHead()
		})

		this.BindVar(this.role_mgr.GetMainRoleVo(), "picture", () => {
			this.RefreshHead()
		})

		this.BindVar(this.role_mgr.GetMainRoleVo(), "dress_list", () => {
			this.RefreshHeadFrame()
		})

		this.BindVar(this.role_mgr.GetMainRoleVo(), "career", () => {
			this.RefreshHead()
		})

		this.BindEvent(GlobalEventSystem, ObjectEventType.MAINROLE_MOVE_EVENT, (x?, y?) => {
			this.RefreshMainRolePos(x, y)
		})

		this.BindEvent(GlobalEventSystem, SceneEventType.OPEN_SCENE_LOAD_VIEW, (x?, y?) => {
			this.RefreshSceneName()
			this.RefreshMainRolePos(this.role_mgr.GetMainRoleVo().pos_x, this.role_mgr.GetMainRoleVo().pos_y)
		})


		this.BindVar(this.role_mgr.GetMainRoleVo(), "hp", () => {
			this.RefreshRoleHp()
		})

		this.BindVar(this.role_mgr.GetMainRoleVo(), "maxHp", () => {
			this.RefreshRoleHp()
		})

		this.BindEvent(RoleManager.GetInstance().GetMainRoleVo(), EventName.UPDATE_MAIN_ROLE_INFO_VIEW, () => {
			this.RefreshRoleHp()
		})

		this.BindEvent(GlobalEventSystem, EventName.LOADMAP_COMPLETE, () => {
			this.RefreshSceneName()
		})

		this.BindEvent(VipModel.GetInstance(), VipModel.UPDATE_VIP_RED, (bool?) => {
			this._img_vip_red.visible = bool
		})

		this.BindEvent(GlobalEventSystem, EventName.ALPHA_STATE_CHANGE, () => {
			this.AlphaStateChange()
		})

		this.BindEvent(GlobalEventSystem, EventName.HIDE_MAINUI_FIGHT_NUM, (bool?) => {
			if (this._lb_fighting.visible != bool) {
				this._img_fight.visible = this._lb_fighting.visible = bool
			}
		})

		this.BindEvent(GlobalEventSystem, EventName.CHECK_ALIVE_GAME_RESPONSE, () => {
			if (!this.last_recv_time) {
				return
			}
			let nowTime = TimeUtil.getServerTime()
			let timeInterval = (nowTime - this.last_recv_time)
			//显示ping值
			if (timeInterval < 0) {
				return
			}
			if (timeInterval < 100) {
				this.SetPingState(0)
			} else if (timeInterval < 200) {
				this.SetPingState(1)
			} else if (timeInterval < 300) {
				this.SetPingState(2)
			} else {
				this.SetPingState(3)
			}
			this.check_outtime_state = false

		})

		//显示无信号图片
		let pingTimeOutFunc = () => {
			if (this.check_outtime_state) {
				this.SetPingState(0)
			}
		}

		//发送10006协议时触发，保存当前时间，1秒内没有回复，显示没信号的图片
		this.BindEvent(GlobalEventSystem, EventName.CHECK_ALIVE_GAME_SENT, () => {
			this.last_recv_time = TimeUtil.getServerTime()
			GlobalTimerQuest.AddDelayQuest(pingTimeOutFunc, 1)
			this.check_outtime_state = true
		})

		this.BindEvent(GlobalEventSystem, EventName.UPDATE_BUFF_DATA, () => {
			this.RefreshBuff()
		})
		
		this.BindEvent(GlobalEventSystem, EventName.UPDATE_TOP_HALO_ICON_RED_STATE , (bool?)=>{
			this.SetHaloIconRedState(bool)
		})
	}

	SetPingState = (state?) => {
		if (state == this.ping_state) { return }
		this.ping_state = state

		ResManager.GetInstance().SetImageSprite(this, this._img_wifi, "mainUI", "uizjm_001" + state, true)
	}

	AlphaStateChange() {
		this.UpdateCS()
		this.UpdateVipIcon()
		this.UpdateRechargeIcon()
		this.UpdateHaloIcon()
		RefBoxChildsLayout(this._box_icon, 12, 72, true, "left")
	}

	UpdateCS(need_refresh_icon_pos?){
		if(this.platform_mgr.is_alpha){
			this._box_cs.visible = false
		}
		else{
			if(ClientConfig && ClientConfig.cs_mode && ClientConfig.cs_mode == 1){
				this._box_cs.visible = true
			}
			else{
				this._box_cs.visible = false
			}
		}
		if(need_refresh_icon_pos){
			RefBoxChildsLayout(this._box_icon, 12, 72, true, "left")
		}
	}

	UpdateVipIcon(need_refresh_icon_pos?){
		if(this.platform_mgr.is_alpha){
			this._box_vip.visible = false
		}
		else{
			this._box_vip.visible = true
		}

		if(need_refresh_icon_pos){
			RefBoxChildsLayout(this._box_icon, 12, 72, true, "left")
		}
	}

	UpdateRechargeIcon(need_refresh_icon_pos?){
		if(this.platform_mgr.is_alpha){
			this._box_recharge.visible = false
		}
		else{
			this._box_recharge.visible = true
		}

		if(need_refresh_icon_pos){
			RefBoxChildsLayout(this._box_icon, 12, 72, true, "left")
		}
	}

	SetHaloIconRedState(bool?){
		this._img_halo_red.visible = bool
	}

	UpdateHaloIcon(need_refresh_icon_pos?){
		if(this.platform_mgr.is_alpha){
			this._box_halo.visible = false
		}
		else{
			if(HaloModel.GetInstance().GetOpenState()){
				this._box_halo.visible = true
				let cookie = this.local_cookie_manager.GetCookie(CookieWrapper.HALO_RED_OPEN_STATE)
				if(!cookie){
					this.local_cookie_manager.SaveCookie(CookieWrapper.HALO_RED_OPEN_STATE, "1")
				}
			}
			else{
				this._box_halo.visible = false
			}
			this.SetHaloIconOriginalRedState()
		}
		if(need_refresh_icon_pos){
			RefBoxChildsLayout(this._box_icon, 12, 72, true, "left")
		}
	}

	SetHaloIconOriginalRedState(){
		let cookie = this.local_cookie_manager.GetCookie(CookieWrapper.HALO_RED_OPEN_STATE)
		if(cookie){
			if(cookie == "1" || this.mainUI_model.hale_red_show){
				this.SetHaloIconRedState(true)
			}
		}
	}

	InitView() {
		// this._lb_role_pos.visible = false
		this.RefreshRoleHp()
		this.RefreshRoleVip()
		this.RefreshRoleFighting()
		this.RefreshPkStatus()
		this.RefreshHead()
		this.RefreshHeadFrame()
		this.RefreshLevel()
		this.RefreshBuff()
		this.RefreshSceneName()
		this.RefreshMainRolePos(this.role_mgr.GetMainRoleVo().pos_x, this.role_mgr.GetMainRoleVo().pos_y)
		this.AlphaStateChange()
	}

	RefreshSceneName() {
		let scene_id = SceneManager.GetInstance().GetSceneId()
		let scene_cfg = scene_id && Config.PRELOAD_SERVER_CONFIG.config_scene && Config.PRELOAD_SERVER_CONFIG.config_scene[scene_id]
		if (scene_cfg) {
			this._lb_scene_name.text = Trim(scene_cfg.name)
		} else {
			this._lb_scene_name.text = "未知场景"
		}
	}

	RefreshMainRolePos(x, y) {

		// x = Math.floor(x) || 0
		// y = Math.floor(y) || 0

		// this._lb_role_pos.changeText(x + "," + y)
		// this._lb_role_pos.text = x + "," + y
	}

	RefreshRoleVip() {
		let main_role = this.role_mgr.GetMainRoleVo()
		let vip_flag_desc = main_role.vip_flag
		let res_name = "x_vip" + vip_flag_desc
		if (main_role.supreme_vip == 1) {
			ResManager.GetInstance().SetImageSprite(this, this._img_vip_bg, this.base_file, "mainui_icon_sup_vip")
		}
		else {
			ResManager.GetInstance().SetImageSprite(this, this._img_vip_bg, this.base_file, "mainui_icon_vip")
		}
		ResManager.GetInstance().SetImageSprite(this, this._img_vip, this.base_file, res_name)
	}

	RefreshRoleFighting() {
		this._lb_fighting.changeText(`${this.role_mgr.GetMainRoleVo().fighting}`)
	}

	RefreshRoleHp() {
		let main_role = this.role_mgr.GetMainRoleVo()
		this._lb_hp.changeText(main_role.hp + "/" + main_role.maxHp)

		let persent
		if (main_role.maxHp == 0) {
			persent = 0
		} else {
			persent = main_role.hp / main_role.maxHp
		}
		SetSizeDeltaX(this._img_hp, Math.min(1, persent) * this.hp_width)
	}

	RefreshHead() {
		let role_vo = this.role_mgr.GetMainRoleVo()
		let picture = role_vo.picture
		if (picture && picture != "") {
			let headStr: string = DressModel.GetInstance().getHeadICon(picture)
			// let config_picture = ResManager.GetInstance().GetGameConfigFromCache(this, "config_picture", false)
			// let picture_cfg = config_picture && config_picture[Number(picture)]

			if (headStr) {
				this._img_head.skin = GameResPath.GetIcon("head", headStr)
			} else {
				headStr = DressModel.GetInstance().getHeadICon(91)
				this._img_head.skin = GameResPath.GetIcon("head", headStr)
			}
		} else {
			this._img_head.skin = GameResPath.GetIcon("head", DressModel.GetInstance().getHeadICon(91))
		}
	}

	RefreshHeadFrame() {
		let role_vo = this.role_mgr.GetMainRoleVo()
		let dress_list = role_vo.dress_list
		if (dress_list) {
			let frame_id = DressModel.GetInstance().GetDressByType(dress_list, DressType.Photo)
			if (frame_id) {
				this._img_frame.visible = true
				this._img_frame.skin = GameResPath.GetIcon("head", "2_" + frame_id)
			} else {
				this._img_frame.visible = false
			}
		} else {
			this._img_frame.visible = false
		}
	}

	RefreshLevel() {
		let role_vo = this.role_mgr.GetMainRoleVo()
		let lv = role_vo.level
		let show_level, show_lv_bg
		if (lv > RoleVo.SHEN_CHUANG_LV) {
			show_lv_bg = "mainui_head_circle_purple"
			show_level = lv - RoleVo.SHEN_CHUANG_LV
			this._lb_lv.color = "#fee54a"
		}
		else {
			show_lv_bg = "mainui_head_circle_blue"
			show_level = lv
			this._lb_lv.color = "#ffffff"
		}
		this._img_lv_bg.skin = GameResPath.GetIcon("mainUI", show_lv_bg)
		this._lb_lv.changeText(show_level)

	}

	RefreshPkStatus() {
		let role_vo = this.role_mgr.GetMainRoleVo()
		let info = PkStatusModel.FightModeInfo[role_vo.pk_status]
		if (info) {
			ResManager.GetInstance().SetImageSprite(this, this._img_fight_mode, this.base_file, info.main_source)
		}
	}

	SetHeadVisible(bool) {
		if (this.is_loaded) {
			this._box_head.visible = bool
		} else {
			this.head_visible = bool
		}
	}

	SetMapVisible(bool) {
		if (this.is_loaded) {
			this._box_map.visible = this.cache_box_map_visible && bool
			this._box_icon.visible = bool
		} else {
			this.map_visible = bool
		}
	}

	SetMoneyType(list?) {
		if (this.is_loaded) {
			if (!list) {
				list = this.platform_mgr.is_alpha ? [1, 2] : this.default_money_list
			}
			for (let index = 0; index < list.length; index++) {
				var value = list[index]
				let item = this.money_item_list[index]
				if (!item) {
					item = new MainUIMoneyItem(this._box_money)
					this.money_item_list[index] = item
					item.Load()
				}
				item.SetMoneyType(value)
			}
		} else {
			this.money_type = list
		}
	}

	GetMoneyPos(money_type) {
		if (this.money_item_list) {
			for (let _ = 0; _ < this.money_item_list.length; _++) {
				var item = this.money_item_list[_]
				if (item.money_type == money_type) {
					let pos = this._box_money.localToGlobal(new Laya.Point(0, 0))
					pos.y += 16.5
					if (money_type == 0) {
						pos.x += 20.5
					} else if (money_type == 1) {
						pos.x += 154.5//132 +2 +20
					} else {
						pos.x += 285//(132+2)*2 +20
					}
					return pos
				}
			}
		}
		return {}
	}

	RefreshBuff() {
		let buff_list = this.mainUI_model.buff_list
		if (buff_list && buff_list.length > 0) {
			//Test

			let len = buff_list.length
			if (len > 4) {
				this._img_buff_count_bg.visible = true
				this._lb_buff_other_count.text = `+${len - 4}`
			}
			else {
				this._img_buff_count_bg.visible = false
			}

			if (!this.buff_item_list) {
				this.buff_item_list = []
			}
			let buff_data, item
			for (let i = 0; i < 4; i++) {
				item = this.buff_item_list[i]
				buff_data = buff_list[i]
				if (buff_data) {
					if (!item) {
						item = new MainUITopBuffItem(this._box_buff)
						item.Load()
						this.buff_item_list[i] = item
					}
					item.SetData(buff_data)
					item.SetVisible(true)
					item.SetPosition(i * 36, 0)
				}
				else {
					if (item) {
						item.SetVisible(false)
					}
				}
			}
		} else {
			for (let i in this.buff_item_list) {
				let item = this.buff_item_list[i]
				item.SetVisible(false)
			}
		}
	}

	StartTimer() {
		var onTimer = () => {
			this._lb_time.text = TimeUtil.timeConversion(TimeUtil.getServerTime(), "hh:MM")
		}
		this.timer_id = GlobalTimerQuest.AddPeriodQuest(onTimer, 33, -1)
		onTimer()
	}

	CancelTimer() {
		if (this.timer_id) {
			GlobalTimerQuest.CancelQuest(this.timer_id)
			this.timer_id = null
		}
	}

	_box_root: Laya.Box
	_box_icon: Laya.Box
	_box_vip: Laya.Box
	_img_vip_bg: Laya.Image
	_img_vip: Laya.Image
	_img_vip_red: Laya.Image
	_box_recharge: Laya.Box
	_img_recharge_bg: Laya.Image
	_img_recharge_red: Laya.Image
	_box_halo: Laya.Box
	_img_halo: Laya.Image
	_img_halo_red: Laya.Image
	_box_cs: Laya.Box
	_img_cs: Laya.Image
	_img_cs_red: Laya.Image
	_box_money: Laya.HBox
	_box_map: Laya.Box
	_img_map_bg: Laya.Image
	_lb_scene_name: Laya.Label
	_lb_role_pos: Laya.Label
	_img_wifi: Laya.Image
	_lb_time: Laya.Label
	_img_power_bg: Laya.Image
	_img_power: Laya.Image
	_box_head: Laya.Box
	_img_head_bg: Laya.Image
	_img_hp: Laya.Image
	_box_buff: Laya.Box
	_img_buff_count_bg: Laya.Image
	_lb_buff_other_count: Laya.Label
	_img_head: Laya.Image
	_img_frame: Laya.Image
	_img_fight: Laya.Image
	_lb_hp: Laya.Label
	_lb_fighting: Laya.Label
	_box_lv: Laya.Box
	_img_lv_bg: Laya.Image
	_lb_lv: Laya.Label
	_box_fight_mode: Laya.Box
	_img_fight_mode: Laya.Image
	public GetComponents() {
		[
			this._box_root,
			this._box_icon,
			this._box_vip,
			this._img_vip_bg,
			this._img_vip,
			this._img_vip_red,
			this._box_recharge,
			this._img_recharge_bg,
			this._img_recharge_red,
			this._box_halo,
			this._img_halo,
			this._img_halo_red,
			this._box_cs,
			this._img_cs,
			this._img_cs_red,
			this._box_money,
			this._box_map,
			this._img_map_bg,
			this._lb_scene_name,
			this._lb_role_pos,
			this._img_wifi,
			this._lb_time,
			this._img_power_bg,
			this._img_power,
			this._box_head,
			this._img_head_bg,
			this._img_hp,
			this._box_buff,
			this._img_buff_count_bg,
			this._lb_buff_other_count,
			this._img_head,
			this._img_frame,
			this._img_fight,
			this._lb_hp,
			this._lb_fighting,
			this._box_lv,
			this._img_lv_bg,
			this._lb_lv,
			this._box_fight_mode,
			this._img_fight_mode,
		]
			= this.GetChildrenByNames([

				"_box_root",
				"_box_icon",
				"_box_vip",
				"_img_vip_bg",
				"_img_vip",
				"_img_vip_red",
				"_box_recharge",
				"_img_recharge_bg",
				"_img_recharge_red",
				"_box_halo",
				"_img_halo",
				"_img_halo_red",
				"_box_cs",
				"_img_cs",
				"_img_cs_red",
				"_box_money",
				"_box_map",
				"_img_map_bg",
				"_lb_scene_name",
				"_lb_role_pos",
				"_img_wifi",
				"_lb_time",
				"_img_power_bg",
				"_img_power",
				"_box_head",
				"_img_head_bg",
				"_img_hp",
				"_box_buff",
				"_img_buff_count_bg",
				"_lb_buff_other_count",
				"_img_head",
				"_img_frame",
				"_img_fight",
				"_lb_hp",
				"_lb_fighting",
				"_box_lv",
				"_img_lv_bg",
				"_lb_lv",
				"_box_fight_mode",
				"_img_fight_mode",
			])
	}
}
window["MainUITopView"] = MainUITopView
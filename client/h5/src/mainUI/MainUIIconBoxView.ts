import { BaseView1 } from "../common/BaseView1"
import { CommonManager } from "../common/CommonManager"
import { Config } from "../common/Config"
import { Enum_UILayer, LayerManager } from "../common/LayerManager"
import { table } from "../common/table"
import { Mathf } from "../util/Mathf"
import { SetLocalPositionX, SetLocalPositionY, SetLocalScaleY, SetAnchoredPosition, Util, SetSizeDelta, GlobalTimerQuest } from "../util/Util"
import { Vector2 } from "../util/Vector2"
import { ActivityIcon } from "./ActivityIcon"
import { ActivityIconManager } from "../commonModel/ActivityIconManager"
import { PlatformManager } from "../PlatformManager"
import { ResManager } from "../common/ResManager"
import { ClientConfig } from "../util/DeclareGlobalVar"
import { LoginModel } from "../login/LoginModel"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"

export class MainUIIconBoxView extends BaseView1 {
	StartTimer
	destroy_imm
	RefreshSizeAndPos
	CreateItem
	OnTime
	open_callback
	LoadSuccess
	background_alpha
	GetOpenAndDeleteIcons
	use_background
	Local_Open
	DeleteItem
	click_bg_toClose
	SetPos
	CancelTimer
	change_scene_close
	CheckOpenIcon
	hide_maincancas
	InitEvent
	RefreshIcon
	destroy_callback
	bg: Laya.Image
	icon_con: Laya.Box
	arrow: Laya.Image

	public constructor() {
		super()

		this.base_file = "mainUI"
		this.layout_file = "MainUIIconBoxView"
		this.layer_value = Enum_UILayer.UI

		this.use_background = true
		this.background_alpha = 0
		this.hide_maincancas = false
		this.click_bg_toClose = true
		this.change_scene_close = true
		this.destroy_imm = true
		let layer_mgr = LayerManager.GetInstance()
		let local_ActivityIcon = ActivityIcon
		let local_CommonManager_Instance = CommonManager.GetInstance()
		let local_ActivityIconManager_Instance = ActivityIconManager.GetInstance()
		let local_CustomActivityModel_Instance = CustomActivityModel.GetInstance()

		let icon_type_ = null
		let offset_ = null
		let pos_ = null
		let direction_ = null
		let close_time_ = 1000
		let close_time_id_ = null
		let icon_list_ = []
		let con_x_ = 0
		let con_y_ = 0
		this.preload_client_config = {
			"ClientAddVipService": false
		}
		this.load_callback = () => {
			//this.display_obj.hitTestPrior = false
			this.LoadSuccess()
			this.SetPos()
			this.InitEvent()
		}

		this.open_callback = () => {

			this.StartTimer()
			this.RefreshIcon()
		}

		this.destroy_callback = () => {
			this.CancelTimer()
			let item = null
			for (let key in icon_list_) {

				item = icon_list_[key]
				item.DeleteMe()
			}
			icon_list_ = []
		}

		this.LoadSuccess = () => {
			// this.form.anchorMax = Vector2(0, 0)
			// this.form.anchorMin = Vector2(0, 0)
			// this.form.pivot = Vector2(0, 1)

			//lua_resM:SetImageSprite(this, this.bg, this.base_file + "_asset", "mainui_ui_box_1")
			con_x_ = this.icon_con.x
			con_y_ = this.icon_con.y
		}

		this.Local_Open = (...new_args) => {
			//let parms = []

			icon_type_ = new_args[0]
			pos_ = new_args[1]
			offset_ = new_args[2]
			direction_ = new_args[3]
			//pos_ = parms[2]
			//offset_ =  parms[3]
			//direction_ = parms[4]

			if (icon_type_ != null && pos_ != null) {
				super.Open()
			}
		}

		this.InitEvent = () => {
		}

		this.SetPos = () => {
			if (direction_ == 2) {
				this.arrow.x = 60
				this.arrow.scaleY = 1
				this.arrow.y = 100 //121

			}

			// let offSet = 0
			// if (this.direction == 2) {
			// 	this.arrow.y = 140
			// 	this.arrow.scaleY = -1
			// 	offSet = -128
			// }



			//let screen_pos = MainCamera.Instance.uiCamera.WorldToScreenPoint(pos_)

			let offset_x = 0
			let offset_y = 0

			if (offset_ != null) {
				offset_x = offset_.x
				offset_y = offset_.y
			}

			this.display_obj.x = pos_.x + local_ActivityIcon.WIDTH / 2 - this.arrow.width / 2 + offset_x
			this.display_obj.y = pos_.y + local_ActivityIcon.HEIGHT / 2 + offset_y
			let y = this.display_obj.y
			// SetAnchoredPosition(
			// 	this,
			// 	pos_.x + offset_x,
			// 	pos_.y + offset_y
			// )
		}

		this.RefreshIcon = () => {
			let item = null
			let vo = null
			let [open_icons, delete_icons] = this.GetOpenAndDeleteIcons()
			for (let i = 0; i < open_icons.length; i++) {
				vo = open_icons[i]
				item = icon_list_[vo.icon_type]
				if (!item) {
					item = this.CreateItem(vo.icon_type)
					if(!item) break
				}
				item.SetVisible(true)
				SetLocalPositionX(item.display_obj, i % 6 * local_ActivityIcon.WIDTH)
				SetLocalPositionY(item.display_obj, Math.floor(i / 6) * local_ActivityIcon.HEIGHT)
			}
			for (let _tmpi in delete_icons) {
				this.DeleteItem(delete_icons[_tmpi].icon_type)
			}
			this.RefreshSizeAndPos()
		}

		this.RefreshSizeAndPos = () => {
			let width = 0
			let height = 0
			let num = Util.TableSize(icon_list_)
			if (num <= 0) {
				this.Close()
				return
			}
			if (num >= 6) {
				width = 6 * local_ActivityIcon.WIDTH + con_x_ * 2
				height = Math.ceil(num / 6) * local_ActivityIcon.HEIGHT + con_y_
			} else {
				width = num * local_ActivityIcon.WIDTH + con_x_ * 2
				height = local_ActivityIcon.HEIGHT + con_y_
			}
			this.bg.width = width
			this.bg.height = height
			let pos = new Laya.Point(this.bg.x,this.bg.y)
			let bg_global_pos = this.bg.localToGlobal(pos)

			if ((bg_global_pos.x + width) > layer_mgr.stageWidth) {
				this.bg.x = this.bg.x - (bg_global_pos.x + width - layer_mgr.stageWidth)
				this.icon_con.x = this.icon_con.x - (bg_global_pos.x + width - layer_mgr.stageWidth) + con_x_
			} else if (bg_global_pos.x < 0) {
				this.bg.x = 0
				this.icon_con.x = 0 + con_x_
			}
		}

		this.CreateItem = (iconType?) => {
			let iconInfo = local_CommonManager_Instance.GetFunctionIconCfg(iconType)
			if (PlatformManager.GetInstance().is_alpha &&(!iconInfo || iconInfo.need_hide_in_alpha)) {
				return
			}
			if(Number(iconType) == 114){
				let cfg = ResManager.GetInstance().GetGameConfigFromCache(this,"ClientAddVipService",true)
				let play_name = LoginModel.GetInstance().plat_name || ClientConfig.plat_name;
				if(cfg){
					for(let key in cfg){
						if(cfg[key].tem && cfg[key].icon_info && cfg[key].tem.indexOf(play_name) > -1){
							iconInfo.icon_name = cfg[key].icon_info.icon_name
							iconInfo.open_lv = cfg[key].icon_info.open_lv
							iconInfo.open_day= cfg[key].icon_info.open_day
						}
					}
				}
			} 
			let item = icon_list_[iconType]
			if (!item) {
				item = new local_ActivityIcon(this.icon_con)
				item.Load()
				item.SetIconType(iconType)
				icon_list_[iconType] = item
			} else {
				item.SetIconType(iconType)
			}
			return item
		}

		this.DeleteItem = (iconType?) => {
			let item = icon_list_[iconType]
			if (item) {
				item.DeleteMe()
				icon_list_[iconType] = null
				this.RefreshIcon()
			}
		}

		this.GetOpenAndDeleteIcons = () => {
			let open_icons = []
			let delete_icons = []
			let cfg = Config.PRELOAD_CLIENT_CONFIG.ConfigBoxIcon
			for (let key in cfg) {

				let vo = cfg[key]
				if (vo.attach_icon_type == icon_type_) {
					if (this.CheckOpenIcon(key)) {
						table.insert(open_icons, vo)
					} else {
						table.insert(delete_icons, vo)
					}
				} else {
					table.insert(delete_icons, vo)
				}
			}

			table.sort(
				open_icons, (a?, b?) => {
					return a.sort_order < b.sort_order
				}
			)

			return [open_icons, delete_icons]
		}

		this.CheckOpenIcon = (icon_type?) => {
			if(icon_type == 114){
				let cfg = ResManager.GetInstance().GetGameConfigFromCache(this,"ClientAddVipService",true)
				let play_name = LoginModel.GetInstance().plat_name || ClientConfig.plat_name;
				let is_can_add =false
				if(cfg){
					for(let key in cfg.tem){
						if(cfg.tem[key] == play_name){
							is_can_add = true
							break
						}
					}
					if(!is_can_add){
						return false
					}
				}

			}
			let box_icon_cfg = local_CommonManager_Instance.GetBoxIconCfg(icon_type)
			let can_add = local_ActivityIconManager_Instance.NeedInputBox(box_icon_cfg)
			if (box_icon_cfg.controll_by_own_fun) {
				can_add = local_ActivityIconManager_Instance.getBoxIconInfo(icon_type) != null
			}
			if (local_CustomActivityModel_Instance.IsActIcon(icon_type) ) {
				return local_CustomActivityModel_Instance.GetOpenState(icon_type) && can_add
			}else{
			return can_add
			}
		}

		this.StartTimer = () => {
			close_time_ = 10
			this.CancelTimer()

			close_time_id_ =
				GlobalTimerQuest.AddDelayQuest(() => {
					this.OnTime()
				},
					1
				)
			this.OnTime()
		}

		this.OnTime = () => {
			close_time_ = close_time_ - 1
			if (close_time_ <= 0) {
				this.CancelTimer()
				this.Close()
			}
		}

		this.CancelTimer = () => {
			if (close_time_id_) {
				GlobalTimerQuest.CancelQuest(close_time_id_)
				close_time_id_ = null
			}
		}
	}

	public Open(...new_args) {

		this.Local_Open(...new_args)
	}


	public GetComponents() {
		[
			this.bg,
			this.icon_con,
			this.arrow,
		]
			= this.GetChildrenByNames([

				"bg",
				"icon_con",
				"arrow",
			])
	}
}
window["MainUIIconBoxView"] = MainUIIconBoxView
import { BaseItem1 } from "../common/BaseItem1"
import { Config } from "../common/Config"
import { EventName } from "../common/EventName"
import { OpenFun } from "../common/OpenFun"
import { ResManager } from "../common/ResManager"
import { RoleManager } from "../commonModel/RoleManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { SYTweenFunc } from "../util/SYTweenFunc"
import { SYTweenLite } from "../util/SYTweenLite"
import { Util } from "../util/Util"
import { MaterialsTool } from "../common/MaterialsTool"
import { PlatformManager } from "../PlatformManager"
import { ShopEvent, ShopModel } from "../commonModel/ShopModel"
import { MainUIController } from "../commonController/MainUIController"
export class MainUIMoneyItem extends BaseItem1 {
	LoadSuccess
	RefreshType
	SetValue
	PlayAnimation
	SetMoneyType
	money_type
	effect_obj
	has_set_effect
	public constructor(parent?) {
		super(parent)
		this.base_file = "mainUI"
		this.layout_file = "MainUIMoneyItem"

		let local_Math = Math,
			local_RoleManager_Instance = RoleManager.GetInstance(),
			local_Config = Config,
			platform_mgr = PlatformManager.GetInstance(),

			playing_ani,
			need_refresh_data

		// let 

		this.load_callback = () => {
			this.LoadSuccess()
		}

		this.LoadSuccess = () => {
			if (need_refresh_data) {
				this.RefreshType()
			}
			need_refresh_data = false

			Util.AddClickEvent(this._img_add, () => {
				if (0 == this.money_type) {
					OpenFun.OpenFunHandler(21)
				} else if (1 == this.money_type) {
					let goods_id = local_Config.PRELOAD_CLIENT_CONFIG.ConfigNotNormalGoods[2].goods_id
					MaterialsTool.GetInstance().materialsTips(goods_id)
				} else if (2 == this.money_type) {
					let goods_id = local_Config.PRELOAD_CLIENT_CONFIG.ConfigNotNormalGoods[3].goods_id
					MaterialsTool.GetInstance().materialsTips(goods_id)
				}
			}, this, true)
		}

		this.RefreshType = () => {
			if (platform_mgr.is_alpha) {
				this._img_add.visible = false
				this.SetVisible(!(this.money_type == 0))
			} else {
				this._img_add.visible = true
				this.SetVisible(true)
			}

			//抖音小程序特殊处理：审核服状态下 货币上的+号去掉不显示，作为一个不可操作区
			if(PlatformManager.GetInstance().is_wx_alpha && Util.IsTTGame()){
				if(this.money_type == 1 || this.money_type == 2){
					this._img_add.visible = false
				}
			}

			this.UnBindEvents()
			let attr = null
			let icon_res = null
			if (0 == this.money_type) {
				icon_res = "diamond"
				attr = "jin"
			} else if (1 == this.money_type) {
				icon_res = "bind_diamond"
				attr = "jinLock"
			} else if (2 == this.money_type) {
				icon_res = "gold"
				attr = "tong"
			}
			ResManager.GetInstance().SetImageSprite(this, this._img_icon, this.base_file, icon_res)
			this.SetValue(attr)
			let update_view = () => {
				this.SetValue(attr)
			}
			this.BindVar(local_RoleManager_Instance.GetMainRoleVo(), attr, update_view)

			this.BindEvent(GlobalEventSystem, EventName.UPDATE_MAINUI_MONEY, (type, show_effect) => {
				if(type != this.money_type) return
				if(show_effect){
					if(!this.has_set_effect){
						this.has_set_effect = true
						this.AddUIEffect("ui_bangyu_3", this._box_effect, null, 3, null, null, null, (obj)=>{
							this.effect_obj = obj
						}, null, null, null, null, false)
					}
					else{
						if(this.effect_obj){
							this.effect_obj.active = false
							this.effect_obj.active = true
						}
					}
				}
				this.SetValue(attr)
			})

			this.BindEvent(GlobalEventSystem, EventName.ALPHA_STATE_CHANGE, () => {
				this.RefreshType()
			}
			)
			this.BindEvent(GlobalEventSystem, EventName.PLAY_MONEYITEM_ANI, (type?) => {
				if (this.money_type == type - 1) {
					this.PlayAnimation()
				}
			})
		}

		this.SetValue = (attr?) => {
			// if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
			// 	let value = local_RoleManager_Instance.GetMainRoleVo()[attr]
			// 	if (value >= 10000 && value < 1000000 ) {
			// 		value = value / 1000
			// 		value = string.format("%.2f", value)
			// 		this._value.text = value + "K"
			// 	} else if (value >= 1000000 && value < 100000000 ) {
			// 		value = local_Math.floor(value/1000)
			// 		this._value.text = value + "K"
			// 	} else if (value >= 100000000 && value < 10000000000 ) {
			// 		value = value / 1000000
			// 		value = string.format("%.2f", value)
			// 		this._value.text = value + "M"
			// 	} else if (value >= 10000000000 ) {
			// 		value = local_Math.floor(value/1000000)
			// 		this._value.text = value + "M"
			// 	}else{
			// 		this._value.text = value
			// 	}

			// }else{
			if(MainUIController.GetInstance().CheckShowDiamondCount(this.money_type)) return

			let value: number = local_RoleManager_Instance.GetMainRoleVo()[attr]
			if (this.money_type == 2) {
				if (value >= 10000 && value < 1000000) {
					value = value / 10000
					this._lb_value.text = value.toFixed(2) + "万"
				} else if (value >= 1000000 && value < 100000000) {
					value = local_Math.floor(value / 10000)
					this._lb_value.text = value + "万"
				} else if (value >= 100000000 && value < 10000000000) {
					value = value / 100000000
					this._lb_value.text = value.toFixed(2) + "亿"
				} else if (value >= 10000000000) {
					value = local_Math.floor(value / 100000000)
					this._lb_value.text = value + "亿"
				} else {
					this._lb_value.text = String(value)
				}
			}
			else {
				this._lb_value.text = String(value)
			}
		}

		this.SetMoneyType = (type?) => {
			this.money_type = type
			if (this.is_loaded) {
				this.RefreshType()
			} else {
				need_refresh_data = true
			}
		}

		this.PlayAnimation = () => {
			if (!playing_ani) {
				playing_ani = true
				if (window["SYTweenLite"]) {
					console.log("have SYTweenLite")
				} else {
					console.log("not have SYTweenLite")
				}
				// SYTweenLite.to(this, this._icon, SYTweenLite.UiAnimationType.SCALE, { x: 1.5, y: 1.5, z: 1.5 }, 0.3, () => {
				// 	playing_ani = false
				// }, SYTweenFunc.PINGPONG)
			}
		}

		this.DeleteMe = () =>{
			this.effect_obj = this.has_set_effect = false
			super.DeleteMe()
		}
	}

	_img_bg: Laya.Image
	_img_icon: Laya.Image
	_img_add: Laya.Image
	_lb_value: Laya.Label
	_box_effect: Laya.Box
	public GetComponents() {
		[
			this._img_bg,
			this._img_icon,
			this._img_add,
			this._lb_value,
			this._box_effect
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_img_icon",
				"_img_add",
				"_lb_value",
				"_box_effect"
			])
			this._lb_value.fontSize = 2 * this._lb_value.fontSize
			this._lb_value.scale(0.5, 0.5)
	}
}
window["MainUIMoneyItem"] = MainUIMoneyItem
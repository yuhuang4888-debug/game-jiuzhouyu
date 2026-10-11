import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { CommonManager } from "../common/CommonManager"
import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { ShopModel, ShopEvent, ShopType, ShopIndex } from "../commonModel/ShopModel"
import { PlatformManager } from "../PlatformManager"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { SoundManager } from "../common/SoundManager"
import { GuildModel } from "../commonModel/GuildModel"
import "../longlangExchange/LonglangExchangeView"
import { Config } from "../common/Config"
import { Util } from "../util/Util"
import { KfHolyAreaModel } from "../commonModel/KfHolyAreaModel"
import { RedDotController } from "../common/RedDotController"
import { RedKey } from "../common/RedDotDefine"


export class ShopView extends BaseWindowComponent {
	CheckRedDot
	CheckVieOpen
	IconFly
	InitMyEvent
	NotAlphaState
	SetBgList
	bg_list
	destroy_imm
	money_list
	nowSelectIndex
	preload_client_config
	preload_server_config
	tabStrList
	tab_new_cond
	titleList
	titleStr
	viewClassList
	window_load_back
	open_callback
	_Open
	public constructor() {
		super()
		this.dependent_res = ["shop"]
		let plat_form_mgr = PlatformManager.GetInstance()
		let shop_model = ShopModel.GetInstance()
		let local_ShopEvent = ShopEvent
		let custom_model = CustomActivityModel.GetInstance()
		let local_GlobalEventSystem = GlobalEventSystem
		let UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE = EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE
		let icon_fly_group_ = []
		let vie_shop_index_ = null
		let ClientShopConfig = null

		let speical_tab = 1

		this.preload_client_config = { "ClientShopConfig": false }

		this.destroy_imm = true
		vie_shop_index_ = 3		//抢购商城索引， 下表数组中抢购商城位置有变，该值也要跟着修改
		this.tabStrList = [
			{ label: "限购", shop_type: ShopType.Limit, icon_up_source: "shop_json.uisc_010_r2_c2_png", icon_down_source: "shop_json.uisc_010_r2_c1_png" },
			{ label: "勾玉", shop_type: ShopType.Diamond, icon_up_source: "shop_json.uisc_010_r1_c2_png", icon_down_source: "shop_json.uisc_010_r1_c1_png" },
			{ label: "绑玉", shop_type: ShopType.Bind_Diamond, icon_up_source: "shop_json.uisc_010_r3_c2_png", icon_down_source: "shop_json.uisc_010_r3_c1_png" },
			{ label: "抢购", shop_type: ShopType.Vie, icon_up_source: "shop_json.uibqy_002_r1_c4_png", icon_down_source: "shop_json.uibqy_002_r1_c3_png" },
			{ label: "善缘", shop_type: ShopType.Guild, icon_up_source: "shop_json.uisc_010_11_png", icon_down_source: "shop_json.uisc_010_10_png" },
			
			{ label: "荣耀", shop_type: ShopType.Honer, icon_up_source: "shop_json.uirysc_002_png", icon_down_source: "shop_json.uirysc_001_png" },
			//{label:"外观", shop_type:ShopType.Outward, icon_up_source:"shop_asset.uirw_013_r2_c2", icon_down_source:"shop_asset.uirw_013_r2_c1"}, 
			{ label: "夜行", shop_type: ShopType.GhostWalk, icon_up_source: "shop_json.xz2_png", icon_down_source: "shop_json.xz1_png" },
			{ label: "异域", shop_type: ShopType.MedalShop, icon_up_source: "shop_json.xz2_png", icon_down_source: "shop_json.xz1_png" },
			//{label:"功勋", shop_type:ShopType.ExploitShop, icon_up_source:"shop_asset.uirysc_002", icon_down_source:"shop_asset.uirysc_001"}, 
			{ label: "天境", shop_type: ShopType.SingleRank, icon_up_source: "shop_json.uikfdr_023_02_png", icon_down_source: "shop_json.uikfdr_023_01_png" },
			//{label:"幸运", shop_type:ShopType.Lucky, icon_up_source:"shop_asset.jnhb_001a", icon_down_source:"shop_asset.jnhb_001"}, 
			{ label: "神祭", shop_type: ShopType.LonglangEx, icon_up_source: "shop_json.uilwmb_012a_png", icon_down_source: "shop_json.uilwmb_012_png" },
			
			{ label: "神社", shop_type: ShopType.GodCourt, icon_up_source: "shop_json.uistjy_001_02_png", icon_down_source: "shop_json.uistjy_001_01_png" }]
		this.viewClassList = [
			"ShopCommonView", 
			"ShopCommonView", 
			"ShopCommonView",
			"ShopVieView",
			"ShopCommonView",

			"ShopCommonView",
			"ShopCommonView",
			"ShopCommonView",
			"ShopCommonView",
			"LonglangExchangeView", 

			"ShopCommonView"
		]
		this.viewClassModuleDic = {
			"0": { module_name: "shop", class_name: "ShopCommonView" },
			"1": { module_name: "shop", class_name: "ShopCommonView" },
			"2": { module_name: "shop", class_name: "ShopCommonView" },
			"3": { module_name: "shop", class_name: "ShopVieView" },
			"4": { module_name: "shop", class_name: "ShopCommonView" },

			"5": { module_name: "shop", class_name: "ShopCommonView" },
			"6": { module_name: "shop", class_name: "ShopCommonView" },
			"7": { module_name: "shop", class_name: "ShopCommonView" },
			"8": { module_name: "shop", class_name: "ShopCommonView" },
			"9": { module_name: "longlangExchange", class_name: "LonglangExchangeView" },

			"10": { module_name: "shop", class_name: "ShopCommonView" }
		}
		this.titleList = [
			"shop.ui_Shop_title",
			"shop.ui_Shop_title",
			"shop.ui_Shop_title",
			"shop.ui_Shop_title",
			"shop.ui_Shop_title",

			"shop.ui_Shop_title",
			"shop.ui_Shop_title",
			"shop.ui_Shop_title",
			"shop.ui_Shop_title",
			"shop.ui_Shop_title",

			"shop.ui_Shop_title"
		]

		//更新钻石商城界面红点
		this.onItemTouch = (itemIndex) => {
			if (Util.IsTableEmpty(this.viewList) || this.use_delete_method) return
			let view = this.viewList[itemIndex]
			//使切换页面后页面还是在最顶部
			if (view) {
				if (view.scroll_group) {
					view.scroll_group.scrollBar.value = 0
				}
			}
			this.SelectView(itemIndex, true)
		}

		this.SelectView = (index?, is_real_index?) =>{
			let local_index = index
			if(is_real_index){
				local_index = this.real_index_to_index[index]
			}
			if (local_index == speical_tab && shop_model.diamond_red_status) {
				shop_model.diamond_red_status = false;
				shop_model.have_enter_special_tab = true;
				local_GlobalEventSystem.Fire(UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "ShopView", ShopIndex.Diamond, false)
				GlobalEventSystem.Fire(EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 153, false)
			}
			super.SelectView(index, is_real_index)
		}

		this.SetBgList = () => {

			ClientShopConfig = ResManager.GetInstance().GetGameConfigFromCache(this, "ClientShopConfig", true)
			if (ClientShopConfig) {
				this.bg_list = []
				let vo = null
				let cfg = null

				for (let i = 0; i < this.tabStrList.length; i++) {
					vo = this.tabStrList[i]
					cfg = ClientShopConfig.ShopSeries[vo.shop_type]
					if (vo.shop_type!=ShopType.LonglangEx) {
						// if (cfg) {
						// 	this.bg_list[i] = "ui_Shop_bg1.jpg"
						// } else {
						// 	this.bg_list[i] = "ui_Shop_bg1.jpg"
						// }
						this.bg_list[i] = "ui_Shop_bg1.jpg"
					} else {
						this.bg_list[i] = "ui_bg_1.jpg"
					}
				}
			}

		}

		this.tab_new_cond = {
			0: () => {
				return this.NotAlphaState()	//限购
			},
			1: () => {
				return this.NotAlphaState()	//钻石
			},
			3: () => {					//抢购
				let a = false
				//let a = this.CheckVieOpen()
				let b = this.NotAlphaState()
				return a && b
				//return b
			},
			4: () => {					//声望
				return GuildModel.GetInstance().GuildIdolIsOpen()
			},
			5: () => {					//荣耀
				return CommonManager.GetInstance().CheckFuncOpenState("BattleFieldEnterView", true)
			},
			7: () => {					//异域
				return KfHolyAreaModel.GetInstance().GetOpenState()[0]
			},
			8: () => {					//天境
				return CommonManager.GetInstance().CheckFuncOpenState("kfSRMainView", true)
			},
			10: () => {					//神庭
				return CommonManager.GetInstance().CheckFuncOpenState("GodCourtView", true)
			}
		}



		//this.titleList = [[10]="shop_asset.uilydh_001"]
		// this.titleStr = "shop_json.uisc_001_png"
		// this.titleList = { "8": "shop_json.uilydh_001_png" }
		this.money_list = [2, 1, 0]

		this.window_load_back = () => {
			this.SetBgList()
			this.InitMyEvent()
			// this.onItemTouch(0)
			//this.CheckRedDot()
			// this.onItemTouch(0)
		}

		this.window_open_back = () => {
			//this.CheckRedDot()
			//延迟执行 界面执行完open_callback再更新红点
			Laya.timer.once(10, this, () => {
				this.CheckRedDot()
			})
		}

		//this.preload_client_config = [ClientShopConfig=false]
		//this.preload_server_config = [config_top_pk_rank_reward=false]

		this.NotAlphaState = () => {
			return !plat_form_mgr.is_alpha && !plat_form_mgr.need_alpha_open_charge
		}

		this.InitMyEvent = () => {
			let fly_fun = (data?, pos?) => {
				this.IconFly(data, pos)
			}
			this.BindEvent(shop_model, local_ShopEvent.SHOP_ICON_FLY, fly_fun)

			this.BindEvent(shop_model, local_ShopEvent.OUT_VIE_SHOP_DATA, () => {
				if (!this.CheckVieOpen() && this.viewClassList[vie_shop_index_] == "ShopVieView") {
					if (!this.nowSelectIndex) {
						return
					}
					if (this.nowSelectIndex == vie_shop_index_) {
						this.Close()
					} else {
						table.remove(this.tabStrList, vie_shop_index_)
						table.remove(this.viewClassList, vie_shop_index_)
						this.nowSelectIndex = this.nowSelectIndex > vie_shop_index_ && this.nowSelectIndex - 1 || this.nowSelectIndex
						this.SetDefaultIndex(this.nowSelectIndex)
						//this.nowSelectIndex = null
						let view = this.viewList[vie_shop_index_]
						if (view) {
							view.DeleteMe()
							this.viewList[vie_shop_index_] = null
						}
						//this:InitTabItem()
					}
				}
			}
			)
		}

		this.CheckRedDot = () => {
			let limit_red = shop_model.limit_red_status && custom_model.GetDayFirstLoginStatus()
			local_GlobalEventSystem.Fire(UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "ShopView", ShopIndex.Limit, limit_red)

			// let vie_red = shop_model.vie_red_stutus
			// local_GlobalEventSystem.Fire(UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "ShopView", vie_shop_index_, vie_red)

			let Honer_red = shop_model.Honer_red_status && custom_model.GetDayFirstLoginStatus()
			local_GlobalEventSystem.Fire(UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "ShopView", ShopIndex.Honer, Honer_red)

			//设置钻石商城的红点
			let Diamond_red = shop_model.diamond_red_status /*&& custom_model.GetDayFirstLoginStatus()*/
			local_GlobalEventSystem.Fire(UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "ShopView", ShopIndex.Diamond, Diamond_red)


			//结社商店红点
			let huild_red = RedDotController.ins.get(RedKey.GUILD_SHOP1) || RedDotController.ins.get(RedKey.GUILD_SHOP2)
			local_GlobalEventSystem.Fire(UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "ShopView", ShopIndex.Guild, huild_red)
		}



		this.IconFly = (type_id?, pos?) => {
			if (type_id && pos) {
				let list = [{ "0": 0, "1": type_id, "2": 1 }]
				local_GlobalEventSystem.Fire(EventName.REWARD_FLY, list, pos, null, null, -40, 300, 700)
			}
		}

		this.CheckVieOpen = () => {
			let vinfo = shop_model.GetVieInfo()
			return vinfo && vinfo.id_list.length > 0
		}

		this._Open = (...parms) => {
			if (parms) {
				this.SetIndexParameter(...parms)
			}
		}
	}

	public Open(...parms) {
		this._Open(...parms)
		super.Open()
	}

	public BaseWindowCloseFunc() {
		ShopModel.GetInstance().show_type_id = null
		super.BaseWindowCloseFunc()
	}

	public Close() {
		Laya.timer.clear(this, this.CheckRedDot)
		super.Close()
	}

}

window["ShopView"] = ShopView
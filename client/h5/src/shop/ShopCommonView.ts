import { BaseItem1 } from "../common/BaseItem1"
import { Config } from "../common/Config"
import { EventName } from "../common/EventName"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { MaterialsTool } from "../common/MaterialsTool"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { GhostWalkModel } from "../commonModel/GhostWalkModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { MainUIModel } from "../commonModel/MainUIModel"
import { ShopModel, ShopEvent, ShopType, ShopMoneyType, ShopIndex } from "../commonModel/ShopModel"
import { TaskModel } from "../commonModel/TaskModel"
import { MainUIChatView } from "../mainUI/MainUIChatView"
import { PlatformManager } from "../PlatformManager"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { Mathf } from "../util/Mathf"
import { SYTweenLite } from "../util/SYTweenLite"
import { SetAnchoredPositionY, GetSizeDeltaY, SetAnchoredPositionX, SetSizeDeltaY, AddUnderLineAndClick, SetAnchoredPosition, Util, SetHtmlStyle } from "../util/Util"
import { ShopItem } from "./ShopItem"
import { ShopLimitItem } from "./ShopLimitItem"
import { ShopSeriesTab } from "./ShopSeriesTab"

export class ShopCommonView extends BaseItem1 {
	CustomMehod
	InitEvents
	InitRealSeriesTabList
	InitShopContent
	LoadSuccess
	Local_DeleteMe
	Scrscroll
	Scrseries_scroll
	SelectFisrt
	SetData
	SetFirstTabIndex
	SetNormalStyle
	SetSeriesStyle
	SetSeriesTab
	SetTabIndex
	ShowAnim
	TabClick
	cansGroup
	preload_client_config
	preload_server_config
	tween_id
	viewport
	// ClickFun
	open_callback
	cur_money_type
	select_index

	public constructor(parent?) {
		super(parent)


		this.base_file = "shop"
		this.layout_file = "ShopCommonView"

		let model = ShopModel.GetInstance()
		let local_ShopEvent = ShopEvent
		let local_ShopType = ShopType
		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName
		let goods_model = GoodsModel.GetInstance()

		let shop_data_ = null
		let array_collection_ = null
		let shop_type_ = null
		let tong_event_id_ = null
		let jin_event_id_ = null
		let jinLock_event_id_ = null
		let needRefresh_ = false
		let ClientShopConfig = null
		let cur_tab_index = 0
		let scroll_height = null
		let attr_tab:LoopScrowViewMgr = null
		let series_tab_data = null
		let type_name = null
		this.cur_money_type=[]
		this.select_index=0

		this.preload_client_config = { "ClientShopConfig": false }
		this.preload_server_config = {"config_guild_prestige":false}

		this.open_callback = () => {
			console.log("打开了")
	
		}

		this.load_callback = () => {
			this.scroll_group.vScrollBarSkin=""
			this.LoadSuccess()
			this.InitEvents()
			this.ShowAnim()
			this.display_obj.height=1000;
		}

		//this.preload_client_config = [ClientStarEquip=false]
		//this.preload_server_config = [config_god_house_reward=false]
		this.Local_DeleteMe = () => {
			cur_tab_index = 0
			//商品销毁
			if (array_collection_) {
				array_collection_.DeleteMe()
				array_collection_ = null
			}
			//子页签销毁
			if (attr_tab) {
				attr_tab.DeleteMe()
				attr_tab = null
			}

			SYTweenLite.Stop(this.tween_id)
			super.DeleteMe()
		}

		this.LoadSuccess = () => {
			ResManager.GetInstance().SetOutsideImageSprite(this, this.bottom_line, GameResPath.GetIcon("shop", "uiscv2_006"))
			ResManager.GetInstance().SetOutsideImageSprite(this, this.scroll_bg, GameResPath.GetIcon("shop", "ui_Shop_04"))

			ClientShopConfig = ResManager.GetInstance().GetGameConfigFromCache(this, "ClientShopConfig")
			scroll_height = GetSizeDeltaY(this.scroll)
			shop_data_ = []
			// this._lb_medal_tips.lineSpacing = 1
			// if (PlatformManager.IsEyouEnPlatform() ) {
			// 	SetAnchoredPositionX(this._gp_tips, 236)
			// 	this._lb_medal_tips.lineSpacing = 0.8
			// }
			// if (PlatformMgr.GetInstance().IsEyouThPlatform() ) {
			// 	SetSizeDeltaY(this.num, 28)
			// 	SetSizeDeltaY(this.num2, 28)
			// }
		}
		this.InitEvents = () => {
			let update_shop_data = () => {
				if (shop_type_ && this.display_obj.visible) {
					this.SetData()
				}
			}
			this.BindEvent(model, local_ShopEvent.UPDATE_SHOP_DATA, update_shop_data)

			if (needRefresh_) {
				this.SetData()
				needRefresh_ = false
			}

			if (type_name) {
				model.Fire(local_ShopEvent.SHOP_REQUEST_PROTO, 15301, "c", local_ShopType[type_name])
			}

			let update_special_score = true
			let day_change = true
			this.cur_money_type=[]
			if (shop_type_ == local_ShopType.Limit) {
				model.limit_red_status = false
				local_GlobalEventSystem.Fire(local_EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "ShopView", ShopIndex.Limit, false)
				local_GlobalEventSystem.Fire(local_EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 153)
				//MainUIModel.GetInstance().Fire(MainUIModel.REFRESH_FRIEND_AND_MAIL_RED, MainUIChatView.red_index.shop)
			} else if (shop_type_ == local_ShopType.Lucky) {
				this.cur_money_type.push(ShopMoneyType.Lucky)
				day_change = false
			} else if (shop_type_ == local_ShopType.SingleRank) {
				this.cur_money_type.push(ShopMoneyType.KfSingleRank)
			} else if (shop_type_ == local_ShopType.MedalShop) {
				this.cur_money_type.push(ShopMoneyType.KfHolyArea)
				this._lb_medal_tips.text = "商店每日0点刷新重置\n参与击杀异域首领可获得结印"
			} else if (shop_type_ == local_ShopType.GhostWalk) {
				this.cur_money_type.push(ShopMoneyType.Ghost_Walk)
				this._lb_medal_tips.text = "商城每日4点刷新重置\n参与百鬼夜行活动可获得百鬼秘文"
				if(GhostWalkModel.ins.GetDayFirstLoginStatus()){
					GhostWalkModel.ins.login_red=false
					GhostWalkModel.ins.SaveEduDayFristLogin()
					GhostWalkModel.ins.setRed()
				}
			}  else if (shop_type_ == local_ShopType.ExploitShop) {
				this.cur_money_type.push(ShopMoneyType.CSPVP)
			} else if (shop_type_ == local_ShopType.Honer) {
				this.cur_money_type.push(41)
				model.Honer_red_status = false
				local_GlobalEventSystem.Fire(local_EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "ShopView", ShopIndex.Honer, false)
				local_GlobalEventSystem.Fire(local_EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 153)
				//MainUIModel.GetInstance().Fire(MainUIModel.REFRESH_FRIEND_AND_MAIL_RED, MainUIChatView.red_index.shop)
			} else if (shop_type_ == local_ShopType.GodCourt) {
				this.cur_money_type.push(ShopMoneyType.God_Clip)
			} else if (shop_type_ == local_ShopType.Guild) {
				this.cur_money_type.push(ShopMoneyType.Guild)
				this.cur_money_type.push(ShopMoneyType.Guild2)
				//1个商店需要2种货币
				this.BindEvent(goods_model, GoodsModel.UPDATE_SPECIAL_SCORE, () => {
					this.num2.text = goods_model.GetTypeGoodsNum(ShopMoneyType.Guild2)
				}
				)
			}

			if (this.cur_money_type&&this.cur_money_type.length>0) {
				Util.AddClickEvent(this.gloryLabel,()=>{
					let cfg = Config.PRELOAD_CLIENT_CONFIG.ConfigNotNormalGoods[this.cur_money_type[0]]
					if (cfg) {
						MaterialsTool.GetInstance().materialsTips(cfg.goods_id)
					}
				},this)
				if (update_special_score) {
					this.BindEvent(goods_model, GoodsModel.UPDATE_SPECIAL_SCORE, () => {
						this.num.text = goods_model.GetSpecialScore(this.cur_money_type[0])
					}
					)
				}
				if (day_change) {
					this.BindEvent(local_GlobalEventSystem, ServerTimeModel.DAY_CHANGE, () => {
						model.Fire(local_ShopEvent.SHOP_REQUEST_PROTO, 15301, "c", shop_type_)
					}
					)
				}
			}

			//Util.AddClickEvent(this._list_tab_con, this.TabClick, this);

			if (shop_type_ == local_ShopType.Guild) {
				this.BindEvent(goods_model, GoodsModel.UPDATE_GOODS_NUM, (list?) => {
					if (this.use_delete_method) {
						return
					}
					for (let _tmpi in list) {
						var vo = list[_tmpi]
						if (vo.type_id == ShopMoneyType.Guild2) {
							this.num2.text = goods_model.GetTypeGoodsNum(ShopMoneyType.Guild2)
							this.SetData()
							break
						}
					}
				}
				)
			}


			Util.AddClickEvent(this.money_conta, ()=>{
				if(this.cur_money_type&&this.cur_money_type.length>0){
					let arr=ShopModel.GetInstance().MoneyIsEnough(this.cur_money_type[0])
					UIToolTipMgr.GetInstance().DefaultAppendTips(this.cur_money_type[0],arr[2]);
				}
				
			}, this,false);
			Util.AddClickEvent(this.money_conta2, ()=>{
				if(this.cur_money_type&&this.cur_money_type.length>1){
					let arr=ShopModel.GetInstance().MoneyIsEnough(this.cur_money_type[1])
					UIToolTipMgr.GetInstance().DefaultAppendTips(this.cur_money_type[1],arr[2]);
				}
			}, this,false);


		}

		this.CustomMehod = (real_index?) => {
			for (let key in ShopIndex) {
				var v = ShopIndex[key]
				if (v == real_index) {
					type_name = key
				}
			}

			shop_type_ = local_ShopType[type_name]
			this.SetData()
			return true
		}

		this.SetData = () => {
			if (this.is_loaded) {
				if (!shop_type_ || !ClientShopConfig) {
					return
				}

				let series_cfg = ClientShopConfig.ShopSeries[shop_type_]
				this._list_tab_con.visible = series_cfg != null
				// this.bottom_line.visible = series_cfg == null
				if (series_cfg) {
					this.InitRealSeriesTabList(series_cfg)
					this.SetFirstTabIndex()
					this.SetSeriesTab()
					this.SetSeriesStyle()
					// SetSizeDeltaY(this.scroll, scroll_height - 70)
					//SetAnchoredPosition(this.scroll, this.scroll.anchoredPosition.x,-86)
					// SetAnchoredPosition(this.scroll, this.scroll.anchorOffsetX, -86)
					SetSizeDeltaY(this.scroll, 643)
					SetSizeDeltaY(this.scroll_group, 643)
					SetSizeDeltaY(this.scroll_bg, 661)
				} else {
					this.SetNormalStyle()
					SetSizeDeltaY(this.scroll, 706)
					SetSizeDeltaY(this.scroll, 706)
					SetSizeDeltaY(this.scroll_bg, 724)
				}

				this._gp_tips.visible = shop_type_ == local_ShopType.Limit

				let label_bool = shop_type_ == local_ShopType.Honer
					|| shop_type_ == local_ShopType.ExploitShop
					|| shop_type_ == local_ShopType.SingleRank
					|| shop_type_ == local_ShopType.Lucky
					|| shop_type_ == local_ShopType.GodCourt
				this.gloryLabel.visible = label_bool
			} else {
				needRefresh_ = true
			}
		}

		this.SetNormalStyle = () => {
			let shopData = model.GetShopDataByType(shop_type_)
			this.InitShopContent(shopData)
		}

		this.InitRealSeriesTabList = (cfg?) => {
			let list = []
			if (cfg) {
				for (let _tmpi = 0; _tmpi < cfg.length; _tmpi++) {
					var vo = cfg[_tmpi]
					if (model.HaveThisSeriesIdGoods(shop_type_, vo.id)) {
						vo["shop_type"] =shop_type_
						table.insert(list, vo)
					}
				}
				series_tab_data = list
			}
		}

		//设置初始化选中的选项卡
		this.SetFirstTabIndex = () => {
			if (model.show_type_id) {
				cur_tab_index = 0
				let shopData = model.GetShopDataByType(shop_type_)
				if (shopData) {
					let sub_id_list = null
					for (let _tmpi in shopData) {
						var vo = shopData[_tmpi]
						if (vo.goods_id == Number(model.show_type_id)) {
							sub_id_list = vo.series_list
							break
						}
					}
					if (sub_id_list) {
						sub_id_list = ErlangParser.GetInstance().parse(sub_id_list[0])
						let sub = null
						let find = false
						for (let _tmpi in sub_id_list) {
							let vo = sub_id_list[_tmpi]
							for (let i = 0; i <= series_tab_data.length; i++) {
								sub = series_tab_data[i]
								if (Number(vo) == sub.id) {
									cur_tab_index = i
									find = true
									break
								}
							}
							if (find) {
								break
							}
						}
					}
				}
			}
		}

		this.SetSeriesTab = () => {
			if (!attr_tab) {
				attr_tab = new LoopScrowViewMgr()
				attr_tab.SetData(this._list_tab_con, ShopSeriesTab, series_tab_data, LoopScrCon.Horizontal, 1,(index)=>{
					this.TabClick(index)
				},cur_tab_index)	
			} else {
				attr_tab.replaceAll(series_tab_data)
				attr_tab.SetSelectIndex(cur_tab_index)
			}
			
		}


		this.TabClick = (index?) => {
			this.scroll_group.scrollBar.value=0
			cur_tab_index =index
			this.SetSeriesStyle()
			if(shop_type_==ShopType.Guild){
				ShopModel.GetInstance().SaveRedToCookie(cur_tab_index+1)
			}
		}

		this.SetSeriesStyle = () => {
			let series_id = (series_tab_data && series_tab_data[cur_tab_index]) && series_tab_data[cur_tab_index].id || 1
			let shopData = model.GetShopDataByTypeAndSeriesId(shop_type_, series_id)
			this.InitShopContent(shopData)
		}

		this.InitShopContent = (shopData?) => {
			let taskList = TaskModel.GetInstance().GetHasReceiveTaskList()
			shop_data_ = []
			let lifelongList = []
			if (shopData && shopData.length > 0) {
				for (let i = 0; i < shopData.length; i++) {
					let shopVo = shopData[i]
					let continuebool = true
					if (taskList && shopVo.trigger_task_id != 0 && !taskList[shopVo.trigger_task_id]) {
						continuebool = false
					}
					if (continuebool) {
						if (shopVo.quota_type == 3 && shopVo.quota_num <= shopVo.sold_out) {
							table.insert(lifelongList, shopData[i])
						} else {
							table.insert(shop_data_, shopData[i])
						}
						//zcs
						//model.show_type_id=shopVo.goods_id
						//zcs
					}
				}
			}
			//合并
			for (let _tmpl = 0; _tmpl < lifelongList.length; _tmpl++) {
				var shop_vo = lifelongList[_tmpl]
				table.insert(shop_data_, shop_vo)
			}

			let show_none = !(shop_data_ && shop_data_.length > 0)
			this.none_conta.visible = show_none
			this.scroll.visible = !show_none

			if (!array_collection_) {
				if (!array_collection_) {
					array_collection_ = new LoopScrowViewMgr()
				}
				let itemRenderer = null
				if (shop_type_ == local_ShopType.Limit
					|| shop_type_ == local_ShopType.Honer
					|| shop_type_ == local_ShopType.MedalShop
					|| shop_type_ == local_ShopType.GhostWalk
					|| shop_type_ == local_ShopType.ExploitShop
					|| shop_type_ == local_ShopType.SingleRank
					|| shop_type_ == local_ShopType.Lucky
					|| shop_type_ == local_ShopType.GodCourt
					|| shop_type_ == local_ShopType.Guild) {
					itemRenderer = ShopLimitItem
				} else {
					itemRenderer = ShopItem
				}
				array_collection_.SetData(this.scroll_group, itemRenderer, shop_data_, LoopScrCon.Vertical, 3)
				if (shop_type_ == local_ShopType.Honer) {
					this.gloryLabel.text = "获取荣耀"
					this.money_conta.visible = true
					ResManager.GetInstance().SetOutsideImageSprite(this, this.money_icon, "resource/game/goodsIcon/36255010.png")
					this.num.text = goods_model.GetSpecialScore(41)
				} else if (shop_type_ == local_ShopType.MedalShop) {
					this._lb_medal_tips.visible = true
					this._img_tips.visible = true
					let money_data = Config.PRELOAD_CLIENT_CONFIG.ConfigNotNormalGoods[ShopMoneyType.KfHolyArea]
					this.money_conta.visible = true
					ResManager.GetInstance().SetOutsideImageSprite(this, this.money_icon, GameResPath.GetGoodsIconPath(money_data.goods_id))
					this.num.text = goods_model.GetSpecialScore(ShopMoneyType.KfHolyArea)
				} else if (shop_type_ == local_ShopType.GhostWalk) {
					this._lb_medal_tips.visible = true
					this._img_tips.visible = true
					let money_data = Config.PRELOAD_CLIENT_CONFIG.ConfigNotNormalGoods[ShopMoneyType.Ghost_Walk]
					this.money_conta.visible = true
					ResManager.GetInstance().SetOutsideImageSprite(this, this.money_icon, GameResPath.GetGoodsIconPath(money_data.goods_id))
					this.num.text = goods_model.GetSpecialScore(ShopMoneyType.Ghost_Walk)
				}else if (shop_type_ == local_ShopType.ExploitShop) {
					//this.gloryLabel.text = "<u>获取功勋</u>"
					this.gloryLabel.text = "获取功勋"
					//this.gloryLabel.innerHTML = Util.StrToHTML("<a href='event:142@1'><font>获取功勋</font></a>")
					this.money_conta.visible = true
					ResManager.GetInstance().SetOutsideImageSprite(this, this.money_icon, GameResPath.GetIcon("goodsIcon", "36255024"))
					this.num.text = goods_model.GetSpecialScore(36255024)
				} else if (shop_type_ == local_ShopType.SingleRank) {
					// this.gloryLabel.text = "<u>获取试炼币</u>"
					this.gloryLabel.text = "获取试炼币"
					//this.gloryLabel.innerHTML = Util.StrToHTML("<a href='event:142@1'><font>获取试炼币</font></a>")
					this.money_conta.visible = true
					let id = ShopMoneyType.KfSingleRank
					ResManager.GetInstance().SetOutsideImageSprite(this, this.money_icon, "resource/game/goodsIcon/36255094.png")
					this.num.text = goods_model.GetSpecialScore(id)
				} else if (shop_type_ == local_ShopType.Lucky) {
					// this.gloryLabel.text = "<u>获取Boss幸运值</u>"
					this.gloryLabel.text = "获取Boss幸运值"
					//this.gloryLabel.innerHTML = Util.StrToHTML("<a href='event:142@1'><font>获取Boss幸运值</font></a>")
					this.money_conta.visible = true
					let id = ShopMoneyType.Lucky
					ResManager.GetInstance().SetOutsideImageSprite(this, this.money_icon, "resource/game/goodsIcon/" + id + ".png")
					this.num.text = goods_model.GetSpecialScore(id)
				} else if (shop_type_ == local_ShopType.GodCourt) {
					// this.gloryLabel.text = "<u>获取神所碎片</u>"
					this.gloryLabel.text = "获取神祈碎片"
					//this.gloryLabel.innerHTML = Util.StrToHTML("<a href='event:142@1'><font>获取神祈碎片</font></a>")
					this.money_conta.visible = true
					let id = ShopMoneyType.God_Clip
					ResManager.GetInstance().SetOutsideImageSprite(this, this.money_icon, "resource/game/goodsIcon/" + id + ".png")
					this.num.text = goods_model.GetSpecialScore(id)
				} else if (shop_type_ == local_ShopType.Guild) {
					this.money_conta.visible = true
					let id = ShopMoneyType.Guild
					ResManager.GetInstance().SetOutsideImageSprite(this, this.money_icon, "resource/game/goodsIcon/" + id + ".png")
					this.num.text = goods_model.GetSpecialScore(id)

					this.money_conta2.visible = true
					id = ShopMoneyType.Guild2
					ResManager.GetInstance().SetOutsideImageSprite(this, this.money_icon2, "resource/game/goodsIcon/" + id + ".png")
					this.num2.text = goods_model.GetTypeGoodsNum(id)
				} else {
					this.money_conta.visible = false
					this.money_conta2.visible = false
				}
			} else {
				array_collection_.replaceAll(shop_data_)
				//array_collection_.RestToBeginning()
				this.SelectFisrt()
			}
		}

		this.SelectFisrt = () => {
			if (model.show_type_id) {
				//圣衣特殊处理
				if (model.show_type_id == 79070501) {
					model.show_type_id = null
					return
				}
				let count = null
				let vo = null
				for (let i = 0; i < shop_data_.length; i++) {
					vo = shop_data_[i]
					if (vo.goods_id == model.show_type_id) {
						count = i
						break
					}
				}

				if (count) {
					let height = 300
					if (shop_type_ == local_ShopType.Limit) {
						height = 332
					}
				}
				model.show_type_id = null
			}
		}

		this.ShowAnim = (reopen?) => {
			if (array_collection_) {
				if (reopen) {
					//array_collection_.RestToBeginning()
				}
				// this.cansGroup.alpha = 0
				this.tween_id = SYTweenLite.to(this, this.cansGroup, SYTweenLite.UiAnimationType.ALPHA, 1, 0.5, () => {
					SYTweenLite.Stop(this.tween_id)
				})
			}
		}

		this.SetTabIndex = (tabIndex?) => {
			cur_tab_index = tabIndex
		}

	}


	public ReOpen_callback() {

		this.ShowAnim(true)
	}

	public DeleteMe() {

		this.Local_DeleteMe()
	}



scroll_bg:Laya.Image
scroll:Laya.Panel
scroll_group:Laya.List
bottom_line:Laya.Image
money_conta:Laya.Box
_Image1:Laya.Image
money_icon:Laya.Image
num:Laya.Label
money_conta2:Laya.Box
_Image2:Laya.Image
money_icon2:Laya.Image
num2:Laya.Label
none_conta:Laya.Box
tips0:Laya.Label
tips_icon0:Laya.Image
_gp_tips:Laya.Box
_Image3:Laya.Image
_Label1:Laya.Label
gloryLabel:Laya.Label
_lb_medal_tips:Laya.Label
_img_tips:Laya.Image
_list_tab_con:Laya.List
public GetComponents() {
[
this.scroll_bg,
this.scroll,
this.scroll_group,
this.bottom_line,
this.money_conta,
this._Image1,
this.money_icon,
this.num,
this.money_conta2,
this._Image2,
this.money_icon2,
this.num2,
this.none_conta,
this.tips0,
this.tips_icon0,
this._gp_tips,
this._Image3,
this._Label1,
this.gloryLabel,
this._lb_medal_tips,
this._img_tips,
this._list_tab_con,
]
 = this.GetChildrenByNames([

"scroll_bg",
"scroll",
"scroll_group",
"bottom_line",
"money_conta",
"_Image1",
"money_icon",
"num",
"money_conta2",
"_Image2",
"money_icon2",
"num2",
"none_conta",
"tips0",
"tips_icon0",
"_gp_tips",
"_Image3",
"_Label1",
"gloryLabel",
"_lb_medal_tips",
"_img_tips",
"_list_tab_con",
])
}
}
 window["ShopCommonView"]= ShopCommonView
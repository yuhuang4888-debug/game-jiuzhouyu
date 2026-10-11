import { Config } from "../common/Config"
import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { RoleManager } from "./RoleManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventDispatcher } from "../util/EventDispatcher"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest, Util } from "../util/Util"
import { GoodsModel } from "./GoodsModel"
import { LungModel } from "./LungModel"
import { MainFunc, MainUIModel } from "./MainUIModel"
import { MainUIChatView } from "../mainUI/MainUIChatView"
import { GuildModel } from "./GuildModel"
import { CookieWrapper } from "../common/CookieWrapper"
import { RedDotController } from "../common/RedDotController"
import { RedKey } from "../common/RedDotDefine"

export enum MysteryShopType {
	MysteryShop = 1,  		//神秘商店类型
	LungShopType = 2		//神纹神秘商店
}
//商店类型
export enum ShopType {
	Limit = 1,				//1：限购
	Diamond = 2,			//2：钻石
	Bind_Diamond = 3,		//3：绑钻
	Outward = 4,			//4：外观
	NormalShop = 5,			//5：常用道具
	Honer = 6,				//荣耀商城
	SacredShop = 7,			//领地商城
	MedalShop = 8,			//勋章商城		
	ExploitShop = 9,		//功勋商城
	TopVipShop = 10,		//至尊VIP商城
	EudaemonShop = 11,		//圣兽领悬赏商城
	SingleRank = 12,		//跨服单人排位
	Lucky = 13,				//幸运商城
	LonglangEx = 14,		//龙语
	GodCourt = 15,			//神庭
	Guild = 16,				//结社
	Vie = 99,				//抢购， 因没定义抢购的类型，所以这里暂用99
	SoulOfWar = 17,				//战魂
	GhostWalk = 18,			//百鬼夜行
}

//商城的选项卡
export enum ShopIndex {
	Limit = 0,
	Diamond = 1,
	Bind_Diamond = 2,
	Vie = 3,
	Guild = 4,
	Honer = 5,
	GhostWalk = 6,
	MedalShop = 7,
	SingleRank = 8,
	LonglangEx = 9,
	GodCourt = 10
}

//商城的货币类型
export enum ShopMoneyType {
	Lucky = 36255096,			//幸运值
	Guild = 36255100,			//善魂
	Guild2 = 38040091,			//团结之证
	TopVip = 36255042,       	//至尊币
	KfHolyArea = 36255012,		//开服圣域商店
	CSPVP = 36255024,			//pvp
	KfSingleRank = 36255094,	//神王试炼币
	Honer = 41,                //荣耀币
	Honer2 = 42,                //功勋
	Honer3 = 43,                //功勋
	Diamond = 1,                    //钻石
	Bind_Diamond = 2,//绑钻
	Gold = 3,//金币
	God_Clip = 36255099,     //神所碎片
	Ghost_Walk = 36255115, //百鬼秘文
	Edu_Coin = 36255041   //蜃气楼 悬赏积分
}


window["MysteryShopType"] = MysteryShopType
window["ShopType"] = ShopType
window["ShopIndex"] = ShopIndex
window["ShopMoneyType"] = ShopMoneyType

export const ShopEvent = {
	SHOP_REQUEST_PROTO: "SHOP_REQUEST_PROTO",
	SHOP_OPEN_VIEW: "SHOP_OPEN_VIEW",
	UPDATE_SHOP_DATA: "UPDATE_SHOP_DATA",
	UPDATE_SHOP_ONE_DATA: "UPDATE_SHOP_ONE_DATA",
	UPDATE_MYSTERY_SHOP_DATA: "UPDATE_MYSTERY_SHOP_DATA", 				//更新神秘商店数据
	UPDATE_MYSTERY_SHOP_ONE_DATA: "UPDATE_MYSTERY_SHOP_ONE_DATA", 		//更新神秘商店数据
	BUY_GOODS_SUCCESS: "BUY_GOODS_SUCCESS", 							//购买商品成功
	BUY_GOODS_FAILURE: "BUY_GOODS_FAILURE", 							//购买商品失败
	SHOW_MYSTERY_RED_DOT: "SHOW_MYSTERY_RED_DOT", 						//神秘商城红点
	SHOP_MYSTERY_BUY_SUCCESS: "SHOP_MYSTERY_BUY_SUCCESS", 				//神秘商店购买成功
	SHOP_ICON_FLY: "SHOP_ICON_FLY", 									//图标飞
	SHOW_REFRESH_EFFECT: "SHOW_REFRESH_EFFECT", 						//刷新特效
	UPDATE_VIE_SHOP_DATA: "UPDATE_VIE_SHOP_DATA", 						//刷新抢购商店数据
	BUY_VIE_GOODS_SUCCESS: "BUY_VIE_GOODS_SUCCESS", 					//购买抢购商品成功
	OUT_VIE_SHOP_DATA: "OUT_VIE_SHOP_DATA",								//抢购商店数据事件
	MONEY_CHANGE: "MONEY_CHANGE"
}
window["ShopEvent"] = ShopEvent

export class ShopModel extends EventDispatcher {
	CancelTimer
	CheckSoulOfWarRed
	CheckVieView
	FormatMysteriousData
	GetMysteryDataById
	GetMysteryDataByType
	GetMysteryShopCfg
	GetRefreshCfg
	GetShopDataByKeyId
	GetShopDataByType: (_type?: number) => IShopGoodsInfo[]
	GetShopDataByTypeAndSeriesId
	GetVieData
	GetVieInfo
	HaveThisSeriesIdGoods
	Honer_red_status
	InitConfig
	MoneyIsEnough
	SetMysteryShop
	SetShopData
	SetVieInfo
	StartTimer
	UpdateMysteryShop
	UpdateShopData
	jinLock_not_enough_not_alert
	limit_red_status
	mystery_data
	mystery_jinLock_not_alert
	mystery_lung_jinLock_not_alert
	on_time
	show_type_id
	vie_red_stutus
	SetRedofGuild
	UpdateRedofGuild

	diamond_red_status
	have_enter_special_tab


	static Instance: ShopModel
	public static SELECTITEM = "SELECTITEM";

	public constructor() {
		super()

		if (ShopModel.Instance) {
			return
		}
		ShopModel.Instance = this

		this.jinLock_not_enough_not_alert = false		//是否弹出提示////->绑钻不足，可用钻石代替
		this.mystery_jinLock_not_alert = false			//神秘商店是否弹出提示////->绑钻不足，可用钻石代替
		this.mystery_lung_jinLock_not_alert = null		//神纹商店是否弹出提示////->绑钻不足，可用钻石代替
		this.mystery_data = []							//神秘商店数据
		this.show_type_id = null
		this.limit_red_status = true
		this.vie_red_stutus = null						//抢购商店红点
		this.Honer_red_status = true

		this.diamond_red_status = false      //钻石商城红点
		this.have_enter_special_tab = false

		let all_goods_list_: {[type: number]: IShopGoodsInfo[]} = {}
		let mystery_shop_good_ = null
		let count_time_id_ = null
		let need_show_refresh_effect_ = []
		let vie_info_ = null					//抢购商店数据
		let vie_cfg_ = null					//抢购商店配置
		let config_mystery_shop_hit_ = null
		let local_ShopEvent = ShopEvent
		let role_mgr = RoleManager.GetInstance()
		let res_mgr = ResManager.GetInstance()
		let goods_model = GoodsModel.GetInstance()
		let Special_Score_Type = ShopMoneyType.KfHolyArea  //KfHolyAreaDefine.Special_Score_Type
		let pvp_money_type = ShopMoneyType.CSPVP 	 		 //CSPVPDefine.MONEY_TYPE
		let topvip_money_type = ShopMoneyType.TopVip

		this.InitConfig = () => {
			config_mystery_shop_hit_ = Config.PRELOAD_SERVER_CONFIG.config_mystery_shop_hit
			vie_cfg_ = Config.PRELOAD_SERVER_CONFIG.config_limit_shop_config
		}

		//设置商店数据
		this.SetShopData = (data?) => {
			if (data) {

				for (let i = data.goods_list.length - 1; i >= 0; i--) {
					data.goods_list[i].type = data.type
				}

				all_goods_list_[data.type] = data.goods_list
				all_goods_list_[data.type].sort((a?, b?) => {
					return a.rank - b.rank
				})

				this.Fire(local_ShopEvent.UPDATE_SHOP_DATA, data.type)
				if (data.type == ShopType.Guild) {
					this.SetRedofGuild(1);
					this.SetRedofGuild(2);
				}
			}
		}

		//更新商店数据
		this.UpdateShopData = (data?) => {
			if (data && all_goods_list_) {
				let have_find = false
				let is_lifelong = false
				for (let tmp in all_goods_list_) {

					for (let _tmpi in all_goods_list_[tmp]) {
						var vo = all_goods_list_[tmp][_tmpi]
						if (vo.key_id == data.key_id) {
							vo.sold_out = vo.sold_out + data.num
							is_lifelong = vo.quota_type == 3
							have_find = true
							break
						}
					}
					if (have_find) {
						break
					}
				}
				this.Fire(local_ShopEvent.UPDATE_SHOP_ONE_DATA, data.key_id)
				if (is_lifelong) {
					this.Fire(local_ShopEvent.UPDATE_SHOP_DATA)
				}
			}
		}

		this.GetShopDataByKeyId = (key_id?) => {
			let data = null
			if (all_goods_list_) {
				for (let tmp in all_goods_list_) {

					for (let _tmpi in all_goods_list_[tmp]) {
						var vo = all_goods_list_[tmp][_tmpi]
						if (vo.key_id == key_id) {
							data = vo
							break
						}
					}
					if (data) {
						break
					}
				}
			}
			return data
		}

		//神秘商店数据(神纹商店)
		this.SetMysteryShop = (data?, config_mystery_shop_good?) => {
			mystery_shop_good_ = config_mystery_shop_good
			if (!data) {
				return
			}

			if (this.mystery_data == null || !this.mystery_data[data.type]) {	//初次登录，或是自动刷新倒计时到点了，判断是否显示红点
				let all_new = true
				for (let _tmpi in data.good_list) {
					var obj = data.good_list[_tmpi]
					if (obj.buy_type == 2) {
						all_new = false
						break
					}
				}
				if (all_new && data.type == MysteryShopType.MysteryShop) {
					GlobalEventSystem.Fire(EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 153, true)
					//MainUIModel.GetInstance().Fire(MainUIModel.REFRESH_FRIEND_AND_MAIL_RED, MainUIChatView.red_index.shop)
				}
			}

			if (this.mystery_data[data.type]) {
				if (data.hit_num != this.mystery_data[data.type].hit_num) {
					this.Fire(local_ShopEvent.SHOW_REFRESH_EFFECT, data.type)
				}
			}

			if (need_show_refresh_effect_[data.type] == true) {
				this.Fire(local_ShopEvent.SHOW_REFRESH_EFFECT, data.type)
				need_show_refresh_effect_[data.type] = false
			}

			this.mystery_data[data.type] = data
			if (this.mystery_data[data.type] && this.mystery_data[data.type].good_list) {
				this.mystery_data[data.type].good_list.sort((a?, b?) => {
					return a.cfg_id - b.cfg_id
				})
				for (let _tmpi in this.mystery_data[data.type].good_list) {
					var obj = this.mystery_data[data.type].good_list[_tmpi]
					obj.type = data.type
					obj.mystery_shop_good = this.GetMysteryShopCfg(obj.cfg_id)
				}
			}
			this.Fire(local_ShopEvent.UPDATE_MYSTERY_SHOP_DATA, data.type)
			this.CancelTimer()
			this.StartTimer()
		}

		this.StartTimer = () => {
			count_time_id_ = GlobalTimerQuest.AddPeriodQuest(() => {
				this.on_time()
			}, 1, -1)
			this.on_time()
		}

		this.on_time = () => {
			if (this.mystery_data) {
				let shop_data = null
				let left_time = null
				let count = 0
				let size = Util.TableSize(this.mystery_data)
				for (let _type in this.mystery_data) {

					shop_data = this.mystery_data[_type]
					if (shop_data.refresh_time != null) {
						left_time = shop_data.refresh_time - TimeUtil.getServerTime()
						if (left_time < -2 && left_time > -4) {		//延迟一点点， 3秒  //left_time > -4 容错服务端发过来的时间会小于当前时间
							count = count + 1
							this.CancelTimer()
							this.mystery_data[_type] = null		//这里置空，再去刷新
							need_show_refresh_effect_[_type] = true
							this.Fire(local_ShopEvent.SHOP_REQUEST_PROTO, 15305, "h", _type)
							if (Number(_type) == MysteryShopType.LungShopType) {
								LungModel.GetInstance().RestoreShopTabDot()
							}
						}
						if (left_time < -5) {  //小于当前时间时停止计时器，不刷新
							this.CancelTimer()
						}
					}
				}
				if (count == size) {
					this.CancelTimer()
				}
			}
		}

		this.CancelTimer = () => {
			if (count_time_id_) {
				GlobalTimerQuest.CancelQuest(count_time_id_)
				count_time_id_ = null
			}
		}

		//更新神秘商店数据（神纹
		this.UpdateMysteryShop = (data?) => {
			if (data && this.mystery_data && this.mystery_data[data.type] && this.mystery_data[data.type].good_list) {
				for (let _tmpi in this.mystery_data[data.type].good_list) {
					var obj = this.mystery_data[data.type].good_list[_tmpi]
					if (obj.cfg_id == data.cfg_id) {
						obj.buy_type = 2
						obj.buy_num = obj.buy_num + 1
						break
					}
				}
				this.Fire(local_ShopEvent.UPDATE_MYSTERY_SHOP_ONE_DATA, data.type, data.cfg_id)
			}
		}

		//获取神秘商城数据（神纹
		this.GetMysteryDataByType = (_type?) => {
			return this.mystery_data && this.mystery_data[_type] || {}
		}

		//神秘商店数据（神纹
		this.GetMysteryDataById = (_type?, cfg_id?) => {
			let data = null
			if (this.mystery_data && this.mystery_data[_type] && this.mystery_data[_type].good_list) {
				for (let _tmpi in this.mystery_data[_type].good_list) {
					var obj = this.mystery_data[_type].good_list[_tmpi]
					if (obj.cfg_id == cfg_id) {
						data = obj
						break
					}
				}
			}
			return data
		}

		//神秘商店配置（神纹
		this.GetMysteryShopCfg = (cfg_id?) => {
			// if (!mystery_shop_good_) {
			// 	mystery_shop_good_ = Config.Mysteryshopgood
			// }
			return mystery_shop_good_[cfg_id]
		}

		//获取商城数据
		this.GetShopDataByType = (_type?) => {
			return all_goods_list_ && all_goods_list_[_type] || []
		}

		//获取商城数据
		this.GetShopDataByTypeAndSeriesId = (_type?, series_id?) => {
			let shop_data = []
			if (all_goods_list_ && all_goods_list_[_type]) {
				let data = all_goods_list_[_type]
				for (let _tmpi in data) {
					var vo = data[_tmpi]
					if (vo.series_list) {
						for (let _tmpi in vo.series_list) {
							var series = vo.series_list[_tmpi]
							let seriesArr2 = JSON.parse(series)
							if (Number(seriesArr2[0]) == series_id) {
								shop_data.push(vo)
								break
							}
						}
					}
				}
			}
			return shop_data
		}

		//是否有该分类的商品
		this.HaveThisSeriesIdGoods = (_type?, series_id?) => {
			let have = false
			if (all_goods_list_ && all_goods_list_[_type]) {
				let data = all_goods_list_[_type]
				for (let _tmpi in data) {
					var vo = data[_tmpi]
					if (vo.series_list) {
						for (let _tmpi in vo.series_list) {
							var series = vo.series_list[_tmpi]
							let seriesArr = JSON.parse(series)
							if (Number(seriesArr[0]) == series_id) {
								have = true
								break
							}
						}
					}
					if (have) {
						break
					}
				}
			}
			return have
		}


		//money是否足够
		this.MoneyIsEnough = (money_type?, cost?) => {
			let enough = true
			let gap = 0
			let my_have = 0
			let alert_str = ""
			money_type = Number(money_type)
			cost = Number(cost)
			if (money_type == ShopMoneyType.Diamond) {					//钻石
				if (role_mgr.mainRoleInfo.jin < cost) {
					enough = false
					gap = cost - role_mgr.mainRoleInfo.jin
					alert_str = "勾玉不足"
				}
				my_have = role_mgr.mainRoleInfo.jin
			} else if (money_type == ShopMoneyType.Bind_Diamond) {				//绑钻
				if (role_mgr.mainRoleInfo.jinLock < cost) {
					enough = false
					gap = cost - role_mgr.mainRoleInfo.jinLock
					alert_str = "绑玉不足"
				}
				my_have = role_mgr.mainRoleInfo.jinLock
			} else if (money_type == ShopMoneyType.Gold) {				//金币
				if (role_mgr.mainRoleInfo.tong < cost) {
					enough = false
					gap = cost - role_mgr.mainRoleInfo.tong
					alert_str = "铜币不足"
				}
				my_have = role_mgr.mainRoleInfo.jinLock
			} else if (money_type == ShopMoneyType.Honer) {			//荣耀点
				if (goods_model.GetSpecialScore(41) < cost) {
					enough = false
					gap = cost - goods_model.GetSpecialScore(41)
					alert_str = "荣耀点不足"
				}
				my_have = goods_model.GetSpecialScore(41)
			} else if (money_type == ShopMoneyType.Honer2) {			//勋章
				if (goods_model.GetSpecialScore(42) < cost) {
					enough = false
					gap = cost - goods_model.GetSpecialScore(42)
					alert_str = "勋章不足"
				}
				my_have = goods_model.GetSpecialScore(42)
			} else if (money_type == ShopMoneyType.Honer3) {			//勋章
				if (goods_model.GetSpecialScore(42) < cost) {
					enough = false
					gap = cost - goods_model.GetSpecialScore(42)
					alert_str = "勋章不足"
				}
				my_have = goods_model.GetSpecialScore(42)
			} else if (money_type == Special_Score_Type) {	//勋章
				if (goods_model.GetSpecialScore(Special_Score_Type) < cost) {
					enough = false
					gap = cost - goods_model.GetSpecialScore(Special_Score_Type)
					alert_str = "勋章不足"
				}
				my_have = goods_model.GetSpecialScore(Special_Score_Type)
			} else if (money_type == pvp_money_type) {		//功勋
				if (goods_model.GetSpecialScore(pvp_money_type) < cost) {
					enough = false
					gap = cost - goods_model.GetSpecialScore(pvp_money_type)
					alert_str = "功勋不足"
				}
				my_have = goods_model.GetSpecialScore(pvp_money_type)
			} else if (money_type == topvip_money_type) {			//至尊币
				if (goods_model.GetSpecialScore(topvip_money_type) < cost) {
					enough = false
					gap = cost - goods_model.GetSpecialScore(topvip_money_type)
					alert_str = "至尊币不足"
				}
				my_have = goods_model.GetSpecialScore(topvip_money_type)
			} else if (money_type == ShopMoneyType.KfSingleRank) {		//试炼币
				if (goods_model.GetSpecialScore(money_type) < cost) {
					enough = false
					gap = cost - goods_model.GetSpecialScore(money_type)
					alert_str = "试炼币不足"
				}
				my_have = goods_model.GetSpecialScore(money_type)
			} else if (money_type == ShopMoneyType.Lucky) {				//幸运币
				if (goods_model.GetSpecialScore(money_type) < cost) {
					enough = false
					gap = cost - goods_model.GetSpecialScore(money_type)
					alert_str = "大妖幸运值不足"
				}
				my_have = goods_model.GetSpecialScore(money_type)
			} else if (money_type == ShopMoneyType.Guild) {				//声望
				if (goods_model.GetSpecialScore(money_type) < cost) {
					enough = false
					gap = cost - goods_model.GetSpecialScore(money_type)
					alert_str = "善缘不足"
				}
				my_have = goods_model.GetSpecialScore(money_type)
			} else if (money_type == ShopMoneyType.Guild2) {				//团结之证
				let count = goods_model.GetTypeGoodsNum(money_type)
				if (count < cost) {
					enough = false
					gap = cost - count
					alert_str = "团结之证不足"
				}
				my_have = count
			} else if (money_type == ShopMoneyType.God_Clip) { //神所碎片
				let count = goods_model.GetSpecialScore(money_type)
				if (count < cost) {
					enough = false
					gap = cost - goods_model.GetSpecialScore(money_type)
					alert_str = "神所碎片不足"
				}
				my_have = goods_model.GetSpecialScore(money_type)
			}else if (money_type == ShopMoneyType.Ghost_Walk) { //神所碎片
				let count = goods_model.GetSpecialScore(money_type)
				if (count < cost) {
					enough = false
					gap = cost - goods_model.GetSpecialScore(money_type)
					alert_str = "百鬼秘文不足"
				}
				my_have = goods_model.GetSpecialScore(money_type)
			}else if (money_type == LungModel.LungStone1) { //神所碎片
				let count = goods_model.GetSpecialScore(money_type)
				if (count < cost) {
					enough = false
					gap = cost - goods_model.GetSpecialScore(money_type)
					alert_str = "神石数量不足"
				}
				my_have = goods_model.GetSpecialScore(money_type)
			}else if (money_type == LungModel.LungStone2) { //神所碎片
				let count = goods_model.GetSpecialScore(money_type)
				if (count < cost) {
					enough = false
					gap = cost - goods_model.GetSpecialScore(money_type)
					alert_str = "神石数量不足"
				}
				my_have = goods_model.GetSpecialScore(money_type)
			}else if (money_type == LungModel.LungStone3) { //神所碎片
				let count = goods_model.GetSpecialScore(money_type)
				if (count < cost) {
					enough = false
					gap = cost - goods_model.GetSpecialScore(money_type)
					alert_str = "神石数量不足"
				}
				my_have = goods_model.GetSpecialScore(money_type)
			}
			return [enough, gap, my_have, alert_str]
		}

		this.FormatMysteriousData = (data?) => {
			if (data) {
				let cfg = null
				let reward_data = null
				let goods_id = null
				let lock = null
				for (let _tmpi in data) {
					var obj = data[_tmpi]
					cfg = this.GetMysteryShopCfg(obj.cfg_id)
					if (cfg) {
						reward_data = JSON.parse(cfg.goods)
						obj.type = 0;
						obj.sub_type = 0;
						obj.color = 0;
						if (reward_data && reward_data[0]) {
							[goods_id, lock] = goods_model.GetMappingTypeId(reward_data[0][0], reward_data[0][1]);
							obj.type_id = goods_id;
							let cfg1 = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_goods.name, goods_id, false);
							obj.type = cfg1.type;
							obj.sub_type = cfg1.subtype;
							obj.color = cfg1.color;
						}
						obj.sell_out = (obj.mystery_shop_good.limit - obj.buy_num) <= 0 ? 1 : 0
					}
				}
			}
			return data
		}

		this.SetVieInfo = (info?) => {
			vie_info_ = info
			this.Fire(local_ShopEvent.UPDATE_VIE_SHOP_DATA)
		}

		this.GetVieInfo = () => {
			return vie_info_
		}

		this.GetVieData = (id?) => {
			return vie_cfg_[id]
		}

		this.CheckVieView = () => {
			return vie_info_ && vie_info_.id_list && vie_info_.id_list.length > 0
		}

		//刷新配置
		this.GetRefreshCfg = (times?, _type?) => {
			let cfg = null
			let obj = null
			for (let key in config_mystery_shop_hit_) {
				obj = config_mystery_shop_hit_[key]
				if (obj.type == _type && times + 1 >= obj.min && times + 1 <= obj.max) {
					cfg = obj
					break
				}
			}
			return cfg
		}

		//战魂红点
		this.CheckSoulOfWarRed = () => {
			//let goods_list = all_goods_list_[ShopType.SoulOfWar]
			//if (! goods_list || goods_list.length <= 0 ) { return false }
			//let num = GoodsModel.GetInstance().GetSpecialScore(36240001)
			//let min_price = 0
			//for (let _ in goods_list) {
			// var v = goods_list[_]
			//min_price = (min_price == 0 || v.price < min_price) && v.price || min_price
			//} 
			//return num >= min_price
			return false
		}

		//结社商店红点  //1是善缘 2是武魂
		this.SetRedofGuild = (type) => {
			let boo =false
			if (!GuildModel.GetInstance().GuildIdolIsOpen()||this.CheckRedFormCookie(type)) {
				boo =false
			}else{
				let shopData = this.GetShopDataByTypeAndSeriesId(ShopType.Guild, type)
				if (!shopData || shopData.length <= 0) {
					return false
				}
	
				let good_type = type == 1 ? ShopMoneyType.Guild : ShopMoneyType.Guild2
				let min_price = 0
				for (let _ in shopData) {
					var v = shopData[_]
					min_price = (min_price == 0 || v.price < min_price) && v.price || min_price
				}
				
				let arr = this.MoneyIsEnough(good_type, min_price)
				boo = arr[0]
			}
			
			
			this.UpdateRedofGuild(type,boo)
		}

		//每天登录红点  type 1是善缘 2是武魂
		this.SaveRedToCookie = (type) => {

			//存入缓存
			let now_date = new Date()
			let date = `${now_date.getFullYear()}-${now_date.getMonth() + 1}-${now_date.getDate()}`
			let cookie = type == 1 ? CookieWrapper.COOKIE_GUILD_SHOP_RED_1 : CookieWrapper.COOKIE_GUILD_SHOP_RED_2
			CookieWrapper.GetInstance().SaveCookie(cookie, date,true)

			//更新红点状态
			this.SetRedofGuild(type)
		}


		this.UpdateRedofGuild=(type,boo)=>{
			RedDotController.ins.up(RedKey[`GUILD_SHOP${type}`], boo);
			GlobalEventSystem.Fire(EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Guild)
			GlobalEventSystem.Fire(EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 153)
			let huild_red = RedDotController.ins.get(RedKey.GUILD_SHOP1)||RedDotController.ins.get(RedKey.GUILD_SHOP2)
			GlobalEventSystem.Fire( EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "ShopView", ShopIndex.Guild, huild_red)
		}


		//是否当天点开过页签
		this.CheckRedFormCookie = (type) => {
			let boo = true
			let cookie = type == 1 ? CookieWrapper.COOKIE_GUILD_SHOP_RED_1 : CookieWrapper.COOKIE_GUILD_SHOP_RED_2
			let last_date = CookieWrapper.GetInstance().GetCookie(cookie,true)
			let now_date = new Date()
			let date = `${now_date.getFullYear()}-${now_date.getMonth() + 1}-${now_date.getDate()}`
			if (last_date != date) {
				boo = false
			}
			return boo
		}



	}


	SaveRedToCookie
	CheckRedFormCookie

	public static GetInstance() {
		if (!ShopModel.Instance) {
			ShopModel.Instance = new ShopModel()
		}
		return ShopModel.Instance
	}
}


window["ShopModel"] = ShopModel
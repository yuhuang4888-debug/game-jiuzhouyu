import { Alert, Alert_Type } from "../alert/Alert";
import { BaseItem1 } from "../common/BaseItem1";
import { Config } from "../common/Config";
import { EquipmentItem } from "../common/EquipmentItem";
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr";
import { table } from "../common/table";
import { GoodsModel } from "../commonModel/GoodsModel";
import { LungModel } from "../commonModel/LungModel";
import { MysteryShopType, ShopEvent, ShopModel } from "../commonModel/ShopModel";
import { Message } from "../sysInfo/SysInfoController";
import { TimeUtil } from "../util/TimeUtil";
import { GlobalTimerQuest, Util } from "../util/Util";
import { LungShopItem } from "./LungShopItem";

export class LungShopView extends BaseItem1 {

	needRefresh = false

	LoadSuccess
	InitEvents
	SetData
	InitContent
	SetRefreshAndCost
	SetCost
	StartTimer
	OnTime
	CancelTimer
	SetMyLungStone
	BuyGoodsSuccess
	loop_mgr: LoopScrowViewMgr
	data_list
	UpdataDataList
	public constructor(parent) {
		super(parent)
		this.base_file = "lung"
		this.layout_file = "LungShopView"
		let model = ShopModel.GetInstance(),
			local_ShopEvent = ShopEvent,
			LungShopType = MysteryShopType.LungShopType,
			local_LungModel = LungModel,
			goods_model = GoodsModel.GetInstance(),
			local_GoodsModel = GoodsModel,
			local_TimeUtil = TimeUtil,
			data_,
			// arrayCollection_: eui.ArrayCollection,
			count_time_id_: Laya.Timer,
			cost_item1_: EquipmentItem,
			cost_item2_: EquipmentItem,
			cost_item3_: EquipmentItem,
			ticket_enough_ = false,
			money_cost_cfg_,
			last_show_effect_time_
		this.load_callback = function () {
			this.LoadSuccess()
			this.InitEvents()
		}

		this.DeleteMe = () => {
			this.CancelTimer()
			if (cost_item1_) {
				cost_item1_.DeleteMe()
				cost_item1_ = null
			}
			if (cost_item2_) {
				cost_item2_.DeleteMe()
				cost_item2_ = null
			}
			if (cost_item3_) {
				cost_item3_.DeleteMe()
				cost_item3_ = null
			}
			if (this.loop_mgr) {
				this.loop_mgr.DeleteMe()
				this.loop_mgr = null
			}
			this.data_list = null
			super.DeleteMe()

		}
		this.LoadSuccess = () => {
			this.scroll_group.scrollBar.visible = false
			model.Fire(local_ShopEvent.SHOP_REQUEST_PROTO, 15305, "h", LungShopType)

			cost_item1_ = new EquipmentItem(this.cost_icon1)
			cost_item1_.Load()
			cost_item1_.SetItemSize(43, 43)
			cost_item1_.SetData(local_LungModel.LungStone1)
			cost_item1_.ExcuteCallback(() => {
				cost_item1_.SetItembgVisible(false)
			})

			cost_item2_ = new EquipmentItem(this.cost_icon2)
			cost_item2_.Load()
			cost_item2_.SetItemSize(43, 43)
			cost_item2_.SetData(local_LungModel.LungStone2)
			cost_item2_.ExcuteCallback(() => {
				cost_item2_.SetItembgVisible(false)
			})

			cost_item3_ = new EquipmentItem(this.cost_icon3)
			cost_item3_.Load()
			cost_item3_.SetItemSize(43, 43)
			cost_item3_.SetData(local_LungModel.LungStone3)
			cost_item3_.ExcuteCallback(() => {
				cost_item3_.SetItembgVisible(false)
			})
		}

		this.InitEvents = () => {
			let update_fun = (_type) => {
				if (this.display_obj && this.display_obj.visible) {
					this.SetData(true)
				}
			}
			this.BindEvent(model, local_ShopEvent.UPDATE_MYSTERY_SHOP_DATA, update_fun)
			// this.BindEvent(goods_model, local_GoodsModel.UPDATE_SPECIAL_SCORE, update_fun)

			let update_one = (_type, cfg_id) => {
				this.UpdataDataList(cfg_id)
				this.SetRefreshAndCost()
				this.BuyGoodsSuccess(cfg_id)
			}
			this.BindEvent(model, local_ShopEvent.UPDATE_MYSTERY_SHOP_ONE_DATA, update_one)


			Util.AddClickEvent(this.refreshBtn, () => {
				if (last_show_effect_time_ && local_TimeUtil.getServerTime() - last_show_effect_time_ <= 1) {
					return
				}
				let request_fun = (force?: boolean) => {
					if (!force && money_cost_cfg_) {
						let [enough, gap, my_have, str] = model.MoneyIsEnough(money_cost_cfg_[0], money_cost_cfg_[2])
						if (!enough) {
							Message.show(str)
							return
						}
					}
					// LungModel.GetInstance().RestoreShopTabDot()
					model.Fire(local_ShopEvent.SHOP_REQUEST_PROTO, 15306, "h", LungShopType)
				}
				if (ticket_enough_) {
					request_fun(true)
				} else {
					if (money_cost_cfg_) {
						if (money_cost_cfg_[0] == 2) {	//消耗绑钻
							let [enough, gap] = model.MoneyIsEnough(money_cost_cfg_[0], money_cost_cfg_[2])
							if (enough) {
								request_fun(true)
							} else {
								let check_func = (bool: boolean) => {
									model.mystery_lung_jinLock_not_alert = bool
								}
								let ok_func = () => {
									request_fun(true)
								}
								let [diamond_enough, gap2] = model.MoneyIsEnough(1, gap)
								if (diamond_enough) {
									if (model.mystery_lung_jinLock_not_alert == false) {
										let str = `<font color=#ff4f50>当前绑玉数量不足，是否消耗勾玉代替？</font>`
										let content = Util.StrToHTML(str)
										Alert.Show(content, Alert_Type.AlertTypeCheckBox, ok_func, undefined, "确定", "取消", undefined, false, check_func, "本次登录不再提示")
										Alert.SetIsCharge(true)
									} else {
										ok_func()
									}
								} else {
									request_fun()
								}
							}
						} else {
							request_fun()
						}
					}
				}
			}, this, true)

			let refresh_effect = (_type) => {
				if (_type == LungShopType) {
					last_show_effect_time_ = local_TimeUtil.getServerTime()
				}
			}
			this.BindEvent(model, local_ShopEvent.SHOW_REFRESH_EFFECT, refresh_effect)

			let score_fun = (vo) => {
				if (vo.currency_id == local_LungModel.LungStone1 || vo.currency_id == local_LungModel.LungStone2 || vo.currency_id == local_LungModel.LungStone3) {
					this.SetMyLungStone()
				}
			}
			this.BindEvent(goods_model, local_GoodsModel.UPDATE_SPECIAL_SCORE, score_fun)

			this.SetData(true)
		}

		this.UpdataDataList = (cfg_id)=>{
			if (this.data_list){
				let new_vo = model.GetMysteryDataById(LungShopType, cfg_id)
				if (new_vo){
					new_vo = new_vo
					for (let  vo of this.data_list) {
						if (vo.cfg_id == new_vo.cfg_id){
							vo.buy_num = new_vo.buy_num
							break
						}
					}
					this.loop_mgr.replaceAll(this.data_list)
				}
			}
		}

		this.SetData = (need_sort = false) => {
			data_ = model.mystery_data[LungShopType]
			if (!data_) {
				return
			}
			data_.good_list = model.FormatMysteriousData(data_.good_list)
			let list = Util.DeepCopy(data_.good_list)
			if (need_sort){
				let sort_fun = (a, b) => {
					if (a.sell_out != b.sell_out) {
						return a.sell_out < b.sell_out
					}
					if (a.type_id != b.type_id && (a.type_id == 38040030 || b.type_id == 38040030)) { // 神纹精粹优先
						return a.type_id == 38040030;
					}
					if (a.type_id != b.type_id && (a.type_id == 38040100 || b.type_id == 38040100)) { // 其次完美神纹碎片
						return a.type_id == 38040100;
					}
					if (a.type != b.type) { // 其次道具类型（神纹宝箱->神纹碎片）
						return a.type < b.type;
					}
					if (a.sub_type != b.sub_type) { // 其次道具子类型（超然->启迪->基础）
						return a.sub_type > b.sub_type;
					}
					if (a.color != b.color) { // 其次道具品质
						return a.color > b.color;
					}
					return a.type_id > b.type_id; // id倒序
				}
				table.sort(list, sort_fun)
			}
			this.data_list = list
			if (!this.loop_mgr) {
				this.loop_mgr = new LoopScrowViewMgr(this.layer_value)
				this.loop_mgr.SetData(this.scroll_group, LungShopItem, this.data_list, LoopScrCon.Vertical, 1)
			} else {
				this.loop_mgr.replaceAll(this.data_list)
			}


			// this.scroll_group.setContentSize(594, (Math.ceil(data_.good_list.length / 3)) * (LungShopItem.height + 6))

			// if (!arrayCollection_) {
			// 	this.InitContent()
			// } else {
			// 	arrayCollection_.replaceAll(data_.good_list)
			// }
			this.SetRefreshAndCost()
			this.SetMyLungStone()
		}

		// this.InitContent = () => {


		// 	if (!arrayCollection_) {
		// 		arrayCollection_ = new eui.ArrayCollection()
		// 	}
		// 	arrayCollection_.source = data_.good_list
		// 	this.scroll_group.dataProvider = arrayCollection_
		// 	this.scroll_group.itemRenderer = LungShopItem
		// }

		//设置刷新
		this.SetRefreshAndCost = () => {
			this.SetCost()
			this.StartTimer()
		}

		//设置刷新消耗
		this.SetCost = () => {
			if (!data_) {
				return
			}
			ticket_enough_ = false
			money_cost_cfg_ = undefined
			let cfg = model.GetRefreshCfg(data_.hit_num, LungShopType)
			if (cfg) {
				let cost = 0;
				let cost_cfg = JSON.parse(cfg.cost)
				if (cost_cfg) {
					for (let vo of cost_cfg) {
						if (vo[0] != undefined) {
							if (vo[0] == 0) {	//消耗物品刷新
								let my_have = goods_model.GetTypeGoodsNum(vo[1])
								if (my_have >= vo[2]) {	//有足够物品可消耗
									ticket_enough_ = true
									cost = vo[2]
									break
								}
							} else {
								money_cost_cfg_ = vo
								let color_str = "'#0a953e'"
								let [enough, gap, my_have] = model.MoneyIsEnough(vo[0], vo[2])
								if (!enough) {
									color_str = "'#ff4f50'"
								}
								cost = vo[2]
							}
						}
					}
				}
				
				if(cost > 0){
					this._Image4.visible = this.cost_num.visible = true
					this.cost_num.text = String(cost);
					this._Label1.text = "立即刷新"
					this._Label1.x = 15
				}else{
					this._Image4.visible = this.cost_num.visible = false
					this._Label1.x = 42
					this._Label1.text = "免费刷新"
				}
			}
		}

		this.StartTimer = () => {
			this.CancelTimer()
			count_time_id_ = GlobalTimerQuest.AddPeriodQuest(this.OnTime, 1)
			this.OnTime()

			// count_time_id_ = new egret.Timer(1000, 0)
			// count_time_id_.addEventListener(egret.TimerEvent.TIMER, this.OnTime, this)
			// count_time_id_.start()
			// this.OnTime()
		}

		this.OnTime = () => {
			if (data_ && data_.refresh_time != undefined) {
				let left_time = data_.refresh_time - local_TimeUtil.getServerTime()
				if (left_time < 0) {
					this.CancelTimer()
					this.refresh_time.text = "00:00:00"
					return
				}
				let time_str = local_TimeUtil.convertTime(left_time)
				this.refresh_time.text = String(time_str)
			}
		}

		this.CancelTimer = () => {
			if (count_time_id_) {
				GlobalTimerQuest.CancelQuest(count_time_id_)
				count_time_id_ = null
			}
			// if (count_time_id_) {
			// 	count_time_id_.stop()
			// 	count_time_id_.removeEventListener(egret.TimerEvent.TIMER, this.OnTime, this)
			// 	count_time_id_ = undefined
			// }
		}

		//设置我拥有的龙石
		this.SetMyLungStone = () => {
			let have1 = goods_model.GetSpecialScore(local_LungModel.LungStone1)
			let have2 = goods_model.GetSpecialScore(local_LungModel.LungStone2)
			let have3 = goods_model.GetSpecialScore(local_LungModel.LungStone3)
			this.my_have1.text = String(have1)
			this.my_have2.text = String(have2)
			this.my_have3.text = String(have3)
		}

		//购买成功
		this.BuyGoodsSuccess = (cfg_id) => {
			let cfg = model.GetMysteryShopCfg(cfg_id)
			if (cfg && cfg.type == LungShopType) {
				let goods = JSON.parse(cfg.goods)
				if (goods) {
					LungModel.GetInstance().ShowGoodsFly(goods)
				}
			}
		}
	}


	
	_Image1: Laya.Image
	_Image2: Laya.Image
	scroll_group: Laya.List
	refreshBtn: Laya.Box
	_Image3: Laya.Image
	_Label1: Laya.Label
	cost_con: Laya.HBox
	cost_num: Laya.Label
	_Image4: Laya.Image
	refresh_con: Laya.HBox
	_Image5: Laya.Image
	refresh_time: Laya.Label
	own1: Laya.Box
	_Image6: Laya.Image
	cost_icon1: Laya.Box
	my_have1: Laya.Label
	own2: Laya.Box
	_Image7: Laya.Image
	cost_icon2: Laya.Box
	my_have2: Laya.Label
	own3: Laya.Box
	_Image8: Laya.Image
	cost_icon3: Laya.Box
	my_have3: Laya.Label
	public GetComponents() {
		[
			this._Image1,
			this._Image2,
			this.scroll_group,
			this.refreshBtn,
			this._Image3,
			this._Label1,
			this.cost_con,
			this.cost_num,
			this._Image4,
			this.refresh_con,
			this._Image5,
			this.refresh_time,
			this.own1,
			this._Image6,
			this.cost_icon1,
			this.my_have1,
			this.own2,
			this._Image7,
			this.cost_icon2,
			this.my_have2,
			this.own3,
			this._Image8,
			this.cost_icon3,
			this.my_have3,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_Image2",
				"scroll_group",
				"refreshBtn",
				"_Image3",
				"_Label1",
				"cost_con",
				"cost_num",
				"_Image4",
				"refresh_con",
				"_Image5",
				"refresh_time",
				"own1",
				"_Image6",
				"cost_icon1",
				"my_have1",
				"own2",
				"_Image7",
				"cost_icon2",
				"my_have2",
				"own3",
				"_Image8",
				"cost_icon3",
				"my_have3",
			])
	}
}
window["LungShopView"] = LungShopView
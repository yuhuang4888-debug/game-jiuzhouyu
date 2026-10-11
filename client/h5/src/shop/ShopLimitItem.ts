import { Alert, Alert_Type } from "../alert/Alert"
import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { Config } from "../common/Config"
import { EventName } from "../common/EventName"
import { MaterialsTool } from "../common/MaterialsTool"
import { ResManager } from "../common/ResManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { ShopModel, ShopEvent, ShopType, ShopMoneyType } from "../commonModel/ShopModel"
import { PlatformManager } from "../PlatformManager"
import { RoleManager } from "../commonModel/RoleManager"
import { Message } from "../sysInfo/SysInfoController"
import { ColorType, ColorUtil, Enum_ColorUtil_Dark, Enum_ColorUtil_Light } from "../util/ColorUtil"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { Mathf } from "../util/Mathf"
import { SetAnchoredPositionY, SetSizeDeltaY, SetAnchoredPositionX, GetLocalPositionY, Util, Trim, SetSizeDeltaX, GetSizeDeltaX, SetLocalPositionX, HtmlColorTxt, SetLocalPositionY } from "../util/Util"
import { kfSingleRankModel } from "../commonModel/kfSingleRankModel"
import { GuildModel } from "../commonModel/GuildModel"
import { FashionPartPos } from "../scene/SceneConfig"
import { GodCourtModel } from "../commonModel/GodCourtModel"
import { SpecialCharKey } from "../common/SpecialCharKey"

export class ShopLimitItem extends BaseItemRenderer {
	Empbuy_btn
	Empnormal_buy_btn
	Empsell_out_btn
	btn_img
	btn_img0
	buy_btn
	buy_event_id
	condition
	cost_icon
	cost_item
	delete_line
	discount_style
	goods_icon
	goodsname:Laya.Label
	img_disc
	item
	jinLock_event_id
	jin_event_id
	limitLb
	limit_conta
	limit_num
	model
	normal_buy_btn
	normal_cost_conta
	normal_cost_conta_pos_y
	normal_cost_icon
	normal_cost_item
	normal_price
	normal_style
	now_price
	original_cost_conta_pos_y
	original_cost_item
	orignal_cost
	orignal_cost_icon
	orignal_price
	price
	sell_out
	sell_out_btn
	special_event_id
	update_one_event_id
	EffectGp
	_Image1: Laya.Image
	cost_conta: Laya.HBox
	_Label1: Laya.Label
	_Group1: Laya.HBox
	_Image2: Laya.Image
	_lb: Laya.Label
	soldout_text: Laya.Label
	//this.AddUIEffect("UI_1601_0" + (data.color == 4 && ("3") || ("4")), this.EffectGp1, null, null, true)

	//gap 6
	public WIDTH = 221
	public HEIGT = 324

	public constructor(parent) {
		super()


		this.base_file = "shop"
		this.layout_file = "ShopLimitItem"
		// this.skinName="resource/game/shop/exml/ShopLimitItemExml.exml"

		this.model = ShopModel.GetInstance()
		this.now_price = null

		this.buy_event_id = null
		this.jin_event_id = null
		this.jinLock_event_id = null
		this.update_one_event_id = null
		this.special_event_id = null
		this.Load()
		// this.load_callback()


	}

	public load_callback() {

		this.LoadSuccess()
		this.InitEvent()
		if (PlatformManager.IsEyouEnPlatform()) {
			this.goodsname.centerX= 0
			this.goodsname.y = 106
			this.goodsname.width = 174
			this.goodsname.height = 68
			this.goodsname.fontSize = 18
			this.goodsname.wordWrap = true
			this.goodsname.align="center"
			this.goodsname.valign="middle"
			this.goodsname.leading = 0.1
			this.limitLb.fontSize = 18
			this.limit_num.fontSize = 18
			this.condition.wordWrap = true
			this.condition.leading = 0.1
		}
		// if (PlatformMgr.GetInstance().IsEyouIdnPlatform() ) {
		// 	this.limitLb.size  = 14
		// 	this.limitLb.lineSpacing = 0.6
		// 	this.limit_num.size  = 18
		// 	SetAnchoredPositionX(this.limit_conta,-18.93)
		// 	this.goodsname.size  = 18
		// 	this.condition.size  = 16
		// }
	}

	public LoadSuccess() {

		this.original_cost_item = new BaseAwardItem(this.orignal_cost_icon)
		this.original_cost_item.Load()
		this.original_cost_item.SetItemSize(32, 32)
		this.original_cost_item.SetItembgVisible(false)

		this.cost_item = new BaseAwardItem(this.cost_icon)
		this.cost_item.Load()
		this.cost_item.SetItemSize(32, 32)
		this.cost_item.SetItembgVisible(false)

		this.normal_cost_item = new BaseAwardItem(this.normal_cost_icon)
		this.normal_cost_item.Load()
		this.normal_cost_item.SetItemSize(32, 32)
		this.normal_cost_item.SetItembgVisible(false)

		//this.sell_out.touchEnabled = false
		this.normal_cost_conta_pos_y = GetLocalPositionY(this.normal_cost_conta)
		this.original_cost_conta_pos_y = GetLocalPositionY(this.orignal_cost)

		Util.SetImageGray(this.sell_out_btn, true)
		if (PlatformManager.IsEyouEnPlatform()) {
			this.condition.size = 18
			this.condition.lineSpacing = 0.8
		}
	}

	public InitEvent() {

		let buy_fun = () => {
			if (this.data) {
				let ok_func = (force?) => {
					if (!force && this.data.mystery_shop_good) {
						let [enough, gap, my_have, str] = this.model.MoneyIsEnough(this.data.money_type, this.now_price)
						if (!enough) {
							Message.show(str)
							return
						}
					}
					this.model.Fire(ShopEvent.SHOP_REQUEST_PROTO, 15302, "ii", this.data.key_id, 1)
				}

				let check_func = (bool?) => {
					this.model.jinLock_not_enough_not_alert = bool
				}

				let ok_btn_fun = () => {
					ok_func(true)
				}

				if ((this.data.quota_num > 10 || this.data.quota_num == 0) && this.data.type != ShopType.Outward && this.data.type != ShopType.Lucky) {
					this.data.scmd = 15302
					if(this.data.money_type == ShopMoneyType.Ghost_Walk){
						let [enough, gap] = this.model.MoneyIsEnough(this.data.money_type, this.now_price)
						if (!enough) {
							let cost_type_id = Config.PRELOAD_CLIENT_CONFIG.ConfigNotNormalGoods[this.data.money_type] && Config.PRELOAD_CLIENT_CONFIG.ConfigNotNormalGoods[this.data.money_type].goods_id || 0
							MaterialsTool.GetInstance().materialsTips(cost_type_id)
						} else {
							ShopModel.GetInstance().Fire(ShopEvent.SHOP_OPEN_VIEW, "ShopBulkPurchaseView", this.data) 
						}
					}else{
						ShopModel.GetInstance().Fire(ShopEvent.SHOP_OPEN_VIEW, "ShopBulkPurchaseView", this.data) 
					}
				
				} else {
					if (this.data.money_type == 2) {	//消耗绑钻
						let [enough, gap] = this.model.MoneyIsEnough(this.data.money_type, this.now_price)
						if (!enough) {
							let diamond_enough, gap2 = this.model.MoneyIsEnough(1, gap)
							if (diamond_enough) {
								if (this.model.jinLock_not_enough_not_alert == false) {
									let content = Util.StrToHTML("<font color='#ff4f5'>当前绑玉数量不足，是否消耗勾玉代替？</font>")
									Alert.Show(content, Alert_Type.AlertTypeCheckBox, ok_btn_fun, null, "确定", "取消", null, false, check_func, "本次登录不再提示")
									Alert.SetIsCharge(true)
								} else {
									ok_btn_fun()
								}
							} else {
								ok_func()
							}
						} else {
							ok_func()
						}
					} else if (this.data.money_type == 41
						|| this.data.money_type == ShopMoneyType.CSPVP
						|| this.data.money_type == ShopMoneyType.KfSingleRank
						|| this.data.money_type == ShopMoneyType.Lucky
						|| this.data.money_type == ShopMoneyType.Guild
						|| this.data.money_type == ShopMoneyType.Ghost_Walk) {
						let [enough, gap] = this.model.MoneyIsEnough(this.data.money_type, this.now_price)
						if (!enough) {
							let cost_type_id = Config.PRELOAD_CLIENT_CONFIG.ConfigNotNormalGoods[this.data.money_type] && Config.PRELOAD_CLIENT_CONFIG.ConfigNotNormalGoods[this.data.money_type].goods_id || 0
							MaterialsTool.GetInstance().materialsTips(cost_type_id)
						} else {
							ok_func()
						}
					} else {
						ok_func()
					}
				}
			}
		}
		Util.AddClickEvent(this.buy_btn, buy_fun, this, true)
		Util.AddClickEvent(this.normal_buy_btn, buy_fun, this, true)

		Util.AddClickEvent(this.sell_out_btn, () => {
			Message.show("没货啦~")
		}, this, true)

		let success_fun = (key_id?) => {
			if (this.data && this.data.key_id == key_id) {
				if ((this.data.quota_num > 10 || this.data.quota_num == 0) && this.data.type != ShopType.Outward) {

				} else {
					// let pos = UILocalToCanvasPoint(this.goods_icon,co.TableXY(0, 1), co.TableXY(0, 1))
					let pos = this.goods_icon.localToGlobal(0, 0)
					let list = [{ "0": 0, "1": this.data.goods_id, "2": 1 }]
					GlobalEventSystem.Fire(EventName.REWARD_FLY, list, pos, null, null, -40, 300, 700)
					this.model.Fire(ShopEvent.SHOP_ICON_FLY, this.data.goods_id, pos)
				}
			}
		}
		this.BindEvent(this.model, ShopEvent.BUY_GOODS_SUCCESS, success_fun)

		let refresh_fun = (key_id?) => {
			if (this.data && this.data.key_id == key_id) {
				this.data = this.model.GetShopDataByKeyId(key_id)
				this.SetState()
			}
		}
		this.BindEvent(this.model, ShopEvent.UPDATE_SHOP_ONE_DATA, refresh_fun)

		let refresh_fun2 = (key_id?) => {
			this.SetState()
		}
		this.BindVar(RoleManager.Instance.mainRoleInfo, "jinLock", refresh_fun2)
		this.BindVar(RoleManager.Instance.mainRoleInfo, "jin", refresh_fun2)
		this.BindEvent(GoodsModel.GetInstance(), GoodsModel.UPDATE_SPECIAL_SCORE, refresh_fun2)
	}

	public dataChanged() {
		if (super.dataChanged()) {

			//if (this.item ) {
			//this.item.DeleteMe()
			//this.item = null
			//}
			//商品图标及名字
			if (!this.item) {
				this.item = new BaseAwardItem(this.goods_icon)
				//this.AddUIEffect("UI_1305_1", this.EffectGp, null, null, true)
				this.item.SetUseMask(true)
				this.item.Load()
				this.item.SetItemSize(82, 84)
			}
			let basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(this.data.goods_id)
			if (basic) {
				this.item.SetData(this.data.goods_id, this.data.num)
				//天境绿色品质颜色特殊处理
				let color_str = (basic.type == 76 && basic.color == 1) && "'#639C12'" || ColorUtil.GetColorLight(basic.color)
				color_str = color_str.replace(SpecialCharKey.ShopLimitItem1, "");
				color_str = color_str.replace(SpecialCharKey.ShopLimitItem1, "");
				//"<font color=" + local_ColorUtil.GetColorDark(info.color) + ">" + pro + ("+") + value + "</font>"
				let name = "<font color=" + color_str + ">" + Trim(basic.goods_name) + "</font>"
				this.goodsname.text = Trim(basic.goods_name)
				this.goodsname.color = color_str
				// this.goodsname.textFlow = Util.StrToHTML(name)
			}

			//根据是否有折扣启用不同的显示模式
			let have_discount = this.data.discount < 100 && true || false
			this.discount_style.visible = have_discount
			this.normal_style.visible = !have_discount
			if (have_discount) {
				ResManager.GetInstance().SetImageSprite(this, this.img_disc, "common2_asset", "sh_discount_" + this.data.discount / 10, true)
			}
			this.orignal_cost.visible = have_discount
			//价格
			let now_price = Mathf.Round(this.data.price * this.data.discount / 100)
			this.now_price = now_price
			this.price.text = String(now_price)
			this.orignal_price.text = this.data.price
			this.normal_price.text = String(now_price)
			// this.price.textFlow = Util.StrToHTML(String(now_price))
			// this.orignal_price.textFlow = Util.StrToHTML(this.data.price)
			// this.normal_price.textFlow = Util.StrToHTML(String(now_price))
			//删除线宽度、位置
			let delete_width = 35 + 12 + this.orignal_price.preferredWidth
			SetSizeDeltaX(this.delete_line, delete_width)
			let org_cost_width = GetSizeDeltaX(this.orignal_cost)
			SetLocalPositionX(this.delete_line, (org_cost_width - delete_width + 12) / 2)

			this.SetState()

		}

	}

	public SetState() {

		if (this.data) {
			//限购状态
			this.limit_conta.visible = this.data.quota_num > 0
			let limit_color = (this.data.quota_num - this.data.sold_out > 0) && "#d15e00" || "#ff4f50"
			limit_color = limit_color.replace(SpecialCharKey.ShopLimitItem1, "");
			limit_color = limit_color.replace(SpecialCharKey.ShopLimitItem1, "");
			let limit_text = (this.data.quota_num - this.data.sold_out) + "/" + this.data.quota_num
			// limit_text = HtmlColorTxt(limit_text, limit_color)
			this.limit_num.color = limit_color
			this.limit_num.text = limit_text
			// this.limit_num.textFlow = Util.StrToHTML(limit_text)
			let limitStr = "限购"
			if (this.data.quota_type == 1) {
				limitStr = "每日限购"
			} else if (this.data.quota_type == 2) {
				limitStr = "每周限购"
			} else if (this.data.quota_type == 3) {
				limitStr = "终生限购"
			}
			this.limitLb.text = limitStr
			// this.limitLb.textFlow = Util.StrToHTML(limitStr)
			//LayoutRebuilder(this.limit_conta)

			//销售状态
			let show = false
			if (this.data.quota_num > 0) {
				if ((this.data.quota_num - this.data.sold_out) > 0) {
					show = false
				} else {
					show = true
				}
			}
			this.sell_out.visible = show
			this.sell_out_btn.visible = show
			this.sell_out.touchEnabled = false;
			if (this.item) {
				this.item.SetGary(show)
			}
			this.buy_btn.visible = !show
			this.normal_buy_btn.visible = !show
			Util.SetImageGray(this.img_disc, show)

			//如果没有限购文本，价格文本位置上移
			// let normal_y = this.data.quota_num > 0 && this.normal_cost_conta_pos_y || this.normal_cost_conta_pos_y - 10
			// SetLocalPositionY(this.normal_cost_conta, normal_y)
			// let original_y = this.data.quota_num > 0 && this.original_cost_conta_pos_y || this.original_cost_conta_pos_y - 10
			// SetLocalPositionY(this.orignal_cost, original_y)
			//LayoutRebuilder(this.normal_cost_conta)

			//货币
			let cost_type_id = null
			if (this.data.money_type == ShopMoneyType.Guild2) {
				cost_type_id = ShopMoneyType.Guild2
			} else {
				let ndata = Config.PRELOAD_CLIENT_CONFIG.ConfigNotNormalGoods[this.data.money_type]
				cost_type_id = ndata && ndata.goods_id || 0
			}
			if (this.cost_item) {
				this.cost_item.SetData(cost_type_id, 0)
				this.cost_item.SetShowTips(false)
			}
			if (this.normal_cost_item) {
				this.normal_cost_item.SetData(cost_type_id)
			}
			if (this.original_cost_item) {
				this.original_cost_item.SetData(cost_type_id)
			}

			let [enough, gap] = this.model.MoneyIsEnough(this.data.money_type, this.now_price)
			//let color_str = enough && "#ffffff" || "#ffffff"
			//this.price.color = color_str
			//this.price.stroke = (enough && ( 2 ) || ( 2 ) )

			//价格颜色
			//let color_str2 = enough && ColorUtilValue.DARKWHITE || ColorUtilValue.RED
			// let color_str2 = enough && 0x000000 || Enum_ColorUtil_Light.RED
			if (enough) {
				this.normal_price.color = "#d15e00"
			} else {
				this.normal_price.color = "#ff4f50"
			}
			// this.normal_price.color = color_str2

			this.SetCondition()
		}
	}

	public SetCondition() {

		if (this.data) {
			//购买条件
			let condition = ErlangParser.GetInstance().Parse(this.data.condition)
			let condition_dic = []
			for (let key in condition) {
				var cond_vo = condition[key]
				let obj = condition[key]
				// condition_dic[obj[1*/ = obj[2]
				condition_dic[obj[0]] = obj[1]
			}
			let is_show_cond = false
			if (Util.TableSize(condition) > 0) {
				let vip_flag = RoleManager.Instance.mainRoleInfo.vip_flag
				let str = ""
				if (condition_dic["lv"] && RoleManager.Instance.mainRoleInfo.level < Number(condition_dic["lv"])) {
					is_show_cond = true
					str = condition_dic["lv"] + "级以上可购买"
				} else if (condition_dic["vip"] && vip_flag < Number(condition_dic["vip"])) {
					is_show_cond = true
					// if (PlatformManager.IsEyouIdnPlatform() ) {
					// 	str = "Khusus VIP " + condition_dic["vip"] + " keatas"
					// }else{
					// 	str = "VIP" + condition_dic["vip"] + "以上可购买"
					// }
					str = "VIP" + condition_dic["vip"] + "以上可购买"
					//} else if (condition_dic["top_pk_grade"] && TopPkModel.GetInstance().level_data && TopPkModel.GetInstance().level_data.rank_lv < Number(condition_dic["top_pk_grade"]) ) {
					//let top_pk_rank_reward_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_top_pk_rank_reward", false)
					//let levelCfg = TopPkModel.GetInstance().GetLevelCfg(condition_dic["top_pk_grade"], top_pk_rank_reward_cfg)
					//if (levelCfg ) {
					//str = levelCfg.rank_name + "以上可以购买"
					//}
					//is_show_cond = true
				} else if (condition_dic["rank_dun_level"]
					&& kfSingleRankModel.GetInstance().GetCurAreaID() < Number(condition_dic["rank_dun_level"])
				) {
					str = "需达到天境" + Number(condition_dic["rank_dun_level"]) + "阶试炼"
					is_show_cond = true
				} else if (condition_dic["constellation_equip"]
					// && ! starEquipModel.GetInstance().StarEquipIsActive(Number(condition_dic["constellation_equip"]))
				) {
					is_show_cond = true
					ResManager.GetInstance().LoadGameConfig(ResManager.GetInstance(), "ClientStarEquip", true, undefined, (cfgs) => {
						let tabList = cfgs.tabList[Number(condition_dic["constellation_equip"])]
						if (tabList) {
							str = "需解锁" + tabList.name
						}
						this.condition.text = Util.StrToHTML(str)
					});
				} else if (condition_dic["god_pool_lv"]
					&& Number(condition_dic["god_pool_lv"]) > GodCourtModel.GetInstance().GetHouseRewardLv()
				) {
					ResManager.GetInstance().LoadGameConfig(ResManager.GetInstance(), "config_god_house_reward", false, undefined, (cfgs) => {
						let cfg = cfgs //lua_resM:GetGameConfigFromCache(this, "config_god_house_reward", false)
						is_show_cond = true
						if (cfg) {
							let curCfg = cfg[Number(condition_dic["god_pool_lv"])]
							if (curCfg) {
								str = "累计勾玉升橙" + curCfg.down_num + "次"
							}
						}
						this.condition.text = Util.StrToHTML(str)
						this.condition.visible = is_show_cond
						if (is_show_cond) {
							this.sell_out_btn.visible = !is_show_cond
							this.buy_btn.visible = !is_show_cond
							this.normal_buy_btn.visible = !is_show_cond
						}
					});
				} else if (condition_dic["guild_lv"]
					&& GuildModel.GetInstance().GetGuildLv() < Number(condition_dic["guild_lv"])
				) {
					str = "结社需达到" + Number(condition_dic["guild_lv"]) + "级"
					is_show_cond = true
				}
				else if (condition_dic["guild_title"] && GuildModel.GetInstance().GetTitleId() < Number(condition_dic["guild_title"])) {
					let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_guild_prestige", false)
					let data = cfg[Number(condition_dic["guild_title"])]
					let title = data && data.title_name || ""
					str = "结社头衔需达到" + title
					is_show_cond = true
					this.condition.text = Util.StrToHTML(str)
				}
				// this.condition.text = str
				this.condition.text = Util.StrToHTML(str)

			}
			this.condition.visible = is_show_cond
			if (is_show_cond) {
				this.sell_out_btn.visible = !is_show_cond
				this.buy_btn.visible = !is_show_cond
				this.normal_buy_btn.visible = !is_show_cond
			}
		}
	}

	public DeleteMe() {

		if (this.original_cost_item) {
			this.original_cost_item.DeleteMe()
			this.original_cost_item = null
		}
		if (this.item) {
			this.item.DeleteMe()
			this.item = null
		}
		if (this.cost_item) {
			this.cost_item.DeleteMe()
			this.cost_item = null
		}
		if (this.normal_cost_item) {
			this.normal_cost_item.DeleteMe()
			this.normal_cost_item = null
		}
		super.DeleteMe()
	}

	public GetComponents() {
		[
			this._Image1,
			this.goodsname,
			this.goods_icon,
			this.img_disc,
			this.limit_conta,
			this.limitLb,
			this.limit_num,
			this.discount_style,
			this.buy_btn,
			this.btn_img,
			this.cost_conta,
			this._Label1,
			this.cost_icon,
			this.price,
			this.orignal_cost,
			this._Group1,
			this.orignal_cost_icon,
			this.orignal_price,
			this.delete_line,
			this.normal_style,
			this.normal_cost_conta,
			this.normal_cost_icon,
			this.normal_price,
			this.normal_buy_btn,
			this._Image2,
			this._lb,
			this.sell_out,
			this.sell_out_btn,
			this.btn_img0,
			this.soldout_text,
			this.condition,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"goodsname",
				"goods_icon",
				"img_disc",
				"limit_conta",
				"limitLb",
				"limit_num",
				"discount_style",
				"buy_btn",
				"btn_img",
				"cost_conta",
				"_Label1",
				"cost_icon",
				"price",
				"orignal_cost",
				"_Group1",
				"orignal_cost_icon",
				"orignal_price",
				"delete_line",
				"normal_style",
				"normal_cost_conta",
				"normal_cost_icon",
				"normal_price",
				"normal_buy_btn",
				"_Image2",
				"_lb",
				"sell_out",
				"sell_out_btn",
				"btn_img0",
				"soldout_text",
				"condition",
			])
	}
}
window["ShopLimitItem"] = ShopLimitItem
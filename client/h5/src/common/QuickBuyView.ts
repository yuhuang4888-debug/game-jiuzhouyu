import { GoodsModel } from "../commonModel/GoodsModel"
import { ShopEvent, ShopModel } from "../commonModel/ShopModel"
import { PlatformManager } from "../PlatformManager"
import { RoleManager } from "../commonModel/RoleManager"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { Mathf } from "../util/Mathf"
import { SetAnchoredPosition, SetAnchoredPositionY, SetSizeDeltaY, Util } from "../util/Util"
import { BaseAwardItem } from "./BaseAwardItem"
import { BaseView1 } from "./BaseView1"
import { CommonManager } from "./CommonManager"
import { EventName } from "./EventName"
import { Enum_UILayer } from "./LayerManager"
import { OpenFun } from "./OpenFun"
import { ResManager } from "./ResManager"
import { table } from "./table"

export class QuickBuyView extends BaseView1 {
	figureGp
	_viewport
	all_price: any

	SetIconData
	NumChange
	calculator_fun
	SetCurNum
	Local_Open
	SetAllPrice
	Scricon_scroller
	GetDunMaterialState
	SetBuyType
	InitEvent
	InitView

	public constructor() {
		super()
		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName
		let goods_model = GoodsModel.GetInstance()
		let role_mgr = RoleManager.GetInstance()
		let local_Message = Message
		let shop_model = ShopModel.GetInstance()
		let erlang_parser = ErlangParser.GetInstance()
		let local_OpenFun = OpenFun
		let common_mgr = CommonManager.GetInstance()
		// let vip_model = VipModel.GetInstance()
		// let local_BaseDungeonModel = BaseDungeonModel
		let local_Number = Number
		let _goodsVo = null
		let _cur_num = null
		let _gold_price = null
		let _bgold_price = null
		let _goods_item = null
		let _price_cfg = null
		let _buy_type = null
		let _figureIcon = null
		let _icon_list = null
		let _buy_btn_pos = 0

		this.base_file = "common"
		this.layout_file = "QuickBuyView"
		//this.dependent_res = ["icon", "mainUI"]
		this.layer_value = Enum_UILayer.Activity
		this.use_background = true
		this.is_center = true
		this.show_open_movie = true
		this.destroy_imm = true
		this.click_bg_toClose = true
		this.preload_server_config = {
			config_quick_buy_price: false
		}

		this.all_price = null

		this.load_callback = () => {
			this.icon_scroller.hScrollBar.visible = false
			this.name_label.style.fontSize = 24
			this.name_label.style.color = "#fe1a1a"
			_buy_btn_pos = this.buy_btn.x
			if (_goodsVo) {
				this.InitView()
			}
		}

		this.close_callback = () => {
			if (this.figureGp) {
				local_GlobalEventSystem.Fire(local_EventName.HIDE_FINGER, this.figureGp)
				this.figureGp = null
			}
			if (_goods_item) {
				_goods_item.DeleteMe()
				_goods_item = null
			}
			if (_icon_list && _icon_list.length > 0) {
				for (let _tmpi in _icon_list) {
					var vo = _icon_list[_tmpi]
					if (vo) {
						// destroy(vo)
						this.icon_group.removeChild(vo)
						vo = null
					}
				}
			}
			_icon_list = null
		}

		this.Local_Open = (goodsVo?) => {
			_goodsVo = goodsVo
			if (this.is_loaded) {
				this.InitView()
			}
			super.Open()
		}

		this.InitView = () => {
			_price_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_quick_buy_price", false)
			ResManager.GetInstance().SetImageSpriteTrans(this, this.bg1, "resource/game/common/texture/bg_03.png")
			if (_goodsVo && _price_cfg) {
				let goodsBasic = goods_model.GetGoodsBasicByTypeId(_goodsVo.type_id)
				if (goodsBasic) {
					_goods_item = new BaseAwardItem(this.item_group)
					_goods_item.Load()
					_goods_item.SetData(goodsBasic.type_id)
					_goods_item.SetItemSize(87, 87)
					this.name_label.width = 200
					this.name_label.innerHTML = GoodsModel.GetGoodsNameWithColorDark(goodsBasic.type_id)
				}

				let price_cfg = _price_cfg[_goodsVo.type_id]
				if (price_cfg) {
					_gold_price = price_cfg.gold_price
					_bgold_price = price_cfg.bgold_price
					this.diamond_label.text = _gold_price
					this.binddiamond_label.text = _bgold_price
					if (_goodsVo.goods_num) {
						let goods_num = _goodsVo.goods_num
						this.SetCurNum(goods_num)
						this.SetAllPrice(goods_num)
					} else {
						_cur_num = 1
					}
					if (_bgold_price == 0) {
						this.binddiamond_group.visible = false
						this.SetBuyType(1)
					} else {
						this.SetBuyType(2)
					}
				}
				this.SetIconData(goodsBasic.getway_url, _goodsVo.type_id)
			}
			this.InitEvent()
			if (PlatformManager.GetInstance().is_alpha) {
				this.buy_btn.x = _buy_btn_pos - 131
				this.recharge_btn.visible = false
			} else {
				this.buy_btn.x = _buy_btn_pos
				this.recharge_btn.visible = true
			}

			SetAnchoredPositionY(this.diamond_group, 302)
			SetAnchoredPositionY(this._Label1, 363)
			SetAnchoredPositionY(this.total_icon, 362)
			SetAnchoredPositionY(this.total_label, 370)
			let num = 363 - 313
			if (!this.binddiamond_group.visible && this.diamond_group.visible) {
				SetAnchoredPositionY(this.diamond_group, 250)
				SetAnchoredPositionY(this._Label1, 363-num)
				SetAnchoredPositionY(this.total_icon, 362-num)
				SetAnchoredPositionY(this.total_label, 370-num)
			}

			if (!this.binddiamond_group.visible || !this.diamond_group.visible) {
				this.other_group.visible = false
				SetSizeDeltaY(this.bg1, 580)
				SetSizeDeltaY(this._Image1, 225)
				SetSizeDeltaY(this.bg1, 490)
				SetSizeDeltaY(this, 580)
				SetAnchoredPositionY(this.recharge_btn, 405)
				SetAnchoredPositionY(this.buy_btn, 405)
			}

		}

		this.InitEvent = () => {
			Util.AddClickEvent(this.reduce_btn, () => {
				this.NumChange(_cur_num - 1)
			}, this, true)

			Util.AddClickEvent(this.increase_btn, () => {
				this.NumChange(_cur_num + 1)
			}, this, true)

			Util.AddClickEvent(this.max_btn, () => {
				let max = 1
				if (_buy_type == 1) {
					max = Mathf.Floor(role_mgr.GetMainRoleVo().jin / _gold_price)
				} else if (_buy_type == 2) {
					max = Mathf.Floor(role_mgr.GetMainRoleVo().jinLock / _bgold_price)
				}
				if (!max || max == 0) {
					max = 1
				}
				this.NumChange(max)
			}, this, true)

			Util.AddClickEvent(this.close_btn, () => {
				this.Close()
			}, this, true)

			Util.AddClickEvent(this.diamond_group, () => {
				this.SetBuyType(1)
			}, this, false)

			Util.AddClickEvent(this.binddiamond_group, () => {
				this.SetBuyType(2)
			}, this, false)

			Util.AddClickEvent(this.buy_btn, () => {
				let enough = null
				if (_buy_type == 1) {
					enough = (role_mgr.GetMainRoleVo().jin / _gold_price) >= _cur_num
				} else if (_buy_type == 2) {
					enough = (role_mgr.GetMainRoleVo().jinLock / _bgold_price) >= _cur_num
				}
				if (_goodsVo && enough) {
					shop_model.Fire(ShopEvent.SHOP_REQUEST_PROTO, 15304, "iic", _goodsVo.type_id, _cur_num, _buy_type)
					this.Close()
				} else {
					if (_buy_type == 1) {
						local_Message.show("勾玉不足")
					} else {
						local_Message.show("绑玉不足")
					}
				}
			}, this, true)

			Util.AddClickEvent(this.recharge_btn, () => {
				local_OpenFun.OpenFunHandler(21)
				this.Close()
			}, this, true)

			Util.AddClickEvent(this.num_touch, () => {
				this.calculator_fun()
			}, this, false)
		}

		//数量改变
		this.NumChange = (num?) => {
			if (_goodsVo && this.is_loaded) {
				let new_num = num
				if (new_num <= 0) {
					new_num = 1
					local_Message.show("已经是最小购买数量了")
					this.SetCurNum(new_num)
					this.SetAllPrice(new_num)
					return
				}
				let enough = null
				if (_buy_type == 1) {
					enough = (role_mgr.GetMainRoleVo().jin / _gold_price) >= new_num
				} else if (_buy_type == 2) {
					enough = (role_mgr.GetMainRoleVo().jinLock / _bgold_price) >= new_num
				}
				if (!enough && new_num != num) {
					local_Message.show("超过最大购买数量了")
					return
				}
				this.SetCurNum(new_num)
				this.SetAllPrice(new_num)
			}
		}

		//设置总价
		this.SetAllPrice = (buy_num?) => {
			if (_buy_type == 1) {
				this.total_label.text = `${buy_num * _gold_price}`
			} else if (_buy_type == 2) {
				this.total_label.text = `${buy_num * _bgold_price}`
			}
		}

		this.SetBuyType = (type_id?) => {
			_buy_type = type_id
			if (type_id == 1) {
				ResManager.GetInstance().SetImageSprite(this, this.one_icon, "common_asset", "com_diamond", true)
				this.diamond_img.visible = false
				this._Image2.visible = true
				this.binddiamond_img.visible = true
				this._Image4.visible = false
				ResManager.GetInstance().SetImageSprite(this, this.total_icon, "common_asset", "com_diamond", true)
				this.price_label.text = _gold_price
			} else {
				ResManager.GetInstance().SetImageSprite(this, this.one_icon, "common_asset", "com_bind_diamond", true)
				this.diamond_img.visible = true
				this._Image2.visible = false
				this.binddiamond_img.visible = false
				this._Image4.visible = true
				ResManager.GetInstance().SetImageSprite(this, this.total_icon, "common_asset", "com_bind_diamond", true)
				this.price_label.text = _bgold_price
			}
			this.NumChange(_cur_num)
		}

		//设置当前数量
		this.SetCurNum = (num?) => {
			if (!this.is_loaded) {
				return
			}
			_cur_num = num
			this.cur_show_num.text = num
		}

		this.calculator_fun = () => {
			if (_goodsVo) {
				let max_num = 99999
				if (_buy_type == 1) {
					max_num = Mathf.Floor(role_mgr.GetMainRoleVo().jin / _gold_price)
				} else if (_buy_type == 2) {
					max_num = Mathf.Floor(role_mgr.GetMainRoleVo().jinLock / _bgold_price)
				}
				let num_change_fun = (value?) => {
					this.NumChange(value)
				}

				local_GlobalEventSystem.Fire(local_EventName.OPEN_CALCULATOR_VIEW, max_num, num_change_fun, [0, -120])
			}
		}

		this.SetIconData = (url?, type_id?) => {
			let way_attr = erlang_parser.Parse(url)
			let shop_icon = null
			let shop_discount = null
			let otherGoods = null
			let goodsBasic = goods_model.GetGoodsBasicByTypeId(_goodsVo.type_id)
			if (goodsBasic.type <= 22 && goodsBasic.type >= 16 && goodsBasic.subtype == 2) {	//骑宠的道具需要特殊处理 加上高级的培养材料
				otherGoods = type_id + 1
			}
			/*
			if (ActivityIconManager.GetInstance().getIconInfo(176)) {
				//显示钜惠里面
				let shop_data = ShopPurchaseModel.GetInstance().getData()
				for (let index in shop_data) {

					if (shop_data[index].goods_list) {
						for (let _tmpi in shop_data[index].goods_list) {
							var goods_data = shop_data[index].goods_list[_tmpi]
							if (goods_data[2] == type_id || otherGoods == goods_data[2] && shop_data[index].less_num > 0) {
								shop_icon = [67]
								shop_discount = shop_data[index].discount
							}
						}
					}
				}
			}
			*/
			//限购商城里有没有
			/*
			if (!shop_icon) {
				let shop_data = shop_model.GetShopDataByType(ShopType.Limit)
				if (shop_data) {
					for (let _tmpi in shop_data) {
						var shopVo = shop_data[_tmpi]
						if (shopVo.goods_id == type_id || otherGoods == shopVo.goods_id && shopVo.quota_num > shopVo.sold_out) {
							let condition = erlang_parser.Parse(shopVo.condition)
							if (Util.TableSize(condition) > 0) {
								if (String(condition[1][1]) == "lv" && role_mgr.mainRoleInfo.level < Number(condition[1][2])) {
									continue
								} else if (String(condition[1][1]) == "vip" && role_mgr.mainRoleInfo.vip_flag < Number(condition[1][2])) {
									continue
								}
							}
							shop_icon = [60, 1, shopVo.goods_id]
							shop_discount = shopVo.discount
							break
						}

					}
				}
			}
			*/
			if (shop_icon) {
				table.unshift(way_attr, shop_icon)
			}
			//其他路径里有常规商城的都屏蔽

			// for (let key = way_attr.length - 1; key >= 0; key--) {
			// 	let way_id = way_attr[key][0]
			// 	way_id = Number(way_id)
			// 	if (way_id >= 140 && way_id <= 145) {
			// 		table.remove(way_attr, key)
			// 	}
			// }
			let count = 1
			if (way_attr && way_attr.length > 0) {
				if (!_icon_list) {
					_icon_list = []
				}
				let hasShop = false
				let showGp = null
				for (let i = 0; i < way_attr.length; i++) {
					let id = way_attr[i][0]
					id = Number(id)
					//抢购商城在上面处理了
					if (id == 87) {
						continue
					}
					//不需要重复添加商城图标
					if (id == 60 || (id >= 140 && id <= 145)) {
						if (hasShop) {
							continue
						}
						hasShop = true
					}
					//创建图标流程
					let group = _icon_list[i]
					if (!group) {
						group = new Laya.Box
						this.icon_group.addChild(group)
						_icon_list[i] = group
						let icon = new Laya.Image
						group.addChild(icon)
						this.icon_scroller.width = count * 87
						count += 1
						this.icon_scroller.refresh()
						icon.skin = local_OpenFun.OpenIcon(way_attr[i][0])
						if (id == 53 && common_mgr.CheckFuncOpenState("DungeonEnterView", true)) {
							if ((_goodsVo.type_id == 16020001 && this.GetDunMaterialState(18)) || (_goodsVo.type_id == 17020001 && this.GetDunMaterialState(19))) {
								showGp = { "g": group, "attr": way_attr[i] }
							}
						}
					}
					group.visible = true
					group.includeInLayout = true
					Util.AddClickEvent(group, () => {
						local_OpenFun.OpenFunHandler(way_attr[i][0], way_attr[i][1], way_attr[i][2])
						this.Close()
					}
						, this, true)

				}
				//剧情模式，手指
				if (showGp) {
					//_figureIcon = UiFactory.CreateChild(this.form,UIType.EmptyObject,"figure_group")
					//let pos = UILocalToCanvasPoint(showGp.g.transform, co.TableXY(0, 1), co.TableXY(0, 1))
					//pos.x = pos.x + 50
					//pos.y = pos.y - 60
					////全局转本地还没处理
					//pos = this.globalToLocal(pos.x, pos.y)
					//SetLocalPosition(_figureIcon.transform,pos.x,pos.y,1)

					//let setp_cfg = [direction=8, text="通关材料副本，可获得培养材料"]
					//local_GlobalEventSystem:Fire(local_EventName.SHOW_FINGER, this, _figureIcon, this.layer_value, 0, 0, null, null, setp_cfg, true)
					//AddClickEvent(_figureIcon,() => {
					//let way_attr = showGp.attr
					//local_OpenFun.OpenFunHandler(way_attr[1], way_attr[2], way_attr[3])
					//this:Close()
					//}
					//, this, true)
				}
				//有特殊途径（抢购商城之类），且有折扣的，图标处打上折扣图片
				if (shop_icon && shop_discount) {
					let group = _icon_list[0]
					if (group) {
						let img = new Laya.Image
						group.addChild(img)
						ResManager.GetInstance().SetImageSprite(this, img,"common2",`sh_discount_${shop_discount / 10}`)
					}
				}
				//多余的图标隐藏
				for (let i = way_attr.length; i <= _icon_list.length; i++) {
					let icon = _icon_list[i]
					if (icon) {
						icon.visible = false
						icon.includeInLayout = false
					}
				}

				this.bg1.height = 660
				//this.bg2.height = 758
				this.display_obj.height = 660
			} else {
				//没有其他途径，下方区域隐藏
				this.other_group.visible = false
				this.bg1.height = 479
				//this.bg2.height = 558
				this.display_obj.height = 479
			}
		}

		this.GetDunMaterialState = (type?) => {
			let class_name = null
			if (18 == type) {
				class_name = "MountDungeon"
			} else if (19 == type) {
				class_name = "PartnerDungeon"
			}

			if (class_name && !common_mgr.CheckFuncOpenState(class_name, true)) {
				return
			}
			/*
			let dunData = BaseDungeonModel.GetInstance().GetDungeonInfo(type)
			if (dunData) {
				let data = dunData[1]
				if (data) {
					let role_lv = role_mgr.GetMainRoleVo().level
					let vip_card = vip_model.GetNobleCardState()
					let vip_flag = role_mgr.GetMainRoleVo().vip_flag
					//特殊处理 只要是vip>0 说明 肯定开过特权卡
					if (vip_flag >= 1) {
						vip_card = 99
					}
					let vip_default_count = vip_model.GetVipPrivilegeValue(
						local_BaseDungeonModel.MODULE_ID,
						local_BaseDungeonModel.VIP_COUNT_PARAMETER + local_Number(type),
						vip_card, vip_flag)
					//每日默认次数 = vip默认次数 + 副本默认次数
					let daily_default_count = local_Number(data.count_cond) + vip_default_count
					let total_count = data.add_count + data.vip_count + daily_default_count
					let vip_max = vip_model.GetVipPrivilegeValue(
						local_BaseDungeonModel.MODULE_ID,
						local_BaseDungeonModel.VIP_PARAMETER + local_Number(type),
						vip_card, vip_flag)
					if (role_lv >= local_Number(data.level)) {
						return total_count > data.daily_count
					}
				}
			}
			*/
		}
	}

	public Open(goodsVo?) {

		this.Local_Open(goodsVo)
	}

	bg1: Laya.Image
	_Image1: Laya.Image
	close_btn: Laya.Image
	increase_btn: Laya.Image
	reduce_btn: Laya.Image
	max_btn: Laya.Image
	diamond_group: Laya.Box
	_Image2: Laya.Image
	diamond_img: Laya.Image
	_Image3: Laya.Image
	diamond_label: Laya.Label
	binddiamond_group: Laya.Box
	_Image4: Laya.Image
	binddiamond_img: Laya.Image
	_Image5: Laya.Image
	binddiamond_label: Laya.Label
	num_touch: Laya.Image
	one_icon: Laya.Image
	total_icon: Laya.Image
	_Label1: Laya.Label
	total_label: Laya.Label
	cur_show_num: Laya.Label
	_Label2: Laya.Label
	_Label3: Laya.Label
	name_label: Laya.HTMLDivElement
	price_label: Laya.Label
	recharge_btn: Laya.Box
	_Image111: Laya.Image
	labelDisplay1: Laya.Label
	buy_btn: Laya.Box
	_Image11: Laya.Image
	labelDisplay: Laya.Label
	_Group1: Laya.Box
	_Image6: Laya.Image
	title_label0: Laya.Label
	item_group: Laya.Box
	other_group: Laya.Box
	_Image8: Laya.Image
	_Image9: Laya.Image
	_Label4: Laya.Label
	icon_scroller: Laya.Panel
	icon_group: Laya.HBox
	_Image10: Laya.Image
	public GetComponents() {
		[
			this.bg1,
			this._Image1,
			this.close_btn,
			this.increase_btn,
			this.reduce_btn,
			this.max_btn,
			this.diamond_group,
			this._Image2,
			this.diamond_img,
			this._Image3,
			this.diamond_label,
			this.binddiamond_group,
			this._Image4,
			this.binddiamond_img,
			this._Image5,
			this.binddiamond_label,
			this.num_touch,
			this.one_icon,
			this.total_icon,
			this._Label1,
			this.total_label,
			this.cur_show_num,
			this._Label2,
			this._Label3,
			this.name_label,
			this.price_label,
			this.recharge_btn,
			this._Image111,
			this.labelDisplay1,
			this.buy_btn,
			this._Image11,
			this.labelDisplay,
			this._Group1,
			this._Image6,
			this.title_label0,
			this.item_group,
			this.other_group,
			this._Image8,
			this._Image9,
			this._Label4,
			this.icon_scroller,
			this.icon_group,
			this._Image10,
		]
			= this.GetChildrenByNames([

				"bg1",
				"_Image1",
				"close_btn",
				"increase_btn",
				"reduce_btn",
				"max_btn",
				"diamond_group",
				"_Image2",
				"diamond_img",
				"_Image3",
				"diamond_label",
				"binddiamond_group",
				"_Image4",
				"binddiamond_img",
				"_Image5",
				"binddiamond_label",
				"num_touch",
				"one_icon",
				"total_icon",
				"_Label1",
				"total_label",
				"cur_show_num",
				"_Label2",
				"_Label3",
				"name_label",
				"price_label",
				"recharge_btn",
				"_Image111",
				"labelDisplay1",
				"buy_btn",
				"_Image11",
				"labelDisplay",
				"_Group1",
				"_Image6",
				"title_label0",
				"item_group",
				"other_group",
				"_Image8",
				"_Image9",
				"_Label4",
				"icon_scroller",
				"icon_group",
				"_Image10",
			])
	}
}
window["QuickBuyView"] = QuickBuyView
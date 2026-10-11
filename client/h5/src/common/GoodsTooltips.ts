import { RoleController } from "./../commonController/RoleController"
import { Alert, Alert_Type } from "../alert/Alert"
import { RoleManager } from "../commonModel/RoleManager"
import { SceneManager } from "../scene/SceneManager"
import { Message } from "../sysInfo/SysInfoController"
import { ColorUtil, Enum_ColorUtil_Dark, Enum_ColorUtil_Light } from "../util/ColorUtil"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { TimeUtil } from "../util/TimeUtil"
import { Util, Trim, LoadLuaConfigAB, HtmlColorTxt, GlobalTimerQuest, AddUnderLineAndClick, Split, SetHtmlCenter, RefGridLayout, RefBoxVLayout, AtlasUrl } from "../util/Util"
import { Vector2 } from "../util/Vector2"
import { BaseView1 } from "./BaseView1"
import { CommonManager } from "./CommonManager"
import { Config } from "./Config"
import { EventName } from "./EventName"
import { Enum_UILayer } from "./LayerManager"
import { OpenFun } from "./OpenFun"
import { ResManager } from "./ResManager"
import { WordManager } from "./WordManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { Mathf } from "../util/Mathf"
import { BagModel } from "../commonModel/BagModel"
import { table } from "./table"
import { BaseAwardItem } from "./BaseAwardItem"
import { RuneModel } from "../commonModel/RuneModel"
import { DsgtModel } from "../commonModel/DsgtModel"
import { MarketModel } from "../commonModel/MarketModel"
import { MarketEvent } from "../commonModel/MarketModel"
import { RuneTreasureModel, RuneTreasureEvent } from "../commonModel/RuneTreasureModel"
import { PartnerModel } from "../commonModel/PartnerModel"
import { MaskModel } from "../commonModel/MaskModel"
import { TreasureMapModel } from "../commonModel/TreasureMapModel"
import { FirstRechargeModel } from "../commonModel/FirstRechargeModel"
import { AutoBrushBaseView, EnumAutoBrushTabType } from "../autoBrush/AutoBrushBaseView"
import { LoopScrCon, LoopScrowViewMgr } from "./LoopScrowViewMgr"
import { ItemInfoItem } from "./ItemInfoItem"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"

export class GoodsTooltips extends BaseView1 {
	public root_wnd: Laya.Box;
	public bg: Laya.Image;
	public item_group: Laya.Box;
	public nameBG: Laya.Image;
	public goods_name: Laya.HTMLDivElement;
	public type_text: Laya.HTMLDivElement;
	public quantity_text: Laya.HTMLDivElement;
	public detail_scroller: Laya.Panel;
	public detail_group: Laya.VBox;
	public label1: Laya.Label;
	public intro: Laya.HTMLDivElement;
	public tips: Laya.HTMLDivElement;
	public line2: Laya.Box;
	public first_line0: Laya.Image;
	public label2: Laya.Label;
	public ways: Laya.HTMLDivElement;
	public sourceGp: Laya.VBox;
	public source_label: Laya.Label;
	public source_txt: Laya.HTMLDivElement;
	public btn_group: Laya.Box;
	public useBtn: Laya.Box;
	public sellBtn: Laya.Box;
	public okBtn: Laya.Box;
	public upShelfBtn: Laya.Box;
	public outShelfBtn: Laya.Box;
	public treasureReceiveBtn: Laya.Box;
	public takeoutBtn: Laya.Box;
	public depositBtn: Laya.Box;
	public putBtn: Laya.Box;
	public overdueText: Laya.HTMLDivElement;
	public _gp_cooling: Laya.VBox;
	public coolingTimeText: Laya.Label;
	public level_text: Laya.HTMLDivElement
	public _Group1: Laya.Box
	public _Image1: Laya.Image
	public level_text_value: Laya.HTMLDivElement

	SourceClickFunc
	setTimer
	CheckSecondView
	close_callback
	btn_num
	InitEvent
	use_local_view
	SetData
	removeTime
	LoadSuccess
	_Image2
	Local_SetTipsHeight
	// overdueText
	show_use_ways
	FormatGiftRewardStr
	Local_OpenCallback
	destroy_callback
	closeObj
	SetExpireTime
	first_line1
	onCoolingTime
	GetGiftBagRewardDesc
	PreSetHtml
	// ways
	setCoolingTime
	is_need_fresh
	_update_time
	changeTipsBorder

	private loop_mgr: LoopScrowViewMgr;

	// 配置
	private confGiftBox: any;
	// private confGift: any;

	public static BtnWidth = 142;
	public static BtnHeight = 52;

	public constructor() {
		super()
		this.base_file = "common"
		this.layout_file = "GoodsTooltips"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.use_background = true
		this.click_bg_toClose = true
		this.is_center = true
		this.is_delay_callback = false
		this.show_open_movie = true

		this.is_need_fresh = false
		let goods_model = GoodsModel.GetInstance()
		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName
		let market_model = MarketModel.GetInstance()
		let local_MarketEvent = MarketEvent
		let local_GoodsModel = GoodsModel
		//let composite_model = CompositeModel.GetInstance()
		//let local_CompositeEvent = CompositeEvent
		let rune_model = RuneModel.GetInstance()
		//let soul_model = SoulModel.GetInstance()
		let common_mgr = CommonManager.GetInstance()
		let local_TimeUtil = TimeUtil
		let local_Math = Mathf
		let local_Message = Message
		let bag_model = BagModel.GetInstance()
		let local_BagModel = BagModel
		// let out_line_model = OutLineModel.GetInstance()
		let local_OpenFun = OpenFun
		//let _is_from_bag = null
		let _type_id = null
		//let _over_time = null
		let _pos_x = null
		let _pos_y = null
		let _goods_vo = null
		let _goods_num = null
		let _btn_list = null
		let _goods_icon = null
		let _overdue_time = 0
		let _cooling_time = 0
		let _cooling_timer = null
		let _Cooling = false
		let gift_bag_info = null
		let show_gift_bag_basic_info = false
		let need_refresh = false
		let used_open_func = false
		let role_mgr = RoleManager.GetInstance()
		this.load_callback = () => {
			this.PreSetHtml()
			this.LoadSuccess()
			this.InitEvent()

			// if (PlatformMgr.GetInstance().IsEyouEnPlatform()) {
			// 	this.goods_name.size = 20
			// 	this.goods_name.lineSpacing = 0.6
			// 	SetSizeDelta(this.goods_name, 245, 40)
			// }
		}

		this.preload_server_config = {
			config_gift_box: false,
			// config_optional_gift: false
		}

		this.open_callback = () => {
			used_open_func = true
			this.OpenCallback()
		}

		this.close_callback = () => {
			if (_goods_vo && _goods_vo.deposite) {
				_goods_vo.deposite = null
			}

			if (this.loop_mgr) {
				this.loop_mgr.DeleteMe();
				this.loop_mgr = null;
			}
		}

		this.destroy_callback = () => {
			this.closeObj = null
			if (_goods_icon) {
				_goods_icon.DeleteMe()
				_goods_icon = null
			}
			if (this._update_time) {
				GlobalTimerQuest.CancelQuest(this._update_time)
				this._update_time = null
			}

			this.removeTime()

			this.source_txt.off(Laya.Event.LINK, this, this.SourceClickFunc)
			local_GlobalEventSystem.Fire(local_EventName.CLOSE_TIPS_VIEW)
			gift_bag_info = null
			show_gift_bag_basic_info = false
			need_refresh = false
			used_open_func = false
		}

		this.PreSetHtml = () => {
			this.goods_name.width = 384
			this.goods_name.style.bold = true
			this.goods_name.style.fontSize = 22
			this.goods_name.style.color = "#ffffff"
			this.goods_name.style.wordWrap = false

			this.type_text.style.fontSize = 22
			// this.type_text.style.color = "#5a1c20"
			this.type_text.style.color = "#ffffff"

			this.quantity_text.style.fontSize = 22
			// this.quantity_text.style.color = "#5a1c20"
			this.quantity_text.style.color = "#ffffff"

			this.level_text.style.fontSize = 22
			// this.level_text.style.color = "#5a1c20"
			this.level_text.style.color = "#ffffff"

			this.level_text_value.style.fontSize = 22
			this.level_text_value.style.color = "#ffffff"

			this.intro.width = 322
			this.intro.style.fontSize = 20
			this.intro.style.color = "#663915"
			this.intro.style.align = "left"
			this.intro.style.wordWrap = true
			this.intro.style.lineHeight = 25
			this.intro.style.leading = 4

			this.tips.width = 322
			this.tips.style.fontSize = 20
			this.tips.style.color = "#60aeff"
			this.tips.style.align = "left"
			this.tips.style.wordWrap = true
			this.tips.style.leading = 2

			this.ways.width = 322
			this.ways.style.fontSize = 20
			this.ways.style.color = "#5a1c20"
			this.ways.style.align = "left"
			this.ways.style.wordWrap = true
			this.ways.style.leading = 2

			this.source_txt.width = 253
			this.source_txt.style.fontSize = 20
			this.source_txt.style.color = "#4a3a32"
			this.source_txt.style.align = "left"
			// this.source_txt.style.leading = 3

			this.overdueText.width = 340
			this.overdueText.style.fontSize = 20
			this.overdueText.style.color = "#ff4f50"
			this.overdueText.style.align = "center"
		}

		this.LoadSuccess = () => {
			this.btn_group.visible = false
			this.detail_scroller.vScrollBarSkin = ""
			this.confGiftBox = ResManager.GetInstance().GetGameConfigFromCache(this, "config_gift_box", false)
			// this.confGift = ResManager.GetInstance().GetGameConfigFromCache(this, "config_optional_gift", false);
			//this.detail_scroller.verticalScrollBar.autoVisibility = false
			//this.detail_scroller.verticalScrollBar.visible = false
			//this.root_wnd.visible = false
			if (this.is_need_fresh) {
				this.SetData(_type_id, _pos_x, _pos_y, _goods_vo, _goods_num, _overdue_time)
				this.is_need_fresh = false
			}
		}

		this.InitEvent = () => {
			let close_fun = () => {
				this.Close()
			}
			Util.AddClickEvent(this.okBtn, close_fun, this, true)

			let useBtn_fun = () => {
				if (_Cooling) {
					local_Message.show("冷却中")
					return
				}
				this.CheckSecondView()
				this.Close()
			}
			Util.AddClickEvent(this.useBtn, useBtn_fun, this, true)

			let sellBtn_fun = () => {
				if (_goods_vo) {
					local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "SellView", _goods_vo)
				}
				this.Close()
			}
			Util.AddClickEvent(this.sellBtn, sellBtn_fun, this, true)

			let upShelfBtn_fun = () => {
				if (!_goods_vo) {
					return
				}
				let goods_vo = _goods_vo
				if (!goods_model.GetGoodsVoByGoodsId(goods_vo.goods_id)) {
					Message.show("物品不存在")
					market_model.Fire(MarketEvent.NEED_UPDATE_BAG)
				} else {
					market_model.Fire(local_MarketEvent.OPEN_VIEW, "MarketSellCtrlView", _goods_vo)
				}
				this.Close()
			}

			Util.AddClickEvent(this.upShelfBtn, upShelfBtn_fun, this, true)
			let outShelfBtn_fun = () => {
				if (!_goods_vo) {
					return
				}
				let goods_vo = _goods_vo
				market_model.Fire(local_MarketEvent.REQUEST_PROTO, 15108, "clii", 1, goods_vo.id, goods_vo.type_id, goods_vo.goods_num)
				this.Close()
			}

			Util.AddClickEvent(this.outShelfBtn, outShelfBtn_fun, this, true)
			let treasureReceive_fun = () => {
				if (!_goods_vo) {
					return
				}
				if (_goods_vo.funcId == 182) {
					// BabyModel.GetInstance().Fire(BabyEvent.ADD_IMPRINT_ITEM, _goods_vo.pos, _goods_vo)
				} else {
					let basic = goods_model.GetGoodsBasicByTypeId(_type_id)
					if (!basic) {
						return
					}
					let goods_vo = _goods_vo
					RuneTreasureModel.GetInstance().Fire(RuneTreasureEvent.RUNE_TREASURE_REQUEST_PROTO, 41605, "lhh", goods_vo.goods_id, local_GoodsModel.GOODS_POS_TYPE.treasurebag, basic.bag_location)
				}
				this.Close()
			}

			Util.AddClickEvent(this.treasureReceiveBtn, treasureReceive_fun, this, true)
			let depositFunc = () => {
				if (!_goods_vo) {
					return
				}
				goods_model.Fire(local_GoodsModel.MOVE_GOODS_POS, _goods_vo.goods_id, local_GoodsModel.GOODS_POS_TYPE.bag, local_GoodsModel.GOODS_POS_TYPE.warehouse)
				this.Close()
			}

			Util.AddClickEvent(this.depositBtn, depositFunc, this, true)
			let takeoutFunc = () => {
				if (!_goods_vo) {
					return
				}
				// if (_goods_vo.isSoul) {
				// 	composite_model.Fire(local_CompositeEvent.TAKE_OUT_SOUL_GOODS, _goods_vo.goods_id, _goods_vo.pos)
				// } else {
				goods_model.Fire(local_GoodsModel.MOVE_GOODS_POS, _goods_vo.goods_id, local_GoodsModel.GOODS_POS_TYPE.warehouse, local_GoodsModel.GOODS_POS_TYPE.bag)
				// }
				this.Close()
			}

			Util.AddClickEvent(this.takeoutBtn, takeoutFunc, this, true)
			let putFunc = () => {
				// composite_model.Fire(local_CompositeEvent.SELECT_SOUL_GOODS, _goods_vo)
				// composite_model.Fire(local_CompositeEvent.OPEN_VIEW, "SoulSelectMatView", _type_id)
				this.Close()
			}

			Util.AddClickEvent(this.putBtn, putFunc, this, true)

			this.source_txt.on(Laya.Event.LINK, this, this.SourceClickFunc)

		}

		this.SetData = async (type_id?, x?, y?, goods_vo?, goods_num?, overdue_time?) => {
			if (!this.is_loaded) {
				_type_id = type_id
				_goods_vo = goods_vo
				_pos_x = x
				_pos_y = y
				_goods_num = Number(goods_num)
				_overdue_time = overdue_time || 0
				this.is_need_fresh = true
				return
			}

			if (x != null && y != null) {
				this.is_center = false
			} else {
				this.is_center = true
			}

			let basic = goods_model.GetGoodsBasicByTypeId(_type_id)
			if (!basic) {
				return
			}

			show_gift_bag_basic_info = false
			if (basic.type == GoodsModel.GIFT_TYPE) {
				let cfg = await ResManager.GetInstance().LoadGameConfig(this, "config_gift_box", false)
				let gift_cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_gift_box.name, _type_id, false, cfg)
				if (gift_cfg && gift_cfg.show_dynamics > 0) {
					let call_fun = (scmd?) => {
						if ((_type_id && scmd) && _type_id == scmd.type_id) {
							if (!this.use_delete_method) {
								gift_bag_info = scmd
								need_refresh = true
								if (used_open_func) {
									this.Local_OpenCallback()
								}
							}
						}
					}
					let goods_id = (_goods_vo && (_goods_vo.goods_id) || (0))
					goods_model.GetGiftBagDynamic(goods_id, _type_id, call_fun)
				} else {
					need_refresh = true
					show_gift_bag_basic_info = true
					if (used_open_func && !this.use_delete_method) {
						this.Local_OpenCallback()
					}
				}
			} else {
				need_refresh = true
			}
		}

		this.changeTipsBorder = (goods_basic)=> {
			if(goods_basic){
				this.nameBG.skin = AtlasUrl("common4", "ui_tips_pz_" + goods_basic.color)
			}
		}

		this.Local_OpenCallback = async () => {
			if ((!this.is_loaded || !_type_id) || !need_refresh) {
				return
			} else {
				this.rewardsList.height = 0
				let basic = goods_model.GetGoodsBasicByTypeId(_type_id);
				let confGiftBox = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_gift_box.name, basic.type_id, false, this.confGiftBox);
				let isList: boolean = Boolean(confGiftBox?.show_reward);
				this.rewardsList.visible = isList;
				if(isList){
					this.rewardsList.height = 90
				}else
				{
					this.rewardsList.height = 0.1
				}
				// this.rewardsList.height = isList ? 90 : 0;
				//this.root_wnd.visible = true
				if (!basic) {
					return
				}
				if (_pos_x != null && _pos_y != null) {
					this.display_obj.x = _pos_x
					this.display_obj.y = _pos_y
				}
				if (!_goods_icon) {
					_goods_icon = new BaseAwardItem(this.item_group)
					_goods_icon.Load()
					_goods_icon.SetItemSize(84, 84)
					_goods_icon.ChangeCountVisible(false)
				}
				_goods_icon.SetData(basic.type_id, 1)
				_goods_icon.SetShowTips(false)
				let showdym
				if (basic.type == 34) {
					let cfg = await ResManager.GetInstance().LoadGameConfig(this, "config_gift_box", false)
					let gift_cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_gift_box.name, _type_id, false, cfg)
					if (gift_cfg && gift_cfg.show_dynamics == 1) {
						showdym = true
					}
				}
				let color_str = ColorUtil.GetColorDark(basic.color)
				// this.nameBG.source = "common_json.ts_title_bg" + basic.color + "_png"
				// this.goods_name.innerHTML = Util.StrToHTML("<font color=" + color_str + ">" + basic.goods_name + "</font>")
				this.goods_name.innerHTML = Util.StrToHTML(basic.goods_name)
				// SetHtmlCenter(this.goods_name, { x: 0, w: 384 }, { y: 20, h: 22 })
				this.goods_name.x = 30
				this.goods_name.y = 10
				let style = WordManager.GetGoodsStyle(Number(basic.type))
				this.type_text.innerHTML = Util.StrToHTML("类型:&nbsp;<font color='#ffe222'>"+ style + "</font>")
				this.type_text.x = 30
				let num = _goods_vo && (_goods_vo.goods_num && _goods_vo.goods_num || 1) || 1
				if (_goods_num && _goods_num > 0) {
					num = _goods_num
				}
				this.quantity_text.innerHTML = Util.StrToHTML("数量:&nbsp;<font color='#ffe222'>" + " " + num + "</font>")
				this.quantity_text.width = 240
				this.quantity_text.x = 30
				if (_goods_vo?.level) {
					this.type_text.y = 55
					this.quantity_text.y = 90
					let color = ColorUtil.GetColorLight(basic.color)
					if(RoleManager.GetInstance().GetMainRoleLevel() < _goods_vo.level){
						this.level_text_value.style.stroke = 2
						this.level_text_value.style.strokeColor = "#ffffff"
					}
					this.level_text.innerHTML = Util.StrToHTML(`等级需求:`)
					this.level_text_value.innerHTML = Util.StrToHTML(`<font color=${RoleManager.GetInstance().GetMainRoleLevel() < _goods_vo.level ?
						Enum_ColorUtil_Light.RED : "'#ffe222'"}>${_goods_vo.level}</font>`)
					this.level_text.x = 30
					this.level_text.y = 125
					this.level_text_value.x = 100
					this.level_text_value.y = 1
				} else {
					this.type_text.y = 60
					this.quantity_text.y = 110
					this.level_text.innerHTML = ''
					this.level_text_value.innerHTML = ''
				}
				let scroller_height = -43
				if (basic.type == 26 && basic.subtype != 99) {
					this.label1.text = "基础属性"
					let level = (_goods_vo && (_goods_vo.level) || (1))
					let goods_id = (_goods_vo && (_goods_vo.goods_id) || (null))
					let run_pro = null
					if (_goods_vo && _goods_vo.comPre) {
						run_pro = rune_model.GetTipsAwakeStr(basic.subtype, basic.color, _goods_vo.awake_list)
					} else {
						run_pro = rune_model.GetTipShowProBySubtype(basic.subtype, basic.color, goods_id)
					}
					this.intro.innerHTML = Util.StrToHTML(run_pro)
					scroller_height = scroller_height - this.intro.height
					let config_rune_all_show = await ResManager.GetInstance().LoadGameConfig(this, "config_rune_all_show", false)
					let unlock = rune_model.GetUnLockStr(basic.type_id, config_rune_all_show)
					let show_txt = Trim(unlock) != ""
					this.tips.visible = show_txt
					this.tips.innerHTML = Util.StrToHTML(unlock)
					if (show_txt) {
						scroller_height = scroller_height - this.tips.height
					}
				} else if (basic.type == 28 && basic.subtype != 99) {
					// this.label1.text = "基础属性"
					// let attr_list = []
					// let str = ""
					// let soul_attr_num_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_soul_attr_num", false)
					// attr_list = soul_model.GetSoulAttr(basic.subtype, 1, basic.color, soul_attr_num_cfg)
					// if (_goods_vo) {
					// 	let config_soul_awake = ResManager.GetInstance().GetGameConfigFromCache(this, "config_soul_awake", false)
					// 	str = soul_model.GetAttrStr(attr_list, Enum_ColorUtil_Dark.GREEN, basic.color, _goods_vo.awake_list, config_soul_awake)
					// } else {
					// 	str = soul_model.GetAttrStr(attr_list, Enum_ColorUtil_Dark.GREEN)
					// }
					// this.intro.innerHTML = Util.StrToHTML(str)
					// this.tips.visible = false
					// scroller_height = scroller_height - this.intro.height
				} else if (basic.type == GoodsModel.GIFT_TYPE && !show_gift_bag_basic_info) {//

					if (gift_bag_info) {
						let str = this.GetGiftBagRewardDesc(gift_bag_info.type_id, gift_bag_info.gift_level, isList);
						this.intro.innerHTML = Util.StrToHTML(str)
						this.tips.visible = false
						scroller_height = scroller_height - this.intro.height
					}

				} else if (basic.type == 34 && showdym) {
					let desStr
					// let opt_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_optional_gift", false)
					// let cfg = opt_cfg[basic.type_id + "@" + RoleManager.GetInstance().GetMainRoleCareer()] || opt_cfg[basic.type_id + "@0"]
					let cfg = goods_model.getOpGiftVoByTypeIdAndCareer(basic.type_id, 0)
					if(!cfg){
						cfg = goods_model.getOpGiftVoByTypeIdAndCareer(basic.type_id, RoleManager.GetInstance().GetMainRoleCareer())
					}
					if (cfg) {
						desStr = "打开可选以下奖励一个：";
						if (!isList) {
							let rewardList = JSON.parse(cfg.list)
							for (let i in rewardList) {
								let v = rewardList[i]
								let giftgoodsBasic = goods_model.GetGoodsBasicByTypeId(v[1])
								desStr = desStr + "<br>" + HtmlColorTxt(Trim(giftgoodsBasic.goods_name) + "*" + v[2], ColorUtil.GetColorLight(giftgoodsBasic.color))
							}
						}
					} else {
						desStr = Trim(basic.intro)
					}
					this.intro.innerHTML = Util.StrToHTML(desStr)
				}else if(basic.type == 59 && basic.subtype == 5){
					let headStr = ""
					let headAttr =  ErlangParser.GetInstance().Parse(basic.base_attrlist)
					if (headAttr) {
						for (let idx = 0; idx < headAttr.length; idx++) {
							var val = headAttr[idx]
							if (idx != headAttr.length - 1) {
								headStr = headStr + WordManager.GetProperties(val[0]) + ":" + Util.HtmlColorTxt(WordManager.ConvertToPercentValue(val[0], val[1]), "'#0a953e'") + "<br/>"
							} else {
								headStr = headStr + WordManager.GetProperties(val[0]) + ":" + Util.HtmlColorTxt(val[1], "'#0a953e'")
							}
						}
					}
					let msg = Trim(basic.intro) != "" && Trim(basic.intro) || ""
					this.intro.innerHTML = Util.StrToHTML(msg + "<br/>" +headStr)
				} else {
					if (basic.type == 14 && (basic.subtype == 1 || basic.subtype == 2)) {
						this.label1.text = "镶嵌属性"
					}
					this.intro.innerHTML = Util.StrToHTML(Trim(basic.intro) != "" && Trim(basic.intro) || "")
					this.tips.visible = false
					// this.tips.includeInLayout = false
					scroller_height = scroller_height - this.intro.height
				}
				this.type_text.width = 240//把宽设回来
				this.intro.width = 322//把宽设回来
				this.tips.width = 322//把宽设回来
				this.tips.height = this.tips.visible ? 0 : -15

				let show_source = ErlangParser.GetInstance().Parse(Trim(basic.getway_url))
				let ShowSource = show_source.length > 0
				let Str = ""
				if (basic.type_id == 38160001 && ShowSource) {
					let list = []
					for (let key in show_source) {
						let v = show_source[key]
						if (FirstRechargeModel.GetInstance().IsNoFirstRecharge() && Number(v[0]) == 70) {
							table.insert(list, v)
							break
						}
						if (!FirstRechargeModel.GetInstance().IsNoFirstRecharge() && Number(v[0]) == 72 && role_mgr.GetMainRoleLevel() >= 90) {
							table.insert(list, v)
							break
						}
					}
					show_source = list
					this.source_label.visible = list && Util.TableSize(list) > 0
				}
				let ClientSourceCfg = ResManager.GetInstance().GetGameConfigFromCache(this, "GoodsSourceConfig", true)
				let open_day = ServerTimeModel.GetInstance().GetOpenServerDay()
				if (ClientSourceCfg) {
					for (let _tmpi in show_source) {
						let vo = show_source[_tmpi]
						let curCfg = ClientSourceCfg[Number(vo[0])]
						if (curCfg) {
							let hasOpen = vo[1] != "0" && common_mgr.CheckFuncOpenState(curCfg.view, true)
							let color = hasOpen && "#d15e00" || "#8b8b8a"
							if (hasOpen) {
								if (open_day <= 7 && curCfg.id == 111) {
									Str = Str + "<a href='" + vo[0] + "@" + vo[1] + "'><font color='" + color + "'>" + curCfg.name_2 + "</font></a>"
								} else {
									Str = Str + "<a href='" + vo[0] + "@" + vo[1] + "'><font color='" + color + "'>" + curCfg.name + "</font></a>"
								}
							} else {
								if (open_day <= 7 && curCfg.id == 111) {
									Str = Str + "<a href='" + vo[0] + "@" + vo[1] + "'><font color='" + color + "'>" + curCfg.name_2 + "</font></a>"
								} else {
									Str = Str + "<a href='" + vo[0] + "@" + vo[1] + "'><font color='" + color + "'>" + curCfg.name + "</font></a>"
								}
							}
							if (Number(_tmpi) != show_source.length - 1) {
								Str = Str + "&nbsp;&nbsp;"
							}

						}
					}
					this.sourceGp.visible = ShowSource
					this.source_txt.innerHTML = Util.StrToHTML(Str)
					this.source_txt.width = 253
					this.sourceGp.size(310, (ShowSource ? (70 + this.source_txt.contextHeight) : 0))
				} else {
					this.sourceGp.visible = false
				}
				let show_use_ways = Trim(basic.getway) != ""
				this.show_use_ways = show_use_ways
				this.line2.visible = show_use_ways
				this.line2.height = show_use_ways ? 0 : -15
				// this.line2.includeInLayout = show_use_ways
				this.ways.visible = show_use_ways
				this.ways.height = show_use_ways ? 0 : -15
				// this.ways.includeInLayout = show_use_ways
				this.label2.visible = show_use_ways
				// this.label2.includeInLayout = show_use_ways
				this.ways.innerHTML = Util.StrToHTML(show_use_ways && (`${basic.getway}\n `) || "")
				this.ways.width = 322
				this.btn_num = 0
				_btn_list = []
				let show_ok = true
				if (_goods_vo) {
					if (((((basic.use == 0 || _goods_vo.isTreasure) || _goods_vo.takeout) || _goods_vo.deposite) || _goods_vo.put) || _goods_vo.isSoul) {
						//this.useBtn.visible = false
						this.useBtn.visible = false
						// this.useBtn.includeInLayout = false
						//GameObject.DestroyImmediate(this.useBtn)
					} else {
						this.btn_num = this.btn_num + 1
						show_ok = false
					}
					if (((((((((basic.bind == 1 || _goods_vo.bind == 1) || basic.trade == 0) || _goods_vo.sell_type) || _goods_vo.isTreasure) || basic.if_custom_price == "0" && basic.trade_price == "[]") || _goods_vo.deposite) || _goods_vo.takeout) || _goods_vo.put) || _goods_vo.isSoul) {
						//GameObject.DestroyImmediate(this.upShelfBtn)
						this.upShelfBtn.visible = false
						// this.upShelfBtn.includeInLayout = false
					} else {
						this.btn_num = this.btn_num + 1
						show_ok = false
					}
					if (!_goods_vo.sell_type) {
						//this.outShelfBtn.visible = false
						//GameObject.DestroyImmediate(this.outShelfBtn)
						this.outShelfBtn.visible = false
						// this.outShelfBtn.includeInLayout = false
					} else {
						this.btn_num = this.btn_num + 1
						show_ok = false
					}
					if (((((((basic.sell == 0 || _goods_vo.sell_type) || basic.type == 38 && basic.subtype == 26) || _goods_vo.takeout) || _goods_vo.deposite) || _goods_vo.put) || _goods_vo.isSoul) || _goods_vo.isMarket) {
						//this.sellBtn.visible = false
						//GameObject.DestroyImmediate(this.sellBtn)
						this.sellBtn.visible = false
						// this.sellBtn.includeInLayout = false
					} else {
						this.btn_num = this.btn_num + 1
						show_ok = false
					}
					if (!_goods_vo.isTreasure) {
						//this.treasureReceiveBtn.visible = false
						//GameObject.DestroyImmediate(this.treasureReceiveBtn)
						this.treasureReceiveBtn.visible = false
						// this.treasureReceiveBtn.includeInLayout = false
					} else {
						this.btn_num = this.btn_num + 1
						show_ok = false
					}
					if (!_goods_vo.deposite) {
						//this.depositBtn.visible = false
						//GameObject.DestroyImmediate(this.depositBtn)
						this.depositBtn.visible = false
						// this.depositBtn.includeInLayout = false
					} else {
						this.btn_num = this.btn_num + 1
						show_ok = false
					}
					if (!_goods_vo.takeout && !_goods_vo.isSoul) {
						//this.takeoutBtn.visible = false
						//GameObject.DestroyImmediate(this.takeoutBtn)
						this.takeoutBtn.visible = false
						// this.takeoutBtn.includeInLayout = false
					} else {
						this.btn_num = this.btn_num + 1
						show_ok = false
					}
					if (!_goods_vo.put) {
						//this.putBtn.visible = false
						//GameObject.DestroyImmediate(this.putBtn)
						this.putBtn.visible = false
						// this.putBtn.includeInLayout = false
					} else {
						this.btn_num = this.btn_num + 1
						show_ok = false
					}
				} else {
					this.sellBtn.visible = false
					this.useBtn.visible = false
					this.upShelfBtn.visible = false
					this.outShelfBtn.visible = false
					this.treasureReceiveBtn.visible = false
					this.depositBtn.visible = false
					this.takeoutBtn.visible = false
					this.putBtn.visible = false
					// this.sellBtn.includeInLayout = false
					// this.useBtn.includeInLayout = false
					// this.upShelfBtn.includeInLayout = false
					// this.outShelfBtn.includeInLayout = false
					// this.treasureReceiveBtn.includeInLayout = false
					// this.depositBtn.includeInLayout = false
					// this.takeoutBtn.includeInLayout = false
					// this.putBtn.includeInLayout = false
				}
				//this.okBtn.visible =  (((((((this.sellBtn.visible == false && this.useBtn.visible == false  && ! this.depositBtn.visible) && ! this.takeoutBtn.visible) && ! this.upShelfBtn.visible) && ! this.outShelfBtn.visible) && ! this.treasureReceiveBtn.visible) && ! this.putBtn.visible && ( true ) || ( false ) ) )
				this.okBtn.visible = show_ok
				// this.okBtn.includeInLayout = show_ok
				if (show_ok) {
					this.btn_num = this.btn_num + 1
				}
				//if (this.okBtn.visible == false ) {
				//GameObject.DestroyImmediate(this.okBtn)
				//}



				let reards: any[] = [];
				switch (basic.type) {
					case 33: // 勾玉礼包
					case 32: // 随机
						let cond_level = GoodsModel.GetInstance().GetGiftBagCondLevel(basic.type_id, confGiftBox)
						let gift_cfg = GoodsModel.GetInstance().GetGiftBagCfg(basic.type_id, cond_level);
						let bool: boolean = JSON.parse(gift_cfg.rand_gifts).length > 0;
						let all = bool ? JSON.parse(gift_cfg.rand_gifts) : JSON.parse(gift_cfg.fixed_gifts);
						reards = all;
						break;
					case 34: // 自选
						let cur_cfg = GoodsModel.GetInstance().getOpGiftVoByTypeIdAndCareer(basic.type_id, 0);
						if (!cur_cfg) {
							cur_cfg = GoodsModel.GetInstance().getOpGiftVoByTypeIdAndCareer(basic.type_id, RoleManager.GetInstance().GetMainRoleCareer());
							if (!cur_cfg) {
								return
							}
						}
						let reards1 = JSON.parse(cur_cfg.list);
						reards = reards1;
						break;
					default:
						break;
				}

				if (isList) {
					// 渲染奖励
					if (!this.loop_mgr) {
						this.loop_mgr = new LoopScrowViewMgr();
						this.loop_mgr.SetData(
							this.rewardsList,
							ItemInfoItem,
							reards,
							LoopScrCon.Horizontal
						);
					} else {
						this.loop_mgr.replaceAll(reards);
					}

				}
				this.changeTipsBorder(basic) //增加一个tips的边框
			}


			this.SetExpireTime()
			this.setCoolingTime()
			this.SetTipsHeight()

			RefGridLayout(this.btn_group, {
				column: 2,
				h_gap: 6,
				v_gap: 0,
				item_w: 142,
				item_h: 52,
				frist_item_space: 25
			})
			this.btn_group.visible = true
			// UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(this.detail_group)
			//lua_resM:SetOutsideImageSprite(this,this._Image2,"client/asset/game/common2/uity_016e.png")
			//lua_resM:SetOutsideImageSprite(this,this.first_line0,"client/asset/game/common2/uity_016e.png")
			//lua_resM:SetOutsideImageSprite(this,this.first_line1,"client/asset/game/common2/uity_016e.png")
			this.CallLater(() => {
				//布局排列
				RefBoxVLayout(this.detail_group, this.detail_group.space, true);
			})
		}



		//expire time项0:永久有效1:持续时间段有效(从获得物品开始计算)2:至固定时间戳有效3:持续天数有效(以当天4点为逻辑日起始点)4:开服天数有效(以开服当天4点为起始点)  5:当天晚上12点失效
		this.SetExpireTime = () => {

			if (this._update_time) {
				GlobalTimerQuest.CancelQuest(this._update_time)
				this._update_time = null
			}


			let basic = goods_model.GetGoodsBasicByTypeId(_type_id)
			if (!basic) {
				return
			}


			let show = false
			if ((_goods_vo && (_goods_vo.expire_time && _goods_vo.expire_time > 0) || _overdue_time > 0) || (basic.expire_time && basic.expire_time != 0)) {
				show = true
				let time_desc = ""
				if (_goods_vo && _goods_vo.expire_time) {
					if (local_TimeUtil.getServerTime() > _goods_vo.expire_time) {
						time_desc = "已过期"
					} else {
						if (basic.expire_type == 5 && basic.expire_time == "1") {
							this.overdueText.visible = show
							let UpdateTime = () => {
								let left_sce = _goods_vo.expire_time - local_TimeUtil.getServerTime()
								time_desc = "<font color='#639c12'>限时：" +
									local_TimeUtil.timeConvert(left_sce, "dd-hh-mm-ss") + "</font>"

								this.overdueText.innerHTML = Util.StrToHTML(time_desc)
								SetHtmlCenter(this.overdueText, { x: 0, w: 384 })
							}
							if (!this._update_time) {
								this._update_time = GlobalTimerQuest.AddPeriodQuest(UpdateTime, 1, -1)

								UpdateTime()
							}
							return
						} else {
							time_desc = "<font color='#639c12'>过期时间：" + local_TimeUtil.timeConversion(_goods_vo.expire_time, "yyyy/mm/dd hh:MM:ss") + "</font>"
						}
					}
				} else if (_overdue_time != 0) {
					time_desc = "限时：" + local_TimeUtil.timeConversion(_overdue_time, "yyyy/mm/dd hh:MM:ss")
				} else if (basic.expire_time != 0) {

					//限时夺宝币特殊处理
					if(basic.type_id==CustomActivityModel.LUC_TREA_LIMIT){
						time_desc = "限时：当天晚上24时过期"
					}else{
						if (String(basic.expire_time).indexOf("-") >= 0) {
							time_desc = "限时：<font color='#639c12'>" + basic.expire_time + "</font>"
						} else {
							let time = basic.expire_time
							if (basic.expire_type == 4) {
								time_desc = "限时：开服" + time + "天内"
							}else if (basic.expire_type == 5 ) {
								time_desc = "限时：" + local_TimeUtil.convertTimeColor(Number(time)*86400, "yyyy/mm/dd hh:MM:ss")
							} else {
								if (time > 1200000000) {
									time_desc = "过期时间：" + local_TimeUtil.timeConversion(time, "yyyy/mm/dd hh:MM:ss")
								} else {
									time_desc = "限时：" + local_TimeUtil.convertTimeColor(time, "yyyy/mm/dd hh:MM:ss")
								}
							}
						}
					}

					
				}
				this.overdueText.innerHTML = Util.StrToHTML(time_desc)
				SetHtmlCenter(this.overdueText, { x: 0, w: 384 })
			}
			this.overdueText.visible = show
		}

		this.setCoolingTime = () => {
			let basic = goods_model.GetGoodsBasicByTypeId(_type_id)
			if (!basic) {
				return
			}
			let show = false
			this.coolingTimeText.text = ""
			if (_goods_vo && _goods_vo.type == 35) {
				let callback = (data?) => {
					if (this.use_delete_method) {
						return
					}
					this.setTimer()
					_cooling_time = data.freeze_endtime
					_Cooling = data.freeze_endtime > local_TimeUtil.getServerTime()
					show = _Cooling
					this.coolingTimeText.text = (_Cooling && ("冷却时间：") || (""))
					this.quantity_text.innerHTML = Util.StrToHTML("可使用次数：&nbsp;<font color='#4a3a32'>" + (data.total_count - data.use_count) + "/" + data.total_count + "</font>")
					this.quantity_text.width = 240
					this.onCoolingTime()
					this.SetTipsHeight()
				}

				goods_model.getGoodCoolingData(_goods_vo.goods_id, callback)
			} else if ((_goods_vo && _goods_vo.type == 38) && _goods_vo.subtype == 39) {
				_Cooling = role_mgr.change_career_time && (role_mgr.change_career_time > local_TimeUtil.getServerTime()) || false
				show = _Cooling
				if (_Cooling) {
					this.setTimer()
					_cooling_time = role_mgr.change_career_time
					let time = _cooling_time - local_TimeUtil.getServerTime()
					this.coolingTimeText.text = (_Cooling && ("冷却时间：" + local_TimeUtil.convertTime(time)) || (""))
				}
			}
			this._gp_cooling.visible = show
		}

		this.setTimer = () => {
			if (!_cooling_timer) {
				_cooling_timer = GlobalTimerQuest.AddPeriodQuest(() => {
					this.onCoolingTime()
				}, 1, -1)
				//local_egret. new Timer(1000, 0)
				//_cooling_timer:addEventListener(local_egret.TimerEvent.TIMER, this.onCoolingTime, this)
			}
			//if (! _cooling_timer.running ) {
			//_cooling_timer:start()
			//}
		}

		this.onCoolingTime = () => {
			if (!this.use_delete_method) {
				let time = _cooling_time - local_TimeUtil.getServerTime()
				this.coolingTimeText.text = "冷却时间：" + local_TimeUtil.convertTime(time)
				if (time <= 0) {
					this.removeTime(true)
				}
			}
		}

		this.removeTime = (reSet?) => {
			if (reSet == null) {
				reSet = false
			}
			if (_cooling_timer) {
				//_cooling_timer:removeEventListener(local_egret.TimerEvent.TIMER, this.onCoolingTime, this)
				GlobalTimerQuest.CancelQuest(_cooling_timer)
				_cooling_timer = null
				this.coolingTimeText.text = ""
				this._gp_cooling.visible = false
				_cooling_time = 0
				_Cooling = false
			}
			if (reSet) {
				this.SetTipsHeight()
			}
		}

		this.Local_SetTipsHeight = () => {
			let overdueTextHeight = 0
			let coolingTimeTextHeight = 0

			if (this.overdueText.visible) {
				overdueTextHeight = this.overdueText.contextHeight
			}
			if (this._gp_cooling.visible) {
				coolingTimeTextHeight = (this.coolingTimeText.height > 0.1 && (this.coolingTimeText.height + 2) || (0.1))
			}
			let textSpacing = (overdueTextHeight > 0 || coolingTimeTextHeight > 0.1) ? 10 : 0.1

			let line_num = local_Math.Ceil(this.btn_num / 2)

			this.btn_group.visible = false
			//66 每个按钮占的位置 20 距离底部间隔
			let btn_group_height = line_num * 66 + 20
			this.btn_group.height = btn_group_height
			//35 tips高度
			let tips_hei = this.tips.visible ? 35 : 0.1

			let content_hei = 45 + this.intro.contextHeight + tips_hei + (this.show_use_ways ? (60 + this.ways.contextHeight) : 0.1)//32是因为tips虽然隐藏，但是laya原生VBox仍然会去计算这个东西
			let source_gp_hei = 0.1
			if (this.sourceGp.visible) {
				source_gp_hei = 30 + 15 + Number(this.source_txt.contextHeight)
				this.sourceGp.height = source_gp_hei
			}

			let all_height = 166 + content_hei + overdueTextHeight + coolingTimeTextHeight + btn_group_height + source_gp_hei + textSpacing + this.rewardsList.height;
			let max = all_height
			if (all_height > 740) {
				max = 680
			} else if (all_height < 450) {
				max = 450
			}

			this.bg.height = max
			this.display_obj.height = max
			
			let new_scroll_height = max - btn_group_height - overdueTextHeight - coolingTimeTextHeight - textSpacing - 166 - source_gp_hei;
			let max_height = 400
			let height = 0.1
			if(new_scroll_height > max_height){
				height = max_height
			}else {
				height = new_scroll_height
			}
			// this.detail_scroller.height = new_scroll_height
			this.detail_scroller.height = height
			this.detail_group.height = content_hei
			this.detail_group.event("resize")
			this.btn_group.y = (max - btn_group_height)


			let sourceY = 0
			if (this.overdueText.visible) {
				this.overdueText.y = this.btn_group.y - overdueTextHeight - textSpacing
				sourceY = overdueTextHeight
			}
			if (this._gp_cooling.visible) {
				this._gp_cooling.y = this.btn_group.y - overdueTextHeight - coolingTimeTextHeight - textSpacing - 8
				sourceY = overdueTextHeight + coolingTimeTextHeight + textSpacing
			}
	
			this.sourceGp.y = this.btn_group.y - source_gp_hei - sourceY + 8
		}

		this.CheckSecondView = () => {
			if (_goods_vo == null) {
				return
			}
			if (_goods_vo.type == 34) {
				if (_goods_vo.level > role_mgr.GetMainRoleVo().level) {
					local_Message.show("等级不足")
					return
				}
				bag_model.Fire(local_BagModel.OPEN_VIEW, "SelectGiftView", _goods_vo)
				return
			}
			// if (((_goods_vo.type == 40 && _goods_vo.subtype == 6) && MarriageModel.GetInstance().GetRingInfo()) && MarriageModel.GetInstance().GetRingInfo().star == 0 ) {
			// 	local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "MarriageBaseView", 2)
			// 	return
			// }
			// if ((_goods_vo.type == 37 && _goods_vo.subtype == 2) && bag_model.show_exp_tips_view) {
			// 	let buff_list = goods_model.goods_buff_list
			// 	if (buff_list.length > 0) {
			// 		for (let _tmpi in buff_list) {
			// 			let vo = buff_list[_tmpi]
			// 			let goodsbasic = goods_model.GetGoodsBasicByTypeId(vo.goods_id)
			// 			if (((goodsbasic && goodsbasic.type == 37) && goodsbasic.subtype == 2) && goodsbasic.type_id != _goods_vo.type_id) {
			// 				Alert.Show(Util.StrToHTML("使用后会替换当前" + local_GoodsModel.GetGoodsNameWithColorDark(goodsbasic.type_id) + "效果，是否继续？"), Alert_Type.AlertTypeCheckBox, () => {
			// 					if (_goods_vo.goods_num <= 1) {
			// 						goods_model.Fire(local_GoodsModel.USE_BAG_GOODS, _goods_vo.goods_id, 1)
			// 					} else {
			// 						bag_model.Fire(local_BagModel.OPEN_VIEW, "BatchUseView", _goods_vo)
			// 					}
			// 				}
			// 					, null, null, null, null, null, (bool?) => {
			// 						bag_model.show_exp_tips_view = !bool
			// 					}
			// 				)
			// 				return
			// 			}
			// 		}
			// 	}
			// }
			if (_goods_vo.type == 37 && _goods_vo.subtype == 2) {
				let buff_list = goods_model.goods_buff_list
				if (buff_list.length > 0) {
					for (let _tmpi in buff_list) {
						let vo = buff_list[_tmpi]
						let goodsbasic = goods_model.GetGoodsBasicByTypeId(vo.goods_id)
						if ((goodsbasic && goodsbasic.type == 37) && goodsbasic.subtype == 2) {
							let state = goods_model.HaveHightExpBuff(goodsbasic.type_id, _goods_vo.type_id)
							if (state == 2) {
								Alert.Show("当前已存在更高级的经验符,低级经验符将会在高级经验符持续时间过期再生效。<br>是否继续使用？", Alert_Type.Two, () => {
									if (_goods_vo.goods_num <= 1) {
										goods_model.Fire(local_GoodsModel.USE_BAG_GOODS, _goods_vo.goods_id, 1)
									} else {
										bag_model.Fire(local_BagModel.OPEN_VIEW, "BatchUseView", _goods_vo)
									}
								})
								return
							} else if (state == 1) {
								goods_model.Fire(local_GoodsModel.USE_BAG_GOODS, _goods_vo.goods_id, 1)
								Alert.Show("已使用更高效经验符。<br>低级经验符将会高级经验符持续时间过期再生效", Alert_Type.One)
								return
							}
						}
					}
				}
			}
			if (_goods_vo.type == 38 && _goods_vo.subtype == 6) {
				DsgtModel.GetInstance().cur_select_dsgt = _goods_vo.type_id
				local_OpenFun.OpenFunHandler(35)
				return
			}
			// if (_goods_vo.type == 38 && _goods_vo.subtype == 7) {
			// 	let ok_callback = () => {
			// 		goods_model.Fire(local_GoodsModel.USE_BAG_GOODS, _goods_vo.goods_id, 1)
			// 	}

			// 	let time = DailyModel.GetInstance().outline_info || out_line_model.GetOnhookTime()
			// 	// [ts2lua]out_line_model.add_time下标访问可能不正确
			// 	let add_time = out_line_model.add_time[_goods_vo.type_id]
			// 	if (time + add_time > out_line_model.max_outline_time) {
			// 		let time = local_Math.Floor(out_line_model.max_outline_time / 3600)
			// 		Alert.Show("使用后离线挂机时间将会溢出(最多" + time + "个小时),是否继续使用", Alert_Type.Two, ok_callback)
			// 	} else {
			// 		ok_callback()
			// 	}
			// 	return
			// }
			if (_goods_vo.type == 38 && _goods_vo.subtype == 10) {
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "MarriageFlowerView")
				return
			}
			if (_goods_vo.type == 75) {
				if (SceneManager.GetInstance().IsFieldScene()) {
					TreasureMapModel.GetInstance().Fire(TreasureMapModel.TM_USE_GOODS, _goods_vo)
				} else {
					local_Message.show("当前场景不能使用")
				}
				return
			}

			// 转职丹
			if (_goods_vo.type == 38 && _goods_vo.subtype == 42) {
				OpenFun.OpenFunHandler(18); // 直接跳转转生界面
				return;
			}

			//蒙面人道具
			if (_goods_vo.type == 38 && _goods_vo.subtype == 36) {
				let einfo = MaskModel.GetInstance().GetMaskInfo()
				if (!einfo || einfo.end_time <= 0) {
					GlobalEventSystem.Fire(EventName.OPEN_VIEW, "MaskUseView", _goods_vo)
				} else {
					GlobalEventSystem.Fire(EventName.OPEN_VIEW, "MaskAddTimeView", _goods_vo)
				}
				return
			}
			if (_goods_vo.type == 38 && _goods_vo.subtype == 39) {
				if (_goods_vo.level > role_mgr.GetMainRoleVo().level) {
					local_Message.show("等级不足")
					return
				}
				GlobalEventSystem.Fire(EventName.OPEN_VIEW, "TransferJobCardView")
				return
			}
			if (_goods_vo.type_id == 37090001) {
				let ok_callback = () => {
					goods_model.Fire(local_GoodsModel.USE_BAG_GOODS, _goods_vo.goods_id, 1)
				}
				let level = RoleManager.GetInstance().GetMainRoleLevel()
				//let lv = level > 370 && "神创" + (level - 370) || level
				if (level < 219) {
					Alert.Show("是否使用人物直升丹？[推荐使用等级259级]", Alert_Type.Two, ok_callback)
				} else {
					ok_callback()
				}
				return
			}
			//宝石直升丹
			if (_goods_vo.type == 14 && _goods_vo.subtype == 12) {
				OpenFun.OpenFunHandler(11)
				return
			}
			//伙伴魂珠
			if (_goods_vo.type == 22 && _goods_vo.subtype == 1) {
				let id = PartnerModel.GetInstance().GetIDByRound(_goods_vo.type_id)
				OpenFun.OpenFunHandler(16, id)
				return
			}
			//装扮
			if (_goods_vo.type == 59) {
				OpenFun.OpenFunHandler(203, _goods_vo.subtype, _goods_vo.type_id)
				return
			}

			//古宝
			if (_goods_vo.type == 83 && _goods_vo.subtype == 1) {
				OpenFun.OpenFunHandler(240)
				return
			}


			if (_goods_vo.goods_num <= 1) {
				goods_model.Fire(local_GoodsModel.USE_BAG_GOODS, _goods_vo.goods_id, 1)
			} else {
				bag_model.Fire(local_BagModel.OPEN_VIEW, "BatchUseView", _goods_vo)
			}
		}

		this.SourceClickFunc = (e?) => {
			let ClientSourceCfg = ResManager.GetInstance().GetGameConfigFromCache(this, "GoodsSourceConfig", true)
			if (ClientSourceCfg && e) {
				// let argsList = Split(id, "@")
				let argsList = e.split(`@`)
				let CurCfg = argsList[1] != "0" && ClientSourceCfg[Number(argsList[0])]
				if (CurCfg) {
					if (common_mgr.CheckFuncOpenState(CurCfg.view, true)) {
						let click_delay = GlobalTimerQuest.AddDelayQuest(() => {
							GlobalTimerQuest.CancelQuest(click_delay)
							GlobalEventSystem.Fire(EventName.TOOLTIPS_JUMP)
							this.Close()
							if ((typeof (CurCfg.id) == "number" && (CurCfg.id == 60 || CurCfg.id >= 140 && CurCfg.id <= 145))) {
								local_OpenFun.OpenFunHandler(CurCfg.id, null, _type_id)
							} else {
								if (CurCfg.id == 239 || CurCfg.id == 204) {
									//善缘商店和武魂商店跳转
									local_OpenFun.OpenFunHandler(CurCfg.id, Number(argsList[1]))
								} else {
									local_OpenFun.OpenFunHandler(CurCfg.id,)
								}

							}
						}, 0.1)
					}
				}
			}
		}

		this.GetGiftBagRewardDesc = (type_id?, gift_level?, isList: boolean = false) => {
			let msg = ""
			let confGiftBox = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_gift_box.name, type_id, false, this.confGiftBox);
			let cond_level = GoodsModel.GetInstance().GetGiftBagCondLevel(type_id, confGiftBox)
			let gift_cfg = GoodsModel.GetInstance().GetGiftBagCfg(type_id, cond_level)
			if (gift_cfg) {
				let fixed_gifts = JSON.parse(gift_cfg.fixed_gifts);
				let rand_gifts = JSON.parse(gift_cfg.rand_gifts);
				msg = this.FormatGiftRewardStr(fixed_gifts, true, 0, isList);
				msg = msg + this.FormatGiftRewardStr(rand_gifts, false, gift_cfg.rand, isList);
			}
			return msg

		}

		this.FormatGiftRewardStr = (list?, is_fix?, times?, isList: boolean = false) => {
			let str = ""
			if (list && list.length > 0) {
				let basic_goods = null
				// let vo_type_id = null
				// let lock = null
				let a_basic = null
				let b_basic = null
				let sort_fun = (a?, b?) => {
					if (is_fix) {
						a_basic = goods_model.GetGoodsBasicByTypeId(a[1])
						b_basic = goods_model.GetGoodsBasicByTypeId(b[1])
						if (a_basic && b_basic) {
							return b_basic.color > a_basic.color
						}
					} else {
						if (a[0] && b[0]) {
							a_basic = goods_model.GetGoodsBasicByTypeId(a[0][1])
							b_basic = goods_model.GetGoodsBasicByTypeId(b[0][1])
							if (a_basic && b_basic) {
								return b_basic.color > a_basic.color
							}
						}
					}
				}
				table.sort(list, sort_fun)

				if (is_fix) {
					str = isList ? "开启固定获得以下奖励：" : "开启固定获得以下奖励：<br>";
					if (!isList) {
						for (let _tmpi in list) {
							let vo = list[_tmpi]
							let [vo_type_id, lock] = goods_model.GetMappingTypeId(vo[0], vo[1])
							if (vo_type_id) {
								basic_goods = goods_model.GetGoodsBasicByTypeId(vo_type_id)
								if (basic_goods) {
									str = str + "<font color=" + ColorUtil.GetColorDark(basic_goods.color) + ">" + basic_goods.goods_name + " * " + vo[2] + "</font><br>"
								}
							}
						}
					}
				} else {
					str = isList ? "开启可随机获得<font color='#639c12'>" + times + "</font>个以下奖励内容：" : "开启可随机获得<font color='#639c12'>" + times + "</font>个以下奖励内容:<br>";
					if (!isList) {
						for (let _tmpi in list) {
							let vo = list[_tmpi]
							let [vo_type_id, lock] = goods_model.GetMappingTypeId(vo[0][0], vo[0][1])
							if (vo_type_id) {
								basic_goods = goods_model.GetGoodsBasicByTypeId(vo_type_id)
								if (basic_goods) {
									str = str + "<font color=" + ColorUtil.GetColorDark(basic_goods.color) + ">" + basic_goods.goods_name + " * " + vo[0][2] + "</font><br>"
								}
							}
						}

					}
				}
			}
			return str
		}
	}

	public SetTipsHeight() {
		this.Local_SetTipsHeight()
	}

	public OpenCallback() {
		this.Local_OpenCallback()
	}

	public Open() {
		super.Open()
	}

	public DeleteMe() {
		super.DeleteMe()
	}


	rewardsList: Laya.List;


	public GetComponents() {
		[
			this.root_wnd,
			this.bg,
			this.item_group,
			this.nameBG,
			this.goods_name,
			this.type_text,
			this.quantity_text,
			this.level_text,
			this.level_text_value,
			this.detail_scroller,
			this.detail_group,
			this._Group1,
			this._Image1,
			this.label1,
			this.intro,
			this.tips,
			this.line2,
			this.first_line0,
			this.label2,
			this.ways,
			this.sourceGp,
			this.source_label,
			this.source_txt,
			this.btn_group,
			this.useBtn,
			this.sellBtn,
			this.okBtn,
			this.upShelfBtn,
			this.outShelfBtn,
			this.treasureReceiveBtn,
			this.takeoutBtn,
			this.depositBtn,
			this.putBtn,
			this.overdueText,
			this._gp_cooling,
			this._Image2,
			this.coolingTimeText,
			this.rewardsList,

		]
			= this.GetChildrenByNames([

				"root_wnd",
				"bg",
				"item_group",
				"nameBG",
				"goods_name",
				"type_text",
				"quantity_text",
				"level_text",
				"level_text_value",
				"detail_scroller",
				"detail_group",
				"_Group1",
				"_Image1",
				"label1",
				"intro",
				"tips",
				"line2",
				"first_line0",
				"label2",
				"ways",
				"sourceGp",
				"source_label",
				"source_txt",
				"btn_group",
				"useBtn",
				"sellBtn",
				"okBtn",
				"upShelfBtn",
				"outShelfBtn",
				"treasureReceiveBtn",
				"takeoutBtn",
				"depositBtn",
				"putBtn",
				"overdueText",
				"_gp_cooling",
				"_Image2",
				"coolingTimeText",
				"rewardsList",
			])
	}
}
window["GoodsTooltips"] = GoodsTooltips
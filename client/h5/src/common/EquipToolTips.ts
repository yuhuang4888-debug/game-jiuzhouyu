
//require("game.common.EquipBestProItem")
import { BaseView1 } from "../common/BaseView1"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { Util, Trim, AtlasUrl, GlobalTimerQuest, RefGridLayout, RefBoxChildsLayout, HtmlColorTxt } from "../util/Util"
import { Config } from "./Config"
import { EventName } from "./EventName"
import { Enum_UILayer } from "./LayerManager"
import { ResManager } from "./ResManager"
import { WordManager } from "./WordManager"
import { RoleManager } from "../commonModel/RoleManager"
import { Alert, Alert_Type } from "../alert/Alert"
import { Message } from "../sysInfo/SysInfoController"
import { ColorType, ColorUtil, Enum_ColorUtil_Dark, Enum_ColorUtil_Light } from "../util/ColorUtil"
import { ErlangParser } from "../util/ErlangParser"
import { GoodsModel } from "../commonModel/GoodsModel"
import { EquipModel, EquipEvent, EquipDefine } from "../commonModel/EquipModel"
import { table } from "./table"
import { EquipmentItem } from "../common/EquipmentItem"
import { EquipBestProItem } from "./EquipBestProItem"
import { EquipStoneItem } from "../equip/EquipStoneItem"
import { SYTweenFunc } from "../util/SYTweenFunc"
import { SYTweenLite } from "../util/SYTweenLite"
import { EquipSuitAttrItem } from "../suit/EquipSuitAttrItem"
import { GuildModel, GuildEvent } from "../commonModel/GuildModel"
import { MarketModel } from "../commonModel/MarketModel"
import { MarketEvent } from "../commonModel/MarketModel"
import { CompositeModel } from "../commonModel/CompositeModel"
import { RuneTreasureModel, RuneTreasureEvent } from "../commonModel/RuneTreasureModel"
import { CommonManager } from "./CommonManager"
import { EnumSubType, EnumSuitType, SuitModel } from "../commonModel/SuitModel"
import { TaskModel } from "../commonModel/TaskModel"
import { PlatformManager } from "../PlatformManager"
export class EquipToolTips extends BaseView1 {

	labelDisplay
	RebuildTimer
	labelDisplay111111111
	Local_InitEvent
	ClearReBuildTimer
	GetBaseAndStrenProStr
	GetBaseAndStrenProStrArr
	GetBestProNum
	SetStonePro
	type_id
	used_open_func
	labelDisplay111
	goods_icon: EquipmentItem
	x_cache
	labelDisplay1111111
	labelDisplay111111
	ResConfig
	use_background
	SetData
	RefinePro
	need_refresh
	click_bg_toClose
	Local_InitView
	SetSmeltPro
	Scrcontent_scroll
	SetRedPro
	labelDisplay11
	labelDisplay11111
	close_callback
	labelDisplay11111111
	is_center
	destroy_imm
	SetWashPro
	preload_server_config
	_Image2
	SetSuitPro2
	is_delay_callback
	SetSuitPro1
	show_btn_list
	equip_attr
	Local_RefreshBtnState
	labelDisplay1111111111
	cfg_finish
	_Image1
	y_cache
	labelDisplay111111111111
	smelt_pro_conta
	Local_customFunction
	open_callback
	textrefine
	destroy_callback
	LoadSuccess
	goods_vo
	SetGodEquipPro
	labelDisplay1111
	labelDisplay11111111111
	stren_cfg
	SetBestPro
	PreSetHtml
	ref_scroll
	cfg_god_equip_cfg
	ShowTaskExchangeArrow
	/**神装合成预览 */
	is_show_base_att = false
	public static BtnWidth = 149;
	public static BtnHeight = 53;

	// Font_name: string = "equip_grade"
	bitmapFont: Laya.BitmapFont

	public constructor() {
		super()

		this.type_id = 0;
		this.goods_vo = null;
		this.cfg_finish = false;
		this.need_refresh = false;
		this.used_open_func = false;
		let local_Util = Util

		let local_Config = Config
		let role_mgr = RoleManager.GetInstance()
		let local_Message = Message
		let goods_model = GoodsModel.GetInstance()
		let equip_model: EquipModel = EquipModel.GetInstance()
		let guild_model = GuildModel.GetInstance()
		let local_GuildEvent = GuildEvent
		let market_model = MarketModel.GetInstance()
		let local_MarketEvent = MarketEvent
		let local_GoodsModel = GoodsModel
		let local_ColorUtil = ColorUtil
		let local_Enum_ColorUtil_Dark = Enum_ColorUtil_Dark
		let local_Enum_ColorUtil_Light = Enum_ColorUtil_Light
		let local_WordManager = WordManager
		let erlang_parser = ErlangParser.GetInstance()
		let _role_id = 0
		let _god_lv = 0
		let _is_show_btn = false
		let _dynamic = null
		let _config_equip_stone_lv = null
		let _best_pro_item_list = null
		let _stone_item_list = null
		let _wash_item_list = null
		// let _smelt_item_list = null
		let _suit_item_list: EquipSuitAttrItem[] = []
		let _suit_item_list2 = null
		let refinement_cfg = null
		this.base_file = "common"
		this.layout_file = "EquipToolTips"
		this.layer_value = Enum_UILayer.Top
		this.destroy_imm = true
		this.use_background = true
		this.click_bg_toClose = true
		this.is_center = true
		this.is_delay_callback = false
		this.preload_server_config = {
			"config_equip_stren_lv": false,
			"config_equip_stone_pos_unlock": false,
			"config_equip_refine_lv": false,
			"config_equip_refinement": false,
			"config_god_equip_cfg": false
		}
		this.is_center = true

		this.load_callback = () => {
			// ResManager.GetInstance().LoadFont(this, "equip_grade", this.grade, 20)

			this.LoadSuccess()
			this.InitEvent()
			// if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
			// 	this.best.size  = 18
			// }
		}

		this.open_callback = () => {

			this.used_open_func = true
			if (this.need_refresh) {
				this.InitView()
			}
		}

		this.close_callback = () => { }
		this.destroy_callback = () => {
			if (this.goods_icon) {
				this.goods_icon.DeleteMe()
				this.goods_icon = null
			}
			for (let _tmpi in _best_pro_item_list) {
				let obj = _best_pro_item_list[_tmpi]
				obj.DeleteMe()
			}
			_best_pro_item_list = null
			for (let _tmpi in _stone_item_list) {
				let obj = _stone_item_list[_tmpi]
				obj.DeleteMe()
			}
			_stone_item_list = null
			if (_suit_item_list) {
				for (let _tmpi in _suit_item_list) {
					let obj = _suit_item_list[_tmpi]
					obj.DeleteMe()
				}
				_suit_item_list = null
			}
			if (_suit_item_list2) {
				for (let _tmpi in _suit_item_list2) {
					let obj = _suit_item_list2[_tmpi]
					obj.DeleteMe()
				}
				_suit_item_list2 = null
			}
			_wash_item_list = null
			// _smelt_item_list = null
			_config_equip_stone_lv = null
			this.equip_attr = null
			this.stren_cfg = null
			this.ClearReBuildTimer()

			if (this.ref_scroll) {
				clearTimeout(this.ref_scroll)
				this.ref_scroll = null
			}
		}

		this.PreSetHtml = () => {
			this.score.width = 271
			this.score.style.fontSize = 22
			this.score.style.bold = false
			this.score.style.color = "#ffffff"

			this.level.width = 272
			this.level.style.fontSize = 22
			this.level.style.color = "#ffffff"
			this.level.style.bold = false


			this.career.width = 195.33
			this.career.style.fontSize = 20
			this.career.style.bold =true
			this.career.style.color = "#663915"

			this.basePro.width = 310
			this.basePro.style.fontSize = 20
			this.basePro.style.color = "#5a1c20"
			this.basePro.style.wordWrap = true
			this.basePro.style.leading = 4


			this._html_stren.width = 310
			this._html_stren.style.fontSize = 20
			this._html_stren.style.color = "#0a953e"
			this._html_stren.style.wordWrap = true
			this._html_stren.style.leading = 4


			

			this.washText.width = 310
			this.washText.style.fontSize = 20
			this.washText.style.color = "#5a1c20"
			this.washText.style.wordWrap = true
			this.washText.style.leading = 4

			this.specPro.width = 310
			this.specPro.style.fontSize = 20
			this.specPro.style.color = "#5a1c20"
			this.specPro.style.wordWrap = true
			this.specPro.style.leading = 4

			this.godPro.width = 340
			this.godPro.style.fontSize = 20
			this.godPro.style.color = "#5a1c20"
			this.godPro.style.wordWrap = true
			this.godPro.style.leading = 4

			this.guild_score.width = 310
			this.guild_score.style.fontSize = 20
			this.guild_score.style.color = "#5a1c20"
			this.guild_score.style.wordWrap = true
			this.guild_score.style.leading = 4
		}

		this.LoadSuccess = () => {
			this.PreSetHtml()

			this.content_scroll.vScrollBar.visible = false

			//this.content_scroll.verticalScrollBar.autoVisibility = false
			//this.content_scroll.verticalScrollBar.visible = false

			// this.sc_img = this.GetChild("equip_conta/sc_img").gameObject
			// ResManager.GetInstance().SetOutsideImageSprite(this, this._Image3, GameResPath.GetIcon("common2", "uity_016c"))
			//lua_resM:SetOutsideImageSprite(this,this._Image2,GameResPath.GetIcon("common2","uity_016e"))
			_best_pro_item_list = []
			_stone_item_list = []
			this.ResConfig()
			// if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
			// 	this.career.size  = 18
			// 	this.pos.size  = 18
			// }


		}




		this.Local_InitEvent = () => {
			let close_fun = () => {
				this.Close()
			}

			Util.AddClickEvent(this.closeBtn, close_fun, this, true)
			Util.AddClickEvent(this.replaceBtn, () => {
				if (!this.goods_vo) {
					return
				}
				let cfgs = ResManager.GetInstance().GetGameConfigFromCache(this, "config_goods", false)
				let cfg = local_Config.GetConfigVo(local_Config.ConfigHasDefaultValue.config_goods.name, this.goods_vo.type_id, false, cfgs)
				let career = role_mgr.GetMainRoleVo().career
				if ((cfg && cfg.career_id != 0) && cfg.career_id != career) {
					local_Message.show("装备职业类型不符合")
					return
				}
				goods_model.CheckEquipNum(1, 0, () => {
					equip_model.Fire(EquipEvent.REQUEST_PROTO, 15201, "l", this.goods_vo.goods_id)
					this.Close()
				}
				)
			}
				, this, true)
			Util.AddClickEvent(this.guildDonateBtn, () => {
				if (guild_model.CheckDepotOver()) {
					local_Message.show("仓库已满，无法继续捐献")
					return
				}
				guild_model.Fire(GuildEvent.REQUEST_40102, [{ goods_id: this.goods_vo.goods_id, num: 1 }])
				this.Close()
			}
				, this, true)
			Util.AddClickEvent(this.guildExchangeBtn, () => {

				if (this.story_model.task_supplement_list["GuildDonateTaskId"]) {
					delete this.story_model.task_supplement_list["GuildDonateTaskId"]
					GlobalEventSystem.Fire(EventName.HIDE_FINGER, this.guildExchangeBtn)
				}

				guild_model.Fire(local_GuildEvent.REQUEST_PROTO, 40103, "lii", this.goods_vo.goods_id, this.goods_vo.type_id, 1)
				this.Close()
			}
				, this, true)
			Util.AddClickEvent(this.destroyBtn, () => {
				Alert.Show("确认销毁这些装备吗？", Alert_Type.Two, () => {
					guild_model.Fire(local_GuildEvent.REQUEST_40104, [this.goods_vo.goods_id])
					this.Close()
				}
				)
			}
				, this, true)
			Util.AddClickEvent(this.UninstallBtn, () => {
				CompositeModel.GetInstance().Fire(CompositeModel.UNINSTALL_EQUIP, this.goods_vo.goods_id)
				this.Close()
			}
				, this, true)
			let upShelfBtn_fun = () => {
				if (!this.goods_vo) {
					return
				}
				let goods_vo = this.goods_vo
				if (goods_vo["bind"]) {
					Message.show("绑定装备无法上架~")
					return
				}
				if (!goods_model.GetGoodsVoByGoodsId(goods_vo.goods_id)) {
					Message.show("物品不存在")
					market_model.Fire(MarketEvent.NEED_UPDATE_BAG)
				} else {
					market_model.Fire(local_MarketEvent.OPEN_VIEW, "MarketSellCtrlView", this.goods_vo)
				}
				this.Close()
			}

			Util.AddClickEvent(this.upShelfBtn, upShelfBtn_fun, this, true)
			let outShelfBtn_fun = () => {
				if (!this.goods_vo) {
					return
				}
				let goods_vo = this.goods_vo
				market_model.Fire(local_MarketEvent.REQUEST_PROTO, 15108, "clii", 1, goods_vo.id, goods_vo.type_id, goods_vo.goods_num)
				this.Close()
			}

			Util.AddClickEvent(this.outShelfBtn, outShelfBtn_fun, this, true)
			let sellBtn_fun = () => {
				if (this.goods_vo) {
					GlobalEventSystem.Fire(EventName.OPEN_VIEW, "SellView", this.goods_vo)
				}
				this.Close()
			}

			Util.AddClickEvent(this.sellBtn, sellBtn_fun, this, true)
			let treasureReceive_fun = () => {
				if (!this.goods_vo) {
					return
				}
				let basic = goods_model.GetGoodsBasicByTypeId(this.type_id)
				if (basic == null) {
					return
				}
				let goods_vo = this.goods_vo
				RuneTreasureModel.GetInstance().Fire(RuneTreasureEvent.RUNE_TREASURE_REQUEST_PROTO, 41605, "lhh", goods_vo.goods_id, local_GoodsModel.GOODS_POS_TYPE.treasurebag, basic.bag_location)
				this.Close()
			}

			Util.AddClickEvent(this.treasureReceiveBtn, treasureReceive_fun, this, true)
			let depositFunc = () => {
				if (!this.goods_vo) {
					return
				}
				goods_model.Fire(local_GoodsModel.MOVE_GOODS_POS, this.goods_vo.goods_id, local_GoodsModel.GOODS_POS_TYPE.bag, local_GoodsModel.GOODS_POS_TYPE.warehouse)
				this.Close()
			}

			Util.AddClickEvent(this.depositBtn, depositFunc, this, true)
			let takeoutFunc = () => {
				if (!this.goods_vo) {
					return
				}
				goods_model.Fire(local_GoodsModel.MOVE_GOODS_POS, this.goods_vo.goods_id, local_GoodsModel.GOODS_POS_TYPE.warehouse, local_GoodsModel.GOODS_POS_TYPE.bag)
				this.Close()
			}

			Util.AddClickEvent(this.takeoutBtn, takeoutFunc, this, true)
		}

		this.Local_customFunction = () => {

		}

		this.ResConfig = () => {
			this.stren_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_equip_stren_lv", false)
			this.equip_attr = ResManager.GetInstance().GetGameConfigFromCache(this, "config_equip_attr", false)
			this.cfg_god_equip_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_god_equip_cfg", false)
			_config_equip_stone_lv = Config.PRELOAD_SERVER_CONFIG.config_equip_stone_lv
			//refinement_cfg = Config.Equiprefinement
			this.cfg_finish = true
		}

		this.SetData = (type_id?, x?, y?, goods_vo?, role_id?, show_btn_list?, god_lv?) => {
			this.type_id = type_id
			_role_id = role_id
			this.show_btn_list = show_btn_list && show_btn_list || [1]
			let main_role_id = role_mgr.GetMainRoleId()
			this.x_cache = x
			this.y_cache = y
			_dynamic = null
			_god_lv = god_lv
			if (x != null && y != null) {
				this.is_center = false
			} else {
				this.is_center = true
			}
			if (role_id && role_id != main_role_id) {
				_is_show_btn = false
				this.goods_vo = goods_vo
				_dynamic = this.goods_vo
				this.need_refresh = true
			} else {
				_is_show_btn = goods_vo != null && goods_model.GetGoodsVoByGoodsId(goods_vo.goods_id) != null || false
				this.goods_vo = goods_vo || goods_model.GetGoodsBasicByTypeId(type_id)
				if (this.goods_vo.goods_id) {
					let wear = equip_model.GetWearEquipInfo(this.goods_vo.equip_type)
					if (wear && wear.goods_id == this.goods_vo.goods_id) {
						let callback = (dynamic?) => {
							_dynamic = dynamic
							this.need_refresh = true
							if ((this.used_open_func && this.is_loaded) && !this.use_delete_method) {
								this.InitView()
							}
						}

						goods_model.GetDynamic(this.goods_vo.goods_id, callback)
					} else {
						this.need_refresh = true
					}
				} else {
					this.need_refresh = true
				}
			}
		}

		this.Local_InitView = () => {
			if ((!this.cfg_finish || this.need_refresh == false) || !this.is_loaded) {
				return
			}
			if (this.goods_vo == null) {
				this.Close()
				return console.log("物品config里面没有配置")
			}
			let equip_vo = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_equip_attr.name, this.goods_vo.type_id, false, this.equip_attr)
			let basic = goods_model.GetGoodsBasicByTypeId(this.type_id)
			if (basic == null) {
				local_Message.show("没有物品数据")
				this.Close()
				return
			}
			if (this.x_cache != null && this.y_cache != null) {
				this.display_obj.x = this.x_cache
				this.display_obj.y = this.y_cache
			}
			if (!this.goods_icon) {
				this.goods_icon = new EquipmentItem(this.icon, null, null, null, null, true)
				this.goods_icon.Load()
				this.goods_icon.SetItemSize(84, 84)
				this.goods_icon.ChangeCountVisible(false)
			}
			this.goods_icon.SetData(this.goods_vo.type_id, 1, this.goods_vo.is_lock, null, null, null, this.goods_vo.rating, this.goods_vo.equip_extra_attr, this.goods_vo.goods_id)
			this.goods_icon.SetShowTips(false)
			if (this.goods_vo.goods_id && goods_model.GetEquipById(this.goods_vo.goods_id)) {
				this.goods_icon.SetStrengthen(this.goods_vo.stren, true)
			} else {
				this.goods_icon.SetStrengthen(this.goods_vo.stren)
			}
			let role_lv = role_mgr.GetMainRoleVo().level
			let lv_color = role_lv >= basic.level && "'#ffef67'" || local_Enum_ColorUtil_Light.RED
			if(role_lv < basic.level){
				this.level.style.stroke = 2
				this.level.style.strokeColor = "#ffffff"
			}
			let lv = basic.level > 370 && (basic.level - 370) || basic.level
			this.sc_img.visible = basic.level > 370
			this.level.x = basic.level > 370 ? 106 : 80
			let lv_str = "<font color=" + lv_color + ">" + lv + "</font>"
			if (lv == 1) {
				lv_str = "<font color=" + lv_color + ">" + "无限制" + "</font>"
			}
			this.level.innerHTML = Util.StrToHTML(lv_str)
			this.level.width = 271
			if (PlatformManager.IsEyouPlatform()) {
				this.grade.text = String("a" + equip_vo.stage)
			} else {
				this.grade.text = `${equip_vo.stage}阶`
			}
			
			let god_equip_str = equip_model.godEquipShowTips(this.cfg_god_equip_cfg, this.goods_vo, _god_lv)
			let color_str = local_ColorUtil.GetColorDark(basic.color)
			this.nameBG.skin = AtlasUrl("common4", "ui_tips_pz_" + basic.color)
			this.equip_name.text = god_equip_str + Trim(basic.goods_name)

			let score = 0

			if (this.is_show_base_att) {
				score = Util.CalAttrPower(basic.base_attrlist, false, true)
				if (equip_vo) {
					score = score + Util.CalAttrPower(equip_vo.other_attr, false, true)
				}
			} else {
				score = this.goods_vo.rating
				if (!score) {
					score = Util.CalAttrPower(basic.base_attrlist, false, true)
					if (equip_vo) {
						score = score + Util.CalAttrPower(equip_vo.other_attr, false, true)
					}
				}

			}

			this.score.innerHTML = Util.StrToHTML("评分：<font color='#ffef67'>" + score + "</font>")
			this.score.width = 271
			let pos = local_WordManager.GetEquipPos(basic.equip_type)
			this.pos.text = Util.StrToHTML(pos)
			let rein_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_reincarnation_cfg", false) //Config.Reincarnationcfg //ReincarnationModel:GetInstance().rein_cfg
			rein_cfg = rein_cfg[basic.career_id + "@" + basic.sex + "@" + basic.turn]
			let career = "通用"
			let color = null
			let role_vo = role_mgr.GetMainRoleVo()
			let diff_sex = basic.sex != 0 && role_vo.sex != basic.sex
			let diff_career = basic.career_id != 0 && role_vo.career != basic.career_id
			let no_turn = role_vo.turn < basic.turn
			color = (diff_sex || diff_career || no_turn) && Enum_ColorUtil_Dark.RED || "'#d15e00'"
			if (rein_cfg) {
				career = rein_cfg.name
			} else if (basic.turn == 0) {
				if (basic.sex != 0) {
					career = basic.sex == 1 && "男性职业" || "女性职业"
				}
			} else {
				if (basic.turn != 0){
					if(basic.sex == 0){
						career = `${WordManager.NumConvertStage(basic.turn)}转通用`
					} else {
						career = WordManager.NumConvertStage(basic.turn) + "转" + (basic.sex == 1 && "男职" || "女职")
					}
				}
			}
			this.career.innerHTML = Util.StrToHTML("职业：<font color=" + color + ">" + career + "</font>")
			this.career.width = 195.33
			let stren_lv = this.goods_vo.stren && this.goods_vo.stren || 0
			let cfg = local_Config.GetConfigVo(local_Config.ConfigHasDefaultValue.config_equip_stren_lv.name, basic.equip_type + "@" + "1", false, this.stren_cfg)
			let stren_list = cfg && erlang_parser.Parse(cfg.attr_list) || {}
			let arr = this.GetBaseAndStrenProStrArr(erlang_parser.Parse(basic.base_attrlist), stren_list, stren_lv)
			this.basePro.innerHTML = arr[0] //Util.StrToHTML(this.GetBaseAndStrenProStr(erlang_parser.Parse(basic.base_attrlist), stren_list, stren_lv))
			this._html_stren.innerHTML = arr[1]
			this.basePro.width = 310
			this.basePro.height = this.basePro.contextHeight
			this._html_stren.width = 310
			this._html_stren.height = this.basePro.contextHeight
			//能不用vbox就不要用，很烦，写7是因为极品属性被隐藏，然后vbox计算的时候会将元素往上缩
			let offset = 7
			if(this.best_conta.visible == false){
				this.content_group.top = offset
			}
			this.base_pro_conta.height = this.basePro.contextHeight + this.basePro.y
			this.content_scroll.vScrollBar.value = 0

			this.SetBestPro()
			this.SetGodEquipPro()
			this.SetRedPro()
			this.SetStonePro()
			this.SetWashPro()
			this.SetSmeltPro()
			this.SetSuitPro1()
			//this:SetSuitPro2()
			this.RefinePro()

			this.ref_scroll = GlobalTimerQuest.AddDelayQuest(() => {
				this.content_group.refresh()
			}, 0.3)

			this.RefreshBtnState()
			this.ClearReBuildTimer()
			// this.RebuildTimer = setTimeout(() => {
			// 		UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(this.content_group)
			// 		this.RebuildTimer = null
			// 	},0.3 )
		}


		//基础和强化属性
		this.GetBaseAndStrenProStrArr = (base_attrlist, stren_list) => {
			let str = "";
			let str_stren = "";
			let pro
			if (base_attrlist && Array.isArray(base_attrlist)) {
				base_attrlist.forEach((val, idx, array) => {
					let sstr
					if (stren_list && Array.isArray(stren_list)) {
						for (let i = 0; i < stren_list.length; i++) {
							pro = stren_list[i]
							if (pro && pro[0] == val[0] && pro[1] > 0) {
								let pro_value = pro[1] * this.goods_vo.stren 
								if(pro_value && this.goods_vo.stren != 0){
									sstr = `${HtmlColorTxt(`强化&nbsp;+${pro_value}`, "'#0a953e'")}`
								}
								break
							}
						}
					}
					if ((idx + 1) != base_attrlist.length) {
						str = str + local_WordManager.GetProperties(val[0]) + "：<font color='#d15e00'>" + val[1] + "</font>" + "<br/>";

						if (sstr) {
							str_stren = str_stren + sstr + "<br/>"
						} else {
							str_stren = str_stren + "<br/>"
						}

					}
					else {
						str = str + local_WordManager.GetProperties(val[0]) + "：<font color='#d15e00'>" + val[1] + "</font>";

						if (sstr) {
							str_stren = str_stren + sstr
						} else {
							str_stren = str_stren + "<br/>"
						}

					}
				});
			}
			return [str, str_stren]
		}

		this.GetBaseAndStrenProStr = (base_attrlist?, stren_list?, stren_lv?) => {
			let str = ""
			let stren_str = null
			let pro = null
			if (base_attrlist && base_attrlist.length > 0) {
				for (let idx in base_attrlist) {
					let val = base_attrlist[idx]
					stren_str = ""
					if ((stren_list && stren_list.length > 0) && stren_lv > 0) {
						for (let i = 0; i < stren_list.length; i++) {
							pro = stren_list[i]
							if ((pro && pro[0] == val[0]) && Number(pro[1]) > 0) {
								stren_str = " <font color='#0a953e'>（强化+" + pro[1] * stren_lv + "）</font>"
								break
							}
						}
					}
					if (Number(idx) < base_attrlist.length - 1) {
						str = str + local_WordManager.GetProperties(val[0]) + "：<font color='#d15e00'>" + val[1] + "</font> " + stren_str + "<br/>"
					} else {
						str = str + local_WordManager.GetProperties(val[0]) + "：<font color='#d15e00'>" + val[1] + "</font>" + stren_str
					}
				}
			}
			return str
		}

		this.RefinePro = () => {
			if (!this.refine || !this.refine_pro_conta) {
				return
			}
			let config_equip_refinement = ResManager.GetInstance().GetGameConfigFromCache(this, "config_equip_refinement", false)
			let show_refine = null
			let extraList = null
			let lv = null
			let vo = this.goods_vo
			if (!vo || !_dynamic) {
				show_refine = false
			} else {
				extraList = equip_model.shortExtraAttrColor(vo.equip_extra_attr)
				lv = _dynamic.refinement_lv
				show_refine = (lv && lv != 0) && equip_model.CheckCanRefine(vo, this.equip_attr)
			}
			this.refine_pro_conta.visible = show_refine
			// this.refine_pro_conta.includeInLayout = show_refine
			this.refine.visible = show_refine
			if (show_refine) {
				this.refine.text = "神炼 +" + lv
				let refineStr = ""
				for (let i in extraList) {
					let extraVo = extraList[i]
					if (extraVo.color >= 4) {
						refineStr = refineStr + equip_model.getRefineAttr(extraVo, lv, vo.equip_type, config_equip_refinement) + "\n"
					}
				}
				this.refine_pro_conta.text = refineStr
			}
		}

		this.SetBestPro = () => {
			let list = []
			let is_preview = false
			if (this.goods_vo) {

				if (this.goods_vo) {

					if (this.is_show_base_att) {
						let cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_equip_attr.name, this.goods_vo.type_id, false, this.equip_attr)
						list = cfg && erlang_parser.Parse(cfg.recommend_attr) || []
						is_preview = true
					} else {
						if (this.goods_vo.equip_extra_attr) {
							list = equip_model.shortExtraAttrColor(this.goods_vo.equip_extra_attr)
						} else {
							let cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_equip_attr.name, this.goods_vo.type_id, false, this.equip_attr)
							list = cfg && erlang_parser.Parse(cfg.recommend_attr) || []
							is_preview = true
						}
					}

				}


			}
			if (list && list.length > 0) {
				if (is_preview) {
					let num = this.GetBestProNum()
					this.best.text = "极品属性(随机生成" + num + "条极品属性)"
				}
			}
			if (list.length > 0) {
				this.best_conta.visible = true
				this.best_conta.height = 0
				// this.best_conta.includeInLayout = true
				let item = null
				for (let i = 0; i < list.length; i++) {
					item = _best_pro_item_list[i]
					if (!item) {
						item = new EquipBestProItem(this.best_pro_conta)
						_best_pro_item_list[i] = item
						item.Load()
						if (i == list.length - 1) {
							item.ExcuteCallback(() => {
								if (!this.use_delete_method) {
									this.best_conta.height = 35 + 26 * (i + 1)
									// UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(this.content_group)
								}
							})
						}
					}
					item.SetVisible(true)
					item.SetData(list[i], is_preview)
				}

				let i = list.length
				if (_best_pro_item_list[i] != null) {
					do {
						_best_pro_item_list[i].SetVisible(false)
						i = i + 1
					} while ((i < _best_pro_item_list.length))
				}

				//SetAnchoredPosition(this.line2.transform,this.line2.transform.anchoredPosition.x,list.length * EquipBestProItem.Height + list.length - 1 * 2 + this.best_pro_conta.anchoredPosition.y + 10)
				//SetSizeDeltaY(this.best_conta.transform,this.line2.transform.anchoredPosition.y+this.line2.transform.sizeDelta.y + 4)
			} else {
				this.best_conta.visible = false
				this.best_conta.height = -15
				// this.best_conta.includeInLayout = false
			}
		}

		this.SetStonePro = () => {
			let list = []
			let posList = {}
			let stone_num = 0
			if (this.goods_vo) {
				if (_dynamic && _dynamic.stone_list) {
					for (let vo of _dynamic.stone_list) {
						list.unshift(vo)
						posList[vo.pos] = vo.pos
					}
					stone_num = _dynamic.stone_list.length
				}
			}
			if (list.length < 6) {
				let obj = null
				let gap = 6 - list.length
				for (let i = 0; i < gap; i++) {
					let _pos = 0
					for (let v of EquipDefine.JEWEL_POS) {
						if (!posList[v]) {
							_pos = v
							posList[v] = v
							break
						}
					}
					obj = { pos: _pos, type_id: 0 }
					table.insert(list, obj)
					stone_num = stone_num + 0.5
				}
			}
			let open = CommonManager.GetInstance().CheckFuncOpenState("EquipJewelView", true)
			if (open && list.length > 0 && _config_equip_stone_lv) {
				this.stone_conta.visible = true
				this.stone_conta.height = 0
				// this.stone_conta.includeInLayout = true
				let item = null
				let cfg = null
				let pos = null
				let lock_cfg = null
				let i = 0
				let index = 0
				let unlock_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_equip_stone_pos_unlock", false)
				let equip_type = goods_model.GetGoodsBasicByTypeId(this.goods_vo.type_id).equip_type
				for (let v of list) {
					pos = v.pos
					lock_cfg = unlock_cfg[equip_type + "@" + pos]
					let attr_cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_equip_attr.name, this.goods_vo.type_id, false, this.equip_attr)
					let cond = JSON.parse(lock_cfg.condition)
					let lock = !(cond.length < 1)
					let vipStr = ""
					let stageStr = ""
					if (lock) {
						let str_list = cond[0]
						let key = str_list[0]
						let value = str_list[1]
						if (key == "stage" && attr_cfg) {
							lock = attr_cfg.stage < Number(value)
							stageStr = lock && (value + "阶解锁") || ""
						} else if (key == "vip") { //vip孔默认显示
							// let card = VipModel.GetInstance().GetNobleCardState()
							// let vip_flag = RoleManager.GetInstance().GetMainRoleVo().vip_flag
							let vValue = str_list[2]
							// lock = !(Number(vValue) <= vip_flag && Number(value) <= card)
							vipStr = lock && "VIP" + vValue + "解锁" || ""
							lock = false
						}
					}
					// if (lock) {
					// 	i = i + 1
					// 	break
					// }
					item = _stone_item_list[index]
					if (!item) {
						item = new EquipStoneItem(this.stone_pro_conta)
						_stone_item_list[index] = item
						item.Load()
					}
					item.SetVisible(true)
					if (list[i]) {
						list[i].cfg = _config_equip_stone_lv[list[i].type_id]
						list[i].vipCond = vipStr
						list[i].stageStr = stageStr
					}
					item.SetData(list[i])
					index = index + 1
					i = i + 1
				}
				for (let i = list.length; i < _stone_item_list.length; i++) {
					_stone_item_list[i].SetVisible(false)
				}
				// SetAnchoredPosition(this.line3, this.line3.transform.anchoredPosition.x, stone_num * EquipStoneItem.Height + 5 * 2 + 6 - stone_num * EquipStoneItem.Height / 2 + this.stone_pro_conta.transform.anchoredPosition.y + 10)
				// SetSizeDeltaY(this.stone_pro_conta, (EquipStoneItem.Height + 4) * stone_num )
			} else {
				this.stone_conta.visible = false
				this.stone_conta.height = -15
				// this.stone_conta.includeInLayout = false
			}
		}

		this.SetWashPro = () => {
			let list = []
			let wash_num = 0
			if (this.goods_vo) {
				if (_dynamic && _dynamic.wash_attr) {
					for (let _tmpi in _dynamic.wash_attr) {
						let vo = _dynamic.wash_attr[_tmpi]
						table.insert(list, vo)
					}
					wash_num = _dynamic.wash_attr.length
				}
			}
			if (!_wash_item_list) {
				_wash_item_list = []
			}
			if (list.length > 0) {
				this.wash_conta.visible = true
				this.wash_conta.height = 0
				// this.wash_conta.includeInLayout = true
				let info = null
				let str
				for (let i = 0; i < list.length; i++) {
					info = list[i]
					let pro = local_WordManager.GetProperties(info.attr_id)
					let value = local_WordManager.ConvertToPercentValue(info.attr_id, info.attr_val)
					let color = null
						if(info.color == ColorType.GREEN){ //这里策划要数值色，写了一个特殊结构
							color = "'#0a953e'"
						}
						else{
							color = local_ColorUtil.GetColorDark(info.color)
						}
					if (i == 0) {
						str = "<font color=" + color + ">" + pro + ("+") + value + "</font>"
					} else {
						str = str + "<br><font color=" + color + ">" + pro + ("+") + value + "</font>"
					}
				}
				this.washText.innerHTML = Util.StrToHTML(str)
				this.washText.width = 310
				this.washText.height = this.washText.contextHeight
			} else {
				this.wash_conta.visible = false
				this.wash_conta.height = -15
				// this.wash_conta.includeInLayout = false
			}
		}

		this.SetSmeltPro = () => {
			let list = []
			let level = 0
			if (this.goods_vo && this.goods_vo.goods_id && goods_model.GetEquipById(this.goods_vo.goods_id)) {
				let wear = equip_model.GetWearEquipInfo(this.goods_vo.equip_type)
				let sinfo = equip_model.GetSmeltInfo(this.goods_vo.equip_type)
				if ((wear && sinfo) && sinfo.refine && sinfo.refine > 0) {
					level = sinfo.refine
					let equip_refine_lv_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_equip_refine_lv", false)
					let sdata = equip_model.GetSmeltData(sinfo.equip_type, sinfo.refine, equip_refine_lv_cfg)
					let attr_list = ErlangParser.GetInstance().Parse(sdata.attr_list)
					// let is_max = false
					// if (sdata.refine == 100) {
					// 	let cfg_new = equip_model.GetSmeltData(sinfo.equip_type, sinfo.refine - 1, equip_refine_lv_cfg)
					// 	attr_list = ErlangParser.GetInstance().Parse(cfg_new.attr_list)
					// 	is_max = true
					// }
					for (let _tmpi in attr_list) {
						let attr = attr_list[_tmpi]
						attr[1] = 0
					}
					let now_stren_ratio = 0
					for (let key in equip_refine_lv_cfg) {
						let refine_data = equip_refine_lv_cfg[key]
						// let refine = is_max && sdata.refine - 1 || sdata.refine
						if (refine_data.part == sdata.part && refine_data.refine < sdata.refine) {
							now_stren_ratio = now_stren_ratio + refine_data.stren_ratio
							let list_ = ErlangParser.GetInstance().Parse(refine_data.attr_list)
							let i = 0
							for (let _tmpi in list_) {
								let attr = list_[_tmpi]
								attr_list[i][1] = Number(attr[1]) + Number(attr_list[i][1])
								i = i + 1
							}
						}
						// if ((is_max && refine_data.part == sdata.part) && refine_data.refine == sdata.refine) {
						// 	now_stren_ratio = now_stren_ratio + refine_data.stren_ratio
						// }
					}
					if (sdata) {
						for (let i = 0; i < attr_list.length; i++) {
							if (attr_list[i]) {
								attr_list[i][2] = 1
								table.insert(list, attr_list[i])
							}
						}
						if (now_stren_ratio > 0) {
							//这里有个提升强化属性的特殊属性
							table.insert(list, [0, now_stren_ratio, 2])
						}
					}
				}
			}
			if (list.length > 0) {
				this.smelt_conta.visible = true
				this.smelt_conta.height = 0
				// this.smelt_conta.includeInLayout = true
				let info = null
				let smelt_str
				if (list.length > 0) {
					for (let i = 0; i < list.length; i++) {
						info = list[i]
						let pro = null
						let value = null
						if (info[2] == 1) {
							pro = local_WordManager.GetProperties(info[0])
							value = info[1]
						} else {
							pro = WordManager.GetEquipPos(this.goods_vo.equip_type) + "强化"
							value = (info[1] / 100) + "%"
						}
						if (!smelt_str) {
							smelt_str = pro + ("+") + value
						} else {
							smelt_str = smelt_str + "\n" + pro + ("+") + value
						}
					}
				}
				this.smelt_pro_text.text = smelt_str
			} else {
				this.smelt_conta.visible = false
				this.smelt_conta.height = -15
				// this.smelt_conta.includeInLayout = false
			}
		}
		//设置武防套装属性
		this.SetSuitPro1 = () => {
			let list = []
			let cur_num = 0
			if (_dynamic && !_dynamic.sell_type && _dynamic.suit_list) {
				list = _dynamic.suit_list
			}
			if (list.length > 0) {
				if (!_suit_item_list) {
					_suit_item_list = []
				}
				this.suit_conta.visible = true
				// this.suit_conta.height = 0
				//this.suit_conta.includeInLayout = true
				table.sort(list, (a?, b?) => {
					return a.suit_count < b.suit_count
				})
				let suitModel: SuitModel = SuitModel.GetInstance();
				let pos: number = this.goods_vo.equip_type;
				let suitType = EquipModel.GetInstance().GetSuitType(pos);
				let attrs: any[] = [];
				if (suitModel.GetIsEquip(pos)) {
					for (let i = EnumSubType.eOne; i <= EnumSubType.eThree; i++) {
						let attrList: any[] = suitModel.GetSuitTypeMaxAttrs(pos, EnumSuitType.eEquip, i, list);
						if (attrList.length >= 0) {
							attrs = attrs.concat(attrList);
						}
					}
				} else {
					attrs = attrs.concat(suitModel.GetSuitTypeMaxAttrs(pos, EnumSuitType.eFairyDevice, EnumSubType.eOne, list))
				}
				this.suit_pro_conta.visible = attrs.length > 0;
				this.suit_conta.visible = attrs.length > 0;
				for (let index = 0; index < attrs.length; index++) {
					const info = attrs[index];
					let item: EquipSuitAttrItem = _suit_item_list[index]
					if (!item) {
						item = new EquipSuitAttrItem(this.suit_pro_conta)
						item.ExcuteCallback(() => {
							item.height = item._lb_num.height + item.attrText.height + item._lb_title.height + 20;
							this.suit_pro_conta.refresh();
						})
						_suit_item_list[index] = item;
						item.Load();
					}
					item.SetData(info, suitType);
				}
				this.suit_pro_conta.refresh();

				// for (let k in countList) {
				// 	let suitData = countList[k]
				// 	let item = _suit_item_list[index]
				// 	let info = list[index]
				// 	if (!item) {
				// 		item = new EquipSuitAttrItem(this.suit_pro_conta)
				// 		item.Load()
				// 		item.ExcuteCallback(() => {
				// 			item.height = item._lb_num.height + item.attrText.height
				// 			this.suit_pro_conta.refresh()
				// 		})
				// 		_suit_item_list[index] = item
				// 	}
				// 	item.SetVisible(true)
				// 	item.SetData(info, suitData, suitType)
				// 	index = index + 1
				// }
			} else {
				this.suit_conta.visible = false
				this.suit_conta.height = -15
				// this.suit_conta.includeInLayout = false
			}
		}
		//设置饰品套装属性
		this.SetSuitPro2 = () => {
			ResManager.GetInstance().LoadGameConfig(this, "config_equip_suit_item", false, null, (cfg) => {
				let list = []
				let cur_num = 0
				if (_dynamic && !_dynamic.sell_type) {
					let suit_type = equip_model.GetSuitType(_dynamic.equip_type)
					let sdata = equip_model.GetSuitDataByDynamic(_dynamic, 2)
					let sult_cfg = cfg//Config.Equipsuititem
					let scfg = equip_model.GetSuitCfg(suit_type, 2, sdata.suit_slv, sult_cfg)
					if (scfg) {
						cur_num = sdata.suit_count
						list = ErlangParser.GetInstance().Parse(scfg.attr_list)
						let name = EquipDefine.SUIT_NAME_CFG[sdata.suit_lv]
						this.suit2.text = "【" + name + "】" + scfg.slv + "阶共鸣(" + cur_num + "/" + scfg.max_count + ")"
					}
				}
				if (list.length > 0) {
					if (!_suit_item_list2) {
						_suit_item_list2 = []
					}
					this.suit_conta2.visible = true
					this.suit_conta2.height = 0
					//this.suit_conta2.includeInLayout = true
					let i = 0
					do {
						let item = _suit_item_list2[i]
						let info = list[i]
						if (!item) {
							item = new EquipSuitAttrItem(this.suit_pro_conta2)
							item.Load()
							item.ExcuteCallback(() => {
								this.suit_pro_conta.refresh()
							})
							_suit_item_list2[i] = item
						}
						item.SetVisible(true)
						item.SetData(info, cur_num)
						i = i + 1
					} while ((i < list.length))
				} else {
					this.suit_conta2.visible = false
					this.suit_conta2.height = -15
					//this.suit_conta2.includeInLayout = false
				}
			})

		}

		this.SetGodEquipPro = () => {
			if (_god_lv != null && _god_lv > 0) {
				this.god_conta.visible = true
				this.god_conta.height = 0
				// this.god_conta.includeInLayout = true
				let [tips, title] = equip_model.showTipsAttr2(this.cfg_god_equip_cfg, this.goods_vo, _god_lv)
				this.godPro.innerHTML = tips
				//this.godPro.height = this.godPro.textHeight
				//this.line9.y = this.godPro.y + this.godPro.height + 12
				//this.god_conta.height = this.line9.height + this.line9.y + 4
				this.god_title.text = title + " 属性加成"
			} else {
				let [tips, title, show] = equip_model.showTipsAttr(this.cfg_god_equip_cfg, this.goods_vo)
				if (show) {
					this.god_conta.visible = true
					this.god_conta.height = 0
					// this.god_conta.includeInLayout = true
					this.godPro.innerHTML = tips
					//this.godPro.height = this.godPro.textHeight
					//this.line9.y = this.godPro.y + this.godPro.height + 12
					//this.god_conta.height = this.line9.height + this.line9.y + 4
					this.god_title.text = title + " 属性加成"
				} else {
					this.god_conta.visible = false
					this.god_conta.height = -15
					// this.god_conta.includeInLayout = false
				}
			}
			this.godPro.width = 340
		}

		this.SetRedPro = () => {
			let cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_equip_attr.name, this.goods_vo.type_id, false, this.equip_attr)
			let list = cfg && erlang_parser.Parse(cfg.other_attr) || []
			if (list.length > 0) {
				this.spec_conta.visible = true
				let str = Util.GetAttrStr(list, "'#d15e00'")
				this.specPro.innerHTML = Util.StrToHTML(str)
				this.specPro.width = 310
				this.specPro.height = this.specPro.contextHeight
				let star = equip_model.GetStarByTypeId(this.goods_vo.type_id, this.equip_attr)
				let color = local_ColorUtil.GetColorNameOne(this.goods_vo.color)
				this.spec.text = color + star + "专有属性"

				this.spec_conta.height = this.specPro.contextHeight + this.specPro.y+3
			} else {
				this.spec_conta.visible = false
				this.spec_conta.height = 1
			}
		}

		this.Local_RefreshBtnState = () => {
			let btn = null
			let i = 0
			if (this.show_btn_list.length > 0) {
				do {
					let show = Util.TableContains(this.show_btn_list, i) // this.show_btn_list[i] != -1
					btn = this.btn_conta.getChildAt(i)
					if (btn) {
						btn.visible = show
						// btn.includeInLayout = show
					}
					i = i + 1
				} while ((i < this.btn_conta.numChildren))
			}

			RefGridLayout(this.btn_conta, {
				column: 2,
				h_gap: 6,
				v_gap: 0,
				item_w: 131,
				item_h: 65,
				frist_item_space: 26
			})

			//穿戴和上架互换位置
			if (this.replaceBtn.visible && this.upShelfBtn.visible) {
				let temp_x = this.replaceBtn.x
				let temp_y = this.replaceBtn.y

				this.replaceBtn.x = this.upShelfBtn.x
				this.replaceBtn.y = this.upShelfBtn.y

				this.upShelfBtn.x = temp_x
				this.upShelfBtn.y = temp_y
			}

		}

		this.GetBestProNum = () => {
			let num = 0
			let basic = goods_model.GetGoodsBasicByTypeId(this.type_id)
			if (basic) {
				if (basic.color == 3) {
					num = 1
				} else if (basic.color == 4) {
					num = 2
				} else if (basic.color == 5 || basic.color == 6) {
					num = 3
				} else if (basic.color == 7) {
					num = 4
				}
			}
			return num
		}

		this.ClearReBuildTimer = () => {
			if (this.RebuildTimer) {
				clearTimeout(this.RebuildTimer)
				this.RebuildTimer = null
			}
		}

	}

	public InitEvent() {

		this.Local_InitEvent()
	}

	public customFunction() {

		this.Local_customFunction()
	}

	public InitView() {

		this.Local_InitView()
	}

	public RefreshBtnState() {

		this.Local_RefreshBtnState()
	}

	public SetBaseAttBool(bool?) {
		this.is_show_base_att = bool
	}


	equip_conta: Laya.Box
	bg: Laya.Image
	nameBG: Laya.Image
	icon: Laya.Box
	equip_name: Laya.Label
	score: Laya.HTMLDivElement
	level: Laya.HTMLDivElement
	content_scroll: Laya.Panel
	content_group: Laya.VBox
	best_conta: Laya.Box
	line2: Laya.Image
	best: Laya.Label
	best_pro_conta: Laya.VBox
	refine: Laya.Label
	refine_pro_conta: Laya.Label
	base_pro_conta: Laya.Box
	line1: Laya.Image
	base: Laya.Label
	basePro: Laya.HTMLDivElement
	_html_stren: Laya.HTMLDivElement
	spec_conta: Laya.Box
	line8: Laya.Image
	spec: Laya.Label
	specPro: Laya.HTMLDivElement
	god_conta: Laya.Box
	line9: Laya.Image
	god_title: Laya.Label
	godPro: Laya.HTMLDivElement
	stone_conta: Laya.Box
	line3: Laya.Image
	stone: Laya.Label
	stone_pro_conta: Laya.VBox
	wash_conta: Laya.Box
	line4: Laya.Image
	wash: Laya.Label
	washText: Laya.HTMLDivElement
	smelt_conta: Laya.Box
	line5: Laya.Image
	_Label1: Laya.Label
	smelt_pro_text: Laya.Label
	suit_conta: Laya.Box
	line6: Laya.Image
	suit: Laya.Label
	suit_pro_conta: Laya.VBox
	suit_conta2: Laya.Box
	line7: Laya.Image
	suit2: Laya.Label
	suit_pro_conta2: Laya.VBox
	_Image3: Laya.Image
	career: Laya.HTMLDivElement
	pos_part: Laya.Label
	pos: Laya.Label
	btn_conta: Laya.Box
	replaceBtn: Laya.Box
	closeBtn: Laya.Box
	donateBtn: Laya.Box
	destroyBtn: Laya.Box
	exchangeBtn: Laya.Box
	UninstallBtn: Laya.Box
	upShelfBtn: Laya.Box
	outShelfBtn: Laya.Box
	UninstallBtn_spirit: Laya.Box
	sellBtn: Laya.Box
	treasureReceiveBtn: Laya.Box
	depositBtn: Laya.Box
	takeoutBtn: Laya.Box
	guild_conta: Laya.Box
	guildExchangeBtn: Laya.Box
	_guild_Image111: Laya.Image
	_guild_labelDisplay11: Laya.Label
	guildDonateBtn: Laya.Box
	_guild_Image11: Laya.Image
	_guild_labelDisplay: Laya.Label
	guild_score: Laya.HTMLDivElement
	sc_img: Laya.Image
	grade: Laya.Label
	lb_level: Laya.Label
	public GetComponents() {
		[
			this.equip_conta,
			this.bg,
			this.nameBG,
			this.icon,
			this.equip_name,
			this.score,
			this.level,
			this.content_scroll,
			this.content_group,
			this.best_conta,
			this.line2,
			this.best,
			this.best_pro_conta,
			this.refine,
			this.refine_pro_conta,
			this.base_pro_conta,
			this.line1,
			this.base,
			this.basePro,
			this._html_stren,
			this.spec_conta,
			this.line8,
			this.spec,
			this.specPro,
			this.god_conta,
			this.line9,
			this.god_title,
			this.godPro,
			this.stone_conta,
			this.line3,
			this.stone,
			this.stone_pro_conta,
			this.wash_conta,
			this.line4,
			this.wash,
			this.washText,
			this.smelt_conta,
			this.line5,
			this._Label1,
			this.smelt_pro_text,
			this.suit_conta,
			this.line6,
			this.suit,
			this.suit_pro_conta,
			this.suit_conta2,
			this.line7,
			this.suit2,
			this.suit_pro_conta2,
			this._Image3,
			this.career,
			this.pos_part,
			this.pos,
			this.btn_conta,
			this.replaceBtn,
			this.closeBtn,
			this.donateBtn,
			this.destroyBtn,
			this.exchangeBtn,
			this.UninstallBtn,
			this.upShelfBtn,
			this.outShelfBtn,
			this.UninstallBtn_spirit,
			this.sellBtn,
			this.treasureReceiveBtn,
			this.depositBtn,
			this.takeoutBtn,
			this.guild_conta,
			this.guildExchangeBtn,
			this._guild_Image111,
			this._guild_labelDisplay11,
			this.guildDonateBtn,
			this._guild_Image11,
			this._guild_labelDisplay,
			this.guild_score,
			this.sc_img,
			this.grade,
			this.lb_level,
		]
			= this.GetChildrenByNames([

				"equip_conta",
				"bg",
				"nameBG",
				"icon",
				"equip_name",
				"score",
				"level",
				"content_scroll",
				"content_group",
				"best_conta",
				"line2",
				"best",
				"best_pro_conta",
				"refine",
				"refine_pro_conta",
				"base_pro_conta",
				"line1",
				"base",
				"basePro",
				"_html_stren",
				"spec_conta",
				"line8",
				"spec",
				"specPro",
				"god_conta",
				"line9",
				"god_title",
				"godPro",
				"stone_conta",
				"line3",
				"stone",
				"stone_pro_conta",
				"wash_conta",
				"line4",
				"wash",
				"washText",
				"smelt_conta",
				"line5",
				"_Label1",
				"smelt_pro_text",
				"suit_conta",
				"line6",
				"suit",
				"suit_pro_conta",
				"suit_conta2",
				"line7",
				"suit2",
				"suit_pro_conta2",
				"_Image3",
				"career",
				"pos_part",
				"pos",
				"btn_conta",
				"replaceBtn",
				"closeBtn",
				"donateBtn",
				"destroyBtn",
				"exchangeBtn",
				"UninstallBtn",
				"upShelfBtn",
				"outShelfBtn",
				"UninstallBtn_spirit",
				"sellBtn",
				"treasureReceiveBtn",
				"depositBtn",
				"takeoutBtn",
				"guild_conta",
				"guildExchangeBtn",
				"_guild_Image111",
				"_guild_labelDisplay11",
				"guildDonateBtn",
				"_guild_Image11",
				"_guild_labelDisplay",
				"guild_score",
				"sc_img",
				"grade",
				"lb_level",
			])
	}
}
window["EquipToolTips"] = EquipToolTips

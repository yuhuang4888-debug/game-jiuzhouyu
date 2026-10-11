
////////////////////////////////////////////////////////////////////-
// u3d (C) CompanyName, All Rights Reserved
// Created by: AuthorName
// Date: 2020-08-14 11.15:17
////////////////////////////////////////////////////////////////////-


import { BaseItem1 } from "../common/BaseItem1"
import { EquipmentItem } from "../common/EquipmentItem"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { EquipModel, EquipDefine, EquipEvent } from "../commonModel/EquipModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { InnateInfoItem } from "../innateSkill/InnateInfoItem"
import { Message } from "../sysInfo/SysInfoController"
import { TaskFinishView } from "../task/TaskFinishView"
import { Enum_ColorUtil_Light, ColorUtil } from "../util/ColorUtil"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { Util, SetAnchoredPositionX, GlobalTimerQuest, SetAnchoredPosition } from "../util/Util"
import { EquipSuitAttrEffItem } from "./EquipSuitAttrEffItem"
import { EquipSuitAwardItem } from "./EquipSuitAwardItem"
import { EquipSuitCostItem } from "./EquipSuitCostItem"

// To edit this template in: Data/Config/Template.lua
// To disable this template, check off menuitem: Options-Enable Template File

//-@class JewelrySuitView
//饰品共鸣
export class JewelrySuitView extends BaseItem1 {
	Image333: Laya.Image
	_img_bg: Laya.Image
	_Image1: Laya.Image
	_Image2: Laya.Image
	_Image3: Laya.Image
	_Image5: Laya.Image
	img7: Laya.Image
	matcon_bg: Laya.Image
	Image: Laya.Image
	_Image4: Laya.Image
	_Image6: Laya.Image
	_img_max: Laya.Image
	_btn_back: Laya.Image
	_lb_type: Laya.Label
	_lb_stage: Laya.Label
	nameText: Laya.HTMLDivElement
	maxText: Laya.Label
	upCon: Laya.Box
	curLvText: Laya.Label
	nextLvText: Laya.Label
	Image1: Laya.Image
	_group_item: Laya.Box
	_img_show_bg: Laya.Image
	_img_show_icon: Laya.Image
	attrCon: Laya.HBox
	_btn_build: Laya.Box
	_img_btn: Laya.Image
	_reddot: Laya.Image
	_lb_btn: Laya.Label
	_scroll_equip: Laya.List
	matCon: Laya.Box
	_group_eff: Laya.Box
	line: Laya.Image
	name_con: Laya.Box
	ChangeCondTextByList
	CheckLimitBySlv
	ClearCostItems
	ClickEquipHandle
	Eff_list_equip
	Emp_btn_build
	GetEquipInfos
	InitEvent
	LoadSuccess
	Out_lb_btn
	Scr_scroll_equip
	UpdateAttrItems
	UpdateBtnRedStauts
	UpdateCostItems
	UpdateEquipItems
	UpdateShowData
	UpdateView


	attrItemList
	cost_item_list_
	list_equip_loop_mgr
	show_item_


	public static MatPosXList = [[150], [25, 243], [-4, 137, 273]]
	public constructor(parent?) {
		super(parent)

		this.base_file = "suit"
		this.layout_file = "JewelrySuitView"

		let model = EquipModel.GetInstance()
		let local_EquipDefine = EquipDefine
		let local_Message = Message
		let local_EquipEvent = EquipEvent
		let goods_model = GoodsModel.GetInstance()
		let local_Enum_ColorUtil_Light = Enum_ColorUtil_Light
		let _ac_equip_ = null
		let _ac_attr_ = null
		let _ac_group_attr_loop_list = null
		let _cur_equip_info_ = null
		let _cur_slv_ = 1
		let _suit_type_ = 1
		let _cur_equip_type_ = 2
		let _is_max_ = false
		let _is_unlock_ = false
		let init_select
		this.show_item_ = null
		this.cost_item_list_ = []

		this.load_callback = () => {

			this.LoadSuccess()
		}

		this.InitEvent = () => {
			Util.AddClickEvent(
				this._btn_build, () => {
					if (!_cur_equip_info_) {
						Message.show("当前未穿戴装备")
						return
					}
					//// [ts2lua]local_EquipDefine.SUIT_NAME_CFG下标访问可能不正确
					//let name = local_EquipDefine.SUIT_NAME_CFG[_suit_type_]
					//let equip_attr_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "Equipattr", false)
					//let suit_stage_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "Equipsuitstage", false)
					//let suit_stage_decor_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "Equipsuitstagedecor", false)
					//let sstage = model.GetSuitMaxStageByTypeId(_cur_equip_info_.type_id, equip_attr_cfg, suit_stage_cfg, suit_stage_decor_cfg)
					//let stage = model.GetStageByTypeId(_cur_equip_info_.type_id, equip_attr_cfg)
					//local_Message:show(stage + "阶装备最高可打造" + sstage + "级" + name)
					//let mType = model.GetDownRedTypeBySuitLv(_suit_type_)
					//let is_down = model.CheckSuitRedStatus(mType, _cur_equip_info_.equip_type)
					//if (is_down ) {
					//Alert.Show(
					//"当前操作可能会导致战力降低，是否确认继续？\n（推荐同时打造" + HtmlColorTxt("2/4/6件相同级数", Enum_ColorUtil_Dark.RED) + "的共鸣）",
					//Alert_Type.Two,
					//function()
					//model:Fire(local_EquipEvent.REQUEST_PROTO, 15221, "cc", _suit_type_, _cur_equip_info_.equip_type)
					//}
					//)
					//}else{
					model.Fire(local_EquipEvent.REQUEST_PROTO, 15221, "cc", _suit_type_, _cur_equip_info_.equip_type)
					//}
				},
				this,
				true
			)
			Util.AddClickEvent(
				this._btn_back, () => {
					if (!_cur_equip_info_) {
						return
					}
					model.Fire(local_EquipEvent.OPEN_VIEW, "EquipSuitReturnView", _cur_equip_info_, _suit_type_)
				},
				this,
				true
			)
			this.BindVar(
				model,
				"suit_info", () => {
					this.UpdateView()
				}
			)
			this.BindEvent(
				model,
				local_EquipEvent.BUILD_SUIT_SUCCESS, () => {
					this.UpdateView()
					this.ClearUIEffect(this._group_eff);
					this._group_eff.visible = true;
					this.AddUIEffect("QiangHua", this._group_eff, { x: -1, y: -1 }, 7, false, 0.5, () => {
						this._group_eff.visible = false;
					});

				}
			)
			this.BindEvent(
				model,
				local_EquipEvent.BACK_SUIT_SUCCESS, () => {
					this.UpdateView()
				}
			)
			this.BindEvent(
				model,
				local_EquipEvent.UPDATE_SUIT_COND, () => {
					this.UpdateView()
				}
			)
		}

		this.LoadSuccess = () => {

			// ResManager.GetInstance().SetOutsideImageSprite(this, this._Image1, "resource/game/composite/uidz_016.png")

			// ResManager.GetInstance().SetOutsideImageSprite(this, this._Image3, "resource/game/composite/uirw_093a.png")
			// ResManager.GetInstance().SetOutsideImageSprite(this, this._Image4, "resource/game/suit/suitbg.png")
			// ResManager.GetInstance().SetOutsideImageSprite(this, this._Image5, "resource/game/composite/uirw_093a.png")


			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, "resource/game/bigBg/ui_merge_bg.jpg")
			this._Image2.visible = false
			if (!this.show_item_) {
				this.show_item_ = new EquipmentItem(this._group_item)
				this.show_item_.SetItemSize(101, 101)
				this.show_item_.Load()
				this.show_item_.SetVisible(false)
			}
			this.InitEvent()
			this.UpdateEquipItems(true)
			this.UpdateBtnRedStauts()

			init_select = GlobalTimerQuest.AddDelayQuest(() => {
				GlobalTimerQuest.CancelQuest(init_select)
				init_select = null
				if (this.use_delete_method) return
				this.UpdateEquipItems()
				if (this.list_equip_loop_mgr) {
					// this.UpdateShowData({ item: this.Content.$children[0] })
					this.UpdateShowData(0)
				}
				this.UpdateBtnRedStauts()
			}, 0.3)

		}

		this.ClickEquipHandle = (e?) => {
			this.UpdateShowData(e)
			// this.list_equip_loop_mgr.soureArr.refresh()
		}

		this.CheckLimitBySlv = (slv?) => {
			let cfg = model.GetSuitCfg(_cur_equip_type_, _suit_type_, slv)
			return !cfg//!(not cfg)
		}

		this.UpdateView = () => {
			this.UpdateEquipItems()
			if (this.list_equip_loop_mgr) {
				// this.UpdateShowData({ item: this.Content.$children[this.Content.selectedIndex] })
				this.UpdateShowData(this.list_equip_loop_mgr.parent.selectedIndex)
			}
			this.UpdateBtnRedStauts()
		}

		this.UpdateBtnRedStauts = () => {
			//let red_list = this.GetEquipTypeRedStatus()
			//for (let i = 1; i <= this.child_count; i++){
			//this["objradio" + i .. "_reddot"].visible = red_list[i] 
			//}
		}


		this.GetEquipInfos = () => {
			let list = []
			let dic = []
			let i = 0
			do {
				let pos = local_EquipDefine.EQUIP_POS[i]
				let stype = model.GetSuitType(pos)
				if (stype == 2) {
					let dynamic = model.GetWearEquipDynamic(pos)
					table.insert(list, {
						is_empty: !dynamic, equip_type: pos, suit_lv: _suit_type_,
						dynamic: dynamic, stage: model.GetStageByTypeId(dynamic && dynamic.type_id), curLv: model.GetCurSuitsLv(pos)
					})
					dic[pos] = list.length
				}
				i = i + 1
			} while ((i < local_EquipDefine.EQUIP_POS.length))
			return list
		}

		this.UpdateEquipItems = (is_set_first?) => {
			let list = this.GetEquipInfos()

			if (!this.list_equip_loop_mgr) {
				this.list_equip_loop_mgr = new LoopScrowViewMgr()
				this.list_equip_loop_mgr.SetData(this._scroll_equip, EquipSuitAwardItem, list, LoopScrCon.Vertical, 1, (item?) => {
					this.ClickEquipHandle(item)
				})
				// this.Content.addEventListener(Laya.ItemTapEvent.ITEM_TAP, this.ClickEquipHandle, this)
			} else {
				this.list_equip_loop_mgr.replaceAll(list)
			}
			if (is_set_first && list.length > 0) {
				let redList = model.suitJewelRedList
				let index = 0
				if (redList) {
					for (let i = 0; i < list.length; i++) {
						let dynamic = list[i]
						let red = redList[dynamic.equip_type]
						if (red) {
							index = i
							break
						}
					}
				}
				// this.list_equip_loop_mgr.SetSelectIndex(index)
				this.ClickEquipHandle(0)
			}
		}

		this.UpdateCostItems = (equipInfo?) => {
			let sdata = model.GetSuitDataByDynamic(equipInfo.dynamic, _suit_type_)
			let cost_cfg = model.GetSuitMakeCost(equipInfo.equip_type, _suit_type_, equipInfo.curLv + 1)
			this.ClearCostItems()
			if (!cost_cfg) {
				return
			}
			// for (let index = 0; index < 1; index++) {
			// 	let info = cost_cfg[index]
			// 	let item = this.cost_item_list_[index]
			// 	if (!item) {
			// 		item = new EquipSuitCostItem(this.matCon)
			// 		item.Load()

			// 		this.cost_item_list_[index] = item
			// 	}
			// 	if (info) {
			// 		let num = Number(info[2])
			// 		let [type_id, lock] = goods_model.GetMappingTypeId(info[0], info[1])
			// 		let own = goods_model.GetTypeGoodsNum(type_id)
			// 		let color = own >= num && local_Enum_ColorUtil_Light.GREEN || local_Enum_ColorUtil_Light.RED
			// 		item.SetPosition(JewelrySuitView.MatPosXList[0][index], 16)
			// 		item.ExcuteCallback(() => {
			// 			item.SetData(type_id)
			// 			// SetAnchoredPosition(item.display_obj, JewelrySuitView.MatPosXList[0][index],8)
			// 			// item.SetNumberInFlow(own + "/" + num)
			// 			item.SetNumberInFlow(Util.StrToHTML(`<font color=${color}>${own}/${num}</font>`))
			// 		}
			// 		)
			// 		index = index + 1
			// 	}
			// }
		}

		this.ClearCostItems = () => {
			for (let _tmpi in this.cost_item_list_) {
				var item = this.cost_item_list_[_tmpi]
				item.SetLockStatus(false)
			}
		}

		this.UpdateShowData = (e?) => {
			if (!this.list_equip_loop_mgr.parent._array) {
				return
			}
			let item = this.list_equip_loop_mgr.parent._array[e]
			let info = item
			_cur_equip_info_ = info.dynamic
			let dynamic = info.dynamic
			let is_empty = !dynamic
			if (!is_empty) {
				let sdata = model.GetSuitDataByDynamic(dynamic, _suit_type_)
				let curLv = info.curLv
				let actived = curLv > 0
				let canActive = model.JewelSuitCanUp(dynamic)
				let is_top_max = curLv >= local_EquipDefine.SUIT_MAX_SLV
				//let suit_stage_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "Equipsuitstage", false)
				//let suit_stage_decor_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "Equipsuitstagedecor", false)
				//let stage = model.GetSuitMaxStageByTypeId(dynamic.type_id, equip_attr_cfg, suit_stage_cfg, suit_stage_decor_cfg)
				//let has_data = this.CheckLimitBySlv(dynamic)
				//_is_max_ =  //(stage > 0) && sdata.suit_slv >= stage || ! has_data
				//this._group_lv.visible = ! _is_max_ 
				// [ts2lua]lua中0和空字符串也是true，此处_is_max_需要确认
				//this._lb_lv_max.text = (_is_max_ && ( sdata.suit_slv + "级" + name + "(当前最高)" ) || ( "" ) )
				//this._btn_back.visible = has_suit 
				// [ts2lua]lua中0和空字符串也是true，此处has_suit需要确认
				// [ts2lua]lua中0和空字符串也是true，此处is_top_max需要确认
				//let unlock = true //model:IsUnLockSuit(dynamic, _suit_type_)
				// [ts2lua]lua中0和空字符串也是true，此处has_suit需要确认


				let lv_color = actived && "#8E6C5C" || "#9c9c9c" //local_Enum_ColorUtil_Light.GRAY
				// if (PlatformMgr.GetInstance().IsEyouThPlatform() ) {
				// 	this.curLvText.text = actived && ("เซ็ท" + "Lv." + curLv) || "ไม่ได้สร้าง"
				// 	this.nextLvText.text = is_top_max && "" || ( "เซ็ท" + ("Lv." + (curLv + 1) ))
				// }else{
				// 	this.curLvText.text = actived && (curLv + "级共鸣") || "未打造"
				// 	this.nextLvText.text = is_top_max && "" || ( (curLv + 1 ) + "级共鸣")
				// }
				this.curLvText.text = actived && (curLv + "级共鸣") || "未打造"
				this.nextLvText.text = is_top_max && "" || ((curLv + 1) + "级共鸣")

				// this.curLvText.color = ColorUtil.TryParseHtmlString(lv_color)
				this.upCon.visible = !is_top_max
				this.maxText.visible = is_top_max
				if (is_top_max) {
					this._btn_build.visible = false
					this._img_max.visible = false
				} else {
					this._btn_build.visible = true
					this._img_max.visible = false
				}

				this._btn_back.visible = actived
				//let lb_btn_text = "<font color=" + btn_color + ">" + this._lb_btn.text + "</font>"
				//this._lb_btn.color = ColorUtil.TryParseHtmlString(local_Enum_ColorUtil_Light.WHITE)

				// [ts2lua]lua中0和空字符串也是true，此处unlock需要确认
				//this._lb_btn.strokeColor = (unlock && ( "#CC7652" ) || ( "#7D7D7D" ) )
				Util.SetImageGray(this._img_btn, !canActive)
				this._lb_btn.stroke = !canActive ? 0 : 2
				// this.Out_lb_btn.effectColor = ColorUtil.TryParseHtmlString(canActive && "#D36A24" || local_Enum_ColorUtil_Light.GRAY)
				//if (! unlock && ! _is_max_ ) {
				//let stage, color, star = model.GetUnLockSuitCondition(dynamic, _suit_type_)
				//if (stage || color || star > 0 ) {
				//this:ChangeCondTextByList(stage, color, star)
				//}
				//this:ClearCostItems()
				//}else{
				this.UpdateCostItems(info)
				//}
				this.show_item_.ExcuteCallback(() => {
					this.show_item_.SetData(dynamic.type_id)
					this.show_item_.SetVisible(true)
				}
				)
				this.show_item_.SetClickCallBack(() => {
					UIToolTipMgr.GetInstance().AppendEquipTips(dynamic.type_id, null, null, dynamic, 1)
				}
				)
				this._img_show_icon.visible = false
				this._img_show_bg.visible = false
				this.UpdateAttrItems(info)
				this.nameText.width = 150
				this.nameText.innerHTML = Util.StrToHTML(GoodsModel.GetGoodsNameWithColorLight(dynamic.type_id))
				//let mType = model.GetRedTypeBySuitLv(_suit_type_)
				//let down_type = model.GetDownRedTypeBySuitLv(_suit_type_)
				//let is_down_red = model.CheckSuitRedStatus(down_type, dynamic.equip_type)
				//let equip_red = model.CheckSuitRedStatus(mType, dynamic.equip_type)
				//equip_red = equip_red && (! is_down_red)
				this._reddot.visible = model.GetJewelSuitRed(dynamic.equip_type)
			} else {
				this.nameText.width = 0
				this.nameText.innerHTML = ""
				this.show_item_.SetVisible(false)
				this._img_show_icon.visible = true
				this._img_show_bg.visible = true
				ResManager.GetInstance().SetImageSprite(this, this._img_show_icon, "equipCom_asset", "role_default_" + info.equip_type)
				this.UpdateCostItems(info)
				this.ClearCostItems()
				this._reddot.visible = false
				let cfg = model.GetSuitMakeCfg(info.equip_type, _suit_type_, 1)
				let [stage, color, star] = model.GetUnLockSuitConditionByCfg(cfg.condition)
				//this:ChangeCondTextByList(1, color, star)
				this._img_max.visible = false
				this._btn_build.visible = true
				this.UpdateAttrItems(info)
				// this.Out_lb_btn.effectColor = ColorUtil.TryParseHtmlString(local_Enum_ColorUtil_Light.GRAY)
				Util.SetImageGray(this._img_btn, true)
				this._lb_btn.stroke = 0
				this._btn_back.visible = false
				this.upCon.visible = false
				this.maxText.visible = false
			}
			this.SetHtmlCenterX(this.nameText, this.name_con.width)
		}

		//this.ChangeCondTextByList = ( stage?, color?, star?) => {
		//if (color ) {
		//color = Number(color)
		//}
		//let color_str = HtmlColorTxt(ColorUtil.GetColorName(color), ColorUtil.GetColorDark(color))
		//let stage_str = HtmlColorTxt(stage, Enum_ColorUtil_Dark.GREEN)
		//let star_str = HtmlColorTxt(star, Enum_ColorUtil_Dark.GREEN)
		////this._lb_cond.text = "佩戴" + color_str + stage_str + "阶" + star_str + "星以上装备才能打造"
		//}

		this.UpdateAttrItems = (equipInfo?, is_ctrl_slv?) => {
			let cfg
			if (equipInfo.curLv == 0) {
				cfg = model.GetSuitCfg(_cur_equip_type_, _suit_type_, 1)
				this._lb_stage.text = "1级共鸣"
			} else {
				cfg = model.GetSuitCfg(_cur_equip_type_, _suit_type_, equipInfo.curLv)
				// if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
				// 	this._lb_stage.text = "เซ็ท" + "Lv." + equipInfo.curLv
				// }else{
				// 	this._lb_stage.text = equipInfo.curLv + "级共鸣"
				// }
				this._lb_stage.text = equipInfo.curLv + "级共鸣"
			}
			let attr_list = cfg && JSON.parse(cfg.attr_list) || {}
			//let result = model.GetSuitNumAndEquips(equipInfo.dynamic.equip_type, _suit_type_, _cur_slv_)
			//let cur_num = result.num

			let curCount = 0
			let countList = []
			if (equipInfo.dynamic) {
				for (let key in equipInfo.dynamic.suit_list) {
					var v = equipInfo.dynamic.suit_list[key]
					if (v.suit_lv == _suit_type_ && (v.suit_slv >= equipInfo.curLv || (v.suit_slv == 1 && equipInfo.curLv == 0))) {
						countList[v.suit_count] = true
						//break
					}
				}
			}
			for (let _tmpi in attr_list) {
				var info = attr_list[_tmpi]
				info.isActive = countList[Number(info[0])]
				//info.curLv = curLv
			}
			if (!this.attrItemList) {
				this.attrItemList = []
			}

			for (let i = 0; i < 3; i++) {
				let newItem = this.attrItemList[i]
				if (!newItem) {
					newItem = new EquipSuitAttrEffItem(this.attrCon)
					newItem.Load()
					this.attrItemList[i] = newItem
				}
				newItem.SetData(attr_list[i], equipInfo)
			}

		}

	}

	public SetHtmlCenterX(html_obj?, w?) {
		if (!html_obj) {
			return
		}
		html_obj.x = w / 2 - html_obj.contextWidth / 2
	}
	public DeleteMe() {
		for (let key in this.cost_item_list_) {

			this.cost_item_list_[key].DeleteMe()
		}
		this.cost_item_list_ = []
		if (this.show_item_) {
			this.show_item_.DeleteMe()
			this.show_item_ = null
		}

		if (this.list_equip_loop_mgr) {
			this.list_equip_loop_mgr.DeleteMe()
			this.list_equip_loop_mgr = null
		}
		if (this.attrItemList) {
			for (let k in this.attrItemList) {
				var v = this.attrItemList[k]
				v.DeleteMe()
			}
			this.attrItemList = null
		}

		this.ClearUIEffect(this._group_eff);

		super.DeleteMe()
	}

	public GetComponents() {
		[
			this.Image333,
			this._img_bg,
			this._Image1,
			this._Image2,
			this._Image3,
			this._Image5,
			this.img7,
			this.matcon_bg,
			this.Image,
			this._Image4,
			this._Image6,
			this._img_max,
			this._btn_back,
			this._lb_type,
			this._lb_stage,
			this.name_con,
			this.nameText,
			this.maxText,
			this.upCon,
			this.curLvText,
			this.nextLvText,
			this.Image1,
			this._group_item,
			this._img_show_bg,
			this._img_show_icon,
			this.attrCon,
			this._btn_build,
			this._img_btn,
			this._reddot,
			this._lb_btn,
			this._scroll_equip,
			this.matCon,
			this._group_eff,
			this.line,
		]
			= this.GetChildrenByNames([

				"Image333",
				"_img_bg",
				"_Image1",
				"_Image2",
				"_Image3",
				"_Image5",
				"img7",
				"matcon_bg",
				"Image",
				"_Image4",
				"_Image6",
				"_img_max",
				"_btn_back",
				"_lb_type",
				"_lb_stage",
				"name_con",
				"nameText",
				"maxText",
				"upCon",
				"curLvText",
				"nextLvText",
				"Image1",
				"_group_item",
				"_img_show_bg",
				"_img_show_icon",
				"attrCon",
				"_btn_build",
				"_img_btn",
				"_reddot",
				"_lb_btn",
				"_scroll_equip",
				"matCon",
				"_group_eff",
				"line",
			])
		this.nameText.style.fontSize = 26
		this.nameText.style.color = "#fffffe"
		this.nameText.style.strokeColor = "#ffffff"
		this.nameText.style.stroke = 1
		this.nameText.style.valign = "middle"
		this.nameText.style.align = "center"

	}
}
window["JewelrySuitView"] = JewelrySuitView

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
import { EnumPushGiftType, PushGiftModel } from "../commonModel/PushGiftModel"
import { SuitModel } from "../commonModel/SuitModel"
import { GiftPushIcon } from "../mainUI/GiftPushIcon"
import { Message } from "../sysInfo/SysInfoController"
import { Enum_ColorUtil_Light, ColorUtil } from "../util/ColorUtil"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { SetAnchoredPosition, SetSizeDeltaX, Util, SetAnchoredPositionX, GlobalTimerQuest } from "../util/Util"
import { EquipSuitAttrEffItem } from "./EquipSuitAttrEffItem"
import { EquipSuitAwardItem } from "./EquipSuitAwardItem"
import { EquipSuitCostItem } from "./EquipSuitCostItem"

// To edit this template in: Data/Config/Template.lua
// To disable this template, check off menuitem: Options-Enable Template File

//-@class EquipSuitView
//武防套装
export class EquipSuitView extends BaseItem1 {
	Image333: Laya.Image
	_Image7: Laya.Image
	matcon_bg: Laya.Image
	ChangeCondTextByList
	CheckLimitBySlv
	ClearCostItems
	ClickEquipHandle
	CustomMehod
	Eff_list_equip
	Emp_btn_build
	GetEquipInfos
	Image
	InitEvent
	LoadSuccess
	Out_lb_btn
	RawImage
	Scr_scroll_equip
	UpdateAttrItems
	UpdateCostItems
	UpdateEquipItems
	UpdateShowData
	UpdateView
	_Image1
	_Image2
	_Image3
	_Image4
	_Image5
	_Image6
	_Label1
	_btn_back
	_btn_build
	_group_eff
	_group_item
	_img_bg
	_img_btn
	_img_max
	_img_show_bg
	_img_show_icon
	_lb_btn
	_lb_stage
	_lb_type
	_list_equip
	_reddot
	_scroll_equip: Laya.List
	attrCon
	attrItemList
	cost_item_list_
	img2
	img3
	list_equip_loop_mgr
	matCon
	nameText: Laya.HTMLDivElement
	name_con
	show_item_

	private giftItem: GiftPushIcon;

	public static MatPosXList = [[150], [38, 256], [18, 150, 288]]
	public constructor(parent?) {
		super(parent)

		this.base_file = "suit"
		this.layout_file = "EquipSuitView"

		let model = EquipModel.GetInstance()
		let local_EquipDefine = EquipDefine
		let local_EquipEvent = EquipEvent
		let local_Message = Message
		let goods_model = GoodsModel.GetInstance()
		let local_Enum_ColorUtil_Light = Enum_ColorUtil_Light
		let _cur_equip_info_ = null
		let suitLv = 1
		//套装类型  1 武防 2 饰品
		let suitType = 1
		let _is_max_ = false
		//当前选中的装备是否已经打造
		let hasActived = false
		this.show_item_ = null
		this.cost_item_list_ = []
		let init_select

		this.load_callback = () => {

			this.LoadSuccess()
			// if (PlatformMgr.GetInstance().IsEyouEnPlatform()) {
			// 	SetAnchoredPosition(this._Label1, 274, -654)
			// 	let csf = this._Label1.GetComponent("ContentSizeFitter")
			// 	csf.horizontalFit = UnityEngine.UI.ContentSizeFitter.FitMode.Unconstrained
			// 	SetSizeDeltaX(this._Label1, 430)
			// 	this._Label1.verticalAlign = "top"
			// 	this._Label1.textAlign = "left"
			// 	this._Label1.lineSpacing = 0.7
			// }


		}
		this.CustomMehod = (index?, parms?) => {
			[suitType, suitLv] = [...parms];
		}

		this.InitEvent = () => {

			this.BindEvent(PushGiftModel.GetInstance(), PushGiftModel.UPDATE_ICON, (giftId: number) => {
				this.ShowGiftIcon();
			})

			Util.AddClickEvent(
				this._btn_build, () => {
					if (!_cur_equip_info_) {
						Message.show("当前未穿戴装备")
						return
					}
					if (hasActived) {
						Message.show("当前已打造【" + EquipDefine.SUIT_NAME_CFG[suitLv] + "】共鸣")
						return
					}
					//// [ts2lua]local_EquipDefine.SUIT_NAME_CFG下标访问可能不正确
					//let name = local_EquipDefine.SUIT_NAME_CFG[suitLv]
					//let equip_attr_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "Equipattr", false)
					//let suit_stage_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "Equipsuitstage", false)
					//let suit_stage_decor_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "Equipsuitstagedecor", false)
					//let sstage = model.GetSuitMaxStageByTypeId(_cur_equip_info_.type_id, equip_attr_cfg, suit_stage_cfg, suit_stage_decor_cfg)
					//let stage = model.GetStageByTypeId(_cur_equip_info_.type_id, equip_attr_cfg)
					//local_Message:show(stage + "阶装备最高可打造" + sstage + "级" + name)
					//let mType = model.GetDownRedTypeBySuitLv(suitLv)
					//let is_down = model.CheckSuitRedStatus(mType, _cur_equip_info_.equip_type)
					//if (is_down ) {
					//Alert.Show(
					//"当前操作可能会导致战力降低，是否确认继续？\n（推荐同时打造" + HtmlColorTxt("2/4/6件相同级数", Enum_ColorUtil_Dark.RED) + "的套装）",
					//Alert_Type.Two,
					//function()
					//model:Fire(local_EquipEvent.REQUEST_PROTO, 15221, "cc", suitLv, _cur_equip_info_.equip_type)
					//}
					//)
					//}else{
					model.Fire(local_EquipEvent.REQUEST_PROTO, 15221, "cc", suitLv, _cur_equip_info_.equip_type)
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
					model.Fire(local_EquipEvent.OPEN_VIEW, "EquipSuitReturnView", _cur_equip_info_, suitLv)
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
					this.AddUIEffect("ui_gongmingchenggong", this._group_eff, undefined, 4, false, 1, undefined, undefined, undefined, undefined, undefined, undefined, false)
					this.ClearUIEffect(this._group_eff1);
					this._group_eff1.visible = true;
					this.AddUIEffect("QiangHua", this._group_eff1, { x: -1, y: -1 }, 7, false, 0.5, () => {
						this._group_eff1.visible = false;
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
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, "resource/game/bigBg/ui_merge_bg.jpg")
			ResManager.GetInstance().SetImageSprite(this, this._Image1, "suit", "ui_role_45")
			ResManager.GetInstance().SetTexture(this, this.line, GameResPath.GetIcon("suit", "com_line_1"))
			// ResManager.GetInstance().SetOutsideImageSprite(this, this._Image3, "resource/game/composite/uirw_093a.png")
			// ResManager.GetInstance().SetOutsideImageSprite(this, this._Image5, "resource/game/composite/uirw_093a.png")
			let titleRes = "uizbtz_005"
			if (suitLv == 2) {
				titleRes = "uizbtz_006"
			} else if (suitLv == 3) {
				titleRes = "uizbtz_007"
			}
			ResManager.GetInstance().SetImageSprite(this, this.img2, "suit", titleRes, true)
			ResManager.GetInstance().SetImageSprite(this, this._img_name_top, "suit", titleRes, true)
			// ResManager.GetInstance().SetOutsideImageSprite(this, this.img3, GameResPath.GetIcon("suit", titleRes))
			// ResManager.GetInstance().SetImageSprite(this, this.img2, "suit", titleRes)
			// ResManager.GetInstance().SetImageSprite(this, this.img3, "suit", titleRes)

			if (!this.show_item_) {
				this.show_item_ = new EquipmentItem(this._group_item)
				this.show_item_.SetItemSize(101, 101)
				this.show_item_.Load()
				this.show_item_.SetVisible(false)
			}
			this.InitEvent()
			this.UpdateEquipItems(true)
			init_select = GlobalTimerQuest.AddDelayQuest(() => {
				GlobalTimerQuest.CancelQuest(init_select)
				init_select = null
				if (this.use_delete_method) return
				this.UpdateEquipItems()
				if (this.list_equip_loop_mgr) {
					// this.UpdateShowData({ item: this.Content.$children[0] })
					this.UpdateShowData(0)
				}
			}, 0.3)
			this.ShowGiftIcon();
		}

		this.ClickEquipHandle = (e?) => {
			this.UpdateShowData(e)
			// this.list_equip_loop_mgr.soureArr.refresh()
		}

		this.CheckLimitBySlv = (slv?) => {
			let cfg = model.GetSuitCfg(suitType, suitLv, slv)
			return !cfg//!(not cfg)
		}

		this.UpdateView = () => {
			this.UpdateEquipItems()
			if (this.list_equip_loop_mgr) {
				// this.UpdateShowData({ item: this.Content.$children[this.Content.selectedIndex] })
				this.UpdateShowData(this.list_equip_loop_mgr.parent.selectedIndex)
				// this.UpdateShowData({item:this._scroll_equip})
				// this.list_equip_loop_mgr.SetSelectIndex(this.Content.selectedIndex)
			}
		}

		this.GetEquipInfos = () => {
			/* let list = []
			let dic = []
			let i = 0
			do {
				let pos = local_EquipDefine.EQUIP_POS[i]
				let stype = model.GetSuitType(pos)
				if (stype == 1) {
					let dynamic = model.GetWearEquipDynamic(pos)
					table.insert(list, {
						is_empty: !dynamic, equip_type: pos, suit_lv: suitLv,
						dynamic: dynamic, isEquipType: true, stage: model.GetStageByTypeId(dynamic && dynamic.type_id)
					})
					dic[pos] = list.length
				}
				i = i + 1
			} while ((i < local_EquipDefine.EQUIP_POS.length)
			)
			return list */

			return SuitModel.GetInstance().GetEquipInfos(suitType,suitLv);

		}


		this.UpdateEquipItems = (is_set_first?) => {
			let list = this.GetEquipInfos()

			if (!this.list_equip_loop_mgr) {
				this.list_equip_loop_mgr = new LoopScrowViewMgr()
				this.list_equip_loop_mgr.SetData(this._scroll_equip, EquipSuitAwardItem, list, LoopScrCon.Vertical, 1, (item?) => {
					this.ClickEquipHandle(item)
				})
				// this.Content.addEventListener(Laya.ItemTapEvent.ITEfM_TAP, this.ClickEquipHandle, this)
			} else {
				this.list_equip_loop_mgr.replaceAll(list)
			}
			if (is_set_first && list.length > 0) {
				let redList = model.suitEquipRedList && model.suitEquipRedList[suitLv]
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
				// this.list_equip_loop_mgr.SetSelectIndex(0)

			}
			this.ClickEquipHandle(0)
		}

		this.UpdateCostItems = (equipInfo?, actived?) => {
			// let cost_cfg
			// if (equipInfo.stage < local_EquipDefine.EQUIP_SUIT_MIN_STAGE) {
			// 	cost_cfg = model.GetSuitMakeCost(equipInfo.equip_type, suitLv, local_EquipDefine.EQUIP_SUIT_MIN_STAGE)
			// } else {
			// 	cost_cfg = model.GetSuitMakeCost(equipInfo.equip_type, suitLv, equipInfo.stage)
			// }
			// //this:ClearCostItems()
			// if (!cost_cfg) {
			// 	return
			// }
			// let index = 0
			// for (let key in cost_cfg) {
			// 	var info = cost_cfg[key]
			// 	let num = Number(info[2])
			// 	let item = this.cost_item_list_[index]
			// 	if (!item) {
			// 		item = new EquipSuitCostItem(this.matCon);
			// 		item.Load()
			// 		// SetAnchoredPositionX(item, EquipSuitView.MatPosXList[cost_cfg].length)//SetAnchoredPositionX(item.transform, EquipSuitView.MatPosXList[cost_cfg][index].length)
			// 		item.SetPosition(EquipSuitView.MatPosXList[cost_cfg.length - 1][index], 16)
			// 		this.cost_item_list_[index] = item
			// 	}
			// 	if (actived) {
			// 		item.ExcuteCallback(() => {
			// 			item.SetLockStatus(false)
			// 		})
			// 	} else {
			// 		let [type_id, lock] = goods_model.GetMappingTypeId(info[0], info[1])
			// 		let own = goods_model.GetTypeGoodsNum(type_id)
			// 		let color = own >= num && local_Enum_ColorUtil_Light.GREEN || local_Enum_ColorUtil_Light.RED
			// 		item.ExcuteCallback(() => {
			// 			item.SetData(type_id)
			// 			// item.ForceSetNumberInFlow(Util.ColorTxtToHTML(own + "/" + num, color))
			// 			item.SetNumberInFlow(Util.StrToHTML(`<font color=${color}>${own}/${num}</font>`))
			// 		})
			// 	}
			// 	index = index + 1
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
			// if(!item)
			// 	return 
			let info = item
			// if (!info) { return }
			_cur_equip_info_ = info.dynamic
			let dynamic = info.dynamic
			let is_empty = !dynamic
			let name = local_EquipDefine.SUIT_NAME_CFG[suitLv]
			if (!is_empty) {
				let sdata = model.GetSuitDataByDynamic(dynamic, suitLv)
				let actived = model.GetCurSuitLv(info.equip_type) >= suitLv
				let canActive = info.stage >= local_EquipDefine.EQUIP_SUIT_MIN_STAGE && model.EquipSuitCanUp(dynamic)
				hasActived = actived
				if (actived) {
					this._lb_btn.text = "已打造"
					this._lb_btn.gray = true
				} else {
					this._lb_btn.text = "共鸣打造"
				}
				this._btn_back.visible = actived
				Util.SetImageGray(this._img_btn, (!canActive || actived))
				this._lb_btn.stroke = (!canActive || actived) ? 0 : 2
				// this.Out_lb_btn.effectColor = ColorUtil.TryParseHtmlString((canActive && !actived) && "#D36A24" || local_Enum_ColorUtil_Light.GRAY)
				//if (actived ) {
				//this:ClearCostItems()
				//}else{
				this.UpdateCostItems(info, actived)
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
				this._reddot.visible = model.GetEquipSuitRed(dynamic.equip_type, suitLv)
			} else {
				this._lb_btn.text = "共鸣打造"
				hasActived = false
				this.nameText.width = 0
				this.nameText.innerHTML = ""
				this.show_item_.SetVisible(false)
				this._img_show_icon.visible = true
				this._img_show_bg.visible = true
				ResManager.GetInstance().SetImageSprite(this, this._img_show_icon, "equipCom_asset", "role_default_" + info.equip_type)
				this.UpdateCostItems({ equip_type: info.equip_type, stage: 0 }, true)
				this._reddot.visible = false
				let cfg = model.GetSuitMakeCfg(info.equip_type, suitLv, local_EquipDefine.EQUIP_SUIT_MIN_STAGE)
				let [stage, color, star] = model.GetUnLockSuitConditionByCfg(cfg.condition)
				//this:ChangeCondTextByList(local_EquipDefine.EQUIP_SUIT_MIN_STAGE, color, star)
				//this._img_max.visible = false 
				this._btn_build.visible = true
				this.UpdateAttrItems(info)
				// this.Out_lb_btn.effectColor = ColorUtil.TryParseHtmlString(local_Enum_ColorUtil_Light.GRAY)
				Util.SetImageGray(this._img_btn, true)
				this._lb_btn.stroke = 0
				this._btn_back.visible = false
			}
			if (is_empty) {
				this.name.visible = false
			} else {
				this.name.visible = true
			}
			this.name.refresh()
			this.name.width = this._img_name_top.width + this.nameText.contextWidth
			this.SetHtmlCenterX(this.name, this.name_con.width)
			// LayoutRebuilder(this.name_con)
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

			if (equipInfo.stage < local_EquipDefine.EQUIP_SUIT_MIN_STAGE) {
				cfg = model.GetSuitCfg(suitType, suitLv, local_EquipDefine.EQUIP_SUIT_MIN_STAGE)
				// if (PlatformMgr.GetInstance().IsEyouEnPlatform()) {
				// 	this._lb_stage.text = "G" + local_EquipDefine.EQUIP_SUIT_MIN_STAGE + " Set"
				// } else {
				// 	this._lb_stage.text = local_EquipDefine.EQUIP_SUIT_MIN_STAGE + "阶套装"
				// }
				this._lb_stage.text = local_EquipDefine.EQUIP_SUIT_MIN_STAGE + "阶共鸣"
			} else {
				cfg = model.GetSuitCfg(suitType, suitLv, equipInfo.stage)
				// if (PlatformMgr.GetInstance().IsEyouEnPlatform()) {
				// 	this._lb_stage.text = "G" + equipInfo.stage + " Set"
				// } else {
				// 	this._lb_stage.text = equipInfo.stage + "阶套装"
				// }
				this._lb_stage.text = equipInfo.stage + "阶共鸣"
			}
			let attr_list = cfg && JSON.parse(cfg.attr_list) || {}

			let curCount = 0
			let countList = []
			if (equipInfo.dynamic) {
				for (let key in equipInfo.dynamic.suit_list) {
					var v = equipInfo.dynamic.suit_list[key]
					if (v.suit_lv == suitLv && v.suit_slv == equipInfo.stage) {
						countList[v.suit_count] = true
						//break
					}
				}
			}
			for (let _tmpi in attr_list) {
				var info = attr_list[_tmpi]
				info.isActive = countList[Number(info[0])]
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
		if (this.giftItem) {
			this.giftItem.DeleteMe();
			this.giftItem = null;
		}
		super.DeleteMe()
	}
	public SetHtmlCenterX(html_obj?, w?) {
		if (!html_obj) {
			return
		}
		html_obj.x = w / 2 - html_obj.width / 2
	}

	private ShowGiftIcon() {
		let bool: boolean = Boolean(PushGiftModel.GetInstance().GetGiftList(EnumPushGiftType.eGongMing));
		if (bool) {
			if (!this.giftItem) {
				this.giftItem = new GiftPushIcon(this.giftIcon);
				this.giftItem.Load();
			}
			this.giftItem.ExcuteCallback(() => {
				this.giftItem.SetDate(PushGiftModel.ICON_TYPE, EnumPushGiftType.eGongMing, 0);
			});
		}
		this.giftIcon.visible = bool;
	}


	line: Laya.Image
	name: Laya.HBox
	_img_name_top: Laya.Image
	_group_eff1: Laya.Box;
	giftIcon: Laya.Box;

	public GetComponents() {
		[
			this.RawImage,
			this.Image333,
			this._img_bg,
			this._Image1,
			this._Image2,
			this._Image3,
			this._Image5,
			this.Image,
			this._Image7,
			this.matcon_bg,
			this._Image4,
			this._Image6,
			this.img2,
			this.name_con,
			this.img3,
			this.name,
			this._img_name_top,
			this.nameText,
			this._img_max,
			this._btn_back,
			this._Label1,
			this._lb_type,
			this._lb_stage,
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
			this._group_eff1,
			this.line,
			this.giftIcon,
		]
			= this.GetChildrenByNames([

				"RawImage",
				"Image333",
				"_img_bg",
				"_Image1",
				"_Image2",
				"_Image3",
				"_Image5",
				"Image",
				"_Image7",
				"matcon_bg",
				"_Image4",
				"_Image6",
				"img2",
				"name_con",
				"img3",
				"name",
				"_img_name_top",
				"nameText",
				"_img_max",
				"_btn_back",
				"_Label1",
				"_lb_type",
				"_lb_stage",
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
				"_group_eff1",
				"line",
				"giftIcon",
			])

		this.nameText.style.fontSize = 26
		this.nameText.style.color = "#ffffff"
		this.nameText.style.strokeColor = "#ffffff"
		this.nameText.style.stroke = 1
		// this.nameText.style.align = "center"    //居中可能无效
		// this.nameText.style.valign = "middle"
	}
}
window["EquipSuitView"] = EquipSuitView
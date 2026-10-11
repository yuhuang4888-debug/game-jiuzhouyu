import { BaseView1 } from "../common/BaseView1"
import { EquipmentItem } from "../common/EquipmentItem"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { LuaSoundManager } from "../common/SoundManager"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { EquipModel, EquipEvent } from "../commonModel/EquipModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { IS2CSuitListInfoParam, SuitModel, SuitModelEvent } from "../commonModel/SuitModel"
import { ColorUtil, Enum_ColorUtil_Dark } from "../util/ColorUtil"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { Util, HtmlColorTxt } from "../util/Util"
import { Config } from "../common/Config"

export class EquipSuitReturnView extends BaseView1 {
	_Image1: Laya.Image
	_Image3: Laya.Image
	_Image4: Laya.Image
	_gp_award: Laya.Box
	_lb_name: Laya.HTMLDivElement
	_lb_tips: Laya.HTMLDivElement
	_lb_desc: Laya.HTMLDivElement
	_Label2: Laya.Label
	_Scroller1: Laya.Panel
	Content: Laya.HBox
	_gp_cancel: Laya.Box
	_Image6: Laya.Image
	_Label3: Laya.Label
	_gp_return: Laya.Box
	_Image7: Laya.Image
	_Label4: Laya.Label
	_img_close: Laya.Image
	Image: Laya.Image
	line: Laya.Image
	Clear

	Emp_gp_cancel
	Emp_gp_return
	InitEvent
	LoadSuccess
	Local_Open
	Scr_Scroller1
	UpdateItems
	UpdateView
	click_bg_toClose
	destroy_callback
	destroy_imm
	is_center
	open_callback
	show_open_movie
	use_background

	private get suitModel() {
		return SuitModel.GetInstance();
	}

	public constructor() {
		super()


		this.base_file = "suit"
		this.layout_file = "EquipSuitReturnView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = false
		this.use_background = true
		this.click_bg_toClose = true
		this.show_open_movie = true
		this.back_login_toClose = true
		this.is_center = true
		let model = EquipModel.GetInstance()
		let local_Util = Util
		let local_EquipEvent = EquipEvent
		let goods_model = GoodsModel.GetInstance()
		let equip_info_ = null
		let suitType: number = null
		let subType: number = null
		let goods_icon_ = null
		let reward_list_ = null
		this.load_callback = () => {

			this.LoadSuccess()
			this.InitEvent()
		}

		this.open_callback = () => {
			this.UpdateView()
		}

		this.destroy_callback = () => {
			this.Clear()
		}



		this.LoadSuccess = () => {
			ResManager.GetInstance().SetTexture(this, this.line, GameResPath.GetIcon("common", "uity_064"))
			if (!goods_icon_) {
				goods_icon_ = new EquipmentItem(this._gp_award)
				goods_icon_.Load()
				goods_icon_.SetItemSize(85, 85)
				goods_icon_.SetClickCallBack(() => {
					if (equip_info_) {
						UIToolTipMgr.GetInstance().AppendEquipTips(equip_info_.type_id, null, null, equip_info_, 1)
					}
				}
				)
			}

		}

		this.InitEvent = () => {
			Util.AddClickEvent(
				this._gp_return, () => {
					if (equip_info_ && suitType) {
						model.Fire(local_EquipEvent.REQUEST_PROTO, 15222, "cc", subType, equip_info_.equip_type)
					}
				},
				this,
				true
			)
			Util.AddClickEvent(
				this._gp_cancel, () => {
					this.Close()
				},
				this,
				true
			)
			Util.AddClickEvent(
				this._img_close, () => {
					this.Close()
				},
				this,
				true, null, null, null, null, LuaSoundManager.SOUND_UI.CLOSE
			)
			this.BindEvent(
				this.suitModel,
				SuitModelEvent.BACK_SUIT_SUCCESS, () => {
					this.UpdateView()
				}
			)
			this.BindEvent(
				model,
				local_EquipEvent.UPDATE_SUIT_REWARD, (scmd?) => {
					this.UpdateItems(scmd.reward_list)
				}
			)
		}

		this.UpdateView = () => {
			if (!equip_info_) {
				return
			}
			let dynamic = equip_info_
			goods_icon_.SetData(dynamic.type_id, 1)

			let suit: IS2CSuitListInfoParam = this.suitModel.GetSuitPos(suitType, subType, equip_info_.equip_type);
			let suitLv: number = Math.max(suit?.slv ? suit.slv - 1 : 0, 0);
			let conf = this.suitModel.GetConfSuitItemInfo(suitType, subType, suitLv);
			let goods = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_goods.name, dynamic.type_id, false);
			let nameStr: string = conf?.name || '无';

			this._lb_desc.innerHTML = Util.StrToHTML("共鸣回退可以退至" + HtmlColorTxt(nameStr, ColorUtil.GetColorDark(1, true)) + "共鸣，且" + HtmlColorTxt("100%", ColorUtil.GetColorDark(1, true)) + "返还打造材料，是否确定进行回退？");
			this._lb_name.innerHTML = goods.goods_name.replace("%(残%)", "");
			let count: number = this.suitModel.GetTypePosLevelNum(suitType, subType, dynamic.equip_type, (suit?.slv || 0));
			if (count) {
				this._lb_tips.innerHTML = Util.StrToHTML(HtmlColorTxt(count + "件加成生效中", ColorUtil.GetColorDark(1, true)))
			} else {
				this._lb_tips.innerHTML = Util.StrToHTML(HtmlColorTxt("暂无加成效果", ColorUtil.GetColorDark(1, true)))
			}

			model.Fire(local_EquipEvent.REQUEST_PROTO, 15223, "cc", subType, equip_info_.equip_type);

			// if (this.suitModel.GetIsEquip(dynamic.equip_type)) {
			// 	//武防
			// 	this._lb_name.innerHTML = Util.StrToHTML("【" + EquipDefine.SUIT_NAME_CFG[suit_type_ - 1] + "】" + GoodsModel.GetGoodsNameWithColorDark(equip_info_.type_id))
			// 	for (let k in dynamic.suit_list) {
			// 		var v = dynamic.suit_list[k]
			// 		if (v.suit_lv >= suit_type_ && (!count || (count < v.suit_count))) {
			// 			count = v.suit_count
			// 		}
			// 	}
			// 	let beforeType = EquipDefine.SUIT_NAME_CFG[suit_type_ - 2] || "无"
			// 	this._lb_desc.innerHTML = Util.StrToHTML("共鸣回退可以退至" + HtmlColorTxt(beforeType, ColorUtil.GetColorDark(1, true)) + "共鸣，且" + HtmlColorTxt("100%", ColorUtil.GetColorDark(1, true)) + "返还打造材料，是否确定进行回退？")
			// } else {
			// 	//饰品
			// 	let cursLv = model.GetCurSuitsLv(equip_info_.equip_type)
			// 	this._lb_name.innerHTML = Util.StrToHTML(GoodsModel.GetGoodsNameWithColorDark(equip_info_.type_id) + (" + ") + cursLv)
			// 	this._lb_desc.innerHTML = Util.StrToHTML("共鸣回退可以将共鸣级数" + HtmlColorTxt(" - 1", ColorUtil.GetColorDark(1, true)) + "，且" + HtmlColorTxt("100%", ColorUtil.GetColorDark(1, true)) + "返还打造材料，是否确定进行回退？")
			// 	for (let k in dynamic.suit_list) {
			// 		var v = dynamic.suit_list[k]
			// 		if (v.suit_slv <= cursLv && (!count || (count < v.suit_count))) {
			// 			count = v.suit_count
			// 		}
			// 	}
			// }
		}

		this.UpdateItems = (list?) => {
			if (!reward_list_) {
				reward_list_ = []
			}
			for (let i = 0; i < reward_list_.length; i++) {
				reward_list_[i].SetVisible(false)
			}
			let item = null
			for (let key in list) {

				// [ts2lua]list下标访问可能不正确
				let vo = list[key]
				// [ts2lua]reward_list_下标访问可能不正确
				item = reward_list_[key]
				if (!item) {
					item = new EquipmentItem(this.Content)
					item.Load()
					item.SetItemSize(87, 87)
					// [ts2lua]reward_list_下标访问可能不正确
					reward_list_[key] = item
				}
				let lock = false
				if (vo.type == 101) {
					let attr_list = ErlangParser.GetInstance().Parse(vo.attr_list)
					for (let _tmpi in attr_list) {
						var attr = attr_list[_tmpi]
						if (attr[0] == "bind") {
							lock = (Number(attr[1]) == 1);
						}
					}
				}
				let [type_id, is_lock] = goods_model.GetMappingTypeId(0, vo.id)
				let goods_vo = goods_model.GetGoodsBasicByTypeId(type_id)
				if (goods_vo) {
					item.SetData(goods_vo.type_id, vo.num, lock)
				}
				item.SetVisible(true)
			}
		}

		this.Clear = () => {
			super.DeleteMe()
			if (goods_icon_) {
				goods_icon_.DeleteMe()
				goods_icon_ = null
			}
			if (reward_list_) {
				for (let _tmpi in reward_list_) {
					var obj = reward_list_[_tmpi]
					obj.DeleteMe()
				}
				reward_list_ = null
			}
			reward_list_ = null
		}

		this.Local_Open = (...param) => {
			[equip_info_, suitType, subType] = [...param];
			if (this.is_loaded) {
				this.UpdateView()
			}
			super.Open();
		}
	}

	public Open(...new_args) {

		this.Local_Open(...new_args)
	}


	public GetComponents() {
		[
			this._Image1,
			this._Image3,
			this._Image4,
			this._gp_award,
			this._lb_name,
			this._lb_tips,
			this._lb_desc,
			this._Label2,
			this._Scroller1,
			this.Content,
			this._gp_cancel,
			this._Image6,
			this._Label3,
			this._gp_return,
			this._Image7,
			this._Label4,
			this._img_close,
			this.Image,
			this.line
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_Image3",
				"_Image4",
				"_gp_award",
				"_lb_name",
				"_lb_tips",
				"_lb_desc",
				"_Label2",
				"_Scroller1",
				"Content",
				"_gp_cancel",
				"_Image6",
				"_Label3",
				"_gp_return",
				"_Image7",
				"_Label4",
				"_img_close",
				"Image",
				"line"
			])
		this._lb_name.style.fontSize = 22
		this._lb_name.style.color = "#4a3a32"
		this._lb_name.width = 362
		this._lb_tips.style.fontSize = 20
		this._lb_tips.style.color = "#639c12"
		this._lb_tips.width = 362;

		this._lb_desc.style.fontSize = 22
		this._lb_desc.style.color = "#663915"
		this._lb_desc.width = 505   //可能无效
		this._lb_desc.style.leading = 10
		this._Scroller1.hScrollBar.visible = false
	}
}
window["EquipSuitReturnView"] = EquipSuitReturnView
import { BaseView1 } from "../common/BaseView1"
import { Util } from "../util/Util"
import { HtmlColorTxt } from "../util/Util"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { PlayBigEffect } from "../util/Util"
import { Message } from "../sysInfo/SysInfoController"
import { TimeUtil } from "../util/TimeUtil"
import { GoodsModel } from "../commonModel/GoodsModel"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { longlangModel } from "../commonModel/longlangModel"
import { longlangStrItem } from "./longlangStrItem"
import { longlangStrAttr } from "./longlangStrAttr"

export class longlangStrView extends BaseView1 {
	FindNext
	GetDefaultIndex
	InitEquip
	InitEvent
	InitView
	LoadSuccess
	Remove
	SetUpState
	SwitchItem
	UpdateCost
	UpdateEquip
	UpdateStren
	UpdateView
	cfg_draconic_equip
	cfg_draconic_strong

	public constructor() {
		super()
		this.base_file = "longlanguage"
		this.layout_file = "longlangStrView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.use_background = true
		this.click_bg_toClose = true
		this.is_center = true
		this.show_open_movie = true
		this.preload_server_config = {
			"config_draconic_equip": false,
			"config_draconic_strong": false
		}

		let local_longlangModel = longlangModel
		let local_longlangModelIns = local_longlangModel.GetInstance()
		let local_resMgr = ResManager.GetInstance()
		let local_msg = Message
		let local_timeUtil = TimeUtil
		let local_goodsModelIns = GoodsModel.GetInstance()
		let attrList_ = []
		let upIng_ = false
		let equip_list_ = null
		let default_index_ = 1
		let now_index_ = null
		let cost_count_ = 0

		this.load_callback = () => {
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg1, "resource/game/longlanguage/other/ui_lybg_1.jpg")
			local_resMgr.SetOutsideImageSprite(this, this._img_cost_icon, GameResPath.GetGoodsIconPath(String(local_longlangModel.MONEY_TYPE)))
			this.cfg_draconic_equip = ResManager.GetInstance().GetGameConfigFromCache(this, "config_draconic_equip", false)
			this.cfg_draconic_strong = ResManager.GetInstance().GetGameConfigFromCache(this, "config_draconic_strong", false)

			this._lb_cost.style.fontSize = 20
			this._lb_cost.style.color = "#663915"
			this._lb_cost.style.wordWrap = false
		}

		this.open_callback = () => {
			this.LoadSuccess()
		}

		this.destroy_callback = () => {
			this.Remove()
		}

		this.LoadSuccess = () => {
			this.InitView()
			this.InitEvent()
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._img_close, () => {
				this.Close()
			}, this, true)

			this.BindEvent(local_goodsModelIns, GoodsModel.UPDATE_SPECIAL_SCORE, (vo?) => {
				if (vo.currency_id == local_longlangModel.MONEY_TYPE) {
					this.UpdateCost()
				}
			})

			Util.AddClickEvent(this._gp_stren, () => {
				let data = local_longlangModelIns.GetWearEquipByPos(now_index_)
				if (data) {
					local_longlangModelIns.Fire(local_longlangModel.SEND_PROTO, 62202, "cc", now_index_, 0)
				} else {
					local_msg.show("请先穿戴神祭")
				}
			}, this, true)

			Util.AddClickEvent(this._gp_auto, () => {
				let data = local_longlangModelIns.GetWearEquipByPos(now_index_)
				if (data) {
					this.SetUpState(true)
					local_longlangModelIns.Fire(local_longlangModel.SEND_PROTO, 62202, "cc", now_index_, 0)
				} else {
					local_msg.show("请先穿戴神祭")
				}
			}, this, true)

			let next_time = null
			this.BindEvent(local_longlangModelIns, local_longlangModel.EQUIP_STR_INFO, (pos_id?) => {
				if (pos_id == now_index_) {
					this.UpdateStren(true)
					if (!next_time || next_time < local_timeUtil.getServerTimeMs()) {
						next_time = local_timeUtil.getServerTimeMs() + 450
						//this:AddUIEffect("ui_qianghuachenggong", this._gp_effect)
						PlayBigEffect("ui_shengjitexiao")
					}
				}
				if (pos_id && upIng_) {
					this.FindNext()
				}
			})

			Util.AddClickEvent(this.cancelBtn, () => {
				this.SetUpState(false)
			}, this, true)

			Util.AddClickEvent(this._img_cost_icon, () => {
				UIToolTipMgr.GetInstance().AppendGoodsTips(local_longlangModel.MONEY_TYPE, null, null, null, local_goodsModelIns.GetSpecialScore(local_longlangModel.MONEY_TYPE), null, this)
			}, this, true)

			this.BindEvent(local_longlangModelIns, "error", () => {
				this.SetUpState(false)
			})
		}

		this.InitView = () => {
			this.InitEquip()
			this.UpdateEquip()
			this.SwitchItem(this.GetDefaultIndex())
		}

		this.GetDefaultIndex = () => {
			let stren_data = local_longlangModelIns.equipInfo
			let min_pos = null
			let min_lv = 99999
			for (let pos in stren_data) {
				let equip_data = local_longlangModelIns.GetWearEquipByPos(pos)
				if (!equip_data) {
					break
				}
				let lv = stren_data[pos]
				if (!lv) {
					min_pos = pos
					break
				}
				let holy_data = this.cfg_draconic_equip[equip_data.type_id]
				if (min_lv > lv && holy_data.strong > lv + 1) {
					min_lv = lv
					min_pos = pos
				}
			}
			if (min_pos == null) {
				min_pos = default_index_
			}
			return min_pos
		}

		this.InitEquip = () => {
			if (!equip_list_) {
				equip_list_ = []
			}
			let item = null
			let i = local_longlangModel.EQUIP_COUNT - 1
			do {
				let parent = this["_gp_" + i]
				let item = new longlangStrItem(parent)
				equip_list_[i] = item
				item.SetClickCallBackAndPos((pos?) => {
					this.SwitchItem(pos)
				}, i + 1)
				item.Load()
				i = i - 1
			} while ((i >= 0))
		}

		this.UpdateEquip = () => {
			let list = local_goodsModelIns.longlang_equip_list
			let i = 0
			do {
				let equip = list[i + 1]
				if (!equip) {
					equip = { equip_type: i + 1, type_id: 0 }
				}
				equip_list_[i].SetData(equip)
				i = i + 1
			} while ((i < local_longlangModel.EQUIP_COUNT))
		}

		this.SwitchItem = (index?) => {
			if (now_index_ == index) {
				return
			}
			for (let i in equip_list_) {
				let item = equip_list_[i]
				if (item) {
					let select = (index - 1) == Number(i)
					item.SetSelcetImg(select)
				}
			}
			now_index_ = index
			this.UpdateView()
		}

		this.Remove = () => {
			if (equip_list_) {
				for (let pos in equip_list_) {
					let obj = equip_list_[pos]
					if (obj) {
						obj.DeleteMe()
					}
				}
				equip_list_ = null
			}
			if (attrList_) {
				for (let _tmpi in attrList_) {
					var item = attrList_[_tmpi]
					item.DeleteMe()
				}
				attrList_ = []
			}
			now_index_ = null
			cost_count_ = 0
			upIng_ = false
		}

		this.UpdateView = () => {
			let data = local_longlangModelIns.GetWearEquipByPos(now_index_)
			if (data) {
				this._lb_name.visible = true
				// this.1.visible = true
				this._img_cost_icon.visible = true
				this.attrScroller.visible = true
				this._lb_none.visible = false
				this.UpdateStren()
			} else {
				this._lb_none.visible = true
				this._lb_name.visible = false
				// this.1.visible = false
				this._img_cost_icon.visible = false
				this.attrScroller.visible = false
				this._img_stren_red.visible = false
				this._img_auto_red.visible = false
				this._img_max.visible = false
				this._lb_cost.innerHTML = ""
			}
		}

		this.UpdateCost = () => {
			let have = local_goodsModelIns.GetSpecialScore(local_longlangModel.MONEY_TYPE)
			let color = cost_count_ && have < cost_count_ ? "'#ff4f50'" : "'#0a953e'"
			if (cost_count_ != null) {
				this._lb_cost.innerHTML = Util.StrToHTML("消耗：" + HtmlColorTxt(have, color) + "/" + cost_count_)
				this._img_auto_red.visible = have >= cost_count_
				this._img_stren_red.visible = have >= cost_count_
			} else {
				this._img_auto_red.visible = false
				this._img_stren_red.visible = false
			}
		}

		this.UpdateStren = (stren_success?) => {
			if (stren_success == null) {
				stren_success = false
			}
			let data = local_longlangModelIns.GetWearEquipByPos(now_index_)
			if (data) {
				let equip_data = this.cfg_draconic_equip[data.type_id]
				let max_stren = equip_data.strong
				let stren_lv = local_longlangModelIns.GetStrData(now_index_)
				let basic = local_goodsModelIns.GetGoodsBasicByTypeId(data.type_id)
				this._lb_name.text = basic.goods_name + " Lv." + stren_lv
				let seal_strong_cfgs = this.cfg_draconic_strong
				let now_stren_cfg = seal_strong_cfgs[now_index_ + "@" + stren_lv]
				let add_attr = JSON.parse(now_stren_cfg.add_attr)
				let next_attr = []
				let max = false
				if (stren_lv + 1 > max_stren) {
					this._lb_cost.visible = false
					this._img_cost_icon.visible = false
					this._img_max.visible = true
					cost_count_ = null
					this.UpdateCost()
					max = true
					if (stren_success) {
						//this:SwitchItem(this.GetDefaultIndex())
					}
				} else {
					this._img_max.visible = false
					this._lb_cost.visible = true
					this._img_cost_icon.visible = true
					let next_stren_cfg = seal_strong_cfgs[now_index_ + "@" + (stren_lv + 1)]
					let cost = next_stren_cfg.cost
					let value = 0
					if (cost != "[]") {
						cost = JSON.parse(cost)
						value = (cost && cost[0]) && cost[0][2]
					}
					cost_count_ = Number(value)
					this.UpdateCost()
					next_attr = JSON.parse(next_stren_cfg.add_attr)
				}
				let i = 0
				do {
					let attrItem = attrList_[i]
					if (!attrItem) {
						attrItem = new longlangStrAttr(this.Content)
						attrItem.Load()
						attrList_[i] = attrItem
					}
					attrItem.SetVisible(true)
					attrItem.SetData(add_attr[i], next_attr[i])
					i = i + 1
				} while ((i < add_attr.length))
				i = add_attr.length
				do {
					let attrItem = attrList_[i]
					if (attrItem) {
						attrItem.SetVisible(false)
					}
					i = i + 1
				} while ((i < attrList_.length))
			}
		}

		this.SetUpState = (bool?) => {
			if (this.is_loaded) {
				this.cancelBtn.visible = bool
				this._gp_auto.visible = !bool
				upIng_ = bool
			}
		}

		this.FindNext = () => {
			let lvList = local_longlangModelIns.equipInfo
			let min = null
			let pos = null
			for (let key in lvList) {
				if (min == null || lvList[key] < min) {
					let data = local_longlangModelIns.GetWearEquipByPos(key)
					if (data) {
						pos = key
						min = lvList[key]
					}
				}
			}
			if (pos) {
				this.SwitchItem(pos)
				local_longlangModelIns.Fire(local_longlangModel.SEND_PROTO, 62202, "cc", now_index_, 0)
			}
		}
	}

	_img_bg: Laya.Image
	_img_bg1: Laya.Image
	_img_bg2: Laya.Image
	_img_title: Laya.Image
	_lb_title: Laya.Label
	_img_close: Laya.Image
	_img_title2: Laya.Image
	_lb_name: Laya.Label
	_lb_none: Laya.Label
	attrScroller: Laya.Panel
	Content: Laya.VBox
	_lb_cost: Laya.HTMLDivElement
	_img_cost_icon: Laya.Image
	_img_max: Laya.Image
	_Image6: Laya.Image
	_Label3: Laya.Label
	_img_select: Laya.Image
	_gp_stren: Laya.Box
	_Image4: Laya.Image
	_Label1: Laya.Label
	_img_stren_red: Laya.Image
	_gp_auto: Laya.Box
	_Image5: Laya.Image
	_Label21: Laya.Label
	_img_auto_red: Laya.Image
	cancelBtn: Laya.Box
	_Image51: Laya.Image
	_Label2: Laya.Label
	equipGp: Laya.Box
	_gp_0: Laya.Box
	_gp_1: Laya.Box
	_gp_2: Laya.Box
	_gp_3: Laya.Box
	_gp_4: Laya.Box
	_gp_5: Laya.Box
	_gp_6: Laya.Box
	_gp_7: Laya.Box
	_gp_8: Laya.Box
	_gp_9: Laya.Box
	_gp_10: Laya.Box
	public GetComponents() {
		[
			this._img_bg,
			this._img_bg1,
			this._img_bg2,
			this._img_title,
			this._lb_title,
			this._img_close,
			this._img_title2,
			this._lb_name,
			this._lb_none,
			this.attrScroller,
			this.Content,
			this._lb_cost,
			this._img_cost_icon,
			this._img_max,
			this._Image6,
			this._Label3,
			this._img_select,
			this._gp_stren,
			this._Image4,
			this._Label1,
			this._img_stren_red,
			this._gp_auto,
			this._Image5,
			this._Label21,
			this._img_auto_red,
			this.cancelBtn,
			this._Image51,
			this._Label2,
			this.equipGp,
			this._gp_0,
			this._gp_1,
			this._gp_2,
			this._gp_3,
			this._gp_4,
			this._gp_5,
			this._gp_6,
			this._gp_7,
			this._gp_8,
			this._gp_9,
			this._gp_10,
		]
			= this.GetChildrenByNames([
				"_img_bg",
				"_img_bg1",
				"_img_bg2",
				"_img_title",
				"_lb_title",
				"_img_close",
				"_img_title2",
				"_lb_name",
				"_lb_none",
				"attrScroller",
				"Content",
				"_lb_cost",
				"_img_cost_icon",
				"_img_max",
				"_Image6",
				"_Label3",
				"_img_select",
				"_gp_stren",
				"_Image4",
				"_Label1",
				"_img_stren_red",
				"_gp_auto",
				"_Image5",
				"_Label21",
				"_img_auto_red",
				"cancelBtn",
				"_Image51",
				"_Label2",
				"equipGp",
				"_gp_0",
				"_gp_1",
				"_gp_2",
				"_gp_3",
				"_gp_4",
				"_gp_5",
				"_gp_6",
				"_gp_7",
				"_gp_8",
				"_gp_9",
				"_gp_10",
			])
	}
}
window["longlangStrView"] = longlangStrView
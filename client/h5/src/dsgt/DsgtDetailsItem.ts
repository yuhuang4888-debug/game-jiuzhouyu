import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItem1 } from "../common/BaseItem1"
import { Config } from "../common/Config"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { DsgtModel } from "../commonModel/DsgtModel"
import { TaskTipType } from "../commonModel/TaskModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Message } from "../sysInfo/SysInfoController"
import { ColorUtil } from "../util/ColorUtil"
import { ErlangParser } from "../util/ErlangParser"
import { Util, GlobalTimerQuest, Trim, SetSizeDeltaX, GetSizeDeltaX, GetSizeDeltaY, SetAnchoredPosition } from "../util/Util"
import { GameResPath } from "../util/GameResPath"
import { FightingShowSmallItem } from "../common/FightingShowSmallItem"

export class DsgtDetailsItem extends BaseItem1 {
	InitEvent
	InitView
	OnTimer
	RefreshActivateBtn
	SetData
	ShowAttDetails
	ShowMaterial
	attr_label_list_
	curr_sorting_order
	dsgt_awarditem_
	dsgt_expend
	story_obj_list
	timer_
	needRefresh
	index
	fight_num
	fight_item
	Font_name: string = "font_1"

	public constructor(parent?) {
		super(parent)


		this.base_file = "dsgt"
		this.layout_file = "DsgtDetailsItem"
		this.layer_value = "UI"
		let dsgtModel = DsgtModel.GetInstance()
		let local_DsgtModel = DsgtModel
		let local_Number = Number
		this.dsgt_awarditem_ = null
		let dsgt_info_ = null
		this.attr_label_list_ = []
		let is_ordering_ = false
		this.timer_ = null
		this.needRefresh = false
		this.load_callback = () => {

			this.fight_item = new FightingShowSmallItem(this._gp_fight)
			this.fight_item.Load()
			this.fight_item.IsCenter(true, false)


			if (this.needRefresh) {
				this.SetData(this.index)
			}
			this.InitEvent()
			// this.curr_sorting_order = this.AddCurrLayerSortingOrder(this.layer_value)
			ResManager.GetInstance().SetTexture(this, this.img_bg_details, GameResPath.GetIcon("dsgt", "ui_role_52"))
		}

		this.createChildren = () => {
			this.story_obj_list = this.story_obj_list || {}
			this.story_obj_list[TaskTipType.ActiveDesignation] = [this.dsgt_Activate_button]
			super.createChildren()
		}

		this.InitEvent = () => {
			is_ordering_ = false
			let DsgtUpatePower = (_power?) => {
				if(this.fight_item)this.fight_item.Updatefighting(_power)
			}

			this.BindEvent(dsgtModel, local_DsgtModel.DSGT_UPDATE_POWER, DsgtUpatePower)
			let TouchActivateBut = () => {
				if (!dsgt_info_) {
					return
				}
				let id = dsgt_info_.id
				let need_good_dic = dsgtModel.GetDsgtGoodsDic()
				let goods_num_dic = dsgtModel.GetDsgtGoodsNumDic()
				let cur_goods_dic = need_good_dic && need_good_dic[id]
				if (!cur_goods_dic || !cur_goods_dic[0] || Util.IsTableEmpty(goods_num_dic)) {
					return
				}
				let good_type = Number(cur_goods_dic[0][1])
				let need_num = Number(cur_goods_dic[0][2])
				let have_num = goods_num_dic[good_type]
				if (!need_num && need_num != 0) return
				if (!have_num || have_num < need_num) {
					Message.show("材料不足")
					return
				}
				dsgtModel.Fire(local_DsgtModel.SCMD_REQUEST, (dsgt_info_.status < 2 && (41109) || (41106)), dsgt_info_.id)
			}

			Util.AddClickEvent(this.dsgt_Activate_button, TouchActivateBut, this, true)
			let TouchAdornBut = () => {
				if (!is_ordering_) {
					this.InitView()
					is_ordering_ = true
					if (dsgt_info_) {
						dsgtModel.Fire(local_DsgtModel.SCMD_REQUEST, (dsgt_info_.id != dsgtModel.GetAdronDsgtID() && (41102) || (41103)), dsgt_info_.id)
					}
				}
			}

			Util.AddClickEvent(this.dsgt_adorn_button, TouchAdornBut, this, true)
		}

		this.InitView = () => {
			if (!this.timer_) {
				this.timer_ = GlobalTimerQuest.AddDelayQuest(this.OnTimer, 0.16)
			}
		}

		this.OnTimer = () => {
			is_ordering_ = false
			if (this.timer_) {
				GlobalTimerQuest.CancelQuest(this.timer_)
				this.timer_ = null
			}
		}

		this.SetData = (index?) => {
			this.index = index
			//this:ClearUIEffect(this._gp_effect_icon)
			dsgt_info_ = dsgtModel.GetDsgtList()[index]
			if (!dsgt_info_) {
				return
			}
			let id = dsgt_info_.id
			let dsgt = dsgtModel.getDsgtCfgByID(id)
			if (!dsgt) {
				return
			}
			if (this.is_loaded) {
				if (dsgt.type == 1) {
					this._gp_effect_icon.visible = true
					this.dsgt_icon_image.visible = false
					let data = {
						custom_sorting_order: this.curr_sorting_order
					}

					ResManager.GetInstance().LoadGameConfig(this, "ClientEffDsgtShow", true, null, (ClientEffDsgtShow) => {
						if (ClientEffDsgtShow) {
							this.ClearUIEffect(this._gp_effect_icon)
							this._gp_effect_icon.width = 237
							this._gp_effect_icon.height = 120
							this._gp_effect_icon.y = -15
							this._gp_effect_icon.x = 0
							let cfg = ClientEffDsgtShow["DsgtDetailsItem"][dsgt.id]
							if (!cfg) {
								cfg = ClientEffDsgtShow["DsgtDetailsItem"]["def"]
							}
							this.AddUIEffect(Trim(dsgt.resource_id), this._gp_effect_icon, {x: cfg.x, y:cfg.y}, cfg.scale, true, null, null, null, null, null, null, null, false)
						}
					})
					// if (dsgt.id == 305145) {
					// 	this.AddUIEffect(Trim(dsgt.resource_id), this._gp_effect_icon, null, 12, true, data, null, null, null, null, null, null, false)
					// } else if (dsgt.id == 305030) {
					// 	this.AddUIEffect(Trim(dsgt.resource_id), this._gp_effect_icon, null, 14, true, data, null, null, null, null, null, null, false)
					// } else if(dsgt.id == 305031){
					// 	this.AddUIEffect(Trim(dsgt.resource_id), this._gp_effect_icon, null, 6, true, data, null, null, null, null, null, null, false)
					// } else {
					// 	this._gp_effect_icon.width = 400
					// 	this._gp_effect_icon.height = 180
					// 	this._gp_effect_icon.x = -87
					// 	this._gp_effect_icon.y = -54
					// 	this.AddUIEffect(Trim(dsgt.resource_id), this._gp_effect_icon, null, 6, true, data, null, null, null, null, null, null, false)

					// }
					// this.AddUIEffect(Trim(dsgt.resource_id), this._gp_effect_icon, null, 8, true,data,null,null,null,null,null,null,false)
					this._lb_title.text = ''
				} else {
					this._gp_effect_icon.visible = false
					this.dsgt_icon_image.visible = true
					ResManager.GetInstance().SetOutsideImageSprite(this, this.dsgt_icon_image, "resource/game/dsgtIcon/" + dsgt.resource_id + ".png", true, () => {
						if (this.use_delete_method) {
							return
						}
						if (dsgt.main_type == 7) {
							let name = RoleManager.GetInstance().GetMainRoleVo().marriage_name
							let title = (dsgt_info_.status > 1 && (name + "的伴侣") || ("某某某的伴侣"))
							this._lb_title.text = title
							// LayoutRebuilder(this._lb_title)
							this.dsgt_icon_image.sizeGrid = '0,76,0,72'
							SetSizeDeltaX(this.dsgt_icon_image, GetSizeDeltaX(this._lb_title) + 90) //90,52
						} else {
							this._lb_title.text = ''
							this.dsgt_icon_image.sizeGrid = null
						}
					})
				}
				dsgtModel.Fire(local_DsgtModel.SCMD_REQUEST, 41107, id)
				this.dsgt_order_label.text = dsgt_info_.status > 1 ? `${dsgt_info_.order}阶` : ''
				this.dsgt_order_label.visible = dsgt_info_.status > 1 ? true : false
				this.dsgt_order_label.color = "#0a953e"
				this.dsgt_unactivate_image.visible = dsgt_info_.status > 1 ? false : true
				this.dsgt_adorn_button.visible = dsgt_info_.status > 1 ? true : false
				this.labelDisplay.text = dsgtModel.GetAdronDsgtID() == id ? "卸下" : "佩戴"
				let bool = dsgt_info_.main_type == 3 && dsgt_info_.order && dsgt_info_.order == dsgt_info_.order_limit && true || false
				this.dsgt_full_order_image.visible = bool
				this.RefreshActivateBtn()
				this.ShowMaterial()
				this.ShowAttDetails()
			} else {
				this.needRefresh = true
			}
		}

		this.RefreshActivateBtn = () => {
			if (!dsgt_info_) {
				return
			}
			let bool = false
			if (dsgt_info_.status < 2 && dsgt_info_.goods_consume != "0" || (dsgt_info_.main_type == 3 && !this.dsgt_full_order_image.visible)) {
				bool = true
			}
			this.dsgt_Activate_button.visible = bool
			// [ts2lua]lua中0和空字符串也是true，此处dsgt_info_.status < 2需要确认
			this.labelDisplay1.text = (dsgt_info_.status < 2 && ("激活") || ("晋升"))
		}

		this.ShowMaterial = () => {
			if (!dsgt_info_) {
				return
			}
			let bool = false
			// if ((dsgt_info_.main_type == 3 && (!dsgt_info_.order || dsgt_info_.order < dsgt_info_.order_limit))
			// 	|| (dsgt_info_.status < 2 && dsgt_info_.goods_consume[0][0] != 0)) {
			// 	bool = true
			// }
			if (dsgt_info_.status < 2 && dsgt_info_.goods_consume != "0" || (dsgt_info_.main_type == 3 && !dsgt_info_.hasOwnProperty("order") || dsgt_info_.order < dsgt_info_.order_limit)) {
				bool = true
			}
			this.dsgt_awarditem_group.visible = bool
			this.dsgt_number_label.visible = bool
			this.dsgt_expend_label.visible = bool
			this.dsgt_description_label.wordWrap = true
			this.dsgt_description_label.fontSize = 24
			this.dsgt_description_label.color = "#d15e00"
			this.dsgt_description_label.visible = !bool
			this.dsgt_red_image.visible = false
			this.dsgt_description_label.text = Trim(dsgt_info_.description)
			if (!bool) {
				return
			}
			//////解决特殊称号 闻风丧胆
			if (this.dsgt_Activate_button.visible != bool) {
				this.dsgt_description_label.visible = true;
				this.dsgt_awarditem_group.visible = false
				this.dsgt_number_label.visible = false
				this.dsgt_expend_label.visible = false
				return;
			}
			///////
			if (!this.dsgt_awarditem_) {
				this.dsgt_awarditem_ = new BaseAwardItem(this.dsgt_awarditem_group)
				this.dsgt_awarditem_.SetScale(0.75)
				this.dsgt_awarditem_.Load()
			}
			let need_good_dic = dsgtModel.GetDsgtGoodsDic()
			let goods_num_dic = dsgtModel.GetDsgtGoodsNumDic()
			if (Util.IsTableEmpty(need_good_dic) || Util.IsTableEmpty(goods_num_dic)) {
				return
			}
			if (need_good_dic[dsgt_info_.id] != null) {
				let good_type = need_good_dic[dsgt_info_.id][0][1]
				let need_num = need_good_dic[dsgt_info_.id][0][2]
				let have_num = goods_num_dic[good_type]
				this.dsgt_awarditem_.SetData(good_type)
				// this.dsgt_awarditem_.SetData(need_good_dic[dsgt_info_.id][1])
				this.dsgt_number_label.text = have_num + "/" + need_num
				let color = have_num >= need_num && "#ffffff" || "#ff4f50"//Color(1, 79 / 255, 80 / 255, 1)
				this.dsgt_number_label.color = String(color)
				this.dsgt_red_image.visible = (have_num >= need_num && (true || (false)))
				this.dsgt_expend_label.text = (dsgt_info_.status >= 2 && ("晋升消耗：") || ("激活消耗："))
			}
		}

		this.ShowAttDetails = () => {
			table.insert(this.attr_label_list_, this.attr1)
			table.insert(this.attr_label_list_, this.attr2)
			table.insert(this.attr_label_list_, this.attr3)
			table.insert(this.attr_label_list_, this.attr4)
			if (!dsgt_info_) {
				return
			}
			//let order_basic = dsgtModel.GetDsgtOrdrtList()
			let attrs_cfg = dsgtModel.GetDsgtAttrs()
			if (!attrs_cfg) {
				return
			}
			let attr_list = null
			if (dsgt_info_.status > 1 && dsgt_info_.main_type == 3) {
				let cfg_obj = dsgtModel.GetDsgtOrderCfg()
				if (cfg_obj) {
					let c = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_dsgt_order.name, dsgt_info_.id + "@" + dsgt_info_.order, false, cfg_obj)
					if (c) {
						let list = c.attr_list
						attr_list = JSON.parse(list)
					}
				}
			} else {
				attr_list = dsgt_info_.attr_list
			}
			// if (this.attr_label_list_.length > 0) {
			// 	for (let index in this.attr_label_list_) {

			// 		this.attr_label_list_[index].visible = false
			// 	}
			// }
			for (let key in this.attr_label_list_) {
				let label = this.attr_label_list_[key]
				label.innerHTML = ""
			}
			for (let index in attr_list) {

				let label = this.attr_label_list_[index]
				let att_type = attr_list[index] && attr_list[index][0]
				let cur_cfg = attrs_cfg[local_Number(att_type)]
				if (cur_cfg) {
					let kind = cur_cfg.kind
					let symbol = cur_cfg.symbol
					let name = cur_cfg.name
					let value = attr_list[index][1]
					let str = (symbol == 2 && ("-") || (""))
					str = str + (kind == 2 && (local_Number(value) / 100) || (value))
					str = str + (kind == 2 && ("%") || (""))
					//label.text = [{text:name + "：", style:{size:24, textColor:"#93847d"}], {text=str, style=[size=24, textColor="#639c12"]]]
					// let text = "<font color=0x93847d>" + name + ": </font><font color=0x639c12>" + str + "</font>"
					label.style.fontSize = 24;
					label.innerHTML = Util.StrToHTML("<font color='#763320'>" + name + ": </font><font color='#c85a37'>" + str + "</font>")
					label.style.width = 200;
					this.attr_label_list_[index].visible = true
				}
			}
		}
	}

	public DeleteMe() {
		if (this.fight_item) {
			this.fight_item.DeleteMe()
			this.fight_item = null
		}
		if (this.timer_) {
			GlobalTimerQuest.CancelQuest(this.timer_)
			this.timer_ = null
		}
		if (this.attr_label_list_.length > 0) {
			this.attr_label_list_ = []
		}
		if (this.dsgt_awarditem_) {
			this.dsgt_awarditem_.DeleteMe()
			this.dsgt_awarditem_ = null
		}
		super.DeleteMe()
	}

	dsgt_details_group: Laya.Box
	img_bg_details: Laya.Image
	_Group3: Laya.Box
	_Image1: Laya.Image
	_Group2: Laya.Box
	_Group1: Laya.Box
	dsgt_icon_image: Laya.Image
	_lb_title: Laya.Label
	dsgt_order_label: Laya.Label
	dsgt_adorn_button: Laya.Box
	_Image11: Laya.Image
	labelDisplay: Laya.Label
	dsgt_unactivate_image: Laya.Image
	_gp_effect_icon: Laya.Box
	dsgt_Activate_button: Laya.Box
	_Image111: Laya.Image
	labelDisplay1: Laya.Label
	dsgt_expend_label: Laya.Label
	dsgt_awarditem_group: Laya.Box
	dsgt_number_label: Laya.Label
	dsgt_red_image: Laya.Image
	dsgt_description_label: Laya.Label
	dsgt_att_label_group: Laya.Box
	dsgt_att_box1: Laya.Box
	attr1: Laya.HTMLDivElement
	dsgt_att_box2: Laya.Box
	attr2: Laya.HTMLDivElement
	dsgt_att_box3: Laya.Box
	attr3: Laya.HTMLDivElement
	dsgt_att_box4: Laya.Box
	attr4: Laya.HTMLDivElement
	dsgt_full_order_image: Laya.Image
	_Image4: Laya.Image
	_gp_fight: Laya.Box
	public GetComponents() {
		[
			this.dsgt_details_group,
			this.img_bg_details,
			this._Group3,
			this._Image1,
			this._Group2,
			this._Group1,
			this.dsgt_icon_image,
			this._lb_title,
			this.dsgt_order_label,
			this.dsgt_adorn_button,
			this._Image11,
			this.labelDisplay,
			this.dsgt_unactivate_image,
			this._gp_effect_icon,
			this.dsgt_Activate_button,
			this._Image111,
			this.labelDisplay1,
			this.dsgt_expend_label,
			this.dsgt_awarditem_group,
			this.dsgt_number_label,
			this.dsgt_red_image,
			this.dsgt_description_label,
			this.dsgt_att_label_group,
			this.dsgt_att_box1,
			this.attr1,
			this.dsgt_att_box2,
			this.attr2,
			this.dsgt_att_box3,
			this.attr3,
			this.dsgt_att_box4,
			this.attr4,
			this.dsgt_full_order_image,
			this._Image4,
			this._gp_fight,
		]
			= this.GetChildrenByNames([

				"dsgt_details_group",
				"img_bg_details",
				"_Group3",
				"_Image1",
				"_Group2",
				"_Group1",
				"dsgt_icon_image",
				"_lb_title",
				"dsgt_order_label",
				"dsgt_adorn_button",
				"_Image11",
				"labelDisplay",
				"dsgt_unactivate_image",
				"_gp_effect_icon",
				"dsgt_Activate_button",
				"_Image111",
				"labelDisplay1",
				"dsgt_expend_label",
				"dsgt_awarditem_group",
				"dsgt_number_label",
				"dsgt_red_image",
				"dsgt_description_label",
				"dsgt_att_label_group",
				"dsgt_att_box1",
				"attr1",
				"dsgt_att_box2",
				"attr2",
				"dsgt_att_box3",
				"attr3",
				"dsgt_att_box4",
				"attr4",
				"dsgt_full_order_image",
				"_Image4",
				"_gp_fight",
			])
	}
}
window["DsgtDetailsItem"] = DsgtDetailsItem
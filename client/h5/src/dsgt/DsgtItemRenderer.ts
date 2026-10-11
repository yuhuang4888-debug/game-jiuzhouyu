
import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { Config } from "../common/Config"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { DsgtModel } from "../commonModel/DsgtModel"
import { RoleManager } from "../commonModel/RoleManager"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { Trim, SetSizeDelta, GetSizeDeltaX, GetSizeDeltaY, SetAnchoredPosition, Util } from "../util/Util"

export class DsgtItemRenderer extends BaseItemRenderer {
	_gp_dsgt_effect
	_lb_title
	attr_label_list
	curr_sorting_order
	dsgt_adorning_image
	dsgt_att_group: Laya.Box
	dsgt_att_label
	dsgt_red_image
	dsgt_status_label
	resource_image: Laya.Image
	select
	_Group2

	bg_dsgtitem_png: Laya.Image
	bg_1: Laya.Image
	_Image1: Laya.Image
	_Image2: Laya.Image
	_Group1: Laya.Box
	_Image3: Laya.Image

	dsgt_att_box1: Laya.Box
	dsgt_att_box2: Laya.Box
	dsgt_att_box3: Laya.Box
	dsgt_att_box4: Laya.Box
	attr1: Laya.HTMLDivElement
	attr2: Laya.HTMLDivElement
	attr3: Laya.HTMLDivElement
	attr4: Laya.HTMLDivElement

	public WIDTH = 696
	public HEIGT = 125
	local_Number = Number
	mask_id
	mask_corners
	old_id
	public constructor(parent) {
		super()


		this.attr_label_list = [];
		this.base_file = "dsgt"
		this.layout_file = "DsgtItemRenderer"
		this.Load()
		// this.layer_value = Enum_UILayer.UI
		// this.load_callback = () => {

		// 	this.curr_sorting_order = this.AddCurrLayerSortingOrder(this.layer_value)
		// }
		// this.skinName = "resource/game/dsgt/exml/DsgtItemRendererExml.exml"
	}

	public load_callback() {
		// this.InitView()
	}
	public dataChanged() {
		if (super.dataChanged()) {
			this.InitView()
		}

	}

	public DeleteMe() {

		this.attr_label_list = []
		super.DeleteMe()
	}

	public InitView() {
		if (this.data.id != this.old_id) {
			this.old_id = this.data.id
			ResManager.GetInstance().SetTexture(this.base_item, this.bg_dsgtitem_png, GameResPath.GetIcon("dsgt", "ui_role_51"))
			let dsgt = DsgtModel.GetInstance().getDsgtCfgByID(this.data.id)
			if (!dsgt) {
				return
			}
			if (dsgt.type == 1) {
				this.resource_image.visible = false
				this._gp_dsgt_effect.visible = true
				this._lb_title.text = ''
				let data = {
					custom_sorting_order: this.curr_sorting_order,
					mask_id: this.mask_id,
					mask_corners: this.mask_corners
				}
				ResManager.GetInstance().LoadGameConfig(this, "ClientEffDsgtShow", true, null, (ClientEffDsgtShow) => {
					if (ClientEffDsgtShow) {
						this.base_item.ClearUIEffect(this._gp_dsgt_effect)
						this._gp_dsgt_effect.width = 237
						this._gp_dsgt_effect.height = 120
						this._gp_dsgt_effect.y = -15
						this._gp_dsgt_effect.x = 20
						let cfg = ClientEffDsgtShow["DsgtItemRenderer"][dsgt.id]
						if (!cfg) {
							cfg = ClientEffDsgtShow["DsgtItemRenderer"]["def"]
						}
						this.base_item.AddUIEffect(Trim(dsgt.resource_id), this._gp_dsgt_effect, { x: cfg.x, y: cfg.y }, cfg.scale, true, null, null, null, null, null, null, null, false)
					}
				})

			} else {
				this.resource_image.visible = true
				this._gp_dsgt_effect.visible = false
				ResManager.GetInstance().SetOutsideImageSprite(this, this.resource_image, "resource/game/dsgtIcon/" + dsgt.resource_id + ".png", true, () => {
					if (this.use_delete_method) {
						return
					}
					if (dsgt.main_type == 7) {
						let name = RoleManager.GetInstance().GetMainRoleVo().marriage_name
						let title = (this.data.status > 1 && (name + "的伴侣") || ("某某某的伴侣"))
						this._lb_title.text = title
						// LayoutRebuilder(this._lb_title)
						this.resource_image.sizeGrid = '0,76,0,72'
						SetSizeDelta(this.resource_image, GetSizeDeltaX(this._lb_title) + 90, 52)
					} else {
						this.resource_image.sizeGrid = null
						this._lb_title.text = ''
					}
				})
			}
		}
		let list = this.parent.parent as Laya.List
		if (this.index == list.selectedIndex) {
			this.select.visible = true
		} else {
			this.select.visible = false
		}
		this.SetAdornStatus()
		this.ShowDetails()
		this.ShowAttDetails()
		this.ShowRedDot()
	}

	public SetAdornStatus() {

		let adron_id = DsgtModel.GetInstance().GetAdronDsgtID()
		this.dsgt_adorning_image.visible = adron_id && this.data.id == adron_id
	}

	public ShowLimitTimeDsgt() {


		let currenttime = TimeUtil.getServerTime()
		let time = this.data.end_time - currenttime
		if (time > 24 * 3600) {
			let _time = Math.ceil(time / (24 * 3600))
			return _time + "天"
		} else if (time > 3600) {
			let _time = Math.ceil(time / 3600)
			return _time + "小时"
		} else if (time > 0) {
			let _time = Math.ceil(time / 60)
			return _time + "分"
		} else {
			return ""
		}
	}

	public ShowAttDetails() {

		table.insert(this.attr_label_list, this.attr1)
		table.insert(this.attr_label_list, this.attr2)
		table.insert(this.attr_label_list, this.attr3)
		table.insert(this.attr_label_list, this.attr4)
		//let order_basic = DsgtModel.GetInstance().GetDsgtOrdrtList()
		let attrs_cfg = DsgtModel.GetInstance().GetDsgtAttrs()
		if (!attrs_cfg) {
			return
		}
		let attr_list = null
		if (this.data.status > 1 && this.data.main_type == 3) {
			let cfg_obj = DsgtModel.GetInstance().GetDsgtOrderCfg()
			if (cfg_obj) {
				let c = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_dsgt_order.name, this.data.id + "@" + this.data.order, false, cfg_obj)
				if (c) {
					let list = c.attr_list
					attr_list = JSON.parse(list)
				}
			}
		} else {
			attr_list = this.data.attr_list
		}
		// if (this.attr_label_list.length > 0) {
		// 	for (let index in this.attr_label_list) {

		// 		this.attr_label_list[index].visible = false
		// 	}
		// }

		for (let key in this.attr_label_list) {
			let label = this.attr_label_list[key]
			label.innerHTML = ""
		}

		for (let index in attr_list) {

			let label = this.attr_label_list[index]
			let att_type = attr_list[index] && attr_list[index][0]
			let cur_cfg = attrs_cfg[this.local_Number(att_type)]
			if (cur_cfg) {
				let kind = cur_cfg.kind
				let symbol = cur_cfg.symbol
				let name = cur_cfg.name

				let value = attr_list[index][1]
				let str = (symbol == 2 && ("-") || (""))
				str = str + (kind == 2 && (this.local_Number(value) / 100) || (value))
				str = str + (kind == 2 && ("%") || (""))
				//label.text = [{text:name + "：", style:{size:24, textColor:"#93847d"}], {text=str, style=[size=24, textColor="#89b000"]]]
				// let text = "<font color=0x663915>" + name + ": </font><font color=0xc85a37>" + str + "</font>"
				// label.GetComponent("Text").text = text
				label.style.fontSize = 20;
				label.innerHTML = Util.StrToHTML("<font color='#763320'>" + name + ":</font><font color='#c85a37'>" + str + "</font>")
				label.width = 200
			}
		}
	}

	public ShowDetails() {

		//圣域称号特殊处理  大于0不显示时限
		if (this.data.main_type == 6 && this.data.end_time && this.data.end_time > 0) {
			this.dsgt_status_label.text = ""
		} else {
			this.dsgt_status_label.text = (this.data.status == 0 || this.data.status == 1) && "未激活" || (this.data.expire_time == 0 && "永久有效" || this.ShowLimitTimeDsgt())
		}
		let color = (this.data.status == 0 || this.data.status == 1) && "#9b9b9b" /*Color(155 / 255, 155 / 255, 155 / 255, 255 / 255)*/ || "#0a953e" /*Color(99 / 255, 156 / 255, 18 / 255, 255 / 255)*/
		this.dsgt_status_label.color = color
		this.dsgt_att_label.text = (this.data.status == 0 || this.data.status == 1) && "激活加成：" || "属性加成："
	}

	public ShowRedDot() {


		let red_dic = DsgtModel.GetInstance().GetRedDic()
		if (red_dic && red_dic[this.data.id]) {
			this.dsgt_red_image.visible = true
		} else {
			this.dsgt_red_image.visible = false
		}
	}




	public GetComponents() {
		[
			this._Group2,
			this.bg_dsgtitem_png,
			this.bg_1,
			this._Image1,
			this._Image2,
			this.resource_image,
			this._lb_title,
			this.dsgt_att_label,
			this.dsgt_att_group,
			this.dsgt_adorning_image,
			this._Group1,
			this.dsgt_status_label,
			this._gp_dsgt_effect,
			this._Image3,
			this.select,
			this.dsgt_red_image,
			this.dsgt_att_box1,
			this.dsgt_att_box2,
			this.dsgt_att_box3,
			this.dsgt_att_box4,
			this.attr1,
			this.attr2,
			this.attr3,
			this.attr4
		]
			= this.GetChildrenByNames([

				"_Group2",
				"bg_dsgtitem_png",
				"bg_1",
				"_Image1",
				"_Image2",
				"resource_image",
				"_lb_title",
				"dsgt_att_label",
				"dsgt_att_group",
				"dsgt_adorning_image",
				"_Group1",
				"dsgt_status_label",
				"_gp_dsgt_effect",
				"_Image3",
				"select",
				"dsgt_red_image",
				"dsgt_att_box1",
				"dsgt_att_box2",
				"dsgt_att_box3",
				"dsgt_att_box4",
				"attr1",
				"attr2",
				"attr3",
				"attr4"
			])
	}
}
window["DsgtItemRenderer"] = DsgtItemRenderer
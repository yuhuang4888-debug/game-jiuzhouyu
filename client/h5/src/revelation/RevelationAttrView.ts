import { BaseView1 } from "../common/BaseView1"
import { Util, SetSizeDeltaY } from "../util/Util"
import { table } from "../common/table"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { WordManager } from "../common/WordManager"
import { ErlangParser } from "../util/ErlangParser"
import { RevelationModel, RevelationEvent } from "../commonModel/RevelationModel"
import { GoodsModel } from "../commonModel/GoodsModel"

export class RevelationAttrView extends BaseView1 {
	model
	res_mgr
	goods_model

	InitEvent
	InitView

	public constructor() {
		super()
		this.base_file = "revelation"
		this.layout_file = "RevelationAttrView"
		this.layer_value = Enum_UILayer.Activity
		this.is_center = true
		this.use_background = true
		this.click_bg_toClose = true
		this.show_open_movie = true
		this.destroy_imm = true

		this.model = RevelationModel.GetInstance()
		this.res_mgr = ResManager.GetInstance()
		this.goods_model = GoodsModel.GetInstance()

		this.load_callback = () => {
			this.InitEvent()
			this.InitView()
		}

		this.InitEvent = () => {
			/*
			Util.AddClickEvent(this.closeBtn, () => {
				this.Close()
			}, this, true)
			*/

			this.BindEvent(this.model, RevelationEvent.UPDATE_EQUIP_DATA, (scmd?) => {
				this.InitView()
			})
		}

		this.InitView = () => {
			this.gp_attr.vScrollBar.visible = false

			let attr_dic = []
			let suit_cfgs = this.res_mgr.GetGameConfigFromCache(this, "config_revelation_equip_suit", false)
			let equipCfg = this.res_mgr.GetGameConfigFromCache(this, "config_revelation_equip_attr", false)
			let scmd = this.model.equipData
			if (!scmd) {
				return
			}
			let suit_cfg = null
			let attr = null
			for (let _tmpi in scmd.suit) {
				var vo = scmd.suit[_tmpi]
				suit_cfg = suit_cfgs[vo.star + "@" + vo.num]
				attr = JSON.parse(suit_cfg.attr)
				for (let _tmpi in attr) {
					let value = attr[_tmpi]
					if (!attr_dic[value[0]]) {
						attr_dic[value[0]] = value[1]
					} else {
						attr_dic[value[0]] = attr_dic[value[0]] + value[1]
					}
				}
			}

			let revelation_equip_list = this.goods_model.revelation_equip_list
			let equip_data = null
			let base_attr = null
			let extra_attr = null
			for (let _tmpi in revelation_equip_list) {
				let equip_info = revelation_equip_list[_tmpi]
				if (!equip_info) {
					break
				}
				equip_data = equipCfg[equip_info.type_id]
				base_attr = JSON.parse(equip_data.recommend_attr)
				for (let _tmpi in base_attr) {
					let vo = base_attr[_tmpi]
					if (!attr_dic[vo[0]]) {
						attr_dic[vo[0]] = vo[1]
					} else {
						attr_dic[vo[0]] = attr_dic[vo[0]] + vo[1]
					}
				}
				extra_attr = JSON.parse(equip_data.other_attr)
				for (let _tmpi in extra_attr) {
					let vo = extra_attr[_tmpi]
					if (!attr_dic[vo[0]]) {
						attr_dic[vo[0]] = vo[1]
					} else {
						attr_dic[vo[0]] = attr_dic[vo[0]] + vo[1]
					}
				}
			}

			let stren_data = this.model.equipData.gathering
			let reve_gather_cfg = this.res_mgr.GetGameConfigFromCache(this, "config_revelation_equip_gathering", false)
			let cfg = null
			let add_attr = null
			for (let _tmpi in stren_data) {
				let vo = stren_data[_tmpi]
				cfg = reve_gather_cfg[vo.pos + "@" + vo.lv]
				if (cfg) {
					add_attr = JSON.parse(cfg.attr)
					for (let _tmpi in add_attr) {
						let vo = add_attr[_tmpi]
						if (!attr_dic[vo[0]]) {
							attr_dic[vo[0]] = vo[1]
						} else {
							attr_dic[vo[0]] = attr_dic[vo[0]] + vo[1]
						}
					}
				}
			}

			let index = 0
			let str0 = ""
			let str1 = ""
			let value = null
			let attr_table = []
			for (let key in attr_dic) {
				let vo = Number(attr_dic[key])
				let key_int = Number(key)
				table.insert(attr_table, { 0:key_int, 1:vo })
			}
			table.sort(attr_table, (a?, b?) => {
				return a[0] < b[0]
			})
			for (let key in attr_table) {
				let value = attr_table[key]
				str0 = str0 + WordManager.GetProperties(value[0])
				str1 = str1 + "+" + WordManager.ConvertToPercentValue(value[0], value[1])
				if (Number(key) < (attr_table.length-1)){
					str0 += "\n"
					str1 += "\n"
				}
				/*
				if (index % 2 == 0) {
					str0 = str0 + WordManager.GetProperties(value[0]) + " <font color='#639c12'>+" + WordManager.ConvertToPercentValue(value[0], value[1]) + "</font>\n"
				} else {
					str1 = str1 + WordManager.GetProperties(value[0]) + " <font color='#639c12'>+" + WordManager.ConvertToPercentValue(value[0], value[1]) + "</font>\n"
				}
				index = index + 1
				*/
			}
			this._lb_attr0.text = str0
			this._lb_attr1.text = str1

			let show = (attr_dic.length == 0)
			this.lb_nothing.visible = show

			//SetSizeDeltaY(this.Content, 27 + 49 * (Math.ceil(index / 2) - 1))
		}
	}

	img_bg: Laya.Image
	img_top: Laya.Image
	lb_title: Laya.Label
	gp_attr: Laya.Panel
	gp_content: Laya.Box
	_lb_attr0: Laya.Label
	_lb_attr1: Laya.Label
	lb_nothing: Laya.Label
	public GetComponents() {
		[
			this.img_bg,
			this.img_top,
			this.lb_title,
			this.gp_attr,
			this.gp_content,
			this._lb_attr0,
			this._lb_attr1,
			this.lb_nothing,
		]
			= this.GetChildrenByNames([
				"img_bg",
				"img_top",
				"lb_title",
				"gp_attr",
				"gp_content",
				"_lb_attr0",
				"_lb_attr1",
				"lb_nothing",
			])
	}
}
window["RevelationAttrView"] = RevelationAttrView
import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { WordManager } from "../common/WordManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { HolySealModel } from "../commonModel/HolySealModel"
import { Util } from "../util/Util"

export class HolySealOtherAttrView extends BaseView1 {

	LoadSuccess
	InitEvent
	InitView
	Remove
	data
	public constructor() {
		super()
		this.base_file = "holySeal"
		this.layout_file = "HolySealAttrView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.use_background = true
		this.click_bg_toClose = true
		this.is_center = true
		this.show_open_movie = true
		let model = HolySealModel.GetInstance(),
			local_HolySealModel = HolySealModel,
			res_mgr = ResManager.GetInstance(),
			local_Util = Util,
			local_JSON = JSON,
			local_WordManager = WordManager
		this.load_callback = function () {
			this.LoadSuccess()
		}
		this.destroy_callback = function () {
			this.Remove()
		}
		this.preload_server_config = {
			"config_seal_strong": false,
			"config_seal_suit": false,
			"config_seal_equip": false
		}

		this.LoadSuccess = () => {
			this.InitEvent()
			this._Scroller1.vScrollBarSkin = undefined
			this._lb_attr0.style.fontSize = 20		
			this._lb_attr0.style.color = "#663915"
			this._lb_attr0.style.leading = 25
			this._lb_attr1.style.fontSize = 20
			this._lb_attr1.style.color = "#663915"
			this._lb_attr1.style.leading = 25
			this.InitView()
		}

		this.InitEvent = () => {

		}

		this.InitView = () => {
			let attr_dic = {}

			//套装属性

			let suit_cfgs = res_mgr.GetGameConfigFromCache(this, "config_seal_suit", false)
			for (let vo of this.data.suit_list) {
				let suit_cfg = suit_cfgs[vo.suit_id]
				let attr = local_JSON.parse(suit_cfg.attr)
				for (let value of attr) {
					if (vo.num == value[0]) {
						for (let vo of value[1]) {
							if (!attr_dic[vo[0]]) {
								attr_dic[vo[0]] = vo[1]
							}
							else {
								attr_dic[vo[0]] += vo[1]
							}
						}
					}
				}
			}

			let wear_holy_seal_list = this.data.pos_list
			for (let equip_info of wear_holy_seal_list) {
				if (!equip_info) continue
				let config_seal_equip = res_mgr.GetGameConfigFromCache(this, "config_seal_equip", false)
				let holy_data = model.GetHolySealData(equip_info.type_id, config_seal_equip)

				//基础属性
				let base_attr = local_JSON.parse(holy_data.base_attr)
				for (let vo of base_attr) {
					if (!attr_dic[vo[0]]) {
						attr_dic[vo[0]] = vo[1]
					}
					else {
						attr_dic[vo[0]] += vo[1]
					}
				}

				//极品属性
				let extra_attr = local_JSON.parse(holy_data.extra_attr)
				for (let vo of extra_attr) {
					if (!attr_dic[vo[0]]) {
						attr_dic[vo[0]] = vo[1]
					}
					else {
						attr_dic[vo[0]] += vo[1]
					}
				}
			}

			//强化属性
			let stren_data = this.data.pos_list
			let seal_strong_cfgs = res_mgr.GetGameConfigFromCache(this, "config_seal_strong", false)
			for (let pos in stren_data) {
				let cfg = model.GetHolySealStrenCfg(stren_data[pos].pos, stren_data[pos].strong, seal_strong_cfgs)
				if (cfg) {
					let add_attr = local_JSON.parse(cfg.add_attr)
					for (let vo of add_attr) {
						if (!attr_dic[vo[0]]) {
							attr_dic[vo[0]] = vo[1]
						}
						else {
							attr_dic[vo[0]] += vo[1]
						}
					}
				}
			}

			//圣魂丹
			// let soul_data = model.soul_data
			// if (soul_data) {
			// 	for (let goods_id in soul_data) {
			// 		let data = soul_data[goods_id]
			// 		if (data) {
						for (let vo of this.data.pill_attr) {
							if (!attr_dic[vo.attr]) {
								attr_dic[vo.attr] = vo.value
							}
							else {
								attr_dic[vo.attr] += vo.value
							}
						}
					// }
				// }
			// }

			let index = 0
			let str0 = ""
			let str1 = ""
			for (let key in attr_dic) {
				let value = attr_dic[key]
				if (index % 2 == 0)
					str0 += `${local_WordManager.GetProperties(Number(key))} :${Util.HtmlColorTxt(local_WordManager.ConvertToPercentValue(key, value), "'#0a953e'")}<br/>`
				else
					str1 += `${local_WordManager.GetProperties(Number(key))} :${Util.HtmlColorTxt(local_WordManager.ConvertToPercentValue(key, value), "'#0a953e'")}<br/>`
				index++
			}

			this._lb_attr0.innerHTML = local_Util.StrToHTML(str0)
			this._lb_attr1.innerHTML = local_Util.StrToHTML(str1)

			this._Group1.height = Math.round(index / 2) * 47

			this._lb_attr0.style.width = 300
			this._lb_attr0.style.height = 1000
			this._lb_attr1.style.width = 300
			this._lb_attr1.style.height = 1000
			// this._Group1.height = 1000
		}


		this.Remove = () => {

		}
	}

    public Open (...parms) {
        if (parms) {
           this.data =  parms[0]
        }
        super.Open()
    }
    

	bg1: Laya.Image
	_Image1: Laya.Image
	_Label1: Laya.Label
	_Image2: Laya.Image
	_Scroller1: Laya.Panel
	_Group1: Laya.Box
	_lb_attr0: Laya.HTMLDivElement
	_lb_attr1: Laya.HTMLDivElement
	public GetComponents() {
		[
			this.bg1,
			this._Image1,
			this._Label1,
			this._Image2,
			this._Scroller1,
			this._Group1,
			this._lb_attr0,
			this._lb_attr1,
		]
			= this.GetChildrenByNames([

				"bg1",
				"_Image1",
				"_Label1",
				"_Image2",
				"_Scroller1",
				"_Group1",
				"_lb_attr0",
				"_lb_attr1",
			])
	}
}
window["HolySealOtherAttrView"] = HolySealOtherAttrView
import { BaseView1 } from "../common/BaseView1"
import { table } from "../common/table"
import { Util } from "../util/Util"
import { Enum_UILayer } from "../common/LayerManager"
import { ErlangParser } from "../util/ErlangParser"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { WordManager } from "../common/WordManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { longlangModel } from "../commonModel/longlangModel"

export class PlayerMessageLongLanguageAttrView extends BaseView1 {
	Content
	InitEvent
	InitView
	LoadSuccess
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
		this.preload_server_config = {
			"config_draconic_suit": false,
			"config_draconic_equip": false,
			"config_draconic_strong": false
		}

		let local_longlangModel = longlangModel
		let local_longlangModelIns = local_longlangModel.GetInstance()
		let local_wordMgr = WordManager

		this.load_callback = () => {
			this.LoadSuccess()
		}

		this.LoadSuccess = () => {
			this.InitEvent()
			local_longlangModelIns.Fire(local_longlangModel.SEND_PROTO, 62209)
			this._Scroller1.vScrollBarSkin = undefined
			this._Scroller1.elasticEnabled = true

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
			let attr_dic = []
			let suit_cfgs = ResManager.GetInstance().GetGameConfigFromCache(this, "config_draconic_suit", false)
			let equipCfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_draconic_equip", false)
			for (let _tmpi in this.data.suit_list) {
				let vo = this.data.suit_list[_tmpi]
				let suit_cfg = suit_cfgs[vo.suit_id]
				let attr = JSON.parse(suit_cfg.attr)
				for (let _tmpi in attr) {
					let value = attr[_tmpi]
					if (vo.num >= Number(value[0])) {
						for (let _tmpi in value[1]) {
							let vo = value[1][_tmpi]
							if (!attr_dic[vo[0]]) {
								attr_dic[vo[0]] = vo[1]
							} else {
								attr_dic[vo[0]] = attr_dic[vo[0]] + vo[1]
							}
						}
					}
				}
			}

            let longlanglist = []
            for(let key in this.data.pos_list){
                if(this.data.pos_list[key].type_id){
                    let base_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(this.data.pos_list[key].type_id)
                    longlanglist.push(base_vo)
                }
            }

			// let longlanglist = this.data.pos_list
			for (let _tmpi in longlanglist) {
				let equip_info = longlanglist[_tmpi]
				if (!equip_info) {
					break
				}
				let holy_data = equipCfg[equip_info.type_id]
				let base_attr = JSON.parse(holy_data.base_attr)
				for (let _tmpi in base_attr) {
					let vo = base_attr[_tmpi]
					if (!attr_dic[vo[0]]) {
						attr_dic[vo[0]] = vo[1]
					} else {
						attr_dic[vo[0]] = attr_dic[vo[0]] + vo[1]
					}
				}
				let extra_attr = JSON.parse(holy_data.extra_attr)
				for (let _tmpi in extra_attr) {
					let vo = extra_attr[_tmpi]
					if (!attr_dic[vo[0]]) {
						attr_dic[vo[0]] = vo[1]
					} else {
						attr_dic[vo[0]] = attr_dic[vo[0]] + vo[1]
					}
				}
			}
			let stren_data = this.data.pos_list
			let strong_cfgs = ResManager.GetInstance().GetGameConfigFromCache(this, "config_draconic_strong", false)
			for (let key in stren_data) {
				let vo = stren_data[key]
				let cfg = strong_cfgs[vo.pos + "@" + vo.strong]
				if (cfg) {
					let add_attr = JSON.parse(cfg.add_attr)
					for (let _tmpi in add_attr) {
						let vo = add_attr[_tmpi]
						if (!attr_dic[vo[0]]) {
							attr_dic[vo[0]] = vo[1]
						} else {
							attr_dic[vo[0]] += vo[0]
						}
					}
				}
			}
			let beforeList = []
			let lastList = []
			for (let key in attr_dic) {

				if (Number(key) <= 8 || Number(key) >= 50 && Number(key) <= 52) {
					table.insert(beforeList, key)
				} else {
					table.insert(lastList, key)
				}
			}
			beforeList = beforeList.concat(lastList)
			let index = 0
			let str0 = ""
			let str1 = ""
			table.sort(beforeList, (a?, b?) => {
				return Number(a) < Number(b)
			})
			for (let key in beforeList) {
				let _tmpi = beforeList[key]
				let value = attr_dic[_tmpi]
				if (index % 2 == 0) {
					str0 = str0 + local_wordMgr.GetProperties(Number(_tmpi)) + " <font color='#0a953e'>+" + local_wordMgr.ConvertToPercentValue(_tmpi, value) + "</font><br>"
				} else {
					str1 = str1 + local_wordMgr.GetProperties(Number(_tmpi)) + " <font color='#0a953e'>+" + local_wordMgr.ConvertToPercentValue(_tmpi, value) + "</font><br>"
				}
				index = index + 1
			}
			this._lb_attr0.innerHTML = Util.StrToHTML(str0)
			this._lb_attr1.innerHTML = Util.StrToHTML(str1)
			
			this._lb_attr0.style.width = 300
			this._lb_attr1.style.width = 300
			this._Group1.height = this._lb_attr0.contextHeight
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
window["PlayerMessageLongLanguageAttrView"] = PlayerMessageLongLanguageAttrView
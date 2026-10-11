import { BaseItem1 } from "../common/BaseItem1"
import { table } from "../common/table"
import { Config } from "../common/Config"
import { PlayBigEffect, RefBoxChildsLayout, Util } from "../util/Util"
import { ResManager } from "../common/ResManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { RoleManager } from "../commonModel/RoleManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { EquipModel, EquipEvent, EquipDefine } from "../commonModel/EquipModel"
import { Message } from "../sysInfo/SysInfoController"
import { WordManager } from "../common/WordManager"
import { FightingShowSmallItem } from "../common/FightingShowSmallItem"

import { GodEquipBuildItem } from "./GodEquipBuildItem"
import { GodEquipBMaterialsItem } from "./GodEquipBMaterialsItem"
import { GodEquipBuildAttrItem } from "./GodEquipBuildAttrItem"
import { FightingUpItem } from "../common/FightingUpItem"

export class GodEquipBuildView extends BaseItem1 {
	InitEvent
	LoadSuccess
	UpdateEquipItems

	InitEquip
	ShowEffect
	TouchHandler
	UpdateShow

	model
	goods_model
	cfg_god_equip
	cfg_god_equip_kv
	cfg_god_pos_limit

	public constructor(parent?) {
		super(parent)
		this.base_file = "godequipbuild"
		this.layout_file = "GodEquipBuildView"
		this.preload_server_config = {
			"config_equip_attr": false,
			"config_god_equip_cfg": false,
			"config_god_equip_kv": false,
			"config_equip_strengthen_max": false,
			"config_god_pos_limit": false
		}

		this.model = EquipModel.GetInstance()
		this.goods_model = GoodsModel.GetInstance()
		let local_resMgr = ResManager.GetInstance()
		let mainRoleId = RoleManager.GetInstance().GetMainRoleId()

		let EQUIP_COUNT_ = 10
		let equip_item_list_ = []
		let attr_cfg_ = null
		let limit_cfg_ = null
		let equip_pos_ = null
		let _selectItem_ = null
		let _showItem_ = null
		let _showUpItem_ = null
		let materials_item_list_ = []
		let attr_item_list_ = []
		let materialsList_ = []
		let fight_item
		//let fight_item_up:FightingUpItem

		this.load_callback = () => {
			this.cfg_god_equip = local_resMgr.GetGameConfigFromCache(this, "config_god_equip_cfg", false)
			this.cfg_god_equip_kv = local_resMgr.GetGameConfigFromCache(this, "config_god_equip_kv", false)
			attr_cfg_ = local_resMgr.GetGameConfigFromCache(this, "config_equip_attr", false)
			limit_cfg_ = local_resMgr.GetGameConfigFromCache(this, "config_equip_strengthen_max", false)
			this.cfg_god_pos_limit = local_resMgr.GetGameConfigFromCache(this, "config_god_pos_limit", false)


			this.InitEvent()
			this.LoadSuccess()
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._btn_make, () => {
				if (!_selectItem_.canBuild()) {
					Message.show(this.model.canNotBuildMessage(this.cfg_god_pos_limit, _selectItem_.pos()))
					return
				}
				if (equip_pos_) {
					this.model.Fire(EquipEvent.REQUEST_PROTO, 15218, "c", equip_pos_)
				}
			}, this, true)

			this.BindEvent(this.model, EquipEvent.GOD_EQUIP_UP, () => {
				this.ShowEffect()
			})

			this.BindEvent(this.model, EquipEvent.GOD_EQUIP_DATA, () => {
				this.UpdateEquipItems()
			})

			this.BindEvent(GlobalEventSystem, GoodsModel.CHANGE_GOODS_DYNAMIC, (goods_id?) => {
				let equip = this.goods_model.GetEquipById(goods_id)
				if (!equip) {
					return
				}
				this.UpdateEquipItems()
			})

			this.BindEvent(GlobalEventSystem, EquipEvent.GOD_EQUIP_POWER_UP_RETURN, (power?) => {
				if(fight_item){
					fight_item.UpdatefightingUp(power)
					RefBoxChildsLayout(this._gp_up,3,null,true,"center")
				}
			})

			this.BindEvent(this.goods_model, GoodsModel.CHANGE_BAG_LIST, (goods_list?) => {
				if (this.use_delete_method) {
					return
				}
				//for (let key in materialsList_) {
				//let materials = materialsList_[key]
				//for (let key in goods_list) {
				//let goods = goods_list[key]
				//if (Number(materials[1]) == goods.type_id ) {
				//this:UpdateEquipItems()
				//return
				//}
				//}
				//}
				this.UpdateEquipItems()
				this.model.ChangeVar("godEquip_red_dot", this.model.godEquipRedDot(), false, true)
			})
		}

		this.LoadSuccess = () => {
			// if (PlatformMgr.GetInstance().IsEyouEnPlatform()) {
			// 	this._lb_title.size = 16
			// 	this._Label1.size = 16
			// 	this._lb_desc.size = 16
			// }
			this._Scroller1.vScrollBarSkin = ""
			this._lb_desc.style.color = "#663915"
			this._lb_desc.style.fontSize = 20
			this._lb_desc.style.wordWrap = false

			fight_item = new FightingShowSmallItem(this._gp_fight)
			fight_item.Load()
			// fight_item_up = new FightingUpItem(this._gp_fight_up)
			// fight_item_up.IsCenter(true,false)
			// fight_item_up.Load()

			this.InitEquip()
		}

		this.InitEquip = () => {
			let group_con = null
			let item = null
			let i = 0
			do {
				let pos = EquipDefine.EQUIP_POS[i]
				item = equip_item_list_[pos]
				if (!item) {
					group_con = this["_gp_" + (i + 1)]
					item = new GodEquipBuildItem(group_con)
					item.SetEquipPos(pos)
					item.Load()
					equip_item_list_[pos] = item

					item.SetClickFun((equip_type?) => {
						this.TouchHandler(equip_type)
					})
				}
				i = i + 1
			} while ((i < EQUIP_COUNT_))
			let index = this.model.godEquipIndex(attr_cfg_)
			equip_pos_ = EquipDefine.EQUIP_POS[index]
			this.UpdateEquipItems()
		}

		this.UpdateEquipItems = () => {
			let attr_cfg = null
			let limit_cfg = null
			let item = null
			let equip = null
			let role_id = mainRoleId
			let equipInfos = this.model.GetWearEquipInfos()
			let i = 0
			do {
				let pos = EquipDefine.EQUIP_POS[i]
				item = equip_item_list_[pos]
				equip = equipInfos[pos]
				if (equip) {
					attr_cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_equip_attr.name, equip.type_id, false, attr_cfg_)
					limit_cfg = limit_cfg_[attr_cfg.stage + "@" + equip.color + "@" + equip.cell]
					item.SetCfgs(limit_cfg, attr_cfg)
					item.SetData(equip, role_id)
				} else {
					item.SetData(null, role_id)
				}
				if (pos == equip_pos_) {
					_selectItem_ = item
					item.setSelect(true)
				}
				i = i + 1
			} while ((i < EQUIP_COUNT_))
			this.UpdateShow()
		}

		this.TouchHandler = (equip_type?) => {
			//let index = equip_type
			if (equip_pos_ == equip_type) {
				return
			}
			let item = equip_item_list_[equip_type]
			if (!item.equip_data()) {
				return
			}
			if (!item.canSelect()) {
				Message.show(this.model.canNotBuildMessage(this.cfg_god_pos_limit, item.pos()))
				return
			}
			equip_pos_ = equip_type
			_selectItem_.setSelect(false)
			item.setSelect(true)
			_selectItem_ = item
			this.UpdateShow()
		}

		this.UpdateShow = () => {
			if (!_selectItem_ || !_selectItem_.equip_data()) {
				this._gp_tips.visible = false
				this._lb_tips.visible = true
				return
			}

			let data = _selectItem_.equip_data()
			let canBuild = _selectItem_.canBuild()
			if (!_selectItem_.is_loaded) {
				//let attr_list = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_equip_attr.name, data.type_id, false)
				let c = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_equip_attr.name, data.type_id, false, attr_cfg_)
				canBuild = this.model.checkFullPos(data.cell, data.color, c.stage, c.star)
			}

			let info = this.model.getGodEquipInfo(equip_pos_)
			let level = (!info || !info.level) && 0 || info.level
			let conf = this.model.getGodEquipConf(equip_pos_, level)
			let nextConf = this.model.getGodEquipConf(equip_pos_, level + 1)
			this._gp_max_hide.visible = nextConf != null
			materialsList_ = []
			if ((conf && conf.cost) && this._gp_max_hide.visible) {
				materialsList_ = JSON.parse(conf.cost)
			}
			let i = 0
			do {
				let _gp = this["_Group" + (6 + i)]
				let _item = materials_item_list_[i]
				let data = materialsList_[i]
				if (!_item) {
					_item = new GodEquipBMaterialsItem(_gp)
					_item.Load()
					table.insert(materials_item_list_, _item)
				}
				_item.setData(data)
				i = i + 1
			} while ((i < this._gp_materials.numChildren))

			if ((nextConf && nextConf.extra_attr) && Number(nextConf.extra_attr) != 0) {
				let att = (conf && (Math.floor(Number(conf.extra_attr) / 100)) || (0))
				let nextAtt = Math.floor(Number(nextConf.extra_attr) / 100) - att
				this._lb_attr_up.text = WordManager.GetEquipPos(_selectItem_.equip_data().cell) + "专有属性: " + att + "%  +" + nextAtt + "%"
			} else if ((conf && conf.extra_attr) && Number(conf.extra_attr) != 0) {
				let att = Math.floor(Number(conf.extra_attr) / 100)
				this._lb_attr_up.text = WordManager.GetEquipPos(_selectItem_.equip_data().cell) + "专有属性: " + att + "%"
			}

			fight_item.Updatefighting(this.model.godEquip_total_power)
			this._gp_fight.event(Laya.Event.RESIZE)
			let can_build = this._gp_max_hide.visible && nextConf && canBuild
			if (!can_build) {
				fight_item.UpdatefightingUp(0)
			}
			// fight_item_up.SetVisible(can_build)
			this._gp_fight_up.visible = false
			RefBoxChildsLayout(this._gp_up,3,null,true,"center")
			if (can_build) {
				this.model.Fire(EquipEvent.REQUEST_PROTO, 15219, "c", equip_pos_)
			}
			if (!equip_pos_) {
				return
			}
			let godEquip_cfg = this.cfg_god_equip[level + 1]
			this._lb_desc.innerHTML = ""
			if (godEquip_cfg) {
				this._lb_desc.innerHTML = Util.StrToHTML("可唤醒<font color='#2971e6'>" + godEquip_cfg.max + "阶</font>及以下装备 ,获取神装专享<font color='#2971e6'>极品属性！</font>")
			} else {
				godEquip_cfg = this.cfg_god_equip[level]
				if (godEquip_cfg) {
					this._lb_desc.innerHTML = Util.StrToHTML("可唤醒<font color='#2971e6'>" + godEquip_cfg.max + "阶</font>及以下装备 ,获取神装专享<font color='#2971e6'>极品属性！</font>")
				}
			}
			this.CallLater(() => {
				this._lb_desc.event("resize")
			})

			let attr_cfg = null
			let limit_cfg = null
			let role_id = mainRoleId
			let godEquipInfo = this.model.getGodEquipInfo(equip_pos_)
			let godlevel = godEquipInfo && godEquipInfo.level || 0
			Util.SetImageGray(this._img_make, false)
			if (this._gp_max_hide.visible) {
				if (!_showItem_) {
					_showItem_ = new GodEquipBuildItem(this._gp_show)
					_showItem_.Load()
				}

				attr_cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_equip_attr.name, data.type_id, false, attr_cfg_)
				limit_cfg = limit_cfg_[attr_cfg.stage + "@" + data.color + "@" + data.cell]
				_showItem_.SetCfgs(limit_cfg, attr_cfg)
				_showItem_.SetData(data, role_id, null, false, false)
				let str = this.model.getGodEquipName(this.cfg_god_equip, godlevel)
				this._lb_show_name.text = str + data.goods_name
				let name_width1 = Math.max(168, this._lb_show_name.width + 30)
				this._img_namebg1.width = name_width1

				this._btn_make.mouseEnabled = true
				this._lb_make.text = '神装打造'
				Util.SetImageGray(this._img_make, !canBuild)
			} else {
				this._btn_make.mouseEnabled = false
				this._lb_make.text = '已满级'
			}
			this._btn_red_dot.visible = this.model.godEquipitemRedDot(_selectItem_.equip_data()) && canBuild
			if (this._gp_max_hide.visible) {
				godlevel = godlevel + 1
			}
			if (!_showUpItem_) {
				_showUpItem_ = new GodEquipBuildItem(this._gp_show_up)
				_showUpItem_.Load()
			}
			attr_cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_equip_attr.name, data.type_id, false, attr_cfg_)
			limit_cfg = limit_cfg_[attr_cfg.stage + "@" + data.color + "@" + data.cell]
			_showUpItem_.SetCfgs(limit_cfg, attr_cfg)
			_showUpItem_.SetData(data, role_id, null, false, false, this._gp_max_hide.visible, godlevel)
			let strUp = this.model.getGodEquipName(this.cfg_god_equip, godlevel)
			this._lb_show_up_name.text = strUp + data.goods_name
			let name_width2 = Math.max(168, this._lb_show_up_name.width + 30)
			this._img_namebg2.width = name_width2
			this._lb_title2.text = strUp + data.goods_name
			let index = 0
			let attrList = []
			let nextattrList = []
			if (nextConf && nextConf.base_attr_add) {
				let ConfList = JSON.parse(nextConf.base_attr_add)
				for (let key in ConfList) {
					let obj = ConfList[key]
					if (obj[0] == "attr") {
						for (let key in obj[1]) {
							let attr = obj[1][key]
							table.insert(nextattrList, attr)
						}
					} else {
						let newObj = ["base_attr", obj[1]]
						table.insert(nextattrList, newObj)
					}
				}
			}
			if (conf && conf.base_attr_add) {
				let ConfList = JSON.parse(conf.base_attr_add)
				for (let key in ConfList) {
					let obj = ConfList[key]
					if (obj[0] == "attr") {
						for (let key in obj[1]) {
							let attr = obj[1][key]
							table.insert(attrList, attr)
						}
					} else {
						let newObj = ["base_attr", obj[1]]
						table.insert(attrList, newObj)
					}
				}
			}
			let length = (attrList.length > 0 && (attrList.length) || (nextattrList.length))
			let key = 0
			if (key < length) {
				do {
					let info = attrList[key]
					let nextInfo = nextattrList[key]
					let attr_item = attr_item_list_[index]
					if (!attr_item) {
						attr_item = new GodEquipBuildAttrItem(this.Content)
						attr_item.Load()
						table.insert(attr_item_list_, attr_item)
					}
					attr_item.visible = true
					attr_item.setData(data, info, nextInfo, attr_cfg_, this._gp_max_hide.visible)
					index = index + 1
					key = key + 1
				} while ((key < length))
			}

			if (length < attr_item_list_.length) {
				let i = index
				do {
					let attr_item = attr_item_list_[i]
					attr_item.visible = false
					i = i + 1
				} while ((i < attr_item_list_.length))
			}
		}

		this.ShowEffect = () => {
			PlayBigEffect("ui_dazaochengong", { x: -1.1, y: 0 })
		}

		this.DeleteMe = () => {
			equip_pos_ = null
			_selectItem_ = null
			materialsList_ = []
			attr_cfg_ = null
			limit_cfg_ = null

			for (let key in equip_item_list_) {
				let item = equip_item_list_[key]
				item.DeleteMe()
			}
			equip_item_list_ = []

			if (_showItem_) {
				_showItem_.DeleteMe()
				_showItem_ = null
			}
			if (_showUpItem_) {
				_showUpItem_.DeleteMe()
				_showUpItem_ = null
			}
			if (fight_item) {
				fight_item.DeleteMe()
				fight_item = null
			}

			// if (fight_item_up) {
			// 	fight_item_up.DeleteMe()
			// 	fight_item_up = null
			// }
			for (let key in materials_item_list_) {
				let materials_item = materials_item_list_[key]
				materials_item.DeleteMe()
			}
			materials_item_list_ = []

			for (let key in attr_item_list_) {
				let materials_item = attr_item_list_[key]
				materials_item.DeleteMe()
			}
			attr_item_list_ = []

			super.DeleteMe()
		}
	}

	_Group1: Laya.Box
	_img_line: Laya.Image
	_img_bg0: Laya.Image
	_lb_title1: Laya.Label
	_gp_item: Laya.Box
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
_gp_up:Laya.Box
	_gp_fight: Laya.Box
_gp_fight_up:Laya.Box
	_gp_max_hide: Laya.Box
	_img_arrow: Laya.Image
	_img_bg1: Laya.Image
	_gp_show: Laya.Box
	_img_namebg1: Laya.Image
	_lb_show_name: Laya.Label
	_gp_showD: Laya.Box
	_img_bg2: Laya.Image
	_gp_show_up: Laya.Box
	_img_namebg2: Laya.Image
	_lb_show_up_name: Laya.Label
	_gp_tips: Laya.Box
	_img_bg3: Laya.Image
	_img_titlebg1: Laya.Image
	_lb_title2: Laya.Label
	_img_titlebg2: Laya.Image
	_lb_title3: Laya.Label
	_gp_desc: Laya.HBox
	_lb_desc: Laya.HTMLDivElement
	_lb_attr_up: Laya.Label
	_Scroller1: Laya.Panel
	Content: Laya.VBox
	_lb_tips: Laya.Label
	_img_bg4: Laya.Image
	_lb_cost: Laya.Label
	_gp_materials: Laya.Box
	_Group6: Laya.Box
	_Group7: Laya.Box
	_Group8: Laya.Box
	_btn_make: Laya.Box
	_img_make: Laya.Image
	_lb_make: Laya.Label
	_btn_red_dot: Laya.Image
	public GetComponents() {
		[
			this._Group1,
			this._img_line,
			this._img_bg0,
			this._lb_title1,
			this._gp_item,
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
			this._gp_up,
			this._gp_fight,
this._gp_fight_up,
			this._gp_max_hide,
			this._img_arrow,
			this._img_bg1,
			this._gp_show,
			this._img_namebg1,
			this._lb_show_name,
			this._gp_showD,
			this._img_bg2,
			this._gp_show_up,
			this._img_namebg2,
			this._lb_show_up_name,
			this._gp_tips,
			this._img_bg3,
			this._img_titlebg1,
			this._lb_title2,
			this._img_titlebg2,
			this._lb_title3,
			this._gp_desc,
			this._lb_desc,
			this._lb_attr_up,
			this._Scroller1,
			this.Content,
			this._lb_tips,
			this._img_bg4,
			this._lb_cost,
			this._gp_materials,
			this._Group6,
			this._Group7,
			this._Group8,
			this._btn_make,
			this._img_make,
			this._lb_make,
			this._btn_red_dot,
		]
			= this.GetChildrenByNames([

				"_Group1",
				"_img_line",
				"_img_bg0",
				"_lb_title1",
				"_gp_item",
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
				"_gp_up",
				"_gp_fight",
"_gp_fight_up",
				"_gp_max_hide",
				"_img_arrow",
				"_img_bg1",
				"_gp_show",
				"_img_namebg1",
				"_lb_show_name",
				"_gp_showD",
				"_img_bg2",
				"_gp_show_up",
				"_img_namebg2",
				"_lb_show_up_name",
				"_gp_tips",
				"_img_bg3",
				"_img_titlebg1",
				"_lb_title2",
				"_img_titlebg2",
				"_lb_title3",
				"_gp_desc",
				"_lb_desc",
				"_lb_attr_up",
				"_Scroller1",
				"Content",
				"_lb_tips",
				"_img_bg4",
				"_lb_cost",
				"_gp_materials",
				"_Group6",
				"_Group7",
				"_Group8",
				"_btn_make",
				"_img_make",
				"_lb_make",
				"_btn_red_dot",
			])
	}
}
window["GodEquipBuildView"] = GodEquipBuildView
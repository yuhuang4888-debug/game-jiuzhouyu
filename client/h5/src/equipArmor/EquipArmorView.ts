import { BaseItem1 } from "../common/BaseItem1"
import { PlayBigEffect, Util } from "../util/Util"
import { table } from "../common/table"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { Message } from "../sysInfo/SysInfoController"
import { LoopScrowViewMgr, LoopScrCon } from "../common/LoopScrowViewMgr"
import { ArmorModel } from "../commonModel/ArmorModel"
import { ArmorAttrItem } from "./ArmorAttrItem"
import { ArmorTabItem } from "./ArmorTabItem"
import { ArmorItem } from "./ArmorItem"
import { Status } from "../util/Status"
import { WordManager } from "../common/WordManager"

export class EquipArmorView extends BaseItem1 {
	model: ArmorModel
	res_mgr

	data
	armour_cfg
	suit_cfg
	first_open
	click_time = 0
	time_int = 0.5
	select_id
	select_pos
	select_stage
	select_type

	dnattr_items
	equip_items
	make_items
	tag_item
	stage_loop_mgr
	upattr_items

	public constructor(parent?) {
		super(parent)
		this.base_file = "equipArmor"
		this.layout_file = "EquipArmorView"
		this.preload_server_config = {
			"config_armour_equipment": false,
			"config_armour_suit": false
		}

		this.model = ArmorModel.GetInstance()
		this.res_mgr = ResManager.GetInstance()

		this.data = []
		this.first_open = true
		this.select_stage = 1		// 战甲阶数
		this.select_type = 1		// 战甲类型.1起源  2圣遗
		this.select_pos = 1			// 战甲位置.1~5
		this.select_id = 0			// 战甲id

		this.stage_loop_mgr = null
		this.upattr_items = []
		this.dnattr_items = []
		this.equip_items = []
		this.make_items = []

		this.load_callback = () => {
			this.armour_cfg = this.res_mgr.GetGameConfigFromCache(this, "config_armour_equipment", false)
			this.suit_cfg = this.res_mgr.GetGameConfigFromCache(this, "config_armour_suit", false)

			this.InitEvent()
			this.LoadSucces()
		}
	}

	public DeleteMe() {
		if (this.stage_loop_mgr) {
			this.stage_loop_mgr.DeleteMe()
			this.stage_loop_mgr = null
		}

		if (this.tag_item) {
			this.tag_item.DeleteMe()
			this.tag_item = null
		}

		this.ClearUpAttr()
		this.ClearDownAttr()
		this.ClearEquipItems()
		this.ClearMakeItems()

		super.DeleteMe()
	}

	public ClearUpAttr() {
		if (this.upattr_items) {
			for (let _ in this.upattr_items) {
				let vo = this.upattr_items[_]
				vo.DeleteMe()
			}
			this.upattr_items = []
		}
	}

	public ClearDownAttr() {
		if (this.dnattr_items) {
			for (let _ in this.dnattr_items) {
				let vo = this.dnattr_items[_]
				vo.DeleteMe()
			}
			this.dnattr_items = []
		}
	}

	public ClearEquipItems() {
		if (this.equip_items) {
			for (let _ in this.equip_items) {
				let vo = this.equip_items[_]
				vo.DeleteMe()
			}
			this.equip_items = []
		}
	}

	public ClearMakeItems() {
		if (this.make_items) {
			for (let _ in this.make_items) {
				let vo = this.make_items[_]
				vo.DeleteMe()
			}
			this.make_items = []
		}
	}

	public LoadSucces() {
		this.model.Fire(ArmorModel.REQUEST_SCMD, 14401, 0, 0)
		this._gp_attr.vScrollBar.visible = false
		this._gp_attr2.vScrollBar.visible = false
		this.res_mgr.SetOutsideImageSprite(this, this.upBG, "resource/game/equipArmor/other/ui_forge_11.png")

		this._lb_msg.width = 400
		this._lb_msg.style.color = "#fe9118"
		this._lb_msg.style.fontSize = 24

		this.lb_left.width = 190
		this.lb_left.style.color = "#663915"
		this.lb_left.style.fontSize = 20
		this.lb_left.style.leading = 10

		this.lb_right.width = 190
		this.lb_right.style.color = "#663915"
		this.lb_right.style.fontSize = 20
		this.lb_right.style.leading = 10
	}

	public InitEvent() {
		Util.AddClickEvent(this._btn_all, () => {
			this.model.show_stage = this.select_stage
			this.model.Fire(ArmorModel.OPEN_VIEW, "ArmorAttrView")
		}, this, true)

		Util.AddClickEvent(this._btn_make, () => {
			if ((Status.NowTime - this.click_time) < this.time_int) {
				return
			}
			this.click_time = Status.NowTime

			let ans = this.model.CheckUpdate(this.select_stage, this.select_type, this.select_pos, this.armour_cfg)
			if (ans == 1) {
				this.model.Fire(ArmorModel.REQUEST_SCMD, 14402, this.select_stage, this.select_type, this.select_pos)
			} else if (ans == 0) {
				Message.show("材料不足~")
			} else {
				Message.show("已打造~")
			}
		}, this, true)

		Util.AddClickEvent(this.leftBtn, () => {
			this.UpdateBtnUI(1)
		}, this, true)

		Util.AddClickEvent(this.rightBtn, () => {
			this.UpdateBtnUI(2)
		}, this, true)

		this.BindEvent(this.model, ArmorModel.UPDATE_ARMOR_VIEW, () => {
			this.model.CheckRedSate(this.armour_cfg)
			this.InitView()
			this.UpdateBtnUI(this.select_type)
		})

		this.BindEvent(this.model, ArmorModel.SELECT_EQUIP, (data?) => {
			this.select_pos = data.pos
			this.UpdateSingel(data)
		})

		this.BindEvent(this.model, ArmorModel.UPDATE_RED, () => {
			this.UpdateRed()
		})

		this.BindEvent(this.model, ArmorModel.MAKE_SUCCED, () => {
			PlayBigEffect("ui_dazaochengong", { x: -0.85, y: 0.55 }, 1.5)
			this.InitSelectByRed()
			this.stage_loop_mgr.SetSelectIndex(this.select_stage - 1)
			this.UpdateBtnUI(this.select_type)
		})
	}

	public InitView() {
		this.data = this.model.data

		if (!this.stage_loop_mgr) {
			this.stage_loop_mgr = new LoopScrowViewMgr()
			this.stage_loop_mgr.SetData(this._gp_tabs, ArmorTabItem, this.data, LoopScrCon.Vertical, 1, (index?) => {
				let data = this.data[index]
				if (!data) {
					return
				}
				if (data.lock) {
					Message.show(data.tips + "开启")
					return
				}
				if (this.select_stage != data.stage) {
					this.select_stage = data.stage
					this.select_type = 1
					this.select_pos = 1
				}

				this.UpdateBtnUI(this.select_type)
				this.model.Fire(ArmorModel.UPDATE_SELECT_TAB, data.stage)
			})
		} else {
			this.stage_loop_mgr.replaceAll(this.data)
		}

		// 等阶默认选中
		if (this.first_open) {
			this.InitSelectByRed()
			this.first_open = false
		}
		this.stage_loop_mgr.SetSelectIndex(this.select_stage - 1)
	}

	public UpdateBtnUI(type?) {
		let ans = type == 1
		this._lb_left.color = ans ? "#9b572f" : "#d7d9ed"
		this._lb_right.color = ans ? "#d7d9ed" : "#9b572f"
		let url_left = ans ? "uizj_007" : "uizj_008"
		let url_right = ans ? "uizj_008" : "uizj_007"
		this.res_mgr.SetImageSprite(this, this._btn_left, "equipArmor", url_left)
		this.res_mgr.SetImageSprite(this, this._btn_right, "equipArmor", url_right)
		this.UpdateRed()

		this.select_type = type
		this.UpdateAll()
	}

	// 刷新一套战甲显示
	public UpdateAll() {
		let attr_list = this.model.GetSuitAttrList(this.select_stage, this.select_type, this.suit_cfg)
		let item = null
		let index = 0
		let str_left = ""
		let str_right = ""
		for (let i in attr_list) {
			let vo = attr_list[i]
			let name = WordManager.GetProperties(vo[0]) + ": "
			let value = WordManager.ConvertToPercentValue(vo[0], vo[1])
			let str = name + "<font color='#d15e00'>" + value + "</font>"
			if (index % 2 == 0) {
				str_left = str_left + str + "<br/>"
			} else {
				str_right = str_right + str + "<br/>"
			}
			index = index + 1
		}
		this.lb_left.innerHTML = str_left
		this.lb_right.innerHTML = str_right
		this.lb_left.width = 190
		this.lb_right.width = 190

		let type_data = this.data[Math.max(0, this.select_stage - 1)].type_list[Math.max(0, this.select_type - 1)]
		let num_totle = type_data.pos_list.length
		let num_active = 0
		for (let i in type_data.pos_list) {
			let vo = type_data.pos_list[i]
			if (vo.status == 1) {
				num_active = num_active + 1
			}
		}
		let str_ans = this.select_type == 1 ? "启源战甲套装" : "圣遗战甲套装"
		str_ans = str_ans + num_active + "/" + num_totle
		let str_status = type_data.status == 1 ? "<font color='#6CBF25'>[已激活]</font>" : "<font color='#898989'>[未激活]</font>"
		this._lb_msg.innerHTML = str_ans + str_status
		this._lb_msg.width = 400
		this.gp_msg.width = this._lb_msg.contextWidth

		for (let i in type_data.pos_list) {
			let vo = type_data.pos_list[i]
			item = this.equip_items[i]
			if (!item) {
				item = new ArmorItem(this._gp_equips)
				item.Load()
				this.equip_items[i] = item
			}
			item.SetData(vo, 1)
			item.select = false
		}
		let pos = this.select_pos > 5 ? (this.select_pos - 5) : this.select_pos
		this.equip_items[pos - 1].select = true
		this.model.Fire(ArmorModel.SELECT_EQUIP, this.equip_items[pos - 1].data)
	}

	// 刷新单个装备显示
	public UpdateSingel(data?) {
		let attr_list = this.model.GetEquipAttrList(data.gtype_id, this.armour_cfg)
		let item = null
		let type = data.status == 1 ? 1 : 2
		let index = 0
		for (let i in attr_list) {
			let vo = attr_list[i]
			item = this.upattr_items[index]
			if (!item) {
				item = new ArmorAttrItem(this.Content2)
				item.Load()
				this.upattr_items[index] = item
			}
			item.SetData(vo, type)
			if (!item.GetVisible()) {
				item.SetVisible(true)
			}
			index = index + 1
		}
		for (let i = index; i < this.upattr_items.length; i++) {
			this.upattr_items[i].SetVisible(false)
		}

		let cfg = this.armour_cfg[data.gtype_id]
		this._img_red.visible = this.model.CheckPosRed(cfg.stage, cfg.type, cfg.pos, this.armour_cfg)
		this._lb_make.text = data.status == 1 ? "已打造" : "打造"
		this._btn_make.gray = data.status == 1

		if (!this.tag_item) {
			this.tag_item = new ArmorItem(this._gp_curr)
			this.tag_item.Load()
		}
		this.tag_item.SetData({ gtype_id: data.gtype_id }, 2)
		this.tag_item.SetScale(0.85)

		let make_list = []
		let consume_list = this.model.GetEquipConsume(data.gtype_id, this.armour_cfg)
		if (consume_list.length == 1) {
			table.insert(make_list, [{ gtype_id: 0, num: 0 }, 3, 0])
			for (let i = 0; i < 2; i++) {
				let vo = consume_list[i]
				if (vo) {
					table.insert(make_list, [{ gtype_id: vo[1], num: vo[2] }, 3, (i + 1)])
				} else {
					table.insert(make_list, [{ gtype_id: 0, num: 0 }, 3, (i + 1)])
				}
			}
		} else {
			for (let i = 0; i < 3; i++) {
				let vo = consume_list[i]
				if (vo) {
					table.insert(make_list, [{ gtype_id: vo[1], num: vo[2] }, 3, i])
				} else {
					table.insert(make_list, [{ gtype_id: 0, num: 0 }, 3, i])
				}
			}
		}
		for (let i in make_list) {
			let vo = make_list[i]
			item = this.make_items[i]
			if (!item) {
				item = new ArmorItem(this._gp_mat)
				item.Load()
				this.make_items[i] = item
			}
			item.SetData(vo[0], vo[1], vo[2])
		}
	}

	public InitSelect() {
		for (let k in this.data) {
			let vo = this.data[k]
			if (vo.lock) {
				if (Number(k) == 0) {
					this.select_stage = vo.stage
				} else {
					this.select_stage = this.data[Number(k) - 1].stage
				}
				return
			}
			if (!vo.status) {
				this.select_stage = vo.stage
				for (let temp in vo.type_list) {
					let vo2 = vo.type_list[temp]
					if (vo2.status == 0) {
						this.select_type = vo2.type
						for (let temp2 in vo2.pos_list) {
							let vo3 = vo2.pos_list[temp2]
							if (vo3.status == 0) {
								this.select_pos = vo3.pos
								return
							}
						}
					}
				}
			}
		}
	}

	public InitSelectByRed() {
		for (let k in this.data) {
			let vo = this.data[k]
			if (!vo.lock) {
				if (!vo.status) {
					this.select_stage = vo.stage
					for (let temp in vo.type_list) {
						let vo2 = vo.type_list[temp]
						if (vo2.status == 0) {
							this.select_type = vo2.type
							for (let temp2 in vo2.pos_list) {
								let vo3 = vo2.pos_list[temp2]
								if (vo3.status == 0) {
									let cfg = this.armour_cfg[vo3.gtype_id]
									if (cfg) {
										let red = this.model.CheckPosRed(cfg.stage, cfg.type, cfg.pos, this.armour_cfg)
										if (red) {
											this.select_pos = vo3.pos
											return
										}
									}
								}
							}
						}
					}
				}
			}
		}

		this.InitSelect()
	}

	public UpdateRed() {
		this._img_red1.visible = this.model.CheckTypeRed(this.select_stage, 1, this.armour_cfg)
		this._img_red2.visible = this.model.CheckTypeRed(this.select_stage, 2, this.armour_cfg)
	}

	_gp_up: Laya.Box
	upBG: Laya.Image
	_btn_all: Laya.Image
	_Image1: Laya.Image
	_Image2: Laya.Image
	_Image3: Laya.Image
	_Image4: Laya.Image
	_Image5: Laya.Image
	_Image6: Laya.Image
	_lb_title2: Laya.Label
	_gp_attr: Laya.Panel
	Content2: Laya.VBox
	_gp_mat: Laya.Box
	_gp_curr: Laya.Box
	_gp_left: Laya.Box
	_img_arrow0: Laya.Image
	_img_line: Laya.Image
	_lb_title: Laya.Label
	_img_arrow: Laya.Image
	_gp_tabs: Laya.List
	_btn_make: Laya.Box
	img_make: Laya.Image
	_lb_make: Laya.Label
	_img_red: Laya.Image
	_gp_down: Laya.Image
	_Image7: Laya.Image
	leftBtn: Laya.Box
	_btn_left: Laya.Image
	_lb_left: Laya.Label
	rightBtn: Laya.Box
	_btn_right: Laya.Image
	_lb_right: Laya.Label
	_img_red2: Laya.Image
	_img_red1: Laya.Image
	gp_msg: Laya.HBox
	_lb_msg: Laya.HTMLDivElement
	_gp_attr2: Laya.Panel
	Content3: Laya.Box
	lb_left: Laya.HTMLDivElement
	lb_right: Laya.HTMLDivElement
	_gp_equips: Laya.HBox
	_gp_effect: Laya.Box
	public GetComponents() {
		[
			this._gp_up,
			this.upBG,
			this._btn_all,
			this._Image1,
			this._Image2,
			this._Image3,
			this._Image4,
			this._Image5,
			this._Image6,
			this._lb_title2,
			this._gp_attr,
			this.Content2,
			this._gp_mat,
			this._gp_curr,
			this._gp_left,
			this._img_arrow0,
			this._img_line,
			this._lb_title,
			this._img_arrow,
			this._gp_tabs,
			this._btn_make,
			this.img_make,
			this._lb_make,
			this._img_red,
			this._gp_down,
			this._Image7,
			this.leftBtn,
			this._btn_left,
			this._lb_left,
			this.rightBtn,
			this._btn_right,
			this._lb_right,
			this._img_red2,
			this._img_red1,
			this.gp_msg,
			this._lb_msg,
			this._gp_attr2,
			this.Content3,
			this.lb_left,
			this.lb_right,
			this._gp_equips,
			this._gp_effect,
		]
			= this.GetChildrenByNames([

				"_gp_up",
				"upBG",
				"_btn_all",
				"_Image1",
				"_Image2",
				"_Image3",
				"_Image4",
				"_Image5",
				"_Image6",
				"_lb_title2",
				"_gp_attr",
				"Content2",
				"_gp_mat",
				"_gp_curr",
				"_gp_left",
				"_img_arrow0",
				"_img_line",
				"_lb_title",
				"_img_arrow",
				"_gp_tabs",
				"_btn_make",
				"img_make",
				"_lb_make",
				"_img_red",
				"_gp_down",
				"_Image7",
				"leftBtn",
				"_btn_left",
				"_lb_left",
				"rightBtn",
				"_btn_right",
				"_lb_right",
				"_img_red2",
				"_img_red1",
				"gp_msg",
				"_lb_msg",
				"_gp_attr2",
				"Content3",
				"lb_left",
				"lb_right",
				"_gp_equips",
				"_gp_effect",
			])
	}
}
window["EquipArmorView"] = EquipArmorView
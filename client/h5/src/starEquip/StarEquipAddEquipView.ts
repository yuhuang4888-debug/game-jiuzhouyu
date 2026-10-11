import { BaseView1 } from "../common/BaseView1"
import { Util } from "../util/Util"
import { table } from "../common/table"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { LoopScrowViewMgr, LoopScrCon } from "../common/LoopScrowViewMgr"
import { GoodsModel } from "../commonModel/GoodsModel"
import { StarEquipModel } from "../commonModel/StarEquipModel"
import { StarEquipAddEquipItem } from "./StarEquipAddEquipItem"

export class StarEquipAddEquipView extends BaseView1 {
	EmpenterBtn
	Open
	SetBagList
	SetLb
	itemGp
	ruleId
	cfg_equip

	public constructor() {
		super()
		this.base_file = "starEquip"
		this.layout_file = "StarEquipAddEquipView"
		this.layer_value = Enum_UILayer.Activity
		this.is_center = true
		this.use_background = true
		this.click_bg_toClose = true
		this.destroy_imm = true
		this.preload_server_config = {
			"config_constellation_equip": false
		}

		//let local_util = Util
		let local_StarEquipModel = StarEquipModel
		let local_starEquipIns = local_StarEquipModel.GetInstance()
		let itemArr = null

		this.load_callback = () => {
			this._Scroller1.scrollBar.visible = false
			this.lb1.style.fontSize = 22
			this.lb1.style.color = "#4a3a32"
			this.lb1.style.wordWrap = false
			this.lb2.style.fontSize = 22
			this.lb2.style.color = "#4a3a32"
			this.lb2.style.wordWrap = false

			this.cfg_equip = ResManager.GetInstance().GetGameConfigFromCache(this, "config_constellation_equip", false)

			Util.AddClickEvent(this.closeBtn, () => {
				this.Close()
			}, this, true)

			Util.AddClickEvent(this.enterBtn, () => {
				this.Close()
			}, this, true)

			//itemArr = eui. new ArrayCollection()
			//this.itemGp.itemRenderer = StarEquipAddEquipItem
			//this.itemGp.dataProvider = itemArr

			this.BindEvent(local_starEquipIns, local_StarEquipModel.UPDATE_ADD_EXTRA, () => {
				this.SetLb()
			})

			this.SetBagList()
			this.SetLb()
			//ResManager.GetInstance().SetOutsideImageSprite(this, this.bg, GameResPath.GetIcon("soul", "uisy_023"))

			this.lb1.innerHTML = Util.StrToHTML("放入本职业<font color='#179846'>橙色装备,套装</font>提高成功率")
		}

		this.close_callback = () => {
			if (itemArr) {
				itemArr.DeleteMe()
				itemArr = null
			}
		}

		this.SetLb = () => {
			let extraList = local_starEquipIns.comExtraList
			let equipCfg = this.cfg_equip
			if (equipCfg && local_starEquipIns.comRatio) {
				let count = 0
				let addValue = Math.min(Math.ceil(local_starEquipIns.comPoint / local_starEquipIns.comRatio[1] * (100 - local_starEquipIns.comRatio[0])), 100 - local_starEquipIns.comRatio[0])
				for (let key in extraList) {
					count = count + 1
				}
				this.lb2.innerHTML = Util.StrToHTML("当前已选中<font color='#179846'>" + count + "件</font>装备，成功率为" + local_starEquipIns.comRatio[0] + ("%<font color='#179846'> + ") + addValue + "%</font>")
			}
		}

		this.Open = (...new_args) => {
			this.ruleId = new_args[0]
			super.Open()
		}

		this.SetBagList = () => {
			let bagList = GoodsModel.GetInstance().starEquipBagList
			let equipCfg = this.cfg_equip
			let showList = []
			for (let _tmpi in bagList) {
				let vo = bagList[_tmpi]
				if ((vo.subtype < 7 && equipCfg[vo.type_id]) && equipCfg[vo.type_id].compose_info > 0) {
					table.insert(showList, vo)
				}
			}
			if (!itemArr) {
				itemArr = new LoopScrowViewMgr()
				itemArr.SetData(this._Scroller1, StarEquipAddEquipItem, showList, LoopScrCon.Vertical, 4)
			} else {
				itemArr.replaceAll(showList)
			}
		}
	}

	bg: Laya.Image
	_Image1: Laya.Image
	_Image2: Laya.Image
	_lb_title: Laya.Label
	closeBtn: Laya.Image
	lb1: Laya.HTMLDivElement
	gp_lb2: Laya.HBox
	lb2: Laya.HTMLDivElement
	_Scroller1: Laya.List
	enterBtn: Laya.Box
	_Image11: Laya.Image
	labelDisplay: Laya.Label
	public GetComponents() {
		[
			this.bg,
			this._Image1,
			this._Image2,
			this._lb_title,
			this.closeBtn,
			this.lb1,
			this.gp_lb2,
			this.lb2,
			this._Scroller1,
			this.enterBtn,
			this._Image11,
			this.labelDisplay,
		]
			= this.GetChildrenByNames([

				"bg",
				"_Image1",
				"_Image2",
				"_lb_title",
				"closeBtn",
				"lb1",
				"gp_lb2",
				"lb2",
				"_Scroller1",
				"enterBtn",
				"_Image11",
				"labelDisplay",
			])
	}
}
window["StarEquipAddEquipView"] = StarEquipAddEquipView
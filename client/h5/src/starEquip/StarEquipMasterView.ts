import { BaseView1 } from "../common/BaseView1"
import { table } from "../common/table"
import { Util } from "../util/Util"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { FightingShowSmallItem } from "../common/FightingShowSmallItem"
import { Message } from "../sysInfo/SysInfoController"
import { LoopScrowViewMgr, LoopScrCon } from "../common/LoopScrowViewMgr"
import { StarEquipModel } from "../commonModel/StarEquipModel"
import { StarEquipMasterItem } from "./StarEquipMasterItem"

import "./StarEquipMasterTip"

export class StarEquipMasterView extends BaseView1 {
	InitItem
	fight
	itemGp
	itemList
	maxCfgCount
	cfg_equip_star

	public constructor() {
		super()
		this.base_file = "starEquip"
		this.layout_file = "StarEquipMasterView"
		this.layer_value = Enum_UILayer.Activity
		this.is_center = true
		this.use_background = true
		this.click_bg_toClose = true
		this.destroy_imm = true
		this.preload_server_config = {
			"config_equip_star": false
		}

		this.itemList = []
		this.maxCfgCount = 120
		let local_StarEquipModel = StarEquipModel
		let local_StarEquipModelIns = local_StarEquipModel.GetInstance()
		let local_resMgr = ResManager.GetInstance()
		let itemArr = null

		this.load_callback = () => {
			this.cfg_equip_star = local_resMgr.GetGameConfigFromCache(this, "config_equip_star", false)

			this.curLb.style.fontSize = 18
			this.curLb.style.color = "#663915"
			this.curLb.style.wordWrap = false
		}

		this.close_callback = () => {
			this.ClearUIEffect(this.effectGp)
			if (itemArr) {
				itemArr.DeleteMe()
				itemArr = null
			}
			if (this.fight) {
				this.fight.DeleteMe()
				this.fight = null
			}
		}

		this.open_callback = () => {
			//this.RegisterMask(this.itemGp)
			this.fight = new FightingShowSmallItem(this._fight)
			this.fight.Load()
			this.fight.Updatefighting(local_StarEquipModelIns.starPower)

			Util.AddClickEvent(this.closeBtn, () => {
				this.Close()
			}, this, true)

			Util.AddClickEvent(this.propBtn, () => {
				//let data = []
				if (!local_StarEquipModelIns.activeStar || local_StarEquipModelIns.activeStar == 0) {
					Message.show("暂无星级大师加成")
					return
				}
				let cfg = this.cfg_equip_star[local_StarEquipModelIns.activeStar]
				if (cfg) {
					let attrList = []
					let attrCfg = JSON.parse(cfg.attr)
					for (let _tmpi in attrCfg) {
						let vo = attrCfg[_tmpi]
						attrList[vo[0]] = vo[1]
					}
					local_StarEquipModelIns.Fire(local_StarEquipModel.OPEN_VIEW, "StarEquipPropView", attrList)
				}
			}
				, this, true)

			this.BindEvent(local_StarEquipModelIns, local_StarEquipModel.STAR_MASTER_INFO, () => {
				if (this.fight) {
					this.fight.Updatefighting(local_StarEquipModelIns.starPower)
				}
				this.InitItem()
			}
			)

			this.BindEvent(local_StarEquipModelIns, local_StarEquipModel.MASTR_UP, () => {
				//this.AddUIEffect("ui_jihuochenggong_glow", "Activity", this.effectGp)
			}
			)

			this.curLb.innerHTML = "当前穿戴装备累计<font color='#e25a00'>" + local_StarEquipModelIns.totalStar + "条星级卓越属性</font>"
			this._gp_lb.callLater(() => {
				if(this.use_delete_method) return
				this.curLb.event("resize")
			})
			local_resMgr.SetOutsideImageSprite(this, this.bg, GameResPath.GetIcon("starEquip", "uixzsy_039"))
			//local_resMgr.SetOutsideImageSprite(this, this._Image2, GameResPath.GetIcon("starEquip", "uixzsy_064"))
			this.InitItem()
		}

		this.InitItem = () => {
			let cfg = this.cfg_equip_star
			let listIndex = 0
			let index = 0
			let showindex1 = null
			let showindex2 = null
			let limitCount = local_StarEquipModelIns.totalStar % 6
			let sourList = []
			for (let i = 1; i <= this.maxCfgCount; i++) {
				let vo = cfg[i]
				let list = sourList[listIndex]
				if (!list) {
					list = []
					sourList[listIndex] = list
				}
				table.insert(list, vo)
				index = index + 1
				if (index > 5) {
					index = 0
					listIndex = listIndex + 1
				}
				if (vo.star > local_StarEquipModelIns.totalStar) {
					limitCount = limitCount + 1
					if (limitCount == 12) {
						break
					}
				}
				if (vo.star == local_StarEquipModelIns.activeStar) {
					showindex1 = listIndex
					showindex2 = index
				}
			}

			if (!itemArr) {
				itemArr = new LoopScrowViewMgr()
				itemArr.SetData(this.scroller, StarEquipMasterItem, sourList, LoopScrCon.Horizontal)
			} else {
				itemArr.replaceAll(sourList)
			}

			//itemArr = eui. new ArrayCollection()
			//this.itemGp.itemRenderer = StarMasterItem
			//this.itemGp.dataProvider = itemArr
			//itemArr.LastOnChild(showindex1 || 0)
			//this.itemGp.scrollH = Math.max(showindex1 * 581 + 100 * showindex2 - 350, 0)
			let value = showindex1 * 581
			this.scroller.scrollBar.value = value == 0 ? 1 : value
		}
	}

	bg: Laya.Image
	closeBtn: Laya.Image
	_img_title: Laya.Image
	_gp_lb: Laya.HBox
	curLb: Laya.HTMLDivElement
	_Image2: Laya.Image
	scroller: Laya.List
	effectGp: Laya.Box
	_Group1: Laya.HBox
	_fight: Laya.Box
	propBtn: Laya.Image
	public GetComponents() {
		[
			this.bg,
			this.closeBtn,
			this._img_title,
			this._gp_lb,
			this.curLb,
			this._Image2,
			this.scroller,
			this.effectGp,
			this._Group1,
			this._fight,
			this.propBtn,
		]
			= this.GetChildrenByNames([
				"bg",
				"closeBtn",
				"_img_title",
				"_gp_lb",
				"curLb",
				"_Image2",
				"scroller",
				"effectGp",
				"_Group1",
				"_fight",
				"propBtn",
			])
	}
}
window["StarEquipMasterView"] = StarEquipMasterView
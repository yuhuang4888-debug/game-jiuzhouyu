import { BaseItem1 } from "../common/BaseItem1"
import { Util, SetAnchoredPosition } from "../util/Util"
import { Runner } from "../util/Runner"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { SYTweenLite } from "../util/SYTweenLite"
import { ErlangParser } from "../util/ErlangParser"
import { GoodsModel } from "../commonModel/GoodsModel"
import { BagModel } from "../commonModel/BagModel"
import { LoopScrowViewMgr, LoopScrCon } from "../common/LoopScrowViewMgr"
import { RedDotManager } from "../common/RedDotManager"
import { ModuleType } from "../common/RedDotManager"
import { Message } from "../sysInfo/SysInfoController"
import { StarEquipModel } from "../commonModel/StarEquipModel"
import { chcModel } from "../commonModel/chcModel"
import { FightingShowSmallItem } from "../common/FightingShowSmallItem"
import { StarEquipTabItem } from "./StarEquipTabItem"
import { StarEquipLockItem } from "./StarEquipLockItem"
import { StarEquipItem } from "./StarEquipItem"
import { StarEquipSuitPropItem } from "./StarEquipSuitPropItem"

import "./StarEquipBasicView"
import "./StarChangeEquipView"
import "./StarEquipPropView"
import "./StarEquipMasterView"
import "./StarEquipComView"
import "../chc/chcBaseView"
import "./StarEquipActiveSuit"
import "./StarEquipComSelectView"

export class StarEquipView extends BaseItem1 {
	//EmpmasterBtn
	InitEquipItem
	InitEvent
	LoadSuccess
	LocalDeleteMe
	OntabTouch
	PlayUnlockAni
	SelectView
	SetProp
	StopRunner
	Update
	UpdateEquip
	UpdateSuitData

	//canbgGp
	//canequipGp
	//cover_effect_cache_sort_order
	//effect_cache_sort_order
	equipItemList
	fight
	lockItemGp
	runnerId
	startTime
	suitPropList
	tabArr
	tabList

	cfg_page
	cfg_pos
	cfg_starequip

	public constructor(parent?) {
		super(parent)
		this.base_file = "starEquip"
		this.layout_file = "StarEquipView"
		this.preload_server_config = {
			"config_constellation_pos": false,
			"config_constellation_page": false
		}
		this.preload_client_config = {
			"ClientStarEquip": false
		}

		this.suitPropList = []
		this.equipItemList = []

		let local_starEquipmodel = StarEquipModel
		let local_starEquipIns = local_starEquipmodel.GetInstance()
		let local_resMgr = ResManager.GetInstance()
		let local_goodsModel = GoodsModel
		let selectTab = 0
		let lockArr = null
		let bag_model = BagModel.GetInstance()

		this.load_callback = () => {
			//this.canequipGp = this.equipGp.GetComponent("CanvasGroup")
			//this.canbgGp = this.bgGp.GetComponent("CanvasGroup")
			this.cfg_pos = ResManager.GetInstance().GetGameConfigFromCache(this, "config_constellation_pos", false)
			this.cfg_page = ResManager.GetInstance().GetGameConfigFromCache(this, "config_constellation_page", false)
			this.cfg_starequip = ResManager.GetInstance().GetGameConfigFromCache(this, "ClientStarEquip", true)

			this._Scroller1.scrollBar.visible = false
			this.lockScroller.scrollBar.visible = false
			this._Scroller2.vScrollBar.visible = false

			//local_resMgr.SetOutsideImageSprite(this, this.bg1, GameResPath.GetIcon("starEquip", "uixzsy_001a"))
			local_resMgr.SetOutsideImageSprite(this, this.bg2, GameResPath.GetIcon("starEquip", "uixzsy_009"))

			this.InitEvent()
			this.LoadSuccess()
		}

		this.LoadSuccess = () => {
			this.fight = new FightingShowSmallItem(this._fight)
			this.fight.Load()
			this.InitEquipItem()

			if (!this.tabArr) {
				let list = this.cfg_starequip.tabList || {}
				this.tabArr = new LoopScrowViewMgr()
				this.tabArr.SetData(this._Scroller1, StarEquipTabItem, list, LoopScrCon.Horizontal, 1, this.OntabTouch)
			}

			let highestTab = 0
			let redPage
			for (let i = 1; i <= 6; i++) {
				let red = RedDotManager.GetInstance().CheckRedStatus(ModuleType.StarEquip, i)
				if (red) {
					redPage = i - 1
				}
			}

			let pageInfo = local_starEquipIns.pageInfo
			for (let key in pageInfo) {
				let pageVo = pageInfo[key]
				if (pageVo.is_active != 0 && pageVo.page != 1) {
					highestTab = highestTab + 1
				}
			}
			selectTab = redPage || local_starEquipIns.OldSelectTab || highestTab

			this.tabArr.SetSelectIndex(selectTab)
			this.starLb.text = local_starEquipIns.totalStar

			this.masterRed.visible = local_starEquipIns.masterRed
			this.comRed.visible = local_starEquipIns.comRed
			this.bagRed.visible = local_starEquipIns.devourRed
			this.devourRed.visible = chcModel.GetInstance().GetReddotAll()
			// this.effect_cache_sort_order = this.AddCurrLayerSortingOrder("UI")
			// this.AddUIEffect("ui_constellation_main", "UI", this.effectGp, null, null, true, { custom_sorting_order = this.effect_cache_sort_order })
			// this.cover_effect_cache_sort_order = this.AddCurrLayerSortingOrder("UI")
			// this.CoverEffect(this.bgGp, "UI", this.cover_effect_cache_sort_order)

			this.SelectView()
			//bag_model.bagViewOpen[local_goodsModel.GOODS_POS_TYPE.starEquipBag] = true
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this.propBtn, () => {
				let pageInfo = local_starEquipIns.GetPageEquipInfo(selectTab + 1)
				if (pageInfo) {
					if (Util.IsTableEmpty(pageInfo.attr)) {
						Message.show("暂无属性加成")
						return
					}
					local_starEquipIns.Fire(local_starEquipmodel.OPEN_VIEW, "StarEquipPropView", pageInfo.attr, 1)
				}
			}, this, true)

			Util.AddClickEvent(this.comBtn, () => {
				local_starEquipIns.Fire(local_starEquipmodel.OPEN_VIEW, "StarEquipComView")
			}, this, true)

			Util.AddClickEvent(this.bagBtn, () => {
				local_starEquipIns.Fire(local_starEquipmodel.OPEN_VIEW, "StarEquipBasicView")
			}, this, true)

			Util.AddClickEvent(this.masterBtn, () => {
				local_starEquipIns.Fire(local_starEquipmodel.OPEN_VIEW, "StarEquipMasterView")
			}, this, true)

			Util.AddClickEvent(this.loclImg, () => {
				local_starEquipIns.Fire(local_starEquipmodel.SEND_PROTO, 23253, "i", (selectTab + 1))
			}, this, true)

			Util.AddClickEvent(this.devourBtn, () => {
				let stype = chcModel.GetInstance().CheckEquipReStype(this.cfg_pos, 1)
				if (stype != 0) {
					StarEquipModel.GetInstance().Fire(StarEquipModel.OPEN_VIEW, "chcBaseView")
				} else {
					Message.show("穿戴圣衣后，才能操作")
				}
			}, this, true)

			this.BindEvent(local_goodsModel.GetInstance(), local_goodsModel.CHANGE_STAREQUIP, () => {
				if (this.use_delete_method) {
					return
				}
				this.UpdateEquip()
			})

			this.BindEvent(local_starEquipIns, local_starEquipmodel.STAR_MASTER_INFO, () => {
				this.starLb.text = local_starEquipIns.totalStar
				this.masterRed.visible = local_starEquipIns.masterRed
			})

			this.BindEvent(local_starEquipIns, local_starEquipmodel.UPDATE_STAR_INFO, () => {
				this.starLb.text = local_starEquipIns.totalStar
				this.UpdateSuitData()
			})

			this.BindEvent(local_starEquipIns, local_starEquipmodel.REFRESH_RED, (type?) => {
				if (type == 2) {
					this.bagRed.visible = local_starEquipIns.devourRed
				} else if (type == 5) {
					this.comRed.visible = local_starEquipIns.comRed
				} else if (type == 3) {
					this.lockRed.visible = local_starEquipIns.canUnlockPage == selectTab
				}
			})

			this.BindEvent(chcModel.GetInstance(), chcModel.UPDATE_RED, () => {
				this.devourRed.visible = chcModel.GetInstance().GetReddotAll()
			})

			this.BindEvent(local_starEquipIns, local_starEquipmodel.ACTIVE_PAGE, () => {
				this.PlayUnlockAni()
			})
			//this:AddUIEffect("ui_constellation_circleglow2", this.effectGp, {x=0, y=315}, {x=1.3, y=1.2}, true, null, null, null, null, true)
			//this:AddUIEffect("ui_constellation_circleglow3", this.effectGp1, null, 1, true, null, null, null, null, true)
		}

		this.InitEquipItem = () => {
			for (let i = 0; i < 10; i++) {
				let item = this.equipItemList[i]
				if (!item) {
					item = new StarEquipItem(this.equipGp)
					//item.SetBaseCove(this.cover_effect_cache_sort_order)
					item.Load()
					item.ExcuteCallback(() => {
						SetAnchoredPosition(item.display_obj, local_starEquipmodel.posList[i][0], local_starEquipmodel.posList[i][1])
						if (i == 9) {
							item.SetScale(1)
						} else {
							item.SetScale(0.8)
						}
					})
					this.equipItemList[i] = item
				}
			}
			//this.CoverEffect(this.equipGp, "UI", this.cover_effect_cache_sort_order)
		}

		this.UpdateEquip = () => {
			let equipInfo = local_starEquipIns.GetPageEquip(selectTab + 1)
			for (let i = 0; i < 10; i++) {
				let item = this.equipItemList[i]
				item.SetData(equipInfo[i + 1] || { page: selectTab + 1, subtype: i + 1 })
			}
		}

		this.SelectView = () => {
			this.UpdateSuitData()
			let equipInfo = local_starEquipIns.GetPageEquipInfo(selectTab + 1)
			if (equipInfo) {
				let lock = !equipInfo.is_active || equipInfo.is_active == 0
				if (lock) {
					let lockCfg = this.cfg_page[selectTab + 1]
					if (lockCfg) {
						let condList = JSON.parse(lockCfg.condition)
						if (!lockArr) {
							lockArr = new LoopScrowViewMgr()
							lockArr.SetData(this.lockScroller, StarEquipLockItem, condList, LoopScrCon.Vertical)
						} else {
							lockArr.replaceAll(condList)
						}
						this.lock2.visible = condList.length != 0
						this.lock1.visible = condList.length != 0
					}
					this.lockRed.visible = local_starEquipIns.canUnlockPage == equipInfo.page
				} else {
					this.lockRed.visible = false
					this.UpdateEquip()
				}
				this.lockScroller.visible = lock
				this.lockGp.visible = lock
				this.black1.visible = lock
				this.black0.visible = lock
				this.equipGp.visible = !lock
				this.bgGp.visible = !lock
				this.effectGp.visible = !lock
				this.effectGp1.visible = !lock
			}
		}

		this.OntabTouch = (index?) => {
			/*
			if (selectTab == index) {
				return
			}
			*/
			if (index != 0 && !local_starEquipIns.StarEquipIsActive(index)) {
				this.tabArr.SetSelectIndex(selectTab)
				Message.show("需先解锁前置装备页")
				return
			}
			selectTab = index
			this.SelectView(selectTab)
		}

		this.SetProp = (nomalList?, speSuitList?, normal_num?, special_num?, suitname1?, suitname2?) => {
			let totalLength = nomalList.length + speSuitList.length + 2
			for (let i = 0; i < totalLength; i++) {
				let item = this.suitPropList[i]
				if (!item) {
					item = new StarEquipSuitPropItem(this.suitGp)
					item.Load()
					this.suitPropList[i] = item
				}
				if (i == 0) {
					item.SetData(0, null, suitname1)
				} else if (i <= nomalList.length) {
					item.SetData(nomalList[i - 1], normal_num)
				} else if (i == nomalList.length + 1) {
					item.SetData(1, null, suitname2)
				} else {
					item.SetData(speSuitList[i - nomalList.length - 2], special_num)
				}
			}
		}

		this.UpdateSuitData = () => {
			let starData = local_starEquipIns.pageInfo[selectTab + 1]
			if (starData) {
				this.fight.Updatefighting(starData.power)
				let curData = this.cfg_page[selectTab + 1]
				if (curData) {
					let normalSuitList = JSON.parse(curData.normal_suit_attr)
					let speSuitList = JSON.parse(curData.special_suit_attr)
					this.SetProp(normalSuitList, speSuitList, starData.normal_num, starData.special_num, curData.normal_name, curData.special_name)
				}
			}
		}

		this.PlayUnlockAni = () => {
			this.lockScroller.visible = false
			this.lock2.visible = false
			this.lock1.visible = false
			this.lockRed.visible = false
			this.UpdateEquip()

			SYTweenLite.to(this, this.loclImg, SYTweenLite.UiAnimationType.ROTATION_Y, 90, 0.35)
			SYTweenLite.to(this, this.midImg, SYTweenLite.UiAnimationType.ROTATION_Y, 90, 0.35, () => {
				if (!this.use_delete_method) {
					SYTweenLite.to(this, this.midImg, SYTweenLite.UiAnimationType.ROTATION_Y, 0, 0.35)
				}
			})
			//this.AddUIEffect("ui_constellation_unlock_2", "UI", this.midGp, null, null, null)
			setTimeout(() => {
				//this.canequipGp.alpha = 0
				//this.canbgGp.alpha = 0
				if(this.use_delete_method) return
				this.equipGp.visible = true
				this.bgGp.visible = true
				this.StopRunner()
				this.startTime = TimeUtil.getServerTimeMs()
				this.runnerId = Runner.GetInstance().AddRunObj(this)
			}, 1400)

			//Laya.Tween.get(this.loclImg).to({scaleX=0}, 350, Laya.Ease.quartIn)
			//Laya.Tween.get(this.midImg):to({scaleX=0}, 350, Laya.Ease.quartIn):to({scaleX=1}, 350, Laya.Ease.quadOut).call(() => {
			//this:AddUIEffect("ui_constellation_deblockingglow", this.midGp, null, null, null, null,() => {
			//let tslet_end = false
			//let OnchangeFunc1 = () => {
			//if (! tslet_end ) {
			//let alpha = this.black0.alpha
			//this.black1.alpha = alpha
			//this.equipGp.alpha = 1 - alpha
			//this.effectGp.alpha = this.equipGp.alpha
			//this.effectGp1.alpha = this.effectGp.alpha
			//this.bgGp.alpha = this.effectGp1.alpha
			//}
			//}

			//this:AddUIEffect("ui_constellation_sweeplight", this.backGp)
			//this.equipGp.alpha = 0
			//this.effectGp.alpha = this.equipGp.alpha
			//this.effectGp1.alpha = this.effectGp.alpha
			//this.bgGp.alpha = this.effectGp1.alpha
			//this.equipGp.visible = true 
			//this.effectGp.visible =  this.equipGp.visible
			//this.effectGp1.visible =  this.effectGp.visible
			//this.bgGp.visible =  this.effectGp1.visible
			//Laya.Tween.get(this.black0, {onChange=OnchangeFunc1}):to({alpha=0}, 700).call(() => {
			//tslet_end = true
			//this.black1.alpha = 1
			//this.black0.alpha = this.black1.alpha
			//this.loclImg.scaleX = 1
			//this:SelectView()
			//}
			//)
			//}
			//)
			//}
			//)
		}

		this.Update = () => {
			if (this.use_delete_method) {
				return
			}
			let showalpha = (TimeUtil.getServerTimeMs() - this.startTime) / 700
			if (showalpha > 1) {
				showalpha = 1
			}
			this.black0.alpha = 1 - showalpha
			this.black1.alpha = 1 - showalpha
			//this.canequipGp.alpha = showalpha
			//this.canbgGp.alpha = showalpha
			if (showalpha >= 1) {
				this.StopRunner()
				this.black0.alpha = 1
				this.black1.alpha = 1
				//SetLocalRotation(this.loclImg, 0, 0, 0, 0)
				this.SelectView()
			}
		}

		this.StopRunner = () => {
			if (this.runnerId) {
				Runner.GetInstance().RemoveRunObj(this.runnerId)
				this.runnerId = null
			}
		}

		this.LocalDeleteMe = () => {
			if (this.equipItemList) {
				for (let key in this.equipItemList) {
					let item = this.equipItemList[key]
					item.DeleteMe()
				}
				this.equipItemList = []
			}
			if (this.suitPropList) {
				for (let _tmpi in this.suitPropList) {
					let vo = this.suitPropList[_tmpi]
					vo.DeleteMe()
				}
				this.suitPropList = []
			}
			//this:ClearUIEffect(this.effectGp1)
			//this:ClearUIEffect(this.effectGp)
			//this:ClearUIEffect(this.midGp)
			//this:ClearUIEffect(this.backGp)
			//if (this.black0 ) {
			//Laya.Tween.removeTweens(this.black0)
			//}
			//if (this.midGp ) {
			//Laya.Tween.removeTweens(this.midGp)
			//}
			if (this.tabArr) {
				this.tabArr.DeleteMe()
				this.tabArr = null
			}
			if (lockArr) {
				lockArr.DeleteMe()
				lockArr = null
			}
			if (this.fight) {
				this.fight.DeleteMe()
				this.fight = null
			}
			bag_model.bagViewOpen[local_goodsModel.GOODS_POS_TYPE.starEquipBag] = false
		}
	}

	public DeleteMe() {
		this.LocalDeleteMe()
		super.DeleteMe()
	}

	public ReOpen_callback() {
		//this.AddUIEffect("ui_constellation_main", "UI", this.effectGp, null, null, true, { custom_sorting_order = this.effect_cache_sort_order })
	}

	black0: Laya.Image
	black1: Laya.Image
	backGp: Laya.Box
	effectGp: Laya.Box
	bg2: Laya.Image
	bgGp: Laya.Box
	_Image1: Laya.Image
	_Image2: Laya.Image
	_Image3: Laya.Image
	_Image4: Laya.Image
	_Image5: Laya.Image
	_Image6: Laya.Image
	_Image7: Laya.Image
	_Image8: Laya.Image
	_Image9: Laya.Image
	midImg: Laya.Image
	_Scroller1: Laya.List
	equipGp: Laya.Box
	lockGp: Laya.Box
	loclImg: Laya.Image
	lock2: Laya.Image
	lock1: Laya.Image
	lockScroller: Laya.List
	_Scroller2: Laya.Panel
	suitGp: Laya.VBox
	masterBtn: Laya.Box
	_Image10: Laya.Image
	_Image11: Laya.Image
	_Image12: Laya.Image
	starLb: Laya.Label
	masterRed: Laya.Image
	comBtn: Laya.Image
	bagBtn: Laya.Image
	devourBtn: Laya.Image
	_Image13: Laya.Image
	_Label1: Laya.Label
	_Group1: Laya.Box
	_fight: Laya.HBox
	propBtn: Laya.Image
	effectGp1: Laya.Box
	midGp: Laya.Box
	comRed: Laya.Image
	bagRed: Laya.Image
	lockRed: Laya.Image
	devourRed: Laya.Image
	public GetComponents() {
		[
			this.black0,
			this.black1,
			this.backGp,
			this.effectGp,
			this.bg2,
			this.bgGp,
			this._Image1,
			this._Image2,
			this._Image3,
			this._Image4,
			this._Image5,
			this._Image6,
			this._Image7,
			this._Image8,
			this._Image9,
			this.midImg,
			this._Scroller1,
			this.equipGp,
			this.lockGp,
			this.loclImg,
			this.lock2,
			this.lock1,
			this.lockScroller,
			this._Scroller2,
			this.suitGp,
			this.masterBtn,
			this._Image10,
			this._Image11,
			this._Image12,
			this.starLb,
			this.masterRed,
			this.comBtn,
			this.bagBtn,
			this.devourBtn,
			this._Image13,
			this._Label1,
			this._Group1,
			this._fight,
			this.propBtn,
			this.effectGp1,
			this.midGp,
			this.comRed,
			this.bagRed,
			this.lockRed,
			this.devourRed,
		]
			= this.GetChildrenByNames([

				"black0",
				"black1",
				"backGp",
				"effectGp",
				"bg2",
				"bgGp",
				"_Image1",
				"_Image2",
				"_Image3",
				"_Image4",
				"_Image5",
				"_Image6",
				"_Image7",
				"_Image8",
				"_Image9",
				"midImg",
				"_Scroller1",
				"equipGp",
				"lockGp",
				"loclImg",
				"lock2",
				"lock1",
				"lockScroller",
				"_Scroller2",
				"suitGp",
				"masterBtn",
				"_Image10",
				"_Image11",
				"_Image12",
				"starLb",
				"masterRed",
				"comBtn",
				"bagBtn",
				"devourBtn",
				"_Image13",
				"_Label1",
				"_Group1",
				"_fight",
				"propBtn",
				"effectGp1",
				"midGp",
				"comRed",
				"bagRed",
				"lockRed",
				"devourRed",
			])
	}
}
window["StarEquipView"] = StarEquipView
import { RedKey } from "./../common/RedDotDefine"
import { RedDotController } from "./../common/RedDotController"
import { BaseItem1 } from "../common/BaseItem1"
import { table } from "../common/table"
import { Util } from "../util/Util"
import { Config } from "../common/Config"
import { ResManager } from "../common/ResManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventName } from "../common/EventName"
import { MainFunc } from "../commonModel/MainUIModel"
import { Message } from "../sysInfo/SysInfoController"
import { GoodsModel } from "../commonModel/GoodsModel"
import { CompositeModel } from "../commonModel/CompositeModel"
import { GodCourtModel } from "../commonModel/GodCourtModel"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { MaterialsTool } from "../common/MaterialsTool"
import { BaseAwardItem } from "../common/BaseAwardItem"
import { LoopScrowViewMgr, LoopScrCon } from "../common/LoopScrowViewMgr"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { GodCourtTooltip } from "../common/GodCourtTooltip"
import { SYTweenLite } from "../util/SYTweenLite"

import { GodCourtEquipItem } from "./GodCourtEquipItem"
import { GodCourtTabItem } from "./GodCourtTabItem"
import { GodCourtSuitItem } from "./GodCourtSuitItem"
import { GodCourtStrenItem } from "./GodCourtStrenItem"

import "./GodCourtPropView"
import "./GodCourtSuitView"
import "./GodCourtStageView"
import "./GodCourtBagView"
import "./GodHouseView"
import { WordManager } from "../common/WordManager"

export class GodCourtView extends BaseItem1 {
	DeleteMe1
	InitEvent
	InitGodCourtList
	InitItem
	InitView

	ReSetUnlock
	ScrTabScroller
	Scr_Scroller1
	ScrsuitScroller
	SelectTab
	SetLockState
	SetStrenData
	SetSuitData
	TabList

	UnlockAni
	UpdateEquip
	UpdateMat
	UpdateScollerImg
	public constructor(parent?) {
		super(parent)
		this.base_file = "godCourt"
		this.layout_file = "GodCourtView"

		let model = GodCourtModel.GetInstance()
		let local_goodsIns = GoodsModel.GetInstance()
		let local_comIns = CompositeModel.GetInstance()
		let tabArr = null
		let curSelectId = 1001
		let itemList = null
		let matItem = null
		let strenMatInfo = null
		let curTabIndx = 0
		let strenArr = null
		let suitArr = null
		let needReSetlock = false
		let cacheLockPos = [[0, 0], [281, 1], [0, - 162], [280, -162]]
		let showMaxStage = 1

		this.load_callback = () => {
			this.TabScroller.vScrollBarSkin = ""
			this.suitScroller.hScrollBarSkin = ""
			this._Scroller1.vScrollBarSkin = ""
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg0, "resource/game/godCourt/other/u_Divinei_01.png")
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_lockbg, "resource/game/godCourt/other/u_Divinei_02.png")
			this.InitView()
		}

		this.InitView = () => {
			// this.effectSort = this.AddCurrLayerSortingOrder("UI")
			// this.AddUIEffect("UI_1608", "UI", this.effectGp1, null, null, true, {
			// 	custom_sorting_order = this.effectSort
			// })

			// this.AddUIEffect("UI_1611", "UI", this.effectGp0, null, null, true, {
			// 	custom_sorting_order = this.effectSort
			// })
			// this.CoverEffect(this.ItemGp, "UI")
			this.InitGodCourtList()
			this.SetLockState()
			this.InitItem()
			this.InitEvent()
			this.SetSuitData()
			this.SetStrenData()

			//let i = 1
			//do {
			//let lock = this["translock" + i]
			//if (lock ) {
			//}
			//i=i+1
			//} while ((i < 5))
		}

		this.InitGodCourtList = () => {
			let cfg = Config.PRELOAD_SERVER_CONFIG.config_god_court
			let tabList = []
			if (cfg) {
				for (let key in cfg) {
					table.insert(tabList, cfg[key])
				}
			}
			table.sort(tabList, (a?, b?) => {
				return a.id < b.id
			})
			if (!tabArr) {
				tabArr = new LoopScrowViewMgr()
				tabArr.SetData(this.TabScroller, GodCourtTabItem, tabList, LoopScrCon.Vertical, 1, (index?) => {
					let data = tabList[index]
					if (data) {
						this.SelectTab(data.id, index)
					}
				})
			}
		}

		this.ReSetUnlock = () => {
			if (needReSetlock) {
				//SetLocalRotation(this.roundGp, 0, 0, 0, 0)
				for (let i = 1; i <= 4; i++) {
					//SetAnchoredPosition(this["translock" + i], cacheLockPos[i][1], cacheLockPos[i][2])
				}
				needReSetlock = false
			}
		}

		this.SetLockState = () => {
			let active = model.IsGodCourtActive(curSelectId)
			if (!active) {
				this.ReSetUnlock()
			}
			this.lockGp.visible = !active
			this.ItemGp.visible = active
			// this.effectGp2.visible = active
			// this.effectGp1.visible = active
		}

		this.InitItem = () => {
			if (!itemList) {
				itemList = []
			}
			for (let i = 0; i < 9; i++) {
				let item = itemList[i]
				if (!item) {
					let item_partent = this["_gp" + i]
					item = new GodCourtEquipItem(item_partent)
					item.Load()
					item.InitItem(model.GetEquipData(curSelectId, i + 1) || { skill_lv: curSelectId, subtype: i + 1 }, (data?) => {
						if (data) {
							let goodsVo = local_goodsIns.GetGoodsVoByGoodsId(data.equip_id)
							if (goodsVo) {
								let better = model.betterEquipList[data.godCourtId] && model.betterEquipList[data.godCourtId][data.pos]
								if (better) {
									model.AutoEquip(data)
								} else {
									UIToolTipMgr.GetInstance().AppendGodCourtTips(goodsVo.type_id, goodsVo, goodsVo.skill_id, [GodCourtTooltip.Btn.replace])
								}
							} else if (!model.AutoEquip(data)) {
								model.Fire(GodCourtModel.OPEN_VIEW, "GodCourtBagView", data.isMainView)
							}
						}
					}
					)
					itemList[i] = item
				}
			}
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this.propBtn, () => {
				let data = model.GetData(curSelectId)
				if (data && data.is_active != 0) {
					model.Fire(GodCourtModel.OPEN_VIEW, "GodCourtPropView", data.attr)
				} else {
					Message.show("请先激活神社")
				}
			}, this, true)

			Util.AddClickEvent(this._img_lock, () => {
				if (curSelectId) {
					model.Fire(GodCourtModel.SEND_SCMD, 23302, "i", curSelectId)
				}
			}, this, true)

			Util.AddClickEvent(this.upStageBtn, () => {
				if (model.IsGodCourtActive(curSelectId, true)) {
					let data = model.godcourtData[curSelectId].equip_list
					for (let _tmpi in data) {
						let vo = data[_tmpi]
						if (vo.equip_id && vo.equip_id != 0) {
							model.Fire(GodCourtModel.OPEN_VIEW, "GodCourtStageView", curSelectId)
							return
						}
					}
					Message.show("请先穿戴装备")
				}
			}, this, true)

			Util.AddClickEvent(this.bagBtn, () => {
				if (model.IsGodCourtActive(curSelectId, true)) {
					model.Fire(GodCourtModel.OPEN_VIEW, "GodCourtBagView", curSelectId)
				}
			}, this, true)

			Util.AddClickEvent(this.comBtn, () => {
				local_comIns.Fire(CompositeModel.OPEN_COMPOSITE_VIEW, CompositeModel.Index.GodCourt, 177)
				// if (local_comIns.godCourtComRed) {
				// 	model.comRed = false
				// }
				// model.Fire(GodCourtModel.REFRESH_RED, 7)
				// GlobalEventSystem.Fire(EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Treasure)
			}, this, true)

			Util.AddClickEvent(this.godHouseBtn, () => {
				model.Fire(GodCourtModel.OPEN_VIEW, "GodHouseView")
				if (model.FirstRedDot) {
					model.FirstRedDot = false
					model.Fire(GodCourtModel.REFRESH_RED, 8)
					RedDotController.ins.up(RedKey.GOD_COURT_FIRST,
						(model.FirstRedDot && CustomActivityModel.GetInstance().GetDayFirstLoginStatus()) ? 1 : 0)
					GlobalEventSystem.Fire(EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Treasure)
				}
			}, this, true)

			Util.AddClickEvent(this.suitPreBtn, () => {
				model.Fire(GodCourtModel.OPEN_VIEW, "GodCourtSuitView", curSelectId)
			}, this, true)

			Util.AddClickEvent(this.strenBtn, () => {
				if (model.IsGodCourtActive(curSelectId, true)) {
					if (strenMatInfo && strenMatInfo.length > 0) {
						let curNum = local_goodsIns.GetSpecialScore(Number(strenMatInfo[0][1]))
						let needNum = Number(strenMatInfo[0][2])
						let [type_id, bind] = local_goodsIns.GetMappingTypeId(strenMatInfo[0][0], strenMatInfo[0][1])
						if (curNum < needNum) {
							MaterialsTool.GetInstance().materialsTips(type_id)
							return
						}
					}
					model.Fire(GodCourtModel.SEND_SCMD, 23305, "i", curSelectId)
				}
			}, this, true)

			this.BindEvent(local_goodsIns, GoodsModel.UPDATE_SPECIAL_SCORE, () => {
				if ((!this.use_delete_method && matItem) && strenMatInfo) {
					this.UpdateMat()
				}
			})

			this.BindEvent(model, GodCourtModel.UPDATE_STREN_DATA, (smcd?) => {
				if (smcd && smcd.court_id == curSelectId) {
					this.SetStrenData()
					//this.AddUIEffect("UI_1102_qianghuachenggong", "UI", this.strenEffectGp)
				}
			})

			this.BindEvent(model, GodCourtModel.UNLOCK, (scmd?) => {
				if (scmd.court_id == curSelectId) {
					needReSetlock = true
					this.UnlockAni(scmd.court_id)
				}
			})

			this.BindEvent(model, GodCourtModel.UPDATE_GODCOURT, (scmd?) => {
				if ((scmd && scmd.court_id == curSelectId) || !scmd) {
					this.SetStrenData()
					this.SetSuitData()
					let showEquipEffect = true
					let i = 0
					do {
						let data = model.GetEquipData(curSelectId, i + 1)
						if (data.equip_id == 0 && data.pos < 9) {
							showEquipEffect = false
							break
						}
						i = i + 1
					} while ((i < GodCourtModel.PosList.length))
					// this.effectGp0.visible = showEquipEffect
				}
			}
			)

			this.BindEvent(model, GodCourtModel.REFRESH_RED, (type?) => {
				if (type == 1) {
					this.unlockRed.visible = model.unlockRedList[curSelectId] != null
				} else if (type == 2) {
					this.upStageRed.visible = model.upStageRedList[curSelectId] != null
				} else if (type == 4) {
					this.strenRed.visible = model.strenRedList[curSelectId] != null
				} else if (type == 6 || type == 5) {
					let showRed = (model.devourRed || (model.betterEquipList[curSelectId] != null))
					this.bagRed.visible = showRed
				} else if (type == 7) {
					this.comRed.visible = model.comRed && local_comIns.godCourtComRed
				} else if (type == 8) {
					this.houseRed.visible = model.lotteryRed || model.rewardRed
				}
			}
			)


			//this.ScrsuitScroller.onValueChanged.AddListener(() => {
			//this:UpdateScollerImg()
			//})

			this.SelectTab(1001)

			this.comRed.visible = model.comRed && local_comIns.godCourtComRed
			this.houseRed.visible = (model.lotteryRed || model.rewardRed || (model.FirstRedDot && CustomActivityModel.GetInstance().GetDayFirstLoginStatus()))
			//this:AddUIEffect("ui_Shenting_runeUI2","UI", this.effectGp0, null, null, true)
			//this:AddUIEffect("ui_Shenting_runeUI2_wenli","UI", this.effectGp2, null, null, true)
		}

		this.SetSuitData = () => {
			let suitCfg = Config.PRELOAD_SERVER_CONFIG.config_god_court_equip_stage
			if (suitCfg) {
				let godCourtData = model.GetData(curSelectId)
				let suitList = []
				let tempList = []
				let maxStage = 1
				if (godCourtData) {
					for (let _tmpi in godCourtData.suit_list) {
						let vo = godCourtData.suit_list[_tmpi]
						if (Number(vo.stage) > maxStage) {
							maxStage = vo.stage
						}
						// tempList[vo.stage] = vo.num
						tempList.push({stage:vo.stage,num:vo.num})
					}
				}
				showMaxStage = maxStage
				for (let key in suitCfg) {
					if (Number(key) != 0 && Number(key) <= maxStage) {
						table.insert(suitList, { cfg: JSON.parse(suitCfg[key].suit_attr),  data:model.IsHasHeight(suitCfg[key],tempList) ,stage:suitCfg[key].stage})
					}
				}

				table.sort(suitList, (a?, b?) => {
					return a.stage < b.stage
				})

				if (!suitArr) {
					suitArr = new LoopScrowViewMgr()
					suitArr.SetData(this.suitScroller, GodCourtSuitItem, suitList, LoopScrCon.Horizontal, 1)
					suitArr.SetOnValueChanged(() => {
						this.UpdateScollerImg()
					})
				} else {
					suitArr.replaceAll(suitList)
				}
				this.suitScroller.scrollBar.value = (showMaxStage - 1) * 500
			}
		}


		this.UnlockAni = (id?) => {
			if (!this.use_delete_method) {
				this.SetLockState()
				this.SelectTab(id)
			}
			// let PosList = [[- 110, 85], [392, 86], [- 110, -247], [390, -247]]
			// SYTweenLite.to(this, this.roundGp, SYTweenLite.UiAnimationType.ROTATION, 45, 0.55, () => {
			// 	setTimeout(() => {
			// 		if (!this.use_delete_method) {
			// 			for (let i = 1; i <= 4; i++) {
			// 				SYTweenLite.to(this, this["lock" + i], SYTweenLite.UiAnimationType.ANCHORED_POS, new Vector2(PosList[i][1], PosList[i][2]), 0.5)
			// 			}
			// 		}
			// 	}, 0.05)
			// 	setTimeout(() => {
			// 		//this.AddUIEffect("UI_1612", "UI", this.lockEffectGp, null, 0.75, false)
			// 		//this.AddUIEffect("UI_1613", "UI", this.lockMask, null, 0.75, null)
			// 		setTimeout(() => {
			// 			if (!this.use_delete_method) {
			// 				this.SetLockState()
			// 				this.SelectTab(id)
			// 			}
			// 		}, 1.2)
			// 	}, 0.6)
			// })
		}

		this.UpdateMat = () => {
			if (!matItem) {
				matItem = new BaseAwardItem(this.matGp)
				matItem.Load()
				matItem.SetItemSize(70, 70)
			}

			if (strenMatInfo && strenMatInfo.length > 0) {
				let curNum = local_goodsIns.GetSpecialScore(Number(strenMatInfo[0][1]))
				let needNum = Number(strenMatInfo[0][2])
				let color = curNum >= needNum && "#00fa64" || "#ff4f50"
				let [type_id, bind] = local_goodsIns.GetMappingTypeId(strenMatInfo[0][0], strenMatInfo[0][1])
				matItem.SetVisible(true)
				matItem.SetData(type_id)
				this.matLb.color = color
				this.matLb.text = curNum + "/" + needNum
				this.labelDisplay.text = "强化"
				//SetImageGray(this.strenBtn, false)
			} else {
				matItem.SetVisible(false)
				this.labelDisplay.text = "已满级"
				//SetImageGray(this.strenBtn, true)
				this.matLb.text = ""
			}
		}

		this.SetStrenData = () => {
			let StrenCfg = Config.PRELOAD_SERVER_CONFIG.config_god_court_strength
			if (StrenCfg) {
				let godCourtData = model.GetData(curSelectId)
				let lv = 0
				if (godCourtData) {
					lv = godCourtData.court_lv
				}
				let curCfg = StrenCfg[lv]
				let curAttr = null
				let length = 0
				if (curCfg) {
					curAttr = JSON.parse(curCfg.attr)
					length = Util.TableSize(curAttr)
					let cost = JSON.parse(curCfg.cost)
					if (cost) {
						strenMatInfo = cost
						this.UpdateMat()
					}
				} else {
					curAttr = []
				}
				let nextCfg = StrenCfg[lv + 1]
				let nextAttr = null
				if (nextCfg) {
					nextAttr = JSON.parse(nextCfg.attr)
					length = Util.TableSize(nextAttr)
				} else {
					nextAttr = []
				}
				let attrList = []
				for (let i = 0; i < length; i++) {
					table.insert(attrList, [curAttr[i], nextAttr[i]])
				}

				if (!strenArr) {
					strenArr = new LoopScrowViewMgr()
					strenArr.SetData(this._Scroller1, GodCourtStrenItem, attrList, LoopScrCon.Vertical, 1)
				} else {
					strenArr.replaceAll(attrList)
				}
			}
		}

		this.UpdateEquip = () => {
			let showEquipEffect = true
			if (itemList) {
				let i = 0
				do {
					let item = itemList[i]
					if (item) {
						let data = model.GetEquipData(curSelectId, i + 1)
						if (data) {
							data.godCourtId = curSelectId
							data.isMainView = curSelectId
							if (data.equip_id == 0 && data.pos < 9) {
								showEquipEffect = false
							}
						}
						item.InitItem(data || { isMainView: curSelectId, godCourtId: curSelectId, subtype: i + 1 })
					}
					i = i + 1
				} while ((i < GodCourtModel.PosList.length))
			}
			// this.effectGp0.visible = showEquipEffect
		}

		this.SelectTab = (godCourtId?, index?) => {
			//if (CanSelectTab(godCourtId) ) {
			curSelectId = godCourtId
			this.SetLockState()
			this.UpdateEquip()
			this.SetSuitData()
			this.SetStrenData()
			//}else{
			//tabArr:SetSelectIndex(curTabIndx,false)
			//return
			//}-1550
			//SetAnchoredPositionX(this.Content1, -(showMaxStage - 1) * 517)
			//this.suitGp.validateNow()
			//this.suitGp.scrollH = showMaxStage - 1 * 520

			this.UpdateScollerImg()
			this.unlockRed.visible = model.unlockRedList[curSelectId] != null
			this.strenRed.visible = model.strenRedList[curSelectId] != null
			this.upStageRed.visible = model.upStageRedList[curSelectId] != null
			let showRed = (model.devourRed || (model.betterEquipList[curSelectId] != null))
			this.bagRed.visible = model.IsGodCourtActive(curSelectId) && showRed
			if (index != null) {
				curTabIndx = index
			}
		}

		let curIndex = 0
		this.UpdateScollerImg = () => {
			let value = this.suitScroller.scrollBar.value
			let pos = Math.floor(value / 500 + 0.5)
			if ((pos >= 0 && curIndex != pos + 1) && pos < 9) {
				curIndex = pos + 1
				this._lb_title1.text = WordManager.NumConvertStage(curIndex) + "阶套装"
			}
			// if (this.Content1) {
			// 	let pos = Math.floor((-GetLocalPositionX(this.Content1)) / 516 + 0.5)
			// 	if ((pos >= 0 && curIndex != pos + 1) && pos < 9) {
			// 		curIndex = pos + 1
			// 		ResManager.GetInstance().SetImageSprite(this, this.suitName, "godCourt", "uitzyl_sp" + curIndex, true)
			// 	}
			// }
		}

		this.DeleteMe1 = () => {
			if (itemList) {
				for (let _tmpi in itemList) {
					let item = itemList[_tmpi]
					item.DeleteMe()
				}
				itemList = null
			}
			if (matItem) {
				matItem.DeleteMe()
				matItem = null
			}
			//this:ClearUIEffect(this.effectGp0)
			//this:ClearUIEffect(this.effectGp1)
			//this:ClearUIEffect(this.effectGp2)
			//this:ClearUIEffect(this.strenEffectGp)
			//this:ClearUIEffect(this.lockEffectGp)
			//let i = 0
			//do {

			//if (this["lock" + (i + 1]) ) {

			//Laya.Tween.removeTweens(this["lock" + (i + 1]))
			//}
			//i=i+1
			//} while ((i < 4))
			//if (this.suitScroller ) {
			//this.suitScroller.removeEventListener(Laya.UIEvent.CHANGE, this.UpdateScollerImg, this)
			//Laya.Tween.removeTweens(this.roundGp)
			//}

			if (strenArr) {
				strenArr.DeleteMe()
				strenArr = null
			}
			if (tabArr) {
				tabArr.DeleteMe()
				tabArr = null
			}
			if (suitArr) {
				suitArr.DeleteMe()
				suitArr = null
			}
		}
	}

	public DeleteMe() {
		this.DeleteMe1()
		super.DeleteMe()
	}

	public ReOpen_callback() {
		// this.AddUIEffect("UI_1608", "UI", this.effectGp1, null, null, true, {
		// 	custom_sorting_order = this.effectSort
		// })
		// this.AddUIEffect("UI_1611", "UI", this.effectGp0, null, null, true, {
		// 	custom_sorting_order = this.effectSort
		// })
		//this:CoverEffect(this.ItemGp,"UI")
	}

	_img_bg1: Laya.Image
	_img_bg0: Laya.Image
	_img_bg2: Laya.Image
	_img_bg3: Laya.Image
	TabScroller: Laya.List
	ItemGp: Laya.Box
	_gp0: Laya.Box
	_gp1: Laya.Box
	_gp2: Laya.Box
	_gp3: Laya.Box
	_gp4: Laya.Box
	_gp5: Laya.Box
	_gp6: Laya.Box
	_gp7: Laya.Box
	_gp8: Laya.Box
	lockGp: Laya.Box
	_img_lockbg: Laya.Image
	_img_lock: Laya.Image
	unlockRed: Laya.Image
	propBtn: Laya.Image
	upStageBtn: Laya.Image
	upStageRed: Laya.Image
	bagBtn: Laya.Image
	bagRed: Laya.Image
	comBtn: Laya.Image
	comRed: Laya.Image
	godHouseBtn: Laya.Image
	houseRed: Laya.Image
	suitPreBtn: Laya.Image
	_lb_suitBtn: Laya.Label
	_img_title1: Laya.Image
	_lb_title1: Laya.Label
	_img_title2: Laya.Image
	_lb_title2: Laya.Label
	strenBtn: Laya.Box
	_Image11: Laya.Image
	labelDisplay: Laya.Label
	strenRed: Laya.Image
	suitScroller: Laya.List
	_Scroller1: Laya.List
	matGp: Laya.Box
	matLb: Laya.Label
	public GetComponents() {
		[
			this._img_bg1,
			this._img_bg0,
			this._img_bg2,
			this._img_bg3,
			this.TabScroller,
			this.ItemGp,
			this._gp0,
			this._gp1,
			this._gp2,
			this._gp3,
			this._gp4,
			this._gp5,
			this._gp6,
			this._gp7,
			this._gp8,
			this.lockGp,
			this._img_lockbg,
			this._img_lock,
			this.unlockRed,
			this.propBtn,
			this.upStageBtn,
			this.upStageRed,
			this.bagBtn,
			this.bagRed,
			this.comBtn,
			this.comRed,
			this.godHouseBtn,
			this.houseRed,
			this.suitPreBtn,
			this._lb_suitBtn,
			this._img_title1,
			this._lb_title1,
			this._img_title2,
			this._lb_title2,
			this.strenBtn,
			this._Image11,
			this.labelDisplay,
			this.strenRed,
			this.suitScroller,
			this._Scroller1,
			this.matGp,
			this.matLb,
		]
			= this.GetChildrenByNames([
				"_img_bg1",
				"_img_bg0",
				"_img_bg2",
				"_img_bg3",
				"TabScroller",
				"ItemGp",
				"_gp0",
				"_gp1",
				"_gp2",
				"_gp3",
				"_gp4",
				"_gp5",
				"_gp6",
				"_gp7",
				"_gp8",
				"lockGp",
				"_img_lockbg",
				"_img_lock",
				"unlockRed",
				"propBtn",
				"upStageBtn",
				"upStageRed",
				"bagBtn",
				"bagRed",
				"comBtn",
				"comRed",
				"godHouseBtn",
				"houseRed",
				"suitPreBtn",
				"_lb_suitBtn",
				"_img_title1",
				"_lb_title1",
				"_img_title2",
				"_lb_title2",
				"strenBtn",
				"_Image11",
				"labelDisplay",
				"strenRed",
				"suitScroller",
				"_Scroller1",
				"matGp",
				"matLb",
			])
	}
}
window["GodCourtView"] = GodCourtView
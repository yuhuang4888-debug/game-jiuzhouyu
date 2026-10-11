import { BaseView1 } from "../common/BaseView1"
import { table } from "../common/table"
import { Util, GetSizeDeltaY, SetAnchoredPositionY } from "../util/Util"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { SYTweenLite } from "../util/SYTweenLite"
import { GoodsModel } from "../commonModel/GoodsModel"
import { Message } from "../sysInfo/SysInfoController"
import { Alert, Alert_Type } from "../alert/Alert"
import { OpenFun } from "../common/OpenFun"
import { CongratulationObtainView } from "../common/CongratulationObtainView"
import { EquipmentItem } from "../common/EquipmentItem"
import { UIVerTabBar } from "../newgameui/UIVerTabBar"
import { StarEquipModel } from "../commonModel/StarEquipModel"
import { StarEquipComItem } from "./StarEquipComItem"
import { StarEquipComTabBtn } from "./StarEquipComTabBtn"
import { StarEquipTabSubBtn } from "./StarEquipTabSubBtn"

import "./StarEquipComPreview"
import "./StarEquipAddEquipView"

export class StarEquipComView extends BaseView1 {
	CloseFunc
	Content
	EmpcomBtn
	FailAni
	GetTabRedDot
	InitTab
	InitView
	Open
	ScrtabScroller
	SetTabRed
	SwitchFunc
	UpdateSuccess

	curComData
	defaultId
	itemList
	radomInfo
	sub_id_list
	successRatio
	tabbar
	tweenId
	waitId
	cfg_menu
	cfg_menu_id
	cfg_con_compose

	public constructor() {
		super()
		this.base_file = "starEquip"
		this.layout_file = "StarEquipComView"
		this.layer_value = Enum_UILayer.Activity
		this.is_center = true
		this.use_background = true
		this.click_bg_toClose = true
		this.preload_server_config = {
			"config_compose_menu": false,
			"config_compose_menu_id": false,
			"config_constellation_compose": false
		}

		this.successRatio = 0
		this.sub_id_list = []
		this.itemList = []
		let local_StarEquipModel = StarEquipModel
		let local_starEquipIns = local_StarEquipModel.GetInstance()
		let local_resMgr = ResManager.GetInstance()
		let lcoal_goodsModel = GoodsModel
		let lcoal_goodsIns = lcoal_goodsModel.GetInstance()

		this.load_callback = () => {
			local_resMgr.SetOutsideImageSprite(this, this.bg1, GameResPath.GetIcon("starEquip", "uixzsy_030"))
			
			this.spComLb.style.fontSize = 20
			this.spComLb.style.color = "#663915"
			this.spComLb.style.wordWrap = false

			this.cfg_menu = local_resMgr.GetGameConfigFromCache(this, "config_compose_menu", false)
			this.cfg_menu_id = local_resMgr.GetGameConfigFromCache(this, "config_compose_menu_id", false)
			this.cfg_con_compose = local_resMgr.GetGameConfigFromCache(this, "config_constellation_compose", false)
			this.InitView()
			// if (PlatformMgr.GetInstance().IsEyouEnPlatform()) {
			// 	SetAnchoredPositionX(this.comTips, 399)
			// 	SetAnchoredPositionX(this.successLb, 467)
			// }
		}

		this.destroy_callback = () => {
			if (this.tweenId) {
				SYTweenLite.Stop(this.tweenId)
				this.tweenId = null
			}
			if (this.waitId) {
				clearTimeout(this.waitId)
				this.waitId = null
			}
			this.CloseFunc()
		}

		this.InitView = () => {
			Util.AddClickEvent(this.comBtn, () => {
				if (this.curComData) {
					let comFunc = (is_close?) => {
						if (is_close) {
							return
						}
						//let goodsNum = 0
						let ruleId = this.curComData.id
						//let selectList = []
						let regularList = []
						let regular_mat = JSON.parse(this.curComData.regular_mat)
						for (let _tmpi in regular_mat) {
							let vo = regular_mat[_tmpi]
							let goodsVoList = lcoal_goodsIns.GetTypeGoods(Number(vo[1]))
							let needNum = Number(vo[2])
							for (let _tmpi1 in goodsVoList) {
								let vo1 = goodsVoList[_tmpi1]
								for (let i = 0; i <= Math.min(needNum, vo1.goods_num); i++) {
									table.insert(regularList, vo1.goods_id)
									needNum = needNum - 1
									if (needNum == 0) {
										break
									}
								}
								if (needNum == 0) {
									break
								}
							}
							if (needNum > 0) {
								Message.show("物品不足")
								return
							}
						}
						let irList = []
						for (let key in local_starEquipIns.comSelect) {

							table.insert(irList, key)
						}
						let addsuccessList = []
						for (let ket in local_starEquipIns.comExtraList) {

							table.insert(addsuccessList, ket)
						}
						local_starEquipIns.Fire(local_StarEquipModel.COM_REQUEST, ruleId, irList, regularList, addsuccessList)
					}

					if (local_starEquipIns.comRatio) {
						//let goodsNum = 0
						//let ruleId = this.curComData.id
						let regular_mat = JSON.parse(this.curComData.regular_mat)
						for (let _tmpi in regular_mat) {
							let vo = regular_mat[_tmpi]
							let goodsVoList = lcoal_goodsIns.GetTypeGoods(Number(vo[1]))
							let needNum = Number(vo[2])
							for (let _tmpi1 in goodsVoList) {
								let vo1 = goodsVoList[_tmpi1]
								for (let i = 0; i <= Math.min(needNum, vo1.goods_num); i++) {
									needNum = needNum - 1
									if (needNum == 0) {
										break
									}
								}
								if (needNum == 0) {
									break
								}
							}
							if (needNum > 0) {
								Message.show("物品不足")
								return
							}
						}
						let irregular_mat = JSON.parse(this.curComData.irregular_mat)
						if (irregular_mat.length > 0 && Util.IsTableEmpty(local_starEquipIns.comSelect)) {
							Message.show("物品不足")
							return
						}
						if (this.successRatio < 100) {
							Alert.Show("当前成功率低于100%,放入装备可提升成功率", Alert_Type.Two, () => {
								if (this.curComData) {
									local_starEquipIns.Fire(local_StarEquipModel.OPEN_VIEW, "StarEquipAddEquipView", this.curComData.id)
								}
							}
								, comFunc, "放入装备", "坚持合成")
						} else {
							comFunc(false)
						}
					} else {
						comFunc(false)
					}
				}
			}
				, this, true)

			Util.AddClickEvent(this.closeBtn, () => {
				this.Close()
			}, this, true)

			Util.AddClickEvent(this.upBtn, () => {
				if (this.curComData) {
					local_starEquipIns.Fire(local_StarEquipModel.OPEN_VIEW, "StarEquipAddEquipView", this.curComData.id)
				}
			}, this, true)

			// Util.AddClickEvent(this.getBtn, () => {
			// 	OpenFun.OpenFunHandler(1)
			// }
			// 	, this, true)

			Util.AddClickEvent(this.radomGp, () => {
				if (this.radomInfo) {
					local_starEquipIns.Fire(local_StarEquipModel.OPEN_VIEW, "StarEquipComPreview", this.radomInfo)
				}
			}, this, true)

			this.BindEvent(local_starEquipIns, local_StarEquipModel.SELECT_COM_MAT, (goods_id?, bool?, index?) => {
				let item = this.itemList[index]
				if (item) {
					if (bool) {
						let goodsVo = lcoal_goodsIns.GetGoodsVoByGoodsId(goods_id)
						item.SetEquipData(goodsVo)
					} else {
						item.ReSetItem()
					}
				}
			})

			this.BindVar(local_starEquipIns, "comPoint", () => {
				this.UpdateSuccess()
			})

			this.BindEvent(local_starEquipIns, local_StarEquipModel.UPDATE_COM_TIME, (scmd?) => {
				if ((scmd && this.curComData) && scmd.compose_id == this.curComData.id) {
					let targetData = JSON.parse(this.curComData.goods)
					let id = null
					for (let _tmpi in targetData) {
						let vo = targetData[_tmpi]
						if (vo[0] == "special") {
							id = vo[2][0][2]
						}
					}
					let showNum = scmd.index - scmd.num
					this.spComLb.innerHTML = Util.StrToHTML("再成功合成<font color='#0a953e'>" + showNum + "</font>次，必定合成" + lcoal_goodsModel.GetGoodsNameWithColorDark(id))
					this.sp_con.width = this.spComLb.width
					this.spComLb.y = 0
				}
			}
			)

			this.BindEvent(local_starEquipIns, local_StarEquipModel.COM_SUCCESS, (rule_id?, goods_list?) => {
				local_starEquipIns.ClearComSelect()
				let comList = []
				for (let _tmpi in goods_list) {
					let vo = goods_list[_tmpi]
					table.insert(comList, [0, vo.goods_type_id, 1, vo.goods_id])
					let goodsBasic = lcoal_goodsIns.GetGoodsBasicByTypeId(vo.goods_type_id)
					if ((goodsBasic && goodsBasic.subtype == 10) && this.curComData) {
						local_starEquipIns.Fire(local_StarEquipModel.SEND_PROTO, 23256, "i", this.curComData.id)
					}
				}
				let success_view = new CongratulationObtainView(comList, 10)
				success_view.Open()
				//ShowCongratulationView()
				this.SwitchFunc()
			}
			)

			this.BindEvent(local_starEquipIns, local_StarEquipModel.COM_FAIL, () => {
				this.FailAni()
				local_starEquipIns.ClearComSelect()
				this.SwitchFunc()
			}
			)

			this.BindEvent(lcoal_goodsIns, lcoal_goodsModel.UPDATE_GOODS_NUM, () => {
				if (!this.use_delete_method) {
					this.SetTabRed()
				}
			}
			)

			Util.AddClickEvent(this.icon1, () => {
				OpenFun.OpenFunHandler(140, 79070501)
				this.Close()
			}, this, true)

			Util.AddClickEvent(this.icon2, () => {
				OpenFun.OpenFunHandler(152)
				this.Close()
			}, this, true)

			if (!this.tabbar) {
				this.tabbar = new UIVerTabBar(this.tabScroller)
				this.tabbar.Load()
			}

			for (let i = 0; i < 3; i++) {
				let item = this.itemList[i]
				if (!item) {
					item = new StarEquipComItem(this["itemGp" + (i + 1)])
					item.SetPos(i)
					item.Load()
					this.itemList[i] = item
				}
			}

			this.itemList[3] = new EquipmentItem(this.itemGp4)
			this.itemList[3].Load()
			this.itemList[3].SetScale(0.75)

			this.InitTab()
		}

		this.InitTab = () => {
			//let local_comModelIns = CompositeModel.GetInstance()
			let nameList = StarEquipModel.GetInstance().GetComTabName(this.cfg_menu, this.cfg_menu_id, this.cfg_con_compose)
			this.sub_id_list = StarEquipModel.GetInstance().starEquip_tab_id_list
			this.tabbar.SetTabBar(nameList, this.SwitchFunc, GetSizeDeltaY(this.tabScroller), null, StarEquipComTabBtn, null, null, StarEquipTabSubBtn, null, 210)
			let tab = 0
			let sub = 0
			if (this.defaultId) {
				let find = false
				for (let i = 0; i < this.sub_id_list.length; i++) {
					let vo = this.sub_id_list[i] && this.sub_id_list[i][1]
					if (vo) {
						for (let j = 0; j < vo.length; j++) {
							if (this.defaultId == vo[j]) {
								tab = i
								sub = j
								find = true
							}
						}
					}
				}
			}
			this.tabbar.SetSelectTab(tab, sub)
			//this.tabbar.RefreshSrollerPos()
			this.SwitchFunc(tab, sub)
			this.SetTabRed()
		}

		this.SwitchFunc = (tabIndex?, subIndex?) => {
			if (!this.sub_id_list) { return }
			let info = this.sub_id_list[tabIndex] && this.sub_id_list[tabIndex][0][subIndex]
			if (info || (tabIndex == null && subIndex == null)) {
				info = info && Number(info)
				let CurComCfg = this.cfg_con_compose[info]
				if ((!CurComCfg && tabIndex == null) && subIndex == null) {
					CurComCfg = this.curComData
				}
				if (CurComCfg || tabIndex == null && subIndex == null) {
					this.curComData = CurComCfg
					let regular_mat = JSON.parse(CurComCfg.regular_mat)
					let irregulat_mat = JSON.parse(CurComCfg.irregular_mat)
					let useIndex = 0
					for (let i = 0; i < regular_mat.length; i++) {
						if (useIndex < 3) {
							this.itemList[useIndex].InitMatData(1, regular_mat[i])
							useIndex = useIndex + 1
						}
					}
					if (irregulat_mat.length > 0) {
						this.itemList[useIndex].InitMatData(2, irregulat_mat)
						useIndex = useIndex + 1
					}
					for (let i = useIndex; i < 3; i++) {
						this.itemList[i].InitMatData(3)
					}

					let targetData = JSON.parse(CurComCfg.goods)
					for (let _tmpi in targetData) {
						let vo = targetData[_tmpi]
						if (vo[0] == "normal") {
							let list = vo[1]
							if (list.length > 1) {
								this.itemGp4.visible = false
								this.radomGp.visible = true
								this.upBtn.visible = true
								this.radomInfo = list
								local_starEquipIns.comRatio = JSON.parse(CurComCfg.ratio)
								this.comTips.visible = false
								this.icon2.visible = false
								this.icon1.visible = false
								this.spComLb.visible = true
								this.UpdateSuccess()
								local_starEquipIns.Fire(local_StarEquipModel.SEND_PROTO, 23256, "i", CurComCfg.id)
								let beforeCfg = info && this.cfg_con_compose[info - 1]
								let showName = false
								if (beforeCfg) {
									this.spLb.text = beforeCfg.name
									showName = true
								}
								this.spLb.visible = showName
								this.spBg.visible = showName
							} else {
								this.itemGp4.visible = true
								this.radomGp.visible = false
								this.upBtn.visible = false
								this.spComLb.visible = false
								this.radomInfo = null
								this.itemList[3].SetData(list[0][2])
								local_starEquipIns.comRatio = null
								this.comTips.visible = true
								this.icon2.visible = true
								this.icon1.visible = true
								this.successLb.text = "100%"
								this.spLb.visible = false
								this.spBg.visible = false
							}
						}
					}
					local_starEquipIns.curComRule = CurComCfg.id
				}
			}
			local_starEquipIns.ClearComSelect()
		}

		this.UpdateSuccess = () => {
			let vo = local_starEquipIns.comRatio
			if (vo) {
				let success = Math.min(Math.ceil(Number(vo[0]) + local_starEquipIns.comPoint / vo[1] * (100 - vo[0])), 100)
				this.successRatio = success
				this.successLb.text = success + "%"
			}
		}

		this.SetTabRed = () => {
			let list = this.GetTabRedDot()
			for (let i = 0; i < list.length; i++) {
				let ShowRed = false
				for (let j = 0; j < list[i].length; j++) {
					let show = list[i][j]
					if (show) {
						ShowRed = true
						this.tabbar.setSubTabRedDot(i, j, true)
					} else {
						this.tabbar.setSubTabRedDot(i, j, false)
					}
				}
				this.tabbar.setTabRedDot(i, ShowRed)
			}
		}

		this.GetTabRedDot = () => {
			let list = local_starEquipIns.starEquip_tab_id_list
			//let comRed = false
			let returnList = []
			for (let _tmpi in list) {
				let tabList = list[_tmpi]
				let subRedList = []
				for (let _tmpi in tabList) {
					let subList = tabList[_tmpi]
					for (let _tmpi in subList) {
						let subVo = subList[_tmpi]
						subRedList.push(local_starEquipIns.canComEquip(this.cfg_con_compose, subVo))
					}
				}
				table.insert(returnList, subRedList)
			}
			return returnList
		}

		this.CloseFunc = () => {
			if (this.tabbar) {
				this.tabbar.DeleteMe()
				this.tabbar = null
			}
			for (let key in this.itemList) {
				let item = this.itemList[key]
				item.DeleteMe()
			}
			this.itemList = []
			this.defaultId = null
			local_starEquipIns.ClearComSelect()
		}

		this.FailAni = () => {
			this.failImg.visible = true
			this.failImg.alpha = 1
			SetAnchoredPositionY(this.failImg, 600)
			if (this.tweenId) {
				SYTweenLite.Stop(this.tweenId)
			}

			this.tweenId = SYTweenLite.to(this, this.failImg, SYTweenLite.UiAnimationType.ANCHORED_POSY, 230, 1, () => {
				this.waitId = setTimeout(() => {
					if (!this.use_delete_method) {
						this.tweenId = SYTweenLite.to(this, this.failImg, SYTweenLite.UiAnimationType.ALPHA, 0, 0.8)
					}
				}, 200)
			})
		}

		this.Open = (...new_args) => {
			this.defaultId = new_args[0]
			super.Open()
		}
	}

	bg: Laya.Image
	bg1: Laya.Image
	_Image1: Laya.Image
	tabScroller: Laya.Box
	upBtn: Laya.Image
	_Image2: Laya.Image
	comBtn: Laya.Box
	_Image11: Laya.Image
	labelDisplay: Laya.Label
	_BitmapLabel1: Laya.Label
	successLb: Laya.Label
	_Image3: Laya.Image
	closeBtn: Laya.Image
	_Image4: Laya.Image
	_Image5: Laya.Image
	_Image6: Laya.Image
	_Image7: Laya.Image
	_Image8: Laya.Image
	radomGp: Laya.Box
	_Image9: Laya.Image
	_Image10: Laya.Image
	itemGp4: Laya.Box
	itemGp1: Laya.Box
	itemGp2: Laya.Box
	itemGp3: Laya.Box
	comTips: Laya.Label
	failImg: Laya.Image
	icon1: Laya.Image
	icon2: Laya.Image
	sp_con: Laya.HBox
	spComLb: Laya.HTMLDivElement
	spBg: Laya.Image
	spLb: Laya.Label
	public GetComponents() {
		[
			this.bg,
			this.bg1,
			this._Image1,
			this.tabScroller,
			this.upBtn,
			this._Image2,
			this.comBtn,
			this._Image11,
			this.labelDisplay,
			this._BitmapLabel1,
			this.successLb,
			this._Image3,
			this.closeBtn,
			this._Image4,
			this._Image5,
			this._Image6,
			this._Image7,
			this._Image8,
			this.radomGp,
			this._Image9,
			this._Image10,
			this.itemGp4,
			this.itemGp1,
			this.itemGp2,
			this.itemGp3,
			this.comTips,
			this.failImg,
			this.icon1,
			this.icon2,
			this.sp_con,
			this.spComLb,
			this.spBg,
			this.spLb,
		]
			= this.GetChildrenByNames([

				"bg",
				"bg1",
				"_Image1",
				"tabScroller",
				"upBtn",
				"_Image2",
				"comBtn",
				"_Image11",
				"labelDisplay",
				"_BitmapLabel1",
				"successLb",
				"_Image3",
				"closeBtn",
				"_Image4",
				"_Image5",
				"_Image6",
				"_Image7",
				"_Image8",
				"radomGp",
				"_Image9",
				"_Image10",
				"itemGp4",
				"itemGp1",
				"itemGp2",
				"itemGp3",
				"comTips",
				"failImg",
				"icon1",
				"icon2",
				"sp_con",
				"spComLb",
				"spBg",
				"spLb",
			])
	}
}
window["StarEquipComView"] = StarEquipComView
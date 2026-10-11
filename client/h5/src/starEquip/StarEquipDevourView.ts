import { BaseItem1 } from "../common/BaseItem1"
import { Util } from "../util/Util"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { GoodsModel } from "../commonModel/GoodsModel"
import { Message } from "../sysInfo/SysInfoController"
import { LoopScrowViewMgr, LoopScrCon } from "../common/LoopScrowViewMgr"
import { StarEquipModel } from "../commonModel/StarEquipModel"
import { FightingShowSmallItem } from "../common/FightingShowSmallItem"
import { StarEquipDevItem } from "./StarEquipDevItem"

export class StarEquipDevourView extends BaseItem1 {
	InitView
	LocalDeleteMe
	SetColor
	SetExp
	SetSingle
	SetSmletExp
	SetTabBtn
	UpdateDevourList
	fight
	itemArr
	itemGroup
	cfg_decompose
	cfg_equip

	public constructor(parent?) {
		super(parent)
		this.base_file = "starEquip"
		this.layout_file = "StarEquipDevourView"
		this.preload_server_config = {
			"config_constellation_decompose": false,
			"config_constellation_equip": false
		}

		let local_StarEquipModel = StarEquipModel
		let local_StarEquipModelIns = local_StarEquipModel.GetInstance()
		let local_goodsModelIns = GoodsModel.GetInstance()
		let local_resMgr = ResManager.GetInstance()

		this.load_callback = () => {
			this.cfg_decompose = local_resMgr.GetGameConfigFromCache(this, "config_constellation_decompose", false)
			this.cfg_equip = local_resMgr.GetGameConfigFromCache(this, "config_constellation_equip", false)

			this._Scroller1.scrollBar.visible = false
			this.curLb.style.fontSize = 22
			this.curLb.style.color = "#955959"
			this.curLb.style.wordWrap = false

			this.InitView()
		}

		this.InitView = () => {
			this.fight = new FightingShowSmallItem(this._fight)
			this.fight.Load()

			Util.AddClickEvent(this.devourBtn, () => {
				if (Util.IsTableEmpty(local_StarEquipModelIns.devourSelect)) {
					Message.show("未选择吞噬物品")
					return
				}
				local_StarEquipModelIns.Fire(local_StarEquipModel.ADD_DEVOUR_EFFECT)
				setTimeout(() => {
					local_StarEquipModelIns.Fire(local_StarEquipModel.REQUEST_DEVOUR)
				}, 500)
				//Laya:callLater(() => {
				//local_StarEquipModelIns:Fire(local_StarEquipModel.REQUEST_DEVOUR)
				//}
				//, 500)
			}, this, true)
			Util.AddClickEvent(this.colorBtn, this.SetColor, this, false)
			Util.AddClickEvent(this.singleBtn, this.SetSingle, this, false)

			Util.AddClickEvent(this.propBtn, () => {
				let attrCfg = this.cfg_decompose[local_StarEquipModelIns.devourLv]
				if (attrCfg) {
					let CurCfg = JSON.parse(attrCfg.attr)
					let list = []
					for (let _tmpi in CurCfg) {
						var vo = CurCfg[_tmpi]
						list[vo[0]] = vo[1]
					}
					if (Util.IsTableEmpty(CurCfg)) {
						Message.show("暂无属性加成")
						return
					}
					local_StarEquipModelIns.Fire(local_StarEquipModel.OPEN_VIEW, "StarEquipPropView", list)
				} else {
					Message.show("暂无属性加成")
				}
			}, this, true)

			this.BindEvent(local_goodsModelIns, GoodsModel.CHANGE_STAREQUIP_BAG, (list?) => {
				if (!list || this.use_delete_method) {
					return
				}
				let change = false
				for (let _tmpi in list) {
					var vo = list[_tmpi]
					if (vo.goods_num == 0 && local_StarEquipModelIns.devourSelect[vo.goods_id]) {
						local_StarEquipModelIns.SelectDevourGoods(vo.goods_id, vo.type_id, false)
						change = true
					}
				}
				if (change) {
					this.UpdateDevourList()
				}
			})

			this.BindEvent(local_StarEquipModelIns, local_StarEquipModel.UPDATE_DEVOUR_TAB, () => {
				this.SetTabBtn()
				local_StarEquipModelIns.GetDevourList(this.cfg_equip)
			})

			this.BindVar(local_StarEquipModelIns, "CurExp", () => {
				this.SetSmletExp()
			})

			this.BindEvent(local_StarEquipModelIns, local_StarEquipModel.UPDATE_DEVOUR_DATA, () => {
				this.SetExp()
			})

			this.BindEvent(local_StarEquipModelIns, local_StarEquipModel.DEVOUR_SUCCESS, () => {
				local_StarEquipModelIns.ClearDevourSelect()
				this.UpdateDevourList()
			})

			this.SetTabBtn()
			this.UpdateDevourList()
			local_StarEquipModelIns.GetDevourList(this.cfg_equip)
			this.SetExp()
			local_resMgr.SetOutsideImageSprite(this, this.img2, GameResPath.GetIconJpg("starEquip", "uitc_049"), true)
			//local_resMgr:SetOutsideImageSprite(this, this.img1, GameResPath.GetIcon("bag","uirwv4_020"))
			local_resMgr.SetImageSpriteTrans(this, this.expImg, GameResPath.GetIcon("common2", "uirwv4_016"))
		}

		this.UpdateDevourList = (bool?) => {
			local_StarEquipModelIns.CreateDevourList(this.cfg_equip)

			let isNull = local_StarEquipModelIns.devourList.length == 0
			this.nothingLb.visible = isNull
			if (!this.itemArr) {
				this.itemArr = new LoopScrowViewMgr()
				this.itemArr.SetData(this._Scroller1, StarEquipDevItem, local_StarEquipModelIns.devourList, LoopScrCon.Vertical, 6)
			} else {
				this.itemArr.replaceAll(local_StarEquipModelIns.devourList)
			}
		}

		this.SetColor = () => {
			let color = local_StarEquipModelIns.devColor == 1 ? 0 : 1
			local_StarEquipModelIns.Fire(local_StarEquipModel.SEND_PROTO, 23208, "cc", color, local_StarEquipModelIns.devSingle)
		}

		this.SetSingle = () => {
			let single = local_StarEquipModelIns.devSingle == 1 ? 0 : 1
			local_StarEquipModelIns.Fire(local_StarEquipModel.SEND_PROTO, 23208, "cc", local_StarEquipModelIns.devColor, single)
		}

		this.SetExp = () => {
			let attrCfg = this.cfg_decompose[local_StarEquipModelIns.devourLv + 1]
			if (attrCfg) {
				let max = attrCfg.exp
				this.expLb.text = "Lv." + local_StarEquipModelIns.devourLv + "   " + local_StarEquipModelIns.devourExp + "/" + max
				//if (! this.expMask ) {
				//this.expMask = Laya. new Rectangle(0, 0, this.expImg.width, 18)
				//this.expImg.mask = this.expMask
				//}
				//this.expImg.mask.width = local_StarEquipModelIns.devourExp / max * 545
				this.expImg.width = Math.min(local_StarEquipModelIns.devourExp / max, 1) * 545
				if (local_StarEquipModelIns.devourLv > 0) {
					this.fight.Updatefighting(local_StarEquipModelIns.devourPower)
				} else {
					this.fight.Updatefighting(0)
				}
			}
		}

		this.SetSmletExp = () => {
			if (local_StarEquipModelIns.CurExp == 0) {
				this.curLb.visible = false
			} else {
				this.curLb.visible = true
				this.curLb.innerHTML = Util.StrToHTML("本次熔炼值:<font color='#ff5500'>" + Math.ceil(local_StarEquipModelIns.CurExp) + "</font>")
			}
			this.curLb.y = 0
		}

		this.SetTabBtn = () => {
			this.select0.visible = local_StarEquipModelIns.devColor != 0
			this.Unselect0.visible = local_StarEquipModelIns.devColor == 0
		}

		this.LocalDeleteMe = () => {
			if (this.itemArr) {
				this.itemArr.DeleteMe()
				this.itemArr = null
			}
			if (this.fight) {
				this.fight.DeleteMe()
				this.fight = null
			}
			local_StarEquipModelIns.ClearDevourSelect()
		}
	}

	public DeleteMe() {
		this.LocalDeleteMe()
		super.DeleteMe()
	}

	img2: Laya.Image
	_Image1: Laya.Image
	_Image2: Laya.Image
	expImg: Laya.Image
	_Scroller1: Laya.List
	expLb: Laya.Label
	gp_cur: Laya.HBox
	curLb: Laya.HTMLDivElement
	nothingLb: Laya.Label
	colorBtn: Laya.Box
	Unselect0: Laya.Image
	select0: Laya.Image
	_Label1: Laya.Label
	singleBtn: Laya.Box
	Unselect1: Laya.Image
	select1: Laya.Image
	_Label2: Laya.Label
	_Group1: Laya.HBox
	_fight: Laya.Box
	propBtn: Laya.Image
	devourBtn: Laya.Box
	Image: Laya.Image
	Text: Laya.Label
	public GetComponents() {
		[
			this.img2,
			this._Image1,
			this._Image2,
			this.expImg,
			this._Scroller1,
			this.expLb,
			this.gp_cur,
			this.curLb,
			this.nothingLb,
			this.colorBtn,
			this.Unselect0,
			this.select0,
			this._Label1,
			this.singleBtn,
			this.Unselect1,
			this.select1,
			this._Label2,
			this._Group1,
			this._fight,
			this.propBtn,
			this.devourBtn,
			this.Image,
			this.Text,
		]
			= this.GetChildrenByNames([

				"img2",
				"_Image1",
				"_Image2",
				"expImg",
				"_Scroller1",
				"expLb",
				"gp_cur",
				"curLb",
				"nothingLb",
				"colorBtn",
				"Unselect0",
				"select0",
				"_Label1",
				"singleBtn",
				"Unselect1",
				"select1",
				"_Label2",
				"_Group1",
				"_fight",
				"propBtn",
				"devourBtn",
				"Image",
				"Text",
			])
	}
}
window["StarEquipDevourView"] = StarEquipDevourView
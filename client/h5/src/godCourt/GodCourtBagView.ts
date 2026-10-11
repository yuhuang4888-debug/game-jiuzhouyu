import { BaseView1 } from "../common/BaseView1"
import { Util, SetLocalPosition } from "../util/Util"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { CookieWrapper } from "../common/CookieWrapper"
import { GoodsModel } from "../commonModel/GoodsModel"
import { GodCourtModel } from "../commonModel/GodCourtModel"
import { LoopScrowViewMgr, LoopScrCon } from "../common/LoopScrowViewMgr"
import { GCBagTabItem } from "./GCBagTabItem"
import { GodCourtEquipItem } from "./GodCourtEquipItem"
import { GCBagPanel } from "./GCBagPanel"
import { GCDevourPanel } from "./GCDevourPanel"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { GodCourtTooltip } from "../common/GodCourtTooltip"

export class GodCourtBagView extends BaseView1 {
	DesFunc
	InitEquipItem
	InitEvent
	InitView
	Open
	SelectTab

	public constructor() {
		super()
		this.base_file = "godCourt"
		this.layout_file = "GodCourtBagView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.use_background = true
		this.is_center = true
		this.click_bg_toClose = true

		let godCourtId = null
		//let selectType = null
		let TabArr = null
		let itemList = null
		let model = GodCourtModel.GetInstance()
		let cookie_wrapper = CookieWrapper.GetInstance()

		let bagPanel = null
		let selectId = null
		let devourPanel = null

		this.load_callback = () => {
			this._scroller.hScrollBarSkin = ""
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg1, "resource/game/godCourt/other/u_Divinei_04.png")
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg2, "resource/game/godCourt/other/u_Divinei_01.png")
			
			this.InitView()
			this.InitEvent()
		}

		this.destroy_callback = () => {
			this.DesFunc()
		}

		this.Open = (...new_args) => {
			let parms = new_args
			if (parms) {
				godCourtId = parms[0]
				selectId = parms[1]
			}
			super.Open()
		}

		this.InitView = () => {
			if (!godCourtId || !this.is_loaded) {
				return
			}

			TabArr = new LoopScrowViewMgr()
			TabArr.SetData(this._scroller, GCBagTabItem, [{ index: 0, name: "背包" }, { index: 1, name: "分解" }], LoopScrCon.Horizontal, 1, (index?) => {
				this.SelectTab(index)
			})

			let obj = cookie_wrapper.GetCookie(CookieWrapper.GODCOURT_BAG_INFO, true)
			if (obj) {
				let info = JSON.parse(obj)
				model.showColor = info.drop_color
				model.showType = info.drop_stage
			}

			this.InitEquipItem()
			if (!bagPanel) {
				bagPanel = new GCBagPanel(this._gp_bag)
				bagPanel.SetId(godCourtId)
				bagPanel.Load()
			}
			if (!devourPanel) {
				devourPanel = new GCDevourPanel(this._gp_devour)
				devourPanel.SetId(godCourtId)
				devourPanel.Load()
			}
			//local_resMgr:SetImageSprite(this, this._bg, "common_assets","uisy_023")
			// local_resMgr.SetOutsideImageSprite(this, this.bg0, GameResPath.GetIconJpg("godCourt", "uistwzsj_005"), true)
			// local_resMgr.SetOutsideImageSprite(this, this.bg1, GameResPath.GetIcon("godCourt", "uisthchc_004"))

			//this.AddUIEffect("UI_1608", "Activity", this.effectGp0, null, null, true)
			//this:AddUIEffect("ui_Shenting_runeUI2_wenli","UI", this.effectGp1, null, null, true)
			//this:AddUIEffect("ui_Shenting_runeUI2_wenli","UI", this.effectGp2, null, null, true)

			if (selectId) {
				this.SelectTab(selectId)
				TabArr.SetSelectIndex(selectId)
			} else {
				this.SelectTab(0)
				TabArr.SetSelectIndex(0)
			}
			// let showEquipEffect = true
			// for (let i = 1; i <= GodCourtModel.PosList.length; i++) {
			// 	let data = model.GetEquipData(godCourtId, i)
			// 	if (!data.equip_id && data.pos < 9) {
			// 		showEquipEffect = false
			// 		break
			// 	}
			// }
			// this.effectGp0.visible = showEquipEffect
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._btn_close, () => {
				this.Close()
			}, this, true)

			this.BindEvent(model, GodCourtModel.UPDATE_GODCOURT, () => {
				let showEquipEffect = true
				for (let i = 1; i <= GodCourtModel.PosList.length; i++) {
					let data = model.GetEquipData(godCourtId, i)
					if (!data.equip_id && data.pos < 9) {
						showEquipEffect = false
					}
				}
				//this.effectGp0.visible = showEquipEffect
			})
		}

		this.InitEquipItem = () => {
			itemList = itemList || {}
			for (let i = 0; i < 9; i++) {
				let item_partent = this["_gp" + i]
				let item = new GodCourtEquipItem(item_partent)
				item.Load()
				itemList[i] = item
				let data = model.GetEquipData(godCourtId, i + 1)
				if (data) {
					data.godCourtId = godCourtId
					if (data.equip_id == 0) {
						data.canEquip = true
					}
				}
				item.InitItem(data || { godCourtId: godCourtId, subtype: i + 1, canEquip: true }, (data?) => {
					if (data) {
						let goodsVo = GoodsModel.GetInstance().GetGoodsVoByGoodsId(data.equip_id)
						if (goodsVo) {
							let better = model.betterEquipList[data.godCourtId] && model.betterEquipList[data.godCourtId][data.pos]
							if (better) {
								model.AutoEquip(data)
							} else {
								UIToolTipMgr.GetInstance().AppendGodCourtTips(goodsVo.type_id, goodsVo, goodsVo.skill_id, [GodCourtTooltip.Btn.replace])
							}
						} else if (data.canEquip) {
							model.AutoEquip(data)
						}
					}
				}
				)
			}
		}

		this.SelectTab = (index?) => {
			//selectType = index
			let isDevour = index == 1

			this._gp_devour.visible = isDevour
			this._gp_bag.visible = !isDevour

			this._lb_title.text = isDevour ? "分解" : "背包"
			this._lb_tips.text = isDevour ? ("分解后获得" + GoodsModel.GetGoodsName(model.devoureMatId) + "可强化神社") : "纹章可在神祈中开启水晶获得"
		}

		this.DesFunc = () => {
			//let obj = [drop_color = model.showColor, drop_stage = model.showType]
			//cookie_wrapper:SaveCookie(CookieWrapper.GODCOURT_BAG_INFO, ErlangParser.GetInstance().stringify(obj), true)
			model.showDevour = 0
			model.showColor = 0
			model.showType = 0
			if (itemList) {
				for (let _tmpi in itemList) {
					let vo = itemList[_tmpi]
					vo.DeleteMe()
				}
				itemList = null
			}
			if (bagPanel) {
				bagPanel.DeleteMe()
				bagPanel = null
			}
			if (devourPanel) {
				devourPanel.DeleteMe()
				devourPanel = null
			}
			selectId = null
			if (TabArr) {
				TabArr.DeleteMe()
				TabArr = null
			}
		}
	}

	_img_bg0: Laya.Image
	_img_bg1: Laya.Image
	_img_bg2: Laya.Image
	_img_title: Laya.Image
	_lb_title: Laya.Label
	_btn_close: Laya.Image
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
	_scroller: Laya.List
	_gp_devour: Laya.Box
	_gp_bag: Laya.Box
	_img_tips: Laya.Image
	_lb_tips: Laya.Label
	public GetComponents() {
		[
			this._img_bg0,
			this._img_bg1,
			this._img_bg2,
			this._img_title,
			this._lb_title,
			this._btn_close,
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
			this._scroller,
			this._gp_devour,
			this._gp_bag,
			this._img_tips,
			this._lb_tips,
		]
			= this.GetChildrenByNames([

				"_img_bg0",
				"_img_bg1",
				"_img_bg2",
				"_img_title",
				"_lb_title",
				"_btn_close",
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
				"_scroller",
				"_gp_devour",
				"_gp_bag",
				"_img_tips",
				"_lb_tips",
			])
	}
}
window["GodCourtBagView"] = GodCourtBagView
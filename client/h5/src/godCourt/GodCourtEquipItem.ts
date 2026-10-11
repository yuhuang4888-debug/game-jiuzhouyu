import { BaseItem1 } from "../common/BaseItem1"
import { Util } from "../util/Util"
import { GodCourtModel } from "../commonModel/GodCourtModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"

export class GodCourtEquipItem extends BaseItem1 {
	DeleteMe1
	InitEvent
	InitItem
	RedFunc
	data
	local_ClickEvent
	touchChildren
	touchEnabled
	AddEvent

	public constructor(parent?) {
		super(parent)
		this.base_file = "godCourt"
		this.layout_file = "GodCourtEquipItem"

		let local_GodCourtModel = GodCourtModel
		let local_GodCourtIns = local_GodCourtModel.GetInstance()
		let local_goodsIns = GoodsModel.GetInstance()
		let needRefresh = null

		this.load_callback = () => {
			if (needRefresh) {
				needRefresh = false
				this.InitItem(this.data)
			}
			this.InitEvent()
		}

		this.InitItem = (data?, clickBack?) => {
			this.data = data
			if (clickBack) {
				this.local_ClickEvent = clickBack
			}
			if (!this.is_loaded) {
				needRefresh = true
				return
			}

			let effect = null
			let isCore = false
			let star = 0
			if ((data.subtype && Number(data.subtype) < 9) || (data.pos && Number(data.pos) < 9)) {
				ResManager.GetInstance().SetImageSprite(this, this.bg, "godCourt", "bg0")
			} else {
				isCore = true
				ResManager.GetInstance().SetImageSprite(this, this.bg, "common", "com_goods_plate_0")
				//effect = "UI_1610"
			}
			let goodsVo = local_goodsIns.GetGoodsVoByGoodsId(this.data.equip_id)
			this.ClearUIEffect(this._gp_effect)
			if (goodsVo) {
				if (goodsVo.subtype < 9) {
					star = 0
				} else {
					star = Math.min(goodsVo.type_id % 10, 5)
				}
				
				if (!effect) {
					if ((data.subtype && Number(data.subtype) < 9) || (data.pos && Number(data.pos) < 9)) {
						if (goodsVo.color == 3) {
							effect = "UI_1609_02"
						} else if (goodsVo.color == 4) {
							effect = "UI_1609_01"
						} else if (goodsVo.color == 5) {
							effect = "UI_1609_03"
						} else if (goodsVo.color == 2) {
							effect = "UI_1609_04"
						} else if (goodsVo.color == 7) {
							effect = "UI_1609_05"
						}
					} else {
						if (goodsVo.color == 5) {
							effect = "ui_goods_red"
						} else if (goodsVo.color == 7) {
							effect = "ui_goods_pink"
						}
					}
				}
				if ((data.subtype && Number(data.subtype) < 9) || (data.pos && Number(data.pos) < 9)) {
					ResManager.GetInstance().SetImageSprite(this, this.bg, "godCourt", "bg" + goodsVo.color)
				} else {
					ResManager.GetInstance().SetImageSprite(this, this.bg, "common", "com_goods_plate_" + goodsVo.color)
				}

				//this.colorImg.visible = true
				ResManager.GetInstance().SetOutsideImageSprite(this, this.icon, GameResPath.GetGoodsIconPath(goodsVo.goods_icon))
				this.stageLb.text = isCore ? "" : this.data.stage + "阶"
			} else {
				this.icon.skin = null
				ResManager.GetInstance().SetImageSprite(this, this.icon, "godCourt", "st" + (data.subtype || data.pos))
				//this.colorImg.visible = false
				this.stageLb.text = ""
				effect = false
			}
			if (effect) {
				this.AddUIEffect(effect, this._gp_effect, null, 6, true)
			} else {
				this.ClearUIEffect(this._gp_effect)
			}
			this.SetStar(star)
			this.RedFunc()
		}

		this.InitEvent = () => {
			this.BindEvent(local_GodCourtIns, local_GodCourtModel.REFRESH_RED, (type?) => {
				if ((this.data && type == 2 || type == 5) || type == 4) {
					this.RedFunc()
				}
			})

			this.BindEvent(GodCourtModel.GetInstance(), GodCourtModel.UPDATE_EQUIP, (scmd?) => {
				if ((scmd && this.data) && this.data.godCourtId == scmd.court_id) {
					let data = GodCourtModel.GetInstance().GetEquipData(scmd.court_id, this.data.pos || this.data.subtype)
					if (data) {
						data.godCourtId = scmd.court_id
						data.canEquip = this.data.canEquip
						data.isMainView = this.data.isMainView
					}
					this.data = data
					this.InitItem(this.data)
				}
			})

			Util.AddClickEvent(this.clickGp, () => {
				if (this.local_ClickEvent) {
					this.local_ClickEvent(this.data)
				}
			}, this, true)

			if (this.AddEvent) {
				this.AddEvent()
			}
		}

		// this.local_ClickEvent = (data?) => {
		// 	if (data) {
		// 		let goodsVo = local_goodsIns.GetGoodsVoByGoodsId(data.equip_id)
		// 		if (goodsVo) {
		// 			UIToolTipMgr.GetInstance().AppendGodCourtTips(goodsVo.type_id, goodsVo, goodsVo.skill_id, [GodCourtTooltip.Btn.replace])
		// 		}
		// 	}
		// }

		this.RedFunc = () => {
			if (this.data) {
				let pos = this.data.subtype || this.data.pos
				let list = local_GodCourtIns.betterEquipList[this.data.godCourtId]
				if (list) {
					this.redImg.visible = list[pos]
				} else {
					this.redImg.visible = false
				}
			}
		}

		this.DeleteMe1 = () => {

		}
	}

	public SetStar(num?) {
		for (let i = 0; i < 4; i++) {
			let item = this["star_" + i]
			if (item) {
				item.visible = i < num
			}
		}
	}

	public DeleteMe() {
		this.ClearUIEffect(this._gp_effect)
		super.DeleteMe()
	}

	clickGp: Laya.Box
	bg: Laya.Image
	_gp_effect: Laya.Box
	colorImg: Laya.Image
	icon: Laya.Image
	stageLb: Laya.Label
	redImg: Laya.Image
	star_group: Laya.Box
	star_0: Laya.Image
	star_1: Laya.Image
	star_2: Laya.Image
	star_3: Laya.Image
	public GetComponents() {
		[
			this.clickGp,
			this.bg,
			this._gp_effect,
			this.colorImg,
			this.icon,
			this.stageLb,
			this.redImg,
			this.star_group,
			this.star_0,
			this.star_1,
			this.star_2,
			this.star_3,
		]
			= this.GetChildrenByNames([

				"clickGp",
				"bg",
				"_gp_effect",
				"colorImg",
				"icon",
				"stageLb",
				"redImg",
				"star_group",
				"star_0",
				"star_1",
				"star_2",
				"star_3",
			])
	}
}
window["GodCourtEquipItem"] = GodCourtEquipItem
import { BaseView1 } from "../common/BaseView1"
import { Config } from "../common/Config"
import { table } from "../common/table"
import { Util, SetLocalPosition } from "../util/Util"
import { ResManager } from "../common/ResManager"
import { Enum_UILayer } from "../common/LayerManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { GodCourtModel } from "../commonModel/GodCourtModel"
import { MaterialsTool } from "../common/MaterialsTool"
import { BaseAwardItem } from "../common/BaseAwardItem"
import { GodCourtStageItem } from "./GodCourtStageItem"
import { GodCourtStagePropItem } from "./GodCourtStagePropItem"

export class GodCourtStageView extends BaseView1 {
	DesFunc
	InitEvent
	InitView
	Open
	SelectPosFunc
	SetProp
	UpdateMatNum

	godCourtId
	matInfo
	propGp
	is_up

	public constructor() {
		super()
		this.base_file = "godCourt"
		this.layout_file = "GodCourtStageView"
		this.layer_value = Enum_UILayer.Activity
		this.use_background = true
		this.click_bg_toClose = true
		this.is_center = true
		this.destroy_imm = true

		let selectPos = 1
		let matItem = null
		let itemList = null
		let model = GodCourtModel.GetInstance()
		let local_goodsIns = GoodsModel.GetInstance()
		let propList = null

		this.load_callback = () => {
			this._Scroller1.vScrollBarSkin = ""
			ResManager.GetInstance().SetOutsideImageSprite(this, this.bg1, "resource/game/godCourt/other/u_Divinei_04.png")
			ResManager.GetInstance().SetOutsideImageSprite(this, this.bg2, "resource/game/godCourt/other/u_Divinei_01.png")

			this.InitView()
			this.InitEvent()
		}

		this.destroy_callback = () => {
			this.DesFunc()
		}

		this.Open = (...new_args) => {
			let parms = new_args
			if (parms) {
				this.godCourtId = parms[0]
			}
			super.Open()
		}

		this.InitView = () => {
			if (this.godCourtId && this.is_loaded) {
				if (!itemList) {
					itemList = []
				}
				let showData = null
				let find = false
				//let showEquipEffect = true
				let showStage = 0

				for (let i = 0; i < 8; i++) {
					let item = itemList[i]
					if (!item) {
						let item_partent = this["_gp" + i]
						item = new GodCourtStageItem(item_partent)
						item.Load()
						SetLocalPosition(item.transform, GodCourtModel.PosList[i][0], GodCourtModel.PosList[i][1])
						itemList[i] = item
					}
					showData = model.GetEquipData(this.godCourtId, i + 1)
					if (showData) {
						if (!showData.equip_id && showData.pos < 9) {
							//showEquipEffect = false
						}
						showData.godCourtId = this.godCourtId
					}
					item.InitItem(showData || { godCourtId: this.godCourtId, subtype: i + 1 })
					if ((showData && showData.equip_id != 0) && (!find || showData.stage < showStage)) {
						find = true
						selectPos = i + 1
						showStage = showData.stage
					}
					// if (i == GodCourtModel.PosList.length - 1) {
					// 	//item.parent.setChildIndex(item, 0)
					// }
				}

				if (!matItem) {
					matItem = new BaseAwardItem(this._gp_mat)
					matItem.Load()
					matItem.SetItemSize(90, 90)
				}

				if (itemList[selectPos]) {
					itemList[selectPos].ExcuteCallback(() => {
						model.Fire(GodCourtModel.SELECT_STAGE, selectPos)
					}
					)
				}
				this.SelectPosFunc(selectPos)
				//this.effectGp0.visible = showEquipEffect
			}
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._btn_close, () => {
				this.Close()
			}, this, true)

			Util.AddClickEvent(this._btn_up, () => {
				if (this.is_up) {
					return
				}
				if (selectPos && this.godCourtId) {
					if (this.matInfo) {
						let [type_id, bind] = local_goodsIns.GetMappingTypeId(this.matInfo[0], this.matInfo[1])
						let nowNum = local_goodsIns.GetTypeGoodsNum(type_id)
						if (nowNum < Number(this.matInfo[2])) {
							MaterialsTool.GetInstance().materialsTips(type_id)
							return
						}
					}
					model.Fire(GodCourtModel.SEND_SCMD, 23304, "ic", this.godCourtId, selectPos)
					this.is_up = true
				}
			}, this, true)

			this.BindEvent(local_goodsIns, GoodsModel.UPDATE_GOODS_NUM, () => {
				if (!this.use_delete_method) {
					this.UpdateMatNum()
				}
			})

			this.BindEvent(model, GodCourtModel.REFRESH_RED, (type?) => {
				if (type == 2) {
					this.redDot.visible = model.upStageRedList[this.godCourtId] && model.upStageRedList[this.godCourtId][selectPos]
				}
			})

			this.BindEvent(model, GodCourtModel.SELECT_STAGE, (pos?) => {
				this.SelectPosFunc(pos)
			})

			this.BindEvent(model, GodCourtModel.UPDATE_GODCOURT, () => {
				let showEquipEffect = true
				let newPos = null
				let showStage = 0
				let i = 0
				do {
					let data = model.GetEquipData(this.godCourtId, i + 1)
					if (data && data.equip_id == 0 && data.pos < 9) {
						showEquipEffect = false
					} else if (data.equip_id != 0 && (!newPos || data.stage < showStage)) {
						newPos = i + 1
						showStage = data.stage
					}
					i = i + 1
				} while ((i < GodCourtModel.PosList.length - 1))
				model.Fire(GodCourtModel.SELECT_STAGE, newPos || 1)
				//this.effectGp0.visible = showEquipEffect
			})

			this.BindEvent(model, GodCourtModel.UPDATE_STAGE, () => {
				this.is_up = false
				//this.AddUIEffect("UI_1102_shengjiechenggong", "Top", this.stageEffectGp)
			})

			//local_resMgr:SetOutsideImageSprite(this, this.bg0, GameResPath.GetIcon("soul","uisy_023"),true)

			//this.AddUIEffect("UI_1608", "Activity", this.effectGp0, null, null, true)
			//this:AddUIEffect("ui_Shenting_runeUI2_wenli", this.effectGp1, null, null, true)
			//this:AddUIEffect("ui_Shenting_runeUI2_wenli", this.effectGp2, null, null, true)
		}

		this.SelectPosFunc = (pos?) => {
			let stageCfg = Config.PRELOAD_SERVER_CONFIG.config_god_court_equip_stage
			let curStage = model.GetStage(this.godCourtId, pos)
			if (stageCfg) {
				let curCfg = stageCfg[curStage]
				let curAttr = curCfg && JSON.parse(curCfg.attr) || {}
				let nextCfg = stageCfg[curStage + 1]
				let nextAttr = nextCfg && JSON.parse(nextCfg.attr) || {}
				this.SetProp(curAttr, nextAttr, pos)
				let mat = curCfg && JSON.parse(curCfg.cost) || {}
				this.matInfo = mat[0]
				this.UpdateMatNum()
			}
			selectPos = pos
		}

		this.SetProp = (curAttr?, nextAttr?, pos?) => {
			if (!propList) {
				propList = []
			}
			let next_length = 0
			if(!Util.IsTableEmpty(nextAttr)){
				next_length = nextAttr.length
			}
			let length = Math.max(curAttr.length, next_length)
			let addAttr = curAttr[0] || nextAttr[0]
			let curAdd = 0
			let nextAdd = 0
			if (addAttr && addAttr[0] == '331') {
				curAdd = Number((curAttr[0] && curAttr[0][1]) || 0)
				nextAdd = Number((nextAttr[0] && nextAttr[0][1]) || 0)
			}
			let equipData = model.GetEquipData(this.godCourtId, pos)
			if (equipData && equipData.equip_id) {
				let goodsVo = local_goodsIns.GetGoodsVoByGoodsId(equipData.equip_id)
				if (goodsVo) {
					let equipCfg = Config.PRELOAD_SERVER_CONFIG.config_god_court_equip
					if (equipCfg) {
						let curCfg = equipCfg[goodsVo.type_id]
						if (curCfg) {
							let attr = JSON.parse(curCfg.base_attr)
							let i = attr.length - 1
							let index = 0
							do {
								let nowAttr = attr[i]
								table.unshift(curAttr, [nowAttr[0], Math.floor(nowAttr[1] * (1 + curAdd / 10000))])
								if (nextAdd <= 0) {
									//table.unshift(nextAttr, [])
									//nextAttr[index] = []
								} else {
									table.unshift(nextAttr, [nowAttr[0], Math.floor(nowAttr[1] * (1 + nextAdd / 10000))])
								}
								length = length + 1
								i = i - 1
								index = index + 1
							} while ((i >= 0))
						}
					}
				}
			}

			let i = 0
			do {
				let item = propList[i]
				if (!item) {
					item = new GodCourtStagePropItem(this.Content)
					item.Load()
					propList[i] = item
				}
				item.SetData(curAttr[i], nextAttr[i])
				i = i + 1
			} while ((i < length))
		}

		this.UpdateMatNum = () => {
			if (this.matInfo && matItem) {
				let [type_id, bind] = local_goodsIns.GetMappingTypeId(this.matInfo[0], this.matInfo[1])
				matItem.SetData(type_id)
				let nowNum = local_goodsIns.GetTypeGoodsNum(type_id)
				this.matLb.color = nowNum >= Number(this.matInfo[2]) && "#00fa64" || "#ff4f50"
				this.matLb.text = nowNum + "/" + this.matInfo[2]
				this.matGp.visible = true
				this.showLb.visible = true
				this._lb_btn.text = "升阶"
				if(this._btn_up.x != 510){
					this._btn_up.x = 510
				}

				//SetImageGray(this.upBtn, false)

				this.redDot.visible = nowNum >= Number(this.matInfo[2])
			} else {
				this._lb_btn.text = "已满阶"
				this._btn_up.x = 325
				//SetImageGray(this.upBtn, true)
				this.matGp.visible = false
				this.showLb.visible = false
				this.redDot.visible = false
			}
		}

		this.DesFunc = () => {
			this.is_up = false
			if (itemList) {
				for (let _tmpi in itemList) {
					let vo = itemList[_tmpi]
					vo.DeleteMe()
				}
				itemList = null
			}
			if (propList) {
				for (let _tmpi in propList) {
					let vo = propList[_tmpi]
					vo.DeleteMe()
				}
				propList = null
			}
			if (matItem) {
				matItem.DeleteMe()
				matItem = null
			}
		}
	}

	bg0: Laya.Image
	bg1: Laya.Image
	bg2: Laya.Image
	_btn_close: Laya.Image
	_img_title1: Laya.Image
	_lb_title1: Laya.Label
	_img_title2: Laya.Image
	_lb_title2: Laya.Label
	_btn_up: Laya.Box
	_img_btn: Laya.Image
	_lb_btn: Laya.Label
	redDot: Laya.Image
	showLb: Laya.Label
	matGp: Laya.Box
	_gp_mat: Laya.Box
	matLb: Laya.Label
	_Scroller1: Laya.Panel
	Content: Laya.VBox
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
	public GetComponents() {
		[
			this.bg0,
			this.bg1,
			this.bg2,
			this._btn_close,
			this._img_title1,
			this._lb_title1,
			this._img_title2,
			this._lb_title2,
			this._btn_up,
			this._img_btn,
			this._lb_btn,
			this.redDot,
			this.showLb,
			this.matGp,
			this._gp_mat,
			this.matLb,
			this._Scroller1,
			this.Content,
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
		]
			= this.GetChildrenByNames([

				"bg0",
				"bg1",
				"bg2",
				"_btn_close",
				"_img_title1",
				"_lb_title1",
				"_img_title2",
				"_lb_title2",
				"_btn_up",
				"_img_btn",
				"_lb_btn",
				"redDot",
				"showLb",
				"matGp",
				"_gp_mat",
				"matLb",
				"_Scroller1",
				"Content",
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
			])
	}
}
window["GodCourtStageView"] = GodCourtStageView
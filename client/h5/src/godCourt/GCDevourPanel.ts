import { BaseItem1 } from "../common/BaseItem1"
import { table } from "../common/table"
import { Util } from "../util/Util"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { ColorUtil } from "../util/ColorUtil"
import { GoodsModel } from "../commonModel/GoodsModel"
import { DownDropBtn } from "../common/DownDropBtn"
import { Message } from "../sysInfo/SysInfoController"
import { Alert, Alert_Type } from "../alert/Alert"
import { GodCourtModel } from "../commonModel/GodCourtModel"
import { LoopScrowViewMgr, LoopScrCon } from "../common/LoopScrowViewMgr"
import { GCDevourItem } from "./GCDevourItem"

export class GCDevourPanel extends BaseItem1 {
	ChangeColor
	DeleteMe1
	InitEvent
	InitView
	UpdateBag

	dropBtn
	godCourtId

	public constructor(parent?) {
		super(parent)
		this.base_file = "godCourt"
		this.layout_file = "GCDevourPanel"

		let local_goodsIns = GoodsModel.GetInstance()
		let model = GodCourtModel.GetInstance()

		let haveMat = 0
		let devourMat = 0
		let bagArr = null

		this.load_callback = () => {
			this._Scroller1.vScrollBarSkin = ""
			this._lb_num.style.fontSize = 20
			this._lb_num.style.color = "#663915"
			this._lb_num.style.wordWrap = false
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_line, GameResPath.GetIcon("common2", "com_line_5"))

			this.InitView()
			this.InitEvent()
		}

		this.InitView = () => {
			this.dropBtn = new DownDropBtn(this.dropBtnGp)
			let ClickColor = (index?, data?) => {
				if (data) {
					model.showDevour = data.cond
					this.ChangeColor()
				}
			}

			haveMat = local_goodsIns.GetSpecialScore(model.devoureMatId)
			let colorList = []
			let defaultText = "任意品质"
			table.insert(colorList, { id: 0, content: "任意品质", cond: 0 })
			let i = 0
			do {
				let color = i + 3
				table.insert(colorList, { id: i, content: ColorUtil.GetColorName(color) + "以下", cond: color })
				i = i + 1
			} while ((i < 3))
			for (let key in colorList) {
				let vo = colorList[key]
				if (vo.cond == model.showDevour) {
					defaultText = vo.content
					break
				}
			}
			this.dropBtn.Init(colorList, ClickColor, defaultText, "content", "Activity", null, false, false)
			this.dropBtn.Load()
			let [type_id, bind] = local_goodsIns.GetMappingTypeId(255, model.devoureMatId)
			let goodsBasic = local_goodsIns.GetGoodsBasicByTypeId(type_id)
			this.UpdateBag()
			this.ChangeColor()
			if (goodsBasic) {
				ResManager.GetInstance().SetOutsideImageSprite(this, this._img_mat, GameResPath.GetGoodsIconPath(goodsBasic.goods_icon))
			}

			//lua_resM:SetOutsideImageSprite(this,this._Image2,GameResPath.GetIcon(""))
		}

		this.InitEvent = () => {
			this.BindEvent(local_goodsIns, GoodsModel.CHANGE_GODCOURT_BAG, () => {
				if (!this.use_delete_method) {
					this.UpdateBag()
				}
			}
			)
			this.BindEvent(local_goodsIns, GoodsModel.CHANGE_GODCOURT, () => {
				if (!this.use_delete_method) {
					this.UpdateBag()
				}
			}
			)
			this.BindVar(model, "devourPoint", () => {
				this._lb_num.innerHTML = Util.StrToHTML(haveMat + " <font color='#0a953e'>+" + model.devourPoint + "</font>")
			}
			)
			Util.AddClickEvent(this._btn_devour, () => {
				if (!Util.IsTableEmpty(model.devourSelect)) {
					let devFunc = () => {
						model.Fire(GodCourtModel.DEVOUR_EFFECT)
						setTimeout(() => {
							model.Fire(GodCourtModel.DEVOUR)
						}
							, 0.75)
					}

					let showTips = null
					if (model.showDevourTips) {
						for (let key in model.devourSelect) {

							let goodsVo = local_goodsIns.GetGoodsVoByGoodsId(key)
							if (goodsVo && goodsVo.subtype != 17) {
								showTips = true
								break
							}
						}
					}
					let checkFunc = (boolean?) => {
						model.showDevourTips = !boolean
					}

					if (showTips) {
						Alert.Show("当前选中包含纹章装备，是否继续分解？\n（解锁新的神社可穿戴纹章）", Alert_Type.AlertTypeCheckBox, devFunc, null, null, null, null, null, checkFunc)
					} else {
						devFunc()
					}
				} else {
					Message.show("当前未选择装备")
				}
			}
				, this, true)
			this.BindEvent(local_goodsIns, GoodsModel.GOODS_DECOMPOSE_SUCCESS, () => {
				model.ClearDevourSelect()
				this.ChangeColor()
			}
			)
			this.BindEvent(local_goodsIns, GoodsModel.UPDATE_SPECIAL_SCORE, (vo?) => {
				if (vo.currency_id == model.devoureMatId) {
					haveMat = local_goodsIns.GetSpecialScore(model.devoureMatId)
					this._lb_num.innerHTML = Util.StrToHTML(haveMat + " <font color='#0a953e'>+" + model.devourPoint + "</font>")
				}
			})
		}

		this.UpdateBag = () => {
			let showList = model.CreateDevourBagList(this.godCourtId)
			if (!bagArr) {
				bagArr = new LoopScrowViewMgr()
				bagArr.SetData(this._Scroller1, GCDevourItem, showList, LoopScrCon.Vertical, 6)
			} else {
				bagArr.replaceAll(showList)
			}
			this.nothingLb.visible = showList.length == 0
		}

		this.ChangeColor = () => {
			model.ChangeDevourColor()
			model.Fire(GodCourtModel.UPDATE_DEVOUR_COLOR)
			this._lb_num.innerHTML = Util.StrToHTML(haveMat + " <font color='#0a953e'>+" + model.devourPoint + "</font>")
		}

		this.DeleteMe1 = () => {
			if (this.dropBtn) {
				this.dropBtn.DeleteMe()
				this.dropBtn = null
			}
			if (bagArr) {
				bagArr.DeleteMe()
				bagArr = null
			}
		}
	}

	public DeleteMe() {
		this.DeleteMe1()
		super.DeleteMe()
	}

	public SetId(godCourtId?) {
		this.godCourtId = godCourtId
	}

	_img_bg: Laya.Image
	_btn_devour: Laya.Box
	_img_btn: Laya.Image
	_lb_btn: Laya.Label
	_Scroller1: Laya.List
	_img_mat: Laya.Image
	_img_line: Laya.Image
	_lb_tips: Laya.Label
	_lb_num: Laya.HTMLDivElement
	nothingLb: Laya.Label
	dropBtnGp: Laya.Box
	public GetComponents() {
		[
			this._img_bg,
			this._btn_devour,
			this._img_btn,
			this._lb_btn,
			this._Scroller1,
			this._img_mat,
			this._img_line,
			this._lb_tips,
			this._lb_num,
			this.nothingLb,
			this.dropBtnGp,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_btn_devour",
				"_img_btn",
				"_lb_btn",
				"_Scroller1",
				"_img_mat",
				"_img_line",
				"_lb_tips",
				"_lb_num",
				"nothingLb",
				"dropBtnGp",
			])
	}
}
window["GCDevourPanel"] = GCDevourPanel
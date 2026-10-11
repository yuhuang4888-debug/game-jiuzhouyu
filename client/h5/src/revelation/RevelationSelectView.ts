import { BaseView1 } from "../common/BaseView1"
import { Util } from "../util/Util"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { RedDotManager, ModuleType } from "../common/RedDotManager"
import { ResManager } from "../common/ResManager"
import { RevelationModel, RevelationEvent } from "../commonModel/RevelationModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { RevelationSelectItem } from "./RevelationSelectItem"

export class RevelationSelectView extends BaseView1 {
	res_mgr

	InitEvent
	InitView
	Open
	UpdateSelect

	public constructor() {
		super()
		this.base_file = "revelation"
		this.layout_file = "RevelationSelectView"
		this.layer_value = Enum_UILayer.Activity
		this.is_center = true
		this.use_background = true
		this.click_bg_toClose = true
		this.destroy_imm = true

		this.res_mgr = ResManager.GetInstance()

		let model = RevelationModel.GetInstance()
		let local_gModel = GoodsModel.GetInstance()
		let local_redMgr = RedDotManager.GetInstance()
		let local_event = RevelationEvent
		let itemArr_ = null
		let posId_ = null

		this.load_callback = () => {
			/*
			if (PlatformMgr.GetInstance().IsEyouEnPlatform()) {
				this.nothingImg.size = 18
				let csf = this.nothingImg.GetComponent("ContentSizeFitter")
				csf.horizontalFit = UnityEngine.UI.ContentSizeFitter.FitMode.Unconstrained
				csf.verticalFit = UnityEngine.UI.ContentSizeFitter.FitMode.Unconstrained
				SetSizeDelta(this.nothingImg, 370, 80)
				this.expLb.size = 22
			}
			*/
			this.InitView()
			this.InitEvent()
		}

		this.destroy_callback = () => {
			model.ReSetDevour()
			this.ClearUIEffect(this.gp_effect)
			if (itemArr_) {
				itemArr_.DeleteMe()
				itemArr_ = null
			}
		}

		this.Open = (...new_args) => {
			if (new_args) {
				posId_ = new_args
			}
			model.ReSetDevour()
			this.InitView()
			super.Open()
		}

		this.InitView = () => {
			if (posId_ && this.is_loaded) {
				let MatList = local_gModel.revelation_type_dic[posId_]
				if (MatList) {
					for (let _tmpi in MatList) {
						let vo = MatList[_tmpi]
						model.SelectList[vo.goods_id] = true
					}
				}
				let show = !MatList || MatList.length == 0
				this.img_nothing.visible = show
				this.lb_nothing.visible = show

				if (!itemArr_) {
					itemArr_ = new LoopScrowViewMgr()
					itemArr_.SetData(this.gp_items, RevelationSelectItem, MatList || {}, LoopScrCon.Vertical)
				}

				this.UpdateSelect()
			}
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this.btn_close, () => {
				this.Close()
			}, this, true)

			Util.AddClickEvent(this.btn_dev, () => {
				model.Fire(local_event.DEVOUR_EQUIP, posId_, model.SelectList)
			}, this, true)

			this.BindEvent(model, local_event.SELECT_DEVOUR_MAT, (goods_id?, select?) => {
				this.UpdateSelect(goods_id, select)
			})

			this.BindEvent(local_gModel, GoodsModel.CHANGE_REVE_BAG_LIST, () => {
				let list = local_gModel.revelation_type_dic[posId_]
				itemArr_.replaceAll(list || {})
				let show = !list || list.length == 0
				this.img_nothing.visible = show
				this.lb_nothing.visible = show
				this.UpdateSelect()
			})

			this.BindEvent(model, local_event.EQUIP_DEVOUR_SUCCESS, () => {
				model.ReSetDevour()
				//this:AddUIEffect("ui_tunshichenggong_glow", this.effectGp)
			})

			this.BindEvent(model, local_event.UPDATE_DEVOUR_RED, () => {
				this.img_redDev.visible = local_redMgr.CheckRedStatus(ModuleType.REVE_DEVOUR_RED, posId_)
			})

			this.img_redDev.visible = local_redMgr.CheckRedStatus(ModuleType.REVE_DEVOUR_RED, posId_)
		}

		this.UpdateSelect = (goods_id?, select?) => {
			let devourExpCfg = this.res_mgr.GetGameConfigFromCache(this, "config_revelation_equip_swallow", false)
			if (devourExpCfg) {
				if (goods_id) {
					let goodsVo = local_gModel.revelation_bag_dic[goods_id]
					if (goodsVo) {
						let curExp = Number(devourExpCfg[goodsVo.type_id] && (devourExpCfg[goodsVo.type_id].exp * goodsVo.goods_num) || 0)
						model.SelectExp = model.SelectExp + (select && curExp || -curExp)
					}
				} else {
					model.SelectExp = 0
					for (let key in model.SelectList) {
						let goodsVo = local_gModel.revelation_bag_dic[key]
						if (goodsVo) {
							let curCfg = devourExpCfg[goodsVo.type_id]
							if (curCfg) {
								model.SelectExp = model.SelectExp + (curCfg && (curCfg.exp * goodsVo.goods_num) || (0))
							}
						}
					}
				}
				if (itemArr_.data_list.length == 0) {
					this.lb_exp.text = "没有同部位的装备可吞噬"
				} else {
					this.lb_exp.text = "预计增加经验值" + model.SelectExp
				}
			}
		}
	}

	img_bg: Laya.Image
	img_bg2: Laya.Image
	img_title: Laya.Image
	lb_title: Laya.Label
	btn_close: Laya.Image
	gp_items: Laya.List
	lb_nothing: Laya.Label
	img_nothing: Laya.Image
	lb_exp: Laya.Label
	btn_dev: Laya.Image
	img_redDev: Laya.Image
	lb_dev: Laya.Label
	gp_effect: Laya.Box
	public GetComponents() {
		[
			this.img_bg,
			this.img_bg2,
			this.img_title,
			this.lb_title,
			this.btn_close,
			this.gp_items,
			this.lb_nothing,
			this.img_nothing,
			this.lb_exp,
			this.btn_dev,
			this.img_redDev,
			this.lb_dev,
			this.gp_effect,
		]
			= this.GetChildrenByNames([
				"img_bg",
				"img_bg2",
				"img_title",
				"lb_title",
				"btn_close",
				"gp_items",
				"lb_nothing",
				"img_nothing",
				"lb_exp",
				"btn_dev",
				"img_redDev",
				"lb_dev",
				"gp_effect",
			])
	}
}
window["RevelationSelectView"] = RevelationSelectView
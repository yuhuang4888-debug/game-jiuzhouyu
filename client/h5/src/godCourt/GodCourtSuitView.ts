import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { table } from "../common/table"
import { Config } from "../common/Config"
import { Util } from "../util/Util"
import { GodCourtModel } from "../commonModel/GodCourtModel"
import { LoopScrowViewMgr, LoopScrCon } from "../common/LoopScrowViewMgr"
import { GCPreSuitItem } from "./GCPreSuitItem"

export class GodCourtSuitView extends BaseView1 {
	InitView
	Open
	godCourtId
	itemGp

	public constructor() {
		super()
		this.base_file = "godCourt"
		this.layout_file = "GodCourtSuitView"
		this.layer_value = Enum_UILayer.Activity
		this.use_background = true
		this.click_bg_toClose = true
		this.show_open_movie = true
		this.is_center = true
		this.destroy_imm = true

		let suitArr
		let model = GodCourtModel.GetInstance()
		this.load_callback = () => {
			this.InitView()
			Util.AddClickEvent(this.closeBtn, () => {
				this.Close()
			}, this, true)
		}

		this.destroy_callback = () => {
			if (suitArr) {
				suitArr.DeleteMe()
				suitArr = null
			}
		}

		this.InitView = () => {
			let suitCfg = Config.PRELOAD_SERVER_CONFIG.config_god_court_equip_stage
			let suitList = []
			let godCourtData = model.GetData(this.godCourtId)
			let suitActiveList = []
			let suitActive = godCourtData && godCourtData.suit_list
			let maxStage = 1
			if (suitActive) {
				for (let _tmpi in suitActive) {
					let vo = suitActive[_tmpi]
					// suitActiveList[vo.stage] = vo.num
					suitActiveList.push({stage:vo.stage,num:vo.num})
					if (Number(vo.stage) > maxStage) {
						maxStage = vo.stage
					}
				}
			}
			if (suitCfg) {
				for (let key in suitCfg) {
					if (Number(key) != 0) {
						let vo = suitCfg[key]
						//table.insert(suitList, [vo, suitActiveList[vo.stage] || 0])
						table.insert(suitList, [vo, model.IsHasHeight(vo,suitActiveList)])
					}
				}
			}
			table.sort(suitList, (a?, b?) => {
				return a[0].stage < b[0].stage
			})
			if (!suitArr) {
				suitArr = new LoopScrowViewMgr()
				suitArr.SetData(this._Scroller1, GCPreSuitItem, suitList, LoopScrCon.Vertical, 1)
			} else {
				suitArr.replaceAll(suitList)
			}
			this._Scroller1.scrollBar.value = 154 * (maxStage - 1)
		}

		this.Open = (...new_args) => {
			let parms = new_args
			if (parms) {
				this.godCourtId = parms[0]
			}
			super.Open()
		}
	}

	_img_bg: Laya.Image
	_img_bg2: Laya.Image
	closeBtn: Laya.Image
	_img_title: Laya.Image
	lb_title: Laya.Label
	_Scroller1: Laya.List
	public GetComponents() {
		[
			this._img_bg,
			this._img_bg2,
			this.closeBtn,
			this._img_title,
			this.lb_title,
			this._Scroller1,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_img_bg2",
				"closeBtn",
				"_img_title",
				"lb_title",
				"_Scroller1",
			])
	}
}
window["GodCourtSuitView"] = GodCourtSuitView
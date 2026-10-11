import { BaseView1 } from "../common/BaseView1"
import { table } from "../common/table"
import { Util } from "../util/Util"
import { Enum_UILayer } from "../common/LayerManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { StarEquipModel } from "../commonModel/StarEquipModel"
import { LoopScrowViewMgr, LoopScrCon } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { StarComSelectItem } from "./StarComSelectItem"

export class StarEquipComSelectView extends BaseView1 {
	InitView
	Open
	bagGp
	data
	index
	cfg_com

	public constructor() {
		super()
		this.base_file = "starEquip"
		this.layer_value = Enum_UILayer.Activity
		this.layout_file = "StarEquipComSelectView"
		this.is_center = true
		this.use_background = true
		this.click_bg_toClose = true
		let bagArr = null
		this.preload_server_config = {
			"config_constellation_compose": false
		}

		this.load_callback = () => {
			this.cfg_com = ResManager.GetInstance().GetGameConfigFromCache(this, "config_constellation_compose", false)
			
			this._Scroller1.scrollBar.visible = false
			//this.RegisterMask(this.bagGp)
			this.InitView()
		}

		this.close_callback = () => {
			if (bagArr) {
				bagArr.DeleteMe()
				bagArr = null
			}
		}

		this.InitView = () => {
			if (this.data && this.is_loaded) {
				let list = GoodsModel.GetInstance().starEquipBagList

				let showList = []
				for (let _tmpi in list) {
					var vo = list[_tmpi]
					if (this.data[vo.type_id]) {
						vo.comIndex = this.index
						table.insert(showList, vo)
					}
				}

				if (!bagArr) {
					bagArr = new LoopScrowViewMgr()
					bagArr.SetData(this._Scroller1, StarComSelectItem, showList, LoopScrCon.Vertical, 5)
				} else {
					bagArr.replaceAll(showList)
				}

				let ruleId = StarEquipModel.GetInstance().curComRule
				if (ruleId) {
					let ruleCfg = this.cfg_com[ruleId - 1] //lua_resM:GetGameConfigFromCache(this, "config_constellation_compose", false)
					if (ruleCfg) {
						//this.needLb.text = Util.StrToHTML("需放入任意品质的<font color='#4ba800'>" + ruleCfg.name + "</font>")
						this.needLb.text = "需放入任意品质的" + ruleCfg.name
					}
				}

				Util.AddClickEvent(this.closeBtn, () => {
					this.Close()
				}, this, true)
			}
		}

		this.Open = (...new_args) => {
			let parms = new_args
			if (parms[0]) {
				let list = []
				for (let _tmpi in parms[0]) {
					var vo = parms[0][_tmpi]
					list[Number(vo)] = true
				}
				this.data = list
				this.index = parms[1]
			}
			super.Open()
		}
	}
	
	_Image1: Laya.Image
	_Image2: Laya.Image
	tips_label: Laya.Label
	_Scroller1: Laya.List
	closeBtn: Laya.Image
	needLb: Laya.Label
	_Image3: Laya.Image
	_lb_title: Laya.Label
	public GetComponents() {
		[
			this._Image1,
			this._Image2,
			this.tips_label,
			this._Scroller1,
			this.closeBtn,
			this.needLb,
			this._Image3,
			this._lb_title,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_Image2",
				"tips_label",
				"_Scroller1",
				"closeBtn",
				"needLb",
				"_Image3",
				"_lb_title",
			])
	}
}
window["StarEquipComSelectView"] = StarEquipComSelectView
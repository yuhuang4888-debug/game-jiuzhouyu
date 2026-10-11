import { BaseView1 } from "../common/BaseView1"
import { table } from "../common/table"
import { Util } from "../util/Util"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrowViewMgr, LoopScrCon } from "../common/LoopScrowViewMgr"
import { chcModel } from "../commonModel/chcModel"
import { chcMagicAddItem } from "./chcMagicAddItem"

export class chcMagicAddView extends BaseView1 {
	InitEvent
	LoadSuccess
	UpdateView
	_ac_item
	_gp_item
	_model
	_pos
	_type
	_stype
	cfg_ench_master

	public constructor() {
		super()
		this._type = chcModel.CHCTYPE.MAGIC
		this.base_file = "chc"
		this.layout_file = "chcMagicAddView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.use_background = true
		this.click_bg_toClose = true
		this.is_center = true
		this.preload_server_config = {
			"config_constellation_enchantment_master": false
		}

		this._model = chcModel.GetInstance()
		let resMgr = ResManager.GetInstance()

		this.load_callback = () => {
			this.cfg_ench_master = resMgr.GetGameConfigFromCache(this, "config_constellation_enchantment_master", false)
			this.InitEvent()
			this.LoadSuccess()
		}

		this.destroy_callback = () => {
			if (this._ac_item) {
				this._ac_item.DeleteMe()
				this._ac_item = null
			}
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._btn_close, () => {
				this.Close()
			}, this, true)
		}

		this.LoadSuccess = () => {
			//resMgr.SetOutsideImageSprite(this, this._img_016, GameResPath.GetIcon("chc", "uity_016bb"))
			//resMgr.SetOutsideImageSprite(this, this._Image3, GameResPath.GetIcon("chc", "uism_061"), true)

			//this._ac_item = eui. new ArrayCollection()
			//this._gp_item.dataProvider = this._ac_item
			//this._gp_item.itemRenderer = chcMagicAddItem

			this.UpdateView()
		}

		this.UpdateView = () => {
			let scfg = this.cfg_ench_master
			let list = []
			for (let key in scfg) {
				let data = scfg[key]
				if (data.equip_type == this._stype) {
					let attr_list = JSON.parse(data.attr)
					for (let _tmpi in attr_list) {
						var vo = attr_list[_tmpi]
						if (Number(vo[0]) == chcModel.MAGIC_RATIO_ATTR_ID) {
							table.insert(list, { lv: data.lv, stype: this._stype, vo: vo })
						}
					}
				}
			}
			table.sort(list, (a?, b?) => {
				return a.lv < b.lv
			})
			if (!this._ac_item) {
				this._ac_item = new LoopScrowViewMgr()
				this._ac_item.SetData(this._Scroller1, chcMagicAddItem, list, LoopScrCon.Vertical)
			}
			//this._ac_item.source = list
		}
	}

	public Open(...new_args) {
		this._stype = new_args[0]
		this._pos = new_args[1]
		super.Open()
	}

	_Image1: Laya.Image
	_Image2: Laya.Image
	_Label1: Laya.Label
	_Image3: Laya.Image
	_lb_title: Laya.Label
	_Scroller1: Laya.List
	_btn_close: Laya.Image
	public GetComponents() {
		[
			this._Image1,
			this._Image2,
			this._Label1,
			this._Image3,
			this._lb_title,
			this._Scroller1,
			this._btn_close,
		]
			= this.GetChildrenByNames([
				"_Image1",
				"_Image2",
				"_Label1",
				"_Image3",
				"_lb_title",
				"_Scroller1",
				"_btn_close",
			])
	}
}
window["chcMagicAddView"] = chcMagicAddView
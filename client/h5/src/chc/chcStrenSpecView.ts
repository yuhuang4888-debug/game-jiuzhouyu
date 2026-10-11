import { BaseView1 } from "../common/BaseView1"
import { table } from "../common/table"
import { Util, Trim } from "../util/Util"
import { LoopScrowViewMgr, LoopScrCon } from "../common/LoopScrowViewMgr"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { chcModel } from "../commonModel/chcModel"
import { chcStrenSpecItem } from "./chcStrenSpecItem"

export class chcStrenSpecView extends BaseView1 {
	InitEvent
	LoadSuccess
	UpdateView

	_ac_item
	_gp_item
	_model
	_pos
	_type
	_stype
	cfg_strength

	public constructor() {
		super()
		this._type = chcModel.CHCTYPE.STREN
		this.base_file = "chc"
		this.layout_file = "chcMagicAddView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.use_background = true
		this.click_bg_toClose = true
		this.is_center = true
		this.preload_server_config = {
			"config_constellation_strength": false
		}

		this._model = chcModel.GetInstance()
		let resMgr = ResManager.GetInstance()

		this.load_callback = () => {
			this.cfg_strength = resMgr.GetGameConfigFromCache(this, "config_constellation_strength", false)
			this._Scroller1.scrollBar.visible = false
			this.InitEvent()
			this.LoadSuccess()
		}

		this.InitEvent = () => {
			// Util.AddClickEvent(this._btn_close, () => {
			// 	this.Close()
			// }, this, true)
		}

		this.LoadSuccess = () => {
			this._lb_title.text = "强化等级加成效果"
			this.UpdateView()
		}

		this.UpdateView = () => {
			let scfg = this.cfg_strength
			let list = []
			//let lv = 0
			//let skey = this._stype + "@" + this._pos + "@" + lv
			// [ts2lua]scfg下标访问可能不正确
			//let data = scfg[skey]
			//while ((data)
			//) {
			//if (data.special_attr != "[]" ) {
			//table.insert(list, {vo=data, stype=this._stype})
			//}
			//lv=lv+1
			//// [ts2lua]scfg下标访问可能不正确
			//data = scfg[skey + lv]
			//}
			//this._ac_item.source = list
			//}

			for (let i = 0; i <= 50; i++) {
				let cfg = scfg[this._stype + "@" + this._pos + "@" + i]
				if (cfg) {
					if (Trim(cfg.special_attr) != "[]") {
						table.insert(list, { vo:cfg, stype:this._stype })
					}
				} else {
					break
				}
			}

			if (!this._ac_item) {
				this._ac_item = new LoopScrowViewMgr()
				this._ac_item.SetData(this._Scroller1, chcStrenSpecItem, list, this._Scroller1)
			}
		}
	}
	public Open(...new_args) {
		this._stype = new_args[0]
		this._pos = new_args[1]
		super.Open()
	}

	public DeleteMe() {
		if (this._ac_item) {
			this._ac_item.DeleteMe()
			this._ac_item = null
		}
		super.DeleteMe()
	}

	_Image1: Laya.Image
	_Image2: Laya.Image
	_Label1: Laya.Label
	_Image3: Laya.Image
	_lb_title: Laya.Label
	_Scroller1: Laya.List
	public GetComponents() {
		[
			this._Image1,
			this._Image2,
			this._Label1,
			this._Image3,
			this._lb_title,
			this._Scroller1,
		]
			= this.GetChildrenByNames([
				"_Image1",
				"_Image2",
				"_Label1",
				"_Image3",
				"_lb_title",
				"_Scroller1",
			])
	}
}
window["chcStrenSpecView"] = chcStrenSpecView
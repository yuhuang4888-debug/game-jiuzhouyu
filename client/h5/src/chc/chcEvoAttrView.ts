import { BaseView1 } from "../common/BaseView1"
import { table } from "../common/table"
import { Util } from "../util/Util"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrowViewMgr, LoopScrCon } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { RoleManager } from "../commonModel/RoleManager"
import { chcModel } from "../commonModel/chcModel"
import { StarEquipModel } from "../commonModel/StarEquipModel"
import { chcEvoAttrItem } from "./chcEvoAttrItem"

export class chcEvoAttrView extends BaseView1 {
	InitEvent
	LoadSuccess
	UpdateView
	_ac_item
	_goods_vo
	_gp_item
	_model
	_type
	cfg_equip
	cfg_evolu_pool

	public constructor() {
		super()
		this.base_file = "chc"
		this.layout_file = "chcEvoAttrView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.use_background = true
		this.click_bg_toClose = true
		this.is_center = true
		this.preload_server_config = {
			"config_constellation_equip": false,
			"config_constellation_evolution_pool": false
		}

		this._type = chcModel.CHCTYPE.EVO
		this._model = chcModel.GetInstance()
		let resMgr = ResManager.GetInstance()

		this.load_callback = () => {
			this.cfg_equip = resMgr.GetGameConfigFromCache(this, "config_constellation_equip", false)
			this.cfg_evolu_pool = resMgr.GetGameConfigFromCache(this, "config_constellation_evolution_pool", false)

			this.InitEvent()
			this.LoadSuccess()
		}

		//this.preload_server_config = [config_constellation_evolution_pool=false, config_constellation_equip=false]
		this.InitEvent = () => {
			Util.AddClickEvent(this._btn_close, () => {
				this.Close()
			}
				, this, true)

			this.BindEvent(StarEquipModel.GetInstance(), StarEquipModel.PREVIEW_TOOLTIPS, (scmd?) => {
				this.UpdateView(scmd.star_attr_cfg)
			}
			)
		}

		this.LoadSuccess = () => {
			StarEquipModel.GetInstance().Fire(StarEquipModel.SEND_PROTO, 23250, "ll", RoleManager.GetInstance().GetMainRoleId(), this._goods_vo.goods_id)
		}

		this.UpdateView = (attr_list?) => {
			let vo = this._goods_vo
			//resMgr:GetGameConfigFromCache(this, "config_constellation_equip", false)
			//let pcfg = Config.Constellationevolutionpool //resMgr:GetGameConfigFromCache(this, "config_constellation_evolution_pool", false)
			let stype = this.cfg_equip[vo.type_id].page
			if (!stype) {
				return
			}
			let cfg = this.cfg_evolu_pool[stype + "@" + vo.cell]
			if (!cfg) {
				return
			}
			let dic = []
			for (let _tmpi in attr_list) {
				let vo = attr_list[_tmpi]
				// [ts2lua]dic下标访问可能不正确
				dic[vo.attr_id] = vo
			}

			let list = []
			for (let key in dic) {

				let data = dic[key]
				let vo
				if (data.plus_interval && data.plus_interval != 0) {
					vo = [data.attr_id, data.attr_val, data.type_id, data.color, data.plus_interval, data.plus_unit]
				} else {
					vo = [data.attr_id, data.attr_val, data.type_id]
				}
				table.insert(list, { vo: vo, is_get: true })
			}
			table.sort(list, (a?, b?) => {
				return Number(a.vo[3]) > Number(b.vo[3])
			})
			let list2 = []
			let plist = JSON.parse(cfg.attr_pool)
			for (let _tmpi in plist) {
				let vo = plist[_tmpi]
				if (!dic[Number(vo[1])]) {
					table.insert(list2, { vo: vo, is_get: false })
				}
			}
			table.sort(list2, (a?, b?) => {
				return Number(a.vo[4]) > Number(b.vo[4])
			})
			for (let i = 1; i <= list2.length; i++) {
				table.insert(list, list2[i])
			}
			if (!this._ac_item) {
				this._ac_item = new LoopScrowViewMgr()
				this._ac_item.SetData(this._Scroller1, chcEvoAttrItem, list, LoopScrCon.Vertical)
			} else {
				this._ac_item.replaceAll(list)
			}
		}
	}

	public Open(...new_args) {
		this._goods_vo = new_args[0]
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
	_Image3: Laya.Image
	_btn_close: Laya.Image
	_Image4: Laya.Image
	_Scroller1: Laya.List
	public GetComponents() {
		[
			this._Image1,
			this._Image2,
			this._Image3,
			this._btn_close,
			this._Image4,
			this._Scroller1,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_Image2",
				"_Image3",
				"_btn_close",
				"_Image4",
				"_Scroller1",
			])
	}
}
window["chcEvoAttrView"] = chcEvoAttrView
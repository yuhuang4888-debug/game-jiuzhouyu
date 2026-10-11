import { BaseView1 } from "../common/BaseView1"
import { table } from "../common/table"
import { Util } from "../util/Util"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { RedDotManager } from "../common/RedDotManager"
import { LoopScrowViewMgr, LoopScrCon } from "../common/LoopScrowViewMgr"
import { chcModel } from "../commonModel/chcModel"
import { chcMasterIcon } from "./chcMasterIcon"
import { chcMasterItem } from "./chcMasterItem"

export class chcMasterView extends BaseView1 {
	InitEvent
	LoadSuccess
	UpdateIcon
	UpdateItem
	UpdateRed
	_ac_icon
	_ac_item
	_gp_icon
	_gp_item
	_is_max
	_mcfg_name
	_model
	_stype
	_type

	cfg_pos
	cfg_strength_master
	cfg_ench_master

	public constructor() {
		super()
		this.base_file = "chc"
		this.layout_file = "chcMasterView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.use_background = true
		this.click_bg_toClose = true
		this.is_center = true
		this.preload_server_config = {
			"config_constellation_pos": false,
			"config_constellation_strength_master": false,
			"config_constellation_enchantment_master": false
		}

		this._is_max = false
		this._model = chcModel.GetInstance()
		this.load_callback = () => {
			this.cfg_pos = ResManager.GetInstance().GetGameConfigFromCache(this, "config_constellation_pos", false)
			this.cfg_strength_master = ResManager.GetInstance().GetGameConfigFromCache(this, "config_constellation_strength_master", false)
			this.cfg_ench_master = ResManager.GetInstance().GetGameConfigFromCache(this, "config_constellation_enchantment_master", false)

			this.InitEvent()
			this.LoadSuccess()
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._btn_close, () => {
				this.Close()
			}
				, this, true)
			Util.AddClickEvent(this._btn_go, () => {
				if (this._is_max) {

				} else {
					if (this._type == chcModel.CHCTYPE.STREN) {
						this._model.Fire(chcModel.REQUEST_PROTO, 23213, "c", this._stype)
					} else if (this._type == chcModel.CHCTYPE.MAGIC) {
						this._model.Fire(chcModel.REQUEST_PROTO, 23233, "c", this._stype)
					}
				}
			}
				, this, true)
			this.BindEvent(this._model, chcModel.UPDATE_MASTER, (type?, stype?, data?) => {
				if (this._type != type) {
					return
				}
				if (this._stype != stype) {
					return
				}
				this.UpdateItem()
				this.UpdateRed()
			}
			)
			this.BindEvent(this._model, chcModel.MASTER_RESULT, (type?, data?) => {
				if (this._type != type) {
					return
				}
				//this:AddUIEffect("ui_constellation_dianliang", this._gp_eff)
			}
			)
		}

		this.LoadSuccess = () => {
			//this._ac_icon = eui. new ArrayCollection()
			//this._gp_icon.dataProvider = this._ac_icon
			//this._gp_icon.itemRenderer = chcMasterIcon
			//this._ac_item = eui. new ArrayCollection()
			//this._gp_item.dataProvider = this._ac_item
			//this._gp_item.itemRenderer = chcMasterItem

			this.UpdateIcon()
			this.UpdateItem()
			this.UpdateRed()
			let name = ""
			if (this._type == chcModel.CHCTYPE.STREN) {
				name = "强化大师"
			} else if (this._type == chcModel.CHCTYPE.MAGIC) {
				name = "觉醒大师"
			}
			//this._img_title.source = "chc_asset." + name + ""
			//ResManager.GetInstance().SetImageSprite(this, this._img_title, "chc", name)
			this._lb_title.text = name
			let str = this._model.GetTypeStr(this._type)
			this._lb_tips.text = "满足" + str + "条件可点亮以下属性"
			let info = this._model.GetInfoByStype(this._type, this._stype)

			//let stage = (info && (info.stage) || (-1))
			this._is_max = info && info.is_max == 1
			Util.SetImageGray(this._Image4, this._is_max)
		}

		this.UpdateIcon = () => {
			let pcfg = this.cfg_pos
			let list = this._model.GetNormalPosList(pcfg)
			let info = this._model.GetInfoByStype(this._type, this._stype)
			let dic = []
			if (info) {
				for (let _tmpi in info.equip_list) {
					let vo = info.equip_list[_tmpi]
					dic[vo.pos] = vo
				}
				if (list) {
					for (let _tmpi in list) {
						let vo = list[_tmpi]
						vo["_type"] = this._type
						vo["stage"] = info.stage
						vo["vo"] = dic[vo.pos]
					}
				}
			}
			table.sort(list, (a?, b?) => {
				if (a && a.vo && b && b.vo) {
					return a.vo.pos < b.vo.pos
				}
			})

			if (!this._ac_icon) {
				this._ac_icon = new LoopScrowViewMgr()
				this._ac_icon.SetData(this._Scroller1, chcMasterIcon, list, LoopScrCon.Horizontal)
			} else {
				this._ac_icon.replaceAll(list)
			}
		}

		this.UpdateItem = () => {
			let mcfg //= resMgr.GetGameConfigFromCache(this, this._mcfg_name, false)
			if (this._type == chcModel.CHCTYPE.STREN) {
				mcfg = this.cfg_strength_master
			} else if (this._type == chcModel.CHCTYPE.MAGIC) {
				mcfg = this.cfg_ench_master
			}
			let minfo = this._model.GetMasterByStype(this._type, this._stype)
			let dic = []
			if (minfo) {
				for (let _tmpi in minfo.master_list) {
					let vo = minfo.master_list[_tmpi]
					dic[vo.master_lv] = vo
				}
			}
			let list = []
			for (let key in mcfg) {
				let data = mcfg[key]
				if (data.equip_type == this._stype) {
					data["_type"] = this._type
					data["vo"] = dic[data.lv]
					table.insert(list, mcfg[key])
				}
			}

			table.sort(list, (a?, b?) => {
				return a.lv < b.lv
			})

			if (!this._ac_item) {
				this._ac_item = new LoopScrowViewMgr()
				this._ac_item.SetData(this._Scroller2, chcMasterItem, list, LoopScrCon.Vertical)
			} else {
				this._ac_item.replaceAll(list)
			}
		}

		this.UpdateRed = () => {
			let rtype = this._model.GetReddotTypeMaster(this._type)
			let bool = RedDotManager.GetInstance().CheckAnyRedStatus(rtype, this._stype)
			this._reddot.visible = bool
		}
	}

	public Open(...new_args) {
		this._type = new_args[0]
		this._stype = new_args[1]
		//let name = null
		//if (this._type == chcModel.CHCTYPE.STREN ) {
		//name = "strength"
		//} else if (this._type == chcModel.CHCTYPE.MAGIC ) {
		//name = "enchantment"
		//}
		//if (name ) {
		//this._mcfg_name = "config_constellation_" + name + "_master"
		//// [ts2lua]this.preload_server_config下标访问可能不正确
		//this.preload_server_config[this._mcfg_name] = false
		//}
		super.Open()
	}

	public DeleteMe() {
		if (this._ac_item) {
			this._ac_item.DeleteMe()
			this._ac_item = null
		}
		if (this._ac_icon) {
			this._ac_icon.DeleteMe()
			this._ac_icon = null
		}
		super.DeleteMe()
	}

	_Image1: Laya.Image
	_Image2: Laya.Image
	_Image3: Laya.Image
	_lb_title: Laya.Label
	_btn_close: Laya.Image
	_lb_tips: Laya.Label
	_Scroller1: Laya.List
	_Scroller2: Laya.List
	_btn_go: Laya.Box
	_Image4: Laya.Image
	_Label1: Laya.Label
	_reddot: Laya.Image
	_gp_eff: Laya.Box
	public GetComponents() {
		[
			this._Image1,
			this._Image2,
			this._Image3,
			this._lb_title,
			this._btn_close,
			this._lb_tips,
			this._Scroller1,
			this._Scroller2,
			this._btn_go,
			this._Image4,
			this._Label1,
			this._reddot,
			this._gp_eff,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_Image2",
				"_Image3",
				"_lb_title",
				"_btn_close",
				"_lb_tips",
				"_Scroller1",
				"_Scroller2",
				"_btn_go",
				"_Image4",
				"_Label1",
				"_reddot",
				"_gp_eff",
			])
	}
}
window["chcMasterView"] = chcMasterView
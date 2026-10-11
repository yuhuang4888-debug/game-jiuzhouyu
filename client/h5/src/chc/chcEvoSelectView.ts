import { BaseView1 } from "../common/BaseView1"
import { table } from "../common/table"
import { Util, HtmlColorTxt } from "../util/Util"
import { Enum_ColorUtil_Dark } from "../util/ColorUtil"
import { LoopScrowViewMgr, LoopScrCon } from "../common/LoopScrowViewMgr"
import { Enum_UILayer } from "../common/LayerManager"
import { Message } from "../sysInfo/SysInfoController"
import { GoodsModel } from "../commonModel/GoodsModel"
import { chcModel } from "../commonModel/chcModel"
import { ResManager } from "../common/ResManager"
import { chcEvoSelectItem } from "./chcEvoSelectItem"

export class chcEvoSelectView extends BaseView1 {
	FireRatioEvent
	GetBagList
	InitEvent
	LoadSuccess
	SelectItemHandle
	UpdateRatio

	_ac_list
	_def_ratio
	_dic
	_equip_cfg
	_ev_point
	_evo_cfg
	_level
	_list
	_model
	_ratio
	_stype
	_type
	_goods_vo

	public constructor() {
		super()
		this.base_file = "chc"
		this.layout_file = "chcEvoSelectView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.use_background = true
		this.click_bg_toClose = true
		this.is_center = true
		this.preload_server_config = {
			"config_constellation_equip": false,
			"config_constellation_evolution": false
		}

		this._type = chcModel.CHCTYPE.EVO
		this._dic = {}
		this._model = chcModel.GetInstance()
		let resMgr = ResManager.GetInstance()

		this.load_callback = () => {
			//this.RegisterMask(this._list)
			this._Scroller1.scrollBar.visible = false
			this._lb_tips.style.fontSize = 22
			this._lb_tips.style.color = "#4a3a32"
			this._lb_tips.style.wordWrap = false
			this._lb_ratio.style.fontSize = 22
			this._lb_ratio.style.color = "#4a3a32"
			this._lb_ratio.style.wordWrap = false
			
			this.InitEvent()
			this.LoadSuccess()
		}

		this.close_callback = () => {
			if (this._ac_list) {
				this._ac_list.DeleteMe()
				this._ac_list = null
			}
			this.FireRatioEvent()
			this._dic = {}
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._btn_close, () => {
				this.Close()
			}
				, this, true)
			Util.AddClickEvent(this._btn_go, () => {
				this.Close()
			}
				, this, true)
			this.BindEvent(this._model, chcModel.SELECT_MTRL, (data?, is_select?) => {
				this.SelectItemHandle(data, is_select)
			}
			)
		}

		this.LoadSuccess = () => {
			this._equip_cfg = resMgr.GetGameConfigFromCache(this, "config_constellation_equip", false)
			this._evo_cfg = resMgr.GetGameConfigFromCache(this, "config_constellation_evolution", false)

			//this._ac_list = eui. new ArrayCollection()
			//this._list.dataProvider = this._ac_list
			//this._list.itemRenderer = chcEvoSelectItem

			this._lb_tips.innerHTML = "放入" + HtmlColorTxt("橙色与红色圣衣可", Enum_ColorUtil_Dark.GREEN) + "增加成功率"
			let vo = this._goods_vo

			let stype = this._equip_cfg[vo.type_id].page
			this._stype = stype
			let edata = this._model.GetDataByPos(this._type, stype, vo.cell)

			this._level = (edata && (edata.lv) || (0))
			let ccfg = this._evo_cfg[stype + "@" + vo.cell + "@" + this._level]
			this._def_ratio = (ccfg && (ccfg.rate) || (0))
			this._ev_point = (ccfg && (ccfg.ev_point) || (0))
			let list = this.GetBagList()

			//this._ac_list.source = list
			if (!this._ac_list) {
				this._ac_list = new LoopScrowViewMgr()
				this._ac_list.SetData(this._Scroller1, chcEvoSelectItem, list, LoopScrCon.Vertical, 4)
				//}else{
			}

			for (let key in this._dic) {
				let vo = this._dic[key]
				let ecfg = this._equip_cfg[vo.type_id]
				this._ratio = this._ratio + ecfg.compose_info / this._ev_point * 10000
			}
			this.UpdateRatio()
		}

		this.SelectItemHandle = (data?, is_select?) => {
			if (this._ev_point <= 0) {
				Message.show("进化已满级")
				return
			}
			if (is_select && this._ratio >= 10000) {
				Message.show("成功率已达100%，无需再放入装备")
				return
			}
			let point = null
			let ecfg = this._equip_cfg[data.type_id]
			if (is_select) {
				this._dic[data.goods_id] = data
				point = ecfg.compose_info
			} else {
				delete this._dic[data.goods_id]
				point = -ecfg.compose_info
			}
			this._ratio = this._ratio + (point / this._ev_point * 10000)
			this._model.Fire(chcModel.SELECT_MTRL_SS, data)
			this.UpdateRatio()
		}

		this.UpdateRatio = () => {
			let len = Util.TableSize(this._dic)
			let cstr = HtmlColorTxt(len + "件", Enum_ColorUtil_Dark.GREEN)
			let other = (10000 - this._def_ratio) / 10000
			let ratio = Math.max(Math.min(10000, this._ratio), 0)
			other = Math.floor(ratio / 100 * other + 0.5)
			let rstr = HtmlColorTxt("+" + other + "%", Enum_ColorUtil_Dark.GREEN)
			this._lb_ratio.innerHTML = "当前已选中" + cstr + "装备，成功率为" + this._def_ratio / 100 + "%" + rstr
		}

		this.GetBagList = () => {
			let bag_list = GoodsModel.GetInstance().starEquipBagList
			let list = []
			for (let _tmpi in bag_list) {
				let vo = bag_list[_tmpi]
				let point = this._equip_cfg[vo.type_id].compose_info
				if (point > 0) {
					table.insert(list, { vo: vo, _is_select: !(!this._dic[vo.goods_id]) })
				}
			}
			return list
		}

		this.FireRatioEvent = () => {
			let other = (10000 - this._def_ratio) / 10000
			let ratio = Math.max(Math.min(10000, this._ratio), 0)
			let all_ratio = ratio * other + this._def_ratio
			this._model.Fire(chcModel.UPDATE_MTRL, this._dic, all_ratio)
		}
	}

	public Open(...new_args) {
		this._goods_vo = new_args[0]
		this._dic = new_args[1]
		this._ratio = 0;
		this._def_ratio = 0;
		this._ev_point = 0;
		super.Open()
	}

	_Image1: Laya.Image
	_Image2: Laya.Image
	_Image3: Laya.Image
	_btn_close: Laya.Image
	_Image4: Laya.Image
	_lb_tips: Laya.HTMLDivElement
	_lb_ratio: Laya.HTMLDivElement
	_btn_go: Laya.Box
	_Image5: Laya.Image
	_Label1: Laya.Label
	_Scroller1: Laya.List
	public GetComponents() {
		[
			this._Image1,
			this._Image2,
			this._Image3,
			this._btn_close,
			this._Image4,
			this._lb_tips,
			this._lb_ratio,
			this._btn_go,
			this._Image5,
			this._Label1,
			this._Scroller1,
		]
			= this.GetChildrenByNames([
				"_Image1",
				"_Image2",
				"_Image3",
				"_btn_close",
				"_Image4",
				"_lb_tips",
				"_lb_ratio",
				"_btn_go",
				"_Image5",
				"_Label1",
				"_Scroller1",
			])
	}
}
window["chcEvoSelectView"] = chcEvoSelectView
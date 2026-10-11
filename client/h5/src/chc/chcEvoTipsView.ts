import { BaseView1 } from "../common/BaseView1"
import { Util } from "../util/Util"
import { Enum_UILayer } from "../common/LayerManager"
import { WordManager } from "../common/WordManager"
import { LoopScrowViewMgr, LoopScrCon } from "../common/LoopScrowViewMgr"
import { TimeUtil } from "../util/TimeUtil"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { RoleManager } from "../commonModel/RoleManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { StarEquipModel } from "../commonModel/StarEquipModel"
import { chcModel } from "../commonModel/chcModel"
import { EquipmentItem } from "../common/EquipmentItem"
import { chcEvoTipsItem } from "./chcEvoTipsItem"

export class chcEvoTipsView extends BaseView1 {
	Clear
	Content
	InitEvent
	LoadSuccess
	Scr_Scroller1
	UpdateAttrTips
	UpdateTimer
	UpdateView

	_ac_item
	_data
	_etime
	_gp_item
	_model
	_show_item
	_type
	cfg_evolu
	cfg_evolu_pool

	public constructor() {
		super()
		this._etime = 0;
		this.base_file = "chc"
		this.layout_file = "chcEvoTipsView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.use_background = true
		this.is_center = true
		this.click_bg_toClose = true
		this.preload_server_config = {
			"config_constellation_evolution": false,
			"config_constellation_evolution_pool": false
		}

		this._type = chcModel.CHCTYPE.EVO
		this._model = chcModel.GetInstance()
		let resMgr = ResManager.GetInstance()
		let goodsModel = GoodsModel.GetInstance()

		this.load_callback = () => {
			this.cfg_evolu = ResManager.GetInstance().GetGameConfigFromCache(this, "config_constellation_evolution", false)
			this.cfg_evolu_pool = ResManager.GetInstance().GetGameConfigFromCache(this, "config_constellation_evolution_pool", false)

			this._Scroller1.scrollBar.visible = false

			this.InitEvent()
			this.LoadSuccess()
		}

		this.destroy_callback = () => {
			this.Clear()
			if (StarEquipModel.waitShowMasterInfo) {
				StarEquipModel.GetInstance().Fire(StarEquipModel.OPEN_VIEW, "StarEquipUpMasterView", StarEquipModel.waitShowMasterInfo)
				StarEquipModel.waitShowMasterInfo = null
				StarEquipModel.waitShowMaster = null
			}
		}

		this.Clear = () => {
			if (this._show_item) {
				this._show_item.DeleteMe()
				this._show_item = null
			}
			if (this._ac_item) {
				this._ac_item.DeleteMe()
				this._ac_item = null
			}
			this._model.ClearTimer(chcModel.CHCTIMER.CLOSE_VIEW)
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._btn_go, () => {
				this.Close()
			}, this, true)

			this.BindEvent(StarEquipModel.GetInstance(), StarEquipModel.PREVIEW_TOOLTIPS, (scmd?) => {
				this.UpdateAttrTips(scmd.star_attr_cfg)
			})
		}

		this.LoadSuccess = () => {
			// resMgr.SetOutsideImageSprite(this, this._img_left, GameResPath.GetIcon("common4", "uijs_062"))
			// resMgr.SetOutsideImageSprite(this, this._img_right, GameResPath.GetIcon("common4", "uijs_062"))
			// resMgr.SetOutsideImageSprite(this, this._img_064l, GameResPath.GetIcon("common4", "uijs_064"), true)
			// resMgr.SetOutsideImageSprite(this, this._img_064r, GameResPath.GetIcon("common4", "uijs_064"), true)
			// resMgr.SetOutsideImageSprite(this, this._Image3, GameResPath.GetIcon("chc", "uiqlcg_003a"), true)

			resMgr.SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("chc", "com_up_bg1"))

			//this._ac_item = eui. new ArrayCollection()
			//this._gp_item.dataProvider = this._ac_item
			//this._gp_item.itemRenderer = chcEvoTipsItem
			this._etime = TimeUtil.getServerTime() + 15
			this._model.StartTimer(chcModel.CHCTIMER.CLOSE_VIEW, 1000, this.UpdateTimer)

			this.UpdateTimer()
			this.UpdateView()
		}

		this.UpdateView = () => {
			let data = this._data
			let vo = goodsModel.starEquipDic[data.equip_id]
			//let basic = goodsModel.GetGoodsBasicByTypeId(vo.type_id)
			this._lb_lv.text = "进化" + data.lv + "级"
			if (!this._show_item) {
				this._show_item = new EquipmentItem(this._gp_aitem)
				this._show_item.SetItemSize(85, 85)
				this._show_item.SetShowTips(false)
				this._show_item.Load()
			}
			this._show_item.ExcuteCallback(() => {
				this._show_item.SetData(vo.type_id)
				this._show_item.SetStarEquipStar(vo.color, vo.star)
			}
			)
			let scfg = this.cfg_evolu
			let ccfg = scfg[data.type_id + "@" + data.pos + "@" + data.lv]
			let fcfg = scfg[data.type_id + "@" + data.pos + "@" + (data.lv - 1)]
			let clist = JSON.parse(ccfg.attr)
			let flist = (fcfg && (JSON.parse(fcfg.attr)) || ({}))
			let i = 0
			if (i < clist.length) {
				do {
					let attr = clist[i]
					attr[2] = (flist[i] && (flist[i][1]) || (0))
					i = i + 1
				} while ((i < clist.length))
			}

			if (!this._ac_item) {
				this._ac_item = new LoopScrowViewMgr()
				this._ac_item.SetData(this._Scroller1, chcEvoTipsItem, clist, LoopScrCon.Vertical)
			} else {
				this._ac_item.replaceAll(clist)
			}

			//this._ac_item.source = clist
			let pcfg = this.cfg_evolu_pool
			let cfg = pcfg[data.type_id + "@" + vo.cell]
			let pool = JSON.parse(cfg.attr_pool)
			let attr_vo = null
			for (let _tmpi in pool) {
				let vo = pool[_tmpi]
				if (Number(vo[0]) == data.attr_id) {
					attr_vo = vo
					break
				}
			}
			if (!attr_vo) {
				return
			}
			let val = attr_vo[1]
			//let is_star = Number(attr_vo[3]) == 1
			//this._img_star.visible = is_star
			let name = WordManager.GetProperties(data.attr_id)
			let valc = WordManager.ConvertToPercentValue(data.attr_id, val)
			let lv = attr_vo[5]
			let gval = attr_vo[6]
			name = (lv && gval && (name.replace("{0}", lv)) || (name))
			valc = (lv && gval && (gval) || (valc))
			this._lb_attr.text = "（卓越" + name + (" + ") + valc + "）"
			StarEquipModel.GetInstance().Fire(StarEquipModel.SEND_PROTO, 23250, "ll", RoleManager.GetInstance().GetMainRoleId(), data.equip_id)
		}

		this.UpdateAttrTips = (attr_list?) => {
			let num = (attr_list && (attr_list.length) || (0))
			this._lb_count.text = "卓越属性增加至" + num + "条"
		}

		this.UpdateTimer = () => {
			if (this.use_delete_method) {
				return
			}
			let rtime = this._etime - TimeUtil.getServerTime()
			if (rtime > 0) {
				this._lb_time.text = rtime + " 后自动关闭"
			} else {
				this.Close()
			}
		}
	}

	public Open(...new_args) {
		this._data = new_args[0]
		super.Open()
	}

	_img_bg: Laya.Image
	_img_title: Laya.Image
	_img_bg2: Laya.Image
	_img_bg3: Laya.Image
	_lb_lv: Laya.Label
	_lb_count: Laya.Label
	_lb_attr: Laya.Label
	_lb_time: Laya.Label
	_gp_aitem: Laya.Box
	_btn_go: Laya.Box
	_Image5: Laya.Image
	_Label1: Laya.Label
	_Scroller1: Laya.List
	_gp_eff: Laya.Box
	public GetComponents() {
		[
			this._img_bg,
			this._img_title,
			this._img_bg2,
			this._img_bg3,
			this._lb_lv,
			this._lb_count,
			this._lb_attr,
			this._lb_time,
			this._gp_aitem,
			this._btn_go,
			this._Image5,
			this._Label1,
			this._Scroller1,
			this._gp_eff,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_img_title",
				"_img_bg2",
				"_img_bg3",
				"_lb_lv",
				"_lb_count",
				"_lb_attr",
				"_lb_time",
				"_gp_aitem",
				"_btn_go",
				"_Image5",
				"_Label1",
				"_Scroller1",
				"_gp_eff",
			])
	}
}
window["chcEvoTipsView"] = chcEvoTipsView
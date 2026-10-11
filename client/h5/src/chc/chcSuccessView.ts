import { BaseView1 } from "../common/BaseView1"
import { Util } from "../util/Util"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { LoopScrowViewMgr, LoopScrCon } from "../common/LoopScrowViewMgr"
import { GoodsModel } from "../commonModel/GoodsModel"
import { chcModel } from "../commonModel/chcModel"
import { EquipmentItem } from "../common/EquipmentItem"
import { chcSuccessItem } from "./chcSuccessItem"

export class chcSuccessView extends BaseView1 {
	Clear
	InitEvent
	LoadSuccess
	Scr_Scroller1
	UpdateTimer
	UpdateView
	_ac_item
	_data
	_etime
	_gp_item
	_model
	_show_item
	cfg_spirit

	public constructor() {
		super()
		this._etime = 0
		this.base_file = "chc"
		this.layout_file = "chcSuccessView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.use_background = true
		this.is_center = true
		this._model = chcModel.GetInstance()
		let resMgr = ResManager.GetInstance()
		let goodsModel = GoodsModel.GetInstance()
		this.preload_server_config = {
			"config_constellation_spirit": false
		}

		this.load_callback = () => {
			this.cfg_spirit = resMgr.GetGameConfigFromCache(this, "config_constellation_spirit", false)
			this.InitEvent()
			this.LoadSuccess()
		}

		this.destroy_callback = () => {
			this.Clear()
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
		}

		this.LoadSuccess = () => {
			// resMgr.SetOutsideImageSprite(this, this._img_left, GameResPath.GetIcon("common4", "uijs_062"))
			// resMgr.SetOutsideImageSprite(this, this._img_right, GameResPath.GetIcon("common4", "uijs_062"))
			// resMgr.SetOutsideImageSprite(this, this._img_064l, GameResPath.GetIcon("common4", "uijs_064"))
			// resMgr.SetOutsideImageSprite(this, this._img_064r, GameResPath.GetIcon("common4", "uijs_064"))
			// resMgr.SetOutsideImageSprite(this, this._img_title, GameResPath.GetIcon("chc", "uiqlcg_003"), true)
			resMgr.SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("chc", "com_up_bg1"))

			//this._ac_item = eui. new ArrayCollection()
			//this._gp_item.dataProvider = this._ac_item
			//this._gp_item.itemRenderer = chcSuccessItem

			this._etime = TimeUtil.getServerTime() + 15
			this._model.StartTimer(chcModel.CHCTIMER.CLOSE_VIEW, 1, this.UpdateTimer)
			this.UpdateTimer()
			this.UpdateView()
			//this:AddUIEffect("ui_constellation_qiling", this._gp_eff)
		}

		this.UpdateView = () => {
			let data = this._data
			let vo = goodsModel.GetStarEquipBuyPagePos(data.type_id, data.pos)
			this._lb_name.text = vo.goods_name
			//let basic = goodsModel.GetGoodsBasicByTypeId(vo.type_id)
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
			let scfg = this.cfg_spirit
			let ccfg = scfg[data.type_id + "@" + data.pos]
			let list = JSON.parse(ccfg.attr)
			this._ac_item = new LoopScrowViewMgr()
			this._ac_item.SetData(this._Scroller1, chcSuccessItem, list, LoopScrCon.Vertical)
			//this._ac_item.source = list
		}

		this.UpdateTimer = () => {
			if (this.use_delete_method) {
				return
			}
			let rtime = this._etime - TimeUtil.getServerTime()
			if (rtime > 0) {
				this._lb_time.text = rtime + "后自动关闭"
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
	_Image4: Laya.Image
	_Image3: Laya.Image
	_lb_time: Laya.Label
	_gp_aitem: Laya.Box
	_btn_go: Laya.Box
	_Image5: Laya.Image
	_Label1: Laya.Label
	_Scroller1: Laya.List
	_gp_eff: Laya.Box
	_lb_name: Laya.Label
	public GetComponents() {
		[
			this._img_bg,
			this._img_title,
			this._img_bg2,
			this._img_bg3,
			this._Image4,
			this._Image3,
			this._lb_time,
			this._gp_aitem,
			this._btn_go,
			this._Image5,
			this._Label1,
			this._Scroller1,
			this._gp_eff,
			this._lb_name,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_img_title",
				"_img_bg2",
				"_img_bg3",
				"_Image4",
				"_Image3",
				"_lb_time",
				"_gp_aitem",
				"_btn_go",
				"_Image5",
				"_Label1",
				"_Scroller1",
				"_gp_eff",
				"_lb_name",
			])
	}
}
window["chcSuccessView"] = chcSuccessView
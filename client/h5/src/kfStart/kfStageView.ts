import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { Util } from "../util/Util"
import { LoopScrowViewMgr, LoopScrCon } from "../common/LoopScrowViewMgr"
import { kfStageItem } from "./kfStageItem"
import { kfStageModel } from "../commonModel/kfStageModel"

export class kfStageView extends BaseView1 {
	loop_mgr
	model:kfStageModel

	public constructor() {
		super()
		this.base_file = "kfStart"
		this.layout_file = "kfStageView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.use_background = true
		this.click_bg_toClose = true
		this.is_center = true
		this.preload_client_config = {
			"ConfigKFuncIcon": false
		}

		this.model = kfStageModel.GetInstance()
		this.load_callback = () => {
			this._gp_con.vScrollBarSkin = ""

			this.InitEvent()
			this.InitView()
		}

		this.close_callback = () => {
			this.Remove()
		}
	}

	private InitEvent() {
		Util.AddClickEvent(this._btn_close, () => {
			this.Close()
		}, this, true)

		this.BindEvent(this.model, kfStageModel.UPDATE_VIEW, () => {
			this.InitView()
		})

		this.BindEvent(this.model, kfStageModel.CLOSE_VIEW, () => {
			this.Close()
		})
	}

	private InitView() {
		let list = this.model.GetFuncData()
		if (!this.loop_mgr) {
			this.loop_mgr = new LoopScrowViewMgr()
			this.loop_mgr.SetData(this._gp_con, kfStageItem, list, LoopScrCon.Vertical)
		} else {
			this.loop_mgr.replaceAll(list)
		}
	}

	private Remove() {
		if (this.loop_mgr) {
			this.loop_mgr.DeleteMe()
			this.loop_mgr = null
		}
	}

	_img_bg: Laya.Image
	_img_bg2: Laya.Image
	_img_title: Laya.Image
	_lb_title: Laya.Label
	_btn_close: Laya.Image
	_img_title2: Laya.Image
	_lb_title1: Laya.Label
	_lb_title2: Laya.Label
	_lb_title3: Laya.Label
	_lb_title4: Laya.Label
	_gp_con: Laya.List
	public GetComponents() {
		[
			this._img_bg,
			this._img_bg2,
			this._img_title,
			this._lb_title,
			this._btn_close,
			this._img_title2,
			this._lb_title1,
			this._lb_title2,
			this._lb_title3,
			this._lb_title4,
			this._gp_con,
		]
			= this.GetChildrenByNames([
				"_img_bg",
				"_img_bg2",
				"_img_title",
				"_lb_title",
				"_btn_close",
				"_img_title2",
				"_lb_title1",
				"_lb_title2",
				"_lb_title3",
				"_lb_title4",
				"_gp_con",
			])
	}
}
window["kfStageView"] = kfStageView
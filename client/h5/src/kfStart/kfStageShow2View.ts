import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { Util } from "../util/Util"
import { LoopScrowViewMgr, LoopScrCon } from "../common/LoopScrowViewMgr"
import { kfStageShowItem } from "./kfStageShowItem"
import { kfStageModel } from "../commonModel/kfStageModel"
import { table } from "../common/table"
import { EnumViewOrder, ViewOrderModel } from "../commonModel/ViewOrderModel"
import { BaseItem1 } from "../common/BaseItem1"

export class kfStageShow2View extends BaseItem1 {
	res_mgr
	model
	loop_mgr

	public constructor(parent) {
		super(parent)
		this.base_file = "kfStart"
		this.layout_file = "kfStageShowView"
		this.layer_value = Enum_UILayer.Activity

		this.preload_client_config = {
			"ConfigKFuncIcon": false
		}

		this.res_mgr = ResManager.GetInstance()
		this.model = kfStageModel.GetInstance()

		this.load_callback = () => {
			this.LoadSuccess()
			this.InitEvent()
			this.InitView()
		}

	}




	public LoadSuccess() {
		this._btn_close.visible=false
		this._gp_con.vScrollBarSkin = ""
		this.res_mgr.SetOutsideImageSprite(this, this._img_bg, "resource/game/kfStart/other/ui_kfjd_008a.png")
	}

	public InitEvent() {
		// Util.AddClickEvent(this._btn_close, () => {
		// 	this.Close()
		// }, this, true)

		// this.BindEvent(this.model, kfStageModel.CLOSE_VIEW, () => {
		// 	this.Close()
		// })
	}

	public InitView() {
		let list = this.model.GetFuncData()
		let show_list = []
		for (let i in list) {
			let vo = list[i]
			if (vo.mod > 1) {
				table.insert(show_list, vo)
			}
		}
		if (!this.loop_mgr) {
			this.loop_mgr = new LoopScrowViewMgr()
			this.loop_mgr.SetData(this._gp_con, kfStageShowItem, show_list, LoopScrCon.Vertical)
		} else {
			this.loop_mgr.replaceAll(list)
		}

		let max = 0
		for (let i in list) {
			let vo = list[i]
			if (vo.mod > max) {
				max = vo.mod
			}
		}
		let front = this.model.GetFrontMod(max)
		if (front) {
			ResManager.GetInstance().SetImageSprite(this, this._img_curNum, "kfStart", "mod_" + front)
			ResManager.GetInstance().SetImageSprite(this, this._img_nextNum, "kfStart", "mod_" + max)
		}
	}


	public DeleteMe(){
		if (this.loop_mgr) {
			this.loop_mgr.DeleteMe()
			this.loop_mgr = null
		}
		this.model.SaveCookie()
		super.DeleteMe()
	}

	_img_bg: Laya.Image
	_btn_close: Laya.Image
	_img_title: Laya.Image
	_img_arrow: Laya.Image
	_img_cur: Laya.Image
	_img_tips1: Laya.Image
	_img_curNum: Laya.Image
	_img_next: Laya.Image
	_img_tips2: Laya.Image
	_img_none: Laya.Image
	_img_nextNum: Laya.Image
	_gp_con: Laya.List
	public GetComponents() {
		[
			this._img_bg,
			this._btn_close,
			this._img_title,
			this._img_arrow,
			this._img_cur,
			this._img_tips1,
			this._img_curNum,
			this._img_next,
			this._img_tips2,
			this._img_none,
			this._img_nextNum,
			this._gp_con,
		]
			= this.GetChildrenByNames([
				"_img_bg",
				"_btn_close",
				"_img_title",
				"_img_arrow",
				"_img_cur",
				"_img_tips1",
				"_img_curNum",
				"_img_next",
				"_img_tips2",
				"_img_none",
				"_img_nextNum",
				"_gp_con",
			])
	}
}
window["kfStageShow2View"] = kfStageShow2View
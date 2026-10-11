import { BaseView1 } from "../common/BaseView1"
import { InstructionItem } from "../common/InstructionItem"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { Util } from "../util/Util"

export class HolySealTipsView extends BaseView1 {

	item_loop_mgr
	instruction_id
	public constructor() {
		super()

		this.base_file = "holySeal"
		this.layout_file = "HolySealTipsView"
		this.layer_value = Enum_UILayer.Activity
		this.is_center = true
		this.use_background = true
		this.click_bg_toClose = true
		this.show_open_movie = true

		this.load_callback = function () {
			this.LoadSuccess()
		}

		this.open_callback = function () {
			this.UpdateView()
		}

		this.preload_client_config = {
			"ConfigInstruction": false
		}

		this.destroy_callback = function () {
			this.Remove()
		}
	}

	LoadSuccess() {

	}

	InitEvent() {
		Util.AddClickEvent(this._img_close, () => {
			this.Close()
		}, this, true)
	}


	UpdateView() {
		let cfgs = ResManager.GetInstance().GetGameConfigFromCache(this, "ConfigInstruction", true)
		if (cfgs && this.instruction_id && cfgs[this.instruction_id]) {
			let cfg = cfgs[this.instruction_id][0]
			this._lb_title.text = Util.StrToHTML(cfg.view_title)


			let list = cfg.content.item_List
			if (this.item_loop_mgr) {
				this.item_loop_mgr.replaceAll(list)
			}
			else {
				this.item_loop_mgr = new LoopScrowViewMgr()
				this.item_loop_mgr.SetData(this._list_item_con, InstructionItem, list, LoopScrCon.Horizontal)
			}
		}
	}

	Remove() {
		if (this.item_loop_mgr) {
			this.item_loop_mgr.DeleteMe()
			this.item_loop_mgr = undefined
		}
	}

	public Open(...parm) {
		this.instruction_id = parm[0]
		super.Open()
	}


	_Image1: Laya.Image
	_Image2: Laya.Image
	_img_close: Laya.Image
	_lb_title: Laya.Label
	_list_item_con: Laya.List
	public GetComponents() {
		[
			this._Image1,
			this._Image2,
			this._img_close,
			this._lb_title,
			this._list_item_con,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_Image2",
				"_img_close",
				"_lb_title",
				"_list_item_con",
			])
	}
}
window["HolySealTipsView"] = HolySealTipsView
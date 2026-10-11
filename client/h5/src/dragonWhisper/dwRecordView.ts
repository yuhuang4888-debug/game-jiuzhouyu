import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { Util } from "../util/Util"
import { DragonWhisperModel, DrWsEvent } from "../commonModel/DragonWhisperModel"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { BossDropRecordItem } from "../boss/BossDropRecordItem"

export class dwRecordView extends BaseView1 {
	InitEvent
	LoadSuccess
	UdpateItem

	item_loop_mgr

	public constructor() {
		super()
		this.base_file = "boss"
		this.layout_file = "BossDropRecordView"
		this.layer_value = Enum_UILayer.Activity
		this.change_scene_close = true
		this.click_bg_toClose = true
		this.use_background = true
		this.is_center = true
		this.destroy_imm = true
		this.show_open_movie = true

		let _model = DragonWhisperModel.GetInstance()
		let local_DrWsEvent = DrWsEvent
		let _item_arraycollection = null

		this.load_callback = () => {
			this.LoadSuccess()
			this.InitEvent()
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._img_close, () => {
				this.Close()
			}, this, true)

			this.BindEvent(_model, local_DrWsEvent.UPDATE_RECORD, (scmd?) => {
				this.UdpateItem(scmd)
			})
		}

		this.LoadSuccess = () => {
			this._list_item.vScrollBarSkin = ""
			_model.Fire(local_DrWsEvent.PROTO, 65106)
		}

		this.UdpateItem = (scmd?) => {
			let list = scmd.drop_log
			this._gp_null.visible = list.length == 0
			if (!this.item_loop_mgr) {
				this.item_loop_mgr = new LoopScrowViewMgr()
				this.item_loop_mgr.SetData(this._list_item, BossDropRecordItem, list, LoopScrCon.Vertical)
			} else {
				this.item_loop_mgr.replaceAll(list)
			}

		}
	}

	public DeleteMe() {
		if (this.item_loop_mgr) {
			this.item_loop_mgr.DeleteMe()
			this.item_loop_mgr = null
		}
		super.DeleteMe()
	}

	_img_bg: Laya.Image
	_img_bg2: Laya.Image
	_img_bg3: Laya.Image
	_list_item: Laya.List
	_box_con: Laya.Box
	_img_bg4: Laya.Image
	_lb_title2: Laya.Label
	_lb_title3: Laya.Label
	_lb_title4: Laya.Label
	_lb_title5: Laya.Label
	_img_close: Laya.Image
	_gp_null: Laya.Box
	_lb_null: Laya.Label
	_lb_title: Laya.Label
	public GetComponents() {
		[
			this._img_bg,
			this._img_bg2,
			this._img_bg3,
			this._list_item,
			this._box_con,
			this._img_bg4,
			this._lb_title2,
			this._lb_title3,
			this._lb_title4,
			this._lb_title5,
			this._img_close,
			this._gp_null,
			this._lb_null,
			this._lb_title,
		]
			= this.GetChildrenByNames([
				"_img_bg",
				"_img_bg2",
				"_img_bg3",
				"_list_item",
				"_box_con",
				"_img_bg4",
				"_lb_title2",
				"_lb_title3",
				"_lb_title4",
				"_lb_title5",
				"_img_close",
				"_gp_null",
				"_lb_null",
				"_lb_title",
			])
	}
}
window["dwRecordView"] = dwRecordView
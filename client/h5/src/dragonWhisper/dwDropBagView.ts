import { BaseView1 } from "../common/BaseView1"
import { Util } from "../util/Util"
import { table } from "../common/table"
import { Enum_UILayer } from "../common/LayerManager"
import { BossModel } from "../commonModel/BossModel"
import { LoopScrowViewMgr, LoopScrCon } from "../common/LoopScrowViewMgr"
import { dwDropBagItem } from "./dwDropBagItem"

export class dwDropBagView extends BaseView1 {
	InitEvent
	UdpateItem
	UpdateView

	bag_loop_mgr

	public constructor() {
		super()
		this.base_file = "dragonWhisper"
		this.layout_file = "dwDropBagView"
		this.layer_value = Enum_UILayer.Activity
		this.change_scene_close = true
		this.click_bg_toClose = true
		this.use_background = true
		this.is_center = true
		this.show_open_movie = true

		// let _model = DragonWhisperModel.GetInstance()
		this.load_callback = () => {
			this._Scroller1.vScrollBarSkin = ""
			this.InitEvent()
		}

		this.open_callback = () => {
			this.UpdateView()
		}
		
		this.destroy_callback = () => {
			this.Remove()
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._btn_close, () => {
				this.Close()
			}, this, true)
		}

		this.UpdateView = () => {
			let dic = BossModel.GetInstance().drop_dic
			let list = []
			for (let key in dic) {
				table.insert(list, dic[key])
			}
			if (list.length < 40) {
				let i = list.length
				do {
					table.insert(list, null)
					i = i + 1
				} while ((i < 40)
				)
			}
			this.UdpateItem(list)
		}

		this.UdpateItem = (list?) => {
			if (!this.bag_loop_mgr) {
				this.bag_loop_mgr = new LoopScrowViewMgr()
				this.bag_loop_mgr.SetData(this._Scroller1, dwDropBagItem, list, LoopScrCon.Vertical, 4)
			} else {
				this.bag_loop_mgr.replaceAll(list)
			}
		}
	}

	public Remove() {
		if (this.bag_loop_mgr) {
			this.bag_loop_mgr.DeleteMe()
			this.bag_loop_mgr = null
		}
	}

	_img_bg: Laya.Image
	_img_bg2: Laya.Image
	_btn_close: Laya.Image
	_gp_title: Laya.Image
	_lb_title: Laya.Label
	_Scroller1: Laya.List
	public GetComponents() {
		[
			this._img_bg,
			this._img_bg2,
			this._btn_close,
			this._gp_title,
			this._lb_title,
			this._Scroller1,
		]
			= this.GetChildrenByNames([
				"_img_bg",
				"_img_bg2",
				"_btn_close",
				"_gp_title",
				"_lb_title",
				"_Scroller1",
			])
	}
}
window["dwDropBagView"] = dwDropBagView
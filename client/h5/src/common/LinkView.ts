import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { SetAnchoredPositionY, SetSizeDeltaY, Util } from "../util/Util"
import { BaseView1 } from "./BaseView1"
import { Enum_UILayer } from "./LayerManager"
import { LinkTool } from "./LinkTool"
import { LinkViewItem } from "./LinkViewItem"
import { LinkViewType } from "./LinkViewType"
import { LoopScrowViewMgr, LoopScrCon } from "./LoopScrowViewMgr"
import { ResManager } from "./ResManager"
import { table } from "./table"

export class LinkView extends BaseView1 {
	_bg1: Laya.Image
	_bg2: Laya.Image
	_Group1: Laya.Box
	_Image2: Laya.Image
	_Image3: Laya.Image
	btnClose: Laya.Image
	Content: Laya.List
	InintEvent
	LoadSuccess
	ScrScroll
	SetData
	UpdateSize
	HaveSameAct
	InitItem
	_type
	loop_mgr
	public constructor() {
		super()

		this.base_file = "common"
		this.layout_file = "LinkView"
		this.layer_value = Enum_UILayer.Activity
		this.use_background = true
		this.click_bg_toClose = true
		this.show_open_movie = true
		this.change_scene_close = true
		this.destroy_imm = true
		this.is_center = true
		let length = 0
		let _bg1_height = 0
		let _bg2_height = 0
		let scroll_height = 0
		let Max = 4
		this.load_callback = () => {
			this.InintEvent()
			this.LoadSuccess()
		}
		this.close_callback = () => {
			if (this.loop_mgr) {
				this.loop_mgr.DeleteMe()
				this.loop_mgr = null
			}
			LinkTool.GetInstance().open_type = null
		}
		this.preload_client_config = {
			"ClientLinK": false
		}
		this.InintEvent = () => {
			Util.AddClickEvent(this.btnClose, () => {
				this.Close()
			}, this, true)
		}

		this.LoadSuccess = () => {
			_bg1_height = this._bg1.height
			_bg2_height = this._bg2.height
			scroll_height = this.Content.height
			this.SetData(this._type)
		}

		this.SetData = (type?) => {
			this._type = type
			if (!this.is_loaded || !this._type) {
				return
			}
			this.InitItem()
		}

		this.HaveSameAct = (jump_id, list) => {
			let bool = false
			if (list && Util.TableSize(list) > 0) {
				for (let key in list) {
					let vo = list[key]
					if (vo.jump_id == jump_id) {
						bool = true
						break
					}
				}
			}

			return bool
		}

		this.InitItem = () => {
			let cfg_ = ResManager.GetInstance().GetGameConfigFromCache(this, "ClientLinK", true)
			let cfg = cfg_[this._type]
			if (!cfg) {
				return
			}

			let dataList = LinkTool.GetInstance().SortList(LinkTool.GetInstance().open_type, cfg.linkList)
			if (this._type == LinkViewType.DestinyTurntable) {
				let list = CustomActivityModel.GetInstance().GetDesTinyGetWay()
				let list_ = Util.DeepCopy(list)
				if (dataList && Util.TableSize(dataList) > 0) {
					for (let key in dataList) {
						let v = dataList[key]
						if (!this.HaveSameAct(v.jump_id, list_))
							table.insert(list_, v)
					}
					dataList = Util.DeepCopy(list_)
					//dataList = dataList.concat(list)
					table.sort(dataList, (a, b) => {
						return a.index < b.index
					})
				}

			}
			length = dataList.length
			for (let key in dataList) {
				let data = dataList[key]
				data._type = this._type
			}
			if (!this.loop_mgr) {
				this.loop_mgr = new LoopScrowViewMgr()
				this.loop_mgr.SetData(this.Content, LinkViewItem, dataList, LoopScrCon.Vertical)
			}
			else {
				this.loop_mgr.replaceAll(dataList)
			}

			this.UpdateSize()
		}

		this.UpdateSize = () => {
			// let num = length >= Max && 0 || Max - length
			// let add = num > 0 && 40 || 0
			// SetSizeDeltaY(this._bg1, _bg1_height - num * (80 + 6))
			// SetSizeDeltaY(this._bg2, _bg2_height - num * (80 + 6))
			// SetSizeDeltaY(this.Content, scroll_height - num * (80 + 6))
			// if (num > 0) {
			// 	SetAnchoredPositionY(this.Content, num * (80 + 6) / 2 - 240)
			// }
		}


	}
	// public DeleteMe() {

	// 	super.DeleteMe()
	// }


	public GetComponents() {
		[
			this._bg1,
			this._bg2,
			this._Group1,
			this._Image2,
			this._Image3,
			this.btnClose,
			this.Content,
		]
			= this.GetChildrenByNames([

				"_bg1",
				"_bg2",
				"_Group1",
				"_Image2",
				"_Image3",
				"btnClose",
				"Content",
			])
	}
}
window["LinkView"] = LinkView
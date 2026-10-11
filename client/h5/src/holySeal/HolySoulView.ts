import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { HolySealModel } from "../commonModel/HolySealModel"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
import { HolySoulItem } from "./HolySoulItem"

export class HolySoulView extends BaseView1 {

	LoadSuccess
	InitEvent
	UpdateView
	Remove
	public constructor() {
		super()
		this.base_file = "holySeal"
		this.layout_file = "HolySoulView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.use_background = true
		this.click_bg_toClose = true
		this.is_center = true
		this.show_open_movie = true

		let model = HolySealModel.GetInstance(),
			res_mgr = ResManager.GetInstance(),
			item_list_


		this.load_callback = function () {
			this.LoadSuccess()
		}

		this.destroy_callback = function () {
			this.Remove()
		}

		this.LoadSuccess = () => {
			res_mgr.SetTexture(this, this._img_bg2, GameResPath.GetIcon("holySeal", "ui_seal_bg2"))
			this.InitEvent()
			this.UpdateView()
			model.Fire(HolySealModel.REQUEST_CCMD_EVENT, 65405)
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._img_close, () => {
				this.Close()
			}, this, true)

			this.BindVar(model, "soul_data", () => {
				this.UpdateView()
			})
		}

		this.UpdateView = () => {
			let soul_data = model.soul_data

			if (!item_list_)
				item_list_ = []
			let item: HolySoulItem
			let index = 0
			for (let key in soul_data) {
				let item = item_list_[index]
				let data = soul_data[key]
				if (!item) {
					item = new HolySoulItem(this._gp_item_con)
					item.Load()
					item_list_[index] = item
				}
				item.SetData(data)
				index++
			}
		}

		this.Remove = () => {
			if (item_list_) {
				for (let obj of item_list_) {
					if (obj) {
						obj.DeleteMe()
					}
				}
				item_list_ = undefined
			}
		}

	}

	_img_bg: Laya.Image
	_img_bg2: Laya.Image
	_img_bg3: Laya.Image
	_img_bg4: Laya.Image
	_img_close: Laya.Image
	_scroll_item: Laya.Panel
	_gp_item_con: Laya.VBox
	_lb_title: Laya.Label
	public GetComponents() {
		[
			this._img_bg,
			this._img_bg2,
			this._img_bg3,
			this._img_bg4,
			this._img_close,
			this._scroll_item,
			this._gp_item_con,
			this._lb_title,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_img_bg2",
				"_img_bg3",
				"_img_bg4",
				"_img_close",
				"_scroll_item",
				"_gp_item_con",
				"_lb_title",
			])
	}
}
window["HolySoulView"] = HolySoulView
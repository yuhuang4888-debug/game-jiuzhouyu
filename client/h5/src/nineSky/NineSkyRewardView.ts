import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { NineSkyModel } from "../commonModel/NineSkyModel"
import { SceneManager } from "../scene/SceneManager"
import { Util } from "../util/Util"
import { NineSkyRewardItem } from "./NineSkyRewardItem"

export class NineSkyRewardView extends BaseView1 {
	item_list



	nine_sky_model:NineSkyModel
	public constructor() {
		super()

		this.base_file = "nineSky"
		this.layout_file = "NineSkyRewardView"
		this.layer_value = Enum_UILayer.Activity
		this.is_center = true
		this.use_background = true
		this.background_alpha = 0.4
		this.click_bg_toClose = true
		this.show_open_movie = true

		this.nine_sky_model = NineSkyModel.GetInstance()

		this.preload_server_config = {
			"config_nine": false,
		}


		this.load_callback = () => {
			this.LoadSuccess()
		}

		this.open_callback = () => {
		}

		this.destroy_callback = () => {
			this.Remove()
		}
	}

	public InitEvent() {
		Util.AddClickEvent(this._img_close, () => {
			this.Close()
		}, this, true)
	}

	public LoadSuccess() {

		this._panel_item.vScrollBarSkin = ""
		this.InitEvent()
		this.UpdateView()
	}

	public Remove() {
		if (this.item_list) {
			for (let _tmpi in this.item_list) {
				var obj = this.item_list[_tmpi]
				obj.DeleteMe()
			}
			this.item_list = null
		}
	}

	public UpdateView() {


		let list = []
		let cfg = null

		let notify_info = null
		if (SceneManager.GetInstance().IsNineSkyFightScene()) {
			notify_info = this.nine_sky_model.GetNotifyInfo()
		}

		let nine_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_nine", false)
		for (let key in nine_cfg) {

			let vo = nine_cfg[key]
			if (vo.mod_id == this.nine_sky_model.server_type) {
				let is_get = notify_info && notify_info.max_floor >= vo.layer_id || false
				let award = JSON.parse(vo.award)
				if (award && award.length > 0) {
					table.insert(
						list,
						{
							desc: "首次达到<font color='#fe1a1a'>第" + vo.layer_id + "层</font>可获得",
							reward: award,
							is_get: is_get,
							layer_id: vo.layer_id
						}
					)
				}
			}
		}

		if (!this.item_list) {
			this.item_list = []
		}

		let len = list.length
		let i = len

		if (i < this.item_list.length) {
			do {
				i = i + 1
				this.item_list[i].SetVisible(false)
			} while ((i < this.item_list.length)
			)
		}

		if (len > 0) {
			table.sort(list, (a?, b?) => {
				return a.layer_id < b.layer_id
			})
			for (let key in list) {

				let item = this.item_list[key]
				if (!item) {
					item = new NineSkyRewardItem(this._panel_item)
					this.item_list[key] = item
					item.Load()
				}
				item.SetPosition(0, Number(key) * 170)
				item.SetData(list[key])
				item.SetVisible(true)
			}
		}
	}

	_img_bg: Laya.Image
	_img_bg2: Laya.Image
	_img_close: Laya.Image
	_img_bg3: Laya.Image
	_lb_title: Laya.Label
	_panel_item: Laya.Panel
	public GetComponents() {
		[
			this._img_bg,
			this._img_bg2,
			this._img_close,
			this._img_bg3,
			this._lb_title,
			this._panel_item,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_img_bg2",
				"_img_close",
				"_img_bg3",
				"_lb_title",
				"_panel_item",
			])
	}
}
window["NineSkyRewardView"] = NineSkyRewardView


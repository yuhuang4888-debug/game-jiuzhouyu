import { BaseView1 } from "../common/BaseView1";
import { Config } from "../common/Config";
import { Enum_UILayer } from "../common/LayerManager";
import { ResManager } from "../common/ResManager";
import { table } from "../common/table";
import { Util } from "../util/Util";
import { DemonRotaryPreItem } from "./DemonRotaryPreItem";

export class DemonRotaryPreView extends BaseView1 {
	_rewards
	item_list
	type

	public constructor() {
		super()

		this.base_file = "demon"
		this.layout_file = "DemonRotaryPreView"
		this.layer_value = Enum_UILayer.Activity
		this.use_background = true
		this.is_center = true
		this.click_bg_toClose = true
		this.preload_server_config = {
			"config_spirit_rotary": false
		}
		this.load_callback = () => {
			this._Scroller1.vScrollBar.visible = false
			this.LoadSuccess()
		}
		this.open_callback = () => {
			this.UpdateView()
		}
		this.destroy_callback = () => {
			if (this.item_list.length > 0) {
				for (let _tmpi in this.item_list) {
					let item = this.item_list[_tmpi]
					item.DeleteMe()
				}
				this.item_list = null
			}
		}
	}

	public LoadSuccess() {
		this.InitEvent()
	}

	public InitEvent() {
		Util.AddClickEvent(this._close, () => {
			this.Close()
		}, this, true)
	}

	public UpdateView() {
		let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_spirit_rotary", false)
		if (cfg) {
			if (!this.item_list) {
				this.item_list = []
			}

			let list = []

			for (let _ in cfg) {
				let v = cfg[_]
				list.push(v)
			}
			list.sort((a, b) => {
				return a.bless_value_1 - b.bless_value_1
			})

			let item
			for (let index = 0; index < list.length; index++) {
				let data = list[index]
				item = this.item_list[index]
				if (!item) {
					item = new DemonRotaryPreItem(this.Content)
					item.Load()
					this.item_list.push(item)
				}
				item.SetData(data, this.type)
				// item.ExcuteCallback(() => {
				// 	item.SetData(data, this.type)
				// })
			}
		}
	}

	public Open(...parms) {
		this.type = parms[0]
		super.Open()
	}



_Image1:Laya.Image
_close:Laya.Image
_Image3:Laya.Image
_Scroller1:Laya.Panel
Content:Laya.VBox
title_bg:Laya.Image
public GetComponents() {
[
this._Image1,
this._close,
this._Image3,
this._Scroller1,
this.Content,
this.title_bg,
]
 = this.GetChildrenByNames([

"_Image1",
"_close",
"_Image3",
"_Scroller1",
"Content",
"title_bg",
])
}
}
 window["DemonRotaryPreView"]= DemonRotaryPreView
import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { LuaSoundManager } from "../common/SoundManager"
import { table } from "../common/table"
import { VipModel } from "../commonModel/VipModel"
import { Util } from "../util/Util"
import { VipRuleItem } from "./VipRuleItem"

export class VipRuleView extends BaseView1 {
	_Image1: Laya.Image
	_Image2: Laya.Image
	_Label1: Laya.Label
	closeBtn: Laya.Image
	scroll: Laya.Panel
	Content: Laya.VBox
	InitEvent
	LoadSuccess
	Open
	SetData
	click_bg_toClose
	destroy_callback
	destroy_imm
	is_center
	open_callback
	show_open_movie
	use_background


	public constructor() {
		super()

		let model = null
		let data_ = []
		let item_list_ = null
		this.base_file = "vip"
		this.layout_file = "VipRuleView"
		this.layer_value = Enum_UILayer.Top
		this.destroy_imm = true
		this.use_background = true
		this.click_bg_toClose = true
		this.show_open_movie = true
		this.is_center = true
		model = VipModel.GetInstance()
		this.load_callback = () => {

			this.LoadSuccess()
			this.InitEvent()
		}

		this.open_callback = () => {
			this.SetData()
		}

		this.destroy_callback = () => {
			for (let _tmpi in item_list_) {
				var obj = item_list_[_tmpi]
				obj.DeleteMe()
			}
			item_list_ = null
		}

		this.LoadSuccess = () => {
			item_list_ = []
		}

		this.InitEvent = () => {
			let close_fun = () => {
				this.Close()
			}

			Util.AddClickEvent(this.closeBtn, close_fun, this, true, null, null, null, null, LuaSoundManager.SOUND_UI.CLOSE)
		}

		this.Open = (parms?) => {
			data_ = parms
			// super.Open()
			super.Open()
		}

		this.SetData = () => {
			if (!data_) {
				return
			}
			//策划说要支持非数组
			let list_arr = []
			for (let k in data_) {
				var v = data_[k]
				if (k != "show_vip_lv") {
					table.insert(list_arr, v)
				}
			}
			table.sort(list_arr, (a?, b?) => {
				return b.new < a.new
			}
			)
			let item = null
			let i = 0
			do {
				item = item_list_[i]
				if (!item) {
					item = new VipRuleItem(this.Content)
					item_list_[i] = item
					item.Load()
				}
				item.SetData(list_arr[i])
				i = i + 1
			} while ((i < list_arr.length))
		}
	}


	public GetComponents() {
		[
			this._Image1,
			this._Image2,
			this._Label1,
			this.closeBtn,
			this.scroll,
			this.Content,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_Image2",
				"_Label1",
				"closeBtn",
				"scroll",
				"Content",
			])
		this.scroll.vScrollBar.visible=false
	}
}
window["VipRuleView"] = VipRuleView
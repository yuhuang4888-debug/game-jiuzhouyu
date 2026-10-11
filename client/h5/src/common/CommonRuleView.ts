import { RefBoxVLayout, Util } from "../util/Util"
import { BaseView1 } from "./BaseView1"
import { CommonRuleItem } from "./CommonRuleItem"
import { Enum_UILayer } from "./LayerManager"

export class CommonRuleView extends BaseView1 {
	Local_Open
	SetTitle
	InitEvent
	SetData
	LoadSuccess
	count_num:number

	public constructor() {
		super()

		let _data = []
		let _titleStr = null
		let _item_list = null
		this.base_file = "common"
		this.layout_file = "CommonRuleView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.use_background = true
		this.click_bg_toClose = true
		this.show_open_movie = true
		this.is_center = true
		


		this.load_callback = () => {
			this.scroll.vScrollBarSkin=""
			this.LoadSuccess()
			this.InitEvent()
		}

		this.open_callback = () => {
			this.SetData()
		}

		this.destroy_callback = () => {
			for (let _tmpi in _item_list) {
				let obj = _item_list[_tmpi]
				obj.DeleteMe()
			}
			_item_list = null
		}

		this.LoadSuccess = () => {
			_item_list = []
			if (_titleStr) {
				this.titleLabel.text = _titleStr
			}
		}

		this.InitEvent = () => {
			let close_fun = () => {
				this.Close()
			}

			Util.AddClickEvent(this.closeBtn, close_fun, this, true)
		}

		this.Local_Open = (parms) => {
			_data = parms
			super.Open()
		}

		this.SetTitle = (titleStr?) => {
			if (this.is_loaded) {
				this.titleLabel.text = titleStr
			} else {
				_titleStr = titleStr
			}
		}

		this.SetData = () => {
			if (!_data) {
				return
			}
			let item
			this.count_num=0
			for (let i = 0; i < _data.length; i++) {
				item = _item_list[i]
				if (!item) {
					item = new CommonRuleItem(this.Content)
					_item_list[i] = item
					item.Load()
				}
				item.SetData(_data[i])
				item.ExcuteCallback(() => {
					this.count_num++
					if(this.count_num>=_data.length){
						RefBoxVLayout(this.Content)
					}
				})
			}

			
		}

	}


	public Open(...new_args) {
		this.Local_Open(...new_args)
	}

	_Image1: Laya.Image
	_Image2: Laya.Image
	titleLabel: Laya.Label
	closeBtn: Laya.Image
	scroll: Laya.Panel
	Content: Laya.Box
	public GetComponents() {
		[
			this._Image1,
			this._Image2,
			this.titleLabel,
			this.closeBtn,
			this.scroll,
			this.Content,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_Image2",
				"titleLabel",
				"closeBtn",
				"scroll",
				"Content",
			])
	}
}
window["CommonRuleView"]=CommonRuleView
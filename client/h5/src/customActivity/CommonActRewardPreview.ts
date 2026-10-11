import { BaseView1 } from "../common/BaseView1"
import { EquipmentItem } from "../common/EquipmentItem"
import { Enum_UILayer } from "../common/LayerManager"
import { LuaSoundManager } from "../common/SoundManager"
import { table } from "../common/table"
import { RefGridLayout, Util } from "../util/Util"

export class CommonActRewardPreview extends BaseView1 {
	_Image1: Laya.Image
	_Image2: Laya.Image
	_Group1: Laya.Box
	_Image3: Laya.Image
	_Image4: Laya.Image
	_scr_reward: Laya.Panel
	Content: Laya.Box
	_img_close: Laya.Image
	Destroy_Callback
	InitEvent
	InitView
	SetData
	click_bg_toClose
	destroy_callback
	destroy_imm
	is_center
	show_open_movie
	use_background
	layout_data


	public constructor() {
		super()

		this.base_file = "customActivity"
		this.layout_file = "CommonActRewardPreview"
		this.is_center = true
		this.use_background = true
		this.click_bg_toClose = true
		this.layer_value = Enum_UILayer.Activity
		this.show_open_movie = true
		this.destroy_imm = true
		let _item_list:Array<EquipmentItem> = []
		let _reward_list = null
		let _showCount = false
		this.layout_data={
			column: 5,
			h_gap: 5,
			v_gap: 15,
			item_w: 100,
			item_h: 100
		}
		this.load_callback = () => {

			this.InitEvent()
			this.InitView(_reward_list, _showCount)
		}

		this.destroy_callback = () => {
			this.Destroy_Callback()
		}

		this.InitEvent = () => {
			Util.AddClickEvent(
				this._img_close, () => {
					this.Close()
				},
				this,
				true, null, null, null, null, LuaSoundManager.SOUND_UI.CLOSE
			)
		}

		this.InitView = (reward_list?, showCount?) => {
			for (let _tmpi in _item_list) {
				var item = _item_list[_tmpi]
				item.SetVisible(false)
			}
			_showCount = showCount
			for (let i = 0; i < reward_list.length; i++) {

				let item:EquipmentItem = _item_list[i]
				if (!item) {
					item = new EquipmentItem(this.Content, null, this.layer_value)
					table.insert(_item_list, item)
					item.SetUseMask(true)
					item.Load()
					item.SetItemSize(100, 100)
				}

					if (_showCount) {
						let type = reward_list[i][0]
						let count = reward_list[i][1]
						let lock = reward_list[i][2]


						item.SetData(type, count, lock)
					} else {
						item.SetData(reward_list[i])
					}
				// item.ExcuteCallback(() => {
				// 	RefGridLayout(this.Content,this.layout_data,false)
				// })
				}

			this.CallLater(() => {
				RefGridLayout(this.Content,this.layout_data,false)
			})
		}

		this.SetData = (reward_list?, showCount?) => {
			_reward_list = reward_list
			_showCount = showCount
		}

		this.Destroy_Callback = () => {
			for (let _tmpi in _item_list) {
				var item = _item_list[_tmpi]
				item.DeleteMe()
			}
			_item_list = []
		}
	}


	public GetComponents() {
		[
			this._Image1,
			this._Image2,
			this._Group1,
			this._Image3,
			this._Image4,
			this._scr_reward,
			this.Content,
			this._img_close,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_Image2",
				"_Group1",
				"_Image3",
				"_Image4",
				"_scr_reward",
				"Content",
				"_img_close",
			])
		this._scr_reward.vScrollBar.visible=false
	}
}
window["CommonActRewardPreview"]=CommonActRewardPreview
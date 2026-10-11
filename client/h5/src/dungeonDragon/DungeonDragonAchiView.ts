import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { LuaSoundManager } from "../common/SoundManager"
import { table } from "../common/table"
import { BaseDungeonModel } from "../commonModel/BaseDungeonModel"
import { GameResPath } from "../util/GameResPath"
import { SetAnchoredPositionX, Util } from "../util/Util"
import { DungeonDragonAchiItem } from "./DungeonDragonAchiItem"
import { DungeonDragonAchiTabItem } from "./DungeonDragonAchiTabItem"
import { DungeonDragonDefine } from "./DungeonDragonDefine"

export class DungeonDragonAchiView extends BaseView1 {

	InitEvent
	InitTab
	InitView
	LoadSuccess
	Local_Open
	Remove
	SwitchTab
	SwitchTabFunc
	UpdateItem

	array_item
	array_tab
	change_scene_close
	click_bg_toClose
	destroy_callback
	is_center
	show_open_movie
	use_background


	public constructor() {
		super()

		this.base_file = "dungeonDragon"
		this.layout_file = "DungeonDragonAchiView"
		this.layer_value = Enum_UILayer.Activity
		let base_model = BaseDungeonModel.GetInstance()
		let local_DungeonDragonDefine = DungeonDragonDefine
		let default_index_ = null
		let default_dun_id_ = null
		let now_index_ = null
		let now_dun_id_ = null
		this.show_open_movie = true
		this.change_scene_close = true
		this.use_background = true
		this.click_bg_toClose = true
		this.is_center = true
		this.load_callback = () => {

			// if (PlatformMgr.GetInstance().IsEyouIdnPlatform() ) {
			// 	SetAnchoredPositionX(this._Label1,8)
			// 	SetAnchoredPositionX(this._Label2,192)
			// 	this._Label4.size  = 16
			// }
			this.LoadSuccess()
		}

		this.destroy_callback = () => {
			this.Remove()
		}

		this.Local_Open = (parms?) => {
			if (parms) {
				default_dun_id_ = parms[0]
			}
			super.Open()
		}

		this.LoadSuccess = () => {
			// ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("dungeonDragon", "uiboss_049"))
			// ResManager.GetInstance().SetOutsideImageSprite(this, this._Image4, GameResPath.GetIconJpg("dungeonDragon", "uilwfb_038"), true)
			ResManager.GetInstance().SetOutsideImageSprite(this, this._Image6, GameResPath.GetIcon("dungeonDragon", "ui_copy_37"), false)
			this.InitEvent()
			this.InitTab()
			this.SwitchTab()
			this.InitView()

		}

		this.InitTab = () => {
			if(!this.array_tab){
				this.array_tab = new LoopScrowViewMgr()
				this.array_tab.SetData(this.Content, DungeonDragonAchiTabItem, local_DungeonDragonDefine.WaveRewardTabList, LoopScrCon.Horizontal, 1, (item?) => {
					this.SwitchTabFunc(item)
				})
			}else{
				this.array_tab.replaceAll(local_DungeonDragonDefine.WaveRewardTabList)
			}
			
			let default_index = 0
			if (default_dun_id_) {
				for (let key in local_DungeonDragonDefine.WaveRewardTabList) {

					let value = local_DungeonDragonDefine.WaveRewardTabList[key]
					if (value.dun_id == default_dun_id_) {
						default_index = Number(key)
						break
					}
				}
			} else {
				let bool = false
				for (let key in local_DungeonDragonDefine.WaveRewardTabList) {

					let value = local_DungeonDragonDefine.WaveRewardTabList[key]
					let data = base_model.GetWaveRewardData(value.dun_id)
					for (let _tmpi in data.list) {
						var vo = data.list[_tmpi]
						if (vo.state == 0) {
							bool = true
							default_index = Number(key)
							break
						}
					}
					if (bool) {
						break
					}
				}
			}
			default_index_ = default_index
			// this._list_tab_con.selectedIndex = default_index
			this.array_tab.SetSelectIndex(default_index)
		}

		this.UpdateItem = () => {
			let data = base_model.GetWaveRewardData(now_dun_id_)
			let list = []
			if (data) {
				let wave_list = data.list
				for (let _tmpi in wave_list) {
					var vo = wave_list[_tmpi]
					if (vo.reward.length > 0) {
						table.insert(list, vo)
					}
				}
			}
			table.sort(list, (a?, b?) => {
				if (a.state == b.state) {
					return a.wave < b.wave
				}
				return a.state < b.state
			}
			)

			if (!this.array_item) {
				this.array_item = new LoopScrowViewMgr()
				this.array_item.SetData(this.Content1, DungeonDragonAchiItem, list, LoopScrCon.Vertical)
			} else {
				this.array_item.replaceAll(list)
			}


		}

		this.SwitchTabFunc = (item?) => {
			this.SwitchTab(item)
		}

		this.SwitchTab = (index?) => {
			if (index == null) {
				index = default_index_
			}
			if (now_index_ == index) {
				return
			}
			// [ts2lua]this.array_tab.source下标访问可能不正确
			// let data = this.array_tab.source[index]
			let data = this.array_tab.data_list[index]
			if (data) {
				now_dun_id_ = data.dun_id
				// this._list_item_con.scrollV = 0
				this.UpdateItem()
			}
			now_index_ = index
		}

		this.InitEvent = () => {
			// this._list_tab_con.addEventListener(Laya.ItemTapEvent.ITEM_TAP, this.SwitchTabFunc, this)
			this.BindEvent(base_model, BaseDungeonModel.UPDATE_WAVE_REWARD_DATA, (dun_id?) => {
				if (dun_id == now_dun_id_) {
					this.UpdateItem()
				}
			}
			)
			Util.AddClickEvent(this._img_close, () => {
				this.Close()
			}
				, this, true, null, null, null, null, LuaSoundManager.SOUND_UI.CLOSE)

		}

		this.Remove = () => {
			// if (this._list_tab_con ) {
			// 	this._list_tab_con.removeEventListener(Laya.ItemTapEvent.ITEM_TAP, this.SwitchTabFunc, this)
			// }
			default_index_ = null
			now_index_ = null

			if (this.array_tab) {
				this.array_tab.DeleteMe()
				this.array_tab = null
			}
			if (this.array_item) {
				this.array_item.DeleteMe()
				this.array_item = null
			}
		}

		this.InitView = () => {

		}
	}

	public Open(...new_args) {

		let parms = new_args
		this.Local_Open(parms)
	}

	public DeleteMe() {

		super.DeleteMe()
	}

	_img_bg: Laya.Image
	_Image2: Laya.Image
	_Image1: Laya.Image
	_Image3: Laya.Image
	_Image4: Laya.Image
	_Image5: Laya.Image
	Content1: Laya.List
	Content: Laya.List
	_Image6: Laya.Image
	_img_close: Laya.Image
	_Group1: Laya.Box
	_Label1: Laya.Label
	_Label2: Laya.Label
	_Label3: Laya.Label
	_Label4: Laya.Label
	_Image7: Laya.Image
	_Image8: Laya.Image
	_Image9: Laya.Image
	public GetComponents() {
		[
			this._img_bg,
			this._Image2,
			this._Image1,
			this._Image3,
			this._Image4,
			this._Image5,
			this.Content1,
			this.Content,
			this._Image6,
			this._img_close,
			this._Group1,
			this._Label1,
			this._Label2,
			this._Label3,
			this._Label4,
			this._Image7,
			this._Image8,
			this._Image9,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_Image2",
				"_Image1",
				"_Image3",
				"_Image4",
				"_Image5",
				"Content1",
				"Content",
				"_Image6",
				"_img_close",
				"_Group1",
				"_Label1",
				"_Label2",
				"_Label3",
				"_Label4",
				"_Image7",
				"_Image8",
				"_Image9",
			])
	}
}
window["DungeonDragonAchiView"] = DungeonDragonAchiView
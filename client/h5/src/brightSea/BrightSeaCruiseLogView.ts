import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { LuaSoundManager } from "../common/SoundManager"
import { table } from "../common/table"
import { BrightSeaEvent, BrightSeaModel } from "../commonModel/BrightSeaModel"
import { GameResPath } from "../util/GameResPath"
import { SetSizeDeltaY, Util } from "../util/Util"
import { BrightSeaCruiseLogItem } from "./BrightSeaCruiseLogItem"

export class BrightSeaCruiseLogView extends BaseView1 {
	InitEvent
	LoadSuccess
	Scr_scroll_con
	UpdateView
	click_bg_toClose
	close_callback
	destroy_imm
	is_center
	item_list
	model
	open_callback
	use_background

	public constructor() {
		super()


		this.base_file = "brightSea"
		this.layout_file = "BrightSeaCruiseLogView"
		this.destroy_imm = true
		this.layer_value = Enum_UILayer.Activity
		this.is_center = true
		this.use_background = true
		this.click_bg_toClose = true
		this.preload_server_config = { "config_sea_treasure_reward": false }
		this.model = BrightSeaModel.GetInstance()
		this.item_list = null

		let local_event = BrightSeaEvent

		this.load_callback = () => {
			ResManager.GetInstance().SetOutsideImageSprite(this,this._Image4,GameResPath.GetIcon("common2","com_line_5"))
			ResManager.GetInstance().SetOutsideImageSprite(this,this._Image5,GameResPath.GetIcon("common2","com_line_5"))
			this.InitEvent()
			this.LoadSuccess()
		}

		this.open_callback = () => {
			this.model.Fire(local_event.REQUEST_PROTO, 18901)
		}

		this.close_callback = () => {
			if (this.item_list) {
				this.item_list.DeleteMe()
				this.item_list = null
			}
		}

		this.LoadSuccess = () => {
			ResManager.GetInstance().SetOutsideImageSprite(this, this._Image1, GameResPath.GetIconOtherPath("brightSea", "ui_bright_02"))
			ResManager.GetInstance().SetImageSpriteTrans(this, this._Image2, GameResPath.GetIcon("brightSea", "uixhrz_005"))
			this.UpdateView()
		}

		this.InitEvent = () => {
			this.BindVar(this.model, "curise_log_list", () => {
				this.UpdateView()
			})
			Util.AddClickEvent(this._close_btn, () => {
				this.Close()
			}, this, true, null, null, null, null, LuaSoundManager.SOUND_UI.CLOSE)

			Util.AddClickEvent(this._close_btn, () => {
				this.Close()
			}, this, true)
		}

		this.UpdateView = () => {
			let list = this.model.curise_log_list //or this.model.BrightTestData.log_list
			if (!list) {
				return
			}

			let len = list.length
			this._con_empty.visible = len < 1
			if (len > 0) {
				table.sort(list, (a?, b?) => {
					return b.time < a.time
				})

				if (!this.item_list) {
					this.item_list = new LoopScrowViewMgr()
					this.item_list.SetData(this._gp_item_con, BrightSeaCruiseLogItem, list,LoopScrCon.Vertical)
				} else {
					this.item_list.replaceAll(list)
				}
			}
		}
	}

	public DeleteMe(){
		super.DeleteMe()
	}


_Image1:Laya.Image
_close_btn:Laya.Image
_Image2:Laya.Image
_Image3:Laya.Image
_Image4:Laya.Image
_Image5:Laya.Image
_gp_item_con:Laya.List
_con_empty:Laya.Box
label:Laya.Label
img:Laya.Image
public GetComponents() {
[
this._Image1,
this._close_btn,
this._Image2,
this._Image3,
this._Image4,
this._Image5,
this._gp_item_con,
this._con_empty,
this.label,
this.img,
]
 = this.GetChildrenByNames([

"_Image1",
"_close_btn",
"_Image2",
"_Image3",
"_Image4",
"_Image5",
"_gp_item_con",
"_con_empty",
"label",
"img",
])
}
}
 window["BrightSeaCruiseLogView"]= BrightSeaCruiseLogView
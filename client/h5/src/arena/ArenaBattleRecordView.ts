import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { LuaSoundManager } from "../common/SoundManager"
import { table } from "../common/table"
import { ArenaModel } from "../commonModel/ArenaModel"
import { Util } from "../util/Util"
import { ArenaBattleRecordItem } from "./ArenaBattleRecordItem"

export class ArenaBattleRecordView extends BaseView1 {
	_Image1: Laya.Image
	_img_close: Laya.Image
	_Image2: Laya.Image
	_Image3: Laya.Image
	_Image4: Laya.Image
	_Group1: Laya.Box
	_Image5: Laya.Image
	_Label1: Laya.Label
	_Image6: Laya.Image
	_Label2: Laya.Label
	_Image7: Laya.Image
	_Label3: Laya.Label
	_Scroller1: Laya.List
	_lb_tips: Laya.Label
	_gp_close: Laya.Box
	_Image8: Laya.Image
	_Label4: Laya.Label
	Emp_gp_close
	InitEvent
	Scr_Scroller1
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


		this.base_file = "arena"
		this.layout_file = "ArenaBattleRecordView"
		this.destroy_imm = true
		this.layer_value = Enum_UILayer.Activity
		this.is_center = true
		this.use_background = true
		this.click_bg_toClose = true

		this.model = ArenaModel.GetInstance()
		this.item_list = null

		let local_ArenaModel = ArenaModel

		this.load_callback = () => {

			this.InitEvent()
		}

		this.open_callback = () => {
			ArenaModel.GetInstance().Fire(local_ArenaModel.REQUEST_CCMD_EVENT, 28009)
		}

		this.close_callback = () => {
			if (this.item_list) {
				this.item_list.DeleteMe()
				this.item_list = null
			}
		}

		this.InitEvent = () => {
			this.BindEvent(this.model, local_ArenaModel.UPDATE_RECORD, () => {
				this.UpdateView()
			}
			)
			Util.AddClickEvent(this._img_close, () => {
				this.Close()
			}, this, true, null, null, null, null, LuaSoundManager.SOUND_UI.CLOSE)

			Util.AddClickEvent(this._gp_close, () => {
				this.Close()
			}, this, true)
		}

		this.UpdateView = () => {
			let list = this.model.record_list
			let len = list.length
			this._lb_tips.visible = len == 0

			if (len > 0) {
				table.sort(list, (a?, b?) => {
					return b.time < a.time
				})
				if(!this.item_list){
					this.item_list = new LoopScrowViewMgr()
					this.item_list.SetData(this._Scroller1, ArenaBattleRecordItem, list, LoopScrCon.Vertical, 1)
				}else{
					this.item_list.replaceAll(list)
				}

			}
		}


	}


	public GetComponents() {
		[
			this._Image1,
			this._img_close,
			this._Image2,
			this._Image3,
			this._Image4,
			this._Group1,
			this._Image5,
			this._Label1,
			this._Image6,
			this._Label2,
			this._Image7,
			this._Label3,
			this._Scroller1,
			this._lb_tips,
			this._gp_close,
			this._Image8,
			this._Label4,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_img_close",
				"_Image2",
				"_Image3",
				"_Image4",
				"_Group1",
				"_Image5",
				"_Label1",
				"_Image6",
				"_Label2",
				"_Image7",
				"_Label3",
				"_Scroller1",
				"_lb_tips",
				"_gp_close",
				"_Image8",
				"_Label4",
			])
		this._Scroller1.scrollBar.visible=false
	}
}
window["ArenaBattleRecordView"]=ArenaBattleRecordView
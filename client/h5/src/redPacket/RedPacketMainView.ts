import { BaseItem1 } from "../common/BaseItem1"
import { BaseView1 } from "../common/BaseView1"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { LuaSoundManager } from "../common/SoundManager"
import { table } from "../common/table"
import { ColorType, ColorUtil, Enum_ColorUtil_NEW } from "../util/ColorUtil"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { Color, SetSizeDelta, Util } from "../util/Util"
import { RedPacketFuncItem } from "./RedPacketFuncItem"
import { RedPacketMainItem } from "./RedPacketMainItem"
import { RedPacketEvent, RedPacketModel } from "../commonModel/RedPacketModel"
import { RedPacketRecordItem } from "./RedPacketRecordItem"

export class RedPacketMainView extends BaseView1 {
	Clear
	InitEvent
	LoadSuccess
	SwitchBar
	UpdateView
	_list_func
	_list_packet
	click_bg_toClose
	destroy_callback
	destroy_imm
	form
	is_center
	item_record_list
	preload_server_config
	use_background
	_btn_list_: [Laya.Box, Laya.Image, Laya.Label]
	_model
	public constructor(parent?) {
		super()
		this._model = RedPacketModel.GetInstance()
		this.base_file = "redPacket"
		this.layout_file = "RedPacketMainView"
		this.layer_value = Enum_UILayer.Activity
		this.is_center = true
		this.use_background = true
		this.click_bg_toClose = true
		this.destroy_imm = true

		let _ac_packet_ = null
		let _ac_record_ = null
		let _ac_func_ = null
		let _btn_list_ = null

		let _cur_index_ = -1
		this.item_record_list = []
		this.load_callback = () => {
			this._Scroller2.vScrollBarSkin=""
			this.InitEvent()
			this.LoadSuccess()
			// if (PlatformMgr.GetInstance().IsEyouIdnPlatform()) {
			// 	this._lb_record.size = 18
			// 	this._lb_func.size = 18
			// }

			_cur_index_ = -1
			this.SwitchBar(0)
		}

		this.destroy_callback = () => {
			this.Clear()
		}

		this.preload_server_config = { "config_red_envelopes": false }
		this.Clear = () => {
			if (this._list_packet) {
				this._list_packet.DeleteMe()
				this._list_packet = null
			}

			if (this._list_func) {
				this._list_func.DeleteMe()
				this._list_func = null
			}
			for (let i = 0; i < this.item_record_list.length; i++) {
				var v = this.item_record_list[i]
				v.DeleteMe()
			}
			this.item_record_list = []

		}

		this.LoadSuccess = () => {

			this._model.redMark = false
			this._model.Fire(RedPacketEvent.REQUEST_PROTO, 33901)

			if(!this._list_func){
				this._list_func = new LoopScrowViewMgr()
				this._list_func.SetData(this.Content1, RedPacketFuncItem, this._model.RedPacketFunc, LoopScrCon.Vertical)
				this.Content1.scrollBar.touchScrollEnable = false
			}else{
				this._list_func.replaceAll(this._model.RedPacketFunc)
			}
			
			

			_btn_list_ = []
			for (let i = 0; i < this._gp_btn.numChildren; i++) {
				let btn: any = this._gp_btn.getChildAt(i)
				let img = btn.getChildAt(0)//.gameObject.GetComponent("Image")
				let label = btn.getChildAt(1)//.gameObject.GetComponent("Text")
				//let outline = btn.GetChild(1).gameObject.GetComponent("Outline")
				_btn_list_[i] = [btn, img, label]//, outline = outline]
				Util.AddClickEvent(btn, () => {
					this.SwitchBar(i)
				}, this)
			}
		}

		this.InitEvent = () => {
			this.BindVar(this._model, "_rp_info", () => {
				if (_cur_index_ < 0) {
					let info = this._model.GetRedPacketInfo()
					// [ts2lua]lua中0和空字符串也是true，此处info.record_list.length > 0需要确认
					let index = (info.record_list.length > 0 && (0) || (1))
					this.SwitchBar(index)
				}
				this.UpdateView()
			}
			)
			Util.AddClickEvent(this._btn_close, () => {
				this.Close()
				//this._model.Fire(RedPacketEvent.CLOSE_VIEW, "RedPacketMainView")
			}
				, this, true, null, null, null, null, LuaSoundManager.SOUND_UI.CLOSE)
			Util.AddClickEvent(this._btn_help, () => {
				GlobalEventSystem.Fire(EventName.OPEN_INSTRUCTION_VIEW, 339)
			}
				, this, true)
		}

		this.UpdateView = () => {
			let info = this._model.GetRedPacketInfo()
			if (!info) {
				return
			}

			if (!this._list_packet) {
				this._list_packet = new LoopScrowViewMgr()
				this._list_packet.SetData(this.Content, RedPacketMainItem, info.red_envelopes_list, LoopScrCon.Vertical)
			} else {
				this._list_packet.replaceAll(info.red_envelopes_list)
			}

			if(info.record_list){
				for (let i = 0; i < info.record_list.length; i++) {
					var v = info.record_list[i]
					this.item_record_list[i] = this.item_record_list[i] || new RedPacketRecordItem(this.Content11)
					this.item_record_list[i].Load()
					this.item_record_list[i].SetData(v)
				}
			}
		
		}

		this.SwitchBar = (index?) => {
			if (_cur_index_ == index) {
				return
			}
			//未选中
			// [ts2lua]_btn_list_下标访问可能不正确
			let old_btn = _btn_list_[_cur_index_]
			if (old_btn) {
				ResManager.GetInstance().SetImageSprite(this, old_btn[1], "common2", "uian_003c")
				old_btn[1].height=57
				old_btn[2].color = Enum_ColorUtil_NEW.WHITE
				old_btn[2].strokeColor = Enum_ColorUtil_NEW.WHITE
			}

			//选中
			_cur_index_ = index
			// [ts2lua]_btn_list_下标访问可能不正确
			let new_btn = _btn_list_[_cur_index_]
			if (new_btn) {
				ResManager.GetInstance().SetImageSprite(this, new_btn[1], "common2", "uian_003a")
				new_btn[1].height=62
				new_btn[2].color = Enum_ColorUtil_NEW.RED_GRAY
				new_btn[2].strokeColor = Enum_ColorUtil_NEW.RED_GRAY
			}
			// this._viewStack.selectedIndex = index
			//console.log("1111111", this._viewStack.numChildren, index)
			for (let i = 0; i < this._viewStack.numChildren; i++) {
				let child: any = this._viewStack.getChildAt(i)
				child.visible = false
			}
			(this._viewStack.getChildAt(index) as any).visible = true
		}
	}

	public DeleteMe() {
		for (let i = 0; i < this.item_record_list.length; i++) {
			this.item_record_list[i].DeleteMe();
		}
		this.item_record_list=[]
		super.DeleteMe()
	}


	_img_bg: Laya.Image
	_Group1: Laya.Box
	_btn_close: Laya.Image
	_Image4: Laya.Image
	_Image5: Laya.Image
	_Image6: Laya.Image
	_Scroller1: Laya.Panel
	Content: Laya.List
	_gp_btn: Laya.Box
	_btn_record: Laya.Box
	_img_record: Laya.Image
	_lb_record: Laya.Label
	_btn_func: Laya.Box
	_img_func: Laya.Image
	_lb_func: Laya.Label
	_viewStack: Laya.Box
	_Group2: Laya.Box
	_Scroller2: Laya.Panel
	Content11: Laya.VBox
	_Group3: Laya.Box
	Content1: Laya.List
	_btn_help: Laya.Image
	_Image2: Laya.Image
	_lb_win_name: Laya.Label
	public GetComponents() {
		[
			this._img_bg,
			this._Group1,
			this._btn_close,
			this._Image4,
			this._Image5,
			this._Image6,
			this._Scroller1,
			this.Content,
			this._gp_btn,
			this._btn_record,
			this._img_record,
			this._lb_record,
			this._btn_func,
			this._img_func,
			this._lb_func,
			this._viewStack,
			this._Group2,
			this._Scroller2,
			this.Content11,
			this._Group3,
			this.Content1,
			this._btn_help,
			this._Image2,
			this._lb_win_name,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_Group1",
				"_btn_close",
				"_Image4",
				"_Image5",
				"_Image6",
				"_Scroller1",
				"Content",
				"_gp_btn",
				"_btn_record",
				"_img_record",
				"_lb_record",
				"_btn_func",
				"_img_func",
				"_lb_func",
				"_viewStack",
				"_Group2",
				"_Scroller2",
				"Content11",
				"_Group3",
				"Content1",
				"_btn_help",
				"_Image2",
				"_lb_win_name",
			])
	}
}

window["RedPacketMainView"]=RedPacketMainView
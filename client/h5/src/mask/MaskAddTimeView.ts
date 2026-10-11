import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseView1 } from "../common/BaseView1"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { MaskModel } from "../commonModel/MaskModel"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { Util } from "../util/Util"

export class MaskAddTimeView extends BaseView1 {
	_Image1: Laya.Image
	_Image2: Laya.Image
	_Image3: Laya.Image
	_btn_close: Laya.Image
	_btn_sub: Laya.Image
	_btn_add: Laya.Image
	_btn_max: Laya.Image
	_Image4: Laya.Image
	_lb_count: Laya.Label
	_Image5: Laya.Image
	_Image6: Laya.Image
	_btn_help: Laya.Image
	_Label1: Laya.Label
	_lb_time: Laya.Label
	_btn_cancel: Laya.Box
	_Image7: Laya.Image
	_Label2: Laya.Label
	_btn_go: Laya.Box
	_Image8: Laya.Image
	_Label3: Laya.Label
	_gp_item: Laya.Box
	award_item
	destroy_callback
	destroy_imm
	goods_vo
	is_center
	mask_model
	num_cur
	num_max
	time_gap
	use_background


	public constructor() {
		super()

		this.base_file = "mask"
		this.layout_file = "MaskAddTimeView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.use_background = true
		this.is_center = true
		this.mask_model = MaskModel.GetInstance()

		this.award_item = null
		this.goods_vo = null
		this.num_max = 0
		this.num_cur = 0
		this.time_gap = 0
		this.preload_server_config = {
			"config_mask": false
		}
		this.load_callback = () => {
			this.LoadSuccess()
			// if (PlatformMgr.GetInstance().IsEyouIdnPlatform() ) {
			// 	this._Label1.size  = 18
			// 	this._lb_time.size  = 18
			// 	SetAnchoredPositionX(this._lb_time,350)
			// }
		}

		this.destroy_callback = () => {
			this.Clear()
		}
	}

	public Clear() {

		if (this.award_item) {
			this.award_item.DeleteMe()
			this.award_item = null
		}
	}

	public InitEvent() {


		Util.AddClickEvent(this._btn_close, () => {
			this.Close()
		}
			, this, true)

		Util.AddClickEvent(this._btn_sub, () => {
			let tar_num = this.num_cur - 1
			if (tar_num < 0) {
				Message.show("已经是最小数量")
			} else {
				this.num_cur = tar_num
				this.ChangeCount()
			}
		}
			, this, true)

		Util.AddClickEvent(this._btn_add, () => {
			let tar_num = this.num_cur + 1
			if (tar_num > this.num_max) {
				Message.show("已经是最大数量")
			} else {
				this.num_cur = tar_num
				this.ChangeCount()
			}
		}
			, this, true)

		Util.AddClickEvent(this._btn_max, () => {
			this.num_cur = this.num_max
			this.ChangeCount()
		}
			, this, true)

		Util.AddClickEvent(this._btn_cancel, () => {
			this.Close()
		}
			, this, true)

		Util.AddClickEvent(this._btn_go, () => {
			if (this.num_cur <= 0) {
				Message.show("至少需要使用1张变身卡")
			} else {
				GoodsModel.GetInstance().Fire(GoodsModel.USE_BAG_GOODS, this.goods_vo.goods_id, this.num_cur)
			}
		}
			, this, true)

		Util.AddClickEvent(this._btn_help, () => {
			GlobalEventSystem.Fire(EventName.OPEN_INSTRUCTION_VIEW, 511)
		}
			, this, true)

		this.BindEvent(this.mask_model, MaskModel.UPDATE_INFO, (info?) => {
			if (info.end_time > 0) {
				this.mask_model.ShowUseMsg()
				this.Close()
			}
		}
		)
	}

	public LoadSuccess() {


		let own = this.goods_vo && this.goods_vo.goods_num || 0
		this.num_max = own
		if (!this.award_item) {
			this.award_item = new BaseAwardItem(this._gp_item)
			this.award_item.Load()
			this.award_item.SetItemSize(74, 74)
		}
		this.award_item.SetData(MaskModel.ITEM_ID, own)
		let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_mask", false)
		this.time_gap = cfg[1].duration
		this.ChangeCount()
		this.InitEvent()
	}

	public ChangeCount() {

		this._lb_count.text = String(this.num_cur)
		let time = this.num_cur * this.time_gap
		this._lb_time.text = time / 60 + "分钟"
	}

	public Open(...new_args) {

		let parms = new_args
		this.goods_vo = parms[0]
		super.Open()
	}



	public GetComponents() {
		[
			this._Image1,
			this._Image2,
			this._Image3,
			this._btn_close,
			this._btn_sub,
			this._btn_add,
			this._btn_max,
			this._Image4,
			this._lb_count,
			this._Image5,
			this._Image6,
			this._btn_help,
			this._Label1,
			this._lb_time,
			this._btn_cancel,
			this._Image7,
			this._Label2,
			this._btn_go,
			this._Image8,
			this._Label3,
			this._gp_item,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_Image2",
				"_Image3",
				"_btn_close",
				"_btn_sub",
				"_btn_add",
				"_btn_max",
				"_Image4",
				"_lb_count",
				"_Image5",
				"_Image6",
				"_btn_help",
				"_Label1",
				"_lb_time",
				"_btn_cancel",
				"_Image7",
				"_Label2",
				"_btn_go",
				"_Image8",
				"_Label3",
				"_gp_item",
			])
	}
}
window["MaskAddTimeView"] = MaskAddTimeView
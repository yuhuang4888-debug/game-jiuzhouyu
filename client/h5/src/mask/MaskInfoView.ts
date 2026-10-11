import { Alert, Alert_Type } from "../alert/Alert"
import { BaseView1 } from "../common/BaseView1"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { MaskModel } from "../commonModel/MaskModel"
import { Enum_ColorUtil_Dark, Enum_ColorUtil_Light } from "../util/ColorUtil"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest, HtmlColorTxt, Util } from "../util/Util"

export class MaskInfoView extends BaseView1 {

	end_time
	mask_model
	timer_id

	public constructor() {
		super()

		this.base_file = "mask"
		this.layout_file = "MaskInfoView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.use_background = true
		this.is_center = true
		this.click_bg_toClose = true
		this.show_open_movie = true
		this.mask_model = MaskModel.GetInstance()


		this.timer_id = null
		this.end_time = 0
		this.load_callback = () => {
			this.LoadSuccess()
			// if (PlatformMgr.GetInstance().IsEyouIdnPlatform() ) {
			// 	this._Label1.size  = 18
			// 	this._lb_time.size  = 18
			// 	this._lb_tips.size  = 15
			// }
		}

		this.destroy_callback = () => {
			this.ClearTimer()
		}

	}

	public InitEvent() {


		Util.AddClickEvent(this._btn_close, () => {
			this.Close()
		}, this, true)

		Util.AddClickEvent(this._btn_cancel, () => {
			let str1 = "是否确认取消蒙面人变身效果?<br>"
			let str2 = HtmlColorTxt("取消后会清空变身时间", Enum_ColorUtil_Dark.GREEN)
			Alert.Show(Util.StrToHTML(str1 + str2), Alert_Type.Two, () => {
				this.mask_model.Fire(MaskModel.REQUEST_PROTO, 51102)
			}
			)
		}, this, true)

		Util.AddClickEvent(this._btn_add, () => {
			let goods_vo = GoodsModel.GetInstance().GetBindGoodsVoFirstByTypeId(MaskModel.ITEM_ID)
			GlobalEventSystem.Fire(EventName.OPEN_VIEW, "MaskAddTimeView", goods_vo)
		}, this, true)

		this.BindEvent(this.mask_model, MaskModel.UPDATE_INFO, () => {
			this.UpdateView()
		}
		)
	}

	public LoadSuccess() {
		ResManager.GetInstance().SetImageSprite(this, this._img_buff, "bufficon", "mengmr")
		//lua_resM:SetOutsideImageSprite(this, this._img_buff, "resource/game/icon/bufficon/mengmr.png")
		this.UpdateView()
		this.InitEvent()
	}

	public UpdateView() {

		let info = this.mask_model.GetMaskInfo()
		if (!info) {
			return
		}
		this.end_time = info.end_time
		this.StartTimer(() => {
			let rtime = this.end_time - TimeUtil.getServerTime()
			if (rtime > 0) {
				this._lb_time.text = TimeUtil.timeConvert(rtime, "hh/mm/ss")
			} else {
				this.ClearTimer()
				this.Close()
			}

		})
	}

	public StartTimer(func?) {

		this.ClearTimer()
		this.timer_id = GlobalTimerQuest.AddPeriodQuest(func, 1, -1)
		func()
	}

	public ClearTimer() {

		if (this.timer_id) {
			GlobalTimerQuest.CancelQuest(this.timer_id)
			this.timer_id = null
		}
	}


	_Image1: Laya.Image
	_Image2: Laya.Image
	_Image3: Laya.Image
	_btn_close: Laya.Image
	_Image5: Laya.Image
	_img_buff: Laya.Image
	_btn_add: Laya.Image
	_Label1: Laya.Label
	_lb_time: Laya.Label
	_lb_tips: Laya.Label
	_btn_cancel: Laya.Box
	_Image7: Laya.Image
	_Label2: Laya.Label
	_lb_title: Laya.Label
	public GetComponents() {
		[
			this._Image1,
			this._Image2,
			this._Image3,
			this._btn_close,
			this._Image5,
			this._img_buff,
			this._btn_add,
			this._Label1,
			this._lb_time,
			this._lb_tips,
			this._btn_cancel,
			this._Image7,
			this._Label2,
			this._lb_title,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_Image2",
				"_Image3",
				"_btn_close",
				"_Image5",
				"_img_buff",
				"_btn_add",
				"_Label1",
				"_lb_time",
				"_lb_tips",
				"_btn_cancel",
				"_Image7",
				"_Label2",
				"_lb_title",
			])
	}
}
window["MaskInfoView"] = MaskInfoView
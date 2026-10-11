import { BaseView1 } from "../common/BaseView1"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { DepositModel } from "../commonModel/DepositModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { SetAnchoredPosition, Util } from "../util/Util"

export class DepositExchangeView extends BaseView1 {

	model:DepositModel
	cur_value
	public constructor() {
		super()
		this.base_file = "deposit"
		this.layout_file = "DepositExchangeView"
		this.layer_value = Enum_UILayer.UI
		this.destroy_imm = true
		this.use_background = true
		this.click_bg_toClose = true
		this.is_center = true
		this.model = DepositModel.GetInstance()
		this.cur_value = 0

		this.load_callback = () => {
			this.InitEvent()
			// ResManager.GetInstance().SetOutsideImageSprite(this, this.img5, GameResPath.GetIcon("deposit", "uirwv4_007"))
			this.UpdateView()
		}

		this.destroy_callback = () => {
			this.Clear()
		}
	}

	public InitEvent() {

		var onClickBtnHandler = (target, x, y) => {
			let btn = target.currentTarget
			if (btn == this.img_sub) {
				this.SetValue(this.cur_value - 2)
			} else if (btn == this.img_add) {
				this.SetValue(this.cur_value + 2)
			} else if (btn == this.img_exchange) {
				if (this.cur_value > 0) {
					this.model.Fire(DepositModel.REQUEST_CCMD_EVENT, 19207, this.cur_value)
				}
			} else if (btn == this.txt_value) {
				this.OpenCalculatorView()
			} else if (btn == this.close) {
				this.Close()
			}
		}
		Util.AddClickEvent(this.img_sub, onClickBtnHandler, this, true)
		Util.AddClickEvent(this.img_add, onClickBtnHandler, this, true)
		Util.AddClickEvent(this.img_exchange, onClickBtnHandler, this, true)
		Util.AddClickEvent(this.txt_value, onClickBtnHandler, this, true)
		Util.AddClickEvent(this.close, onClickBtnHandler, this, true)

		this.BindEvent(this.model, DepositModel.UPDATE_DEPOSIT_VALUE, (value?) => {
			this.UpdateView()
		})
	}

	public OpenCalculatorView() {

		let pos = [20, -30]
		let change_func = (value?) => {
			this.SetValue(value)
		}

		GlobalEventSystem.Fire(EventName.OPEN_CALCULATOR_VIEW, 9999, change_func, pos)
		this.SetValue(0)
	}

	public SetValue(value?) {

		if (!this.is_loaded) {
			return
		}
		value = Math.max(value, 0)
		value = Math.min(value, this.model.GetDepositValue())
		if (value % 2 != 0) {
			value = value - 1
		}
		this.cur_value = value
		this.txt_value.text = value
		this.txt_diamond.text = String(value / 2)
		this.Layout()
	}

	public UpdateView() {
		this.txt_deposit.text = this.model.GetDepositValue()
		this.SetValue(0)
		this.Layout()
	}

	public Layout() {
		this.group1.refresh()
		// LayoutRebuilder(this.group1)
		// LayoutRebuilder(this.group2)
	}

	public Open() {
		super.Open()
		this.cur_value = 0
	}

	public Clear() {


	}

	bg: Laya.Image
	img4: Laya.Image
	img1: Laya.Image
	img61: Laya.Image
	txt1: Laya.Label
	img2: Laya.Image
	txt_value: Laya.Label
	img_sub: Laya.Image
	img_add: Laya.Image
	img5: Laya.Image
	group1: Laya.HBox
	txt2: Laya.Label
	txt_diamond: Laya.Label
	img6: Laya.Image
	group2: Laya.HBox
	txt3: Laya.Label
	txt_deposit: Laya.Label
	close: Laya.Image
	img_exchange: Laya.Box
	img11: Laya.Image
	txt4: Laya.Label
	public GetComponents() {
		[
			this.bg,
			this.img4,
			this.img1,
			this.img61,
			this.txt1,
			this.img2,
			this.txt_value,
			this.img_sub,
			this.img_add,
			this.img5,
			this.group1,
			this.txt2,
			this.txt_diamond,
			this.img6,
			this.group2,
			this.txt3,
			this.txt_deposit,
			this.close,
			this.img_exchange,
			this.img11,
			this.txt4,
		]
			= this.GetChildrenByNames([

				"bg",
				"img4",
				"img1",
				"img61",
				"txt1",
				"img2",
				"txt_value",
				"img_sub",
				"img_add",
				"img5",
				"group1",
				"txt2",
				"txt_diamond",
				"img6",
				"group2",
				"txt3",
				"txt_deposit",
				"close",
				"img_exchange",
				"img11",
				"txt4",
			])
	}
}
window["DepositExchangeView"] = DepositExchangeView
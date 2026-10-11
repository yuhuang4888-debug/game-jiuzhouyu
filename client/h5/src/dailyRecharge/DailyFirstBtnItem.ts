import { BaseItem1 } from "../common/BaseItem1"
import { ResManager } from "../common/ResManager"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { PlatformManager } from "../PlatformManager"
import { Color, TransformCurrency } from "../util/Util"
export class DailyFirstBtnItem extends BaseItem1 {
	_Image1: Laya.Image
	_img_select: Laya.Image
	_lb_text1: Laya.Label
	_Group1: Laya.HBox
	_img_num: Laya.Image
	_lb_text2: Laya.Label
	_img_red: Laya.Image
	_lb_text3: Laya.Label
	Out_lb_text1
	Out_lb_text2
	grade
	is_red
	is_select
	refresh

	public constructor(parent?) {
		super(parent)


		this.base_file = "dailyRecharge"
		this.layout_file = "DailyFirstBtnItem"
		this.load_callback = () => {

			// if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
			// 	this._lb_text1.size  = 16
			// 	this._lb_text2.size  = 16
			// 	this._lb_text2.text = ""
			// }
			// if (PlatformMgr.GetInstance().IsEyouIdnPlatform() ) {
			// 	this._lb_text1.size  = 16
			// 	this._lb_text2.size  = 14
			// }
			this.InitView()
			this.InitEvent()
		}


	}

	public InitEvent() {


		this.BindEvent(CustomActivityModel.GetInstance(), CustomActivityDefine.EVENT.DAILYFRIST_SELECT, (is_select?, grade?) => {
			if (grade != this.grade) {
				this.is_select = false
			} else {
				this.is_select = true
			}
			this.SwicthView(this.is_select)
		}
		)
	}

	public InitView() {

		if (this.grade) {
			this.ShowView(this.is_select, this.grade)
		}

		if (this.refresh) {
			this.refresh = false
			this.SetRedDot(this.is_red)
		}
	}

	public SetData(is_select?, grade?) {


		this.is_select = is_select
		this.grade = grade
		this.ShowView(is_select, grade)

	}

	public SetRedDot(bool?) {

		if (this.is_loaded) {
			this._img_red.visible = bool
		} else {
			this.is_red = bool
			this.refresh = true
		}
	}

	public ShowView(is_select?, grade?) {


		this.SwicthView(is_select)
		// [ts2lua]lua中0和空字符串也是true，此处grade + 7 > 9需要确认
		let load_func = () => {
			// LayoutRebuilder(this._img_num)
			// LayoutRebuilder(this._Group1)
		}
		let count = 6
		if (grade == 1)
			count = 30
		else if (grade == 2)
			count = 128
		if (PlatformManager.IsEyouPlatform()) {
			this._lb_text3.text = String(TransformCurrency(count*10))+"Jade"
		} else {
		this._lb_text3.text = String(count)
		}
		//ResManager.GetInstance().SetImageSprite(this, this._img_num, "dailyRecharge_asset", "mrsc_0" + ((grade + 1 + 7) > 9 ? (grade + 1 + 7) : ("0" + ((grade + 1 + 7)))), true, load_func)
		//this._img_num.source = "dailyRecharge_asset.mrsc_0" + ((grade + 7) > 9 && ( grade + 7 ) || ( "0" + (grade + 7) ) ) + ""

	}

	public SwicthView(is_select?) {


		this._img_select.visible = is_select
		let color = is_select && Color(194 / 255, 102 / 255, 62 / 255, 128 / 255) || Color(169 / 255, 136 / 255, 91 / 255, 128 / 255)
		// this._lb_text1.strokeColor = color
		// this._lb_text2.strokeColor = color
		// [ts2lua]lua中0和空字符串也是true，此处is_select需要确认
		//this._lb_text1.strokeColor = (is_select && ( "#c2663e" ) || ( "#a9885b" ) )
		//// [ts2lua]lua中0和空字符串也是true，此处is_select需要确认
		//this._lb_text2.strokeColor = (is_select && ( "#c2663e" ) || ( "#a9885b" ) )
	}



	public GetComponents() {
		[
			this._Image1,
			this._img_select,
			this._lb_text1,
			this._Group1,
			this._img_num,
			this._lb_text2,
			this._img_red,
			this._lb_text3
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_img_select",
				"_lb_text1",
				"_Group1",
				"_img_num",
				"_lb_text2",
				"_img_red",
				"_lb_text3"
			])
	}
}
window["DailyFirstBtnItem"] = DailyFirstBtnItem
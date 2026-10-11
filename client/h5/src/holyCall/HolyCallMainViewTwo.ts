import { HolyCallMainView } from "./HolyCallMainView"

export class HolyCallMainViewTwo extends HolyCallMainView {

	public constructor(parent?) {
		super(parent)
		this._pos_list = [{ size: 65, count: 2 }, { size: 65, count: 4 }, { size: 65, count: 6 }]
		this.base_file = "holyCall"
		this.layout_file = "HolyCallMainViewTwo"
	}

	_img_left: Laya.Image
	_img_right: Laya.Image
	_lb_tips: Laya.Label
	_gp_record: Laya.Box
	_img0: Laya.Image
	_btn_ten: Laya.Box
	_btn_one: Laya.Box
	_Scroller1: Laya.List
	_img_rare: Laya.Image
	itemGp1: Laya.HBox
	itemGp2: Laya.HBox
	itemGp3: Laya.HBox
	_time: Laya.Box
	_Scroller2: Laya.List
	_btn_rare: Laya.Image
	_Image6: Laya.Image
	_lb_rare: Laya.Label
	_red: Laya.Image
	_effect_rare: Laya.Box
	public GetComponents() {
		[
			this._img_left,
			this._img_right,
			this._lb_tips,
			this._gp_record,
			this._img0,
			this._btn_ten,
			this._btn_one,
			this._Scroller1,
			this._img_rare,
			this.itemGp1,
			this.itemGp2,
			this.itemGp3,
			this._time,
			this._Scroller2,
			this._btn_rare,
			this._Image6,
			this._lb_rare,
			this._red,
			this._effect_rare,
		]
			= this.GetChildrenByNames([
				"_img_left",
				"_img_right",
				"_lb_tips",
				"_gp_record",
				"_img0",
				"_btn_ten",
				"_btn_one",
				"_Scroller1",
				"_img_rare",
				"itemGp1",
				"itemGp2",
				"itemGp3",
				"_time",
				"_Scroller2",
				"_btn_rare",
				"_Image6",
				"_lb_rare",
				"_red",
				"_effect_rare",
			])
	}
}
window["HolyCallMainViewTwo"] = HolyCallMainViewTwo
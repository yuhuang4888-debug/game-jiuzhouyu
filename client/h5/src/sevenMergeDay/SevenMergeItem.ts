import { SevenDayItem } from "../sevenDay/SevenDayItem"

export class SevenMergeItem extends SevenDayItem {
	_gp_item: Laya.Box
	_gp_normal: Laya.Box
	_img_normal: Laya.Image
	_img_selected: Laya.Image
	_gp_special: Laya.Box
	_img_special: Laya.Image
	_img_good: Laya.Image
	_gp_num: Laya.Box
	_img_icon: Laya.Image
	_img_red: Laya.Image
	ray_gp_item
	public constructor(parent?) {
		super(parent)


		this.base_file = "sevenMergeDay"
		this.layout_file = "SevenMergeItem"
		this.load_callback = () => {

			super.LoadSuccess()
		}
	}



	public GetComponents() {
		[
			this._gp_item,
			this._gp_normal,
			this._img_normal,
			this._img_selected,
			this._gp_special,
			this._img_special,
			this._img_good,
			this._gp_num,
			this._img_icon,
			this._lb_day,
			this._img_red,
		]
			= this.GetChildrenByNames([

				"_gp_item",
				"_gp_normal",
				"_img_normal",
				"_img_selected",
				"_gp_special",
				"_img_special",
				"_img_good",
				"_gp_num",
				"_img_icon",
				"_lb_day",
				"_img_red",
			])
	}
}
window["SevenMergeItem"] = SevenMergeItem
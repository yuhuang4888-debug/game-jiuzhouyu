import { SevenDayItem } from "../sevenDay/SevenDayItem"
export class SevenEightDayItem extends SevenDayItem {
	_img_selected: Laya.Image
	_gp_item: Laya.Box
	_gp_normal: Laya.Box
	_img_normal: Laya.Image
	_img_good: Laya.Image
	_lb_count: Laya.Label
	_img_icon: Laya.Image
	_Group1: Laya.Box
	_lb_eight: Laya.Label
	_img_red: Laya.Image
	outlinet_lb_count
	ray_gp_item
	public constructor(parent?) {
		super(parent)


		this.base_file = "sevenDay"
		this.layout_file = "SevenEightDayItem"
		this.load_callback = () => {

			super.LoadSuccess()
		}
	}



	public GetComponents() {
		[
			this._img_selected,
			this._gp_item,
			this._gp_normal,
			this._img_normal,
			this._img_good,
			this._lb_count,
			this._img_icon,
			this._Group1,
			this._lb_eight,
			this._img_red,
		]
			= this.GetChildrenByNames([

				"_img_selected",
				"_gp_item",
				"_gp_normal",
				"_img_normal",
				"_img_good",
				"_lb_count",
				"_img_icon",
				"_Group1",
				"_lb_eight",
				"_img_red",
			])
	}
}
window["SevenEightDayItem"] = SevenEightDayItem
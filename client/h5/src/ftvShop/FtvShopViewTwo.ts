import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { FtvShopView } from "./FtvShopView"

export class FtvShopViewTwo extends FtvShopView {
	_Image11: Laya.Image
	_gp_time: Laya.Box
	_gp_item: Laya.Box
	_gp_desc: Laya.Box
	_Image2: Laya.Image
	_lb_desc: Laya.HTMLDivElement
	_Image3: Laya.Image
	_Group1: Laya.Box
	_Image4: Laya.Image
	_btn_last: Laya.Box
	_Image1: Laya.Image
	labelDisplay: Laya.Label
	_btn_next: Laya.Box
	_Image111: Laya.Image
	labelDisplay1: Laya.Label
	Emp_btn_last
	Emp_btn_next
	LoadSuccess


	public constructor(parent?) {
		super()


		this.base_file = "ftvShop"
		this.layout_file = "FtvShopViewTwo"

		this.LoadSuccess = () => {
			ResManager.GetInstance().SetOutsideImageSprite(this, this._Image11, GameResPath.GetIcon("ftvShop", "uiqgsc_003"), true)
		}
	}

	public GetComponents() {
		[
			this._Image11,
			this._gp_time,
			this._gp_item,
			this._gp_desc,
			this._Image2,
			this._lb_desc,
			this._Image3,
			this._Group1,
			this._Image4,
			this._btn_last,
			this._Image1,
			this.labelDisplay,
			this._btn_next,
			this._Image111,
			this.labelDisplay1,
		]
			= this.GetChildrenByNames([

				"_Image11",
				"_gp_time",
				"_gp_item",
				"_gp_desc",
				"_Image2",
				"_lb_desc",
				"_Image3",
				"_Group1",
				"_Image4",
				"_btn_last",
				"_Image1",
				"labelDisplay",
				"_btn_next",
				"_Image111",
				"labelDisplay1",
			])
	}
}
window["FtvShopViewTwo"] = FtvShopViewTwo
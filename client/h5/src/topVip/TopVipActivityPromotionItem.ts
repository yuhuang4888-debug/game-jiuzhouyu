import { BaseItem1 } from "../common/BaseItem1"
import { ResManager } from "../common/ResManager"
import { SetLocalScale } from "../util/Util"

export class TopVipActivityPromotionItem extends BaseItem1 {
	_bg_img: Laya.Image
	_Image1: Laya.Image
	_sure_img: Laya.Image
	_day_num_img: Laya.Image

	day
	need_refresh_data
	recharge

	public constructor(parent?) {
		super(parent)


		this.need_refresh_data = false;
		this.base_file = "topVip"
		this.layout_file = "TopVipActivityPromotionItem"
		this.load_callback = () => {

			this.LoadSuccess()
		}


	}

	public LoadSuccess() {

		if (this.need_refresh_data) {
			this.need_refresh_data = false
			this.UpdataView()
		}
	}

	public SetData(day?, recharge?) {

		this.day = day
		this.recharge = recharge
		if (this.is_loaded) {
			this.UpdataView()
		} else {
			this.need_refresh_data = true
		}
	}

	public SetScale(value?) {

		SetLocalScale(this.display_obj, value, value, 1)
	}

	public UpdataView() {

		if (this.recharge) {
			this._sure_img.visible = true
			ResManager.GetInstance().SetImageSprite(this, this._bg_img, "topVip_asset", "uizz_035_2", true)
			this._day_num_img.visible = false
		} else {
			this._sure_img.visible = false
			ResManager.GetInstance().SetImageSprite(this, this._bg_img, "topVip_asset", "uizz_035_1", true)
			this._day_num_img.visible = true
			ResManager.GetInstance().SetImageSprite(this, this._day_num_img, "topVip_asset", "7_0" + this.day, true)
		}
	}
	public GetComponents() {
		[
			this._bg_img,
			this._Image1,
			this._sure_img,
			this._day_num_img,
		]
			= this.GetChildrenByNames([

				"_bg_img",
				"_Image1",
				"_sure_img",
				"_day_num_img",
			])
	}
}
window["TopVipActivityPromotionItem"] = TopVipActivityPromotionItem
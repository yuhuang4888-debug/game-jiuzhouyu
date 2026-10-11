import { BaseItem1 } from "../common/BaseItem1"
import { PlatformManager } from "../PlatformManager"


export class BossFieldVitItem extends BaseItem1 {
	detail
	need_refresh_data

	public constructor(parent?) {
		super(parent)

		this.base_file = "bossField"
		this.layout_file = "BossFieldVitItem"
		this.load_callback = () => {
			this.InitEvent()
			this.LoadSuccess()
		}
	}

	public LoadSuccess() {

		this._lb_desc.leading = 1
		if (PlatformManager.IsEyouEnPlatform()) {
			this._lb_desc.leading = 0.7
		}
		if (this.need_refresh_data) {
			this.need_refresh_data = false
			this.UpdataView()
		}
	}
	public InitEvent() {


	}

	public Setdata?(data?) {

		this.detail = data
		if (this.is_loaded) {
			this.UpdataView()
		} else {
			this.need_refresh_data = true
		}
	}

	public UpdataView() {
		this._lb_desc.text = this.detail
		// SetAnchoredPositionY(this.Image, 0)
	}



	public DeleteMe() {

		super.DeleteMe()
	}

	_img_point: Laya.Image
	_lb_desc: Laya.Label
	public GetComponents() {
		[
			this._img_point,
			this._lb_desc,
		]
			= this.GetChildrenByNames([

				"_img_point",
				"_lb_desc",
			])
	}
}
window["BossFieldVitItem"] = BossFieldVitItem


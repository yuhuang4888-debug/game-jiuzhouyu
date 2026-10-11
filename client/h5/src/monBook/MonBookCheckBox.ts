import { BaseItem1 } from "../common/BaseItem1"
import { ResManager } from "../common/ResManager"
import { MonBookModel } from "../commonModel/MonBookModel"
import { ColorUtil } from "../util/ColorUtil"
import { Util } from "../util/Util"

export class MonBookCheckBox extends BaseItem1 {
	data
	is_group
	name
	need_refresh_data
	quality
	select
	public constructor(parent) {
		super(parent)
		this.base_file = "monBook"
		this.layout_file = "MonBookCheckBox"
		this.select = false
		this.load_callback = () => {

			if (this.need_refresh_data) {
				this.UpdateView()
				this.need_refresh_data = false
			}
			Util.AddClickEvent(this.con, () => {
				this.UpdateStage(!this.select)
				MonBookModel.GetInstance().Fire(MonBookModel.CLICK_DECOMPOSE_CHECK, this.quality, this.select)
			}, this, false)

			this.BindEvent(MonBookModel.GetInstance(), MonBookModel.REFUSE_DECOMPOSE_CHECK, (quality?, bool?) => {
				if (quality == this.quality) {
					this.UpdateStage(bool)
				}
			}
			)
		}
	}

	public SetData(data?) {

		this.data = data
		if (this.is_loaded) {
			this.UpdateView()
		} else {
			this.need_refresh_data = true
		}


	}
	public UpdateView() {

		this.quality = this.data.quality
		this.name = this.data.name
		this.is_group = this.data.is_group
		let name = String(this.name)
		this.labelDisplay.text = name

		let color_num = this.quality == 6 ? 7 : this.quality
		let color = ColorUtil.GetColorDark(color_num, false)
		this.labelDisplay.color = ColorUtil.TryParseHtmlString(color)
		let res = this.quality == 4 && "com_ui_gx1" || "com_ui_gx"
		this.select = this.quality == 4 && true || false
		this.UpdateStage(this.select)
		// ResManager.GetInstance().SetImageSprite(this, this._bg_img, "common_asset", res)//uity_045c

		// LayoutRebuilder(this.labelDisplay)
		// LayoutRebuilder(this.form)
	}
	public UpdateStage(bool?) {

		this.select = bool
		// let res = bool && "com_ui_gx1" || "com_ui_gx"
		this._bg_img.visible = !this.select
		this._bg_img2.visible = this.select
		// ResManager.GetInstance().SetImageSprite(this, this._bg_img, "common_asset", res)
	}
	

	con: Laya.Box
	_bg_img: Laya.Image
	_bg_img2: Laya.Image
	labelDisplay: Laya.Label
	public GetComponents() {
		[
			this.con,
			this._bg_img,
			this._bg_img2,
			this.labelDisplay,
		]
			= this.GetChildrenByNames([

				"con",
				"_bg_img",
				"_bg_img2",
				"labelDisplay",
			])
	}
}
window["MonBookCheckBox"] = MonBookCheckBox
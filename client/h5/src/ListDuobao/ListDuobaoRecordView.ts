import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { ListDuobaoModel } from "../commonModel/ListDuobaoModel"
import { Util } from "../util/Util"

export class ListDuobaoRecordView extends BaseView1 {
	model
	custom_model
	item

	public constructor() {
		super()
		this.base_file = "listDuobao"
		this.layout_file = "ListDuobaoRecordView"
		this.layer_value = Enum_UILayer.Activity
		this.is_center = true
		this.use_background = true
		this.click_bg_toClose = true
		this.destroy_imm = true

		this.model = ListDuobaoModel.GetInstance()
		this.custom_model = CustomActivityModel.GetInstance()
		this.load_callback = () => {
			this.UpdateView()
		}

		this.destroy_callback = () => {
			this.Remove()
		}
	}

	private Remove() {
		if (this.item) {
			this.item.DeleteMe()
			this.item = null
		}
	}

	private UpdateView() {
		Util.AddClickEvent(this._img_close, () => {
			this.Close()
		}, this, true)

		this.item = this.custom_model.LoadActRecord(this._gp_record, this.model.base_type, this.model.sub_type, 2, null, null, "#663915")
		this.item.ResetRecord(2)
		this.item.ExcuteCallback(() => {
			this.item._record.width = 350;
		})
	}

	_img_bg: Laya.Image
	_img_bg2: Laya.Image
	_img_title: Laya.Image
	_lb_title: Laya.Label
	_img_close: Laya.Image
	_gp_record: Laya.Box
	public GetComponents() {
		[
			this._img_bg,
			this._img_bg2,
			this._img_title,
			this._lb_title,
			this._img_close,
			this._gp_record,
		]
			= this.GetChildrenByNames([
				"_img_bg",
				"_img_bg2",
				"_img_title",
				"_lb_title",
				"_img_close",
				"_gp_record",
			])
	}
}
window["ListDuobaoRecordView"] = ListDuobaoRecordView
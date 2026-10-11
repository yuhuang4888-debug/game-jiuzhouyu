import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { Util } from "../util/Util"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { Message } from "../sysInfo/SysInfoController"
import { EquipmentItem } from "../common/EquipmentItem"
import { GoodsModel } from "../commonModel/GoodsModel"
import { ResManager } from "../common/ResManager"

export class HolyCallMainItem extends BaseItemRenderer {
	Content
	Emp_btn_get
	VHS_Scroller1
	_btn_get
	_item_list_
	_model
	btnImg
	btnLb
	itemGp
	receviedImg
	reddot
	tipsLb

	public static width = 355
	public static height = 135

	public constructor() {
		super()
		this.base_file = "holyCall"
		this.layout_file = "HolyCallMainItem"
		this._model = CustomActivityModel.GetInstance()
		this._item_list_ = null

		this.load_callback = () => {
			this.InitEvent()
		}
		this.Load()
	}

	public InitEvent() {
		this._item_list_ = []
		Util.AddClickEvent(
			this._btn_get, () => {
				if (this.data.status == 1) {
					this._model.Fire(CustomActivityDefine.EVENT.SCMD_REQUEST, 33192, this.data.base_type, this.data.sub_type, this.data.grade_id)
				} else if (this.data.status == 0) {
					Message.show("召唤次数不足")
				}
			},
			this,
			true
		)
	}

	public Despose() {
		if (this._item_list_) {
			for (let _tmpi in this._item_list_) {
				var item = this._item_list_[_tmpi]
				item.DeleteMe()
			}
		}
		this._item_list_ = null
	}

	public dataChanged() {
		if (!super.dataChanged()) {
			return
		}
		this.UpdateItems(this.data.reward)
		let color = "#ff4f50"
		if (this.data.all_times >= this.data.times) {
			color = "#639c12"
		}
		this.tipsLb.textFlow = Util.StrToHTML("累计召唤<font color=" + color + ">(" + (this.data.all_times || 0) + "/" + this.data.times + ")</font>次可获得")
		let status = this.data.status
		if (status == 1) {
			//this.btnImg.source = "common_asset.com_rect_btn12"
			ResManager.GetInstance().SetImageSprite(this, this.btnImg, "common_asset", "com_rect_btn12")
			this.btnLb.text = "领取"
			//this.btnLb.strokeColor = "#cc7652"
		} else if (status == 0) {
			//this.btnImg.source = "common_asset.com_rect_btn13"
			ResManager.GetInstance().SetImageSprite(this, this.btnImg, "common_asset", "com_rect_btn13")
			this.btnLb.text = "未达成"
			//this.btnLb.strokeColor = "#82AB20"
		}
		this.reddot.visible = status == 1
		this.receviedImg.visible = this.data.status == 2
		this._btn_get.visible = this.data.status == 1 || this.data.status == 0
	}

	public UpdateItems(list?) {

		for (let i = 1; i <= this._item_list_.length; i++) {
			this._item_list_[i].SetVisible(false)
		}

		let i = 0
		do {
			let info = list[i]
			let item = this._item_list_[i]
			if (!item) {
				item = new EquipmentItem(this.Content, null, "UI")
				item.SetItemSize(64, 64)
				item.SetMaskId(2)
				item.SetMaskRect(this.data.parent_mask)
				item.Load()
				this._item_list_[i] = item
			}
			let type_id = GoodsModel.GetInstance().GetMappingTypeId(info.style, info.typeId)
			item.SetData(type_id, info.count)
			item.SetVisible(true)
			i = i + 1
		} while ((i < list.length)
		)
	}

	public DeleteMe() {
		this.Despose()
		super.DeleteMe()
	}
}
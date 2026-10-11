import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { Util } from "../util/Util"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { GoodsModel } from "../commonModel/GoodsModel"
import { Message } from "../sysInfo/SysInfoController"
import { EquipmentItem } from "../common/EquipmentItem"

export class HolyCallMainItemTwo extends BaseItemRenderer {
	WIDTH = 317
	HEIGT = 115

	_item_list_
	_model
	fly_list
	is_get=false

	public constructor() {
		super()
		this.base_file = "holyCall"
		this.layout_file = "HolyCallMainItemTwo"
		this._model = CustomActivityModel.GetInstance()
		this._item_list_ = null

		this.load_callback = () => {
			this._Scroller1.hScrollBarSkin = ""
			this.tipsLb.style.fontSize = 20
			this.tipsLb.style.color = "#ffffff"
			this.tipsLb.style.wordWrap = false
			
			this.InitEvent()
		}
		this.Load()
	}

	public InitEvent() {
		this._item_list_ = []
		Util.AddClickEvent(this._btn_get, () => {
			if (this.data.status == 1) {
				this.is_get = true
				this._model.Fire(CustomActivityDefine.EVENT.SCMD_REQUEST, 33192, this.data.base_type, this.data.sub_type, this.data.grade_id)
			} else if (this.data.status == 0) {
				Message.show("召唤次数不足")
			}
		}, this, true)
		this.BindEvent(this._model, CustomActivityDefine.EVENT.ANSWER_TARGET, (base_type?, sub_type?, result_data?) => {
			if(!this.is_get)return
			this.is_get = false
			if (this.data && this.data.base_type == base_type && this.data.sub_type == sub_type && this.data.grade == result_data.grade) {
				//飘字特效
				this.fly_list = CustomActivityModel.GetInstance().GetFlyRewardList(this.data.reward,2)
				CustomActivityModel.GetInstance().ShowActFlyReward(this.fly_list, this._btn_get)
			}
		})
	}

	public DeleteMe() {
		if (this._item_list_) {
			for (let _tmpi in this._item_list_) {
				let item = this._item_list_[_tmpi]
				item.DeleteMe()
			}
		}
		this._item_list_ = null

		super.DeleteMe()
	}

	public dataChanged() {
		if (!super.dataChanged()) {
			return
		}
		this.is_get = false
		this.UpdateItems(this.data.reward)
		// let color = "#aeff00"
		// if (this.data.all_times >= this.data.times) {
		// 	color = "#aeff00"
		// }
		this.tipsLb.innerHTML = Util.StrToHTML("累计许愿<font color='#ffe56e'>(" + (this.data.all_times || 0) + "/" + this.data.times + ")</font>次可获得"
		)
		let status = this.data.status
		if (status == 1) {
			this.btnLb.text = "领取"
		} else if (status == 0) {
			this.btnLb.text = "未达成"
		}
		this.reddot.visible = status == 1
		this.receviedImg.visible = this.data.status == 2
		this._btn_get.visible = this.data.status == 1 || this.data.status == 0
	}

	public UpdateItems(list?) {
		for (let i = 0; i < this._item_list_.length; i++) {
			this._item_list_[i].SetVisible(false)
		}

		let i = 0
		do {
			let info = list[i]
			let item = this._item_list_[i]
			if (!item) {
				item = new EquipmentItem(this.itemGp)
				item.SetItemSize(55, 55)
				item.Load()
				this._item_list_[i] = item
			}
			let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(info.style, info.typeId)
			item.SetData(type_id, info.count)
			item.SetVisible(true)
			i = i + 1
		} while ((i < list.length)
		)
	}

	_Image1: Laya.Image
	_btn_get: Laya.Box
	btnImg: Laya.Image
	btnLb: Laya.Label
	reddot: Laya.Image
	_Scroller1: Laya.Panel
	itemGp: Laya.HBox
	_img_tips: Laya.Image
	tipsLb: Laya.HTMLDivElement
	receviedImg: Laya.Image
	public GetComponents() {
		[
			this._Image1,
			this._btn_get,
			this.btnImg,
			this.btnLb,
			this.reddot,
			this._Scroller1,
			this.itemGp,
			this._img_tips,
			this.tipsLb,
			this.receviedImg,
		]
			= this.GetChildrenByNames([
				"_Image1",
				"_btn_get",
				"btnImg",
				"btnLb",
				"reddot",
				"_Scroller1",
				"itemGp",
				"_img_tips",
				"tipsLb",
				"receviedImg",
			])
	}
}
window["HolyCallMainItemTwo"] = HolyCallMainItemTwo
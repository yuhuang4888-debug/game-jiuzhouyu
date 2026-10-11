import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { EquipmentItem } from "../common/EquipmentItem"
import { OpenFun } from "../common/OpenFun"
import { ResManager } from "../common/ResManager"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"

export class DailySupplyItem extends BaseItemRenderer {
	_Group1: Laya.Box
	bg: Laya.Image
	_Image1: Laya.Image
	title: Laya.HTMLDivElement
	_Scroller1: Laya.Panel
	Content: Laya.HBox
	getBtn: Laya.Box
	_Image11: Laya.Image
	labelDisplay: Laya.Label
	recImg: Laya.Image
	reddot: Laya.Image
	UnfinishImg: Laya.Image
	VHS_Scroller1
	_canGet
	_item_list
	_model
	parent_mask_corners
	reward
	public static width = 700
	public static height = 158
	public constructor(parent) {
		super()
		this.WIDTH=700
		this.HEIGT=158

		this._item_list = [];
		this._canGet = false;
		this.base_file = "activity"
		this.layout_file = "DailySupplyItem"
		this._model = CustomActivityModel.GetInstance()
		// this.load_callback = () => {

		// }
		this.Load()
	}

	public load_callback(): void {
		// let parent_scr = this.parent_wnd.GetComponentInParent(typeof(UnityEngine.UI.ScrollRect))
			// if (parent_scr ) {
			// this.parent_mask_corners = GetWorldCorners(parent_scr.transform.Find("_group_item"))
			// this.VHS_Scroller1.parentScroll = parent_scr
			// }
			// let mask = this.GetChild("_Group1/_Scroller1/reward").GetComponent("Image")
			// this.RegisterMask(mask,2)
			this.InitEvent()
			// ResManager.GetInstance().SetOutsideImageSprite(this, this.bg, GameResPath.GetIcon("activity", "cjgh_002"), true)
			// ResManager.GetInstance().SetOutsideImageSprite(this, this._Image1, GameResPath.GetIcon("activity", "uimrbj_001"), true)
	}



	public dataChanged() {
		if(!super.dataChanged()) return
		if (!this.data) {
			return
		}
		let data = this.data
		let str=data.desc.replace("今日新增活跃度","")
		this.title.innerHTML ="今日新增活跃度<font color='#ffffff'>" + str + "</font>" 
		this._canGet = data.status == 1
		this.reddot.visible = this._canGet
		this.getBtn.visible = this._canGet || data.status == 0
		this.recImg.visible = data.status == 2
		if (this._canGet) {
			this.labelDisplay.text = "领取"
		} else {
			this.labelDisplay.text = "前往"
		}
		let rewards = ErlangParser.GetInstance().Parse(data.reward)
		this.UpdateItems(rewards)
	}

	public InitEvent() {


		Util.AddClickEvent(this.getBtn, () => {
			let data = this.data
			if (data.status == 1) {
				this._model.Fire(CustomActivityDefine.EVENT.SCMD_REQUEST, 33105, data.base_type, data.sub_type, data.grade)
			} else if (data.status == 0) {
				OpenFun.OpenFunHandler(82)
			}
		}
			, this, true)
	}

	public UpdateItems(list?) {

		if (list) {
			for (let _tmpi in this._item_list) {
				var item = this._item_list[_tmpi]
				item.DeleteMe()
			}
			this._item_list = []
			let i = 0
			do {
				let info = list[i]
				let item = this._item_list[i]
				if (!item) {
					item = new EquipmentItem(this.Content)
					item.SetItemSize(87, 87)
					// item.SetScale(0.8)
					// item.SetMaskId(2)

					// item.SetMaskRect(this.parent_mask_corners)
					item.Load()
					this._item_list[i] = item
				}
				let [type_id,lock] = GoodsModel.GetInstance().GetMappingTypeId(info[0], info[1])
				let goods_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
				item.SetData(type_id, info[2])
				item.SetVisible(true)
				i = i + 1
			} while ((i < list.length))
			i = list.length
			if (i < this._item_list.length) {
				do {
					this._item_list[i].SetVisible(false)
					i = i + 1
				} while ((i < this._item_list.length))
			}

		}
	}

	public DeleteMe() {
		for (let _tmpi in this._item_list) {
			var item = this._item_list[_tmpi]
			item.DeleteMe()
		}
		this._item_list = null
		super.DeleteMe()
	}

	public GetComponents() {
		[
			this._Group1,
			this.bg,
			this._Image1,
			this.title,
			this._Scroller1,
			this.Content,
			this.getBtn,
			this._Image11,
			this.labelDisplay,
			this.recImg,
			this.reddot,
			this.UnfinishImg,
		]
			= this.GetChildrenByNames([

				"_Group1",
				"bg",
				"_Image1",
				"title",
				"_Scroller1",
				"Content",
				"getBtn",
				"_Image11",
				"labelDisplay",
				"recImg",
				"reddot",
				"UnfinishImg",
			])
		this.title.style.fontSize=24
		this.title.style.color="#fff1b9"
		this.title.style.wordWrap=false
		this._Scroller1.hScrollBar.visible=false
	}
}
window["DailySupplyItem"]=DailySupplyItem
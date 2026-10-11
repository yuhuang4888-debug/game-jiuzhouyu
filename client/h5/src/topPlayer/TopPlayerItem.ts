
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
import { GoodsModel } from "../commonModel/GoodsModel"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { EquipmentItem } from "../common/EquipmentItem"


export class TopPlayerItem extends BaseItemRenderer {
	_img_bg0: Laya.Image
	_img_bg1: Laya.Image
	_img_title: Laya.Image
	_Image11: Laya.Image
	_lb_desc: Laya.Label
	_btn_get: Laya.Box
	_Image1: Laya.Image
	labelDisplay: Laya.Label
	_img_received: Laya.Image
	_Scroller1: Laya.Panel
	Content: Laya.HBox
	_img_red: Laya.Image

	award_list
	parent_mask_corners
	public static width = 536
	public static height = 167
	WIDTH = 536
    HEIGT = 167
	public constructor(parent) {
		super()


		this.base_file = "topPlayer"
		this.layout_file = "TopPlayerItem"
		this.load_callback = () => {
			this._Scroller1.hScrollBar.visible = false
			// let mask = this.GetChild("_Scroller1/_gp_award_con").GetComponent("Image")
			// this.RegisterMask(mask,2)
			//this.parent_mask_corners = GetWorldCorners(this.parent_wnd.GetComponentInParent(typeof(UnityEngine.UI.ScrollRect)).transform.Find("listGp"))
			ResManager.GetInstance().SetImageSpriteTrans(this, this._img_bg0, GameResPath.GetIcon("topPlayer", "uikf_019"))
			ResManager.GetInstance().SetImageSpriteTrans(this, this._img_bg1, GameResPath.GetIcon("topPlayer", "uikf_019"))

			Util.AddClickEvent(this._btn_get, () => {
				if (GoodsModel.GetInstance().CheckEquipNum(1, 999)) {
					if (this.data.type && this.data.type != 0) {
						CustomActivityModel.GetInstance().Fire(CustomActivityDefine.EVENT.SCMD_REQUEST, 22504, this.data.rank_type, 1, this.data.id)
					} else {
						CustomActivityModel.GetInstance().Fire(CustomActivityDefine.EVENT.SCMD_REQUEST, 22503, this.data.rank_type, 1, this.data.id)
					}
				}
			}
				, this, true)
		}
		this.Load()
	}

	public dataChanged() {
		if (super.dataChanged()) {
			this._lb_desc.text = this.data.desc
			let reward_list = this.data.reward
			if (!this.award_list) {
				this.award_list = []
			}
			if (reward_list && this.award_list.length > reward_list.length) {
				for (let i = reward_list.length; i < this.award_list.length; i++) {
					this.award_list[i].SetVisible(false)
				}
			}
			let item = null
			let index = 0
			for (let key in reward_list) {

				// [ts2lua]reward_list下标访问可能不正确
				let vo = reward_list[key]
				let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(vo[0], vo[1])
				let goods_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
				if (goods_vo) {
					item = this.award_list[index]
					if (!item) {
						item = new EquipmentItem(this.Content)
						this.award_list[index] = item
						item.SetItemSize(90, 90)
						item.Load()
					}
					item.SetData(goods_vo.type_id, vo[2], lock)
					item.SetPosition(index * 90, 0)
					item.SetVisible(true)
					index = index + 1
				}
			}
			this._btn_get.visible = this.data.state == 1
			this._img_red.visible = this.data.state == 1
			this._img_received.visible = this.data.state == 2
			if (this.data.type && this.data.type != 0) {
				if (1 == this.data.id) {
					ResManager.GetInstance().SetOutsideImageSprite(this, this._img_title, GameResPath.GetIcon("topPlayer", "uikf_020"))
				} else if (2 == this.data.id) {
					ResManager.GetInstance().SetOutsideImageSprite(this, this._img_title, GameResPath.GetIcon("topPlayer", "uikf_020b"))
				} else{
					ResManager.GetInstance().SetOutsideImageSprite(this, this._img_title, GameResPath.GetIcon("topPlayer", "uikf_020c"))
				}
			} else if (!this.data.type || this.data.type == 0) {
				ResManager.GetInstance().SetOutsideImageSprite(this, this._img_title, GameResPath.GetIcon("topPlayer", "uikf_020c"))
			}
		}
	}

	public DeleteMe() {

		if (this.award_list) {
			for (let _tmpi in this.award_list) {
				var obj = this.award_list[_tmpi]
				obj.DeleteMe()
			}
			this.award_list = null
		}
		super.DeleteMe()
	}







	public GetComponents() {
		[
			this._img_bg0,
			this._img_bg1,
			this._img_title,
			this._Image11,
			this._lb_desc,
			this._btn_get,
			this._Image1,
			this.labelDisplay,
			this._img_received,
			this._Scroller1,
			this.Content,
			this._img_red,
		]
			= this.GetChildrenByNames([

				"_img_bg0",
				"_img_bg1",
				"_img_title",
				"_Image11",
				"_lb_desc",
				"_btn_get",
				"_Image1",
				"labelDisplay",
				"_img_received",
				"_Scroller1",
				"Content",
				"_img_red",
			])
	}
}
window["TopPlayerItem"] = TopPlayerItem
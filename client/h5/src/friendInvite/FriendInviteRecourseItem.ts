import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { FriendInviteModel } from "../commonModel/FriendInviteModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"

export class FriendInviteRecourseItem extends BaseItemRenderer {
	_Image1: Laya.Image
	_img_title_bg: Laya.Image
	_lb_desc: Laya.HTMLDivElement
	_Scroller1: Laya.Panel
	Content: Laya.HBox
	_img_receive: Laya.Image
	_btn_get: Laya.Box
	_Image11: Laya.Image
	labelDisplay: Laya.Label
	_img_red: Laya.Image
	Emp_btn_get
	Scr_Scroller1
	_gp_item_con
	item_list
	public static width = 618
	public static height = 153
	WIDTH = 572
	HEIGT = 155
	public constructor(parent) {
		super()

		this.base_file = "friendInvite"
		this.layout_file = "FriendInviteRecourseItem"
		this.load_callback = () => {

			//ResManager.GetInstance().SetOutsideImageSprite(this, this._img_title_bg, GameResPath.GetIcon("friendInvite", "uiyqkbx_018"), true)
			Util.AddClickEvent(this._btn_get, () => {
				if (this.data && this.data.state == 2) {
					FriendInviteModel.GetInstance().Fire(FriendInviteModel.SCMD_REQUEST, 34004, 1, this.data.id)
				}
			}
				, this, true)
		}
		this.Load()
	}

	public dataChanged() {
		if (super.dataChanged()) {
			this._img_receive.visible = this.data.state == 1
			this._btn_get.visible = this.data.state != 1
			this.labelDisplay.text = (this.data.state == 0 && "未达到" || "领取")
			let color = (this.data.now_num >= this.data.num && "'#8CFF00'" || "'#ffffff'")
			this._img_red.visible = this.data.state == 2
			this._lb_desc.style.fontSize = 20
			this._lb_desc.style.color = "#fff1b9"
			this._lb_desc.style.align = "center"
			this._lb_desc.style.wordWrap = false
			this._lb_desc.innerHTML = Util.StrToHTML("累计" + this.data.num + "次<font color=" + color + ">(" + this.data.now_num + "/" + this.data.num + ")</font>")
			if (!this.item_list) {
				this.item_list = []
			}
			let item = null
			for (let key in this.data.reward) {

				let vo = this.data.reward[key]
				let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(vo[0], vo[1])
				let goods_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
				if (goods_vo) {
					item = this.item_list[key]
					if (!item) {
						item = new BaseAwardItem(this.Content)
						item.SetItemSize(85, 85)
						item.Load()
						this.item_list[key] = item
					}
					item.SetData(goods_vo.type_id, vo[2], lock)
					item.SetVisible(true)
				}
			}
			for (let i = this.data.reward.length; i < this.item_list.length; i++) {
				this.item_list[i].SetVisible(false)
			}
		}
	}
	public DeleteMe() {

		if (this.item_list) {
			for (let _tmpi in this.item_list) {
				var obj = this.item_list[_tmpi]
				obj.DeleteMe()
			}
			this.item_list = null
		}
		super.DeleteMe()
	}



	public GetComponents() {
		[
			this._Image1,
			this._img_title_bg,
			this._lb_desc,
			this._Scroller1,
			this.Content,
			this._img_receive,
			this._btn_get,
			this._Image11,
			this.labelDisplay,
			this._img_red,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_img_title_bg",
				"_lb_desc",
				"_Scroller1",
				"Content",
				"_img_receive",
				"_btn_get",
				"_Image11",
				"labelDisplay",
				"_img_red",
			])
	}
}
window["FriendInviteRecourseItem"] = FriendInviteRecourseItem
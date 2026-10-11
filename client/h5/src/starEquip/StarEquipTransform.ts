import { BaseView1 } from "../common/BaseView1"
import { Util } from "../util/Util"
import { Alert, Alert_Type } from "../alert/Alert"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { StarEquipModel } from "../commonModel/StarEquipModel"
import { EquipmentItem } from "../common/EquipmentItem"
import { UIToolTipMgr } from "../common/UIToolTipMgr"

export class StarEquipTransform extends BaseView1 {
	EmptranBtn
	EmpwearBtn
	InitView
	Open

	preItem
	targetItem
	type
	wearIngItem
	data
	targetdata

	public constructor() {
		super()
		this.base_file = "starEquip"
		this.layout_file = "StarEquipTransform"
		this.layer_value = Enum_UILayer.Activity
		this.is_center = true
		this.use_background = true

		//let local_util = Util
		let local_StarEquipModel = StarEquipModel
		let local_starEquipIns = local_StarEquipModel.GetInstance()
		let local_resMgr = ResManager.GetInstance()

		this.load_callback = () => {
			this._Label1.style.fontSize = 18
			this._Label1.style.color = "#b94a00"
			this._Label1.style.wordWrap = false
		}
		this.open_callback = () => {
			this._Label1.innerHTML = "属性转移可将原装备<font color='#d15e00'>所有属性完美转移</font>至新装备"
			local_resMgr.SetOutsideImageSprite(this, this.bg2, GameResPath.GetIconJpg("starEquip", "uixzsy_029"))
			this.InitView()
		}

		this.destroy_callback = () => {
			if (this.wearIngItem) {
				this.wearIngItem.DeleteMe()
				this.wearIngItem = null
			}
			if (this.targetItem) {
				this.targetItem.DeleteMe()
				this.targetItem = null
			}
			if (this.preItem) {
				this.preItem.DeleteMe()
				this.preItem = null
			}
		}

		this.InitView = () => {
			if (this.data && this.is_loaded) {
				this.labelDisplay1.text = this.type == 1 && "取消" || "直接穿戴"
				this.redImg.visible = this.type == 1
				Util.AddClickEvent(this.closeBtn, () => {
					this.Close()
				}, this, true)

				Util.AddClickEvent(this.wearBtn, () => {
					if (this.type != 1) {
						local_starEquipIns.Fire(local_StarEquipModel.SEND_PROTO, 23202, "lic", this.targetdata.goods_id, this.targetdata.page, 0)
					}
					this.Close()
				}, this, true)

				Util.AddClickEvent(this.tranBtn, () => {
					Alert.Show("转移后,新装备将继承原装备的所有打造属性.<br><font color='#ff4f50'>原装备将因为力量丧失而销毁.</font><br>是否进行属性转移?", Alert_Type.Two, () => {
						if (this.type) {
							local_starEquipIns.Fire(local_StarEquipModel.SEND_PROTO, 23257, "ll", this.data.goods_id, this.targetdata.goods_id)
						} else {
							local_starEquipIns.Fire(local_StarEquipModel.SEND_PROTO, 23202, "lic", this.targetdata.goods_id, this.targetdata.page, 1)
						}
						this.Close()
					}
					)
				}, this, true)

				if (!this.wearIngItem) {
					this.wearIngItem = new EquipmentItem(this.itemGp1, null, "Activity")
					this.wearIngItem.Load()
					this.wearIngItem.SetItemSize(85, 85)
				}
				this.wearIngItem.SetData(this.data.type_id)

				this.wearIngItem.SetClickCallBack(() => {
					UIToolTipMgr.GetInstance().AppendStarEquipToolTips(this.data.type_id, this.data, null, [0])
				}
				)
				this.wearIngItem.SetStarEquipStar(this.data.color, this.data.star)

				if (!this.targetItem) {
					this.targetItem = new EquipmentItem(this.itemGp2, null, "Activity")
					this.targetItem.Load()
					this.targetItem.SetItemSize(85, 85)
				}
				this.targetItem.SetData(this.targetdata.type_id)
				this.targetItem.SetClickCallBack(() => {
					UIToolTipMgr.GetInstance().AppendStarEquipToolTips(this.targetdata.type_id, this.targetdata, null, [0])
				}
				)
				this.targetItem.SetStarEquipStar(this.targetdata.color, this.targetdata.star)
				let goods_vo = Util.DeepCopy(this.targetdata)
				goods_vo.goods_id = 23254
				goods_vo.addition_attrlist = this.data.addition_attrlist
				goods_vo.star = this.data.star

				if (!this.preItem) {
					this.preItem = new EquipmentItem(this.itemGp3, null, "Activity")
					this.preItem.Load()
					this.preItem.SetItemSize(85, 85)
				}
				this.preItem.SetData(goods_vo.type_id)
				this.preItem.SetClickCallBack(() => {
					UIToolTipMgr.GetInstance().AppendStarEquipToolTips(this.targetdata.type_id, goods_vo, null, [0])
					StarEquipModel.GetInstance().Fire(StarEquipModel.SEND_PROTO, 23254, "ll", this.data.goods_id, this.targetdata.goods_id)
				}
				)
				this.preItem.SetStarEquipStar(goods_vo.color, goods_vo.star)

			}
		}

		this.Open = (...new_args) => {
			this.data = new_args[0]
			this.targetdata = new_args[1]
			this.type = new_args[2]
			this.InitView()
			super.Open()
		}
	}

	bg: Laya.Image
	bg2: Laya.Image
	_Image111: Laya.Image
	_Image2: Laya.Image
	_Image3: Laya.Image
	_Image4: Laya.Image
	_Image5: Laya.Image
	closeBtn: Laya.Image
	wearBtn: Laya.Box
	_Image1: Laya.Image
	labelDisplay1: Laya.Label
	tranBtn: Laya.Box
	_Image11: Laya.Image
	labelDisplay: Laya.Label
	redImg: Laya.Image
	_img_tips: Laya.Image
	_Label1: Laya.HTMLDivElement
	itemGp1: Laya.Box
	itemGp2: Laya.Box
	itemGp3: Laya.Box
	_lb_title: Laya.Label
	public GetComponents() {
		[
			this.bg,
			this.bg2,
			this._Image111,
			this._Image2,
			this._Image3,
			this._Image4,
			this._Image5,
			this.closeBtn,
			this.wearBtn,
			this._Image1,
			this.labelDisplay1,
			this.tranBtn,
			this._Image11,
			this.labelDisplay,
			this.redImg,
			this._img_tips,
			this._Label1,
			this.itemGp1,
			this.itemGp2,
			this.itemGp3,
			this._lb_title,
		]
			= this.GetChildrenByNames([

				"bg",
				"bg2",
				"_Image111",
				"_Image2",
				"_Image3",
				"_Image4",
				"_Image5",
				"closeBtn",
				"wearBtn",
				"_Image1",
				"labelDisplay1",
				"tranBtn",
				"_Image11",
				"labelDisplay",
				"redImg",
				"_img_tips",
				"_Label1",
				"itemGp1",
				"itemGp2",
				"itemGp3",
				"_lb_title",
			])
	}
}
window["StarEquipTransform"] = StarEquipTransform
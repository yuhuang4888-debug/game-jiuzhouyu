import { BaseItem1 } from "../common/BaseItem1"
import { Util } from "../util/Util"
import { GoodsModel } from "../commonModel/GoodsModel"
import { CompositeModel } from "../commonModel/CompositeModel"
import { GodCourtModel } from "../commonModel/GodCourtModel"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { EquipmentItem } from "../common/EquipmentItem"

export class GodCourtComItem extends BaseItem1 {
	InitEvent
	InitMatData
	LoadSuccess
	ReSetItem
	SetEquipData
	SetIndex
	SetMaterialData

	goodsVo
	goods_item
	index
	is_equip
	mat_id
	mat_type
	need_refresh
	parms
	type

	public constructor(parent?) {
		super(parent)
		this.base_file = "composite"
		this.layout_file = "CompositeEquipItem"
		this.need_refresh = false;
		let local_gModelIns = GoodsModel.GetInstance()
		let local_comModel = CompositeModel
		let local_comModelIns = local_comModel.GetInstance()
		let local_godCourtModel = GodCourtModel
		let local_godCourtIns = local_godCourtModel.GetInstance()
		let local_uiToolMgr = UIToolTipMgr.GetInstance()

		this.load_callback = () => {
			this.LoadSuccess()
			this.InitEvent()
		}

		this.LoadSuccess = () => {
			this.num_label.width = 80
			this.num_label.style.color = "#ffffff"
			this.num_label.style.fontSize = 20
			this.num_label.style.stroke = 1
			this.num_label.style.strokeColor = "#000000"
			this.num_label.style.align = "center"
			this.num_label.style.wordWrap = false
			if (this.need_refresh) {
				this.InitMatData(this.mat_type, this.parms, this.type)
			}
		}

		this.InitEvent = () => {
			let OnAddMatBtnClick = () => {
				if (this.mat_type == 2) {
					if (!this.goodsVo) {
						local_godCourtIns.Fire(local_godCourtModel.OPEN_VIEW, "GCComSelectView", this.index, this.parms)
					} else {
						local_uiToolMgr.AppendGodCourtTips(this.mat_id, this.goodsVo, null, [3])
					}
				}
			}
			Util.AddClickEvent(this.gp_con, OnAddMatBtnClick, this, false)

			let OnGoodsChange = (list?) => {
				if (this.use_delete_method) {
					return
				}
				if (this.mat_type == 1 && !this.is_equip) {
					for (let _tmpi in list) {
						let vo = list[_tmpi]
						if (vo.type_id == this.mat_id) {
							this.SetMaterialData(this.parms)
						}
					}
				}
			}

			this.BindEvent(local_gModelIns, GoodsModel.UPDATE_GOODS_NUM, OnGoodsChange)
		}

		this.InitMatData = (mat_pos_type?, parms?, type?) => {
			this.mat_type = mat_pos_type
			if (mat_pos_type == 1) {
				this.mat_id = Number(parms[1])
			}
			this.parms = parms
			this.type = type
			this.goodsVo = false
			if (this.is_loaded) {
				if (!this.goods_item) {
					this.goods_item = new EquipmentItem(this.item_group)
					this.goods_item.Load()
					this.goods_item.SetItemSize(80, 80)
					this.goods_item.SetShowTips(false)
				}
				this.goods_item.ClearItemEffect()
				this._img.visible = false
				if (mat_pos_type == 1) {
					this.lock_img.visible = false
					let goods_basic = local_gModelIns.GetGoodsBasicByTypeId(this.mat_id)
					if (goods_basic && goods_basic.type == 10) {
						this.goods_item.SetData(null)
						this.add_img.visible = true
						this.num_label.visible = false
						this.is_equip = true
					} else {
						if (this.parms) {
							this.SetMaterialData(this.parms)
							this.add_img.visible = false
							this.num_label.visible = true
							this.is_equip = false
						}
					}

					this.item_group.visible = true
				} else if (mat_pos_type == 2) {
					this.lock_img.visible = false
					this.add_img.visible = true
					this.num_label.visible = false
					this.goods_item.SetData(null)
					this.goods_item.SetIconGaryCom(false)
					this.item_group.visible = true
				} else {
					this.lock_img.visible = true
					this.add_img.visible = false
					this.num_label.visible = false
					this.goods_item.SetData(null)
					this.goods_item.SetIconGaryCom(false)
					this.item_group.visible = false
				}
			} else {
				this.need_refresh = true
			}
		}

		this.SetEquipData = (goodVo?) => {
			this.goodsVo = goodVo
			if (goodVo) {
				this.mat_id = goodVo.type_id
				if (this.is_loaded) {
					this.lock_img.visible = false
					this.add_img.visible = false
					this.num_label.visible = false
					this.item_group.visible = true

					this._img.visible = !(!local_gModelIns.godCourtDic[goodVo.goods_id])
					if (this.goods_item) {
						this.goods_item.SetData(this.mat_id)
						this.goods_item.SetShowTips(false)
					}
				}
			}
		}

		this.ReSetItem = () => {
			this.goodsVo = false
			this.lock_img.visible = false
			this.add_img.visible = true
			this.num_label.visible = false
			this.goods_item.SetData(null)
			this.item_group.visible = true
			this._img.visible = false
		}

		this.SetMaterialData = (parms?) => {
			if (parms) {
				let type_id = parms[1]
				let need_count = Number(parms[2])
				if (!this.goods_item) {
					this.goods_item = new EquipmentItem(this.item_group)
					this.goods_item.Load()
					this.goods_item.SetShowTips(false)
				}
				if (this.is_loaded) {
					this.lock_img.visible = false
					this.add_img.visible = false

					if (this.goods_item && need_count) {
						this.num_label.visible = true
						let now_count = 0
						if (need_count > 1) {
							now_count = local_gModelIns.GetTypeGoodsNum(this.mat_id)
						} else {
							let selectedList = local_godCourtIns.regualrMatList
							if (!selectedList[this.index]) {
								let goodsList = local_gModelIns.GetTypeGoods(this.mat_id)
								for (let _tmpi in goodsList) {
									let vo = goodsList[_tmpi]
									let find = false
									for (let key in selectedList) {
										if (selectedList[key].goods_id == vo.goods_id) {
											find = true
											break
										}
									}
									if (!find) {
										selectedList[this.index] = {goods_id : vo.goods_id}
										now_count = 1
										break
									}
								}
							} else {
								now_count = 1
							}
						}
						if (now_count < need_count) {
							this.num_label.innerHTML = Util.StrToHTML("<font color='#ff4f50'>" + now_count + "</font>/" + need_count)
							this.goods_item.SetIconGaryCom(true)
							this.goods_item.ExcuteCallback(() => {
								this.goods_item.SetShowTips(true)
								this.goods_item.SetData(this.mat_id, null, null, null, null, true)
							}
							)
						} else {
							this.goods_item.SetIconGaryCom(false)
							this.num_label.innerHTML = now_count + "/" + need_count
							this.goods_item.SetIconGaryCom(false)
							this.goods_item.ExcuteCallback(() => {
								this.goods_item.SetShowTips(true)
								this.goods_item.SetData(this.mat_id)
							}
							)
						}
					}
				}
			}
		}

		this.SetIndex = (index?, type?) => {
			this.index = index
			this.type = type
		}
	}

	public DeleteMe() {
		if (this.goods_item) {
			this.goods_item.DeleteMe()
		}
		this.goods_item = null
		super.DeleteMe()
	}

	gp_con: Laya.Box
	bg: Laya.Image
	item_group: Laya.Box
	lock_img: Laya.Image
	add_img: Laya.Image
	num_label: Laya.HTMLDivElement
	_img: Laya.Image
	public GetComponents() {
		[
			this.gp_con,
			this.bg,
			this.item_group,
			this.lock_img,
			this.add_img,
			this.num_label,
			this._img,
		]
			= this.GetChildrenByNames([
				"gp_con",
				"bg",
				"item_group",
				"lock_img",
				"add_img",
				"num_label",
				"_img",
			])
	}
}
window["GodCourtComItem"] = GodCourtComItem
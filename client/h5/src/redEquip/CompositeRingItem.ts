import { BaseItem1 } from "../common/BaseItem1"
import { Util } from "../util/Util"
import { table } from "../common/table"
import { GoodsModel } from "../commonModel/GoodsModel"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { MatViewType } from "../commonModel/CompositeModel"
import { CompositeModel } from "../commonModel/CompositeModel"
import { EquipmentItem } from "../common/EquipmentItem"

export class CompositeRingItem extends BaseItem1 {
	InitEvent
	InitMatData
	LoadSuccess
	LocalDeleteMe
	ReSetItem
	SetEquipData
	SetMaterialData
	SetType

	public constructor(parent?) {
		super(parent)
		this.base_file = "composite"
		this.layout_file = "CompositeEquipItem"

		let goods_item_ = null
		let goods_change_bind_ = null
		let need_refresh_ = false
		let mat_type_ = null
		let mat_id_ = null
		let parms_ = null
		let goodsVo_ = null
		let is_equip_ = null
		let index_ = null
		let type_ = null

		let local_gModelIns = GoodsModel.GetInstance()
		let local_comModel = CompositeModel
		let local_comModelIns = local_comModel.GetInstance()
		let local_uiToolMgr = UIToolTipMgr.GetInstance()

		this.load_callback = () => {
			this.LoadSuccess()
			this.InitEvent()
		}

		this.SetType = (index?, type?) => {
			index_ = index
			type_ = type
		}

		this.LoadSuccess = () => {
			this.num_label.width = 80
			this.num_label.style.color = "#ffffff"
			this.num_label.style.fontSize = 20
			this.num_label.style.stroke = 1
			this.num_label.style.strokeColor = "#000000"
			this.num_label.style.align = "center"
			this.num_label.style.wordWrap = false
			
			if (need_refresh_) {
				this.InitMatData(mat_type_, parms_, type_)
			}
		}

		this.InitEvent = () => {
			let OnAddMatBtnClick = () => {
				if (mat_type_ == 2) {
					if (!goodsVo_) {
						local_comModelIns.Fire(local_comModel.OPEN_CHOSE_EQUIPMENT_VIEW, index_, parms_, null, type_)
					} else {
						local_uiToolMgr.AppendEquipTips(mat_id_, null, null, goodsVo_, null, [5])
					}
				} else if (mat_type_ == 1 && is_equip_) {
					if (!goodsVo_) {
						let mat_list = []
						for (let _tmpi in parms_) {
							var vo = parms_[_tmpi]
							table.insert(mat_list, vo[1])
						}
						local_comModelIns.Fire(local_comModel.OPEN_CHOSE_EQUIPMENT_VIEW, index_, mat_list, mat_type_, type_)
					} else {
						local_uiToolMgr.AppendEquipTips(mat_id_, null, null, goodsVo_, null, [5])
					}
				}
			}
			Util.AddClickEvent(this.gp_con, OnAddMatBtnClick, this, false)

			let OnGoodsChange = (list?) => {
				if (this.use_delete_method) {
					return
				}
				if (mat_type_ == 1 && !is_equip_) {
					for (let _tmpi in list) {
						var vo = list[_tmpi]
						if (vo.type_id == mat_id_) {
							this.SetMaterialData(parms_[0])
							local_comModelIns.Fire(local_comModel.UPDATA_SUCCESS_RATIO)
						}
					}
				}
			}
			goods_change_bind_ = local_gModelIns.Bind(GoodsModel.UPDATE_GOODS_NUM, OnGoodsChange)
		}

		this.InitMatData = (mat_pos_type?, parms?, type?) => {
			mat_type_ = mat_pos_type
			if (parms && parms[0]) {
				mat_id_ = Number(parms[0][1])
			}
			parms_ = parms
			type_ = type
			goodsVo_ = false
			if (this.is_loaded) {
				if (!goods_item_) {
					goods_item_ = new EquipmentItem(this.item_group)
					goods_item_.Load()
					goods_item_.SetItemSize(80, 80)
				}
				//goods_item_:SetShowTips(false)
				goods_item_.ClearItemEffect()
				this._img.visible = false
				if (mat_pos_type == 1) {
					this.lock_img.visible = false
					let goods_basic = local_gModelIns.GetGoodsBasicByTypeId(mat_id_)
					if (goods_basic && goods_basic.type == 10) {
						goods_item_.SetData(null)
						goods_item_.SetShowTips(false)
						this.add_img.visible = true
						this.num_label.visible = false
						is_equip_ = true
					} else {
						if (parms_[0]) {
							this.SetMaterialData(parms_[0])
							this.add_img.visible = false
							this.num_label.visible = true
							is_equip_ = false
						}
					}
				} else if (mat_pos_type == 2) {
					goods_item_.SetIconGaryCom(false)
					this.add_img.visible = true
					this.lock_img.visible = false
					this.num_label.visible = false
					goods_item_.SetShowTips(false)
					goods_item_.SetData(null)
				} else {
					goods_item_.SetIconGaryCom(false)
					this.lock_img.visible = true
					this.add_img.visible = false
					this.num_label.visible = false
					goods_item_.SetShowTips(false)
					goods_item_.SetData(null)
				}
			} else {
				need_refresh_ = true
			}
		}

		this.SetEquipData = (goodVo?) => {
			goodsVo_ = goodVo
			if (goodVo) {
				mat_id_ = goodVo.type_id
				if (this.is_loaded) {
					this.lock_img.visible = false
					this.num_label.visible = false
					this.add_img.visible = false
					this._img.visible = local_comModelIns.checkWearEquip(goodVo.goods_id)
					if (goods_item_) {
						goods_item_.SetData(mat_id_)
						goods_item_.SetShowTips(false)
					}
				}
			}
		}

		this.ReSetItem = () => {
			goodsVo_ = false
			this.lock_img.visible = false
			this.num_label.visible = false
			this.add_img.visible = true
			this._img.visible = false
			goods_item_.SetData(null)
		}

		this.SetMaterialData = (parms?) => {
			if (parms) {
				let type_id = Number(parms[1])
				let need_count = Number(parms[2])
				if (!goods_item_) {
					goods_item_ = new EquipmentItem(this.item_group)
					goods_item_.Load()
				}
				//goods_item_:SetShowTips(false)
				if (this.is_loaded) {
					this.lock_img.visible = false
					this.num_label.visible = false
					this.add_img.visible = false
					if (goods_item_ && need_count) {
						this.num_label.visible = true
						let goods_id = local_gModelIns.GetOneGoodsByTypeId(mat_id_)
						let now_count = local_gModelIns.GetTypeGoodsNum(mat_id_)
						if (now_count < need_count) {
							this.num_label.innerHTML = Util.StrToHTML("<font color='#ff4f50'>" + now_count + "</font>/" + need_count)
							local_comModelIns.compEquip_regular_glist[type_id] = false
							goods_item_.SetIconGaryCom(true)
							//goods_item_:ExcuteCallback(function(
							goods_item_.SetData(mat_id_, null, null, null, null, true)
							goods_item_.SetShowTips(true)
							//}
							//)
						} else {
							goods_item_.SetIconGaryCom(false)
							local_comModelIns.compEquip_regular_glist[type_id] = need_count
							this.num_label.innerHTML = now_count + "/" + need_count
							goods_item_.SetIconGaryCom(false)
							//goods_item_:ExcuteCallback(() => {
							goods_item_.SetData(mat_id_)
							goods_item_.SetShowTips(true)
							//}
							//)
						}
						if (goods_id) {
							if (type_ == MatViewType.RING) {
								local_comModelIns.ring_mat_list[index_] = goods_id
							} else if (type_ == MatViewType.RINGUP) {
								local_comModelIns.ring_up_mat_list[index_] = goods_id
							}
						}
					}
				}
			}
		}

		this.LocalDeleteMe = () => {
			if (goods_change_bind_) {
				local_gModelIns.UnBind(goods_change_bind_)
			}
			if (goods_item_) {
				goods_item_.DeleteMe()
			}
			goods_item_ = null
		}
	}

	public DeleteMe() {
		this.LocalDeleteMe()
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
window["CompositeRingItem"] = CompositeRingItem
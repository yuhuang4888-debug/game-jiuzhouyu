import { BaseItem1 } from "../common/BaseItem1"
import { Util } from "../util/Util"
import { table } from "../common/table"
import { EquipmentItem } from "../common/EquipmentItem"
import { GoodsModel } from "../commonModel/GoodsModel"
import { CompositeModel } from "../commonModel/CompositeModel"
import { UIToolTipMgr } from "../common/UIToolTipMgr"

export class CompositeEquipItem extends BaseItem1 {
	compositeModel
	goodsModel
	goodsVo
	index
	is_equip
	item
	mat_id
	mat_type
	need_refresh
	parms

	public constructor(parent?) {
		super(parent)
		this.base_file = "composite"
		this.layout_file = "CompositeEquipItem"

		this.goodsModel = GoodsModel.GetInstance()
		this.compositeModel = CompositeModel.GetInstance()
		this.is_equip = false
		this.need_refresh = false

		this.load_callback = () => {
			this.LoadSuccess()
			this.InitEvent()
		}
	}

	public SetPos(i?) {
		this.index = i
	}

	public LoadSuccess() {
		this.item_group.visible = false
		this.num_label.width = 80
		this.num_label.style.color = "#ffffff"
		this.num_label.style.fontSize = 20
		this.num_label.style.stroke = 1
		this.num_label.style.strokeColor = "#000000"
		this.num_label.style.align = "center"
		this.num_label.style.wordWrap = false

		if (!this.item) {
			this.item = new EquipmentItem(this.item_group)
			this.item.Load()
			this.item.SetItemSize(80, 80)
			this.item.SetShowTips(false)
		}
		if (this.need_refresh) {
			this.InitMatData(this.mat_type, this.parms)
		}
	}

	public InitEvent() {
		let OnAddMatBtnClick = () => {
			if (this.mat_type == 2) {
				if (!this.goodsVo) {
					this.compositeModel.Fire(CompositeModel.OPEN_CHOSE_EQUIPMENT_VIEW, this.index, this.parms, this.mat_type)
				} else {
					UIToolTipMgr.GetInstance().AppendEquipTips(this.mat_id, null, null, this.goodsVo, null, [5])
				}
			} else if (this.mat_type == 1 && this.is_equip) {
				if (!this.goodsVo) {
					let mat_list = []
					for (let _tmpi in this.parms) {
						let vo = this.parms[_tmpi]
						table.insert(mat_list, vo[1])
					}
					this.compositeModel.Fire(CompositeModel.OPEN_CHOSE_EQUIPMENT_VIEW, this.index, mat_list, this.mat_type)
				} else {
					UIToolTipMgr.GetInstance().AppendEquipTips(this.mat_id, null, null, this.goodsVo, null, [5])
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
					if (vo.type_id == this.mat_id && this.parms) {
						this.SetMaterialData(this.parms[0])
						this.compositeModel.Fire(CompositeModel.UPDATA_SUCCESS_RATIO)
					}
				}
			}
		}
		this.BindEvent(this.goodsModel, GoodsModel.UPDATE_GOODS_NUM, OnGoodsChange)
	}

	public InitMatData(mat_pos_type?, parms?) {
		this.mat_type = Number(mat_pos_type)
		if (parms && parms[0]) {
			this.mat_id = Number(parms[0][1])
		}
		this.parms = parms
		this.goodsVo = false
		if (this.is_loaded) {
			if (!this.item) {
				this.item = new EquipmentItem(this.item_group)
				this.item.Load()
			}
			this.item.ClearItemEffect()
			if (mat_pos_type == 1) {
				this.lock_img.visible = false
				let goods_basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(this.mat_id)
				if (goods_basic && goods_basic.type == 10) {
					this.item.SetData(null)
					this.item.SetShowTips(false)
					this.add_img.visible = true
					this.num_label.visible = false
					this.is_equip = true
				} else {
					if (this.parms[0]) {
						this.SetMaterialData(this.parms[0])
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
				this.item.SetData(null)
				this.item.SetIconGaryCom(false)
				this.item.SetShowTips(false)
				this.item_group.visible = true
			} else {
				this.lock_img.visible = true
				this.add_img.visible = false
				this.num_label.visible = false
				this.item.SetData(null)
				this.item.SetIconGaryCom(false)
				this.item.SetShowTips(false)
				this.item_group.visible = false
			}
		} else {
			this.need_refresh = true
		}
	}

	public SetEquipData(goodVo?) {
		this.goodsVo = goodVo
		if (goodVo) {
			this.mat_id = goodVo.type_id
			if (this.is_loaded) {
				this.lock_img.visible = false
				this.add_img.visible = false
				this.num_label.visible = false
				this.item_group.visible = true
				if (this.item) {
					this.item.SetData(this.mat_id, null, this.goodsVo.bind)
					this.item.SetShowTips(false)
				}
			}
		}
	}

	public ReSetItem() {
		this.goodsVo = false
		this.lock_img.visible = false
		this.add_img.visible = true
		this.num_label.visible = false
		this.item.SetData(null)
		this.item.SetShowTips(false)
		this.item_group.visible = true
	}

	public SetMaterialData(parms?) {
		if (parms) {
			let type_id = Number(parms[1])
			let need_count = Number(parms[2])
			if (!this.item) {
				this.item = new EquipmentItem(this.item_group)
				this.item.Load()
				this.item.SetItemSize(80, 80)
			}
			if (this.is_loaded) {
				this.lock_img.visible = false
				this.add_img.visible = false

				if (this.item && need_count) {
					let goods_id = this.goodsModel.GetOneGoodsByTypeId(this.mat_id)
					let now_count = this.goodsModel.GetTypeGoodsNum(this.mat_id)
					if (now_count < need_count) {
						this.num_label.innerHTML = Util.StrToHTML("<font color='#ff4f50'>" + now_count + "</font>/" + need_count
						)
						this.compositeModel.compEquip_regular_glist[type_id] = false
						this.item.SetIconGaryCom(true)
						//this.item.ExcuteCallback(() => {
						this.item.SetShowTips(true)
						this.item.SetData(this.mat_id, null, null, null, null, true)
						//}
						//)
					} else {
						this.compositeModel.compEquip_regular_glist[type_id] = need_count
						this.num_label.innerHTML = now_count + "/" + need_count
						this.item.SetIconGaryCom(false)
						//this.item.ExcuteCallback(() => {
						this.item.SetData(this.mat_id)
						this.item.SetShowTips(true)
						//}
						//)
					}
					if (goods_id) {
						this.compositeModel.equipment_mat_list[this.index] = goods_id
					}
				}
			}
		}
	}

	public DeleteMe() {
		if (this.item) {
			this.item.DeleteMe()
			this.item = null
		}
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
window["CompositeEquipItem"] = CompositeEquipItem
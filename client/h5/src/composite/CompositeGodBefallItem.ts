import { BaseItem1 } from "../common/BaseItem1"
import { table } from "../common/table"
import { Util, SetLocalScale } from "../util/Util"
import { GoodsModel } from "../commonModel/GoodsModel"
import { CompositeModel } from "../commonModel/CompositeModel"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { EquipmentItem } from "../common/EquipmentItem"
import { GodBefallDefine } from "../commonModel/GodBefallModel"

export class CompositeGodBefallItem extends BaseItem1 {
	Dispose
	InitEvent
	InitMatData
	LoadSuccess
	ReSetItem
	SetEquipData
	SetIndex
	SetMaterialData
	compositeModel
	goodsVo
	goods_change_bind
	goods_item
	index
	is_equip
	mat_id
	mat_type
	need_refresh
	parms

	public constructor(parent?, index?) {
		super(parent)
		this.base_file = "composite"
		this.layout_file = "CompositeGodBefallItem"

		this.compositeModel = CompositeModel.GetInstance()
		let ui_tool_tip_mgr = UIToolTipMgr.GetInstance()
		let local_CompositeModel = CompositeModel
		let goods_model = GoodsModel.GetInstance()
		this.need_refresh = false
		this.index = index

		this.load_callback = () => {
			this.LoadSuccess()
			this.InitEvent()
		}

		this.LoadSuccess = () => {
			this.num_label.width = 80
			this.num_label.style.fontSize = 18
			this.num_label.style.color = "#ffffff"
			this.num_label.style.wordWrap = false

			if (this.need_refresh) {
				this.InitMatData(this.mat_type, this.parms)
			}
		}

		this.InitEvent = () => {
			let OnAddMatBtnClick = () => {
				if (this.mat_type == 2) {
					if (!this.goodsVo) {
						this.compositeModel.Fire(local_CompositeModel.OPEN_CHOSE_GOD_VIEW, this.index, this.parms)
					} else {
						ui_tool_tip_mgr.AppendGodEquipTips(this.mat_id, this.goodsVo, [4])
					}
				}
				else if (this.mat_type == 1 && this.is_equip) {
					if (!this.goodsVo) {
						let mat_list = []
						for (let _tmpi in this.parms) {
							let vo = this.parms[_tmpi]
							table.insert(mat_list, vo[1])
						}
						this.compositeModel.Fire(local_CompositeModel.OPEN_CHOSE_GOD_VIEW, this.index, mat_list, this.mat_type)
					} else {
						ui_tool_tip_mgr.AppendGodEquipTips(this.mat_id, this.goodsVo, [4])
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
							this.SetMaterialData(this.parms[0])
							this.compositeModel.Fire(local_CompositeModel.UPDATA_GOD_SUCCESS_RATIO)
						}
					}
				}
			}
			this.goods_change_bind = goods_model.Bind(GoodsModel.UPDATE_GOODS_NUM, OnGoodsChange)
		}

		this.SetIndex = (index?) => {
			this.index = index
		}

		this.InitMatData = (mat_pos_type?, parms?) => {
			this.mat_type = mat_pos_type
			if (parms && parms[0]) {
				this.mat_id = Number(parms[0][1])
			}

			this.parms = parms
			this.goodsVo = false
			if (this.is_loaded) {
				if (this.goods_item) {
					this.goods_item.DeleteMe()
					this.goods_item = null
				}
				if (!this.goods_item) {
					this.goods_item = new EquipmentItem(this.item_group)
					/*
					let loadsuccess = this.goods_item.LoadSuccess
					this.goods_item.LoadSuccess = () => {
						loadsuccess(this.goods_item)
						this.goods_item.click_group.GetComponent("Image").raycastTarget = false
						this.goods_item.item_bg.GetComponent("Image").raycastTarget = false
					}
					*/
					this.goods_item.Load()
					this.goods_item.SetItemSize(80, 80)
				}
				this.goods_item.ClearItemEffect()
				if (mat_pos_type == 1) {
					this.lock_img.visible = false
					let goods_basic = goods_model.GetGoodsBasicByTypeId(this.mat_id)
					if (goods_basic && goods_basic.type == GodBefallDefine.EQUIP_TYPE) {
						this.goods_item.SetData(null)
						this.add_img.visible = true
						this.num_label.visible = false
						this.is_equip = true
						this.item_group.visible = false
					} else {
						if (this.parms[0]) {
							this.SetMaterialData(this.parms[0])
							this.add_img.visible = false
							this.num_label.visible = true
							this.is_equip = false
							this.item_group.visible = true
						}
					}
				}
				else if (mat_pos_type == 2) {
					this.goods_item.SetIconGaryCom(false)
					this.add_img.visible = true
					this.lock_img.visible = false
					this.num_label.visible = false
					this.goods_item.SetData(null)
					this.item_group.visible = false
				} else {
					this.goods_item.SetIconGaryCom(false)
					this.lock_img.visible = true
					this.add_img.visible = false
					this.num_label.visible = false
					this.goods_item.SetData(null)
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
					if (this.goods_item) {
						this.goods_item.SetData(this.mat_id, null, goodVo.bind)
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
			this.item_group.visible = false
			this.goods_item.SetData(null)
		}

		this.SetMaterialData = (parms?) => {
			if (parms) {
				let type_id = Number(parms[1])
				let need_count = Number(parms[2])
				if (this.goods_item) {
					this.goods_item.DeleteMe()
					this.goods_item = null
				}
				if (!this.goods_item) {
					this.goods_item = new EquipmentItem(this.item_group)
					this.goods_item.Load()
					this.goods_item.SetItemSize(80, 80)
				}
				if (this.is_loaded) {
					this.lock_img.visible = true
					this.add_img.visible = true
					if (this.goods_item && need_count) {
						// 有物品取消锁
						this.lock_img.visible = false
						this.add_img.visible = false
						let goods_id = goods_model.GetOneGoodsByTypeId(Number(this.mat_id))
						let now_count = goods_model.GetTypeGoodsNum(Number(this.mat_id))
						if (now_count < need_count) {
							this.num_label.innerHTML = Util.StrToHTML("<font color='#ff4f50'>" + now_count + "</font>/" + need_count)
							this.compositeModel.compEquip_regular_glist[type_id] = false
							this.goods_item.SetIconGaryCom(true)
							this.goods_item.ExcuteCallback(() => {
								this.goods_item.SetShowTips(true)
								this.goods_item.SetData(this.mat_id, null, null, null, null, true)
							}
							)
						} else {
							let goods_vo = goods_model.GetGoodsVoByGoodsId(goods_id)
							this.goods_item.SetIconGaryCom(false)
							this.compositeModel.compEquip_regular_glist[type_id] = true
							this.num_label.innerHTML = now_count + "/" + need_count
							this.goods_item.SetIconGaryCom(false)
							this.goods_item.ExcuteCallback(() => {
								this.goods_item.SetShowTips(true)
								this.goods_item.SetData(this.mat_id, null, goods_vo.bind)
							}
							)
						}
						if (goods_id) {
							this.compositeModel.selected_god_list[this.index] = goods_id
						}
					}
				}
			}
		}

		this.Dispose = () => {
			if (this.goods_change_bind) {
				goods_model.UnBind(this.goods_change_bind)
			}
			if (this.goods_item) {
				this.goods_item.DeleteMe()
			}
			this.goods_item = null
		}
	}

	public DeleteMe() {
		this.Dispose()
		super.DeleteMe()
	}

	gp_con: Laya.Box
	bg: Laya.Image
	item_group: Laya.Box
	lock_img: Laya.Image
	add_img: Laya.Image
	gp_num: Laya.HBox
	num_label: Laya.HTMLDivElement
	_img: Laya.Image
	public GetComponents() {
		[
			this.gp_con,
			this.bg,
			this.item_group,
			this.lock_img,
			this.add_img,
			this.gp_num,
			this.num_label,
			this._img,
		]
			= this.GetChildrenByNames([

				"gp_con",
				"bg",
				"item_group",
				"lock_img",
				"add_img",
				"gp_num",
				"num_label",
				"_img",
			])
	}
}
window["CompositeGodBefallItem"] = CompositeGodBefallItem
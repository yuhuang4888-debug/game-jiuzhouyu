import { BaseView1 } from "../common/BaseView1"
import { Util } from "../util/Util"
import { table } from "../common/table"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { EquipModel } from "../commonModel/EquipModel"
import { EquipWashGoodsItem } from "./EquipWashGoodsItem"

export class EquipWashGoodsView extends BaseView1 {
	InitEvent
	InitView
	Local_Open

	public constructor() {
		super()
		this.base_file = "equip"
		this.layout_file = "EquipWashGoodsView"
		this.layer_value = Enum_UILayer.Activity
		this.use_background = true
		this.click_bg_toClose = true
		this.show_open_movie = true
		this.is_center = true
		this.destroy_imm = true

		let model = EquipModel.GetInstance()
		//let local_Erlang = ErlangParser.GetInstance()
		let pos_info_ = null
		let lock_num_ = null
		let select_extra_ = null
		let select_callBack_ = null
		let washgoodsitem_list_ = []

		this.load_callback = () => {
			this._scr_info.vScrollBar.visible = false
			this.InitEvent()
		}

		this.open_callback = () => {
			this.InitView()
		}

		this.close_callback = () => {
			for (let _tmpi in washgoodsitem_list_) {
				var obj = washgoodsitem_list_[_tmpi]
				obj.DeleteMe()
			}
			washgoodsitem_list_ = []
		}

		this.Local_Open = (...new_args) => {
			pos_info_ = new_args[0]
			lock_num_ = new_args[1]
			select_extra_ = new_args[2]
			select_callBack_ = new_args[3]
			super.Open()
		}

		this.InitView = () => {
			if (!pos_info_) {
				return
			}
			let wash_list = null
			if (pos_info_) {
				let pos = pos_info_.equip_type + "@" + pos_info_.division
				let equip_wash_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_equip_wash", false)
				wash_list = model.GetWashInfo(pos, equip_wash_cfg)
			}
			if (!wash_list) {
				return
			}
			let extra_cost = []
			table.insert(extra_cost, JSON.parse(wash_list["extra_red_cost"]))
			table.insert(extra_cost, JSON.parse(wash_list["extra_orange_cost"]))
			let decriptions = []
			table.insert(decriptions, "必得一条红色或红色以上属性")
			table.insert(decriptions, "必得一条橙色或橙色以上属性")
			let cur_cost = null
			for (let index in extra_cost) {
				for (let _index in extra_cost[index]) {
					if (Number(extra_cost[index][_index][0]) == lock_num_) {
						cur_cost = extra_cost[index][_index][1]
						let goodsitem = new EquipWashGoodsItem(this.Content)
						goodsitem.Load()
						washgoodsitem_list_[index] = goodsitem
						let id = Number(cur_cost[0][1])
						let num = cur_cost[0][2]
						let item_touch_callback = (type_id?, have_num?) => {
							select_callBack_(index, type_id, cur_cost[0][2], have_num)
							this.Close()
						}

						let callback = (id?, num?) => {
							goodsitem.SetData(item_touch_callback, id, num, decriptions[index], select_extra_)
						}

						goodsitem.ExcuteCallback((goods_id?, goods_num?) => {
							if (goods_id == null) {
								goods_id = id
							}
							if (goods_num == null) {
								goods_num = num
							}
							goodsitem.SetData(item_touch_callback, id, num, decriptions[index], select_extra_)
						})
						break
					}
				}
			}
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._img_close, () => {
				this.Close()
			}, this, true)

			Util.AddClickEvent(this.btn_unload, () => {
				for (let _tmpi in washgoodsitem_list_) {
					var item = washgoodsitem_list_[_tmpi]
					item.UnLoadSelect()
				}
				select_callBack_(-2, 0)
				this.Close()
			}, this, true)
		}
	}

	public Open(...new_args) {
		this.Local_Open(...new_args)
	}
	_Image11: Laya.Image
	_img_close: Laya.Image
	_Image4: Laya.Image
	_Image3: Laya.Image
	_Label1: Laya.Label
	_scr_info: Laya.Panel
	Content: Laya.VBox
	btn_unload: Laya.Image
	lb_unload: Laya.Label
	public GetComponents() {
		[
			this._Image11,
			this._img_close,
			this._Image4,
			this._Image3,
			this._Label1,
			this._scr_info,
			this.Content,
			this.btn_unload,
			this.lb_unload,
		]
			= this.GetChildrenByNames([
				"_Image11",
				"_img_close",
				"_Image4",
				"_Image3",
				"_Label1",
				"_scr_info",
				"Content",
				"btn_unload",
				"lb_unload",
			])
	}
}
window["EquipWashGoodsView"] = EquipWashGoodsView
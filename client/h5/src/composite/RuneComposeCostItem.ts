import { BaseItem1 } from "../common/BaseItem1"
import { CompositeModel, CompositeEvent } from "../commonModel/CompositeModel"
import { Util } from "../util/Util"
import { table } from "../common/table"
import { GoodsModel } from "../commonModel/GoodsModel"
import { EquipmentItem } from "../common/EquipmentItem"
import { RuneModel } from "../commonModel/RuneModel"
import { ColorUtil } from "../util/ColorUtil"

export class RuneComposeCostItem extends BaseItem1 {
	data
	item: EquipmentItem
	model
	needRefresh
	now_bag_vo
	show_goods_tips
	type_id

	public constructor(parent?) {
		super(parent)
		this.show_goods_tips = false;
		this.base_file = "composite"
		this.layout_file = "RuneComposeCostItem"
		this.is_load_res = false
		this.is_delay_callback = false
		this.model = CompositeModel.GetInstance()

		this.load_callback = () => {
			this.LoadSuccess()
			this.InitEvents()
		}
	}

	public DeleteMe() {
		if (this.item) {
			this.item.DeleteMe()
			this.item = null
		}
		super.DeleteMe()
	}

	public LoadSuccess() {
	}

	public InitEvents() {
		Util.AddClickEvent(this.click_bg, () => {
			this.model.Fire(CompositeEvent.OPEN_VIEW, "RuneSelectMatView", this.type_id)
		}, this)

		this.BindEvent(this.model, CompositeEvent.SELECT_RUNE_GOODS, (vo?) => {
			if (vo && vo.type_id == Number(this.type_id)) {
				this.model.DelRuneComposeAwake(this.now_bag_vo.awake_list)
				this.RefreshItemData(vo, true)
				this.model.Fire(CompositeEvent.REFRESH_MSG_AFTER_SELECT)
			}
		})

		let update_fun = () => {
			if (this.data) {
				this.SetData(this.data)
			}
		}
		this.BindEvent(GoodsModel.GetInstance(), GoodsModel.CHANGE_RUNE_BAG_LIST, update_fun)

		if (this.needRefresh) {
			this.SetData(this.data)
		}
	}

	public SetData(data?) {
		this.data = data
		this.now_bag_vo = null
		if (this.is_loaded) {
			this._img_wear.visible = false
			if (!this.item) {
				this.item = new EquipmentItem(this.conta)
				this.item.Load()
				this.item.SetItemSize(80, 80)
			}
			let type_id, lock
			[type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(this.data[0], this.data[1])
			this.type_id = type_id
			let goods_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
			if (goods_vo) {
				this._lb_name.text = goods_vo.goods_name
				this._lb_name.color = ColorUtil.GetReplaceChar(ColorUtil.GetColorDark(goods_vo.color))
				this.item.SetData(type_id, 1)
				this.item.SetIconGaryCom(false)
				this.item.SetStrengthen(1)
				let my_have = this.GetTheSameTypeGoods(Number(type_id))
				let str = ""
				this.click_bg.visible = true
				this._img_awaken.visible = false
				if (my_have) {
					if (my_have.length >= Number(this.data[2])) {
						str = my_have.length + "/" + this.data[2]
						this.RefreshItemData(my_have[0])
					} else {
						str = "<font color='#ff4f50'>" + my_have.length + "</font>/" + this.data[2]
						if (my_have.length == 0) {
							this.item.SetIconGaryCom(true)
							this.click_bg.visible = false
						}
					}
				}
			}
		} else {
			this.needRefresh = true
		}
	}

	public RefreshItemData(now_bag_vo?, not_fire?) {
		this.now_bag_vo = now_bag_vo
		let awake = false
		this._img_wear.visible = false
		if (this.now_bag_vo) {
			this.item.SetData(this.now_bag_vo.type_id, 1)
			this.item.SetStrengthen(now_bag_vo.level)
			for (let key in now_bag_vo.awake_list) {
				let awakeInfo = now_bag_vo.awake_list[key]
				if (awakeInfo.awake_lv > 0) {
					awake = true
					break
				}
			}
			if (awake) {
				CompositeModel.GetInstance().SaveRuneComposeAwake(now_bag_vo.awake_list)
			}

			this._img_wear.visible = RuneModel.GetInstance().IsRuneDress(now_bag_vo)
		}
		this._img_awaken.visible = awake
	}

	public GetTheSameTypeGoods(type_id?) {
		let list = []


		let wear_info = RuneModel.GetInstance().GetWearRuneSame(type_id)
		if (wear_info) {
			table.insert(list, wear_info)
		}



		let rune_list = GoodsModel.GetInstance().runebag_goods_list
		for (let _tmpi in rune_list) {
			let obj = rune_list[_tmpi]
			if (obj.type_id == type_id && obj.sybtype != 99) {
				table.insert(list, obj)
			}
		}

		let sort_fun = (a?, b?) => {
			let a_v = RuneModel.GetInstance().IsRuneDress(a) ? 1 : 0
			let b_v = RuneModel.GetInstance().IsRuneDress(b) ? 1 : 0
			if (a_v != b_v) {
				return a_v > b_v
			}
			return a.level < b.level
		}


		table.sort(list, sort_fun)
		return list
	}



	conta: Laya.Box
	num: Laya.Label
	click_bg: Laya.Box
	_img_awaken: Laya.Image
	_img_wear: Laya.Image
	_lb_name: Laya.Label
	public GetComponents() {
		[
			this.conta,
			this.num,
			this.click_bg,
			this._img_awaken,
			this._img_wear,
			this._lb_name,
		]
			= this.GetChildrenByNames([

				"conta",
				"num",
				"click_bg",
				"_img_awaken",
				"_img_wear",
				"_lb_name",
			])
	}
}
window["RuneComposeCostItem"] = RuneComposeCostItem
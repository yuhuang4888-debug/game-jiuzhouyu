import { BaseItem1 } from "../common/BaseItem1"
import { EquipmentItem } from "../common/EquipmentItem"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
import { CycleimpActlistEvent, CycleimpActlistModel } from "../commonModel/CycleimpActlistModel"

export class SelectGiftItem extends BaseItem1 {
	num
	cfg
	award
	call_back
	index
	is_cyc

	public constructor(parent?) {
		super(parent)
		this.base_file = "bag"
		this.layout_file = "SelectGiftItem"

		this.num = 0

		this.load_callback = () => {
			this.name_label.style.fontSize = 22
			this.name_label.style.color = "#ff0000"
			this.name_label.style.wordWrap = false

			this.LoadSuccess()
			this.InitEvent()
		}
	}

	public LoadSuccess() {
		if (this.is_loaded) {
			// ResManager.GetInstance().SetOutsideImageSprite(this, this.bg, GameResPath.GetIcon("bag", "uitc_007"))
			// ResManager.GetInstance().SetOutsideImageSprite(this, this._Image1111, GameResPath.GetIcon("bag", "uitc_010"), true)
			if (this.cfg) {
				this.InitView()
				this.SetNum(0)
				let id = this.GetCycleimpGoods()
				let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(this.cfg[0], this.cfg[1])
				if (this.is_cyc && id && id == type_id) {
					if (this.call_back && this.cfg) {
						this.call_back(this.index, "max", this)
					}
				}
			}
		}
	}

	public InitEvent() {
		Util.AddClickEvent(this.reduce_btn, () => {
			if (this.call_back && this.cfg) {
				this.call_back(this.index, -1, this)
			}
		}, this, true)

		Util.AddClickEvent(this.increase_btn, () => {
			if (this.call_back && this.cfg) {
				this.call_back(this.index, 1, this)
			}
		}, this, true)

		Util.AddClickEvent(this.max_btn, () => {
			if (this.call_back && this.cfg) {
				this.call_back(this.index, "max", this)
			}
		}, this, true)

		Util.AddClickEvent(this.num_bg, () => {
			if (this.call_back && this.cfg) {
				let pos = this.num_bg.localToGlobal(new Laya.Point(0, 0))
				let x = pos.x - Laya.stage.width / 2 + 100
				let y = pos.y - Laya.stage.height / 2
				this.call_back(this.index, "zixuan", this, [x, y])
			}
		}, this, false)
	}

	public InitView() {
		if (!this.award) {
			this.award = new EquipmentItem(this.item_group, null, Enum_UILayer.Activity)
			this.award.SetItemSize(86, 86)
			// this.award.SetUseMask(true)
			this.award.Load()
		}
		let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(this.cfg[0], this.cfg[1])
		let goods_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
		if (goods_vo) {
			this.award.SetData(goods_vo.type_id, this.cfg[2])
			this.name_label.innerHTML = Util.StrToHTML(GoodsModel.GetGoodsNameWithColorDark(goods_vo.type_id))
			this.haveLb.text = "拥有:" + GoodsModel.GetInstance().GetTypeGoodsNum(goods_vo.type_id)
		}

	}

	public SetNum(num?) {
		if (this.is_loaded) {
			this.num = num
			this.num_label.text = String(num)
		}
	}

	public SetData(cfg?, call_back?, index?, is_cyc = false) {
		this.cfg = cfg
		this.call_back = call_back
		this.index = index
		this.is_cyc = is_cyc
		this.LoadSuccess()
	}

	public GetCycleimpGoods = () => {
		let _model = CycleimpActlistModel.GetInstance()
		if (_model.type == 0) return false
		if (_model.type == 1) {
			return 16020004
		} else if (_model.type == 2) {
			return 17020004
		} else if (_model.type == 3) {
			return 18020004
		} else if (_model.type == 4) {
			return 19020004
		} else if (_model.type == 5) {
			return 20020004
		}else if (_model.type == 6) {
			return 25020004
		} else
			return false
	}

	public DeleteMe() {
		if (this.award) {
			this.award.DeleteMe()
			this.award = null
		}
		super.DeleteMe()
	}

	_Group1: Laya.Box
	bg: Laya.Image
	item_group: Laya.Box
	num_bg: Laya.Image
	name_label: Laya.HTMLDivElement
	num_label: Laya.Label
	reduce_btn: Laya.Box
	_Image111: Laya.Image
	increase_btn: Laya.Box
	_Image11: Laya.Image
	max_btn: Laya.Box
	_Image1: Laya.Image
	haveLb: Laya.Label
	public GetComponents() {
		[
			this._Group1,
			this.bg,
			this.item_group,
			this.num_bg,
			this.name_label,
			this.num_label,
			this.reduce_btn,
			this._Image111,
			this.increase_btn,
			this._Image11,
			this.max_btn,
			this._Image1,
			this.haveLb,
		]
			= this.GetChildrenByNames([
				"_Group1",
				"bg",
				"item_group",
				"num_bg",
				"name_label",
				"num_label",
				"reduce_btn",
				"_Image111",
				"increase_btn",
				"_Image11",
				"max_btn",
				"_Image1",
				"haveLb",
			])
	}
}
window["SelectGiftItem"] = SelectGiftItem
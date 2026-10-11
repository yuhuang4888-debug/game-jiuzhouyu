import { BaseItem1 } from "../common/BaseItem1"
import { Util } from "../util/Util"
import { GoodsModel } from "../commonModel/GoodsModel"
import { BaseAwardItem } from "../common/BaseAwardItem"

export class EquipWashGoodsItem extends BaseItem1 {
	awarditem
	good_type
	have_num
	need_num
	touch_CallBack

	public constructor(parent?) {
		super(parent)
		this.base_file = "equip"
		this.layout_file = "EquipWashGoodsItem"

		this.load_callback = () => {
			this.InitEvent()
		}
	}

	public InitEvent() {
		//this._gp_gooditem.addEventListener(Laya.TouchEvent.TOUCH_BEGIN,() => {
		//this._gp_tween.scaleY = 0.9
		//this._gp_tween.scaleX = this._gp_tween.scaleY
		//}
		//, this)
		//this._gp_gooditem.addEventListener(Laya.TouchEvent.TOUCH_END,() => {
		//this._gp_tween.scaleY = 1
		//this._gp_tween.scaleX = this._gp_tween.scaleY
		//}
		//, this)
		//this._gp_gooditem.addEventListener(Laya.TouchEvent.TOUCH_CANCEL,() => {
		//this._gp_tween.scaleY = 1
		//this._gp_tween.scaleX = this._gp_tween.scaleY
		//}
		//, this)

		Util.AddClickEvent(this._gp_gooditem, () => {
			this.touch_CallBack(this.good_type, this.have_num)
		}, this, true)

		this.BindEvent(GoodsModel.GetInstance(), GoodsModel.UPDATE_GOODS_NUM, (goods_list?) => {
			if (this.use_delete_method) {
				return
			}
			for (let _tmpi in goods_list) {
				var vo = goods_list[_tmpi]
				if (vo.type_id == this.good_type) {
					this.have_num = GoodsModel.GetInstance().GetTypeGoodsNum(this.good_type)
					this.lb_num.color = (this.have_num >= this.need_num && ("#b3ff48") || ("#ff4f50"))
					this.lb_num.text = this.have_num 
					this.lb_need.text = "/" + this.need_num
				}
			}
		})
	}

	public SetData(touchCallBack?, goods_type?, need_num?, description?, select_extra?) {
		this.touch_CallBack = touchCallBack
		this.good_type = goods_type
		if (goods_type) {
			if (!this.awarditem) {
				this.awarditem = new BaseAwardItem(this._gp_awarditem)
				this.awarditem.Load()
			}
			this.awarditem.ExcuteCallback(() => {
				this.awarditem.SetData(goods_type, 0, false, null, null)
				this.awarditem.SetItemSize(84, 84)
			})
		}
		if (need_num) {
			this.have_num = GoodsModel.GetInstance().GetTypeGoodsNum(goods_type)
			this.need_num = Number(need_num)
			this.lb_num.color = (this.have_num >= this.need_num && ("#b3ff48") || ("#ff4f50"))
			this.lb_num.text = this.have_num
			this.lb_need.text = "/" + this.need_num
		}
		if (description) {
			this._lb_dec.text = description
		}
		if (select_extra == this.good_type) {
			this._img_select.visible = true
		} else {
			this._img_select.visible = false
		}
	}

	public UnLoadSelect() {
		this._img_select.visible = false
	}

	public DeleteMe() {
		if (this.awarditem) {
			this.awarditem.DeleteMe()
			this.awarditem = null
		}
		
		super.DeleteMe()
	}

	_Group2: Laya.Box
	_gp_tween: Laya.Box
	_Image1: Laya.Image
	_lb_dec: Laya.Label
	_gp_gooditem: Laya.Box
	_gp_item: Laya.Box
	_gp_awarditem: Laya.Box
	_Image2: Laya.Image
	gp_num: Laya.HBox
	lb_num: Laya.Label
	lb_need: Laya.Label
	_img_select: Laya.Image
	public GetComponents() {
		[
			this._Group2,
			this._gp_tween,
			this._Image1,
			this._lb_dec,
			this._gp_gooditem,
			this._gp_item,
			this._gp_awarditem,
			this._Image2,
			this.gp_num,
			this.lb_num,
			this.lb_need,
			this._img_select,
		]
			= this.GetChildrenByNames([

				"_Group2",
				"_gp_tween",
				"_Image1",
				"_lb_dec",
				"_gp_gooditem",
				"_gp_item",
				"_gp_awarditem",
				"_Image2",
				"gp_num",
				"lb_num",
				"lb_need",
				"_img_select",
			])
	}
}

window["EquipWashGoodsItem"] = EquipWashGoodsItem
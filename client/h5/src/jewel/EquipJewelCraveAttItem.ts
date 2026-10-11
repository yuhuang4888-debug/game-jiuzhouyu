import { BaseItem1 } from "../common/BaseItem1"
import { ResManager } from "../common/ResManager"
import { WordManager } from "../common/WordManager"
import { Mathf } from "../util/Mathf"
import { Util } from "../util/Util"

export class EquipJewelCraveAttItem extends BaseItem1 {
	SetData
	SetPropUP

	public constructor(parent?) {
		super(parent)
		this.base_file = "jewel"
		this.layout_file = "EquipJewelCraveAttItem"

		let crave_cur_data_ = null
		let crave_next_data_ = null
		let jewel_cur_data_ = null
		let now_overall_plus_ = null
		let next_overall_plus_ = null
		let prop_cache_ = null
		let prop_crave_cur_data_ = null
		let prop_crave_next_data_ = null

		this.load_callback = () => {
			if (crave_cur_data_ || crave_next_data_) {
				this.SetData(crave_cur_data_, crave_next_data_, jewel_cur_data_, now_overall_plus_, next_overall_plus_)
			}
			if (prop_cache_) {
				this.SetPropUP(prop_crave_cur_data_, prop_crave_next_data_)
				prop_cache_ = false
			}
		}

		this.SetData = (crave_cur_data?, crave_next_data?, jewel_cur_data?, now_overall_plus?, next_overall_plus?) => {
			crave_cur_data_ = crave_cur_data
			crave_next_data_ = crave_next_data
			jewel_cur_data_ = jewel_cur_data
			now_overall_plus_ = Number(now_overall_plus)
			next_overall_plus_ = Number(next_overall_plus)
			if (this.is_loaded) {
				this.lb_curName.text = WordManager.GetProperties(crave_cur_data_[0])
				if (jewel_cur_data_) {
					this.lb_curValue.text = "+" + String(Number(crave_cur_data_[1]) + Mathf.Round(Number(jewel_cur_data) * (now_overall_plus / 100 + 1)))
				} else {
					this.lb_curValue.text = "+" + String(crave_cur_data_[1])
				}
				this.img_arrow.visible = (crave_next_data_ && (true || (false)))
				this.gp_next.visible = this.img_arrow.visible
				if (crave_next_data_ && next_overall_plus_) {
					this.lb_nextName.text = WordManager.GetProperties(crave_next_data_[0])
					if (jewel_cur_data) {
						this.lb_nextValue.text = "+" + String(Number(crave_next_data_[1]) + Mathf.Round(Number(jewel_cur_data) * (next_overall_plus / 100 + 1)))
					} else {
						this.lb_nextValue.text = "+" + String(crave_next_data_[1])
					}
				}
			}
		}

		this.SetPropUP = (cur_data?, next_data?) => {
			prop_crave_cur_data_ = cur_data
			prop_crave_next_data_ = next_data
			if (this.is_loaded) {
				this.lb_curName.text = "宝石属性提升:"
				this.lb_curValue.text = "+" + prop_crave_cur_data_ + "%"
				let show_next = (prop_crave_next_data_ && (true || (false)))
				this.img_arrow.visible = show_next
				this.gp_next.visible = show_next
				this.lb_nextName.text = show_next ? "宝石属性提升:" : ""
				this.lb_nextValue.text = show_next ? ("+" + prop_crave_next_data_ + "%") : ""
			} else {
				prop_cache_ = true
			}
		}
	}

	public DeleteMe() {
		this.ClearUIEffect(this.effect_group)
		super.DeleteMe()
	}

	public PlayEffect() {
		// ResManager.GetInstance().SetUIEffect2(this,"ui_refresh_glow", this.effect_group, undefined, {x=1.5, y=1}, undefined, undefined, undefined, undefined, undefined, true)
	}

	gp_cur: Laya.HBox
	lb_curName: Laya.Label
	lb_curValue: Laya.Label
	gp_next: Laya.HBox
	lb_nextName: Laya.Label
	lb_nextValue: Laya.Label
	img_arrow: Laya.Image
	effect_group: Laya.Box
	public GetComponents() {
		[
			this.gp_cur,
			this.lb_curName,
			this.lb_curValue,
			this.gp_next,
			this.lb_nextName,
			this.lb_nextValue,
			this.img_arrow,
			this.effect_group,
		]
			= this.GetChildrenByNames([

				"gp_cur",
				"lb_curName",
				"lb_curValue",
				"gp_next",
				"lb_nextName",
				"lb_nextValue",
				"img_arrow",
				"effect_group",
			])
	}
}
window["EquipJewelCraveAttItem"] = EquipJewelCraveAttItem
import { GoodsTooltips } from "../common/GoodsTooltips"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"

export class PetCrystalView extends GoodsTooltips {
	SetSmeltStr

	public constructor() {
		super()
		// this.base_file="pet"
		// this.layout_file="PetCrystalView"
		// let local_eui = eui
		let local_util = Util,
			smelt_str_,
			max_str_,
			crystalBG_,
			crystal_max_label_
		this.OpenCallback = () => {
			super.OpenCallback()
			this.quantity_text.innerHTML = local_util.StrToHTML(`已吞噬:<font color='#ffe222'>${smelt_str_}</font>`)
		}

		this.SetSmeltStr = (smelt_str?, max_str?) => {
			smelt_str_ = smelt_str
			max_str_ = max_str
			if (this.HasOpen()) {
				this.quantity_text.innerHTML = local_util.StrToHTML(`已吞噬:<font color='#ffe222'>${smelt_str_}</font>`)
				if (max_str_) {
					crystal_max_label_.textFlow = local_util.StrToHTML(max_str_)
				}
			}
		}

		this.SetTipsHeight = () => {
			if (!max_str_) {
				super.SetTipsHeight()
				if (crystalBG_) {
					crystalBG_.visible = false
				}
				if (crystal_max_label_) {
					crystal_max_label_.visible = false
				}
			} else {
				if (!crystalBG_) {
					crystalBG_ = new Laya.Image()
					this.display_obj.addChild(crystalBG_)
					// crystalBG_.source = "common2_json.uity_016c_png"
					ResManager.GetInstance().SetImageSpriteTrans(this, crystalBG_, GameResPath.GetIcon("common2", "uity_016c"))
					crystalBG_.horizontalCenter = 0
				}
				crystalBG_.visible = true
				if (!crystal_max_label_) {
					crystal_max_label_ = new Laya.Label()
					this.display_obj.addChild(crystal_max_label_)
					crystal_max_label_.x = 30
					crystal_max_label_.textAlign = "left"
					crystal_max_label_.size = 22
				}
				crystal_max_label_.textFlow = local_util.StrToHTML(max_str_)
				crystal_max_label_.visible = true

				let overdueTextHeight = 0
				let coolingTimeTextHeight = 0
				if (this.overdueText.visible) {
					overdueTextHeight = this.overdueText.contextHeight
				}
				if (this._gp_cooling.visible) {
					// this._gp_cooling.validateNow()
					coolingTimeTextHeight = this.coolingTimeText.height > 0 ? this._gp_cooling.height : 0
				}
				let crystal_height = 40
				let textSpacing = overdueTextHeight > 0 && coolingTimeTextHeight > 0 ? 10 : 0;
				let line_num = Math.ceil(this.btn_group.numChildren / 2)
				let btn_group_height = line_num * 65 + 20
				this.btn_group.height = btn_group_height
				let all_height = this.detail_scroller.y + this.detail_group.height + 10 + overdueTextHeight + btn_group_height + 10 + crystal_height
				let max = all_height
				if (all_height > 800) {
					max = 800
				} else if (all_height < 450) {
					max = 450
				}
				let new_scroll_height = max - btn_group_height - 10 - overdueTextHeight - 10 - coolingTimeTextHeight - textSpacing - this.detail_scroller.y - crystal_height
				this.detail_scroller.height = new_scroll_height
				this.detail_group.height = new_scroll_height
				crystalBG_.y = max - btn_group_height - 8 - crystal_height
				crystal_max_label_.y = max - btn_group_height - crystal_height
				this.btn_group.y = max - btn_group_height - 8;
				if (this.overdueText.visible) {
					this.overdueText.y = this.btn_group.y - overdueTextHeight
				}
				if (this._gp_cooling.visible) {
					this._gp_cooling.y = this.btn_group.y - overdueTextHeight - coolingTimeTextHeight - textSpacing
				}
				this.bg.height = max
				this.display_obj.height = max
			}
		}

	}

}
window["PetCrystalView"] = PetCrystalView
import { BaseItem1 } from "../common/BaseItem1"
import { EquipmentItem } from "../common/EquipmentItem"
import { ResManager } from "../common/ResManager"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { ErlangParser } from "../util/ErlangParser"

export class LTItem extends BaseItem1 {

	b
	cur_sorting_order
	grade_info
	item
	s

	public constructor(parent?) {
		super(parent)



		this.base_file = "luckyTreasure"
		this.layout_file = "LTItem"
		this.load_callback = () => {
		}
	}


	public InitView() {


		let info = this.grade_info
		if (!info) {
			return
		}
		let is_big_Box = false
		let rew = null
		if (info.reward == "[]") {
			is_big_Box = true
		} else if (info.reward) {
			rew = ErlangParser.GetInstance().Parse(info.reward)
			rew = rew && rew[0]
		}
		this._diam.visible = is_big_Box
		this._num.visible=this._desc.visible = is_big_Box
		//this._bg.visible = bool 
		this._item.visible = !is_big_Box
		let cond = CustomActivityModel.GetInstance().GetActCondition(this.b, this.s, "data", info.grade)
		if (!is_big_Box && rew) {
			if (!this.item) {
				this.item = new EquipmentItem(this._item, null, this.layer_value)
				this.item.SetCacheSortOrder(this.cur_sorting_order)
				this.item.Load()
				this.item.SetItemSize(89, 89)
			}
			this.item.ExcuteCallback(() => {
				let [type, lock] = GoodsModel.GetInstance().GetMappingTypeId(rew[0], rew[1])
				this.item.SetData(type, rew[2], lock)
			}
			)
			ResManager.GetInstance().SetImageSprite(this, this._bg, "luckyTreasure", "uixytb_007a")
			this._bg.height=120
		} else if (is_big_Box) {
			let img_url = info.grade==1?"uixytb_008b":"uixytb_008a"
			ResManager.GetInstance().SetImageSprite(this, this._bg, "luckyTreasure", img_url)
			this._bg.height=154
			if (cond) {
				ResManager.GetInstance().SetImageSprite(this, this._diam, "luckyTreasure", String(cond.img), true)
				this._num.text=`${cond.reward}%`
			}
		}
		let effect_url = null
		let pos = null
		let rare_url = null
		if (is_big_Box) {
			effect_url = "ui_2033_1"
		}
		if (cond) {
			pos = ((!is_big_Box) && (rew && rew != 0)) && { x: 0, y: 0 } || { x: 0, y: 15 }
			let vis = ((!is_big_Box) && (rew && rew != 0)) && cond.rare == "1"
			this._rare.visible = vis
		}
		if (effect_url) {
			// this.AddUIEffect(effect_url, this._rare_eff, { x: 0, y: 0 }, 1, true)
			// this.AddUIEffect("ui_2033", this.bg_effect, { x: 0, y: 0 }, 1, true)
		}
	}

	public SetData(...new_args) {

		let args = new_args
		this.grade_info = args[0]
		this.b = args[1]
		this.s = args[2]
		this.cur_sorting_order = args[4]
		this.InitView()
	}

	public DeleteMe() {

		this.ClearUIEffect(this._rare_eff)
		this.ClearUIEffect(this.bg_effect)
		if (this.item) {
			this.item.DeleteMe()
			this.item = null
		}
		super.DeleteMe()
	}


_bg:Laya.Image
_item:Laya.Box
_rare:Laya.Image
_diam:Laya.Image
_desc:Laya.Image
_num:Laya.Label
_rare_eff:Laya.Box
bg_effect:Laya.Box
public GetComponents() {
[
this._bg,
this._item,
this._rare,
this._diam,
this._desc,
this._num,
this._rare_eff,
this.bg_effect,
]
 = this.GetChildrenByNames([

"_bg",
"_item",
"_rare",
"_diam",
"_desc",
"_num",
"_rare_eff",
"bg_effect",
])
}
}
 window["LTItem"]= LTItem
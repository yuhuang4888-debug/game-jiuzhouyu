import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { EquipmentItem } from "../common/EquipmentItem"
import { ResManager } from "../common/ResManager"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { Util } from "../util/Util"

export class SelectItem extends BaseItemRenderer {
	_gp_reward: Laya.Box
	_img_select: Laya.Image
	_img_lock: Laya.Image
	item
	model

	public static width = 111 + 6
	public static height = 111 + 6
	WIDTH = 90
    HEIGT = 90
	public constructor(parent) {
		super()

		this.model = CustomActivityModel.GetInstance()
		this.item = null
		this.base_file = "optionalLotto"
		this.layout_file = "SelectItem"
		//this.layer_value = Enum_UILayer.Activity
		this.load_callback = () => {

			this.InitEvent()
		}
		this.Load()
	}

	public InitEvent() {


		Util.AddClickEvent(this._img_select, () => {
			let callback = this.data.Select_Callback
			if (callback) {
				callback(this.data)
			}
		}
			, this, true)
	}

	public dataChanged() {
		if (super.dataChanged()){
			if (this.data) {
				this.InitView()
			}
		}
		
	}

	public InitView() {

		let data = this.data
		let b = data.base_type
		let s = data.sub_type
		let rewards = this.model.GetActReward(b, s, data.form_type, data.reward)
		if (rewards && rewards[0]) {
			let rew = rewards[0]
			let [type, lock] = GoodsModel.GetInstance().GetMappingTypeId(rew[0], rew[1])
			if (!this.item) {
				this.item = new EquipmentItem(this._gp_reward)
				//this.item.SetMaskId(1)
				this.item.Load()
				this.item.SetItemSize(90, 90)
			}
			this.item.ExcuteCallback(() => {
				this.item.SetData(type, rew[2], lock)
			}
			)
		}
		let grade = data.grade
		let select_grade = data.select_grade
		let rare = data.rare
		let need_num = data.need_num[rare]
		let select_num = data.rare_select_num[rare]

		//选中或未选满
		let select_bool = ((select_grade[grade] || Number(need_num) != Number(select_num)) && (true) || (false))
		this._img_select.visible = select_bool

		//未选中且选满
		let lock_bool = !select_grade[grade] && Number(need_num) == Number(select_num)
		this._img_lock.visible = lock_bool

		if (select_bool) {
			let s_url = select_grade[grade] && "uizxbx_001a" || "uizxbx_001b"
			ResManager.GetInstance().SetImageSprite(this, this._img_select, "optionalLotto_asset", s_url)
		}
	}

	public DeleteMe() {

		if (this.item) {
			this.item.DeleteMe()
			this.item = null
		}
		super.DeleteMe()
	}


	public GetComponents() {
		[
			this._gp_reward,
			this._img_select,
			this._img_lock,
		]
			= this.GetChildrenByNames([

				"_gp_reward",
				"_img_select",
				"_img_lock",
			])
	}
}
window["SelectItem"] = SelectItem
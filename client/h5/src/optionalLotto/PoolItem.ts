import { BaseItem1 } from "../common/BaseItem1"
import { EquipmentItem } from "../common/EquipmentItem"
import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { Util } from "../util/Util"

export class PoolItem extends BaseItem1 {
	_img_bg: Laya.Image
	_img_select: Laya.Image
	_img_add: Laya.Image
	_gp_reward: Laya.Box
	_img_rare: Laya.Image
	_img_status: Laya.Image
	base_type
	cur_info
	item
	model
	pool_dic
	rare
	sub_type

	public constructor(parent?) {
		super(parent)

		this.model = CustomActivityModel.GetInstance()
		this.cur_info = null
		this.pool_dic = null
		this.base_type = null
		this.sub_type = null
		this.rare = null
		this.item = null

		this.base_file = "optionalLotto"
		this.layout_file = "PoolItem"
		this.load_callback = () => {

			this.InitEvent()
		}


	}

	public InitEvent() {


		Util.AddClickEvent(this._img_add, () => {
			GlobalEventSystem.Fire(EventName.OPEN_VIEW, "SelectView", this.base_type, this.sub_type,this.rare)
		}
			, this, true)

		this.BindEvent(this.model, CustomActivityDefine.EVENT.UP_GRADE, (...new_args) => {
			let args = new_args
			if (this.cur_info && args[1] == this.base_type && args[2] == this.sub_type) {
				this._img_select.visible = args[3] == this.cur_info.grade
			}
		}
		)
	}

	public InitView() {

		let info = this.cur_info
		let pool = this.pool_dic
		this._img_add.visible = !info
		this._img_add.mouseEnabled = !info
		this.SetBg()
		if (!info || !pool) {
			this._img_status.visible = false
			if (this.item) {
				this.item.DeleteMe()
				this.item = null
			}
			return
		}
		this._img_status.visible = info.status != null && info.status != 0
		let vo = pool[info.rare] && pool[info.rare][info.grade]
		let reward = this.model.GetActReward(this.base_type, this.sub_type, vo.form_type, vo.reward)
		if (reward && reward[0]) {
			let rew = reward[0]
			if (!this.item) {
				this.item = new EquipmentItem(this._gp_reward)
				this.item.Load()
				this.item.SetItemSize(85, 85)
			}
			this.item.ExcuteCallback(() => {
				let [type, lock] = GoodsModel.GetInstance().GetMappingTypeId(rew[0], rew[1])
				this.item.SetData(type, rew[2], lock)
			}
			)
		}
	}

	public SetBg() {
		let rare = this.rare
		if (this.cur_info) {
			rare = this.cur_info.rare
		}
		let url = null
		let rare_url = null
		if (rare == 2) {
			url = "011"
			rare_url = "003"
		} else if (rare == 1) {
			url = "010"
			rare_url = "004"
		} else {
			url = "008"
			rare_url = "005"
		}
		ResManager.GetInstance().SetImageSprite(this, this._img_bg, "optionalLotto_asset", "uizxjc_" + url)
		ResManager.GetInstance().SetImageSprite(this, this._img_rare, "optionalLotto_asset", "uizxjc_" + rare_url)
	}

	public SetData(...new_args) {

		let args = new_args
		this.cur_info = args[0]
		this.pool_dic = args[1]
		this.base_type = args[2]
		this.sub_type = args[3]
		this.rare = args[4] - 1
		this.InitView()
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
			this._img_bg,
			this._img_select,
			this._img_add,
			this._gp_reward,
			this._img_rare,
			this._img_status,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_img_select",
				"_img_add",
				"_gp_reward",
				"_img_rare",
				"_img_status",
			])
	}
}
window["PoolItem"] = PoolItem
import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItem1 } from "../common/BaseItem1"
import { MondaysAwardModel } from "../commonModel/MondaysAwardModel"



export class MondaysAwardChnageRewardItem extends BaseItem1 {
	_gp_add
	_gp_reward
	_item
	_model
	need_refresh
	num
	type_id



	public constructor(parent?) {
		super(parent)
		this.base_file = "mondaysaward"
		this.layout_file = "MondaysAwardChnageRewardItem"
		this._model = MondaysAwardModel.GetInstance()
		this.load_callback = () => {
			if (this.need_refresh) {
				this.SetData(this.type_id, this.num)
			}
		}
	}

	public DeleteMe() {
		if (this._item) {
			this._item.DeleteMe()
		}
		super.DeleteMe()
	}

	public SetData(type_id?, num?, scale?) {
		if (this.is_loaded) {
			if (type_id) {
				if (!this._item) {
					this._item = new BaseAwardItem(this._gp_reward, null, "Activity")
					this._item.Load()
					this._item.SetScale(0.75)
				}
				this._item.SetData(type_id, num)
			}
			let bool = type_id != null
			this._gp_reward.visible = bool
			this._gp_add.visible = !bool
		} else {
			this.type_id = type_id
			this.num = num
			this.need_refresh = true
		}
	}

	_Image1: Laya.Image
	_Image2: Laya.Image
	public GetComponents() {
		[
			this._gp_reward,
			this._gp_add,
			this._Image1,
			this._Image2,
		]
			= this.GetChildrenByNames([

				"_gp_reward",
				"_gp_add",
				"_Image1",
				"_Image2",
			])
	}
}
window["MondaysAwardChnageRewardItem"] = MondaysAwardChnageRewardItem

import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItem1 } from "../common/BaseItem1"
import { Enum_UILayer } from "../common/LayerManager"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { ErlangParser } from "../util/ErlangParser"
import { Util } from "../util/Util"

export class FtvActivenessPersonalItem extends BaseItem1 {
	_gp_btn: Laya.Box
	_gp_awarditem: Laya.Box
	_img_mask: Laya.Image
	_img_received: Laya.Image
	_Image1: Laya.Image
	_lb_dec: Laya.Label
	_red: Laya.Image

	awardItem
	cache_curr_sorting_order
	data
	info
	next_curr_sorting_order

	public constructor(parent?) {
		super(parent)


		this.base_file = "ftvActiveness"
		this.layout_file = "FtvActivenessPersonalItem"
		this.layer_value = Enum_UILayer.UI
		this.load_callback = () => {

			// this.ReplaceUIShader(this._red)
			this.InitEvent()
		}


	}

	public InitEvent() {

		let onReceived = () => {
			if (this.data && this.info) {
				if (this.data.status == 1) {
					CustomActivityModel.GetInstance().Fire(CustomActivityDefine.EVENT.SCMD_REQUEST, 33105, this.info.base_type, this.info.sub_type, this.data.grade)
				}
			}
		}

		Util.AddClickEvent(this._gp_awarditem, onReceived, this, true)
	}

	public InitView() {


		if (!this.awardItem) {
			this.awardItem = new BaseAwardItem(this._gp_awarditem)
			// this.awardItem.SetMaskId(1)
			// this.cache_curr_sorting_order = this.AddCurrLayerSortingOrder(this.layer_value)
			// this.awardItem.SetCacheSortOrder(this.cache_curr_sorting_order)
			// this.next_curr_sorting_order = this.AddCurrLayerSortingOrder(this.layer_value)
			// this.CoverMode(this._red, "UI", this.next_curr_sorting_order)

			this.awardItem.Load()
			this.awardItem.SetItemSize(80, 80)
		}
		let reward = this.data.reward
		if (typeof (reward) == "string") {
			reward = ErlangParser.GetInstance().Parse(reward)
		}
		let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(reward[0][0], reward[0][1])
		this.SetAction(this.data.status, type_id)
		this.awardItem.ExcuteCallback(() => {
			this.awardItem.SetData(type_id, reward[0][2], lock)
		}
		)
		let person_times = CustomActivityModel.GetInstance().GetActData(this.info.base_type, this.info.sub_type).person_times
		this._lb_dec.text = this.data.condition[0][1] + "个"
	}

	public SetAction(status?, type_id?) {


		let touch_bool = (status == 1 ? (false) : (true))
		this.awardItem.SetShowTips(touch_bool)

		let get_bool = (status == 2 ? (true) : (false))
		// this._img_mask.visible = get_bool
		this._img_received.visible = get_bool

		if (status == 1) {
			this._red.visible = true
		} else {
			this._red.visible = false

		}
	}

	public SetData(arg?, info?) {


		this.data = arg
		this.info = info
		if (this.data && this.info) {
			this.InitView()
		}
	}

	public DeleteMe() {


		if (this.awardItem) {
			this.awardItem.DeleteMe()
			this.awardItem = null
		}
		super.DeleteMe()
	}

	public GetComponents() {
		[
			this._gp_btn,
			this._gp_awarditem,
			this._img_mask,
			this._img_received,
			this._Image1,
			this._lb_dec,
			this._red,
		]
			= this.GetChildrenByNames([

				"_gp_btn",
				"_gp_awarditem",
				"_img_mask",
				"_img_received",
				"_Image1",
				"_lb_dec",
				"_red",
			])
	}
}
window["FtvActivenessPersonalItem"]=FtvActivenessPersonalItem
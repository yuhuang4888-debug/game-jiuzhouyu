import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItem1 } from "../common/BaseItem1"
import { Enum_UILayer } from "../common/LayerManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { WelfareModel, WelfareEvent } from "../commonModel/WelfareModel"
import { ErlangParser } from "../util/ErlangParser"
import { Util } from "../util/Util"

export class DailySignTotalItem extends BaseItem1 {
	click_group: Laya.Box
	_gp_effect: Laya.Box
	reward_group: Laya.Box
	mask_group: Laya.Box
	_Image1: Laya.Image
	_Image2: Laya.Image
	_Image3: Laya.Image
	day_label: Laya.Label
	_red: Laya.Image
	_dot: Laya.Image
	bg_1:Laya.Image
	bg_2:Laya.Image
	Empclick_group

	data
	item
	mask_id
	need_refresh

	public constructor(parent) {
		super(parent)


		this.base_file = "dailySign"
		this.layout_file = "DailySignTotalItem"
		this.layer_value = Enum_UILayer.UI

		//同个界面上有别的mask，这里设置0表示不用那个id，否则会默认使用1
		this.mask_id = 0

		this.load_callback = () => {

			// if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
			// 	this.day_label.size  = 18
			// }
			// this.ReplaceUIShader(this._red)
			// this.ReplaceUIShader(this._Image1)
			// this.ReplaceUIShader(this._Image2)
			this.LoadSuccess()
		}

	}

	public LoadSuccess() {



		this.item = new BaseAwardItem(this.reward_group)
		this.item.Load()
		this.item.SetItemSize(60,60)

		Util.AddClickEvent(this.click_group, () => {
			if (this.data.receive == 3) {
				WelfareModel.GetInstance().Fire(WelfareEvent.WELFARE_REQUEST_PROTO, 41705, "c", this.data.sum)
			}
		}, this, true)

		if (this.need_refresh) {
			this.RefreshView()
		}
	}

	public RefreshView() {

		if (this.data) {
			let mask_bool = this.data.receive == 1 && true || false
			this.mask_group.visible = mask_bool

			let touch_bool = (this.data.receive == 0 || this.data.receive == 1) && true || false
			this.item.SetShowTips(touch_bool)
			// if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
			// 	this.day_label.text = "Acc. " + this.data.sum + " Check-ins"
			// }else{
			this.day_label.text = "累签" + this.data.sum + "天"
			// }
			if (this.data.cfg) {
				let rewards = JSON.parse(this.data.cfg.rewards)
				if (rewards) {
					let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(rewards[0][0], rewards[0][1])
					let goods_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
					if (goods_vo) {
						let not_show_effect = (this.data.receive >= 1 && (false) || (true))
						this.item.SetData(goods_vo.type_id, rewards[0][2], lock, null, null, not_show_effect)
						this.item.ExcuteCallback(() => {
							// let curr_sorting_order = this.AddCurrLayerSortingOrder(this.layer_value)
							// this.CoverEffect(this._red, "UI", curr_sorting_order)
							// this.CoverEffect(this._dot, "UI", curr_sorting_order)
							// this.CoverEffect(this._Image1, "UI", curr_sorting_order)
							// this.CoverEffect(this._Image2, "UI", curr_sorting_order)
						})
					}
				}
				if (this.data.receive == 3) {
					//let cur_sorting_order = this.AddCurrLayerSortingOrder(this.layer_value)
					//let data = {
					//custom_sorting_order = cur_sorting_order,
					//load_call_back =() => {				
					//this:CoverEffect(this.reward_group,this.layer_value,cur_sorting_order)
					//}
					//}
					if(!this._gp_effect.getChildAt[0]){
						this.AddUIEffect("UI_2037_1",this._gp_effect, null, 5, true)
					}

					//红点
					// this._red.visible = true
					// this._dot.visible = true
					this.bg_2.visible=true
					this.bg_1.visible=false
					this.day_label.color="#a51c1c"
				} else {
					//红点
					// this._red.visible = false
					// this._dot.visible = false
					this.bg_1.visible=true
					this.bg_2.visible=false
					this.day_label.color="#663915"
					this.ClearUIEffect(this._gp_effect)
				}
			}
		}
	}

	public SetData(data?) {

		this.data = data
		if (this.is_loaded) {
			this.RefreshView()
		} else {
			this.need_refresh = true
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
			this.click_group,
			this._gp_effect,
			this.reward_group,
			this.mask_group,
			this._Image1,
			this._Image2,
			this._Image3,
			this.day_label,
			this._red,
			this._dot,
			this.bg_1,
			this.bg_2
		]
			= this.GetChildrenByNames([

				"click_group",
				"_gp_effect",
				"reward_group",
				"mask_group",
				"_Image1",
				"_Image2",
				"_Image3",
				"day_label",
				"_red",
				"_dot",
				"bg_1",
				"bg_2"
			])
	}
}
window["DailySignTotalItem"]=DailySignTotalItem
import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItem1 } from "../common/BaseItem1"
import { Enum_UILayer } from "../common/LayerManager"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { SYTweenFunc } from "../util/SYTweenFunc"
import { SYTweenLite } from "../util/SYTweenLite"
import { Util } from "../util/Util"

export class DailyFirstRewardItem extends BaseItem1 {
	_gp_btn: Laya.Box
	_gp_effect: Laya.Box
	_gp_awarditem: Laya.Box
	_img_mask: Laya.Image
	_img_received: Laya.Image
	_lb_day: Laya.Label
	_lb_dec: Laya.HTMLDivElement
	InitEvent
	InitView
	SetAction
	SetData
	SetReceived
	StartAction
	StopAction
	_awardItem
	cache_order
	is_delay_callback
	tween_id

	public constructor(parent?) {
		super(parent)


		let local_Number = Number
		this._awardItem = null
		let _data = null
		let _base_type = null
		let _sub_type = null
		this.base_file = "dailyRecharge"
		this.layout_file = "DailyFirstRewardItem"
		this.is_delay_callback = false
		this.layer_value = Enum_UILayer.Activity
		let cur_sorting_order = null
		this.load_callback = () => {
			//cur_sorting_order = this.AddCurrLayerSortingOrder(this.layer_value)

			this.InitView()
			this.InitEvent()
		}

		this.InitEvent = () => {
			let onReceived = () => {
				if (local_Number(_data.val) >= local_Number(_data.max) && _data.state == 1) {
					CustomActivityModel.GetInstance().RequireGetAward(_base_type, _sub_type, _data.id)
				}
			}

			Util.AddClickEvent(this._gp_btn, onReceived, this, true)
		}

		this.InitView = () => {
			this._awardItem = new BaseAwardItem(this._gp_awarditem, null, this.layer_value)
			this._awardItem.Load()
			//this._awardItem.SetCacheSortOrder(cur_sorting_order+1)
			this._awardItem.SetItemSize(68, 68)
			this._awardItem.SetShowEffect(true)
		}

		this.SetData = (base_type?, sub_type?, data?) => {
			_base_type = base_type
			_sub_type = sub_type
			_data = data
			// if (PlatformMgr.GetInstance().IsEyouIdnPlatform() ) {
			// 	this._lb_day.text = data.max + " Hari"
			// }else{
			this._lb_day.text = "累计" + data.max + "天"
			//}

			// [ts2lua]lua中0和空字符串也是true，此处local_Number(data.val) >= local_Number(data.max)需要确认
			let color = (local_Number(data.val) >= local_Number(data.max) ? ("#b3ff48") : ("#ffffff"))
			// this._lb_dec.style.fontSize = 22
			// //this._lb_refresh_time.style.valign = "center"
			// this._lb_dec.style.color = "#ffffff"
			// this._lb_dec.width = 300
			// this._lb_dec.innerHTML = Util.StrToHTML("(<font color='" + color + "'>" + data.val + "/" + data.max + "</font>)")
			this._lb_dec.visible = false
			this.SetAction(local_Number(data.val), local_Number(data.max))
			// [ts2lua]lua中0和空字符串也是true，此处_data.state == 2需要确认
			this.SetReceived((_data.state == 2 ? (true) : (false)))
			if (data && data.reward_list && data.reward_list[0]) {
				let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(data.reward_list[0].style, data.reward_list[0].typeId)
				this._awardItem.ExcuteCallback(() => {
					this._awardItem.SetData(type_id, data.reward_list[0].count, lock, null, null, false, null, null, null, null, null, () => {
						//let cur_sorting_order = this.AddCurrLayerSortingOrder(this.layer_value)
						//if (! this.cache_order ) {
						//this.cache_order = cur_sorting_order
						//}
						//this:CoverEffect(this._img_mask,this.layer_value,this.cache_order)
						//this:CoverEffect(this._img_received,this.layer_value,this.cache_order)
					})

				}
				)
			}
		}

		this.SetReceived = (bool?) => {
			//this._img_mask.visible = bool
			this._img_received.visible = bool
		}

		this.SetAction = (val?, max?) => {
			this.ClearUIEffect(this._gp_effect)
			if (local_Number(val) >= local_Number(max) && _data.state == 1) {
				this._awardItem.SetShowTips(false)
				let data = {
					// custom_sorting_order = cur_sorting_order,
					// load_call_back =() => {
					// 	this.CoverEffect(this._gp_awarditem, this.layer_value, cur_sorting_order + 1)
					// 	this.CoverEffect(this._img_mask, this.layer_value, cur_sorting_order + 1)
					// 	this.CoverEffect(this._img_received, this.layer_value, cur_sorting_order + 1)
					// }
				}
				this._gp_effect.width = 720
				this._gp_effect.height = 1280
				this.AddUIEffect("UI_2004_1", this._gp_effect)
			} else {
				this._awardItem.SetShowTips(true)
				this.ClearUIEffect(this._gp_effect)
			}
		}  

		this.StartAction = () => {
			this.tween_id = SYTweenLite.to(this, this._gp_awarditem, SYTweenLite.UiAnimationType.ROTATION, 20, 0.3, null, SYTweenFunc.EASE_OUT_IN, true)
			//local_laya.Tween.get(this._gp_awarditem, {loop=true}):to({rotation=20}, 100, local_laya.Ease.circIn):to({rotation=-20}, 200, local_laya.Ease.circOut):to({rotation=0}, 50, local_laya.Ease.circIn):to({rotation=20}, 100, local_laya.Ease.circIn):to({rotation=-20}, 200, local_laya.Ease.circOut):to({rotation=0}, 75, local_laya.Ease.circIn).to({}, 2000)
		}

		this.StopAction = () => {
			if (this.tween_id) {
				SYTweenLite.Stop(this.tween_id)
				this.tween_id = null
				//local_laya.Tween.removeTweens(this._gp_awarditem)
				if (this._gp_awarditem) {
					//this._gp_awarditem.rotation = 0
					//SetRotate(this._gp_awarditem, 0, 0, 0)
				}

			}
		}
	}

	public DeleteMe() {

		if (this._awardItem) {
			this._awardItem.DeleteMe()
			this._awardItem = null
		}
		this.StopAction()
		if(this._gp_effect){
			this.ClearUIEffect(this._gp_effect)
		}
		super.DeleteMe()
	}



	public GetComponents() {
		[
			this._gp_btn,
			this._gp_effect,
			this._gp_awarditem,
			this._img_mask,
			this._img_received,
			this._lb_day,
			this._lb_dec,
		]
			= this.GetChildrenByNames([

				"_gp_btn",
				"_gp_effect",
				"_gp_awarditem",
				"_img_mask",
				"_img_received",
				"_lb_day",
				"_lb_dec",
			])
	}
}
window["DailyFirstRewardItem"] = DailyFirstRewardItem
import { BaseItem1 } from "../common/BaseItem1"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { LimitLevelShopModel } from "../commonModel/LimitLevelShopModel"
import { Message } from "../sysInfo/SysInfoController"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"

export class LimitLevelShopTabItem extends BaseItem1 {
	_Image1: Laya.Image
	_img_select: Laya.Image
	_gp_behind_effect: Laya.Box
	_img_show: Laya.Image
	_gp_front_effect: Laya.Box
	_img_name: Laya.Image
	_img_click:Laya.Image
	_img_only_buy_once:Laya.Image
	call_back
	curr_sorting_order
	index
	model
	need_refresh_data
	need_refresh_select
	select_state
	vo
	pos
	local_resManager
	type
	subtype
	buy_state
	public constructor(parent?) {
		super(parent)

		this.vo = null
		this.index = null
		this.call_back = null
		this.need_refresh_data = null
		this.need_refresh_select = null
		this.select_state = false

		this.base_file = "limitLevelShop"
		this.layout_file = "LimitLevelShopTabItem"
		this.layer_value = Enum_UILayer.Activity
		this.model = LimitLevelShopModel.GetInstance()
		this.local_resManager = ResManager.GetInstance()
		this.load_callback = () => {

			this.LoadSuccess()
		}


	}

	public LoadSuccess() {
		if(this.pos){
			this.display_obj.x=this.pos[0]
			this.display_obj.y=this.pos[1]
		}
		// this.curr_sorting_order = this.AddCurrLayerSortingOrder(this.layer_value)
		// this.AddUIEffect("UI_1201", this.layer_value, this._gp_behind_effect, null, 5, true,)
		// this.CoverEffect(this._img_show, "Activity", this.curr_sorting_order)
		//this:AddUIEffect2("ui_purchase_arrary_front", this._gp_front_effect, null, null, true)
		this.local_resManager.SetOutsideImageSprite(this, this._img_only_buy_once,GameResPath.GetIconOtherPath("limitLevelShop","ui_only_buy_once"),false)
		this._img_only_buy_once.visible = false
		this.InitEvent()
	}

	public InitEvent() {


		Util.AddClickEvent(this._img_click, () => {
			if (this.call_back) {
				if(this.SetOnlyBuyOnceFlag()){
					if(this.GetOldGiftState(this.index) == 1){
						Message.show("抢购限时返场!只能购买之前未购买的礼包~")
						return
					}
				}
				this.call_back(this.index)
			}
		}, this, false)

		if (this.need_refresh_data) {
			this.UpdateView()
			this.need_refresh_data = false
		}

		if (this.need_refresh_select) {
			this.UpdateSelect()
			this.need_refresh_select = false
		}
	}

	public SetData(type?, subtype?, buy_state?, vo?, index?, call_back?,pos?) {
 		this.type = type
		this.subtype = subtype
		this.buy_state = buy_state
		this.vo = vo
		this.index = index
		this.call_back = call_back
		this.pos=pos
		if (this.is_loaded) {
			this.UpdateView()
			this.display_obj.x=this.pos[0]
			this.display_obj.y=this.pos[1]
			
		} else {
			this.need_refresh_data = true
		}
	}

	public UpdateView() {
		let cfg = this.vo
		if (cfg && cfg.show) {
			let value = this.model.GetValueByErlang(cfg.show, "tab_show")
			if (value) {
				ResManager.GetInstance().SetOutsideImageSprite(this, this._img_name, GameResPath.GetIconOtherPath("limitLevelShop", value[1]), true)
				ResManager.GetInstance().SetOutsideImageSprite(this, this._img_show,GameResPath.GetIconOtherPath( "limitLevelShop", value[2]),  true)
			}
		}
		if(this.SetOnlyBuyOnceFlag()){
			this._img_only_buy_once.visible = this.GetOldGiftState(this.index) == 1 ? true : false
		}
	}

	public SetOnlyBuyOnceFlag() {
		let open_times = this.model.GetGiftOpenTimes(this.type, this.subtype)
		return open_times >= 2 ? true : false
	}

	public GetOldGiftState(index) {
		let old_list = this.model.GetOldGiftBuyState(this.type, this.subtype)
		let vo = old_list[index]
		return vo.state
	}

	public SetSelect(bool?) {

		this.select_state = bool
		if (this.is_loaded) {
			this.UpdateSelect()
		} else {
			this.need_refresh_select = true
		}
	}

	public UpdateSelect() {

		this._img_select.visible = this.select_state
	}


	public GetComponents() {
		[
			this._Image1,
			this._img_select,
			this._gp_behind_effect,
			this._img_show,
			this._gp_front_effect,
			this._img_name,
			this._img_click,
			this._img_only_buy_once
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_img_select",
				"_gp_behind_effect",
				"_img_show",
				"_gp_front_effect",
				"_img_name",
				"_img_click",
				"_img_only_buy_once"
			])
	}
}
window["LimitLevelShopTabItem"]=LimitLevelShopTabItem
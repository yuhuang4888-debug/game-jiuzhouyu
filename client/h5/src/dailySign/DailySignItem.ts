import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { Enum_UILayer } from "../common/LayerManager"
import { OpenFun } from "../common/OpenFun"
import { ResManager } from "../common/ResManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { VipModel } from "../commonModel/VipModel"
import { WelfareModel, WelfareEvent } from "../commonModel/WelfareModel"
import { ColorUtil, Enum_ColorUtil_Light } from "../util/ColorUtil"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { Util, Color } from "../util/Util"
import { DailyTipsView } from "./DailyTipsView"

export class DailySignItem extends BaseItemRenderer {

	click_group: Laya.Box
	_Image1: Laya.Image
	_red: Laya.Image
	_gp_effect: Laya.Box
	item_group: Laya.Box
	day_label: Laya.Label
	img_mask: Laya.Image
	patch_group: Laya.Box
	_Image2: Laya.Image
	_Image3: Laya.Image
	tick_img: Laya.Image
	tips_bg: Laya.Image
	vip_img: Laya.Image
	nulti_img: Laya.Image
	_lb_vip: Laya.Label
	sign_group: Laya.Box
	top_img :Laya.Image
	Empclick_group
	Outday_label
	cache_curr_sorting_order
	item
	model
	next_curr_sorting_order
	reward_info
	vip_info

	public static width = 132
	public static height = 130

	public constructor(parent) {
		super()
		this.WIDTH=140
		this.HEIGT=130
		this.model = WelfareModel.GetInstance()
		this.base_file = "dailySign"
		this.layout_file = "DailySignItem"
		// this.layer_value = Enum_UILayer.UI
		// this.load_callback = () => {

		// this.LoadSuccess()

		// this.ReplaceUIShader(this.tips_bg)
		// this.ReplaceUIShader(this.patch_group)
		//this:ReplaceUIShader(this.vip_img)
		//this:ReplaceUIShader(this.nulti_img)
		//this:ReplaceUIShader(this._red)
		// this.ReplaceUIShader(this._mask)
		// this.ReplaceUIShader(this.tick_img)
		// }
		this.Load()
	}

	public load_callback() {

		this.item = new BaseAwardItem(this.item_group)
		this.item.SetUseMask(true)
		this.item.SetItemSize(80,80)
		// this.cache_curr_sorting_order = this.AddCurrLayerSortingOrder(this.layer_value)
		this.item.SetCacheSortOrder(this.cache_curr_sorting_order)
		// this.next_curr_sorting_order = this.AddCurrLayerSortingOrder(this.layer_value)
		// this.CoverEffect(this.tips_bg, "UI", this.next_curr_sorting_order)
		// this.CoverEffect(this.patch_group, "UI", this.next_curr_sorting_order)
		//this:CoverEffect(this.vip_img, "UI", this.next_curr_sorting_order)
		//this:CoverEffect(this.nulti_img, "UI", this.next_curr_sorting_order)
		//this:CoverEffect(this._red, "UI", this.next_curr_sorting_order)
		// this.CoverEffect(this.img_mask, "UI", this.next_curr_sorting_order)
		// this.CoverEffect(this.tick_img, "UI", this.next_curr_sorting_order)
		ResManager.GetInstance().SetTexture(this,this.top_img,GameResPath.GetIcon("dailySign","uiqd_012"))
		this.item.Load()


		Util.AddClickEvent(this.click_group, () => {
			if(!this.data) return
			let vip_ = 0
			if (this.vip_info && this.vip_info.length > 0 && Number(this.vip_info[0][1]) > 0) {
				vip_ = Number(this.vip_info[0][1])
			}
			this.model.now_click_to_check_day = this.data.check_day
			if (this.data.receive == 2) {
				WelfareModel.GetInstance().Fire(WelfareEvent.RETROACTIVE, this.data.check_day, vip_, this.reward_info)
			} else if (this.data.receive == 3 || this.data.receive == 4) {
				let request_fun = () => {
					WelfareModel.GetInstance().Fire(WelfareEvent.WELFARE_REQUEST_PROTO, 41704, "cc", this.data.check_day, 0)
				}
				if (vip_ > 0) {
					let my_vip = VipModel.GetInstance().GetVipLevel()
					if (my_vip < vip_) {
						let str = "提升至<font color='#639C12'>VIP" + vip_ + "</font>，本次签到可领取<font color='#639C12'>2</font>倍奖励"
						let ok_fun = () => {
							OpenFun.OpenFunHandler(23)
						}
						let tips_view = new DailyTipsView(2, str, null, ok_fun, request_fun, this.reward_info)
						tips_view.Open()
						//Alert.Show(str, Alert_Type.Two, ok_fun, request_fun, "提升VIP", "坚持领奖")
					} else {
						request_fun()
					}
				} else {
					request_fun()
				}
			} else {
				this.item.DefaultCallFun()
			}
		}, this, true)
	}

	public dataChanged() {
		if(!super.dataChanged()) return
		if (this.data) {
		if (this.data.check_day) {
				// if (PlatformMgr.GetInstance().IsEyouEnPlatform()) {
				// 	this.day_label.text = "Day " + this.data.check_day
				// } else if (PlatformMgr.GetInstance().IsEyouThPlatform()) {
				// 	this.day_label.text = "วันที่" + this.data.check_day
				// } else if (PlatformMgr.GetInstance().IsEyouIdnPlatform()) {
				// 	this.day_label.text = "Hari " + this.data.check_day
				// } else {
				this.day_label.text = "第" + this.data.check_day + "天"
				// }
			}
			let mask_bool = (this.data.receive == 1 || this.data.receive == 5) && true || false
			this.img_mask.visible = mask_bool

			let patch_bool = this.data.receive == 2 && true || false
			this.patch_group.visible = patch_bool

			let sign_bool=this.data.receive==3 && true ||false
			this.sign_group.visible=sign_bool

			let tick_bool = (this.data.receive == 1 || this.data.receive == 5) && true || false
			this.tick_img.visible = tick_bool

			let touch_bool = (this.data.receive == 1 || this.data.receive == 5 || this.data.receive == 0) && true || false
			this.item.SetShowTips(touch_bool)

			if (this.data.cfg) {
				this.reward_info = JSON.parse(this.data.cfg.rewards)
				let rewards = this.reward_info
				if (rewards) {
					let [type_id, lock ]= GoodsModel.GetInstance().GetMappingTypeId(rewards[0][0], rewards[0][1])
					let goods_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
					if (goods_vo) {
						this.item.SetData(goods_vo.type_id, rewards[0][2], lock)
					}
				}
				this.vip_info = JSON.parse(this.data.cfg.vip_lv)
				let vip_cfg = this.vip_info
				if (vip_cfg && vip_cfg.length > 0 && Number(vip_cfg[0][1]) > 0) {
					this.tips_bg.visible = true
					this._lb_vip.visible=true
					this._lb_vip.text="V"+vip_cfg[0][1]+"\n双倍"
					// ResManager.GetInstance().SetImageSprite(this, this.tips_bg, "dailySign_asset", "v" + vip_cfg[0][1], true)

					//this.vip_img.visible = true 
					//lua_resM:SetImageSprite(this,this.vip_img,"dailySign_asset","v" + vip_cfg[1][2],true)				
					//this.nulti_img.visible = true 
					//lua_resM:SetImageSprite(this,this.nulti_img,"dailySign_asset","mul" + this.data.cfg.vip_multiple,true)
				} else {
					this.tips_bg.visible = false
					this._lb_vip.visible=false
					//this.vip_img.visible = false 
					//this.nulti_img.visible = false 
				}

				if (this.data.receive == 3 || this.data.receive == 4) {
					//红点
					this._red.visible = true
					// this.day_label.color = Enum_ColorUtil_Light.WHITE
					// this.Outday_label.effectColor = Color(210 / 255, 121 / 255, 16 / 255, 1)

					//剧情
					//if ((! this.model.show_story_arrow_day || this.model.show_story_arrow_day == this.data.check_day) 
					//and this.task_model.IsCurrMainLineTaskTipType(TaskTipType.Award_daily) ) {
					//if (! this.task_model.IsCurrMainTaskHasFinish() ) {
					//let step_cfg = this.task_model.GetNowGuideCfg(false)
					//GlobalEventSystem:Fire(EventName.SHOW_FINGER, this, this.click_group, "UI", null, null, true, null, step_cfg)
					//if (this.parent ) {
					//this.parent.setChildIndex(this, 999)
					//}
					//this.model.show_story_arrow_day = this.data.check_day
					//}else{
					//GlobalEventSystem:Fire(EventName.HIDE_FINGER, this, this.click_group)
					//}
					//}
				} else {
					//红点
					this._red.visible = false
					// this.day_label.color = Color(133 / 255, 92 / 255, 67 / 255, 1)
					// this.Outday_label.effectColor = Color(210 / 255, 121 / 255, 16 / 255, 0)

					//剧情
					//if ((this.model.show_story_arrow_day && this.model.show_story_arrow_day == this.data.check_day) 
					//and this.task_model.IsCurrMainLineTaskTipType(TaskTipType.Award_daily) 
					//and this.task_model.IsCurrMainTaskHasFinish() ) {
					//if (this.task_model.IsCurrMainTaskHasFinish() ) {
					//GlobalEventSystem:Fire(EventName.HIDE_FINGER, this, this.click_group)
					//}
					//}
				}
			}
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
			this._Image1,
			this._red,
			this._gp_effect,
			this.item_group,
			this.day_label,
			this.img_mask,
			this.patch_group,
			this._Image2,
			this._Image3,
			this.tick_img,
			this.tips_bg,
			this.vip_img,
			this.nulti_img,
			this._lb_vip,
			this.sign_group,
			this.top_img
		]
			= this.GetChildrenByNames([

				"click_group",
				"_Image1",
				"_red",
				"_gp_effect",
				"item_group",
				"day_label",
				"img_mask",
				"patch_group",
				"_Image2",
				"_Image3",
				"tick_img",
				"tips_bg",
				"vip_img",
				"nulti_img",
				"_lb_vip",
				"sign_group",
				"top_img"
			])
	}
}
window["DailySignItem"]=DailySignItem
import { Alert, Alert_Type } from "../alert/Alert"
import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItem1 } from "../common/BaseItem1"
import { EventName } from "../common/EventName"
import { InstructionType } from "../common/InstructionType"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { GoodsModel } from "../commonModel/GoodsModel"
import { TopVipModel, TopVipEvent } from "../commonModel/TopVipModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { SetAnchoredPositionX, Util, SetSizeDeltaY, GlobalTimerQuest } from "../util/Util"

export class TopVipMainView extends BaseItem1 {
	_Group8: Laya.Box
	_Group1: Laya.Box
	_Image1: Laya.Image
	_Image2: Laya.Image
	_Label1: Laya.Label
	_Label2: Laya.Label
	_Group2: Laya.Box
	_Image3: Laya.Image
	_Image4: Laya.Image
	_Label3: Laya.Label
	_Label4: Laya.Label
	_Group3: Laya.Box
	_Image5: Laya.Image
	_Image6: Laya.Image
	_Label5: Laya.Label
	_Label6: Laya.Label
	_Group4: Laya.Box
	_Image7: Laya.Image
	_Image8: Laya.Image
	_Label7: Laya.Label
	_Label8: Laya.Label
	_Group5: Laya.Box
	_Image9: Laya.Image
	_Image10: Laya.Image
	_Label9: Laya.Label
	_Label10: Laya.Label
	_Group6: Laya.Box
	_Image11: Laya.Image
	_Image12: Laya.Image
	_Label11: Laya.Label
	_Label12: Laya.Label
	_Group7: Laya.Box
	_Image13: Laya.Image
	_Image14: Laya.Image
	_Label13: Laya.Label
	_Label14: Laya.Label
	_Group9: Laya.Box
	vip_stage_bg_img: Laya.Image
	top_img: Laya.Image
	vip_gp: Laya.Box
	_Image15: Laya.Image
	vip_lv_img: Laya.Image
	vip_state_img: Laya.Image
	update_vip_gp: Laya.Box
	_Image16: Laya.Image
	_Label15: Laya.Label
	vip_time_gp: Laya.Box
	out_time_lb: Laya.Label
	day_gp: Laya.Box
	_Label16: Laya.Label
	day_num_lb: Laya.Label
	every_day_gp: Laya.Box
	_Image17: Laya.Image
	_Image18: Laya.Image
	_Image19: Laya.Image
	_Image20: Laya.Image
	_Image21: Laya.Image
	item_gp: Laya.HBox
	_receive_gp: Laya.Box
	_Image22: Laya.Image
	receive_lb: Laya.Label
	receive_red_img: Laya.Image
	exp_gp: Laya.Box
	_Image23: Laya.Image
	_Label17: Laya.Label
	experience_gp: Laya.Box
	_Image24: Laya.Image
	_Label18: Laya.Label
	_Image25: Laya.Image
	_Label19: Laya.Label
	exp_pay_lb: Laya.Label
	_Label20: Laya.Label
	_Image26: Laya.Image
	detail_img: Laya.Image
	_img_is_get:Laya.Image
	CancelTime
	ChangeVipStage
	InitEvent
	InitView
	LoadSuccess
	LocalDeleteMe
	StarTimer
	TimeOver
	UpdateTimer
	UpdateView
	public constructor(parent?) {
		super(parent)


		this.base_file = "topVip"
		this.layout_file = "TopVipMainView"
		let model = TopVipModel.GetInstance()

		let local_Erlang = ErlangParser.GetInstance()
		let goods_model = GoodsModel.GetInstance()
		let local_TopVipEvent = TopVipEvent
		let local_Math = Math
		let timer_ = null
		let out_time_ = null
		let item_list_ = null
		let vip_type_ = null
		let right_type_ = 0
		let data_str_ = null
		this.preload_server_config={
			"config_supreme_vip":false,
			"config_supreme_vip_key_value":false
		}
		this.load_callback = () => {

			this.LoadSuccess()
			this.InitEvent()

			// if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
			// 	this._Label1.size  = 20
			// 	this._Label2.size  = 16
			// 	this._Label3.size  = 20
			// 	this._Label4.size  = 16
			// 	this._Label5.size  = 20
			// 	this._Label6.size  = 16
			// 	this._Label7.size  = 20
			// 	this._Label8.size  = 16
			// 	this._Label9.size  = 20
			// 	this._Label10.size  = 16
			// 	this._Label11.size  = 20
			// 	this._Label12.size  = 16
			// 	this._Label13.size  = 20
			// 	this._Label14.size  = 16

			// 	this._Label17.size  = 18

			// 	this._Label19.size  = 18
			// 	this._Label20.size  = 18
			// 	SetAnchoredPositionX(this._Label19,-60)
			// 	SetAnchoredPositionX(this.exp_pay_lb,-21)
			// 	SetAnchoredPositionX(this._Label20,51)
			// }
			// if (PlatformMgr.GetInstance().IsEyouIdnPlatform() ) {
			// 	this._Label1.size  = 20
			// 	this._Label2.size  = 16
			// 	this._Label3.size  = 20
			// 	this._Label4.size  = 16
			// 	this._Label5.size  = 20
			// 	this._Label6.size  = 16
			// 	this._Label7.size  = 20
			// 	this._Label8.size  = 16
			// 	this._Label9.size  = 20
			// 	this._Label10.size  = 16
			// 	this._Label11.size  = 20
			// 	this._Label12.size  = 16
			// 	this._Label13.size  = 20
			// 	this._Label14.size  = 16

			// 	this._Label17.size  = 18

			// 	this._Label19.size  = 18
			// 	this._Label20.size  = 18
			// 	SetAnchoredPositionX(this._Label19,-60)
			// 	SetAnchoredPositionX(this.exp_pay_lb,16)
			// 	SetAnchoredPositionX(this._Label20,82)
			// 	SetAnchoredPositionX(this._Label16,-121.43)
			// 	this._Label15.size  = 18
			// }
		}

		this.LocalDeleteMe = () => {
			if (item_list_ && item_list_.length > 0) {
				for (let _tmpi in item_list_) {
					var obj = item_list_[_tmpi]
					obj.DeleteMe()
				}
				item_list_ = null
			}
			this.CancelTime()
		}

		this.LoadSuccess = () => {
			// ResManager.GetInstance().SetTexture(this, this.vip_stage_bg_img, GameResPath.GetIcon("topvip_asset", "uizz_010"))
			ResManager.GetInstance().SetOutsideImageSprite(this, this._Image20, GameResPath.GetIcon("topVip", "uizz_026"), true)
			// ResManager.GetInstance().SetOutsideImageSprite(this, this._Image21, GameResPath.GetIcon("topVip", "uizz_026"), true)
			ResManager.GetInstance().SetOutsideImageSprite(this, this._Image26, GameResPath.GetIcon("topVip", "uizz_025"), true)
			ResManager.GetInstance().SetImageSpriteTrans(this, this._Image24, GameResPath.GetIcon("topVip", "ui_9"), true)
			// ResManager.GetInstance().SetOutsideImageSprite(this, this._Image15, GameResPath.GetIcon("topVip", "uizz_029"), true)
			ResManager.GetInstance().SetTexture(this,this.top_img,GameResPath.GetIcon("topVip","uizz_010"))
			let n = model.GetSupremeVip()
			this.InitView()
		}

		this.InitView = () => {
			let config_supreme_vip = ResManager.GetInstance().GetGameConfigFromCache(this, "config_supreme_vip", false)
			let config_supreme_vip_key_value = ResManager.GetInstance().GetGameConfigFromCache(this, "config_supreme_vip_key_value", false)
			let reward = null
			let list = null
			let exp_pay = null
			for (let key in config_supreme_vip) {

				if (key == "2@8") {
					// [ts2lua]config_supreme_vip下标访问可能不正确
					reward = config_supreme_vip[key]
					list = JSON.parse(reward.args)
					break
				}
			}
			for (let key in config_supreme_vip_key_value) {

				if (key == "1") {
					let cfg = null
					// [ts2lua]config_supreme_vip_key_value下标访问可能不正确
					cfg = config_supreme_vip_key_value[key]
					exp_pay =JSON.parse(cfg.value)
					for (let _tmpi in exp_pay) {
						var pay = exp_pay[_tmpi]
						this.exp_pay_lb.text = String(pay[2])
					}
					break
				}
			}
			if (!item_list_) {
				item_list_ = []
			}
			let index = 1
			for (let _tmpi in list) {
				var vo = list[_tmpi]
				// [ts2lua]item_list_下标访问可能不正确
				let item = item_list_[index]
				if (!item) {
					item = new BaseAwardItem(this.item_gp)
					item.Load()
					table.insert(item_list_, item)
					item.SetItemSize(87,87)
				}
				let [type_id, lock] = goods_model.GetMappingTypeId(vo[0], vo[1])
				let goods_vo = goods_model.GetGoodsBasicByTypeId(type_id)
				if (goods_vo) {
					item.SetData(goods_vo.type_id, vo[2], lock)
				}
				index = index + 1
			}
		}

		this.InitEvent = () => {
			this.BindEvent(model, local_TopVipEvent.UPDATE_TOP_VIP_MAIN_VIEW, () => {
				this.UpdateView()
			}
			)
			this.BindEvent(model, local_TopVipEvent.CHANGE_RECEIVE_LABLE, () => {
				this.receive_lb.text = "已领取"
				this._receive_gp.visible=false
				this._img_is_get.visible=true
			}
			)
			Util.AddClickEvent(this.update_vip_gp, () => {
				model.Fire(local_TopVipEvent.OPEN_TOP_VIP_View, "TopVipActivityPromotionView")
			}
				, this, true)
			Util.AddClickEvent(this.detail_img, () => {
				GlobalEventSystem.Fire(EventName.OPEN_INSTRUCTION_VIEW, InstructionType.SUPREME_VIP)
			}
				, this, true)
			Util.AddClickEvent(this.exp_gp, () => {
				let str = "是否消耗<font color='#639c12'>199勾玉</font>体验3天至尊VIP特权？"
				Alert.Show(str, Alert_Type.Two, () => {
					model.Fire(local_TopVipEvent.TOP_VIP_REQUEST_PROTO, 45106)
				}
				)
			}
				, this, true)
			Util.AddClickEvent(this._receive_gp, () => {
				if (right_type_) {
					model.Fire(local_TopVipEvent.TOP_VIP_REQUEST_PROTO, 45108, "c", right_type_)
				}
			}
				, this, true)
			model.Fire(local_TopVipEvent.TOP_VIP_REQUEST_PROTO, 45101)
		}

		this.UpdateView = () => {
			let vo = model.GetMyTopVipVo()
			let is_show = model.GetDayRewardRed()
			if (is_show) {
				this.receive_red_img.visible = true
			} else {
				this.receive_red_img.visible = false
			}
			for (let _tmpi in vo.right_list) {
				var v = vo.right_list[_tmpi]
				right_type_ = v.right_type
				data_str_ = ErlangParser.GetInstance().Parse(v.data_str)[0]
			}
			vip_type_ = vo.supvip_type
			out_time_ = vo.supvip_time - TimeUtil.getServerTime()
			if (data_str_ == "2") {
				this.receive_lb.text = "已领取"
				Util.SetImageGray(this._Image22, true)
				this._receive_gp.visible=false
				this._img_is_get.visible=true
				vip_type_=3
				// SetTextGray(this.receive_lb, true)
			} else if (data_str_ == "1") {
				this._img_is_get.visible=false
				this._receive_gp.visible=true
				this.receive_lb.text = "领取"
			}
			this.ChangeVipStage(vip_type_, out_time_)
			if (out_time_ <= 0) {
				return
			}
			let second = out_time_
			let D = local_Math.floor(second / 60 / 60 / 24)
			let h = local_Math.floor(second / 60 / 60) % 24
			if (h >= 1) {
				this.UpdateTimer()
			} else if (h < 1) {
				this.UpdateTimer()
				this.StarTimer(1)
			} else {
				this.UpdateTimer()
			}
		}

		this.ChangeVipStage = (vip_type?, out_time?) => {
			if (vip_type == 0) {
				this.experience_gp.visible = true
				this.every_day_gp.visible = false
				this.vip_gp.visible = false
				this.exp_gp.visible = true
				this._receive_gp.visible = false
				// SetSizeDeltaY(this.top_img, 49)
			} else {
				// SetSizeDeltaY(this.top_img, 106)
				this.experience_gp.visible = false
				this.every_day_gp.visible = true
				this.vip_gp.visible = true
				this.exp_gp.visible = false
				this._receive_gp.visible = true
				if (vip_type == 1) {
					this.update_vip_gp.visible = true
					this._receive_gp.visible= !this.update_vip_gp.visible
					this.vip_time_gp.visible = true
					if (out_time > 0) {
						ResManager.GetInstance().SetImageSprite(this, this.vip_lv_img, "topVip_asset", "uizz_034", true)
						this.out_time_lb.visible = false
						this.day_gp.visible = true
					} else {
						ResManager.GetInstance().SetImageSprite(this, this.vip_lv_img, "topVip_asset", "uizz_033", true)
						this.out_time_lb.visible = true
						this.day_gp.visible = false
					}
				} else if (vip_type ==2) {
					this.update_vip_gp.visible = false
					this.vip_time_gp.visible = false
					ResManager.GetInstance().SetImageSprite(this, this.vip_lv_img, "topVip_asset", "uizz_032", true)
				}else {
					this.update_vip_gp.visible = false
					this.vip_time_gp.visible = false
					this._receive_gp.visible=false
					this._img_is_get.visible=true
				}
			}
		}

		this.StarTimer = (countdoentime?) => {
			this.CancelTime()
			timer_ = GlobalTimerQuest.AddPeriodQuest(this.UpdateTimer, countdoentime)
		}

		this.CancelTime = () => {
			if (timer_) {
				GlobalTimerQuest.CancelQuest(timer_)
			}
		}

		this.UpdateTimer = () => {
			out_time_ = out_time_ - 1
			if (out_time_ <= 0) {
				this.TimeOver()
				return
			}
			let D = local_Math.floor(out_time_ / 60 / 60 / 24)
			let h = local_Math.floor(out_time_ / 60 / 60) % 24
			let m = local_Math.floor(out_time_ / 60) % 60
			let s = out_time_ % 60
			if (D >= 1) {
				this.day_num_lb.text = D + "天" + h + "时"
			} else if (h >= 1) {
				this.day_num_lb.text = h + "小时" + m + "分"
			} else {
				this.day_num_lb.text = m + "分" + s + "秒"
			}
		}

		this.TimeOver = () => {
			this.CancelTime()
			model.Fire(local_TopVipEvent.TOP_VIP_REQUEST_PROTO, 45101)
		}


	}


	public DeleteMe() {
		this.LocalDeleteMe()
		super.DeleteMe()
	}

	public GetComponents() {
		[
			this._Group8,
			this._Group1,
			this._Image1,
			this._Image2,
			this._Label1,
			this._Label2,
			this._Group2,
			this._Image3,
			this._Image4,
			this._Label3,
			this._Label4,
			this._Group3,
			this._Image5,
			this._Image6,
			this._Label5,
			this._Label6,
			this._Group4,
			this._Image7,
			this._Image8,
			this._Label7,
			this._Label8,
			this._Group5,
			this._Image9,
			this._Image10,
			this._Label9,
			this._Label10,
			this._Group6,
			this._Image11,
			this._Image12,
			this._Label11,
			this._Label12,
			this._Group7,
			this._Image13,
			this._Image14,
			this._Label13,
			this._Label14,
			this._Group9,
			this.vip_stage_bg_img,
			this.top_img,
			this.vip_gp,
			this._Image15,
			this.vip_lv_img,
			this.vip_state_img,
			this.update_vip_gp,
			this._Image16,
			this._Label15,
			this.vip_time_gp,
			this.out_time_lb,
			this.day_gp,
			this._Label16,
			this.day_num_lb,
			this.every_day_gp,
			this._Image17,
			this._Image18,
			this._Image19,
			this._Image20,
			this._Image21,
			this.item_gp,
			this._receive_gp,
			this._Image22,
			this.receive_lb,
			this.receive_red_img,
			this.exp_gp,
			this._Image23,
			this._Label17,
			this.experience_gp,
			this._Image24,
			this._Label18,
			this._Image25,
			this._Label19,
			this.exp_pay_lb,
			this._Label20,
			this._Image26,
			this.detail_img,
			this._img_is_get
		]
			= this.GetChildrenByNames([

				"_Group8",
				"_Group1",
				"_Image1",
				"_Image2",
				"_Label1",
				"_Label2",
				"_Group2",
				"_Image3",
				"_Image4",
				"_Label3",
				"_Label4",
				"_Group3",
				"_Image5",
				"_Image6",
				"_Label5",
				"_Label6",
				"_Group4",
				"_Image7",
				"_Image8",
				"_Label7",
				"_Label8",
				"_Group5",
				"_Image9",
				"_Image10",
				"_Label9",
				"_Label10",
				"_Group6",
				"_Image11",
				"_Image12",
				"_Label11",
				"_Label12",
				"_Group7",
				"_Image13",
				"_Image14",
				"_Label13",
				"_Label14",
				"_Group9",
				"vip_stage_bg_img",
				"top_img",
				"vip_gp",
				"_Image15",
				"vip_lv_img",
				"vip_state_img",
				"update_vip_gp",
				"_Image16",
				"_Label15",
				"vip_time_gp",
				"out_time_lb",
				"day_gp",
				"_Label16",
				"day_num_lb",
				"every_day_gp",
				"_Image17",
				"_Image18",
				"_Image19",
				"_Image20",
				"_Image21",
				"item_gp",
				"_receive_gp",
				"_Image22",
				"receive_lb",
				"receive_red_img",
				"exp_gp",
				"_Image23",
				"_Label17",
				"experience_gp",
				"_Image24",
				"_Label18",
				"_Image25",
				"_Label19",
				"exp_pay_lb",
				"_Label20",
				"_Image26",
				"detail_img",
				"_img_is_get"
			])
	}
}
window["TopVipMainView"]=TopVipMainView
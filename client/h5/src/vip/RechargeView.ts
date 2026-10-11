import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { PlatformManager } from "../PlatformManager"
import { VipModel } from "../commonModel/VipModel"
import { ResManager } from "../common/ResManager"
import { GlobalEventSystem, ClientConfig } from "../util/DeclareGlobalVar"
import { EventName } from "../common/EventName"
import { Util, SetSizeDeltaX } from "../util/Util"
import { LuaSoundManager } from "../common/SoundManager"
import { GameResPath } from "../util/GameResPath"
import { RoleManager } from "../commonModel/RoleManager"
import { RechargeItem } from "./RechargeItem"
import { table } from "../common/table"
import { LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { LoopScrCon } from "../common/LoopScrowViewMgr"
export class RechargeView extends BaseView1 {
	loop_mgr: LoopScrowViewMgr
	CreateRechargeProductItem
	InitEvent
	InitView
	OtherPay
	SetDailyText
	UpdateVipInfo
	destroy_callback
	is_center
	model
	not_show_main_msg
	show_open_movie
	use_background
	public constructor() {
		super()
		this.base_file = "vip"
		this.layout_file = "RechargeView"
		this.use_background = true
		this.is_center = true
		this.show_open_movie = true
		this.layer_value = Enum_UILayer.Activity
		this.not_show_main_msg = true
		this.model = VipModel.GetInstance()
		let plat_mgr = PlatformManager.GetInstance()
		let resMgr = ResManager.GetInstance()
		let product_list_ = []
		this.preload_server_config = {
			"config_recharge_product": false,
			"config_recharge_return": false
		}
		this.preload_client_config = {
			"ClientRechargeShow": false
		}
		this.load_callback = () => {

			this.InitView()
			this.InitEvent()
			// 		if (PlatformMgr.GetInstance().IsEyouIdnPlatform() ) {
			// 			this._lb_cost_left.size  = 16
			// 			this._lb_cost_right.size  = 18
			// 			this.labelDisplay.size  = 20
			// 			this.labelDisplay.verticalAlign = "middle"
			// this.labelDisplay.textAlign = "center"
			// 		}
		}

		this.destroy_callback = () => {
			// for (let _tmpi in product_list_) {
			// 	var product = product_list_[_tmpi]
			// 	product.DeleteMe()
			// }
			// product_list_ = []
			if (this.loop_mgr) {
				this.loop_mgr.DeleteMe()
				this.loop_mgr = null
			}
			// if (this.Content && this.Content.scrollBar) {
			// 	this.Content.scrollBar.changeHandler = null
			// }
		}
		this.InitEvent = () => {

			Util.AddClickEvent(this.down_img, () => {
				this.Content.scrollTo(8)
			}, this, true)

			Util.AddClickEvent(this._btn_recharge, () => {
				GlobalEventSystem.Fire(EventName.OPEN_VIP_VIEW)
				this.Close()
			}, this, true)

			Util.AddClickEvent(this._box_close, () => {
				this.Close()
			}, this, true, null, null, null, null, LuaSoundManager.SOUND_UI.CLOSE)

			Util.AddClickEvent(this.more_btn, () => {
				PlatformManager.GetInstance().OtherPayRequest()
			}, this, true)

			this.BindEvent(VipModel.GetInstance(), VipModel.CLOSE_SOME_VIEW, () => {
				this.Close()
			})
            Util.AddClickEvent(this.more_btn, ()=>{
				plat_mgr.OtherPayRequest()
			}, this, true)
		}

		this.InitView = () => {
			// resMgr.SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("vip","uivip_026_bg"))
			resMgr.SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("vip", "ui_Recharge_01"))
			resMgr.SetImageSprite(this, this._Image2, "vip", "vip_026")
			resMgr.SetImageSprite(this, this._img_exp_highlight, "vip", "vip_027")
			resMgr.SetOutsideImageSprite(this, this._img_bg2, GameResPath.GetIcon("vip", "uivip_026a"))
			resMgr.SetImageSprite(this, this.Image, "vip", "uity_027")
			resMgr.SetOutsideImageSprite(this, this.bg1, GameResPath.GetIcon("vip", "ui_gift_02"))
			this.UpdateVipInfo()
			this.CreateRechargeProductItem()
			this.SetDailyText()
			let active = !PlatformManager.GetInstance().is_alpha
			this._btn_recharge.visible = active
			// if (PlatformMgr.GetInstance().IsEyouEnPlatform()) {
			// 	this._lb_cost_left.size = 20
			// 	this.labelDisplay.size = 20
			// }
			//this.more_btn.visible = (PlatformMgr.GetInstance( : IsEyouPlatform() || PlatformMgr.GetInstance(): IsEyouEnPlatform() || PlatformMgr.GetInstance(): IsEyouIdnPlatform() || PlatformMgr.GetInstance(): IsEyouThPlatform()) && PlatformMgr.GetInstance().IsMorePayShow())
			let sour = "re_more"
			// if (PlatformMgr.GetInstance().IsEyouEnPlatform()) {
			// 	sour = "more_en"
			// }
			// if (PlatformMgr.GetInstance().IsEyouJpPlatform()) {
			// 	this._lb_cost_left.text = "100個消費するごとにEXP+1"
			// 	this._lb_cost_right.text = ""
			// 	this._lb_maxlv.text = "プレミア最高レベルに到達しています"
			// 	SetAnchoredPositionX(this._img_diamond, 218)
			// 	SetAnchoredPositionX(this._lb_cost_left, 264.5)
			// }
			// if (PlatformMgr.GetInstance().IsEyouThPlatform()) {
			// 	SetSizeDeltaY(this._lb_cost_right, 30)
			// }
			ResManager.GetInstance().SetImageSprite(this, this.more_btn, "vip_asset", sour, true)
			this.OtherPay()
		}

		this.UpdateVipInfo = () => {
			let vip_lv = VipModel.GetInstance().GetVipLevel()
			// let vip_flag = RoleManager.GetInstance().GetMainRoleVo().vip_flag
			resMgr.SetImageSprite(this, this._img_vip, "common_asset", "com_vip_" + vip_lv)
			// this.txt_vip_rank.text = vip_flag
			let cur_exp = this.model.GetExp()
			let need_exp = this.model.GetNextStageExp()
			if (cur_exp == 0 && need_exp == 0) {
				SetSizeDeltaX(this._img_exp_highlight, 356)
				this._lb_exp_text.text = "已满级"
				this._lb_exp_text.visible = false
				this._lb_cost_left.visible = false
				this._lb_cost_right.visible = false
				this._img_diamond.visible = false
				this._lb_maxlv.visible = true
				this.day_exp_text.visible = false
			} else {
				SetSizeDeltaX(this._img_exp_highlight, 356 * cur_exp / need_exp)
				this._lb_exp_text.text = cur_exp + "/" + need_exp
				this._lb_exp_text.visible = true
			}
		}

		this.CreateRechargeProductItem = () => {
			let recharge_list = this.model.GetShowRechargeProductList()
			if (recharge_list) {
				if (recharge_list.length % 2 != 0) {
					table.insert(recharge_list, [])
				}
				this.loop_mgr = new LoopScrowViewMgr()
				this.loop_mgr.SetData(this.Content, RechargeItem, recharge_list, LoopScrCon.Vertical)
				this.Content.scrollBar.changeHandler = new Laya.Handler(this, (value) => {
					this.down_img.visible = value < 290
				})
				// for (let i = 0; i < recharge_list.length; i++) {
				// 	var v = recharge_list[i]
				// 	let item = new RechargeItem(this.Content)
				// 	item.Load()
				// 	item.SetData(v)
				// 	table.insert(product_list_, item)
				// }
			}
		}

		this.SetDailyText = () => {
			if (this.model.active_card_type && this.model.active_card_type > 3) {
				this.day_exp_text.text = "每日登录+5点经验"
			} else {
				this.day_exp_text.text = ""
			}
		}
		this.OtherPay = ()=>{
            let call_fun = (obj)=>{
                console.warn("SupportOtherPay 回调--------：", JSON.stringify(obj))
                if (!this.use_delete_method){
                    this.more_btn.visible = (obj && obj.value) ? Number(obj.value) == 1 : false
                }
            }
            plat_mgr.SupportOtherPay(call_fun)
        }
	}
	public Open(...new_args) {
		super.Open()
	}

	_img_bg: Laya.Image
	bg1: Laya.Image
	_img_bg2: Laya.Image
	Image: Laya.Image
	_Image11: Laya.Image
	_btn_recharge: Laya.Box
	_Image1: Laya.Image
	labelDisplay: Laya.Label
	_img_vip: Laya.Image
	txt_vip_rank: Laya.Label
	Content: Laya.List
	_Group1: Laya.Box
	_Image2: Laya.Image
	_img_exp_highlight: Laya.Image
	_lb_exp_text: Laya.Label
	_lb_cost_left: Laya.Label
	_lb_cost_right: Laya.Label
	_img_diamond: Laya.Image
	_Image3: Laya.Image
	_box_close: Laya.Box
	_img_close: Laya.Image
	_lb_maxlv: Laya.Label
	day_exp_text: Laya.Label
	img_progress_di: Laya.Image
	more_btn: Laya.Image
	down_img: Laya.Image
	public GetComponents() {
		[
			this._img_bg,
			this.bg1,
			this._img_bg2,
			this.Image,
			this._Image11,
			this._btn_recharge,
			this._Image1,
			this.labelDisplay,
			this._img_vip,
			this.txt_vip_rank,
			this.Content,
			this._Group1,
			this._Image2,
			this._img_exp_highlight,
			this._lb_exp_text,
			this._lb_cost_left,
			this._lb_cost_right,
			this._img_diamond,
			this._Image3,
			this._box_close,
			this._img_close,
			this._lb_maxlv,
			this.day_exp_text,
			this.img_progress_di,
			this.more_btn,
			this.down_img,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"bg1",
				"_img_bg2",
				"Image",
				"_Image11",
				"_btn_recharge",
				"_Image1",
				"labelDisplay",
				"_img_vip",
				"txt_vip_rank",
				"Content",
				"_Group1",
				"_Image2",
				"_img_exp_highlight",
				"_lb_exp_text",
				"_lb_cost_left",
				"_lb_cost_right",
				"_img_diamond",
				"_Image3",
				"_box_close",
				"_img_close",
				"_lb_maxlv",
				"day_exp_text",
				"img_progress_di",
				"more_btn",
				"down_img",
			])
	}
}
window["RechargeView"] = RechargeView
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { Util } from "../util/Util"
import { PlatformManager } from "../PlatformManager"
import { VipModel } from "../commonModel/VipModel"
import { EventName } from "../common/EventName"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { ViewPopLevelModel } from "../commonModel/ViewPopLevelModel"
import { table } from "../common/table"
import { SYTweenLite } from "../util/SYTweenLite"
import { RoleManager } from "../commonModel/RoleManager"
import { Config } from "../common/Config"
export class RechargeItem extends BaseItemRenderer {
	WIDTH = 310
	HEIGT = 261
	InitEvent
	SHowItem
	SetData
	ShowProductTwo
	SwicthItem
	need_refreshData
	product_info_
	product_data
	money_cfg
	vip_model = VipModel.GetInstance()
	vipM = VipModel
	resMgr = ResManager.GetInstance()

	tween_list
	wait_time_id
	public constructor() {
		super()


		this.base_file = "vip"
		this.layout_file = "RechargeItem"
		let local_util = Util
		let platMgr = PlatformManager.GetInstance()
		let e_name = EventName
		let local_g_event = GlobalEventSystem
		let product_typetwo_info_ = null
		let is_recharging_ = false
		this.need_refreshData = false;
		this.load_callback = () => {


			if(PlatformManager.IsEyouEnPlatform()){
				this._Image3.pos(110,53)
				this._lb_donate_jewel.pos(139,57)
				this._lb_donate_jewel.fontSize = 22
			}
			this.InitEvent()

			// if (this.need_refreshData) {
			// 	this.SetData(this.product_data)
			// 	this.need_refreshData = false
			// }
		}


		this.InitEvent = () => {


			Util.AddClickEvent(this._box_product, () => {
				if (this.product_info_) {
					GlobalEventSystem.Fire(EventName.OPEN_VIEW, "ActivityRechargeShow", this.product_info_)
				}
			}, this, true)


			this.resMgr.SetImageSpriteTrans(this, this._img_bg, GameResPath.GetIcon("vip", "uivip_027_1"))
			//this.resMgr.SetOutsideImageSprite(this, this._Image2, GameResPath.GetIcon("vip", "uivip_028"))
			let OnProductClik = () => {
				is_recharging_ = true
				if (this.money_cfg) {

					platMgr.PayRequest(this.money_cfg.money, { id: this.money_cfg.product_id, pay_title: this.money_cfg.product_name })
				}
			}

			Util.AddClickEvent(this._gp_product, OnProductClik, this, true)
			let UpdateView = (scmd?) => {
				if (!this.data || !this.product_info_) return

				if (scmd == null) {
					//充值成功
					setTimeout(() => {
						if (this.use_delete_method) return
						this.ShowActivityView()
					}, 200);

				}

				if (this.product_info_ && this.product_info_.product_id && scmd && scmd.product_id) {
					if (scmd != null) {
						let cfg = this.vip_model.GetEyouCardReturnMappingCfg(this.product_info_.product_id)
						if ((this.product_info_ && scmd.product_id == this.product_info_.product_id)
							|| (cfg && cfg.mapping_product_id == scmd.product_id)) {
							this.SwicthItem(this.product_info_.product_id, scmd.return_type)
						}
					} else {
						if (is_recharging_ && this.product_info_.product_id != 1) {
							is_recharging_ = false
							//let point = this.localToGlobal(this.width / 2, this.height / 2)
							//local_g_event:Fire(e_name.REWARD_FLY, {[1, 0, this.product_info_.money * 10]}, point, null, Enum_UILayer.Top, -100)
						}
					}

				}
			}

			this.BindEvent(this.vip_model, this.vipM.UPDATE_RECHARGE_VIEW, UpdateView)
			let on_getbtn_click = () => {
				if (!this.product_info_) return
				is_recharging_ = true
				this.vip_model.Fire(this.vipM.REQUEST_PROTO, 15902, "i", this.product_info_.product_id)
			}

			Util.AddClickEvent(this._gp_btn, on_getbtn_click, this, true)
			this.BindEvent(this.vip_model, this.vipM.UPDATE_RECHARGE_TYPETWO, (info?) => {
				if (!this.data || !this.product_info_) return
				if (info == null && is_recharging_) {
					is_recharging_ = false
					//let point = this.localToGlobal(this.width / 2, this.height / 2)
					//local_g_event:Fire(e_name.REWARD_FLY, {[2, 0, 100]}, point, null, Enum_UILayer.Top, -100)
					return
				}
				if (this.product_info_.product_type != 2) {
					return
				}
				let list = null
				if (!info && product_typetwo_info_.left_count) {
					product_typetwo_info_.state = 2
					product_typetwo_info_.left_count = product_typetwo_info_.left_count - 1
				} else {
					list = info.product_list
				}
				if (!list) {
					return
				}
				this.ShowProductTwo(list)
			}
			)
		}

		// this.SetData = (info?) => {
		// 	this.product_data = info
		// 	//this.product_info_ = info
		// 	if (this.is_loaded) {
		// 		this.SHowItem()
		// 	} else {
		// 		this.need_refreshData = true
		// 	}

		// }

		this.SHowItem = () => {

		}

		this.ShowProductTwo = (list?) => {
			for (let _tmpi in list) {
				var info = list[_tmpi]
				if (info.product_id == this.product_info_.product_id) {
					product_typetwo_info_ = info
					// if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
					// 	this._lb_money.size  = 22
					// }else{
					this._lb_money.fontSize = 34
					//}
					if (0 == product_typetwo_info_.state) {
						this._gp_product.mouseEnabled = true
						this._gp_btn.visible = false
					} else if (1 == product_typetwo_info_.state) {
						this._gp_product.mouseEnabled = false
						this._gp_btn.visible = true
					} else if (2 == product_typetwo_info_.state) {
						this._gp_product.mouseEnabled = false
						this._gp_btn.visible = false
						// if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
						// 	this._lb_money.size  = 22
						// }else{
						this._lb_money.fontSize = 28
						//}
						if (product_typetwo_info_.left_count > 0) {
							this._lb_money.text = "剩余" + product_typetwo_info_.left_count + "天"
						} else {
							this._lb_money.text = "已全部领取"
						}
					} else if ("default" == product_typetwo_info_.state) {
					}
				}
			}
		}

		this.SwicthItem = (product_id?, return_type?) => {
			if (product_id && return_type != undefined) {
				let is_return = return_type
				// if (PlatformMgr.GetInstance().IsEyouPlatform() ) { //eyou第三方儲值返還映射
				// 	let value = this.vip_model.EyouCardReturnMapping(product_id)
				// 	if (value ) {
				// 		is_return = value
				// 	}
				// }
				this._gp_donate.visible = is_return != 0
				let cfg = ResManager.GetInstance().GetGameConfigFromCache(this.base_item, "config_recharge_return", false)
				let return_cfg = cfg[product_id + "@" + return_type]
				if (return_cfg) {
					this._lb_donate_jewel.text = return_cfg.return_gold
				}
			}
		}

		this.Load()
	}
	public dataChanged() {
		if (!super.dataChanged()) {
			return
		}
		if (!this.data || this.data.length <= 0) {
			this._gp_product.visible = false
			this._gp_btn.visible = false
			return
		}
		this.product_data = this.data
		let cfg = ResManager.GetInstance().GetGameConfigFromCache(this.base_item, "config_recharge_product", false)
		this.product_info_ = cfg[this.product_data.product_id]


		//是否展示充值豪礼界面
		this.ShowActivityView()

		// if (PlatformManager.IsEyouPlatform() ) {
			//蘋果手機
			// if (Laya.Browser.onIOS) { 
			// 	//eyou臺灣地區
			// 	if (PlatformManager.IsTWAreaCurrency()) {
			// 		this.product_info_ = Config.RechargeEyouIOSTwProduct[this.product_data.product_id]
			// 	}else{
			// 		//eyou非臺灣地區（澳門香港）
			// 		this.product_info_ = Config.RechargeEyouIOSNotTwProduct[this.product_data.product_id]
			// 	}
			// } else if (Laya.Browser.onAndroid) { //安卓
			// 	//eyou臺灣地區
			// 	if (PlatformManager.IsTWAreaCurrency() ) {
			// 		this.product_info_ = Config.RechargeEyouAndroidTwProduct[this.product_data.product_id]
			// 	}else{
			// 		//eyou非臺灣地區（澳門香港）
			// 		this.product_info_ = Config.RechargeEyouAndroidNotTwProduct[this.product_data.product_id]
			// 	}
			// }
			
		// } else if (PlatformManager.IsEyouJpPlatform() ) {
		// 	this.product_info_ = Config.RechargeEyouJapanProduct[this.product_data.product_id]
		// } else if (PlatformManager.IsEyouIdnPlatform() ) {
		// 	this.product_info_ = Config.RechargeEyouIdnProduct[this.product_data.product_id]
		// } else if (PlatformManager.IsEyouKrPlatform() ) {
		// 	if (Laya.Browser.onIOS) { //蘋果手機
		// 		this.product_info_ = Config.RechargeEyouKrIosProduct[this.product_data.product_id]
		// 	} else if (Laya.Browser.onAndroid) { //安卓
		// 		this.product_info_ = Config.RechargeEyouKrAndroidProduct[this.product_data.product_id]
		// 	}
		// }
		if (PlatformManager.IsEyouThPlatform()) {
			this.product_info_ = Config.PRELOAD_CLIENT_CONFIG.ConfigRechargeEyouThProduct[this.product_data.product_id]
		} else if (PlatformManager.IsEyouEnPlatform()) {
			this.product_info_ = Config.PRELOAD_CLIENT_CONFIG.ConfigRechargeEyouEnProduct[this.product_data.product_id]
		}

		this.money_cfg = cfg[this.product_data.product_id]
		if (!this.product_info_ || !this.money_cfg) {
			return
		}
		this._lb_product_name.text = this.product_info_.product_name
		if(PlatformManager.IsEyouThPlatform()){
			this._lb_money.text = this.product_info_.money + "฿"
		}else if(PlatformManager.IsEyouEnPlatform()){
				this._lb_money.text = this.product_info_.money + "$"
		}else{
			this._lb_money.text = this.product_info_.money + "元"
		}
		if (this.product_info_.product_id <= 8) {
			this.resMgr.SetImageSprite(this, this._img_icon, "vip_asset", "recharge_" + this.product_info_.product_id, true)
		}

		if (this.product_info_.product_type == 2) {
			this._lb_describe2.visible = true
			this._lb_describe1.visible = true
			this._lb_describe1.text = this.product_info_.about
			this.vip_model.Fire(this.vipM.REQUEST_PROTO, 15901)
			return
		}

		this.SwicthItem(this.product_data.product_id, this.product_data.return_type)
	}

	/**是否展示充值豪礼界面 */
	private ShowActivityView() {
		let rscfg 
		if (PlatformManager.IsEyouThPlatform()) {
			rscfg = null  //泰文审核 先屏蔽掉这个功能
		}else{
			rscfg = ResManager.GetInstance().GetGameConfigFromCache(this, "ClientRechargeShow", true)
		}
		this._box_product.visible = false
		if (rscfg && rscfg["recharge_icon"] && rscfg["recharge_icon"]["product_ids"] && this.product_info_) {
			//判断活动数据是否为空
			let act_data_list = CustomActivityModel.GetInstance().GetRechargeList(this.product_info_.product_id)

			//配置了显示   最大充值档次需要特殊处理的 如果最大充值档次活动list为空，则显示9999的配置
			let list: Array<number> = rscfg["recharge_icon"]["product_ids"]
			let open_lv = rscfg["recharge_icon"]["open_lv"]

			if (RoleManager.GetInstance().mainRoleInfo.level >= open_lv) {
				let max_product_id = CustomActivityModel.GetInstance().GetMaxProductId()
				if (max_product_id == this.product_info_.product_id) {
					//最大充值档位特殊判断
					if (act_data_list.length <= 0) {
						let list_temp = CustomActivityModel.GetInstance().GetRechargeList(9999)
						this._box_product.visible = list.indexOf(this.product_info_.product_id) != -1 && list_temp.length > 0
					} else {
						this._box_product.visible = true
					}

				} else {
					this._box_product.visible = list.indexOf(this.product_info_.product_id) != -1 && act_data_list.length > 0
				}
			} else {
				this._box_product.visible = false
			}



		}

		if (this._box_product.visible) {
			this.PlayTween()
		} else {
			this.ClearTween()
			this.ClearTimer()
		}


	}


	public PlayTween() {
		if (!this.tween_list) {
			this.tween_list = []

		}
		let shake_w = 15
		table.insert(this.tween_list, SYTweenLite.to(this, this._img_product, SYTweenLite.UiAnimationType.ROTATION, -shake_w, 0.15, () => {

			table.insert(this.tween_list, SYTweenLite.to(this, this._img_product, SYTweenLite.UiAnimationType.ROTATION, shake_w, 0.3, () => {

				table.insert(this.tween_list, SYTweenLite.to(this, this._img_product, SYTweenLite.UiAnimationType.ROTATION, 0, 0.15, () => {

					this.WaitTime()

				}))

			}))

		}))

	}





	public WaitTime() {
		this.ClearTween()
		this.wait_time_id = setTimeout(() => {
			this.PlayTween()

		}, 0.15)

	}



	public ClearTimer() {
		if (this.wait_time_id) {

			clearTimeout(this.wait_time_id)

			this.wait_time_id = false

		}

	}



	public ClearTween() {
		if (this.tween_list) {

			for (let i = 0; i < this.tween_list.length; i++) {
				var v = this.tween_list[i]

				SYTweenLite.Stop(v)

			}

			this.tween_list = false

		}

	}

	public DeleteMe() {
		this.ClearTween()
		this.ClearTimer()
		super.DeleteMe()
	}


	_gp_product: Laya.Box
	_img_bg: Laya.Image
	_img_icon: Laya.Image
	_Group1: Laya.Box
	_Image11: Laya.Image
	_lb_product_name: Laya.Label
	_lb_describe1: Laya.Label
	_lb_money: Laya.Label
	_gp_donate: Laya.Box
	_Image2: Laya.Image
	_Image3: Laya.Image
	_Image4: Laya.Image
	_lb_donate_jewel: Laya.Label
	_lb_describe2: Laya.Label
	_gp_btn: Laya.Box
	_Button1: Laya.Box
	_Image1: Laya.Image
	labelDisplay: Laya.Label
	_Image5: Laya.Image
	_box_product: Laya.Box
	_img_product: Laya.Image
	public GetComponents() {
		[
			this._gp_product,
			this._img_bg,
			this._img_icon,
			this._Group1,
			this._Image11,
			this._lb_product_name,
			this._lb_describe1,
			this._lb_money,
			this._gp_donate,
			this._Image2,
			this._Image3,
			this._Image4,
			this._lb_donate_jewel,
			this._lb_describe2,
			this._gp_btn,
			this._Button1,
			this._Image1,
			this.labelDisplay,
			this._Image5,
			this._box_product,
			this._img_product,
		]
			= this.GetChildrenByNames([

				"_gp_product",
				"_img_bg",
				"_img_icon",
				"_Group1",
				"_Image11",
				"_lb_product_name",
				"_lb_describe1",
				"_lb_money",
				"_gp_donate",
				"_Image2",
				"_Image3",
				"_Image4",
				"_lb_donate_jewel",
				"_lb_describe2",
				"_gp_btn",
				"_Button1",
				"_Image1",
				"labelDisplay",
				"_Image5",
				"_box_product",
				"_img_product",
			])
	}
}
window["RechargeItem"] = RechargeItem
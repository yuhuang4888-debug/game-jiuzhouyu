import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { OpenFun } from "../common/OpenFun"
import { ResManager } from "../common/ResManager"
import { VipModel } from "../commonModel/VipModel"
import { RoleManager } from "../commonModel/RoleManager"
import { GameResPath } from "../util/GameResPath"
import { SYTweenFunc } from "../util/SYTweenFunc"
import { SYTweenLite } from "../util/SYTweenLite"
import { TimeUtil } from "../util/TimeUtil"
import { Util, SetSizeDeltaX, SetAnchoredPositionX, GlobalTimerQuest, SetAnchoredPositionY } from "../util/Util"
import { Vector3 } from "../util/Vector3"
import { VipActiveTab } from "./vipActiveTab"
import { UI_MODEL_TYPE } from "../common/UIModelClass3D"

export class VipActiveView extends BaseView1 {
	UIBG: Laya.Image
	topImg: Laya.Image
	vipImage1: Laya.Image
	vipImage2: Laya.Image
	closeBtn: Laya.Image
	totaleffectGroup: Laya.Box
	modelGroup: Laya.Box
	effectGroup: Laya.Box
	_img_show: Laya.Image
	enterBtn: Laya.Box
	_Image1: Laya.Image
	labelDisplay: Laya.Label
	tabGroup: Laya.Box
	tab_pos1: Laya.Box
	tab_pos2: Laya.Box
	tab_pos3: Laya.Box
	tab_pos4: Laya.Box
	tab_pos5: Laya.Box
	tab_pos6: Laya.Box
	showImage: Laya.Image
	showTitleImage: Laya.Image
	_Group1: Laya.Box
	_price_bg: Laya.Image
	_Label1: Laya.Label
	oldPriceLabel: Laya.Label
	_Image11: Laya.Image
	_Image2: Laya.Image
	_Group2: Laya.Box
	_Label2: Laya.Label
	nowPriceLabel: Laya.Label
	_Image3: Laya.Image
	_con_effect: Laya.Box
	_lb_count_time: Laya.Label
	ClearDes
	ClearTween
	EmpenterBtn
	InitEvent
	LoadSuccess
	OutlabelDisplay
	SelectTab
	ShowEffect
	ShowModel
	ShowPicture
	back_login_toClose
	click_bg_toClose
	destroy_callback
	is_auto
	is_center
	mainVo
	open_callback
	showMOdel
	show_image_offset_y
	show_image_y
	show_open_movie
	timer_id
	tween_id
	use_background
	cur_sorting_order = null

	public constructor() {
		super()

		this.base_file = "vipActive"
		this.layout_file = "VipActiveView"
		this.layer_value = Enum_UILayer.Activity
		this.is_center = true
		this.use_background = true
		this.click_bg_toClose = true
		this.show_open_movie = true
		this.back_login_toClose = true
		this.show_image_offset_y = 0
		let vip_model = VipModel.GetInstance()
		let resMgr = ResManager.GetInstance()
		let local_util = Util
		let tabButtonList_ = null
		let selectTabItem_ = null
		let nowSelect_ = null
		let showModel_ = null

		this.preload_server_config = {
			"config_vip_card": false
		}
		let tabInfo_ = [{ res: "副本次数", midres: "msz5", type: 5 },{ res: "大妖之境", midres: "msz1", type: 1 }, { res: "红装独享", midres: "msz2", type: 2 }, { res: "杀怪经验", midres: "msz3", type: 3 }, { res: "专属侍魂", midres: "msz4", type: 4 }, { res: "每日礼包", midres: "msz6", type: 6 }]
		let local_TimeUtil = TimeUtil

		this.load_callback = () => {
			// cur_sorting_order = this.AddCurrLayerSortingOrder(this.layer_value)

			this.LoadSuccess()
			this.InitEvent()
			// if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
			// 	SetSizeDeltaX(this._Label1,80)
			// 	SetAnchoredPositionX(this._Label1,-6)
			// }
			// if (PlatformMgr.GetInstance().IsEyouJpPlatform() ) {
			// 	this.labelDisplay.text = "確認へ"
			// }
			// if (PlatformMgr.GetInstance().IsEyouIdnPlatform() ) {
			// 	this.labelDisplay.size  = 16
			// }
			// if (PlatformMgr.GetInstance().IsEyouThPlatform() ) {
			// 	SetSizeDeltaX(this._Label1,70)
			// 	SetAnchoredPositionX(this._Label1,0)
			// }
		}

		this.open_callback = () => {
			// this.AddUIEffect("UI_2008", this.layer_value, this._con_effect, null, null, true, {load_call_back =() => {
			// 	this.CoverEffect(this.showTitleImage)
			// 	this.CoverEffect(this._img_show)
			// }})
		}

		this.destroy_callback = () => {
			if (this.timer_id) {
				GlobalTimerQuest.CancelQuest(this.timer_id)
				this.timer_id = null
			}
			this.ClearTween()
			if (tabButtonList_) {
				for (let _tmpi in tabButtonList_) {
					var vo = tabButtonList_[_tmpi]
					vo.DeleteMe()
					vo = null
				}
				tabButtonList_ = null
			}
			selectTabItem_ = null
			if (showModel_) {
				showModel_.DeleteMe()
				this.showMOdel = null
			}
		}

		this.LoadSuccess = () => {
			this.show_image_y = this._img_show.y
			if (!tabButtonList_) {
				tabButtonList_ = []
			}
			for (let i = 0; i < tabInfo_.length; i++) {
				let tabItem = tabButtonList_[i]
				if (!tabItem) {
					tabItem = new VipActiveTab(this["tab_pos" + (i + 1)])
					tabItem.Load()
					tabButtonList_[i] = tabItem
				}
				tabItem.index = i
				tabItem.ExcuteCallback(() => {
					tabItem.SetName(tabInfo_[i].res)
					this.SelectTab(0)
				}
				)
				tabItem.SetOnClick((index?) => {
					this.SelectTab(index)
				}, i)
			}

			// this.AddUIEffect2("ui_diamond_arrary", this.totaleffectGroup, null, null, true)
			resMgr.SetOutsideImageSprite(this, this.UIBG, GameResPath.GetIcon("vipActive", "uivipzs_001a"), true)
			resMgr.SetTexture(this, this.topImg, GameResPath.GetIcon("vipActive", "uivipzs_001"), null, true)
			// resMgr.SetImageSpriteTrans(this, this.vipImage1, GameResPath.GetIcon("vipActive", "uivipzs_002"), true)
			// resMgr.SetOutsideImageSprite(this, this._price_bg, GameResPath.GetIcon("vipActive", "uivipzs_0018a"), true)
			//resMgr:SetOutsideImageSprite(this, this.vipImage2, GameResPath.GetIcon("vipActive","uivipjh_005"), true)
			let main_role = RoleManager.GetInstance().GetMainRoleVo()
			let vip_level = vip_model.GetMaxVipCardType() //main_role.vip_flag
			let vip_cfg = this.preload_server_config["config_vip_card"] //Config.Vipcard
			let has_temp_card = vip_model.HasTempCard()

			let v4_price = 999
			if (vip_cfg && vip_level && !has_temp_card) {
				let have_price = 0
				for (let lv in vip_cfg) {
					var vip_data = vip_cfg[lv]
					if (vip_level >= lv) {
						have_price = vip_data.price
					}
				}
				v4_price = v4_price - have_price
			}
			this.nowPriceLabel.text = v4_price.toString()

			this._lb_count_time.visible = this.is_auto == true
			if (this.is_auto) {
				let end_time = local_TimeUtil.getServerTime() + 8
				let count_down
				this.timer_id = GlobalTimerQuest.AddPeriodQuest(() => {
					count_down = end_time - local_TimeUtil.getServerTime()
					this._lb_count_time.text = count_down + "秒后自动关闭"
					if (count_down < 0) {
						this.Close()
					}
				}, 1)
			}
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this.closeBtn, () => {
				this.Close()
			}
				, this, true)
			Util.AddClickEvent(this.enterBtn, () => {
				OpenFun.OpenFunHandler(8)
				this.Close()
			}
				, this, true)
		}

		this.SelectTab = (index?) => {
			if (tabButtonList_) {
				if (selectTabItem_) {
					// selectTabItem_.selectImg.visible = false
					selectTabItem_.SetSelected(false)
				}
				// [ts2lua]tabButtonList_下标访问可能不正确
				let tabItem = tabButtonList_[index]
				if (tabItem) {
					// tabItem.selectImg.visible = true
					tabItem.SetSelected(true)
					nowSelect_ = index
				}
				selectTabItem_ = tabItem
				// [ts2lua]tabInfo_下标访问可能不正确
				let tabInfo = tabInfo_[index]
				if (tabInfo) {
					this.ClearDes()
					let list
					if (1 == tabInfo.type) {
						let attack_action_list = ["attack", "idle"]
						this.ShowModel(10040003, attack_action_list, 0.8, null, UI_MODEL_TYPE.MONSTER)
					} else if (2 == tabInfo.type) {
						let attack_action_list = ["attack", "idle"]
						this.ShowModel(10060001, attack_action_list, 0.8, null, UI_MODEL_TYPE.MONSTER)
					} else if (3 == tabInfo.type) {
						// this.AddUIEffect2("ui_stageproperty_vip7", this.effectGroup, null, null, true)
						this.show_image_offset_y = 0
						this.ShowEffect("UI_2040")
					} else if (4 == tabInfo.type) {
						//let idle_action_list = [ "idle"]
						this.ShowModel(1011, null, 1.5, new Vector3(0, -250, 0), UI_MODEL_TYPE.SPRITE)
					} else if (5 == tabInfo.type) {
						// this.AddUIEffect2("ui_7day_corselet", this.effectGroup, null, null, true)
						//CustomActivityModel:GetInstance():ShowViewModel(this,"VipActiveView", 1100004, this.modelGroup,null,null,cur_sorting_order)
						this.show_image_offset_y = -20
						this.ShowPicture(tabInfo.midres)
					} else if (6 == tabInfo.type) {
						// this.AddUIEffect2("ui_stageproperty_vip6", this.effectGroup, null, null, true)
						//CustomActivityModel:GetInstance():ShowViewModel(this,"VipActiveView", 1100004, this.modelGroup,null,null,cur_sorting_order)
						this.show_image_offset_y = -40
						this.ShowEffect("UI_2042")
					}
					// this.showTitleImage.source = "vipActive_asset." + tabInfo.midres + ""
					resMgr.SetImageSpriteTrans(this, this.showTitleImage, "resource/game/vipActive/texture/" + tabInfo.midres + ".png", true)
				}
			}
		}

		this.ShowModel = (res?, action_list?, ui_scale?, pos?, type?) => {
			this.modelGroup.visible = true
			this._img_show.visible = false
			this.effectGroup.visible = false
			this.ClearTween()

			pos = pos || Vector3.zero
			this.mainVo = RoleManager.GetInstance().GetMainRoleVo()
			let [head_res, head_tex] = this.mainVo.GetRoleHeadId()
			let data = {
				clothe_res_id: res,
				custom_sorting_order: this.cur_sorting_order,
				layer_value: this.layer_value,
				position: new Vector3(0, 0, 0),// pos,
				scale:  ui_scale,
				can_rotate: true,
				action_name_list: action_list,
				type: type,
				// action_delta:true
			}
			ResManager.GetInstance().SetRoleModel(this, this.modelGroup, data)
		}

		this.ShowEffect = (res_name?) => {
			this.effectGroup.y = 208
			let scale = 5
			if(res_name == "UI_2040"){
				this.effectGroup.y = 188
				scale = 6
			}	
			this.ClearUIEffect(this.effectGroup,true)
			this.AddUIEffect(res_name, this.effectGroup, null, scale, true)
			this.modelGroup.visible = false
			this.effectGroup.visible = true
			this._img_show.visible = false
		}

		this.ShowPicture = (res_name?) => {
			resMgr.SetOutsideImageSprite(this, this._img_show, "resource/game/vipActive/texture/" + res_name + ".png", true)
			this.modelGroup.visible = false
			this._img_show.visible = true
			this.effectGroup.visible = false
			let start_posY = this.show_image_y + this.show_image_offset_y
			SetAnchoredPositionY(this._img_show, start_posY)

			this.ClearTween()
			if (!this.tween_id) {
				this.tween_id = SYTweenLite.to(this, this._img_show, SYTweenLite.UiAnimationType.ANCHORED_POSY, start_posY + 5, 2, null, SYTweenFunc.PINGPONG, true)
			}
		}

		this.ClearTween = () => {
			if (this.tween_id) {
				SYTweenLite.Stop(this.tween_id)
				this.tween_id = null
			}
		}

		this.ClearDes = () => {
			if (showModel_) {
				showModel_.DeleteMe()
				showModel_ = null
			}
			//if (this.effectGroup ) {
			//	this.ClearUIEffect(this.effectGroup)
			//}
			if (this.showImage) {
				// this.showImage.visible = false
				// this.showImage.visible = false
			}
		}
	}

	public Open(parms?) {

		this.is_auto = parms
		super.Open()
	}


	public GetComponents() {
		[
			this.UIBG,
			this.topImg,
			this.vipImage1,
			this.vipImage2,
			this.closeBtn,
			this.totaleffectGroup,
			this.modelGroup,
			this.effectGroup,
			this._img_show,
			this.enterBtn,
			this._Image1,
			this.labelDisplay,
			this.tabGroup,
			this.tab_pos1,
			this.tab_pos2,
			this.tab_pos3,
			this.tab_pos4,
			this.tab_pos5,
			this.tab_pos6,
			this.showImage,
			this.showTitleImage,
			this._Group1,
			this._price_bg,
			this._Label1,
			this.oldPriceLabel,
			this._Image11,
			this._Image2,
			this._Group2,
			this._Label2,
			this.nowPriceLabel,
			this._Image3,
			this._con_effect,
			this._lb_count_time,
		]
			= this.GetChildrenByNames([

				"UIBG",
				"topImg",
				"vipImage1",
				"vipImage2",
				"closeBtn",
				"totaleffectGroup",
				"modelGroup",
				"effectGroup",
				"_img_show",
				"enterBtn",
				"_Image1",
				"labelDisplay",
				"tabGroup",
				"tab_pos1",
				"tab_pos2",
				"tab_pos3",
				"tab_pos4",
				"tab_pos5",
				"tab_pos6",
				"showImage",
				"showTitleImage",
				"_Group1",
				"_price_bg",
				"_Label1",
				"oldPriceLabel",
				"_Image11",
				"_Image2",
				"_Group2",
				"_Label2",
				"nowPriceLabel",
				"_Image3",
				"_con_effect",
				"_lb_count_time",
			])
	}
}
window["VipActiveView"] = VipActiveView
import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { VipModel } from "../commonModel/VipModel"
import { PlatformManager } from "../PlatformManager"
import { GameResPath } from "../util/GameResPath"
import { Mathf } from "../util/Mathf"
import { Util, SetSizeDeltaX } from "../util/Util"
import { VipComponentTabButton } from "./VipComponentTabButton"
import { VipTopCardItem} from "./VipTopCardItem"
import { VipPrivilegeCardView } from "./VipPrivilegeCardView"
import { VipPrivilegeShowView } from "./VipPrivilegeShowView"
import { RoleManager } from "../commonModel/RoleManager"
import { Message } from "../sysInfo/SysInfoController"

export class VipView extends BaseView1 {
	_Image1: Laya.Image
	bg: Laya.Image
	_Image2: Laya.Image
	recharge_btn: Laya.Box
	_Image11: Laya.Image
	labelDisplay: Laya.Label
	mask_exp_highlight: Laya.Image
	_Image3: Laya.Image
	exp_highlight: Laya.Image
	exp_text: Laya.Label
	sub_view_bg: Laya.Image
	view_content: Laya.Box
	txt_vip_rank: Laya.Label
	vip_image: Laya.Image
	cost_left_label: Laya.Label
	_Image4: Laya.Image
	cost_right_label: Laya.Label
	day_exp_text: Laya.Label
	money_icon: Laya.Image
	title_image: Laya.Image
	close_btn: Laya.Image
	tab_content: Laya.List
	title_group: Laya.VBox
	_box_close :Laya.Box
	_Box_top_vip: Laya.Box
	DestroyCallback
	InitEvent
	InitTabItem
	LoadSuccess
	Open
	SelectIndex
	SetDailyText
	SetSubView
	UpdateVipInfo
	close_callback
	destroy_callback
	is_center
	is_lastView_close
	loop_scroll
	not_show_main_msg
	on_item_touch
	open_callback
	tab_list
	use_background
	top_card_item
	CreatTopCardItem
	HideElement
	HideTopItem
	check
	toggle



	public constructor() {
		super()

		// this.tab_list = eui. new List();
		this.base_file = "vip"
		this.layout_file = "VipBaseView"
		this.is_center = true
		this.layer_value = Enum_UILayer.Activity
		this.use_background = true
		this.not_show_main_msg = true
		this.is_lastView_close = true
		// let local_util = Util 
		let vipM = VipModel
		let vip_model = vipM.GetInstance()
		let resMgr = ResManager.GetInstance()
		// let local_eui = eui
		let exp_mask_ = null
		let default_index_ = 0
		let pop_sub_item_ = null
		let pop_sub_view_ = null
		let sub_item_list_ = []
		let sub_view_list_ = []
		let sub_info_ = null
		let card_index_ = null
		let cur_tab_index_ = -1
		let show_vip_lv_ = 0
		let select_card_type_ = null
		let SubIndexList_ = [{ index: 0, label: "特权卡", title_resource: "vip_021", view: VipPrivilegeCardView }, { index: 1, label: "特权福利", title_resource: "vip_020", view: VipPrivilegeShowView }]
		this.load_callback = () => {

			// this.Content = this.GetChild("tab_content/Viewport/Content")
			this.LoadSuccess()
		}

		this.open_callback = () => {
			// this.tab_list.selectedIndex = default_index_
			this.loop_scroll.SetSelectIndex(default_index_)
			this.SelectIndex(default_index_)
			this.UpdateVipInfo()
		}

		this.close_callback = () => {
			cur_tab_index_ = null
			default_index_ = 1
		}

		this.destroy_callback = () => {
			this.DestroyCallback()
		}

		this.LoadSuccess = () => {
			// if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
			// 	this.cost_left_label.size  = 20
			// 	this.labelDisplay.size  = 20
			// }
			this.CreatTopCardItem()
			this.InitEvent()
			this.SetDailyText()
			this.InitTabItem()
			let bg_url = GameResPath.GetIcon("vip", "vip_bg")
			resMgr.SetOutsideImageSprite(this, this.bg, bg_url)

			resMgr.SetImageSprite(this, this._Image3, "vip", "vip_026")
			resMgr.SetImageSprite(this, this.exp_highlight, "vip", "vip_027")
			resMgr.SetOutsideImageSprite(this,this._Image1,GameResPath.GetIcon("vip","ui_gift_02"))
			let vip_hide = vip_model.GetVipHide()
			let state = vip_hide <= 0 ? false : true
			this.toggle.visible = state
			this.recharge_btn.visible = !PlatformManager.GetInstance().is_alpha
		}

		this.InitEvent = () => {
			let OnCloseBtnClick = () => {
				this.Close()
			}
			Util.AddClickEvent(this._box_close, OnCloseBtnClick, this, true)

			let OnRechargeBtnClick = () => {
				vipM.GetInstance().Fire(vipM.OPEN_VIEW, "RechargeView")
				this.Close()
			}
			Util.AddClickEvent(this.recharge_btn, OnRechargeBtnClick, this, true)

			Util.AddClickEvent(this.check, ()=> {
				let vip_lv = vip_model.GetVipLevel()
				let message = Message
				if(vip_lv <= 0){
					message.show("V1及以上可设置")
					return
				}
				this.toggle.visible = !this.toggle.visible
				let state = !this.toggle.visible ? 0 : 1
				if(state == 0){
					message.show("已对他人显示VIP等级")
				}else if(state == 1){
					message.show("已对他人隐藏VIP等级")
				}
				vip_model.Fire(VipModel.IS_HIDE_VIP_FLAG, state)
			}, this, true)

			this.on_item_touch = (item?) => {
				// SoundManager.GetInstance().PlaySoundEffect("2_dianji")
				this.SelectIndex(this.tab_content.selectedIndex)
			}

			let UpdateView = () => {
				this.SetDailyText()
			}
			this.BindEvent(vip_model, vipM.UPDATE_NOBLE_STATE, UpdateView)

			let UpdateVipData = () => {
				this.UpdateVipInfo()
			}
			this.BindEvent(vip_model, vipM.UPDATE_VIP_DATA, UpdateVipData)
			VipModel.GetInstance().Fire(VipModel.REQUEST_PROTO,45004)
		}

		this.Open = (index?, card_index?) => {
			if (index!=undefined) {
				default_index_ = index
			}
			if (index == 0) {
				select_card_type_ = card_index
			}
			super.Open()
		}

		this.UpdateVipInfo = () => {
			let vip_lv = vip_model.GetVipLevel()
			resMgr.SetImageSprite(this, this.vip_image,"common","com_vip_" + vip_lv)
			// resMgr.SetImageSprite(this, this.vip_image,"common_asset", "com_vip_" + vip_lv)
			// this.txt_vip_rank.text = vip_lv
			let cur_exp = vip_model.GetExp()
			let need_exp = vip_model.GetNextStageExp()
			if (cur_exp == 0 && need_exp == 0) {
				// this.exp_highlight.mask.width = this.exp_highlight.width
				this.exp_highlight.width=356
				this.exp_text.text = "已满级"
			} else {
				// this.exp_highlight.mask.width = this.exp_highlight.width * cur_exp / need_exp
				SetSizeDeltaX(this.exp_highlight, 356 * Mathf.Min(1, cur_exp / need_exp))
				this.exp_text.text = Math.ceil(cur_exp) + "/" + need_exp
			}
		}

		this.SelectIndex = (index?, secIndex?) => {
			let cur_index = cur_tab_index_
			cur_tab_index_ = index
			// this.tab_list.selectedIndex = index
			// this.loop_scroll.SetSelectIndex(index)
			// [ts2lua]SubIndexList_下标访问可能不正确
			sub_info_ = SubIndexList_[index]
			if (sub_info_) {
				// this.title_image.source = "vip_asset." + sub_info_.title_resource + ""
				// ResManager.GetInstance().SetImageSprite(this, this.title_image, "vip_asset", sub_info_.title_resource, true)
				// this.title_image.left = 870 - this.title_image.width / 2
				this.SetSubView(index, secIndex)
			}
		}

		this.SetSubView = (index?, secIndex?) => {
			let bg_url
			let bool_element
			let bool_top_item
			if(index < 1){
				bg_url = GameResPath.GetIcon("vip", "vip_bg")
				bool_element = false
				bool_top_item = true
			}
			else{
				bg_url = GameResPath.GetIcon("vip", "vip_bg_1")
				bool_element = true
				bool_top_item = false
			}
			this.HideElement(bool_element)
			this.HideTopItem(bool_top_item)
			resMgr.SetOutsideImageSprite(this, this.bg, bg_url)
			// [ts2lua]sub_view_list_下标访问可能不正确
			let sub_view = sub_view_list_[index]
			if (!sub_view) {
				let sub_view_class = sub_info_.view
				if (sub_view_class) {
					sub_view = new sub_view_class(this.view_content, null, this.layer_value)
					// [ts2lua]sub_view_list_下标访问可能不正确
					sub_view_list_[index] = sub_view
				}
				if (sub_view) {
					sub_view.Load()
				}
				if (sub_info_.view == VipPrivilegeCardView && select_card_type_) {
					sub_view.SetSelectIndex(select_card_type_)
					select_card_type_ = null
				}
			}
			if (sub_view) {
				if (pop_sub_view_ && pop_sub_view_ != sub_view) {
					pop_sub_view_.SetVisible(false)
				}
				pop_sub_view_ = sub_view
				pop_sub_view_.SetVisible(true)

				if (sub_info_.view == VipPrivilegeShowView) {
					if (secIndex) {
						sub_view.SetLabel(secIndex)
					}
				}
			}
		}

		this.HideElement = (bool) => {
			this.recharge_btn.visible = bool
			this.vip_image.visible = bool
			this.day_exp_text.visible = bool
			this.exp_text.visible = bool
			this._Image4.visible = bool
			this.cost_right_label.visible = bool
			this.cost_left_label.visible = bool
			this._Image2.visible = bool
			this._Image3.visible = bool
			this.exp_highlight.visible = bool
		}

		this.HideTopItem = (bool) => {
			this._Box_top_vip.visible = bool
		}

		this.CreatTopCardItem = () => {
			this.top_card_item = new VipTopCardItem(this._Box_top_vip)
			this.top_card_item.Load()
			// if(this.top_card_item){
			// 	this.top_card_item.ExcuteCallback(()=>{})
			// }
		}

		this.InitTabItem = () => {
			// this.loop_scroll = local_eui.this. new loop_scroll()
			// this.loop_scroll.source = SubIndexList_
			// this.tab_list.dataProvider = this.loop_scroll
			// this.tab_list.itemRenderer = VipComponentTabButton

			if (!this.loop_scroll) {
				this.loop_scroll = new LoopScrowViewMgr()
			}
			this.loop_scroll.SetData(this.tab_content, VipComponentTabButton, SubIndexList_, LoopScrCon.Horizontal, 1, this.on_item_touch)

			// let hLayout = local_eui. new HorizontalLayout()
			// hLayout.gap = 10
			// hLayout.paddingLeft = 20
			// hLayout.horizontalAlign = Laya.HorizontalAlign.LEFT
			// this.tab_list.layout = hLayout
			// this.tab_list.height = this.tab_content.height
			// this.tab_list.width = this.tab_content.width
			// this.tab_content.viewport = this.tab_list
		}

		this.SetDailyText = () => {
			// if (vip_model.active_card_type > 3 ) {
			if (vip_model.active_card_type && vip_model.active_card_type > 3) {
				this.day_exp_text.text = "每日登录+5点经验"
			} else if (!vip_model.active_card_type || vip_model.active_card_type == 0) { 	
				this.day_exp_text.text = "需购买以下特权卡才能成功激活且获得vip经验哦"
			} else {
				this.day_exp_text.text = ""
			}
		}

		this.DestroyCallback = () => {
			for (let index in sub_view_list_) {

				sub_view_list_[index].DeleteMe()
				sub_view_list_[index] = null
			}
			sub_view_list_ = []
			for (let index in sub_item_list_) {

				sub_item_list_[index].DeleteMe()
				sub_item_list_[index] = null
			}
			sub_item_list_ = []

			if (this.loop_scroll) {
				this.loop_scroll.DeleteMe()
				this.loop_scroll = null
			}

			if (this.top_card_item) {
				this.top_card_item.DeleteMe()
				this.top_card_item = null
			}
		}
	}


	public GetComponents() {
		[
			this._Image1,
			this.bg,
			this._Image2,
			this.recharge_btn,
			this._Image11,
			this.labelDisplay,
			this.mask_exp_highlight,
			this._Image3,
			this.exp_highlight,
			this.exp_text,
			this.sub_view_bg,
			this.view_content,
			this.txt_vip_rank,
			this.vip_image,
			this.cost_left_label,
			this._Image4,
			this.cost_right_label,
			this.day_exp_text,
			this.money_icon,
			this.title_image,
			this.close_btn,
			this.tab_content,
			this.title_group,
			this._box_close,
			this._Box_top_vip,
			this.check,
			this.toggle
		]
			= this.GetChildrenByNames([

				"_Image1",
				"bg",
				"_Image2",
				"recharge_btn",
				"_Image11",
				"labelDisplay",
				"mask_exp_highlight",
				"_Image3",
				"exp_highlight",
				"exp_text",
				"sub_view_bg",
				"view_content",
				"txt_vip_rank",
				"vip_image",
				"cost_left_label",
				"_Image4",
				"cost_right_label",
				"day_exp_text",
				"money_icon",
				"title_image",
				"close_btn",
				"tab_content",
				"title_group",
				"_box_close",
				"_Box_top_vip",
				"check",
				"toggle"
			])
		this.tab_content.scrollBar.visible=false
	}
}
window["VipView"]=VipView
import { BaseView1, OpenMode } from "../common/BaseView1"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { BaseDungeonModel } from "../commonModel/BaseDungeonModel"
import { BossModel } from "../commonModel/BossModel"
import { RoleManager } from "../commonModel/RoleManager"
import { VipModel } from "../commonModel/VipModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { Util, Trim, RefBoxChildsLayout, SetHtmlStyle, SetHtmlCenter } from "../util/Util"

export class BossDomainBuyView extends BaseView1 {
InitEvent
LoadSuccess
UpdateView

public constructor(){
super() 
	

	this.base_file = "bossdomain"
	this.layout_file = "BossDomainBuyView"
	this.layer_value = Enum_UILayer.Activity
	this.open_mode = OpenMode.OpenToggle
	this.destroy_imm = true
	this.background_alpha = 0.75
	this.use_background = true
	this.click_bg_toClose = true
	this.is_center = true
	let _model = BossModel.GetInstance()
	let can_buy = false
	let dun_cfg = null
	let role_mgr = RoleManager.GetInstance()
	let vip_model = VipModel.GetInstance()
	let local_BossBaseModel = BossModel
	this.preload_server_config={
		"config_num_by_vip":false,
		"config_decoration_boss_kv":false
	}

	this.load_callback = () => {
		SetHtmlStyle(this._lb_rcount,{c:"#663519",f:22,ww:false,w:200})
		SetHtmlStyle(this._lb_lcount,{c:"#663519",f:22,ww:false,w:200})
		SetHtmlStyle(this._lb_msg,{c:"#663519",f:20,ww:false,w:580})
		this.InitEvent()
		this.LoadSuccess()
	}

	this.LoadSuccess = () => {
		this.UpdateView()
	}

	this.InitEvent = () => {
		Util.AddClickEvent(this.closeBtn,() => {
				this.Close()
			}, this, true)

		let cancal_func = () => {
			this.Close()
		}
		Util.AddClickEvent(this._btn_cancal, cancal_func, this, true)

		let ok_func = () => {
			if (can_buy ) {
				BaseDungeonModel.GetInstance().Fire(BaseDungeonModel.SCMD_REQUEST, 47104)
			}else{
				GlobalEventSystem.Fire(EventName.OPEN_VIP_VIEW)
				this.Close()
			}
		}

		Util.AddClickEvent(this._btn_ok, ok_func, this, true)
		this.BindVar(role_mgr.GetMainRoleVo(), "vip_flag",(event_name?, value?, old_value?) => {
				this.UpdateView()
			}
		)
		this.BindEvent(vip_model, VipModel.UPDATE_NOBLE_STATE,() => {
				this.UpdateView()
			}
		)
		this.BindEvent(_model, local_BossBaseModel.DOMAINBOSS_BUY_TIME_RETURN,() => {
				this.UpdateView()
			}
		)
	}

	this.UpdateView = () => {
		let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_num_by_vip", false)
		if (! cfg ) {
			this.Close()
			return
		}
		let vip_card = vip_model.GetNobleCardState()
		let vip_flag = role_mgr.GetMainRoleVo().vip_flag
		if (vip_card > 0 ) {
			this.labelDisplay1.text = "购买"
			can_buy = true
		}else{
			this.labelDisplay1.text = "前往"
			vip_card = 99
		}
		let value = vip_model.GetVipPrivilegeValue(local_BossBaseModel.DOMAIN_MODULE_ID, 3, vip_card, vip_flag)
		if (value == null ) {
			this.Close()
			return
		}
		let next_lv = null
		let next_value = null
		let i = vip_flag + 1
		do {
			next_value = vip_model.GetVipPrivilegeValue(local_BossBaseModel.DOMAIN_MODULE_ID, 3, vip_card, i)
			if (next_value && next_value > value ) {
				next_lv = i
				break
			}
			i=i+1
		} while ((i < 15))
		if (next_lv ) {
			this._img_arrow.visible = true 
			this._group_right.visible = true 
			this._lb_rcount.innerHTML = "每天能购买" + next_value + "次"
			SetHtmlCenter(this._lb_rcount,{x:0,w:200})
			//lua_resM:SetOutsideImageSprite(this, this._img_rvip, "client/assets/icon/common/com_vip_" + next_lv + ".png")
			ResManager.GetInstance().SetImageSprite(this, this._img_rvip, "common_asset","com_vip_" + next_lv,true)
		}else{
			this._img_arrow.visible = false 
			this._group_right.visible = false 
		}

		RefBoxChildsLayout(this._Group1,30,null,true)
		let buy_count = _model.do_main_data.buy_count
		let left_num = "0"
		let cost = 0
		let kv_cfg = ResManager.GetInstance().GetGameConfigFromCache(this,"config_decoration_boss_kv",false)
		if (kv_cfg[10] && Trim(kv_cfg[10].value) != "[]" ) {
			cost = JSON.parse(kv_cfg[10].value)[0][2]
		}
		left_num = String(Math.max(0, value - buy_count))
		ResManager.GetInstance().SetImageSprite(this, this._img_lvip, "common","com_vip_" + vip_flag,true)
		if (left_num == "0" ) {
			left_num = "<font color='#ff0000'>" + left_num + "</font>"
		}
		this._lb_lcount.innerHTML =`每天能购买${left_num}/${value}次`
		SetHtmlCenter(this._lb_lcount,{x:0,w:200})
		if (can_buy ) {
			this._lb_msg.innerHTML = Util.StrToHTML("是否使用<font color='#639c12'>" + cost + "勾玉/绑玉</font>购买1次挑战次数")
			this._img_tips.visible=this._lb_tips.visible = true 
			this._Group1.y=194
		}else{
			this._img_tips.visible=this._lb_tips.visible = false 
			this._Group1.y=169
			this._lb_msg.innerHTML = Util.StrToHTML("激活<font color='#639c12'>特权卡</font>后即可消耗绑玉/勾玉购买挑战次数")
		}

		SetHtmlCenter(this._lb_msg,{x:0,w:580})
	}
}

public DeleteMe(){
	super.DeleteMe()
}


_Image1:Laya.Image
_Image3:Laya.Image
_lb_msg:Laya.HTMLDivElement
_img_tips:Laya.Image
_lb_tips:Laya.Label
_btn_cancal:Laya.Box
_Image111:Laya.Image
labelDisplay:Laya.Label
_btn_ok:Laya.Box
_Image11:Laya.Image
labelDisplay1:Laya.Label
_Group1:Laya.Box
_group_left:Laya.Box
_Image4:Laya.Image
_img_lvip:Laya.Image
_lb_lcount:Laya.HTMLDivElement
_Image5:Laya.Image
_img_arrow:Laya.Image
_group_right:Laya.Box
_Image6:Laya.Image
_img_rvip:Laya.Image
_lb_rcount:Laya.HTMLDivElement
closeBtn:Laya.Image
_Image2:Laya.Image
_lb_win_name:Laya.Label
public GetComponents() {
[
this._Image1,
this._Image3,
this._lb_msg,
this._img_tips,
this._lb_tips,
this._btn_cancal,
this._Image111,
this.labelDisplay,
this._btn_ok,
this._Image11,
this.labelDisplay1,
this._Group1,
this._group_left,
this._Image4,
this._img_lvip,
this._lb_lcount,
this._Image5,
this._img_arrow,
this._group_right,
this._Image6,
this._img_rvip,
this._lb_rcount,
this.closeBtn,
this._Image2,
this._lb_win_name,
]
 = this.GetChildrenByNames([

"_Image1",
"_Image3",
"_lb_msg",
"_img_tips",
"_lb_tips",
"_btn_cancal",
"_Image111",
"labelDisplay",
"_btn_ok",
"_Image11",
"labelDisplay1",
"_Group1",
"_group_left",
"_Image4",
"_img_lvip",
"_lb_lcount",
"_Image5",
"_img_arrow",
"_group_right",
"_Image6",
"_img_rvip",
"_lb_rcount",
"closeBtn",
"_Image2",
"_lb_win_name",
])
}
}
 window["BossDomainBuyView"]= BossDomainBuyView
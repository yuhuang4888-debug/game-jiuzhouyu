import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { BrightSeaEvent, BrightSeaModel } from "../commonModel/BrightSeaModel"
import { RoleManager } from "../commonModel/RoleManager"
import { ColorUtil } from "../util/ColorUtil"
import { TimeUtil } from "../util/TimeUtil"
import { Util, HtmlColorTxt, Trim, SetHtmlStyle } from "../util/Util"
import { Config } from "../common/Config"
import { GuildEvent, GuildModel } from "../commonModel/GuildModel"

export class BrightSeaCruiseLogItem extends BaseItemRenderer {
load_success_callback
model
role_mgr
sea_event

// 掠夺
STATE_PLUNDER = 0
guild_model
public WIDTH = 613
public HEIGT = 120

public constructor(parent){
super() 
	
	
	this.base_file = "brightSea"
	this.layout_file = "BrightSeaCruiseLogItem"
	this.model = BrightSeaModel.GetInstance()
	this.sea_event = BrightSeaEvent
	this.guild_model=GuildModel.GetInstance()
	this.role_mgr = RoleManager.GetInstance()
	this.load_callback = () => {
		SetHtmlStyle(this._lb_content,{f:20,c:"#663915",w:400,lh:30})
		this.InitEvent()

		if (this.load_success_callback ) {
			this.load_success_callback()
			this.load_success_callback = null
		}

		// this.SetAssistBtnVis()
	}
	this.Load()
}

public InitEvent(){ 
	this.BindEvent(this.guild_model, GuildEvent.CHANGED_CONDS_ASSIST, () => {
		// this.SetAssistBtnVis()
		this.dataChanged()
	})


	
	Util.AddClickEvent(this._btn_plunder,() => {
		if (! this.data ) { 
			return 
		}
		this.model.enemy_fight = this.data.rober_power
		let ser_id = this.role_mgr.GetMainRoleVo().server_unique_id
		this.model.LaunchBattle(this.data.auto_id, ser_id, this.role_mgr.GetMainRoleId(), 2)
	}, this, true)

	Util.AddClickEvent(this._btn_guild_help,() => {
		this.model.Fire(this.sea_event.OPEN_VIEW, "BrightSeaGuildHelpDialog", this.data)
	}, this, true)
}

public SetLoadSuccessCallback(callback?){ 
	
	this.load_success_callback = callback
}

// public SetAssistBtnVis(){
// 	let is_open = this.guild_model.IsCanOpenAssist()
// 	this._btn_guild_help.visible=is_open
// 	this._btn_plunder.y=is_open?72:44
// }

public dataChanged(){ 
	
	if(!super.dataChanged())return
	let is_plunderer = this.data.type == this.STATE_PLUNDER
	let is_open = this.guild_model.IsCanOpenAssist() && !is_plunderer
	this._btn_guild_help.visible = is_open
	this._btn_plunder.y=is_open?72:44
	this._img_pld_success.visible = false 

	this._lb_time.text = TimeUtil.timeConversion(this.data.time, "yyyy-mm-dd hh:MM:ss")
	// 4c3d35 e036f4 60aeff
	let text
	let role_name = "<font color='#e036f4'>" + this.data.rober_name + "</font>"
	let ship_data = ResManager.GetInstance().GetGameConfigFromCache(this.base_item,"config_sea_treasure_reward",false)[this.data.shipping_id]
	//Config.Seatreasurereward[this.data.shipping_id]

	let color = ColorUtil.GetColorLight(this.data.shipping_id + 1)
	let ship_name = "<font color=" + color + ">" + ship_data.name + "</font>"
	let power = this.data.rober_power || 0

	let goods_tab = []
	let reward_cnt = 0
	if (this.data.reward ) {
		for (let _tmpi in this.data.reward) {
			var info = this.data.reward[_tmpi]
			let goods = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_goods.name, info.typeId, false)
			if (goods ) {
				goods_tab[info.typeId] =  goods_tab[info.typeId] || {}
				let goods_data = goods_tab[info.typeId]
				let color_name = HtmlColorTxt(Trim(goods.goods_name + "X" + info.count), ColorUtil.GetColorLight(goods.color)) || ""
				reward_cnt = reward_cnt + info.count
				goods_data.reward = color_name
			}
		}

		if (is_plunderer ) {
			this._img_pld_success.visible = true 
			ResManager.GetInstance().SetImageSprite(this, this._img_pld_success, "brightSea_asset", "uixhrz_001", true)
		}
	}

	let back_cnt = 0
	if (this.data.back_list && this.data.back_list.length>0) {
		for (let _tmpi in this.data.back_list) {
			var info = this.data.back_list[_tmpi]
			let goods = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_goods.name, info.typeId, false)
			if (goods ) {
				let goods_data = goods_tab[info.typeId] || {}
				goods_data.back_cnt = info.count
				back_cnt = back_cnt + info.count
			}
		}
		// 追回成功
		if (! is_plunderer ) {
			if (back_cnt >= reward_cnt ) {
				this._img_pld_success.visible = true 
				ResManager.GetInstance().SetImageSprite(this, this._img_pld_success, "brightSea_asset", "uixhrz_001n", true)
				this._btn_plunder.visible = false 
				this._btn_guild_help.visible = false 
			}
		}
	}

	let goods_name = ""
	if (goods_tab ) {
		for (let type_id in goods_tab) {
			var goods_data = goods_tab[type_id]
			goods_name = goods_name + goods_data.reward || "" 
			if (goods_data.back_cnt ) {
				goods_name = goods_name + "(已夺回数量" + goods_data.back_cnt + "个)"
			}
		}
	}

	if (is_plunderer ) {
		text = `您掠夺了${role_name}的${ship_name}<br>抢走了${HtmlColorTxt(goods_name,"'#2971e6'")}`
	}else{
		text = `${role_name}(战力：${ String(power)})掠夺了您的${ ship_name}抢走了${HtmlColorTxt(goods_name,"'#2971e6'")}`
	}

	this._lb_content.innerHTML = text
	this._lb_content.style.width=400
}


public DeleteMe(){
	super.DeleteMe()
}



_img_line:Laya.Image
_lb_time:Laya.Label
_lb_content:Laya.HTMLDivElement
_btn_guild_help:Laya.Box
_Image6:Laya.Image
_Label41:Laya.Label
_btn_plunder:Laya.Box
_Image61:Laya.Image
_Label4:Laya.Label
_img_pld_success:Laya.Image
public GetComponents() {
[
this._img_line,
this._lb_time,
this._lb_content,
this._btn_guild_help,
this._Image6,
this._Label41,
this._btn_plunder,
this._Image61,
this._Label4,
this._img_pld_success,
]
 = this.GetChildrenByNames([

"_img_line",
"_lb_time",
"_lb_content",
"_btn_guild_help",
"_Image6",
"_Label41",
"_btn_plunder",
"_Image61",
"_Label4",
"_img_pld_success",
])
}
}
 window["BrightSeaCruiseLogItem"]= BrightSeaCruiseLogItem
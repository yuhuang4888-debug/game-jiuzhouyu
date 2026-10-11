import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseView1 } from "../common/BaseView1"
import { CustomHeadItem } from "../common/CustomHeadItem"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { LuaSoundManager } from "../common/SoundManager"
import { BrightSeaModel } from "../commonModel/BrightSeaModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { RoleManager } from "../commonModel/RoleManager"
import { ColorUtil } from "../util/ColorUtil"
import { ErlangParser } from "../util/ErlangParser"
import { Util, Trim, SetHtmlStyle, HtmlColorTxt } from "../util/Util"

export class BrightSeaPlunderDialog extends BaseView1 {
InitEvent
InitView
Local_DeleteMe
Local_Open
click_bg_toClose
data
data_list
destroy_imm
is_center
item_reward
model
open_callback
role_head
time_event_id
type
use_background
public constructor(){
super() 
	

	this.base_file = "brightSea"
	this.layout_file = "BrightSeaPlunderDialog"
	this.destroy_imm = true
	this.layer_value = Enum_UILayer.Activity
	this.is_center = true
	this.use_background = true
	this.click_bg_toClose = true

	this.model = BrightSeaModel.GetInstance()
	this.time_event_id = null
	this.type = null
	this.data_list = []
	let erlang_parser = ErlangParser.GetInstance()
	let role_mgr = RoleManager.GetInstance()

	this.preload_server_config =
	{
		"config_sea_treasure_reward": false
	}
	
	this.load_callback = () => {
		SetHtmlStyle(this._role_name,{c:"#663915",f:20,ww:false,w:240})
		SetHtmlStyle(this._guild_name,{c:"#663915",f:20,ww:false,w:240})
		SetHtmlStyle(this._ship_name,{c:"#663915",f:20,ww:false,w:240})
		this.InitEvent()
		this.InitView()
	}
	
	this.Local_Open = ( parms?) => {
		if (parms ) {
			this.data = parms
		}
		super.Open()
	}

	this.destroy_callback=()=>{
		this.Local_DeleteMe()
	}
	this.Local_DeleteMe = () => {
		if (this.item_reward ) {
			this.item_reward.DeleteMe()
			this.item_reward = null
		}
		if (this.role_head ) {
			this.role_head.DeleteMe()
			this.role_head = null
		}

	}
	
	this.InitEvent = () => {
		Util.AddClickEvent(this._close_btn,() => {
			this.Close()
		}, this, true, null, null, null, null, LuaSoundManager.SOUND_UI.CLOSE)

		Util.AddClickEvent(this._ok_btn,() => {
			if (! this.data ) {
				return
			}
			this.model.enemy_fight = this.data.power
			this.model.LaunchBattle(this.data.auto_id, this.data.ser_id, role_mgr.GetMainRoleId(), 1)
		}, this, true)
	}

	this.InitView = () => {
		if (! this.data ) { 
			return 
		}

		let ship_data = ResManager.GetInstance().GetGameConfigFromCache(this,"config_sea_treasure_reward",false)[this.data.shipping_id]
		//Seatreasurereward[this.data.shipping_id]
		let guild_name = this.model.GetGuildName(this.data.guild_name)
		this._role_name.innerHTML = Util.StrToHTML("名称：<font color='#d15e00'>" + this.data.role_name + "</font>")
		this._guild_name.innerHTML = Util.StrToHTML(`结社：${guild_name}`)

		if (ship_data ) {
			let color = ColorUtil.GetColorLight(this.data.shipping_id + 1)
			this._ship_name.innerHTML = Util.StrToHTML(`船只：${HtmlColorTxt(ship_data.name,color)}`)
			let reward_tb = erlang_parser.Parse(ship_data.rob_reward)
			if (reward_tb ) {


				// let reward_info = reward_tb[1]
				// if (! this.item_reward ) {
				// 	this.item_reward = this.model.LoadAwardItem(reward_info, this._con_reward, this.layer_value)
				// }
				if (!this.item_reward) {
					this.item_reward = new BaseAwardItem(this._con_reward, null, "Activity")
					this.item_reward .Load()
					this.item_reward .SetVisible(true)
					this.item_reward .SetItemSize(89, 89)
					// this.item_reward .ExcuteCallback(() => {
						
					// })
				}

				let vo = reward_tb[0]
				let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(vo[0], vo[1])
				let goods_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
				if (goods_vo) {
					this.item_reward.SetData(goods_vo.type_id, vo[2], lock)
				}


			}
		}



		if (! this.role_head ) {
			this.role_head =  new CustomHeadItem(this._con_head)
			this.role_head.Load()
		}
		let data = this.data
		this.role_head.SetData(data.role_id, data.career, data.sex, data.pic, data.pic_ver, data.turn, data.ser_id,null,data.role_lv)
		//data, role_career, role_sex, picture, picture_ver, role_turn, server_id, dress_list, level)

		//let head_res = this.model.GetHeadRes(this.data)
		//lua_resM:SetOutsideImageSprite(this, this._img_head, head_res)
		//lua_resM:SetImageSprite(this, this._frame, "mainUI_asset", "uizjm_005",true)
	}
}

public Open(...new_args){ 
	
	this.Local_Open(...new_args)
}

public DeleteMe(){ 
	
	super.DeleteMe()
}



_Image2:Laya.Image
_Img_bg:Laya.Image
_close_btn:Laya.Image
_Group1:Laya.Box
_Image4:Laya.Image
title:Laya.Label
_con_head:Laya.Box
_role_name:Laya.HTMLDivElement
_guild_name:Laya.HTMLDivElement
_ship_name:Laya.HTMLDivElement
_con_reward:Laya.Box
Image:Laya.Image
_ok_btn:Laya.Box
_Image1:Laya.Image
labelDisplay:Laya.Label
public GetComponents() {
[
this._Image2,
this._Img_bg,
this._close_btn,
this._Group1,
this._Image4,
this.title,
this._con_head,
this._role_name,
this._guild_name,
this._ship_name,
this._con_reward,
this.Image,
this._ok_btn,
this._Image1,
this.labelDisplay,
]
 = this.GetChildrenByNames([

"_Image2",
"_Img_bg",
"_close_btn",
"_Group1",
"_Image4",
"title",
"_con_head",
"_role_name",
"_guild_name",
"_ship_name",
"_con_reward",
"Image",
"_ok_btn",
"_Image1",
"labelDisplay",
])
}
}
 window["BrightSeaPlunderDialog"]= BrightSeaPlunderDialog
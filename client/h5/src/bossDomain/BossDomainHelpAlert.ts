import { BaseView1, OpenMode } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { BossModel } from "../commonModel/BossModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { Enum_ColorUtil_Dark } from "../util/ColorUtil"
import { ErlangParser } from "../util/ErlangParser"
import { Util, HtmlColorTxt, SetHtmlStyle, SetHtmlCenter } from "../util/Util"

export class BossDomainHelpAlert extends BaseView1 {
ClickLink
InitEvent
LoadSuccess
SetCheckBox
background_alpha
click_bg_toClose
destroy_imm
is_center
open_mode
use_background

public constructor(){
super() 
	
	
	this.base_file = "bossdomain"
	this.layout_file = "BossDomainHelpAlert"
	this.preload_server_config={"config_decoration_boss_kv":false}
	this.layer_value = Enum_UILayer.Activity
	this.open_mode = OpenMode.OpenToggle
	this.destroy_imm = true
	this.is_center = true
	this.use_background = true
	this.click_bg_toClose = true
	this.background_alpha = 0
	let _model = BossModel.GetInstance()
	let num = 0
	let checkSelect = false
	let local_Enum_ColorUtil_Dark = Enum_ColorUtil_Dark
	
	this.load_callback = () => {
		SetHtmlStyle(this._content,{c:"#663519",f:20,w:500})
		this.InitEvent()
		this.LoadSuccess()
	}
	
	this.InitEvent = () => {
		Util.AddClickEvent(this._cancel_btn,() => {
				this.Close()
			}
			, this, true)
		Util.AddClickEvent(this._ok_btn,() => {
				_model.Fire(BossModel.DOMAINBOSS_SELECT_CHECKBOX)
				this.Close()
			}
			, this, true)
		Util.AddClickEvent(this._close_btn,() => {
				this.Close()
			}
			, this, true)
		Util.AddClickEvent(this.check,() => {
				_model.domain_alert = ! checkSelect
				this.SetCheckBox(! checkSelect)
			}
			, this)
		//this._content.addEventListener(local_laya.TextEvent.LINK, this.ClickLink, this)
	}
	
	this.LoadSuccess = () => {
		let kv_cfg =ResManager.GetInstance().GetGameConfigFromCache(this,"config_decoration_boss_kv",false)// Config.Decorationbosskv
		let cfg = kv_cfg[19].value
		let list = ErlangParser.GetInstance().Parse(cfg)[0]
		let type_id = list[1]
		num = list[2]
		let goods_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)

		let new_str1=`开启${HtmlColorTxt("协助模式", local_Enum_ColorUtil_Dark.ORANGE) }时将无法获得奖励,只可攻击其他${ HtmlColorTxt("敌对玩家", local_Enum_ColorUtil_Dark.ORANGE)}`
		let new_str2=`,每次成功${HtmlColorTxt("协助本服玩家", local_Enum_ColorUtil_Dark.ORANGE) }获得boss归属时,可获得一份协助奖励:`
		let new_str3=`${HtmlColorTxt(`【${goods_vo.goods_name}】`, local_Enum_ColorUtil_Dark.ORANGE) }X${num}`
		let con=new_str1+new_str2+new_str3

		this._content.innerHTML = Util.StrToHTML(con)
		//AddUnderlineText(this._content, this._content,ColorUtil.GetColorLight(ColorType.GREEN), 3 , 5 )
		SetHtmlCenter(this._content,{x:0,w:581})
	}
	
	this.ClickLink = ( evt?) => {
		UIToolTipMgr.GetInstance().AppendGoodsTips(Number(evt.text), null, null, null, num)
	}
	
	this.SetCheckBox = (bool?) => {
		let res = bool && "com_ui_gx1" || "com_ui_gx"
		ResManager.GetInstance().SetImageSprite(this, this.check, "common_asset", res)
		checkSelect = bool
	}
}


public DeleteMe() {
	super.DeleteMe()
}



_Image11:Laya.Image
_Image3:Laya.Image
_content:Laya.HTMLDivElement
_cancel_btn:Laya.Box
_Image1:Laya.Image
labelDisplay1:Laya.Label
_ok_btn:Laya.Box
_Image111:Laya.Image
labelDisplay:Laya.Label
_close_btn:Laya.Box
_Image6:Laya.Image
gp_check:Laya.HBox
check:Laya.Image
Text:Laya.Label
_Image2:Laya.Image
_lb_win_name:Laya.Label
public GetComponents() {
[
this._Image11,
this._Image3,
this._content,
this._cancel_btn,
this._Image1,
this.labelDisplay1,
this._ok_btn,
this._Image111,
this.labelDisplay,
this._close_btn,
this._Image6,
this.gp_check,
this.check,
this.Text,
this._Image2,
this._lb_win_name,
]
 = this.GetChildrenByNames([

"_Image11",
"_Image3",
"_content",
"_cancel_btn",
"_Image1",
"labelDisplay1",
"_ok_btn",
"_Image111",
"labelDisplay",
"_close_btn",
"_Image6",
"gp_check",
"check",
"Text",
"_Image2",
"_lb_win_name",
])
}
}
 window["BossDomainHelpAlert"]= BossDomainHelpAlert
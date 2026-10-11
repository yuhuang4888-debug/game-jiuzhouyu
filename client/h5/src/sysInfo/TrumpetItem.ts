import { BaseItem1 } from "../common/BaseItem1"
import { Enum_UILayer, LayerManager } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
// import { ChatModel, TRUMPET_TYPE } from "../commonModel/ChatModel"
import {ChatModel, TRUMPET_TYPE } from "../commonModel/ChatModel"
import { ColorUtil, ColorType } from "../util/ColorUtil"
import { GameResPath } from "../util/GameResPath"
import { Runner } from "../util/Runner"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest, Util } from "../util/Util"
import { Vector2 } from "../util/Vector2"

export class TrumpetItem extends BaseItem1 {
Content
InlcontentLabel
Scr_scroller
SprSpriteGraphic
SpriteGraphic
_Group1:Laya.Box
_data
_gp_content:Laya.Box
_gp_effect0
_gp_effect:Laya.Box
_gp_effect1:Laya.Box
_gp_effect2:Laya.Box
_gp_effect3:Laya.Box
_img_bg:Laya.Image
_lb_name:Laya.Label
_model
_scroll_max
_scroller:Laya.Panel
_timer_time
_trumpet_timer
contentLabel:Laya.HTMLDivElement
count
faceList
horizontalCenter
need_refresh
run_obj
top
touchChildren
touchEnabled

public constructor(parent?){
super(parent) 
	
	this._timer_time = 200;
	this.faceList = [];
	this._scroll_max = 100;
	this.need_refresh = false;
	this.count = 0;
	this.base_file = "sysInfo"
	this.dependent_res = ["chat"]
	this.layout_file = "TrumpetItem"
	this._model = ChatModel.GetInstance()
	this.layer_value = Enum_UILayer.Top
	this.load_callback = () => {
		
		// this.horizontalCenter = 0
		// this.top = 300
		this.display_obj.centerX=0
		this.display_obj.y = 300
		// this.display_obj.x=Laya.stage.width/2
		// this.display_obj.y=Laya.stage.height/2
		// SetLocalPositionZ(this.form, -1000)
		this.LoadSuccess()
		this.InitEvent()
	}
}

public InitEvent(){ 
	this.contentLabel.on(Laya.Event.CLICK,this,()=>{
		this.ClickLink()

	})
}

public ClickLink(evt?){ 
	
	
}

public setData(data?){ 
	
	this._data = data
	if (this.is_loaded ) {
		this.display_obj.visible = true 
		this.UpdateItem()
	}else{
		this.need_refresh = true
	}
}

public LoadSuccess(){ 
	// [this._Group1,this._gp_content,this._gp_effect,this._gp_effect1,this._gp_effect2,this._gp_effect3,this._img_bg,this._lb_name,this._scroller,this.contentLabel]=
	// 		this.GetChildrenByNames(["_Group1","_gp_content","_gp_effect","_gp_effect1","_gp_effect2","_gp_effect3","_img_bg","_lb_name","_scroller","contentLabel"])
	// this.touchEnabled = false
	// this.touchChildren = false
	if (this._data && this.need_refresh ) {
		this.UpdateItem()
	}
}

public UpdateItem(){ 
	
	let layer = LayerManager.GetInstance().GetUILayer(Enum_UILayer.Top)
	// if ((! StoryAnimationModel.GetInstance().story_animaion_view_is_show && ! LoginModel.GetInstance().is_show_loading_view) && ! ReincarnationModel.GetInstance().is_show_effect ) {
	// 	layer.setChildIndex(this, layer.numChildren - 1)
	// }
	this.initLabel()
	this.showEffect()
}

public initLabel(){ 
	
	let str = '025'
	let trumpet_type = "世界"
	let color ="#60aeff"
	let sever_str = ''
	if (this._data.horn_type ) {
		if (this._data.horn_type == TRUMPET_TYPE.WORLD ) {
			trumpet_type = "世界"
			str = "030"
			color = "#60aeff"
		} else if (this._data.horn_type == TRUMPET_TYPE.SMALL_KUAFU ) {
			trumpet_type = "跨服"
			str = "029"
			color = "#ff9015"
			sever_str = "S" + this._data.server_num + "."
		} else if (this._data.horn_type == TRUMPET_TYPE.KUAFU ) {
			trumpet_type = "活动"
			str = "028"
			color = "#f5519b"
			sever_str = "S" + this._data.server_num + "."
		}
	}
	this._lb_name.text ="[" + trumpet_type + "]" + sever_str + this._data.name + "："
	ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, "resource/game/chat/texture/uilt_" + str + ".png")
	// this._lb_name.validateNow()
	this._scroller.x = this._lb_name.width + this._lb_name.x
	// SetLocalPositionX(this._scroller, this._lb_name.sizeDelta.x + this._lb_name.localPosition.x)
	let contentHtml = ""
	if (this._data.result == 1 ) {
		contentHtml = ChatModel.GetInstance().disposeChtaGoods(this._data.msg, this._data, this._data.player_id)
	}else{
		contentHtml = this._data.msg
	}
	contentHtml=ChatModel.GetInstance().disposeChtaFace(contentHtml,28,18,20)

	// contentHtml = ChatModel.GetInstance().FormatColorTag(contentHtml)
	// contentHtml = ChatModel.GetInstance().FormatLinkTag(contentHtml)
	// this.InlcontentLabel.textFlow = Util.StrToHTML(contentHtml)
	this.contentLabel.style.color = color
	this.contentLabel.style.fontSize = 20;
	this.contentLabel.style.wordWrap=false
	this.contentLabel.x=0;
	this.contentLabel.innerHTML=contentHtml
	if(this.contentLabel.contextWidth<300){
		this._scroller.width=this.contentLabel.contextWidth
	}else{
		this._scroller.width=300
	}
	this._Group1.width=this._scroller.width+this._lb_name.width
	// AddInlineLickEvent(this.InlcontentLabel,(param_list?) => {
					
	// 			})
	// SetInlineText(this.InlcontentLabel, Util.StrToHTML(contentHtml))
	// let first_line_has_face = ChatModel.GetInstance().disposeChtaFace2(contentHtml, this.contentLabel.text, this.contentLabel, this._gp_content, this.faceList, 2.5, 2, 7)
	// if (first_line_has_face ) {
	// 	this._scroller.y = -10
	// }else{
	// 	this._scroller.y = 7
	// }
	// this.contentLabel.validateNow()
	// this._scroller.viewport.scrollH = 0
	// this._scroller.height = this.contentLabel.height + 2
	// SetSizeDeltaY(this._scroller, this.contentLabel.sizeDelta.y + 2)
	// this._scroller.validateNow()
	// this._scroller.width = Math.min(this._scroller.viewport.contentWidth, this._scroll_max)
	// SetSizeDeltaX(this._scroller, Math.min(this._gp_content.sizeDelta.x, this._scroll_max))
	// if (! this._trumpet_timer.running ) {
	// 	this._trumpet_timer.start()
	// }
	// this.contentLabel.x = this.InlcontentLabel.preferredWidth / 2
	if (! this._trumpet_timer ) {
		this._trumpet_timer = GlobalTimerQuest.AddPeriodQuest(() => {
			this.teumpetTimer()
		}, this._timer_time / 1000, -1)
	}
	// if (! this.run_obj ) {
	// 	this.run_obj = Runner.GetInstance().AddRunObj(this, 1)
	// }
	
	if (this._data.horn_type == TRUMPET_TYPE.WORLD ) {
		ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, "resource/game/chat/texture/uilt_030.png")
	} else if (this._data.horn_type == TRUMPET_TYPE.SMALL_KUAFU ) {
		ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, "resource/game/chat/texture/uilt_029.png")
	} else if (this._data.horn_type == TRUMPET_TYPE.KUAFU ) {
		ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, "resource/game/chat/texture/uilt_028.png")
	}
	// let len = Math.min(this._scroller.sizeDelta.x, this.InlcontentLabel.preferredWidth)
	// SetSizeDelta(this._Group1, this._lb_name.preferredWidth + len + 60, 86)
}

public teumpetTimer(){ 
	
	if (this.contentLabel.contextWidth> this._scroller.width ) {
		if (this.contentLabel.x > -this.contentLabel.contextWidth  ) {
			// this.contentLabel.anchoredPosition = Vector2(this.contentLabel.anchoredPosition.x - 5, this.contentLabel.anchoredPosition.y)
			this.contentLabel.x -=10
		}else{
			// this.contentLabel.x = this.InlcontentLabel.preferredWidth / 2
			this.contentLabel.x=0//this._scroller.width+5
		}
	}
	if (this.count == 1000 / this._timer_time ) {
		this.count = 0
		if (TimeUtil.getServerTime() - this._data.time >= this._model.trumpetShow ) {
			this._model.showChat = null
			if (this._model.trumpet_Wait_List.length <= 0 ) {
				this.HidThis()
			}else{
				let chat = table.shift(this._model.trumpet_Wait_List)
				this._model.showTrumpet(chat)
			}
			this.stopTimer()
			return
		}
	}
	this.count = this.count + 1
}

public Update(){ 
	
	this.teumpetTimer()
}

public HidThis(){ 
	
	this.clearEffect()
	this.display_obj.visible = false 
}

public stopTimer(){ 
	
	if (this._trumpet_timer ) { 
		GlobalTimerQuest.CancelQuest(this._trumpet_timer)
		this._trumpet_timer = null
	}
	// if (this.run_obj ) {
	// 	Runner.GetInstance().RemoveRunObj(this.run_obj)
	// 	this.run_obj = null
	// }
}

public showEffect(){ 
	
	// this.clearEffect()
	this.AddUIEffect("ui_1109_1", this.layer_value, this._gp_effect0, null, null, true)
	if (this._data.horn_type ) {
		if (this._data.horn_type == TRUMPET_TYPE.WORLD ) {
			// this.AddUIEffect2("ui_announcement_line_blue", this._gp_effect1, null, null, true)
			this.AddUIEffect("ui_1109_2", this.layer_value, this._gp_effect1, null, null, true)
		} else if (this._data.horn_type == TRUMPET_TYPE.SMALL_KUAFU ) {
			// this.AddUIEffect2("ui_announcement_line_yellow", this._gp_effect1, null, null, true)
			// this.AddUIEffect2("ui_announcement_lizi1", this._gp_effect2, null, null, true)
			this.AddUIEffect("ui_1109_2", this.layer_value, this._gp_effect1, null, null, true)
		} else if (this._data.horn_type == TRUMPET_TYPE.KUAFU ) {
			// this.AddUIEffect2("ui_announcement_line_pink", this._gp_effect1, null, null, true)
			// this.AddUIEffect2("ui_announcement_lizi2", this._gp_effect2, null, null, true)
			// this.AddUIEffect2("ui_announcement_meteor", this._gp_effect3, null, null, true)
			this.AddUIEffect("ui_1109_2", this.layer_value, this._gp_effect1, null, null, true)
		}
	}
}

public clearEffect(){ 
	
	// this.ClearUIEffect(this._gp_effect)
	// this.ClearUIEffect(this._gp_effect1)
	// this.ClearUIEffect(this._gp_effect2)
	// this.ClearUIEffect(this._gp_effect3)
}


	public GetComponents() {
		[
			this._img_bg,
			this._gp_effect1,
			this._Group1,
			this._lb_name,
			this._scroller,
			this._gp_content,
			this.contentLabel,
			this._gp_effect,
			this._gp_effect2,
			this._gp_effect3,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_gp_effect1",
				"_Group1",
				"_lb_name",
				"_scroller",
				"_gp_content",
				"contentLabel",
				"_gp_effect",
				"_gp_effect2",
				"_gp_effect3",
			])
	}
}
window["TrumpetItem"] = TrumpetItem
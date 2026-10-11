import { BaseItem1 } from "../common/BaseItem1"
import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { WordManager } from "../common/WordManager"
import { ChatModel, CHAT_TYPE, TRUMPET_TYPE, ChatModelEvent } from "../commonModel/ChatModel"
import { MainUIModel } from "../commonModel/MainUIModel"
import { ModelPartName } from "../scene/SceneConfig"
import { ColorUtil, ColorType } from "../util/ColorUtil"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { SetSizeDeltaX, Util, Trim } from "../util/Util"
let local_CHAT_TYPE
export class MainUIChatItem extends BaseItem1 {
	_info
	click_func
	data
	empty
	faceList
	is_click_link
	is_last_msg
	link_mark
	msg
	needRefreshData
	use_local_view
	scroller
	self_parent
	public static width = 310
	public static height = 29
	//点击超链接
	click_link

	static non_breaking_space = ""//string.char(0xc2) + string.char(0xa0)
	static many_non_breaking_space = ""
	// 	for(let i = 1; i <= 9; i++) {
	// 	many_non_breaking_space = many_non_breaking_space + non_breaking_space
	// }

	public constructor(parent,scroller?) {
		super(parent)
		local_CHAT_TYPE = CHAT_TYPE
		this.self_parent=parent
		this.scroller=scroller
		// this.empty = "@@";
		this.empty = "";
		this.msg = "";
		this.link_mark = false;
		this.faceList = [];
		this.base_file = "mainUI"
		this.layout_file = "MainUIChatItem"
		this.is_delay_callback = true
		// this.use_local_view = true
		// this.Load()

		this.load_callback = () => {
			// if (PlatformMgr.GetInstance().IsEyouEnPlatform()) {
			// 	this.title.size = 13
			// 	SetSizeDeltaX(this._gp_title, 50)
			// 	SetSizeDeltaX(this.titleBg, 50)
			// }
			this.click_func = (e: Laya.Event) => {
				if (this.link_mark) {
					this.link_mark = false
					return
				}
				
				// let channel = local_CHAT_TYPE.WORLD
				// if (this._info) {
				// 	channel = this._info.channel
				// }
				// if (channel == local_CHAT_TYPE.TRUMPET) {
				// 	if (this._info.horn_type == TRUMPET_TYPE.SMALL_KUAFU) {
				// 		channel = local_CHAT_TYPE.SMALL_KUAFU
				// 	} else if (this._info.horn_type == TRUMPET_TYPE.WORLD) {
				// 		channel = local_CHAT_TYPE.WORLD
				// 	} else if (this._info.horn_type == TRUMPET_TYPE.KUAFU) {
				// 		channel = local_CHAT_TYPE.WORLD_KUAFU
				// 	} else {
				// 		channel = local_CHAT_TYPE.WORLD
				// 	}
				// }
				// GlobalEventSystem.Fire(EventName.OPEN_CHAT_VIEW, channel)
			}

			this.contentLabel.on(Laya.Event.LINK, this, this.ClickLink);

			Util.AddClickEvent(this._gp_content, (e: Laya.Event)=>{ 
				e.stopPropagation()
				if (this.is_click_link) {
					this.is_click_link = false
					return
				}
				let _data = this.data;
				if(!_data || _data.channel == undefined) return;
				let channel =_data.channel
				ChatModel.GetInstance().Fire(ChatModelEvent.CLICK_MAIN_ITEM)
				GlobalEventSystem.Fire(EventName.OPEN_CHAT_VIEW, channel)
			}, this)
			if (this.needRefreshData) {
				this.SetData(this.data)
				this.needRefreshData = null
			}
		}

	}

	public DeleteMe() {
		this.contentLabel.off(Laya.Event.LINK, this, this.ClickLink);
		super.DeleteMe()

	}

	public ClickLink(evt?, e?:Laya.Event) {
		if (this.is_click_link) {
			this.is_click_link = false
			return
		}
		this.click_link = true;
		this.click_func();
		ChatModel.GetInstance().is_click_text = true;
		ChatModel.GetInstance().LinkEvtInChatItem(evt)
		this.link_mark = true
		if(e)
		{
			e.stopPropagation()
		}
		ChatModel.GetInstance().Fire(ChatModelEvent.CLICK_MAIN_ITEM)
	}

	// function MainUIChatItem.dataChanged()
	public SetData(data?, is_last_msg?) {
		this.data = data
		this.is_last_msg = this.is_last_msg || is_last_msg
		if (!this.is_loaded || !this.display_obj) {
			this.needRefreshData = true
			return
		}
		this.SetVisible(true)
		let channel = this.data.channel
		if(this.data.channel!=10){
			ChatModel.GetInstance().selectchannel=this.data.channel
		}
		if (this._img_trumpet) {
			this._img_trumpet.visible = false
		}
		this._info = this.data
		this._info.msg = Trim(this._info.msg)
		// this._info.msg = DeleteHTMLSign(this._info.msg, true)
		let [title, src, color] = ChatModel.GetInstance().channelImage(channel)
		if (channel == local_CHAT_TYPE.SYSTEM) {
			// this.titleBg.source = "mainUI_json.mainUI_chat_1_png"
			// ResManager.GetInstance().SetImageSprite(this, this.titleBg, "mainUI_asset", "mainUI_chat_1")
			src="mainUI_chat_1"
			// this.title.text = "系统"
			// this.empty = this.empty.gsub("@@", this.title.text)
			this.empty = this.empty.replace("@@", this.title.text)
			// this.contentLabel.textColor = ColorUtil.GetColorLight(ColorType.WHITE)
			this.msg = this.empty + this._info.msg
			SetSizeDeltaX(this.contentLabel, MainUIChatItem.width - 5)
		} else if (channel == local_CHAT_TYPE.TRUMPET) {
			// if (this._img_trumpet ) {
			// 	this._img_trumpet.visible = true 
			// 	// this._img_trumpet.includeInLayout = true
			// }
			let contentHtml = ""
			let _channel = local_CHAT_TYPE.WORLD
			if (this.data.horn_type == TRUMPET_TYPE.WORLD) {
				_channel = local_CHAT_TYPE.WORLD
			} else if (this.data.horn_type == TRUMPET_TYPE.SMALL_KUAFU) {
				_channel = local_CHAT_TYPE.SMALL_KUAFU
			} else if (this.data.horn_type == TRUMPET_TYPE.KUAFU) {
				_channel = local_CHAT_TYPE.WORLD_KUAFU
			}
			let [title, src_1, color] = ChatModel.GetInstance().channelImage(_channel)
			// this.title.text = title
			src=src_1
			// this.titleBg.source = src
			// ResManager.GetInstance().SetImageSprite(this, this.titleBg, "mainUI_asset", src)
			if (this.data.result == 1) {
				contentHtml = ChatModel.GetInstance().disposeChtaGoods(this._info.msg, this._info, this._info.player_id, true)
			} else {
				contentHtml = this._info.msg
			}
			// this.empty = this.empty.gsub("@@", this.title.text)
			this.empty = this.empty.replace("@@", this.title.text)
			// let text = this.empty + this.data.name + "："
			// let length = ChatModel.GetInstance().getLength(text)
			// let font_num = text.length - length * 0.5 / 0.5
			// this._img_trumpet.x = this.contentLabel.size / 2 * font_num
			let trumpet_empty = ""
			// if (Util.GetDeviceOS() == DEVICE_OS.WINDOWS_PC ) {
			// 	trumpet_empty = "   "
			// }else{
			// 	trumpet_empty = "      "
			// }
			this.msg = "<font color='" + color + "'>"  + this.data.name + "：" + "<f_horn.length>" + trumpet_empty + "</font>" + contentHtml
		} else if (channel == local_CHAT_TYPE.WORLD || channel == local_CHAT_TYPE.TEAM || channel == local_CHAT_TYPE.CAMP || channel == local_CHAT_TYPE.SEA || table.find(ChatModel.SPECIAL_CHANNEL, channel) != -1) {
			// this.title.text = title
			// this.titleBg.source = src
			// ResManager.GetInstance().SetImageSprite(this, this.titleBg, "mainUI_asset", src)
			// this.empty = this.empty.gsub("@@", this.title.text)
			// this.empty = string.gsub(this.empty, "@@", this.title.text)
			let contentHtml = ""
			if (this.data.result == 1) {
				contentHtml = ChatModel.GetInstance().disposeChtaGoods(this._info.msg, this._info, this._info.player_id, true)
			} else {
				contentHtml = this._info.msg
			}
			if (this.data.name) {
				this.msg = "<font color='" + color + "'>" + this.empty + this.data.name + "：</font>" + contentHtml
			} else {
				this.msg = "<font color='" + color + "'>" + this.empty + "</font>" + contentHtml
			}
			// this.msg = this._info.msg
		} else if (channel == local_CHAT_TYPE.GUILD) {
			// this.titleBg.source = "mainUI_json.mainUI_chat_3_png"
			// ResManager.GetInstance().SetImageSprite(this, this.titleBg, "mainUI_asset", "mainUI_chat_3")
			// this.title.text = "结社"
			// this.empty = this.empty.gsub("@@", this.title.text)
			// // [ts2lua]lua中0和空字符串也是true，此处this.data.position != 0需要确认
			let positionName = (this.data.position != 0 && (WordManager.GetGuildPosName(this.data.position)) || (""))
			let contentHtml = ""
			if (this.data.result == 1) {
				contentHtml = ChatModel.GetInstance().disposeChtaGoods(this._info.msg, this._info, this._info.player_id, true)
			} else {
				contentHtml = this._info.msg
			}
			if (!this.data.chuanwen) {
				this.msg =`<font color='#D85051'>${this.empty}${this.data.name}[${positionName}]:</font>${contentHtml}`
				// "<font color='" + ColorUtil.GetColorLight(ColorType.PURPLE) + "'>" + this.empty + this.data.name + "[" + positionName + "]：</font>" + contentHtml
			} else {
				this.msg = `<font color='#D85051'>${this.empty}</font>${contentHtml}`
				//"<font color='" + ColorUtil.GetColorLight(ColorType.PURPLE) + "'>" + this.empty + "</font>" + contentHtml
			}
		} else {
			//GameError:GetInstance():SendErrorToPHP("主界面聊天不显示的频道" + channel + "内容：" + this._info.msg, true)
		}
		this.msg = ChatModel.GetInstance().FormatColorTag(this.msg)
		// this.msg = ChatModel.GetInstance().FormatLinkTag(this.msg)
		// this.contentLabel.textFlow = Util.StrToHTML(this.msg)
		this.contentLabel.style.fontSize=36
		this.contentLabel.scale(0.5, 0.5)
		this.contentLabel.style.color="#FFFFFF"
		// this.contentLabel.style.wordWrap=true
		//喇叭暂且这样处理：<f_horn.length>
		this.msg=this.msg.replace("<f_horn.length>","")
		//处理超链接
		// this.msg=this.msg.replace("<a@","<a href='@")
		// this.msg=this.msg.replace("@>","@'>")
		//处理文字字符
		//添加频道名
		///		"<font color='#FFFFFF'>系统</font><font color='#60aeff'>萨拉卢修斯</font>成功将<font color='#ff9015'>卫士武魂</font>提升至<font color='#ff4f50'>红色</font>,百分比属性大幅提升!<font color='#b3ff48'><a@open_fun@181>我也想要</a></font>"

		// if(ChatModel.IsChieseSymbol("：")){
		// 	console.log(true)
		// }
		this.msg=/**src+*/"<font color='#FFFFFF'>"+"&nbsp;"+"</font>"+this.msg
		let sys_tag= "<img src='resource/game/mainUI/texture/" + src + ".png' style='width:" + 108 + "px; height:" + 50 + "px'/>"
		this.msg=sys_tag+ChatModel.GetInstance().disposeChtaFace(this.msg,68,44,36, null, 2)
		// this.msg="<font color='#FFFFFF'>系统</font><font color='#60aeff'>萨拉卢修斯</font>成功将<font color='#ff9015'>卫士武魂</font>提升至<font color='#ff4f50'>红色</font>,百分比属性大幅提升!<font color='#b3ff48'><a@open_fun@181>我也想要</a></font>"
		// this.msg=ChatModel.GetInstance().disposeChtaFace(this.msg,18,12,18,307)
		this.contentLabel.innerHTML = this.msg
		this.contentLabel.style.width = this.contentLabel.width = 310 * 2
		let contextHeight = this.contentLabel.contextHeight * 0.5
		this.contentLabel.height = contextHeight + 5
		this._gp_content.height = contextHeight + 5
		this.display_obj.height=this._gp_content.height
		if (this.data.iType == ChatModel.MSG_TYPE.VOICE) {
			this.msg = "<font color='" + color + "'>" + this.data.name + "：[语音信息]</font>"
		}
		// this.contentLabel.on(Laya.Event.LINK,this, (text?)=>{
		// 	ChatModel.GetInstance().LinkEvtInChatItem(text)
		// });
		// SetInlineText(this.contentLabel, Trim(this.msg), null, null, true)
		// SetInlineText(this.contentLabel,..(" - " + many_non_breaking_space)Trim(this.msg), null, null, true)
		// AddInlineLickEvent(this.contentLabel, (param_list?) => {
		// 	this.is_click_link = true
		// })
		// TimerQuest.AddDelayQuest(GlobalTimerQuest,() => {
		// 	if (this.contentLabel ) {
		// 		if (this.contentLabel.CheckFirstLineHasFace() ) {
		// 			SetLocalPositionY(this._gp_title, -34)
		// 		}else{
		// 			SetLocalPositionY(this._gp_title, -15.3)
		// 		}
		// 	}
		// }, 0)

		if (this.is_last_msg) {
			// GlobalEventSystem.FireNextFrame(ChatModelEvent.KEEP_MAINUICHATVIEW_MSG_NEW)
		}
		if(this.scroller){
			this.scroller.vScrollBar.value=this.self_parent.displayHeight
		}
		MainUIModel.GetInstance().Fire(MainUIModel.UPDATE_MAINUI_CHAT_VIEW)
		// let first_line_has_face = ChatModel.GetInstance().disposeChtaFace(this.msg, this.contentLabel.text, this.contentLabel, this._gp_content, this.faceList, 2.5, 2, 7)
		// if (! this._img_trumpet ) {
		// 	return
		// }
		// if (first_line_has_face ) {
		// 	this._gp_title.y = 25
		// 	this._img_trumpet.y = 12
		// 	if (this._img_trumpet.visible ) {
		// 		this._gp_content.y = 0
		// 		this._gp_title.y = 16
		// 	}
		// }else{
		// 	this._gp_title.y = 6
		// 	this._img_trumpet.y = 2
		// }
		// }
	}



	_Group1: Laya.Box
	_gp_title: Laya.Box
	titleBg: Laya.Image
	title: Laya.Label
	_gp_content: Laya.Box
	contentLabel: Laya.HTMLDivElement
	_img_trumpet: Laya.Image
	public GetComponents() {
		[
			this._Group1,
			this._gp_title,
			this.titleBg,
			this.title,
			this._gp_content,
			this.contentLabel,
			this._img_trumpet,
		]
			= this.GetChildrenByNames([

				"_Group1",
				"_gp_title",
				"titleBg",
				"title",
				"_gp_content",
				"contentLabel",
				"_img_trumpet",
			])
		this.contentLabel.style.leading = 5;
		this.title.fontSize = 2 * this.title.fontSize;
		this.title.scale(0.5, 0.5);
	}
}
window["MainUIChatItem"] = MainUIChatItem
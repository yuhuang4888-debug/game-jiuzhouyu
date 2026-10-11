import { Alert, Alert_Type } from "../alert/Alert"
import { BaseView1, OpenMode } from "../common/BaseView1"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { LuaSoundManager } from "../common/SoundManager"
import { table } from "../common/table"
import { ChatModel, ChatModelEvent, CHAT_TYPE, TRUMPET_TYPE } from "../commonModel/ChatModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { PlatformManager } from "../PlatformManager"
import { RoleManager } from "../commonModel/RoleManager"
import { SceneManager } from "../scene/SceneManager"
import { Message } from "../sysInfo/SysInfoController"
import { Enum_ColorUtil_Dark } from "../util/ColorUtil"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { Util, HtmlColorTxt } from "../util/Util"
import { Vector2 } from "../util/Vector2"

export class ChatTrumpetView extends BaseView1 {
	InitEvent
	LoadSuccess
	_btn_send
	_input
	_lb_font_num
	background_alpha
	changeNum
	click_bg_toClose
	close_callback
	destroy_imm
	faceBtn
	horizontalCenter
	initTextField
	model
	open_mode
	preload_server_config
	tipsVisible
	updateGoods
	use_background
	use_local_view
	verticalCenter

	///
	_btn_close
	_bag
	_img_bag_select
	t_gp_menu
	_lb_tips
	_bg
	_lb_num
	_lb_type
	_gp_text_input
	_Group1: Laya.Box
	_Image11: Laya.Image
	_Image2: Laya.Image
	_Image3: Laya.Image
	_Image4: Laya.Image
	_Image1: Laya.Image
	labelDisplay: Laya.Label
	_Group2: Laya.Box
	_Image5: Laya.Image
	_Image6: Laya.Image
	_Label1: Laya.Label
	_Image7: Laya.Image
	_Image8: Laya.Image
	Placeholder: Laya.Label
	Text: Laya.Label

	///
	public constructor() {
		super()

		this.base_file = "chat"
		this.layout_file = "ChatTrumpetView"
		this.layer_value = Enum_UILayer.Activity
		this.open_mode = OpenMode.OpenToggle
		this.destroy_imm = true
		this.use_background = true
		this.click_bg_toClose = true
		// this.use_local_view = true
		this.background_alpha = 1
		this.horizontalCenter = 0
		this.verticalCenter = -200
		this.model = ChatModel.GetInstance()
		let local_ChatModelEvent = ChatModelEvent
		let local_laya = Laya

		let _model = ChatModel.GetInstance()
		let need_num = null
		let need_type_id = null
		let need_cost = null
		let _channel = CHAT_TYPE.TRUMPET
		let kv_cfgs = null
		let shop_cfgs = null
		let select_trumpet_type = TRUMPET_TYPE.WORLD
		let font_max = 30
		this.load_callback = () => {

			this.InitEvent()
			this.LoadSuccess()
			// this.form.anchoredPosition = new Vector2(0, 600)
			// this.x=0;
			// this.y=600
		}

		this.close_callback = () => {
			GlobalEventSystem.Fire(EventName.CLOSE_VIEW, "ChatTrumpetMenu")
		}

		this.preload_server_config = { "config_horn_kv": false, "config_shop": false,"config_goods_price": false }
		this.InitEvent = () => {
			this._gp_text_input.on(Laya.Event.CHANGE,this,()=>{
				if (this._gp_text_input.text.length  <= this._gp_text_input.maxChars) {
					this._gp_text_input.text = this._gp_text_input.text 
				} else {
					Message.show("单条信息不超过" + String(this._gp_text_input.maxChars) + "字")
				}
			})
			this._gp_text_input.on(Laya.Event.INPUT,this,()=>{
				if (this._gp_text_input.text.length  <= this._gp_text_input.maxChars) {
					this._gp_text_input.text = this._gp_text_input.text 
				} else {
					Message.show("单条信息不超过" + String(this._gp_text_input.maxChars) + "字")
				}
			})
			Util.AddClickEvent(this._btn_send, () => {
				let send_msg = () => {
					if(this.use_delete_method) return
					let msg = this._input.text
					if (msg == "") {
						Message.show("请输入聊天内容!")
						return
					}
					let scene_info = SceneManager.GetInstance().scene_Info
					if (!scene_info) {
						return
					}
					let roleVo = RoleManager.GetInstance().GetMainRoleVo()
					let channel = _channel
					let [sendGoods, goods_id_list, sendGoodsMesg] = _model.sendGoodsMesg(msg)
					// if (ChatModel.SPECIAL_CHANNEL.find(_channel) != -1 && goods_id_list.length > 0 ) {
					if (table.find(ChatModel.SPECIAL_CHANNEL, _channel) != -1 && goods_id_list.length > 0) {
						_model.Fire(local_ChatModelEvent.SEND_SPECIAL_CHANNEL_GOODS, _channel, goods_id_list)
					}
					_model.Fire(local_ChatModelEvent.CHAT_SEND_MSG, 11001, channel, roleVo.province, roleVo.city, select_trumpet_type, sendGoodsMesg, sendGoods, 0, "")

					// console.log("content", msg)
					// let tmpArgs = this.model.GetAllArgsText(msg)
					// console.log("tmpArgs", tmpArgs)
					// msg = this.model.GetHyperlinkText(msg)
					// console.log("GetHyperlinkText", msg)
					// _model.Fire(local_ChatModelEvent.CHAT_SEND_MSG, 11001, channel, roleVo.province, roleVo.city, select_trumpet_type, msg, tmpArgs, 0, "")
					this.Close()
				}

				let goods_num = GoodsModel.GetInstance().GetTypeGoodsNum(need_type_id)
				if (goods_num < need_num) {
					let cur = need_num - goods_num
					let con = "发送喇叭需要消耗" + HtmlColorTxt(need_num, Enum_ColorUtil_Dark.GREEN) + "个喇叭道具，现缺少" + HtmlColorTxt(cur, Enum_ColorUtil_Dark.RED) + "个，是否用" + HtmlColorTxt(cur * need_cost, Enum_ColorUtil_Dark.RED) + "勾玉补足？"
					Alert.Show(Util.StrToHTML(con), Alert_Type.Two, send_msg)
				} else {
					send_msg()
				}
			}
				, this, true)
			Util.AddClickEvent(this._btn_close, () => {
				this.Close()
			}
				, this, true, null, null, null, null, LuaSoundManager.SOUND_UI.CLOSE)
			Util.AddClickEvent(this._bag, (e?) => {
				_model.selectChannel = _channel
				// _model.Fire(local_ChatModelEvent.OPENBAGPANEL, this._bag.localToGlobal(), true)
				_model.Fire(local_ChatModelEvent.OPENBAGPANEL, this._bag.localToGlobal(new Laya.Point(0,0),true))
				// e.stopImmediatePropagation()
			}
				, this, true)
			Util.AddClickEvent(this.t_gp_menu, () => {
				_model.Fire(local_ChatModelEvent.OPEN_TRUMPET_MENU, "ChatTrumpetMenu",this.t_gp_menu.localToGlobal(new Laya.Point(0,0)))

				// GlobalEventSystem.Fire(EventName.OPEN_VIEW, "ChatTrumpetMenu", this._gp_menu.localToGlobal())
				// GlobalEventSystem.Fire(EventName.OPEN_VIEW, "ChatTrumpetMenu", new Vector2(-83.8, 625.1))
			}
				, this, true)
			this.BindEvent(_model, local_ChatModelEvent.CHAT_BAG_OPEN, (bool?, Channel?) => {
				if (_channel == Channel) {
					this._img_bag_select.visible = bool
				}
			}
			)
			Util.AddClickEvent(this.faceBtn, (target?, x?, y?) => {
				_model.selectChannel = _channel
				// _model.Fire(local_ChatModelEvent.OPENTOOLPANEL, this.faceBtn.localToGlobal(), true)
				let point=this.faceBtn.localToGlobal(new Laya.Point(0,0),true)
				point.x=point.x+500
				point.y=point.y
				_model.Fire(local_ChatModelEvent.OPENTOOLPANEL, this.faceBtn.localToGlobal(new Laya.Point(0,0),true))
			}
				, this, true)
			let addFace = (...new_args) => {
				let args = new_args
				let face_str = "<f_" + args[0] + ">"
				if ((args[1] == _channel && face_str.length + this._input.text.length < this._input.maxChars) || this._input.maxChars == 0) {
					this._input.text = this._input.text + face_str
					// this.tipsVisible()
					// this.changeNum()
				} else {
					Message.show("单条信息不超过" + String(this._input.maxChars) + "字")
				}
			}
			this.BindEvent(_model, local_ChatModelEvent.ADD_FACE, addFace)

			let addGoods = (...new_args) => {
				let args = new_args
				// let goodVo = args[1]
				// let str = this.model.EncryMsgForGoodsItem(goodVo)
				let data = args[0]
				let goods_name = data.goods_name
				let name = "[" + goods_name + "]"
				if ((args[1] == _channel)) {
					if ((name.length + this._input.text.length < this._input.maxChars) || this._input.maxChars == 0) {
						let text:string=this._input.text
						let repetition = text.indexOf(name)
						if(repetition==-1){
							_model.setSendGoodsData(data, false)
						}else{
							_model.setSendGoodsData(data, true)
						}
						this._input.text = text + name
					} else {
						Message.show("单条信息不超过30字")
					}
					// let data = args[1]
					// let name = "[" + data.goods_name + "]"
					// let repetition = string.find(this._input.text, name) != -1
					// _model.setSendGoodsData(data, repetition)
					// this._input.text = this._input.text + name
					// this.tipsVisible()
					// this.changeNum()
					// this.model.ReplaceInputTextMark(this._input, str)
				}
			}
			this.BindEvent(_model, local_ChatModelEvent.ADD_BAG_GOODS, addGoods)
			this.BindEvent(_model, local_ChatModelEvent.SELECT_TRUMPET_TYPE, (type?) => {
				select_trumpet_type = type
				this.updateGoods()
			}
			)
		}

		this.LoadSuccess = () => {
			if (PlatformManager.IsEyouEnPlatform()) {
				this._lb_type.size = 16
			}
			ResManager.GetInstance().SetImageSpriteTrans(this, this._bg, GameResPath.GetIcon("chat", "bg_03"))
			// kv_cfgs = ResManager.GetInstance().GetGameConfigFromCache(this, "config_horn_kv", false)
			kv_cfgs = ResManager.GetInstance().GetGameConfigFromCache(this, "config_horn_kv", false)
			shop_cfgs = ResManager.GetInstance().GetGameConfigFromCache(this, "config_goods_price", false)
			this.initTextField()
			this.updateGoods()
		}

		this.updateGoods = () => {
			// [ts2lua]kv_cfgs下标访问可能不正确
			let list = JSON.parse(kv_cfgs["cost_goods"].value)
			// [ts2lua]list下标访问可能不正确
			// if (list[select_trumpet_type - 1] ) {
			if (list[select_trumpet_type-1]) {
				// [ts2lua]list下标访问可能不正确
				need_num = Number(list[select_trumpet_type-1][1][0][2])
				// [ts2lua]list下标访问可能不正确
				need_type_id = Number(list[select_trumpet_type-1][1][0][1])
				// [ts2lua]shop_cfgs下标访问可能不正确
				// [ts2lua]shop_cfgs下标访问可能不正确
				// [ts2lua]lua中0和空字符串也是true，此处shop_cfgs[need_type_id]需要确认
				need_cost = (shop_cfgs[need_type_id] && (shop_cfgs[need_type_id].price) || (0))
				this._lb_num.text = "x" + need_num
			}
			this._lb_type.text = _model.trumpetName(select_trumpet_type)
		}

		this.tipsVisible = () => {
			// this._lb_tips.visible = this._input.text == ""
			// this._lb_font_num.visible = this._input.text != ""
			this._lb_tips.visible = this._input.text == ""
			this._lb_font_num.visible = this._input.text != ""
		}

		this.initTextField = () => {
			// if (! this._input ) {
			// 	this._input = local_laya. new TextField()
			// 	this._input.x = 0
			// 	this._input.y = 0
			// 	this._input.width = 466
			// 	this._input.height = 115
			// 	this._input.type = Laya.TextFieldType.INPUT
			// 	this._input.size = 22
			// 	this._input.characterLimit = font_max
			// 	this._input.textAlign = Laya.HorizontalAlign.LEFT
			// 	this._input.verticalAlign = Laya.VerticalAlign.TOP
			// 	this._input.textColor = "#2E1F19"
			// 	this._input.multiline = true
			// 	this._input.lineSpacing = 10
			// 	this._gp_text_input.addChild(this._input)
			// 	this._input.addEventListener(Laya.FocusEvent.FOCUS_OUT,() => {
			// 			this.tipsVisible()
			// 		}
			// 		, this)
			// 	this._input.addEventListener(Laya.FocusEvent.FOCUS_IN,() => {
			// 			this._lb_tips.visible = false
			// 			this._lb_font_num.visible = true
			// 		}
			// 		, this)
			// 	this._input.addEventListener(Laya.Event.CHANGE,() => {
			// 			this.changeNum()
			// 		}
			// 		, this)
			// }
			// this._input = this.GetChild("_gp_text_input").GetComponent("InputField")
			this._input = this._gp_text_input
		}

		this.changeNum = () => {
			this._input.text = this._input.text.replace('\n', "")
			this._lb_font_num.text = Math.min(this._input.text.length, font_max) + "/" + font_max
		}
	}

	public GetComponents() {
		[
			this._bg,
			this._btn_close,
			this._Group1,
			this._Image11,
			this._Image2,
			this._Image3,
			this._Image4,
			this.faceBtn,
			this._btn_send,
			this._Image1,
			this.labelDisplay,
			this._lb_tips,
			this._Group2,
			this._Image5,
			this._lb_num,
			this._bag,
			this._Image6,
			this._Label1,
			this._img_bag_select,
			this.t_gp_menu,
			this._Image7,
			this._Image8,
			this._lb_type,
			this._gp_text_input,
			this.Placeholder,
			this.Text,
			this._lb_font_num,
		]
			= this.GetChildrenByNames([

				"_bg",
				"_btn_close",
				"_Group1",
				"_Image11",
				"_Image2",
				"_Image3",
				"_Image4",
				"faceBtn",
				"_btn_send",
				"_Image1",
				"labelDisplay",
				"_lb_tips",
				"_Group2",
				"_Image5",
				"_lb_num",
				"_bag",
				"_Image6",
				"_Label1",
				"_img_bag_select",
				"t_gp_menu",
				"_Image7",
				"_Image8",
				"_lb_type",
				"_gp_text_input",
				"Placeholder",
				"Text",
				"_lb_font_num",
			])
	}
}

window["ChatTrumpetView"] = ChatTrumpetView
import { BaseItem1 } from "../common/BaseItem1"
import { Config } from "../common/Config"
import { CustomHeadItem } from "../common/CustomHeadItem"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { ChatModel, ChatModelEvent, CHAT_TYPE } from "../commonModel/ChatModel"
import { DressModel, DressType } from "../commonModel/DressModel"
import { MedalModel } from "../commonModel/MedalModel"
import { RoleManager } from "../commonModel/RoleManager"
import { ColorUtil, ColorType } from "../util/ColorUtil"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameMath } from "../util/GameMath"
import { Mathf } from "../util/Mathf"
import { Util, SetLocalScale, SetSizeDeltaX, SetAnchoredPosition, RefBoxChildsLayout } from "../util/Util"
import { Vector2 } from "../util/Vector2"
import { Vector3 } from "../util/Vector3"
import { ChatVoiceManager } from "./ChatVoiceManager"

export class ChatItem extends BaseItem1 {
	ReOpen_callback
	_jiantou_main
	_jiantou_player
	bind_play_voice
	click_menu_pos
	curr_sorting_order
	data
	head_main
	head_player
	is_delay_callback
	is_last_msg
	model
	needRefreshData
	//oneline_height
	send_player
	use_local_view
	voice_qipao_min_width
	qipao_expand_width = 70
	// let newline_size = 46

	mine
	LayoutCallBack

	public constructor(parent) {
		super(parent)

		this.base_file = "chat"
		this.layout_file = "ChatItem"
		this.layer_value = Enum_UILayer.UI
		// this.use_local_view = true
		this.model = ChatModel.GetInstance()
		this.is_delay_callback = true
		this.voice_qipao_min_width = 130 //语音气泡最小的长度
		this.mine = false
		// this.is_delay_callback = false


		this.ReOpen_callback = () => {
			// this.curr_sorting_order = this.AddCurrLayerSortingOrder(this.layer_value)
			if (this.send_player && this.data && this.data.title_id && this.data.title_id > 0) {
				let is_mine = RoleManager.GetInstance().GetMainRoleVo().role_id == this.send_player.player_id
				this.SetMedal(is_mine)
			}

		}

		this.load_callback = () => {
			// this.curr_sorting_order = this.AddCurrLayerSortingOrder(this.layer_value)
			this.LoadSuccess()

			if (this.needRefreshData) {
				this.UpdateItem()
				this.needRefreshData = null
			}
		}
	}


	public LoadSuccess() {
		// this._jiantou_main = this.btn_qipao_voice.transform.Find("img_jiantou").GetComponent("ImageExtend")
		// this._jiantou_player = this.btn_qipao_voice1.transform.Find("img_jiantou").GetComponent("ImageExtend")

		// this.head_main =  new PlayerHead(this.img_headicon.transform)
		this.head_main = new CustomHeadItem(this.img_headicon)
		this.head_main.Load()
		this.head_main.ExcuteCallback(() => {
			// this.head_main.SetAnchoredPosition(0, 0)
		})

		// this.head_player =  new PlayerHead(this.img_headicon1.transform)
		this.head_player = new CustomHeadItem(this.img_headicon1)
		this.head_player.SetClickFunc((target?, x?, y?) => {
			// let player_id = this.GetSenderPlayerId()
			// console.log("头像id", player_id, x, y)
			this.click_menu_pos = new Vector3(x, y, 0)
			let isPicture = Number(this.data.picture) == this.send_player.player_id
			this.model.Fire(ChatModelEvent.OPEN_CHAT_MENU, this.img_headicon1, this.send_player.player_id, this.send_player.ser_id, false, this.data, this.data.channel, null, isPicture)
		})
		this.head_player.Load()
		this.head_player.ExcuteCallback(() => {
			// this.head_player.SetAnchoredPosition(0, 0)
		})

		this.img_voice_img.visible = false
		this.img_voice_img1.visible = false

		// this.txt_content1.text = "<quad name=f_21 size=40 width=1.458333 height=1 />"
		// this.oneline_height = this.txt_content1.pre
		// this.txt_content1.text = "test"
		// this.oneline_height = Math.max(this.txt_content1.preferredHeight, this.oneline_height)
		this.txt_content1.text = ""

		this.InitEvent()
	}

	//获取消息发送者id
	public GetSenderPlayerId() {

		let player_id = this.data.player_id || (this.data.player_list && this.data.player_list[1].player_id)
		return player_id
	}

	public InitEvent() {

		let onClickBtnHandler = (target, x, y) => {
			console.log(target)
			if (target == this.btn_qipao_voice || target == this.btn_qipao_voice1) {
				let player_id = this.GetSenderPlayerId()
				let voice_vo = ChatVoiceManager.GetInstance().GetVoice(this.data.voice_id)
				let chat_voice_mgr = ChatVoiceManager.GetInstance()
				let playing_voice_id = chat_voice_mgr.playing_voice_id
				if (playing_voice_id) {
					//停掉正在播放的语音
					chat_voice_mgr.StopVoice(playing_voice_id)
					if (playing_voice_id != this.data.voice_id) {
						// console.log("播放语音", this.data.voice_id, player_id, this.data.time)
						this.model.Fire(ChatModelEvent.REQUEST_CCMD_EVENT, 11004, this.data.voice_id, player_id, this.data.time, "")
					}
				} else {
					// console.log("播放语音", this.data.voice_id, player_id, this.data.time)
					this.model.Fire(ChatModelEvent.REQUEST_CCMD_EVENT, 11004, this.data.voice_id, player_id, this.data.time, "")
				}
			} else if (target == this.img_voice_img) { //语音转文字按钮
				this.img_voice_txt.visible = true
				this.img_voice_img.visible = false
			} else if (target == this.img_voice_img1) {
				this.img_voice_txt1.visible = true
				this.img_voice_img1.visible = false
			}
		}
		Util.AddClickEvent(this.btn_qipao_voice, onClickBtnHandler, this)
		Util.AddClickEvent(this.img_voice_img, onClickBtnHandler, this)
		Util.AddClickEvent(this.btn_qipao_voice1, onClickBtnHandler, this)
		Util.AddClickEvent(this.img_voice_img1, onClickBtnHandler, this)
		Util.AddClickEvent(this.img_headicon1, onClickBtnHandler, this)

		//以下代码实现点击语音气泡按钮时，旁边的箭头一起变暗的效果
		// let onUpBtnHandler = (target?) => {
		// 	if (target == this.btn_qipao_voice ) {
		// 		this._jiantou_main.SetColor(Color(1, 1, 1, 1))
		// 	} else if (target == this.btn_qipao_voice1 ) {
		// 		this._jiantou_player.SetColor(Color(1, 1, 1, 1))
		// 	}
		// }
		// let onDownBtnHandler = (target?) => {
		// 	if (target == this.btn_qipao_voice ) {
		// 		this._jiantou_main.SetColor(Color(200 / 255, 200 / 255, 200 / 255, 1))
		// 	} else if (target == this.btn_qipao_voice1 ) {
		// 		this._jiantou_player.SetColor(Color(200 / 255, 200 / 255, 200 / 255, 1))
		// 	}
		// }
		// AddUpEvent(this.btn_qipao_voice, onUpBtnHandler)
		// AddDownEvent(this.btn_qipao_voice, onDownBtnHandler)
		// AddUpEvent(this.btn_qipao_voice1, onUpBtnHandler)
		// AddDownEvent(this.btn_qipao_voice1, onDownBtnHandler)

		// let ui = GameObject.Find("root/Canvas/UI")
		// let camera = ui.GetComponent("Canvas").worldCamera
		// let changeColor =(transform, pos, img_extend)=> {
		// 	let bool = UnityEngine.RectTransformUtility.RectangleContainsScreenPoint(transform, pos, camera)
		// 	if (bool ) {
		// 		img_extend.SetColor(Color(200 / 255, 200 / 255, 200 / 255, 1))
		// 	}else{
		// 		img_extend.SetColor(Color(1, 1, 1, 1))
		// 	}
		// }

		// let onDrag =(target, pos_x, pos_y)=> {
		// 	if (target == this.btn_qipao_voice ) {
		// 		changeColor(target.transform, Vector2(pos_x, pos_y), this._jiantou_main)
		// 	} else if (target == this.btn_qipao_voice1 ) {
		// 		changeColor(target.transform, Vector2(pos_x, pos_y), this._jiantou_player)
		// 	}
		// }
		// AddDragEvent(this.btn_qipao_voice, onDrag)
		// AddDragEvent(this.btn_qipao_voice1, onDrag)

		this.BindEvent(this.model, ChatModelEvent.STOP_VOICE_PLAY, (voice_id?) => {
			if (this.data && this.data.voice_id == voice_id) {
				console.log("停止播放语音", this.data.voice_id)
			}
		})
	}

	public SetData(data?, is_last_msg?) {

		this.data = data
		this.is_last_msg = is_last_msg
		if (this.is_loaded) {
			this.UpdateItem()
		} else {
			this.needRefreshData = true
		}
	}

	public GetData() {
		return this.data 
	}


	public UpdateItem() {
		let data = this.data
		if (data) {
			this.test.style.leading = 5
			this.test2.style.leading = 5
			this.mainRoleCon.visible = false
			this.playerRoleCon.visible = false
			this.img_voice_txt.visible = false
			this.img_voice_txt1.visible = false

			let main_role_vo = RoleManager.GetInstance().GetMainRoleVo()
			let send_player = (data.player_list && data.player_list[1]) || data
			this.send_player = send_player
			let ser_name
			if (table.find(ChatModel.SPECIAL_CHANNEL, this.data.channel) != -1) {
				ser_name = data.server_num || send_player.server_num || ""
				ser_name = "<font color=" + ColorUtil.GetColorDark(ColorType.GREEN) + ">S" + ser_name + ".</font>"
				// ser_name = data.c_server_msg || send_player.c_server_msg || ""
				// ser_name = ser_name.replace(/[`~!@#$%^&*()_\-+=<>?:"{}|,.\/;'\\[\]·~！@#￥%……&*（）——\-+={}|《》？：“”【】、；‘’，。、 ]/ig, "")
				// ser_name = "<font color=" + ColorUtil.GetColorDark(ColorType.GREEN) + ">" + ser_name + ".</font>"
			}
			let msg = data.msg
			if (this.data.result == 1) {
				msg = this.model.disposeChtaGoods(data.msg, this.data, this.data.player_id);
			}
			// msg = DeleteHTMLSign(msg, true)
			// msg=msg.replace("<a@","<a href='@")
			// msg=msg.replace("@>","@'>")
			msg = this.model.FormatColorTag(msg, false)
			msg = this.model.changeToDark(msg)
			// msg = this.model.FormatLinkTag(msg)
			if (send_player && send_player.player_id == main_role_vo.role_id) {
				this.mainRoleCon.visible = true
				this.img_qipao1.visible = data.iType != ChatModel.MSG_TYPE.VOICE
				this.btn_qipao_voice.visible = data.iType == ChatModel.MSG_TYPE.VOICE
				this.txt_name.style.color = "#4a3a32"
				this.txt_name.style.fontSize = 20
				if (table.find(ChatModel.SPECIAL_CHANNEL, this.data.channel) != -1) {
					this.txt_name.innerHTML = ser_name + main_role_vo.name
				} else {
					this.txt_name.innerHTML = main_role_vo.name
				}
				this.txt_name.width = 500
				this.txt_lv1.text = main_role_vo.level + "";
				if (data.iType == ChatModel.MSG_TYPE.HORN) {
					ResManager.GetInstance().SetImageSprite(this, this.img_qipao1_img, "chat_asset", "trumpet2")
					this.img_qipao1_img.sizeGrid = "35,67,35,58"
				} else if (data.iType == ChatModel.MSG_TYPE.TEXT || data.iType == undefined) {
					let frame_id = DressModel.GetInstance().GetDressByType(main_role_vo.dress_list, DressType.Bubble)
					if (frame_id) {
						ResManager.GetInstance().SetImageSprite(this, this.img_qipao1_img, "chat", "1_" + frame_id + "_1")
						this.img_qipao1_img.sizeGrid = "34,68,36,76"
					} else {
						ResManager.GetInstance().SetImageSprite(this, this.img_qipao1_img, "chat_asset", "chat_contentbg2")
						this.img_qipao1_img.sizeGrid = "40,37,27,29"
					}
					// ResManager.GetInstance().SetImageSprite(this, this.img_qipao1_img, "chat_asset", "chat_contentbg2")
				}
				if (data.iType != ChatModel.MSG_TYPE.VOICE) {
					// SetInlineText(this.txt_content1, msg, null, true)
					this.txt_content1.text = msg
					this.test.style.color = "#411d00"
					this.test.style.fontSize = 20
					// this.test.style.wordWrap=true
					// let testmsg=ChatModel.GetInstance().replaceChatFace("我我我我我我我我我<f_1>aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
					msg = ChatModel.GetInstance().disposeChtaFace(msg, 70, 48, 20)
					if (ChatModel.IsChinese("我")) {
						console.log(true)
					}
					this.test.innerHTML = msg
					this.test.width = 363
					if (this.test.contextWidth < 363) {
						this.test.x = 363 - this.test.contextWidth
					}
					this.mine = true
					// AddInlineLickEvent(this.txt_content1,(param_list?) => {
					// 		console.log("点击", param_list)
					// 		// this.CilckContentHandle(param_list)
					// 	})
				} else if (data.iType == ChatModel.MSG_TYPE.VOICE) {
					// this.txt_main_voice_time.text = string.format("%d\"", data.length)
					//this.txt_main_voice_time.text = String(data.length) + "\""
					this.txt_content11.text = msg
				}
				this.SetVip(true,send_player.player_id)
				this.SetMedal(true)
				// PrintTable(send_player)
				let frame_id = DressModel.GetInstance().GetDressByType(main_role_vo.dress_list, DressType.Photo)
				// this.head_main.setData(main_role_vo.level, main_role_vo.career, main_role_vo.picture, null,null,frame_id)
				this.head_main.SetRoleVoData(main_role_vo)
			} else if (send_player && send_player.player_id != main_role_vo.role_id) {
				this.playerRoleCon.visible = true
				this.img_qipao.visible = data.iType != ChatModel.MSG_TYPE.VOICE
				this.btn_qipao_voice1.visible = data.iType == ChatModel.MSG_TYPE.VOICE
				this.txt_name1.style.color = "#4a3a32"
				this.txt_name1.style.fontSize = 20
				if (table.find(ChatModel.SPECIAL_CHANNEL, this.data.channel) != -1) {
					this.txt_name1.innerHTML = ser_name + send_player.name
				} else {
					this.txt_name1.innerHTML = send_player.name
				}
				this.txt_name1.width = 500
				this.txt_lv.text = send_player.level
				if (data.iType == ChatModel.MSG_TYPE.HORN) {
					ResManager.GetInstance().SetImageSprite(this, this.img_qipao_img, "chat_asset", "trumpet")
					this.img_qipao_img.sizeGrid = "35,67,35,58"
				} else if (data.iType == ChatModel.MSG_TYPE.TEXT || data.iType == undefined) {
					let frame_id = DressModel.GetInstance().GetDressByType(send_player.dress_list, DressType.Bubble)
					if (frame_id) {
						ResManager.GetInstance().SetImageSprite(this, this.img_qipao_img, "chat", "1_" + frame_id + "_0")
						this.img_qipao_img.sizeGrid = "34,68,36,76"
					} else {
						ResManager.GetInstance().SetImageSprite(this, this.img_qipao_img, "chat_asset", "chat_contentbg1")
						this.img_qipao_img.sizeGrid = "40,30,27,41"
					}
					// ResManager.GetInstance().SetImageSprite(this, this.img_qipao_img, "chat_asset", "chat_contentbg1")
				}

				if (data.iType != ChatModel.MSG_TYPE.VOICE) {
					// SetInlineText(this.txt_content111, msg, null, true)
					this.txt_content111.text = msg
					this.test2.style.color = "#411d00"
					this.test2.style.fontSize = 20
					// this.test.style.wordWrap=true
					msg = ChatModel.GetInstance().disposeChtaFace(msg, 70, 48, 20)
					this.test2.innerHTML = msg
					this.test2.width = 363
					this.test2.x = 0
					this.mine = false
					// AddInlineLickEvent(this.txt_content111,(param_list?) => {
					// 	})
				} else if (data.iType == ChatModel.MSG_TYPE.VOICE) {
					//this.txt_player_voice_time.text = String(data.length) + "\""
					this.txt_content.text = msg
				}
				let frame_id = DressModel.GetInstance().GetDressByType(send_player.dress_list, DressType.Photo)
				// this.head_player.setData(send_player.level, send_player.career, send_player.picture,null,null,frame_id)
				this.head_player.SetRoleVoData(send_player)
				this.SetVip(false,send_player.player_id)
				this.SetMedal(false)

				// this.txt_content111.text = "<u>哈哈哈哈</u>啊啊啊啊啊哦哦哦哦哦额鹅鹅鹅<u>电饭锅电饭锅</u>"
				// AddUnderLineAndClick(this, this.txt_content111.transform)
			}
			this.SetTitle()
			this.test.on(Laya.Event.LINK, this, (text?) => {
				this.model.LinkEvtInChatItem(text)
			});
			this.test2.on(Laya.Event.LINK, this, (text?) => {
				this.model.LinkEvtInChatItem(text)
			});
			this.Layout()
			if (this.is_last_msg) {
				GlobalEventSystem.Fire(ChatModelEvent.KEEP_CHATVIEW_MSG_NEW)
			}
		}
	}

	public Layout() {
		let deal_list = [2,3,4,6,28,29,30,31,32]
		if (this.mine) {
			let bg_width = 0
			let bg_height = 0
			if (this.test.contextHeight == 20) {
				this.display_obj.height = 105
			} else if (this.test.contextHeight == 45) {
				this.display_obj.height = 125
			}
			else if (this.test.contextHeight == 73) {
				this.display_obj.height = 145
			} else if (this.test.contextHeight == 101) {
				this.display_obj.height = 175
			} else if (this.test.contextHeight == 48) {
				this.display_obj.height = 125
			} else if (this.test.contextHeight == 24) {
				this.display_obj.height = 125
			} else {
				this.display_obj.height = 105
			}
			bg_height = this.test.contextHeight + 30
			bg_width = 60 + this.test.contextWidth
			if (bg_height < 35) {
				bg_height = 45
			}
			if (bg_width < 65) {
				bg_width = 65
			}
			this.display_obj.height += 15
			this.img_qipao1_img.width = bg_width
			this.img_qipao1_img.height = bg_height
			if (this.data.iType && (this.data.iType == ChatModel.MSG_TYPE.HORN || DressModel.GetInstance().GetDressByType(RoleManager.GetInstance().GetMainRoleVo().dress_list, DressType.Bubble))) {//使用气泡或者喇叭的时候
				// this.display_obj.height += 20
				// this.img_qipao1_img.width += 15
				// this.img_qipao1_img.height += 30
				// this.img_qipao1_img.right -= 12
				// this.img_qipao1_img.top -= 15
			}
			let num = DressModel.GetInstance().GetDressByType(RoleManager.GetInstance().GetMainRoleVo().dress_list, DressType.Bubble)
			if(deal_list.indexOf(num)!=-1||this.data.iType == ChatModel.MSG_TYPE.HORN) {
				this.img_qipao1_img.height += 10
				this.img_qipao1_img.top = 30
			}
			if (RoleManager.GetInstance().GetMainRoleVo().dress_list) {
				let frame_id = DressModel.GetInstance().GetDressByType(RoleManager.GetInstance().GetMainRoleVo().dress_list, DressType.Photo)
				if (frame_id) {
					this.display_obj.height += 10
				}
			}
		} else {
			let bg_width2 = 0
			let bg_height2 = 0
			if (this.test2.contextHeight == 20) {
				this.display_obj.height = 105
			} else if (this.test2.contextHeight == 45) {
				this.display_obj.height = 125
			}
			else if (this.test2.contextHeight == 73) {
				this.display_obj.height = 145
			} else if (this.test2.contextHeight == 101) {
				this.display_obj.height = 175
			} else if (this.test2.contextHeight == 53) {
				this.display_obj.height = 125
			} else if (this.test2.contextHeight == 24) {
				this.display_obj.height = 125
			} else {
				this.display_obj.height = 105
			}
			this.display_obj.height += 15
			bg_height2 = this.test2.contextHeight + 30
			bg_width2 = 60 + this.test2.contextWidth
			if (bg_height2 < 35) {
				bg_height2 = 45
			}
			if (bg_width2 < 65) {
				bg_width2 = 65
			}

			this.img_qipao_img.width = bg_width2
			this.img_qipao_img.height = bg_height2

			// this.img_qipao_img.width=bg_width2
			// this.img_qipao_img.height=bg_height2
			if (DressModel.GetInstance().GetDressByType(this.send_player.dress_list, DressType.Bubble) || DressModel.GetInstance().GetDressByType(this.send_player.dress_list, DressType.Bubble)) {//使用气泡或者喇叭的时候
				// this.display_obj.height += 20
				// this.img_qipao_img.width += 10
				// this.img_qipao_img.height += 30
				this.img_qipao_img.left -= 7
				let num = DressModel.GetInstance().GetDressByType(this.send_player.dress_list, DressType.Bubble)
				if(deal_list.indexOf(num)!=-1||this.data.iType == ChatModel.MSG_TYPE.HORN) {
					this.img_qipao_img.height += 10
					this.img_qipao_img.top -= 10
				}
			}
			if (this.send_player.dress_list) {
				let frame_id = DressModel.GetInstance().GetDressByType(this.send_player.dress_list, DressType.Photo)
				if (frame_id) {
					this.display_obj.height += 10
					this.img_qipao_img.left += 5
				}
			}
		}

		if (this.LayoutCallBack) {
			this.LayoutCallBack(this.display_obj.height)
		}

	}

	public SetVip(is_mine?,player_id?) {
		let str_vip
		if (this.data.vip_flag == null) {
			return
		}
		let do_not_show_vip = table.find(ChatModel.DO_NOT_SHOW_VIP_CHANNEL, this.data.channel) != -1 || this.data.channel == CHAT_TYPE.TRUMPET
			&& table.find(ChatModel.DO_NOT_SHOW_VIP_TRUMPET, this.data.horn_type) != -1
		let vip_Lv = this.data.vip_flag
		let is_show_vip = vip_Lv > 0 && !do_not_show_vip 
		let vip_hide_state = this.data.is_hide_vip 
		if(vip_hide_state > 0){ 	//隐藏vip等级
			str_vip = "VIP-x"
			if (this.data.supreme_vip == 1) {
				str_vip = "SVIP-x"
			}
		}
		else{						//不隐藏vip等级
			str_vip = "uivip_zjm_" + vip_Lv
			if (this.data.supreme_vip == 1) {
				str_vip = "VIP_" + vip_Lv
			}
		}
		SetLocalScale(this.vip_di, 1.1, 1.1, 1)
		SetLocalScale(this.vip_di1, 1.1, 1.1, 1)
		if (is_mine) {
			this.vip_di.visible = is_show_vip
			ResManager.GetInstance().SetImageSprite(this, this.vip_di, "mainUI", str_vip)
			if (this.data.supreme_vip == 1) {
				SetLocalScale(this.vip_di, 1.6, 1.6, 1)

			}
		} else {
			this.vip_di1.visible = is_show_vip
			ResManager.GetInstance().SetImageSprite(this, this.vip_di1, "mainUI", str_vip)
			if (this.data.supreme_vip == 1) {
				SetLocalScale(this.vip_di1, 1.6, 1.6, 1)
			}
		}
	}



	//优先显示天境头衔
	public SetMedal(is_mine?) {
		this.ClearUIEffect(this.effect_touxian)
		this.effect_touxian.width = 0
		if (this.data.title_id && this.data.title_id != 0) {
			this.img_medal.visible = false
			this.img_medal1.visible = false
			this.effect_touxian1.visible = is_mine
			this.effect_touxian.visible = !is_mine
			let id = this.data.title_id
			let cfgs = ResManager.GetInstance().GetGameConfigFromCache(this, "ClientTitleNameBordWidth", true)
			let title_cfg = cfgs[id]
			let config_title_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_title_cfg", false)
			let infos = MedalModel.GetInstance().GetTitleInfo()
			let cfg = config_title_cfg && config_title_cfg[id + "@0"]
			if (cfg && title_cfg) {

				let eff_id = this.data.title_id - 1000
				let w = 80
				let pos
				let scale = 8
				if (title_cfg) {
					w = title_cfg.width
					scale = title_cfg.scale
					if (eff_id <= 5) {
						pos = { x: -2, y: 0 }
					} else {
						pos = { x: 0, y: 0 }
					}
				}

				let eff_url = MedalModel.GetInstance().GetTitleEffetName(eff_id)

				if (is_mine) {
					SetSizeDeltaX(this.effect_touxian1, w)
					this.AddUIEffect(eff_url, this.effect_touxian1, pos, scale, true)
				} else {
					SetSizeDeltaX(this.effect_touxian, w)
					this.AddUIEffect(eff_url, this.effect_touxian, pos, scale, true)
				}

			}
		} else {
			this.effect_touxian1.visible = false
			this.effect_touxian.visible = false
			if (!this.data.medal_id) {
				return
			}
			let is_show = this.data.medal_id > 1
			let cfgs1 = ResManager.GetInstance().GetGameConfigFromCache(this, "config_medal", false)
			let cfg = cfgs1[this.data.medal_id]
			let img_medal
			if (is_mine) {
				this.img_medal.visible = is_show
				img_medal = this.img_medal
			} else {
				this.img_medal1.visible = is_show
				img_medal = this.img_medal1
			}
			if (cfg && cfg.title && cfg.title != 0) {
				ResManager.GetInstance().SetImageSprite(this, img_medal, "mainUI_asset", "tx_" + cfg.title + "")
			}
		}


	}

	//清除界面
	public DeleteMe() {

		if (this.bind_play_voice) {
			this.model.UnBind(this.bind_play_voice)
			this.bind_play_voice = null
		}
		if (this.head_main) {
			this.head_main.DeleteMe()
			this.head_main = null
		}
		if (this.head_player) {
			this.head_player.DeleteMe()
			this.head_player = null
		}
		super.DeleteMe()
	}

	public SetTitle() {


		// if (this.vip_di.visible) {
		// 	SetSizeDeltaX(this.vip_di, 25)
		// } else {
		// 	SetSizeDeltaX(this.vip_di, 0)
		// }
		// if (this.effect_touxian1.visible) {
		// 	SetSizeDeltaX(this.effect_touxian1, 61)
		// } else {
		// 	SetSizeDeltaX(this.effect_touxian1, 0)
		// }
		// if (this.img_medal.visible) {
		// 	SetSizeDeltaX(this.img_medal, 66)
		// } else {
		// 	SetSizeDeltaX(this.img_medal, 0)
		// }
		// if (this.vip_di1.visible) {
		// 	SetSizeDeltaX(this.vip_di1, 25)
		// } else {
		// 	SetSizeDeltaX(this.vip_di1, 0)
		// }
		// if (this.effect_touxian.visible) {
		// 	SetSizeDeltaX(this.effect_touxian, 61)
		// } else {
		// 	SetSizeDeltaX(this.effect_touxian, 0)
		// }
		// if (this.img_medal1.visible) {
		// 	SetSizeDeltaX(this.img_medal1, 66)
		// } else {
		// 	SetSizeDeltaX(this.img_medal1, 0)
		// }
		// SetSizeDeltaX(this.txt_touxian1, 0)
		// SetSizeDeltaX(this.txt_touxian, 0)
		this.txt_name.y = 6 //29 / 2 - this.txt_name.contextHeight / 2
		this.txt_name1.y = 12
		this.img_medal1.y = 8
		this.vip_di.y = 6

		if (this.mainRoleCon.visible) {
			RefBoxChildsLayout(this.info_content1, 12, null, true, "right")
		}


		if (this.playerRoleCon.visible) {
			RefBoxChildsLayout(this.info_content, 12, null, true, "left")
		}

	}


	mainRoleCon: Laya.Box
	img_headicon: Laya.Box
	img_kuang: Laya.Image
	txt_lv1: Laya.Label
	info_content1: Laya.Box
	vip_di: Laya.Image
	txt_touxian1: Laya.Label
	effect_touxian1: Laya.Box
	img_medal: Laya.Image
	vip_num1: Laya.Image
	txt_name: Laya.HTMLDivElement
	img_qipao1_img: Laya.Image
	img_qipao1: Laya.Box
	SpriteGraphic1: Laya.Box
	image111: Laya.Image
	txt_content1: Laya.Label
	test: Laya.HTMLDivElement
	btn_qipao_voice: Laya.Box
	img_voice_img: Laya.Image
	img_voice_txt: Laya.VBox
	txt_content11: Laya.Label
	txt1: Laya.Label
	image: Laya.Image
	playerRoleCon: Laya.Box
	img_headicon1: Laya.Box
	img_kuang1: Laya.Image
	txt_lv: Laya.Label
	info_content: Laya.Box
	vip_di1: Laya.Image
	txt_touxian: Laya.Label
	effect_touxian: Laya.Box
	img_medal1: Laya.Image
	txt_name1: Laya.HTMLDivElement
	vip_num: Laya.Image
	img_qipao_img: Laya.Image
	img_qipao: Laya.Box
	txt_content111: Laya.Label
	image11: Laya.Image
	SpriteGraphic: Laya.Box
	test2: Laya.HTMLDivElement
	btn_qipao_voice1: Laya.Box
	img_voice_img1: Laya.Image
	img_voice_txt1: Laya.VBox
	txt_content: Laya.Label
	txt: Laya.Label
	image11111: Laya.Image
	public GetComponents() {
		[
			this.mainRoleCon,
			this.img_headicon,
			this.img_kuang,
			this.txt_lv1,
			this.info_content1,
			this.vip_di,
			this.txt_touxian1,
			this.effect_touxian1,
			this.img_medal,
			this.vip_num1,
			this.txt_name,
			this.img_qipao1_img,
			this.img_qipao1,
			this.SpriteGraphic1,
			this.image111,
			this.txt_content1,
			this.test,
			this.btn_qipao_voice,
			this.img_voice_img,
			this.img_voice_txt,
			this.txt_content11,
			this.txt1,
			this.image,
			this.playerRoleCon,
			this.img_headicon1,
			this.img_kuang1,
			this.txt_lv,
			this.info_content,
			this.vip_di1,
			this.txt_touxian,
			this.effect_touxian,
			this.img_medal1,
			this.txt_name1,
			this.vip_num,
			this.img_qipao_img,
			this.img_qipao,
			this.txt_content111,
			this.image11,
			this.SpriteGraphic,
			this.test2,
			this.btn_qipao_voice1,
			this.img_voice_img1,
			this.img_voice_txt1,
			this.txt_content,
			this.txt,
			this.image11111,
		]
			= this.GetChildrenByNames([

				"mainRoleCon",
				"img_headicon",
				"img_kuang",
				"txt_lv1",
				"info_content1",
				"vip_di",
				"txt_touxian1",
				"effect_touxian1",
				"img_medal",
				"vip_num1",
				"txt_name",
				"img_qipao1_img",
				"img_qipao1",
				"SpriteGraphic1",
				"image111",
				"txt_content1",
				"test",
				"btn_qipao_voice",
				"img_voice_img",
				"img_voice_txt",
				"txt_content11",
				"txt1",
				"image",
				"playerRoleCon",
				"img_headicon1",
				"img_kuang1",
				"txt_lv",
				"info_content",
				"vip_di1",
				"txt_touxian",
				"effect_touxian",
				"img_medal1",
				"txt_name1",
				"vip_num",
				"img_qipao_img",
				"img_qipao",
				"txt_content111",
				"image11",
				"SpriteGraphic",
				"test2",
				"btn_qipao_voice1",
				"img_voice_img1",
				"img_voice_txt1",
				"txt_content",
				"txt",
				"image11111",
			])
	}
}
window["ChatItem"] = ChatItem
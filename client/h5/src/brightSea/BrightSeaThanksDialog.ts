import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { BrightSeaEvent, BrightSeaModel } from "../commonModel/BrightSeaModel"
import { ChatModel, ChatModelEvent, CHAT_TYPE } from "../commonModel/ChatModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { PlatformManager } from "../PlatformManager"
import { RoleManager } from "../commonModel/RoleManager"
import { Message } from "../sysInfo/SysInfoController"
import { GameResPath } from "../util/GameResPath"
import { Util, Trim, SetHtmlStyle, SetHtmlCenter, HtmlColorTxt } from "../util/Util"
import { BaseAwardItem } from "../common/BaseAwardItem"
import { table } from "../common/table"
import { CustomHeadItem } from "../common/CustomHeadItem"

export class BrightSeaThanksDialog extends BaseView1 {
	model
	InitEvent
	InitView
	CheckChatLegal
	data
	SendChat
	GetChatContent
	defaultText
	Local_DeleteMe
	reward_item_list_
	Local_Open
	_head1
	public constructor() {
		super()


		this.base_file = "brightSea"
		this.layout_file = "BrightSeaThanksDialog"
		this.destroy_imm = true
		this.layer_value = Enum_UILayer.Activity
		this.is_center = true
		this.use_background = true
		this.click_bg_toClose = true
		this.model = BrightSeaModel.GetInstance()
		let role_mgr = RoleManager.GetInstance()
		let send_content = null
		let is_send_reward = false

		let default_thanks = [
			"感谢大佬帮我抢回奖励,以后我就跟着你混了!",
			"大佬威武,好人一生平安!",
			"好兄弟,这次你帮我,下次我帮你!"
		]

		this.load_callback = () => {
			SetHtmlStyle(this._lbontent,{w:470,c:"#b55d34",lh:25,f:20,ww:false})
			this._sc.vScrollBarSkin=""
			this.InitEvent()
			this.InitView()
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._confirmBtn, () => {
				if (!this.data) {
					return
				}
				let [is_pass, content] = this.CheckChatLegal()
				if (is_pass) {
					send_content = content
					this.model.Fire(BrightSeaEvent.REQUEST_PROTO, 18909, this.data.auto_id, 1)
					is_send_reward = true
				}
			}, this, true)

			this.BindEvent(this.model, BrightSeaEvent.RECEIVE_REWARD, () => {
				this.SendChat(send_content)
				this.Close()
			})
		}

		this.SendChat = (content?) => {
			if (this.data) {
				let roleVo = role_mgr.GetMainRoleVo()
				ChatModel.GetInstance().Fire(ChatModelEvent.CHAT_SEND_MSG, 11001, CHAT_TYPE.PRIVATE_CHAT, roleVo.province, roleVo.city, this.data.role_id, content, "", 0, "",this.data.name)
			}
		}

		this.destroy_callback = () => {
			this.Local_DeleteMe()
		}

		this.GetChatContent = () => {
			let content = Trim(this.textDisplay.text)
			if (content == "") {
				content = this.defaultText
				if (content == "") {
					content = default_thanks[Util.RandomRange(0, 2)]
					this.textDisplay.text = content
				}
			}
			return content
		}

		this.CheckChatLegal = () => {
			let content = this.GetChatContent()
			// let _, title_filter = LanguageFilter.FilterMsg(content)
			// if (title_filter == false ) {
			// 	Message.show("内容有敏感词")
			// 	return [false,""]
			// }
			return [true, content]
		}

		this.open_callback = () => {
		}

		this.Local_DeleteMe = () => {
			if (!is_send_reward && this.data) {
				this.model.Fire(BrightSeaEvent.REQUEST_PROTO, 18909, this.data.auto_id, 1)
				this.SendChat(this.GetChatContent())
			}
			is_send_reward = false

			if (this.reward_item_list_) {
				for (let _ in this.reward_item_list_) {
					var item = this.reward_item_list_[_]
					item.DeleteMe()
				}
				this.reward_item_list_ = null
			}

			if(this._head1){
				this._head1.DeleteMe()
				this._head1=null
			}
		}

		this.Local_Open = (parms?) => {
			if (parms) {
				this.data = parms
			}
			super.Open()
		}

		this.InitView = () => {
			this.defaultText= default_thanks[Util.RandomRange(0, 2)]
			this.textDisplay.prompt = this.defaultText
			//ResManager.GetInstance().SetOutsideImageSprite(this, this._Image1_1, GameResPath.GetIcon("brightSea","uicczhxz_003"))

			if (!this.data) {
				return
			}

			// let head_res = this.model.GetHeadRes(this.data)
			// ResManager.GetInstance().SetOutsideImageSprite(this, this._head, head_res)
			if (!this._head1) {
				this._head1 = new CustomHeadItem(this._head)
				this._head1.Load()
			}

			let head_data = { role_id: this.data.role_id, picture: this.data.pic, picture_ver: this.data.pic_ver }
			this._head1.SetRoleVoData(head_data)
			this._head1.SetActiveBg2(false)

			let str = `${HtmlColorTxt(this.data.name,'"#0a953e"')}大佬义薄云天帮你夺回了损失`
			this._lbontent.innerHTML = str
			SetHtmlCenter(this._lbontent,{x:7,w:470})

			if (this.data.reward && this.data.reward.length > 0) {
				if (!this.reward_item_list_) {
					this.reward_item_list_ = []
				}
				for (let _ = 0; _ < this.reward_item_list_.length; _++) {
					var reward_item = this.reward_item_list_[_]
					reward_item.SetVisible(false)
				}

				let reward_tb = GoodsModel.RewardKeyToNumber(this.data.reward)
				// let index = 1
				// for (let key in reward_tb) {

				// 	let vo = reward_tb[key]
				// 	let ret = this.model.LoadAndRefreshAwardItem(vo, this._con_reward, this.reward_item_list_, index)
				// 	if (ret ) {
				// 		index = index + 1
				// 	}
				// }


				for (let index in reward_tb) {
					var vo = reward_tb[index]
					let item = this.reward_item_list_[index]
					if (!item) {
						item = new BaseAwardItem(this._con_reward, null, "Activity")
						item.Load()
						item.SetVisible(true)
						table.insert(this.reward_item_list_, item)
						item.ExcuteCallback(() => {
							item.SetItemSize(89, 89)
						})
					}
					let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(vo.style, vo.typeId)
					let goods_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
					if (goods_vo) {
						item.SetData(goods_vo.type_id, vo.count, lock)
					}
				}


			}
		}

	}

	public Open(...new_args) {

		this.Local_Open(...new_args)
	}

	public DeleteMe() {
		super.DeleteMe()
	}


_Image1_1:Laya.Image
_con_head:Laya.Box
_head:Laya.Box
_lbontent:Laya.HTMLDivElement
_sc:Laya.Panel
_con_reward:Laya.HBox
_Group2:Laya.Box
_text_input:Laya.Box
_image1:Laya.Image
textDisplay:Laya.TextInput
_confirmBtn:Laya.Box
_Image6:Laya.Image
labelDisplay:Laya.Label
_Group4:Laya.Box
_Image4444:Laya.Image
title:Laya.Label
public GetComponents() {
[
this._Image1_1,
this._con_head,
this._head,
this._lbontent,
this._sc,
this._con_reward,
this._Group2,
this._text_input,
this._image1,
this.textDisplay,
this._confirmBtn,
this._Image6,
this.labelDisplay,
this._Group4,
this._Image4444,
this.title,
]
 = this.GetChildrenByNames([

"_Image1_1",
"_con_head",
"_head",
"_lbontent",
"_sc",
"_con_reward",
"_Group2",
"_text_input",
"_image1",
"textDisplay",
"_confirmBtn",
"_Image6",
"labelDisplay",
"_Group4",
"_Image4444",
"title",
])
}
}
 window["BrightSeaThanksDialog"]= BrightSeaThanksDialog
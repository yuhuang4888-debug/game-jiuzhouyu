import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { BrightSeaModel } from "../commonModel/BrightSeaModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { GuildModel, GuildEvent } from "../commonModel/GuildModel"
import { ErlangParser } from "../util/ErlangParser"
import { HtmlColorTxt, SetHtmlStyle, Util } from "../util/Util"

export class BrightSeaGuildHelpDialog extends BaseView1 {
	InitEvent
	InitView
	Local_DeleteMe
	_Local_Open
	click_bg_toClose
	data
	destroy_imm
	is_center
	item_reward
	model
	open_callback
	use_background

	public constructor(parent?) {
		super()


		this.base_file = "brightSea"
		this.layout_file = "BrightSeaGuildHelpDialog"
		this.destroy_imm = true
		this.layer_value = Enum_UILayer.Activity
		this.is_center = true
		this.use_background = true
		this.click_bg_toClose = true

		this.model = BrightSeaModel.GetInstance()
		let erlang_parser = ErlangParser.GetInstance()
		let guild_model = GuildModel.GetInstance()

		this.load_callback = () => {
			SetHtmlStyle(this._content1,{c:"#663915",f:22,w:430,lh:25})
			this.InitEvent()
			this.InitView()
		}

		this.open_callback = () => {
		}

		this.Local_DeleteMe = () => {
			if (this.item_reward) {
				this.item_reward.DeleteMe()
				this.item_reward = null
			}
		}

		this._Local_Open = (parms?) => {
			if (parms) {
				this.data = parms
			}
			super.Open()
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._close_btn, () => {
				this.Close()
			}, this, true)

			Util.AddClickEvent(this._ok_btn, () => {
				if (!this.data) {
					return
				}
				guild_model.Fire(GuildEvent.REQUEST_PROTO, 40401, "chil", 3, 1, 0, this.data.auto_id)
				this.Close()
			}, this, true)
		}

		this.InitView = () => {
			if (!this.data) {
				return
			}
			
			let rober_gname =HtmlColorTxt( (this.data.rober_gname || ""),"'#0a953e'")
			let rober_name = HtmlColorTxt( this.data.rober_name,"'#0a953e'")

			let str
			if (this.data.rober_gname && this.data.rober_gname != "") {
				str = `辛辛苦苦挖的矿被${rober_gname}结社的${rober_name}无情掠夺了。<br>可向结社求助，夺回以下损失：`
			} else {
				str = `辛辛苦苦挖的矿被${rober_name}无情掠夺了。<br>可向结社求助，夺回以下损失：`
			}

			this._content1.innerHTML = str
			this._content1.style.width=430

			let reward_tb = this.data.reward
			if (reward_tb && reward_tb.length>0) {
				reward_tb = GoodsModel.RewardKeyToNumber(reward_tb)
				// let reward_info = reward_tb[1]
				// if (!this.item_reward) {
				// 	this.item_reward = this.model.LoadAwardItem(reward_info, this._con_reward, this.layer_value)
				// }


				if (!this.item_reward) {
					this.item_reward = new BaseAwardItem(this._con_reward, null, "Activity")
					this.item_reward .Load()
					this.item_reward .SetVisible(true)
					this.item_reward .SetItemSize(98, 98)
				}

				let vo = reward_tb[0]
				let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(vo[0], vo[1])
				let goods_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
				if (goods_vo) {
					this.item_reward.SetData(goods_vo.type_id, vo[2], lock)
				}


			}else{
				if (this.item_reward) {
					this.item_reward .SetVisible(false)
				}

			}
		}

		this.destroy_callback=()=>{
			this.Local_DeleteMe()
		}
	}

	public Open(...new_args) {

		this._Local_Open(...new_args)
	}

	public DeleteMe() {
		super.DeleteMe()
	}

_Image2:Laya.Image
_Img_bg:Laya.Image
_content1:Laya.HTMLDivElement
_ok_btn:Laya.Box
_Image1:Laya.Image
labelDisplay:Laya.Label
_close_btn:Laya.Image
_Group1:Laya.Box
_Image4:Laya.Image
title:Laya.Label
_con_reward:Laya.Box
public GetComponents() {
[
this._Image2,
this._Img_bg,
this._content1,
this._ok_btn,
this._Image1,
this.labelDisplay,
this._close_btn,
this._Group1,
this._Image4,
this.title,
this._con_reward,
]
 = this.GetChildrenByNames([

"_Image2",
"_Img_bg",
"_content1",
"_ok_btn",
"_Image1",
"labelDisplay",
"_close_btn",
"_Group1",
"_Image4",
"title",
"_con_reward",
])
}
}
 window["BrightSeaGuildHelpDialog"]= BrightSeaGuildHelpDialog
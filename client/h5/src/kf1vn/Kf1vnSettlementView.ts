import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { Kf1vnModel } from "../commonModel/Kf1vnModel"
import { GameResPath } from "../util/GameResPath"
import { SetHtmlCenter, SetHtmlStyle, Util } from "../util/Util"

export class Kf1vnSettlementView extends BaseView1 {
	InitEvent
	LoadSuccess
	Local_Open
	SetEffect
	SetItemList
	UpdateView
	back_login_close
	click_bg_toClose
	destroy_callback
	destroy_imm
	open_callback
	use_background
	GetDefendNumByTurn
	GetTimeByTag
	public constructor() {
		super()

		this.base_file = "kf1vn"
		this.layout_file = "Kf1vnSettlementView"
		this.layer_value = Enum_UILayer.Activity
		this.back_login_close = true
		this.destroy_imm = true
		this.click_bg_toClose = true
		this.use_background = true
		this.is_center=true

		this.preload_server_config={"config_kf_1vn_match":false,"config_kf_1vn_time":false}
		let data_ = null
		let item_list_ = null
		this.load_callback = () => {
			this._Scroller1.hScrollBarSkin = ""
			SetHtmlStyle(this.platform_label1, { c: "#ffffff", f: 20, w: 600, ww: false })
			SetHtmlStyle(this.platform_label2, { c: "#ffffff", f: 20, w: 600, ww: false })
			SetHtmlStyle(this.ticket_label1, { c: "#ffffff", f: 20, w: 600, ww: false })
			SetHtmlStyle(this.ticket_label2, { c: "#663519", f: 20, w: 600, ww: false,lh:25,a:"center" })
			this.LoadSuccess()
			this.InitEvent()
		}

		this.GetTimeByTag = (tag?) => {
			let time = 0
			let config_kf_1vn_time= ResManager.GetInstance().GetGameConfigFromCache(this,"config_kf_1vn_time",false)
			if (config_kf_1vn_time && config_kf_1vn_time[1]) {
				time = config_kf_1vn_time[1][tag]
			}
			return time
		}


		this.GetDefendNumByTurn = (turn?) => {
			let num = 0
			let config_kf_1vn_match=ResManager.GetInstance().GetGameConfigFromCache(this,"config_kf_1vn_match",false)
			if (config_kf_1vn_match) {
			  num = (config_kf_1vn_match[turn] && (config_kf_1vn_match[turn].c_num) || (0))
			}
			return num
		  }
	

		this.open_callback = () => {
			this.UpdateView()
		}

		this.destroy_callback = () => {
			for (let _tmpi in item_list_) {
				var item = item_list_[_tmpi]
				item.DeleteMe()
			}
			item_list_ = null
			// this.ClearUIEffect(this._gp_victory)
			// this.ClearUIEffect(this._gp_fly)
		}

		this.LoadSuccess = () => {

			item_list_ = []
		}

		this.InitEvent = () => {

		}

		this.Local_Open = (parms?) => {
			data_ = parms && parms[0] || null
			super.Open()
		}

		this.UpdateView = () => {
			if (!data_ || !data_.rank) {
				return
			}
			ResManager.GetInstance().SetImageSprite(this, this.settlement_state, "kf1vn", data_["type"] == 1 && "uijs_049" || "uijs_050")
			ResManager.GetInstance().SetOutsideImageSprite(this, this._bg, GameResPath.GetIcon("kf1vn","com_up_bg1"))
			this.ticket_conta.visible = data_["type"] == 1
			this.platform_conta.visible = data_["type"] == 2
			if (data_["type"] == 1) {
				let str = "我的积分：<font color='#ffef67'>" + data_.score + "</font>&nbsp;&nbsp;&nbsp;&nbsp;我的排名：<font color='#ffef67'>" + data_.rank + "</font>"
				this.ticket_label1.innerHTML = Util.StrToHTML(str)
				let time = this.GetTimeByTag("race_2_pre")
				let style = (data_.is_def == 1 && ("擂主") || ("挑战者"))
				let str2 = "您将以<font color='#ffef67'>【" + style + "】</font>的身份参与擂台赛<br>擂台赛将于<font color='#0a953e'>" + time + "秒</font>后正式开启,请准时参加！"
				this.ticket_label2.innerHTML = Util.StrToHTML(str2)
			} else {
				let str = "恭喜您在<font color='#00fa64'>擂台赛</font>中以优异成绩获得<font color='#ffef67'>第" + data_.rank + "名</font>"
				this.platform_label1.innerHTML = Util.StrToHTML(str)
				let turn = this.GetDefendNumByTurn(data_.turn)
				let str2 = "1v" + turn

				if (turn == 0) {
					str2 = "无"
				}
				this.platform_label2.innerHTML = Util.StrToHTML("最高守擂记录：<font color='#ffef67'>" + str2 + "</font>")
			}
			this.SetItemList(data_.award)
			this.SetEffect()
			SetHtmlCenter(this.ticket_label2, { x: 0, w: 720 })
			SetHtmlCenter(this.ticket_label1, { x: 0, w: 720 })
			SetHtmlCenter(this.platform_label1, { x: 0, w: 720 })
			SetHtmlCenter(this.platform_label2, { x: 0, w: 720 })

		}

		this.SetItemList = (reward_list?) => {

			if (item_list_ && item_list_.length > 0) {
				for (let k = 0; k < item_list_.length; k++) {
					if (item_list_[k]) {
						item_list_[k].SetVisible(false)
					}
				}
			}
			let bag_list = (reward_list && (reward_list) || ([]))
			let i = 0
			do {
				let info = bag_list[i]
				if (info) {
					let item = item_list_[i]
					if (!item) {
						item = new BaseAwardItem(this.Content)
						item.Load()
						item.SetScale(0.85)
						item_list_[i] = item
					}
					let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(info.style, info.typeId)
					item.SetData(type_id, info.count, lock)
					item.SetVisible(true)
				}
				i = i + 1
			} while ((i < bag_list.length))

		}

		this.SetEffect = () => {
			if (!data_) {
				return
			}
			// let effect_name = data_["type"] == 1 && "ui_qualification_glow" || "ui_arena_glow"
			// this.AddUIEffect("ui_victory_glow1", this._gp_victory, null, 1.4, true)
			// this.AddUIEffect(effect_name, this._gp_fly, null, 1.1, false)
		}
	}

	public Open(...new_args) {

		let parms = new_args
		this.Local_Open(parms)
	}


_bg:Laya.Image
settlement_state:Laya.Image
ticket_conta:Laya.Box
_Image1:Laya.Image
ticket_label1:Laya.HTMLDivElement
ticket_label2:Laya.HTMLDivElement
platform_conta:Laya.Box
_Image2:Laya.Image
platform_label1:Laya.HTMLDivElement
platform_label2:Laya.HTMLDivElement
tips:Laya.Label
tips0:Laya.Label
_Scroller1:Laya.Panel
Content:Laya.HBox
public GetComponents() {
[
this._bg,
this.settlement_state,
this.ticket_conta,
this._Image1,
this.ticket_label1,
this.ticket_label2,
this.platform_conta,
this._Image2,
this.platform_label1,
this.platform_label2,
this.tips,
this.tips0,
this._Scroller1,
this.Content,
]
 = this.GetChildrenByNames([

"_bg",
"settlement_state",
"ticket_conta",
"_Image1",
"ticket_label1",
"ticket_label2",
"platform_conta",
"_Image2",
"platform_label1",
"platform_label2",
"tips",
"tips0",
"_Scroller1",
"Content",
])
}
}
 window["Kf1vnSettlementView"]= Kf1vnSettlementView
import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseView1 } from "../common/BaseView1"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { WelfareModel, WelfareEvent } from "../commonModel/WelfareModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { Util, Trim } from "../util/Util"

export class WelfareWelcomeView extends BaseView1 {
	Empclose_btn
	EmpgoBtn
	InitEvent
	InitView
	LoadSuccess
	_Local_Open
	bg
	btn_effect
	click_bg_toClose
	close_btn
	content
	destroy_callback
	destroy_imm
	goBtn
	image
	image1
	item
	item2
	item_con1
	item_con2
	item_name2
	open_callback
	title_icon
	use_background
	ShowCircleEffect
	public constructor() {
		super()

		this.base_file = "Welfare"
		this.layout_file = "WelfareWelcomeView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.use_background = true
		this.click_bg_toClose = false
		this.preload_client_config = {
			"config_welfare_cfg": false
		}
		this.load_callback = () => {
			this.LoadSuccess()
			this.InitEvent()
		}
		this.open_callback = () => {
			this.InitView()
		}

		this.destroy_callback = () => {
			if (this.item) {
				this.item.DeleteMe()
				this.item = null
			}
			if (this.item2) {
				this.item2.DeleteMe()
				this.item2 = null
			}
			if(this.goBtn){
				GlobalEventSystem.Fire(EventName.HIDE_FINGER, this.goBtn)
			}
		}

		this.LoadSuccess = () => {

			// if (PlatformMgr.GetInstance().IsEyouPlatform() ) { 
			// 	this.content.size  = 24
			// 	this.content.lineSpacing = 1.4
			// }
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this.close_btn, () => {
				this.Close()
			}, this, true)

			Util.AddClickEvent(this.goBtn, () => {
				WelfareModel.GetInstance().Fire(WelfareEvent.WELFARE_REQUEST_PROTO, 41719, "c", 4)	//目前英文的新手奖励界面用
				GlobalEventSystem.Fire(EventName.HIDE_FINGER, this, this.goBtn)
				this.Close()
			}, this, true)
		}

		this._Local_Open = (param?) => {
			super.Open()
		}

		this.InitView = () => {
			let str = "登入遊戲可擁有特殊稱號:\n"
			// if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) { 
			// 	str = "Loginto ) { game to get a unique title:\n"
			// } else if (PlatformMgr.GetInstance().IsEyouJpPlatform() ) {
			// 	str = "騎士様、極夜大陸へようこそ！ 下記のTwitterフォロー達成報酬、限定称号と新米成長パックをぜひお受け取りください！"
			// }
			if (this.preload_server_config["config_welfare_cfg"]) {
				let cfg = this.preload_server_config["config_welfare_cfg"][4]
				if (cfg) {
					let reward_list = ErlangParser.GetInstance().Parse(cfg.val)
					if (reward_list && reward_list[1] && reward_list[2]) {
						let basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(Number(reward_list[1][2]))
						let num = ""
						if (basic) {
							num = Number(reward_list[1][3]) > 1 && (reward_list[1][3] + "x ") || " "
							// if (PlatformMgr.GetInstance().IsEyouJpPlatform() ) {
							// }else{
							str = str + " " + num + Trim(basic.goods_name)
							// }
							if (!this.item) {
								this.item = new BaseAwardItem(this.item_con1)
								this.item.Load()
							}
							this.item.SetItembgVisible(false)
							this.item.SetItemSize(200, 200)
							this.item.SetData(Number(reward_list[1][2]))
						}
						basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(Number(reward_list[2][2]))
						num = ""
						if (basic) {
							num = Number(reward_list[2][3]) > 1 && (reward_list[2][3] + "x ") || " "
							// if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {  
							// str = str + "and Gear " + num + Trim(basic.goods_name)
							// } else if (PlatformMgr.GetInstance().IsEyouJpPlatform() ) {
							// }else{
							str = str + "和獲得 " + num + Trim(basic.goods_name)
							// }
							if (!this.item2) {
								this.item2 = new BaseAwardItem(this.item_con2)
								this.item2.Load()
							}
							this.item2.SetItembgVisible(false)
							this.item2.SetItemSize(90, 90)
							this.item2.SetData(Number(reward_list[2][2]))
							this.item_name2.text = Trim(basic.goods_name)
						}
					}
				}
			}
			this.content.text = str
			let step_cfg = { direction: 8, text: "赶快开启您的奇妙旅程吧~" }
			// if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) { 
			// step_cfg = [direction=8, text="Start your wonderful journey~"]
			// } else if (PlatformMgr.GetInstance().IsEyouJpPlatform() ) {
			// step_cfg = [direction=8, text="タップして報酬を受け取ろう！"]
			// }
			GlobalEventSystem.Fire(EventName.SHOW_FINGER, this, this.goBtn, this.layer_value, null, null, false, false, step_cfg, true)
		}

		this.ShowCircleEffect = () => {
			this.AddUIEffect("UI_1140", this.display_obj, this.btn_effect, null, null, true)
		}
	}

	public Open(...new_args) {

		this._Local_Open(...new_args)
	}
}
window["WelfareWelcomeView"]=WelfareWelcomeView

import { Alert, Alert_Type } from "../alert/Alert"
import { GoodsModel } from "../commonModel/GoodsModel"
import { Message } from "../sysInfo/SysInfoController"
import { TimeUtil } from "../util/TimeUtil"
import { Util, SetAnchoredPosition, HtmlColorTxt, NotEnougnDiamond } from "../util/Util"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { DailyModel } from "../commonModel/DailyModel"
import { ColorUtil, Enum_ColorUtil_Dark } from "../util/ColorUtil"
import { MarriageEvent, MarriageModel } from "../commonModel/MarriageModel"
import { SettingModel } from "../commonModel/SettingModel"
import { PlatformManager } from "../PlatformManager"
import { OnHookModel } from "../commonModel/OnHookModel"
import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseView1, OpenMode } from "../common/BaseView1"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { WithBtnHSlider } from "../common/WithBtnHSlider"
import { BossModel } from "../commonModel/BossModel"
import { ResManager } from "../common/ResManager"
import { RoleManager } from "../commonModel/RoleManager"
import { ShopModel } from "../commonModel/ShopModel"

export class BossFieldVitBuyView extends BaseView1 {
	slider: WithBtnHSlider
	vit_back_cost
	model: BossModel
	back_vit
	public constructor() {
		super()
		this.base_file = "bossField"
		this.layout_file = "BossFieldVitBuyView"
		this.layer_value = Enum_UILayer.Activity
        this.open_mode = OpenMode.OpenToggle
		this.destroy_imm = true
		this.is_center = true
		this.use_background = true
		this.click_bg_toClose = true
        this.back_login_toClose = true
		this.back_vit=0
		this.model = BossModel.GetInstance()

		this.load_callback = () => {
			this.LoadSuccess()
		}

		this.close_callback = () => {
		}

		this.destroy_callback=()=>{
			if (this.slider) {
				this.slider.DeleteMe()
				this.slider = null
			}
		}
	}

	private LoadSuccess() {
		this.gp_price.visible = false
		this.InitEvent();
		let cfgs = ResManager.GetInstance().GetGameConfigFromCache(this, "config_boss_type_key_value", false)
		this.vit_back_cost = JSON.parse(BossModel.GetInstance().GetBossKeyValue(BossModel.BossType.field, "back_vit_cost", cfgs))[0]||[0,0,0]
		this.lb_price_2.text = this.vit_back_cost[2] + ""
		this.ShowVit()
	}


	private UpdateCost() {
		let slide_num = this.GetSlideValue()

		let need_cost = Number(this.vit_back_cost[2])
		let arr = ShopModel.GetInstance().MoneyIsEnough(2, need_cost)


		let color = arr[0] ? ColorUtil.GetReplaceChar(Enum_ColorUtil_Dark.GREEN) : ColorUtil.GetReplaceChar(Enum_ColorUtil_Dark.RED)
		this.lb_price.color = color
		this.lb_price.text = (slide_num * need_cost) + ""
		this.gp_price.visible = true
	}

	private InitEvent() {
		Util.AddClickEvent(this.btn_close, () => {
			this.Close()
		}, this, true)

		Util.AddClickEvent(this.btn_cancel, () => {
			this.Close()
		}, this, true)

		Util.AddClickEvent(this.btn_enter, () => {
			if(!this.slider)return
			let value =this.GetSlideValue()
			let need_cost = Number(this.vit_back_cost[2]) * value
			let arr = ShopModel.GetInstance().MoneyIsEnough(2, need_cost)
			if (arr[0]) {
				this.model.Fire(BossModel.SCMD_REQUEST, 46045, BossModel.BossType.field,value)
			} else {
				let need_jin = need_cost - arr[2]
				let ok_callback = () => {
					if(this.use_delete_method)return
					if (need_jin > RoleManager.GetInstance().mainRoleInfo.jin) {
						NotEnougnDiamond()
						return
					}

					if(this.slider){
						this.model.Fire(BossModel.SCMD_REQUEST, 46045, BossModel.BossType.field,value)
					}
				
				}


				let str = `绑玉不足${HtmlColorTxt(need_cost+"",'"#0a953e"')},是否花费勾玉${HtmlColorTxt(need_jin+"",'"#0a953e"')}补足?`
				Alert.Show(Util.StrToHTML(str), Alert_Type.Two, ok_callback)
				Alert.SetIsCharge(true)
			}
		}, this, true)



		this.BindEvent(GoodsModel.GetInstance(), GoodsModel.UPDATE_GOODS_NUM, (goods_list?) => {
			if (this.use_delete_method) {
				return
			}
			for (let _tmpi in goods_list) {
				var vo = goods_list[_tmpi]
				if (vo.type_id == 2) {
					this.UpdateCost()
					break
				}
			}
		}
		)



		this.BindEvent(BossModel.GetInstance(), BossModel.BOSS_FIELD_BACK_VIT_UPDATE, () => {
			Message.show("成功找回体力")
			this.Close()
		}
		)
	}


	private GetSlideValue(){
		if(this.slider){
			let value = this.slider.GetValue()
			value = Number(value.toFixed(0))
			return value
		}
		return 0
	}

	private ShowVit() {
		this.slider = new WithBtnHSlider(this.gp_slider)
		this.slider.SetData(this.back_vit, 1, 1, this.back_vit, true, () => {
			this.UpdateCost()
		})
		this.slider.Load()
		this.slider.ExcuteCallback(() => {
			SetAnchoredPosition(this.slider.display_obj, -170, -70)
		})
	}



	
	public Open(...new_args) {
		this.back_vit = new_args&&new_args[0]||1
		super.Open()
	}



	img_bg: Laya.Image
	img_bg2: Laya.Image
	img_bg3: Laya.Image
	lb_title: Laya.Label
	lb_1: Laya.Label
	lb_2: Laya.Label
	price_text: Laya.Label
	gp_price: Laya.Box
	lb_price: Laya.Label
	price_image: Laya.Image
	gp_price_2: Laya.Box
	lb_price_2: Laya.Label
	price_image_2: Laya.Image
	gp_slider: Laya.Box
	btn_close: Laya.Image
	btn_cancel: Laya.Image
	lb_cancel: Laya.Label
	btn_enter: Laya.Image
	lb_enter: Laya.Label
	public GetComponents() {
		[
			this.img_bg,
			this.img_bg2,
			this.img_bg3,
			this.lb_title,
			this.lb_1,
			this.lb_2,
			this.price_text,
			this.gp_price,
			this.lb_price,
			this.price_image,
			this.gp_price_2,
			this.lb_price_2,
			this.price_image_2,
			this.gp_slider,
			this.btn_close,
			this.btn_cancel,
			this.lb_cancel,
			this.btn_enter,
			this.lb_enter,
		]
			= this.GetChildrenByNames([

				"img_bg",
				"img_bg2",
				"img_bg3",
				"lb_title",
				"lb_1",
				"lb_2",
				"price_text",
				"gp_price",
				"lb_price",
				"price_image",
				"gp_price_2",
				"lb_price_2",
				"price_image_2",
				"gp_slider",
				"btn_close",
				"btn_cancel",
				"lb_cancel",
				"btn_enter",
				"lb_enter",
			])
	}
}
window["BossFieldVitBuyView"] = BossFieldVitBuyView
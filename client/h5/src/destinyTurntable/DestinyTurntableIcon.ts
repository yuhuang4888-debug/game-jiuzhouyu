import { BaseItem1 } from "../common/BaseItem1"
import { LinkTool } from "../common/LinkTool"
import { LinkViewType } from "../common/LinkViewType"
import { OpenFun } from "../common/OpenFun"
import { ResManager } from "../common/ResManager"
import { FirstRechargeModel } from "../commonModel/FirstRechargeModel"
import { investType, KaifuActivityModel } from "../commonModel/KaifuActivityModel"
import { Message } from "../sysInfo/SysInfoController"
import { Util } from "../util/Util"

export class DestinyTurntableIcon extends BaseItem1 {
	Image1: Laya.Image
	icon: Laya.Image
	tips: Laya.Image
	other: Laya.Image
	click_gp: Laya.Box

	InitEvent
	InitView
	LoadSuccess
	SetData
	data

	public static width = 164
	public static height = 164
	public constructor(parent?) {
		super(parent)

		this.base_file = "destinyTurntable"
		this.layout_file = "DestinyTurntableIcon"

		this.load_callback = () => {

			this.InitEvent()
			this.LoadSuccess()
		}



		this.InitEvent = () => {
			Util.AddClickEvent(this.click_gp, () => {
				if (this.data.jump_id) {

					let level_jump_condition = (investType)=> {
						let model = KaifuActivityModel.GetInstance()
						let curData = model.getInvestData(investType)
						let config_investment_item = ResManager.GetInstance().GetGameConfigFromCache(this, "config_investment_item", false)
						let fullCondtion = model.investOpenStatus(investType, config_investment_item)
						let bool = null
						if(curData){
							bool = !(curData.cur_lv <= 0) && fullCondtion  //如果bool为true表示已经购买了，false表示没有购买
						}
						return bool
					}
					//191是超值投资
					if(this.data.jump_id == 191){
						if(!level_jump_condition(investType.level)){			//等级投资
							OpenFun.OpenFunHandler(62)
						}else if(!level_jump_condition(investType.top)){		//巅峰投资
							OpenFun.OpenFunHandler(115)
						}else if(!level_jump_condition(investType.king)){	//王者投资
							OpenFun.OpenFunHandler(184)
						}else if(!level_jump_condition(investType.extreme)){ //至尊投资
							OpenFun.OpenFunHandler(155)
						}else if(!level_jump_condition(investType.god)){		//神眷投资
							OpenFun.OpenFunHandler(185)
						}
					}else{
						if(this.data.jump_id == 250){
							if(FirstRechargeModel.GetInstance().IsNoFirstRecharge()){
								Message.show("首充后开启周卡购买")
								return
							}
						}
						OpenFun.OpenFunHandler(this.data.jump_id)
					}
					
					if (this.data.link) {
						LinkTool.GetInstance().CacheJumpId(LinkViewType.DestinyTurntable, this.data.jump_id)
					}
				} else {
					LinkTool.GetInstance().ShowLinkView(LinkViewType.DestinyTurntable)
				}
			}, this, true)
		}

		this.LoadSuccess = () => {
			this.InitView()
		}

		this.SetData = (data?) => {
			this.data = data
			if (!this.is_loaded) {
				return
			}
			this.InitView()
		}

		this.InitView = () => {
			if (!this.data) {
				return
			}
			if (this.data.other) {
				this.icon.visible = false
				this.other.visible = true
				this.tips.visible = false
			} else {
				this.icon.visible = true
				this.other.visible = false
				this.tips.visible = this.data.isDouble
				let res = "uitmzp_012c"
				let asset = "destinyTurntable_asset"
				if (this.data.jump_id == 61) {
					//asset = "icon_asset"
					res = "uitmzp_012b"
				} else if (this.data.jump_id == 23) {
					res = "uitmzp_012a"
				} else if (this.data.jump_id == 191) {
					asset = "icon_asset"
					res = "23"
				} else if (this.data.jump_id == 192) {
					asset = "icon_asset"
					res = "416"
				} else if (this.data.jump_id == 140) {
					asset = "icon_asset"
					res = "22"
				} else if (this.data.jump_id == 194) {
					asset = "icon_asset"
					res = "490"
				} else if (this.data.jump_id == 55) {
					asset = "icon_asset"
					res = "415"
				} else if (this.data.jump_id == 232) {
					asset = "icon_asset"
					res = "33198"
				}else if (this.data.jump_id == 233) {
					asset = "icon_asset"
					res = "33243"
				}else if (this.data.jump_id == 250){
					asset = "icon_asset"
					res = "452"
				}
				ResManager.GetInstance().SetImageSprite(this, this.icon, asset, res)
			}
		}

	}
	public DeleteMe() {
		super.DeleteMe()
	}



	public GetComponents() {
		[
			this.Image1,
			this.icon,
			this.tips,
			this.other,
			this.click_gp
		]
			= this.GetChildrenByNames([

				"Image1",
				"icon",
				"tips",
				"other",
				"click_gp"
			])
	}
}
window["DestinyTurntableIcon"] = DestinyTurntableIcon
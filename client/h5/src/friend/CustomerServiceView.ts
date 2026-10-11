import { BaseItem1 } from "../common/BaseItem1"
import { Config } from "../common/Config"
import { ResManager } from "../common/ResManager"
import { FriendModel, FriendEvent } from "../commonModel/FriendModel"
import { Message } from "../sysInfo/SysInfoController"
import { ClientConfig } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { SetAnchoredPositionX, Trim, Util } from "../util/Util"
import { CustomerServiceItem } from "./CustomerServiceItem"

export class CustomerServiceView extends BaseItem1 {
	customerServiceConfig
	inputLabel
	submitBtn
	_Label1
	_Label2
	Placeholder
	bg1
	_Image1
	CreatItem
	item_list
	_Image2: Laya.Image

	public constructor(parent?) {
		super(parent)


		this.base_file = "friend"
		this.layout_file = "CustomerServiceView"
		this.preload_client_config = { "ClientCustomerServiceConfig": false }
		this.item_list = []
		this.load_callback = () => {
			this.LoadSuccess()
			// if (PlatformMgr.GetInstance().IsEyouIdnPlatform() ) {
			// 	this._Label1.size  = 18
			// 	this._Label2.size  = 18
			// 	SetAnchoredPositionX(this._Label1,289)
			// 	SetAnchoredPositionX(this._Label2,289)
			// }
			this.CreatItem()
		}

		this.CreatItem = ()=> {
			let platform_id = ClientConfig.plat_name
			let custom_server_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "ClientConfigCustomerService", true)
			let is_default = true
			let cfg
			for (let key in custom_server_cfg) {
				if(key == platform_id){
					cfg = custom_server_cfg[key]
					is_default = false
				}
			}

			if(is_default){
				cfg = custom_server_cfg.default_platform
			}

			for (let key in cfg.open_content) {
				let index = Number(key)
				let data = cfg.open_content[index]
				let item = this.item_list[index]
				if(!item){
					item = new CustomerServiceItem(this.downBox)
					this.item_list[index] = item
					item.SetPosition(0, index * 50)
					item.Load()
				}
				item.ExcuteCallback(()=>{
					item.SetData(data)
				})
			}
		}
	}

	public LoadSuccess() {


		ResManager.GetInstance().SetImageSpriteTrans(this, this.bg1, GameResPath.GetIcon("friend", "uisj_021"))
		// ResManager.GetInstance().SetOutsideImageSprite(this, this._Image1, GameResPath.GetIcon("friend", "uisj_022"))

		this.customerServiceConfig = ResManager.GetInstance().LoadGameConfig(this, "ClientCustomerServiceConfig", true)
		let SubmitFun = () => {
			if(this.btnLabel.text=="联系客服"){
				this.btnLabel.text="提交"
				this._Image1.visible=false
				this.upBox.visible=true
				this.downBox.visible=false
				this.Bg.visible=true
			}else{
				let inputStr = this.inputLabel.text
				if (inputStr && Trim(inputStr) != "") {
					FriendModel.GetInstance().Fire(FriendEvent.CUSTOMER_SERVICE, inputStr)
					this.inputLabel.text = ""
				} else {
					Message.show("内容不能为空")
				}
			}
		}

		Util.AddClickEvent(this.submitBtn, SubmitFun, this, true)
		this.BindEvent(FriendModel.GetInstance(), FriendEvent.SUBMIT_SUCCESS, () => {
			this.inputLabel.text = ""
		}
		)
		if (this.customerServiceConfig) {
			let promptText = null
			let cusid = ClientConfig.customerServiceId
			// [ts2lua]this.customerServiceConfig下标访问可能不正确
			if (this.customerServiceConfig[cusid]) {
				// [ts2lua]this.customerServiceConfig下标访问可能不正确
				promptText = this.customerServiceConfig[cusid]
			}
			if (!promptText) {
				// [ts2lua]this.customerServiceConfig下标访问可能不正确
				promptText = this.customerServiceConfig["default"]
			}
			if (promptText) {
				this.Placeholder.text = promptText
			}
		}
		//lua_resM:SetOutsideImageSprite(this, this.bg1, GameResPath.GetIcon("friend","uisj_021"))
	}

	public DeleteMe() {
		for (let index in this.item_list) {
			let vo = this.item_list[index]
			vo.DeleteMe()
		}
		this.item_list = []
		super.DeleteMe()
	}



	btnLabel: Laya.Label
	Text: Laya.Label
	downBox: Laya.Box
	line: Laya.Image
	line2: Laya.Image
	line3: Laya.Image
	upBox: Laya.Box
	bg2: Laya.Image
	Bg

	public GetComponents() {
		[
			this._Image1,
			this.submitBtn,
			this.btnLabel,
			this.Placeholder,
			this.Text,
			this.downBox,
			this._Label1,
			this.line,
			this.line2,
			this.line3,
			this.upBox,
			this.bg1,
			this.bg2,
			this._Label1,
			this._Label2,
			this._Image2,
			this.inputLabel,
			this.Bg
		]
			= this.GetChildrenByNames([

				"_Image1",
				"submitBtn",
				"btnLabel",
				"Placeholder",
				"Text",
				"downBox",
				"_Label1",
				"line",
				"line2",
				"line3",
				"upBox",
				"bg1",
				"bg2",
				"_Label1",
				"_Label2",
				"_Image2",
				"inputLabel",
				"Bg"
			])
			this.Bg.visible=false
	}
}
window["CustomerServiceView"] = CustomerServiceView
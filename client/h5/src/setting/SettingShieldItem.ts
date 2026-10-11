import { Alert, Alert_Type } from "../alert/Alert"
import { BagSmeltItemRender } from "../bag/BagSmeltItemRender"
import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { Config } from "../common/Config"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { SettingModel } from "../commonModel/SettingModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Message } from "../sysInfo/SysInfoController"
import { SetSizeDeltaX, Util } from "../util/Util"
import { PlatformManager } from "../PlatformManager"

export class SettingShieldItem extends BaseItemRenderer {
	check_img: Laya.Image
	_lb_text: Laya.Label
	check_img_1 :Laya.Image

	cfg

	config_setting
	model
	needRefresh

	public static width = 230
	public static height = 60

	public constructor(parent?) {
		super()

		// this.skinName = "resource/game/setting/exml/SettingShieldItemExml.exml"
		this.WIDTH = 250
		this.HEIGT = 50
		this.base_file = "setting"
		this.layout_file = "SettingShieldItem"
		this.model = SettingModel.GetInstance()
		// this.preload_client_config = {
		// 	"ClientBlockConfig": false
		// }
		// this.load_callback = () => {
		// this.LoadSuccess()

		// if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
		// 	this._lb_text.size  = 20
		// 	SetSizeDeltaX(this._lb_text, 217)
		// }

		// }
		this.Load()

	}

	public DeleteMe() {

		if (this.config_setting) {
			this.config_setting = null
		}
		super.DeleteMe()
	}

	public LoadSuccess() {

		let update_fun = (scmd?) => {
			if (((scmd && this.data) && this.data.type == scmd.type) && this.data.subtype == scmd.subtype) {
				this.data.is_open = scmd.is_open
				this.dataChanged()
			}
		}

		this.BindEvent(this.model, SettingModel.UPDATE_ONE_SETTING_INFO, update_fun)
	}

	public load_callback() {

		let click_fun = () => {
			if (this.data) {
				let mode = this.model.GetBlockKey(SettingModel.SettingType.SysSetting, this.data.subtype)
				if (mode) {
					this.CheckClickFun(mode)
				}
			}
		}

		Util.AddClickEvent(this.check_img, click_fun, this)
		Util.AddClickEvent(this.check_img_1,click_fun,this)
		if (this.needRefresh) {
			this.dataChanged()
		}
	}

	public dataChanged() {
		if(!super.dataChanged()) return
		//this.data = data
		this.cfg = this.data.cfg
		if (this.cfg && this.data) {
			this._lb_text.text = this.cfg.name
			if(PlatformManager.IsEyouEnPlatform()){
				this._lb_text.fontSize=20
			}

			if (this.data.is_open == 0) {
				// ResManager.GetInstance().SetImageSprite(this, this.check_img, "common_asset", "uity_045d")
				this.check_img.visible=true
				this.check_img_1.visible=false
			} else {
				this.check_img.visible=false
				this.check_img_1.visible=true
				// ResManager.GetInstance().SetImageSprite(this, this.check_img, "common_asset", "com_ui_gx1")
			}
		} else {
			this.needRefresh = true
		}
	}

	public SendProtocal(subtype?, is_open?) {

		if (this.data) {
			let setting_list = []
			table.insert(setting_list, this.model.Package10203ItemData(subtype, is_open, this.data.type))
			this.model.PackageAndSend10203(setting_list)

			//this.model.Fire(SettingModel.SETTING_REQUEST_PROTO, 10203, "ccc", this.data.type, subtype, is_open)
		}
	}

	public CheckClickFun(mode?) {

		//限制150级之前不能取消自动拾取
		if ((this.data.subtype == 17 || this.data.subtype == 18 || this.data.subtype == 19) &&
			RoleManager.GetInstance().GetMainRoleLevel() < 150 &&
			this.data.is_open == 1) {
			// if (PlatformMgr.GetInstance().IsEyouPlatform() ) {
			// 	Message.show("150級後可以變更設置")
			// } else if (PlatformMgr.GetInstance().IsAbroadPlatform() ) {
			// 	Message.show("This option can be deselected at Lv. 150 onwards")
			// }else{
			Message.show("150级后可取消选项")
			// }
			return
		}

		let is_simple_mode = this.model.GetBlockProperty(SettingModel.SettingType.SysSetting, "simple_mode")
		let not_block = this.data.subtype == 201
		let ok_func = () => {
			if (is_simple_mode == 1 && !not_block) {
				this.SendProtocal(Config.PRELOAD_CLIENT_CONFIG.ClientBlockConfig.BlockSubType["simple_mode"], 0)
			}
			// [ts2lua]lua中0和空字符串也是true，此处this.data.is_open == 1需要确认
			let open = (this.data.is_open == 1 ? (0) : (1))
			this.SendProtocal(this.data.subtype, open)
		}

		if (is_simple_mode == 1 && !not_block) {
			Alert.Show("您当前处于极简模式，是否确定退出该模式？", Alert_Type.Two, ok_func, null, "退出", "取消")
		} else {
			ok_func()
		}
	}


	public GetComponents() {
		[
			this.check_img,
			this._lb_text,
			this.check_img_1,
		]
			= this.GetChildrenByNames([

				"check_img",
				"_lb_text",
				"check_img_1"
			])
	}
}
window["SettingShieldItem"] = SettingShieldItem
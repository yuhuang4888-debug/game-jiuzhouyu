import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { OpenFun } from "../common/OpenFun"
import { ResManager } from "../common/ResManager"
import { Util } from "../util/Util"
import { RoleManager } from "../commonModel/RoleManager"

export class BossVipAddView extends BaseView1 {
	show_svip

	public constructor() {
		super()
		this.base_file = "bossPersonal"
		this.layout_file = "BossVipAddView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.use_background = true
		this.click_bg_toClose = true
		this.is_center = true

		this.load_callback = () => {
			this.LoadSuccess()
			this.InitEvent()
		}
	}

	private LoadSuccess() {
		ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg3, "resource/game/bossPersonal/other/com_tips.png")
		this._lb_vip1.style.fontSize = 18
		this._lb_vip1.style.color = "#5e6382"
		this._lb_vip1.style.wordWrap = false
		this._lb_vip1.innerHTML = "每日挑战次数<font color='#00b515'>+1</font>次"
		this._lb_vip2.style.fontSize = 18
		this._lb_vip2.style.color = "#5e6382"
		this._lb_vip2.style.wordWrap = false
		this._lb_vip2.innerHTML = "每日挑战次数<font color='#00b515'>+2</font>次"
		this._lb_svip.style.fontSize = 18
		this._lb_svip.style.color = "#5e6382"
		this._lb_svip.style.wordWrap = false
		this._lb_svip.innerHTML = "每日挑战次数额外<font color='#00b515'>+1</font>次"
		
		let main_role = RoleManager.GetInstance().GetMainRoleVo()
		this.show_svip = main_role.vip_flag >= 4
		this._gp_svip.visible = this.show_svip
		this._gp_vip.visible = !this.show_svip
		let icon_res = this.show_svip ? "ui_svip" : "ui_vip"
		ResManager.GetInstance().SetImageSprite(this, this._btn_go, "bossPersonal", icon_res)
		let str
		if (this.show_svip){
			str = "激活至尊VIP（永久）增加更多的专属大妖挑战次数"
		} else {
			str = "获取VIP特权卡增加更多的专属大妖挑战次数"
		}
		this._lb_tips.text = str
	}

	private InitEvent() {
		Util.AddClickEvent(this._btn_close, ()=>{
			this.Close()
		}, this, true)
		
		Util.AddClickEvent(this._btn_go, ()=>{
			if (this.show_svip){
				OpenFun.OpenFunHandler(226)
			} else {
				OpenFun.OpenFunHandler(8)
			}
			this.Close()
		}, this, true)
	}

	_img_bg: Laya.Image
	_img_bg2: Laya.Image
	_img_bg3: Laya.Image
	_gp_title: Laya.Image
	_lb_title: Laya.Label
	_gp_title2: Laya.Image
	_lb_title2: Laya.Label
	_btn_close: Laya.Image
	_lb_tips: Laya.Label
	_btn_go: Laya.Image
	_gp_vip: Laya.Box
	_lb_vip1: Laya.HTMLDivElement
	_lb_vip2: Laya.HTMLDivElement
	_img_vip1: Laya.Image
	_img_vip2: Laya.Image
	_gp_svip: Laya.Box
	_lb_svip: Laya.HTMLDivElement
	_img_svip: Laya.Image
	public GetComponents() {
		[
			this._img_bg,
			this._img_bg2,
			this._img_bg3,
			this._gp_title,
			this._lb_title,
			this._gp_title2,
			this._lb_title2,
			this._btn_close,
			this._lb_tips,
			this._btn_go,
			this._gp_vip,
			this._lb_vip1,
			this._lb_vip2,
			this._img_vip1,
			this._img_vip2,
			this._gp_svip,
			this._lb_svip,
			this._img_svip,
		]
			= this.GetChildrenByNames([
				"_img_bg",
				"_img_bg2",
				"_img_bg3",
				"_gp_title",
				"_lb_title",
				"_gp_title2",
				"_lb_title2",
				"_btn_close",
				"_lb_tips",
				"_btn_go",
				"_gp_vip",
				"_lb_vip1",
				"_lb_vip2",
				"_img_vip1",
				"_img_vip2",
				"_gp_svip",
				"_lb_svip",
				"_img_svip",
			])
	}
}
window["BossVipAddView"] = BossVipAddView
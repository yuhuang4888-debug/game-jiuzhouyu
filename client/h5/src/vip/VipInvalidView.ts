import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { OpenFun } from "../common/OpenFun"
import { ResManager } from "../common/ResManager"
import { RoleManager } from "../commonModel/RoleManager"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
import { Vector2 } from "../util/Vector2"

export class VipInvalidView extends BaseView1 {
	ui_bg: Laya.Image
	ui_girl: Laya.Image
	vip_title_img: Laya.Image
	vip_title_img2: Laya.Image
	close_btn: Laya.Image
	_Group1: Laya.Box
	point_1: Laya.Image
	point_2: Laya.Image
	point_3: Laya.Image
	point_4: Laya.Image
	point_5: Laya.Image
	point_6: Laya.Image
	label_1: Laya.Label
	label_2: Laya.Label
	label_3: Laya.Label
	label_4: Laya.Label
	label_5: Laya.Label
	label_6: Laya.Label
	get_btn: Laya.Box
	_Image11: Laya.Image
	labelDisplay: Laya.Label
	_Image1: Laya.Image
	_Label1: Laya.Label
	timer_label: Laya.Label
	InitCfg
	InitEvent
	InitView
	destroy_imm
	is_center
	preload_client_config
	show_open_movie
	use_background

	public static className = "VipInvalidView"
	public constructor() {
		super()

		this.base_file = "vip"
		this.layout_file = "VipTipsView"
		this.layer_value = Enum_UILayer.Activity
		this.is_center = true
		this.use_background = true
		this.show_open_movie = true
		this.destroy_imm = true
		let resMgr = ResManager.GetInstance()
		this.load_callback = () => {

			this.InitView()
			this.InitEvent()
			this.InitCfg()
		}

		// this.preload_client_config = [ClientVipPrivilege=false]
		this.InitCfg = () => {
			resMgr.LoadGameConfig(this, "ClientVipPrivilege", true, null, (cfg) => {
				if (cfg) {
					// [ts2lua]cfg下标访问可能不正确
					let tips_cfg = cfg[RoleManager.GetInstance().GetMainRoleVo().vip_flag]
					if (tips_cfg) {
						let tipsText = null
						let count = 0
						let i = 0
						do {
							tipsText = tips_cfg[i].tips
							if (tipsText && !tips_cfg[i].hide) {
								// tipsText = tipsText.gsub(RegExp("color='639c12'".length, "g"), "color='b3ff48'".length)
								tipsText = tipsText.gsub("color='639c12'".length, "color='b3ff48'".length)
								// [ts2lua]this下标访问可能不正确
								this["textlabel_" + (count + 1)].text = Util.StrToHTML(tipsText)
								count = count + 1
							}
							i = i + 1
						} while ((i < tips_cfg.length && count < 6))
						i = count
						do {
							// [ts2lua]this下标访问可能不正确
							if (this["objpoint_" + (i + 1)]) {
								// [ts2lua]this下标访问可能不正确
								// this["point_" + (i + 1].visible) = false
								this["objpoint_" + (i + 1)].visible = false
							}
							i = i + 1
						} while ((i < 6))
					}
				}
			})

		}

		this.InitView = () => {
			resMgr.SetOutsideImageSprite(this, this.ui_bg, GameResPath.GetIcon("vip", "uivip_044a"), true)
			resMgr.SetOutsideImageSprite(this, this.ui_girl, GameResPath.GetIcon("vip", "uivip_044b"), true)
			// this.vip_title_img.x = 360
			this.vip_title_img.pos(360,this.vip_title_img.y)//= Vector2(360, this.vip_title_img.anchoredPosition.y)
			// this.vip_title_img.source = "vip_asset.uivip_044e"
			// this.vip_title_img2.source = "vip_asset.uivip_044f"
			resMgr.SetImageSpriteTrans(this, this.vip_title_img, GameResPath.GetIcon("vip", "uivip_044e"), true)
			resMgr.SetImageSpriteTrans(this, this.vip_title_img2, GameResPath.GetIcon("vip", "uivip_044f"), true)
			// this.get_btn.label = "立即激活"
			this.labelDisplay.text = "激活VIP"
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this.get_btn, () => {
				OpenFun.OpenFunHandler(8)
				this.Close()
			}
				, this, true)
			Util.AddClickEvent(this.close_btn, () => {
				this.Close()
			}
				, this, true)
		}
	}
	public GetComponents() {
		[
			this.ui_bg,
			this.ui_girl,
			this.vip_title_img,
			this.vip_title_img2,
			this.close_btn,
			this._Group1,
			this.point_1,
			this.point_2,
			this.point_3,
			this.point_4,
			this.point_5,
			this.point_6,
			this.label_1,
			this.label_2,
			this.label_3,
			this.label_4,
			this.label_5,
			this.label_6,
			this.get_btn,
			this._Image11,
			this.labelDisplay,
			this._Image1,
			this._Label1,
			this.timer_label,
		]
			= this.GetChildrenByNames([

				"ui_bg",
				"ui_girl",
				"vip_title_img",
				"vip_title_img2",
				"close_btn",
				"_Group1",
				"point_1",
				"point_2",
				"point_3",
				"point_4",
				"point_5",
				"point_6",
				"label_1",
				"label_2",
				"label_3",
				"label_4",
				"label_5",
				"label_6",
				"get_btn",
				"_Image11",
				"labelDisplay",
				"_Image1",
				"_Label1",
				"timer_label",
			])
	}

}

window["VipInvalidView"] = VipInvalidView
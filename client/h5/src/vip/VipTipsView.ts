import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { VipModel } from "../commonModel/VipModel"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { Util, GlobalTimerQuest } from "../util/Util"

export class VipTipsView extends BaseView1 {
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
	CancelTime
	InitCfg
	InitEvent
	InitView
	SetTimerText
	close_callback
	destroy_imm
	is_center
	show_open_movie
	use_background


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
		let vipM = VipModel
		let vip_model = vipM.GetInstance()
		let local_time = TimeUtil
		let timer_id_ = null
		let auto_time_ = null
		this.load_callback = () => {

			this.InitView()
			this.InitEvent()
			this.InitCfg()
		}

		this.close_callback = () => {
			this.CancelTime()
		}

		this.InitCfg = () => {
			resMgr.LoadGameConfig(this,"ClientVipPrivilege",true,null,(cfg)=>{
				if (cfg) {
					let tips_cfg = cfg.vip_tips
					if (tips_cfg) {
						for (let i = 1; i <= 6; i++) {
							this["textlabel_" + i].textFlow = Util.StrToHTML(tips_cfg[i].tips)
						}
					}
				}
			})
			
		}

		this.InitView = () => {
			resMgr.SetOutsideImageSprite(this, this.ui_bg, GameResPath.GetIcon("vip", "uivip_044a"), true)
			resMgr.SetOutsideImageSprite(this, this.ui_girl, GameResPath.GetIcon("vip", "uivip_044b"), true)
			resMgr.SetImageSpriteTrans(this, this.vip_title_img, GameResPath.GetIcon("vip", "uivip_044h"), true)
			resMgr.SetImageSpriteTrans(this, this.vip_title_img2, GameResPath.GetIcon("vip", "uivip_044d"), true)
			this.CancelTime()
			auto_time_ = local_time.getClientTime() + 30

			// this.SetTimerText()
			// timer_id_ = GlobalTimerQuest.AddPeriodQuest(() => {
			// 	this.SetTimerText()
			// }, 1, -1)
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this.get_btn, () => {
				// vip_model.Fire(vipM.REQUEST_PROTO, 45007, "c", 1)
				this.Close()
			}
				, this, true)
			Util.AddClickEvent(this.close_btn, () => {
				this.Close()
			}
				, this, true)
		}

		this.SetTimerText = () => {
			if (auto_time_ - local_time.getClientTime() > 0) {
				if (this.timer_label) {
					this.timer_label.text = Math.floor(auto_time_ - local_time.getClientTime()) + "秒后自动领取"
				}
			} else {
				this.CancelTime()
				vip_model.Fire(vipM.REQUEST_PROTO, 45007, "c", 1)
				this.Close()
			}
		}

		this.CancelTime = () => {
			if (timer_id_) {
				GlobalTimerQuest.CancelQuest(timer_id_)
				timer_id_ = null
			}
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
window["VipTipsView"]=VipTipsView
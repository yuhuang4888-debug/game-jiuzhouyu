import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { BossModel } from "../commonModel/BossModel"
import { Message } from "../sysInfo/SysInfoController"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest, SetAnchoredPosition } from "../util/Util"

/**目测废弃 */
export class BossFieldVitView extends BaseView1 {
	item_list = []
	time_id
	local_x
	local_y
	public constructor(parent?) {
		super()

		this.base_file = "bossField"
		this.layout_file = "BossFieldVitView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.show_open_movie = true
		this.back_login_toClose = true
		this.use_background2 = true
		this.click_bg_toClose = true
		// this.hide_maincancas = false
		this.background_alpha = 0
		this.preload_client_config = {
			"ConfigBossFieldVitWay": false
		}
		this.preload_server_config = {
			"config_boss_type_key_value": false
		}
		this.load_callback = () => {
			this.LoadSuccess()
		}
		this.close_callback = () => {
			
		}
		this.destroy_callback = () =>{
			for (let _tmpi in this.item_list) {
				let obj = this.item_list[_tmpi]
				obj.DeleteMe()
			}
			this.item_list.length = 0
			this.ClearTimer()
		}
	}

	public SetData(x?, y?) {
		this.local_x = x 
		this.local_y = y 
	}

	public LoadSuccess() {
		// SetAnchoredPosition(this.gp, this._localX - ScreenWidth / 2, this._localY - ScreenHeight / 2)
		if(this.local_x && this.local_y){
			this.display_obj.x = this.local_x 
			this.display_obj.y = this.local_y - this.display_obj.height
		}
		this._panel_item.vScrollBarSkin = ""
		this.ShowWay()
		this.InitEvent()
	}
	public InitEvent() {

		this.BindEvent(BossModel.GetInstance(), BossModel.UPDATE_VIT_TIME, (scmd/**vit?, max_vit?, last_vit_time?*/) => {
			this.ShowVit(scmd.vit, scmd.max_vit, scmd.last_vit_time)
		}
		)

		BossModel.GetInstance().Fire(BossModel.SCMD_REQUEST, 46044, BossModel.BossType.field)
	}


	public ShowWay() {
		let item_class = window["BossFieldVitItem"]
		if(!item_class) return
		let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "ConfigBossFieldVitWay")
		for (let i = 0; i < cfg.length; i++) {
			let item = this.item_list[i] && this.item_list[i] || new item_class(this._vbox_item)
			this.item_list[i] = item
			item.Setdata(cfg[i])
			item.Load()
		}
	}


	public ShowVit(vit?, max_vit?, last_vit_time?) {
		let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_boss_type_key_value", false)
		let time = BossModel.GetInstance().GetBossKeyValue(BossModel.BossType.field, "add_vit_time", cfg)
		this.ClearTimer()
		if (vit == max_vit) {
			this._box_time.visible = false
			this._box_vitmax.visible = true
		} else {
			let add_vit = Math.floor((TimeUtil.getServerTime() - last_vit_time) / time)
			if (vit + add_vit >= max_vit) {
				this._box_time.visible = false
				this._box_vitmax.visible = true
			} else {
				this._box_time.visible = true
				this._box_vitmax.visible = false
				let end_time = last_vit_time + (max_vit - vit) * time
				if (!this.time_id) {
					this.time_id = GlobalTimerQuest.AddPeriodQuest(() => {
						let left_time = end_time - TimeUtil.getServerTime()
						if (left_time >= 0) {
							this._lb_time.text = TimeUtil.timeConvert(left_time, "hh:MM:ss")
							//
						} else {
							this.ClearTimer()
							this._box_time.visible = false
							this._box_vitmax.visible = true
						}
					}, 1, -1)
				}
				this._lb_time.text = TimeUtil.timeConvert(end_time - TimeUtil.getServerTime(), "hh:MM:ss")
			}
		}
	}

	public ClearTimer() {

		if (this.time_id) {
			GlobalTimerQuest.CancelQuest(this.time_id)
			this.time_id = null
		}
	}

	_box_con: Laya.Box
	_img_bg: Laya.Image
	_box_time: Laya.Box
	_lb_desc: Laya.Label
	_lb_time: Laya.Label
	_img_line: Laya.Image
	_box_vitmax: Laya.Box
	_lb_desc2: Laya.Label
	_panel_item: Laya.Panel
	_vbox_item: Laya.VBox
	public GetComponents() {
		[
			this._box_con,
			this._img_bg,
			this._box_time,
			this._lb_desc,
			this._lb_time,
			this._img_line,
			this._box_vitmax,
			this._lb_desc2,
			this._panel_item,
			this._vbox_item,
		]
			= this.GetChildrenByNames([

				"_box_con",
				"_img_bg",
				"_box_time",
				"_lb_desc",
				"_lb_time",
				"_img_line",
				"_box_vitmax",
				"_lb_desc2",
				"_panel_item",
				"_vbox_item",
			])
	}

}
window["BossFieldVitView"] = BossFieldVitView

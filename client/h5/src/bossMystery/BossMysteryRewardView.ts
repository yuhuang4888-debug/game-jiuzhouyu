import { BaseView1 } from "../common/BaseView1"
import { Util } from "../util/Util"
import { Enum_UILayer } from "../common/LayerManager"
import { BossModel } from "../commonModel/BossModel"
import { LoopScrowViewMgr, LoopScrCon} from "../common/LoopScrowViewMgr"

import { BossMysteryRewardItem } from "./BossMysteryRewardItem"
import { ResManager } from "../common/ResManager"

export class BossMysteryRewardView extends BaseView1 {
	InitContent
	InitEvent
	LoadSuccess
	OpenCallback
	_Local_Open

	loop_mgr
	model
	scroll_group
	stage_list
	cfg_kill

	public constructor() {
		super()
		this.base_file = "bossMystery"
		this.layout_file = "BossMysteryRewardView"
		this.layer_value = Enum_UILayer.Activity
		this.back_login_toClose = true
		this.destroy_imm = true
		this.use_background = true
		this.click_bg_toClose = true
		this.show_open_movie = true
		this.change_scene_close = true
		this.is_center = true
		this.preload_server_config = {
			"config_domain_kill_reward": false
		}
		
		this.model = BossModel.GetInstance()
		this.loop_mgr = null
		
		this.load_callback = () => {
			this.LoadSuccess()
			this.InitEvent()
		}

		this.open_callback = () => {
			this.OpenCallback()
		}

		this.destroy_callback = () => {
			if (this.loop_mgr) {
				this.loop_mgr.DeleteMe()
				this.loop_mgr = null
			}
		}

		this.LoadSuccess = () => {
			this.cfg_kill = ResManager.GetInstance().GetGameConfigFromCache(this, "config_domain_kill_reward", false)
			
			this._Label1.text = "击杀指定数量的首领可领取奖励(4点重置)"
			this._Scroller1.scrollBar.visible = false
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._img_close, ()=>{
				this.Close()
			}, this, true)

			let update_fun = () => {
				this.OpenCallback()
			}
			this.BindEvent(this.model, BossModel.UPDATE_MYSTERY_BOSS_REWARD, update_fun)
		}

		this._Local_Open = (parms?) => {
			super.Open()
		}

		this.OpenCallback = () => {
			if (this.model.mystery_boss_reward) {
				let [stage_list, reach, all_len] = this.model.GetMysteryBossRewardCfg(this.model.mystery_boss_reward.kill_num, this.cfg_kill)
				this.stage_list = stage_list

				this.InitContent()
			}
		}

		this.InitContent = () => {
			if (!this.loop_mgr) {
				this.loop_mgr = new LoopScrowViewMgr()
				this.loop_mgr.SetData(this._Scroller1, BossMysteryRewardItem, this.stage_list, LoopScrCon.Vertical)
			} else {
				this.loop_mgr.replaceAll(this.stage_list)
			}
		}
	}

	public Open(...new_args) {
		let params = new_args
		this._Local_Open(params)
	}

	bg_img: Laya.Image
	_Image1: Laya.Image
	_img_close: Laya.Image
	_Scroller1: Laya.List
	_Label1: Laya.Label
	_img_title: Laya.Image
	_lb_title: Laya.Label
	public GetComponents() {
		[
			this.bg_img,
			this._Image1,
			this._img_close,
			this._Scroller1,
			this._Label1,
			this._img_title,
			this._lb_title,
		]
			= this.GetChildrenByNames([

				"bg_img",
				"_Image1",
				"_img_close",
				"_Scroller1",
				"_Label1",
				"_img_title",
				"_lb_title",
			])
	}
}
window["BossMysteryRewardView"] = BossMysteryRewardView
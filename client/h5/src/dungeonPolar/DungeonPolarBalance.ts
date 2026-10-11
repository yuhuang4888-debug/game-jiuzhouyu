import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { BaseDungeonModel } from "../commonModel/BaseDungeonModel"
import { GameResPath } from "../util/GameResPath"
import { Trim, GlobalTimerQuest } from "../util/Util"
import { DungeonPolarBalanceItem } from "./DungeonPolarBalanceItem"
import { Config } from "../common/Config"

export class DungeonPolarBalance extends BaseView1 {
	CancelCountTime
	_model
	close_time
	UpdateView
	StartTimer
	left_time
	time_id

	item_list
	public constructor() {
		super()

		this.base_file = "dungeonPolar"
		this.layout_file = "DungeonPolarBalance"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.is_center = true
		this.use_background = true
		this.click_bg_toClose = true
		this.back_login_toClose = true
		let _arr = null
		let result_data = null
		this._model = BaseDungeonModel.GetInstance()
		let local_ResManager = ResManager.GetInstance()
		this.preload_server_config = {
			"config_week_dungeon_boss": false,
			"config_dungeon": false
		}
		this.close_time = 15
		this.load_callback = () => {
			this._scroller.vScrollBarSkin = ""
		}

		this.open_callback = () => {
			this.UpdateView()
			this.StartTimer()
		}

		this.UpdateView = () => {
			result_data = this._model.polarBalance
			if (!result_data) {
				return
			}

			let is_win = result_data.result_type == 1
			let bg_res = is_win ? "com_up2_bg1" : "com_up2_bg2"
			let title_img = is_win ? "ui_copy_64" : "ui_copy_67"
			local_ResManager.SetOutsideImageSprite(this, this._bg, GameResPath.GetIcon("dungeonCommon", bg_res))
			local_ResManager.SetImageSprite(this, this.state_img, "dungeonCommon", title_img)


			//布局
			let content_heigth = is_win ? 589 : 427
			this._bg.height = content_heigth
			this._Label1.y = this._bg.y + content_heigth + 10
			this._box.height = content_heigth


			this._gp_victory.visible = is_win
			this._gp_fairly.visible = !is_win

			if (result_data.result_type == 1) {
				let list = []
				for (let key in result_data.dun_rewards) {

					let reward = result_data.dun_rewards[key]
					if (reward.dun_rewards_list.length > 0) {
						table.insert(list, reward)
					}
				}
				let cfgs = local_ResManager.GetGameConfigFromCache(this, "config_week_dungeon_boss", false)
				let boss_cfg = []
				for (let key in cfgs) {

					let cfg = cfgs[key]
					if (Trim(cfg.rewards_view) != "[]") {
						boss_cfg[cfg.boss_id] = true
					}
				}
				let boss_list = []
				for (let key in result_data.role_boss_list) {

					let boss_reward = result_data.role_boss_list[key]
					if (boss_cfg[boss_reward.boss_id]) {
						table.insert(boss_list, boss_reward)
					}
				}

				let data = list.concat(boss_list)
				if(!this.item_list)this.item_list=[]
				let i = 0
				do {
					let info = data[i]
					let item = this.item_list[i]
					if (!item) {
						item = new DungeonPolarBalanceItem(this.Content)
						item.Load()
						this.item_list[i] = item
					}
					item.SetData(info)
					i = i + 1
				} while (i < data.length)


			} else {
				let cfgs = local_ResManager.GetGameConfigFromCache(this, "config_dungeon", false)
				let cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_dungeon.name, result_data.dun_id, false, cfgs)
				if (cfg) {
					this._lb_tilte.text = `很遗憾，您未能击杀${cfg.name}内大妖`
				}
			}
		}

		this.StartTimer = () => {
			this.CancelCountTime()
			this.left_time = this.close_time
			this.time_id = GlobalTimerQuest.AddPeriodQuest(() => {
				this.left_time = this.left_time - 1
				if (this.left_time <= 0) {
					this.Close()
				}
			}, 1)
		}

		this.CancelCountTime = () => {
			if (this.time_id) {
				GlobalTimerQuest.CancelQuest(this.time_id)
				this.time_id = null
			}
		}

		this.close_callback = () => {

			for (let _tmpi in this.item_list) {
				var item = this.item_list[_tmpi]
				item.DeleteMe()
			}
			this.item_list = []

			this._model.polarBalance = null
			this.CancelCountTime()
		}
	}

	public DeleteMe() {
		super.DeleteMe()
	}




	_box: Laya.Box
	_bg: Laya.Image
	state_img: Laya.Image
	_gp_victory: Laya.Box
	_gp_tip_img: Laya.Box
	_Image1: Laya.Image
	_lb_tips: Laya.Label
	_scroller: Laya.Panel
	Content: Laya.VBox
	_gp_fairly: Laya.Box
	_lb_tilte: Laya.Label
	_Label1: Laya.Label
	public GetComponents() {
		[
			this._box,
			this._bg,
			this.state_img,
			this._gp_victory,
			this._gp_tip_img,
			this._Image1,
			this._lb_tips,
			this._scroller,
			this.Content,
			this._gp_fairly,
			this._lb_tilte,
			this._Label1,
		]
			= this.GetChildrenByNames([

				"_box",
				"_bg",
				"state_img",
				"_gp_victory",
				"_gp_tip_img",
				"_Image1",
				"_lb_tips",
				"_scroller",
				"Content",
				"_gp_fairly",
				"_lb_tilte",
				"_Label1",
			])
	}
}
window["DungeonPolarBalance"] = DungeonPolarBalance
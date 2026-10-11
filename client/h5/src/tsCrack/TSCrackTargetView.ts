import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { TSCrackModel } from "../commonModel/TSCrackModel"
import { ErlangParser } from "../util/ErlangParser"
import { SetAnchoredPosition, Util } from "../util/Util"
import { TSCrackTabItem } from "./TSCrackTabItem"
import { TSCrackTargetItem } from "./TSCrackTargetItem"

export class TSCrackTargetView extends BaseView1 {
	_Image1: Laya.Image
	_Image2: Laya.Image
	_img_title: Laya.Image
	_img_close: Laya.Image
	_Image3: Laya.Image
	_list_tab_con: Laya.HBox
	Content: Laya.List
	Scr_Scroller1
	_list_item_con
	default_index
	item_loop_mgr
	now_index
	tab_item_list
	tab_name_list
	ts_crack_model
	_iid







	public static PersonReward = 0

	public static ServerReward = 1



	public constructor() {
		super()




		this.base_file = "tsCrack"

		this.layout_file = "TSCrackTargetView"

		this.layer_value = Enum_UILayer.Activity

		this.destroy_imm = true

		this.is_center = true

		this.use_background = true

		this.click_bg_toClose = true

		this.show_open_movie = true

		this.change_scene_close = true

		this.ts_crack_model = TSCrackModel.GetInstance()



		this.tab_name_list = ["每日目标", "本服目标"]



		this.default_index = TSCrackTargetView.PersonReward

		this.preload_server_config = {
			"config_chrono_rift_role_stage_reward": false,
			"config_chrono_rift_goal": false
		}

		this.tab_item_list = false



		this.load_callback = () => {

			this.LoadSuccess()

		}



		this.destroy_callback = () => {

			if (this.tab_item_list) {

				for (let _ in this.tab_item_list) {
					var obj = this.tab_item_list[_]

					obj.DeleteMe()

				}

				this.tab_item_list = false

			}



			if (this.item_loop_mgr) {

				this.item_loop_mgr.DeleteMe()

				this.item_loop_mgr = false

			}

			this.now_index = false

		}

	}



	public LoadSuccess() {








		//this.RegisterMask(this._list_item_con)

		this.InitTab()

		this.UpdatePersonRewardTabRed()

		this.UpdateServerRewardTabRed()

		this.SwitchTab(this.default_index)

		this.InitEvent()

	}



	public InitTab() {


		if (!this.tab_item_list) {

			this.tab_item_list = []

		}

		let item, obj

		for (let index in this.tab_name_list) {


			let name = this.tab_name_list[index]

			let item = this.tab_item_list[index]

			if (item == null) {

				item = new TSCrackTabItem(this._list_tab_con)

				this.tab_item_list[index] = item

				item.Load()

			}

			item.SetData({

				id: this._iid,

				name: name,

				index: index

			})

		}

	}



	public InitEvent() {


		this.BindEvent(this.ts_crack_model, TSCrackModel.CLICK_TAB, (id?, index?) => {

			if (this._iid == id) {

				this.SwitchTab(index)

			}

		})



		Util.AddClickEvent(this._img_close, () => {

			this.Close()

		}, this, true)



		this.BindEvent(this.ts_crack_model, TSCrackModel.UPDATE_SCRAMBLE_REWARD, () => {

			if (this.now_index == TSCrackTargetView.PersonReward) {

				this.UpdateView()

			}

		})



		this.BindEvent(this.ts_crack_model, TSCrackModel.UPDATE_SEASON_REWARD, () => {

			if (this.now_index == TSCrackTargetView.ServerReward) {

				this.UpdateView()

			}

		})



		this.BindEvent(this.ts_crack_model, TSCrackModel.REFRESH_RED_FLAG, (flag?) => {

			if (TSCrackModel.RedFlag.PersonReward == flag) {

				this.UpdatePersonRewardTabRed()

			} else if (TSCrackModel.RedFlag.ServerReward == flag) {

				this.UpdateServerRewardTabRed()

			}

		})



	}



	public SwitchTab(index?) {


		if (this.now_index == index) {

			return

		}

		let item = this.tab_item_list[this.now_index]

		if (item) {

			item.SetSelectState(false)

		}



		item = this.tab_item_list[index]

		if (item) {

			item.SetSelectState(true)

		}



		//SetAnchoredPosition(this.Content, 0, 0)



		this.now_index = index

		this.UpdateView()

	}



	public UpdatePersonRewardTabRed() {


		if (this.tab_item_list && this.tab_item_list[TSCrackTargetView.PersonReward]) {

			this.tab_item_list[TSCrackTargetView.PersonReward].SetRedState(this.ts_crack_model.HasRedFlag(TSCrackModel.RedFlag.PersonReward))

		}

	}



	public UpdateServerRewardTabRed() {


		if (this.tab_item_list && this.tab_item_list[TSCrackTargetView.ServerReward]) {

			this.tab_item_list[TSCrackTargetView.ServerReward].SetRedState(this.ts_crack_model.HasRedFlag(TSCrackModel.RedFlag.ServerReward))

		}

	}



	public UpdateView() {


		let list = []

		if (TSCrackTargetView.PersonReward == this.now_index) {

			ResManager.GetInstance().SetImageSprite(this, this._img_title, "tsCrack_asset", "uiskshmrzd_001", true)

			let scramble_reward_data = this.ts_crack_model.GetScrambleRewardData()

			let chrono_rift_role_stage_reward_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_chrono_rift_role_stage_reward", false)

			if (scramble_reward_data && chrono_rift_role_stage_reward_cfg) {

				let cfg = null

				for (let _tmpi in scramble_reward_data.act_list) {
					var vo = scramble_reward_data.act_list[_tmpi]

					cfg = chrono_rift_role_stage_reward_cfg[vo.stage]

					table.insert(list, {

						type: TSCrackTargetView.PersonReward,

						stage: vo.stage,

						status: vo.status,

						value: scramble_reward_data.value,

						need_value: cfg.value,

						reward: JSON.parse(cfg.reward)

					})

				}

			}

		} else if (TSCrackTargetView.ServerReward == this.now_index) {

			ResManager.GetInstance().SetImageSprite(this, this._img_title, "tsCrack_asset", "uiskshsjjl_001", true)

			let season_reward_data = this.ts_crack_model.GetSeasonRewardData()

			let chrono_rift_goal_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_chrono_rift_goal", false)

			if (season_reward_data && chrono_rift_goal_cfg) {

				let cfg = null

				for (let _tmpi in season_reward_data) {
					var vo = season_reward_data[_tmpi]

					cfg = chrono_rift_goal_cfg[vo.goal_id]

					table.insert(list, {

						type: TSCrackTargetView.ServerReward,

						goal_id: vo.goal_id,

						status: vo.status,

						value: vo.value,

						need_value: cfg.value,

						doc: cfg.doc,

						reward: JSON.parse(cfg.reward)

					})

				}

			}

		}



		if (this.item_loop_mgr) {

			this.item_loop_mgr.replaceAll(list)

		} else {
			this.item_loop_mgr = new LoopScrowViewMgr(this.layer_value)

			this.item_loop_mgr.SetData(this.Content, TSCrackTargetItem, list, LoopScrCon.Vertical)

		}



		// this.item_arr.replaceAll(list)

	}






	public GetComponents() {
		[
			this._Image1,
			this._Image2,
			this._img_title,
			this._img_close,
			this._Image3,
			this._list_tab_con,
			this.Content,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_Image2",
				"_img_title",
				"_img_close",
				"_Image3",
				"_list_tab_con",
				"Content",
			])
	}
}
window["TSCrackTargetView"] = TSCrackTargetView
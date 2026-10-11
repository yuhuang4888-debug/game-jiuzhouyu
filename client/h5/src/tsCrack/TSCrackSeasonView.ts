import { BaseView1 } from "../common/BaseView1"
import { CommonRewardItem } from "../common/CommonRewardItem"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { WordManager } from "../common/WordManager"
import { RoleManager } from "../commonModel/RoleManager"
import { TSCrackModel } from "../commonModel/TSCrackModel"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { HtmlColorTxt, SetAnchoredPosition, Util } from "../util/Util"
import { TSCrackSeasonRankItem } from "./TSCrackSeasonRankItem"
import { TSCrackSeasonRewardItem } from "./TSCrackSeasonRewardItem"
import { TSCrackTabItem } from "./TSCrackTabItem"

export class TSCrackSeasonView extends BaseView1 {
	_Image1: Laya.Image
	_Image2: Laya.Image
	_img_title: Laya.Image
	_img_close: Laya.Image
	_Image3: Laya.Image
	_list_tab_con: Laya.HBox
	_gp_reward: Laya.Box
	Content11: Laya.List
	_gp_rank: Laya.Box
	Content1: Laya.List
	_img_bg: Laya.Image
	Content: Laya.List
	_lb_rank: Laya.Label
	_img_rank: Laya.Image
	_lb_desc: Laya.HTMLDivElement
	_lb_reward_none: Laya.Label
	_lb_none: Laya.Label
	Scr_Scroller1
	Scr_Scroller2
	Scr_Scroller3
	_list_my_reward_con
	_list_rank_con
	_list_reward_con
	default_child_index
	my_rank_item_arr
	my_rank_loop_mgr
	now_index
	rank_item_arr
	rank_loop_mgr
	rank_mask_corners
	reward_item_arr
	reward_loop_mgr
	reward_mask_corners
	tab_arr
	tab_item_list
	tab_name_list
	ts_crack_model
	_iid
	default_index





	public static Stronghold = 0

	public static PersonRank = 1

	public constructor() {
		super()




		this.base_file = "tsCrack"

		this.layout_file = "TSCrackSeasonView"

		this.layer_value = Enum_UILayer.Activity

		this.destroy_imm = true

		this.is_center = true

		this.use_background = true

		this.click_bg_toClose = true

		this.show_open_movie = true

		this.change_scene_close = true



		this.ts_crack_model = TSCrackModel.GetInstance()



		this.tab_name_list = ["据点奖励", "个人排名"]

		this.default_index = TSCrackSeasonView.Stronghold



		// this.reward_item_arr = null

		this.rank_item_arr = null

		this.my_rank_item_arr = null

		this.preload_server_config = {
			"config_chrono_rift_role_rank_reward": false,
			"config_chrono_rift_castle_reward": false
		}

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



			if (this.reward_loop_mgr) {

				this.reward_loop_mgr.DeleteMe()

				this.reward_loop_mgr = false

			}



			if (this.rank_loop_mgr) {

				this.rank_loop_mgr.DeleteMe()

				this.rank_loop_mgr = false

			}



			if (this.my_rank_loop_mgr) {

				this.my_rank_loop_mgr.DeleteMe()

				this.my_rank_loop_mgr = false

			}

			this.now_index = false

		}



	}



	public LoadSuccess() {




		this.InitTab()

		this.SwitchTab(this.default_index)

		// this._list_tab_con.selectedIndex = this.default_index



		this.InitEvent()



		this.ts_crack_model.Fire(TSCrackModel.REQUEST_PROTO, 20409)

		ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("tsCrack", "uisksh_106"))

	}



	public InitTab() {


		if (!this.tab_item_list) {

			this.tab_item_list = []

		}

		// for (let key in this.tab_name_list) {


		// 	let obj = this.tab_name_list[key]

		// 	table.insert(this.tab_item_list, {name=obj, red_state=false})

		// }

		// this.tab_arr.source = this.tab_item_list

		// this.tab_arr.refresh()



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



		SetAnchoredPosition(this.Content11, 0, 0)

		SetAnchoredPosition(this.Content1, 0, 0)





		// this.reward_mask_corners = GetWorldCorners(this._list_reward_con)

		// this.rank_mask_corners = GetWorldCorners(this._list_rank_con)

		this.now_index = index

		this.UpdateView()

	}



	public UpdateView() {


		let list = []



		if (TSCrackSeasonView.Stronghold == this.now_index) {

			let chrono_rift_castle_reward_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_chrono_rift_castle_reward", false)

			let data = null

			let count = null

			for (let key in chrono_rift_castle_reward_cfg) {


				data = chrono_rift_castle_reward_cfg[key]

				count = this.ts_crack_model.GetCountByLv(data.lv)

				if (count > 0) {

					table.insert(list, {

						name: data.name,

						reward: JSON.parse(data.reward),

						count: count

					})

				}

			}

			this._lb_none.visible = list.length == 0

			this._lb_none.text = "当前未占领任何据点"



			// this.reward_item_arr.replaceAll(list)



			if (this.reward_loop_mgr) {

				this.reward_loop_mgr.replaceAll(list)

			} else {
				this.reward_loop_mgr = new LoopScrowViewMgr(this.layer_value)

				this.reward_loop_mgr.SetData(this.Content11, TSCrackSeasonRewardItem, list, LoopScrCon.Vertical)

			}

		} else if (TSCrackSeasonView.PersonRank == this.now_index) {

			let chrono_rift_role_rank_reward_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_chrono_rift_role_rank_reward", false)

			let person_rank_data = this.ts_crack_model.GetPersonRank()

			if (person_rank_data && chrono_rift_role_rank_reward_cfg) {

				let cfg = null

				for (let _tmpi in person_rank_data) {
					var vo = person_rank_data[_tmpi]

					cfg = chrono_rift_role_rank_reward_cfg[vo.rank]

					table.insert(list, {

						rank: vo.rank,

						server_num: vo.server_num,

						role_id: vo.role_id,

						role_name: vo.role_name,

						value: vo.value,



					})

				}

			}

			if (list.length < 10) {

				let i = list.length + 1

				do {

					table.insert(list, { rank: i, server_num: "", role_id: 0, role_name: "当前暂无上榜", value: 0 })

					i = i + 1

				} while ((i <= 10)

				)
			}



			if (this.rank_loop_mgr) {

				this.rank_loop_mgr.replaceAll(list)

			} else {
				this.rank_loop_mgr = new LoopScrowViewMgr(this.layer_value)

				this.rank_loop_mgr.SetData(this.Content1, TSCrackSeasonRankItem, list,LoopScrCon.Vertical)

			}





			// this.rank_item_arr.replaceAll(list)

			let my_data = null

			if (person_rank_data) {

				for (let _tmpi in person_rank_data) {
					var vo = person_rank_data[_tmpi]

					if (vo.role_id == RoleManager.GetInstance().GetMainRoleId()) {

						my_data = vo

						break

					}

				}

			}

			if (my_data) {

				this._lb_rank.text = "第" + WordManager.NumConvertStage(my_data.rank) + "名"
				this._lb_desc.style.fontSize = 20
				this._lb_desc.style.color = "#e92c03"
				this._lb_desc.style.wordWrap = false
				this._lb_desc.innerHTML = Util.StrToHTML("s" + my_data.server_num + "." + my_data.role_name + "<br>" + HtmlColorTxt("贡献:" + my_data.value, "'#a376ff'"))

				let cfg = null

				let reward = null

				for (let key in chrono_rift_role_rank_reward_cfg) {


					cfg = chrono_rift_role_rank_reward_cfg[key]

					if (cfg.min_rank <= my_data.rank && cfg.max_rank >= my_data.rank) {

						reward = JSON.parse(cfg.reward)

						break

					}

				}

				let reward_list = []

				if (reward) {

					for (let _tmpi in reward) {
						var vo = reward[_tmpi]

						table.insert(reward_list, {

							size: 68,

							vo: {

								style: vo[0],

								typeId: vo[1],

								count: vo[2]

							}
						})

					}

				}

				// this.my_rank_item_arr.replaceAll(reward_list)



				if (this.my_rank_loop_mgr) {

					this.my_rank_loop_mgr.replaceAll(reward_list)

				} else {
					this.my_rank_loop_mgr = new LoopScrowViewMgr(this.layer_value)

					this.my_rank_loop_mgr.SetData(this.Content, CommonRewardItem, reward_list, LoopScrCon.Horizontal)

				}





				this._lb_reward_none.visible = reward_list.length == 0
				this.Content.visible = reward_list.length != 0

			} else {
				this._lb_rank.text = "未上榜"
				this._lb_desc.style.fontSize = 20
				this._lb_desc.style.color = "#e92c03"
				this._lb_desc.style.wordWrap = false
				this._lb_desc.innerHTML = RoleManager.GetInstance().GetMainRoleVo().name

				this._lb_reward_none.visible = true
				this.Content.visible = false

			}

		}

		this._gp_reward.visible = this.now_index == TSCrackSeasonView.Stronghold

		this._gp_rank.visible = this.now_index == TSCrackSeasonView.PersonRank

	}








	public GetComponents() {
		[
			this._Image1,
			this._Image2,
			this._img_title,
			this._img_close,
			this._Image3,
			this._list_tab_con,
			this._gp_reward,
			this.Content11,
			this._gp_rank,
			this.Content1,
			this._img_bg,
			this.Content,
			this._lb_rank,
			this._img_rank,
			this._lb_desc,
			this._lb_reward_none,
			this._lb_none,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_Image2",
				"_img_title",
				"_img_close",
				"_Image3",
				"_list_tab_con",
				"_gp_reward",
				"Content11",
				"_gp_rank",
				"Content1",
				"_img_bg",
				"Content",
				"_lb_rank",
				"_img_rank",
				"_lb_desc",
				"_lb_reward_none",
				"_lb_none",
			])
	}
}
window["TSCrackSeasonView"] = TSCrackSeasonView
import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { Util } from "../util/Util"
import { ResManager } from "../common/ResManager"
import { ListDuobaoModel } from "../commonModel/ListDuobaoModel"
import { LoopScrowViewMgr, LoopScrCon } from "../common/LoopScrowViewMgr"
import { ListRankItem } from "./ListRankItem"
import { ListGoodsItem } from "./ListGoodsItem"
import { ErlangParser } from "../util/ErlangParser"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"

export class ListRankView extends BaseView1 {
	model
	res_mgr
	single_type
	player_loop_mgr
	server_loop_mgr
	goods_loop_mgr

	public constructor() {
		super()
		this.base_file = "listDuobao"
		this.layout_file = "ListRankView"
		this.layer_value = Enum_UILayer.Activity
		this.is_center = true
		this.use_background = true
		this.click_bg_toClose = true
		this.destroy_imm = true

		this.model = ListDuobaoModel.GetInstance()
		this.res_mgr = ResManager.GetInstance()
		this.single_type = true

		this.load_callback = () => {
			this.LoadSuccess()
			this.InitEvent()
		}

		this.close_callback = () => {
			this.Remove()
		}
	}

	private Remove() {
		this.single_type = true
		if (this.player_loop_mgr) {
			this.player_loop_mgr.DeleteMe()
			this.player_loop_mgr = null
		}
		if (this.server_loop_mgr) {
			this.server_loop_mgr.DeleteMe()
			this.server_loop_mgr = null
		}
		if (this.goods_loop_mgr) {
			this.goods_loop_mgr.DeleteMe()
			this.goods_loop_mgr = null
		}
	}

	private LoadSuccess() {
		this.model.Fire(ListDuobaoModel.REQUEST_SCMD, 33253, this.model.base_type, this.model.sub_type)
		this.res_mgr.SetOutsideImageSprite(this, this._img_bg, "resource/game/listDuobao/other/ui_content_bg2.png")
		this.res_mgr.SetOutsideImageSprite(this, this._gp_title, "resource/game/listDuobao/other/ui_cbdb_bg_12.png")

		this._lb_myrank.style.fontSize = 20
		this._lb_myrank.style.color = "#663915"
		this._lb_myrank.style.wordWrap = false
		this._lb_myscore.style.fontSize = 20
		this._lb_myscore.style.color = "#663915"
		this._lb_myscore.style.wordWrap = false
	}

	private InitEvent() {
		Util.AddClickEvent(this._btn_close, () => {
			this.Close()
		}, this, true)

		Util.AddClickEvent(this._btn_single, () => {
			if (this.single_type) {
				return
			}
			this.BtnClick(true)
		}, this, true)

		Util.AddClickEvent(this._btn_all, () => {
			if (!this.single_type) {
				return
			}
			this.BtnClick(false)
		}, this, true)

		this.BindEvent(this.model, ListDuobaoModel.UPDATE_RANK, () => {
			this.UpdateView()
		})
	}

	private BtnClick(single) {
		this.single_type = single
		this._lb_single.color = single ? "#ffffff" : "#403442"
		this._lb_all.color = single ? "#403442" : "#ffffff"
		let icon1 = single ? "ui_cbdb_03" : "ui_cbdb_04"
		let icon2 = single ? "ui_cbdb_04" : "ui_cbdb_03"
		this.res_mgr.SetImageSprite(this, this._btn_single, "listDuobao", icon1)
		this.res_mgr.SetImageSprite(this, this._btn_all, "listDuobao", icon2)

		this._player_rank.visible = single
		this._server_rank.visible = !single

		let cond = CustomActivityModel.GetInstance().GetActCondition(this.model.base_type, this.model.sub_type, "info")
		if (cond && cond.target) {
			this._lb_tips.text = "个人积分达到" + cond.target + "可获得区服排行奖励"
		}
		this._lb_tips.visible = !single
		this._lb_myrank.y = single ? 873 : 863
		this._lb_myscore.y = single ? 908 : 890
		let rank = single ? this.model.player_rank : this.model.server_rank
		let icon = "ui_rank4"
		if (rank > 0 && rank < 4) {
			icon = "ui_rank" + rank
			this._lb_rank.visible = false
		} else {
			this._lb_rank.visible = true
			this._lb_rank.fontSize = rank == 0 ? 18 : 36
			this._lb_rank.text = rank == 0 ? "未上榜" : rank
		}
		ResManager.GetInstance().SetImageSprite(this, this._img_rank, "listDuobao", icon)

		let name = single ? "我的" : "本区"
		this._lb_myrank.innerHTML = rank == 0 ? (name + "排名：<font color='#d15e00'>未上榜</font>") : (name + "排名：<font color='#d15e00'>第" + rank + "名</font>")
		let score = single ? this.model.player_score : this.model.server_score
		this._lb_myscore.innerHTML = name + "积分：<font color='#0a953e'>" + score + "</font>积分"

		if (single && rank > 0) {
			let reward_data = this.model.GetPlayerRankRewardByRank(rank)
			if (reward_data) {
				this._gp_reward.visible = true
				let list = []
				let reward = ErlangParser.GetInstance().Parse(reward_data)
				for (let i in reward) {
					let vo = reward[i]
					let type_id
					if (vo[0] == 0) {
						type_id = vo[1]
					}
					list.push([type_id, vo[2]])
				}
				if (!this.goods_loop_mgr) {
					this.goods_loop_mgr = new LoopScrowViewMgr()
					this.goods_loop_mgr.SetData(this._gp_reward, ListGoodsItem, list, LoopScrCon.Horizontal)
				} else {
					this.goods_loop_mgr.replaceAll(list)
				}
			}
		} else {
			this._gp_reward.visible = false
		}
	}

	private UpdateView() {
		this.BtnClick(this.single_type)
		let list1 = this.model.player_rank_list
		if (!this.player_loop_mgr) {
			this.player_loop_mgr = new LoopScrowViewMgr()
			this.player_loop_mgr.SetData(this._player_rank, ListRankItem, list1, LoopScrCon.Vertical)
		} else {
			this.player_loop_mgr.replaceAll(list1)
		}
		let list2 = this.model.server_rank_list
		if (!this.server_loop_mgr) {
			this.server_loop_mgr = new LoopScrowViewMgr()
			this.server_loop_mgr.SetData(this._server_rank, ListRankItem, list2, LoopScrCon.Vertical)
		} else {
			this.server_loop_mgr.replaceAll(list2)
		}
	}

	_img_bg: Laya.Image
	_img_bg2: Laya.Image
	_img_title: Laya.Image
	_btn_single: Laya.Image
	_lb_single: Laya.Label
	_btn_all: Laya.Image
	_lb_all: Laya.Label
	_btn_close: Laya.Image
	_gp_title: Laya.Image
	_lb_title: Laya.Label
	_player_rank: Laya.List
	_server_rank: Laya.List
	_gp_reward: Laya.List
	_img_rank: Laya.Image
	_lb_rank: Laya.Label
	_lb_myrank: Laya.HTMLDivElement
	_lb_myscore: Laya.HTMLDivElement
	_lb_tips: Laya.Label
	public GetComponents() {
		[
			this._img_bg,
			this._img_bg2,
			this._img_title,
			this._btn_single,
			this._lb_single,
			this._btn_all,
			this._lb_all,
			this._btn_close,
			this._gp_title,
			this._lb_title,
			this._player_rank,
			this._server_rank,
			this._gp_reward,
			this._img_rank,
			this._lb_rank,
			this._lb_myrank,
			this._lb_myscore,
			this._lb_tips,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_img_bg2",
				"_img_title",
				"_btn_single",
				"_lb_single",
				"_btn_all ",
				"_lb_all",
				"_btn_close",
				"_gp_title",
				"_lb_title",
				"_player_rank",
				"_server_rank",
				"_gp_reward",
				"_img_rank",
				"_lb_rank",
				"_lb_myrank",
				"_lb_myscore",
				"_lb_tips",
			])
	}
}
window["ListRankView"] = ListRankView
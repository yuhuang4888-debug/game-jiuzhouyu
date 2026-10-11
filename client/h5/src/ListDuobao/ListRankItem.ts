import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { LoopScrowViewMgr, LoopScrCon } from "../common/LoopScrowViewMgr"
import { ListGoodsItem } from "./ListGoodsItem"
import { ErlangParser } from "../util/ErlangParser"

export class ListRankItem extends BaseItemRenderer {
	WIDTH = 588
	HEIGT = 94
	loop_mgr

	public constructor() {
		super()
		this.base_file = "listDuobao"
		this.layout_file = "ListRankItem"

		this.load_callback = () => {
			this.LoadSuccess()
		}
		this.Load()
	}

	public DeleteMe() {
		if (this.loop_mgr) {
			this.loop_mgr.DeleteMe()
			this.loop_mgr = null
		}
		super.DeleteMe()
	}

	protected LoadSuccess() {
		this._gp_reward.hScrollBarSkin = ""
		this._lb_score.style.fontSize = 20
		this._lb_score.style.color = "#663915"
		this._lb_score.style.wordWrap = false
	}

	protected dataChanged() {
		if (!super.dataChanged()) {
			return
		}

		let rank = this.data.rank
		this._lb_rank.text = rank > 3 ? rank : ""
		let icon = rank > 3 ? "ui_rank4" : ("ui_rank" + rank)
		ResManager.GetInstance().SetImageSprite(this, this._img_rank, "listDuobao", icon)

		let list = []
		let reward = ErlangParser.GetInstance().Parse(this.data.reward)
		for (let i in reward) {
			let vo = reward[i]
			let type_id
			if (vo[0] == 0) {
				type_id = vo[1]
			}
			list.push([type_id, vo[2]])
		}
		if (!this.loop_mgr) {
			this.loop_mgr = new LoopScrowViewMgr()
			this.loop_mgr.SetData(this._gp_reward, ListGoodsItem, list, LoopScrCon.Horizontal)
		} else {
			this.loop_mgr.replaceAll(list)
		}

		if (this.data.rank_type == 1) {
			this.UpdatePlayer()
		} else if (this.data.rank_type == 2) {
			this.UpdateServer()
		}
	}

	private UpdatePlayer() {
		if (this.data.role_id) {
			this._lb_name.text = "s" + this.data.server_id + "." + this.data.role_name
			this._lb_name.color = "#d15e00"
			this._lb_score.innerHTML = "积分：<font color='#0a953e'>" + this.data.score + "</font>"
		} else {
			this._lb_name.text = "虚位以待"
			this._lb_name.color = "#663915"
			this._lb_score.innerHTML = "上榜条件：<font color='#0a953e'>" + this.data.need_score + "</font>积分"
		}
	}

	private UpdateServer() {
		if (this.data.server_id) {
			this._lb_name.text = "s" + this.data.server_id + "." + this.data.server_name
			this._lb_name.color = "#d15e00"
			this._lb_score.innerHTML = "积分：<font color='#0a953e'>" + this.data.score + "</font>"
		} else {
			this._lb_name.text = "虚位以待"
			this._lb_name.color = "#663915"
			this._lb_score.innerHTML = "上榜条件：<font color='#0a953e'>" + this.data.need_score + "</font>积分"
		}
	}

	_img_bg: Laya.Image
	_gp_reward: Laya.List
	_gp_msg: Laya.Box
	_img_rank: Laya.Image
	_lb_rank: Laya.Label
	_lb_name: Laya.Label
	_lb_score: Laya.HTMLDivElement
	public GetComponents() {
		[
			this._img_bg,
			this._gp_reward,
			this._gp_msg,
			this._img_rank,
			this._lb_rank,
			this._lb_name,
			this._lb_score,
		]
			= this.GetChildrenByNames([
				"_img_bg",
				"_gp_reward",
				"_gp_msg",
				"_img_rank",
				"_lb_rank",
				"_lb_name",
				"_lb_score",
			])
	}
}
window["ListRankItem"] = ListRankItem
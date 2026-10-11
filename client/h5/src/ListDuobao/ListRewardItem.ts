import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ListDuobaoModel } from "../commonModel/ListDuobaoModel"
import { LoopScrowViewMgr, LoopScrCon } from "../common/LoopScrowViewMgr"
import { ListGoodsItem } from "./ListGoodsItem"
import { ErlangParser } from "../util/ErlangParser"

export class ListRewardItem extends BaseItemRenderer {
	WIDTH = 588
	HEIGT = 94
	model
	loop_mgr

	public constructor() {
		super()
		this.base_file = "listDuobao"
		this.layout_file = "ListRewardItem"

		this.model = ListDuobaoModel.GetInstance()
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

	private LoadSuccess() {
		this._gp_item.hScrollBarSkin = ""
		this._lb_msg.style.fontSize = 20
		this._lb_msg.style.color = "#663915"
		this._lb_msg.style.wordWrap = false
		this._lb_score.style.fontSize = 20
		this._lb_score.style.color = "#663915"
		this._lb_score.style.wordWrap = false
	}

	protected dataChanged() {
		if (!super.dataChanged()) {
			return
		}

		this._img_have.visible = this.data[1] == 2
		let score = this.model.score
		let need_score = this.data[0].need_val
		this._lb_msg.innerHTML = "积分达到<font color='#0a953e'>" + need_score + "</font>可领取"
		let color = score >= need_score ? "'#0a953e'" : "'#e02020'"
		this._lb_score.innerHTML = "(<font color=" + color + ">" + score + "</font>/" + need_score + ")"

		let list = []
		let reward = ErlangParser.GetInstance().Parse(this.data[0].reward)
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
			this.loop_mgr.SetData(this._gp_item, ListGoodsItem, list, LoopScrCon.Horizontal)
		} else {
			this.loop_mgr.replaceAll(list)
		}
	}

	_img_bg: Laya.Image
	_img_have: Laya.Image
	_lb_msg: Laya.HTMLDivElement
	_lb_score: Laya.HTMLDivElement
	_gp_item: Laya.List
	public GetComponents() {
		[
			this._img_bg,
			this._img_have,
			this._lb_msg,
			this._lb_score,
			this._gp_item,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_img_have",
				"_lb_msg",
				"_lb_score",
				"_gp_item",
			])
	}
}
window["ListRewardItem"] = ListRewardItem
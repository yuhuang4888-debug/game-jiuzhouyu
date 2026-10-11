import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { CommonRewardItem } from "../common/CommonRewardItem"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { GameResPath } from "../util/GameResPath"
import { HtmlColorTxt, Util } from "../util/Util"

export class TSCrackSeasonRewardItem extends BaseItemRenderer {
	_img_bg: Laya.Image
	_lb_desc: Laya.Label
	_lb_desc0: Laya.HTMLDivElement
	Content: Laya.List
	Scr_Scroller1
	_list_reward_con
	item_loop_mgr

	public static width = 565
	public static height = 175
	WIDTH = 614
    HEIGT = 136


	public constructor(parent) {
		super()

		this.base_file = "tsCrack"
		this.layout_file = "TSCrackSeasonRewardItem"
		this.load_callback = () => {
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("tsCrack", "uisksh_108"))
		}
		this.Load()
	}

	

	public dataChanged() {
		if (super.dataChanged()) {
			let data = this.data
			let list = []
			this._lb_desc.text = "占领" + data.name + "点"
			this._lb_desc0.style.fontSize = 20
			this._lb_desc0.style.color = "#a44532"
			this._lb_desc0.style.wordWrap = false
			this._lb_desc0.innerHTML = Util.StrToHTML("当前拥有:" + HtmlColorTxt(data.count + "个", "'#79b20c'"))
			for (let _tmpi in data.reward) {
				var vo = data.reward[_tmpi]
				table.insert(list, { size: 75, vo: { style: vo[0], typeId: vo[1], count: vo[2] * data.count } })
			}
			if (this.item_loop_mgr) {
				this.item_loop_mgr.replaceAll(list)
			} else {
				this.item_loop_mgr = new LoopScrowViewMgr()
				this.item_loop_mgr.SetData(this.Content, CommonRewardItem, list, LoopScrCon.Horizontal)
			}

		}

		// this.reward_array.replaceAll(list)
	}

	public DeleteMe() {

		if (this.item_loop_mgr) {
			this.item_loop_mgr.DeleteMe()
			this.item_loop_mgr = false
		}
		super.DeleteMe()
	}



	public GetComponents() {
		[
			this._img_bg,
			this._lb_desc,
			this._lb_desc0,
			this.Content,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_lb_desc",
				"_lb_desc0",
				"Content",
			])
	}
}
window["TSCrackSeasonRewardItem"] = TSCrackSeasonRewardItem
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { CommonRewardItem } from "../common/CommonRewardItem"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { HtmlColorTxt, Util } from "../util/Util"

export class TSCrackSeasonRankItem extends BaseItemRenderer {
	_img_bg: Laya.Image
	Content: Laya.List
	_img_rank: Laya.Image
	_lb_desc: Laya.HTMLDivElement
	_lb_rank: Laya.Label
	Scr_Scroller1
	_list_reward_con
	item_loop_mgr



	public static width = 572

	public static height = 116

	WIDTH = 614
    HEIGT = 120


	public constructor(parent) {
		super()


		this.base_file = "tsCrack"

		this.layout_file = "TSCrackSeasonRankItem"
		this.load_callback = () => {
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("tsCrack", "uisksh_107"))
		}
		this.Load()
	}



	



	public dataChanged() {
		if (super.dataChanged()) {
			let data = this.data

			let list = []

			let reward = null

			let chrono_rift_role_rank_reward_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_chrono_rift_role_rank_reward", false)
			let cfg = null

			for (let key in chrono_rift_role_rank_reward_cfg) {


				cfg = chrono_rift_role_rank_reward_cfg[key]

				if (cfg.min_rank <= data.rank && cfg.max_rank >= data.rank) {

					reward = JSON.parse(cfg.reward)

					break

				}

			}

			if (reward) {

				for (let _tmpi in reward) {
					var vo = reward[_tmpi]

					table.insert(list, { size: 68, vo: { style: vo[0], typeId: vo[1], count: vo[2] } })

				}

			}



			if (this.item_loop_mgr) {

				this.item_loop_mgr.replaceAll(list)

			} else {
				this.item_loop_mgr = new LoopScrowViewMgr()

				this.item_loop_mgr.SetData(this.Content, CommonRewardItem, list, LoopScrCon.Horizontal)

			}


			this._lb_desc.style.fontSize = 20
			this._lb_desc.style.color = "#e92c03"
			this._lb_desc.style.align = "left"
			this._lb_desc.style.wordWrap = false
			this._lb_desc.style.lineHeight = 30
			this._lb_desc.width = 180
			if (data.role_id == 0) {

				this._lb_desc.innerHTML = data.role_name

			} else {
				
				this._lb_desc.innerHTML = Util.StrToHTML("s" + data.server_num + "." + data.role_name + "<br>" + HtmlColorTxt("贡献:" + data.value, "'#0094e9'"))

			}

			if (data.rank > 3) {

				this._img_rank.visible = false

				this._lb_rank.visible = true

				this._lb_rank.text = data.rank

			} else {
				this._lb_rank.visible = false

				this._img_rank.visible = true

				if (data.rank == 1) {

					ResManager.GetInstance().SetImageSprite(this, this._img_rank, "tsCrack", "ui_phb_11", true)

				} else if (data.rank == 2) {

					ResManager.GetInstance().SetImageSprite(this, this._img_rank, "tsCrack", "ui_phb_12", true)

				} else if (data.rank == 3) {

					ResManager.GetInstance().SetImageSprite(this, this._img_rank, "tsCrack", "ui_phb_13", true)

				}

			}
		}



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
			this.Content,
			this._img_rank,
			this._lb_desc,
			this._lb_rank,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"Content",
				"_img_rank",
				"_lb_desc",
				"_lb_rank",
			])
	}
}
window["TSCrackSeasonRankItem"] = TSCrackSeasonRankItem
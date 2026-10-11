import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { EquipmentItem } from "../common/EquipmentItem"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { ArenaModel } from "../commonModel/ArenaModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"

export class EudaemonRankItem extends BaseItemRenderer {

	WIDTH = 488
	HEIGT = 69

	rankStrList
	rewardList

	static rankStrList = ["ui_phb_11", "ui_phb_12", "ui_phb_13"];
	public constructor() {
		super()

		this.base_file = "eudaemon"
		this.layout_file = "EudaemonRankItem"


		

		this.load_callback = () => {
			this.LoadSuccess()
		}
		this.Load()
	}

	public LoadSuccess() {
		//resource/game/eudaemon/texture/ui_kf_dgxs006.png
		ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("eudaemon", "ui_kf_dgxs006"))
	}

	protected dataChanged() {
		if (super.dataChanged()) {
			if (this.data.rank > 3) {
				this._img_rank.visible = false
				this._lb_rank.text = this.data.rank
			} else {
				this._lb_rank.text = ""
				this._img_rank.visible = true
				ResManager.GetInstance().SetImageSprite(this, this._img_rank, "eudaemon", EudaemonRankItem.rankStrList[this.data.rank - 1], true)
			}
			let data = this.data.data
			if (data) {
				this._lb_name.text = "S" + data.server_num + "." + data.role_name
				if (data.index == 0) {
					this._lb_score.text = data.total_score
				} else if (data.index == 1) {
					this._lb_score.text = data.score
				} else if (data.index == 2) {
					this._lb_score.text = data.kill_num
				}
			} else {
				this._lb_name.text = "虚位以待"
				this._lb_score.text = ""
			}
			if (!this.rewardList) {
				this.rewardList = []
			}
			let cor = ArenaModel.GetInstance().mask_cor
			let listCfg = JSON.parse(this.data.Cfg.rewards)
			let i = 0
			if (i < listCfg.length) {
				do {
					let item = this.rewardList[i]
					if (!item) {
						item = new EquipmentItem(this._panel_item)
						item.Load()
						item.SetItemSize(45, 45)
						item.SetPosition(Number(i) * 51, 0)
						this.rewardList[i] = item
					} else {
						item.SetVisible(true)
					}
					let cfg = listCfg[i]
					let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(cfg[0], cfg[1])
					let goodsBasic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
					if (goodsBasic) {
						item.SetData(goodsBasic.type_id, cfg[2])
					}
					i = i + 1
				} while ((i < listCfg.length)
				)
			}
			let j = listCfg.length
			if (j < this.rewardList.length) {
				do {
					this.rewardList[j].SetVisible(false)
					j = j + 1
				} while ((j < this.rewardList.length)
				)
			}
		}
	}

	public DeleteMe() {
		if (this.rewardList) {
			for (let _tmpi in this.rewardList) {
				var vo = this.rewardList[_tmpi]
				vo.DeleteMe()
			}
			this.rewardList = null
		}
		super.DeleteMe()
	}
	_img_bg: Laya.Image
	_img_rank: Laya.Image
	_lb_rank: Laya.Label
	_lb_name: Laya.Label
	_lb_score: Laya.Label
	_panel_item: Laya.Panel
	public GetComponents() {
		[
			this._img_bg,
			this._img_rank,
			this._lb_rank,
			this._lb_name,
			this._lb_score,
			this._panel_item,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_img_rank",
				"_lb_rank",
				"_lb_name",
				"_lb_score",
				"_panel_item",
			])
	}
}
window["EudaemonRankItem"] = EudaemonRankItem
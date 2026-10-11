import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { EquipmentItem } from "../common/EquipmentItem"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { StarEquipModel } from "../commonModel/StarEquipModel"
import { StageShowView } from "../customActivity/StageShowView"
import { Util } from "../util/Util"
import { Config } from "../common/Config"

export class BossDomainRewardItem extends BaseItemRenderer {

	item: EquipmentItem
	InitEvents
	goods_model
	InitView
	_stage_show
	public WIDTH = 98
	public HEIGT = 98

	public constructor(parent?) {
		super()

		this.base_file = "bossdomain"
		this.layout_file = "BossDomainRewardItem"
		this.item = null
		this.goods_model = GoodsModel.GetInstance()
		this.load_callback = () => {

			this.InitEvents()
			this.InitView()
		}

		this.InitEvents = () => {
			Util.AddClickEvent(this.box, () => {
				if (!this.data) return
				if (!this._stage_show) {
					this._stage_show = new StageShowView()
				}

				if (this.data[0] && this.data[0][1]) {
					this._stage_show.Open(this.data, this.box, StageShowView.ShowArrow.UP, this.display_obj.x)
				}
			}, this, true)
		}


		this.InitView = () => {
			if (!this.data) {
				return
			}
			if (this.data[0][1]) {
				this.box.visible = true
				this.icon1.visible = true
				this.icon2.visible = false
				this.gpReward.visible = false
			} else {
				this.box.visible = false
				if (!this.item) {
					this.item = new EquipmentItem(this.gpReward)
					this.item.Load()
					this.item.SetUseMask(true)
					this.item.SetItemSize(98, 98)
				}
				this.item.ExcuteCallback(() => {
					let vo = this.goods_model.GetGoodsBasicByTypeId(this.data[1])
					if (vo) {
						this.item.SetData(vo.type_id)
						if (vo.type == 79 && vo.subtype >= 1 && vo.subtype <= 12) {
							let cfg = Config.PRELOAD_SERVER_CONFIG.config_constellation_equip
							let star = StarEquipModel.GetInstance().GetEquipStar(cfg, vo.type_id)
							this.item.SetStarEquipStar(vo.color, star)
						} else {
							this.item.SetStarEquipStar(vo.color, 0)
						}
					}
					// this.CoverEffect(this.icon1,Enum_UILayer.Activity)
					// this.CoverEffect(this.icon2,Enum_UILayer.Activity)
				}
				)

				let show = Number(this.data[3])
				this.gpReward.visible = true
				this.icon1.visible = show && show != 0 && (show == 1 || show == 3)
				this.icon2.visible = show && show != 0 && (show == 2 || show == 3)
			}
		}

		this.Load()
	}

	public dataChanged() {
		if (!super.dataChanged()) return
		this.InitView()
	}

	public DeleteMe() {

		if (this.item) {
			this.item.DeleteMe()
			this.item = null
		}

		if (this._stage_show) {
			this._stage_show.DeleteMe()
			this._stage_show = null
		}
		super.DeleteMe()
	}


	box: Laya.Image
	gpReward: Laya.Box
	icon1: Laya.Image
	icon2: Laya.Image
	public GetComponents() {
		[
			this.box,
			this.gpReward,
			this.icon1,
			this.icon2,
		]
			= this.GetChildrenByNames([

				"box",
				"gpReward",
				"icon1",
				"icon2",
			])
	}
}
window["BossDomainRewardItem"] = BossDomainRewardItem
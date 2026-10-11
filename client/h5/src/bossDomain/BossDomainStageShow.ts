
///**
//* 数据
//* 中心对象
//* 展示方向

import { BaseView1 } from "../common/BaseView1"
import { EquipmentItem } from "../common/EquipmentItem"
import { Enum_UILayer, LayerManager } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { GoodsModel } from "../commonModel/GoodsModel"
import { StarEquipModel } from "../commonModel/StarEquipModel"
import { Mathf } from "../util/Mathf"
import { SetSizeDeltaX, GetSizeDeltaX, GetSizeDeltaY, SetAnchoredPositionX, SetAnchoredPositionY, SetAnchoredPosition } from "../util/Util"
import { Config } from "../common/Config"

//*/
export class BossDomainStageShow extends BaseView1 {
	LoadSuccess
	Local_Open
	Remove
	awardList
	background_alpha
	click_bg_toClose
	close_callback
	destroy_imm
	initView
	setPosition
	use_background
	_data
	_obj
	_pos
	_arrow
	_tagetW

	public static ShowArrow = {
		UP: "up"
	}
	public constructor() {
		super()


		this.awardList = []
		this._data = null
		this._obj = null
		this._pos = null
		this._arrow = null

		this.base_file = "bossdomain"
		this.layout_file = "BossDomainStageShow"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.click_bg_toClose = true
		this.use_background = true
		this.background_alpha = 0
		let view_width_max = 485
		let cell_width = 80
		let goods_model = GoodsModel.GetInstance()

		this.load_callback = () => {
			this.scroller.hScrollBarSkin = ""
			this.LoadSuccess()
		}

		this.close_callback = () => {
			this.Remove()
		}

		this.Remove = () => {
			for (let key in this.awardList) {

				let item = this.awardList[key]
				item.DeleteMe()
			}
			this.awardList = []
		}

		this.LoadSuccess = () => {
			this.initView()
			this.setPosition()
		}

		this.Local_Open = (parms?) => {
			this._data = parms[0]
			this._obj = parms[1]
			this._arrow = parms[2]
			this._tagetW = parms[3]

			this._pos = this._obj.localToGlobal(new Laya.Point(0, 0))
			super.Open()
		}

		this.initView = () => {
			if (!this._data || !this.is_loaded) {
				return
			}
			let index = 0
			for (let key in this._data) {

				index = index + 1
				let info = this._data[key]
				let item: EquipmentItem = this.awardList[index]
				if (!item) {
					item = new EquipmentItem(this._gp_reward, null, this.layer_value)
					item.Load()
					item.SetItemSize(cell_width, cell_width)
					item.SetUseMask(true)
					table.insert(this.awardList, item)
				}
				item.ExcuteCallback(() => {
					let [type_id, lock] = goods_model.GetMappingTypeId(info[0], info[1])
					let goods_vo = goods_model.GetGoodsBasicByTypeId(type_id)
					if (goods_vo) {
						let num = Number(info[2])
						num = num > 1 && num || 0
						item.SetData(type_id, num)
					}

					if (goods_vo && goods_vo.type == 79 && goods_vo.subtype >= 1 && goods_vo.subtype <= 12) {
						//需要确保自己的模块已经加载过这个配置
						let cfg = Config.PRELOAD_SERVER_CONFIG.config_constellation_equip
						let star = StarEquipModel.GetInstance().GetEquipStar(cfg, goods_vo.type_id)
						item.SetStarEquipStar(goods_vo.color, star)
					} else {
						item.SetStarEquipStar(goods_vo.color, 0)
					}
				})
			}


			let content_width = this._gp_reward.space * (index - 1) + index * cell_width
			let view_width = Mathf.Min(content_width, view_width_max)

			SetSizeDeltaX(this.bg, view_width + 20)
			SetSizeDeltaX(this.scroller, view_width)
			SetSizeDeltaX(this.display_obj, view_width + 20)

			this.scroller.hScrollBar.touchScrollEnable = content_width >= view_width_max
		}

		this.setPosition = () => {
			SetAnchoredPosition(this.display_obj, this._pos.x + this._obj.width / 2, this._pos.y - 130)
		}

	}

	public Open(...new_args) {

		let parms = new_args
		this.Local_Open(parms)
	}


	bg: Laya.Image
	scroller: Laya.Panel
	_gp_reward: Laya.HBox
	arrow_up: Laya.Image
	public GetComponents() {
		[
			this.bg,
			this.scroller,
			this._gp_reward,
			this.arrow_up,
		]
			= this.GetChildrenByNames([

				"bg",
				"scroller",
				"_gp_reward",
				"arrow_up",
			])
	}
}
window["BossDomainStageShow"] = BossDomainStageShow
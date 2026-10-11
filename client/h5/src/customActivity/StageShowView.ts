
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

//*/
export class StageShowView extends BaseView1 {
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
		UP: "up",
		DOWN: "down",
		LEFT: "left",
		RIGHT: "right",
		CENTERED: "centered"
	}
	public constructor() {
		super()


		this.awardList = []
		this._data = null
		this._obj = null
		this._pos = null
		this._arrow = null

		this.base_file = "customActivity"
		this.layout_file = "StageShowView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.click_bg_toClose = true
		this.use_background = true
		this.background_alpha = 0

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
				let item = this.awardList[index]
				if (!item) {
					item = new EquipmentItem(this._gp_reward, null, this.layer_value)
					item.Load()
					item.SetScale(0.7)
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
						let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_constellation_equip", false)
						let star = StarEquipModel.GetInstance().GetEquipStar(cfg, goods_vo.type_id)
						item.SetStarEquipStar(goods_vo.color, star)
					} else {
						item.SetStarEquipStar(goods_vo.color, 0)
					}
				})
			}

			SetSizeDeltaX(this.bg, Mathf.Min(index * 92.5 + 14, 384))
			let view_width = Mathf.Min(index * 92.5, 368)
			SetSizeDeltaX(this.scroller, view_width)
			SetSizeDeltaX(this.display_obj, view_width)

			this.scroller.hScrollBar.touchScrollEnable = view_width >= 368
		}

		this.setPosition = () => {
			if (!this._arrow) {
				this._arrow = StageShowView.ShowArrow.UP
			}
			this["arrow_" + this._arrow].visible = true

			let offsetX = 0
			let offsetY = 0
			if (StageShowView.ShowArrow.CENTERED == this._arrow) {
				// offsetY = -GetSizeDeltaY(this.display_obj)
				this._pos.x = this._pos.x - (this.bg.width / 2 / 2) - (this.arrow_centered.width / 2);
				this._pos.y = this._pos.y - this.display_obj.height - this.arrow_centered.height / 2;
			} else if (StageShowView.ShowArrow.UP == this._arrow) {

				let sc_w = Laya.stage.width
				let sc_h = Laya.stage.height

				offsetY = -GetSizeDeltaY(this.display_obj)
				//往右拓展还是往左拓展
				let cur_x = this.display_obj.width + this._pos.x
				let dir = cur_x > sc_w ? 1 : 2//1往左  2往右  3居中

				let width = GetSizeDeltaX(this._obj)
				let delta_x = width - 93;
				offsetX = (width / 2 - delta_x) / 2

				let arrowX = GetSizeDeltaX(this._obj) / 2 - GetSizeDeltaX(this.arrow_up) / 2
				if (this._tagetW) {
					arrowX = delta_x - this.arrow_up.x / 2 + this._tagetW / 2
				}
				SetAnchoredPositionX(this.arrow_up, arrowX)

			} else if (StageShowView.ShowArrow.DOWN == this._arrow) {
				let width = GetSizeDeltaX(this._obj)
				let delta_x = width - 93
				offsetX = - (width / 2 - delta_x)
				offsetY = - GetSizeDeltaY(this._obj)

				let arrowX = GetSizeDeltaX(this.display_obj) / 2 - GetSizeDeltaX(this.arrow_down) / 2
				if (this._tagetW) {
					arrowX = delta_x - this.arrow_down.x / 2 + this._tagetW / 2
				}
				SetAnchoredPositionX(this.arrow_down, arrowX)
			} else if (StageShowView.ShowArrow.LEFT == this._arrow) {
				offsetX = - GetSizeDeltaX(this.display_obj) - 23
				let height = GetSizeDeltaY(this._obj)
				let delta_y = height - 69
				offsetY = height / 2 - delta_y

				let a = GetSizeDeltaX(this.arrow_left)
				let arrowY = height / 2 - GetSizeDeltaX(this.arrow_left) / 2
				SetAnchoredPositionY(this.arrow_left, -arrowY)
			} else if (StageShowView.ShowArrow.RIGHT == this._arrow) {
				offsetX = GetSizeDeltaX(this._obj) + 23
				let height = GetSizeDeltaY(this._obj)
				let delta_y = height - 69
				offsetY = height / 2 - delta_y

				let arrowY = height / 2 - GetSizeDeltaX(this.arrow_right) / 2
				SetAnchoredPositionY(this.arrow_right, -arrowY)
			}

			SetAnchoredPosition(this.display_obj, this._pos.x + offsetX, this._pos.y + offsetY)
		}

	}

	public Open(...new_args) {

		let parms = new_args
		this.Local_Open(parms)
	}


	bg: Laya.Image
	scroller: Laya.Panel
	_gp_reward: Laya.HBox
	arrow_down: Laya.Image
	arrow_up: Laya.Image
	arrow_right: Laya.Image
	arrow_left: Laya.Image
	arrow_centered: Laya.Image
	public GetComponents() {
		[
			this.bg,
			this.scroller,
			this._gp_reward,
			this.arrow_down,
			this.arrow_up,
			this.arrow_right,
			this.arrow_left,
			this.arrow_centered,
		]
			= this.GetChildrenByNames([

				"bg",
				"scroller",
				"_gp_reward",
				"arrow_down",
				"arrow_up",
				"arrow_right",
				"arrow_left",
				"arrow_centered",
			])
	}
}
window["StageShowView"] = StageShowView
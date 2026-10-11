import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { GameResPath } from "../util/GameResPath"
import { Util, SetAnchoredPositionY } from "../util/Util"
import { BaseView1 } from "./BaseView1"
import { CongratulationObtainItem2 } from "./CongratulationObtainItem2"
import { CongratulationRareView } from "./CongratulationRareView"
import { Enum_UILayer } from "./LayerManager"
import { ResManager } from "./ResManager"

export class CongratulationObtainAutoView extends BaseView1 {


	cache_data
	SetBtnData
	SetGoodsData
	SetItemData
	CreateOneItem
	SetBtn
	Init
	Open_Callback
	percentWidth
	percentHeight

	anim_num//动画做到第几个了
	RollAnim
	anim_row//动画做到第几行了
	StopAuto

	public constructor(base_type, sub_type) {
		super()

		this.base_file = "common"
		this.layout_file = "CongratulationObtainAutoView"
		this.layer_value = Enum_UILayer.Activity
		this.background_alpha = 0.7
		//this.is_center = true
		this.use_background = true
		this.destroy_imm = true
		this.click_bg_toClose = false
		this.percentWidth = 100
		this.percentHeight = 100
		this.not_show_item_use = true
		let goods_model = GoodsModel.GetInstance()
		let _item_list = []
		let count = 0
		let _goods_data = null
		let _btn_data = null
		let _item_data = null
		let item_size = 95
		let is_anime = true
		let needs_load = false
		let base_type_ = base_type
		let sub_type_ = sub_type
		this.anim_num = 0
		this.anim_row = 0
		this.load_callback = () => {
			this.bottom_label.visible = false
			this.Init()
			this.SetBtn()

			this.goods_scroller.vScrollBarSkin = ""
			if (needs_load && this.cache_data) {
				needs_load = false
				this.anim_num = 0
				this.anim_row = 0
				_goods_data = this.cache_data
				this.SetItemData()
				this.CreateOneItem()
			}
		}

		this.open_callback = () => {
			this.Open_Callback()
		}

		this.close_callback = () => {
			Laya.Tween.clearAll(this.goods_scroller)
			this.ClearUIEffect(this._gp_blackline_effect)
			CustomActivityModel.GetInstance().Fire(CustomActivityDefine.EVENT.CLEAR_AUTO_VIEW)
			if (_item_list) {
				let i = 0
				if (i < _item_list.length) {
					do {
						let item = _item_list[i]
						if (item) {
							item.DeleteMe()
						}
						i = i + 1
					} while ((i < _item_list.length)
					)
				}

				_item_list = []
			}


			is_anime = true
			needs_load = false
			this.cache_data = null

		}

		this.Open_Callback = () => {
			this.AddUIEffect("ui_ZiTi_Huode", this._gp_blackline_effect, null, 128/40, true)
		}

		this.Init = () => {
			ResManager.GetInstance().SetTexture(this, this.left_bg, GameResPath.GetIcon("common4", "uijs_062"))

			Util.AddClickEvent(this.click_bg, () => {
				if (is_anime == false) {
					this.Close()
				}
			}, this, false)


			this.BindEvent(CustomActivityModel.GetInstance(), CustomActivityDefine.EVENT.STOP_AUTO, () => {
				this.StopAuto()
			})

		}

		this.StopAuto = () => {
			is_anime = false
			this.bottom_label.visible = true
			this.btn.visible = false
		}

		this.SetBtnData = (btn_data?) => {
			_btn_data = btn_data
		}

		this.SetGoodsData = (data?) => {
			_goods_data = data
			if (this.is_loaded) {
				this.SetItemData()
				this.CreateOneItem()
				
			} else {
				needs_load = true
				this.cache_data = data
			}
		}

		this.SetItemData = () => {
			let good_item_num = 0
			let data = []
			let i = 0
			if (i < _goods_data.length) {
				do {
					let [type_id, lock] = goods_model.GetMappingTypeId(_goods_data[i][0], _goods_data[i][1])
					let goods_vo = goods_model.GetGoodsBasicByTypeId(type_id)
					let max_overlap = (goods_vo && goods_vo.max_overlap && (goods_vo.max_overlap) || (999))
					let goods_num = (goods_vo && goods_vo.max_overlap == 0 && (1) || (_goods_data[i][2]))
					let create_num = (goods_vo && goods_vo.max_overlap == 0 && (_goods_data[i][2]) || (1))
					create_num = Number(create_num)
					good_item_num = good_item_num + create_num
					let j = 0
					if (j < Number(create_num)) {
						do {
							//如果有[3] 则表示数据中有goods_id 显示背包里对应的装备
							if (_goods_data[i] && _goods_data[i][3]) {
								data.push([type_id, goods_num, lock, _goods_data[i][3]])
							} else {
								data.push([type_id, goods_num, lock])
							}
							j = j + 1
						}
						while ((j < create_num))
					}
					i = i + 1
				}
				while ((i < _goods_data.length))
			}

			_item_data = data
		}

		this.CreateOneItem = () => {
			count = count + 1
			let item = _item_list[count - 1]
			if (!item) {
				item = new CongratulationObtainItem2(this.Content)
				item.Load()
				item.SetAnchorXY(0.5)
				_item_list.push(item)
			}

			//位置
			let col = 5
			let cell_index = count - 1
			let cell_width = 95
			let cell_hgap = 15
			let cell_vgap = 15
			let head_space = -17   //偏移量 17
			let row_num = Math.ceil((cell_index + 1) / col)  //第几行  从1开始
			let col_num = Math.ceil(cell_index % col) + 1  //第几列  从1开始
			let cell_x = (col_num - 1) * cell_width + (col_num - 1) * cell_hgap + head_space //+ cell_width / 2
			let cell_y = (row_num - 1) * cell_width + (row_num - 1) * cell_vgap //+ cell_width / 2
			item.SetPosition(cell_x, cell_y)


			//加载完成调用
			item.ExcuteCallback(() => {

				item.SetData(_item_data[0][0], _item_data[0][1], _item_data[0][2], null, item_size)

				let goods_base = goods_model.GetGoodsBasicByTypeId(_item_data[0][0])
				if ((goods_base && goods_base.color >= 4) && item.award_item) {
					item.award_item.ExcuteCallback(() => {
						if (item.award_item) {
							item.award_item.SetBoxEffect(goods_base.color)
						}
					}
					)

				}

				item.SetAlpha(1)
				item.PlayAnimtion(200)
				this.RollAnim(col, cell_width, cell_vgap)

			}
			)

			if (base_type_ == 102 && CustomActivityModel.GetInstance().IsRareReward(_goods_data)) {
				this.StopAuto()
				let view = new CongratulationRareView()
				view.SetData(_item_data[0], 2)
				view.Open()
			}

		}

		this.RollAnim = (col, cell_width, cell_vgap) => {
			//顺便滚动下
			this.anim_num++
			let ar = Math.ceil(this.anim_num / col)  //第几行  从1开始
			if (this.anim_row != ar) {
				let roll_y = (this.anim_row - 1) * cell_width + (this.anim_row - 1) * cell_vgap
				this.anim_row = ar
				Laya.Tween.clearAll(this.goods_scroller)
				this.goods_scroller.scrollTo(0, roll_y)
				Laya.Tween.to(this.goods_scroller.vScrollBar, { value: roll_y }, 200)
			}

		}

		this.SetBtn = () => {
			if (!_btn_data) { return }
			this.labelDisplay.text = _btn_data.text && _btn_data.text || "停止"
			if (_btn_data.call_back_func) {
				let func = _btn_data.call_back_func
				Util.AddClickEvent(this.btn, func, this, true)

			}
			this.btn.visible = true
		}
	}


	click_bg: Laya.Box
	_gp_view: Laya.Box
	_gp_borderglow_effect: Laya.Box
	mainGp: Laya.Box
	left_bg: Laya.Image
	goods_scroller: Laya.Panel
	Content: Laya.Box
	_img_point: Laya.Image
	btn: Laya.Box
	_Image1: Laya.Image
	labelDisplay: Laya.Label
	_Group1: Laya.Box
	bottom_label: Laya.Label
	_gp_blackline_effect: Laya.Box
	public GetComponents() {
		[
			this.click_bg,
			this._gp_view,
			this._gp_borderglow_effect,
			this.mainGp,
			this.left_bg,
			this.goods_scroller,
			this.Content,
			this._img_point,
			this.btn,
			this._Image1,
			this.labelDisplay,
			this._Group1,
			this.bottom_label,
			this._gp_blackline_effect,
		]
			= this.GetChildrenByNames([

				"click_bg",
				"_gp_view",
				"_gp_borderglow_effect",
				"mainGp",
				"left_bg",
				"goods_scroller",
				"Content",
				"_img_point",
				"btn",
				"_Image1",
				"labelDisplay",
				"_Group1",
				"bottom_label",
				"_gp_blackline_effect",
			])
	}
}
window["CongratulationObtainAutoView"] = CongratulationObtainAutoView
import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { RuneTreasureEvent, RuneTreasureModel } from "../commonModel/RuneTreasureModel"
import { Util } from "../util/Util"
import { RuneResultItem } from "./RuneResultItem"
import { LayerManager } from "../common/LayerManager"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { SoundManager } from "../common/SoundManager"
import { GoodsModel } from "../commonModel/GoodsModel"

export class RuneTreasureResultView extends BaseView1 {
	model
	data
	item_list
	anim_end_num = 0
	click_close = false
	chip_id = 36100002
	is_animing = false
	goods_model

	public constructor(data) {
		super()
		this.base_file = "runeTreasure"
		this.layout_file = "RuneTreasureResultView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.use_background = true
		this.is_center = true

		this.model = RuneTreasureModel.GetInstance()
		this.goods_model = GoodsModel.GetInstance()
		this.data = data
		this.item_list = []

		this.load_callback = () => {
			this.display_obj.width = LayerManager.GetInstance().stageWidth
			this.display_obj.height = LayerManager.GetInstance().stageHeight
			this.InitEvent()
		}

		this.open_callback = () => {
			this.InitView()
		}

		this.close_callback = () => {
			this.model.treasure_rune_lock = false
		}

		this.destroy_callback = () => {
			this.Remove()
		}
	}

	public Remove() {
		for (let i in this.item_list) {
			let item = this.item_list[i]
			item.DeleteMe()
		}
		this.item_list = []
		this.data = null
		this.is_animing = false
	}

	public InitEvent() {
		Util.AddClickEvent(this._btn_click, () => {
			if (this.click_close) {
				this.Close()
			} else {
				this.PlayAnim()
			}
		}, this, true)

		Util.AddClickEvent(this._img_chip, () => {
			UIToolTipMgr.GetInstance().AppendGoodsTips(this.chip_id)
		}, this, true)

		this.BindEvent(this.model, RuneTreasureEvent.RUNE_ANIM_END, () => {
			this.anim_end_num = this.anim_end_num + 1
			if (this.anim_end_num >= this.data.reward_list.length) {
				SoundManager.GetInstance().PlaySoundEffect("fighting_up", true, null, "role")
				this.click_close = true
				this._lb_tips.text = "点击空白处关闭界面"
			}
		})
	}

	public InitView() {
		let reward_list = this.data.reward_list
		this._lb_num.text = "x" + this.data.chip_num
		let show_one = reward_list.length == 1
		this._gp_one.visible = show_one
		this._gp_ten.visible = !show_one
		if (show_one) {
			this.InitOne(reward_list)
		} else {
			this.InitTen(reward_list)
		}

		let color = 0
		for (let i in reward_list) {
			let vo = reward_list[i]
			let basic = this.goods_model.GetGoodsBasicByTypeId(vo[1])
			if (vo[1] == 26270005 || vo[1] == 26260005) {
				color = 6
				break
			}
			if (basic.color > color) {
				color = basic.color
			}
		}
		let effect = "ui_yuhunzahohuan_01"
		if (color == 4) {
			effect = "ui_yuhunzahohuan_02"
		} else if (color == 5) {
			effect = "ui_yuhunzahohuan_03"
		} else if (color == 6) {
			effect = "ui_yuhunzahohuan_04"
		}
		this.AddUIEffect(effect, this._gp_effect, { x: 0, y: 0.8 }, 1, null, null, null, () => {
			setTimeout(() => {
				if (this.use_delete_method) return
				this._gp_con.visible = true
			}, 350)
		}, null, null, null, null, false)
	}

	public InitOne(reward_list) {
		let item = new RuneResultItem(this._gp_one)
		item.Load()
		item.SetData(reward_list[0])
		this.item_list[0] = item
	}

	public InitTen(reward_list) {
		let len = reward_list.length
		let index = 0
		for (let i = len - 1; i >= 0; i--) {
			let parent = this["_gp" + index]
			let item = new RuneResultItem(parent)
			item.Load()
			item.SetData(reward_list[i])
			this.item_list[index] = item
			index = index + 1
		}
	}

	public PlayAnim() {
		if (this.is_animing) {
			return
		}
		this.is_animing = true

		for (let i in this.item_list) {
			let item = this.item_list[i]
			item.PlayAnim()
		}
	}

	_gp_con: Laya.Box
	_btn_click: Laya.Box
	_gp_chip: Laya.HBox
	_lb_tips2: Laya.Label
	_img_chip: Laya.Image
	_lb_num: Laya.Label
	_lb_tips: Laya.Label
	_gp_one: Laya.Box
	_gp_ten: Laya.Box
	_gp0: Laya.Box
	_gp1: Laya.Box
	_gp2: Laya.Box
	_gp3: Laya.Box
	_gp4: Laya.Box
	_gp5: Laya.Box
	_gp6: Laya.Box
	_gp7: Laya.Box
	_gp8: Laya.Box
	_gp9: Laya.Box
	_gp_effect: Laya.Box
	public GetComponents() {
		[
			this._gp_con,
			this._btn_click,
			this._gp_chip,
			this._lb_tips2,
			this._img_chip,
			this._lb_num,
			this._lb_tips,
			this._gp_one,
			this._gp_ten,
			this._gp0,
			this._gp1,
			this._gp2,
			this._gp3,
			this._gp4,
			this._gp5,
			this._gp6,
			this._gp7,
			this._gp8,
			this._gp9,
			this._gp_effect,
		]
			= this.GetChildrenByNames([
				"_gp_con",
				"_btn_click",
				"_gp_chip",
				"_lb_tips2",
				"_img_chip",
				"_lb_num",
				"_lb_tips",
				"_gp_one",
				"_gp_ten",
				"_gp0",
				"_gp1",
				"_gp2",
				"_gp3",
				"_gp4",
				"_gp5",
				"_gp6",
				"_gp7",
				"_gp8",
				"_gp9",
				"_gp_effect",
			])
	}
}
window["RuneTreasureResultView"] = RuneTreasureResultView
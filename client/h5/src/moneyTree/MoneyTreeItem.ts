import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItem1 } from "../common/BaseItem1"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { StageShowView } from "../customActivity/StageShowView"
import { ColorUtil, Enum_ColorUtil_Light } from "../util/ColorUtil"
import { GameResPath } from "../util/GameResPath"
import { Util, SetAnchoredPosition, SetLocalScale, SetAnchoredPositionY, SetAnchoredPositionX, GlobalTimerQuest } from "../util/Util"

export class MoneyTreeItem extends BaseItem1 {
	effect: Laya.Box
	gp: Laya.Box
	_gp_show_reward: Laya.Box
	_img_rare: Laya.Image
	_gp_reward: Laya.Box
	_gp_effect: Laya.Box
	_gp_cul_reward: Laya.Box
	_box: Laya.Image
	_count_bg: Laya.Image
	_count: Laya.Label
	_draw: Laya.Image
	_img_red: Laya.Image
	_img_rare_two: Laya.Image
	Emp_gp_reward
	InitEvent
	RefreshRewardItem
	SetData
	SetItem
	_stage_show
	base_type
	cache_order
	cache_sort_order
	cur_sorting_order
	data
	info
	item_type
	mask_id
	pos
	reward_item
	reward_list
	show_two
	sub_type
	SetPos
	mask_corners
	public constructor(parent?) {
		super(parent)


		this.reward_list = [];
		this.base_file = "moneyTree"
		this.layout_file = "MoneyTreeItem"
		this.layer_value = Enum_UILayer.UI
		this.load_callback = () => {

			// this.cache_order = this.AddCurrLayerSortingOrder(this.layer_value)
			// this.cur_sorting_order =  this.AddCurrLayerSortingOrder(this.layer_value)
			this.InitEvent()
			this.SetPos(this.pos)
		}

		this.SetData = (...new_args) => {
			let args = new_args
			this.data = args[0]
			this.item_type = args[1]
			this.info = args[2]
			this.base_type = args[2].base_type
			this.sub_type = args[2].sub_type
			this.show_two = args[3]
			this.mask_id = args[4]
			this.cache_sort_order = args[5]
			this.mask_corners = args[6]
			this.SetItem()
			this.RefreshRewardItem()
		}

		this.InitEvent = () => {
			let draw = () => {
				if (this.item_type == "show_item") {
					let type_id, lock = GoodsModel.GetInstance().GetMappingTypeId(this.data.reward[0].style, this.data.reward[0].typeId)
					if (type_id) {
						UIToolTipMgr.GetInstance().DefaultAppendTips(type_id, 1)
					}
				} else {
					if (this.data.status == 1) {
						CustomActivityModel.GetInstance().Fire(CustomActivityDefine.EVENT.SCMD_REQUEST, 33192, this.base_type, this.sub_type, this.data.grade_id)
					}
				}
			}

			Util.AddClickEvent(this._gp_reward, draw, this, true)
			Util.AddClickEvent(this._box, () => {
				if (this.data.status == 1) {
					CustomActivityModel.GetInstance().Fire(CustomActivityDefine.EVENT.SCMD_REQUEST, 33192, this.base_type, this.sub_type, this.data.grade_id)
				} else {
					let rew = this.reward_list
					if (!rew || !rew.length) {
						return
					}
					if (!this._stage_show) {
						this._stage_show = new StageShowView()
					}
					let list = []
					for (let i in rew) {

						let v = []
						v[0] = rew[i].style
						v[1] = rew[i].typeId
						v[2] = rew[i].count
						table.insert(list, v)
					}
					if (list.length > 0) {
						this._stage_show.Open(list, this._box, StageShowView.ShowArrow.LEFT)
					}
				}
			}
				, this, true)
		}

		this.SetItem = () => {
			// SetAnchoredPosition(this._gp_reward, this.item_type == "show_item" && -38 || -52, this.item_type == "show_item" && -45 || 0)
			this._gp_show_reward.visible = !this.show_two && this.item_type == "show_item"
			this._img_rare_two.visible = this.show_two && this.item_type == "show_item"
			SetLocalScale(this._gp_show_reward, this.item_type == "show_item" && 1 || 0, this.item_type == "show_item" && 1 || 0)
			this._gp_cul_reward.visible = this.item_type == "show_item"
			SetLocalScale(this._gp_cul_reward, this.item_type == "show_item" && 0 || 1, this.item_type == "show_item" && 0 || 1)
		}

		this.SetPos = (pos?) => {
			this.pos = pos
			if (!this.is_loaded || !this.pos) {
				return
			}
			SetAnchoredPosition(this.display_obj, this.pos.x, this.pos.y)
		}

		this.RefreshRewardItem = () => {
			let bool = this.data.reward && this.data.reward.length == 1 && this.item_type == "show_item"
			let type = null
			let color = 0
			if (bool) {
				if (!this.reward_item) {
					this.reward_item = new BaseAwardItem(this._gp_reward)
					this.reward_item.Load()
					let size = this.item_type == "show_item" && 75 || 105
					this.reward_item.SetItemSize(size, size)
				}
				let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(this.data.reward[0].style, this.data.reward[0].typeId)
				this.reward_item.ExcuteCallback(() => {
					this.reward_item.SetData(type_id, this.data.reward[0].count, lock)
				}
				)
				type = type_id
				let basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type)
				if (basic) {
					color = basic.color
				}
			}
			this.ClearUIEffect(this._gp_effect)
			if (this.item_type == "show_item") {
				if (this.data.is_rare == 0) {
					if (this.show_two) {
						ResManager.GetInstance().SetImageSprite(this, this._img_rare_two, "moneyTree","uixyqqq_0_" + color)// "client/assets/icon/moneyTree/texture/uixyqqq_0_" + color + ".png")
					} else {
						let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "ConfigCustomActivityView", true)
						if (cfg && this.info) {
							CustomActivityModel.GetInstance().LoadCompontRes(this, cfg, "MoneyTreeItem", this.info.show_id)
						}
					}
				} else {
					if (this.show_two) {
						ResManager.GetInstance().SetImageSprite(this, this._img_rare_two,"moneyTree","uixyqqq_1_" + color)//"client/assets/icon/moneyTree/texture/uixyqqq_1_" + color + ".png")
					} else {
						ResManager.GetInstance().SetImageSprite(this, this._img_rare, "moneyTree_asset", "uiyqs_005", true)
					}
				}
				if (this.data.is_rare == 1) {
					if (this.show_two) {
						this.reward_item.SetItemSize(100, 100)
						// SetAnchoredPositionY(this._gp_reward, -65)
					} else {
						this.reward_item.SetItemSize(87, 87)
						// SetAnchoredPositionY(this._gp_reward, -80)
					}
					// SetAnchoredPositionX(this._gp_reward, -25)
				}
				// this.Emp_gp_reward.raycastTarget = true
			} else {
				this._gp_cul_reward.visible = true
				this._draw.visible = this.data.status == 2
				let text = this.data.times + "次"
				if (this.data.status == 1) {
					text = "可领取"
				}
				this._count.text = text
				this._count.color = ColorUtil.TryParseHtmlString(Enum_ColorUtil_Light.GREEN)
				this._img_red.visible = this.data.status == 1

				this.ClearUIEffect(this.effect)
				if (this.data.status == 1) {
					SetLocalScale(this.effect, 0.7, 0.7, 0.7)
					this.ClearUIEffect(this.gp)//, this.layer_value, this.cache_order)
					// this.AddUIEffect("UI_2009_b_zt", this.layer_value, this.effect, null, null, true, {
						// custom_sorting_order: this.cache_order, mask_corners: this.mask_corners, mask_id: this.mask_id, load_call_back: () => {
							//this:CoverEffect(this.gp)
							// this.ReplaceUIShader(this.gp)
							//let canvas = this.GetChild("gp").GetComponent("Canvas")
							//if (canvas ) {
							//canvas.overrideSorting = true
							//}
						// }
					// })
					// GlobalTimerQuest.AddDelayQuest(() => {
						// let canvas = this.GetChild("gp").GetComponent("Canvas")
						// if (canvas ) {
						// 	canvas.overrideSorting = true
						// }
					// }, 0)

				}
				this.reward_list = this.data.reward
			}
		}

	}

	public DeleteMe() {
		if (this.reward_item) {
			this.reward_item.DeleteMe()
			this.reward_item = null
		}

		if (this._stage_show) {
			this._stage_show = null
		}

		this.ClearUIEffect(this.effect)
		super.DeleteMe()
	}

	public GetComponents() {
		[
			this.effect,
			this.gp,
			this._gp_show_reward,
			this._img_rare,
			this._gp_reward,
			this._gp_effect,
			this._gp_cul_reward,
			this._box,
			this._count_bg,
			this._count,
			this._draw,
			this._img_red,
			this._img_rare_two,
		]
			= this.GetChildrenByNames([

				"effect",
				"gp",
				"_gp_show_reward",
				"_img_rare",
				"_gp_reward",
				"_gp_effect",
				"_gp_cul_reward",
				"_box",
				"_count_bg",
				"_count",
				"_draw",
				"_img_red",
				"_img_rare_two",
			])
	}
}
window["MoneyTreeItem"]=MoneyTreeItem
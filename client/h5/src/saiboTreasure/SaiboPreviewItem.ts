import { BaseItem1 } from "../common/BaseItem1"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { SaiboModel, SaiBoModelEvent } from "../commonModel/SaiboModel"
import { Message } from "../sysInfo/SysInfoController"
import { GameResPath } from "../util/GameResPath"
import { SetAnchoredPosition, SetLocalScale, Util } from "../util/Util"
import { SetAnchoredPositionX } from './../util/Util';

export class SaiboPreviewItem extends BaseItem1 {
	ShowModel
	cur_sorting_order
	data
	grade_cfg
	grade_data
	index
	is_select
	model
	saibo_model

	public constructor(parent?) {
		super(parent)


		this.model = CustomActivityModel.GetInstance();
		this.saibo_model = SaiboModel.GetInstance();
		this.is_select = false;

		this.base_file = "saiboTreasure"
		this.layout_file = "SaiboPreviewItem"
		this.load_callback = () => {
			// this.cur_sorting_order = this.AddCurrLayerSortingOrder(Enum_UILayer.Activity)
			this.InitEvent()
		}

		this.ShowModel = (model_id?) => {
			CustomActivityModel.GetInstance().ShowViewModel(this, "SaiboPreviewItem", model_id, this._gp_model, null, null, this.cur_sorting_order)
		}
	}

	public InitEvent() {
		ResManager.GetInstance().SetOutsideImageSprite(this, this.bgImg, GameResPath.GetIcon("saiboTreasure", "uisbdb_029"), true)
		Util.AddClickEvent(this._img_select, () => {
			this.is_select = !this.is_select
			ResManager.GetInstance().SetImageSpriteTrans(this, this._img_select, GameResPath.GetIcon("saiboTreasure", this.is_select && "uisbdb_035" || "uisbdb_034"))
			if ((!this.grade_cfg || !this.grade_data) || !this.data) {
				return
			}
			if (this.grade_data.discount_state == 2) {
				Message.show("已购买")
			}
			SaiboModel.GetInstance().Fire(SaiBoModelEvent.SELECT_BUY, this.is_select)
		}
			, this, true)
		Util.AddClickEvent(this._gp_tips, () => {
			if (!this.grade_cfg) {
				return
			}
			let reward = (this.index == 0 && (this.grade_cfg.reward) || (this.grade_cfg.dis_reward))
			if (reward) {
				reward = reward[0];
				let [typeid, lock] = GoodsModel.GetInstance().GetMappingTypeId(reward[0], reward[1]);
				UIToolTipMgr.GetInstance().DefaultAppendTips(typeid, 0);
			}
		}, this, false);
	}

	public InitView() {


		if (!this.data) {
			return
		}
		if (!this.grade_data) {
			return
		}
		if (!this.grade_cfg) {
			return
		}
		let _data = {
			custom_sorting_order: this.cur_sorting_order
		}
		this.ClearUIEffect(this._gp_effect_1);
		// this.AddUIEffect("UI_2002_2_cheng", this._gp_effect_2, null, 3, true)
		this.AddUIEffect("UI_2002_2_cheng", this._gp_effect_1, null, 3, true);
		SetLocalScale(this._gp_effect_1, 1.1, 1);
		SetAnchoredPosition(this._gp_effect_1, -13, 45);
		// this.CoverEffect(this._img_icon, this.layer_value, this.cur_sorting_order + 1)
		// this.CoverEffect(this._gp_good, this.layer_value, this.cur_sorting_order + 1)
		// this.CoverEffect(this._img_dicount, this.layer_value, this.cur_sorting_order + 1)
		// this.CoverEffect(this._lb_num, this.layer_value, this.cur_sorting_order + 1)
		let bool = this.index == 0
		this._lb_desc1.visible = bool
		this._gp_btn.visible = !bool
		this._img_dicount.visible = !bool
		ResManager.GetInstance().SetOutsideImageSprite(this, this._img_title, GameResPath.GetIcon('saiboTreasure', bool ? "uisbdb_031" : "uisbdb_032"))
		if (!bool) {
			this.InitBtn()
		} else {
			let total = this.grade_cfg.condition && this.grade_cfg.condition.total
			if (total) {
				this._lb_desc0.text = total + "次"
				this._lb_desc1.text = (this.grade_data.state_stage != 2 && ("夺宝" + total + "次即可领取") || ("已领取"))
			}
		}
		this.ShowRewardModel()
	}

	public InitBtn() {
		if (!this.grade_cfg || !this.grade_data) {
			return
		}

		// 已领取不显示勾选框
		this._Group1.visible = !(this.grade_data.state_stage == 2);

		if (this.grade_data.discount_state == 2) {
			this._img_cost.visible = false
			this._lb_cost.text = "已购买";
			SetAnchoredPositionX(this._lb_cost, 18)
		} else {
			if (this.grade_data.state_stage == 2) {
				this._img_cost.visible = false
				this._lb_cost.text = "未购买";
				SetAnchoredPositionX(this._lb_cost, 10)
				return;
			}
			this._img_icon.visible = true
			let cost = this.grade_cfg.discount
			if (!cost) {
				return
			}
			cost = cost[0]
			let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(cost[0], cost[1])
			let basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
			if (basic) {
				ResManager.GetInstance().SetOutsideImageSprite(this, this._img_cost, GameResPath.GetGoodsIconPath(basic.goods_icon))
				this._lb_cost.text = cost[2]
			}
		}
	}

	public ShowRewardModel() {
		if (!this.grade_cfg) {
			return
		}
		let show = this.grade_cfg.show
		if (!show) {
			return
		}
		let dis = show.length;
		if (dis && dis[0] == "rebate") {
			ResManager.GetInstance().SetImageSpriteTrans(this, this._img_dicount, GameResPath.GetIcon('saiboTreasure', dis[0] + "_uisbdb_016"))
		} else {
			this._img_dicount.visible = false
		}
		show = show[this.index]
		let cur_day_cfg = null
		if (!show) {
			return
		}
		if (show[0] == "model") {
			this._img_icon.visible = false
			this.ClearUIEffect(this._gp_effect)
			this._gp_model.visible = true
			this.ShowModel(show[1][0][1])
		} else if (show[0] == "effect") {
			this._gp_model.visible = false
			this._img_icon.visible = false
			this.AddUIEffect(show[1][0][1], this._gp_effect, null, null, true)
		} else if (show[0] == "icon") {
			this.ClearUIEffect(this._gp_effect)
			this._gp_model.visible = false
			this._img_icon.visible = true
			this._lb_num.visible = true
			this._lb_num.text = show[1][0][2]
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_icon, GameResPath.GetGoodsIconPath(show[1][0][1]))
		}
	}

	public SetData(...new_args) {
		let args = new_args
		if (args) {
			this.data = args[0]
			this.grade_data = args[1]
			this.index = args[2]
			this.grade_cfg = args[3]
			this.InitView();
		}
	}

	public DeleteMe() {
		super.DeleteMe();
	}


	bgImg: Laya.Image
	_img_022: Laya.Image
	_lb_desc0: Laya.Label
	_img_title: Laya.Image
	_lb_desc1: Laya.Label
	_gp_effect_2: Laya.Box
	_gp_model: Laya.Box
	_gp_effect: Laya.Box
	_img_icon: Laya.Image
	_gp_effect_1: Laya.Box
	_gp_good: Laya.Box
	_img_mask: Laya.Image
	_lb_num: Laya.Label
	_img_dicount: Laya.Image
	_gp_btn: Laya.Box
	_Group1: Laya.Box
	_img_select: Laya.Image
	_img_cost: Laya.Image
	_lb_cost: Laya.Label
	_gp_tips: Laya.Box
	public GetComponents() {
		[
			this.bgImg,
			this._img_022,
			this._lb_desc0,
			this._img_title,
			this._lb_desc1,
			this._gp_effect_2,
			this._gp_model,
			this._gp_effect,
			this._img_icon,
			this._gp_effect_1,
			this._gp_good,
			this._img_mask,
			this._lb_num,
			this._img_dicount,
			this._gp_btn,
			this._Group1,
			this._img_select,
			this._img_cost,
			this._lb_cost,
			this._gp_tips,
		]
			= this.GetChildrenByNames([

				"bgImg",
				"_img_022",
				"_lb_desc0",
				"_img_title",
				"_lb_desc1",
				"_gp_effect_2",
				"_gp_model",
				"_gp_effect",
				"_img_icon",
				"_gp_effect_1",
				"_gp_good",
				"_img_mask",
				"_lb_num",
				"_img_dicount",
				"_gp_btn",
				"_Group1",
				"_img_select",
				"_img_cost",
				"_lb_cost",
				"_gp_tips",
			])
	}
}
window["SaiboPreviewItem"] = SaiboPreviewItem
import { BaseItem1 } from "../common/BaseItem1"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { SaiboModel } from "../commonModel/SaiboModel"
import { PlatformManager } from "../PlatformManager"
import { GameResPath } from "../util/GameResPath"
import { SetAnchoredPosition, SetAnchoredPositionY, SetLocalScale, SetSizeDelta, Util } from "../util/Util"
import { SaiboPreview } from "./SaiboPreview"

export class SaiboTotalItem extends BaseItem1 {
	ShowModel
	act_data
	cur_stage
	custom_sorting_order
	// empty_gp_btn
	goods_type
	grade_data
	index

	public constructor(parent?) {
		super(parent)


		this.ShowModel = (model_id?) => {
			CustomActivityModel.GetInstance().ShowViewModel(this, "SaiboTotalItem", model_id, this._gp_model)
		}

		this.base_file = "saiboTreasure"
		this.layout_file = "SaiboTotalItem"
		this.load_callback = () => {
			this.InitEvent()
		}
	}

	public InitEvent() {
		Util.AddClickEvent(this._gp_btn, () => {
			let act_data = this.act_data
			let grade_data = this.grade_data
			if (act_data && grade_data) {
				let base_type = act_data.base_type
				let sub_type = act_data.sub_type
				if (((grade_data.state_stage && grade_data.state_stage == 1) && grade_data.buy_reward) && grade_data.buy_reward.length == 0) {
					CustomActivityModel.GetInstance().Fire(CustomActivityDefine.EVENT.SCMD_REQUEST, 33166, base_type, sub_type, this.cur_stage, grade_data.grade_stage, 0)
				} else {
					if ((this.cur_stage == null && grade_data.is_rare != null) && grade_data.is_rare != 1) {
						let rewards = SaiboModel.GetInstance().GetPoolCurWaveRewards(base_type, sub_type, act_data.wave)
						if (rewards) {
							let list = []
							for (let i in rewards) {

								let vo = rewards[i]
								if (vo.rare == 0 && vo.reward) {
									table.insert(list, vo.reward[0])
								}
							}
							if (list.length > 0) {
								let proview = new SaiboPreview()
								proview.Open(list)
							}
						}
					} else if ((this.cur_stage != null && grade_data.buy_reward) && !Util.IsTableEmpty(grade_data.buy_reward)) {
						CustomActivityModel.GetInstance().Fire(CustomActivityDefine.EVENT.OPEN_CUSTOM_VIEW, "SaiboBuyPreview", "saiboTreasure", this.act_data, this.grade_data, this.cur_stage)
					} else if (this.goods_type) {
						UIToolTipMgr.GetInstance().DefaultAppendTips(this.goods_type, (grade_data?.goods_list[0]?.count || 1));
					}
				}
			}
		}, this, true);

		this.BindEvent(CustomActivityModel.GetInstance(), CustomActivityDefine.EVENT.ANSWER_TARGET, (...new_args) => {
			let args = new_args
			let act_data = this.act_data
			let grade_data = this.grade_data
			if (!act_data || !grade_data) {
				return
			}
			let base_type = act_data.base_type
			let sub_type = act_data.sub_type
			if (base_type != args[0] || sub_type != args[1]) {
				return
			}
			let result = args[2]
			if (!result) {
				return
			}
			if (result.reward) {
				if (result.grade_stage == grade_data.grade_stage && result.stage == this.cur_stage) {
					if (grade_data.discount_state != null) {
						grade_data.discount_state = 2
					}
					grade_data.state_stage = 2
					this.grade_data = grade_data
					this.InitView(false)
				}
			} else if (result.reward_list) {
				for (let _tmpi in result.reward_list) {
					var v = result.reward_list[_tmpi]
					if (v.sort == grade_data.sort) {
						grade_data.state = 0
						this.grade_data = grade_data
						this.InitView(false)
					}
				}
			}
		})

		this.BindEvent(CustomActivityModel.GetInstance(), CustomActivityDefine.EVENT.UPDATE_VIEW, (...new_args) => {
			let args = new_args
			let act_data = this.act_data
			let grade_data = this.grade_data
			if (!act_data || !grade_data) {
				return
			}
			let base_type = act_data.base_type
			let sub_type = act_data.sub_type
			if (base_type != args[0] || sub_type != args[1]) {
				return
			}
			this.act_data = CustomActivityModel.GetInstance().GetActData(base_type, sub_type)
			let pool = this.act_data.pool
			if (pool && pool.length > 0) {
				let v = pool[grade_data.sort - 1]
				if (v) {
					this.grade_data = v
					this.InitView(false)
				}
			}
		}
		)
	}

	public InitView(bool?) {
		let act_data = this.act_data
		let grade_data = this.grade_data
		let base_type = act_data.base_type
		let sub_type = act_data.sub_type
		let func = () => {
			if (bool != false) {
				let sorting_order = this.custom_sorting_order + 1
				// this.CoverEffect(this._gp_btn, this.layer_value, sorting_order)
				// this.CoverEffect(this._img_goods, this.layer_value, sorting_order)
				// this.CoverEffect(this._img_draw, this.layer_value, sorting_order)
				// this.CoverEffect(this._lb_total, this.layer_value, sorting_order)
				// this.CoverEffect(this._img_red, this.layer_value, sorting_order)
				// this.CoverEffect(this._lb_num, this.layer_value, sorting_order)
			}
		}
		let data = {
			custom_sorting_order: this.custom_sorting_order,
			load_call_back: func
		}
		this.ClearUIEffect(this._gp_effect);
		this.ClearUIEffect(this._gp_effect_1);
		if (act_data && grade_data) {
			let status = null
			let reward = grade_data.reward || grade_data.grade_reward
			let basic = null
			if (reward && reward[0]) {
				let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(reward[0].style, reward[0].typeId)
				basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
				if (basic) {
					if ((((basic.type == 16 || basic.type == 17) || basic.type == 18) || basic.type == 37) || basic.type == 28) {
						SetSizeDelta(this._img_goods, 65, 65)
					} else {
						SetSizeDelta(this._img_goods, 80, 80)
					}
					this.goods_type = type_id
					ResManager.GetInstance().SetOutsideImageSprite(this, this._img_goods, GameResPath.GetGoodsIconPath(basic.goods_icon))
				}
				this._lb_num.text = reward[0].count
			}
			if (grade_data.grade_reward != null) {
				status = grade_data.state_stage
				let dis_state = grade_data.discount_state
				let cfg = null
				if (this.cur_stage) {
					cfg = SaiboModel.GetInstance().GetStageCfg(base_type, sub_type, this.cur_stage, grade_data.grade_stage)
				}
				if (cfg && cfg.condition) {
					let num = cfg.condition.total
					if (PlatformManager.IsEyouEnPlatform()) {
						this._lb_total.text = num
					} else {
						this._lb_total.text = num + "次"
					}
				}
				this._img_draw.visible = status == 2;
				this._img_007.visible = !(this.index == 0)
				ResManager.GetInstance().SetImageSpriteTrans(this, this._img_004, GameResPath.GetIcon('saiboTreasure', this.index == 3 ? 'uisbdb_022' : status == 0 ? "uisbdb_004a" : "uisbdb_004b"))
				ResManager.GetInstance().SetImageSpriteTrans(this, this._img_007, GameResPath.GetIcon('saiboTreasure', status == 0 ? "uisbdb_007" : "uisbdb_006"))
				this._img_red.visible = status == 1;
				if (this.index == 3) {
					this._img_goods.visible = false;
					this._img_005.visible = false;
					this._lb_num.visible = false;
					this.ShowRewardModel(base_type, sub_type, this.cur_stage, grade_data.grade_stage);
				} else {
					this._img_goods.visible = true;
					this._img_005.visible = true;
					this._lb_num.visible = true;
					ResManager.GetInstance().SetImageSpriteTrans(this, this._img_005, GameResPath.GetIcon('saiboTreasure', status == 2 && "0_uisbdb_005" || basic.color + "_uisbdb_005"))
				}

				if (status == 1 && (!grade_data.buy_reward || !grade_data.buy_reward.length)) {
					this.AddUIEffect("UI_2003_1", this._gp_effect_1, null, 3, true)
					SetLocalScale(this._gp_effect_1, 1, 1);
					SetAnchoredPosition(this._gp_effect_1, 0, 11)
					// this.AddUIEffect("ui_saibo_scienceglow1_1", this._gp_effect, 3, null, true, null, null, null, null, true)
				} else if (grade_data.buy_reward && grade_data.buy_reward.length > 0) {
					this._img_draw.visible = (status == 2 && dis_state == 2 && (true || (false)))
					ResManager.GetInstance().SetImageSpriteTrans(this, this._img_005, GameResPath.GetIcon('saiboTreasure', status == 2 && dis_state == 2 && "0_uisbdb_005" || basic.color + "_uisbdb_005"))
					if (status == 1) {
						this.AddUIEffect("UI_2003_1", this._gp_effect_1, null, 3, true)
						SetLocalScale(this._gp_effect_1, 1, 1);
						SetAnchoredPosition(this._gp_effect_1, 0, 11)
						// this.AddUIEffect("ui_saibo_scienceglow1_1", this._gp_effect, 3, null, true, null, null, null, null, true)
					} else {
						this.AddUIEffect("UI_2002_2_cheng", this._gp_effect_1, null, 3, true)
						SetLocalScale(this._gp_effect_1, 2.5, 1.2);
						SetAnchoredPosition(this._gp_effect_1, -102, 1);
						// this.AddUIEffect("UI_2002_2_cheng", this._gp_effect, { x: 0, y: 1 }, 3, true)
					}
				}
			} else if (grade_data.reward) { // 为上面奖励显示道具
				this._img_008.visible = true;
				status = grade_data.state;
				this._gp_btn.mouseEnabled = status == 1;
				this._gp_btn.centerX = -8;
				// this.empty_gp_btn.raycastTarget = status == 1
				ResManager.GetInstance().SetImageSpriteTrans(this, this._img_008, GameResPath.GetIcon('saiboTreasure', 'uisbdb_008'), true)
				this._img_004.visible = false;
				this._img_007.visible = false;
				this._lb_total.visible = false;
				this._lb_num.visible = false;
				this._img_005.visible = true;
				this._img_goods.visible = true;

				if ((basic && grade_data.is_rare != 0) && status == 1) {
					// SetLocalScale(this._gp_goods, 1, 1)
					this._lb_num.visible = true;
					SetSizeDelta(this._img_goods, 80, 80)
					ResManager.GetInstance().SetImageSpriteTrans(this, this._img_005, GameResPath.GetIcon('saiboTreasure', 'uisbdb_026_' + basic.color))
					if (basic.color) {
						let url = null
						if (4 == basic.color) {
							url = "UI_2002_2_cheng"
						} else if (5 == basic.color) {
							url = "UI_2002_2_hong"
						} else if (6 == basic.color) {
							url = "UI_2002_2_fen"
						}
						if (url) {
							this.AddUIEffect(url, this._gp_effect, null, 3, true);
							SetLocalScale(this._gp_effect, 2, 1.2);
							SetAnchoredPosition(this._gp_effect, -72, -10);
						}
					}
				} else if (grade_data.is_rare == 0 && status == 1) {
					// SetLocalScale(this._gp_goods, 0.8, 0.8)
					this._img_goods.visible = false;
					ResManager.GetInstance().SetImageSpriteTrans(this, this._img_005, GameResPath.GetIcon('saiboTreasure', 'uisbdb_005'));
				} else if (status == 0) {
					this._img_goods.visible = false;
					this._img_005.visible = false;
				}
			}
		}
		func()
	}

	public ShowRewardModel(base_type?, sub_type?, stage?, grade?) {
		let grade_cfg = SaiboModel.GetInstance().GetStageCfg(base_type, sub_type, stage, grade)
		if (!grade_cfg) {
			return
		}
		let show = grade_cfg.show
		if (!show) {
			return
		}
		show = show[0]
		let cur_day_cfg = null
		if (!show) {
			return
		}
		if (show[0] == "model") {
			this._gp_model.visible = true
			this._img_icon.visible = false
			this.ClearUIEffect(this._gp_model_effect)
			this.ShowModel(show[1][0][1])
		} else if (show[0] == "effect") {
			this._gp_model.visible = false
			this._img_icon.visible = false
			// this.AddUIEffect(show[1][0][1], this._gp_model_effect, null, null, true)
		} else if (show[0] == "icon") {
			this.ClearUIEffect(this._gp_model_effect)
			this._gp_model.visible = false
			this._img_icon.visible = true
			SetAnchoredPositionY(this._img_icon, 0)
			this._lb_num.text = show[1][0][2]
			this._lb_num.visible = true
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_icon, GameResPath.GetGoodsIconPath(show[1][0][1]))
		}
	}

	public SetData(...new_args) {
		let prams = new_args
		if (prams.length > 0) {
			this.grade_data = prams[0]
			this.act_data = prams[1]
			this.index = prams[2]
			if (prams[3]) {
				this.cur_stage = prams[3]
			}
			this.custom_sorting_order = prams[4]
			this.InitView()
		}
	}


	public DeleteMe() {
		super.DeleteMe();
	}

	_img_004: Laya.Image
	_img_007: Laya.Image
	_img_008: Laya.Image
	_gp_effect: Laya.Box
	_gp_btn: Laya.Box
	_gp_model: Laya.Box
	_gp_model_effect: Laya.Box
	_img_icon: Laya.Image
	_gp_goods: Laya.Box
	_img_goods: Laya.Image
	_img_005: Laya.Image
	_lb_num: Laya.Label
	_img_draw: Laya.Image
	_lb_total: Laya.Label
	_gp_effect_1: Laya.Box
	_img_red: Laya.Image
	public GetComponents() {
		[
			this._img_004,
			this._img_007,
			this._img_008,
			this._gp_effect,
			this._gp_btn,
			this._gp_model,
			this._gp_model_effect,
			this._img_icon,
			this._gp_goods,
			this._img_goods,
			this._img_005,
			this._lb_num,
			this._img_draw,
			this._lb_total,
			this._gp_effect_1,
			this._img_red,
		]
			= this.GetChildrenByNames([

				"_img_004",
				"_img_007",
				"_img_008",
				"_gp_effect",
				"_gp_btn",
				"_gp_model",
				"_gp_model_effect",
				"_img_icon",
				"_gp_goods",
				"_img_goods",
				"_img_005",
				"_lb_num",
				"_img_draw",
				"_lb_total",
				"_gp_effect_1",
				"_img_red",
			])
	}
}
window["SaiboTotalItem"] = SaiboTotalItem
import { Alert, Alert_Type } from "../alert/Alert"
import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { OpenFun } from "../common/OpenFun"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { RoleManager } from "../commonModel/RoleManager"
import { SaiboModel, SaiBoModelEvent } from "../commonModel/SaiboModel"
import { Message } from "../sysInfo/SysInfoController"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
import { SaiboPreviewItem } from "./saiboPreviewItem"

export class SaiboBuyPreview extends BaseView1 {
	DestoryCallback
	InitEvent
	InitView
	RefBuyCost
	click_bg_toClose
	destroy_callback
	destroy_imm
	is_center
	open_callback
	show_open_movie
	use_background

	private data: any = null;
	private grade_data: any = null;
	private cur_stage: any = null;

	public constructor() {
		super()


		this.base_file = "saiboTreasure"
		this.layout_file = "SaiboBuyPreview"
		this.layer_value = Enum_UILayer.Activity
		this.is_center = true
		this.use_background = true
		this.click_bg_toClose = true
		this.show_open_movie = true
		this.destroy_imm = true
		let item_list = []
		let cur_cfg = null
		let is_extro_buy = false
		let cost = null
		let model = SaiboModel.GetInstance()
		let local_Message = Message
		let custom_model = CustomActivityModel.GetInstance()
		let local_CustomActivityDefine = CustomActivityDefine
		let goods_model = GoodsModel.GetInstance()
		this.open_callback = () => {

			this.InitEvent()
			this.InitView()
		}

		this.destroy_callback = () => {
			this.DestoryCallback()
		}

		this.InitEvent = () => {
			ResManager.GetInstance().SetOutsideImageSprite(
				this,
				this._Image3,
				GameResPath.GetIconOtherPath('saiboTreasure', 'uisbdb_036')
			);
			Util.AddClickEvent(this._img_close, () => {
				this.Close()
			}, this, true);

			this.BindEvent(model, SaiBoModelEvent.SELECT_BUY, (bool?) => {
				is_extro_buy = bool
				this.RefBuyCost(bool)
			});

			Util.AddClickEvent(this._btn_draw, () => {
				if ((!cur_cfg || !this.grade_data) || !this.data) {
					return
				}
				if (this.grade_data.state_stage == 2) {
					local_Message.show("已领取过该奖励!")
				} else if (this.grade_data.state_stage != 0 && this.grade_data.discount_state == 0) {

					let request = () => {
						let base_type = this.data.base_type
						let sub_type = this.data.sub_type
						let stage = cur_cfg.stage
						let grade = cur_cfg.grade
						custom_model.Fire(local_CustomActivityDefine.EVENT.SCMD_REQUEST, 33166, base_type, sub_type, stage, grade, +is_extro_buy)
					}

					let recharge = () => {
						OpenFun.OpenFunHandler(21)
					}

					let show_alert = (str?, call_back?) => {
						Alert.Show(str, Alert_Type.Two, call_back)
					}
					// 判断是否勾选购买折扣
					if (is_extro_buy) {
						Alert.Show(`需要消耗<font color='#34a064'>${cost[2]}</font>勾玉领取奖励`, Alert_Type.Two, () => {
							let role = RoleManager.GetInstance().mainRoleInfo
							let money_type = cost[1];
							let have_num = (money_type == 1 && (role.jin) || (role.jinLock + role.jin))
							let need_num = cost[2];
							if (Number(need_num) > have_num) {
								let str = "勾玉不足，是否前往充值"
								let call_back = () => {
									recharge();
								}
								show_alert(str, call_back)
							} else {
								request();
							}
						}, null, "确定", '取消');
					} else {
						Alert.Show(`当前有<font color='#34a064'>超值折扣奖励</font>未勾选,是否直接领取阶段大奖?`, Alert_Type.Two, () => {
							request();
						}, null, "确定", '取消');
					}
				} else if (this.grade_data.state_stage == 0) {
					let times = cur_cfg.condition && cur_cfg.condition.total
					local_Message.show("累计夺宝次数不足" + times)
				};
			}, this, true);

			this.BindEvent(custom_model, local_CustomActivityDefine.EVENT.ANSWER_TARGET, (...new_args) => {
				let args = new_args
				let act_data = this.data
				if (!act_data || !this.grade_data) {
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
				if ((this.grade_data.grade_stage != null && result.grade_stage != null) && act_data.stage_s) {
					if (result.grade_stage == this.grade_data.grade_stage) {
						this.grade_data.state_stage = 2;
						this.grade_data.discount_state = result.buy >= 1 ? 2 : result.buy;
						this.grade_data = this.grade_data;
						this.InitView()
					}
				}
			}
			)
		}

		this.InitView = () => {
			if (!this.data) {
				return
			}
			if (!this.grade_data) {
				return
			}
			if (this.cur_stage == null) {
				return
			}
			cur_cfg = model.GetStageCfg(this.data.base_type, this.data.sub_type, this.cur_stage, this.grade_data.grade_stage)
			if (!cur_cfg) {
				return
			}
			let grade_reward = this.grade_data.grade_reward
			if (grade_reward && grade_reward.length > 0) {
				let item = item_list[0]
				if (!item) {
					item = new SaiboPreviewItem(this.Content)
					item.Load()
					table.insert(item_list, item)
				}
				item.ExcuteCallback(() => {
					item.SetData(this.data, this.grade_data, 0, cur_cfg)
				}
				)
			}
			let buy_reward = this.grade_data.buy_reward
			if (buy_reward && buy_reward.length > 0) {
				let item = item_list[1]
				if (!item) {
					item = new SaiboPreviewItem(this.Content)
					item.Load()
					table.insert(item_list, item)
				}
				item.ExcuteCallback(() => {
					item.SetData(this.data, this.grade_data, 1, cur_cfg)
				}
				)
			}
			this.RefBuyCost(false)
		}

		this.RefBuyCost = (bool?) => {
			if (!this.grade_data) {
				return
			}
			let label = this.labelDisplay
			let state = this.grade_data.state_stage
			label.text = state == 0 ? '未激活' : state == 1 ? '领取奖励' : '已领取';
			let need_num = 0;
			cost = cur_cfg.discount
			if (!cost || Util.IsTableEmpty(cost)) {
				return
			}
			cost = cost[0]
			let [type_id, lock] = goods_model.GetMappingTypeId(cost[0], cost[1])
			let basic = goods_model.GetGoodsBasicByTypeId(type_id)
			if (basic) {
				ResManager.GetInstance().SetOutsideImageSprite(this, this._img_cost, GameResPath.GetGoodsIconPath(basic.goods_icon))
			}
			if (bool && cur_cfg) {
				need_num = cost[2]
			}
			this._lb_cost_num.text = need_num + '';
		}


		this.DestoryCallback = () => {
			is_extro_buy = false
			if (item_list.length > 0) {
				for (let _tmpi in item_list) {
					var item = item_list[_tmpi]
					item.DeleteMe()
				}
				item_list = []
			}
		}

	}

	public Open(...new_args) {
		let parms = new_args
		if (parms) {
			this.data = parms[0]
			this.grade_data = parms[1]
			this.cur_stage = parms[2]
		}
		super.Open();
	}


	_Image1: Laya.Image
	_Image2: Laya.Image
	_Image3: Laya.Image
	_img_close: Laya.Image
	_Scroller1: Laya.Panel
	Content: Laya.HBox
	_btn_draw: Laya.Box
	_Image11: Laya.Image
	labelDisplay: Laya.Label
	_Group1: Laya.Box
	_img_cost: Laya.Image
	_lb_cost_num: Laya.Label
	public GetComponents() {
		[
			this._Image1,
			this._Image2,
			this._Image3,
			this._img_close,
			this._Scroller1,
			this.Content,
			this._btn_draw,
			this._Image11,
			this.labelDisplay,
			this._Group1,
			this._img_cost,
			this._lb_cost_num,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_Image2",
				"_Image3",
				"_img_close",
				"_Scroller1",
				"Content",
				"_btn_draw",
				"_Image11",
				"labelDisplay",
				"_Group1",
				"_img_cost",
				"_lb_cost_num",
			])
	}
}
window["SaiboBuyPreview"] = SaiboBuyPreview
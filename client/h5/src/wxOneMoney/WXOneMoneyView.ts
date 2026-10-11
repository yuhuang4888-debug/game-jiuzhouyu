import { Alert, Alert_Type } from "../alert/Alert"
import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseView1 } from "../common/BaseView1"
import { CongratulationObtainView } from "../common/CongratulationObtainView"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { OpenFun } from "../common/OpenFun"
import { ResManager } from "../common/ResManager"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { CheatModel } from "../commonModel/CheatModel"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { RoleManager } from "../commonModel/RoleManager"
import { VipModel } from "../commonModel/VipModel"
import { PlatformManager } from "../PlatformManager"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"

class WXOneMoneyView extends BaseView1 {
	_bg: Laya.Image
	_lb_name_0: Laya.Label
	_lb_name_1: Laya.Label
	_btn_close: Laya.Image
	_img_desc: Laya.Image
	_img_left_desc: Laya.Image
	_img_right_desc: Laya.Image
	_img_left_bg: Laya.Image
	_img_right_bg: Laya.Image
	_item_group: Laya.Panel
	_gp_reward: Laya.HBox
	_btn_get: Laya.Box
	btn_bg: Laya.Image
	_gp_btn_h: Laya.HBox
	_lb_text: Laya.Label
	_img_icon: Laya.Image
	_btn_red: Laya.Image
	_gp_model2: Laya.Box
	_gp_model1: Laya.Box
	_gp_effect: Laya.Box
	_img_instruction: Laya.Image


	InitView
	InitEvent
	RefreshView
	ShowGoods
	ShowUIGoods
	RefreshRed
	ClearShow
	SetActInfo
	ClearView

	public constructor() {
		super()

		let _info,
			_data,
			_reward_list = [],
			_show_reward_id = [],
			_uiID = [],//1model, 2effect
			_uiModel = [],
			_is_recharging,
			_product_info,
			_cost_info

		let model = CustomActivityModel.GetInstance(),
			res_mgr = ResManager.GetInstance(),
			act_define = CustomActivityDefine,
			uiTip_mgr = UIToolTipMgr.GetInstance(),
			goods_model = GoodsModel.GetInstance(),
			_util = Util

		this.base_file = "wxOneMoney"
		this.layout_file = "WXOneMoneyView"
		this.layer_value = Enum_UILayer.Activity
		this.is_center = true
		this.show_open_movie = true
		this.use_background = true
		this.not_show_main_msg = true
		this.background_alpha = 0.8
		this.click_bg_toClose = true
		this.destroy_imm = true
		this.change_scene_close = true
		this.load_callback = () => {
			this.InitView()
			this.InitEvent()
		}
		this.destroy_callback = () => {
			this.ClearView()
		}
		this.preload_server_config = {
			"config_recharge_product": false
		}
		this.preload_client_config = {
			"ConfigCustomActivityView": false
		}

		this.InitView = () => {
			CustomActivityModel.GetInstance().CloseACTRed(_info.base_type, _info.sub_type)
			res_mgr.SetTexture(this, this._bg, GameResPath.GetIcon("wxOneMoney", "ui_yylb_01"))
			res_mgr.SetTexture(this, this._img_left_desc, GameResPath.GetIcon("wxOneMoney", "ui_yylb_03"), undefined, undefined, true)
			// res_mgr.SetTexture(this, this._img_desc, "resource/game/wxOneMoney/texture/uiyylb_003.png")
			// res_mgr.SetTexture(this, this._img_left_bg, "resource/game/wxOneMoney/texture/uiyylb_006.png")
			// res_mgr.SetTexture(this, this._img_right_bg, "resource/game/wxOneMoney/texture/uiyylb_006.png")
			// res_mgr.SetTexture(this, this._img_left_desc, "resource/game/wxOneMoney/texture/uiyylb_006b.png")
			// res_mgr.SetTexture(this, this._img_right_desc, "resource/game/wxOneMoney/texture/uiyylb_006a.png")
			// this._gp_effect.width = 400
			// this._gp_effect.y = 152
			this.AddUIEffect("ui_fazhen_03", this._gp_effect, { x: 0, y: 0 }, 8, true)
			if (!_info) return
			_data = model.GetActData(_info.base_type, _info.sub_type)
			if (!_data) {
				model.Fire(act_define.EVENT.SCMD_REQUEST, 33104, _info.base_type, _info.sub_type)
				return
			}

			let info = _info
			let data = _data

			let info_cond = model.GetActCondition(_info.base_type, _info.sub_type, "info")
			this.RefreshView(info_cond)
			this.ShowGoods(info_cond)
			this.RefreshRed()

			//适配UI
			let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "ConfigCustomActivityView", true)
			if (cfg && info)
				// model.LoadCompontRes(this, cfg, "WXOneMoneyView", info.show_id)

				//展示名称
				for (let i = 0; i <= 1; i++) {
					let basic = goods_model.GetGoodsBasicByTypeId(_show_reward_id[i])
					if (basic) {
						this[`_lb_name_${i}`].text = basic.goods_name
					}
				}
		}

		this.InitEvent = () => {
			if (!_info) return
			let base_type = _info.base_type
			let sub_type = _info.sub_type

			let recharge_func = () => {
				if (!_data) return
				let status = _data.reward_list[0].status;
				let grade = _data.reward_list[0].grade
				if (status == 0) {
					_is_recharging = true
					//充值测试
					/* 	if (_util.IsDebug()) {
							// Message.show("秘籍充值")
							// let text = `recharge_${_product_info.product_id}`
							// CheatModel.GetInstance().Fire(CheatModel.SEND_CHEAT_TO_SERVER, text)
						} else {
						} */
					let ok_func = () => {
						model.Fire(CustomActivityDefine.EVENT.SCMD_REQUEST, 33265, _info.base_type, _info.sub_type, grade)
					}
					if (_product_info) {
						let hasNum: number = GoodsModel.GetInstance().GetTypeGoodsNum(36210008) // 写死默认拿这个道具
						if (hasNum >= _product_info.money) {
							VipModel.GetInstance().Fire(VipModel.REQUEST_PROTO, 15804, 'i', _product_info.product_id);
						} else {
							PlatformManager.GetInstance().PayRequest(_product_info.money, { id: _product_info.product_id, pay_title: _product_info.product_name })
						}
					} else if (_cost_info) {
						let money_enough  = RoleManager.GetInstance().mainRoleInfo.jin >= Number(_cost_info[2])
						if (money_enough) {
							let str = `是否消耗<font color='#639c12'>${_cost_info[2]}勾玉</font>进行抢购？`
							let content = Util.StrToHTML(str)
							Alert.Show(content, Alert_Type.Two, ok_func, undefined, "确定", "取消")
						} else {
							let charge_fun = () => {
								let state = CustomActivityModel.GetInstance().GetSuperGiftBuyState()
								if(state){
									OpenFun.OpenFunHandler(21)
								}else{
									OpenFun.OpenFunHandler(249)
								}
								// OpenFun.OpenFunHandler(21)
							}
							let str = `您的勾玉不足，是否前往充值`
							Alert.Show(str, Alert_Type.One, charge_fun, undefined, "确定")
						}
					}
				} else if (status == 1) {
					model.Fire(act_define.EVENT.SCMD_REQUEST, 33105, _data.base_type, _data.sub_type, grade)
				}
			}
			_util.AddClickEvent(this._btn_get, recharge_func, this, true)

			_util.AddClickEvent(this._btn_close, () => {
				this.Close()
			}, this, true)

			_util.AddClickEvent(this._gp_model1, () => {
				if (_show_reward_id && _show_reward_id[0]) {
					uiTip_mgr.DefaultAppendTips(_show_reward_id[0], undefined)
				}
			}, this, false)

			_util.AddClickEvent(this._gp_model2, () => {
				if (_show_reward_id && _show_reward_id[1]) {
					uiTip_mgr.DefaultAppendTips(_show_reward_id[1], undefined)
				}
			}, this, false)

			this.BindEvent(model, act_define.EVENT.UPDATE_VIEW, (...args) => {
				if (args[0] == base_type && args[1] == sub_type) {
					if (!_info) return
					let info_cond = model.GetActCondition(_info.base_type, _info.sub_type, "info")
					_data = model.GetActData(base_type, sub_type)
					if (!_data) return
					this.RefreshView(info_cond)
					this.ShowGoods(info_cond)
					this.RefreshRed()
				}
			})

			this.BindEvent(model, act_define.EVENT.ANSWER_TARGET, (base_type, sub_type, result_data, reward_data) => {
				if (base_type == _info.base_type && sub_type == _info.sub_type) {
					_data = model.GetActData(base_type, sub_type)
					if (!_data) return
					this.RefreshRed()

					if (reward_data) {
						// let rewards = model.GetRewardsBySex(reward_data.reward)
						let rewards = ErlangParser.GetInstance().Parse(reward_data.reward)
						new CongratulationObtainView(rewards, 10).Open();

						let moneys = [];
						let ids: number[] = [31, 34, 35];
						for (const iterator of rewards) {
							let [type_id_, lock_] = GoodsModel.GetInstance().GetMappingTypeId(iterator[0], iterator[1])
							if (ids.indexOf(type_id_) != -1) {
								moneys.push(iterator);
							}
						}
						if (moneys && moneys.length > 0) {
							let point = this._btn_get.localToGlobal(new Laya.Point(this._btn_get.width / 2, 0))
							GlobalEventSystem.Fire(EventName.REWARD_FLY, moneys, point, undefined, undefined, 0, 0)
							// for (const iterator of moneys) {
							// 	let [type_id_, lock_] = GoodsModel.GetInstance().GetMappingTypeId(iterator[0], iterator[1])
							// 	goods_model.Fire(GoodsModel.REQUEST_CCMD_EVENT, 15050, "li", type_id_, iterator[2]);
							// }
						}
						// FunctionOpenModel.GetInstance().Fire(FunctionOpenEvent.FUNCTIONOPEN_GET_REWARD_SUCCESS, scmd.id)

						model.DeleteSpecialIcon(base_type, _info)
					}
				}
			})

			_util.AddClickEvent(this._img_instruction, () => {
				GlobalEventSystem.Fire(EventName.OPEN_INSTRUCTION_VIEW, 73)
			}, this, true)
		}

		this.RefreshView = (info_cond) => {
			let info = _info
			let data = _data
			if (!_data || !_info) return

			if (!_reward_list) {
				_reward_list = []
			}

			for (let vo of data.reward_list) {
				let list = ErlangParser.GetInstance().Parse(vo.reward)
				if (list) {
					for (let i = 0; i < list.length; i++) {
						let item_info = list[i]
						let item = _reward_list[i]
						if (!item) {
							item = new BaseAwardItem(this._gp_reward)
							item.SetItemSize(73, 73)
							item.Load()
							_reward_list.push(item)
						}
						let [type_id_, lock] = goods_model.GetMappingTypeId(item_info[0], item_info[1])
						let basic = goods_model.GetGoodsBasicByTypeId(type_id_)
						if (basic) {
							item.SetData(type_id_, item_info[2])
							item.visible = true

							if (i < 2) {
								_show_reward_id[i] = type_id_;
							}
						}
					}
				}
			}

			if (info_cond && info_cond.recharge) {
				let recharge_cfg = res_mgr.GetGameConfigFromCache(this, "config_recharge_product", false)
				_product_info = recharge_cfg[info_cond.recharge]
			}
			if (info_cond && info_cond.cost && info_cond.cost[0]) {
				_cost_info = info_cond.cost[0]
			}
		}

		this.ShowGoods = (info_cond) => {
			if (!info_cond) return
			let cond = info_cond
			this.ClearShow()
			if (cond.show_left && cond.show_left[0]) {
				this.ShowUIGoods(cond.show_left[0], this._gp_model1, 0)
			}
			if (cond.show_right && cond.show_right[0]) {
				this.ShowUIGoods(cond.show_right[0], this._gp_model2, 1)
			}
		}

		this.ShowUIGoods = (item_data, parent, pos) => {
			if (item_data[0] == "show_model" && item_data[1]) {
				//展示model
				let call_back = (ui_model) => {
					_uiModel[pos] = ui_model
					_uiID[pos] = 1
				}
				model.ShowViewModel(this, "WXOneMoneyView", item_data[1][0], parent, call_back)
			}
			else if (item_data[0] == "show_effect" && item_data[1]) {
				//展示特效
				if (item_data[1][0][1] == "ui_2044") {
					this.AddUIEffect(item_data[1][0][1], parent, undefined, 6, true, undefined, undefined, () => {
						parent.mouseEnabled = true
					})
				}
				// this.AddUIEffect(item_data[1][0][1], parent, undefined, 0.7, true, undefined, undefined)
				_uiModel[pos] = parent
				_uiID[pos] = 2
			}
		}

		this.RefreshRed = () => {
			if (!_data) return
			let status = _data.reward_list[0].status
			this._img_icon.visible = false
			if (status == 0) {
				if (_product_info && !_cost_info) {
					this._gp_btn_h.centerX = 0
					this._lb_text.text = '1元立购'
				} else {
					this._gp_btn_h.centerX = 5
					this._lb_text.text = `购买${_cost_info[2]}`
					this._img_icon.visible = true
				}
				this._btn_red.visible = false
				// this._gp_effect.visible = false
			}
			else if (status == 1) {
				this._lb_text.text = '领取'
				this._btn_red.visible = true
				// this._gp_effect.visible = true
			}
			else if (status == 2) {
				this._lb_text.text = '已领取'
				this._btn_red.visible = false
				// this._gp_effect.visible = false
			}
			this._gp_btn_h.refresh()
		}

		this.ClearShow = () => {
			for (let i in _uiID) {
				let index = _uiID[i]
				if (index == 1) {
					_uiModel[i].DeleteMe()
				} else if (index == 2) {
					this.ClearUIEffect(_uiModel[i])
				}
			}
		}

		this.SetActInfo = (info, parm) => {
			if (!info) return
			_info = info
		}

		this.ClearView = () => {
			this.ClearShow()
			if (_reward_list && _reward_list.length > 0) {
				for (let item of _reward_list) {
					item.DeleteMe()
				}
				_reward_list.length = 0
			}
		}
	}


	public GetComponents() {
		[
			this._bg,
			this._lb_name_0,
			this._lb_name_1,
			this._btn_close,
			this._img_desc,
			this._img_left_desc,
			this._img_right_desc,
			this._img_left_bg,
			this._img_right_bg,
			this._item_group,
			this._gp_reward,
			this._btn_get,
			this.btn_bg,
			this._gp_btn_h,
			this._lb_text,
			this._img_icon,
			this._btn_red,
			this._gp_model2,
			this._gp_model1,
			this._gp_effect,
			this._img_instruction,
		]
			= this.GetChildrenByNames([

				"_bg",
				"_lb_name_0",
				"_lb_name_1",
				"_btn_close",
				"_img_desc",
				"_img_left_desc",
				"_img_right_desc",
				"_img_left_bg",
				"_img_right_bg",
				"_item_group",
				"_gp_reward",
				"_btn_get",
				"btn_bg",
				"_gp_btn_h",
				"_lb_text",
				"_img_icon",
				"_btn_red",
				"_gp_model2",
				"_gp_model1",
				"_gp_effect",
				"_img_instruction",
			])
		this._item_group.hScrollBar.visible = false
	}
}
window["WXOneMoneyView"] = WXOneMoneyView
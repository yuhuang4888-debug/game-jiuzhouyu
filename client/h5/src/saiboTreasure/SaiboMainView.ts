import { Alert, Alert_Type } from "../alert/Alert"
import { BaseItem1 } from "../common/BaseItem1"
import { CongratulationObtainView, enum_CongratulaionType } from "../common/CongratulationObtainView"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { OpenFun } from "../common/OpenFun"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { RoleManager } from "../commonModel/RoleManager"
import { SaiboModel, SaiBoModelEvent } from "../commonModel/SaiboModel"
import { Message } from "../sysInfo/SysInfoController"
import { ColorUtil } from "../util/ColorUtil"
import { GameResPath } from "../util/GameResPath"
import { Runner } from "../util/Runner"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest, Util } from "../util/Util"
import { SaiboTabItem } from "./SaiboTabItem"
import { SaiboTotalItem } from "./saiboTotalItem"

export class SaiboMainView extends BaseItem1 {
	CustomMehod
	InitEvent
	InitItem
	InitRadioBtn
	LoadSuccess
	RefAllRewardItem
	RefAllTimes
	RefCumRewardItem
	SelectGrade
	ShowModel
	Update
	item_call_back
	custom_sorting_order

	private selectIndex: number = 0
	private loop_mgr: LoopScrowViewMgr;
	private _info: any = null;
	private timer_id: number;
	private timeout_id: number[] = [];

	private show_item_list: any[] = []
	private un_show_item_list: any[] = []
	private all_show_item_list: any[] = []
	private total_item_list: any[] = []
	private actData: any = null;

	public constructor(parent?) {
		super(parent)


		this.base_file = "saiboTreasure"
		this.layout_file = "SaiboMainView"
		this.is_load_res = false;
		this.layer_value = Enum_UILayer.UI;
		let model: CustomActivityModel = CustomActivityModel.GetInstance();
		let local_ResManager = ResManager.GetInstance();
		let local_Event = CustomActivityDefine.EVENT;
		let local_GoodsModel = GoodsModel.GetInstance();
		let saibo_Model = SaiboModel.GetInstance();

		let info_cond = null
		let cost_goods_basic = null
		let one_cost_num = null
		let ten_cost_num = null
		let have_num = 0
		let array_collection = null
		let enter_btn = true
		this.load_callback = () => {

			// if (PlatformMgr.GetInstance().IsEyouEnPlatform()) {
			// 	let csf = this._Label3.GetComponent("ContentSizeFitter")
			// 	csf.horizontalFit = UnityEngine.UI.ContentSizeFitter.FitMode.Unconstrained
			// 	csf.verticalFit = UnityEngine.UI.ContentSizeFitter.FitMode.Unconstrained
			// 	SetSizeDelta(this._Label3, 85, 100)
			// 	SetAnchoredPosition(this._Label3, 0, 18)
			// 	this._Label3.size = 18
			// 	this._Label3.lineSpacing = 0.7
			// 	SetAnchoredPositionX(this._Image3, 98)
			// }
			this.LoadSuccess();
			this.InitEvent();
			this.StartTimer();
		}

		this.LoadSuccess = () => {
			let addUIEffect = (...new_args) => {
				let args = new_args
				this.AddUIEffect(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9])
			}
			// this.custom_sorting_order = this.AddCurrLayerSortingOrder(this.layer_value)
			// local_ResManager.SetImageSprite(this, this._img_bg, 'bigBg', '');
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetBigBgPath("uisbdb_001.jpg"))
			// local_ResManager.SetImageSprite(this, this._img_fight_down, 'common', 'uisbdb_017');
			local_ResManager.SetOutsideImageSprite(this, this._img_mask, GameResPath.GetIcon('saiboTreasure', 'mask'));
			local_ResManager.SetImageSpriteTrans(this, this._img_line, GameResPath.GetIcon('saiboTreasure', 'line'), true);
			local_ResManager.SetImageSpriteTrans(this, this._img_line0, GameResPath.GetIcon('saiboTreasure', 'line'), true);
			let _data = {
				custom_sorting_order: this.custom_sorting_order
			}
			// this.AddUIEffect("UI_2003_1", this._gp_effect, null, null, true, _data)
			// this.AddUIEffect("UI_2003_2", this._gp_effect1, null, null, true, _data)
			if (!this._info) {
				return
			}

			this.actData = model.GetActData(this._info.base_type, this._info.sub_type)
			if (!this.actData) {
				return
			}
			this.updateRedDot();
			this.selectRedIndex();
			this.InitRadioBtn();
			this.InitItem();
			this.RefAllTimes();
			info_cond = model.GetActCondition(this._info.base_type, this._info.sub_type, "info")
			if (info_cond && info_cond.goods.length > 0) {
				let fight = info_cond.fighting;
				if (fight && fight.length) {
					let type = fight[0][0];
					this._img_fight.visible = type == "1";
					this._gp_fight.visible = type == "0";
					if (type == "1") {
						local_ResManager.SetOutsideImageSprite(this, this._img_fight, GameResPath.GetIcon('saiboTreasure', fight[0][1]), true)
						if (this._gp_fight_fire) {
							let _data1 = {
								custom_sorting_order: this.custom_sorting_order + 3
							}
							// this.AddUIEffect("UI_1104",  this._gp_fight_fire, { x: 35, y: -102, z: 0 }, { x: 0.8, y: 1.5, z: 1 }, true, _data1)
							// this.AddUIEffect("UI_1104", this._gp_fight_fire, undefined, undefined, true);
						}
					} else {
						this._bit_fight.text = "a" + fight[0][1];
					}
				}
				if (info_cond.reward_pic) {
					ResManager.GetInstance().SetOutsideImageSprite(this, this._img_reward, GameResPath.GetIcon('saiboTreasure', info_cond.reward_pic))
				}
				let show_model = info_cond.show_model[0];
				let resIds: number[] = [];
				// let model_id = show_model[1]
				for (const key in show_model) {
					if (Object.prototype.hasOwnProperty.call(show_model, key)) {
						const element = show_model[key];
						resIds.push(element)
					}
				}
				this.ShowModel(resIds);
			}
		}

		this.InitEvent = () => {
			let buy_callback = (num?) => {
				if (!enter_btn) {
					Message.show("点击过快")
					return
				}
				enter_btn = false
				let id = setTimeout(() => {
					enter_btn = true
				}, 0.3)

				table.insert(this.timeout_id, id)
				if (one_cost_num >= 0) {
					let need_num = (num == 1 && (one_cost_num) || (ten_cost_num))
					let str = null
					let need_money = null
					if (!this._info) {
						return
					}
					let base_type = this._info.base_type
					let sub_type = this._info.sub_type
					let act_key_dic = model.act_key_dic
					let cur_key_dic = act_key_dic[base_type] && act_key_dic[base_type][sub_type] || {}
					let basic = cost_goods_basic
					let openAlert = false
					if (need_num > have_num && basic) {
						let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_goods_price", false)
						let price_info = cfg[basic.type_id];
						if (!price_info) {
							return
						}
						let buy_num = need_num - have_num
						need_money = price_info.price * buy_num
						let goods_color = ColorUtil.GetColorDark(basic.color)
						str = "是否花费<font color='#34a064'>" + need_money + "勾玉</font>购买" + buy_num + "个<font color=" + goods_color + ">" + basic.goods_name + "</font>"
					}

					let request = (times?, auto_buy?) => {
						model.Fire(local_Event.SCMD_REQUEST, 33167, base_type, sub_type, times, auto_buy)
					}

					let recharge = () => {
						let jin = RoleManager.GetInstance().mainRoleInfo.jin
						if (need_money && need_money > jin) {
							Alert.Show("勾玉不足，是否前往充值", Alert_Type.Two, () => {
								OpenFun.OpenFunHandler(21)
							})
						} else {
							request(num, 1)
						}
					}

					let ok_callback = () => {
						recharge()
						if (openAlert) {
							act_key_dic[base_type] = act_key_dic[base_type] || {}
							act_key_dic[base_type][sub_type] = act_key_dic[base_type][sub_type] || {}
							let _openAlert = act_key_dic[base_type][sub_type]["openAlert"]
							act_key_dic[base_type][sub_type]["openAlert"] = (_openAlert && (!_openAlert) || (false))
						}
					}

					if (str) {
						let is_openAlert = cur_key_dic && cur_key_dic["openAlert"]
						if (is_openAlert == false) {
							recharge()
							return
						}
						Alert.Show(str, Alert_Type.AlertTypeCheckBox, ok_callback, null, null, null, null, null, () => {
							openAlert = !openAlert
						}
						)
					} else {
						request(num, 0)
					}
				}
			}

			Util.AddClickEvent(this._btn_one, () => {
				buy_callback(1)
			}, this, true)
			this.BindEvent(model, local_Event.ANSWER_TARGET, (...new_args) => {
				if (!this._info) {
					return
				}
				let args = new_args
				if (this._info.base_type == args[0] && this._info.sub_type == args[1]) {
					let rewards = args[2]
					let list = []
					let is_rare = false
					this.actData = model.GetActData(args[0], args[1])
					if (rewards.grade_stage) {
						let reward = rewards.reward
						for (let _tmpi in reward) {
							var v = reward[_tmpi]
							let vo = []
							vo[0] = v.style
							vo[1] = v.typeId
							vo[2] = v.count
							table.insert(list, vo)
						}
					} else if (rewards.reward_list && rewards.reward_list.length > 0) {
						for (let _tmpi in rewards.reward_list) {
							var reward = rewards.reward_list[_tmpi]
							for (let _tmpi in reward.reward) {
								var v = reward.reward[_tmpi]
								let vo = []
								vo[0] = v.style
								vo[1] = v.typeId
								vo[2] = v.count
								vo[3] = reward.is_rare
								table.insert(list, vo)
								is_rare = true
							}
						}
						this.RefAllTimes()
						this.RefAllRewardItem()
					}
					this.updateRedDot();
					this.InitRadioBtn();
					if (list.length > 0) {
						let view = null
						if (is_rare) {
							view = new CongratulationObtainView(list, 10, null, null, null, null, enum_CongratulaionType.rare_reward)
						} else {
							view = new CongratulationObtainView(list, 10)
						}
						if (view) {
							view.Open()
						}
					}
				}
			})

			Util.AddClickEvent(this._img_cost_icon, () => {
				if (cost_goods_basic) {
					UIToolTipMgr.GetInstance().DefaultAppendTips(cost_goods_basic.type_id, 0)
				}
			}, this, true);

			this.BindEvent(model, local_Event.UPDATE_VIEW, (...new_args) => {
				if (!this._info) {
					return
				}
				let args = new_args
				if (this._info.base_type == args[0] && this._info.sub_type == args[1]) {
					this.actData = model.GetActData(this._info.base_type, this._info.sub_type)
					this.updateRedDot();
					this.RefAllTimes();

				}
			})

			this.BindEvent(saibo_Model, SaiBoModelEvent.SELECT_TAB, (data: any, index: number) => {
				this.selectIndex = index;
				this.SelectGrade(index);
				this.loop_mgr.SetSelectIndex(index);
			});
		}


		this.SelectGrade = (index: number) => {
			if (!this.actData) {
				return
			}
			let cur_stage_list = this.actData.stage_s && this.actData.stage_s[index]
			let cum_rewards = cur_stage_list && cur_stage_list.grade_state
			if (this.total_item_list.length > 0) {
				for (let _tmpi in this.total_item_list) {
					var item = this.total_item_list[_tmpi]
					item.visible = false
				}
			}
			if (cum_rewards && cum_rewards.length > 0) {
				for (let i in cum_rewards) {
					let item = this.total_item_list[i]
					if (!item) {
						item = new SaiboTotalItem(this.Content)
						item.Load()
						table.insert(this.total_item_list, item)
					}
					item.ExcuteCallback(() => {
						item.SetData(cum_rewards[i], this.actData, i, cur_stage_list.stage, this.custom_sorting_order)
						item.visible = true
					}
					)
				}
			}
		}

		// 渲染tab
		this.InitRadioBtn = () => {
			if (!this.actData) {
				return
			}
			let grade_cfgs = saibo_Model.GetStageCfg(this.actData.base_type, this.actData.sub_type);

			let confs: any[] = [];
			for (const key in grade_cfgs) {
				if (Object.prototype.hasOwnProperty.call(grade_cfgs, key)) {
					const element = grade_cfgs[key];
					confs.push(element)
				}
			}

			if (!this.loop_mgr) {
				this.loop_mgr = new LoopScrowViewMgr();
				this.loop_mgr.SetData(
					this.tabList,
					SaiboTabItem,
					confs,
					LoopScrCon.Horizontal,
				);
			} else {
				this.loop_mgr.replaceAll(confs);
			}
			this.loop_mgr.SetSelectIndex(this.selectIndex);
			// let grade_max = []
			// for (let i in grade_cfgs) {

			// 	let dic = grade_cfgs[i]
			// 	if (!dic) {
			// 		return
			// 	}
			// 	let len = Util.TableSize(dic)
			// 	let max_cfg = dic[len]
			// 	let index = Number(i) - 1
			// 	if (max_cfg) {
			// 		let min = 0;// (grade_max[grade_max].length && (grade_max[grade_max].length + 1) || (0))
			// 		let max = max_cfg.condition && max_cfg.condition.total
			// 		let label = this["labelDisplay" + index];
			// 		label.text = min + "~" + max + "次";
			// 		grade_max[Number(i)] = max;
			// 		this["_btn_radio_" + index].GetComponent("Toggle").onValueChanged.AddListener((e?) => {
			// 			//SoundManager:GetInstance():PlaySoundEffect("2_dianji")
			// 			this.select_index = index + 1
			// 			this.SelectGrade(index + 1)
			// 		})
			// 	}
			// }
			// if (grade_max.length > 0) {
			// 	this._btn_all_num.text = '0'; // grade_max[grade_max].length
			// }
		}

		this.ShowModel = (model_id?) => {
			// let func = () => {
			// 	// let order = this.AddCurrLayerSortingOrder(this.layer_value)
			// 	// this:.CoverMode(this._gp_fight,this.layer_value,order)
			// 	// this:CoverMode(this._img_fight,this.layer_value,order)
			// }
			model.ShowViewModel(this, this.layout_file, model_id, this._gp_model, null, null, this.custom_sorting_order, null, null, true)
		}

		this.InitItem = () => {
			if (!this.actData) {
				return
			}
			let rewards = this.actData.pool;
			if (this.show_item_list.length > 0) {
				for (let _tmpi in this.show_item_list) {
					let item: SaiboTotalItem = this.show_item_list[_tmpi]
					item.SetVisible(false);
				}
			}
			if (this.un_show_item_list.length > 0) {
				for (let _tmpi in this.un_show_item_list) {
					let item: SaiboTotalItem = this.un_show_item_list[_tmpi]
					item.SetVisible(false);
				}
			}
			let width = 140
			let height = 110

			let initItemPos = (item: SaiboTotalItem, i: number) => {
				let x = 0
				let y = 0
				if (i == 0) {
					x = 130;
					y = 620;
				} else if (i < 6) {
					x = 0;
					y = 620 - (i - 1) * (30 + height);
				} else if (i >= 6 && i < 10) {
					x = 135 + (i - 6) * (0 + width);
					y = 60;
				} else if (i >= 10 && i < 14) {
					x = 555;
					y = 200 + (i - 10) * (30 + height);
				} else if (i == 14) {
					x = 430;
					y = 620;
				}

				item.SetPosition(x, y)
			}

			if (rewards && rewards.length > 0) {
				let length = this.show_item_list.length
				for (let i in rewards) {
					let item: SaiboTotalItem = (Number(i) < length && (this.show_item_list[i]) || (this.un_show_item_list[Number(i) - length]))
					if (!item) {
						item = new SaiboTotalItem(this._gp_show)
						item.Load()
						if (Number(i) <= 15) {
							initItemPos(item, Number(i))
							item.SetVisible(true);
							table.insert(this.show_item_list, item)
							table.insert(this.all_show_item_list, item)
						} else {
							item.SetVisible(false)
							table.insert(this.un_show_item_list, item)
							table.insert(this.all_show_item_list, item)
						}
					}
					item.ExcuteCallback(() => {
						// item.SetVisible((length > 0 && Number(Number(i) <= length && (true) || (false))))
						item.SetVisible(Number(i) < 15)
						item.SetData(rewards[i], this.actData, i, null, this.custom_sorting_order)
					})
				}
			}
			let sorting_order = this.custom_sorting_order + 2
			// this.CoverEffect(this._img_mask, this.layer_value, sorting_order)
			// this.CoverEffect(this._img_line, this.layer_value, sorting_order)
			// this.CoverEffect(this._img_line0, this.layer_value, sorting_order)
			// this.CoverEffect(this._gp_fight, this.layer_value, sorting_order)
			//this:CoverEffect(this._gp_fight_fire,this.layer_value,sorting_order)
			// this.CoverEffect(this._img_fight, this.layer_value, sorting_order + 2)
			this.RefAllRewardItem()
		}

		this.RefAllRewardItem = () => {
			Runner.GetInstance().AddRunObj(this, 1)
			this.selectRedIndex();
			this.SelectGrade(this.selectIndex);
		}

		let end_pos = [{ x: 380, y: 620 }]
		let start_pos = [{ x: 205, y: 620 }]
		this.item_call_back = (item?, i?) => {
			if (!item) {
				if (this.show_item_list.length > 15) {
					return
				}
				let _item = this.un_show_item_list[0]
				if (_item) {
					table.insert(this.show_item_list, _item)
					_item.SetPosition(start_pos[0].x, start_pos[0].y)
					_item.visible = true
					table.splice(this.un_show_item_list, 0, 1)
				}
				return
			}
			table.splice(this.show_item_list, Number(i), 1)
			item.visible = false
			table.insert(this.un_show_item_list, item)
		}

		this.Update = () => {
			for (let i in this.show_item_list) {
				let item: SaiboTotalItem = this.show_item_list[i];
				if (!item && !item.is_loaded) {
					return;
				}
				let itemY: number = item.GetPoxY;
				let itemX: number = item.GetPoxX;
				let offset: number = 1.8;
				if (itemX <= 0 && itemY > 60 && itemY <= 620) {
					item.SetPosition(0, itemY - offset)
				} else if (itemX >= 0 && itemX < 555 && itemY <= 60) {
					item.SetPosition(itemX + offset, 60)
				} else if (itemX >= 555 && itemY < 620 && itemY >= 60) {
					item.SetPosition(555, itemY + offset)
				} else if (itemX <= 555 && itemY >= 620) {
					item.SetPosition(itemX - offset, 620)
					if (itemX + offset <= end_pos[0].x && itemX > start_pos[0].x) {
						item.SetPosition(start_pos[0].x, start_pos[0].y)
					}
				}
			}
		}

		this.RefCumRewardItem = () => {
			if (!this.actData || !this.actData.stage_s) {
				return
			}
			let num = 0
			for (let i in this.actData.stage_s) {
				let cur_stage_list = this.actData.stage_s[i]
				let cum_rewards = cur_stage_list && cur_stage_list.grade_state
				if (cum_rewards && cum_rewards.length > 0) {
					for (let i in cum_rewards) {
						let item = this.total_item_list[num]
						num = num + 1
						if (item) {
							item.SetData(cum_rewards[i], this.actData, i, cur_stage_list.stage)
						}
					}
				}
			}
			let rewards = this.actData.pool
			if (rewards && rewards.length > 0) {
				for (let i in rewards) {
					let item = this.all_show_item_list[i]
					if (item) {
						item.SetData(rewards[i], this.actData, i)
					}
				}
			}
		}

		this.RefAllTimes = () => {
			if (this.actData && this._info) {
				let cur_time = this.actData.all_times
				let str = "累计夺宝:<font color='#A2FF00'>" + cur_time + "次</font>"
				let all_times = 0
				if (this._info) {
					let cond = model.GetActCondition(this._info.base_type, this._info.sub_type, "info")
					if (((cond && cond.wave) && cond.special) && cond.normal) {
						all_times = Number(cond.wave) * (Number(cond.special) + Number(cond.normal))
					}
				}
				str = str + "<font color='#4DFFEC'>(本次活动共可夺宝:" + all_times + "次)</font>";

				this._lb_total_num.style.fontSize = 18;
				this._lb_total_num.style.color = '#A2FF00';
				this._lb_total_num.style.align = "center";
				this._lb_total_num.style.bold = true;
				this._lb_total_num.style.letterSpacing = 2;
				this._lb_total_num.width = 440;

				this._lb_total_num.innerHTML = Util.StrToHTML(str)
				let today_times = this.actData.today_drawtimes
				let cur_cost = saibo_Model.GetCostCfgByTimes(today_times)
				if (cur_cost && cur_cost.cost) {
					this._img_discount.visible = cur_cost.is_dis == 1
					let discount_num = saibo_Model.discount_num
					let dis_num = today_times >= discount_num ? 0 : discount_num - today_times;
					this._lb_dicount.text = `${dis_num}/${discount_num}`; //Util.StrToHTML("每日超值次数：<font color=0xa2ff00>" +  + "</font>")
					let goods = JSON.parse(cur_cost.cost)[0]
					if (goods) {
						let [type_id, lock] = local_GoodsModel.GetMappingTypeId(goods[0], goods[1])
						have_num = local_GoodsModel.GetTypeGoodsNum(type_id)
						let bool = false
						if (have_num >= goods[2]) {
							bool = true
						}
						this._img_red_one.visible = bool
						let basic = local_GoodsModel.GetGoodsBasicByTypeId(type_id)
						if (basic) {
							cost_goods_basic = basic
							local_ResManager.SetOutsideImageSprite(this, this._img_cost_icon, GameResPath.GetGoodsIconPath(basic.goods_icon))
						}
						this._lb_cost_num.text = (goods[2] == 0 && ("免费") || (goods[2]))
						one_cost_num = goods[2]
						this._img_red_one.visible = goods[2] == 0
					}
				}
			}
		}

		this.CustomMehod = (index?, args?) => {
			this._info = args && args[0];
		}


	}

	private selectRedIndex() {
		for (let i = 0; i < this.actData.stage_s.length; i++) {
			const element = this.actData.stage_s[i];
			let redIndex: number = element.grade_state.findIndex((data: any) => {
				return data.state_stage == 1; // 是否有可领取的奖励
			});

			if (redIndex != -1) {
				this.selectIndex = i;
				break;
			}
		}
	}

	private updateRedDot() {
		let grade_cfgs = SaiboModel.GetInstance().GetStageCfg(this.actData.base_type, this.actData.sub_type);

		let confs: any[] = [];
		for (const key in grade_cfgs) {
			if (Object.prototype.hasOwnProperty.call(grade_cfgs, key)) {
				const element = grade_cfgs[key];
				confs.push(element)
			}
		}

		let bool: boolean = confs.some((data: any) => {
			return CustomActivityModel.GetInstance().GetGradeRed(data[1].type, data[1].subtype, data[1].stage)
		});

		let today_times = this.actData.today_drawtimes
		let cost_cfg = SaiboModel.GetInstance().GetCostCfgByTimes(today_times)
		let goods = JSON.parse(cost_cfg.cost)[0];
		if (!bool && Number(goods[2]) != 0) {
			CustomActivityModel.GetInstance().CloseACTRed(this._info.base_type, this._info.sub_type)
		}


	}


	public DeleteMe() {
		this.DeleteMeFunc()
	}


	private DeleteMeFunc() {
		if (this.loop_mgr) {
			this.loop_mgr.DeleteMe();
			this.loop_mgr = null;
		}

		if (this.timeout_id.length > 0) {
			for (let _tmpi in this.timeout_id) {
				var id = this.timeout_id[_tmpi]
				clearTimeout(id)
			}
			this.timeout_id = []
		}
		if (this.all_show_item_list.length > 0) {
			this.all_show_item_list = []
		}
		if (this.show_item_list.length > 0) {
			for (let _tmpi in this.show_item_list) {
				var item = this.show_item_list[_tmpi]
				item.DeleteMe()
			}
			this.show_item_list = []
		}
		if (this.un_show_item_list.length > 0) {
			for (let _tmpi in this.un_show_item_list) {
				var item = this.un_show_item_list[_tmpi]
				item.DeleteMe()
			}
			this.un_show_item_list = []
		}
		if (this.total_item_list.length > 0) {
			for (let _tmpi in this.total_item_list) {
				var item = this.total_item_list[_tmpi]
				item.DeleteMe()
			}
			this.total_item_list = []
		}
		Runner.GetInstance().RemoveRunObj(this.$hashCode);
		this.StopTimer();
		super.DeleteMe();
	}


	/**
	 * 倒计时
	 */
	public StartTimer() {
		if (!this._info) {
			this.StopTimer();
			return;
		}
		this.StopTimer();
		let loop_func = () => {
			let left_time = this._info.etime - TimeUtil.getServerTime()
			if (left_time <= 0) {
				this.StopTimer();
				this._gp_time.text = '已结束';
			} else {
				let time: string = TimeUtil.timeConvert(left_time, 'hh-mm-ss')
				this._gp_time.text = time;
			}
		}

		this.timer_id = GlobalTimerQuest.AddPeriodQuest(loop_func, 1, -1);
		loop_func();
	}

	public StopTimer() {
		if (this.timer_id) {
			GlobalTimerQuest.CancelQuest(this.timer_id)
			this.timer_id = null
		}
	}


	_img_bg: Laya.Image
	_gp_time: Laya.Label
	_img_reward: Laya.Image
	_btn_all_num: Laya.Label
	_gp_effect: Laya.Box
	_gp_effect1: Laya.Box
	_gp_show: Laya.Box
	_img_mask: Laya.Image
	_img_line: Laya.Image
	_img_line0: Laya.Image
	_gp_model: Laya.Box
	_gp_fight_fire: Laya.Box
	_img_fight: Laya.Image
	_gp_fight: Laya.Box
	_img_fight_down: Laya.Image
	_bit_fight: Laya.Label
	_Scroller1: Laya.Panel
	Content: Laya.HBox
	_lb_total_num: Laya.HTMLDivElement
	_btn_one: Laya.Box
	_Image4: Laya.Image
	_Label1: Laya.Label
	_gp_one: Laya.HBox
	_img_icon_one: Laya.Image
	_Group1: Laya.HBox
	_lb_num_one: Laya.Label
	_lb_cost_one: Laya.Label
	_img_red_one: Laya.Image
	_img_discount: Laya.Image
	_Group3: Laya.Box
	_Label3: Laya.Label
	_img_cost_icon: Laya.Image
	_lb_cost_num: Laya.Label
	_lb_dicount: Laya.Label
	tabList: Laya.List
	public GetComponents() {
		[
			this._img_bg,
			this._gp_time,
			this._img_reward,
			this._btn_all_num,
			this._gp_effect,
			this._gp_effect1,
			this._gp_show,
			this._img_mask,
			this._img_line,
			this._img_line0,
			this._gp_model,
			this._gp_fight_fire,
			this._img_fight,
			this._gp_fight,
			this._img_fight_down,
			this._bit_fight,
			this._Scroller1,
			this.Content,
			this._lb_total_num,
			this._btn_one,
			this._Image4,
			this._Label1,
			this._gp_one,
			this._img_icon_one,
			this._Group1,
			this._lb_num_one,
			this._lb_cost_one,
			this._img_red_one,
			this._img_discount,
			this._Group3,
			this._Label3,
			this._img_cost_icon,
			this._lb_cost_num,
			this._lb_dicount,
			this.tabList,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_gp_time",
				"_img_reward",
				"_btn_all_num",
				"_gp_effect",
				"_gp_effect1",
				"_gp_show",
				"_img_mask",
				"_img_line",
				"_img_line0",
				"_gp_model",
				"_gp_fight_fire",
				"_img_fight",
				"_gp_fight",
				"_img_fight_down",
				"_bit_fight",
				"_Scroller1",
				"Content",
				"_lb_total_num",
				"_btn_one",
				"_Image4",
				"_Label1",
				"_gp_one",
				"_img_icon_one",
				"_Group1",
				"_lb_num_one",
				"_lb_cost_one",
				"_img_red_one",
				"_img_discount",
				"_Group3",
				"_Label3",
				"_img_cost_icon",
				"_lb_cost_num",
				"_lb_dicount",
				"tabList",
			])
	}
}
window["SaiboMainView"] = SaiboMainView
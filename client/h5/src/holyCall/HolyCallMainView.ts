import { BaseItem1 } from "../common/BaseItem1"
import { table } from "../common/table"
import { Util, Trim, Color } from "../util/Util"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { CustomActivityDefine, Enum_Btn_Type } from "../commonModel/CustomActivityDefine"
import { GoodsModel } from "../commonModel/GoodsModel"
import { Message } from "../sysInfo/SysInfoController"
import { ColorUtil } from "../util/ColorUtil"
import { CongratulationObtainView, enum_CongratulaionType } from "../common/CongratulationObtainView"
import { CongratulationRareView } from "../common/CongratulationRareView"
import { Alert, Alert_Type } from "../alert/Alert"
import { LoopScrowViewMgr, LoopScrCon } from "../common/LoopScrowViewMgr"
import { EquipmentItem } from "../common/EquipmentItem"
import { CommonRewardItem } from "../common/CommonRewardItem"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { HolyCallMainItem } from "./HolyCallMainItem"
import { HolyCallMainItemTwo } from "./HolyCallMainItemTwo"
import { Enum_Currency_Type } from "../commonModel/CustomActivityDefine"

export class HolyCallMainView extends BaseItem1 {
	CustomMehod
	Dispose
	InitBtn
	InitEvent
	LoadSuccess
	RarePool
	ReOpen_callback
	UdpateShowItems
	UpdateItems
	UpdateView

	_Viewport1
	_pos_list
	act_type
	cfg_act_view

	_lb_rare: Laya.Label
	_red: Laya.Image
	_btn_rare: Laya.Image
	_time: Laya.Box
	_Scroller2: Laya.List

	public constructor(parent?) {
		super(parent)
		this.base_file = "holyCall"
		this.layout_file = "HolyCallMainView"
		this.preload_client_config = {
			"ConfigCustomActivityView": false
		}

		this._pos_list = [{ size: 95, count: 3 }, { size: 70, count: 5 }, { size: 70, count: 6 }]
		this.act_type = 0
		let local_EVENT = CustomActivityDefine.EVENT
		let local_goodsmodel = GoodsModel.GetInstance()
		let _model = CustomActivityModel.GetInstance()
		let _item_list = null
		let record_item = null
		let time_item = null
		let one_btn = null
		let ten_btn = null
		let _data = null
		let info = null
		let _ac_item_loop_list = null
		let _ac_item_loop_mgr = null
		let _sp_item_loop_list = null
		let _sp_item_loop_mgr = null
		let rare_draw_cost = null
		//let mask_item_mat = new Material(ShaderTools.GetShader("UI-Default_mask"))

		this.load_callback = () => {
			this.LoadSuccess()
		}

		this.InitEvent = () => {
			if (this._btn_reward) {
				Util.AddClickEvent(this._btn_reward, () => {
					if (_data) {
						let list = []
						for (let _tmpi in _data.show_list) {
							let reward = _data.show_list[_tmpi]
							let [type_id, lock] = local_goodsmodel.GetMappingTypeId(reward["reward"][0].style, reward["reward"][0].typeId)
							table.insert(list, [type_id, (reward["reward"][0].count > 1 && (reward["reward"][0].count) || (0))])
						}
						if (list.length > 0) {
							_model.Fire(local_EVENT.OPEN_CUSTOM_VIEW, "CommonActRewardPreview", "customActivity", list, true)
						}
					}
				}, this, true)
			}

			this.BindEvent(_model, local_EVENT.UPDATE_VIEW, (base_type?, sub_type?) => {
				if (info.base_type != base_type || info.sub_type != sub_type) {
					return
				}
				_data = _model.GetActData(info.base_type, info.sub_type)
				this.UpdateView()
			})

			this.BindEvent(_model, local_EVENT.ANSWER_TARGET, (base_type?, sub_type?, result_data?, reward_data?) => {
				if (info.base_type != base_type || info.sub_type != sub_type) {
					return
				}
				let openView = (reward_list?) => {
					let list = []
					let open_rare = false
					let count = 0
					for (let _tmpi in reward_list) {
						let value = reward_list[_tmpi]
						let data = []
						let rew = value.reward[0]
						if (rew.style != 0 || rew.typeId != 0) {
							data[0] = rew.style
							data[1] = rew.typeId
							data[2] = rew.count
							data[3] = value.is_rare
							table.insert(list, data)
						} else {
							open_rare = true
						}
					}
					if (list.length) {
						let view = new CongratulationObtainView(list, 10, null, null, null, null, enum_CongratulaionType.rare_reward)
						view.Open()
						//飘字特效
						let fly_list = CustomActivityModel.GetInstance().GetFlyRewardList(list)
						if(list.length>=10){
							CustomActivityModel.GetInstance().ShowActFlyReward(fly_list, this._btn_ten)
						}else{
							CustomActivityModel.GetInstance().ShowActFlyReward(fly_list, this._btn_one)
						}
					}
					if (open_rare) {
						count = _data.rare_draw_times
						this._lb_rare.text = "拥有" + count + "次"
						this._red.visible = count > 0
						let view = new CongratulationRareView()
						view.SetData(null, 3)
						view.SetSpecialImg("holyCall_asset.uixysd_002c", 2)
						view.Open()
					}
				}

				if (result_data.all_times) {
					openView(result_data.reward_list)
					this.UpdateView()
				} else if (result_data.cumulate_reward) {
					let list = []
					for (let _tmpi in result_data.cumulate_reward) {
						let value = result_data.cumulate_reward[_tmpi]
						list = list.concat(value.reward) //table.merge(list, value.reward)
					}
					Util.ShowCongratulationView(list)
					this.UpdateView()
				} else if (result_data.rare_draw_times != null) {
					let other = 0
					if (rare_draw_cost){
						other = local_goodsmodel.GetTypeGoodsNum(rare_draw_cost[1])
					}
					let times = result_data.rare_draw_times
					_data.rare_draw_times = times
					this._lb_rare.text = "拥有" + Number(times + other) + "次"
					this._red.visible = times > 0
					openView(result_data.reward_list)
				}
			})

			if (this._btn_rare) {
				Util.AddClickEvent(
					this._btn_rare, () => {
						let b = info.base_type
						let s = info.sub_type

						let have_num = 0
						let cost_num = 1
						let is_jump = null
						if (rare_draw_cost) {
							cost_num = rare_draw_cost[2]
							have_num = rare_draw_cost[3]
							is_jump = _model.getKeyDicValue(b, s, "check_good")
						}

						let ok_func = () => {
							if (is_jump) {
								_model.setKeyDicValue(b, s, "check_good", true)
							}
							_model.Fire(local_EVENT.SCMD_REQUEST, 33222, b, s)
						}

						let times = _data.rare_draw_times
						if (times > 0) {
							ok_func()
						} else if (rare_draw_cost && have_num >= cost_num) {
							let basic = rare_draw_cost.basic
							let str = "是否消耗" + cost_num + "个<font color=" + ColorUtil.GetColorLight(basic.color) + ">" + Trim(basic.goods_name) + "</font>抽取一次大奖？"
							if (is_jump) {
								ok_func()
							} else {
								Alert.Show(str, Alert_Type.AlertTypeCheckBox, ok_func, null, null, null, null, null, () => {
									is_jump = !is_jump
								})
							}
						} else {
							Message.show("次数不足")
						}
					},
					this,
					true
				)

				this.BindEvent(local_goodsmodel, GoodsModel.UPDATE_GOODS_NUM, (list?) => {
					if (this.use_delete_method) {
						return
					}
					if (rare_draw_cost) {
						let type = rare_draw_cost[1]
						for (let _tmpi in list) {
							let v = list[_tmpi]
							if (v.type_id == type) {
								rare_draw_cost[3] = local_goodsmodel.GetTypeGoodsNum(type)
								let times = _data.rare_draw_times + rare_draw_cost[3]
								this._lb_rare.text = "拥有" + times + "次"
								return
							}
						}
					}
				})
			}
		}

		this.CustomMehod = (index?, _info?) => {
			info = _info
		}

		this.LoadSuccess = () => {
			if (!info) {
				return
			}
			_data = _model.GetActData(info.base_type, info.sub_type)
			if (!_data) {
				return
			}
			if (_data.rare_pool && _data.rare_pool.length > 0) {
				this.act_type = 1
				if (!time_item && this._time) {
					time_item = _model.LoadActTimer(this._time, info.etime, 20, "#a0ff67", null, "#ffffff", "活动剩余时间：")
				}
				// let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "ConfigCustomActivityView", true)
				// if (cfg) {
				// 	_model.LoadCompontRes(this, cfg, "HolyCallMainView", info.show_id)
				// }
				let times = _data.rare_draw_times
				this._lb_rare.text = "拥有" + times + "次"
				this._red.visible = times > 0
			}
			if (this.act_type == 1) {
				this._Scroller1.vScrollBarSkin = ""
				this._Scroller2.hScrollBarSkin = ""
			}
			_item_list = []

			// this.RegisterMask(this._Viewport1)
			// this.parent_mask = GetWorldCorners(this._Viewport1)
			_ac_item_loop_list = []
			let loop_item = (this.act_type == 1 && (HolyCallMainItemTwo) || (HolyCallMainItem))
			_ac_item_loop_mgr = new LoopScrowViewMgr()
			_ac_item_loop_mgr.SetData(this._Scroller1, loop_item, _ac_item_loop_list, LoopScrCon.Vertical)

			record_item = _model.LoadActRecord(this._gp_record, info.base_type, info.sub_type, null, null, null, "#c4cbda")

			this.UdpateShowItems(_data.show_list)
			this.UpdateView()
			this.InitEvent()
			if (this.act_type == 1) {
				this.RarePool(_data.rare_pool)
				// if (!this.cache_order) {
				// 	this.cache_order = this.AddCurrLayerSortingOrder(this.layer_value)
				// }
				// this.AddUIEffect("UI_2035_1", this.layer_value, this._Image2, null, null, true, { custom_sorting_order = this.cache_order })
				// this.AddUIEffect("UI_2035_2", this.layer_value, this._Image3, null, null, true, { custom_sorting_order = this.cache_order })
				// this.CoverEffect(this._img_rare, this.layer_value, this.cache_order)
			}
		}

		this.ReOpen_callback = () => {
			if (this.act_type == 1) {
				// this.AddUIEffect("UI_2035_1", this.layer_value, this._Image2, null, null, true, { custom_sorting_order = this.cache_order })
				// this.AddUIEffect("UI_2035_2", this.layer_value, this._Image3, null, null, true, { custom_sorting_order = this.cache_order })
			}
		}

		this.UpdateView = () => {
			this.UpdateItems()
			this.InitBtn()
		}

		this.RarePool = (list?) => {
			if (!list) {
				return
			}
			// this.RegisterMask(this._Viewport2)

			if (!_sp_item_loop_list) {
				_sp_item_loop_list = []
			}
			for (let i in list) {
				let info = list[i].reward[0]
				table.insert(_sp_item_loop_list, {
					size: 85,
					vo: info
				})
			}
			// CommonRewardItem.width = 95
			// CommonRewardItem.height = 95
			_sp_item_loop_mgr = new LoopScrowViewMgr()
			_sp_item_loop_mgr.SetData(this._Scroller2, CommonRewardItem, _sp_item_loop_list, LoopScrCon.Horizontal)
		}

		this.UpdateItems = () => {
			let list = _data && _data.cumulate_reward
			if (list) {
				for (let _tmpi in list) {
					let vo = list[_tmpi]
					vo.all_times = _data.all_times
					vo.sub_type = _data.sub_type
					vo.base_type = _data.base_type
					//vo.parent_mask = this.parent_mask
					//vo.mask_item_mat = mask_item_mat
				}
				let sortFunc = (a?, b?) => {
					if (a.grade_id != b.grade_id) {
						return b.grade_id > a.grade_id
					}
					return false
				}

				table.sort(list, sortFunc)
				let _list = []
				for (let _tmpi in list) {
					let v = list[_tmpi]
					if (v.status != 2) {
						table.insert(_list, v)
					}
				}
				for (let _tmpi in list) {
					let v = list[_tmpi]
					if (v.status == 2) {
						table.insert(_list, v)
					}
				}
				list = _list
				_ac_item_loop_list = list
				_ac_item_loop_mgr.replaceAll(_ac_item_loop_list)
			}
		}

		this.UdpateShowItems = (list?) => {
			let index = 0
			for (let i = 0; i < this._pos_list.length; i++) {
				for (let j = 0; j < this._pos_list[i].count; j++) {
					let info = list[index].reward && list[index].reward[0] || null
					let posInfo = this._pos_list[i]
					if (info) {
						let item = _item_list[index]
						if (!item) {
							item = new EquipmentItem(this["itemGp" + (Number(i) + 1)])
							item.SetItemSize(posInfo.size, posInfo.size)
							item.Load()
							_item_list[index] = item
						}
						let [type_id, lock] = local_goodsmodel.GetMappingTypeId(info.style, info.typeId)
						item.SetData(type_id, info.count)
						index = index + 1
					}
				}
			}
		}

		this.InitBtn = () => {
			let v = info
			if (!v) {
				return
			}
			let cond = _model.GetActCondition(v.base_type, v.sub_type, "info")
			if (!cond) {
				return
			}
			let key = null
			let parent = null
			let bg_source = null
			let num = null
			let btn_dic = []
			if (cond.one_cost) {
				key = "one_cost"
				parent = this._btn_one
				btn_dic["text"] = "抽一次"
				btn_dic["strokeColor"] = this.act_type ? 1 && "#485d9c" : (Color(130 / 255, 171 / 255, 32 / 255, 1))
				bg_source = this.act_type == 1 ? GameResPath.GetIcon("common", "ui_button_rect13") : ("common_asset.com_rect_btn13")
				num = 1
				let cost = cond.one_cost[0]
				one_btn = _model.LoadActBtn(parent, one_btn, _data, cost, btn_dic, num, bg_source, null, false, true, null, Enum_Btn_Type.TWO, Enum_Currency_Type.Special, (btn) => {
					if (!btn) {
						return
					}
					btn.SetFreeBtn(_data.free_times > 0, "免费" + _data.free_times + "次")
					btn._name_1.y = 7
					btn._gp_cost_1.centerX = 5
					btn._gp_cost_1.centerY = 15
				})
			}
			let btn_dic2 = []
			if (cond.ten_cost) {
				key = "ten_cost"
				parent = this._btn_ten
				btn_dic2["text"] = "抽十次"
				btn_dic2["strokeColor"] = this.act_type == 1 ? "#af4200" : (Color(204 / 255, 118 / 255, 82 / 255, 1))
				bg_source = this.act_type == 1 ? GameResPath.GetIcon("common", "ui_button_rect12") : ("common_asset.com_rect_btn12")
				num = 10
				let cost = cond.ten_cost[0]
				ten_btn = _model.LoadActBtn(parent, ten_btn, _data, cost, btn_dic2, num, bg_source, null, false, true, null, Enum_Btn_Type.TWO, Enum_Currency_Type.Special, (btn) => {
					if (!btn) {
						return
					}
					btn._name_1.y = 7
					btn._gp_cost_1.centerX = 5
					btn._gp_cost_1.centerY = 15
				})
			}
			if (cond.rare_draw_cost) {
				if (!rare_draw_cost) {
					rare_draw_cost = []
				}
				rare_draw_cost[1] = Number(cond.rare_draw_cost[0][1])//id
				rare_draw_cost[2] = Number(cond.rare_draw_cost[0][2])//num
				rare_draw_cost[3] = local_goodsmodel.GetTypeGoodsNum(rare_draw_cost[1])//have
				let basic = local_goodsmodel.GetGoodsBasicByTypeId(rare_draw_cost[1])
				rare_draw_cost.basic = basic

				let times = _data.rare_draw_times + rare_draw_cost[3]
				this._lb_rare.text = "拥有" + times + "次"
			}
		}

		this.Dispose = () => {
			_ac_item_loop_list = []
			if (_ac_item_loop_mgr) {
				_ac_item_loop_mgr.DeleteMe()
			}
			_sp_item_loop_list = []
			if (_sp_item_loop_mgr) {
				_sp_item_loop_mgr.DeleteMe()
			}
			//CommonRewardItem.width = 78
			//CommonRewardItem.height = 78
			if (_item_list) {
				for (let _tmpi in _item_list) {
					let item = _item_list[_tmpi]
					item.DeleteMe()
				}
			}
			_item_list = null
			if (record_item) {
				record_item.DeleteMe()
			}
			if (ten_btn) {
				ten_btn.DeleteMe()
				ten_btn = null
			}
			if (one_btn) {
				one_btn.DeleteMe()
				one_btn = null
			}
			if (time_item) {
				time_item.DeleteMe()
				time_item = null
			}
		}
	}

	public DeleteMe() {
		this.Dispose()
		super.DeleteMe()
	}

	imgBg: Laya.Image
	_Image1: Laya.Image
	_btn_reward: Laya.Image
	_Image2: Laya.Image
	_Image4: Laya.Image
	goodsIcon: Laya.Image
	_btn_ten: Laya.Box
	_btn_one: Laya.Box
	_gp_record: Laya.Box
	_Scroller1: Laya.List
	itemGp: Laya.Box
	countLb: Laya.Label
	itemGp1: Laya.HBox
	itemGp2: Laya.HBox
	itemGp3: Laya.HBox
	public GetComponents() {
		[
			this.imgBg,
			this._Image1,
			this._btn_reward,
			this._Image2,
			this._Image4,
			this.goodsIcon,
			this._btn_ten,
			this._btn_one,
			this._gp_record,
			this._Scroller1,
			this.itemGp,
			this.countLb,
			this.itemGp1,
			this.itemGp2,
			this.itemGp3,
		]
			= this.GetChildrenByNames([
				"imgBg",
				"_Image1",
				"_btn_reward",
				"_Image2",
				"_Image4",
				"goodsIcon",
				"_btn_ten",
				"_btn_one",
				"_gp_record",
				"_Scroller1",
				"itemGp",
				"countLb",
				"itemGp1",
				"itemGp2",
				"itemGp3",
			])
	}
}
window["HolyCallMainView"] = HolyCallMainView
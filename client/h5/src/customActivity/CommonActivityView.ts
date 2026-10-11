import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { Config } from "../common/Config"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { TaskTipType } from "../commonModel/TaskModel"
import { PlatformManager } from "../PlatformManager"
import { RoleManager } from "../commonModel/RoleManager"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { ErlangParser } from "../util/ErlangParser"
import { TimeUtil } from "../util/TimeUtil"
import { HotPointModel } from "../kfHotPoint/HotPointModel"
import { CycleimpActlistModel } from "../commonModel/CycleimpActlistModel"
import { Util } from "../util/Util"
import { ClientConfig } from "../util/DeclareGlobalVar"

export class CommonActivityView extends BaseWindowComponent {

	_Local_Close
	SetIconType
	_key2index;

	public constructor() {
		super()
		this.dependent_res = ["customActivity"];

		this.money_list = [2, 1, 0]
		this.destroy_imm = true
		this.change_scene_close = false
		this.not_show_item_use = true

		let cus_model = CustomActivityModel.GetInstance(),
			local_Number = Number,
			config_preload_client = Config.PRELOAD_CLIENT_CONFIG,
			platform_mgr = PlatformManager.GetInstance(),
			local_TaskTipType = TaskTipType,
			local_CustomActivityDefine = CustomActivityDefine,
			res_mgr = ResManager.GetInstance(),
			// competelist_model = CompeteListModel.GetInstance(),
			_index2info,
			_key2index,
			_icon_type

		this.window_load_back = () => {
			//初始化红点信息
			if (_index2info) {
				for (let key in _index2info) {
					let info = _index2info[key]
					let value
					let list = []
					if (typeof (info) == 'string') {
						list = info.split("@");
					}
					if (info && info.base_type) {
						value = cus_model.GetRedDotValue(info.base_type, info.sub_type)
					} else if (list.length > 0 && local_Number(list[0]) == config_preload_client.ConfigCustomActivity.SPECIAL_ID.COMPETELIST) {
						value = cus_model.GetSpecialRedDotValue(config_preload_client.ConfigCustomActivity.SPECIAL_ID.COMPETELIST, list[1], list[2])
					} else if (info && info.type == "331_cycle") { //循环冲榜
						value = CycleimpActlistModel.GetInstance().CheckActData()
					} else {
						value = cus_model.GetSpecialRedDotValue(info[0], undefined, info[1])
					}
					this.SetTabRed(key, value && value > 0)
				}
			}


			if (cus_model.IsActIcon(_icon_type)) {
				let open_day = ServerTimeModel.GetInstance().GetOpenServerDay()
				if (open_day < 8 && !platform_mgr.is_alpha && !platform_mgr.need_alpha_open_charge) {
					if (this.task_model.IsCurrMainLineTaskTipType(local_TaskTipType.Award_lv_gift)) {
						this.destroy_imm = true
						this._story_bar2.x = 156//第二个选项卡位置
					} else if (this.task_model.IsCurrMainLineTaskTipType(local_TaskTipType.Award_eternal_valley)) {
						this.destroy_imm = true
						this._story_bar2.x = 20//第三个选项卡位置
					}
				} else {
					if (this.task_model.IsCurrMainLineTaskTipType(local_TaskTipType.Award_eternal_valley)) {
						this.destroy_imm = true
						this._story_bar2.x = 156//第二个选项卡位置
					}
				}
			}

			//监听绑定事件
			this.BindEvent(cus_model, local_CustomActivityDefine.EVENT.UPDATE_TAB_RED, (key?, state?) => {
				if (_key2index[key] != null) {
					this.SetTabRed(_key2index[key], state)
				}
			})

			this.BindEvent(cus_model, local_CustomActivityDefine.EVENT.CLOSE, () => {
				this.Close()
			})
		}

		this._Local_Close = () => {
			if (this.task_model.IsCurrMainLineTaskTipType(local_TaskTipType.Award_lv_gift) || this.task_model.IsCurrMainLineTaskTipType(local_TaskTipType.Award_eternal_valley)) {
				if (this.story_model.curr_view_story_step > 0) {
					this.story_model.curr_view_story_step = 0
				}
			}
			super.Close()
		}

		this.SetIconType = async (icon_type, new_window_list, ...param) => {
			let icon_key_cfg = Config.PRELOAD_CLIENT_CONFIG.ClientCustomActivityIconKey

			_icon_type = icon_type
			let window_list = config_preload_client.ConfigCustomActivity.windowscomponent[icon_type]

			let tab_str_list = []
			let view_class_list = []
			let arg_list = []
			let instruction_list = []
			this.titleList = []

			let index = 0
			if (!_index2info) {
				_index2info = {}
			}
			if (!_key2index) {
				_key2index = {}
				this._key2index = _key2index
			}

			let default_select_index = 0    //第一个元素作为默认选中的选项卡的活动大类
			let [act_type, show_id] = param

			if (!this.viewClassModuleDic) {
				this.viewClassModuleDic = {}
			}
			//循环冲榜
			let act_time = CycleimpActlistModel.GetInstance().GetActTime()
			if ((!act_time || act_time.type != 0) && icon_type == "331@110") {
				let info = {
					type: "331_cycle"
				}
				_index2info[view_class_list.length] = info
				_key2index["331_cycle"] = view_class_list.length
				table.insert(tab_str_list, { label: "循环冲榜" })
				table.insert(view_class_list, "CycleimpActlistView")
				table.insert(arg_list, true)
				table.insert(this.titleList, "customActivity.ui_dabipin")
			}

			for (let key in window_list) {
				let list = key.split("@")
				if (cus_model.ActivityNeedHideInAlpha(list[0])) {
					continue
				}
				let info = cus_model.GetActInfoByShowID(list[0], list[1])
				let role_lv = RoleManager.GetInstance().mainRoleInfo.level
				let info2 = window_list[key]
				let bool = true
				//封测时，修改开服活动的title
				if (cus_model.isCBPlatform() && (icon_type == "331@3" || icon_type == "331@3_1")) {
					info2.title = "uifc_001_png"
				}
				if (info2.max_day && info2.max_day > 0) {
					//bool = KaifuActivityModel.GetInstance().fullShowIconTime(info.stime, info2.max_day)
				}
				let is_Key2Item = icon_key_cfg[key] ? true : false
				if (info && role_lv >= info2.open_lv && bool && is_Key2Item) {
					/*
					if (info.base_type == 96) {
						let receive_all = FirstBloodModel.GetInstance().ReceiveAll(info.sub_type)
						if (receive_all) {
							continue
						}
					}
					*/


					let item_class = icon_key_cfg[key]
					if (item_class && item_class.module_js_class) {
						//this.viewClassModuleDic[view_class_list.length] = { module_name: item_class.module_js_name, class_name: item_class.module_js_class }
						item_class = item_class.module_js_class
					}
					//游戏移植阶段的特殊处理，未移植功能屏蔽
					if (!window[item_class]) {
						continue
					}
					if (platform_mgr.is_alpha) {
						if (Number(list[0]) == 10 || Number(list[0]) == 109) continue
					}


					//首日礼包特殊处理
					if (info.base_type == Config.PRELOAD_CLIENT_CONFIG.ConfigCustomActivity.ACT_ID.CREAT_ROLE_GIFT) {
						let gift_data = cus_model.GetActData(info.base_type, info.sub_type)
						let act_data = gift_data && gift_data.reward_list[0] || null
						if ((!act_data || act_data.status == 2)) {
							continue
						}
					}
					//渠道不开放特殊处理
					if (info.base_type == Config.PRELOAD_CLIENT_CONFIG.ConfigCustomActivity.ACT_ID.ONLINE_DRAW
						|| info.base_type == Config.PRELOAD_CLIENT_CONFIG.ConfigCustomActivity.ACT_ID.RED_PACKET_RAIN
					) {
						let conList = ErlangParser.GetInstance().Parse(info.condition)
						let plat_name = ClientConfig.plat_name
						let show = false
						for (let vo of conList) {
							show = true
							if (vo[0] == "source_list") {
								show = false
								let source_list = vo[1]
								if (Util.TableSize(source_list) > 0) {
									for (let k in source_list) {
										let name = source_list[k]
										if (String(name) == String(plat_name)) {
											show = true
											break
										}
									}
								}
								else
									show = true

								if (show) break
							}
						}
						if (!show) continue
					}


					let obj = { label: info.name }
					table.insert(tab_str_list, obj)
					_index2info[view_class_list.length] = info
					_key2index[key] = view_class_list.length
					table.insert(view_class_list, item_class)
					table.insert(arg_list, info)

					//背景，循环冲榜活动大界面计算时数量索引要加一
					if (info2.bg) {
						if (!this.bg_list) {
							this.bg_list = []
						} if (icon_type == "331@110" && CycleimpActlistModel.GetInstance().GetActTime().type != 0) {
							this.bg_list[index + 1] = info2.bg
						} else {
							this.bg_list[index] = info2.bg
						}
					}
					//头条
					if (info2.title) {
						table.insert(this.titleList, `customActivity.${info2.title}`)
					}
					if (info2.change_scene_close != undefined) {
						this.change_scene_close = info2.change_scene_close
					}
					if (info2.not_show_down) {
						// this.SetDownState(false)
					}
					//如果有指定，换成指定的select_index,循环冲榜活动大界面计算时数量索引要加一
					if (act_type && list[0] == String(act_type)) {
						if (show_id == undefined || list[1] == String(show_id)) {
							if (icon_type == "331@110" && CycleimpActlistModel.GetInstance().GetActTime().type != 0) {
								default_select_index = index + 1
							} else {
								default_select_index = index
							}
						}
					}
					//规则
					let id = cus_model.getActInstructionId(list[0], list[1])
					if (info.base_type == 67) { //许愿盛典无法通过id区分 所以需要通过条件中的probability_type区分概率显示
						let conList = ErlangParser.GetInstance().Parse(info.condition)
						for (let vo of conList) {
							if (vo[0] == "probability_type") {
								id = cus_model.getActInstructionId(67, `1${vo[1]}`)
								break
							}
						}
					}
					if (id) {
						instruction_list[index] = id
					}
					index++
				} else {	//特殊界面(红点不能用活动通用)
					let special_class = local_CustomActivityDefine.SpecialView[key]
					if (special_class && role_lv >= info2.open_lv && bool) {
						let open_state = cus_model.GetSpecialOpenState(list[0], list[1])
						if (open_state) {
							let item_class = special_class.module_js_class
							/*
							if (!window[item_class]) {
								if (!res_mgr.IsJsLoad(special_class.module_js_name)) {
									await res_mgr.LoadJs(special_class.module_js_name)
								}
							}
							*/
							//游戏移植阶段的特殊处理，未移植功能屏蔽
							if (!window[item_class]) {
								continue
							}
							_index2info[view_class_list.length] = list //用key
							_key2index[key] = view_class_list.length
							let _info
							//嗨点

							if (local_Number(list[0]) == Config.PRELOAD_CLIENT_CONFIG.ConfigCustomActivity.SPECIAL_ID.HOTPOINT) {
								_info = HotPointModel.GetInstance().GetActInfo(local_Number(list[0]), local_Number(list[1]))
							}

							let obj = { label: _info && _info.name || info2.name }
							table.insert(tab_str_list, obj)
							table.insert(view_class_list, item_class)
							table.insert(arg_list, _info || {})

							//背景
							if (info2.bg) {
								if (!this.bg_list) {
									this.bg_list = []
								}
								this.bg_list[index] = info2.bg
							}
							//头条
							if (info2.title) {
								table.insert(this.titleList, `customActivity.${info2.title}`)
							}
							if (info2.change_scene_close != undefined) {
								this.change_scene_close = info2.change_scene_close
							}
							//如果有指定，换成指定的select_index
							if (act_type && list[0] == String(act_type)) {
								default_select_index = index
							}
							let id = cus_model.getActInstructionId(list[0], list[1])
							if (id) {
								instruction_list[index] = id
							}
							index++
						}
					}
				}
			}


			//竟榜活动特别处理
			/*
			if (competelist_model.competeListOpen()) {
				let atListOpenDic = competelist_model.CompeteListOpenDic()
				for (let key in atListOpenDic) {
					let openInfo = atListOpenDic[key]
					if (!openInfo) continue
					let config = competelist_model.config_atList[`${openInfo.type}@${openInfo.subtype}`];
					if (config && config.act_type != 1 && openInfo.end_time > TimeUtil.getServerTime() && config.icon == _icon_type) {
						let _key = `${config_preload_client.ConfigCustomActivity.SPECIAL_ID.COMPETELIST}@${openInfo.type}@${openInfo.subtype}`;
						_index2info[view_class_list.length] = _key//用key
						_key2index[_key] = view_class_list.length
						let obj = { label: config.name }
						table.insert(tab_str_list, obj)
						if (!window["CompetelistView"]) {
							if (!res_mgr.IsJsLoad("dailyAct")) {
								await res_mgr.LoadJs("dailyAct")
							}
						}
						table.insert(view_class_list, window["CompetelistView"])
						table.insert(arg_list, { base_type: config.type, sub_type: config.sub_type, show_id: config.show_id })
						table.insert(this.titleList, "customActivity_json.uihd_001_png")
						if (!this.bg_list) {
							this.bg_list = []
						}
						this.bg_list[index] = "uijrcb_011.jpg"
						if (act_type && `${config_preload_client.ConfigCustomActivity.SPECIAL_ID.COMPETELIST}@${config.type}@${config.sub_type}` == act_type) {
							default_select_index = index
						}
						let id = cus_model.getActInstructionId(config.type, config.show_id)
						if (id) {
							instruction_list[index] = id
						}
						index++;
					}

				}

			}
			*/
			//循环冲榜 昨日榜单
			if (CycleimpActlistModel.GetInstance().GetActTime()?.type != 0 && icon_type == "331@110") {
				let list = CycleimpActlistModel.GetInstance().GetYesterdayInfo()
				if (list && Util.TableSize(list) > 0) {
					table.insert(tab_str_list, { label: "昨日榜单" })
					table.insert(view_class_list, "CycleimpActlistView")
					table.insert(arg_list, false)
					table.insert(this.titleList, "customActivity.ui_dabipin")
				}

			}


			this.tabStrList = tab_str_list
			this.viewClassList = view_class_list
			this.arg_list = arg_list
			this.instruction_list = instruction_list
			if (default_select_index != undefined) {
				this.SetDefaultIndex(default_select_index)
			}
		}


	}

	public Close() {
		this._Local_Close()
	}

}
window["CommonActivityView"] = CommonActivityView
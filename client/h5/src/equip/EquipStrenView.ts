import { BaseItem1 } from "../common/BaseItem1"
import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { Config } from "../common/Config"
import { EquipmentItem } from "../common/EquipmentItem"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { ModuleType } from "../common/RedDotManager"
import { ResManager } from "../common/ResManager"
import { WordManager } from "../common/WordManager"
import { EquipModel, EquipDefine, EquipEvent } from "../commonModel/EquipModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { TaskTipType, TaskModel } from "../commonModel/TaskModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { Util, SetAnchoredPosition, GlobalTimerQuest } from "../util/Util"
import { Vector2 } from "../util/Vector2"
import { MaterialsTool } from "../common/MaterialsTool"
import { FightingShowSmallItem } from "../common/FightingShowSmallItem"
import { SYTweenLite } from "../util/SYTweenLite"
import { EquipStrenItem } from "./EquipStrenItem"
import { EquipAttrItem } from "./EquipAttrItem"

export class EquipStrenView extends BaseItem1 {
	// AddEffect
	CheckAllMax
	CheckMax
	// ClearTimer
	InitCostData
	InitEvent
	InitView
	LoadSuccess
	SetGoldStr
	SetGradeData
	SetSelectDefault
	SetTrueDynmaic
	// StartTimer
	UpdateAttrItems
	UpdateCostData
	UpdateCurEquipInfo
	// UpdateEffecetAll
	// UpdateEffecetOne
	UpdateEquipItems
	UpdateGoodsData
	UpdatePower
	UpdateShowData
	UpdateShowItem
	// UpdateTimer
	UpdateView
	ReSelectAutoEquip
	AddStrenEffect
	GetEffectBox
	UpdateOneEquipItem
	InitEffectBox

	fight_item
	attr_item_list_
	cache_pos
	equip_icon_list_
	fly_item
	fly_tween_id
	labelDisplay
	show_item_
	story_obj_list
	effect_box_list = []
	effect_obj

	ReTaskGuilde
	is_do_task
	static SPE_TASK_ID =101435 //加强引导的id
	IsStrengeGuiderTask

	public constructor(parent?) {
		super(parent)
		let local_Message = Message
		let local_EventName = EventName
		let local_GlobalEventSystem = GlobalEventSystem
		let local_EquipDefine = EquipDefine
		let local_EquipEvent = EquipEvent
		let local_GoodsModel = GoodsModel

		let model = EquipModel.GetInstance()
		let res_mgr = ResManager.GetInstance()
		let material_tool = MaterialsTool.GetInstance()
		let role_mgr = RoleManager.GetInstance()
		let goods_model = GoodsModel.GetInstance()
		let erlang_parser = ErlangParser.GetInstance()

		this.layer_value = Enum_UILayer.UI
		this.base_file = "equip"
		this.layout_file = "EquipStrenView"
		this.preload_server_config = {
			"config_equip_whole_reward": false,
			"config_equip_stren_lv": false,
			"config_equip_stren_lv_key": false
		}

		let equip_pos_list_ = local_EquipDefine.EQUIP_POS
		let master_cfg_ = null
		let limit_cfg_ = null
		let attr_cfg_ = null
		let cur_equip_info_ = null
		let enough_goods_ = false
		let is_max_ = false
		let cost_type_id_ = null
		let cost_num_ = null
		let cur_grade_ = -1
		// let _timer_ = null
		// let _delta_send_ = 200
		// let auto_stren_info = null
		// let auto_is_max = false
		// let auto_ing = false
		let anim_count = 0
		let anim_all = 0
		let ainming = false

		this.load_callback = () => {
			// if (PlatformMgr.GetInstance().IsEyouKrPlatform() ) {
			// 	SetAnchoredPositionX(this._Label4,238)
			// 	SetAnchoredPositionX(this._Label5,366)
			// }
			this.LoadSuccess()
			// 		if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
			// 			let csf = this.labelDisplay.GetComponent("ContentSizeFitter")
			// 			csf.horizontalFit = UnityEngine.UI.ContentSizeFitter.FitMode.Unconstrained
			// 			csf.verticalFit = UnityEngine.UI.ContentSizeFitter.FitMode.Unconstrained
			// 			SetSizeDelta(this.labelDisplay,170,65)
			// 			this.labelDisplay.verticalAlign = "middle"
			// this.labelDisplay.textAlign = "center"
			// 			this.labelDisplay.lineSpacing = 0.8
			// 			this._Label3.size  = 20
			// 			this._Label4.size  = 20
			// 			this._Label5.size  = 20
			// 			SetAnchoredPositionX(this._Image1,16)
			// 			SetAnchoredPositionX(this._Label3,42)
			// 			SetAnchoredPositionX(this._Label4,119)
			// 			SetAnchoredPositionX(this._Label5,352)
			// 		}
		}

		this.LoadSuccess = () => {
			attr_cfg_ = Config.PRELOAD_SERVER_CONFIG.config_equip_attr
			limit_cfg_ = Config.PRELOAD_SERVER_CONFIG.config_equip_strengthen_max
			master_cfg_ = ResManager.GetInstance().GetGameConfigFromCache(this, "config_equip_whole_reward", false)

			this.fight_item = new FightingShowSmallItem(this._fight_power)
			this.fight_item.Load()

			if (!this.use_delete_method) {
				this.AddUIEffect("QiangHua", this.gp_effect, null, 8, null, null, null, (obj) => {
					this.effect_obj = obj
					this.effect_obj.active = false
				}, null, null, null, null, false)

				this.InitEffectBox()
				this.InitEvent()
				this.InitView()
			}

			this.ReTaskGuilde()
		}

		this.InitEvent = () => {
			let update_task = (task_id?, task_tips_list?) => {
				if (task_id && this.task_model.IsCurrMainLineTaskTipType(TaskTipType.StrenEquip)
					&& this.task_model.IsAllStepFinish(task_id)) {
					this.story_model.curr_view_story_step = 2
					//GlobalEventSystem.Fire(EventName.SHOW_FINGER, this, local_BaseWindowComponent.CURR_BASE_WINDOW_COMPONENT._img_return, "UI", null, null, null, null)
				}

				this.ReTaskGuilde()
			}
			this.BindEvent(this.task_model, TaskModel.UPDATE_ONE_TASK, update_task)

			Util.AddClickEvent(this.btnStrOne, () => {
				if (!cur_equip_info_) {
					local_Message.show("需要穿戴装备才可以强化")
					return
				}
				if (is_max_) {
					local_Message.show("达到强化上限")
					return
				}
				if (!enough_goods_) {
					material_tool.materialsTips(local_EquipDefine.STREN_GOODS_TYPE_ID)
					return
				}
				model.Fire(local_EquipEvent.REQUEST_PROTO, 15205, "cc", cur_equip_info_.equip_type, 1)
			}, this, true)

			Util.AddClickEvent(this.btnStrAll, () => {
				// if (ainming) {
				// 	return
				// }
				if (!cur_equip_info_) {
					local_Message.show("需要穿戴装备才可以强化")
					this.ReTaskGuilde()
					return
				}
				if (this.CheckAllMax()) {
					local_Message.show("达到强化上限")
					return
				}
				if (!enough_goods_) {
					material_tool.materialsTips(local_EquipDefine.STREN_GOODS_TYPE_ID)
					return
				}
				model.Fire(local_EquipEvent.REQUEST_PROTO, 15205, "cc", 0, 2)

				// auto_stren_info = cur_equip_info_
				// auto_is_max = is_max_
				// this.StartTimer()
			}, this, true)

			Util.AddClickEvent(this.btnStopAll, () => {
				// this.ClearTimer()
				// this.AddUIEffect("UI_1102_qianghuachenggong", "UI", this._group_eff_3, null, 1)
			}, this, true)

			Util.AddClickEvent(this.btnMaster, () => {
				model.Fire(local_EquipEvent.OPEN_VIEW, "EquipStrenMasterView")
			}, this, true)

			this.BindEvent(model, local_EquipEvent.UPDATE_ALL_STREN, (scmd?) => {
				if (this.use_delete_method) {
					return
				}
				if (scmd && scmd.stren_info) {
					anim_all = scmd.stren_info.length
					anim_count = 0
					ainming = true
					let dealy_time = 0.06
					for (let i in scmd.stren_info) {
						let type = scmd.stren_info[i].equip_type
						let time = dealy_time * Number(i)
						if (time > 0) {
							GlobalTimerQuest.AddDelayQuest(() => {
								this.AddStrenEffect(type)
							}, time)
						} else {
							this.AddStrenEffect(type)
						}
					}
				}

			})

			this.BindEvent(model, local_EquipEvent.UPDATE_ONE_STREN, (list?) => {
				this.UpdateView()
				if (this.effect_obj) {
					this.effect_obj.active = false
					this.effect_obj.active = true
				}
				// this.UpdateEffecetOne(list[0].equip_type)
				// this.AddStrenEffect(list[0].equip_type)
				// this.AddEffect()
			})

			this.BindEvent(model, local_EquipEvent.UPDATE_MASTER_RED, () => {
				this.red_master.visible = model.CheckMasterRed(1)
				this.SetGradeData()
			})

			this.BindEvent(model, local_EquipEvent.SELECT_STREN_EQUIP, (info?) => {
				cur_equip_info_ = info
				if (cur_equip_info_) {
					let equip_type = cur_equip_info_.equip_type
					if (this.cache_pos != equip_type) {
						let move_func = () => {
							let x = (equip_type % 2) == 1 && 18 || 548
							let y = Math.ceil(equip_type / 2) * 147
							SetAnchoredPosition(this.fly_item.display_obj, x, y)
							if (this.fly_tween_id) {
								SYTweenLite.Stop(this.fly_tween_id)
							}
							this.fly_item.SetVisible(true)
							this.fly_item.SetData(info.type_id)
							this.fly_tween_id = SYTweenLite.to(this, this.fly_item.display_obj, SYTweenLite.UiAnimationType.ANCHORED_POS, new Vector2(303, 294), 0.35, () => {
								this.UpdateShowData(info)
								this.fly_item.SetVisible(false)
								this.fly_tween_id = null
							})
							this.cache_pos = equip_type
						}

						if (!this.fly_item) {
							this.fly_item = new EquipmentItem(this.display_obj, null, this.layer_value, null, true)
							this.fly_item.Load()
							this.fly_item.ExcuteCallback(() => {
								this.fly_item.SetVisible(false)
								this.fly_item.SetScale(0.8, 0.8)
								move_func()
							})
						} else {
							move_func()
						}

					}
				}
				// this.ClearTimer()
			})

			let role_vo = role_mgr.GetMainRoleVo()
			this.BindVar(role_vo, "tong", (type?, val?, oval?, p?) => {
				this.UpdateCostData()
			})

			this.BindEvent(goods_model, local_GoodsModel.CHANGE_EQUIPLIST, () => {
				this.UpdateCurEquipInfo()
				this.UpdateView()
				this.SetSelectDefault()
			})

			this.BindEvent(local_GlobalEventSystem, local_EventName.UPDATE_REDDOT, (rType?, key?) => {
				if (rType != ModuleType.EQUIP_STREN) {
					return
				}
				let equip_attr_cfg = res_mgr.GetGameConfigFromCache(this, "config_equip_attr", false)
				let stren_key_cfg = null //res_mgr:GetGameConfigFromCache(this, "config_equip_stren_lv_key", false)
				let stren_cfg = res_mgr.GetGameConfigFromCache(this, "config_equip_stren_lv", false)
				let stren_max_cfg = res_mgr.GetGameConfigFromCache(this, "config_equip_strengthen_max", false)
				this._reddot.visible = model.CheckStrenRedDotOne(cur_equip_info_, equip_attr_cfg, stren_key_cfg, stren_cfg, stren_max_cfg)
			})
		}


		//101435 任务加强引导
		this.ReTaskGuilde =()=>{
			let MainLineTaskVo = TaskModel.GetInstance().GetMainLineTaskVo()
			if (this.task_model.IsCurrMainLineTaskTipType(TaskTipType.StrenSum) && MainLineTaskVo &&this.task_model.IsStrengeGuiderTask()) {
		
			if(!this.task_model.IsCurrMainTaskHasFinish()){
				this.is_do_task = true
				this.story_model.curr_view_story_step = 0
				GlobalEventSystem.Fire(EventName.SHOW_FINGER, this, this.btnStrAll, "UI", null, null, null, null)
				return
			}

			if(this.task_model.IsCurrMainTaskHasFinish()&&this.is_do_task){
				GlobalEventSystem.Fire(EventName.HIDE_FINGER,this.btnStrAll)
				this.story_model.curr_view_story_step = 1
				GlobalEventSystem.Fire(EventName.SHOW_FINGER, this, BaseWindowComponent.CURR_BASE_WINDOW_COMPONENT._img_return, "UI", null, null, null, null)
			}
		}
		}

		this.InitView = () => {
			res_mgr.SetOutsideImageSprite(this, this.icon1, "resource/game/equip/other/uidz_004d.png")

			if (!this.equip_icon_list_) {
				this.equip_icon_list_ = []
			}
			for (let i = 0; i < equip_pos_list_.length; i++) {
				let pos = equip_pos_list_[i]
				let con = (i % 2 == 0 && (this.left_groupEquip) || (this.right_groupEquip))
				let item = new EquipStrenItem(con)
				item.SetEquipPos(pos)
				item.Load()
				this.equip_icon_list_[i] = item
			}

			cost_type_id_ = local_EquipDefine.STREN_GOODS_TYPE_ID
			this.InitCostData()

			this.UpdateView()
			this.SetSelectDefault()
		}

		this.UpdateEquipItems = () => {
			let equipInfos = model.GetWearEquipDynamics()
			for (let key in equipInfos) {
				let info = equipInfos[key]
				let item = this.equip_icon_list_[info.equip_type - 1]
				if (item) {
					let attr_cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_equip_attr.name, info.type_id, false, attr_cfg_)
					let limit_cfg = limit_cfg_[attr_cfg.stage + "@" + info.color + "@" + info.equip_type]
					item.SetCfgs(limit_cfg, attr_cfg)
					item.SetData(info)
				}
			}
		}

		this.UpdateOneEquipItem = (equip_type) => {
			let equipInfos = model.GetWearEquipDynamics()
			for (let key in equipInfos) {
				let info = equipInfos[key]
				if (info.equip_type == equip_type) {
					let item = this.equip_icon_list_[info.equip_type - 1]
					if (item) {
						let attr_cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_equip_attr.name, info.type_id, false, attr_cfg_)
						let limit_cfg = limit_cfg_[attr_cfg.stage + "@" + info.color + "@" + info.equip_type]
						item.SetCfgs(limit_cfg, attr_cfg)
						item.SetData(info)
					}
					break
				}
			}
		}

		this.UpdateView = () => {
			this.UpdateEquipItems()
			this.SetGradeData()
			this.UpdatePower()
			this.UpdateShowData(cur_equip_info_)
			this.group_cost.visible = !Util.IsTableEmpty(model.GetWearEquipInfos())
			this.red_master.visible = model.CheckMasterRed(1)
		}

		this.SetSelectDefault = () => {
			let list = model.GetWearEquipDynamics()
			if (list.length < 1) {
				return
			}
			let info = list[0]
			let stren = 99999
			for (let _tmpi in list) {
				let v = list[_tmpi]
				if (v.stren < stren && !this.CheckMax(v)) {
					info = v
					stren = info.stren
				}
			}
			let item = this.equip_icon_list_[info.equip_type - 1]
			item.ExcuteCallback(() => {
				model.Fire(local_EquipEvent.SELECT_STREN_EQUIP, info)
			}
			)
		}

		this.UpdateShowData = (info?) => {
			if (!info) {
				return
			}
			let equip_type = info.equip_type
			let stren_key_cfg = null//res_mgr:GetGameConfigFromCache(this, "config_equip_stren_lv_key", false)
			let attr_cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_equip_attr.name, info.type_id, false, attr_cfg_)
			let limit_cfg = limit_cfg_[attr_cfg.stage + "@" + info.color + "@" + equip_type]
			let stren = ((limit_cfg && limit_cfg.stren_max <= info.stren) && (limit_cfg.stren_max) || (info.stren))
			let stren_cfg = res_mgr.GetGameConfigFromCache(this, "config_equip_stren_lv", false)
			let curCfg = model.GetStrenData(equip_type, stren, stren_key_cfg, stren_cfg)
			let nextCfg = model.GetStrenData(equip_type, stren + 1, stren_key_cfg, stren_cfg)
			if (!curCfg) {
				return
			}
			is_max_ = this.CheckMax(cur_equip_info_)
			let cur_list = erlang_parser.parse(curCfg.attr_list)
			let next_list = nextCfg && erlang_parser.parse(nextCfg.attr_list) || {}
			for (let _tmpi in cur_list) {
				let attr = cur_list[_tmpi]
				attr[1] = Number(attr[1]) * stren
			}
			for (let _tmpi in next_list) {
				let attr = next_list[_tmpi]
				attr[1] = Number(attr[1]) * (stren + 1)
			}
			this.UpdateAttrItems(cur_list, next_list)
			this.UpdateShowItem()
			let goods_str = (curCfg && (erlang_parser.parse(curCfg.object_list)[0]) || (null))
			this.UpdateGoodsData(goods_str)
			this.group_max_tip.visible = is_max_
			let equip_attr_cfg = res_mgr.GetGameConfigFromCache(this, "config_equip_attr", false)
			let stren_max_cfg = res_mgr.GetGameConfigFromCache(this, "config_equip_strengthen_max", false)
			this._reddot.visible = model.CheckStrenRedDotOne(cur_equip_info_, equip_attr_cfg, stren_key_cfg, stren_cfg, stren_max_cfg)
		}

		this.UpdateGoodsData = (goods_str?) => {
			if (!goods_str || is_max_) {
				this.have_num.text = "已满级"
				this.need_num.text = ""
				return
			}
			cost_num_ = Number(goods_str[2])
			this.UpdateCostData()
		}

		this.UpdateCostData = () => {
			if (!cost_num_) {
				return
			}
			if (is_max_) {
				return
			}
			let own = role_mgr.GetMainRoleVo().tong
			enough_goods_ = own >= Number(cost_num_)
			let color = (enough_goods_ && "#0a953e" || "#ff4f50")
			let own_str = this.SetGoldStr(own)
			this.have_num.color = color
			this.have_num.text = own_str
			this.need_num.text = "/" + this.SetGoldStr(cost_num_)
		}

		this.InitCostData = () => {
			let icon_id = local_GoodsModel.GetGoodsIcon(cost_type_id_)
			res_mgr.SetOutsideImageSprite(this, this.goods_icon, GameResPath.GetGoodsIconPath(icon_id))
		}

		this.UpdateShowItem = () => {
			if (!cur_equip_info_) {
				return
			}
			let info = cur_equip_info_
			if (!this.show_item_) {
				this.show_item_ = new EquipStrenItem(this.gp_show)
				this.show_item_.Load()
				//SetAnchoredPosition(this.show_item_.display_obj, 305, 295)
			}
			let attr_cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_equip_attr.name, info.type_id, false, attr_cfg_)
			let limit_cfg = limit_cfg_[attr_cfg.stage + "@" + info.color + "@" + info.equip_type]
			this.show_item_.SetCfgs(limit_cfg, attr_cfg)
			this.show_item_.SetData(info)
		}

		this.UpdateAttrItems = (clist?, nlist?) => {
			if (!this.attr_item_list_) {
				this.attr_item_list_ = []
			}
			let item = null
			for (let i = 0; i < clist.length; i++) {
				item = this.attr_item_list_[i]
				if (!item) {
					item = new EquipAttrItem(this.listAttr)
					item.Load()
					this.attr_item_list_[i] = item
				}
				item.SetData(1, clist[i], nlist[i], 1)
				item.SetVisible(true)
			}
			for (let i = clist.length; i < this.attr_item_list_.length; i++) {
				this.attr_item_list_[i].SetVisible(false)
			}
		}

		this.UpdatePower = () => {
			let stren_key_cfg = res_mgr.GetGameConfigFromCache(this, "config_equip_stren_lv_key", false)
			let stren_cfg = res_mgr.GetGameConfigFromCache(this, "config_equip_stren_lv", false)
			let stren_max_cfg = res_mgr.GetGameConfigFromCache(this, "config_equip_strengthen_max", false)
			let power = model.GetWearEquipsStrenPower(stren_key_cfg, stren_cfg, stren_max_cfg)
			power = power + model.GetStrenMasterPower()
			this.fight_item.Updatefighting(power)
			this.fight_item.horizontalCenter = 0
		}

		this.CheckMax = (info?) => {
			let attr_cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_equip_attr.name, info.type_id, false, attr_cfg_)
			let limit_cfg = limit_cfg_[attr_cfg.stage + "@" + info.color + "@" + info.equip_type]
			if (!limit_cfg) {
				return false
			}
			let wear_info = goods_model.GetDynamic(info.goods_id, null, false, true)
			return limit_cfg.stren_max <= wear_info.stren
		}

		this.CheckAllMax = () => {
			let list = model.GetWearEquipDynamics()
			for (let _tmpi in list) {
				let info = list[_tmpi]
				let is_max = this.CheckMax(info)
				if (!is_max) {
					return false
				}
			}
			return true
		}

		this.SetGradeData = () => {
			let lv = model.GetMasterLv(1)
			let [_, _j, grade] = model.GetWholeAwardCfg(local_EquipDefine.STREN_WHOLE_TYPE, lv)
			/*
			if (cur_grade_ >= 0 && grade > cur_grade_) {
				this:AddUIEffect("UI_1102_qianghuachenggong", "UI" , this._group_eff)
			}
			*/
			cur_grade_ = grade
			this.grade.text = grade + "阶"
		}

		// this.UpdateEffecetAll = (list?) => {
		// 	for (let _tmpi in list) {
		// 		let info = list[_tmpi]
		// 		this.UpdateEffecetOne(info.equip_type)
		// 	}
		// }

		// this.UpdateEffecetOne = (equip_type?) => {
		// 	let item = this.equip_icon_list_[equip_type]
		// 	if (!item) {
		// 		return
		// 	}
		// 	item.UpdateEffect()
		// }

		this.SetTrueDynmaic = (equip_type?) => {
			if (cur_equip_info_ && cur_equip_info_.equip_type == equip_type) {
				let wear_info = model.GetWearEquipInfo(equip_type)
				if (!wear_info) {
					return
				}
				let dynamic = goods_model.GetDynamic(wear_info.goods_id, null, false, true)
				cur_equip_info_ = dynamic
			}
		}

		this.UpdateCurEquipInfo = () => {
			if (!cur_equip_info_) {
				return
			}
			let equipInfos = model.GetWearEquipDynamics()
			for (let key in equipInfos) {
				let info = equipInfos[key]
				if (info.equip_type == cur_equip_info_.equip_type) {
					this.SetTrueDynmaic(info.equip_type)
				}
			}
		}

		// this.AddEffect = () => {
		// 	// this.AddUIEffect("UI_1502", "UI", this._group_eff_2, null, 1)
		// 	if (!_timer_) {
		// 		// this.AddUIEffect("UI_1102_qianghuachenggong", "UI", this._group_eff_3, null, 1)
		// 	} else {
		// 	}
		// }

		// this.StartTimer = () => {
		// 	this.ClearTimer()
		// 	// _timer_ = GlobalTimerQuest.AddPeriodQuest(this.UpdateTimer, 0.8, -1)

		// 	if (this.btnStrAll) {
		// 		this.btnStrAll.visible = false
		// 	}
		// 	if (this.btnStopAll) {
		// 		this.btnStopAll.visible = true
		// 	}
		// 	auto_ing = true
		// 	this.UpdateTimer()
		// }

		// this.ClearTimer = () => {
		// 	auto_ing = false
		// 	// if (_timer_) {
		// 	// 	GlobalTimerQuest.CancelQuest(_timer_)
		// 	// 	_timer_ = null
		// 	// }
		// 	if (this.btnStrAll) {
		// 		this.btnStrAll.visible = true
		// 	}
		// 	if (this.btnStopAll) {
		// 		this.btnStopAll.visible = false
		// 	}
		// }

		// this.UpdateTimer = () => {
		// 	this.ReSelectAutoEquip()
		// 	if ((auto_stren_info && enough_goods_) && !auto_is_max) {
		// 		model.Fire(local_EquipEvent.REQUEST_PROTO, 15205, "cc", auto_stren_info.equip_type, 1)
		// 	} else {
		// 		this.ClearTimer()

		// 		// if (auto_is_max) {
		// 		// 	let all_max = this.CheckAllMax()
		// 		// 	if (all_max) {
		// 		// 		if (auto_is_max) {
		// 		// 			this.SetSelectDefault()
		// 		// 		}
		// 		// 		this.ClearTimer()
		// 		// 	} else {
		// 		// 		this.ReSelectAutoEquip()
		// 		// 	}
		// 		// } else {
		// 		// 	if (auto_is_max) {
		// 		// 		this.SetSelectDefault()
		// 		// 	}
		// 		// 	this.ClearTimer()
		// 		// }
		// 	}
		// }

		// this.ReSelectAutoEquip = () => {
		// 	let list = model.GetWearEquipDynamics()
		// 	if (list.length < 1) {
		// 		return
		// 	}
		// 	let info = cur_equip_info_
		// 	let stren = 99999
		// 	for (let _tmpi in list) {
		// 		let v = list[_tmpi]
		// 		if (v.stren < stren && !this.CheckMax(v)) {
		// 			info = v
		// 			stren = info.stren
		// 		}
		// 	}
		// 	auto_stren_info = info
		// 	auto_is_max = this.CheckMax(auto_stren_info)
		// }

		this.SetGoldStr = (value?) => {
			if (value >= 100000) {
				//return (value / 10000):toFixed(1) + "万"
				return WordManager.FormatNumber2(value, true, true)
			} else {
				return String(value)
			}
		}

		this.AddStrenEffect = (equip_type) => {
			if (this.use_delete_method) {
				return
			}
			let start_pos = { x: 500, y: 907 }
			let space = 152
			let anim_time = 0.45
			let anim_time2 = 0.1

			let right = (equip_type % 2 == 0)
			let scale_x = right ? -1 : 1
			let end_x = right ? 635 : 67
			let index = Math.ceil(equip_type / 2)
			let end_y = 152 + (index - 1) * space
			// 旋转角度计算
			let tan = Math.abs(907 - end_y) / Math.abs(end_x - 500)
			let rotate = 90 - Math.atan(tan) * 180 / Math.PI
			let end_rota = right ? rotate : -rotate

			let new_obj = false
			let effect_box = this.GetEffectBox()
			if (!effect_box) {
				new_obj = true
				effect_box = new Laya.Box()
				effect_box.width = this.display_obj.width
				effect_box.height = this.display_obj.height
				effect_box.anchorX = 0.5
				effect_box.anchorY = 0.5
				this.display_obj.addChild(effect_box)
				this.effect_box_list.push(effect_box)
			}
			effect_box.x = start_pos.x
			effect_box.y = start_pos.y
			effect_box.alpha = 0
			effect_box.rotation = end_rota
			effect_box.scaleX = scale_x
			effect_box.scaleY = 0
			effect_box.visible = true

			let play_anim = () => {
				// SYTweenLite.to(this, effect_box, SYTweenLite.UiAnimationType.ROTATION, end_rota, anim_time2)
				SYTweenLite.to(this, effect_box, SYTweenLite.UiAnimationType.ALPHA, 1, anim_time2)
				SYTweenLite.to(this, effect_box, SYTweenLite.UiAnimationType.SCALE, { x: scale_x, y: 1 }, anim_time2)
				SYTweenLite.to(this, effect_box, SYTweenLite.UiAnimationType.POS, { x: end_x, y: end_y }, anim_time, () => {
					effect_box.visible = false
					model.Fire(EquipEvent.PLAY_END_EFFECT, equip_type)
					this.UpdateOneEquipItem(equip_type)
					anim_count = anim_count + 1
					if (anim_count >= anim_all) {
						anim_count = 0
						ainming = false
						this.UpdateView()
						// this.SetSelectDefault()
					}
				})
			}
			if (new_obj) {
				this.AddUIEffect("TuoW", effect_box, null, { x: 1, y: -1, z: 1 }, true, null, null, () => {
					play_anim()
				}, null, null, null, null, false)
			} else {
				play_anim()
			}
		}

		this.GetEffectBox = () => {
			for (let i in this.effect_box_list) {
				let item = this.effect_box_list[i]
				if (item && !item.visible) {
					return item
				}
			}
		}

		this.InitEffectBox = () => {
			let count = 10
			for (let i = 0; i < count; i++) {
				let effect_box = new Laya.Box()
				effect_box.width = this.display_obj.width
				effect_box.height = this.display_obj.height
				effect_box.anchorX = 0.5
				effect_box.anchorY = 0.5
				this.display_obj.addChild(effect_box)
				this.effect_box_list.push(effect_box)
				effect_box.visible = false
				this.AddUIEffect("TuoW", effect_box, null, { x: 1, y: -1, z: 1 }, true, null, null, null, null, null, null, null, false)
			}
		}
	}

	public DeleteMe() {
		if (this.effect_obj) {
			this.effect_obj.destroy()
		}

		for (let i in this.effect_box_list) {
			let item = this.effect_box_list[i]
			item.destroy()
		}
		this.effect_box_list = []

		if (this.equip_icon_list_) {
			for (let key in this.equip_icon_list_) {
				this.equip_icon_list_[key].DeleteMe()
			}
			this.equip_icon_list_ = null
		}

		if (this.attr_item_list_) {
			for (let key in this.attr_item_list_) {
				this.attr_item_list_[key].DeleteMe()
			}
			this.attr_item_list_ = null
		}

		if (this.show_item_) {
			this.show_item_.DeleteMe()
		}
		//if (this.left_groupEquip ) {
		//this.left_groupEquip.removeChildren()
		//}
		//if (this.right_groupEquip ) {
		//this.right_groupEquip.removeChildren()
		//}
		if (this.fight_item) {
			this.fight_item.DeleteMe()
			this.fight_item = null
		}

		if (this.fly_item) {
			this.fly_item.DeleteMe()
			this.fly_item = null
		}
		if (this.fly_tween_id) {
			SYTweenLite.Stop(this.fly_tween_id)
			this.fly_tween_id = null
		}
		// this.ClearTimer()
		super.DeleteMe()
	}

	public SetVisible(value?) {
		if (!value) {
			// this.ClearTimer()
		}
		super.SetVisible(value)
	}

	public createChildren() {
		if (this["GetComponents"]) {
			this["GetComponents"]()
			this.is_get = true
		}
		this.story_obj_list = []
		this.story_obj_list[TaskTipType.StrenEquip] = [this.btnStrAll]
		//this.story_obj_list[TaskTipType.StrenEquip] = [this.btnStrAll, local_BaseWindowComponent.CURR_BASE_WINDOW_COMPONENT._img_return]

		let MainLineTaskVo = TaskModel.GetInstance().GetMainLineTaskVo()
		if (MainLineTaskVo && this.task_model.IsCurrMainLineTaskTipType(TaskTipType.StrenSum) && MainLineTaskVo &&!this.task_model.IsStrengeGuiderTask()) {
			this.story_obj_list[TaskTipType.StrenSum] = [this.btnStrAll,BaseWindowComponent.CURR_BASE_WINDOW_COMPONENT._img_return]
		}
	
		this.story_obj_list[TaskTipType.RefineEquip] = [{ obj: BaseWindowComponent.CURR_BASE_WINDOW_COMPONENT._story_bar2, x_off: 0, y_off: 0 }]

		super.createChildren()
	}

	public ReOpen_callback() {
		// this.AddUIEffect("UI_1501", "UI", this._group_eff_1, null, 0.91, true, null)
	}

	icon1: Laya.Image
	_fight_power: Laya.Box
	gp_show: Laya.Box
	left_groupEquip: Laya.VBox
	right_groupEquip: Laya.VBox
	groupAttr: Laya.Box
	_img_attr: Laya.Image
	_img_attr0: Laya.Image
	_Label1: Laya.Label
	listAttr: Laya.VBox
	groupGoods: Laya.Box
	_img_cost: Laya.Image
	_img_cost0: Laya.Image
	_Label2: Laya.Label
	group_cost: Laya.HBox
	goods_icon: Laya.Image
	have_num: Laya.Label
	need_num: Laya.Label
	btnMaster: Laya.Image
	red_master: Laya.Image
	grade: Laya.Label
	btnStrOne: Laya.Image
	_lb_strOne: Laya.Label
	btnStrAll: Laya.Image
	_lb_strAll: Laya.Label
	btnStopAll: Laya.Image
	lb_stopAll: Laya.Label
	_reddot: Laya.Image
	group_max_tip: Laya.HBox
	_Image1111: Laya.Image
	_Label3: Laya.Label
	_Label4: Laya.Label
	_Label5: Laya.Label
	gp_effect: Laya.Box
	public GetComponents() {
		[
			this.icon1,
			this._fight_power,
			this.gp_show,
			this.left_groupEquip,
			this.right_groupEquip,
			this.groupAttr,
			this._img_attr,
			this._img_attr0,
			this._Label1,
			this.listAttr,
			this.groupGoods,
			this._img_cost,
			this._img_cost0,
			this._Label2,
			this.group_cost,
			this.goods_icon,
			this.have_num,
			this.need_num,
			this.btnMaster,
			this.red_master,
			this.grade,
			this.btnStrOne,
			this._lb_strOne,
			this.btnStrAll,
			this._lb_strAll,
			this.btnStopAll,
			this.lb_stopAll,
			this._reddot,
			this.group_max_tip,
			this._Image1111,
			this._Label3,
			this._Label4,
			this._Label5,
			this.gp_effect,
		]
			= this.GetChildrenByNames([

				"icon1",
				"_fight_power",
				"gp_show",
				"left_groupEquip",
				"right_groupEquip",
				"groupAttr",
				"_img_attr",
				"_img_attr0",
				"_Label1",
				"listAttr",
				"groupGoods",
				"_img_cost",
				"_img_cost0",
				"_Label2",
				"group_cost",
				"goods_icon",
				"have_num",
				"need_num",
				"btnMaster",
				"red_master",
				"grade",
				"btnStrOne",
				"_lb_strOne",
				"btnStrAll",
				"_lb_strAll",
				"btnStopAll",
				"lb_stopAll",
				"_reddot",
				"group_max_tip",
				"_Image1111",
				"_Label3",
				"_Label4",
				"_Label5",
				"gp_effect",
			])
	}
}
window["EquipStrenView"] = EquipStrenView
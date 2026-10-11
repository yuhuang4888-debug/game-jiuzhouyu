import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItem1 } from "../common/BaseItem1"
import { Config } from "../common/Config"
import { EquipmentItem } from "../common/EquipmentItem"
import { EventName } from "../common/EventName"
import { FightingShowSmallItem } from "../common/FightingShowSmallItem"
import { MaterialsTool } from "../common/MaterialsTool"
import { RedDotManager, ModuleType } from "../common/RedDotManager"
import { ResManager } from "../common/ResManager"
import { EquipModel, EquipDefine, EquipEvent } from "../commonModel/EquipModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { Message } from "../sysInfo/SysInfoController"
import { Enum_ColorUtil_Dark } from "../util/ColorUtil"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { SYTweenLite } from "../util/SYTweenLite"
import { Util, SetAnchoredPosition, HtmlColorTxt } from "../util/Util"
import { Vector2 } from "../util/Vector2"
import { EquipAttrItem } from "./EquipAttrItem"
import { EquipSmeltItem } from "./EquipSmeltItem"
import { GlobalTimerQuest } from "../util/Util"

export class EquipSmeltView extends BaseItem1 {
	AddEffect
	CheckAllMax
	CheckIsRed
	CheckItemRed
	CheckMax
	InitCostData
	InitEvent
	InitView
	LoadSuccess
	//SetGradeData
	SetSelectDefault
	SetTrueDynmaic
	UpdateAttrItems
	UpdateCostData
	UpdateCurEquipInfo
	UpdateEffecetAll
	UpdateEffecetOne
	UpdateEquipItems
	UpdateGoodsData
	UpdatePower
	UpdateShowData
	UpdateShowItem
	UpdateView
	AddStrenEffect
	GetEffectBox
	UpdateOneEquipItem
	InitEffectBox

	fight_item
	attr_item_list_
	bg
	cache_pos
	// createChildren
	equip_icon_list_
	fly_item
	fly_tween_id
	gourpEquip
	icon2
	item
	item_top
	show_item_
	story_obj_list
	strong_item
	need_gp_top: any
	effect_box_list = []
	effect_obj

	public constructor(parent?) {
		super(parent)
		this.base_file = "equip"
		this.layout_file = "EquipSmeltView"

		let local_Message = Message
		let local_GoodsModel = GoodsModel
		let goods_model = GoodsModel.GetInstance()
		let red_dot_mgr = RedDotManager.GetInstance()
		let EQUIP_SMELT = ModuleType.EQUIP_SMELT
		let local_EquipDefine = EquipDefine
		let local_EquipEvent = EquipEvent
		let equip_pos_list_ = local_EquipDefine.EQUIP_POS

		let model = EquipModel.GetInstance()
		let res_mgr = ResManager.GetInstance()

		let master_cfg_ = null
		let limit_cfg_ = null
		let attr_cfg_ = null
		let cur_equip_info_ = null
		let enough_goods_ = false
		let enough_goods_top = false
		let is_max_ = false
		let cost_type_id_ = null
		let cost_type_id_top = null
		let cost_num_ = null
		let cost_num_top_ = null
		let cur_grade_ = -1
		let need_top_goods = true
		let red_item_dir = []
		let equip_refine_lv_cfgs = null
		let anim_count = 0
		let anim_all = 0
		let ainming = false

		this.preload_server_config = { "config_equip_refine_max": false, "config_equip_whole_reward": false, "config_equip_refine_lv": false, "config_equip_stren_lv": false }

		this.load_callback = () => {
			this.LoadSuccess()
		}

		this.LoadSuccess = () => {
			limit_cfg_ = res_mgr.GetGameConfigFromCache(this, "config_equip_refine_max", false)
			master_cfg_ = res_mgr.GetGameConfigFromCache(this, "config_equip_whole_reward", false)
			attr_cfg_ = res_mgr.GetGameConfigFromCache(this, "config_equip_attr", false)

			this.fight_item = new FightingShowSmallItem(this._fight_power)
			this.fight_item.Load()

			this.goods_num.width = 100
			this.goods_num.style.fontSize = 20
			this.goods_num.style.color = "#663915"
			this.goods_num.style.align = "center"
			this.goods_num.style.wordWrap = false

			this.goods_num_top.width = 100
			this.goods_num_top.style.fontSize = 20
			this.goods_num_top.style.color = "#663915"
			this.goods_num_top.style.align = "center"
			this.goods_num_top.style.wordWrap = false

			if (!this.use_delete_method) {
				this.AddUIEffect("QiangHua", this.gp_effect, null, 8, null, null, null, (obj) => {
					this.effect_obj = obj
					this.effect_obj.active = false
				}, null, null, null, null, false)

				this.InitEffectBox()
				this.InitEvent()
				this.InitView()
			}
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this.btnStrOne, () => {
				// for (let i = 1; i < 11; i++) {
				// 	this.AddStrenEffect(i)
				// }
				// return
				if (!cur_equip_info_) {
					local_Message.show("需要穿戴装备才可以精炼")
					return
				}
				if (is_max_) {
					local_Message.show("装备已精炼到满级")
					return
				}
				if (!enough_goods_) {
					MaterialsTool.GetInstance().materialsTips(local_EquipDefine.SMELT_GOODS_TYPE_ID)
					return
				}
				if (!enough_goods_top && need_top_goods) {
					MaterialsTool.GetInstance().materialsTips(local_EquipDefine.SMELT_TOP_GOODS_TYPE_ID)
					return
				}
				model.Fire(local_EquipEvent.REQUEST_PROTO, 15251, "cc", cur_equip_info_.equip_type, 1)
			}, this, true)

			Util.AddClickEvent(this.btnStrAll, () => {
				// if (ainming) {
				// 	return
				// }
				if (!cur_equip_info_) {
					local_Message.show("需要穿戴装备才可以精炼")
					return
				}
				if (this.CheckAllMax()) {
					local_Message.show("装备已精炼到满级")
					return
				}
				model.Fire(local_EquipEvent.REQUEST_PROTO, 15251, "cc", cur_equip_info_.equip_type, 2)
			}, this, true)

			this.BindEvent(model, local_EquipEvent.UPDATE_ALL_SMELT, (scmd?) => {
				if (this.use_delete_method) {
					return
				}
				if (scmd && scmd.refine_info) {
					anim_all = scmd.refine_info.length
					anim_count = 0
					ainming = true
					let dealy_time = 0.06
					for (let i in scmd.refine_info) {
						let type = scmd.refine_info[i].equip_type
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

			this.BindEvent(model, local_EquipEvent.UPDATE_ONE_SMELT, (list?) => {
				this.UpdateView()
				this.CheckItemRed()
				if (this.effect_obj) {
					this.effect_obj.active = false
					this.effect_obj.active = true
				}
				// this.UpdateEffecetOne(list[0].equip_type)
				this.AddEffect()
			})

			this.BindEvent(model, local_EquipEvent.SELECT_SMELT_EQUIP, (info?) => {
				cur_equip_info_ = info
				let equip_type = cur_equip_info_.equip_type
				if (this.cache_pos != equip_type) {
					let move_func = () => {
						let x = (equip_type % 2) == 1 && 25 || 568
						let y = Math.ceil(equip_type / 2) * 149
						SetAnchoredPosition(this.fly_item.display_obj, x, y)
						if (this.fly_tween_id) {
							SYTweenLite.Stop(this.fly_tween_id)
						}
						this.fly_item.SetVisible(true)
						this.fly_item.SetData(info.type_id)
						this.fly_tween_id = SYTweenLite.to(this, this.fly_item.display_obj, SYTweenLite.UiAnimationType.ANCHORED_POS, new Vector2(305, 295), 0.35, () => {
							this.UpdateShowData(info)
							this.fly_item.SetVisible(false)
							this.fly_tween_id = null
						})
						this.cache_pos = equip_type
					}

					if (!this.fly_item) {
						this.fly_item = new EquipmentItem(this.display_obj)
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
			})

			this.BindEvent(goods_model, local_GoodsModel.UPDATE_GOODS_NUM, (goods_list?) => {
				if (this.use_delete_method) {
					return
				}
				if (!cost_type_id_) {
					return
				}
				for (let _tmpi in goods_list) {
					let info = goods_list[_tmpi]
					if (cost_type_id_ == info.type_id || cost_type_id_top == info.type_id) {
						this.UpdateCostData()
						this._reddot.visible = red_dot_mgr.CheckRedStatus(EQUIP_SMELT)
						this.CheckItemRed()
						break
					}
				}
			})

			this.BindEvent(goods_model, local_GoodsModel.CHANGE_EQUIPLIST, () => {
				this.UpdateCurEquipInfo()
				this.UpdateView()
			})

			this.BindEvent(GlobalEventSystem, EventName.UPDATE_REDDOT, (rType?, key?) => {
				if (rType != EQUIP_SMELT) {
					return
				}
				this._reddot.visible = red_dot_mgr.CheckRedStatus(EQUIP_SMELT)
			})

			this.BindEvent(model, EquipEvent.ALL_SMELT_FAIL, (scmd?) => {
				if (scmd.res == 1520091) {
					if (!enough_goods_) {
						MaterialsTool.GetInstance().materialsTips(local_EquipDefine.SMELT_GOODS_TYPE_ID)
						return
					}
					if (!enough_goods_top && need_top_goods) {
						MaterialsTool.GetInstance().materialsTips(local_EquipDefine.SMELT_TOP_GOODS_TYPE_ID)
						return
					}
				}
			})
		}

		this.InitView = () => {
			res_mgr.SetOutsideImageSprite(this, this.icon1, "resource/game/equip/other/uidz_004d.png")
			//res_mgr:SetOutsideImageSprite(this, this.bg, GameResPath.GetIconJpg("equip","uidz_005"))
			// res_mgr.SetOutsideImageSprite(this, this.icon2, GameResPath.GetIcon("equip", "uidz_004e"), true)
			// res_mgr.SetOutsideImageSprite(this, this._img_attr, GameResPath.GetIcon("equip", "uidz_002"))
			// res_mgr.SetOutsideImageSprite(this, this._img_cost, GameResPath.GetIcon("equip", "uidz_002"))
			// this.AddUIEffect("UI_1501", "UI" , this._group_eff_1, null, 0.91, true, null)
			equip_refine_lv_cfgs = res_mgr.GetGameConfigFromCache(this, "config_equip_refine_lv", false)
			if (!this.equip_icon_list_) {
				this.equip_icon_list_ = []
			}
			for (let i = 0; i < equip_pos_list_.length; i++) {
				let pos = equip_pos_list_[i]
				let con = (i % 2 == 0 && (this.left_groupEquip) || (this.right_groupEquip))
				let item = new EquipSmeltItem(con)
				item.SetEquipPos(pos)
				item.Load()
				this.equip_icon_list_[i] = item
			}

			cost_type_id_ = local_EquipDefine.SMELT_GOODS_TYPE_ID
			cost_type_id_top = local_EquipDefine.SMELT_TOP_GOODS_TYPE_ID
			this.InitCostData()
			this.UpdateView()
			this.CheckItemRed()
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
			this.UpdatePower()
			this.UpdateShowData(cur_equip_info_)
			this.group_cost.visible = !Util.IsTableEmpty(model.GetWearEquipInfos())
			this._reddot.visible = red_dot_mgr.CheckRedStatus(EQUIP_SMELT)
		}

		this.SetSelectDefault = () => {
			let list = model.GetWearEquipDynamics()
			if (list.length < 1) {
				return
			}
			let dic = model.GetSmeltInfos()
			let info = list[0]
			for (let key in dic) {
				let dynamic = model.GetWearEquipDynamic(dic[key].equip_type)
				if (!dynamic) {

				} else {
					if (!this.CheckMax(dynamic) && this.CheckIsRed(dynamic)) {
						info = dic[key]
						break
					}
				}
			}
			let item = this.equip_icon_list_[info.equip_type - 1]
			item.ExcuteCallback(() => {
				cur_equip_info_ = model.GetWearEquipDynamic(info.equip_type)
				model.Fire(local_EquipEvent.SELECT_SMELT_EQUIP, cur_equip_info_)
			}
			)
		}

		this.CheckIsRed = (info?) => {
			let type = info.equip_type
			return (red_item_dir && red_item_dir[type] && (true) || (false))
		}

		this.CheckItemRed = () => {
			let list = model.GetWearEquipDynamics()
			if (list && list.length > 0) {
				for (let i = 0; i < list.length; i++) {
					let info = list[i]
					let type = info.equip_type
					let smelt_info = model.GetSmeltInfo(type)
					if (smelt_info && (smelt_info.refine || smelt_info.refine == 0)) {
						let refine = smelt_info.refine
						let curCfg = model.GetSmeltData(type, refine, equip_refine_lv_cfgs)
						let attr = ErlangParser.GetInstance().Parse(curCfg.attr_list)
						let wear_info = model.GetWearEquipInfo(type)
						let is_max = this.CheckMax(wear_info)
						if (is_max) {
							let item = this.equip_icon_list_[type - 1]
							item.ExcuteCallback(() => {
								model.Fire(local_EquipEvent.UPDATE_SMELT_ITEM_RED, type, false)
							}
							)
						} else {
							if ((!curCfg || !attr)) {
							} else {
								let goods_str = (curCfg && (JSON.parse(curCfg.object_list)[0]) || (null))
								let goods_str_top = (curCfg && (JSON.parse(curCfg.object_list)[1]) || (null))
								let cost_num = Number(goods_str[2])
								let cost_num_top = (goods_str_top && (Number(goods_str_top[2])) || (null))
								let own = goods_model.GetTypeGoodsNum(cost_type_id_)
								let own_top = goods_model.GetTypeGoodsNum(cost_type_id_top)
								let is_red = (cost_num_top && ((!is_max && own >= cost_num) && own_top >= cost_num_top) || (!is_max && own >= cost_num))
								let item = this.equip_icon_list_[type - 1]
								item.ExcuteCallback(() => {
									model.Fire(local_EquipEvent.UPDATE_SMELT_ITEM_RED, type, is_red)
								}
								)
								red_item_dir[type] = is_red
							}
						}
					}
				}
			}
		}

		this.UpdateShowData = (info?) => {
			if (!info) {
				return
			}
			let equip_type = info.equip_type
			let smelt_info = model.GetSmeltInfo(equip_type)
			if (!smelt_info) {
				return
			}
			let attr_cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_equip_attr.name, info.type_id, false, attr_cfg_)
			let limit_cfg = limit_cfg_[attr_cfg.stage + "@" + info.color + "@" + equip_type]
			if (!limit_cfg) {
				return
			}
			let real_refine = (limit_cfg.refine_max <= smelt_info.refine && (limit_cfg.refine_max) || (smelt_info.refine))
			let refine = real_refine //- 1
			refine = refine == -1 ? 0 : refine
			let curCfg = model.GetSmeltData(equip_type, refine, equip_refine_lv_cfgs)
			let nextCfg = model.GetSmeltData(equip_type, refine + 1, equip_refine_lv_cfgs)
			let wear_info = model.GetWearEquipInfo(equip_type)
			is_max_ = this.CheckMax(wear_info)
			let cur_list = ErlangParser.GetInstance().Parse(curCfg.attr_list)
			let next_list = {}
			if (nextCfg && nextCfg.attr_list) {
				next_list = ErlangParser.GetInstance().Parse(nextCfg.attr_list)
			}
			if (real_refine == 0) {
				for (let _tmpi in cur_list) {
					let attr = cur_list[_tmpi]
					attr[1] = 0
				}
			}
			let now_stren_ratio = 0
			let next_stren_ratio = 0
			//for (let key in equip_refine_lv_cfgs) {
			//let value = equip_refine_lv_cfgs[key]
			//if (curCfg.part == value.part && curCfg.refine > value.refine ) {
			//let list = ErlangParser.GetInstance().Parse(value.attr_list)
			//let i = 0
			//for (let _tmpi in list) {
			// let attr = list[_tmpi]
			//cur_list[i][1] = Number(attr[1]) + Number(cur_list[i][1])
			//i=i+1
			//}
			//}
			//if (((next_list && next_list.length > 0) && nextCfg.part == value.part) && nextCfg.refine > value.refine ) {
			//let list = ErlangParser.GetInstance().Parse(value.attr_list)
			//let i = 0
			//for (let _tmpi in list) {
			// let attr = list[_tmpi]
			//next_list[i][1] = (real_refine == 0 && ( Number(attr[1]) ) || ( Number(attr[1]) + Number(next_list[i][1]) ) )
			//i=i+1
			//}
			//}
			//if (value.part == curCfg.part ) {
			//if (value.refine <= curCfg.refine ) {
			//now_stren_ratio = now_stren_ratio + value.stren_ratio
			//}
			//if (nextCfg && value.refine == nextCfg.refine ) {
			//next_stren_ratio = next_stren_ratio + value.stren_ratio
			//}
			//}
			//}
			if (real_refine >= 0) {
				if (real_refine == 0) {
					let key = curCfg.part + "@" + real_refine;
					let value = equip_refine_lv_cfgs[key];
					now_stren_ratio = value.stren_ratio;
				} else {
					for (let i = 0; i < real_refine; i++) {
						let key = curCfg.part + "@" + i
						let value = equip_refine_lv_cfgs[key]
						if (value) {
							//let list = ErlangParser.GetInstance().Parse(value.attr_list)
							//let i = 0
							//for (let _tmpi in list) {
							// let attr = list[_tmpi]
							//cur_list[i][1] = Number(attr[1]) + Number(cur_list[i][1])
							//i=i+1
							//}
							now_stren_ratio = now_stren_ratio + value.stren_ratio
						}
					}
				}


			}
			if (nextCfg) {
				//let list = ErlangParser.GetInstance().Parse(nextCfg.attr_list)
				//let i = 0
				//for (let _tmpi in list) {
				// let attr = list[_tmpi]
				//next_list[i][1] = (real_refine == 0 && ( Number(attr[1]) ) || ( Number(attr[1]) + Number(cur_list[i][1]) ) )
				//i=i+1
				//}
				next_stren_ratio = curCfg.stren_ratio
			}
			this.UpdateAttrItems(cur_list, next_list, now_stren_ratio, next_stren_ratio, equip_type)
			this.UpdateShowItem()
			let goods_cfg = (real_refine == 0 && (curCfg) || (nextCfg))
			let goods_str = (goods_cfg && (JSON.parse(goods_cfg.object_list)[0]) || (null))
			let goods_str_top = (goods_cfg && (JSON.parse(goods_cfg.object_list)[1]) || (null))
			need_top_goods = goods_str_top
			this.UpdateGoodsData(goods_str, goods_str_top)
		}

		this.UpdateGoodsData = (goods_str?, goods_str_top?) => {
			goods_str_top = false
			if (!goods_str || is_max_) {
				this.goods_num.innerHTML = "已满级"
			}
			if (!goods_str_top && !goods_str || is_max_) {
				this.goods_num_top.innerHTML = "已满级"
				this.need_top_gp.visible = false
				//SetLocalPositionX(this.need_gp,-110)
				//this.need_gp.horizontalCenter = -110
				return
			}
			this.need_top_gp.visible = goods_str_top && true || false
			//SetLocalPositionX(this.need_gp,goods_str_top && -110 || 0)
			cost_num_ = Number(goods_str[2])
			cost_num_top_ = (goods_str_top && (Number(goods_str_top[2])) || (null))
			this.UpdateCostData()
		}

		this.UpdateCostData = () => {
			if (is_max_) {
				return
			}
			if (cost_num_) {
				let own = goods_model.GetTypeGoodsNum(cost_type_id_)
				enough_goods_ = own >= Number(cost_num_)
				let color = (enough_goods_ && (Enum_ColorUtil_Dark.GREEN) || (Enum_ColorUtil_Dark.RED))
				let str = HtmlColorTxt(own, color)
				let result = Util.StrToHTML(str + "/" + cost_num_)
				this.goods_num.innerHTML = result //"<div style='font-size:20px;align:center;color:#663915;'>" + result + "</div>"
				this.gp_num.width = this.goods_num.width

				//let size = Mathf.Max(this.goods_name.width, this.goods_name.width)
				//SetSizeDeltaX(this._Group1, size)
				//SetSizeDeltaX(this.need_gp, size + 76)
			}
			if (cost_num_top_) {
				let own_top = goods_model.GetTypeGoodsNum(cost_type_id_top)
				enough_goods_top = own_top >= Number(cost_num_top_)
				let color_top = (enough_goods_top && (Enum_ColorUtil_Dark.GREEN) || (Enum_ColorUtil_Dark.RED))
				let str = HtmlColorTxt(own_top, color_top)
				let result = Util.StrToHTML(str + "/" + cost_num_top_)
				this.goods_num_top.innerHTML = result //"<div style='font-size:20px;align:center;color:#663915;'>" + result + "</div>"
				this.gp_num_top.width = this.goods_num_top.width

				//let size = Mathf.Max(this.goods_name_top.width, this.goods_num_top.width)
				//SetSizeDeltaX(this._Group2, size)
				//SetSizeDeltaX(this.need_gp_top, size + 76)
			}
		}

		this.InitCostData = () => {
			if (!this.item) {
				this.item = new BaseAwardItem(this.goods_icon)
				this.item.Load()
				this.item.SetItemSize(70, 70)
			}
			this.item.SetData(cost_type_id_)

			if (!this.item_top) {
				this.item_top = new BaseAwardItem(this.goods_icon_top)
				this.item_top.Load()
				this.item_top.SetItemSize(70, 70)
			}
			this.item_top.SetData(cost_type_id_top)
		}

		this.UpdateShowItem = () => {
			if (!cur_equip_info_) {
				return
			}
			let info = cur_equip_info_
			if (!this.show_item_) {
				this.show_item_ = new EquipSmeltItem(this.gp_show)
				this.show_item_.Load()
				//SetAnchoredPosition(this.show_item_.display_obj, 305, 295)
			}
			let attr_cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_equip_attr.name, info.type_id, false, attr_cfg_)
			let limit_cfg = limit_cfg_[attr_cfg.stage + "@" + info.color + "@" + info.equip_type]
			this.show_item_.SetCfgs(limit_cfg, attr_cfg)
			this.show_item_.SetData(info)
		}

		this.UpdateAttrItems = (clist?, nlist?, strong_lv?, next_strong_lv?, equip_type?) => {
			let item = null
			if (!this.attr_item_list_) {
				this.attr_item_list_ = []
			}
			for (let i = 0; i < clist.length; i++) {
				item = this.attr_item_list_[i]
				if (!item) {
					item = new EquipAttrItem(this.listAttr)
					item.Load()
					this.attr_item_list_[i] = item
				}
				item.SetData(1, clist[i], nlist[i], equip_type)
				item.SetVisible(true)
			}
			for (let i = clist.length; i < this.attr_item_list_.length; i++) {
				this.attr_item_list_[i].SetVisible(false)
			}
			if (!this.strong_item) {
				this.strong_item = new EquipAttrItem(this.listAttr)
				this.strong_item.Load()
			}
			this.strong_item.SetData(2, strong_lv, next_strong_lv, equip_type)
		}

		this.UpdatePower = () => {
			let equip_refine_lv_cfgs = res_mgr.GetGameConfigFromCache(this, "config_equip_refine_lv", false)
			let equip_stren_lv_cfgs = res_mgr.GetGameConfigFromCache(this, "config_equip_stren_lv", false)
			let power = model.GetWearEquipsSmeltPower(equip_refine_lv_cfgs, equip_stren_lv_cfgs)
			this.fight_item.Updatefighting(power)
			this.fight_item.horizontalCenter = 0
		}

		this.CheckMax = (info?) => {
			let attr_cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_equip_attr.name, info.type_id, false, attr_cfg_)
			let limit_cfg = limit_cfg_[attr_cfg.stage + "@" + info.color + "@" + info.equip_type]
			if (!limit_cfg) {
				return false
			}
			let smelt_info = model.GetSmeltInfo(info.equip_type)
			if (!smelt_info) {
				return false
			}
			return limit_cfg.refine_max <= smelt_info.refine
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
		/*
		this.SetGradeData = () => {
			let lv = model.GetAllSmeltLv()
			let [_, j, grade] = model.GetWholeAwardCfg(local_EquipDefine.SMELT_WHOLE_TYPE, lv)
			if (cur_grade_ >= 0 && grade > cur_grade_) {
				// this.AddUIEffect2("ui_forge_glow", this._group_eff)
			}
			cur_grade_ = grade
			this.grade.text = grade + "阶"
		}*/

		this.UpdateEffecetAll = (list?) => {
			for (let _tmpi in list) {
				let info = list[_tmpi]
				this.UpdateEffecetOne(info.equip_type)
			}
		}

		this.UpdateEffecetOne = (equip_type?) => {
			let item = this.equip_icon_list_[equip_type - 1]
			if (!item) {
				return
			}
			item.UpdateEffect()
		}

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

		this.AddEffect = () => {
			// this.AddUIEffect("UI_1502", "UI", this._group_eff_2, null, 1)
			this.AddUIEffect("ui_ZiTi_JingLian", this._group_eff_3, null, 2)
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
				// SYTweenLite.to(this, effect_box, SYTweenLite.UiAnimationType.ROTATION, end_rota, anim_time)
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
						this.CheckItemRed()
						// this.SetSelectDefault()
						this.AddEffect()
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
	/*
	protected createChildren  () {
		this.story_obj_list = []
		this.story_obj_list[TaskTipType.RefineEquip] = ["", this.btnStrAll]
		super.createChildren()
	}*/

	public ReOpen_callback() {
		// this.AddUIEffect("UI_1501", "UI", this._group_eff_1, null, 0.91, true, null)
	}

	public DeleteMe() {
		if (this.effect_obj) {
			this.effect_obj.destroy()
		}
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
			this.show_item_ = null
		}
		if (this.item) {
			this.item.DeleteMe()
			this.item = null
		}
		if (this.item_top) {
			this.item_top.DeleteMe()
			this.item_top = null
		}
		if (this.strong_item) {
			this.strong_item.DeleteMe()
			this.strong_item = null
		}
		if (this.fly_item) {
			this.fly_item.DeleteMe()
			this.fly_item = null
		}
		if (this.fly_tween_id) {
			SYTweenLite.Stop(this.fly_tween_id)
			this.fly_tween_id = null
		}
		if (this.fight_item) {
			this.fight_item.DeleteMe()
			this.fight_item = undefined
		}
		super.DeleteMe()
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
	need_gp: Laya.HBox
	goods_icon: Laya.Box
	_Group1: Laya.VBox
	goods_name: Laya.Label
	gp_num: Laya.HBox
	goods_num: Laya.HTMLDivElement
	need_top_gp: Laya.HBox
	goods_icon_top: Laya.Box
	_Group2: Laya.VBox
	goods_name_top: Laya.Label
	gp_num_top: Laya.HBox
	goods_num_top: Laya.HTMLDivElement
	btnStrOne: Laya.Image
	_lb_strOne: Laya.Label
	btnStrAll: Laya.Image
	_lb_strAll: Laya.Label
	_reddot: Laya.Image
	_group_eff: Laya.Box
	_group_eff_1: Laya.Box
	_group_eff_2: Laya.Box
	_group_eff_3: Laya.Box
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
			this.need_gp,
			this.goods_icon,
			this._Group1,
			this.goods_name,
			this.gp_num,
			this.goods_num,
			this.need_top_gp,
			this.goods_icon_top,
			this._Group2,
			this.goods_name_top,
			this.gp_num_top,
			this.goods_num_top,
			this.btnStrOne,
			this._lb_strOne,
			this.btnStrAll,
			this._lb_strAll,
			this._reddot,
			this._group_eff,
			this._group_eff_1,
			this._group_eff_2,
			this._group_eff_3,
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
				"need_gp",
				"goods_icon",
				"_Group1",
				"goods_name",
				"gp_num",
				"goods_num",
				"need_top_gp",
				"goods_icon_top",
				"_Group2",
				"goods_name_top",
				"gp_num_top",
				"goods_num_top",
				"btnStrOne",
				"_lb_strOne",
				"btnStrAll",
				"_lb_strAll",
				"_reddot",
				"_group_eff",
				"_group_eff_1",
				"_group_eff_2",
				"_group_eff_3",
				"gp_effect",
			])
	}
}
window["EquipSmeltView"] = EquipSmeltView
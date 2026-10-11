
import { BaseController } from "../common/BaseController"
import { EventName, SceneEventType } from "../common/EventName"
import { Enum_UILayer, LayerManager } from "../common/LayerManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { MainUIModel, MainFunc } from "../commonModel/MainUIModel"
import { PlatformManager } from "../PlatformManager"
import { RoleManager } from "../commonModel/RoleManager"
import { SceneManager } from "../scene/SceneManager"
import { GlobalEventSystem, ClientConfig } from "../util/DeclareGlobalVar"
import { Status } from "../util/Status"
import { FirstRechargeBubble } from "../recharge/FirstRechargeBubble"
import { FirstRechargeModel } from "../commonModel/FirstRechargeModel"

import "../mainUI/MainUITopView"
import "../mainUI/MainUIDownView"
import "../mainUI/MainUIActivityView"
import "../mainUI/MainUISecondaryView"
import "../mainUI/MainUIChatItem"
import "../mainUI/MainUIChatView"
import "../mainUI/MainUISkillItem"
import "../mainUI/MainUISkillView"
import "../mainUI/MainUITaskTeamView"
import "../mainUI/MainUIAutoBrushView"
import "../mainUI/UIJoyStick"

import "../mainUI/MainUIFightModeItem"
import "../mainUI/MainUIFightModeView"
import "../mainUI/MainUIBuffView"
import "../mainUI/DropProgress"
// import "../mainUI/MainUISkillView"
// import "../mainUI/MainUIChatView"

// import "../mainUI/FightModeView"
import "../common/InstructionView"

import "../common/PropertyTipsView"
import "../common/ExchangeViewOne"
import "../common/CalculatorView"
import "../mainUI/MainUIIconBoxView"
import "../mainUI/MainUIHiterBigBloodView"
import "../mainUI/CollectBarView"
import "../mainUI/MainUIReliveView"
import "../mainUI/OpenDestinyView"
import "../mainUI/EyouThAdultItem"

import { GameResPath } from "../util/GameResPath"
import { ResManager } from "../common/ResManager"
import { IsInTable, SetAnchoredPosition, SetSizeDelta, Util } from "../util/Util"
import { SYTweenLite } from "../util/SYTweenLite"
import { ActivityForeshowManager } from "../commonModel/ActivityForeshowManager"
import { UIEffect } from "../common/UIEffect"
// import "../mainUI/MainUIHiterBigBloodView"
import "../mainUI/FlowerEffectView"
import "../mainUI/FightingUpView"
import "../mainUI/MainUIEffectView"
import "../mainUI/MainUIEffectGodSkillView"
import "../mainUI/MainUIEffectPartnerSkillView"
import "../mainUI/MainUIMarriageItem"

import { ActivityIconManager } from "../commonModel/ActivityIconManager"
import { Vector2 } from "../util/Vector2"
import { SYTweenFunc } from "../util/SYTweenFunc"
import { MarriageEvent, MarriageModel } from "../commonModel/MarriageModel"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import "../mainUI/TopPlayerTipItem"
import "../mainUI/FuncBoardView"
import { MainUITopView } from "../mainUI/MainUITopView"
import { SkillUIModel } from "../commonModel/SkillUIModel"
import { MaskModel } from "../commonModel/MaskModel"
import { GuardModel } from "../commonModel/GuardModel"
import { VipModel } from "../commonModel/VipModel"
import { WeekCardModel } from "../commonModel/WeekCardModel"
import { EyouManager } from "./EyouManager"
import "../common/KSAPKShortcutTipsView"
import { EyouThAdultItem } from "../mainUI/EyouThAdultItem"



export class MainUIController extends BaseController {
	static Instance: MainUIController

	private InitEvent
	private InitMainUI

	/**
	 * 钻石动画随机位置范围
	 */
	diamond_ani_random_range = {
		x: { min: -100, max: 100 },
		y: { min: -100, max: 100 }
	}
	/**
	 * 第一段移动时间
	 */
	diamond_ani_move_time1 = 0.4

	/**
	 * 第二段移动时间
	 */
	diamond_ani_move_time2 = 0.7

	/**
	 * 图片的初始化大小范围，不能填0
	 */
	diamond_img_start_scale = [0.3, 0.4]

	/**
	 * 图片的最终
	 */
	diamond_img_end_scale = 0.4


	/**
	* 特效的初始化大小范围，不能填0
	*/
	diamond_effect_start_scale = [0.7, 1.2]

	/**
	 * 特效的最终
	 */
	diamond_effect_end_scale = 0.4

	SetCareerLevelVisible
	ShowItemMove
	ChangeScene
	GetViewByIndex
	SetMapVisible
	SetMainUIViewVisible
	SetHeadVisible
	ShowTeamView
	ShowDiamond
	CheckDiamondParentChildrenCount
	CheckShowDiamondCount
	SetMoneyType
	SetTopToLayer

	main_ui_secondary_view
	main_ui_top_view
	main_ui_down_view
	main_ui_chat_view
	main_ui_auto_brush_view
	main_ui_task_team_view

	effect_obj: UIEffect
	show_diamond_state = false
	diamond_parent: Laya.Box
	first_recharge_bubble;
	money_type_count_dic
	public constructor() {
		super()

		if (MainUIController.Instance) {
			return
		}

		let local_MainUIModel_Instance = MainUIModel.GetInstance(),
			local_GlobalEventSystem = GlobalEventSystem,
			local_ActivityIconManager_Instance = ActivityIconManager.GetInstance(),
			local_Act_ForeShow_Mgr = ActivityForeshowManager.GetInstance(),

			local_main_ui_top_view: MainUITopView,
			local_main_ui_activity_view,
			local_main_ui_down_view,
			local_main_ui_task_team_view,
			local_main_ui_skill_view,
			local_main_ui_vip_view,
			local_main_ui_secondary_view,
			local_main_ui_auto_brush_view,
			local_ui_joy_stick,
			local_instruction_view,
			local_calculator_view,
			local_fight_mode_view,
			local_main_ui_relive_view,
			local_main_ui_hiter_big_blood_view,
			local_fighting_up_view,
			local_big_eff_view,
			local_big_eff_view2,
			local_big_eff_view3,
			local_icon_box_view,
			local_flower_effect_view,
			local_property_tips_view,
			local_shop_purchase_foreshow_view,
			local_collect_bar_view,


			has_init_mainui,
			delay_timer_list,
			layer_group_list,
			delay_fightup_view_state,
			delay_cache_data,
			first_recharge_bubble,
			show_destiny,
			show_destiny_table,
			clickEffectObj_: UIEffect
		this.InitEvent = () => {

			local_GlobalEventSystem.Bind(
				EventName.GAME_START, () => {
					GoodsModel.GetInstance().Fire(GoodsModel.GET_GOODS_BUFF_LIST)

					MainUIModel.GetInstance().AddAdultFlag()
				}
			)

			local_GlobalEventSystem.Bind(
				EventName.SWITCH_MAIN_FUNC_VIEW, (main_func?, open_index?, back_id?) => {
					local_MainUIModel_Instance.SwitchView(main_func, open_index, back_id)
				}
			)

			local_GlobalEventSystem.Bind(
				EventName.INIT_MAINUI_EVENT, () => {
					this.InitMainUI()
				}
			)

			local_GlobalEventSystem.Bind(
				EventName.OPEN_INSTRUCTION_VIEW, (id?) => {
					if (!local_instruction_view) {
						local_instruction_view = new window["InstructionView"]()
					}
					local_instruction_view.Open(id)
				}
			)

			local_GlobalEventSystem.Bind(
				EventName.OPEN_PROPERTY_TIPS_VIEW, (attr_list?, title_name?) => {
					if (!local_property_tips_view) {
						local_property_tips_view = new window["PropertyTipsView"]()
					}
					local_property_tips_view.SetData(attr_list, title_name)
					if (local_property_tips_view.HasOpen()) {
						local_property_tips_view.UpdateView()
					} else {
						local_property_tips_view.Open()
					}
				}
			)

			local_GlobalEventSystem.Bind(
				EventName.SHOW_HITER_BIG_BLOOD_VIEW, (is_show?, vo?, bar_num?, autoClose?) => {
					if (is_show) {
						if (!local_main_ui_hiter_big_blood_view) {
							local_main_ui_hiter_big_blood_view = new window["MainUIHiterBigBloodView"]()
						}
						local_main_ui_hiter_big_blood_view.SetDate(vo, bar_num, autoClose)
						local_main_ui_hiter_big_blood_view.Open()
					} else {
						if (local_main_ui_hiter_big_blood_view && local_main_ui_hiter_big_blood_view.HasOpen()) {
							local_main_ui_hiter_big_blood_view.Close()
						}
					}
				}
			)
			local_GlobalEventSystem.Bind(
				EventName.SHOW_BAOJI_ANI, (vo?) => {
					if ((vo && local_main_ui_hiter_big_blood_view) && local_main_ui_hiter_big_blood_view.visible == true) {
						local_main_ui_hiter_big_blood_view.ShowBAOJIAni(vo)
					}
				}
			)

			local_GlobalEventSystem.Bind(
				EventName.OPEN_CALCULATOR_VIEW, (...new_args) => {
					if (!local_calculator_view) {
						local_calculator_view = new window["CalculatorView"]()
					}
					local_calculator_view.Open(...new_args)
				}
			)


			local_GlobalEventSystem.Bind(
				EventName.SET_MONEY_TYPE, (list?) => {
					this.SetMoneyType(list)
				}
			)

			////////////////-物品移动//////////////////-
			//goods_list物品列表,
			//start_pos开始的位置,
			//end_pos消失位置 ,
			//len第一部分动画y轴移动的位置,
			//time1第一段动画时间,
			//time2第二段动画时间
			//down_icon_type 如果飘向下方的icon icon会有一个动画 默认为背包
			let show_animation = (goods_list, start_pos = { x: 360, y: -640 }, end_pos?, layer?, len = 0, time1 = 0, time2 = 750, down_icon_type = MainFunc.Bag) => {
				if (goods_list && goods_list.length > 0) {
					layer = layer || Enum_UILayer.Top
					if (!delay_timer_list) {
						delay_timer_list = {}
					}
					if (delay_timer_list) {
						if (!layer_group_list) {
							layer_group_list = {}
						}
						let group = layer_group_list[layer]
						if (!group) {
							let ui_layer = LayerManager.GetInstance().GetUILayer(layer ? layer : Enum_UILayer.Top)
							group = new Laya.Sprite()
							ui_layer.addChild(group)
							layer_group_list[layer] = group
						}

						for (let i = 0; i < goods_list.length; i++) {
							let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(goods_list[i][0], goods_list[i][1])
							if (type_id == 34) {
								this.ShowDiamond(1, goods_list[i][2], start_pos)
							} else if (type_id == 35 || type_id == 36020001) {
								this.ShowDiamond(2, goods_list[i][2], start_pos)
							} else if (type_id == 31) {
								this.ShowDiamond(3, goods_list[i][2], start_pos)
							} else {
								let item = new Laya.Image()
								item.visible = false
								group.addChild(item)
								let goodsinfo = goods_list[i]
								let timer_id: any = setTimeout(() => {
									if (!end_pos) {
										if (local_main_ui_down_view) {
											end_pos = local_main_ui_down_view.GetIconPos(down_icon_type, { x: 0, y: 0 })
										} else {
											end_pos = { x: 550, y: -1000 }
										}
									}
									this.ShowItemMove(item, goodsinfo, start_pos, len, time1, end_pos, time2, timer_id, down_icon_type)
								}, i * 120)
								delay_timer_list[timer_id] = timer_id
							}
						}
					}
				}
			}
			local_GlobalEventSystem.Bind(EventName.REWARD_FLY, show_animation)

			let change_fighting_func = (event_name?, new_fight?, old_fight?) => {
				if (old_fight && old_fight != 0 && new_fight > old_fight) {
					if (delay_fightup_view_state) {
						if (!delay_cache_data) {
							delay_cache_data = {}
						}
						delay_cache_data["old_fight"] =
							(delay_cache_data["old_fight"] && (delay_cache_data["old_fight"]) || (old_fight))
						delay_cache_data["new_fight"] = new_fight
					} else {
						if (SceneManager.GetInstance().IsPolarDungeon() || SceneManager.GetInstance().IsKFPolarDungeon()) {
							return
						}
						if (!local_fighting_up_view) {
							local_fighting_up_view = new window["FightingUpView"]()
						}
						if (local_fighting_up_view.HasOpen()) {
							local_fighting_up_view.SetAnimation(old_fight, new_fight)
						} else {
							local_fighting_up_view.SetData(old_fight, new_fight)
							local_fighting_up_view.Open()
						}
					}
				};
			}
			RoleManager.GetInstance().GetMainRoleVo().BindOne("fighting", change_fighting_func)
			local_GlobalEventSystem.Bind(EventName.DELAY_SHOW_FIGHTUP, change_fighting_func)

			//仅仅播放不循环的特效
			//boo true使用第二个播放窗口
			let play_big_eff = (obj?, type?) => {
				if (!type) {
					if (!local_big_eff_view) {
						local_big_eff_view = new window["MainUIEffectView"]()
					}
					if (local_big_eff_view.HasOpen()) {
						local_big_eff_view.SetData(obj)
					} else {
						local_big_eff_view.SetData(obj)
						local_big_eff_view.Open()
					}
				} else {
					if (type == 1) {
						if (!local_big_eff_view2) {
							local_big_eff_view2 = new window["MainUIEffectGodSkillView"]()
						}
						if (local_big_eff_view2.HasOpen()) {
							local_big_eff_view2.SetData(obj)
						} else {
							local_big_eff_view2.SetData(obj)
							local_big_eff_view2.Open()
						}
					} else if (type == 2) {
						if (!local_big_eff_view3) {
							local_big_eff_view3 = new window["MainUIEffectPartnerSkillView"]()
						}
						if (local_big_eff_view3.HasOpen()) {
							local_big_eff_view3.SetData(obj)
						} else {
							local_big_eff_view3.SetData(obj)
							local_big_eff_view3.Open()
						}
					}

				}

			}
			local_GlobalEventSystem.Bind(EventName.PLAY_BIG_EFFECT, play_big_eff)
			// local_GlobalEventSystem.Bind(
			// 	EventName.DELAY_SHOW_FIGHTUP, (bool?) => {
			// 		delay_fightup_view_state = bool
			// 		if (!bool && delay_cache_data) {
			// 			change_fighting_func(null, delay_cache_data.new_fight, delay_cache_data.old_fight)
			// 			delay_cache_data = null
			// 		}
			// 	}
			// )

			local_GlobalEventSystem.Bind(
				EventName.OPEN_MAINUI_VIP_TIP, (state?) => {
					if ((state && !PlatformManager.GetInstance().is_alpha) && !PlatformManager.GetInstance().need_alpha_open_charge
					) {
						if (!local_main_ui_vip_view) {
							local_main_ui_vip_view = new window["MainUIVipTipsView"]()
						}
						local_main_ui_vip_view.Open()
					} else {
						if (local_main_ui_vip_view) {
							local_main_ui_vip_view.Close()
							local_main_ui_vip_view = null
						}
					}
				}
			)

			RoleManager.GetInstance().GetMainRoleVo().Bind(
				EventName.CHANGE_LEVEL, (lv) => {
					// LoginManager.GetInstance().RecordRoleData()
					this.ShowTeamView()
					// let lv = RoleManager.GetInstance().GetMainRoleVo().level
					if (lv == 371 && !show_destiny) {
						show_destiny = true
						GlobalEventSystem.Fire(EventName.OPEN_VIEW, "OpenDestinyView")
					}
					local_MainUIModel_Instance.TryRefreshBuff()

				}
			)

			GlobalEventSystem.Bind(EventName.GAME_DISCONNECT, () => {
				PlatformManager.GetInstance().CancelAPKShourtcutTimer()
			})

			//////////////////-首充气泡//////////////////-
			FirstRechargeModel.GetInstance().Bind(FirstRechargeModel.ADD_BUBBLE, (bool?) => {
				if (PlatformManager.GetInstance().is_alpha) return
				if (bool) {
					if (!first_recharge_bubble) {
						first_recharge_bubble = new FirstRechargeBubble()
						first_recharge_bubble.Open()
						this.first_recharge_bubble = first_recharge_bubble
					}
				} else {
					if (first_recharge_bubble) {
						first_recharge_bubble.Close()
						first_recharge_bubble = null
					}
				}
			})
			
			//天命转盘
			// CustomActivityModel.GetInstance().Bind(CustomActivityDefine.EVENT.OPEN_DESTABLE, (bool?) => {
			// 	if (bool) { 
			// 		if (!show_destiny_table) {
			// 			show_destiny_table = new DestinyTurnTableActiveView()
			// 			show_destiny_table.Open()
			// 		}
			// 	} else {
			// 		if (show_destiny_table) {
			// 			show_destiny_table.Close()
			// 			show_destiny_table = null
			// 		}
			// 	}

			// })

			//////////////////-移动//////////////////-
			let onJoystickDirChange = () => {
				if (local_ui_joy_stick) {
					if (SceneManager.GetInstance().curr_joystick_dir) {
						if (SceneManager.GetInstance().IsExpScene()) {
							return;
						}
						local_ui_joy_stick.ShowJoyStick()
					} else {
						local_ui_joy_stick.HideJoyStick()
					}
				}
			}
			SceneManager.GetInstance().BindOne("curr_joystick_dir", onJoystickDirChange)

			let onJoysticMoveChange = () => {
				if (SceneManager.GetInstance().IsExpScene()) {
					return;
				}
				if (local_ui_joy_stick) {
					local_ui_joy_stick.UpdatePos()
				}
			}
			SceneManager.GetInstance().BindOne("curr_click_move_pos", onJoysticMoveChange)

			//////////////////-特惠商店//////////////////-
			local_GlobalEventSystem.Bind(
				SceneEventType.SCENE_CHANGED, () => {
					this.ChangeScene()
					local_MainUIModel_Instance.TryRefreshBuff()
				}
			)

			local_GlobalEventSystem.Bind(
				EventName.OPEN_ICON_BOX_VIEW, (...new_args) => {
					local_GlobalEventSystem.Fire(EventName.OPEN_VIEW, "MainUIIconBoxView", ...new_args)
				}
			)

			local_GlobalEventSystem.Bind(
				EventName.CLOSE_ICON_BOX_VIEW, () => {
					local_GlobalEventSystem.Fire(EventName.CLOSE_VIEW, "MainUIIconBoxView")
				}
			)


			local_GlobalEventSystem.Bind(EventName.OPEN_COLLECT_VIEW, (mon_id?, type_id?, collect_time?, is_fake?, call_back?, show_tips?, close_call_back?, show_img?) => {

				if (local_collect_bar_view == null) {
					local_collect_bar_view = new window["CollectBarView"]()
				}
				if (!local_collect_bar_view.isPop) {
					local_collect_bar_view.Open(mon_id, type_id, collect_time, is_fake, call_back, show_tips, close_call_back, show_img)
				}
			})




			let effect_group: Laya.Sprite = new Laya.Sprite(), ui_effect = new UIEffect()
			effect_group.width = LayerManager.GetInstance().stageWidth
			effect_group.height = LayerManager.GetInstance().stageHeight

			local_GlobalEventSystem.Bind(EventName.STATE_RESET_SIZE, () => {
				effect_group.width = LayerManager.GetInstance().stageWidth
				effect_group.height = LayerManager.GetInstance().stageHeight
			})


			/**
			 * 在对应层级下创建特效(必须传时长)
			 * @param layer_value 层级
			 * @param effect_name 特效名
			 * @param pos 位置
			 * @param scale 缩放
			 * @param time 持续时间
			 * @param call_back 播放结束后回调
			 * @param effect_res_type 资源类型
			 * @returns 
			 */
			let play_fun = (layer_value, effect_name, pos, scale, time, call_back?, effect_res_type?) => {
				if (!layer_value || !effect_name || !pos) {
					return
				}
				if (!time) time = 5
				let ui_layer = LayerManager.GetInstance().GetUILayer(layer_value)
				ui_layer.addChild(effect_group)

				let effect_pos = pos
				let call_fun = () => {
					if (effect_group) {
						ui_effect.ClearUIEffect(effect_group)
						effect_group.removeSelf()
						effect_group.removeChildren()
					}
					if (call_back) {
						call_back()
					}
				}
				ui_effect.AddUIEffect(effect_name, effect_group, effect_pos, scale, false, time, call_fun, null, null, null, null, null, false, effect_res_type)
			}
			GlobalEventSystem.Bind(EventName.SHOW_EFFECT, play_fun)


			MarriageModel.GetInstance().Bind(MarriageEvent.SHOW_FLOWER_EFFECT, () => {

				if (window["FlowerEffectView"]) {
					local_flower_effect_view = new window["FlowerEffectView"]()
				}
				if (!local_flower_effect_view.HasOpen()) {

					local_flower_effect_view.open_callback = () => {
						local_flower_effect_view.ShowFlowerEffect()
					}
					local_flower_effect_view.Open()
				} else {
					local_flower_effect_view.ShowFlowerEffect()
				}
			}
			)

			CustomActivityModel.GetInstance().Bind(CustomActivityDefine.EVENT.WAVE_RED_PACKET, (bool?) => {
				if (bool) {
					if (!local_flower_effect_view && window["FlowerEffectView"]) {
						local_flower_effect_view = new window["FlowerEffectView"]()
					}
					if (!local_flower_effect_view.HasOpen()) {
						local_flower_effect_view.open_callback = () => {
							local_flower_effect_view.CreateRPREffect()
						}
						local_flower_effect_view.Open()
					} else {
						//local_flower_effect_view.CreateRPREffect()
					}
				} else {
					if (local_flower_effect_view && local_flower_effect_view.HasOpen()) {
						local_flower_effect_view.RPR_effect_playing = false

						local_flower_effect_view.Close()
						local_flower_effect_view = null
					}
				}
			}
			)


			let refresh_buff_count = () => {
				local_MainUIModel_Instance.TryRefreshBuff()
			}

			RoleManager.GetInstance().GetMainRoleVo().BindOne("worldLv", refresh_buff_count)
			RoleManager.GetInstance().GetMainRoleVo().BindOne("worldLvExp", refresh_buff_count)
			RoleManager.GetInstance().GetMainRoleVo().BindOne("vip_flag", refresh_buff_count)
			GoodsModel.GetInstance().Bind(GoodsModel.UPDATE_GOODS_BUFF_DATA, refresh_buff_count)
			VipModel.GetInstance().Bind(VipModel.UPDATE_NOBLE_STATE, refresh_buff_count)
			GuardModel.GetInstance().Bind(GuardModel.UPDATA_VIEW, refresh_buff_count)
			GlobalEventSystem.Bind(EventName.UPDATE_WORLD_LEVEL_VIEW, refresh_buff_count)
			// this.Bind(ActChallengeModel.GetInstance(), ActChallengeModel.UPDATE_BUFF, refresh_buff_count)
			MaskModel.GetInstance().Bind(MaskModel.UPDATE_INFO, refresh_buff_count)
			SkillUIModel.GetInstance().Bind(SkillUIModel.UPDATE_CAREER_SKILL_BUFF, refresh_buff_count)
			GlobalEventSystem.Bind(EventName.UPDATE_MAINUI_BUFF_COUNT, refresh_buff_count)
			WeekCardModel.GetInstance().Bind(WeekCardModel.UPDATE_VIEW, refresh_buff_count)
		}



		this.InitMainUI = () => {
			if (!has_init_mainui) {
				has_init_mainui = true

				if (window["MainUITopView"]) {
					local_main_ui_top_view = new window["MainUITopView"]()
					local_main_ui_top_view.Open()
					this.main_ui_top_view = local_main_ui_top_view
				}

				if (window["MainUIActivityView"]) {
					local_main_ui_activity_view = new window["MainUIActivityView"]()
					local_main_ui_activity_view.Open()
				}

				if (window["MainUISkillView"]) {
					local_main_ui_skill_view = new window["MainUISkillView"]()
					local_main_ui_skill_view.Open()
				}

				if (window["MainUIChatView"]) {
					this.main_ui_chat_view = new window["MainUIChatView"]()
					this.main_ui_chat_view.Open()
				}

				if (window["MainUISecondaryView"]) {
					local_main_ui_secondary_view = new window["MainUISecondaryView"]()
					local_main_ui_secondary_view.Open()
					this.main_ui_secondary_view = local_main_ui_secondary_view
				}

				if (window["MainUITaskTeamView"]) {
					local_main_ui_task_team_view = new window["MainUITaskTeamView"]()
					local_main_ui_task_team_view.Open()
					this.main_ui_task_team_view = local_main_ui_task_team_view
				}

				if (window["MainUIDownView"]) {
					local_main_ui_down_view = new window["MainUIDownView"]()
					local_main_ui_down_view.Open()
					this.main_ui_down_view = local_main_ui_down_view;
				}

				if (window["MainUIAutoBrushView"]) {
					local_main_ui_auto_brush_view = new window["MainUIAutoBrushView"]()
					local_main_ui_auto_brush_view.Open()
					this.main_ui_auto_brush_view = local_main_ui_auto_brush_view;
				}

				if (window["UIJoyStick"]) {
					local_ui_joy_stick = new window["UIJoyStick"]()
					local_ui_joy_stick.Open()
				}
				// this.ShowTeamView()
			}
		}

		this.SetMainUIViewVisible = (index?, bool?) => {
			if (index == 0) {
				if (local_main_ui_top_view) {
					if (bool) {
						local_main_ui_top_view.CancelHide()
					} else {
						local_main_ui_top_view.Hide()
					}
				}
			} else if (index == 1) {
				if (local_main_ui_activity_view) {
					if (bool) {
						local_main_ui_activity_view.CancelHide()
					} else {
						local_main_ui_activity_view.Hide()
					}
				}
			} else if (index == 2) {
				if (local_main_ui_secondary_view) {
					if (bool) {
						local_main_ui_secondary_view.CancelHide()
					} else {
						local_main_ui_secondary_view.Hide()
					}
				}
			} else if (index == 3) {
				if (this.main_ui_chat_view) {
					if (bool) {
						this.main_ui_chat_view.CancelHide()
					} else {
						this.main_ui_chat_view.Hide()
					}
				}
			} else if (index == 4) {
				if (local_main_ui_down_view) {
					if (bool) {
						local_main_ui_down_view.CancelHide()
					} else {
						local_main_ui_down_view.Hide()
					}
				}
			} else if (index == 6) {
				if (local_main_ui_relive_view) {
					if (bool) {
						local_main_ui_relive_view.CancelHide()
					} else {
						local_main_ui_relive_view.Hide()
					}
				}
			} else if (index == 7) {
				if (local_main_ui_vip_view) {
					if (bool) {
						local_main_ui_vip_view.CancelHide()
					} else {
						local_main_ui_vip_view.Hide()
					}
				}
			} else if (index == 8) {
				if (local_shop_purchase_foreshow_view) {
					if (bool) {
						local_shop_purchase_foreshow_view.CancelHide()
					} else {
						local_shop_purchase_foreshow_view.Hide()
					}
				}
			} else if (index == 9) {
				if (local_flower_effect_view) {
					if (bool) {
						local_flower_effect_view.CancelHide()
					} else {
						local_flower_effect_view.Hide()
					}
				}
			} else if (index == 10) {
				if (local_main_ui_secondary_view) {
					local_main_ui_secondary_view.SetGroupVisible(bool)
				}
			} else if (index == 11) {
				if (local_main_ui_task_team_view) {
					if (bool) {
						local_main_ui_task_team_view.CancelHide()
					} else {
						local_main_ui_task_team_view.Hide()
					}
				}
			} else if (index == 12) {
			} else if (index == 13) {
				if (local_main_ui_secondary_view) {
					local_main_ui_secondary_view.SetRightConPos(bool)
				}
			} else if (index == 14) {
				if (local_main_ui_skill_view) {
					if (bool) {
						local_main_ui_skill_view.CancelHide()
					} else {
						local_main_ui_skill_view.Hide()
					}
				}
			} else if (index == 15) {
				if (first_recharge_bubble) {
					if (bool) {
						first_recharge_bubble.CancelHide()
					} else {
						first_recharge_bubble.Hide()
					}
				}
			}
		}

		this.ShowTeamView = () => {
			// let show = (RoleManager.GetInstance().mainRoleInfo && RoleManager.GetInstance().mainRoleInfo.level >= TeamModel.SHOW_TEAM_LV) && !SceneManager.GetInstance().HideTeamIconScene()
			// if (this.main_ui_team_view) { 
			// 	this.SetMainUIViewVisible(12, show)
			// }
		}

		this.GetViewByIndex = (index?) => {
			return null
		}

		this.SetHeadVisible = (bool?) => {
			if (local_main_ui_top_view) {
				local_main_ui_top_view.SetHeadVisible(bool)
			}
		}

		this.SetCareerLevelVisible = (bool?) => {
			// if (local_main_ui_top_view) {
			// 	local_main_ui_top_view.SetCareerLevelVisible(bool)
			// }
		}

		this.SetMapVisible = (bool?) => {
			if (local_main_ui_top_view) {
				local_main_ui_top_view.SetMapVisible(bool)
			}
		}

		this.SetMoneyType = (list?) => {
			if (local_main_ui_top_view) {
				local_main_ui_top_view.SetMoneyType(list)
			}
		}

		this.ShowItemMove = (item?, vo?, start_pos?, len?, time1?, end_pos?, time2?, timer_index?, icon_type?) => {
			if (item) {
				let style = vo.style || vo[0]
				let typeId = vo.typeId || vo[1]
				let count = vo.count || vo[2]
				let [goods_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(style, typeId)
				let basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(goods_id)

				if (basic) {
					ResManager.GetInstance().SetOutsideImageSprite(this, item, GameResPath.GetGoodsIconPath(basic.goods_icon))
				}
				SetSizeDelta(item, 84, 84)
				SetAnchoredPosition(item, start_pos.x, start_pos.y)
				item.visible = true

				let delay_call = () => {

					if (item) {
						item.visible = false
						item.destroy()
					}
					if (delay_timer_list && delay_timer_list[timer_index]) {
						clearTimeout(delay_timer_list[timer_index])
					}
					if (icon_type) {
						local_GlobalEventSystem.Fire(EventName.PLAY_DOWN_ICON_ANIMATION, icon_type)
					}
				}

				if (item) {
					if (!time1 || time1 == 0) {
						SYTweenLite.to(this, item, SYTweenLite.UiAnimationType.ANCHORED_POS, { x: end_pos.x, y: end_pos.y }, time2 / 1000, delay_call)
					} else {
						SYTweenLite.to(this, item, SYTweenLite.UiAnimationType.ANCHORED_POSY, start_pos.y - len, time1 / 1000, () => {
							SYTweenLite.to(this, item, SYTweenLite.UiAnimationType.SCALE, { x: 0.5, y: 0.5 }, (time2 - 100) / 1000)
							SYTweenLite.to(this, item, SYTweenLite.UiAnimationType.ANCHORED_POS, { x: end_pos.x, y: end_pos.y }, time2 / 1000, delay_call)
						})
					}
					//Laya.Tween.get(item):to({y = start_pos.y + len}, time1).to(
					//{scaleX = 0.6, scaleY = 0.6, x = end_pos.x, y = end_pos.y},
					//time2
					//):call(delay_call)
				}
			}
		}



		this.ShowDiamond = (type, count, start_pos) => {
			if (!type || !count || !start_pos)
				return

			let stage_width = LayerManager.GetInstance().stageWidth
			let stage_height = LayerManager.GetInstance().stageHeight
			//根据界面大小取随机范围、
			let random_range = {
				x_min: start_pos.x + this.diamond_ani_random_range.x.min,
				x_max: start_pos.x + this.diamond_ani_random_range.x.max,
				y_min: start_pos.y + this.diamond_ani_random_range.y.min,
				y_max: start_pos.y + this.diamond_ani_random_range.y.max,
			}

			random_range.x_min = Util.Clamp(0, stage_width, random_range.x_min)
			random_range.x_max = Util.Clamp(0, stage_width, random_range.x_max)
			random_range.y_min = Util.Clamp(0, stage_height, random_range.y_min)
			random_range.y_max = Util.Clamp(0, stage_height, random_range.y_max)

			//超出屏幕 不添加动画
			if (random_range.x_min == random_range.x_max || random_range.y_min == random_range.y_max) {
				return
			}

			this.show_diamond_state = true
			type = Number(type)
			count = Number(count)
			let show_count = 5, source_str, effect_name, end_pos
			if (type == 1) {
				effect_name = "ui_bangyu_2"
				end_pos = local_main_ui_top_view.GetMoneyPos(0)
			} else if (type == 2) {
				effect_name = "ui_bangyu_1"
				end_pos = local_main_ui_top_view.GetMoneyPos(1)
			} else if (type == 3) {
				source_str = "com_gold"
				end_pos = local_main_ui_top_view.GetMoneyPos(2)
			}
			else {
				end_pos = { x: 620, y: 10 }
			}

			if (count > 15) {
				show_count = Math.min(Math.ceil(count / 3), 20)
			}

			if (!this.money_type_count_dic) {
				this.money_type_count_dic = {}
			}

			if (!this.money_type_count_dic[type]) {
				this.money_type_count_dic[type] = 0
			}

			this.money_type_count_dic[type] += show_count

			if (!this.effect_obj) {
				this.effect_obj = new UIEffect()
			}

			if (!this.diamond_parent) {
				this.diamond_parent = new Laya.Box()
				let ui_layer = LayerManager.GetInstance().GetUILayer(Enum_UILayer.Top)
				ui_layer.addChild(this.diamond_parent)
			}

			let pos1_x, pos1_y
			for (let i = 0; i < show_count; i++) {
				let time = this.diamond_ani_move_time2 + i * 0.05

				let box = new Laya.Box()
				box.width = box.height = 100
				box.anchorX = box.anchorY = 0.5
				let scale
				if (source_str) {
					let image = new Laya.Image()
					box.addChild(image)
					image.centerX = image.centerY = 0
					image.anchorX = image.anchorY = 0.5
					image.skin = GameResPath.GetIcon("common", source_str)
					var local_scale
					if (typeof (this.diamond_img_start_scale) == "number") {
						local_scale = this.diamond_img_start_scale
					} else if (this.diamond_img_start_scale[0] && this.diamond_img_start_scale[1]) {
						local_scale = Util.RandomRange(this.diamond_img_start_scale[0], this.diamond_img_start_scale[1])
					}
					image.scale(local_scale, local_scale)
					scale = this.diamond_img_end_scale
					image.rotation = Util.RandomRange(0, 360)
					SYTweenLite.to(this, image, SYTweenLite.UiAnimationType.ROTATION, image.rotation + 720, this.diamond_ani_move_time1 + time, null, SYTweenFunc.LINEAR)
				}

				if (effect_name) {
					let effect_box = new Laya.Box()
					box.addChild(effect_box)
					effect_box.width = effect_box.height = 100
					effect_box.centerX = effect_box.centerY = 0
					effect_box.anchorX = effect_box.anchorY = 0.5
					var local_scale
					if (typeof (this.diamond_effect_start_scale) == "number") {
						local_scale = this.diamond_effect_start_scale
					} else if (this.diamond_effect_start_scale[0] && this.diamond_effect_start_scale[1]) {
						local_scale = Util.RandomRange(this.diamond_effect_start_scale[0], this.diamond_effect_start_scale[1])
					}
					effect_box.scale(local_scale, local_scale)
					scale = this.diamond_effect_end_scale
					this.effect_obj.AddUIEffect(effect_name, effect_box, null, 14)
					effect_box.rotation = Util.RandomRange(0, 360)
				}

				this.diamond_parent.addChild(box)

				box.x = start_pos.x
				box.y = start_pos.y

				pos1_x = Util.RandomRange(random_range.x_min, random_range.x_max)
				pos1_y = Util.RandomRange(random_range.y_min, random_range.y_max)

				SYTweenLite.to(this, box, SYTweenLite.UiAnimationType.ANCHORED_POS, new Vector2(pos1_x, pos1_y), this.diamond_ani_move_time1, () => {
					SYTweenLite.to(this, box, SYTweenLite.UiAnimationType.SCALE, new Vector2(scale, scale), time)
					SYTweenLite.to(this, box, SYTweenLite.UiAnimationType.ANCHORED_POS, new Vector2(end_pos.x, end_pos.y), time + 0.1, () => {
						box.removeSelf()
						this.CheckDiamondParentChildrenCount(type)
					}, SYTweenFunc.EASE_IN_OUT)
				}, SYTweenFunc.EASE_OUT)
			}
		}

		this.CheckShowDiamondCount = (type) => {
			if (this.money_type_count_dic) {
				if (this.money_type_count_dic[type + 1]) {
					return true
				}
			}
			return false
		}

		this.CheckDiamondParentChildrenCount = (type) => {
			--this.money_type_count_dic[type]
			if (this.money_type_count_dic[type] == 0) {
				GlobalEventSystem.Fire(EventName.UPDATE_MAINUI_MONEY, type - 1, true)
			}

			if (!Util.IsNull(this.diamond_parent) && this.diamond_parent.numChildren == 0 && this.show_diamond_state) {
				console.warn("------DiamondDone------")
				this.show_diamond_state = false
				this.effect_obj.ResetUIEffect()
			}
		}

		this.ChangeScene = () => {
			this.ShowTeamView()
			if (SceneManager.GetInstance().IsFieldScene()) {
				local_MainUIModel_Instance.Fire(MainUIModel.CHANGE_ACTIVITY_STATE, true)
				this.SetMainUIViewVisible(0, true)
				this.SetMainUIViewVisible(1, true)
				this.SetMainUIViewVisible(2, true)
				this.SetMainUIViewVisible(3, true)
				this.SetMainUIViewVisible(4, true)
				this.SetMainUIViewVisible(10, true)
			}
		}


		this.SetTopToLayer = (enum_ui_layer) => {
			if (local_main_ui_top_view) {
				if (local_main_ui_top_view.layer_value == enum_ui_layer) return
				local_main_ui_top_view.layer_value = enum_ui_layer
				if (local_main_ui_top_view.HasOpen()) {
					let ui_layer = LayerManager.GetInstance().GetUILayer(enum_ui_layer)
					if (local_main_ui_top_view.default_child_index == null) {
						ui_layer.addChild(local_main_ui_top_view.display_obj);
					}
					else {
						ui_layer.setChildIndex(local_main_ui_top_view.display_obj, local_main_ui_top_view.default_child_index);
					}
				}
			}
		}


		this.InitEvent()
	}

	public static GetInstance() {

		if (!MainUIController.Instance) {
			MainUIController.Instance = new MainUIController()
		}
		return MainUIController.Instance
	}

}
window["MainUIController"] = MainUIController
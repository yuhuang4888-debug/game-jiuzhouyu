import { BaseView1 } from "../common/BaseView1"
import { CommonRewardItem } from "../common/CommonRewardItem"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { SoundManager } from "../common/SoundManager"
import { table } from "../common/table"
import { WordManager } from "../common/WordManager"
import { BaseDungeonModel, DungeonResultType, DUN_TYPE } from "../commonModel/BaseDungeonModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { TaskTipType } from "../commonModel/TaskModel"
// import { TeamModel } from "../commonModel/TeamModel"
import { PlatformManager } from "../PlatformManager"
import { RoleManager } from "../commonModel/RoleManager"
import { SceneManager } from "../scene/SceneManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { Runner } from "../util/Runner"
import { SYTweenFunc } from "../util/SYTweenFunc"
import { SYTweenLite } from "../util/SYTweenLite"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest, Util } from "../util/Util"
import { Vector2 } from "../util/Vector2"
import { Vector3 } from "../util/Vector3"
import { DungeonEnterView } from "./DungeonEnterView"
import { Mathf } from "../util/Mathf"
import { CommonManager } from "../common/CommonManager"
import { SentientActEvent, SentientActModel } from "../commonModel/SentientActModel"
import { OpenFun } from "../common/OpenFun"

export class DungeonVictoryView extends BaseView1 {

	BindUpData
	CancelTime
	CountDownFunc
	FomatCountTimeTips
	GetRankImage
	InitEvent
	InitView
	Remove
	Scr_sc_equip_reward
	Scr_sc_reward
	SetWXShare
	ShowExpAni
	ShowNeedComponent
	ShowStoryArrow
	StartTime
	Update
	UpdateView
	_dgp_reward
	_dgp_reward1
	anim_list
	equip_reward_loop_mgr
	equip_other_reward_loop_mgr
	func_touch_treasure
	grid_layout
	loop_mgr
	not_show_main_msg
	showEffect
	showPoint
	treasure_click



	public static result_type_cfg = {
		[DungeonResultType.Default]: {
			_gp_fly: { visible: true, y: 484 },
			_gp_victory: { visible: true, y: 480 },
			_gp_tip_1: { visible: true, y: 534 },
			_gp_reward_con: { visible: true, y: 564 },
			_gp_btns: { visible: true },
			_img_point: { visible: true, y: 510 }
		},

		[DungeonResultType.Sweeping]: {
			_gp_fly: { visible: true, y: 484 },
			_gp_victory: { visible: true, y: 480 },
			_gp_tip_1: { visible: true, y: 534 },
			_gp_reward_con: { visible: true, y: 564 },
			_gp_btns: { visible: true },
			_img_point: { visible: true, y: 510 }
		},

		[DungeonResultType.Exp]: {
			_gp_get_exp: { visible: true },
			_gp_fly: { visible: true, y: 400 },
			_gp_victory: { visible: true, y: 480 },
			_btn_left: { visible: false },
			_gp_btns: { visible: true },
			_img_point: { visible: true, y: 59 }
		}
	}
	public constructor() {
		super()

		this.treasure_click = false
		this.base_file = "dungeonCommon"
		this.layout_file = "DungeonVictoryView"
		this.layer_value = Enum_UILayer.Activity
		this.use_background = true
		this.background_alpha = 1
		this.not_show_main_msg = true
		this.is_center = true
		this.destroy_imm = true
		let model = BaseDungeonModel.GetInstance()
		let local_DungeonResultType = DungeonResultType
		let local_DUN_TYPE = DUN_TYPE
		let local_BaseDungeonModel = BaseDungeonModel
		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName
		let local_DungeonEnterView = DungeonEnterView
		let scene_mgr = SceneManager.GetInstance()
		let goods_model = GoodsModel.GetInstance()

		let local_WordManager = WordManager
		let local_TimeUtil = TimeUtil
		let role_mgr = RoleManager.GetInstance()
		let local_laya = Laya
		let left_time_ = 15
		let time_id_ = null
		let time_func_ = null
		let end_time_ = null
		let count_down_func_ = null
		let dungeon_result_type_ = null
		let dun_type_ = null
		let update_id_ = null
		let max_count_ = 50
		let now_count_ = 0
		let now_exp_ = 0
		let reward_arr_ = null
		let wx_share_tips_ = null
		let not_reopen_view = false
		let voice
		this.anim_list = []
		this.load_callback = () => {
			voice = CommonManager.GetInstance().PlayFightingVoice(2)
			this.InitEvent()
			GlobalEventSystem.Fire(EventName.SETTING_INPUT_FOCUS);
			this.exp_old.style.fontSize = 20
			this.exp_old.style.color = "#663915"
			this.exp_old.style.wordWrap = false
			this.exp_new.style.fontSize = 20
			this.exp_new.style.color = "#663915"
			this.exp_new.style.wordWrap = false
		}

		this.open_callback = () => {
			this.InitView()
		}

		this.close_callback = () => {
			this.Remove()
		}

		this.InitEvent = () => {


			this._html_left_time.style.fontSize = 22
			this._html_left_time.style.align = "center"
			this._html_left_time.style.color = "#ffffff"
			this._html_left_time.style.width = 720

			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("dungeonCommon", "com_up_bg1"))
			ResManager.GetInstance().SetImageSpriteTrans(this, this._img_bg2, GameResPath.GetIcon("dungeonCommon", "ui_copy_64"))

			Util.AddClickEvent(
				this._btn_right, () => {
					let need_return = false
					if (dungeon_result_type_ == local_DungeonResultType.Sweeping
						|| dun_type_ == local_DUN_TYPE.Marriage) {
						this.Close()
						return
					}

					//众生之门

					if (dun_type_ == local_DUN_TYPE.SentientAct) {
						//用上次结算时剩余的次数和当前剩余次数做一个校对，如果对不上，就是在结算界面打开的
						//时候进入到另一个传送门里面，那么此时只需要关闭界面，就不发送退出场景的协议
						let cur_enter_num = SentientActModel.GetInstance().enter_num
						let data = model.GetDungeonResultInfo()
						if (data && data["enter_num"] != null && (cur_enter_num != data["enter_num"])) {
							this.Close()
							return
						}
					}

					switch (dun_type_) {
						case local_DUN_TYPE.Rune:
						case local_DUN_TYPE.Tower:
							let dun_list = model.GetDungeonInfo(dun_type_)
							if (dun_list) {
								let all_floor = dun_list.length
								let cur_floor = 0
								for (let key in dun_list) {

									if (dun_list[key].permanent_count > 0) {
										cur_floor = Number(key) + 1
									}
								}
								let cur_data = dun_list[cur_floor]
								if (cur_data) {
									model.Fire(local_BaseDungeonModel.SCMD_REQUEST, 61001, cur_data.dun_id)
								}
							}
							this.Close()
							need_return = true
							break
						case local_DUN_TYPE.Vip_Rerson_Boss:
							// local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "BossEnterView", BossModel.Index.Vip_Person_Boss)
							break
						case local_DUN_TYPE.Exp:
							if (!not_reopen_view) {
								local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "DungeonEnterView", local_DungeonEnterView.Index.Exp)
							}
							break
						case local_DUN_TYPE.Material_Mount:
						case local_DUN_TYPE.Material_Copper:
						case local_DUN_TYPE.NEW_AMULET:
						case local_DUN_TYPE.NEW_MOUNT:
						case local_DUN_TYPE.NEW_WEAPON:
						case local_DUN_TYPE.NEW_WING:
						case local_DUN_TYPE.NEW_BACK_ORNAMENT:
							if (!not_reopen_view) {
								local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "DungeonEnterView",
									local_DungeonEnterView.Index.Material)
							}
							break
						case local_DUN_TYPE.Unreal:
							local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "DungeonEnterView", local_DungeonEnterView.Index.Equip)
							break
						case local_DUN_TYPE.Equip:
							if (!not_reopen_view) {
								local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "DungeonEnterView", local_DungeonEnterView.Index.Equip)
							}
							break
						case local_DUN_TYPE.Marriage:
							local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "MarriageBaseView", 4)
							break
						case local_DUN_TYPE.Soul:
							let info = model.GetDungeonResultInfo()
							// [ts2lua]info下标访问可能不正确
							if (!info["isSweepSoul"]) {
								// local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "DungeonEnterView", local_DungeonEnterView.Index.Soul)
							}
							break
						case local_DUN_TYPE.AdvancedExp:
							//local_GlobalEventSystem:Fire(local_EventName.OPEN_VIEW, "DungeonEnterView", local_DungeonEnterView.Index.AdvanExp)
							break
						case local_DUN_TYPE.TOWER_LIMIT:
							let next_dun_id = model.GetNextChallenge()
							if (next_dun_id > 0) {
								model.Fire(local_BaseDungeonModel.SCMD_REQUEST, 61001, next_dun_id)
							}
							this.Close()
							need_return = true
							break;

					}

					if (need_return) {
						return
					}

					this.Close()
					if (scene_mgr.IsDungeonScene() && model.IsInDunTypeScene(dun_type_)) {
						model.Fire(local_BaseDungeonModel.SCMD_REQUEST, 61002)
					}
				},
				this,
				true
			)
			Util.AddClickEvent(
				this._btn_left, () => {
					let info = model.GetDungeonResultInfo()
					if (dungeon_result_type_ == local_DungeonResultType.Sweeping) {
						this.Close()
						if (goods_model.GetTypeGoodsNum(local_BaseDungeonModel.SWEEPING_GOODS_ID) == 0) {
							if (model.material_auto_buy_state) {
								model.Fire(local_BaseDungeonModel.SCMD_REQUEST, 61022, info.dun_id, 1)
							} else {
								local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "DungeonMaterialAlertView", dun_type_, info.dun_id)
							}
							return
						}
						if (info) {
							model.Fire(local_BaseDungeonModel.SCMD_REQUEST, 61022, info.dun_id, 1)
						}
						return
					}

					switch (dun_type_) {
						case local_DUN_TYPE.Rune:
							if (scene_mgr.IsDungeonScene() && model.IsInDunTypeScene(dun_type_)) {
								model.Fire(local_BaseDungeonModel.SCMD_REQUEST, 61002)
							}
							if (!not_reopen_view) {
								setTimeout(() => {
									local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "DungeonEnterView", local_DungeonEnterView.Index.Rune)
								}, 1)
							}
							break
						case local_DUN_TYPE.Soul:
							// dungeon_soul_model.Fire(dungeonSoulModel.CONTINUE_SWEEP)
							break
						case local_DUN_TYPE.Material_Mount:
						case local_DUN_TYPE.Material_Partner:
						case local_DUN_TYPE.Material_WING:
						case local_DUN_TYPE.Material_Copper:
						case local_DUN_TYPE.NEW_AMULET:
						case local_DUN_TYPE.NEW_MOUNT:
						case local_DUN_TYPE.NEW_WEAPON:
						case local_DUN_TYPE.NEW_WING:
						case local_DUN_TYPE.NEW_BACK_ORNAMENT:
							if (info) {
								model.Fire(local_BaseDungeonModel.SCMD_REQUEST, 61001, info.dun_id)
							}
							break
						case local_DUN_TYPE.SentientAct:
							SentientActModel.GetInstance().Fire(SentientActEvent.FIND_WAY)
							break
						case local_DUN_TYPE.TOWER_LIMIT:
							if (scene_mgr.IsDungeonScene() && model.IsInDunTypeScene(dun_type_)) {
								model.Fire(local_BaseDungeonModel.SCMD_REQUEST, 61002)
							}
							OpenFun.OpenFunHandler(237)
							break
					}
					this.Close()
				},
				this,
				true
			)
			this.func_touch_treasure = () => {
				this.treasure_click = true
				this._img_box.visible = false
				this._gp_treasure.mouseEnabled = false
				this._gp_btns.visible = true
				let data = this.BindUpData()
				this.UpdateView(data)
			}
			Util.AddClickEvent(
				this._gp_treasure, () => {
					this.func_touch_treasure()
				},
				this,
				true
			)
			Util.AddClickEvent(
				this._gp_click, () => {
					if (dun_type_ == local_DUN_TYPE.Material_Copper && !this.treasure_click) {
						this.func_touch_treasure()
					} else if (dun_type_ == local_DUN_TYPE.AdvancedExp) {
						this.Close()
					}
				},
				this
			)
		}

		this.InitView = () => {
			let info = model.GetDungeonResultInfo()
			if (!info) {
				this.Close()
				return
			}
			dungeon_result_type_ = info.result_type
			dun_type_ = info.dun_type
			console.log("dungeon_result_type_____________", dungeon_result_type_, "___________________", dun_type_)

			switch (dungeon_result_type_) {
				case local_DungeonResultType.Default:
				case local_DungeonResultType.Sweeping:
				case local_DungeonResultType.Exp:
				case local_DungeonResultType.Soul:
				case local_DungeonResultType.AdvancedExp:
					break
				default:
					this.Close()
					break
			}

			let show_cfg = DungeonVictoryView.result_type_cfg[dungeon_result_type_]
			if (dun_type_ == local_DUN_TYPE.Equip) {
				// 寻装觅刃的由于奖励比较多，单独处理一下位置
				show_cfg._gp_fly = { visible: true, y: -400 }
			}
			for (let key in show_cfg) {
				let vo = show_cfg[key]
				if (vo) {
					for (let k in vo) {
						this[key][k] = vo[k]
					}
				} else {
					this[key].visible = false
				}
			}
			this.ShowNeedComponent()
			if (dun_type_ != local_DUN_TYPE.Material_Copper ||
				dun_type_ == local_DUN_TYPE.Material_Copper && info.result_type == local_DungeonResultType.Sweeping
			) {
				let data = this.BindUpData()
				this.UpdateView(data)
			}
			this.showEffect()
			this.showPoint()
		}

		this.ShowNeedComponent = () => {
			let cfg = []
			//区分结算类型
			switch (dungeon_result_type_) {
				case local_DungeonResultType.Default:
					cfg["_lb_left"] = { text: "继续挑战" }
					cfg["_lb_right"] = { text: "领取奖励" }
					if ((dun_type_ == local_DUN_TYPE.Vip_Rerson_Boss || dun_type_ == local_DUN_TYPE.MonsterInvasion) ||
						dun_type_ == local_DUN_TYPE.Marriage || dun_type_ == local_DUN_TYPE.New_Main_Line
					) {
						cfg["_btn_left"] = { visible: false }
						cfg["_btn_right"] = { centerX: 0 }
					} else if (dun_type_ == local_DUN_TYPE.TOWER_LIMIT) {
						cfg["_lb_left"] = { text: "退出" }
						cfg["_lb_right"] = { text: "继续挑战" }
						cfg["_btn_left"] = { centerX: -116 }
						cfg["_btn_right"] = { centerX: 116 }

						let next_dun_id = model.GetNextChallenge()
						if (next_dun_id == 0) {
							cfg["_btn_left"] = { centerX: 0 }
							cfg["_btn_right"] = { visible: false }
						}

					} else if (dun_type_ == local_DUN_TYPE.Tower || dun_type_ == local_DUN_TYPE.Rune) {

						cfg["_lb_left"] = { text: "完成" }
						cfg["_lb_right"] = { text: "继续挑战" }
						cfg["_btn_left"] = { centerX: -116 }
						cfg["_btn_right"] = { centerX: 116 }

						if (dun_type_ == local_DUN_TYPE.Rune) {
							if (model.GetRuneNowFloor() == 1) {	//符文引导要隐藏掉继续挑战的按钮
								cfg["_btn_right"] = { visible: false }
								cfg["_btn_left"] = { centerX: 0 }
							}
						}
						let dun_list = model.GetDungeonInfo(dun_type_)
						if (dun_list) {
							let all_floor = dun_list.length
							let cur_floor = 0
							for (let key in dun_list) {
								if (dun_list[key].permanent_count > 0) {
									cur_floor = Number(key) + 1
								}
							}

							let cur_data = dun_list[cur_floor]
							if (!cur_data) {
								cfg["_btn_left"] = { centerX: 0 }
								cfg["_btn_right"] = { visible: false }
							}
						}
					} else if (((dun_type_ == local_DUN_TYPE.Material_Mount || dun_type_ == local_DUN_TYPE.Material_Partner) ||
						dun_type_ == local_DUN_TYPE.Material_WING) ||
						dun_type_ == local_DUN_TYPE.Material_Copper
					) {
						let info = model.GetDungeonResultInfo()
						let [left_times, total_times] = model.GetDunLeftTime(dun_type_, info.dun_id)
						cfg["_btn_right"] = { centerX: 116 }
						if (!(left_times != 0)) {
							cfg["_btn_left"] = { visible: false }
							cfg["_btn_right"] = { centerX: 0 }

						}
					} else if (dun_type_ == local_DUN_TYPE.Unreal) {
						cfg["_btn_left"] = { visible: false }
						cfg["_gp_stars"] = { visible: true }
						let info = model.GetDungeonResultInfo()
						let level = model.unreal_level
						let i = 0
						if (level > 0) {
							do {
								if (level > i) {
									ResManager.GetInstance().SetImageSprite(this, this["img_img_star" + i], "common_asset", "uifb_hsfb_008a")
								} else {
									ResManager.GetInstance().SetImageSprite(this, this["img_img_star" + i], "common_asset", "uifb_hsfb_008b")
								}
								i = i + 1
							} while ((i < 3)
							)
						}

					} else if (dun_type_ == local_DUN_TYPE.Equip) {
						cfg["_btn_left"] = { visible: false }
						cfg["_btn_left"] = { visible: false }
						cfg["_btn_right"] = { centerX: 0 }
					} else if (dun_type_ == local_DUN_TYPE.Heart) {
						cfg["_btn_left"] = { visible: false }
						cfg["_lb_right"] = { text: "确定" }
						cfg["_gp_reward_con"] = { visible: false }
						cfg["_gp_tip_1"] = { visible: false }
					} else if (dun_type_ == local_DUN_TYPE.ReincarnationDun) {
						cfg["_btn_left"] = { visible: false }
						cfg["_lb_right"] = { text: "确定" }
						cfg["_btn_right"] = { centerX: 0 }
						cfg["_gp_reward_con"] = { visible: true }
						cfg["_gp_tip_1"] = { visible: true }
						// cfg["_img_reward_bg"] = { visible: false }
					} else if (dun_type_ == local_DUN_TYPE.Daily) {
						cfg["_btn_left"] = { visible: false }
						cfg["_lb_right"] = { text: "确定" }
						cfg["_btn_right"] = { visible: true }
						cfg["_btn_right"] = { centerX: 0 }
						cfg["_gp_reward_con"] = { visible: false }
						cfg["_gp_tip_1"] = { visible: false }
						// cfg["_img_bg"] = { visible: false }

					}
					break
				case local_DungeonResultType.Sweeping:
					// if (dun_type_ == local_DUN_TYPE.Pet ) {
					// 	this._gp_layer.visible = true 
					// 	let layer = Math.floor((model._dungeonPetRecordId - model.pet_dun_id - 1) / model.petSelectMax) * model.petSelectMax + 1

					// 	this._lb_layer.text = "1~" + layer + "层扫荡奖励（昨日最高记录点）"
					// 	SetAnchoredPosition(this._sc_reward,this._sc_reward.anchoredPosition.x,-70)
					// }
					// ResManager.GetInstance().SetOutsideImageSprite(this, this._img_reward_bg, GameResPath.GetIcon("common4", "uijs_038"))

					cfg["_lb_right"] = { text: "领取奖励" }
					let info = model.GetDungeonResultInfo()
					// let info = this.GetTestData()
					let [left_times, total_times] = model.GetDunLeftTime(dun_type_, info.dun_id)
					// if (info.dun_id && left_times ) {
					if (info.dun_id && (left_times != 0)) {
						cfg["_lb_left"] = { text: "继续扫荡" }

						cfg["_gp_cost_count"] = { visible: true }
						cfg["_btn_right"] = { centerX: 116 }
						ResManager.GetInstance().SetOutsideImageSprite(
							this,
							this._img_cost_icon,
							GameResPath.GetGoodsIconPath(String(local_BaseDungeonModel.SWEEPING_GOODS_ID))
						)
						this._lb_cost_count.text = "x" + goods_model.GetTypeGoodsNum(local_BaseDungeonModel.SWEEPING_GOODS_ID)
					} else {
						cfg["_btn_right"] = { centerX: 0 }
						cfg["_btn_left"] = { visible: false }
					}
					break
				case local_DungeonResultType.Exp:
					let reward_info = model.GetDungeonResultInfo()
					// let bool = reward_info.count > 1 && true || false
					// this.merge_num_img.visible = bool
					// if (reward_info.count > 1) {
					// 	ResManager.GetInstance().SetImageSprite(this, this.merge_num_img, "dungeonExp", "uipj_" + reward_info.count, true)
					// 	this.merge_num_img.x = -200
					// 	this.merge_num_img.y = this.merge_num_img.y
					// 	this.merge_num_img.scaleX = this.merge_num_img.scaleY = 4
					// }
					let bool = false
					let lv = 0
					let exp = 0
					for (let i in reward_info.ex_data) {
						let vo = reward_info.ex_data[i]
						if (vo.key == 10) {
							bool = Number(vo.val) == 1
						} else if (vo.key == 11) {
							lv = Number(vo.val)
						} else if (vo.key == 12) {
							exp = Number(vo.val)
						}
					}
					this.merge_num_img.visible = bool
					let str_lv = lv > 370 ? "神创" + Number(lv - 370) + "级" : lv + "级"
					let exp_str = Mathf.Floor(exp / 10) + "%"
					this.exp_old.innerHTML = str_lv + "&nbsp;&nbsp;<font color='#0a953e'>" + exp_str + "</font>"
					lv = RoleManager.GetInstance().GetMainRoleLevel()
					str_lv = lv > 370 ? "神创" + Number(lv - 370) + "级" : lv + "级"
					let main_role_vo = RoleManager.GetInstance().GetMainRoleVo()
					exp = main_role_vo.exp
					let exp_lim = main_role_vo.exp_lim
					// if (exp > exp_lim) {
					// 	exp = exp_lim
					// }
					let persent = Mathf.Floor(100 * exp / exp_lim)
					this.exp_new.innerHTML = str_lv + "&nbsp;&nbsp;<font color='#0a953e'>" + persent + "%</font>"

					cfg["_lb_right"] = { text: "确定" }
					cfg["_btn_right"] = { centerX: 0 }
					this._gp_tip_1.y = 494
					this._gp_btns.y = 694
					ResManager.GetInstance().SetImageSprite(this, this.img_title, "dungeonCommon", "ui_copy_87")
					break
				case local_DungeonResultType.Soul:
					let resultInfo = model.GetDungeonResultInfo()
					if (!resultInfo["isSweepSoul"]) {

						cfg["_btn_left"] = { visible: false }
					} else {
						cfg["_lb_left"] = { text: "继续扫荡" }
					}
					// ResManager.GetInstance().SetOutsideImageSprite(this, this._img_reward_bg, GameResPath.GetIcon("common4", "uijs_038"))

					cfg["_lb_left"] = { text: "确定" }
					break;
				case local_DungeonResultType.AdvancedExp:
					ResManager.GetInstance().SetImageSprite(this, this._gp_advanceExp_img1, "advancedexp_asset", "uigjjyfb_019", true)
					ResManager.GetInstance().SetImageSprite(this, this._gp_advanceExp_img2, "advancedexp_asset", "uigjjyfb_019", true)

					cfg["_gp_advanceExp"] = { visible: true }

					cfg["_lb_tips"] = { visible: true }

					cfg["_lb_left_time"] = { visible: false }
					let data = model.GetDungeonResultInfo()
					let advExpInfo = model.adExpPanelInfo
					// ResManager.GetInstance().SetOutsideImageSprite(this, this._img_reward_bg, GameResPath.GetIcon("dungeonMainLine", "uijs_076"))
					if (advExpInfo) {

						cfg["_img_top"] = { visible: advExpInfo.wave > advExpInfo.history_wave }
						// [ts2lua]lua中0和空字符串也是true，此处data.result == 1需要确认
						let wave = (data.result == 1 && (advExpInfo.wave) || (advExpInfo.wave - 1))
						this.levelLb.text = Util.StrToHTML("成功挑战:<font color='#62ff04'>" + wave + "关</font>")
						this.expLb.text =
							Util.StrToHTML("获得经验:<font color='#62ff04'>" + local_WordManager.ConvertNumWithWan(advExpInfo.exp) + "</font>")
					}
					break
			}

			for (let key in cfg) {
				let vo = cfg[key]
				if (vo) {
					for (let k in vo) {
						this[key][k] = vo[k]
					}
				}
				else
					this[key].visible = false
			}

			// //播放特效
			// switch (dungeon_result_type_) {
			// 	case local_DungeonResultType.Default:
			// 		this.AddUIEffect("UI_2104", this._gp_fly, null, null, false, {
			// 			load_call_back: () => {
			// 				// this.CoverEffect(this._gp_reward_con)
			// 			}
			// 		})
			// 		break
			// 	case local_DungeonResultType.Sweeping:
			// 		this.AddUIEffect("UI_2104", this._gp_fly, null, null, false, {
			// 			load_call_back: () => {
			// 				// this.CoverEffect(this._gp_reward_con)
			// 			}
			// 		})
			// 		break
			// 	case local_DungeonResultType.Exp:
			// 		this.AddUIEffect("UI_2104", this._gp_fly, null, null, false, {
			// 			load_call_back: () => {
			// 				// this.CoverEffect(this._gp_reward_con)
			// 			}
			// 		})
			// 		break
			// 	case local_DungeonResultType.AdvancedExp:
			// 		this.AddUIEffect("UI_2104", this._gp_fly, null, null, false, {
			// 			load_call_back: () => {
			// 				// this.CoverEffect(this._gp_reward_con)
			// 			}
			// 		})
			// 		break
			// 	case local_DungeonResultType.Soul:
			// 		this.AddUIEffect("UI_2104", this._gp_fly, null, null, false, {
			// 			load_call_back: () => {
			// 				// this.CoverEffect(this._gp_reward_con)
			// 			}
			// 		})
			// 		break
			// }
			this.ShowStoryArrow()
			this.SetWXShare()
		}

		this.ShowStoryArrow = () => {
			not_reopen_view = false
			if (dun_type_ == local_DUN_TYPE.Rune) {
				let step_cfg = null
				if (this._btn_left.visible && model.GetRuneNowFloor() == 1) {
					step_cfg = { direction: 8, text: "退出御魂塔，继续任务吧~", "effect_scaleX": 0.65, "effect_scaleY": 0.9, "off_y": 10 }
					not_reopen_view = true
					GlobalEventSystem.Fire(EventName.SHOW_FINGER, this, this._btn_left, this.layer_value, null, null, null, null, step_cfg, true)
				}
			} else if (dun_type_ == local_DUN_TYPE.Exp) {
				if (this.task_model.MainTaskIsExpDungeonTaskType()) {
					not_reopen_view = true
				}
			} else if (dun_type_ == local_DUN_TYPE.Equip) {
				if (this.task_model.MainTaskIsEquipDungeonTaskType()) {
					not_reopen_view = true
				}
			} else if (BaseDungeonModel.GetInstance().IsNewMateriaDungeon(dun_type_)) {
				if (this.task_model.MainTaskIsNewMaterialDunTaskType(dun_type_)) {
					not_reopen_view = true
				}
			}
		}

		this.BindUpData = () => {
			let reward_list = null
			let data = model.GetDungeonResultInfo()
			//let data = this.GetTestData()
			if (data) {
				switch (dungeon_result_type_) {
					case local_DungeonResultType.Default:
						reward_list = data.reward_list
						if(dun_type_ == local_DUN_TYPE.Rune){
							for(let vo of reward_list){
								vo.show_name = true
							}
						}
					case local_DungeonResultType.Sweeping:
						reward_list = data.reward_list
						break
					case local_DungeonResultType.Exp:
						let info = model.GetExpDungeonInfo()
						reward_list = info ? info.exp : 0
						break
					case local_DungeonResultType.AdvancedExp:
						reward_list = data.reward_list
						break
					case local_DungeonResultType.Soul:
						let SortFunc = (a, b) => {
							let AgoodsBasic = goods_model.GetGoodsBasicByTypeId(a.typeId)
							let BgoodsBasic = goods_model.GetGoodsBasicByTypeId(b.typeId)

							if (AgoodsBasic && BgoodsBasic) {
								if ((AgoodsBasic.subtype != 99 && BgoodsBasic.subtype != 99) || AgoodsBasic.subtype == 99 && BgoodsBasic.subtype == 99) {
									return BgoodsBasic.color - AgoodsBasic.color
								}
								if (AgoodsBasic.subtype == 99) {
									return 1
								} else if (BgoodsBasic.subtype == 99) {
									return -1
								}
							}
						}
						reward_list = data.reward_list
						reward_list.sort(SortFunc)
						break
				}
			}
			return { reward: reward_list }
		}

		this.UpdateView = (data?) => {
			if (dun_type_ == local_DUN_TYPE.Equip) {
				left_time_ = 10
			} else if (dun_type_ == local_DUN_TYPE.Rune) {
				left_time_ = 5
			} else if (dun_type_ == local_DUN_TYPE.Daily) {
				this._gp_reward_con.visible = false
				this._gp_tip_1.visible = false
				this._html_left_time.y = 727
			} else if (dun_type_ == local_DUN_TYPE.New_Main_Line) {
				left_time_ = model.mainline_dun_exit_time
			} else if (dun_type_ == local_DUN_TYPE.TOWER_LIMIT) {
				left_time_ = 10
			}
			end_time_ = local_TimeUtil.getServerTime() + left_time_
			let time_func = () => {
				let left_time = end_time_ - local_TimeUtil.getServerTime()
				if (left_time < 0) {
					if (dun_type_ != local_DUN_TYPE.Marriage) {
						this.CountDownFunc()
					}

					this.Close()
					return
				}
				this._html_left_time.style.fontSize = 22
				this._html_left_time.style.align = "center"
				this._html_left_time.style.color = "#ffffff"
				this._html_left_time.style.width = 720
				this._html_left_time.innerHTML = this.FomatCountTimeTips(Util.HtmlColorTxt(left_time, "'#00ed2d'"))
				this.CallLater(() => {
					this._html_left_time.x = Math.abs(720 - this._html_left_time.width) / 2
					if (!this._html_left_time.visible) {
						this._html_left_time.visible = true
					}
				})
			}
			if (dun_type_ != local_DUN_TYPE.ReincarnationDun) {
				this._img_reward_bg.visible = true
			}
			this._img_equip_reward_bg.visible = false
			this._sc_reward.visible = true
			this._sc_equip_reward.visible = false
			this._sc_equip_other_reward.visible = this._gp_equip_tips.visible = false
			this._sc_reward.y = 0

			switch (dungeon_result_type_) {
				case local_DungeonResultType.Default:
					if (dun_type_ == local_DUN_TYPE.Rune || dun_type_ == local_DUN_TYPE.Tower) {
						let dun_list = model.GetDungeonInfo(dun_type_)
						if (dun_list) {
							let all_floor = dun_list.length
							let cur_floor = 0
							for (let key in dun_list) {
								if (dun_list[key].permanent_count > 0) {
									cur_floor = Number(key) + 1
								}
							}
							let cur_data = dun_list[cur_floor]
							if (cur_data) {
								if (cur_data.dun_id != 12002) {
									count_down_func_ = () => {
										let fighting = role_mgr.GetMainRoleVo().fighting
										if (cur_data && fighting >= cur_data.recommend_power * local_BaseDungeonModel.Recommend_Power_Module) {
											model.Fire(local_BaseDungeonModel.SCMD_REQUEST, 61001, cur_data.dun_id)
										} else {
											model.Fire(local_BaseDungeonModel.SCMD_REQUEST, 61002)
										}
									}
								}
							}
						}
					}
					this.StartTime(time_func)
					break
				case local_DungeonResultType.Sweeping:
					this.StartTime(time_func)
					break
				case local_DungeonResultType.Exp:
					end_time_ = local_TimeUtil.getServerTime() + 10
					this.ShowExpAni(data.reward)
					this.StartTime(time_func)
					break
				case local_DungeonResultType.AdvancedExp:
					end_time_ = local_TimeUtil.getServerTime() + 10
					this.StartTime(time_func)
					break
				case local_DungeonResultType.Soul:
					end_time_ = local_TimeUtil.getServerTime() + 10
					this.StartTime(time_func)
					break
			}

			if (this.use_delete_method) {
				return
			}

			
			if (data && data.reward && typeof (data.reward) == "object" && data.reward.length > 0) {//|| dungeon_result_type_ == local_DungeonResultType.Soul
				
				
				if(dun_type_ == local_DUN_TYPE.Equip){
					// 寻装觅刃掉落不同布局
					this._sc_reward.visible = false
					this._sc_equip_reward.visible = true

					this._img_reward_bg.visible = false
					this._img_equip_reward_bg.visible = true
					this._gp_tip_1.y = 468
					this._gp_btns.y = 788
					this._img_bg.height = 466
					this._html_left_time.y = 876

					let list = []
					let other_list

					for(let vo of data.reward){
						if(vo.reward_type == 0){
							list.push(vo)
						}else{
							if(!other_list){
								other_list = []
							}
							other_list.push(vo)
						}
					}
					// other_list = list

					if (!this.equip_reward_loop_mgr) {
						this.equip_reward_loop_mgr = new LoopScrowViewMgr(this.layer_value)
						this.equip_reward_loop_mgr.SetData(this._sc_equip_reward, CommonRewardItem, list, LoopScrCon.Vertical)
					} else {
						this.equip_reward_loop_mgr.replaceAll(list)
					}

					if(other_list){
						this._sc_equip_other_reward.visible = this._gp_equip_tips.visible = true
						this._img_bg.y = 150
						this._img_bg2.y = 217
						this._gp_reward_con.y = 414
						this._gp_tip_1.y = 318
						this._gp_btns.y = 920
						this._html_left_time.y = 1000
						
						this._img_bg.height = 760


						if (!this.equip_other_reward_loop_mgr) {
							this.equip_other_reward_loop_mgr = new LoopScrowViewMgr(this.layer_value)
							this.equip_other_reward_loop_mgr.SetData(this._sc_equip_other_reward, CommonRewardItem, other_list, LoopScrCon.Vertical)
						} else {
							this.equip_other_reward_loop_mgr.replaceAll(other_list)
						}
					}
				} else {
					let len = data.reward.length
					let index = Math.ceil(len / 5)
					if (len > 5) len = 5
					this._sc_reward.width = 101 * len
					this._sc_reward.y = index >= 2 ? 0 : 44
					if (index > 3) {
						index = 3
					}
					if (index == 0) {
						index = 1
					}

					if (dungeon_result_type_ == local_DungeonResultType.Sweeping && dun_type_ == local_DUN_TYPE.Pet) {
						this._gp_reward_con.height = index * 108 + (index - 1) * 13 + 32 + 20 + 40
					} else if (dungeon_result_type_ == local_DungeonResultType.AdvancedExp) {
						this._gp_reward_con.height = index * 108 + (index - 1) * 13 + 32 + 20 + 100
					}


					if (dun_type_ == local_DUN_TYPE.Marriage) {
						let col = Mathf.Ceil(data.reward.length / 5)
						let is_muilt = col >= 2 ? true : false
						if (this._img_reward_bg.visible) {
							this._img_reward_bg.height = is_muilt ? 190 : 105;
						}
						this._sc_reward.height = is_muilt ? col * 86 : 86
						this._sc_reward.y = 10
					} else if (dun_type_ == local_DUN_TYPE.SentientAct) {
						this._sc_reward.height = 170
					} else if (dun_type_ == local_DUN_TYPE.Rune) {
						let height = index * 86 + index * 30
						if(height > 242){
							height = 242
						}
						this._sc_reward.height = height
						this._sc_reward.spaceY = 30
	
						let bg_start_y = 445
						let bg_height = 319
						let tips_height = 64
	
						let total_height = tips_height + height + 10
						let start_y = (bg_height - total_height) / 2
	
						this._gp_tip_1.y = bg_start_y + start_y + 30
	
						this._gp_reward_con.y = bg_start_y + start_y + tips_height + 3
	
					} else {
						this._sc_reward.height = index * 101
					}
	
					if (!this.loop_mgr) {
						this.loop_mgr = new LoopScrowViewMgr()
						this.loop_mgr.SetData(this._sc_reward, CommonRewardItem, data.reward, LoopScrCon.Vertical)
					} else {
						this.loop_mgr.replaceAll(data.reward)
					}
				}
			}
		}

		this.showEffect = () => {
			let info = model.GetDungeonResultInfo()
			switch (dun_type_) {
				case local_DUN_TYPE.Material_Copper:
					if (info.result_type == local_DungeonResultType.Sweeping) {
						this.treasure_click = true
						return
					}
					this._gp_copper_level_effect.visible = true
					ResManager.GetInstance().SetImageSprite(this, this._img_bg3, "dungeonMaterial", "uijs_039", true)
					ResManager.GetInstance().SetImageSprite(this, this._img_level, "dungeonMaterial", model.CopperLevelImgUrl())
					this._img_point.x = 530
					//test
					// ResManager.GetInstance().SetImageSprite(this, this._img_level, "dungeonMaterial_asset", "uijs_044.png")

					// Laya.Tween.get(this._gp_copper_level_effect).to(
					// 	{x = 40, y = 500, scaleX = 1, scaleY = 1},
					// 	200,
					// 	Laya.Ease.circIn
					// )
					table.insert(this.anim_list, SYTweenLite.to(this, this._gp_copper_level_effect, SYTweenLite.UiAnimationType.ANCHORED_POS, new Vector2(420, 476), 0.2, null, SYTweenFunc.EASE_IN, false))
					table.insert(this.anim_list, SYTweenLite.to(this, this._gp_copper_level_effect, SYTweenLite.UiAnimationType.SCALE, Vector3.one, 0.2, null, SYTweenFunc.EASE_IN, false))

					this._gp_btns.visible = false
					this._gp_treasure.visible = true
					ResManager.GetInstance().SetImageSprite(this, this._img_box, "dungeonMaterial_asset", "box_" + (model.copperGrade || 0))
					//test
					// ResManager.GetInstance().SetImageSprite(this, this._img_box, "dungeonMaterial_asset", "box_1")

					// Laya.Tween.get(this._img_box, {loop = true}):to({rotation = 15}, 100, Laya.Ease.circIn).to(
					// 	{rotation = 0},
					// 	100,
					// 	Laya.Ease.circIn
					// ):to({rotation = -15}, 100, Laya.Ease.circIn):to({rotation = 0}, 100, Laya.Ease.circIn):call(onTime)

					let runAni1, runAni2, runAni3, runAni4
					let onTime
					runAni1 = () => {
						table.insert(this.anim_list, SYTweenLite.to(this, this._img_box, SYTweenLite.UiAnimationType.ROTATION, 15, 0.1, runAni2, SYTweenFunc.EASE_IN, false))
					}
					runAni2 = () => {
						table.insert(this.anim_list, SYTweenLite.to(this, this._img_box, SYTweenLite.UiAnimationType.ROTATION, 0, 0.1, runAni3, SYTweenFunc.EASE_IN, false))
					}
					runAni3 = () => {
						table.insert(this.anim_list, SYTweenLite.to(this, this._img_box, SYTweenLite.UiAnimationType.ROTATION, -15, 0.1, runAni4, SYTweenFunc.EASE_IN, false))
					}
					runAni4 = () => {
						table.insert(this.anim_list, SYTweenLite.to(this, this._img_box, SYTweenLite.UiAnimationType.ROTATION, 0, 0.1, onTime, SYTweenFunc.EASE_IN, false))
					}

					let time = 10
					onTime = () => {
						time = time - 1
						if ((time <= 0 && this._gp_treasure) && !this.treasure_click) {
							// this._gp_treasure.dispatchEventWith(Laya.TouchEvent.TOUCH_TAP)
							this.func_touch_treasure()
						} else {
							runAni1()
						}
					}
					runAni1()
					break
				case local_DUN_TYPE.Soul:
					// let data = model.GetDungeonResultInfo()
					// let soul_dungeon_reward_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_soul_dungeon_reward", false)
					// if (data.ex_data && data.ex_data[0] ) {
					// 	let has_kill = data.ex_data[0].val
					// 	this._lb_kill.textFlow = Util.StrToHTML("本次通关波数:<font color=0xffef67>" + has_kill + "波</font>")
					// 	let rank = dungeon_soul_model.SetScoreRank(has_kill, soul_dungeon_reward_cfg)
					// 	ResManager.GetInstance().SetImageSprite(this, this._img_bg, "dungeonMaterial_asset", "uijs_039", true)
					// 	let end_point = this._gp_reward_con.localToGlobal(40, -70)
					// 	Laya.Tween.get(this._gp_copper_level_effect).to(
					// 		{x = end_point.x, y = end_point.y, scaleX = 1, scaleY = 1},
					// 		200,
					// 		Laya.Ease.circIn
					// 	)
					// 	let source = this.GetRankImage(rank)
					// 	ResManager.GetInstance().SetImageSprite(this, this._img_level, "dungeonCommon_asset", source, true)
					// 	this._gp_copper_level_effect.visible = true
					// }
					break
				case local_DUN_TYPE.AdvancedExp:
					if (this._img_top.visible) {
						Laya.Tween.to(this._img_top, { x: 536, y: 557, scaleX: 1, scaleY: 1 }, 300, Laya.Ease.circIn, Laya.Handler.create(this, () => {
							if (this.use_delete_method) {
								return
							}
							this._img_top.x = 506
							this._img_top.y = 487
							this._img_top.scaleX = 1
							this._img_top.scaleY = 1
						}
						))
					}
					break;
				case local_DUN_TYPE.Exp:
				// if (this.merge_num_img.visible) {
				// 	table.insert(this.anim_list,
				// 		SYTweenLite.to(this,
				// 			this.merge_num_img,
				// 			SYTweenLite.UiAnimationType.POSX,
				// 			150,
				// 			0.3,
				// 			null,
				// 			SYTweenFunc.EASE_IN,
				// 			false))

				// 	table.insert(this.anim_list,
				// 		SYTweenLite.to(this,
				// 			this.merge_num_img,
				// 			SYTweenLite.UiAnimationType.SCALE,
				// 			new Vector3(1, 1, 1),
				// 			0.3,
				// 			null,
				// 			SYTweenFunc.EASE_IN,
				// 			false))
				// }
				// break;
			}
		}

		this.showPoint = () => {
			if (!this._img_point || dun_type_ == local_DUN_TYPE.Exp) {
				return
			}
			let type = local_BaseDungeonModel.MORE_ACTIVITY
			let dun_type = dun_type_
			let point = model.getPoint(dun_type)
			let img_url = "uipj_047"
			if (point == 2) {
				img_url = "uipj_046"
			} else if (point == 1.15) {
				img_url = "uipj_049"
			}
			this._img_point.visible = point > 0
			if (this._img_point && this._img_point.visible) {

				ResManager.GetInstance().SetImageSprite(this, this._img_point, "dungeonCommon", img_url, true)
			}
		}

		this.StartTime = (time_func?) => {
			this.CancelTime()
			time_id_ = GlobalTimerQuest.AddPeriodQuest(time_func, 1)
			time_func()
		}

		this.ShowExpAni = (now_exp?) => {
			now_exp_ = now_exp
			now_count_ = 0
			if (!update_id_) {
				update_id_ = Runner.GetInstance().AddRunObj(this)
			}
		}

		this.Update = (now_time?, elapse_time?) => {
			if (this._lb_get_exp) {
				now_count_ = now_count_ + 1
				if (now_count_ == max_count_) {
					this._lb_get_exp.text = `${local_WordManager.ConvertNumWithWan(now_exp_)}`//Util.StrToHTML("获得经验：" + Util.HtmlColorTxt(local_WordManager.ConvertNumWithWan(now_exp_), "#fff83d"))
				} else if (now_count_ < max_count_) {
					this._lb_get_exp.text = `${local_WordManager.ConvertNumWithWan(now_exp_ / max_count_ * now_count_)}`
					// Util.StrToHTML(
					// 	"获得经验：" + Util.HtmlColorTxt(local_WordManager.ConvertNumWithWan(now_exp_ / max_count_ * now_count_), "#fff83d")
					// )
				} else if (now_count_ > max_count_) {
					if (update_id_) {
						Runner.GetInstance().RemoveRunObj(update_id_)
						update_id_ = null
					}
				}
			}
		}

		this.CancelTime = () => {
			if (time_id_) {
				GlobalTimerQuest.CancelQuest(time_id_)
				time_id_ = null
			}
		}

		this.GetRankImage = (rank?) => {
			let str = "uipj_043"
			if (rank == 0) {
				str = "uipj_043"
			} else if (rank == 1) {
				str = "uipj_042"
			} else if (rank == 2) {
				str = "uijs_041"
			} else if (rank == 3) {
				str = "uijs_040"
			} else if (rank == 4) {
				str = "uijs_044"
			} else if (rank == 5) {
				str = "uipj_044"
			} else if (rank == 6) {
				str = "uipj_045"
			}
			return str
		}

		this.Remove = () => {

			if (voice) {
				SoundManager.GetInstance().StopSoundEffect(voice)
				voice = null
			}


			if (update_id_) {
				Runner.GetInstance().RemoveRunObj(update_id_)
				update_id_ = null
			}
			this.CancelTime()
			count_down_func_ = null
			model.SetDungeonResultInfo(null)
			model.SetDungeonMonsterDeadPos(null)
			if (this._img_box) {
				if (dun_type_ == local_DUN_TYPE.Material_Copper) {
					this.treasure_click = false
				}
				if (dun_type_ == local_DUN_TYPE.Soul) {
				}
				if (dun_type_ == local_DUN_TYPE.Exp) {
				}
				if (this.anim_list && this.anim_list.length > 0) {
					for (let i = 0; i < this.anim_list.length; i++) {
						var v = this.anim_list[i]
						SYTweenLite.Stop(v)
					}
					this.anim_list = []
				}
			}
			left_time_ = 15
			if (wx_share_tips_) {
				wx_share_tips_.DeleteMe()
				wx_share_tips_ = null
			}
			if (this.loop_mgr) {
				this.loop_mgr.DeleteMe()
				this.loop_mgr = null
			}

			if (this.equip_reward_loop_mgr) {
				this.equip_reward_loop_mgr.DeleteMe()
				this.equip_reward_loop_mgr = null
			}

			if (this.equip_other_reward_loop_mgr) {
				this.equip_other_reward_loop_mgr.DeleteMe()
				this.equip_other_reward_loop_mgr = null
			}

			if (this.anim_list && this.anim_list.length > 0) {
				for (let i = 0; i < this.anim_list.length; i++) {
					var v = this.anim_list[i]
					SYTweenLite.Stop(v)
				}
				this.anim_list = []
			}
			if (this._btn_left) {
				GlobalEventSystem.Fire(EventName.HIDE_FINGER, this._btn_left)
			}
		}

		this.CountDownFunc = () => {
			if (count_down_func_) {
				count_down_func_()
			} else if (scene_mgr.IsDungeonScene() && model.IsInDunTypeScene(dun_type_)) {
				model.Fire(local_BaseDungeonModel.SCMD_REQUEST, 61002)
			}
		}

		this.FomatCountTimeTips = (str?) => {
			if (dun_type_ == local_DUN_TYPE.Rune || dun_type_ == local_DUN_TYPE.Tower) {
				let dun_list = model.GetDungeonInfo(dun_type_)
				if (dun_list) {
					let all_floor = dun_list.length
					let cur_floor = 0
					for (let key in dun_list) {

						// [ts2lua]dun_list下标访问可能不正确
						if (dun_list[key].permanent_count > 0) {
							cur_floor = Number(key) + 1
						}
					}
					// [ts2lua]dun_list下标访问可能不正确
					let cur_data = dun_list[cur_floor]
					let fighting = role_mgr.GetMainRoleVo().fighting
					if (cur_data && cur_data.recommend_power && fighting >= cur_data.recommend_power * local_BaseDungeonModel.Recommend_Power_Module) {
						if (PlatformManager.IsEyouIdnPlatform()) {
							str = "Lanjut tantang setelah hitungan " + str + " detik"
						} else {
							str = str + "秒后继续挑战"
						}
					} else {
						str = str + "秒后自动退出"
					}
				}
			} else {
				str = str + "秒后自动退出"
			}
			return str
		}

		this.SetWXShare = () => {
			//if (! scene_mgr.IsReincarnationDungeon() ) {
			//let call_back = (show?) => {
			//this.wx_share_con.visible = show
			//if (this.wx_share_con.visible ) {
			//if (! wx_share_tips_ ) {
			//wx_share_tips_ =  new WXShareTips(this.wx_share_con)
			//wx_share_tips_:Load()
			//}
			//}
			//}

			//friend_invite_model:ShowWXShare(call_back)
			//}
		}
	}

	//测试数据
	public GetTestData() {

		let td
		td = {}
		td.count = 1
		td.dun_id = 13001
		td.dun_type = 13
		td.ex_data = [{ key: 9, value: 0 }]
		td.grade = 3
		td.other_reward = [{
			reward_type: 1,
			other_reward_list: [
				{
					count1: 5,
					goods_id1: 0,
					style1: 0,
					type_id1: 23020001
				},
				{
					count1: 1,
					goods_id1: 0,
					style1: 0,
					type_id1: 38100002
				},
				{
					count1: 50000,
					goods_id1: 0,
					style1: 3,
					type_id1: 0
				}
			]
		}]
		td.result = 1
		td.result_subtype = 0
		td.result_type = 0
		td.scene_id = 2028
		td.reward_list = [
			// {
			// 	reward_type: 0,
			// 	size: 85,
			// 	vo: { style: 0, typeId: 23020001, count: 5, goods_id: 0 }
			// },
			// {
			// 	reward_type: 0,
			// 	size: 85,
			// 	vo: { style: 0, typeId: 38100002, count: 1, goods_id: 0 }
			// },
			// {
			// 	reward_type: 0,
			// 	size: 85,
			// 	vo: { style: 3, typeId: 0, count: 50000, goods_id: 0 }
			// },

			// {
			// 	reward_type: 0,
			// 	size: 85,
			// 	vo: { style: 0, typeId: 23020001, count: 5, goods_id: 0 }
			// },
			// {
			// 	reward_type: 0,
			// 	size: 85,
			// 	vo: { style: 0, typeId: 38100002, count: 1, goods_id: 0 }
			// },
			{
				reward_type: 0,
				size: 85,
				vo: { style: 3, typeId: 0, count: 50000, goods_id: 0 }
			},
			{
				reward_type: 0,
				size: 85,
				vo: { style: 0, typeId: 23020001, count: 5, goods_id: 0 }
			},
			{
				reward_type: 0,
				size: 85,
				vo: { style: 0, typeId: 38100002, count: 1, goods_id: 0 }
			},
			{
				reward_type: 0,
				size: 85,
				vo: { style: 3, typeId: 0, count: 50000, goods_id: 0 }
			},
			{
				reward_type: 1,
				size: 85,
				vo: { style: 0, typeId: 23020001, count: 5, goods_id: 0 }
			},
			{
				reward_type: 1,
				size: 85,
				vo: { style: 0, typeId: 38100002, count: 1, goods_id: 0 }
			},
			{
				reward_type: 1,
				size: 85,
				vo: { style: 3, typeId: 0, count: 50000, goods_id: 0 }
			}
		]

		return td
	}

	_gp_click: Laya.Box
	_img_bg: Laya.Image
	_img_bg2: Laya.Image
	btn_group: Laya.Box
	left_btn_group: Laya.Box
	right_btn_group: Laya.Box
	_gp_cost_count: Laya.HBox
	_img_cost_icon: Laya.Image
	_lb_cost_count: Laya.Label
	_gp_victory: Laya.Box
	_html_left_time: Laya.HTMLDivElement
	_gp_fly: Laya.Box
	_gp_get_exp: Laya.Box
	_lb_get_exp: Laya.Label
	merge_num_img: Laya.Image
	gp_lv: Laya.Image
	img_arrow: Laya.Image
	exp_old: Laya.HTMLDivElement
	exp_new: Laya.HTMLDivElement
	_gp_reward_con: Laya.Box
	_img_reward_bg: Laya.Image
	_img_equip_reward_bg: Laya.Image
	_sc_reward: Laya.List
	_lb_noreward: Laya.Label
	_gp_layer: Laya.Box
	_Image11: Laya.Image
	_lb_layer: Laya.Label
	_gp_advanceExp: Laya.Box
	_Group1: Laya.HBox
	_gp_advanceExp_img1: Laya.Image
	levelLb: Laya.Label
	_Group2: Laya.HBox
	_gp_advanceExp_img2: Laya.Image
	expLb: Laya.Label
	_sc_equip_reward: Laya.List
	_gp_equip_tips: Laya.Box
	_sc_equip_other_reward: Laya.List
	_gp_tip_1: Laya.Box
	_Image2: Laya.Image
	img_title: Laya.Image
	_gp_kill: Laya.Box
	_lb_kill: Laya.Label
	_gp_copper_level_effect: Laya.Box
	_img_bg3: Laya.Image
	_img_level: Laya.Image
	_gp_treasure: Laya.Box
	_img_box: Laya.Image
	_gp_treasure_effect: Laya.Box
	_gp_stars: Laya.Box
	_img_star0: Laya.Image
	_img_star1: Laya.Image
	_img_star2: Laya.Image
	_gp_btns: Laya.Box
	_btn_left: Laya.Box
	_Image1: Laya.Image
	_lb_left: Laya.Label
	_btn_right: Laya.Box
	_Image111: Laya.Image
	_lb_right: Laya.Label
	_img_point: Laya.Image
	_lb_tips: Laya.Label
	_img_top: Laya.Image
	wx_share_con: Laya.Box
	public GetComponents() {
		[
			this._gp_click,
			this._img_bg,
			this._img_bg2,
			this.btn_group,
			this.left_btn_group,
			this.right_btn_group,
			this._gp_cost_count,
			this._img_cost_icon,
			this._lb_cost_count,
			this._gp_victory,
			this._html_left_time,
			this._gp_fly,
			this._gp_get_exp,
			this._lb_get_exp,
			this.merge_num_img,
			this.gp_lv,
			this.img_arrow,
			this.exp_old,
			this.exp_new,
			this._gp_reward_con,
			this._img_reward_bg,
			this._img_equip_reward_bg,
			this._sc_reward,
			this._lb_noreward,
			this._gp_layer,
			this._Image11,
			this._lb_layer,
			this._gp_advanceExp,
			this._Group1,
			this._gp_advanceExp_img1,
			this.levelLb,
			this._Group2,
			this._gp_advanceExp_img2,
			this.expLb,
			this._sc_equip_reward,
			this._gp_equip_tips,
			this._sc_equip_other_reward,
			this._gp_tip_1,
			this._Image2,
			this.img_title,
			this._gp_kill,
			this._lb_kill,
			this._gp_copper_level_effect,
			this._img_bg3,
			this._img_level,
			this._gp_treasure,
			this._img_box,
			this._gp_treasure_effect,
			this._gp_stars,
			this._img_star0,
			this._img_star1,
			this._img_star2,
			this._gp_btns,
			this._btn_left,
			this._Image1,
			this._lb_left,
			this._btn_right,
			this._Image111,
			this._lb_right,
			this._img_point,
			this._lb_tips,
			this._img_top,
			this.wx_share_con,
		]
			= this.GetChildrenByNames([

				"_gp_click",
				"_img_bg",
				"_img_bg2",
				"btn_group",
				"left_btn_group",
				"right_btn_group",
				"_gp_cost_count",
				"_img_cost_icon",
				"_lb_cost_count",
				"_gp_victory",
				"_html_left_time",
				"_gp_fly",
				"_gp_get_exp",
				"_lb_get_exp",
				"merge_num_img",
				"gp_lv",
				"img_arrow",
				"exp_old",
				"exp_new",
				"_gp_reward_con",
				"_img_reward_bg",
				"_img_equip_reward_bg",
				"_sc_reward",
				"_lb_noreward",
				"_gp_layer",
				"_Image11",
				"_lb_layer",
				"_gp_advanceExp",
				"_Group1",
				"_gp_advanceExp_img1",
				"levelLb",
				"_Group2",
				"_gp_advanceExp_img2",
				"expLb",
				"_sc_equip_reward",
				"_gp_equip_tips",
				"_sc_equip_other_reward",
				"_gp_tip_1",
				"_Image2",
				"img_title",
				"_gp_kill",
				"_lb_kill",
				"_gp_copper_level_effect",
				"_img_bg3",
				"_img_level",
				"_gp_treasure",
				"_img_box",
				"_gp_treasure_effect",
				"_gp_stars",
				"_img_star0",
				"_img_star1",
				"_img_star2",
				"_gp_btns",
				"_btn_left",
				"_Image1",
				"_lb_left",
				"_btn_right",
				"_Image111",
				"_lb_right",
				"_img_point",
				"_lb_tips",
				"_img_top",
				"wx_share_con",
			])
	}
}
window["DungeonVictoryView"] = DungeonVictoryView
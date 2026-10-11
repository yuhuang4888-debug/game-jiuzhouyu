
import { Alert, Alert_Type } from "../alert/Alert"
import { BaseClass } from "../common/BaseClass"
import { BaseController } from "../common/BaseController"
import { GoodsType } from "../common/CommonGoodsListVo"
import { Config } from "../common/Config"
import { EventName, ObjectEventType, SceneEventType } from "../common/EventName"
import { Enum_UILayer, LayerManager } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { ViewManager } from "../common/ViewManager"
import { BaseDungeonModel, DungeonEnterViewIndex, DungeonResultType, DUN_TYPE } from "../commonModel/BaseDungeonModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { MainUIModel } from "../commonModel/MainUIModel"
import { TaskModel } from "../commonModel/TaskModel"
import { RoleManager } from "../commonModel/RoleManager"
import { SceneManager } from "../scene/SceneManager"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { SkillVo } from "../skill/SkillVo"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { GameMath } from "../util/GameMath"
import { SYTweenLite } from "../util/SYTweenLite"
import { LoadLuaConfigAB, Util } from "../util/Util"
import { MainUIController } from "../commonController/MainUIController"
import { FindVo } from "../scene/sceneobj/FindVo"
import { Scene } from "../scene/Scene"
import { VipModel } from "../commonModel/VipModel"

import "../dungeon/DungeonEnterView"
import "../dungeon/DungeonFightSceneView"
import "../dungeon/DungeonFailureView"
import "../dungeon/DungeonVictoryView"
import "../dungeon/DungeonBuyTimeView"
import "../dungeonPartner/DungeonPartnerResultView"
import "../dungeonMaterial/DungeonMaterialAlertView"
import "../dungeonHeart/DungeonHeartEnterView"
import "../dungeonHeart/DungeonHeartFightSceneItem"
import "../dungeonRein/DungeonReinItem"
import "../dungeonPolar/DungeonPolarRequest"
import "../dungeon/DungeonResultEffectView"
import "../dungeonTower/DungeonTowerBaseView"
import "../dungeonTower/DungeonTowerView"
import "../dungeonMaterial/DungeonMaterialNewResultView"
import "../dungeonRune/DungeonRuneDailyRewardView"

import { TeamModel, TeamEvent } from "../commonModel/TeamModel"
import { MarriageDefine } from "../commonModel/MarriageModel"
import { DungeonDragonTipsItem } from "../dungeonDragon/DungeonDragonTipsItem"
import { kfSingleRankModel } from "../commonModel/kfSingleRankModel"
import { FunctionOpenEvent, FunctionOpenModel } from "../commonModel/FunctionOpenModel"
import { FunctionOpenAutoView } from "../funcOpen/FunctionOpenAutoView"
import { CommonManager } from "../common/CommonManager"
import { BossModel } from "../commonModel/BossModel"
import "../dungeonExp/DoubleExpTipView"
import { UIEffect } from "../common/UIEffect"
import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { AutoFightManager } from "../autofight/AutoFightManager"
import "../dungeon/DungeonFightSceneMaskView"
import { SentientActModel } from "../commonModel/SentientActModel"
import { table } from "../common/table"
import { AutoBrushModel } from "../commonModel/AutoBrushModel"
import { TimeUtil } from "../util/TimeUtil"

export class BaseDungeonController extends BaseController {
	ShowBossBornEffect
	ChangeScene
	EnterSceneHandle
	ExitSceneHandle
	Init
	RefreshRed
	SetMainUIVisible
	cur_find_id
	delay_find_way
	dungeon_scene_is_loaded
	last_find_x
	last_find_y



	static Instance
	public constructor() {
		super()
		BaseDungeonController.Instance = this
		let local_BaseDungeonModel_Instance = BaseDungeonModel.GetInstance()
		let local_BaseDungeonModel = BaseDungeonModel
		let local_DUN_TYPE = DUN_TYPE
		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName

		let local_SceneManager_Instance = SceneManager.GetInstance()
		let local_SceneManager = SceneManager

		// let local_CameraManager_Instance = CameraManager.GetInstance()
		let local_ObjectEventType = ObjectEventType
		let local_SceneEventType = SceneEventType

		let local_Config = Config

		// let local_MonsterInvasionModel_Instance = MonsterInvasionModel.GetInstance()
		// let local_MonsterInvasionModel = MonsterInvasionModel
		let local_ServerTimeModel = ServerTimeModel
		let local_Alert = Alert

		let local_TaskModel_Instance = TaskModel.GetInstance()
		let local_RoleManager_Instance = RoleManager.GetInstance()
		let local_VipModel_Instance = VipModel.GetInstance()
		let local_LayerManager_Instance = LayerManager.GetInstance()

		let local_UserMsgAdapter_Instance = UserMsgAdapter.GetInstance()
		let local_GoodsModel_Instance = GoodsModel.GetInstance()
		let local_DungeonResultType = DungeonResultType
		let local_Message = Message
		let local_ViewManager_Instance = ViewManager.GetInstance()
		let local_MarriageDefine = MarriageDefine
		let local_BossBaseModel_Instance = BossModel.GetInstance()

		let local_MainUIModel_Instance = MainUIModel.GetInstance()
		let show_born_effect_dic_

		let monster_reward_ = null
		let monster_view_ = null
		let invite_view_list_ = null
		let is_open_mask_ = false


		this.Init = () => {
			//初始化
			let InitDunData = (dun_type) => {
				switch (dun_type) {
					case local_DUN_TYPE.Rune:
						local_BaseDungeonModel_Instance.Fire(local_BaseDungeonModel.SCMD_REQUEST, 61113, dun_type)
						local_BaseDungeonModel_Instance.Fire(local_BaseDungeonModel.SCMD_REQUEST, 61020, dun_type)
						local_BaseDungeonModel_Instance.Fire(local_BaseDungeonModel.SCMD_REQUEST, 61115)
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
					case local_DUN_TYPE.Exp:
					case local_DUN_TYPE.Vip_Rerson_Boss:
					case local_DUN_TYPE.Equip:
					case local_DUN_TYPE.Unreal:
					case local_DUN_TYPE.Marriage:
					case local_DUN_TYPE.AdvancedExp:
					case local_DUN_TYPE.SingleRank:
					case local_DUN_TYPE.Dragon:
					case local_DUN_TYPE.SentientAct:
						local_BaseDungeonModel_Instance.Fire(local_BaseDungeonModel.SCMD_REQUEST, 61020, dun_type)
						break
					// case local_DUN_TYPE.Soul:
					// 	local_BaseDungeonModel_Instance.Fire(local_BaseDungeonModel.SCMD_REQUEST, 61020, dun_type)
					// 	local_BaseDungeonModel_Instance.Fire(local_BaseDungeonModel.SCMD_REQUEST, 21509)
					// 	break
					case local_DUN_TYPE.Heart:
						local_BaseDungeonModel_Instance.Fire(local_BaseDungeonModel.SCMD_REQUEST, 61020, dun_type)
						local_BaseDungeonModel_Instance.Fire(local_BaseDungeonModel.SCMD_REQUEST, 61101)
						break
				}
			}

			let init_data_dun_type_list = [
				local_DUN_TYPE.Rune,
				local_DUN_TYPE.Material_Mount,
				local_DUN_TYPE.Material_Partner,
				local_DUN_TYPE.Material_WING,
				local_DUN_TYPE.Material_Copper,
				local_DUN_TYPE.Exp,
				local_DUN_TYPE.Vip_Rerson_Boss,
				local_DUN_TYPE.Equip,
				local_DUN_TYPE.Unreal,
				local_DUN_TYPE.Marriage,
				local_DUN_TYPE.Dragon,
				local_DUN_TYPE.AdvancedExp,
				local_DUN_TYPE.SingleRank,
				local_DUN_TYPE.Soul,
				local_DUN_TYPE.Heart,
				local_DUN_TYPE.SentientAct,
				local_DUN_TYPE.NEW_AMULET,
				local_DUN_TYPE.NEW_MOUNT,
				local_DUN_TYPE.NEW_WEAPON,
				local_DUN_TYPE.NEW_WING,
				local_DUN_TYPE.NEW_BACK_ORNAMENT
			]

			let CheckDunInitState = (dun_type) => {
				if (!local_BaseDungeonModel_Instance.GetDunInitState(dun_type) && local_BaseDungeonModel_Instance.CheckDunOpenState(dun_type)) {
					local_BaseDungeonModel_Instance.SetDunInitState(dun_type, true)
					InitDunData(dun_type)
				}
			}

			let check_all_dun_init_state_timer
			let CheckAllDunInitState = () => {
				if (check_all_dun_init_state_timer) {
					clearTimeout(check_all_dun_init_state_timer)
				}
				check_all_dun_init_state_timer = setTimeout(() => {
					check_all_dun_init_state_timer = false
					let dun_type
					for (let i in init_data_dun_type_list) {
						dun_type = init_data_dun_type_list[i]
						CheckDunInitState(dun_type)
					}
				}, 500)
			}

			GlobalEventSystem.Bind(SceneEventType.SCENE_REENTER, () => {
				if (local_SceneManager_Instance.IsKfSingleRankScene()) {
					GlobalEventSystem.Fire(EventName.STARTAUTOFIGHT)
				}
			})

			local_GlobalEventSystem.Bind(
				local_EventName.GAME_START, () => {
					local_BaseDungeonModel_Instance.ResetData()
					CheckAllDunInitState()

					//请求爬塔的数据
					local_BaseDungeonModel_Instance.RequestLimitTowerData()
				}
			)

			local_GlobalEventSystem.Bind(
				local_ServerTimeModel.DAY_CHANGE, () => {
					local_BaseDungeonModel_Instance.ResetDunInitState()
					setTimeout(() => {
						CheckAllDunInitState()
					}, 3)

					local_BaseDungeonModel_Instance.RequestLimitTowerData()

				}
			)

			local_GlobalEventSystem.Bind(
				local_ServerTimeModel.HOUR_REFRESH, (hour?) => {
					local_BaseDungeonModel_Instance.ResetDunInitState()
					if (hour == 4) {
						setTimeout(() => {
							CheckAllDunInitState()
						},
							3
						)
					}
				}
			)

			local_GlobalEventSystem.Bind(EventName.UPDATE_NEWEST_TASK_ID, (value?) => {
				CheckAllDunInitState()
			}
			)

			local_RoleManager_Instance.GetMainRoleVo().Bind(
				local_EventName.CHANGE_LEVEL, (level?) => {
					CheckAllDunInitState()
				}
			)

			local_BaseDungeonModel_Instance.Bind(
				local_BaseDungeonModel.OPEN_DENGEON_RESULT_VIEW, () => {
					let result_info = local_BaseDungeonModel_Instance.GetDungeonResultInfo()
					if (!result_info) {
						return
					}
					if (result_info.dun_type == 38) {
						local_GlobalEventSystem.Fire(local_EventName.CLOSE_VIEW, "DungeonResultEffectView")
						local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "DungeonResultEffectView")
					}
					else {
						if (result_info.result == 1) {
							local_GlobalEventSystem.Fire(local_EventName.CLOSE_VIEW, "DungeonVictoryView")
							local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "DungeonVictoryView")
						} else {
							local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "DungeonFailureView", result_info.dun_type)
						}
					}

				}
			)




			local_BaseDungeonModel_Instance.Bind(
				local_BaseDungeonModel.SCMD_REQUEST, (cmd, ...new_args) => {
					let args = new_args
					switch (cmd) {
						case 61001:
							if (local_SceneManager_Instance.IsBossScene()) {
								local_Alert.Show(
									"是否离开当前场景?",
									Alert_Type.Two, () => {
										this.SendFmtToGame(cmd, "i", args[0])
									},
									null,
									"离开",
									"取消"
								)
							} else {
								this.SendFmtToGame(cmd, "i", args[0])
							}
							break
						case 61045:
						case 61011:
						case 61056:
						case 61051:
						case 61104:
						case 61062:
						case 61019:
						case 61116:
							this.SendFmtToGame(cmd, "i", args[0])
							break
						case 61020:
						case 61025:
						case 61028:
						case 61042:
							this.SendFmtToGame(cmd, "c", args[0])
							break
						case 61021:
						case 61022:
							this.SendFmtToGame(cmd, "ih", args[0], args[1])
							break
						case 61043:
						case 61054:
						case 61050:
							this.SendFmtToGame(cmd, "ic", args[0], args[1])
							break
						case 61092:
							this.SendFmtToGame(cmd, "ci", args[0], args[1])
							break
						case 61093:
							this.SendFmtToGame(cmd, "ci", args[0], args[1])
							break
						case 61090:
							this.SendFmtToGame(cmd, "s", args[0])
							break
						case 61046:
							this.SendFmtToGame(cmd, "cil", args[0], args[1], args[2])
							break
						case 61010:
							this.SendFmtToGame(cmd, "ilc", args[0], args[1], args[2])
							break
						case 61047:
							this.SendFmtToGame(cmd, "ilc", args[0], args[1], args[2])
							break
						case 61007:
							this.SendFmtToGame(cmd, "hh", args[0], args[1])
							break
						case 61102:
							let send = () => {
								this.WriteBegin(cmd)
								let list = args[1]
								this.WriteFMT("i", args[0])
								this.WriteFMT("h", Util.TableSize(list))
								for (let key in list) {

									let id = list[key]
									this.WriteFMT("i", id)
								}
								this.SendToGame()
							}

							if (local_SceneManager_Instance.IsBossScene()) {
								local_Alert.Show(
									"是否离开当前场景?",
									Alert_Type.Two, () => {
										send()
									},
									null,
									"离开",
									"取消"
								)
							} else {
								send()
							}
							break
						case 61063:
							this.SendFmtToGame(cmd, "icccc", args[0], args[1], args[2], args[3], args[4])
							break
						case 50802:
							this.SendFmtToGame(cmd, "icc", args[0], args[1], args[2])
							break
						case 61112:
							this.WriteBegin(61112)
							let list = args[0]
							this.WriteFMT("h", Util.TableSize(list))
							for (let k in list) {
								var data = list[k]
								this.WriteFMT("i", data.dun_id)
								this.WriteFMT("c", data.reward_type)
							}
							this.SendToGame()
							break
						case 61113:
						case 61121:
						case 61120:
						case 61118:
							this.SendFmtToGame(cmd, "c", args[0])
							break
						default:
							this.SendFmtToGame(cmd)
					}


				}
			)

			local_GlobalEventSystem.Bind(
				local_SceneManager.START, () => {
					this.dungeon_scene_is_loaded = true
					show_born_effect_dic_ = undefined
					//this.ChangeScene()
				}
			)

			local_GlobalEventSystem.Bind(local_SceneEventType.SCENE_CHANGED, () => {
				this.dungeon_scene_is_loaded = false
				this.ChangeScene()
			})


			local_BaseDungeonModel_Instance.Bind(local_BaseDungeonModel.FIND_WAY, (x?, y?) => {
				this.FindWay(x, y)
			})

			local_BaseDungeonModel_Instance.Bind(local_BaseDungeonModel.OPEN_POLAR_BALANCE, () => {
				if (!local_BaseDungeonModel_Instance.polarBalance) {
					return
				}
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "DungeonPolarBalance")
			}
			)

			local_GlobalEventSystem.Bind(local_SceneEventType.MONSTER_VO_ADD, (ins_id, monster_vo) => {
				let cur_dun_id = SceneManager.GetInstance().GetCurrDunId()
				let dun_type_ = local_BaseDungeonModel_Instance.GetDunType(cur_dun_id)
				if (local_BaseDungeonModel_Instance.IsShowBornEffectDungeonType(dun_type_)) {
					let config = local_Config.GetConfigVo(local_Config.ConfigHasDefaultValue.config_mon.name, monster_vo.type_id, false)
					if (config && config.boss >= 3) {
						if (!show_born_effect_dic_) {
							show_born_effect_dic_ = {}
						}
						if (show_born_effect_dic_[ins_id]) {
							return
						}
						show_born_effect_dic_[ins_id] = true
						this.ShowBossBornEffect(ins_id)
					}
				}
			})

			local_GlobalEventSystem.Bind(local_SceneEventType.MONSTER_VO_REMOVE, () => {
				if (local_SceneManager_Instance.IsNewMainLineDungeon()) {
					if (Util.TableSize(SceneManager.GetInstance().monster_vo_list) == 0) {
						ResManager.GetInstance().LoadGameConfig(this, "config_dungeon_wave", false, null, (cfg) => {
							let [pos_x, pos_y, id] = local_BaseDungeonModel_Instance.GetSpawnPoint(local_BaseDungeonModel_Instance.curr_wave_type + 1, cfg)
							if (id != 0) {
								local_BaseDungeonModel_Instance.Fire(local_BaseDungeonModel.FIND_WAY, pos_x, pos_y)
							}
							ResManager.GetInstance().DestoryGameConfig(this, "config_dungeon_wave", false)
						})
					}
				}
			})

			local_RoleManager_Instance.GetMainRoleVo().BindOne(
				"fighting", (event_name?, value?, old_value?) => {
					if (!old_value) {
						return
					}
					local_BaseDungeonModel_Instance.RefreshRuneRed()
					local_BaseDungeonModel_Instance.RefreshTowerRed()
				}
			)

			local_RoleManager_Instance.GetMainRoleVo().BindOne(
				"vip_flag", () => {
					local_BaseDungeonModel_Instance.RequestDungeonNum(0)
				}
			)

			local_VipModel_Instance.Bind(VipModel.UPDATE_NOBLE_STATE, () => {
				if (BaseController.is_delay_send_protocal) {
					return
				}
				local_BaseDungeonModel_Instance.RefreshVipPersonRed()
			})

			local_RoleManager_Instance.GetMainRoleVo().Bind(
				local_EventName.CHANGE_LEVEL, (level?) => {
					let cfg = local_Config.PRELOAD_CLIENT_CONFIG.ConfigFuncOpenCondition
					let person_vip_cfg = cfg["BossPersonalEnterView"]
					if (person_vip_cfg && person_vip_cfg.open_lv == level) {
						local_BaseDungeonModel_Instance.RefreshVipPersonRed()
					}


					//请求爬塔的数据
					local_BaseDungeonModel_Instance.RequestLimitTowerData()
				}
			)

			local_BaseDungeonModel_Instance.Bind(
				local_BaseDungeonModel.SHOW_DRAGONE_WAVE_ITEM, (dun_id?, data?) => {
					if (window["DungeonDragonTipsItem"]) {
						let layer = local_LayerManager_Instance.GetUILayer(Enum_UILayer.Activity)
						if (layer) {
							let item = new DungeonDragonTipsItem(layer)
							item.Load()
							item.ExcuteCallback(() => {
								item.SetData(dun_id, data)

								item.display_obj.y = local_LayerManager_Instance.stageHeight
								item.display_obj.alpha = 0

								let posY = local_LayerManager_Instance.stageHeight - 500
								let runAni2, runAni3, deleteFunc
								deleteFunc = () => {
									if (item) {
										item.DeleteMe()
										item = null
									}
								}

								runAni2 = () => {
									setTimeout(() => {
										SYTweenLite.to(this, item.display_obj, SYTweenLite.UiAnimationType.ANCHORED_POSY, posY - 100, 0.25, deleteFunc)
									}, 1000)
								}


								SYTweenLite.to(this, item.display_obj, SYTweenLite.UiAnimationType.ANCHORED_POSY, posY, 0.35, runAni2)
								SYTweenLite.to(this, item.display_obj, SYTweenLite.UiAnimationType.ALPHA, 1, 0.35)
							}
							)
						}
					}
				}
			)

			GoodsModel.GetInstance().Bind(GoodsModel.UPDATE_GOODS_NUM, (goods_list) => {
				for (let _tmpi in goods_list) {
					var info = goods_list[_tmpi]
					if (BaseDungeonModel.EXP_AGAIN_GOODS_ID == info.type_id) {
						local_BaseDungeonModel_Instance.RefreshExpRed()
						break
					}
				}
			})

			// let _hash_code_target = null
			// local_BaseDungeonModel_Instance.Bind(
			// 	local_BaseDungeonModel.SKILL_OPEN_ICON_FLY, (icon_url?, pos?, target_pos?, endFunc?) => {
					// if (!icon_url || !pos) {
					// 	return
					// }
					// let ui_layer = local_LayerManager_Instance.GetUILayer(Enum_UILayer.UI)
					// let img = new Laya.Image()
					// img.height = 100
					// img.width = img.height
					// if (!_hash_code_target) {
					// 	_hash_code_target = new BaseClass()
					// }
					// ResManager.GetInstance().SetOutsideImageSprite(_hash_code_target, img, icon_url)
					// img.mouseEnabled = false
					// ui_layer.addChild(img)
					// img.x = pos.x
					// img.y = pos.y
					// if (target_pos) {
					// 	let dist = GameMath.GetDistance(pos.x, pos.y, target_pos.x, target_pos.y, true)
					// 	let delayFunc = () => {
					// 		if (endFunc) {
					// 			endFunc()
					// 		}
					// 		if (img && ui_layer) {
					// 			img.visible = false
					// 			ui_layer.removeChild(img)
					// 			ResManager.GetInstance().DestroyAllReferenceRes(_hash_code_target.hashCode)
					// 		}
					// 	}
					// 	Laya.Tween.to(img, { x: target_pos.x, y: target_pos.y }, 1200, null, Handler.create(ui_layer, delayFunc, null, true))
					// 	//Laya.Tween.get(img):wait(500):to({x = target_pos.x, y = target_pos.y}, 1200).call(delayFunc)
					// }
			// 	}
			// )

			// local_MonsterInvasionModel_Instance.Bind(local_MonsterInvasionModel.OPEN_REWARD_VIEW,() => {
			// 	if (! monster_reward_ ) {
			// 	  monster_reward_ =  new MonsterInvasionBoxReward()
			// 	}
			// 	monster_reward_.Open()
			//   }
			//   )
			//   local_MonsterInvasionModel_Instance.Bind(local_MonsterInvasionModel.OPEN_VIEW,() => {

			//   }
			//   )

			// local_GlobalEventSystem.Bind(local_SceneEventType.PET_MONSTER_VO_ADD,(instance_id?, monster_vo?) => {
			//   if (local_SceneManager_Instance.IsDungeonPetScene() ) {
			//     if (! local_BaseDungeonModel_Instance.select_pet_instance_id ) {
			//       local_BaseDungeonModel_Instance.select_pet_instance_id = instance_id
			//       let monster = Scene.GetInstance().GetMonster(local_BaseDungeonModel_Instance.select_pet_instance_id)
			//       if (monster ) {
			//         local_CameraManager_Instance.SetCameraPos(monster.real_pos.x, monster.real_pos.y, true)
			//         monster.CheckInScreen()
			//       }
			//     }
			//     local_BaseDungeonModel_Instance.setPetMonster(instance_id)
			//   }
			// }
			// )
			// local_GlobalEventSystem.Bind(local_ObjectEventType.MONSTER_MOVE,(pos_x?, pos_y?, instance_id?) => {
			//   if (local_SceneManager_Instance.IsDungeonPetScene() && instance_id == local_BaseDungeonModel_Instance.select_pet_instance_id ) {
			//     local_CameraManager_Instance.SetCameraPos(pos_x, pos_y, true)
			//     local_BaseDungeonModel_Instance.checkSelectPetMonster()
			//   }
			// }
			// )
			// local_GlobalEventSystem.Bind(local_ObjectEventType.OBJ_DEAD,(instance_id?) => {
			//   if (local_SceneManager_Instance.IsDungeonPetScene() ) {
			//     local_BaseDungeonModel_Instance.checkSelectPetMonster()
			//   }
			// }
			// )
			// local_GlobalEventSystem.Bind(local_EventName.REFRESH_MONSTER_HP,(instance_id?, vo?) => {
			//   if (local_SceneManager_Instance.IsDungeonPetScene() && vo.boss_type != 8 ) {
			//     let config = local_Config.GetConfigVo(local_Config.ConfigHasDefaultValue.config_mon.name, vo.type_id, false)
			//     local_GlobalEventSystem.Fire(local_EventName.SHOW_HITER_BIG_BLOOD_VIEW, true, vo, config.hp_num, false)
			//   }
			// }
			// )

			/*
			协议
			*/

			//玩家的周常副本信息
			this.RegisterProtocal(
				50801, () => {
					let scmd = local_UserMsgAdapter_Instance.GetSCMD(50801)
					local_BaseDungeonModel_Instance.setPolarInfo(scmd)
				}
			)
			//榜单
			this.RegisterProtocal(
				50802, () => {
					let scmd = local_UserMsgAdapter_Instance.GetSCMD(50802)
					local_BaseDungeonModel_Instance.setPolarRank(scmd)
				}
			)
			//结算界面
			this.RegisterProtocal(
				50805, () => {
					let scmd = local_UserMsgAdapter_Instance.GetSCMD(50805)
					local_BaseDungeonModel_Instance.setPolarBalance(scmd)
				}
			)

			//通用错误返回
			this.RegisterProtocal(
				61000, () => {
					let scmd = local_UserMsgAdapter_Instance.GetSCMD(61000)
					Util.ErrorCodeShow(scmd.error_code)
				}
			)

			//进入副本
			this.RegisterProtocal(
				61001, () => {
					let scmd = local_UserMsgAdapter_Instance.GetSCMD(61001)
					if (scmd.error_code != 1) {
						Util.ErrorCodeShow(scmd.error_code, scmd.error_code_args)
					} else {
						ResManager.GetInstance().LoadGameConfig(
							this,
							"config_dungeon",
							false,
							null,
							(cfg?) => {
								let dun_cfg = local_Config.GetConfigVo(local_Config.ConfigHasDefaultValue.config_dungeon.name, scmd.dun_id, false, cfg)
								let dun_type = dun_cfg && dun_cfg.type
								if (!dun_type) {
									ResManager.GetInstance().DestoryGameConfig(this, "config_dungeon", false)
									return
								}
								let data = local_BaseDungeonModel_Instance.GetDungeonInfo(dun_type)
								if (data) {
									let dun_data = null
									let bool = false


									switch (dun_type) {
										case local_DUN_TYPE.Vip_Rerson_Boss:
											bool = true
											for (let _tmpi in data) {
												var vo = data[_tmpi]
												if (vo.dun_id == scmd.dun_id) {
													vo.is_sweep = 1
												}
												vo.daily_count = vo.daily_count + 1
											}
											break
										case local_DUN_TYPE.AdvancedExp:
										case local_DUN_TYPE.Exp:
											bool = true
											for (let _tmpi in data) {
												var vo = data[_tmpi]
												if (vo.dun_id != local_BaseDungeonModel.GUILD_EXP_ID) {
													dun_data = vo
													//return
												}
											}
											if (dun_data) {
												let [left_num, total_times] = local_BaseDungeonModel_Instance.GetDunLeftTime(dun_type, scmd.dun_id)
												if (local_BaseDungeonModel_Instance.GetMergeExpCount()) {
													dun_data.daily_count = dun_data.daily_count + left_num
												} else {
													dun_data.daily_count = dun_data.daily_count + 1
												}
											}
											break
										case local_DUN_TYPE.Equip:
										case local_DUN_TYPE.Dragon:
											local_BaseDungeonModel_Instance.Fire(local_BaseDungeonModel.SCMD_REQUEST, 61020, dun_type)
											break
										case local_DUN_TYPE.SingleRank:
											kfSingleRankModel.GetInstance().SetDunInfo(scmd)
										case local_DUN_TYPE.SentientAct:
											SentientActModel.GetInstance().SetDunInfo(scmd)
											break
									}
									if (bool) {
										this.RefreshRed(dun_type)
									}
								}

								if (!local_BaseDungeonModel_Instance.IsLoadingDunType(dun_type)) { //加载类型的副本61004会主动推
									local_BaseDungeonModel_Instance.Fire(local_BaseDungeonModel.SCMD_REQUEST, 61004)
								}
								ResManager.GetInstance().DestoryGameConfig(this, "config_dungeon", false)
							}
						)
					}
				}
			)

			//退出副本
			this.RegisterProtocal(
				61002, () => {
					let scmd = local_UserMsgAdapter_Instance.GetSCMD(61002)
					if (scmd.error_code == 1) {
						//重置副本波数
						local_BaseDungeonModel_Instance.curr_wave_num = 1
					}
					Util.ErrorCodeShow(scmd.error_code)
				}
			)

			//通用结算界面
			this.RegisterProtocal(
				61003, () => {
					let scmd = local_UserMsgAdapter_Instance.GetSCMD(61003)
					// console.warn(JSON.stringify(scmd))
					let dungeon_rune_lv_data, dungeon_cfg

					let call_func = () => {
						if (!dungeon_cfg || !dungeon_rune_lv_data) {
							return
						}
						let dun_cfg = local_Config.GetConfigVo(local_Config.ConfigHasDefaultValue.config_dungeon.name, scmd.dun_id, false, dungeon_cfg)
						let dun_type = dun_cfg && dun_cfg.type
						if (!dun_type) {
							return
						}
						scmd["dun_type"] = dun_type
						if (dun_type == local_DUN_TYPE.Main_Line) {
							let task_id = TaskModel.GetInstance().GetMainLineTaskVo() && TaskModel.GetInstance().GetMainLineTaskVo().task_id
							let is_finish = TaskModel.GetInstance().GetMainLineTaskVo() && TaskModel.GetInstance().GetMainLineTaskVo().has_finish
							if (task_id && AutoBrushModel.GetInstance().IsSpeTaskId(task_id) && is_finish) {
								AutoBrushModel.GetInstance().Fire(AutoBrushModel.SHOW_MAIN_TASK_ARROW)
							}
						}
						scmd["result_type"] = local_DungeonResultType.Default
						let list = []

						for (let _tmpi in scmd.reward_list) {
							var vo = scmd.reward_list[_tmpi]
							let count = vo.count
							let [type_id, lock] = local_GoodsModel_Instance.GetMappingTypeId(vo.style, vo.typeId)
							let basic = local_GoodsModel_Instance.GetGoodsBasicByTypeId(type_id)
							if ((count > 1 && basic) && basic.type != 36) {

								let max_overlap = (basic.max_overlap == 0 && (1) || (basic.max_overlap))
								while ((count > 0)) {
									let num = null
									if (count > max_overlap) {
										num = max_overlap
										count = count - max_overlap
									} else {
										num = count
										count = 0
									}
									list.push({
										reward_type: 0,
										size: 85,
										vo: {
											style: vo.style,
											typeId: vo.typeId,
											count: num,
											goods_id: vo.goods_id
										}
									})
								}
							} else {
								list.push({
									reward_type: 0,
									size: 85,
									vo: {
										style: vo.style,
										typeId: vo.typeId,
										count: vo.count,
										goods_id: vo.goods_id
									}
								})
							}
						}
						for (let _tmpi in scmd.other_reward) {
							var other_reward = scmd.other_reward[_tmpi]
							for (let _tmpi in other_reward.other_reward_list) {
								let vo = other_reward.other_reward_list[_tmpi]
								let count = vo.count1
								if (count > 1) {
									let [type_id, lock] = local_GoodsModel_Instance.GetMappingTypeId(vo.style1, vo.type_id1)
									let basic = local_GoodsModel_Instance.GetGoodsBasicByTypeId(type_id)
									if (basic) {

										let max_overlap = (basic.max_overlap == 0 && (1) || (basic.max_overlap))
										if (basic.type == 36) {
											max_overlap = 999999999999999
										}
										while ((count > 0)) {
											let num = null
											if (count > max_overlap) {
												num = max_overlap
												count = count - max_overlap
											} else {
												num = count
												count = 0
											}
											list.push({
												reward_type: other_reward.reward_type,
												size: 85,
												vo: {
													style: vo.style1,
													typeId: vo.type_id1,
													count: num,
													goods_id: vo.goods_id1
												}
											})
										}
									}
								} else {
									list.push(
										{
											reward_type: other_reward.reward_type,
											size: 85,
											vo: {
												style: vo.style1,
												typeId: vo.type_id1,
												count: vo.count1,
												goods_id: vo.goods_id1
											}
										}
									)
								}
							}
						}
						scmd["reward_list"] = list
						let data = local_BaseDungeonModel_Instance.GetDungeonInfo(dun_type)
						if (data) {
							let bool = true

							switch (dun_type) {
								case local_DUN_TYPE.NEW_AMULET:
								case local_DUN_TYPE.NEW_MOUNT:
								case local_DUN_TYPE.NEW_WEAPON:
								case local_DUN_TYPE.NEW_WING:
								case local_DUN_TYPE.NEW_BACK_ORNAMENT:
								case local_DUN_TYPE.Material_Copper:
								case local_DUN_TYPE.Material_Mount:
								case local_DUN_TYPE.Material_Partner:
								case local_DUN_TYPE.Material_WING:
									if (scmd.result == 1) {
										for (let _tmpi in data) {
											let vo = data[_tmpi]
											if (vo.dun_id == scmd.dun_id) {
												vo.is_sweep = 1
											}
											vo.daily_count = vo.daily_count + 1
										}
									}
									break
								case local_DUN_TYPE.Rune:
								case local_DUN_TYPE.Tower:
									if (scmd.result == 1) {
										local_BaseDungeonModel_Instance.Fire(local_BaseDungeonModel.SCMD_REQUEST, 61020, local_DUN_TYPE.Rune)
										for (let _tmpi in data) {
											let vo = data[_tmpi]
											if (vo.dun_id == scmd.dun_id) {
												vo.permanent_count = 1
												break
											}
										}
									}
									break
								case local_DUN_TYPE.Unreal:
									bool = false
									local_BaseDungeonModel_Instance.Fire(local_BaseDungeonModel.SCMD_REQUEST, 61020, local_DUN_TYPE.Unreal)
									break
								case local_DUN_TYPE.Dragon:
									bool = false
									break
							}

							if (bool) {
								this.RefreshRed(dun_type)
							}
						}

						switch (dun_type) {
							// case local_DUN_TYPE.Soul:
							// 	scmd.result = 1
							// 	for (let _tmpi in scmd.ex_data) {
							// 		let vo = scmd.ex_data[_tmpi]
							// 		if (vo.key == 8 && vo.val == 2) {
							// 			scmd["isSweepSoul"] = true
							// 		}
							// 	}

							// 	scmd["result_type"] = local_DungeonResultType.Soul
							// 	local_BaseDungeonModel_Instance.Fire(local_BaseDungeonModel.SCMD_REQUEST, 21509)
								// break
							case local_DUN_TYPE.Pet:
								local_BaseDungeonModel_Instance.SetDungeonResultInfo(scmd)
								if (scmd.result == 1) {
									local_BaseDungeonModel_Instance.Fire(local_BaseDungeonModel.SCMD_REQUEST, 61103)
									local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "DungeonPetResultView", scmd)
								} else {
									local_BaseDungeonModel_Instance.Fire(local_BaseDungeonModel.OPEN_DENGEON_RESULT_VIEW)
								}
								return true
								break
							case local_DUN_TYPE.Exp:
								scmd.result = 1

								scmd["result_type"] = local_DungeonResultType.Exp
								//local_GlobalEventSystem:Fire(SysInfoController.CLEAR_MSG_CACHE, SysInfoType.MINI)
								break
							case local_DUN_TYPE.AdvancedExp:
								let info = local_BaseDungeonModel_Instance.adExpPanelInfo
								if (scmd.result != 1 && info.exp > 0) {
									scmd.result = 1
									info.wave = info.wave - 1
								}

								scmd["result_type"] = local_DungeonResultType.AdvancedExp
								break
							case local_DUN_TYPE.Rune:
								if (scmd.result == 1) {
									// let record = local_BaseDungeonModel_Instance.GetDungeonHighestRecord(local_DUN_TYPE.Rune)
									// let cfg = dungeon_rune_lv_data[record]
									// if (cfg && Number(cfg.unlock_rune) != 0) {
									// 	local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "DungeonRuneUnlockView", scmd)

									// 	return true
									// }
								}
								break
							case local_DUN_TYPE.Polar:
								return true
								break
							case local_DUN_TYPE.Boss_Guide_One:
							case local_DUN_TYPE.Boss_Guide_Two:
								let boss_result_data = { reward_type: 1, reward_list: [] }
								for (let _tmpi in list) {
									let vo = list[_tmpi]
									// table.insert(
									// 	boss_result_data.reward_list,
									// 	{type = vo.style, goods_type_id = vo.typeId, num = vo.count, id = vo.goods_id}
									// )
									boss_result_data.reward_list.push({ type: vo.style, goods_type_id: vo.typeId, num: vo.count, id: vo.goods_id })
								}
								// local_BossBaseModel_Instance.Fire(BossModel.OPEN_BOSS_RESULT_VIEW, boss_result_data)
								break
							case local_DUN_TYPE.Vip_Rerson_Boss:
								if (scmd.result == 1) {
									local_BossBaseModel_Instance.Fire(BossModel.VIP_PERSON_BOSS_kill)
								}
								return true
							case local_DUN_TYPE.GuildGuard:
								// GuildModel.GetInstance().Fire(GuildEvent.OPEN_VIEW, "GuildGuardResultView", scmd)
								return true
							case local_DUN_TYPE.SingleRank:
								local_BaseDungeonModel_Instance.SetDungeonResultInfo(scmd)
								if (scmd.result != 1) {
									local_BaseDungeonModel_Instance.Fire(local_BaseDungeonModel.OPEN_DENGEON_RESULT_VIEW)
								}
								return true
							case local_DUN_TYPE.Dragon:
							case local_DUN_TYPE.Equip:
								for (let _tmpi in scmd.ex_data) {
									let vo = scmd.ex_data[_tmpi]
									if (vo.key == 9 && vo.val == 2) {
										scmd["isAssist"] = true
									}
								}
								break
							case local_DUN_TYPE.SentientAct:
								scmd["enter_num"]=SentientActModel.GetInstance().enter_num
								break;
						}


						//前面会添加一些字段到scmd
						if (dun_type != local_DUN_TYPE.Heart) {
							//觉醒神殿副本不需要弹出通用副本结算
							//数据进去后没有进行清理  打完觉醒再去打符文副本，就会出现结算面板异常
							//现在觉醒副本不进数据

							if (BaseDungeonModel.GetInstance().IsNewMateriaDungeon(dun_type)) {
								scmd["is_sd"] = 0  //是否扫荡
								scmd["is_sweep"] = scmd.result == 1 ? 1 : 0  //这个是用来更新副本状态的 功能和语义不符
							}
							local_BaseDungeonModel_Instance.SetDungeonResultInfo(scmd)
						}

						//打开结算界面
						if (scmd.result == 1) {

							if (dun_type == local_DUN_TYPE.Equip && list.length == 0) {
								if (!local_BaseDungeonModel_Instance.none_alert && !scmd["isAssist"]) {
									local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "DungeonEquipNoneView")
								}
							} else if (dun_type == local_DUN_TYPE.Dragon) {
								local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "DungeonDragonResultView", scmd)
							} else if (BaseDungeonModel.GetInstance().IsNewMateriaDungeon(dun_type)) {
								//新资源副本结算
								console.warn("--------------新副本结算---------", scmd)
								GlobalEventSystem.Fire(EventName.OPEN_VIEW, "DungeonMaterialNewResultView", scmd)
							} else if (dun_type == local_DUN_TYPE.Partner) {
								GlobalEventSystem.Fire(EventName.OPEN_VIEW, "DungeonPartnerResultView", scmd)
							} else if (dun_type == local_DUN_TYPE.Heart) {
								let dungeon_learn_skill_data = Config.PRELOAD_SERVER_CONFIG.config_dungeon_learn_skill//Config.Dungeonlearnskill
								let cfg = dungeon_learn_skill_data && dungeon_learn_skill_data[scmd.dun_id]
								if (cfg) {
									let career = RoleManager.GetInstance().GetMainRoleCareer()
									let skill_list = JSON.parse(cfg.skill_list)
									for (let _ in skill_list) {
										var v = skill_list[_]
										if (Number(v[0]) == career) {
											for (let key in v[1]) {
												var value = v[1][key]
												let vo = new SkillVo(value[0])

												let res_data
												res_data = {
													id: vo.id,
													is_skill: true,
													sort_no: 0,
													name: vo.getName(),
													condition: "",
													icon: vo.GetIcon(),
													icon_open_text: vo.getDesc(null, false),
													icon_text: vo.getName(),
													content: vo.getName(),
													show_lv: 1,
													title_type: 1,
													dun_type: local_DUN_TYPE.Heart
												}
												FunctionOpenModel.GetInstance().Fire(FunctionOpenEvent.FUNCTIONOPEN_OPEN_VIEW, "FunctionOpenAutoView", res_data)
											}
										}
									}
								}
							} else if (dun_type == local_DUN_TYPE.AdvancedExp) {
								local_BaseDungeonModel_Instance.Fire(local_BaseDungeonModel.OPEN_DENGEON_RESULT_VIEW)
							} else {
								// this.Fire(BaseDungeonModel.OPEN_DENGEON_RESULT_VIEW)
								// local_BaseDungeonModel_Instance.Fire(BaseDungeonModel.OPEN_DENGEON_RESULT_VIEW)
								local_BaseDungeonModel_Instance.TryAddResultDrop()
							}
						} else {
							local_BaseDungeonModel_Instance.Fire(local_BaseDungeonModel.OPEN_DENGEON_RESULT_VIEW)
						}
						local_BaseDungeonModel_Instance.Fire(local_BaseDungeonModel.UPDATE_DUNGEON_TYPE_VIEW, dun_type)
					}
					ResManager.GetInstance().LoadGameConfig(this, "config_dungeon_rune_lv_data", false, null, (cfg) => {
						dungeon_rune_lv_data = cfg
						call_func()
					})
					ResManager.GetInstance().LoadGameConfig(this, "config_dungeon", false, null, (cfg) => {
						dungeon_cfg = cfg
						call_func()
					})


					local_BaseDungeonModel_Instance.RequestDungeonNum(scmd["dun_type"])
				}
			)

			//副本信息
			this.RegisterProtocal(
				61004, () => {
					let scmd = local_UserMsgAdapter_Instance.GetSCMD(61004)
					local_BaseDungeonModel_Instance.SetDungeonSceneMsg(scmd)
					local_BaseDungeonModel_Instance.Fire(local_BaseDungeonModel.UPDATE_DUNGEON_INFO, scmd)

					let boo = (!local_SceneManager_Instance.IsDungeonScene(local_SceneManager_Instance.GetLastSceneId()) || local_SceneManager_Instance.GetLastSceneId() == 0)
					if (local_SceneManager_Instance.IsDungeonScene() && boo) {
						let local_MainUIController = MainUIController.GetInstance()
						let local_MainUIModel = MainUIModel.GetInstance()
						local_MainUIController.SetMainUIViewVisible(10, false)
						//local_MainUIController.SetMainUIViewVisible(13, false)
						local_MainUIModel.Fire(MainUIModel.CHANGE_ACTIVITY_STATE, false)
						GlobalEventSystem.Fire(EventName.STARTAUTOFIGHT)
					}



				}
			)

			//副本信息
			this.RegisterProtocal(
				61005, () => {
					let scmd = local_UserMsgAdapter_Instance.GetSCMD(61005)
					local_BaseDungeonModel_Instance.curr_wave_type = scmd.type
					local_BaseDungeonModel_Instance.curr_wave_num = scmd.wave_num
					local_BaseDungeonModel_Instance.RefreshMonster(scmd.dun_id, scmd.scene_id, scmd.type, scmd.time)

					var find_way = () => {
						// if (local_SceneManager_Instance.IsNewMainLineDungeon() || local_SceneManager_Instance.IsEquipScene()) {
						// 	var find = () => {
						// 		local_BaseDungeonModel_Instance.Fire(BaseDungeonModel.FIND_WAY)
						// 	}
						// 	setTimeout(find, 0.5)
						// }

						if (this.delay_find_way) {
							GlobalEventSystem.UnBind(this.delay_find_way)
							this.delay_find_way = null
						}
					}

					// if (StoryController.Instance.IsPlaying() || StoryController.Instance.NeedPlayStory(scmd.scene_id, scmd.dun_id) ) {
					// 	this.delay_find_way = GlobalEventSystem.Bind(EventName.STORY_FINISH, find_way)
					// }else{
					if (!this.dungeon_scene_is_loaded) { //有可能在还没加载完成场景的时候就收到61005 这个时候保存一下需要寻路的信息，在加载完成后再开始寻路
						local_BaseDungeonModel_Instance.wait_load_find_way_fun = find_way
					} else {
						find_way()
					}
					// }
				}
			)

			//副本信息
			this.RegisterProtocal(
				61007, () => {
					let scmd = local_UserMsgAdapter_Instance.GetSCMD(61007)
					local_BaseDungeonModel_Instance.SuccessTriggerRolePos(scmd.x, scmd.y)
				}
			)

			//播放剧情
			this.RegisterProtocal(
				61009, () => {
					let scmd = local_UserMsgAdapter_Instance.GetSCMD(61009)
					// console.log("收到服务器剧情通知 61009",scmd.story_id,scmd.sub_sotry_id)
					setTimeout(() => {
						// console.log("触发服务器剧情 61009",scmd.story_id,scmd.sub_sotry_id)
						GlobalEventSystem.Fire(EventName.STORY_PLAY_TRIGGER, scmd.story_id, scmd.sub_sotry_id, 0, true)
					}, 0.05)

				}
			)

			//发送剧情事件
			this.RegisterProtocal(
				61010, () => {
					let scmd = local_UserMsgAdapter_Instance.GetSCMD(61010)
					local_BaseDungeonModel_Instance.Fire(BaseDungeonModel.SHOW_TRIGGER_TIP, false)
				}
			)

			//助战剩余次数
			this.RegisterProtocal(
				61011, () => {
					let scmd = local_UserMsgAdapter_Instance.GetSCMD(61011)
					local_BaseDungeonModel_Instance.SetDungeonHelpData(scmd)
				}
			)

			//退出副本时间
			this.RegisterProtocal(
				61018, () => {
					let scmd = local_UserMsgAdapter_Instance.GetSCMD(61018)
					if (scmd.type == 1) {
						local_BaseDungeonModel_Instance.Fire(local_BaseDungeonModel.UPDATE_DUNGEON_END_TIME, scmd.end_time)
					}
				}
			)

			//发送坐标事件的触发情况
			this.RegisterProtocal(
				61019, () => {
					let scmd = local_UserMsgAdapter_Instance.GetSCMD(61019)
					local_BaseDungeonModel_Instance.ResetPosEventList(scmd.xy_list)
				}
			)

			//获取副本状态信息
			this.RegisterProtocal(
				61020, () => {
					let scmd = local_UserMsgAdapter_Instance.GetSCMD(61020)
					let dungeon_cfg, dungeon_ui_cfg
					dungeon_ui_cfg = Config.PRELOAD_SERVER_CONFIG.config_dungeon_ui_content
					dungeon_cfg = Config.PRELOAD_SERVER_CONFIG.config_dungeon
					if (dungeon_ui_cfg && dungeon_cfg) {
						local_BaseDungeonModel_Instance.InitTurnRelation(dungeon_cfg)
						for (let v of scmd.dun_list) {
							local_BaseDungeonModel_Instance.SetDunBaseInfo(v, dungeon_cfg, dungeon_ui_cfg)
						}
						local_BaseDungeonModel_Instance.SetDungeonInfo(scmd.dun_type, scmd.dun_list)
						local_BaseDungeonModel_Instance.RequestDungeonNum(scmd.dun_type)
						this.RefreshRed(scmd.dun_type)
						local_BaseDungeonModel_Instance.Fire(local_BaseDungeonModel.UPDATE_DUNGEON_TYPE_VIEW, scmd.dun_type)
					}
				}
			)

			//购买副本次数
			this.RegisterProtocal(
				61021, () => {
					let scmd = local_UserMsgAdapter_Instance.GetSCMD(61021)
					if (scmd.error_code == 1) {
						local_Message.show("购买成功")
						let config_dungeon, config_dungeon_ui_content
						let cfg = config_dungeon//Config.Dungeon
						let dun_cfg = local_Config.GetConfigVo(local_Config.ConfigHasDefaultValue.config_dungeon.name, scmd.dun_id, false, cfg)
						if (dun_cfg) {
							let dun_type = dun_cfg && dun_cfg.type
							let dun_list = local_BaseDungeonModel_Instance.GetDungeonInfo(dun_type)

							switch (dun_type) {
								case local_DUN_TYPE.NEW_AMULET:
								case local_DUN_TYPE.NEW_MOUNT:
								case local_DUN_TYPE.NEW_WEAPON:
								case local_DUN_TYPE.NEW_WING:
								case local_DUN_TYPE.NEW_BACK_ORNAMENT:
								case local_DUN_TYPE.Material_Copper:
								case local_DUN_TYPE.Material_Mount:
								case local_DUN_TYPE.Material_Partner:
								case local_DUN_TYPE.Material_WING:
								case local_DUN_TYPE.Unreal:
								case local_DUN_TYPE.Soul:
								case local_DUN_TYPE.AdvancedExp:
									for (let _tmpi in dun_list) {
										var v = dun_list[_tmpi]
										v.vip_count = scmd.buy_count
									}
									break
								default:
									for (let _tmpi in dun_list) {
										var vo = dun_list[_tmpi]
										if (vo.dun_id == scmd.dun_id) {
											vo.vip_count = scmd.buy_count
											// return
											break
										}
									}
							}

							this.RefreshRed(dun_type)
							// let vip_card = local_VipModel_Instance.GetNobleCardState()
							// let vip_flag = local_RoleManager_Instance.GetMainRoleVo().vip_flag
							let total_buy_count = 0
							// 	local_VipModel_Instance.GetVipPrivilegeValue(
							// 	local_BaseDungeonModel.MODULE_ID,
							// 	local_BaseDungeonModel.VIP_PARAMETER + dun_type,
							// 	vip_card,
							// 	vip_flag
							// )
							local_BaseDungeonModel_Instance.Fire(local_BaseDungeonModel.UPDATE_DUNGEON_TIME, scmd.dun_id, dun_type)
							if (total_buy_count == scmd.buy_count) {
								local_GlobalEventSystem.Fire(local_EventName.CLOSE_VIEW, "DungeonBuyTimeView")
							}
						}
					} else {
						if (scmd.dun_id == local_MarriageDefine.DUN_ID && scmd.error_code == 6100043) {
							local_Message.show("购买次数已达上限")
						} else {
							Util.ErrorCodeShow(scmd.error_code)
						}
					}
				}
			)

			//扫荡
			this.RegisterProtocal(
				61022, () => {
					let scmd = local_UserMsgAdapter_Instance.GetSCMD(61022)
					if (scmd.error_code == 1) {
						let config_dungeon
						let cfg = config_dungeon
						let dun_cfg = local_Config.GetConfigVo(local_Config.ConfigHasDefaultValue.config_dungeon.name, scmd.dun_id, false, cfg)
						let dun_type = dun_cfg && dun_cfg.type
						if (dun_type) {
							scmd["result"] = 1
							scmd["reward_list"] = scmd.sweep_list[0] && scmd.sweep_list[0].reward_list
							scmd["dun_type"] = dun_type
							scmd["result_type"] = local_DungeonResultType.Sweeping


							//组装结算数据
							let list = []
							for (let _tmpi in scmd.sweep_list) {
								var reward = scmd.sweep_list[_tmpi]
								for (let _tmpi in reward.reward_list) {
									var vo = reward.reward_list[_tmpi]
									// table.insert(
									// 	list,
									// 	{reward_type = 0, style = vo.style, typeId = vo.typeId, count = vo.count, goods_id = vo.goods_id}
									// )
									list.push({
										reward_type: 0,
										size: 85,
										vo: {
											style: vo.style,
											typeId: vo.typeId,
											count: vo.count,
											goods_id: vo.goods_id
										}

									})
								}
								for (let _tmpi in reward.other_reward) {
									var other_reward = reward.other_reward[_tmpi]
									for (let _tmpi in other_reward.other_reward_list) {
										let vo = other_reward.other_reward_list[_tmpi]
										// table.insert(
										// 	list,
										// 	{
										// 		reward_type = other_reward.reward_type,
										// 		style = vo.style1,
										// 		typeId = vo.type_id1,
										// 		count = vo.count1,
										// 		goods_id = vo.goods_id1
										// 	}
										// )

										list.push({
											reward_type: other_reward.reward_type,
											size: 85,
											vo: {
												style: vo.style1,
												typeId: vo.type_id1,
												count: vo.count1,
												goods_id: vo.goods_id1
											}

										})
									}
								}
							}
							scmd["reward_list"] = list


							let data = local_BaseDungeonModel_Instance.GetDungeonInfo(dun_type)
							let dun_data = null
							if (data) {
								switch (dun_type) {
									case local_DUN_TYPE.NEW_AMULET:
									case local_DUN_TYPE.NEW_MOUNT:
									case local_DUN_TYPE.NEW_WEAPON:
									case local_DUN_TYPE.NEW_WING:
									case local_DUN_TYPE.NEW_BACK_ORNAMENT:
									case local_DUN_TYPE.Material_Copper:
									case local_DUN_TYPE.Material_Mount:
									case local_DUN_TYPE.Material_Partner:
									case local_DUN_TYPE.Material_WING:
										for (let _tmpi in data) {
											let vo = data[_tmpi]
											vo.daily_count = vo.daily_count + scmd.auto_num
										}
										break
									default:
										for (let _tmpi in data) {
											let vo = data[_tmpi]
											if (vo.dun_id == scmd.dun_id) {
												dun_data = vo
												return
											}
										}
										if (dun_data) {
											dun_data.daily_count = dun_data.daily_count + 1
										}
								}
							}

							if (local_BaseDungeonModel_Instance.IsNewMateriaDungeon(dun_type)) {
								scmd["is_sweep"] = 1 //这个是用来更新副本状态的 功能和语义不符
								scmd["is_sd"] = 1  //是否扫荡
								local_BaseDungeonModel_Instance.SetDungeonResultInfo(scmd)
								console.warn("--------------新副本扫荡--------", scmd)
								GlobalEventSystem.Fire(EventName.OPEN_VIEW, "DungeonMaterialNewResultView", scmd)
							} else {
								local_BaseDungeonModel_Instance.SetDungeonResultInfo(scmd)
								local_BaseDungeonModel_Instance.Fire(local_BaseDungeonModel.OPEN_DENGEON_RESULT_VIEW)
							}

							this.RefreshRed(dun_type)
							local_BaseDungeonModel_Instance.Fire(local_BaseDungeonModel.UPDATE_DUNGEON_TYPE_VIEW, dun_type)
						}
					} else {
						Util.ErrorCodeShow(scmd.error_code)
					}
				}
			)

			//获取当前时间评分状态
			this.RegisterProtocal(
				61023, () => {
					let scmd = local_UserMsgAdapter_Instance.GetSCMD(61023)
					local_BaseDungeonModel_Instance.Fire(local_BaseDungeonModel.NOW_TIME_SCORE_STATE, scmd)
				}
			)

			//鼓舞
			this.RegisterProtocal(
				61025, () => {
					let scmd = local_UserMsgAdapter_Instance.GetSCMD(61025)
					if (scmd.error_code == 1) {
						let total_count = scmd.coin_count + scmd.gold_count
						let dun_id = local_SceneManager_Instance.GetCurrDunId()
						let num = 10
						if (dun_id == local_BaseDungeonModel.GUILD_EXP_ID) {
							num = 5
							total_count = total_count
						}
						local_Message.show("鼓舞成功，当前伤害加成为 " + total_count * num + "%")
						local_BaseDungeonModel_Instance.SetInspireInfo({ coin_count: scmd.coin_count, gold_count: scmd.gold_count })
						local_BaseDungeonModel_Instance.Fire(local_BaseDungeonModel.UPDATE_INSPRITE_INFO, true)
						local_GlobalEventSystem.Fire(local_EventName.UPDATE_BUFF_VIEW)
					} else {
						Util.ErrorCodeShow(scmd.error_code)
					}
				}
			)

			//鼓舞状态数据
			this.RegisterProtocal(
				61026, () => {
					let scmd = local_UserMsgAdapter_Instance.GetSCMD(61026)
					local_BaseDungeonModel_Instance.SetInspireInfo({ coin_count: scmd.coin_count, gold_count: scmd.gold_count })
					local_BaseDungeonModel_Instance.Fire(local_BaseDungeonModel.UPDATE_INSPRITE_INFO)
				}
			)

			//副本批量扫荡
			this.RegisterProtocal(
				61028, () => {
					let scmd = local_UserMsgAdapter_Instance.GetSCMD(61028)
					let list = []
					for (let _tmpi in scmd.sweep_list) {
						var sweep_list = scmd.sweep_list[_tmpi]
						for (let _tmpi in sweep_list.reward_list) {
							var vo = sweep_list.reward_list[_tmpi]
							// table.insert(
							// 	list,
							// 	{reward_type = 0, style = vo.style, typeId = vo.typeId, count = vo.count, goods_id = vo.goods_id}
							// )
							list.push({
								reward_type: 0,
								size: 85,
								vo: {
									style: vo.style,
									typeId: vo.typeId,
									count: vo.count,
									goods_id: vo.goods_id
								}
							})
						}
						for (let _tmpi in sweep_list.other_reward) {
							var other_reward = sweep_list.other_reward[_tmpi]
							for (let _tmpi in other_reward.other_reward_list) {
								let vo = other_reward.other_reward_list[_tmpi]
								// table.insert(
								// 	list,
								// 	{
								// 		reward_type = other_reward.reward_type,
								// 		style = vo.style1,
								// 		typeId = vo.type_id1,
								// 		count = vo.count1,
								// 		goods_id = vo.goods_id1
								// 	}
								// )
								list.push({
									reward_type: other_reward.reward_type,
									style: vo.style1,
									typeId: vo.type_id1,
									count: vo.count1,
									goods_id: vo.goods_id1
								})
							}
						}
					}
					scmd["reward_list"] = list
					if (list.length > 0) {
						scmd["result"] = 1
						scmd["reward_list"] = list
						scmd["result_type"] = local_DungeonResultType.Sweeping
						local_BaseDungeonModel_Instance.SetDungeonResultInfo(scmd)
						local_BaseDungeonModel_Instance.Fire(local_BaseDungeonModel.OPEN_DENGEON_RESULT_VIEW)
					}
					local_BaseDungeonModel_Instance.Fire(local_BaseDungeonModel.SCMD_REQUEST, 61020, scmd.dun_type)
				}
			)

			//下一波到来时间
			this.RegisterProtocal(
				61030, () => {
					let scmd = local_UserMsgAdapter_Instance.GetSCMD(61030)
					local_BaseDungeonModel_Instance.Fire(local_BaseDungeonModel.NEXT_WAVE_TIME_INFO, scmd.wave_num, scmd.time)
				}
			)

			//获得额外的奖励领取列表
			this.RegisterProtocal(
				61042, () => {
					let scmd = local_UserMsgAdapter_Instance.GetSCMD(61042)
					local_BaseDungeonModel_Instance.Fire(local_BaseDungeonModel.UPDATE_EXTRA_REWARD_LIST, scmd)
				}
			)

			//领取额外的奖励
			this.RegisterProtocal(
				61043, () => {
					let scmd = local_UserMsgAdapter_Instance.GetSCMD(61043)
					if (scmd.error_code == 1) {
						// local_Util.ShowCongratulationView(scmd.reward_list, 10)
						local_BaseDungeonModel_Instance.Fire(local_BaseDungeonModel.RECEVIED_EXTRA_REWARD, scmd)
					} else {
						Util.ErrorCodeShow(scmd.error_code)
					}
				}
			)
			//副本面板信息(经验副本左侧面板)
			this.RegisterProtocal(
				61044, () => {
					let scmd = local_UserMsgAdapter_Instance.GetSCMD(61044)
					local_BaseDungeonModel_Instance.SetExpDungeonInfo(scmd)
				}
			)

			//副本冷却时间
			this.RegisterProtocal(
				61045, () => {
					let scmd = local_UserMsgAdapter_Instance.GetSCMD(61045)
					local_BaseDungeonModel_Instance.SetDungeonCd(scmd)
				}
			)

			//邀请进入副本
			this.RegisterProtocal(
				61046, () => {
					let scmd = local_UserMsgAdapter_Instance.GetSCMD(61046)
					if (scmd.code_msg && scmd.code_msg != "") {
						local_Message.show(scmd.code_msg)
					}
				}
			)

			//回应邀请进入副本
			this.RegisterProtocal(
				61047, () => {
					let scmd = local_UserMsgAdapter_Instance.GetSCMD(61047)
					if (scmd.code == 1) {
					} else {
						Util.ErrorCodeShow(scmd.code)
					}
				}
			)

			//邀请进入副本界面信息
			this.RegisterProtocal(
				61048, () => {
					let scmd = local_UserMsgAdapter_Instance.GetSCMD(61048)
					let inviter = 0
					for (let _tmpi in scmd.list) {
						var data = scmd.list[_tmpi]
						if (data.type == 1) {
							inviter = data.role_id
							break
						}
					}

					// 1 成功发出邀请 2 邀请方取消邀请 3 对方拒绝 4 被邀请方不能进入副本
					if (scmd.code == 1) {
						if (!invite_view_list_) {
							invite_view_list_ = []
						}
						let view = null
						if (scmd.dun_id == local_MarriageDefine.DUN_ID) {
							local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "MarriageDunTipsView", scmd)
							view = local_ViewManager_Instance.GetView("MarriageDunTipsView")
						}
						invite_view_list_[scmd.dun_id + "@" + inviter] = view
					} else {
						if (scmd.dun_id == local_MarriageDefine.DUN_ID) {
							let role_vo = local_RoleManager_Instance.GetMainRoleVo()
							let is_initiative = role_vo.role_id == inviter
							let str = ""
							if (scmd.code == 2) {
								str = is_initiative && "您取消了邀请" || "对方取消了邀请"
							} else if (scmd.code == 3) {
								str = is_initiative && "对方拒绝了您的邀请" || "您拒绝了对方的邀请"
							} else if (scmd.code == 4) {
								str = is_initiative && "对方不能进入副本" || "您不能进入副本"
							}
							local_Message.show(str)
						}
						if (invite_view_list_) {
							let view = invite_view_list_[scmd.dun_id + "@" + inviter]
							if (view && view.Close) {
								view.Close()
							}
						}
					}
				}
			)

			//神纹副本最佳记录
			this.RegisterProtocal(
				61050, () => {
					let scmd = local_UserMsgAdapter_Instance.GetSCMD(61050)
					local_BaseDungeonModel_Instance.Fire(local_BaseDungeonModel.UPDATE_BEST_RECORD, scmd)
				}
			)

			//神纹副本成就奖励
			this.RegisterProtocal(
				61051, () => {
					let scmd = local_UserMsgAdapter_Instance.GetSCMD(61051)
					local_BaseDungeonModel_Instance.SetDragonWaveRewardData(scmd)
				}
			)

			//快速出怪
			this.RegisterProtocal(
				61052, () => {
					let scmd = local_UserMsgAdapter_Instance.GetSCMD(61052)
					if (scmd.error_code == 1) {
						local_BaseDungeonModel_Instance.Fire(local_BaseDungeonModel.SCMD_REQUEST, 61053)
					} else {
						Util.ErrorCodeShow(scmd.error_code)
					}
				}
			)

			//快速出怪信息
			this.RegisterProtocal(
				61053, () => {
					let scmd = local_UserMsgAdapter_Instance.GetSCMD(61053)
					local_BaseDungeonModel_Instance.SetDragonRefreshData(scmd)
				}
			)

			//领取成就
			this.RegisterProtocal(
				61054, () => {
					let scmd = local_UserMsgAdapter_Instance.GetSCMD(61054)
					if (scmd.code == 1) {
						local_Message.show("领取成功")
						let data = local_BaseDungeonModel_Instance.GetWaveRewardData(scmd.dun_id)
						if (data) {
							let list = data.list
							for (let _tmpi in list) {
								var vo = list[_tmpi]
								if (vo.wave == scmd.wave) {
									vo.state = 2
									Util.ShowCongratulationView(vo.reward, 10)
									break
								}
							}
							local_BaseDungeonModel_Instance.SetDragonRewardState()
							local_BaseDungeonModel_Instance.Fire(local_BaseDungeonModel.UPDATE_WAVE_REWARD_DATA, scmd.dun_id)
						}
					} else {
						Util.ErrorCodeShow(scmd.code)
					}
				}
			)

			//查看副本技能数量
			this.RegisterProtocal(
				61055, () => {
					let scmd = local_UserMsgAdapter_Instance.GetSCMD(61055)
					local_BaseDungeonModel_Instance.SetDragonSkillData(scmd)
				}
			)

			//释放buff技能
			this.RegisterProtocal(
				61056, () => {
					let scmd = local_UserMsgAdapter_Instance.GetSCMD(61056)
					if (scmd.code == 1) {
						local_BaseDungeonModel_Instance.Fire(local_BaseDungeonModel.SCMD_REQUEST, 61055)
					} else {
						Util.ErrorCodeShow(scmd.code)
					}
				}
			)

			//波数数据(神纹副本)
			this.RegisterProtocal(
				61057, () => {
					let scmd = local_UserMsgAdapter_Instance.GetSCMD(61057)
				}
			)

			//神纹本跳关奖励
			this.RegisterProtocal(
				61058, () => {
					let scmd = local_UserMsgAdapter_Instance.GetSCMD(61058)
					local_BaseDungeonModel_Instance.SetDragonJumpData(scmd)
				}
			)

			//波数副本面板(高级经验副本)
			this.RegisterProtocal(
				61059, () => {
					let scmd = local_UserMsgAdapter_Instance.GetSCMD(61059)
					local_BaseDungeonModel_Instance.setAdExpInfo(scmd)
				}
			)

			//波数副本结束(高级经验副本)
			this.RegisterProtocal(
				61060, () => {
					let scmd = local_UserMsgAdapter_Instance.GetSCMD(61060)
					local_BaseDungeonModel_Instance.setAdExpInfo2(scmd)
				}
			)

			//波数跳关(进入通知)(高级经验副本)
			this.RegisterProtocal(
				61061, () => {
					let scmd = local_UserMsgAdapter_Instance.GetSCMD(61061)
					local_BaseDungeonModel_Instance.setAdExpPopView(scmd)
				}
			)

			//开关设置信息(注意.有一些副本是根据副本类型设置的,但是客户端也会存副本id.服务端和客户端自己转化)
			this.RegisterProtocal(
				61062, () => {
					let scmd = local_UserMsgAdapter_Instance.GetSCMD(61062)
					local_BaseDungeonModel_Instance.setDunSetInfo(scmd)
				}
			)

			//开关设置(注意.有一些副本是根据副本类型设置的,但是客户端也会存副本id.服务端和客户端自己转化)
			this.RegisterProtocal(
				61063, () => {
					let scmd = local_UserMsgAdapter_Instance.GetSCMD(61063)
					if (scmd.errcode == 1) {
						local_BaseDungeonModel_Instance.changeDunSetInfo(scmd)
						local_BaseDungeonModel_Instance.Fire(local_BaseDungeonModel.SCMD_REQUEST, 61062, scmd.dun_id)
					} else {
						Util.ErrorCodeShow(scmd.errcode)
					}
				}
			)

			//鼓舞状态数据(首次进入推送)
			this.RegisterProtocal(
				61065, () => {
					let scmd = local_UserMsgAdapter_Instance.GetSCMD(61065)
					local_BaseDungeonModel_Instance.show_inspite_msg = true
					local_BaseDungeonModel_Instance.check_inspite_msg(scmd)
					local_BaseDungeonModel_Instance.Fire(local_BaseDungeonModel.SHOW_MESSAGE_INSPRITE)
				}
			)

			//副本独自的特殊信息
			this.RegisterProtocal(
				61088, () => {
					let scmd = local_UserMsgAdapter_Instance.GetSCMD(61088)
					local_BaseDungeonModel_Instance.setPolarSpData(scmd, Config.PRELOAD_SERVER_CONFIG.config_week_dungeon_kv)
				}
			)

			//题目信息
			this.RegisterProtocal(
				61089, () => {
					let scmd = local_UserMsgAdapter_Instance.GetSCMD(61089)
					if (scmd.type == 1) {
						local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "MarriageDunLuckView", scmd)
					} else if (scmd.type == 2) {
						local_GlobalEventSystem.Fire(local_EventName.CLOSE_VIEW, "MarriageDunLuckView")
					}
				}
			)

			//提交答案
			this.RegisterProtocal(
				61090, () => {
					let scmd = local_UserMsgAdapter_Instance.GetSCMD(61090)
					if (scmd.ret == 2) {
						local_Message.show("太棒了，你们选择一致")
					} else if (scmd.ret == 3) {
						local_Message.show("很遗憾，你们选择相异")
					}
				}
			)

			//抢夺扣血
			this.RegisterProtocal(
				61091, () => {
					let scmd = local_UserMsgAdapter_Instance.GetSCMD(61091)
					if (scmd.error_code == 1) {
						local_BaseDungeonModel_Instance.Fire(local_BaseDungeonModel.GUIDE_FIGHT_SUCCESS)
					} else {
						Util.ErrorCodeShow(scmd.error_code)
					}
				}
			)

			//异兽入侵 领取阶段奖励
			this.RegisterProtocal(
				61092, () => {
					let scmd = local_UserMsgAdapter_Instance.GetSCMD(61092)
					if (scmd.error_code == 1) {
						// local_MonsterInvasionModel_Instance.setMonsterInvasionReward(scmd)
					} else {
						Util.ErrorCodeShow(scmd.error_code)
					}
				}
			)

			//异兽入侵 界面协议
			this.RegisterProtocal(
				61093, () => {
					let scmd = local_UserMsgAdapter_Instance.GetSCMD(61093)
					// local_MonsterInvasionModel_Instance.setMonsterInvasionData(scmd)
				}
			)

			//副本技能列表
			this.RegisterProtocal(
				61101, () => {
					let scmd = local_UserMsgAdapter_Instance.GetSCMD(61101)
					local_BaseDungeonModel_Instance.SetHeartSkillData(scmd)
				}
			)

			//当前通关副本id
			this.RegisterProtocal(
				61103, () => {
					let scmd = local_UserMsgAdapter_Instance.GetSCMD(61103)
					local_BaseDungeonModel_Instance.setDungeonPetLayer(scmd)
				}
			)

			//符文副本奖励
			this.RegisterProtocal(
				61112, () => {
					let scmd = local_UserMsgAdapter_Instance.GetSCMD(61112)
					if (scmd.code == 1) {
						local_BaseDungeonModel_Instance.SetRuneExtraReward(scmd)
					} else {
						Util.ErrorCodeShow(scmd.code)
					}
				}
			)

			this.RegisterProtocal(
				61113, () => {
					let scmd = local_UserMsgAdapter_Instance.GetSCMD(61113)
					local_BaseDungeonModel_Instance.SetRuneReward(scmd)
				}
			)

			//符文本领取每日奖励
			this.RegisterProtocal(
				61114, () => {
					let scmd = local_UserMsgAdapter_Instance.GetSCMD(61114)
					if (scmd.code == 1) {
						GlobalEventSystem.Fire(EventName.CLOSE_VIEW, "DungeonRuneDailyRewardView")
						local_BaseDungeonModel_Instance.SetRuneDailyRewardState(2)
						Util.ShowCongratulationView(scmd.reward_list)
						BaseDungeonModel.GetInstance().RefreshRuneRed()
					}
					else {
						Util.ErrorCodeShow(scmd.code)
					}
				}
			)

			//符文本奖励领取状态
			this.RegisterProtocal(
				61115, () => {
					let scmd = local_UserMsgAdapter_Instance.GetSCMD(61115)
					local_BaseDungeonModel_Instance.SetRuneDailyRewardState(scmd.daily_status)
					local_BaseDungeonModel_Instance.SetRuneUnlockFloor(scmd.unlock_level)
					local_BaseDungeonModel_Instance.RefreshRuneRed()
				}
			)

			//符文本解锁层级
			this.RegisterProtocal(
				61116, () => {
					let scmd = local_UserMsgAdapter_Instance.GetSCMD(61116)
					local_BaseDungeonModel_Instance.SetRuneUnlockFloor(scmd.level)
					local_BaseDungeonModel_Instance.RefreshRuneRed()
					let dungeon_rune_lv_data = Config.PRELOAD_SERVER_CONFIG.config_dungeon_rune_lv_data
					let cfg = dungeon_rune_lv_data[scmd.level]
					if (cfg && Number(cfg.unlock_rune) != 0) {
						local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "DungeonRuneUnlockView", scmd)
					}
				}
			)

			// 经验本触发获取经验 yy25d经验本 不由击杀怪物过去经验，根据在副本时间获取
			this.RegisterProtocal(
				61119, () => {
					let scmd = local_UserMsgAdapter_Instance.GetSCMD(61119)
					local_BaseDungeonModel_Instance.Fire(local_BaseDungeonModel.TIMING_UPDATE_EXP, scmd.next_time);
				}
			)

			//怪物剩余数量
			this.RegisterProtocal(
				61066, () => {
					let scmd = local_UserMsgAdapter_Instance.GetSCMD(61066)
					local_BaseDungeonModel_Instance.Fire(local_BaseDungeonModel.UPDATE_MONSTER_NUM, scmd)
				}
			)



			//爬塔
			this.RegisterProtocal(
				61117, () => {
					let scmd = local_UserMsgAdapter_Instance.GetSCMD(61117)
					if (scmd.round != 0 && scmd.over_time != 0) {
						local_BaseDungeonModel_Instance.dungeon_tower_scmd = scmd
						local_BaseDungeonModel_Instance.Fire(local_BaseDungeonModel.LIMIT_TIME_TOWER_UPDATE)

						if (local_BaseDungeonModel_Instance.cur_tower_round != scmd.round) {
							local_BaseDungeonModel_Instance.cur_tower_round = scmd.round
							local_BaseDungeonModel_Instance.Fire(local_BaseDungeonModel.LIMIT_TIME_TOWER_ITEM_ROUND)
						}

					} else {
						GlobalEventSystem.Fire(EventName.CLOSE_VIEW, "DungeonTowerBaseView")
					}

					local_BaseDungeonModel_Instance.AddTowerIcon(scmd.over_time, scmd.round)
					local_BaseDungeonModel_Instance.RefreshTowerRed()
				}
			)


			this.RegisterProtocal(
				61118, () => {
					let scmd = local_UserMsgAdapter_Instance.GetSCMD(61118)
					if (scmd.code == 1) {
						//领取成功
						let obj = local_BaseDungeonModel_Instance.dungeon_tower_scmd
						if (obj && obj.reward_mode != null) {
							obj.reward_mode = 2

							let list = []
							let round_cfg = local_BaseDungeonModel_Instance.GetTowerInfoDatas()
							let rewards = ErlangParser.GetInstance().parse(round_cfg.big_reward)
							table.insert(list, [rewards[0][0], rewards[0][1], rewards[0][2]])
							Util.ShowCongratulationView(list)
						}
						local_BaseDungeonModel_Instance.Fire(local_BaseDungeonModel.LIMIT_TIME_TOWER_UPDATE)
						local_BaseDungeonModel_Instance.RefreshTowerRed()
					}

				}
			)

			//资源副本优化 次数更新
			this.RegisterProtocal(
				61121, () => {
					let scmd = local_UserMsgAdapter_Instance.GetSCMD(61121)
					local_BaseDungeonModel_Instance.SaveDungeonNumData(scmd)
					//要放在SaveDungeonNumData后面
					local_BaseDungeonModel_Instance.UpdateNewMatrialRed(scmd)
					local_BaseDungeonModel_Instance.Fire(local_BaseDungeonModel.NEW_DUNGEON_UPDATE_NUM)
				}
			)

			//新资源副本 一键扫荡/一键挑战
			this.RegisterProtocal(
				61120, () => {

					let scmd = local_UserMsgAdapter_Instance.GetSCMD(61120)
					if (scmd.code == 1) {
						local_BaseDungeonModel_Instance.ShowDungeonResult(scmd)
						local_BaseDungeonModel_Instance.Fire(local_BaseDungeonModel.NEW_DUNGEON_ONE_KEY)
					}
					else {
						Util.ErrorCodeShow(scmd.code)
					}

				}
			)


			//上线请求一遍领取的奖励信息
			local_BaseDungeonModel_Instance.InitDragonReward()
		}

		this.ChangeScene = () => {
			ResManager.GetInstance().GetGameConfigWithAutoDestory("config_beings_gate_kv", (cfg) => {
				let is_dungeon_scene = SentientActModel.GetInstance().IsSentientActDungeonScene(cfg)
				let is_last_dungoen_scene = SentientActModel.GetInstance().IsSentientActDungeonScene(cfg, local_SceneManager_Instance.GetLastSceneId())
				if (local_SceneManager_Instance.IsDungeonScene() && !is_dungeon_scene &&
					(!local_SceneManager_Instance.IsDungeonScene(local_SceneManager_Instance.GetLastSceneId()) || local_SceneManager_Instance.GetLastSceneId() == 0)
				) {

					local_BaseDungeonModel_Instance.EnterSceneStart()
					this.EnterSceneHandle()
				}
				if ((local_SceneManager_Instance.IsDungeonScene(local_SceneManager_Instance.GetLastSceneId()) || local_SceneManager_Instance.GetLastSceneId() == 0) &&
					!local_SceneManager_Instance.IsDungeonScene() && !is_last_dungoen_scene
				) {
					this.ExitSceneHandle()
				}
			}, false)

		}

		this.EnterSceneHandle = () => {
			if (local_SceneManager_Instance.IsVipPersonalBossDungeon()) {
				GlobalEventSystem.Fire(EventName.CLOSE_VIEW, "BossEnterView")
			}

			local_GlobalEventSystem.Fire(local_EventName.CLOSE_VIEW, "DungeonEnterView")
			local_GlobalEventSystem.Fire(local_EventName.CLOSE_VIEW, "DungeonMainLineTipsView")

			if (local_SceneManager_Instance.IsExpDungeon()) {
				local_SceneManager_Instance.ResetMainRoleKillMonsterCount()
				local_BaseDungeonModel_Instance.SetExpDungeonInfo(null)
			} else if (local_SceneManager_Instance.IsEquipDungeon()) {
				TeamModel.GetInstance().Fire(TeamEvent.TEAM_CLOSE_VIEW, "TeamVoteView")
			} else if (local_SceneManager_Instance.IsLimitTowerDungeon()) {
				local_GlobalEventSystem.Fire(local_EventName.CLOSE_VIEW, "DungeonTowerBaseView")
			}

			if (local_SceneManager_Instance.IsPolarDungeon() || local_SceneManager_Instance.IsKFPolarDungeon()) {
				local_GlobalEventSystem.Fire(local_EventName.HIDE_MAINUI_FIGHT_NUM, false)
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "DungeonPolarSceneView")
				local_GlobalEventSystem.Fire(local_EventName.HIDE_ALL_NOTIFICATION, false)
				MainUIController.GetInstance().SetMainUIViewVisible(13, false)
			} else {
				//打开场景界面
				//if (local_SceneManager_Instance.IsGuildGuardScene() ) {
				//local_GlobalEventSystem:Fire(local_EventName.OPEN_VIEW, "GuildGuardSceneView")
				//} else if (local_SceneManager_Instance.IsAdvanceExpScene() ) {
				//local_GlobalEventSystem:Fire(local_EventName.OPEN_VIEW, "AdvancedExpSceneView")
				//}else{
				if (local_SceneManager_Instance.IsExpDungeon()) {
					local_GlobalEventSystem.Fire(local_EventName.CLOSE_VIEW, "DungeonFightSceneView")
				}
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "DungeonFightSceneView")
				//if (Util.IsTableEmpty(BaseWindowComponent.CURR_OPEN_VIEW) && local_SceneManager_Instance.IsMainLineDungeonScene() ) {
				//local_GlobalEventSystem:Fire(local_EventName.OPEN_VIEW, "DungeonFightSceneMaskView")
				//is_open_mask_ = true
				//}
			}

			local_BaseDungeonModel_Instance.Fire(BaseDungeonModel.SCMD_REQUEST, 61019, SceneManager.Instance.GetSceneId())
		}

		this.ExitSceneHandle = () => {
			let local_SceneManager_Instance = SceneManager.Instance
			this.SetMainUIVisible(true)
			local_MainUIModel_Instance.Fire(MainUIModel.CHANGE_ACTIVITY_STATE, true)

			//local_GlobalEventSystem:Fire(local_EventName.CLOSE_VIEW, "GuildGuardSceneView")
			local_GlobalEventSystem.Fire(local_EventName.CLOSE_VIEW, "DungeonFightSceneView")

			let maskView = local_ViewManager_Instance.GetView("DungeonPolarSceneView")
			if (maskView && maskView.HasOpen()) {
				local_GlobalEventSystem.Fire(local_EventName.CLOSE_VIEW, "DungeonPolarSceneView")
				local_GlobalEventSystem.Fire(local_EventName.HIDE_MAINUI_FIGHT_NUM, true)
				// local_BossBaseModel_Instance.PickupMon = []
				local_GlobalEventSystem.Fire(local_EventName.HIDE_ALL_NOTIFICATION, true)
				MainUIController.GetInstance().SetMainUIViewVisible(13, true)
			}

			if (local_SceneManager_Instance.IsDragonDungeon(local_SceneManager_Instance.GetLastDunId())) {
				local_BaseDungeonModel_Instance.SetDragonJumpData(null)
				//退出神纹副本后，如果没打开结算界面，则跳到神纹界面
				if (!ViewManager.GetInstance().GetViewOpenState("DungeonDragonResultView")) {
					GlobalEventSystem.Fire(EventName.OPEN_VIEW, "DungeonEnterView", DungeonEnterViewIndex.Dragon)
				}
			}

			local_BaseDungeonModel_Instance.TryJumpFailureId()
			local_BaseDungeonModel_Instance.SetDungeonSceneMsg(null)

			local_BaseDungeonModel_Instance.ClearDungeonInfo()

			if (this.delay_find_way) {
				GlobalEventSystem.UnBind(this.delay_find_way)
				this.delay_find_way = null
			}
		}

		this.SetMainUIVisible = (bool?) => {
			MainUIController.GetInstance().SetMainUIViewVisible(10, bool)
		}

		this.RefreshRed = (dun_type?) => {

			switch (dun_type) {
				case local_DUN_TYPE.NEW_AMULET:
				case local_DUN_TYPE.NEW_MOUNT:
				case local_DUN_TYPE.NEW_WEAPON:
				case local_DUN_TYPE.NEW_WING:
				case local_DUN_TYPE.NEW_BACK_ORNAMENT:
				case local_DUN_TYPE.Material_Copper:
				case local_DUN_TYPE.Material_Mount:
				case local_DUN_TYPE.Material_Partner:
				case local_DUN_TYPE.Material_WING:
					local_BaseDungeonModel_Instance.RefreshMaterialRed()
					break
				case local_DUN_TYPE.Tower:
				case local_DUN_TYPE.Rune:
					local_BaseDungeonModel_Instance.RefreshRuneRed()
					// MedalModel.GetInstance().setShowRedDot()
					break
				case local_DUN_TYPE.Vip_Rerson_Boss:
					local_BaseDungeonModel_Instance.RefreshVipPersonRed()
					break
				case local_DUN_TYPE.Exp:
					local_BaseDungeonModel_Instance.RefreshExpRed()
					break
				case local_DUN_TYPE.Soul:
					local_BaseDungeonModel_Instance.RefreshSoulRed()
					break
				case local_DUN_TYPE.Equip:
					local_BaseDungeonModel_Instance.RefreshEquipRed()
					break
				case local_DUN_TYPE.Dragon:
					local_BaseDungeonModel_Instance.SetDragonTimeState()
					break
				case local_DUN_TYPE.Pet:
					local_BaseDungeonModel_Instance._dungeonPetSweep = true
					local_BaseDungeonModel_Instance.checkSweepRedDot()
					break
				case local_DUN_TYPE.AdvancedExp:
					local_BaseDungeonModel_Instance.RefreshAdExpRed()
					break
			}


		}
		this.ShowBossBornEffect = (ins_id) => {
			if (Util.IsTableEmpty(BaseWindowComponent.CURR_OPEN_VIEW)) {
				AutoFightManager.GetInstance().SetAutoFight(false)
				local_GlobalEventSystem.Fire(EventName.OPEN_VIEW, "DungeonFightSceneMaskView")
				//this.is_open_mask = true
			}
			// else {
			// 	GlobalEventSystem.Fire(EventName.STOPAUTOFIGHT)
			// 	let effect_group = new Laya.Box()
			// 	effect_group.width = 720
			// 	effect_group.height = 1280
			// 	effect_group.centerX = 0
			// 	effect_group.centerY = -300
			// 	let top_ui_layer = LayerManager.GetInstance().GetUILayer(Enum_UILayer.Activity)
			// 	top_ui_layer.addChild(effect_group)
			// 	let effect = new UIEffect()
			// 	let call_back_func = () => {
			// 		GlobalEventSystem.Fire(EventName.STARTAUTOFIGHT)
			// 		delete show_born_effect_dic_[ins_id]
			// 		show_born_effect_dic_ = null
			// 		effect.DeleteMe()
			// 	}

			// 	effect.AddUIEffect("effect_ui_dayaolaixi", effect_group, null, null, null, 1.5, call_back_func)
			// }
		}

		this.Init()
	}

	public FindWay(posx?, posy?, wave_type?) {

		ResManager.GetInstance().LoadGameConfig(this, "config_dungeon_wave", false, null, (cfg) => {
			var call_back = () => {
				GlobalEventSystem.Fire(EventName.STARTAUTOFIGHT)
				this.last_find_x = null
				this.last_find_y = null
			}

			let [x, y, id] = BaseDungeonModel.GetInstance().GetSpawnPoint(undefined, cfg)

			this.cur_find_id = id || 0

			let findVo = new FindVo()
			findVo.sceneId = SceneManager.GetInstance().GetSceneId()
			findVo.type = FindVo.POINT
			findVo.id = id || 0
			findVo.x = posx || x
			findVo.y = posy || y
			findVo.call_back = call_back
			// console.log("副本寻路参数",findVo.id,id)
			if (findVo.id == 0) {
				return
			}

			let main_role = Scene.Instance.GetMainRole()
				main_role.is_shoe_flying = false
			// console.log("副本开始寻路了  ",findVo.x,findVo.y,id,posx,posy,x,y,RoleManager.Instance.mainRoleInfo.role_id)
			GlobalEventSystem.Fire(EventName.FIND, findVo)
			this.last_find_x = findVo.x
			this.last_find_y = findVo.y

			ResManager.GetInstance().DestoryGameConfig(this, "config_dungeon_wave", false)
		})
	}

}

window["BaseDungeonController"] = BaseDungeonController
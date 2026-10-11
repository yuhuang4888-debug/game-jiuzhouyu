import { BaseView1 } from "../common/BaseView1"
import { Config } from "../common/Config"
import { CustomHeadItem } from "../common/CustomHeadItem"
import { EventName, ObjectEventType } from "../common/EventName"
import { Enum_UILayer, LayerManager } from "../common/LayerManager"
import { MainUIManager } from "../common/MainUIManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { AutoBrushModel } from "../commonModel/AutoBrushModel"
import { BaseDungeonModel } from "../commonModel/BaseDungeonModel"
// import { BossModel } from "../commonModel/BossModel"
import { MainUIModel } from "../commonModel/MainUIModel"
import { PlatformManager } from "../PlatformManager"
import { SceneBaseType } from "../scene/SceneConfig"
import { SceneManager } from "../scene/SceneManager"
import { ColorUtil } from "../util/ColorUtil"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { Runner } from "../util/Runner"
import { SYTweenLite } from "../util/SYTweenLite"
import { GlobalTimerQuest, Util } from "../util/Util"

export class MainUIHiterBigBloodView extends BaseView1 {

	RefuseDrogInfo
	CancalDelayCloseTime
	ClearHiter
	GetBloodUrl
	InitEvent
	LoadSuccess
	SetDate
	ShowBAOJIAni
	ShowVit
	StartDelayCloseTime
	StartUpdate
	StopUpdate
	Update
	UpdateHpImage
	UpdateView
	baoji_tween_id1
	baoji_tween_id2
	change_scene_close
	close_callback
	destroy_imm
	head
	is_set_order_sorting
	need_loading_view
	open_callback
	preload_server_config
	_cur_show_mon_id
	_damage_dic = {}
	public static Dark_Move_Times = 60
	public static Light_Move_Times = 7
	public static Blood_Max_Len = 204
	public static Len_Offset = 0
	public static Offset_X = 28
	public static Offset_Y = 127

	public constructor() {
		super()

		this.base_file = "mainUI"
		this.layout_file = "MainUIHiterBigBloodView"
		this.layer_value = Enum_UILayer.Main
		this.destroy_imm = true
		this.change_scene_close = true
		this.need_loading_view = false
		this.is_set_order_sorting = false

		let mainUI_model = MainUIModel.GetInstance()
		let local_laya = Laya
		let layer_mgr = LayerManager.GetInstance()
		let local_MainUIModel = MainUIModel
		let local_SceneBaseType = SceneBaseType
		let local_Config = Config

		let local_ColorUtil = ColorUtil
		let local_GameResPath = GameResPath
		let scene_mgr = SceneManager.GetInstance()
		// let kf_holy_arena_model = KfHolyAreaModel.GetInstance()
		let local_Math = Math
		let local_Ranner = Runner.GetInstance()

		let hp_strip_count_ = 10
		let update_id_ = null
		let now_dark_hp_ = null
		let now_light_hp_ = null
		let update_state_ = false
		let strip_index_ = null
		let hiter_vo_ = null
		let need_to_refresh_ = null
		let delay_close_time_id_ = null
		let hp_change_id_ = null
		let frame_index_ = 0
		let show_baoji_ani_ = false
		let autoClose_ = true
		
		this.preload_server_config = {
			"config_additional_drop": false
		}
		this.load_callback = () => {

			this.display_obj.x = LayerManager.GetInstance().stageWidth - this.display_obj.width - MainUIHiterBigBloodView.Offset_X
			let liu_hai_height = Util.GetLiuhaiHeight()
			if (liu_hai_height) {
				this.display_obj.y = MainUIHiterBigBloodView.Offset_Y + liu_hai_height
			}
			else {
				this.display_obj.y = MainUIHiterBigBloodView.Offset_Y
			}
			let config = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_mon.name, hiter_vo_.type_id, false) //Config.PRELOAD_SERVER_CONFIG.config_mon[mon_vo.type_id]
			if (config && config.boss == 7) {
				MainUIModel.GetInstance().Fire(MainUIModel.CHANGE_ACTIVITY_STATE, false)
			}
			// this.form.pivot = Vector2(1, 1)
			// this.form.anchorMax = Vector2(1, 1)
			// this.form.anchorMin = Vector2(1, 1)

			// let x,y = MainUIHiterBigBloodView.Offset_X,0
			// let liu_hai_height = GetLiuhaiHeight()
			// if (liu_hai_height ) {
			// 	y = MainUIHiterBigBloodView.Offset_Y + liu_hai_height
			// }else{
			// 	y = MainUIHiterBigBloodView.Offset_Y
			// }
			// this.form.anchoredPosition = Vector2(-x, -y)



			this.LoadSuccess()
		}

		this.open_callback = () => {
			if (need_to_refresh_) {
				this.UpdateView()
				need_to_refresh_ = false
			}
			mainUI_model.big_blood_in_show = true
		}

		this.close_callback = () => {
			let config = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_mon.name, hiter_vo_.type_id, false) //Config.PRELOAD_SERVER_CONFIG.config_mon[mon_vo.type_id]
			if (config && config.boss == 7) {
				MainUIModel.GetInstance().Fire(MainUIModel.CHANGE_ACTIVITY_STATE, true)
			}
			this.ClearHiter()
			this.StopUpdate()
			strip_index_ = null
			hiter_vo_ = null
			mainUI_model.big_blood_in_show = false
			show_baoji_ani_ = false
			this._cur_show_mon_id = null
			if (this.baoji_tween_id1) {
				SYTweenLite.Stop(this.baoji_tween_id1)
			}
			if (this.baoji_tween_id2) {
				SYTweenLite.Stop(this.baoji_tween_id2)
			}

			if (this.head) {
				this.head.DeleteMe()
				this.head = null
			}

			MainUIManager.GetInstance().RemoveMoveComponent(this)
		}

		// this.preload_server_config = [config_c_sanctuary_mon_type=false, config_c_sanctuary_mon=false]

		this.SetDate = (vo?, hp_strip_count?, autoClose?) => {
			if (autoClose != null) {
				autoClose_ = autoClose
			} else {
				autoClose_ = true
			}
			if (!autoClose_) {
				this.CancalDelayCloseTime()
			}
			if (hiter_vo_ == vo) {
				if (this.is_loaded && autoClose_) {
					this.StartDelayCloseTime(3)
				}
			} else {
				this.ClearHiter()
				hiter_vo_ = vo
				hp_strip_count_ = hp_strip_count || 10
				hp_strip_count_ = (hp_strip_count_ == 0 && (1) || (hp_strip_count_))
				if (this.is_loaded) {
					this.UpdateView()
				} else {
					need_to_refresh_ = true
				}
			}
		}
		this.RefuseDrogInfo = (type_id) => {
			let list = this._damage_dic
			if (list && Util.TableSize(list) > 0) {
				let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_additional_drop", false)
				let vo = null
				let role_num = Util.TableSize(list)
				for (let key in cfg) {
					let data = cfg[key]
					if (data.mon_id == type_id && data.hurt_num_min <= role_num && data.hurt_num >= role_num) {
						this.drop_gp.visible = true
						vo = data
						break
					}
				}
				if (vo) {
					this.drop_lb.style.fontSize = 16
					this.drop_lb.style.color = "#663915"
					this.drop_lb.style.wordWrap = false
					this.drop_lb.innerHTML = `参与击杀: <font color='#0a953e'>${role_num}</font>人   大妖掉落: <font color='#d15e00'>${vo.ratio / 100} %</font>`
					let parent = <Laya.HBox>this.drop_lb.parent
					if(parent) parent.refresh()
				}
			}
		}

		this.InitEvent = () => {
			let onRemoveSceneObjHandler = (vo?) => {
				if (vo && hiter_vo_ == vo) {
					this.Close()
				}
			}
			this.BindEvent(GlobalEventSystem, ObjectEventType.REMOVE_SCENE_OBJECT, onRemoveSceneObjHandler)
			this.BindEvent(GlobalEventSystem, EventName.UPDATE_BOSS_DAMAGE_DATA, (monster_id?, list?, type_id?) => {
				if (hiter_vo_.vo_type != local_SceneBaseType.Monster) return
				if(this._damage_dic && Util.TableSize(this._damage_dic) > 0){
					// for (let key in this._damage_dic) {
					// 	delete this._damage_dic[key]
					// }
					this._damage_dic = {}
				}
				let monster = local_Config.GetConfigVo(local_Config.ConfigHasDefaultValue.config_mon.name, hiter_vo_.type_id, false)
				if (type_id == monster.id){
					for (let key in list) {
						let data = list[key]
						this._damage_dic[data.player_id] = Util.DeepCopy(data)
					}
				}
				this.RefuseDrogInfo(type_id)				
			}
			)
			this.BindEvent(GlobalEventSystem, EventName.ADD_BOSS_DAMAGE_DATA, (scmd?) => {
				if (hiter_vo_.vo_type != local_SceneBaseType.Monster) return
				if (this._cur_show_mon_id != scmd.monster_type_id) {
					return
				}
				let vo = this._damage_dic[scmd.player_id]
				if (vo) {
					vo.damage = vo.damage + scmd.damage
				} else {
					this._damage_dic[scmd.player_id] = Util.DeepCopy(scmd)
				}
				this.RefuseDrogInfo(scmd.monster_type_id)
			}
			)
			this.BindEvent(GlobalEventSystem, EventName.REMOVE_BOSS_DAMAGE_DATA, (monster_id?, list?, type_id?) => {
				if (hiter_vo_.vo_type != local_SceneBaseType.Monster) return
				
				for (let _tmpi in list) {
					var info = list[_tmpi]
					delete this._damage_dic[info.player_id]
				}
				this.RefuseDrogInfo(type_id)
			}
			)
		}

		this.LoadSuccess = () => {



			// ResManager.GetInstance().SetOutsideImageSprite(this, this._img_next_blood, GameResPath.GetIcon("mainUI", "uizjm_020b"))
			// ResManager.GetInstance().SetOutsideImageSprite(this, this._img_dark_blood, GameResPath.GetIcon("mainUI", "uizjm_020f"))
			// ResManager.GetInstance().SetOutsideImageSprite(this, this._img_light_blood, GameResPath.GetIcon("mainUI", "uizjm_020a"))
			MainUIManager.GetInstance().AddMoveComponent(this, this.display_obj, false, MainUIManager.MOVE_TYPE.Right)
			this.InitEvent()
		}

		this.ClearHiter = () => {
			if (hiter_vo_ && hp_change_id_) {
				hiter_vo_.UnBind(hp_change_id_)
				hp_change_id_ = null
			}
			this.CancalDelayCloseTime()
		}

		this.CancalDelayCloseTime = () => {
			if (delay_close_time_id_) {
				GlobalTimerQuest.CancelQuest(delay_close_time_id_)
				delay_close_time_id_ = null
			}
		}

		this.StartDelayCloseTime = (time?) => {
			this.CancalDelayCloseTime()

			delay_close_time_id_ = GlobalTimerQuest.AddDelayQuest(() => {
				this.Close()
			}, time)
		}

		this.UpdateView = () => {
			this._img_next_blood.visible = false
			this.drop_gp.visible = false
			if (hiter_vo_ && autoClose_) {
				this.StartDelayCloseTime(3)
			}
			this._lb_anger.visible = false
			if (hiter_vo_.vo_type == local_SceneBaseType.Monster) {
				this._box_head.visible = false
				this._img_head.visible = true
				this._lb_hp.visible = false
				this._lb_left_blood.visible = false

				let monster = local_Config.GetConfigVo(local_Config.ConfigHasDefaultValue.config_mon.name, hiter_vo_.type_id, false)
				this._cur_show_mon_id = monster.id
				if (hiter_vo_.type_id == AutoBrushModel.AutoBrushMonsterId) {
					let next_level = AutoBrushModel.GetInstance().GetLevel() + 1

					let cfgs = local_Config.PRELOAD_CLIENT_CONFIG.ConfigAutoBrush
					let cfg

					if (cfgs && cfgs.level_boss_cfg && cfgs.level_boss_cfg[next_level]) {
						cfg = cfgs.level_boss_cfg[next_level]
					}

					if (!cfg) {
						let index = next_level % 10
						if (cfgs && cfgs.turn_boss_cfg && cfgs.turn_boss_cfg[index]) {
							cfg = cfgs.turn_boss_cfg[index]
						}
					}

					if (cfg)
						ResManager.GetInstance().SetTexture(this, this._img_head, local_GameResPath.GetMonsterHeadPath(cfg.head_res))
					let color = local_ColorUtil.GetColorLight(monster.color, false)
					let lv = hiter_vo_.level > 370 ? `神创${hiter_vo_.level - 370}` : hiter_vo_.level
					this._lb_name.text = `${lv}级 ${hiter_vo_.name}`
					this._lb_name.color = color
				}
				else if (monster) {
					this.ShowVit(monster.id)

					ResManager.GetInstance().SetTexture(this, this._img_head, GameResPath.GetMonsterHeadPath(monster.icon))
					ResManager.GetInstance().SetOutsideImageSprite(this, this._img_head, local_GameResPath.GetMonsterHeadPath(monster.icon))
					let level = hiter_vo_.level
					if (monster.auto == 1 || monster.auto == 2 || SceneManager.GetInstance().IsGhostWalkScene()) {
						level = hiter_vo_.level
					} else if (monster.auto == 0) {
						level = monster.lv
					}
					if (PlatformManager.IsEyouEnPlatform()) {
						this._lb_name.text = "Lv." + level + "  " + monster.name
					} else if (PlatformManager.IsEyouIdnPlatform()) {
						this._lb_name.text = "Lv." + level + "  " + monster.name
					} else {
						this._lb_name.text = level + "级 " + monster.name
					}

					this._lb_name.color = local_ColorUtil.GetColorLight(monster.color, false)
					if (scene_mgr.IsSuitBossScene() || scene_mgr.IsMysteryBossScene()) {
						this._lb_anger.visible = true
						this._lb_anger.text = "疲劳值:" + monster.anger
					}
					else if (scene_mgr.IsFieldBossScene() || scene_mgr.IsFieldInfiniteBossScene()) {
						this._lb_anger.visible = false
						// let config = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_boss_cfg.name, monster.id, false)
						// if(config){
						// 	this._lb_anger.visible = config.layers!=0
						// 	if(config.layers>0){
						// 		this._lb_anger.text = "体力消耗：" + config.tired_add
						// 	}
						// }

					}
					// else if (scene_mgr.IsHolyTerritory() && ! HolyTerritoryModel.GetInstance().IsSelfHT() ) {
					// 	let config = local_Config.Bosscfg[monster.id]
					// 	if (config && config.sign == 1 ) {
					// 		this._lb_anger.visible = true 
					// 		this._lb_anger.text = "疲劳值:" + monster.anger
					// 	}
					// } 
					// else if (scene_mgr.IsKfHolyAreaScene() ) {
					// 	// let c_sanctuary_mon = ResManager.GetInstance().GetGameConfigFromCache(this, "config_c_sanctuary_mon", false)
					// 	// let boss_cfg = kf_holy_arena_model.GetMonsterCfg(monster.id, c_sanctuary_mon)
					// 	// let scene_info = kf_holy_arena_model.GetSceneData(scene_mgr.GetSceneId())
					// 	// if (boss_cfg && scene_info ) {
					// 	// 	let c_sanctuary_mon_type_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_c_sanctuary_mon_type", false)
					// 	// 	let type_cfg = kf_holy_arena_model.GetMonsterTypeCfg(boss_cfg.type, scene_info.con_type, c_sanctuary_mon_type_cfg)
					// 	// 	if (type_cfg ) {
					// 	// 		this._lb_anger.visible = true
					// 	// 		this._lb_anger.text = "怒气值:" + type_cfg.anger
					// 	// 	}
					// 	// }
					// }
				} else {
					let lv = hiter_vo_.level > 370 && "神创" + (hiter_vo_.level - 370) || hiter_vo_.level
					if (PlatformManager.IsEyouEnPlatform()) {
						this._lb_name.text = "Lv." + lv + "  " + hiter_vo_.name
					} else {
						this._lb_name.text = lv + "级 " + hiter_vo_.name
					}
					console.log("MainUIHiterBigBloodView:UpdateView=>Can't found id " + hiter_vo_.type_id + " in monster cfg!!")
				}
			} else if (hiter_vo_.vo_type == local_SceneBaseType.Role) {
				this._box_head.visible = true
				this._img_head.visible = false
				this._lb_hp.visible = true
				this._lb_left_blood.visible = false
				let is_mask = hiter_vo_.mask_id != 0 && scene_mgr.CanMaskScene()
				let lv = hiter_vo_.level > 370 && "神创" + (hiter_vo_.level - 370) || hiter_vo_.level
				if (PlatformManager.IsEyouEnPlatform()) {
					this._lb_name.text = is_mask && "Anonymous" || "Lv." + lv + "  " + hiter_vo_.name
				} else if (PlatformManager.IsEyouIdnPlatform()) {
					this._lb_name.text = is_mask && "Anonymous" || "Lv." + lv + "  " + hiter_vo_.name

				} else {
					this._lb_name.text = is_mask && "蒙面人" || lv + "级 " + hiter_vo_.name
				}

				if (this.head == null) {
					this.head = new CustomHeadItem(this._box_head)
					this.head.Load()
				}
				this.head.SetRoleVoData(is_mask && { career: hiter_vo_.career } || hiter_vo_)
				this.head.CloseClick()
				this.head.ExcuteCallback(() => {
					// this.head.transform.anchoredPosition = new Vector2(0, 0)
					this.head.SetActiveFrame(false)
					this.head.SetActiveLevel(false)
				})
			}
			let now_hp = hiter_vo_.hp / hiter_vo_.maxHp * hp_strip_count_
			let now_hp_count = local_Math.floor(now_hp)
			this._lb_hp.text = MainUIHiterBigBloodView.FormatHp(hiter_vo_.hp, hiter_vo_.maxHp)
			this.UpdateHpImage(now_hp_count)

			this._img_dark_blood.width = MainUIHiterBigBloodView.Blood_Max_Len * (now_hp - now_hp_count) + MainUIHiterBigBloodView.Len_Offset
			this._img_light_blood.width = MainUIHiterBigBloodView.Blood_Max_Len * (now_hp - now_hp_count) + MainUIHiterBigBloodView.Len_Offset

			now_dark_hp_ = hiter_vo_.hp
			now_light_hp_ = now_dark_hp_
			let hp_change = (value?, hp?) => {
				update_state_ = true
				frame_index_ = 0
				this.StartUpdate()
			}

			hp_change_id_ = hiter_vo_.BindOne("hp", hp_change)

		}

		this.StartUpdate = () => {
			if (!update_id_) {
				local_Ranner.AddRunObj(this)
				update_id_ = true
			}
		}

		this.StopUpdate = () => {
			if (update_id_) {
				local_Ranner.RemoveRunObj(this.hashCode)
				update_id_ = false
			}
		}

		this.UpdateHpImage = (strip_index?) => {
			if (strip_index_ != strip_index) {
				strip_index_ = strip_index
				if (strip_index < 1) {
					this._lb_left_blood.visible = false
					this._img_next_blood.visible = false
				} else {
					if (!this._img_next_blood.visible) {
						this._lb_left_blood.visible = true
						this._img_next_blood.visible = true
					}
					this._lb_left_blood.text = strip_index >= hp_strip_count_ && "x" + hp_strip_count_ || "x" + (strip_index + 1)
					let next_num = strip_index % 5
					if (next_num == 0) {
						next_num = 5
					}
					ResManager.GetInstance().SetImageSpriteTrans(this, this._img_next_blood, local_GameResPath.GetIcon("mainUI", this.GetBloodUrl(next_num)))
				}
				let num = (strip_index + 1) % 5
				if (num == 0) {
					num = 5
				}
				ResManager.GetInstance().SetImageSpriteTrans(this, this._img_light_blood, local_GameResPath.GetIcon("mainUI", this.GetBloodUrl(num)))
			}
		}

		this.GetBloodUrl = (index?) => {
			let url = ""
			if (5 == index) {
				url = "mainui_boss_blood_5"
			} else if (4 == index) {
				url = "mainui_boss_blood_4"
			} else if (3 == index) {
				url = "mainui_boss_blood_3"
			} else if (2 == index) {
				url = "mainui_boss_blood_2"
			} else if (1 == index) {
				url = "mainui_boss_blood_1"
			}
			return url
		}

		this.Update = (now_time?, elapse_time?) => {
			if (update_state_) {
				if (!hiter_vo_) {
					update_state_ = false
					this.StopUpdate()
					return
				}
				frame_index_ = frame_index_ + 1
				let light_scale = frame_index_ / MainUIHiterBigBloodView.Light_Move_Times
				if (light_scale > 1) {
					light_scale = 1
				}
				let now_light_hp = now_light_hp_ + light_scale * (hiter_vo_.hp - now_light_hp_)
				let light_percent = now_light_hp / hiter_vo_.maxHp * hp_strip_count_
				this._lb_hp.text = MainUIHiterBigBloodView.FormatHp(now_light_hp, hiter_vo_.maxHp)

				let light_strip_index = local_Math.floor(light_percent)
				let light_end_value = light_percent - light_strip_index

				this._img_light_blood.width = light_end_value * MainUIHiterBigBloodView.Blood_Max_Len + MainUIHiterBigBloodView.Len_Offset
				this.UpdateHpImage(light_strip_index)

				now_light_hp_ = now_light_hp

				let dark_scale = frame_index_ / MainUIHiterBigBloodView.Dark_Move_Times
				if (dark_scale > 1) {
					dark_scale = 1
				}
				let now_dark_hp = now_dark_hp_ + dark_scale * (hiter_vo_.hp - now_dark_hp_)
				now_dark_hp_ = now_dark_hp
				let dark_percent = now_dark_hp / hiter_vo_.maxHp * hp_strip_count_
				let dark_strip_index = local_Math.floor(dark_percent)
				let dark_end_value = dark_percent - dark_strip_index


				this._img_dark_blood.width = dark_end_value * MainUIHiterBigBloodView.Blood_Max_Len + MainUIHiterBigBloodView.Len_Offset

				if (dark_scale == 1) {
					update_state_ = false
					this.StopUpdate()
				}
			}
		}

		this.ShowBAOJIAni = (vo?) => {
			if (((vo && hiter_vo_) && vo.role_id == hiter_vo_.instance_id) && !show_baoji_ani_) {
				if (this._box_con) {
					show_baoji_ani_ = true

					this.baoji_tween_id1 = SYTweenLite.to(this, this._box_con, SYTweenLite.UiAnimationType.SCALE, 1.1, 0.05, () => {
						this.baoji_tween_id2 = SYTweenLite.to(this, this._box_con, SYTweenLite.UiAnimationType.SCALE, 1, 0.03, () => {
							show_baoji_ani_ = false
						})
					})

				}
			}
		}
		this.ShowVit = (id?) => {
			// let cfg = Config.Bosscfg[id]
			// let type = cfg && cfg.type
			// this._lb_vit.visible = type == BossModel.BossType.field 
			// if (this._lb_vit.visible && cfg ) {
			// 	let tired_add = cfg.tired_add
			// 	this._lb_vit.text = "击杀体力消耗：" + tired_add
			// }
		}

	}

	public static FormatHp = (now?, max?) => {
		now = Math.floor(now)
		max = Math.floor(max)
		if (max > 100000) {
			now = now > 10000 && now || MainUIHiterBigBloodView.GetPreciseDecimal(Number(now / 10000), 1) + "w"
			max = MainUIHiterBigBloodView.GetPreciseDecimal(Number(max / 10000), 1) + "w"
		}
		return now + "/" + max
	}

	public static GetPreciseDecimal = (nNum, n) => {
		if (typeof (nNum) != "number") {
			return nNum
		}
		n = n || 0;
		n = Math.floor(n)
		if (n < 0)
			n = 0

		let nDecimal = 10 ^ n
		let nTemp = Math.floor(nNum * nDecimal);
		let nRet = nTemp / nDecimal;
		return nRet
	}

	_box_con: Laya.Box
	_img_bg: Laya.Image
	_img_next_blood: Laya.Image
	_img_dark_blood: Laya.Image
	_img_light_blood: Laya.Image
	_lb_name: Laya.Label
	_lb_left_blood: Laya.Label
	_lb_hp: Laya.Label
	_lb_anger: Laya.Label
	_lb_vit: Laya.Label
	_img_head: Laya.Image
	_box_head: Laya.Box
	drop_gp: Laya.Image
	drop_lb: Laya.HTMLDivElement
	public GetComponents() {
		[
			this._box_con,
			this._img_bg,
			this._img_next_blood,
			this._img_dark_blood,
			this._img_light_blood,
			this._lb_name,
			this._lb_left_blood,
			this._lb_hp,
			this._lb_anger,
			this._lb_vit,
			this._img_head,
			this._box_head,
			this.drop_gp,
			this.drop_lb
		]
			= this.GetChildrenByNames([

				"_box_con",
				"_img_bg",
				"_img_next_blood",
				"_img_dark_blood",
				"_img_light_blood",
				"_lb_name",
				"_lb_left_blood",
				"_lb_hp",
				"_lb_anger",
				"_lb_vit",
				"_img_head",
				"_box_head",
				"drop_gp",
				"drop_lb"
			])
	}
}
window["MainUIHiterBigBloodView"] = MainUIHiterBigBloodView
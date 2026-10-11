import { BaseItem1 } from "../common/BaseItem1"
import { SceneEventType, EventName } from "../common/EventName"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { BaseDungeonModel, DUN_TYPE } from "../commonModel/BaseDungeonModel"
import { MainUIModel } from "../commonModel/MainUIModel"
import { SceneManager } from "../scene/SceneManager"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { Util, GlobalTimerQuest, GetLocalPositionY, GetLocalPositionX, SetHtmlStyle, RefBoxVLayout } from "../util/Util"
import { DungeonDragonDefine } from "./DungeonDragonDefine"
import { DungeonDragonRewardItem } from "./DungeonDragonRewardItem"
import { DungeonDragonSkillItem } from "./DungeonDragonSkillItem"
import { DungeonDragonTowerItem } from "./DungeonDragonTowerItem"
import { Config } from "../common/Config"
import { BossHelpRolePanel } from "../boss/BossHelpRolePanel"
import { SYTweenLite } from "../util/SYTweenLite"
import { MainUIManager } from "../common/MainUIManager"
import { MainUIController } from "../commonController/MainUIController"
import { Scene } from "../scene/Scene"
import { SceneBaseType } from "../scene/SceneConfig"

export class DungeonDragonFightSceneItem extends BaseItem1 {
	CancelAllCountTime
	CancelCountTime
	InitEvent
	LoadSuccess
	StartCountTime
	UpdateDunData
	UpdateJumpData
	UpdateMonsterCount
	UpdateRefreshData
	UpdateSkillData
	UpdateWaveData
	array_reward_
	preload_server_config
	skill_item_list_
	tower_item_list_
	_help_role_panel
	_shape_: Laya.Sprite = null
	CreatShape
	ClearShape
	PrintShape
	tween_list
	show_wave
	time_close
	public static TimeType = { CountDown: 0, NextWaveNum: 1, QuickRefreshNum: 2, JumpLevel: 3 }
	public constructor(parent?) {
		super(parent)

		this.base_file = "dungeonDragon"
		this.layout_file = "DungeonDragonFightSceneItem"
		let base_model = BaseDungeonModel.GetInstance()
		this.preload_client_config = { "ConfigDrageonWaveDesc": false }
		let local_Util = Util
		let scene_mgr = SceneManager.GetInstance()
		let local_Config = Config
		let local_DungeonDragonDefine = DungeonDragonDefine
		let local_DUN_TYPE = DUN_TYPE
		let mainUI_model = MainUIModel.GetInstance()
		let local_MainUIModel = MainUIModel
		let local_laya = Laya
		let local_BaseDungeonModel = BaseDungeonModel
		let local_GlobalEventSystem = GlobalEventSystem
		let local_SceneEventType = SceneEventType
		let local_Message = Message
		let local_DungeonDragonFightSceneItem = DungeonDragonFightSceneItem
		let local_TimeUtil = TimeUtil
		let local_Math = Math
		let data_ = null
		let total_count_ = 0
		this.tower_item_list_ = null
		this.skill_item_list_ = null
		let total_refresh_times_ = null
		let total_refresh_time_ = null
		this.array_reward_ = null

		let wave_desc_cfg_ = null
		let time_id_ = null
		let time_func_ = null
		this.tween_list = []
		this.show_wave = 0
		this.time_close = null

		this.load_callback = () => {
			this._img_jump0.visible = this._lb_jump_level.visible = this._img_jump1.visible = false
			MainUIManager.GetInstance().AddMoveComponent(this, this._box_pos1, false, MainUIManager.MOVE_TYPE.Left)
			MainUIManager.GetInstance().AddMoveComponent(this, this._gp_con1, false, MainUIManager.MOVE_TYPE.Buttom)
			MainUIManager.GetInstance().AddMoveComponent(this, this._gp_refresh, false, MainUIManager.MOVE_TYPE.Right)
			MainUIManager.GetInstance().AddMoveComponent(this, this._gp_next_wave, false, MainUIManager.MOVE_TYPE.Top)
			MainUIManager.GetInstance().AddMoveComponent(this, this._gp_jump_level, false, MainUIManager.MOVE_TYPE.Top)
			MainUIManager.GetInstance().AddMoveComponent(this, this._gp_help_role, false, MainUIManager.MOVE_TYPE.Right)
			MainUIManager.GetInstance().AddMoveComponent(this, this._box_1, false, MainUIManager.MOVE_TYPE.Right)
			MainUIManager.GetInstance().AddMoveComponent(this, this._gp_count_down, false, MainUIManager.MOVE_TYPE.Top)

			this._gp_scroller.vScrollBarSkin = ""
			SetHtmlStyle
			this.LoadSuccess()
		}

		this.preload_server_config = { "config_dungeon_wave_helper": false, "config_dungeon_special_cfg": false }

		this.CreatShape = () => {
			this._shape_ = new Laya.Sprite()
			this._shape_.x = this._img_refresh_mask.width / 2
			this._shape_.y = this._img_refresh_mask.height / 2
			this._img_refresh_mask.mask = this._shape_
		}

		this.ClearShape = () => {
			if (this._shape_ && !this._shape_.destroyed) {
				this._shape_.removeSelf()
				this._shape_.destroy()
				this._shape_ = null
			}
		}

		this.PrintShape = (angle) => {
			if (!this._shape_) return
			angle = 1 - angle
			this._shape_.graphics.clear();
			this._shape_.graphics.drawPie(0, 0, 50, angle * 360 - 90, 360 - 90, 0x000000)
			//this._shape_.graphics.drawPie(0, 0, 50, 90, 360 + 90 - angle * 360, 0x000000)
		}

		this.LoadSuccess = () => {

			this.CreatShape()

			let wave_desc_cfgs = ResManager.GetInstance().GetGameConfigFromCache(this, "ConfigDrageonWaveDesc", true) //Config.ConfigDrageonWaveDesc
			let dun_cfg = Config.ConfigHasDefaultValue.config_dungeon
			let cur_dun_id = scene_mgr.GetCurrDunId()

			wave_desc_cfg_ = wave_desc_cfgs[cur_dun_id]
			let cfg = local_Config.GetConfigVo(local_Config.ConfigHasDefaultValue.config_dungeon.name, cur_dun_id, false, dun_cfg)
			if (cfg) {
				total_count_ = cfg.wave_num - 1
			}
			// let tips = local_DungeonDragonDefine.LevelTips[cur_dun_id]
			// if (tips) {
			// 	this._lb_title2.text = `神纹烙印·${tips}`
			// }


			let special_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_dungeon_special_cfg", false)//Config.Dungeonspecialcfg
			let tower_key = local_DUN_TYPE.Dragon + "@" + local_DungeonDragonDefine.TowerKey

			let towers_cfg = (special_cfg && special_cfg[tower_key]) && special_cfg[tower_key].value
			if (towers_cfg) {
				towers_cfg = JSON.parse(towers_cfg)
				let towers = null
				for (let key in towers_cfg) {

					// [ts2lua]towers_cfg下标访问可能不正确
					let value = towers_cfg[key]
					if (Number(value[0]) == cur_dun_id) {
						towers = value[1]
						break
					}
				}

				table.sort(towers, (a, b) => {
					return a > b
				})

				if (towers) {
					if (!this.tower_item_list_) {
						this.tower_item_list_ = []
					}
					for (let key in towers) {

						let vo = towers[key]
						let item = this.tower_item_list_[key]
						if (!item) {
							item = new DungeonDragonTowerItem(this._gp_towers)
							this.tower_item_list_[key] = item
							item.Load()
						}
						item.SetTwoerTypeId(Number(key), vo)
					}
				}
			}
			let skill_key = local_DUN_TYPE.Dragon + "@" + local_DungeonDragonDefine.SkillKey
			let skills_cfg = (special_cfg && special_cfg[skill_key]) && special_cfg[skill_key].value
			if (skills_cfg) {
				let skills = JSON.parse(skills_cfg)
				if (!this.skill_item_list_) {
					this.skill_item_list_ = []
				}
				for (let key in skills) {
					let vo = skills[key]
					let item = this.skill_item_list_[key]
					if (!item) {
						item = new DungeonDragonSkillItem(this._gp_skills)
						this.skill_item_list_[key] = item
						item.Load()
					}
					item.SetSkillId(vo)
				}
			}
			let quick_create_key = local_DUN_TYPE.Dragon + "@" + local_DungeonDragonDefine.QuickCreateKey
			let quick_create_cfg = (special_cfg && special_cfg[quick_create_key]) && special_cfg[quick_create_key].value
			if (quick_create_cfg) {
				let quick_create = JSON.parse(quick_create_cfg)
				total_refresh_times_ = Number(quick_create[0])
				total_refresh_time_ = Number(quick_create[1])
			}

			this.InitEvent()
			base_model.Fire(local_BaseDungeonModel.SCMD_REQUEST, 61030)
			base_model.Fire(local_BaseDungeonModel.SCMD_REQUEST, 61053)
			base_model.Fire(local_BaseDungeonModel.SCMD_REQUEST, 61055)
			this.UpdateDunData()
			this.UpdateWaveData()
			this.UpdateJumpData()

			this._help_role_panel = new BossHelpRolePanel(this._gp_help_role)
			this._help_role_panel.Load()
			this._help_role_panel.SetVisible(false)
			//this._help_role_panel.SetScale(0.8)

			this.time_close = setTimeout(() => {
				this.PlayAnimClose()
			}, 2000);
		}

		this.InitEvent = () => {
			this.BindEvent(base_model, local_BaseDungeonModel.UPDATE_DUNGEON_INFO, (vo?) => {
				this.UpdateDunData()
			}
			)
			this.BindEvent(base_model, local_BaseDungeonModel.NEXT_WAVE_TIME_INFO, (wave_num?, left_time?) => {
				this.UpdateWaveData(wave_num, left_time)
			}
			)
			this.BindEvent(base_model, local_BaseDungeonModel.UPDATE_DRAGON_SKILL_COUNT, () => {
				this.UpdateSkillData()
			}
			)
			this.BindEvent(base_model, local_BaseDungeonModel.UPDATE_DRAGON_REFRESH_DATA, () => {
				this.UpdateRefreshData()
			}
			)
			this.BindEvent(base_model, local_BaseDungeonModel.UPDATE_DRAGON_JUMP_DATA, () => {
				this.UpdateJumpData()
			}
			)


			this.BindEvent(local_GlobalEventSystem, local_SceneEventType.MONSTER_VO_ADD, (ins_id) => {
				this.UpdateMonsterCount()
			}
			)
			this.BindEvent(local_GlobalEventSystem, local_SceneEventType.MONSTER_VO_REMOVE, (ins_id) => {
				this.UpdateMonsterCount()
			}
			)
			Util.AddClickEvent(this._gp_refresh, () => {
				let data = base_model.GetDragonRefreshData()
				if (data) {
					if (data.quick_count == total_refresh_times_) {
						local_Message.show("刷新次数不足")
						return
					}
					if (local_TimeUtil.getServerTime() <= data.next_quick_time) {
						local_Message.show("冷却时间未到")
						return
					}
					base_model.Fire(local_BaseDungeonModel.SCMD_REQUEST, 61052)
				}
			}
				, this, true)

			Util.AddClickEvent(this._img_rewa, () => {
				if (!this.is_pop) {
					this.PlayAnim(false)
				} else {
					this.PlayAnimClose()
				}
			}, this, true)


		}

		this.UpdateWaveData = (wave_num?, next_wave_time?) => {
			if (wave_num == null || 0 == wave_num) {
				wave_num = 1
			}
			if (next_wave_time == null) {
				next_wave_time = 0
			}
			this._lb_wave_count.text = wave_num + "/" + total_count_
			if (wave_desc_cfg_) {
				// [ts2lua]wave_desc_cfg_下标访问可能不正确
				let cfg = wave_desc_cfg_[wave_num]
				if (cfg) {
					if (!this._gp_con1.visible) {
						this._gp_con1.visible = true
					}
					ResManager.GetInstance().SetOutsideImageSprite(this, this._img_mon_head, GameResPath.GetMonsterHeadPath(cfg.mon_head))
					this._lb_mon_desc.text = cfg.desc //Util.StrToHTML(cfg.desc)
				} else {
					this._gp_con1.visible = false
				}
			}
			let cur_dun_id = scene_mgr.GetCurrDunId()
			let wave_helper_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_dungeon_wave_helper", false)//Config.Dungeonwavehelper
			if (wave_helper_cfg) {
				let wave_helper = null
				let i = wave_num
				do {
					// [ts2lua]wave_helper_cfg下标访问可能不正确
					let cfg = wave_helper_cfg[cur_dun_id + "@" + i]
					if (cfg) {
						let reward_list = JSON.parse(cfg.reward)
						if (reward_list.length > 0) {
							wave_helper = cfg
							break
						}
					}
					i = i + 1
				} while ((i <= total_count_)
				)
				if (wave_helper) {
					this._lb_reward_wave_count.text = `第${wave_helper.wave}波`
					let list = []
					let reward = JSON.parse(wave_helper.reward)
					if (reward && reward.length > 0) {
						for (let _tmpi in reward) {
							var vo = reward[_tmpi]
							table.insert(list, { size: 61, vo: { style: vo[0], typeId: vo[1], count: vo[2] } })
						}
					}

					if (!this.array_reward_) {
						this.array_reward_ = new LoopScrowViewMgr()
						this.array_reward_.SetData(this.Content, DungeonDragonRewardItem, list, LoopScrCon.Horizontal)
					} else {
						this.array_reward_.replaceAll(list)
					}

					if (this.show_wave < wave_helper.wave) {
						//播放一次动画
						if (!this.is_pop) {
							this.PlayAnim(true)
						}
						this.show_wave = wave_helper.wave
					}

				}
			}
			if (next_wave_time > local_TimeUtil.getServerTime()) {
				this._Group1.visible = true
				this.StartCountTime(local_DungeonDragonFightSceneItem.TimeType.NextWaveNum, () => {
					let left_time = next_wave_time - local_TimeUtil.getServerTime()
					if (left_time < 0) {
						this._Group1.visible = false
						this.CancelCountTime(local_DungeonDragonFightSceneItem.TimeType.NextWaveNum)
						return
					}
					this._lb_next_wave_time.text = String(left_time)
				}
					, 1)
			} else {
				this._Group1.visible = false
			}

			RefBoxVLayout(this._box2,0,true)
		}

		this.UpdateDunData = () => {
			let dun_info = base_model.GetDungeonSceneMsg()
			if (dun_info) {
				let end_time = dun_info.end_time
				this.StartCountTime(local_DungeonDragonFightSceneItem.TimeType.CountDown, () => {
					let left_time = end_time - local_TimeUtil.getServerTime()
					if (left_time < 0) {
						this.CancelCountTime(local_DungeonDragonFightSceneItem.TimeType.CountDown)
						return
					}
					this._lb_left_time.text = local_TimeUtil.timeConvert8(left_time)
				}
					, 1)
			}
		}

		this.UpdateRefreshData = () => {
			let data = base_model.GetDragonRefreshData()
			if (data) {
				this._lb_left_refresh_times.text = `剩余${(total_refresh_times_ - data.quick_count)}次`
				let end_time = data.next_quick_time
				this.StartCountTime(local_DungeonDragonFightSceneItem.TimeType.QuickRefreshNum, () => {
					let left_time = end_time * 1000 - local_TimeUtil.getServerTimeMs()
					if (left_time < 0) {
						this.CancelCountTime(local_DungeonDragonFightSceneItem.TimeType.QuickRefreshNum)
						this._lb_refresh_time.text = ""
						this._img_refresh_mask.visible=false
						return
					}
					let left=Math.floor(left_time / 1000)
					this._lb_refresh_time.text = left + "S"

					this._img_refresh_mask.visible=left>0
					this.PrintShape(Math.floor(left/total_refresh_times_*100)/100)
					
					
				}, 0.4)
			}
		}

		this.UpdateJumpData = () => {
			let data = base_model.GetDragonJumpData()
			if (data) {
				if (data.reward_list.length > 0) {
					local_GlobalEventSystem.Fire(EventName.OPEN_VIEW, "DungeonDragonJumpLevelView", data)
				}
				if (data.wave > 0) {
					this._lb_jump_level.text = String(data.wave)
					this._img_jump0.visible = this._lb_jump_level.visible = this._img_jump1.visible = true
					let i = 0
					this.StartCountTime(local_DungeonDragonFightSceneItem.TimeType.JumpLevel, () => {
						i = i + 1
						if (i > 1) {
							this._img_jump0.visible = this._lb_jump_level.visible = this._img_jump1.visible = false
							this.CancelCountTime(local_DungeonDragonFightSceneItem.TimeType.JumpLevel)
						}
					}, 5)
				}
			}
		}



		this.UpdateSkillData = () => {
			let skill_data = base_model.GetDragonSkillData()
			let skill_dic = []
			for (let _tmpi in skill_data) {
				var vo = skill_data[_tmpi]
				// [ts2lua]skill_dic下标访问可能不正确
				skill_dic[vo.skill_id] = vo.num
			}
			for (let _tmpi in this.skill_item_list_) {
				var item = this.skill_item_list_[_tmpi]
				if (item) {
					// [ts2lua]skill_dic下标访问可能不正确
					let num = skill_dic[item.GetSkillId()]
					if (num != null) {
						item.SetNum(num)
					}
				}
			}
		}

		this.StartCountTime = (type?, func?, time?) => {
			if (!time_id_) {
				time_id_ = {}
			}
			if (!time_func_) {
				time_func_ = {}
			}
			this.CancelCountTime(type)
			time_func_[type] = func
			// time_id_[type] = local_laya. new Timer(time * 1000, 0)
			// time_id_[type].addEventListener(local_laya.TimerEvent.TIMER, func, this)
			// time_id_[type].start()
			time_id_[type] = GlobalTimerQuest.AddPeriodQuest(func, time, -1)
			func()
		}

		this.CancelCountTime = (type?) => {
			if (!time_id_ || !time_id_[type]) {
				return
			}
			// time_id_[type].stop()
			// time_id_[type].removeEventListener(local_laya.TimerEvent.TIMER, time_func_[type], this)
			GlobalTimerQuest.CancelQuest(time_id_[type])
			delete time_id_[type]
			delete time_func_[type]
		}

		this.CancelAllCountTime = () => {
			if (time_id_ == null) {
				return
			}
			for (let key in time_id_) {
				let timdId = time_id_[key]
				if (timdId) {
					GlobalTimerQuest.CancelQuest(timdId)
				}
				delete time_id_[key]
			}
			time_id_ = null
			time_func_ = null
		}

		this.UpdateMonsterCount = () => {
			let monster_vo_list = scene_mgr.monster_vo_list
			let len = 0
			if (!Util.IsTableEmpty(monster_vo_list)) {
				for (let key in monster_vo_list) {

					// [ts2lua]monster_vo_list下标访问可能不正确
					let vo = monster_vo_list[key]
					if (vo && vo.warGroup != 99) {
						len = len + 1
					}
				}
			}
			this._gp_left_count.visible = len > 0
			this._lb_left_count.text = String(len)
			RefBoxVLayout(this._box2,0,true)
		}
	}


	public PlayAnim(is_auto) {
		this.ClearTime()
		this._Image_bg2.scaleX = 0
		this.Content.x = -this.Content.width
		let time = 0.3
		table.insert(this.tween_list, SYTweenLite.to(this, this._Image_bg2, SYTweenLite.UiAnimationType.SCALE, { x: 1, y: 1 }, time))
		table.insert(this.tween_list, SYTweenLite.to(this, this.Content, SYTweenLite.UiAnimationType.POSX, 93, time, () => {
			if (is_auto) {
				this.anim_time = setTimeout(() => {
					this.PlayAnimClose()
				}, 2000);
			}
			this.is_pop = true
		}))
	}


	public PlayAnimClose() {
		this.ClearTime()
		let time = 0.3
		table.insert(this.tween_list, SYTweenLite.to(this, this._Image_bg2, SYTweenLite.UiAnimationType.SCALE, { x: 0, y: 1 }, time))
		table.insert(this.tween_list, SYTweenLite.to(this, this.Content, SYTweenLite.UiAnimationType.POSX, -this.Content.width, time, () => {
			this.is_pop = false
		}))
	}

	anim_time = null
	is_pop = false
	is_auto = false //是否是自动弹出 自动弹出自动回收

	public DeleteMe() {
		MainUIManager.GetInstance().RemoveMoveComponent(this)
		this.ClearShape()
		this.ClearTime()
		if (this.tower_item_list_) {
			for (let _tmpi in this.tower_item_list_) {
				var v = this.tower_item_list_[_tmpi]
				v.DeleteMe()
			}
			this.tower_item_list_ = null
		}
		if (this.skill_item_list_) {
			for (let _tmpi in this.skill_item_list_) {
				var v = this.skill_item_list_[_tmpi]
				v.DeleteMe()
			}
			this.skill_item_list_ = null
		}
		if (this._help_role_panel && !this._help_role_panel.use_delete_method) {
			this._help_role_panel.DeleteMe()
		}
		this.CancelAllCountTime()
		if (this.array_reward_) {
			this.array_reward_.DeleteMe()
			this.array_reward_ = null
		}

		super.DeleteMe()
	}

	ClearTime() {
		if (this.time_close) {
			clearTimeout(this.time_close)
			this.time_close = null
		}
		if (this.anim_time) {
			clearTimeout(this.anim_time)
			this.anim_time = null
		}
		if (this.tween_list) {
			for (let _ in this.tween_list) {
				var tween_id = this.tween_list[_]
				SYTweenLite.Stop(tween_id)
			}
			this.tween_list = []
		}
	}



_gp_help_role:Laya.Box
_box_pos1:Laya.Box
_Image_bg2:Laya.Image
Content:Laya.List
_lb_reward_wave_count:Laya.Label
_img_rewa:Laya.Image
_gp_count_down:Laya.Box
_Image1:Laya.Image
_lb_2:Laya.Label
_lb_left_time:Laya.Label
_gp_con1:Laya.Box
_gp_skills:Laya.HBox
_img_mon_bg:Laya.Image
_img_mon_head:Laya.Image
_lb_mon_desc:Laya.Label
_gp_refresh:Laya.Box
_img_refresh:Laya.Image
_img_refresh_mask:Laya.Image
_lb_refresh_time:Laya.Label
_lb_left_refresh_times:Laya.Label
_gp_next_wave:Laya.Box
_Image6:Laya.Image
_box2:Laya.Box
_gp_left_count:Laya.Box
_Image9:Laya.Image
_lb_left_count:Laya.Label
_Group1:Laya.Box
_Image7:Laya.Image
_lb_next_wave_time:Laya.Label
_gp_jump_level:Laya.Box
_img_jump0:Laya.Image
_lb_jump_level:Laya.Label
_img_jump1:Laya.Image
_box_1:Laya.Box
_img_1_1:Laya.Image
_img_1_2:Laya.Image
_lb_wave_count:Laya.Label
_gp_scroller:Laya.Panel
_gp_towers:Laya.VBox
public GetComponents() {
[
this._gp_help_role,
this._box_pos1,
this._Image_bg2,
this.Content,
this._lb_reward_wave_count,
this._img_rewa,
this._gp_count_down,
this._Image1,
this._lb_2,
this._lb_left_time,
this._gp_con1,
this._gp_skills,
this._img_mon_bg,
this._img_mon_head,
this._lb_mon_desc,
this._gp_refresh,
this._img_refresh,
this._img_refresh_mask,
this._lb_refresh_time,
this._lb_left_refresh_times,
this._gp_next_wave,
this._Image6,
this._box2,
this._gp_left_count,
this._Image9,
this._lb_left_count,
this._Group1,
this._Image7,
this._lb_next_wave_time,
this._gp_jump_level,
this._img_jump0,
this._lb_jump_level,
this._img_jump1,
this._box_1,
this._img_1_1,
this._img_1_2,
this._lb_wave_count,
this._gp_scroller,
this._gp_towers,
]
 = this.GetChildrenByNames([

"_gp_help_role",
"_box_pos1",
"_Image_bg2",
"Content",
"_lb_reward_wave_count",
"_img_rewa",
"_gp_count_down",
"_Image1",
"_lb_2",
"_lb_left_time",
"_gp_con1",
"_gp_skills",
"_img_mon_bg",
"_img_mon_head",
"_lb_mon_desc",
"_gp_refresh",
"_img_refresh",
"_img_refresh_mask",
"_lb_refresh_time",
"_lb_left_refresh_times",
"_gp_next_wave",
"_Image6",
"_box2",
"_gp_left_count",
"_Image9",
"_lb_left_count",
"_Group1",
"_Image7",
"_lb_next_wave_time",
"_gp_jump_level",
"_img_jump0",
"_lb_jump_level",
"_img_jump1",
"_box_1",
"_img_1_1",
"_img_1_2",
"_lb_wave_count",
"_gp_scroller",
"_gp_towers",
])
}
}
 window["DungeonDragonFightSceneItem"]= DungeonDragonFightSceneItem
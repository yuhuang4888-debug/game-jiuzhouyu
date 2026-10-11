import { Alert, Alert_Type } from "../alert/Alert"
import { AutoFightManager } from "../autofight/AutoFightManager"
import { BaseView1 } from "../common/BaseView1"
import { EventName, SceneEventType } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { LuaSoundManager, SoundManager } from "../common/SoundManager"
import { table } from "../common/table"
import { WordManager } from "../common/WordManager"
import { HolyBattleModel } from "../commonModel/HolyBattleModel"
import { MainUIModel } from "../commonModel/MainUIModel"
import { NineSkyModel } from "../commonModel/NineSkyModel"
import { RoleManager } from "../commonModel/RoleManager"
import { FightEvent } from "../scene/fight/FightEvent"
import { Scene } from "../scene/Scene"
import { SceneManager } from "../scene/SceneManager"
import { SkillVo } from "../skill/SkillVo"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { Mathf } from "../util/Mathf"
import { Runner } from "../util/Runner"
import { SYTweenLite } from "../util/SYTweenLite"
import { TimeUtil } from "../util/TimeUtil"
import { Util,HtmlColorTxt, GlobalTimerQuest,SetHtmlStyle } from "../util/Util"
import { HolyBattleTargetPanel } from "./HolyBattleTargetPanel"
import { HolyBattleTowerItem } from "./HolyBattleTowerItem"
import { Config } from "../common/Config"
import { CommonManager } from "../common/CommonManager"
import { MainUIManager } from "../common/MainUIManager"
import { PlatformManager } from "../PlatformManager"

export class HolyBattleFightSceneView extends BaseView1 {
	AddRunner
	CancelAllCountDown
	CancelCountDown
	Emp_gp_record
	GetRoleVoList
	InitEvent
	LoadSuccess
	Remove
	RemoveRunner
	SetTagetPanelHide
	StartCountDown
	Update
	UpdateBossAutoFight
	UpdateFightData
	UpdateRewardRed
	UpdateSkillData
	UpdateTime
	UpdateTower
	destroy_callback
	preload_server_config
	tween_list

	public constructor() {
		super()


		this.base_file = "holyBattle"
		this.layout_file = "HolyBattleFightSceneView"
		this.layer_value = Enum_UILayer.Main
		this.tween_list = []
		let local_HolyBattleModel_Instance = HolyBattleModel.GetInstance()
		let local_HolyBattleModel = HolyBattleModel
		let local_EventName = EventName
		let local_GlobalEventSystem = GlobalEventSystem
		let local_MainUIModel_Instance = MainUIModel.GetInstance()
		let local_MainUIModel = MainUIModel
		let local_TimeUtil = TimeUtil
		let local_Runner_Instance = Runner.GetInstance()
		let local_Scene_Instance = Scene.GetInstance()
		let local_RoleManager_Instance = RoleManager.GetInstance()
		let local_SceneManager_Instance = SceneManager.GetInstance()
		let local_WordManager = WordManager
		let _tower_item_list = null
		let _taget_panel = null
		let _hide_activity_view = null
		let _anger_skill_id = null
		let _skill_state = false
		let last_anger = 0
		let voice
		let voice_time

		this.load_callback = () => {
			this._scrollbar.vScrollBarSkin = ""
			SetHtmlStyle(this._lb_score, { f: 18, c: "#5a1c20", w: 200, ww: false })
			SetHtmlStyle(this._lb_camp_rank, { f: 18, c: "#5a1c20", w: 200, ww: false })
			this.LoadSuccess()
		}

		this.destroy_callback = () => {
			this.Remove()
		}
		this.preload_server_config = { "config_role_holy_spirit_battlefield_group": false, "config_holy_spirit_battlefield_kv": false }
		this.LoadSuccess = () => {


			MainUIManager.GetInstance().AddMoveComponent(this, this._gp_time, false, MainUIManager.MOVE_TYPE.Top)
            MainUIManager.GetInstance().AddMoveComponent(this, this._box_1, false, MainUIManager.MOVE_TYPE.Right)
            MainUIManager.GetInstance().AddMoveComponent(this, this._box_2, false, MainUIManager.MOVE_TYPE.Left)
            MainUIManager.GetInstance().AddMoveComponent(this, this._box_3, false, MainUIManager.MOVE_TYPE.Left)
            MainUIManager.GetInstance().AddMoveComponent(this, this._gp_target, false, MainUIManager.MOVE_TYPE.Right)
			MainUIManager.GetInstance().AddMoveComponent(this, this._gp_skill, false, MainUIManager.MOVE_TYPE.Buttom)
			
			if (!_taget_panel) {
				_taget_panel = new HolyBattleTargetPanel(this._gp_target)
				_taget_panel.Load()
			}

			let holy_spirit_battlefield_kv_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_holy_spirit_battlefield_kv", false)//Config.Holyspiritbattlefieldkv
			_anger_skill_id = (holy_spirit_battlefield_kv_cfg && holy_spirit_battlefield_kv_cfg["anger_skill"]) && holy_spirit_battlefield_kv_cfg["anger_skill"].values
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_skill, GameResPath.GetSkillIconPath(_anger_skill_id))
			Util.SetImageGray(this._img_skill, true)
			let skill_vo = new SkillVo(_anger_skill_id)
			this._lb_skill_name.text = skill_vo.getName()

			this.UpdateFightData()
			this.UpdateTower()
			this.UpdateTime()
			this.UpdateRewardRed()
			this.InitEvent()

			local_HolyBattleModel_Instance.Fire(local_HolyBattleModel.REQUEST_PROTO, 21808)
			local_HolyBattleModel_Instance.Fire(local_HolyBattleModel.REQUEST_PROTO, 21811)
			local_HolyBattleModel_Instance.Fire(local_HolyBattleModel.REQUEST_PROTO, 21813)

			//auto_fight_mgr.SetAutoFight(false)
			local_HolyBattleModel_Instance.ResetAutoFight()

			this.AddRunner()

			voice_time=setTimeout(() => {
				voice = CommonManager.GetInstance().PlayFightingVoice(3)
			}, 1200);
			
		}

		this.InitEvent = () => {

			this.BindEvent(local_GlobalEventSystem, local_EventName.WINDOW_RESUME, () => {
				local_HolyBattleModel_Instance.ResetAutoFight()
			}
			)


			this.BindEvent(local_HolyBattleModel_Instance, local_HolyBattleModel.UPDATE_FIGHT_DATA, () => {
				this.UpdateFightData()
			}
			)

			this.BindEvent(local_HolyBattleModel_Instance, local_HolyBattleModel.UPDATE_SKILL_DATA, (cur_anger?) => {
				this.UpdateSkillData(cur_anger)
			}
			)

			this.BindEvent(local_HolyBattleModel_Instance, local_HolyBattleModel.UPDATE_TIME_DATA, () => {
				this.UpdateTime()
			}
			)
			this.BindEvent(local_HolyBattleModel_Instance, local_HolyBattleModel.REFRESH_RED_FLAG, (flag?) => {
				if (flag == local_HolyBattleModel.RedFlag.Open) {

				} else if (flag == local_HolyBattleModel.RedFlag.Reward) {
					this.UpdateRewardRed()
				}

			}
			)
			this.BindEvent(GlobalEventSystem, SceneEventType.ROLE_VO_REMOVE, (instance_id?, monster_vo?) => {
				local_Scene_Instance.SetClickTarget(null)
			}
			)
			this.BindEvent(GlobalEventSystem, SceneEventType.MONSTER_VO_REMOVE, (instance_id?, monster_vo?) => {
				local_Scene_Instance.SetClickTarget(null)
			}
			)
			this.BindEvent(local_GlobalEventSystem, NineSkyModel.NINE_SKY_FIGHTING_MSG, (attack_role_id?) => {
				//BossSceneManager:GetInstance():setSufferedList(attack_role_id)
			}
			)
			this.BindVar(local_RoleManager_Instance.GetMainRoleVo(), "warGroup", () => {
				local_HolyBattleModel_Instance.ResetAutoFight()
			}
			)
			Util.AddClickEvent(this._img_play, () => {
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "HolyBattleInstructionView")
			}
				, this, true)
			Util.AddClickEvent(this._img_close, () => {
				Alert.Show("是否确认退出当前玩法场景?", Alert_Type.Two, () => {
					local_HolyBattleModel_Instance.Fire(local_HolyBattleModel.REQUEST_PROTO, 21803)
				}
					, null, "退出", "取消")
			}
				, this, true, null, null, null, null, LuaSoundManager.SOUND_UI.CLOSE)
			Util.AddClickEvent(this._img_reward, () => {
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "HolyBattleRewardView")
			}
				, this, true)
			Util.AddClickEvent(this._img_blessing, () => {
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "HolyBattleBuffView")
			}
				, this, true)
			Util.AddClickEvent(this._gp_record, () => {
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "HolyBattleRecordView")
			}
				, this, true)
			Util.AddClickEvent(this._img_skill, () => {
				if (_skill_state) {
					local_GlobalEventSystem.Fire(FightEvent.RELEASE_MAIN_SKILL, null, _anger_skill_id)
				} else {
					local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "HolyBattleSkillView", _anger_skill_id)
				}
			}
				, this, true)


			local_MainUIModel_Instance.Fire(local_MainUIModel.CHANGE_ACTIVITY_STATE, false)
		}

		this.UpdateFightData = () => {
			let data = local_HolyBattleModel_Instance.GetFightData()
			if (data) {
				let str1 = `神道排名：${HtmlColorTxt(data.group_rank, "'#00980e'")}`
				let my_group = local_RoleManager_Instance.GetMainRoleVo().warGroup
				if (my_group > 0 && local_HolyBattleModel.GroupName[my_group - 1]) {
					str1 = `${str1}（${local_HolyBattleModel.GroupName[my_group - 1]}）`
				}
				this._lb_camp_rank.innerHTML = str1

				if(PlatformManager.IsEyouPlatform()){
					this._lb_camp_rank.y = 314
					this._lb_camp_rank.style.wordWrap = true
					this._lb_camp_rank.style.leading = 0.1
					this._lb_camp_rank.style.width = 200
				}
				this._lb_score.innerHTML = `我的积分：${HtmlColorTxt(data.point, "'#00980e'")}`

				this.UpdateSkillData(data.anger)

				let attr_vo = data.buff_list && data.buff_list[0]
				if (attr_vo) {
					this._lb_add_attr.text = (attr_vo.attr_id == 22 && "防御" || local_WordManager.GetProperties(attr_vo.attr_id)) + (" + ") + local_WordManager.ConvertToPercentValue(attr_vo.attr_id, attr_vo.value)
				} else {
					this._lb_add_attr.text = "防御+0%"
				}
			}
		}

		this.UpdateSkillData = (cur_anger?) => {
			if (cur_anger == null) { return }
			if (cur_anger - last_anger == -10) {	//不是最新的怒气值
				return
			}
			last_anger = cur_anger

			let holy_spirit_battlefield_kv_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_holy_spirit_battlefield_kv", false)//Config.Holyspiritbattlefieldkv
			let max_anger = (holy_spirit_battlefield_kv_cfg && holy_spirit_battlefield_kv_cfg["max_anger"]) && Number(holy_spirit_battlefield_kv_cfg["max_anger"].values)
			this._lb_anger.text = `（${cur_anger}/${max_anger}）`//"(" + cur_anger + "/" + max_anger + ")"

			_skill_state = cur_anger >= max_anger
			Util.SetImageGray(this._img_skill, !_skill_state)
		}

		this.UpdateTime = () => {
			let time_data = local_HolyBattleModel_Instance.GetTimeData()

			if (time_data && time_data.status == 2) {
				this.StartCountDown(0, () => {
					let left_time = time_data.end_time - local_TimeUtil.getServerTime()
					if (left_time < 0) {
						this.CancelCountDown(0)
						return
					}
					let ter = left_time % 60
					this._lb_last_time.text = `${Mathf.Floor(left_time / 60)}:${(ter < 10 && ("0" + ter) || (ter))}`//Mathf.Floor(left_time / 60) + ":" + (ter < 10 && ("0" + ter) || (ter))
				}
					, 1)
			} else {
				this.CancelCountDown(0)
			}
		}

		this.UpdateTower = () => {
			let holy_spirit_battlefield_kv_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_holy_spirit_battlefield_kv", false)//Config.Holyspiritbattlefieldkv
			let tower_list = holy_spirit_battlefield_kv_cfg && holy_spirit_battlefield_kv_cfg["tower_list"]

			if (tower_list) {
				tower_list = JSON.parse(tower_list.values)
				let list = []
				let item = null
				for (let _tmpi in tower_list) {
					var vo = tower_list[_tmpi]
					table.insert(list,
						{
							mon_list: vo[0],
							x: vo[1],
							y: vo[2]
						})
				}

				//table.sort(list,(a?, b?) => {
				//return a.mon_id < b.mon_id
				//})

				if (!_tower_item_list) {
					_tower_item_list = []
				}

				for (let key in list) {

					item = _tower_item_list[key]
					if (!item) {
						item = new HolyBattleTowerItem(this._gp_tower_con)
						item.Load()
						_tower_item_list[key] = item
					}
					item.SetData(list[key])
				}
			}
		}

		this.UpdateRewardRed = () => {
			let bool = local_HolyBattleModel_Instance.HasRedFlag(local_HolyBattleModel.RedFlag.Reward)
			this._img_reward_red.visible = bool
		}

		this.UpdateBossAutoFight = () => {
			let obj_vo_list = []
			let local_cfg = Config
			let find_count = 1

			let distance = Config.PRELOAD_CLIENT_CONFIG.ConfigTargetAutoFight.Flag["HolyBattleScene"].distance
			//let mon_list = local_Scene_Instance.FindTargets(local_Scene.FIND_TARGET_TYPE.monster, 1, null, distance, null, null, null)

			let mon_list, mon_count
			[mon_list, mon_count] = local_Scene_Instance.FindTargets(Scene.FIND_TARGET_TYPE.monster, 1, null, distance, null, null, null)
			let monster = mon_list[0]
			let monster_vo = (monster && (monster.GetVo()) || (null))

			if (monster_vo) {
				table.insert(obj_vo_list, monster_vo)
			}

			obj_vo_list = obj_vo_list.concat(this.GetRoleVoList())//table.merge(obj_vo_list, this.GetRoleVoList())

			if (obj_vo_list.length > 0) {
				if (!_hide_activity_view && local_MainUIModel_Instance.activity_icon_in_show) {
					local_MainUIModel_Instance.Fire(local_MainUIModel.CHANGE_ACTIVITY_STATE, false)
				}
				_taget_panel.setData(obj_vo_list)
				_hide_activity_view = true
				this.SetTagetPanelHide(true)
			} else {
				_hide_activity_view = false
				this.SetTagetPanelHide(false)
			}
		}

		this.SetTagetPanelHide = (bool?) => {
			if (_taget_panel && _taget_panel.visible != bool) {
				_taget_panel.SetVisible(bool)
			}
		}

		this.GetRoleVoList = () => {
			let main_role_vo = local_RoleManager_Instance.GetMainRoleVo()
			let main_role_id = local_RoleManager_Instance.GetMainRoleId()
			let list = []
			let role_vo_list = local_SceneManager_Instance.GetAllRoleVos()

			for (let role_id in role_vo_list) {

				let role_vo = role_vo_list[role_id]
				let can_show = true
				if (role_vo.hp == 0 || role_vo.warGroup == main_role_vo.warGroup) {
					can_show = false
				}
				if (can_show) {
					if (role_id != String(main_role_id)) {
						table.insert(list, role_vo)
					}
				}

			}
			return list
		}

		let time_id_ = null
		this.StartCountDown = (type?, func?, time?) => {
			if (!time_id_) {
				time_id_ = []
			}
			this.CancelCountDown(type)
			time_id_[type] = GlobalTimerQuest.AddPeriodQuest(func, time, -1)
			func()
		}

		this.CancelCountDown = (type?) => {
			if (!time_id_ || !time_id_[type]) {
				return
			}
			GlobalTimerQuest.CancelQuest(time_id_[type])
			delete time_id_[type]
		}

		this.CancelAllCountDown = () => {
			if (!time_id_) {
				return
			}
			for (let key in time_id_) {

				GlobalTimerQuest.CancelQuest(time_id_[key])
				delete time_id_[key]
			}
			time_id_ = null
		}

		let _update_times_index = 0
		let _update_id = null
		this.Update = (now_time?, elapse_time?) => {
			_update_times_index = _update_times_index + 1

			if (_update_times_index % 20 == 0) {
				this.UpdateBossAutoFight()
			}
		}

		this.AddRunner = () => {
			local_Runner_Instance.AddRunObj(this)
		}

		this.RemoveRunner = () => {
			local_Runner_Instance.RemoveRunObj(this.hashCode)
		}

		this.Remove = () => {
			MainUIManager.GetInstance().RemoveMoveComponent(this)
			if(voice_time){
				clearTimeout(voice_time)
				voice_time=null
			}

			if(voice){
				SoundManager.GetInstance().StopSoundEffect(voice)
				voice=null
			}

			if (_tower_item_list) {
				for (let _tmpi in _tower_item_list) {
					var obj = _tower_item_list[_tmpi]
					obj.DeleteMe()
				}
				_tower_item_list = null
			}
			if (_taget_panel) {
				_taget_panel.DeleteMe()
			}
			this.RemoveRunner()
			this.CancelAllCountDown()
			if (this.tween_list && this.tween_list.length > 0) {
				for (let key in this.tween_list) {
					var tween_id = this.tween_list[key]
					SYTweenLite.Stop(tween_id)
				}
			}
		}


	}

	public DeleteMe() {

		super.DeleteMe()
	}


_gp_time:Laya.Box
_img_bg:Laya.Image
_Image2:Laya.Image
_lb_last_time:Laya.Label
_box_1:Laya.Box
_gp_right:Laya.Box
_img_blessing:Laya.Image
_lb_add_attr:Laya.Label
_img_reward:Laya.Image
_img_reward_red:Laya.Image
_img_play:Laya.Image
_box_2:Laya.Box
_gp_left:Laya.Box
_img_bg1:Laya.Image
_Label1:Laya.Label
_Image3:Laya.Image
_lb_score:Laya.HTMLDivElement
_lb_camp_rank:Laya.HTMLDivElement
_gp_record:Laya.Box
_Image5:Laya.Image
_Label2:Laya.Label
_scrollbar:Laya.Panel
_gp_tower_con:Laya.VBox
_box_3:Laya.Box
_img_close:Laya.Image
_gp_target:Laya.Box
_gp_skill:Laya.Box
_Image7:Laya.Image
_img_skill:Laya.Image
_Image8:Laya.Image
_lb_skill_name:Laya.Label
_lb_anger:Laya.Label
public GetComponents() {
[
this._gp_time,
this._img_bg,
this._Image2,
this._lb_last_time,
this._box_1,
this._gp_right,
this._img_blessing,
this._lb_add_attr,
this._img_reward,
this._img_reward_red,
this._img_play,
this._box_2,
this._gp_left,
this._img_bg1,
this._Label1,
this._Image3,
this._lb_score,
this._lb_camp_rank,
this._gp_record,
this._Image5,
this._Label2,
this._scrollbar,
this._gp_tower_con,
this._box_3,
this._img_close,
this._gp_target,
this._gp_skill,
this._Image7,
this._img_skill,
this._Image8,
this._lb_skill_name,
this._lb_anger,
]
 = this.GetChildrenByNames([

"_gp_time",
"_img_bg",
"_Image2",
"_lb_last_time",
"_box_1",
"_gp_right",
"_img_blessing",
"_lb_add_attr",
"_img_reward",
"_img_reward_red",
"_img_play",
"_box_2",
"_gp_left",
"_img_bg1",
"_Label1",
"_Image3",
"_lb_score",
"_lb_camp_rank",
"_gp_record",
"_Image5",
"_Label2",
"_scrollbar",
"_gp_tower_con",
"_box_3",
"_img_close",
"_gp_target",
"_gp_skill",
"_Image7",
"_img_skill",
"_Image8",
"_lb_skill_name",
"_lb_anger",
])
}
}
 window["HolyBattleFightSceneView"]= HolyBattleFightSceneView
import { Alert, Alert_Type } from "../alert/Alert"
import { AutoFightManager } from "../autofight/AutoFightManager"
import { BaseItem1 } from "../common/BaseItem1"
import { Config } from "../common/Config"
import { EventName } from "../common/EventName"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { BossSceneEvent, BossSceneManager } from "../commonController/BossSceneManager"
import { BossModel } from "../commonModel/BossModel"
import { GuildEvent, GuildModel } from "../commonModel/GuildModel"
import { TaskModel } from "../commonModel/TaskModel"
import { PlatformManager } from "../PlatformManager"
import { RoleManager } from "../commonModel/RoleManager"
import { Scene } from "../scene/Scene"
import { SceneBaseType } from "../scene/SceneConfig"
import { SceneManager } from "../scene/SceneManager"
import { FindVo } from "../scene/sceneobj/FindVo"
import { SceneObj } from "../scene/sceneobj/SceneObj"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameMath } from "../util/GameMath"
import { SYTweenFunc } from "../util/SYTweenFunc"
import { SYTweenLite } from "../util/SYTweenLite"
import { GlobalTimerQuest, HtmlColorTxt, SetAnchoredPosition, SetLocalScaleX, SetSizeDeltaX, SetSizeDeltaY, Util } from "../util/Util"
import { BossWayTaskItem } from "./BossWayTaskItem"
import { BossSuitExit } from "../bossSuit/BossSuitExit"
import { BossInstructionView } from "./BossInstructionView"
import { KaifuActivityModel } from "../commonModel/KaifuActivityModel"
import { TimeUtil } from "../util/TimeUtil"

export class BossWayFindingItem extends BaseItem1 {
	boss_info
	boss_pos_list
	is_first
	tween_id_list
	is_moving
	move_interval
	show_state
	progress_width

	base_type
	now_type

	assist_dic
	assist_data
	need_special_operate
	cache_value
	selectVo

	scene: Scene
	boss_model: BossModel
	scene_mgr: SceneManager
	task_model: TaskModel
	boss_scene_mgr: BossSceneManager
	auto_fight_mgr: AutoFightManager
	role_mgr: RoleManager
	guild_model: GuildModel
	res_mgr: ResManager

	time1
	time2
	time3

	boss_type
	need_refresh_data
	select_index
	item_loop_mgr: LoopScrowViewMgr
	task_item_list
	boss_data
	max_anger
	boss_suit_exit_view
	tired_need
	boss_vo
	public constructor(parent?) {
		super(parent)
		this.base_file = "boss"
		this.layout_file = "BossWayFindingItem"

		this.boss_info// 场景boss 信息
		this.boss_pos_list //场景Boss位置
		this.is_first = true //第一次打开界面
		this.tween_id_list = false //移动动画事件列表
		this.is_moving = false // 正在移动
		this.move_interval = 0.2 // 移动间隔
		this.show_state = true //界面显示状态
		this.progress_width = 120 // 进度条长度
		this.tired_need = null
		this.boss_vo = null
		this.base_type = {
			boss: 1,
			damage: 2,
		}
		this.now_type = this.base_type.boss

		this.assist_dic = []
		this.assist_data = null

		this.scene = Scene.GetInstance()
		this.boss_model = BossModel.GetInstance()
		this.scene_mgr = SceneManager.GetInstance()
		this.task_model = TaskModel.GetInstance()
		this.boss_scene_mgr = BossSceneManager.GetInstance()
		this.auto_fight_mgr = AutoFightManager.GetInstance()
		this.role_mgr = RoleManager.GetInstance()
		this.need_special_operate = false
		this.guild_model = GuildModel.GetInstance()
		this.res_mgr = ResManager.GetInstance()

		this.preload_client_config = {
			"ClientBossInstruction": false
		}

		this.preload_server_config = {
			"config_boss_type": false,
			"config_eudemons_boss_cfg": false
		}

		this.load_callback = () => {
			this.SetContentH()
			this.LoadSuccess()
		}
	}

	public ShowInstruction() {
		let boss_instruction_cfg = this.res_mgr.GetGameConfigFromCache(this, "ClientBossInstruction")
		if (boss_instruction_cfg && boss_instruction_cfg[this.boss_type]) {
			this._img_Instruction.visible = true
		} else {
			this._img_Instruction.visible = false
		}
	}
	public SetContentH() {
		let scene_id = this.scene_mgr.GetSceneId()
		if (this.scene_mgr.IsHolyTerritory()) {
			// this._list_item.height = 190
			// this._list_item.repeatY = 10
		} else if (this.scene_mgr.IsAbyssBossScene(scene_id)) {
			this._list_item.height = 235
			this._box_con2.mouseThrough = true
		}
	}

	public SetData(type?, boss_info?, boss_pos_list?) {
		this.boss_info = boss_info
		this.boss_pos_list = boss_pos_list
		this.boss_type = type
		if (this.is_loaded) {
			this.UpdateItem()
			// if (this.time1) {
			// 	clearTimeout(this.time1)
			// 	this.time1 = null
			// }
			this.time1 = setTimeout(() => {
				if (this.use_delete_method) { return }
				if (this.boss_model.get_eudamon_task) {
					this.SwitchType(this.base_type.damage)
					this.boss_model.DoEudaemonTask()
					BossModel.GetInstance().Fire(BossModel.SELECT_TASK_TEAM_VIEW, 2)
				}
				if (this.boss_model.find_cry_stal) {
					this.SwitchType(this.base_type.damage)
					this.boss_model.Fire(BossModel.COLLECT_BOX, BossModel.CRYSTAL_TYPE)
					this.boss_model.find_cry_stal = null
					BossModel.GetInstance().Fire(BossModel.SELECT_TASK_TEAM_VIEW, 2)
				}
			}, 1)
		} else {
			this.is_first = false
			this.need_refresh_data = true
		}
	}

	public UpdateItem() {
		if (this.is_first) {
			this.is_first = false
			this.InitSelectIndex()
			this.UpdateViewInfo()
			if (!this.boss_scene_mgr.relive_success && !this.boss_scene_mgr.return_safe_success && !this.boss_model.reconnect) {
				this.Pathfinding(this.select_index, true, false)
			}
			this.ShowInstruction()
			this.UpdateScrollItem()

			this.item_loop_mgr.CenterOnChild(this.select_index)
			this.item_loop_mgr.SetSelectIndex(this.select_index, false)

		} else {
			this.UpdateScrollItem()
			this.item_loop_mgr.CenterOnChild(this.select_index)
		}
	}

	public InitSelectIndex() {
		this.select_index = 0
		if (this.boss_model.last_scene_id && this.boss_model.last_scene_id == this.scene_mgr.scene_Info.id) {
			return
		}
		this.boss_model.last_scene_id = this.scene_mgr.scene_Info.id
		let enter_info = this.boss_model.GetEnterBossInfo()
		this.need_special_operate = true
		if (enter_info) {
			let boss_id = enter_info.boss_id
			for (let key in this.boss_info) {
				let vo = this.boss_info[key]
				if (vo.boss_id == boss_id) {
					this.need_special_operate = false
					this.select_index = Number(key)
					break
				}
			}
		}
	}

	public LoadSuccess() {
		this._html_er_tired.style.color = "#ffffff"
		this._html_er_tired.style.fontSize = 20
		this._html_er_tired.style.wordWrap = false

		if (this.need_refresh_data) {
			this.SetData(this.boss_type, this.boss_info, this.boss_pos_list)
			this.need_refresh_data = false
		}
		this.assist_data = this.guild_model.GetAssistData()

		this._list_item.mouseHandler = new Laya.Handler(this, this.ListMouseHander)
		// let width = this.scene_mgr.IsAbyssBossScene() && 260 || 240
		// SetSizeDeltaY(this._Group2, width)

		this.InitEvent()
	}

	public ListMouseHander = (e: Laya.Event, index) => {
		if (e.type == Laya.Event.CLICK)
			this.SwitchBoss(index)
	}

	public UpdateScrollItem() {
		let item_class = window["BossWayFindingSubItem"]
		if (!item_class) return
		if (!this.item_loop_mgr) {
			this.item_loop_mgr = new LoopScrowViewMgr()
			this.item_loop_mgr.SetData(this._list_item, item_class, this.boss_info, LoopScrCon.Vertical, null, (index) => {
			}, this.select_index)
		}
		else {
			this.item_loop_mgr.replaceAll(this.boss_info)
		}
	}

	public UpdateViewInfo() {
		if (!this.boss_info || this.boss_info.length <= 0) {
			return
		}

		if (this.scene_mgr.IsSuitBossScene()) {
			this._box_tired.visible = true
			this._img_Instruction.visible = true
			this._box_er_tired.visible = false
			//this._title_gp.visible = true 
			let layer = this.boss_info[1].layer
			this._lb_pl.text = "疲劳值"
		} else if (this.scene_mgr.IsFieldBossScene() || this.scene_mgr.IsFieldSpecialBossScene()|| this.scene_mgr.IsFieldInfiniteBossScene()) {
			this._box_tired.visible = true
			this._box_er_tired.visible = false
			//this._title_gp.visible = true 
			this._box_progress.visible = false
			this.tired_need = 20
			let layer = this.boss_info[0].layer
			this._lb_pl.text = layer == 0 ? "无限层不消耗体力" :"当前体力值:"
			this._lb_progress.visible = this._img_add_vit.visible = (layer != 0)
			//this._img_add_vit.visible = true
		} else if (this.scene_mgr.IsAbyssBossScene()) {
			this._box_tired.visible = false
			this._box_er_tired.visible = false
			//this._title_gp.visible = true 
			this._box_progress.visible = false
			let layer = this.boss_info[0].layer
			let layerUrl = Number(layer) == 0 && "0_1" || layer
		} else if (this.scene_mgr.IsHolyTerritory()) {
			this._box_tired.visible = false
			this._box_er_tired.visible = false
			this._img_Instruction.visible = false
			let layer = this.boss_info[0].layer
		} else if (this.scene_mgr.IsHolyBossScene()) {
			this._box_er_tired.visible = true
			this._box_tired.visible = false
			let layer = this.boss_info[1].layer
			this.UpdateERTired()
		} else if (this.scene_mgr.IsMysteryBossScene()) {
			this._box_tired.visible = true
			this._box_er_tired.visible = false
			//this._title_gp.visible = true 
			this._box_progress.visible = true
			let layer = this.boss_info[1].layer
		}
		else if (this.scene_mgr.IsCrossWuxianBossScene()) {
			this._box_er_tired.visible = true
			this._box_tired.visible = true
			let layer = this.boss_info[1].layer
			this._lb_pl.text = "无限层不消耗体力"
			this._box_progress.visible = false
			this._lb_progress.visible = this._img_add_vit.visible = false
		}
	}

	public SetProgress(value?, max?) {
		if ((!value && value != 0) || !max || ((this.cache_value && value == 0 && !this.scene_mgr.IsFieldBossScene()&& !this.scene_mgr.IsFieldInfiniteBossScene()) && !this.scene_mgr.IsSuitBossScene())) {
			return
		}
		this.cache_value = value
		value = Math.max(0, value)


		this._lb_progress.text = value + "/" + max
		this._img_progress_bar.width = value / max * this.progress_width
		if (this.scene_mgr.IsFieldBossScene()||this.scene_mgr.IsFieldInfiniteBossScene()) {
			this._lb_progress.x=(this._lb_pl.x+this._lb_pl.textField.textWidth+2)+this._lb_progress.width*this._lb_progress.anchorX
		}else{
			this._lb_progress.x=122.5
		}
	}

	public DeleteMe() {
		this.ClearTimer()

		this.is_first = true
		this.select_index = null

		if (this.boss_model.reconnect) {
			this.boss_model.reconnect = false
		}

		////////
		if (this.tween_id_list) {
			for (let _ in this.tween_id_list) {
				var key = this.tween_id_list[_]
				SYTweenLite.Stop(key)
			}
			this.tween_id_list = false
		}

		if (this.item_loop_mgr) {
			this.item_loop_mgr.DeleteMe()
			this.item_loop_mgr = null
		}

		if (this.task_item_list) {
			for (let _ in this.task_item_list) {
				var vo = this.task_item_list[_]
				vo.DeleteMe()
			}
			this.task_item_list = null
		}
		if (this.time3) {
			clearTimeout(this.time3)
			this.time3 = null
		}
		if (this.time2) {
			clearTimeout(this.time2)
			this.time2 = null
		}
		if (this.time1) {
			clearTimeout(this.time1)
			this.time1 = null
		}
		super.DeleteMe()
	}

	public SwitchBoss(index?) {
		// this._list_item["_selectedIndex"] = -1
		this.Pathfinding(index)
	}

	public Pathfinding(index?, showTired?, showAlert?) {

		if (showTired == null) {
			showTired = true
		}
		if (showAlert == null) {
			showAlert = true
		}
		if (index == null) {
			return
		}
		let end_pos = null
		this.boss_vo = null
		if (this.need_special_operate) {  //特殊处理逻辑
			this.need_special_operate = false
			if (this.scene_mgr.IsMysteryBossScene()) {
				let enter_info = this.boss_model.GetEnterBossInfo()
				if (enter_info) {
					let boss_id = enter_info.boss_id
					let eudemons_boss_cfg = this.res_mgr.GetGameConfigFromCache(this, "config_eudemons_boss_cfg", false)
					let boss_cfg = this.res_mgr.GetGameConfigFromCache(this, "config_boss_cfg", false)
					end_pos = this.boss_model.GetBossPos(boss_id, BossModel.BossType.mystery, eudemons_boss_cfg, boss_cfg)
					this.boss_vo = this.boss_model.GetBossInfo(BossModel.BossType.mystery, boss_id)
				}
			}
		} else {
			this.boss_vo = this.boss_info[index]
			if (this.boss_vo && this.boss_vo.suit_mon) {
				end_pos = this.boss_vo.pos
			} else {
				end_pos = this.boss_pos_list[index]
			}
		}

		if (!end_pos) {
			return
		}

		let cancel_func = () => {
			if (this.select_index != index) {
				if (this.use_delete_method) {
					return
				}
				this.ChangeScrollV(this.select_index)
				this.item_loop_mgr.SetSelectIndex(this.select_index, false)
			}
		}
		let okFun = () => {

			let show = !this.assist_data && showTired
			this.selectVo = this.boss_info[this.select_index]
			// this.boss_scene_mgr.JudgeTired(show, this.selectVo.boss_type, this.boss_vo && this.boss_vo.boss_id || 0)
			let real_x = end_pos.x / SceneObj.GetLogicRealRatio().x
			let real_y = end_pos.y / SceneObj.GetLogicRealRatio().y

			let set_target = () => { //判断目标BOSS是否在范围内，如果没有就寻路
				let boss = this.scene.GetMonsterByTypeId(this.boss_vo.boss_id)
				let main_role_vo = this.role_mgr.GetMainRoleVo()
				if (boss && GameMath.GetDistance(main_role_vo.pos_x, main_role_vo.pos_y, boss.real_pos.x, boss.real_pos.y) <= 300 * 300) {
					if (!this.boss_scene_mgr.JudgeTired(false, null, boss.vo.type_id)) { //|| HolyTerritoryModel.GetInstance().SelfHT
						return
					}
					this.scene.clearGoToData()
					this.scene.SetClickTarget(boss)
					this.auto_fight_mgr.SetAutoFight(true)
					this.boss_scene_mgr.SetAutoState(true)
					this.boss_model.Fire(BossModel.FINDWAY_INDEX, index)
					this.boss_scene_mgr.SetAttackTarget(boss)
					return true
				}
				return false
			}

			let move = () => {
				this.select_index = index
				this.auto_fight_mgr.SetAutoFight(true)
				this.boss_scene_mgr.SetAutoState(true)
				this.boss_model.Fire(BossModel.FINDWAY_INDEX, index)

				let findVo = new FindVo()
				findVo.type = FindVo.MONSTER
				findVo.sceneId = this.scene_mgr.GetSceneId()
				findVo.id = this.boss_vo.boss_id
				findVo.x = real_x
				findVo.y = real_y
				findVo.range = 5
				this.scene.FindElement(findVo)
			}

			if (this.boss_vo) {
				let boss_cfg = null
				if (this.boss_model.IsCrossServerBoss(this.boss_vo.boss_type)) {
					let cfgs = this.res_mgr.GetGameConfigFromCache(this, "config_eudemons_boss_cfg", false)
					boss_cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_eudemons_boss_cfg.name, this.boss_vo.boss_id, false, cfgs)
				} else {
					let cfgs = ResManager.GetInstance().GetGameConfigFromCache(this, "config_boss_cfg", false)
					boss_cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_boss_cfg.name, this.boss_vo.boss_id, false, cfgs)
				}
				if (!boss_cfg) {
					if (this.boss_vo && this.boss_vo.suit_mon) {
						if (set_target() == false) {
							move()
						}
					}
					return
				}
				let drop_lv = boss_cfg.drop_lv
				let level = this.role_mgr.GetMainRoleVo().level
				if ((!this.assist_data && drop_lv != 0) && level - this.boss_vo.lv >= drop_lv) {
					Alert.Show(
						"与该大妖等级差距过大，击杀无奖励。<br>是否前往击杀？",
						Alert_Type.Two, () => {
							if (set_target() == false) {
								move()
								if(this.boss_vo&&this.boss_vo.boss_id>0){
									this.boss_scene_mgr.JudgeTired(show, this.boss_vo.boss_type, this.boss_vo.boss_id)
								}
							}
						},
						cancel_func,
						"确定",
						"取消"
					)
				} else {
					if (set_target() == false) {
						move()
						if(this.boss_vo&&this.boss_vo.boss_id>0){
							this.boss_scene_mgr.JudgeTired(show, this.boss_vo.boss_type,this.boss_vo.boss_id)
						}
					}
				}
			}
		}
		if (this.boss_vo) {
			if (!this.assist_data && showAlert) {
				let high_level = (this.boss_vo.boss_type == BossModel.BossType.field||this.boss_vo.boss_type == BossModel.BossType.field_infinite )
				&& BossModel.FIELD_HIGT_LEVEL_TIPS_VALUE 
				|| BossModel.HIGT_LEVEL_TIPS_VALUE
				if (this.boss_vo.lv - this.role_mgr.GetMainRoleVo().level >= high_level) {
					Alert.Show("该大妖等级较高，挑战可能比较困难。<br>是否继续前往？", Alert_Type.Two, okFun, cancel_func, "前往", "取消")
					return
				}
			}
		}
		okFun()
	}

	public SwitchType(type?) {

		if (type == this.now_type) { return }
		this.now_type = type

		this.ChangeScrollV(this.select_index)

		if (this.scene_mgr.IsHolyBossScene() || this.scene_mgr.IsCrossWuxianBossScene()) {
			if (type == this.base_type.damage) {
				this.SetTask(true)
			} else {
				this.SetTask(false)
			}
		}

		this.UpdateScrollItem()
	}

	public ChangeScrollV(select_index?) {

	}

	public SetTiredStatus(id?) {
		if (!this.scene_mgr.IsHolyTerritory()) {
			return
		}
		let bool = false
		if (id && this.scene_mgr.IsHolyTerritory()) {
			let cfgs = ResManager.GetInstance().GetGameConfigFromCache(this, "config_boss_cfg", false)
			let config = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_boss_cfg.name, id, false, cfgs)
			if (config && config.sign == 1) {
				bool = true
			}
		}
		this._box_tired.visible = bool
		//this._box_con2.mouseThrough = !bool
		this._box_con2.mouseEnabled = bool
		if (bool) {
			this._list_item.height = 190
			//this._list_item.repeatY = 7
		}
		else {
			this._list_item.height = 235
			//this._list_item.repeatY = 8
		}
		this._img_Instruction.visible = bool
	}

	public SetBossData(data?) {
		this.boss_data = data
	}

	public InitEvent() {
		this.BindEvent(this.boss_model, BossModel.KILL_BOSS, (scmd?) => {
			if (this.boss_info) {
				for (let _tmpi in this.boss_info) {
					var data = this.boss_info[_tmpi]
					if (data.boss_id == scmd.boss_id) {
						data.reborn_time = scmd.reborn_time
						this.UpdateScrollItem()
						if (this.time3) {
							clearTimeout(this.time3)
							this.time3 = null
						}
						this.time3 = setTimeout(() => {
							if (this.use_delete_method) { return }
							this.ChangeScrollV(this.select_index)
						}, 0.2)
						return
					}
				}
			}
		}
		)

		this.BindEvent(this.boss_model, BossModel.UPDATE_BOSS_INFO, (scmd?) => {
			if (!this.boss_info || !this.boss_info[0]) {
				return
			}
			if (scmd != this.boss_info[0].boss_type) {
				return
			}
			let info = this.boss_model.GetBossTypeInfo(scmd)
			if (!info) {
				return
			}
			for (let _tmpi in this.boss_info) {
				var data = this.boss_info[_tmpi]
				for (let _tmpi in info.boss_info) {
					var v = info.boss_info[_tmpi]
					if (data.boss_id == v.boss_id) {
						data.reborn_time = v.reborn_time
						this.UpdateScrollItem()
					}
				}
			}
		}
		)

		this.BindEvent(this.boss_model, BossModel.CHANGE_BOSS_TARGET, (attackObj?, id?, showAlert?) => {
			if (showAlert == null) {
				showAlert = true
			}
			let select_index = null
			if ((attackObj && attackObj._type == SceneBaseType.Monster) && attackObj.vo) {
				select_index = this.boss_scene_mgr.FindBossIndexById(this.boss_info, attackObj.vo.type_id)
			} else if (!attackObj && id) {
				select_index = this.boss_scene_mgr.FindBossIndexById(this.boss_info, id)
			}
			if (select_index != null) {
				//this.select_index = select_index
				this.Pathfinding(select_index, showAlert, false)
				this.ChangeScrollV(select_index)
				this.item_loop_mgr.SetSelectIndex(select_index)
			}
			if (this.scene_mgr.IsMysteryBossScene() && (this.boss_model.IsSpecialBoss(id) || this.boss_model.IsBoxByBossId(id))) {
				this.boss_model.Fire(BossModel.START_SPECIAL_BOSS_OR_BOX_FIND, id)
			}
		})

		//MAIN_ROLE_CHANGE_ATTACK_TARGRT

		this.BindEvent(GlobalEventSystem, EventName.MAIN_ROLE_CHANGE_ATTACK_TARGRT, (target?) => { //更新选中数据（包括点击BOSS、自动战斗的选取）
			let obj_type = target && target._type
			if (target == null) {
				this.selectVo = null
			}
			if ((!target || !obj_type) || obj_type != SceneBaseType.Monster) {
				return
			}
			let select_index = null
			if ((obj_type && obj_type == SceneBaseType.Monster) && target.vo) {
				select_index = this.boss_scene_mgr.FindBossIndexById(this.boss_info, target.vo.type_id)
			}
			if (select_index != null && this.select_index != select_index && (!this.selectVo || this.selectVo && this.selectVo.boss_id != target.vo.type_id)) {
				this.ChangeScrollV(select_index)
				this.item_loop_mgr.SetSelectIndex(select_index, false)
				this.select_index = select_index
				//this:Pathfinding(select_index)
			}
		})

		this.BindEvent(GlobalEventSystem, EventName.ATTACK_CLICK_MON, (target?) => { //boss寻路（只有点击BOSS才会调用）
			let obj_type = target && target._type
			if ((!target || !obj_type) || obj_type != SceneBaseType.Monster) {
				return
			}
			let select_index = null
			if ((obj_type && obj_type == SceneBaseType.Monster) && target.vo) {
				select_index = this.boss_scene_mgr.FindBossIndexById(this.boss_info, target.vo.type_id)
			}
			if (select_index != null && (!this.selectVo || this.selectVo && this.selectVo.boss_id != target.vo.type_id)) {
				this.Pathfinding(select_index)
			}
		})

		this.BindEvent(this.guild_model, GuildEvent.HELP_SUCCESS, (scmd?) => {
			this.assist_data = this.guild_model.GetAssistData()
		})

		this.BindEvent(this.guild_model, GuildEvent.CANCEL_HELP_SUCCESS, (scmd?) => {
			this.assist_data = this.guild_model.GetAssistData()
		})

		if (this.scene_mgr.IsHolyTerritory()) {
			this.BindEvent(HolyTerritoryModel.GetInstance(), HTEvent.FATIGUE, (fatigue?, max?) => {
				if (this.is_loaded) {
					this.SetProgress(fatigue, max)
				}
			})
		}

		Util.AddClickEvent(this._img_Instruction, () => {
			new BossInstructionView().Open(this.boss_type)
		}, this, true)

		Util.AddClickEvent(this._img_add_vit, (e) => {
			this.boss_model.Fire(BossModel.OPEN_BOSS_TIRED_ALERT)
			//BossModel.GetInstance().Fire(BossModel.OPEN_VIT_VIEW, e.stageX, e.stageY)
		}, this, true)

		// this.taskGp.addEventListener(local_eui.ItemTapEvent.ITEM_TAP, (e?, a?) => {
		// 	if (e) {
		// 		if (e.item.ClickFunc) {
		// 			e.item.ClickFunc()
		// 		} else {
		// 			let item = this.taskGp.tsvar_children[e.itemIndex]
		// 			if (item) {
		// 				item["ClickFunc"]()
		// 			}
		// 		}
		// 	}
		// }, this
		// )

		if (this.scene_mgr.IsHolyBossScene()) {
			this.BindEvent(this.boss_model, BossModel.UPDATE_ER_TIRED_VALUE, (value?) => {
				if (this.is_loaded) {
					this.UpdateERTired(value)
				}
			}
			)

			let taskData = this.boss_model.GetEudaemonTask()
			if (!this.task_item_list) {
				this.task_item_list = []
			}
			let index = (this.boss_model.find_cry_stal && taskData.length > 1) && 2 || 1
			for (let i = 0; i < taskData.length; i++) {
				let item = this.task_item_list[i]
				if (!item) {
					item = new BossWayTaskItem(this._panel_task)
					item.Load()
					item.SetPosition(0, Number(i) * 82)
					this.task_item_list[i] = item
				}
				item.SetData(taskData[i], i)
				if (i == index) {
					item.SetSelect(true)
				}
			}

			let updateFunc = () => {
				if (this.use_delete_method) {
					return
				}
				let taskData = this.boss_model.GetEudaemonTask()
				if (!this.task_item_list) {
					this.task_item_list = []
				}
				for (let i = 0; i < taskData.length; i++) {
					let item = this.task_item_list[i]
					if (!item) {
						item = new BossWayTaskItem(this._panel_task)
						item.SetPosition(0, Number(i) * 82)
						item.Load()
						this.task_item_list[i] = item
					}
					item.SetData(taskData[i], i)
				}
				for (let i = taskData.length; i < this.task_item_list.length; i++) {
					let item = this.task_item_list[i]
					if (item) {
						item.SetVisible(false)
					}
				}
			}
			this.BindEvent(this.task_model, TaskModel.UPDATE_ONE_TASK, updateFunc)
			this.BindEvent(this.task_model, TaskModel.UPDATE_ALL_TASK_FROM_30000, updateFunc)
		}

		if (this.scene_mgr.IsSuitBossScene() || this.scene_mgr.IsMysteryBossScene()) {
			this.BindEvent(this.boss_scene_mgr, BossSceneEvent.UPDATE_SUIT_ANGER, (anger?, _max_anger?) => {
				let cfgs = this.res_mgr.GetGameConfigFromCache(this, "config_boss_type", false)
				let cfg = cfgs[this.boss_type]
				if (cfg) {
					if (this.max_anger && this.max_anger != 0 && _max_anger > this.max_anger) {
						if (this.boss_suit_exit_view) {
							this.boss_suit_exit_view.Close()
							this.boss_suit_exit_view = null
						}
					}
					let max_anger = _max_anger
					this.max_anger = _max_anger
					let dataList = this.boss_model.GetBossTypeInfo(this.boss_type)
					let str = ""
					let str2 = ""
					let count_down = 30
					if (this.scene_mgr.IsSuitBossScene()) {
						str = "疲劳值超值"
						str2 = "由于您在蛮荒场景中累计疲劳度超过100，您将自动退出蛮荒场景！"
						count_down = 20
					} else if (this.scene_mgr.IsMysteryBossScene()) {
						str = "疲劳值超值"
						str2 = "由于您在秘境Boss场景中累计疲劳度超过上限，您将自动退出场景！"
					}
					this.SetProgress(anger, max_anger)
					//if (dataList.tired == anger ) {
					//return
					//}
					dataList.tired = anger
					if (this.scene_mgr.IsSuitBossScene()) {
						//if (Scene.GetInstance():GetMainRole().IsDead() ) {
						//let suitReliveView =  new BossSuitReliveView()
						//suitReliveView:Open()
						//return
						//}
					}
					if (anger >= max_anger) {
						//let is_exit = this.boss_model.relive_time != 0
						//if (!is_exit) {
						this.boss_suit_exit_view = new BossSuitExit(count_down, str, str2, () => {
							this.boss_model.Fire(BossModel.SCMD_REQUEST, 46004, this.boss_type)
						})
						this.boss_suit_exit_view.Open()
						//}
					}
				}
			}
			)
		}


		this.BindEvent(BossModel.GetInstance(), BossModel.UPDATE_VIT_TIME, (scmd/**vit?, max_vit?, last_vit_time?*/) => {
			if (this.scene_mgr.IsFieldBossScene()||this.scene_mgr.IsFieldInfiniteBossScene()) {
				this.SetProgress(scmd.vit, scmd.max_vit)
				this.UupdateVitOnTime(scmd.vit, scmd.max_vit, scmd.add_vit, scmd.back_vit, scmd.last_vit_time)
			}
		}
		)
	}


	public UpdateERTired(now_tired?) {
		let info = this.boss_model.GetBossTypeInfo(BossModel.BossType.holy)
		if (info) {
			let tired = now_tired || info.tired
			let left_tired = info.max_tired - tired
			let color = (left_tired == 0 && ("'#fa1a1a'") || ("'#00fa64'"))
			this._html_er_tired.innerHTML = `大妖次数：${HtmlColorTxt(`${left_tired}/${info.max_tired}`, color)}`
			// this._lb_er_tired.text = `剩余次数:${left_tired}/${info.max_tired}`
			if (info) {
				info.tired = tired
			}
		}
	}

	public SetTask(bool?) {
		this._list_item.visible = !bool
		this._box_er_tired.visible = !bool
		this._panel_task.visible = bool
		this.wuxian.visible = bool && this.scene_mgr.IsCrossWuxianBossScene()
	}

	cur_vit = 0//防止无限刷新
	req_vit = -1 //请求更新时的vit
	last_vit_time = 0
	time_id
	/***场景中定时刷新世界大妖的体力值 */
	public UupdateVitOnTime(vit?, max_vit?, add_vit?, back_vit?, last_vit_time?) {
		// vit:int16             // 体力值
		// max_vit:int16         // 最大体力值
		//add_vit                //已恢复的体力值
		// back_vit:int16        // 可找回的体力值
		// last_vit_time:int32   // 上次计算的体力值时间)
		this.last_vit_time = last_vit_time
		let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_boss_type_key_value", false)
		//恢复一点体力所需要的时间
		let time = BossModel.GetInstance().GetBossKeyValue(BossModel.BossType.field, "add_vit_time", cfg)
		//每天最多恢复的体力上限
		let add_vit_max = BossModel.GetInstance().GetBossKeyValue(BossModel.BossType.field, "add_vit_max", cfg)
		//每天恢复达到上限
		if (add_vit >= Number(add_vit_max)) {
			this.ClearTimer()
		} else {
			this.cur_vit = vit
			if (vit >= max_vit) {
				this.ClearTimer()
				//体力已经回满  不显示提示
			} else {
				let v = KaifuActivityModel.GetInstance().CheckHaveMonthCard() ? 0.8 : 1
				let end_time = this.last_vit_time + /**(max_vit - vit) **/ time * v
				let time_func = () => {
					let left_time = end_time - TimeUtil.getServerTime()
					if (left_time >= 0) {
						//时间还在倒计时
					} else {
						this.ClearTimer()
						// if (this.req_vit != this.cur_vit) {
						// 	this.req_vit = this.cur_vit
						// 	//刷新体力值
						// 	BossModel.GetInstance().Fire(BossModel.SCMD_REQUEST, 46043, BossModel.BossType.field)
						// } else {
						// 	//console.warn("测试：倒计时停止")
						// }
					}
				}
				//倒计时
				if (!this.time_id) {
					this.time_id = GlobalTimerQuest.AddPeriodQuest(() => {
						time_func()
					}, 10, -1)
					time_func()
				}
			}
		}
	}
	public ClearTimer() {
		if (this.time_id) {
			GlobalTimerQuest.CancelQuest(this.time_id)
			this.time_id = null
		}
	}

	_img_bg: Laya.Image
	_box_con: Laya.Box
	_box_radio: Laya.HBox
	_box_radio1: Laya.Box
	_img_radio1: Laya.Image
	_lb_radio1: Laya.Label
	_box_radio2: Laya.Box
	_img_radio2: Laya.Image
	_lb_radio2: Laya.Label
	_list_item: Laya.List
	_panel_task: Laya.Panel
	_box_con2: Laya.Box
	_box_tired: Laya.Box
	_lb_pl: Laya.Label
	_box_progress: Laya.Box
	_img_progress_mask: Laya.Image
	_img_progress_bar: Laya.Image
	_lb_progress: Laya.Label
	_img_Instruction: Laya.Image
	_img_add_vit: Laya.Image
	_box_er_tired: Laya.Box
	_Image2: Laya.Image
	_html_er_tired: Laya.HTMLDivElement
	wuxian:Laya.Label
	public GetComponents() {
		[
			this._img_bg,
			this._box_con,
			this._box_radio,
			this._box_radio1,
			this._img_radio1,
			this._lb_radio1,
			this._box_radio2,
			this._img_radio2,
			this._lb_radio2,
			this._list_item,
			this._panel_task,
			this._box_con2,
			this._box_tired,
			this._lb_pl,
			this._box_progress,
			this._img_progress_mask,
			this._img_progress_bar,
			this._lb_progress,
			this._img_Instruction,
			this._img_add_vit,
			this._box_er_tired,
			this._Image2,
			this._html_er_tired,
			this.wuxian
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_box_con",
				"_box_radio",
				"_box_radio1",
				"_img_radio1",
				"_lb_radio1",
				"_box_radio2",
				"_img_radio2",
				"_lb_radio2",
				"_list_item",
				"_panel_task",
				"_box_con2",
				"_box_tired",
				"_lb_pl",
				"_box_progress",
				"_img_progress_mask",
				"_img_progress_bar",
				"_lb_progress",
				"_img_Instruction",
				"_img_add_vit",
				"_box_er_tired",
				"_Image2",
				"_html_er_tired",
				"wuxian"
			])
	}
}
window["BossWayFindingItem"] = BossWayFindingItem
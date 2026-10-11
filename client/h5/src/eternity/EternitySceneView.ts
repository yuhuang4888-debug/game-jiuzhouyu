import { Alert, Alert_Type } from "../alert/Alert"
import { BossTargetPanel } from "../boss/BossTargetPanel"
import { BaseView1 } from "../common/BaseView1"
import { Config } from "../common/Config"
import { EventName } from "../common/EventName"
import { InstructionType } from "../common/InstructionType"
import { Enum_UILayer, LayerManager } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { MainUIManager } from "../common/MainUIManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { BossSceneManager } from "../commonController/BossSceneManager"
import { EternityDefine, EternityEvent, EternityModel, EternityTimer } from "../commonModel/EternityModel"
import { KfHolyAreaModel } from "../commonModel/KfHolyAreaModel"
import { MainUIModel } from "../commonModel/MainUIModel"
import { RoleManager } from "../commonModel/RoleManager"
import { KfHolyAreaDefine } from "../kfHolyArea/KfHolyAreaDefine"
import { Scene } from "../scene/Scene"
import { SceneManager } from "../scene/SceneManager"
import { Enum_ColorUtil_Dark } from "../util/ColorUtil"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { GameMath } from "../util/GameMath"
import { GameResPath } from "../util/GameResPath"
import { Runner } from "../util/Runner"
import { SYTweenLite } from "../util/SYTweenLite"
import { TimeUtil } from "../util/TimeUtil"
import { Color, GetSizeDeltaX, HtmlColorTxt, SetLocalPositionX, Util } from "../util/Util"
import { EternityBossItem } from "./EternityBossItem"
import { EternityCadreItem } from "./EternityCadreItem"
import { EternityDamageItem } from "./EternityDamageItem"
import { EternityMonItem } from "./EternityMonItem"

export class EternitySceneView extends BaseView1 {
	_gp_con: Laya.Box
	_Image1: Laya.Image
	_gp_damage: Laya.Box
	_Image2: Laya.Image
	_Image3: Laya.Image
	_lb_server: Laya.HTMLDivElement
	_lb_tips: Laya.Label
	_lb_name: Laya.Label
	Content: Laya.List
	_gp_boss: Laya.Box
	_gp_item_boss: Laya.Box
	_Scroller1: Laya.Panel
	Content1: Laya.VBox
	_gp_item_cadre: Laya.VBox
	_gp_item_mon: Laya.VBox
	_btn_help: Laya.Image
	_btn_boss: Laya.Image
	boss_text: Laya.Label
	_btn_damage: Laya.Image
	damage_text: Laya.Label
	_Group2: Laya.Box
	_Image4: Laya.Image
	_lb_time: Laya.Label
	_gp_target: Laya.Box
	_gp_exit: Laya.Box
	_Image5: Laya.Image
	AddRunner
	ChangeScene
	CheckTargetPanel
	Clear
	CreateDamageList
	GetItemData
	GetRoleVoList
	InitEvent
	LoadSuccess
	RemoveRunner
	SaveDamageList
	SelectRadioBtn
	SetMonName
	SetPosDic
	SetTagetPanelHide
	Update
	UpdateCountDown
	UpdateDamageData
	UpdateItems
	UpdateMonsterItems
	UpdateTimer
	_Group2_CG
	_ac_damage
	_boss_item_list
	_cadre_item_list
	_cur_index
	_cur_sel_mon_id
	_cur_show_mon_id
	_damage_dic
	_damage_mark_dic
	_dg_damage
	_gp_con_CG
	_gp_exit_CG
	_gp_target_CG
	_icon_state
	_mon_item_list
	_pos_dic
	_scene_id
	_taget_panel: BossTargetPanel
	_tips_timer
	anim_list
	corners
	count_down_offset_h
	count_down_offset_h_1
	count_down_offset_h_reset
	count_down_offset_h_reset_1

	public constructor() {
		super()


		this._cur_index = -1;
		this._pos_dic = [];
		this._boss_item_list = [];
		this._cadre_item_list = [];
		this._mon_item_list = [];
		this._damage_mark_dic = [];
		this._damage_dic = [];
		this.anim_list = []
		this._icon_state = false;
		this.base_file = "eternity"
		this.layout_file = "EternitySceneView"
		this.layer_value = Enum_UILayer.Main
		this.destroy_imm = true
		this.change_scene_close = true
		this.back_login_toClose = true
		this.not_close_by_android_back_key = true
		let _model = EternityModel.GetInstance()
		let local_Alert = Alert
		let local_Alert_Type = Alert_Type
		let REQUEST_PROTO = EternityEvent.REQUEST_PROTO
		let local_EternityEvent = EternityEvent
		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName
		let scene_mgr = SceneManager.GetInstance()
		let mainUI_model = MainUIModel.GetInstance()
		let local_MainUIModel = MainUIModel
		let local_Config = Config
		let local_EternityDefine = EternityDefine
		let local_EternityTimer = EternityTimer
		let local_Number = Number

		let local_TimeUtil = TimeUtil
		let runner = Runner.GetInstance()
		let local_KfHolyAreaDefine = KfHolyAreaDefine
		let scene = Scene.GetInstance()
		let role_mgr = RoleManager.GetInstance()

		this.preload_server_config = {
			"config_sanctum_hurt_reward": false,
			"config_sanctum_scene": false
		}
		this.preload_client_config = {
			"ConfigEternity": false
		}
		this.load_callback = () => {
			this._Scroller1.vScrollBar.visible = false
			MainUIManager.GetInstance().AddMoveComponent(this, this._gp_con, false, MainUIManager.MOVE_TYPE.Left)
			MainUIManager.GetInstance().AddMoveComponent(this, this._gp_exit, false, MainUIManager.MOVE_TYPE.Left)

			MainUIManager.GetInstance().AddMoveComponent(this, this._Group2, false, MainUIManager.MOVE_TYPE.Stay)
			MainUIManager.GetInstance().AddMoveComponent(this, this._gp_target, false, MainUIManager.MOVE_TYPE.Stay)
			this.LoadSuccess()
			this.InitEvent()
		}

		this.destroy_callback = () => {
			this.Clear()
		}

		this.Clear = () => {
			MainUIManager.GetInstance().RemoveMoveComponent(this)
			this._cur_index = -1
			if (this._tips_timer) {
				clearTimeout(this._tips_timer)
				this._tips_timer = null
			}
			if (this._taget_panel) {
				this._taget_panel.DeleteMe()
				this._taget_panel = null
			}
			if (this.anim_list && this.anim_list.length > 0) {
				for (let k in this.anim_list) {
					var v = this.anim_list[k]
					SYTweenLite.Stop(v)
				}
				this.anim_list = []
			}
			for (let key in this._boss_item_list) {

				this._boss_item_list[key].DeleteMe()
			}
			this._boss_item_list = []
			for (let key in this._mon_item_list) {

				this._mon_item_list[key].DeleteMe()
			}
			this._mon_item_list = []
			for (let key in this._cadre_item_list) {

				this._cadre_item_list[key].DeleteMe()
			}
			this._cadre_item_list = []
			_model.ClearTimer(local_EternityTimer.SCENE)
			this.RemoveRunner()
			if (this._ac_damage) {
				this._ac_damage.DeleteMe()
				this._ac_damage = null
			}
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._gp_exit, () => {
				local_Alert.Show("当前退出后，将可能导致无法继续参与活动是否退出？", local_Alert_Type.Two, () => {
					_model.Fire(REQUEST_PROTO, 27903)
				}
				)
			}
				, this, true)
			Util.AddClickEvent(this._btn_help, () => {
				local_GlobalEventSystem.Fire(local_EventName.OPEN_INSTRUCTION_VIEW, InstructionType.ETERNITY)
			}
				, this, true)
			Util.AddClickEvent(this._btn_boss, () => {
				this.SelectRadioBtn(1)
			}
				, this, true)
			Util.AddClickEvent(this._btn_damage, () => {
				this.SelectRadioBtn(2)
			}
				, this, true)
			this.BindVar(_model, "_act_data", () => {
				this.UpdateCountDown()
			}
			)
			this.BindVar(_model, "_mon_data", () => {
				this.UpdateMonsterItems()
			}
			)
			this.BindVar(_model, "_damage_data", (type?, value?, old_value?, param?) => {
				if (this._scene_id != value.scene) {
					return
				}
				this.SaveDamageList(value.mon_id, value.hurt_list, false)
				this.UpdateDamageData(value.hurt_list)
			}
			)
			this.BindEvent(local_GlobalEventSystem, local_EventName.UPDATE_BOSS_DAMAGE_DATA, (monster_id?, list?, type_id?) => {
				this.SaveDamageList(type_id, list, true)
				this.UpdateDamageData(list)
			}
			)
			this.BindEvent(local_GlobalEventSystem, local_EventName.ADD_BOSS_DAMAGE_DATA, (scmd?) => {
				if (this._cur_show_mon_id != scmd.monster_type_id) {
					return
				}
				let data = this._damage_dic[scmd.monster_type_id]
				if (!data) {
					return
				}
				let vo = data.dic[scmd.player_id]
				if (vo) {
					vo.damage = vo.damage + scmd.damage
				} else {
					data.dic[scmd.player_id] = scmd
					table.insert(data.list, scmd)
				}
				this.SaveDamageList(scmd.monster_type_id, data.list, true)
				this.UpdateDamageData(data.list)
			}
			)
			this.BindEvent(local_GlobalEventSystem, local_EventName.REMOVE_BOSS_DAMAGE_DATA, (monster_id?, list?, type_id?) => {
				if (this._cur_show_mon_id != type_id) {
					return
				}
				let data = this._damage_dic[type_id]
				if (!data) {
					return
				}
				let vo = this._damage_dic[type_id]
				if (!vo) {
					return
				}
				for (let _tmpi in list) {
					var info = list[_tmpi]
					data.dic[info.player_id] = null
				}
				data.list = []
				for (let key in data.dic) {

					table.insert(data.list, data.dic[key])
				}
				this.SaveDamageList(type_id, data.list, true)
				this.UpdateDamageData(data.list)
			}
			)
			this.BindEvent(local_GlobalEventSystem, SceneManager.START, (scene_id?) => {
				if (scene_mgr.IsEternityScene(scene_id)) {
					this.ChangeScene()
				}
			}
			)
			this.BindEvent(_model, local_EternityEvent.SELECT_MON, (mon_id?) => {
				this._cur_sel_mon_id = mon_id
			}
			)

			let pos_anim = (parent?, pos_x?) => {
				let index = SYTweenLite.to(this, parent, SYTweenLite.UiAnimationType.POSX, pos_x, local_MainUIModel.Move_Time_Interval)
				table.insert(this.anim_list, index)
			}
			let alpha_anim = (parent?, alpha?) => {
				let index = SYTweenLite.to(this, parent, SYTweenLite.UiAnimationType.ALPHA, alpha, local_MainUIModel.Move_Time_Interval)
				table.insert(this.anim_list, index)
			}
			this.BindEvent(mainUI_model, local_MainUIModel.UPDATE_ACTIVITY_STATE, (bool?) => {
				// if (bool) {
				// 	pos_anim(this._gp_con, this.count_down_offset_h)
				// 	pos_anim(this._gp_exit, this.count_down_offset_h_1)
				// 	alpha_anim(this._gp_con_CG, 0)
				// 	alpha_anim(this._gp_exit_CG, 0)
				// 	alpha_anim(this._gp_target_CG, 0)
				// 	alpha_anim(this._Group2_CG, 0)
				// } else {
				// 	pos_anim(this._gp_con, this.count_down_offset_h_reset)
				// 	pos_anim(this._gp_exit, this.count_down_offset_h_reset_1)
				// 	alpha_anim(this._gp_con_CG, 1)
				// 	alpha_anim(this._gp_exit_CG, 1)
				// 	alpha_anim(this._gp_target_CG, 1)
				// 	alpha_anim(this._Group2_CG, 1)
				// }
			}
			)
			this.BindEvent(_model, local_EternityEvent.UPDATE_GO_STATUS, (can_go?, scmd?) => {
				if (!can_go) {
					return
				}
				let scene_id = scene_mgr.GetSceneId()
				this._tips_timer = setTimeout(() => {
					if (scene_id != scene_mgr.GetSceneId()) {
						return
					}
					let mdata = local_Config.GetConfigVo(local_Config.ConfigHasDefaultValue.config_mon.name, scmd.mon_id, false)
					let name = (mdata && (mdata.name) || (""))
					name = HtmlColorTxt(name, Enum_ColorUtil_Dark.RED)
					let str = "我方服务器已成功击杀" + name + "，现已获得进入天启之源权限，是否立即进入？（进入天启之源后将不可退出）"
					local_Alert.Show(Util.StrToHTML(str), local_Alert_Type.Two, () => {
						_model.Fire(REQUEST_PROTO, 27902, "h", local_EternityDefine.BOSS_SCENE)
					}
						, null, "立即进入", "稍后进入")
				}
					, 3000)
			}
			)
		}

		this.LoadSuccess = () => {
			// this.form.pivot = Vector2(0.5, 0.5)
			// this.form.anchorMin = Vector2(0, 0.5)
			// this.form.anchorMax = Vector2(1, 0.5)
			// this.form.sizeDelta = Vector2(0,1280)

			ResManager.GetInstance().SetOutsideImageSprite(this, this._Image4, GameResPath.GetIcon("common2", "uijhsd_017"), true)

			// this.RegisterMask(this._dg_damage)
			// this.corners = GetWorldCorners(this._dg_damage)

			this.SelectRadioBtn(1)


			this.SetPosDic()

			let scene_id = scene_mgr.GetSceneId()
			_model.Fire(REQUEST_PROTO, 27904, "h", scene_id)
			_model.Fire(REQUEST_PROTO, 27900)
			if (!this._taget_panel) {
				this._taget_panel = new BossTargetPanel(this._gp_target)
				this._taget_panel.Load()
				this.SetTagetPanelHide(false)
			}
			// this.count_down_offset_h = -GetSizeDeltaX(this._gp_con)
			// this.count_down_offset_h_reset = 0
			// this.count_down_offset_h_1 = -GetSizeDeltaX(this._gp_exit)
			// this.count_down_offset_h_reset_1 = 0
			// let state = mainUI_model.activity_icon_in_show
			// this._gp_con_CG = this._gp_con
			// this._gp_target_CG = this._gp_exit
			// this._gp_exit_CG = this._gp_target
			// this._Group2_CG = this._Group2
			// if (state) {
			// 	SetLocalPositionX(this._gp_con, this.count_down_offset_h)
			// 	SetLocalPositionX(this._gp_exit, this.count_down_offset_h_1)
			// 	this._gp_con_CG.alpha = 0
			// 	this._gp_exit_CG.alpha = 0
			// 	this._gp_target_CG.alpha = 0
			// 	this._Group2_CG.alpha = 0
			// } else {
			// 	SetLocalPositionX(this._gp_con, this.count_down_offset_h_reset)
			// 	SetLocalPositionX(this._gp_exit, this.count_down_offset_h_reset_1)
			// 	this._gp_con_CG.alpha = 1
			// 	this._gp_exit_CG.alpha = 1
			// 	this._gp_target_CG.alpha = 1
			// 	this._Group2_CG.alpha = 1
			// }
			this.ChangeScene()
			this.UpdateCountDown()
			this.AddRunner()
		}

		this.UpdateCountDown = () => {
			let adata = _model.GetActData()
			if (adata && adata.end_time > 0) {
				_model.ClearTimer(local_EternityTimer.SCENE)
				let func = () => {
					this.UpdateTimer()
				}
				_model.StartTimer(local_EternityTimer.SCENE, 1, func)
				this.UpdateTimer()
			}
		}

		this.SelectRadioBtn = (index?) => {
			if (this._cur_index == index) {
				return
			}
			this._cur_index = index
			this._gp_boss.visible = index == 1
			if (index == 2 && this._cur_show_mon_id) {
				let data = this._damage_dic[this._cur_show_mon_id]
				let list = (data && (data.list) || (null))
				this.UpdateDamageData(list)
				this._gp_damage.visible = true
			} else {
				this._gp_damage.visible = false
			}
			ResManager.GetInstance().SetImageSprite(this, this._btn_boss, "eternity_asset", index == 1 && "uikfsy_017" || "uikfsy_018")
			ResManager.GetInstance().SetImageSprite(this, this._btn_damage, "eternity_asset", index == 2 && "uikfsy_017" || "uikfsy_018")
			this.boss_text.color = index == 1 && "#9b572f" || "#d7d9ed"
			this.damage_text.color = index == 1 && "#d7d9ed" || "#9b572f"
		}

		this.ChangeScene = () => {
			this._cur_show_mon_id = null
			this._scene_id = scene_mgr.GetSceneId()
			_model.Fire(REQUEST_PROTO, 27904, "h", this._scene_id)
			this.SetPosDic()
			this.UpdateItems()
			this.UpdateDamageData(null)
			this._lb_name.text = ""
			this._damage_dic = []
		}

		this.SaveDamageList = (mon_id?, hurt_list?, cal_ratio?) => {
			let total = 0
			if (cal_ratio) {
				for (let _tmpi in hurt_list) {
					var vo = hurt_list[_tmpi]
					total = total + vo.damage
				}
			}
			let dic = []

			for (let _tmpi in hurt_list) {
				var vo = hurt_list[_tmpi]
				vo.mon_id = mon_id
				vo.ratio = cal_ratio ? ((Math.floor(vo.damage / total * 1000) / 10) <= 0.1 ? 0.1 : Math.floor(vo.damage / total * 1000) / 10) : Math.floor(vo.damage / 100 * 10) / 10 //保留一位小数
				dic[vo.player_id] = vo
			}
			this._damage_dic[mon_id] = { list: hurt_list, dic: dic }
		}

		this.UpdateDamageData = (hurt_list?) => {
			if (this._cur_index != 2) {
				return
			}
			if (!hurt_list) {
				this._gp_damage.visible = false
				this._lb_server.innerHTML = ""
			} else if (hurt_list.length < 1) {
				this._gp_damage.visible = true
				this._lb_server.innerHTML = "归属：无"
				this.CreateDamageList(hurt_list)
			} else {
				let sort_func = (a?, b?) => {
					return a.damage > b.damage
				}
				table.sort(hurt_list, sort_func)
				let vo_dic = []
				let hurt_dic = []
				let data = null
				let max = 0
				let i = 0
				if (i < hurt_list.length) {
					do {
						let vo = hurt_list[i]
						if (vo_dic[vo.server_id]) {
							hurt_dic[vo.server_id] = hurt_dic[vo.server_id] + vo.damage
						} else {
							vo_dic[vo.server_id] = vo
							hurt_dic[vo.server_id] = vo.damage
						}
						vo.rank = i + 1
						i = i + 1
					} while ((i < hurt_list.length))
				}
				for (let key in hurt_dic) {

					if (hurt_dic[key] > max) {
						max = hurt_dic[key]
						data = vo_dic[key]
					}
				}
				let str = HtmlColorTxt("S" + data.server_num + "." + data.server_name, "'#00B11D'")
				this._lb_server.style.fontSize = 16
				this._lb_server.style.color = "#663915"
				this._lb_server.style.wordWrap = false
				this._lb_server.innerHTML = Util.StrToHTML("归属：" + str)

				this.CreateDamageList(hurt_list)
				this._gp_damage.visible = true
			}
			// let a = <Laya.HBox>this._lb_server.parent
			// if (a)
			// 	a.refresh()
		}

		this.CreateDamageList = (list?) => {
			if (!list) { return }
			if (!this._ac_damage) {
				if (Util.IsTableEmpty(list)) { return }
				this._ac_damage = new LoopScrowViewMgr()
				this._ac_damage.SetData(this.Content, EternityDamageItem, list, LoopScrCon.Vertical)
			} else {
				this._ac_damage.replaceAll(list)
			}
		}

		this.UpdateItems = () => {
			let type_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "ConfigEternity", true)
			let map_cfg = local_Config.PRELOAD_CLIENT_CONFIG.ClientMapConfig[this._scene_id]
			if (!map_cfg) {
				return
			}
			let type_dic = []
			let i = 0
			do {
				let vo = map_cfg.point_list[i]
				let type = type_cfg.mon_type[vo.mon_id]
				if (!type) { return }
				let [iclass, igroup, ilist] = this.GetItemData(type)
				let index = (type_dic[type] != null && (type_dic[type] + 1) || (0))
				type_dic[type] = index
				let item = ilist[index]
				if (!item) {
					item = new iclass(igroup)
					item.Load()
					ilist[index] = item
				}
				item.ExcuteCallback(() => {
					item.SetMapData(vo)
					item.SetVisible(true)
				}
				)

				i = i + 1
			} while ((i < map_cfg.point_list.length))
			for (let type in type_dic) {

				let [iclass, igroup, ilist] = this.GetItemData(type)
				let count = type_dic[type]
				let i = count + 1
				if (i < ilist.length) {
					do {
						ilist[i].ExcuteCallback(() => {
							ilist[i].SetVisible(false)
						}
						)
						i = i + 1
					} while ((i < ilist.length))
				}
			}
		}

		this.UpdateMonsterItems = () => {
			let mdata = _model.GetMonData()
			if (!mdata) {
				return
			}
			let scene_id = scene_mgr.GetSceneId()
			if (scene_id != mdata.scene) {
				return
			}
			let type_dic = []
			for (let _tmpi in mdata.mon) {
				let vo = mdata.mon[_tmpi]
				let [iclass, igroup, ilist] = this.GetItemData(vo.mon_type)
				let index = (type_dic[vo.mon_type] != null && (type_dic[vo.mon_type] + 1) || (0))
				type_dic[vo.mon_type] = index
				let item = ilist[index]
				if (item) {
					item.ExcuteCallback(() => {
						item.SetData(vo)
					}
					)
				}
			}
			//LayoutRebuilder(this.Content1)
		}

		this.GetItemData = (type?) => {
			if (type == 1) {
				return [EternityBossItem, this._gp_item_boss, this._boss_item_list]
			} else if (type == 2) {
				return [EternityCadreItem, this._gp_item_cadre, this._cadre_item_list]
			} else {
				return [EternityMonItem, this._gp_item_mon, this._mon_item_list]
			}
		}

		this.SetPosDic = () => {
			this._pos_dic = []
			let scene_id = scene_mgr.GetSceneId()
			let cfg_dic = ResManager.GetInstance().GetGameConfigFromCache(this, "config_sanctum_scene", false)
			if (!cfg_dic) {
				return
			}
			let i = 0
			do {

				let type = local_EternityDefine.MON_TYPE_LIST[i]
				let cfg = cfg_dic[scene_id + "@" + type]
				if (!cfg) {
					break
				}
				let mon_list = JSON.parse(cfg.mon)
				for (let _tmpi in mon_list) {
					var vo = mon_list[_tmpi]
					this._pos_dic[local_Number(vo[0])] = { x: local_Number(vo[1]), y: local_Number(vo[2]) }
				}

				i = i + 1
			} while ((i < local_EternityDefine.MON_TYPE_LIST.length))
		}

		this.UpdateTimer = () => {
			let data = _model.GetActData()
			if (!data) {
				return
			}
			let time = data.end_time - local_TimeUtil.getServerTime()
			if (time < 0) {
				_model.ClearTimer(local_EternityTimer.SCENE)
			} else {
				this._lb_time.text = local_TimeUtil.timeConvert(time, "hh:MM:ss")
			}
		}

		this.AddRunner = () => {
			runner.AddRunObj(this, 16)
		}

		this.RemoveRunner = () => {
			runner.RemoveRunObj(this.hashCode)
		}

		this.Update = () => {
			let main_role = scene.main_role
			if (!main_role) {
				return
			}
			let cur_mon_id = null
			for (let mon_id in this._pos_dic) {

				let pos = this._pos_dic[mon_id]
				let dis = GameMath.GetDistance(main_role.real_pos.x, main_role.real_pos.y, pos.x, pos.y)
				if (dis <= local_KfHolyAreaDefine.Examination_Range * local_KfHolyAreaDefine.Examination_Range) {
					if (!this._damage_mark_dic[mon_id]) {
						let mdata = _model.GetMonDataOne(mon_id)
						if (mdata && (mdata.reborn_time > local_TimeUtil.getServerTime() || mdata.bl_server > 0)) {
							this._damage_mark_dic[mon_id] = true
							this._cur_show_mon_id = mon_id
							_model.Fire(REQUEST_PROTO, 27905, "hi", this._scene_id, local_Number(mon_id))
							this.SetMonName(mon_id)
						} else {
							let [mon_list, mon_count] = scene.FindTargets(Scene.FIND_TARGET_TYPE.monster, 1, null, null, null, null, null)
							let monster = mon_list[0]
							let monster_vo = (monster && (monster.GetVo()) || (null))
							if (monster_vo && monster_vo.type_id == mon_id) {
								this._damage_mark_dic[mon_id] = true
								this._cur_show_mon_id = mon_id
								//UserMsgAdapter:GetInstance():SendAllFmtToGame(12025, "i", {monster_vo.instance_id})
								UserMsgAdapter.GetInstance().SendAllFmtToGame(12025, "i", [monster_vo.instance_id])
								this.SetMonName(mon_id)
							}
						}
					}
					cur_mon_id = mon_id
					break
				} else {
					if (this._damage_mark_dic[mon_id]) {
						this._damage_mark_dic[mon_id] = null
						this._cur_show_mon_id = null
						this.UpdateDamageData(null)
						this._lb_name.text = ""
					}
				}
			}
			this.CheckTargetPanel(cur_mon_id)
		}

		this.SetMonName = (mon_id?) => {
			let mon_cfg = local_Config.GetConfigVo(local_Config.ConfigHasDefaultValue.config_mon.name, mon_id, false)
			this._lb_name.text = (mon_cfg && (mon_cfg.name) || (""))
		}

		this.SetTagetPanelHide = (bool?) => {
			if (this._taget_panel && this._taget_panel.is_loaded) {

				if (this._taget_panel.display_obj.visible != bool) {
					this._taget_panel.display_obj.visible = bool
				}
			}
		}

		this.GetRoleVoList = (mon_id?) => {
			let main_role_vo = role_mgr.GetMainRoleVo()
			let main_role_id = role_mgr.GetMainRoleId()
			let list = []
			let role_vo_list = scene_mgr.GetAllRoleVos()
			if (main_role_vo.boss_flag == 1) {
				table.insert(list, main_role_vo)
			}
			for (let role_id in role_vo_list) {

				let role_vo = role_vo_list[role_id]
				let bool1 = true
				if (role_vo.hp == 0 && role_vo.boss_flag != 1) {
					bool1 = false
				}
				if (bool1) {
					let pos = this._pos_dic[mon_id]
					if (pos) {
						let distance =
							GameMath.GetDistance(
								role_vo.pos_x,
								role_vo.pos_y,
								pos.x,
								pos.y
							)
						if (distance <= local_KfHolyAreaDefine.Examination_Range * local_KfHolyAreaDefine.Examination_Range) {
							if (Number(role_id) != main_role_id) {
								let role = scene.GetRole(role_id)
								table.insert(list, role)
							}
						}
					}
				}
			}
			return list
		}

		this.CheckTargetPanel = (mon_id?) => {
			let obj_vo_list = []
			let role_vo_list = this.GetRoleVoList(mon_id)
			let main_role_vo = role_mgr.GetMainRoleVo()
			if (mon_id) {
				let monster = scene.GetMonsterByTypeId(mon_id)
				let pos = this._pos_dic[mon_id]
				let distance =
					GameMath.GetDistance(
						main_role_vo.pos_x,
						main_role_vo.pos_y,
						pos.x,
						pos.y
					)
				if (monster && distance <= local_KfHolyAreaDefine.Examination_Range * local_KfHolyAreaDefine.Examination_Range) {
					table.insert(obj_vo_list, monster)
					if (!this._icon_state && mainUI_model.activity_icon_in_show) {
						mainUI_model.Fire(local_MainUIModel.CHANGE_ACTIVITY_STATE, false)
					}
					if (!mainUI_model.big_blood_in_show) {
						let config = local_Config.GetConfigVo(local_Config.ConfigHasDefaultValue.config_mon.name, monster.GetVo().type_id, false)
						BossSceneManager.GetInstance().SetAttackTarget(monster)
						local_GlobalEventSystem.Fire(local_EventName.SHOW_HITER_BIG_BLOOD_VIEW, true, monster.GetVo(), config.hp_num, false)
					}
				}
			} else {
				local_GlobalEventSystem.Fire(local_EventName.SHOW_HITER_BIG_BLOOD_VIEW, false)
				let vo = _model.GetMonDataOne(mon_id)
				if (vo && vo.reborn_time > local_TimeUtil.getServerTime()) {
					vo.boss_id = vo.mon_id
					table.insert(obj_vo_list, vo)
				}
			}
			if (mon_id) {
				obj_vo_list = obj_vo_list.concat(role_vo_list)
			}
			if (obj_vo_list.length > 0) {
				this._icon_state = true
				this._taget_panel.SetData(obj_vo_list)
				this.SetTagetPanelHide(true)
			} else {
				this._icon_state = false
				this.SetTagetPanelHide(false)
			}
		}


	}



	public GetComponents() {
		[
			this._gp_con,
			this._Image1,
			this._gp_damage,
			this._Image2,
			this._Image3,
			this._lb_server,
			this._lb_tips,
			this._lb_name,
			this.Content,
			this._gp_boss,
			this._gp_item_boss,
			this._Scroller1,
			this.Content1,
			this._gp_item_cadre,
			this._gp_item_mon,
			this._btn_help,
			this._btn_boss,
			this.boss_text,
			this._btn_damage,
			this.damage_text,
			this._Group2,
			this._Image4,
			this._lb_time,
			this._gp_target,
			this._gp_exit,
			this._Image5,
		]
			= this.GetChildrenByNames([

				"_gp_con",
				"_Image1",
				"_gp_damage",
				"_Image2",
				"_Image3",
				"_lb_server",
				"_lb_tips",
				"_lb_name",
				"Content",
				"_gp_boss",
				"_gp_item_boss",
				"_Scroller1",
				"Content1",
				"_gp_item_cadre",
				"_gp_item_mon",
				"_btn_help",
				"_btn_boss",
				"boss_text",
				"_btn_damage",
				"damage_text",
				"_Group2",
				"_Image4",
				"_lb_time",
				"_gp_target",
				"_gp_exit",
				"_Image5",
			])
	}
}
window["EternitySceneView"] = EternitySceneView
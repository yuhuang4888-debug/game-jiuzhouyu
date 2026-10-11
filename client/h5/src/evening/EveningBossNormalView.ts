import { Alert, Alert_Type } from "../alert/Alert"
import { AutoFightManager } from "../autofight/AutoFightManager"
import { BaseView1 } from "../common/BaseView1"
import { EventName, SceneEventType } from "../common/EventName"
import { Enum_UILayer, LayerManager } from "../common/LayerManager"
import { MainUIManager } from "../common/MainUIManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { GuildActivityModel, GuildActEvent, GuildActDefine } from "../commonModel/GuildActivityModel"
import { GuildModel, GuildPermission } from "../commonModel/GuildModel"
import { MainUIModel } from "../commonModel/MainUIModel"
import { KfHolyAreaDefine } from "../kfHolyArea/KfHolyAreaDefine"
import { Scene } from "../scene/Scene"
import { SceneManager } from "../scene/SceneManager"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { GameMath } from "../util/GameMath"
import { Runner } from "../util/Runner"
import { SYTweenFunc } from "../util/SYTweenFunc"
import { SYTweenLite } from "../util/SYTweenLite"
import { Util } from "../util/Util"
import { Vector2 } from "../util/Vector2"
import { EveningBossPanel } from "./EveningBossPanel"

export class EveningBossNormalView extends BaseView1 {
	_boss_pos
	_can_call
	_damage_mark
	_model
	_update_id
	_wayfinding_panel
	back_login_toClose
	destroy_callback
	destroy_imm
	is_center
	percentHeight
	percentWidth
	preload_server_config


	public constructor() {
		super()

		this._can_call = true;
		this.base_file = "evening"
		this.layout_file = "EveningBossNormalView"
		this.layer_value = Enum_UILayer.Main
		this.destroy_imm = true
		this.back_login_toClose = true
		this.dependent_res = ["mainUI"]
		this._model = GuildActivityModel.GetInstance()
		this.percentWidth = 100
		this.percentHeight = 100

		this.load_callback = () => {
			MainUIManager.GetInstance().AddMoveComponent(this, this._gp_call, false, MainUIManager.MOVE_TYPE.Left)
			MainUIManager.GetInstance().AddMoveComponent(this, this._wayfinding_gp, false, MainUIManager.MOVE_TYPE.Left)
			// MainUIManager.GetInstance().AddMoveComponent(this, this._btn_exit, false, MainUIManager.MOVE_TYPE.Left)
			MainUIManager.GetInstance().AddMoveComponent(this, this._gp_time, false, MainUIManager.MOVE_TYPE.Top)
			this.LoadSuccess()
		}

		this.destroy_callback = () => {
			this.Clear()
		}

		this.preload_server_config = { "config_gboss": false }
	}

	public Clear() {
		MainUIManager.GetInstance().RemoveMoveComponent(this)
		if (this._wayfinding_panel) {
			this._wayfinding_panel.DeleteMe()
			this._wayfinding_panel = null
		}
		if (this._wayfinding_gp) {
			Laya.Tween.clearAll(this._wayfinding_gp)
		}
		this.RemoveRunner()
	}



	public LoadSuccess() {

		this._model.Fire(GuildActEvent.REQUEST_PROTO, 40201)
		this._wayfinding_panel = new EveningBossPanel(this._wayfinding_gp)
		this._wayfinding_panel.Load()
		let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_gboss", false)
		let pdata = JSON.parse(cfg[12].value)
		this._boss_pos = new Vector2(Number(pdata[0]), Number(pdata[1]))
		this.SendFmt()

		MainUIModel.GetInstance().Fire(MainUIModel.CHANGE_ACTIVITY_STATE, false)
		this._model.SetMainUIViewVisible(true)
		let mVo = SceneManager.GetInstance().GetMonsterVoByTypeId(GuildActDefine.BOSS_ID)
		if (mVo) {
			this.StartPanelAction()
		}


		//先拿到初始x
		this.InitEvent()
	}

	public InitEvent() {

		Util.AddClickEvent(this._btn_exit, () => {
			Alert.Show("是否确定退出场景？", Alert_Type.Two, () => {
				this._model.Fire(GuildActEvent.REQUEST_PROTO, 40218)
			}
			)
		}
			, this, true)
		Util.AddClickEvent(this._btn_call, () => {
			let has_pms = GuildModel.GetInstance().HasPermission(GuildPermission.OPEN_ACT)
			if (has_pms) {
				if (this._can_call) {
					this._model.Fire(GuildActEvent.REQUEST_PROTO, 40204)
				} else {
					Message.show("今天已召唤过")
				}
			} else {
				Message.show("仅结社会长及副会长可召唤八岐大蛇！")
			}
		}
			, this, true)
		this.BindEvent(GlobalEventSystem, SceneEventType.MONSTER_VO_ADD, (mon_id?, monVo?) => {
			if (monVo.type_id == GuildActDefine.BOSS_ID) {
				this.SendFmt()
			}
		}
		)
		this.BindEvent(this._model, GuildActEvent.CALL_BOSS_SUCCESS, () => {
			this.SendFmt()
			this.StartPanelAction()
			this.UpdateBtnStatus()
		}
		)
		this.BindEvent(this._model, GuildActEvent.UPDATE_BOSS_DATA, () => {
			this.UpdateBtnStatus()
		}
		)


		this.BindEvent(GlobalEventSystem, EventName.BROADCAST_COLLECT_RESULT, (flag?, monster_type_id?, monster_ins_id?) => {


			if (flag==13||flag==2) {
				let monsterList
					let monster
					let target
					let monVo
					//如果有人正在采集该物品  则自动寻找其他物品采集
					if (!AutoFightManager.GetInstance().GetAutoFightState()) return
					monsterList = Scene.GetInstance().GetMonsterList()
					for (let k in monsterList) {
						monster = monsterList[k];
						monVo = monster.GetVo()
						if (monVo.instance_id == monster_ins_id) continue
						target = monster
					}



					if (target) {
						let scene = Scene.GetInstance()
						scene.MainRoleAttackMonster(target)
						scene.SetClickTarget(target)
					}
			}else if(flag==7){
				//采集次数满了
				AutoFightManager.GetInstance().SetAutoFight(false)
				Scene.GetInstance().SetClickTarget(null)
				this.RemoveRunner()
			}

		})



	}

	public SendFmt() {

		let mVo = SceneManager.GetInstance().GetMonsterVoByTypeId(GuildActDefine.BOSS_ID)
		if (mVo) {
			this._wayfinding_panel.SetBossID(mVo.instance_id)
			this.AddRunner()
		}
	}

	public StartPanelAction() {

		let icon_show = MainUIModel.GetInstance().activity_icon_in_show
		if (!icon_show) {
			Laya.Tween.to(this._wayfinding_gp, { left: 0 }, MainUIModel.Move_Time_Interval)
		}
	}

	public UpdateBtnStatus() {

		let binfo = this._model.GetBossInfo()
		if (!binfo) {
			return
		}
		this._can_call = binfo.is_drum_today == 0
	}

	public AddRunner() {

		Runner.GetInstance().AddRunObj(this, 16)
	}

	public RemoveRunner() {
		Runner.GetInstance().RemoveRunObj(this.hashCode)
	}

	public Update() {
		let main_role = Scene.GetInstance().main_role
		if (!main_role) {
			return
		}
		// let dis = GameMath.GetDistance(main_role.x, main_role.y, this._boss_pos.x, this._boss_pos.y)
		let dis = GameMath.GetDistance(main_role.real_pos.x, main_role.real_pos.y, this._boss_pos.x, this._boss_pos.y)
		if (dis <= KfHolyAreaDefine.Examination_Range * KfHolyAreaDefine.Examination_Range) {
			if (!this._damage_mark) {
				let mon_list, mon_count
				[mon_list, mon_count] = Scene.GetInstance().FindTargets(Scene.FIND_TARGET_TYPE.monster, 1, null, null, null, null, null)
				let monster = mon_list[0]
				let monster_vo = (monster && (monster.GetVo()) || (null))
				if (monster_vo && monster_vo.type_id == GuildActDefine.BOSS_ID) {
					this._damage_mark = true
					UserMsgAdapter.GetInstance().SendAllFmtToGame(12025, "i", [monster_vo.instance_id])
				}
			}
		} else {
			if (this._damage_mark) {
				this._damage_mark = null
			}
		}
	}

	public DeleteMe() {
		super.DeleteMe()
	}

	_gp_call: Laya.Box
	_btn_call: Laya.Image
	_wayfinding_gp: Laya.Box
	_btn_exit: Laya.Image
	_gp_time: Laya.Box
	_Image1: Laya.Image
	_lb_time: Laya.Label
	public GetComponents() {
		[
			this._gp_call,
			this._btn_call,
			this._wayfinding_gp,
			this._btn_exit,
			this._gp_time,
			this._Image1,
			this._lb_time,
		]
			= this.GetChildrenByNames([

				"_gp_call",
				"_btn_call",
				"_wayfinding_gp",
				"_btn_exit",
				"_gp_time",
				"_Image1",
				"_lb_time",
			])
	}
}
window["EveningBossNormalView"] = EveningBossNormalView

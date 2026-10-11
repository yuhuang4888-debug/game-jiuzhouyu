import { BaseItem1 } from "../common/BaseItem1"
import { SceneEventType } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { GuildActivityModel, GuildActDefine, GuildActEvent } from "../commonModel/GuildActivityModel"
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
import { Util } from "../util/Util"
import { Vector2 } from "../util/Vector2"
import { EveningBossPanel } from "./EveningBossPanel"

export class EveningBossView extends BaseItem1 {
	_boss_pos
	_can_call
	_damage_mark
	_model
	_update_id
	_wayfinding_panel
	percentHeight
	percentWidth
	preload_server_config

	Update
	public constructor(parent?) {
		super(parent)

		this._can_call = true
		this.base_file = "evening"
		this.layout_file = "EveningBossView"
		this._model = GuildActivityModel.GetInstance()
		this.percentWidth = 100
		this.percentHeight = 100
		this.load_callback = () => {
			this.InitView()
			this.LoadSuccess()
		}

		this.preload_server_config = { "config_gboss": false }
	}


	public InitView(){
		this.Update = () => {
			
			let main_role = Scene.GetInstance().main_role
			if (!main_role) {
				return
			}
			let dis = GameMath.GetDistance(main_role.real_pos.x, main_role.real_pos.y, this._boss_pos.x, this._boss_pos.y)
			if (dis <= KfHolyAreaDefine.Examination_Range * KfHolyAreaDefine.Examination_Range) {
				if (!this._damage_mark) {
					let mon_list, mon_count
					[mon_list, mon_count] = Scene.GetInstance().FindTargets(Scene.FIND_TARGET_TYPE.monster, 1, null, null, null, null, null)
					let monster = mon_list[0]
					// [ts2lua]lua中0和空字符串也是true，此处monster需要确认
					let monster_vo = (monster && (monster.GetVo()) || (null))
					if (monster_vo && monster_vo.type_id == GuildActDefine.BOSS_ID) {
						this._damage_mark = true
						UserMsgAdapter.GetInstance().SendAllFmtToGame(12025, "i", monster_vo.instance_id)
					}
				}
			} else {
				if (this._damage_mark) {
					this._damage_mark = null
				}
			}
		}
	}

	public DeleteMe() {

		if (this._wayfinding_panel) {
			this._wayfinding_panel.DeleteMe()
		}
		if (this._wayfinding_gp) {
			// Laya.Tween.removeTweens(this._wayfinding_gp)
		}
		this.RemoveRunner()
		super.DeleteMe()
	}

	public LoadSuccess() {

		this._wayfinding_panel = new EveningBossPanel(this._wayfinding_gp)
		this._wayfinding_panel.Load()
		this.SetPanelVisible()
		this.SendFmt()
		this.InitEvent()
		let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_gboss", false)
		// [ts2lua]cfg下标访问可能不正确
		let pdata = JSON.parse(cfg[12].value)[1]
		this._boss_pos = new Vector2(Number(pdata[1]), Number(pdata[2]))
		MainUIModel.GetInstance().Fire(MainUIModel.CHANGE_ACTIVITY_STATE, false)
		let mVo = SceneManager.GetInstance().GetMonsterVoByTypeId(GuildActDefine.BOSS_ID)
		if (mVo) {
			this.StartPanelAction()
		}


		
	}

	public InitEvent() {

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
		this.BindVar(this._model, "act_info", (event_name?, value?, old_value?) => {
			this.SetPanelVisible()
		}
		)
		this.BindEvent(this._model, GuildActEvent.CALL_BOSS_SUCCESS, () => {
			this.SendFmt()
			this.StartPanelAction()
		}
		)
		this.BindEvent(this._model, GuildActEvent.UPDATE_BOSS_DATA, () => {
			this.UpdateBtnStatus()
		}
		)
		this.BindEvent(MainUIModel.GetInstance(), MainUIModel.UPDATE_ACTIVITY_STATE, (bool?) => {
			if (bool) {
				// Laya.Tween.get(this._gp_call).to({left=-this._gp_call.width, alpha=0}, MainUIModel.Move_Time_Interval)
				// Laya.Tween.get(this._wayfinding_gp).to({left=-this._wayfinding_gp.width, alpha=0}, MainUIModel.Move_Time_Interval)
				this._gp_call.visible = false
				this._wayfinding_gp.visible = false
			} else {
				// Laya.Tween.get(this._gp_call).to({left=25, alpha=1}, MainUIModel.Move_Time_Interval)
				// let mVo = SceneManager.GetInstance().GetMonsterVoByTypeId(GuildActDefine.BOSS_ID)
				// // [ts2lua]lua中0和空字符串也是true，此处mVo需要确认
				// let left = (mVo && ( 0 ) || ( -this._wayfinding_gp.width ) )
				// Laya.Tween.get(this._wayfinding_gp).to({left=left, alpha=1}, MainUIModel.Move_Time_Interval)
				this._gp_call.visible = true
				this._wayfinding_gp.visible = true
			}
		}
		)
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
			// Laya.Tween.get(this._wayfinding_gp).to({left=0}, MainUIModel.Move_Time_Interval)
		}
	}

	public SetPanelVisible() {

		let act_info = this._model.GetActInfo()
		if (!act_info) {
			return
		}
		if (act_info.stage == 1) {
			this._wayfinding_gp.visible = false
		} else if (act_info.stage == 2) {
			this._wayfinding_gp.visible = true
			this._model.Fire(GuildActEvent.REQUEST_PROTO, 40201)
		}
	}

	public UpdateBtnStatus() {

		let binfo = this._model.GetBossInfo()
		if (!binfo) {
			return
		}
		this._can_call = binfo.is_drum_today == 0
		ResManager.GetInstance().SetImageSprite(this, this._btn_call, "evening_asset", (this._can_call && ( "uiygjl_001" ) || ( "uiygjl_001a" ) ))
	}

	public AddRunner() {

		// if (!this._update_id) {
		// 	this._update_id = Runner.GetInstance().AddRunObj(this, 21)
		// }
		Runner.GetInstance().AddRunObj(this, 16)
	}

	public RemoveRunner() {

		// if (this._update_id) {
		// 	Runner.GetInstance().RemoveRunObj(this._update_id)
		// 	this._update_id = null
		// }
		Runner.GetInstance().RemoveRunObj(this.hashCode)
	}


	_gp_call: Laya.Box
	_btn_call: Laya.Image
	_wayfinding_gp: Laya.Box
	_Group2: Laya.Box
	_Image1: Laya.Image
	_Group1: Laya.HBox
	_Label1: Laya.Label
	_Image2: Laya.Image
	_lb_exp: Laya.Label
	public GetComponents() {
		[
			this._gp_call,
			this._btn_call,
			this._wayfinding_gp,
			this._Group2,
			this._Image1,
			this._Group1,
			this._Label1,
			this._Image2,
			this._lb_exp,
		]
			= this.GetChildrenByNames([

				"_gp_call",
				"_btn_call",
				"_wayfinding_gp",
				"_Group2",
				"_Image1",
				"_Group1",
				"_Label1",
				"_Image2",
				"_lb_exp",
			])
	}
}
window["EveningBossView"] = EveningBossView

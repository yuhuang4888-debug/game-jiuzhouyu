import { AutoFightManager } from "../autofight/AutoFightManager"
import { BaseItem1 } from "../common/BaseItem1"
import { SceneEventType } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { BossSceneManager } from "../commonController/BossSceneManager"
import { HolyBattleModel } from "../commonModel/HolyBattleModel"
import { kfSingleRankModel } from "../commonModel/kfSingleRankModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Scene } from "../scene/Scene"
import { SceneObj } from "../scene/sceneobj/SceneObj"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { Mathf } from "../util/Mathf"
import { Util, Color, SetLocalScaleX } from "../util/Util"
import { Vector2 } from "../util/Vector2"

export class HolyBattleTowerItem extends BaseItem1 {
	Emp_gp_go
	InitEvent
	LoadSuccess
	Local_DeleteMe
	RefreshWarGroup
	SetData
	UpdateState
	UpdateTowerVo
	UpdateView
	need_refresh_data

	public static ProgressWidth = 126
	public constructor(parent?) {
		super(parent)


		this.base_file = "holyBattle"
		this.layout_file = "HolyBattleTowerItem"
		this.need_refresh_data = null

		let local_Scene = Scene.GetInstance()
		let local_GlobalEventSystem = GlobalEventSystem
		let local_SceneEventType = SceneEventType
		let local_MainRoleVo = RoleManager.GetInstance().GetMainRoleVo()
		let local_HolyBattleModel = HolyBattleModel
		let local_HolyBattleModel_Instance = HolyBattleModel.GetInstance()
		let boss_scene_mgr = BossSceneManager.GetInstance()
		let auto_fight_mgr = AutoFightManager.GetInstance()
		let _data = null
		let _tower_group_id = null
		let _tower_id_dic = null
		this.preload_server_config = { "config_role_holy_spirit_battlefield_group": false }

		let green = "#00b11d"
		let color2 = "#000000"
		let orange = "#ff6519"


		this.load_callback = () => {

			this.LoadSuccess()
		}

		this.LoadSuccess = () => {
			this.InitEvent()

			if (this.need_refresh_data) {
				this.UpdateView()
				this.need_refresh_data = false
			}
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._gp_go, () => {
				if (_data) {
					let real_x = _data.x / SceneObj.GetLogicRealRatio().x
					let real_y = _data.y / SceneObj.GetLogicRealRatio().y

					auto_fight_mgr.SetAutoFight(true)
					boss_scene_mgr.SetAutoState(true)
					local_Scene.SetClickTarget(null)
					local_Scene.MainRoleMove(new Vector2(real_x, real_y))
				}
			}
				, this, true)
			this.BindEvent(local_HolyBattleModel_Instance, local_HolyBattleModel.UPDATE_MON_DATA, () => {
				this.UpdateTowerVo()
			}
			)
			this.BindVar(RoleManager.GetInstance().GetMainRoleVo(), "warGroup", () => {
				this.RefreshWarGroup()
			}
			)
		}

		this.SetData = (data?) => {
			_data = data
			if (this.is_loaded) {
				this.UpdateView()
			} else {
				this.need_refresh_data = true
			}
		}

		this.UpdateState = (state?) => {

			if (state) {
				this._lb_name.color = green
				ResManager.GetInstance().SetImageSprite(this, this._img_hp, "holyBattle_asset", "ui_xt_002", true)
				ResManager.GetInstance().SetImageSprite(this, this._img_go, "common", "ui_button_rect14", true)
				this._lb_go.text = "守卫"
			} else {
				this._lb_name.color = orange
				ResManager.GetInstance().SetImageSprite(this, this._img_hp, "holyBattle_asset", "ui_xt_001", true)
				ResManager.GetInstance().SetImageSprite(this, this._img_go, "common", "ui_button_rect11", true)
				this._lb_go.text = "进攻"
			}
		}

		this.UpdateView = () => {
			_tower_id_dic = []
			for (let _tmpi in _data.mon_list) {
				var vo = _data.mon_list[_tmpi]
				_tower_id_dic[Number(vo[1])] = true
			}
			this.UpdateTowerVo()
		}

		this.UpdateTowerVo = () => {
			let mon_data = local_HolyBattleModel_Instance.GetMonData()
			let data = null
			let bool = false
			if (mon_data) {
				for (let key in mon_data) {

					data = mon_data[key]
					if (data && _tower_id_dic[data.mon_cfg_id]) {
						bool = true
						break
					}
				}
			}
			if (bool) {
				_tower_group_id = data.group_id
				let mon_id = data.mon_cfg_id
				let end_id=mon_id%10
				ResManager.GetInstance().SetImageSprite(this, this._img_tips, "holyBattle_asset", `uifh_0${end_id}`, true)
				this.RefreshWarGroup()

				let hp = data.hp / data.hp_all
				SetLocalScaleX(this._img_hp, hp)
				//SetSizeDeltaX(this._img_hp, hp * HolyBattleTowerItem.ProgressWidth)
				this._lb_hp.text = Mathf.Floor(hp * 100) + "%"
			}
		}

		this.RefreshWarGroup = () => {
			let spirit_battlefield_group_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_role_holy_spirit_battlefield_group", false)//Config.Roleholyspiritbattlefieldgroup
			if (spirit_battlefield_group_cfg) {


				let group_cfg = spirit_battlefield_group_cfg[_tower_group_id]
				if (group_cfg) {
					this._lb_name.color = green
					this._lb_name.text = group_cfg.name
					this.UpdateState(local_MainRoleVo.warGroup == _tower_group_id)
				} else {
					this._lb_name.color = orange
					this._lb_name.text = "中立"
					this.UpdateState(false)
				}
			}
		}

		this.Local_DeleteMe = () => {

		}


	}

	public DeleteMe() {
		super.DeleteMe()
	}

	_Image1: Laya.Image
	_img_tips: Laya.Image
	_img_name_bg: Laya.Image
	_lb_name: Laya.Label
	_Image2: Laya.Image
	_img_hp: Laya.Image
	_gp_go: Laya.Box
	_img_go: Laya.Image
	_lb_go: Laya.Label
	_lb_hp: Laya.Label
	public GetComponents() {
		[
			this._Image1,
			this._img_tips,
			this._img_name_bg,
			this._lb_name,
			this._Image2,
			this._img_hp,
			this._gp_go,
			this._img_go,
			this._lb_go,
			this._lb_hp,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_img_tips",
				"_img_name_bg",
				"_lb_name",
				"_Image2",
				"_img_hp",
				"_gp_go",
				"_img_go",
				"_lb_go",
				"_lb_hp",
			])
	}
}
window["HolyBattleTowerItem"] = HolyBattleTowerItem
import { AutoFightManager } from "../autofight/AutoFightManager"
import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { BossSceneManager } from "../commonController/BossSceneManager"
import { BossModel } from "../commonModel/BossModel"
import { PlatformManager } from "../PlatformManager"
import { RoleManager } from "../commonModel/RoleManager"
import { Scene } from "../scene/Scene"
import { SceneManager } from "../scene/SceneManager"
import { Util } from "../util/Util"

export class BossDamageSubItem extends BaseItemRenderer {

	public WIDTH = 220 //86 + 13
	public HEIGT = 36


	boss_scene_mgr
	can_fight
	attack_obj
	public constructor() {
		super()

		this.base_file = "boss"
		this.layout_file = "BossDamageSubItem"
		this.boss_scene_mgr = BossSceneManager.GetInstance()
		this.load_callback = () => {
			this.LoadSuccess()
		}
		this.Load()
	}

	public LoadSuccess() {


		// if (PlatformManager.IsEyouIdnPlatform() ) {
		// 	this._lb_name.size  = 18
		// 	this._lb_name.lineSpacing = 0.7
		// }

		// this.BindEvent(TeamModel.GetInstance(), TeamEvent.TEAM_UPDATE_TERAM_HALL, () => {
		// 	this.UpdateAtteck()
		// })

		Util.AddClickEvent(this, () => {
			if (!this.can_fight) {
				this.boss_scene_mgr.SetAutoState(true)
				return
			}
			this.boss_scene_mgr.SetAutoState(false)
			this.boss_scene_mgr.SetAttackTarget(this.attack_obj)
			Scene.GetInstance().SetClickTarget(this.attack_obj)
			AutoFightManager.GetInstance().SetAutoFight(true)
			BossModel.GetInstance().Fire(BossModel.CHANGE_BOSS_TARGET, this.attack_obj)
		}, this, true)
	}

	public DeleteMe() {
		super.DeleteMe()
	}

	public dataChanged() {
		if (super.dataChanged()) {
			if (!this.data) { return }
			//
			let color = RoleManager.GetInstance().GetMainRoleId() == this.data.player_id && "#60AEFF" || "#ffffff"
			this._lb_name.text = this.data.player_name
			this._lb_name.color = color
			this._lb_hurt.text = this.data.modulus + "%"
			this._img_rank.visible = this.data.rank && this.data.rank <= 3
			this._lb_rank.visible = this.data.rank && this.data.rank > 3

			if (this.data.rank && this.data.rank <= 3) {
				ResManager.GetInstance().SetImageSprite(this, this._img_rank, "boss", `ui_phb_1${this.data.rank}`)
			} else {
				this._lb_rank.text = this.data.rank || ""
			}
			this.UpdateAtteck()
		}
	}
	public UpdateAtteck() {

		if (!this.data) { return }

		let role_list = BossSceneManager.GetInstance().GetSortSecneRoleList()
		this.attack_obj = null
		for (let _ in role_list) {
			var v = role_list[_]
			if (v.id == this.data.player_id) {
				this.attack_obj = v
			}
		}
		if (this.attack_obj && this.attack_obj._type) {
			this.can_fight = SceneManager.GetInstance().IsCanAttackByMainRole(this.attack_obj.vo)
		}
	}




	_img_line: Laya.Image
	_lb_name: Laya.Label
	_lb_hurt: Laya.Label
	_img_rank: Laya.Image
	_lb_rank: Laya.Label
	public GetComponents() {
		[
			this._img_line,
			this._lb_name,
			this._lb_hurt,
			this._img_rank,
			this._lb_rank,
		]
			= this.GetChildrenByNames([

				"_img_line",
				"_lb_name",
				"_lb_hurt",
				"_img_rank",
				"_lb_rank",
			])
	}
}

window["BossDamageSubItem"] = BossDamageSubItem
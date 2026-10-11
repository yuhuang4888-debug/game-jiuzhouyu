import { AutoFightManager } from "../autofight/AutoFightManager"
import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { Config } from "../common/Config"
import { CustomHeadItem } from "../common/CustomHeadItem"
import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { BossSceneManager } from "../commonController/BossSceneManager"
import { NineSkyModel } from "../commonModel/NineSkyModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Scene } from "../scene/Scene"
import { SceneBaseType } from "../scene/SceneConfig"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"

export class NineSkyFightHeadItem extends BaseItemRenderer {
	WIDTH = 76
	HEIGT = 97

	hp_event

	head1
	_is_attacted = false
	_is_suffered = false
	is_attack = false
	effect

	model: NineSkyModel
	cache_vo
	hp_mask: Laya.Sprite
	hp_mask_width
	public constructor() {
		super()
		this.base_file = "nineSky"
		this.layout_file = "NineSkyFightHeadItem"
		this.model = NineSkyModel.GetInstance()
		this.load_callback = () => {
			this.LoadSuccess()

		}
		this.Load()
	}

	public LoadSuccess() {
		this.hp_mask = new Laya.Sprite()
		this.hp_mask.pos(34, 34)
		this._img_hp.mask = this.hp_mask

		this.hp_mask_width = this._img_hp.width / 2 + 5
		this.InitEvent()
		this.AddAttackEffect()
		
	}

	private AddAttackEffect(){
		if(Scene.GetInstance().GetClickTarget() && Scene.GetInstance().GetClickTarget().vo){
			let vo = Scene.GetInstance().GetClickTarget().vo
			if (this.data && this.data.vo != vo && this.is_attack) {
				this.ShowAttackEffect(false)
			}
			if (this.data && this.data.vo == vo && !this.is_attack) {
				this.ShowAttackEffect(true)
			}
		}
	}

	public InitEvent() {
		Util.AddClickEvent(this._img_bg, () => {
			this.ClickHead()
		}, this)

		this.BindVar(this.model, "top_info", (event_name?, now_value?) => {
			let info = this.model.GetTopInfo()
			let vo = this.data && this.data.vo
			if (vo && vo.vo_type != SceneBaseType.Monster && info && info.role_id == vo.role_id) {
				this._img_tips.visible = true
			} else {
				this._img_tips.visible = false
			}
		})

		this.BindEvent(GlobalEventSystem, EventName.MAIN_ROLE_CHANGE_ATTACK_TARGRT, (target?) => {
			//攻击目标
			if (target && target.vo) {
				if (this.data && this.data.vo == target.vo && this.is_attack) {
					return
				}
				if (this.data && this.data.vo != target.vo && this.is_attack) {
					this.ShowAttackEffect(false)
				}
				if (this.data && this.data.vo == target.vo && !this.is_attack) {
					this.ShowAttackEffect(true)
				}
			} 
		}
		)

	}

	public ShowAttackEffect(value?) {

		if (value == this.is_attack) {
			return
		}
		this.is_attack = value
		if (value) {
			if (!this.effect) {
				this.effect = true
			}
			this.base_item.AddUIEffect("UI_2017", this._box_attack_effect, null, 12, true)
		} else {
			if (this.effect) {
				this.base_item.ClearUIEffect(this._box_attack_effect)
				this.effect = false
			}
		}
		if (this._box_attack_effect.visible != value) {
			this._box_attack_effect.visible = value
		}
	}

	ClickHead = () =>{
		let vo = this.data.vo
			if (vo) {
				if (vo.vo_type != SceneBaseType.Monster) {
					let obj = Scene.Instance.GetRole(vo.role_id)
					if (obj) {
						Scene.Instance.SetClickTarget(obj)
					}
				} else {
					let obj = Scene.Instance.GetMonster(vo.instance_id)
					if (obj) {
						Scene.Instance.SetClickTarget(obj)
					}
				}

				if (!AutoFightManager.GetInstance().GetAutoFightState()) {
					AutoFightManager.GetInstance().SetAutoFight(true)
				}
			}
	}

	protected dataChanged() {
		if (!super.dataChanged()) return
		let vo = this.data.vo
		this.AddAttackEffect()
		this.CancelHpEvent()
		if (vo) {
			this.cache_vo = vo
			if (vo.vo_type == SceneBaseType.Role) {

				this._head.visible = true
				this._img_head.visible = false


				// let picture_source = vo.career && vo.career + "001" || RoleManager.GetInstance().mainRoleInfo.career
				// if (vo.picture && (String(vo.picture)) != "") {
				// 	let pic_cfgs = ResManager.GetInstance().GetGameConfigFromCache(this.base_item, "config_picture", false)
				// 	let picture_cfg = pic_cfgs[vo.picture]
				// 	if (picture_cfg) {
				// 		picture_source = picture_cfg.resource
				// 	}
				// }
				//ResManager.GetInstance().SetOutsideImageSprite(this, this._img_head, GameResPath.GetIcon("head", picture_source))

				if (this.head1 == null) {
					this.head1 = new CustomHeadItem(this._head)
					this.head1.SetActiveFrame(false)
					this.head1.SetActiveLevel(false)
					this.head1.SetActiveBg(false)

					// this.head1.CloseClick()
					this.head1.SetScale(0.75)
					this.head1.Load()
					this.head1.SetClickFunc(this.ClickHead)
				}
				this.head1.SetActiveBg(false)
				this.head1.SetRoleVoData(vo, vo.turn, vo.server_unique_id)
				this.head1.SetActiveBg2(false)



				this._lb_lv.text = "Lv." + vo.level
				let top_info = NineSkyModel.GetInstance().GetTopInfo()
				if (top_info && top_info.role_id == vo.role_id) {
					this._img_tips.visible = true
				} else {
					this._img_tips.visible = false
				}
			} else if (vo.vo_type == SceneBaseType.Monster) {
				this._head.visible = false
				this._img_head.visible = true
				this._img_tips.visible = false
				this._lb_lv.text = "Lv." + vo.level
				let cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_mon.name, vo.type_id, false)
				let icon_res = cfg && cfg.icon || 0
				ResManager.GetInstance().SetOutsideImageSprite(this, this._img_head, GameResPath.GetMonsterHeadPath(icon_res))
			}

			this._lb_name.text = vo.name
			// this.DrawMaskCircle(0.7)

			this.DrawMaskCircle(vo.hp / vo.maxHp)
			this.hp_event = vo.BindOne("hp", (event_name?, now_hp?, old_hp?) => {
				if (vo) {
					this.DrawMaskCircle(now_hp / vo.maxHp)
					if (now_hp <= 0) {
						let id = vo.vo_type == SceneBaseType.Monster && vo.instance_id || vo.role_id
						this.model.Fire(NineSkyModel.REMOVE_ROLE, id)
						this.CancelHpEvent()
					}
				}
			})

		}
	}

	public DrawMaskCircle = (angle) => {
		angle = 1 - angle
		this.hp_mask.graphics.clear();
		this.hp_mask.graphics.drawPie(0, 0, this.hp_mask_width, angle * 360 - 90, 360 - 90, 0x000000)
	}

	public CancelHpEvent() {
		if (this.cache_vo && this.hp_event) {
			this.cache_vo.UnBind(this.hp_event)
		}
	}

	public DeleteMe() {

		if (this.head1) {
			this.head1.DeleteMe()
			this.head1 = null
		}
		this.CancelHpEvent()
		this.cache_vo = undefined
		super.DeleteMe()
	}


	_img_bg: Laya.Image
	_img_bg2: Laya.Image
	_img_head: Laya.Image
	_head: Laya.Box
	_img_tips: Laya.Image
	_img_hp: Laya.Image
	_lb_lv: Laya.Label
	_lb_name: Laya.Label
	_box_suffer_effect: Laya.Box
	_box_attack_effect: Laya.Box
	public GetComponents() {
		[
			this._img_bg,
			this._img_bg2,
			this._img_head,
			this._head,
			this._img_tips,
			this._img_hp,
			this._lb_lv,
			this._lb_name,
			this._box_suffer_effect,
			this._box_attack_effect,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_img_bg2",
				"_img_head",
				"_head",
				"_img_tips",
				"_img_hp",
				"_lb_lv",
				"_lb_name",
				"_box_suffer_effect",
				"_box_attack_effect",
			])
	}
}
window["NineSkyFightHeadItem"] = NineSkyFightHeadItem
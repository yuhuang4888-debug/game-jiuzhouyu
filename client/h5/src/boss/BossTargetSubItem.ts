import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { Config } from "../common/Config"
import { CustomHeadItem } from "../common/CustomHeadItem"
import { ResManager } from "../common/ResManager"
import { BossSceneManager } from "../commonController/BossSceneManager"
import { RoleManager } from "../commonModel/RoleManager"
import { SceneBaseType } from "../scene/SceneConfig"
import { SceneManager } from "../scene/SceneManager"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest, Util } from "../util/Util"

export class BossTargetSubItem extends BaseItemRenderer {

	public WIDTH = 76 //86 + 13
	public HEIGT = 97

	time
	is_attack
	is_suffered
	last_boss_id
	timer_id
	head_item
	effect

	boss_scene_mgr: BossSceneManager

	circle_mask:Laya.Sprite
	public constructor(parent) {
		super()
		this.base_file = "boss"
		this.layout_file = "BossTargetSubItem"

		this.time = 0
		this.is_attack = false
		this.is_suffered = false
		this.boss_scene_mgr = BossSceneManager.GetInstance()

		this.load_callback = () => {
			this.LoadSuccess()
		}
		this.Load()
	}

	public LoadSuccess() {
		this.circle_mask = new Laya.Sprite()
		// this._box_progress.addChild(this.circle_mask)
		this.circle_mask.x = this._box_progress.width / 2
		this.circle_mask.y = this._box_progress.height / 2
		this._img_progress_bar.mask = this.circle_mask

		// let width = this._box_progress.width / 2
		Util.AddClickEvent(this._img_bg, () => {
			this.boss_scene_mgr.Fire(BossSceneManager.SWITCH_ITEM, this.index)
		}, this)
	}

	public DrawMaskCircle(angle){
		angle = 1 - angle
		this.circle_mask.graphics.clear();
		this.circle_mask.graphics.drawPie(0, 0, 50, angle * 360 - 90, 360 - 90, 0x000000)
	}

	public dataChanged() {
		if (super.dataChanged()) {
			let data = this.data
			if (data._type && data._type == SceneBaseType.Monster || (!data._type && !data.role_id) && this.index == 0
			) {
				this._box_head.visible = false
				this._img_head.visible = true
				if (data._type) {
					if (data.vo) {
						this._lb_name.text = data.vo.name
						this._lb_lv.text = "Lv." + data.vo.level
						let source = ((data.vo.hp / data.vo.maxHp) <= 0.3) && "uizdpz_016a" || "uizdpz_016"
						// ResManager.GetInstance().SetImageSprite(this, this._img_progress_bar, this.base_file, "uizdpz_016a")

						ResManager.GetInstance().SetOutsideImageSprite(
							this,
							this._img_head,
							GameResPath.GetMonsterHeadPath(data.vo.cfg_data.icon)
						)
						this.DrawMaskCircle(data.vo.hp / data.vo.maxHp)
						// this._progress_bar.fillAmount = data.vo.hp / data.vo.maxHp
					}
					this._lb_count.visible = false
					this._box_progress.visible = true

					this.RemoveTimer()
					//lua_resM:SetImageSprite(this,this._progress_bar,this.base_file + "_asset","uihsl_026")
					this.ShowSufferedEffect(!this.is_attack && this.boss_scene_mgr.IsSuffered(data.id))
				} else {
					this._lb_name.text = data.boss_name

					this._box_progress.visible = false
					this._lb_count.visible = true
					if (this.last_boss_id != data.boss_id) {
						this.time = Math.max(data.reborn_time - TimeUtil.getServerTime(), 0)
					} else {
						this.time = this.time > 0 && this.time || Math.max(data.reborn_time - TimeUtil.getServerTime(), 0)
					}
					this._lb_count.text = TimeUtil.convertTime(this.time)

					
					if (!this.timer_id) {
						this.time = this.time + 1
						let loop_func = () => {
							this.time = this.time - 1
							this._lb_count.text = TimeUtil.convertTime(this.time)
							if (this.time < 0) {
								this.RemoveTimer()
								this._lb_count.visible = false
								this._box_progress.visible = true
							}
						}
						this.timer_id = GlobalTimerQuest.AddPeriodQuest(loop_func, 1, -1)
						loop_func()
					}
					this.ShowSufferedEffect(false)

					let bossVo = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_mon.name, data.boss_id, false)
					if (bossVo) {
						//等级由服务端确定
						if (data.mon_lv && data.mon_lv != 0) {
							this._lb_lv.text = "Lv." + data.mon_lv
						} else {
							this._lb_lv.text = "Lv." + bossVo.lv
						}
						ResManager.GetInstance().SetOutsideImageSprite(this, this._img_head, GameResPath.GetMonsterHeadPath(bossVo.icon))
					}
					this.last_boss_id = data.boss_id
				}
				this._img_owner.visible = false
				this.ShowBool(data)
			} else if ((data._type && data._type == SceneBaseType.Role) && data.vo) {
				this._box_head.visible = true
				this._img_head.visible = false
				this._img_owner.visible = data.vo.boss_flag == 1

				let is_mask = data.vo.mask_id != 0 && SceneManager.GetInstance().CanMaskScene()
				this._lb_name.text = is_mask && "蒙面人" || data.vo.name
				let lv = data.vo.level > 370 && "神创" + ((data.vo.level - 370)) || "Lv." + data.vo.level
				this._lb_lv.text = is_mask && "" || lv
				this._lb_count.visible = false
				this._box_progress.visible = true
				let source = ((data.vo.hp / data.vo.maxHp) <= 0.3) && "uizdpz_016a" || "uizdpz_016"
				this.DrawMaskCircle(data.vo.hp / data.vo.maxHp)
				// this._progress_bar.fillAmount = data.vo.hp / data.vo.maxHp

				this.ShowSufferedEffect(!this.is_attack && this.boss_scene_mgr.IsSuffered(data.id))
				// let picture_source = data.vo.career + "001"
				// let picture_id = data.vo.picture
				// if (picture_id && String(picture_id) != "") {
				// 	let cfgs = ResManager.GetInstance().GetGameConfigFromCache(this.base_item, "config_picture", false)
				// 	let picture_cfg = cfgs[picture_id]
				// 	if (picture_cfg) {
				// 		picture_source = picture_cfg.resource
				// 	}
				// }
				//lua_resM:SetOutsideImageSprite(this, this._img_head, GameResPath.GetIcon("head_item",picture_source))
				this.ShowBool(data)
				if (this.head_item == null) {
					this.head_item = new CustomHeadItem(this._box_head)
					this.head_item.Load()
				}
				this.head_item.SetRoleVoData(is_mask && { career: data.vo.career } || data.vo)
				this.head_item.CloseClick()
				this.head_item.ExcuteCallback(() => {
					this.head_item.SetActiveFrame(false)
					this.head_item.SetActiveLevel(false)
					this.head_item.SetActiveBg(false)
					this.head_item.SetScale(0.8)
					this.head_item.icon_sys_head.x = 0.5
					this.head_item.icon_sys_head.y = -4
				})
			} else if (data.role_id == RoleManager.GetInstance().GetMainRoleId()) {
				this._box_head.visible = true
				this._img_head.visible = false
				this._img_owner.visible = data.boss_flag == 1

				let is_mask = data.mask_id != 0 && SceneManager.GetInstance().CanMaskScene()
				this._lb_name.text = is_mask && "蒙面人(自己)" || data.name

				let lv = data.level > 370 && "神创" + (data.level - 370) || "Lv." + data.level
				this._lb_lv.text = is_mask && "" || lv
				this._lb_count.visible = false
				this._box_progress.visible = true
				let source = ((data.hp / data.maxHp) <= 0.3) && "uizdpz_016a" || "uizdpz_016"
				//lua_resM:SetImageSprite(this,this._progress_bar,this.base_file + "_asset",source)
				//SetSizeDeltaX(this._progress_mask,data.hp / data.maxHp * this.progress_width)
				this.DrawMaskCircle(data.vo.hp / data.vo.maxHp)
				// this._progress_bar.fillAmount = data.hp / data.maxHp
				// let picture_source = data.career + "001"
				// let picture_id = data.picture
				// if (picture_id && String(picture_id) != "") {
				// 	let cfgs = ResManager.GetInstance().GetGameConfigFromCache(this.base_item, "config_picture", false)
				// 	let picture_cfg = cfgs[Number(picture_id)]
				// 	if (picture_cfg) {
				// 		picture_source = picture_cfg.resource
				// 	}
				// }
				//lua_resM:SetOutsideImageSprite(this, this._img_head, GameResPath.GetIcon("head_item",picture_source))
				this.ShowBool(data)
				if (this.head_item == null) {
					this.head_item = new CustomHeadItem(this._box_head)
					//this.head_item.SetScale(0.67)
					this.head_item.Load()
				}
				this.head_item.SetRoleVoData(data)
				this.head_item.CloseClick()
				this.head_item.ExcuteCallback(() => {
					this.head_item.SetActiveFrame(false)
					this.head_item.SetActiveLevel(false)
					this.head_item.SetActiveBg(false)
					this.head_item.icon_sys_head.x = 0.5
					this.head_item.icon_sys_head.y = -4
					this.head_item.SetScale(0.8)
				})
			}

			this.ShowAttackEffect(
				data == this.boss_scene_mgr.GetAttackTarget() && !this.boss_scene_mgr.GetAttackTarget().is_dead
			)

		}
	}

	public ShowBool(data?) {

		let canAttack = SceneManager.GetInstance().IsCanAttackByMainRole(data.vo, false,false,false)
		if (canAttack) {
			ResManager.GetInstance().SetImageSprite(this, this._img_progress_bar, this.base_file + "_asset", "uizdpz_016a")
		} else {
			ResManager.GetInstance().SetImageSprite(this, this._img_progress_bar, this.base_file + "_asset", "uizdpz_016")
		}
	}

	public RemoveTimer() {

		if (this.timer_id) {
			GlobalTimerQuest.CancelQuest(this.timer_id)
			this.timer_id = null
			this.time = 0
		}
	}

	public DeleteMe() {
		this.base_item.ClearUIEffect(this._box_attack_effect)
		this.RemoveTimer()
		if (this.head_item) {
			this.head_item.DeleteMe()
			this.head_item = null
		}
		super.DeleteMe()
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

	public ShowSufferedEffect(value?) {

		// if (value == this.is_suffered ) {
		// 	return
		// }
		// this.is_suffered = value
		// if (value ) {
		// 	if (! this.effect ) {
		// 		this.effect =  new UIEffect()
		// 	}
		// 	this.effect.AddUIEffect("border_redglow", this._suffer_effect_gp, {x = 0, y = 6}, null, true)
		// }else{
		// 	if (this.effect ) {
		// 		this.effect.ClearUIEffect(this._suffer_effect_gp)
		// 	}
		// }
		// if (this._suffer_effect_gp.visible != value ) {
		// 	this._suffer_effect_gp.visible = value
		// }
	}

	_box_con: Laya.Box
	_img_bg: Laya.Image
	_Image2: Laya.Image
	_img_head: Laya.Image
	_box_head: Laya.Box
	_lb_count: Laya.Label
	_box_progress: Laya.Box
	_img_progress_bar: Laya.Image
	_lb_lv: Laya.Label
	_lb_name: Laya.Label
	_img_owner: Laya.Image
	_box_attack_effect: Laya.Box
	_box_suffer_effect: Laya.Box
	public GetComponents() {
		[
			this._box_con,
			this._img_bg,
			this._Image2,
			this._img_head,
			this._box_head,
			this._lb_count,
			this._box_progress,
			this._img_progress_bar,
			this._lb_lv,
			this._lb_name,
			this._img_owner,
			this._box_attack_effect,
			this._box_suffer_effect,
		]
			= this.GetChildrenByNames([

				"_box_con",
				"_img_bg",
				"_Image2",
				"_img_head",
				"_box_head",
				"_lb_count",
				"_box_progress",
				"_img_progress_bar",
				"_lb_lv",
				"_lb_name",
				"_img_owner",
				"_box_attack_effect",
				"_box_suffer_effect",
			])
	}
}
window["BossTargetSubItem"] = BossTargetSubItem
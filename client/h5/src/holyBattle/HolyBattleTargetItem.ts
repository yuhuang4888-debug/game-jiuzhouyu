import { AutoFightManager } from "../autofight/AutoFightManager"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { CustomHeadItem } from "../common/CustomHeadItem"
import { ResManager } from "../common/ResManager"
import { BossSceneManager } from "../commonController/BossSceneManager"
import { HolyBattleModel } from "../commonModel/HolyBattleModel"
import { Scene } from "../scene/Scene"
import { SceneBaseType } from "../scene/SceneConfig"
import { SceneManager } from "../scene/SceneManager"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { Util, GlobalTimerQuest, Trim, SetLocalScale, SetAnchoredPosition } from "../util/Util"
import { Config } from "../common/Config"
import { BossModel } from "../commonModel/BossModel"
import { BaseItem1 } from "../common/BaseItem1"
export class HolyBattleTargetItem extends BaseItem1 {
	Out_lv_lb
	boss_scene_mgr
	cur_sorting_order
	effect
	head
	holy_battle_model
	is_attack
	is_suffered
	lastBossId
	progress_Width
	time
	timer1
	tips_img
	circle_mask: Laya.Sprite
	// public WIDTH = 76
	// public HEIGT = 90

	data
	index
	is_need_fresh
	public constructor(parent) {
		super(parent)


		this.base_file = "boss"
		this.layout_file = "BossTargetPanelItem"
		//this.layer_value = "Main"

		this.progress_Width = 0
		this.time = 0
		this.timer1 = null
		this.effect = null
		this.lastBossId = null
		this.tips_img = null
		this.head = null

		this.is_attack = false
		this.is_suffered = false

		this.boss_scene_mgr = BossSceneManager.GetInstance()
		this.holy_battle_model = HolyBattleModel.GetInstance()
		this.is_need_fresh=false
		this.load_callback = () => {
			this.InitMask()
			this.LoadSuccess()

			if(this.is_need_fresh){
				this.is_need_fresh=false
				this.dataChanged()
			}
		}
	}


	public SetData(data,index){
		this.data=data
		this.index=index

		if(!this.is_loaded){
			this.is_need_fresh=true
			return
		}

		this.dataChanged()
	}



	public InitMask() {
		this.circle_mask = new Laya.Sprite()
		this.circle_mask.x = this._progress_bar.width / 2
		this.circle_mask.y = this._progress_bar.height / 2
		this._progress_bar.mask = this.circle_mask
	}


	public DrawMaskCircle(angle) {
		angle = 1 - angle
		let value = 90
		this.circle_mask.graphics.clear();
		this.circle_mask.graphics.drawPie(0, 0, 50, value, 360 + value - angle * 360, 0x000000)
	}


	public LoadSuccess() {

		this.progress_Width = this._progress_bar.width
		this._gp_fighting.visible = false

		this.DrawMaskCircle(0)

		Util.AddClickEvent(this._gp_child, () => {
			this.holy_battle_model.Fire(HolyBattleModel.SWITCH_ITEM, this.index)
		}, this, true)
	}

	public dataChanged() {
		this.RemoveTimer()
		if (!this.data) {
			return
		}
		

		let vo = this.data
		if (!vo.vo_type) {
			this._head.visible = false
			this._head_img.visible = true

			let bossVo = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_mon.name, vo.bossid, false)

			this._name_lb.text = bossVo.name
			this._lv_lb.text = ""

			this._progress_gp.visible = false
			this._count_lb.visible = true
			if (this.lastBossId != vo.bossid) {
				this.time = Math.max(vo.reborn_time - TimeUtil.getServerTime(), 0)
			} else {
				this.time = this.time > 0 && this.time || Math.max(vo.reborn_time - TimeUtil.getServerTime(), 0)
			}
			this._count_lb.text = TimeUtil.convertTime(this.time)
			if (!this.timer1) {
				let loop_func = () => {
					this.time = this.time - 1
					this._count_lb.text = TimeUtil.convertTime(this.time)
					if (this.time < 0) {
						this.RemoveTimer()
						this._count_lb.visible = false
						this._progress_gp.visible = true
					}
				}
				this.timer1 = GlobalTimerQuest.AddPeriodQuest(loop_func, 1, -1)
				loop_func()
			}
			this.showSufferedEffect(false)
			ResManager.GetInstance().SetOutsideImageSprite(this, this._head_img, GameResPath.GetIcon("monsterHead", bossVo.icon))
			this.lastBossId = vo.bossid
			this._gp_attribution.visible = false
		} else if (vo.vo_type == SceneBaseType.Monster) {
			this._head.visible = false
			this._head_img.visible = true
			if (vo.warGroup > 0) {
				let spirit_battlefield_group_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_role_holy_spirit_battlefield_group", false)//Config.Roleholyspiritbattlefieldgroup
				if (spirit_battlefield_group_cfg) {
					let group_cfg = spirit_battlefield_group_cfg[vo.warGroup]
					if (group_cfg) {
						this._name_lb.text = group_cfg.name
					}
				}
			} else {
				this._name_lb.text = "中立"
			}
			this._lv_lb.text = ""
			//SetSizeDeltaX(this._progress_mask,vo.hp / vo.maxHp * this.progress_Width)
			//this._progress_bar.fillAmount = vo.hp / vo.maxHp
			this.DrawMaskCircle(vo.hp / vo.maxHp)

			this._count_lb.visible = false
			this._progress_gp.visible = true
			this.UpdateHpState(vo)
			if (vo.cfg_data) {
				ResManager.GetInstance().SetOutsideImageSprite(this, this._head_img, "resource/game/monsterHead/" + vo.cfg_data.icon + ".png")
			}
			this.showSufferedEffect(!this.is_attack && this.boss_scene_mgr.IsSuffered(vo.instance_id))
			this._gp_attribution.visible = false

		} else if (vo.vo_type == SceneBaseType.Role) {
			this._head.visible = true
			this._head_img.visible = false
			this._gp_attribution.visible = vo.boss_flag == 1

			this._name_lb.text = vo.name
			this._lv_lb.text = "Lv." + vo.level
			this._count_lb.visible = false
			this._progress_gp.visible = true
			//SetSizeDeltaX(this._progress_mask,vo.hp / vo.maxHp * this.progress_Width)
			//this._progress_bar.fillAmount = vo.hp / vo.maxHp
			this.DrawMaskCircle(vo.hp / vo.maxHp)

			// let picture_source = vo.career + "001"
			// let picture_id = vo.picture
			// if (picture_id && Trim(String(picture_id)) != "") {
			// 	let picture_cfg = Config.PRELOAD_SERVER_CONFIG.config_picture[Number(picture_id)]
			// 	if (picture_cfg) {
			// 		picture_source = picture_cfg.resource
			// 	}
			// }
			//lua_resM:SetOutsideImageSprite(this, this._head_img, GameResPath.GetIcon("head",picture_source))
			if (this.head == null) {
				this.head = new CustomHeadItem(this._head)
				this.head.SetActiveFrame(false)
				this.head.SetActiveLevel(false)
				this.head.CloseClick()
				this.head.SetScale(0.67)
				this.head.Load()
			}
			this.head.SetRoleVoData(vo, vo.turn, vo.server_unique_id)
			this.head.SetActiveBg2(false)

			this.showSufferedEffect(!this.is_attack && this.boss_scene_mgr.IsSuffered(vo.role_id))
			this.UpdateHpState(vo)
		} else if (vo.vo_type == SceneBaseType.MainRole) {
			this._head.visible = true
			this._head_img.visible = false
			this._gp_attribution.visible = vo.boss_flag == 1
			this._name_lb.text = vo.name
			this._lv_lb.text = "Lv." + vo.level
			this._count_lb.visible = false
			this._progress_gp.visible = true
			//SetSizeDeltaX(this._progress_mask,vo.hp / vo.maxHp * this.progress_Width)
			//this._progress_bar.fillAmount = vo.hp / vo.maxHp
			this.DrawMaskCircle(vo.hp / vo.maxHp)

			let picture_source = vo.career + "001"
			let picture_id = vo.picture
			if (picture_id && Trim(String(picture_id)) != "") {
				let picture_cfg = Config.PRELOAD_SERVER_CONFIG.config_picture[Number(picture_id)]
				if (picture_cfg) {
					picture_source = picture_cfg.resource
				}
			}
			//lua_resM:SetOutsideImageSprite(this, this._head_img, GameResPath.GetIcon("head",picture_source))
			if (this.head == null) {
				this.head = new CustomHeadItem(this._head)
				this.head.SetActiveFrame(false)
				this.head.SetActiveLevel(false)
				this.head.CloseClick()
				this.head.SetScale(0.67)
				this.head.Load()
			}
			this.head.SetRoleVoData(vo, vo.turn, vo.server_unique_id)

			this.UpdateHpState(vo)
		}


		if (vo.vo_type == SceneBaseType.Monster) {
			if (!this.tips_img) {
				this.tips_img = new Laya.Image()//UiFactory.CreateChild(this._gp_child,UIType.Image, "tips_img")
				this._Group1.addChild(this.tips_img)
				this.tips_img.pos(-5, -3)
				this.tips_img.width = 41
				this.tips_img.height = 29

				//SetLocalScale(this.tips_img.transform, 1.5)
				//SetAnchoredPosition(this.tips_img.transform, 0, -8)
			}
			this.tips_img.visible = true
			let end_id = vo.type_id % 10
			ResManager.GetInstance().SetImageSprite(this, this.tips_img, "holyBattle_asset", `uifh_0${end_id}`, true)

		} else {
			if (this.tips_img) {
				this.tips_img.visible = false
			}
		}

		let curr_attack_target = Scene.GetInstance().GetClickTarget()
		let auto_state = AutoFightManager.GetInstance().GetAutoFightState()
		let bool = false
		if (auto_state && curr_attack_target) {
			bool = (curr_attack_target.GetVo() == vo && vo.hp != 0)
		} else {
			bool = false
		}
		this.showAttackEffect(bool)

	}

	public UpdateHpState(vo?) {


		let canAttack = SceneManager.GetInstance().IsCanAttackByMainRole(vo,false,false,false)
		if (canAttack) {
			ResManager.GetInstance().SetImageSprite(this, this._progress_bar, this.base_file + "_asset", "uizdpz_016a")
		} else {
			ResManager.GetInstance().SetImageSprite(this, this._progress_bar, this.base_file + "_asset", "uizdpz_016")
		}
	}

	public RemoveTimer() {

		if (this.timer1) {
			GlobalTimerQuest.CancelQuest(this.timer1)
			this.timer1 = null
			this.time = 0
		}
	}

	public DeleteMe() {

		this.RemoveTimer()
		if (this.head) {
			this.head.DeleteMe()
			this.head = null
		}

		if (this.circle_mask) {
			this.circle_mask.removeSelf()
			this.circle_mask.destroy()
			this.circle_mask = null
		}

		if (this.tips_img) {
			this.tips_img.removeSelf()
			this.tips_img.destroy()
			this.tips_img = null
		}

		this.ClearUIEffect(this._attack_effect_gp)
		super.DeleteMe()
	}

	public showAttackEffect(value?) {

		if (value) {
			if (!this.effect) {
				this.effect = true
			}

			if(!this.is_attack){
				this.is_attack=true
				this.AddUIEffect("UI_2017", this._attack_effect_gp, { x: 0, y: 0 }, 12, true)
			}
			
		} else {
			if(this.is_attack){
				this.is_attack=false
				if (this.effect) {
					this.ClearUIEffect(this._attack_effect_gp)
					this.effect = false
				}
			}
		}
	}

	public showSufferedEffect(value?) {


		if (value == this.is_suffered) {
			return
		}
		this.is_suffered = value


		if (value) {
			if (!this.effect) {
				this.effect = true
			}
			this.AddUIEffect("border_redglow", this._suffer_effect_gp, null, null, true)
			//this.AddUIEffect("UI_2017", this.layer_value, this._attack_effect_gp, null, null, true, {custom_sorting_order = this.cur_sorting_order, mask_id = 1})
		} else {
			if (this.effect) {
				this.ClearUIEffect(this._suffer_effect_gp)
				this.effect = false
			}
		}

		// if (value) {
		// 	if (!this.effect) {
		// 		this.effect = new UIEffect()
		// 	}
		// 	this.effect.AddUIEffect("border_redglow", this._suffer_effect_gp, { x=0, y=6 }, null, true)
		// } else {
		// 	if (this.effect) {
		// 		this.effect.ClearUIEffect(this._suffer_effect_gp)
		// 	}
		// }
		if (this._suffer_effect_gp.visible != value) {
			this._suffer_effect_gp.visible = value
		}
	}




	_gp_child: Laya.Box
	_gp_state: Laya.Box
	_lb_state: Laya.Label
	_Group1: Laya.Box
	_Image1: Laya.Image
	_Image2: Laya.Image
	_Imag: Laya.Image
	_head_img: Laya.Image
	_head: Laya.Box
	_count_lb: Laya.Label
	_progress_gp: Laya.Box
	_Image3: Laya.Image
	_progress_bar: Laya.Image
	_lv_lb: Laya.Label
	_name_lb: Laya.Label
	_gp_attribution: Laya.Image
	seaTypeGp: Laya.Box
	seaTypeImg: Laya.Image
	seaTypeLb: Laya.Label
	_gp_fighting: Laya.Box
	_Image4: Laya.Image
	_bl_fighting: Laya.Label
	_suffer_effect_gp: Laya.Box
	_attack_effect_gp: Laya.Box
	public GetComponents() {
		[
			this._gp_child,
			this._gp_state,
			this._lb_state,
			this._Group1,
			this._Image1,
			this._Image2,
			this._Imag,
			this._head_img,
			this._head,
			this._count_lb,
			this._progress_gp,
			this._Image3,
			this._progress_bar,
			this._lv_lb,
			this._name_lb,
			this._gp_attribution,
			this.seaTypeGp,
			this.seaTypeImg,
			this.seaTypeLb,
			this._gp_fighting,
			this._Image4,
			this._bl_fighting,
			this._suffer_effect_gp,
			this._attack_effect_gp,
		]
			= this.GetChildrenByNames([

				"_gp_child",
				"_gp_state",
				"_lb_state",
				"_Group1",
				"_Image1",
				"_Image2",
				"_Imag",
				"_head_img",
				"_head",
				"_count_lb",
				"_progress_gp",
				"_Image3",
				"_progress_bar",
				"_lv_lb",
				"_name_lb",
				"_gp_attribution",
				"seaTypeGp",
				"seaTypeImg",
				"seaTypeLb",
				"_gp_fighting",
				"_Image4",
				"_bl_fighting",
				"_suffer_effect_gp",
				"_attack_effect_gp",
			])
	}
}
window["HolyBattleTargetItem"] = HolyBattleTargetItem

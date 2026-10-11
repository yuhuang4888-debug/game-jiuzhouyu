
import { CustomHeadItem } from "../common/CustomHeadItem"
import { ResManager } from "../common/ResManager"
import { BossSceneManager } from "../commonController/BossSceneManager"
import { RoleManager } from "../commonModel/RoleManager"
import { SceneBaseType } from "../scene/SceneConfig"
import { SceneManager } from "../scene/SceneManager"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { Util, GlobalTimerQuest, Trim } from "../util/Util"
import { Config } from "../common/Config"
import { EventName } from "../common/EventName"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { BaseItem1 } from "../common/BaseItem1"
import { Scene } from "../scene/Scene"
import { DressModel } from "../commonModel/DressModel"
export class BossTargetPanelItem extends BaseItem1 {
	Out_lv_lb
	boss_scene_mgr
	cur_sorting_order
	effect
	head1: CustomHeadItem
	is_attack
	is_suffered
	lastBossId
	progress_width
	time
	timer1
	circle_mask: Laya.Sprite

	data
	index
	is_need_fresh
	InitEvent

	// public WIDTH = 78
	// public HEIGT = 90
	public constructor(parent) {
		super(parent)


		this.time = 0
		this.is_attack = false
		this.is_suffered = false
		this.base_file = "boss"
		this.layout_file = "BossTargetPanelItem"
		this.boss_scene_mgr = BossSceneManager.GetInstance()
		this.is_need_fresh=false

		this.load_callback=()=>{
			
			this.InitEvent()
			if(this.is_need_fresh){
				this.is_need_fresh=false
				this.dataChanged()
			}
		}


		this.InitEvent=()=>{
			this.InitMask()
			this.DrawMaskCircle(0)
			this._gp_fighting.visible = false
			Util.AddClickEvent(this._gp_child, () => {
				this.boss_scene_mgr.Fire(BossSceneManager.SWITCH_ITEM, this.index)
			}, this, true)
	
	
			this.BindEvent(GlobalEventSystem, EventName.MAIN_ROLE_CHANGE_ATTACK_TARGRT, (monster?) => {
				let boo=false
				if(this.data&&monster){
					boo=this.data == monster && !monster.is_dead
				}
				this.ShowAttackEffect(boo)
			}
			)
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


	public dataChanged() {
		if(!this.data)return
		let data = this.data
		if (data._type && data._type == SceneBaseType.Monster || (!data._type && !data.role_id) && this.index == 1) {
			this._head.visible = false
			this._head_img.visible = true
			if (data._type) {
				if (data.vo) {
					this._name_lb.text = data.vo.name
					this._lv_lb.text = "Lv." + data.vo.level
					//SetSizeDeltaX(this._progress_mask,data.vo.hp / data.vo.maxHp * this.progress_width)
					let source = ((data.vo.hp / data.vo.maxHp) <= 0.3) && "uizdpz_016a" || "uizdpz_016"
					ResManager.GetInstance().SetImageSprite(this, this._progress_bar, this.base_file + "_asset", "uizdpz_016a")
					this.DrawMaskCircle(data.vo.hp / data.vo.maxHp)
					ResManager.GetInstance().SetOutsideImageSprite(this, this._head_img, GameResPath.GetMonsterHeadPath(data.vo.cfg_data.icon))
				}
				this._count_lb.visible = false
				this._progress_gp.visible = true

				this.RemoveTimer()
				this.ShowSufferedEffect(!this.is_attack && this.boss_scene_mgr.IsSuffered(data.id))
			} else {
				this._name_lb.text = data.boss_name

				this._progress_gp.visible = false
				this._count_lb.visible = true
				if (this.lastBossId != data.boss_id) {
					this.time = Math.max(data.reborn_time - TimeUtil.getServerTime(), 0)
				} else {
					this.time = this.time > 0 && this.time || Math.max(data.reborn_time - TimeUtil.getServerTime(), 0)
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
				this.ShowSufferedEffect(false)

				let bossVo = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_mon.name, data.boss_id, false)
				if (bossVo) {
					//等级由服务端确定
					if (data.mon_lv && data.mon_lv != 0) {
						this._lv_lb.text = "Lv." + data.mon_lv
					} else {
						this._lv_lb.text = "Lv." + bossVo.lv
					}
					ResManager.GetInstance().SetOutsideImageSprite(this, this._head_img, GameResPath.GetMonsterHeadPath(bossVo.icon))
				}
				this.lastBossId = data.boss_id
			}
			this._gp_attribution.visible = false
		} else if ((data._type && data._type == SceneBaseType.Role) && data.vo) {
			this._head.visible = true
			this._head_img.visible = false
			this._gp_attribution.visible = data.vo.boss_flag == 1

			let is_mask = data.vo.mask_id != 0 && SceneManager.GetInstance().CanMaskScene()
			this._name_lb.text = is_mask && "蒙面人" || data.vo.name
			let lv = data.vo.level > 370 && "神创" + ((data.vo.level - 370)) || "Lv." + data.vo.level
			this._lv_lb.text = is_mask && "" || lv
			this._count_lb.visible = false
			this._progress_gp.visible = true
			let source = ((data.vo.hp / data.vo.maxHp) <= 0.3) && "uizdpz_016a" || "uizdpz_016"
			//lua_resM:SetImageSprite(this,this._progress_bar,this.base_file + "_asset",source)
			//SetSizeDeltaX(this._progress_mask,data.vo.hp / data.vo.maxHp * this.progress_width)
			//this._progress_bar.fillAmount = data.vo.hp / data.vo.maxHp
			this.DrawMaskCircle(data.vo.hp / data.vo.maxHp)
			this.ShowSufferedEffect(!this.is_attack && this.boss_scene_mgr.IsSuffered(data.id))
			let picture_id = data.vo.picture
			let picture_source: string = DressModel.GetInstance().getHeadICon(picture_id, data.vo.career)
			if (Trim(String(picture_id)) != "") {
				picture_source = DressModel.GetInstance().getHeadICon(91, data.vo.career)
			}

			this.ShowBool(data)
			if (this.head1 == null) {
				this.head1 = new CustomHeadItem(this._head)
				this.head1.SetActiveFrame(false)
				this.head1.SetActiveLevel(false)
				this.head1.SetActiveBg(false)

				this.head1.CloseClick()
				this.head1.SetScale(0.75)
				this.head1.Load()
			}
			this.head1.SetActiveBg(false)
			this.head1.SetRoleVoData(is_mask && { career: data.vo.career } || data.vo)
			this.head1.SetActiveBg2(false)


		} else if (data.role_id == RoleManager.GetInstance().GetMainRoleId()) {
			this._head.visible = true
			this._head_img.visible = false
			this._gp_attribution.visible = data.boss_flag == 1

			let is_mask = data.mask_id != 0 && SceneManager.GetInstance().CanMaskScene()
			this._name_lb.text = is_mask && "蒙面人(自己)" || data.name

			let lv = data.level > 370 && "神创" + (data.level - 370) || "Lv." + data.level
			this._lv_lb.text = is_mask && "" || lv
			this._count_lb.visible = false
			this._progress_gp.visible = true
			let source = ((data.hp / data.maxHp) <= 0.3) && "uizdpz_016a" || "uizdpz_016"
			//lua_resM:SetImageSprite(this,this._progress_bar,this.base_file + "_asset",source)
			//SetSizeDeltaX(this._progress_mask,data.hp / data.maxHp * this.progress_width)
			//this._progress_bar.fillAmount = data.hp / data.maxHp
			this.DrawMaskCircle(data.hp / data.maxHp)
			let picture_id = data.picture
			let picture_source: string = DressModel.GetInstance().getHeadICon(picture_id, data.career)
			if (Trim(String(picture_id)) != "") {
				picture_source = DressModel.GetInstance().getHeadICon(91, data.career)
			}
			//lua_resM:SetOutsideImageSprite(this, this._head_img, GameResPath.GetIcon("head",picture_source))
			this.ShowBool(data)
			if (this.head1 == null) {
				this.head1 = new CustomHeadItem(this._head)
				this.head1.SetScale(0.75)
				this.head1.Load()
			}
			this.head1.SetRoleVoData(data)
			this.head1.SetActiveBg(false)
			this.head1.CloseClick()
			this.head1.ExcuteCallback(() => {
				this.head1.SetActiveBg(false)
				this.head1.SetActiveFrame(false)
				this.head1.SetActiveLevel(false)
				this.head1.SetScale(0.75)
			})
		}
		if (this.head1) {
			this.head1.SetActiveLevel(false)
			this.head1.SetPosition(-3,-4)
		}

		let boo=data == this.boss_scene_mgr.GetAttackTarget() && !this.boss_scene_mgr.GetAttackTarget().is_dead
		this.ShowAttackEffect(boo)
	}

	public ShowBool(data?) {

		let canAttack = SceneManager.GetInstance().IsCanAttackByMainRole(data.vo, false,false,false)
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
		if (this.head1) {
			this.head1.DeleteMe()
			this.head1 = null
		}

		if (this.circle_mask) {
			this.circle_mask.removeSelf()
			this.circle_mask.destroy()
			this.circle_mask = null
		}

		this.ClearUIEffect(this._attack_effect_gp)
		super.DeleteMe()
	}

	public ShowAttackEffect(value?) {
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
window["BossTargetPanelItem"] = BossTargetPanelItem
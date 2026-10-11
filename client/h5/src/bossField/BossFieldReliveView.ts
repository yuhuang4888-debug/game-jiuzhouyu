import { Alert, Alert_Type } from "../alert/Alert"
import { BaseView1 } from "../common/BaseView1"
import { CommonManager } from "../common/CommonManager"
import { CustomHeadItem } from "../common/CustomHeadItem"
import { EventName, SceneEventType } from "../common/EventName"
import { Enum_UILayer, LayerManager } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { SoundManager } from "../common/SoundManager"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { BossModel } from "../commonModel/BossModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { GuildDefine, GuildEvent, GuildModel } from "../commonModel/GuildModel"
import { ReliveModel } from "../commonModel/ReliveModel"
import { RoleManager } from "../commonModel/RoleManager"
import { SceneBaseType } from "../scene/SceneConfig"
import { SceneManager } from "../scene/SceneManager"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest, SetAnchoredPosition, SetHtmlStyle, Util } from "../util/Util"


export class BossFieldReliveView extends BaseView1 {



	scene_mgr: SceneManager
	boss_model: BossModel
	guild_model: GuildModel

	role_mgr: RoleManager
	layer_mgr: LayerManager
	erlang_parser: ErlangParser

	left_time
	toSafe_time
	is_free
	enough
	relive_cold_time
	auto_relive_state

	last_time
	help_timer
	killer_head
	left_time_id
	voice
	boss_special_relive_type
	public constructor() {
		super()

		this.base_file = "bossField"
		this.layout_file = "BossFieldReliveView"

		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.use_background = true
		this.background_alpha = 0.8
		this.is_center = true

		this.change_scene_close = false
		this.back_login_toClose = true
		this.not_close_by_android_back_key = true

		this.scene_mgr = SceneManager.GetInstance()
		this.boss_model = BossModel.GetInstance()
		this.guild_model = GuildModel.GetInstance()

		this.role_mgr = RoleManager.GetInstance()
		this.layer_mgr = LayerManager.GetInstance()
		this.erlang_parser = ErlangParser.GetInstance()

		this.left_time = 10
		this.toSafe_time = 20
		this.is_free = true
		this.enough = false
		this.relive_cold_time = null
		this.auto_relive_state = false

		this.preload_server_config = {
			"config_scene_revive_cost": false,
			"config_boss_type_key_value": false
		}

		this.load_callback = () => {
			SetHtmlStyle(this._lb_potion_num, { c: "#73b21a", f: 20, ww: false, w: 300 })
			this.LoadSuccess()
		}

		this.open_callback = () => {
			this.UpdateView()
		}

		this.close_callback = () => {
			this.is_free = true
			this.Remove()
		}
	}

	public LoadSuccess() {

		ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("boss", "com_up_bg2"), true, () => {
			//this._box_help.y=this._img_bg.y+this._img_bg.height+10
		})
		this.InitEvent()

		this.voice = CommonManager.GetInstance().PlayFightingVoice(1)
	}

	public InitEvent() {

		let relive_state = 1
		let relive_fuc = () => {

			if (1 == relive_state) {
				if ((this.scene_mgr.IsKfHolyAreaScene() || this.scene_mgr.IsConvoyScene()) || this.scene_mgr.IsSeaHegemonyScene()) {
					GlobalEventSystem.Fire(EventName.RELIVE_BY_TYPE, 23)
				} else if (this.scene_mgr.IsKfHolyAreaScene()) {
					GlobalEventSystem.Fire(EventName.RELIVE_BY_TYPE, 1)
				} else if (this.scene_mgr.IsSeaAsserScene()) {
					GlobalEventSystem.Fire(EventName.RELIVE_BY_TYPE, 1)
				} else if (this.scene_mgr.IsGuildFightScene()) {
					GlobalEventSystem.Fire(EventName.RELIVE_BY_TYPE, 14)

				} else if (this.scene_mgr.IsCrossWuxianBossScene()) {
					GlobalEventSystem.Fire(EventName.RELIVE_BY_TYPE, 22)
				} else {
					GlobalEventSystem.Fire(EventName.RELIVE_BY_TYPE, 1, false, true)
				}
			} else if (2 == relive_state) {
				GlobalEventSystem.Fire(EventName.RELIVE_BY_TYPE, 1)
				this.boss_model.need_relive_snatch = true
			} else if (3 == relive_state) {
				GlobalEventSystem.Fire(EventName.RELIVE_BY_TYPE, 3)
			}
		}

		let click_func = (target) => {
			if (target.currentTarget == this._box_free_relive) {
				if ((((this.scene_mgr.IsFeastBossScene() && this.is_free || this.scene_mgr.IsFieldScene()) || this.scene_mgr.IsMysteryBossScene()) || this.scene_mgr.IsDWScene()) || this.scene_mgr.IsEveningScene()) {
					GlobalEventSystem.Fire(EventName.RELIVE_BY_TYPE, 3)
					return
				}
				if (((((this.scene_mgr.IsHolyBossScene() || this.scene_mgr.IsFieldBossScene()|| this.scene_mgr.IsFieldInfiniteBossScene()) || this.scene_mgr.IsFieldSpecialBossScene()) || this.scene_mgr.IsHolyTerritory()) || this.scene_mgr.IsKfHolyAreaScene()) || this.scene_mgr.IsConvoyScene()) {
					if (!this._box_free_relive.mouseEnabled) {
						if (this.toSafe_time <= 0) {
							return
						}
						Message.show("复活疲劳层数过高")
					} else {
						if (this.scene_mgr.IsKfHolyAreaScene() || this.scene_mgr.IsConvoyScene()) {
							GlobalEventSystem.Fire(EventName.RELIVE_BY_TYPE, 22)
						} else {
							GlobalEventSystem.Fire(EventName.RELIVE_BY_TYPE, 3)
						}
					}
					return
				}
				if (this.scene_mgr.IsSeaHegemonyScene()) {
					GlobalEventSystem.Fire(EventName.RELIVE_BY_TYPE, 22)
					return
				}
				if (this.scene_mgr.IsSeaAsserScene()) {
					GlobalEventSystem.Fire(EventName.RELIVE_BY_TYPE, 25)
					return
				}
			}
			if (target.currentTarget == this._box_relive || target.currentTarget == this._box_free_relive) {
				relive_state = 1
			} else if (target.currentTarget == this._box_relive_and_snatch) {
				relive_state = 2
			}

			if (this.enough) {
				relive_fuc()
			} else {
				if (Util.CheckMoney(20, relive_fuc, true, false, false)) {
					relive_fuc()
				}
				else{
					Message.show("绑定勾玉不足")
				}
			}
		}

		this.BindEvent(ReliveModel.GetInstance(), ReliveModel.RELIVE_TIME_UPDATE, () => {
			this.UpdateView()
		}
		)
		this.BindEvent(this.boss_model, BossModel.DOMAINBOSS_RELIVE_TIME, () => {
			this.UpdateView()
		}
		)
		this.BindEvent(GlobalEventSystem, SceneEventType.MONSTER_VO_ADD, (instance_id?, monster_vo?) => {
			if (instance_id == this.scene_mgr.killerId) {
				this.UpdateHead()
			}
		}
		)

		Util.AddClickEvent(this._box_relive, click_func, this, true)
		Util.AddClickEvent(this._box_free_relive, click_func, this, true)
		Util.AddClickEvent(this._box_relive_and_snatch, click_func, this, true)



		//AddClickEvent(this._btn_help,() => {
		//let etime = this.guild_model.boss_etime
		//if (etime > TimeUtil.getServerTime() ) {
		//Message.show("请勿频繁操作")
		//}else{
		//this.guild_model.boss_etime = TimeUtil.getServerTime() + GuildDefine.BOSS_HELP_CD
		//this.guild_model.Fire(GuildEvent.REQUEST_PROTO, 40060)
		//this:StartHelpTimer()
		//Message.show("已向结社成员发起求助")
		//}
		//}
		//, this, true)

		Util.AddClickEvent(this._btn_help, () => {
			let etime = this.guild_model.boss_etime
			if (etime > TimeUtil.getServerTime()) {
				Message.show("请勿频繁操作")
			} else {
				this.guild_model.boss_etime = TimeUtil.getServerTime() + GuildDefine.BOSS_HELP_CD
				this.guild_model.Fire(GuildEvent.REQUEST_PROTO, 40060)
				this.StartHelpTimer()
				Message.show("已向结社成员发起求助")
			}
		}
			, this, true)

		let check_handler = () => {
			let select = !this.auto_relive_state
			let auto_relive = this.boss_model.auto_relive
			if (auto_relive == select) {
				return
			}
			if (this.role_mgr.GetMainRoleVo().jinLock < 20 && !this.enough) {
				this.auto_relive_state = false
				this.UpdateAutoReliveState()
				Message.show("绑玉不足")
				return
			}
			this.boss_model.auto_relive = select
			this.auto_relive_state = select
			this.UpdateAutoReliveState()
			if (select) {
				this.last_time = this.left_time
				if (this.left_time < 5) {
					this.left_time = 0
				} else {
					this.left_time = 5
				}
			} else {
				this.left_time = this.last_time - (5 - this.left_time)
			}
			this._lb_count_down.text = String(this.left_time)
		}

		Util.AddClickEvent(this._img_auto_relive, check_handler, this, true)

	}

	public UpdateAutoReliveState() {
		ResManager.GetInstance().SetImageSprite(this, this._img_auto_relive, "common", this.auto_relive_state ? "com_ui_gx1" : "com_ui_gx")
	}

	public initCheck() {

		if (this._box_check.visible) {
			if (this.role_mgr.GetMainRoleVo().jinLock < 20 && !this.enough) {
				this.auto_relive_state = false
				this.UpdateAutoReliveState()
				this.boss_model.auto_relive = false
			} else {
				this.auto_relive_state = this.boss_model.auto_relive
				this.UpdateAutoReliveState()
				if (this.boss_model.auto_relive) {
					this.last_time = this.left_time
					this.left_time = 5
				}
			}
		}
	}

	public UpdateHead() {

		// let effect_width = 262
		// let effect_height = 384
		// let width = LayerManager.GetInstance().stageWidth ScreenWidth
		// let height = ScreenHeight
		// let scale_x = width / effect_width
		// let scale_y = height / effect_height

		if (this.scene_mgr.IsEquipDungeon()) return

		if (this.scene_mgr.killerType == SceneBaseType.Role) {
			this.killer_head = new CustomHeadItem(this._box_role_head)
			this.killer_head.Load()
			this.killer_head.ExcuteCallback(() => {
				// this.killer_head.transform.pivot = Vector2(0.5, 0.5)
				// this.killer_head.transform.anchorMax = Vector2(0.5, 0.5)
				// this.killer_head.transform.anchorMin = Vector2(0.5, 0.5)
				// this.killer_head.SetPosition(-99.5, 175)
			})
			let info_ = this.scene_mgr.killerId && this.scene_mgr.GetRoleVo(this.scene_mgr.killerId)
			this.boss_model.killer_vo = info_ && info_ || this.boss_model.killer_vo
			//if (! this.boss_model.killer_vo || Util.TableSize(this.boss_model.killer_vo) <= 0 ) {
			//this.boss_model.killer_vo = this.scene_mgr.GetRoleVo(this.scene_mgr.killerId)
			//}
			let role_vo = this.boss_model.killer_vo
			//Message.show(this.scene_mgr.killerId)
			//if (! role_vo ) {
			//Message.show("无rolevo")
			//}
			let role_fight = 0
			if (role_vo) {
				let is_mask = (this.scene_mgr.KillerMaskId != 0 || role_vo.mask_id != 0) && this.scene_mgr.CanMaskScene()
				// this._lb_fighting.text = is_mask && "" || role_vo.fighting
				if (is_mask) {
					this.killer_head.SetRoleVoData({
						career: role_vo.career
					})
				} else {
					//let frame_id = Role.GetDressByType(role_vo, DressType.Photo)
					this.killer_head.SetRoleVoData(role_vo)//, null, null, frame_id
				}
			} else {
				//this.killer_head.SetRoleVoData(null, 1, null, true, GameResPath.GetIcon("monsterHead","0"))
				// this._lb_fighting.text = "0"
			}
			// this._box_killer_msg.visible = true
			// this.killer_head.SetPosition(-99.5, 175)
			if (((((this.scene_mgr.IsHolyBossScene() || this.scene_mgr.IsFieldBossScene()||this.scene_mgr.IsFieldInfiniteBossScene()) || this.scene_mgr.IsFieldSpecialBossScene()) || this.scene_mgr.IsAbyssBossScene()) || this.scene_mgr.IsSeaHegemonyScene()) || this.scene_mgr.IsSeaAsserScene()) {
				// ResManager.GetInstance().SetImageSprite(this, this._img_tips, "bossfield", "uiboss_038c", true)
			} else {
				// ResManager.GetInstance().SetImageSprite(this, this._img_tips, "bossfield", "uiboss_038b", true)
				this.boss_model.is_owner_snatch = false
			}
		} else if (this.scene_mgr.killerType == SceneBaseType.Monster) {

			// this._box_killer_msg.visible = false
			let monster_vo = this.scene_mgr.GetMonsterVo(this.scene_mgr.killerId)
			// this.killer_head = new PlayerHeah(this.form)
			// this.killer_head.Load()
			// this.killer_head.ExcuteCallback(() => {
			// 	if (this.killer_head && this.killer_head.transform) {
			// 		this.killer_head.transform.pivot = Vector2(0.5, 0.5)
			// 		this.killer_head.transform.anchorMax = Vector2(0.5, 0.5)
			// 		this.killer_head.transform.anchorMin = Vector2(0.5, 0.5)
			// 	}
			// 	this.killer_head.SetPosition(-99.5, 175)
			// })

			// this.killer_head.SetPosition(0, 175)
			// if (monster_vo) {
			// 	this.killer_head.setData(monster_vo.level, 1, null, true, GameResPath.GetIcon("monsterHead", monster_vo.cfg_data.icon))
			// } else {
			// 	this.killer_head.setData(null, 1, null, true, GameResPath.GetIcon("monsterHead", "0"))
			// }
			if (monster_vo && monster_vo.cfg_data)
				ResManager.GetInstance().SetOutsideImageSprite(this, this._img_mon_head, GameResPath.GetMonsterHeadPath(monster_vo.cfg_data.icon))

			// this.AddUIEffect2("ui_frame_white", this._gp_effect, null, {x=scale_x, y=scale_y}, true)
			// ResManager.GetInstance().SetImageSprite(this, this._img_tips, "bossfield_asset", "uiboss_038c", true)
		}
	}

	public UpdateView() {

		if (this.scene_mgr.IsEquipDungeon()) {
			this._lb_killer_name.text = `很遗憾！您已被击杀！`
		} else {
			this._lb_killer_name.text = `很遗憾！你被${this.scene_mgr.killerName}击杀！`//"很遗憾！你被" + this.scene_mgr.killerName + "击杀！"
		}

		// this._lb_killer_msg.text = this.scene_mgr.killerName
		this._lb_desc.text = "自动复活倒计时"
		this.UpdateHead()


		let boss_special_relive_type
		if(this.scene_mgr.IsFieldBossScene() || this.scene_mgr.IsFieldSpecialBossScene()||this.scene_mgr.IsFieldInfiniteBossScene()){
			boss_special_relive_type = ReliveModel.BossSpecialReliveType.WorldBoss
		}else if(this.scene_mgr.IsHolyTerritory()){
			boss_special_relive_type = ReliveModel.BossSpecialReliveType.HolyTerr
		}else if(this.scene_mgr.IsKfHolyAreaScene()){
			boss_special_relive_type = ReliveModel.BossSpecialReliveType.KfHolyArea
		}else if(this.scene_mgr.IsHolyBossScene()){
			boss_special_relive_type = ReliveModel.BossSpecialReliveType.HolyBoss
		}
		this.boss_special_relive_type = boss_special_relive_type
		if (boss_special_relive_type) {
			let relive_data = ReliveModel.GetInstance().GetReliveTimeData(boss_special_relive_type)
			if(!relive_data){
				return
			}
			
			if (relive_data.relive_time <= 0) {
				return
			}

			if (!ReliveModel.GetInstance().relive_time_has_return) {
				return
			}

			let die_times = relive_data.die_times
			let cfgs = ResManager.GetInstance().GetGameConfigFromCache(this, "config_boss_type_key_value", false)
			let value = this.boss_model.GetBossKeyValue(12, "die_wait_time", cfgs)
			let list = JSON.parse(value)
			let min_times = Number(list[0][1])
			let cur_time = TimeUtil.getServerTime()

			this.left_time = relive_data.relive_time - cur_time
			this.toSafe_time = relive_data.safe_time - TimeUtil.getServerTime()
			this._box_free_relive.gray = die_times > min_times && relive_data.time > cur_time
			this._box_free_relive.mouseEnabled = !(die_times > min_times && relive_data.time > cur_time)
			this._lb_to_safe.visible = this.toSafe_time > 0

		}else if (this.scene_mgr.IsBossDoMainScene()) {
			if (!this.boss_model.doMian_boss_relive_time || this.boss_model.doMian_boss_relive_time < TimeUtil.getServerTime()) {
				return
			}
			this.left_time = this.boss_model.doMian_boss_relive_time - TimeUtil.getServerTime()
			this._lb_desc.text = "自动复活倒计时"
		}else if (this.scene_mgr.IsSeaHegemonyScene()) {
			this.relive_cold_time = 6
			this.left_time = 20
			this._box_free_relive.gray = true
			this._lb_desc.text = "自动复活倒计时"
		}else if (this.scene_mgr.IsSeaAsserScene()) {
			this.relive_cold_time = 6
			this.left_time = 20
			this._box_free_relive.gray = true
			this._lb_desc.text = "自动复活倒计时"
		}else if (this.scene_mgr.IsEquipDungeon()) {
			this.relive_cold_time = 0
			this.left_time = 5
			this._box_free_relive.gray = true
			this._lb_desc.text = "自动复活倒计时"

			if (this.killer_head) {
				this.killer_head.visible = false
			}
		}else if (this.scene_mgr.IsGuildFightScene()) {
			this.relive_cold_time = 0
			this.left_time = 17
			this._box_free_relive.gray = true
			this._lb_desc.text = "自动复活倒计时"
		}


		this.SetReliveBtn()
		this.UpdateHelpData()
		this.UpdateCanUsePotion()
		this.initCheck()

		if (!this.left_time_id) {
			let on_timer = () => {
				if (this._lb_to_safe.visible) {
					this._lb_to_safe.text = this.toSafe_time + "秒后将传送回安全区"
					if (this.toSafe_time <= 0) {
						this._lb_to_safe.visible = false
						if (this.scene_mgr.IsKfHolyAreaScene()) {
							GlobalEventSystem.Fire(EventName.RELIVE_BY_TYPE, 21)
						} else {
							GlobalEventSystem.Fire(EventName.RELIVE_BY_TYPE, 20)
						}
					}
					this.toSafe_time = this.toSafe_time - 1
				}

				if (this.left_time <= 0) {
					if (this.left_time_id) {
						GlobalTimerQuest.CancelQuest(this.left_time_id)
						this.left_time_id = null
					}
					if (this.auto_relive_state) {
						GlobalEventSystem.Fire(EventName.RELIVE_BY_TYPE, 1, false, true)
					} else {
						if ((this.scene_mgr.IsKfHolyAreaScene() || this.scene_mgr.IsSeaHegemonyScene()) || this.scene_mgr.IsSeaAsserScene() || this.scene_mgr.IsCrossWuxianBossScene()) {
							GlobalEventSystem.Fire(EventName.RELIVE_BY_TYPE, 22, true)
						} else if (this.scene_mgr.IsBossDoMainScene()) {

						} else if (this.scene_mgr.IsMysteryBossScene()) {
							GlobalEventSystem.Fire(EventName.RELIVE_BY_TYPE, 15, true)
						} else {
							GlobalEventSystem.Fire(EventName.RELIVE_BY_TYPE, 3, true)
						}
					}
					this.boss_model.killer_vo = []
				}

				if (this.relive_cold_time && this.relive_cold_time > 0) {
					this._box_free_relive.mouseEnabled = false
					this.relive_cold_time = this.relive_cold_time - 1
					this._lb_free_relive.text = "回出生点(" + this.relive_cold_time + ")"
					if (this.relive_cold_time == 0) {
						this._lb_free_relive.text = "回出生点"
						this._box_free_relive.gray = false
						this._box_free_relive.mouseEnabled = true
					}
				}
				this.left_time = this.left_time < 0 && 0 || this.left_time
				this._lb_count_down.text = String(this.left_time)
				this.left_time = this.left_time - 1
			}
			this.left_time_id = GlobalTimerQuest.AddPeriodQuest(on_timer, 1, -1)
			on_timer()
		}
	}

	public Remove() {

		if (this.voice) {
			SoundManager.GetInstance().StopSoundEffect(this.voice)
			this.voice = null
		}
		this.scene_mgr.SetKillerInfo(0)
		if (this.left_time_id) {
			GlobalTimerQuest.CancelQuest(this.left_time_id)
			this.left_time_id = null
		}
		if (this.killer_head) {
			this.killer_head.DeleteMe()
			this.killer_head = null
		}
		this.left_time = 10
		this.CancelHelpTimer()
		if(this.boss_special_relive_type){
			let data = ReliveModel.GetInstance().GetReliveTimeData(this.boss_special_relive_type)
			if(data){
				data.relive_time = 0
			}
		}
		ReliveModel.GetInstance().relive_time_has_return = false
	}

	public SetReliveBtn() {
		if (this.scene_mgr.IsFeastBossScene()) {
			let cfgs = ResManager.GetInstance().GetGameConfigFromCache(this, "config_boss_type_key_value", false)
			let value = this.boss_model.GetBossKeyValue(11, "feast_boss_revive_cost", cfgs)
			let list = JSON.parse(value)
			this._box_relive_and_snatch.visible = false
			this._box_relive.centerX = 0
			if (list && list.length > 0) {
				this.is_free = false
				this._box_free_relive.visible = false
				this._box_relive.visible = true
			} else {
				this._box_free_relive.visible = true
				this._box_relive.visible = false
			}
		} else if (this.scene_mgr.IsAbyssBossScene()) {
			this._box_free_relive.visible = false
			this._box_relive_and_snatch.visible = true
			this._box_relive.visible = this._box_relive_and_snatch.visible
			this._box_relive.centerX = 100
			this._box_relive_and_snatch.centerX = -100
			this._box_check.visible = true
		} else if (this.scene_mgr.IsMysteryBossScene()) {
			this._box_relive_and_snatch.visible = false
			this._box_check.visible = false
			this._box_relive.visible = false
		} else if (this.scene_mgr.IsFieldInfiniteBossScene()||this.scene_mgr.IsHolyBossScene() || this.scene_mgr.IsFieldBossScene() || this.scene_mgr.IsFieldSpecialBossScene() || this.scene_mgr.IsHolyTerritory() || this.scene_mgr.IsKfHolyAreaScene() || this.scene_mgr.IsSeaHegemonyScene() || this.scene_mgr.IsSeaAsserScene() || this.scene_mgr.IsCrossWuxianBossScene()) {
			this._box_free_relive.visible = true
			this._box_relive.visible = true
			this._box_relive_and_snatch.visible = false
			this._box_free_relive.centerX = -100
			this._box_relive.centerX = 100

			// SetAnchoredPosition(this._box_free_relive, -130, this._box_free_relive.anchoredPosition.y)
			// SetAnchoredPosition(this._box_relive, 130, this._box_relive.anchoredPosition.y)
			this._lb_free_relive.text = "回出生点"
			this._lb_relive.text = "原地复活"
			let cfgs = ResManager.GetInstance().GetGameConfigFromCache(this, "config_boss_type_key_value", false)
			let value = this.boss_model.GetBossKeyValue(BossModel.BossType.field, "new_outside_resurgence_cost", cfgs)
			let list = JSON.parse(value)[0]
			this._lb_relive_cost.text = list[1] + ""
			this._box_check.visible = true
		} else if ((this.scene_mgr.IsFieldScene() || this.scene_mgr.IsEveningScene()) || this.scene_mgr.IsDWScene()) {
			if (this.killer_head) {
				this.killer_head.visible = false
			}
			// this._lb_killer_name.y = this._lb_killer_name.y - 60
			// SetAnchoredPositionY(this._lb_killer_name, -525 + 60)
			this._box_relive_and_snatch.visible = false
			this._lb_to_safe.visible = false
			if (this.role_mgr.mainRoleInfo.level > 20) {
				this._lb_free_relive.text = "回出生点"
				this._lb_relive.text = "立即复活"
				this._lb_relive_cost.text = "20"
				this._box_free_relive.visible = true
				this._box_relive.visible = true
				this._box_relive.centerX = 100
				this._box_free_relive.centerX = -100
				// SetAnchoredPosition(this._box_relive, 100, this._box_relive.anchoredPosition.y)
				// SetAnchoredPosition(this._box_free_relive, -100, this._box_free_relive.anchoredPosition.y)
			} else {
				this._lb_free_relive.text = "原地复活"
				this._box_free_relive.visible = true
				this._box_relive.visible = false
			}
		} else if (this.scene_mgr.IsBossDoMainScene()) {
			this._box_free_relive.visible = false
			this._box_relive.visible = false
			this._box_check.visible = false
			this._box_relive_and_snatch.visible = true
			this._box_relive_and_snatch.centerX = 0
			// SetAnchoredPosition(this._box_relive_and_snatch, 0, this._box_relive_and_snatch.anchoredPosition.y)
		} else if (this.scene_mgr.IsConvoyScene()) {
			this._box_free_relive.visible = true
			this._box_relive.visible = true
			this._box_relive_and_snatch.visible = false
			this._box_relive.centerX = 100
			this._box_relive_and_snatch.centerX = -100
			// SetAnchoredPosition(this._box_free_relive, -130, this._box_free_relive.anchoredPosition.y)
			// SetAnchoredPosition(this._box_relive, 130, this._box_relive.anchoredPosition.y)
			this._lb_relive.text = "原地复活"
			this._lb_free_relive.text = "回出生点"
			this._box_check.visible = true
		} else if (this.scene_mgr.IsEquipDungeon()) {
			this._box_check.visible = false
			if (this.killer_head) {
				this.killer_head.visible = false
			}
			this._box_role_monster.visible = false
			this._lb_killer_name.y = 507
			this._lb_count_down.y = 538
			this._lb_desc.y = 639
			this._img_bg.height = 355
		}
		else if (this.scene_mgr.IsGuildFightScene()) {
			this._box_check.visible = false
		}
	}

	public UpdateHelpData() {
		if ((((this.scene_mgr.IsKfHolyAreaScene() || this.scene_mgr.IsBossDoMainScene()) || this.scene_mgr.IsConvoyScene()) || this.scene_mgr.IsSeaHegemonyScene()) || this.scene_mgr.IsSeaAsserScene() || this.scene_mgr.IsMysteryBossScene()) {
			this._box_help.visible = false
			return
		}
		let has_guild = this.role_mgr.GetMainRoleVo().guild_id != 0
		let show = this.scene_mgr.killerType == SceneBaseType.Role && has_guild
		if (show) {
			this.StartHelpTimer()
			this._box_help.visible = true
		} else {
			this.CancelHelpTimer()
			this._box_help.visible = false
		}
		this._box_help.y = this._img_bg.y + this._img_bg.height + 10
	}

	public StartHelpTimer() {

		let etime = this.guild_model.boss_etime
		if (etime > TimeUtil.getServerTime()) {
			this.CancelHelpTimer()
			this.help_timer = GlobalTimerQuest.AddPeriodQuest(() => {
				if (this.use_delete_method) {
					this.CancelHelpTimer()
					return
				}
				let etime = this.guild_model.boss_etime
				let rtime = etime - TimeUtil.getServerTime()
				if (rtime > 0) {
					this._lb_help_time.text = rtime + "s"
				} else {
					this.CancelHelpTimer()
					this._lb_help_time.text = ""
				}
			}, 1, -1)
		}
	}

	public CancelHelpTimer() {

		if (this.help_timer) {
			GlobalTimerQuest.CancelQuest(this.help_timer)
			this.help_timer = null
		}
	}

	public UpdateCanUsePotion() {
		let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_scene_revive_cost", false)
		let scene_type = this.scene_mgr.GetSceneType()
		let can_use_potion = false
		let goods_id = null
		let need = null
		for (let key in cfg) {
			if (cfg[key].scene_type == scene_type) {
				can_use_potion = true
				let cost = JSON.parse(cfg[key].cost)
				goods_id = cost[0][1]
				need = Number(cost[0][1])
			}
		}
		this._box_use_potion.visible = can_use_potion
		if (!can_use_potion || !goods_id) {
			return
		}
		let num = GoodsModel.GetInstance().GetBagGoodsNum(goods_id)
		this.enough = num >= need && true || false
		let str = ":<font color='#00fa64'>" + num + "(优先消耗长生石)</font> "
		this._lb_potion_num.innerHTML = str
		let goods_basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(goods_id)
		if (goods_basic) {
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_goods_icon, GameResPath.GetGoodsIconPath(goods_basic.goods_icon))
		}

		Util.AddClickEvent(this._img_goods_icon, () => {
			UIToolTipMgr.GetInstance().AppendGoodsTips(goods_id)
		}, this, true)

		if (num > 0) {
			this._box_diamond_now.visible = false
			this._box_diamond_stand.visible = false
		} else {
			this._box_diamond_now.visible = true
			this._box_diamond_stand.visible = true
		}
	}

	_img_bg: Laya.Image
	_img_bg2: Laya.Image
	_box_effect: Laya.Box
	_lb_desc: Laya.Label
	_lb_count_down: Laya.Label
	_box_relive: Laya.Box
	_img_bg5: Laya.Image
	_lb_relive: Laya.Label
	_box_diamond_now: Laya.Box
	_img_icon: Laya.Image
	_lb_relive_cost: Laya.Label
	_box_relive_and_snatch: Laya.Box
	_img_bg4: Laya.Image
	_lb_relive_stand: Laya.Label
	_box_diamond_stand: Laya.Box
	_Image4: Laya.Image
	_lb_relive_cost0: Laya.Label
	_box_free_relive: Laya.Box
	_img_bg3: Laya.Image
	_lb_free_relive: Laya.Label
	_lb_killer_name: Laya.Label
	_box_killer_msg: Laya.Box
	_lb_fighting: Laya.Label
	_lb_killer_msg: Laya.Label
	_box_role_monster: Laya.Box
	_img_kuang: Laya.Image
	_img_circle: Laya.Image
	_img_mon_head: Laya.Image
	_box_role_head: Laya.Box
	_img_tips: Laya.Image
	_lb_to_safe: Laya.Label
	_box_help: Laya.Box
	_btn_help: Laya.Image
	_lb_help_time: Laya.Label
	_box_check: Laya.Box
	_img_auto_relive: Laya.Image
	_lb_auto_relive_time: Laya.Label
	_box_use_potion: Laya.Box
	_lb_desc2: Laya.Label
	_img_goods_icon: Laya.Image
	_lb_potion_num: Laya.HTMLDivElement
	public GetComponents() {
		[
			this._img_bg,
			this._img_bg2,
			this._box_effect,
			this._lb_desc,
			this._lb_count_down,
			this._box_relive,
			this._img_bg5,
			this._lb_relive,
			this._box_diamond_now,
			this._img_icon,
			this._lb_relive_cost,
			this._box_relive_and_snatch,
			this._img_bg4,
			this._lb_relive_stand,
			this._box_diamond_stand,
			this._Image4,
			this._lb_relive_cost0,
			this._box_free_relive,
			this._img_bg3,
			this._lb_free_relive,
			this._lb_killer_name,
			this._box_killer_msg,
			this._lb_fighting,
			this._lb_killer_msg,
			this._box_role_monster,
			this._img_kuang,
			this._img_circle,
			this._img_mon_head,
			this._box_role_head,
			this._img_tips,
			this._lb_to_safe,
			this._box_help,
			this._btn_help,
			this._lb_help_time,
			this._box_check,
			this._img_auto_relive,
			this._lb_auto_relive_time,
			this._box_use_potion,
			this._lb_desc2,
			this._img_goods_icon,
			this._lb_potion_num,
		]
			= this.GetChildrenByNames([
				"_img_bg",
				"_img_bg2",
				"_box_effect",
				"_lb_desc",
				"_lb_count_down",
				"_box_relive",
				"_img_bg5",
				"_lb_relive",
				"_box_diamond_now",
				"_img_icon",
				"_lb_relive_cost",
				"_box_relive_and_snatch",
				"_img_bg4",
				"_lb_relive_stand",
				"_box_diamond_stand",
				"_Image4",
				"_lb_relive_cost0",
				"_box_free_relive",
				"_img_bg3",
				"_lb_free_relive",
				"_lb_killer_name",
				"_box_killer_msg",
				"_lb_fighting",
				"_lb_killer_msg",
				"_box_role_monster",
				"_img_kuang",
				"_img_circle",
				"_img_mon_head",
				"_box_role_head",
				"_img_tips",
				"_lb_to_safe",
				"_box_help",
				"_btn_help",
				"_lb_help_time",
				"_box_check",
				"_img_auto_relive",
				"_lb_auto_relive_time",
				"_box_use_potion",
				"_lb_desc2",
				"_img_goods_icon",
				"_lb_potion_num",
			])
	}
}
window["BossFieldReliveView"] = BossFieldReliveView
import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { Config } from "../common/Config"
import { ResManager } from "../common/ResManager"
import { BossSceneManager } from "../commonController/BossSceneManager"
import { BossModel } from "../commonModel/BossModel"
import { PlatformManager } from "../PlatformManager"
import { RoleManager } from "../commonModel/RoleManager"
import { SceneManager } from "../scene/SceneManager"
import { ColorType, ColorUtil, Enum_ColorUtil_NEW } from "../util/ColorUtil"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest } from "../util/Util"

export class BossWayFindingSubItem extends BaseItemRenderer {
	public WIDTH = 218 //86 + 13
	public HEIGT = 35

	boss_model:BossModel
	boss_scene_mgr:BossSceneManager
	res_mgr:ResManager
	img_select
	role_mgr
	scene_mgr
	timer_id

	public constructor(parent) {
		super()

		this.base_file = "boss"
		this.layout_file = "BossWayFindingSubItem"
		this.boss_model = BossModel.GetInstance()
		this.boss_scene_mgr = BossSceneManager.GetInstance()
		this.role_mgr = RoleManager.GetInstance()
		this.res_mgr = ResManager.GetInstance()
		//this.scene_mgr = SceneManager.GetInstance()
		this.load_callback = () => {
			this.LoadSuccess()
		}
		this.Load()
	}

	public LoadSuccess() {

		this.BindEvent(
			this.boss_model,
			BossModel.UPDATE_BOSS_HP, () => {
				this.UpdateBossHp()
			}
		)
	}

	public DeleteMe() {

		this.StopTimer()
		this.ShowBoxEffect(false)
		super.DeleteMe()
	}

	public dataChanged() {
		if (super.dataChanged()) {
			if (!this.data) {
				return
			}
			this._img_select.visible = this.selected
			this.StopTimer()
			let str = this.data.boss_name
			let boss_info = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_mon.name, this.data.boss_id, false)
			let source = null
			if (boss_info) {
				if (SceneManager.GetInstance().IsHolyTerritory()) {
					source = "uiboss_060b"
				} else {
					if(PlatformManager.IsEyouPlatform()){
						str = `${str}\nLv${boss_info.lv}`
					}else{
					str = `${str}Lv${boss_info.lv}`
					}
					source = "uiboss_060c"
				}
			}


			this._lb_name.text = str
			this.res_mgr.SetImageSprite(this, this._img_peace, "boss", source)
			if (this.data.reborn_time != null) {
				this._lb_time.visible = true
				this.TimerStart(this.data.reborn_time)
			} else {
				this._lb_time.visible = false
			}
			let cfgs = this.res_mgr.GetGameConfigFromCache(this.base_item, "config_boss_cfg", false)
			let config = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_boss_cfg.name, this.data.boss_id, false, cfgs)
			if (!config) {
				let cfgs = this.res_mgr.GetGameConfigFromCache(this.base_item, "config_eudemons_boss_cfg", false)
				config = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_eudemons_boss_cfg.name, this.data.boss_id, false, cfgs)
			}
			if (config) {
				this._img_peace.visible = config.sign == 1

				let bool = true
				let main_role_vo = this.role_mgr.GetMainRoleVo()

				let level = (config.type == BossModel.BossType.field ||config.type == BossModel.BossType.field_infinite)
				&& BossModel.FIELD_HIGT_LEVEL_TIPS_VALUE 
				|| BossModel.HIGT_LEVEL_TIPS_VALUE

				if (this.data.lv - main_role_vo.level >= level) {
					bool = false
				}
				

				if (bool) {
					this._lb_name.color = "#ffffff"
				} else {
					this._lb_name.color = "#fbe098"
				}
			} else {
				this._img_peace.visible = false
			}
		}
	}

	public ShowBoxEffect(show?) {

		// if (show ) {
		// 	Laya.Tween.get(this._img_box, {loop = true}):to({rotation = 15}, 150, Laya.Ease.circIn).to(
		// 		{rotation = 0},
		// 		150,
		// 		Laya.Ease.circIn
		// 	):to({rotation = -15}, 150, Laya.Ease.circIn):to({rotation = 0}, 150, Laya.Ease.circIn):wait(100)
		// }else{
		// 	if (this._img_box ) {
		// 		Laya.Tween.removeTweens(this._img_box)
		// 	}
		// }
	}

	public TimerStart(refresh_time?) {

		if (refresh_time <= 0) {
			this.UpdateBossHp()
			return
		}

		if (!this.data) {
			return
		}
		let left_time = this.data.reborn_time - TimeUtil.getServerTime() + 1
		let loop_func = () => {
			if (!this.data || this.use_delete_method) {
				return
			}
			left_time = left_time - 1
			if (left_time <= 0) {
				this.UpdateBossHp()
				this.StopTimer()
				return
			}
			let time = TimeUtil.convertTime(left_time)
			this._lb_time.text = time
			this._lb_time.color = ColorUtil.TryParseHtmlString("#ff4f50")
		}
		this.timer_id = GlobalTimerQuest.AddPeriodQuest(loop_func, 1, -1)
		loop_func()
	}

	public StopTimer() {

		if (this.timer_id) {
			GlobalTimerQuest.CancelQuest(this.timer_id)
			this.timer_id = null
		}
	}

	public UpdateBossHp() {

		if (!this.data) {
			return
		}
		if (!this.data.reborn_time || TimeUtil.getServerTime() >= this.data.reborn_time) {
			this._lb_time.color = Enum_ColorUtil_NEW.LIGHT_GREEN

			let data = BossModel.GetInstance().GetBossHpData(this.data.boss_id)
			if (data) {
				this._lb_time.text = Math.floor(data.hp / data.hp_max * 100) + "%"
			} else {
				if (BossModel.GetInstance().HasBossHpCfg(this.data.boss_id)) {
					this._lb_time.text = "100%"
				} else {
					this._lb_time.text = "已复活"
				}
			}
		}
	}

	_lb_name: Laya.Label
	_lb_time: Laya.Label
	_img_peace: Laya.Image
	_img_box: Laya.Image
	_img_line: Laya.Image
	_img_select: Laya.Image
	public GetComponents() {
		[
			this._lb_name,
			this._lb_time,
			this._img_peace,
			this._img_box,
			this._img_line,
			this._img_select,
		]
			= this.GetChildrenByNames([

				"_lb_name",
				"_lb_time",
				"_img_peace",
				"_img_box",
				"_img_line",
				"_img_select",
			])
	}
}
window["BossWayFindingSubItem"] = BossWayFindingSubItem
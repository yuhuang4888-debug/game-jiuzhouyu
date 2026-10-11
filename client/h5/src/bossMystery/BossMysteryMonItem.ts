import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { Util } from "../util/Util"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest } from "../util/Util"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { PlatformManager } from "../PlatformManager"
import { RoleManager } from "../commonModel/RoleManager"
import { BossModel } from "../commonModel/BossModel"

export class BossMysteryMonItem extends BaseItemRenderer {
	WIDTH = 140
	HEIGT = 276

	data
	effect
	model
	cfg_boss
	timer_id

	public constructor() {
		super()
		this.base_file = "bossMystery"
		this.layout_file = "BossMysteryMonItem"

		this.model = BossModel.GetInstance()

		this.load_callback = () => {
			this.cfg_boss = ResManager.GetInstance().GetGameConfigFromCache(this.base_item, "config_boss_cfg", false)
			this.InitEvents()
			if (PlatformManager.IsEyouEnPlatform()) {
				this._lb_bossName.fontSize = 15
			}
		}
		this.Load()
	}

	public InitEvents() {
		this.BindEvent(BossModel.GetInstance(), BossModel.KILL_BOSS, (scmd?) => {
			if (this.data && scmd.boss_type == BossModel.BossType.mystery && this.data.boss_id == scmd.boss_id) {
				this.dataChanged()
			}
		})

		let update_select_fun = (info?) => {
			if (this.data && this.model.IsBoxByBossId(this.data.boss_id) && info && this.model.IsBoxByBossId(info.boss_id) && this.data.layer == info.layer) {
				this.data = info
				this.dataChanged()
			}
		}
		this.BindEvent(BossModel.GetInstance(), BossModel.UPDATE_SELECT_BOSS_INFO, update_select_fun)

		let update_pos_fun = () => {
			if (this.data && (this.model.IsBoxByBossId(this.data.boss_id) || this.data.mon_type == BossModel.MYSTERY_SPECIAL_BOSS_TYPE)) {
				this.dataChanged()
			}
		}
		this.BindEvent(BossModel.GetInstance(), BossModel.UPDATE_MON_POS, update_pos_fun)
	}

	public OnTime() {
		let left_time = this.data.reborn_time - TimeUtil.getServerTime()
		if (left_time < 0) {
			this.data.reborn_time = 0
			this.dataChanged()
			this.StopTimer()
			this.refresh_time.text = "00:00"
			if (this.data.mon_type == BossModel.MYSTERY_BOX_TYPE || this.data.mon_type == BossModel.MYSTERY_SUPER_BOX_TYPE) {
				this.model.Fire(BossModel.SCMD_REQUEST, 46000, this.data.boss_type)
				this.model.Fire(BossModel.SCMD_REQUEST, 46039)
			}
			return
		}
		let time = TimeUtil.convertTime(left_time)
		this.refresh_time.text = time
	}

	public DeleteMe() {
		if (this.effect) {
			this.effect.DeleteMe()
			this.effect.ClearUIEffect(this.reborn_effect)
			this.effect = null
		}
		this.StopTimer()
		super.DeleteMe()
	}

	public dataChanged() {
		if (!super.dataChanged()) {
			return
		}

		if (this.data) {

			if (this.selected) {
				this._img_select.visible = true
			} else {
				this._img_select.visible = false
			}
			this.StopTimer()
			if(this.data.mon_type == BossModel.MYSTERY_BOX_TYPE){
				ResManager.GetInstance().SetOutsideImageSprite(this, this.mon_icon, GameResPath.GetMonsterHeadPath("15010025"))
			}else{
				ResManager.GetInstance().SetOutsideImageSprite(this, this.mon_icon, GameResPath.GetMonsterHeadPath(this.data.icon))
			}
			
			let level = RoleManager.GetInstance().GetMainRoleVo().level
			let open_lv = this.data.open_lv
			let max_lv = this.data.max_lv
			let open_state = level >= open_lv && level <= max_lv
			let alive_state = this.data.reborn_time == 0 || TimeUtil.getServerTime() > this.data.reborn_time
			this._lb_unopen_tips.visible = !open_state
			let bool = open_state && !alive_state
			this._img_dead.visible = bool

			this._img_special.visible = this.data.mon_type == BossModel.MYSTERY_SPECIAL_BOSS_TYPE

			this.refresh_con.visible = level <= max_lv && !alive_state
			this._lb_bossName.text = this.data.boss_name
			this._lb_level.text = "Lv." + this.data.lv
			let is_max_num = false
			if (this.data.mon_type == BossModel.MYSTERY_SPECIAL_BOSS_TYPE) {
				let now_num = this.model.GetNowSpecialBossNum(this.data.layer)
				this.SetGray(now_num == 0)
			} else if (this.data.mon_type == BossModel.MYSTERY_BOX_TYPE || this.data.mon_type == BossModel.MYSTERY_SUPER_BOX_TYPE) {
				this.refresh_con.visible = false
				this._lb_bossName.text = this.data.boss_name
				this._img_dead.visible = false
				let max = this.model.GetMaxBoxNumByType(this.data.mon_type, this.data.layer)
				let now = this.model.GetNowBoxNum(this.data.mon_type, this.data.layer)
				is_max_num = max == now
				this.SetGray(now == 0)
			} else {
				this.SetGray(bool)
			}

			//if (this.data.mon_type == BossModel.MYSTERY_BOX_TYPE || this.data.mon_type == BossModel.MYSTERY_SUPER_BOX_TYPE ) {
			//this.mon_name.text = this.data.boss_name
			//this._img_dead.visible = false 

			//let max = this.model.GetMaxBoxNumByType(this.data.mon_type, this.data.layer)
			//let now = this.model.GetNowBoxNum(this.data.mon_type, this.data.layer)
			//is_max_num = max == now
			//}else{
			//this.refresh_con.visible = level <= max_lv && ! alive_state 
			//this.mon_name.textFlow = Util.StrToHTML(this.data.boss_name + "\n" + "<font color=`ffffff.length`>" + "Lv." + this.data.lv + "</font>")
			//}

			let config = this.cfg_boss[this.data.boss_id]
			if (config) {
				if (PlatformManager.IsEyouEnPlatform()) {
					this.step_num.text = "G" + config.image
				} else {
					this.step_num.text = config.image + "阶"
				}
			} else {
				//GameError.GetInstance().SendErrorToPHP("BossCommonRoomItem can ! find boss cfg. id is = " + this.data.boss_id)
			}
			if (open_state) {

			} else {
				this._lb_unopen_tips.text = (level >= open_lv && ("您等级太高") || (""))
			}
			if (!alive_state && !is_max_num) {
				this.StartTimer()
			}
		}
	}

	public SetGray(bool?) {
		Util.SetImageGray(this.mon_icon, bool)
		Util.SetImageGray(this.circle_image, bool)
		Util.SetImageGray(this._img_bg, bool)
	}

	public StartTimer() {
		if (!this.timer_id) {
			let time_fun = () => {
				this.OnTime()
			}
			this.timer_id = GlobalTimerQuest.AddPeriodQuest(time_fun, 1, -1)
			time_fun()
		}
	}

	public StopTimer() {
		if (this.timer_id) {
			GlobalTimerQuest.CancelQuest(this.timer_id)
			this.timer_id = null
		}
	}

	_img_bg: Laya.Image
	circle_image: Laya.Image
	mon_icon: Laya.Image
	step_bg: Laya.Image
	step_num: Laya.Label
	_lb_unopen_tips: Laya.Label
	_img_dead: Laya.Image
	refresh_con: Laya.Box
	_Image3: Laya.Image
	refresh_time: Laya.Label
	_lb_alive: Laya.Label
	_img_select: Laya.Image
	reborn_effect: Laya.Box
	_img_special: Laya.Image
	_Group2: Laya.VBox
	_lb_bossName: Laya.Label
	_lb_level: Laya.Label
	public GetComponents() {
		[
			this._img_bg,
			this.circle_image,
			this.mon_icon,
			this.step_bg,
			this.step_num,
			this._lb_unopen_tips,
			this._img_dead,
			this.refresh_con,
			this._Image3,
			this.refresh_time,
			this._lb_alive,
			this._img_select,
			this.reborn_effect,
			this._img_special,
			this._Group2,
			this._lb_bossName,
			this._lb_level,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"circle_image",
				"mon_icon",
				"step_bg",
				"step_num",
				"_lb_unopen_tips",
				"_img_dead",
				"refresh_con",
				"_Image3",
				"refresh_time",
				"_lb_alive",
				"_img_select",
				"reborn_effect",
				"_img_special",
				"_Group2",
				"_lb_bossName",
				"_lb_level",
			])
	}
}
window["BossMysteryMonItem"] = BossMysteryMonItem
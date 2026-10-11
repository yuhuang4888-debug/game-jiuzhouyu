import { BaseItem1 } from "../common/BaseItem1"
import { Config } from "../common/Config"
import { Util, GlobalTimerQuest } from "../util/Util"
import { TimeUtil } from "../util/TimeUtil"
import { ColorUtil } from "../util/ColorUtil"
import { ResManager } from "../common/ResManager"
import { BossModel } from "../commonModel/BossModel"

export class BossSuitItem extends BaseItem1 {
	boss_id
	boss_info
	callfunc
	index
	select
	timer
	type

	public constructor(parent?) {
		super(parent)
		this.base_file = "suitboss"
		this.layout_file = "BossSuitItem"
		this.type = null
		this.callfunc = null
		this.index = null
		this.select = null

		this.load_callback = () => {
			if (this.type == null) {
				this.type = 1
			}

			this.InitEvent()
			this.LoadSuccess()
			// if (PlatformMgr.GetInstance().IsEyouIdnPlatform()) {
			// 	SetAnchoredPositionY(this._Group1, -107)
			// }
		}
	}

	public setFun(type?, callfunc?, index?) {
		this.type = type
		this.callfunc = callfunc
		this.index = index
	}

	public InitEvent() {
		this.BindEvent(BossModel.GetInstance(), BossModel.KILL_BOSS, (scmd?) => {
			if (scmd.boss_type == BossModel.BossType.suit && this.boss_id == scmd.boss_id) {
				this.boss_info.reborn_time = scmd.reborn_time
				this.TimerStart(scmd.reborn_time)
			}
		})

		Util.AddClickEvent(this._Group2, () => {
			if (this.callfunc != null) {
				this.callfunc(this)
			}
		}, this, true)
	}

	public LoadSuccess() {
		/*
		if (this.type == 1) {
			ResManager.GetInstance().SetImageSprite(this, this._img_alive, "suitboss_asset", "uimh_021")
			ResManager.GetInstance().SetImageSprite(this, this._img_unAlive, "suitboss_asset", "uimh_021a")
			ResManager.GetInstance().SetImageSprite(this, this._img_select, "suitboss_asset", "uimh_021b")
		} else {
			ResManager.GetInstance().SetImageSprite(this, this._img_alive, "suitboss_asset", "uimh_022")
			ResManager.GetInstance().SetImageSprite(this, this._img_unAlive, "suitboss_asset", "uimh_022a")
			ResManager.GetInstance().SetImageSprite(this, this._img_select, "suitboss_asset", "uimh_022b")
		}
		*/
		if (this.boss_info != null) {
			this.SetData(this.boss_info)
		}

		if (this.select != null) {
			this.SetSelect(this.select)
		}
	}

	public SetData(boss_info?) {
		this.boss_info = boss_info
		if (!this.is_loaded) {
			return
		}
		this.boss_id = boss_info.boss_id
		let bool = boss_info.reborn_time <= 0
		// this._img_alive.visible = bool
		// this._img_unAlive.visible = !bool
		this._img_boss.gray = !bool
		let lv = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_mon.name, this.boss_id, false).lv
		this._lb_lv.text = "LV." + lv
		this.TimerStart(boss_info.reborn_time)
		this._img_red.visible = false
		if(this.boss_info.boss_type==BossModel.BossType.abyss){
			this._img_red.visible = BossModel.GetInstance().CheckBossRemainState(boss_info)
		}
	}

	public SetSelect(bool?) {
		if (!this.is_loaded) {
			this.select = bool
			return
		}
		this._img_select.visible = bool
		this._gp_mon.visible = bool
	}

	public TimerStart(refresh_time?) {
		this.StopTimer()
		if (refresh_time <= 0) {
			this._lb_time.text = "已复活"
			this._lb_time.color = "#00fa64"
			// this._img_alive.visible = true
			// this._img_unAlive.visible = false
			this._img_boss.gray = false
			//LayoutRebuilder(this._Group1)
			return
		}
		this.OnTime()
		this.timer = GlobalTimerQuest.AddPeriodQuest(() => {
			this.OnTime()
		}, 1)
	}

	public OnTime() {
		if (this.use_delete_method || Util.IsNull(this._lb_time)) {
			return
		}
		let left_time = this.boss_info.reborn_time - TimeUtil.getServerTime()
		if (left_time < 0) {
			this._lb_time.text = "已复活"
			this._lb_time.color = "#00fa64"
			// this._img_alive.visible = true
			// this._img_unAlive.visible = false
			this._img_boss.gray = false
			this.StopTimer()
			//LayoutRebuilder(this._Group1)
			return
		}
		let time = TimeUtil.convertTime(left_time)
		this._lb_time.text = time
		this._lb_time.color = "#ff4f50"
		//LayoutRebuilder(this._Group1)
	}

	public StopTimer() {
		if (this.timer) {
			GlobalTimerQuest.CancelQuest(this.timer)
			this.timer = null
		}
	}

	public DeleteMe() {
		this.StopTimer()
		this.type = null
		this.callfunc = null
		super.DeleteMe()
	}

	_Group2: Laya.Box
	_gp_boss_icon: Laya.Box
	_img_bg: Laya.Image
	_img_boss: Laya.Image
	_img_select: Laya.Image
	_gp_mon: Laya.Box
	_Image1: Laya.Image
	_img_mon: Laya.Image
	_Group1: Laya.VBox
	_lb_lv: Laya.Label
	_lb_time: Laya.Label
_img_red:Laya.Image
	public GetComponents() {
		[
			this._Group2,
			this._gp_boss_icon,
			this._img_bg,
			this._img_boss,
			this._img_select,
			this._gp_mon,
			this._Image1,
			this._img_mon,
			this._Group1,
			this._lb_lv,
			this._lb_time,
this._img_red,
		]
			= this.GetChildrenByNames([

				"_Group2",
				"_gp_boss_icon",
				"_img_bg",
				"_img_boss",
				"_img_select",
				"_gp_mon",
				"_Image1",
				"_img_mon",
				"_Group1",
				"_lb_lv",
				"_lb_time",
"_img_red",
			])
	}
}
window["BossSuitItem"] = BossSuitItem
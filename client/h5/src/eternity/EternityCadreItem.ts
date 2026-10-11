import { AutoFightManager } from "../autofight/AutoFightManager"
import { BaseItem1 } from "../common/BaseItem1"
import { Config } from "../common/Config"
import { BossModel } from "../commonModel/BossModel"
import { EternityEvent, EternityModel } from "../commonModel/EternityModel"
import { Scene } from "../scene/Scene"
import { SceneObj } from "../scene/sceneobj/SceneObj"
import { ColorType, ColorUtil } from "../util/ColorUtil"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest, Util } from "../util/Util"
import { Vector2 } from "../util/Vector2"

export class EternityCadreItem extends BaseItem1 {
	click: Laya.Box
	_Image1: Laya.Image
	_lb_name: Laya.Label
	_lb_lv: Laya.Label
	_lb_state: Laya.Label
	_img_select: Laya.Image
	UpdateTimer
	_data
	_map_data
	_model
	_timer

	public constructor(parent?) {
		super(parent)



		this.base_file = "eternity"
		this.layout_file = "EternityCadreItem"
		this._model = EternityModel.GetInstance()
		this.load_callback = () => {

			// if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
			// 	this._lb_name.size  = 14
			// 	this._lb_lv.size  = 14
			// 	this._lb_state.size  = 14
			// 	SetAnchoredPosition(this._lb_lv,128,0)
			// 	SetAnchoredPosition(this._lb_state,82,-6)
			// }
			this.LoadSuccess()
			this.InitEvent()
		}
		this.UpdateTimer = () => {
			let time = this._data.reborn_time - TimeUtil.getServerTime()
			if (time < 0) {
				this.ClearTimer()
				this.UpdateBossHp()
			} else {
				this._lb_state.text = TimeUtil.timeConvert(time, "hh:MM:ss")
			}
		}
	}

	public InitEvent() {

		Util.AddClickEvent(this.click, () => {
			if (!this._data) {
				return
			}
			if (!this._map_data) {
				return
			}
			AutoFightManager.GetInstance().SetAutoFight(false)
			let tar_pos = new Vector2(this._map_data.x / SceneObj.GetLogicRealRatio().x, this._map_data.y / SceneObj.GetLogicRealRatio().y)
			Scene.GetInstance().MainRoleMove(tar_pos, 2, () => {
				AutoFightManager.GetInstance().SetAutoFight(true)
			}
			)
			Scene.GetInstance().SetClickTarget(null)
			this._model.Fire(EternityEvent.SELECT_MON, this._map_data.mon_id)
		}
			, this)
		this.BindEvent(this._model, EternityEvent.SELECT_MON, (mon_id?) => {
			if (!this._map_data) {
				return
			}
			this._img_select.visible = this._map_data.mon_id == mon_id
		}
		)
		this.BindEvent(BossModel.GetInstance(), BossModel.UPDATE_BOSS_HP, () => {
			this.UpdateBossHp()
		}
		)
	}

	public DeleteMe() {

		this.ClearTimer()
		super.DeleteMe()
	}

	public LoadSuccess() {
	}
	public SetData(data?) {

		this._data = data
		this._lb_lv.text = "LV." + data.mon_lv
		if (data.reborn_time > TimeUtil.getServerTime()) {
			this._lb_state.color = "#ff4f50"
			let key = "cadre@" + data.mon_id
			this.ClearTimer()
			this.StartTimer()
			this.UpdateTimer()
		} else {
			this.UpdateBossHp()
		}
	}

	public StartTimer() {

		this.ClearTimer()
		let func = () => {
			this.UpdateTimer()
		}
		this._timer = GlobalTimerQuest.AddPeriodQuest(func, 1, -1)
	}

	public ClearTimer() {

		if (this._timer) {
			GlobalTimerQuest.CancelQuest(this._timer)
			this._timer = null
		}
	}

	public SetMapData(mData?) {

		this._map_data = mData
		let mdata = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_mon.name, mData.mon_id, false)
		this._lb_name.text = (mdata && (mdata.name) || (""))
	}

	public UpdateBossHp() {

		if (this._data && (!this._data.reborn_time || TimeUtil.getServerTime() >= this._data.reborn_time)) {
			this._lb_state.color = "#19ae4a"
			let data = BossModel.GetInstance().GetBossHpData(this._data.mon_id)
			if (data) {
				this._lb_state.text = Math.floor(data.hp / data.hp_max * 100) + "%"
			} else {
				if (BossModel.GetInstance().HasBossHpCfg(this._data.mon_id)) {
					this._lb_state.text = "100%"
				} else {
					this._lb_state.text = "已复活"
				}
			}
		}
	}



	public GetComponents() {
		[
			this.click,
			this._Image1,
			this._lb_name,
			this._lb_lv,
			this._lb_state,
			this._img_select,
		]
			= this.GetChildrenByNames([

				"click",
				"_Image1",
				"_lb_name",
				"_lb_lv",
				"_lb_state",
				"_img_select",
			])
	}
}
window["EternityCadreItem"] = EternityCadreItem
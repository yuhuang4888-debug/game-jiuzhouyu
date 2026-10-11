
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { KfHolyAreaModel } from "../commonModel/KfHolyAreaModel"
import { ResManager } from "../common/ResManager"
import { ColorUtil } from "../util/ColorUtil"
import { TimeUtil } from "../util/TimeUtil"
import { ColorType } from "../util/ColorUtil"
import { GlobalTimerQuest } from "../util/Util"
import { Config } from "../common/Config"
import { GameResPath } from "../util/GameResPath"
export class KfHolyAreaBuildMsgBossItem extends BaseItemRenderer {
	_Image1: Laya.Image
	_Image2: Laya.Image
	_lb_left_time: Laya.Label
	_lb_boss_name: Laya.Label
	_lb_level: Laya.Label
	_img_boss_head: Laya.Image
	_img_select: Laya.Image
	_gp_peace: Laya.Box
	_Image3: Laya.Image
	_Label1: Laya.Label
	time_id

	public static width = 85
	public static height = 113
	WIDTH = 85
    HEIGT = 113
	public constructor(parent) {
		super()

		this.base_file = "kfHolyArea"
		this.layout_file = "KfHolyAreaBuildMsgBossItem"
		this.load_callback = () => {


		}
		this.Load()
	}



	public dataChanged() {
		if (super.dataChanged()) {
			this._img_select.visible = this.selected

			let data = this.data
			if (data) {
				this.ClearTimer()

				if (data.reborn_time > 0) {
					let loop_func = () => {
						if (this.data && this.data.reborn_time - TimeUtil.getServerTime() > 0) {
							this._lb_left_time.color = "#ff4f50"//ColorUtil.GetColorLight(ColorType.RED)
							this._lb_left_time.text = TimeUtil.convertTimeColor(this.data.reborn_time - TimeUtil.getServerTime())
						} else {
							this._lb_left_time.color = "#0a953e"//ColorUtil.GetColorLight(ColorType.GREEN)
							this._lb_left_time.text = "已复活"
							this.ClearTimer()
						}
					}
					this.time_id = GlobalTimerQuest.AddPeriodQuest(loop_func, 1, -1)
					loop_func()
				} else {
					this._lb_left_time.color = "#0a953e"//ColorUtil.GetColorLight(ColorType.GREEN)
					this._lb_left_time.text = "已复活"
				}
				this._gp_peace.visible = KfHolyAreaModel.GetInstance().IsPeaceBoss(data.bossid)
				let boss_info = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_mon.name, data.bossid, false)
				ResManager.GetInstance().SetOutsideImageSprite(this, this._img_boss_head, GameResPath.GetMonsterHeadPath(boss_info.icon))
				this._lb_boss_name.text = boss_info.name
				this._lb_level.text = "Lv." + boss_info.lv

			}

		}
	}

	public ClearTimer() {

		if (this.time_id) {
			GlobalTimerQuest.CancelQuest(this.time_id)
			this.time_id = null
		}
	}

	public DeleteMe() {

		this.ClearTimer()
		super.DeleteMe()
	}


	public GetComponents() {
		[
			this._Image1,
			this._Image2,
			this._lb_left_time,
			this._lb_boss_name,
			this._lb_level,
			this._img_boss_head,
			this._img_select,
			this._gp_peace,
			this._Image3,
			this._Label1,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_Image2",
				"_lb_left_time",
				"_lb_boss_name",
				"_lb_level",
				"_img_boss_head",
				"_img_select",
				"_gp_peace",
				"_Image3",
				"_Label1",
			])
	}
}
window["KfHolyAreaBuildMsgBossItem"] = KfHolyAreaBuildMsgBossItem
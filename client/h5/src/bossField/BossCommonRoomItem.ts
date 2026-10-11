import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { Config } from "../common/Config"
import { ResManager } from "../common/ResManager"
import { PlatformManager } from "../PlatformManager"
import { RoleManager } from "../commonModel/RoleManager"
import { GameError } from "../util/GameError"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest, SetAnchoredPosition, SetAnchoredPositionX, SetAnchoredPositionY, SetSizeDeltaX } from "../util/Util"
import { BossModel } from "../commonModel/BossModel"

export class BossCommonRoomItem extends BaseItemRenderer {

	public WIDTH = 234 //86 + 13
	public HEIGT = 130
	public static HEIGT_UI = 130
	effect
	time_id
	res_mgr:ResManager
	model:BossModel
	public constructor(parent) {
		super()

		this.base_file = "bossField"
		this.layout_file = "BossCommonRoomItem"
		this.res_mgr = ResManager.GetInstance()
		this.model = BossModel.GetInstance()
		this.load_callback = () => {
			this.LoadSuccess()
		}
		this.Load()
	}

	public LoadSuccess() {

		if (PlatformManager.IsEyouEnPlatform()) {
			this._lb_boss_name.fontSize = 15
			this._lb_boss_level.fontSize = 18
			this._lb_unopen_tips.fontSize = 18
			this._lb_count_down.fontSize = 18
			this._lb_alive.fontSize = 18
			SetAnchoredPositionX(this._lb_boss_name, 95)
		}
		
		if (PlatformManager.IsEyouIdnPlatform()) {
			this._lb_boss_name.fontSize = 16
			this._lb_boss_name.leading = 0.7
			this._lb_boss_level.fontSize = 18
			this._lb_alive.fontSize = 18
			this._lb_stage.fontSize = 14
			SetAnchoredPositionY(this._lb_stage, -90)

			// let csf = this._lb_boss_name.GetComponent("ContentSizeFitter")
			// csf.horizontalFit = UnityEngine.UI.ContentSizeFitter.FitMode.Unconstrained
			SetSizeDeltaX(this._lb_boss_name, 132.2)
			SetAnchoredPosition(this._lb_boss_name, 98.9, -9.2)
			this._lb_boss_name.valign = "middle"
			this._lb_boss_name.align = "left"

			this._lb_count_down.fontSize = 18
			this._lb_count_down.leading = 0.7
		}
		this.SetProbImg(false)
	}

	protected dataChanged() {
		if (!super.dataChanged())return
		this.UpdateView()
	}

	public UpdateView(){
			this._img_select.visible = this.selected

			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_head, GameResPath.GetMonsterHeadPath(this.data.icon))

			let level = RoleManager.GetInstance().GetMainRoleVo().level
			let open_lv = this.data.open_lv
			let max_lv = this.data.max_lv
			let open_state = level >= open_lv && level <= max_lv
			let alive_state = this.data.reborn_time == 0 || TimeUtil.getServerTime() > this.data.reborn_time

		this._Image1.visible=this._lb_count_down.visible = level <= max_lv && !alive_state
			this._lb_unopen_tips.visible = !open_state
			this._lb_alive.visible = level <= max_lv && alive_state
		let is_show_arrow = !(this.data.layer==0||this.data.boss_type==BossModel.BossType.fieldspecial)
		this._lb_alive.text=!is_show_arrow?"不消耗体力":""
		this.SetProbImg(is_show_arrow,this.data.arrow_num)
		//this._img_dead.visible = open_state && !alive_state
			this._lb_boss_name.text = this.data.boss_name
			this._lb_boss_level.text = "Lv." + this.data.lv
			let boss_cfg = this.res_mgr.GetGameConfigFromCache(this.base_item, "config_boss_cfg", false)
			let config = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_boss_cfg.name, this.data.boss_id, false, boss_cfg)
			if (config) {
				if (PlatformManager.IsEyouEnPlatform()) {
					this._lb_stage.text = "G" + config.image
				} else if (PlatformManager.IsEyouIdnPlatform()) {
					this._lb_stage.text = "Grade " + config.image
				} else {
					this._lb_stage.text = config.image + "阶"
				}
				this._img_peace.visible = config.sign == 1
			} else {
				GameError.GetInstance().SendErrorToPHP("BossCommonRoomItem can ! find boss cfg. id is = " + this.data.boss_id)
			}
			if (!open_state) {
				this._lb_unopen_tips.text = level >= open_lv && "您等级太高" || ""
			}

			if (!alive_state) {
				this.StartTimer()
		}
	}

	public StartTimer() {

		this.StopTimer()
		let loop_func = () => {
			let left_time = this.data.reborn_time - TimeUtil.getServerTime()
			if (left_time < 0) {
				this.data.reborn_time = 0
				this.dataChanged()
				this.StopTimer()
				// if (! this.effect ) {
				// 	this.effect =  new UIEffect()
				// }
				// this.effect.AddUIEffect("ui_rebirth_glow", this._gp_effect)
			}
			let time = TimeUtil.convertTime(left_time)
			this._lb_count_down.text = /**"复活" +*/ time
		}

		this.time_id = GlobalTimerQuest.AddPeriodQuest(loop_func, 1, -1)
		loop_func()
	}

	public StopTimer() {

		if (this.time_id) {
			GlobalTimerQuest.CancelQuest(this.time_id)
			this.time_id = null
		}
	}
	public SetProbImg(vis,arrow_num?){
		this._img_prob.visible=this._img_arrow_1.visible=this._img_arrow_2.visible=vis;
		if(vis){
			for(let i=1;i<=2;i++){
				let skin_str = i<=arrow_num?"ui_chief_36":"ui_chief_37"
				ResManager.GetInstance().SetImageSprite(this,this["_img_arrow_"+i],"bossField",skin_str)
			}
		}
	}

	public DeleteMe() {

		// if (this.effect ) {
		// 	this.effect.DeleteMe()
		// 	this.effect.ClearUIEffect(this._gp_effect)
		// 	this.effect = null
		// }
		this.StopTimer()
		super.DeleteMe()
	}

_img_bg:Laya.Image
_img_head_bg:Laya.Image
_img_head:Laya.Image
_img_stage:Laya.Image
_lb_stage:Laya.Label
_lb_boss_name:Laya.Label
_lb_boss_level:Laya.Label
_lb_unopen_tips:Laya.Label
_Image1:Laya.Image
_lb_count_down:Laya.Label
_lb_alive:Laya.Label
_img_unopened:Laya.Image
_img_peace:Laya.Image
_img_select:Laya.Image
_gp_effect:Laya.Box
_img_prob:Laya.Image
_img_arrow_1:Laya.Image
_img_arrow_2:Laya.Image
public GetComponents() {
[
this._img_bg,
this._img_head_bg,
this._img_head,
this._img_stage,
this._lb_stage,
this._lb_boss_name,
this._lb_boss_level,
this._lb_unopen_tips,
this._Image1,
this._lb_count_down,
this._lb_alive,
this._img_unopened,
this._img_peace,
this._img_select,
this._gp_effect,
this._img_prob,
this._img_arrow_1,
this._img_arrow_2,
]
 = this.GetChildrenByNames([

"_img_bg",
"_img_head_bg",
"_img_head",
"_img_stage",
"_lb_stage",
"_lb_boss_name",
"_lb_boss_level",
"_lb_unopen_tips",
"_Image1",
"_lb_count_down",
"_lb_alive",
"_img_unopened",
"_img_peace",
"_img_select",
"_gp_effect",
"_img_prob",
"_img_arrow_1",
"_img_arrow_2",
])
}
}

window["BossCommonRoomItem"] = BossCommonRoomItem
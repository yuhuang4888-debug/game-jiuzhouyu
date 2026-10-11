import { BaseItem1 } from "../common/BaseItem1"
import { MainUIManager } from "../common/MainUIManager"
import { ResManager } from "../common/ResManager"
import { BaseDungeonModel } from "../commonModel/BaseDungeonModel"
import { MainUIModel } from "../commonModel/MainUIModel"
import { RoleManager } from "../commonModel/RoleManager"
import { SceneManager } from "../scene/SceneManager"
import { SkillVo } from "../skill/SkillVo"
import { GameResPath } from "../util/GameResPath"
import { SYTweenLite } from "../util/SYTweenLite"
import { SetAnchoredPositionX, SetAnchoredPositionY, Util, SetLocalScaleX, Trim, SetHtmlStyle, SetHtmlCenter } from "../util/Util"
import { Config } from "../common/Config"
export class DungeonHeartFightSceneItem extends BaseItem1 {
	InitEvent
	LoadSuccess
	UpdateArrowState
	UpdateView
	alpha
	destroy_callback
	left
	tween_id

	public constructor(parent?) {
		super(parent)


		this.base_file = "dungeonHeart"
		this.layout_file = "DungeonHeartFightSceneItem"
		let base_model = BaseDungeonModel.GetInstance()

		let mainUI_model = MainUIModel.GetInstance()
		let local_MainUIModel = MainUIModel
		let local_laya = Laya
		let arrow_state_ = false
		this.load_callback = () => {
			SetHtmlStyle(this._lb_skill_desc, { f: 18, c: "#663915", w: 209 })
			this.LoadSuccess()
		}

		this.LoadSuccess = () => {

			this.InitEvent()
			this.UpdateView()
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._img_arrow, () => {
				arrow_state_ = !arrow_state_
				this.UpdateArrowState()
			}
				, this, true)

			MainUIManager.GetInstance().AddMoveComponent(this, this.display_obj, false, null)


			// let state = mainUI_model.activity_icon_in_show
			// if (state) {
			// 	this.alpha = 0
			// 	this.left = -this._box_ui.width
			// } else {
			// 	this.alpha = 1
			// 	this.left = 10
			// }
		}

		this.UpdateArrowState = () => {
			
			this.StopTween()
			let value = arrow_state_ && -231 || 0
			this.tween_id = SYTweenLite.to(this, this._box_ui, SYTweenLite.UiAnimationType.POSX, value, 0.3,()=>{
				//SetLocalScaleX(this._img_arrow, arrow_state_ && 1 || -1)
				this._panel_btn_img.rotation= arrow_state_ && 270 || 90
			})
		}

		this.UpdateView = () => {
			let cur_dun_id = SceneManager.GetInstance().GetCurrDunId()
			let cfg = Config.PRELOAD_SERVER_CONFIG.config_dungeon_learn_skill[cur_dun_id]//Config.Dungeonlearnskill[cur_dun_id]
			let skill_id = 0
			if (cfg) {
				let skill_list = JSON.parse(cfg.skill_list)
				let career = RoleManager.GetInstance().GetMainRoleCareer()
				if (skill_list.length > 0) {
					for (let _ in skill_list) {
						var v = skill_list[_]
						if (Number(v[0]) == career) {
							skill_id = v[1][0][0]
						}
					}
				}
			}
			if (skill_id) {
				let skill_vo = new SkillVo(skill_id)
				let icon = skill_vo.GetIcon()
				ResManager.GetInstance().SetOutsideImageSprite(this, this._img_skill_icon, GameResPath.GetSkillIconPath(icon != 0 && icon || skill_id))
				this._lb_skill_desc.innerHTML = Trim(skill_vo.getDesc(null, false))
				this._lb_skill_desc.style.width=209
				if(this._lb_skill_desc.contextHeight<=18){
					SetHtmlCenter(this._lb_skill_desc, { x: 11, w: 209 })
				}
				//SetHtmlCenter(this._lb_skill_desc, { x: 6, w: 220 })
			}
		}

	}

	public StopTween() {

		if (this.tween_id) {
			SYTweenLite.Stop(this.tween_id)
			this.tween_id = null
		}
	}


	public DeleteMe() {
		this.StopTween()
		MainUIManager.GetInstance().RemoveMoveComponent(this)
		super.DeleteMe()
	}


_box_ui:Laya.Box
_img_bg:Laya.Image
_Image2_title2:Laya.Image
_lb_title2:Laya.Label
_lb_name:Laya.Label
_Image2:Laya.Image
_Image3:Laya.Image
_Label1:Laya.Label
_Label2:Laya.Label
_box_icon:Laya.Box
skillBg:Laya.Image
_img_skill_icon:Laya.Image
_lb_skill_desc:Laya.HTMLDivElement
_img_arrow:Laya.Box
_panel_btn_img:Laya.Image
public GetComponents() {
[
this._box_ui,
this._img_bg,
this._Image2_title2,
this._lb_title2,
this._lb_name,
this._Image2,
this._Image3,
this._Label1,
this._Label2,
this._box_icon,
this.skillBg,
this._img_skill_icon,
this._lb_skill_desc,
this._img_arrow,
this._panel_btn_img,
]
 = this.GetChildrenByNames([

"_box_ui",
"_img_bg",
"_Image2_title2",
"_lb_title2",
"_lb_name",
"_Image2",
"_Image3",
"_Label1",
"_Label2",
"_box_icon",
"skillBg",
"_img_skill_icon",
"_lb_skill_desc",
"_img_arrow",
"_panel_btn_img",
])
}
}
 window["DungeonHeartFightSceneItem"]= DungeonHeartFightSceneItem
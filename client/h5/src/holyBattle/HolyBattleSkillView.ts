import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { SkillManager } from "../skill/SkillManager"
import { GameResPath } from "../util/GameResPath"
import { SetHtmlCenter, SetHtmlStyle, Trim, Util } from "../util/Util"

export class HolyBattleSkillView extends BaseView1 {
	InitEvent
	Open
	Scrdes_scroller
	UpdateView
	change_scene_close
	click_bg_toClose
	is_center
	show_open_movie
	use_background

	public constructor() {
		super()


		this.base_file = "holyBattle"
		this.layout_file = "HolyBattleSkillView"
		this.layer_value = Enum_UILayer.Activity
		this.use_background = true
		this.click_bg_toClose = true
		this.is_center = true
		this.show_open_movie = true
		this.change_scene_close = true
		let local_skillMgr = SkillManager.GetInstance()
		let skill_id_ = null
		this.load_callback = () => {
			this.des_scroller.vScrollBarSkin = ""
			SetHtmlStyle(this.des_text, { f: 20, c: "#663915", w: 433, lh: 25 })
			SetHtmlStyle(this.name_text, { f: 22, c: "#b94a00", w: 184,ww:false,st:2,stc:"#fbfaf1"})
			this.UpdateView()
			this.InitEvent()
		}

		this.Open = (...new_args) => {
			let parm = new_args
			if (parm && parm.length > 0) {
				skill_id_ = parm[0]
			}
			super.Open()
		}

		this.UpdateView = () => {
			//ResManager.GetInstance().SetOutsideImageSprite(this, this._Image2, GameResPath.GetIcon("common2", "uity_016j"), false)
			if (skill_id_) {
				ResManager.GetInstance().SetOutsideImageSprite(this, this.icon,  GameResPath.GetSkillIconPath(skill_id_))//"client/assets/icon/skillsicon/" + skill_id_ + ".png")
				let skill_vo = local_skillMgr.getSkill(skill_id_)
				this.name_text.innerHTML = `Lv.${skill_vo.level}&nbsp;${skill_vo.getName()}`
				SetHtmlCenter(this.name_text,{x:179,w:184})
				//this.lv_text.text = `等级：${skill_vo.level}级`
				this.des_text.innerHTML = Trim(skill_vo.getDesc(0))
				this.des_text.style.width=433
			}
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this.enter_btn, () => {
				this.Close()
			}
				, this, true)


			let close_fun = () => {
				this.Close()
			}
			Util.AddClickEvent(this.closeBtn, close_fun, this, true)
		}


	}

	public DeleteMe() {
		super.DeleteMe()
	}




_Image1:Laya.Image
_Image333:Laya.Image
closeBtn:Laya.Image
icon_bg:Laya.Image
icon:Laya.Image
_img_bg4:Laya.Image
name_text:Laya.HTMLDivElement
lv_text:Laya.Label
des_scroller:Laya.Panel
_Label1:Laya.Label
des_text:Laya.HTMLDivElement
enter_btn:Laya.Box
_Image3:Laya.Image
labelDisplay:Laya.Label
public GetComponents() {
[
this._Image1,
this._Image333,
this.closeBtn,
this.icon_bg,
this.icon,
this._img_bg4,
this.name_text,
this.lv_text,
this.des_scroller,
this._Label1,
this.des_text,
this.enter_btn,
this._Image3,
this.labelDisplay,
]
 = this.GetChildrenByNames([

"_Image1",
"_Image333",
"closeBtn",
"icon_bg",
"icon",
"_img_bg4",
"name_text",
"lv_text",
"des_scroller",
"_Label1",
"des_text",
"enter_btn",
"_Image3",
"labelDisplay",
])
}
}
 window["HolyBattleSkillView"]= HolyBattleSkillView
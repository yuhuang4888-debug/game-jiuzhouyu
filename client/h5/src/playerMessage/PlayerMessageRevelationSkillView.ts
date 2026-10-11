import { BaseView1 } from "../common/BaseView1"
import { Util, SetSizeDeltaY, SetAnchoredPositionY } from "../util/Util"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { SkillManager } from "../skill/SkillManager"
import { RevelationModel, RevelationEvent } from "../commonModel/RevelationModel"

export class PlayerMessageRevelationSkillView extends BaseView1 {
	model
	res_mgr
	skill_mgr
	skill_id
    data
	public constructor() {
		super()
		this.base_file = "revelation"
		this.layout_file = "RevelationSkillView"
		this.layer_value = Enum_UILayer.Activity
		this.is_center = true
		this.use_background = true
		this.click_bg_toClose = true
		this.show_open_movie = true
		this.destroy_imm = true

		this.res_mgr = ResManager.GetInstance()
		this.model = RevelationModel.GetInstance()
		this.skill_mgr = SkillManager.GetInstance()
		this.skill_id = null

		this.load_callback = () => {
            this.btn_up.visible = false
			this.curScroller.vScrollBar.visible = false
			this._Scroller1.vScrollBar.visible = false

			this._lb_desc_cur.width = 350
			this._lb_desc_cur.style.fontSize = 20
			this._lb_desc_cur.style.leading = 15
			this._lb_desc_cur.style.color = "#663915"

			this._lb_desc_next.width = 350
			this._lb_desc_next.style.fontSize = 20
			this._lb_desc_next.style.leading = 15
			this._lb_desc_next.style.color = "#663915"
			
			this.res_mgr.SetOutsideImageSprite(this, this.img_bg2, "resource/game/revelation/other/ui_Apocalypse_05.png")

			this.InitEvent()
			this.InitView()
		}

		this.destroy_callback = () => {
			//this.ClearUIEffect(this._group_eff)
		}
	}   

	private InitEvent() {
	}

	private InitView() {
		this.SetSkillInfo()

	}

	private SetSkillInfo() {
		let SkillCfg = this.res_mgr.GetGameConfigFromCache(this, "config_revelation_equip_skill", false)
		let skillList = this.data.skill_list
		if (SkillCfg) {
			if (!skillList || skillList.length == 0) {
				let minLv
				for (let key in SkillCfg) {
					let vo = SkillCfg[key]
					if (!minLv || minLv > vo.lv) {
						minLv = vo.lv
					}
				}
				let skillLv1Cfg = SkillCfg[minLv]
				if (skillLv1Cfg) {
					let skillData = JSON.parse(skillLv1Cfg.skill_id)[0]
					let skill_id = Number(skillData[0])
					let skill_lv = Number(skillData[1])
					let skill_vo = this.skill_mgr.getSkill(skill_id)
					let icon = skill_vo.GetIcon(skill_lv)
					this.res_mgr.SetOutsideImageSprite(this, this.img_icon, GameResPath.GetSkillIconPath(icon == 0 && skill_id || icon))
					this.lb_name.text = skill_vo.GetLvName(skill_lv)
					let str = skill_vo.getDesc(skill_lv, false)
					this._lb_desc_cur.innerHTML = str
					this._lb_desc_cur.width = 350
					this._lb_tips_act.text = "所有部位聚灵等级达到" + minLv + "级后可激活"
					this._lb_level.text = "未激活"
					this._lb_tips_act.visible = true
					this._group_next.visible = false
					this.skill_id = skill_id
				}
				this.lb_btn.text = "激活"
			} else {
				let skillData = skillList[skillList.length - 1]
				let CurskillId = skillData.skill_id
				let CurskillLv = skillData.lv
				let devourLv = null
				let nextLv = null
				SetAnchoredPositionY(this._group_next, 560)
				SetSizeDeltaY(this.display_obj, 945)

				for (let key in SkillCfg) {
					let skillInfo = JSON.parse(SkillCfg[key].skill_id)[0]
					if (Number(skillInfo[0]) == CurskillId && Number(skillInfo[1]) == CurskillLv) {
						devourLv = key
						break
					}
				}
				for (let _temp in SkillCfg) {
					let vo = SkillCfg[_temp]
					if (vo.lv > devourLv && (!nextLv || vo.lv < nextLv)) {
						nextLv = _temp
					}
				}
				this._lb_level.text = "等级:" + CurskillLv
				let skill_vo = this.skill_mgr.getSkill(CurskillId)
				let id = skill_vo.GetIcon(CurskillLv)
				this.res_mgr.SetOutsideImageSprite(this, this.img_icon, GameResPath.GetSkillIconPath(id != 0 && id || CurskillId))
				this.lb_name.text = skill_vo.GetLvName(CurskillLv)
				this._lb_desc_cur.innerHTML = skill_vo.getDesc(CurskillLv)
				this._lb_desc_cur.width = 350
				let nextCfg = SkillCfg[nextLv]
				if (devourLv && nextCfg) {
					let nextSkill = JSON.parse(nextCfg.skill_id)[0]
					this._lb_tips_act.visible = true
					this._group_next.visible = true
					this._lb_tips_act.text = "所有部位聚灵等级达到" + nextLv + "级后可升级"
					this._img_max.visible = false
					let next_skill_vo = this.skill_mgr.getSkill(nextSkill[0])
					let id = next_skill_vo.GetLvName(Number(nextSkill[1]))
					this._lb_desc_next.innerHTML = next_skill_vo.getDesc(Number(nextSkill[1]))
					this._lb_desc_next.width = 350
					this.skill_id = Number(nextSkill[0])
					this.lb_btn.text = "升级"
				} else {
					this._lb_tips_act.visible = false
					this._group_next.visible = false
					this.btn_up.visible = false
					this._img_max.visible = true
				}
			}
			this.img_red.visible = this.model.skillRed
		}
	}

    public Open(...parms) {
        if (parms) {
            this.data = parms[0]
        }
        super.Open()
    }

	img_bg: Laya.Image
	img_bg2: Laya.Image
	img_title: Laya.Image
	lb_name: Laya.Label
	img_bg3: Laya.Image
	img_icon: Laya.Image
	_img_max: Laya.Image
	_lb_tips: Laya.Label
	_group_cur: Laya.Box
	_Image4: Laya.Image
	_lb_level: Laya.Label
	curScroller: Laya.Panel
	Content1: Laya.Box
	_lb_desc_cur: Laya.HTMLDivElement
	_group_next: Laya.Box
	_Image5: Laya.Image
	_Label1: Laya.Label
	_Scroller1: Laya.Panel
	Content: Laya.Box
	_lb_desc_next: Laya.HTMLDivElement
	_lb_tips_act: Laya.Label
	btn_up: Laya.Box
	img_btn: Laya.Image
	lb_btn: Laya.Label
	img_red: Laya.Image
	gp_eff: Laya.Box
	gp_eff_skill: Laya.Box
	public GetComponents() {
		[
			this.img_bg,
			this.img_bg2,
			this.img_title,
			this.lb_name,
			this.img_bg3,
			this.img_icon,
			this._img_max,
			this._lb_tips,
			this._group_cur,
			this._Image4,
			this._lb_level,
			this.curScroller,
			this.Content1,
			this._lb_desc_cur,
			this._group_next,
			this._Image5,
			this._Label1,
			this._Scroller1,
			this.Content,
			this._lb_desc_next,
			this._lb_tips_act,
			this.btn_up,
			this.img_btn,
			this.lb_btn,
			this.img_red,
			this.gp_eff,
			this.gp_eff_skill,
		]
			= this.GetChildrenByNames([
				"img_bg",
				"img_bg2",
				"img_title",
				"lb_name",
				"img_bg3",
				"img_icon",
				"_img_max",
				"_lb_tips",
				"_group_cur",
				"_Image4",
				"_lb_level",
				"curScroller",
				"Content1",
				"_lb_desc_cur",
				"_group_next",
				"_Image5",
				"_Label1",
				"_Scroller1",
				"Content",
				"_lb_desc_next",
				"_lb_tips_act",
				"btn_up",
				"img_btn",
				"lb_btn",
				"img_red",
				"gp_eff",
				"gp_eff_skill",
			])
	}
}
window["PlayerMessageRevelationSkillView"] = PlayerMessageRevelationSkillView
import { BaseItem1 } from "../common/BaseItem1"
import { ResManager } from "../common/ResManager";
import { RuneEvent, RuneModel } from "../commonModel/RuneModel";
import { PlatformManager } from "../PlatformManager";
import { GameResPath } from "../util/GameResPath";
import { Util } from "../util/Util";

export class RuneSkillItem extends BaseItem1 {

    selectCache
    garyCache
    skillLv
    canActive
    vo
    index
    cond
    constructor(parent) {
        super(parent)
        this.base_file = "rune"
        this.layout_file = "RuneSkillItem"
        this.load_callback = function () {
            Util.AddClickEvent(this.display_obj, () => {
                if (this.canActive) {
                    // this.AddUIEffect("ui_Runeskills_glow1", this.effectGp1, undefined, 1, false, false, () => {
                    RuneModel.GetInstance().Fire(RuneEvent.UPDATE_RUNE_SKILL, this.skillLv)
                    // })
                }
                RuneModel.GetInstance().Fire(RuneEvent.SELECT_SKILL, this.skillLv)
            }, this, true)
            if (this.selectCache) {
                this.SetSelect(this.selectCache)
            }
            if (this.vo && this.index != undefined && this.cond) {
                this.InitItem(this.vo, this.index, this.cond)
                this.vo = undefined
                this.index = undefined
                this.cond = undefined
            }
            // this.SetGary(this.garyCache)

        }
    }

    InitItem(skillLvVo, i, condText) {
        if (this.is_loaded) {
            if (skillLvVo) {
                this.skillLv = i
                console.warn("skillkv--------:", this.skillLv)
                ResManager.GetInstance().SetOutsideImageSprite(this, this.skillImg, GameResPath.GetSkillIconPath(skillLvVo.icon))
                let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_rune_awake_skill", false)
                this.canActive = this.activeImg.visible = this.red.visible = RuneModel.GetInstance().rune_info.skill_lv == i && RuneModel.GetInstance().CanSkillUp(i + 1, cfg)
                this.lockImg.visible = this.lockLb.visible = RuneModel.GetInstance().rune_info.skill_lv <= i;
                this.skillImg.gray = this.lockImg.visible;
                this.lockLb.text = `${condText}`
            }
        } else {
            this.vo = skillLvVo
            this.index = i
            this.cond = condText
        }
    }

    SetSelect(bool) {
        this.selectCache = bool
        if (this.is_loaded) {
            this.SelectImg.visible = bool
        }
    }
    /**最后一个技能有个特殊图标*/
    SetLast() {
        if (!this.effectGp) {
            this.effectGp = new Laya.Box()
            this.display_obj.addChildAt(this.effectGp, 1)
            this.effectGp.centerX = 1
            this.effectGp.centerY = -1
            this.AddUIEffect("ui_Runeskills_glow", this.effectGp, undefined, undefined, true)
        }
    }

    SetGary(bool) {
        if (this.is_loaded) {
            this.skillImg.gray = bool;
        } else {
            this.garyCache = bool
        }
    }

    DeleteMe() {
        if (this.effectGp) {
            this.ClearUIEffect(this.effectGp)
        }
        this.ClearUIEffect(this.effectGp1)
        super.DeleteMe()
    }

    root_wnd: Laya.Box
    garyGp: Laya.Box
    mg0: Laya.Image
    skillImg: Laya.Image
    SelectImg: Laya.Image
    red: Laya.Image
    lockImg: Laya.Image
    lockImg2: Laya.Image
    activeImg: Laya.Image
    lockLb: Laya.Label
    effectGp1: Laya.Box
    effectGp: Laya.Box
    public GetComponents() {
        [
            this.root_wnd,
            this.garyGp,
            this.mg0,
            this.skillImg,
            this.SelectImg,
            this.red,
            this.lockImg,
            this.lockImg2,
            this.activeImg,
            this.lockLb,
            this.effectGp1,
            this.effectGp,
        ]
            = this.GetChildrenByNames([

                "root_wnd",
                "garyGp",
                "mg0",
                "skillImg",
                "SelectImg",
                "red",
                "lockImg",
                "lockImg2",
                "activeImg",
                "lockLb",
                "effectGp1",
                "effectGp",
            ])
    }
}
window["RuneSkillItem"] = RuneSkillItem
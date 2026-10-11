
import { ResManager } from '../common/ResManager';
import { FightEvent } from '../scene/fight/FightEvent';
import { SkillManager } from '../skill/SkillManager';
import { Message } from '../sysInfo/SysInfoController';
import { GlobalEventSystem } from '../util/DeclareGlobalVar';
import { GameResPath } from '../util/GameResPath';
import { Mathf } from '../util/Mathf';
import { Runner } from '../util/Runner';
import { TimeUtil } from '../util/TimeUtil';
import { Util } from '../util/Util';
import { BaseItem1 } from './../common/BaseItem1';
export class SeaAssertSSkill extends BaseItem1 {
    Dispose
    Draw
    InitEvent
    StartColdAni
    Update
    setData

    public constructor(parent?) {
        super(parent)

        this.base_file = "seaAssert"
        this.layout_file = "SeaAssertSSkill"
        let cold_time = null
        let skillId = null
        let skillVo = null
        let reset_time = null
        let cold_id = null
        let countdown_time = null
        let runner = Runner.GetInstance()

        this.load_callback = () => {

            if (skillId) {
                this.setData(skillId)
            }
            this.InitEvent()
        }

        this.InitEvent = () => {
            Util.AddClickEvent(
                this.skillBox, () => {
                    console.log("_________________skill")
                    if (reset_time && reset_time > TimeUtil.getClientTime()) {
                        Message.show("技能冷却中")
                        return
                    }
                    if (skillVo) {
                        GlobalEventSystem.Fire(FightEvent.RELEASE_MAIN_SKILL, null, skillId)
                        if (cold_time) {
                            //if (! cold_mask ) {
                            //    cold_mask = Laya. new Shape()
                            //    cold_mask.x = this._img.width / 2 + this._img.x
                            //    cold_mask.y = this._img.height / 2 + this._img.y
                            //    this.addChildAt(cold_mask, 1)
                            //}
                            reset_time = TimeUtil.getClientTime() + cold_time
                            if (!cold_id) {
                                this.StartColdAni()
                            }
                        }
                    }
                },
                this,
                true
            )
        }

        this.Dispose = () => {
            if (cold_id) {
                runner.RemoveRunObj(cold_id)
            }
        }

        this.setData = (skill_id?) => {
            skillId = skill_id
            skillVo = SkillManager.GetInstance().getSkill(skillId)
            if (skillVo) {
                cold_time = skillVo.getCd() / 1000
            }
            let sp_name = "uisdbz_011"
            if (skillId == 510002) {
                sp_name = "uisdbz_010"
            }
            else if (skillId == 510003) {
                sp_name = "uisdbz_012"
            }

            if (this.is_loaded) {
                ResManager.GetInstance().SetImageSpriteTrans(this, this._img, GameResPath.GetIcon("seaAssert", sp_name))
                this._img_mask.visible = false;
            }
        }

        this.StartColdAni = () => {
            if (!cold_id) {
                //cold_mask.visible = true
                this._img_mask.visible = true
                cold_id = runner.AddRunObj(this)
            }
        }

        this.Update = (now_time?, elapse_time?) => {
            if (reset_time < TimeUtil.getClientTime()) {
                //cold_mask.visible = false
                this._img_mask.visible = false
                this._lb_cold.text = ""
                if (cold_id) {
                    runner.RemoveRunObj(cold_id)
                    cold_id = null
                }
            } else {
                this.Draw()
            }
        }

        this.Draw = () => {
            countdown_time = reset_time - TimeUtil.getClientTime()
            this.DrawMaskCircle(countdown_time / cold_time);
            this._lb_cold.text = Mathf.Ceil(countdown_time).toString();
        }
    }

    public DrawMaskCircle(angle) {
        angle = 1 - angle
        let value = 90
        this._img_mask.graphics.clear();
        this._img_mask.graphics.drawPie(0, 0, 36, value, 360 + value - angle * 360, 0x000000)
        this._img_mask.alpha = 0.6;
    }

    public DeleteMe() {
        this.Dispose();
        super.DeleteMe();
    }

    skillBox: Laya.Box
    _img: Laya.Image
    _img_mask: Laya.Image
    _lb_cold: Laya.Label
    public GetComponents() {
        [
            this.skillBox,
            this._img,
            this._img_mask,
            this._lb_cold,
        ]
            = this.GetChildrenByNames([

                "skillBox",
                "_img",
                "_img_mask",
                "_lb_cold",
            ])
    }
}
window["SeaAssertSSkill"] = SeaAssertSSkill
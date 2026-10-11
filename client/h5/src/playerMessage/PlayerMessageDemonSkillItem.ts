import { BaseItem1 } from "../common/BaseItem1";
import { EventName } from "../common/EventName";
import { ResManager } from "../common/ResManager";
import { DemonEvent } from "../commonModel/DemonEvent";
import { DemonModel } from "../commonModel/DemonModel";
import { SkillVo } from "../skill/SkillVo";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { GameResPath } from "../util/GameResPath";
import { Util } from "../util/Util";

export class PlayerMessageDemonSkillItem extends BaseItem1 {
    _Image1: Laya.Image
    _img_icon: Laya.Image
    _img_red: Laya.Image
    _img_tips: Laya.Image


    demon_model
    need_refersh_data
    skill_cfg
    scalex
    scaley
    public constructor(parent?) {
        super(parent)

        this.base_file = "demon"
        this.layout_file = "DemonSkillItem"
        this.demon_model = DemonModel.GetInstance()
        this.need_refersh_data = false
        this.preload_server_config = {
            "config_demons_skill_map" : false
        }
        this.load_callback = () => {
            this.display_obj.scaleX = 0.8
            this.display_obj.scaleY = 0.8
            this.LoadSuccess()
        }
    }

    public LoadSuccess() {
        Util.AddClickEvent(this._img_icon, () => {
            if (this.skill_cfg) {
                GlobalEventSystem.Fire(EventName.OPEN_VIEW, "PlayerMessageDemonSkillTipsView", this.skill_cfg.demons_id, this.skill_cfg.skill_id)
            }
        },this, false)

        this.BindEvent(this.demon_model, DemonEvent.REFRESH_RED_FLAG, (flag?, key?) => {
            if (this.skill_cfg && flag == DemonModel.RedFlag.LifeSkill && this.skill_cfg.demons_id == key) {
                this.UpdateRedState()
            }
        })

        if (this.need_refersh_data) {
            this.need_refersh_data = false
            this.UpdateView()
        }
    }

    public SetData(skill_cfg?,scalex?,scaley?) {
        this.skill_cfg = skill_cfg
        if (this.is_loaded) {
            this.UpdateView()
        } else {
            this.need_refersh_data = true
        }
    }

    public UpdateView() {
        let demons_skill_map_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_demons_skill_map", false)

        let real_skill_id = null
        if (demons_skill_map_cfg) {
            real_skill_id = demons_skill_map_cfg[this.skill_cfg.skill_id] && demons_skill_map_cfg[this.skill_cfg.skill_id].skill_follow
        }
        if (real_skill_id) {
            ResManager.GetInstance().SetTexture(this, this._img_icon, GameResPath.GetSkillIconPath(new SkillVo(real_skill_id).GetIcon()))
        }
        this.UpdateRedState()
    }

    public UpdateRedState() {
        this._img_red.visible = this.demon_model.GetRedFlagState(DemonModel.RedFlag.LifeSkill, this.skill_cfg.demons_id)
    }

    public DeleteMe() {
        this.need_refersh_data = false
        super.DeleteMe()
    }

    public GetComponents() {
        [
            this._Image1,
            this._img_icon,
            this._img_red,
            this._img_tips,
        ]
            = this.GetChildrenByNames([

                "_Image1",
                "_img_icon",
                "_img_red",
                "_img_tips",
            ])
    }
}
window["PlayerMessageDemonSkillItem"] = PlayerMessageDemonSkillItem
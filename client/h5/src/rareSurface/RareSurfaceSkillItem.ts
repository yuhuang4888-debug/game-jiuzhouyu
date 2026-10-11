import { BaseItem1 } from "../common/BaseItem1";
import { ResManager } from "../common/ResManager";
import { OutWardBaseModel } from "../commonModel/OutWardBaseModel";
import { Util } from "../util/Util";

export class RareSurfaceSkillItem extends BaseItem1 {
    need_refresh_data
    skill_id
    public constructor(parent) {
        super(parent);
        this.base_file = 'rareSurface'
        this.layout_file = 'RareSurfaceSkillItem'
        this.need_refresh_data = false
        this.load_callback = () => {
            this.LoadSuccess();
            this.InitEvent();
        }
    }
    private InitEvent = () => {
        Util.AddClickEvent(this._gp_click, () => {
            OutWardBaseModel.GetInstance().Fire(OutWardBaseModel.OPEN_VIEW, "PetSkillView", this.skill_id, 1)
        }, this,true)
    }
    private LoadSuccess = () => {
        if (this.need_refresh_data) {
            this.UpdateView()
            this.need_refresh_data = false
        }
    }
    private UpdateView = () => {
        if(this.skill_id){
            ResManager.GetInstance().SetOutsideImageSprite(this, this._img_skill, "resource/game/skillIcon/" + this.skill_id + ".png")
        }
    }

    public SetData(skill_id) {
        this.skill_id = skill_id
        if (this.is_loaded) {
            this.UpdateView()
        }
        else
            this.need_refresh_data = true
    }
    _gp_click: Laya.Box
    _img_skill: Laya.Image
    public GetComponents() {
        [
            this._gp_click,
            this._img_skill,
        ]
            = this.GetChildrenByNames([

                "_gp_click",
                "_img_skill",
            ])
    }
}
window["RareSurfaceSkillItem"] = RareSurfaceSkillItem
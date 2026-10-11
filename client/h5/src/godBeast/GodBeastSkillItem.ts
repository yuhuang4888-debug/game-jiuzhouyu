import { BaseItem1 } from "../common/BaseItem1";
import { EventName } from "../common/EventName";
import { ResManager } from "../common/ResManager";
import { GodBeastModel } from "../commonModel/GodBeastModel";
import { OutWardBaseModel } from "../commonModel/OutWardBaseModel";
import { TaskFinishView } from "../task/TaskFinishView";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { GameResPath } from "../util/GameResPath";
import { Util } from "../util/Util";

export class GodBeastSkillItem extends BaseItem1 {

    private _model = GodBeastModel.GetInstance();
    private _data;
    needRefresh
    public constructor(parent) {
        super(parent)
        this.base_file = "godBeast"
        this.layout_file = "GodBeastSkillItem"

        this.load_callback = function () {
            this.InitEvent()
        }
    }

    private InitEvent() {
        Util.AddClickEvent(this.con, () => {
            // GlobalEventSystem.Fire(EventName.OPEN_VIEW, "GodBeastSkillView", this._data)
            OutWardBaseModel.GetInstance().Fire(OutWardBaseModel.OPEN_VIEW, "PetSkillView",this._data[0], 0)
        }, this, true)


        if (this.needRefresh){
            this.SetData(this._data)
            this.needRefresh = null
        }
    }

    public SetData(data) {
        this._data = data
        if (this.is_loaded){
            ResManager.GetInstance().SetTexture(this, this._img_skill, GameResPath.GetSkillIconPath(data[0]))
        }else{
            this.needRefresh = true
        }
        
    }

    con: Laya.Box
    _img_skill: Laya.Image
    _Image1: Laya.Image
    public GetComponents() {
        [
            this.con,
            this._img_skill,
            this._Image1,
        ]
            = this.GetChildrenByNames([

                "con",
                "_img_skill",
                "_Image1",
            ])
    }
}
window["GodBeastSkillItem"] = GodBeastSkillItem
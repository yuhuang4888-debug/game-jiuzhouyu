import { AutoFightManager } from "../autofight/AutoFightManager"
import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { Config } from "../common/Config"
import { CustomHeadItem } from "../common/CustomHeadItem"
import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { BossSceneManager } from "../commonController/BossSceneManager"
import { NineSkyModel } from "../commonModel/NineSkyModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Scene } from "../scene/Scene"
import { SceneBaseType } from "../scene/SceneConfig"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"

export class NineSkyResultOwnerItem extends BaseItemRenderer {
    WIDTH = 513
    HEIGT = 42

    model: NineSkyModel
    public constructor() {
        super()
        this.base_file = "nineSky"
        this.layout_file = "NineSkyResultOwnerItem"
        this.model = NineSkyModel.GetInstance()
        this.load_callback = () => {
            this.LoadSuccess()

        }
        this.Load()
    }

    public LoadSuccess() {
        this.InitEvent()
    }

    public InitEvent() {
    }

    protected dataChanged() {
        if (!super.dataChanged()) return

        let data = this.data
        let str = `顶层秘宝${data.index}`
        this._lb_reward_name.text = str
        
        if (this.model.server_type > 1) {
            str = `s${data.server_num}.${data.role_name}`
        }
        else {
            str = data.role_name
        }
        this._lb_role_name.text = str
    }

    public DeleteMe() {
        super.DeleteMe()
    }


    _img_bg: Laya.Image
    _lb_reward_name: Laya.Label
    _lb_role_name: Laya.Label
    public GetComponents() {
        [
            this._img_bg,
            this._lb_reward_name,
            this._lb_role_name,
        ]
            = this.GetChildrenByNames([

                "_img_bg",
                "_lb_reward_name",
                "_lb_role_name",
            ])
    }
}
window["NineSkyResultOwnerItem"] = NineSkyResultOwnerItem
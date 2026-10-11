import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { KfHolyAreaModel } from "../commonModel/KfHolyAreaModel"
export class KfHolyAreaSceneDamageItem extends BaseItemRenderer {
    _Image1: Laya.Image
    _lb_role_name: Laya.Label
    _lb_role_damage: Laya.Label
    model

    public static width = 220
    public static height = 25
    WIDTH = 220
    HEIGT = 25
    public constructor(parent) {
        super()

        this.base_file = "kfHolyArea"
        this.layout_file = "KfHolyAreaSceneDamageItem"
        this.model = KfHolyAreaModel.GetInstance()
        this.Load()
    }

    public load_callback() {


    }

    public dataChanged() {
        if (super.dataChanged()) {
            if (this.model.IsCampMode()) {
                this._lb_role_name.text = this.model.GetCampName(this.model.GetCampByServerId(this.data.server_id)) + " " + this.data.player_name
            } else {
                this._lb_role_name.text = "s" + this.data.server_num + " " + this.data.player_name
            }
            this._lb_role_damage.text = this.data.modulus + "%"
        }
    }

    public GetComponents() {
        [
            this._Image1,
            this._lb_role_name,
            this._lb_role_damage,
        ]
            = this.GetChildrenByNames([

                "_Image1",
                "_lb_role_name",
                "_lb_role_damage",
            ])
    }
}
window["KfHolyAreaSceneDamageItem"] = KfHolyAreaSceneDamageItem
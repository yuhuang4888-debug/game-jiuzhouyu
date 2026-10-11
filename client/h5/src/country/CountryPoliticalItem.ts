import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { RoleManager } from "../commonModel/RoleManager"
import { SeaHegemonyModel } from "../commonModel/SeaHegemonyModel"
import { Mathf } from "../util/Mathf"
import { RefBoxChildsLayout, SetLocalPosition, SetLocalPositionX } from "../util/Util"

export class CountryPoliticalItem extends BaseItemRenderer {
    roleId
    public WIDTH: number = 642
    public HEIGT: number = 55

    public constructor(parent) {
        super()

        this.base_file = "country"
        this.layout_file = "CountryPoliticalItem"
        this.load_callback = () => {
        }

        this.roleId = RoleManager.GetInstance().GetMainRoleId()
        this.Load()
    }

    public dataChanged() {
        if (!super.dataChanged()) return
        this.vipImg.visible = false
        // ResManager.GetInstance().SetImageSprite(this, this.vipImg, "mainUI_asset", "uivip_zjm_" + this.data.vip)
        this.nameLb.text = this.data.role_name
        this.lvLb.text = (this.data.lv > 370 && (this.data.lv - 370 + "级") || (this.data.lv + "级"))
        this.lvImg.visible = this.data.lv > 370
        this.posLb.text = SeaHegemonyModel.GetInstance().GetPositionName(this.data.job_id)
        this.exploitLb.text = this.data.exploit > 10000 ? Mathf.Round(this.data.exploit / 10000) + "w" : this.data.exploit + ""
        let fight_num= Number(this.data.fight )
        this.fightLb.text = fight_num > 10000 ? Mathf.Round(fight_num / 10000) + "w" : fight_num + ""
        this.guildLb.text = this.data.guild_name

        let sp_name = SeaHegemonyModel.GetInstance().GetItemBg(this.roleId == this.data.role_id)
        ResManager.GetInstance().SetOutsideImageSprite(this, this.bg,sp_name)

        // RefBoxChildsLayout(this._box_name, 2, null, true, "left")
        RefBoxChildsLayout(this._box_name, 2, null, true, "center")
        RefBoxChildsLayout(this._box_lv, 2)
    }

    public DeleteMe(): void {
        super.DeleteMe()
    }


    bg: Laya.Image
    posLb: Laya.Label
    exploitLb: Laya.Label
    fightLb: Laya.Label
    guildLb: Laya.Label
    _box_name: Laya.Box
    nameLb: Laya.Label
    vipImg: Laya.Image
    _box_lv: Laya.Box
    lvImg: Laya.Image
    lvLb: Laya.Label
    public GetComponents() {
        [
            this.bg,
            this.posLb,
            this.exploitLb,
            this.fightLb,
            this.guildLb,
            this._box_name,
            this.nameLb,
            this.vipImg,
            this._box_lv,
            this.lvImg,
            this.lvLb,
        ]
            = this.GetChildrenByNames([

                "bg",
                "posLb",
                "exploitLb",
                "fightLb",
                "guildLb",
                "_box_name",
                "nameLb",
                "vipImg",
                "_box_lv",
                "lvImg",
                "lvLb",
            ])
    }
}
window["CountryPoliticalItem"] = CountryPoliticalItem
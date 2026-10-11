import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { RoleManager } from "../commonModel/RoleManager"
import { SeaHegemonyModel } from "../commonModel/SeaHegemonyModel"

export class SeaGuildListItem extends BaseItemRenderer {

    public WIDTH: number = 580
    public HEIGT: number = 59

    public constructor(parent) {
        super()

        this.base_file = "seaHegemony"
        this.layout_file = "SeaGuildListItem"
        this.load_callback = () => {

        }
        this.Load()
    }

    public dataChanged() {
        if (!super.dataChanged()) return
        let rank = this.data.rank
        if (rank <= 3) {
            this.rankImg.visible = true
            this.rankLb.visible = false
            let sp_name = "rank" +rank
            ResManager.GetInstance().SetImageSprite(this, this.rankImg, "seaHegemony", sp_name, true)
        } else {
            this.rankImg.visible = false
            this.rankLb.visible = true
            this.rankLb.text = rank
        }
        this.guildLb.text = this.data.guild_name
        this.nameLb.text = "S" + this.data.server_num + "." + this.data.role_name
        this.fightLb.text = this.data.guild_power + ""

        let sp_name = SeaHegemonyModel.GetInstance().GetItemBg(RoleManager.GetInstance().GetMainRoleVo().guild_id == this.data.guild_id)
        ResManager.GetInstance().SetOutsideImageSprite(this, this.bg, sp_name)

    }

    public DeleteMe(): void {
        super.DeleteMe()
    }
    bg: Laya.Image
    rankImg: Laya.Image
    rankLb: Laya.Label
    guildLb: Laya.Label
    nameLb: Laya.Label
    fightLb: Laya.Label
    public GetComponents() {
        [
            this.bg,
            this.rankImg,
            this.rankLb,
            this.guildLb,
            this.nameLb,
            this.fightLb,
        ]
            = this.GetChildrenByNames([

                "bg",
                "rankImg",
                "rankLb",
                "guildLb",
                "nameLb",
                "fightLb",
            ])
    }
}
window["SeaGuildListItem"] = SeaGuildListItem
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { RoleManager } from "../commonModel/RoleManager"
import { SeaHegemonyModel } from "../commonModel/SeaHegemonyModel"
import { GameResPath } from "../util/GameResPath"

export class SeaFightTotalItem extends BaseItemRenderer {

    public WIDTH: number = 585
    public HEIGT: number = 41

    public constructor(parent) {
        super()

        this.base_file = "seaHegemony"
        this.layout_file = "SeaFightTotalItem"

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
            let sp_name = `rank${rank}`
            ResManager.GetInstance().SetImageSprite(this, this.rankImg, "seaHegemony", sp_name, true)
        } else {
            this.rankImg.visible = false
            this.rankLb.visible = true
            this.rankLb.text = rank
        }
        this.nameLb.text = this.data.role_name
        this.killLb.text = this.data.kill_score+""
        this.scoreLb.text = this.data.score+""
        
        let role_id = RoleManager.GetInstance().GetMainRoleId()
        ResManager.GetInstance().SetOutsideImageSprite(this, this.bg, this.GetItemBg(role_id == this.data.role_id))
    }

    public DeleteMe(): void {
        super.DeleteMe()
    }

	public GetItemBg = (boo) => {
        let sp_name=boo?"ui_kdb_11":"uitc_035"
        return GameResPath.GetIconOtherPath("seaHegemony", sp_name)
    }

bg:Laya.Image
rankImg:Laya.Image
rankLb:Laya.Label
nameLb:Laya.Label
killLb:Laya.Label
scoreLb:Laya.Label
public GetComponents() {
[
this.bg,
this.rankImg,
this.rankLb,
this.nameLb,
this.killLb,
this.scoreLb,
]
 = this.GetChildrenByNames([

"bg",
"rankImg",
"rankLb",
"nameLb",
"killLb",
"scoreLb",
])
}
}
 window["SeaFightTotalItem"]= SeaFightTotalItem
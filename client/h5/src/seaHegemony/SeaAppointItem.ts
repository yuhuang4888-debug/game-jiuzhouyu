import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { RoleManager } from "../commonModel/RoleManager"
import { SeaHegemonyModel } from "../commonModel/SeaHegemonyModel"
import { Util } from "../util/Util"

export class SeaAppointItem extends BaseItemRenderer {

    public WIDTH: number = 441
    public HEIGT: number = 60
    model
    public constructor(parent) {
        super()

        this.base_file = "seaHegemony"
        this.layout_file = "SeaAppointItem"

        this.model = SeaHegemonyModel.GetInstance()

        this.load_callback = () => {

            this.InitEvent()
        }
        this.Load()
    }

    public InitEvent() {

        this.BindEvent(
            this.model,
            SeaHegemonyModel.SELECT_POSITION, () => {
                this.dataChanged()
            }
        )
        Util.AddClickEvent(
            this.btnGp, () => {
                if (this.model.SelectPositon(this.data, !this.selectImg.visible)) {
                    this.selectImg.visible = true
                    this.unSelectImg.visible = false
                } else {
                    this.selectImg.visible = false
                    this.unSelectImg.visible = true
                }
            },
            this,
            true
        )
    }

    public dataChanged() {
        if (!super.dataChanged()) return
        if(this.data==undefined)return
        this.nameLb.text = "S" + this.data.server_num + "." + this.data.role_name
        this.positionLb.text = this.model.GetPositionName(this.data.self_level)
        // [ts2lua]this.model.selectInfo下标访问可能不正确
        let info = this.model.selectInfo[this.model.selectingPosition]
        let select = false
        if (info) {
            for (let _tmpi in info.people) {
                var vo = info.people[_tmpi]
                if (vo == this.data.role_id) {
                    select = true
                    break
                }
            }
        }
        let role_id = RoleManager.GetInstance().GetMainRoleId()
        let sp_name = SeaHegemonyModel.GetInstance().GetItemBg(role_id == this.data.role_id)
        ResManager.GetInstance().SetOutsideImageSprite(this, this.bg, sp_name)

        this.selectImg.visible = select
        this.unSelectImg.visible = !select
    }

    public DeleteMe(): void {
        super.DeleteMe()
    }



    bg: Laya.Image
    nameLb: Laya.Label
    positionLb: Laya.Label
    btnGp: Laya.Box
    selectImg: Laya.Image
    unSelectImg: Laya.Image
    public GetComponents() {
        [
            this.bg,
            this.nameLb,
            this.positionLb,
            this.btnGp,
            this.selectImg,
            this.unSelectImg,
        ]
            = this.GetChildrenByNames([

                "bg",
                "nameLb",
                "positionLb",
                "btnGp",
                "selectImg",
                "unSelectImg",
            ])
    }
}
window["SeaAppointItem"] = SeaAppointItem
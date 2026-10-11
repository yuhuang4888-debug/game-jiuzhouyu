import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { RankModel, RankModelEvent } from "../commonModel/RankModel"
import { RoleManager } from "../commonModel/RoleManager"
import { SeaHegemonyModel } from "../commonModel/SeaHegemonyModel"
import { RefBoxChildsLayout } from "../util/Util"

export class SoldierArrItem extends BaseItemRenderer {

    public WIDTH: number = 666
    public HEIGT: number = 41
    model


    public constructor(parent) {
        super()

        this.base_file = "seaHegemony"
        this.layout_file = "SoldierArrItem"

        this.model = SeaHegemonyModel.GetInstance()
        this.load_callback = () => {

            this.InitEvent()
            //this:UpdateView()
        }
        this.Load()
    }

    public InitEvent() {

        //this.id = this.addEventListener(Laya.TouchEvent.TOUCH_TAP, this.touchHandler, this)
    }

    public touchHandler(e?) {

        if (this.data && this.data.role_id != RoleManager.GetInstance().GetMainRoleId()) {
            let point = { x: e.stageX, y: e.stageY }
            // [ts2lua]lua中0和空字符串也是true，此处this.model.isSeaKing需要确认
            RankModel.GetInstance().Fire(RankModelEvent.OPEN_MENU_VIEW, point, this.data.role_id, this.data.server_id, (this.model.isSeaKing && (1) || (null)))
            //e:stopImmediatePropagation()
        }
    }

    public dataChanged() {
        if (!super.dataChanged()) return
        let role_id = RoleManager.GetInstance().GetMainRoleId()
        let sp_name = SeaHegemonyModel.GetInstance().GetItemBg(role_id == this.data.role_id)
        ResManager.GetInstance().SetOutsideImageSprite(this, this.bg, sp_name)

        this.nameLb.text = "S" + this.data.server_num + "." + this.data.role_name
        let lv = this.data.role_lv
        if (lv > 370) {
            this.lvLb.text = lv - 370 + "级"
            this.lvImg.visible = true
            //this.lvLb.x = 261
        } else {
            this.lvLb.text = "Lv." + lv
            this.lvImg.visible = false
            //this.lvLb.x = 239
        }
        this.positionLb.text = this.model.GetPositionName(this.data.self_level)
        this.fightLb.text = this.data.power
        RefBoxChildsLayout(this._box_lv,2)
    }

    public DeleteMe() {

        super.DeleteMe()
    }


bg:Laya.Image
nameLb:Laya.Label
_box_lv:Laya.Box
lvImg:Laya.Image
lvLb:Laya.Label
positionLb:Laya.Label
fightLb:Laya.Label
public GetComponents() {
[
this.bg,
this.nameLb,
this._box_lv,
this.lvImg,
this.lvLb,
this.positionLb,
this.fightLb,
]
 = this.GetChildrenByNames([

"bg",
"nameLb",
"_box_lv",
"lvImg",
"lvLb",
"positionLb",
"fightLb",
])
}
}
 window["SoldierArrItem"]= SoldierArrItem
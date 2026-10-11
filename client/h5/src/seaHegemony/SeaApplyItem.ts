import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { CustomHeadItem } from "../common/CustomHeadItem"
import { SeaHegemonyModel } from "../commonModel/SeaHegemonyModel"
import { TransformLevel, Util } from "../util/Util"

export class SeaApplyItem extends BaseItemRenderer {

    public WIDTH: number = 553
    public HEIGT: number = 104

    onClickPass
    onClickRefuse
    role_head:CustomHeadItem
    model
    public constructor(parent) {
        super()

        this.base_file = "seaHegemony"
        this.layout_file = "SeaApplyItem"
        this.load_callback = () => {


            Util.AddClickEvent(this._btn_pass, () => {
                this.onClickPass()
            }, this, true)
            Util.AddClickEvent(this._btn_refuse, () => {
                this.onClickRefuse()
            }, this, true)
        }

        this.model = SeaHegemonyModel.GetInstance()
        this.onClickPass = () => {
            this.model.Fire(SeaHegemonyModel.REQUEST_PROTO, 18605, "cl", 1, this.data.role_id)
        }
        this.onClickRefuse = () => {
            this.model.Fire(SeaHegemonyModel.REQUEST_PROTO, 18605, "cl", 0, this.data.role_id)
        }

        this.Load()
    }

    public dataChanged() {
        if (!super.dataChanged()) return
        let data = this.data
        // [ts2lua]lua中0和空字符串也是true，此处data.role_lv > 370需要确认
        this._lb_name.text = `${data.role_name}  ${TransformLevel(data.role_lv)}级`
        this._lb_fight.text = data.power+""
        if (!this.role_head) {
            this.role_head = new CustomHeadItem(this._playerHead)
            this.role_head.SetActiveLevel(false)
            this.role_head.SetActiveBg2(false)
            this.role_head.Load()
        }
        this.role_head.SetRoleVoData(data)

    }

    public DeleteMe() {

        if (this.role_head) {
            this.role_head.DeleteMe()
            this.role_head = null
        }
        super.DeleteMe()
    }

    _Image1: Laya.Image
    _playerHead: Laya.Box
    _Label1: Laya.Label
    _lb_fight: Laya.Label
    _lb_name: Laya.Label
    _btn_pass: Laya.Image
    _btn_refuse: Laya.Image
    public GetComponents() {
        [
            this._Image1,
            this._playerHead,
            this._Label1,
            this._lb_fight,
            this._lb_name,
            this._btn_pass,
            this._btn_refuse,
        ]
            = this.GetChildrenByNames([

                "_Image1",
                "_playerHead",
                "_Label1",
                "_lb_fight",
                "_lb_name",
                "_btn_pass",
                "_btn_refuse",
            ])
    }
}
window["SeaApplyItem"] = SeaApplyItem
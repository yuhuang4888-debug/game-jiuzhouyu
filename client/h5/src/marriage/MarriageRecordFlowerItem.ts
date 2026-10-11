import { BaseItemRenderer } from "../common/BaseItemRenderer";
import { EventName } from "../common/EventName";
import { ResManager } from "../common/ResManager";
import { GoodsModel } from "../commonModel/GoodsModel";
import { MarriageEvent, MarriageModel } from "../commonModel/MarriageModel";
import { RoleManager } from "../commonModel/RoleManager";
import { Message } from "../sysInfo/SysInfoController";
import { Enum_ColorUtil_Light } from "../util/ColorUtil";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { GameResPath } from "../util/GameResPath";
import { TimeUtil } from "../util/TimeUtil";
import { Util } from "../util/Util";

export class MarriageRecordFlowerItem extends BaseItemRenderer {
    public WIDTH = 497
    public HEIGT = 93

    private _model: MarriageModel;

    private is_gift = false
    private module_id = 22302
    public constructor() {
        super()
        this.base_file = "marriage"
        this.layout_file = "MarriageRecordFlowerItem"
        this._model = MarriageModel.GetInstance()
        this.Load()
    }

    public load_callback() {
        ResManager.GetInstance().SetOutsideImageSprite(this, this._img_080, GameResPath.GetIcon("marriage", "uijh_080"))

        Util.AddClickEvent(this._btn_thank, () => {
            if (this.data.is_thanks == 1) { Message.show("已感谢"); return; }
            this._model.Fire(MarriageEvent.REQUEST_PROTO, 22305, "l", this.data.id)
            this._model.ThanksToChat(this.data.sender_id)
        }, this, true)

        Util.AddClickEvent(this._btn_gift, () => {
            if (this.data) {
                this.is_gift = true
                GlobalEventSystem.Fire(EventName.REQUEST_ROLE_PROTO, 13013, "hlh", this.data.server_id, this.data.sender_id, this.module_id)
            }
            // let vo = { "role_id": this.data.sender_id, "name": this.data.sender_name }
            // GlobalEventSystem.Fire(EventName.OPEN_VIEW, "MarriageFlowerView", vo)
        }, this, true)

        let figure_fun = (scmd) => {
            let info = this.data
            if (info && info.server_id == scmd.server_id
                && info.sender_id == scmd.player_id
                && this.module_id == scmd.module_id
                && this.is_gift) {
                this.is_gift = false
                GlobalEventSystem.Fire(EventName.OPEN_VIEW, "MarriageFlowerView", scmd)
            }
        }
        this.BindEvent(GlobalEventSystem, EventName.GET_ROLE_FIGURE_INFO_RETURN, figure_fun)

        this.BindEvent(this._model, MarriageEvent.THANKS_FLOWER, (scmd) => {
            if (!this.data || !scmd || scmd.id != this.data.id) return
            this.data.is_thanks = 1
            Util.SetImageGray(this._btn_thank, this.data.is_thanks == 1)
        })
    }

    protected dataChanged() {
        if (!super.dataChanged()) return
        let data = this.data
        let date = TimeUtil.timeConversion(data.time, "MDHM")
        let name = Util.HtmlColorTxt(`S${data.server_num}.${data.sender_name}`, "'#883e43'")
        let goods = Util.HtmlColorTxt(GoodsModel.GetGoodsName(data.goods_id), Enum_ColorUtil_Light.BLUE)
        this._lb_content.style.color = "#ef8d9f"
        this._lb_content.style.fontSize = 20
        this._lb_content.style.valign = "middle"
        this._lb_content.style.align = "left"
        this._lb_content.x = 25
        this._lb_content.y = 12
        this._lb_content.width = 300
        this._lb_content.height = 70
        this._lb_content.style.leading = 10
        this._lb_content.innerHTML = Util.StrToHTML(`${date},收到${name}赠送${goods}x${data.goods_num}`)
        this._lb_content.style.padding = [(this._lb_content.height - this._lb_content.contextHeight) / 2, 0, 0, 0]
        let role = RoleManager.GetInstance().mainRoleInfo
        let bool = role.server_unique_id == data.server_id
        this._btn_thank.visible = bool
        if (bool)
            Util.SetImageGray(this._btn_thank, data.is_thanks == 1)
    }

    _img_080: Laya.Image
    _btn_thank: Laya.Image
    _btn_gift: Laya.Image
    _lb_content: Laya.HTMLDivElement
    public GetComponents() {
        [
            this._img_080,
            this._btn_thank,
            this._btn_gift,
            this._lb_content,
        ]
            = this.GetChildrenByNames([

                "_img_080",
                "_btn_thank",
                "_btn_gift",
                "_lb_content",
            ])
    }
}
window["MarriageRecordFlowerItem"] = MarriageRecordFlowerItem
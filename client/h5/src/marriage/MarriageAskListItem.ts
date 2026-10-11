import { BaseItemRenderer } from "../common/BaseItemRenderer";
import { CustomHeadItem } from "../common/CustomHeadItem";
import { EventName } from "../common/EventName";
import { ResManager } from "../common/ResManager";
import { DressModel, DressType } from "../commonModel/DressModel";
import { MarriageModel, MarriageStateCfg } from "../commonModel/MarriageModel";
import { Message } from "../sysInfo/SysInfoController";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { AtlasUrl, Util } from "../util/Util";

export class MarriageAskListItem extends BaseItemRenderer {
    public WIDTH = 490
    public HEIGT = 104

    private _head: CustomHeadItem;

    private _model: MarriageModel;
    public constructor() {
        super()
        this.base_file = "marriage"
        this.layout_file = "MarriageAskListItem"
        this._model = MarriageModel.GetInstance()
        this.Load()


    }

    public DeleteMe() {
        if (this._head) {
            this._head.DeleteMe()
            this._head = undefined
        }
        super.DeleteMe()
    }


    public load_callback() {
        this._head = new CustomHeadItem(this._head_con)
        this._head.Load()

        ResManager.GetInstance().SetImageSprite(this.base_item, this._img_034,"marriage","uijh_034")

        Util.AddClickEvent(this._btn_ask, () => {
            if(!this.data) return
            let need_intimacy = this._model.GetConstantData(9)
            if (this.data.intimacy < need_intimacy) {
                Message.show(`需要520亲密度才可发起求婚`)
                return
            }
            GlobalEventSystem.Fire(EventName.OPEN_VIEW, "MarriageAskView", this.data)
        }, this, true)
    }

    protected dataChanged() {
        if (!super.dataChanged()) return
        let data = this.data
        this._lb_name.text = data.role_name
        this._lb_intimacy.text = data.intimacy
        let frame_id = DressModel.GetInstance().GetDressByType(data.dress_list, DressType.Photo)
        // this._head.setData(data.lv || data.level, data.career, data.picture, undefined, undefined, frame_id)
        this._head.SetRoleVoData(data)


        let state = undefined
        if (data.is_marriage == 2) {
            state = MarriageStateCfg.Married
        } else if (data.is_marriage == 0) {
            state = MarriageStateCfg.Single
        }
        this._img_state.skin = AtlasUrl("marriage", state ? `${state.pic}` : "")
    }

    _img_034: Laya.Image
    _head_con: Laya.Box
    _img_state: Laya.Image
    _Group1: Laya.HBox
    _lb_name: Laya.Label
    _Group2: Laya.HBox
    _Image1: Laya.Image
    _Label1: Laya.Label
    _lb_intimacy: Laya.Label
    _btn_ask: Laya.Image
    public GetComponents() {
        [
            this._img_034,
            this._head_con,
            this._img_state,
            this._Group1,
            this._lb_name,
            this._Group2,
            this._Image1,
            this._Label1,
            this._lb_intimacy,
            this._btn_ask,
        ]
            = this.GetChildrenByNames([

                "_img_034",
                "_head_con",
                "_img_state",
                "_Group1",
                "_lb_name",
                "_Group2",
                "_Image1",
                "_Label1",
                "_lb_intimacy",
                "_btn_ask",
            ])
    }
}
window["MarriageAskListItem"] = MarriageAskListItem
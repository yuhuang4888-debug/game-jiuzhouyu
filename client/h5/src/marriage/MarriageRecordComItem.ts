import { BaseItemRenderer } from "../common/BaseItemRenderer";
import { CustomHeadItem } from "../common/CustomHeadItem";
import { EventName } from "../common/EventName";
// import { PlayerHead } from "../common/PlayerHead";
import { ResManager } from "../common/ResManager";
import { DressModel, DressType } from "../commonModel/DressModel";
import { FriendModel } from "../commonModel/FriendModel";
import { MarriageEvent, MarriageModel, MarriageStateCfg } from "../commonModel/MarriageModel";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { AtlasUrl, Util } from "../util/Util";

export class MarriageRecordComItem extends BaseItemRenderer {
    public WIDTH = 564
    public HEIGT = 100

    private _head: CustomHeadItem;

    private _model: MarriageModel;
    private _event_1;
    private _event_2;

    public constructor() {
        super()
        this.base_file = "marriage"
        this.layout_file = "MarriageRecordComItem"
        this._model = MarriageModel.GetInstance()
        this.Load()
 
    }

    public load_callback() {
        this._head = new CustomHeadItem(this._head_con)
        this._head.Load()
        ResManager.GetInstance().SetImageSprite(this.base_item, this._img_034,"marriage","uijh_034")

        Util.AddClickEvent(this._btn_flower, () => {
            GlobalEventSystem.Fire(EventName.OPEN_VIEW, "MarriageFlowerView", this.data)
        }, this, true)

        Util.AddClickEvent(this._btn_menu, (evt: Laya.Event) => {
            let pos = this._btn_menu.localToGlobal(new Laya.Point(0, 70))
            evt.stopPropagation()
            GlobalEventSystem.Fire(EventName.OPEN_VIEW, "MarriageRoleMenuView", this.data, pos)
        }, this, true)

        this._event_1 = this._model.Bind(MarriageEvent.GIVE_GIFT_SUCCESS, (scmd) => {
            if (!this.data) return
            if (this.data.role_id != scmd.receive_id) return
            let fri_vo = FriendModel.GetInstance().getFriendById(scmd.receive_id)
            if (fri_vo) {
                this.data.intimacy = fri_vo.intimacy
                this._lb_intimacy.text = fri_vo.intimacy.toString()
            }
        })

        this._event_2 = this._model.Bind(MarriageEvent.GET_FLOWER, (scmd) => {
            if (!this.data) return
            if (this.data.role_id != scmd.role_id) return
            let fri_vo = FriendModel.GetInstance().getFriendById(scmd.role_id)
            if (fri_vo) {
                this.data.intimacy = fri_vo.intimacy
                this._lb_intimacy.text = fri_vo.intimacy.toString()
            }
        })
    }

    public DeleteMe() {
        if (this._head) {
            this._head.DeleteMe()
            this._head = undefined
        }
        if (this._event_1) {
            this._model.UnBind(this._event_1)
            this._event_1 = undefined
        }
        if (this._event_2) {
            this._model.UnBind(this._event_2)
            this._event_2 = undefined
        }
        super.DeleteMe()
    }

    protected dataChanged() {
        if (!super.dataChanged()) return
        let data = this.data
        this._lb_name.text = data.name
        this._lb_intimacy.text = data.intimacy
        let frame_id = DressModel.GetInstance().GetDressByType(data.dress_list, DressType.Photo)
        this._head.SetRoleVoData(data)
        // this._head.etData(data.lv || data.level, data.career, data.picture, undefined, undefined, frame_id)
        this._img_outline.visible = !data.if_online

        let state = undefined
        if (data.if_marriage == 2) {
            state = MarriageStateCfg.Married
        } else if (data.if_marriage == 0) {
            state = MarriageStateCfg.Single
        }
        this._img_state.skin = AtlasUrl("marriage", state ? `${state.pic}` : "") 
    }

    _img_034: Laya.Image
    _head_con: Laya.Box
    _img_state: Laya.Image
    _Group1: Laya.HBox
    _lb_name: Laya.Label
    _img_outline: Laya.Image
    _Group2: Laya.HBox
    _Image1: Laya.Image
    _Label1: Laya.Label
    _lb_intimacy: Laya.Label
    _btn_flower: Laya.Image
    _btn_menu: Laya.Image
    public GetComponents() {
        [
            this._img_034,
            this._head_con,
            this._img_state,
            this._Group1,
            this._lb_name,
            this._img_outline,
            this._Group2,
            this._Image1,
            this._Label1,
            this._lb_intimacy,
            this._btn_flower,
            this._btn_menu,
        ]
            = this.GetChildrenByNames([

                "_img_034",
                "_head_con",
                "_img_state",
                "_Group1",
                "_lb_name",
                "_img_outline",
                "_Group2",
                "_Image1",
                "_Label1",
                "_lb_intimacy",
                "_btn_flower",
                "_btn_menu",
            ])
    }
}
window["MarriageRecordComItem"] = MarriageRecordComItem
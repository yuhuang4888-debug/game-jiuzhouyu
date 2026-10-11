import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { GoodsModel } from "../commonModel/GoodsModel"
import { SeaHegemonyModel } from "../commonModel/SeaHegemonyModel"
import { Enum_ColorUtil_Dark } from "../util/ColorUtil"
import { GameResPath } from "../util/GameResPath"
import { Mathf } from "../util/Mathf"
import { HtmlColorTxt, Util } from "../util/Util"

export class SeaAssertRewardItem extends BaseItemRenderer {
    _model
    reward_list

    WIDTH = 613
    HEIGT = 136

    public constructor() {
        super()

        this.reward_list = []
        this.base_file = "seaAssert"
        this.layout_file = "SeaAssertRewardItem"
        this._model = SeaHegemonyModel.GetInstance()

        this.load_callback = () => {
            ResManager.GetInstance().SetOutsideImageSprite(this, this._Image11, GameResPath.GetIconOtherPath("tsCrack", "uisksh_108"))
            this.InitEvent()
        }

        this.Load();
    }

    public InitEvent() {
        this._lb_desc.style.fontSize = 18
        this._lb_desc.style.color = "#ffffff"
        this._lb_desc.style.wordWrap = false
        Util.AddClickEvent(
            this._btn_get, () => {
                this._model.Fire(SeaHegemonyModel.REQUEST_PROTO, 18713, "c", this.data.id)
            },
            this,
            true
        )
    }

    public DeleteMe() {
        for (let key in this.reward_list) {
            // [ts2lua]this.reward_list下标访问可能不正确
            let item = this.reward_list[key]
            item.DeleteMe()
        }
        this.reward_list = [];

        super.DeleteMe;
    }

    public dataChanged() {
        if (super.dataChanged()) {
            if (!this.data) {
                return
            }

            if (this.reward_list) {
                for (let _ in this.reward_list) {
                    var item = this.reward_list[_]
                    item.SetVisible(false)
                }
            }

            let list = JSON.parse(this.data.reward)
            let index = 0
            for (let key in list) {

                // [ts2lua]list下标访问可能不正确
                let reward = list[key]
                // [ts2lua]this.reward_list下标访问可能不正确
                let item: BaseAwardItem = this.reward_list[index]
                if (!item) {
                    item = new BaseAwardItem(this._gp_reward)
                    item.Load()
                    item.SetScale(0.6)
                    table.insert(this.reward_list, item)
                }
                item.SetVisible(true)
                let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(reward[0], reward[1])
                let goods_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
                if (goods_vo) {
                    item.SetData(type_id, reward[2])
                }
                index = index + 1
            }

            this._lb_null.visible = true;
            this._btn_get.visible = false;
            this._lb_full.visible = false;
            let task_data = this.data.task_data;
            if (task_data) {
                this._lb_null.visible = task_data.status == 0
                this._btn_get.visible = task_data.status == 1
                this._lb_full.visible = task_data.status == 2
            }
            // [ts2lua]lua中0和空字符串也是true，此处not task_data需要确认
            let count = task_data ? task_data.count : 0;
            this._lb_desc.innerHTML = Util.StrToHTML(this.data.name + HtmlColorTxt("(" + Mathf.Min(count, this.data.count) + "/" + this.data.count + ")", "'#fff1b9'") + " ")
        }

    }

    _Image11: Laya.Image
    _lb_desc: Laya.HTMLDivElement
    _Scroller1: Laya.Box
    _gp_reward: Laya.HBox
    _lb_null: Laya.Label
    _btn_get: Laya.Box
    _Image1: Laya.Image
    labelDisplay: Laya.Label
    _lb_full: Laya.Image
    public GetComponents() {
        [
            this._Image11,
            this._lb_desc,
            this._Scroller1,
            this._gp_reward,
            this._lb_null,
            this._btn_get,
            this._Image1,
            this.labelDisplay,
            this._lb_full,
        ]
            = this.GetChildrenByNames([

                "_Image11",
                "_lb_desc",
                "_Scroller1",
                "_gp_reward",
                "_lb_null",
                "_btn_get",
                "_Image1",
                "labelDisplay",
                "_lb_full",
            ])
    }
}
window["SeaAssertRewardItem"] = SeaAssertRewardItem
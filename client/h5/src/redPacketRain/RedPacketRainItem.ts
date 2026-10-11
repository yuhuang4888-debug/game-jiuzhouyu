import { BaseItem1 } from "../common/BaseItem1";
import { EquipmentItem } from "../common/EquipmentItem";
import { EventName } from "../common/EventName";
import { ResManager } from "../common/ResManager";
import { CustomActivityModel } from "../commonModel/CustomActivityModel";
import { GoodsModel } from "../commonModel/GoodsModel";
import { Enum_ColorUtil_Dark } from "../util/ColorUtil";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { TimeUtil } from "../util/TimeUtil";
import { GlobalTimerQuest, Util } from "../util/Util";

export class RedPacketRainItem extends BaseItem1 {
    click_gp: Laya.Box
    _Image1: Laya.Image
    _img_rpr: Laya.Image
    _lb_tips: Laya.Label
    _gp_item: Laya.Box
    _gp_end: Laya.Box
    _Image2: Laya.Image
    _Image3: Laya.Image

    private _model: CustomActivityModel;
    private _timer
    private _data;
    private _item: EquipmentItem;

    RPRDeleteMe
    InitEvent
    LoadSuccess
    SetData
    UpdateItemState
    StartTimer
    UpdateTimer
    ClearTimer
    UpdateItem
    GetGoodsTypeByKey

    public constructor(parent) {
        super(parent)
        this.base_file = "redPacketRain"
        this.layout_file = "RedPacketRainItem"
        this._model = CustomActivityModel.GetInstance()
        this.load_callback = function () {
            this.InitEvent()
            this.LoadSuccess()
        }

        this.InitEvent = () => {
            Util.AddClickEvent(this.click_gp, () => {
                if (!this._data) return
                if (this._data.goods_vo) return
                let vo = this._data.show_vo
                let type = this.GetGoodsTypeByKey(vo[1])
                let data = [type, 0, vo[2]]
                GlobalEventSystem.Fire(EventName.OPEN_VIEW, "RewardPreView", [data])
            }, this, true)
        }

        this.RPRDeleteMe = () => {
            if (this._item) {
                this._item.DeleteMe()
                this._item = undefined
            }
            this.ClearTimer()
            super.DeleteMe();
        }

        this.LoadSuccess = () => {
        }

        this.SetData = (data) => {
            this._data = data
            ResManager.GetInstance().SetImageSprite(this, this._img_rpr, "redPacketRain", `rpr_0${data.wave}`)
            this._lb_tips.color = "#fe1a1a"
            this._gp_item.visible = false
            this._gp_end.visible = false
            this._img_rpr.visible = true

            if (data.status == 1 || data.status == 4) {
                this._lb_tips.text = `第${data.wave}波红包`
                this._gp_end.visible = !data.goods_vo && data.status == 1
                this.UpdateItemState(data.goods_vo)
            } else if (data.status == 2) {
                this._lb_tips.color = "#0a953e"
                this._lb_tips.text = data.goods_vo ? `第${data.wave}波红包` : `正在开抢中`
                this.UpdateItemState(data.goods_vo)
            } else if (data.status == 3) {
                this.StartTimer()
                this.UpdateTimer()
            }
        }

        this.UpdateItemState = (goods_vo) => {
            this._img_rpr.visible = !goods_vo
            this._gp_item.visible = !!goods_vo
            this.UpdateItem(goods_vo)
        }

        this.StartTimer = () => {
            this.ClearTimer()
            if (!this._timer) {
                this._timer = GlobalTimerQuest.AddPeriodQuest(() => {
                    this.UpdateTimer()
                }, 1, -1)
            }
        }

        this.UpdateTimer = () => {
            let rtime = this._data.end_time - TimeUtil.getServerTime()
            if (rtime > 0) {
                this._lb_tips.text = `${TimeUtil.timeConvert8(rtime)}后开抢`
            } else {
                this.ClearTimer()
                this._lb_tips.text = `第${this._data.wave}波红包`
            }
        }

        this.ClearTimer = () => {
            if (this._timer) {
                GlobalTimerQuest.CancelQuest(this._timer)
                this._timer = null
            }
        }

        this.UpdateItem = (vo) => {
            if (!vo) return
            if (!this._item) {
                this._item = new EquipmentItem(this._gp_item)
                this._item.Load()
                this._item.SetItemSize(86, 86)
            }
            let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(vo.style, vo.typeId)
            this._item.SetData(type_id, vo.count, lock)
        }

        this.GetGoodsTypeByKey = (key) => {
            if (key == "gold") return 1
            if (key == "bgold") return 2
            if (key == "coin") return 3
        }
    }


    public DeleteMe() {
        this.RPRDeleteMe()
    }

    public GetComponents() {
        [
            this.click_gp,
            this._Image1,
            this._img_rpr,
            this._lb_tips,
            this._gp_item,
            this._gp_end,
            this._Image2,
            this._Image3,
        ]
            = this.GetChildrenByNames([

                "click_gp",
                "_Image1",
                "_img_rpr",
                "_lb_tips",
                "_gp_item",
                "_gp_end",
                "_Image2",
                "_Image3",
            ])
    }
}
window["RedPacketRainItem"] = RedPacketRainItem
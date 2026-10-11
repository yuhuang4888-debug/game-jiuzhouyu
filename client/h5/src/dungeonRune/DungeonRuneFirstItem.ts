import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { CustomHeadItem } from "../common/CustomHeadItem"
import { ResManager } from "../common/ResManager"
import { BaseDungeonModel } from "../commonModel/BaseDungeonModel"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { GameResPath } from "../util/GameResPath"

export class DungeonRuneFirstItem extends BaseItemRenderer {
    WIDTH = 439
    HEIGT = 126

    head_item
    model: BaseDungeonModel
    public constructor() {
        super()
        this.base_file = "dungeonRune"
        this.layout_file = "DungeonRuneFirstItem"
        this.model = BaseDungeonModel.GetInstance()
        this.load_callback = () => {
            this.LoadSuccess()
        }
        this.Load()
    }

    public InitEvent() {

    }
    public LoadSuccess() {
        this._img_bg.skin = GameResPath.GetIcon("dungeonRune", "ui_activity_02")
        // ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("dungeonRune", "ui_activity_02"))
        this.InitEvent()
    }

    public dataChanged() {
        if (super.dataChanged()) {
            ResManager.GetInstance().SetImageSprite(this, this._img_rank, "dungeonRune", this.index + 1)

            this._gp_head.visible = !this.data.none
            this._lb_name.visible = !this.data.none
            this._lb_time.visible = !this.data.none
            this._lb_null.visible = this.data.none

            if (this._gp_head.visible) {
                if (!this.head_item) {
                    this.head_item = new CustomHeadItem(this._gp_head)
                    this.head_item.Load()
                }
                //let frame_id = DressModel.GetInstance().GetDressByType(this.data.dress_list, DressType.Photo)
                this.head_item.SetData(this.data.role_id, this.data.role_carrer, null, this.data.picture, this.data.picture_ver, null, null, this.data.dress_list, this.data.role_lv)
            }

            if (this._lb_name.visible) {
                this._lb_name.text = this.data.role_name
            }

            if (this._lb_time.visible) {
                let mergeDay = ServerTimeModel.GetInstance().GetMergeServerDay()
                if (mergeDay > 0) {
                    this._lb_time.text = this.timeConvert2(this.data.time)
                } else {
                    this._lb_time.text = this.timeConver(this.data.time)
                }
            }
        }
    }

    public DeleteMe() {

        if (this.head_item) {
            this.head_item.DeleteMe()
            this.head_item = null
        }
        super.DeleteMe()
    }

    public timeConver(timeStr?) {

        if (timeStr == null) {
            return ""
        }
        if (timeStr < 0) { timeStr = 0 }
        timeStr = Math.floor(timeStr)
        let date = new Date(timeStr * 1000)
        let year = date.getFullYear()
        let month=date.getMonth()+1
        let monthStr = month < 10 && "0" +month || month
        let dateStr = date.getDate() < 10 && "0" + date.getDate() || date.getDate()
        let hoursStr = date.getHours() < 10 && "0" + date.getHours() || date.getHours()
        let minutesStr = date.getMinutes() < 10 && "0" + date.getMinutes() || date.getMinutes()
        let secondStr = date.getSeconds() < 10 && "0" + date.getSeconds() || date.getSeconds()
        return year + "/" + monthStr + "/" + dateStr + "\n" + hoursStr + ":" + minutesStr + ":" + secondStr
    }

    public timeConvert2(second?) {

        if (second == null) { return "" }
        let s = second % 60
        let m = Math.floor(second / 60);
        let min = m % 60
        let str = min == 0 && "" || min + "分"
        let hour
        let d
        let openTime = ServerTimeModel.GetInstance().GetOpenServerTime()
        let openDay = Math.ceil((second - openTime) / 3600 / 24)
        if (m >= 60) {
            let h = Math.floor(m / 60);
            hour = h % 24
            str = hour == 0 && "" || hour + "时" + str
            str = str + s + "秒"
            //if (h >= 24 ) {
            //d = Math.floor(h/24);
            //str = d + "天" + str;
            //}
        } else if (m > 0 && m < 60) {
            str = m + "分"
            str = str + s + "秒"
        } else {
            str = str + s + "秒"
        }
        if (second <= 0) {
            str = "0"
        }
        return "开服第" + openDay + "天\n" + str
    }


    _img_bg: Laya.Image
    _img_rank: Laya.Image
    _gp_head: Laya.Box
    _lb_name: Laya.Label
    _lb_time: Laya.Label
    _lb_null: Laya.Label
    public GetComponents() {
        [
            this._img_bg,
            this._img_rank,
            this._gp_head,
            this._lb_name,
            this._lb_time,
            this._lb_null,
        ]
            = this.GetChildrenByNames([

                "_img_bg",
                "_img_rank",
                "_gp_head",
                "_lb_name",
                "_lb_time",
                "_lb_null",
            ])
    }
}

window["DungeonRuneFirstItem"] = DungeonRuneFirstItem
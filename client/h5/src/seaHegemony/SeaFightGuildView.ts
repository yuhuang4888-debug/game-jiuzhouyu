import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { SeaHegemonyModel } from "../commonModel/SeaHegemonyModel"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
import { SeaGuildListItem } from "./SeaGuildListItem"

export class SeaFightGuildView extends BaseView1 {

    index
    InitView
    Local_Open
    dataArr

    public constructor() {
        super()

        this.index = 0
        this.base_file = "seaHegemony"
        this.layout_file = "SeaFightGuildView"
        this.layer_value = Enum_UILayer.Activity
        this.use_background = true
        this.click_bg_toClose = true
        this.is_center = true
        let local_model = SeaHegemonyModel
        let lcoal_modelIns = local_model.GetInstance()
        this.load_callback = () => {

            this.InitView()
            Util.AddClickEvent(
                this.closeBtn, () => {
                    this.Close()
                },
                this,
                true
            )
            this.BindEvent(
                lcoal_modelIns,
                local_model.GUILD_LIST, (camp?) => {
                    if (camp == this.index) {
                        this.InitView()
                    }
                }
            )

        }

        this.Local_Open = (...new_args) => {
            let parms = new_args
            if (parms && parms[0]) {
                this.index = parms[0]
                lcoal_modelIns.Fire(local_model.REQUEST_PROTO, 18608, "i", this.index)
                this.InitView()
            }
            super.Open()
        }

        this.InitView = () => {
            if (this.index && this.is_loaded) {
                // [ts2lua]lcoal_modelIns.seaGuildList下标访问可能不正确
                let data = lcoal_modelIns.seaGuildList[this.index] || []
                table.sort(data, (a?, b?) => {
                    if (a.rank != b.rank) {
                        return a.rank < b.rank
                    }
                    return false
                })
                this.dataArr = new LoopScrowViewMgr()
                this.dataArr.SetData(this.Content, SeaGuildListItem, data, LoopScrCon.Vertical)
            }
        }
    }

    public DeleteMe() {

        if (this.dataArr) {
            this.dataArr.DeleteMe()
            this.dataArr = null
        }
        super.DeleteMe()
    }

    public Open(...new_args) {

        this.Local_Open(...new_args)
    }


bg:Laya.Image
closeBtn:Laya.Image
_Image3:Laya.Image
_Image5:Laya.Image
_Image7:Laya.Image
Content:Laya.List
timeLb:Laya.Label
_Label1:Laya.Label
_Label2:Laya.Label
_Label3:Laya.Label
_Label4:Laya.Label
_Image2_title:Laya.Image
_lb_win_name:Laya.Label
public GetComponents() {
[
this.bg,
this.closeBtn,
this._Image3,
this._Image5,
this._Image7,
this.Content,
this.timeLb,
this._Label1,
this._Label2,
this._Label3,
this._Label4,
this._Image2_title,
this._lb_win_name,
]
 = this.GetChildrenByNames([

"bg",
"closeBtn",
"_Image3",
"_Image5",
"_Image7",
"Content",
"timeLb",
"_Label1",
"_Label2",
"_Label3",
"_Label4",
"_Image2_title",
"_lb_win_name",
])
}
}
 window["SeaFightGuildView"]= SeaFightGuildView
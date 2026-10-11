import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { SeaHegemonyModel } from "../commonModel/SeaHegemonyModel"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { Util, GlobalTimerQuest } from "../util/Util"
import { SeaShipChangeItem } from "./SeaShipChangeItem"

export class SeaShipChangeView extends BaseView1 {
    is_set_order_sorting
    InitView
    TimeFunc
    CancelColdTimer
    StartColdTimer
    coldTimer

    public constructor() {
        super()

        this.base_file = "seaHegemony"
        this.layout_file = "SeaShipChangeView"
        this.preload_server_config ={"config_seacraft_ship":false}
        this.preload_client_config = {"ClientSeaHegemony":false}
        let local_util = Util
        let local_model = SeaHegemonyModel
        let local_modelIns = local_model.GetInstance()

        this.destroy_imm = true
        this.layer_value = Enum_UILayer.Activity
        this.is_center = true
        this.use_background = true
        this.click_bg_toClose = true
        this.is_set_order_sorting = true

        let selectShipType = null
        let itemList = null

        this.open_callback = () => {
            let cfg =ResManager.GetInstance().GetGameConfigFromCache(this,"config_seacraft_ship",false)
            if (!itemList) {
                itemList = []
            }
            let i = 1
            do {
                let item = new SeaShipChangeItem(this.Content)
                item.Load()
                // [ts2lua]cfg下标访问可能不正确
                item.SetData(cfg[i])
                itemList[i] = item
                i = i + 1
            } while ((i < 3))
        }

        this.load_callback = () => {
            this._Scroller1.vScrollBarSkin=""
            this.InitView()
            Util.AddClickEvent(
                this.closeBtn, () => {
                    this.Close()
                },
                this,
                true
            )
            Util.AddClickEvent(
                this.changeBtn, () => {
                    if (selectShipType) {
                        local_modelIns.Fire(local_model.REQUEST_PROTO, 18610, "c", selectShipType)
                    }
                },
                this,
                true
            )
            this.StartColdTimer()
            local_modelIns.Fire(local_model.REQUEST_PROTO, 18610, "c", 0)
        }

        this.destroy_callback = () => {
            this.CancelColdTimer()
            if (itemList) {
                for (let _tmpi in itemList) {
                    var vo = itemList[_tmpi]
                    vo.DeleteMe()
                }
                itemList = null
            }
        }

        this.InitView = () => {
            this.BindEvent(
                local_modelIns,
                local_model.CHANGE_SHIP, () => {
                    if (itemList) {
                        for (let _tmpi in itemList) {
                            var vo = itemList[_tmpi]
                            if (vo.is_loaded) {
                                vo.SetCur()
                            }
                        }
                    }
                    this.StartColdTimer()
                }
            )

            this.BindEvent(
                local_modelIns,
                local_model.SELECT_SHIP, (shipType?) => {
                    selectShipType = shipType
                }
            )
        }

        this.StartColdTimer = () => {
            if (local_modelIns.changeCold) {
                this.CancelColdTimer()
                this.coldTimer = GlobalTimerQuest.AddPeriodQuest(() => {
                    this.TimeFunc()
                }, 1)
                this.TimeFunc()
                if (local_modelIns.changeCold > TimeUtil.getServerTime()) {
                    Util.SetImageGray(this.changeBtn, true)
                }
            }
        }

        this.CancelColdTimer = () => {
            if (this.coldTimer) {
                GlobalTimerQuest.CancelQuest(this.coldTimer)
                this.coldTimer = null
            }
        }

        this.TimeFunc = () => {
            let time = local_modelIns.changeCold - TimeUtil.getServerTime()
            if (time > 0 && this.labelDisplay) {
                this.labelDisplay.text = `切换战舰(${time})`
            } else {
                if (this.labelDisplay) {
                    this.labelDisplay.text = "切换战舰"
                }
                this.CancelColdTimer()
                Util.SetImageGray(this.changeBtn, false)
            }
        }
    }

    public DeleteMe(): void {
        super.DeleteMe()
    }



bg:Laya.Image
closeBtn:Laya.Image
_Image2:Laya.Image
_Scroller1:Laya.Panel
Content:Laya.VBox
changeBtn:Laya.Box
_Image1:Laya.Image
labelDisplay:Laya.Label
_Image2_title:Laya.Image
_lb_win_name:Laya.Label
public GetComponents() {
[
this.bg,
this.closeBtn,
this._Image2,
this._Scroller1,
this.Content,
this.changeBtn,
this._Image1,
this.labelDisplay,
this._Image2_title,
this._lb_win_name,
]
 = this.GetChildrenByNames([

"bg",
"closeBtn",
"_Image2",
"_Scroller1",
"Content",
"changeBtn",
"_Image1",
"labelDisplay",
"_Image2_title",
"_lb_win_name",
])
}
}
 window["SeaShipChangeView"]= SeaShipChangeView
import { Alert, Alert_Type } from "../alert/Alert"
import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { OpenFun } from "../common/OpenFun"
import { ResManager } from "../common/ResManager"
import { TopPkDefine, TopPkModel } from "../commonModel/TopPkModel"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"

export class TopPkBuyCountView extends BaseView1 {
    _Image111: Laya.Image
    _Image2: Laya.Image
    _Image3: Laya.Image
    _lb_desc: Laya.HTMLDivElement
    _btn_cancel: Laya.Box
    _Image11: Laya.Image
    labelDisplay: Laya.Label
    _btn_ok: Laya.Box
    _Image1: Laya.Image
    labelDisplay1: Laya.Label
    _Group1: Laya.Box
    _Image4: Laya.Image
    _Label1: Laya.Label
    _Image5: Laya.Image
    colse_img: Laya.Image
    Emp_btn_cancel
    Emp_btn_ok
    InitEvent
    LoadSuccess
    Remove
    UpdateView

    public constructor() {
        super()


        this.base_file = "topPk"
        this.layout_file = "TopPkBuyCountView"
        this.layer_value = Enum_UILayer.Activity
        let model = TopPkModel.GetInstance()
        let local_TopPkDefine = TopPkDefine
        this.destroy_imm = true
        this.use_background = true
        this.is_center = true
        this.change_scene_close = true
        this.show_open_movie = true
        this.click_bg_toClose = true
        this.load_callback = () => {

            this.LoadSuccess()
        }

        this.close_callback = () => {
            this.Remove()
        }

        this.Remove = () => {

        }

        this.LoadSuccess = () => {
            ResManager.GetInstance().SetOutsideImageSprite(this, this._Image111, GameResPath.GetIcon("topPk", "bg_03"))
            this.UpdateView()
            this.InitEvent()
        }

        this.InitEvent = () => {
            this.BindVar(model, "daily_count_data", () => {
                this.UpdateView()
            }
            )
            Util.AddClickEvent(this._btn_cancel, () => {
                this.Close()
            }
                , this, true)
            Util.AddClickEvent(this.colse_img, () => {
                this.Close()
            }, this, true)

            let request_func = () => {
                model.Fire(TopPkModel.REQUEST_SCMD, 28104, 1)
                // this.Close()
            }
            Util.AddClickEvent(this._btn_ok, () => {
                if (Util.CheckMoney(TopPkDefine.BUY_COST, request_func, true, false, () => {
                    Alert.Show("勾玉不足是否前往充值？", Alert_Type.Two, () => {
                        OpenFun.OpenFunHandler(21)
                        this.Close()
                    });
                })) {
                    request_func()
                }
                // else {
                //     Alert.Show("勾玉不足是否前往充值？", Alert_Type.Two, () => {
                //         OpenFun.OpenFunHandler(21)
                //         this.Close()
                //     });
                // }
            }, this, true)
        }

        this.UpdateView = () => {
            let daily_count_data = model.daily_count_data
            if (daily_count_data) {
                this._lb_desc.style.fontSize = 24
                this._lb_desc.style.valign = "center"
                this._lb_desc.style.color = "#663915"
                this._lb_desc.width = 500
                this._lb_desc.style.lineHeight = 30
                this._lb_desc.innerHTML = "是否使用<font color='#0a953e'>" + TopPkDefine.BUY_COST + "勾玉/绑玉</font>购买1次挑战次数？<br/>" + Util.HtmlColorTxt("优先消耗绑玉", "'#FF9015'") + "<br/>" + Util.HtmlColorTxt("本日还可购买" + (TopPkDefine.DAILT_BUY_COUNT - daily_count_data.daily_buy_count) + "次", "'#558ed5'")
            }
        }


    }



    public GetComponents() {
        [
            this._Image111,
            this._Image2,
            this._Image3,
            this._lb_desc,
            this._btn_cancel,
            this._Image11,
            this.labelDisplay,
            this._btn_ok,
            this._Image1,
            this.labelDisplay1,
            this._Group1,
            this._Image4,
            this._Label1,
            this._Image5,
            this.colse_img
        ]
            = this.GetChildrenByNames([

                "_Image111",
                "_Image2",
                "_Image3",
                "_lb_desc",
                "_btn_cancel",
                "_Image11",
                "labelDisplay",
                "_btn_ok",
                "_Image1",
                "labelDisplay1",
                "_Group1",
                "_Image4",
                "_Label1",
                "_Image5",
                "colse_img"
            ])
    }
}
window["TopPkBuyCountView"] = TopPkBuyCountView
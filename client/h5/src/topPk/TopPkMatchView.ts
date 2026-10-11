import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { TopPkModel } from "../commonModel/TopPkModel"
import { GameResPath } from "../util/GameResPath"
import { SYTweenFunc } from "../util/SYTweenFunc"
import { SYTweenLite } from "../util/SYTweenLite"
import { GlobalTimerQuest, Util } from "../util/Util"

export class TopPkMatchView extends BaseView1 {
    _img_bg: Laya.Image
    _lb_tips_1: Laya.Label
    _lb_tips_2: Laya.Label
    _Image1: Laya.Image
    _img_rotation: Laya.Image
    _Image2: Laya.Image
    _lb_count_down: Laya.Label
    _gp_cacel_match: Laya.Box
    _Image3: Laya.Image
    _Label1: Laya.Label
    CancelCountDown
    InitEvent
    InitView
    LoadSuccess
    Remove
    StartCountDown
    anim_list

    public constructor() {
        super()


        this.base_file = "topPk"
        this.layout_file = "TopPkMatchView"
        this.layer_value = Enum_UILayer.Activity
        let model = TopPkModel.GetInstance()
        let local_laya = Laya
        let time_id_ = null
        let time_func_ = null
        this.destroy_imm = true
        this.use_background = true
        this.is_center = true
        this.anim_list = []
        this.change_scene_close = true
        this.load_callback = () => {

            this.LoadSuccess()
        }

        this.close_callback = () => {
            this.Remove()
        }

        this.Remove = () => {
            this.CancelCountDown()
            Laya.Tween.clearAll(this._img_rotation)
            if (this.anim_list && this.anim_list.length > 0) {
                for (let i = 0; i < this.anim_list.length; i++) {
                    var v = this.anim_list[i]
                    SYTweenLite.Stop(v)
                }
                this.anim_list = []
            }
        }

        this.LoadSuccess = () => {
            ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("topPk", "uidfjj_024"))
            this.InitView()
            this.InitEvent()
        }

        this.InitEvent = () => {
            Util.AddClickEvent(this._gp_cacel_match, () => {
                model.Fire(TopPkModel.REQUEST_SCMD, 28114)
            }
                , this, true)
        }

        this.InitView = () => {
            let start_time = 0
            this.StartCountDown(() => {
                this._lb_count_down.text = String(start_time)
                start_time = start_time + 1
            }
            )
            let func1 = () => {
                Laya.Tween.to(this._img_rotation,{ rotation:360 },1000,Laya.Ease.linearNone, Laya.Handler.create(this, () => {
                    this._img_rotation.rotation = 0
                    fun2()
                }))
            }
            let fun2 = () => {
                Laya.Tween.to(this._img_rotation,{ rotation:360 },1000,Laya.Ease.linearNone, Laya.Handler.create(this, () => {
                    this._img_rotation.rotation = 0
                    func1()
                }))
            }
            func1()
            // table.insert(this.anim_list, SYTweenLite.to(this,
            //     this._img_rotation,
            //     SYTweenLite.UiAnimationType.ROTATION,
            //     -360,
            //     1, () => {
            //         if (this._img_rotation) {
            //             //(this._img_rotation, 0)
            //         }
            //     },
            //     SYTweenFunc.LINEAR,
            //     true))

        }

        this.CancelCountDown = () => {

            if (time_id_) {
                GlobalTimerQuest.CancelQuest(time_id_)
                time_id_ = null
                time_func_ = null
            }
        }

        this.StartCountDown = (func?) => {
            this.CancelCountDown()
            time_func_ = func
            time_id_ = GlobalTimerQuest.AddPeriodQuest(func, 1)

            func()
        }


    }



    public GetComponents() {
        [
            this._img_bg,
            this._lb_tips_1,
            this._lb_tips_2,
            this._Image1,
            this._img_rotation,
            this._Image2,
            this._lb_count_down,
            this._gp_cacel_match,
            this._Image3,
            this._Label1,
        ]
            = this.GetChildrenByNames([

                "_img_bg",
                "_lb_tips_1",
                "_lb_tips_2",
                "_Image1",
                "_img_rotation",
                "_Image2",
                "_lb_count_down",
                "_gp_cacel_match",
                "_Image3",
                "_Label1",
            ])
    }
}
window["TopPkMatchView"] = TopPkMatchView
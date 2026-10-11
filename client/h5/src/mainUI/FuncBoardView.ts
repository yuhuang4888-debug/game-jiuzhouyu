import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { table } from "../common/table"
import { MainUIModel } from "../commonModel/MainUIModel"
import { SYTweenFunc } from "../util/SYTweenFunc"
import { SYTweenLite } from "../util/SYTweenLite"
import { GlobalTimerQuest, Util } from "../util/Util"
import { Config } from "../common/Config"
import { ResManager } from "../common/ResManager"
import { TempleAwakenModel, TempleAwakenEvent } from "../commonModel/TempleAwakenModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventName } from "../common/EventName"
import { BaseItem1 } from "../common/BaseItem1"

export class FuncBoardView extends BaseItem1 {

    SetData
    StartTimer
    onTimer
    removeTimer
    dir_type  //方向类型
    pos       //point
    scmd      //配置id
    InitImg
    PopAnim
    Shake
    tween_list = []
    ClearTween
    is_auto = false
    InitEvent
    // CloseFunc

    //浮动动画
    ShakeAnim
    ShakeW = 10

    //方向类型
    public static DIR_LEFT = 1  //指向左边
    public static DIR_RIGHT = 2

    //功能区分
    cfg


    public constructor(p) {
        super(p)
        this.base_file = "mainUI"
        this.layout_file = "FuncBoardView"
        this.layer_value = Enum_UILayer.Main
        // this.change_scene_close = false
        // this.destroy_imm = true
        // this.use_background = false
        // this.change_scene_close = true
        // this.show_open_movie = false
        let _closeTimer
        let _time = 10
        let model: MainUIModel = MainUIModel.GetInstance()

        //浮动动画
        let tween_complete
        let tween_state

        this.load_callback = () => {
            this.InitEvent()
            this.display_obj.alpha = 0

            //先load
            this.SetData(this.scmd, this.pos, this.dir_type)
        }


        this.InitEvent = () => {
            // Util.AddClickEvent(this._img_close, () => {
            //     this.CloseFunc()
            // }, this, true)

            this.BindEvent(model, MainUIModel.UPDATE_ACTIVITY_STATE, (bool?) => {
                this.display_obj.visible = bool
            })


            this.BindEvent(GlobalEventSystem, EventName.CHANGE_ACCOUNT, () => {
                this.DeleteMe()
                //this.Close()
            })



            this.BindEvent(GlobalEventSystem, EventName.CHANGE_ROLE, () => {
                //this.Close()
                this.DeleteMe()
            })

            this.BindEvent(GlobalEventSystem, EventName.CLOSE_FUNCBOARD, (uid) => {
                if (this.scmd.uid && uid == this.scmd.uid) {
                    //this.Close()
                    this.DeleteMe()
                }
            })

            //神殿觉醒处理
            this.BindEvent(TempleAwakenModel.GetInstance(), TempleAwakenEvent.UPDATE_VIEW, () => {
                if (this.cfg && this.cfg.mod_id == 429 && this.cfg.sub_id == 0) {
                    let uid_str = this.cfg.id
                    //判断章节是否完成
                    let now_chapter = Number(uid_str) % 10 + 1000 //检查的章节
                    let t_info = TempleAwakenModel.GetInstance().GetMainChapterInfo()
                    if (t_info && t_info[now_chapter] && t_info[now_chapter].status == 3) {
                        //this.RemoveOneBoard()
                        this.DeleteMe()
                        //this.Close()
                    }
                }

            })



        }




        this.SetData = (scmd, pos, dir_type) => {

            this.scmd = scmd//scmd={uid:xxxx}
            this.pos = pos
            this.dir_type = dir_type

            if (this.is_loaded) {
                this.cfg = Config.PRELOAD_SERVER_CONFIG.config_popup[this.scmd.uid]
                this.is_auto = false
                if (this.cfg) {
                    this._lb_con.text = this.cfg.content || "" + this.scmd.uid
                    _time = this.cfg.popup_time || 10
                    //this.is_auto = false
                    //ResManager.GetInstance().SetImageSprite(this,this.content_bg,"mainUI","mainui_ui_41")
                } else if (this.scmd.uid == 1525) {
                    this._lb_con.text = "可激活套装"
                    this._lb_con.x = 20
                }

                this._lb_time.visible = this.is_auto
                this.display_obj.pos(this.pos.x, this.pos.y)
                //this.display_obj.visible = MainUIModel.GetInstance().activity_icon_in_show

                this.InitImg()
                this.PopAnim()
            }

        }

        this.StartTimer = () => {

            if (!_closeTimer) {
                _closeTimer = GlobalTimerQuest.AddPeriodQuest(() => {
                    this.onTimer()
                }, 1, -1)
                this.onTimer()
            }

        }


        this.onTimer = () => {
            this._lb_time.text = `${_time}s后消失`
            if (_time <= 0) {
                this.removeTimer()
                this.DeleteMe()
                //this.CloseFunc()
            }
            _time = _time - 1
        }


        this.removeTimer = () => {
            if (_closeTimer) {
                GlobalTimerQuest.CancelQuest(_closeTimer)
                _closeTimer = null
                _time = 10
            }
        }


        this.InitImg = () => {
            switch (this.dir_type) {
                case FuncBoardView.DIR_LEFT:
                    this.content_bg.pos(93, 30)
                    this.content_bg.scaleX = -1
                    break
                case FuncBoardView.DIR_RIGHT:
                    this.content_bg.scaleX = 1
                    break
            }
        }


        this.PopAnim = () => {
            this.ClearTween()
            switch (this.dir_type) {
                case FuncBoardView.DIR_LEFT:
                    this.display_obj.pos(this.pos.x - 200, this.pos.y)
                    this.display_obj.alpha = 0
                    table.insert(this.tween_list, SYTweenLite.to(this, this.display_obj, SYTweenLite.UiAnimationType.POSX, this.pos.x, 0.25, () => {
                        if (this.is_auto) {
                            this.StartTimer()
                        }
                        tween_state = true
                        this.ShakeAnim()
                    }, SYTweenFunc.EASE_IN))
                    table.insert(this.tween_list, SYTweenLite.to(this, this.display_obj, SYTweenLite.UiAnimationType.ALPHA, 1, 0.15, null, SYTweenFunc.EASE_IN))
                    break
                case FuncBoardView.DIR_RIGHT:
                    this.display_obj.pos(this.pos.x - 200, this.pos.y)
                    this.display_obj.alpha = 0
                    table.insert(this.tween_list, SYTweenLite.to(this, this.display_obj, SYTweenLite.UiAnimationType.POSX, this.pos.x, 0.25, () => {
                        if (this.is_auto) {
                            this.StartTimer()
                        }
                        tween_state = true
                        this.ShakeAnim()
                    }, SYTweenFunc.EASE_IN))
                    table.insert(this.tween_list, SYTweenLite.to(this, this.display_obj, SYTweenLite.UiAnimationType.ALPHA, 1, 0.15, null, SYTweenFunc.EASE_IN))
                    break
            }
        }

        this.ClearTween = () => {
            if (this.tween_list) {
                for (let _ in this.tween_list) {
                    var key = this.tween_list[_]
                    SYTweenLite.Stop(key)
                }
                this.tween_list = []
            }
            Laya.Tween.clearAll(this.display_obj)
            if (tween_complete) {
                tween_complete.recover()
                tween_complete = null
            }
        }

        this.ShakeAnim = () => {
            if (!tween_complete) {
                tween_complete = Laya.Handler.create(this, () => {
                    this.ShakeAnim()
                }, null, false)
            }

            let pos_temp
            switch (this.dir_type) {
                case FuncBoardView.DIR_LEFT:
                    pos_temp = tween_state ? this.pos.x + this.ShakeW : this.pos.x - this.ShakeW
                    tween_state = !tween_state
                    Laya.Tween.to(this.display_obj, { x: pos_temp }, 1000, Laya.Ease.sineInOut, tween_complete)
                    break
                case FuncBoardView.DIR_RIGHT:
                    pos_temp = tween_state ? this.pos.x + this.ShakeW : this.pos.x - this.ShakeW
                    tween_state = !tween_state
                    Laya.Tween.to(this.display_obj, { x: pos_temp }, 1000, Laya.Ease.sineInOut, tween_complete)
                    break
            }
        }

    }

    public DeleteMe(): void {
        this.ClearTween()
        this.removeTimer()
        super.DeleteMe()
    }



    content_bg: Laya.Image
    _lb_con: Laya.Label
    _lb_time: Laya.Label
    public GetComponents() {
        [
            this.content_bg,
            this._lb_con,
            this._lb_time,
        ]
            = this.GetChildrenByNames([

                "content_bg",
                "_lb_con",
                "_lb_time",
            ])
    }
}
window["FuncBoardView"] = FuncBoardView
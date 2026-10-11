import { AutoFightManager } from "../autofight/AutoFightManager"
import { BaseView1 } from "../common/BaseView1"
import { CookieWrapper } from "../common/CookieWrapper"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { MainUIModel } from "../commonModel/MainUIModel"
import { SeaHegemonyModel } from "../commonModel/SeaHegemonyModel"
import { GameResPath } from "../util/GameResPath"
import { SYTweenLite } from "../util/SYTweenLite"
import { Util, GetLocalPositionX, SetLocalPositionX, GlobalTimerQuest } from "../util/Util"

export class SeaFightChangeView extends BaseView1 {
    time
    model
    InitEvent
    SetStatus
    status
    CancelTimer
    StartTimer
    TimerFunc
    Local_Open
    public constructor() {
        super()

        this.time = 0
        this.base_file = "seaHegemony"
        this.layout_file = "SeaFightChangeView"
        this.layer_value = Enum_UILayer.Activity
        this.use_background = true
        this.click_bg_toClose = true
        this.is_center = true
        this.model = SeaHegemonyModel.GetInstance()
        let local_util = Util
        let timerId = null
        let init_left_x
        let init_right_x

        this.load_callback = () => {
            ResManager.GetInstance().SetOutsideImageSprite(this, this._img_split, GameResPath.GetIcon("seaHegemony", "ui_shzb_split"))
            this.InitEvent()

            init_left_x = GetLocalPositionX(this.leftGp)
            init_right_x = GetLocalPositionX(this.rightGp)
            this.SetStatus(this.status)
        }

        this.Local_Open = (parms) => {
            if (parms && parms.length > 0) {
                this.status = parms[0]
                this.SetStatus(this.status)
            }
            super.Open()
        }

        this.close_callback = () => {
            this.status = null
            this.CancelTimer()

            //关闭弹出介绍
            // let str = CookieWrapper.GetInstance().GetCookie(CookieWrapper.SEA_FIGHT_INSTRUCTION,true)
            // if(!str||str!="1"){
            //     CookieWrapper.GetInstance().SaveCookie(CookieWrapper.SEA_FIGHT_INSTRUCTION, "1", true)
            //     this.model.Fire(SeaHegemonyModel.OPEN_VIEW, "SeaFightInstructionView",1)
            // }

        }

        this.InitEvent = () => {
            Util.AddClickEvent(
                this.enterBtn, () => {
                    AutoFightManager.GetInstance().SetAutoFight(true)
                    this.Close()
                },
                this,
                true
            )
            ResManager.GetInstance().SetImageSpriteTrans(this, this.leftBg, GameResPath.GetIcon("seaHegemony", "ui_shzb_052"))
            ResManager.GetInstance().SetImageSpriteTrans(this, this.rightBg, GameResPath.GetIcon("seaHegemony", "ui_shzb_051"))
        }

        this.SetStatus = (status?) => {
            if (this.status && this.is_loaded) {
                let sp_name
                if (status == 2) {
                    sp_name = "ui_shzb_057"
                } else {
                    sp_name = "ui_shzb_056"
                }
                ResManager.GetInstance().SetImageSprite(this, this.fightImg, "seaHegemony", sp_name, true)
                let data = SeaHegemonyModel.GetInstance().fightData
                if (data) {
                    let attData = data.def[0]
                    if (attData) {
                        if (attData.server_num) {
                            this.nameLb.text = "S" + attData.server_num + "." + attData.guild_name
                        } else {
                            this.nameLb.text = attData.guild_name
                        }
                    }
                    let i = 0
                    do {
                        let def1 = data.att[i]
                        if (def1) {
                            if (def1.server_num) {
                                this["nameLb" + (i + 1)].text = "S" + def1.server_num + "." + def1.guild_name
                            } else {
                                this["nameLb" + (i + 1)].text = def1.guild_name
                            }
                        } else {
                            this["nameLb" + (i + 1)].text = "暂无结社"
                        }
                        i = i + 1
                    } while ((i < 3))
                }
                this.leftGp.visible = true
                this.rightGp.visible = true
                this._img_split.visible = this.fightImg.visible = false
                this.enterBtn.visible = false

                SetLocalPositionX(this.leftGp, init_left_x - 1000)
                SYTweenLite.to(this, this.leftGp, SYTweenLite.UiAnimationType.POSX, init_left_x, MainUIModel.Move_Time_Interval)

                SetLocalPositionX(this.rightGp, init_right_x + 1000)
                SYTweenLite.to(this, this.rightGp, SYTweenLite.UiAnimationType.POSX, init_right_x, MainUIModel.Move_Time_Interval, () => {
                    this.fightImg.visible = true
                    this.enterBtn.visible = true
                    this._img_split.visible = true
                })
                this.StartTimer()
            }
        }

        this.TimerFunc = () => {
            if (this.enterBtn && this.time > 0) {
                this.time--
                this.labelDisplay.text = `开始战斗(${this.time})`
            } else {
                this.CancelTimer()
                this.Close()
            }
        }

        this.CancelTimer = () => {
            if (timerId) {
                GlobalTimerQuest.CancelQuest(timerId)
                timerId = null
            }
        }

        this.StartTimer = () => {
            this.CancelTimer()
            this.time = 15

            timerId =
                GlobalTimerQuest.AddPeriodQuest(() => {
                    this.TimerFunc()
                }, 1
                )
            this.TimerFunc()
        }
    }

    public DeleteMe(): void {
        super.DeleteMe()
    }

    public Open(...parms) {
        this.Local_Open(parms)
    }


    _img_split: Laya.Image
    leftGp: Laya.Box
    leftBg: Laya.Image
    _Image11: Laya.Image
    nameLb: Laya.Label
    _Label1: Laya.Label
    rightGp: Laya.Box
    rightBg: Laya.Image
    attImg1: Laya.Image
    attImg2: Laya.Image
    attImg3: Laya.Image
    nameLb1: Laya.Label
    nameLb2: Laya.Label
    nameLb3: Laya.Label
    _Label2: Laya.Label
    fightImg: Laya.Image
    enterBtn: Laya.Box
    _Image1: Laya.Image
    labelDisplay: Laya.Label
    public GetComponents() {
        [
            this._img_split,
            this.leftGp,
            this.leftBg,
            this._Image11,
            this.nameLb,
            this._Label1,
            this.rightGp,
            this.rightBg,
            this.attImg1,
            this.attImg2,
            this.attImg3,
            this.nameLb1,
            this.nameLb2,
            this.nameLb3,
            this._Label2,
            this.fightImg,
            this.enterBtn,
            this._Image1,
            this.labelDisplay,
        ]
            = this.GetChildrenByNames([

                "_img_split",
                "leftGp",
                "leftBg",
                "_Image11",
                "nameLb",
                "_Label1",
                "rightGp",
                "rightBg",
                "attImg1",
                "attImg2",
                "attImg3",
                "nameLb1",
                "nameLb2",
                "nameLb3",
                "_Label2",
                "fightImg",
                "enterBtn",
                "_Image1",
                "labelDisplay",
            ])
    }
}
window["SeaFightChangeView"] = SeaFightChangeView
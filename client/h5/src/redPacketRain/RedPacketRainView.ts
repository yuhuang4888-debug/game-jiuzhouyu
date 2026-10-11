import { BaseItem1 } from "../common/BaseItem1";
import { OpenFun } from "../common/OpenFun";
import { ResManager } from "../common/ResManager";
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine";
import { CustomActivityModel } from "../commonModel/CustomActivityModel";
import { VipModel } from "../commonModel/VipModel";
import { Enum_ColorUtil_Light } from "../util/ColorUtil";
import { ErlangParser } from "../util/ErlangParser";
import { GameResPath } from "../util/GameResPath";
import { TimeUtil } from "../util/TimeUtil";
import { GlobalTimerQuest, Util } from "../util/Util";
import { RedPacketRainItem } from "./RedPacketRainItem";

export class RedPacketRainView extends BaseItem1 {

    _img_002: Laya.Image
    _Image1: Laya.Image
    _Image2: Laya.Image
    _Image3: Laya.Image
    _Image4: Laya.Image
    _Label1: Laya.Label
    _Label2: Laya.Label
    _Label3: Laya.Label
    _lb_end: Laya.Label
    _gp_time: Laya.Box
    _lb_time_tips: Laya.Label
    _lb_time_cd: Laya.Label
    _gp_item: Laya.Box
    _gp_pro: Laya.Box
    _Image5: Laya.Image
    _Image6: Laya.Image
    _Image7: Laya.Image
    _img_pro: Laya.Image
    _btn_go: Laya.Box
    _Image8: Laya.Image
    _Label4: Laya.Label
    _Label5: Laya.Label
    _lb_time: Laya.Label
    _lb_pro: Laya.Label
    _lb_tips: Laya.HTMLDivElement
    private _model: CustomActivityModel;
    private _timer
    private _item_list: Array<RedPacketRainItem>;
    private _pos_list = [[208, 466], [391, 466], [122, 643], [303, 643], [486, 643]];
    private _end_time = 0;
    private _timer_func;
    private _act_info;//scmd33101
    private _cond_key;

    InitEvent
    LoadSuccess
    UpdateItems
    UpdateView
    StartTimer
    UpdateTimer
    UpdateCDTimer
    ClearTimer

    public constructor(parent) {
        super(parent);
        this.base_file = "redPacketRain"
        this.layout_file = "RedPacketRainView"
        this._model = CustomActivityModel.GetInstance()
        this.load_callback = function () {
            this.InitEvent()
            this.LoadSuccess()
        }

        this.InitEvent = () => {
            this.BindEvent(this._model, CustomActivityDefine.EVENT.WAVE_RED_PACKET, () => {
                let sub_type = this._act_info.sub_type
                this._model.Fire(CustomActivityDefine.EVENT.SCMD_REQUEST, 33155, sub_type)
            })

            this.BindEvent(this._model, CustomActivityDefine.EVENT.UPDATE_RED_PACKET, () => {
                let sub_type = this._act_info.sub_type
                this._model.Fire(CustomActivityDefine.EVENT.SCMD_REQUEST, 33155, sub_type)
            })

            //充值成功刷新界面
            this.BindEvent(VipModel.GetInstance(), VipModel.UPDATE_RECHARGE_VIEW, (scmd) => {
                if (!scmd && this._cond_key == "recharge") {
                    let sub_type = this._act_info.sub_type
                    this._model.Fire(CustomActivityDefine.EVENT.SCMD_REQUEST, 33155, sub_type)
                }
            })

            this.BindEvent(this._model, CustomActivityDefine.EVENT.UPDATE_VIEW, (type, stype, scmd) => {
                let base_type = this._act_info.base_type
                let sub_type = this._act_info.sub_type
                if (base_type == type && sub_type == stype) {
                    this.UpdateView()
                }
            })

            Util.AddClickEvent(this._btn_go, () => {
                if (this._cond_key == "recharge") {
                    OpenFun.OpenFunHandler(21)
                } else if (this._cond_key == "activity") {
                    OpenFun.OpenFunHandler(82)
                }
            }, this, true)
        }

        this.LoadSuccess = () => {
            let sub_type = this._act_info.sub_type
            this._model.Fire(CustomActivityDefine.EVENT.SCMD_REQUEST, 33155, sub_type)

            this._item_list = new Array<RedPacketRainItem>()
            let Mask_: Laya.Sprite;
            Mask_ = new Laya.Sprite();
            Mask_.graphics.drawRect(0, 0, 0, this._img_pro.height, "#ffffff");
            Mask_.pos(0, 0);
            this._img_pro.mask = Mask_

            ResManager.GetInstance().SetOutsideImageSprite(this, this._img_002, GameResPath.GetIconOtherPath("redPacketRain", "uihby_002"))
        }

        this.UpdateItems = (list) => {
            for (let i = 0; i < list.length; i++) {
                let info = list[i]
                let item = this._item_list[i]
                if (!item) {
                    item = new RedPacketRainItem(this._gp_item)
                    item.Load()

                    this._item_list[i] = item
                }

                item.ExcuteCallback(() => {
                    item.SetData(info)
                    item.display_obj.x = this._pos_list[i][0]
                    item.display_obj.y = this._pos_list[i][1]
                    item.display_obj.visible = true
                })

            }
            for (let i = list.length; i < this._item_list.length; i++) {
                this._item_list[i].display_obj.visible = false
            }
        }

        this.UpdateView = () => {
            this.ClearTimer()
            let base_type = this._act_info.base_type
            let sub_type = this._act_info.sub_type
            let info = this._model.GetActInfo(base_type, sub_type)
            //[{rain_time,72000,5,60},{wave_envelopes_num, [{1,5},{2,5},{3,5},{4,5},{5,5}]}]
            let cond_list = ErlangParser.GetInstance().Parse(info.condition)
            let value = 0, gname = "", goods_name = "", gap = 0, reward_dic = {}, wave_count = 0
            for (let vo of cond_list) {
                if (vo[0] == "rain_value") {
                    value = Number(vo[2])
                    if (vo[1] == "recharge") { gname = "充值", goods_name = "勾玉" }
                    else if (vo[1] == "activity") gname = "活跃度"
                    this._cond_key = vo[1]
                } else if (vo[0] == "rain_time") {
                    gap = Number(vo[3])
                    wave_count = Number(vo[2])
                } else if (vo[0] == "wave_envelopes_num") {
                    for (let data of vo[1]) {
                        reward_dic[data[0]] = data
                    }
                }
            }

            let data = this._model.GetActData(base_type, sub_type)
            //该天活动已结束
            let cur_time = TimeUtil.getServerTime()
            let cdate = new Date(cur_time * 1000)
            let sdate = new Date(data.start_time * 1000)
            let adate = new Date(info.stime * 1000)
            let first_day = adate.getDay() == cdate.getDay()
            let today = sdate.getDay() == cdate.getDay()
            let hour = data.clear_type == 2 ? 4 : 0
            let clear_time = TimeUtil.GetTimeFutureZeroStamp(data.start_time, 0, hour)
            let end = data.start_time == 0 || (!first_day && cur_time < clear_time) || (first_day && !today)
            // let end = data.start_time == 0 || cdate.getDay() != sdate.getDay()
            this._lb_end.visible = end


            let list = [], plist = []
            for (let vo of data.wave_receive) {
                plist[vo.wave2 - 1] = vo
            }
            for (let i = 0; i < wave_count; i++) {
                plist[i] = plist[i] || { wave2: i + 1 }
            }
            //只有最后一波要判断时间
            let is_over_time = data.start_time < cur_time
            let start = data.wave > 1 || (data.start_time != 0 && is_over_time)
            for (let vo of plist) {
                //status 1.已结束 2.进行中 3.等待开始 --4.未开始
                //start 活动: 0.未开始 1.已开始 2.已结束
                let status = 4
                let wave = data.wave == wave_count && is_over_time ? data.wave : data.wave - 1
                if (vo.wave2 < wave) status = 1
                else if (vo.wave2 == wave && start) status = 2
                else if (vo.wave2 > wave && start) status = 3
                let dwave = vo.wave2 - data.wave
                let etime = dwave >= 0 ? dwave * gap + data.start_time : 0
                let goods_vo = vo.goods_list ? vo.goods_list[0] : undefined
                let vs = end ? 2 : (start ? 1 : 0)
                list.push({ wave: vo.wave2, start: vs, status: status, end_time: etime, goods_vo: goods_vo, show_vo: reward_dic[vo.wave2] })
            }
            this.UpdateItems(list)

            if (!end) {
                let can_start = data.act_value >= value
                this._gp_pro.visible = !can_start
                this._gp_time.visible = can_start
                if (!can_start) {
                    this._lb_pro.text = `${data.act_value}/${value}`
                    let width = Math.min(data.act_value / value, 1) * this._img_pro.width
                    let height = this._img_pro.height
                    this._img_pro.mask.graphics.clear()
                    this._img_pro.mask.graphics.drawRect(0, 0, width, height, "#ffffff");
                    let gname_str = Util.HtmlColorTxt(gname, Enum_ColorUtil_Light.GREEN)
                    let value_str = Util.HtmlColorTxt(value, "'#ffe222'")
                    this._lb_tips.style.valign = "center"
                    this._lb_tips.style.color = "#ffffff"
                    this._lb_tips.style.wordWrap = false
                    this._lb_tips.style.fontSize = 22

                    this._lb_tips.innerHTML = Util.StrToHTML(`全服${gname_str}达到${value_str}${goods_name}激活红包雨`)
                    let parent = <Laya.HBox>this._lb_tips.parent
                    if (parent) parent.refresh()
                    this.StartTimer(data.start_time, this.UpdateTimer)
                } else {
                    if (start) {
                        let etime = (wave_count - data.wave + 1) * gap + data.start_time
                        this._lb_time_tips.text = "红包雨结束倒计时"
                        this.StartTimer(etime, this.UpdateCDTimer)
                    } else {
                        if (!end) {
                            this._lb_time_tips.text = "红包雨开启倒计时"
                            this.StartTimer(data.start_time, this.UpdateCDTimer)
                        }
                    }
                }
            }
        }

        this.StartTimer = (time, func) => {
            this.ClearTimer()
            this._timer_func = func
            this._end_time = time
            if (!this._timer) {
                this._timer = GlobalTimerQuest.AddPeriodQuest(() => {
                    this._timer_func()
                }, 1, -1)
            }

            this._timer_func()
        }

        this.UpdateTimer = () => {
            let rtime = this._end_time - TimeUtil.getServerTime()
            if (rtime > 0) {
                this._lb_time.text = TimeUtil.timeConvert(rtime, "hh:MM:ss")
            } else {
                this.ClearTimer()
                this._lb_time.text = "00:00:00"
            }
        }

        this.UpdateCDTimer = () => {
            let rtime = this._end_time - TimeUtil.getServerTime()
            if (rtime > 0) {
                this._lb_time_cd.text = TimeUtil.timeConvert(rtime, "hh:MM:ss")
            } else {
                this.ClearTimer()
                this._lb_time_cd.text = "00:00:00"
                let sub_type = this._act_info.sub_type
                this._model.Fire(CustomActivityDefine.EVENT.SCMD_REQUEST, 33155, sub_type)
            }
        }

        this.ClearTimer = () => {
            if (this._timer) {
                GlobalTimerQuest.CancelQuest(this._timer)
                this._timer = null
            }
        }
    }

    public CustomMehod = (index, info) => {
        this._act_info = info
    }

    public DeleteMe() {
        if (this._item_list) {
            for (let item of this._item_list) {
                item.DeleteMe()
            }
            this._item_list = undefined
        }
        this.ClearTimer()
        super.DeleteMe()
    }



    public GetComponents() {
        [
            this._img_002,
            this._Image1,
            this._Image2,
            this._Image3,
            this._Image4,
            this._Label1,
            this._Label2,
            this._Label3,
            this._lb_end,
            this._gp_time,
            this._lb_time_tips,
            this._lb_time_cd,
            this._gp_item,
            this._gp_pro,
            this._Image5,
            this._Image6,
            this._Image7,
            this._img_pro,
            this._btn_go,
            this._Image8,
            this._Label4,
            this._Label5,
            this._lb_time,
            this._lb_pro,
            this._lb_tips,
        ]
            = this.GetChildrenByNames([

                "_img_002",
                "_Image1",
                "_Image2",
                "_Image3",
                "_Image4",
                "_Label1",
                "_Label2",
                "_Label3",
                "_lb_end",
                "_gp_time",
                "_lb_time_tips",
                "_lb_time_cd",
                "_gp_item",
                "_gp_pro",
                "_Image5",
                "_Image6",
                "_Image7",
                "_img_pro",
                "_btn_go",
                "_Image8",
                "_Label4",
                "_Label5",
                "_lb_time",
                "_lb_pro",
                "_lb_tips",
            ])
    }
}
window["RedPacketRainView"] = RedPacketRainView
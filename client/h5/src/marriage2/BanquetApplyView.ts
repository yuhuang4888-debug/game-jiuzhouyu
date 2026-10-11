import { BanquetModel, BanqEvent } from "../commonModel/BanquetModel"
import { Enum_UILayer } from "../common/LayerManager"
import { TimeUtil } from "../util/TimeUtil"
import { GoodsModel } from "../commonModel/GoodsModel"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { LuaSoundManager } from "../common/SoundManager"
import { Util, GetSizeDeltaY, SetAnchoredPosition } from "../util/Util"
import { MarriageModel } from "../commonModel/MarriageModel"
import { table } from "../common/table"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { EquipmentItem } from "../common/EquipmentItem"
import { ApplyDateItem } from "./ApplyDateItem"
import { BanquetApplyItem } from "./BanquetApplyItem"
import { BaseView1 } from "../common/BaseView1"
import { OpenFun } from "../common/OpenFun"


export class BanquetApplyView extends BaseView1 {
    InitInfo
    InitView
    SetApplayData
    banModel
    change_scene_close
    dateArr
    date_loop_mgr
    destroy_callback
    destroy_imm
    is_center
    itemList
    preLoad_list
    preload_server_config
    select
    selectDay
    show_open_movie
    timeArr
    timeArr_loop_mgr: LoopScrowViewMgr
    timeCfg
    use_background
    Local_Open
    param_
    public constructor() {
        super();
        let res_mgr = ResManager.GetInstance()
        this.banModel = BanquetModel.GetInstance();
        this.select = 0;
        this.base_file = "marriage2"
        this.layout_file = "BanquetApplyView"
        //this.preLoad_list = ["marriage"]
        this.preload_server_config = {
            "config_wedding_time": false,
            "config_wedding_info": false
        }
        this.layer_value = Enum_UILayer.Activity
        this.is_center = true
        this.use_background = true
        this.show_open_movie = true
        this.change_scene_close = true
        this.destroy_imm = true

        // let local_eui = eui
        let local_TimeUtil = TimeUtil
        let local_Date = Date
        let goods_model = GoodsModel.GetInstance()
        this.load_callback = () => {

            this.banModel.Fire(BanqEvent.REQUET_PROTO, 17250)

            this.InitInfo()
            // if (PlatformManager.IsEyouEnPlatform()) {

            // let csf = this._Label1.GetComponent("ContentSizeFitter")
            // csf.horizontalFit = UnityEngin.UI.ContentSizeFitter.FitMode.Unconstrained
            // SetSizeDeltaX(this._Label1, 70)
            // SetAnchoredPosition(this._Label1, 315, -246)

            // csf = this._Label4.GetComponent("ContentSizeFitter")
            // csf.horizontalFit = UnityEngine.UI.ContentSizeFitter.FitMode.Unconstrained
            // SetSizeDeltaX(this._Label4, 75)
            // SetAnchoredPosition(this._Label4, 433, -310)
            // this._Label4.size = 18
            // this._Label4.lineSpacing = 0.6
            // this._Label2.size = 16
            // }
        }

        this.destroy_callback = () => {
            if (this.itemList) {
                for (let _tmpi in this.itemList) {
                    var vo = this.itemList[_tmpi]
                    vo.DeleteMe()
                }
                this.itemList = []
            }
            if (this.date_loop_mgr) {
                this.date_loop_mgr.DeleteMe()
                this.date_loop_mgr = null
            }
            if (this.timeArr_loop_mgr) {
                this.timeArr_loop_mgr.DeleteMe()
                this.timeArr_loop_mgr = null
            }

            if( this.param_ && this.param_.length>1){
                OpenFun.OpenFunHandler( this.param_ [0], this.param_ [1])
            }
        }




        this.InitInfo = () => {
            this.timeCfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_wedding_time", false);

            let model = this.banModel
            res_mgr.SetTexture(this, this._Image1, "resource/game/marriage2/texture/uijh_200.png")
            ResManager.GetInstance().SetOutsideImageSprite(this, this.BG1, GameResPath.GetIconJpg("marriage2", "uijh_135"), true)
            Util.AddClickEvent(this.closeBtn, () => {
                this.Close();
            }
                , this, true, null, null, null, null, LuaSoundManager.SOUND_UI.CLOSE)
            this.BindEvent(model, BanqEvent.APPLY_VIEW_DATA, (scmd?) => {
                this.InitView()
            }
            )
            this.InitView()
            if (this.select) {
                let scroll_to = this.select * 60
                if (scroll_to > GetSizeDeltaY(this.Content1) - GetSizeDeltaY(this.scroller)) {
                    scroll_to = GetSizeDeltaY(this.Content1) - GetSizeDeltaY(this.scroller)
                }
                SetAnchoredPosition(this.Content1, this.Content1.x, scroll_to)
            }
        }

        this.InitView = () => {
            let dayData = []
            let cur_timestamp = local_TimeUtil.getServerTime()
            let one_hour_timestamp = 24 * 60 * 60
            let showDay = MarriageModel.GetInstance().GetConstantData(19) || 5
            let i = 0
            do {
                let temp_time = cur_timestamp + one_hour_timestamp * i
                let date = new local_Date(temp_time * 1000)
                date.setHours(0)
                date.setMinutes(0)
                date.setSeconds(0)
                table.insert(dayData, { time: date.getTime() })
                i = i + 1
            } while ((i < showDay)
            )
            if (dayData) {
                if (!this.date_loop_mgr) {
                    let touch = (e?) => {
                        this.SetApplayData(e)
                        //this.selectDay = e.real_index
                    }
                    this.date_loop_mgr = new LoopScrowViewMgr()
                    this.date_loop_mgr.SetData(this.Content11, ApplyDateItem, dayData, LoopScrCon.Vertical, 0, touch);
                    // this.date_loop_mgr.SetSelectIndex(1)
                } else {
                    this.date_loop_mgr.replaceAll(dayData)
                }

            }
            let index = (this.date_loop_mgr && this.date_loop_mgr.select_index - 1) || 0
            this.SetApplayData(index)
            if (!this.itemList) {
                this.itemList = []
            }
            let rewadCfg = BanquetModel.GetInstance().ClientCfg
            if (rewadCfg) {
                let list = rewadCfg.reward
                if (list) {
                    let j = 0
                    do {
                        let item = this.itemList[j]
                        if (!item) {
                            item = new EquipmentItem(this.Content)
                            item.Load()
                            item.SetScale(0.4)
                            this.itemList[j] = item
                        }
                        let arr = goods_model.GetMappingTypeId(list[j][0], list[j][1]);
                        let typeId = arr[0], lock = arr[1];
                        let goodsVo = goods_model.GetGoodsBasicByTypeId(typeId)
                        if (goodsVo) {
                            let v = list[j][2]
                            item.ExcuteCallback(() => {
                                item.SetData(goodsVo.type_id, 0)
                            }
                            )
                        }
                        j = j + 1
                    } while ((j < list.length)
                    )
                }
            }
            // this.timeLb.text = Util.StrToHTML("婚礼时长:<font color=0xb3ff48>15</font>分钟")
        }

        this.SetApplayData = (day?) => {
            let time = local_TimeUtil.GetFutureZeroStamp(day)
            if (time) {
                let timeCfg = this.timeCfg
                let data = this.banModel.GetDayList()
                let applyedDate = null
                if (data) {
                    for (let _tmpi in data) {
                        var vo = data[_tmpi]
                        if (vo.order_unix_date == time) {
                            applyedDate = vo.time_list
                            break
                        }
                    }
                }
                let nowTime = new local_Date(local_TimeUtil.getServerTime() * 1000)
                let showData = []
                this.select = 0
                let applyedIndex = 0
                let selectIndex = 0
                if (applyedDate) {
                    let sort_func = (a?, b?) => {
                        return a.time_id < b.time_id
                    }
                    table.sort(applyedDate, sort_func)
                }
                let jumpIdx: number = -1;
                let count: number = 0;
                for (let index in timeCfg) {

                    let pushData = timeCfg[index]
                    pushData["day"] = day
                    if ((applyedDate && applyedDate[applyedIndex]) && applyedDate[applyedIndex].time_id == parseInt(index)) {
                        pushData["order_list"] = applyedDate[applyedIndex].order_list
                        applyedIndex = applyedIndex + 1
                        jumpIdx = count;
                    } else {
                        if (!(this.select > 0)) {
                            let begin_time = JSON.parse(pushData.begin_time)[1]
                            let h = Number(begin_time[0])
                            let m = Number(begin_time[1])
                            if (h > nowTime.getHours() || (h == nowTime.getHours() && m < nowTime.getMinutes())) {
                                this.select = selectIndex
                            }
                        }
                        pushData["order_list"] = null
                    }
                    selectIndex = selectIndex + 1
                    table.insert(showData, pushData);
                    if (jumpIdx == -1) {//找出可以预约的索引
                        let future_time = TimeUtil.GetFutureZeroStamp(pushData.day)
                        let begin_time = JSON.parse(pushData.begin_time);
                        let _time = future_time + Number(begin_time[0]) * 3600 + Number(begin_time[1]) * 60
                        let cur_time = TimeUtil.getServerTime();
                        if (cur_time < _time) {
                            jumpIdx = count;
                        }
                    }
                    count++;
                }
                if (showData.length > 0) {
                    let sort_func = (a?, b?) => {
                        return a.time_id < b.time_id
                    }
                    table.sort(showData, sort_func)
                }
                jumpIdx = jumpIdx - 1;//额外减一的话，可以让玩家看到一个已过期的信息，体验上会好点
                jumpIdx <= -1 ? 0 : jumpIdx;
                if (!this.timeArr_loop_mgr) {
                    if (showData.length > 0) {
                        this.timeArr_loop_mgr = new LoopScrowViewMgr();
                        this.timeArr_loop_mgr.SetData(this.Content1, BanquetApplyItem, showData, LoopScrCon.Vertical, jumpIdx);
                        // this.timeArr_loop_mgr.SetSelectIndex(1)
                    }
                } else {
                    this.timeArr_loop_mgr.replaceAll(showData);
                }
                this.ScrollVIndex(this.Content1, jumpIdx)
            }
        }


        this.Local_Open = (parms) => {
            this.param_ = parms
            super.Open()
        }
    }


    public Open(...parms) {
        this.Local_Open(parms)
    }


    public ScrollVIndex(list: Laya.List, leftIndex: number, itemHeight?: number, listHeight?: number) {
        if (listHeight == null) {
            listHeight = list.height;
        }
        if (itemHeight == null) {
            itemHeight = list.cells.length ? list.cells[0].height : 0;
        }
        itemHeight += list.spaceY;
        let offsetHeight = list.array.length * itemHeight - listHeight;
        list.scrollBar.value = Math.min(leftIndex * itemHeight, offsetHeight);
    }
    _Image1: Laya.Image
    _Image2: Laya.Image
    _Image3: Laya.Image
    BG1: Laya.Image
    BG2: Laya.Image
    closeBtn: Laya.Image
    _Image4: Laya.Image
    _Image5: Laya.Image
    _Image6: Laya.Image
    _Image7: Laya.Image
    _Image8: Laya.Image
    _Image9: Laya.Image
    _Scroller1: Laya.Panel
    Content: Laya.List
    scroller: Laya.Panel
    Content11: Laya.List
    _Scroller2: Laya.Panel
    Content1: Laya.List
    timeLb: Laya.Label
    _Label1: Laya.Label
    _Label2: Laya.Label
    _Label3: Laya.Label
    _Label4: Laya.Label
    _Label5: Laya.Label
    public GetComponents() {
        [
            this._Image1,
            this._Image2,
            this._Image3,
            this.BG1,
            this.BG2,
            this.closeBtn,
            this._Image4,
            this._Image5,
            this._Image6,
            this._Image7,
            this._Image8,
            this._Image9,
            this._Scroller1,
            this.Content,
            this.scroller,
            this.Content11,
            this._Scroller2,
            this.Content1,
            this.timeLb,
            this._Label1,
            this._Label2,
            this._Label3,
            this._Label4,
            this._Label5,
        ]
            = this.GetChildrenByNames([

                "_Image1",
                "_Image2",
                "_Image3",
                "BG1",
                "BG2",
                "closeBtn",
                "_Image4",
                "_Image5",
                "_Image6",
                "_Image7",
                "_Image8",
                "_Image9",
                "_Scroller1",
                "Content",
                "scroller",
                "Content11",
                "_Scroller2",
                "Content1",
                "timeLb",
                "_Label1",
                "_Label2",
                "_Label3",
                "_Label4",
                "_Label5",
            ])
    }
}
window["BanquetApplyView"] = BanquetApplyView
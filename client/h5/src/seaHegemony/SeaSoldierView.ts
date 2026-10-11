import { BaseItem1 } from "../common/BaseItem1"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { table } from "../common/table"
import { SeaHegemonyModel } from "../commonModel/SeaHegemonyModel"
import { Message } from "../sysInfo/SysInfoController"
import { HtmlColorTxt, SetHtmlCenter, SetHtmlStyle, Util } from "../util/Util"
import { SeaSoldierHeadItem } from "./SeaSoldierHeadItem"
import { SoldierArrItem } from "./SoldierArrItem"

export class SeaSoldierView extends BaseItem1 {
    InitView
    InitEvent
    soldierArr
    SetSoldierList
    SetButtonStatus
    Dispose
    public constructor(parent?) {

        super(parent)

        this.base_file = "seaHegemony"
        this.layout_file = "SeaSoldierView"
        let local_util = Util
        let local_model = SeaHegemonyModel
        let local_modelIns = local_model.GetInstance()
        let local_msg = Message
        this.load_callback = () => {
            SetHtmlStyle(this._Label2,{f:18,c:"#763320",w:720,ww:false})
            this.InitView()
            this.InitEvent()
        }

        let headList = null
        this.InitView = () => {
           

            this.SetSoldierList()
        }

        this.InitEvent = () => {
            Util.AddClickEvent(
                this.applyBtn, () => {
                    local_modelIns.Fire(local_model.REQUEST_PROTO, 18603)
                },
                this,
                true
            )
            Util.AddClickEvent(
                this.appointBtn, () => {
                    if (local_modelIns.isSeaKing) {
                        local_modelIns.Fire(local_model.OPEN_VIEW, "SeaAppointView")
                    } else {
                        local_msg.show("只有海域之王可操作")
                }
                },
                this,
                true
            )
            Util.AddClickEvent(
                this.SettingBtn, () => {
                    if (local_modelIns.isSeaKing) {
                        local_modelIns.Fire(local_model.OPEN_VIEW, "ApplySettingView")
                    } else {
                        local_msg.show("只有海域之王可操作")
                    }
                },
                this,
                true
            )
            Util.AddClickEvent(
                this.checkAppBtn, () => {
                    if (local_modelIns.isSeaKing) {
                        local_modelIns.Fire(local_model.OPEN_VIEW, "SeaSoldierApplyView")
                    } else {
                        local_msg.show("只有海域之王可操作")
                    }
                },
                this,
                true
            )
            this.BindEvent(
                local_modelIns,
                local_model.SOLDIER_INFO, () => {
                    this.SetSoldierList()
                }
            )
            this.BindEvent(
                local_modelIns,
                local_model.SOLDIER_APPLY, () => {
                    this.appyRed.visible = local_modelIns.isSeaKing && local_modelIns.applyRed
                }
            )
            local_modelIns.Fire(local_model.REQUEST_PROTO, 18601)
        }

        this.SetSoldierList = () => {
            let data = local_modelIns.seaSoldierData
            if (data) {
                let arrData = data.job_list
                let posList = {}
                for (let _tmpi in arrData) {
                    var vo = arrData[_tmpi]
                    if (!posList[vo.self_level]) {
                        posList[vo.self_level] = vo
                    }
                }
                table.sort(
                    arrData, (data1?, data2?) => {
                        if (data1.self_level != data2.self_level) {
                            return data1.self_level < data2.self_level
                        }
                        else if (data1.power != data2.power) {
                            return data1.power > data2.power
                        }
                        return false
                    }
                )
                if (!headList) {
                    headList = []
                }
                let i = 0
                do {
                    let item = headList[i]
                    if (!item) {
                        // [ts2lua]this下标访问可能不正确
                        item = new SeaSoldierHeadItem(this["headGp" +i])
                        item.Load()
                        headList[i] = item
                    }
                    // [ts2lua]posList下标访问可能不正确
                    item.SetData(posList[i+1] || { index: i+1 })
                    i = i + 1
                } while ((i < 3))

                let space_str='&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'
                let str1=`禁卫人数上限:${HtmlColorTxt(data.limit_num,"'#c85a37'")}`
                let str2=`已招募人数:${HtmlColorTxt(data.num + "/" + data.limit_num,"'#c85a37'")}`
                this._Label2.innerHTML=`${str1}${space_str}${str2}`
                SetHtmlCenter(this._Label2,{x:0,w:720})

                if(!this.soldierArr){
                    this.soldierArr = new LoopScrowViewMgr()
                    this.soldierArr.SetData(this.Content, SoldierArrItem,arrData,LoopScrCon.Vertical)
                }else{
                    this.soldierArr.replaceAll(arrData)
                }
              
                this.noLb.visible = data.num == 0
                this.noImg.visible = data.num == 0
            }
            this.SetButtonStatus()
        }

        this.SetButtonStatus = () => {
            let hasJoin = local_modelIns.hasJoinSoldier
            this.appointBtn.visible = hasJoin
            this.checkAppBtn.visible = hasJoin
            this.SettingBtn.visible = hasJoin
            this.applyBtn.visible = !hasJoin
            this.appyRed.visible = (hasJoin && local_modelIns.isSeaKing && local_modelIns.applyRed)
        }

        this.Dispose = () => {
            if (this.soldierArr) {
                this.soldierArr.DeleteMe()
                this.soldierArr = null
            }
            if (headList) {
                for (let _tmpi in headList) {
                    var vo = headList[_tmpi]
                    vo.DeleteMe()
                }
                headList = null
            }
        }
    }

    public DeleteMe() {

        this.Dispose()
        super.DeleteMe()
    }



Content:Laya.List
headGp0:Laya.Box
headGp1:Laya.Box
headGp2:Laya.Box
applyBtn:Laya.Box
_Image111:Laya.Image
labelDisplay1:Laya.Label
SettingBtn:Laya.Box
_Image11111:Laya.Image
labelDisplay11:Laya.Label
appointBtn:Laya.Box
_Image1:Laya.Image
labelDisplay111:Laya.Label
checkAppBtn:Laya.Box
_Image1111:Laya.Image
labelDisplay:Laya.Label
_Label1:Laya.Label
_Label2:Laya.HTMLDivElement
_Image11:Laya.Image
_Image2:Laya.Image
_Label4:Laya.Label
_Label5:Laya.Label
_Label6:Laya.Label
_Label7:Laya.Label
appyRed:Laya.Image
noLb:Laya.Label
noImg:Laya.Image
public GetComponents() {
[
this.Content,
this.headGp0,
this.headGp1,
this.headGp2,
this.applyBtn,
this._Image111,
this.labelDisplay1,
this.SettingBtn,
this._Image11111,
this.labelDisplay11,
this.appointBtn,
this._Image1,
this.labelDisplay111,
this.checkAppBtn,
this._Image1111,
this.labelDisplay,
this._Label1,
this._Label2,
this._Image11,
this._Image2,
this._Label4,
this._Label5,
this._Label6,
this._Label7,
this.appyRed,
this.noLb,
this.noImg,
]
 = this.GetChildrenByNames([

"Content",
"headGp0",
"headGp1",
"headGp2",
"applyBtn",
"_Image111",
"labelDisplay1",
"SettingBtn",
"_Image11111",
"labelDisplay11",
"appointBtn",
"_Image1",
"labelDisplay111",
"checkAppBtn",
"_Image1111",
"labelDisplay",
"_Label1",
"_Label2",
"_Image11",
"_Image2",
"_Label4",
"_Label5",
"_Label6",
"_Label7",
"appyRed",
"noLb",
"noImg",
])
}
}
 window["SeaSoldierView"]= SeaSoldierView
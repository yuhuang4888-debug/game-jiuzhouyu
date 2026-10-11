import { BaseItem1 } from "../common/BaseItem1"
import { EventName } from "../common/EventName"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { table } from "../common/table"
import { SeaHegemonyModel } from "../commonModel/SeaHegemonyModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { Util } from "../util/Util"
import { CountryPoliticalItem } from "./CountryPoliticalItem"

export class CountryPoliticalView extends BaseItem1 {

    InitEvent
    itemArr

    public constructor(parent?) {
        super(parent)

        this.base_file = "country"
        this.layout_file = "CountryPoliticalView"
        let local_model = SeaHegemonyModel
        let local_modelIns = local_model.GetInstance()
        let local_util = Util
        this.load_callback = () => {

            this.InitEvent()
        }

        this.InitEvent = () => {

            Util.AddClickEvent(
                this.soldierBtn, () => {
                    GlobalEventSystem.Fire(EventName.OPEN_VIEW, "CountryBaseView", 2)
                },
                this,
                true
            )
            Util.AddClickEvent(
                this.campBtn, () => {
                    local_modelIns.Fire(local_model.OPEN_VIEW, "CountryGuildView")
                },
                this,
                true
            )
            this.BindEvent(
                local_modelIns,
                local_model.UPDATE_PEOPLE_DATA, () => {
                    let data = []
                    for (let key in local_modelIns.peopleData) {

                        // [ts2lua]local_modelIns.peopleData下标访问可能不正确
                        for (let _tmpi in local_modelIns.peopleData[key]) {
                            var vo = local_modelIns.peopleData[key][_tmpi]
                            table.insert(data, vo)
                        }
                    }
                    this.nothingGp.visible = data.length == 0

                    if (!this.itemArr) {
                        this.itemArr = new LoopScrowViewMgr()
                        this.itemArr.SetData(this.Content, CountryPoliticalItem, data, LoopScrCon.Vertical)
                    }else{
                        this.itemArr.replaceAll(data)
                    }
                }
            )
            local_modelIns.peopleData = []
            local_modelIns.Fire(local_model.REQUEST_PROTO, 18654, "hh", 200, 1)
        }
    }

    public DeleteMe() {

        if (this.itemArr) {
            this.itemArr.DeleteMe()
            this.itemArr = null
        }
        super.DeleteMe()
    }



_Image1:Laya.Image
_Label1:Laya.Label
_Label2:Laya.Label
_Label3:Laya.Label
_Label4:Laya.Label
_Label5:Laya.Label
_Label6:Laya.Label
Content:Laya.List
soldierBtn:Laya.Box
_Image111:Laya.Image
labelDisplay:Laya.Label
campBtn:Laya.Box
_Image11:Laya.Image
labelDisplay1:Laya.Label
nothingGp:Laya.Box
_Image7:Laya.Image
_Label7:Laya.Label
public GetComponents() {
[
this._Image1,
this._Label1,
this._Label2,
this._Label3,
this._Label4,
this._Label5,
this._Label6,
this.Content,
this.soldierBtn,
this._Image111,
this.labelDisplay,
this.campBtn,
this._Image11,
this.labelDisplay1,
this.nothingGp,
this._Image7,
this._Label7,
]
 = this.GetChildrenByNames([

"_Image1",
"_Label1",
"_Label2",
"_Label3",
"_Label4",
"_Label5",
"_Label6",
"Content",
"soldierBtn",
"_Image111",
"labelDisplay",
"campBtn",
"_Image11",
"labelDisplay1",
"nothingGp",
"_Image7",
"_Label7",
])
}
}
 window["CountryPoliticalView"]= CountryPoliticalView
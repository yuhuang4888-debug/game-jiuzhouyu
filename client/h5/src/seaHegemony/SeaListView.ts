import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { SeaHegemonyModel } from "../commonModel/SeaHegemonyModel"
import { Util } from "../util/Util"
import { SeaHegemonyJoinItem } from "./SeaHegemonyJoinItem"

export class SeaListView extends BaseView1 {

    public constructor() {
        super()

        this.base_file = "seaHegemony"
        this.layout_file = "SeaListView"
        this.layer_value = Enum_UILayer.Activity
        this.use_background = true
        let local_model = SeaHegemonyModel
        let local_modelIns = local_model.GetInstance()
        this.is_center = true
        this.click_bg_toClose = true
        this.show_open_movie = true
        this.destroy_imm = true
        let itemList = null
        let posList = [[0, 0], [311, 0], [0, 478], [311, 478]]
        let InitEvent = () => {
            local_modelIns.Fire(local_model.REQUEST_PROTO, 18618)

            Util.AddClickEvent(this._con_bg,()=>{
                this.Close()
            },this)
        }

        this.load_callback = () => {

            if (!itemList) {
                itemList = []
            }
            let i = 0
            do {
                let item = new SeaHegemonyJoinItem(this._con_item)
                item.Load()
                item.SetPosition(posList[i][0], posList[i][1])
                item.SetData(i+1)
                itemList[i] = item
                i = i + 1
            } while ((i < 4))
            InitEvent()
        }

        this.destroy_callback = () => {
            if (itemList) {
                for (let _tmpi in itemList) {
                    var vo = itemList[_tmpi]
                    vo.DeleteMe()
                }
                itemList = null
            }
        }
    }

    public DeleteMe(): void {
        super.DeleteMe()
    }

_con_bg:Laya.Box
_con_item:Laya.Box
public GetComponents() {
[
this._con_bg,
this._con_item,
]
 = this.GetChildrenByNames([

"_con_bg",
"_con_item",
])
}
}
 window["SeaListView"]= SeaListView
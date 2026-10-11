import { BaseItem1 } from "../common/BaseItem1"
import { EventName } from "../common/EventName"
import { LayerManager } from "../common/LayerManager"
import { Point } from "../scene/AstarManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"


export class TopPlayerTipItem extends BaseItem1 {

    des: Laya.HTMLDivElement
    bg: Laya.Image
    LoadSuccess
    InitEvent
    tip
    ResizePos
    txt_width = 0
    html_txt_x= 32
    public constructor(parent?) {
        super(parent)
        this.base_file = "mainUI"
        this.layout_file = "TopPlayerTipItem"


        this.load_callback = () => {
            this.SetDes(this.tip)
            this.InitEvent()
        }

        this.LoadSuccess = () => {

        }

        this.InitEvent = () => {
            GlobalEventSystem.Bind(EventName.STATE_RESET_SIZE, () => {
                this.CallLater(this.ResizePos)
            })
        }

        this.ResizePos = () => {
            if (this.time_id_) {
                clearTimeout(this.time_id_)
                this.time_id_ = null
            }

            this.time_id_ = setTimeout(() => {
                if (this.use_delete_method) return

                let point_des: Laya.Point = this.display_obj.localToGlobal(new Laya.Point(0, 0))
                if ((point_des.x + this.txt_width-10) >= LayerManager.GetInstance().stageWidth) {
                    this.bg.scaleX = -1
                    this.des.x= this.html_txt_x - this.txt_width -5
                } else {
                    this.bg.scaleX = 1
                    this.des.x= this.html_txt_x-5
                }

                this.display_obj.visible=true
            }, 100);

        }

    }
    time_id_
    public SetDes(des) {
        this.tip = des
        if (this.is_loaded) {

            this.display_obj.visible=false

            this.des.style.fontSize = 20
            this.des.style.color = "#663915"
            this.des.style.wordWrap = false
            this.des.style.bold = true
            this.des.innerHTML = this.tip

            //49：文字右边距
            let left_padding = 55
            let con_width = this.des.contextWidth
            this.txt_width =con_width + left_padding// con_width >= 227 ? con_width + left_padding : 276
            this.bg.width =  this.txt_width 


            this.ResizePos()
        }

  

    }


    public DeleteMe() {
        if (this.time_id_) {
            clearTimeout(this.time_id_)
            this.time_id_ = null
        }

        super.DeleteMe()
    }



    public GetComponents() {
        [
            this.des,
            this.bg
        ]
            = this.GetChildrenByNames([

                "des",
                "bg"
            ])
    }
}
window["TopPlayerTipItem"] = TopPlayerTipItem
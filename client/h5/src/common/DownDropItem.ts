import { Message } from "../sysInfo/SysInfoController";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { SetHtmlCenter, Util } from "../util/Util"
import { BaseItem1 } from "./BaseItem1"
import { EventName } from "./EventName";

export class DownDropItem extends BaseItem1 {
    callback

    SetRes
    parent_obj
    data
    resType
    key
    index

    //是否自定义标题
    is_custom_html = false
    CustomHtml

    public constructor(parent) {
        super(parent)

        this.base_file = "common"
        this.layout_file = "DownDropItem"
        this.load_callback = () => {

            if (!this.is_custom_html) {
                this._lb_content.style.fontSize = 20
                this._lb_content.style.color = "#5A1C20"
                this._lb_content.style.valign = "middle"
            } else {
                this.CustomHtml()
            }



            // this._img_bg = this.GetChild("_img_bg").gameObject
            // this._lb_content = this.GetChild("_lb_content").gameObject.GetComponent("Text")
            // if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
            // 	this._lb_content.size  = 18
            // }
            Util.AddClickEvent(this._group, () => {
                this.onClick()
            }, this)

            this.UpdateItem()

        }


        this.SetRes = (type?) => {
            if (type && type == 2) {
                this.resType = 2
                this.layout_file = "DownDropItem2"

            }
        }

        this.CustomHtml = () => { }
    }


    public UpdateItem() {

        this._lb_content.width = this.parent_obj.width
        this._lb_content.innerHTML = Util.StrToHTML(this.key && this.data[this.key] || this.data)
        SetHtmlCenter(this._lb_content, { w: this.parent_obj.width - 10 }, { h: 47 })
    }

    public Init(index?, data?, callback?, key?, parent_obj?) {

        this.index = index
        this.data = data
        this.key = key
        this.callback = callback
        this.parent_obj = parent_obj
    }

    public onClick() {
        this.callback(this.key, this.data)
        GlobalEventSystem.Fire(EventName.DROP_ITEM_BE_CLICK)
        this.parent_obj = null
    }
    public DeleteMe() {
        super.DeleteMe()
    }


    _img_bg: Laya.Image
    _group: Laya.Box
    _lb_content: Laya.HTMLDivElement
    _img_split: Laya.Image
    public GetComponents() {
        [
            this._img_bg,
            this._group,
            this._lb_content,
            this._img_split,
        ]
            = this.GetChildrenByNames([

                "_img_bg",
                "_group",
                "_lb_content",
                "_img_split",
            ])
    }
}
window["DownDropItem"] = DownDropItem
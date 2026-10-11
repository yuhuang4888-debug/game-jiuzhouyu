import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { Mathf } from "../util/Mathf"
import { Util, SetAnchoredPosition, SetSizeDelta } from "../util/Util"
import { Vector2 } from "../util/Vector2"
import { BaseItem1 } from "./BaseItem1"
import { DownDropItem } from "./DownDropItem"
import { ResManager } from "./ResManager"
import { table } from "./table"

export class DownDropList extends BaseItem1 {
    CallBack
    curr_sorting_order1
    UpdateItems
    anim_list

    _item_height
    curr_sorting_order2
    data_list
    bg_img
    ani
    _btn_class
    key
    item_list
    _list
    height
    resType
    down
    parent_width
    uilayer
    Local_SetViewData

    Init
    UpdateView
    SetRes
    show_count
    _btn_gap
    parent_height

    is_cus_width = false
    cus_width = 100
    cus_cell_width = 100
    public constructor(parent) {
        super(parent)

        this.base_file = "common"
        this.layout_file = "DownDropList"
        this.anim_list = []
        this._btn_class = DownDropItem
        this._item_height = 47
        this._btn_gap = 6
        this.item_list = []
        this.load_callback = () => {

            this._scroller.vScrollBar.visible = false
            this.SetViewData()
        }


        this.Local_SetViewData = () => {
            this.UpdateView()
            this.CreateBackground()
            this.UpdateItems()
        }

        this.Init = (data_list?, CallBack?, parent_size?, uilayer?, show_count?, key?, down?, ani?, is_array?) => {
            this.data_list = data_list || {}
            this.CallBack = CallBack
            this.parent_width = parent_size.width
            this.parent_height = parent_size.height
            this.uilayer = uilayer
            this.key = key
            this.down = down
            this.ani = ani
            let length = Util.TableSize(this.data_list)
            this.show_count = show_count && Mathf.Min(length, show_count) || length
            // local_pairs = is_array && ipairs || pairs
        }



        this.UpdateView = () => {
            let h = 10 //(scroller上下间距
            let dis_h = h + this.show_count * (this._item_height + this._btn_gap)//item间距
            this.display_obj.height = dis_h
            this.display_obj.width = this.is_cus_width ? this.cus_width : this.parent_width
            if (this.down) {
                SetAnchoredPosition(this.display_obj, 0, this.parent_height + 5)
            } else {
                SetAnchoredPosition(this.display_obj, 0, - 10 - this.display_obj.height)
            }

            let xSzie = (this.resType && this.resType == 2) && (this.parent_width - 6) || (this.parent_width - 16)
            SetSizeDelta(this.content, xSzie, Util.TableSize(this.data_list) * (this._item_height + 6))

            if (this.ani) {
                this.ClearAni()
                // SetSizeDelta(this,this.parent_width, 0)
                // this.form.sizeDelta = Vector2()
                // let index = TweenLite.to(this, this.form, TweenLite.UiAnimationType.HEIGHT, this.height, 0.5, () => {
                //     this.ClearAni()
                // })
                // table.insert(this.anim_list, index)
            }
        }

        this.UpdateItems = () => {
            let btn_class = this._btn_class
            for (let key in this.data_list) {
                let info = this.data_list[key]
                let item = new btn_class(this.content)//new DownDropItem(this.content)
                item.Init(key, info, this.CallBack, this.key, this.display_obj)
                item.SetRes(this.resType)
                item.Load()
                item.ExcuteCallback(() => {
                    SetSizeDelta(item.display_obj, this.parent_width, this._item_height)
                })
                this.item_list[key] = item
            }


        }

        this.SetRes = (type?) => {
            if (type && type == 2) {
                this.resType = 2
                this._item_height = 38
                this._btn_gap = 4
                this.layout_file = "DownDropList2"
            }
        }

    }

    public SetViewData() {

        this.Local_SetViewData()
    }

    public ClearAni() {

        // for (let i = 0; i < this.anim_list.length; i++) {
        //     var v = this.anim_list[i]
        //     TweenLite.Stop(v)
        // }
        // this.anim_list = []
    }
    public DeleteMe() {

        this.ClearAni()

        for (let i in this.item_list) {
            var v = this.item_list[i]
            v.DeleteMe()
        }
        this.item_list = []
        this.curr_sorting_order1 = null
        this.curr_sorting_order2 = null
        super.DeleteMe()
    }


    public CreateBackground() {

        if (this._bg) {
            this.display_obj.addChildAt(this._bg, 1)
            SetSizeDelta(this._bg, 2 * 720 + 100, 2 * 1280 + 100)
            Util.AddClickEvent(this._bg, () => {
                this.DeleteMe()
            }, this)

        }
    }

    _bg: Laya.Image
    _img_bg: Laya.Image
    _scroller: Laya.Panel
    content: Laya.VBox
    public GetComponents() {
        [
            this._bg,
            this._img_bg,
            this._scroller,
            this.content,
        ]
            = this.GetChildrenByNames([

                "_bg",
                "_img_bg",
                "_scroller",
                "content",
            ])
    }
}
window["DownDropList"] = DownDropList
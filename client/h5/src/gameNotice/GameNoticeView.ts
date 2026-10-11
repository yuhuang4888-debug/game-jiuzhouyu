import { BaseItem1 } from "../common/BaseItem1";
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr";
import { WelfareModel, WelfareEvent, AdModuleId } from "../commonModel/WelfareModel"
import { LoginModel } from "../login/LoginModel";
import { GameNoticeContentItem } from "./GameNoticeContentItem";
import { GameNoticeListItem } from "./GameNoticeListItem";


export class GameNoticeView extends BaseItem1 {
    _img_next: Laya.Image
    _lab_title: Laya.Label
    _list_title: Laya.List
    _gp_content: Laya.Panel
    _gp_item: Laya.VBox

    LoadSuccess
    SwitchTab
    OnListScrollChange
    public constructor(parent?) {
        super(parent)

        this.base_file = 'gameNotice'
        this.layout_file = 'GameNoticeView'
        let model = WelfareModel.GetInstance(),
            login_model = LoginModel.GetInstance(),
            notice_loop_mgr,
            now_index,
            item_content = [],
            notice_list
        this.load_callback = () => {
            this.LoadSuccess()
        }
        this.LoadSuccess = () => {
            notice_list = login_model.GetInsideNoticeList()
            if (!notice_list || notice_list.length == 0) return
            this._list_title.vScrollBarSkin = ""
            let can_scroll = this._gp_content.vScrollBar.visible = false
            if (!notice_loop_mgr) {
                notice_loop_mgr = new LoopScrowViewMgr()
                notice_loop_mgr.SetData(this._list_title, GameNoticeListItem, notice_list, LoopScrCon.Vertical, 1, () => {
                    this.SwitchTab()
                }, null, null, null, false)
            } else {
                notice_loop_mgr.replaceAll(notice_list)
            }
            notice_loop_mgr.SetSelectIndex(0)
            can_scroll = this._list_title.scrollBar.value != this._list_title.scrollBar.max
            this._img_next.visible = can_scroll
            if (can_scroll) {
                this._list_title.scrollBar.changeHandler = Laya.Handler.create(this, this.OnListScrollChange, null, false)
            }
        }

        this.OnListScrollChange = (value) => {
            this._img_next.visible = value != this._list_title.scrollBar.max
        }
        this.SwitchTab = () => {
            let index = this._list_title.selectedIndex
            if (now_index == index) {
                return
            }
            now_index = index
            let data = notice_list[now_index]
            if (data) {
                this._gp_content.vScrollBar.stopScroll()
                this._gp_content.vScrollBar.value = 0
                for (let item of item_content) {
                    item.DeleteMe()
                }
                item_content = []
                this._lab_title.text = data.title
                let notice_cotent_ = data.content[0].content.split("\n\n##")
                if (notice_cotent_) {
                    for (let i = 0; i < notice_cotent_.length; i++) {
                        if (!notice_cotent_[i])
                            break
                        let item = item_content[i]
                        if (!item) {
                            item = new GameNoticeContentItem(this._gp_item)
                            item.Load()
                            item_content.push(item)
                        }
                        item.ExcuteCallback(() => {
                            item.SetData(notice_cotent_[i])
                        })
                    }
                }
            }
        }
        this.DeleteMe = () => {
            if (notice_loop_mgr) {
                notice_loop_mgr.DeleteMe()
                notice_loop_mgr = null
            }
            super.DeleteMe()
        }
    }

    public GetComponents() {
        [
            this._img_next,
            this._lab_title,
            this._list_title,
            this._gp_content,
            this._gp_item,
        ]
            = this.GetChildrenByNames([

                "_img_next",
                "_lab_title",
                "_list_title",
                "_gp_content",
                "_gp_item",
            ])
    }
}
window["GameNoticeView"] = GameNoticeView
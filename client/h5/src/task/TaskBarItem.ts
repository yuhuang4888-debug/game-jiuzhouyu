import { BaseItem1 } from "../common/BaseItem1"
import { TaskModel, TaskType, TaskTypeTitle } from "../commonModel/TaskModel";
import { SetLocalScale, Util } from "../util/Util";
import { TaskContentSubView } from "./TaskContentSubView";

export class TaskBarItem extends BaseItem1 {
    model
    now_height
    needRefresh
    sub_view
    data
    content_visible
    LoadSuccess
    InitEvents
    ShowContent
    SetData
    SetContentView
    public static BarHeight = 60;
    public constructor(parent?) {
        super(parent)
        this.needRefresh = false;
        this.content_visible = false;
        this.base_file = "task"
        this.layout_file = "TaskBarItem"
        this.model = TaskModel.GetInstance()
        let local_Util = Util
        this.load_callback = () => {
            this.LoadSuccess()
            this.InitEvents()
        }

        this.DeleteMe = () => {
            if (this.sub_view) {
                this.sub_view.DeleteMe()
                this.sub_view = null
            }
            super.DeleteMe();
        }

        this.LoadSuccess = () => {
            this.display_obj.height = 60
            this.content_visible = false
            this.now_height = 60
        }

        this.InitEvents = () => {
            let bar_click_fun = () => {
                if (this.data && this.data.data) {
                    this.model.Fire(TaskModel.CLICK_TASK_BAR_ITEM, this.data.data.task_id, true)
                }
            }
            local_Util.AddClickEvent(this.tab, bar_click_fun, this)

            let click_fun = (task_id?, force_reverse?) => {
                if ((this.data && this.data.data) && this.data.data.task_id == task_id) {
                    if (!force_reverse) {
                        if (!this.content_visible) {
                            this.ShowContent(!this.content_visible)
                        }
                    } else {
                        let bool = !this.content_visible
                        this.ShowContent(bool)
                    }
                } else {
                    this.ShowContent(false)
                }
            }

            this.BindEvent(this.model, TaskModel.CLICK_TASK_BAR_ITEM, click_fun)

            if (this.needRefresh) {
                this.SetData(this.data)
                this.needRefresh = false
            }
        }

        this.SetData = (data?) => {
            this.data = data
            if (this.is_loaded && this.data.data) {
                let task_name = TaskTypeTitle[this.data.type] + this.data.data.task_name
                if (!task_name) {
                    task_name = this.task_model.GetTaskNameTitle(this.data.task_id)
                }
                if (this.data.data.task_type == TaskType.MAIN_LINE) {
                    if (this.data.data.task_id > 100640) {
                        task_name = task_name
                    } else {
                        task_name = task_name + "" + this.data.data.main_line_order
                    }
                }
                this.tab_txt.text = task_name
                this.SetContentView(data)
            } else {
                this.needRefresh = true
            }
        }

        this.SetContentView = (data?) => {
            if (data) {
                if (!this.sub_view) {
                    this.sub_view = new TaskContentSubView(this.subCon)
                    this.sub_view.Load()
                }
                this.sub_view.SetData(this.data.data)
            }
        }

        this.ShowContent = (bool?) => {
            this.content_visible = bool
            this.subCon.visible = this.content_visible
            let scale = this.content_visible && 1 || 0
            SetLocalScale(this.subCon, 1, scale, 1)
            this.arrow.rotation = this.subCon.visible ? 0 : 180
            if (this.subCon.visible && this.sub_view) {
                this.now_height = TaskBarItem.BarHeight + this.sub_view.GetContentHeight()
            } else {
                this.now_height = TaskBarItem.BarHeight
            }
            this.display_obj.height = this.now_height
            this.model.Fire(TaskModel.REFRESH_SCROLL_SIZE)
        }
    }

    conta: Laya.Box
    tab: Laya.Box
    btn_img: Laya.Image
    img2: Laya.Image
    tab_txt: Laya.Label
    arrow: Laya.Image
    red_dot: Laya.Image
    subCon: Laya.VBox
    public GetComponents() {
        [
            this.conta,
            this.tab,
            this.btn_img,
            this.img2,
            this.tab_txt,
            this.arrow,
            this.red_dot,
            this.subCon,
        ]
            = this.GetChildrenByNames([

                "conta",
                "tab",
                "btn_img",
                "img2",
                "tab_txt",
                "arrow",
                "red_dot",
                "subCon",
            ])
    }
}
window["TaskBarItem"] = TaskBarItem
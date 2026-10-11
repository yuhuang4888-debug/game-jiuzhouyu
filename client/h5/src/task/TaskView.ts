import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager";
import { TaskModel } from "../commonModel/TaskModel"
import { Util } from "../util/Util";
import { TaskBarItem } from "./TaskBarItem";

export class TaskView extends BaseView1 {


    InitEvent
    RefreshPos
    _Local_Open
    LoadSuccess
    InitView
    SetTaskBar
    public constructor() {
        super()
        this.base_file = "task"
        this.layout_file = "TaskView"
        this.layer_value = Enum_UILayer.Activity
        this.destroy_imm = true
        this.use_background = true
        this.click_bg_toClose = true
        this.show_open_movie = true
        this.is_delay_callback = false
        this.is_center = true
        let model = TaskModel.GetInstance()
        let tab_bar_item_list_ = []
        let default_task_id_ = 1
        let task_data_ = null
        let local_TaskModel = TaskModel
        let local_Util = Util
        this.load_callback = () => {
            this.LoadSuccess()
            this.InitEvent()
        }
        this.open_callback = () => {
            this.InitView()
        }

        this.destroy_callback = () => {
            if (tab_bar_item_list_) {
                for (let _tmpi in tab_bar_item_list_) {
                    var item = tab_bar_item_list_[_tmpi]
                    item.DeleteMe()
                    item = null
                }
                tab_bar_item_list_ = []
            }
        }

        this.LoadSuccess = () => {
            this.scroll.vScrollBar.visible = false
            // ResManager.GetInstance().SetOutsideImageSprite(this, this.bg, "resource/game/task/texture/uixrw_001a.png", true)
            tab_bar_item_list_ = []
        }

        this.InitEvent = () => {
            local_Util.AddClickEvent(this.closeBtn, () => {
                this.Close()
            }, this, true, null, null, null, null)

            this.BindEvent(model, local_TaskModel.REFRESH_SCROLL_SIZE, () => {
                this.RefreshPos()
            })

            let task_change_fun = () => {
                if (this.use_delete_method) {
                    return
                }
                this.InitView()
            }
            this.BindEvent(model, local_TaskModel.UPDATE_ALL_TASK_FROM_30000, task_change_fun)

            let click_fun = (task_id?, force_reverse?) => {
                default_task_id_ = task_id
                // model.show_task_id = default_task_id_
            }
            this.BindEvent(model, local_TaskModel.CLICK_TASK_BAR_ITEM, click_fun)
        }

        this._Local_Open = (param?) => {
            if (param) {
                let [default_task_id] = param
                default_task_id_ = default_task_id || model.now_select_task_id
            }
            super.Open()
        }

        this.InitView = () => {
            task_data_ = model.GetTaskData()
            if (task_data_ && task_data_.length > 0) {
                this.SetTaskBar(task_data_)
            }
        }

        this.SetTaskBar = (task_data?) => {
            if (task_data) {
                let bar = null
                let find = false
                let i = 0
                let call_back_index = 0


                let select_fun = ()=>{
                    if (!this.use_delete_method && call_back_index == task_data.length && default_task_id_){
                        model.Fire(local_TaskModel.CLICK_TASK_BAR_ITEM, default_task_id_)
                        call_back_index = 0
                    }
                }

                do {
                    bar = tab_bar_item_list_[i]
                    if (!bar) {
                        bar = new TaskBarItem(this.Content)
                        bar.Load()
                        tab_bar_item_list_[i] = bar
                    }
                    bar.SetVisible(true)
                    bar.SetData(task_data[i])
                    if (((default_task_id_ && task_data[i]) && task_data[i].data) && task_data[i].data.task_id == default_task_id_) {
                        find = true
                    }
                    bar.ExcuteCallback(()=>{
                        call_back_index = call_back_index + 1
                        select_fun()
                    })
                    i = i + 1
                } while ((i < task_data.length))

                let item = null
                let j = task_data.length
                do {
                    item = tab_bar_item_list_[j]
                    if ((item)) {
                        item.SetVisible(false)
                    }
                    j = j + 1
                } while ((j < tab_bar_item_list_.length))

                if (!find) {
                    default_task_id_ = null
                }
                if (((!default_task_id_ && task_data[0]) && task_data[0].data) && task_data[0].data.task_id) {
                    default_task_id_ = task_data[0].data.task_id
                }
                select_fun()
            }
        }

        this.RefreshPos = () => {
            if (task_data_) {
                let now_show_index = 0
                let item = null
                let now_show_height = 0
                let i = 0
                let all_height = 0
                do {
                    item = tab_bar_item_list_[i]
                    if (item && item.subCon) {
                        if (item.subCon.visible == true) {
                            now_show_index = i
                            now_show_height = item.now_height
                        }
                        all_height = all_height + item.now_height
                    }
                    i = i + 1
                } while ((i < tab_bar_item_list_.length))
                this.Content.height = all_height + 60
                this.Content.refresh()
                let now_bar_height = now_show_index * TaskBarItem.BarHeight
                if (now_show_index > 0) {
                    if (all_height < this.scroll.height) {
                        
                        this.scroll.scrollTo(0, 0)
                    } else {
                        if (now_bar_height > all_height - this.scroll.height) {
                            this.scroll.scrollTo(0, all_height - this.scroll.height)
                        } else {
                            this.scroll.scrollTo(0, now_bar_height)
                        }
                    }
                } else {
                    this.scroll.scrollTo(0, 0)
                }
            }
        }
    }

    public Open(...new_args) {
        this._Local_Open(...new_args)
    }

    bg: Laya.Image
    image1: Laya.Image
    image2: Laya.Image
    image3: Laya.Image
    closeBtn: Laya.Image
    scroll: Laya.Panel
    Content: Laya.VBox
    public GetComponents() {
        [
            this.bg,
            this.image1,
            this.image2,
            this.image3,
            this.closeBtn,
            this.scroll,
            this.Content,
        ]
            = this.GetChildrenByNames([

                "bg",
                "image1",
                "image2",
                "image3",
                "closeBtn",
                "scroll",
                "Content",
            ])
    }
}
window["TaskView"] = TaskView
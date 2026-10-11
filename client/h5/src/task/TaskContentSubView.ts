import { BaseItem1 } from "../common/BaseItem1"
import { EquipmentItem } from "../common/EquipmentItem";
import { WordManager } from "../common/WordManager";
import { GoodsModel } from "../commonModel/GoodsModel";
import { TaskModel, TaskType } from "../commonModel/TaskModel";
import { RoleManager } from "../commonModel/RoleManager";
import { ErlangParser } from "../util/ErlangParser";
import { Util } from "../util/Util";
import { TaskView } from "./TaskView";

export class TaskContentSubView extends BaseItem1 {


    model:TaskModel
    data_
    item_list_
    is_delay_callback

    GetContentHeight
    SetTaskReward
    SetData
    InitEvents
    LoadSuccess

    public static Height = 410
    public constructor(parent?) {
        super(parent)
        this.base_file = "task"
        this.layout_file = "TaskContentSubView"
        this.is_delay_callback = false
        this.model = TaskModel.GetInstance()
        let needRefresh_ = false
        this.data_ = null
        this.item_list_ = null
        let local_Util = Util
        this.load_callback = () => {
            this.LoadSuccess()
            this.InitEvents()
        }

        this.DeleteMe = () => {
            if (this.item_list_) {
                for (let _tmpi in this.item_list_) {
                    var item = this.item_list_[_tmpi]
                    item.DeleteMe()
                    item = null
                }
                this.item_list_ = null
            }
            super.DeleteMe();
        }

        this.LoadSuccess = () => {
            this._Scroller1.hScrollBar.visible = false
            this.item_list_ = []
        }

        this.InitEvents = () => {
            let do_task_fun = () => {
                if (this.data_) {
                    this.task_model.Fire(TaskModel.CLICK_DO_TASK, this.data_.task_id, this.data_.task_type)
                    if (this.data_.has_finish == 1 && this.data_.task_type != TaskType.REINCARNATION && !this.task_model.IsFindNpcTask(this.data_.task_tips_type)) {
                        this.model.Fire(TaskModel.REQUEST_CCMD_EVENT, 30004, this.data_.task_id)
                        //} else if (this.data_.task_type == TaskType.REINCARNATION && ReincarnationModel.GetInstance().IsFinishStageTask() ) {
                        //OpenFun.OpenFunHandler(18)
                    } else {
                        this.model.DoTask(this.data_, null, null, null, true)
                        this.model.Fire(TaskModel.TASK_CLOSE_VIEW, "TaskView")
                    }
                }
            }
            local_Util.AddClickEvent(this.finishBtn, do_task_fun, this, true)
            local_Util.AddClickEvent(this.goBtn, do_task_fun, this, true)

            let update_reward = (task_id?) => {
                if (this.data_ && this.data_.task_id == task_id) {
                    let task = this.task_model.GetAllTaskList(task_id)
                    if (task && task[0]) {
                        this.data_ = task[0]
                        this.SetData(this.data_)
                    }
                }
            }
            this.BindEvent(this.task_model, TaskModel.UPDATE_CIRCLE_TASK_REWARD, update_reward)

            if (needRefresh_) {
                this.SetData(this.data_)
                needRefresh_ = false
            }
        }

        this.SetData = (data?) => {
            this.data_ = data
            if (this.data_ && this.is_loaded) {
                let tip_str = ""
                this.finishBtn.visible = this.data_.has_finish == 1
                this.goBtn.visible = this.data_.has_finish != 1
                let task_tips_msg = this.model.GetTaskTipsMsg(this.data_)
                if (this.data_.has_finish == 1) {
                    tip_str = task_tips_msg + "<font color='#0a953e'>(完成)</font>"
                } else {
                    if (this.data_.show_num > 0) {
                        let now_str = WordManager.FormatNumber(this.data_.show_num)
                        tip_str = task_tips_msg + "<font color='#ff4f50'>(0/" + now_str + ")</font>"
                    } else {
                        let now_str = WordManager.FormatNumber(this.data_.now_num)
                        let need_str = WordManager.FormatNumber(this.data_.need_num)
                        // [ts2lua]lua中0和空字符串也是true，此处this.data_.need_num > this.data_.now_num需要确认
                        let color_str = (this.data_.need_num > this.data_.now_num && ("#ff4f50") || ("#0a953e"))
                        tip_str = task_tips_msg + "<font color='" + color_str + "'>(" + now_str + "/" + need_str + ")</font>"
                    }
                }
                // this.task_target.text = Util.StrToHTML((tip_str).trim())
                // this.task_target.visible = false
                this.task_target2.style.color = "#663915"
                this.task_target2.style.fontSize = 20
                this.task_target2.width = 388
                this.task_target2.height = 54
                this.task_target2.innerHTML = tip_str   
                this.task_target2.style.padding = [(this.task_target2.height - this.task_target2.contextHeight) / 2, 0, 0, 0]
                
                // this.task_target2.innerHTML = "<font style='fontSize:20' color='#67fc2c'>测试测试测试测试测试测试测试测试测试测试</font>"


                this.content.text = (this.data_.desc).trim()
                this.SetTaskReward()
            } else {
                needRefresh_ = true
            }
        }

        this.SetTaskReward = () => {
            if (!this.data_) {
                return
            }
            let award_list = []
            if (this.data_.task_type == TaskType.GUILD || this.data_.task_type == TaskType.DAILY) {
                if (this.data_.circle_task_normal_reward) {
                    let format_fun = (list?) => {
                        for (let _tmpi in list) {
                            var vo = list[_tmpi]
                            let obj = []
                            obj[0] = vo.type
                            obj[1] = vo.type_id
                            obj[2] = vo.count
                            award_list.push(obj)
                        }
                    }

                    format_fun(this.data_.circle_task_normal_reward)
                    format_fun(this.data_.circle_task_extra_reward)
                }
            } else {
                if (this.data_.special_goods_list) {
                    let list = ErlangParser.GetInstance().Parse(this.data_.special_goods_list)
                    if (list) {
                        for (let _tmpi in list) {
                            var vo = list[_tmpi]
                            if (Number(vo[0]) == RoleManager.GetInstance().mainRoleInfo.career) {
                                let obj = null
                                obj = []
                                obj[0] = 0
                                obj[1] = Number(vo[2])
                                obj[2] = Number(vo[3])
                                award_list.push(obj)
                            }
                        }
                    }
                }
                let list2 = ErlangParser.GetInstance().Parse(this.data_.award_list)
                if (list2) {
                    for (let _tmpi in list2) {
                        var vo = list2[_tmpi]
                        award_list.push(vo)
                    }
                }
            }
            if (this.item_list_) {
                for (let _tmpi in this.item_list_) {
                    var item = this.item_list_[_tmpi]
                    item.SetVisible(false)
                }
            }
            this.reward_con.visible = award_list && award_list.length > 0
            if (award_list && award_list.length) {
                let item = null
                let vo = null
                let i = 0
                do {
                    vo = award_list[i]
                    if (vo) {
                        item = this.item_list_[i]
                        if (!item) {
                            item = new EquipmentItem(this.Content)
                            this.item_list_[i] = item
                            item.Load()
                            item.SetScale(0.6)
                        }
                        item.SetVisible(true)
                        let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(vo[0], vo[1])
                        item.SetData(type_id, vo[2])
                    }
                    i = i + 1
                } while ((i < award_list.length))
            }
        }

        this.GetContentHeight = () => {
            return TaskContentSubView.Height
        }
    }
    
    _Image1: Laya.Image
    task_name: Laya.Label
    content: Laya.Label
    state_icon: Laya.Image
    image3: Laya.Image
    image4: Laya.Image
    _Image2: Laya.Image
    _Label2: Laya.Label
    _Label1: Laya.Label
    _Image3: Laya.Image
    task_target: Laya.Label
    task_target2: Laya.HTMLDivElement
    reward_con: Laya.Box
    _Image5: Laya.Image
    _Label3: Laya.Label
    _Scroller1: Laya.Panel
    Content: Laya.HBox
    finishBtn: Laya.Box
    _Image11: Laya.Image
    labelDisplay1: Laya.Label
    goBtn: Laya.Box
    _Image111: Laya.Image
    labelDisplay: Laya.Label
    public GetComponents() {
        [
            this._Image1,
            this.task_name,
            this.content,
            this.state_icon,
            this.image3,
            this.image4,
            this._Image2,
            this._Label2,
            this._Label1,
            this._Image3,
            this.task_target,
            this.task_target2,
            this.reward_con,
            this._Image5,
            this._Label3,
            this._Scroller1,
            this.Content,
            this.finishBtn,
            this._Image11,
            this.labelDisplay1,
            this.goBtn,
            this._Image111,
            this.labelDisplay,
        ]
            = this.GetChildrenByNames([

                "_Image1",
                "task_name",
                "content",
                "state_icon",
                "image3",
                "image4",
                "_Image2",
                "_Label2",
                "_Label1",
                "_Image3",
                "task_target",
                "task_target2",
                "reward_con",
                "_Image5",
                "_Label3",
                "_Scroller1",
                "Content",
                "finishBtn",
                "_Image11",
                "labelDisplay1",
                "goBtn",
                "_Image111",
                "labelDisplay",
            ])
    }
}
window["TaskContentSubView"] = TaskContentSubView
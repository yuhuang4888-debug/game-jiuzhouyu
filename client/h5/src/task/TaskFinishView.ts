import { BaseView1 } from "../common/BaseView1";
import { EquipmentItem } from "../common/EquipmentItem";
import { SceneEventType } from "../common/EventName";
import { Enum_UILayer } from "../common/LayerManager";
import { ResManager } from "../common/ResManager";
import { WordManager } from "../common/WordManager";
import { GoodsModel } from "../commonModel/GoodsModel";
import { TaskModel, TaskType } from "../commonModel/TaskModel";
import { RoleManager } from "../commonModel/RoleManager";
import { SceneManager } from "../scene/SceneManager";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { ErlangParser } from "../util/ErlangParser";
import { GlobalTimerQuest, Util } from "../util/Util";

export class TaskFinishView extends BaseView1 {

    task_vo
    model: TaskModel
    item_list
    close_time = 10
    has_send = false
    time_event_id
    public constructor() {
        super()
        this.base_file = "task"
        this.layout_file = "TaskFinishView"
        this.layer_value = Enum_UILayer.Activity
        this.destroy_imm = true
        this.use_background = true
        this.click_bg_toClose = true
        this.show_open_movie = true
        this.is_delay_callback = false
        this.is_center = true

        this.model = TaskModel.GetInstance()

        this.load_callback = () => {
            this.LoadSuccess()
            this.InitEvent()
        }

        this.open_callback = () => {
            this.InitView()
        }

        this.destroy_callback = () => {
            this.has_send = false
            this.CancelTime()
            if (this.item_list) {
                for (let _tmpi in this.item_list) {
                    var item = this.item_list[_tmpi]
                    item.DeleteMe()
                    item = null
                }
                this.item_list = null
            }
            if (this.finifsh_effect) {
                this.ClearUIEffect(this.finifsh_effect)
            }
        }
    }

    public LoadSuccess = () => {
        this._panel_reward.hScrollBarSkin = ""
        this._html_task_target.style.color = "#663915"
        this.close_time = 10
    }

    public InitEvent = () => {
        let do_task_fun = () => {
            if (this.task_vo) {
                let finish = this.task_model.IsAllStepFinish(this.task_vo.task_id)
                if (finish) {
                    //this.task_model.Fire(TaskModel.CLICK_DO_TASK, this.task_vo.task_id, this.task_vo.task_type)
                    this.model.finish_task_vo = null
                    this.has_send = true
                    this.model.Fire(TaskModel.REQUEST_CCMD_EVENT, 30004, this.task_vo.task_id)
                    this.Close()
                }
            }
        }
        Util.AddClickEvent(this._box_finish, do_task_fun, this, true)

        Util.AddClickEvent(this._img_close, () => {
            this.Close()
        }, this, true, null, null, null, null)

        this.BindEvent(GlobalEventSystem, SceneEventType.SCENE_CHANGED, () => {
            if (!SceneManager.GetInstance().IsFieldScene()) {
                if (!this.has_send) {
                    this.model.finish_task_vo = this.task_vo
                }
                this.Close()
            }
        }
        )
    }

    public InitView = () => {
        if (!this.task_vo) {
            return
        }
        let tip_str = ""
        let finish = this.task_model.IsAllStepFinish(this.task_vo.task_id)
        this._box_finish.visible = finish
        let task_tips_msg = this.model.GetTaskTipsMsg(this.task_vo)
        if (finish) {
            tip_str = task_tips_msg + "<font color='#0a953e'>(完成)</font>"
            //this:AddUIEffect2("ui_completionoftask", this.finifsh_effect, null, null, true)
        } else {
            if (this.task_vo.show_num) {
                let now_str = WordManager.FormatNumber(this.task_vo.show_num)
                tip_str = task_tips_msg + "(<font color='#ff4f50'>0/" + now_str + ")</font>"
            } else {
                let now_str = WordManager.FormatNumber(this.task_vo.now_num)
                let need_str = WordManager.FormatNumber(this.task_vo.need_num)
                let color_str = (this.task_vo.need_num > this.task_vo.now_num && ("#ff4f50") || ("#0a953e"))
                tip_str = task_tips_msg + "(<font color='" + color_str + "'>" + now_str + "/" + need_str + ")</font>"
            }
        }
        this._html_task_target.style.fontSize = 20
        // this._html_task_target.style.valign = "center"
        this._html_task_target.innerHTML = Util.StrToHTML((tip_str).trim())
        // this._html_task_target.style.padding = [(this._html_task_target.height - this._html_task_target.contextHeight) / 2, 0, 0, 0];     //垂直居中
        this._lb_content.text = Util.StrToHTML((this.task_vo.desc).trim())
        this.SetTaskReward()
        this.StartTime()
    }

    public SetTaskReward = () => {
        if (!this.task_vo) {
            return
        }
        let award_list = []
        if (this.task_vo.task_type == TaskType.GUILD || this.task_vo.task_type == TaskType.DAILY) {
            if (this.task_vo.circle_task_normal_reward) {
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

                format_fun(this.task_vo.circle_task_normal_reward)
                format_fun(this.task_vo.circle_task_extra_reward)
            }
        } else {
            if (this.task_vo.special_goods_list) {
                let list = ErlangParser.GetInstance().Parse(this.task_vo.special_goods_list)
                if (list) {
                    for (let _tmpi in list) {
                        var vo = list[_tmpi]
                        if (Number(vo[1]) == RoleManager.GetInstance().mainRoleInfo.career) {
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
            let list2 = ErlangParser.GetInstance().Parse(this.task_vo.award_list)
            if (list2) {
                for (let _tmpi in list2) {
                    var vo = list2[_tmpi]
                    award_list.push(vo)
                }
            }
        }
        //悬赏任务经验值
        if (this.task_vo.task_type == TaskType.EUDAEMON_TASK) {
            let role_lv = RoleManager.GetInstance().GetMainRoleLevel()
            let obj = [5, 0, Math.ceil(21000000 * Math.pow(1.5, (role_lv - 60) / 120))]
            award_list.push(obj)
        }
        if (this.item_list) {
            for (let _tmpi in this.item_list) {
                var item = this.item_list[_tmpi]
                item.SetVisible(false)
            }
        }
        this._box_reward.visible = award_list && award_list.length > 0
        if (this._box_reward.visible) {
            this._lb_finish.text = "领取奖励"
        } else {
            this._lb_finish.text = "提交任务"
        }
        if(!this.item_list){
            this.item_list = []
        }
        if (award_list && award_list.length) {
            let item = null
            let vo = null
            let i = 0
            do {
                vo = award_list[i]
                if (vo) {
                    item = this.item_list[i]
                    if (!item) {
                        item = new EquipmentItem(this._hbox_reward)
                        this.item_list[i] = item
                        item.Load()
                        item.SetScale(0.6)
                    }
                    let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(vo[0], vo[1])
                    item.SetData(type_id, vo[2])
                }
                i = i + 1
            } while ((i < award_list.length))
            // this.Content.width = award_list.length * 80
        }
    }

    public StartTime = () => {
        this.CancelTime()
        if (!this.task_model.GetAutoTaskSetting()) {
            if (this._lb_count_down) {
                this._lb_count_down.text = ""
            }
            return
        }
        var peorid_func = () => {
            if (!this.use_delete_method) {
                this.OnTime()
            }
        }
        this.time_event_id = GlobalTimerQuest.AddPeriodQuest(peorid_func, 1, -1)
        peorid_func()
    }

    public OnTime = () => {
        this.close_time = this.close_time - 1
        if (this.close_time <= 0) {
            this._lb_count_down.text = ""
            if (this.task_vo) {
                if (this.task_vo.has_finish == 1) {
                    this.model.Fire(TaskModel.REQUEST_CCMD_EVENT, 30004, this.task_vo.task_id)
                    this.Close()
                }
            }
            return
        }
        this._lb_count_down.text = this.close_time + "s后自动提交任务"
    }

    public CancelTime = () => {
        if (this.time_event_id) {
            GlobalTimerQuest.CancelQuest(this.time_event_id)
            this.time_event_id = null
        }
    }

    public Open(...params) {
        this.task_vo = params[0]
        super.Open()
    }
    _img_bg: Laya.Image
    _img_bg2: Laya.Image
    _lb_title: Laya.Label
    finifsh_effect: Laya.Box
    _img_close: Laya.Image
    _img_bg3: Laya.Image
    _lb_content: Laya.Label
    _lb_title2: Laya.Label
    icon_tag: Laya.Image
    _img_bg4: Laya.Image
    _lb_desc: Laya.Label
    _lb_task_target: Laya.Label
    _html_task_target: Laya.HTMLDivElement
    _box_reward: Laya.Box
    _lb_desc2: Laya.Label
    _panel_reward: Laya.Panel
    _hbox_reward: Laya.HBox
    _box_finish: Laya.Box
    _img_finish: Laya.Image
    _lb_finish: Laya.Label
    _lb_count_down: Laya.Label
    public GetComponents() {
        [
            this._img_bg,
            this._img_bg2,
            this._lb_title,
            this.finifsh_effect,
            this._img_close,
            this._img_bg3,
            this._lb_content,
            this._lb_title2,
            this.icon_tag,
            this._img_bg4,
            this._lb_desc,
            this._lb_task_target,
            this._html_task_target,
            this._box_reward,
            this._lb_desc2,
            this._panel_reward,
            this._hbox_reward,
            this._box_finish,
            this._img_finish,
            this._lb_finish,
            this._lb_count_down,
        ]
            = this.GetChildrenByNames([

                "_img_bg",
                "_img_bg2",
                "_lb_title",
                "finifsh_effect",
                "_img_close",
                "_img_bg3",
                "_lb_content",
                "_lb_title2",
                "icon_tag",
                "_img_bg4",
                "_lb_desc",
                "_lb_task_target",
                "_html_task_target",
                "_box_reward",
                "_lb_desc2",
                "_panel_reward",
                "_hbox_reward",
                "_box_finish",
                "_img_finish",
                "_lb_finish",
                "_lb_count_down",
            ])
    }
}
window["TaskFinishView"] = TaskFinishView
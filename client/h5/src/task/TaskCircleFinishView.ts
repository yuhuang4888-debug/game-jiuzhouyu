import { BaseView1 } from "../common/BaseView1";
import { EquipmentItem } from "../common/EquipmentItem";
import { SceneEventType } from "../common/EventName";
import { Enum_UILayer } from "../common/LayerManager";
import { WordManager } from "../common/WordManager";
import { GoodsModel } from "../commonModel/GoodsModel";
import { TaskModel, TaskType } from "../commonModel/TaskModel";
import { SceneManager } from "../scene/SceneManager";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { GlobalTimerQuest, Util } from "../util/Util";
import { TimeUtil } from "../util/TimeUtil"
import { RoleManager } from "../commonModel/RoleManager";
import { PlatformManager } from "../PlatformManager";

export class TaskCircleFinishView extends BaseView1 {

    model: TaskModel
    item_list
    item_list2
    task_vo
    close_time = 10
    time_event_id
    has_send

    public constructor() {
        super()
        this.base_file = "task"
        this.layout_file = "TaskCircleFinishView"
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
            if (PlatformManager.IsEyouEnPlatform()) {
                this._lb_reward.pos(44,167)
                this._panel_reward.pos(159,190)
            }
            this.UpdateView()
        }

        this.destroy_callback = () => {
            this.CancelTime()
            if (this.item_list) {
                for (let _tmpi in this.item_list) {
                    var item = this.item_list[_tmpi]
                    item.DeleteMe()
                }
                this.item_list = undefined
            }

            if (this.item_list2) {
                for (let _tmpi in this.item_list2) {
                    var item = this.item_list2[_tmpi]
                    item.DeleteMe()
                }
                this.item_list2 = undefined
            }
        }
    }

    public LoadSuccess = () => {
        this._panel_reward.hScrollBarSkin = ""
        this._panel_total_reward.hScrollBarSkin = ""

        this._html_target.style.color = "#663915"
        this._html_target.style.wordWrap = false
        this._html_target.style.fontSize = 20
        this._html_target.style.bold = true
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

                    //由于日常奖励直接发背包，这里模拟下恭喜获得
                    let [finish_num, all_num] = this.model.GetCicleTaskProgressByTaskType(this.task_vo.task_type)
                    //前后端约定的,10轮奖励
                    if(finish_num % 10 == 0){
                        let reward_list = []
                        if (this.task_vo.circle_task_normal_reward) {
                            let format_fun = (list?) => {
                                for (let _tmpi in list) {
                                    var vo = list[_tmpi]
                                    reward_list.push([vo.type, vo.type_id, vo.count])
                                }
                            }
                
                            format_fun(this.task_vo.circle_task_normal_reward)
                            format_fun(this.task_vo.circle_task_extra_reward)
                        }
                        Util.ShowCongratulationView(reward_list)
                    }
                }
            }
        }
        Util.AddClickEvent(this._img_get, do_task_fun, this, true)

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
        })

        this.BindEvent(this.task_model, TaskModel.UPDATE_CIRCLE_TASK_PROGRESS, () => {
            this.UpdateCircle()
        })
    }

    public UpdateView = () => {
        if (!this.task_vo) {
            return
        }
        let tip_str = ""
        let finish = this.task_model.IsAllStepFinish(this.task_vo.task_id)
        let task_tips_msg = this.model.GetTaskTipsMsg(this.task_vo)

        if (finish) {
            tip_str = task_tips_msg + "<font color='#0a953e'>(完成)</font>"
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


        this._html_target.innerHTML = `任务目标：${Util.StrToHTML((tip_str).trim())}`

        if (this.task_vo.task_type == TaskType.GUILD) {
            this._lb_title.text = "结社任务"
        } else if (this.task_vo.task_type == TaskType.DAILY) {
            this._lb_title.text = "日常任务"
        }


        this.UpdateNormalReward()
        this.UpdateExtraReward()
        this.UpdateCircle()
        this.StartTime()
    }

    public UpdateCircle = () => {
        let [finish_num, all_num] = this.model.GetCicleTaskProgressByTaskType(this.task_vo.task_type)
        //3默认偏移 每段加36 默认图片10段
        finish_num = finish_num % 10
        if (finish_num == 0) {
            finish_num = 10
        }
        this._lb_circle.text = `当前环数：第${finish_num}环`
        this._img_progress.width = 3 + finish_num * 36
        this._img_bg7.visible = finish_num == 10
    }

    public UpdateNormalReward = () => {
        if (!this.task_vo) {
            return
        }
        let reward_list = []
        if (this.task_vo.circle_task_normal_reward) {
            let format_fun = (list?) => {
                for (let _tmpi in list) {
                    var vo = list[_tmpi]
                    reward_list.push([vo.type, vo.type_id, vo.count])
                }
            }

            format_fun(this.task_vo.circle_task_normal_reward)
            // format_fun(this.task_vo.circle_task_extra_reward)
        }


        if (this.item_list) {
            for (let _tmpi in this.item_list) {
                var item = this.item_list[_tmpi]
                item.SetVisible(false)
            }
        }

        if (!this.item_list) {
            this.item_list = []
        }

        if (reward_list && reward_list.length) {
            for (let i = 0; i < reward_list.length; i++) {
                var vo = reward_list[i]
                var item = this.item_list[i]
                if (!item) {
                    item = new EquipmentItem(this._panel_reward)
                    this.item_list[i] = item
                    item.Load()
                    item.SetItemSize(77, 77)
                }
                let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(vo[0], vo[1])
                item.SetData(type_id, vo[2])
                item.SetVisible(true)
                item.SetPosition(i * 91, 0) //77+14
            }
        }
    }

    public UpdateExtraReward = () => {
        let level = RoleManager.GetInstance().GetMainRoleLevel()
        //计算日常经验公式 如有变化需要找数值对对
        
        let extra_reward_list = []

        if (this.task_vo.task_type == TaskType.GUILD) {
            let show_exp = Math.round(100000000 * Math.pow(1.5, (level - 60) / 120))
            extra_reward_list.push([
                5,0,show_exp
            ])

            extra_reward_list.push([
                4,38040009,2000
            ])

            extra_reward_list.push([
                0,38040091,4
            ])
    
            extra_reward_list.push([
                3,0,80000
            ])

            extra_reward_list.push([
                24,36255046,200
            ])
        } else if (this.task_vo.task_type == TaskType.DAILY) {
            let show_exp = Math.round(200000000 * Math.pow(1.5, (level - 60) / 120))
            extra_reward_list.push([
                5,0,show_exp
            ])
    
            extra_reward_list.push([
                3,0,100000
            ])
        }
        

        if (this.item_list2) {
            for (let _tmpi in this.item_list2) {
                var item = this.item_list2[_tmpi]
                item.SetVisible(false)
            }
        }

        if (!this.item_list2) {
            this.item_list2 = []
        }

        let len = extra_reward_list.length
        if (len > 0) {
            for (let i = 0; i < extra_reward_list.length; i++) {
                var vo = extra_reward_list[i]
                var item = this.item_list2[i]
                if (!item) {
                    item = new EquipmentItem(this._panel_total_reward)
                    this.item_list2[i] = item
                    item.Load()
                    item.SetItemSize(77, 77)
                }
                let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(vo[0], vo[1])
                item.SetData(type_id, vo[2])
                item.SetVisible(true)
                item.SetPosition(i * 90, 0) //77+13
            }
            let panel_width = len * 77 + (len - 1) * 13
            if(panel_width > 420){
                panel_width = 420
            }
            this._panel_total_reward.width = panel_width
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

        let end_time = this.close_time + TimeUtil.getServerTime()
        var peorid_func = () => {
            let left_time = end_time - TimeUtil.getServerTime()
            if (left_time <= 0) {
                if (this.task_vo && this.task_vo.has_finish == 1) {
                    this.model.Fire(TaskModel.REQUEST_CCMD_EVENT, 30004, this.task_vo.task_id)
                }
                this.Close()
                return
            }
            this._lb_count_down.text = left_time + "s后自动提交任务"
        }
        this.time_event_id = GlobalTimerQuest.AddPeriodQuest(peorid_func, 1, -1)
        peorid_func()
    }

    public CancelTime = () => {
        if (this.time_event_id) {
            GlobalTimerQuest.CancelQuest(this.time_event_id)
            this.time_event_id = null
        }
    }

    public Open(...params) {
        if (!params[0]) return
        this.task_vo = params[0]
        super.Open()
    }

    _img_bg: Laya.Image
    _img_bg4: Laya.Image
    _img_bg5: Laya.Image
    _img_progress: Laya.Image
    _img_bg8: Laya.Image
    _img_bg7: Laya.Image
    _img_bg6: Laya.Image
    _img_reward: Laya.Image
    _img_bg3: Laya.Image
    _img_bg2: Laya.Image
    _img_close: Laya.Image
    _lb_title: Laya.Label
    _lb_circle: Laya.Label
    _lb_reward: Laya.Label
    _lb_title2: Laya.Label
    _lb_count_down: Laya.Label
    _html_target: Laya.HTMLDivElement
    _img_get: Laya.Image
    _lb_get: Laya.Label
    _panel_reward: Laya.Panel
    _panel_total_reward: Laya.Panel

    public GetComponents() {
        [
            this._img_bg,
            this._img_bg4,
            this._img_bg5,
            this._img_progress,
            this._img_bg8,
            this._img_bg7,
            this._img_bg6,
            this._img_reward,
            this._img_bg3,
            this._img_bg2,
            this._img_close,
            this._lb_title,
            this._lb_circle,
            this._lb_reward,
            this._lb_title2,
            this._lb_count_down,
            this._html_target,
            this._img_get,
            this._lb_get,
            this._panel_reward,
            this._panel_total_reward
        ]
            = this.GetChildrenByNames([
                "_img_bg",
                "_img_bg4",
                "_img_bg5",
                "_img_progress",
                "_img_bg8",
                "_img_bg7",
                "_img_bg6",
                "_img_reward",
                "_img_bg3",
                "_img_bg2",
                "_img_close",
                "_lb_title",
                "_lb_circle",
                "_lb_reward",
                "_lb_title2",
                "_lb_count_down",
                "_html_target",
                "_img_get",
                "_lb_get",
                "_panel_reward",
                "_panel_total_reward"
            ])
    }
}
window["TaskCircleFinishView"] = TaskCircleFinishView
// TypeScript file

import { Config } from "../common/Config"

/**
 *  int8    任务内容类型
 *  string   任务提示内容
    int8    是否完成
    int32	id (怪物,NPC,物品...)
    int32	需要数量
    int32	现在数量
    int32   显示数量
    int32   场景id
    int32   x坐标(逻辑坐标)
    int32   y坐标(逻辑坐标)
    int8    是否需要引导
        }
 */
export class TaskVo
{
    task_type  = 0
    task_name  = ""
    desc  = ""
    tips  = ""
    award_list = []
    special_goods_list = []
    circle_task_normal_reward = []       //赏金和结社任务正常奖励
    circle_task_extra_reward = []         //赏金和结社任务额外奖励
    new_finish_flag = false
    main_line_order = 0
    show_finish = false
    /**
     * 0表示已接任务，1表示可接任务
     */
    accept_type = 1

    constructor(public task_id:number, public task_tips_type:number, public task_tips_msg:string, public has_finish:number, public id:number, public need_num:number, public now_num:number, public show_num:number, 
                        public scene_id?:number, public scene_x?:number, public scene_y?:number, public need_guide?:number)
    {
        let task_cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_task.name, task_id, false)
        if (task_cfg) {
            this.task_type = task_cfg.type
            this.task_name = task_cfg.name
            this.desc = task_cfg.desc
            this.tips = task_cfg.tips
            this.award_list = task_cfg.award_list
            this.special_goods_list = task_cfg.special_goods_list
            this.main_line_order = task_cfg.main_line_order
            this.show_finish = task_cfg.show_finish
        }
    }
}
window["TaskVo"] = TaskVo
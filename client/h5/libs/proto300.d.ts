declare interface ITaskVo {
    task_id: number;
    task_tips_type: number;
    task_tips_msg: string;
    has_finish: number;
    id: number;
    need_num: number;
    now_num: number;
    show_num: number;
    scene_id?: number;
    scene_x?: number;
    scene_y?: number;
    need_guide?: number;
    task_type: number;
    task_name: string;
    desc: string;
    tips: string;
    award_list: any[];
    special_goods_list: any[];
    main_line_order: number;
    show_finish: number;
}

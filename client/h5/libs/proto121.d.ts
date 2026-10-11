/** npc信息
 */
declare interface ProtoFmtInfo {
    12100: {
        desc: "动态npc信息";
        send: (
            number: 12100,
            fmt: "i",
            args: [
                /**场景id*/
                scene_id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**场景id*/
            scene_id: number
        ];
        recv: {
            /** 场景id */
            scene_id: number;
            npc_list: {
                /** npc id */
                npc_id: number;
                /** 是否显示（0不显示，1显示） */
                is_show: number;
                /** 场景id */
                scene_id: number;
                /** x坐标 */
                x: number;
                /** y坐标 */
                y: number;
                /** npc动作和模型 */
                args: string;
            }[];
        };
    };
    12101: {
        desc: "npc关联任务";
        send: (number: 12101, fmt: "i", args: [npc_id: number]) => never;
        sendFmt: "i";
        sendArgs: [npc_id: number];
        recv: {
            npc_id: number;
            task_list: {
                /** 任务id */
                task_id: number;
                /** 任务状态 */
                task_state: number;
                /** 任务名称 */
                task_name: string;
                /** 任务类型 */
                task_type: number;
            }[];
        };
    };
    12102: {
        desc: "获取任务对话";
        send: (
            number: 12102,
            fmt: "ii",
            args: [
                /**唯一标识*/
                npc_id: number,
                /**任务id*/
                task_id: number
            ]
        ) => never;
        sendFmt: "ii";
        sendArgs: [
            /**唯一标识*/
            npc_id: number,
            /**任务id*/
            task_id: number
        ];
        recv: {
            /** 唯一标识 */
            npc_id: number;
            /** 任务id */
            task_id: number;
            /** 对话id */
            talk_id: number;
        };
    };
    12103: {
        desc: "场景中动态改变NPC状态";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            npc_list: {
                /** npc_id */
                npc_id: number;
                /** 是否显示（0不显示，1显示） */
                is_show: number;
                /** 场景id */
                scene_id: number;
                /** x坐标 */
                x: number;
                /** y坐标 */
                y: number;
                /** npc动作和模型 */
                args: string;
            }[];
        };
    };
}

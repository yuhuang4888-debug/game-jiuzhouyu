/** 百鬼夜行
 */
declare interface ProtoFmtInfo {
    20600: {
        desc: "返回码信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 返回码 */
            code: number;
            /**  参数 */
            args: string;
        };
    };
    20601: {
        desc: "活动信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 0关闭 1开启 */
            state: number;
            /** 活动结束时间 */
            etime: number;
            /** 小跨服模式 1248 */
            ser_mod: number;
            /** 分区组id */
            group_id: number;
            ser_list: {
                /** 服务器id */
                ser_id: number;
                /** 服数 */
                ser_num: number;
                /**  服信息 */
                c_server_msg: string;
                /**  服务器名 */
                ser_name: string;
                /** 开服天数 */
                open_day: number;
                /** 世界等级 */
                world_lv: number;
            }[];
            /** 跨服世界等级 */
            avg_wlv: number;
        };
    };
    20602: {
        desc: "boss信息";
        send: (
            number: 20602,
            fmt: "i",
            args: [
                /**场景id 获取全部传0*/
                scene_id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**场景id 获取全部传0*/
            scene_id: number
        ];
        recv: {
            scene_list: {
                /** 场景id */
                scene_id: number;
                /** 剩余数量 */
                num: number;
                boss_list: {
                    /** bossid */
                    boss_id: number;
                }[];
            }[];
        };
    };
    20603: {
        desc: "进入场景";
        send: (
            number: 20603,
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
        recv: null;
    };
    20604: {
        desc: "退出场景";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: null;
    };
}

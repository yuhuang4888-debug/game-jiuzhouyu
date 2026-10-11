/** 周一大奖
 */
declare interface ProtoFmtInfo {
    17900: {
        desc: "通用错误码返回";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 返回码 */
            code: number;
        };
    };
    17901: {
        desc: "更换奖池";
        send: (number: 17901, fmt: any, args: [pool: any]) => never;
        sendFmt: any;
        sendArgs: [pool: any];
        recv: {
            pool: {
                /** 奖励类型id */
                id: number;
                /** 物品类型id列表 */
                rids: {
                    /** 奖池id */
                    rid: number;
                }[];
            }[];
        };
    };
    17902: {
        desc: "个人抽奖记录";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            person: {
                /** 玩家id */
                role_id: number;
                /**  玩家名字 */
                role_name: string;
                /** 类型id(几等奖) */
                type: number;
                /** 奖池id */
                pool_id: number;
                /** 时间 */
                utime: number;
                /** 头像地址 */
                picture: string;
                /** 头像版本号 */
                picture_ver: number;
                /** 职业 */
                career: number;
            }[];
        };
    };
    17903: {
        desc: "抽奖";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 类型id(几等奖) */
            type: number;
            /** 奖池id */
            pool_id: number;
            /** 抽奖次数 */
            draw_times: number;
        };
    };
    17904: {
        desc: "任务状态";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            task_state: {
                /** 任务id */
                task_id: number;
                /** 0 未完成 1已完成未领取 2 已领取 */
                state: number;
            }[];
        };
    };
    17905: {
        desc: "跨服抽奖记录";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 全服记录 */
            record: {
                /** 服务器id */
                serverid: number;
                /** 服数 */
                server_num: number;
                /** 玩家id */
                role_id: number;
                /**  玩家名字 */
                role_name: string;
                /** 类型id(几等奖) */
                type: number;
                /** 奖池id */
                pool_id: number;
                /** 时间 */
                utime: number;
                /** 头像地址 */
                picture: string;
                /** 头像版本号 */
                picture_ver: number;
                /** 职业 */
                career: number;
                /** 转生 */
                turn: number;
            }[];
        };
    };
    17906: {
        desc: "领取任务奖励";
        send: (
            number: 17906,
            fmt: "h",
            args: [
                /**任务id*/
                task_id: number
            ]
        ) => never;
        sendFmt: "h";
        sendArgs: [
            /**任务id*/
            task_id: number
        ];
        recv: {
            /** 返回码 */
            code: number;
        };
    };
    17907: {
        desc: "是否在抽奖期间";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 0否 1是 */
            code: number;
            /** 抽奖次数 */
            draw_times: number;
        };
    };
    17908: {
        desc: "获取玩家奖池数据";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            pool: {
                /** 奖励类型id */
                id: number;
                /** 物品类型id列表 */
                rids: {
                    /** 奖池id */
                    rid: number;
                }[];
            }[];
        };
    };
}

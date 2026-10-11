/** 祭典
 */
declare interface ProtoFmtInfo {
    19400: {
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
    19401: {
        desc: "祭典基础信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 祭典唯一id */
            uid: number;
            /** 活动id */
            act_id: number;
            /** 祭典类型 0 普通版 1 豪华版 2 至尊版 */
            type: number;
            /** 当前等级 */
            lv: number;
            /** 当前累计经验 */
            exp: number;
            /** 过期时间戳 */
            expired_time: number;
            /** 奖励状态(直至当前等级) */
            reward_list: {
                /** 祭典等级 */
                lv: number;
                /** 状态 1 未领取 2 已领取 */
                status1: number;
                /** 状态 1 未领取 2 已领取 */
                status2: number;
            }[];
        };
    };
    19402: {
        desc: "领取祭典奖励(返回19401)";
        send: (
            number: 19402,
            fmt: "c",
            args: [
                /**祭典等级 0 全部领取*/
                lv: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**祭典等级 0 全部领取*/
            lv: number
        ];
        recv: {
            reward_list: any;
        };
    };
    19403: {
        desc: "祭典任务信息";
        send: (
            number: 19403,
            fmt: "c",
            args: [
                /**0 所有 1 每日任务 2 每周任务 3 赛季任务*/
                type: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**0 所有 1 每日任务 2 每周任务 3 赛季任务*/
            type: number
        ];
        recv: {
            /** 各类任务汇总 */
            type_list: {
                /** 任务类型 1 每日任务 2 每周任务 3 赛季任务 */
                type: number;
                /** 任务列表 */
                task_list: {
                    /** 任务id */
                    task_id: number;
                    /** 已完成次数 */
                    finish_times: number;
                    /** 当前任务数值 */
                    cur_num: number;
                    /** 状态 0 未完成 1 未领取 2 已领取 */
                    status: number;
                }[];
                /** 任务刷新时间戳 */
                refresh_time: number;
            }[];
        };
    };
    19404: {
        desc: "领取经验奖励(返回19401和19403单项信息)";
        send: (
            number: 19404,
            fmt: "ch",
            args: [
                /**0 所有 1 每日任务 2 每周任务 3 赛季任务*/
                type: number,
                /**任务id 0 所有*/
                task_id: number
            ]
        ) => never;
        sendFmt: "ch";
        sendArgs: [
            /**0 所有 1 每日任务 2 每周任务 3 赛季任务*/
            type: number,
            /**任务id 0 所有*/
            task_id: number
        ];
        recv: {
            /** 领取经验值 */
            exp: number;
        };
    };
    19405: {
        desc: "购买高级祭典(钻石购买)(返回19401)";
        send: (
            number: 19405,
            fmt: "c",
            args: [
                /**1 豪华版 2 至尊版*/
                type: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**1 豪华版 2 至尊版*/
            type: number
        ];
        recv: null;
    };
}

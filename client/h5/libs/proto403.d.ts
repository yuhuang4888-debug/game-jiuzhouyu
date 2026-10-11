/** 公会宝箱
 */
declare interface ProtoFmtInfo {
    40300: {
        desc: "错误码展示";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            error_code: number;
        };
    };
    40301: {
        desc: "宝箱界面";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 领取数量 */
            num: number;
            /** 最大领取数量 */
            max_num: number;
            send_list: {
                /** 唯一id */
                auto_id: number;
                /**  发放者玩家名字 */
                role_name: string;
                /** 发放者id */
                role_id: number;
                /** 任务配置id */
                task_id: number;
                /** 是否领取 0否 1是 */
                status: number;
                reward: any;
                /** 激活时间 */
                time: number;
            }[];
            log: {
                /**  发放者玩家名字 */
                role_name: string;
                /** 发放者id */
                role_id: number;
                /** 任务配置id */
                task_id: number;
                /** 激活时间 */
                time: number;
            }[];
            info: {
                /** 任务配置id */
                task_id: number;
                /** 已发放次数 */
                send_num: number;
            }[];
        };
    };
    40302: {
        desc: "领取宝箱奖励";
        send: (
            number: 40302,
            fmt: "l",
            args: [
                /**唯一id 发0表示一键领取*/
                auto_id: number
            ]
        ) => never;
        sendFmt: "l";
        sendArgs: [
            /**唯一id 发0表示一键领取*/
            auto_id: number
        ];
        recv: {
            /** 返回码 */
            code: number;
            send_list: {
                /** 唯一id */
                auto_id: number;
                reward: any;
            }[];
        };
    };
    40303: {
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            send_list: {
                /** 唯一id */
                auto_id: number;
                /**  发放者玩家名字 */
                role_name: string;
                /** 发放者id */
                role_id: number;
                /** 任务配置id */
                task_id: number;
                /** 是否领取 0否 1是 */
                status: number;
                reward: any;
                /** 激活时间 */
                time: number;
            }[];
            log: {
                /**  发放者玩家名字 */
                role_name: string;
                /** 发放者id */
                role_id: number;
                /** 任务配置id */
                task_id: number;
                /** 激活时间 */
                time: number;
            }[];
        };
    };
    40304: {
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 唯一id */
            auto_id: number;
        };
    };
    40305: {
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 变化的任务状态 */
            info: {
                /** 任务配置id */
                task_id: number;
                /** 已发放次数 */
                send_num: number;
            }[];
        };
    };
}

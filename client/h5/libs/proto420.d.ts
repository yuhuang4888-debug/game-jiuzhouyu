/** 投资活动
 */
declare interface ProtoFmtInfo {
    42000: {
        desc: "错误码提示";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            code: number;
            args: string;
        };
    };
    42001: {
        desc: "投资信息";
        send: (number: 42001, fmt: "c", args: [type: number]) => never;
        sendFmt: "c";
        sendArgs: [type: number];
        recv: {
            type: number;
            cur_lv: number;
            buy_time: number;
            /** 领取时间 */
            get_time: number;
            /** 登录天数 */
            login_days: number;
            rewards: {
                /** 奖励id */
                id: number;
                /** 领奖的等级 0 未领奖 X领奖的等级 如果小于cur_lv 则可以补领，否则为已领奖 */
                got_lv: number;
            }[];
        };
    };
    42002: {
        desc: "投资(修改投资档次)";
        send: (
            number: 42002,
            fmt: "ch",
            args: [type: number, lv: number]
        ) => never;
        sendFmt: "ch";
        sendArgs: [type: number, lv: number];
        recv: {
            type: number;
            lv: number;
        };
    };
    42003: {
        desc: "领取回报(补领也是这个)";
        send: (
            number: 42003,
            fmt: "cc",
            args: [
                type: number,
                /**奖励id*/
                id: number
            ]
        ) => never;
        sendFmt: "cc";
        sendArgs: [
            type: number,
            /**奖励id*/
            id: number
        ];
        recv: {
            type: number;
            /** 奖励id */
            id: number;
            rewards: any;
        };
    };
    42004: {
        desc: "开启列表";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            open_list: {
                /** 类型 */
                type: number;
                /** 展示id */
                show_id: number;
                /** 状态 */
                state: number;
                /** 触发的时间 */
                refresh_time: number;
            }[];
        };
    };
}

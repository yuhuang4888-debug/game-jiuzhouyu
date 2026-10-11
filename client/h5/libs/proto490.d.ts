/** 惊喜礼包
 */
declare interface ProtoFmtInfo {
    49000: {
        desc: "惊喜礼包界面";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            code: number;
            /** 累积每日免费抽奖次数 */
            free_draw_times: number;
            /** 累积的每日额外次数 */
            add_draw_times: number;
            /** 已经使用的每日免费次数 */
            use_free_times: number;
            /** 总抽奖次数 */
            draw_times: number;
            /** 轮次 */
            turn_id: number;
            draw_list: {
                /** 当前轮次的以得抽奖id */
                draw_id: number;
            }[];
            /** 已购买礼包 */
            gift_list: {
                /** 礼包id */
                gift_id: number;
                /** 礼包购买时间 */
                buy_time: number;
                /** 领取返利天数 */
                back_day: number;
            }[];
            day_task_list: {
                /** 1 充值 2 活跃 */
                task_id: number;
                /** 1 已完成 */
                task_state: number;
            }[];
        };
    };
    49001: {
        desc: "惊喜礼包购买";
        send: (
            number: 49001,
            fmt: "i",
            args: [
                /**礼包id*/
                gift_id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**礼包id*/
            gift_id: number
        ];
        recv: {
            /** 错误码 */
            code: number;
            /** 礼包id */
            gift_id: number;
        };
    };
    49002: {
        desc: "惊喜礼包抽奖";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            code: number;
            /** 轮次id */
            turn_id: number;
            /** 奖励id */
            gift_id: number;
            /** 已经使用的每日免费次数 */
            use_free_times: number;
        };
    };
    49003: {
        desc: "惊喜礼包返利领取";
        send: (
            number: 49003,
            fmt: "i",
            args: [
                /**礼包id  0 :全部的奖励*/
                gift_id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**礼包id  0 :全部的奖励*/
            gift_id: number
        ];
        recv: {
            /** 错误码 */
            code: number;
            /** 礼包id */
            gift_id: number;
        };
    };
    49004: {
        desc: "免费抽奖次数更新";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 累积每日免费抽奖次数 */
            free_draw_times: number;
            /** 累积的每日额外次数 */
            add_draw_times: number;
            /** 已经使用的每日免费次数 */
            use_free_times: number;
            day_task_list: {
                /** 1 充值 2 活跃 */
                task_id: number;
                /** 1 已完成 */
                task_state: number;
            }[];
        };
    };
}

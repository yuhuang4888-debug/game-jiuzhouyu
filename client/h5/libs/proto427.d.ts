/** 天天冒险
 */
declare interface ProtoFmtInfo {
    42700: {
        desc: "活动开启状态";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 期数 */
            stage: number;
            /** 活动开启时间 单位秒 */
            start_time: number;
            /** 活动结束时间 单位秒 */
            end_time: number;
        };
    };
    42701: {
        desc: "活动界面";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 当前圈数 */
            circle: number;
            /** 当前位置 */
            location: number;
            /** 每日已经重置次数 */
            left_times: number;
            /** 已投掷次数 */
            throw_times: number;
            /** 剩余免费重置次数 */
            free_reset_times: number;
            /** 额外免费投掷次数 */
            free_throw_times: number;
        };
    };
    42702: {
        desc: "投骰子";
        send: (
            number: 42702,
            fmt: "c",
            args: [
                /**0：不使用抵扣卷， 1：使用抵扣劵*/
                is_cheap: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**0：不使用抵扣卷， 1：使用抵扣劵*/
            is_cheap: number
        ];
        recv: {
            /** 错误码：1为成功 */
            errcode: number;
            /** 圈数 */
            circle: number;
            /** 格子位置 */
            location: number;
            /** 前进步数 */
            steps: number;
            /** 暴击位置 */
            lucky_reward: {
                /** 位置 */
                loc: number;
                /** 暴击倍数 */
                crit: number;
                get_goods: any;
            }[];
            gain_goods_list: any;
        };
    };
    42703: {
        desc: "重置骰子";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码：1为成功 */
            errcode: number;
            /** 圈数 */
            circle: number;
            /** 格子位置 */
            location: number;
        };
    };
    42704: {
        desc: "商城界面";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 刷新次数 */
            times: number;
            refresh_cost: any;
            goods_list: {
                /** id */
                id: number;
                /** 奖励类型 0：免费 1：随机 */
                type: number;
                reward: any;
                /** 原价 */
                show_price: number;
                /** 现价 */
                price: number;
                /** 是否超时 */
                over: number;
                /** 0:未购买 1：已经购买 */
                state: number;
            }[];
        };
    };
    42705: {
        desc: "商城购买";
        send: (
            number: 42705,
            fmt: "h",
            args: [
                /**id*/
                id: number
            ]
        ) => never;
        sendFmt: "h";
        sendArgs: [
            /**id*/
            id: number
        ];
        recv: {
            /** 错误码：1为成功 */
            errcode: number;
            /** id */
            id: number;
        };
    };
    42706: {
        desc: "商城刷新";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码：1为成功 */
            errcode: number;
            /** 刷新次数 */
            times: number;
            refresh_cost: any;
            goods_list: {
                /** id */
                id: number;
                /** 奖励类型 0：免费 1：随机 */
                type: number;
                reward: any;
                /** 原价 */
                show_price: number;
                /** 现价 */
                price: number;
                /** 是否超时 */
                over: number;
                /** 0:未购买 1：已经购买 */
                state: number;
            }[];
        };
    };
}

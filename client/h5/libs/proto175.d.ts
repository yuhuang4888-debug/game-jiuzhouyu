/** 七天登录
 */
declare interface ProtoFmtInfo {
    17500: {
        desc: "打开七天登录";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            errcode: number;
            /** 登录天数， 大于7天， 发8 */
            current_day: number;
            /** 领取状态 */
            reward_status: {
                /** 天数 */
                day_id: number;
                /** 0:不可领取， 1：可领取 ， 2：已领取 */
                status: number;
            }[];
        };
    };
    17501: {
        desc: "领取七天登录";
        send: (
            number: 17501,
            fmt: "c",
            args: [
                /**领取天数*/
                day_id: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**领取天数*/
            day_id: number
        ];
        recv: {
            /** 错误码 */
            errcode: number;
            /** 领取天数 */
            day_id: number;
            /** 奖励列表 */
            reward_list: {
                /** 物品大类型 */
                good_type: number;
                /** 物品id */
                good_id: number;
                /** 数量 */
                good_num: number;
                /** 物品唯一id */
                good_auto_id: number;
            }[];
        };
    };
    17502: {
        desc: "打开合服七天登录";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            errcode: number;
            /** 登录天数， 大于7天， 发8 */
            current_day: number;
            /** 领取状态 */
            reward_status: {
                /** 天数 */
                day_id: number;
                /** 0:不可领取， 1：可领取 ， 2：已领取 */
                status: number;
            }[];
        };
    };
    17503: {
        desc: "领取合服七天登录";
        send: (
            number: 17503,
            fmt: "c",
            args: [
                /**领取天数*/
                day_id: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**领取天数*/
            day_id: number
        ];
        recv: {
            /** 错误码 */
            errcode: number;
            /** 领取天数 */
            day_id: number;
            /** 奖励列表 */
            reward_list: {
                /** 物品大类型 */
                good_type: number;
                /** 物品id */
                good_id: number;
                /** 数量 */
                good_num: number;
                /** 物品唯一id */
                good_auto_id: number;
            }[];
        };
    };
}

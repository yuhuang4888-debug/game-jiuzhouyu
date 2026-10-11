/** 竞榜活动
 */
declare interface ProtoFmtInfo {
    33800: {
        desc: "获取正在开启的活动";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            act_list: {
                /** 主类型 */
                type: number;
                /** 次类型 */
                subtype: number;
                /** 展示id */
                show_id: number;
                /** 活动开启时间 单位秒 */
                start_time: number;
                /** 活动结束时间 单位秒 */
                end_time: number;
                /** 活动结束购买时间 单位秒 */
                buy_end_time: number;
            }[];
        };
    };
    33801: {
        desc: "界面信息";
        send: (
            number: 33801,
            fmt: "hh",
            args: [
                /**主类型*/
                type: number,
                /**次类型*/
                subtype: number
            ]
        ) => never;
        sendFmt: "hh";
        sendArgs: [
            /**主类型*/
            type: number,
            /**次类型*/
            subtype: number
        ];
        recv: {
            /** 主类型 */
            type: number;
            /** 次类型 */
            subtype: number;
            /** 活动是否开启(0否1是) */
            is_open: number;
            /** 玩家积分 */
            score: number;
            /** 今日积分 */
            today_score: number;
            cost: any;
            ten_cost: any;
            /** 显示奖励id列表 */
            reward_list: {
                /** 奖励id */
                reward_id: number;
            }[];
            stage_list: {
                /** 奖励id */
                id: number;
                /** 1为可领取；2为已领取；3为未达条件 */
                got_type: number;
            }[];
            /** 世界等级 */
            world_lv: number;
        };
    };
    33802: {
        desc: "榜单信息";
        send: (
            number: 33802,
            fmt: "hh",
            args: [
                /**主类型*/
                type: number,
                /**次类型*/
                subtype: number
            ]
        ) => never;
        sendFmt: "hh";
        sendArgs: [
            /**主类型*/
            type: number,
            /**次类型*/
            subtype: number
        ];
        recv: {
            /** 主类型 */
            type: number;
            /** 次类型 */
            subtype: number;
            /** 玩家积分 */
            score: number;
            /** 自己排名 */
            rank: number;
            rank_list: {
                /** 排名 */
                rank: number;
                server_id: number;
                role_id: number;
                role_name: string;
                /** 积分 */
                role_score: number;
            }[];
        };
    };
    33803: {
        desc: "抽奖";
        send: (
            number: 33803,
            fmt: "hhc",
            args: [
                /**主类型*/
                type: number,
                /**次类型*/
                subtype: number,
                /**抽奖次数*/
                times: number
            ]
        ) => never;
        sendFmt: "hhc";
        sendArgs: [
            /**主类型*/
            type: number,
            /**次类型*/
            subtype: number,
            /**抽奖次数*/
            times: number
        ];
        recv: {
            /** 主类型 */
            type: number;
            /** 次类型 */
            subtype: number;
            /** 抽奖次数 */
            times: number;
            /** 今日积分 */
            today_score: number;
            /** 错误码 */
            error_code: number;
            /** 奖励id列表 */
            reward_list: {
                reward_id: number;
                reward: any;
            }[];
        };
    };
    33804: {
        desc: "领取阶段奖励";
        send: (
            number: 33804,
            fmt: "hhh",
            args: [
                /**主类型*/
                type: number,
                /**次类型*/
                subtype: number,
                /**奖励id*/
                reward_id: number
            ]
        ) => never;
        sendFmt: "hhh";
        sendArgs: [
            /**主类型*/
            type: number,
            /**次类型*/
            subtype: number,
            /**奖励id*/
            reward_id: number
        ];
        recv: {
            /** 主类型 */
            type: number;
            /** 次类型 */
            subtype: number;
            /** 奖励id */
            reward_id: number;
            /** 错误码 */
            error_code: number;
        };
    };
    33805: {
        desc: "许愿界面";
        send: (
            number: 33805,
            fmt: "hhc",
            args: [
                /**主类型*/
                type: number,
                /**次类型*/
                subtype: number,
                /**类型：1为钻石；2为秘钥*/
                cost_type: number
            ]
        ) => never;
        sendFmt: "hhc";
        sendArgs: [
            /**主类型*/
            type: number,
            /**次类型*/
            subtype: number,
            /**类型：1为钻石；2为秘钥*/
            cost_type: number
        ];
        recv: {
            /** 主类型 */
            type: number;
            /** 次类型 */
            subtype: number;
            /** 活动是否开启(0否1是) */
            is_open: number;
            /** 玩家积分 */
            score: number;
            /** 对应类型已抽次数 */
            times: number;
            /** 显示奖励id列表 */
            reward_list: {
                /** 奖励id */
                reward_id: number;
            }[];
        };
    };
    33806: {
        desc: "许愿";
        send: (
            number: 33806,
            fmt: "hhc",
            args: [
                /**主类型*/
                type: number,
                /**次类型*/
                subtype: number,
                /**消耗类型：1为钻石；2为秘钥*/
                cost_type: number
            ]
        ) => never;
        sendFmt: "hhc";
        sendArgs: [
            /**主类型*/
            type: number,
            /**次类型*/
            subtype: number,
            /**消耗类型：1为钻石；2为秘钥*/
            cost_type: number
        ];
        recv: {
            /** 主类型 */
            type: number;
            /** 次类型 */
            subtype: number;
            /** 消耗类型：1为钻石；2为秘钥 */
            cost_type: number;
            /** 错误码 */
            error_code: number;
            /** 奖励id列表 */
            reward_list: {
                reward_id: number;
                reward: any;
            }[];
        };
    };
    33807: {
        desc: "获取秘钥数量";
        send: (
            number: 33807,
            fmt: "hh",
            args: [
                /**主类型*/
                type: number,
                /**次类型*/
                subtype: number
            ]
        ) => never;
        sendFmt: "hh";
        sendArgs: [
            /**主类型*/
            type: number,
            /**次类型*/
            subtype: number
        ];
        recv: {
            /** 主类型 */
            type: number;
            /** 次类型 */
            subtype: number;
            /** 秘钥数量 */
            num: number;
            /** 当前还需充值量 */
            recharge: number;
        };
    };
}

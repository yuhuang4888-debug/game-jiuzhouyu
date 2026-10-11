/** 开服冲榜活动信息
 */
declare interface ProtoFmtInfo {
    22500: {
        desc: "错误码展示";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            error_code: number;
        };
    };
    22501: {
        desc: "冲榜榜单信息";
        send: (
            number: 22501,
            fmt: "ih",
            args: [
                /**请求的排行榜类型 :1 等级 2 坐骑 3 伙伴 4 充值  5 宝石 6 战力*/
                type: number,
                /**活动子类   看定制活动*/
                sub_type: number
            ]
        ) => never;
        sendFmt: "ih";
        sendArgs: [
            /**请求的排行榜类型 :1 等级 2 坐骑 3 伙伴 4 充值  5 宝石 6 战力*/
            type: number,
            /**活动子类   看定制活动*/
            sub_type: number
        ];
        recv: {
            rank_type: number;
            /** 请求者排行 0为未上榜 */
            sel_rank: number;
            /** 自己的值 */
            sel_val: number;
            /** 排行榜总人数 */
            sum: number;
            /** 最大长度 */
            max_len: number;
            /** 上榜阈值 */
            rank_limit: number;
            /** 奖励领取状态 0 不可领取 1 可以领取 2已领取 */
            status: number;
            /** 活动结束时间戳    0：表示已经结算 */
            end_time: number;
            rank_list: {
                player_id: number;
                name: string;
                /** 值  对应排行榜的相应的值，阶星的值： 阶*1000 + 星 */
                first_value: number;
                rank: number;
            }[];
        };
    };
    22502: {
        desc: "目标奖励信息";
        send: (
            number: 22502,
            fmt: "h",
            args: [
                /**活动子类， 默认就是1*/
                sub_type: number
            ]
        ) => never;
        sendFmt: "h";
        sendArgs: [
            /**活动子类， 默认就是1*/
            sub_type: number
        ];
        recv: {
            goal_list: {
                /** 榜单类型 */
                rank_type: number;
                goal: {
                    goalId: number;
                    /** 领取状态 0不可领 1 可领 2 完成 */
                    status: number;
                }[];
            }[];
        };
    };
    22503: {
        desc: "领取奖励";
        send: (
            number: 22503,
            fmt: "ihc",
            args: [
                /**请求的排行榜类型*/
                type: number,
                /**活动子类*/
                sub_type: number,
                /**目标奖励id*/
                goal: number
            ]
        ) => never;
        sendFmt: "ihc";
        sendArgs: [
            /**请求的排行榜类型*/
            type: number,
            /**活动子类*/
            sub_type: number,
            /**目标奖励id*/
            goal: number
        ];
        recv: {
            /** 1 成功 */
            error_code: number;
            /** 请求的排行榜类型 */
            type: number;
            /** 目标奖励id */
            goal: number;
            sub_type: number;
        };
    };
    22504: {
        desc: "领取排行榜奖励";
        send: (
            number: 22504,
            fmt: "ihc",
            args: [
                /**请求的排行榜类型*/
                type: number,
                /**活动子类*/
                sub_type: number,
                /**奖励id*/
                reward_id: number
            ]
        ) => never;
        sendFmt: "ihc";
        sendArgs: [
            /**请求的排行榜类型*/
            type: number,
            /**活动子类*/
            sub_type: number,
            /**奖励id*/
            reward_id: number
        ];
        recv: {
            /** 1 成功 */
            error_code: number;
            /** 奖励id */
            reward_id: number;
            sub_type: number;
            /** 排行榜类型 */
            type: number;
        };
    };
    22505: {
        desc: "获取途径";
        send: (
            number: 22505,
            fmt: "i",
            args: [
                /**请求排行榜的获取途径*/
                rush_id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**请求排行榜的获取途径*/
            rush_id: number
        ];
        recv: {
            /** 排行榜id */
            rush_id: number;
            res: {
                /** 跳转id */
                jump_id: number;
                /** 类型标志 0代表无标识，1代表超值，2代表必买（必买为限时途径） */
                label: number;
                /** 结束时间，秒，unix时间戳 */
                end_time: number;
            }[];
        };
    };
}

/** 战力冲榜
 */
declare interface ProtoFmtInfo {
    22600: {
        desc: "错误码展示";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            error_code: number;
        };
    };
    22601: {
        desc: "冲榜榜单信息";
        send: (
            number: 22601,
            fmt: "h",
            args: [
                /**:1 个人   2 伙伴*/
                sub_type: number
            ]
        ) => never;
        sendFmt: "h";
        sendArgs: [
            /**:1 个人   2 伙伴*/
            sub_type: number
        ];
        recv: {
            sub_type: number;
            /** 请求者排行 0为未上榜 */
            sel_rank: number;
            /** 自己的值 */
            sel_val: number;
            rank_list: {
                player_id: number;
                name: string;
                /** 值 */
                first_value: number;
                rank: number;
            }[];
        };
    };
    22602: {
        desc: "目标奖励信息";
        send: (
            number: 22602,
            fmt: "h",
            args: [
                /**:1 个人   2 伙伴*/
                sub_type: number
            ]
        ) => never;
        sendFmt: "h";
        sendArgs: [
            /**:1 个人   2 伙伴*/
            sub_type: number
        ];
        recv: {
            /** 榜单类型 */
            sub_type: number;
            goal_list: {
                stage_id: number;
                /** 我的战力 */
                my_power: number;
                /** 战力需求 */
                power: number;
                /** 领取状态 0不可领 1 可领 2 完成 */
                status: number;
            }[];
        };
    };
    22603: {
        desc: "领取奖励";
        send: (
            number: 22603,
            fmt: "hc",
            args: [
                /**活动子类*/
                sub_type: number,
                /**目标奖励id*/
                stage_id: number
            ]
        ) => never;
        sendFmt: "hc";
        sendArgs: [
            /**活动子类*/
            sub_type: number,
            /**目标奖励id*/
            stage_id: number
        ];
        recv: {
            code: number;
            sub_type: number;
            /** 目标奖励id */
            stage_id: number;
            reward: any;
        };
    };
}

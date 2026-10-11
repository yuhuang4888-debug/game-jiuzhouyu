/** 跨服云购
 */
declare interface ProtoFmtInfo {
    51201: {
        desc: "开启的活动列表";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            open_act_list: {
                type: number;
                subtype: number;
                start_time: number;
                end_time: number;
                /** 购买截止时间 */
                buy_endtime: number;
                /** 重置时间 */
                reset_time: number;
            }[];
        };
    };
    51202: {
        desc: "活动界面";
        send: (
            number: 51202,
            fmt: "hh",
            args: [type: number, subtype: number]
        ) => never;
        sendFmt: "hh";
        sendArgs: [type: number, subtype: number];
        recv: {
            code: number;
            type: number;
            subtype: number;
            /** 大奖id */
            grade_id: number;
            /** 大奖已抽次数 */
            grade_count: number;
            /** 自己抽取的次数 */
            self_count: number;
            /** 自己抽取总次数 */
            self_total_count: number;
            stage_rewards: {
                /** 累积次数 */
                stage_count: number;
                stage_wlv: number;
                /** 奖励状态 1 已领取 */
                reward_st: number;
            }[];
        };
    };
    51203: {
        desc: "活动抽奖记录";
        send: (
            number: 51203,
            fmt: "hhcc",
            args: [
                type: number,
                subtype: number,
                start_pos: number,
                end_pos: number
            ]
        ) => never;
        sendFmt: "hhcc";
        sendArgs: [
            type: number,
            subtype: number,
            start_pos: number,
            end_pos: number
        ];
        recv: {
            type: number;
            subtype: number;
            start_pos: number;
            end_pos: number;
            is_end: number;
            tv_records: {
                role_id: number;
                name: string;
                server_id: number;
                server_num: number;
                rewards: any;
                time: number;
            }[];
        };
    };
    51204: {
        desc: "活动大奖记录";
        send: (
            number: 51204,
            fmt: "hh",
            args: [type: number, subtype: number]
        ) => never;
        sendFmt: "hh";
        sendArgs: [type: number, subtype: number];
        recv: {
            type: number;
            subtype: number;
            big_reward_records: {
                role_id: number;
                name: string;
                server_id: number;
                server_num: number;
                /** 大奖id */
                grade_id: number;
                /** 抽奖次数 */
                self_count: number;
                time: number;
            }[];
        };
    };
    51205: {
        desc: "抽奖";
        send: (
            number: 51205,
            fmt: "hhh",
            args: [type: number, subtype: number, times: number]
        ) => never;
        sendFmt: "hhh";
        sendArgs: [type: number, subtype: number, times: number];
        recv: {
            code: number;
            type: number;
            subtype: number;
            /** 大奖已抽次数 */
            grade_count: number;
            /** 自己抽取的次数 */
            self_count: number;
            /** 自己抽取总次数 */
            self_total_count: number;
            rewards: any;
        };
    };
    51206: {
        desc: "领取阶段奖励";
        send: (
            number: 51206,
            fmt: "hhh",
            args: [type: number, subtype: number, stage_count: number]
        ) => never;
        sendFmt: "hhh";
        sendArgs: [type: number, subtype: number, stage_count: number];
        recv: {
            code: number;
            type: number;
            subtype: number;
            stage_count: number;
            rewards: any;
        };
    };
    51207: {
        desc: "活动进入下一轮(界面处于打开中，刷新下界面)";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            type: number;
            subtype: number;
            grade_id: number;
            /** 刷新后为0 */
            grade_count: number;
            /** 刷新后为0 */
            self_count: number;
        };
    };
    51208: {
        desc: "活动重置(界面处于打开中，刷新下界面)";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            type: number;
            subtype: number;
            start_time: number;
            end_time: number;
            /** 下次购买截止时间 */
            buy_endtime: number;
            /** 下次重置时间 */
            reset_time: number;
            /** 大奖id */
            grade_id: number;
            /** 重置为0 */
            grade_count: number;
            /** 重置为0 */
            self_count: number;
            /** 重置为0 */
            self_total_count: number;
            stage_rewards: {
                /** 累积次数 */
                stage_count: number;
                stage_wlv: number;
                /** 奖励状态 1 已领取 */
                reward_st: number;
            }[];
        };
    };
    51209: {
        desc: "大奖购买次数刷新";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            type: number;
            subtype: number;
            /** 大奖id */
            grade_id: number;
            /** 新的购买次数 */
            grade_count: number;
        };
    };
}

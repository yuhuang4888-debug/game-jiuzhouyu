/** boss转盘
 */
declare interface ProtoFmtInfo {
    51001: {
        desc: "获取没放弃的转盘";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            rotary_list: {
                rotary_id: number;
                /** boss类型 */
                boss_type: number;
                /** 转盘奖励等级 */
                boss_reward_lv: number;
                boss_id: number;
                reward_list: {
                    /** 奖池id */
                    pool_id: number;
                    /** 奖励id */
                    reward_id: number;
                    /** 珍惜度 */
                    rare: number;
                    /** 1 已领取 */
                    is_get: number;
                    rewards: any;
                }[];
            }[];
        };
    };
    51002: {
        desc: "新转盘推送";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            rotary_id: number;
            /** boss类型 */
            boss_type: number;
            /** 转盘奖励等级 */
            boss_reward_lv: number;
            boss_id: number;
            reward_list: {
                /** 奖池id */
                pool_id: number;
                /** 奖励id */
                reward_id: number;
                /** 珍惜度 */
                rare: number;
                /** 1 已领取 */
                is_get: number;
                rewards: any;
            }[];
        };
    };
    51003: {
        desc: "放弃转盘";
        send: (number: 51003, fmt: "i", args: [rotary_id: number]) => never;
        sendFmt: "i";
        sendArgs: [rotary_id: number];
        recv: {
            code: number;
            rotary_id: number;
        };
    };
    51004: {
        desc: "转转盘";
        send: (number: 51004, fmt: "i", args: [rotary_id: number]) => never;
        sendFmt: "i";
        sendArgs: [rotary_id: number];
        recv: {
            code: number;
            rotary_id: number;
            /** 奖池id */
            pool_id: number;
            /** 奖励id */
            reward_id: number;
            rewards: any;
        };
    };
    51005: {
        desc: "转转盘(结束)";
        send: (number: 51005, fmt: "i", args: [rotary_id: number]) => never;
        sendFmt: "i";
        sendArgs: [rotary_id: number];
        recv: null;
    };
}

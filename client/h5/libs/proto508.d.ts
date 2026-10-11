/** 周常副本
 */
declare interface ProtoFmtInfo {
    50801: {
        desc: "玩家的周常副本信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            dun_list: {
                /** 周常本id */
                week_dun_id: number;
                /** 单人评分 */
                dun_score: number;
                /** 本周单人模式是否通关 */
                single_succ: number;
                /** 本周组队模式是否通关 */
                team_succ: number;
                /** 本周助战次数 */
                help_times: number;
                boss_reward: {
                    /** bossid */
                    boss_id: number;
                    /** 奖励状态 1 本周已领取 */
                    reward_st: number;
                }[];
            }[];
        };
    };
    50802: {
        desc: "榜单";
        send: (
            number: 50802,
            fmt: "icc",
            args: [
                /**组队副本id*/
                team_dun_id: number,
                rank1: number,
                rank2: number
            ]
        ) => never;
        sendFmt: "icc";
        sendArgs: [
            /**组队副本id*/
            team_dun_id: number,
            rank1: number,
            rank2: number
        ];
        recv: {
            /** 组队副本id */
            team_dun_id: number;
            /** 0表示还没上榜 */
            self_rank: number;
            /** 自己的成绩 */
            self_pass_time: number;
            rank_list: {
                /** 通关时长 */
                pass_time: number;
                /** 通关时间 */
                time: number;
                /** 排名 */
                rank: number;
                role_list: {
                    role_id: number;
                    role_name: string;
                    server_id: number;
                    server_num: number;
                }[];
            }[];
        };
    };
    50805: {
        desc: "结算界面";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 1 副本结束 2 副本失败 */
            result_type: number;
            /** 副本id */
            dun_id: number;
            /** 通关时间 */
            go_time: number;
            dun_rewards: {
                /** 1 通关奖励 2 助战奖励 */
                type: number;
                /** 次数 */
                times: number;
                dun_rewards_list: any;
            }[];
            role_boss_list: {
                boss_id: number;
                /** 奖励状态 1 本周已领取 */
                reward_st: number;
                reward_list: any;
            }[];
        };
    };
}

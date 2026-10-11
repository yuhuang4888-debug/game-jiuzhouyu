/** 三军之战
 */
declare interface ProtoFmtInfo {
    60201: {
        desc: "活动信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 0: 未开启 1: 已开启 */
            status: number;
            /** 结束时间戳 */
            etime: number;
        };
    };
    60202: {
        desc: "进入场景";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            errcode: number;
        };
    };
    60203: {
        desc: "退出场景";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            errcode: number;
        };
    };
    60204: {
        desc: "战场信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 活动结束时间 */
            etime: number;
            /** 分组阵营 */
            group: number;
            /** 玩家当前积分 */
            score: number;
            /** 玩家当前排名 */
            ranking: number;
            rank_list: {
                /** 分组阵营 */
                group: number;
                /** 人数 */
                num: number;
                /** 阵营总积分 */
                score: number;
            }[];
            /** 需要积分 0表示已经全部达成 */
            need_score: number;
            /** 阶段奖励 */
            stage_reward: any;
        };
    };
    60205: {
        desc: "积分榜";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 自己的积分 */
            score: number;
            /** 自己的排名 */
            ranking: number;
            rank_list: {
                /** 排名 */
                ranking: number;
                /** 阵营 */
                group: number;
                /**  名字 */
                name: string;
                /** 等级 */
                lv: number;
                /** 积分 */
                score: number;
                /** 战力 */
                combat_power: number;
            }[];
        };
    };
    60206: {
        desc: "结算界面";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 积分 */
            score: number;
            /** 排名 */
            ranking: number;
            /** 阵营排名 */
            group_ranking: number;
            /** 奖励 */
            reward: {
                /** 1:阵营奖励 2:排名奖励 */
                type: number;
                /** 奖励类型 */
                object_type: number;
                /** 物品类型id */
                type_id: number;
                /** 物品数量 */
                num: number;
            }[];
        };
    };
    60207: {
        desc: "排名奖励";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            reward_list: {
                /** 排名下限 */
                min_ranking: number;
                /** 排名上限 */
                max_ranking: number;
                /** 奖励 */
                reward: any;
            }[];
        };
    };
}

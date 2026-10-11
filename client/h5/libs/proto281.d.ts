/** 巅峰竞技
 */
declare interface ProtoFmtInfo {
    28100: {
        desc: "错误码展示";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            code: number;
            args: string;
        };
    };
    28101: {
        desc: "基本信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 赛季序号 */
            season_num: number;
            /** 赛季结束时间 */
            season_end_time: number;
            /** 段位等级 */
            rank_lv: number;
            /** 积分 */
            point: number;
            /** 本赛季总次数 */
            season_count: number;
            /** 本赛季胜利次数 */
            season_win_count: number;
            /** 每日可领取荣誉值 */
            daily_honor_value: number;
            /** 每日荣誉值领取状态 1:可以领取 0:已经领取，2:未达成 */
            honor_is_got: number;
            /** 每日匹配次数 */
            daily_count: number;
            daily_reward_counts: {
                /** 次数 */
                count: number;
                /** 状态 0已领取 1未达成 2可领取 */
                state: number;
            }[];
            /** 日常购买次数 */
            daily_buy_count: number;
            /** 昨天段位等级 */
            yesterday_rank_lv: number;
        };
    };
    28102: {
        desc: "领取每日荣誉值";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            reward_obj_list: any;
        };
    };
    28103: {
        desc: "领取每日参与次数奖励";
        send: (
            number: 28103,
            fmt: "c",
            args: [
                /**次数*/
                count: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**次数*/
            count: number
        ];
        recv: {
            /** 次数 */
            count: number;
            reward_obj_list: any;
        };
    };
    28104: {
        desc: "购买次数";
        send: (
            number: 28104,
            fmt: "h",
            args: [
                /**购买次数*/
                buy_count: number
            ]
        ) => never;
        sendFmt: "h";
        sendArgs: [
            /**购买次数*/
            buy_count: number
        ];
        recv: {
            /** 新的每日购买次数 */
            daily_buy_count: number;
        };
    };
    28105: {
        desc: "段位等级奖励列表";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            got_list: {
                /** 段位等级 */
                rank_lv: number;
                /** 状态 0已领取 1未达成 2可领取 */
                state: number;
            }[];
        };
    };
    28106: {
        desc: "领取段位等级奖励";
        send: (
            number: 28106,
            fmt: "c",
            args: [
                /**段位等级*/
                rank_lv: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**段位等级*/
            rank_lv: number
        ];
        recv: {
            /** 被领取奖励的段位等级 */
            rank_lv: number;
            reward_obj_list: any;
        };
    };
    28107: {
        desc: "活动状态信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 状态 1开启 0关闭 */
            state: number;
            start_time: number;
            end_time: number;
        };
    };
    28110: {
        desc: "匹配";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 成功必然返回 */
            res: number;
        };
    };
    28111: {
        desc: "匹配到对手";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 1 成功 0 失败 */
            res: number;
            /** 我的段位等级 */
            my_rank_lv: number;
            /** 敌人段位等级 */
            enemy_rank_lv: number;
            /** 假人战斗力 */
            fake_man_power: number;
        };
    };
    28112: {
        desc: "开始预告";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 阶段 1即将开始 2正式开始 3退出阶段 */
            stage: number;
            /** 阶段结束时间戳 */
            time: number;
        };
    };
    28113: {
        desc: "结算";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 1赢 0输 */
            res: number;
            /** 获得荣誉值 */
            honor: number;
            /** 正负标识 1:正 0:负 */
            flag: number;
            /** 获得活动积分 */
            point: number;
        };
    };
    28114: {
        desc: "取消匹配";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 成功必然返回 */
            res: number;
        };
    };
    28115: {
        desc: "排行榜数据";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            rank_list: {
                /** 玩家id */
                role_id: number;
                /**  玩家名 */
                role_name: string;
                /** 职业 */
                career: number;
                /** 战力 */
                power: number;
                /**  帮派名 */
                guild_name: string;
                /**  平台 */
                platform: string;
                /** 服务器编号 */
                server: number;
                /** 段位等级 */
                rank_lv: number;
                /** 积分 */
                point: number;
            }[];
        };
    };
    28116: {
        desc: "退出";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: null;
    };
    28117: {
        desc: "段位提升";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            old_rank_lv: number;
            old_point: number;
            new_rank_lv: number;
            new_point: number;
        };
    };
}

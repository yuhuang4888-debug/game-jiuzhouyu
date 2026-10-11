/** 跨服领地战
 */
declare interface ProtoFmtInfo {
    50600: {
        desc: "活动状态";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 0 未开启 1 准备前(会长可以选择领地) 2 准备开启 3 开启中 */
            war_state: number;
            /** 准备时间(会长选择领地截止时间) */
            ready_time: number;
            /** 开始时间 */
            start_time: number;
            /** 活动结束时间 */
            end_time: number;
        };
    };
    50601: {
        desc: "活动界面";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 1为可领取；2为不可领取 3 已领取 */
            type: number;
            /** 霸主公会id */
            winner: number;
            /** 霸主 服务器id */
            server_id: number;
            /** 连胜次数 */
            win_num: number;
            /** 0 无 1 连胜 2 终结 */
            reward_type: number;
            /** 连胜奖励键(即连胜次数) */
            reward_key: number;
            /** 已分配的玩家id */
            reward_owner: number;
        };
    };
    50602: {
        desc: "领取每日奖励";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 1为成功 */
            error_code: number;
        };
    };
    50603: {
        desc: "进入退出场景";
        send: (
            number: 50603,
            fmt: "c",
            args: [
                /**1为进入场景；2为退出场景*/
                type: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**1为进入场景；2为退出场景*/
            type: number
        ];
        recv: {
            /** 1为成功 */
            error_code: number;
            /** 请求类型 */
            type: number;
        };
    };
    50604: {
        desc: "战场信息(进入场景后请求一次，以后的信息变更通过其他协议通知)";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 领地id */
            territory_id: number;
            /** 结束时间 */
            end_time: number;
            /** 玩家个人积分 */
            role_score: number;
            /** 公会列表 */
            guild_list: {
                /** 公会id */
                guild_id: number;
                /** 公会名 */
                guild_name: string;
                server_id: number;
                server_num: number;
                /** 积分 */
                score: number;
                own_list: {
                    /** 占领的据点id */
                    mod_id: number;
                }[];
            }[];
            /** 阶段奖励列表(已领取) */
            stage_list: {
                /** 奖励阶段id */
                keyid: number;
            }[];
            /** 据点信息 */
            own_list: {
                /** 1为未占领；2为已被占领 */
                type: number;
                /** 公会id */
                guild_id: number;
                /** 占领公会名 */
                guild_name: string;
                /** 据点id */
                mon_id: number;
                /** 据点当前血量 */
                hp: number;
                /** 据点上限血量 */
                hp_lim: number;
            }[];
        };
    };
    50605: {
        desc: "新增阶段奖励(新获取的阶段奖励)";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 玩家个人积分 */
            role_score: number;
            add_stage_list: {
                /** 奖励阶段id */
                keyid: number;
            }[];
        };
    };
    50606: {
        desc: "战场公会信息变化(定时广播更新)";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            guild_update_list: {
                /** 公会id */
                guild_id: number;
                /** 积分 */
                score: number;
                own_list: {
                    /** 占领的据点id */
                    mod_id: number;
                }[];
            }[];
        };
    };
    50607: {
        desc: "战场公会据点变化(定时广播更新)";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            own_update_list: {
                /** 1为未占领；2为已被占领 */
                type: number;
                /** 公会id */
                guild_id: number;
                /** 占领公会名 */
                guild_name: string;
                /** 据点id */
                mon_id: number;
                /** 据点当前血量 */
                hp: number;
                /** 据点上限血量 */
                hp_lim: number;
            }[];
        };
    };
    50611: {
        desc: "战场结束推送页面";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            territory_id: number;
            mode_num: number;
            guild_list: {
                /** 公会id */
                guild_id: number;
                /** 是否胜利 */
                is_win: number;
                /** 公会名 */
                guild_name: string;
                server_id: number;
                server_num: number;
                /** 积分 */
                score: number;
                own_list: {
                    /** 占领的据点id */
                    mod_id: number;
                }[];
            }[];
        };
    };
    50612: {
        desc: "个人积分变化(定时广播更新，或者遇到关键节点会推)";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 玩家个人积分 */
            role_score: number;
        };
    };
    50613: {
        desc: "据点占领";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 据点id */
            mon_id: number;
            /** 公会id */
            guild_id: number;
        };
    };
    50617: {
        desc: "会长召集";
        send: (
            number: 50617,
            fmt: "i",
            args: [
                /**据点id*/
                mon_id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**据点id*/
            mon_id: number
        ];
        recv: {
            /** 据点id */
            mon_id: number;
        };
    };
    50618: {
        desc: "分配奖励";
        send: (
            number: 50618,
            fmt: "l",
            args: [
                /**分配奖励给玩家*/
                role_id: number
            ]
        ) => never;
        sendFmt: "l";
        sendArgs: [
            /**分配奖励给玩家*/
            role_id: number
        ];
        recv: {
            code: number;
        };
    };
    50619: {
        desc: "连杀数";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 击杀者server_id */
            atter_server_id: number;
            role_id: number;
            role_name: string;
            /** 性别 */
            sex: number;
            /** 阵营 */
            realm: number;
            /** 职业 */
            career: number;
            /** 转生数 */
            turn: number;
            /** 等级 */
            lv: number;
            /**  头像地址 */
            picture: string;
            /** 头像版本号 */
            picture_ver: number;
            /** 连杀数 */
            ckill_num: number;
        };
    };
    50620: {
        desc: "活动轮次信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 轮次 */
            round: number;
            /** 本轮开始时间 */
            round_start_time: number;
            round_end_time: number;
        };
    };
    50621: {
        desc: "领地赛事信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            war_list: {
                /** 领地id */
                territory_id: number;
                /** a公会 */
                a_guild: number;
                a_guild_name: string;
                a_server_id: number;
                a_server_num: number;
                /** b公会 */
                b_guild: number;
                b_guild_name: string;
                b_server_id: number;
                b_server_num: number;
                /** 胜者公会id */
                winner: number;
            }[];
        };
    };
    50622: {
        desc: "服务器分服信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 1248 */
            mode_num: number;
            /** 跨服世界等级 */
            avg_wlv: number;
            server_list: {
                server_id: number;
                server_num: number;
                server_name: string;
                /** 世界等级 */
                wlv: number;
            }[];
        };
    };
    50623: {
        desc: "会长选择领地";
        send: (
            number: 50623,
            fmt: "i",
            args: [
                /**领地id*/
                territory_id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**领地id*/
            territory_id: number
        ];
        recv: {
            code: number;
            /** 领地id */
            territory_id: number;
        };
    };
    50624: {
        desc: "查看公会是否有参赛资格";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 1 有资格 */
            qualification: number;
            /** 1 已选择 */
            is_choose_terri_id: number;
        };
    };
    50625: {
        desc: "战斗结束，刷新参赛资格";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 1 有资格 */
            qualification: number;
        };
    };
    50626: {
        desc: "领地选择状态广播";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 1 重新请求21协议刷新界面 */
            up_war_list: number;
        };
    };
    50627: {
        desc: "轮次战斗开始，推送相关公会成员信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            territory_id: number;
        };
    };
}

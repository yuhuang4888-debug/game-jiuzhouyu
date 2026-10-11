/** 跨服服战
 */
declare interface ProtoFmtInfo {
    60100: {
        desc: "错误码";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            errcode: number;
            /**  参数 */
            args: string;
        };
    };
    60101: {
        desc: "活动信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 当前服是否已经开启服战功能 0: 未开启 1: 已开启 */
            is_open: number;
            /** 0:休战期 1:准备期(客户端处理成0状态即可) 2:约战期 3: 确认期 4:对战期 5:战斗空窗期 */
            status: number;
            /** 第几轮 */
            round: number;
            /** 当前阶段结束时间戳 */
            etime: number;
            /** 赛季开始时间 */
            season_stime: number;
            /** 赛季结束时间 */
            season_etime: number;
        };
    };
    60102: {
        desc: "约战期界面信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 本服排名 */
            ranking: number;
            /** 本服积分 */
            score: number;
            /** 0: 未报名 1: 已报名 */
            is_sign_up: number;
            /** 报名所需最低战力 */
            min_power: number;
            /** 当前约战的服务器id */
            appoint_id: number;
            /** 约战人玩家id 0:表示本服没有约战人 */
            dominator_id: number;
            /**  约战人所属公会名字 */
            dominator_gname: string;
            /**  约战人名字 */
            dominator_name: string;
        };
    };
    60103: {
        desc: "确定期界面信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 本服排名 */
            ranking: number;
            /** 本服积分 */
            score: number;
            list: {
                /** 轮次 */
                round: number;
                /** 攻方服务器id  0: 表示怪物入侵 */
                att_id: number;
                /**  攻方服务器名字 */
                att_ser_name: string;
                /** 守方服务器id  0: 表示怪物入侵 */
                def_id: number;
                /**  守方服务器名字 */
                def_ser_name: string;
                /** 获胜类型 0: 未出结果 1: 攻方获胜 2: 守方获胜 */
                win_type: number;
            }[];
        };
    };
    60104: {
        desc: "战斗期界面信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 是否是参赛选手 0: 不是 1: 是 */
            is_contestant: number;
            /** 本服排名 */
            ranking: number;
            /** 本服积分 */
            score: number;
            list: {
                /** 轮次 */
                round: number;
                /** 攻方服务器id  0: 表示怪物入侵 */
                att_id: number;
                /**  攻方服务器名字 */
                att_ser_name: string;
                /** 守方服务器id  0: 表示怪物入侵 */
                def_id: number;
                /**  守方服务器名字 */
                def_ser_name: string;
                /** 获胜类型 0: 未出结果 1: 攻方获胜 2: 守方获胜 */
                win_type: number;
            }[];
        };
    };
    60105: {
        desc: "休战期界面信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 本服排名 */
            ranking: number;
            /** 本服积分 */
            score: number;
        };
    };
    60106: {
        desc: "参赛选手界面";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 0: 未报名 1: 已报名 */
            is_sign_up: number;
            /** 排名 0: 榜单外 >0: 实际排名 未报名的玩家直接显示未报名 不需用到这个字段 */
            ranking: number;
            /**  玩家名字 */
            role_name: string;
            /**  所属公会名字 */
            guild_name: string;
            /** 玩家历史最高战力 */
            h_combat_power: number;
            role_list: {
                /** 排名 */
                ranking: number;
                /**  玩家名字 */
                role_name: string;
                /**  所属公会名字 */
                guild_name: string;
                /** 历史最高战力 */
                h_combat_power: number;
            }[];
        };
    };
    60107: {
        desc: "约战界面";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 本服积分 */
            score: number;
            /** 本服排名 */
            ranking: number;
            /** 约战人玩家id 0:表示本服没有约战人 */
            dominator_id: number;
            /**  约战人所属公会名字 */
            dominator_gname: string;
            /**  约战人名字 */
            dominator_name: string;
            /** 本服约战的服务器id 0表示本服未约战 */
            appoint_id: number;
            server_list: {
                /** 服务器id */
                server_id: number;
                /**  服务器名字 */
                server_name: string;
                /** 积分 */
                score: number;
                /** 排名 */
                ranking: number;
                /** 该服下次可被约战时间 小于这个时间表示该服处于约战冷却期 */
                can_be_appoint_time: number;
                /** 该服被约战记录 */
                be_appoint_record: {
                    /**  服务器名字 */
                    server_name: string;
                    /** 消耗积分 */
                    cost_score: number;
                    /** 时间 */
                    time: number;
                }[];
            }[];
        };
    };
    60108: {
        desc: "约战确认界面";
        send: (
            number: 60108,
            fmt: "h",
            args: [
                /**要约战的服务器id*/
                server_id: number
            ]
        ) => never;
        sendFmt: "h";
        sendArgs: [
            /**要约战的服务器id*/
            server_id: number
        ];
        recv: {
            /** 约战需要积分 */
            appoint_score: number;
            /** 胜利净赚积分 */
            obtain_score: number;
            /** 失败失去积分 */
            lose_score: number;
        };
    };
    60109: {
        desc: "约战";
        send: (
            number: 60109,
            fmt: "h",
            args: [
                /**要约战的服务器id*/
                server_id: number
            ]
        ) => never;
        sendFmt: "h";
        sendArgs: [
            /**要约战的服务器id*/
            server_id: number
        ];
        recv: {
            /** 返回码 */
            errcode: number;
        };
    };
    60110: {
        desc: "报名";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 返回码 */
            errcode: number;
        };
    };
    60111: {
        desc: "排名奖励界面";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            rank_list: {
                /** 服务器id 0表示当前排名未有服务器 */
                server_id: number;
                /**  服务器名字 */
                server_name: string;
                /** 积分 */
                score: number;
                /** 排名 */
                ranking: number;
                reward: {
                    /** 物品类型 */
                    object_type: number;
                    /** 物品类型id */
                    type_id: number;
                    /** 数量 */
                    num: number;
                }[];
            }[];
        };
    };
    60112: {
        desc: "对战表界面";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            list: {
                /** 轮次 */
                round: number;
                /** 攻方服务器id */
                att_id: number;
                /**  攻方服务器名字 */
                att_ser_name: string;
                /** 守方服务器id */
                def_id: number;
                /**  守方服务器名字 */
                def_ser_name: string;
                /** 获胜类型 0: 未出结果 1: 攻方获胜 2: 守方获胜 */
                win_type: number;
            }[];
        };
    };
    60113: {
        desc: "场景列表";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 攻方服务器id */
            att_id: number;
            /**  攻方服务器名字 */
            att_ser_name: string;
            /** 守方服务器id */
            def_id: number;
            /**  守方服务器名字 */
            def_ser_name: string;
            /** 是否是参赛选手 0: 不是 1: 是 */
            is_contestant: number;
            list: {
                /** 战斗场景编号 */
                id: number;
                /** 第几个场景 */
                index: number;
            }[];
        };
    };
    60114: {
        desc: "房间信息";
        send: (
            number: 60114,
            fmt: "h",
            args: [
                /**战斗场景编号*/
                id: number
            ]
        ) => never;
        sendFmt: "h";
        sendArgs: [
            /**战斗场景编号*/
            id: number
        ];
        recv: {
            /** 战斗场景编号 */
            id: number;
            /** 核心血量 */
            hp: number;
            /** 攻方人数 */
            att_num: number;
            /** 守方人数 */
            def_num: number;
            /** 战场是否已经结束 0: 未结束 1: 已结束 */
            is_end: number;
        };
    };
    60115: {
        desc: "进入场景";
        send: (
            number: 60115,
            fmt: "h",
            args: [
                /**战斗场景编号*/
                id: number
            ]
        ) => never;
        sendFmt: "h";
        sendArgs: [
            /**战斗场景编号*/
            id: number
        ];
        recv: {
            /** 错误码 */
            errcode: number;
        };
    };
    60116: {
        desc: "退出场景";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            errcode: number;
        };
    };
    60117: {
        desc: "战斗信息(客户端进入场景后自行请求)";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 1: PVP 2: 怪物入侵 */
            type: number;
            /** 1: 进攻方 2: 防守方 */
            tag: number;
            /** 本轮结束时间戳 */
            etime: number;
            /** 作战阶段 */
            stage: number;
            /** 下一波刷怪时间 0: 表示没有下一波 怪物入侵且本方为防守方的时候才需要用到 */
            next_wave: number;
            list: {
                /** 怪物KeyId */
                id: number;
                /** 怪物类型id */
                mid: number;
                /** 血量 */
                hp: number;
            }[];
        };
    };
    60118: {
        desc: "下一波刷怪时间更新";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 下一波刷怪时间 0: 表示没有下一波 怪物入侵且本方为防守方的时候才需要用到 */
            next_wave: number;
        };
    };
    60119: {
        desc: "战斗阶段更新";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 作战阶段 */
            stage: number;
            list: {
                /** 怪物KeyId */
                id: number;
                /** 怪物类型id */
                mid: number;
                /** 血量 */
                hp: number;
            }[];
        };
    };
    60120: {
        desc: "血量更新";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            list: {
                /** 怪物KeyId */
                id: number;
                /** 怪物类型id */
                mid: number;
                /** 血量 */
                hp: number;
            }[];
        };
    };
    60121: {
        desc: "战斗结果";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 1: 攻方胜利 2: 守方胜利 */
            type: number;
        };
    };
    60122: {
        desc: "服战结果";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 获胜服务器id */
            winner_id: number;
            list: {
                /** 排名 */
                ranking: number;
                /** 服务器id */
                server_id: number;
                /** 玩家id */
                role_id: number;
                /**  玩家名字 */
                role_name: string;
                /** 击杀数 */
                kill_num: number;
                /** 连杀数 */
                combo: number;
                reward: {
                    /** 物品类型 */
                    object_type: number;
                    /** 物品类型id */
                    type_id: number;
                    /** 数量 */
                    num: number;
                }[];
            }[];
        };
    };
    60123: {
        desc: "服战排名界面";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            server_list: {
                /**  服务器名字 */
                server_name: string;
                /**  约战人所属公会名字 */
                dominator_gname: string;
                /**  约战人名字 */
                dominator_name: string;
                /** 积分 */
                score: number;
                /** 排名 */
                ranking: number;
            }[];
        };
    };
    60124: {
        desc: "通知玩家进入服战场景";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: null;
    };
}

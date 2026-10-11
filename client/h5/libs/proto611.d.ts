/** 副本信息2
 */
declare interface ProtoFmtInfo {
    61101: {
        desc: "副本技能列表";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            skill_list: {
                skill_id: number;
                skill_lv: number;
            }[];
        };
    };
    61102: {
        desc: "进入使魔副本";
        send: (
            number: 61102,
            fmt: "iA",
            args: [
                /**副本id*/
                dun_id: number,
                pet: any
            ]
        ) => never;
        sendFmt: "iA";
        sendArgs: [
            /**副本id*/
            dun_id: number,
            pet: any
        ];
        recv: null;
    };
    61103: {
        desc: "当前通关副本id";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 副本id */
            dun_id: number;
            /** 昨日副本id */
            yesterday_dun_id: number;
            demon_list: {
                /** 使魔id */
                demon_id: number;
            }[];
            /** 0 未扫荡  1 已经扫荡 */
            have_sweep: number;
        };
    };
    61104: {
        desc: "扫荡";
        send: (
            number: 61104,
            fmt: "i",
            args: [
                /**副本id*/
                dun_id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**副本id*/
            dun_id: number
        ];
        recv: null;
    };
    61105: {
        desc: "伙伴副本界面";
        send: (
            number: 61105,
            fmt: "c",
            args: [
                /**层数*/
                level: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**层数*/
            level: number
        ];
        recv: {
            /** 层数 */
            level: number;
            /** 当前扫荡次数 */
            sweep_count: number;
            dun_list: {
                /** 副本id */
                dun_id: number;
                /** 评级 */
                score: number;
            }[];
        };
    };
    61106: {
        desc: "伙伴副本阶段奖励";
        send: (
            number: 61106,
            fmt: "c",
            args: [
                /**层数*/
                level: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**层数*/
            level: number
        ];
        recv: {
            /** 层数 */
            level: number;
            stage_reward: {
                /** 评级 */
                score: number;
                /** 状态    0 不可以领取 1 可以领取   2已经领取 */
                status: number;
            }[];
        };
    };
    61107: {
        desc: "伙伴副本首通";
        send: (
            number: 61107,
            fmt: "i",
            args: [
                /**层数*/
                dun_id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**层数*/
            dun_id: number
        ];
        recv: {
            dun_id: number;
            role_id: number;
            role_name: string;
        };
    };
    61108: {
        desc: "伙伴副本领取阶段奖励";
        send: (
            number: 61108,
            fmt: "cc",
            args: [
                /**层数*/
                level: number,
                /**评级*/
                score: number
            ]
        ) => never;
        sendFmt: "cc";
        sendArgs: [
            /**层数*/
            level: number,
            /**评级*/
            score: number
        ];
        recv: {
            code: number;
            reward_lists: any;
        };
    };
    61109: {
        desc: "伙伴副本扫荡";
        send: (
            number: 61109,
            fmt: "c",
            args: [
                /**层数*/
                level: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**层数*/
            level: number
        ];
        recv: {
            code: number;
            reward_lists: any;
            /** 多倍奖励 */
            mul_reward_lists: any;
            /** 多倍奖励倍数 */
            mul: number;
        };
    };
    61110: {
        desc: "伙伴副本怪物信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            mon_lists: {
                mon_id: number;
                /** 击杀怪物 */
                cur_num: number;
                /** 数量 */
                all_num: number;
            }[];
        };
    };
    61111: {
        desc: "玩家完成切换场景进入副本";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: null;
    };
    61112: {
        desc: "副本奖励领取";
        send: (
            number: 61112,
            fmt: any,
            args: [
                /**副本奖励参数列表*/
                reward_args_list: any
            ]
        ) => never;
        sendFmt: any;
        sendArgs: [
            /**副本奖励参数列表*/
            reward_args_list: any
        ];
        recv: {
            /** 错误码 */
            code: number;
            /** 副本奖励参数列表 */
            reward_args_list: {
                /** 副本id */
                dun_id: number;
                /** 奖励类型 */
                reward_type: number;
            }[];
            reward_list: any;
        };
    };
    61113: {
        desc: "副本奖励界面";
        send: (
            number: 61113,
            fmt: "c",
            args: [
                /**副本类型*/
                dun_type: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**副本类型*/
            dun_type: number
        ];
        recv: {
            /** 副本类型 */
            dun_type: number;
            dun_list: {
                /** 副本id */
                dun_id: number;
                /** 奖励类型 */
                reward_type: number;
                /** 0:未领取 1:已经领取了 2:不可领取 */
                reward_status: number;
            }[];
        };
    };
    61114: {
        desc: "符文本领取每日奖励";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            code: number;
            reward_list: any;
        };
    };
    61115: {
        desc: "符文本奖励领取状态";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 每日奖励领取状态 0 不可领取 1 可领取 2 已领取 */
            daily_status: number;
            /** 御魂解锁层级 */
            unlock_level: number;
        };
    };
    61116: {
        desc: "符文本解锁层级";
        send: (
            number: 61116,
            fmt: "i",
            args: [
                /**解锁层级*/
                level: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**解锁层级*/
            level: number
        ];
        recv: {
            /** 错误码 */
            code: number;
            /** 当前解锁御魂层级 */
            level: number;
        };
    };
    61117: {
        desc: "限时爬塔面板信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 当前轮数 */
            round: number;
            /** 结束时间戳 */
            over_time: number;
            /** 大奖的领奖状态 */
            reward_mode: number;
            pass_list: {
                /** 已通过的副本id */
                dun_id: number;
            }[];
        };
    };
    61118: {
        desc: "限时爬塔关卡大奖领取";
        send: (
            number: 61118,
            fmt: "c",
            args: [
                /**轮数*/
                round: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**轮数*/
            round: number
        ];
        recv: {
            /** 领取结果 */
            code: number;
        };
    };
    61119: {
        desc: "经验本触发获取经验yy25d经验本不由击杀怪物过去经验，根据在副本时间获取";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 下次触发经验时间(毫秒) */
            next_time: number;
        };
    };
    61120: {
        desc: "资源副本一键操作";
        send: (
            number: 61120,
            fmt: "c",
            args: [
                /**操作类型 1-一键挑战 2-一键扫荡*/
                oper_type: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**操作类型 1-一键挑战 2-一键扫荡*/
            oper_type: number
        ];
        recv: {
            /** 结束时间戳 */
            code: number;
            /** 操作类型 1-一键挑战 2-一键扫荡 */
            oper_type: number;
            sweep_list: {
                reward_list: {
                    /** 物品大类型 */
                    style: number;
                    /** 物品id */
                    typeId: number;
                    /** 数量 */
                    count: number;
                    /** 物品唯一id */
                    goods_id: number;
                }[];
                /** 额外奖励 */
                other_reward: {
                    /** 奖励类型  1:多倍奖励 9:周卡奖励 */
                    reward_type: number;
                    other_reward_list: {
                        /** 物品大类型 */
                        style1: number;
                        /** 物品id */
                        type_id1: number;
                        /** 数量 */
                        count1: number;
                        /** 物品唯一id */
                        goods_id1: number;
                    }[];
                }[];
            }[];
        };
    };
    61121: {
        desc: "获取某种资源副本次数";
        send: (
            number: 61121,
            fmt: "c",
            args: [
                /**副本类型*/
                dun_type: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**副本类型*/
            dun_type: number
        ];
        recv: {
            count_list: {
                /** 副本类型 */
                dun_type: number;
                /** 副本扫荡次数 */
                sweep_count: number;
                /** 副本挑战次数 */
                challenge_count: number;
            }[];
        };
    };
}

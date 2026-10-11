/** 幻饰boss信息
 */
declare interface ProtoFmtInfo {
    47101: {
        desc: "幻饰boss信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 状态 0:开启;1:小跨服区域分配中 */
            act_status: number;
            /** 进入次数 */
            count: number;
            /** 协助次数 */
            assist_count: number;
            /** 购买的次数 */
            buy_count: number;
            /** 增加进入次数 */
            add_count: number;
            /** 是否双倍buff */
            in_buff: number;
            /** 击杀数量 */
            kill_count: number;
            /** 是否存活 */
            is_alive: number;
            /** 特殊boss人数 */
            sboss_role_num: number;
            boss_list: {
                boss_id: number;
                /** 复活结束时间戳：0|>0 */
                reborn_time: number;
                /** 人数 */
                role_num: number;
                /** 是否协助 */
                is_had_assist: number;
            }[];
        };
    };
    47102: {
        desc: "进入boss";
        send: (
            number: 47102,
            fmt: "ic",
            args: [
                /**bossid*/
                boss_id: number,
                /**进入类型##1:消耗进入 2:协助进入*/
                type: number
            ]
        ) => never;
        sendFmt: "ic";
        sendArgs: [
            /**bossid*/
            boss_id: number,
            /**进入类型##1:消耗进入 2:协助进入*/
            type: number
        ];
        recv: {
            error_code: number;
            boss_id: number;
            type: number;
        };
    };
    47103: {
        desc: "退出";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            error_code: number;
        };
    };
    47104: {
        desc: "购买次数";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            error_code: number;
        };
    };
    47105: {
        desc: "取消关注列表";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            unfollow_list: {
                /** 怪物id */
                boss_id: number;
            }[];
        };
    };
    47106: {
        desc: "关注";
        send: (
            number: 47106,
            fmt: "ic",
            args: [
                /**怪物id*/
                boss_id: number,
                /**关注*/
                is_follow: number
            ]
        ) => never;
        sendFmt: "ic";
        sendArgs: [
            /**怪物id*/
            boss_id: number,
            /**关注*/
            is_follow: number
        ];
        recv: {
            /** 错误码 */
            error_code: number;
            /** 怪物id */
            boss_id: number;
            /** 关注 */
            is_follow: number;
        };
    };
    47107: {
        desc: "boss/特殊boss复活通知";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** bossid */
            boss_id: number;
        };
    };
    47108: {
        desc: "BOSS掉落记录";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            drop_log: {
                /** 玩家id */
                role_id: number;
                /** 服id */
                server_id: number;
                server_num: number;
                name: string;
                boss_id: number;
                /** 物品类型id */
                goods_id: number;
                /** 数量 */
                num: number;
                /** 装备评分 */
                rating: number;
                /** 装备附加属性(极品属性) */
                equip_extra_attr: {
                    /** 颜色 参考后台颜色配置 */
                    color: number;
                    /** 类型 1: 成长型属性 2: 百分比加成属性 */
                    type_id: number;
                    /** 属性类型 */
                    attr_id: number;
                    /** 属性值 */
                    attr_val: number;
                    /** 每多少级增加(成长型属性使用) */
                    plus_interval: number;
                    /** 每隔多少级增加多少属性(成长型属性使用) */
                    plus_unit: number;
                }[];
                time: number;
            }[];
        };
    };
    47109: {
        desc: "特殊boss个人排名";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            rank_list: {
                role_id: number;
                name: string;
                server_id: number;
                server_num: number;
                server_name: string;
                hurt: number;
            }[];
        };
    };
    47110: {
        desc: "进入特殊boss";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            error_code: number;
        };
    };
    47111: {
        desc: "公会求助";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            error_code: number;
        };
    };
    47112: {
        desc: "特殊boss个人伤害";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            role_id: number;
            name: string;
            server_id: number;
            server_num: number;
            server_name: string;
            hurt: number;
        };
    };
    47113: {
        desc: "boss结算";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 是否有归属 */
            is_belong: number;
            /** 是否使用双倍卡 */
            is_double: number;
            /** 奖励 */
            reward_type_list: {
                /** 奖励类型 */
                reward_type: number;
                reward_list: {
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
            /** 双倍奖励 */
            reward_type_list2: {
                /** 奖励类型 */
                reward_type2: number;
                reward_list2: {
                    /** 物品大类型 */
                    style2: number;
                    /** 物品id */
                    type_id2: number;
                    /** 数量 */
                    count2: number;
                    /** 物品唯一id */
                    goods_id2: number;
                }[];
            }[];
        };
    };
    47114: {
        desc: "战斗场景信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 进入类型##1:消耗进入 2:协助进入 */
            enter_type: number;
            /** 退出时间戳 */
            quit_time: number;
            /** 复活倒计时##特殊boss:期间不复活会主动踢出场景;普通boss:期间不复活会复活到安全点 */
            revive_time: number;
        };
    };
    47115: {
        desc: "退出时间";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 退出时间戳 */
            quit_time: number;
        };
    };
    47116: {
        desc: "复活时间";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 复活倒计时##特殊boss:期间不复活会主动踢出场景;普通boss:期间不复活会复活到安全点 */
            revive_time: number;
        };
    };
    47117: {
        desc: "boss/特殊boss死亡";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** bossid */
            boss_id: number;
            /** 复活结束时间戳：0|>0;(注意:普通boss使用) */
            reborn_time: number;
        };
    };
}

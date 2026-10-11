/** 幻兽之域信息
 */
declare interface ProtoFmtInfo {
    47000: {
        desc: "怪物(采集,Boss)列表信息";
        send: (
            number: 47000,
            fmt: "c",
            args: [
                /**boss类型 1:幻兽boss*/
                boss_type: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**boss类型 1:幻兽boss*/
            boss_type: number
        ];
        recv: {
            boss_type: number;
            /** boss状态 1 正常 2重置中 */
            act_status: number;
            /** 重置结束时间戳 */
            reset_etime: number;
            /** boss的已使用的疲劳值 */
            tired: number;
            /** 总疲劳值 */
            max_tired: number;
            collect_list: {
                /** 1 普通 2 稀有 */
                type: number;
                /** 采集次数 */
                collect_times: number;
                /** 总采集次数 */
                total_collect_times: number;
            }[];
            boss_info: {
                /** BossId */
                boss_id: number;
                /** 采集怪剩余的数量 */
                num: number;
                /** 复活结束时间戳：0|>0 */
                reborn_time: number;
                /** 是否关注：0|1 */
                is_remind: number;
            }[];
        };
    };
    47001: {
        desc: "幻兽BOSS击杀记录";
        send: (
            number: 47001,
            fmt: "ci",
            args: [boss_type: number, boss_id: number]
        ) => never;
        sendFmt: "ci";
        sendArgs: [boss_type: number, boss_id: number];
        recv: {
            kill_log: {
                /** 击杀时间 */
                time: number;
                /**  服务器名字 */
                s_name: string;
                /** 玩家id */
                role_id: number;
                /**  击杀名字 */
                name: string;
            }[];
        };
    };
    47002: {
        desc: "幻兽BOSS掉落记录";
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
                /** 层数 */
                layers: number;
                /** 物品类型id */
                goods_id: number;
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
    47003: {
        desc: "进入幻兽之域";
        send: (
            number: 47003,
            fmt: "ci",
            args: [boss_type: number, boss_id: number]
        ) => never;
        sendFmt: "ci";
        sendArgs: [boss_type: number, boss_id: number];
        recv: {
            code: number;
        };
    };
    47004: {
        desc: "退出幻兽之域";
        send: (number: 47004, fmt: "c", args: [boss_type: number]) => never;
        sendFmt: "c";
        sendArgs: [boss_type: number];
        recv: {
            code: number;
        };
    };
    47005: {
        desc: "幻兽之域BOSS关注|取消关注操作";
        send: (
            number: 47005,
            fmt: "cic",
            args: [
                boss_type: number,
                boss_id: number,
                /**是否关注0|1*/
                remind: number
            ]
        ) => never;
        sendFmt: "cic";
        sendArgs: [
            boss_type: number,
            boss_id: number,
            /**是否关注0|1*/
            remind: number
        ];
        recv: {
            code: number;
            boss_type: number;
            boss_id: number;
            remind: number;
        };
    };
    47006: {
        desc: "幻兽之域BOSS重生提醒";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            boss_type: number;
            boss_id: number;
        };
    };
    47007: {
        desc: "幻兽之域BOSS被击杀信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            boss_type: number;
            /** BossId */
            boss_id: number;
            /** 复活结束时间戳 */
            reborn_time: number;
            /** 剩余活着的数量 */
            num: number;
        };
    };
    47008: {
        desc: "幻兽之域BOSS怪物重生刷新信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            boss_type: number;
            /** BossId */
            boss_id: number;
            /** 复活结束时间戳 */
            reborn_time: number;
            /** 剩余活着的数量 */
            num: number;
        };
    };
    47009: {
        desc: "疲劳值更新";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            boss_tired: number;
        };
    };
    47010: {
        desc: "幻兽之域的错误提示码";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            code: number;
        };
    };
    47011: {
        desc: "同区域服务器列表";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 下次重置时间 */
            next_reset_time: number;
            server_list: {
                /** 服务器id */
                server_id: number;
                /** 区域id */
                zone_id: number;
                server_num: number;
                /**  服务器名 */
                server_name: string;
                /** 开服时间 */
                optime: number;
            }[];
        };
    };
    47015: {
        desc: "结算奖励";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 奖励类型##1:归属 2:普通 3 采集宝箱奖励 */
            reward_type: number;
            reward_list: {
                /** 类型 */
                type: number;
                /** 物品类型 */
                goods_type_id: number;
                /** 物品数量 */
                num: number;
                /** 唯一id */
                id: number;
            }[];
        };
    };
    47016: {
        desc: "个人信息推送";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            info_list: {
                /** 1 普通 2 稀有 3 圣主采集怪 4 任务采集怪 */
                key: number;
                /** 值 */
                val: number;
            }[];
        };
    };
    47017: {
        desc: "进场景宝箱信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            info: {
                boss_id: number;
                xylist: {
                    x: number;
                    y: number;
                }[];
            }[];
        };
    };
    47018: {
        desc: "宝箱信息更新";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            boss_id: number;
            xylist: {
                x: number;
                y: number;
            }[];
        };
    };
    47019: {
        desc: "狩猎等级信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            level: number;
            exp: number;
            /** 经验增加值 */
            add_exp: number;
        };
    };
    47021: {
        desc: "圣兽领榜单";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            player_list: {
                role_id: number;
                role_name: string;
                server_id: number;
                server_num: number;
                /** 击杀boss的总积分(对应boss榜) */
                score: number;
                /** 对应boss积分榜单的排序键值(时间戳) */
                sort_key1: number;
                /** 击杀玩家数(对应击杀榜) */
                kill_num: number;
                /** 对应击杀榜的排序键值(时间戳) */
                sort_key2: number;
                /** 总积分(对应总榜单) */
                total_score: number;
                /** 对应总榜单的排序键值(时间戳) */
                sort_key3: number;
            }[];
        };
    };
    47022: {
        desc: "玩家获得积分推送";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 1击杀玩家 2击杀boss 3采集 */
            score_type: number;
            score_add: number;
        };
    };
    47023: {
        desc: "最大疲劳值变化刷新";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 总疲劳值 */
            max_tired: number;
        };
    };
    47034: {
        desc: "玩家死亡次数";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 死亡次数 */
            die_times: number;
            /** 死亡等待结束时间 */
            time: number;
            /** debuff持续时间 */
            debuff_time: number;
            /** 玩家回安全区时间 */
            safe_time: number;
        };
    };
    47035: {
        desc: "复活boss";
        send: (
            number: 47035,
            fmt: "ci",
            args: [boss_type: number, boss_id: number]
        ) => never;
        sendFmt: "ci";
        sendArgs: [boss_type: number, boss_id: number];
        recv: {
            errcode: number;
            boss_type: number;
            boss_id: number;
        };
    };
}

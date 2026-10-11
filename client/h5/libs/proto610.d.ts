/** 副本信息
 */
declare interface ProtoFmtInfo {
    61000: {
        desc: "%%-----------------------副本结果类型------------------------define(DUN_RESULT_TYPE_NO,0).%没有结算-define(DUN_RESULT_TYPE_SUCCESS,1).%挑战成功-define(DUN_RESULT_TYPE_FAIL,2).%挑战失败%子类型-define(DUN_RESULT_SUBTYPE_NO,0).%无-define(DUN_RESULT_SUBTYPE_TIMEOUT,1).%副本超时-define(DUN_RESULT_SUBTYPE_DELAY_LOGOUT,2).%玩家延迟登出-define(DUN_RESULT_SUBTYPE_SKIP_DUNGEON,3).%跳过副本-define(DUN_RESULT_SUBTYPE_ACTIVE_QUIT,4).%副本主动退出-define(DUN_RESULT_SUBTYPE_LOGOUT,5).%玩家登出-define(DUN_RESULT_SUBTYPE_PASSIVE_FORCE_QUIT,6).%被动强制退出-define(DUN_RESULT_SUBTYPE_PASSIVE_FLOW_QUIT,7).%被动流程退出通用错误返回";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            error_code: number;
            error_code_args: string;
        };
    };
    61001: {
        desc: "进入副本";
        send: (number: 61001, fmt: "i", args: [dun_id: number]) => never;
        sendFmt: "i";
        sendArgs: [dun_id: number];
        recv: {
            /** 副本id */
            dun_id: number;
            /** 场景id */
            scene_id: number;
            /** 错误码 */
            error_code: number;
            /**  错误码参数 */
            error_code_args: string;
        };
    };
    61002: {
        desc: "退出副本";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            error_code: number;
        };
    };
    61003: {
        desc: "通用结算界面";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 结果 */
            result: number;
            /** 结果子类型 */
            result_subtype: number;
            /** 副本id */
            dun_id: number;
            /** 星级评价 */
            grade: number;
            /** 场景id */
            scene_id: number;
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
            ex_data: {
                /** 由双端协议值的意义 */
                key: number;
                val: number;
            }[];
            /** 副本合并次数 */
            count: number;
        };
    };
    61004: {
        desc: "副本信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 副本开始时间 */
            start_time: number;
            /** 副本开始时间(毫秒) */
            start_time_ms: number;
            /** 副本结束时间 */
            end_time: number;
            /** 关卡 */
            level: number;
            /** 关卡结束时间 */
            level_end_time: number;
            /** 副本创建者id */
            owner_id: number;
            /** 波数 */
            wave_num: number;
        };
    };
    61005: {
        desc: "刷怪通知";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 副本id */
            dun_id: number;
            /** 场景id */
            scene_id: number;
            /** 副本波数类型 */
            type: number;
            /** 触发时间戳 */
            time: number;
            /** 波数 */
            wave_num: number;
        };
    };
    61006: {
        desc: "事件触发目的:减少服务端压力,由客户端发送,服务端校验";
        send: (
            number: 61006,
            fmt: "c",
            args: [
                /**事件类型Id*/
                event_type_id: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**事件类型Id*/
            event_type_id: number
        ];
        recv: null;
    };
    61007: {
        desc: "坐标事件";
        send: (
            number: 61007,
            fmt: "hh",
            args: [
                /**X坐标*/
                x: number,
                /**Y坐标*/
                y: number
            ]
        ) => never;
        sendFmt: "hh";
        sendArgs: [
            /**X坐标*/
            x: number,
            /**Y坐标*/
            y: number
        ];
        recv: {
            /** X坐标 */
            x: number;
            /** Y坐标 */
            y: number;
        };
    };
    61009: {
        desc: "播放剧情";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 剧情id */
            story_id: number;
            /** 剧情子id */
            sub_sotry_id: number;
        };
    };
    61010: {
        desc: "发送剧情事件";
        send: (
            number: 61010,
            fmt: "iic",
            args: [
                /**剧情id*/
                story_id: number,
                /**剧情子id*/
                sub_sotry_id: number,
                /**0:没有结束(剧情开始);1:剧情结束*/
                is_end: number
            ]
        ) => never;
        sendFmt: "iic";
        sendArgs: [
            /**剧情id*/
            story_id: number,
            /**剧情子id*/
            sub_sotry_id: number,
            /**0:没有结束(剧情开始);1:剧情结束*/
            is_end: number
        ];
        recv: null;
    };
    61011: {
        desc: "助战剩余次数";
        send: (
            number: 61011,
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
        recv: {
            /** 副本id */
            dun_id: number;
            /** 助战次数 */
            left_help_count: number;
        };
    };
    61012: {
        desc: "篝火结束通知";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: null;
    };
    61013: {
        desc: "结算界面加好友,邀请加入公会,积分展示";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 结果(跟61003一致) */
            result: number;
            /** 助战类型 0:无;1:是 */
            help_type: number;
            /** 积分 */
            score: number;
            /** 通关时间 */
            pass_time: number;
            rela_list: {
                /** 玩家id */
                role_id: number;
                /** 1:好友 */
                rela_type: number;
                /** 亲密度 */
                intimacy: number;
                /** 是否请求加好友 0:无 1:是 */
                is_ask_add: number;
                /** 公会id */
                guild_id: number;
            }[];
            drop_reward: any;
            reward_list: any;
        };
    };
    61014: {
        desc: "剧情播放通知";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            story_list: {
                /** 剧情id */
                story_id: number;
                /** 剧情子id */
                sub_sotry_id: number;
                /** 是否结束(0:没有结束;1:结束) */
                is_end: number;
            }[];
        };
    };
    61015: {
        desc: "关卡结算";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 副本id */
            dun_id: number;
            /** 场景id */
            scene_id: number;
            /** 关卡 */
            level: number;
            /** 是否最后一关卡 */
            is_last_level: number;
            /** 结果 */
            result: number;
            reward_list: any;
        };
    };
    61016: {
        desc: "结算界面2(关卡)加好友,邀请加入公会,积分展示";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 助战类型 0:无;1:是 */
            help_type: number;
            /** 积分 */
            score: number;
            /** 通关时间 */
            pass_time: number;
            /** 关卡列表 */
            level_list: {
                /** 关卡 */
                level: number;
                /** 积分 */
                score: number;
            }[];
            rela_list: {
                /** 玩家id */
                role_id: number;
                /** 1:好友 */
                rela_type: number;
                /** 亲密度 */
                intimacy: number;
                /** 是否请求加好友 0:无 1:是 */
                is_ask_add: number;
                /** 公会id */
                guild_id: number;
            }[];
            reward_list: any;
        };
    };
    61017: {
        desc: "跳过副本";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            error_code: number;
        };
    };
    61018: {
        desc: "退出副本时间";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 0:无配置 1:需要倒数 */
            type: number;
            end_time: number;
        };
    };
    61019: {
        desc: "发送坐标事件的触发情况";
        send: (
            number: 61019,
            fmt: "i",
            args: [
                /**场景id*/
                scene_id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**场景id*/
            scene_id: number
        ];
        recv: {
            xy_list: {
                /** x坐标 */
                x: number;
                /** y坐标 */
                y: number;
            }[];
        };
    };
    61020: {
        desc: "获取副本状态信息";
        send: (
            number: 61020,
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
            dun_type: number;
            /** 副本信息 */
            dun_list: {
                /** 副本id */
                dun_id: number;
                /** 日次数 */
                daily_count: number;
                /** 周次数 */
                weekly_count: number;
                /** 永久次数 */
                permanent_count: number;
                /** 已重置次数 */
                reset_count: number;
                /** 购买次数 */
                vip_count: number;
                /** 增加次数 */
                add_count: number;
                /** 是否能扫荡##服务端尽可能校验,某些数据难以获取客户端也需要校验部分 */
                is_sweep: number;
                /** 记录信息 不同副本可能需要不同的值 */
                rec_data: {
                    /** 键 双端协商定义 */
                    key: number;
                    /** 值 */
                    val: number;
                }[];
            }[];
        };
    };
    61021: {
        desc: "购买副本次数";
        send: (
            number: 61021,
            fmt: "ih",
            args: [
                /**副本id*/
                dun_id: number,
                /**次数*/
                count: number
            ]
        ) => never;
        sendFmt: "ih";
        sendArgs: [
            /**副本id*/
            dun_id: number,
            /**次数*/
            count: number
        ];
        recv: {
            /** 错误码 */
            error_code: number;
            /** 副本id */
            dun_id: number;
            /** 已购买总次数 */
            buy_count: number;
        };
    };
    61022: {
        desc: "扫荡";
        send: (
            number: 61022,
            fmt: "ih",
            args: [
                dun_id: number,
                /**扫荡次数*/
                auto_num: number
            ]
        ) => never;
        sendFmt: "ih";
        sendArgs: [
            dun_id: number,
            /**扫荡次数*/
            auto_num: number
        ];
        recv: {
            error_code: number;
            dun_id: number;
            grade: number;
            /** 剩余次数 */
            left_count: number;
            /** 扫荡次数 */
            auto_num: number;
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
    61023: {
        desc: "获取当前时间评分状态";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            cur_score: number;
            next_score: number;
            /** 时间戳 为0的时候则不会再变化 */
            change_time: number;
        };
    };
    61024: {
        desc: "获取副本是否可用";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            dun_list: {
                /** 副本类型 */
                dun_type: number;
                /** 剩余次数 */
                left_count: number;
            }[];
        };
    };
    61025: {
        desc: "鼓舞";
        send: (
            number: 61025,
            fmt: "c",
            args: [
                /**1铜币鼓舞 2元宝鼓舞*/
                cost_type: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**1铜币鼓舞 2元宝鼓舞*/
            cost_type: number
        ];
        recv: {
            /** 错误码 */
            error_code: number;
            /** 铜币鼓舞次数 */
            coin_count: number;
            /** 元宝鼓舞次数 */
            gold_count: number;
        };
    };
    61026: {
        desc: "鼓舞状态数据";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 铜币鼓舞次数 */
            coin_count: number;
            /** 元宝鼓舞次数 */
            gold_count: number;
        };
    };
    61027: {
        desc: "副本重置";
        send: (number: 61027, fmt: "i", args: [dun_id: number]) => never;
        sendFmt: "i";
        sendArgs: [dun_id: number];
        recv: {
            /** 重置成功的副本id 失败返回61000 */
            dun_id: number;
        };
    };
    61028: {
        desc: "副本批量扫荡";
        send: (number: 61028, fmt: "c", args: [dun_type: number]) => never;
        sendFmt: "c";
        sendArgs: [dun_type: number];
        recv: {
            dun_type: number;
            sweep_list: {
                dun_id: number;
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
                    /** 奖励类型  1:多倍奖励 */
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
    61029: {
        desc: "副本掉落（表现用，不是真掉落）";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            reward_list: any;
        };
    };
    61030: {
        desc: "下一波到来时间";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 当前波数 */
            wave_num: number;
            /** 下一波时间戳 */
            time: number;
        };
    };
    61031: {
        desc: "副本杀怪总数量（特定副本才有，并不是每种副本，都会记录杀怪数）";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            kill_count: number;
        };
    };
    61032: {
        desc: "伤害排行榜";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 0 表示未上榜 */
            my_rank: number;
            /** 自己伤害值 */
            my_hurt: number;
            rank_list: {
                /** 玩家id */
                role_id: number;
                /**  玩家名 */
                role_name: string;
                /** 伤害值 */
                hurt_value: number;
            }[];
        };
    };
    61033: {
        desc: "特定怪物血量变化更新";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 怪物唯一id */
            auto_id: number;
            /** 怪物配置id */
            mon_type_id: number;
            /** 当前血量 */
            hp: number;
            /** 血量上限 */
            hp_limit: number;
        };
    };
    61034: {
        desc: "特定怪物血量";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            object_list: {
                /** 怪物唯一id */
                auto_id: number;
                /** 怪物配置id */
                mon_type_id: number;
                /** 当前血量 */
                hp: number;
                /** 血量上限 */
                hp_limit: number;
            }[];
        };
    };
    61035: {
        desc: "波数信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            dun_id: number;
            wave_list: {
                /** 当前波数类型 */
                wave_type: number;
                /**  参数列表 */
                wave_type_args: string;
                /** 当前子波数类型 */
                wave_subtype: number;
                /** 当前循环次数 */
                cycle_num: number;
                /** 最大循环次数 */
                max_cycle_num: number;
                /** 下一波刷新时间 */
                next_wave_time: number;
            }[];
        };
    };
    61036: {
        desc: "怪物积分";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            score: number;
        };
    };
    61037: {
        desc: "副本摘要信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            total_list: {
                /** 副本类型 */
                dun_type: number;
                /** 是否还有次数 */
                available: number;
                /** 剩余次数 */
                left_count: number;
                /** 最大次数 */
                max_count: number;
            }[];
        };
    };
    61038: {
        desc: "副本摘要信息更新";
        send: (number: 61038, fmt: "c", args: [dun_type: number]) => never;
        sendFmt: "c";
        sendArgs: [dun_type: number];
        recv: {
            /** 副本类型 */
            dun_type: number;
            /** 是否还有次数 */
            available: number;
            /** 剩余次数 */
            left_count: number;
            /** 最大次数 */
            max_count: number;
        };
    };
    61039: {
        desc: "进入下一副本";
        send: (
            number: 61039,
            fmt: "i",
            args: [
                /**当前副本id*/
                prev_id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**当前副本id*/
            prev_id: number
        ];
        recv: null;
    };
    61040: {
        desc: "怪物逃走数量";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            num: number;
        };
    };
    61041: {
        desc: "副本累计获得经验";
        send: (number: 61041, fmt: "i", args: [dun_id: number]) => never;
        sendFmt: "i";
        sendArgs: [dun_id: number];
        recv: {
            dun_id: number;
            exp: number;
        };
    };
    61042: {
        desc: "获得额外的奖励领取列表";
        send: (
            number: 61042,
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
    61043: {
        desc: "领取额外的奖励";
        send: (
            number: 61043,
            fmt: "ic",
            args: [
                /**副本id*/
                dun_id: number,
                /**奖励类型*/
                reward_type: number
            ]
        ) => never;
        sendFmt: "ic";
        sendArgs: [
            /**副本id*/
            dun_id: number,
            /**奖励类型*/
            reward_type: number
        ];
        recv: {
            /** 错误码 */
            error_code: number;
            /** 副本id */
            dun_id: number;
            /** 奖励类型 */
            reward_type: number;
            reward_list: any;
        };
    };
    61044: {
        desc: "副本面板信息经验副本左侧面板";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 击杀数量 */
            kill_num: number;
            /** 经验 */
            exp: number;
        };
    };
    61045: {
        desc: "副本冷却时间";
        send: (
            number: 61045,
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
        recv: {
            /** 副本id */
            dun_id: number;
            /** 下次进入时间 */
            next_time: number;
        };
    };
    61046: {
        desc: "邀请进入副本";
        send: (
            number: 61046,
            fmt: "cil",
            args: [
                /**1 开始邀请 2 取消*/
                type: number,
                /**副本id*/
                dun_id: number,
                /**玩家id*/
                other_id: number
            ]
        ) => never;
        sendFmt: "cil";
        sendArgs: [
            /**1 开始邀请 2 取消*/
            type: number,
            /**副本id*/
            dun_id: number,
            /**玩家id*/
            other_id: number
        ];
        recv: {
            /**  错误码内容 */
            code_msg: string;
        };
    };
    61047: {
        desc: "回应邀请进入副本";
        send: (
            number: 61047,
            fmt: "ilc",
            args: [
                /**副本id*/
                dun_id: number,
                /**邀请者id*/
                inviter: number,
                /**1 同意 2 拒绝*/
                answer: number
            ]
        ) => never;
        sendFmt: "ilc";
        sendArgs: [
            /**副本id*/
            dun_id: number,
            /**邀请者id*/
            inviter: number,
            /**1 同意 2 拒绝*/
            answer: number
        ];
        recv: {
            /** 错误码 */
            code: number;
            /** 1 同意 2 拒绝 */
            answer: number;
        };
    };
    61048: {
        desc: "邀请进入副本界面信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 1 成功发出邀请 2 邀请方取消邀请 3 对方拒绝 4 被邀请方不能进入副本 */
            code: number;
            list: {
                /** 1 邀请方，2 被邀请方 */
                type: number;
                /** 玩家id */
                role_id: number;
                /** 玩家名字 */
                name: string;
                /** 性别 */
                sex: number;
                /** 阵营 */
                realm: number;
                /** 职业 */
                career: number;
                /** 等级 */
                level: number;
                /** 是否GM */
                GM: number;
                /** VIP */
                vip_flag: number;
                /** 职称 */
                touxian: number;
                /** 等级模型 */
                level_model_list: {
                    /** 部位 */
                    part_pos: number;
                    /** 模型id */
                    level_model_id: number;
                }[];
                /** 时装模型 */
                fashion_model_list: {
                    /** 部位 */
                    part_pos: number;
                    /** 模型id */
                    fashion_model_id: number;
                    figure_chartlet_id: number;
                }[];
                /** 自定义头像url */
                picture: string;
                /** 自定义头像版本号 */
                prcture_ver: number;
                /** 帮派id */
                guild_id: number;
                /** 帮派名字 */
                guild_name: string;
                /** 帮派职位 */
                position: number;
                /** 帮派职位名字 */
                position_name: string;
                /** 称号 */
                dsgt_id: number;
                /** 活跃度形象Id */
                image_id: number;
                /** 转生次数 */
                turn: number;
                /** 转生阶段 */
                turn_stage: number;
                /** 爵位等级 */
                grade_id: number;
                /** 结婚状态 0单身 1情侣 2结婚 */
                is_marriage: number;
                /** 伴侣玩家id */
                marriage_id: number;
                /** 伴侣玩家name */
                marriage_name: string;
                /** 护送天使id */
                escort_state: number;
                /** 房子街区id */
                block_id: number;
                /** 房子id */
                house_id: number;
                /** 房子等级 */
                house_lv: number;
                /** 幻化模型 */
                figure_list: {
                    /** 类型 （1:坐骑 2：伙伴 3: 翅膀 4:神器 5：圣器 6：精灵 7：宠物） */
                    figure_type: number;
                    /** 模型id */
                    figure_id: number;
                    figure_chartlet_id: number;
                }[];
                /** 幻化模型是否骑乘##找不到数据就默认骑乘 */
                figure_ride_list: {
                    /** 类型 （1:坐骑 2：伙伴 3: 翅膀 4:神器 5：圣器 6：精灵 7：宠物） */
                    figure_type: number;
                    /** 是否骑乘(用于场景表现,点击头像等等忽略本字段) */
                    is_ride: number;
                }[];
                /** 成就等级 */
                achv_lv: number;
                /** 勋章id */
                medal_id: number;
                /** 法阵id */
                fazhen_id: number;
                /** 装扮列表 */
                dress_list: {
                    /** 装扮类型 */
                    dress_type: number;
                    /** 装扮id */
                    dress_id: number;
                }[];
                /** 将神id */
                god_id: number;
                /** 天启套装 */
                revelation_suit: number;
                /** 使魔id */
                demon_id: number;
                /** 是否有至尊vip标识 */
                supreme_vip: number;
                /** 头衔id */
                title_id: number;
                /** 蒙面id */
                mask_id: number;
                /** 阵营四海争霸(玩家阵营) */
                seaCamp: number;
                /** 海战日常砖块品质 */
                brick_id: number;
                /** 假人类型（0:玩家） */
                dummy_type: number;
                /** 套装贴图id */
                suit_fashion_id: number;
                /** 采集状态 （0：非采集， 1：采集中） */
                collect_state: number;
            }[];
            dun_id: number;
        };
    };
    61049: {
        desc: "追加奖励";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 副本id */
            dun_id: number;
            /** 额外奖励 */
            other_reward: {
                /** 奖励类型  1:多倍奖励 */
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
        };
    };
    61050: {
        desc: "龙纹副本最佳记录";
        send: (
            number: 61050,
            fmt: "ic",
            args: [
                /**副本id*/
                dun_id: number,
                /**波数*/
                wave: number
            ]
        ) => never;
        sendFmt: "ic";
        sendArgs: [
            /**副本id*/
            dun_id: number,
            /**波数*/
            wave: number
        ];
        recv: {
            /** 副本id */
            dun_id: number;
            /** 波数 */
            wave: number;
            /** 我的通关记录 */
            my_time: number;
            /** 最快通关记录 */
            best_time: number;
            role_list: {
                /** 玩家id */
                role_id: number;
                /** 玩家名字 */
                name: string;
                /** 战力 */
                power: number;
                server_num: number;
                server_id: number;
            }[];
        };
    };
    61051: {
        desc: "龙纹副本成就奖励";
        send: (
            number: 61051,
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
        recv: {
            /** 副本id */
            dun_id: number;
            /** 最高波数 */
            wave: number;
            /** 已领取波数 */
            record_list: {
                /** 波数 */
                wave: number;
            }[];
        };
    };
    61052: {
        desc: "快速出怪";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            error_code: number;
        };
    };
    61053: {
        desc: "快速出怪信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 加速次数 */
            quick_count: number;
            /** 总加速次数 */
            sum_quick_count: number;
            /** 下次加速的时间戳 */
            next_quick_time: number;
        };
    };
    61054: {
        desc: "领取成就";
        send: (
            number: 61054,
            fmt: "ic",
            args: [
                /**副本id*/
                dun_id: number,
                /**波数*/
                wave: number
            ]
        ) => never;
        sendFmt: "ic";
        sendArgs: [
            /**副本id*/
            dun_id: number,
            /**波数*/
            wave: number
        ];
        recv: {
            /** 成功就读配置奖励 */
            code: number;
            /** 副本id */
            dun_id: number;
            /** 波数 */
            wave: number;
        };
    };
    61055: {
        desc: "查看副本技能数量";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            skill_list: {
                /** 技能id */
                skill_id: number;
                /** 数量 */
                num: number;
            }[];
        };
    };
    61056: {
        desc: "释放buff技能";
        send: (
            number: 61056,
            fmt: "i",
            args: [
                /**技能Id*/
                skill_id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**技能Id*/
            skill_id: number
        ];
        recv: {
            /** 结果码 */
            code: number;
        };
    };
    61057: {
        desc: "波数数据(龙纹副本)";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 副本id */
            dun_id: number;
            /** 结束时间 */
            end_time: number;
            /** 战斗的波数 */
            battle_wave: number;
            /** 当前的波数 */
            cur_wave: number;
            /** 历史最高波数 */
            history_wave: number;
        };
    };
    61058: {
        desc: "龙纹本跳关奖励";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 跳过的关卡 */
            wave: number;
            reward_list: any;
        };
    };
    61059: {
        desc: "波数副本面板高级经验副本";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 波数 */
            wave: number;
            /** 波数开始时间 */
            wave_start_time: number;
            /** 波数结束时间 */
            wave_end_time: number;
            /** 历史最大波数 */
            history_wave: number;
            /** 当前经验 */
            exp: number;
        };
    };
    61060: {
        desc: "波数副本结束高级经验副本";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 波数 */
            wave: number;
            /** 历史最大波数 */
            history_wave: number;
            /** 当前经验 */
            exp: number;
        };
    };
    61061: {
        desc: "波数跳关(进入通知)高级经验副本";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 波数 */
            wave: number;
            /** 历史最大波数 */
            history_wave: number;
            /** 当前经验 */
            exp: number;
        };
    };
    61062: {
        desc: "开关设置信息注意:有一些副本是根据副本类型设置的,但是客户端也会存副本id.服务端和客户端自己转化";
        send: (
            number: 61062,
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
        recv: {
            /** 副本id */
            dun_id: number;
            setting_list: {
                /** 开关类型 */
                type: number;
                /** 选择 */
                select_type: number;
                /** 是否开启 */
                is_open: number;
                /** 次数 */
                count: number;
            }[];
        };
    };
    61063: {
        desc: "开关设置注意:有一些副本是根据副本类型设置的,但是客户端也会存副本id.服务端和客户端自己转化";
        send: (
            number: 61063,
            fmt: "icccc",
            args: [
                /**副本id*/
                dun_id: number,
                /**开关类型*/
                type: number,
                /**选择类型*/
                select_type: number,
                /**是否开启*/
                is_open: number,
                /**次数*/
                count: number
            ]
        ) => never;
        sendFmt: "icccc";
        sendArgs: [
            /**副本id*/
            dun_id: number,
            /**开关类型*/
            type: number,
            /**选择类型*/
            select_type: number,
            /**是否开启*/
            is_open: number,
            /**次数*/
            count: number
        ];
        recv: {
            /** 错误码 */
            errcode: number;
            /** 副本id */
            dun_id: number;
            /** 开关类型 */
            type: number;
            /** 选择 */
            select_type: number;
            /** 是否开启 */
            is_open: number;
            /** 次数 */
            count: number;
        };
    };
    61064: {
        desc: "副本复位客户端请求，回到出生点";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: null;
    };
    61065: {
        desc: "鼓舞状态数据首次进入推送";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 铜币鼓舞次数 */
            coin_count: number;
            /** 元宝鼓舞次数 */
            gold_count: number;
        };
    };
    61066: {
        desc: "怪物剩余数量";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 波数 */
            wave_num: number;
            /** 怪物死亡数量 */
            dead_mon_num: number;
            /** 总怪物数量 */
            mon_num: number;
        };
    };
    61088: {
        desc: "副本独自的特殊信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            dun_id: number;
            dun_type: number;
            /** 1 获取全部信息 2 更新部分信息 */
            push_type: number;
            content: string;
        };
    };
    61089: {
        desc: "题目信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            dun_id: number;
            question_id: number;
            /** 1开始答题 2 结束答题 */
            type: number;
            /** 答题结束时间 */
            end_time: number;
        };
    };
    61090: {
        desc: "提交答案";
        send: (number: 61090, fmt: "s", args: [answer: string]) => never;
        sendFmt: "s";
        sendArgs: [answer: string];
        recv: {
            /** 1 提交答案成功 2 双方答题一致 3 双方答题不一致 */
            ret: number;
        };
    };
    61091: {
        desc: "抢夺扣血";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            error_code: number;
        };
    };
    61092: {
        desc: "异兽入侵领取阶段奖励";
        send: (
            number: 61092,
            fmt: "ci",
            args: [
                /**副本类型*/
                dun_type: number,
                /**副本id*/
                dun_id: number
            ]
        ) => never;
        sendFmt: "ci";
        sendArgs: [
            /**副本类型*/
            dun_type: number,
            /**副本id*/
            dun_id: number
        ];
        recv: {
            /** 副本id */
            dun_id: number;
            /** 返回码 */
            error_code: number;
            /** 守护值奖励状态 0：为完成 1：已完成未领取 2：已领取 */
            reward_status: number;
            reward_list: any;
        };
    };
    61093: {
        desc: "异兽入侵界面协议";
        send: (
            number: 61093,
            fmt: "ci",
            args: [
                /**副本类型*/
                dun_type: number,
                /**副本id*/
                dun_id: number
            ]
        ) => never;
        sendFmt: "ci";
        sendArgs: [
            /**副本类型*/
            dun_type: number,
            /**副本id*/
            dun_id: number
        ];
        recv: {
            /** 副本类型 */
            dun_type: number;
            /** 副本id */
            dun_id: number;
            /** 守护值 */
            d_value: number;
            /** 下次复活时间戳 */
            next_born_time: number;
            /** 已消耗次数 */
            enter_times: number;
            /** 活动结束时间 */
            end_time: number;
            /** 守护值奖励状态 0：为完成 1：已完成未领取 2：已领取 */
            reward_status: number;
        };
    };
    61094: {
        desc: "觉醒副本怪物减速结束时间";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 减速结束时间 */
            end_time: number;
        };
    };
    61095: {
        desc: "觉醒副本怪物减速";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 减速结束时间 */
            end_time: number;
        };
    };
    61096: {
        desc: "诛邪战场日常奖励信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 结果(错误码) */
            res: number;
        };
    };
    61097: {
        desc: "诛邪战场日常奖励信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 领取状态 0未达成 1 可领取 2 已领取 */
            state: number;
            reward_list: any;
        };
    };
    61098: {
        desc: "情缘副本怪物性别注，该请求除了客户端请求，我还会主动发送更新，也可能会新增怪物，取决于怪物出生的时机";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            sex_list: {
                /** 怪物唯一id */
                mid: number;
                /** 怪物类型id */
                mtid: number;
                /** 性别 */
                sex: number;
            }[];
        };
    };
    61099: {
        desc: "守卫公会结算界面";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 结果 参考61003 */
            result: number;
            /** 结果子类型 参考61003 */
            result_subtype: number;
            /** 副本id */
            dun_id: number;
            /** 星级评价 */
            grade: number;
            /** 场景id */
            scene_id: number;
            reward_list: any;
            ex_reward_list: any;
            /** 魔法塔剩余数 */
            tower_num: number;
        };
    };
}

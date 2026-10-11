/** 其他系列活动(延伸活动)
 */
declare interface ProtoFmtInfo {
    33201: {
        desc: "神兵租借神兵租借界面信息";
        send: (
            number: 33201,
            fmt: "hh",
            args: [
                /**活动类型*/
                type: number,
                /**活动子类*/
                subtype: number
            ]
        ) => never;
        sendFmt: "hh";
        sendArgs: [
            /**活动类型*/
            type: number,
            /**活动子类*/
            subtype: number
        ];
        recv: {
            error_code: number;
            /** 活动类型 */
            type: number;
            /** 活动子类 */
            subtype: number;
            /** 当天租借次数 */
            hire_times: number;
            /** 累积租借次数 */
            acc_hire_times: number;
            /** 租借过期时间戳 */
            time: number;
            /** 0 未达到永久租借次数 1 已达永久租借次数 */
            hire_state: number;
        };
    };
    33202: {
        desc: "神兵租借";
        send: (
            number: 33202,
            fmt: "hh",
            args: [
                /**活动类型*/
                type: number,
                /**活动子类*/
                subtype: number
            ]
        ) => never;
        sendFmt: "hh";
        sendArgs: [
            /**活动类型*/
            type: number,
            /**活动子类*/
            subtype: number
        ];
        recv: {
            error_code: number;
        };
    };
    33203: {
        desc: "跨服消费排行榜";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 我的排名 */
            my_rank: number;
            /** 消费 */
            cost: number;
            rank_list: {
                server_id: number;
                server_num: number;
                role_id: number;
                /** 玩家名称 */
                role_name: string;
                /** 排名 */
                rank: number;
                /** 消费 */
                cost: number;
            }[];
        };
    };
    33204: {
        desc: "跨服消费排行榜奖励列表";
        send: (
            number: 33204,
            fmt: "h",
            args: [
                /**活动子类型*/
                subtype: number
            ]
        ) => never;
        sendFmt: "h";
        sendArgs: [
            /**活动子类型*/
            subtype: number
        ];
        recv: {
            /** 活动子类型 */
            subtype: number;
            rank_list: {
                /** 档次 */
                grade_id: number;
                /** 最低消费钻石 */
                limit_cost: number;
                /** 最低排名 */
                min_rank: number;
                /** 最高排名 */
                max_rank: number;
                /** 奖励 */
                reward: any;
            }[];
        };
    };
    33205: {
        desc: "惊喜(幸运)扭蛋扭蛋界面信息";
        send: (
            number: 33205,
            fmt: "hh",
            args: [
                base_type: number,
                /**活动子类型*/
                sub_type: number
            ]
        ) => never;
        sendFmt: "hh";
        sendArgs: [
            base_type: number,
            /**活动子类型*/
            sub_type: number
        ];
        recv: {
            base_type: number;
            /** 活动子类型 */
            sub_type: number;
            /** 剩余免费次数 */
            free_times: number;
            /** 已使用总次数 */
            total_times_use: number;
            /** 累计奖励领取情况 */
            cumulate_reward: {
                /** 奖励id */
                grade_id: number;
                /** 奖励需要次数 */
                times: number;
                /** 奖励 */
                reward: any;
                /** 0: 未达成 1: 已达成未领取 2: 已领取 */
                status: number;
            }[];
            reward_list: {
                /** 奖励档次 */
                grade: number;
                /** 奖励格式类型 见后台备注 */
                form_type: number;
                /** 领取状态 0:未达到 1:可以领取 2:已经领取 3:奖励超时 */
                status: number;
                /** 已领取次数 */
                receive_times: number;
                /**  奖励名字 */
                name: string;
                /**  奖励描述 */
                desc: string;
                /**  领取条件 */
                condition: string;
                /**  奖励 具体参考后台配置的格式 */
                reward: string;
            }[];
        };
    };
    33206: {
        desc: "扭蛋";
        send: (
            number: 33206,
            fmt: "hhcc",
            args: [
                /**活动主类型*/
                base_type: number,
                /**活动子类型*/
                sub_type: number,
                /**1 一次 10 十次*/
                index: number,
                /**是否自动购买 0:不自动 1:自动*/
                auto_buy: number
            ]
        ) => never;
        sendFmt: "hhcc";
        sendArgs: [
            /**活动主类型*/
            base_type: number,
            /**活动子类型*/
            sub_type: number,
            /**1 一次 10 十次*/
            index: number,
            /**是否自动购买 0:不自动 1:自动*/
            auto_buy: number
        ];
        recv: {
            /** 返回码 */
            error_code: number;
            /** 活动主类型 */
            base_type: number;
            /** 活动子类型 */
            sub_type: number;
            /** 剩余免费次数 */
            free_times: number;
            /** 已使用总次数 */
            total_times_use: number;
            /** 当前幸运值 */
            show_luckey_val: number;
            list: {
                grade_id: number;
                /** 奖励 */
                reward: any;
            }[];
        };
    };
    33207: {
        desc: "累积奖励领取";
        send: (
            number: 33207,
            fmt: "hhh",
            args: [
                /**活动主类型*/
                base_type: number,
                /**活动子类型*/
                sub_type: number,
                /**奖励id*/
                grade_id: number
            ]
        ) => never;
        sendFmt: "hhh";
        sendArgs: [
            /**活动主类型*/
            base_type: number,
            /**活动子类型*/
            sub_type: number,
            /**奖励id*/
            grade_id: number
        ];
        recv: {
            /** 返回码 */
            error_code: number;
            /** 活动主类型 */
            base_type: number;
            /** 活动子类型 */
            sub_type: number;
            /** 奖励id */
            grade_id: number;
            /** 奖励 */
            reward: any;
        };
    };
    33208: {
        desc: "惊喜扭蛋的当前幸运值(每次打开界面都请求)";
        send: (
            number: 33208,
            fmt: "hh",
            args: [
                /**活动主类型*/
                base_type: number,
                /**活动子类型*/
                sub_type: number
            ]
        ) => never;
        sendFmt: "hh";
        sendArgs: [
            /**活动主类型*/
            base_type: number,
            /**活动子类型*/
            sub_type: number
        ];
        recv: {
            /** 活动主类型 */
            base_type: number;
            /** 活动子类型 */
            sub_type: number;
            /** 当前幸运值 */
            show_luckey_val: number;
        };
    };
    33209: {
        desc: "每日补给获取活跃度";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 今日增加的活跃度 */
            liveness: number;
        };
    };
    33211: {
        desc: "节日投资：投资列表";
        send: (
            number: 33211,
            fmt: "hh",
            args: [
                /**活动大类*/
                base_type: number,
                /**活动子类*/
                sub_type: number
            ]
        ) => never;
        sendFmt: "hh";
        sendArgs: [
            /**活动大类*/
            base_type: number,
            /**活动子类*/
            sub_type: number
        ];
        recv: {
            /** 活动大类 */
            base_type: number;
            /** 活动子类 */
            sub_type: number;
            investments: {
                /** 购买档次 */
                lv: number;
            }[];
        };
    };
    33212: {
        desc: "节日投资：购买";
        send: (
            number: 33212,
            fmt: "hhc",
            args: [
                base_type: number,
                sub_type: number,
                /**档次*/
                lv: number
            ]
        ) => never;
        sendFmt: "hhc";
        sendArgs: [
            base_type: number,
            sub_type: number,
            /**档次*/
            lv: number
        ];
        recv: {
            error_code: number;
            base_type: number;
            sub_type: number;
            /** 档次 */
            lv: number;
            login_days: number;
            reward_list: any;
        };
    };
    33213: {
        desc: "幸运抽奖界面协议";
        send: (
            number: 33213,
            fmt: "hh",
            args: [base_type: number, sub_type: number]
        ) => never;
        sendFmt: "hh";
        sendArgs: [base_type: number, sub_type: number];
        recv: {
            base_type: number;
            sub_type: number;
            pool: any;
            error_code: number;
        };
    };
    33214: {
        desc: "幸运抽奖抽奖";
        send: (
            number: 33214,
            fmt: "hhhc",
            args: [
                base_type: number,
                sub_type: number,
                /**1 10次*/
                times: number,
                /**是否自动购买 0:不自动 1:自动*/
                auto_buy: number
            ]
        ) => never;
        sendFmt: "hhhc";
        sendArgs: [
            base_type: number,
            sub_type: number,
            /**1 10次*/
            times: number,
            /**是否自动购买 0:不自动 1:自动*/
            auto_buy: number
        ];
        recv: {
            base_type: number;
            sub_type: number;
            error_code: number;
            reward: {
                grade: number;
                reward_list: any;
                /** 稀有度 0 1 2 */
                rare: number;
            }[];
        };
    };
    33215: {
        desc: "vip特惠礼包：设置折扣";
        send: (
            number: 33215,
            fmt: "hhh",
            args: [
                base_type: number,
                sub_type: number,
                /**档次*/
                grade: number
            ]
        ) => never;
        sendFmt: "hhh";
        sendArgs: [
            base_type: number,
            sub_type: number,
            /**档次*/
            grade: number
        ];
        recv: {
            error_code: number;
            base_type: number;
            sub_type: number;
            /** 档次 */
            grade: number;
            now_cost: any;
        };
    };
    33216: {
        desc: "封测充值返还";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 累积充值钻石 */
            gold: number;
            /** 返还钻石 */
            return_gold: number;
            /** 登陆天数 */
            login_days: number;
        };
    };
    33217: {
        desc: "等级抽奖信息";
        send: (
            number: 33217,
            fmt: "hh",
            args: [base_type: number, sub_type: number]
        ) => never;
        sendFmt: "hh";
        sendArgs: [base_type: number, sub_type: number];
        recv: {
            error_code: number;
            base_type: number;
            sub_type: number;
            /** 抽奖时间戳 */
            draw_time: number;
            /** 0 没有得奖 1 得奖 2 没资格 */
            is_winner: number;
            winner_list: {
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
        };
    };
    33218: {
        desc: "活跃转盘界面";
        send: (
            number: 33218,
            fmt: "hh",
            args: [base_type: number, sub_type: number]
        ) => never;
        sendFmt: "hh";
        sendArgs: [base_type: number, sub_type: number];
        recv: {
            base_type: number;
            sub_type: number;
            /** 活跃度 */
            activation: number;
            activation_state: {
                /** 当前只有150活跃度需求 id 默认为1 */
                id: number;
                /** 0未领取 1已达成未领取 2已领取 */
                status: number;
            }[];
            /** 个人记录 */
            self_log: {
                name: string;
                reward_list: any;
            }[];
        };
    };
    33219: {
        desc: "活跃转盘领取活跃度奖励";
        send: (
            number: 33219,
            fmt: "hhh",
            args: [
                base_type: number,
                sub_type: number,
                /**当前只有150活跃度需求 id 默认为1*/
                id: number
            ]
        ) => never;
        sendFmt: "hhh";
        sendArgs: [
            base_type: number,
            sub_type: number,
            /**当前只有150活跃度需求 id 默认为1*/
            id: number
        ];
        recv: {
            base_type: number;
            sub_type: number;
            activation_state: {
                /** 当前只有150活跃度需求 id 默认为1 */
                id: number;
                /** 0未领取 1已达成未领取 2已领取 */
                status: number;
            }[];
            error_code: number;
            reward_list: any;
        };
    };
    33220: {
        desc: "活跃转盘抽奖";
        send: (
            number: 33220,
            fmt: "hhh",
            args: [base_type: number, sub_type: number, times: number]
        ) => never;
        sendFmt: "hhh";
        sendArgs: [base_type: number, sub_type: number, times: number];
        recv: {
            base_type: number;
            sub_type: number;
            error_code: number;
            lists: {
                grade: number;
                reward_list: any;
                /** 稀有度 0 1 2 3 */
                rare: number;
            }[];
        };
    };
    33221: {
        desc: "神圣召唤界面协议";
        send: (
            number: 33221,
            fmt: "hh",
            args: [
                /**活动主类型*/
                base_type: number,
                /**活动子类型*/
                sub_type: number
            ]
        ) => never;
        sendFmt: "hh";
        sendArgs: [
            /**活动主类型*/
            base_type: number,
            /**活动子类型*/
            sub_type: number
        ];
        recv: {
            /** 活动主类型 */
            base_type: number;
            /** 活动子类型 */
            sub_type: number;
            /** 返回码 1表示成功，其他表示出错 */
            error_code: number;
            /** 抽奖总次数 */
            all_times: number;
            /** 免费次数 */
            free_times: number;
            /** 显示在树上的列表 */
            show_list: {
                /** 奖励id */
                grade_id: number;
                /** 是否大奖 1: 是 0: 否 */
                is_rare: number;
                reward: any;
            }[];
            /** 累计次数奖励 */
            cumulate_reward: {
                /** 奖励id */
                grade_id: number;
                /** 奖励需要次数 */
                times: number;
                reward: any;
                /** 0: 未达成 1: 已达成未领取 2: 已领取 */
                status: number;
            }[];
            rare_pool: {
                /** 奖励id */
                grade_id: number;
                /** 是否大奖 1: 是 0: 否 */
                is_rare: number;
                reward: any;
            }[];
            rare_draw_times: number;
        };
    };
    33222: {
        desc: "神圣召唤稀有奖池抽奖";
        send: (
            number: 33222,
            fmt: "hh",
            args: [
                /**活动主类型*/
                base_type: number,
                /**活动子类型*/
                sub_type: number
            ]
        ) => never;
        sendFmt: "hh";
        sendArgs: [
            /**活动主类型*/
            base_type: number,
            /**活动子类型*/
            sub_type: number
        ];
        recv: {
            /** 返回码 1表示成功，其他表示出错 */
            error_code: number;
            /** 活动主类型 */
            base_type: number;
            /** 活动子类型 */
            sub_type: number;
            /** 剩余珍稀抽奖次数 */
            rare_draw_times: number;
            reward_list: {
                /** 奖励id */
                grade_id: number;
                /** 是否大奖 1: 是 0: 否 */
                is_rare: number;
                reward: any;
            }[];
        };
    };
    33223: {
        desc: "活动首杀";
        send: (
            number: 33223,
            fmt: "hh",
            args: [
                /**活动主类型*/
                base_type: number,
                /**活动子类型*/
                sub_type: number
            ]
        ) => never;
        sendFmt: "hh";
        sendArgs: [
            /**活动主类型*/
            base_type: number,
            /**活动子类型*/
            sub_type: number
        ];
        recv: {
            code: number;
            /** 0 未击杀  1 已经被击杀 */
            status: number;
            /** 玩家id */
            role_id: number;
            /**   玩家名字 */
            role_name: string;
        };
    };
    33224: {
        desc: "招财猫活动数据";
        send: (
            number: 33224,
            fmt: "hhc",
            args: [
                /**活动主类型*/
                base_type: number,
                /**活动子类型*/
                sub_type: number,
                /**是否需要发送下一轮数据 1 是 0 否*/
                is_next: number
            ]
        ) => never;
        sendFmt: "hhc";
        sendArgs: [
            /**活动主类型*/
            base_type: number,
            /**活动子类型*/
            sub_type: number,
            /**是否需要发送下一轮数据 1 是 0 否*/
            is_next: number
        ];
        recv: {
            /** 活动主类型 */
            base_type: number;
            /** 活动子类型 */
            sub_type: number;
            /** 当前抽奖轮数 */
            turns: number;
            /** 抽奖需要的物品id */
            cgoods_id: number;
            /** 抽奖需要的物品数量 */
            cgoods_num: number;
            /** 所有轮次奖励区间列表 */
            rounds_list: {
                /** 轮次 */
                rounds: number;
                /** 最大奖励 */
                max_num: number;
                /** 最低奖励 */
                min_num: number;
                /** 奖励ID */
                reward_id: number;
            }[];
            reward_list: {
                /** 档次 */
                grade_id: number;
                /** 物品id */
                goods_id: number;
                /** 物品数量 */
                goods_num: number;
                /** 是否头奖 0 否， 1 是 */
                is_head: number;
            }[];
        };
    };
    33225: {
        desc: "招财猫抽奖";
        send: (
            number: 33225,
            fmt: "hh",
            args: [
                /**活动主类型*/
                base_type: number,
                /**活动子类型*/
                sub_type: number
            ]
        ) => never;
        sendFmt: "hh";
        sendArgs: [
            /**活动主类型*/
            base_type: number,
            /**活动子类型*/
            sub_type: number
        ];
        recv: {
            /** 返回码 */
            error_code: number;
            /** 活动主类型 */
            base_type: number;
            /** 活动子类型 */
            sub_type: number;
            /** 档次 */
            grade_id: number;
            /** 中奖的物品id  物品id和数量联合代表中奖奖项 */
            goods_id: number;
            /** 物品数量      物品id和数量联合代表中奖奖项 */
            goods_num: number;
        };
    };
    33226: {
        desc: "招财猫抽奖记录";
        send: (
            number: 33226,
            fmt: "hh",
            args: [
                /**活动主类型*/
                base_type: number,
                /**活动子类型*/
                sub_type: number
            ]
        ) => never;
        sendFmt: "hh";
        sendArgs: [
            /**活动主类型*/
            base_type: number,
            /**活动子类型*/
            sub_type: number
        ];
        recv: {
            /** 活动主类型 */
            base_type: number;
            /** 活动子类型 */
            sub_type: number;
            /** 个人记录 */
            self_list: {
                role_id: number;
                role_name: string;
                goods_id: number;
                goods_num: number;
            }[];
            /** 全服记录 */
            golb_list: {
                role_id: number;
                role_name: string;
                goods_id: number;
                goods_num: number;
            }[];
        };
    };
    33227: {
        desc: "跨服团购活动信息";
        send: (
            number: 33227,
            fmt: "hh",
            args: [
                /**活动主类型*/
                base_type: number,
                /**活动子类型*/
                sub_type: number
            ]
        ) => never;
        sendFmt: "hh";
        sendArgs: [
            /**活动主类型*/
            base_type: number,
            /**活动子类型*/
            sub_type: number
        ];
        recv: {
            /** 活动主类型 */
            base_type: number;
            /** 活动子类型 */
            sub_type: number;
            gp_goods: {
                /** 商品id */
                grade_id: number;
                first_buy_count: number;
                tail_buy_count: number;
                /** 购买人数 */
                buy_num: number;
            }[];
        };
    };
    33228: {
        desc: "跨服团购购买记录";
        send: (
            number: 33228,
            fmt: "hh",
            args: [
                /**活动主类型*/
                base_type: number,
                /**活动子类型*/
                sub_type: number
            ]
        ) => never;
        sendFmt: "hh";
        sendArgs: [
            /**活动主类型*/
            base_type: number,
            /**活动子类型*/
            sub_type: number
        ];
        recv: {
            /** 活动主类型 */
            base_type: number;
            /** 活动子类型 */
            sub_type: number;
            record_list: {
                role_id: number;
                role_name: string;
                server_id: number;
                server_num: number;
                grade_id: number;
                first_buy: {
                    /** 时间间隔，购买时间=first_buy_time+gap_time */
                    gap_time: number;
                }[];
                first_buy_time: number;
                tail_buy: {
                    /** 时间间隔，购买时间=tail_buy_time+gap_time */
                    gap_time: number;
                }[];
                tail_buy_time: number;
            }[];
        };
    };
    33229: {
        desc: "跨服团购购买";
        send: (
            number: 33229,
            fmt: "hhhc",
            args: [
                /**活动主类型*/
                base_type: number,
                /**活动子类型*/
                sub_type: number,
                grade_id: number,
                /**1 订金 2 尾款*/
                purchase_type: number
            ]
        ) => never;
        sendFmt: "hhhc";
        sendArgs: [
            /**活动主类型*/
            base_type: number,
            /**活动子类型*/
            sub_type: number,
            grade_id: number,
            /**1 订金 2 尾款*/
            purchase_type: number
        ];
        recv: {
            error_code: number;
            /** 活动主类型 */
            base_type: number;
            /** 活动子类型 */
            sub_type: number;
            grade_id: number;
            /** 1 订金 2 尾款 */
            purchase_type: number;
            /** 如果是订金：自己购买的总次数；如果是尾款：付尾款的总次数 */
            buy_count: number;
            /** 购买总人数 */
            buy_num: number;
            reward_list: any;
        };
    };
    33230: {
        desc: "跨服团购商品购买数量广播";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 活动主类型 */
            base_type: number;
            /** 活动子类型 */
            sub_type: number;
            /** 商品id */
            grade_id: number;
            /** 购买人数 */
            buy_num: number;
        };
    };
    33231: {
        desc: "查看特殊货币数量";
        send: (
            number: 33231,
            fmt: "hh",
            args: [
                /**活动主类型*/
                base_type: number,
                /**活动子类型*/
                sub_type: number
            ]
        ) => never;
        sendFmt: "hh";
        sendArgs: [
            /**活动主类型*/
            base_type: number,
            /**活动子类型*/
            sub_type: number
        ];
        recv: {
            /** 活动主类型 */
            base_type: number;
            /** 活动子类型 */
            sub_type: number;
            /** 特殊货币数量 */
            currency: number;
        };
    };
    33232: {
        desc: "查看契约挑战信息";
        send: (
            number: 33232,
            fmt: "hh",
            args: [
                /**活动主类型*/
                base_type: number,
                /**活动子类型*/
                sub_type: number
            ]
        ) => never;
        sendFmt: "hh";
        sendArgs: [
            /**活动主类型*/
            base_type: number,
            /**活动子类型*/
            sub_type: number
        ];
        recv: {
            /** 活动主类型 */
            base_type: number;
            /** 活动子类型 */
            sub_type: number;
            /** 当前契约总值 */
            sum_point: number;
            /** 是否激活传说契约（0未激活，1已激活） */
            is_legend: number;
            /** 下次刷新每日任务时间 */
            flush_time: number;
            /** 任务列表 */
            task_list: {
                /** 任务唯一id（该id用于领取契约值使用，自增id） */
                item_id: number;
                /** 任务id（有可能重复，配置上的id） */
                task_id: number;
                /** 任务类型 0累计任务，1每日任务 */
                challenge_type: number;
                /**  任务名称 */
                challenge_name: string;
                /**  模块图片 */
                icon_type: string;
                /** 契约点数 */
                point: number;
                /** 所需 累计完成次数累计金额充值或消耗 */
                grand_num: number;
                /** 跳转id */
                jump_id: number;
                /** 实际完成进度 */
                process_num: number;
                /** 任务是否完成可领取（0未领取，1可领取，2已领取） */
                is_get: number;
                /** 当前任务是否开放 */
                is_open: number;
            }[];
        };
    };
    33233: {
        desc: "领取契约点";
        send: (
            number: 33233,
            fmt: "hhh",
            args: [
                /**活动主类型*/
                base_type: number,
                /**活动子类型*/
                sub_type: number,
                /**任务唯一id（该id用于领取契约值使用，自增id）*/
                item_id: number
            ]
        ) => never;
        sendFmt: "hhh";
        sendArgs: [
            /**活动主类型*/
            base_type: number,
            /**活动子类型*/
            sub_type: number,
            /**任务唯一id（该id用于领取契约值使用，自增id）*/
            item_id: number
        ];
        recv: {
            /** 返回码 */
            error_code: number;
            /** 活动主类型 */
            base_type: number;
            /** 活动子类型 */
            sub_type: number;
            /** 任务唯一id（该id用于领取契约值使用，自增id） */
            item_id: number;
            /** 当前契约总值 */
            sum_point: number;
            /** 任务类型 0累计任务，1每日任务 */
            challenge_type: number;
        };
    };
    33234: {
        desc: "主动推送契约状况";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 活动主类型 */
            base_type: number;
            /** 活动子类型 */
            sub_type: number;
            task_list: {
                /** 任务唯一id（该id用于领取契约值使用，自增id） */
                item_id: number;
                /** 任务类型 0累计任务，1每日任务 */
                challenge_type: number;
                /** 实际完成进度 */
                process_num: number;
                /** 任务是否完成可领取（0未领取，1可领取，2已领取） */
                is_get: number;
            }[];
        };
    };
    33235: {
        desc: "传说契约激活";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 活动主类型 */
            base_type: number;
            /** 活动子类型 */
            sub_type: number;
            /** 是否激活传说契约（0未激活，1已激活） */
            is_legend: number;
        };
    };
    33236: {
        desc: "完成问卷调查";
        send: (
            number: 33236,
            fmt: "c",
            args: [
                /**问卷类型*/
                question_type: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**问卷类型*/
            question_type: number
        ];
        recv: {
            /** 错误码 */
            error_code: number;
            /** 问卷类型 */
            question_type: number;
        };
    };
    33237: {
        desc: "传说契约buff";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 玩家id */
            player_id: number;
            buff_list: {
                /** 图标根据物品id去查找 */
                goods_id: number;
                /** buff类型 0 */
                buff_type: number;
                /** 剩余持续时间(秒) */
                time: number;
            }[];
        };
    };
    33238: {
        desc: "获取天命转盘信息";
        send: (
            number: 33238,
            fmt: "hh",
            args: [
                /**活动主类型*/
                base_type: number,
                /**活动子类型*/
                sub_type: number
            ]
        ) => never;
        sendFmt: "hh";
        sendArgs: [
            /**活动主类型*/
            base_type: number,
            /**活动子类型*/
            sub_type: number
        ];
        recv: {
            /** 活动主类型 */
            base_type: number;
            /** 活动子类型 */
            sub_type: number;
            /** 当前第n转 */
            turn: number;
            /** 当前积分 */
            point: number;
            /** 当前抽奖所需积分 */
            need_point: number;
            /** 最大转数，超过这个就不转咯 */
            max_turn: number;
            /** 抽奖情况 */
            reward_list: {
                /** 奖励档次 */
                grade: number;
                /** 奖励格式类型 见后台备注 */
                form_type: number;
                /** 领取状态 0:未抽中 1已抽到（不会重复 */
                status: number;
                /**  奖励名字 */
                name: string;
                /**  奖励描述 */
                desc: string;
                /**  奖励 具体参考后台配置的格式 */
                reward: string;
                /**  领取条件 */
                condition: string;
            }[];
            double_point: {
                /** 跳转id */
                jump_id: number;
                /** 当前跳转id的活动是否已购买 */
                is_buy: number;
            }[];
            /** 标签 */
            label: number;
        };
    };
    33239: {
        desc: "天命转盘积分变动推送";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 活动主类型 */
            base_type: number;
            /** 活动子类型 */
            sub_type: number;
            /** 当前第n转 */
            turn: number;
            /** 当前积分 */
            point: number;
            /** 当前抽奖所需积分 */
            need_point: number;
        };
    };
    33240: {
        desc: "天命转盘抽奖";
        send: (
            number: 33240,
            fmt: "hh",
            args: [
                /**活动主类型*/
                base_type: number,
                /**活动子类型*/
                sub_type: number
            ]
        ) => never;
        sendFmt: "hh";
        sendArgs: [
            /**活动主类型*/
            base_type: number,
            /**活动子类型*/
            sub_type: number
        ];
        recv: {
            /** 错误码 */
            error_code: number;
            /** 活动主类型 */
            base_type: number;
            /** 活动子类型 */
            sub_type: number;
            /** 抽中档次 */
            grade_id: number;
            /**  奖励 具体参考后台配置的格式 */
            reward: string;
            /** 新的一轮 */
            turn: number;
            /** 当前积分 */
            point: number;
            /** 新的一轮抽奖所需积分 */
            need_point: number;
        };
    };
    33241: {
        desc: "幸运寻宝界面33105协议领取";
        send: (
            number: 33241,
            fmt: "hh",
            args: [
                /**活动主类型*/
                base_type: number,
                /**活动子类型*/
                sub_type: number
            ]
        ) => never;
        sendFmt: "hh";
        sendArgs: [
            /**活动主类型*/
            base_type: number,
            /**活动子类型*/
            sub_type: number
        ];
        recv: {
            /** 活动主类型 */
            base_type: number;
            /** 活动子类型 */
            sub_type: number;
            reward_list: {
                /** 奖励档次 */
                grade: number;
                /** 奖励格式类型 见后台备注 */
                form_type: number;
                /** 领取状态 0:未达到 1:可以领取 2:已经领取 3:奖励超时 */
                status: number;
                /** 进度 */
                process: number;
                /** 已领取次数 */
                receive_times: number;
                /**  奖励名字 */
                name: string;
                /**  奖励描述 */
                desc: string;
                /**  领取条件 */
                condition: string;
                /**  奖励 具体参考后台配置的格式 */
                reward: string;
            }[];
        };
    };
    33242: {
        desc: "幸运寻宝领取";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 活动主类型 */
            base_type: number;
            /** 活动子类型 */
            sub_type: number;
            reward_list: {
                /** 奖励档次 */
                grade: number;
                /** 进度 */
                process: number;
            }[];
        };
    };
    33243: {
        desc: "幸运鉴宝界面";
        send: (
            number: 33243,
            fmt: "hh",
            args: [
                /**活动主类型*/
                base_type: number,
                /**活动子类型*/
                sub_type: number
            ]
        ) => never;
        sendFmt: "hh";
        sendArgs: [
            /**活动主类型*/
            base_type: number,
            /**活动子类型*/
            sub_type: number
        ];
        recv: {
            /** 活动主类型 */
            base_type: number;
            /** 活动子类型 */
            sub_type: number;
            /** 抽奖次数 */
            draw_time: number;
            /** 抽奖轮数 */
            turn: number;
            /** 大奖记录 */
            grade_info: {
                /** 大奖档次id */
                grade_id: number;
                /** 抽中次数 */
                count: number;
            }[];
            /** 活动奖励数据 */
            reward_list: {
                /** 奖励档次 */
                grade: number;
                /** 奖励格式类型 见后台备注 */
                form_type: number;
                /**  奖励名字 */
                name: string;
                /**  奖励描述 */
                desc: string;
                /**  领取条件 */
                condition: string;
                /**  奖励 具体参考后台配置的格式 */
                reward: string;
            }[];
        };
    };
    33244: {
        desc: "幸运鉴宝抽奖";
        send: (
            number: 33244,
            fmt: "hhhch",
            args: [
                /**活动主类型*/
                base_type: number,
                /**活动子类型*/
                sub_type: number,
                /**抽奖次数 %%抽奖次数超过1可能会有问题，因为是先扣费再抽奖*/
                times: number,
                /**0否 1自动购买 2单抽自动购买使用*/
                auto_buy: number,
                /**当前抽奖轮数（服务端到了下一轮客户端还发前一轮的轮次，不会抽奖）*/
                turn: number
            ]
        ) => never;
        sendFmt: "hhhch";
        sendArgs: [
            /**活动主类型*/
            base_type: number,
            /**活动子类型*/
            sub_type: number,
            /**抽奖次数 %%抽奖次数超过1可能会有问题，因为是先扣费再抽奖*/
            times: number,
            /**0否 1自动购买 2单抽自动购买使用*/
            auto_buy: number,
            /**当前抽奖轮数（服务端到了下一轮客户端还发前一轮的轮次，不会抽奖）*/
            turn: number
        ];
        recv: {
            /** 活动主类型 */
            base_type: number;
            /** 活动子类型 */
            sub_type: number;
            /** 抽奖次数 */
            times: number;
            /** 0否 1自动购买 */
            auto_buy: number;
            /** 错误码 */
            error_code: number;
            grade_list: {
                /** 抽中奖励档次id */
                grade_id: number;
            }[];
            /** 奖励 */
            reward: any;
            /** 抽奖总次数 */
            draw_time: number;
            /** 抽奖轮数 */
            turn: number;
            grade_info: {
                /** 大奖档次id */
                grade_id: number;
                /** 抽中次数 */
                count: number;
            }[];
        };
    };
    33245: {
        desc: "通用抽奖界面";
        send: (
            number: 33245,
            fmt: "hh",
            args: [
                /**活动主类型*/
                base_type: number,
                /**活动子类型*/
                sub_type: number
            ]
        ) => never;
        sendFmt: "hh";
        sendArgs: [
            /**活动主类型*/
            base_type: number,
            /**活动子类型*/
            sub_type: number
        ];
        recv: {
            /** 活动主类型 */
            base_type: number;
            /** 活动子类型 */
            sub_type: number;
            /** 必中大奖的幸运值 */
            max_luck: number;
            /** 当前幸运值 */
            current_luck: number;
            /** 每次抽奖获取的幸运值 */
            per_luck: number;
            /** 抽奖总次数 */
            total_times: number;
            /**  单抽消耗 */
            one_cost: string;
            /**  十连消耗 */
            ten_cost: string;
            /** 抽奖列表 */
            draw_list: {
                /** 档次 */
                grade_id: number;
                /** 是否大奖 */
                is_nice: number;
                /** 是否已抽中 （是大奖且该活动不放回奖励才有效） */
                is_get1: number;
                /**  奖励 */
                reward: string;
            }[];
            /** 累计次数奖励 */
            grand_list: {
                /** 档次 */
                grade_id: number;
                /** 是否已领取 */
                is_get2: number;
                /** 所需抽奖次数 */
                need_num: number;
                /**  奖励 */
                reward: string;
            }[];
            exchange_list: {
                /** 档次 */
                grade_id: number;
                /** 兑换所需积分 */
                need_point: number;
                /**  奖励 */
                reward: string;
            }[];
        };
    };
    33246: {
        desc: "通用抽奖抽奖";
        send: (
            number: 33246,
            fmt: "hhhcc",
            args: [
                /**活动主类型*/
                base_type: number,
                /**活动子类型*/
                sub_type: number,
                /**抽奖次数 1或10*/
                times: number,
                /**是否自动购买*/
                auto_buy: number,
                /**通透字段，客户端使用*/
                lucency_field: number
            ]
        ) => never;
        sendFmt: "hhhcc";
        sendArgs: [
            /**活动主类型*/
            base_type: number,
            /**活动子类型*/
            sub_type: number,
            /**抽奖次数 1或10*/
            times: number,
            /**是否自动购买*/
            auto_buy: number,
            /**通透字段，客户端使用*/
            lucency_field: number
        ];
        recv: {
            /** 错误码 */
            error_code: number;
            /** 活动主类型 */
            base_type: number;
            /** 活动子类型 */
            sub_type: number;
            /** 是否自动购买 */
            auto_buy: number;
            /** 预留字段，客户端使用 */
            lucency_field: number;
            /** 当前幸运值 */
            current_luck: number;
            /** 当前抽奖次数 */
            current_times: number;
            /** 奖励列表 */
            reward_list: {
                /** 档次 */
                grade_id: number;
                /**  奖励 */
                reward: string;
                /** 是否大奖 */
                is_nice: number;
            }[];
        };
    };
    33247: {
        desc: "多倍充值活动界面";
        send: (
            number: 33247,
            fmt: "hh",
            args: [
                /**活动主类型*/
                base_type: number,
                /**活动子类型*/
                sub_type: number
            ]
        ) => never;
        sendFmt: "hh";
        sendArgs: [
            /**活动主类型*/
            base_type: number,
            /**活动子类型*/
            sub_type: number
        ];
        recv: {
            /** 活动主类型 */
            base_type: number;
            /** 活动子类型 */
            sub_type: number;
            /** 剩余返利次数 */
            times: number;
        };
    };
    33248: {
        desc: "冲级礼包时间戳";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            min_time: number;
            max_time: number;
        };
    };
    33249: {
        desc: "弹窗好评";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            errcode: number;
        };
    };
    33250: {
        desc: "广告定制活动cd";
        send: (
            number: 33250,
            fmt: "hh",
            args: [
                /**活动主类型*/
                base_type: number,
                /**活动子类型*/
                sub_type: number
            ]
        ) => never;
        sendFmt: "hh";
        sendArgs: [
            /**活动主类型*/
            base_type: number,
            /**活动子类型*/
            sub_type: number
        ];
        recv: {
            /** 活动主类型 */
            base_type: number;
            /** 活动子类型 */
            sub_type: number;
            cd_lists: {
                /** 档次 */
                grade_id: number;
                /** cd时间，大于时间就可以看， 列表中没有默认直接可以看 */
                cd_time: number;
            }[];
        };
    };
    33251: {
        desc: "冲榜排名变化提醒";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 冲榜活动id */
            rush_rank_id: number;
            /** 变化类型： 0 排名被超过 1 进入下一阶段目标, 2 登临榜首 3 到达阈值条件 4 第二名多久超过 */
            type: number;
            /** 下一阶段排名 如 100\\20\\3\\1，只有type == 1 时有效 */
            rank: number;
            /** 等级榜为等级，坐骑为阶数,以此类推 */
            value: number;
            /** 坐骑榜为星数，只有需要第二值的才有效，以此类推 */
            sub_value: number;
        };
    };
    33252: {
        desc: "冲榜夺宝界面信息";
        send: (
            number: 33252,
            fmt: "hh",
            args: [
                /**主类型*/
                type: number,
                /**次类型*/
                subtype: number
            ]
        ) => never;
        sendFmt: "hh";
        sendArgs: [
            /**主类型*/
            type: number,
            /**次类型*/
            subtype: number
        ];
        recv: {
            /** 主类型 */
            type: number;
            /** 次类型 */
            subtype: number;
            /** 玩家积分 */
            score: number;
            /** 今日积分 */
            today_score: number;
            /** 条件 */
            condition: string;
            /** 显示奖励id列表 */
            reward_list: {
                /** 奖励id */
                grade_id: number;
                /** 是否是大奖 */
                is_rare: number;
                /** 奖励 */
                reward: any;
            }[];
            stage_list: {
                /** 奖励id */
                id: number;
                /** 1为可领取；2为已领取；3为未达条件 */
                got_type: number;
            }[];
            /** 世界等级 */
            world_lv: number;
        };
    };
    33253: {
        desc: "冲榜夺宝榜单信息";
        send: (
            number: 33253,
            fmt: "hh",
            args: [
                /**主类型*/
                type: number,
                /**次类型*/
                subtype: number
            ]
        ) => never;
        sendFmt: "hh";
        sendArgs: [
            /**主类型*/
            type: number,
            /**次类型*/
            subtype: number
        ];
        recv: {
            /** 主类型 */
            type: number;
            /** 次类型 */
            subtype: number;
            /** 玩家积分 */
            score: number;
            /** 自己排名 */
            rank: number;
            rank_list: {
                /** 排名 */
                rank: number;
                server_id: number;
                role_id: number;
                role_name: string;
                /** 积分 */
                role_score: number;
            }[];
            /** 区服本服积分 */
            sever_score: number;
            /** 区服本服排名 */
            server_rank: number;
            server_rank_list: {
                /** 排名 */
                rank: number;
                /** 服务器Id */
                server_id: number;
                /**  服务器名 */
                server_name: string;
                /** 积分 */
                server_score: number;
            }[];
        };
    };
    33254: {
        desc: "领取冲榜夺宝阶段奖励";
        send: (
            number: 33254,
            fmt: "hhh",
            args: [
                /**主类型*/
                type: number,
                /**次类型*/
                subtype: number,
                /**奖励id*/
                reward_id: number
            ]
        ) => never;
        sendFmt: "hhh";
        sendArgs: [
            /**主类型*/
            type: number,
            /**次类型*/
            subtype: number,
            /**奖励id*/
            reward_id: number
        ];
        recv: {
            /** 主类型 */
            type: number;
            /** 次类型 */
            subtype: number;
            /** 奖励id */
            reward_id: number;
            /** 错误码 */
            error_code: number;
        };
    };
    33255: {
        desc: "红包返利活动信息（开始结束时间是绑定个人的）";
        send: (
            number: 33255,
            fmt: "hh",
            args: [
                /**主类型*/
                type: number,
                /**次类型*/
                subtype: number
            ]
        ) => never;
        sendFmt: "hh";
        sendArgs: [
            /**主类型*/
            type: number,
            /**次类型*/
            subtype: number
        ];
        recv: {
            /** 主类型 */
            type: number;
            /** 次类型 */
            subtype: number;
            /** 是否有资格参加 */
            is_quality: number;
            /** 开启时间 */
            start_time: number;
            /** 结束时间 */
            end_time: number;
            /** 登录红包可提现金额 */
            login_money: number;
            /** 充值返利可提现金额 */
            recharge_money: number;
            /** 提现状态，默认是0,；1的时候是提现中（可能需要时间） */
            login_status: number;
            /** 提现状态，默认是0,；1的时候是提现中（可能需要时间） */
            recharge_status: number;
            /** 充值红包是否提现过 0 无 1 有 */
            login_withdrawal: number;
            /** 返利红包是否提现过 0 无 1 有 */
            recharge_withdrawal: number;
            /** 全服登录红包提现次数 */
            login_global_times: number;
            /** 全服充值红包提现次数 */
            recharge_global_times: number;
        };
    };
    33256: {
        desc: "红包返利提现红包";
        send: (
            number: 33256,
            fmt: "hhcss",
            args: [
                /**主类型*/
                type: number,
                /**次类型*/
                subtype: number,
                /**提现类型， 1 登录红包提现  2 充值红包提现*/
                withdraw_type: number,
                package_code: string,
                token_id: string
            ]
        ) => never;
        sendFmt: "hhcss";
        sendArgs: [
            /**主类型*/
            type: number,
            /**次类型*/
            subtype: number,
            /**提现类型， 1 登录红包提现  2 充值红包提现*/
            withdraw_type: number,
            package_code: string,
            token_id: string
        ];
        recv: {
            /** 主类型 */
            type: number;
            /** 次类型 */
            subtype: number;
            errcode: number;
            /** 登录红包可提现金额 */
            login_money: number;
            /** 充值返利可提现金额 */
            recharge_money: number;
            /** 提现状态，默认是0,；1的时候是提现中（可能需要时间） */
            login_status: number;
            /** 提现状态，默认是0,；1的时候是提现中（可能需要时间） */
            recharge_status: number;
        };
    };
    33257: {
        desc: "服务端推送具体奖励";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 主类型 */
            type: number;
            /** 次类型 */
            subtype: number;
            reward_list: {
                style: number;
                goods_id: number;
                num: number;
            }[];
        };
    };
    33258: {
        desc: "全民狂欢任务进度|（也会主动推送）";
        send: (
            number: 33258,
            fmt: "hh",
            args: [
                /**主类型*/
                type: number,
                /**次类型*/
                subtype: number
            ]
        ) => never;
        sendFmt: "hh";
        sendArgs: [
            /**主类型*/
            type: number,
            /**次类型*/
            subtype: number
        ];
        recv: {
            /** 主类型 */
            type: number;
            /** 次类型 */
            subtype: number;
            task_list: {
                /** 奖励档次 */
                grade: number;
                /** 进度值 */
                process: number;
            }[];
        };
    };
}

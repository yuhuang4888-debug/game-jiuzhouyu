/** 活动
 */
declare interface ProtoFmtInfo {
    33100: {
        desc: "错误码展示";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            error_code: number;
        };
    };
    33101: {
        desc: "获取活动列表(登陆请求)";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            list: {
                /** 活动主类型 */
                base_type: number;
                /** 活动子类型 */
                sub_type: number;
                /** 活动类型 1:开服活动 2:合服活动 3:运营活动 4:单独图标 5:封测活动 */
                act_type: number;
                /** 展示id */
                show_id: number;
                /** 活动开始时候的世界等级 */
                wlv: number;
                /**  活动名字 */
                name: string;
                /**  活动描述 */
                desc: string;
                /**  条件 */
                condition: string;
                /** 开始时间 */
                stime: number;
                /** 结束时间 */
                etime: number;
            }[];
        };
    };
    33102: {
        desc: "活动开启推送客户端要根据推送的结束时间更新定时器的时间";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            list: {
                /** 活动主类型 */
                base_type: number;
                /** 活动子类型 */
                sub_type: number;
                /** 活动类型 1:开服活动 2:合服活动 3:运营活动 4:单独图标 5:封测活动 */
                act_type: number;
                /** 展示id */
                show_id: number;
                /** 活动开始时候的世界等级 */
                wlv: number;
                /**  活动名字 */
                name: string;
                /**  活动描述 */
                desc: string;
                /**  条件 */
                condition: string;
                /** 开始时间 */
                stime: number;
                /** 结束时间 */
                etime: number;
            }[];
        };
    };
    33103: {
        desc: "活动结束";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            list: {
                /** 活动主类型 */
                base_type: number;
                /** 活动子类型 */
                sub_type: number;
            }[];
        };
    };
    33104: {
        desc: "获取奖励领取状态(通用活动)";
        send: (
            number: 33104,
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
    33105: {
        desc: "领取活动奖励(通用活动)";
        send: (
            number: 33105,
            fmt: "hhh",
            args: [
                /**活动主类型*/
                base_type: number,
                /**活动子类型*/
                sub_type: number,
                /**奖励档次*/
                grade: number
            ]
        ) => never;
        sendFmt: "hhh";
        sendArgs: [
            /**活动主类型*/
            base_type: number,
            /**活动子类型*/
            sub_type: number,
            /**奖励档次*/
            grade: number
        ];
        recv: {
            /** 返回码 */
            error_code: number;
            /** 活动主类型 */
            base_type: number;
            /** 活动子类型 */
            sub_type: number;
            /** 奖励档次 */
            grade: number;
        };
    };
    33106: {
        desc: "特殊记录全服领取的奖励总数";
        send: (
            number: 33106,
            fmt: "hhhhh",
            args: [
                /**活动主类型*/
                base_type: number,
                /**活动子类型*/
                sub_type: number,
                /**模块id*/
                mod_id: number,
                /**计数器id*/
                counter_id: number,
                /**档次id*/
                grade: number
            ]
        ) => never;
        sendFmt: "hhhhh";
        sendArgs: [
            /**活动主类型*/
            base_type: number,
            /**活动子类型*/
            sub_type: number,
            /**模块id*/
            mod_id: number,
            /**计数器id*/
            counter_id: number,
            /**档次id*/
            grade: number
        ];
        recv: {
            /** 活动主类型 */
            base_type: number;
            /** 活动子类型 */
            sub_type: number;
            /** 模块id */
            mod_id: number;
            /** 计数器id */
            counter_id: number;
            /** 总数 */
            count: number;
            /** 档次id */
            grade: number;
        };
    };
    33107: {
        desc: "消费活动状态信息";
        send: (
            number: 33107,
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
            values: {
                /** 消费类别 1钻石 2绑钻 3金币 */
                type: number;
                /** 已经消费的数值 */
                value: number;
            }[];
        };
    };
    33108: {
        desc: "活动刷新列表";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            values: {
                /** 活动主类型 */
                base_type: number;
                /** 活动子类型 */
                sub_type: number;
            }[];
        };
    };
    33110: {
        desc: "确认已经五星评价";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 返回码 */
            code: number;
        };
    };
    33111: {
        desc: "打开特惠商城";
        send: (
            number: 33111,
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
            errcode: number;
            grade_num_list: {
                /** 奖励档次 */
                grade: number;
                /** 消耗货币类型 */
                cost_type: number;
                /** 消耗货币数量 */
                cost_num: number;
                /** 折扣 */
                cost_discount: number;
                /** 剩余次数 */
                less_num: number;
                /** 总次数 */
                all_num: number;
                /** 个人剩余次数 */
                less_num_self: number;
                /** 个人总次数 */
                all_num_self: number;
            }[];
        };
    };
    33112: {
        desc: "众仙云购信息";
        send: (
            number: 33112,
            fmt: "h",
            args: [
                /**活动子类型*/
                sub_type: number
            ]
        ) => never;
        sendFmt: "h";
        sendArgs: [
            /**活动子类型*/
            sub_type: number
        ];
        recv: {
            /** 错误码 */
            errcode: number;
            /** 活动子类型 */
            sub_type: number;
            /** 是否跨服活动 0本服 1跨服 */
            if_kf: number;
            /** 下次开奖时间 */
            next_reward_time: number;
            /** 本轮不限购买次数开始时间 */
            not_limit_begin_time: number;
            /** 已购份数 */
            all_buy_num: number;
            /** 幸运大奖id */
            big_reward_id: number;
            /** 全服购买记录 */
            all_buy_list: {
                /**  平台 */
                platform: string;
                /** 服务器编号 */
                server_num: number;
                /**  玩家名字 */
                name: string;
                /** 物品类型id */
                goods_id_list: {
                    goods_id: number;
                }[];
                /** 购买份数 */
                player_buy_num: number;
                /** 购买时间 */
                award_time: number;
            }[];
            stage: {
                /** 阶段id */
                buy_times: number;
                /** 状态 0不满足条件 1可领取 2已领取 */
                state: number;
            }[];
            /** 玩家购买数量 */
            self_buy_num: number;
            /** 剩余购买数量 */
            less_buy_num: number;
            /** 参与人数 */
            join_num: number;
        };
    };
    33113: {
        desc: "众仙云购-购买";
        send: (
            number: 33113,
            fmt: "hhc",
            args: [
                /**活动子类型*/
                sub_type: number,
                /**购买份数*/
                buy_num: number,
                /**是否自动购买 0不自动 1自动*/
                if_auto_buy: number
            ]
        ) => never;
        sendFmt: "hhc";
        sendArgs: [
            /**活动子类型*/
            sub_type: number,
            /**购买份数*/
            buy_num: number,
            /**是否自动购买 0不自动 1自动*/
            if_auto_buy: number
        ];
        recv: {
            /** 错误码 */
            errcode: number;
            /** 活动子类型 */
            sub_type: number;
            buy_list: {
                /** 物品类型 */
                good_type: number;
                /** 物品id */
                reward_id: number;
                /** 物品数量 */
                reward_num: number;
            }[];
            buy_times_list: {
                /** 阶段奖励对应的购买次数 无则发0 */
                buy_times: number;
            }[];
        };
    };
    33114: {
        desc: "众仙云购-上期中奖名单";
        send: (
            number: 33114,
            fmt: "h",
            args: [
                /**活动子类型*/
                sub_type: number
            ]
        ) => never;
        sendFmt: "h";
        sendArgs: [
            /**活动子类型*/
            sub_type: number
        ];
        recv: {
            /** 活动子类型 */
            sub_type: number;
            /** 获奖人员名单 */
            bingo_player_list: {
                /** 幸运大奖id */
                big_bingo_id: number;
                /** 开奖时间 */
                award_time: number;
                /**  平台 */
                platform: string;
                /** 服务器编号 */
                server_num: number;
                /**  玩家名字 */
                name: string;
                /** 玩家id */
                role_id: number;
                /** 购买份数 */
                buy_times: number;
            }[];
        };
    };
    33115: {
        desc: "打开完美恋人";
        send: (
            number: 33115,
            fmt: "hc",
            args: [
                /**活动子类型*/
                sub_type: number,
                /**1.查看活动 2 领取奖励*/
                opr: number
            ]
        ) => never;
        sendFmt: "hc";
        sendArgs: [
            /**活动子类型*/
            sub_type: number,
            /**1.查看活动 2 领取奖励*/
            opr: number
        ];
        recv: {
            /** 错误码 */
            code: number;
            /** 活动子类型 */
            sub_type: number;
            /** 1.查看活动 2 领取奖励 */
            opr: number;
            /** 奖励状态 0 不可领取 1可领取 2已领取 */
            if_get_reward: number;
            /** 婚礼举办次数列表 */
            wedding_type_list: {
                /** 婚礼类型id */
                wedding_type_id: number;
                /** 举行次数 */
                wedding_times: number;
            }[];
        };
    };
    33116: {
        desc: "限时云购领取阶段奖励更新";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 活动子类型 */
            sub_type: number;
            stage: {
                /** 阶段id */
                buy_times: number;
                /** 状态 0不满足条件 1可领取 2已领取 */
                state: number;
            }[];
        };
    };
    33118: {
        desc: "公会争霸运营活动信息更新";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 活动主类型 */
            base_type: number;
            /** 活动子类型 */
            sub_type: number;
        };
    };
    33120: {
        desc: "砸蛋界面信息";
        send: (
            number: 33120,
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
            /** 计时时间(一般为活动开始时间或者0点清理时间) */
            start_time: number;
            /** 已经免费砸蛋次数 */
            free_smashed_times: number;
            /** 已经砸蛋次数 */
            smashed_times: number;
            /** 手动刷新次数 */
            refresh_times: number;
            /** 稀有物品列表 */
            show_list: {
                goods_list: any;
            }[];
            eggs: {
                /** 金蛋编号 1~4 */
                id: number;
                /** 0 普通蛋 1 金蛋 */
                etype: number;
                /** 0: 未砸 1: 已砸 */
                status: number;
                goods_list: any;
            }[];
            record: {
                /**  玩家名字 */
                name: string;
                goods_list: any;
                /** 时间 */
                time: number;
            }[];
            /** 累计奖励领取情况 */
            cumulate_reward: {
                /** 奖励id */
                grade_id: number;
                /** 奖励需要砸蛋次数 */
                times: number;
                /** 奖励 */
                reward: any;
                /** 0: 未达成 1: 已达成未领取 2: 已领取 */
                status: number;
            }[];
        };
    };
    33121: {
        desc: "砸蛋刷新";
        send: (
            number: 33121,
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
            errcode: number;
            /** 活动主类型 */
            base_type: number;
            /** 活动子类型 */
            sub_type: number;
        };
    };
    33122: {
        desc: "砸蛋";
        send: (
            number: 33122,
            fmt: "hhcc",
            args: [
                /**活动主类型*/
                base_type: number,
                /**活动子类型*/
                sub_type: number,
                /**第几个金蛋 0:表示全砸*/
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
            /**第几个金蛋 0:表示全砸*/
            index: number,
            /**是否自动购买 0:不自动 1:自动*/
            auto_buy: number
        ];
        recv: {
            /** 返回码 */
            errcode: number;
            /** 活动主类型 */
            base_type: number;
            /** 活动子类型 */
            sub_type: number;
            /** 已经免费砸蛋次数 */
            free_smashed_times: number;
            /** 已经砸蛋次数 */
            smashed_times: number;
            eggs: {
                /** 金蛋编号 1~4 */
                id: number;
                goods_list: any;
            }[];
        };
    };
    33123: {
        desc: "领取累计奖励";
        send: (
            number: 33123,
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
            errcode: number;
            /** 活动主类型 */
            base_type: number;
            /** 活动子类型 */
            sub_type: number;
            /** 累计奖励领取情况 */
            cumulate_reward: {
                /** 奖励id */
                grade_id: number;
                /** 奖励需要砸蛋次数 */
                times: number;
                /** 奖励 */
                reward: any;
                /** 0: 未达成 1: 已达成未领取 2: 已领取 */
                status: number;
            }[];
        };
    };
    33126: {
        desc: "活动Boss信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 活动阶段 0:活动关闭 1:活动Boss已经生成 2:等待下场活动Boss开启 3:活动Boss全被击杀 */
            status: number;
            /** 当前活动阶段结束时间戳 */
            stage_etime: number;
            boss_list: {
                /** 场景id */
                scene_id: number;
                /** 剩余数量 */
                remain_num: number;
            }[];
        };
    };
    33127: {
        desc: "立即前往";
        send: (
            number: 33127,
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
            /** 错误码 */
            errcode: number;
        };
    };
    33128: {
        desc: "界面协议";
        send: (
            number: 33128,
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
            draw_times: number;
            /** 重置次数 */
            reset: number;
            pool: {
                /** 稀有度 0稀有 1史诗 2传说 */
                rare: number;
                /** 档次id */
                grade: number;
                /** 0未抽中,其他表示被抽中的抽奖次数（9，第9次被抽中） */
                status: number;
            }[];
            stage: {
                /** 奖励档次 */
                grade: number;
                /** 0未达成 1已达成未领取 2已领取 */
                status: number;
            }[];
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
    33129: {
        desc: "自选奖池";
        send: (
            number: 33129,
            fmt: "hhA",
            args: [
                /**活动主类型*/
                base_type: number,
                /**活动子类型*/
                sub_type: number,
                /**发空表示随机奖池*/
                pool: any
            ]
        ) => never;
        sendFmt: "hhA";
        sendArgs: [
            /**活动主类型*/
            base_type: number,
            /**活动子类型*/
            sub_type: number,
            /**发空表示随机奖池*/
            pool: any
        ];
        recv: {
            /** 活动主类型 */
            base_type: number;
            /** 活动子类型 */
            sub_type: number;
            pool: {
                /** 稀有度 0稀有 1史诗 2传说 */
                rare: number;
                /** 档次id */
                grade: number;
                /** 0未抽中,其他表示被抽中的抽奖次数（9，第9次被抽中） */
                status: number;
            }[];
            /** 返回码 */
            error_code: number;
        };
    };
    33130: {
        desc: "幸运转盘活动数据";
        send: (
            number: 33130,
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
            /** 剩余券数 */
            ticket_num: number;
            /** 获得总券数 */
            total_tickets: number;
            /** 获得总剩余可获得卷数 */
            total_left_tickets: number;
            /** 当前累计充值 */
            charge_gold: number;
            /** 还需多少 */
            need_gold: number;
            /** 倍数列表 */
            n_times_list: {
                /** 倍数 */
                n_times: number;
            }[];
            reward_list: {
                /** 物品id */
                goods_id: number;
                /** 物品数量 */
                goods_num: number;
            }[];
        };
    };
    33131: {
        desc: "幸运转盘抽奖";
        send: (
            number: 33131,
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
            /** 中奖的物品id  物品id和数量联合代表中奖奖项 */
            goods_id: number;
            /** 物品数量      物品id和数量联合代表中奖奖项 */
            goods_num: number;
            /** 倍数 */
            n_times: number;
            /** 剩余券数 */
            ticket_num: number;
            /** 获得总剩余可获得卷数 */
            total_left_tickets: number;
        };
    };
    33132: {
        desc: "幸运转盘抽奖记录";
        send: (
            number: 33132,
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
            list: {
                role_id: number;
                role_name: string;
                goods_id: number;
                goods_num: number;
                n_times: number;
            }[];
        };
    };
    33133: {
        desc: "重置奖励";
        send: (
            number: 33133,
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
            /** 返回码 */
            error_code: number;
            /** 抽奖次数 */
            draw_times: number;
            /** 重置次数 */
            reset: number;
            pool: {
                /** 稀有度 0稀有 1史诗 2传说 */
                rare: number;
                /** 档次id */
                grade: number;
                /** 0未抽中,其他表示被抽中的抽奖次数（9，第9次被抽中） */
                status: number;
            }[];
            stage: {
                /** 奖励档次 */
                grade: number;
                /** 0未达成 1已达成未领取 2已领取 */
                status: number;
            }[];
        };
    };
    33134: {
        desc: "抽奖";
        send: (
            number: 33134,
            fmt: "hhc",
            args: [
                /**活动主类型*/
                base_type: number,
                /**活动子类型*/
                sub_type: number,
                /**0自动不购买 1自动购买*/
                auto_buy: number
            ]
        ) => never;
        sendFmt: "hhc";
        sendArgs: [
            /**活动主类型*/
            base_type: number,
            /**活动子类型*/
            sub_type: number,
            /**0自动不购买 1自动购买*/
            auto_buy: number
        ];
        recv: {
            /** 活动主类型 */
            base_type: number;
            /** 活动子类型 */
            sub_type: number;
            /** 抽奖次数 */
            draw_times: number;
            /** 返回码 */
            error_code: number;
            grade: number;
            /** 0稀有 1史诗 2传说 */
            rare: number;
            /** 奖励 */
            reward: any;
        };
    };
    33135: {
        desc: "领取阶段奖励";
        send: (
            number: 33135,
            fmt: "hhh",
            args: [
                /**活动主类型*/
                base_type: number,
                /**活动子类型*/
                sub_type: number,
                grade: number
            ]
        ) => never;
        sendFmt: "hhh";
        sendArgs: [
            /**活动主类型*/
            base_type: number,
            /**活动子类型*/
            sub_type: number,
            grade: number
        ];
        recv: {
            /** 活动主类型 */
            base_type: number;
            /** 活动子类型 */
            sub_type: number;
            grade: number;
            error_code: number;
        };
    };
    33136: {
        desc: "0元豪礼界面信息";
        send: (
            number: 33136,
            fmt: "h",
            args: [
                /**活动子类型*/
                sub_type: number
            ]
        ) => never;
        sendFmt: "h";
        sendArgs: [
            /**活动子类型*/
            sub_type: number
        ];
        recv: {
            /** 返回码 */
            errcode: number;
            /** 活动子类型 */
            sub_type: number;
            reward_list: {
                /** 奖励档次 */
                grade: number;
                /** 奖励格式类型 见后台备注 */
                form_type: number;
                /** 领取状态 0:未购买当前档次奖励 1:已购买未领取返利奖励 2:已领取返利奖励 */
                status: number;
                /** 领取状态为1的时候表示返利什么时候可以领取, 其他时候该字段无效 */
                receive_time: number;
                /**  活动名字 */
                name: string;
                /**  活动描述 */
                desc: string;
                /**  领取条件 */
                condition: string;
                /**  奖励 具体参考后台配置的格式 */
                reward: string;
            }[];
        };
    };
    33137: {
        desc: "0元豪礼购买";
        send: (
            number: 33137,
            fmt: "hh",
            args: [
                /**活动子类型*/
                sub_type: number,
                /**奖励档次*/
                grade: number
            ]
        ) => never;
        sendFmt: "hh";
        sendArgs: [
            /**活动子类型*/
            sub_type: number,
            /**奖励档次*/
            grade: number
        ];
        recv: {
            /** 返回码 */
            errcode: number;
            /** 奖励档次 */
            grade: number;
            /** 活动子类型 */
            sub_type: number;
        };
    };
    33138: {
        desc: "0元豪礼领取返利奖励";
        send: (
            number: 33138,
            fmt: "hh",
            args: [
                /**活动子类型*/
                sub_type: number,
                /**奖励档次*/
                grade: number
            ]
        ) => never;
        sendFmt: "hh";
        sendArgs: [
            /**活动子类型*/
            sub_type: number,
            /**奖励档次*/
            grade: number
        ];
        recv: {
            /** 返回码 */
            errcode: number;
            /** 奖励档次 */
            grade: number;
            /** 活动子类型 */
            sub_type: number;
        };
    };
    33139: {
        desc: "随机产生奖池";
        send: (
            number: 33139,
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
            pool: {
                /** 稀有度 0稀有 1史诗 2传说 */
                rare: number;
                /** 档次id */
                grade: number;
            }[];
        };
    };
    33140: {
        desc: "嗨点信息";
        send: (
            number: 33140,
            fmt: "h",
            args: [
                /**活动子类型*/
                sub_type: number
            ]
        ) => never;
        sendFmt: "h";
        sendArgs: [
            /**活动子类型*/
            sub_type: number
        ];
        recv: {
            /** 获得总嗨点值 */
            sum_points: number;
            mod_list: {
                /** 模块id */
                mod_id: number;
                sub_id: number;
                condition_type: string;
                /**  名称 */
                name: string;
                /** 排序id */
                order_id: number;
                /** 跳转id */
                jump_id: number;
                /** 保留值 */
                sec_value: number;
                /**  模块图片 */
                icon_type: string;
                /** 进度值 */
                pro_value: number;
                /** 是否显示进度 */
                is_pro: number;
                /** 目标值 */
                condi_val: number;
                /** 奖励嗨点 */
                reward_point: number;
                /**  描述 */
                dec: string;
                /** 是否已完成 */
                is_com: number;
            }[];
        };
    };
    33141: {
        desc: "许愿池界面";
        send: (
            number: 33141,
            fmt: "hh",
            args: [
                /**活动类型*/
                base_type: number,
                /**活动子类型*/
                sub_type: number
            ]
        ) => never;
        sendFmt: "hh";
        sendArgs: [
            /**活动类型*/
            base_type: number,
            /**活动子类型*/
            sub_type: number
        ];
        recv: {
            /** 活动类型 */
            base_type: number;
            /** 活动子类型 */
            sub_type: number;
            rare_pool: {
                /** 档次 */
                grade: number;
                /** 幸运值 */
                lucky_value: number;
                /** 免费次数 */
                free_times: number;
                /** 0未被抽中1抽中 */
                state: number;
                /** 最大幸运值 */
                max_luckey_value: number;
            }[];
        };
    };
    33142: {
        desc: "许愿池抽奖";
        send: (
            number: 33142,
            fmt: "hhhhc",
            args: [
                /**活动类型*/
                base_type: number,
                /**活动子类型*/
                sub_type: number,
                /**大奖档次id*/
                grade: number,
                /**抽奖次数 1 10*/
                times: number,
                /**自动购买 0否 1是*/
                auto_buy: number
            ]
        ) => never;
        sendFmt: "hhhhc";
        sendArgs: [
            /**活动类型*/
            base_type: number,
            /**活动子类型*/
            sub_type: number,
            /**大奖档次id*/
            grade: number,
            /**抽奖次数 1 10*/
            times: number,
            /**自动购买 0否 1是*/
            auto_buy: number
        ];
        recv: {
            /** 活动类型 */
            base_type: number;
            /** 活动子类型 */
            sub_type: number;
            /** 大奖档次id */
            grade: number;
            /** 返回码 */
            error_code: number;
            reward_list: {
                reward: any;
                /** 是否稀有 */
                is_rare: number;
            }[];
            /** 幸运值 */
            lucky_value: number;
            /** 免费次数 */
            free_times: number;
            /** 0未被抽中1抽中 */
            state: number;
        };
    };
    33143: {
        desc: "连续消费活动信息";
        send: (
            number: 33143,
            fmt: "h",
            args: [
                /**活动子类型*/
                sub_type: number
            ]
        ) => never;
        sendFmt: "h";
        sendArgs: [
            /**活动子类型*/
            sub_type: number
        ];
        recv: {
            /** 当天消费值 */
            today_consume: number;
            /** 累计天数 */
            continue_day: number;
        };
    };
    33144: {
        desc: "许愿池重置";
        send: (
            number: 33144,
            fmt: "hhh",
            args: [
                /**活动类型*/
                base_type: number,
                /**活动子类型*/
                sub_type: number,
                /**大奖档次id*/
                grade: number
            ]
        ) => never;
        sendFmt: "hhh";
        sendArgs: [
            /**活动类型*/
            base_type: number,
            /**活动子类型*/
            sub_type: number,
            /**大奖档次id*/
            grade: number
        ];
        recv: {
            /** 活动类型 */
            base_type: number;
            /** 活动子类型 */
            sub_type: number;
            /** 大奖档次id */
            grade: number;
            /** 返回码 */
            code: number;
            /** 幸运值 */
            lucky_value: number;
            /** 免费次数 */
            free_times: number;
            /** 0未被抽中1抽中 */
            state: number;
            /** 最大幸运值 */
            max_luckey_value: number;
        };
    };
    33145: {
        desc: "Boss首杀信息";
        send: (
            number: 33145,
            fmt: "h",
            args: [
                /**活动子类型*/
                sub_type: number
            ]
        ) => never;
        sendFmt: "h";
        sendArgs: [
            /**活动子类型*/
            sub_type: number
        ];
        recv: {
            boss_list: {
                /** 奖励档次 */
                grade: number;
                /** boss id */
                boss_id: number;
                /** 是否被击杀 1：已击杀 0：未击杀 */
                killed: number;
                /** 领取状态 0：不可领 1：可领 2：已领 */
                reward_state: number;
                /** 归属信息 */
                bl_list: {
                    /** 玩家id */
                    role_id: number;
                    /**  名字 */
                    name: string;
                }[];
                reward_list: any;
            }[];
        };
    };
    33146: {
        desc: "Boss首杀领取奖励";
        send: (
            number: 33146,
            fmt: "hhi",
            args: [
                /**活动子类型*/
                sub_type: number,
                /**奖励档次*/
                grade: number,
                /**boss id*/
                boss_id: number
            ]
        ) => never;
        sendFmt: "hhi";
        sendArgs: [
            /**活动子类型*/
            sub_type: number,
            /**奖励档次*/
            grade: number,
            /**boss id*/
            boss_id: number
        ];
        recv: {
            /** 1:成功 */
            errcode: number;
            /** BOSS Id */
            boss_id: number;
            /** 领取状态 0：不可领 1：可领 2：已领 */
            reward_status: number;
        };
    };
    33148: {
        desc: "超值礼包活动";
        send: (
            number: 33148,
            fmt: "h",
            args: [
                /**活动子类型*/
                sub_type: number
            ]
        ) => never;
        sendFmt: "h";
        sendArgs: [
            /**活动子类型*/
            sub_type: number
        ];
        recv: {
            sub_type: number;
            /** 到达等级时的时间戳 */
            time: number;
        };
    };
    33149: {
        desc: "精品特卖信息";
        send: (
            number: 33149,
            fmt: "h",
            args: [
                /**活动子类型*/
                sub_type: number
            ]
        ) => never;
        sendFmt: "h";
        sendArgs: [
            /**活动子类型*/
            sub_type: number
        ];
        recv: {
            sub_type: number;
            /** 到达等级时的时间戳 */
            time: number;
        };
    };
    33151: {
        desc: "购买烟花";
        send: (
            number: 33151,
            fmt: "hi",
            args: [
                /**活动子类*/
                sub_type: number,
                /**数量*/
                num: number
            ]
        ) => never;
        sendFmt: "hi";
        sendArgs: [
            /**活动子类*/
            sub_type: number,
            /**数量*/
            num: number
        ];
        recv: {
            /** 错误码 */
            errcode: number;
        };
    };
    33152: {
        desc: "烟花世界等级";
        send: (
            number: 33152,
            fmt: "h",
            args: [
                /**活动子类*/
                sub_type: number
            ]
        ) => never;
        sendFmt: "h";
        sendArgs: [
            /**活动子类*/
            sub_type: number
        ];
        recv: {
            /** 活动开始时世界等级 */
            wlv: number;
        };
    };
    33153: {
        desc: "每日转盘抽奖";
        send: (
            number: 33153,
            fmt: "hc",
            args: [
                /**活动子类型*/
                sub_type: number,
                /**0: 抽一次 1: 抽十次*/
                type: number
            ]
        ) => never;
        sendFmt: "hc";
        sendArgs: [
            /**活动子类型*/
            sub_type: number,
            /**0: 抽一次 1: 抽十次*/
            type: number
        ];
        recv: {
            errcode: number;
            /** 活动子类型 */
            sub_type: number;
            /** 0: 抽一次 1: 抽十次 */
            type: number;
            grade_list: {
                /** 奖励档次id */
                grade_id: number;
            }[];
        };
    };
    33154: {
        desc: "每日转盘抽奖记录";
        send: (
            number: 33154,
            fmt: "h",
            args: [
                /**活动子类型*/
                sub_type: number
            ]
        ) => never;
        sendFmt: "h";
        sendArgs: [
            /**活动子类型*/
            sub_type: number
        ];
        recv: {
            /** 活动子类型 */
            sub_type: number;
            record_list: {
                role_id: number;
                role_name: string;
                grade_id: number;
                time: number;
            }[];
        };
    };
    33155: {
        desc: "活动红包界面信息";
        send: (
            number: 33155,
            fmt: "h",
            args: [
                /**活动子类*/
                sub_type: number
            ]
        ) => never;
        sendFmt: "h";
        sendArgs: [
            /**活动子类*/
            sub_type: number
        ];
        recv: {
            /** 活动子类 */
            sub_type: number;
            /** 红包活动数据 */
            act_value: number;
            /** 当前波数 */
            wave: number;
            /** 当前波数发送时间 */
            start_time: number;
            /** 1：0点， 2:4点 */
            clear_type: number;
            wave_receive: {
                /** 波数 */
                wave2: number;
                /** 1 已抢过 0 未抢过 */
                is_receive: number;
                rewards: any;
            }[];
        };
    };
    33157: {
        desc: "领取红包";
        send: (
            number: 33157,
            fmt: "h",
            args: [
                /**活动子类*/
                sub_type: number
            ]
        ) => never;
        sendFmt: "h";
        sendArgs: [
            /**活动子类*/
            sub_type: number
        ];
        recv: {
            /** 返回码 */
            errcode: number;
            /** 活动子类 */
            sub_type: number;
            /** 波数 */
            wave: number;
            rewards: any;
        };
    };
    33158: {
        desc: "开始发红包";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 活动子类 */
            sub_type: number;
            /** 当前波数 */
            wave: number;
            /** 当前波数发送时间 */
            start_time: number;
        };
    };
    33160: {
        desc: "打开幸运鉴宝";
        send: (
            number: 33160,
            fmt: "h",
            args: [
                /**活动子类*/
                sub_type: number
            ]
        ) => never;
        sendFmt: "h";
        sendArgs: [
            /**活动子类*/
            sub_type: number
        ];
        recv: {
            /** 返回码 */
            errcode: number;
            /** 活动子类 */
            sub_type: number;
            /** 幸运值 */
            lucky_num: number;
            /** 幸运值上限 */
            lucky_num_max: number;
        };
    };
    33161: {
        desc: "开始幸运鉴宝";
        send: (
            number: 33161,
            fmt: "hc",
            args: [
                /**活动子类*/
                sub_type: number,
                /**1单次 2十次*/
                type: number
            ]
        ) => never;
        sendFmt: "hc";
        sendArgs: [
            /**活动子类*/
            sub_type: number,
            /**1单次 2十次*/
            type: number
        ];
        recv: {
            /** 返回码 */
            errcode: number;
            /** 活动子类 */
            sub_type: number;
            /** 1单次 2十次 */
            type: number;
            /** 幸运值 */
            lucky_num: number;
            reward_list: {
                /** 奖励id */
                reward_id: number;
            }[];
        };
    };
    33162: {
        desc: "打开收集活动";
        send: (
            number: 33162,
            fmt: "h",
            args: [
                /**活动子类*/
                sub_type: number
            ]
        ) => never;
        sendFmt: "h";
        sendArgs: [
            /**活动子类*/
            sub_type: number
        ];
        recv: {
            /** 返回码 */
            errcode: number;
            /** 活动子类 */
            sub_type: number;
            /** 全服当前心动值 */
            now_point: number;
            /** 自己当前心动值 */
            self_now_point: number;
            /** 多倍经验结束时间 */
            exp_end_time: number;
            /** 副本多倍掉落结束时间 */
            drop_end_time: number;
            /** 本服奖励列表 */
            get_reward_id_list: {
                /** 奖励id */
                reward_id: number;
            }[];
        };
    };
    33163: {
        desc: "提交收集活动";
        send: (
            number: 33163,
            fmt: "hc",
            args: [
                /**活动子类*/
                sub_type: number,
                /**1钻石 2物品*/
                put_type: number
            ]
        ) => never;
        sendFmt: "hc";
        sendArgs: [
            /**活动子类*/
            sub_type: number,
            /**1钻石 2物品*/
            put_type: number
        ];
        recv: {
            /** 返回码 */
            errcode: number;
            /** 活动子类 */
            sub_type: number;
            /** 1钻石 2物品 */
            put_type: number;
            /** 奖励类型 1普通 2累计 */
            reward_type: number;
            /** 奖励id */
            reward_id: number;
        };
    };
    33164: {
        desc: "打开充值消费活动";
        send: (
            number: 33164,
            fmt: "h",
            args: [
                /**活动子类*/
                sub_type: number
            ]
        ) => never;
        sendFmt: "h";
        sendArgs: [
            /**活动子类*/
            sub_type: number
        ];
        recv: {
            /** 返回码 */
            errcode: number;
            /** 活动子类 */
            sub_type: number;
            /** 充值数 */
            recharge_num: number;
            /** 消费数 */
            consume_num: number;
        };
    };
    33165: {
        desc: "赛博夺宝界面";
        send: (
            number: 33165,
            fmt: "hh",
            args: [
                /**活动类型*/
                base_type: number,
                /**活动子类型*/
                sub_type: number
            ]
        ) => never;
        sendFmt: "hh";
        sendArgs: [
            /**活动类型*/
            base_type: number,
            /**活动子类型*/
            sub_type: number
        ];
        recv: {
            /** 活动类型 */
            base_type: number;
            /** 活动子类型 */
            sub_type: number;
            /** 当前波数 */
            wave: number;
            /** 总抽奖次数 */
            all_times: number;
            /** 今日抽奖次数 */
            today_drawtimes: number;
            /** 奖池 */
            pool: {
                reward: any;
                /** 档次id */
                grade_id: number;
                /** 是否大奖 1: 是 0: 否 */
                is_rare: number;
                /** 排序id */
                sort: number;
                /** 1未被抽中 0被抽中 */
                state: number;
            }[];
            stage_s: {
                /** 阶段 */
                stage: number;
                grade_state: {
                    /** 阶段档次 */
                    grade_stage: number;
                    grade_reward: any;
                    buy_reward: any;
                    /** 0未达成 1已达成未领取 2已领取 */
                    state_stage: number;
                    /** 0未购买 2已购买 是否可以购买依据state_stage判断 */
                    discount_state: number;
                }[];
            }[];
        };
    };
    33166: {
        desc: "赛博夺宝阶段奖励领取/购买";
        send: (
            number: 33166,
            fmt: "hhccc",
            args: [
                /**活动类型*/
                base_type: number,
                /**活动子类型*/
                sub_type: number,
                /**阶段*/
                stage: number,
                /**阶段档次*/
                grade_stage: number,
                /**1购买0领取*/
                buy: number
            ]
        ) => never;
        sendFmt: "hhccc";
        sendArgs: [
            /**活动类型*/
            base_type: number,
            /**活动子类型*/
            sub_type: number,
            /**阶段*/
            stage: number,
            /**阶段档次*/
            grade_stage: number,
            /**1购买0领取*/
            buy: number
        ];
        recv: {
            /** 返回码 1表示成功，其他表示出错 */
            error_code: number;
            /** 活动类型 */
            base_type: number;
            /** 活动子类型 */
            sub_type: number;
            /** 阶段 */
            stage: number;
            /** 阶段档次 */
            grade_stage: number;
            reward: any;
            /** 1购买0领取 */
            buy: number;
        };
    };
    33167: {
        desc: "赛博夺宝抽奖";
        send: (
            number: 33167,
            fmt: "hhcc",
            args: [
                /**活动主类型*/
                base_type: number,
                /**活动子类型*/
                sub_type: number,
                /**抽奖次数  1*/
                tiems: number,
                /**是否自动购买道具 1是，0否*/
                auto_buy: number
            ]
        ) => never;
        sendFmt: "hhcc";
        sendArgs: [
            /**活动主类型*/
            base_type: number,
            /**活动子类型*/
            sub_type: number,
            /**抽奖次数  1*/
            tiems: number,
            /**是否自动购买道具 1是，0否*/
            auto_buy: number
        ];
        recv: {
            /** 返回码 1表示成功，其他表示出错 */
            error_code: number;
            /** 活动主类型 */
            base_type: number;
            /** 活动子类型 */
            sub_type: number;
            /** 总抽奖次数 */
            all_times: number;
            /** 今日抽奖次数 */
            today_drawtimes: number;
            reward_list: {
                /** 奖励id */
                grade_id: number;
                /** 是否大奖 1: 是 0: 否 */
                is_rare: number;
                reward: any;
                sort: number;
            }[];
        };
    };
    33168: {
        desc: "摇钱树商城兑换";
        send: (
            number: 33168,
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
            /** 活动主类型 */
            base_type: number;
            /** 活动子类型 */
            sub_type: number;
            /** 奖励id */
            grade_id: number;
            /** 返回码 1表示成功，其他表示出错 */
            error_code: number;
            reward: any;
            /** 已兑换次数 */
            num: number;
            /** 积分 */
            score: number;
        };
    };
    33169: {
        desc: "实名认证成功";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: null;
    };
    33170: {
        desc: "跨服云购界面基础信息";
        send: (
            number: 33170,
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
            /** 活动类型 */
            type: number;
            /** 活动子类 */
            subtype: number;
            /** 阶段 1: 等待开奖 2: 已经全部开完奖，等待活动结束 */
            stage: number;
            /** 阶段结束时间 */
            etime: number;
            /** 展示列表 每次云购随机获得以下奖励 */
            show_list: {
                /** 奖励类型 */
                object_type: number;
                /** 物品类型id */
                gtype_id: number;
                /** 物品数量 */
                num: number;
                /** 是否稀有 0: 不稀有 1: 稀有 */
                is_rare: number;
            }[];
        };
    };
    33171: {
        desc: "跨服云购界面商品信息";
        send: (
            number: 33171,
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
            /** 活动类型 */
            type: number;
            /** 活动子类 */
            subtype: number;
            product_list: {
                /** 商品id */
                product_id: number;
                /**  商品名字 */
                product_name: string;
                /** 物品类型id */
                gtype_id: number;
                /** 每份数量 */
                goods_num: number;
                /** 全服已购份数 */
                total_buy_num: number;
                /** 总份数 */
                total_num_lim: number;
                /** 玩家自己购买份数 */
                self_buy_num: number;
                /** 玩家自己购买上限 */
                self_buy_lim: number;
                /** 获奖人数 */
                winner_num: number;
                /** 获奖人数上限 */
                winner_num_lim: number;
            }[];
            record: {
                /**  服务器名字 */
                server_name: string;
                /**  玩家名字 */
                role_name: string;
                /**  商品名字 */
                product_name: string;
                /** 购买份数 */
                buy_num: number;
            }[];
        };
    };
    33172: {
        desc: "跨服云购界面获奖信息";
        send: (
            number: 33172,
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
            /** 活动类型 */
            type: number;
            /** 活动子类 */
            subtype: number;
            /** 玩家自己中奖的物品 */
            obtain_list: {
                /** 奖励类型 */
                object_type: number;
                /** 物品类型id */
                gtype_id: number;
                /** 物品数量 */
                num: number;
            }[];
            /** 云购开奖记录 */
            record: {
                /**  服务器名字 */
                server_name: string;
                /**  玩家名字 */
                role_name: string;
                /**  商品名字 */
                product_name: string;
                /** 商品数量 */
                product_num: number;
            }[];
        };
    };
    33173: {
        desc: "跨服云购界面刷新";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 活动类型 */
            type: number;
            /** 活动子类 */
            subtype: number;
            /** 界面更新类型 1: 界面全部刷新 2: 刷33171 3: 刷33172 */
            utype: number;
        };
    };
    33174: {
        desc: "跨服云购购买";
        send: (
            number: 33174,
            fmt: "hhih",
            args: [
                /**活动类型*/
                type: number,
                /**活动子类*/
                subtype: number,
                /**商品id*/
                product_id: number,
                /**购买份数*/
                buy_num: number
            ]
        ) => never;
        sendFmt: "hhih";
        sendArgs: [
            /**活动类型*/
            type: number,
            /**活动子类*/
            subtype: number,
            /**商品id*/
            product_id: number,
            /**购买份数*/
            buy_num: number
        ];
        recv: {
            /** 返回码 */
            errcode: number;
            /** 活动类型 */
            type: number;
            /** 活动子类 */
            subtype: number;
            /** 商品id */
            product_id: number;
            /** 玩家自己购买份数 */
            self_buy_num: number;
            /** 玩家自己购买上限 */
            self_buy_lim: number;
            /** 全服已购份数 */
            total_buy_num: number;
            /** 总份数 */
            total_num_lim: number;
            reward: {
                /** 奖励类型 */
                object_type: number;
                /** 物品类型id */
                gtype_id: number;
                /** 物品数量 */
                num: number;
            }[];
        };
    };
    33175: {
        desc: "跨服云购中奖列表";
        send: (
            number: 33175,
            fmt: "hhi",
            args: [
                /**活动类型*/
                type: number,
                /**活动子类*/
                subtype: number,
                /**商品id*/
                product_id: number
            ]
        ) => never;
        sendFmt: "hhi";
        sendArgs: [
            /**活动类型*/
            type: number,
            /**活动子类*/
            subtype: number,
            /**商品id*/
            product_id: number
        ];
        recv: {
            winner_list: {
                /**  服务器名字 */
                server_name: string;
                /**  玩家名字 */
                role_name: string;
            }[];
        };
    };
    33176: {
        desc: "神佑祈愿抽奖";
        send: (
            number: 33176,
            fmt: "hhhc",
            args: [
                /**活动主类型*/
                base_type: number,
                /**活动子类型*/
                sub_type: number,
                /**抽奖次数*/
                draw_times: number,
                /**自动购买 0 否 1 是*/
                auto_buy: number
            ]
        ) => never;
        sendFmt: "hhhc";
        sendArgs: [
            /**活动主类型*/
            base_type: number,
            /**活动子类型*/
            sub_type: number,
            /**抽奖次数*/
            draw_times: number,
            /**自动购买 0 否 1 是*/
            auto_buy: number
        ];
        recv: {
            /** 活动主类型 */
            base_type: number;
            /** 活动子类型 */
            sub_type: number;
            /** 错误码 1表示成功 */
            error_code: number;
            list: {
                /** 是否稀有 0 否 1 是 */
                is_rare: number;
                /** 奖励 */
                reward: any;
            }[];
            /** 剩余免费次数 */
            free_times: number;
            /** 总积分 */
            total_score: number;
            stage: {
                /** 档次 */
                grade: number;
                /** 需要积分 */
                score: number;
                /** 奖励 */
                reward: any;
                /** 状态 0未达成 1已达成未领取 2已领取 */
                status: number;
            }[];
        };
    };
    33177: {
        desc: "神佑祈愿界面";
        send: (
            number: 33177,
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
            /** 剩余免费次数 */
            free_times: number;
            /** 总积分 */
            total_score: number;
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
            stage: {
                /** 档次 */
                grade: number;
                /** 需要积分 */
                score: number;
                /** 奖励 */
                reward: any;
                /** 状态 0未达成 1已达成未领取 2已领取 */
                status: number;
            }[];
        };
    };
    33178: {
        desc: "神佑祈愿领取阶段奖励";
        send: (
            number: 33178,
            fmt: "hhh",
            args: [base_type: number, sub_type: number, grade: number]
        ) => never;
        sendFmt: "hhh";
        sendArgs: [base_type: number, sub_type: number, grade: number];
        recv: {
            base_type: number;
            sub_type: number;
            grade: number;
            error_code: number;
            reward: any;
        };
    };
    33179: {
        desc: "领取多份奖励";
        send: (
            number: 33179,
            fmt: "hhhh",
            args: [
                /**活动主类型*/
                base_type: number,
                /**活动子类型*/
                sub_type: number,
                /**奖励档次*/
                grade: number,
                /**兑换份数*/
                num: number
            ]
        ) => never;
        sendFmt: "hhhh";
        sendArgs: [
            /**活动主类型*/
            base_type: number,
            /**活动子类型*/
            sub_type: number,
            /**奖励档次*/
            grade: number,
            /**兑换份数*/
            num: number
        ];
        recv: {
            /** 返回码 */
            error_code: number;
            /** 兑换份数 */
            num: number;
            /** 活动主类型 */
            base_type: number;
            /** 活动子类型 */
            sub_type: number;
            /** 奖励档次 */
            grade: number;
        };
    };
    33180: {
        desc: "幸运翻牌界面信息";
        send: (
            number: 33180,
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
            /** 活动类型 */
            type: number;
            /** 活动子类 */
            subtype: number;
            /** 卡牌是否展开 0: 未展开 1: 已展开 */
            is_open: number;
            /** 翻牌次数 */
            use_times: number;
            /** 今日翻牌次数 */
            total_use_times: number;
            /** 是否免费刷新 */
            is_free_refresh: number;
            /** 刷新次数 */
            refresh_times: number;
            reward_list: {
                /** 物品类型id */
                gtype_id: number;
                /** 物品数量 */
                num: number;
                /** 第几张牌抽中这个奖励 */
                pos: number;
            }[];
            record_list: {
                /**  玩家名字 */
                role_name: string;
                /** 物品类型id */
                gtype_id: number;
                /** 物品数量 */
                num: number;
                /** 时间 */
                time: number;
            }[];
        };
    };
    33181: {
        desc: "幸运翻牌刷新奖励";
        send: (
            number: 33181,
            fmt: "hhc",
            args: [
                /**活动类型*/
                type: number,
                /**活动子类*/
                subtype: number,
                /**0: 不自动购买 1: 自动购买*/
                auto_buy: number
            ]
        ) => never;
        sendFmt: "hhc";
        sendArgs: [
            /**活动类型*/
            type: number,
            /**活动子类*/
            subtype: number,
            /**0: 不自动购买 1: 自动购买*/
            auto_buy: number
        ];
        recv: {
            /** 返回码 */
            errcode: number;
        };
    };
    33182: {
        desc: "幸运翻牌翻牌";
        send: (
            number: 33182,
            fmt: "hhcc",
            args: [
                /**活动类型*/
                type: number,
                /**活动子类*/
                subtype: number,
                /**第几张牌*/
                pos: number,
                /**0: 不自动购买 1: 自动购买*/
                auto_buy: number
            ]
        ) => never;
        sendFmt: "hhcc";
        sendArgs: [
            /**活动类型*/
            type: number,
            /**活动子类*/
            subtype: number,
            /**第几张牌*/
            pos: number,
            /**0: 不自动购买 1: 自动购买*/
            auto_buy: number
        ];
        recv: {
            /** 返回码 */
            errcode: number;
            /** 第几张牌 */
            pos: number;
            /** 物品类型id */
            gtype_id: number;
            /** 物品数量 */
            num: number;
            /** 翻牌次数 */
            use_times: number;
            /** 今日翻牌次数 */
            total_use_times: number;
        };
    };
    33183: {
        desc: "幸运翻牌展开卡牌";
        send: (
            number: 33183,
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
            /** 返回码 */
            errcode: number;
            /** 活动类型 */
            type: number;
            /** 活动子类 */
            subtype: number;
        };
    };
    33184: {
        desc: "幸运翻牌记录";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 活动类型 */
            type: number;
            /** 活动子类 */
            subtype: number;
            record_list: {
                /**  玩家名字 */
                role_name: string;
                /** 物品类型id */
                gtype_id: number;
                /** 物品数量 */
                num: number;
                /** 时间 */
                time: number;
            }[];
        };
    };
    33185: {
        desc: "众仙云购";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            code: number;
        };
    };
    33186: {
        desc: "摇摇乐抽奖";
        send: (
            number: 33186,
            fmt: "hhhc",
            args: [
                /**活动主类型*/
                base_type: number,
                /**活动子类型*/
                sub_type: number,
                /**抽奖次数  1:抽一次奖 10：抽十次奖*/
                times: number,
                /**自动购买  0:扣代币   1: 扣钻石*/
                auto_buy: number
            ]
        ) => never;
        sendFmt: "hhhc";
        sendArgs: [
            /**活动主类型*/
            base_type: number,
            /**活动子类型*/
            sub_type: number,
            /**抽奖次数  1:抽一次奖 10：抽十次奖*/
            times: number,
            /**自动购买  0:扣代币   1: 扣钻石*/
            auto_buy: number
        ];
        recv: {
            /** 返回码 */
            errcode: number;
            /** 奖励 */
            reward_list: {
                /** 档次id */
                grade_id: number;
                /** 抽中相同的数量 */
                same_num: number;
                reward: any;
            }[];
        };
    };
    33187: {
        desc: "摇摇乐界面";
        send: (
            number: 33187,
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
            errcode: number;
            /** 累计抽奖次数 */
            shake_times: number;
        };
    };
    33188: {
        desc: "节日消费排行榜";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 我的排名   0为没上榜 */
            my_rank: number;
            /** 消费 */
            cost: number;
            rank_list: {
                /** 玩家id */
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
    33189: {
        desc: "节日消费奖励列表";
        send: (
            number: 33189,
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
                reward: any;
            }[];
        };
    };
    33190: {
        desc: "摇钱树界面协议";
        send: (
            number: 33190,
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
            /** 积分 */
            score: number;
            shop: {
                grade_id: number;
                reward: any;
                /** 需要积分 */
                need_score: number;
                /** 已兑换次数 */
                num: number;
                /** 最大兑换次数 */
                max_num: number;
                /** 1不清理 2 0点清理 3 4点清理 */
                clear_type: number;
            }[];
        };
    };
    33191: {
        desc: "摇钱树抽奖";
        send: (
            number: 33191,
            fmt: "hhcc",
            args: [
                /**活动主类型*/
                base_type: number,
                /**活动子类型*/
                sub_type: number,
                /**抽奖次数 1或10*/
                tiems: number,
                /**是否自动购买道具 1是，0否*/
                auto_buy: number
            ]
        ) => never;
        sendFmt: "hhcc";
        sendArgs: [
            /**活动主类型*/
            base_type: number,
            /**活动子类型*/
            sub_type: number,
            /**抽奖次数 1或10*/
            tiems: number,
            /**是否自动购买道具 1是，0否*/
            auto_buy: number
        ];
        recv: {
            /** 返回码 1表示成功，其他表示出错 */
            error_code: number;
            /** 活动主类型 */
            base_type: number;
            /** 活动子类型 */
            sub_type: number;
            /** 总抽奖次数 */
            all_times: number;
            /** 免费次数 */
            free_times: number;
            reward_list: {
                /** 奖励id */
                grade_id: number;
                /** 是否大奖 1: 是 0: 否 */
                is_rare: number;
                reward: any;
            }[];
            /** 积分 */
            score: number;
        };
    };
    33192: {
        desc: "摇钱树累计奖励";
        send: (
            number: 33192,
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
        };
    };
    33193: {
        desc: "节日活跃";
        send: (
            number: 33193,
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
            /** 个人次数 */
            person_times: number;
            /** 全服次数 */
            server_times: number;
            ser_reward_list: {
                grade_id: number;
                /** 全服奖励触发类型 */
                trigger_type: number;
                /**  触发类型参数 */
                param: string;
                /** 奖励需要次数 */
                times: number;
                /** 奖励 */
                reward: any;
                /** 0: 未达成 1: 已达成未领取 2: 已领取 */
                status: number;
            }[];
        };
    };
    33194: {
        desc: "节日活跃提交";
        send: (
            number: 33194,
            fmt: "hhc",
            args: [
                /**活动主类型*/
                base_type: number,
                /**活动子类型*/
                sub_type: number,
                /**消耗类型1:钻石 2:物品*/
                cost_type: number
            ]
        ) => never;
        sendFmt: "hhc";
        sendArgs: [
            /**活动主类型*/
            base_type: number,
            /**活动子类型*/
            sub_type: number,
            /**消耗类型1:钻石 2:物品*/
            cost_type: number
        ];
        recv: {
            /** 返回码 */
            error_code: number;
            /** 活动主类型 */
            base_type: number;
            /** 活动子类型 */
            sub_type: number;
            /** 消耗类型1:钻石 2:物品 */
            cost_type: number;
            reward_list: {
                /** 奖励id */
                grade_id: number;
                /** 是否大奖 1: 是 0: 否 */
                is_rare: number;
                reward: any;
            }[];
            /** 个人次数 */
            person_times: number;
        };
    };
    33195: {
        desc: "节日活跃领取";
        send: (
            number: 33195,
            fmt: "hhh",
            args: [
                /**活动主类型*/
                base_type: number,
                /**活动子类型*/
                sub_type: number,
                grade_id: number
            ]
        ) => never;
        sendFmt: "hhh";
        sendArgs: [
            /**活动主类型*/
            base_type: number,
            /**活动子类型*/
            sub_type: number,
            grade_id: number
        ];
        recv: {
            /** 返回码 */
            error_code: number;
            /** 活动主类型 */
            base_type: number;
            /** 活动子类型 */
            sub_type: number;
            grade_id: number;
            reward: any;
        };
    };
    33196: {
        desc: "节日活跃全服次数广播";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 活动主类型 */
            base_type: number;
            /** 活动子类型 */
            sub_type: number;
            /** 全服次数 */
            server_times: number;
            /** 是否需要请求数据 */
            is_ask: number;
            /** 触发类型列表 */
            trigger_type_list: {
                trigger_type: number;
            }[];
        };
    };
    33197: {
        desc: "记录";
        send: (
            number: 33197,
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
            /** 日志列表（全服记录） */
            log_list: {
                role_id: number;
                name: string;
                reward_list: any;
            }[];
            /** 日志列表（个人记录） */
            self_list: {
                role_id: number;
                name: string;
                reward_list: any;
            }[];
        };
    };
    33198: {
        desc: "摇摇乐日志";
        send: (
            number: 33198,
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
            errcode: number;
            /** 活动主类型 */
            base_type: number;
            /** 活动子类型 */
            sub_type: number;
            list: {
                /** 玩家id */
                role_id: number;
                /**  玩家名字 */
                role_name: string;
                /** 物品类型id */
                goods_id: number;
                /** 物品数量 */
                num: number;
                /** 时间 */
                time: number;
            }[];
        };
    };
    33199: {
        desc: "新增摇摇乐日志";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            list: {
                /** 玩家id */
                role_id: number;
                /**  玩家名字 */
                role_name: string;
                /** 物品类型id */
                goods_id: number;
                /** 物品数量 */
                num: number;
                /** 时间 */
                time: number;
            }[];
        };
    };
}

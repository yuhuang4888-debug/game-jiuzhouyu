/** 星钻联赛
 */
declare interface ProtoFmtInfo {
    60400: {
        desc: "错误码";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            errcode: number;
            /**  参数 */
            errargs: string;
        };
    };
    60401: {
        desc: "概要信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 阶段 */
            stage: number;
            /** 阶段结束时间戳 */
            end_time: number;
        };
    };
    60402: {
        desc: "报名信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 我的历史最高战力 */
            my_power: number;
            /** 入选最小战力 0为暂无 */
            min_power: number;
        };
    };
    60403: {
        desc: "报名";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 是否报名 0 未报名，> 0 已报名 */
            is_apply: number;
            /** 我的历史最高战力 */
            my_power: number;
            /** 入选最小战力 0为暂无 */
            min_power: number;
        };
    };
    60404: {
        desc: "我的活动信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 已经举行过几届 */
            cycle_index: number;
            /** 是否报名 0 未报名，> 0 已报名 */
            is_apply: number;
            /** 是否落选 1 落选 0没有落选 */
            is_lost: number;
            /** 我达到的轮次，可以算出获得绑钻数量 */
            my_round: number;
        };
    };
    60405: {
        desc: "入场";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: null;
    };
    60406: {
        desc: "战况信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 阶段 同60401的stage */
            stage: number;
            /** 当前第几轮 */
            round_index: number;
            /** 状态 0未结算 1胜利 2落选 */
            win: number;
            /** 我达到的轮次 胜场数 = 如果win>0 my_round  否则 my_round-1 */
            my_round: number;
            /** 剩余生命 */
            life_num: number;
        };
    };
    60407: {
        desc: "战场信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            life_info: {
                role_id: number;
                life_num: number;
            }[];
        };
    };
    60408: {
        desc: "辅助技能列表";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            skill_list: {
                /** 技能id */
                skill_id: number;
                /** 使用价格 */
                next_price: number;
                /** 使用时间 减去当前时间即为冷却时间 */
                next_used_time: number;
            }[];
        };
    };
    60409: {
        desc: "结算";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 1赢 0输 */
            res: number;
            /** 我达到的轮次 */
            my_round: number;
            /** 结算原因 1正常结算 2败方没有入场 3没有对手 4对手中途离场 5对手迟到30秒内还没切完场景 */
            reason: number;
        };
    };
    60410: {
        desc: "退出";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: null;
    };
    60411: {
        desc: "购买生命";
        send: (number: 60411, fmt: "c", args: [buy_num: number]) => never;
        sendFmt: "c";
        sendArgs: [buy_num: number];
        recv: {
            life_num: number;
        };
    };
    60412: {
        desc: "王者榜单";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            cur_round: number;
            round_list: {
                round: number;
                pair_list: {
                    role_id_1: number;
                    name_1: string;
                    server_name_1: string;
                    power_1: number;
                    sex_1: number;
                    career_1: number;
                    turn_1: number;
                    pic_1: string;
                    picvsn_1: number;
                    role_id_2: number;
                    name_2: string;
                    server_name_2: string;
                    power_2: number;
                    sex_2: number;
                    career_2: number;
                    turn_2: number;
                    pic_2: string;
                    picvsn_2: number;
                }[];
            }[];
        };
    };
    60413: {
        desc: "购买技能";
        send: (number: 60413, fmt: "i", args: [skill_id: number]) => never;
        sendFmt: "i";
        sendArgs: [skill_id: number];
        recv: {
            skill_id: number;
            next_price: number;
            next_used_time: number;
        };
    };
    60414: {
        desc: "通知玩家使用技能";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            role_name: string;
            skill_id: number;
        };
    };
    60415: {
        desc: "阶段信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            stage: number;
            end_time: number;
        };
    };
    60416: {
        desc: "本轮已晋级选手";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            role_list: {
                role_name: string;
                server_name: string;
            }[];
        };
    };
    60417: {
        desc: "往届信息";
        send: (number: 60417, fmt: "h", args: [cycle_index: number]) => never;
        sendFmt: "h";
        sendArgs: [cycle_index: number];
        recv: {
            cycle_index: number;
            winner_id: number;
            winner_name: string;
            winner_server_name: string;
            winner_power: number;
            winner_career: number;
            winner_sex: number;
            winner_turn: number;
            winner_pic: string;
            winner_pic_ver: number;
            winner_lv_model: {
                part_pos: number;
                level_model_id: number;
            }[];
            winner_fashion: {
                part_pos: number;
                fashion_model_id: number;
                color: number;
            }[];
            god_weapon_model: {
                part_pos: number;
                godweapon_id: number;
            }[];
            wing_figure: number;
            role_list: {
                role_name: string;
                server_name: string;
                guild_name: string;
            }[];
        };
    };
    60418: {
        desc: "当前轮次更新";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            cur_round: number;
        };
    };
    60419: {
        desc: "报名名单";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            apply_list: {
                role_id: number;
                role_name: string;
                server_name: string;
                guild_name: string;
                lv: number;
                power: number;
            }[];
        };
    };
    60420: {
        desc: "当前阶段竞猜列表";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 轮次 */
            round: number;
            /** 需要猜中多少场算赢 */
            min_num: number;
            /** 价格类型 0为还没竞猜，价格类型可选 */
            price_id: number;
            /** 本轮竞猜结束时间 */
            end_time: number;
            guess_list: {
                /** 配对id */
                pair_id: number;
                /** 我选择的玩家 0为未选择 */
                role_id: number;
                /** 玩家id */
                id_1: number;
                /**  玩家名字 */
                name_1: string;
                server_name_1: string;
                sex_1: number;
                career_1: number;
                turn_1: number;
                pic_1: string;
                picvsn_1: number;
                power_1: number;
                /** 玩家id */
                id_2: number;
                /**  玩家名字 */
                name_2: string;
                server_name_2: string;
                sex_2: number;
                career_2: number;
                turn_2: number;
                pic_2: string;
                picvsn_2: number;
                power_2: number;
            }[];
        };
    };
    60421: {
        desc: "竞猜";
        send: (
            number: 60421,
            fmt: "cA",
            args: [
                /**竞猜档次 第一次竞猜发送档次（价格类型） 修改竞猜该字段被我忽略*/
                price_id: number,
                guess_list: any
            ]
        ) => never;
        sendFmt: "cA";
        sendArgs: [
            /**竞猜档次 第一次竞猜发送档次（价格类型） 修改竞猜该字段被我忽略*/
            price_id: number,
            guess_list: any
        ];
        recv: {
            /** 成功返回码 用来区别提示修改还是押注 如果是失败返回的是60400 */
            res: number;
            guess_list: {
                pair_id: number;
                role_id: number;
            }[];
        };
    };
    60422: {
        desc: "我的竞猜概况";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 是否可以领奖 1是0否 */
            has_award: number;
            /** 当前是否已经竞猜 0未竞猜 其它已竞猜 */
            has_guess: number;
        };
    };
    60423: {
        desc: "我的竞猜结果";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            guess_list: {
                /** 第几轮 */
                round: number;
                /** 价格类型 */
                price_id: number;
                /** 状态 0还未结算 1已经结算 2已领奖 */
                state: number;
                guest_items: {
                    /** 我竞猜的玩家id */
                    role_id: number;
                    /** 胜利的玩家id */
                    win_id: number;
                    sex: number;
                    career: number;
                    turn: number;
                    pic: string;
                    picvsn: number;
                }[];
                rewards: any;
            }[];
        };
    };
    60424: {
        desc: "竞猜领奖";
        send: (
            number: 60424,
            fmt: "c",
            args: [
                /**第几轮 0表示一键领奖 其它代表具体*/
                round: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**第几轮 0表示一键领奖 其它代表具体*/
            round: number
        ];
        recv: {
            round: number;
        };
    };
    60425: {
        desc: "观战";
        send: (
            number: 60425,
            fmt: "l",
            args: [
                /**想要观战的玩家id，两个id随便一个*/
                role_id: number
            ]
        ) => never;
        sendFmt: "l";
        sendArgs: [
            /**想要观战的玩家id，两个id随便一个*/
            role_id: number
        ];
        recv: null;
    };
    60426: {
        desc: "观战结果";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /**  胜者名字 */
            role_name: string;
        };
    };
    60427: {
        desc: "退出观战";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: null;
    };
    60428: {
        desc: "竞猜开始";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 竞猜结束时间 */
            end_time: number;
        };
    };
}

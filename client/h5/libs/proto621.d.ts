/** 跨服1vN
 */
declare interface ProtoFmtInfo {
    62100: {
        desc: "获取活动信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 玩家是否参与比赛(0否1是) */
            is_sign: number;
            /** 报名人数 */
            sign_num: number;
            /** 擂主人数 */
            def_num: number;
            /** 玩家所在战区 */
            zone: number;
        };
    };
    62101: {
        desc: "活动阶段切换广播";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 活动阶段(0空闲 1报名 2资格赛准备（可进入场景） 3资格赛, 4守擂赛准备 5守擂赛 6活动结束) */
            stage: number;
            /** 匹配轮次 */
            turn: number;
            /** 当前活动状态结束时间 */
            edtime: number;
            /** 每个活动阶段的子状态(0等待开启，1匹配，2竞猜，3战斗，4结束) */
            sub_stage: number;
            /** 当前子活动状态结束时间 */
            sub_edtime: number;
        };
    };
    62102: {
        desc: "报名";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            error_code: number;
        };
    };
    62103: {
        desc: "进入";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            error_code: number;
        };
    };
    62104: {
        desc: "资格赛等待场景信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 资格赛剩余次数 */
            left_times: number;
            /** 当期活动积分 */
            score: number;
            /** 下次匹配时间戳 */
            time: number;
            /** 胜利次数 */
            win: number;
            /** 失败次数 */
            lose: number;
            /** 累计经验 */
            exp_sum: number;
            /** 擂主数量 */
            def_num: number;
        };
    };
    62105: {
        desc: "资格赛对战开始信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            battle_list: {
                /** 玩家id */
                player_id: number;
                /**  平台标示 */
                platform: string;
                /** 玩家服数 */
                server_num: number;
                /**  玩家服 */
                server_name: string;
                /**  玩家名字 */
                name: string;
                /** 职业类型 */
                career: number;
                /** 战斗力 */
                combat_power: number;
                /** 胜利次数 */
                win: number;
                /** 失败次数 */
                lose: number;
                /** 性别 */
                sex: number;
                /**  头像url */
                picture: string;
                /** 头像版本号 */
                picture_ver: number;
                /** 等级 */
                lv: number;
            }[];
            /** loading截止时间戳 */
            loading_time: number;
            /** 战斗超时时间戳 */
            battle_time: number;
        };
    };
    62107: {
        desc: "退出对战场景";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            error_code: number;
        };
    };
    62108: {
        desc: "资格赛单场对战结果";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 胜负(0负，1胜) */
            result: number;
            /** 原始积分 */
            old_score: number;
            /** 本次增加积分 */
            add_score: number;
            /** 剩余匹配次数 */
            left_times: number;
            /** 是否超时 */
            is_timeout: number;
            battle_list: {
                /** 玩家id */
                player_id: number;
                /**  平台标示 */
                platform: string;
                /** 玩家服数 */
                server_num: number;
                /**  玩家名字 */
                name: string;
                /** 职业类型 */
                career: number;
                /** 性别 */
                sex: number;
                /**  头像url */
                picture: string;
                /** 头像版本号 */
                picture_ver: number;
                /** 等级 */
                lv: number;
                /** 血量 */
                hp: number;
                /** 血量上限 */
                hp_lim: number;
            }[];
        };
    };
    62109: {
        desc: "资格赛最后结算";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 是否擂主(0否|1是) */
            is_def: number;
            /** 我的排名 */
            rank: number;
            /** 积分 */
            score: number;
            award: any;
        };
    };
    62110: {
        desc: "资格赛积分排行榜";
        send: (
            number: 62110,
            fmt: "c",
            args: [
                /**0|1|2 0在场景里面请求*/
                area: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**0|1|2 0在场景里面请求*/
            area: number
        ];
        recv: {
            /** 1|2 */
            area: number;
            rank_1_list: {
                /** 排名 */
                rank: number;
                /** 玩家id */
                player_id: number;
                /**  平台标示 */
                platform: string;
                /** 玩家服数 */
                server_num: number;
                /**  玩家服 */
                server_name: string;
                /**  玩家名字 */
                name: string;
                /**  帮派名字 */
                gname: string;
                /** vip类型 */
                vip: number;
                /** 积分 */
                score: number;
                /** 胜利次数 */
                win: number;
                /** 失败次数 */
                lose: number;
                /** 战斗力 */
                combat_power: number;
                /** 职业 */
                career: number;
                /** 等级 */
                lv: number;
            }[];
        };
    };
    62111: {
        desc: "挑战赛等待场景信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 当期活动积分 */
            score: number;
            /** 累计经验 */
            exp_sum: number;
            /** 是否擂主(0否|1是) */
            is_def: number;
        };
    };
    62112: {
        desc: "挑战赛对战开始信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 擂主玩家id */
            player_id: number;
            /**  擂主玩家平台标示 */
            platform: string;
            /** 擂主玩家服数 */
            server_num: number;
            /**  擂主玩家服 */
            server_name: string;
            /**  擂主玩家名字 */
            name: string;
            /** 擂主职业类型 */
            career: number;
            /** 擂主战斗力 */
            combat_power: number;
            /** 擂主胜利次数 */
            win: number;
            /** 擂主失败次数 */
            lose: number;
            /** 擂主性别 */
            sex: number;
            /**  擂主头像url */
            picture: string;
            /** 擂主头像版本号 */
            picture_ver: number;
            /** 擂主等级 */
            lv: number;
            challenger_list: {
                /** 玩家id */
                player_id: number;
                /**  玩家平台标示 */
                platform: string;
                /** 玩家服数 */
                server_num: number;
                /**  玩家服 */
                server_name: string;
                /**  玩家名字 */
                name: string;
                /** 职业类型 */
                career: number;
                /** 转生数 */
                turn: number;
                /** 性别 */
                sex: number;
                /**  头像url */
                picture: string;
                /** 头像版本号 */
                picture_ver: number;
                /** 等级 */
                lv: number;
                /** 战斗力 */
                combat_power: number;
            }[];
            /** loading截止时间戳 */
            loading_time: number;
            /** 战斗超时时间戳 */
            battle_time: number;
        };
    };
    62113: {
        desc: "挑战赛单场对战结果";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 胜负(0负，1胜) */
            result: number;
            /** 挑战者数量 */
            challenger_num: number;
            /** 挑战者总数量 */
            total_challenger_num: number;
            /** 擂主id */
            role_id: number;
            /**  平台标示 */
            platform: string;
            /** 玩家服数 */
            server_num: number;
            /**  玩家名字 */
            name: string;
            /** 职业类型 */
            career: number;
            /** 性别 */
            sex: number;
            /**  头像url */
            picture: string;
            /** 头像版本号 */
            picture_ver: number;
            /** 等级 */
            lv: number;
            /** 血量 */
            hp: number;
            /** 血量上线 */
            hp_lim: number;
            award: any;
        };
    };
    62114: {
        desc: "挑战赛擂主排行榜(目前废弃)";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            rank_2_def_rank: {
                /** 排名 */
                rank: number;
                /** 玩家id */
                player_id: number;
                /**  平台标示 */
                platform: string;
                /** 玩家服数 */
                server_num: number;
                /**  玩家名字 */
                name: string;
                /**  帮派名字 */
                gname: string;
                /** vip类型 */
                vip: number;
                /** 积分 */
                score: number;
                /** 轮次 */
                turn: number;
                /** 是否已经失败(0否|1是) */
                lose: number;
                /** 战斗力 */
                combat_power: number;
                /** 存活时间 */
                survival_time: number;
                /** 等级 */
                lv: number;
            }[];
        };
    };
    62115: {
        desc: "挑战赛挑战者排行榜(目前废弃)";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            rank_2_score_rank: {
                /** 排名 */
                rank: number;
                /** 玩家id */
                player_id: number;
                /** 玩家服数 */
                server_num: number;
                /**  玩家名字 */
                name: string;
                /**  帮派名字 */
                gname: string;
                /** vip类型 */
                vip: number;
                /** 积分 */
                score: number;
                /** 战斗力 */
                combat_power: number;
                /** 职业 */
                career: number;
            }[];
        };
    };
    62116: {
        desc: "挑战赛擂主排行榜（结束后）";
        send: (
            number: 62116,
            fmt: "c",
            args: [
                /**0|1|2 0在场景里面请求*/
                area: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**0|1|2 0在场景里面请求*/
            area: number
        ];
        recv: {
            /** 1|2 */
            area: number;
            rank_2_def_rank: {
                /** 排名 */
                rank: number;
                /** 服唯一id */
                server_id: number;
                /** 玩家id */
                player_id: number;
                /**  平台标示 */
                platform: string;
                /** 玩家服数 */
                server_num: number;
                /**  玩家服 */
                server_name: string;
                /**  玩家名字 */
                name: string;
                /**  帮派名字 */
                gname: string;
                /** vip类型 */
                vip: number;
                /** 积分 */
                score: number;
                /** 轮次 */
                turn: number;
                /** 战斗力 */
                combat_power: number;
                /** 职业 */
                career: number;
                /** 存活时间 */
                survival_time: number;
                /** 是否已经失败(0否|1是) */
                lose: number;
                /** 等级 */
                lv: number;
                /** 血量 */
                hp: number;
                /** 血量上线 */
                hp_lim: number;
            }[];
            daily_award: any;
        };
    };
    62117: {
        desc: "挑战赛竞猜列表(战斗信息列表)";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            bet_list: {
                /** 战斗场次id */
                battle_id: number;
                /** 状态(0可竞猜,1战斗中,2结束) */
                status: number;
                /** 擂主id */
                player_id: number;
                /**  平台标示 */
                platform: string;
                /** 玩家服数 */
                server_num: number;
                /**  擂主服 */
                server_name: string;
                /**  擂主名字 */
                name: string;
                /** 擂主职业 */
                career: number;
                /** 擂主转生 */
                turn: number;
                /** 擂主性别 */
                sex: number;
                /** 等级 */
                lv: number;
                /**  头像url */
                picture: string;
                /** 头像版本号 */
                picture_ver: number;
                /** 擂主战斗力 */
                combat_power: number;
                challenger_list: {
                    /** 挑战者id */
                    player_id: number;
                    /**  平台标示 */
                    platform: string;
                    /** 玩家服数 */
                    server_num: number;
                    /**  挑战者服 */
                    server_name: string;
                    /**  挑战者名字 */
                    name: string;
                    /** 挑战者挑战者职业 */
                    career: number;
                    /** 挑战者转生 */
                    turn: number;
                    /** 挑战者性别 */
                    sex: number;
                    /** 等级 */
                    lv: number;
                    /**  挑战者头像url */
                    picture: string;
                    /** 挑战者头像版本号 */
                    picture_ver: number;
                    /** 挑战者战斗力 */
                    combat_power: number;
                }[];
                /** 0 未有结果 1 擂主胜 2 挑战者胜 */
                battle_result: number;
                /** 是否竞猜 */
                is_bet: number;
                /** 0 未有结果 1 猜错 2 猜对 */
                bet_result: number;
            }[];
            /** 剩余擂主数量 */
            def_num: number;
            /** 竞猜次数 */
            bet_num: number;
        };
    };
    62118: {
        desc: "挑战赛押注";
        send: (
            number: 62118,
            fmt: "hhcc",
            args: [
                /**匹配轮次*/
                turn: number,
                /**战斗场次id*/
                battle_id: number,
                /**押注选项*/
                opt_no: number,
                /**押注消耗类型##配置base_kf_1vn_bet中的竞猜消耗列表*/
                cost_type: number
            ]
        ) => never;
        sendFmt: "hhcc";
        sendArgs: [
            /**匹配轮次*/
            turn: number,
            /**战斗场次id*/
            battle_id: number,
            /**押注选项*/
            opt_no: number,
            /**押注消耗类型##配置base_kf_1vn_bet中的竞猜消耗列表*/
            cost_type: number
        ];
        recv: {
            /** 错误码 */
            error_code: number;
            /** 匹配轮次 */
            turn: number;
            /** 战斗场次id （客户端用于更新押注界面） */
            battle_id: number;
        };
    };
    62119: {
        desc: "资格赛等待场景信息广播信息，排名";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 我的排名 */
            rank: number;
            /**  擂主 */
            top_name: string;
        };
    };
    62120: {
        desc: "挑战赛结算";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 我的排名 */
            rank: number;
            /** 我的积分 */
            score: number;
            award: any;
            /** 自己最高轮次 */
            turn: number;
        };
    };
    62121: {
        desc: "挑战赛观战";
        send: (
            number: 62121,
            fmt: "h",
            args: [
                /**战斗场次id*/
                battle_id: number
            ]
        ) => never;
        sendFmt: "h";
        sendArgs: [
            /**战斗场次id*/
            battle_id: number
        ];
        recv: {
            /** 错误码 */
            error_code: number;
        };
    };
    62122: {
        desc: "累计经验更新";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 经验值 */
            exp_sum: number;
        };
    };
    62123: {
        desc: "挑战赛单场竞猜结果";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 战斗场次id */
            battle_id: number;
            /** 0 未有结果 1 擂主胜 2 挑战者胜 */
            battle_result: number;
            /** 0 未有结果 1 猜错 2 猜对 */
            bet_result: number;
        };
    };
    62124: {
        desc: "1vN拍卖信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            auction_list: {
                /** 拍卖配置id */
                auction_id: number;
                /** 0准备中 1拍卖中 2结束 */
                result: number;
                /** 最终成交价 */
                last_price: number;
                /** 我的竞拍价格 */
                my_price: number;
            }[];
            /** 结束时间戳 */
            edtime: number;
        };
    };
    62125: {
        desc: "1vN拍卖排行榜";
        send: (number: 62125, fmt: "h", args: [auction_id: number]) => never;
        sendFmt: "h";
        sendArgs: [auction_id: number];
        recv: {
            auction_id: number;
            auction_rank_list: {
                /** 玩家服数 */
                server_num: number;
                /**  玩家名字 */
                name: string;
                /** 竞拍价格 */
                price: number;
            }[];
        };
    };
    62126: {
        desc: "1vN拍卖-追加竞拍价格";
        send: (
            number: 62126,
            fmt: "hii",
            args: [
                /**拍卖配置id*/
                auction_id: number,
                /**消耗钻石*/
                price_add: number,
                /**使用代金券数量*/
                voucher_num: number
            ]
        ) => never;
        sendFmt: "hii";
        sendArgs: [
            /**拍卖配置id*/
            auction_id: number,
            /**消耗钻石*/
            price_add: number,
            /**使用代金券数量*/
            voucher_num: number
        ];
        recv: {
            /** 错误码 */
            error_code: number;
        };
    };
    62127: {
        desc: "1vN拍卖-关注拍卖窗口";
        send: (
            number: 62127,
            fmt: "c",
            args: [
                /**关注拍卖窗口(0取消|1关注)*/
                follow: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**关注拍卖窗口(0取消|1关注)*/
            follow: number
        ];
        recv: {
            /** 错误码 */
            error_code: number;
        };
    };
    62128: {
        desc: "1vN拍卖-关注拍卖往期记录";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            past_auction_list: {
                /** 第几期 */
                issue: number;
                /** 玩家服数 */
                server_num: number;
                /**  玩家名字 */
                name: string;
                award: any;
                /** 成交价 */
                price: number;
            }[];
        };
    };
    62129: {
        desc: "1vN拍卖-状态广播";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 状态(0关闭,1拍卖中) */
            stage: number;
            /** 本状态结束时间戳 */
            edtime: number;
        };
    };
    62130: {
        desc: "报名列表(前100)";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            sign_num: number;
            role_list: {
                role_id: number;
                role_name: string;
                server_name: string;
                power: number;
            }[];
            my_power: number;
        };
    };
    62131: {
        desc: "1vN我的身份";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 0 无 1擂主 2挑战者 */
            def_type: number;
            /** 第几轮 */
            turn: number;
        };
    };
    62132: {
        desc: "通用错误码提示";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            error_code: number;
            error_args: string;
        };
    };
    62133: {
        desc: "查看竞猜记录";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            bet_list: {
                /** 唯一键 */
                key: number;
                /**  平台标示 */
                platform: string;
                /** 玩家服数 */
                server_num: number;
                /**  擂主名字 */
                name: string;
                /** 轮次 */
                race_2_turn: number;
                /** 竞猜消耗类型 */
                bet_cost_type: number;
                /** 0 未有结果 1 猜错 2 猜对 */
                bet_result: number;
                /** 0 未有结果 1:已经领取 2:未领取 */
                status: number;
            }[];
        };
    };
    62134: {
        desc: "领取竞猜奖励";
        send: (
            number: 62134,
            fmt: "l",
            args: [
                /**唯一键*/
                key: number
            ]
        ) => never;
        sendFmt: "l";
        sendArgs: [
            /**唯一键*/
            key: number
        ];
        recv: {
            /** 唯一键 */
            key: number;
        };
    };
    62135: {
        desc: "挑战赛单场结果";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 战斗场次id */
            battle_id: number;
            /** 0 未有结果 1 擂主胜 2 挑战者胜 */
            battle_result: number;
        };
    };
    62136: {
        desc: "请求最强王者返回13013协议";
        send: (
            number: 62136,
            fmt: "c",
            args: [
                /**0|1|2 0在场景里面请求*/
                area: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**0|1|2 0在场景里面请求*/
            area: number
        ];
        recv: null;
    };
}

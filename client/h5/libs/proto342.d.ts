/** 竞猜
 */
declare interface ProtoFmtInfo {
    34200: {
        desc: "错误码展示";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            errcode: number;
        };
    };
    34201: {
        desc: "开启中的竞猜活动";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            lists: {
                /** 活动类型(1:世界杯) */
                type: number;
                /** 开启等级 */
                open_lv: number;
                /** 开始时间 */
                stime: number;
                /** 结束时间 */
                etime: number;
            }[];
        };
    };
    34202: {
        desc: "竞猜信息列表";
        send: (
            number: 34202,
            fmt: "c",
            args: [
                /**活动类型(1:世界杯)*/
                type: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**活动类型(1:世界杯)*/
            type: number
        ];
        recv: {
            lists: {
                /** 活动类型(1:世界杯) */
                type: number;
                /** 比赛类型 */
                subtype: number;
            }[];
        };
    };
    34203: {
        desc: "竞猜单场列表";
        send: (
            number: 34203,
            fmt: "cc",
            args: [
                /**比赛类型(1:世界杯)*/
                type: number,
                /**比赛类型*/
                subtype: number
            ]
        ) => never;
        sendFmt: "cc";
        sendArgs: [
            /**比赛类型(1:世界杯)*/
            type: number,
            /**比赛类型*/
            subtype: number
        ];
        recv: {
            /** 比赛类型(1:世界杯) */
            type: number;
            /** 比赛类型 */
            subtype: number;
            /** 开始时间 */
            stime: number;
            /** 结束时间 */
            etime: number;
            lists: {
                /** 配置id */
                id: number;
                /**  场次名称 */
                name: string;
                /** 比赛时间 */
                time: number;
                /**  A方名字 */
                aname: string;
                /** A方图标 */
                aicon: number;
                /**  B方名字 */
                bname: string;
                /** B方图标 */
                bicon: number;
                /** A方获胜赔率 百分比 */
                awin_odds: number;
                /** A方输赔率 百分比 */
                afail_odds: number;
                /** 平局赔率 */
                draw_odds: number;
                /** 0: 未下注 1: 已下注 */
                is_bet: number;
                /** 结果(A方) 0:无结果 1:胜利 2:失败 3:平局 */
                result: number;
                /**  结果描述 */
                result_desc: string;
                /** 状态(0:押注期间 1:等待开奖 2:可以领取 3:未中奖 4:已领取 5:被淘汰) */
                status: number;
            }[];
        };
    };
    34204: {
        desc: "竞猜单场购买信息";
        send: (
            number: 34204,
            fmt: "ccic",
            args: [
                /**比赛类型(1:世界杯)*/
                type: number,
                /**比赛类型*/
                subtype: number,
                /**配置id*/
                id: number,
                /**押注选择 1:A队胜利 2:A队失败 3:平局*/
                sel: number
            ]
        ) => never;
        sendFmt: "ccic";
        sendArgs: [
            /**比赛类型(1:世界杯)*/
            type: number,
            /**比赛类型*/
            subtype: number,
            /**配置id*/
            id: number,
            /**押注选择 1:A队胜利 2:A队失败 3:平局*/
            sel: number
        ];
        recv: {
            /** 比赛类型(1:世界杯) */
            type: number;
            /** 比赛类型 */
            subtype: number;
            /** 配置id */
            id: number;
            /**  A方名字 */
            aname: string;
            /** A方图标 */
            aicon: number;
            /**  B方名字 */
            bname: string;
            /** B方图标 */
            bicon: number;
            /** 押注次数 */
            times: number;
            /** 最大押注次数 */
            times_lim: number;
            /** 押注选择 1:A队胜利 2:A队失败 3:平局 */
            sel: number;
            /** A方获胜赔率 百分比 */
            odds: number;
        };
    };
    34205: {
        desc: "竞猜单场的押注购买";
        send: (
            number: 34205,
            fmt: "cciicc",
            args: [
                /**比赛类型(1:世界杯)*/
                type: number,
                /**比赛类型*/
                subtype: number,
                /**配置id*/
                id: number,
                /**押注次数*/
                times: number,
                /**押注选择 1:A队胜利 2:A队失败 3:平局*/
                sel: number,
                /**0: 不自动购买 1: 自动购买*/
                auto_buy: number
            ]
        ) => never;
        sendFmt: "cciicc";
        sendArgs: [
            /**比赛类型(1:世界杯)*/
            type: number,
            /**比赛类型*/
            subtype: number,
            /**配置id*/
            id: number,
            /**押注次数*/
            times: number,
            /**押注选择 1:A队胜利 2:A队失败 3:平局*/
            sel: number,
            /**0: 不自动购买 1: 自动购买*/
            auto_buy: number
        ];
        recv: {
            /** 返回码 */
            errcode: number;
            /** 比赛类型(1:世界杯) */
            type: number;
            /** 比赛类型 */
            subtype: number;
            /** 配置id */
            id: number;
            /** 押注次数 */
            times: number;
        };
    };
    34206: {
        desc: "竞猜冠军列表";
        send: (
            number: 34206,
            fmt: "c",
            args: [
                /**比赛类型(1:世界杯)*/
                type: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**比赛类型(1:世界杯)*/
            type: number
        ];
        recv: {
            /** 比赛类型(1:世界杯) */
            type: number;
            /** 开始时间 */
            stime: number;
            /** 结束时间 */
            etime: number;
            lists: {
                /** 配置id */
                id: number;
                /**  名称 */
                name: string;
                /** 图标 */
                icon: number;
                /** 赔率 百分比 */
                odds: number;
                /** 0: 未下注 1: 已下注 */
                is_bet: number;
                /** 结果 0: 未出结果 1: 胜利 2:被淘汰 */
                result: number;
                /** 状态(0:押注期间 1:等待开奖 2:可以领取 3:未中奖 4:已领取 5:被淘汰) */
                status: number;
                /** 投注人数 */
                person_num: number;
            }[];
        };
    };
    34207: {
        desc: "竞猜冠军购买信息";
        send: (
            number: 34207,
            fmt: "ci",
            args: [
                /**比赛类型(1:世界杯)*/
                type: number,
                /**配置id*/
                id: number
            ]
        ) => never;
        sendFmt: "ci";
        sendArgs: [
            /**比赛类型(1:世界杯)*/
            type: number,
            /**配置id*/
            id: number
        ];
        recv: {
            /** 比赛类型(1:世界杯) */
            type: number;
            /** 配置id */
            id: number;
            /**  名字 */
            name: string;
            /** 图标 */
            icon: number;
            /** 押注次数 */
            times: number;
            /** 最大押注次数 */
            times_lim: number;
            /** 赔率 百分比 */
            odds: number;
            /** 下注列表 */
            bet_list: {
                /** 赔率 百分比 */
                pre_odds: number;
                /** 次数 */
                pre_times: number;
            }[];
        };
    };
    34208: {
        desc: "竞猜冠军的押注购买";
        send: (
            number: 34208,
            fmt: "ciic",
            args: [
                /**比赛类型(1:世界杯)*/
                type: number,
                /**配置id*/
                id: number,
                /**押注次数*/
                times: number,
                /**0: 不自动购买 1: 自动购买*/
                auto_buy: number
            ]
        ) => never;
        sendFmt: "ciic";
        sendArgs: [
            /**比赛类型(1:世界杯)*/
            type: number,
            /**配置id*/
            id: number,
            /**押注次数*/
            times: number,
            /**0: 不自动购买 1: 自动购买*/
            auto_buy: number
        ];
        recv: {
            /** 返回码 */
            errcode: number;
            /** 比赛类型(1:世界杯) */
            type: number;
            /** 配置id */
            id: number;
            /** 押注次数 */
            times: number;
            /** 投注人数 */
            person_num: number;
        };
    };
    34209: {
        desc: "竞猜单场的领取";
        send: (
            number: 34209,
            fmt: "cci",
            args: [
                /**比赛类型(1:世界杯)*/
                type: number,
                /**比赛类型 见34202*/
                subtype: number,
                /**配置id*/
                id: number
            ]
        ) => never;
        sendFmt: "cci";
        sendArgs: [
            /**比赛类型(1:世界杯)*/
            type: number,
            /**比赛类型 见34202*/
            subtype: number,
            /**配置id*/
            id: number
        ];
        recv: {
            /** 返回码 */
            errcode: number;
            /** 比赛类型(1:世界杯) */
            type: number;
            /** 比赛类型 见34202 */
            subtype: number;
            /** 配置id */
            id: number;
        };
    };
    34210: {
        desc: "竞猜冠军的领取";
        send: (
            number: 34210,
            fmt: "ci",
            args: [
                /**比赛类型(1:世界杯)*/
                type: number,
                /**配置id*/
                id: number
            ]
        ) => never;
        sendFmt: "ci";
        sendArgs: [
            /**比赛类型(1:世界杯)*/
            type: number,
            /**配置id*/
            id: number
        ];
        recv: {
            /** 返回码 */
            errcode: number;
            /** 比赛类型(1:世界杯) */
            type: number;
            /** 配置id */
            id: number;
        };
    };
    34211: {
        desc: "数据重新加载";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            lists: {
                /** 活动类型(1:世界杯) */
                type: number;
                /** 开启等级 */
                open_lv: number;
                /** 开始时间 */
                stime: number;
                /** 结束时间 */
                etime: number;
            }[];
        };
    };
    34212: {
        desc: "竞猜记录";
        send: (
            number: 34212,
            fmt: "c",
            args: [
                /**比赛类型(1:世界杯)*/
                type: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**比赛类型(1:世界杯)*/
            type: number
        ];
        recv: {
            lists: {
                /** 1: 单场竞猜 2: 分组竞猜 */
                type: number;
                /**  名字 */
                cfg_name: string;
                /** 下注次数 */
                times: number;
                /** 赔率 */
                odds: number;
                /** 1:A队胜利 2:A队失败 3:平局 如果type是分组竞猜的表示是冠军竞猜 不用使用这个字段 */
                sel_result: number;
                /** 奖励数量 */
                reward_num: number;
                /** 时间 */
                time: number;
            }[];
        };
    };
}

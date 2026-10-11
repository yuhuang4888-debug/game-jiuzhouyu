/** 充值活动
 */
declare interface ProtoFmtInfo {
    15901: {
        desc: "查看福利卡";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            product_list: {
                /** 商品大类 */
                product_type: number;
                /** 商品子类 */
                product_subtype: number;
                /** 商品id */
                product_id: number;
                /** 0 未购买 1 购买未领取 2 已领取 */
                state: number;
                /** 剩余领取天数 */
                left_count: number;
            }[];
        };
    };
    15902: {
        desc: "领取福利卡福利";
        send: (
            number: 15902,
            fmt: "i",
            args: [
                /**商品id*/
                product_id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**商品id*/
            product_id: number
        ];
        recv: {
            /** 1成功 */
            errcode: number;
        };
    };
    15903: {
        desc: "查看成长基金";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            product_list: {
                /** 商品大类 */
                product_type: number;
                /** 商品子类 */
                product_subtype: number;
                /** 商品id */
                product_id: number;
                num_list: {
                    /** 目标序号 */
                    rank: number;
                    /** 0 未购买 1 购买未领取 2 已领取 */
                    state: number;
                }[];
            }[];
        };
    };
    15904: {
        desc: "领取成长基金福利";
        send: (
            number: 15904,
            fmt: "ii",
            args: [
                /**商品id*/
                product_id: number,
                /**序号*/
                rank: number
            ]
        ) => never;
        sendFmt: "ii";
        sendArgs: [
            /**商品id*/
            product_id: number,
            /**序号*/
            rank: number
        ];
        recv: {
            /** 1成功 */
            errcode: number;
        };
    };
    15905: {
        desc: "查看首充奖励状态";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            reward_list: {
                /** 状态：0未充值 1可领奖 2时间未到 3已领完 4已领取 5未达到开服时间 */
                open: number;
                /** 第几天的奖励 */
                index: number;
            }[];
            /** 商品id */
            product_id: number;
            /** 是否通知过 */
            is_notify: number;
        };
    };
    15906: {
        desc: "领取首充奖励";
        send: (
            number: 15906,
            fmt: "c",
            args: [
                /**第几天的奖励*/
                index: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**第几天的奖励*/
            index: number
        ];
        recv: {
            /** 返回码 */
            errcode: number;
            /** 第几天的奖励 */
            index: number;
        };
    };
    15907: {
        desc: "设置首充通知状态";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: null;
    };
    15908: {
        desc: "查看添加有礼充值状态";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 是否已充值触发金额 0 否 1 是 */
            is_buy: number;
        };
    };
    15951: {
        desc: "查看每日礼包状态";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            product: {
                /** 商品id */
                product_id: number;
                /** 0 未购买 1 购买未领取 2 已领取 */
                state: number;
            }[];
        };
    };
    15952: {
        desc: "购买每日礼包";
        send: (
            number: 15952,
            fmt: "i",
            args: [
                /**商品id*/
                product_id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**商品id*/
            product_id: number
        ];
        recv: {
            /** 1成功 */
            errcode: number;
        };
    };
    15953: {
        desc: "领取每日礼包";
        send: (
            number: 15953,
            fmt: "i",
            args: [
                /**商品id*/
                product_id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**商品id*/
            product_id: number
        ];
        recv: {
            /** 1成功 */
            errcode: number;
        };
    };
    15954: {
        desc: "商品信息";
        send: (number: 15954, fmt: "c", args: [product_type: number]) => never;
        sendFmt: "c";
        sendArgs: [product_type: number];
        recv: {
            product_list: {
                /** 商品id */
                product_id: number;
                /** 开始时间 */
                start_time: number;
                /** 结束时间 */
                end_time: number;
                /**                 周几开启 */
                week_time_list: string;
                /**                 每月第几天开启 */
                month_time_list: string;
                /** 开服开始天数 */
                open_begin: number;
                /** 开服结束天数 */
                open_end: number;
                /** 合服开始天数 */
                merge_begin: number;
                /** 合服结束天数 */
                merge_end: number;
                /**                其它条件 [] */
                condition: string;
            }[];
        };
    };
    15955: {
        desc: "当天累计充值信息";
        send: (number: 15955, fmt: "h", args: [sub_type: number]) => never;
        sendFmt: "h";
        sendArgs: [sub_type: number];
        recv: {
            sub_type: number;
            /** 当天充值额度 */
            num: number;
            reward_infos: {
                /** 每日累充奖励id */
                id: number;
                /** 领取状态 0未完成 1可领取 2已领取 */
                state: number;
                /** 当前进度 */
                val: number;
                /** 总进度 */
                max: number;
                /** 奖励内容 */
                reward_list: any;
                condition: string;
                /** 描述 */
                desc: string;
            }[];
        };
    };
    15956: {
        desc: "多天累计充值奖励";
        send: (number: 15956, fmt: "h", args: [sub_type: number]) => never;
        sendFmt: "h";
        sendArgs: [sub_type: number];
        recv: {
            sub_type: number;
            reward_list: {
                /** 配置id */
                id: number;
                /** 领取状态 0未完成 1可领取 2已领取 */
                state: number;
                /** 当前进度 */
                val: number;
                /** 总进度 */
                max: number;
                /** 领取条件 */
                gold_num: number;
                /** 奖励内容 */
                reward_list: any;
                condition: string;
                /** 描述 */
                desc: string;
            }[];
        };
    };
    15957: {
        desc: "从开始时间当天0点到目前的充值总额";
        send: (
            number: 15957,
            fmt: "hhi",
            args: [
                /**主类型*/
                type: number,
                /**子类型*/
                subtype: number,
                /**活动开启时间*/
                start_time: number
            ]
        ) => never;
        sendFmt: "hhi";
        sendArgs: [
            /**主类型*/
            type: number,
            /**子类型*/
            subtype: number,
            /**活动开启时间*/
            start_time: number
        ];
        recv: {
            /** 主类型 */
            type: number;
            /** 子类型 */
            subtype: number;
            /** 元宝数 */
            total_gold: number;
        };
    };
    15958: {
        desc: "查看充值活动的当前充值数";
        send: (
            number: 15958,
            fmt: "hh",
            args: [
                /**主类型*/
                type: number,
                /**子类型*/
                subtype: number
            ]
        ) => never;
        sendFmt: "hh";
        sendArgs: [
            /**主类型*/
            type: number,
            /**子类型*/
            subtype: number
        ];
        recv: {
            /** 主类型 */
            type: number;
            /** 子类型 */
            subtype: number;
            /** 元宝数 */
            total_gold: number;
        };
    };
    15959: {
        desc: "当天充值数额";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 元宝数 */
            total_gold: number;
        };
    };
    15960: {
        desc: "几天前的充值金额";
        send: (
            number: 15960,
            fmt: "h",
            args: [
                /**几天前*/
                day: number
            ]
        ) => never;
        sendFmt: "h";
        sendArgs: [
            /**几天前*/
            day: number
        ];
        recv: {
            lists: {
                /** 当天0点 */
                time: number;
                /** 元宝数 */
                total_gold: number;
            }[];
        };
    };
}

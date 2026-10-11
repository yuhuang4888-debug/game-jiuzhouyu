/** 寻宝
 */
declare interface ProtoFmtInfo {
    41600: {
        desc: "错误码展示";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            errcode: number;
        };
    };
    41601: {
        desc: "寻宝界面";
        send: (
            number: 41601,
            fmt: "c",
            args: [
                /**寻宝类型 1: 装备寻宝 2: 巅峰寻宝 3: 至尊寻宝  4:符文寻宝*/
                type: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**寻宝类型 1: 装备寻宝 2: 巅峰寻宝 3: 至尊寻宝  4:符文寻宝*/
            type: number
        ];
        recv: {
            /** 当前抽奖次数 、 */
            draw_tiems: number;
            /** 轮次 */
            turn: number;
            stage_reward_list: {
                /** 阶段 */
                stage: number;
                /** 0:不可领取， 1：可领取 ， 2：已领取 */
                status: number;
            }[];
            /** 阶段奖励重置时间戳 */
            stage_reflush_time: number;
            /** 下次免费时间戳 */
            rune_free_time: number;
        };
    };
    41602: {
        desc: "寻宝记录";
        send: (
            number: 41602,
            fmt: "cc",
            args: [
                /**1: 全服 2: 个人*/
                rtype: number,
                /**寻宝类型 1: 装备寻宝 2: 巅峰寻宝 3: 至尊寻宝*/
                htype: number
            ]
        ) => never;
        sendFmt: "cc";
        sendArgs: [
            /**1: 全服 2: 个人*/
            rtype: number,
            /**寻宝类型 1: 装备寻宝 2: 巅峰寻宝 3: 至尊寻宝*/
            htype: number
        ];
        recv: {
            /** 1: 全服 2: 个人 */
            rtype: number;
            list: {
                /** 玩家id */
                role_id: number;
                /**  玩家名字 */
                role_name: string;
                /** 寻宝类型 1: 装备寻宝 2: 巅峰寻宝 3: 至尊寻宝 */
                type: number;
                /** 物品类型id */
                gtyp_id: number;
                /** 物品数量 */
                goods_num: number;
                /** 时间 */
                time: number;
                /** 是否稀有 0否 1是 */
                is_rare: number;
            }[];
        };
    };
    41603: {
        desc: "新增寻宝记录";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 1: 全服 2: 个人 */
            rtype: number;
            /** 玩家id */
            role_id: number;
            list: {
                /** 玩家id */
                role_id: number;
                /**  玩家名字 */
                role_name: string;
                /** 寻宝类型 1: 装备寻宝 2: 巅峰寻宝 3: 至尊寻宝 */
                type: number;
                /** 物品类型id */
                gtyp_id: number;
                /** 物品数量 */
                goods_num: number;
                /** 时间 */
                time: number;
                /** 是否稀有 0否 1是 */
                is_rare: number;
            }[];
        };
    };
    41604: {
        desc: "寻宝";
        send: (
            number: 41604,
            fmt: "ccc",
            args: [
                /**寻宝类型 1: 装备寻宝 2: 巅峰寻宝 3: 至尊寻宝， 4符文寻宝*/
                type: number,
                /**次数 只能发1和10，50*/
                times: number,
                /**自动购买寻宝令 0: 不自动购买 1: 自动购买，  先传*/
                auto_buy: number
            ]
        ) => never;
        sendFmt: "ccc";
        sendArgs: [
            /**寻宝类型 1: 装备寻宝 2: 巅峰寻宝 3: 至尊寻宝， 4符文寻宝*/
            type: number,
            /**次数 只能发1和10，50*/
            times: number,
            /**自动购买寻宝令 0: 不自动购买 1: 自动购买，  先传*/
            auto_buy: number
        ];
        recv: {
            /** 返回码 */
            res: number;
            /** 寻宝类型 1: 装备寻宝 2: 巅峰寻宝 3: 至尊寻宝， 4符文寻宝 */
            type: number;
            /** 次数 */
            times: number;
            /** 碎片数量 */
            chip_num: number;
            reward_list: {
                /** 物品唯一id */
                goods_id: number;
                /** 物品类型id */
                gtyp_id: number;
                /** 物品数量 */
                goods_num: number;
                /** 是否稀有 */
                is_rare: number;
            }[];
        };
    };
    41605: {
        desc: "取出";
        send: (
            number: 41605,
            fmt: "lhh",
            args: [
                /**物品唯一id*/
                goods_id: number,
                /**从哪里移*/
                from_pos: number,
                /**移到哪里*/
                to_pos: number
            ]
        ) => never;
        sendFmt: "lhh";
        sendArgs: [
            /**物品唯一id*/
            goods_id: number,
            /**从哪里移*/
            from_pos: number,
            /**移到哪里*/
            to_pos: number
        ];
        recv: {
            /** 错误码 */
            errcode: number;
            /** 物品数量 */
            goods_num: number;
            /** 物品类型id */
            gtyp_id: number;
        };
    };
    41606: {
        desc: "一键取出";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            errcode: number;
            good_ids: {
                /** 物品数量 */
                goods_num: number;
                /** 物品类型id */
                gtyp_id: number;
            }[];
        };
    };
    41607: {
        desc: "符文寻宝阶段奖励";
        send: (
            number: 41607,
            fmt: "h",
            args: [
                /**阶段*/
                stage: number
            ]
        ) => never;
        sendFmt: "h";
        sendArgs: [
            /**阶段*/
            stage: number
        ];
        recv: {
            /** 奖励列表 */
            rewards: any;
        };
    };
    41608: {
        desc: "装备寻宝界面";
        send: (
            number: 41608,
            fmt: "cc",
            args: [
                /**寻宝类型 1: 装备寻宝 2: 巅峰寻宝 3: 至尊寻宝*/
                htype: number,
                /**1: 全服 2: 个人(策划说默认为1)*/
                rtype: number
            ]
        ) => never;
        sendFmt: "cc";
        sendArgs: [
            /**寻宝类型 1: 装备寻宝 2: 巅峰寻宝 3: 至尊寻宝*/
            htype: number,
            /**1: 全服 2: 个人(策划说默认为1)*/
            rtype: number
        ];
        recv: {
            /** 寻宝积分 */
            score: number;
            /** 寻宝类型 */
            htype: number;
            /** 是否抽中过神兵 0否1是 */
            draw_weapon: number;
            /** 1: 全服 2: 个人 */
            rtype: number;
            /** 免费次数 1表示有免费抽奖次数，0表示当前无免费抽奖次数 */
            freetimes: number;
            /** 下次免费时间戳 有抽奖次数时该值为0 */
            free_time: number;
            list: {
                /** 玩家id */
                role_id: number;
                /**  玩家名字 */
                role_name: string;
                /** 寻宝类型 1: 装备寻宝 2: 巅峰寻宝 3: 至尊寻宝 */
                type: number;
                /** 物品类型id */
                gtyp_id: number;
                /** 物品数量 */
                goods_num: number;
                /** 时间 */
                time: number;
                /** 是否稀有 0否 1是 */
                is_rare: number;
            }[];
        };
    };
    41609: {
        desc: "积分兑换";
        send: (
            number: 41609,
            fmt: "i",
            args: [
                /**商城奖励id*/
                id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**商城奖励id*/
            id: number
        ];
        recv: {
            /** 错误码  1表示兑换成功，其他表失败 */
            code: number;
            /** 寻宝积分 */
            score: number;
        };
    };
    41610: {
        desc: "幸运值";
        send: (
            number: 41610,
            fmt: "c",
            args: [
                /**寻宝类型 1: 装备寻宝 2: 巅峰寻宝 3: 至尊寻宝*/
                htype: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**寻宝类型 1: 装备寻宝 2: 巅峰寻宝 3: 至尊寻宝*/
            htype: number
        ];
        recv: {
            /** 寻宝类型 1: 装备寻宝 2: 巅峰寻宝 3: 至尊寻宝 */
            htype: number;
            /** 幸运值 */
            luckey_value: number;
            /** 稀有物品获取提升概率 eg:200%, 这个协议传的是200 */
            percent: number;
        };
    };
    41611: {
        desc: "第一次寻宝";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 第一次装备寻宝才会收到该协议 默认发1 */
            code: number;
        };
    };
    41612: {
        desc: "跨服抽奖记录";
        send: (
            number: 41612,
            fmt: "c",
            args: [
                /**寻宝类型 1: 装备寻宝 2: 巅峰寻宝 3: 至尊寻宝*/
                htype: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**寻宝类型 1: 装备寻宝 2: 巅峰寻宝 3: 至尊寻宝*/
            htype: number
        ];
        recv: {
            /** 寻宝类型 具体参考：TREASURE_HUNT_TYPE */
            htype: number;
            list: {
                /** 服务器id */
                server_id: number;
                /** 服数 */
                server_num: number;
                /** 玩家id */
                role_id: number;
                /**  玩家名字 */
                role_name: string;
                /** 寻宝类型 1: 装备寻宝 2: 巅峰寻宝 3: 至尊寻宝 */
                type: number;
                /** 物品类型id */
                gtyp_id: number;
                /** 物品数量 */
                goods_num: number;
                /** 时间 */
                time: number;
                /** 是否稀有 */
                is_rare: number;
            }[];
        };
    };
    41613: {
        desc: "是否打开过神兵自选界面";
        send: (
            number: 41613,
            fmt: "c",
            args: [
                /**寻宝类型*/
                htype: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**寻宝类型*/
            htype: number
        ];
        recv: {
            /** 寻宝类型 */
            htype: number;
            /** 0没有打开 1打开过 */
            open: number;
        };
    };
    41614: {
        desc: "打开神兵自选界面后客户端返回";
        send: (
            number: 41614,
            fmt: "c",
            args: [
                /**寻宝类型*/
                htype: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**寻宝类型*/
            htype: number
        ];
        recv: null;
    };
    41615: {
        desc: "抽中宝物分类240后全服主动推一次";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 寻宝类型 */
            htype: number;
        };
    };
    41620: {
        desc: "寻宝任务";
        send: (
            number: 41620,
            fmt: "c",
            args: [
                /**寻宝类型*/
                htype: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**寻宝类型*/
            htype: number
        ];
        recv: {
            code: number;
            /** 寻宝类型 */
            htype: number;
            task_list: {
                task_id: number;
                /** 完成数量 */
                num: number;
                /** 完成状态 0 未完成 1未领取 2已领取 */
                state: number;
            }[];
        };
    };
    41621: {
        desc: "寻宝任务更新";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 寻宝类型 */
            htype: number;
            task_list: {
                task_id: number;
                /** 完成数量 */
                num: number;
                /** 完成状态 0 未完成 1未领取 2已领取 */
                state: number;
            }[];
        };
    };
    41622: {
        desc: "领取寻宝任务奖励";
        send: (
            number: 41622,
            fmt: "ci",
            args: [
                /**寻宝类型*/
                htype: number,
                task_id: number
            ]
        ) => never;
        sendFmt: "ci";
        sendArgs: [
            /**寻宝类型*/
            htype: number,
            task_id: number
        ];
        recv: {
            code: number;
            /** 寻宝类型 */
            htype: number;
            task_id: number;
            /** 完成数量 */
            num: number;
            /** 完成状态 0 未完成 1未领取 2已领取 */
            state: number;
            rewards: any;
        };
    };
}

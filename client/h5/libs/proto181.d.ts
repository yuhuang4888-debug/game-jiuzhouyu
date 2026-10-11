/** 龙纹信息
 */
declare interface ProtoFmtInfo {
    18100: {
        desc: "获取龙纹信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 基础属性列表 */
            attr_list: {
                attr_id: number;
                attr_value: number;
            }[];
            /** 槽位列表 */
            pos_list: {
                /** 槽位 */
                pos: number;
                /** 等级 */
                lv: number;
                /** 下一级的战力加成 */
                next_power: number;
            }[];
            /** 战力 */
            combat_power: number;
        };
    };
    18101: {
        desc: "龙纹升级";
        send: (
            number: 18101,
            fmt: "l",
            args: [
                /**装备物品Id*/
                goods_id: number
            ]
        ) => never;
        sendFmt: "l";
        sendArgs: [
            /**装备物品Id*/
            goods_id: number
        ];
        recv: {
            /** 错误码 */
            error_code: number;
            /** 装备物品Id */
            goods_id: number;
            /** 等级 */
            lv: number;
        };
    };
    18102: {
        desc: "穿戴龙纹装备";
        send: (
            number: 18102,
            fmt: "lc",
            args: [
                /**装备物品Id*/
                goods_id: number,
                /**装备格子位置*/
                cell_pos: number
            ]
        ) => never;
        sendFmt: "lc";
        sendArgs: [
            /**装备物品Id*/
            goods_id: number,
            /**装备格子位置*/
            cell_pos: number
        ];
        recv: {
            /** 返回码 */
            error_code: number;
            /** 装备物品Id */
            goods_id: number;
            /** 装备格子位置 */
            cell_pos: number;
        };
    };
    18103: {
        desc: "卸下龙纹装备";
        send: (
            number: 18103,
            fmt: "l",
            args: [
                /**装备物品Id*/
                goods_id: number
            ]
        ) => never;
        sendFmt: "l";
        sendArgs: [
            /**装备物品Id*/
            goods_id: number
        ];
        recv: {
            /** 返回码 */
            error_code: number;
            /** 装备物品Id */
            goods_id: number;
            /** 背包格子位置，失败为0 */
            cell: number;
        };
    };
    18104: {
        desc: "龙纹一键分解";
        send: (number: 18104, fmt: any, args: [goods_id_list: any]) => never;
        sendFmt: any;
        sendArgs: [goods_id_list: any];
        recv: {
            /** 返回码 */
            error_code: number;
            decompose_list: any;
        };
    };
    18105: {
        desc: "熔炉信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 熔炉id */
            crucible_id: number;
            /** 开始时间 */
            start_time: number;
            /** 结束时间 */
            end_time: number;
            /** 本时间内的次数 */
            count: number;
            /** 召唤奖励状态 */
            status_list: {
                /** 次数 */
                count: number;
                /** 领取状态##0:未达到,1:可领取,2:已经领取 */
                status: number;
            }[];
            /** 免费次数 */
            free_times: number;
            /** 下次免费次数增加时间 */
            next_free_time: number;
        };
    };
    18106: {
        desc: "熔炉召唤";
        send: (
            number: 18106,
            fmt: "cc",
            args: [
                /**次数*/
                count: number,
                /**是否自动购买 0否 1是*/
                autobuy: number
            ]
        ) => never;
        sendFmt: "cc";
        sendArgs: [
            /**次数*/
            count: number,
            /**是否自动购买 0否 1是*/
            autobuy: number
        ];
        recv: {
            /** 返回码 */
            error_code: number;
            /** 次数 */
            count: number;
            reward_list: any;
        };
    };
    18107: {
        desc: "熔炉召唤奖励领取";
        send: (
            number: 18107,
            fmt: "i",
            args: [
                /**次数*/
                count: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**次数*/
            count: number
        ];
        recv: {
            /** 返回码 */
            error_code: number;
            /** 次数 */
            count: number;
            reward_list: any;
        };
    };
    18108: {
        desc: "熔炉槽位升级";
        send: (
            number: 18108,
            fmt: "c",
            args: [
                /**槽位*/
                pos: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**槽位*/
            pos: number
        ];
        recv: {
            /** 返回码 */
            error_code: number;
            /** 槽位 */
            pos: number;
            /** 槽位等级 */
            lv: number;
        };
    };
    18109: {
        desc: "龙纹槽位降级";
        send: (
            number: 18109,
            fmt: "c",
            args: [
                /**槽位*/
                pos: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**槽位*/
            pos: number
        ];
        recv: {
            /** 返回码 */
            error_code: number;
            /** 槽位 */
            pos: number;
            /** 槽位等级 */
            lv: number;
        };
    };
    18110: {
        desc: "龙纹槽位重置";
        send: (
            number: 18110,
            fmt: "c",
            args: [
                /**槽位*/
                pos: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**槽位*/
            pos: number
        ];
        recv: {
            /** 返回码 */
            error_code: number;
            /** 槽位 */
            pos: number;
            /** 槽位等级 */
            lv: number;
        };
    };
    18111: {
        desc: "龙纹槽位信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 共鸣的战力 */
            combat_power: number;
        };
    };
    18112: {
        desc: "龙纹熔炉开启时间信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 熔炉id */
            crucible_id: number;
            /** 开始时间 */
            start_time: number;
        };
    };
    18113: {
        desc: "龙纹战力";
        send: (
            number: 18113,
            fmt: "lh",
            args: [
                /**物品id*/
                goods_id: number,
                /**背包类型*/
                location: number
            ]
        ) => never;
        sendFmt: "lh";
        sendArgs: [
            /**物品id*/
            goods_id: number,
            /**背包类型*/
            location: number
        ];
        recv: {
            /** 背包类型 */
            location: number;
            goods_list: {
                /** 物品Id */
                goods_id: number;
                /** 物品类型Id */
                type_id: number;
                /** 物品子位置(神器背包(8)：1(神器保护箱); 灵器库(13): sub_pos等于库id) */
                sub_pos: number;
                /** 物品所在格数 */
                cell: number;
                /** 物品数量 */
                goods_num: number;
                /** 物品绑定状态 */
                bind: number;
                /** 物品交易状态 */
                trade: number;
                /** 物品出售状态 */
                sell: number;
                /** 物品销毁状态 */
                is_drop: number;
                /** 颜色 */
                color: number;
                /** 过期时间戳 */
                expire_time: number;
                /** 战力 */
                combat_power: number;
                /** 强化等级 */
                stren: number;
                /** 物品等级 */
                level: number;
                /** 装备评分 */
                rating: number;
                /** 装备综合评分 */
                overall_rating: number;
                /** 附加属性 */
                addition_attrlist: {
                    /** 属性类型 */
                    attr_type: number;
                    /** 属性值 */
                    attr_value: number;
                    /** 属性颜色 */
                    color: number;
                    /** 战力 */
                    combat_power: number;
                }[];
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
                /** 坐骑装备阶数 */
                equipStage: number;
                /** 坐骑装备星数 */
                equipStar: number;
                /** 技能id */
                skill_id: number;
                skill_lv: number;
                /** 属性觉醒 */
                awake_list: {
                    /** 属性类型 */
                    attr_type: number;
                    /** 觉醒等级 */
                    awake_lv: number;
                }[];
                /** 下一级的战力加成 */
                next_power: number;
            }[];
        };
    };
}

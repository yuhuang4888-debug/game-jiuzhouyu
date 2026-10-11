/** 公会仓库
 */
declare interface ProtoFmtInfo {
    40100: {
        desc: "错误码展示";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            error_code: number;
        };
    };
    40101: {
        desc: "仓库界面";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 仓库积分 */
            depot_score: number;
            exchange_records: {
                /** 记录id 这个自增id不存数据库用32位就行(客户端根据这个id排序) */
                id: number;
                /**  兑换的玩家名字 */
                role_name: string;
                /** 1:捐献 2:兑换 3:销毁 */
                exchange_type: number;
                /** 物品唯一Id */
                goods_id: number;
                /** 物品类型Id */
                type_id: number;
                /** 颜色 */
                color: number;
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
                /** 附加属性(极品属性) */
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
                /** 宝石列表 */
                stone_list: {
                    /** 宝石孔位置 */
                    pos: number;
                    /** 物品类型Id */
                    type_id: number;
                }[];
                /** 洗炼属性 */
                wash_attr: {
                    /** 第几条 */
                    index: number;
                    /** 颜色 */
                    color: number;
                    /** 属性id */
                    attr_id: number;
                    /** 属性值 */
                    attr_val: number;
                }[];
                /** 套装等级 */
                suit_lv: number;
                /** 第几阶 */
                suit_slv: number;
                suit_count: number;
                /** 兑换时间 */
                time: number;
            }[];
            depot_goods: {
                /** 物品唯一Id */
                goods_id: number;
                /** 物品类型Id */
                type_id: number;
                /** 物品数量 */
                goods_num: number;
                /** 颜色 */
                color: number;
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
                /** 附加属性(极品属性) */
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
                /** 宝石列表 */
                stone_list: {
                    /** 宝石孔位置 */
                    pos: number;
                    /** 物品类型Id */
                    type_id: number;
                }[];
                /** 洗炼属性 */
                wash_attr: {
                    /** 第几条 */
                    index: number;
                    /** 颜色 */
                    color: number;
                    /** 属性id */
                    attr_id: number;
                    /** 属性值 */
                    attr_val: number;
                }[];
                /** 套装等级 */
                suit_lv: number;
                /** 第几阶 */
                suit_slv: number;
                suit_count: number;
            }[];
        };
    };
    40102: {
        desc: "捐赠";
        send: (number: 40102, fmt: any, args: [donate_list: any]) => never;
        sendFmt: any;
        sendArgs: [donate_list: any];
        recv: {
            /** 错误码 */
            error_code: number;
            /** 仓库积分 */
            depot_score: number;
        };
    };
    40103: {
        desc: "兑换";
        send: (
            number: 40103,
            fmt: "lii",
            args: [
                /**仓库物品唯一id*/
                goods_id: number,
                /**物品类型id*/
                type_id: number,
                /**数量*/
                num: number
            ]
        ) => never;
        sendFmt: "lii";
        sendArgs: [
            /**仓库物品唯一id*/
            goods_id: number,
            /**物品类型id*/
            type_id: number,
            /**数量*/
            num: number
        ];
        recv: {
            /** 错误码 */
            error_code: number;
            /** 仓库积分 */
            depot_score: number;
        };
    };
    40104: {
        desc: "销毁";
        send: (number: 40104, fmt: any, args: [depot_gids: any]) => never;
        sendFmt: any;
        sendArgs: [depot_gids: any];
        recv: {
            /** 错误码 */
            error_code: number;
            /** 销毁类型 3:手动销毁 4:自动销毁 (该类型沿用仓库操作类型) */
            op_type: number;
            /** 销毁数量 */
            depot_num: number;
        };
    };
    40105: {
        desc: "仓库物品更新(加新的物品)";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 只发送更新的物品 */
            depot_goods: {
                /** 物品唯一Id */
                goods_id: number;
                /** 物品类型Id */
                type_id: number;
                /** 物品数量 */
                goods_num: number;
                /** 颜色 */
                color: number;
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
                /** 附加属性(极品属性) */
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
                /** 宝石列表 */
                stone_list: {
                    /** 宝石孔位置 */
                    pos: number;
                    /** 物品类型Id */
                    type_id: number;
                }[];
                /** 洗炼属性 */
                wash_attr: {
                    /** 第几条 */
                    index: number;
                    /** 颜色 */
                    color: number;
                    /** 属性id */
                    attr_id: number;
                    /** 属性值 */
                    attr_val: number;
                }[];
                /** 套装等级 */
                suit_lv: number;
                /** 第几阶 */
                suit_slv: number;
                suit_count: number;
            }[];
        };
    };
    40106: {
        desc: "更新仓库物品数量(若物品数量为0,即是要删除的物品)";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            depot_goods: {
                /** 物品唯一Id */
                goods_id: number;
                /** 物品数量 */
                num: number;
            }[];
        };
    };
    40107: {
        desc: "仓库记录更新增加新的记录";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            exchange_records: {
                /** 记录id 这个自增id不存数据库用32位就行(客户端根据这个id排序) */
                id: number;
                /**  兑换的玩家名字 */
                role_name: string;
                /** 1:捐献 2:兑换 3:销毁 */
                exchange_type: number;
                /** 物品唯一Id */
                goods_id: number;
                /** 兑换的物品Id */
                type_id: number;
                /** 颜色 */
                color: number;
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
                /** 附加属性(极品属性) */
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
                /** 宝石列表 */
                stone_list: {
                    /** 宝石孔位置 */
                    pos: number;
                    /** 物品类型Id */
                    type_id: number;
                }[];
                /** 洗炼属性 */
                wash_attr: {
                    /** 第几条 */
                    index: number;
                    /** 颜色 */
                    color: number;
                    /** 属性id */
                    attr_id: number;
                    /** 属性值 */
                    attr_val: number;
                }[];
                /** 套装等级 */
                suit_lv: number;
                /** 第几阶 */
                suit_slv: number;
                suit_count: number;
                /** 兑换时间 */
                time: number;
            }[];
        };
    };
    40108: {
        desc: "仓库有变化广播公会";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 1 仓库有更新 */
            change: number;
        };
    };
    40109: {
        desc: "按条件销毁";
        send: (
            number: 40109,
            fmt: "ccc",
            args: [
                /**阶数*/
                stage: number,
                /**稀有度（颜色）*/
                color: number,
                /**星数*/
                star: number
            ]
        ) => never;
        sendFmt: "ccc";
        sendArgs: [
            /**阶数*/
            stage: number,
            /**稀有度（颜色）*/
            color: number,
            /**星数*/
            star: number
        ];
        recv: null;
    };
    40110: {
        desc: "批量销毁当前条件";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 阶数 */
            stage: number;
            /** 稀有度（颜色） */
            color: number;
            /** 星数 */
            star: number;
        };
    };
}

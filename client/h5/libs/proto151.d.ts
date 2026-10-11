/** 交易信息
 */
declare interface ProtoFmtInfo {
    15100: {
        desc: "错误码";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            errcode: number;
            /**  参数 */
            args: string;
        };
    };
    15101: {
        desc: "商品一级列表";
        send: (
            number: 15101,
            fmt: "i",
            args: [
                /**商品大类*/
                type: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**商品大类*/
            type: number
        ];
        recv: {
            /** 商品大类 */
            type: number;
            sell_list: {
                /** 商品子类 */
                subtype: number;
                /** 正在出售的数量 */
                sell_num: number;
            }[];
        };
    };
    15102: {
        desc: "出售的商品列表";
        send: (
            number: 15102,
            fmt: "iiccc",
            args: [
                /**商品大类*/
                type: number,
                /**商品子类*/
                subtype: number,
                /**阶数*/
                stage: number,
                /**星级*/
                star: number,
                /**颜色*/
                color: number
            ]
        ) => never;
        sendFmt: "iiccc";
        sendArgs: [
            /**商品大类*/
            type: number,
            /**商品子类*/
            subtype: number,
            /**阶数*/
            stage: number,
            /**星级*/
            star: number,
            /**颜色*/
            color: number
        ];
        recv: {
            /** 商品大类 */
            type: number;
            /** 商品子类 */
            subtype: number;
            goods_list: {
                /** 交易所商品Id */
                id: number;
                /** 出售玩家id */
                player_id: number;
                /** 物品类型Id */
                type_id: number;
                /** 物品数量 */
                goods_num: number;
                /** 装备评分 */
                rating: number;
                /** 装备综合评分 */
                overall_rating: number;
                /** 总价 */
                unit_price: number;
                /** sell_type */
                sell_type: number;
                /** 极品属性 */
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
            }[];
        };
    };
    15104: {
        desc: "根据名字搜索商品";
        send: (
            number: 15104,
            fmt: "s",
            args: [
                /** 物品名字*/
                goods_name: string
            ]
        ) => never;
        sendFmt: "s";
        sendArgs: [
            /** 物品名字*/
            goods_name: string
        ];
        recv: {
            goods_list: {
                /** 交易所商品Id */
                id: number;
                /** 出售玩家id */
                player_id: number;
                /** 物品类型Id */
                type_id: number;
                /** 物品数量 */
                goods_num: number;
                /** 装备评分 */
                rating: number;
                /** 装备综合评分 */
                overall_rating: number;
                /** 总价 */
                unit_price: number;
                /** sell_type */
                sell_type: number;
                /** 极品属性 */
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
            }[];
        };
    };
    15105: {
        desc: "商品上架界面信息";
        send: (
            number: 15105,
            fmt: "li",
            args: [
                /**背包物品id*/
                goods_id: number,
                /**物品类型id*/
                type_id: number
            ]
        ) => never;
        sendFmt: "li";
        sendArgs: [
            /**背包物品id*/
            goods_id: number,
            /**物品类型id*/
            type_id: number
        ];
        recv: {
            /** 背包物品id */
            goods_id: number;
            /** 1: 最近成交价 2: 官方推荐价 */
            type: number;
            /** 最近成交价 */
            recommend_price: number;
        };
    };
    15106: {
        desc: "商品上架";
        send: (
            number: 15106,
            fmt: "liic",
            args: [
                /**背包物品id*/
                goods_id: number,
                /**数量*/
                goods_num: number,
                /**总价*/
                price: number,
                /**是否喊话*/
                is_shout: number
            ]
        ) => never;
        sendFmt: "liic";
        sendArgs: [
            /**背包物品id*/
            goods_id: number,
            /**数量*/
            goods_num: number,
            /**总价*/
            price: number,
            /**是否喊话*/
            is_shout: number
        ];
        recv: {
            /** 返回码 */
            errcode: number;
        };
    };
    15108: {
        desc: "商品下架";
        send: (
            number: 15108,
            fmt: "clii",
            args: [
                /**商品的sell_type字段 (取消了指定交易，客户端只发1即可)*/
                sell_type: number,
                /**交易所商品Id*/
                id: number,
                /**物品类型id*/
                type_id: number,
                /**物品数量*/
                goods_num: number
            ]
        ) => never;
        sendFmt: "clii";
        sendArgs: [
            /**商品的sell_type字段 (取消了指定交易，客户端只发1即可)*/
            sell_type: number,
            /**交易所商品Id*/
            id: number,
            /**物品类型id*/
            type_id: number,
            /**物品数量*/
            goods_num: number
        ];
        recv: {
            /** 返回码 */
            errcode: number;
        };
    };
    15109: {
        desc: "获取玩家上架中的物品";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            goods_list: {
                /** 交易所商品Id */
                id: number;
                /** 出售玩家id */
                player_id: number;
                /** 物品类型Id */
                type_id: number;
                /** 物品数量 */
                goods_num: number;
                /** 装备评分 */
                rating: number;
                /** 装备综合评分 */
                overall_rating: number;
                /** 总价 */
                unit_price: number;
                /** sell_type */
                sell_type: number;
                /** 极品属性 */
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
            }[];
        };
    };
    15111: {
        desc: "购买商品";
        send: (
            number: 15111,
            fmt: "cliiliii",
            args: [
                /**商品的sell_type字段 (取消了指定交易，客户端只发1即可)*/
                sell_type: number,
                /**交易所商品Id*/
                id: number,
                /**商品大类*/
                type: number,
                /**商品子类*/
                subtype: number,
                /**商品出售玩家id*/
                seller_id: number,
                /**物品类型id*/
                type_id: number,
                /**购买数量*/
                goods_num: number,
                /**总价*/
                unit_price: number
            ]
        ) => never;
        sendFmt: "cliiliii";
        sendArgs: [
            /**商品的sell_type字段 (取消了指定交易，客户端只发1即可)*/
            sell_type: number,
            /**交易所商品Id*/
            id: number,
            /**商品大类*/
            type: number,
            /**商品子类*/
            subtype: number,
            /**商品出售玩家id*/
            seller_id: number,
            /**物品类型id*/
            type_id: number,
            /**购买数量*/
            goods_num: number,
            /**总价*/
            unit_price: number
        ];
        recv: {
            /** 返回码 */
            errcode: number;
            /** 1:交易所 2:指定交易 */
            sell_type: number;
            /** 交易所商品Id */
            id: number;
            /** 商品大类 */
            type: number;
            /** 商品子类 */
            subtype: number;
        };
    };
    15112: {
        desc: "交易记录";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            record_list: {
                /** 物品类型Id */
                type_id: number;
                /** 物品数量 */
                goods_num: number;
                /** 装备评分 */
                rating: number;
                /** 装备综合评分 */
                overall_rating: number;
                /** 1:出售 2:购买 3:购买(求购) */
                type: number;
                /** 交易税 */
                tax: number;
                /** 收支 */
                price: number;
                /** 交易时间 */
                time: number;
                /** 极品属性 */
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
            }[];
        };
    };
    15114: {
        desc: "交易次数信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            times_list: {
                /** key: 1 购买次数 */
                type: number;
                /** value : 次数 */
                times: number;
                /** 上限 */
                times_limit: number;
            }[];
        };
    };
    15115: {
        desc: "发起求购";
        send: (
            number: 15115,
            fmt: "iii",
            args: [
                /**物品类型Id*/
                type_id: number,
                /**物品数量*/
                goods_num: number,
                /**总价*/
                unit_price: number
            ]
        ) => never;
        sendFmt: "iii";
        sendArgs: [
            /**物品类型Id*/
            type_id: number,
            /**物品数量*/
            goods_num: number,
            /**总价*/
            unit_price: number
        ];
        recv: {
            /** 返回码 */
            errcode: number;
            /** 求购id */
            id: number;
            /** 求购者id */
            player_id: number;
            role_name: string;
            /** 类型id */
            type_id: number;
            /** 求购数量 */
            goods_num: number;
            /** 总价 */
            unit_price: number;
            /** 求购时间 */
            time: number;
        };
    };
    15116: {
        desc: "撤销求购";
        send: (
            number: 15116,
            fmt: "l",
            args: [
                /**求购id*/
                id: number
            ]
        ) => never;
        sendFmt: "l";
        sendArgs: [
            /**求购id*/
            id: number
        ];
        recv: {
            /** 返回码 */
            errcode: number;
            /** 求购id */
            id: number;
        };
    };
    15117: {
        desc: "求购出售";
        send: (
            number: 15117,
            fmt: "llii",
            args: [
                /**求购id*/
                id: number,
                /**求购者玩家id*/
                buyer_id: number,
                /**物品类型id*/
                type_id: number,
                /**购买数量*/
                goods_num: number
            ]
        ) => never;
        sendFmt: "llii";
        sendArgs: [
            /**求购id*/
            id: number,
            /**求购者玩家id*/
            buyer_id: number,
            /**物品类型id*/
            type_id: number,
            /**购买数量*/
            goods_num: number
        ];
        recv: {
            /** 返回码 */
            errcode: number;
            /** 求购id */
            id: number;
            /** 数量 */
            goods_num: number;
        };
    };
    15118: {
        desc: "查看求购列表";
        send: (
            number: 15118,
            fmt: "hh",
            args: [page_no: number, page_size: number]
        ) => never;
        sendFmt: "hh";
        sendArgs: [page_no: number, page_size: number];
        recv: {
            /** 总页数 */
            page_total: number;
            page_no: number;
            page_size: number;
            seek_list: {
                /** 求购id */
                id: number;
                /** 求购者 */
                ser_id: number;
                /** 求购者 */
                server_num: number;
                /** 求购者id */
                player_id: number;
                role_name: string;
                /** 类型id */
                type_id: number;
                /** 求购数量 */
                goods_num: number;
                /** 总价 */
                unit_price: number;
                /** 求购时间 */
                time: number;
            }[];
        };
    };
    15119: {
        desc: "查看我的求购列表";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            seek_list: {
                /** 求购id */
                id: number;
                /** 类型id */
                type_id: number;
                /** 求购数量 */
                goods_num: number;
                /** 总价 */
                unit_price: number;
                /** 求购时间 */
                time: number;
            }[];
        };
    };
    15120: {
        desc: "玩家出售的商品删除";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 1 市场出售 2 指定交易 3 求购 */
            sell_type: number;
            /** 商品大类 */
            type: number;
            /** 商品子类 */
            subtype: number;
            /** 商品id */
            id: number;
        };
    };
    15121: {
        desc: "跨服市场信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 0则是不开启，未满足条件 ，有时间则是 跨服开启时间 */
            open_time: number;
        };
    };
    15122: {
        desc: "市场喊话";
        send: (
            number: 15122,
            fmt: "l",
            args: [
                /**交易Id*/
                sell_id: number
            ]
        ) => never;
        sendFmt: "l";
        sendArgs: [
            /**交易Id*/
            sell_id: number
        ];
        recv: {
            /** 返回码 */
            errcode: number;
            /** 交易Id */
            sell_id: number;
            /** 下一次可喊话的时间 */
            cd_time: number;
        };
    };
}

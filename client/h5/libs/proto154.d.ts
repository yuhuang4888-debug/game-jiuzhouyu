/** 拍卖信息
 */
declare interface ProtoFmtInfo {
    15400: {
        desc: "获取拍卖菜单注：服务端返回数据只包含有有拍卖物品的菜单，客户端通过读取配置展示全部菜单";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 公会拍卖功能活动列表 */
            module_list: {
                /** 功能类型 */
                module_id: number;
                /** 物品数量 */
                num: number;
            }[];
            /** 世界拍卖物品类目列表 */
            type_list: {
                /** 物品类目 */
                type: number;
                /** 物品数量 */
                num: number;
            }[];
        };
    };
    15401: {
        desc: "获取拍卖物品";
        send: (
            number: 15401,
            fmt: "iii",
            args: [
                /**拍卖类型：1公会拍卖,2世界拍卖,3跨服海域拍卖*/
                auction_type: number,
                /**商品类目  					   Type为0表示获取世界拍卖全部拍卖物*/
                type: number,
                /**功能类型 						   ModuleId为0表示获取该公会拍卖全部拍卖物*/
                module_id: number
            ]
        ) => never;
        sendFmt: "iii";
        sendArgs: [
            /**拍卖类型：1公会拍卖,2世界拍卖,3跨服海域拍卖*/
            auction_type: number,
            /**商品类目  					   Type为0表示获取世界拍卖全部拍卖物*/
            type: number,
            /**功能类型 						   ModuleId为0表示获取该公会拍卖全部拍卖物*/
            module_id: number
        ];
        recv: {
            /** 拍卖类型：1公会拍卖,2世界拍卖 3跨服海域拍卖 */
            auction_type: number;
            goods_list: {
                /** 拍卖物唯一id */
                goods_id: number;
                /** 功能类型 */
                module_id: number;
                /** 拍卖品id */
                type_id: number;
                /** 世界等级 */
                wlv: number;
                /** 当前竞价 */
                now_price: number;
                /** 下一次竞价 */
                next_price: number;
                /** 一口价 */
                price: number;
                /** 起拍时间戳 */
                start_time: number;
                /** 结束时间戳 */
                time: number;
                /** 出价最高玩家id */
                top_player_id: number;
                /** 是否竞价延时：0否，1是 */
                is_delay: number;
                /** 0 没有 1有 */
                had_bonus: number;
            }[];
        };
    };
    15402: {
        desc: "更新拍卖物品信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 拍卖物唯一id */
            goods_id: number;
            /** 功能类型 */
            module_id: number;
            /** 拍卖类型：1公会拍卖,2世界拍卖 3跨服海域拍卖 */
            auction_type: number;
            /** 当前竞价 */
            now_price: number;
            /** 下一次竞价 */
            next_price: number;
            /** 结束时间戳 */
            time: number;
            /** 出价最高玩家id */
            top_player_id: number;
            /** 是否竞价延时：0否，1是 */
            is_delay: number;
            /** 拍卖物状态：1拍卖中,2已拍出 	 已拍出状态时，需要将该条拍卖物移除 */
            goods_status: number;
        };
    };
    15403: {
        desc: "竞拍商品";
        send: (
            number: 15403,
            fmt: "ilcii",
            args: [
                /**拍卖类型：1公会拍卖,2世界拍卖 3跨服海域拍卖*/
                auction_type: number,
                /**拍卖物唯一id*/
                goods_id: number,
                /**竞拍类型：1普通竞拍，2一口价，3加价*/
                price_type: number,
                /**绑定钻石*/
                bgold: number,
                /**钻石*/
                gold: number
            ]
        ) => never;
        sendFmt: "ilcii";
        sendArgs: [
            /**拍卖类型：1公会拍卖,2世界拍卖 3跨服海域拍卖*/
            auction_type: number,
            /**拍卖物唯一id*/
            goods_id: number,
            /**竞拍类型：1普通竞拍，2一口价，3加价*/
            price_type: number,
            /**绑定钻石*/
            bgold: number,
            /**钻石*/
            gold: number
        ];
        recv: {
            /** 返回码 */
            res: number;
            /** 竞拍类型：1普通竞拍，2一口价，3加价 */
            price_type: number;
        };
    };
    15404: {
        desc: "竞拍失败通知";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 拍卖类型：1公会拍卖,2世界拍卖 */
            auction_type: number;
            /** 商品类目 */
            type: number;
            /** 功能类型 */
            module_id: number;
            /** 拍卖物唯一id */
            goods_id: number;
            /** 拍品id */
            type_id: number;
            /** 返还绑定钻石 */
            bgold: number;
            /** 返还钻石 */
            gold: number;
        };
    };
    15405: {
        desc: "我的竞拍(弃用)";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            goods_list: {
                /** 拍卖物唯一id */
                goods_id: number;
                /** 功能类型 */
                module_id: number;
                /** 拍品id */
                type_id: number;
                /** 世界等级 */
                wlv: number;
                /** 当前竞价 */
                now_price: number;
                /** 下一次竞价 */
                next_price: number;
                /** 一口价 */
                price: number;
                /** 起拍时间戳 */
                start_time: number;
                /** 结束时间戳 */
                time: number;
                /** 出价最高玩家id */
                top_player_id: number;
                /** 是否竞价延时：0否，1是 */
                is_delay: number;
                /** 0 没有 1有 */
                had_bonus: number;
            }[];
        };
    };
    15406: {
        desc: "拍卖记录(弃用)";
        send: (
            number: 15406,
            fmt: "i",
            args: [
                /**拍卖类型：1公会拍卖,2世界拍卖*/
                auction_type: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**拍卖类型：1公会拍卖,2世界拍卖*/
            auction_type: number
        ];
        recv: {
            /** 拍卖类型：1公会拍卖,2世界拍卖 */
            auction_type: number;
            auction_list: {
                /** 功能id */
                module_id: number;
                /** 成交时间戳 */
                time: number;
                /** 拍品id */
                type_id: number;
                /** 世界等级 */
                wlv: number;
                /** 成交价 */
                price: number;
                /** 是否流拍至世界：0否，1是 */
                to_world: number;
            }[];
        };
    };
    15407: {
        desc: "预计分红";
        send: (
            number: 15407,
            fmt: "ii",
            args: [
                /**拍卖类型：1公会拍卖,2世界拍卖*/
                auction_type: number,
                /**功能类型*/
                module_id: number
            ]
        ) => never;
        sendFmt: "ii";
        sendArgs: [
            /**拍卖类型：1公会拍卖,2世界拍卖*/
            auction_type: number,
            /**功能类型*/
            module_id: number
        ];
        recv: {
            /** 拍卖类型：1公会拍卖,2世界拍卖 */
            auction_type: number;
            /** 功能类型 */
            module_id: number;
            /** 预计分红 钻石 */
            estimate_gold: number;
            /** 预计分红 绑钻 */
            estimate_bgold: number;
        };
    };
    15408: {
        desc: "竞拍开始通知";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 拍卖类型：1公会拍卖,2世界拍卖 */
            auction_type: number;
            /** 功能id */
            module_id: number;
            /** 类型：1拍卖预告,2拍卖开始 3 拍卖结束 */
            type: number;
        };
    };
    15409: {
        desc: "个人拍卖记录";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            record_list: {
                /** 1 竞拍 2 竞拍失败返还 */
                op_type: number;
                /** 功能id */
                module_id: number;
                /** 竞拍类型：1普通竞拍，2一口价，3加价 */
                price_type: number;
                /** 钻石花费获得 */
                gold: number;
                /** 绑钻花费获得 */
                bgold: number;
                /** 拍品id */
                type_id: number;
                /** 世界等级 */
                wlv: number;
                /** 成交时间戳 */
                time: number;
            }[];
        };
    };
    15410: {
        desc: "分红记录";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 分红记录 */
            bonus_list: {
                /** 功能id */
                module_id: number;
                /** 钻石获得 */
                gold: number;
                /** 绑钻获得 */
                bgold: number;
                /** 成交时间戳 */
                time: number;
            }[];
            bonus_info: {
                /** 功能id */
                module_id: number;
                /** 本周已分红钻石 */
                gold_got: number;
                /** 本周已分红绑钻 */
                bgold_got: number;
            }[];
        };
    };
    15411: {
        desc: "所有拍卖都结束";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            all_close: number;
        };
    };
}

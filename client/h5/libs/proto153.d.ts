/** 商城信息
 */
declare interface ProtoFmtInfo {
    15301: {
        desc: "获得商品列表";
        send: (
            number: 15301,
            fmt: "c",
            args: [
                /**商店类型:1：每周限购 2：钻石 3：绑钻*/
                type: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**商店类型:1：每周限购 2：钻石 3：绑钻*/
            type: number
        ];
        recv: {
            type: number;
            goods_list: {
                /** 物品唯一ID */
                key_id: number;
                /** 标签id列表 */
                subtype_list: string;
                /** 物品摆放优先级 */
                rank: number;
                /** 物品ID */
                goods_id: number;
                /** 物品数量 */
                num: number;
                /** 价格类型 */
                money_type: number;
                /** 价格 */
                price: number;
                /** 折扣 */
                discount: number;
                /** 限购类型 */
                quota_type: number;
                /** 限购数量 */
                quota_num: number;
                /** 已购买的数量 */
                sold_out: number;
                /** 售卖条件 */
                condition: string;
                /** 正在接取的任务##用作显示商品 */
                trigger_task_id: number;
                bind: number;
            }[];
        };
    };
    15302: {
        desc: "购买商品";
        send: (
            number: 15302,
            fmt: "ii",
            args: [
                /**商店物品唯一id*/
                key_id: number,
                /**购买数量*/
                num: number
            ]
        ) => never;
        sendFmt: "ii";
        sendArgs: [
            /**商店物品唯一id*/
            key_id: number,
            /**购买数量*/
            num: number
        ];
        recv: {
            result: number;
            /** 商店物品唯一id */
            key_id: number;
            /** 购买数量 */
            num: number;
        };
    };
    15303: {
        desc: "根据物品类型id购买物品";
        send: (
            number: 15303,
            fmt: "ii",
            args: [
                /**物品类型id*/
                goods_id: number,
                /**够买数量*/
                num: number
            ]
        ) => never;
        sendFmt: "ii";
        sendArgs: [
            /**物品类型id*/
            goods_id: number,
            /**够买数量*/
            num: number
        ];
        recv: {
            res: number;
            goods_id: number;
            num: number;
        };
    };
    15304: {
        desc: "根据物品类型id购买物品（快速购买）";
        send: (
            number: 15304,
            fmt: "iic",
            args: [
                /**物品类型id*/
                goods_id: number,
                /**够买数量*/
                num: number,
                /**1钻石 2绑钻*/
                buy_type: number
            ]
        ) => never;
        sendFmt: "iic";
        sendArgs: [
            /**物品类型id*/
            goods_id: number,
            /**够买数量*/
            num: number,
            /**1钻石 2绑钻*/
            buy_type: number
        ];
        recv: {
            res: number;
            goods_id: number;
            num: number;
            /** 1钻石 2绑钻 */
            buy_type: number;
        };
    };
    15305: {
        desc: "神秘商店";
        send: (
            number: 15305,
            fmt: "h",
            args: [
                /**商店类型*/
                type: number
            ]
        ) => never;
        sendFmt: "h";
        sendArgs: [
            /**商店类型*/
            type: number
        ];
        recv: {
            /** 商店类型 */
            type: number;
            /** 刷新时间戳 */
            refresh_time: number;
            /** 已刷次数 */
            hit_num: number;
            good_list: {
                /** 配置id */
                cfg_id: number;
                /** 折扣 */
                discount: number;
                /** 当前所需数量（有折扣时需读取该值） */
                price: number;
                /** 1为未购买；2为已买 */
                buy_type: number;
                /** 已买数量 */
                buy_num: number;
            }[];
        };
    };
    15306: {
        desc: "手动刷新商店";
        send: (
            number: 15306,
            fmt: "h",
            args: [
                /**商店类型*/
                type: number
            ]
        ) => never;
        sendFmt: "h";
        sendArgs: [
            /**商店类型*/
            type: number
        ];
        recv: {
            /** 错误码：1为成功(成功后会自动推15305) */
            errcode: number;
        };
    };
    15307: {
        desc: "购买商品";
        send: (
            number: 15307,
            fmt: "hhi",
            args: [
                /**商店类型*/
                type: number,
                /**配置id*/
                cfg_id: number,
                /**折扣价（无则为0）*/
                price: number
            ]
        ) => never;
        sendFmt: "hhi";
        sendArgs: [
            /**商店类型*/
            type: number,
            /**配置id*/
            cfg_id: number,
            /**折扣价（无则为0）*/
            price: number
        ];
        recv: {
            /** 错误码：1为成功 */
            errcode: number;
            /** 商店类型 */
            type: number;
            /** 配置id */
            cfg_id: number;
        };
    };
}

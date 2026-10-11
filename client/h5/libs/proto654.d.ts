/** 圣印
 */
declare interface ProtoFmtInfo {
    65400: {
        desc: "通用错误返回";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            error_code: number;
            error_code_args: string;
        };
    };
    65401: {
        desc: "界面";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            equip_list: {
                /** 位置 */
                pos: number;
                /** 物品唯一id, */
                goods_id: number;
                /** 强化等级 */
                stren: number;
            }[];
        };
    };
    65402: {
        desc: "强化";
        send: (
            number: 65402,
            fmt: "cc",
            args: [
                /**部位id*/
                pos_id: number,
                /**0普通强化（强化一次） 1自动强化（强化某一部位直到材料不足）*/
                stren_type: number
            ]
        ) => never;
        sendFmt: "cc";
        sendArgs: [
            /**部位id*/
            pos_id: number,
            /**0普通强化（强化一次） 1自动强化（强化某一部位直到材料不足）*/
            stren_type: number
        ];
        recv: {
            pos_id: number;
            /** 新强化等级 */
            stren_lv: number;
        };
    };
    65403: {
        desc: "穿装备";
        send: (
            number: 65403,
            fmt: "cl",
            args: [
                /**位置*/
                pos: number,
                /**物品唯一id*/
                goods_id: number
            ]
        ) => never;
        sendFmt: "cl";
        sendArgs: [
            /**位置*/
            pos: number,
            /**物品唯一id*/
            goods_id: number
        ];
        recv: null;
    };
    65404: {
        desc: "脱装备";
        send: (
            number: 65404,
            fmt: "c",
            args: [
                /**位置  0表示一键卸下*/
                pos: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**位置  0表示一键卸下*/
            pos: number
        ];
        recv: null;
    };
    65405: {
        desc: "圣魂丹界面协议";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            seal_pill: {
                /** 物品类型id */
                goods_type_id: number;
                /** 使用总数量 */
                num: number;
                /** 当前等级使用数量上限 */
                limit: number;
            }[];
        };
    };
    65406: {
        desc: "使用圣魂丹";
        send: (
            number: 65406,
            fmt: "ih",
            args: [
                /**物品类型id*/
                goods_type_id: number,
                /**使用数量*/
                num: number
            ]
        ) => never;
        sendFmt: "ih";
        sendArgs: [
            /**物品类型id*/
            goods_type_id: number,
            /**使用数量*/
            num: number
        ];
        recv: {
            /** 物品类型id */
            goods_type_id: number;
            /** 使用数量 */
            num: number;
            /** 返回码 0表示成功 */
            code: number;
        };
    };
    65407: {
        desc: "获取总评分";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 总评分（装备评分+套装评分） */
            rating: number;
        };
    };
    65408: {
        desc: "套装预览";
        send: (
            number: 65408,
            fmt: "i",
            args: [
                /**物品类型id*/
                goods_type_id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**物品类型id*/
            goods_type_id: number
        ];
        recv: {
            suit: {
                /** 套装id */
                suit_id: number;
                /** 数量 */
                num: number;
            }[];
            /** 返回码 0表示成功 1表示 */
            code: number;
        };
    };
    65409: {
        desc: "套装";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            suit: {
                /** 套装id */
                suit_id: number;
                /** 数量 */
                num: number;
            }[];
        };
    };
}

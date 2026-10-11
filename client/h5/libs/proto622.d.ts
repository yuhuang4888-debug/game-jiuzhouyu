/** 龙语
 */
declare interface ProtoFmtInfo {
    62200: {
        desc: "通用错误返回";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            error_code: number;
            error_code_args: string;
        };
    };
    62201: {
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
    62202: {
        desc: "强化";
        send: (
            number: 62202,
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
    62203: {
        desc: "穿装备";
        send: (
            number: 62203,
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
    62204: {
        desc: "脱装备";
        send: (
            number: 62204,
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
    62207: {
        desc: "获取总评分";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 总评分（装备评分+套装评分） */
            rating: number;
        };
    };
    62208: {
        desc: "套装预览";
        send: (
            number: 62208,
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
    62209: {
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

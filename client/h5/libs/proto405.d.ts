/** 公会神像
 */
declare interface ProtoFmtInfo {
    40500: {
        desc: "错误码";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            errcode: number;
        };
    };
    40501: {
        desc: "神像信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 最高历史等级 */
            guild_title_lv: number;
            god_list: {
                god_id: number;
                /** 品级 */
                color: number;
                /** 觉醒等级 */
                lv: number;
                /** 武魂总战力 */
                god_power: number;
            }[];
        };
    };
    40502: {
        desc: "铭文信息";
        send: (number: 40502, fmt: "h", args: [god_id: number]) => never;
        sendFmt: "h";
        sendArgs: [god_id: number];
        recv: {
            god_id: number;
            rune_list: {
                pos: number;
                /** 物品唯一id */
                goods_id: number;
                /** 物品类型id */
                goods_type_id: number;
            }[];
            /** 组合id */
            combo_id: number;
            achievemetn_lvs: {
                /** 铭文大师等级 */
                achievemetn_lv: number;
            }[];
            /** 武魂总战力 */
            god_power: number;
        };
    };
    40503: {
        desc: "神像升品";
        send: (number: 40503, fmt: "h", args: [god_id: number]) => never;
        sendFmt: "h";
        sendArgs: [god_id: number];
        recv: {
            god_id: number;
            /** 品级 */
            color: number;
            /** 觉醒等级 */
            lv: number;
            /** 武魂总战力 */
            god_power: number;
        };
    };
    40504: {
        desc: "神像觉醒";
        send: (number: 40504, fmt: "h", args: [god_id: number]) => never;
        sendFmt: "h";
        sendArgs: [god_id: number];
        recv: {
            god_id: number;
            /** 品级 */
            color: number;
            /** 觉醒等级 */
            lv: number;
            /** 武魂总战力 */
            god_power: number;
        };
    };
    40505: {
        desc: "穿戴推送02协议";
        send: (
            number: 40505,
            fmt: "hcl",
            args: [
                god_id: number,
                /**槽位id*/
                pos_id: number,
                /**物品id*/
                goods_id: number
            ]
        ) => never;
        sendFmt: "hcl";
        sendArgs: [
            god_id: number,
            /**槽位id*/
            pos_id: number,
            /**物品id*/
            goods_id: number
        ];
        recv: {
            /** 返回码 */
            code: number;
            god_id: number;
            /** 槽位id */
            pos_id: number;
            /** 穿上的符文物品id */
            new_goods_id: number;
            /** 脱下的符文物品id */
            old_goods_id: number;
            /** 穿上的符文物品类型id */
            new_goods_type_id: number;
        };
    };
    40506: {
        desc: "激活组合推送02协议";
        send: (
            number: 40506,
            fmt: "hc",
            args: [god_id: number, combo_id: number]
        ) => never;
        sendFmt: "hc";
        sendArgs: [god_id: number, combo_id: number];
        recv: null;
    };
    40507: {
        desc: "脱铭文推送02协议";
        send: (
            number: 40507,
            fmt: "hc",
            args: [
                /**神像id*/
                god_id: number,
                /**位置*/
                pos: number
            ]
        ) => never;
        sendFmt: "hc";
        sendArgs: [
            /**神像id*/
            god_id: number,
            /**位置*/
            pos: number
        ];
        recv: {
            /** 错误码 */
            code: number;
        };
    };
    40508: {
        desc: "升级铭文推送02协议";
        send: (
            number: 40508,
            fmt: "hc",
            args: [god_id: number, pos: number]
        ) => never;
        sendFmt: "hc";
        sendArgs: [god_id: number, pos: number];
        recv: {
            code: number;
        };
    };
    40509: {
        desc: "激活铭文大师等级推送02协议";
        send: (
            number: 40509,
            fmt: "ch",
            args: [
                god_id: number,
                /**铭文大师等级*/
                lv: number
            ]
        ) => never;
        sendFmt: "ch";
        sendArgs: [
            god_id: number,
            /**铭文大师等级*/
            lv: number
        ];
        recv: {
            code: number;
        };
    };
}

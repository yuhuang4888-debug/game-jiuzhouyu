/** 聚魂
 */
declare interface ProtoFmtInfo {
    17000: {
        desc: "打开聚魂界面";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 聚魂经验 */
            soul_point: number;
            /** 槽位列表 */
            soul_list: {
                /** 槽位id */
                pos_id: number;
                /** 是否开启 */
                if_open: number;
                /** 物品id */
                goods_id: number;
                /** 符文物品类型id */
                goods_type_id: number;
                /** 品质 */
                color: number;
                /** 物品等级 */
                lv: number;
                /** 属性列表 */
                attr_list: {
                    /** 属性类型 */
                    attr_id: number;
                    /** 属性基础值 */
                    attr_num: number;
                    /** 觉醒等级 */
                    awake_lv: number;
                }[];
                /** 战力 */
                power: number;
            }[];
        };
    };
    17001: {
        desc: "聚魂镶嵌";
        send: (
            number: 17001,
            fmt: "cl",
            args: [
                /**槽位id*/
                pos_id: number,
                /**物品id*/
                goods_id: number
            ]
        ) => never;
        sendFmt: "cl";
        sendArgs: [
            /**槽位id*/
            pos_id: number,
            /**物品id*/
            goods_id: number
        ];
        recv: {
            /** 返回码 */
            code: number;
            /** 槽位id */
            pos_id: number;
            /** 穿上的聚魂物品id */
            new_goods_id: number;
            /** 脱下的聚魂物品id */
            old_goods_id: number;
            /** 穿上的聚魂物品类型id */
            new_goods_type_id: number;
        };
    };
    17002: {
        desc: "聚魂升级";
        send: (
            number: 17002,
            fmt: "l",
            args: [
                /**物品id*/
                goods_id: number
            ]
        ) => never;
        sendFmt: "l";
        sendArgs: [
            /**物品id*/
            goods_id: number
        ];
        recv: {
            /** 返回码 */
            code: number;
            /** 物品id */
            goods_id: number;
        };
    };
    17003: {
        desc: "聚魂合成预览";
        send: (
            number: 17003,
            fmt: "lA",
            args: [
                /**规则id*/
                rule_id: number,
                soul_list: any
            ]
        ) => never;
        sendFmt: "lA";
        sendArgs: [
            /**规则id*/
            rule_id: number,
            soul_list: any
        ];
        recv: {
            /** 返回码 */
            code: number;
            /** 合成后等级 */
            lv: number;
        };
    };
    17004: {
        desc: "聚魂分解预览";
        send: (number: 17004, fmt: any, args: [soul_list: any]) => never;
        sendFmt: any;
        sendArgs: [soul_list: any];
        recv: {
            /** 返回码 */
            code: number;
            /** 分解总经验 */
            exp: number;
            /** 分解的得到的道具列表 */
            result_list: any;
        };
    };
    17005: {
        desc: "聚魂经验";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 聚魂总经验 */
            exp: number;
        };
    };
    17006: {
        desc: "聚魂觉醒";
        send: (
            number: 17006,
            fmt: "lhA",
            args: [
                /**物品唯一id*/
                goods_id: number,
                /**属性id*/
                attr_id: number,
                /**消耗物品唯一id*/
                cost_id_list: any
            ]
        ) => never;
        sendFmt: "lhA";
        sendArgs: [
            /**物品唯一id*/
            goods_id: number,
            /**属性id*/
            attr_id: number,
            /**消耗物品唯一id*/
            cost_id_list: any
        ];
        recv: {
            /** 返回码 */
            code: number;
            /** 物品唯一id */
            goods_id: number;
            /** 属性id */
            attr_id: number;
            /** 新聚魂等级 */
            awake_lv: number;
            /** 聚魂等级 */
            level: number;
        };
    };
    17007: {
        desc: "聚魂拆解";
        send: (number: 17007, fmt: any, args: [goods_id_list: any]) => never;
        sendFmt: any;
        sendArgs: [goods_id_list: any];
        recv: {
            /** 返回码 */
            code: number;
            goods_id_list: {
                /** 物品唯一id */
                goods_id: number;
                goods_list: any;
            }[];
        };
    };
}

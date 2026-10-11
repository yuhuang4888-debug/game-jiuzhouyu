/** 符文
 */
declare interface ProtoFmtInfo {
    16700: {
        desc: "打开符文界面";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 符文经验 */
            rune_point: number;
            /** 符文碎片 */
            rune_chip: number;
            /** 符文等级 */
            skill_lv: number;
            /** 槽位列表 */
            rune_list: {
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
                    /** 觉醒经验 */
                    awake_exp: number;
                    /** 下一级觉醒的战力(无一下级为0) */
                    next_power: number;
                    /** 当前的觉醒战力加成 */
                    cur_power: number;
                }[];
            }[];
            /** 符文系统总战力 */
            rune_sum_power: number;
        };
    };
    16701: {
        desc: "符文镶嵌";
        send: (
            number: 16701,
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
            /** 穿上的符文物品id */
            new_goods_id: number;
            /** 脱下的符文物品id */
            old_goods_id: number;
            /** 穿上的符文物品类型id */
            new_goods_type_id: number;
        };
    };
    16702: {
        desc: "符文升级";
        send: (
            number: 16702,
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
            /** 符文经验 */
            rune_point: number;
            /** 物品id */
            goods_id: number;
        };
    };
    16703: {
        desc: "符文兑换";
        send: (
            number: 16703,
            fmt: "hi",
            args: [
                /**序号,符文兑换配置id*/
                id: number,
                /**数量  兑换符文数量*/
                num: number
            ]
        ) => never;
        sendFmt: "hi";
        sendArgs: [
            /**序号,符文兑换配置id*/
            id: number,
            /**数量  兑换符文数量*/
            num: number
        ];
        recv: {
            /** 返回码 */
            code: number;
            /** 符文碎片 */
            rune_chip: number;
            /** 序号,符文兑换配置id */
            id: number;
            /** 数量 */
            num: number;
        };
    };
    16704: {
        desc: "符文副本层数";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 符文副本层数 */
            rune_dungeon_level: number;
        };
    };
    16705: {
        desc: "符文合成预览";
        send: (
            number: 16705,
            fmt: "lA",
            args: [
                /**规则id*/
                rule_id: number,
                rune_list: any
            ]
        ) => never;
        sendFmt: "lA";
        sendArgs: [
            /**规则id*/
            rule_id: number,
            rune_list: any
        ];
        recv: {
            /** 返回码 */
            code: number;
            /** 合成后等级 */
            lv: number;
        };
    };
    16706: {
        desc: "符文分解预览";
        send: (number: 16706, fmt: any, args: [rune_list: any]) => never;
        sendFmt: any;
        sendArgs: [rune_list: any];
        recv: {
            /** 返回码 */
            code: number;
            /** 分解总经验 */
            exp: number;
            /** 分解的得到的道具列表 */
            result_list: any;
        };
    };
    16707: {
        desc: "符文觉醒";
        send: (
            number: 16707,
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
            /** 符文等级 */
            lv: number;
            /** 觉醒等级 */
            awake_lv: number;
            /** 经验 */
            exp: number;
            /** 下一级觉醒的战力(无一下级为0) */
            next_power: number;
            /** 当前的觉醒战力加成 */
            cur_power: number;
        };
    };
    16708: {
        desc: "符文拆解";
        send: (number: 16708, fmt: any, args: [goods_id_list: any]) => never;
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
    16709: {
        desc: "符文拆解预览";
        send: (number: 16709, fmt: any, args: [rune_list: any]) => never;
        sendFmt: any;
        sendArgs: [rune_list: any];
        recv: {
            /** 返回码 */
            code: number;
            /** 分解的得到的道具列表 */
            result_list: any;
        };
    };
    16710: {
        desc: "符文技能升级";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 返回码 */
            code: number;
            /** 新的符文技能等级 */
            lv: number;
        };
    };
}

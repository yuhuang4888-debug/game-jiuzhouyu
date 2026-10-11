/** 幻兽
 */
declare interface ProtoFmtInfo {
    17300: {
        desc: "通用错误返回";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            error_code: number;
            error_code_args: string;
        };
    };
    17301: {
        desc: "幻兽概览";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 可出战幻兽数量 */
            fight_count: number;
            eudemons_list: {
                id: number;
                /** 0 未激活 1已激活 2出战 */
                state: number;
                /** 评分 */
                score: number;
                equip_list: {
                    /** 位置 */
                    pos: number;
                    /** 物品唯一id, */
                    goods_id: number;
                    /** 强化等级 */
                    stren: number;
                    /** 强化经验 */
                    exp: number;
                }[];
                equip_attr: {
                    attr_type: number;
                    attr_value: number;
                }[];
            }[];
        };
    };
    17302: {
        desc: "幻兽信息变化";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            id: number;
            /** 0 未激活 1已激活 2出战 */
            state: number;
            /** 评分 */
            score: number;
            equip_list: {
                /** 位置 */
                pos: number;
                /** 物品唯一id */
                goods_id: number;
                /** 强化等级 */
                stren: number;
                /** 强化经验 */
                exp: number;
            }[];
            equip_attr: {
                attr_type: number;
                attr_value: number;
            }[];
        };
    };
    17303: {
        desc: "穿装备";
        send: (
            number: 17303,
            fmt: "lic",
            args: [
                /**物品唯一id*/
                goods_id: number,
                /**神兽id*/
                id: number,
                /**是否继承 1是0否*/
                replace: number
            ]
        ) => never;
        sendFmt: "lic";
        sendArgs: [
            /**物品唯一id*/
            goods_id: number,
            /**神兽id*/
            id: number,
            /**是否继承 1是0否*/
            replace: number
        ];
        recv: null;
    };
    17304: {
        desc: "脱装备";
        send: (
            number: 17304,
            fmt: "ic",
            args: [
                /**神兽id*/
                id: number,
                /**位置  0表示一键卸下*/
                pos: number
            ]
        ) => never;
        sendFmt: "ic";
        sendArgs: [
            /**神兽id*/
            id: number,
            /**位置  0表示一键卸下*/
            pos: number
        ];
        recv: null;
    };
    17305: {
        desc: "出战脱战";
        send: (
            number: 17305,
            fmt: "ic",
            args: [
                id: number,
                /**1脱战 2出战*/
                fight_state: number
            ]
        ) => never;
        sendFmt: "ic";
        sendArgs: [
            id: number,
            /**1脱战 2出战*/
            fight_state: number
        ];
        recv: {
            /** 新状态 */
            id: number;
            /** 0 未激活 1已激活 2出战 */
            state: number;
        };
    };
    17306: {
        desc: "拓展出战槽位";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 新槽位数量 */
            fight_count: number;
        };
    };
    17307: {
        desc: "强化";
        send: (
            number: 17307,
            fmt: "lcA",
            args: [
                /**强化的装备*/
                goods_id: number,
                /**是否双倍强化 1是 0否*/
                is_double: number,
                goods_list: any
            ]
        ) => never;
        sendFmt: "lcA";
        sendArgs: [
            /**强化的装备*/
            goods_id: number,
            /**是否双倍强化 1是 0否*/
            is_double: number,
            goods_list: any
        ];
        recv: {
            /** 强化的装备 */
            goods_id: number;
            /** 强化等级 */
            stren: number;
            /** 当前经验 (达到最大等级后，该经验值为溢出经验) 取不到下一等级，就是最大等级 */
            exp: number;
        };
    };
    17308: {
        desc: "强化预览";
        send: (
            number: 17308,
            fmt: "lcA",
            args: [
                /**强化的装备*/
                goods_id: number,
                /**是否双倍强化 1是 0否*/
                is_double: number,
                goods_list: any
            ]
        ) => never;
        sendFmt: "lcA";
        sendArgs: [
            /**强化的装备*/
            goods_id: number,
            /**是否双倍强化 1是 0否*/
            is_double: number,
            goods_list: any
        ];
        recv: {
            /** 强化的装备 */
            goods_id: number;
            /** 强化等级 */
            stren: number;
            /** 增加的经验值 */
            exp: number;
        };
    };
    17309: {
        desc: "计算局部属性的战力";
        send: (
            number: 17309,
            fmt: "hcA",
            args: [
                /**模块id*/
                module_id: number,
                /**模块子id*/
                sub_module_id: number,
                attr: any
            ]
        ) => never;
        sendFmt: "hcA";
        sendArgs: [
            /**模块id*/
            module_id: number,
            /**模块子id*/
            sub_module_id: number,
            attr: any
        ];
        recv: {
            /** 模块id */
            module_id: number;
            /** 模块子id */
            sub_module_id: number;
            /** 增加的战力 */
            combat_power: number;
        };
    };
    17310: {
        desc: "幻兽合成";
        send: (
            number: 17310,
            fmt: "iA",
            args: [
                /**合成规则id*/
                rule_id: number,
                /**指定扣除物品*/
                specify_glist: any
            ]
        ) => never;
        sendFmt: "iA";
        sendArgs: [
            /**合成规则id*/
            rule_id: number,
            /**指定扣除物品*/
            specify_glist: any
        ];
        recv: {
            /** 错误码 */
            code: number;
            /** 合成规则id */
            rule_id: number;
            send_list: {
                /** 合成的物品id */
                goods_id: number;
                /** 合成的物品类型id */
                goods_type_id: number;
            }[];
        };
    };
    17311: {
        desc: "强化";
        send: (
            number: 17311,
            fmt: "lcl",
            args: [
                /**强化的装备*/
                goods_id: number,
                /**1:强化一次 10：强化10次*/
                type: number,
                /**强化材料id*/
                cost_goods_id: number
            ]
        ) => never;
        sendFmt: "lcl";
        sendArgs: [
            /**强化的装备*/
            goods_id: number,
            /**1:强化一次 10：强化10次*/
            type: number,
            /**强化材料id*/
            cost_goods_id: number
        ];
        recv: {
            /** 强化的装备 */
            goods_id: number;
            /** 强化等级 */
            stren: number;
            /** 当前经验 (达到最大等级后，该经验值为溢出经验) 取不到下一等级，就是最大等级 */
            exp: number;
        };
    };
    17312: {
        desc: "一键穿装备";
        send: (
            number: 17312,
            fmt: "Aci",
            args: [
                goods: any,
                /**是否继承 1是0否*/
                replace: number,
                /**神兽id*/
                id: number
            ]
        ) => never;
        sendFmt: "Aci";
        sendArgs: [
            goods: any,
            /**是否继承 1是0否*/
            replace: number,
            /**神兽id*/
            id: number
        ];
        recv: null;
    };
}

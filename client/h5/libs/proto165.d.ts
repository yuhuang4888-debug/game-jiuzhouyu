/** 坐骑宠物
 */
declare interface ProtoFmtInfo {
    16500: {
        desc: "错误码展示";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            errcode: number;
        };
    };
    16501: {
        desc: "场景广播";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 玩家ID */
            role_id: number;
            /** 玩家当前宠物形象 0: 表示没有 */
            figure_id: number;
            /** 0: 隐藏 1: 显示 */
            hide_status: number;
            /** 当前飞行器id 0隐藏 */
            pet_aircraft: number;
            /** 当前翅膀id 0隐藏 */
            pet_wing: number;
        };
    };
    16502: {
        desc: "宠物信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 坐骑阶数 */
            stage: number;
            /** 当前星数 */
            star: number;
            /** 等级 */
            lv: number;
            /** 祝福值 */
            blessing: number;
            /** 经验值 */
            exp: number;
            /** 幻化形象的等阶 */
            figure_stage: number;
            /** 宠物战力 */
            combat: number;
            /** 0: 隐藏 1: 显示 */
            hide_status: number;
            attr_list: {
                /** 属性类型 */
                attr_id: number;
                /** 属性值 */
                attr_val: number;
            }[];
            /** 解锁技能列表 */
            skill_list: {
                /** 技能id */
                skill_id: number;
            }[];
        };
    };
    16503: {
        desc: "幻化宠物";
        send: (
            number: 16503,
            fmt: "ci",
            args: [
                /**1:基础形象幻化 2:幻形形象幻化*/
                type: number,
                /**基础形象幻化:阶数 幻形形象幻化:幻形id*/
                args: number
            ]
        ) => never;
        sendFmt: "ci";
        sendArgs: [
            /**1:基础形象幻化 2:幻形形象幻化*/
            type: number,
            /**基础形象幻化:阶数 幻形形象幻化:幻形id*/
            args: number
        ];
        recv: {
            /** 错误码 */
            errcode: number;
            /** 1:基础形象幻化 2:幻形形象幻化 */
            type: number;
            /** 基础形象幻化:阶数 幻形形象幻化:幻形id */
            args: number;
        };
    };
    16504: {
        desc: "隐藏/显示宠物";
        send: (
            number: 16504,
            fmt: "c",
            args: [
                /**0: 隐藏 1: 显示*/
                type: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**0: 隐藏 1: 显示*/
            type: number
        ];
        recv: {
            /** 错误码 */
            errcode: number;
            /** 0: 隐藏 1: 显示 */
            type: number;
        };
    };
    16505: {
        desc: "宠物升星";
        send: (
            number: 16505,
            fmt: "c",
            args: [
                /**1: 使用普通道具一键升星2: 使用特殊道具一键升星*/
                type: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**1: 使用普通道具一键升星2: 使用特殊道具一键升星*/
            type: number
        ];
        recv: {
            /** 错误码 */
            errcode: number;
            /** 阶数 */
            stage: number;
            /** 星数 */
            star: number;
            /** 祝福值 */
            blessing: number;
            /** 增加的祝福值 */
            blessing_plus: number;
        };
    };
    16506: {
        desc: "吞噬";
        send: (
            number: 16506,
            fmt: any,
            args: [
                /**吞噬指定物品*/
                specify_goods: any
            ]
        ) => never;
        sendFmt: any;
        sendArgs: [
            /**吞噬指定物品*/
            specify_goods: any
        ];
        recv: {
            /** 错误码 */
            errcode: number;
            /** 等级 */
            lv: number;
            /** 当前经验值 */
            exp: number;
            /** 增加的经验值 */
            exp_plus: number;
        };
    };
    16507: {
        desc: "幻形界面信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            errcode: number;
            /** 当前幻形形象id */
            illusion_id: number;
            /** 已激活的幻形形象列表 */
            figure_list: {
                /** 形象id */
                id: number;
                /** 阶数 */
                stage: number;
            }[];
        };
    };
    16508: {
        desc: "幻形形象详细信息";
        send: (
            number: 16508,
            fmt: "i",
            args: [
                /**形象id*/
                id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**形象id*/
            id: number
        ];
        recv: {
            /** 错误码 */
            errcode: number;
            /** 形象id */
            id: number;
            /** 阶数 */
            stage: number;
            /** 祝福值 */
            blessing: number;
            /** 战力 */
            combat: number;
            attr_list: {
                /** 属性类型 */
                attr_id: number;
                /** 属性值 */
                attr_val: number;
            }[];
            /** 解锁技能列表 */
            skill_list: {
                /** 技能id */
                skill_id: number;
            }[];
        };
    };
    16509: {
        desc: "激活形象";
        send: (
            number: 16509,
            fmt: "i",
            args: [
                /**形象id*/
                id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**形象id*/
            id: number
        ];
        recv: {
            /** 错误码 */
            errcode: number;
        };
    };
    16510: {
        desc: "幻形升阶";
        send: (
            number: 16510,
            fmt: "ic",
            args: [
                /**形象id*/
                id: number,
                /**1: 使用普通道具 2: 使用特殊道具 3: 激活材料*/
                type: number
            ]
        ) => never;
        sendFmt: "ic";
        sendArgs: [
            /**形象id*/
            id: number,
            /**1: 使用普通道具 2: 使用特殊道具 3: 激活材料*/
            type: number
        ];
        recv: {
            /** 错误码 */
            errcode: number;
            /** 阶数 */
            stage: number;
            /** 祝福值 */
            blessing: number;
            /** 增加的祝福值 */
            blessing_plus: number;
        };
    };
    16511: {
        desc: "使用灵丹";
        send: (
            number: 16511,
            fmt: "i",
            args: [
                /**物品类型id*/
                type_id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**物品类型id*/
            type_id: number
        ];
        recv: {
            /** 错误码 */
            errcode: number;
            /** 物品类型id */
            type_id: number;
        };
    };
    16512: {
        desc: "灵丹使用次数";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 灵丹道具使用次数 */
            counter_list: {
                /** 物品id */
                goods_id: number;
                /** 使用次数 */
                times: number;
                /** 次数限制 */
                times_lim: number;
            }[];
        };
    };
    16520: {
        desc: "打开精灵飞行器";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            errcode: number;
            /** 当前形象id */
            show_id: number;
            /** 是否显示 0否 1是 */
            if_show: number;
            aircraft_list: {
                /** 飞行器id */
                aircraft_id: number;
                /** 阶数 */
                stage: number;
            }[];
        };
    };
    16521: {
        desc: "精灵飞行器激活/升阶";
        send: (
            number: 16521,
            fmt: "i",
            args: [
                /**飞行器id*/
                aircraft_id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**飞行器id*/
            aircraft_id: number
        ];
        recv: {
            /** 错误码 */
            errcode: number;
            /** 飞行器id */
            aircraft_id: number;
        };
    };
    16522: {
        desc: "使用飞行器";
        send: (
            number: 16522,
            fmt: "i",
            args: [
                /**飞行器id*/
                aircraft_id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**飞行器id*/
            aircraft_id: number
        ];
        recv: {
            /** 错误码 */
            errcode: number;
            /** 飞行器id */
            aircraft_id: number;
        };
    };
    16523: {
        desc: "显示/隐藏飞行器";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            errcode: number;
        };
    };
    16530: {
        desc: "打开精灵羽翼";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            errcode: number;
            /** 当前形象id */
            show_id: number;
            /** 是否显示 0否 1是 */
            if_show: number;
            wing_list: {
                /** 翅膀id */
                wing_id: number;
                /** 阶数 */
                stage: number;
                /** 限时结束时间戳 不限时为0 */
                end_time: number;
            }[];
        };
    };
    16531: {
        desc: "精灵羽翼激活/升阶";
        send: (
            number: 16531,
            fmt: "i",
            args: [
                /**翅膀id*/
                wing_id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**翅膀id*/
            wing_id: number
        ];
        recv: {
            /** 错误码 */
            errcode: number;
            /** 翅膀id */
            wing_id: number;
            /** 限时结束时间戳 不限时为0 */
            end_time: number;
        };
    };
    16532: {
        desc: "使用精灵羽翼";
        send: (
            number: 16532,
            fmt: "i",
            args: [
                /**翅膀id*/
                wing_id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**翅膀id*/
            wing_id: number
        ];
        recv: {
            /** 错误码 */
            errcode: number;
            /** 翅膀id */
            wing_id: number;
        };
    };
    16533: {
        desc: "显示/隐藏精灵羽翼";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            errcode: number;
        };
    };
    16534: {
        desc: "通知玩家限时幻形结束";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            errcode: number;
            /** 翅膀id */
            wing_id: number;
        };
    };
    16540: {
        desc: "打开精灵装备";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            errcode: number;
            /** 战力 */
            combat_power: number;
            /** 槽位列表 */
            pet_equip_list: {
                /** 槽位id */
                pos_id: number;
                /** 部位等级 */
                pos_lv: number;
                /** 部位经验 */
                pos_point: number;
                /** 物品唯一id */
                goods_id: number;
                /** 物品类型id */
                goods_type_id: number;
            }[];
        };
    };
    16541: {
        desc: "精灵装备镶嵌";
        send: (
            number: 16541,
            fmt: "cl",
            args: [
                /**槽位id*/
                pos_id: number,
                /**物品唯一id*/
                goods_id: number
            ]
        ) => never;
        sendFmt: "cl";
        sendArgs: [
            /**槽位id*/
            pos_id: number,
            /**物品唯一id*/
            goods_id: number
        ];
        recv: {
            /** 返回码 */
            code: number;
            /** 槽位id */
            pos_id: number;
            /** 穿上的精灵装备物品唯一id */
            new_goods_id: number;
            /** 脱下的精灵装备物品唯一id */
            old_goods_id: number;
            /** 穿上的精灵装备物品类型id */
            new_goods_type_id: number;
        };
    };
    16542: {
        desc: "精灵装备强化";
        send: (
            number: 16542,
            fmt: "lA",
            args: [
                /**物品唯一id*/
                goods_id: number,
                /**消耗列表*/
                cost_list: any
            ]
        ) => never;
        sendFmt: "lA";
        sendArgs: [
            /**物品唯一id*/
            goods_id: number,
            /**消耗列表*/
            cost_list: any
        ];
        recv: {
            /** 返回码 */
            code: number;
            /** 物品唯一id */
            goods_id: number;
        };
    };
    16543: {
        desc: "精灵装备打磨";
        send: (
            number: 16543,
            fmt: "ll",
            args: [
                /**物品唯一id*/
                goods_id: number,
                /**消耗品物品唯一id*/
                cost_goods_id: number
            ]
        ) => never;
        sendFmt: "ll";
        sendArgs: [
            /**物品唯一id*/
            goods_id: number,
            /**消耗品物品唯一id*/
            cost_goods_id: number
        ];
        recv: {
            /** 返回码 */
            code: number;
            /** 物品唯一id */
            goods_id: number;
            /** 消耗品物品唯一id */
            cost_goods_id: number;
        };
    };
}
